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

%let racelist=W B H AIOM;
%let racename= NH-White Black-Alone Hispanic All-Other;

%macro rename(data);
/** First, create a data set with the list of variables in your input data set **/

proc contents data=&data out=_contents noprint;

/** Then, turn the list into a macro variable list: **/

proc sql noprint;
  select name 
  into :varlist separated by ' '
  from _contents
  ;
quit;

/** Next, you need to process each var in the list into a rename statement. **/

%let i = 1;
%let v = %scan( &varlist, &i );
%let rename = ;

%do %while ( &v ~= );
  
  %let rename = &rename &v=c&v.;

  %let i = %eval( &i + 1 );
  %let v = %scan( &varlist, &i );

%end;

/** Finally, you apply the rename statement to your data set. **/

data &data._new;
  set &data;
  rename &rename ;
run;
%mend rename;

data city_ward;
	set equity.equity_profile_city
			equity.equity_profile_wd12;

			if city=1 then ward2012=0;
			_make_profile=1;

run; 

*Add gap calculation;

data whiterates;
	set equity.equity_profile_city 
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

data city_ward_WR (drop=cPct: _make_profile);
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

data equity.profile_tabs_ACS_suppress;
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
	%suppress_gaps;
	%suppress_gaps_fb;
	%decimal_convert;

run;


