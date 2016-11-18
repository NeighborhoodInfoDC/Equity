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
**************************************************************************/
options symbolgen;

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let racelist=W B H AIOM;
%let racename= NH-White Black-Alone Hispanic All-Other;


data city_ward;
	set equity.profile_acs_city
			equity.profile_acs_wd12;

			if city=1 then ward2012="0";
			_make_profile=1;

run; 

*Add gap calculation - separate out city level white rates; 


data whiterates;
	set equity.profile_acs_city 
	(keep= _make_profile
		   Pct25andOverWoutHSW: Pct25andOverWHSW: Pct25andOverWSCW:
           PctPoorPersonsW: PctPoorChildrenW:
           PctFamilyLT75000W: PctFamilyGT200000W:
           AvgHshldIncAdjW: PctUnemployedW: 
           PctEmployed16to64W: Pct16andOverEmployW:
           Pct16andOverWagesW: Pct16andOverWorkFTW: 
           PctWorkFTLT35kW:  PctWorkFTLT75kW:
           PctEmployedMngmtW: PctEmployedServW:
           PctEmployedSalesW: PctEmployedNatResW: 
           PctEmployedProdW: PctOwnerOccupiedHUW: )
		   			;
	_make_profile=1;
	run;

%rename(whiterates);
run;


