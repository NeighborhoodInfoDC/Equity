/**************************************************************************
 Program:  Rename.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey 
 Created:  08/22/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Renames all variables in a dataset to begin with letter C.  
**************************************************************************/

%macro rename(data=,out=);
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

data &out.;
  set &data;
  rename &rename ;
run;
%mend rename;
