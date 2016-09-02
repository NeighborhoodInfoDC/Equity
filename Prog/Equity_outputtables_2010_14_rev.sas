
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

%macro rename(data);

/** First, create a data set with the list of variables in your input data set **/

proc contents data=&data out=_contents noprint;

/** Then, turn the list into a macro variable list: **/

proc sql noprint;
  select name 
  into :varlist separated by ' '
  from _contents
  ;
quit;

/** Next, you need to process each var in the list into a rename statement. **/

%let i = 1;
%let v = %scan( &varlist, &i );
%let rename = ;

%do %while ( &v ~= );
  
  %let rename = &rename &v=c&v.;

  %let i = %eval( &i + 1 );
  %let v = %scan( &varlist, &i );

%end;

/** Finally, you apply the rename statement to your data set. **/

data &data._new;
  set &data;
  rename &rename ;
run;
%mend rename;



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

data costb_index;
set Equity.Acs_tables_ipums;
if city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 then subpopvar = 1;
else subpopvar = 0;
run;

proc sort data = costb_index;
by strata cluster;
run;

*StdDev on Count Total Renters (by Puma and Race))*;
%survey_freq (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat1, out=costb_totalr_freqprelim);run;

*StdDev on Count Cost Burdened (by Puma and Race)*;
%survey_freq (input=costb_index, where=%str(subpopvar=1 and costburden=1), weight=hhwt, 
type=crosstabs, tables=costburden*puma*race_cat1, out=costb_totalcb_freqprelim);run;

*StdDev on Pct Cost Burdened (of Total)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=costburden, out=costb_total_pctprelim);run;

*StdDev on Pct Cost Burdened (by Puma Only)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=costburden, out=costb_puma_pctprelim);run;

*StdDev on Pct Cost Burdened (by Race Only)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1, var=costburden, out=costb_race_pctprelim);run;

*StdDev on Pct Cost Burdened (by Race & Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1*puma, var=costburden, out=costb_allvars_pctprelim);run;

data costb_pct;
set costb_total_pctprelim (keep=mean stderr) costb_puma_pctprelim (keep=mean puma stderr) costb_race_pctprelim (keep=race_cat1 mean stderr) 
costb_allvars_pctprelim (keep=race_cat1 puma mean stderr);
	category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
run;

data costb_r_freq;
	set costb_totalr_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data costb_cb_freq;
	set costb_totalcb_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

proc sort data=costb_nhwh0 out=costb_r_base; by PUMA category; run;
proc sort data=costb_nhwh2 out=costb_cb_base; by PUMA category; run;
proc sort data=costb_nhwh3 out=costb_pct_base; by PUMA category; run;
proc sort data=costb_r_freq out=costb_r_std; by PUMA category; run;
proc sort data=costb_cb_freq out=costb_cb_std; by PUMA category; run;
proc sort data=costb_pct out=costb_pct_std; by PUMA category; run;

data costb_nhwh0_stdincl;
	merge costb_r_base costb_r_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;

data costb_nhwh2_stdincl;
	merge costb_cb_base costb_cb_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;

data costb_nhwh3_stdincl;
	merge costb_pct_base costb_pct_std (drop=mean race_cat1);
		by PUMA category;
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

*StdDev on Count Total Renters (for Race Alone by Puma and Race)*;
%survey_freq (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat2, out=costb_totalr_freqprelim_alone);run;

*StdDev on Count Cost Burdened (for Race Alone by Puma and Race)*;
%survey_freq (input=costb_index, where=%str(subpopvar=1 and costburden=1), weight=hhwt, 
type=crosstabs, tables=costburden*puma*race_cat2, out=costb_totalcb_freqprelim_alone);run;

*StdDev on Pct Cost Burdened (of Total - Race Alone)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=costburden, out=costb_total_pctprelim_alone);run;

*StdDev on Pct Cost Burdened (for Race Alone by Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=costburden, out=costb_puma_pctprelim_alone);run;

*StdDev on Pct Cost Burdened (for Race Alone by Race)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2, var=costburden, out=costb_race_pctprelim_alone);run;

*StdDev on Pct Cost Burdened (for Race Alone by Race & Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2*puma, var=costburden, out=costb_allvars_pctprelim_alone);run;

data costb_pct_alone;
set costb_total_pctprelim_alone (keep=mean stderr) costb_puma_pctprelim_alone (keep=mean puma stderr) costb_race_pctprelim_alone (keep=race_cat2 mean stderr) 
costb_allvars_pctprelim_alone (keep=race_cat2 puma mean stderr);
	category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
run;

data costb_r_freq_alone;
	set costb_totalr_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7;
		format category category.; 
run;

data costb_cb_freq_alone;
	set costb_totalcb_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=2;
			if race_cat2=2 then category=3;
			if race_cat2=3 then category=4; 
			format category category.;
run;

proc sort data=costb_alone0 out=costb_r_base_alone; by PUMA category; run;
proc sort data=costb_alone2 out=costb_cb_base_alone; by PUMA category; run;
proc sort data=costb_alone3 out=costb_pct_base_alone; by PUMA category; run;
proc sort data=costb_r_freq_alone out=costb_r_std_alone; by PUMA category; run;
proc sort data=costb_cb_freq_alone out=costb_cb_std_alone; by PUMA category; run;
proc sort data=costb_pct_alone out=costb_pct_std_alone; by PUMA category; run;

data data costb_alone0_stdincl;;
	merge costb_r_base_alone costb_r_std_alone (drop=wgtfreq race_cat2);
		by PUMA category;
		run;

data costb_alone2_stdincl;;
	merge costb_cb_base_alone costb_cb_std_alone (drop=wgtfreq race_cat2);
		by PUMA category;
		run;

data costb_alone3_stdincl;
	merge costb_pct_base_alone costb_pct_std_alone (drop=mean race_cat2);
		by PUMA category;
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

*StdDev on Count Total Renters (Foreign)*;
%survey_freq (input=costb_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
type=oneway, tables=puma, out=costb_totalr_freqprelim_for);run;

*StdDev on Count Cost Burdened (Foreign by PUMA)*;
%survey_freq (input=costb_index, where=%str(subpopvar=1 and costburden=1 and foreign=1), weight=hhwt, 
type=crosstabs, tables=costburden*puma, out=costb_totalcb_freqprelim_for);run;

*StdDev on Pct Cost Burdened (of Total - Foreign)*;
%survey_means (input=costb_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
domain=subpopvar, var=costburden, out=costb_total_pctprelim_for);run;

*StdDev on Pct Cost Burdened (by Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1  and foreign=1), weight=hhwt, 
domain=subpopvar*puma, var=costburden, out=costb_puma_pctprelim_for);run;


data costb_pct_for;
set costb_total_pctprelim_for (keep=mean stderr) costb_puma_pctprelim_for (keep=mean puma stderr);
	category=8;
		format category category.;
run;

data costb_r_freq_for;
	set costb_totalr_freqprelim_for(keep=wgtfreq stddev puma );
		category=8;
		format category category.; 
run;

data costb_cb_freq_for;
	set costb_totalcb_freqprelim_for(keep=wgtfreq stddev puma);
		category=8;
			format category category.;
run;

proc sort data=costb_for0 out=costb_r_base_for; by PUMA category; run;
proc sort data=costb_for2 out=costb_cb_base_for; by PUMA category; run;
proc sort data=costb_for3 out=costb_pct_base_for; by PUMA category; run;
proc sort data=costb_r_freq_for out=costb_r_std_for; by PUMA category; run;
proc sort data=costb_cb_freq_for out=costb_cb_std_for; by PUMA category; run;
proc sort data=costb_pct_for out=costb_pct_std_for; by PUMA category; run;

data costb_for0_stdincl;
	merge costb_r_base_for costb_r_std_for (drop=wgtfreq);
		by PUMA category;
		run;

data costb_for2_stdincl;
	merge costb_cb_base_for costb_cb_std_for (drop=wgtfreq);
		by PUMA category;
		run;

data costb_for3_stdincl;
	merge costb_pct_base_for costb_pct_std_for (drop=wgtfreq);
		by PUMA category;
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

