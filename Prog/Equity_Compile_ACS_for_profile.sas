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

%let inc_dollar_yr=2015;
%let racelist=W B H AIOM;
%let racename= NH-White Black-Alone Hispanic All-Other;+

+
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
          equity.acs_2010_14_dc_sum_bg&geosuf
        (keep=&geo TotPop: mTotPop: 
		   PopUnder5Years_: mPopUnder5Years_:
		   PopUnder18Years_: mPopUnder18Years_:
		   Pop18_34Years_:mPop18_34Years_:
		   Pop35_64Years_: mPop35_64Years_:
		   Pop65andOverYears_: mPop65andOverYears_:
		   Pop25andOverYears_: mPop25andOverYears_:
		   PopWithRace: mPopWithRace:
		   PopBlackNonHispBridge: mPopBlackNonHispBridge:
           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
		   PopHisp: mPopHisp:
		   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
		   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
		   PopMultiracialNonHisp: mPopMultiracialNonHisp:
		   PopAlone: mPopAlone:
           NumFamilies_: mNumFamilies_:
		   PopEmployed:  mPopEmployed:
		   PopEmployedByOcc: mPopEmployedByOcc: 
		   PopEmployedMngmt: mPopEmployedMngmt:
		   PopEmployedServ: mPopEmployedServ: 
		   PopEmployedSales: mPopEmployedSales:
		   PopEmployedNatRes: mPopEmployedNatRes: 
		   PopEmployedProd: mPopEmployedProd:
           Pop25andOverWoutHS: mPop25andOverWoutHS: 
		   Pop25andOverWHS_: mPop25andOverWHS_:
		   Pop25andOverWSC_: mPop25andOverWSC_:
		   Pop25andOverWCollege_: mPop25andOverWCollege_:
		   AggIncome: mAggIncome:
		   AggHshldIncome: mAggHshldIncome:
		   FamIncomeLT75k_: mFamIncomeLT75k_:
		   FamIncomeGT200k_: mFamIncomeGT200k_:
		   NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
		   NumOwnerOccupiedHU: mNumOwnerOccupiedHU:
           NumRenterHsgUnits: mNumRenterHsgUnits:
		   NumRenterOccupiedHU: mNumRenterOccupiedHU:
		   NumVacantHsgUnits: mNumVacantHsgUnits:
		   NumVacantHsgUnitsForRent: mNumVacantHUForRent: 
		   NumVacantHsgUnitsForSale: mNumVacantHUForSale:
           NumOwnerOccupiedHU: mNumOwnerOccupiedHU:)

      equity.Acs_2010_14_dc_sum_tr&geosuf
        (keep=&geo TotPop: mTotPop: 
		   PopUnder5Years: mPopUnder5Years:
		   Pop5andOverYears: mPop5andOverYears:
		   PopUnder18Years: mPopUnder18Years: 
		   Pop18_34Years: mPop18_34Years:
		   Pop35_64Years: mPop35_64Years:
		   Pop65andOverYears: mPop65andOverYears:
		   Pop25andOverYears: mPop25andOverYears: 
		   PopWithRace: mPopWithRace:
		   PopBlackNonHispBridge: mPopBlackNonHispBridge:
           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
		   PopHisp: mPopHisp:
		   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
		   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
		   PopMultiracialNonHisp: mPopMultiracialNonHisp:
		   PopAlone: mPopAlone:
           NumFamilies: mNumFamilies:
		   NumHshlds: mNumHshlds:
		   PopEmployed:  mPopEmployed:
		   PopEmployedByOcc: mPopEmployedByOcc: 
		   PopEmployedMngmt: mPopEmployedMngmt:
		   PopEmployedServ: mPopEmployedServ: 
		   PopEmployedSales: mPopEmployedSales:
		   PopEmployedNatRes: mPopEmployedNatRes: 
		   PopEmployedProd: mPopEmployedProd:
           Pop25andOverWoutHS: mPop25andOverWoutHS: 
		   Pop25andOverWHS: mPop25andOverWHS:
		   Pop25andOverWSC: mPop25andOverWSC:
		   Pop25andOverWCollege: mPop25andOverWCollege:
		   AggIncome: mAggIncome:
		   AggHshldIncome: mAggHshldIncome:
		   FamIncomeLT75k: mFamIncomeLT75k:
		   FamIncomeGT200k: mFamIncomeGT200k:
		   NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
		   NumOwnerOccupiedHU: mNumOwnerOccupiedHU:
           NumRenterHsgUnits: mNumRenterHsgUnits:
		   NumRenterOccupiedHU: mNumRenterOccupiedHU:
		   NumVacantHsgUnits: mNumVacantHsgUnits:
		   NumVacantHsgUnitsForRent: mNumVacantHUForRent: 
		   NumVacantHsgUnitsForSale: mNumVacantHUForSale:
           NumOwnerOccupiedHU: mNumOwnerOccupiedHU:
		   PopNativeBorn: mPopNativeBorn:
		   PopNonEnglish: mPopNonEnglish:
		   PopForeignBorn: mPopForeignBorn: 
           PersonsPovertyDef: mPersonsPovertyDef:
           PopPoorPersons: mPopPoorPersons: 
           PopInCivLaborForce: mPopInCivLaborForce: 
		   PopCivilianEmployed: mPopCivilianEmployed:
           PopUnemployed: mPopUnemployed:
           Pop16andOverYears: mPop16andOverYears: 
           Pop16andOverEmploy: mPop16andOverEmploy: 
		   Pop16_64years: mPop16_64years:
		   Pop25_64years: mPop25_64years:
		   Pop16_64Employed: mPop16_64Employed:
		   Pop25_64Employed: mPop25_64Employed:
		   PopWorkFT: mPopWorkFT:
		   PopWorkEarn: mPopWorkEarn:
		   PopWorkFTLT35K: mPopWorkFTLT35K:
		   PopWorkFTLT75K: mPopWorkFTLT75K:
           NumFamiliesOwnChildren: mNumFamiliesOwnChildren:
           NumFamiliesOwnChildrenFH: mNumFamiliesOwnChildFH: 
           ChildrenPovertyDef: mChildrenPovertyDef: 
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

  data equity.Equity_profile&geosuf (compress=no); 
  
    set Equity_profile&geosuf._A;
    
    ** Population **;
    
	%Label_var_years( var=TotPop, label=Population, years= 2010_14 )

	%Pct_calc( var=PctForeignBorn, label=% foreign born, num=PopForeignBorn, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=PctForeignBorn_m_2010_14, mult=100, num=PopForeignBorn_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopForeignBorn_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctNativeBorn, label=% native born, num=PopNativeBorn, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=PctNativeBorn_m_2010_14, mult=100, num=PopNativeBorn_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopNativeBorn_2010_14, den_moe=mPopWithRace_2010_14 );

    %Pct_calc( var=PctPopUnder18Years, label=% children, num=PopUnder18Years, den=PopWithRace, years= 2010_14 )
    
    %Moe_prop_a( var=PctPopUnder18Years_m_2010_14, mult=100, num=PopUnder18Years_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopUnder18Years_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctPop18_34Years, label=% persons 18-34 years old, num=Pop18_34Years, den=PopWithRace, years= 2010_14 )
	
	%Moe_prop_a( var=PctPop18_34Years_m_2010_14, mult=100, num=Pop18_34Years_2010_14, den=PopWithRace_2010_14, 
	                       num_moe=mPop18_34Years_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctPop35_64Years, label=% persons 35-64 years old, num=Pop35_64Years, den=PopWithRace, years= 2010_14 )
	
	%Moe_prop_a( var=PctPop35_64Years_m_2010_14, mult=100, num=Pop35_64Years_2010_14, den=PopWithRace_2010_14, 
	                       num_moe=mPop35_64Years_2010_14, den_moe=mPopWithRace_2010_14 );

	%Pct_calc( var=PctPop65andOverYears, label=% seniors, num=Pop65andOverYears, den=PopWithRace, years= 2010_14 )

    %Moe_prop_a( var=PctPop65andOverYrs_m_2010_14, mult=100, num=Pop65andOverYears_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPop65andOverYears_2010_14, den_moe=mPopWithRace_2010_14 );

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");
	 
    %Pct_calc( var=PctPopUnder18Years&race., label=% children &name., num=PopUnder18Years&race., den=PopAlone&race., years= 2010_14 )
    
    %Moe_prop_a( var=PctPopUnder18Years&race._m_2010_14, mult=100, num=PopUnder18Years&race._2010_14, den=PopAlone&race._2010_14, 
                       num_moe=mPopUnder18Years&race._2010_14, den_moe=mPopAlone&race._2010_14 );

	%Pct_calc( var=PctPop18_34Years&race., label=% persons 18-34 years old &name., num=Pop18_34Years&race., den=PopAlone&race., years= 2010_14 )
	
	%Moe_prop_a( var=PctPop18_34Years&race._m_2010_14, mult=100, num=Pop18_34Years&race._2010_14, den=PopAlone&race._2010_14, 
	                       num_moe=mPop18_34Years&race._2010_14, den_moe=mPopAlone&race._2010_14 );

	%Pct_calc( var=PctPop35_64Years&race., label=% persons 35-64 years old &name., num=Pop35_64Years&race., den=PopAlone&race., years= 2010_14 )
	
	%Moe_prop_a( var=PctPop35_64Years&race._m_2010_14, mult=100, num=Pop35_64Years&race._2010_14, den=PopAlone&race._2010_14, 
	                       num_moe=mPop35_64Years&race._2010_14, den_moe=mPopAlone&race._2010_14 );

	%Pct_calc( var=PctPop65andOverYears&race., label=% seniors &name., num=Pop65andOverYears&race., den=PopAlone&race., years= 2010_14 )

    %Moe_prop_a( var=PctPop65andOverYrs&race._m_2010_14, mult=100, num=Pop65andOverYears&race._2010_14, den=PopAlone&race._2010_14, 
                       num_moe=mPop65andOverYears&race._2010_14, den_moe=mPopAlone&race._2010_14 );

	%Pct_calc( var=PctForeignBorn&race., label=% foreign born &name., num=PopForeignBorn&race., den=PopAlone&race., years=2010_14 )

    %Moe_prop_a( var=PctForeignBorn&race._m_2010_14, mult=100, num=PopForeignBorn&race._2010_14, den=PopAlone&race._2010_14, 
                       num_moe=mPopForeignBorn&race._2010_14, den_moe=mPopAlone&race._2010_14 );

	%end;

    
    ** Population by Race/Ethnicity **;
    
    %Pct_calc( var=PctBlackNonHispBridge, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctWhiteNonHispBridge, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctHisp, label=% Hispanic, num=PopHisp, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctAsnPINonHispBridge, label=% Asian/P.I. non-Hispanic, num=PopAsianPINonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctOtherRaceNonHispBridg, label=% All other than Black White Asian P.I. Hispanic, num=PopOtherRaceNonHispBridg, den=PopWithRace, years=2010_14 )

    %Moe_prop_a( var=PctBlackNonHispBridge_m_2010_14, mult=100, num=PopBlackNonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopBlackNonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

    %Moe_prop_a( var=PctWhiteNonHispBridge_m_2010_14, mult=100, num=PopWhiteNonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopWhiteNonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

    %Moe_prop_a( var=PctHisp_m_2010_14, mult=100, num=PopHisp_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopHisp_2010_14, den_moe=mPopWithRace_2010_14 );

	%Moe_prop_a( var=PctAsnPINonHispBridge_m_2010_14, mult=100, num=PopAsianPINonHispBridge_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAsianPINonHispBridge_2010_14, den_moe=mPopWithRace_2010_14 );

    %Moe_prop_a( var=PctOthRaceNonHispBridg_m_2010_14, mult=100, num=PopOtherRaceNonHispBridg_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopOtherRaceNonHispBr_2010_14, den_moe=mPopWithRace_2010_14 );

	** Population by race/ethnicity alone**; 

    %Pct_calc( var=PctAloneB, label=% black alone, num=PopAloneB, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneW, label=% white alone, num=PopAloneW, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneH, label=% Hispanic alone, num=PopAloneH, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneA, label=% Asian/P.I. alone, num=PopAloneA, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneI, label=% Indigenous alone, num=PopAloneI, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneO, label=% Other race alone, num=PopAloneO, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneM, label=% Multiracial alone, num=PopAloneM, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneIOM, label=% Indigienous-other-multi-alone, num=PopAloneIOM, den=PopWithRace, years=2010_14 )
	%Pct_calc( var=PctAloneAIOM, label=% All other than Black-White-Hispanic, num=PopAloneAIOM, den=PopWithRace, years=2010_14 )

	%Moe_prop_a( var=PctAloneB_m_2010_14, mult=100, num=PopAloneB_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneB_2010_14, den_moe=mPopWithRace_2010_14 );

	%Moe_prop_a( var=PctAloneW_m_2010_14, mult=100, num=PopAloneW_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneW_2010_14, den_moe=mPopWithRace_2010_14 );

	%Moe_prop_a( var=PctAloneH_m_2010_14, mult=100, num=PopAloneH_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneH_2010_14, den_moe=mPopWithRace_2010_14 );

	%Moe_prop_a( var=PctAloneA_m_2010_14, mult=100, num=PopAloneA_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneA_2010_14, den_moe=mPopWithRace_2010_14 );
					   
	%Moe_prop_a( var=PctAloneI_m_2010_14, mult=100, num=PopAloneI_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneI_2010_14, den_moe=mPopWithRace_2010_14);

	%Moe_prop_a( var=PctAloneO_m_2010_14, mult=100, num=PopAloneO_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneO_2010_14, den_moe=mPopWithRace_2010_14 );

	%Moe_prop_a( var=PctAloneM_m_2010_14, mult=100, num=PopAloneM_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneM_2010_14, den_moe=mPopWithRace_2010_14);

	%Moe_prop_a( var=PctAloneIOM_m_2010_14, mult=100, num=PopAloneIOM_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneIOM_2010_14, den_moe=mPopWithRace_2010_14 );

	%Moe_prop_a( var=PctAloneAIOM_m_2010_14, mult=100, num=PopAloneAIOM_2010_14, den=PopWithRace_2010_14, 
                       num_moe=mPopAloneAIOM_2010_14, den_moe=mPopWithRace_2010_14 );


	** Family Risk Factors **;

	%Pct_calc( var=PctOthLang, label=% pop. that speaks a language other than English at home, num=PopNonEnglish, den=Pop5andOverYears, years=2010_14 )

	%Moe_prop_a( var=PctOthLang_m_2010_14, mult=100, num=PopNonEnglish_2010_14, den=Pop5andOverYears_2010_14, 
	                       num_moe=mPopNonEnglish_2010_14, den_moe=mPop5andOverYears_2010_14 );

	%Pct_calc( var=PctPoorPersons, label=Poverty rate (%), num=PopPoorPersons, den=PersonsPovertyDefined, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsB, label=Poverty rate Black-Alone (%), num=PopPoorPersonsB, den=PersonsPovertyDefinedB, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsW, label=Poverty rate NH-White (%), num=PopPoorPersonsW, den=PersonsPovertyDefinedW, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsH, label=Poverty rate Hispanic(%), num=PopPoorPersonsH, den=PersonsPovertyDefinedH, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsAIOM, label=Poverty rate All-Other(%), num=PopPoorPersonsAIOM, den=PersonsPovertyDefAIOM, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsFB, label=Poverty rate foreign born (%), num=PopPoorPersonsFB, den=PersonsPovertyDefinedFB, years=2010_14 )
    
	%Moe_prop_a( var=PctPoorPersons_m_2010_14, mult=100, num=PopPoorPersons_2010_14, den=PersonsPovertyDefined_2010_14, 
                       num_moe=mPopPoorPersons_2010_14, den_moe=mPersonsPovertyDefined_2010_14 );

    %Moe_prop_a( var=PctPoorPersonsB_m_2010_14, mult=100, num=PopPoorPersonsB_2010_14, den=PersonsPovertyDefinedB_2010_14, 
                       num_moe=mPopPoorPersonsB_2010_14, den_moe=mPersonsPovertyDefinedB_2010_14 );

    %Moe_prop_a( var=PctPoorPersonsW_m_2010_14, mult=100, num=PopPoorPersonsW_2010_14, den=PersonsPovertyDefinedW_2010_14, 
                       num_moe=mPopPoorPersonsW_2010_14, den_moe=mPersonsPovertyDefinedW_2010_14 );

    %Moe_prop_a( var=PctPoorPersonsH_m_2010_14, mult=100, num=PopPoorPersonsH_2010_14, den=PersonsPovertyDefinedH_2010_14, 
                       num_moe=mPopPoorPersonsH_2010_14, den_moe=mPersonsPovertyDefinedH_2010_14 );

	%Moe_prop_a( var=PctPoorPersonsAIOM_m_2010_14, mult=100, num=PopPoorPersonsAIOM_2010_14, den=PersonsPovertyDefAIOM_2010_14, 
                       num_moe=mPopPoorPersonsAIOM_2010_14, den_moe=mPersonsPovertyDefAIOM_2010_14 );

	%Moe_prop_a( var=PctPoorPersonsFB_m_2010_14, mult=100, num=PopPoorPersonsFB_2010_14, den=PersonsPovertyDefinedFB_2010_14, 
                       num_moe=mPopPoorPersonsFB_2010_14, den_moe=mPersonsPovertyDefinedFB_2010_14 );

	%Pct_calc( var=PctUnemployed, label=Unemployment rate (%), num=PopUnemployed, den=PopInCivLaborForce, years=2010_14 )

	%Moe_prop_a( var=PctUnemployed_m_2010_14, mult=100, num=PopUnemployed_2010_14, den=PopInCivLaborForce_2010_14, 
	                       num_moe=mPopUnemployed_2010_14, den_moe=mPopInCivLaborForce_2010_14 );

	%Pct_calc( var=PctEmployed16to64, label=% persons employed between 16 and 64 years old, num=Pop16_64Employed, den=Pop16_64years, years=2010_14 )

	%Moe_prop_a( var=PctEmployed16to64_m_2010_14, mult=100, num=Pop16_64Employed_2010_14, den=Pop16_64years_2010_14, 
                       num_moe=mPop16_64Employed_2010_14, den_moe=mPop16_64years_2010_14 );

	%Pct_calc( var=Pct16andOverEmploy, label=% pop. 16+ yrs. employed, num=Pop16andOverEmploy, den=Pop16andOverYears, years=2010_14 )

    %Moe_prop_a( var=Pct16andOverEmploy_m_2010_14, mult=100, num=Pop16andOverEmploy_2010_14, den=Pop16andOverYears_2010_14, 
                       num_moe=mPop16andOverEmploy_2010_14, den_moe=mPop16andOverYears_2010_14 );

	%Pct_calc( var=Pct16andOverWages, label=% persons employed with earnings, num=PopWorkEarn, den=Pop16andOverYears, years=2010_14 )

	%Moe_prop_a( var=Pct16andOverWages_m_2010_14, mult=100, num=PopWorkEarn_2010_14, den=Pop16andOverYears_2010_14, 
                       num_moe=mPopWorkEarn_2010_14, den_moe=mPop16andOverYears_2010_14 );

	%Pct_calc( var=Pct16andOverWorkFT, label=% persons employed full time, num=PopWorkFT, den=Pop16andOverYears, years=2010_14 )

    %Moe_prop_a( var=Pct16andOverWorkFT_m_2010_14, mult=100, num=PopWorkFT_2010_14, den=Pop16andOverYears_2010_14, 
                       num_moe=mPopWorkFT_2010_14, den_moe=mPop16andOverYears_2010_14 );

	%Pct_calc( var=PctWorkFTLT35k, label=% persons employed full time with earnings less than 35000, num=PopWorkFTLT35K, den=PopWorkFT, years=2010_14 )

	%Moe_prop_a( var=PctWorkFTLT35k_m_2010_14, mult=100, num=PopWorkFTLT35k_2010_14, den=PopWorkFT_2010_14, 
                       num_moe=mPopWorkFTLT35k_2010_14, den_moe=mPopWorkFT_2010_14 );

	%Pct_calc( var=PctWorkFTLT75k, label=% persons employed full time with earnings less than 75000, num=PopWorkFTLT75k, den=PopWorkFT, years=2010_14 )

	%Moe_prop_a( var=PctWorkFTLT75k_m_2010_14, mult=100, num=PopWorkFTLT75k_2010_14, den=PopWorkFT_2010_14, 
                       num_moe=mPopWorkFTLT75k_2010_14, den_moe=mPopWorkFT_2010_14 );

	%Pct_calc( var=PctEmployedMngmt, label=% persons 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt, den=PopEmployedByOcc, years=2010_14 )

	%Moe_prop_a( var=PctEmployedMngmt_m_2010_14, mult=100, num=PopEmployedMngmt_2010_14, den=PopEmployedByOcc_2010_14, 
                       num_moe=mPopEmployedMngmt_2010_14, den_moe=mPopEmployedByOcc_2010_14 );

	%Pct_calc( var=PctEmployedServ, label=% persons 16+ years old employed in service occupations, num=PopEmployedServ, den=PopEmployedByOcc, years=2010_14 )

	%Moe_prop_a( var=PctEmployedServ_m_2010_14, mult=100, num=PopEmployedServ_2010_14, den=PopEmployedByOcc_2010_14, 
                       num_moe=mPopEmployedServ_2010_14, den_moe=mPopEmployedByOcc_2010_14 );

	%Pct_calc( var=PctEmployedSales, label=% persons 16+ years old employed in sales and office occupations, num=PopEmployedSales, den=PopEmployedByOcc, years=2010_14 )

	%Moe_prop_a( var=PctEmployedSales_m_2010_14, mult=100, num=PopEmployedSales_2010_14, den=PopEmployedByOcc_2010_14, 
                       num_moe=mPopEmployedSales_2010_14, den_moe=mPopEmployedByOcc_2010_14 );

	%Pct_calc( var=PctEmployedNatRes, label=% persons 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes, den=PopEmployedByOcc, years=2010_14 )

	%Moe_prop_a( var=PctEmployedNatRes_m_2010_14, mult=100, num=PopEmployedNatRes_2010_14, den=PopEmployedByOcc_2010_14, 
                       num_moe=mPopEmployedNatRes_2010_14, den_moe=mPopEmployedByOcc_2010_14 );

	%Pct_calc( var=PctEmployedProd, label=% persons employed in production transportation and material moving occupations, num=PopEmployedProd, den=PopEmployedByOcc, years=2010_14 )

	%Moe_prop_a( var=PctEmployedProd_m_2010_14, mult=100, num=PopEmployedProd_2010_14, den=PopEmployedByOcc_2010_14, 
                       num_moe=mPopEmployedProd_2010_14, den_moe=mPopEmployedByOcc_2010_14 );

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");
		 
	%Pct_calc( var=PctUnemployed&race., label=&name. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=2010_14 )

	%Moe_prop_a( var=PctUnemployed&race._m_2010_14, mult=100, num=PopUnemployed&race._2010_14, den=PopInCivLaborForce&race._2010_14, 
	                       num_moe=mPopUnemployed&race._2010_14, den_moe=mPopInCivLaborForce&race._2010_14 );

	%Pct_calc( var=PctEmployed16to64&race., label=% persons &name. employed between 16 and 64 years old, num=Pop16_64Employed&race., den=Pop16_64years&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployed16to64&race._m_2010_14, mult=100, num=Pop16_64Employed&race._2010_14, den=Pop16_64years&race._2010_14, 
                       num_moe=mPop16_64Employed&race._2010_14, den_moe=mPop16_64years&race._2010_14 );

	%Pct_calc( var=Pct16andOverEmploy&race., label=% pop. 16+ yrs. employed &name., num=Pop16andOverEmploy&race., den=Pop16andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct16andOverEmploy&race._m_2010_14, mult=100, num=Pop16andOverEmploy&race._2010_14, den=Pop16andOverYears&race._2010_14, 
                       num_moe=mPop16andOverEmploy&race._2010_14, den_moe=mPop16andOverYears&race._2010_14 );

	%Pct_calc( var=Pct16andOverWages&race., label=% persons &name. employed with earnings, num=PopWorkEarn&race., den=Pop16andOverYears&race., years=2010_14 )

	%Moe_prop_a( var=Pct16andOverWages&race._m_2010_14, mult=100, num=PopWorkEarn&race._2010_14, den=Pop16andOverYears&race._2010_14, 
                       num_moe=mPopWorkEarn&race._2010_14, den_moe=mPop16andOverYears&race._2010_14 );

	%Pct_calc( var=Pct16andOverWorkFT&race., label=% persons &name. employed full time, num=PopWorkFT&race., den=Pop16andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct16andOverWorkFT&race._m_2010_14, mult=100, num=PopWorkFT&race._2010_14, den=Pop16andOverYears&race._2010_14, 
                       num_moe=mPopWorkFT&race._2010_14, den_moe=mPop16andOverYears&race._2010_14 );

	%Pct_calc( var=PctWorkFTLT35k&race., label=% persons &name. employed full time with earnings less than 35000, num=PopWorkFTLT35K&race., den=PopWorkFT&race., years=2010_14 )

	%Moe_prop_a( var=PctWorkFTLT35k&race._m_2010_14, mult=100, num=PopWorkFTLT35k&race._2010_14, den=PopWorkFT&race._2010_14, 
                       num_moe=mPopWorkFTLT35k&race._2010_14, den_moe=mPopWorkFT&race._2010_14 );

	%Pct_calc( var=PctWorkFTLT75k&race., label=% persons &name. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race., den=PopWorkFT&race., years=2010_14 )

	%Moe_prop_a( var=PctWorkFTLT75k&race._m_2010_14, mult=100, num=PopWorkFTLT75k&race._2010_14, den=PopWorkFT&race._2010_14, 
                       num_moe=mPopWorkFTLT75k&race._2010_14, den_moe=mPopWorkFT&race._2010_14 );

	%Pct_calc( var=PctEmployedMngmt&race., label=% persons &name. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedMngmt&race._m_2010_14, mult=100, num=PopEmployedMngmt&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedMngmt&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedServ&race., label=% persons &name. 16+ years old employed in service occupations, num=PopEmployedServ&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedServ&race._m_2010_14, mult=100, num=PopEmployedServ&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedServ&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedSales&race., label=% persons &name. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedSales&race._m_2010_14, mult=100, num=PopEmployedSales&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedSales&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedNatRes&race., label=% persons &name. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedNatRes&race._m_2010_14, mult=100, num=PopEmployedNatRes&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedNatRes&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedProd&race., label=% persons &name. employed in production transportation and material moving occupations, num=PopEmployedProd&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedProd&race._m_2010_14, mult=100, num=PopEmployedProd&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedProd&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%end;


	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=Pct25andOverWoutHS&race., label=% persons &name. without HS diploma, num=Pop25andOverWoutHS&race., den=Pop25andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWoutHS&race._m_2010_14, mult=100, num=Pop25andOverWoutHS&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWoutHS&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%Pct_calc( var=Pct25andOverWHS&race., label=% persons &name. with HS diploma, num=Pop25andOverWHS&race., den=Pop25andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWHS&race._m_2010_14, mult=100, num=Pop25andOverWHS&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWHS&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%Pct_calc( var=Pct25andOverWSC&race., label=% persons &name. with some college, num=Pop25andOverWSC&race., den=Pop25andOverYears&race., years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSC&race._m_2010_14, mult=100, num=Pop25andOverWSC&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWSC&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%end;

	%Pct_calc( var=Pct25andOverWoutHS, label=% persons without HS diploma, num=Pop25andOverWoutHS, den=Pop25andOverYears, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWoutHS_m_2010_14, mult=100, num=Pop25andOverWoutHS_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWoutHS_2010_14, den_moe=mPop25andOverYears_2010_14 );

	%Pct_calc( var=Pct25andOverWoutHSFB, label=% foreign born persons without HS diploma, num=Pop25andOverWoutHSFB, den=Pop25andOverYearsFB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWoutHSFB_m_2010_14, mult=100, num=Pop25andOverWoutHSFB_2010_14, den=Pop25andOverYearsFB_2010_14, 
                       num_moe=mPop25andOverWoutHSFB_2010_14, den_moe=mPop25andOverYearsFB_2010_14 );

	%Pct_calc( var=Pct25andOverWoutHSNB, label=% native born persons without HS diploma, num=Pop25andOverWoutHSNB, den=Pop25andOverYearsNB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWoutHSNB_m_2010_14, mult=100, num=Pop25andOverWoutHSNB_2010_14, den=Pop25andOverYearsNB_2010_14, 
                       num_moe=mPop25andOverWoutHSNB_2010_14, den_moe=mPop25andOverYearsNB_2010_14 );

	%Pct_calc( var=Pct25andOverWHS, label=% persons with HS diploma, num=Pop25andOverWHS, den=Pop25andOverYears, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWHS_m_2010_14, mult=100, num=Pop25andOverWHS_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWHS_2010_14, den_moe=mPop25andOverYears_2010_14 );

	%Pct_calc( var=Pct25andOverWHSFB, label=% foreign born persons with HS diploma, num=Pop25andOverWHSFB, den=Pop25andOverYearsFB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWHSFB_m_2010_14, mult=100, num=Pop25andOverWHSFB_2010_14, den=Pop25andOverYearsFB_2010_14, 
                       num_moe=mPop25andOverWHSFB_2010_14, den_moe=mPop25andOverYearsFB_2010_14 );

	%Pct_calc( var=Pct25andOverWHSNB, label=% native born persons with HS diploma, num=Pop25andOverWHSNB, den=Pop25andOverYearsNB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWHSNB_m_2010_14, mult=100, num=Pop25andOverWHSNB_2010_14, den=Pop25andOverYearsNB_2010_14, 
                       num_moe=mPop25andOverWHSNB_2010_14, den_moe=mPop25andOverYearsNB_2010_14 );

	%Pct_calc( var=Pct25andOverWSC, label=% persons with some college, num=Pop25andOverWSC, den=Pop25andOverYears, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSC_m_2010_14, mult=100, num=Pop25andOverWSC_2010_14, den=Pop25andOverYears_2010_14, 
                       num_moe=mPop25andOverWSC_2010_14, den_moe=mPop25andOverYears_2010_14 );

	%Pct_calc( var=Pct25andOverWSCFB, label=% foreign born persons with some college, num=Pop25andOverWSCFB, den=Pop25andOverYearsFB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSCFB_m_2010_14, mult=100, num=Pop25andOverWSCFB_2010_14, den=Pop25andOverYearsFB_2010_14, 
                       num_moe=mPop25andOverWSCFB_2010_14, den_moe=mPop25andOverYearsFB_2010_14 );

	%Pct_calc( var=Pct25andOverWSCNB, label=% native born persons with some college, num=Pop25andOverWSCNB, den=Pop25andOverYearsNB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSCNB_m_2010_14, mult=100, num=Pop25andOverWSCNB_2010_14, den=Pop25andOverYearsNB_2010_14, 
                       num_moe=mPop25andOverWSCNB_2010_14, den_moe=mPop25andOverYearsNB_2010_14 );

    
   ** Child Well-Being Indicators **;
    
    %Pct_calc( var=PctPoorChildren, label=% children in poverty, num=PopPoorChildren, den=ChildrenPovertyDefined, years=2010_14 )
		%Pct_calc( var=PctPoorChildrenB, label=% children Black-Alone in poverty, num=PopPoorChildrenB, den=ChildrenPovertyDefinedB, years=2010_14 )
		%Pct_calc( var=PctPoorChildrenW, label=% children NH-White in poverty, num=PopPoorChildrenW, den=ChildrenPovertyDefinedW, years=2010_14 )
		%Pct_calc( var=PctPoorChildrenH, label=% children Hispanic in poverty, num=PopPoorChildrenH, den=ChildrenPovertyDefinedH, years=2010_14 )
		%Pct_calc( var=PctPoorChildrenAIOM, label=% children All-Other in poverty, num=PopPoorChildrenAIOM, den=ChildrenPovertyDefAIOM, years=2010_14 )

    %Moe_prop_a( var=PctPoorChildren_m_2010_14, mult=100, num=PopPoorChildren_2010_14, den=ChildrenPovertyDefined_2010_14, 
                       num_moe=mPopPoorChildren_2010_14, den_moe=mChildrenPovertyDefined_2010_14 );
       
	    %Moe_prop_a( var=PctPoorChildrenB_m_2010_14, mult=100, num=PopPoorChildrenB_2010_14, den=ChildrenPovertyDefinedB_2010_14, 
	                       num_moe=mPopPoorChildrenB_2010_14, den_moe=mChildrenPovertyDefinedB_2010_14 );

	    %Moe_prop_a( var=PctPoorChildrenW_m_2010_14, mult=100, num=PopPoorChildrenW_2010_14, den=ChildrenPovertyDefinedW_2010_14, 
	                       num_moe=mPopPoorChildrenW_2010_14, den_moe=mChildrenPovertyDefinedW_2010_14 );

	    %Moe_prop_a( var=PctPoorChildrenH_m_2010_14, mult=100, num=PopPoorChildrenH_2010_14, den=ChildrenPovertyDefinedH_2010_14, 
	                       num_moe=mPopPoorChildrenH_2010_14, den_moe=mChildrenPovertyDefinedH_2010_14 );

		%Moe_prop_a( var=PctPoorChildrenAIOM_m_2010_14, mult=100, num=PopPoorChildrenAIOM_2010_14, den=ChildrenPovertyDefAIOM_2010_14, 
	                       num_moe=mPopPoorChildrenAIOM_2010_14, den_moe=mChildrenPovertyDefAIOM_2010_14 );

        
    ** Income Conditions **;
    
	%Pct_calc( var=PctFamilyLT75000, label=% families with income less than 75000, num=FamIncomeLT75k, den=NumFamilies, years=2010_14 )

    %Moe_prop_a( var=PctFamilyLT75000_m_2010_14, mult=100, num=FamIncomeLT75k_2010_14, den=NumFamilies_2010_14, 
                       num_moe=mFamIncomeLT75k_2010_14, den_moe=mNumFamilies_2010_14 );

	%Pct_calc( var=PctFamilyGT200000, label=% families with income greater than 200000, num=FamIncomeGT200k, den=NumFamilies, years=2010_14 )

    %Moe_prop_a( var=PctFamilyGT200000_m_2010_14, mult=100, num=FamIncomeGT200k_2010_14, den=NumFamilies_2010_14, 
                       num_moe=mFamIncomeGT200k_2010_14, den_moe=mNumFamilies_2010_14 );

	%Pct_calc( var=AvgHshldIncome, label=Average household income last year ($), num=AggHshldIncome, den=NumHshlds, mult=1, years=2010_14 )

	%dollar_convert( AvgHshldIncome_2010_14, AvgHshldIncAdj_2010_14, 2014, &inc_dollar_yr )

    AvgHshldIncome_m_2010_14 = 
      %Moe_ratio( num=AggHshldIncome_2010_14, den=NumHshlds_2010_14, 
                  num_moe=mAggHshldIncome_2010_14, den_moe=mNumHshlds_2010_14 );
                        
    %dollar_convert( AvgHshldIncome_m_2010_14, AvgHshldIncAdj_m_2010_14, 2014, &inc_dollar_yr )

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctFamilyLT75000&race., label=% families &name. with income less than 75000, num=FamIncomeLT75k&race., den=NumFamilies&race., years=2010_14 )

    %Moe_prop_a( var=PctFamilyLT75000&race._m_2010_14, mult=100, num=FamIncomeLT75k&race._2010_14, den=NumFamilies&race._2010_14, 
                       num_moe=mFamIncomeLT75k&race._2010_14, den_moe=mNumFamilies&race._2010_14 );

	%Pct_calc( var=PctFamilyGT200000&race., label=% families &name. with income greater than 200000, num=FamIncomeGT200k&race., den=NumFamilies&race., years=2010_14 )

    %Moe_prop_a( var=PctFamilyGT200000&race._m_2010_14, mult=100, num=FamIncomeGT200k&race._2010_14, den=NumFamilies&race._2010_14, 
                       num_moe=mFamIncomeGT200k&race._2010_14, den_moe=mNumFamilies&race._2010_14 );

	%Pct_calc( var=AvgHshldIncome&race., label=Average household income last year &name. ($), num=AggHshldIncome&race., den=NumHshlds&race., mult=1, years=2010_14 )

	%dollar_convert( AvgHshldIncome&race._2010_14, AvgHshldIncAdj&race._2010_14, 2014, &inc_dollar_yr )

    AvgHshldIncome&race._m_2010_14 = 
      %Moe_ratio( num=AggHshldIncome&race._2010_14, den=NumHshlds&race._2010_14, 
                  num_moe=mAggHshldIncome&race._2010_14, den_moe=mNumHshlds&race._2010_14 );
                        
    %dollar_convert( AvgHshldIncome&race._m_2010_14, AvgHshldIncAdj&race._m_2010_14, 2014, &inc_dollar_yr )

	%end;

	label
	  AvgHshldIncAdjB_2010_14 = "Average household income, Black/African American, 2010-14"
	  AvgHshldIncAdjW_2010_14 = "Average household income, Non-Hispanic White, 2010-14"
	  AvgHshldIncAdjH_2010_14 = "Average household income, Hispanic/Latino, 2010-14"
	  AvgHshldIncAdjAIOM_2010_14 = "Average household income, All remaining groups other than Black, Non-Hispanic White, Hispanic, 2010-14"
      ;

        

    ** Housing Conditions **;
    
    %Label_var_years( var=NumOccupiedHsgUnits, label=Occupied housing units, years=2010_14 )

    %Pct_calc( var=PctVacantHsgUnitsForRent, label=Rental vacancy rate (%), num=NumVacantHsgUnitsForRent, den=NumRenterHsgUnits, years=2010_14 )

	%Moe_prop_a( var=PctVacantHUForRent_m_2010_14, mult=100, num=NumVacantHsgUnitsForRent_2010_14, den=NumRenterHsgUnits_2010_14, 
                       num_moe=mNumVacantHUForRent_2010_14, den_moe=mNumRenterHsgUnits_2010_14 );

    %Pct_calc( var=PctOwnerOccupiedHU, label=Homeownership rate (%), num=NumOwnerOccupiedHU, den=NumOccupiedHsgUnits, years=2010_14 )

    %Moe_prop_a( var=PctOwnerOccupiedHU_m_2010_14, mult=100, num=NumOwnerOccupiedHU_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumOwnerOccupiedHU_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctOwnerOccupiedHU&race., label=Homeownership rate &name.(%), num=NumOwnerOccupiedHU&race., den=NumOccupiedHsgUnits&race., years=2010_14 )

    
    %Moe_prop_a( var=PctOwnerOccupiedHU&race._m_2010_14, mult=100, num=NumOwnerOccupiedHU&race._2010_14, den=NumOccupiedHsgUnits&race._2010_14, 
                       num_moe=mNumOwnerOccupiedHU&race._2010_14, den_moe=mNumOccupiedHsgUnits&race._2010_14 );
    
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

/*proc print data=equity.equity_profile_city;
var city AvgHshldIncomeB_2010_14 AvgHshldIncomeW_2010_14 AvgHshldIncomeH_2010_14 AvgHshldIncomeAIOM_2010_14
AvgHshldIncomeB_m_2010_14 AvgHshldIncomeW_m_2010_14 AvgHshldIncomeH_m_2010_14 AvgHshldIncomeAIOM_m_2010_14
;

proc print data=equity.equity_profile_wd12;
var ward2012 
PctAloneB_2010_14 PctAloneB_m_2010_14 PctAloneW_2010_14 PctAloneW_m_2010_14 
PctAloneH_2010_14 PctAloneH_m_2010_14  PctAloneA_2010_14 PctAloneA_m_2010_14 
PctAloneI_2010_14 PctAloneI_m_2010_14 PctAloneO_2010_14 PctAloneO_m_2010_14 
PctAloneM_2010_14 PctAloneM_m_2010_14  PctAloneIOM_2010_14 PctAloneIOM_m_2010_14 
PctAloneAIOM_2010_14 PctAloneAIOM_m_2010_14
PctPoorPersons_2010_14 PctPoorPersons_m_2010_14 PctPoorPersonsB_2010_14 PctPoorPersonsB_m_2010_14
PctPoorPersonsW_2010_14 PctPoorPersonsW_m_2010_14 PctPoorPersonsH_2010_14 PctPoorPersonsH_m_2010_14
PctPoorPersonsAIOM_2010_14 PctPoorPersonsAIOM_m_2010_14 PctPoorPersonsFB_2010_14 PctPoorPersonsFB_m_2010_14
PctUnemployedB_2010_14 PctUnemployedB_m_2010_14
PctUnemployedW_2010_14 PctUnemployedW_m_2010_14 PctUnemployedH_2010_14 PctUnemployedH_m_2010_14
PctUnemployedAIOM_2010_14 PctUnemployedAIOM_m_2010_14*/
;
run; 