data city_ward_WR (drop=_make_profile);
	merge city_ward whiterates_new (rename=(c_make_profile=_make_profile));
	by _make_profile;
	
	Gap25andOverWoutHSB_2010_14=cPct25andOverWoutHSW_2010_14/100*Pop25andOverYearsB_2010_14-Pop25andOverWoutHSB_2010_14;
	Gap25andOverWoutHSW_2010_14=cPct25andOverWoutHSW_2010_14/100*Pop25andOverYearsW_2010_14-Pop25andOverWoutHSW_2010_14;
	Gap25andOverWoutHSH_2010_14=cPct25andOverWoutHSW_2010_14/100*Pop25andOverYearsH_2010_14-Pop25andOverWoutHSH_2010_14;
	Gap25andOverWoutHSAIOM_2010_14=cPct25andOverWoutHSW_2010_14/100*Pop25andOverYearsAIOM_2010_14-Pop25andOverWoutHSAIOM_2010_14;
	Gap25andOverWoutHSFB_2010_14=cPct25andOverWoutHSW_2010_14/100*Pop25andOverYearsFB_2010_14-Pop25andOverWoutHSFB_2010_14;
	Gap25andOverWoutHSNB_2010_14=cPct25andOverWoutHSW_2010_14/100*Pop25andOverYearsNB_2010_14-Pop25andOverWoutHSNB_2010_14;

	Gap25andOverWHSB_2010_14=cPct25andOverWHSW_2010_14/100*Pop25andOverYearsB_2010_14-Pop25andOverWHSB_2010_14;
	Gap25andOverWHSW_2010_14=cPct25andOverWHSW_2010_14/100*Pop25andOverYearsW_2010_14-Pop25andOverWHSW_2010_14;
	Gap25andOverWHSH_2010_14=cPct25andOverWHSW_2010_14/100*Pop25andOverYearsH_2010_14-Pop25andOverWHSH_2010_14;
	Gap25andOverWHSAIOM_2010_14=cPct25andOverWHSW_2010_14/100*Pop25andOverYearsAIOM_2010_14-Pop25andOverWHSAIOM_2010_14;
	Gap25andOverWHSFB_2010_14=cPct25andOverWHSW_2010_14/100*Pop25andOverYearsFB_2010_14-Pop25andOverWHSFB_2010_14;
	Gap25andOverWHSNB_2010_14=cPct25andOverWHSW_2010_14/100*Pop25andOverYearsNB_2010_14-Pop25andOverWHSNB_2010_14;

	Gap25andOverWSCB_2010_14=cPct25andOverWSCW_2010_14/100*Pop25andOverYearsB_2010_14-Pop25andOverWSCB_2010_14;
	Gap25andOverWSCW_2010_14=cPct25andOverWSCW_2010_14/100*Pop25andOverYearsW_2010_14-Pop25andOverWSCW_2010_14;
	Gap25andOverWSCH_2010_14=cPct25andOverWSCW_2010_14/100*Pop25andOverYearsH_2010_14-Pop25andOverWSCH_2010_14;
	Gap25andOverWSCAIOM_2010_14=cPct25andOverWSCW_2010_14/100*Pop25andOverYearsAIOM_2010_14-Pop25andOverWSCAIOM_2010_14;
	Gap25andOverWSCFB_2010_14=cPct25andOverWSCW_2010_14/100*Pop25andOverYearsFB_2010_14-Pop25andOverWSCFB_2010_14;
	Gap25andOverWSCNB_2010_14=cPct25andOverWSCW_2010_14/100*Pop25andOverYearsNB_2010_14-Pop25andOverWSCNB_2010_14;

	GapPoorPersonsB_2010_14=cPctPoorPersonsW_2010_14/100*PersonsPovertyDefinedB_2010_14-PopPoorPersonsB_2010_14;
	GapPoorPersonsW_2010_14=cPctPoorPersonsW_2010_14/100*PersonsPovertyDefinedW_2010_14-PopPoorPersonsW_2010_14;
	GapPoorPersonsH_2010_14=cPctPoorPersonsW_2010_14/100*PersonsPovertyDefinedH_2010_14-PopPoorPersonsH_2010_14;
	GapPoorPersonsAIOM_2010_14=cPctPoorPersonsW_2010_14/100*PersonsPovertyDefAIOM_2010_14-PopPoorPersonsAIOM_2010_14;
	GapPoorPersonsFB_2010_14=cPctPoorPersonsW_2010_14/100*PersonsPovertyDefinedFB_2010_14-PopPoorPersonsFB_2010_14;


	GapPoorChildrenB_2010_14=cPctPoorChildrenW_2010_14/100*ChildrenPovertyDefinedB_2010_14-PopPoorChildrenB_2010_14;
	GapPoorChildrenW_2010_14=cPctPoorChildrenW_2010_14/100*ChildrenPovertyDefinedW_2010_14-PopPoorChildrenW_2010_14;
	GapPoorChildrenH_2010_14=cPctPoorChildrenW_2010_14/100*ChildrenPovertyDefinedH_2010_14-PopPoorChildrenH_2010_14;
	GapPoorChildrenAIOM_2010_14=cPctPoorChildrenW_2010_14/100*ChildrenPovertyDefAIOM_2010_14-PopPoorChildrenAIOM_2010_14;


	GapFamilyLT75000B_2010_14=cPctFamilyLT75000W_2010_14/100*NumFamiliesB_2010_14-FamIncomeLT75kB_2010_14;
	GapFamilyLT75000W_2010_14=cPctFamilyLT75000W_2010_14/100*NumFamiliesW_2010_14-FamIncomeLT75kW_2010_14;
	GapFamilyLT75000H_2010_14=cPctFamilyLT75000W_2010_14/100*NumFamiliesH_2010_14-FamIncomeLT75kH_2010_14;
	GapFamilyLT75000AIOM_2010_14=cPctFamilyLT75000W_2010_14/100*NumFamiliesAIOM_2010_14-FamIncomeLT75kAIOM_2010_14;


	GapFamilyGT200000B_2010_14=cPctFamilyGT200000W_2010_14/100*NumFamiliesB_2010_14-FamIncomeGT200kB_2010_14;
	GapFamilyGT200000W_2010_14=cPctFamilyGT200000W_2010_14/100*NumFamiliesW_2010_14-FamIncomeGT200kW_2010_14;
	GapFamilyGT200000H_2010_14=cPctFamilyGT200000W_2010_14/100*NumFamiliesH_2010_14-FamIncomeGT200kH_2010_14;
	GapFamilyGT200000AIOM_2010_14=cPctFamilyGT200000W_2010_14/100*NumFamiliesAIOM_2010_14-FamIncomeGT200kAIOM_2010_14;


	GapAvgHshldIncAdjB_2010_14=cAvgHshldIncAdjW_2010_14/100*NumHshldsB_2010_14-AggHshldIncomeB_2010_14;
	GapAvgHshldIncAdjW_2010_14=cAvgHshldIncAdjW_2010_14/100*NumHshldsW_2010_14-AggHshldIncomeW_2010_14;
	GapAvgHshldIncAdjH_2010_14=cAvgHshldIncAdjW_2010_14/100*NumHshldsH_2010_14-AggHshldIncomeH_2010_14;
	GapAvgHshldIncAdjAIOM_2010_14=cAvgHshldIncAdjW_2010_14/100*NumHshldsAIOM_2010_14-AggHshldIncomeAIOM_2010_14;


	GapEmployed16to64B_2010_14=cPctEmployed16to64W_2010_14/100*Pop16_64yearsB_2010_14-Pop16_64EmployedB_2010_14;
	GapEmployed16to64W_2010_14=cPctEmployed16to64W_2010_14/100*Pop16_64yearsW_2010_14-Pop16_64EmployedW_2010_14;
	GapEmployed16to64H_2010_14=cPctEmployed16to64W_2010_14/100*Pop16_64yearsH_2010_14-Pop16_64EmployedH_2010_14;
	GapEmployed16to64AIOM_2010_14=cPctEmployed16to64W_2010_14/100*Pop16_64yearsAIOM_2010_14-Pop16_64EmployedAIOM_2010_14;

	Gap16andOverEmployB_2010_14=cPct16andOverEmployW_2010_14/100*Pop16andOverYearsB_2010_14-Pop16andOverEmployB_2010_14;
	Gap16andOverEmployW_2010_14=cPct16andOverEmployW_2010_14/100*Pop16andOverYearsW_2010_14-Pop16andOverEmployW_2010_14;
	Gap16andOverEmployH_2010_14=cPct16andOverEmployW_2010_14/100*Pop16andOverYearsH_2010_14-Pop16andOverEmployH_2010_14;
	Gap16andOverEmployAIOM_2010_14=cPct16andOverEmployW_2010_14/100*Pop16andOverYearsAIOM_2010_14-Pop16andOverEmployAIOM_2010_14;

	GapUnemployedB_2010_14=cPctUnemployedW_2010_14/100*PopInCivLaborForceB_2010_14-PopUnemployedB_2010_14;
	GapUnemployedW_2010_14=cPctUnemployedW_2010_14/100*PopInCivLaborForceW_2010_14-PopUnemployedW_2010_14;
	GapUnemployedH_2010_14=cPctUnemployedW_2010_14/100*PopInCivLaborForceH_2010_14-PopUnemployedH_2010_14;
	GapUnemployedAIOM_2010_14=cPctUnemployedW_2010_14/100*PopInCivLaborForceAIOM_2010_14-PopUnemployedAIOM_2010_14;

	Gap16andOverWagesB_2010_14=cPct16andOverWagesW_2010_14/100*Pop16andOverYearsB_2010_14-PopWorkEarnB_2010_14;
	Gap16andOverWagesW_2010_14=cPct16andOverWagesW_2010_14/100*Pop16andOverYearsW_2010_14-PopWorkEarnW_2010_14;
	Gap16andOverWagesH_2010_14=cPct16andOverWagesW_2010_14/100*Pop16andOverYearsH_2010_14-PopWorkEarnH_2010_14;
	Gap16andOverWagesAIOM_2010_14=cPct16andOverWagesW_2010_14/100*Pop16andOverYearsAIOM_2010_14-PopWorkEarnAIOM_2010_14;

	Gap16andOverWorkFTB_2010_14=cPct16andOverWorkFTW_2010_14/100*Pop16andOverYearsB_2010_14-PopWorkFTB_2010_14;
	Gap16andOverWorkFTW_2010_14=cPct16andOverWorkFTW_2010_14/100*Pop16andOverYearsW_2010_14-PopWorkFTW_2010_14;
	Gap16andOverWorkFTH_2010_14=cPct16andOverWorkFTW_2010_14/100*Pop16andOverYearsH_2010_14-PopWorkFTH_2010_14;
	Gap16andOverWorkFTAIOM_2010_14=cPct16andOverWorkFTW_2010_14/100*Pop16andOverYearsAIOM_2010_14-PopWorkFTAIOM_2010_14;

	GapWorkFTLT35kB_2010_14=cPctWorkFTLT35kW_2010_14/100*PopWorkFTB_2010_14-PopWorkFTLT35KB_2010_14;
	GapWorkFTLT35kW_2010_14=cPctWorkFTLT35kW_2010_14/100*PopWorkFTW_2010_14-PopWorkFTLT35KW_2010_14;
	GapWorkFTLT35kH_2010_14=cPctWorkFTLT35kW_2010_14/100*PopWorkFTH_2010_14-PopWorkFTLT35KH_2010_14;
	GapWorkFTLT35kAIOM_2010_14=cPctWorkFTLT35kW_2010_14/100*PopWorkFTAIOM_2010_14-PopWorkFTLT35KAIOM_2010_14;

	GapWorkFTLT75kB_2010_14=cPctWorkFTLT75kW_2010_14/100*PopWorkFTB_2010_14-PopWorkFTLT75KB_2010_14;
	GapWorkFTLT75kW_2010_14=cPctWorkFTLT75kW_2010_14/100*PopWorkFTW_2010_14-PopWorkFTLT75KW_2010_14;
	GapWorkFTLT75kH_2010_14=cPctWorkFTLT75kW_2010_14/100*PopWorkFTH_2010_14-PopWorkFTLT75KH_2010_14;
	GapWorkFTLT75kAIOM_2010_14=cPctWorkFTLT75kW_2010_14/100*PopWorkFTAIOM_2010_14-PopWorkFTLT75KAIOM_2010_14;

	GapEmployedMngmtB_2010_14=cPctEmployedMngmtW_2010_14/100*PopEmployedByOccB_2010_14-PopEmployedMngmtB_2010_14;
	GapEmployedMngmtW_2010_14=cPctEmployedMngmtW_2010_14/100*PopEmployedByOccW_2010_14-PopEmployedMngmtW_2010_14;
	GapEmployedMngmtH_2010_14=cPctEmployedMngmtW_2010_14/100*PopEmployedByOccH_2010_14-PopEmployedMngmtH_2010_14;
	GapEmployedMngmtAIOM_2010_14=cPctEmployedMngmtW_2010_14/100*PopEmployedByOccAIOM_2010_14-PopEmployedMngmtAIOM_2010_14;

	GapEmployedServB_2010_14=cPctEmployedServW_2010_14/100*PopEmployedByOccB_2010_14-PopEmployedServB_2010_14;
	GapEmployedServW_2010_14=cPctEmployedServW_2010_14/100*PopEmployedByOccW_2010_14-PopEmployedServW_2010_14;
	GapEmployedServH_2010_14=cPctEmployedServW_2010_14/100*PopEmployedByOccH_2010_14-PopEmployedServH_2010_14;
	GapEmployedServAIOM_2010_14=cPctEmployedServW_2010_14/100*PopEmployedByOccAIOM_2010_14-PopEmployedServAIOM_2010_14;

	GapEmployedSalesB_2010_14=cPctEmployedSalesW_2010_14/100*PopEmployedByOccB_2010_14-PopEmployedSalesB_2010_14;
	GapEmployedSalesW_2010_14=cPctEmployedSalesW_2010_14/100*PopEmployedByOccW_2010_14-PopEmployedSalesW_2010_14;
	GapEmployedSalesH_2010_14=cPctEmployedSalesW_2010_14/100*PopEmployedByOccH_2010_14-PopEmployedSalesH_2010_14;
	GapEmployedSalesAIOM_2010_14=cPctEmployedSalesW_2010_14/100*PopEmployedByOccAIOM_2010_14-PopEmployedSalesAIOM_2010_14;

	GapEmployedNatResB_2010_14=cPctEmployedNatResW_2010_14/100*PopEmployedByOccB_2010_14-PopEmployedNatResB_2010_14;
	GapEmployedNatResW_2010_14=cPctEmployedNatResW_2010_14/100*PopEmployedByOccW_2010_14-PopEmployedNatResW_2010_14;
	GapEmployedNatResH_2010_14=cPctEmployedNatResW_2010_14/100*PopEmployedByOccH_2010_14-PopEmployedNatResH_2010_14;
	GapEmployedNatResAIOM_2010_14=cPctEmployedNatResW_2010_14/100*PopEmployedByOccAIOM_2010_14-PopEmployedNatResAIOM_2010_14;

	GapEmployedProdB_2010_14=cPctEmployedProdW_2010_14/100*PopEmployedByOccB_2010_14-PopEmployedProdB_2010_14;
	GapEmployedProdW_2010_14=cPctEmployedProdW_2010_14/100*PopEmployedByOccW_2010_14-PopEmployedProdW_2010_14;
	GapEmployedProdH_2010_14=cPctEmployedProdW_2010_14/100*PopEmployedByOccH_2010_14-PopEmployedProdH_2010_14;
	GapEmployedProdAIOM_2010_14=cPctEmployedProdW_2010_14/100*PopEmployedByOccAIOM_2010_14-PopEmployedProdAIOM_2010_14;

	GapOwnerOccupiedHUB_2010_14=cPctOwnerOccupiedHUW_2010_14/100*NumOccupiedHsgUnitsB_2010_14-NumOwnerOccupiedHUB_2010_14;
	GapOwnerOccupiedHUW_2010_14=cPctOwnerOccupiedHUW_2010_14/100*NumOccupiedHsgUnitsW_2010_14-NumOwnerOccupiedHUW_2010_14;
	GapOwnerOccupiedHUH_2010_14=cPctOwnerOccupiedHUW_2010_14/100*NumOccupiedHsgUnitsH_2010_14-NumOwnerOccupiedHUH_2010_14;
	GapOwnerOccupiedHUAIOM_2010_14=cPctOwnerOccupiedHUW_2010_14/100*NumOccupiedHsgUnitsAIOM_2010_14-NumOwnerOccupiedHUAIOM_2010_14;

