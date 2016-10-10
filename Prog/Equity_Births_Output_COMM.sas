/**************************************************************************
 Program:  Equity_ACS_profile_COMM.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey & S. Diby
 Created:  08/22/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Outputs  data in  decimal format for COMM. 
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )


*output population by race;

	/*Make sure all vars are labeled*/;

/*Birth indicators by race*/
data all (drop=q); 
set equity.city_births_gaps
	(keep= 	city ward2012 cluster_tr2000 
			Births_total_2011 births_total_3yr_2011
			Pct_births_w_race_2011 births_w_race_2011 
			Pct_births_low_wt_2011 Births_low_wt_2011 Births_w_weight_2011
			Pct_births_prenat_adeq_2011 births_prenat_adeq_2011 Births_w_prenat_2011
			Pct_births_teen_2011 Births_teen_2011 Births_w_age_2011); 	

length race $10.;
race="All";

array old {4} 	Pct_births_w_race_2011 Pct_births_low_wt_2011 
				Pct_births_prenat_adeq_2011 Pct_births_teen_2011;

array new {4}  	Pct_births_w_race_2011 Pct_births_low_wt_2011 
			   	Pct_births_prenat_adeq_2011 Pct_births_teen_2011;
;

				do q=1 to 4; 

				   	new{q}=old{q}/100;
					if old{q}=.s then new{q}=.s;

				end; 
run;
data white (drop=q); 
set equity.city_births_gaps
	(keep= 	city ward2012 cluster_tr2000 
			Pct_births_white_2011 Births_white_2011 
			Pct_births_white_3yr_2011 Births_white_3yr_2011 
			Pct_births_low_wt_wht_2011 Births_low_wt_wht_2011 Births_w_weight_wht_2011
			Pct_births_prenat_adeq_wht_2011 Births_prenat_adeq_wht_2011 Births_w_prenat_wht_2011 
			Pct_births_teen_wht_2011 Births_teen_wht_2011 Births_w_age_wht_2011); 	

length race $10.;

race="White";

array old {5} 	Pct_births_white_2011 
				Pct_births_white_3yr_2011
				Pct_births_low_wt_wht_2011 	
				Pct_births_prenat_adeq_wht_2011 	
				Pct_births_teen_wht_2011;

array new {5} 	nPct_births_white_2011 
				nPct_births_white_3yr_2011
				nPct_births_low_wt_wht_2011 	
				nPct_births_prenat_adeq_wht_2011 	
				nPct_births_teen_wht_2011;

				do q=1 to 5; 

				   	new{q}=old{q}/100;
					if old{q}=.s then new{q}=.s;

				end; 

	rename 	Births_white_2011 = births_w_race_2011 
			Births_white_3yr_2011 = births_total_3yr_2011
			Births_low_wt_wht_2011 = Births_low_wt_2011
			Births_w_weight_wht_2011 = Births_w_weight_2011
			Births_prenat_adeq_wht_2011 = births_prenat_adeq_2011
			Births_w_prenat_wht_2011 = Births_w_prenat_2011
			Births_teen_wht_2011 = Births_teen_2011 
			Births_w_age_wht_2011 =	Births_w_age_2011;

run;

data black (drop=q); 
set equity.city_births_gaps
	(keep= 	city ward2012 cluster_tr2000 

			Pct_births_black_2011 Births_black_2011 
			Pct_births_black_3yr_2011 Births_black_3yr_2011 

			Births_low_wt_blk_2011 Births_w_weight_blk_2011
			Pct_births_low_wt_blk_2011 Gap_births_low_wt_blk_2011 

			Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
			Births_prenat_adeq_blk_2011 Births_w_prenat_blk_2011 

			Pct_births_teen_blk_2011 Gap_births_teen_blk_2011
			Births_teen_blk_2011 Births_w_age_blk_2011); 	

length race $10.;

race="Black";

array old {5} 	Pct_births_black_2011 
				Pct_births_black_3yr_2011
				Pct_births_low_wt_blk_2011 	
				Pct_births_prenat_adeq_blk_2011 	
				Pct_births_teen_blk_2011;

