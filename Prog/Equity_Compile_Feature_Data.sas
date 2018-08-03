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

%let _years=2012_2016;

/*
data ACSindicator;
set ACS.Acs_2012_16_dc_sum_tr_tr10;
keep popunder25years_2012_16  numrentercostburden_&_years. rentcostburdendenom_&_years. numownercostburden_&_years.
     ownercostburdendenom_&_years. numowneroccupiedhsgunits_&_years. numrenteroccupiedhu_&_years. medfamincm_&_years.
	 familyhhtot_&_years.  famincomelt75k_&_years. personspovertydefined_&_years.  poppoorpersons_&_years.
     popunemployed_&_years. popincivlaborforce_&_years. popemployedworkers_&_years. earningover75k_&_years.
	 popunder25years_&_years. totpop_&_years. famincomemt75k popabovepov ownership unemploymentrate wd12 cl17 city;

     famincomemt75k= familyhhtot_&_years.-famincomelt75k_&_years.;
     popabovepov= personspovertydefined_&_years. - poppoorpersons_&_years.;
	 ownership= numowneroccupiedhsgunits_&_years./(numowneroccupiedhsgunits_&_years.+ numrenteroccupiedhu_&_years.)
	 unemploymentrate = popunemployed_&_years./popincivlaborforce_&_years.

run;
*/

data unemployment;
set ACS.Acs_2012_16_dc_sum_tr_wd12;
keep indicator year wd12  popunemployed_&_years. popincivlaborforce_&_years. unemploymentrate;
indicator = "unemployment";
year = "2012-2016";
unemploymentrate = popunemployed_&_years./popincivlaborforce_&_years.;
run;

data postsecondary;
set ACS.Acs_2012_16_dc_sum_tr_wd12;
keep indicator year wd12 popunder25years_2012_16 
indicator = "postsecondary";
year = "2012-2016";
run;



data homesaleprices;
set realprop.Sales_res_clean;
run;

data create_flags;
  set homesaleprices (where=(saleyear = 2017));
  
  /*pull in effective interest rates - for example: 
  http://www.fhfa.gov/DataTools/Downloads/Documents/Historical-Summary-Tables/Table15_2015_by_State_and_Year.xls*/
  
    eff_int_rate_2017= 3.69; *2017 not available, using 2016;


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

data violentcrime;
set police.Crimes_2017;
keep crimes_pt1_violent_2017 crime_rate_pop_2017 wd12 cl17 city;
run;

data prenatal;
set vital.Births_2017;
keep births_prenat_adeq_2016 births_w_prenat_2016 wd12 cl17 city;
run;

data indicators;
set  ACSindicator wardafford clusterafford cityafford violentcrime prenatal;
run;
