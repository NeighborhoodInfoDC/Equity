
/**************************************************************************
 Program:  Equity_formats_2010_14.sas
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
	07/25/16 MW Modified for ACS 2010-14, Equity and the SAS1 Server
**************************************************************************/

*%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( IPUMS );
%DCDATA_lib( Equity);

***** Formats *****;

proc format;

  /** PUMA to selected counties (combine Arlington & Alexandria) **/

  value $pumctyb (notsorted)
    '1100101' = 'District of Columbia'
    '1100102' = 'District of Columbia'
    '1100103' = 'District of Columbia'
    '1100104' = 'District of Columbia'
    '1100105' = 'District of Columbia'
    '2401001' = 'Montgomery'
    '2401002' = 'Montgomery'
    '2401003' = 'Montgomery'
    '2401004' = 'Montgomery'
    '2401005' = 'Montgomery'
    '2401006' = 'Montgomery'
    '2401007' = 'Montgomery'
    '2401101' = 'Prince George''s'
    '2401102' = 'Prince George''s'
    '2401103' = 'Prince George''s'
    '2401104' = 'Prince George''s'
    '2401105' = 'Prince George''s'
    '2401106' = 'Prince George''s'
    '2401107' = 'Prince George''s'
    '5100100' = 'Arlington'
    '5100200' = 'Alexandria'
    '5100301' = 'Fairfax/Fairfax City/Falls Church'
    '5100302' = 'Fairfax/Fairfax City/Falls Church'
    '5100303' = 'Fairfax/Fairfax City/Falls Church'
    '5100304' = 'Fairfax/Fairfax City/Falls Church'
    '5100305' = 'Fairfax/Fairfax City/Falls Church'
	'5100501' = 'Prince William/Manassas/Manassas Park'
	'5100502' = 'Prince William/Manassas/Manassas Park'
	'5100600' = 'Loudoun/Fauquier/Clarke/Warren'
    other = ' ';

  value race 
    1 = 'White'
	2 = 'Black'
	4-6 = 'Asian'
	3,7 = 'Other'
	8,9 = 'Multiple';

  value raceui
    1 = 'Non-Hispanic White'
	2 = 'Non-Hispanic Black'
	3 = 'Hispanic'
	4 = 'Non-Hispanic Asian'
	5 = 'Non-Hispanic Other'
	6 = 'Non-Hispanic Multiple';
 
  value sex (notsorted)
    2 = 'Women'
	1 = 'Men';

  value labforce
    1 = 'Not in LF'
	2 = 'Yes in LF'
	0 = 'N/A';

  value empstat
    1 = 'Employed'
	2 = 'Unemployed'
	3 = 'Not in labor force';
 
  value empui
    1 = 'Employed'
	0 = 'Unemployed';

  value Hispan
    1-4 = 'Hispanic'
	  0 = 'Not Hispanic'
	  9 = 'Not reported';

  value age
    000-005 = '0-5 years old'
	006-017 = '6-17 years old'
	018-034 = '18-34 years old'
	035-064 = '35-64 years old'
	065-093 = '65 years and older';

  value ageui
    1 = '0-5 years old'
	2 = '6-17 years old'
	3 = '18-34 years old'
	4 = '35-64 years old'
	5 = '65 years and older';

  value girlage
    1 = '0-11 years old'
    2 = '12-17 years old'
    3 = '18-24 years old';

  value womage
    1 = '25 years and older';

  value hage
	1 = '0-17 years old'
    2 = '18-24 years old'
    3 = '25-64 years old'
	4 = '65 years and older';
 
  value ind
    017-019, 027-029     = 'Agriculture, Forestry, Fishing and Hunting'
	037-039, 047-049     = 'Mining'
	057-059, 067-069     = 'Utilities'
	             077     = 'Construction'
	107-109, 117-119,
	127-129, 137, 139,
	147-149, 157, 159,
	167-169, 177, 179,
	187-189, 199, 207,
	209, 217-219,
	227-229, 237-239,
	247-249, 257, 259,
	267-269, 277-279,
	287-289, 297-299,
	307-309, 317-319,
	329, 336-339, 347,
	349, 357-359,
	367-369, 377-379,
	387, 389, 396-399    = 'Manufacturing'
	407-409, 417-419,
	426-429, 437-439,
	447-449, 456-459     = 'Wholesale Trade'
	467-469, 477-479,
	487-489, 497-499,
	507-509, 517-519,
	527-529, 537-539,
	547-549, 557-559,
	567-569, 579         = 'Retail Trade'
	607-609, 617-619,
	627-629, 637-639     = 'Transport and Wareshousing'
	647-649, 657, 659,    
	667-669, 677-679     = 'Information and Communications'
	687-689, 697, 699,    
    707, 708, 717-719    = 'Finance, Insurance, Real Estate and Rental and Leasing'
    727-729, 737-739,
	746-749, 757-759,
	767-769, 777-779     = 'Professional, Scientific, Management, Administrative Services'
	786-789, 797-799,
	807-809, 817-819,
	827, 829, 837-839,
	847                  = 'Education, Health and Social Services'
	856-859, 866-869     = 'Arts, Entertainment, Recreation, Accomodation, Food Services'
	877-879, 887-889,
	897-899, 907-909,
	916-919, 929         = 'Other Services (Except Public Administration)'
	937-939, 947-949,
	957, 959             = 'Public Administration'
	967-969, 977-979,
	987                  = 'Active Duty Military'
	             992     = 'Unemployed';

  value poverty
    000 = 'N/A'
	001 = '1 percent or less of poverty threshold'
	501 = '501 percent or more of poverty threshold';

  value povui
    1 = 'Poverty'
	2 = 'Not in poverty'
	3 = 'N/A';

  value hpov
	1 = '0-100% federal poverty level'
    2 = '101-200% federal poverty level'
    3 = '201%+ federal poverty level';

  value famui
    1 = 'Women-headed household with related children'
    2 = 'Women-headed household without related children'
    3 = 'Male-headed household with related children'
    4 = 'Male-headed household without related children'
    5 = 'Married couple with related children'
    6 = 'Married couple without related children';
  
  value indui
    1 = 'Agriculture, Forestry, Fishing and Hunting'
	2 = 'Mining'
	3 = 'Utilities'
	4 = 'Construction'
	5 = 'Manufacturing'
	6 = 'Wholesale trade'
	7 = 'Retail trade'
	8 = 'Transport and warehousing'
	9 = 'Information and Communication'
	10 = 'Finance, Insurance, Real Estate and Rental and Leasing'
	11 = 'Professional, Scientific, and Management'
	12 = 'Education, Health and Social Services'
	13 = 'Arts, Entertainment, Recreation, Accomodation, Food Services'
	14 = 'Other Services'
	15 = 'Public Administration'
	16 = 'Active Duty Military';

  value crowd
    1  = 'Household is overcrowded'
	0  = 'Household is NOT overcrowded';

  value Affprob
    1  = 'Affordability problem';

  value Sevaff
    1  = 'Severe affordability problem';

  value forborn
    1  = 'Born abroad of American parents'
    2  = 'Naturalized citizen'
    3  = 'Not a citizen';

  value occup

    1  = 'Office and Administrative support'
    2  = 'Management'
	3  = 'Business and financial operations'
	4  = 'Sales occupations'
  	5  = 'Education, training and library'
	6  = 'Healthcare, practitioner, technical'
	7  = 'Computer and mathematical'
	8  = 'Personal care and service'
	9  = 'Food preparation and serving'
 	10 = 'Arts, Design, Entertainment, Sports and Media'
	11 = 'Healthcare support'
 	12 = 'Building and Grounds cleaning and maintenance'
	13 = 'Community and Social Service'
  	14 = 'Life, Physical and Social Science'
  	15 = 'Protective service'
	16 = 'Production'
	17 = 'Transportation and material moving'
  	18 = 'Architecture and engineering'
	19 = 'Construction and extraction'
 	20 = 'Installation and maintenance and repairs';

   value edatt
    0  = 'Less than 9th grade'
  	1  = '9th to 12th grade, no diploma'
	2  = 'High school graduation, GED or alternative'
  	3  = 'Some college, no degree'
  	4  = 'Associates degree'
	5  = 'Bachelors degree'
 	6  = 'Graduate or professional degree';

   value country
	1  = 'Central America'
 	2  = 'Africa'
  	3  = 'West Indies'
	4  = 'South America'
 	5  = 'Mexico'
 	6  = 'China'
	7  = 'India'
 	8  = 'Korea'
 	9  = 'France'
	10 = 'Canada'
 	11 = 'Other';

   value speakengui
	1  = 'Well'
    2  = 'Not well'
    3  = 'Not at all';

	value hcovsourceui
    1  = 'Employer or union only'
    2  = 'Purchased directly only'
    3  = 'Medicaid only'
    4  = 'Medicare only'
	5  = 'Other public health coverage only (TRICARE, VA, IHS)'
    6  = 'Employer or union and purchased directly'
    7  = 'Medicare and employer/union'
    8  = 'Medicare and Medicaid'
    9  = 'Other combinations of health coverage'
    10 = 'No health insurance coverage';

	value ftpt (notsorted)
    35 - high = 'Full time (35+ hrs/wk)'
    1 - < 35 = 'Part time'
    0 = 'Did not work';

	value rentunit
	0 = "N/A"
	1 - 2 = "Mobile Home or Other Type of Housing"
	3 - 4 = "Single-Family"
	5 - 6 = "2 - 4 Units"
	7 = "5 - 9 Units"
	8 - 10 = "10+ Units";

	value hudinc
	.n = "Missing"
	1 = "Extremely low (0-30% AMI)"
	2 = "Very low (31-50%)"
	3 = "Low (51-80%)"
	4 = "Middle (81-120%)"
	5 = "High (over 120%)";

	value numbeds
	0 = "N/A"
	1 = "Efficiency"
	2 = "One Bedroom"
	3 = "Two Bedroom"
	4 - 22 = "Three or more Bedrooms";

	value grsrent
	0 = "N/A"
	1 - < 800 = "Under $800"
	800 - < 1330 = "$800 - $1,330"
	1330 - < 1690 = "$1,330 - $1,690"
	1690 - < 3180 = "$1,690 - $3,190"
	3190 - high = "$3,190 or more";

	value affprob
	0 = "Paying less than 30% of Household Income in Housing Costs"
	1 = "Paying 30%-50% of Household Income in Housing Costs"
	2 = "Paying 50% or more of Household Income in Housing Costs";

	value hhinc
	low - < 50000 = "Less than $50,000"
	50000 - < 75000 = "$50,000 - $74,999"
	75000 - < 9999999 = "$75,000 or more"
	9999999 = "N/A";

	value mortform
	0 = "N/A"
	1 = "No Mortgage"
	2 - 4 = "Mortgage";

	value hvalue
	low - < 50000 = "Less than $50,000"
	50000 - < 100000 = "$50,000 - $99,999"
	100000 - < 150000 = "$100,000 - $149,999"
	150000 - < 200000 = "$150,000 - $199,999"
	200000 - < 300000 = "$200,000 - $299,999"
	300000 - < 500000 = "$300,000 - $499,999"
	500000 - < 9999999 = "$500,000 or more" 
	9999999 = "N/A";

	value owncost
	low - < 740 = "Less than $740"
	740 - < 1240 = "$740 - $1,240"
	1240 - < 1580 = "$1,240 - $1,580"
	1580 - < 2970 = "$1,580 - $2,970"
	2970 - < 99999 = "$2,970 or more"
	99999 = "Not in universe";

	value agecat
	low - < 18 = "Under 18"
	18 - < 65 = "18 - 64"
	65 - high = "65 and Older";

	value hhtype_new
	0 = "Single Adult Only"
	1 = "Families with Children"
	2 = "Other Families"
	3 = "Non-Family"
	4 = "Other arrangements"
