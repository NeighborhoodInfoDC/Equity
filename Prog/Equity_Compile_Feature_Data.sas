/**************************************************************************
 Program:  Equity_Compile_Feature_Data.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  07/18/18
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  
			   
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )
%DCData_lib( Police )
%DCData_lib( Realprop )
%DCData_lib( Vital )

%let _years=2012_2016;

data ACSindicator;
set ACS.Acs_2012_16_dc_sum_tr_tr10;
keep pop25andoverwsc_&_years. numrentercostburden_&_years. rentcostburdendenom_&_years. numownercostburden_&_years.
     ownercostburdendenom_&_years. numowneroccupiedhsgunits_&_years. numrenteroccupiedhu_&_years. medfamincm_&_years.
	 familyhhtot_&_years.  famincomelt75k_&_years. personspovertydefined_&_years.  poppoorpersons_&_years.
     popunemployed_&_years. popincivlaborforce_&_years. popemployedworkers_&_years. earningover75k_&_years.
	 popunder18years_&_years. totpop_&_years. totalhousingunit famincomemt75k popabovepov ;

	 totalhousingunit= numowneroccupiedhsgunits_&_years. + numrenteroccupiedhu_&_years.;
     famincomemt75k= familyhhtot_&_years.-famincomelt75k_&_years.;
     popabovepov= personspovertydefined_&_years. - poppoorpersons_&_years.;
run;

data affordbility;
set realprop.Sales_res_clean;
