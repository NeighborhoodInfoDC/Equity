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
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo  popunemployed_&_years. popincivlaborforce_&_years. unemploymentrate;
indicator = "unemployment";
year = "2012-2016";
unemploymentrate = popunemployed_&_years./popincivlaborforce_&_years.;
run;

data postsecondary;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo pop25andoverwcollege_&_years. pop25andoveryears_&_years. PctCol;
indicator = "postsecondary";
year = "2012-2016";
PctCol = pop25andoverwcollege_&_years. / pop25andoveryears_&_years.;
run;

data homeownership;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numowneroccupiedhsgunits_&_years. Tothousing ownership;
indicator = "homeownership";
year = "2012-2016";
Tothousing= numowneroccupiedhsgunits_&_years.+ numrenteroccupiedhu_&_years.;
ownership= numowneroccupiedhsgunits_&_years./ Tothousing;
run;

data income75k;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo famincomemt75k familyhhtot_&_years. pctmt75K;
indicator = "Family Income over $75,000";
year = "2012-2016";
famincomemt75k= familyhhtot_&_years.- famincomelt75k_&_years.;
pctmt75K= famincomemt75k/familyhhtot_&_years.;
run;

data abovepoverty;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo personspovertydefined_&_years. poppoorpersons_&_years. pctabovepov;
indicator = "Persons above federal poverty rate";
year = "2012-2016";
popabovepov= personspovertydefined_&_years. - poppoorpersons_&_years.;
pctabovepov= popabovepov/personspovertydefined_&_years.;
run;

data earning75k;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo earningover75k_&_years. popemployedworkers_&_years. pctearningover75K;
indicator = "Persons workers with annual earnings over $75,000";
year = "2012-2016";
pctearningover75K=earningover75k_&_years./popemployedworkers_&_years.;
run;

data childrenabovepoverty;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo poppoorchildrenunder5_&_years. childpovertyunder5def_&_years. pctchildabovepov;
indicator = "Children above federal poverty level";
year = "2012-2016";
pctchildabovepov = poppoorchildrenunder5_&_years./childpovertyunder5def_&_years.;
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
set police.crimes_sum_&geosuf;
keep indicator year &geo crimes_pt1_violent_2017 crime_rate_pop_2017 violentcrimerate;
indicator = "Violent Crime Rate per 1000 people";
year = "2017";
violentcrimerate = crimes_pt1_violent_2017/crime_rate_pop_2017;
run;

data prenatal;
set vital.births_sum_&geosuf;
keep indicator year &geo births_prenat_adeq_2016 births_w_prenat_2016 adeqprenatal;
indicator = "Births with adequate prenatal care";
year = "2016";
adeqprenatal = births_prenat_adeq_2016/births_w_prenat_2016;
run;

data indicators;
set  unemployment postsecondary homeownership income75k abovepoverty earning75k violentcrime prenatal;
run; 

proc export data=stanc_tabs_&geosuf
	outfile="L:\Libraries\Equity\Doc\Equityfeaturetabs_&geosuf..csv"
	dbms=csv replace;
	run;


%mend Compile_equity_data;

%Compile_equity_data (ward2012, wd12);

%Compile_equity_data (cluster2017, cl17);

%Compile_equity_data (city, city);