data scostb_index;
set Equity.Acs_tables_ipums;
if city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 then subpopvar = 1;
else subpopvar = 0;
run;

proc sort data = scostb_index;
by strata cluster;
run;

*StdDev on Count Total Renters*;
%survey_freq (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat1, out=scostb_totalr_freqprelim);run;

*StdDev on Count SevCost Burdened*;
%survey_freq (input=scostb_index, where=%str(subpopvar=1 and sevcostburden=1), weight=hhwt, 
type=crosstabs, tables=sevcostburden*puma*race_cat1, out=scostb_totalcb_freqprelim);run;

*StdDev on Pct Sev Cost Burdened (of Total)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=sevcostburden, out=scostb_total_pctprelim);run;

*StdDev on Pct Sev Cost Burdened (by Puma)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=sevcostburden, out=scostb_puma_pctprelim);run;

*StdDev on Pct Sev Cost Burdened (by Race)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1, var=sevcostburden, out=scostb_race_pctprelim);run;

*StdDev on Pct Sev Cost Burdened (by Race & Puma)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1*puma, var=sevcostburden, out=scostb_allvars_pctprelim);run;

data scostb_pct;
set scostb_total_pctprelim (keep=mean stderr) scostb_puma_pctprelim (keep=mean puma stderr) scostb_race_pctprelim (keep=race_cat1 mean stderr) 
scostb_allvars_pctprelim (keep=race_cat1 puma mean stderr);
	category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
run;

data scostb_r_freq;
	set scostb_totalr_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data scostb_cb_freq;
	set scostb_totalcb_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

proc sort data=scostb_nhwh0 out=scostb_r_base; by PUMA category; run;
proc sort data=scostb_nhwh2 out=scostb_cb_base; by PUMA category; run;
proc sort data=scostb_nhwh3 out=scostb_pct_base; by PUMA category; run;
proc sort data=scostb_r_freq out=scostb_r_std; by PUMA category; run;
proc sort data=scostb_cb_freq out=scostb_cb_std; by PUMA category; run;
proc sort data=scostb_pct out=scostb_pct_std; by PUMA category; run;

data costb_NHWH0_stdincl;
	merge scostb_r_base scostb_r_std (drop=/*wgtfreq*/ race_cat1);
		by PUMA category;
		run;

data costb_NHWH2_stdincl;
	merge scostb_cb_base scostb_cb_std (drop=/*wgtfreq*/ race_cat1);
		by PUMA category;
		run;

data costb_NHWH3_stdincl;
	merge scostb_pct_base scostb_pct_std (drop=/*mean*/ race_cat1);
		by PUMA category;
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
																	total_PctSum_010 total_PctSum_000 total_PctSum_010 total_PctSum_011 total_PctSum_010 total_PctSum_001)
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

*StdDev on Count Total Renters (Race Alone)*;
%survey_freq (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat2, out=scostb_totalr_freqprelim_alone);run;

*StdDev on Count Sev Cost Burdened (Race Alone)*;
%survey_freq (input=scostb_index, where=%str(subpopvar=1 and sevcostburden=1), weight=hhwt, 
type=crosstabs, tables=sevcostburden*puma*race_cat2, out=scostb_totalcb_freqprelim_alone);run;

*StdDev on Pct Sev Cost Burdened (Total - Race Alone)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=sevcostburden, out=scostb_total_pctprelim_alone);run;

*StdDev on Pct Sev Cost Burdened (by Puma)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=sevcostburden, out=scostb_puma_pctprelim_alone);run;

*StdDev on Pct Sev Cost Burdened (by Race)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2, var=sevcostburden, out=scostb_race_pctprelim_alone);run;

*StdDev on Pct Sev Cost Burdened (by Race & Puma)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2*puma, var=sevcostburden, out=scostb_allvars_pctprelim_alone);run;

data scostb_pct_alone;
set scostb_total_pctprelim_alone (keep=mean stderr) scostb_puma_pctprelim_alone (keep=mean puma stderr) scostb_race_pctprelim_alone (keep=race_cat2 mean stderr) 
scostb_allvars_pctprelim_alone (keep=race_cat2 puma mean stderr);
	category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
run;

data scostb_r_freq_alone;
	set scostb_totalr_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7;
		format category category.; 
run;

data scostb_cb_freq_alone;
	set scostb_totalcb_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

proc sort data=scostb_alone0 out=scostb_r_base_alone; by PUMA category; run;
proc sort data=scostb_alone2 out=scostb_cb_base_alone; by PUMA category; run;
proc sort data=scostb_alone3 out=scostb_pct_base_alone; by PUMA category; run;
proc sort data=scostb_r_freq_alone out=scostb_r_std_alone; by PUMA category; run;
proc sort data=scostb_cb_freq_alone out=scostb_cb_std_alone; by PUMA category; run;
proc sort data=scostb_pct_alone out=scostb_pct_std_alone; by PUMA category; run;

data scostb_alone0_stdincl;
	merge scostb_r_base_alone scostb_r_std_alone (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;

data scostb_alone2_stdincl;
	merge scostb_cb_base_alone scostb_cb_std_alone (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;

data scostb_alone3_stdincl;
	merge scostb_pct_base_alone scostb_pct_std_alone (drop=/*mean*/ race_cat2);
		by PUMA category;
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

*StdDev on Count Total Renters (Foreign)*;
%survey_freq (input=scostb_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
type=oneway, tables=puma, out=scostb_totalr_freqprelim_for);run;

*StdDev on Count Cost Burdened (Foreign)*;
%survey_freq (input=scostb_index, where=%str(subpopvar=1 and sevcostburden=1 and foreign=1), weight=hhwt, 
type=crosstabs, tables=sevcostburden*puma, out=scostb_totalcb_freqprelim_for);run;

*StdDev on Pct Cost Burdened (Total - Foreign)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
domain=subpopvar, var=sevcostburden, out=scostb_total_pctprelim_for);run;

*StdDev on Pct Cost Burdened (by Puma)*;
%survey_means (input=scostb_index, where=%str(subpopvar=1  and foreign=1), weight=hhwt, 
domain=subpopvar*puma, var=sevcostburden, out=scostb_puma_pctprelim_for);run;


data scostb_pct_for;
set scostb_total_pctprelim_for (keep=mean stderr) scostb_puma_pctprelim_for (keep=mean puma stderr);
	category=8;
		format category category.;
run;

data scostb_r_freq_for;
	set scostb_totalr_freqprelim_for(keep=wgtfreq stddev puma );
		category=8;
		format category category.; 
run;

data scostb_cb_freq_for;
	set scostb_totalcb_freqprelim_for(keep=wgtfreq stddev puma);
		category=8;
			format category category.;
run;

proc sort data=scostb_for0 out=scostb_r_base_for; by PUMA category; run;
proc sort data=scostb_for2 out=scostb_cb_base_for; by PUMA category; run;
proc sort data=scostb_for3 out=scostb_pct_base_for; by PUMA category; run;
proc sort data=scostb_r_freq_for out=scostb_r_std_for; by PUMA category; run;
proc sort data=scostb_cb_freq_for out=scostb_cb_std_for; by PUMA category; run;
proc sort data=scostb_pct_for out=scostb_pct_std_for; by PUMA category; run;

data scostb_for0_stdincl;
	merge scostb_r_base_for scostb_r_std_for (drop=wgtfreq);
		by PUMA category;
		run;

data scostb_for2_stdincl;
	merge scostb_cb_base_for scostb_cb_std_for (drop=wgtfreq);
		by PUMA category;
		run;

data scostb_for3_stdincl;
	merge scostb_pct_base_for scostb_pct_std_for (drop=wgtfreq);
		by PUMA category;
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
		
data emp_index;
set Equity.Acs_tables_ipums;
if city=7230 and age25to64=1   then subpopvar = 1;
else subpopvar = 0;
/*Try to trick proc surveymeans*/
if emp25to64=.u then emptext="Out of LF";
	else if emp25to64=1 then emptext="Employed";
	else emptext="Unemployed";
run;

proc sort data = emp_index;
by strata cluster;
run;

*StdDev on Count Total People Ages 25 to 64 (by Race& PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1), options=missing, weight=perwt, 
type=crosstabs, tables=puma*race_cat1, out=emp_all_freqprelim);run;

