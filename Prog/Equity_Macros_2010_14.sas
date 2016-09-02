/**************************************************************************
 Program:  Equity_macros_2010_14.sas
 Library:  Equity
 Project:  Racial Equity Profiles
 Author:   L. Hendey
 Created:  7/25/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Based on .HsngSec.HsngSec_macros_2009_11.sas that created tables from 2009-11 3-year ACS IPUMS data for 
 Housing Security 2013 report out to funders.

 Modifications: 
	07/25/13 LH Separated Macros to output tables from program.
 	07/25/16 MW Updated for ACS 2010-14, Equity, and SAS1 Server
	08/20/16 LH	Modified macros to accomodate race categories.
**************************************************************************/


***** Macros *****;
%macro survey_freq (input=, where= , options=, weight=, tables=, type=, out=);

proc surveyfreq data = &input (where=(&where)) &options;
weight &weight;
strata strata;
cluster cluster;
by subpopvar;
tables &tables;
ods output &type=&out;
run;

%mend survey_freq;

%macro survey_means (input=, where=, option=, weight=, domain=, var=, out=);

proc surveymeans data = &input (where=(&where)) &option;
weight &weight;
strata strata;
cluster cluster;
domain &domain;
var &var;
ods output Domain=&out;
run;

%mend survey_means;


** Count table macro **;

** Count table for person**;

%macro Count_table( where=, row_var=, row_fmt=, title=, weight=perwt, universe=Persons, out=);

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class puma ;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total'
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
      all='Total'
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "% &universe" * colpctsum=' ' * f=comma10.1 * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";


  run;

  title2;
  footnote1;

%mend Count_table;

** Count table for households**;

%macro Count_table2( where=, row_var=, row_fmt=, title=, weight=hhwt, universe=Households, out= );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing  out=&out;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class puma  ;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total'
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
      all='Total'
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "% &universe" * colpctsum=' ' * f=comma10.1 * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table2;
*for affordability rent tables; 
%macro Count_table3( where=, row_var=, row_fmt=, title=, weight=perwt, universe=Persons, out= );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class puma aff_unit;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total' aff_unit=' '
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
      all='Total' aff_unit=' '
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "% &universe" * colpctsum=' ' * f=comma10.1 * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma. aff_unit aff_unit. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table3;

*tables for NH White and Hispanic; 
%macro Count_table4( where=, row_var=, row_fmt=, title=, weight=hhwt, universe=Persons, out=);

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class puma race_cat1 ;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total' race_cat1=' '
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
      all='Total' race_cat1=' '
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "% &universe" * (colpctsum=' ' * f=comma10.1)* ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma. race_cat1 racecatA. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table4;

*tables for Race Alone; 
%macro Count_table5( where=, row_var=, row_fmt=, title=, weight=hhwt, universe=Persons, out=);

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class puma race_cat2 ;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total' race_cat2=' '
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
      all='Total' race_cat2=' '
  	,
      /** Rows **/
      all='Total' &row_var
      ,
      /** Columns (do not change) **/
      total = "% &universe" * colpctsum=' ' * f=comma10.1 * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma. race_cat2 racecatB. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table5;


%macro Count_table_med( where=, row_var=, row_fmt=, title=, weight=perwt, universe=Persons, out= );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class upuma /order=data preloadfmt;
    var rentgrs;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total'
  	,
      /** Rows **/
      all='Median Gross Rent' &row_var
      ,
      /** Columns (do not change) **/
      median="&universe" * rentgrs = " " * ( upuma=' ' all='Washington Region' )
      / condense
    ;
    format upuma $pumctyb. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table_med;

%macro Count_table_med2( where=, row_var=, row_fmt=, title=, weight=perwt, universe=Persons, out= );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class upuma /order=data preloadfmt;
    var valueh;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total'
  	,
      /** Rows **/
      all='Median Home Value' &row_var
      ,
      /** Columns (do not change) **/
      median="&universe" * valueh = " " * ( upuma=' ' all='Washington Region' )
      / condense
    ;
    format upuma $pumctyb. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table_med2;

