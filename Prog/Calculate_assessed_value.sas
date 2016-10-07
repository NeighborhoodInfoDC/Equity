/**************************************************************************
 Program:  Calculate_assessed_value.sas
 Library:  Equity
 Project:  Racial Equity Profile
 Author:   K.Abazajian
 Created:  8/30/2016
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Program compares DC Assessed Property value for 2010 and 2016 
				for tracts and Wards based on racial composition of tracts.

 Modifications: 
 08/30/16 MW Added classifications for neighborhood by race.

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib (RealProp);
%DCDATA_lib (Equity);
%DCDATA_lib (Census);
%DCDATA_lib (NCDB);
%DCDATA_lib (ACS);

*pull data for SF and condo, 2010 2016;
data y2010_realprop;
set RealProp.proptax_history(where=(year=2010 & ui_proptype in ('10','11')));
run;
data y2016_realprop (drop=ssl rename=(ssl_new=ssl));
set RealProp.ownerpt_2016_04 (where=(ui_proptype in ('10','11')));

length ssl_new $17.; 
ssl_new=ssl;

run;

*merge 2010 and 2016 data by ssl;
proc sort data=y2010_realprop; by ssl;run;
proc sort data=y2016_realprop; by ssl;run;
data assessed_val (where=( in_both=1));
merge y2010_realprop(in=a keep=ssl assess_val rename=(assess_val=assess_val10a)) 
	y2016_realprop(in=b keep=ssl assess_val rename=(assess_val=assess_val16a))
	realprop.parcel_geo(keep=ssl geo2010);
by ssl;
/*if a=0 and b=1 then in_2016=1;
else if a=1 and b=0 then in_2010=1;*/
if a=1 and b=1 then in_both=1;
label /*in_2016 ="Only in 2016 data" in_2010="Only in 2010 data"*/ in_both="In both years of data";

run; 

proc means data=assessed_val  p99 p1;
var assess_val10a assess_val16a;
output out=assessed_val_extreme p99=assess_val10p99 assess_val16p99 p1=assess_val10p1 assess_val16p1 ;
run;
data assessed_val_extreme2;
	set assessed_val_extreme;
	in_both=1;

run;
data assessed_val_cutoff;
	merge assessed_val assessed_val_extreme2; 
	by in_both;

	assess_val10=.; assess_val16=.;
	assess_val10=assess_val10a; 
	assess_val16=assess_val16a; 

	if assess_val10a < assess_val10p1 then assess_val10=.;
	if assess_val10a > assess_val10p99 then assess_val10=.; 
	if assess_val16a < assess_val16p1 then assess_val16=.;
	if assess_val16a > assess_val16p99 then assess_val16=.; 

	extreme=.;
	if assess_val10 ~=. and assess_val16 ~=. then extreme=0;  *have both years;
	else if assess_val10 =. and assess_val16 =. then extreme=1; *missing both years;
	else if assess_val10 =. or assess_val16 =. then extreme=2; *missing one year;

%dollar_convert(assess_val10, assess_val10r, 2010, 2016);

label assess_val10="Property Assessed Value 2010 extreme obs removed"
	   assess_val16="Property Assessed Value 2016 extreme obs removed"
	   assess_val10r="Property Assessed Value 2010 in $2016 extreme obs removed";

run;

proc sort data=assessed_val_cutoff; by geo2010;
run;
*For tract level summary;
proc summary data=assessed_val_cutoff; 
where extreme=0; 
by geo2010; 
var assess_val10 assess_val16 assess_val10r; 
output out=tract_assessed_val (drop=_type_) sum=; 
run;
*	Note: There are 654 parcels with no tract assigned?
	Also, tracts 2.01, 73.01, 62.02 with residential units but no data ;

