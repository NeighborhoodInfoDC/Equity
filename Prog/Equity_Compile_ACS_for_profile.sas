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
 				7/29/17 - RP Updated for 2017 equity study to include indicators for Asian and mobility
						  indicators. Also macro'd to run for council district and county in DC, MD and VA.
				02/09/20 LH Update for 2014-18 ACS
				12/22/20 LH Update for 2015-19 ACS and update header to \\sas1\
				02/18/22 LH Update to break out IOM for all indicators
                07/25/22 YS add gender breakouts for employment vars by race for Sadie
		08/11/22 LH minor fixes for var names that were shortened. 
 Note: MOEs for AIOM average household income and average adjusted are blank because they are suppressed by the Census.
 **************************************************************************/


%include "\\sas1\DCDATA\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let inc_dollar_yr=2019;
%let racelist=W B H A IOM AIOM ;
%let racename= NH-White Black-Alone Hispanic Asian-PI Indigenous-Other-Multi All-Other ; 
*all-other is all other than NHWhite, Black, Hispanic; 
*all races except NH white, hispanic, and multiple race are race alone. ;

%let _years=2015_19;
%let revisions=Add employment by gender.;

/** Macro Add_Percents- Start Definition **/

%macro add_percents (state,geo,geo2);

  %let st = %upcase( &state );
  %let geodo = %upcase( &geo2 );

  %if &geodo = REGCNT %then %do;
  	%let t = regcnt;
	%let name = County;
  %end;
  %else %do;
  	%let t = tr;
	%let name = Council District;
  %end;

  %local geosuf geoafmt j; 

  %let geosuf = %sysfunc( putc( %upcase( &geo ), $geosuf. ) );
  %let geoafmt = %sysfunc( putc( %upcase( &geo ), $geoafmt. ) );

  %let y_lbl = %sysfunc( translate( &_years., '-', '_' ) );

  data profile_acs_&_years._&state._&geosuf._A (compress=no);  
  	merge  
      acs.Acs_&_years._&state._sum_&t.&geosuf.
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
           PopInCivLaborFor: mPopInCivLaborFor: 
		   PopCivilianEmployed: mPopCivilianEmployed:
		   PopCivilEmployed: mPopCivilEmployed: 
           PopUnemployed: mPopUnemployed:
           Pop16andOverYears: mPop16andOverYears: 
           Pop16andOverEmp: mPop16andOverEmp: 
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
		   PopMoved: mPopMoved:
		   rename=(TotPop_&_years.=TotPop_tr_&_years. mTotPop_&_years.=mTotPop_tr_&_years.))
         ;
    	 by &geo;
   
  run;

  /* i do not think we need this proc summary....
  proc summary data=Nbr_profile&geosuf._A;
    var _numeric_;
    class &geo;
    output out=Nbr_profile_acs&geosuf._B (compress=no) mean=;

  run;*/

  data profile_acs_&_years._&state.&geosuf (compress=no label="DC Equity Indicators by Race/Ethnicity, &_years., &geo."); 
  
    set profile_acs_&_years._&state._&geosuf._A;
    
    ** Population **;
    
	%Label_var_years( var=TotPop_tr, label=Population, years= &_years. )

	%Pct_calc( var=PctForeignBorn, label=% foreign born, num=PopForeignBorn, den=PopWithRace, years=&_years. )

    %Moe_prop_a( var=PctForeignBorn_m_&_years., mult=100, num=PopForeignBorn_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopForeignBorn_&_years., den_moe=mPopWithRace_&_years., label_moe = % foreign born MOE &y_lbl. );

	%Pct_calc( var=PctNativeBorn, label=% native born, num=PopNativeBorn, den=PopWithRace, years=&_years. )

    %Moe_prop_a( var=PctNativeBorn_m_&_years., mult=100, num=PopNativeBorn_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopNativeBorn_&_years., den_moe=mPopWithRace_&_years., label_moe = % native born MOE &y_lbl.);

    %Pct_calc( var=PctPopUnder18Years, label=% children, num=PopUnder18Years, den=PopWithRace, years= &_years. )
    
    %Moe_prop_a( var=PctPopUnder18Years_m_&_years., mult=100, num=PopUnder18Years_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopUnder18Years_&_years., den_moe=mPopWithRace_&_years., label_moe = % children MOE &y_lbl.);

	%Pct_calc( var=PctPop18_34Years, label=% persons 18-34 years old, num=Pop18_34Years, den=PopWithRace, years= &_years. )
	
	%Moe_prop_a( var=PctPop18_34Years_m_&_years., mult=100, num=Pop18_34Years_&_years., den=PopWithRace_&_years., 
	                       num_moe=mPop18_34Years_&_years., den_moe=mPopWithRace_&_years., label_moe = % persons 18-34 years old MOE &y_lbl.);

	%Pct_calc( var=PctPop35_64Years, label=% persons 35-64 years old, num=Pop35_64Years, den=PopWithRace, years= &_years. )
	
	%Moe_prop_a( var=PctPop35_64Years_m_&_years., mult=100, num=Pop35_64Years_&_years., den=PopWithRace_&_years., 
	                       num_moe=mPop35_64Years_&_years., den_moe=mPopWithRace_&_years., label_moe = % persons 35-64 years old MOE &y_lbl.);

	%Pct_calc( var=PctPop65andOverYears, label=% seniors, num=Pop65andOverYears, den=PopWithRace, years= &_years. )

    %Moe_prop_a( var=PctPop65andOverYrs_m_&_years., mult=100, num=Pop65andOverYears_&_years., den=PopWithRace_&_years., 
                       num_moe=mPop65andOverYears_&_years., den_moe=mPopWithRace_&_years., label_moe = % seniors MOE &y_lbl.);

    %Pct_calc( var=PctPopUnder18YearsW, label=% children NH-White, num=PopUnder18YearsW, den=PopWhiteNonHispBridge, years= &_years. )
    
    %Moe_prop_a( var=PctPopUnder18YearsW_m_&_years., mult=100, num=PopUnder18YearsW_&_years., den=PopWhiteNonHispBridge_&_years., 
                       num_moe=mPopUnder18YearsW_&_years., den_moe=mPopWhiteNonHispBridge_&_years., label_moe = % children NH-White MOE &y_lbl.);

	%Pct_calc( var=PctPop18_34YearsW, label=% persons 18-34 years old NH-White, num=Pop18_34YearsW, den=PopWhiteNonHispBridge, years= &_years. )
	
	%Moe_prop_a( var=PctPop18_34YearsW_m_&_years., mult=100, num=Pop18_34YearsW_&_years., den=PopWhiteNonHispBridge_&_years., 
	                       num_moe=mPop18_34YearsW_&_years., den_moe=mPopWhiteNonHispBridge_&_years., label_moe = % persons 18-34 years old NH-White MOE &y_lbl.);

	%Pct_calc( var=PctPop35_64YearsW, label=% persons 35-64 years old NH-White, num=Pop35_64YearsW, den=PopWhiteNonHispBridge, years= &_years. )
	
	%Moe_prop_a( var=PctPop35_64YearsW_m_&_years., mult=100, num=Pop35_64YearsW_&_years., den=PopWhiteNonHispBridge_&_years., 
	                       num_moe=mPop35_64YearsW_&_years., den_moe=mPopWhiteNonHispBridge_&_years., label_moe = % persons 35-64 years old NH-White MOE &y_lbl.);

	%Pct_calc( var=PctPop65andOverYearsW, label=% seniors NH-White, num=Pop65andOverYearsW, den=PopWhiteNonHispBridge, years= &_years. )

    %Moe_prop_a( var=PctPop65andOverYrsW_m_&_years., mult=100, num=Pop65andOverYearsW_&_years., den=PopWhiteNonHispBridge_&_years., 
                       num_moe=mPop65andOverYearsW_&_years., den_moe=mPopWhiteNonHispBridge_&_years., label_moe = % seniors NH-White MOE &y_lbl.);

	%Pct_calc( var=PctForeignBornW, label=% foreign born NH-White, num=PopForeignBornW, den=PopWhiteNonHispBridge, years=&_years. )

    %Moe_prop_a( var=PctForeignBornW_m_&_years., mult=100, num=PopForeignBornW_&_years., den=PopWhiteNonHispBridge_&_years., 
                       num_moe=mPopForeignBornW_&_years., den_moe=mPopWhiteNonHispBridge_&_years., label_moe = % foreign born NH-White MOE &y_lbl.);

	%do r=2 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let rname=%scan(&racename.,&r.," ");
	 
    %Pct_calc( var=PctPopUnder18Years&race., label=% children &rname., num=PopUnder18Years&race., den=PopAlone&race., years= &_years. )
    
    %Moe_prop_a( var=PctPopUnder18Years&race._m_&_years., mult=100, num=PopUnder18Years&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopUnder18Years&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % children &rname. MOE &y_lbl.);

	%Pct_calc( var=PctPop18_34Years&race., label=% persons 18-34 years old &rname., num=Pop18_34Years&race., den=PopAlone&race., years= &_years. )
	
	%Moe_prop_a( var=PctPop18_34Years&race._m_&_years., mult=100, num=Pop18_34Years&race._&_years., den=PopAlone&race._&_years., 
	                       num_moe=mPop18_34Years&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % persons 18-34 years old &rname. MOE &y_lbl.);

	%Pct_calc( var=PctPop35_64Years&race., label=% persons 35-64 years old &rname., num=Pop35_64Years&race., den=PopAlone&race., years= &_years. )
	
	%Moe_prop_a( var=PctPop35_64Years&race._m_&_years., mult=100, num=Pop35_64Years&race._&_years., den=PopAlone&race._&_years., 
	                       num_moe=mPop35_64Years&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % persons 35-64 years old &rname. MOE &y_lbl.);

	%Pct_calc( var=PctPop65andOverYears&race., label=% seniors &rname., num=Pop65andOverYears&race., den=PopAlone&race., years= &_years. )

    %Moe_prop_a( var=PctPop65andOverYrs&race._m_&_years., mult=100, num=Pop65andOverYears&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPop65andOverYears&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % seniors &rname. MOE &y_lbl.);

	%Pct_calc( var=PctForeignBorn&race., label=% foreign born &rname., num=PopForeignBorn&race., den=PopAlone&race., years=&_years. )

    %Moe_prop_a( var=PctForeignBorn&race._m_&_years., mult=100, num=PopForeignBorn&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopForeignBorn&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % foreign born &rname. MOE &y_lbl.);

	%end;



    
    ** Population by Race/Ethnicity **;
    
    %Pct_calc( var=PctBlackNonHispBridge, label=% black non-Hispanic, num=PopBlackNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=PctWhiteNonHispBridge, label=% white non-Hispanic, num=PopWhiteNonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=PctHisp, label=% Hispanic, num=PopHisp, den=PopWithRace, years=&_years. )
    %Pct_calc( var=PctAsnPINonHispBridge, label=% Asian/P.I. non-Hispanic, num=PopAsianPINonHispBridge, den=PopWithRace, years=&_years. )
    %Pct_calc( var=PctOtherRaceNonHispBridg, label=% All other than Black White Asian P.I. Hispanic, num=PopOtherRaceNonHispBridg, den=PopWithRace, years=&_years. )

    %Moe_prop_a( var=PctBlackNonHispBridge_m_&_years., mult=100, num=PopBlackNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopBlackNonHispBridge_&_years., den_moe=mPopWithRace_&_years., label_moe =% black non-Hispanic MOE &y_lbl.);

    %Moe_prop_a( var=PctWhiteNonHispBridge_m_&_years., mult=100, num=PopWhiteNonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopWhiteNonHispBridge_&_years., den_moe=mPopWithRace_&_years., label_moe =% white non-Hispanic MOE &y_lbl.);

    %Moe_prop_a( var=PctHisp_m_&_years., mult=100, num=PopHisp_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopHisp_&_years., den_moe=mPopWithRace_&_years., label_moe =% Hispanic MOE &y_lbl.);

	%Moe_prop_a( var=PctAsnPINonHispBridge_m_&_years., mult=100, num=PopAsianPINonHispBridge_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAsianPINonHispBridge_&_years., den_moe=mPopWithRace_&_years., label_moe =% Asian/P.I. non-Hispanic MOE &y_lbl.);

    %Moe_prop_a( var=PctOthRaceNonHispBridg_m_&_years., mult=100, num=PopOtherRaceNonHispBridg_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopOtherRaceNonHispBr_&_years., den_moe=mPopWithRace_&_years., label_moe =% All other than Black White Asian P.I. Hispanic MOE &y_lbl.);

	** Population by race/ethnicity alone**; 

    %Pct_calc( var=PctAloneB, label=% black alone, num=PopAloneB, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneW, label=% white alone, num=PopAloneW, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneH, label=% Hispanic alone, num=PopAloneH, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneA, label=% Asian/P.I. alone, num=PopAloneA, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneI, label=% Indigenous alone, num=PopAloneI, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneO, label=% Other race alone, num=PopAloneO, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneM, label=% Multiracial alone, num=PopAloneM, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneIOM, label=% Indigienous-other-multi-alone, num=PopAloneIOM, den=PopWithRace, years=&_years. )
	%Pct_calc( var=PctAloneAIOM, label=% All other than Black-White-Hispanic, num=PopAloneAIOM, den=PopWithRace, years=&_years. )

	%Moe_prop_a( var=PctAloneB_m_&_years., mult=100, num=PopAloneB_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneB_&_years., den_moe=mPopWithRace_&_years., label_moe =% black alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneW_m_&_years., mult=100, num=PopAloneW_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneW_&_years., den_moe=mPopWithRace_&_years., label_moe =% white alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneH_m_&_years., mult=100, num=PopAloneH_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneH_&_years., den_moe=mPopWithRace_&_years., label_moe =% Hispanic alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneA_m_&_years., mult=100, num=PopAloneA_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneA_&_years., den_moe=mPopWithRace_&_years., label_moe =% Asian/P.I. alone MOE &y_lbl.);
					   
	%Moe_prop_a( var=PctAloneI_m_&_years., mult=100, num=PopAloneI_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneI_&_years., den_moe=mPopWithRace_&_years., label_moe =% Indigenous alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneO_m_&_years., mult=100, num=PopAloneO_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneO_&_years., den_moe=mPopWithRace_&_years., label_moe =% Other race alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneM_m_&_years., mult=100, num=PopAloneM_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneM_&_years., den_moe=mPopWithRace_&_years., label_moe =% Multiracial alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneIOM_m_&_years., mult=100, num=PopAloneIOM_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneIOM_&_years., den_moe=mPopWithRace_&_years., label_moe =% Indigenous-other-multi-alone MOE &y_lbl.);

	%Moe_prop_a( var=PctAloneAIOM_m_&_years., mult=100, num=PopAloneAIOM_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopAloneAIOM_&_years., den_moe=mPopWithRace_&_years., label_moe =% All other than Black-White-Hispanic MOE &y_lbl.);


	** Family Risk Factors **;

	%Pct_calc( var=PctOthLang, label=% pop. that speaks a language other than English at home, num=PopNonEnglish, den=Pop5andOverYears, years=&_years. )

	%Moe_prop_a( var=PctOthLang_m_&_years., mult=100, num=PopNonEnglish_&_years., den=Pop5andOverYears_&_years., 
	                       num_moe=mPopNonEnglish_&_years., den_moe=mPop5andOverYears_&_years., label_moe = % pop. that speaks a language other than English at home MOE &y_lbl.);

	%Pct_calc( var=PctPoorPersons, label=Poverty rate (%), num=PopPoorPersons, den=PersonsPovertyDefined, years=&_years. )
	%Pct_calc( var=PctPoorPersonsB, label=Poverty rate Black-Alone (%), num=PopPoorPersonsB, den=PersonsPovertyDefinedB, years=&_years. )
	%Pct_calc( var=PctPoorPersonsW, label=Poverty rate NH-White (%), num=PopPoorPersonsW, den=PersonsPovertyDefinedW, years=&_years. )
	%Pct_calc( var=PctPoorPersonsH, label=Poverty rate Hispanic(%), num=PopPoorPersonsH, den=PersonsPovertyDefinedH, years=&_years. )
    %Pct_calc( var=PctPoorPersonsA, label=Poverty rate Asian-Pacific Islander(%), num=PopPoorPersonsA, den=PersonsPovertyDefinedA, years=&_years. )
	%Pct_calc( var=PctPoorPersonsIOM, label=Poverty rate Indigenous-Other-Multi race(%), num=PopPoorPersonsIOM, den=PersonsPovertyDefIOM, years=&_years. )
	%Pct_calc( var=PctPoorPersonsAIOM, label=Poverty rate All-Other(%), num=PopPoorPersonsAIOM, den=PersonsPovertyDefAIOM, years=&_years. )
	%Pct_calc( var=PctPoorPersonsFB, label=Poverty rate foreign born (%), num=PopPoorPersonsFB, den=PersonsPovertyDefinedFB, years=&_years. )
    
	%Moe_prop_a( var=PctPoorPersons_m_&_years., mult=100, num=PopPoorPersons_&_years., den=PersonsPovertyDefined_&_years., 
                       num_moe=mPopPoorPersons_&_years., den_moe=mPersonsPovertyDefined_&_years., label_moe =Poverty rate (%) MOE &y_lbl.);

    %Moe_prop_a( var=PctPoorPersonsB_m_&_years., mult=100, num=PopPoorPersonsB_&_years., den=PersonsPovertyDefinedB_&_years., 
                       num_moe=mPopPoorPersonsB_&_years., den_moe=mPersonsPovertyDefinedB_&_years., label_moe =Poverty rate Black-Alone (%) MOE &y_lbl.);

    %Moe_prop_a( var=PctPoorPersonsW_m_&_years., mult=100, num=PopPoorPersonsW_&_years., den=PersonsPovertyDefinedW_&_years., 
                       num_moe=mPopPoorPersonsW_&_years., den_moe=mPersonsPovertyDefinedW_&_years., label_moe =Poverty rate NH-White (%) MOE &y_lbl.);

    %Moe_prop_a( var=PctPoorPersonsH_m_&_years., mult=100, num=PopPoorPersonsH_&_years., den=PersonsPovertyDefinedH_&_years., 
                       num_moe=mPopPoorPersonsH_&_years., den_moe=mPersonsPovertyDefinedH_&_years., label_moe =Poverty rate Hispanic(%) MOE &y_lbl.);

    %Moe_prop_a( var=PctPoorPersonsA_m_&_years., mult=100, num=PopPoorPersonsA_&_years., den=PersonsPovertyDefinedA_&_years., 
                       num_moe=mPopPoorPersonsA_&_years., den_moe=mPersonsPovertyDefinedA_&_years., label_moe =Poverty rate Asian-Pacific Islander(%) MOE &y_lbl.);

	%Moe_prop_a( var=PctPoorPersonsIOM_m_&_years., mult=100, num=PopPoorPersonsIOM_&_years., den=PersonsPovertyDefIOM_&_years., 
                       num_moe=mPopPoorPersonsIOM_&_years., den_moe=mPersonsPovertyDefIOM_&_years., label_moe =Poverty rate Indigenous-Other-Multi race(%) MOE &y_lbl.);

	%Moe_prop_a( var=PctPoorPersonsAIOM_m_&_years., mult=100, num=PopPoorPersonsAIOM_&_years., den=PersonsPovertyDefAIOM_&_years., 
                       num_moe=mPopPoorPersonsAIOM_&_years., den_moe=mPersonsPovertyDefAIOM_&_years., label_moe =Poverty rate All-Other(%) MOE &y_lbl.);

	%Moe_prop_a( var=PctPoorPersonsFB_m_&_years., mult=100, num=PopPoorPersonsFB_&_years., den=PersonsPovertyDefinedFB_&_years., 
                       num_moe=mPopPoorPersonsFB_&_years., den_moe=mPersonsPovertyDefinedFB_&_years., label_moe =Poverty rate foreign born (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployed, label=Unemployment rate (%), num=PopUnemployed, den=PopInCivLaborForce, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_m_&_years., mult=100, num=PopUnemployed_&_years., den=PopInCivLaborForce_&_years., 
	                       num_moe=mPopUnemployed_&_years., den_moe=mPopInCivLaborForce_&_years., label_moe =Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctEmployed16to64, label=% persons employed between 16 and 64 years old, num=Pop16_64Employed, den=Pop16_64years, years=&_years. )

	%Moe_prop_a( var=PctEmployed16to64_m_&_years., mult=100, num=Pop16_64Employed_&_years., den=Pop16_64years_&_years., 
                       num_moe=mPop16_64Employed_&_years., den_moe=mPop16_64years_&_years., label_moe =% persons employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=Pct16plusEmploy, label=% pop. 16+ yrs. employed, num=Pop16andOverEmploy, den=Pop16andOverYears, years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy_m_&_years., mult=100, num=Pop16andOverEmploy_&_years., den=Pop16andOverYears_&_years., 
                       num_moe=mPop16andOverEmploy_&_years., den_moe=mPop16andOverYears_&_years., label_moe =% pop. 16+ yrs. employed MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWages, label=% persons employed with earnings, num=PopWorkEarn, den=Pop16andOverYears, years=&_years. )

	%Moe_prop_a( var=Pct16plusWages_m_&_years., mult=100, num=PopWorkEarn_&_years., den=Pop16andOverYears_&_years., 
                       num_moe=mPopWorkEarn_&_years., den_moe=mPop16andOverYears_&_years., label_moe =% persons employed with earnings MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWorkFT, label=% persons employed full time, num=PopWorkFT, den=Pop16andOverYears, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT_m_&_years., mult=100, num=PopWorkFT_&_years., den=Pop16andOverYears_&_years., 
                       num_moe=mPopWorkFT_&_years., den_moe=mPop16andOverYears_&_years., label_moe =% persons employed full time MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k, label=% persons employed full time with earnings less than 35000, num=PopWorkFTLT35K, den=PopWorkFT, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k_m_&_years., mult=100, num=PopWorkFTLT35k_&_years., den=PopWorkFT_&_years., 
                       num_moe=mPopWorkFTLT35k_&_years., den_moe=mPopWorkFT_&_years., label_moe =% persons employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k, label=% persons employed full time with earnings less than 75000, num=PopWorkFTLT75k, den=PopWorkFT, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k_m_&_years., mult=100, num=PopWorkFTLT75k_&_years., den=PopWorkFT_&_years., 
                       num_moe=mPopWorkFTLT75k_&_years., den_moe=mPopWorkFT_&_years., label_moe =% persons employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctEmpMngmt, label=% persons 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt_m_&_years., mult=100, num=PopEmployedMngmt_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedMngmt_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedServ, label=% persons 16+ years old employed in service occupations, num=PopEmployedServ, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpServ_m_&_years., mult=100, num=PopEmployedServ_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedServ_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales, label=% persons 16+ years old employed in sales and office occupations, num=PopEmployedSales, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpSales_m_&_years., mult=100, num=PopEmployedSales_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedSales_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedNatRes, label=% persons 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes_m_&_years., mult=100, num=PopEmployedNatRes_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedNatRes_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd, label=% persons employed in production transportation and material moving occupations, num=PopEmployedProd, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpProd_m_&_years., mult=100, num=PopEmployedProd_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedProd_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons employed in production transportation and material moving occupations MOE &y_lbl.);

/*gender breakout for employment*/


	%Pct_calc( var=PctEmp16to64_ML, label=% Male employed between 16 and 64 years old, num=Pop16_64Employed_M, den=Pop16_64years_M, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64_ML_m_&_years., mult=100, num=Pop16_64Employed_M_&_years., den=Pop16_64years_M_&_years., 
                       num_moe=mPop16_64Employed_M_&_years., den_moe=mPop16_64years_M_&_years., label_moe =% male employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=PctEmp16to64_F, label=% Female employed between 16 and 64 years old, num=Pop16_64Employed_F, den=Pop16_64years_F, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64_F_m_&_years., mult=100, num=Pop16_64Employed_F_&_years., den=Pop16_64years_F_&_years., 
                       num_moe=mPop16_64Employed_F_&_years., den_moe=mPop16_64years_F_&_years., label_moe =% female employed between 16 and 64 years old MOE &y_lbl.);


	%Pct_calc( var=PctWorkFTLT75k_ML, label=% male employed full time with earnings less than 75000, num=PopWorkFTLT75k_M, den=PopWorkFT_M, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k_ML_m_&_years., mult=100, num=PopWorkFTLT75k_M_&_years., den=PopWorkFT_M_&_years., 
                       num_moe=mPopWorkFTLT75k_M_&_years., den_moe=mPopWorkFT_M_&_years., label_moe =% male employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k_F, label=% female employed full time with earnings less than 75000, num=PopWorkFTLT75k_F, den=PopWorkFT_F, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k_F_m_&_years., mult=100, num=PopWorkFTLT75k_F_&_years., den=PopWorkFT_F_&_years., 
                       num_moe=mPopWorkFTLT75k_F_&_years., den_moe=mPopWorkFT_F_&_years., label_moe =% female employed full time with earnings less than 75000 MOE &y_lbl.);


	%Pct_calc( var=PctWorkFTLT35k_ML, label=% male employed full time with earnings less than 35000, num=PopWorkFTLT35k_M, den=PopWorkFT_M, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k_ML_m_&_years., mult=100, num=PopWorkFTLT35k_M_&_years., den=PopWorkFT_M_&_years., 
                       num_moe=mPopWorkFTLT35k_M_&_years., den_moe=mPopWorkFT_M_&_years., label_moe =% male employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k_F, label=% female employed full time with earnings less than 35000, num=PopWorkFTLT35k_F, den=PopWorkFT_F, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k_F_m_&_years., mult=100, num=PopWorkFTLT35k_F_&_years., den=PopWorkFT_F_&_years., 
                       num_moe=mPopWorkFTLT35k_F_&_years., den_moe=mPopWorkFT_F_&_years., label_moe =% female employed full time with earnings less than 35000 MOE &y_lbl.);

    %Pct_calc( var=Pct16plusWorkFT_ML, label=% male employed full time, num=PopWorkFT_M, den=Pop16andOverYears_M, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT_ML_m_&_years., mult=100, num=PopWorkFT_M_&_years., den=Pop16andOverYears_M_&_years., 
                       num_moe=mPopWorkFT_M_&_years., den_moe=mPop16andOverYears_M_&_years., label_moe =% male employed full time MOE &y_lbl.);

   %Pct_calc( var=Pct16plusWorkFT_F, label=% female employed full time, num=PopWorkFT_F, den=Pop16andOverYears_F, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT_F_m_&_years., mult=100, num=PopWorkFT_F_&_years., den=Pop16andOverYears_F_&_years., 
                       num_moe=mPopWorkFT_F_&_years., den_moe=mPop16andOverYears_F_&_years., label_moe =% female employed full time MOE &y_lbl.);

   %Pct_calc( var=PctWorkEarn_ML, label=% male 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn_M, den=Pop16andOverYears_M, years=&_years. )

    %Moe_prop_a( var=PctWorkEarn_ML_m_&_years., mult=100, num=PopWorkEarn_M_&_years., den=Pop16andOverYears_M_&_years., 
                       num_moe=mPopWorkEarn_M_&_years., den_moe=mPop16andOverYears_M_&_years., label_moe =% male 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	%Pct_calc( var=PctWorkEarn_F, label=% female 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn_F, den=Pop16andOverYears_F, years=&_years. )

    %Moe_prop_a( var=PctWorkEarn_F_m_&_years., mult=100, num=PopWorkEarn_F_&_years., den=Pop16andOverYears_F_&_years., 
                       num_moe=mPopWorkEarn_F_&_years., den_moe=mPop16andOverYears_F_&_years., label_moe =% female 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	%Pct_calc( var=PctUnemployed_ML, label=Unemployment rate male (%), num=PopUnemployed_M, den=PopInCivLaborForce_M, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_ML_m_&_years., mult=100, num=PopUnemployed_M_&_years., den=PopInCivLaborForce_M_&_years., 
	                       num_moe=mPopUnemployed_M_&_years., den_moe=mPopInCivLaborForce_M_&_years., label_moe =Unemployment rate male (%) MOE &y_lbl.);

    %Pct_calc( var=PctUnemployed_F, label=Unemployment rate female (%), num=PopUnemployed_F, den=PopInCivLaborForce_F, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_F_m_&_years., mult=100, num=PopUnemployed_F_&_years., den=PopInCivLaborForce_F_&_years., 
	                       num_moe=mPopUnemployed_F_&_years., den_moe=mPopInCivLaborForce_F_&_years., label_moe =Unemployment rate female (%) MOE &y_lbl.);


	%Pct_calc( var=PctEmpMngmt_ML, label=% male 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt_M, den=PopEmployedByOcc_M, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt_ML_m_&_years., mult=100, num=PopEmployedMngmt_M_&_years., den=PopEmployedByOcc_M_&_years., 
                       num_moe=mPopEmployedMngmt_M_&_years., den_moe=mPopEmployedByOcc_M_&_years., label_moe =% male 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ_ML, label=% male 16+ years old employed in service occupations, num=PopEmployedServ_M, den=PopEmployedByOcc_M, years=&_years. )

	%Moe_prop_a( var=PctEmpServ_ML_m_&_years., mult=100, num=PopEmployedServ_M_&_years., den=PopEmployedByOcc_M_&_years., 
                       num_moe=mPopEmployedServ_M_&_years., den_moe=mPopEmployedByOcc_M_&_years., label_moe =% male 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales_ML, label=% male 16+ years old employed in sales and office occupations, num=PopEmployedSales_M, den=PopEmployedByOcc_M, years=&_years. )

	%Moe_prop_a( var=PctEmpSales_ML_m_&_years., mult=100, num=PopEmployedSales_M_&_years., den=PopEmployedByOcc_M_&_years., 
                       num_moe=mPopEmployedSales_M_&_years., den_moe=mPopEmployedByOcc_M_&_years., label_moe =% male 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes_ML, label=% male 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes_M, den=PopEmployedByOcc_M, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes_ML_m_&_years., mult=100, num=PopEmployedNatRes_M_&_years., den=PopEmployedByOcc_M_&_years., 
                       num_moe=mPopEmployedNatRes_M_&_years., den_moe=mPopEmployedByOcc_M_&_years., label_moe =% male 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd_ML, label=% male employed in production transportation and material moving occupations, num=PopEmployedProd_M, den=PopEmployedByOcc_M, years=&_years. )

	%Moe_prop_a( var=PctEmpProd_ML_m_&_years., mult=100, num=PopEmployedProd_M_&_years., den=PopEmployedByOcc_M_&_years., 
                       num_moe=mPopEmployedProd_M_&_years., den_moe=mPopEmployedByOcc_M_&_years., label_moe =% male employed in production transportation and material moving occupations MOE &y_lbl.);

    %Pct_calc( var=PctEmpMngmt_F, label=% female 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt_F, den=PopEmployedByOcc_F, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt_F_m_&_years., mult=100, num=PopEmployedMngmt_F_&_years., den=PopEmployedByOcc_F_&_years., 
                       num_moe=mPopEmployedMngmt_F_&_years., den_moe=mPopEmployedByOcc_F_&_years., label_moe =% female 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ_F, label=% female 16+ years old employed in service occupations, num=PopEmployedServ_F, den=PopEmployedByOcc_F, years=&_years. )

	%Moe_prop_a( var=PctEmpServ_F_m_&_years., mult=100, num=PopEmployedServ_F_&_years., den=PopEmployedByOcc_F_&_years., 
                       num_moe=mPopEmployedServ_F_&_years., den_moe=mPopEmployedByOcc_F_&_years., label_moe =% female 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales_F, label=% female 16+ years old employed in sales and office occupations, num=PopEmployedSales_F, den=PopEmployedByOcc_F, years=&_years. )

	%Moe_prop_a( var=PctEmpSales_F_m_&_years., mult=100, num=PopEmployedSales_F_&_years., den=PopEmployedByOcc_F_&_years., 
                       num_moe=mPopEmployedSales_F_&_years., den_moe=mPopEmployedByOcc_F_&_years., label_moe =% female 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes_F, label=% female 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes_F, den=PopEmployedByOcc_F, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes_F_m_&_years., mult=100, num=PopEmployedNatRes_F_&_years., den=PopEmployedByOcc_F_&_years., 
                       num_moe=mPopEmployedNatRes_F_&_years., den_moe=mPopEmployedByOcc_F_&_years., label_moe =% female 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd_F, label=% female employed in production transportation and material moving occupations, num=PopEmployedProd_F, den=PopEmployedByOcc_F, years=&_years. )

	%Moe_prop_a( var=PctEmpProd_F_m_&_years., mult=100, num=PopEmployedProd_F_&_years., den=PopEmployedByOcc_F_&_years., 
                       num_moe=mPopEmployedProd_F_&_years., den_moe=mPopEmployedByOcc_F_&_years., label_moe =% female employed in production transportation and material moving occupations MOE &y_lbl.);



	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let rname=%scan(&racename.,&r.," ");
		 
	%Pct_calc( var=PctUnemployed&race., label=&rname. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._m_&_years., mult=100, num=PopUnemployed&race._&_years., den=PopInCivLaborForce&race._&_years., 
	                       num_moe=mPopUnemployed&race._&_years., den_moe=mPopInCivLaborForce&race._&_years., label_moe =&rname. Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctEmployed16to64&race., label=% persons &rname. employed between 16 and 64 years old, num=Pop16_64Employed&race., den=Pop16_64years&race., years=&_years. )

	%Moe_prop_a( var=PctEmployed16to64&race._m_&_years., mult=100, num=Pop16_64Employed&race._&_years., den=Pop16_64years&race._&_years., 
                       num_moe=mPop16_64Employed&race._&_years., den_moe=mPop16_64years&race._&_years., label_moe =% persons &rname. employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=Pct16plusEmploy&race., label=% pop. 16+ yrs. employed &rname., num=Pop16andOverEmploy&race., den=Pop16andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy&race._m_&_years., mult=100, num=Pop16andOverEmploy&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPop16andOverEmploy&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% pop. 16+ yrs. employed &rname. MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWages&race., label=% persons &rname. employed with earnings, num=PopWorkEarn&race., den=Pop16andOverYears&race., years=&_years. )

	%Moe_prop_a( var=Pct16plusWages&race._m_&_years., mult=100, num=PopWorkEarn&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPopWorkEarn&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% persons &rname. employed with earnings MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWorkFT&race., label=% persons &rname. employed full time, num=PopWorkFT&race., den=Pop16andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT&race._m_&_years., mult=100, num=PopWorkFT&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPopWorkFT&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% persons &rname. employed full time MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race., label=% persons &rname. employed full time with earnings less than 35000, num=PopWorkFTLT35K&race., den=PopWorkFT&race., years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._m_&_years., mult=100, num=PopWorkFTLT35k&race._&_years., den=PopWorkFT&race._&_years., 
                       num_moe=mPopWorkFTLT35k&race._&_years., den_moe=mPopWorkFT&race._&_years., label_moe =% persons &rname. employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k&race., label=% persons &rname. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race., den=PopWorkFT&race., years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._m_&_years., mult=100, num=PopWorkFTLT75k&race._&_years., den=PopWorkFT&race._&_years., 
                       num_moe=mPopWorkFTLT75k&race._&_years., den_moe=mPopWorkFT&race._&_years., label_moe =% persons &rname. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctEmpMngmt&race., label=% persons &rname. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt&race._m_&_years., mult=100, num=PopEmployedMngmt&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedMngmt&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &rname. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ&race., label=% persons &rname. 16+ years old employed in service occupations, num=PopEmployedServ&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpServ&race._m_&_years., mult=100, num=PopEmployedServ&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedServ&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &rname. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales&race., label=% persons &rname. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpSales&race._m_&_years., mult=100, num=PopEmployedSales&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedSales&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &rname. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes&race., label=% persons &rname. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes&race._m_&_years., mult=100, num=PopEmployedNatRes&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedNatRes&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &rname. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd&race., label=% persons &rname. employed in production transportation and material moving occupations, num=PopEmployedProd&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpProd&race._m_&_years., mult=100, num=PopEmployedProd&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedProd&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &rname. employed in production transportation and material moving occupations MOE &y_lbl.);

/*gender breakout for employment*/
	%Pct_calc( var=PctEmp16to64&race._ML, label=% Male &rname. employed between 16 and 64 years old, num=Pop16_64Employed&race._M, den=Pop16_64years&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64&race._ML_m_&_years., mult=100, num=Pop16_64Employed&race._M_&_years., den=Pop16_64years&race._M_&_years., 
                       num_moe=mPop16_64Employed&race._M_&_years., den_moe=mPop16_64years&race._M_&_years., label_moe =% male &rname. employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=PctEmp16to64&race._F, label=% Female &rname. employed between 16 and 64 years old, num=Pop16_64Employed_F, den=Pop16_64years_F, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64&race._F_m_&_years., mult=100, num=Pop16_64Employed&race._F_&_years., den=Pop16_64years&race._F_&_years., 
                       num_moe=mPop16_64Employed&race._F_&_years., den_moe=mPop16_64years&race._F_&_years., label_moe =% female &rname. employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k&race._ML, label=% male &race. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race._M, den=PopWorkFT&race._M, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._ML_m_&_years., mult=100, num=PopWorkFTLT75k&race._M_&_years., den=PopWorkFT&race._M_&_years., 
                       num_moe=mPopWorkFTLT75k&race._M_&_years., den_moe=mPopWorkFT&race._M_&_years., label_moe =% male &race. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k&race._F, label=% female &race. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race._F, den=PopWorkFT&race._F, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._F_m_&_years., mult=100, num=PopWorkFTLT75k&race._F_&_years., den=PopWorkFT&race._F_&_years., 
                       num_moe=mPopWorkFTLT75k&race._F_&_years., den_moe=mPopWorkFT&race._F_&_years., label_moe =% female &race. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race._ML, label=% male &race. employed full time with earnings less than 35000, num=PopWorkFTLT35k&race._M, den=PopWorkFT&race._M, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._ML_m_&_years., mult=100, num=PopWorkFTLT35k&race._M_&_years., den=PopWorkFT&race._M_&_years., 
                       num_moe=mPopWorkFTLT35k&race._M_&_years., den_moe=mPopWorkFT&race._M_&_years., label_moe =% male &race. employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race._F, label=% female &race. employed full time with earnings less than 35000, num=PopWorkFTLT35k&race._F, den=PopWorkFT&race._F, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._F_m_&_years., mult=100, num=PopWorkFTLT35k&race._F_&_years., den=PopWorkFT&race._F_&_years., 
                       num_moe=mPopWorkFTLT35k&race._F_&_years., den_moe=mPopWorkFT&race._F_&_years., label_moe =% female &race. employed full time with earnings less than 35000 MOE &y_lbl.);

   %Pct_calc( var=Pct16plusWorkFT&race._ML, label=% male &race. employed full time, num=PopWorkFT&race._M, den=Pop16andOverYears&race._M, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT&race._ML_m_&_years., mult=100, num=PopWorkFT&race._M_&_years., den=Pop16andOverYears&race._M_&_years., 
                       num_moe=mPopWorkFT&race._M_&_years., den_moe=mPop16andOverYears&race._M_&_years., label_moe =% male &race. employed full time MOE &y_lbl.);

   %Pct_calc( var=Pct16plusWorkFT&race._F, label=% female &race. employed full time, num=PopWorkFT&race._F, den=Pop16andOverYears&race._F, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT&race._F_m_&_years., mult=100, num=PopWorkFT&race._F_&_years., den=Pop16andOverYears&race._F_&_years., 
                       num_moe=mPopWorkFT&race._F_&_years., den_moe=mPop16andOverYears&race._F_&_years., label_moe =% female &race. employed full time MOE &y_lbl.);

 %Pct_calc( var=PctWorkEarn&race._ML, label=% male &race. 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn&race._M, den=Pop16andOverYears&race._M, years=&_years. )

    %Moe_prop_a( var=PctWorkEarn&race._ML_m_&_years., mult=100, num=PopWorkEarn&race._M_&_years., den=Pop16andOverYears&race._M_&_years., 
                       num_moe=mPopWorkEarn&race._M_&_years., den_moe=mPop16andOverYears&race._M_&_years., label_moe =% male &race. 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	%Pct_calc( var=PctWorkEarn&race._F, label=% female &race. 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn&race._F, den=Pop16andOverYears&race._F, years=&_years. )

    %Moe_prop_a( var=PctWorkEarn&race._F_m_&_years., mult=100, num=PopWorkEarn&race._F_&_years., den=Pop16andOverYears&race._F_&_years., 
                       num_moe=mPopWorkEarn&race._F_&_years., den_moe=mPop16andOverYears&race._F_&_years., label_moe =% female &race. 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	%Pct_calc( var=PctUnemployed&race._ML, label=Unemployment rate male &race. (%), num=PopUnemployed&race._M, den=PopInCivLaborFor&race._M, years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._ML_m_&_years., mult=100, num=PopUnemployed&race._M_&_years., den=PopInCivLaborFor&race._M_&_years., 
	                       num_moe=mPopUnemployed&race._M_&_years., den_moe=mPopInCivLaborFor&race._M_&_years., label_moe =Unemployment rate male &race. (%) MOE &y_lbl.);

    %Pct_calc( var=PctUnemployed&race._F, label=Unemployment rate female &race. (%), num=PopUnemployed&race._F, den=PopInCivLaborFor&race._F, years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._F_m_&_years., mult=100, num=PopUnemployed&race._F_&_years., den=PopInCivLaborFor&race._F_&_years., 
	                       num_moe=mPopUnemployed&race._F_&_years., den_moe=mPopInCivLaborFor&race._F_&_years., label_moe =Unemployment rate female &race. (%) MOE &y_lbl.);


	%Pct_calc( var=PctEmpMngmt&race._ML, label=% male &race. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt&race._ML_m_&_years., mult=100, num=PopEmployedMngmt&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedMngmt&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &race. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ&race._ML, label=% male &race. 16+ years old employed in service occupations, num=PopEmployedServ&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpServ&race._ML_m_&_years., mult=100, num=PopEmployedServ&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedServ&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &race. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales&race._ML, label=% male &race. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpSales&race._ML_m_&_years., mult=100, num=PopEmployedSales&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedSales&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &race. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes&race._ML, label=% male &race. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes&race._ML_m_&_years., mult=100, num=PopEmployedNatRes&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedNatRes&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &race. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd&race._ML, label=% male &race. employed in production transportation and material moving occupations, num=PopEmployedProd&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpProd&race._ML_m_&_years., mult=100, num=PopEmployedProd&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedProd&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &race. employed in production transportation and material moving occupations MOE &y_lbl.);

    %Pct_calc( var=PctEmpMngmt&race._F, label=% female &race. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt&race._F_m_&_years., mult=100, num=PopEmployedMngmt&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedMngmt&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &race. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ&race._F, label=% female &race. 16+ years old employed in service occupations, num=PopEmployedServ&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpServ&race._F_m_&_years., mult=100, num=PopEmployedServ&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedServ&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &race. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales&race._F, label=% female &race. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpSales&race._F_m_&_years., mult=100, num=PopEmployedSales&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedSales&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &race. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes&race._F, label=% female &race. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes&race._F_m_&_years., mult=100, num=PopEmployedNatRes&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedNatRes&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &race. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd&race._F, label=% female &race. employed in production transportation and material moving occupations, num=PopEmployedProd&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpProd&race._F_m_&_years., mult=100, num=PopEmployedProd&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedProd&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &race. employed in production transportation and material moving occupations MOE &y_lbl.);


	%end;


	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let rname=%scan(&racename.,&r.," ");

    %Pct_calc( var=Pct25andOverWoutHS&race., label=% persons &rname. without HS diploma, num=Pop25andOverWoutHS&race., den=Pop25andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct25andOverWoutHS&race._m_&_years., mult=100, num=Pop25andOverWoutHS&race._&_years., den=Pop25andOverYears&race._&_years., 
                       num_moe=mPop25andOverWoutHS&race._&_years., den_moe=mPop25andOverYears&race._&_years., label_moe =% persons &rname. without HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWHS&race., label=% persons &rname. with HS diploma, num=Pop25andOverWHS&race., den=Pop25andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct25andOverWHS&race._m_&_years., mult=100, num=Pop25andOverWHS&race._&_years., den=Pop25andOverYears&race._&_years., 
                       num_moe=mPop25andOverWHS&race._&_years., den_moe=mPop25andOverYears&race._&_years., label_moe =% persons &rname. with HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWSC&race., label=% persons &rname. with some college, num=Pop25andOverWSC&race., den=Pop25andOverYears&race., years=&_years. )

	%Moe_prop_a( var=Pct25andOverWSC&race._m_&_years., mult=100, num=Pop25andOverWSC&race._&_years., den=Pop25andOverYears&race._&_years., 
                       num_moe=mPop25andOverWSC&race._&_years., den_moe=mPop25andOverYears&race._&_years., label_moe =% persons &rname. with some college MOE &y_lbl.);

	%end;

	%Pct_calc( var=Pct25andOverWoutHS, label=% persons without HS diploma, num=Pop25andOverWoutHS, den=Pop25andOverYears, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWoutHS_m_&_years., mult=100, num=Pop25andOverWoutHS_&_years., den=Pop25andOverYears_&_years., 
                       num_moe=mPop25andOverWoutHS_&_years., den_moe=mPop25andOverYears_&_years., label_moe =% persons without HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWoutHSFB, label=% foreign born persons without HS diploma, num=Pop25andOverWoutHSFB, den=Pop25andOverYearsFB, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWoutHSFB_m_&_years., mult=100, num=Pop25andOverWoutHSFB_&_years., den=Pop25andOverYearsFB_&_years., 
                       num_moe=mPop25andOverWoutHSFB_&_years., den_moe=mPop25andOverYearsFB_&_years., label_moe =% foreign born persons without HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWoutHSNB, label=% native born persons without HS diploma, num=Pop25andOverWoutHSNB, den=Pop25andOverYearsNB, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWoutHSNB_m_&_years., mult=100, num=Pop25andOverWoutHSNB_&_years., den=Pop25andOverYearsNB_&_years., 
                       num_moe=mPop25andOverWoutHSNB_&_years., den_moe=mPop25andOverYearsNB_&_years., label_moe =% native born persons without HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWHS, label=% persons with HS diploma, num=Pop25andOverWHS, den=Pop25andOverYears, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWHS_m_&_years., mult=100, num=Pop25andOverWHS_&_years., den=Pop25andOverYears_&_years., 
                       num_moe=mPop25andOverWHS_&_years., den_moe=mPop25andOverYears_&_years., label_moe =% persons with HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWHSFB, label=% foreign born persons with HS diploma, num=Pop25andOverWHSFB, den=Pop25andOverYearsFB, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWHSFB_m_&_years., mult=100, num=Pop25andOverWHSFB_&_years., den=Pop25andOverYearsFB_&_years., 
                       num_moe=mPop25andOverWHSFB_&_years., den_moe=mPop25andOverYearsFB_&_years., label_moe =% foreign born persons with HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWHSNB, label=% native born persons with HS diploma, num=Pop25andOverWHSNB, den=Pop25andOverYearsNB, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWHSNB_m_&_years., mult=100, num=Pop25andOverWHSNB_&_years., den=Pop25andOverYearsNB_&_years., 
                       num_moe=mPop25andOverWHSNB_&_years., den_moe=mPop25andOverYearsNB_&_years., label_moe =% native born persons with HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWSC, label=% persons with some college, num=Pop25andOverWSC, den=Pop25andOverYears, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWSC_m_&_years., mult=100, num=Pop25andOverWSC_&_years., den=Pop25andOverYears_&_years., 
                       num_moe=mPop25andOverWSC_&_years., den_moe=mPop25andOverYears_&_years., label_moe =% persons with some college MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWSCFB, label=% foreign born persons with some college, num=Pop25andOverWSCFB, den=Pop25andOverYearsFB, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWSCFB_m_&_years., mult=100, num=Pop25andOverWSCFB_&_years., den=Pop25andOverYearsFB_&_years., 
                       num_moe=mPop25andOverWSCFB_&_years., den_moe=mPop25andOverYearsFB_&_years., label_moe =% foreign born persons with some college MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWSCNB, label=% native born persons with some college, num=Pop25andOverWSCNB, den=Pop25andOverYearsNB, years=&_years. )

	%Moe_prop_a( var=Pct25andOverWSCNB_m_&_years., mult=100, num=Pop25andOverWSCNB_&_years., den=Pop25andOverYearsNB_&_years., 
                       num_moe=mPop25andOverWSCNB_&_years., den_moe=mPop25andOverYearsNB_&_years., label_moe =% native born persons with some college MOE &y_lbl.);

    
   ** Child Well-Being Indicators **;
    
    %Pct_calc( var=PctPoorChildren, label=% children in poverty, num=PopPoorChildren, den=ChildrenPovertyDefined, years=&_years. )
		%Pct_calc( var=PctPoorChildrenB, label=% children Black-Alone in poverty, num=PopPoorChildrenB, den=ChildrenPovertyDefinedB, years=&_years. )
		%Pct_calc( var=PctPoorChildrenW, label=% children NH-White in poverty, num=PopPoorChildrenW, den=ChildrenPovertyDefinedW, years=&_years. )
		%Pct_calc( var=PctPoorChildrenA, label=% children Asian-Pacific Islander in poverty, num=PopPoorChildrenA, den=ChildrenPovertyDefinedA, years=&_years. )
		%Pct_calc( var=PctPoorChildrenH, label=% children Hispanic in poverty, num=PopPoorChildrenH, den=ChildrenPovertyDefinedH, years=&_years. )		
	    %Pct_calc( var=PctPoorChildrenIOM, label=% children Indigenous-Other-Multi race in poverty, num=PopPoorChildrenIOM, den=ChildrenPovertyDefIOM, years=&_years. )
		 %Pct_calc( var=PctPoorChildrenAIOM, label=% children All-Other in poverty, num=PopPoorChildrenAIOM, den=ChildrenPovertyDefAIOM, years=&_years. )

    %Moe_prop_a( var=PctPoorChildren_m_&_years., mult=100, num=PopPoorChildren_&_years., den=ChildrenPovertyDefined_&_years., 
                       num_moe=mPopPoorChildren_&_years., den_moe=mChildrenPovertyDefined_&_years., label_moe =% children in poverty MOE &y_lbl.);
       
	    %Moe_prop_a( var=PctPoorChildrenB_m_&_years., mult=100, num=PopPoorChildrenB_&_years., den=ChildrenPovertyDefinedB_&_years., 
	                       num_moe=mPopPoorChildrenB_&_years., den_moe=mChildrenPovertyDefinedB_&_years., label_moe =% children Black-Alone in poverty MOE &y_lbl.);

	    %Moe_prop_a( var=PctPoorChildrenW_m_&_years., mult=100, num=PopPoorChildrenW_&_years., den=ChildrenPovertyDefinedW_&_years., 
	                       num_moe=mPopPoorChildrenW_&_years., den_moe=mChildrenPovertyDefinedW_&_years., label_moe =% children NH-White in poverty MOE &y_lbl.);

	    %Moe_prop_a( var=PctPoorChildrenH_m_&_years., mult=100, num=PopPoorChildrenH_&_years., den=ChildrenPovertyDefinedH_&_years., 
	                       num_moe=mPopPoorChildrenH_&_years., den_moe=mChildrenPovertyDefinedH_&_years., label_moe =% children Hispanic in poverty MOE &y_lbl.);

	    %Moe_prop_a( var=PctPoorChildrenA_m_&_years., mult=100, num=PopPoorChildrenA_&_years., den=ChildrenPovertyDefinedA_&_years., 
	                       num_moe=mPopPoorChildrenA_&_years., den_moe=mChildrenPovertyDefinedA_&_years., label_moe =% children Asian-Pacific Islander in poverty MOE &y_lbl.);

		%Moe_prop_a( var=PctPoorChildrenIOM_m_&_years., mult=100, num=PopPoorChildrenIOM_&_years., den=ChildrenPovertyDefIOM_&_years., 
	                       num_moe=mPopPoorChildrenIOM_&_years., den_moe=mChildrenPovertyDefIOM_&_years., label_moe =% children Indigenous-Other-Multi race in poverty MOE &y_lbl.);
		%Moe_prop_a( var=PctPoorChildrenAIOM_m_&_years., mult=100, num=PopPoorChildrenAIOM_&_years., den=ChildrenPovertyDefAIOM_&_years., 
	                       num_moe=mPopPoorChildrenAIOM_&_years., den_moe=mChildrenPovertyDefAIOM_&_years., label_moe =% children All-Other in poverty MOE &y_lbl.);

        
    ** Income Conditions **;
    
	%Pct_calc( var=PctFamilyLT75000, label=% families with income less than 75000, num=FamIncomeLT75k, den=NumFamilies, years=&_years. )

    %Moe_prop_a( var=PctFamilyLT75000_m_&_years., mult=100, num=FamIncomeLT75k_&_years., den=NumFamilies_&_years., 
                       num_moe=mFamIncomeLT75k_&_years., den_moe=mNumFamilies_&_years., label_moe =% families with income less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctFamilyGT200000, label=% families with income greater than 200000, num=FamIncomeGT200k, den=NumFamilies, years=&_years. )

    %Moe_prop_a( var=PctFamilyGT200000_m_&_years., mult=100, num=FamIncomeGT200k_&_years., den=NumFamilies_&_years., 
                       num_moe=mFamIncomeGT200k_&_years., den_moe=mNumFamilies_&_years., label_moe =% families with income greater than 200000 MOE &y_lbl.);

	%Pct_calc( var=AvgHshldIncome, label=Average household income last year ($), num=AggHshldIncome, den=NumHshlds, mult=1, years=&_years. )

	%dollar_convert( AvgHshldIncome_&_years., AvgHshldIncAdj_&_years., 2015, &inc_dollar_yr )

    AvgHshldIncome_m_&_years. = 
      %Moe_ratio( num=AggHshldIncome_&_years., den=NumHshlds_&_years., 
                  num_moe=mAggHshldIncome_&_years., den_moe=mNumHshlds_&_years.);
                        
    %dollar_convert( AvgHshldIncome_m_&_years., AvgHshldIncAdj_m_&_years., 2015, &inc_dollar_yr )

	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let rname=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctFamilyLT75000&race., label=% families &rname. with income less than 75000, num=FamIncomeLT75k&race., den=NumFamilies&race., years=&_years. )

    %Moe_prop_a( var=PctFamilyLT75000&race._m_&_years., mult=100, num=FamIncomeLT75k&race._&_years., den=NumFamilies&race._&_years., 
                       num_moe=mFamIncomeLT75k&race._&_years., den_moe=mNumFamilies&race._&_years., label_moe =% families &rname. with income less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctFamilyGT200000&race., label=% families &rname. with income greater than 200000, num=FamIncomeGT200k&race., den=NumFamilies&race., years=&_years. )

    %Moe_prop_a( var=PctFamilyGT200000&race._m_&_years., mult=100, num=FamIncomeGT200k&race._&_years., den=NumFamilies&race._&_years., 
                       num_moe=mFamIncomeGT200k&race._&_years., den_moe=mNumFamilies&race._&_years., label_moe =% families &rname. with income greater than 200000 MOE &y_lbl.);

	%Pct_calc( var=AvgHshldIncome&race., label=Average household income last year &rname. ($), num=AggHshldIncome&race., den=NumHshlds&race., mult=1, years=&_years. )

	%dollar_convert( AvgHshldIncome&race._&_years., AvgHshldIncAdj&race._&_years., 2015, &inc_dollar_yr )

    AvgHshldIncome&race._m_&_years. = 
      %Moe_ratio( num=AggHshldIncome&race._&_years., den=NumHshlds&race._&_years., 
                  num_moe=mAggHshldIncome&race._&_years., den_moe=mNumHshlds&race._&_years.);
                        
    %dollar_convert( AvgHshldIncome&race._m_&_years., AvgHshldIncAdj&race._m_&_years., 2015, &inc_dollar_yr )

	%end;

	label
	  AvgHshldIncAdj_&_years. = "Average household income (adjusted), &y_lbl."
	  AvgHshldIncAdj_m_&_years. = "Average household income (adjusted) MOE, &y_lbl."
	  AvgHshldIncAdjB_&_years. = "Average household income (adjusted), Black/African American, &y_lbl."
	  AvgHshldIncAdjB_m_&_years. = "Average household income (adjusted), Black/African American MOE, &y_lbl."
	  AvgHshldIncAdjW_&_years. = "Average household income (adjusted), Non-Hispanic White, &y_lbl."
	  AvgHshldIncAdjW_m_&_years. = "Average household income (adjusted), Non-Hispanic White MOE, &y_lbl."
	  AvgHshldIncAdjH_&_years. = "Average household income (adjusted), Hispanic/Latino, &y_lbl."
	  AvgHshldIncAdjH_m_&_years. = "Average household income (adjusted), Hispanic/Latino MOE, &y_lbl."
	  AvgHshldIncAdjA_&_years. = "Average household income (adjusted), Asian-Pacific Islander, &y_lbl."
	  AvgHshldIncAdjA_m_&_years. = "Average household income (adjusted), Asian-Pacific Islander MOE, &y_lbl."
	  AvgHshldIncAdjIOM_&_years. = "Average household income (adjusted), Indigenous-Other-Multi race MOE, &y_lbl."
	  AvgHshldIncAdjIOM_m_&_years. = "Average household income (adjusted), Indigenous-Other-Multi race MOE, &y_lbl."
	  AvgHshldIncAdjAIOM_&_years. = "Average household income (adjusted), All remaining groups other than Black, Non-Hispanic White, Hispanic, &y_lbl."
	  AvgHshldIncAdjAIOM_m_&_years. = "Average household income (adjusted), All remaining groups other than Black, Non-Hispanic White, Hispanic MOE, &y_lbl."
	  AvgHshldIncome_m_&_years. = "Average household income, MOE, &y_lbl."
	  AvgHshldIncomeB_m_&_years. = "Average household income, Black/African American, MOE, &y_lbl."
	  AvgHshldIncomeW_m_&_years. = "Average household income, Non-Hispanic White, MOE, &y_lbl."
	  AvgHshldIncomeH_m_&_years. = "Average household income, Hispanic/Latino, MOE, &y_lbl."
	  AvgHshldIncomeA_m_&_years. = "Average household income, Asian-Pacific Islander, MOE, &y_lbl."
	  AvgHshldIncomeIOM_m_&_years. = "Average household income, Indigenous-Other-Multi race, MOE, &y_lbl."
      AvgHshldIncomeAIOM_m_&_years. = "Average household income, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &y_lbl.";

        

    ** Housing Conditions **;
    
    %Label_var_years( var=NumOccupiedHsgUnits, label=Occupied housing units, years=&_years. )

    %Pct_calc( var=PctVacantHsgUnitsForRent, label=Rental vacancy rate (%), num=NumVacantHsgUnitsForRent, den=NumRenterHsgUnits, years=&_years. )

	%Moe_prop_a( var=PctVacantHUForRent_m_&_years., mult=100, num=NumVacantHsgUnitsForRent_&_years., den=NumRenterHsgUnits_&_years., 
                       num_moe=mNumVacantHUForRent_&_years., den_moe=mNumRenterHsgUnits_&_years., label_moe =Rental vacancy rate (%) MOE &y_lbl.);

    %Pct_calc( var=PctOwnerOccupiedHU, label=Homeownership rate (%), num=NumOwnerOccupiedHU, den=NumOccupiedHsgUnits, years=&_years. )

    %Moe_prop_a( var=PctOwnerOccupiedHU_m_&_years., mult=100, num=NumOwnerOccupiedHU_&_years., den=NumOccupiedHsgUnits_&_years., 
                       num_moe=mNumOwnerOccupiedHU_&_years., den_moe=mNumOccupiedHsgUnits_&_years., label_moe =Homeownership rate (%) MOE &y_lbl.);

	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let rname=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctOwnerOccupiedHU&race., label=Homeownership rate &rname.(%), num=NumOwnerOccupiedHU&race., den=NumOccupiedHsgUnits&race., years=&_years. )

    
    %Moe_prop_a( var=PctOwnerOccupiedHU&race._m_&_years., mult=100, num=NumOwnerOccupiedHU&race._&_years., den=NumOccupiedHsgUnits&race._&_years., 
                       num_moe=mNumOwnerOccupiedHU&race._&_years., den_moe=mNumOccupiedHsgUnits&race._&_years., label_moe =Homeownership rate &rname.(%) MOE &y_lbl.);
    
   	%end;


	** Mobility **;
	%Pct_calc( var=PctMovedLastYear, label=% persons who moved in the last year, num=PopMovedLastYear, den=PopWithRace, years=&_years. )

	%Moe_prop_a( var=PctMovedLastYear_m_&_years., mult=100, num=PopMovedLastYear_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopMovedLastYear_&_years., den_moe=mPopWithRace_&_years., label_moe =% persons who moved in the last year MOE &y_lbl.);

	%Pct_calc( var=PctMovedDiffCnty, label=% persons who moved from a different county in the last year, num=PopMovedDiffCnty, den=PopWithRace, years=&_years. )

	%Moe_prop_a( var=PctMovedDiffCnty_m_&_years., mult=100, num=PopMovedDiffCnty_&_years., den=PopWithRace_&_years., 
                       num_moe=mPopMovedDiffCnty_&_years., den_moe=mPopWithRace_&_years., label_moe =% persons who moved from a different couny in the last year MOE &y_lbl.);

	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let rname=%scan(&racename.,&r.," ");

	%Pct_calc( var=PctMovedLastYear&race., label=% persons who moved in the last year &rname., num=PopMovedLastYear&race., den=PopAlone&race., years=&_years. )

	%Moe_prop_a( var=PctMovedLastYear&race._m_&_years., mult=100, num=PopMovedLastYear&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopMovedLastYear&race._&_years., den_moe=mPopAlone&race._&_years., label_moe =% persons who moved in the last year &rname. MOE &y_lbl.);

	%Pct_calc( var=PctMovedDiffCnty&race., label=% persons who moved from a different county in the last year &rname., num=PopMovedDiffCnty&race., den=PopAlone&race., years=&_years. )

	%Moe_prop_a( var=PctMovedDiffCnty&race._m_&_years., mult=100, num=PopMovedDiffCnty&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopMovedDiffCnty&race._&_years., den_moe=mPopAlone&race._&_years., label_moe =% persons who moved from a different county in the last year &rname. MOE &y_lbl.);

	%end;

    ** Create flag for generating profile **;
    
    if TotPop_tr_&_years. >= 100 then _make_profile = 1;
    else _make_profile = 0;
    
 
  run;

  %if &st = DC and &geodo = WD12 %then %do;
  data profile_acs_&_years._dc_regcd;
  	set Profile_acs_&_years._dc_wd12;
	rename Ward2012 = councildist;
  run;
  %end;

  
  ** Finalize data **;

  %if &st = DC and &geodo = WD12 %then %do;
	%Finalize_data_set( 
	data=profile_acs_&_years._dc_regcd,
	out=profile_acs_&_years._dc_regcd,
	outlib=Equity,
	label="DC Metro Area Equity Indicators by Race/Ethnicity, &_years.,DC &name.",
	sortby=councildist,
	restrictions=None,
	revisions=&revisions.
	)
  %end;

  %else %do; 
	%Finalize_data_set( 
		data=profile_acs_&_years._&state._&geo2.,
		out=profile_acs_&_years._&state._&geo2.,
		outlib=Equity,
		label="DC Metro Area Equity Indicators by Race/Ethnicity, &_years., &st. &name.",
		sortby=&geo.,
		restrictions=None,
		revisions=&revisions.
		)
	%end; 


%mend add_percents;

/** End Macro Definition **/

%add_percents(MD,county,regcnt); 
%add_percents(MD,councildist,regcd); 

%add_percents(VA,county,regcnt); 
%add_percents(VA,councildist,regcd); 

%add_percents(dc,county,regcnt); 
%add_percents(dc,ward2012,wd12);     