%macro Count_table_tworows( where=, row_var=, row_var2=, row_fmt=, row_fmt2=, title=, weight=perwt, universe=Persons, out= );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=comma10.0 noseps missing out=&out.;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
	class &row_var2;
    class puma ;
    var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total'
  	,
      /** Rows **/
      all='Total' &row_var. * &row_var2.
      ,
      /** Columns (do not change) **/
      total = "&universe" * sum=' ' * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    table 
      /** Pages (do not change) **/
      all='Total'
  	,
      /** Rows **/
      all='Total' &row_var. * &row_var2.
      ,
      /** Columns (do not change) **/
      total = "% &universe" * colpctsum=' ' * f=comma10.1 * ( puma=' ' all='District of Columbia' )
      / condense
    ;
    format puma puma. &row_var &row_fmt &row_var2 &row_fmt2;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Count_table_tworows;


** Rate table macro **;

**Rate table for persons**;

%macro Rate_table( where=, rate_var=, row_var=, row_fmt=, title=, desc=, weight=perwt, universe=Persons );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=percent10.1 noseps missing;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class upuma sex /order=data preloadfmt;
    var &rate_var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total' sex=' '
  	,
      /** Rows **/
	  all='Total' *total='' *sum='' *f=comma10.0
      (all="% &desc" &row_var) *&rate_var='' *mean=''
    ,
      /** Columns (do not change) **/
      ( upuma=' ' all='Washington Region' )
      / condense
    ;
    format upuma $pumctyb. sex sex. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Rate_table;

**Rate table for households**;

%macro Rate_table2( where=, rate_var=, row_var=, row_fmt=, title=, desc=, weight=perwt, universe=Persons );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=percent10.1 noseps missing;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class upuma /order=data preloadfmt;
    var &rate_var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total'
  	,
      /** Rows **/
	  all='Total' *total='' *sum='' *f=comma10.0
      (all="% &desc" &row_var) *&rate_var='' *mean=''
    ,
      /** Columns (do not change) **/
     ( upuma=' ' all='Washington Region' )
      / condense
    ;
    format upuma $pumctyb. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Rate_table2;

**Rate table for UPUMA**;

%macro Rate_table3( where=, rate_var=, row_var=, row_fmt=, title=, desc=, weight=perwt, universe=Persons );

  %fdate()

  proc tabulate data=Equity.Acs_tables_ipums format=percent10.1 noseps missing;
    %if "&where. "~= "" %then %do;
      where &where;
    %end;
    class &row_var;
    class upuma sex /order=data preloadfmt;
    var &rate_var total;
    weight &weight;
    table 
      /** Pages (do not change) **/
      all='Total' sex=' '
  	,
      /** Rows **/
	  all='Total' *total='' *sum='' *f=comma10.0
      (all="% &desc" &row_var) *&rate_var='' *mean=''
    ,
      /** Columns (do not change) **/
      ( upuma=' ' )
      / condense
    ;
    format upuma $pumctyb. sex sex. &row_var &row_fmt;
    title2 &title;
    title3 "Universe: &universe";
    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

  run;

  title2;
  footnote1;

%mend Rate_table3;

%macro Income_table( where=, row_var=, row_fmt=, title=, weight=hhwt, universe=Households );

   %fdate()

   proc tabulate data=Equity.Acs_tables_ipums_inc format=comma10.1 noseps missing;

    %if &where~= %then %do;

      where &where;

    %end;

    class &row_var;

    class upuma /order=data preloadfmt;

    var total inc: ;

    weight &weight;

    table 

      /** Rows **/

      total='Households' * sum=' '

      mean="Average Income ($)" * ( all='Total' &row_var ) * ( inctot incwage incbus00 incss incwelfr incinvst incretir incsupp incother ),

      /** Columns (do not change) **/

      ( upuma=' ' all='Washington Region' )

      / condense 

    ;

    table 

      /** Rows **/

      total='Households' * sum=' '

      pctsum<inctot>="Pct. Income" * ( all='Total' &row_var ) * ( inctot incwage incbus00 incss incwelfr incinvst incretir incsupp incother ),

      /** Columns (do not change) **/

      ( upuma=' ' all='Washington Region' )

      / condense 

    ;

    format upuma $pumctyb. sex sex. &row_var &row_fmt;

    title2 &title;

    title3 "Universe: &universe";

    footnote1 "Source: ACS IPUMS data, 2010-14 (&fdate)";

 

  run;

 

  title2;

  footnote1;

 

%mend Income_table;
