/**************************************************************************
 Program:  Births_geocode
 Library:  Vital
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  9/6/2018
 Version:  SAS 9.4
 Environment:  Windows
 Modifications: 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Equity )
%DCData_lib( Mar )
libname raw "L:\Libraries\Equity\Raw";

/** Use MAR geocoder to geocode address data **/

%DC_mar_geocode(
  debug=n,
  streetalt_file = &_dcdata_default_path\Vital\Prog\StreetAlt_041918_new.txt,
  data = raw.DC_retail_banks,
  staddr = address,
  zip = zip,
  out = retailbanks
);

proc export data=retailbanks (where=(_STATUS_='Found'))
   outfile='&_dcdata_default_path\Equity\Proj\JPMC feature\retailbanks_geocoded.csv'
   dbms=csv
   replace;
run;
