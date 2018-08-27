/**************************************************************************
 Program:  Equity_Compile_Feature_Data.sas
 Library:  Equity
 Project:  JPMC DC Equity Tool
 Author:   Yipeng Su
 Created:  07/18/18
 Version:  SAS 9.4
 Environment:  Windows
 Last Edited: 24/8/18 by Yipeng Su
 Description:  Compile data for DC Equity Tool
			   
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )
%DCData_lib( Police )
%DCData_lib( Realprop )
%DCData_lib( Vital )

%let _years=2012_16;
data sales_res_year;
set realprop.sales_res_clean;
saleyear=year(saledate);
run;

proc contents data=sales_res_year;
run;


data create_flags;
  set sales_res_year (where=(saleyear = 2017));
  
  /*pull in effective interest rates - for example: 
  http://www.fhfa.gov/DataTools/Downloads/Documents/Historical-Summary-Tables/Table15_2015_by_State_and_Year.xls*/
  
    eff_int_rate_2017= 3.69; *2017 not available, using 2016;


	month_int_rate_2017 = (eff_int_rate_2017*.01)/12;

	loan_multiplier_2017 =  month_int_rate_2017 *	( ( 1 + month_int_rate_2017 )**360	) / ( ( ( 1+ month_int_rate_2017 )**360 )-1 );

	*calculate monthly Principal and Interest for First time Homebuyer (10% down);
    PI_First_2017=saleprice*.9*loan_multiplier_2017;

   *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for First Time Homebuyer (34% of PI = TI);
    PITI_First=PI_First_2017*1.34;

	total_sales=1;

	if PITI_First in (0,.) then do;

			AMI_first_afford = .;
			total_sales=0;
	end;

	else do;
			 if PITI_First <= (72935/ 12*.28) then AMI_first_afford=1; else AMI_first_afford=0; *DC Median income 2016 ACS;

	end;
	
run;
proc sort data=create_flags;
by Ward2012;
Run;

proc summary data=create_flags;
 by Ward2012;
 var AMI_first_afford total_sales;
 output out=wardafford sum=;
 run;

data afford_wd12;
set wardafford;
keep indicator year ward2012 numerator denom equityvariable;
indicator = "Percent homes sold at prices affordable at median income";
year = "2017";
numerator = AMI_first_afford;
denom = total_sales;
equityvariable = AMI_first_afford/total_sales;
ward2012 = ward2012;
run;

proc sort data=create_flags;
by cluster2017;
Run;
 proc summary data=create_flags;
 by cluster2017;
 var AMI_first_afford total_sales;
 output out=clusterafford sum=;
 run;
data afford_cl17;
set clusterafford;
keep indicator year cluster2017 numerator denom equityvariable;
indicator = "Percent homes sold at prices affordable at median income";
year = "2017";
numerator = AMI_first_afford;
denom = total_sales;
equityvariable = AMI_first_afford/total_sales;
run;

 proc summary data=create_flags;
 by city;
 var AMI_first_afford total_sales;
 output out=cityafford sum=;
 run;
data afford_city;
set cityafford;
keep indicator year city numerator denom equityvariable;
indicator = "Percent homes sold at prices affordable at median income";
year = "2017";
numerator = AMI_first_afford;
denom = total_sales;
equityvariable = AMI_first_afford/total_sales;
geo= city;
run;

%macro Compile_equity_data (geo, geosuf);

data unemployment;
length indicator $80;
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
length indicator $80;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "postsecondary";
year = "2012-2016";
PctCol = pop25andoverwcollege_&_years. / pop25andoveryears_&_years.;
equityvariable = PctCol;
denom = pop25andoveryears_&_years.;
numerator = pop25andoverwcollege_&_years.;
run;

data homeownership;
length indicator $80;
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
length indicator $80;
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
length indicator $80;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Persons above federal poverty level";
year = "2012-2016";
popabovepov= personspovertydefined_&_years. - poppoorpersons_&_years.;
pctabovepov= popabovepov/personspovertydefined_&_years.;
equityvariable = pctabovepov;
denom = personspovertydefined_&_years.;
numerator = popabovepov;
run;

data earning75k;
length indicator $80;
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
length indicator $80;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Children under 18 above federal poverty level";
year = "2012-2016";
pctchildabovepov = poppoorchildren_&_years./childrenpovertydefined_&_years.;
equityvariable = pctchildabovepov;
denom = childrenpovertydefined_&_years.;
numerator = poppoorchildren_&_years.;
run;

data costburden;
length indicator $80;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Households with housing cost burden (paying 30% or higher)";
year = "2012-2016";
pctcostburden = numownercostburden_&_years./rentcostburdendenom_&_years.;
equityvariable = pctcostburden;
denom = rentcostburdendenom_&_years.;
numerator = numownercostburden_&_years.;
run;

data commute;
length indicator $80;
set ACS.Acs_2012_16_dc_sum_tr_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Workers with Travel time to work less than 45 minutes";
year = "2012-2016";
commuteunder40 = numownercostburden_&_years./rentcostburdendenom_&_years.;
equityvariable = commuteunder40;
denom = popemployedworkers_&_years.;
numerator = (popemployedtravel_lt5_&_years. + popemployedtravel_10_14_&_years.+ popemployedtravel_15_19_&_years.+ popemployedtravel_20_24_&_years. + popemployedtravel_25_29_&_years. + popemployedtravel_30_34_&_years. + popemployedtravel_35_39_&_years.);
run;

data violentcrime;
length indicator $80;
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
length indicator $80;
set vital.births_sum_&geosuf;
keep indicator year &geo numerator denom equityvariable;
indicator = "Births with adequate prenatal care";
year = "2016";
adeqprenatal = births_prenat_adeq_2016/births_w_prenat_2016;
equityvariable = adeqprenatal;
denom = births_w_prenat_2016;
numerator = births_prenat_adeq_2016;
run;

data afford;
keep indicator year &geo numerator denom equityvariable;
set afford_&geosuf;
length indicator $80;
run;

data equity_tabs_&geosuf;
retain indicator year &geo numerator denom equityvariable;
set  unemployment postsecondary homeownership income75k abovepoverty costburden commute earning75k violentcrime prenatal afford;
run; 

proc export data=equity_tabs_&geosuf
	outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeaturetabs_&geosuf..csv"
	dbms=csv replace;
	run;

%mend Compile_equity_data;

%Compile_equity_data (ward2012, wd12);

%Compile_equity_data (cluster2017, cl17);

%Compile_equity_data (city, city);


data equity_tabs_cl17_format;
set equity_tabs_cl17;
format cluster2017 $clus17f. ;
run;

proc export data=equity_tabs_cl17_format
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeaturetabs_cl17_format..csv"
dbms=csv replace;
run;
