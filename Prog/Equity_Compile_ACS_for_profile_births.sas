/**************************************************************************
 Program:  Compile_ACS_for_profile_births.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey & S. Diby
 Created:  07/31/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Calculates statistics for birth variables by geography to feed into Equity Profiles. 
 **************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Vital )
%DCData_lib( Equity )


%let racelist=blk asn wht hsp wht oth;
%let racename= NH-Black NH-AsianPI Hispanic NH-White NH-Other;
%let births_start_yr=2011;
%let births_end_yr=2011;


%let geography=city Ward2012 cluster_tr2000;
%let _years=2010_14;

/** Macro Add_Percents- Start Definition **/

%macro add_percents;

%do i = 1 %to 3; 
  %let geo=%scan(&geography., &i., " "); 


    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  data Equity_profile_births&geosuf._C (compress=no);    
     set Vital.Births_sum&geosuf
        (keep=&geo births_total: 
				births_w_race: births_black: births_asian: births_hisp: births_white: births_oth_rac:
				Births_w_age: births_15to19: births_teen: Births_low_wt: Births_w_weight:
				births_prenat_adeq: births_w_prenat: )
         ;
    	 by &geo;
   
  run;

  data Equity_profile_births&geosuf._B (compress=no); 
  
    set Equity_profile_births&geosuf._C;
    
    ** Total births **;
    
	%Pct_calc( var=Pct_births_w_race, label=% Births with mothers race reported, num=births_w_race, den=births_total, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_black, label=% Births to non-Hisp. Black mothers, num=births_black, den=births_w_race, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_asian, label=% Births to non-Hisp. Asian/PI mothers, num=births_asian, den=births_w_race, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_hisp, label=% Births to Hispanic/Latino mothers, num=births_hisp, den=births_w_race, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_white, label=% Births to non-Hisp. White mothers, num=births_white, den=births_w_race, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_oth_rac, label=% Births to non-Hisp. other race mothers, num=births_oth_rac, den=births_w_race, from=&births_start_yr, to=&births_end_yr )

    ** Total births - 3-year averages **;
    
	%Pct_calc( var=Pct_births_black_3yr, label=% Births to non-Hisp. Black mothers 3-year avg., num=births_black_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_asian_3yr, label=% Births to non-Hisp. Asian/PI mothers 3-year avg., num=births_asian_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_hisp_3yr, label=% Births to Hispanic/Latino mothers 3-year avg., num=births_hisp_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_white_3yr, label=% Births to non-Hisp. White mothers 3-year avg., num=births_white_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr )
	%Pct_calc( var=Pct_births_oth_rac_3yr, label=% Births to non-Hisp. other race mothers 3-year avg., num=births_oth_rac_3yr, den=births_total_3yr, from=&births_start_yr, to=&births_end_yr )

    %Pct_calc( var=Pct_births_low_wt, label=% low weight births (under 5.5 lbs), num=Births_low_wt, den=Births_w_weight, from=&births_start_yr, to=&births_end_yr )
    %Pct_calc( var=Pct_births_teen, label=% births to teen mothers, num=Births_teen, den=Births_w_age, from=&births_start_yr, to=&births_end_yr )

	%Pct_calc( var=Pct_births_prenat_adeq, label=% Births to mothers with adequate prenatal care, num=births_prenat_adeq, den=births_w_prenat, from=&births_start_yr, to=&births_end_yr )


		if births_total_2011 <=5 then Pct_births_w_race=.s; 
		if births_w_race_2011 <=5 then do; Pct_births_black_2011=.s; Pct_births_asian_2011=.s; Pct_births_hisp_2011=.s; Pct_births_white_2011=.s; Pct_births_oth_rac_2011=.s; end; 
		if births_black_3yr_2011 <= 5 then Pct_births_black_3yr_2011=.s;
		if births_asian_3yr_2011 <=5 then Pct_births_asian_3yr_2011=.s;
		if births_hisp_3yr_2011 <=5 then  Pct_births_hisp_3yr_2011=.s;
		if births_white_3yr_2011 <=5 then Pct_births_white_3yr_2011=.s;
		if births_oth_rac_3yr_2011 <=5 then Pct_births_oth_rac_3yr_2011=.s;

	 	if Births_w_weight_2011 <=5 then Pct_births_low_wt_2011 =.s;
		if births_w_prenat_2011 <=5 then Pct_births_prenat_adeq_2011=.s;
		if Births_w_age_2011 <=5 then Pct_births_teen_2011 =.s;


	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");
		 
	 
	    ** Teen births - under 20 years old, by race**;
		%Pct_calc( var=Pct_births_teen_&race., label=% Births to &name. teen mothers, num=births_teen_&race., den=Births_w_age_&race., from=&births_start_yr, to=&births_end_yr )

		** Low-birth weight births, by race**;

		%Pct_calc( var=Pct_births_low_wt_&race., label=% &name. low weight births (under 5.5 lbs), num=Births_low_wt_&race., den=Births_w_weight_&race., from=&births_start_yr, to=&births_end_yr  )

	    ** Births with adequate prenatal care, by race**;
		%Pct_calc( var=Pct_births_prenat_adeq_&race., label=% Births to &name. mothers with adequate prenatal care, num=births_prenat_adeq_&race., den=births_w_prenat_&race., from=&births_start_yr, to=&births_end_yr )
		
		if Births_w_age_&race._2011 <= 5 then Pct_births_teen_&race._2011=.s;
		if Births_low_wt_&race._2011 <= 5 then Pct_births_low_wt_&race._2011=.s;
		if births_prenat_adeq_&race._2011 <=5 then Pct_births_prenat_adeq_&race._2011=.s;
			

	%end;

 
  run;
    
