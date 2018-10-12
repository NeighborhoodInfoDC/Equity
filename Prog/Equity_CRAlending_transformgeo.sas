/**************************************************************************
 Program:  Equity_CRAlending_transformgeo.sas
 Library:  Equtiy
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  9/12/18
 Version:  SAS 9.4
 Environment:  Windows with SAS/Connect
 
 Description:  transform small business loan per employee from tract level to neighborhood cluster and ward

CRA lending data (AvgAnnualAmt): https://www.ffiec.gov/craadweb/aggregate.aspx 
2014-2016 three year average tract level loan between 10,000- 1 million is cleaned by Equity_CRA_pull.do program

Small business employee data: LEHD Origin-Destination Employment Statistics (LODES)
2015 data (latest year) is extracted using LED_pull.do program


 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Equity );
%DCData_lib( ACS );

libname CRA "L:\Libraries\Equity\Raw" ;

data CRA_lending;
	set CRA.CRAbyTract;
run;

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=CRA_lending,
dat_org_geo=geo2010,
dat_count_vars= SBemployees_total AvgAnnualAmt,
wgt_ds_name=general.Wt_tr10_cl17,
wgt_org_geo=Geo2010,
wgt_new_geo=cluster2017, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=CRA_by_cl17,
calc_vars= 
CRAperEmp = AvgAnnualAmt / SBemployees_total;
,
calc_vars_labels=

);

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=CRA_lending,
dat_org_geo=Geo2010,
dat_count_vars= SBemployees_total AvgAnnualAmt,
wgt_ds_name=general.Wt_tr10_ward12,
wgt_org_geo=Geo2010,
wgt_new_geo=Ward2012, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=CRA_by_ward,
calc_vars=
CRAperEmp = AvgAnnualAmt / SBemployees_total;
,
calc_vars_labels=

)

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=CRA_lending,
dat_org_geo=Geo2010,
dat_count_vars= SBemployees_total AvgAnnualAmt,
wgt_ds_name=general.Wt_tr10_city,
wgt_org_geo=Geo2010,
wgt_new_geo=city, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=CRA_by_city,
calc_vars= 
CRAperEmp = AvgAnnualAmt / SBemployees_total;
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

proc export data=CRA_by_city
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\CRA_lending_city_format.csv"
dbms=csv replace;
run;
