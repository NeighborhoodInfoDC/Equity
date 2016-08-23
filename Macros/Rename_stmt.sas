/* Rename_stmt.sas - UI SAS Autocall Macro Library
 *
 * Generate SAS rename statement/option code for a list of variables.
 *
 * NB:  Program written for SAS Version 9.1
 *
 * 02/18/09  Peter A. Tatian
 ****************************************************************************/

/** Macro Rename_stmt - Start Definition **/

%macro Rename_stmt(  
  vars=,                   /** List of variable names **/
  prefix = ,               /** Prefix to add before variable names (optional) **/
  suffix = ,               /** Suffix to add after variable names (optional) **/
  reverse = N,             /** Reverse order of variables **/
  quiet=Y                  /** Suppress log messages? (Y/N) **/
);

  %let quiet = %upcase( &quiet );
  %let reverse = %upcase( &reverse );
  
  %if &quiet ~= Y %then %do;
    %note_mput( macro=Rename_stmt, msg=Processing vars=(&vars) )
  %end;

  %let i = 1;
  %let item = %scan( &vars, &i, %str( ) );
  %let rename_code = ;

  %do %while ( %length( &item ) > 0 );
  
    %if &reverse = Y %then 
      %let rename_code = &rename_code &prefix&item&suffix=&item;
    %else
      %let rename_code = &rename_code &item=&prefix&item&suffix;
    
    %let i = %eval( &i + 1 );
    %let item = %scan( &vars, &i, %str( ) );
    
  %end;
  
  %if &quiet ~= Y %then %do;
    %note_mput( macro=Rename_stmt, msg=Rename_code=(&rename_code) )
  %end;

  &rename_code

%mend Rename_stmt;

/** End Macro Definition **/

/************ UNCOMMENT TO TEST *************************************/

title "Rename_stmt:  UI SAS Autocall Macro Library";

filename uiautos "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);

options nocenter;
options mprint nosymbolgen nomlogic;
options msglevel=i;

%put Result=%Rename_stmt( vars=a b c d, prefix=new_, quiet=N );

%put Result=%Rename_stmt( vars=a b c d, suffix=_new, quiet=N );

%put Result=%Rename_stmt( vars=a b c d, prefix=new_, suffix=_2, quiet=N );

%put Result=%Rename_stmt( vars=a b c d, prefix=new_, reverse=Y, quiet=N );

run;

/********************************************************************/