*StdDev on Employed for Ages 25 to 64 (by Race & PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=1), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma*race_cat1, out=emp_emp_freqprelim);run;

*StdDev on Unemployed for Ages 25 to 64 (by Race & PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=0), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma*race_cat1, out=emp_umemp_freqprelim);run;

*StdDev on Out of LF for Ages 25 to 64 (by Race & PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=.u), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma*race_cat1, out=emp_outLF_freqprelim);run;

/***SurveyMeans does not include emp25to64=. or emp25to64=0. Check Friday morning. Do either nomcar or emptext work??**/

/*Try either NOMCAR or emptext

*StdDev on Pct Employed 25 to 64 (Total)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=,
domain=subpopvar, var=emptext, out=emp_total_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (by Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=, 
domain=subpopvar*puma, var=emptext, out=emp_puma_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (by Race)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=, 
domain=subpopvar*race_cat1, var=emptext, out=emp_race_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (by Race & Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=, 
domain=subpopvar*race_cat1*puma, var=emptext, out=emp_allvars_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (Total)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar, var=emp25to64, out=emp_total_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (by Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar*puma, var=emp25to64, out=emp_puma_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (by Race)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar*race_cat1, var=emp25to64, out=emp_race_pctprelim);run;

*StdDev on Pct Employed 25 to 64 (by Race & Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar*race_cat1*puma, var=emp25to64, out=emp_allvars_pctprelim);run;

data emp_pct;
set emp_total_pctprelim (keep=mean stderr) emp_puma_pctprelim (keep=mean puma stderr) emp_race_pctprelim (keep=race_cat1 mean stderr) 
emp_allvars_pctprelim (keep=race_cat1 puma mean stderr);
	category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
run;*/

data emp_all_freq;
	set emp_all_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data emp_emp_freq;
	set emp_emp_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data emp_unemp_freq;
	set emp_unemp_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data emp_outLF_freq;
	set emp_outLF_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

proc sort data=emp_nhwh0 out=emp_all_base; by PUMA category; run;
proc sort data=emp_nhwh2a out=emp_emp_base; by PUMA category; run;
proc sort data=emp_nhwh2b out=emp_unemp_base; by PUMA category; run;
proc sort data=emp_nhwh2c out=emp_outLF_base; by PUMA category; run;
/*try pcts
proc sort data=emp_nhwh3a out=emp_emp_pct_base; by PUMA category; run;
proc sort data=emp_nhwh3b out=emp_unemp_pct_base; by PUMA category; run;
proc sort data=emp_nhwh3c out=emp_outLF_pct_base; by PUMA category; run;*/
proc sort data=emp_all_freq out=emp_all_std; by PUMA category; run;
proc sort data=emp_emp_freq out=emp_emp_std; by PUMA category; run;
proc sort data=emp_unemp_freq out=emp_unemp_std; by PUMA category; run;
proc sort data=emp_outLF_freq out=emp_outLF_std; by PUMA category; run;
proc sort data=emp_pct out=emp_pct_std; by PUMA category; run;

data emp_NHWH0_stdincl;
	merge emp_all_base emp_all_std (drop=/*wgtfreq*/ race_cat1);
		by PUMA category;
		run;
		
data emp_NHWH2a_stdincl;
	merge emp_emp_base emp_emp_std (drop=/*wgtfreq*/ race_cat1);
		by PUMA category;
		run;
		
data emp_NHWH2b_stdincl;
	merge emp_unemp_base emp_unemp_std (drop=/*wgtfreq*/ race_cat1);
		by PUMA category;
		run;

data emp_NHWH2c_stdincl;
	merge emp_outLF_base emp_outLF_std (drop=/*wgtfreq*/ race_cat1);
		by PUMA category;
		run;
/**Check and make match!*/
data emp_pctincl;
	merge emp_emp_pct_base emp_unemp_pct_base emp_outLF_pct_base emp_pct_std (drop=/*mean*/ race_cat1);
		by PUMA category;
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

*StdDev on Count Total People Ages 25 to 64 (by Race& PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1), options=missing, weight=perwt, 
type=crosstabs, tables=puma*race_cat2, out=emp_all_freqprelim_alone);run;

*StdDev on Employed for Ages 25 to 64 (by Race & PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=1), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma*race_cat2, out=emp_emp_freqprelim_alone);run;

*StdDev on Unemployed for Ages 25 to 64 (by Race & PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=0), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma*race_cat2, out=emp_umemp_freqprelim_alone);run;

*StdDev on Out of LF for Ages 25 to 64 (by Race & PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=.u), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma*race_cat2, out=emp_outLF_freqprelim_alone);run;

/***SurveyMeans does not include emp25to64=. or emp25to64=0. Check Friday morning. Do either nomcar or emptext work??**/

/*Try either NOMCAR or emptext

*StdDev on Pct Employed 25 to 64 (Total)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=,
domain=subpopvar, var=emptext, out=emp_total_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (by Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=, 
domain=subpopvar*puma, var=emptext, out=emp_puma_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (by Race)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=, 
domain=subpopvar*race_cat2, var=emptext, out=emp_race_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (by Race & Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=, 
domain=subpopvar*race_cat2*puma, var=emptext, out=emp_allvars_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (Total)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar, var=emp25to64, out=emp_total_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (by Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar*puma, var=emp25to64, out=emp_puma_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (by Race)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar*race_cat2, var=emp25to64, out=emp_race_pctprelim_alone);run;

*StdDev on Pct Employed 25 to 64 (by Race & Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1), weight=perwt, option=NOMCAR, 
domain=subpopvar*race_cat2*puma, var=emp25to64, out=emp_allvars_pctprelim_alone);run;

data emp_pct_alone;
set emp_total_pctprelim_alone (keep=mean stderr) emp_puma_pctprelim_alone (keep=mean puma stderr) emp_race_pctprelim_alone (keep=race_cat2 mean stderr) 
emp_allvars_pctprelim_alone (keep=race_cat2 puma mean stderr);
	category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
run;*/

data emp_all_freq_alone;
	set emp_all_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data emp_emp_freq_alone;
	set emp_emp_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data emp_unemp_freq_alone;
	set emp_unemp_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data emp_outLF_freq_alone;
	set emp_outLF_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

proc sort data=emp_nhwh_alone0 out=emp_all_base_alone; by PUMA category; run;
proc sort data=emp_nhwh_alone2a out=emp_emp_base_alone; by PUMA category; run;
proc sort data=emp_nhwh_alone2b out=emp_unemp_base_alone; by PUMA category; run;
proc sort data=emp_nhwh_alone2c out=emp_outLF_base_alone; by PUMA category; run;
/*try pcts
proc sort data=emp_nhwh_alone3a out=emp_emp_pct_base_alone; by PUMA category; run;
proc sort data=emp_nhwh_alone3b out=emp_unemp_pct_base_alone; by PUMA category; run;
proc sort data=emp_nhwh_alone3c out=emp_outLF_pct_base_alone; by PUMA category; run;*/
proc sort data=emp_all_freq_alone out=emp_all_std_alone; by PUMA category; run;
proc sort data=emp_emp_freq_alone out=emp_emp_std_alone; by PUMA category; run;
proc sort data=emp_unemp_freq_alone out=emp_unemp_std_alone; by PUMA category; run;
proc sort data=emp_outLF_freq_alone out=emp_outLF_std_alone; by PUMA category; run;
proc sort data=emp_pct_alone out=emp_pct_std_alone; by PUMA category; run;