run;


data equity.profile_tabs_ACS_suppress (drop=cPct: cAvg:);
	set city_ward_WR;

	array t_est {21} 
		Pct25andOverWoutHS_2010_14
		Pct25andOverWHS_2010_14
		Pct25andOverWSC_2010_14
		AvgHshldIncAdj_2010_14
		PctFamilyGT200000_2010_14
		PctFamilyLT75000_2010_14
		PctPoorPersons_2010_14
		PctPoorChildren_2010_14
		Pct16andOverEmploy_2010_14
		PctEmployed16to64_2010_14
		PctUnemployed_2010_14
		Pct16andOverWages_2010_14
		Pct16andOverWorkFT_2010_14
		PctWorkFTLT35k_2010_14
		PctWorkFTLT75k_2010_14
		PctEmployedMngmt_2010_14
		PctEmployedServ_2010_14
		PctEmployedSales_2010_14
		PctEmployedNatRes_2010_14
		PctEmployedProd_2010_14
		PctOwnerOccupiedHU_2010_14
		;

	array t_moe {21} 	
		Pct25andOverWoutHS_m_2010_14
		Pct25andOverWHS_m_2010_14
		Pct25andOverWSC_m_2010_14
		AvgHshldIncAdj_m_2010_14
		PctFamilyGT200000_m_2010_14
		PctFamilyLT75000_m_2010_14
		PctPoorPersons_m_2010_14
		PctPoorChildren_m_2010_14
		Pct16andOverEmploy_m_2010_14
		PctEmployed16to64_m_2010_14
		PctUnemployed_m_2010_14
		Pct16andOverWages_m_2010_14
		Pct16andOverWorkFT_m_2010_14
		PctWorkFTLT35k_m_2010_14
		PctWorkFTLT75k_m_2010_14
		PctEmployedMngmt_m_2010_14
		PctEmployedServ_m_2010_14
		PctEmployedSales_m_2010_14
		PctEmployedNatRes_m_2010_14
		PctEmployedProd_m_2010_14
		PctOwnerOccupiedHU_m_2010_14
		;

	array t_cv {21} 
		cvPct25andOverWoutHS_2010_14
		cvPct25andOverWHS_2010_14
		cvPct25andOverWSC_2010_14
		cvAvgHshldIncAdj_2010_14
		cvPctFamilyGT200000_2010_14
		cvPctFamilyLT75000_2010_14
		cvPctPoorPersons_2010_14
		cvPctPoorChildren_2010_14
		cvPct16andOverEmploy_2010_14
		cvPctEmployed16to64_2010_14
		cvPctUnemployed_2010_14
		cvPct16andOverWages_2010_14
		cvPct16andOverWorkFT_2010_14
		cvPctWorkFTLT35k_2010_14
		cvPctWorkFTLT75k_2010_14
		cvPctEmployedMngmt_2010_14
		cvPctEmployedServ_2010_14
		cvPctEmployedSales_2010_14
		cvPctEmployedNatRes_2010_14
		cvPctEmployedProd_2010_14
		cvPctOwnerOccupiedHU_2010_14
		;

	array t_upper {21} 		
		uPct25andOverWoutHS_2010_14
		uPct25andOverWHS_2010_14
		uPct25andOverWSC_2010_14
		uAvgHshldIncAdj_2010_14
		uPctFamilyGT200000_2010_14
		uPctFamilyLT75000_2010_14
		uPctPoorPersons_2010_14
		uPctPoorChildren_2010_14
		uPct16andOverEmploy_2010_14
		uPctEmployed16to64_2010_14
		uPctUnemployed_2010_14
		uPct16andOverWages_2010_14
		uPct16andOverWorkFT_2010_14
		uPctWorkFTLT35k_2010_14
		uPctWorkFTLT75k_2010_14
		uPctEmployedMngmt_2010_14
		uPctEmployedServ_2010_14
		uPctEmployedSales_2010_14
		uPctEmployedNatRes_2010_14
		uPctEmployedProd_2010_14
		uPctOwnerOccupiedHU_2010_14
		;

	array t_lower {21} 		
		lPct25andOverWoutHS_2010_14
		lPct25andOverWHS_2010_14
		lPct25andOverWSC_2010_14
		lAvgHshldIncAdj_2010_14
		lPctFamilyGT200000_2010_14
		lPctFamilyLT75000_2010_14
		lPctPoorPersons_2010_14
		lPctPoorChildren_2010_14
		lPct16andOverEmploy_2010_14
		lPctEmployed16to64_2010_14
		lPctUnemployed_2010_14
		lPct16andOverWages_2010_14
		lPct16andOverWorkFT_2010_14
		lPctWorkFTLT35k_2010_14
		lPctWorkFTLT75k_2010_14
		lPctEmployedMngmt_2010_14
		lPctEmployedServ_2010_14
		lPctEmployedSales_2010_14
		lPctEmployedNatRes_2010_14
		lPctEmployedProd_2010_14
		lPctOwnerOccupiedHU_2010_14
		;

  	do t=1 to 21; 
   
                t_cv{t}=t_moe{t}/1.645/t_est{t}*100;
                t_lower{t}=t_est{t}- t_moe{t};
                t_upper{t}=t_est{t}+ t_moe{t};
              
                if t_cv{t} > 30 then do; 
				t_est{t}=.s; t_moe{t}=.s; 
				end; 

	end;
	
	%suppress_vars;
	%suppress_vars_fb;

	%suppress_gaps_negative;
	%suppress_gaps;
	%suppress_gaps_fb;

	%macro suppression;

	%do r=1 %to 4;

	%let race=%scan(&racelist.,&r.," ");
	%let name=%scan(&racename.,&r.," ");

	array f_gap&race. {21} 
		Gap25andOverWoutHS&race._2010_14
		Gap25andOverWHS&race._2010_14
		Gap25andOverWSC&race._2010_14
		GapAvgHshldIncAdj&race._2010_14
		GapFamilyGT200000&race._2010_14
		GapFamilyLT75000&race._2010_14
		GapPoorPersons&race._2010_14
		GapPoorChildren&race._2010_14
		Gap16andOverEmploy&race._2010_14
		GapEmployed16to64&race._2010_14
		GapUnemployed&race._2010_14
		Gap16andOverWages&race._2010_14
		Gap16andOverWorkFT&race._2010_14
		GapWorkFTLT35k&race._2010_14
		GapWorkFTLT75k&race._2010_14
		GapEmployedMngmt&race._2010_14
		GapEmployedServ&race._2010_14
		GapEmployedSales&race._2010_14
		GapEmployedNatRes&race._2010_14
		GapEmployedProd&race._2010_14
		GapOwnerOccupiedHU&race._2010_14
		;

	  	do z=1 to 21; 

			if e_gap&race.{z}=.s then f_gap&race.{z}= e_gap&race.{z};
			else if p_gap&race.{z}=a. then f_gap&race.{z}=p_gap&race.{z};
			else if n_gap&race.{z}=a. then f_gap&race.{z}=p_gap&race.{z};
			else f_gap&race.{z} = e_gap&race.{z};
		end;

	%end;

	%mend; 

