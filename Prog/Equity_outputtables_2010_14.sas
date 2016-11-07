
/**************************************************************************
 Program:  Equity_outputtables_2010_14.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   G. MacDonald
 Created:  04/24/2013 
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create formats for tables from 2010-14 5-year ACS IPUMS data for 
 Equity 2016 report.

 Modifications: 
	07/25/2013 LH Limited to formats only on this program. 
	08/12/2013 EO altered tables based on HUD affordability levels.
	08/30/2013 EO altered tables for Demographics based on HUD affordability levels.
	07/25/2016 MW Updated for ACS 2010-14, Equity, and SAS1 Server
**************************************************************************/

*%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( IPUMS );
%DCDATA_lib( Equity );

*%include "K:\Metro\PTatian\DCData\Libraries\IPUMS\Prog\Ipums_formats_2009_11.sas"; 
*%include "K:\Metro\PTatian\DCData\Libraries\Equity\Prog\Equity_formats_2009_11.sas";
*%include "K:\Metro\PTatian\DCData\Libraries\Equity\Prog\Equity_macros_2009_11.sas";

*%include "L:\Libraries\IPUMS\Prog\Ipums_formats_2010_14.sas"; 
%include "D:\DCData\Libraries\Equity\Prog\Equity_formats_2010_14.sas";
%include "D:\DCData\Libraries\Equity\Prog\Equity_macros_2010_14.sas";


***** Tables *****;

options nospool;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 1. Total Number of Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= ,
  row_fmt= ,
  weight = hhwt,
  universe= Renters,
  title= "Table 1. Total Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 2. Cost Burden for All Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= costburden,
  row_fmt= costburden.,
  weight = hhwt,
  universe= Renters,
  title= "Table 2. Cost Burden for All Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 3. Cost Burden for White-Non Hispanic Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and racew=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= hhwt, 
  universe= White-Non Hispanic Renters,
  title= "Table 3. Cost Burden for White-Non Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 4. Cost Burden for Hispanic Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceh=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= hhwt, 
  universe= Hispanic Renters,
  title= "Table 4. Cost Burden for Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 5. Cost Burden for Black Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceb=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= hhwt, 
  universe= Black Renters,
  title= "Table 5. Cost Burden for Black Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 6. Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceaiom=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= hhwt, 
  universe= Renters of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or Two or More Races,
  title= "Table 6. Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 7. Cost Burden for Renters Who are Foreign-Born.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= hhwt, 
  universe= Renters Who are Foreign-Born,
  title= "Table 7. Cost Burden for Renters Who are Foreign-Born" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 8. Severe Cost Burden for All Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight = hhwt,
  universe= Renters,
  title= "Table 8. Severe Cost Burden for All Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 9. Severe Cost Burden for White-Non Hispanic Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and racew=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= hhwt, 
  universe= White-Non Hispanic Renters,
  title= "Table 9. Severe Cost Burden for White-Non Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 10. Severe Cost Burden for Hispanic Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceh=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= hhwt, 
  universe= Hispanic Renters,
  title= "Table 10. Severe Cost Burden for Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 11. Severe Cost Burden for Black Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceb=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= hhwt, 
  universe= Black Renters,
  title= "Table 11. Severe Cost Burden for Black Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 12. Severe Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceaiom=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= hhwt, 
  universe= Renters of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or and Two or More Races,
  title= "Table 12. Severe Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 13. Severe Cost Burden for Renters Who are Foreign-Born.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= hhwt, 
  universe= Renters Who are Foreign-Born,
  title= "Table 13. Severe Cost Burden for Renters Who are Foreign-Born" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 14. Share of Population Ages 25-64 that is Employed for All Races.xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 ),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight = perwt,
  universe= Individuals Ages 25 to 64,
  title= "Table 14. Share of Population Ages 25-64 that is Employed for All Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 15. Share of Population Ages 25-64 that is Employed for White-Non Hispanic .xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 and racew=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= White-Non Hispanic Individuals Ages 25 to 64,
  title= "Table 15. Share of Population Ages 25-64 that is Employed for White-Non Hispanic " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 16. Share of Population Ages 25-64 that is Employed for Hispanic .xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 and raceh=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= Hispanic Individuals Ages 25 to 64,
  title= "Table 16. Share of Population Ages 25-64 that is Employed for Hispanic " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 17. Share of Population Ages 25-64 that is Employed for Black .xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 and raceb=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= Black Individuals Ages 25 to 64,
  title= "Table 17. Share of Population Ages 25-64 that is Employed for Black " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 18. Share of Population Ages 25-64 that is Employed for Asian, Pacific Islanders.xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 and racea=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Asian/Pacific Islander Individuals Ages 25 to 64,
  title= "Table 18. Share of Population Ages 25-64 that is Employed for Asian, Pacific Islanders" );

