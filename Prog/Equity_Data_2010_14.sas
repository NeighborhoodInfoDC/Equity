
/**************************************************************************
 Program:  Equity_Data_2010_14.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   G. MacDonald
 Created:  04/24/2013
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create data for from 2009-11 3-year ACS IPUMS data for 
 Housing Security 2013 report out to funders.

 Modifications: 07/25/13 LH Pulled Pieces from HsngSec_tables_2009_11 into different programs
 07/22/16 MW Updated for ACS 2010-14, SAS1 Server, and for the Equity library. 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";
%include "L:\Libraries\IPUMS\Prog\Download_ipums_formats.sas";

** Define libraries **;
%DCData_lib( IPUMS );
%DCData_lib( EQUITY );

%include "L:\Libraries\Equity\Prog\Equity_formats_2010_14.sas";

proc freq data=ipums.acs_2010_14_pmsa99;
tables ownershpd/list missing;
run;

proc freq data=ipums.acs_2010_14_pmsa99;
tables racnum race racwht hispan racamind racasian racblk racother racpacis /list missing;
run;

proc freq data=ipums.acs_2010_14_pmsa99;
tables bpl citizen /list missing;
run;

proc freq data=ipums.acs_2010_14_pmsa99;
tables empstat*empstatd /list missing;
run;

***** Data *****;

data pre_tables;
	set Ipums.Acs_2010_14_pmsa99;
	uniquehh = cat(year,datanum,serial);

	if age < 18 then ischild = 1;
	else ischild = 0;
	if age >= 65 then iselderly = 1;
	else iselderly = 0;

	/* Single adult female households */
	if ischild = 0 then isadult = 1;
	else isadult = 0;

	/* Poverty 200% or below */ /***WE NEED TO FIX AT SOME POINT IF USING POV _SHOULD BE HOUSEHOLD NOT FAMILY***/
	if poverty <= 200 and poverty > 0 then ispoor = 1;
	else ispoor = 0;

	/* Disability */
	isdis = 0;
	if diffmob = 2 or diffcare = 2 then isdis = 1;

	array vars {*} diffeye diffhear diffphys diffrem;
	array f_vars {*} f_diffeye f_diffhear f_diffphys f_diffrem;

	do i = 1 to 4;
		if vars{i} = 2 then f_vars{i} = 1;
		else f_vars{i} = 0;
	end;

	if sum(f_diffhear, f_diffeye, f_diffphys, F_diffrem)>=2 then isdis = 1;
	/* End Disability Code */

	if isdis = 1 and iselderly = 1 then elddis = 1;
	else elddis = 0;
	if uhrswork >= 35 then isft = 1; else isft = 0;
	if 0 < uhrswork < 35 then ispt = 1; else ispt = 0;
run;

proc means data = pre_tables noprint nway sum missing;
	var ischild nchild iselderly isdis elddis isft ispt isadult ispoor;
	class uniquehh;
	output out = acs_nchild (drop = _TYPE_ _FREQ_) sum=ischild haveownchild iselderly isdis elddis isft ispt isadult ispoor;
run;

proc sort data = pre_tables; by uniquehh; run;

proc sort data = acs_nchild; by uniquehh; run;

data pre_acs_tables;
	merge pre_tables (drop = ischild iselderly isdis elddis isft ispt isadult ispoor) acs_nchild;
	by uniquehh;
	if haveownchild > 0 then areownchild = 1;
	else areownchild = 0;
	if iselderly > 0 then haveelderly = 1;
	else haveelderly = 0;
	if isdis > 0 then hasdis = 1;
	else hasdis = 0;
	if elddis > 0 then haselddis = 1;
	else haselddis = 0;
	if isft > 0 then hasft = 1; else hasft = 0;
	if ispt > 0 then haspt = 1; else haspt = 0;
	if isadult = 1 then singleadult = 1;
	else singleadult = 0;
	if ispoor > 0 then haspoor = 1;
	else haspoor = 0;
	label haveownchild = "Sum of Number of Own Children in Household - DO NOT USE, not meaningful"
	areownchild = "Household has Parent with Own Children"
	ischild = "Number of Children Present in the Houshold"
	iselderly = "Total Number of Elderly Members in the Household"
	haveelderly = "Household has an Elderly Member"
	isdis = "Total Number of Disabled Members in the Household"
	hasdis = "Household has a Disabled Member"
	elddis = "Total Number of Elderly, Disabled Members in the Household"
	haselddis = "Household has an Elderly, Disabled Member"
	isft = "Total Number of Full Time Workers in the Household"
	hasft = "Household has a Full Time Worker"
	ispt = "Total Number of Part Time Workers in the Household"
	haspt = "Household has a Part Time Worker"
	isadult = "Total Number of Adults in the Household"
	singleadult = "Indicator if the Houshold has only One Adult"
	ispoor = "Total Number of People Living in Poverty (200% or below) in the Household"
	haspoor = "At Least One Person in the Household Living in Poverty (200% or below)"
	;
run;

proc sort data = pre_acs_tables; by serial; run;

