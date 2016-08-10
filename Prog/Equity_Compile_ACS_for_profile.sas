/**************************************************************************
 Program:  Compile_ACS_for_profile.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey & S. Diby
 Created:  07/31/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Creates calculated statistics for ACS by geography to feed into Equity Profiles. 

 Modifications: 8/8/16 - SD wrote formulas for Equity indicators
 **************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let geography=city Ward2012 cluster_tr2000;

/** Macro Add_Percents- Start Definition **/

%macro add_percents;

%do i = 1 %to 3; 
  %let geo=%scan(&geography., &i., " "); 
  
    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  data Equity_profile&geosuf._A (compress=no);  
  merge  
          ACS.acs_2010_14_dc_sum_bg_&geosuf
        (keep=&geo TotPop: mTotPop: PopUnder18Years: mPopUnder18Years: Pop65andOverYears: mPop65andOverYears:
		   PopWithRace: mPopWithRace:
		   PopBlackNonHispBridge: mPopBlackNonHispBridge:
           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
		   PopHisp: mPopHisp:
		   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
		   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
		   PopAloneB: mPopAloneB:
		   PopAloneW: mPopAloneW:
		   PopAloneH: mPopAloneH:
		   PopAloneA: mPopAloneA:
		   PopAloneI: mPopAloneI:
		   PopAloneO: mPopAloneO:
		   PopAloneM: mPopAloneM:
		   PopAloneIOM: mPopAloneIOM:
		   PopAloneAIOM: mPopAloneAIOM:
           Pop25andOverYears: mPop25andOverYears: 
           NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
           Pop25andOverWoutHS: mPop25andOverWoutHS: 
           NumHshldPhone: mNumHshldPhone: 
           NumHshldCar: mNumHshldCar: 
           NumFamilies_: mNumFamilies_:
           AggFamilyIncome: mAggFamilyIncome: 
           NumRenterHsgUnits: mNumRenterHsgUnits:
           NumVacantHsgUnitsForRent: mNumVacantHUForRent: 
           NumOwnerOccupiedHsgUnits: mNumOwnerOccupiedHU: )
      ACS.Acs_2010_14_dc_sum_tr&geosuf
        (keep=&geo TotPop: mTotPop: 
           PopForeignBorn: mPopForeignBorn: 
           PersonsPovertyDefined: mPersonsPovertyDefined:
           PopPoorPersons: mPopPoorPersons: 
           PopInCivLaborForce: mPopInCivLaborForce: 
           PopUnemployed: mPopUnemployed:
           Pop16andOverYears: mPop16andOverYears: 
           Pop16andOverEmployed: mPop16andOverEmployed: 
           NumFamiliesOwnChildren: mNumFamiliesOwnChildren:
           NumFamiliesOwnChildrenFH: mNumFamiliesOwnChildFH: 
           ChildrenPovertyDefined: mChildrenPovertyDefined: 
           PopPoorChildren: mPopPoorChildren: 
		   PopPoorElderly: mPopPoorElderly:
		   ElderlyPovertyDefined: mElderlyPovertyDefined: 
         rename=(TotPop_2010_14=TotPop_tr_2010_14 mTotPop_2010_14=mTotPop_tr_2010_14))
         
         ;
    by &geo;
    
  run;
  /* i do not think we need this proc summary....
  proc summary data=Nbr_profile&geosuf._A;
    var _numeric_;
    class &geo;
    output out=Nbr_profile&geosuf._B (compress=no) mean=;

  run;*/
  data equity.Equity_profile&geosuf (compress=no); /*NEED TO REMOVE 1990, 2000, 2010 from formulas*/
  
    set Nbr_profile&geosuf._A;
    
    /* Population 
    
    %Label_var_years( var=TotPop, label=Population, years= 2010_14 )
    
    %Pct_calc( var=PctPopUnder18Years, label=% children, num=PopUnder18Years, den=TotPop, years= 2010_14 )
    
    %Moe_prop_a( var=PctPopUnder18Years_m_2010_14, mult=100, num=PopUnder18Years_2010_14, den=TotPop_2010_14, 
                       num_moe=mPopUnder18Years_2010_14, den_moe=mTotPop_2010_14 );
    
	%Pct_calc( var=PctPop65andOverYears, label=% seniors, num=Pop65andOverYears, den=TotPop, years= 2010_14 )

    %Moe_prop_a( var=PctPop65andOverYears_m_2010_14, mult=100, num=Pop65andOverYears_2010_14, den=TotPop_2010_14, 
                       num_moe=mPop65andOverYears_2010_14, den_moe=mTotPop_2010_14 );
    
    %Pct_calc( var=PctForeignBorn, label=% foreign born, num=PopForeignBorn, den=TotPop_tr, years=2010_14 )

    %Moe_prop_a( var=PctForeignBorn_m_2010_14, mult=100, num=PopForeignBorn_2010_14, den=TotPop_tr_2010_14, 
                       num_moe=mPopForeignBorn_2010_14, den_moe=mTotPop_tr_2010_14 );

    %Pct_calc( var=PctSameHouse5YearsAgo, label=% same house 5 years ago, num=PopSameHouse5YearsAgo, den=Pop5andOverYears, years=1990 2000 )
    
    ** Population by Race/Ethnicity **;
    
    %Pct_calc( var=PctBlackNonHispBridge, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=1990 2000 2010_14 2010 )
    %Pct_calc( var=PctWhiteNonHispBridge, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=1990 2000 2010_14 2010 )
    %Pct_calc( var=PctHisp, label=% Hispanic, num=PopHisp, den=PopWithRace, years=1990 2000 2010_14 2010 )
    %Pct_calc( var=PctAsianPINonHispBridge, label=% Asian/P.I. non-Hispanic, num=PopAsianPINonHispBridge, den=PopWithRace, years=1990 2000 2010_14 2010 )
    
    %Pct_calc( var=PctOtherRaceNonHispBridge, label=% other race non-Hispanic, num=PopOtherRaceNonHispBridge, den=PopWithRace, years=1990 2000 2010 )
    %Pct_calc( var=PctOtherRaceNonHispBridg, label=% other race non-Hispanic, num=PopOtherRaceNonHispBridg, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=PctBlackNonHispBridge_m_2010_14, mult=100, num=PopBlackNonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopBlackNonHispBridge_2010_14, den_moe=mPopWithRace2010_14 );

    %Moe_prop_a( var=PctWhiteNonHispBridge_m_2010_14, mult=100, num=PopWhiteNonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopWhiteNonHispBridge_2010_14, den_moe=mPopWithRace2010_14 );

    %Moe_prop_a( var=PctHisp_m_2010_14, mult=100, num=PopHisp_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopHisp_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAsianPINonHispBridge_m_2010_14, mult=100, num=PopAsianPINonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAsianPINonHispBridge_2010_14, den_moe=mPopWithRace2010_14 );

    %Moe_prop_a( var=PctOtherRaceNonHispBridg_m_2010_14, mult=100, num=PopOtherRaceNonHispBridg_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopOtherRaceNonHispBridg_2010_14, den_moe=mPopWithRace2010_14 );*/

	** Population by race/ethnicity alone**;

    %Pct_calc( var=PctAloneB, label=% black alone non-Hispanic, num=PopAloneB, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneW, label=% white alone non-Hispanic, num=PopAloneW, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneH, label=% Hispanic alone non-Hispanic, num=PopAloneH, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneA, label=% Asian/P.I. alone non-Hispanic, num=PopAloneA, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneI, label=% Indigenous alone non-Hispanic, num=PopAloneI, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneO, label=% Other race alone non-Hispanic, num=PopAloneO, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneM, label=% Multiracial alone non-Hispanic, num=PopAloneM, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneIOM, label=% Indigienous-other-multi-alone non-Hispanic, num=PopAloneIOM, den=PopWithRace, years=1990 2000 2010_14 2010 )
	%Pct_calc( var=PctAloneAIOM, label=% All other than Black-White-Hispanic alone non-Hispanic, num=PopAloneAIOM, den=PopWithRace, years=1990 2000 2010_14 2010 )


	%Moe_prop_a( var=PctAloneB_m_2010_14, mult=100, num=PopAloneB_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneB_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneW_m_2010_14, mult=100, num=PopAloneW_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneW_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneH_m_2010_14, mult=100, num=PopAloneH_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneH_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneA_m_2010_14, mult=100, num=PopAloneA_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneA_2010_14, den_moe=mPopWithRace2010_14 );
					   
	%Moe_prop_a( var=PctAloneI_m_2010_14, mult=100, num=PopAloneI_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneI_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneO_m_2010_14, mult=100, num=PopAloneO_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneO_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneM_m_2010_14, mult=100, num=PopAloneM_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneM_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneIOM_m_2010_14, mult=100, num=PopAloneIOM_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneIOM_2010_14, den_moe=mPopWithRace2010_14 );

	%Moe_prop_a( var=PctAloneAIOM_m_2010_14, mult=100, num=PopAloneAIOM_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneAIOM_2010_14, den_moe=mPopWithRace2010_14 );


	/* Family Risk Factors **;

    %Pct_calc( var=PctPoorPersons, label=Poverty rate (%), num=PopPoorPersons, den=PersonsPovertyDefined, years=1980 1990 2000 2010_14 )
    %Pct_calc( var=PctUnemployed, label=Unemployment rate (%), num=PopUnemployed, den=PopInCivLaborForce, years=1980 1990 2000 2010_14 )
    %Pct_calc( var=Pct16andOverEmployed, label=% pop. 16+ yrs. employed, num=Pop16andOverEmployed, den=Pop16andOverYears, years=1980 1990 2000 2010_14 )
    %Pct_calc( var=Pct25andOverWoutHS, label=% persons without HS diploma, num=Pop25andOverWoutHS, den=Pop25andOverYears, years=1980 1990 2000 2010_14 )
    %Pct_calc( var=PctFamiliesOwnChildrenFH, label=% female-headed families with children, num=NumFamiliesOwnChildrenFH, den=NumFamiliesOwnChildren, years=1990 2000 2010_14 )
    
    %Moe_prop_a( var=PctPoorPersons_m_2010_14, mult=100, num=PopPoorPersons_2010_14, den=PersonsPovertyDefined_2010_14, 
                       num_moe=mPopPoorPersons_2010_14, den_moe=mPersonsPovertyDefined_2010_14 );
    
    %Moe_prop_a( var=PctUnemployed_m_2010_14, mult=100, num=PopUnemployed_2010_14, den=PopInCivLaborForce_2010_14, 
                       num_moe=mPopUnemployed_2010_14, den_moe=mPopInCivLaborForce_2010_14 );
    
    %Moe_prop_a( var=Pct16andOverEmployed_m_2010_14, mult=100, num=Pop16andOverEmployed_2010_14, den=Pop16andOverYears_2010_14, 
                       num_moe=mPop16andOverEmployed_2010_14, den_moe=mPop16andOverYears_2010_14 );
    
    %Moe_prop_a( var=Pct25andOverWoutHS_m_2010_14, mult=100, num=Pop25andOverWoutHS_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWoutHS_2010_14, den_moe=mPop25andOverYears_2010_14 );
    
    %Moe_prop_a( var=PctFamiliesOwnChildFH_m_2010_14, mult=100, num=NumFamiliesOwnChildrenFH_2010_14, den=NumFamiliesOwnChildren_2010_14, 
                       num_moe=mNumFamiliesOwnChildFH_2010_14, den_moe=mNumFamiliesOwnChildren_2010_14 );
    
    ** Isolation Indicators **;
    
    %Pct_calc( var=PctHshldPhone, label=% HHs with a phone, num=NumHshldPhone, den=NumOccupiedHsgUnits, years=2000 2010_14 )
    %Pct_calc( var=PctHshldCar, label=% HHs with a car, num=NumHshldCar, den=NumOccupiedHsgUnits, years=2000 2010_14 )
    
    %Moe_prop_a( var=PctHshldPhone_m_2010_14, mult=100, num=NumHshldPhone_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumHshldPhone_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );
    
    %Moe_prop_a( var=PctHshldCar_m_2010_14, mult=100, num=NumHshldCar_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumHshldCar_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );
    
   ** Child Well-Being Indicators **;
    
    %Pct_calc( var=PctPoorChildren, label=% children in poverty, num=PopPoorChildren, den=ChildrenPovertyDefined, years=1990 2000 2010_14 )
    
    %Moe_prop_a( var=PctPoorChildren_m_2010_14, mult=100, num=PopPoorChildren_2010_14, den=ChildrenPovertyDefined_2010_14, 
                       num_moe=mPopPoorChildren_2010_14, den_moe=mChildrenPovertyDefined_2010_14 );
    
    %Pct_calc( var=Pct_births_low_wt, label=% low weight births (under 5.5 lbs), num=Births_low_wt, den=Births_w_weight, from=&births_start_yr, to=&births_end_yr )
    %Pct_calc( var=Pct_births_teen, label=% births to teen mothers, num=Births_teen, den=Births_w_age, from=&births_start_yr, to=&births_end_yr )
    
	 ** Elderly Well-Being Indicators **;
    
    %Pct_calc( var=PctPoorElderly, label=% seniors in poverty, num=PopPoorElderly, den=ElderlyPovertyDefined, years=1990 2000 2010_14 )
    
    %Moe_prop_a( var=PctPoorElderly_m_2010_14, mult=100, num=PopPoorElderly_2010_14, den=ElderlyPovertyDefined_2010_14, 
                       num_moe=mPopPoorElderly_2010_14, den_moe=mElderlyPovertyDefined_2010_14 );

    ** Income Conditions **;
    
    %Pct_calc( var=AvgFamilyIncome, label=Average family income last year ($), num=AggFamilyIncome, den=NumFamilies, mult=1, years=1980 1990 2000 2010_14 )
    
    %dollar_convert( AvgFamilyIncome_1980, AvgFamilyIncAdj_1980, 1979, &inc_dollar_yr )
    %dollar_convert( AvgFamilyIncome_1990, AvgFamilyIncAdj_1990, 1989, &inc_dollar_yr )
    %dollar_convert( AvgFamilyIncome_2000, AvgFamilyIncAdj_2000, 1999, &inc_dollar_yr )
    %dollar_convert( AvgFamilyIncome_2010_14, AvgFamilyIncAdj_2010_14, 2012, &inc_dollar_yr )
    
    label
      AvgFamilyIncAdj_1980 = "Avg. family income, 1979"
      AvgFamilyIncAdj_1990 = "Avg. family income, 1989"
      AvgFamilyIncAdj_2000 = "Avg. family income, 1999"
      AvgFamilyIncAdj_2010_14 = "Avg. family income, 2010-14"
      ;
      
    AvgFamilyIncome_m_2010_14 = 
      %Moe_ratio( num=AggFamilyIncome_2010_14, den=NumFamilies_2010_14, 
                  num_moe=mAggFamilyIncome_2010_14, den_moe=mNumFamilies_2010_14 );
                        
    %dollar_convert( AvgFamilyIncome_m_2010_14, AvgFamilyIncAdj_m_2010_14, 2012, &inc_dollar_yr )
    
    if AvgFamilyIncAdj_1980 > 0 then PctChgAvgFamilyIncAdj_1980_1990 = %pctchg( AvgFamilyIncAdj_1980, AvgFamilyIncAdj_1990 );
    if AvgFamilyIncAdj_1990 > 0 then PctChgAvgFamilyIncAdj_1990_2000 = %pctchg( AvgFamilyIncAdj_1990, AvgFamilyIncAdj_2000 );
    if AvgFamilyIncAdj_2000 > 0 then PctChgAvgFamilyIncA_2000_2010_14 = %pctchg( AvgFamilyIncAdj_2000, AvgFamilyIncAdj_2010_14 );
    
    label
      PctChgAvgFamilyIncAdj_1980_1990 = "% change in avg. family income, 1980 to 1990"
      PctChgAvgFamilyIncAdj_1990_2000 = "% change in avg. family income, 1990 to 2000"
      PctChgAvgFamilyIncA_2000_2010_14 = "% change in avg. family income, 2000 to 2010-14"
      ;
    
    PctChgAvgFamIncA_m_2000_2010_14 = AvgFamilyIncAdj_m_2010_14 / AvgFamilyIncAdj_2000;
    

    ** Housing Conditions **;
    
    %Label_var_years( var=NumOccupiedHsgUnits, label=Occupied housing units, years=1980 1990 2000 2010_14 2010 )

    %Pct_calc( var=PctVacantHsgUnitsForRent, label=Rental vacancy rate (%), num=NumVacantHsgUnitsForRent, den=NumRenterHsgUnits, years=1980 1990 2000 2010_14 )
    %Pct_calc( var=PctOwnerOccupiedHsgUnits, label=Homeownership rate (%), num=NumOwnerOccupiedHsgUnits, den=NumOccupiedHsgUnits, years=1980 1990 2000 2010_14 )
    
    %Moe_prop_a( var=PctVacantHUForRent_m_2010_14, mult=100, num=NumVacantHsgUnitsForRent_2010_14, den=NumRenterHsgUnits_2010_14, 
                       num_moe=mNumVacantHUForRent_2010_14, den_moe=mNumRenterHsgUnits_2010_14 );
    
    %Moe_prop_a( var=PctOwnerOccupiedHU_m_2010_14, mult=100, num=NumOwnerOccupiedHsgUnits_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumOwnerOccupiedHU_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );*/
    
   
    ** Create flag for generating profile **;
    
    if TotPop_2010 >= 100 then _make_profile = 1;
    else _make_profile = 0;
    
 
  run;
    
  %File_info( data=Equity.Equity_profile&geosuf, printobs=0, contents=n )
  
%end; 
  
%mend add_percents;

/** End Macro Definition **/

%add_percents; 