data emp_NHWH_alone0_stdincl;
	merge emp_all_base_alone emp_all_std_alone (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;
		
data emp_NHWH_alone2a_stdincl;
	merge emp_emp_base_alone emp_emp_std_alone (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;
		
data emp_NHWH_alone2b_stdincl;
	merge emp_unemp_base_alone emp_unemp_std_alone (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;

data emp_NHWH_alone2c_stdincl;
	merge emp_outLF_base_alone emp_outLF_std_alone (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;

/**Check tomorrow!*/
data emp_pctincl_alone;
	merge emp_emp_pct_base_alone emp_unemp_pct_base_alone emp_outLF_unemp_pct_base_alone emp_pct_std_alone (drop=/*mean*/ race_cat2);
		by PUMA category;
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

*StdDev on Count Total People Ages 25 to 64 (Foreign)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and foreign=1), options=missing, weight=perwt, 
type=crosstabs, tables=puma, out=emp_all_freqprelim_for);run;

*StdDev on Employed for Ages 25 to 64 (by PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=1 and foreign=1), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma out=emp_emp_freqprelim_for);run;

*StdDev on Unemployed for Ages 25 to 64 (by PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=0 and foreign=1), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma, out=emp_umemp_freqprelim_for);run;

*StdDev on Out of LF for Ages 25 to 64 (by PUMA)*;
%survey_freq (input=emp_index, where=%str(subpopvar=1 and emp25to64=.u and foreign=1), options=missing, weight=perwt, 
type=crosstabs, tables=emp25to64*puma, out=emp_outLF_freqprelim_for);run;

*StdDev on Pct Employed 25 to 64 (Total)*;
%survey_means (input=emp_index, where=%str(subpopvar=1 and foreign=1), weight=perwt, option=,
domain=subpopvar, var=emptext, out=emp_total_pctprelim_for);run;

*StdDev on Pct Employed 25 to 64 (by Puma)*;
%survey_means (input=emp_index, where=%str(subpopvar=1 and foreign=1), weight=perwt, option=, 
domain=subpopvar*puma, var=emptext, out=emp_puma_pctprelim_for);run;

data emp_pct_for;
set emp_total_pctprelim_for (keep=mean stderr) scostb_puma_pctprelim_for (keep=mean puma stderr);
	category=8;
		format category category.;
run;

data emp_all_freq_for;
	set emp_all_freqprelim_for(keep=wgtfreq stddev puma );
		category=8;
		format category category.; 
run;

data emp_emp_freq_for;
	set emp_emp_freqprelim_for(keep=wgtfreq stddev puma );
		category=8;
		format category category.; 
run;

data emp_unemp_freq_for;
	set emp_unemp_freqprelim_for(keep=wgtfreq stddev puma );
		category=8;
		format category category.; 
run;

data emp_outLF_freq_for;
	set emp_outLF_freqprelim_for(keep=wgtfreq stddev puma );
		category=8;
		format category category.; 
run;

proc sort data=emp_nhwh_for0 out=emp_all_base_for; by PUMA category; run;
proc sort data=emp_nhwh_for2a out=emp_emp_base_for; by PUMA category; run;
proc sort data=emp_nhwh_for2b out=emp_unemp_base_for; by PUMA category; run;
proc sort data=emp_nhwh_for2c out=emp_outLF_base_for; by PUMA category; run;
/*try pcts
proc sort data=emp_nhwh_for3a out=emp_emp_pct_base_for; by PUMA category; run;
proc sort data=emp_nhwh_for3b out=emp_unemp_pct_base_for; by PUMA category; run;
proc sort data=emp_nhwh_for3c out=emp_outLF_pct_base_for; by PUMA category; run;*/
proc sort data=emp_all_freq_for out=emp_all_std_for; by PUMA category; run;
proc sort data=emp_emp_freq_for out=emp_emp_std_for; by PUMA category; run;
proc sort data=emp_unemp_freq_for out=emp_unemp_std_for; by PUMA category; run;
proc sort data=emp_outLF_freq_for out=emp_outLF_std_for; by PUMA category; run;
proc sort data=emp_pct_for out=emp_pct_std_for; by PUMA category; run;

data emp_NHWH_for0_stdincl;
	merge emp_all_base_for emp_all_std_for (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;
		
data emp_NHWH_for2a_stdincl;
	merge emp_emp_base_for emp_emp_std_for (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;
		
data emp_NHWH_for2b_stdincl;
	merge emp_unemp_base_for emp_unemp_std_for (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;

data emp_NHWH_for2c_stdincl;
	merge emp_outLF_base_for emp_outLF_std_for (drop=/*wgtfreq*/ race_cat2);
		by PUMA category;
		run;

/**Check!*/
data emp_pctincl_for;
	merge emp_pct_base_for emp_pct_std_for (drop=/*mean*/ race_cat2);
		by PUMA category;
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
		
data mort_index;
set Equity.Acs_tables_ipums;
if city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 then subpopvar = 1;
else subpopvar = 0;
/*Try to trick proc surveymeans*/
if ownmort=1 then owntext="Owned with Mortgage";
	else if ownmort=0 then owntext="Owned Free and Clear";
run;

proc sort data = mort_index;
by strata cluster;
run;

*StdDev on Count Total Owners (by Puma and Race))*;
%survey_freq (input=mort_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat1, out=mort_o_freqprelim);run;

*StdDev on Count Own with Mortgage (by Puma and Race)*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and ownmortgage=1), weight=hhwt, 
type=crosstabs, tables=ownmortgage*puma*race_cat1, out=mort_om_freqprelim);run;

*StdDev on Count Own Free and Clear (by Puma and Race)*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and ownmortgage=0), weight=hhwt, 
type=crosstabs, tables=ownmortgage*puma*race_cat1, out=mort_ofc_freqprelim);run;

*StdDev on Pct Own with Mortgage (of Total)*;
%survey_means (input=mort_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=ownmortgage, out=mort_total_pctprelim);run;

*StdDev on Pct Own with Mortgage (by Puma Only)*;
%survey_means (input=mort_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=ownmortgage out=mort_puma_pctprelim);run;

*StdDev on Pct Own with Mortgage (by Race Only)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1, var=ownmortgage, out=mort_race_pctprelim);run;

*StdDev on Pct Own with Mortgage (by Race & Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1*puma, var=ownmortgage, out=mort_allvars_pctprelim);run;

data mort_pct;
set mort_total_pctprelim (keep=mean stderr) mort_puma_pctprelim (keep=mean puma stderr) mort_race_pctprelim (keep=race_cat1 mean stderr) 
mort_allvars_pctprelim (keep=race_cat1 puma mean stderr);
	category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
run;

data mort_o_freq;
	set mort_o_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data mort_om_freq;
	set mort_om_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data mort_ofc_freq;
	set mort_ofc_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

proc sort data=mort_nhwh0 out=mort_o_base; by PUMA category; run;
proc sort data=mort_nhwh2a out=mort_om_base; by PUMA category; run;
proc sort data=mort_nhwh2b out=mort_ofc_base; by PUMA category; run;
/*try pcts
proc sort data=mort_nhwh3a out=mort_om_pct_base; by PUMA category; run;
proc sort data=mort_nhwh3b out=mort_ofc_pct_base; by PUMA category; run;*/
proc sort data=mort_o_freq out=mort_o_std; by PUMA category; run;
proc sort data=mort_om_freq out=mort_om_std; by PUMA category; run;
proc sort data=mort_ofc_freq out=mort_ofc_std; by PUMA category; run;
proc sort data=mort_pct out=mort_pct_std; by PUMA category; run;

data mort_nhwh0_stdincl;
	merge mort_o_base mort_o_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;

data mort_nhwh2a_stdincl;
	merge mort_om_base mort_om_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;
		
data mort_nhwh2b_stdincl;
	merge mort_ofc_base mort_ofc_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;
/**Check!!*/
data mort_pctincl;
	merge mort_om_pct_base mort_ofc_pct_base mort_pct_std (drop=mean race_cat1);
		by PUMA category;
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
	
*StdDev on Count Total Owners (by Puma and Race))*;
%survey_freq (input=mort_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat2, out=mort_o_freqprelim_alone);run;

*StdDev on Count Own with Mortgage (by Puma and Race)*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and ownmortgage=1), weight=hhwt, 
type=crosstabs, tables=ownmortgage*puma*race_cat2, out=mort_om_freqprelim_alone);run;