data equity.Equity_profile_births&geosuf.;
set Equity_profile_births&geosuf._B; 
keep &geo Births_asian_2011 Births_asian_3yr_2011 Births_black_2011 Births_black_3yr_2011 Births_hisp_2011 Births_hisp_3yr_2011 Births_low_wt_2011
Births_low_wt_asn_2011 Births_low_wt_blk_2011 Births_low_wt_hsp_2011 Births_low_wt_oth_2011 Births_low_wt_wht_2011 Births_oth_rac_2011
Births_oth_rac_3yr_2011 Births_prenat_adeq_2011 Births_prenat_adeq_asn_2011 Births_prenat_adeq_blk_2011 Births_prenat_adeq_hsp_2011
Births_prenat_adeq_oth_2011 Births_prenat_adeq_wht_2011 Births_total_2011 Births_total_3yr_2011 Births_w_age_2011 Births_w_age_asn_2011
Births_w_age_blk_2011 Births_w_age_hsp_2011 Births_w_age_oth_2011 Births_w_age_wht_2011 Births_w_agerace_2011 Births_w_prenat_2011
Births_w_prenat_asn_2011 Births_w_prenat_blk_2011 Births_w_prenat_hsp_2011 Births_w_prenat_oth_2011 Births_w_prenat_wht_2011 Births_w_race_2011
Births_w_weight_2011 Births_w_weight_asn_2011 Births_w_weight_blk_2011 Births_w_weight_hsp_2011 Births_w_weight_oth_2011 Births_w_weight_wht_2011
Births_white_2011 Births_white_3yr_2011 Pct_births_asian_2011 Pct_births_asian_3yr_2011 Pct_births_black_2011
Pct_births_black_3yr_2011 Pct_births_hisp_2011 Pct_births_hisp_3yr_2011 Pct_births_low_wt_2011 Pct_births_low_wt_asn_2011 Pct_births_low_wt_blk_2011
Pct_births_low_wt_hsp_2011 Pct_births_low_wt_oth_2011 Pct_births_low_wt_wht_2011 Pct_births_oth_rac_2011 Pct_births_oth_rac_3yr_2011
Pct_births_prenat_adeq_2011 Pct_births_prenat_adeq_asn_2011 Pct_births_prenat_adeq_blk_2011 Pct_births_prenat_adeq_hsp_2011
Pct_births_prenat_adeq_oth_2011 Pct_births_prenat_adeq_wht_2011 Pct_births_teen_2011 Pct_births_teen_asn_2011 Pct_births_teen_blk_2011
Pct_births_teen_hsp_2011 Pct_births_teen_oth_2011 Pct_births_teen_wht_2011 Pct_births_w_race_2011 Pct_births_white_2011 Pct_births_white_3yr_2011
Births_teen_wht_2011 Births_teen_oth_2011 Births_teen_blk_2011 Births_teen_hsp_2011 Births_teen_asn_2011 Births_teen_2011;
 
 run;

 %File_info( data=Equity.Equity_profile_births&geosuf, printobs=0, contents=n )
 
 %end;

%mend add_percents;

/** End Macro Definition **/

%add_percents; 



