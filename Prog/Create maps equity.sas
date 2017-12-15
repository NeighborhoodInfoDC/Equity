/**************************************************************************
 Program:  Create maps equity.sas
 Library:  Equity
 Project:  Racial Equity Profile
 Author:   L. Posey
 Created:  9/18/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Use for equity maps. Creates file for race by tract. 

 Modifications: 

**************************************************************************/
*run for formats;

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCDATA_lib (Equity);
%DCDATA_lib (Census);
%DCDATA_lib (NCDB);
%DCDATA_lib (ACS);

*data by tract prog from L:\Libraries\Equity\Prog\Calculate_assessed_value.sas (%macro acs_precents);

data acs_race (where=(county in("11001","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685")));
  
set acs.Acs_2011_15_dc_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_2011_15 popblacknonhispbridge_2011_15 popasianpinonhispbridge_2011_15
										 PopMultiracialNonHisp_2011_15 popnativeamnonhispbridge_2011_15 popothernonhispbridge_2011_15 pophisp_2011_15 popwithrace_2011_15
										 mpopwhitenonhispbridge_2011_15 mpopblacknonhispbridge_2011_15 mpopasianpinonhispbridge_2011_15
										mPopMultiracialNonHisp_2011_15 mpopnativeamnonhispbr_2011_15 mpopothernonhispbridge_2011_15 mpophisp_2011_15 mpopwithrace_2011_15)
	acs.Acs_2011_15_md_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_2011_15 popblacknonhispbridge_2011_15 popasianpinonhispbridge_2011_15
									PopMultiracialNonHisp_2011_15 popnativeamnonhispbridge_2011_15 popothernonhispbridge_2011_15 pophisp_2011_15 popwithrace_2011_15
									mpopwhitenonhispbridge_2011_15 mpopblacknonhispbridge_2011_15 mpopasianpinonhispbridge_2011_15
									mPopMultiracialNonHisp_2011_15 mpopnativeamnonhispbr_2011_15 mpopothernonhispbridge_2011_15 mpophisp_2011_15 mpopwithrace_2011_15)
	acs.Acs_2011_15_va_sum_tr_tr10 (keep= geo2010 popwhitenonhispbridge_2011_15 popblacknonhispbridge_2011_15 popasianpinonhispbridge_2011_15
									PopMultiracialNonHisp_2011_15 popnativeamnonhispbridge_2011_15 popothernonhispbridge_2011_15 pophisp_2011_15 popwithrace_2011_15
										mpopwhitenonhispbridge_2011_15 mpopblacknonhispbridge_2011_15 mpopasianpinonhispbridge_2011_15
									mPopMultiracialNonHisp_2011_15 mpopnativeamnonhispbr_2011_15 mpopothernonhispbridge_2011_15 mpophisp_2011_15 mpopwithrace_2011_15);

length county $5.;
county = substr(Geo2010,1,5);


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

	if blackrate_2011_15  => 75 then blackratecomp = 1;
	else if 50<= blackrate_2011_15 < 75 then blackratecomp = 2;
	else if blackrate_2011_15 < 50 then blackratecomp = 3;

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
  Data PG_byrace_v2 (keep=geo2010 whiteratecomp blackratecomp tract_comp whiterate_2011_15 blackrate_2011_15 hisprate_2011_15 county);
  set acs_race;
	 where county='24033';
  run;

  Data DC_byrace (keep=geo2010 tract_comp whiteratecomp blackratecomp county);
  set acs_race;
 	 where county='11001';
  run;
proc export data=VA_byrace_v2
	outfile="D:\DCDATA\Libraries\Equity\Prog\FF_byrace_v2.csv"
	dbms=csv replace;
	run;
proc export data=MO_byrace_v2
	outfile="D:\DCDATA\Libraries\Equity\Prog\MO_byrace_v2.csv"
	dbms=csv replace;
	run;
proc export data=PG_byrace_v2
	outfile="D:\DCDATA\Libraries\Equity\Prog\PG_byrace_v2.csv"
	dbms=csv replace;
	run;
  *data by council district;

Data ACS_race_districts_v1;
set acs.acs_2011_15_va_sum_tr_regcd
acs.acs_2011_15_md_sum_tr_regcd
acs.acs_2011_15_dc_sum_tr_wd12;
run;

Data ACS_race_districts (keep = Ward2012 councildist blackrate_2011_15 whiterate_2011_15 hisprate_2011_15 asianpirate_2011_15 councildist) ;
set ACS_race_districts_v1
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

					   format councildist ward2012;

  run;
proc export data=ACS_race_districts 
	outfile="D:\DCDATA\Libraries\Equity\Prog\ACS_race_districts.csv"
	dbms=csv replace;
	run;
  *data by county for regional profile.; 

Data equity.ACS_race_county (where=(county in("11001","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685")));
set acs.acs_2011_15_va_sum_regcnt_regcnt
	acs.acs_2011_15_md_sum_regcnt_regcnt
	acs.acs_2011_15_dc_sum_regcnt_regcnt;

	keep county blackrate: whiterate: hisprate: asianpirate: popwhitenonhispbridge_2011_15 popblacknonhispbridge_2011_15 popasianpinonhispbridge_2011_15
	PopMultiracialNonHisp_2011_15 popnativeamnonhispbridge_2011_15 popothernonhispbridge_2011_15 pophisp_2011_15 popwithrace_2011_15
	mpopwhitenonhispbridge_2011_15 mpopblacknonhispbridge_2011_15 mpopasianpinonhispbridge_2011_15
	mPopMultiracialNonHisp_2011_15 mpopnativeamnonhispbr_2011_15 mpopothernonhispbridge_2011_15 mpophisp_2011_15 mpopwithrace_2011_15;

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
