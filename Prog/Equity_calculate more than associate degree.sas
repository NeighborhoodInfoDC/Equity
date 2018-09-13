/**************************************************************************
 Program:  Equity_calculate more than associate degree.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  9/12/18
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  calculate adults with at least an assocaite degree

 **************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let _years=2012_16;

data associate_higher;
length indicator $80;
set ACS.Acs_sf_2012_16_dc_tr10;
keep indicator year geo2010 numerator denom;
indicator = "adults with at least an associate degree";
year = "2012-2016";
PctCol = (B15002e14 + B15002e15 + B15002e16 + B15002e17 + B15002e18 + B15002e31 + B15002e32 + B15002e33 + B15002e34 + B15002e35) / B15002e1;
denom = B15002e1;
numerator = (B15002e14 + B15002e15 + B15002e16 + B15002e17 + B15002e18 + B15002e31 + B15002e32 + B15002e33 + B15002e34 + B15002e35) ;
run;


%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=associate_higher,
dat_org_geo=Geo2010,
dat_count_vars= numerator denom,
wgt_ds_name=general.Wt_tr10_cl17,
wgt_org_geo=Geo2010,
wgt_new_geo=cluster2017, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=educ_by_cl17,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
      equityvariable=numerator/denom;
,
calc_vars_labels=

);


%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=associate_higher,
dat_org_geo=Geo2010,
dat_count_vars= numerator denom,
wgt_ds_name=general.Wt_tr10_ward12,
wgt_org_geo=Geo2010,
wgt_new_geo=Ward2012, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=educ_by_ward,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
    equityvariable=numerator/denom;
,
calc_vars_labels=

)

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=associate_higher,
dat_org_geo=Geo2010,
dat_count_vars= numerator denom,
wgt_ds_name=general.Wt_tr10_city,
wgt_org_geo=Geo2010,
wgt_new_geo=city, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=educ_by_city,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
    equityvariable=numerator/denom;
,
calc_vars_labels=

)

data equity_educ_by_cl17_format;
set educ_by_cl17;
format cluster2017 $clus17f. ;
run;

proc export data=equity_educ_by_cl17_format
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeature_highereduc_cl17_format.csv"
dbms=csv replace;
run;

proc export data=educ_by_ward
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeature_highereduc_wd12_format.csv"
dbms=csv replace;
run;

proc export data=educ_by_city
outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Equityfeature_highereduc_city_format.csv"
dbms=csv replace;
run;