*StdDev on Count Own Free and Clear (by Puma and Race)*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and ownmortgage=0), weight=hhwt, 
type=crosstabs, tables=ownmortgage*puma*race_cat2, out=mort_ofc_freqprelim_alone);run;

*StdDev on Pct Own with Mortgage (of Total)*;
%survey_means (input=mort_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=ownmortgage, out=mort_total_pctprelim_alone);run;

*StdDev on Pct Own with Mortgage (by Puma Only)*;
%survey_means (input=mort_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=ownmortgage out=mort_puma_pctprelim_alone);run;

*StdDev on Pct Own with Mortgage (by Race Only)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2, var=ownmortgage, out=mort_race_pctprelim_alone);run;

*StdDev on Pct Own with Mortgage (by Race & Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2*puma, var=ownmortgage, out=mort_allvars_pctprelim_alone);run;

data mort_pct_alone;
set mort_total_pctprelim_alone (keep=mean stderr) mort_puma_pctprelim_alone (keep=mean puma stderr) mort_race_pctprelim_alone (keep=race_cat2 mean stderr) 
mort_allvars_pctprelim_alone (keep=race_cat2 puma mean stderr);
	category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
run;

data mort_o_freq_alone;
	set mort_o_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data mort_om_freq_alone;
	set mort_om_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data mort_ofc_freq_alone;
	set mort_ofc_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7;  
			format category category.;
run;

proc sort data=mort_nhwh_alone0 out=mort_o_base_alone; by PUMA category; run;
proc sort data=mort_nhwh_alone2a out=mort_om_base_alone; by PUMA category; run;
proc sort data=mort_nhwh_alone2b out=mort_ofc_base_alone; by PUMA category; run;
/*try pcts
proc sort data=mort_nhwh_alone3a out=mort_om_pct_base_alone; by PUMA category; run;
proc sort data=mort_nhwh_alone3b out=mort_ofc_pct_base_alone; by PUMA category; run;*/
proc sort data=mort_o_freq_alone out=mort_o_std_alone; by PUMA category; run;
proc sort data=mort_om_freq_alone out=mort_om_std_alone; by PUMA category; run;
proc sort data=mort_ofc_freq_alone out=mort_ofc_std_alone; by PUMA category; run;
proc sort data=mort_pct_alone out=mort_pct_std_alone; by PUMA category; run;

data mort_nhwh_alone0_stdincl;
	merge mort_o_base_alone mort_o_std_alone (drop=wgtfreq race_cat2);
		by PUMA category;
		run;

data mort_nhwh_alone2a_stdincl;
	merge mort_om_base_alone mort_om_std_alone (drop=wgtfreq race_cat2_alone);
		by PUMA category;
		run;
		
data mort_nhwh_alone2b_stdincl;
	merge mort_ofc_base_alone mort_ofc_std_alone (drop=wgtfreq race_cat2);
		by PUMA category;
		run;

/**Check!*/
data mort_pctincl_alone;
	merge mort_om_pct_base_alone mort_ofc_pct_base_alone mort_pct_std_alone (drop=mean race_cat2);
		by PUMA category;
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
		
*StdDev on Count Total Owners (by Puma))*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
type=crosstabs, tables=puma, out=mort_o_freqprelim_for);run;

*StdDev on Count Own with Mortgage (by Puma )*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and ownmortgage=1 and foreign=1), weight=hhwt, 
type=crosstabs, tables=ownmortgage*puma, out=mort_om_freqprelim_for);run;

*StdDev on Count Own Free and Clear (by Puma and Race)*;
%survey_freq (input=mort_index, where=%str(subpopvar=1 and ownmortgage=0 and foreign=1), weight=hhwt, 
type=crosstabs, tables=ownmortgage*puma, out=mort_ofc_freqprelim_for);run;

*StdDev on Pct Own with Mortgage (of Total)*;
%survey_means (input=mort_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
domain=subpopvar, var=ownmortgage, out=mort_total_pctprelim_for);run;

*StdDev on Pct Own with Mortgage (by Puma Only)*;
%survey_means (input=mort_index, where=%str(subpopvar=1 and foreign=1), weight=hhwt, 
domain=subpopvar*puma, var=ownmortgage out=mort_puma_pctprelim_for);run;

data mort_pct_for;
set mort_total_pctprelim_for (keep=mean stderr) mort_puma_pctprelim_for (keep=mean puma stderr);
	category=8;
		format category category.;
run;

data mort_o_freq_for;
	set mort_o_freqprelim_for (keep=wgtfreq stddev puma);
		category=8;
			format category category.;
run;

data mort_om_freq_for;
	set mort_om_freqprelim_for (keep=wgtfreq stddev puma );
		category=8;
			format category category.;
run;

data mort_ofc_freq_for;
	set mort_ofc_freqprelim_for (keep=wgtfreq stddev puma );
		category=8;
			format category category.;
run;

proc sort data=mort_nhwh_for0 out=mort_o_base_for; by PUMA category; run;
proc sort data=mort_nhwh_for2a out=mort_om_base_for; by PUMA category; run;
proc sort data=mort_nhwh_for2b out=mort_ofc_base_for; by PUMA category; run;
/*try pcts
proc sort data=mort_nhwh_for3a out=mort_om_pct_base_for; by PUMA category; run;
proc sort data=mort_nhwh_for3b out=mort_ofc_pct_base_for; by PUMA category; run;*/
proc sort data=mort_o_freq_for out=mort_o_std_for; by PUMA category; run;
proc sort data=mort_om_freq_for out=mort_om_std_for; by PUMA category; run;
proc sort data=mort_ofc_freq_for out=mort_ofc_std_for; by PUMA category; run;
proc sort data=mort_pct_for out=mort_pct_std_for; by PUMA category; run;

data mort_nhwh_for0_stdincl;
	merge mort_o_base_for mort_o_std_for (drop=wgtfreq);
		by PUMA category;
		run;

data mort_nhwh_for2a_stdincl;
	merge mort_om_base_for mort_om_std_for (drop=wgtfreq);
		by PUMA category;
		run;
		
data mort_nhwh_for2b_stdincl;
	merge mort_ofc_base_for mort_ofc_std_for(drop=wgtfreq);
		by PUMA category;
		run;

/*check!*/
data mort_pctincl_for;
	merge mort_om_pct_base_for mort_ofc_pct_base_for mort_pct_std_for (drop=mean);
		by PUMA category;
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
		
data aff_index;
set Equity.Acs_tables_ipums;
if city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 then subpopvar = 1;
else subpopvar = 0;
/*Try to trick proc surveymeans*/
if aff_unit=1 then afftext="ELI";
	else if aff_unit=2 then afftext="VLI";
	else if aff_unit=3 then afftext="LI";
	else afftext="MHI";
run;

proc sort data = aff_index;
by strata cluster;
run;

*StdDev on Count Total Renters (by Puma and Race))*;
%survey_freq (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat1, out=aff_all_freqprelim);run;

*StdDev on Count ELI Renters (by Puma and Race)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=1), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat1, out=aff_eli_freqprelim);run;

*StdDev on Count VLI Renters (by Puma and Race)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=2), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat1, out=aff_li_freqprelim);run;

*StdDev on Count LLI Renters (by Puma and Race)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=3), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat1, out=aff_li_freqprelim);run;

*StdDev on Count MHI Renters (by Puma and Race)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=4), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat1, out=aff_li_freqprelim);run;

*StdDev on Pct Affordability Level (of Total)*;
%survey_means (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=aff_unit, out=aff_total_pctprelim);run;

*StdDev on Pct Affordability Level (by Puma Only)*;
%survey_means (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=aff_unit out=aff_puma_pctprelim);run;

*StdDev on Pct Affordability Level (by Race Only)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1, var=aff_unit, out=aff_race_pctprelim);run;

*StdDev on Pct Affordability Level (by Race & Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat1*puma, var=aff_unit, out=aff_allvars_pctprelim);run;

