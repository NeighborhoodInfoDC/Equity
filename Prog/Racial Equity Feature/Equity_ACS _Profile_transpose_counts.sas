/**************************************************************************
 Program:  Equity_ACS_profile_transpose_count.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey & S. Diby
 Created:  08/22/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Transposes calculated indicators for Equity profiles 
			   and merges calculated statistics for ACS data at different geographies. 
			   Counts only (not percentages). Based on Equity_ACS_profile_transpose program.
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let racelist=W B H AIOM;
%let racename= NH-White Black-Alone Hispanic All-Other;


proc transpose data=equity.profile_tabs_ACS_suppress out=equity.profile_tabs_ACS_count; 
	var PopWithRace: mPopWithRace:
		PopBlackNonHispBridge: mPopBlackNonHispBridge:
		PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
		PopHisp: mPopHisp:
		PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
		PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
		PopAloneB: mPopAloneB:
		PopAloneW: mPopAloneW:
		PopAloneH: mPopAloneH:
		PopAloneA_: mPopAloneA_:
		PopAloneI_: mPopAloneA_:
		PopAloneO: mPopAloneO:
		PopAloneM: mPopAloneM:
		PopAloneIOM: mPopAloneIOM: 
		PopAloneAIOM: mPopAloneAIOM:

		PopForeignBorn_: mPopForeignBorn_:
		PopNativeBorn: mPopNativeBorn:

		PopForeignBornB:	mPopForeignBornB:	
		PopForeignBornW:	mPopForeignBornW:	
		PopForeignBornH:	mPopForeignBornH:	
		PopForeignBornAIOM:	mPopForeignBornAIOM:	
				
		PopNonEnglish:	mPopNonEnglish:	
				
		PopUnder18Years_:	mPopUnder18Years_:	
		PopUnder18YearsW_:	mPopUnder18YearsW_:	
		PopUnder18YearsB_:	mPopUnder18YearsB_:	
		PopUnder18YearsH_:	mPopUnder18YearsH_:	
		PopUnder18YearsAIOM_:	mPopUnder18YearsAIOM_:	
				
		Pop18_34Years_:		mPop18_34Years_:	
		Pop18_34YearsW_:	mPop18_34YearsW_:	
		Pop18_34YearsB_:	mPop18_34YearsB_:	
		Pop18_34YearsH_:	mPop18_34YearsH_:	
		Pop18_34YearsAIOM_:	mPop18_34YearsAIOM_:	
				
		Pop35_64Years_:		mPop35_64Years_:	
		Pop35_64YearsW_:	mPop35_64YearsW_:	
		Pop35_64YearsB_:	mPop35_64YearsB_:	
		Pop35_64YearsH_:	mPop35_64YearsH_:	
		Pop35_64YearsAIOM_:	mPop35_64YearsAIOM_:	
				
		Pop65andOverYears_:	mPop65andOverYears_:	
		Pop65andOverYearsW:	mPop65andOverYearsW:	
		Pop65andOverYearsB:	mPop65andOverYearsB:	
		Pop65andOverYearsH:	mPop65andOverYearsH:	
		Pop65andOverYearsAIOM:	mPop65andOverYearsAIOM:	
		
		Pop25andOverYears_: 	mPop25andOverYears_:
		Pop25andOverYearsW: 	mPop25andOverYearsW:
		Pop25andOverYearsB: 	mPop25andOverYearsB:
		Pop25andOverYearsH: 	mPop25andOverYearsH:
		Pop25andOverYearsAIOM: 	mPop25andOverYearsAIOM:
		Pop25andOverYearsFB: 	mPop25andOverYearsFB:
		Pop25andOverYearsNB: 	mPop25andOverYearsNB:

		Pop25andOverWoutHS_:	mPop25andOverWoutHS_:	
		Pop25andOverWoutHSW:	mPop25andOverWoutHSW:	Gap25andOverWoutHSW:
		Pop25andOverWoutHSB:	mPop25andOverWoutHSB:	Gap25andOverWoutHSB:
		Pop25andOverWoutHSH:	mPop25andOverWoutHSH:	Gap25andOverWoutHSH:
		Pop25andOverWoutHSAIOM:	mPop25andOverWoutHSAIOM:	Gap25andOverWoutHSAIOM:
		Pop25andOverWoutHSFB:	mPop25andOverWoutHSFB:	Gap25andOverWoutHSFB:
		Pop25andOverWoutHSNB:	mPop25andOverWoutHSNB:	Gap25andOverWoutHSNB:
				
		Pop25andOverWHS_:	mPop25andOverWHS_:	
		Pop25andOverWHSW:	mPop25andOverWHSW:	Gap25andOverWHSW:
		Pop25andOverWHSB:	mPop25andOverWHSB:	Gap25andOverWHSB:
		Pop25andOverWHSH:	mPop25andOverWHSH:	Gap25andOverWHSH:
		Pop25andOverWHSAIOM:	mPop25andOverWHSAIOM:	Gap25andOverWHSAIOM:
		Pop25andOverWHSFB:	mPop25andOverWHSFB:	Gap25andOverWHSFB:
		Pop25andOverWHSNB:	mPop25andOverWHSNB:	Gap25andOverWHSNB:
				
		Pop25andOverWSC_:	mPop25andOverWSC_:	
		Pop25andOverWSCW:	mPop25andOverWSCW:	Gap25andOverWSCW:
		Pop25andOverWSCB:	mPop25andOverWSCB:	Gap25andOverWSCB:
		Pop25andOverWSCH:	mPop25andOverWSCH:	Gap25andOverWSCH:
		Pop25andOverWSCAIOM:	mPop25andOverWSCAIOM:	Gap25andOverWSCAIOM:
		Pop25andOverWSCFB:	mPop25andOverWSCFB:	Gap25andOverWSCFB:
		Pop25andOverWSCNB:	mPop25andOverWSCNB:	Gap25andOverWSCNB:
				
		NumHshlds_: mNumHshlds_:
		NumHshldsW: mNumHshldsW:
		NumHshldsB: mNumHshldsB:
		NumHshldsH: mNumHshldsH:
		NumHshldsAIOM: mNumHshldsAIOM:

		AvgHshldIncAdj_:		
		AvgHshldIncAdjW:	GapAvgHshldIncAdjW:
		AvgHshldIncAdjB:	GapAvgHshldIncAdjB:
		AvgHshldIncAdjH:	GapAvgHshldIncAdjH:
		AvgHshldIncAdjAIOM:	GapAvgHshldIncAdjAIOM:

		AvgHshldIncome_:	
		AvgHshldIncomeW:
		AvgHshldIncomeB:
		AvgHshldIncomeH:
		AvgHshldIncomeAIOM:

		AggHshldIncome_:	mAggHshldIncome_:	
		AggHshldIncomeW:	mAggHshldIncomeW:	
		AggHshldIncomeB:	mAggHshldIncomeB:	
		AggHshldIncomeH:	mAggHshldIncomeH:	
		AggHshldIncomeAIOM:	mAggHshldIncomeAIOM:	
		
		NumFamilies_: mNumFamilies_:
		NumFamiliesW: mNumFamiliesW:
		NumFamiliesB: mNumFamiliesB:
		NumFamiliesH: mNumFamiliesH:
		NumFamiliesAIOM: mNumFamiliesAIOM:

		FamIncomeGT200k_:	mFamIncomeGT200k_:	
		FamIncomeGT200kW:	mFamIncomeGT200kW:	GapFamilyGT200000W:
		FamIncomeGT200kB:	mFamIncomeGT200kB:	GapFamilyGT200000B:
		FamIncomeGT200kH:	mFamIncomeGT200kH:	GapFamilyGT200000H:
		FamIncomeGT200kAIOM:	mFamIncomeGT200kAIOM:	GapFamilyGT200000AIOM:
				
		FamIncomeLT75k_:	mFamIncomeLT75k_:	
		FamIncomeLT75kW:	mFamIncomeLT75kW:	GapFamilyLT75000W:
		FamIncomeLT75kB:	mFamIncomeLT75kB:	GapFamilyLT75000B:
		FamIncomeLT75kH:	mFamIncomeLT75kH:	GapFamilyLT75000H:
		FamIncomeLT75kAIOM:	mFamIncomeLT75kAIOM:	GapFamilyLT75000AIOM:
		
		PersonsPovertyDefined_: mPersonsPovertyDefined_:
		PersonsPovertyDefinedB: mPersonsPovertyDefinedB:
		PersonsPovertyDefinedW: mPersonsPovertyDefinedW:
		PersonsPovertyDefinedH: mPersonsPovertyDefinedH:
		PersonsPovertyDefAIOM: mPersonsPovertyDefAIOM:
		PersonsPovertyDefinedFB: mPersonsPovertyDefinedFB:

		PopPoorPersons_:	mPopPoorPersons_:	
		PopPoorPersonsW:	mPopPoorPersonsW:	GapPoorPersonsW:
		PopPoorPersonsB:	mPopPoorPersonsB:	GapPoorPersonsB:
		PopPoorPersonsH:	mPopPoorPersonsH:	GapPoorPersonsH:
		PopPoorPersonsAIOM:	mPopPoorPersonsAIOM:	GapPoorPersonsAIOM:
		PopPoorPersonsFB:	mPopPoorPersonsFB:	GapPoorPersonsFB:
		
		ChildrenPovertyDefined_: mChildrenPovertyDefined_:
		ChildrenPovertyDefinedB: mChildrenPovertyDefinedB:
		ChildrenPovertyDefinedW: mChildrenPovertyDefinedW:
		ChildrenPovertyDefinedH: mChildrenPovertyDefinedH:
		ChildrenPovertyDefAIOM: mChildrenPovertyDefAIOM:

		PopPoorChildren_:	mPopPoorChildren_:	
		PopPoorChildrenW:	mPopPoorChildrenW:	
		PopPoorChildrenB:	mPopPoorChildrenB:	
		PopPoorChildrenH:	mPopPoorChildrenH:	
		PopPoorChildrenAIOM:	mPopPoorChildrenAIOM:	
		
		PopInCivLaborForce_: mPopInCivLaborForce_:
		PopInCivLaborForceW: mPopInCivLaborForceW:
		PopInCivLaborForceB: mPopInCivLaborForceB:
		PopInCivLaborForceH: mPopInCivLaborForceH:
		PopInCivLaborForceAIOM: mPopInCivLaborForceAIOM:

		Pop16andOverEmploy_:	mPop16andOverEmploy_:	
		Pop16andOverEmployW:	mPop16andOverEmployW:	Gap16andOverEmployW:
		Pop16andOverEmployB:	mPop16andOverEmployB:	Gap16andOverEmployB:
		Pop16andOverEmployH:	mPop16andOverEmployH:	Gap16andOverEmployH:
		Pop16andOverEmployAIOM:	mPop16andOverEmployAIOM:	Gap16andOverEmployAIOM:

		Pop16_64years_: 			mPop16_64years_:
		Pop16_64yearsW: 		mPop16_64yearsW:
		Pop16_64yearsB: 		mPop16_64yearsB:
		Pop16_64yearsH: 		mPop16_64yearsH:
		Pop16_64yearsAIOM: 		mPop16_64yearsAIOM:

		Pop16_64Employed_:	mPop16_64Employed_:	
		Pop16_64EmployedW:	mPop16_64EmployedW:	GapEmployed16to64W:
		Pop16_64EmployedB:	mPop16_64EmployedB:	GapEmployed16to64B:
		Pop16_64EmployedH:	mPop16_64EmployedH:	GapEmployed16to64H:
		Pop16_64EmployedAIOM:	mPop16_64EmployedAIOM:	GapEmployed16to64AIOM:
			
		PopUnemployed_:	mPopUnemployed_:	
		PopUnemployedW:	mPopUnemployedW:	GapUnemployedW:
		PopUnemployedB:	mPopUnemployedB:	GapUnemployedB:
		PopUnemployedH:	mPopUnemployedH:	GapUnemployedH:
		PopUnemployedAIOM:	mPopUnemployedAIOM:	GapUnemployedAIOM:
		
		Pop16andOverYears_: 		mPop16andOverYears_:
		Pop16andOverYearsW: 		mPop16andOverYearsW:
		Pop16andOverYearsB: 		mPop16andOverYearsB:
		Pop16andOverYearsH: 		mPop16andOverYearsH:
		Pop16andOverYearsAIOM: 		mPop16andOverYearsAIOM:
	
		PopWorkEarn_:	mPopWorkEarn_:	
		PopWorkEarnW:	mPopWorkEarnW:	Gap16andOverWagesW:
		PopWorkEarnB:	mPopWorkEarnB:	Gap16andOverWagesB:
		PopWorkEarnH:	mPopWorkEarnH:	Gap16andOverWagesH:
		PopWorkEarnAIOM:	mPopWorkEarnAIOM:	Gap16andOverWagesAIOM:
					
		PopWorkFT_: 		mPopWorkFT_:
		PopWorkFTW: 		mPopWorkFTW:
		PopWorkFTB: 		mPopWorkFTB:
		PopWorkFTH: 		mPopWorkFTH:
		PopWorkFTAIOM: 		mPopWorkFTAIOM:
	
		PopWorkFTLT35k_:	mPopWorkFTLT35k_:	
		PopWorkFTLT35kW:	mPopWorkFTLT35kW:	GapWorkFTLT35kW:
		PopWorkFTLT35kB:	mPopWorkFTLT35kB:	GapWorkFTLT35kB:
		PopWorkFTLT35kH:	mPopWorkFTLT35kH:	GapWorkFTLT35kH:
		PopWorkFTLT35kAIOM:	mPopWorkFTLT35kAIOM:	GapWorkFTLT35kAIOM:
				
		PopWorkFTLT75k_:	mPopWorkFTLT75k_:	
		PopWorkFTLT75kW:	mPopWorkFTLT75kW:	GapWorkFTLT75kW:
		PopWorkFTLT75kB:	mPopWorkFTLT75kB:	GapWorkFTLT75kB:
		PopWorkFTLT75kH:	mPopWorkFTLT75kH:	GapWorkFTLT75kH:
		PopWorkFTLT75kAIOM:	mPopWorkFTLT75kAIOM:	GapWorkFTLT75kAIOM:
		
		PopEmployedbyOcc_: 		mPopEmployedbyOcc_:
		PopEmployedbyOccW: 		mPopEmployedbyOccW:
		PopEmployedbyOccB: 		mPopEmployedbyOccB:
		PopEmployedbyOccH: 		mPopEmployedbyOccH:
		PopEmployedbyOccAIOM: 	mPopEmployedbyOccAIOM:

		PopEmployedMngmt_:	mPopEmployedMngmt_:	
		PopEmployedMngmtW:	mPopEmployedMngmtW:	GapEmployedMngmtW:
		PopEmployedMngmtB:	mPopEmployedMngmtB:	GapEmployedMngmtB:
		PopEmployedMngmtH:	mPopEmployedMngmtH:	GapEmployedMngmtH:
		PopEmployedMngmtAIOM:	mPopEmployedMngmtAIOM:	GapEmployedMngmtAIOM:
				
		PopEmployedServ_:	mPopEmployedServ_:	
		PopEmployedServW:	mPopEmployedServW:	GapEmployedServW:
		PopEmployedServB:	mPopEmployedServB:	GapEmployedServB:
		PopEmployedServH:	mPopEmployedServH:	GapEmployedServH:
		PopEmployedServAIOM:	mPopEmployedServAIOM:	GapEmployedServAIOM:
				
		PopEmployedSales_:	mPopEmployedSales_:	
		PopEmployedSalesW:	mPopEmployedSalesW:	GapEmployedSalesW:
		PopEmployedSalesB:	mPopEmployedSalesB:	GapEmployedSalesB:
		PopEmployedSalesH:	mPopEmployedSalesH:	GapEmployedSalesH:
		PopEmployedSalesAIOM:	mPopEmployedSalesAIOM:	GapEmployedSalesAIOM:
				
		PopEmployedNatRes_:	mPopEmployedNatRes_:	
		PopEmployedNatResW:	mPopEmployedNatResW:	GapEmployedNatResW:
		PopEmployedNatResB:	mPopEmployedNatResB:	GapEmployedNatResB:
		PopEmployedNatResH:	mPopEmployedNatResH:	GapEmployedNatResH:
		PopEmployedNatResAIOM:	mPopEmployedNatResAIOM:	GapEmployedNatResAIOM:
				
		PopEmployedProd_:	mPopEmployedProd_:	
		PopEmployedProdW:	mPopEmployedProdW:	GapEmployedProdW:
		PopEmployedProdB:	mPopEmployedProdB:	GapEmployedProdB:
		PopEmployedProdH:	mPopEmployedProdH:	GapEmployedProdH:
		PopEmployedProdAIOM:	mPopEmployedProdAIOM:	GapEmployedProdAIOM:
				
		NumOwnerOccupiedHU_:	mNumOwnerOccupiedHU_:	
		NumOwnerOccupiedHUW:	mNumOwnerOccupiedHUW:	GapOwnerOccupiedHUW:
		NumOwnerOccupiedHUB:	mNumOwnerOccupiedHUB:	GapOwnerOccupiedHUB:
		NumOwnerOccupiedHUH:	mNumOwnerOccupiedHUH:	GapOwnerOccupiedHUH:
		NumOwnerOccupiedHUAIOM:	mNumOwnerOccupiedHUAIOM:	GapOwnerOccupiedHUAIOM:

		NumOccupiedHsgUnits_:	mNumOccupiedHsgUnits_:	
		NumOccupiedHsgUnitsW:	mNumOccupiedHsgUnitsW:
		NumOccupiedHsgUnitsB:	mNumOccupiedHsgUnitsB:
		NumOccupiedHsgUnitsH:	mNumOccupiedHsgUnitsH:
		NumOccupiedHsgUnitsAIOM:	mNumOccupiedHsgUnitsAIOM:
	 	;

	id ward2012; 
run; 


proc export data=equity.profile_tabs_ACS_count
	outfile="D:\DCDATA\Libraries\Equity\Prog\Racial Equity Feature\profile_tabs_ACS_count.csv"
	dbms=csv replace;
	run;



					
