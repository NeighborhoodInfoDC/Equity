
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
%include "L:\Libraries\Equity\Prog\Equity_formats_2010_14.sas";
%include "L:\Libraries\Equity\Prog\Equity_macros_2010_14.sas";

proc freq data=equity.acs_tables (where=(pernum=1 and GQ in (1,2) and ownershp=2));
tables racew raceh raceb racea racei raceo racem raceiom raceiom2 raceaiom raceaiom2/list missing;
weight perwt;
run;

***** Tables *****;

options nospool;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 1. Total Number of Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= ,
  row_fmt= ,
  weight = perwt,
  universe= Renters,
  title= "Table 1. Total Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 2. Cost Burden for All Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= costburden,
  row_fmt= costburden.,
  weight = perwt,
  universe= Renters,
  title= "Table 2. Cost Burden for All Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 3. Cost Burden for White-Non Hispanic Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racew=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= White-Non Hispanic Renters,
  title= "Table 3. Cost Burden for White-Non Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 4. Cost Burden for Hispanic Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceh=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Hispanic Renters,
  title= "Table 4. Cost Burden for Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 5. Cost Burden for Black Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceb=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Black Renters,
  title= "Table 5. Cost Burden for Black Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 6. Cost Burden for Asian, Pacific Islander Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racea=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Asian/Pacific Islander Renters,
  title= "Table 6. Cost Burden for Asian, Pacific Islander Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 7. Cost Burden for American Indian, Alaskan Native Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racei=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= American Indian/Alaskan Native Renters,
  title= "Table 7. Cost Burden for American Indian, Alaskan Native Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 8. Cost Burden for Other Race Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceo=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Other Race Renters,
  title= "Table 8. Cost Burden for Other Race Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 9. Cost Burden for Renters of Two of More Races.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racem=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Renters of Two of More Races,
  title= "Table 9. Cost Burden for Renters of Two of More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 10. Cost Burden for Renters of American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceiom=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Renters of American Indian/Alaskan Native Descent or Other or Two or More Races,
  title= "Table 10. Cost Burden for Renters of American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 11. Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceaiom=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Renters of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or Two or More Races,
  title= "Table 11. Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 12. Cost Burden for Renters Who are Foreign-Born.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
  row_var= costburden,
  row_fmt= costburden.,
  weight= perwt, 
  universe= Renters Who are Foreign-Born,
  title= "Table 12. Cost Burden for Renters Who are Foreign-Born" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 13. Severe Cost Burden for All Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 ),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight = perwt,
  universe= Renters,
  title= "Table 13. Severe Cost Burden for All Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 14. Severe Cost Burden for White-Non Hispanic Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racew=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= White-Non Hispanic Renters,
  title= "Table 14. Severe Cost Burden for White-Non Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 15. Severe Cost Burden for Hispanic Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceh=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Hispanic Renters,
  title= "Table 15. Severe Cost Burden for Hispanic Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 16. Severe Cost Burden for Black Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceb=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Black Renters,
  title= "Table 16. Severe Cost Burden for Black Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 17. Severe Cost Burden for Asian, Pacific Islander Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racea=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Asian/Pacific Islander Renters,
  title= "Table 17. Severe Cost Burden for Asian, Pacific Islander Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 18. Severe Cost Burden for American Indian, Alaskan Native Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racei=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= American Indian/Alaskan Native Renters,
  title= "Table 18. Severe Cost Burden for American Indian, Alaskan Native Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 19. Severe Cost Burden for Other Race Renters.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceo=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Other Race Renters,
  title= "Table 19. Severe Cost Burden for Other Race Renters" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 20. Severe Cost Burden for Renters of Two of More Races.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and racem=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Renters of Two of More Races,
  title= "Table 20. Severe Cost Burden for Renters of Two of More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 21. Severe Cost Burden for Renters of American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceiom=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Renters of American Indian/Alaskan Native Descent or Other or and Two or More Races,
  title= "Table 21. Severe Cost Burden for Renters of American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 22. Severe Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and raceaiom=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Renters of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or and Two or More Races,
  title= "Table 22. Severe Cost Burden for Renters of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 23. Severe Cost Burden for Renters Who are Foreign-Born.xls" style=Minimal;

