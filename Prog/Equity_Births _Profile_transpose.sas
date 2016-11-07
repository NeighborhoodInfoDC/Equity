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
			   Outputs transposed data in percent and decimal formats. 
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

data equity.city_births_gaps (drop=_make_profile b);
	merge city_births whiterates_births_new(rename=(c_make_profile=_make_profile));
	by _make_profile;
	
	Gap_births_low_wt_blk_2011=cPct_births_low_wt_wht_2011/100*Births_black_2011-Births_low_wt_blk_2011;
	Gap_births_low_wt_hsp_2011=cPct_births_low_wt_wht_2011/100*Births_hisp_2011-Births_low_wt_hsp_2011;
	Gap_births_low_wt_asn_2011=cPct_births_low_wt_wht_2011/100*Births_asian_2011-Births_low_wt_asn_2011;
	Gap_births_low_wt_oth_2011=cPct_births_low_wt_wht_2011/100*Births_oth_rac_2011-Births_low_wt_oth_2011;

	Gap_births_prenat_adeq_blk_2011=cPct_births_prenat_adeq_wht_2011/100*Births_black_2011-Births_prenat_adeq_blk_2011;
	Gap_births_prenat_adeq_hsp_2011=cPct_births_prenat_adeq_wht_2011/100*Births_hisp_2011-Births_prenat_adeq_hsp_2011;
	Gap_births_prenat_adeq_asn_2011=cPct_births_prenat_adeq_wht_2011/100*Births_asian_2011-Births_prenat_adeq_asn_2011;
	Gap_births_prenat_adeq_oth_2011=cPct_births_prenat_adeq_wht_2011/100*Births_oth_rac_2011-Births_prenat_adeq_oth_2011;

	Gap_births_teen_blk_2011=cPct_births_teen_wht_2011/100*Births_black_2011-Births_teen_blk_2011;
	Gap_births_teen_hsp_2011=cPct_births_teen_wht_2011/100*Births_hisp_2011-Births_teen_hsp_2011;
	Gap_births_teen_asn_2011=cPct_births_teen_wht_2011/100*Births_asian_2011-Births_teen_asn_2011;
	Gap_births_teen_oth_2011=cPct_births_teen_wht_2011/100*Births_oth_rac_2011-Births_teen_oth_2011;

	array birthpcts {12}
		Pct_births_low_wt_blk_2011
		Pct_births_low_wt_hsp_2011 
		Pct_births_low_wt_asn_2011 
		Pct_births_low_wt_oth_2011 

		Pct_births_prenat_adeq_blk_2011 
		Pct_births_prenat_adeq_hsp_2011 
		Pct_births_prenat_adeq_asn_2011 
		Pct_births_prenat_adeq_oth_2011 

		Pct_births_teen_blk_2011
		Pct_births_teen_hsp_2011 
		Pct_births_teen_asn_2011 
		Pct_births_teen_oth_2011
		;

	array birthgaps {12}
		Gap_births_low_wt_blk_2011
		Gap_births_low_wt_hsp_2011
		Gap_births_low_wt_asn_2011
		Gap_births_low_wt_oth_2011

		Gap_births_prenat_adeq_blk_2011
		Gap_births_prenat_adeq_hsp_2011
		Gap_births_prenat_adeq_asn_2011
		Gap_births_prenat_adeq_oth_2011

		Gap_births_teen_blk_2011
		Gap_births_teen_hsp_2011
		Gap_births_teen_asn_2011
		Gap_births_teen_oth_2011
		;

	do b=1 to 12;
		if birthpcts{b}=.s then birthgaps{b}=.s;
	end;

run;

