/**************************************************************************
 Program:  Equity_Births_profile_transpose.sas
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

data city_births;
	set equity.profile_births_city
			equity.profile_births_wd12
			equity.profile_births_cltr00;

			if city="1" then ward2012="0";
			if city="1" then cluster_tr2000="00";
			

run; 

*Add gap calculation - separate out city level white rates; 

data whiterates_births;
	set equity.profile_births_city 
	(keep= Pct_births_white_2011 Pct_births_white_3yr_2011 Pct_births_low_wt_wht_2011 
		   Pct_births_prenat_adeq_wht_2011 Pct_births_teen_wht_2011 _make_profile)
		   ;
	_make_profile=1;
	run;

%rename(whiterates_births);
run;

data equity.births_gaps_allgeo (label="Birth Gaps for All Geographies, 2011" drop=_make_profile b);
	merge city_births whiterates_births_new(rename=(c_make_profile=_make_profile));
	by _make_profile;
	
	Gap_births_low_wt_blk_2011=cPct_births_low_wt_wht_2011/100*Births_w_weight_blk_2011-Births_low_wt_blk_2011;
	Gap_births_low_wt_hsp_2011=cPct_births_low_wt_wht_2011/100*Births_w_weight_hsp_2011-Births_low_wt_hsp_2011;
	Gap_births_low_wt_asn_2011=cPct_births_low_wt_wht_2011/100*Births_w_weight_asn_2011-Births_low_wt_asn_2011;
	Gap_births_low_wt_oth_2011=cPct_births_low_wt_wht_2011/100*Births_w_weight_oth_2011-Births_low_wt_oth_2011;

	Gap_births_prenat_adeq_blk_2011=cPct_births_prenat_adeq_wht_2011/100*Births_w_prenat_blk_2011-Births_prenat_adeq_blk_2011;
	Gap_births_prenat_adeq_hsp_2011=cPct_births_prenat_adeq_wht_2011/100*Births_w_prenat_hsp_2011-Births_prenat_adeq_hsp_2011;
	Gap_births_prenat_adeq_asn_2011=cPct_births_prenat_adeq_wht_2011/100*Births_w_prenat_asn_2011-Births_prenat_adeq_asn_2011;
	Gap_births_prenat_adeq_oth_2011=cPct_births_prenat_adeq_wht_2011/100*Births_w_prenat_oth_2011-Births_prenat_adeq_oth_2011;

	Gap_births_teen_blk_2011=cPct_births_teen_wht_2011/100*Births_w_age_blk_2011-Births_teen_blk_2011;
	Gap_births_teen_hsp_2011=cPct_births_teen_wht_2011/100*Births_w_age_hsp_2011-Births_teen_hsp_2011;
	Gap_births_teen_asn_2011=cPct_births_teen_wht_2011/100*Births_w_age_asn_2011-Births_teen_asn_2011;
	Gap_births_teen_oth_2011=cPct_births_teen_wht_2011/100*Births_w_age_oth_2011-Births_teen_oth_2011;


/* 1) Suppressing gaps where estimates are suppressed: see Equity_Compile_births_for_profile.sas*/

	array birthpcts_pos {4}
		Pct_births_prenat_adeq_blk_2011 
		Pct_births_prenat_adeq_hsp_2011 
		Pct_births_prenat_adeq_asn_2011 
		Pct_births_prenat_adeq_oth_2011 
		;

	array birthgaps_pos {4}
		Gap_births_prenat_adeq_blk_2011
		Gap_births_prenat_adeq_hsp_2011
		Gap_births_prenat_adeq_asn_2011
		Gap_births_prenat_adeq_oth_2011
		;

		do a=1 to 4;
			if birthpcts_pos{a}=.s then birthgaps_pos{a}=.s;
		end;

/* 2) Suppressing gaps that meet or exceed the white citywide rate;
	  specifically, suppressing negative gaps where they should be positive*/

	array pos_gap {4} 
		Gap_births_prenat_adeq_blk_2011
		Gap_births_prenat_adeq_hsp_2011
		Gap_births_prenat_adeq_asn_2011
		Gap_births_prenat_adeq_oth_2011
		;

		do p=1 to 4; 
			if pos_gap{p} < 0 then pos_gap{p} = .a; 
	      	end;

