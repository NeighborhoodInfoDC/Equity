/*MAIA - insert standard DC data header*/

*Methodology for affordability adapted from Zhong Yi Tong paper 
http://content.knowledgeplex.org/kp2/cache/documents/22736.pdf
Homeownership Affordability in Urban America: Past and Future;

%dcdata_lib( realprop );
%dcdata_lib( equity );

data create_flags;
  set realpr_r.sales_master (where=(ui_proptype in ('10' '11') and /*add code for saledate [between 1/1/10 and 12/31/14]*/));
  
  /*pull in effective interest rates - for example: 
  http://www.fhfa.gov/DataTools/Downloads/Documents/Historical-Summary-Tables/Table15_2015_by_State_and_Year.xls*/
  
  *create sale_yr from saledate(?- check var name); 
  
  eff_int_rate_2010= X.XX;
  eff_int_rate_2011= X.XX;
  eff_int_rate_2012= X.XX;
  eff_int_rate_2013= X.XX;
  eff_int_rate_2014= X.XX;


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
  **repeat for each year;
  *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for First Time Homebuyer (34% of PI = TI);
  /*no need to repeat for each year - we'll just lump all 5 together*/
    PITI_First=PI_First*1.34;
  *calculate monthly Principal and Interest for Repeat Homebuyer (20% down);
    if sale_yr=2010 then PI_Repeat=saleprice*.8*loan_multiplier_2010;
  **repeat for each year;
  *calculate monthly PITI (Principal, Interest, Taxes and Insurance) for Repeat Homebuyer (25% of PI = TI);
    PITI_Repeat=PI_Repeat*1.25;
  
	*get median family income by race from ACS for 2010-2014 and create race-based flags for each sale; 
	if PITI_First <= [NH white median family income / 12] then white_first_afford=1; else white_first_afford=0; 
	if PITI_Repeat <= [NH white median family income / 12] then white_repeat_afford=1; else white_repeat_afford=0; 
		*repeat by race categories;
		
		*proc summary at city, ward, tract, and cluster levels - so you could get % of sales in Ward 7 affordable to 
		median white family vs. median black family.;