proc transpose data=equity.profile_tabs_ACS_suppress out=equity.profile_tabs_ACS; 
var PctBlackNonHispBridge: PctWhiteNonHispBridge:
	PctHisp: PctAsnPINonHispBridge: PctOtherRace: PctOthRace:
	PctAloneB: PctAloneW: PctAloneH: PctAloneA_:
	PctAloneI_: PctAloneO: PctAloneM: PctAloneIOM: PctAloneAIOM:

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
	Pct25andOverWoutHSW: Gap25andOverWoutHSW:
	Pct25andOverWoutHSB: Gap25andOverWoutHSB:
	Pct25andOverWoutHSH: Gap25andOverWoutHSH:
	Pct25andOverWoutHSAIOM: Gap25andOverWoutHSAIOM:
	Pct25andOverWoutHSFB: Gap25andOverWoutHSFB:
	Pct25andOverWoutHSNB: Gap25andOverWoutHSNB:

	Pct25andOverWHS_:  
	Pct25andOverWHSW: Gap25andOverWHSW:  
	Pct25andOverWHSB: Gap25andOverWHSB:  
	Pct25andOverWHSH: Gap25andOverWHSH:  
	Pct25andOverWHSAIOM: Gap25andOverWHSAIOM:  
	Pct25andOverWHSFB: Gap25andOverWHSFB:  
	Pct25andOverWHSNB: Gap25andOverWHSNB:  

	Pct25andOverWSC_: 
	Pct25andOverWSCW: Gap25andOverWSCW:
	Pct25andOverWSCB: Gap25andOverWSCB:
	Pct25andOverWSCH: Gap25andOverWSCH:
	Pct25andOverWSCAIOM: Gap25andOverWSCAIOM:
	Pct25andOverWSCFB: Gap25andOverWSCFB:
	Pct25andOverWSCNB: Gap25andOverWSCNB:

	AvgHshldIncAdj_: 
	AvgHshldIncAdjW: GapAvgHshldIncAdjW:
	AvgHshldIncAdjB: GapAvgHshldIncAdjB:
	AvgHshldIncAdjH: GapAvgHshldIncAdjH:
	AvgHshldIncAdjAIOM_2010_14 GapAvgHshldIncAdjAIOM:

	PctFamilyGT200000_:
	PctFamilyGT200000W: GapFamilyGT200000W: 
	PctFamilyGT200000B: GapFamilyGT200000B: 
	PctFamilyGT200000H: GapFamilyGT200000H: 
	PctFamilyGT200000AIOM: GapFamilyGT200000AIOM: 

	PctFamilyLT75000_: 
	PctFamilyLT75000W: GapFamilyLT75000W: 
	PctFamilyLT75000B: GapFamilyLT75000B: 
	PctFamilyLT75000H: GapFamilyLT75000H: 
	PctFamilyLT75000AIOM: GapFamilyLT75000AIOM: 

	PctPoorPersons_: 
	PctPoorPersonsW: GapPoorPersonsW:
	PctPoorPersonsB: GapPoorPersonsB:
	PctPoorPersonsH: GapPoorPersonsH:
	PctPoorPersonsAIOM: GapPoorPersonsAIOM:
	PctPoorPersonsFB: GapPoorPersonsFB:

	/*note that child poverty gaps have been excluded from output
	because White child poverty rate is near to 0*/

	PctPoorChildren_: 
	PctPoorChildrenW:
	PctPoorChildrenB:
	PctPoorChildrenH:
	PctPoorChildrenAIOM:

	Pct16andOverEmploy_: 
	Pct16andOverEmployW: Gap16andOverEmployW:
	Pct16andOverEmployB: Gap16andOverEmployB:
	Pct16andOverEmployH: Gap16andOverEmployH:
	Pct16andOverEmployAIOM: Gap16andOverEmployAIOM:

	PctEmployed16to64_: 
	PctEmployed16to64W: GapEmployed16to64W:
	PctEmployed16to64B: GapEmployed16to64B:
	PctEmployed16to64H: GapEmployed16to64H:
	PctEmployed16to64AIOM: GapEmployed16to64AIOM:

	PctUnemployed_: 
	PctUnemployedW: GapUnemployedW:
	PctUnemployedB: GapUnemployedB:
	PctUnemployedH: GapUnemployedH:
	PctUnemployedAIOM: GapUnemployedAIOM:

	Pct16andOverWages_: 
	Pct16andOverWagesW: Gap16andOverWagesW:
	Pct16andOverWagesB: Gap16andOverWagesB:
	Pct16andOverWagesH: Gap16andOverWagesH:
	Pct16andOverWagesAIOM: Gap16andOverWagesAIOM:

	Pct16andOverWorkFT_: 
	Pct16andOverWorkFTW: Gap16andOverWorkFTW:
	Pct16andOverWorkFTB: Gap16andOverWorkFTB:
	Pct16andOverWorkFTH: Gap16andOverWorkFTH:
	Pct16andOverWorkFTAIOM: Gap16andOverWorkFTAIOM:

	PctWorkFTLT35k_: 
	PctWorkFTLT35kW: GapWorkFTLT35kW:
	PctWorkFTLT35kB: GapWorkFTLT35kB:
	PctWorkFTLT35kH: GapWorkFTLT35kH:
	PctWorkFTLT35kAIOM: GapWorkFTLT35kAIOM:

	PctWorkFTLT75k_: 
	PctWorkFTLT75kW: GapWorkFTLT75kW:
	PctWorkFTLT75kB: GapWorkFTLT75kB:
	PctWorkFTLT75kH: GapWorkFTLT75kH:
	PctWorkFTLT75kAIOM: GapWorkFTLT75kAIOM:

	PctEmployedMngmt_: 
	PctEmployedMngmtW: GapEmployedMngmtW:
	PctEmployedMngmtB: GapEmployedMngmtB:
	PctEmployedMngmtH: GapEmployedMngmtH:
	PctEmployedMngmtAIOM: GapEmployedMngmtAIOM:

	PctEmployedServ_: 
	PctEmployedServW: GapEmployedServW:
	PctEmployedServB: GapEmployedServB:
	PctEmployedServH: GapEmployedServH:
	PctEmployedServAIOM: GapEmployedServAIOM:

	PctEmployedSales_: 
	PctEmployedSalesW: GapEmployedSalesW:
	PctEmployedSalesB: GapEmployedSalesB:
	PctEmployedSalesH: GapEmployedSalesH:
	PctEmployedSalesAIOM: GapEmployedSalesAIOM:

	PctEmployedNatRes_: 
	PctEmployedNatResW: GapEmployedNatResW:
	PctEmployedNatResB: GapEmployedNatResB:
	PctEmployedNatResH: GapEmployedNatResH:
	PctEmployedNatResAIOM: GapEmployedNatResAIOM:

	PctEmployedProd_: 
	PctEmployedProdW: GapEmployedProdW:
	PctEmployedProdB: GapEmployedProdB:
	PctEmployedProdH: GapEmployedProdH:
	PctEmployedProdAIOM: GapEmployedProdAIOM:

	PctOwnerOccupiedHU_: 
	PctOwnerOccupiedHUW: GapOwnerOccupiedHUW:
	PctOwnerOccupiedHUB: GapOwnerOccupiedHUB:
	PctOwnerOccupiedHUH: GapOwnerOccupiedHUH:
	PctOwnerOccupiedHUAIOM: GapOwnerOccupiedHUAIOM:

 ;
id ward2012; 
run; 