data aff_pct;
set aff_total_pctprelim (keep=mean stderr) aff_puma_pctprelim (keep=mean puma stderr) aff_race_pctprelim (keep=race_cat1 mean stderr) 
aff_allvars_pctprelim (keep=race_cat1 puma mean stderr);
	category=.;
		if race_cat1=1 then category=2;
		if race_cat1=2 then category=3;
		if race_cat1=3 then category=4; 
		format category category.;
run;

data aff_all_freq;
	set aff_all_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data aff_eli_freq;
	set aff_eli_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data aff_vli_freq;
	set aff_vli_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data aff_li_freq;
	set aff_li_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

data aff_mhi_freq;
	set aff_mhi_freqprelim (keep=wgtfreq stddev puma race_cat1);
		category=.;
			if race_cat1=1 then category=2;
			if race_cat1=2 then category=3;
			if race_cat1=3 then category=4; 
			format category category.;
run;

proc sort data=aff_nhwh0 out=aff_all_base; by PUMA category; run;
proc sort data=aff_nhwh2a out=aff_eli_base; by PUMA category; run;
proc sort data=aff_nhwh2b out=aff_vli_base; by PUMA category; run;
proc sort data=aff_nhwh2c out=aff_li_base; by PUMA category; run;
proc sort data=aff_nhwh2d out=aff_mhi_base; by PUMA category; run;
/*try pcts
proc sort data=aff_nhwh3a out=aff_eli_pct_base; by PUMA category; run;
proc sort data=aff_nhwh3b out=aff_li_pct_base; by PUMA category; run;
proc sort data=aff_nhwh3c out=aff_li_pct_base; by PUMA category; run;
proc sort data=aff_nhwh3d out=aff_mhi_pct_base; by PUMA category; run;*/
proc sort data=aff_all_freq out=aff_all_std; by PUMA category; run;
proc sort data=aff_eli_freq out=aff_eli_std; by PUMA category; run;
proc sort data=aff_vli_freq out=aff_vli_std; by PUMA category; run;
proc sort data=aff_li_freq out=aff_li_std; by PUMA category; run;
proc sort data=aff_mhi_freq out=aff_mhi_std; by PUMA category; run;
proc sort data=aff_pct out=aff_pct_std; by PUMA category; run;

data aff_nhwh0_stdincl;
	merge aff_all_base aff_all_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;

data aff_nhwh2a_stdincl;
	merge aff_eli_base aff_eli_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;
		
data aff_nhwh2b_stdincl;
	merge aff_eli_base aff_vli_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;
		
data aff_nhwh2c_stdincl;
	merge aff_li_base aff_li_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;
		
data aff_nhwh2d_stdincl;
	merge aff_eli_base aff_mhi_std (drop=wgtfreq race_cat1);
		by PUMA category;
		run;
		
data aff_pctincl;
	merge aff_eli_pct_base aff_vli_pct_base aff_li_pct_base aff_mhi_pct_base aff_pct_std (drop=mean race_cat1);
		by PUMA category;
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

*StdDev on Count Total Renters (by Puma and Race Alone))*;
%survey_freq (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma*race_cat2, out=aff_all_freqprelim_alone);run;

*StdDev on Count ELI Renters (by Puma and Race Alone)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=1), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat2, out=aff_eli_freqprelim_alone);run;

*StdDev on Count VLI Renters (by Puma and Race Alone)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=2), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat2, out=aff_li_freqprelim_alone);run;

*StdDev on Count LLI Renters (by Puma and Race Alone)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=3), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat2, out=aff_li_freqprelim_alone);run;

*StdDev on Count MHI Renters (by Puma and Race Alone)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=4), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma*race_cat2, out=aff_li_freqprelim_alone);run;

*StdDev on Pct Affordability Level (of Total)*;
%survey_means (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=aff_unit, out=aff_total_pctprelim_alone);run;

*StdDev on Pct Affordability Level (by Puma Only)*;
%survey_means (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=aff_unit out=aff_puma_pctprelim_alone);run;

*StdDev on Pct Affordability Level (by Race Alone Only)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2, var=aff_unit, out=aff_race_pctprelim_alone);run;

*StdDev on Pct Affordability Level (by Race Alone & Puma)*;
%survey_means (input=costb_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*race_cat2*puma, var=aff_unit, out=aff_allvars_pctprelim_alone);run;

data aff_pct;
set aff_total_pctprelim_alone (keep=mean stderr) aff_puma_pctprelim_alone (keep=mean puma stderr) aff_race_pctprelim_alone (keep=race_cat2 mean stderr) 
aff_allvars_pctprelim_alone (keep=race_cat2 puma mean stderr);
	category=.;
		if race_cat2=1 then category=5;
		if race_cat2=2 then category=6;
		if race_cat2=3 then category=7; 
		format category category.;
run;

data aff_all_freq_alone;
	set aff_all_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data aff_eli_freq_alone;
	set aff_eli_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data aff_vli_freq_alone;
	set aff_vli_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data aff_li_freq_alone;
	set aff_li_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

data aff_mhi_freq_alone;
	set aff_mhi_freqprelim_alone (keep=wgtfreq stddev puma race_cat2);
		category=.;
			if race_cat2=1 then category=5;
			if race_cat2=2 then category=6;
			if race_cat2=3 then category=7; 
			format category category.;
run;

proc sort data=aff_nhwh_alone 0 out=aff_all_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 2a out=aff_eli_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 2b out=aff_vli_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 2c out=aff_li_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 2d out=aff_mhi_base_alone; by PUMA category; run;
/*try pcts
proc sort data=aff_nhwh_alone 3a out=aff_eli_pct_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 3b out=aff_li_pct_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 3c out=aff_li_pct_base_alone; by PUMA category; run;
proc sort data=aff_nhwh_alone 3d out=aff_mhi_pct_base_alone; by PUMA category; run;*/
proc sort data=aff_all_freq_alone out=aff_all_std_alone _alone; by PUMA category; run;
proc sort data=aff_eli_freq_alone out=aff_eli_std_alone _alone; by PUMA category; run;
proc sort data=aff_vli_freq_alone out=aff_vli_std_alone _alone; by PUMA category; run;
proc sort data=aff_li_freq_alone out=aff_li_std_alone _alone; by PUMA category; run;
proc sort data=aff_mhi_freq_alone out=aff_mhi_std_alone _alone; by PUMA category; run;
proc sort data=aff_pct_alone out=aff_pct_std_alone _alone; by PUMA category; run;

data aff_nhwh_alone0_stdincl;
	merge aff_all_base_alone aff_all_std_alone  (drop=wgtfreq race_cat2);
		by PUMA category;
		run;

data aff_nhwh_alone2a_stdincl;
	merge aff_eli_base_alone aff_eli_std_alone  (drop=wgtfreq race_cat2);
		by PUMA category;
		run;
		
data aff_nhwh_alone2b_stdincl;
	merge aff_eli_base_alone aff_vli_std_alone  (drop=wgtfreq race_cat2);
		by PUMA category;
		run;
		
data aff_nhwh_alone2c_stdincl;
	merge aff_li_base_alone aff_li_std_alone  (drop=wgtfreq race_cat2);
		by PUMA category;
		run;
		
data aff_nhwh_alone2d_stdincl;
	merge aff_eli_base_alone aff_mhi_std_alone  (drop=wgtfreq race_cat2);
		by PUMA category;
		run;

/*check!*/	
data aff_pctincl_alone;
	merge aff_eli_pct_base_alone aff_vli_pct_base_alone aff_li_pct_base_alone aff_mhi_pct_base_alone aff_pct_std_alone  (drop=mean race_cat2);
		by PUMA category;
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

*StdDev on Count Total Renters (by Puma))*;
%survey_freq (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
type=crosstabs, tables=puma, out=aff_all_freqprelim_for);run;

*StdDev on Count ELI Renters (by Puma)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=1), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma, out=aff_eli_freqprelim_for);run;

*StdDev on Count VLI Renters (by Puma)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=2), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma, out=aff_li_freqprelim_for);run;

*StdDev on Count LLI Renters (by Puma)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=3), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma, out=aff_li_freqprelim_for);run;

