/**************************************************************************
 Program:  Equity_ACS_summary_all.sas
 Library:  ACS
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/04/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Main macro for generating all ACS summary files.

 Modifications: 
	7/29/2016 - renamed macros by add "Equity_" in front of original macro names.
**************************************************************************/

%macro Equity_ACS_summary_all( 

  /** State abbreviation. Ex: DC **/
  state_ab = DC,

  /** Year range (xxxx_yy). Ex: 2005_09 **/
  years = 2010_14,
  
  finalize = Y,
  revisions = New file.

  );


  %global _state_ab _years _years_dash _last_year _out_lib _finalize _revisions;

  %** Program parameters **;

  %let _state_ab   = %lowcase(&state_ab);
  %let _years = &years;
  %let _years_dash = %sysfunc( translate( &_years, '-', '_' ) );
  %let _last_year = 20%scan( &_years, 2, _ );
  %let _finalize = &finalize;
  %let _revisions = &revisions;


  %** Check if OK to run finalized data sets **;

  %if %mparam_is_yes( &_finalize ) and not &_remote_batch_submit %then %do;
    %warn_mput( macro=Equity_ACS_summary_all, msg=%str(Not a remote batch submit session. Finalize will be set to N.) )
    %let _finalize = N;
  %end;

  %if %mparam_is_yes( &_finalize ) %then %do;
    %let _out_lib = Equity;
  %end;
  %else %do;
    %let _out_lib = WORK;
  %end;
  

  **** Create summary files from block group source ****;

  %Equity_ACS_summary_geo_source( bg10 )


  **** Create summary files from census tract source ****;

  %Equity_ACS_summary_geo_source( tr10 )


%mend Equity_ACS_summary_all;

