/**************************************************************************
 Program:  Assessed_value_change.sas
 Library:  Equity
 Project:  Racial Equity Profile
 Author:   K.Abazajian
 Created:  8/30/2016
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  

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
by geo2010; 
var assess_val10 assess_val16; 
output out=tract_assessed_val (drop=_TYPE_ _FREQ_) sum=; 
run;
*	Note: There are 654 parcels with no tract assigned?
	Also, tracts 2.01, 73.01, 62.02 with residential units but no data ;

data tract_assessed_val_change;
set tract_assessed_val;
dollar_change= sum(assess_val16,-assess_val10);
percent_change= 100 + ((dollar_change / assess_val10) * 100);
run;

/*Select tract-based Race Vars*/
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
	whiterate=p5i3/p5i1;
	blackrate=p5i4/p5i1;
	aiomrate=sum(p5i5, p5i6, p5i7, p5i8, p5i9)/p5i1;
	if 	whiterate =>.75 then majwhite_10=1; /*Non-Hispanic White by Total Population*/
		else majwhite_10=0;
	if  blackrate=>.75 then majblack_10=1; /*Non-Hispanic Black*/
		else majblack_10=0;
	if aiomrate=>.75 then majaiom_10=1; /*Non-Hispanic AmIn, Asian, Pacific Islander, Other, Multi*/
		else majaiom_10=0;
	if majwhite_10=0 and majblack_10=0 and majaiom_10=0 then mixedngh_10=1;
		else mixedngh_10 =0;
	run;

proc freq data=census_race;
	tables whiterate*majwhite_10/list missing;
	tables blackrate*majblack_10/list missing;
	tables aiomrate*majaiom_10/list missing;
	tables majblack_10*majwhite_10*majaiom_10*mixedngh_10/list missing;
	run;

data acs_race;
	set acs.acs_2010_14_dc_sum_bg_tr10;
	whiterate=popwhitenonhispbridge_2010_14/popwithrace_2010_14;
	blackrate=popblacknonhispbridge_2010_14/popwithrace_2010_14;
	aiomrate=sum(popasianpinonhispbridge_2010_14, PopMultiracialNonHisp_2010_14, popnativeamnonhispbridge_2010_14, popothernonhispbridge_2010_14)/popwithrace_2010_14;
	if 	whiterate =>.75 then majwhite_14=1; /*Non-Hispanic White by Total Population*/
		else majwhite_14=0;
	if  blackrate=>.75 then majblack_14=1; /*Non-Hispanic Black*/
		else majblack_14=0;
	if  aiomrate=>.75 then majaiom_14=1; /*Non-Hispanic AmIn, Asian, Pacific Islander, Other, Multi*/
		else majaiom_14=0;
	if majwhite_14=0 and majblack_14=0 and majaiom_14=0 then mixedngh_14=1;
		else mixedngh_14 =0;
	run;

proc freq data=acs_race;
	tables whiterate*majwhite_14/list missing;
	tables blackrate*majblack_14/list missing;
	tables aiomrate*majaiom_14/list missing;
	tables majblack_14*majwhite_14*majaiom_14*mixedngh_14/list missing;
	run;

/*Tract 62.02 has no people in it??*/