/* 3) Prioritizing suppression by estimate over negative/positive suppression*/

	array g_gap_pos {4}
		Gap_births_prenat_adeq_blk_2011
		Gap_births_prenat_adeq_hsp_2011
		Gap_births_prenat_adeq_asn_2011
		Gap_births_prenat_adeq_oth_2011
		;

		do y=1 to 4; 
			if birthgaps_pos{y}=.s then g_gap_pos{y}= birthgaps_pos{y}; 
			else if pos_gap{y}=.a then g_gap_pos{y}=pos_gap{y};
			else g_gap_pos{y} = birthgaps_pos{y};
	      	end;



/* Repeating 1-3 to suppress positive gaps where they should be negative*/


/* 1) Suppressing gaps where estimates are suppressed: see Equity_Compile_births_for_profile.sas*/

	array birthpcts_neg {8}
		Pct_births_low_wt_blk_2011
		Pct_births_low_wt_hsp_2011 
		Pct_births_low_wt_asn_2011 
		Pct_births_low_wt_oth_2011 

		Pct_births_teen_blk_2011
		Pct_births_teen_hsp_2011 
		Pct_births_teen_asn_2011 
		Pct_births_teen_oth_2011
		;

	array birthgaps_neg {8}
		Gap_births_low_wt_blk_2011
		Gap_births_low_wt_hsp_2011
		Gap_births_low_wt_asn_2011
		Gap_births_low_wt_oth_2011

		Gap_births_teen_blk_2011
		Gap_births_teen_hsp_2011
		Gap_births_teen_asn_2011
		Gap_births_teen_oth_2011
		;

		do b=1 to 8;
			if birthpcts_neg{b}=.s then birthgaps_neg{b}=.s;
		end;


/* 2) Suppressing gaps that meet or exceed the white citywide rate;
	  specifically, suppressing negative gaps where they should be positive*/

	array neg_gap {8} 
		Gap_births_low_wt_blk_2011
		Gap_births_low_wt_hsp_2011
		Gap_births_low_wt_asn_2011
		Gap_births_low_wt_oth_2011				
		Gap_births_teen_blk_2011
		Gap_births_teen_hsp_2011
		Gap_births_teen_asn_2011
		Gap_births_teen_oth_2011
      	;	
		
		do n=1 to 8; 
			if neg_gap{n} > 0 then neg_gap{n} = .a; 
		end;

/* 3) Prioritizing suppression by estimate over negative/positive suppression*/

	array g_gap_neg {8} 
		Gap_births_low_wt_blk_2011
		Gap_births_low_wt_hsp_2011
		Gap_births_low_wt_asn_2011
		Gap_births_low_wt_oth_2011				
		Gap_births_teen_blk_2011
		Gap_births_teen_hsp_2011
		Gap_births_teen_asn_2011
		Gap_births_teen_oth_2011
      	;	
		
		do x=1 to 8; 
			if birthgaps_neg{x}=.s then g_gap_neg{x}= birthgaps_neg{x}; 
			else if neg_gap{x}=.a then g_gap_neg{x}=neg_gap{x};
			else g_gap_neg{x} = birthgaps_neg{x};
	    end;

	
	label
		Gap_births_low_wt_blk_2011 = "Difference in # of NH-Black low weight births (under 5.5 lbs) with equity, 2011 "
		Gap_births_low_wt_hsp_2011 = "Difference in # of Hispanic low weight births (under 5.5 lbs) with equity, 2011 "
		Gap_births_low_wt_asn_2011 = "Difference in # of NH-AsianPI low weight births (under 5.5 lbs) with equity, 2011 "
		Gap_births_low_wt_oth_2011 = "Difference in # of NH-Other low weight births (under 5.5 lbs) with equity, 2011 "

		Gap_births_prenat_adeq_blk_2011 = "Difference in # of births to NH-Black mothers with adequate prenatal care with equity, 2011 "
		Gap_births_prenat_adeq_hsp_2011 = "Difference in # of births to Hispanic mothers with adequate prenatal care with equity, 2011 "
		Gap_births_prenat_adeq_asn_2011 = "Difference in # of births to NH-AsianPI mothers with adequate prenatal care with equity, 2011 "
		Gap_births_prenat_adeq_oth_2011 = "Difference in # of births to NH-Other mothers with adequate prenatal care with equity, 2011 "

		Gap_births_teen_blk_2011 = "Difference in # of births to NH-Black teen mothers with equity, 2011 "
		Gap_births_teen_hsp_2011 = "Difference in # of births to Hispanic teen mothers with equity, 2011 "
		Gap_births_teen_asn_2011 = "Difference in # of births to NH-AsianPI teen mothers with equity, 2011 "
		Gap_births_teen_oth_2011 = "Difference in # of births to NH-Other teen mothers with equity, 2011 "
		;
