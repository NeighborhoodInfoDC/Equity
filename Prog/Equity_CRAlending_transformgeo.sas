/**************************************************************************
 Program:  Equity_CRAlending_transformgeo.sas
 Library:  Equtiy
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  9/12/18
 Version:  SAS 9.4
 Environment:  Windows with SAS/Connect
 
 Description:  transform small business loan per employee from tract level to neighborhood cluster and ward

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Equity );
%DCData_lib( ACS );

libname CRA "L:\Libraries\Equity\Raw" ;

data CRA_lending;
	set CRA.CRAbyTract;
	geo2010 = put(geoid,z12.);
run;

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=CRA_lending,
dat_org_geo=geo2010,
dat_count_vars= Denominator Grocery Retail_banks Check_cashing,
wgt_ds_name=general.Wt_tr10_cl17,
wgt_org_geo=Geo2010,
wgt_new_geo=cluster2017, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=CRA_by_cl17,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
,
calc_vars_labels=

);

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=CRA_lending,
dat_org_geo=GeoBg2010,
dat_count_vars= Denominator Grocery Retail_banks Check_cashing,
wgt_ds_name=general.Wt_tr10_ward12,
wgt_org_geo=Geo2010,
wgt_new_geo=Ward2012, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=CRA_by_ward,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
,
calc_vars_labels=

)

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=CRA_lending,
dat_org_geo=Geo2010,
dat_count_vars= Denominator Grocery Retail_banks Check_cashing,
wgt_ds_name=general.Wt_tr10_city,
wgt_org_geo=GeoBg2010,
wgt_new_geo=city, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=CRA_by_ward,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
,
calc_vars_labels=

)

data equity_CRA_by_cl17_format;
set CRA_by_cl17;
format cluster2017 $clus17f. ;
run;

proc export data=equity_CRA_by_cl17_format
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\CRA_lending_cl17_format.csv"
dbms=csv replace;
run;

proc export data=CRA_by_ward
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\CRA_lending_wd12_format.csv"
dbms=csv replace;
run;

proc export data=CRA_by_ward
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\CRA_lending_city_format.csv"
dbms=csv replace;
run;
