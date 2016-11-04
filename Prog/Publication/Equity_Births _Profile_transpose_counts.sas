/**************************************************************************
 Program:  Equity_ACS_profile_transpose.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey & S. Diby
 Created:  08/22/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Transposes calculated indicators for Equity profiles 
			   and merges calculated statistics for ACS data at different geographies.
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let racelist=blk asn wht hsp oth;
%let racename= NH-Black NH-AsianPI Hispanic NH-White NH-Other; 

proc transpose data=equity.city_births_gaps out=equity.profile_tabs_births_count_wd12; 
var Births_total_2011
	births_total_3yr_2011
	births_w_race_2011 

	births_white_2011 
	births_asian_2011 
	births_black_2011
	births_hisp_2011
	births_oth_rac_2011 

	births_white_3yr_2011
	births_asian_3yr_2011
	births_black_3yr_2011 
	births_hisp_3yr_2011 
	births_oth_rac_3yr_2011

	Births_w_weight_2011
	births_w_weight_wht_2011 	
	births_w_weight_blk_2011
	births_w_weight_hsp_2011
	births_w_weight_asn_2011
	births_w_weight_oth_2011

	births_low_wt_2011 	
	births_low_wt_wht_2011 	
	births_low_wt_blk_2011	Gap_births_low_wt_blk_2011
	births_low_wt_hsp_2011 	Gap_births_low_wt_hsp_2011
	births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
	
	Births_w_prenat_2011
	births_w_prenat_wht_2011 	
	births_w_prenat_blk_2011
	births_w_prenat_hsp_2011
	births_w_prenat_asn_2011
	births_w_prenat_oth_2011 

	births_prenat_adeq_2011 	
	births_prenat_adeq_wht_2011 	
	births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
	births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
	
	Births_w_age_2011
	births_w_age_wht_2011 	
	births_w_age_blk_2011
	births_w_age_hsp_2011
	births_w_age_asn_2011
	births_w_age_oth_2011

	births_teen_2011 	
	births_teen_wht_2011 	
	births_teen_blk_2011 Gap_births_teen_blk_2011
	births_teen_hsp_2011 Gap_births_teen_hsp_2011
	births_teen_asn_2011 Gap_births_teen_asn_2011
	births_teen_oth_2011 Gap_births_teen_oth_2011
	;
id ward2012; 
run; 

proc transpose data=equity.city_births_gaps out=equity.profile_tabs_births_count_cltr00; 
var Births_total_2011
	births_total_3yr_2011
	births_w_race_2011 

	births_white_2011 
	births_asian_2011 
	births_black_2011
	births_hisp_2011
	births_oth_rac_2011 

	births_white_3yr_2011
	births_asian_3yr_2011
	births_black_3yr_2011 
	births_hisp_3yr_2011 
	births_oth_rac_3yr_2011

	Births_w_weight_2011
	births_w_weight_wht_2011 	
	births_w_weight_blk_2011
	births_w_weight_hsp_2011
	births_w_weight_asn_2011
	births_w_weight_oth_2011

	births_low_wt_2011 	
	births_low_wt_wht_2011 	
	births_low_wt_blk_2011	Gap_births_low_wt_blk_2011
	births_low_wt_hsp_2011 	Gap_births_low_wt_hsp_2011
	births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
	
	Births_w_prenat_2011
	births_w_prenat_wht_2011 	
	births_w_prenat_blk_2011
	births_w_prenat_hsp_2011
	births_w_prenat_asn_2011
	births_w_prenat_oth_2011 

	births_prenat_adeq_2011 	
	births_prenat_adeq_wht_2011 	
	births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
	births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
	
	Births_w_age_2011
	births_w_age_wht_2011 	
	births_w_age_blk_2011
	births_w_age_hsp_2011
	births_w_age_asn_2011
	births_w_age_oth_2011

	births_teen_2011 	
	births_teen_wht_2011 	
	births_teen_blk_2011 Gap_births_teen_blk_2011
	births_teen_hsp_2011 Gap_births_teen_hsp_2011
	births_teen_asn_2011 Gap_births_teen_asn_2011
	births_teen_oth_2011 Gap_births_teen_oth_2011
	;
id cluster_tr2000; 
run; 


proc sort data=equity.profile_tabs_births_count_wd12 out=profile_tabs_births_wd12_count; 
	by _name_;
run;

proc sort data=equity.profile_tabs_births_count_cltr00 out=profile_tabs_births_cltr00_count; 
	by _name_;
run;


proc export data=equity.profile_tabs_births_count_wd12
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_ward_count.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_births_count_cltr00
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_cluster_count.csv"
	dbms=csv replace;
	run;


