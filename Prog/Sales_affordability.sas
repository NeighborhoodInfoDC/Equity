/**************************************************************************
 Program:  Sales_Affordability.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   M. Woluchem	
 Created:  8/12/16
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description: *Methodology for affordability adapted from Zhong Yi Tong paper 
http://content.knowledgeplex.org/kp2/cache/documents/22736.pdf
Homeownership Affordability in Urban America: Past and Future;

 Modifications: 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";


** Define libraries **;
%DCData_lib( realprop );
%DCData_lib( equity );

data create_flags;
  set realpr_r.sales_master (where=(ui_proptype in ('10' '11') and 2010 <= year(saledate) <= 2014))
/*add code for saledate [between 1/1/10 and 12/31/14]*/;
  
  /*pull in effective interest rates - for example: 
  http://www.fhfa.gov/DataTools/Downloads/Documents/Historical-Summary-Tables/Table15_2015_by_State_and_Year.xls*/
  
  *create sale_yr from saledate(?- check var name); 

	sale_yr = year(saledate);
  
	eff_int_rate_2010= 4.93;
	eff_int_rate_2011= 4.62;
	eff_int_rate_2012= 3.72;
	eff_int_rate_2013= 3.95;
	eff_int_rate_2014= 4.22;

		month_int_rate_2010 = (eff_int_rate_2010/12/100);
		month_int_rate_2011 = (eff_int_rate_2011/12/100); 
		month_int_rate_2012 = (eff_int_rate_2012/12/100); 
		month_int_rate_2013 = (eff_int_rate_2013/12/100); 
		month_int_rate_2014 = (eff_int_rate_2014/12/100); 
		
	loan_multiplier_2010 =  month_int_rate_2010 *	( ( 1 + month_int_rate_2010 )**360	) / ( ( ( 1+ month_int_rate_2010 )**360 )-1 );
  	loan_multiplier_2011 =  month_int_rate_2011 *	( ( 1 + month_int_rate_2011 )**360	) / ( ( ( 1+ month_int_rate_2011 )**360 )-1 );
  	loan_multiplier_2012 =  month_int_rate_2012 *	( ( 1 + month_int_rate_2012 )**360	) / ( ( ( 1+ month_int_rate_2012 )**360 )-1 );
  	loan_multiplier_2013 =  month_int_rate_2013 *	( ( 1 + month_int_rate_2013 )**360	) / ( ( ( 1+ month_int_rate_2013 )**360 )-1 );
  	loan_multiplier_2014 =  month_int_rate_2014 *	( ( 1 + month_int_rate_2014 )**360	) / ( ( ( 1+ month_int_rate_2014 )**360 )-1 );

  *calculate monthly Principal and Interest for First time Homebuyer (10% down);
    if sale_yr=2010 then PI_First=saleprice*.9*loan_multiplier_2010;
	if sale_yr=2011 then PI_First=saleprice*.9*loan_multiplier_2011;
	if sale_yr=2012 then PI_First=saleprice*.9*loan_multiplier_2012;
	if sale_yr=2013 then PI_First=saleprice*.9*loan_multiplier_2013;
	if sale_yr=2014 then PI_First=saleprice*.9*loan_multiplier_2014;
 
  *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for First Time Homebuyer (34% of PI = TI);
  /*no need to repeat for each year - we'll just lump all 5 together*/
    PITI_First=PI_First*1.34;
  *calculate monthly Principal and Interest for Repeat Homebuyer (20% down);
    if sale_yr=2010 then PI_Repeat=saleprice*.8*loan_multiplier_2010;
	if sale_yr=2011 then PI_Repeat=saleprice*.8*loan_multiplier_2011;
	if sale_yr=2012 then PI_Repeat=saleprice*.8*loan_multiplier_2012;
	if sale_yr=2013 then PI_Repeat=saleprice*.8*loan_multiplier_2013;
	if sale_yr=2014 then PI_Repeat=saleprice*.8*loan_multiplier_2014;
  **repeat for each year;
  *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for Repeat Homebuyer (25% of PI = TI);
    PITI_Repeat=PI_Repeat*1.25;

	if PITI_First <= (112951.00 / 12) then white_first_afford=1; else white_first_afford=0; 
		if PITI_Repeat <= (112951.00 / 12) then white_repeat_afford=1; else white_repeat_afford=0; 
	if PITI_First <= (40214.00 / 12) then black_first_afford=1; else black_first_afford=0; 
		if PITI_Repeat <= (40214.00 / 12) then black_repeat_afford=1; else black_repeat_afford=0; 
	if PITI_First <= (58949.00 / 12) then hispanic_first_afford=1; else hispanic_first_afford=0; 
		if PITI_Repeat <= (58949.00 / 12) then hispanic_repeat_afford=1; else hispanic_repeat_afford=0; 
	if PITI_First <= (63160.00 / 12) then aiom_first_afford=1; else aiom_first_afford=0; 
		if PITI_Repeat <= (63160.00 / 12) then aiom_repeat_afford=1; else aiom_repeat_afford=0; 

	label 	PITI_First = "Principal, Interest, Tax and Insurance for FT Homebuyer"
			PITI_Repeat = "Principal, Interest, Tax and Insurance for Repeat Homebuyer"
			white_first_afford = "Property Sale is Affordable for FT White Owners"
			black_first_afford = "Property Sale is Affordable for FT Black Owners"
			hispanic_first_afford = "Property Sale is Affordable for FT Hispanic Owners"
			AIOM_first_afford = "Property Sale is Affordable for FT Owners of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races"
			white_repeat_afford = "Property Sale is Affordable for Repeat White Owners"
			black_repeat_afford = "Property Sale is Affordable for Repeat Black Owners"
			hispanic_repeat_afford = "Property Sale is Affordable for Repeat Hispanic Owners"
			AIOM_repeat_afford = "Property Sale is Affordable for Repeat Owners of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races"
