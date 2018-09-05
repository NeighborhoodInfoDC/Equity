/**************************************************************************
 Program:  Equity_JPMC_poulation by blockgroup.sas
 Library:  Equity
 Project:  Equtiy Feature
 Author:   YipengSU
 Created:  9/4/2017
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Use for equity maps. Creates file for population by tract. 

 Modifications: 

**************************************************************************/
*run for formats;

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCDATA_lib (Equity);
%DCDATA_lib (ACS);

 Data DC_pop_block (keep=geobg2010 tract tract_comp b01001e1);
  set acs.Acs_sf_2012_16_dc_bg10;
  run;

proc export data=DC_pop_block
	outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\population_blockgroup.csv"
	dbms=csv replace;
	run;
