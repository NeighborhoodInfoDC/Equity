/**************************************************************************
 Program:  Equity_Sales_Affordability_transpose_count.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby	
 Created:  11/4/16
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description: Outputs table of numbers on sales affordability by race, based on Equity.Sales_affordability program.

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( realprop );
%DCData_lib( equity );

proc transpose data=equity.sales_afford_all out=equity.profile_tabs_aff_count; 
var total_sales 
	white_first_afford white_repeat_afford
	black_first_afford black_repeat_afford
	hispanic_first_afford hispanic_repeat_afford
	AIOM_first_afford AIOM_repeat_afford
	;
id ward2012;
run;

proc export data=equity.profile_tabs_aff_count;
	outfile="D:\DCDATA\Libraries\Equity\Prog\Racial Equity Feature\profile_tabs_salesaffordability_count.csv"
	dbms=csv replace;
	run;