/*Child poverty rates for Hispanics in Ward 3 and Whites in Ward 5 are hard suppressed
  due to high margins of error (14% and 23% respectively). The %suppress_vars macro
  did not automatically suppress these variables because variable estimates = 0, 
  preventing the CV from calculating because of division by 0*/

	if ward2012=3 then PctPoorChildrenH_2010_14=.s;
	else if ward 2012=3 then PctPoorChildrenH_m_2010_14=.s;
	else if ward2012=5 then PctPoorChildrenW_2010_14=.s;
	else if ward2012=5 then PctPoorChildrenW_m_2010_14=.s;

	label
		PctBlackNonHispBridge_m_2010_14 = "% black non-Hispanic, MOE, 2010-14 "
		PctWhiteNonHispBridge_m_2010_14 = "% white non-Hispanic, MOE, 2010-14 "
		PctHisp_m_2010_14 = "% Hispanic, MOE, 2010-14 " 
		PctAsnPINonHispBridge_m_2010_14 = "% Asian/P.I., MOE, 2010-14 " 
		PctOthRaceNonHispBridg_m_2010_14 = "% All other than Black White Asian P.I. Hispanic, MOE, 2010-14 "
		PctAloneB_m_2010_14 = "% black non-Hispanic, MOE, 2010-14 " 
		PctAloneW_m_2010_14 = "% white alone, MOE, 2010-14 " 
		PctAloneH_m_2010_14 = "% Hispanic alone, MOE, 2010-14 " 
		PctAloneA_m_2010_14 = "% Asian/P.I. alone, MOE, 2010-14 "
		PctAloneI_m_2010_14 = "% Indigenous alone, MOE, 2010-14 " 
		PctAloneO_m_2010_14 = "% Other race alone, MOE, 2010-14 " 
		PctAloneM_m_2010_14 = "% Multiracial alone, MOE, 2010-14 " 
		PctAloneIOM_m_2010_14 = "% Indigienous-other-multi-alone alone, MOE, 2010-14 " 
		PctAloneAIOM_m_2010_14 = "% All other than Black-White-Hispanic alone, MOE, 2010-14 "

		PctForeignBorn_m_2010_14 = "% foreign born, MOE, 2010-14 "
		PctNativeBorn_m_2010_14 = "% native born, MOE, 2010-14 " 
		PctForeignBornB_m_2010_14 = "% foreign born Black-Alone, MOE, 2010-14 " 
		PctForeignBornW_m_2010_14 = "% foreign born NH-White, MOE, 2010-14 "
		PctForeignBornH_m_2010_14 = "% foreign born Hispanic, MOE, 2010-14 " 
		PctForeignBornAIOM_m_2010_14 = "% foreign born All-Other, MOE, 2010-14 "
		PctOthLang_m_2010_14 = "% pop. that speaks a language other than English at home, MOE, 2010-14 "

		PctPopUnder18Years_m_2010_14 = "% children, MOE, 2010-14 "
		PctPopUnder18YearsW_m_2010_14 = "% children NH-White, MOE, 2010-14 " 
		PctPopUnder18YearsB_m_2010_14 = "% children Black-Alone, MOE, 2010-14 " 
		PctPopUnder18YearsH_m_2010_14 = "% children Hispanic, MOE, 2010-14 "
		PctPopUnder18YearsAIOM_m_2010_14 = "% children All-Other, MOE, 2010-14 "

		PctPop18_34Years_m_2010_14 = "% persons 18-34 years old, MOE, 2010-14 "
		PctPop18_34YearsW_m_2010_14 = "% persons 18-34 years old NH-White, MOE, 2010-14 " 
		PctPop18_34YearsB_m_2010_14 = "% persons 18-34 years old Black-Alone, MOE, 2010-14 " 
		PctPop18_34YearsH_m_2010_14 = "% persons 18-34 years old Hispanic, MOE, 2010-14 "
		PctPop18_34YearsAIOM_m_2010_14 = "% persons 18-34 years old All-Other, MOE, 2010-14 "

		PctPop35_64Years_m_2010_14 = "% persons 35-64 years old, MOE, 2010-14 "
		PctPop35_64YearsW_m_2010_14 = "% persons 35-64 years old NH-White, MOE, 2010-14 " 
		PctPop35_64YearsB_m_2010_14 = "% persons 35-64 years old Black-Alone, MOE, 2010-14 " 
		PctPop35_64YearsH_m_2010_14 = "% persons 35-64 years old Hispanic, MOE, 2010-14 "
		PctPop35_64YearsAIOM_m_2010_14 = "% persons 35-64 years old All-Other, MOE, 2010-14 "

		PctPop65andOverYrs_m_2010_14 = "% seniors, MOE, 2010-14 "
		PctPop65andOverYrsW_m_2010_14 = "% seniors NH-White, MOE, 2010-14 " 
		PctPop65andOverYrsB_m_2010_14 = "% seniors Black-Alone, MOE, 2010-14 " 
		PctPop65andOverYrsH_m_2010_14 = "% seniors Hispanic, MOE, 2010-14 "
		PctPop65andOverYrsAIOM_m_2010_14 = "% seniors All-Other, MOE, 2010-14 "

		Pct25andOverWoutHS_m_2010_14 = "% persons without HS diploma, MOE, 2010-14 "
		Pct25andOverWoutHSW_m_2010_14 = "% persons NH-White without HS diploma, MOE, 2010-14 "
		Pct25andOverWoutHSB_m_2010_14 = "% persons Black-Alone without HS diploma, MOE, 2010-14 "
		Pct25andOverWoutHSH_m_2010_14 = "% persons Hispanic without HS diploma, MOE, 2010-14 "
		Pct25andOverWoutHSAIOM_m_2010_14 = "% persons All-Other without HS diploma, MOE, 2010-14 "
		Pct25andOverWoutHSFB_m_2010_14 = "% persons foreign-born without HS diploma, MOE, 2010-14 "
		Pct25andOverWoutHSNB_m_2010_14 = "% persons native-born without HS diploma, MOE, 2010-14 "

		Pct25andOverWHS_m_2010_14 = "% persons with HS diploma, MOE, 2010-14 "
		Pct25andOverWHSW_m_2010_14 = "% persons NH-White with HS diploma, MOE, 2010-14 "
		Pct25andOverWHSB_m_2010_14 = "% persons Black-Alone with HS diploma, MOE, 2010-14 "
		Pct25andOverWHSH_m_2010_14 = "% persons Hispanic with HS diploma, MOE, 2010-14 "
		Pct25andOverWHSAIOM_m_2010_14 = "% persons All-Other with HS diploma, MOE, 2010-14 "
		Pct25andOverWHSFB_m_2010_14 = "% persons foreign-born with HS diploma, MOE, 2010-14 "
		Pct25andOverWHSNB_m_2010_14 = "% persons native-born with HS diploma, MOE, 2010-14 "

		Pct25andOverWSC_m_2010_14 = "% persons with some college, MOE, 2010-14 "
		Pct25andOverWSCW_m_2010_14 = "% persons NH-White with some college, MOE, 2010-14 "
		Pct25andOverWSCB_m_2010_14 = "% persons Black-Alone with some college, MOE, 2010-14 "
		Pct25andOverWSCH_m_2010_14 = "% persons Hispanic with some college, MOE, 2010-14 "
		Pct25andOverWSCAIOM_m_2010_14 = "% persons All-Other with some college, MOE, 2010-14 "
		Pct25andOverWSCFB_m_2010_14 = "% persons foreign-born with some college, MOE, 2010-14 "
		Pct25andOverWSCNB_m_2010_14 = "% persons native-born with some college, MOE, 2010-14 "

		AvgHshldIncAdj_m_2010_14 = "Average household income last year ($), MOE, 2010-14 "
		AvgHshldIncAdjW_m_2010_14 = "Average household income last year NH-White ($), MOE, 2010-14 "
		AvgHshldIncAdjB_m_2010_14 = "Average household income last year Black-Alone ($), MOE, 2010-14 "
		AvgHshldIncAdjH_m_2010_14 = "Average household income last year Hispanic ($), MOE, 2010-14 "
		AvgHshldIncAdjAIOM_m_2010_14 = "Average household income last year All-Other ($), MOE, 2010-14 "

		PctFamilyGT200000_m_2010_14 = "% families with income greater than 200000, MOE, 2010-14 "
		PctFamilyGT200000W_m_2010_14 = "% families NH-White with income greater than 200000, MOE, 2010-14 "
		PctFamilyGT200000B_m_2010_14 = "% families Black-Alone with income greater than 200000, MOE, 2010-14 "
		PctFamilyGT200000H_m_2010_14 = "% families Hispanic with income greater than 200000, MOE, 2010-14 "
		PctFamilyGT200000AIOM_m_2010_14 = "% families All-Other with income greater than 200000, MOE, 2010-14 "

		PctFamilyLT75000_m_2010_14 = "% families with income less than 75000, MOE, 2010-14 "
		PctFamilyLT75000W_m_2010_14 = "% families NH-White with income less than 75000, MOE, 2010-14 "
		PctFamilyLT75000B_m_2010_14 = "% families Black-Alone with income less than 75000, MOE, 2010-14 "
		PctFamilyLT75000H_m_2010_14 = "% families Hispanic with income less than 75000, MOE, 2010-14 "
		PctFamilyLT75000AIOM_m_2010_14 = "% families All-Other with income less than 75000, MOE, 2010-14 "

		PctPoorPersons_m_2010_14 = "Poverty rate (%), MOE, 2010-14 "
		PctPoorPersonsW_m_2010_14 = "Poverty rate NH-White (%), MOE, 2010-14 "
		PctPoorPersonsB_m_2010_14 = "Poverty rate Black-Alone (%), MOE, 2010-14 "
		PctPoorPersonsH_m_2010_14 = "Poverty rate Hispanic (%), MOE, 2010-14 "
		PctPoorPersonsAIOM_m_2010_14 = "Poverty rate All-Other (%), MOE, 2010-14 "
		PctPoorPersonsFB_m_2010_14 = "Poverty rate foreign born (%), MOE, 2010-14 "

		PctPoorChildren_m_2010_14 = "% children in poverty, MOE, 2010-14 "
		PctPoorChildrenW_m_2010_14 = "% children NH-White in poverty, MOE, 2010-14 "
		PctPoorChildrenB_m_2010_14 = "% children Black-Alone in poverty, MOE, 2010-14 "
		PctPoorChildrenH_m_2010_14 = "% children Hispanic in poverty, MOE, 2010-14 "
		PctPoorChildrenAIOM_m_2010_14 = "% children All-Other in poverty, MOE, 2010-14 "

		Pct16andOverEmploy_m_2010_14 = "% pop. 16+ yrs. employed, MOE, 2010-14 "
		Pct16andOverEmployW_m_2010_14 = "% pop. 16+ yrs. employed NH-White, MOE, 2010-14 "
		Pct16andOverEmployB_m_2010_14 = "% pop. 16+ yrs. employed Black-Alone, MOE, 2010-14 "
		Pct16andOverEmployH_m_2010_14 = "% pop. 16+ yrs. employed Hispanic, MOE, 2010-14"
		Pct16andOverEmployAIOM_m_2010_14 = "% pop. 16+ yrs. employed All-Other, MOE, 2010-14"

		PctEmployed16to64_m_2010_14 = "% persons employed between 16 and 64 years old, MOE, 2010-14 "
		PctEmployed16to64W_m_2010_14 = "% persons NH-White employed between 16 and 64 years old, MOE, 2010-14 "
		PctEmployed16to64B_m_2010_14 = "% persons Black-Alone employed between 16 and 64 years old, MOE, 2010-14 "
		PctEmployed16to64H_m_2010_14 = "% persons Hispanic employed between 16 and 64 years old, MOE, 2010-14"
		PctEmployed16to64AIOM_m_2010_14 = "% persons All-Other employed between 16 and 64 years old, MOE, 2010-14"

		PctUnemployed_m_2010_14 = "Unemployment rate (%), MOE, 2010-14 "
		PctUnemployedW_m_2010_14 = "NH-White Unemployment rate (%), MOE, 2010-14 "
		PctUnemployedB_m_2010_14 = "Black-Alone Unemployment rate (%), MOE, 2010-14 "
		PctUnemployedH_m_2010_14 = "Hispanic Unemployment rate (%), MOE, 2010-14"
		PctUnemployedAIOM_m_2010_14 = "All-Other Unemployment rate (%), MOE, 2010-14"

		Pct16andOverWages_m_2010_14 = "% persons employed with earnings, MOE, 2010-14 "
		Pct16andOverWagesW_m_2010_14 = "% persons NH-White employed with earnings, MOE, 2010-14 "
		Pct16andOverWagesB_m_2010_14 = "% persons Black-Alone employed with earnings, MOE, 2010-14 "
		Pct16andOverWagesH_m_2010_14 = "% persons Hispanic employed with earnings, MOE, 2010-14"
		Pct16andOverWagesAIOM_m_2010_14 = "% persons All-Other employed with earnings, MOE, 2010-14"

		Pct16andOverWorkFT_m_2010_14 = "% persons employed full time, MOE, 2010-14 "
		Pct16andOverWorkFTW_m_2010_14 = "% persons NH-White employed full time, MOE, 2010-14 "
		Pct16andOverWorkFTB_m_2010_14 = "% persons Black-Alone employed full time, MOE, 2010-14 "
		Pct16andOverWorkFTH_m_2010_14 = "% persons Hispanic employed full time, MOE, 2010-14"
		Pct16andOverWorkFTAIOM_m_2010_14 = "% persons All-Other employed full time, MOE, 2010-14"

		PctWorkFTLT35k_m_2010_14 = "% persons employed full time with earnings less than 35000, MOE, 2010-14 "
		PctWorkFTLT35kW_m_2010_14 = "% persons NH-White employed full time with earnings less than 35000, MOE, 2010-14 "
		PctWorkFTLT35kB_m_2010_14 = "% persons Black-Alone employed full time with earnings less than 35000, MOE, 2010-14 "
		PctWorkFTLT35kH_m_2010_14 = "% persons Hispanic employed full time with earnings less than 35000, MOE, 2010-14"
		PctWorkFTLT35kAIOM_m_2010_14 = "% persons All-Other employed full time with earnings less than 35000, MOE, 2010-14"

		PctWorkFTLT75k_m_2010_14 = "% persons employed full time with earnings less than 75000, MOE, 2010-14 "
		PctWorkFTLT75kW_m_2010_14 = "% persons NH-White employed full time with earnings less than 75000, MOE, 2010-14 "
		PctWorkFTLT75kB_m_2010_14 = "% persons Black-Alone employed full time with earnings less than 75000, MOE, 2010-14 "
		PctWorkFTLT75kH_m_2010_14 = "% persons Hispanic employed full time with earnings less than 75000, MOE, 2010-14"
		PctWorkFTLT75kAIOM_m_2010_14 = "% persons All-Other employed full time with earnings less than 75000, MOE, 2010-14"

		PctEmployedMngmt_m_2010_14 = "% persons employed in management business science and arts occupations, MOE, 2010-14 "
		PctEmployedMngmtW_m_2010_14 = "% persons NH-White employed in management business science and arts occupations, MOE, 2010-14 "
		PctEmployedMngmtB_m_2010_14 = "% persons Black-Alone employed in management business science and arts occupations, MOE, 2010-14 "
		PctEmployedMngmtH_m_2010_14 = "% persons Hispanic employed in management business science and arts occupations, MOE, 2010-14"
		PctEmployedMngmtAIOM_m_2010_14 = "% persons All-Other employed in management business science and arts occupations, MOE, 2010-14"

		PctEmployedServ_m_2010_14 = "% persons employed in service occupations, MOE, 2010-14 "
		PctEmployedServW_m_2010_14 = "% persons NH-White employed in service occupations, MOE, 2010-14 "
		PctEmployedServB_m_2010_14 = "% persons Black-Alone employed in service occupations, MOE, 2010-14 "
		PctEmployedServH_m_2010_14 = "% persons Hispanic employed in service occupations, MOE, 2010-14"
		PctEmployedServAIOM_m_2010_14 = "% persons All-Other employed in service occupations, MOE, 2010-14"

		PctEmployedSales_m_2010_14 = "% persons employed in sales and office occupations, MOE, 2010-14 "
		PctEmployedSalesW_m_2010_14 = "% persons NH-White employed in sales and office occupations, MOE, 2010-14 "
		PctEmployedSalesB_m_2010_14 = "% persons Black-Alone employed in sales and office occupations, MOE, 2010-14 "
		PctEmployedSalesH_m_2010_14 = "% persons Hispanic employed in sales and office occupations, MOE, 2010-14"
		PctEmployedSalesAIOM_m_2010_14 = "% persons All-Other employed in sales and office occupations, MOE, 2010-14"

		PctEmployedNatRes_m_2010_14 = "% persons employed in natural resources construction and maintenance occupations, MOE, 2010-14 "
		PctEmployedNatResW_m_2010_14 = "% persons NH-White employed in natural resources construction and maintenance occupations, MOE, 2010-14 "
		PctEmployedNatResB_m_2010_14 = "% persons Black-Alone employed in natural resources construction and maintenance occupations, MOE, 2010-14 "
		PctEmployedNatResH_m_2010_14 = "% persons Hispanic employed in natural resources construction and maintenance occupations, MOE, 2010-14"
		PctEmployedNatResAIOM_m_2010_14 = "% persons All-Other employed in natural resources construction and maintenance occupations, MOE, 2010-14"

		PctEmployedProd_m_2010_14 = "% persons employed in production transportation and material moving occupations, MOE, 2010-14 "
		PctEmployedProdW_m_2010_14 = "% persons NH-White employed in production transportation and material moving occupations, MOE, 2010-14 "
		PctEmployedProdB_m_2010_14 = "% persons Black-Alone employed in production transportation and material moving occupations, MOE, 2010-14 "
		PctEmployedProdH_m_2010_14 = "% persons Hispanic employed in production transportation and material moving occupations, MOE, 2010-14"
		PctEmployedProdAIOM_m_2010_14 = "% persons All-Other employed in production transportation and material moving occupations, MOE, 2010-14"

		PctOwnerOccupiedHU_m_2010_14 = "Homeownership rate (%), MOE, 2010-14 "
		PctOwnerOccupiedHUW_m_2010_14 = "Homeownership rate NH-White(%), MOE, 2010-14 "
		PctOwnerOccupiedHUB_m_2010_14 = "Homeownership rate Black-Alone(%), MOE, 2010-14 "
		PctOwnerOccupiedHUH_m_2010_14 = "Homeownership rate Hispanic (%), MOE, 2010-14 "
		PctOwnerOccupiedHUAIOM_m_2010_14 = "Homeownership rate All-Other (%), MOE, 2010-14 "


		Gap25andOverWoutHSW_2010_14 = "Difference in # of NH-White people without HS diploma with equity, 2010-14 "
		Gap25andOverWoutHSB_2010_14 = "Difference in # of Black-Alone people without HS diploma with equity, 2010-14 "
		Gap25andOverWoutHSH_2010_14 = "Difference in # of Hispanic people without HS diploma with equity, 2010-14 "
		Gap25andOverWoutHSAIOM_2010_14 = "Difference in # of All-Other people without HS diploma with equity, 2010-14 "
		Gap25andOverWoutHSFB_2010_14 = "Difference in # of people foreign-born without HS diploma with equity, 2010-14 "
		Gap25andOverWoutHSNB_2010_14 = "Difference in # of people native-born without HS diploma with equity, 2010-14 "

		Gap25andOverWHSW_2010_14 = "Difference in # of NH-White people with HS diploma with equity, 2010-14 "
		Gap25andOverWHSB_2010_14 = "Difference in # of Black-Alone people with HS diploma with equity, 2010-14 "
		Gap25andOverWHSH_2010_14 = "Difference in # of Hispanic people with HS diploma with equity, 2010-14 "
		Gap25andOverWHSAIOM_2010_14 = "Difference in # of All-Other people with HS diploma with equity, 2010-14 "
		Gap25andOverWHSFB_2010_14 = "Difference in # of people foreign-born with HS diploma with equity, 2010-14 "
		Gap25andOverWHSNB_2010_14 = "Difference in # of people native-born with HS diploma with equity, 2010-14 "

		Gap25andOverWSCW_2010_14 = "Difference in # of NH-White people with some college with equity, 2010-14 "
		Gap25andOverWSCB_2010_14 = "Difference in # of Black-Alone people with some college with equity, 2010-14 "
		Gap25andOverWSCH_2010_14 = "Difference in # of Hispanic people with some college with equity, 2010-14 "
		Gap25andOverWSCAIOM_2010_14 = "Difference in # of All-Other people with some college with equity, 2010-14 "
		Gap25andOverWSCFB_2010_14 = "Difference in # of people foreign-born with some college with equity, 2010-14 "
		Gap25andOverWSCNB_2010_14 = "Difference in # of people native-born with some college with equity, 2010-14 "

		GapAvgHshldIncAdjW_2010_14 = "Average household income last year NH-White ($) with equity, 2010-14 "
		GapAvgHshldIncAdjB_2010_14 = "Average household income last year Black-Alone ($) with equity, 2010-14 "
		GapAvgHshldIncAdjH_2010_14 = "Average household income last year Hispanic ($) with equity, 2010-14 "
		GapAvgHshldIncAdjAIOM_2010_14 = "Average household income last year All-Other ($) with equity, 2010-14 "

		GapFamilyGT200000W_2010_14 = "Difference in # of families NH-White with income greater than 200000 with equity, 2010-14 "
		GapFamilyGT200000B_2010_14 = "Difference in # of families Black-Alone with income greater than 200000 with equity, 2010-14 "
		GapFamilyGT200000H_2010_14 = "Difference in # of families Hispanic with income greater than 200000 with equity, 2010-14 "
		GapFamilyGT200000AIOM_2010_14 = "Difference in # of families All-Other with income greater than 200000 with equity, 2010-14 "

		GapFamilyLT75000W_2010_14 = "Difference in # of families NH-White with income less than 75000 with equity, 2010-14 "
		GapFamilyLT75000B_2010_14 = "Difference in # of families Black-Alone with income less than 75000 with equity, 2010-14 "
		GapFamilyLT75000H_2010_14 = "Difference in # of families Hispanic with income less than 75000 with equity, 2010-14 "
		GapFamilyLT75000AIOM_2010_14 = "Difference in # of families All-Other with income less than 75000 with equity, 2010-14 "

		GapPoorPersonsW_2010_14 = "Difference in # of NH-White people living below poverty line with equity, 2010-14 "
		GapPoorPersonsB_2010_14 = "Difference in # of Black-Alone people living below poverty line with equity, 2010-14 "
		GapPoorPersonsH_2010_14 = "Difference in # of Hispanic people living below poverty line with equity, 2010-14 "
		GapPoorPersonsAIOM_2010_14 = "Difference in # of All-Other people living below poverty line with equity, 2010-14 "
		GapPoorPersonsFB_2010_14 = "Difference in # of foreign born people living below poverty line with equity, 2010-14 "

		Gap16andOverEmployW_2010_14 = "Difference in # of people 16+ yrs. employed NH-White with equity, 2010-14 "
		Gap16andOverEmployB_2010_14 = "Difference in # of people 16+ yrs. employed Black-Alone with equity, 2010-14 "
		Gap16andOverEmployH_2010_14 = "Difference in # of people 16+ yrs. employed Hispanic with equity, 2010-14 "
		Gap16andOverEmployAIOM_2010_14 = "Difference in # of people 16+ yrs. employed All-Other with equity, 2010-14 "

		GapEmployed16to64W_2010_14 = "Difference in # of NH-White people employed between 16 and 64 years old with equity, 2010-14 "
		GapEmployed16to64B_2010_14 = "Difference in # of Black-Alone people employed between 16 and 64 years old with equity, 2010-14 "
		GapEmployed16to64H_2010_14 = "Difference in # of Hispanic people employed between 16 and 64 years old with equity, 2010-14 "
		GapEmployed16to64AIOM_2010_14 = "Difference in # of All-Other people employed between 16 and 64 years old with equity, 2010-14 "

		GapUnemployedW_2010_14 = "Difference in # of NH-White unemployed people with equity, 2010-14 "
		GapUnemployedB_2010_14 = "Difference in # of Black-Alone unemployed people with equity, 2010-14 "
		GapUnemployedH_2010_14 = "Difference in # of Hispanic unemployed people with equity, 2010-14 "
		GapUnemployedAIOM_2010_14 = "Difference in # of All-Other unemployed people with equity, 2010-14 "

		Gap16andOverWagesW_2010_14 = "Difference in # of NH-White people employed with earnings with equity, 2010-14 "
		Gap16andOverWagesB_2010_14 = "Difference in # of Black-Alone people employed with earnings with equity, 2010-14 "
		Gap16andOverWagesH_2010_14 = "Difference in # of Hispanic people employed with earnings with equity, 2010-14 "
		Gap16andOverWagesAIOM_2010_14 = "Difference in # of All-Other people employed with earnings with equity, 2010-14 "

		Gap16andOverWorkFTW_2010_14 = "Difference in # of NH-White people employed full time with equity, 2010-14 "
		Gap16andOverWorkFTB_2010_14 = "Difference in # of Black-Alone people employed full time with equity, 2010-14 "
		Gap16andOverWorkFTH_2010_14 = "Difference in # of Hispanic people employed full time with equity, 2010-14 "
		Gap16andOverWorkFTAIOM_2010_14 = "Difference in # of All-Other people employed full time with equity, 2010-1 4"

		GapWorkFTLT35kW_2010_14 = "Difference in # of NH-White people employed full time with earnings less than 35000 with equity, 2010-14 "
		GapWorkFTLT35kB_2010_14 = "Difference in # of Black-Alone people employed full time with earnings less than 35000 with equity, 2010-14 "
		GapWorkFTLT35kH_2010_14 = "Difference in # of Hispanic people employed full time with earnings less than 35000 with equity, 2010-14 "
		GapWorkFTLT35kAIOM_2010_14 = "Difference in # of All-Other people employed full time with earnings less than 35000 with equity, 2010-14 "

		GapWorkFTLT75kW_2010_14 = "Difference in # of NH-White people employed full time with earnings less than 75000 with equity, 2010-14 "
		GapWorkFTLT75kB_2010_14 = "Difference in # of Black-Alone people employed full time with earnings less than 75000 with equity, 2010-14 "
		GapWorkFTLT75kH_2010_14 = "Difference in # of Hispanic people employed full time with earnings less than 75000 with equity, 2010-14 "
		GapWorkFTLT75kAIOM_2010_14 = "Difference in # of All-Other people employed full time with earnings less than 75000 with equity, 2010-14 "

		GapEmployedMngmtW_2010_14 = "Difference in # of NH-White people employed in management business science and arts occupations with equity, 2010-14 "
		GapEmployedMngmtB_2010_14 = "Difference in # of Black-Alone people employed in management business science and arts occupations with equity, 2010-14 "
		GapEmployedMngmtH_2010_14 = "Difference in # of Hispanic people employed in management business science and arts occupations with equity, 2010-14 "
		GapEmployedMngmtAIOM_2010_14 = "Difference in # of All-Other people employed in management business science and arts occupations with equity, 2010-14 "

		GapEmployedServW_2010_14 = "Difference in # of NH-White people employed in service occupations with equity, 2010-14 "
		GapEmployedServB_2010_14 = "Difference in # of Black-Alone people employed in service occupations with equity, 2010-14 "
		GapEmployedServH_2010_14 = "Difference in # of Hispanic people employed in service occupations with equity, 2010-14 "
		GapEmployedServAIOM_2010_14 = "Difference in # of All-Other people employed in service occupations with equity, 2010-14"

		GapEmployedSalesW_2010_14 = "Difference in # of NH-White people employed in sales and office occupations with equity, 2010-14 "
		GapEmployedSalesB_2010_14 = "Difference in # of Black-Alone people employed in sales and office occupations with equity, 2010-14 "
		GapEmployedSalesH_2010_14 = "Difference in # of Hispanic people employed in sales and office occupations with equity, 2010-14 "
		GapEmployedSalesAIOM_2010_14 = "Difference in # of All-Other people employed in sales and office occupations with equity, 2010-14 "

		GapEmployedNatResW_2010_14 = "Difference in # of NH-White people employed in natural resources construction and maintenance occupations with equity, 2010-14 "
		GapEmployedNatResB_2010_14 = "Difference in # of Black-Alone people employed in natural resources construction and maintenance occupations with equity, 2010-14 "
		GapEmployedNatResH_2010_14 = "Difference in # of Hispanic people employed in natural resources construction and maintenance occupations with equity, 2010-14 "
		GapEmployedNatResAIOM_2010_14 = "Difference in # of All-Other people employed in natural resources construction and maintenance occupations with equity, 2010-14 "

		GapEmployedProdW_2010_14 = "Difference in # of NH-White people employed in production transportation and material moving occupations with equity, 2010-14 "
		GapEmployedProdB_2010_14 = "Difference in # of Black-Alone people employed in production transportation and material moving occupations with equity, 2010-14 "
		GapEmployedProdH_2010_14 = "Difference in # of Hispanic people employed in production transportation and material moving occupations with equity, 2010-14 "
		GapEmployedProdAIOM_2010_14 = "Difference in # of All-Other people employed in production transportation and material moving occupations with equity, 2010-14 "

		GapOwnerOccupiedHUW_2010_14 = "Difference in # of NH-White homeowners with equity, 2010-14 "
		GapOwnerOccupiedHUB_2010_14 = "Difference in # of Black-Alone homeowners with equity, 2010-14 "
		GapOwnerOccupiedHUH_2010_14 = "Difference in # of Hispanic homeowners with equity, 2010-14 "
		GapOwnerOccupiedHUAIOM_2010_14 = "Difference in # of All-Other homeowners with equity, 2010-14 "
		;
	
