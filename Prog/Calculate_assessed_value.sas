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
output out=tract_assessed_val sum= (drop=_TYPE_ _FREQ_); 
run;
*	Note: There are 654 parcels with no tract assigned?
	Also, tracts 2.01, 73.01, 62.02 with residential units but no data ;

data tract_assessed_val_change;
set tract_assessed_val;
dollar_change= sum(assess_val16,-assess_val10);
percent_change= 100 + ((dollar_change / assess_val10) * 100);
run;
* 	Write access to Equity data is denied?;

data census_race;
	set *census summary file for tract*;
	if *Non-Hispanic Black*/*totalpop*=>.75 then majblack=1;
		else majblack=0;
	if *Non-Hispanic White*/*totalpop*=>.75 then majwhite=1;
		else majwhite=0;
	if *Hispanic*/*totalpop*=>.75 then majhisp=1;
		else majhisp=0;
	if majhisp=0 and majwhite=0 and majblack=0 then mixedngh=1;
		else mixedngh=0;
	run;
	
data acs_race;
	set *ACS summary file for tract*;
	if *Non-Hispanic Black*/*totalpop*=>.75 then majblack=1;
		else majblack=0;
	if *Non-Hispanic White*/*totalpop*=>.75 then majwhite=1;
		else majwhite=0;
	if *Hispanic*/*totalpop*=>.75 then majhisp=1;
		else majhisp=0;
	if majhisp=0 and majwhite=0 and majblack=0 then mixedngh=1;
		else mixedngh=0;
	run;
	
proc freq data=census_race;
	tables majblack*majwhite*majhisp*mixedngh/list missing;
	run;
	
proc freq data=acs_race;
	tables majblack*majwhite*majhisp*mixedngh/list missing;
	run;
