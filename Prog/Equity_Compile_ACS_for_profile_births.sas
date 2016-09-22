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

%let racelist=blk asn wht hsp wht oth;
%let racename= NH-Black NH-AsianPI Hispanic NH-White NH-Other;


%let geography=city Ward2012 cluster_tr2000;
%let _years=2010_14;

/** Macro Add_Percents- Start Definition **/

%macro add_percents;

%do i = 1 %to 3; 
  %let geo=%scan(&geography., &i., " "); 


    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  data Equity_profile&geosuf._A (compress=no);  
  	merge  
          vital.Births_sum_tr10
        (keep=&geo TotPop: mTotPop: 
		   

      		vital.Births_sum_wd12
        (keep=&geo TotPop: mTotPop: 
		   )
         ;
    	 by &geo;
   
  run;

  /* i do not think we need this proc summary....
  proc summary data=Nbr_profile&geosuf._A;
    var _numeric_;
    class &geo;
    output out=Nbr_profile&geosuf._B (compress=no) mean=;

  run;*/

  data equity.Equity_profile_births&geosuf (compress=no); 
  
    set Equity_profile_births&geosuf._A;
    
    ** Total births **;
    
	%Pct_calc( var=Pct_births_w_race, label=% Births with mothers race reported, num=births_w_race, den=births_total, years=2011)
	%Pct_calc( var=Pct_births_black, label=% Births to non-Hisp. Black mothers, num=births_black, den=births_w_race, years=2011)
	%Pct_calc( var=Pct_births_asian, label=% Births to non-Hisp. Asian/PI mothers, num=births_asian, den=births_w_race, years=2011)
	%Pct_calc( var=Pct_births_hisp, label=% Births to Hispanic/Latino mothers, num=births_hisp, den=births_w_race, years=2011)
	%Pct_calc( var=Pct_births_white, label=% Births to non-Hisp. White mothers, num=births_white, den=births_w_race, years=2011)
	%Pct_calc( var=Pct_births_oth_rac, label=% Births to non-Hisp. other race mothers, num=births_oth_rac, den=births_w_race, years=2011)

    ** Total births - 3-year averages **;
    
	%Pct_calc( var=Pct_births_black_3yr, label=% Births to non-Hisp. Black mothers, 3-year avg., num=births_black_3yr, den=births_total_3yr, years=2011)
	%Pct_calc( var=Pct_births_asian_3yr, label=% Births to non-Hisp. Asian/PI mothers, 3-year avg., num=births_asian_3yr, den=births_total_3yr, years=2011)
	%Pct_calc( var=Pct_births_hisp_3yr, label=% Births to Hispanic/Latino mothers, 3-year avg., num=births_hisp_3yr, den=births_total_3yr, years=2011)
	%Pct_calc( var=Pct_births_white_3yr, label=% Births to non-Hisp. White mothers, 3-year avg., num=births_white_3yr, den=births_total_3yr, years=2011)
	%Pct_calc( var=Pct_births_oth_rac_3yr, label=% Births to non-Hisp. other race mothers, 3-year avg., num=births_oth_rac_3yr, den=births_total_3yr, years=2011)

    ** Total teen births - ages 15-19**;

	%Pct_calc( var=Pct_births_15to19, label=% Births to mothers 15-19 years old, num=births_15to19, den=Births_w_age, years=2011)

    ** Total teen births - under 20 years old**;
	%Pct_calc( var=Pct_births_teen, label=% Births to teen mothers, num=births_teen, den=Births_w_age, years=2011)

	** Total low-birth weight births**;

	%Pct_calc( var=Pct_births_low_wt, label=% low weight births (under 5.5 lbs), num=Births_low_wt, den=Births_w_weight, years=2011 )

    ** Total births with adequate prenatal care**;
	%Pct_calc( var=Pct_births_prenat_adeq, label=% Births to mothers with adequate prenatal care, num=births_prenat_adeq, den=births_w_prenat, years=2011)


	%do r=1 %to 5;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");
	 
     ** Teen births - ages 15-19, by race**;

	%Pct_calc( var=Pct_births_15to19_&race., label=% Births to &name. mothers 15-19 years old, num=births_15to19_&race., den=Births_w_age_&race., years=2011)

    ** Teen births - under 20 years old, by race**;
	%Pct_calc( var=Pct_births_teen_&race., label=% Births to &name. teen mothers, num=births_teen_&race., den=Births_w_age_&race., years=2011)

	** Low-birth weight births, by race**;

	%Pct_calc( var=Pct_births_low_wt_&race., label=% &name. low weight births (under 5.5 lbs), num=Births_low_wt_&race., den=Births_w_weight_&race., years=2011 )

    ** Births with adequate prenatal care, by race**;
	%Pct_calc( var=Pct_births_prenat_adeq_&race., label=% Births to &name. mothers with adequate prenatal care, num=births_prenat_adeq_&race., den=births_w_prenat_&race., years=2011)

	%end;


    ** Create flag for generating profile **;
    
    if TotPop_2010_14 >= 100 then _make_profile = 1;
    else _make_profile = 0;
    
 
  run;
    
  %File_info( data=Equity.Equity_profile&geosuf, printobs=0, contents=n )
  
%end; 
  
%mend add_percents;

/** End Macro Definition **/

%add_percents; 

run; 
