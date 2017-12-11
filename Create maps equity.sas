/**************************************************************************
 Program:  Calculate_assessed_value.sas
 Library:  Equity
 Project:  Racial Equity Profile
 Author:   L. Posey
 Created:  9/18/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Use for equity maps. Creates file for race by track. 

 Modifications: 

**************************************************************************/
*run for formats;

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib (RealProp);
%DCDATA_lib (Equity);
%DCDATA_lib (Census);
%DCDATA_lib (NCDB);
%DCDATA_lib (ACS);

*data by tract prog from L:\Libraries\Equity\Prog\Calculate_assessed_value.sas (%macro acs_precents);
libname tracts "D:\Equity map";

data acs_race;
  
set tracts.Acs_2011_15_dc_sum_tr_tr10 tracts.Acs_2011_15_md_sum_tr_tr10 tracts.Acs_2011_15_va_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_2011_15 popblacknonhispbridge_2011_15 popasianpinonhispbridge_2011_15
	PopMultiracialNonHisp_2011_15 popnativeamnonhispbridge_2011_15 popothernonhispbridge_2011_15 pophisp_2011_15 popwithrace_2011_15
	mpopwhitenonhispbridge_2011_15 mpopblacknonhispbridge_2011_15 mpopasianpinonhispbridge_2011_15
	mPopMultiracialNonHisp_2011_15 mpopnativeamnonhispbr_2011_15 mpopothernonhispbridge_2011_15 mpophisp_2011_15 mpopwithrace_2011_15);

geo = substr(Geo2010,1,1);
if geo=2 then place = "MD";
else if geo=5 then place = "VA";
else place = "DC";

	%Pct_calc( var=blackrate, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=2011_15 )
    %Pct_calc( var=whiterate, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=2011_15 )
    %Pct_calc( var=hisprate, label=% Hispanic, num=PopHisp, den=PopWithRace, years=2011_15 )
 
    %Moe_prop_a( var=blackrate_m_15, mult=100, num=PopBlackNonHispBridge_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopBlackNonHispBridge_2011_15, den_moe=mPopWithRace_2011_15 );

    %Moe_prop_a( var=whiterate_m_15, mult=100, num=PopWhiteNonHispBridge_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopWhiteNonHispBridge_2011_15, den_moe=mPopWithRace_2011_15 );

    %Moe_prop_a( var=hisprate_m_15, mult=100, num=PopHisp_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopHisp_2011_15, den_moe=mPopWithRace_2011_15 );

	if 	whiterate_2011_15 =>75 then majwhite_15=1; /*Non-Hispanic White by Total Population*/
		else if whiterate_2011_15 + whiterate_m_15 =>75 then majwhite_15=1;
		else majwhite_15=0;
	if 	blackrate_2011_15 =>75 then majblack_15=1; /*Non-Hispanic black by Total Population*/
		else if blackrate_2011_15 + blackrate_m_15 =>75 then majblack_15=1;
		else majblack_15=0;
 	if 	hisprate_2011_15 =>75 then majhisp_15=1; /*Hispanic by Total Population*/
		else if hisprate_2011_15 + hisprate_m_15 =>75 then majhisp_15=1;
		else majhisp_15=0;
	if majwhite_15=0 and majblack_15=0 and majhisp_15=0 then mixedngh_15=1;
		else mixedngh_15 =0;

	tract_comp=.;
	if majwhite_15=1 then tract_comp=1;
	if majblack_15=1 then tract_comp=2;
	if mixedngh_15=1 then tract_comp=3;
 	if majhisp_15=1 then tract_comp=4;

	if whiterate_2011_15 => 75 then whiteratecomp = 1;
	else if 50<= whiterate_2011_15 < 75 then whiteratecomp = 2;
	else if whiterate_2011_15 < 50 then whiteratecomp = 3;

  run;

  proc freq data=acs_race;
  tables tract_comp majwhite_15*tract_comp place*tract_comp;
  run;
    /*use this 9/27/17*/
  Data tracts.VA_byrace_v2 (keep=geo2010 whiteratecomp COUNTYFP);
  set acs_race;
  CountyFP=substr(geo2010,3,3);
  where place = "VA";
  if CountyFP ne "059" then delete;
  run;
  Data tracts.MO_byrace_v2 (keep=geo2010 whiteratecomp COUNTYFP);
  set acs_race;
  CountyFP=substr(geo2010,3,3);
  if CountyFP ne "031" then delete;
  run;
  Data tracts.PG_byrace_v2 (keep=geo2010 whiteratecomp COUNTYFP);
  set acs_race;
  CountyFP=substr(geo2010,3,3);
  if CountyFP ne "033" then delete;
  run;

  Data tracts.VA_byrace(keep=geo2010 tract_comp COUNTYFP);
  set acs_race;
  CountyFP=substr(geo2010,3,3);
  where place = "VA";
  if CountyFP ne "059" then delete;
  run;
  Data tracts.DC_byrace (keep=geo2010 tract_comp);
  set acs_race;
  where place = "DC";
  run;
 Data tracts.PG_byrace (keep=geo2010 tract_comp COUNTYFP);
  set acs_race;
  CountyFP=substr(geo2010,3,3);
  where place = "MD";
  if CountyFP ne "033" then delete;
  run;
 Data tracts.MO_byrace (keep=geo2010 tract_comp COUNTYFP);
  set acs_race;
  CountyFP=substr(geo2010,3,3);
  where place = "MD";
  if CountyFP ne "031" then delete;
  run;

  *data by council district;
