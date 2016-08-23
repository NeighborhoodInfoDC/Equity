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
  set realpr_r.sales_res_clean (where=(ui_proptype in ('10' '11') and 2010 <= year(saledate) <= 2014))
/*add code for saledate [between 1/1/10 and 12/31/14]*/;
  
  /*pull in effective interest rates - for example: 
  http://www.fhfa.gov/DataTools/Downloads/Documents/Historical-Summary-Tables/Table15_2015_by_State_and_Year.xls*/
  
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
    PITI_First=PI_First*1.34;

  *calculate monthly Principal and Interest for Repeat Homebuyer (20% down);
    if sale_yr=2010 then PI_Repeat=saleprice*.8*loan_multiplier_2010;
	if sale_yr=2011 then PI_Repeat=saleprice*.8*loan_multiplier_2011;
	if sale_yr=2012 then PI_Repeat=saleprice*.8*loan_multiplier_2012;
	if sale_yr=2013 then PI_Repeat=saleprice*.8*loan_multiplier_2013;
	if sale_yr=2014 then PI_Repeat=saleprice*.8*loan_multiplier_2014;
 
  *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for Repeat Homebuyer (25% of PI = TI);
    PITI_Repeat=PI_Repeat*1.25;

	/*Here are numbers for Average Household Income at the city level. 2010-14 ACS 
Black	NH-White	Hispanic	AIOM	 Black, MOE		NH-White, MOE	Hispanic, MOE	AIOM, MOE
59559.5	 157431		89889.9		76180.1	 1930.88		3872.54			8619.84			.*/


	if PITI_First <= (157431 / 12*.28) then white_first_afford=1; else white_first_afford=0; 
		if PITI_Repeat <= (157431/ 12 *.28) then white_repeat_afford=1; else white_repeat_afford=0; 
	if PITI_First <= (59559.5 / 12 *.28) then black_first_afford=1; else black_first_afford=0; 
		if PITI_Repeat <= (59559.5 / 12 *.28) then black_repeat_afford=1; else black_repeat_afford=0; 
	if PITI_First <= (89889.9 / 12*.28) then hispanic_first_afford=1; else hispanic_first_afford=0; 
		if PITI_Repeat <= (89889.9/ 12*.28 ) then hispanic_repeat_afford=1; else hispanic_repeat_afford=0; 
	if PITI_First <= (76180.1 / 12*.28 ) then aiom_first_afford=1; else aiom_first_afford=0; 
		if PITI_Repeat <= (76180.1 / 12*.28 ) then aiom_repeat_afford=1; else aiom_repeat_afford=0; 


	total_sales=1;

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
proc print data= create_flags (obs=25);
var saleprice PITI_FIRST PITI_repeat white_first_afford black_first_afford hispanic_first_afford AIOM_first_afford;
run;
proc freq data=create_flags; 
tables white_first_afford black_first_afford hispanic_first_afford AIOM_first_afford; 
run;
*proc summary at city, ward, tract, and cluster levels - so you could get % of sales in Ward 7 affordable to 
median white family vs. median black family.;

	
/*Proc Summary: Affordability for Owners by Race*/

proc summary data=create_flags;
	class city;
	var total_sales white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output	out=City_level (where=(_type_^=0))	sum= ;
	
	format city $CITY16.;
		run;

proc summary data=create_flags;
	class ward2012;
	var total_sales white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output 	out=Ward_Level (where=(_type_^=0)) 
	sum= ; 
	format ward2012 $wd12.;
;
		run;

proc summary data=create_flags;
	class geo2010;
	var total_sales white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output out=Tract_Level (where=(_type_^=0)) sum= ;
		run;

proc summary data=create_flags;
	class cluster_tr2000;
	var total_sales white_first_afford white_repeat_afford black_first_afford black_repeat_afford
		hispanic_first_afford hispanic_repeat_afford AIOM_first_afford AIOM_repeat_afford;
	output 		out=Cluster_Level (where=(_type_^=0)) 	sum= ;
	
		run;



	data equity.sales_afford_all (label="Homes Sales Affordabilty for Average Household Income" drop=_type_);

	set city_level ward_level cluster_level tract_level; 

	tractlabel=geo2010; 
	clustername=cluster_tr2000; 
	clusterlabel=cluster_tr2000;

	format tractlabel $GEO10A11. Clusterlabel $CLUS00A16. clustername $clus00s. geo2010 cluster_tr2000; 

	PctAffordFirst_White=white_first_afford/total_sales*100; 
	PctAffordFirst_Black=Black_first_afford/total_sales*100; 
	PctAffordFirst_Hispanic=Hispanic_first_afford/total_sales*100;
	PctAffordFirst_AIOM= AIOM_first_afford/total_sales*100;


	PctAffordRepeat_White=white_Repeat_afford/total_sales*100; 
	PctAffordRepeat_Black=Black_Repeat_afford/total_sales*100; 
	PctAffordRepeat_Hispanic=Hispanic_Repeat_afford/total_sales*100;
	PctAffordRepeat_AIOM= AIOM_repeat_afford/total_sales*100;

	label PctAffordFirst_White="Pct. of SF/Condo Sales 2010-14 Affordable to First-time Buyer at Avg. Household Inc. NH White"
		  PctAffordFirst_Black="Pct. of SF/Condo Sales 2010-14 Affordable to First-time Buyer at Avg. Household Inc. Black Alone"
		  PctAffordFirst_Hispanic="Pct. of SF/Condo Sales 2010-14 Affordable to First-time Buyer at Avg. Household Inc. Hispanic"
		 PctAffordFirst_AIOM="Pct. of SF/Condo Sales 2010-14 Affordable to First-time Buyer at Avg. Household Inc. Asian, Native American, Other, Multiple Race"
	
		PctAffordRepeat_White="Pct. of SF/Condo Sales 2010-14 Affordable to Repeat Buyer at Avg. Household Inc. NH White"
		PctAffordRepeat_Black="Pct. of SF/Condo Sales 2010-14 Affordable to Repeat Buyer at Avg. Household Inc. Black Alone"
		PctAffordRepeat_Hispanic="Pct. of SF/Condo Sales 2010-14 Affordable to Repeat Buyer at Avg. Household Inc. Hispanic"
		PctAffordRepeat_AIOM="Pct. of SF/Condo Sales 2010-14 Affordable to First-time Buyer at Avg. Household Inc. Asian, Native American, Other, Multiple Race";
		
	run;

data wardonly;
	set equity.sales_afford_all (where=(ward2012~=" ") keep=ward2012 pct:); 
	run; 
	proc transpose data=wardonly out=ward_long prefix=Ward_;
	id ward2012;
	run;

data cityonly;
	set equity.sales_afford_all (where=(city~=" ") keep=city pct:); 
	city=0;
	rename city=ward2012;
	run; 

	proc transpose data=cityonly out=city_long prefix=Ward_;
	id ward2012;
	run;
proc sort data=city_long;
by _name_;
proc sort data=ward_long;
by _name_; 

	data output_table;
	merge city_long ward_long;
	by _name_;
	run;

proc export data=output_table 
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_aff.csv"
	dbms=csv replace;
	run;