%Count_table( 
  where= %str( pernum=1 and GQ in (1,2) and ownershp = 2 and foreign=1),
  row_var= sevcostburden,
  row_fmt= sevcostburden.,
  weight= perwt, 
  universe= Renters Who are Foreign-Born,
  title= "Table 23. Severe Cost Burden for Renters Who are Foreign-Born" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 24. Share of Population Ages 25-64 that is Employed for All .xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 ),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight = perwt,
  universe= Individuals Ages 25 to 64,
  title= "Table 24. Share of Population Ages 25-64 that is Employed for All " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 25. Share of Population Ages 25-64 that is Employed for White-Non Hispanic .xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and racew=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= White-Non Hispanic Individuals Ages 25 to 64,
  title= "Table 25. Share of Population Ages 25-64 that is Employed for White-Non Hispanic " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 26. Share of Population Ages 25-64 that is Employed for Hispanic .xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and raceh=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= Hispanic Individuals Ages 25 to 64,
  title= "Table 26. Share of Population Ages 25-64 that is Employed for Hispanic " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 27. Share of Population Ages 25-64 that is Employed for Black .xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and raceb=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= Black Individuals Ages 25 to 64,
  title= "Table 27. Share of Population Ages 25-64 that is Employed for Black " );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 28. Share of Population Ages 25-64 that is Employed for Asian, Pacific Islanders.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and racea=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Asian/Pacific Islander Individuals Ages 25 to 64,
  title= "Table 28. Share of Population Ages 25-64 that is Employed for Asian, Pacific Islanders" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 29. Share of Population Ages 25-64 that is Employed for American Indian, Alaskan Natives.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and racei=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=American Indian/Alaskan Native Individuals Ages 25 to 64,
  title= "Table 29. Share of Population Ages 25-64 that is Employed for American Indian, Alaskan Natives" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 30. Share of Population Ages 25-64 that is Employed for Other Race Individuals.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and raceo=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Individuals of Other Race Ages 25 to 64 ,
  title= "Table 30. Share of Population Ages 25-64 that is Employed for Other Race individuals" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 31. Share of Population Ages 25-64 that is Employed for Individuals of Two of More Races.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and racem=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Individuals of Two of More Races Ages 25 to 64,
  title= "Table 31. Share of Population Ages 25-64 that is Employed for Individuals of Two of More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 32. Share of Population Ages 25-64 that is Employed for Individuals of American Indian, Alaskan Native Descent, Other, and Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and raceiom=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Individuals of American Indian/Alaskan Native Descent or Other or and Two or More Races Ages 25 to 64,
  title= "Table 32. Share of Population Ages 25-64 that is Employed for Individuals of American Indian, Alaskan Native Descent, Other, and Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 33. Share of Population Ages 25-64 that is Employed for Individuals of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, and Two or More Races.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and raceaiom=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe=Individuals of Asian/Pacific Islander or American Indian/Alaskan Native Descent or Other or Two or More Races Ages 25 to 64,
  title= "Table 33. Share of Population Ages 25-64 that is Employed for Individuals of Asian, Pacific Islander, American Indian, Alaskan Native Descent, Other, and Two or More Races" );

run;

ods html file="D:\DCData\Libraries\Equity\Prog\Table 34. Share of Population Ages 25-64 that is Employed Who are Foreign-Born.xls" style=Minimal;

%Count_table( 
  where= %str( age25to64=1 and foreign=1),
  row_var= emp25to64,
  row_fmt= emp25to64_f.,
  weight= perwt, 
  universe= Individuals who are Foreign-Born Ages 25 to 64,
  title= "Table 34. Share of Population Ages 25-64 that is Employed Who are Foreign-Born" );

run;


