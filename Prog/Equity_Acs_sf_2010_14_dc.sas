/**************************************************************************
 Program:  Equity_Acs_sf_2010_14_dc.sas
 Library:  ACS
 Project:  NeighborhoodInfo DC
 Author:   Carl Hedman
 Created:  5/26/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Read selected tables for ACS summary files.
 
 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )


%Acs_sf(

  /** State abbreviation. Ex: DC **/
  state_ab = DC,

  /** Year range (xxxx_yy). Ex: 2005_09 **/
  years = 2010_14,
  
  /** List of tables to include in data sets **/
    table_list = 
      B00001 B00002 B01001 B01002 B01003 B02001 B03002 B05002 B06002 B07012 B09001
      B11001 B11003 B11004 B11005 B11007 B11010 B11013 B11016 B15002
      B15003 B16004 B17001 B18101 B18102 B18103 B18104 B18105 B18106
      B19001 B19013 B19050 B19056 B19057 B19058 B19059 B19127 B19131 B19113
      B23001 B23025 B25003 B25004 B25007 B25010 B25043 B25044 B25061
      B25062 B25063 B25065 B25070 B25014 B25024 B25041 B25049 B25052 
      B25070 B25091 B25105 B25088 B25064 C24010 C24030
  ,
  /** List of table estimate (e:) and margin of error (m:) cells that should be excluded from all data sets **/
    drop_list =
      B00001m: B00002m:
      B01001Ee: B01002Ee: B11001Ee: B19001Ee: B19013Ee: B25003Ee: B25014Ee: C24010Ee:
      B01001Em: B01002Em: B11001Em: B19001Em: B19013Em: B25003Em: B25014Em: C24010Em:
      B18101Ee: B19113Ee:
      B18101Em: B19113Em:
    ,
    
    /** List of table estimate (e:) and margin of error (m:) cells that should be excluded from BLOCK GROUP data sets only **/
    drop_bg_list = 
      B05002e: B07012e: B11010e: B11013e: B17001e: 
      B05002m: B07012m: B11010m: B11013m: B17001m:  
      B18101e: B18102e: B18103e: B18104e: B18105e: B18106e: 
      B18101m: B18102m: B18103m: B18104m: B18105m: B18106m: 
      B19058e: B19131e: B23001e: B25052e:
      B19058m: B19131m: B23001m: B25052m:
      B06002e: B09001e: B25105e:
      B06002m: B09001m: B25105m: 
  );