array new {5} 	nPct_births_black_2011 
				nPct_births_black_3yr_2011
				nPct_births_low_wt_blk_2011 	
				nPct_births_prenat_adeq_blk_2011 	
				nPct_births_teen_blk_2011;

				do q=1 to 5; 

				   	new{q}=old{q}/100;
					if old{q}=.s then new{q}=.s;

				end; 

	rename 	Births_black_2011 = births_w_race_2011 
			Births_black_3yr_2011 = births_total_3yr_2011
			Births_low_wt_blk_2011 = Births_low_wt_2011
			Births_w_weight_blk_2011 = Births_w_weight_2011
			Births_prenat_adeq_blk_2011 = births_prenat_adeq_2011
			Births_w_prenat_blk_2011 = Births_w_prenat_2011
			Births_teen_blk_2011 = Births_teen_2011 
			Births_w_age_blk_2011 =	Births_w_age_2011
			Gap_births_low_wt_blk_2011 = Gap_births_low_wt_2011
			Gap_births_prenat_adeq_blk_2011 = Gap_births_prenat_adeq_2011
			Gap_births_teen_blk_2011 = Gap_births_teen_2011;


run;

data hispanic (drop=q); 
set equity.city_births_gaps
	(keep= 	city ward2012 cluster_tr2000 
			Pct_births_hisp_2011 Births_hisp_2011 
			Pct_births_hisp_3yr_2011 Births_hisp_3yr_2011 

			Pct_births_low_wt_hsp_2011 Gap_births_low_wt_hsp_2011
			Births_low_wt_hsp_2011 Births_w_weight_hsp_2011

			Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
			Births_prenat_adeq_hsp_2011 Births_w_prenat_hsp_2011 

			Pct_births_teen_hsp_2011 Gap_births_teen_hsp_2011
			Births_teen_hsp_2011 Births_w_age_hsp_2011); 	

length race $10.;

race="Hispanic";

array old {5} 	Pct_births_hisp_2011 
				Pct_births_hisp_3yr_2011
				Pct_births_low_wt_hsp_2011 	
				Pct_births_prenat_adeq_hsp_2011 	
				Pct_births_teen_hsp_2011;

array new {5} 	nPct_births_hisp_2011 
				nPct_births_hisp_3yr_2011
				nPct_births_low_wt_hsp_2011 	
				nPct_births_prenat_adeq_hsp_2011 	
				nPct_births_teen_hsp_2011;

				do q=1 to 5; 

				   	new{q}=old{q}/100;
					if old{q}=.n then new{q}=.n;
					if old{q}=.s then new{q}=.s;

				end; 

	rename 	Births_hisp_2011 = births_w_race_2011 
			Births_hisp_3yr_2011 = births_total_3yr_2011
			Births_low_wt_hsp_2011 = Births_low_wt_2011
			Births_w_weight_hsp_2011 = Births_w_weight_2011
			Births_prenat_adeq_hsp_2011 = births_prenat_adeq_2011
			Births_w_prenat_hsp_2011 = Births_w_prenat_2011
			Births_teen_hsp_2011 = Births_teen_2011 
			Births_w_age_hsp_2011 =	Births_w_age_2011
			Gap_births_low_wt_hsp_2011 = Gap_births_low_wt_2011
			Gap_births_prenat_adeq_hsp_2011 = Gap_births_prenat_adeq_2011
			Gap_births_teen_hsp_2011 = Gap_births_teen_2011;

run;

data all_race (label="Births Tabulations for COMM");
	set all white black hispanic;
	run;

proc sort data=all_race out=equity.births_ward_comm (drop=cluster_tr2000);
by ward2012 race;

/*proc sort data=all_race out=equity.births_cluster_comm (drop=ward2012);
by cluster_tr2000 race;*/

proc export data=equity.births_ward_comm
	outfile="D:\DCDATA\Libraries\Equity\Prog\Births_Ward_COMMOutput.csv"
	dbms=csv replace;
	run;
/*proc export data=equity.births_cluster_comm
	outfile="D:\DCDATA\Libraries\Equity\Prog\Births_Cluster_COMMOutput.csv"
	dbms=csv replace;
	run;*/

proc contents data=equity.births_ward_comm;
run;

/*proc contents data=equity.births_cluster_comm;
run;*/
