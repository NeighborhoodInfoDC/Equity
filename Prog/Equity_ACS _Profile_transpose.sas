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
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )


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
           PctEmployed16to64W: Pct16andOverEmployedW:
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

data city_ward_WR (drop=cNum: cPct: cPop: _make_profile);
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

	Gap16andOverEmployedB_2010_14=cPct16andOverEmployedW_2010_14/100*Pop16andOverYearsB_2010_14-Pop16andOverEmployedB_2010_14;
	Gap16andOverEmployedW_2010_14=cPct16andOverEmployedW_2010_14/100*Pop16andOverYearsW_2010_14-Pop16andOverEmployedW_2010_14;
	Gap16andOverEmployedH_2010_14=cPct16andOverEmployedW_2010_14/100*Pop16andOverYearsH_2010_14-Pop16andOverEmployedH_2010_14;
	Gap16andOverEmployAIOM_2010_14=cPct16andOverEmployedW_2010_14/100*Pop16andOverYearsAIOM_2010_14-Pop16andOverEmployAIOM_2010_14;

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

proc transpose data=city_ward_WR out=transposed_data; 
var PctBlackNonHispBridge: PctWhiteNonHispBridge:
	PctHisp: PctAsnPINonHispBridge: PctOth:
	PctAloneB: PctAloneW: PctAloneH: PctAloneA_:
	PctAloneI_: PctAloneO: PctAloneM: PctAloneIOM: PctAloneAIOM:

	PctForeignBorn: PctNativeBorn: PctOthLang: 

	PctPopUnder18Years_: PctPopUnder18YearsW_: 
	PctPopUnder18YearsB_: PctPopUnder18YearsH_:
	PctPopUnder18YearsAIOM_:

	PctPop18_34Years_: PctPop18_34YearsW_: 
	PctPop18_34YearsB_: PctPop18_34YearsH_:
	PctPop18_34YearsAIOM_:

	PctPop35_64Years_: PctPop35_64YearsW_: 
	PctPop35_64YearsB_: PctPop35_64YearsH_:
	PctPop35_64YearsAIOM_:

	PctPop65andOverYears: PctPop65andOverYrs:
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

	PctPoorPersons_: 
	PctPoorPersonsW: GapPoorPersonsW:
	PctPoorPersonsB: GapPoorPersonsB:
	PctPoorPersonsH: GapPoorPersonsH:
	PctPoorPersonsAIOM: GapPoorPersonsAIOM:
	PctPoorPersonsFB: GapPoorPersonsFB:

	PctPoorChildren_: 
	PctPoorChildrenW: GapPoorChildrenW:
	PctPoorChildrenB: GapPoorChildrenB:
	PctPoorChildrenH: GapPoorChildrenH:
	PctPoorChildrenAIOM: GapPoorChildrenAIOM:

	PctFamilyLT75000_: 
	PctFamilyLT75000W: GapFamilyLT75000W: 
	PctFamilyLT75000B: GapFamilyLT75000B: 
	PctFamilyLT75000H: GapFamilyLT75000H: 
	PctFamilyLT75000AIOM: GapFamilyLT75000AIOM: 

	PctFamilyGT200000_:
	PctFamilyGT200000W: GapFamilyGT200000W: 
	PctFamilyGT200000B: GapFamilyGT200000B: 
	PctFamilyGT200000H: GapFamilyGT200000H: 
	PctFamilyGT200000AIOM: GapFamilyGT200000AIOM: 

	AvgHshldIncAdj_: 
	AvgHshldIncAdjW: GapAvgHshldIncAdjW:
	AvgHshldIncAdjB: GapAvgHshldIncAdjB:
	AvgHshldIncAdjH: GapAvgHshldIncAdjH:
	AvgHshldIncAdjAIOM: GapAvgHshldIncAdjAIOM:

	Pct16andOverEmployed_: 
	Pct16andOverEmployedW: Gap16andOverEmployedW:
	Pct16andOverEmployedB: Gap16andOverEmployedB:
	Pct16andOverEmployedH: Gap16andOverEmployedH:
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

data equity.profile_tabs_ACS (where=(category ~=.));
	set transposed_data;

black=index(_name_, "B_2010_14");
if black=0 then black=index(_name_,"B_m_2010_14");

white=index(_name_, "W_2010_14");
if white=0 then white=index(_name_,"W_m_2010_14");

hispanic=index(_name_, "H_2010_14");
if hispanic=0 then hispanic=index(_name_,"H_m_2010_14");

AIOM=index(_name_, "AIOM_2010_14");
if AIOM=0 then AIOM=index(_name_,"AIOM_m_2010_14");

if black > 0 then category=5;
if white > 0 then category=2;
if hispanic > 0 then category=4; 
if AIOM  > 0 then category=6; 

 if _name_ in ("PctWhiteNonHispBridge_2010_14") then category=2;
 if _name_ in ("PctBlackNonHispBridge_2010_14") then category=5;
 if _name_ in ("PctHisp_2010_14") then category=4;
 if _name_ in ("PctAsnPINonHispBridge_2010_14") then category=0;
 if _name_ in ("PctOth_2010_14") then category=0;

*looks like there are some you'll have to fix individually;
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

run;

proc export data=equity.profile_tabs_ACS
	outfile="D:\DCDATA\Libraries\Equity\Prog\profile_tabs_ACS.csv"
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

