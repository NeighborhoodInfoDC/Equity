/**************************************************************************
 Program:  Create maps equity all years.sas
 Library:  Equity
 Project:  Racial Equity Profile
 Author:   L. Posey
 Created:  9/18/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Use for equity maps. Creates file for race by tract. 

 Modifications: 02/15/2020 LH Update to add &_years. macro var.
				12/22/2020 LH Update for \\sas1\

**************************************************************************/
%include "\\sas1\DCDATA\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCDATA_lib (Equity);
%DCDATA_lib (ACS);

%let _years=2015_19;

*data by tract prog from L:\Libraries\Equity\Prog\Calculate_assessed_value.sas (%macro acs_precents);

data acs_race (where=(county in("11001","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685")));
  
set acs.Acs_&_years._dc_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_&_years. popblacknonhispbridge_&_years. popasianpinonhispbridge_&_years.
										 PopMultiracialNonHisp_&_years. popnativeamnonhispbridge_&_years. popothernonhispbridge_&_years. pophisp_&_years. popwithrace_&_years.
										 mpopwhitenonhispbridge_&_years. mpopblacknonhispbridge_&_years. mpopasianpinonhispbridge_&_years.
										mPopMultiracialNonHisp_&_years. mpopnativeamnonhispbr_&_years. mpopothernonhispbridge_&_years. mpophisp_&_years. mpopwithrace_&_years.)
	acs.Acs_&_years._md_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_&_years. popblacknonhispbridge_&_years. popasianpinonhispbridge_&_years.
									PopMultiracialNonHisp_&_years. popnativeamnonhispbridge_&_years. popothernonhispbridge_&_years. pophisp_&_years. popwithrace_&_years.
									mpopwhitenonhispbridge_&_years. mpopblacknonhispbridge_&_years. mpopasianpinonhispbridge_&_years.
									mPopMultiracialNonHisp_&_years. mpopnativeamnonhispbr_&_years. mpopothernonhispbridge_&_years. mpophisp_&_years. mpopwithrace_&_years.)
	acs.Acs_&_years._va_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_&_years. popblacknonhispbridge_&_years. popasianpinonhispbridge_&_years.
									PopMultiracialNonHisp_&_years. popnativeamnonhispbridge_&_years. popothernonhispbridge_&_years. pophisp_&_years. popwithrace_&_years.
										mpopwhitenonhispbridge_&_years. mpopblacknonhispbridge_&_years. mpopasianpinonhispbridge_&_years.
									mPopMultiracialNonHisp_&_years. mpopnativeamnonhispbr_&_years. mpopothernonhispbridge_&_years. mpophisp_&_years. mpopwithrace_&_years.);

length county $5.;
county = substr(Geo2010,1,5);


	%Pct_calc( var=blackrate, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=whiterate, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=hisprate, label=% Hispanic, num=PopHisp, den=PopWithRace, years=&_years. )
 
    %Moe_prop_a( var=blackrate_m_15, mult=100, num=PopBlackNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopBlackNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=whiterate_m_15, mult=100, num=PopWhiteNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopWhiteNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=hisprate_m_15, mult=100, num=PopHisp_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopHisp_&_years., den_moe=mPopWithRace_&_years. );

	if 	whiterate_&_years. =>75 then majwhite_15=1; /*Non-Hispanic White by Total Population*/
		else if whiterate_&_years. + whiterate_m_15 =>75 then majwhite_15=1;
		else majwhite_15=0;
	if 	blackrate_&_years. =>75 then majblack_15=1; /*Non-Hispanic black by Total Population*/
		else if blackrate_&_years. + blackrate_m_15 =>75 then majblack_15=1;
		else majblack_15=0;
 	if 	hisprate_&_years. =>75 then majhisp_15=1; /*Hispanic by Total Population*/
		else if hisprate_&_years. + hisprate_m_15 =>75 then majhisp_15=1;
		else majhisp_15=0;
	if majwhite_15=0 and majblack_15=0 and majhisp_15=0 then mixedngh_15=1;
		else mixedngh_15 =0;

	tract_comp=.;
	if majwhite_15=1 then tract_comp=1;
	if majblack_15=1 then tract_comp=2;
	if mixedngh_15=1 then tract_comp=3;
 	if majhisp_15=1 then tract_comp=4;

	if whiterate_&_years. => 75 then whiteratecomp = 1;
	else if 50<= whiterate_&_years. < 75 then whiteratecomp = 2;
	else if whiterate_&_years. < 50 then whiteratecomp = 3;

	if blackrate_&_years.  => 75 then blackratecomp = 1;
	else if 50<= blackrate_&_years. < 75 then blackratecomp = 2;
	else if blackrate_&_years. < 50 then blackratecomp = 3;

  run;

  proc freq data=acs_race;
  tables county*blackratecomp tract_comp majwhite_15*tract_comp county*tract_comp;
  run;


    /*use this 9/27/17*/
  Data VA_byrace_v2 (keep=geo2010 whiteratecomp tract_comp county);
  set acs_race;
  
  where county='51059';
  run;
  Data MO_byrace_v2 (keep=geo2010 whiteratecomp tract_comp county);
  set acs_race;
 where county='24031';
  run;
  Data PG_byrace_v2 (keep=geo2010 whiteratecomp blackratecomp tract_comp whiterate_&_years. blackrate_&_years. hisprate_&_years. county);
  set acs_race;
	 where county='24033';
  run;

  Data DC_byrace (keep=geo2010 tract_comp whiteratecomp blackratecomp county);
  set acs_race;
 	 where county='11001';
  run;