data tract_assessed_val_change;
	set tract_assessed_val (rename=(_freq_=NumSFCondo)) ;


	*setting to missing because only 3 properties;

	if geo2010="11001010900" then do; dollar_change=.; avg_dollar_change=.; percent_change=.; assess_val16=.; assess_val10=.; 
		assess_val10r=.;end;
	
		dollar_change= (assess_val16-assess_val10)/1000;
		avg_dollar_change=(assess_val16-assess_val10)/NumSFCondo;
		percent_change= ((assess_val16-assess_val10) / assess_val10) * 100;

		dollar_changeR=(assess_val16-assess_val10r)/1000;
		  avg_dollar_changeR=(assess_val16-assess_val10r)/NumSFCondo;
		  percent_changeR=((assess_val16-assess_val10r)/ assess_val10r) * 100;

		label dollar_change="Nominal Change in Assessed Value, Single Family Homes and Condos ($000), 2010-16"
			  avg_dollar_change="Avg. Nominal Change in Assessed Value, Single Family Homes and Condos, 2010-16"
			  percent_change="Pct. Change in Nominal Assessed Value, Single Family Homes and Condos, 2010-16"
	 			dollar_changeR="Real Change in Assessed Value, Single Family Homes and Condos ($000) $2016, 2010-16"
			  avg_dollar_changeR="Avg. Real Change in Assessed Value, Single Family Homes and Condos $2016, 2010-16"
			  percent_changeR="Pct. Change in Real Assessed Value, Single Family Homes and Condos $2016, 2010-16"
;

run;

/*Select tract-based Race Vars*/

proc sort data=ncdb.Ncdb_sum_2010_tr10 (keep=geo2010 PopWithRace: PopBlackNonHispBridge:
PopWhiteNonHispBridge: PopHisp:  PopAsianPINonHispBridge:
PopNativeAmNonHispBridge: PopOtherNonHispBridge:)
out=census_base;
by geo2010;
run;

/*Test that all Census race values are collected correctly*/
data census_test;
set census_base;
sumrace=sum(popblacknonhispbridge_2010, popwhitenonhispbridge_2010, popasianpinonhispbridge_2010,
popnativeamnonhispbridge_2010, popothernonhispbridge_2010, pophisp_2010);
run;

data census_race;
	set census_base;
	whiterate=(PopWhiteNonHispBridge_2010/PopWithRace_2010)*100;
	blackrate=(PopBlackNonHispBridge_2010/PopWithRace_2010)*100;
	hisprate=(PopHisp_2010/PopWithRace_2010)*100;
	aiomrate=(sum(PopAsianPINonHispBridge_2010, PopNativeAMNonHispBridge_2010, PopOtherNonHispBridge_2010)/PopWithRace_2010)*100;
	if 	whiterate =>75 then majwhite_10=1; /*Non-Hispanic White by Total Population*/
		else majwhite_10=0;
	if  blackrate=>75 then majblack_10=1; /*Non-Hispanic Black*/
		else majblack_10=0;
	if  hisprate=>75 then majhisp_10=1;
		else majhisp_10=0;
	if aiomrate=>75 then majaiom_10=1; /*Non-Hispanic AmIn, Asian, Pacific Islander, Other, Multi*/
		else majaiom_10=0;
	if majwhite_10=0 and majblack_10=0 and majhisp_10=0 and majaiom_10=0 then mixedngh_10=1;
		else mixedngh_10 =0;
	run;

proc freq data=census_race;
	tables whiterate*majwhite_10/list missing;
	tables blackrate*majblack_10/list missing;
	tables hisprate*majhisp_10/list missing;
	tables aiomrate*majaiom_10/list missing;
	tables majblack_10*majwhite_10*majhisp_10*majaiom_10*mixedngh_10/list missing;
	run;

%let geo=geo2010;
%let _years=2010_14;

/** Macro ACS_Percents- Start Definition **/