run;


proc transpose data=equity.profile_tabs_ACS_suppress out=equity.profile_tabs_ACS (label="DC Equity Indicators and Gap Calculations for Equity Profile City & Ward, 2010-14"); 
	var PctWhiteNonHispBridge: PctHisp:
		PctAloneB: PctAloneW: PctAloneA_:
		PctAloneI_: PctAloneO: PctAloneM: PctAloneAIOM:

		PctForeignBorn_: PctNativeBorn: 

		PctForeignBornB: PctForeignBornW:
		PctForeignBornH: PctForeignBornAIOM:

		PctOthLang:

		PctPopUnder18Years_: PctPopUnder18YearsW_: 
		PctPopUnder18YearsB_: PctPopUnder18YearsH_:
		PctPopUnder18YearsAIOM_:

		PctPop18_34Years_: PctPop18_34YearsW_: 
		PctPop18_34YearsB_: PctPop18_34YearsH_:
		PctPop18_34YearsAIOM_:

		PctPop35_64Years_: PctPop35_64YearsW_: 
		PctPop35_64YearsB_: PctPop35_64YearsH_:
		PctPop35_64YearsAIOM_:

		PctPop65andOverYears_: PctPop65andOverYrs_:
		PctPop65andOverYearsW: PctPop65andOverYrsW:
		PctPop65andOverYearsB: PctPop65andOverYrsB:
		PctPop65andOverYearsH: PctPop65andOverYrsH:
		PctPop65andOverYearsAIOM: PctPop65andOverYrsAIOM:

		Pct25andOverWoutHS_:
		Pct25andOverWoutHSW:
		Pct25andOverWoutHSB:
		Pct25andOverWoutHSH:
		Pct25andOverWoutHSAIOM:
		Pct25andOverWoutHSFB:
		Pct25andOverWoutHSNB:

		Gap25andOverWoutHSB:
		Gap25andOverWoutHSH:
		Gap25andOverWoutHSAIOM:
		Gap25andOverWoutHSFB:
		Gap25andOverWoutHSNB:

		Pct25andOverWHS_:
		Pct25andOverWHSW:
		Pct25andOverWHSB:
		Pct25andOverWHSH:
		Pct25andOverWHSAIOM:
		Pct25andOverWHSFB:
		Pct25andOverWHSNB:

		Gap25andOverWHSB:
		Gap25andOverWHSH:
		Gap25andOverWHSAIOM:
		Gap25andOverWHSFB:
		Gap25andOverWHSNB:

		Pct25andOverWSC_:
		Pct25andOverWSCW:
		Pct25andOverWSCB:
		Pct25andOverWSCH:
		Pct25andOverWSCAIOM:
		Pct25andOverWSCFB:
		Pct25andOverWSCNB:

		Gap25andOverWSCB:
		Gap25andOverWSCH:
		Gap25andOverWSCAIOM:
		Gap25andOverWSCFB:
		Gap25andOverWSCNB:

		AvgHshldIncAdj_:
		AvgHshldIncAdjW:
		AvgHshldIncAdjB:
		AvgHshldIncAdjH:

		PctFamilyGT200000_:
		PctFamilyGT200000W:
		PctFamilyGT200000B:
		PctFamilyGT200000H:
		PctFamilyGT200000AIOM:

		PctFamilyLT75000_:
		PctFamilyLT75000W:
		PctFamilyLT75000B:
		PctFamilyLT75000H:
		PctFamilyLT75000AIOM:

		GapFamilyLT75000B:
		GapFamilyLT75000H:
		GapFamilyLT75000AIOM:

		PctPoorPersons_:
		PctPoorPersonsW:
		PctPoorPersonsB:
		PctPoorPersonsH:
		PctPoorPersonsAIOM:
		PctPoorPersonsFB:

		GapPoorPersonsB:
		GapPoorPersonsH:
		GapPoorPersonsAIOM:
		GapPoorPersonsFB:

		PctPoorChildren_:
		PctPoorChildrenW:
		PctPoorChildrenB:
		PctPoorChildrenH:
		PctPoorChildrenAIOM:

		Pct16andOverEmploy_:
		Pct16andOverEmployW:
		Pct16andOverEmployB:
		Pct16andOverEmployH:
		Pct16andOverEmployAIOM:

		Gap16andOverEmployB:
		Gap16andOverEmployH:
		Gap16andOverEmployAIOM:

		PctEmployed16to64_:
		PctEmployed16to64W:
		PctEmployed16to64B:
		PctEmployed16to64H:
		PctEmployed16to64AIOM:

		GapEmployed16to64B:
		GapEmployed16to64H:
		GapEmployed16to64AIOM:

		PctUnemployed_:
		PctUnemployedW:
		PctUnemployedB:
		PctUnemployedH:
		PctUnemployedAIOM:

		GapUnemployedB:
		GapUnemployedH:
		GapUnemployedAIOM:

		Pct16andOverWages_:
		Pct16andOverWagesW:
		Pct16andOverWagesB:
		Pct16andOverWagesH:
		Pct16andOverWagesAIOM:

		Gap16andOverWagesB:
		Gap16andOverWagesH:
		Gap16andOverWagesAIOM:

		Pct16andOverWorkFT_:
		Pct16andOverWorkFTW:
		Pct16andOverWorkFTB:
		Pct16andOverWorkFTH:
		Pct16andOverWorkFTAIOM:

		Gap16andOverWorkFTB:
		Gap16andOverWorkFTH:
		Gap16andOverWorkFTAIOM:

		PctWorkFTLT35k_:
		PctWorkFTLT35kW:
		PctWorkFTLT35kB:
		PctWorkFTLT35kH:
		PctWorkFTLT35kAIOM:

		GapWorkFTLT35kB:
		GapWorkFTLT35kH:
		GapWorkFTLT35kAIOM:

		PctWorkFTLT75k_:
		PctWorkFTLT75kW:
		PctWorkFTLT75kB:
		PctWorkFTLT75kH:
		PctWorkFTLT75kAIOM:

		GapWorkFTLT75kB:
		GapWorkFTLT75kH:
		GapWorkFTLT75kAIOM:

		PctEmployedMngmt_:
		PctEmployedMngmtW:
		PctEmployedMngmtB:
		PctEmployedMngmtH:
		PctEmployedMngmtAIOM:

		PctEmployedServ_:
		PctEmployedServW:
		PctEmployedServB:
		PctEmployedServH:
		PctEmployedServAIOM:

		PctEmployedSales_:
		PctEmployedSalesW:
		PctEmployedSalesB:
		PctEmployedSalesH:
		PctEmployedSalesAIOM:

		PctEmployedNatRes_:
		PctEmployedNatResW:
		PctEmployedNatResB:
		PctEmployedNatResH:
		PctEmployedNatResAIOM:

		PctEmployedProd_:
		PctEmployedProdW:
		PctEmployedProdB:
		PctEmployedProdH:
		PctEmployedProdAIOM:

		PctOwnerOccupiedHU_:
		PctOwnerOccupiedHUW:
		PctOwnerOccupiedHUB:
		PctOwnerOccupiedHUH:
		PctOwnerOccupiedHUAIOM:

		GapOwnerOccupiedHUB:
		GapOwnerOccupiedHUH:
		GapOwnerOccupiedHUAIOM:
	 	;

	id ward2012; 
run; 


proc export data=equity.profile_tabs_ACS
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ACS.csv"
	dbms=csv replace;
	run;

** Register metadata **;

%Dc_update_meta_file(
      ds_lib=Equity,
      ds_name=profile_tabs_ACS,
	  creator=L Hendey and S Diby,
      creator_process=profile_tabs_ACS.sas,
      restrictions=None
      )