;

	value haveelderly
	0 = "No elderly members"
	1 = "Has at least 1 elderly member";

	value hasdis
	0 = "No disabled members"
	1 = "Has at least 1 disabled member";

	value haselddis
	0 = "No elderly and disabled members"
	1 = "Has at least 1 elderly, disabled member";

	value hhsize
	0 = "Vacant"
	1 = "One Person"
	2 = "Two Persons"
	3 = "Three Persons"
	4 - 6 = "4 - 6 Persons"
	7 - high = "7 or more Persons";

	value emp_age
	0 = "No One in the Household Working, At Least One Working Age Member"
	1 = "No One in the Household Working, All Adults Older than 65"
	2 = "At Least One Member with a Part-Time Job, No Full Time Workers"
	3 = "At Least One Member with a Full-Time Job";

	value yesno
	0 = "No"
	1 = "Yes";

	value age25to64_f 
	. = "Not 25 to 64"
	1 = "Age 25 to 64";

	value employed
	. = "Not Employed"
	1 = "Employed";

	value emp25to64_f 
	0 = "Ages 25 to 64 and Unemployed"
	1 = "Ages 25 to 64 and Employed"
	.u = "Ages 25 to 64 and Not in the Labor Force";

	/*value ownfreeclear
	.u = "Not owners"
	0 = "Do Not Own Free and Clear"
	1 = "Own Free and Clear";*/

	value ownmortgage
	.u = "Not Owners"
	0 = "Own Free and Clear"
	1 = "Own With Mortgage";

	value aff_unit
	1 = "Unit is Affordable at ELI (Below 30% of AMI)"
	2 = "Unit is Affordable at VLI (30%-50% of AMI)"
	3 = "Unit is Affordable at LI (50%-80% of AMIt)"
	4 = "Unit is Affordable at 80% AMI and above";

	value racecatA
	1 = "Non-Hispanic White"
	2 = "Non-Hispanic All Other Race"
	3 = "Hispanic";

	value racecatB
	1 = "Black Alone"
	2 = "Asian, Native American, Other or Multiple Race"
	3 = "White Alone";

	value category
	.= "Total"
	2= "Non-Hispanic White"
	3= "Non-Hispanic All Other"
	4= "Hispanic"
	5= "Black Alone"
	6= "Asian, American Indian, Other Alone and Multiple Race"
	7= "White Alone"
	8= "Foreign Born";

	value puma_id
	100 = "District of Columbia"
	101 = "101"
	102 = "102"
	103 = "103"
	104 = "104"
	105 = "105" ;
run;