%macro acs_percents;

    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  
  data acs_race; 
  
    set acs.acs_2010_14_dc_sum_bg_tr10 (keep= geo2010 popwhitenonhispbridge_2010_14 popblacknonhispbridge_2010_14 popasianpinonhispbridge_2010_14
	PopMultiracialNonHisp_2010_14 popnativeamnonhispbridge_2010_14 popothernonhispbridge_2010_14 pophisp_2010_14 popwithrace_2010_14
	mpopwhitenonhispbridge_2010_14 mpopblacknonhispbridge_2010_14 mpopasianpinonhispbridge_2010_14
	mPopMultiracialNonHisp_2010_14 mpopnativeamnonhispbr_2010_14 mpopothernonhispbridge_2010_14 mpophisp_2010_14 mpopwithrace_2010_14);

	%Pct_calc( var=blackrate, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=whiterate, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=hisprate, label=% Hispanic, num=PopHisp, den=PopWithRace, years=2010_14 )
 
    %Moe_prop_a( var=blackrate_m_14, mult=100, num=PopBlackNonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopBlackNonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

    %Moe_prop_a( var=whiterate_m_14, mult=100, num=PopWhiteNonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopWhiteNonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

    %Moe_prop_a( var=hisprate_m_14, mult=100, num=PopHisp_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopHisp_2010_14, den_moe=mPopWithRace_2010_14 );

	if 	whiterate_2010_14 =>75 then majwhite_14=1; /*Non-Hispanic White by Total Population*/
		else if whiterate_2010_14 + whiterate_m_14 =>75 then majwhite_14=1;
		else majwhite_14=0;
	if 	blackrate_2010_14 =>75 then majblack_14=1; /*Non-Hispanic black by Total Population*/
		else if blackrate_2010_14 + blackrate_m_14 =>75 then majblack_14=1;
		else majblack_14=0;
 	if 	hisprate_2010_14 =>75 then majhisp_14=1; /*Hispanic by Total Population*/
		else if hisprate_2010_14 + hisprate_m_14 =>75 then majhisp_14=1;
		else majhisp_14=0;
	if majwhite_14=0 and majblack_14=0 and majhisp_14=0 then mixedngh_14=1;
		else mixedngh_14 =0;

	tract_comp=.;
	if majwhite_14=1 then tract_comp=1;
	if majblack_14=1 then tract_comp=2;
	if mixedngh_14=1 then tract_comp=3;
 
  run;

  proc freq data=acs_race;
  tables tract_comp majwhite_14*tract_comp;
  run;
    
  %File_info( data=acs_race, printobs=0, contents=n )
  
%mend acs_percents;

%acs_percents;

/*Tract 62.02 has no people in it??*/


data racecomp;
	merge acs_race (keep=geo2010 whiterate_2010_14 whiterate_m_14 blackrate_2010_14 blackrate_m_14 majwhite_14 majblack_14 mixedngh_14 tract_comp) census_race (keep= geo2010 whiterate blackrate majwhite_10 majblack_10 mixedngh_10);
	by geo2010;
	majblack=majblack_14;
	majwhite=majwhite_14;
	mixedngh=mixedngh_14;
run;

  proc freq data=racecomp;
  tables tract_comp majwhite*tract_comp;
  run;
data equity.assessedval_race (label="Assessed Value for Single Family Homes and Condos by Tract Racial Composition");
	merge racecomp (keep=geo2010 mixedngh majblack majwhite tract_comp) tract_assessed_val_change ;
	by geo2010;

	format geo2010;
	
	label majblack="Tract Population in 2010-14 is at least 75% Black"
	      majwhite="Tract Popuation in 2010-14 is at least 75% White" 
	      mixedngh="Tract Population is not 75% white or 75% Black" 
	      NumSFCondo ="Number of Single Family Homes and Condominium Units"
	      tract_comp="Tract Racial Composition 1=White 2=Black 3=Mixed";
	run;

proc univariate data=equity.assessedval_race;
CLASS tract_comp;
var dollar_changeR avg_dollar_changeR percent_changeR;
id geo2010; 
run;
proc freq data=equity.assessedval_race;
tables dollar_change avg_dollar_change percent_change;
run;

proc export data=equity.assessedval_race
	outfile="D:\DCDATA\Libraries\Equity\Prog\assessedval_race.csv"
	dbms=csv replace;
	run;

proc means data=equity.assessedval_race mean n sum ;
class tract_comp;
var numsfcondo assess_val16 assess_val10r;
run;

*output for comms;
data comms_out (Label="Tract Level Assessed Value by Race of Tract for COMM" drop=dollar_change dollar_changeR);
	set equity.assessedval_race;

percent_change_dec=percent_change/100; 
percent_changeR_dec=percent_changeR/100; 
dollar_change_new=dollar_change*1000;
dollar_changeR_new=dollar_changeR*1000; 

label 
			  percent_change_dec="Pct. Change in Nominal Assessed Value, Single Family Homes and Condos, 2010-16 (decimal)"
			  percent_changeR_dec="Pct. Change in Real Assessed Value, Single Family Homes and Condos $2016, 2010-16 (decimal)"
dollar_change_new="Nominal Change in Assessed Value, Single Family Homes and Condos, 2010-16"
	dollar_changeR_new="Real Change in Assessed Value, Single Family Homes and Condos $2016, 2010-16";


run; 

proc contents data=comms_out; 
run;
proc export data=comms_out
	outfile="D:\DCDATA\Libraries\Equity\Prog\assessedval_tractrace_comm.csv"
	dbms=csv replace;
	run;