*StdDev on Count MHI Renters (by Puma)*;
%survey_freq (input=aff_index, where=%str(subpopvar=1 and aff_unit=4), weight=hhwt, 
type=crosstabs, tables=aff_unit*puma, out=aff_li_freqprelim_for);run;

*StdDev on Pct Affordability Level (of Total)*;
%survey_means (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar, var=aff_unit, out=aff_total_pctprelim_for);run;

*StdDev on Pct Affordability Level (by Puma Only)*;
%survey_means (input=aff_index, where=%str(subpopvar=1), weight=hhwt, 
domain=subpopvar*puma, var=aff_unit out=aff_puma_pctprelim_for);run;

data aff_pct;
set aff_total_pctprelim_for (keep=mean stderr) aff_puma_pctprelim_for (keep=mean puma stderr);
	category=8; 
		format category category.;
run;

data aff_all_freq_for;
	set aff_all_freqprelim_for (keep=wgtfreq stddev puma);
		category=8;
			format category category.;
run;

data aff_eli_freq_for;
	set aff_eli_freqprelim_for (keep=wgtfreq stddev puma);
		category=9; 
			format category category.;
run;

data aff_vli_freq_for;
	set aff_vli_freqprelim_for (keep=wgtfreq stddev puma);
		category=.; 
			format category category.;
run;

data aff_li_freq_for;
	set aff_li_freqprelim_for (keep=wgtfreq stddev puma);
		category=.; 
			format category category.;
run;

data aff_mhi_freq_for;
	set aff_mhi_freqprelim_for (keep=wgtfreq stddev puma);
		category=.; 
			format category category.;
run;

proc sort data=aff_nhwh_for_0 out=aff_all_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_2a out=aff_eli_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_2b out=aff_vli_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_2c out=aff_li_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_2d out=aff_mhi_base_for; by PUMA category; run;
/*try pcts
proc sort data=aff_nhwh_for_3a out=aff_eli_pct_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_3b out=aff_li_pct_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_3c out=aff_li_pct_base_for; by PUMA category; run;
proc sort data=aff_nhwh_for_3d out=aff_mhi_pct_base_for; by PUMA category; run;*/
proc sort data=aff_all_freq_for out=aff_all_std_for _for; by PUMA category; run;
proc sort data=aff_eli_freq_for out=aff_eli_std_for _for; by PUMA category; run;
proc sort data=aff_vli_freq_for out=aff_vli_std_for _for; by PUMA category; run;
proc sort data=aff_li_freq_for out=aff_li_std_for _for; by PUMA category; run;
proc sort data=aff_mhi_freq_for out=aff_mhi_std_for _for; by PUMA category; run;
proc sort data=aff_pct_for out=aff_pct_std_for _for; by PUMA category; run;

data aff_nhwh_for0_stdincl;
	merge aff_all_base_for aff_all_std_for  (drop=wgtfreq);
		by PUMA category;
		run;

data aff_nhwh_for2a_stdincl;
	merge aff_eli_base_for aff_eli_std_for  (drop=wgtfreq);
		by PUMA category;
		run;
		
data aff_nhwh_for2b_stdincl;
	merge aff_eli_base_for aff_vli_std_for  (drop=wgtfreq);
		by PUMA category;
		run;
		
data aff_nhwh_for2c_stdincl;
	merge aff_li_base_for aff_li_std_for  (drop=wgtfreq);
		by PUMA category;
		run;
		
data aff_nhwh_for2d_stdincl;
	merge aff_eli_base_for aff_mhi_std_for  (drop=wgtfreq);
		by PUMA category;
		run;

/*check!*/	
data aff_pctincl_for;
	merge aff_eli_pct_base_for aff_vli_pct_base_for aff_li_pct_base_for aff_mhi_pct_base_for aff_pct_std_for  (drop=mean);
		by PUMA category;
		run;


*Merge files together;
		proc sort data=costb_nhwh0_stdincl;
		by PUMA category;
		proc sort data=costb_nhwh2_stdincl;
		by PUMA category;
		proc sort data=costb_nhwh3_stdincl;
		by PUMA category;
		proc sort data=costb_alone0_stdincl;
		by PUMA category;
		proc sort data=costb_alone2_stdincl;
		by PUMA category;
		proc sort data=costb_alone3_stdincl;
		by PUMA category;
		proc sort data=costb_for0_stdincl;
		by PUMA category;
		proc sort data=costb_for2_stdincl;
		by PUMA category;
		proc sort data=costb_for3_stdincl;
		by PUMA category;
		proc sort data=scostb_nhwh2_stdincl;
		by PUMA category;
		proc sort data=scostb_nhwh3_stdincl;
		by PUMA category;
		proc sort data=scostb_alone2_stdincl;
		by PUMA category;
		proc sort data=scostb_alone3_stdincl;
		by PUMA category;
		proc sort data=scostb_for2_stdincl;
		by PUMA category;
		proc sort data=scostb_for3_stdincl;
		by PUMA category;
		proc sort data=mort_nhwh0_stdincl;
		by PUMA category;
		proc sort data=mort_nhwh2a_stdincl;
		by PUMA category;
		proc sort data=mort_nhwh2b_stdincl;
		by PUMA category;
		proc sort data=mort_nhwh3a_stdincl;
		by PUMA category;
		proc sort data=mort_nhwh3b_stdincl;
		by PUMA category;
		proc sort data=mort_alone0_stdincl;
		by PUMA category;
		proc sort data=mort_alone2a_stdincl;
		by PUMA category;
		proc sort data=mort_alone2b_stdincl;
		by PUMA category;
		proc sort data=mort_alone3a_stdincl;
		by PUMA category;
		proc sort data=mort_alone3b_stdincl;
		by PUMA category;
		proc sort data=mort_for0_stdincl;
		by PUMA category;
		proc sort data=mort_for2a_stdincl;
		by PUMA category;
		proc sort data=mort_for2b_stdincl;
		by PUMA category;
		proc sort data=mort_for3a_stdincl;
		by PUMA category;
		proc sort data=mort_for3b_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh2a_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh2b_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh2c_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh2d_stdincl;
		by PUMA category;
		proc sort data=aff_alone2a_stdincl;
		by PUMA category;
		proc sort data=aff_alone2b_stdincl;
		by PUMA category;
		proc sort data=aff_alone2c_stdincl;
		by PUMA category;
		proc sort data=aff_alone2d_stdincl;
		by PUMA category;
		proc sort data=aff_for2a_stdincl;
		by PUMA category;
		proc sort data=aff_for2b_stdincl;
		by PUMA category;
		proc sort data=aff_for2c_stdincl;
		by PUMA category;
		proc sort data=aff_for2d_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh3a_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh3b_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh3c_stdincl;
		by PUMA category;
		proc sort data=aff_nhwh3d_stdincl;
		by PUMA category;
		proc sort data=aff_alone3a_stdincl;
		by PUMA category;
		proc sort data=aff_alone3b_stdincl;
		by PUMA category;
		proc sort data=aff_alone3c_stdincl;
		by PUMA category;
		proc sort data=aff_alone3d_stdincl;
		by PUMA category;
		proc sort data=aff_for3a_stdincl;
		by PUMA category;
		proc sort data=aff_for3b_stdincl;
		by PUMA category;
		proc sort data=aff_for3c_stdincl;
		by PUMA category;
		proc sort data=aff_for3d_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh0_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh2a_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh2b_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh2c_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh3a_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh3b_stdincl;
		by PUMA category;
		proc sort data=emp_nhwh3c_stdincl;
		by PUMA category;
		proc sort data=emp_alone0_stdincl;
		by PUMA category;
		proc sort data=emp_alone2a_stdincl;
		by PUMA category;
		proc sort data=emp_alone2b_stdincl;
		by PUMA category;
		proc sort data=emp_alone2c_stdincl;
		by PUMA category;
		proc sort data=emp_alone3a_stdincl;
		by PUMA category;
		proc sort data=emp_alone3b_stdincl;
		by PUMA category;
		proc sort data=emp_alone3c_stdincl;
		by PUMA category;
		proc sort data=emp_for0_stdincl;
		by PUMA category; 
		proc sort data=emp_for2a_stdincl;
		by PUMA category;
		proc sort data=emp_for2b_stdincl;
		by PUMA category;
		proc sort data=emp_for2c_stdincl;
		by PUMA category;
		proc sort data=emp_for3a_stdincl;
		by PUMA category;
		proc sort data=emp_for3b_stdincl;
		by PUMA category;
		proc sort data=emp_for3c_stdincl;
		by PUMA category;
		data merged_data;
		merge costb_nhwh0_stdincl costb_nhwh2_stdincl costb_nhwh3_stdincl costb_alone0_stdincl (where=(category~=.)) costb_alone2_stdincl  (where=(category~=.)) costb_alone3_stdincl  (where=(category~=.)) 
			 costb_for0_stdincl costb_for2_stdincl  costb_for3_stdincl  
			 scostb_nhwh2_stdincl scostb_nhwh3_stdincl scostb_alone2_stdincl  (where=(category~=.)) scostb_alone3 (where=(category~=.))  scostb_for2 scostb_for3
			 mort_nhwh0_stdincl mort_nhwh2a_stdincl mort_nhwh2b_stdincl mort_nhwh3a_stdincl  mort_nhwh3b_stdincl  mort_alone0_stdincl (where=(category~=.)) mort_alone2a_stdincl  (where=(category~=.)) mort_alone2b_stdincl  (where=(category~=.))
			 mort_alone3a_stdincl  (where=(category~=.)) mort_alone3b_stdincl  (where=(category~=.))  mort_for0_stdincl mort_for2a_stdincl  mort_for2b_stdincl  mort_for3a_stdincl  mort_for3b_stdincl  
			 aff_nhwh2a_stdincl aff_nhwh2b_stdincl aff_nhwh2c_stdincl aff_nhwh2d_stdincl  aff_alone2a_stdincl  aff_alone2b_stdincl  aff_alone2c_stdincl  aff_alone2d_stdincl  aff_for2a_stdincl  aff_for2b_stdincl  aff_for2c_stdincl  aff_for2d_stdincl  
			aff_nhwh3a_stdincl  aff_nhwh3b_stdincl  aff_nhwh3c_stdincl  aff_nhwh3d_stdincl  aff_alone3a_stdincl  aff_alone3b_stdincl  aff_alone3c_stdincl  aff_alone3d_stdincl  aff_for3a_stdincl  aff_for3b_stdincl  aff_for3c_stdincl  aff_for3d_stdincl  
			emp_nhwh0_stdincl emp_nhwh2a_stdincl emp_nhwh2b_stdincl emp_nhwh2c_stdincl emp_nhwh3a_stdincl  emp_nhwh3b_stdincl  emp_nhwh3c_stdincl  
			emp_alone0_stdincl (where=(category~=.)) emp_alone2a_stdincl  (where=(category~=.)) emp_alone2b_stdincl  (where=(category~=.)) emp_alone2c_stdincl  (where=(category~=.))
			emp_alone3a_stdincl  (where=(category~=.)) emp_alone3b_stdincl  (where=(category~=.)) emp_alone3c_stdincl  (where=(category~=.))
				emp_for0_stdincl  emp_for2a_stdincl  emp_for2b_stdincl  emp_for2c_stdincl  emp_for3a_stdincl  emp_for3b_stdincl  emp_for3c_stdincl ;

		by PUMA category;
		format puma puma_id.;

		if puma=. then puma=100;

		mergeflag=1; 
		run; 