proc transpose data=equity.profile_tabs_ACS_suppress out=equity.profile_tabs_ACS_dec; 
var nPctBlackNonHispBridge: nPctWhiteNonHispBridge:
	nPctHisp: nPctAsnPINonHispBridge: nPctOthRace:
	nPctAloneB: nPctAloneW: nPctAloneH: nPctAloneA_:
	nPctAloneI_: nPctAloneO: nPctAloneM: nPctAloneIOM: nPctAloneAIOM:

	nPctForeignBorn_: nPctNativeBorn: 

	nPctForeignBornB: nPctForeignBornW:
	nPctForeignBornH: nPctForeignBornAIOM:

	nPctOthLang:

	nPctPopUnder18Years_: 
	nPctPopUnder18YearsW_: nPctPopUnder18YrsW_:
	nPctPopUnder18YearsB_: nPctPopUnder18YrsB_:
	nPctPopUnder18YearsH_: nPctPopUnder18YrsH_:
	nPctPopUnder18YearsAIOM_: nPctPopUnder18YrsAIOM_:

	nPctPop18_34Years_: nPctPop18_34YearsW_: 
	nPctPop18_34YearsB_: nPctPop18_34YearsH_:
	nPctPop18_34YearsAIOM_:

	nPctPop35_64Years_: nPctPop35_64YearsW_: 
	nPctPop35_64YearsB_: nPctPop35_64YearsH_:
	nPctPop35_64YearsAIOM_:

	nPctPop65andOverYears_: nPctPop65andOverYrs_:
	nPctPop65andOverYrsW: nPctPop65andOvrYrsW:
	nPctPop65andOverYrsB: nPctPop65andOvrYrsB:
	nPctPop65andOverYrsH: nPctPop65andOvrYrsH:
	nPctPop65andOverYrsAIOM: nPctPop65andOvrYrsAIOM:

	nPct25andOverWoutHS_: 
	nPct25andOverWoutHSW: Pct25andOvrWoutHSW: nGap25andOverWoutHSW:
	nPct25andOverWoutHSB: Pct25andOvrWoutHSB: nGap25andOverWoutHSB:
	nPct25andOverWoutHSH: Pct25andOvrWoutHSH: nGap25andOverWoutHSH:
	nPct25andOverWoutHSAIOM: Pct25andOvrWoutHSAIOM: nGap25andOverWoutHSAIOM:
	nPct25andOverWoutHSFB: nGap25andOverWoutHSFB:
	nPct25andOverWoutHSNB: nGap25andOverWoutHSNB:

	nPct25andOverWHS_:  
	nPct25andOverWHSW: nGap25andOverWHSW:  
	nPct25andOverWHSB: nGap25andOverWHSB:  
	nPct25andOverWHSH: nGap25andOverWHSH:  
	nPct25andOverWHSAIOM: nGap25andOverWHSAIOM:  
	nPct25andOverWHSFB: nGap25andOverWHSFB:  
	nPct25andOverWHSNB: nGap25andOverWHSNB:  

	nPct25andOverWSC_: 
	nPct25andOverWSCW: nGap25andOverWSCW:
	nPct25andOverWSCB: nGap25andOverWSCB:
	nPct25andOverWSCH: nGap25andOverWSCH:
	nPct25andOverWSCAIOM: nGap25andOverWSCAIOM:
	nPct25andOverWSCFB: nGap25andOverWSCFB:
	nPct25andOverWSCNB: nGap25andOverWSCNB:

	nAvgHshldIncAdj_: 
	nAvgHshldIncAdjW: nGapnAvgHshldIncAdjW:
	nAvgHshldIncAdjB: nGapnAvgHshldIncAdjB:
	nAvgHshldIncAdjH: nGapnAvgHshldIncAdjH:
	nAvgHshldIncAdjAIOM_2010_14 nGapnAvgHshldIncAdjAIOM:

	nPctFamilyGT200000_:
	nPctFamilyGT200000W: nGapFamilyGT200000W: 
	nPctFamilyGT200000B: nGapFamilyGT200000B: 
	nPctFamilyGT200000H: nGapFamilyGT200000H: 
	nPctFamilyGT200000AIOM: nGapFamilyGT200000AIOM: 

	nPctFamilyLT75000_: 
	nPctFamilyLT75000W: nGapFamilyLT75000W: 
	nPctFamilyLT75000B: nGapFamilyLT75000B: 
	nPctFamilyLT75000H: nGapFamilyLT75000H: 
	nPctFamilyLT75000AIOM: nGapFamilyLT75000AIOM: 

	nPctPoorPersons_: 
	nPctPoorPersonsW: nGapPoorPersonsW:
	nPctPoorPersonsB: nGapPoorPersonsB:
	nPctPoorPersonsH: nGapPoorPersonsH:
	nPctPoorPersonsAIOM: nGapPoorPersonsAIOM:
	nPctPoorPersonsFB: nGapPoorPersonsFB:

	/*note that child poverty gaps have been excluded from output
	because White child poverty rate is near to 0*/

	nPctPoorChildren_: 
	nPctPoorChildrenW:
	nPctPoorChildrenB:
	nPctPoorChildrenH:
	nPctPoorChildrenAIOM:

	nPct16andOverEmploy_: 
	nPct16andOverEmployW: nPct16andOverEmplyW: nGap16andOverEmployW:
	nPct16andOverEmployB: nPct16andOverEmplyB: nGap16andOverEmployB:
	nPct16andOverEmployH: nPct16andOverEmplyH: nGap16andOverEmployH:
	nPct16andOverEmployAIOM: nPct16andOverEmplyAIOM: nGap16andOverEmployAIOM:

	nPctEmployed16to64_: 
	nPctEmployed16to64W: nGapEmployed16to64W:
	nPctEmployed16to64B: nGapEmployed16to64B:
	nPctEmployed16to64H: nGapEmployed16to64H:
	nPctEmployed16to64AIOM: nGapEmployed16to64AIOM:

	nPctUnemployed_: 
	nPctUnemployedW: nGapUnemployedW:
	nPctUnemployedB: nGapUnemployedB:
	nPctUnemployedH: nGapUnemployedH:
	nPctUnemployedAIOM: nGapUnemployedAIOM:

	nPct16andOverWages_: 
	nPct16andOverWagesW: nGap16andOverWagesW:
	nPct16andOverWagesB: nGap16andOverWagesB:
	nPct16andOverWagesH: nGap16andOverWagesH:
	nPct16andOverWagesAIOM: nGap16andOverWagesAIOM:

	nPct16andOverWorkFT_: 
	nPct16andOverWorkFTW: nPct16andOverWrkFTW: nGap16andOverWorkFTW:
	nPct16andOverWorkFTB: nPct16andOverWrkFTB: nGap16andOverWorkFTB:
	nPct16andOverWorkFTH: nPct16andOverWrkFTH: nGap16andOverWorkFTH:
	nPct16andOverWorkFTAIOM: nPct16andOverWrkFTAIOM: nGap16andOverWorkFTAIOM:

	nPctWorkFTLT35k_: 
	nPctWorkFTLT35kW: nGapWorkFTLT35kW:
	nPctWorkFTLT35kB: nGapWorkFTLT35kB:
	nPctWorkFTLT35kH: nGapWorkFTLT35kH:
	nPctWorkFTLT35kAIOM: nGapWorkFTLT35kAIOM:

	nPctWorkFTLT75k_: 
	nPctWorkFTLT75kW: nGapWorkFTLT75kW:
	nPctWorkFTLT75kB: nGapWorkFTLT75kB:
	nPctWorkFTLT75kH: nGapWorkFTLT75kH:
	nPctWorkFTLT75kAIOM: nGapWorkFTLT75kAIOM:

	nPctEmployedMngmt_: 
	nPctEmployedMngmtW: nGapEmployedMngmtW:
	nPctEmployedMngmtB: nGapEmployedMngmtB:
	nPctEmployedMngmtH: nGapEmployedMngmtH:
	nPctEmployedMngmtAIOM: nGapEmployedMngmtAIOM:

	nPctEmployedServ_: 
	nPctEmployedServW: nGapEmployedServW:
	nPctEmployedServB: nGapEmployedServB:
	nPctEmployedServH: nGapEmployedServH:
	nPctEmployedServAIOM: nGapEmployedServAIOM:

	nPctEmployedSales_: 
	nPctEmployedSalesW: nGapEmployedSalesW:
	nPctEmployedSalesB: nGapEmployedSalesB:
	nPctEmployedSalesH: nGapEmployedSalesH:
	nPctEmployedSalesAIOM: nGapEmployedSalesAIOM:

	nPctEmployedNatRes_: 
	nPctEmployedNatResW: nGapEmployedNatResW:
	nPctEmployedNatResB: nGapEmployedNatResB:
	nPctEmployedNatResH: nGapEmployedNatResH:
	nPctEmployedNatResAIOM: nGapEmployedNatResAIOM:

	nPctEmployedProd_: 
	nPctEmployedProdW: nGapEmployedProdW:
	nPctEmployedProdB: nGapEmployedProdB:
	nPctEmployedProdH: nGapEmployedProdH:
	nPctEmployedProdAIOM: nGapEmployedProdAIOM:

	nPctOwnerOccupiedHU_: 
	nPctOwnerOccupiedHUW: nPctOwnerOccpiedHUW: nGapOwnerOccupiedHUW:
	nPctOwnerOccupiedHUB: nPctOwnerOccpiedHUB: nGapOwnerOccupiedHUB:
	nPctOwnerOccupiedHUH: nPctOwnerOccpiedHUH: nGapOwnerOccupiedHUH:
	nPctOwnerOccupiedHUAIOM: nPctOwnerOccpiedHUAIOM: nGapOwnerOccupiedHUAIOM:

 ;
