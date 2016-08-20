
/**************************************************************************
 Program:  Equity_outputtables_2010_14_rev.sas
 Library:  Equity
 Project:  Racial Equity Profile
 Author:   G. MacDonald
 Created:  04/24/2013 
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Output tabulations 2010-14 5-year ACS IPUMS data for 
 Racial Equity 2016 report.

 Modifications: 
	07/25/2013 LH Limited to formats only on this program. 
	08/12/2013 EO altered tables based on HUD affordability levels.
	08/30/2013 EO altered tables for Demographics based on HUD affordability levels.
	07/25/2016 MW Updated for ACS 2010-14, Equity, and SAS1 Server
	08/20/2016 LH Revised to remove ODS export tables and create datasets from proc tabulate output. 
	
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( IPUMS );
%DCDATA_lib( Equity );

*%include "L:\Libraries\IPUMS\Prog\Ipums_formats_2010_14.sas"; 
%include "D:\DCData\Libraries\Equity\Prog\Equity_formats_2010_14.sas";
%include "D:\DCData\Libraries\Equity\Prog\Equity_macros_2010_14.sas";


***** Tables *****;

options nospool;

/*COST BURDEN*/ 
	%Count_table4( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
	  row_var= costburden,
	  row_fmt= yesno.,
	  weight= hhwt, 
	  universe= Renters,
	  out=costb_NHWH,
	  title= "Table 1. Cost Burden for Renters, White-Non Hispanic, Hispanic" );

	run;
		data costb_NHWH0 (drop=_table_ costburden race_cat1);

			set costb_NHWH (where=(_table_=1 & costburden=.) keep =_table_ puma total_Sum costburden race_cat1);

		rename total_Sum=NumRenters;
		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;

		run; 

		data costb_NHWH2 (drop=_table_ costburden race_cat1);

			set costb_NHWH (where=(_table_=1 & costburden=1) keep =_table_ puma total_Sum costburden race_cat1);

		rename total_Sum=NumRentCostB;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		run; 
		data costb_NHWH3 (drop=_table_ costburden _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set costb_NHWH (where=(_table_=2 & costburden=1) keep =_table_ puma costburden race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentCostB;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 

	%Count_table5( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
	  row_var= costburden,
	  row_fmt= yesno.,
	  weight= hhwt, 
	  universe= Renters,
	  out=costb_Alone,
	  title= "Table 2. Cost Burden for Renters, Race Alone" );

	run;

		data costb_alone0 (drop=_table_ costburden race_cat2);

			set costb_alone (where=(_table_=1 & costburden=.) keep =_table_ puma total_Sum costburden race_cat2);

		rename total_Sum=NumRenters;
			category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data costb_alone2 (drop=_table_ costburden race_cat2);

			set costb_alone (where=(_table_=1 & costburden=1) keep =_table_ puma total_Sum costburden race_cat2);

		rename total_Sum=NumRentCostB;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data costb_alone3 (drop=_table_ costburden _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set costb_alone (where=(_table_=2 & costburden=1) keep =_table_ puma costburden race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentCostB;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

	%Count_table2( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
	  row_var= costburden,
	  row_fmt= yesno.,
	  weight= hhwt, 
	  universe= Renters Who are Foreign-Born,
	  out=costb_for,
	  title= "Table 3. Cost Burden for Renters Who are Foreign-Born" );

	run;
		data costb_for0 (drop=_table_ costburden );

			set costb_for (where=(_table_=1 & costburden=.) keep =_table_ puma total_Sum costburden );

		rename total_Sum=NumRenters;
		category=8;
		format category category.;
		run; 
		data costb_for2 (drop=_table_ costburden );

			set costb_for (where=(_table_=1 & costburden=1) keep =_table_ puma total_Sum costburden );

		rename total_Sum=NumRentCostB;
		category=8;
		format category category.;
		run; 
		data costb_for3 (drop=_table_ costburden _type_  total_PctSum_00);

			set costb_for (where=(_table_=2 & costburden=1) keep =_table_ puma costburden _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=PctRentCostB;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 

/*SEVERE COST BURDEN*/ 
		
	%Count_table4( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
	  row_var= sevcostburden,
	  row_fmt= yesno.,
	  weight= hhwt, 
	  universe= Renters,
	  out=scostb_NHWH,
	  title= "Table 4. Severe Cost Burden for Renters, White-Non Hispanic, Hispanic" );

	run;
		data scostb_NHWH0 (drop=_table_ sevcostburden race_cat1);

			set scostb_NHWH (where=(_table_=1 & sevcostburden=.) keep =_table_ puma total_Sum sevcostburden race_cat1);

		rename total_Sum=NumRenters;
		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;

		run; 

		data scostb_NHWH2 (drop=_table_ sevcostburden race_cat1);

			set scostb_NHWH (where=(_table_=1 & sevcostburden=1) keep =_table_ puma total_Sum sevcostburden race_cat1);

		rename total_Sum=NumRentSevCostB;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 

		data scostb_NHWH3 (drop=_table_ sevcostburden _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set scostb_NHWH (where=(_table_=2 & sevcostburden=1) keep =_table_ puma sevcostburden race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentSevCostB;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 

	%Count_table5( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
	  row_var= sevcostburden,
	  row_fmt= yesno.,
	  weight= hhwt, 
	  universe= Renters,
	  out=scostb_Alone,
	  title= "Table 5. Severe Cost Burden for Renters, Race Alone" );

	run;

		data scostb_alone0 (drop=_table_ sevcostburden race_cat2);

			set scostb_alone (where=(_table_=1 & sevcostburden=.) keep =_table_ puma total_Sum sevcostburden race_cat2);

		rename total_Sum=NumRenters;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data scostb_alone2 (drop=_table_ sevcostburden race_cat2);

			set scostb_alone (where=(_table_=1 & sevcostburden=1) keep =_table_ puma total_Sum sevcostburden race_cat2);

		rename total_Sum=NumRentSevCostB;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data scostb_alone3 (drop=_table_ sevcostburden _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set scostb_alone (where=(_table_=2 & sevcostburden=1) keep =_table_ puma sevcostburden race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentSevCostB;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

	%Count_table2( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
	  row_var= sevcostburden,
	  row_fmt= yesno.,
	  weight= hhwt, 
	  universe= Renters Who are Foreign-Born,
	  out=scostb_for,
	  title= "Table 6. Severe Cost Burden for Renters Who are Foreign-Born" );

	run;
		data scostb_for0 (drop=_table_ sevcostburden );

			set scostb_for (where=(_table_=1 & sevcostburden=.) keep =_table_ puma total_Sum sevcostburden );

		rename total_Sum=NumRenters;
		category=8;
		format category category.;
		run; 
		data scostb_for2 (drop=_table_ sevcostburden );

			set scostb_for (where=(_table_=1 & sevcostburden=1) keep =_table_ puma total_Sum sevcostburden );

		rename total_Sum=NumRentSevCostB;
		category=8;
		format category category.;
		run; 
		data scostb_for3 (drop=_table_ sevcostburden _type_  total_PctSum_00);

			set scostb_for (where=(_table_=2 & sevcostburden=1) keep =_table_ puma sevcostburden _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=PctRentSevCostB;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 

/*Share of Population Employed 25-64*/

	%Count_table4( 
	  where= %str(city=7230 and age25to64=1  ),
	  row_var= emp25to64,
	  row_fmt= emp25to64_f.,
	  weight = perwt,
	  universe= Individuals Ages 25 to 64,
	  out=emp_NHWH,
	  title= "Table 7. Share of Population Ages 25-64 that is Employed, Non-Hispanic White, Hispanic" );

	run;
		data emp_NHWH0 (drop=_table_ emp25to64 race_cat1);

			set emp_NHWH (where=(_table_=1 & emp25to64=.) keep =_table_ puma total_Sum emp25to64 race_cat1);

		rename total_Sum=Pop25to64years;
		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;

		run; 

		data emp_NHWH2a (drop=_table_ emp25to64 race_cat1);

			set emp_NHWH (where=(_table_=1 & emp25to64=1) keep =_table_ puma total_Sum emp25to64 race_cat1);

		rename total_Sum=Pop25to64yearsEmp;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data emp_NHWH2b (drop=_table_ emp25to64 race_cat1);

			set emp_NHWH (where=(_table_=1 & emp25to64=0) keep =_table_ puma total_Sum emp25to64 race_cat1);

		rename total_Sum=Pop25to64yearsUnEmp;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data emp_NHWH2c (drop=_table_ emp25to64 race_cat1);

			set emp_NHWH (where=(_table_=1 & emp25to64=.u) keep =_table_ puma total_Sum emp25to64 race_cat1);

		rename total_Sum=Pop25to64yearsOutLF;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data emp_NHWH3a (drop=_table_ emp25to64 _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set emp_NHWH (where=(_table_=2 & emp25to64=1) keep =_table_ puma emp25to64 race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=Pct25to64yearsEmp;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data emp_NHWH3b (drop=_table_ emp25to64 _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set emp_NHWH (where=(_table_=2 & emp25to64=0) keep =_table_ puma emp25to64 race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=Pct25to64yearsUnEmp;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data emp_NHWH3c (drop=_table_ emp25to64 _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set emp_NHWH (where=(_table_=2 & emp25to64=.u) keep =_table_ puma emp25to64 race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=Pct25to64yearsOutLF;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
	%Count_table5( 
	  where= %str(city=7230 and age25to64=1 ),
	  row_var= emp25to64,
	  row_fmt= emp25to64_f.,
	  weight = perwt,
	  universe= Individuals Ages 25 to 64,
	  out=emp_Alone,
	  title= "Table 8. Share of Population Ages 25-64 that is Employed, Race Alone" );

	run;
		data emp_alone0 (drop=_table_ emp25to64 race_cat2);

			set emp_alone (where=(_table_=1 & emp25to64=.) keep =_table_ puma total_Sum emp25to64 race_cat2);

		rename total_Sum=Pop25to64years;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data emp_alone2a (drop=_table_ emp25to64 race_cat2);

			set emp_alone (where=(_table_=1 & emp25to64=1) keep =_table_ puma total_Sum emp25to64 race_cat2);

		rename total_Sum=Pop25to64yearsEmp;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data emp_alone2b (drop=_table_ emp25to64 race_cat2);

			set emp_alone (where=(_table_=1 & emp25to64=0) keep =_table_ puma total_Sum emp25to64 race_cat2);

		rename total_Sum=Pop25to64yearsUnEmp;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data emp_alone2c (drop=_table_ emp25to64 race_cat2);

			set emp_alone (where=(_table_=1 & emp25to64=.u) keep =_table_ puma total_Sum emp25to64 race_cat2);

		rename total_Sum=Pop25to64yearsOutLF;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data emp_alone3a (drop=_table_ emp25to64 _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set emp_alone (where=(_table_=2 & emp25to64=1) keep =_table_ puma emp25to64 race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=Pct25to64yearsEmp;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data emp_alone3b (drop=_table_ emp25to64 _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set emp_alone (where=(_table_=2 & emp25to64=0) keep =_table_ puma emp25to64 race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=Pct25to64yearsUnEmp;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data emp_alone3c (drop=_table_ emp25to64 _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set emp_alone (where=(_table_=2 & emp25to64=.u) keep =_table_ puma emp25to64 race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=Pct25to64yearsOutLF;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

	%Count_table2( 
	  where= %str(city=7230 and age25to64=1 and foreign=1),
	  row_var= emp25to64,
	  row_fmt= emp25to64_f.,
	  weight = perwt,
	  universe= Individuals Ages 25 to 64 Who Are Foreign Born,
	  out=emp_for,
	  title= "Table 9. Severe Cost Burden for Renters Who are Foreign-Born" );

	run;
		data emp_for0 (drop=_table_ emp25to64 );

			set emp_for (where=(_table_=1 & emp25to64=.) keep =_table_ puma total_Sum emp25to64 );

		rename total_Sum=Pop25to64years;
		category=8;
		format category category.;
		run; 
		data emp_for2a (drop=_table_ emp25to64 );

			set emp_for (where=(_table_=1 & emp25to64=1) keep =_table_ puma total_Sum emp25to64 );

		rename total_Sum=Pop25to64yearsEmp;
		category=8;
		format category category.;
		run; 
		data emp_for2b (drop=_table_ emp25to64 );

			set emp_for (where=(_table_=1 & emp25to64=0) keep =_table_ puma total_Sum emp25to64 );

		rename total_Sum=Pop25to64yearsUnEmp;
		category=8;
		format category category.;
		run; 
		data emp_for2c (drop=_table_ emp25to64 );

			set emp_for (where=(_table_=1 & emp25to64=.u) keep =_table_ puma total_Sum emp25to64 );

		rename total_Sum=Pop25to64yearsOutLF;
		category=8;
		format category category.;
		run; 
		data emp_for3a (drop=_table_ emp25to64 _type_  total_PctSum_00);

			set emp_for (where=(_table_=2 & emp25to64=1) keep =_table_ puma emp25to64 _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=Pct25to64yearsEmp;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 
		data emp_for3b (drop=_table_ emp25to64 _type_  total_PctSum_00);

			set emp_for (where=(_table_=2 & emp25to64=0) keep =_table_ puma emp25to64 _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=Pct25to64yearsUnEmp;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 
		data emp_for3c (drop=_table_ emp25to64 _type_  total_PctSum_00);

			set emp_for (where=(_table_=2 & emp25to64=.u) keep =_table_ puma emp25to64 _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=Pct25to64yearsOutLF;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 

/***********Mortgage Status******/ 
	%Count_table4( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 ),
	  row_var= ownmortgage,
	  row_fmt= ownmortgage.,
	  weight= hhwt, 
	  universe= Homeowners,
	  out=mort_NHWH,
	  title= "Table 10. Mortgage Status for Homeowners, Non Hispanic White, Hispanic" );

	run;
		data mort_NHWH0 (drop=_table_ ownmortgage race_cat1);

			set mort_NHWH (where=(_table_=1 & ownmortgage=.) keep =_table_ puma total_Sum ownmortgage race_cat1);

		rename total_Sum=NumOwners;
		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;

		run; 

		data mort_NHWH2a (drop=_table_ ownmortgage race_cat1);

			set mort_NHWH (where=(_table_=1 & ownmortgage=1) keep =_table_ puma total_Sum ownmortgage race_cat1);

		rename total_Sum=NumOwnersOweMort;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data mort_NHWH2b (drop=_table_ ownmortgage race_cat1);

			set mort_NHWH (where=(_table_=1 & ownmortgage=0) keep =_table_ puma total_Sum ownmortgage race_cat1);

		rename total_Sum=NumOwnersNoMort;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data mort_NHWH3a (drop=_table_ ownmortgage _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set mort_NHWH (where=(_table_=2 & ownmortgage=1) keep =_table_ puma ownmortgage race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctOwnersOweMort;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data mort_NHWH3b (drop=_table_ ownmortgage _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set mort_NHWH (where=(_table_=2 & ownmortgage=0) keep =_table_ puma ownmortgage race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctOwnersNoMort;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
	%Count_table5( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 ),
	  row_var= ownmortgage,
	  row_fmt= ownmortgage.,
	  weight= hhwt, 
	  universe= Homeowners,
	  out=mort_Alone,
	  title= "Table 11. Mortgage Status for Homeowners, Races Alone" );

	run;
		data mort_alone0 (drop=_table_ ownmortgage race_cat2);

			set mort_alone (where=(_table_=1 & ownmortgage=.) keep =_table_ puma total_Sum ownmortgage race_cat2);

		rename total_Sum=NumOwners;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data mort_alone2a (drop=_table_ ownmortgage race_cat2);

			set mort_alone (where=(_table_=1 & ownmortgage=1) keep =_table_ puma total_Sum ownmortgage race_cat2);

		rename total_Sum=NumOwnersOweMort;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data mort_alone2b (drop=_table_ ownmortgage race_cat2);

			set mort_alone (where=(_table_=1 & ownmortgage=0) keep =_table_ puma total_Sum ownmortgage race_cat2);

		rename total_Sum=NumOwnersNoMort;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data mort_alone3a (drop=_table_ ownmortgage _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set mort_alone (where=(_table_=2 & ownmortgage=1) keep =_table_ puma ownmortgage race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctOwnersOweMort;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data mort_alone3b (drop=_table_ ownmortgage _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set mort_alone (where=(_table_=2 & ownmortgage=0) keep =_table_ puma ownmortgage race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctOwnersNoMort;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
	
	%Count_table2( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 and foreign=1),
	  row_var= ownmortgage,
	  row_fmt= ownmortgage.,
	  weight= hhwt, 
	  universe= Homeowners,
	  out=mort_for,
	  title= "Table 12. Mortgage Status for Homeowners, Foreign Born" );

	run;
		data mort_for0 (drop=_table_ ownmortgage );

			set mort_for (where=(_table_=1 & ownmortgage=.) keep =_table_ puma total_Sum ownmortgage );

		rename total_Sum=NumOwners;
		category=8;
		format category category.;
		run;  
		data mort_for2a (drop=_table_ ownmortgage );

			set mort_for (where=(_table_=1 & ownmortgage=1) keep =_table_ puma total_Sum ownmortgage );

		rename total_Sum=NumOwnersOweMort;
		category=8;
		format category category.;
		run; 
		data mort_for2b (drop=_table_ ownmortgage );

			set mort_for (where=(_table_=1 & ownmortgage=0) keep =_table_ puma total_Sum ownmortgage );

		rename total_Sum=NumOwnersNoMort;
		category=8;
		format category category.;
		run; 
		data mort_for3a (drop=_table_ ownmortgage _type_  total_PctSum_00);

			set mort_for (where=(_table_=2 & ownmortgage=1) keep =_table_ puma ownmortgage _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=PctOwnersOweMort;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 
		data mort_for3b (drop=_table_ ownmortgage _type_  total_PctSum_00);

			set mort_for (where=(_table_=2 & ownmortgage=0) keep =_table_ puma ownmortgage _type_
																	total_PctSum_01 total_PctSum_00 );

		rename total_PctSum_01=PctOwnersNoMort;
		if puma=. then total_PctSum_01=total_PctSum_00;
		category=8;
		format category category.;
		run; 
	
/****RENTAL UNIT AFFORDABILITY********/


	%count_table3(
		where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2),
		row_var=race_cat1,
		row_fmt=racecatA.,
		weight=hhwt,
		universe=Renters,
		out=aff_NHWH,
		title="Table 13. Housing Affordability for Renters, Non-Hispanic White, Hispanic"); 
		run;
	
		data aff_NHWH2a (drop=_table_ aff_unit race_cat1);

			set aff_NHWH (where=(_table_=1 & aff_unit=1) keep =_table_ puma total_Sum aff_unit race_cat1);

		rename total_Sum=NumRentUnitsELI;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data aff_NHWH2b (drop=_table_ aff_unit race_cat1);

			set aff_NHWH (where=(_table_=1 & aff_unit=2) keep =_table_ puma total_Sum aff_unit race_cat1);

		rename total_Sum=NumRentUnitsVLI;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data aff_NHWH2c (drop=_table_ aff_unit race_cat1);

			set aff_NHWH (where=(_table_=1 & aff_unit=3) keep =_table_ puma total_Sum aff_unit race_cat1);

		rename total_Sum=NumRentUnitsLI;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		data aff_NHWH2d (drop=_table_ aff_unit race_cat1);

			set aff_NHWH (where=(_table_=1 & aff_unit=4) keep =_table_ puma total_Sum aff_unit race_cat1);

		rename total_Sum=NumRentUnitsMHI;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 

		data aff_NHWH3a (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set aff_NHWH (where=(_table_=2 & aff_unit=1) keep =_table_ puma aff_unit race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsELI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		
		data aff_NHWH3b (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set aff_NHWH (where=(_table_=2 & aff_unit=2) keep =_table_ puma aff_unit race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsVLI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		
		data aff_NHWH3c (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set aff_NHWH (where=(_table_=2 & aff_unit=3) keep =_table_ puma aff_unit race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsLI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 
		
		data aff_NHWH3d (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat1);

			set aff_NHWH (where=(_table_=2 & aff_unit=4) keep =_table_ puma aff_unit race_cat1 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsMHI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
		run; 

	%count_table3(
		where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2),
		row_var=race_cat2,
		row_fmt=racecatB.,
		weight=hhwt,
		universe=Renters,
		out=aff_alone,
		title="Table 14. Housing Affordability for Renters, Race Alone"); 
		run;
	
		data aff_alone2a (drop=_table_ aff_unit race_cat2);

			set aff_alone (where=(_table_=1 & aff_unit=1) keep =_table_ puma total_Sum aff_unit race_cat2);

		rename total_Sum=NumRentUnitsELI;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data aff_alone2b (drop=_table_ aff_unit race_cat2);

			set aff_alone (where=(_table_=1 & aff_unit=2) keep =_table_ puma total_Sum aff_unit race_cat2);

		rename total_Sum=NumRentUnitsVLI;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data aff_alone2c (drop=_table_ aff_unit race_cat2);

			set aff_alone (where=(_table_=1 & aff_unit=3) keep =_table_ puma total_Sum aff_unit race_cat2);

		rename total_Sum=NumRentUnitsLI;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data aff_alone2d (drop=_table_ aff_unit race_cat2);

			set aff_alone (where=(_table_=1 & aff_unit=4) keep =_table_ puma total_Sum aff_unit race_cat2);

		rename total_Sum=NumRentUnitsMHI;
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

		data aff_alone3a (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set aff_alone (where=(_table_=2 & aff_unit=1) keep =_table_ puma aff_unit race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsELI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data aff_alone3b (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set aff_alone (where=(_table_=2 & aff_unit=2) keep =_table_ puma aff_unit race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsVLI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data aff_alone3c (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set aff_alone (where=(_table_=2 & aff_unit=3) keep =_table_ puma aff_unit race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsLI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 
		data aff_alone3d (drop=_table_ aff_unit _type_ total_PctSum_011 total_PctSum_001 total_PctSum_000 race_cat2);

			set aff_alone (where=(_table_=2 & aff_unit=4) keep =_table_ puma aff_unit race_cat2 _type_
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsMHI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
		run; 

	%count_table3(
		where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
		row_var=foreign,
		row_fmt=yesno.,
		weight=hhwt,
		universe=Renters,
		out=aff_for,
		title="Table 15. Housing Affordability for Renters, Foreign Born"); 
		run;

		data aff_for2a (drop=_table_  aff_unit foreign );

			set aff_for (where=(_table_=1 & aff_unit=1 & foreign=1) keep =_table_ puma aff_unit total_Sum foreign );

		rename total_Sum=NumRentUnitsELI;
		category=8;
		format category category.;
		run; 
		data aff_for2b (drop=_table_  aff_unit foreign );

			set aff_for (where=(_table_=1 & aff_unit=2 & foreign=1) keep =_table_ puma aff_unit total_Sum foreign );

		rename total_Sum=NumRentUnitsVLI;
		category=8;
		format category category.;
		run; 
		data aff_for2c (drop=_table_ aff_unit foreign );

			set aff_for (where=(_table_=1 & aff_unit=3 & foreign=1) keep =_table_ puma aff_unit total_Sum foreign );

		rename total_Sum=NumRentUnitsLI;
		category=8;
		format category category.;
		run; 
		data aff_for2d (drop=_table_  aff_unit foreign );

			set aff_for (where=(_table_=1 & aff_unit=4 & foreign=1) keep =_table_ puma aff_unit total_Sum foreign );

		rename total_Sum=NumRentUnitsMHI;
		category=8;
		format category category.;
		run; 
		data aff_for3a (drop=_table_ aff_unit foreign _type_  total_PctSum_000 total_PctSum_011 total_PctSum_001);

			set aff_for (where=(_table_=2 & aff_unit=1 & foreign=1) keep =_table_ puma aff_unit foreign _type_
																	total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsELI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=8;
		format category category.;
		run; 
		data aff_for3b (drop=_table_ aff_unit foreign _type_  total_PctSum_000 total_PctSum_011 total_PctSum_001);

			set aff_for (where=(_table_=2 & aff_unit=2 & foreign=1) keep =_table_ puma aff_unit foreign _type_
																	total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsVLI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=8;
		format category category.;
		run; 
		data aff_for3c (drop=_table_ aff_unit foreign _type_  total_PctSum_000 total_PctSum_011 total_PctSum_001);

			set aff_for (where=(_table_=2 & aff_unit=3 & foreign=1) keep =_table_ puma aff_unit foreign _type_
																	total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsLI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=8;
		format category category.;
		run; 
		data aff_for3d (drop=_table_ aff_unit foreign _type_  total_PctSum_000 total_PctSum_011 total_PctSum_001);

			set aff_for (where=(_table_=2 & aff_unit=4 & foreign=1) keep =_table_ puma aff_unit foreign _type_
																	total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_001);

		rename total_PctSum_010=PctRentUnitsMHI;
		if puma=. then total_PctSum_010=total_PctSum_000;

		if _type_=111 then total_PctSum_010=total_PctSum_011;
		if _type_=101 then total_PctSum_010=total_PctSum_001;

		category=8;
		format category category.;
		run; 



*Merge files together;
		proc sort data=costb_nhwh0;
		by PUMA category;
		proc sort data=costb_nhwh2;
		by PUMA category;
		proc sort data=costb_nhwh3;
		by PUMA category;
		proc sort data=costb_alone0;
		by PUMA category;
		proc sort data=costb_alone2;
		by PUMA category;
		proc sort data=costb_alone3;
		by PUMA category;
		proc sort data=costb_for0;
		by PUMA category;
		proc sort data=costb_for2;
		by PUMA category;
		proc sort data=costb_for3;
		by PUMA category;
		proc sort data=scostb_nhwh2;
		by PUMA category;
		proc sort data=scostb_nhwh3;
		by PUMA category;
		proc sort data=scostb_alone2;
		by PUMA category;
		proc sort data=scostb_alone3;
		by PUMA category;
		proc sort data=scostb_for2;
		by PUMA category;
		proc sort data=scostb_for3;
		by PUMA category;
		proc sort data=mort_nhwh0;
		by PUMA category;
		proc sort data=mort_nhwh2a;
		by PUMA category;
		proc sort data=mort_nhwh2b;
		by PUMA category;
		proc sort data=mort_nhwh3a;
		by PUMA category;
		proc sort data=mort_nhwh3b;
		by PUMA category;
		proc sort data=mort_alone0;
		by PUMA category;
		proc sort data=mort_alone2a;
		by PUMA category;
		proc sort data=mort_alone2b;
		by PUMA category;
		proc sort data=mort_alone3a;
		by PUMA category;
		proc sort data=mort_alone3b;
		by PUMA category;
		proc sort data=mort_for0;
		by PUMA category;
		proc sort data=mort_for2a;
		by PUMA category;
		proc sort data=mort_for2b;
		by PUMA category;
		proc sort data=mort_for3a;
		by PUMA category;
		proc sort data=mort_for3b;
		by PUMA category;
		proc sort data=aff_nhwh2a;
		by PUMA category;
		proc sort data=aff_nhwh2b;
		by PUMA category;
		proc sort data=aff_nhwh2c;
		by PUMA category;
		proc sort data=aff_nhwh2d;
		by PUMA category;
		proc sort data=aff_alone2a;
		by PUMA category;
		proc sort data=aff_alone2b;
		by PUMA category;
		proc sort data=aff_alone2c;
		by PUMA category;
		proc sort data=aff_alone2d;
		by PUMA category;
		proc sort data=aff_for2a;
		by PUMA category;
		proc sort data=aff_for2b;
		by PUMA category;
		proc sort data=aff_for2c;
		by PUMA category;
		proc sort data=aff_for2d;
		by PUMA category;
		proc sort data=aff_nhwh3a;
		by PUMA category;
		proc sort data=aff_nhwh3b;
		by PUMA category;
		proc sort data=aff_nhwh3c;
		by PUMA category;
		proc sort data=aff_nhwh3d;
		by PUMA category;
		proc sort data=aff_alone3a;
		by PUMA category;
		proc sort data=aff_alone3b;
		by PUMA category;
		proc sort data=aff_alone3c;
		by PUMA category;
		proc sort data=aff_alone3d;
		by PUMA category;
		proc sort data=aff_for3a;
		by PUMA category;
		proc sort data=aff_for3b;
		by PUMA category;
		proc sort data=aff_for3c;
		by PUMA category;
		proc sort data=aff_for3d;
		by PUMA category;
		proc sort data=emp_nhwh0;
		by PUMA category;
		proc sort data=emp_nhwh2a;
		by PUMA category;
		proc sort data=emp_nhwh2b;
		by PUMA category;
		proc sort data=emp_nhwh2c;
		by PUMA category;
		proc sort data=emp_nhwh3a;
		by PUMA category;
		proc sort data=emp_nhwh3b;
		by PUMA category;
		proc sort data=emp_nhwh3c;
		by PUMA category;
		proc sort data=emp_alone0;
		by PUMA category;
		proc sort data=emp_alone2a;
		by PUMA category;
		proc sort data=emp_alone2b;
		by PUMA category;
		proc sort data=emp_alone2c;
		by PUMA category;
		proc sort data=emp_alone3a;
		by PUMA category;
		proc sort data=emp_alone3b;
		by PUMA category;
		proc sort data=emp_alone3c;
		by PUMA category;
		proc sort data=emp_for0;
		by PUMA category; 
		proc sort data=emp_for2a;
		by PUMA category;
		proc sort data=emp_for2b;
		by PUMA category;
		proc sort data=emp_for2c;
		by PUMA category;
		proc sort data=emp_for3a;
		by PUMA category;
		proc sort data=emp_for3b;
		by PUMA category;
		proc sort data=emp_for3c;
		by PUMA category;
		data merged_data;
		merge costb_nhwh0 costb_nhwh2 costb_nhwh3 costb_alone0 (where=(category~=.)) costb_alone2 (where=(category~=.)) costb_alone3 (where=(category~=.)) 
			 costb_for0 costb_for2 costb_for3
			 scostb_nhwh2 scostb_nhwh3 scostb_alone2 (where=(category~=.)) scostb_alone3 (where=(category~=.))  scostb_for2 scostb_for3
			 mort_nhwh0 mort_nhwh2a mort_nhwh2b mort_nhwh3a mort_nhwh3b mort_alone0 (where=(category~=.)) mort_alone2a (where=(category~=.)) mort_alone2b (where=(category~=.))
			 mort_alone3a (where=(category~=.)) mort_alone3b (where=(category~=.))  mort_for0 mort_for2a mort_for2b mort_for3a mort_for3b 
			 aff_nhwh2a aff_nhwh2b aff_nhwh2c aff_nhwh2d aff_alone2a aff_alone2b aff_alone2c aff_alone2d aff_for2a aff_for2b aff_for2c aff_for2d
			aff_nhwh3a aff_nhwh3b aff_nhwh3c aff_nhwh3d aff_alone3a aff_alone3b aff_alone3c aff_alone3d aff_for3a aff_for3b aff_for3c aff_for3d
			emp_nhwh0 emp_nhwh2a emp_nhwh2b emp_nhwh2c emp_nhwh3a emp_nhwh3b emp_nhwh3c 
			emp_alone0 (where=(category~=.)) emp_alone2a (where=(category~=.)) emp_alone2b (where=(category~=.)) emp_alone2c (where=(category~=.))
			emp_alone3a (where=(category~=.)) emp_alone3b (where=(category~=.)) emp_alone3c (where=(category~=.))
				emp_for0  emp_for2a emp_for2b emp_for2c emp_for3a emp_for3b emp_for3c;
		by PUMA category;

		run; 
proc sort data=merged_data;
by category;

Proc transpose data=merged_data out=transposed_data prefix=PUMA;
by category;
id puma; 

run;

proc sort data=transposed_data;
by _name_ category ;
run; 
proc freq data=transposed_data;
tables _name_;
run;
data profile_tabs_ipums ; 
	set transposed_data; 

rename _name_=Indicator;

order = .;

if _name_ ="Pop25to64years" then order=1;
if _name_="Pop25to64yearsEmp" then order=2; 
if _name_="Pct25to64yearsEmp" then order=3;
if _name_="Pop25to64yearsUnEmp" then order=4; 
if _name_="Pct25to64yearsUnEmp" then order=5;
if _name_="Pop25to64yearsOutLF" then order=6; 
if _name_="Pct25to64yearsOutLF" then order=7;

if _name_="NumOwners" then order=8;
if _name_="NumRenters" then order=9; 
if _name_="NumOwnersNoMort"  then order=10;
if _name_="PctOwnersNoMort" then order=11; 
if _name_="NumOwnersOweMort" then order=12;
if _name_="PctOwnersOweMort"  then order=13;

if _name_="NumRentCostB" then order=14;
if _name_="PctRentCostB" then order=15;
if _name_="NumRentSevCostB" then order=16;
if _name_="PctRentSevCostB" then order=17;

if _name_="NumRentUnitsELI" then order=18;
if _name_="PctRentUnitsELI" then order=19;
if _name_="NumRentUnitsVLI" then order=20;
if _name_="PctRentUnitsVLI" then order=21;
if _name_="NumRentUnitsLI" then order=22;
if _name_="PctRentUnitsLI" then order=23;
if _name_="NumRentUnitsMHI" then order=24;
if _name_="PctRentUnitsMHI" then order=25;

run; 

proc sort data=profile_tabs_ipums out=sorted;
by order;
data equity.profile_tabs_ipums (Label="iPUMS ACS 2010-14 Tabulations for Racial Equity Profile" sortedby=order);
set sorted;
run;
proc export data=equity.profile_tabs_ipums 
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ipums.csv"
	dbms=csv replace;
	run;