proc transpose data=equity.city_births_gaps out=equity.profile_tabs_births_wd12; 
var Births_total_2011
	Pct_births_w_race_2011 

	Pct_births_white_2011 
	Pct_births_asian_2011 
	Pct_births_black_2011
	Pct_births_hisp_2011
	Pct_births_oth_rac_2011 

	Pct_births_white_3yr_2011
	Pct_births_asian_3yr_2011
	Pct_births_black_3yr_2011 
	Pct_births_hisp_3yr_2011 
	Pct_births_oth_rac_3yr_2011

	Pct_births_low_wt_2011 	
	Pct_births_low_wt_wht_2011 	
	Pct_births_low_wt_blk_2011	Gap_births_low_wt_blk_2011
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hsp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	Pct_births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	Pct_births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen_blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen_hsp_2011
	Pct_births_teen_asn_2011 Gap_births_teen_asn_2011
	Pct_births_teen_oth_2011 Gap_births_teen_oth_2011
	;
id ward2012; 
run; 

proc transpose data=equity.city_births_gaps out=equity.profile_tabs_births_cltr00; 
var Births_total_2011
	Pct_births_w_race_2011 

	Pct_births_white_2011 
	Pct_births_asian_2011 
	Pct_births_black_2011
	Pct_births_hisp_2011
	Pct_births_oth_rac_2011 

	Pct_births_white_3yr_2011
	Pct_births_asian_3yr_2011
	Pct_births_black_3yr_2011 
	Pct_births_hisp_3yr_2011 
	Pct_births_oth_rac_3yr_2011

	Pct_births_low_wt_2011 	
	Pct_births_low_wt_wht_2011 	
	Pct_births_low_wt_blk_2011	Gap_births_low_wt_blk_2011
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hsp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	Pct_births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hsp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	Pct_births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen_blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen_hsp_2011
	Pct_births_teen_asn_2011 Gap_births_teen_asn_2011
	Pct_births_teen_oth_2011 Gap_births_teen_oth_2011
	;
id cluster_tr2000; 
run; 

* convert to decimal;
data convert_births_wd12 
		(drop=births_w_race: births_black: births_asian: births_hisp: births_white: births_oth_rac:
			Births_w_age: births_teen: Births_low_wt: Births_w_weight:
			births_prenat_adeq: births_w_prenat:);
	set equity.city_births_gaps; 

%decimal_convert_births;

run; 

data convert_births_cltr00
	(drop=births_w_race: births_black: births_asian: births_hisp: births_white: births_oth_rac:
			Births_w_age: births_teen: Births_low_wt: Births_w_weight:
			births_prenat_adeq: births_w_prenat:);
	set equity.city_births_gaps; 

%decimal_convert_births;

run; 
proc transpose data=convert_births_wd12 out=profile_tabs_births_wd12_dec_1; 
var nBirths_total_2011
	nPct_births_w_race_2011 

	nPct_births_white_2011 
	nPct_births_asian_2011 
	nPct_births_black_2011
	nPct_births_hisp_2011
	nPct_births_oth_rac_2011 

	nPct_births_white_3yr_2011
	nPct_births_asian_3yr_2011
	nPct_births_black_3yr_2011 
	nPct_births_hisp_3yr_2011 
	nPct_births_oth_rac_3yr_2011

	nPct_births_low_wt_2011 	
	nPct_births_low_wt_wht_2011 	
	nPct_births_low_wt_blk_2011	nGap_births_low_wt_blk_2011
	nPct_births_low_wt_hsp_2011 nGap_births_low_wt_hsp_2011
	nPct_births_low_wt_asn_2011 nGap_births_low_wt_asn_2011
	nPct_births_low_wt_oth_2011 nGap_births_low_wt_oth_2011
		
	nPct_births_prenat_adeq_2011 	
	nPct_births_prenat_adeq_wht_2011 	
	nPct_births_prenat_adeq_blk_2011 nGap_births_prenat_adeq_blk_2011
	nPct_births_prenat_adeq_hsp_2011 nGap_births_prenat_adeq_hsp_2011
	nPct_births_prenat_adeq_asn_2011 nGap_births_prenat_adeq_asn_2011
	nPct_births_prenat_adeq_oth_2011 nGap_births_prenat_adeq_oth_2011
		
	nPct_births_teen_2011 	
	nPct_births_teen_wht_2011 	
	nPct_births_teen_blk_2011 nGap_births_teen_blk_2011
	nPct_births_teen_hsp_2011 nGap_births_teen_hsp_2011
	nPct_births_teen_asn_2011 nGap_births_teen_asn_2011
	nPct_births_teen_oth_2011 nGap_births_teen_oth_2011
	;