id ward2012; 
run; 


/*data equity.profile_tabs_ACS (where=(category ~=.));
	set transposed_data;

total=index(_name_, "_2010_14");
if total=0 then total=index(_name_, "_m_2010_14");

black=index(_name_, "B_2010_14");
if black=0 then black=index(_name_,"B_m_2010_14");

white=index(_name_, "W_2010_14");
if white=0 then white=index(_name_,"W_m_2010_14");

hispanic=index(_name_, "H_2010_14");
if hispanic=0 then hispanic=index(_name_,"H_m_2010_14");

AIOM=index(_name_, "AIOM_2010_14");
if AIOM=0 then AIOM=index(_name_,"AIOM_m_2010_14");

if total >0 then category=1;
if black > 0 then category=5;
if white > 0 then category=2;
if hispanic > 0 then category=4; 
if AIOM  > 0 then category=6; 

 if _name_ in ("PctWhiteNonHispBridge_2010_14") then category=2;
 if _name_ in ("PctWhiteNonHispBridge_m_2010_14") then category=2;
 if _name_ in ("PctBlackNonHispBridge_2010_14") then category=5;
 if _name_ in ("PctBlackNonHispBridge_m_2010_14") then category=5;
 if _name_ in ("PctHisp_2010_14") then category=4;
 if _name_ in ("PctHisp_m_2010_14") then category=4;
 if _name_ in ("PctAsnPINonHispBridge_2010_14") then category=0;
 if _name_ in ("PctAsnPINonHispBridge_m_2010_14") then category=0;
 if _name_ in ("PctOth_2010_14") then category=0;
 if _name_ in ("PctOth_m_2010_14") then category=0;
 if _name_ in ("PctForeignBorn_2010_14") then category=0;
 if _name_ in ("PctForeignBorn_m_2010_14") then category=0;
 if _name_ in ("PctNativeBorn_2010_14") then category=0;
 if _name_ in ("PctNativeBorn_m_2010_14") then category=0;
 if _name_ in ("PctOthLang_2010_14") then category=0;
 if _name_ in ("PctOthLang_m_2010_14") then category=0;

 if _name_ ="Gap25andOverWoutHSFB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWoutHSFB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWoutHSFB_m_2010_14" then do; black=0; category=.; end;
 if _name_ ="Gap25andOverWoutHSNB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWoutHSNB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWoutHSNB_m_2010_14" then do; black=0; category=.; end;
 if _name_ ="Gap25andOverWHSFB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWHSFB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWHSFB_m_2010_14" then do; black=0; category=.; end;
 if _name_ ="Gap25andOverWHSNB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWHSNB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWHSNB_m_2010_14" then do; black=0; category=.; end;
 if _name_ ="Gap25andOverWSCFB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWSCFB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWSCFB_m_2010_14" then do; black=0; category=.; end;
 if _name_ ="Gap25andOverWSCNB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWSCNB_2010_14" then do; black=0; category=.; end;
 if _name_ ="Pct25andOverWSCNB_m_2010_14" then do; black=0; category=.; end;


order=.;

run;*/

proc export data=equity.profile_tabs_ACS
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ACS.csv"
	dbms=csv replace;
	run;

proc export data=equity.profile_tabs_ACS_dec
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ACS_comms.csv"
	dbms=csv replace;
	run;

  proc format;
  	value category
   	1= "Total"
  	2= "Non-Hispanic White"
    3= "Non-Hispanic All Other"
	4= "Hispanic"
	5= "Black Alone"
 	6= "Asian, American Indian, Other Alone and Multiple Race"
	7= "White Alone"
 	8= "Foreign Born";

