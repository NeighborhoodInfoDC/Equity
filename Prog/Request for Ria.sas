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
%macro Count_table13( where=, row_var=, row_fmt=, title=, weight=hhwt, universe=Persons, out=);

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class puma hud_inc ;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total' hud_inc=' '
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "&universe" * sum=' ' * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    table 
      /** Pages (do not change) **/
      all='Total' hud_inc=' '
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "% &universe" * (colpctsum=' ' * f=comma10.1)* ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma.  hud_inc  HUDINC25. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table13;
%Count_table13( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
	  row_var= race_cat1,
	  row_fmt=  racecatA.,
	  weight= hhwt, 
	  universe= Renters,
	  out=costb_NHWH,
	  title= "Table 1. HUD Income Categories for Renters, White-Non Hispanic, Hispanic" );

	run;
%Count_table13( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
	  row_var= race_cat2,
	  row_fmt=  racecatB.,
	  weight= hhwt, 
	  universe= Renters,
	  out=test,
	  title= "Table 1. HUD Income Categories for Renters, Race Alone" );

	run;


%Count_table13( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 ),
	  row_var= race_cat1,
	  row_fmt=  racecatA.,
	  weight= hhwt, 
	  universe= Owners,
	  out=costb_NHWH,
	  title= "Table 1. HUD Income Categories for Owners, White-Non Hispanic, Hispanic" );

	run;
%Count_table13( 
	  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 ),
	  row_var= race_cat2,
	  row_fmt=  racecatB.,
	  weight= hhwt, 
	  universe= Owners,
	  out=test,
	  title= "Table 1. HUD Income Categories for Owners, Race Alone" );

	run;
