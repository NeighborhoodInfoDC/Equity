/**************************************************************************
 Program:  Equity_Births_Output_COMM.sas
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
data all (drop=q Pct:); 
set equity.births_gaps_allgeo
	(keep= 	city ward2012 cluster_tr2000 
			Births_total_2011
			Pct_births_w_race_2011 births_w_race_2011 
			Pct_births_low_wt_2011 Births_low_wt_2011 Births_w_weight_2011
			Pct_births_prenat_adeq_2011 births_prenat_adeq_2011 Births_w_prenat_2011
			Pct_births_teen_2011 Births_teen_2011 Births_w_age_2011); 	

length race $10. ID $11.;
race="All";

if city="1" then ID="0";
if Ward2012~=" " then ID=Ward2012;
if cluster_tr2000~=" " then ID=Cluster_Tr2000;

array old {4} 	Pct_births_w_race_2011 Pct_births_low_wt_2011 
				Pct_births_prenat_adeq_2011 Pct_births_teen_2011;

array new {4}  	nPct_births_w_race_2011 nPct_births_low_wt_2011 
			   	nPct_births_prenat_adeq_2011 nPct_births_teen_2011;
;

				do q=1 to 4; 

				   	new{q}=old{q}/100;
					if old{q}=.s then new{q}=.s;

				end; 
run;
data white (drop=q Pct:); 
set equity.births_gaps_allgeo
	(keep= 	city ward2012 cluster_tr2000 
			Pct_births_white_2011 Births_white_2011 
			Pct_births_low_wt_wht_2011 Births_low_wt_wht_2011 Births_w_weight_wht_2011
			Pct_births_prenat_adeq_wht_2011 Births_prenat_adeq_wht_2011 Births_w_prenat_wht_2011 
			Pct_births_teen_wht_2011 Births_teen_wht_2011 Births_w_age_wht_2011); 	

length race $10. ID $11.;
race="White";

if city="1" then ID="0";
if Ward2012~=" " then ID=Ward2012;
if cluster_tr2000~=" " then ID=Cluster_Tr2000;

array old {4} 	Pct_births_white_2011 
				Pct_births_low_wt_wht_2011 	
				Pct_births_prenat_adeq_wht_2011 	
				Pct_births_teen_wht_2011;

array new {4} 	nPct_births_w_race_2011 
				nPct_births_low_wt_2011 	
				nPct_births_prenat_adeq_2011 	
				nPct_births_teen_2011;

				do q=1 to 4; 

				   	new{q}=old{q}/100;
					if old{q}=.s then new{q}=.s;

				end; 

	rename 	Births_white_2011 = Births_w_race_2011 
			Births_low_wt_wht_2011 = Births_low_wt_2011
			Births_w_weight_wht_2011 = Births_w_weight_2011
			Births_prenat_adeq_wht_2011 = Births_prenat_adeq_2011
			Births_w_prenat_wht_2011 = Births_w_prenat_2011
			Births_teen_wht_2011 = Births_teen_2011 
			Births_w_age_wht_2011 =	Births_w_age_2011;

run;

data black (drop=q Pct:); 
set equity.births_gaps_allgeo
	(keep= 	city ward2012 cluster_tr2000 

			Pct_births_black_2011 Births_black_2011 
			Births_low_wt_blk_2011 Births_w_weight_blk_2011
			Pct_births_low_wt_blk_2011 Gap_births_low_wt_blk_2011 

			Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
			Births_prenat_adeq_blk_2011 Births_w_prenat_blk_2011 

			Pct_births_teen_blk_2011 Gap_births_teen_blk_2011
			Births_teen_blk_2011 Births_w_age_blk_2011); 	

length race $10. ID $11.;
race="Black";

if city="1" then ID="0";
if Ward2012~=" " then ID=Ward2012;
if cluster_tr2000~=" " then ID=Cluster_Tr2000;


array old {4} 	Pct_births_black_2011 
				Pct_births_low_wt_blk_2011 	
				Pct_births_prenat_adeq_blk_2011 	
				Pct_births_teen_blk_2011;

array new {4} 	nPct_births_w_race_2011 
				nPct_births_low_wt_2011 	
				nPct_births_prenat_adeq_2011 	
				nPct_births_teen_2011;

				do q=1 to 4; 

				   	new{q}=old{q}/100;
					if old{q}=.s then new{q}=.s;

				end; 

	rename 	Births_black_2011 = Births_w_race_2011 
			Births_low_wt_blk_2011 = Births_low_wt_2011
			Births_w_weight_blk_2011 = Births_w_weight_2011
			Births_prenat_adeq_blk_2011 = Births_prenat_adeq_2011
			Births_w_prenat_blk_2011 = Births_w_prenat_2011
			Births_teen_blk_2011 = Births_teen_2011 
			Births_w_age_blk_2011 =	Births_w_age_2011
			Gap_births_low_wt_blk_2011 = Gap_births_low_wt_2011
			Gap_births_prenat_adeq_blk_2011 = Gap_births_prenat_adeq_2011
			Gap_births_teen_blk_2011 = Gap_births_teen_2011;


run;

data hispanic (drop=q Pct:); 
set equity.births_gaps_allgeo
	(keep= 	city ward2012 cluster_tr2000 
			Pct_births_hisp_2011 Births_hisp_2011 
			Pct_births_low_wt_hsp_2011 Gap_births_low_wt_hsp_2011
			Births_low_wt_hsp_2011 Births_w_weight_hsp_2011

			Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
			Births_prenat_adeq_hsp_2011 Births_w_prenat_hsp_2011 

			Pct_births_teen_hsp_2011 Gap_births_teen_hsp_2011
			Births_teen_hsp_2011 Births_w_age_hsp_2011); 	

length race $10. ID $11.;
race="Hispanic";

if city="1" then ID="0";
if Ward2012~=" " then ID=Ward2012;
if cluster_tr2000~=" " then ID=Cluster_Tr2000;

array old {4} 	Pct_births_hisp_2011 
				Pct_births_low_wt_hsp_2011 	
				Pct_births_prenat_adeq_hsp_2011 	
				Pct_births_teen_hsp_2011;

array new {4} 	nPct_births_w_race_2011 
				nPct_births_low_wt_2011 	
				nPct_births_prenat_adeq_2011 	
				nPct_births_teen_2011;

				do q=1 to 4; 

				   	new{q}=old{q}/100;
					if old{q}=.n then new{q}=.n;
					if old{q}=.s then new{q}=.s;

				end; 

	rename 	Births_hisp_2011 = Births_w_race_2011 
			Births_low_wt_hsp_2011 = Births_low_wt_2011
			Births_w_weight_hsp_2011 = Births_w_weight_2011
			Births_prenat_adeq_hsp_2011 = Births_prenat_adeq_2011
			Births_w_prenat_hsp_2011 = Births_w_prenat_2011
			Births_teen_hsp_2011 = Births_teen_2011 
			Births_w_age_hsp_2011 =	Births_w_age_2011
			Gap_births_low_wt_hsp_2011 = Gap_births_low_wt_2011
			Gap_births_prenat_adeq_hsp_2011 = Gap_births_prenat_adeq_2011
			Gap_births_teen_hsp_2011 = Gap_births_teen_2011;

run;

data all_race (label="Births Tabulations for COMM");
	retain  ID city ward2012 cluster_tr2000 race Births_total_2011
			Births_w_race_2011 nPct_births_w_race_2011 
			Births_w_weight_2011
			Births_low_wt_2011 nPct_births_low_wt_2011 Gap_births_low_wt_2011 
			Births_w_prenat_2011
			Births_prenat_adeq_2011 nPct_births_prenat_adeq_2011 Gap_births_prenat_adeq_2011
			Births_w_age_2011
			Births_teen_2011 nPct_births_teen_2011 Gap_births_teen_2011
			;
	set all white black hispanic;

	label
		nPct_births_w_race_2011 = "% Births with mothers race reported"
		nPct_births_low_wt_2011 = "% low weight births (under 5.5 lbs)"
		nPct_births_prenat_adeq_2011 = "% Births to mothers with adequate prenatal care"
		nPct_births_teen_2011 = "% births to teen mothers"
		Births_w_race_2011 = "Total births with mothers race reported"
		Births_low_wt_2011 = "Low weight births (under 5.5 lbs)"
		Births_w_weight_2011 = "Births with birth weight reported"
		Births_prenat_adeq_2011 = "Births with adequate prenatal care (Kessner index)"
		Births_w_prenat_2011 = "Births with prenatal care reported (Kessner index)"
		Births_teen_2011 = "Births to mothers under 20 years old"
		Births_w_age_2011 = "Births with mother's age reported"
		Gap_births_low_wt_2011 = "Racial gap, low birth weight"
		Gap_births_prenat_adeq_2011 = "Racial gap, adequate prenatal care"
		Gap_births_teen_2011 = "Racial gap, teen births"
		;

	run;

proc sort data=all_race;

by cluster_tr2000 Ward2012 city;

proc export data=all_race
	outfile="D:\DCDATA\Libraries\Equity\Prog\Racial Equity Feature\profile_tabs_births_Comms.csv"
	dbms=csv replace;
	run;

proc contents data=all_race;
run;