data whiterates;
	set merged_data (where=(category=2 & puma=100));

	run; 

%rename(whiterates);
run; 

proc contents data=whiterates_new;
run;

data merged_data_WR (drop=cNum: cPct: cPop: mergeflag);
	merge merged_data whiterates_new (drop=cPUMA cCategory rename=(cmergeflag=mergeflag));
	by mergeflag;
	GapRentCostB=cPctRentCostB/100*NumRenters-NumRentCostB;
	GapRentSevCostB=cPctRentSevCostB/100*NumRenters-NumRentSevCostB;
	GapRentUnitsELI=cPctRentUnitsELI/100*NumRenters-NumRentUnitsELI;
	GapRentUnitsLI=cPctRentUnitsLI/100*NumRenters-NumRentUnitsLI;
	GapRentUnitsMHI=cPctRentUnitsMHI/100*NumRenters-NumRentUnitsMHI;
	GapRentUnitsVLI=cPctRentUnitsVLI/100*NumRenters-NumRentUnitsVLI;
	GapOwnersNoMort=cPctOwnersNoMort/100*NumOwners-NumOwnersNoMort;
	GapOwnersOweMort=cPctOwnersOweMort/100*NumOwners-NumOwnersOweMort;
	GapPop25to64yearsEmp=cPct25to64yearsEmp/100*Pop25to64Years-Pop25to64yearsEmp;
	GapPop25to64yearsOutLF=cPct25to64yearsOutLF/100*Pop25to64Years-Pop25to64yearsOutLF;
	GapPop25to64yearsUnEmp=cPct25to64yearsUnEmp/100*Pop25to64Years-Pop25to64yearsUnEmp;
	run;

proc print data=merged_data_wr;
var category puma GapRentCostB GapRentSevCostB GapRentUnitsELI GapRentUnitsLI GapRentUnitsMHI GapRentUnitsVLI GapOwnersNoMort
	GapOwnersOweMort GapPop25to64yearsEmp GapPop25to64yearsOutLF GapPop25to64yearsUnEmp PctRentCostB NumRenters NumRentCostB;
run;

proc sort data=merged_data_WR;
by category;

Proc transpose data=merged_data_WR out=transposed_data prefix=PUMA;
by category;
id puma; 
format puma puma_id.;
run;

proc sort data=transposed_data;
by _name_ category ;
run; 
proc freq data=transposed_data;
tables _name_;
run;

data profile_tabs_ipums ; 
	set transposed_data ; 

rename _name_=Indicator;

order = .;

if _name_ ="Pop25to64years" then order=1;
if _name_="Pop25to64yearsEmp" then order=2; 
if _name_="Pct25to64yearsEmp" then order=3;
if _name_="GapPop25to64yearsEmp" then order=4;
if _name_="Pop25to64yearsUnEmp" then order=5; 
if _name_="Pct25to64yearsUnEmp" then order=6;
if _name_="GapPop25to64yearsUnEmp" then order=7;
if _name_="Pop25to64yearsOutLF" then order=8; 
if _name_="Pct25to64yearsOutLF" then order=9;
if _name_="GapPop25to64yearsOutLF" then order=10;

if _name_="NumOwners" then order=11;
if _name_="NumRenters" then order=12; 
if _name_="NumOwnersNoMort"  then order=13;
if _name_="PctOwnersNoMort" then order=14; 
if _name_="GapOwnersNoMort" then order=15;
if _name_="NumOwnersOweMort" then order=16;
if _name_="PctOwnersOweMort"  then order=17;
if _name_="GapOwnersOweMort" then order=18;

if _name_="NumRentCostB" then order=19;
if _name_="PctRentCostB" then order=20;
if _name_="GapRentCostB" then order=21;
if _name_="NumRentSevCostB" then order=22;
if _name_="PctRentSevCostB" then order=23;
if _name_="GapRentSevCostB" then order=24;

if _name_="NumRentUnitsELI" then order=25;
if _name_="PctRentUnitsELI" then order=26;
if _name_="GapRentUnitsELI" then order=27;
if _name_="NumRentUnitsVLI" then order=28;
if _name_="PctRentUnitsVLI" then order=29;
if _name_="GapRentUnitsVLI" then order=30;
if _name_="NumRentUnitsLI" then order=31;
if _name_="PctRentUnitsLI" then order=32;
if _name_="GapRentUnitsLI" then order=33;
if _name_="NumRentUnitsMHI" then order=34;
if _name_="PctRentUnitsMHI" then order=35;
if _name_="GapRentUnitsMHI" then order=36;

label PUMA100 = "District of Columbia";

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