Libname district "D:\Equity map";

Data district.ACS_race_districts_v1;
set district.acs_2011_15_va_sum_tr_regcd
district.acs_2011_15_md_sum_tr_regcd
district.acs_2011_15_dc_sum_tr_wd12;
run;

Data district.ACS_race_districts (keep = Ward2012 councildist blackrate_2011_15 whiterate_2011_15 hisprate_2011_15 asianpirate_2011_15 regcd) ;
set district.ACS_race_districts_v1
(keep= Ward2012 councildist popwhitenonhispbridge_2011_15 popblacknonhispbridge_2011_15 popasianpinonhispbridge_2011_15
	PopMultiracialNonHisp_2011_15 popnativeamnonhispbridge_2011_15 popothernonhispbridge_2011_15 pophisp_2011_15 popwithrace_2011_15
	mpopwhitenonhispbridge_2011_15 mpopblacknonhispbridge_2011_15 mpopasianpinonhispbridge_2011_15
	mPopMultiracialNonHisp_2011_15 mpopnativeamnonhispbr_2011_15 mpopothernonhispbridge_2011_15 mpophisp_2011_15 mpopwithrace_2011_15);

	%Pct_calc( var=blackrate, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=2011_15 )
    %Pct_calc( var=whiterate, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=2011_15 )
    %Pct_calc( var=hisprate, label=% Hispanic, num=PopHisp, den=PopWithRace, years=2011_15 )
	%Pct_calc( var=asianpirate, label=% asianpi non-Hispanic, num=PopasianpiNonHispBridge, den=PopWithRace, years=2011_15 )
 
    %Moe_prop_a( var=blackrate_m_15, mult=100, num=PopBlackNonHispBridge_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopBlackNonHispBridge_2011_15, den_moe=mPopWithRace_2011_15 );

    %Moe_prop_a( var=whiterate_m_15, mult=100, num=PopWhiteNonHispBridge_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopWhiteNonHispBridge_2011_15, den_moe=mPopWithRace_2011_15 );

    %Moe_prop_a( var=asianpirate_m_15, mult=100, num=PopasianpiNonHispBridge_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopasianpiNonHispBridge_2011_15, den_moe=mPopWithRace_2011_15 );

    %Moe_prop_a( var=hisprate_m_15, mult=100, num=PopHisp_2011_15, den=PopWithRace_2011_15, 
                       num_moe=mPopHisp_2011_15, den_moe=mPopWithRace_2011_15 );


  run;



