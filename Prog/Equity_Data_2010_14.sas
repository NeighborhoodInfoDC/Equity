
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

data Equity.Acs_tables;

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

  	if racwht=2 then racew=1;
		else racew=0;
	if hispan^=0 then raceh=1;
		else raceh=0;
	if racamind=2 then racei=1;
		else racei=0;
	if racblk=2 then raceb=1;
		else raceb=0;
	if racasian=2 or racpacis=2 then racea=1;
		else racea=0;
	if racother=2 then raceo=1;
		else raceo=0;
	if racnum>1 then racem=1;
		else racem=0;
	if race in (3,7,8,9) then raceiom=1;
		else raceiom=0;
	if racei=1 or raceo=1 or racem=1 then raceiom2=1;
		else raceiom2=0;
	if race >2 then raceaiom=1;
		else raceaiom=0;
	if racea=1 or racei=1 or raceo=1 or racem=1 then raceaiom2=1;
		else raceaiom2=0;
	if citizen in (1,2,3,4,5) then foreign=1;
		else foreign=0;

    if 025 =< age <= 64 then age25to64=1;
		else age25to64=0;
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
  		else sevcostburden=0;
    if 30 <= cost_burden < 50 then costburden=1;
		else costburden=0;
 	if 0 <= cost_burden < 30 then nocostburden=1;
		else nocostburden=0;

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
			housing_costs = "Housing Costs";

  /*if is_sfemwkids = 1 then fam_ui=1; **Women-headed household with related children**;
  if is_sngfem = 1 then fam_ui=2; **Women-headed household without related children**;
  if is_smalwkids = 1 then fam_ui=3; **Male-headed household with related children**;
  if is_sngmal = 1 then fam_ui=4; **Male-headed household without related children**;
  if is_mrdwkids = 1 then fam_ui=5; **Married couple with related children**;
  if is_mrdnokid = 1 then fam_ui=6; **Married couple without related children**;
  label fam_ui = "Family type";

  if 170 <= ind <= 290 then ind_ui = 1; **Agriculture, Foresttry, Fishing and Hunting**;
  else if 370 <= ind <= 490 then ind_ui= 2; **Mining**;
  else if 570 <= ind <= 690 then ind_ui= 3; **Utilities**;
  else if ind = 770 then ind_ui= 4; **Construction**;
  else if 1070 <= ind <= 3990 then ind_ui= 5; **Manufacturing**;
  else if 4070 <= ind <= 4590 then ind_ui= 6; **Wholesale Trade**;
  else if 4670 <= ind <= 5790 then ind_ui= 7; **Retail Trade**;
  else if 6070 <= ind <= 6390 then ind_ui= 8; **Transport and Wareshousing**;
  else if 6470 <= ind <= 6780 then ind_ui= 9; **Information and Communications**;
  else if 6870 <= ind <= 7190 then ind_ui= 10; **Finance, Insurance, Real Estate and Rental and Leasing**;
  else if 7270 <= ind <= 7790 then ind_ui= 11; **Professional, Scientific, Management, Administrative Services**;
  else if 7860 <= ind <= 8470 then ind_ui= 12; **Education, Health and Social Services**;
  else if 8560 <= ind <= 8690 then ind_ui= 13; **Arts, Entertainment, Recreation, Accomodation, Food Services**;
  else if 8770 <= ind <= 9290 then ind_ui= 14; **Other Services (Except Public Administration)**;
  else if 9370 <= ind <= 9590 then ind_ui= 15; **Public Administration**;
  else if 9670 <= ind <= 9870 then ind_ui= 16; **Active Duty Military**;
  label ind_ui = "Industry";*/

  /*if age in (000,001,002,003,004,005) then age_ui = 1; **0-5 years old**;
  else if age in (006,007,008,009,010,
				  011,012,013,014,015,
				  016,017) then age_ui = 2; **6-17 years old**;
  else if age in (018,019,020,021,022,
				  023,024,025,026,027,
				  028,029,030,031,032,
                  033,034) then age_ui = 3; **18-34 years old**;
  else if age in (035,036,037,038,039,
				  040,041,042,043,044,
				  045,046,047,048,049,
				  050,051,052,053,054,
				  055,056,057,058,059,
				  060,061,062,063,064) then age_ui = 4; **35-64 years old**;
  else if age in (065,066,067,068,069,	
				  070,071,072,073,074,
				  075,076,077,078,079,
				  080,081,082,083,084,
				  085,086,087,088,089,
                  090,091,092,093) then age_ui = 5; **65 years and older**;
  label age_ui = 'Age';*/

  /*if 000 =< age <= 17 then hage = 1; **0-17 years old**;
  else if 018 =< age <= 24 then hage = 2; **18-24 years old**;
  else if 025 =< age <= 64 then hage = 3; **25-64 years old**;
  else if 065 =< age <= 093 then hage = 4; **65 years and older**;
  label hage = "Age";*/

  /*if age in (000,001,002,003,004,005, 
			 006,007,008,009,010,011) then girlage = 1; **0-11 years old**;
  else if age in (012,013,014,015,016,
				  017) then girlage = 2; **12-17 years old**;
  else if age in (018,019,020,021,022,
				  023,024) then girlage = 3; **18-24 years old**;
  label girlage = 'Age';

  if age >= 25 then womage = 1; **25 years and older**;
  label womage = 'Age';


  if 001 <=poverty <=100 then pov_ui = 1; **At or below poverty**;
  else if 101 <=poverty<=501 then pov_ui =2; **Above poverty**;
  else if poverty = 000 then pov_ui = 3; **N/A**;
  label pov_ui = "Poverty status";

  if pov_ui = 1 then povrate = 1; **At or below poverty**;
  else if pov_ui = 2 or 3 then povrate = 0; **Above poverty or N/A**;
  label povrate = "Poverty rate";

  if 001<= poverty <=500 then povst_ui = 1; **Poverty Status Determined**;
  if poverty = 501 then povst_ui = 2; **Poverty Status Determined**;
  else if poverty in (000) then povst_ui = 0; **No poverty status determined**;

  if 000 <= poverty <= 100 then hpov = 1; **0-100% federal poverty level**;
  else if 101 <= poverty <= 200 then hpov = 2; **101-200% federal poverty level**;
  else if poverty >=201 then hpov = 3; **201%+ federal poverty level**;
  label hpov = "Federal poverty level";

  if rooms = 0 then crowd=.;
  else if numprec / rooms >= 1.01 then crowd = 1; **Household is overcrowded**;
  else if numprec / rooms <= 1.00 then crowd = 0; **Household is NOT overcrowded**;
  label crowd = "Overcrowded rate";

  if cost_burden >= 50 then Affprob = 2; **Serious Affordability problem**;
  else if 30 <= cost_burden < 50 then Affprob = 1; **Affordability problem**;
  else if 0 <= cost_burden < 30 then Affprob = 0; **No affordability problem**;

  if Affprob = 1 then Affrate = 1; **Affordability problem**;
  else if Affprob = 0 then Affrate = 0; **No affordability problem**;
  label Affrate = "Affordability problem rate";

  if cost_burden > 50 then Sevaff = 1; **Severe Affordabilty problem**;
  else if 0 <= cost_burden < 50 then Sevaff = 0; **No severe affordability problem**;

  if Sevaff = 1 then Sevrate = 1; **Severe affordability problem**;
  else if Sevaff = 0 then Sevrate = 0; **No severe affordability problem**;
  label Sevrate = "Severe affordability problem rate";

  if citizen = 0 then forborn = 0; **n/a**;
  else if citizen = 1 then forborn = 1; **Born abroad of American parents**;
  else if citizen = 2 then forborn = 2; **Naturalized citizen**;
  else if citizen = 3 then forborn = 3; **Not a citizen**;
  label forborn = "Citizenship status";

  if educd < 30 then edatt = 0; **Less than 9th grade**;
  else if 30 >= educd <= 61 then edatt = 1; **9th to 12th grade, no diploma**;
  else if educd in (63,64) then edatt = 2; **High school graduation, GED or alternative**;
  else if educd in (65,71) then edatt = 3; **Some college, no degree**;
  else if educd = 81 then edatt = 4; **Associate's degree**;
  else if educd = 101 then edatt = 5; **Bachelor's degree**;
  else if educd in (114,115,116) then edatt = 6; **Graduate or professional degree**;
  label edatt = "Educational attainment";*/

  /*if 500 <= occ <= 593 then occup = 1; **Office and Administrative support**;
  else if 1 <= occ <= 43 then occup = 2; **Management**;
  else if 50 <= occ <= 73 or 80 <= occ <= 95 then occup = 3; **Business and financial operations**;
  else if  470 <= occ <= 496 then occup = 4; **Sales occupations**;
  else if 220 <= occ <= 255 then occup = 5; **Education, training and library**;
  else if 300 <= occ <= 354 then occup = 6; **Healthcare, practitioner, technical**;
  else if 100 <= occ <= 124 then occup = 7; **Computer and mathematical**;
  else if 430 <= occ <= 465 then occup = 8; **Personal care and service**;
  else if 210 <= occ <= 215 then occup = 9; **Food preparation and serving**;
  else if 260 <= occ <= 296 then occup = 10; **Arts, Design, Entertainment, Sports and Media**;
  else if 360 <= occ <= 365 then occup = 11; **Healthcare support**;
  else if 420 <= occ <= 425 then occup = 12; **Building and Grounds cleaning and maintenance**;
  else if 200 <= occ <= 206 then occup = 13; **Community and Social Service**;
  else if 160 <= occ <= 196 then occup = 14; **Life, Physical and Social Science**;
  else if 370 <= occ <= 395 then occup = 15; **Protective service**;
  else if 770 <= occ <= 896 then occup = 16; **Production**;
  else if 900 <= occ <= 975 then occup = 17; **Transportation and material moving**;
  else if 130 <= occ <= 156 then occup = 18; **Architecture and engineering**;
  else if 620 <= occ <= 676 or 680 <= occ <= 694 then occup = 19; **Construction and extraction**;
  else if 700 <= occ <= 762 then occup = 20; **Installation and maintenance and repairs**;
  label occup = "Occupation";

  if bpl = 210 then country = 1; ** Central America**;
  else if bpl = 600 then country = 2; **Africa**;
  else if bpl = 260 then country = 3; **West Indies**;
  else if bpl = 300 then country = 4; **South America**;
  else if bpl = 200 then country = 5; **Mexico**;
  else if bpl = 500 then country = 6; **China**;
  else if bpl = 521 then country = 7; **India**;
  else if bpl = 502 then country = 8; **Korea**;
  else if bpl = 421 then country = 9; **France**;
  else if bpl = 150 then country = 10; **Canada**;
  else if bpl > 150 and bpl <= 950 and 
		  bpl ne 210 and
		  bpl ne 600 and
		  bpl ne 260 and
		  bpl ne 300 and
		  bpl ne 200 and
		  bpl ne 500 and
		  bpl ne 521 and
		  bpl ne 502 and
		  bpl ne 421 and
		  bpl ne 150 then country = 11; **Other**;
  label country = "Country of origin";

  if ownershp = 1 then homeown = 1; **Homeowner**;
  else if ownershp = 2 then homeown = 0; **Renter**;
  label homeown = "Homeownership rate";

  if speakeng in (3,4,5) then speakeng_ui = 1; **Well**;
  else if speakeng = 6 then speakeng_ui = 2; **Not well**;
  else if speakeng = 1 then speakeng_ui = 3; **Not at all**;
  label speakeng_ui = "Ability to speak English";

  if lingisol = 1 then hhling = 0; **not linguistically isolated**;
  else if lingisol = 2 then hhling = 1; **linguistically isolated**;
  label hhling = 'Linguistically isolated rate';

  if vehicles = 9 then hhveh = 0; **no cars**;
  else if 1 <= vehicles <= 6 then hhveh = 1; **has one or more cars**;
  label hhveh = 'Households with 1 or more cars rate';

  numsource = 0;
   if hinsemp = 2 then numsource = numsource + 1;
   if hinspur = 2 then numsource = numsource + 1;
   if hinstri = 2 then numsource = numsource + 1;
   if hinscaid = 2 then numsource = numsource + 1;
   if hinscare = 2 then numsource = numsource + 1;
   if hinsva = 2 then numsource = numsource + 1;
   if hinsihs = 2 then numsource = numsource + 1;

  /*if hinsemp = 2 and numsource = 1 then hcovsource = 1; **Employer or union only**;
  else if hinspur = 2 and numsource = 1 then hcovsource = 2; **Purchased directly only**;
  else if hinscaid = 2 and numsource = 1 then hcovsource = 3; **Medicaid only**;
  else if hinscare = 2 and numsource = 1 then hcovsource = 4; **Medicare only**; 
  else if numsource = 1 and ( hinstri = 2 or hinsva = 2 or hinsihs = 2 ) then hcovsource = 5; **Other public health coverage only (TRICARE, VA, IHS)**;
  else if hinsemp = 2 and hinspur = 2 and numsource = 2 then hcovsource = 6; **Employer or union and purchased directly**;
  else if hinscare = 2 and hinsemp = 2 and numsource = 2 then hcovsource = 7; **Medicare and employer/union**;
  else if hinscaid = 2 and hinscare = 2 and numsource = 2 then hcovsource = 8; **Medicare and Medicaid**;
  else if hcovany = 1 and numsource = 0 then hcovsource = 10; **No health insurance coverage**;
  else if hcovany = 2 and numsource >= 2 then hcovsource = 9; **Other combinations of health coverage**;
  label hcovsource = "Health insurance source";

  if hcovany = 2 then hcovrate = 1; **With health insurance coverage**;
  else if hcovany = 1 then hcovrate = 0; **Without health insurance coverage**;
  label hcovrate = "Health coverage rate";*/

  *revised 10/2/13; 
  *hhtype: 1=MCFamily 2=Male Family 3=Female Family 4=Male Nonfamily Alone 5=Male NF not alone 6=Female alone 7= Female NF not alone;
  
  /*if NUMPREC = 1 then hhtype_new = 0; **Single Adult Households**;
  else if NUMPREC > 1 and  ischild > 0 and hhtype in (1,2,3) then hhtype_new = 1; * family households, with any children**;
  else if hhtype in (1,2,3) then hhtype_new = 2; **Other families**;
  else if hhtype > 3 then hhtype_new = 3; **Non families**;
  else hhtype_new = 4; **All other household structures**; *This was missing so should still be missing; 
  label hhtype_new = "Household types (mutually exclusive)";

	
*revised 10/4/13;
  if hasft = 1 then emp_age = 3; *at least one full-time worker;
  else if haspt = 1 then emp_age = 2; *at least one part-time worker;
  else if haveelderly = 1 and isadult=iselderly then emp_age = 1; *no workers, all adults elderly; 
  else emp_age = 0; *no workers, at least one working age person - may technically be a teen;
  label emp_age = "Household Employment and Age";
/*original code
  if hasft = 1 then emp_age = 3;
  else if haspt = 1 then emp_age = 2;
  else if haveelderly = 0 then emp_age = 1;
  else if haveelderly = 1 then emp_age = 0;
*/

  /*if haveelderly = 1 or hasdis = 1 then elddisor = 1;
  else elddisor = 0;
  label elddisor = "Elderly or Disabled Household Member";

  /*Code to create mortgage if home is sold today*; 
  Assumptions about PMI and Taxes and Insurance come from email exchanges between Pettit and Zhong Yi Tong  - 
http://content.knowledgeplex.org/kp2/cache/documents/22736.pdf

Using 34% of PI for TI (including PMI) for first-time homebuyers and 25% for Repeat Buyers

  *create loan multiplier;  
effective interest rate http://www.fhfa.gov/webfiles/25273/Table15_2012_by_State_and_Year.xls 
  
Maryland	4.66
Virginia	4.63
DC	4.62
Weighted Average (based on sales (rbi data 2011))	4.64*/

  *monthly interest rate;
 /* monthly_int_rate=4.64/12/100; 
  loan_multiplier=monthly_int_rate * ( ( 1 + monthly_int_rate )**360 ) / ( ( ( 1 + monthly_int_rate)**360 ) -1 ); 

if valueH ne 9999999 then PandI_first=VALUEH * .9 * loan_multiplier; *assumes 10% down;
  monthly_payment_first=PandI_first*1.34; 

  if valueH ne 9999999 then  PandI_repeat=VALUEH * .8 *loan_multiplier; *assumes 20% down;
  monthly_payment_repeat=PandI_repeat*1.25; 

  label monthly_int_rate ="Monthly Interest Rate 2011 - Weighted Average by State"
  		loan_multiplier="Loan Multiplier"
		PandI_first="Monthly Principal & Interest for First Time Homebuyer"
		PandI_repeat="Monthly Principal & Interest for Repeat Homebuyer"
		monthly_payment_first="Monthly Payment if Home Sold to First time buyer"
		monthly_payment_repeat="Monthly Payment if Home Sold to Repeat buyer";*/

  run; 

%File_info( data= Equity.Acs_tables, contents=n );
