/**************************************************************************
 Program:  Equity_Compile_Feature_Data.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  07/18/18
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  
			   
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )
%DCData_lib( Police )
%DCData_lib( Realprop )
%DCData_lib( Vital )

%let _years=2012_16;


%macro Compile_equity_data (geo, geosuf);

data unemployment;
length indicator $30;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "unemployment";
year = "2012-2016";
unemploymentrate = popunemployed_&_years./popincivlaborforce_&_years.;
equityvariable = unemploymentrate;
denom = popincivlaborforce_&_years.;
numerator = popunemployed_&_years.;
run;

data postsecondary;
length indicator $30;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "postsecondary";
year = "2012-2016";
PctCol = pop25andoverwcollege_&_years. / pop25andoveryears_&_years.;
equityvariable = PctCol;
denom = pop25andoverwcollege_&_years.;
numerator = pop25andoveryears_&_years.;
run;

data homeownership;
length indicator $30;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "homeownership";
year = "2012-2016";
Tothousing= numowneroccupiedhsgunits_&_years.+ numrenteroccupiedhu_&_years.;
ownership= numowneroccupiedhsgunits_&_years./ (numowneroccupiedhsgunits_&_years.+ numrenteroccupiedhu_&_years.);
equityvariable = ownership;
denom = Tothousing;
numerator = numowneroccupiedhsgunits_&_years.;
run;

data income75k;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
length indicator $30;
keep indicator year &geo numerator denom equityvariable;
indicator = "Family Income over $75,000";
year = "2012-2016";
famincomemt75k= familyhhtot_&_years.- famincomelt75k_&_years.;
pctmt75K= famincomemt75k/familyhhtot_&_years.;
equityvariable = pctmt75K;
denom = familyhhtot_&_years.;
numerator = famincomemt75k;
run;

data abovepoverty;
length indicator $30;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Persons above federal poverty rate";
year = "2012-2016";
popabovepov= personspovertydefined_&_years. - poppoorpersons_&_years.;
pctabovepov= popabovepov/personspovertydefined_&_years.;
equityvariable = pctabovepov;
denom = poppoorpersons_&_years.;
numerator = personspovertydefined_&_years.;
run;

data earning75k;
length indicator $30;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Persons workers with annual earnings over $75,000";
year = "2012-2016";
pctearningover75K=earningover75k_&_years./popemployedworkers_&_years.;
equityvariable = pctearningover75K;
denom = popemployedworkers_&_years.;
numerator = earningover75k_&_years.;
run;

data childrenabovepoverty;
length indicator $30;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Children above federal poverty level";
year = "2012-2016";
pctchildabovepov = poppoorchildrenunder5_&_years./childpovertyunder5def_&_years.;
equityvariable = pctchildabovepov;
denom = childpovertyunder5def_&_years.;
numerator = poppoorchildrenunder5_&_years.;
run;
/*
data create_flags;
  set realpr_r.sales_res_clean (where=(saleyear = 2017));*/
  
  /*pull in effective interest rates - for example: 
  http://www.fhfa.gov/DataTools/Downloads/Documents/Historical-Summary-Tables/Table15_2015_by_State_and_Year.xls*/
  
/*    eff_int_rate_2017= 3.69; *2017 not available, using 2016;


	month_int_rate= (eff_int_rate_2017/12/100);

	loan_multiplier_2017 =  month_int_rate_2017 *	( ( 1 + month_int_rate_2017 )**360	) / ( ( ( 1+ month_int_rate_2017 )**360 )-1 );

	*calculate monthly Principal and Interest for First time Homebuyer (10% down);
    PI_First_2017=saleprice*.9*loan_multiplier_2017;

   *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for First Time Homebuyer (34% of PI = TI);
    PITI_First=PI_First_2017*1.34;

	total_sales=1;

	if PITI_First in (0,.) then do;

			AMI50_first_afford = .;
			total_sales=0;
	end;

	else do;
			 if PITI_First <= (110300/ 12*.28) then AMI_first_afford=1; else AMI_first_afford=0;

	end;
	
run;

proc summary data=create_flags;
 by wd12;
 var AMI_first_afford total_sales;
 output out=wardafford sum=;
 run;

data wardafford;
set wardafford;
keep indicator year geo AMI_first_afford total_sales adeqprenatal;
indicator = "Percent homes sold at prices affordable at median income";
year = "2017";
pctafford = AMI_first_afford/total_sales;
geo= &geo
run;

 proc summary data=create_flags;
 by cl17;
 var AMI_first_afford total_sales;
 output out=clusterafford sum=;
 run;
 proc summary data=create_flags;
 by city;
 var AMI_first_afford total_sales;
 output out=cityafford sum=;
 run;
*/

data violentcrime;
length indicator $30;
set police.crimes_sum_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Violent Crime Rate per 1000 people";
year = "2017";
violentcrimerate = crimes_pt1_violent_2017/crime_rate_pop_2017;
equityvariable = violentcrimerate;
denom = crime_rate_pop_2017;
numerator = crimes_pt1_violent_2017;
run;

data prenatal;
length indicator $30;
set vital.births_sum_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Births with adequate prenatal care";
year = "2016";
adeqprenatal = births_prenat_adeq_2016/births_w_prenat_2016;
equityvariable = adeqprenatal;
denom = births_w_prenat_2016;
numerator = births_prenat_adeq_2016;
run;

data equity_tabs_&geosuf;
set  unemployment postsecondary homeownership income75k abovepoverty earning75k violentcrime prenatal;
run; 

proc export data=equity_tabs_&geosuf
	outfile="L:\Libraries\Equity\Doc\Equityfeaturetabs_&geosuf..csv"
	dbms=csv replace;
	run;


%mend Compile_equity_data;

%Compile_equity_data (ward2012, wd12);

%Compile_equity_data (cluster2017, cl17);

%Compile_equity_data (city, city);

