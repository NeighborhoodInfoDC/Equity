
/**************************************************************************
 Program:  Create Assessed Value 2020.sas 
 Library:  Equity
 Project:  Council Testimony
 Author:   Leah Hendey
 Created:  6/8/2023
 Version:  SAS 9.4
 Environment:  Windows
 
 Description: Based on Calculate_assessed_value.sas which was a program to compare
        DC Assessed Property value for 2010 and 2016 
				for tracts and Wards based on racial composition of tracts.

 Modifications: 

**************************************************************************/

%include "\\sas1\DCDATA\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib (RealProp);
%DCDATA_lib (Equity);
%DCDATA_lib (Census);
%DCDATA_lib (NCDB);
%DCDATA_lib (ACS);

*pull data for SF and condo,  2016 2020; 
/* data y2016_realprop;
set RealPr_l.ownerpt_2016_04 (where=(year=2016 & ui_proptype in ('10','11')));
run;*/
data y2020_realprop (drop=ssl rename=(ssl_new=ssl));
set RealPr_r.parcel_base_ownerpt_2020_05 (where=(ui_proptype in ('10','11')));

length ssl_new $17.; 
ssl_new=ssl;

assess_val20=assess_val;
all=1;
run;



proc means data=y2020_realprop  p99 p1;
var assess_val20;
output out=assessed_val_extreme p99=assess_val20p99 p1=assess_val20p1 ;
run;
data assessed_val_extreme2;
	set assessed_val_extreme;
	all=1;
data assessed_val_cutoff;
	merge y2020_realprop assessed_val_extreme2; 
	by all;
	assess_val20a=.;
	assess_val20a=assess_val20;  

	if assess_val20 < assess_val20p1 then assess_val20a=.;
	if assess_val20 > assess_val20p99 then assess_val20a=.; 

	extreme=.;
	if assess_val20a ~=.  then extreme=0; 
	else if assess_val20a =.  then extreme=1; 



label assess_val20a="Property Assessed Value 2020 extreme obs removed";

run;
proc freq data=assessed_val_cutoff;
tables extreme;
run;
proc sort data=assessed_val_cutoff; by ssl;
proc sort data=realpr_r.parcel_geo out=parcel_geo; by ssl;

data with2020tract;
merge assessed_val_cutoff (in=a) parcel_geo (keep=ssl ward2022 geo2020 geo2010 ward2012);
by ssl; 
if a;
run;
proc sort data=with2020tract; by geo2020;
run;

*For tract level summary;
proc summary data=with2020tract; 
where extreme=0; 
by geo2020; 
var assess_val20a ; 
output out=tract_assessed_val (drop=_type_) sum=; 
run;
*	Note: There are 32 parcels with no tract assigned?
	Also, tracts 2.01, 73.01, 62.02 with residential units but no data ;

data tract_assessed_val_change;
	set tract_assessed_val (rename=(_freq_=NumSFCondo)) ;


	*set to missing if under 10 properties;
	
	 if NumSFCondo < 10 then assess_val20a=.; 	
	 if geo2020 = " " then delete;
	 

/* from old code	
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
;*/

run;

/*Select tract-based Race Vars*/
data census_base (where=(state="11"));

	set ncdb.Ncdb_sum_2020_tr20 (keep=geo2020 PopWithRace: PopBlackNonHispBridge:
PopWhiteNonHispBridge: PopHisp:  PopAsianPINonHispBridge:
PopNativeAmNonHispBridge: PopOtherNonHispBridge:);

length state $2.;

state=substr(geo2020,1,2);


run;

/*Test that all Census race values are collected correctly*/
data census_test;
set census_base;
sumrace=sum(popblacknonhispbridge_2020, popwhitenonhispbridge_2020, popasianpinonhispbridge_2020,
popnativeamnonhispbridge_2020, popothernonhispbridge_2020, pophisp_2020);
run;