run;

/*Rates for "Other" race category are excluded from output because of low sample size*/

proc transpose data=equity.births_gaps_allgeo out=equity.profile_tabs_births_wd12 (label="Birth Indicators Output for Equity Profile City & Ward, 2011"); 
var Births_total_2011
	Pct_births_w_race_2011 

	Pct_births_white_2011 
	Pct_births_asian_2011 
	Pct_births_black_2011
	Pct_births_hisp_2011

	Pct_births_white_3yr_2011
	Pct_births_asian_3yr_2011
	Pct_births_black_3yr_2011 
	Pct_births_hisp_3yr_2011 

	Pct_births_low_wt_2011 	
	Pct_births_low_wt_wht_2011 	
	Pct_births_low_wt_blk_2011	Gap_births_low_wt_blk_2011
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hsp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen_blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen_hsp_2011
	Pct_births_teen_asn_2011 Gap_births_teen_asn_2011
	;
id ward2012; 
run; 

proc transpose data=equity.births_gaps_allgeo out=equity.profile_tabs_births_cltr00 (label="Birth Indicators Output for Equity Profile City & Neighborhood Cluster, 2011"); 
var Births_total_2011
	Pct_births_w_race_2011 

	Pct_births_white_2011 
	Pct_births_asian_2011 
	Pct_births_black_2011
	Pct_births_hisp_2011

	Pct_births_white_3yr_2011
	Pct_births_asian_3yr_2011
	Pct_births_black_3yr_2011 
	Pct_births_hisp_3yr_2011 

	Pct_births_low_wt_2011 	
	Pct_births_low_wt_wht_2011 	
	Pct_births_low_wt_blk_2011	Gap_births_low_wt_blk_2011
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hsp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen_blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen_hsp_2011
	Pct_births_teen_asn_2011 Gap_births_teen_asn_2011
	;
id cluster_tr2000; 
run; 


proc sort data=equity.profile_tabs_births_wd12 out=profile_tabs_births_wd12_pct; 
	by _name_;
run;

proc sort data=equity.profile_tabs_births_cltr00 out=profile_tabs_births_cltr00_pct; 
	by _name_;
run;


proc export data=equity.profile_tabs_births_wd12
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_ward.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_births_cltr00
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_cluster.csv"
	dbms=csv replace;
	run;

** Register metadata **;

%Dc_update_meta_file(
      ds_lib=Equity,
      ds_name=births_gaps_allgeo,
	  creator=L Hendey and S Diby,
      creator_process=Equity_Births_profile_transpose.sas,
      restrictions=None
      )

%Dc_update_meta_file(
      ds_lib=Equity,
      ds_name=profile_tabs_births_wd12,
	  creator=L Hendey and S Diby,
      creator_process=Equity_Births_profile_transpose.sas,
      restrictions=None
      )

%Dc_update_meta_file(
      ds_lib=Equity,
      ds_name=profile_tabs_births_cltr00,
	  creator=L Hendey and S Diby,
      creator_process=Equity_Births_profile_transpose.sas,
      restrictions=None
      )
