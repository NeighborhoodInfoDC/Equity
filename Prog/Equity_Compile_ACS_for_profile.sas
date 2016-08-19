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
  %let racelist=W B H AIOM;
  %let racename= NH-White Black-Alone Hispanic All-Other;

    %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  data Equity_profile&geosuf._A (compress=no);  
  merge  
          equity.acs_2010_14_dc_sum_bg&geosuf
        (keep=&geo TotPop: mTotPop: 
		   PopUnder5Years_&_years. mPopUnder5Years_&_years.
		   PopUnder18Years_&_years. mPopUnder18Years_&_years. 
		   Pop18_34Years_&_years. mPop18_34Years_&_years.
		   Pop35_64Years_&_years. mPop35_64Years_&_years.
		   Pop65andOverYears_&_years. mPop65andOverYears_&_years.
		   Pop25andOverYears_&_years. mPop25andOverYears_&_years. 
		   PopWithRace: mPopWithRace:
		   PopBlackNonHispBridge: mPopBlackNonHispBridge:
           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
		   PopHisp: mPopHisp:
		   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
		   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
		   PopMultiracialNonHisp: mPopMultiracialNonHisp:
		   PopAlone: mPopAlone:
           /*NumHshldPhone: mNumHshldPhone: 
           NumHshldCar: mNumHshldCar: 
           NumFamilies_: mNumFamilies_:*/
		   PopEmployed:  mPopEmployed:
		   PopEmployedByOcc: mPopEmployedByOcc: 
		   PopEmployedMngmt: mPopEmployedMngmt:
		   PopEmployedServ: mPopEmployedServ: 
		   PopEmployedSales: mPopEmployedSales:
		   PopEmployedNatRes: mPopEmployedNatRes: 
		   PopEmployedProd: mPopEmployedProd:
           Pop25andOverWoutHS: mPop25andOverWoutHS: 
		   Pop25andOverWHS_&_years. mPop25andOverWHS_&_years. 
		   Pop25andOverWSC_&_years. mPop25andOverWSC_&_years. 
		   Pop25andOverWCollege_&_years. mPop25andOverWCollege_&_years.
		   AggFamilyIncome: mAggFamilyIncome: 
		   AggIncome: mAggIncome:
		   MedFamIncm: mMedFamIncm:
		   FamIncome_&_years. mFamIncome_&_years.
		   FamIncomeLT75k_&_years. mFamIncomeLT75k_&_years.
		   FamIncomeGT200k_&_years. mFamIncomeGT200k_&_years.
		   NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
		   NumOwnerOccupiedHU: mNumOwnerOccupiedHU:
           NumRenterHsgUnits: mNumRenterHsgUnits:
		   NumRenterOccupiedHU: mNumRenterOccupiedHU:
		   NumVacantHsgUnits: mNumVacantHsgUnits:
		   NumVacantHsgUnitsForRent: mNumVacantHUForRent: 
		   NumVacantHsgUnitsForSale: mNumVacantHsgUnitsForSale
           /*NumOwnerOccupiedHsgUnits: mNumOwnerOccupiedHU: */)

      equity.Acs_2010_14_dc_sum_tr&geosuf
        (keep=&geo TotPop: mTotPop: 
		   PopUnder5Years: mPopUnder5Years:
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
           /*NumHshldPhone: mNumHshldPhone: 
           NumHshldCar: mNumHshldCar: 
           NumFamilies_: mNumFamilies_:*/
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
		   AggFamilyIncome: mAggFamilyIncome: 
		   AggIncome: mAggIncome:
		   MedFamIncm: mMedFamIncm:
		   FamIncome: mFamIncome:
		   FamIncomeLT75k: mFamIncomeLT75k:
		   FamIncomeGT200k: mFamIncomeGT200k:
		   NumOccupiedHsgUnits: mNumOccupiedHsgUnits:
		   NumOwnerOccupiedHU: mNumOwnerOccupiedHU:
           NumRenterHsgUnits: mNumRenterHsgUnits:
		   NumRenterOccupiedHU: mNumRenterOccupiedHU:
		   NumVacantHsgUnits: mNumVacantHsgUnits:
		   NumVacantHsgUnitsForRent: mNumVacantHUForRent: 
		   NumVacantHsgUnitsForSale: mNumVacantHsgUnitsForSale
           /*NumOwnerOccupiedHsgUnits: mNumOwnerOccupiedHU: */)

		   PopNativeBorn: mPopNativeBorn:
		   PopNonEnglish: mPopNonEnglish:
		   PopForeignBorn: mPopForeignBorn: 
           PersonsPovertyDef: mPersonsPovertyDef:
           PopPoorPersons: mPopPoorPersons: 
           PopInCivLaborForce: mPopInCivLaborForce: 
		   PopCivilianEmployed: mPopCivilianEmployed:
           PopUnemployed: mPopUnemployed:
           Pop16andOverYears: mPop16andOverYears: 
           Pop16andOverEmployed: mPop16andOverEmployed: 
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

	%Pct_calc( var=PctForeignBorn, label=% foreign born, num=PopForeignBorn, den=TotPop_tr, years=2010_14 )

    %Moe_prop_a( var=PctForeignBorn_m_2010_14, mult=100, num=PopForeignBorn_2010_14, den=TotPop_tr_2010_14, 
                       num_moe=mPopForeignBorn_2010_14, den_moe=mTotPop_tr_2010_14 );

	%Pct_calc( var=PctNativeBorn, label=% native born, num=PopNativeBorn, den=TotPop_tr, years=2010_14 )

    %Moe_prop_a( var=PctNativeBorn_m_2010_14, mult=100, num=PopNativeBorn_2010_14, den=TotPop_tr_2010_14, 
                       num_moe=mPopNativeBorn_2010_14, den_moe=mTotPop_tr_2010_14 );

    %Pct_calc( var=PctSameHouse5YearsAgo, label=% same house 5 years ago, num=PopSameHouse5YearsAgo, den=Pop5andOverYears, years=2010_14 )


	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.,” “);
		%let name=%scan(&racename.,&r.,” “);
	 
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

    %Moe_prop_a( var=PctPop65andOverYears&race._m_2010_14, mult=100, num=Pop65andOverYears&race._2010_14, den=PopAlone&race._2010_14, 
                       num_moe=mPop65andOverYears&race._2010_14, den_moe=mPopAlone&race._2010_14 );

	%end;

    
    ** Population by Race/Ethnicity **;
    
    %Pct_calc( var=PctBlackNonHispBridge, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctWhiteNonHispBridge, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctHisp, label=% Hispanic, num=PopHisp, den=PopWithRace, years=2010_14 )
    %Pct_calc( var=PctAsianPINonHispBridge, label=% Asian/P.I. non-Hispanic, num=PopAsianPINonHispBridge, den=PopWithRace, years=2010_14 )
    
    %Pct_calc( var=PctOtherRaceNonHispBridge, label=% other race non-Hispanic, num=PopOtherRaceNonHispBridge, den=PopWithRace, years=2010_14 )
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
                       num_moe=mPopOtherRaceNonHispBridg_2010_14, den_moe=mPopWithRace2010_14 );

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

	%Pct_calc( var=PctOLang, label=% pop. that speaks a language other than English at home, num=PopNonEnglish, den=Pop5andOverYears, years=2010_14 )

	%Moe_prop_a( var=PctOLang_m_2010_14, mult=100, num=PopNonEnglish_2010_14, den=Pop5andOverYears_2010_14, 
	                       num_moe=mPopNonEnglish_2010_14, den_moe=mPop5andOverYears_2010_14 );

	%Pct_calc( var=PctFamiliesOwnChildrenFH, label=% female-headed families with children, num=NumFamiliesOwnChildrenFH, den=NumFamiliesOwnChildren, years=2010_14 )

    %Moe_prop_a( var=PctFamiliesOwnChildFH_m_2010_14, mult=100, num=NumFamiliesOwnChildrenFH_2010_14, den=NumFamiliesOwnChildren_2010_14, 
                       num_moe=mNumFamiliesOwnChildFH_2010_14, den_moe=mNumFamiliesOwnChildren_2010_14 );

	%Pct_calc( var=PctPoorPersonsB, label=Poverty rate Black-Alone (%), num=PopPoorPersonsB, den=PersonsPovertyDefinedB, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsW, label=Poverty rate NH-White (%), num=PopPoorPersonsW, den=PersonsPovertyDefinedW, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsH, label=Poverty rate Hispanic(%), num=PopPoorPersonsH, den=PersonsPovertyDefinedH, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsAIOM, label=Poverty rate All-Other(%), num=PopPoorPersonsAIOM, den=PersonsPovertyDefAIOM, years=2010_14 )
	%Pct_calc( var=PctPoorPersonsFB, label=Poverty rate foreign born (%), num=PopPoorPersonsFB, den=PersonsPovertyDefinedFB, years=2010_14 )
    
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

	%do r=1 %to 4;

			%let race=%scan(&racelist.,&r.,” “);
			%let name=%scan(&racename.,&r.,” “);
		 
	%Pct_calc( var=PctUnemployed&race., label=&name. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=2010_14 )

	%Moe_prop_a( var=PctUnemployed&race._m_2010_14, mult=100, num=PopUnemployed&race._2010_14, den=PopInCivLaborForce&race._2010_14, 
	                       num_moe=mPopUnemployed&race._2010_14, den_moe=mPopInCivLaborForce&race._2010_14 );

	%Pct_calc( var=PctEmployed16to64&race., label=% persons &name. employed between 16 and 64 years old, num=Pop16_64Employed&race., den=Pop16_64years&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployed16to64&race._m_2010_14, mult=100, num=Pop16_64Employed&race._2010_14, den=Pop16_64years&race._2010_14, 
                       num_moe=mPop16_64Employed&race._2010_14, den_moe=mPop16_64years&race._2010_14 );

	%Pct_calc( var=Pct16andOverWages&race., label=% persons &name. employed with earnings, num=PopWorkEarn&race., den=Pop16andOverYears&race., years=2010_14 )

	%Moe_prop_a( var=Pct16andOverWages_m_2010_14&race., mult=100, num=PopWorkEarn&race._2010_14, den=Pop16andOverYears&race._2010_14, 
                       num_moe=mPopWorkEarn&race._2010_14, den_moe=mPop16andOverYears&race._2010_14 );

	%Pct_calc( var=Pct16andOverWorkFT&race., label=% persons &name. employed full time, num=PopWorkFT&race., den=Pop16andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct16andOverWorkFT&race._m_2010_14, mult=100, num=PopWorkFT&race._2010_14, den=Pop16andOverYears&race._2010_14, 
                       num_moe=mPopWorkFT&race._2010_14, den_moe=mPop16andOverYears&race._2010_14 );

	%Pct_calc( var=Pct16andOverWorkFTLT35000&race., label=% persons &name. employed full time with earnings less than 35000, num=PopWorkFTLT35K&race., den=PopWorkFT&race., years=2010_14 )

	%Moe_prop_a( var=Pct16andOverWorkFTLT35000&race._m_2010_14, mult=100, num=PopWorkFTLT35k&race._2010_14, den=PopWorkFTLT35k&race._2010_14, 
                       num_moe=mPopWorkFTLT35k&race._2010_14, den_moe=mPopWorkFTLT35k&race._2010_14 );

	%Pct_calc( var=Pct16andOverWorkFTLT75000&race., label=% persons &name. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race., den=PopWorkFT&race., years=2010_14 )

	%Moe_prop_a( var=Pct16andOverWorkFTLT75000&race._m_2010_14, mult=100, num=PopWorkFTLT75k&race._2010_14, den=PopWorkFTLT75k&race._2010_14, 
                       num_moe=mPopWorkFTLT75k&race._2010_14, den_moe=mPopWorkFTLT75k&race._2010_14 );

	%Pct_calc( var=PctEmployedMngmt&race., label=% persons &name. 16+ years old employed in management, business, science and arts occupations, num=PopEmployedMngmt&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedMngmt&race._m_2010_14, mult=100, num=PopEmployedMngmt&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedMngmt&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedServ&race., label=% persons &name. 16+ years old employed in service occupations, num=PopEmployedServ&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedServ&race._m_2010_14, mult=100, num=PopEmployedServ&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedServ&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedSales&race., label=% persons &name. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedSales&race._m_2010_14, mult=100, num=PopEmployedSales&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedSales&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedNatRes&race., label=% persons &name. 16+ years old employed in natural resources, construction, and maintenance occupations, num=PopEmployedNatRes&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedNatRes&race._m_2010_14, mult=100, num=PopEmployedNatRes&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedNatRes&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%Pct_calc( var=PctEmployedProd&race., label=% persons &name. employed in production, transportation, and material moving occupations, num=PopEmployedProd&race., den=PopEmployedByOcc&race., years=2010_14 )

	%Moe_prop_a( var=PctEmployedProd&race._m_2010_14, mult=100, num=PopEmployedProd&race._2010_14, den=PopEmployedByOcc&race._2010_14, 
                       num_moe=mPopEmployedProd&race._2010_14, den_moe=mPopEmployedByOcc&race._2010_14 );

	%end;

    %Pct_calc( var=Pct16andOverEmployed, label=% pop. 16+ yrs. employed, num=Pop16andOverEmployed, den=Pop16andOverYears, years=2010_14 )

    %Moe_prop_a( var=Pct16andOverEmployed_m_2010_14, mult=100, num=Pop16andOverEmployed_2010_14, den=Pop16andOverYears_2010_14, 
                       num_moe=mPop16andOverEmployed_2010_14, den_moe=mPop16andOverYears_2010_14 );

	%do r=1 %to 4;

			%let race=%scan(&racelist.,&r.,” “);
			%let name=%scan(&racename.,&r.,” “);

    %Pct_calc( var=Pct25andOverWoutHS&race., label=% persons &name. without HS diploma, num=Pop25andOverWoutHS&race., den=Pop25andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct25andOverWoutHS&race._m_2010_14, mult=100, num=Pop25andOverWoutHS&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWoutHS&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%Pct_calc( var=Pct25andOverWHS&race., label=% persons &name. with HS diploma, num=Pop25andOverWHS&race., den=Pop25andOverYears&race., years=2010_14 )

    %Moe_prop_a( var=Pct25andOverAllWHS&race._m_2010_14, mult=100, num=Pop25andOverWHS&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWHS&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%Pct_calc( var=Pct25andOverWSC&race., label=% persons &name. with some college, num=Pop25andOverWSC&race., den=Pop25andOverYears&race., years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWSC&race._m_2010_14, mult=100, num=Pop25andOverWSC&race._2010_14, den=Pop25andOverYears&race._2010_14, 
                       num_moe=mPop25andOverWSC&race._2010_14, den_moe=mPop25andOverYears&race._2010_14 );

	%end;

	%Pct_calc( var=Pct25andOverWoutHSFB, label=% foreign born persons without HS diploma, num=Pop25andOverWoutHSFB, den=Pop25andOverYearsFB, years=2010_14 )
	%Pct_calc( var=Pct25andOverWoutHSNB, label=% native born persons without HS diploma, num=Pop25andOverWoutHSNB, den=Pop25andOverYearsNB, years=2010_14 )
	%Pct_calc( var=Pct25andOverWHSFB, label=% foreign born persons with HS diploma, num=Pop25andOverWHSFB, den=Pop25andOverYearsFB, years=2010_14 )
	%Pct_calc( var=Pct25andOverWHSNB, label=% native born persons with HS diploma, num=Pop25andOverWHSNB, den=Pop25andOverYearsNB, years=2010_14 )
	%Pct_calc( var=Pct25andOverWSCFB, label=% foreign born persons with some college, num=Pop25andOverWSCFB, den=Pop25andOverYearsFB, years=2010_14 )
	%Pct_calc( var=Pct25andOverWSCNB, label=% native born persons with some college, num=Pop25andOverWSCNB, den=Pop25andOverYearsNB, years=2010_14 )

	%Moe_prop_a( var=Pct25andOverWoutHSFB_m_2010_14, mult=100, num=Pop25andOverWoutHSFB_2010_14, den=Pop25andOverYearsFB_2010_14, 
                       num_moe=mPop25andOverWoutHSFB_2010_14, den_moe=mPop25andOverYearsFB_2010_14 );

	%Moe_prop_a( var=Pct25andOverWoutHSNB_m_2010_14, mult=100, num=Pop25andOverWoutHSNB_2010_14, den=Pop25andOverYearsNB_2010_14, 
                       num_moe=mPop25andOverWoutHSNB_2010_14, den_moe=mPop25andOverYearsNB_2010_14 );

	%Moe_prop_a( var=Pct25andOverWHSFB_m_2010_14, mult=100, num=Pop25andOverWHSFB_2010_14, den=Pop25andOverYearsFB_2010_14, 
                       num_moe=mPop25andOverWHSFB_2010_14, den_moe=mPop25andOverYearsFB_2010_14 );

	%Moe_prop_a( var=Pct25andOverWHSNB_m_2010_14, mult=100, num=Pop25andOverWHSNB_2010_14, den=Pop25andOverYearsNB_2010_14, 
                       num_moe=mPop25andOverWHSNB_2010_14, den_moe=mPop25andOverYearsNB_2010_14 );

	%Moe_prop_a( var=Pct25andOverWSCFB_m_2010_14, mult=100, num=Pop25andOverWSCFB_2010_14, den=Pop25andOverYearsFB_2010_14, 
                       num_moe=mPop25andOverWSCFB_2010_14, den_moe=mPop25andOverYearsFB_2010_14 );

	%Moe_prop_a( var=Pct25andOverWSCNB_m_2010_14, mult=100, num=Pop25andOverWSCNB_2010_14, den=Pop25andOverYearsNB_2010_14, 
                       num_moe=mPop25andOverWSCNB_2010_14, den_moe=mPop25andOverYearsNB_2010_14 );

    ** Isolation Indicators **;
    
    %Pct_calc( var=PctHshldPhone, label=% HHs with a phone, num=NumHshldPhone, den=NumOccupiedHsgUnits, years=2010_14 )
    %Pct_calc( var=PctHshldCar, label=% HHs with a car, num=NumHshldCar, den=NumOccupiedHsgUnits, years=2010_14 )
    
    %Moe_prop_a( var=PctHshldPhone_m_2010_14, mult=100, num=NumHshldPhone_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumHshldPhone_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );
    
    %Moe_prop_a( var=PctHshldCar_m_2010_14, mult=100, num=NumHshldCar_2010_14, den=NumOccupiedHsgUnits_2010_14, 
                       num_moe=mNumHshldCar_2010_14, den_moe=mNumOccupiedHsgUnits_2010_14 );
    
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

    
    %Pct_calc( var=Pct_births_low_wt, label=% low weight births (under 5.5 lbs), num=Births_low_wt, den=Births_w_weight, from=&births_start_yr, to=&births_end_yr )
    %Pct_calc( var=Pct_births_teen, label=% births to teen mothers, num=Births_teen, den=Births_w_age, from=&births_start_yr, to=&births_end_yr )
    
	 ** Elderly Well-Being Indicators **;
    
    %Pct_calc( var=PctPoorElderly, label=% seniors in poverty, num=PopPoorElderly, den=ElderlyPovertyDefined, years=2010_14 )
    
    %Moe_prop_a( var=PctPoorElderly_m_2010_14, mult=100, num=PopPoorElderly_2010_14, den=ElderlyPovertyDefined_2010_14, 
                       num_moe=mPopPoorElderly_2010_14, den_moe=mElderlyPovertyDefined_2010_14 );

    ** Income Conditions **;
    
	%do r=1 %to 4;

			%let race=%scan(&racelist.,&r.,” “);
			%let name=%scan(&racename.,&r.,” “);

    %Pct_calc( var=PctFamilyLT75000&race., label=% families &name. with income less than 75000, num=FamIncomeLT75k&race., den=FamIncome&race., years=2010_14 )

    %Moe_prop_a( var=PctFamilyLT75000&race._m_2010_14, mult=100, num=FamIncomeGT75k&race._2010_14, den=FamIncome&race._2010_14, 
                       num_moe=mFamIncomeGT75k&race._2010_14, den_moe=mFamIncome&race._2010_14 );

	%Pct_calc( var=PctFamilyGT200000&race., label=% families &name. with income greater than 200000, num=FamIncomeGT200k&race., den=FamIncome&race., years=2010_14 )

    %Moe_prop_a( var=PctFamilyGT200000&race._m_2010_14, mult=100, num=FamIncomeGT200k&race._2010_14, den=FamIncome&race._2010_14, 
                       num_moe=mFamIncomeGT200k&race._2010_14, den_moe=mFamIncome&race._2010_14 );

	%Pct_calc( var=AvgFamilyIncome&race., label=Average family income last year &name. ($), num=AggFamilyIncome&race., den=FamIncome&race., mult=1, years=2010_14 )

	%dollar_convert( AvgFamilyIncome&race._2010_14, AvgFamilyIncAdj&race._2010_14, 2015, &inc_dollar_yr )

	AvgFamilyIncome&race._m_2010_14 = 
      %Moe_ratio( num=AggFamilyIncome&race._2010_14, den=FamIncome&race._2010_14, 
                  num_moe=mAggFamilyIncome&race._2010_14, den_moe=mFamIncome&race._2010_14 );
                        
    %dollar_convert( AvgFamilyIncome&race._m_2010_14, AvgFamilyIncAdj&race._m_2010_14, 2015, &inc_dollar_yr )

	%Pct_calc( var=MedianFamilyIncome&race., label=Median family income last year &name. ($), num=MedFamIncm&race., den=FamIncome&race., mult=1, years=2010_14 )

	%dollar_convert( MedianFamilyIncome&race._2010_14, MedFamilyIncAdj&race._2010_14, 2015, &inc_dollar_yr )

	MedianFamilyIncome&race._m_2010_14 = 
      %Moe_ratio( num=MedFamIncm&race._2010_14, den=FamIncome&race._2010_14, 
                  num_moe=mMedFamIncm&race._2010_14, den_moe=mFamIncome&race._2010_14 );
                        
    %dollar_convert( MedianFamilyIncome&race._m_2010_14, MedFamilyIncAdj&race._m_2010_14, 2015, &inc_dollar_yr )

	%end;

	label
	  AvgFamilyIncAdjB_2010_14 = "Avg. family income, Black/African American, 2010-14"
	  AvgFamilyIncAdjW_2010_14 = "Avg. family income, Non-Hispanic White, 2010-14"
	  AvgFamilyIncAdjH_2010_14 = "Avg. family income, Hispanic/Latino, 2010-14"
	  AvgFamilyIncAdjAIOM_2010_14 = "Avg. family income, All remaining groups other than Black, Non-Hispanic White, Hispanic, 2010-14"
      ;

        

    ** Housing Conditions **;
    
    %Label_var_years( var=NumOccupiedHsgUnits, label=Occupied housing units, years=2010_14 )

    %Pct_calc( var=PctVacantHsgUnitsForRent, label=Rental vacancy rate (%), num=NumVacantHsgUnitsForRent, den=NumRenterHsgUnits, years=2010_14 )

	%Moe_prop_a( var=PctVacantHUForRent_m_2010_14, mult=100, num=NumVacantHsgUnitsForRent_2010_14, den=NumRenterHsgUnits_2010_14, 
                       num_moe=mNumVacantHUForRent_2010_14, den_moe=mNumRenterHsgUnits_2010_14 );

	%do r=1 %to 4;

			%let race=%scan(&racelist.,&r.,” “);
			%let name=%scan(&racename.,&r.,” “);

    %Pct_calc( var=PctOwnerOccupiedHU&race., label=Homeownership rate &name.(%), num=NumOwnerOccupiedHU&race., den=NumOccupiedHsgUnits&race., years=2010_14 )

    
    %Moe_prop_a( var=PctOwnerOccupiedHU&race._m_2010_14, mult=100, num=NumOwnerOccupiedHU&race._2010_14, den=NumOccupiedHsgUnits&race._2010_14, 
                       num_moe=mNumOwnerOccupiedHU&race._2010_14, den_moe=mNumOccupiedHsgUnits&race._2010_14 );
    
   	%end;

    ** Create flag for generating profile **;
    
    if TotPop_2010 >= 100 then _make_profile = 1;
    else _make_profile = 0;
    
 
  run;
    
  %File_info( data=Equity.Equity_profile&geosuf, printobs=0, contents=n )
  
%end; 
  
%mend add_percents;

/** End Macro Definition **/

%add_percents; 


/*proc print data=equity.equity_profile_wd12;
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
