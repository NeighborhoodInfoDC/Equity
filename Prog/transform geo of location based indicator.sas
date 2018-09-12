/**************************************************************************
 Program:  transform geo of location based indicator.sas
 Library:  Equtiy
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  9/10/18
 Version:  SAS 9.4
 Environment:  Windows with SAS/Connect
 
 Description:  transform location based indicator from blockgroup level to neighborhood cluster and ward

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Equity );
%DCData_lib( ACS );

libname access "L:\Libraries\Equity\Raw" ;

data Access_to_locations;
	set access.access_to_locations (rename = (GeoBg2010 = GeoBg2010n));
	GeoBg2010 = put(GeoBg2010n,z12.);
run;

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=Access_to_locations,
dat_org_geo=GeoBg2010,
dat_count_vars= Denominator Grocery Retailbanks Checkcashing,
wgt_ds_name=general.Wt_bg10_cl17,
wgt_org_geo=GeoBg2010,
wgt_new_geo=cluster2017, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=pop_by_cl17,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
    equity_grocery= Grocery/Denominator;
	equity_banks= Retailbanks/Denominator;
	equity_checkcashing= Checkcashing/Denominator;
,
calc_vars_labels=

);

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=Access_to_locations,
dat_org_geo=GeoBg2010,
dat_count_vars= Denominator Grocery Retailbanks Checkcashing,
wgt_ds_name=general.Wt_bg10_ward12,
wgt_org_geo=GeoBg2010,
wgt_new_geo=Ward2012, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=pop_by_ward,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
    equity_grocery= Grocery/Denominator;
	equity_banks= Retailbanks/Denominator;
	equity_checkcashing= Checkcashing/Denominator;
,
calc_vars_labels=

)

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=Access_to_locations,
dat_org_geo=GeoBg2010,
dat_count_vars= Denominator Grocery Retail_banks Check_cashing,
wgt_ds_name=general.Wt_bg10_city,
wgt_org_geo=GeoBg2010,
wgt_new_geo=city, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=pop_by_city,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
    equity_grocery= Grocery/Denominator;
	equity_banks= Retailbanks/Denominator;
	equity_checkcashing= Checkcashing/Denominator;
,
calc_vars_labels=

)

data equity_location_by_cl17_format;
set pop_by_cl17;
format cluster2017 $clus17f. ;
run;

proc export data=equity_location_by_cl17_format
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeature_locations_cl17_format.csv"
dbms=csv replace;
run;

proc export data=pop_by_ward
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeature_locations_wd12_format.csv"
dbms=csv replace;
run;

proc export data=pop_by_city
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeature_locations_city_format.csv"
dbms=csv replace;
run;