id ward2012; 
run; 

proc transpose data=convert_births_cltr00 out=profile_tabs_births_cltr00_dec_1; 
var Births_total_2011
	nPct_births_w_race_2011 

	nPct_births_white_2011 
	nPct_births_asian_2011 
	nPct_births_black_2011
	nPct_births_hisp_2011
	nPct_births_oth_rac_2011 

	nPct_births_white_3yr_2011
	nPct_births_asian_3yr_2011
	nPct_births_black_3yr_2011 
	nPct_births_hisp_3yr_2011 
	nPct_births_oth_rac_3yr_2011

	nPct_births_low_wt_2011 	
	nPct_births_low_wt_wht_2011 	
	nPct_births_low_wt_blk_2011		nGap_births_low_wt_blk_2011
	nPct_births_low_wt_hsp_2011 	nGap_births_low_wt_hsp_2011
	nPct_births_low_wt_asn_2011 	nGap_births_low_wt_asn_2011
	nPct_births_low_wt_oth_2011 	nGap_births_low_wt_oth_2011
		
	nPct_births_prenat_adeq_2011 	
	nPct_births_prenat_adeq_wht_2011 	
	nPct_births_prenat_adeq_blk_2011 nGap_births_prenat_adeq_blk_2011
	nPct_births_prenat_adeq_hsp_2011 nGap_births_prenat_adeq_hsp_2011
	nPct_births_prenat_adeq_asn_2011 nGap_births_prenat_adeq_asn_2011
	nPct_births_prenat_adeq_oth_2011 nGap_births_prenat_adeq_oth_2011
		
	nPct_births_teen_2011 	
	nPct_births_teen_wht_2011 	
	nPct_births_teen_blk_2011 nGap_births_teen_blk_2011
	nPct_births_teen_hsp_2011 nGap_births_teen_hsp_2011
	nPct_births_teen_asn_2011 nGap_births_teen_asn_2011
	nPct_births_teen_oth_2011 nGap_births_teen_oth_2011
	;
id cluster_tr2000; 
run; 

*import labels from profile_tabs_births_wd12 into decimal convert dataset;

*first, drop the "n" from the var names in profile_tabs_births_wd12_dec_1;

data profile_tabs_births_wd12_dec_2;
	set profile_tabs_births_wd12_dec_1;
	_name_=substr(_name_,2);
	id=_n_;
run;

data profile_tabs_births_cltr00_dec_2;
	set profile_tabs_births_cltr00_dec_1;
	_name_=substr(_name_,2);
	id=_n_;
run;

*then, sort data by _name_ field and merge;

proc sort data=profile_tabs_births_wd12_dec_2;
	by _name_;
run;

proc sort data=profile_tabs_births_cltr00_dec_2;
	by _name_;
run;

proc sort data=equity.profile_tabs_births_wd12 out=profile_tabs_births_wd12_pct; 
	by _name_;
run;

proc sort data=equity.profile_tabs_births_cltr00 out=profile_tabs_births_cltr00_pct; 
	by _name_;
run;

data tabs_births_wd12_dec_notsort;
	merge profile_tabs_births_wd12_pct (keep=_name_ _label_)
		  profile_tabs_births_wd12_dec_2;
	by _name_;	
run;


data tabs_births_cltr00_dec_notsort;
	merge profile_tabs_births_cltr00_pct (keep=_name_ _label_)
		  profile_tabs_births_cltr00_dec_2;
	by _name_;	
run;

proc sort data=tabs_births_wd12_dec_notsort 
		  out=equity.profile_tabs_births_wd12_dec; 
	by id;
run;

proc sort data=tabs_births_cltr00_dec_notsort 
		  out=equity.profile_tabs_births_cltr00_dec; 
	by id;
run;

proc export data=equity.profile_tabs_births_wd12
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_ward.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_births_cltr00
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_cluster.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_births_wd12_dec
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_ward_dec.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_births_cltr00_dec
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_births_cluster_dec.csv"
	dbms=csv replace;
	run;