proc sort data = ipums.Acs_2010_14_fam_pmsa99 (drop=hhwt gq statefip) out = Acs_2010_14_fam_pmsa99; by serial; run;

data Acs_2010_14;

  merge pre_acs_tables (in=a) Acs_2010_14_fam_pmsa99;
  by serial;
  if a;
  
run;

data Equity.Acs_tables (Label="iPUMS 2010-14 ACS for Racial Equity Profiles");

  set Acs_2010_14;
  where put( upuma, $pumctyb. ) ~= '' 
	/* Single-adult female household living alone */
  	/* and hhtype = 6 
	/* Single-female headed household 
	and (is_sngfem = 1 or is_sfemwkids = 1)
	/* Under 200% Poverty Line
	and poverty <= 200 */
	;

  total = 1;

  ** Create new variables **;

  upuma_label = put( upuma, $pumctyb. );

  if labforce = 2 then inLF = 1;
  else if labforce = 1 then inLF = 0;
  label inLF = "Labor Force Participation Rate";

  /*if gq = 0 then occunit = 0; **vacant housing unit**;
  else occunit = 1; **occupied housing unit**;*/

  	if race=1 and hispan=0 then raceW=1;
		else raceW=.;
	if hispan^=0 then raceH=1;
		else raceH=.;
	if race=3 then raceI=1;
		else raceI=.;
	if race=2 then raceB=1;
		else raceB=.;
	if race in (4,5,6) then raceA=1;
		else raceA=.;
	if race=7 then raceO=1;
		else raceO=.;	
	if race in (8,9) then raceM=1;
		else raceM=.;
	if race in (3,7,8,9) then raceIOM=1;
		else raceIOM=.;
	if race >2 then raceAIOM=1;
		else raceAIOM=.;

	if citizen in (2,3,4,5) then foreign=1;
		else foreign=.;

	if mortgage=1 then ownfreeclear=1; 
		else if mortgage=0 then ownfreeclear=.;
		else ownfreeclear=0;
	if mortgage in (3,4) then ownmortgage=1;
		else if mortgage=0 then ownmortgage=.;
		else ownmortgage=0;

    if 025 =< age <= 64 then age25to64=1;
		else age25to64=.;
	if empstat = 1 then employed=1;
	  	else if empstat = 2 then employed=0;
		else employed=.;

    if age25to64=1 and employed=1 then emp25to64=1;
	  	else if age25to64=1 and employed=0 then emp25to64=0;
		else emp25to64=.;

	if ownershp = 1 then housing_costs = owncost;
  		else if ownershp = 2 then housing_costs = rentgrs;

	if housing_costs = 0 then cost_burden = 0;
	  else if missing ( hhincome ) then cost_burden = .u;
	  else if hhincome > 0 then cost_burden = ( 100 * 12 * housing_costs ) / hhincome;
	  else cost_burden = 100;

    if cost_burden >= 50 then sevcostburden = 1;
  		else sevcostburden=.;
    if cost_burden >=30 then costburden=1;
		else costburden=.;
 	if 0 < cost_burden < 30 then nocostburden=1;
		else nocostburden=.;

	label 	racew = "Race: White-Non Hispanic"
			raceh = "Race: Hispanic"
			racei = "Race: American Indian/Alaskan Native"
			raceb = "Race: Black"
			racea = "Race: Asian/Pacific Islander"
			raceo = "Race: Other Race"
			racem = "Race: Two or More Races"
			raceiom = "Race: American Indian/Alaskan Native, Other, and Two or More"
			raceaiom = "Race: Asian/Pacific Islander, American Indian/Alaskan Native, Other, and Two or More"
			foreign = "Foreign Born"
			age25to64 = "Age: 25 to 64"
			employed = "Employed"
			emp25to64 = "Employed & Aged 25 to 64"
			cost_burden = "Cost Burden"
			sevcostburden = "Severely Cost Burdened"
			costburden = "Cost Burdened"
			nocostburden = "No Cost Burdened"
			housing_costs = "Housing Costs"
			ownmortgage = "Owned with mortgage or loan"
			ownfreeclear="Owned free and clear";

  run; 

%File_info( data= Equity.Acs_tables, contents=n );

/*Quality Control*/

proc freq data=equity.acs_tables;
tables race*hispan*racew*raceh*racei*raceb*racea*raceo*racem*raceiom*raceaiom/list missing;
run;

proc freq data=equity.acs_tables;
tables citizen*foreign/list missing;
tables mortgage*ownfreeclear*ownmortgage/list missing;
tables age25to64*employed*emp25to64/list missing;
tables costburden*sevcostburden*nocostburden/list missing;
run;

proc freq data=equity.acs_tables (where=(city=7230 and age25to64=1));
tables empstat*age25to64*employed*emp25to64/list missing;
weight perwt;
run;

proc freq data=equity.acs_tables(where=(city=7230 and 25<= age<=64));
tables empstat*employed/list missing;
weight perwt;
run;

proc freq data=equity.acs_tables (where=(city=7230 and empstat^=1 and empstat^=2));
tables empstat*age/list missing;
weight perwt;
run;
