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
%DCData_lib( Equity )
%DCData_lib( ACS )


%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=work.death_pop,
dat_org_geo=geo2010,
dat_count_vars= agegroup_1 agegroup_2 agegroup_3 agegroup_4 agegroup_5 agegroup_6 agegroup_7 agegroup_8 agegroup_9 agegroup_10 agegroup_11 ,
wgt_ds_name=Wt_tr10_ward12,
wgt_org_geo=Geo2010,
wgt_new_geo=ward2012, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=pop_by_ward,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars=
,
calc_vars_labels=

)