proc export data=VA_byrace_v2
	outfile="&_dcdata_default_path.\Equity\Prog\FF_byrace_v2_&_years..csv"
	dbms=csv replace;
	run;
proc export data=MO_byrace_v2
	outfile="&_dcdata_default_path.\Equity\Prog\MO_byrace_v2_&_years..csv"
	dbms=csv replace;
	run;
proc export data=PG_byrace_v2
	outfile="&_dcdata_default_path.\Equity\Prog\PG_byrace_v2_&_years..csv"
	dbms=csv replace;
	run;
  *data by council district;

Data ACS_race_districts_v1;
set acs.acs_&_years._va_sum_tr_regcd
acs.acs_&_years._md_sum_tr_regcd
acs.acs_&_years._dc_sum_tr_wd12;
run;

Data ACS_race_districts_&_years. (keep = Ward2012 councildist blackrate_&_years. whiterate_&_years. hisprate_&_years. asianpirate_&_years. councildist) ;
set ACS_race_districts_v1
(keep= Ward2012 councildist popwhitenonhispbridge_&_years. popblacknonhispbridge_&_years. popasianpinonhispbridge_&_years.
	PopMultiracialNonHisp_&_years. popnativeamnonhispbridge_&_years. popothernonhispbridge_&_years. pophisp_&_years. popwithrace_&_years.
	mpopwhitenonhispbridge_&_years. mpopblacknonhispbridge_&_years. mpopasianpinonhispbridge_&_years.
	mPopMultiracialNonHisp_&_years. mpopnativeamnonhispbr_&_years. mpopothernonhispbridge_&_years. mpophisp_&_years. mpopwithrace_&_years.);

	%Pct_calc( var=blackrate, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=whiterate, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=hisprate, label=% Hispanic, num=PopHisp, den=PopWithRace, years=&_years. )
	%Pct_calc( var=asianpirate, label=% asianpi non-Hispanic, num=PopasianpiNonHispBridge, den=PopWithRace, years=&_years. )
 
    %Moe_prop_a( var=blackrate_m_15, mult=100, num=PopBlackNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopBlackNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=whiterate_m_15, mult=100, num=PopWhiteNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopWhiteNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=asianpirate_m_15, mult=100, num=PopasianpiNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopasianpiNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=hisprate_m_15, mult=100, num=PopHisp_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopHisp_&_years., den_moe=mPopWithRace_&_years. );

					   format councildist ward2012;

  run;
proc export data=ACS_race_districts_&_years.
	outfile="&_dcdata_default_path.\Equity\Prog\ACS_race_districts_&_years..csv"
	dbms=csv replace;
	run;
  *data by county for regional profile.; 

Data ACS_race_county_&_years. (where=(county in("11001","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685")));
set acs.acs_&_years._va_sum_regcnt_regcnt
	acs.acs_&_years._md_sum_regcnt_regcnt
	acs.acs_&_years._dc_sum_regcnt_regcnt;

	keep county blackrate: whiterate: hisprate: asianpirate: popwhitenonhispbridge_&_years. popblacknonhispbridge_&_years. popasianpinonhispbridge_&_years.
	PopMultiracialNonHisp_&_years. popnativeamnonhispbridge_&_years. popothernonhispbridge_&_years. pophisp_&_years. popwithrace_&_years.
	mpopwhitenonhispbridge_&_years. mpopblacknonhispbridge_&_years. mpopasianpinonhispbridge_&_years.
	mPopMultiracialNonHisp_&_years. mpopnativeamnonhispbr_&_years. mpopothernonhispbridge_&_years. mpophisp_&_years. mpopwithrace_&_years.;

	%Pct_calc( var=blackrate, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=whiterate, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=hisprate, label=% Hispanic, num=PopHisp, den=PopWithRace, years=&_years. )
	%Pct_calc( var=asianpirate, label=% asianpi non-Hispanic, num=PopasianpiNonHispBridge, den=PopWithRace, years=&_years. )
 
    %Moe_prop_a( var=blackrate_m_15, mult=100, num=PopBlackNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopBlackNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=whiterate_m_15, mult=100, num=PopWhiteNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopWhiteNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=asianpirate_m_15, mult=100, num=PopasianpiNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopasianpiNonHispBridge_&_years., den_moe=mPopWithRace_&_years. );

    %Moe_prop_a( var=hisprate_m_15, mult=100, num=PopHisp_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopHisp_&_years., den_moe=mPopWithRace_&_years. );


run;
proc export data=ACS_race_county_&_years.
	outfile="&_dcdata_default_path.\Equity\Prog\ACS_race_county_&_years..csv"
	dbms=csv replace;
	run;