;
run;
		
*proc summary at city, ward, tract, and cluster levels - so you could get % of sales in Ward 7 affordable to 
median white family vs. median black family.;

*get median family income by race from ACS for 2010-2014 and create race-based flags for each sale; 

/*Retrieve HH Income by Race*/

proc means data=equity.acs_tables (where=(pernum=1 and raceW=1 and city=7230)) median mean;
	class race;
	vars hhincome;
	weight hhwt;
	TITLE "NH White Median HH Income";
run;

proc means data=equity.acs_tables (where=(pernum=1 and raceH=1 and city=7230)) median mean;
	vars hhincome;
	weight hhwt;
	TITLE "Hispanic Median HH Income";
run;

proc means data=equity.acs_tables (where=(pernum=1 and raceB=1 and city=7230)) median mean;
	class race;
	vars hhincome;
	weight hhwt;
	TITLE "Black Median HH Income";
run;

proc means data=equity.acs_tables (where=(pernum=1 and raceAIOM=1 and city=7230)) median mean;
	vars hhincome;
	weight hhwt;
	TITLE "AIOM Median HH Income";
run;

/*Proc Summary: Affordability for Owners by Race*/

proc summary data=create_flags;
	class city;
	var white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output
		out=City_level (where=(_type_^=0))
	sum= wfa_sum wra_sum bfa_sum bra_sum hfa_sum hra_sum afa_sum ara_sum
	mean= wfa_mean wra_mean bfa_mean bra_mean hfa_mean hra_mean afa_mean ara_mean;
	format city $CITY16.;
	label 
		wfa_sum = "Sum Affordable: NW Hispanic FT Owners"
		wra_sum = "Sum Affordable: NW Hispanic Repeat Owners"
		bfa_sum = "Sum Affordable: Black FT Owners"
		bra_sum = "Sum Affordable: Black Repeat Owners"
		hfa_sum = "Sum Affordable: Hispanic FT Owners"
		hra_sum = "Sum Affordable: Hispanic Repeat Owners"
		afa_sum = "Sum Affordable: AIOM FT Owners"
		ara_sum = "Sum Affordable: AIOM Repeat Owners"
		wfa_mean = "% Affordable: NW Hispanic FT Owners"
		wra_mean = "% Affordable: NW Hispanic Repeat Owners"
		bfa_mean = "% Affordable: Black FT Owners"
		bra_mean = "% Affordable: Black Repeat Owners"
		hfa_mean = "% Affordable: Hispanic FT Owners"
		hra_mean = "% Affordable: Hispanic Repeat Owners"
		afa_mean = "% Affordable: AIOM FT Owners"
		ara_mean = "% Affordable: AIOM Repeat Owners"
;
		run;