run;


ods html file="D:\DCData\Libraries\Equity\Prog\Table 19. Share of Population Ages 25-64 that is Employed for Individuals of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, and Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 and raceaiom=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Individuals of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or Two or More Races Ages 25 to 64,
  title= "Table 19. Share of Population Ages 25-64 that is Employed for Individuals of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, and Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 20. Share of Population Ages 25-64 that is Employed Who are Foreign-Born.xls" style=Minimal;

%Count_table( 
  where= %str(city=7230 and age25to64=1 and foreign=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= Individuals who are Foreign-Born Ages 25 to 64,
  title= "Table 20. Share of Population Ages 25-64 that is Employed Who are Foreign-Born" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 21. Mortgage Status for All Homeowners.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 ),
  row_var= ownmortgage,
  row_fmt= ownmortgage.,
  weight = hhwt,
  universe= Homeowners,
  title= "Table 21. Mortgage Status for All Homeowners" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 22. Mortgage Status for White-Non Hispanic Homeowners.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 and racew=1),
  row_var= ownmortgage,
  row_fmt= ownmortgage.,
  weight= hhwt, 
  universe= White-Non Hispanic Homeowners,
  title= "Table 22. Mortgage Status for White-Non Hispanic Homeowners" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 23. Mortgage Status for Hispanic Homeowners.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 and raceh=1),
  row_var= ownmortgage,
  row_fmt= ownmortgage.,
  weight= hhwt, 
  universe= Hispanic Homeowners,
  title= "Table 23. Mortgage Status for Hispanic Homeowners" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 24. Mortgage Status for Black Homeowners.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 and raceb=1),
  row_var= ownmortgage,
  row_fmt= ownmortgage.,
  weight= hhwt, 
  universe= Black Homeowners,
  title= "Table 24. Mortgage Status for Black Homeowners" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 25. Mortgage Status for Homeowners of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 and raceaiom=1),
  row_var= ownmortgage,
  row_fmt= ownmortgage.,
  weight= hhwt, 
  universe= Homeowners of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or and Two or More Races,
  title= "Table 25. Mortgage Status for Homeowners of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 26. Mortgage Status for Homeowners Who are Foreign-Born.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 1 and foreign=1),
  row_var= ownmortgage,
  row_fmt= ownmortgage.,
  weight= hhwt, 
  universe= Homeowners Who are Foreign-Born,
  title= "Table 26. Mortgage Status for Homeowners Who are Foreign-Born" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 27. Housing Affordability for All Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= aff_unit,
  row_fmt= aff_unit.,
  weight = hhwt,
  universe= Renters,
  title= "Table 27. Housing Affordability for All Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 28. Housing Affordability for White-Non Hispanic Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and racew=1),
  row_var= aff_unit,
  row_fmt= aff_unit.,
  weight= hhwt, 
  universe= White-Non Hispanic Renters,
  title= "Table 28. Housing Affordability for White-Non Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 29. Housing Affordability for Hispanic Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceh=1),
  row_var= aff_unit,
  row_fmt= aff_unit.,
  weight= hhwt, 
  universe= Hispanic Renters,
  title= "Table 29. Housing Affordability for Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 30. Housing Affordability for Black Renters.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceb=1),
  row_var= aff_unit,
  row_fmt= aff_unit.,
  weight= hhwt, 
  universe= Black Renters,
  title= "Table 30. Housing Affordability for Black Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 31. Housing Affordability for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and raceaiom=1),
  row_var= aff_unit,
  row_fmt= aff_unit.,
  weight= hhwt, 
  universe= Renters of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or Two or More Races,
  title= "Table 31. Housing Affordability for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 32. Housing Affordability for Renters Who are Foreign-Born.xls" style=Minimal;

%Count_table2( 
  where= %str(city=7230 and pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
  row_var= aff_unit,
  row_fmt= aff_unit.,
  weight= hhwt, 
  universe= Renters Who are Foreign-Born,
  title= "Table 32. Housing Affordability for Renters Who are Foreign-Born" );

run;