data census_race;
	set census_base ;
	whiterate=(PopWhiteNonHispBridge_2020/PopWithRace_2020)*100;
	blackrate=(PopBlackNonHispBridge_2020/PopWithRace_2020)*100;
	hisprate=(PopHisp_2020/PopWithRace_2020)*100;
	aiomrate=(sum(PopAsianPINonHispBridge_2020, PopNativeAMNonHispBridge_2020, PopOtherNonHispBridge_2020)/PopWithRace_2020)*100;
	if 	whiterate =>75 then majwhite_20=1; /*Non-Hispanic White by Total Population*/
		else majwhite_20=0;
	if  blackrate=>75 then majblack_20=1; /*Non-Hispanic Black*/
		else majblack_20=0;
	if  hisprate=>75 then majhisp_20=1;
		else majhisp_20=0;
	if aiomrate=>75 then majaiom_20=1; /*Non-Hispanic AmIn, Asian, Pacific Islander, Other, Multi*/
		else majaiom_20=0;
	if majwhite_20=0 and majblack_20=0 and majhisp_20=0 and majaiom_20=0 then mixedngh_20=1;
		else mixedngh_20 =0;


		tract_comp20=.;
	if majwhite_20=1 then tract_comp20=1;
	if majblack_20=1 then tract_comp20=2;
	if mixedngh_20=1 then tract_comp20=3;
 
	run;

proc freq data=census_race;
	tables whiterate*majwhite_20/list missing;
	tables blackrate*majblack_20/list missing;
	tables hisprate*majhisp_20/list missing;
	tables aiomrate*majaiom_20/list missing;
	tables majblack_20*majwhite_20*majhisp_20*majaiom_20*mixedngh_20/list missing;
	tables tract_comp20;
	run;


	/*old code using ACS/
%let geo=geo2010;
%let _years=2010_14;

/** Macro ACS_Percents- Start Definition **

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

	if 	whiterate_2010_14 =>75 then majwhite_14=1; *Non-Hispanic White by Total Population;
		else if whiterate_2010_14 + whiterate_m_14 =>75 then majwhite_14=1;
		else majwhite_14=0;
	if 	blackrate_2010_14 =>75 then majblack_14=1; *Non-Hispanic black by Total Population;
		else if blackrate_2010_14 + blackrate_m_14 =>75 then majblack_14=1;
		else majblack_14=0;
 	if 	hisprate_2010_14 =>75 then majhisp_14=1; *Hispanic by Total Population;
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

%acs_percents;**/

/*Tract 62.02 has no people in it??*/

/*
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
	*/
data assessedval_race (label="Assessed Value for Single Family Homes and Condos by Tract Racial Composition, 2020");
	merge census_race (keep=geo2020 mixedngh_20 majblack_20 majwhite_20 tract_comp20 PopWithRace_2020) tract_assessed_val_change ;
	by geo2020;

	format geo2020;
	
	label majblack_20="Tract Population in 2020 is at least 75% Black"
	      majwhite_20="Tract Popuation in 2020 is at least 75% White" 
	      mixedngh_20="Tract Population is not 75% white or 75% Black" 
	      NumSFCondo ="Number of Single Family Homes and Condominium Units"
	      tract_comp20="Tract Racial Composition 1=White 2=Black 3=Mixed";
	run;

proc univariate data=assessedval_race;
CLASS tract_comp20;
var assess_val20a;
id geo2020; 
run;
proc freq data=equity.assessedval_race;
tables dollar_change avg_dollar_change percent_change;
run;

/*
proc export data=equity.assessedval_race
	outfile="D:\DCDATA\Libraries\Equity\Prog\assessedval_race.csv"
	dbms=csv replace;
	run;
*/


proc means data=assessedval_race mean n sum ;
where assess_val20a ~=.;
class tract_comp20;
var numsfcondo assess_val20a;
title output for testimoney 6-8-2023;
run;


/*
** Register metadata **;

%Dc_update_meta_file(
      ds_lib=Equity,
      ds_name=assessedval_race,
      creator_process=Calculate_assessed_value.sas,
      restrictions=None,
      revisions=New file.
      )


*output for comms;
data comms_out (Label="Tract Level Assessed Value by Race of Tract for COMM, 2010-16" drop=dollar_change dollar_changeR);
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
