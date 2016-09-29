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
			   Outputs transposed data in percent and decimal formats. 
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let racelist=blk asn wht hsp oth;
%let racename= NH-Black NH-AsianPI Hispanic NH-White NH-Other;

data city_births;
	set equity.equity_profile_births_city
			equity.equity_profile_birhts_wd12
			equity.equity_profile_births_cltr00;

			if city=1 then ward2012=0;
			if city=1 then cluster_tr2000=0;
			_make_profile=1;

run; 

*Add gap calculation - separate out city level white rates; 

data whiterates_births;
	set equity.equity_profile_births_city 
	(keep= _make_profile
		    Pct_births_white_2011 Pct_births_white_3yr_2011 Pct_births_low_wt_wht_2011 
			Pct_births_prenat_adeq_wht_2011 Pct_births_teen_wht_2011 )
		   ;
	_make_profile=1;
	run;

%rename(whiterates);
run;

data city_births_WR (drop=_make_profile);
	merge city_births whiterates_births (rename=(c_make_profile=_make_profile));
	by _make_profile;
	
	Gap_births_low_wt_blk_2011=cPct_births_low_wt_wht_2011/100*Births_black_2011-Births_low_wt_blk_2011;
	Gap_births_low_wt_hisp_2011=cPct_births_low_wt_wht_2011/100*Births_hisp_2011-Births_low_wt_hisp_2011;
	Gap_births_low_wt_asn_2011=cPct_births_low_wt_wht_2011/100*Births_asian_2011-Births_low_asn_2011;
	Gap_births_low_wt_oth_2011=cPct_births_low_wt_wht_2011/100*Births_oth_rac_2011-Births_low_wt_oth_2011;

	Gap_births_prenat_adeq_B_2011=cPct_births_prenat_adeq_wht_2011/100*Births_black_2011-Births_prenat_adeq_blk_2011;
	Gap_births_prenat_adeq_H_2011=cPct_births_prenat_adeq_wht_2011/100*Births_asian_2011-Births_prenat_adeq_hisp_2011;
	Gap_births_prenat_adeq_A_2011=cPct_births_prenat_adeq_wht_2011/100*Births_hisp_2011-Births_prenat_adeq_asn_2011;
	Gap_births_prenat_adeq_O_2011=cPct_births_prenat_adeq_wht_2011/100*Births_oth_rac_2011-Births_prenat_adeq_oth_2011;

	Gap_births_teen_blk_2011=cPct_births_teen_wht_2011/100*Births_black_2011-Births_teen_blk_2011;
	Gap_births_teen_hisp_2011=cPct_births_teen_wht_2011/100*Births_asian_2011-Births_teen_hisp_2011;
	Gap_births_teen_asn_2011=cPct_births_teen_wht_2011/100*Births_hisp_2011-Births_teen_asn_2011;
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
		Gap_births_low_wt_hisp_2011
		Gap_births_low_wt_asn_2011
		Gap_births_low_wt_oth_2011

		Gap_births_prenat_adeq_blk_2011
		Gap_births_prenat_adeq_hisp_2011
		Gap_births_prenat_adeq_asn_2011
		Gap_births_prenat_adeq_oth_2011

		Gap_births_teen__blk_2011
		Gap_births_teen__hisp_2011
		Gap_births_teen__asn_2011
		Gap_births_teen__oth_2011

	;

	do b=1 to 12;
		if birthpcts{12}=.s then birthgaps{12}=.s;
	end;

run;

	
proc transpose data=city_ward_births_WR out=equity.profile_tabs_births_wd12; 
var Pct_births_w_race_2011 

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
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hisp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	Pct_births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hisp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	Pct_births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen__blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen__hisp_2011
	Pct_births_teen_asn_2011 Gap_births_teen__asn_2011
	Pct_births_teen_oth_2011 Gap_births_teen__oth_2011
	;
id ward2012; 
run; 

proc transpose data=city_cluster_births_WR out=equity.profile_tabs_births_cltr00; 
var Pct_births_w_race_2011 

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
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hisp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	Pct_births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hisp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	Pct_births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen__blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen__hisp_2011
	Pct_births_teen_asn_2011 Gap_births_teen__asn_2011
	Pct_births_teen_oth_2011 Gap_births_teen__oth_2011
	;
id cluster_tr00; 
run; 

* convert to decimal;
data convert;
	set equity.profile_tabs_births_wd12; 

%decimal_convert_births;

run; 

data convert;
	set equity.profile_tabs_ACS_suppress equity.profile_tabs_births_cltr00 ; 

%decimal_convert;

run; 
proc transpose data=city_ward_births_WR out=equity.profile_tabs_births_wd12; 
var Pct_births_w_race_2011 

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
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hisp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	Pct_births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hisp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	Pct_births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen__blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen__hisp_2011
	Pct_births_teen_asn_2011 Gap_births_teen__asn_2011
	Pct_births_teen_oth_2011 Gap_births_teen__oth_2011
	;
id ward2012; 
run; 

proc transpose data=city_cluster_births_WR out=equity.profile_tabs_births_cltr00; 
var Pct_births_w_race_2011 

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
	Pct_births_low_wt_hsp_2011 	Gap_births_low_wt_hisp_2011
	Pct_births_low_wt_asn_2011 	Gap_births_low_wt_asn_2011
	Pct_births_low_wt_oth_2011 	Gap_births_low_wt_oth_2011
		
	Pct_births_prenat_adeq_2011 	
	Pct_births_prenat_adeq_wht_2011 	
	Pct_births_prenat_adeq_blk_2011 Gap_births_prenat_adeq_blk_2011
	Pct_births_prenat_adeq_hsp_2011 Gap_births_prenat_adeq_hisp_2011
	Pct_births_prenat_adeq_asn_2011 Gap_births_prenat_adeq_asn_2011
	Pct_births_prenat_adeq_oth_2011 Gap_births_prenat_adeq_oth_2011
		
	Pct_births_teen_2011 	
	Pct_births_teen_wht_2011 	
	Pct_births_teen_blk_2011 Gap_births_teen__blk_2011
	Pct_births_teen_hsp_2011 Gap_births_teen__hisp_2011
	Pct_births_teen_asn_2011 Gap_births_teen__asn_2011
	Pct_births_teen_oth_2011 Gap_births_teen__oth_2011
	;
id cluster_tr00; 
run; 

data equity.profile_tabs_ACS_dec;
	set profile_tabs_ACS_dec;

_name_=substr(_name_,2);
call execute (

run;
*add step to merge labels on from profiles_tabs_acs (by _name_); 

proc export data=equity.profile_tabs_ACS
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ACS.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_ACS_dec
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ACS_comms.csv"
	dbms=csv replace;
	run;
