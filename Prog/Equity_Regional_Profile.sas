/**************************************************************************
 Program:  Equity_Regional_Profile.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  07/28/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Creates calculated statistics for ACS by geography to feed into regional Equity profile. 

 Modifications: 9/23/17 LH Fixed macros that were referring to variables used in the district level analysis
						   and created new regional ones.
	 	2/09/20 LH Update for 2014-18 ACS and add &_years to run for various years.
		12/22/20 LH Update for 2015-19 ACS and \\sas1\
		02/24/22 LH Update to add IOM indicators
		02/28/22 LH Add additional counties - Charles and Frederick, changed output data name, add finalize data set macro
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
%let y_lbl = %sysfunc( translate( &_years., '-', '_' ) );
%let revisions=New file. Data are rounded to nearest integer (except unemployment);


** County formats **;
proc format;
value $county
	"11001" = "Washington DC"
	"24017" = "Charles" 
	"24021" = "Frederick" 
	"24031" = "Montgomery"
	"24033" = "Prince Georges"
	"51510" = "Alexandria"
	"51013" = "Arlington"
	"51610" = "Falls Church City"
	"51059" = "Fairfax"
	"51600" = "Fairfax City"
	"51107" = "Loudoun"
	"51153" = "Prince William"
	"51683" = "Manassas City"
	"51685" = "Manassas Park City"
	;
run;


** Combined county data **;
data allcounty;
	set equity.Profile_acs_&_years._dc_regcnt 
		equity.Profile_acs_&_years._md_regcnt 
		equity.Profile_acs_&_years._va_regcnt;
	if county in ("11001","24017","24021","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685");
	format county county.;

	
	%suppress_vars;
	%suppress_vars_fb;

	** Calculate and label gaps **;
	Gap25andOverWoutHSB_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsB_&_years.-Pop25andOverWoutHSB_&_years.;
	Gap25andOverWoutHSW_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsW_&_years.-Pop25andOverWoutHSW_&_years.;
	Gap25andOverWoutHSH_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsH_&_years.-Pop25andOverWoutHSH_&_years.;
	Gap25andOverWoutHSA_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsA_&_years.-Pop25andOverWoutHSA_&_years.;
	Gap25andOverWoutHSIOM_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWoutHSIOM_&_years.;
	Gap25andOverWoutHSAIOM_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsAIOM_&_years.-Pop25andOverWoutHSAIOM_&_years.;
	Gap25andOverWoutHSFB_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsFB_&_years.-Pop25andOverWoutHSFB_&_years.;
	Gap25andOverWoutHSNB_&_years.=Pct25andOverWoutHSW_&_years./100*Pop25andOverYearsNB_&_years.-Pop25andOverWoutHSNB_&_years.;

	Gap25andOverWHSB_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsB_&_years.-Pop25andOverWHSB_&_years.;
	Gap25andOverWHSW_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsW_&_years.-Pop25andOverWHSW_&_years.;
	Gap25andOverWHSH_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsH_&_years.-Pop25andOverWHSH_&_years.;
	Gap25andOverWHSA_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsA_&_years.-Pop25andOverWHSA_&_years.;
	Gap25andOverWHSIOM_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWHSIOM_&_years.;
	Gap25andOverWHSAIOM_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsAIOM_&_years.-Pop25andOverWHSAIOM_&_years.;
	Gap25andOverWHSFB_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsFB_&_years.-Pop25andOverWHSFB_&_years.;
	Gap25andOverWHSNB_&_years.=Pct25andOverWHSW_&_years./100*Pop25andOverYearsNB_&_years.-Pop25andOverWHSNB_&_years.;

	Gap25andOverWSCB_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsB_&_years.-Pop25andOverWSCB_&_years.;
	Gap25andOverWSCW_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsW_&_years.-Pop25andOverWSCW_&_years.;
	Gap25andOverWSCH_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsH_&_years.-Pop25andOverWSCH_&_years.;
	Gap25andOverWSCA_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsA_&_years.-Pop25andOverWSCA_&_years.;
	Gap25andOverWSCIOM_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWSCIOM_&_years.;
	Gap25andOverWSCAIOM_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsAIOM_&_years.-Pop25andOverWSCAIOM_&_years.;
	Gap25andOverWSCFB_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsFB_&_years.-Pop25andOverWSCFB_&_years.;
	Gap25andOverWSCNB_&_years.=Pct25andOverWSCW_&_years./100*Pop25andOverYearsNB_&_years.-Pop25andOverWSCNB_&_years.;

	GapPoorPersonsB_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefinedB_&_years.-PopPoorPersonsB_&_years.;
	GapPoorPersonsW_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefinedW_&_years.-PopPoorPersonsW_&_years.;
	GapPoorPersonsH_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefinedH_&_years.-PopPoorPersonsH_&_years.;
	GapPoorPersonsA_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefinedA_&_years.-PopPoorPersonsA_&_years.;
	GapPoorPersonsIOM_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefIOM_&_years.-PopPoorPersonsIOM_&_years.;
	GapPoorPersonsAIOM_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefAIOM_&_years.-PopPoorPersonsAIOM_&_years.;
	GapPoorPersonsFB_&_years.=PctPoorPersonsW_&_years./100*PersonsPovertyDefinedFB_&_years.-PopPoorPersonsFB_&_years.;


	GapPoorChildrenB_&_years.=PctPoorChildrenW_&_years./100*ChildrenPovertyDefinedB_&_years.-PopPoorChildrenB_&_years.;
	GapPoorChildrenW_&_years.=PctPoorChildrenW_&_years./100*ChildrenPovertyDefinedW_&_years.-PopPoorChildrenW_&_years.;
	GapPoorChildrenH_&_years.=PctPoorChildrenW_&_years./100*ChildrenPovertyDefinedH_&_years.-PopPoorChildrenH_&_years.;
	GapPoorChildrenA_&_years.=PctPoorChildrenW_&_years./100*ChildrenPovertyDefinedA_&_years.-PopPoorChildrenA_&_years.;
	GapPoorChildrenIOM_&_years.=PctPoorChildrenW_&_years./100*ChildrenPovertyDefIOM_&_years.-PopPoorChildrenIOM_&_years.;
	GapPoorChildrenAIOM_&_years.=PctPoorChildrenW_&_years./100*ChildrenPovertyDefAIOM_&_years.-PopPoorChildrenAIOM_&_years.;


	GapFamilyLT75000B_&_years.=PctFamilyLT75000W_&_years./100*NumFamiliesB_&_years.-FamIncomeLT75kB_&_years.;
	GapFamilyLT75000W_&_years.=PctFamilyLT75000W_&_years./100*NumFamiliesW_&_years.-FamIncomeLT75kW_&_years.;
	GapFamilyLT75000H_&_years.=PctFamilyLT75000W_&_years./100*NumFamiliesH_&_years.-FamIncomeLT75kH_&_years.;
	GapFamilyLT75000A_&_years.=PctFamilyLT75000W_&_years./100*NumFamiliesA_&_years.-FamIncomeLT75kA_&_years.;
	GapFamilyLT75000IOM_&_years.=PctFamilyLT75000W_&_years./100*NumFamiliesIOM_&_years.-FamIncomeLT75kIOM_&_years.;
	GapFamilyLT75000AIOM_&_years.=PctFamilyLT75000W_&_years./100*NumFamiliesAIOM_&_years.-FamIncomeLT75kAIOM_&_years.;


	GapFamilyGT200000B_&_years.=PctFamilyGT200000W_&_years./100*NumFamiliesB_&_years.-FamIncomeGT200kB_&_years.;
	GapFamilyGT200000W_&_years.=PctFamilyGT200000W_&_years./100*NumFamiliesW_&_years.-FamIncomeGT200kW_&_years.;
	GapFamilyGT200000H_&_years.=PctFamilyGT200000W_&_years./100*NumFamiliesH_&_years.-FamIncomeGT200kH_&_years.;
	GapFamilyGT200000A_&_years.=PctFamilyGT200000W_&_years./100*NumFamiliesA_&_years.-FamIncomeGT200kA_&_years.;
	GapFamilyGT200000IOM_&_years.=PctFamilyGT200000W_&_years./100*NumFamiliesIOM_&_years.-FamIncomeGT200kIOM_&_years.;
	GapFamilyGT200000AIOM_&_years.=PctFamilyGT200000W_&_years./100*NumFamiliesAIOM_&_years.-FamIncomeGT200kAIOM_&_years.;


	GapAvgHshldIncAdjB_&_years.=AvgHshldIncAdjW_&_years./100*NumHshldsB_&_years.-AggHshldIncomeB_&_years.;
	GapAvgHshldIncAdjW_&_years.=AvgHshldIncAdjW_&_years./100*NumHshldsW_&_years.-AggHshldIncomeW_&_years.;
	GapAvgHshldIncAdjH_&_years.=AvgHshldIncAdjW_&_years./100*NumHshldsH_&_years.-AggHshldIncomeH_&_years.;
	GapAvgHshldIncAdjA_&_years.=AvgHshldIncAdjW_&_years./100*NumHshldsA_&_years.-AggHshldIncomeA_&_years.;
	GapAvgHshldIncAdjIOM_&_years.=AvgHshldIncAdjW_&_years./100*NumHshldsIOM_&_years.-AggHshldIncomeIOM_&_years.;
	GapAvgHshldIncAdjAIOM_&_years.=AvgHshldIncAdjW_&_years./100*NumHshldsAIOM_&_years.-AggHshldIncomeAIOM_&_years.;


	GapEmployed16to64B_&_years.=PctEmployed16to64W_&_years./100*Pop16_64yearsB_&_years.-Pop16_64EmployedB_&_years.;
	GapEmployed16to64W_&_years.=PctEmployed16to64W_&_years./100*Pop16_64yearsW_&_years.-Pop16_64EmployedW_&_years.;
	GapEmployed16to64H_&_years.=PctEmployed16to64W_&_years./100*Pop16_64yearsH_&_years.-Pop16_64EmployedH_&_years.;
	GapEmployed16to64A_&_years.=PctEmployed16to64W_&_years./100*Pop16_64yearsA_&_years.-Pop16_64EmployedA_&_years.;
	GapEmployed16to64IOM_&_years.=PctEmployed16to64W_&_years./100*Pop16_64yearsIOM_&_years.-Pop16_64EmployedIOM_&_years.;
	GapEmployed16to64AIOM_&_years.=PctEmployed16to64W_&_years./100*Pop16_64yearsAIOM_&_years.-Pop16_64EmployedAIOM_&_years.;

	Gap16andOverEmployB_&_years.=Pct16andOverEmployW_&_years./100*Pop16andOverYearsB_&_years.-Pop16andOverEmployB_&_years.;
	Gap16andOverEmployW_&_years.=Pct16andOverEmployW_&_years./100*Pop16andOverYearsW_&_years.-Pop16andOverEmployW_&_years.;
	Gap16andOverEmployH_&_years.=Pct16andOverEmployW_&_years./100*Pop16andOverYearsH_&_years.-Pop16andOverEmployH_&_years.;
	Gap16andOverEmployA_&_years.=Pct16andOverEmployW_&_years./100*Pop16andOverYearsA_&_years.-Pop16andOverEmployA_&_years.;
	Gap16andOverEmployIOM_&_years.=Pct16andOverEmployW_&_years./100*Pop16andOverYearsIOM_&_years.-Pop16andOverEmployIOM_&_years.;
	Gap16andOverEmployAIOM_&_years.=Pct16andOverEmployW_&_years./100*Pop16andOverYearsAIOM_&_years.-Pop16andOverEmployAIOM_&_years.;

	GapUnemployedB_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceB_&_years.-PopUnemployedB_&_years.;
	GapUnemployedW_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceW_&_years.-PopUnemployedW_&_years.;
	GapUnemployedH_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceH_&_years.-PopUnemployedH_&_years.;
	GapUnemployedA_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceA_&_years.-PopUnemployedA_&_years.;
	GapUnemployedIOM_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceIOM_&_years.-PopUnemployedIOM_&_years.;
	GapUnemployedAIOM_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceAIOM_&_years.-PopUnemployedAIOM_&_years.;

	Gap16andOverWagesB_&_years.=Pct16andOverWagesW_&_years./100*Pop16andOverYearsB_&_years.-PopWorkEarnB_&_years.;
	Gap16andOverWagesW_&_years.=Pct16andOverWagesW_&_years./100*Pop16andOverYearsW_&_years.-PopWorkEarnW_&_years.;
	Gap16andOverWagesH_&_years.=Pct16andOverWagesW_&_years./100*Pop16andOverYearsH_&_years.-PopWorkEarnH_&_years.;
	Gap16andOverWagesA_&_years.=Pct16andOverWagesW_&_years./100*Pop16andOverYearsA_&_years.-PopWorkEarnA_&_years.;
	Gap16andOverWagesIOM_&_years.=Pct16andOverWagesW_&_years./100*Pop16andOverYearsIOM_&_years.-PopWorkEarnIOM_&_years.;
	Gap16andOverWagesAIOM_&_years.=Pct16andOverWagesW_&_years./100*Pop16andOverYearsAIOM_&_years.-PopWorkEarnAIOM_&_years.;

	Gap16andOverWorkFTB_&_years.=Pct16andOverWorkFTW_&_years./100*Pop16andOverYearsB_&_years.-PopWorkFTB_&_years.;
	Gap16andOverWorkFTW_&_years.=Pct16andOverWorkFTW_&_years./100*Pop16andOverYearsW_&_years.-PopWorkFTW_&_years.;
	Gap16andOverWorkFTH_&_years.=Pct16andOverWorkFTW_&_years./100*Pop16andOverYearsH_&_years.-PopWorkFTH_&_years.;
	Gap16andOverWorkFTA_&_years.=Pct16andOverWorkFTW_&_years./100*Pop16andOverYearsA_&_years.-PopWorkFTA_&_years.;
	Gap16andOverWorkFTIOM_&_years.=Pct16andOverWorkFTW_&_years./100*Pop16andOverYearsIOM_&_years.-PopWorkFTIOM_&_years.;
	Gap16andOverWorkFTAIOM_&_years.=Pct16andOverWorkFTW_&_years./100*Pop16andOverYearsAIOM_&_years.-PopWorkFTAIOM_&_years.;

	GapWorkFTLT35kB_&_years.=PctWorkFTLT35kW_&_years./100*PopWorkFTB_&_years.-PopWorkFTLT35KB_&_years.;
	GapWorkFTLT35kW_&_years.=PctWorkFTLT35kW_&_years./100*PopWorkFTW_&_years.-PopWorkFTLT35KW_&_years.;
	GapWorkFTLT35kH_&_years.=PctWorkFTLT35kW_&_years./100*PopWorkFTH_&_years.-PopWorkFTLT35KH_&_years.;
	GapWorkFTLT35kA_&_years.=PctWorkFTLT35kW_&_years./100*PopWorkFTA_&_years.-PopWorkFTLT35KA_&_years.;
	GapWorkFTLT35kIOM_&_years.=PctWorkFTLT35kW_&_years./100*PopWorkFTIOM_&_years.-PopWorkFTLT35KIOM_&_years.;
	GapWorkFTLT35kAIOM_&_years.=PctWorkFTLT35kW_&_years./100*PopWorkFTAIOM_&_years.-PopWorkFTLT35KAIOM_&_years.;

	GapWorkFTLT75kB_&_years.=PctWorkFTLT75kW_&_years./100*PopWorkFTB_&_years.-PopWorkFTLT75KB_&_years.;
	GapWorkFTLT75kW_&_years.=PctWorkFTLT75kW_&_years./100*PopWorkFTW_&_years.-PopWorkFTLT75KW_&_years.;
	GapWorkFTLT75kH_&_years.=PctWorkFTLT75kW_&_years./100*PopWorkFTH_&_years.-PopWorkFTLT75KH_&_years.;
	GapWorkFTLT75kA_&_years.=PctWorkFTLT75kW_&_years./100*PopWorkFTA_&_years.-PopWorkFTLT75KA_&_years.;
	GapWorkFTLT75kIOM_&_years.=PctWorkFTLT75kW_&_years./100*PopWorkFTIOM_&_years.-PopWorkFTLT75KIOM_&_years.;
	GapWorkFTLT75kAIOM_&_years.=PctWorkFTLT75kW_&_years./100*PopWorkFTAIOM_&_years.-PopWorkFTLT75KAIOM_&_years.;

	GapEmployedMngmtB_&_years.=PctEmployedMngmtW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedMngmtB_&_years.;
	GapEmployedMngmtW_&_years.=PctEmployedMngmtW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedMngmtW_&_years.;
	GapEmployedMngmtH_&_years.=PctEmployedMngmtW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedMngmtH_&_years.;
	GapEmployedMngmtA_&_years.=PctEmployedMngmtW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedMngmtA_&_years.;
	GapEmployedMngmtIOM_&_years.=PctEmployedMngmtW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedMngmtIOM_&_years.;
	GapEmployedMngmtAIOM_&_years.=PctEmployedMngmtW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedMngmtAIOM_&_years.;

	GapEmployedServB_&_years.=PctEmployedServW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedServB_&_years.;
	GapEmployedServW_&_years.=PctEmployedServW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedServW_&_years.;
	GapEmployedServH_&_years.=PctEmployedServW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedServH_&_years.;
	GapEmployedServA_&_years.=PctEmployedServW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedServA_&_years.;
	GapEmployedServIOM_&_years.=PctEmployedServW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedServIOM_&_years.;
	GapEmployedServAIOM_&_years.=PctEmployedServW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedServAIOM_&_years.;

	GapEmployedSalesB_&_years.=PctEmployedSalesW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedSalesB_&_years.;
	GapEmployedSalesW_&_years.=PctEmployedSalesW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedSalesW_&_years.;
	GapEmployedSalesH_&_years.=PctEmployedSalesW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedSalesH_&_years.;
	GapEmployedSalesA_&_years.=PctEmployedSalesW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedSalesA_&_years.;
	GapEmployedSalesIOM_&_years.=PctEmployedSalesW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedSalesIOM_&_years.;
	GapEmployedSalesAIOM_&_years.=PctEmployedSalesW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedSalesAIOM_&_years.;

	GapEmployedNatResB_&_years.=PctEmployedNatResW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedNatResB_&_years.;
	GapEmployedNatResW_&_years.=PctEmployedNatResW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedNatResW_&_years.;
	GapEmployedNatResH_&_years.=PctEmployedNatResW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedNatResH_&_years.;
	GapEmployedNatResA_&_years.=PctEmployedNatResW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedNatResA_&_years.;
	GapEmployedNatResIOM_&_years.=PctEmployedNatResW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedNatResIOM_&_years.;
	GapEmployedNatResAIOM_&_years.=PctEmployedNatResW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedNatResAIOM_&_years.;

	GapEmployedProdB_&_years.=PctEmployedProdW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedProdB_&_years.;
	GapEmployedProdW_&_years.=PctEmployedProdW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedProdW_&_years.;
	GapEmployedProdH_&_years.=PctEmployedProdW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedProdH_&_years.;
	GapEmployedProdA_&_years.=PctEmployedProdW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedProdA_&_years.;
	GapEmployedProdIOM_&_years.=PctEmployedProdW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedProdIOM_&_years.;
	GapEmployedProdAIOM_&_years.=PctEmployedProdW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedProdAIOM_&_years.;

	GapOwnerOccupiedHUB_&_years.=PctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsB_&_years.-NumOwnerOccupiedHUB_&_years.;
	GapOwnerOccupiedHUW_&_years.=PctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsW_&_years.-NumOwnerOccupiedHUW_&_years.;
	GapOwnerOccupiedHUH_&_years.=PctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsH_&_years.-NumOwnerOccupiedHUH_&_years.;
	GapOwnerOccupiedHUA_&_years.=PctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsA_&_years.-NumOwnerOccupiedHUA_&_years.;
	GapOwnerOccupiedHUIOM_&_years.=PctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsIOM_&_years.-NumOwnerOccupiedHUIOM_&_years.;
	GapOwnerOccupiedHUAIOM_&_years.=PctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsAIOM_&_years.-NumOwnerOccupiedHUAIOM_&_years.;

	label
	Gap25andOverWoutHSW_&_years. = "Difference in # of NH-White people without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSB_&_years. = "Difference in # of Black-Alone people without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSH_&_years. = "Difference in # of Hispanic people without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSA_&_years. = "Difference in # of Asian-PI people without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSIOM_&_years. = "Difference in # of Indigenous-Other-Multi people without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSAIOM_&_years. = "Difference in # of All-Other people without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSFB_&_years. = "Difference in # of people foreign-born without HS diploma with equity, &y_lbl."
	Gap25andOverWoutHSNB_&_years. = "Difference in # of people native-born without HS diploma with equity, &y_lbl."

	Gap25andOverWHSW_&_years. = "Difference in # of NH-White people with HS diploma with equity, &y_lbl."
	Gap25andOverWHSB_&_years. = "Difference in # of Black-Alone people with HS diploma with equity, &y_lbl."
	Gap25andOverWHSH_&_years. = "Difference in # of Hispanic people with HS diploma with equity, &y_lbl."
	Gap25andOverWHSA_&_years. = "Difference in # of Asian-PI people with HS diploma with equity, &y_lbl."
	Gap25andOverWHSIOM_&_years. = "Difference in # of Indigenous-Other-Multi people with HS diploma with equity, &y_lbl."
	Gap25andOverWHSAIOM_&_years. = "Difference in # of All-Other people with HS diploma with equity, &y_lbl."
	Gap25andOverWHSFB_&_years. = "Difference in # of people foreign-born with HS diploma with equity, &y_lbl."
	Gap25andOverWHSNB_&_years. = "Difference in # of people native-born with HS diploma with equity, &y_lbl."

	Gap25andOverWSCW_&_years. = "Difference in # of NH-White people with some college with equity, &y_lbl."
	Gap25andOverWSCB_&_years. = "Difference in # of Black-Alone people with some college with equity, &y_lbl."
	Gap25andOverWSCH_&_years. = "Difference in # of Hispanic people with some college with equity, &y_lbl."
	Gap25andOverWSCA_&_years. = "Difference in # of Asian-PI people with some college with equity, &y_lbl."
	Gap25andOverWSCIOM_&_years. = "Difference in # of Indigenous-Other-Multi people with some college with equity, &y_lbl."
	Gap25andOverWSCAIOM_&_years. = "Difference in # of All-Other people with some college with equity, &y_lbl."
	Gap25andOverWSCFB_&_years. = "Difference in # of people foreign-born with some college with equity, &y_lbl."
	Gap25andOverWSCNB_&_years. = "Difference in # of people native-born with some college with equity, &y_lbl."

	GapAvgHshldIncAdjW_&_years. = "Average household income last year NH-White ($) with equity, &y_lbl."
	GapAvgHshldIncAdjB_&_years. = "Average household income last year Black-Alone ($) with equity, &y_lbl."
	GapAvgHshldIncAdjH_&_years. = "Average household income last year Hispanic ($) with equity, &y_lbl."
	GapAvgHshldIncAdjA_&_years. = "Average household income last year Asian-PI ($) with equity, &y_lbl."
	GapAvgHshldIncAdjIOM_&_years. = "Average household income last year Indigenous-Other-Multi ($) with equity, &y_lbl."
	GapAvgHshldIncAdjAIOM_&_years. = "Average household income last year All-Other ($) with equity, &y_lbl."

	GapFamilyGT200000W_&_years. = "Difference in # of families NH-White with income greater than 200000 with equity, &y_lbl."
	GapFamilyGT200000B_&_years. = "Difference in # of families Black-Alone with income greater than 200000 with equity, &y_lbl."
	GapFamilyGT200000H_&_years. = "Difference in # of families Hispanic with income greater than 200000 with equity, &y_lbl."
	GapFamilyGT200000A_&_years. = "Difference in # of families Asian-PI with income greater than 200000 with equity, &y_lbl."
	GapFamilyGT200000IOM_&_years. = "Difference in # of families Indigenous-Other-Multi  with income greater than 200000 with equity, &y_lbl."
	GapFamilyGT200000AIOM_&_years. = "Difference in # of families All-Other with income greater than 200000 with equity, &y_lbl."

	GapFamilyLT75000W_&_years. = "Difference in # of families NH-White with income less than 75000 with equity, &y_lbl."
	GapFamilyLT75000B_&_years. = "Difference in # of families Black-Alone with income less than 75000 with equity, &y_lbl."
	GapFamilyLT75000H_&_years. = "Difference in # of families Hispanic with income less than 75000 with equity, &y_lbl."
	GapFamilyLT75000A_&_years. = "Difference in # of families Asian-PI with income less than 75000 with equity, &y_lbl."
	GapFamilyLT75000IOM_&_years. = "Difference in # of families Indigenous-Other-Multi with income less than 75000 with equity, &y_lbl."
	GapFamilyLT75000AIOM_&_years. = "Difference in # of families All-Other with income less than 75000 with equity, &y_lbl."

	GapPoorPersonsW_&_years. = "Difference in # of NH-White people living below poverty line with equity, &y_lbl."
	GapPoorPersonsB_&_years. = "Difference in # of Black-Alone people living below poverty line with equity, &y_lbl."
	GapPoorPersonsH_&_years. = "Difference in # of Hispanic people living below poverty line with equity, &y_lbl."
	GapPoorPersonsA_&_years. = "Difference in # of Asian-PI people living below poverty line with equity, &y_lbl."
	GapPoorPersonsIOM_&_years. = "Difference in # of Indigenous-Other-Multi people living below poverty line with equity, &y_lbl."
	GapPoorPersonsAIOM_&_years. = "Difference in # of All-Other people living below poverty line with equity, &y_lbl."
	GapPoorPersonsFB_&_years. = "Difference in # of foreign born people living below poverty line with equity, &y_lbl."

	GapPoorChildrenAIOM_&_years. = "Difference in # of All-Other children living below poverty line with equity, &y_lbl."    
	GapPoorChildrenIOM_&_years. = "Difference in # of Indigenous-Other-Multi children living below poverty line with equity, &y_lbl." 
	GapPoorChildrenA_&_years. = "Difference in # of Asian-PI children living below poverty line with equity, &y_lbl."
	GapPoorChildrenB_&_years. = "Difference in # of Black-Alone children living below poverty line with equity, &y_lbl."    
	GapPoorChildrenH_&_years. = "Difference in # of Hispanic children living below poverty line with equity, &y_lbl."
	GapPoorChildrenW_&_years. = "Difference in # of NH-White children living below poverty line with equity, &y_lbl."


	Gap16andOverEmployW_&_years. = "Difference in # of people 16+ yrs. employed NH-White with equity, &y_lbl."
	Gap16andOverEmployB_&_years. = "Difference in # of people 16+ yrs. employed Black-Alone with equity, &y_lbl."
	Gap16andOverEmployH_&_years. = "Difference in # of people 16+ yrs. employed Hispanic with equity, &y_lbl."
	Gap16andOverEmployA_&_years. = "Difference in # of people 16+ yrs. employed Asian-PI with equity, &y_lbl."
	Gap16andOverEmployIOM_&_years. = "Difference in # of people 16+ yrs. employed Indigenous-Other-Multi with equity, &y_lbl."
	Gap16andOverEmployAIOM_&_years. = "Difference in # of people 16+ yrs. employed All-Other with equity, &y_lbl."

	GapEmployed16to64W_&_years. = "Difference in # of NH-White people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmployed16to64B_&_years. = "Difference in # of Black-Alone people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmployed16to64H_&_years. = "Difference in # of Hispanic people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmployed16to64A_&_years. = "Difference in # of Asian-PI people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmployed16to64IOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmployed16to64AIOM_&_years. = "Difference in # of All-Other people employed between 16 and 64 years old with equity, &y_lbl."

	GapUnemployedW_&_years. = "Difference in # of NH-White unemployed people with equity, &y_lbl."
	GapUnemployedB_&_years. = "Difference in # of Black-Alone unemployed people with equity, &y_lbl."
	GapUnemployedH_&_years. = "Difference in # of Hispanic unemployed people with equity, &y_lbl."
	GapUnemployedA_&_years. = "Difference in # of Asian-PI unemployed people with equity, &y_lbl."
	GapUnemployedIOM_&_years. = "Difference in # of Indigenous-Other-Multi unemployed people with equity, &y_lbl."
	GapUnemployedAIOM_&_years. = "Difference in # of All-Other unemployed people with equity, &y_lbl."

	Gap16andOverWagesW_&_years. = "Difference in # of NH-White people employed with earnings with equity, &y_lbl."
	Gap16andOverWagesB_&_years. = "Difference in # of Black-Alone people employed with earnings with equity, &y_lbl."
	Gap16andOverWagesH_&_years. = "Difference in # of Hispanic people employed with earnings with equity, &y_lbl."
	Gap16andOverWagesA_&_years. = "Difference in # of Asian-PI people employed with earnings with equity, &y_lbl."
	Gap16andOverWagesIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed with earnings with equity, &y_lbl."
	Gap16andOverWagesAIOM_&_years. = "Difference in # of All-Other people employed with earnings with equity, &y_lbl."

	Gap16andOverWorkFTW_&_years. = "Difference in # of NH-White people employed full time with equity, &y_lbl."
	Gap16andOverWorkFTB_&_years. = "Difference in # of Black-Alone people employed full time with equity, &y_lbl."
	Gap16andOverWorkFTH_&_years. = "Difference in # of Hispanic people employed full time with equity, &y_lbl."
	Gap16andOverWorkFTA_&_years. = "Difference in # of Asian-PI people employed full time with equity, &y_lbl."
	Gap16andOverWorkFTIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with equity, &y_lbl."
	Gap16andOverWorkFTAIOM_&_years. = "Difference in # of All-Other people employed full time with equity, &y_lbl."

	GapWorkFTLT35kW_&_years. = "Difference in # of NH-White people employed full time with earnings less than 35000 with equity, &y_lbl."
	GapWorkFTLT35kB_&_years. = "Difference in # of Black-Alone people employed full time with earnings less than 35000 with equity, &y_lbl."
	GapWorkFTLT35kH_&_years. = "Difference in # of Hispanic people employed full time with earnings less than 35000 with equity, &y_lbl."
	GapWorkFTLT35kA_&_years. = "Difference in # of Asian-PI people employed full time with earnings less than 35000 with equity, &y_lbl."
	GapWorkFTLT35kIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with earnings less than 35000 with equity, &y_lbl."
	GapWorkFTLT35kAIOM_&_years. = "Difference in # of All-Other people employed full time with earnings less than 35000 with equity, &y_lbl."

	GapWorkFTLT75kW_&_years. = "Difference in # of NH-White people employed full time with earnings less than 75000 with equity, &y_lbl."
	GapWorkFTLT75kB_&_years. = "Difference in # of Black-Alone people employed full time with earnings less than 75000 with equity, &y_lbl."
	GapWorkFTLT75kH_&_years. = "Difference in # of Hispanic people employed full time with earnings less than 75000 with equity, &y_lbl."
	GapWorkFTLT75kA_&_years. = "Difference in # of Asian-PI people employed full time with earnings less than 75000 with equity, &y_lbl."
	GapWorkFTLT75kIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with earnings less than 75000 with equity, &y_lbl."
	GapWorkFTLT75kAIOM_&_years. = "Difference in # of All-Other people employed full time with earnings less than 75000 with equity, &y_lbl."

	GapEmployedMngmtW_&_years. = "Difference in # of NH-White people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmployedMngmtB_&_years. = "Difference in # of Black-Alone people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmployedMngmtH_&_years. = "Difference in # of Hispanic people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmployedMngmtA_&_years. = "Difference in # of Asian-PI people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmployedMngmtIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmployedMngmtAIOM_&_years. = "Difference in # of All-Other people employed in management business science and arts occupations with equity, &y_lbl."

	GapEmployedServW_&_years. = "Difference in # of NH-White people employed in service occupations with equity, &y_lbl."
	GapEmployedServB_&_years. = "Difference in # of Black-Alone people employed in service occupations with equity, &y_lbl."
	GapEmployedServH_&_years. = "Difference in # of Hispanic people employed in service occupations with equity, &y_lbl."
	GapEmployedServA_&_years. = "Difference in # of Asian-PI people employed in service occupations with equity, &y_lbl."
	GapEmployedServIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in service occupations with equity, &y_lbl."
	GapEmployedServAIOM_&_years. = "Difference in # of All-Other people employed in service occupations with equity, &y_lbl."

	GapEmployedSalesW_&_years. = "Difference in # of NH-White people employed in sales and office occupations with equity, &y_lbl."
	GapEmployedSalesB_&_years. = "Difference in # of Black-Alone people employed in sales and office occupations with equity, &y_lbl."
	GapEmployedSalesH_&_years. = "Difference in # of Hispanic people employed in sales and office occupations with equity, &y_lbl."
	GapEmployedSalesA_&_years. = "Difference in # of Asian-PI people employed in sales and office occupations with equity, &y_lbl."
	GapEmployedSalesIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in sales and office occupations with equity, &y_lbl."
	GapEmployedSalesAIOM_&_years. = "Difference in # of All-Other people employed in sales and office occupations with equity, &y_lbl."

	GapEmployedNatResW_&_years. = "Difference in # of NH-White people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmployedNatResB_&_years. = "Difference in # of Black-Alone people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmployedNatResH_&_years. = "Difference in # of Hispanic people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmployedNatResA_&_years. = "Difference in # of Asian-PI people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmployedNatResIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmployedNatResAIOM_&_years. = "Difference in # of All-Other people employed in natural resources construction and maintenance occupations with equity, &y_lbl."

	GapEmployedProdW_&_years. = "Difference in # of NH-White people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmployedProdB_&_years. = "Difference in # of Black-Alone people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmployedProdH_&_years. = "Difference in # of Hispanic people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmployedProdA_&_years. = "Difference in # of Asian-PI people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmployedProdIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmployedProdAIOM_&_years. = "Difference in # of All-Other people employed in production transportation and material moving occupations with equity, &y_lbl."

	GapOwnerOccupiedHUW_&_years. = "Difference in # of NH-White homeowners with equity, &y_lbl."
	GapOwnerOccupiedHUB_&_years. = "Difference in # of Black-Alone homeowners with equity, &y_lbl."
	GapOwnerOccupiedHUH_&_years. = "Difference in # of Hispanic homeowners with equity, &y_lbl."
	GapOwnerOccupiedHUA_&_years. = "Difference in # of Asian-PI homeowners with equity, &y_lbl."
	GapOwnerOccupiedHUIOM_&_years. = "Difference in # of Indigenous-Other-Multi homeowners with equity, &y_lbl."
	GapOwnerOccupiedHUAIOM_&_years. = "Difference in # of All-Other homeowners with equity, &y_lbl."
		;

	%suppress_gaps_negative;
	%suppress_gaps_region_z;
	%suppress_gaps_region_fb;

run;


** Aggregate numerators and denominators to the region-level **;
proc summary data = allcounty;
	var    TotPop: mTotPop: 
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
		   PopMoved: mPopMoved:
		   Gap:
		   ;
	output out = region_agg_a sum=;
run;


** Calculate percents for the region from numerators and denominators**;
%macro region_pct;
data region_agg ; 
  
    set region_agg_a;
    
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
		%let name=%scan(&racename.,&r.," ");
	 
    %Pct_calc( var=PctPopUnder18Years&race., label=% children &name., num=PopUnder18Years&race., den=PopAlone&race., years= &_years. )
    
    %Moe_prop_a( var=PctPopUnder18Years&race._m_&_years., mult=100, num=PopUnder18Years&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopUnder18Years&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % children &name. MOE &y_lbl.);

	%Pct_calc( var=PctPop18_34Years&race., label=% persons 18-34 years old &name., num=Pop18_34Years&race., den=PopAlone&race., years= &_years. )
	
	%Moe_prop_a( var=PctPop18_34Years&race._m_&_years., mult=100, num=Pop18_34Years&race._&_years., den=PopAlone&race._&_years., 
	                       num_moe=mPop18_34Years&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % persons 18-34 years old &name. MOE &y_lbl.);

	%Pct_calc( var=PctPop35_64Years&race., label=% persons 35-64 years old &name., num=Pop35_64Years&race., den=PopAlone&race., years= &_years. )
	
	%Moe_prop_a( var=PctPop35_64Years&race._m_&_years., mult=100, num=Pop35_64Years&race._&_years., den=PopAlone&race._&_years., 
	                       num_moe=mPop35_64Years&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % persons 35-64 years old &name. MOE &y_lbl.);

	%Pct_calc( var=PctPop65andOverYears&race., label=% seniors &name., num=Pop65andOverYears&race., den=PopAlone&race., years= &_years. )

    %Moe_prop_a( var=PctPop65andOverYrs&race._m_&_years., mult=100, num=Pop65andOverYears&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPop65andOverYears&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % seniors &name. MOE &y_lbl.);

	%Pct_calc( var=PctForeignBorn&race., label=% foreign born &name., num=PopForeignBorn&race., den=PopAlone&race., years=&_years. )

    %Moe_prop_a( var=PctForeignBorn&race._m_&_years., mult=100, num=PopForeignBorn&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopForeignBorn&race._&_years., den_moe=mPopAlone&race._&_years., label_moe = % foreign born &name. MOE &y_lbl.);

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
                       num_moe=mPopAloneIOM_&_years., den_moe=mPopWithRace_&_years., label_moe =% Indigienous-other-multi-alone MOE &y_lbl.);

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
    %Pct_calc( var=PctPoorPersonsA, label=Poverty rate Asian-PI(%), num=PopPoorPersonsA, den=PersonsPovertyDefinedA, years=&_years. )
	%Pct_calc( var=PctPoorPersonsIOM, label=Poverty rate Indigenous-Other-Multi(%), num=PopPoorPersonsIOM, den=PersonsPovertyDefIOM, years=&_years. )
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
                       num_moe=mPopPoorPersonsA_&_years., den_moe=mPersonsPovertyDefinedA_&_years., label_moe =Poverty rate Asian-PI(%) MOE &y_lbl.);

	%Moe_prop_a( var=PctPoorPersonsIOM_m_&_years., mult=100, num=PopPoorPersonsIOM_&_years., den=PersonsPovertyDefIOM_&_years., 
                       num_moe=mPopPoorPersonsIOM_&_years., den_moe=mPersonsPovertyDefIOM_&_years., label_moe =Poverty rate Indigenous-Other-Multi(%) MOE &y_lbl.);

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

	%Pct_calc( var=Pct16andOverEmploy, label=% pop. 16+ yrs. employed, num=Pop16andOverEmploy, den=Pop16andOverYears, years=&_years. )

    %Moe_prop_a( var=Pct16andOverEmploy_m_&_years., mult=100, num=Pop16andOverEmploy_&_years., den=Pop16andOverYears_&_years., 
                       num_moe=mPop16andOverEmploy_&_years., den_moe=mPop16andOverYears_&_years., label_moe =% pop. 16+ yrs. employed MOE &y_lbl.);

	%Pct_calc( var=Pct16andOverWages, label=% persons employed with earnings, num=PopWorkEarn, den=Pop16andOverYears, years=&_years. )

	%Moe_prop_a( var=Pct16andOverWages_m_&_years., mult=100, num=PopWorkEarn_&_years., den=Pop16andOverYears_&_years., 
                       num_moe=mPopWorkEarn_&_years., den_moe=mPop16andOverYears_&_years., label_moe =% persons employed with earnings MOE &y_lbl.);

	%Pct_calc( var=Pct16andOverWorkFT, label=% persons employed full time, num=PopWorkFT, den=Pop16andOverYears, years=&_years. )

    %Moe_prop_a( var=Pct16andOverWorkFT_m_&_years., mult=100, num=PopWorkFT_&_years., den=Pop16andOverYears_&_years., 
                       num_moe=mPopWorkFT_&_years., den_moe=mPop16andOverYears_&_years., label_moe =% persons employed full time MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k, label=% persons employed full time with earnings less than 35000, num=PopWorkFTLT35K, den=PopWorkFT, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k_m_&_years., mult=100, num=PopWorkFTLT35k_&_years., den=PopWorkFT_&_years., 
                       num_moe=mPopWorkFTLT35k_&_years., den_moe=mPopWorkFT_&_years., label_moe =% persons employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k, label=% persons employed full time with earnings less than 75000, num=PopWorkFTLT75k, den=PopWorkFT, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k_m_&_years., mult=100, num=PopWorkFTLT75k_&_years., den=PopWorkFT_&_years., 
                       num_moe=mPopWorkFTLT75k_&_years., den_moe=mPopWorkFT_&_years., label_moe =% persons employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctEmployedMngmt, label=% persons 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmployedMngmt_m_&_years., mult=100, num=PopEmployedMngmt_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedMngmt_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedServ, label=% persons 16+ years old employed in service occupations, num=PopEmployedServ, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmployedServ_m_&_years., mult=100, num=PopEmployedServ_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedServ_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedSales, label=% persons 16+ years old employed in sales and office occupations, num=PopEmployedSales, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmployedSales_m_&_years., mult=100, num=PopEmployedSales_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedSales_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedNatRes, label=% persons 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmployedNatRes_m_&_years., mult=100, num=PopEmployedNatRes_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedNatRes_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedProd, label=% persons employed in production transportation and material moving occupations, num=PopEmployedProd, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmployedProd_m_&_years., mult=100, num=PopEmployedProd_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedProd_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons employed in production transportation and material moving occupations MOE &y_lbl.);

	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");
		 
	%Pct_calc( var=PctUnemployed&race., label=&name. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._m_&_years., mult=100, num=PopUnemployed&race._&_years., den=PopInCivLaborForce&race._&_years., 
	                       num_moe=mPopUnemployed&race._&_years., den_moe=mPopInCivLaborForce&race._&_years., label_moe =&name. Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctEmployed16to64&race., label=% persons &name. employed between 16 and 64 years old, num=Pop16_64Employed&race., den=Pop16_64years&race., years=&_years. )

	%Moe_prop_a( var=PctEmployed16to64&race._m_&_years., mult=100, num=Pop16_64Employed&race._&_years., den=Pop16_64years&race._&_years., 
                       num_moe=mPop16_64Employed&race._&_years., den_moe=mPop16_64years&race._&_years., label_moe =% persons &name. employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=Pct16andOverEmploy&race., label=% pop. 16+ yrs. employed &name., num=Pop16andOverEmploy&race., den=Pop16andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct16andOverEmploy&race._m_&_years., mult=100, num=Pop16andOverEmploy&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPop16andOverEmploy&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% pop. 16+ yrs. employed &name. MOE &y_lbl.);

	%Pct_calc( var=Pct16andOverWages&race., label=% persons &name. employed with earnings, num=PopWorkEarn&race., den=Pop16andOverYears&race., years=&_years. )

	%Moe_prop_a( var=Pct16andOverWages&race._m_&_years., mult=100, num=PopWorkEarn&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPopWorkEarn&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% persons &name. employed with earnings MOE &y_lbl.);

	%Pct_calc( var=Pct16andOverWorkFT&race., label=% persons &name. employed full time, num=PopWorkFT&race., den=Pop16andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct16andOverWorkFT&race._m_&_years., mult=100, num=PopWorkFT&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPopWorkFT&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% persons &name. employed full time MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race., label=% persons &name. employed full time with earnings less than 35000, num=PopWorkFTLT35K&race., den=PopWorkFT&race., years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._m_&_years., mult=100, num=PopWorkFTLT35k&race._&_years., den=PopWorkFT&race._&_years., 
                       num_moe=mPopWorkFTLT35k&race._&_years., den_moe=mPopWorkFT&race._&_years., label_moe =% persons &name. employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k&race., label=% persons &name. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race., den=PopWorkFT&race., years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._m_&_years., mult=100, num=PopWorkFTLT75k&race._&_years., den=PopWorkFT&race._&_years., 
                       num_moe=mPopWorkFTLT75k&race._&_years., den_moe=mPopWorkFT&race._&_years., label_moe =% persons &name. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctEmployedMngmt&race., label=% persons &name. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmployedMngmt&race._m_&_years., mult=100, num=PopEmployedMngmt&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedMngmt&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedServ&race., label=% persons &name. 16+ years old employed in service occupations, num=PopEmployedServ&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmployedServ&race._m_&_years., mult=100, num=PopEmployedServ&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedServ&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedSales&race., label=% persons &name. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmployedSales&race._m_&_years., mult=100, num=PopEmployedSales&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedSales&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedNatRes&race., label=% persons &name. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmployedNatRes&race._m_&_years., mult=100, num=PopEmployedNatRes&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedNatRes&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmployedProd&race., label=% persons &name. employed in production transportation and material moving occupations, num=PopEmployedProd&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmployedProd&race._m_&_years., mult=100, num=PopEmployedProd&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedProd&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. employed in production transportation and material moving occupations MOE &y_lbl.);

	%end;


	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=Pct25andOverWoutHS&race., label=% persons &name. without HS diploma, num=Pop25andOverWoutHS&race., den=Pop25andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct25andOverWoutHS&race._m_&_years., mult=100, num=Pop25andOverWoutHS&race._&_years., den=Pop25andOverYears&race._&_years., 
                       num_moe=mPop25andOverWoutHS&race._&_years., den_moe=mPop25andOverYears&race._&_years., label_moe =% persons &name. without HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWHS&race., label=% persons &name. with HS diploma, num=Pop25andOverWHS&race., den=Pop25andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct25andOverWHS&race._m_&_years., mult=100, num=Pop25andOverWHS&race._&_years., den=Pop25andOverYears&race._&_years., 
                       num_moe=mPop25andOverWHS&race._&_years., den_moe=mPop25andOverYears&race._&_years., label_moe =% persons &name. with HS diploma MOE &y_lbl.);

	%Pct_calc( var=Pct25andOverWSC&race., label=% persons &name. with some college, num=Pop25andOverWSC&race., den=Pop25andOverYears&race., years=&_years. )

	%Moe_prop_a( var=Pct25andOverWSC&race._m_&_years., mult=100, num=Pop25andOverWSC&race._&_years., den=Pop25andOverYears&race._&_years., 
                       num_moe=mPop25andOverWSC&race._&_years., den_moe=mPop25andOverYears&race._&_years., label_moe =% persons &name. with some college MOE &y_lbl.);

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
		%Pct_calc( var=PctPoorChildrenA, label=% children Asian-PI in poverty, num=PopPoorChildrenA, den=ChildrenPovertyDefinedA, years=&_years. )
		%Pct_calc( var=PctPoorChildrenH, label=% children Hispanic in poverty, num=PopPoorChildrenH, den=ChildrenPovertyDefinedH, years=&_years. )	
		%Pct_calc( var=PctPoorChildrenIOM, label=% children Indigenous-Other-Multi in poverty, num=PopPoorChildrenIOM, den=ChildrenPovertyDefIOM, years=&_years. )	
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
	                       num_moe=mPopPoorChildrenA_&_years., den_moe=mChildrenPovertyDefinedA_&_years., label_moe =% children Asian-PI in poverty MOE &y_lbl.);

		%Moe_prop_a( var=PctPoorChildrenIOM_m_&_years., mult=100, num=PopPoorChildrenIOM_&_years., den=ChildrenPovertyDefIOM_&_years., 
	                       num_moe=mPopPoorChildrenIOM_&_years., den_moe=mChildrenPovertyDefIOM_&_years., label_moe =% children Indigenous-Other-Multi in poverty MOE &y_lbl.);

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
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctFamilyLT75000&race., label=% families &name. with income less than 75000, num=FamIncomeLT75k&race., den=NumFamilies&race., years=&_years. )

    %Moe_prop_a( var=PctFamilyLT75000&race._m_&_years., mult=100, num=FamIncomeLT75k&race._&_years., den=NumFamilies&race._&_years., 
                       num_moe=mFamIncomeLT75k&race._&_years., den_moe=mNumFamilies&race._&_years., label_moe =% families &name. with income less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctFamilyGT200000&race., label=% families &name. with income greater than 200000, num=FamIncomeGT200k&race., den=NumFamilies&race., years=&_years. )

    %Moe_prop_a( var=PctFamilyGT200000&race._m_&_years., mult=100, num=FamIncomeGT200k&race._&_years., den=NumFamilies&race._&_years., 
                       num_moe=mFamIncomeGT200k&race._&_years., den_moe=mNumFamilies&race._&_years., label_moe =% families &name. with income greater than 200000 MOE &y_lbl.);

	%Pct_calc( var=AvgHshldIncome&race., label=Average household income last year &name. ($), num=AggHshldIncome&race., den=NumHshlds&race., mult=1, years=&_years. )

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
	  AvgHshldIncAdjA_&_years. = "Average household income (adjusted), Asian-PI, &y_lbl."
	  AvgHshldIncAdjA_m_&_years. = "Average household income (adjusted), Asian-PI MOE, &y_lbl."
	  AvgHshldIncAdjIOM_&_years. = "Average household income (adjusted), Indigenous, Other or Multiple race, &y_lbl."
	  AvgHshldIncAdjIOM_m_&_years. = "Average household income (adjusted), Indigenous, Other or Multiple Race MOE, &y_lbl."
	  AvgHshldIncAdjAIOM_&_years. = "Average household income (adjusted), All remaining groups other than Black, Non-Hispanic White, Hispanic, &y_lbl."
	  AvgHshldIncAdjAIOM_m_&_years. = "Average household income (adjusted), All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &y_lbl."
	  AvgHshldIncome_m_&_years. = "Average household income, MOE, &y_lbl."
	  AvgHshldIncomeB_m_&_years. = "Average household income, Black/African American, MOE, &y_lbl."
	  AvgHshldIncomeW_m_&_years. = "Average household income, Non-Hispanic White, MOE, &y_lbl."
	  AvgHshldIncomeH_m_&_years. = "Average household income, Hispanic/Latino, MOE, &y_lbl."
	  AvgHshldIncomeA_m_&_years. = "Average household income, Asian-PI, MOE, &y_lbl."
	  AvgHshldIncomeIOM_m_&_years. = "Average household income, Indigenous, Other or Multiple Race  MOE, &y_lbl."
	  AvgHshldIncomeAIOM_m_&_years. = "Average household income, All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &y_lbl."
      ;

        

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
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctOwnerOccupiedHU&race., label=Homeownership rate &name.(%), num=NumOwnerOccupiedHU&race., den=NumOccupiedHsgUnits&race., years=&_years. )

    
    %Moe_prop_a( var=PctOwnerOccupiedHU&race._m_&_years., mult=100, num=NumOwnerOccupiedHU&race._&_years., den=NumOccupiedHsgUnits&race._&_years., 
                       num_moe=mNumOwnerOccupiedHU&race._&_years., den_moe=mNumOccupiedHsgUnits&race._&_years., label_moe =Homeownership rate &name.(%) MOE &y_lbl.);
    
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
		%let name=%scan(&racename.,&r.," ");

	%Pct_calc( var=PctMovedLastYear&race., label=% persons who moved in the last year &name., num=PopMovedLastYear&race., den=PopAlone&race., years=&_years. )

	%Moe_prop_a( var=PctMovedLastYear&race._m_&_years., mult=100, num=PopMovedLastYear&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopMovedLastYear&race._&_years., den_moe=mPopAlone&race._&_years., label_moe =% persons who moved in the last year &name. MOE &y_lbl.);

	%Pct_calc( var=PctMovedDiffCnty&race., label=% persons who moved from a different county in the last year &name., num=PopMovedDiffCnty&race., den=PopAlone&race., years=&_years. )

	%Moe_prop_a( var=PctMovedDiffCnty&race._m_&_years., mult=100, num=PopMovedDiffCnty&race._&_years., den=PopAlone&race._&_years., 
                       num_moe=mPopMovedDiffCnty&race._&_years., den_moe=mPopAlone&race._&_years., label_moe =% persons who moved from a different county in the last year &name. MOE &y_lbl.);

	%end;

    ** Create flag for generating profile **;
    
    if TotPop_tr_&_years. >= 100 then _make_profile = 1;
    else _make_profile = 0;

	county = "0";
    
 
  run;

  %mend region_pct;
  %region_pct;


** Stack county and region data **;
data Profile_acs_region;
	set allcounty region_agg (drop = _type_ _freq_);
	
	order=.;
	if county=" " then order=1;
	if county="11001" then order=2;
	if county="24017" then order=3;
	if county="24021" then order=4; 
	if county="24031" then order=5;
	if county="24033" then order=6;
	if county="51510" then order=7;
	if county="51013" then order=8;
	if county="51610" then order=9;
	if county="51059" then order=10;
	if county="51600" then order=11;
	if county="51107" then order=12;
	if county="51153" then order=13;
	if county="51683" then order=14; 
	if county="51685" then order=15; 
	

	drop cv: p n x a_se b_se: uPct: uAvg: z c_se d_se den denA denAIOM denB denH denW f k lAvg: lPct: num numA numAIOM numB numH numW zA zAIOM zB zH zW ;
run;

proc sort data = Profile_acs_region; by order; run;


** Round numbers **;
%round_output (in=Profile_acs_region,out=Profile_acs_region_rounded);

*temporary fix;
data donotroundunemp;
	set Profile_acs_region_rounded (drop=PctUnemployed:);

	%Pct_calc( var=PctUnemployed, label=Unemployment rate (%), num=PopUnemployed, den=PopInCivLaborForce, years=&_years. )

		%Moe_prop_a( var=PctUnemployed_m_&_years., mult=100, num=PopUnemployed_&_years., den=PopInCivLaborForce_&_years., 
	                       num_moe=mPopUnemployed_&_years., den_moe=mPopInCivLaborForce_&_years., label_moe =Unemployment rate (%) MOE &y_lbl.);


	%Pct_calc( var=PctUnemployedW, label=NH-White Unemployment rate (%), num=PopUnemployedW, den=PopInCivLaborForceW, years=&_years. )

		%Moe_prop_a( var=PctUnemployedW_m_&_years., mult=100, num=PopUnemployedW_&_years., den=PopInCivLaborForceW_&_years., 
	                       num_moe=mPopUnemployedW_&_years., den_moe=mPopInCivLaborForceW_&_years., label_moe =NH-White Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployedB, label=Black-Alone Unemployment rate (%), num=PopUnemployedB, den=PopInCivLaborForceB, years=&_years. )

		%Moe_prop_a( var=PctUnemployedB_m_&_years., mult=100, num=PopUnemployedB_&_years., den=PopInCivLaborForceB_&_years., 
	                       num_moe=mPopUnemployedB_&_years., den_moe=mPopInCivLaborForceB_&_years., label_moe =Black-Alone Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployedH, label=Hispanic Unemployment rate (%), num=PopUnemployedH, den=PopInCivLaborForceH, years=&_years. )

		%Moe_prop_a( var=PctUnemployedH_m_&_years., mult=100, num=PopUnemployedH_&_years., den=PopInCivLaborForceH_&_years., 
	                       num_moe=mPopUnemployedH_&_years., den_moe=mPopInCivLaborForceH_&_years., label_moe =Hispanic Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployedA, label=Asian-PI Unemployment rate (%), num=PopUnemployedA, den=PopInCivLaborForceA, years=&_years. )

		%Moe_prop_a( var=PctUnemployedA_m_&_years., mult=100, num=PopUnemployedA_&_years., den=PopInCivLaborForceA_&_years., 
	                       num_moe=mPopUnemployedA_&_years., den_moe=mPopInCivLaborForceA_&_years., label_moe =Asian-PI Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployedIOM, label=Indigenous-Other-Multi Unemployment rate (%), num=PopUnemployedIOM, den=PopInCivLaborForceIOM, years=&_years. )

		%Moe_prop_a( var=PctUnemployedIOM_m_&_years., mult=100, num=PopUnemployedIOM_&_years., den=PopInCivLaborForceIOM_&_years., 
	                       num_moe=mPopUnemployedIOM_&_years., den_moe=mPopInCivLaborForceIOM_&_years., label_moe =Indigenous-Other-Multi Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployedAIOM, label=All-Other Unemployment rate (%), num=PopUnemployedAIOM, den=PopInCivLaborForceAIOM, years=&_years. )

		%Moe_prop_a( var=PctUnemployedAIOM_m_&_years., mult=100, num=PopUnemployedAIOM_&_years., den=PopInCivLaborForceAIOM_&_years., 
	                       num_moe=mPopUnemployedAIOM_&_years., den_moe=mPopInCivLaborForceAIOM_&_years., label_moe =All-Other Unemployment rate (%) MOE &y_lbl.);
run;
** save data set for use in other repos;
%Finalize_data_set( 
		data=donotroundunemp,
		out=Regional_equity_gaps_acs_&_years.,
		outlib=Equity,
		label="DC Regional ACS Equity Indicators and Gaps by Race/Ethnicity, County  &_years.",
		sortby=county,
		restrictions=None,
		revisions=&revisions.
		)
** Transpose for final excel output **;
proc transpose data=donotroundunemp out=profile_tabs_region ;/*(label="DC Equity Indicators and Gap Calculations for Equity Profile City & Ward, &y_lbl."); */
	var TotPop_tr:

		PctWhiteNonHispBridge_: PctHisp_:
		PctAloneB_: PctAloneW_: PctAloneA_:
		PctAloneI_: PctAloneO_: PctAloneM_: 

		PctPopUnder18Years_: PctPopUnder18YearsW_: 
		PctPopUnder18YearsB_: PctPopUnder18YearsH_:
		PctPopUnder18YearsA_: PctPopUnder18YearsIOM_: 

		PctPop18_34Years_: PctPop18_34YearsW_: 
		PctPop18_34YearsB_: PctPop18_34YearsH_:
		PctPop18_34YearsA_: PctPop18_34YearsIOM_:

		PctPop35_64Years_: PctPop35_64YearsW_: 
		PctPop35_64YearsB_: PctPop35_64YearsH_:
		PctPop35_64YearsA_: PctPop18_34YearsIOM_:

		PctPop65andOverYears_: PctPop65andOverYrs_:
		PctPop65andOverYearsW_: PctPop65andOverYrsW_:
		PctPop65andOverYearsB_: PctPop65andOverYrsB_:
		PctPop65andOverYearsH_: PctPop65andOverYrsH_:
		PctPop65andOverYearsA_: PctPop65andOverYrsA_:
		PctPop65andOverYearsIOM_: PctPop65andOverYrsIOM_:

		PctForeignBorn_: PctNativeBorn_: 

		PctForeignBornB_: PctForeignBornW_:
		PctForeignBornH_: PctForeignBornA_: 
		PctForeignBornIOM_: PctForeignBornIOM_: 

		PctOthLang_:

		Pct25andOverWoutHS_:
		Pct25andOverWoutHSW_:
		Pct25andOverWoutHSB_:
		Pct25andOverWoutHSH_:
		Pct25andOverWoutHSA_:
		Pct25andOverWoutHSIOM_:
		Pct25andOverWoutHSFB_:
		Pct25andOverWoutHSNB_:

		Gap25andOverWoutHSB_:
		Gap25andOverWoutHSH_:
		Gap25andOverWoutHSA_:
		Gap25andOverWoutHSIOM_:
		Gap25andOverWoutHSFB_:

		Pct25andOverWHS_:
		Pct25andOverWHSW_:
		Pct25andOverWHSB_:
		Pct25andOverWHSH_:
		Pct25andOverWHSA_:
		Pct25andOverWHSIOM_:
		Pct25andOverWHSFB_:
		Pct25andOverWHSNB_:

		Gap25andOverWHSB_:
		Gap25andOverWHSH_:
		Gap25andOverWHSA_:
		Gap25andOverWHSIOM_:
		Gap25andOverWHSFB_:
		
		Pct25andOverWSC_:
		Pct25andOverWSCW_:
		Pct25andOverWSCB_:
		Pct25andOverWSCH_:
		Pct25andOverWSCA_:
		Pct25andOverWSCIOM_:
		Pct25andOverWSCFB_:
		Pct25andOverWSCNB_:

		Gap25andOverWSCB_:
		Gap25andOverWSCH_:
		Gap25andOverWSCA_:
		Gap25andOverWSCIOM_:
		Gap25andOverWSCFB_:
		
		PctPoorPersons_:
		PctPoorPersonsW_:
		PctPoorPersonsB_:
		PctPoorPersonsH_:
		PctPoorPersonsA_:
		PctPoorPersonsIOM_:
		PctPoorPersonsFB_:

		GapPoorPersonsB_:
		GapPoorPersonsH_:
		GapPoorPersonsA_:
		GapPoorPersonsIOM_:
		GapPoorPersonsFB_:

		PctPoorChildren_:
		PctPoorChildrenW_:
		PctPoorChildrenB_:
		PctPoorChildrenH_:
		PctPoorChildrenA_:
		PctPoorChildrenIOM_:

		PctFamilyLT75000_:
		PctFamilyLT75000W_:
		PctFamilyLT75000B_:
		PctFamilyLT75000H_:
		PctFamilyLT75000A_:
		PctFamilyLT75000IOM_:

		GapFamilyLT75000B_:
		GapFamilyLT75000H_:
		GapFamilyLT75000A_:
		GapFamilyLT75000IOM_:

		PctFamilyGT200000_:
		PctFamilyGT200000W_:
		PctFamilyGT200000B_:
		PctFamilyGT200000H_:
		PctFamilyGT200000A_:
		PctFamilyGT200000IOM_:

		AvgHshldIncAdj_:
		AvgHshldIncAdjW_:
		AvgHshldIncAdjB_:
		AvgHshldIncAdjH_:
		AvgHshldIncAdjA_:
		AvgHshldIncAdjIOM_:
		
		Pct16andOverEmploy_:
		Pct16andOverEmployW_:
		Pct16andOverEmployB_:
		Pct16andOverEmployH_:
		Pct16andOverEmployA_:
		Pct16andOverEmployIOM_:

		Gap16andOverEmployB_:
		Gap16andOverEmployH_:
		Gap16andOverEmployA_:
		Gap16andOverEmployIOM_:

		PctEmployed16to64_:
		PctEmployed16to64W_:
		PctEmployed16to64B_:
		PctEmployed16to64H_:
		PctEmployed16to64A_:
		PctEmployed16to64IOM_:

		GapEmployed16to64B_:
		GapEmployed16to64H_:
		GapEmployed16to64A_:
		GapEmployed16to64IOM_:

		PctUnemployed_:
		PctUnemployedW_:
		PctUnemployedB_:
		PctUnemployedH_:
		PctUnemployedA_:
		PctUnemployedIOM_:

		GapUnemployedB_:
		GapUnemployedH_:
		GapUnemployedA_:
		GapUnemployedIOM_:

		Pct16andOverWages_:
		Pct16andOverWagesW_:
		Pct16andOverWagesB_:
		Pct16andOverWagesH_:
		Pct16andOverWagesA_:
		Pct16andOverWagesIOM_:

		Gap16andOverWagesB_:
		Gap16andOverWagesH_:
		Gap16andOverWagesA_:
		Gap16andOverWagesIOM_:

		Pct16andOverWorkFT_:
		Pct16andOverWorkFTW_:
		Pct16andOverWorkFTB_:
		Pct16andOverWorkFTH_:
		Pct16andOverWorkFTA_:
		Pct16andOverWorkFTIOM_:

		Gap16andOverWorkFTB_:
		Gap16andOverWorkFTH_:
		Gap16andOverWorkFTA_:
		Gap16andOverWorkFTIOM_:


		PctWorkFTLT35k_:
		PctWorkFTLT35kW_:
		PctWorkFTLT35kB_:
		PctWorkFTLT35kH_:
		PctWorkFTLT35kA_:
		PctWorkFTLT35kIOM_:

		GapWorkFTLT35kB_:
		GapWorkFTLT35kH_:
		GapWorkFTLT35kA_:
		GapWorkFTLT35kIOM_:

		PctWorkFTLT75k_:
		PctWorkFTLT75kW_:
		PctWorkFTLT75kB_:
		PctWorkFTLT75kH_:
		PctWorkFTLT75kA_:
		PctWorkFTLT75kIOM_:

		GapWorkFTLT75kB_:
		GapWorkFTLT75kH_:
		GapWorkFTLT75kA_:
		GapWorkFTLT75kIOM_:

		PctEmployedMngmt_:
		PctEmployedMngmtW_:
		PctEmployedMngmtB_:
		PctEmployedMngmtH_:
		PctEmployedMngmtA_:
		PctEmployedMngmtIOM_:

		PctEmployedServ_:
		PctEmployedServW_:
		PctEmployedServB_:
		PctEmployedServH_:
		PctEmployedServA_:
		PctEmployedServIOM_:

		PctEmployedSales_:
		PctEmployedSalesW_:
		PctEmployedSalesB_:
		PctEmployedSalesH_:
		PctEmployedSalesA_:
		PctEmployedSalesIOM_:

		PctEmployedNatRes_:
		PctEmployedNatResW_:
		PctEmployedNatResB_:
		PctEmployedNatResH_:
		PctEmployedNatResA_:
		PctEmployedNatResIOM_:

		PctEmployedProd_:
		PctEmployedProdW_:
		PctEmployedProdB_:
		PctEmployedProdH_:
		PctEmployedProdA_:
		PctEmployedProdIOM_:

		PctOwnerOccupiedHU_:
		PctOwnerOccupiedHUW_:
		PctOwnerOccupiedHUB_:
		PctOwnerOccupiedHUH_:
		PctOwnerOccupiedHUA_:
		PctOwnerOccupiedHUIOM_:

		GapOwnerOccupiedHUB_:
		GapOwnerOccupiedHUH_:
		GapOwnerOccupiedHUA_:
		GapOwnerOccupiedHUIOM_:

		PctMovedLastYear_:
		PctMovedLastYearW_:
		PctMovedLastYearB_:
		PctMovedLastYearH_:
		PctMovedLastYearA_:
		PctMovedLastYearIOM_:

		PctMovedDiffCnty_:
		PctMovedDiffCntyW_:
		PctMovedDiffCntyB_:
		PctMovedDiffCntyH_:
		PctMovedDiffCntyA_:
		PctMovedDiffCntyIOM_:
	 	;

	id county; 
run; 


** Export final file **;
proc export data=profile_tabs_region
	outfile="&_dcdata_default_path.\Equity\Prog\profile_tabs_HITregion_acs_&_years..csv"
	dbms=csv replace;
	run;


/* End of program */
