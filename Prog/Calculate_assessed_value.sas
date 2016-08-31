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
%DCDATA_lib (ACS);

*pull data for SF and condo, 2010 2016;
data y2010_realprop;
set RealProp.proptax_history(where=(year=2010 & ui_proptype in ('10','11')));
run;
data y2016_realprop;
set RealProp.ownerpt_2016_04 (where=(ui_proptype in ('10','11')));
run;

*merge 2010 and 2016 data by ssl;
proc sort data=y2010_realprop; by ssl;run;
proc sort data=y2016_realprop; by ssl;run;
data assessed_val;
merge y2010_realprop(in=a keep=ssl assess_val rename=(assess_val=assess_val10)) 
	y2016_realprop(in=b keep=ssl assess_val rename=(assess_val=assess_val16))
	realprop.parcel_geo(keep=ssl geo2010);
by ssl;
if a=0 and b=1 then in_2016=1;
else if a=1 and b=0 then in_2010=1;
else if a=1 and b=1 then in_both=1;
label in_2016 ="Only in 2016 data" in_2010="Only in 2010 data" in_both="In both years of data";
run;
*For count of units in each;
proc summary data=assessed_val print sum; var in_2016 in_2010 in_both;
output out=Merge_results;
run;
proc sort data=assessed_val; by geo2010;
run;
*For tract level summary;
proc summary data=assessed_val; 
where in_both=1; 
by geo2010; 
var assess_val10 assess_val16; 
output out=tract_assessed_val (drop=_type_) sum=; 
run;
*	Note: There are 654 parcels with no tract assigned?
	Also, tracts 2.01, 73.01, 62.02 with residential units but no data ;

data tract_assessed_val_change;
set tract_assessed_val (rename=(_freq_=NumSFCondo));
dollar_change= sum(assess_val16,-assess_val10);
avg_dollar_change=dollar_change/NumSFCondo;
percent_change= ((dollar_change / assess_val10) * 100);
run;

/*Select tract-based Race Vars*/
/*Maia - can you adapt this instead so we aren't creating from scratch??

Ncdb.Ncdb_sum_2010&geosuf
        (keep=&geo
          PopWithRace: PopBlackNonHispBridge:
           PopWhiteNonHispBridge: PopHisp: PopAsianPINonHispBridge:
           PopOtherRaceNonHispBridge: 
            )
L:\Metadata\meta_ncdb_ncdb_sum_2010_tr10.html */

proc sort data=census.census_sf1_2010_dc_ph (where=(geo2010^=" ") keep=geo2010 p5i1 p5i3 p5i4 p5i5 p5i6 p5i7 p5i8 p5i9 p5i10)
out=census_base;
by geo2010;
run;

/*Test that all Census race values are collected correctly*/
data census_test;
set census_base;
sumrace=sum(p5i3, p5i4, p5i5, p5i6, p5i7, p5i8, p5i9, p5i10);
run;

data census_race;
	set census_base;
	whiterate=(p5i3/p5i1)*100;
	blackrate=(p5i4/p5i1)*100;
	hisprate=(p5i10/p5i1)*100;
	aiomrate=(sum(p5i5, p5i6, p5i7, p5i8, p5i9)/p5i1)*100;
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

/*****************did you copy somala's code? in Equity_Compile_ACS_for_profile.sas? - double check that it matches please*/ 

%macro acs_percents;

    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  
  data acs_race; 
  
    set acs.acs_2010_14_dc_sum_bg_tr10 (keep= geo2010 popwhitenonhispbridge_2010_14 popblacknonhispbridge_2010_14 popasianpinonhispbridge_2010_14
	PopMultiracialNonHisp_2010_14 popnativeamnonhispbridge_2010_14 popothernonhispbridge_2010_14 pophisp_2010_14 popwithrace_2010_14
	mpopwhitenonhispbridge_2010_14 mpopblacknonhispbridge_2010_14 mpopasianpinonhispbridge_2010_14
	mPopMultiracialNonHisp_2010_14 mpopnativeamnonhispbr_2010_14 mpopothernonhispbridge_2010_14 mpophisp_2010_14 mpopwithrace_2010_14);

	%Pct_calc( var=whiterate, label=% White, num=popwhitenonhispbridge, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=whiterate_m_14, mult=100, num=popwhitenonhispbridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopWhiteNonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=blackrate, label=% Black, num=popblacknonhispbridge, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=blackrate_m_14, mult=100, num=popblacknonhispbridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopBlackNonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=hisprate, label=% hisp, num=pophisp, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=hisprate_m_14, mult=100, num=pophisp_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPophisp_2010_14, den_moe=mPopWithRace_2010_14 );

	if 	whiterate_2010_14 =>75 then majwhite_14=1; /*Non-Hispanic White by Total Population*/
		else majwhite_14=0;
	if 	blackrate_2010_14 =>75 then majblack_14=1; /*Non-Hispanic black by Total Population*/
		else majblack_14=0;
 	if 	hisprate_2010_14 =>75 then majhisp_14=1; /*Hispanic by Total Population*/
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

/*ideally this is done by creating whiteupperbound=white estimate + white MOE;  */
data racecomp;
	merge acs_race (keep=geo2010 whiterate_2010_14 whiterate_m_14 blackrate_2010_14 blackrate_m_14 majwhite_14 majblack_14 mixedngh_14 tract_comp) census_race (keep= geo2010 whiterate blackrate majwhite_10 majblack_10 mixedngh_10);
	by geo2010;
	majblack=majblack_14;
	majwhite=majwhite_14;
	mixedngh=mixedngh_14;
	manualfix=0;
	if geo2010 in ("11001000400", "11001000802", "11001010800", "11001002102", "11001003400") then do;
		mixedngh=1; 
		majblack=0;
		majwhite=0;
		manualfix=1;
		tract_comp=3;
		end;
	if geo2010 in ("11001000501", "11001000702", "11001000901", "11001001301", "11001004002", "11001008301") then do;
		mixedngh=0;
		majblack=0;
		majwhite=1;
		manualfix=1;
		tract_comp=1;
		end;
	if geo2010 in ("11001001901", "11001001902", "11001002201", "11001008701", "11001009204") then do;
		mixedngh=0;
		majblack=1;
		majwhite=0;
		manualfix=1;
		tract_comp=2;
		end;
run;
  proc freq data=racecomp;
  tables tract_comp majwhite*tract_comp;
  run;
data valueshift;
	merge racecomp (keep=geo2010 mixedngh majblack majwhite tract_comp) tract_assessed_val_change ;
	by geo2010;
	run;

proc univariate data=valueshift;
CLASS tract_comp;
var dollar_change avg_dollar_change percent_change;

run;