proc summary data=create_flags;
	class ward2012;
	var white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output
		out=Ward_Level (where=(_type_^=0))
	sum= wfa_sum wra_sum bfa_sum bra_sum hfa_sum hra_sum afa_sum ara_sum
	mean= wfa_mean wra_mean bfa_mean bra_mean hfa_mean hra_mean afa_mean ara_mean;
	format ward2012 $wd12.;
	label 
		wfa_sum = "Sum Affordable: NW Hispanic FT Owners"
		wra_sum = "Sum Affordable: NW Hispanic Repeat Owners"
		bfa_sum = "Sum Affordable: Black FT Owners"
		bra_sum = "Sum Affordable: Black Repeat Owners"
		hfa_sum = "Sum Affordable: Hispanic FT Owners"
		hra_sum = "Sum Affordable: Hispanic Repeat Owners"
		afa_sum = "Sum Affordable: AIOM FT Owners"
		ara_sum = "Sum Affordable: AIOM Repeat Owners"
		wfa_mean = "% Affordable: NW Hispanic FT Owners"
		wra_mean = "% Affordable: NW Hispanic Repeat Owners"
		bfa_mean = "% Affordable: Black FT Owners"
		bra_mean = "% Affordable: Black Repeat Owners"
		hfa_mean = "% Affordable: Hispanic FT Owners"
		hra_mean = "% Affordable: Hispanic Repeat Owners"
		afa_mean = "% Affordable: AIOM FT Owners"
		ara_mean = "% Affordable: AIOM Repeat Owners"
;
		run;

proc summary data=create_flags;
	class geo2010;
	var white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output
		out=Tract_Level (where=(_type_^=0))
	sum= wfa_sum wra_sum bfa_sum bra_sum hfa_sum hra_sum afa_sum ara_sum
	mean= wfa_mean wra_mean bfa_mean bra_mean hfa_mean hra_mean afa_mean ara_mean;
	format geo2010 $GEO10A11.;
	label 
		wfa_sum = "Sum Affordable: NW Hispanic FT Owners"
		wra_sum = "Sum Affordable: NW Hispanic Repeat Owners"
		bfa_sum = "Sum Affordable: Black FT Owners"
		bra_sum = "Sum Affordable: Black Repeat Owners"
		hfa_sum = "Sum Affordable: Hispanic FT Owners"
		hra_sum = "Sum Affordable: Hispanic Repeat Owners"
		afa_sum = "Sum Affordable: AIOM FT Owners"
		ara_sum = "Sum Affordable: AIOM Repeat Owners"
		wfa_mean = "% Affordable: NW Hispanic FT Owners"
		wra_mean = "% Affordable: NW Hispanic Repeat Owners"
		bfa_mean = "% Affordable: Black FT Owners"
		bra_mean = "% Affordable: Black Repeat Owners"
		hfa_mean = "% Affordable: Hispanic FT Owners"
		hra_mean = "% Affordable: Hispanic Repeat Owners"
		afa_mean = "% Affordable: AIOM FT Owners"
		ara_mean = "% Affordable: AIOM Repeat Owners"
;
		run;

proc summary data=create_flags;
	class cluster_tr2000;
	var white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output
		out=Cluster_Level (where=(_type_^=0))
	sum= wfa_sum wra_sum bfa_sum bra_sum hfa_sum hra_sum afa_sum ara_sum
	mean= wfa_mean wra_mean bfa_mean bra_mean hfa_mean hra_mean afa_mean ara_mean;
	format Cluster_tr2000 $CLUS00A16. ;
	label 
		wfa_sum = "Sum Affordable: NW Hispanic FT Owners"
		wra_sum = "Sum Affordable: NW Hispanic Repeat Owners"
		bfa_sum = "Sum Affordable: Black FT Owners"
		bra_sum = "Sum Affordable: Black Repeat Owners"
		hfa_sum = "Sum Affordable: Hispanic FT Owners"
		hra_sum = "Sum Affordable: Hispanic Repeat Owners"
		afa_sum = "Sum Affordable: AIOM FT Owners"
		ara_sum = "Sum Affordable: AIOM Repeat Owners"
		wfa_mean = "% Affordable: NW Hispanic FT Owners"
		wra_mean = "% Affordable: NW Hispanic Repeat Owners"
		bfa_mean = "% Affordable: Black FT Owners"
		bra_mean = "% Affordable: Black Repeat Owners"
		hfa_mean = "% Affordable: Hispanic FT Owners"
		hra_mean = "% Affordable: Hispanic Repeat Owners"
		afa_mean = "% Affordable: AIOM FT Owners"
		ara_mean = "% Affordable: AIOM Repeat Owners"
;
		run;

