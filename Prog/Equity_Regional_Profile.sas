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
		08/11/22 LH Add employment by gender variables
	 	01/31/23 LH Update for 2016-20 and add Baltimore & Richmond regions. Removed fixed start year on income adjustment.
        01/04/24 RG Update for 2017-21
		02/20/24 LH Update for 2018-22 and for change to cnty files with ucounty as id.
		02/27/24 LH update for ACS recode on special values.
		01/15/25 LH Update to be able to use older years with regcnt or 2022+ with cnty
		01/26/25 LH Update to run alternate Washington region definitions. 
		01/31/25 LH Update for new cost burden indicators and 2019-23
 **************************************************************************/

%include "\\sas1\DCDATA\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let _years=2019_23;
%let y_lbl = %sysfunc( translate( &_years., '-', '_' ) );

%let inc_from_yr=2023;
%let inc_dollar_yr=2023;
%let lastyr=2023;

%let racelist=W B H A IOM AIOM ;
%let racename= NH-White Black-Alone Hispanic Asian-PI Indigenous-Other-Multi All-Other ;
*all-other is all other than NHWhite, Black, Hispanic; 
*all races except NH white, hispanic, and multiple race are race alone. ;

%let revisions=Fix denom for No Mortage Cost Burden;

*HIT region: "11001","24017","24021","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685";
*PDMV region: "11001","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685";

** County formats **;
proc format;
value $county
	"11XXX" = "Greater Washington Region"
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
	"24XXX" = "Greater Baltimore Region"
	"24510" = "Baltimore City"
	"24005" = "Baltimore County"
	"24003" = "Anne Arundel"
	"24027" = "Howard"
	"24013" = "Carroll"
	"24025" = "Harford"
	"24035" = "Queen Annes" 
	"51XXX" = "Greater Richmond Region"
	"51760" = "Richmond"
	"51041" = "Chesterfield"
	"51087" = "Henrico"
	;
run;
%macro pickregion(dcregion); 
	%if &dcregion=PDMV %then %do; 

		%let dcregionlist="11001","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685";

	%end; 

	%if &dcregion=HIT %then %do; 
		%let dcregionlist="11001","24017","24021","24031","24033","51510","51013","51610","51059","51600","51107","51153","51683","51685";

	%end; 

%macro allcounty; 


%if &inc_from_yr. < 2022 %then %do;

		** Combined county data **;
	data allcounty;
		set equity.Profile_acs_&_years._dc_regcnt (rename=(county=ucounty))
			equity.Profile_acs_&_years._md_regcnt (rename=(county=ucounty))
			equity.Profile_acs_&_years._va_regcnt (rename=(county=ucounty));

%end;

%else %do; 
	

** Combined county data **;
	data allcounty;
		set equity.Profile_acs_&_years._dc_cnty 
			equity.Profile_acs_&_years._md_cnty 
			equity.Profile_acs_&_years._va_cnty;

%end; 
	format ucounty county.;
	length region $10.;

/*1/31/23 adding new regions */
if ucounty in ("24003","24005","24013","24025","24027", "24035", "24510" ) then region="Baltimore";
if ucounty in (&dcregionlist.) then region="Washington";
if ucounty in ("51760", "51087", "51041" ) then region="Richmond"; 

	%if &lastyr >= 2023 %then %do; 
	
		%suppress_vars_2023plus;
	%End; 
	
	%else %do; 
		%suppress_vars;

	%end; 
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


	GapEmp16to64B_&_years.=PctEmp16to64W_&_years./100*Pop16_64yearsB_&_years.-Pop16_64EmployedB_&_years.;
	GapEmp16to64W_&_years.=PctEmp16to64W_&_years./100*Pop16_64yearsW_&_years.-Pop16_64EmployedW_&_years.;
	GapEmp16to64H_&_years.=PctEmp16to64W_&_years./100*Pop16_64yearsH_&_years.-Pop16_64EmployedH_&_years.;
	GapEmp16to64A_&_years.=PctEmp16to64W_&_years./100*Pop16_64yearsA_&_years.-Pop16_64EmployedA_&_years.;
	GapEmp16to64IOM_&_years.=PctEmp16to64W_&_years./100*Pop16_64yearsIOM_&_years.-Pop16_64EmployedIOM_&_years.;
	GapEmp16to64AIOM_&_years.=PctEmp16to64W_&_years./100*Pop16_64yearsAIOM_&_years.-Pop16_64EmployedAIOM_&_years.;

	Gap16plusEmployB_&_years.=Pct16plusEmployW_&_years./100*Pop16andOverYearsB_&_years.-Pop16andOverEmployB_&_years.;
	Gap16plusEmployW_&_years.=Pct16plusEmployW_&_years./100*Pop16andOverYearsW_&_years.-Pop16andOverEmployW_&_years.;
	Gap16plusEmployH_&_years.=Pct16plusEmployW_&_years./100*Pop16andOverYearsH_&_years.-Pop16andOverEmployH_&_years.;
	Gap16plusEmployA_&_years.=Pct16plusEmployW_&_years./100*Pop16andOverYearsA_&_years.-Pop16andOverEmployA_&_years.;
	Gap16plusEmployIOM_&_years.=Pct16plusEmployW_&_years./100*Pop16andOverYearsIOM_&_years.-Pop16andOverEmployIOM_&_years.;
	Gap16plusEmployAIOM_&_years.=Pct16plusEmployW_&_years./100*Pop16andOverYearsAIOM_&_years.-Pop16andOverEmployAIOM_&_years.;

	GapUnemployedB_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceB_&_years.-PopUnemployedB_&_years.;
	GapUnemployedW_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceW_&_years.-PopUnemployedW_&_years.;
	GapUnemployedH_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceH_&_years.-PopUnemployedH_&_years.;
	GapUnemployedA_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceA_&_years.-PopUnemployedA_&_years.;
	GapUnemployedIOM_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceIOM_&_years.-PopUnemployedIOM_&_years.;
	GapUnemployedAIOM_&_years.=PctUnemployedW_&_years./100*PopInCivLaborForceAIOM_&_years.-PopUnemployedAIOM_&_years.;

	Gap16plusWagesB_&_years.=Pct16plusWagesW_&_years./100*Pop16andOverYearsB_&_years.-PopWorkEarnB_&_years.;
	Gap16plusWagesW_&_years.=Pct16plusWagesW_&_years./100*Pop16andOverYearsW_&_years.-PopWorkEarnW_&_years.;
	Gap16plusWagesH_&_years.=Pct16plusWagesW_&_years./100*Pop16andOverYearsH_&_years.-PopWorkEarnH_&_years.;
	Gap16plusWagesA_&_years.=Pct16plusWagesW_&_years./100*Pop16andOverYearsA_&_years.-PopWorkEarnA_&_years.;
	Gap16plusWagesIOM_&_years.=Pct16plusWagesW_&_years./100*Pop16andOverYearsIOM_&_years.-PopWorkEarnIOM_&_years.;
	Gap16plusWagesAIOM_&_years.=Pct16plusWagesW_&_years./100*Pop16andOverYearsAIOM_&_years.-PopWorkEarnAIOM_&_years.;

	Gap16plusWorkFTB_&_years.=Pct16plusWorkFTW_&_years./100*Pop16andOverYearsB_&_years.-PopWorkFTB_&_years.;
	Gap16plusWorkFTW_&_years.=Pct16plusWorkFTW_&_years./100*Pop16andOverYearsW_&_years.-PopWorkFTW_&_years.;
	Gap16plusWorkFTH_&_years.=Pct16plusWorkFTW_&_years./100*Pop16andOverYearsH_&_years.-PopWorkFTH_&_years.;
	Gap16plusWorkFTA_&_years.=Pct16plusWorkFTW_&_years./100*Pop16andOverYearsA_&_years.-PopWorkFTA_&_years.;
	Gap16plusWorkFTIOM_&_years.=Pct16plusWorkFTW_&_years./100*Pop16andOverYearsIOM_&_years.-PopWorkFTIOM_&_years.;
	Gap16plusWorkFTAIOM_&_years.=Pct16plusWorkFTW_&_years./100*Pop16andOverYearsAIOM_&_years.-PopWorkFTAIOM_&_years.;

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

	GapEmpMngmtB_&_years.=PctEmpMngmtW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedMngmtB_&_years.;
	GapEmpMngmtW_&_years.=PctEmpMngmtW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedMngmtW_&_years.;
	GapEmpMngmtH_&_years.=PctEmpMngmtW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedMngmtH_&_years.;
	GapEmpMngmtA_&_years.=PctEmpMngmtW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedMngmtA_&_years.;
	GapEmpMngmtIOM_&_years.=PctEmpMngmtW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedMngmtIOM_&_years.;
	GapEmpMngmtAIOM_&_years.=PctEmpMngmtW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedMngmtAIOM_&_years.;

	GapEmpServB_&_years.=PctEmpServW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedServB_&_years.;
	GapEmpServW_&_years.=PctEmpServW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedServW_&_years.;
	GapEmpServH_&_years.=PctEmpServW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedServH_&_years.;
	GapEmpServA_&_years.=PctEmpServW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedServA_&_years.;
	GapEmpServIOM_&_years.=PctEmpServW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedServIOM_&_years.;
	GapEmpServAIOM_&_years.=PctEmpServW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedServAIOM_&_years.;

	GapEmpSalesB_&_years.=PctEmpSalesW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedSalesB_&_years.;
	GapEmpSalesW_&_years.=PctEmpSalesW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedSalesW_&_years.;
	GapEmpSalesH_&_years.=PctEmpSalesW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedSalesH_&_years.;
	GapEmpSalesA_&_years.=PctEmpSalesW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedSalesA_&_years.;
	GapEmpSalesIOM_&_years.=PctEmpSalesW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedSalesIOM_&_years.;
	GapEmpSalesAIOM_&_years.=PctEmpSalesW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedSalesAIOM_&_years.;

	GapEmpNatResB_&_years.=PctEmpNatResW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedNatResB_&_years.;
	GapEmpNatResW_&_years.=PctEmpNatResW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedNatResW_&_years.;
	GapEmpNatResH_&_years.=PctEmpNatResW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedNatResH_&_years.;
	GapEmpNatResA_&_years.=PctEmpNatResW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedNatResA_&_years.;
	GapEmpNatResIOM_&_years.=PctEmpNatResW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedNatResIOM_&_years.;
	GapEmpNatResAIOM_&_years.=PctEmpNatResW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedNatResAIOM_&_years.;

	GapEmpProdB_&_years.=PctEmpProdW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedProdB_&_years.;
	GapEmpProdW_&_years.=PctEmpProdW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedProdW_&_years.;
	GapEmpProdH_&_years.=PctEmpProdW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedProdH_&_years.;
	GapEmpProdA_&_years.=PctEmpProdW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedProdA_&_years.;
	GapEmpProdIOM_&_years.=PctEmpProdW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedProdIOM_&_years.;
	GapEmpProdAIOM_&_years.=PctEmpProdW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedProdAIOM_&_years.;

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


	Gap16plusEmployW_&_years. = "Difference in # of people 16+ yrs. employed NH-White with equity, &y_lbl."
	Gap16plusEmployB_&_years. = "Difference in # of people 16+ yrs. employed Black-Alone with equity, &y_lbl."
	Gap16plusEmployH_&_years. = "Difference in # of people 16+ yrs. employed Hispanic with equity, &y_lbl."
	Gap16plusEmployA_&_years. = "Difference in # of people 16+ yrs. employed Asian-PI with equity, &y_lbl."
	Gap16plusEmployIOM_&_years. = "Difference in # of people 16+ yrs. employed Indigenous-Other-Multi with equity, &y_lbl."
	Gap16plusEmployAIOM_&_years. = "Difference in # of people 16+ yrs. employed All-Other with equity, &y_lbl."

	GapEmp16to64W_&_years. = "Difference in # of NH-White people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmp16to64B_&_years. = "Difference in # of Black-Alone people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmp16to64H_&_years. = "Difference in # of Hispanic people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmp16to64A_&_years. = "Difference in # of Asian-PI people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmp16to64IOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed between 16 and 64 years old with equity, &y_lbl."
	GapEmp16to64AIOM_&_years. = "Difference in # of All-Other people employed between 16 and 64 years old with equity, &y_lbl."

	GapUnemployedW_&_years. = "Difference in # of NH-White unemployed people with equity, &y_lbl."
	GapUnemployedB_&_years. = "Difference in # of Black-Alone unemployed people with equity, &y_lbl."
	GapUnemployedH_&_years. = "Difference in # of Hispanic unemployed people with equity, &y_lbl."
	GapUnemployedA_&_years. = "Difference in # of Asian-PI unemployed people with equity, &y_lbl."
	GapUnemployedIOM_&_years. = "Difference in # of Indigenous-Other-Multi unemployed people with equity, &y_lbl."
	GapUnemployedAIOM_&_years. = "Difference in # of All-Other unemployed people with equity, &y_lbl."

	Gap16plusWagesW_&_years. = "Difference in # of NH-White people employed with earnings with equity, &y_lbl."
	Gap16plusWagesB_&_years. = "Difference in # of Black-Alone people employed with earnings with equity, &y_lbl."
	Gap16plusWagesH_&_years. = "Difference in # of Hispanic people employed with earnings with equity, &y_lbl."
	Gap16plusWagesA_&_years. = "Difference in # of Asian-PI people employed with earnings with equity, &y_lbl."
	Gap16plusWagesIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed with earnings with equity, &y_lbl."
	Gap16plusWagesAIOM_&_years. = "Difference in # of All-Other people employed with earnings with equity, &y_lbl."

	Gap16plusWorkFTW_&_years. = "Difference in # of NH-White people employed full time with equity, &y_lbl."
	Gap16plusWorkFTB_&_years. = "Difference in # of Black-Alone people employed full time with equity, &y_lbl."
	Gap16plusWorkFTH_&_years. = "Difference in # of Hispanic people employed full time with equity, &y_lbl."
	Gap16plusWorkFTA_&_years. = "Difference in # of Asian-PI people employed full time with equity, &y_lbl."
	Gap16plusWorkFTIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with equity, &y_lbl."
	Gap16plusWorkFTAIOM_&_years. = "Difference in # of All-Other people employed full time with equity, &y_lbl."

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

	GapEmpMngmtW_&_years. = "Difference in # of NH-White people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmpMngmtB_&_years. = "Difference in # of Black-Alone people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmpMngmtH_&_years. = "Difference in # of Hispanic people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmpMngmtA_&_years. = "Difference in # of Asian-PI people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmpMngmtIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in management business science and arts occupations with equity, &y_lbl."
	GapEmpMngmtAIOM_&_years. = "Difference in # of All-Other people employed in management business science and arts occupations with equity, &y_lbl."

	GapEmpServW_&_years. = "Difference in # of NH-White people employed in service occupations with equity, &y_lbl."
	GapEmpServB_&_years. = "Difference in # of Black-Alone people employed in service occupations with equity, &y_lbl."
	GapEmpServH_&_years. = "Difference in # of Hispanic people employed in service occupations with equity, &y_lbl."
	GapEmpServA_&_years. = "Difference in # of Asian-PI people employed in service occupations with equity, &y_lbl."
	GapEmpServIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in service occupations with equity, &y_lbl."
	GapEmpServAIOM_&_years. = "Difference in # of All-Other people employed in service occupations with equity, &y_lbl."

	GapEmpSalesW_&_years. = "Difference in # of NH-White people employed in sales and office occupations with equity, &y_lbl."
	GapEmpSalesB_&_years. = "Difference in # of Black-Alone people employed in sales and office occupations with equity, &y_lbl."
	GapEmpSalesH_&_years. = "Difference in # of Hispanic people employed in sales and office occupations with equity, &y_lbl."
	GapEmpSalesA_&_years. = "Difference in # of Asian-PI people employed in sales and office occupations with equity, &y_lbl."
	GapEmpSalesIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in sales and office occupations with equity, &y_lbl."
	GapEmpSalesAIOM_&_years. = "Difference in # of All-Other people employed in sales and office occupations with equity, &y_lbl."

	GapEmpNatResW_&_years. = "Difference in # of NH-White people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmpNatResB_&_years. = "Difference in # of Black-Alone people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmpNatResH_&_years. = "Difference in # of Hispanic people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmpNatResA_&_years. = "Difference in # of Asian-PI people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmpNatResIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in natural resources construction and maintenance occupations with equity, &y_lbl."
	GapEmpNatResAIOM_&_years. = "Difference in # of All-Other people employed in natural resources construction and maintenance occupations with equity, &y_lbl."

	GapEmpProdW_&_years. = "Difference in # of NH-White people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmpProdB_&_years. = "Difference in # of Black-Alone people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmpProdH_&_years. = "Difference in # of Hispanic people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmpProdA_&_years. = "Difference in # of Asian-PI people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmpProdIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in production transportation and material moving occupations with equity, &y_lbl."
	GapEmpProdAIOM_&_years. = "Difference in # of All-Other people employed in production transportation and material moving occupations with equity, &y_lbl."

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
%mend; 
%allcounty; 

proc sort data=allcounty;
by region;
** Aggregate numerators and denominators to the region-level **;
proc summary data = allcounty;
by region;
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
		   PopInCivLaborFor: mPopInCivLaborFor:
		   PopCivilianEmployed: mPopCivilianEmployed:
		   PopCivilEmployed: mPopCivilEmployed:
           PopUnemployed: mPopUnemployed:
           Pop16andOverYears: mPop16andOverYears: 
           Pop16andOverEmploy: mPop16andOverEmploy: 
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

		   %if &lastyr >= 2023 %then %do;
		   Mortcstbrden:  Mortsvrecstbrden:   mMortcstbrden: mMortsvrecstbrden: 
		   Nomortcstbrden: Nomortsvrecstbrden:  mNomortcstbrden: mNomortsvrecstbrden:
		   Allowncstbrden: Allownsvrecstbrden:  mAllowncstbrden: mAllownsvrecstbrden:
		   Rentcstbrden: Rentsvrecstbrden:  mRentcstbrden: mRentsvrecstbrden: 
		   %end;

		   Gap:
		   ;
	output out = region_agg_a sum=;
run;


** Calculate percents for the region from numerators and denominators**;
%macro region_pct;
data region_agg ; 
  
    set region_agg_a (where=(region~=" "));
    
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

	%Pct_calc( var=PctEmp16to64, label=% persons employed between 16 and 64 years old, num=Pop16_64Employed, den=Pop16_64years, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64_m_&_years., mult=100, num=Pop16_64Employed_&_years., den=Pop16_64years_&_years., 
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

	%Pct_calc( var=PctEmpServ, label=% persons 16+ years old employed in service occupations, num=PopEmployedServ, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpServ_m_&_years., mult=100, num=PopEmployedServ_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedServ_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales, label=% persons 16+ years old employed in sales and office occupations, num=PopEmployedSales, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpSales_m_&_years., mult=100, num=PopEmployedSales_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedSales_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes, label=% persons 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes_m_&_years., mult=100, num=PopEmployedNatRes_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedNatRes_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd, label=% persons employed in production transportation and material moving occupations, num=PopEmployedProd, den=PopEmployedByOcc, years=&_years. )

	%Moe_prop_a( var=PctEmpProd_m_&_years., mult=100, num=PopEmployedProd_&_years., den=PopEmployedByOcc_&_years., 
                       num_moe=mPopEmployedProd_&_years., den_moe=mPopEmployedByOcc_&_years., label_moe =% persons employed in production transportation and material moving occupations MOE &y_lbl.);

/*gender breakout for employment*/
	%Pct_calc( var=Pct16plusEmploy_ML, label=% Male 16+ yrs. employed, num=Pop16andOverEmp_M, den=Pop16andOverYears_M, years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy_ML_m_&_years., mult=100, num=Pop16andOverEmp_M_&_years., den=Pop16andOverYears_M_&_years., 
                       num_moe=mPop16andOverEmp_M_&_years., den_moe=mPop16andOverYears_M_&_years., label_moe =% Male 16+ yrs. employed MOE &y_lbl.);

	%Pct_calc( var=Pct16plusEmploy_F, label=% Female 16+ yrs. employed, num=Pop16andOverEmp_F, den=Pop16andOverYears_F, years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy_F_m_&_years., mult=100, num=Pop16andOverEmp_F_&_years., den=Pop16andOverYears_F_&_years., 
                       num_moe=mPop16andOverEmp_F_&_years., den_moe=mPop16andOverYears_F_&_years., label_moe =% Female 16+ yrs. employed MOE &y_lbl.);

	%Pct_calc( var=PctEmp16to64_ML, label=% Male employed between 16 and 64 years old, num=Pop16_64Employed_M, den=Pop16_64years_M, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64_ML_m_&_years., mult=100, num=Pop16_64Employed_M_&_years., den=Pop16_64years_M_&_years., 
                       num_moe=mPop16_64Employed_M_&_years., den_moe=mPop16_64years_M_&_years., label_moe =% male employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=PctEmp16to64_F, label=% Female employed between 16 and 64 years old, num=Pop16_64Employed_F, den=Pop16_64years_F, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64_F_m_&_years., mult=100, num=Pop16_64Employed_F_&_years., den=Pop16_64years_F_&_years., 
                       num_moe=mPop16_64Employed_F_&_years., den_moe=mPop16_64years_F_&_years., label_moe =% female employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=PctUnemployed_ML, label=Unemployment rate male (%), num=PopUnemployed_M, den=PopInCivLaborForce_M, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_ML_m_&_years., mult=100, num=PopUnemployed_M_&_years., den=PopInCivLaborForce_M_&_years., 
	                       num_moe=mPopUnemployed_M_&_years., den_moe=mPopInCivLaborForce_M_&_years., label_moe =Unemployment rate male (%) MOE &y_lbl.);

    %Pct_calc( var=PctUnemployed_F, label=Unemployment rate female (%), num=PopUnemployed_F, den=PopInCivLaborForce_F, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_F_m_&_years., mult=100, num=PopUnemployed_F_&_years., den=PopInCivLaborForce_F_&_years., 
	                       num_moe=mPopUnemployed_F_&_years., den_moe=mPopInCivLaborForce_F_&_years., label_moe =Unemployment rate female (%) MOE &y_lbl.);

	    %Pct_calc( var=Pct16plusWorkFT_ML, label=% male employed full time, num=PopWorkFT_M, den=Pop16andOverYears_M, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT_ML_m_&_years., mult=100, num=PopWorkFT_M_&_years., den=Pop16andOverYears_M_&_years., 
                       num_moe=mPopWorkFT_M_&_years., den_moe=mPop16andOverYears_M_&_years., label_moe =% male employed full time MOE &y_lbl.);

   %Pct_calc( var=Pct16plusWorkFT_F, label=% female employed full time, num=PopWorkFT_F, den=Pop16andOverYears_F, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT_F_m_&_years., mult=100, num=PopWorkFT_F_&_years., den=Pop16andOverYears_F_&_years., 
                       num_moe=mPopWorkFT_F_&_years., den_moe=mPop16andOverYears_F_&_years., label_moe =% female employed full time MOE &y_lbl.);

   %Pct_calc( var=Pct16plusWages_ML, label=% male 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn_M, den=Pop16andOverYears_M, years=&_years. )

    %Moe_prop_a( var=Pct16plusWages_ML_m_&_years., mult=100, num=PopWorkEarn_M_&_years., den=Pop16andOverYears_M_&_years., 
                       num_moe=mPopWorkEarn_M_&_years., den_moe=mPop16andOverYears_M_&_years., label_moe =% male 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWages_F, label=% female 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn_F, den=Pop16andOverYears_F, years=&_years. )

    %Moe_prop_a( var=Pct16plusWages_F_m_&_years., mult=100, num=PopWorkEarn_F_&_years., den=Pop16andOverYears_F_&_years., 
                       num_moe=mPopWorkEarn_F_&_years., den_moe=mPop16andOverYears_F_&_years., label_moe =% female 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);


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
		%let name=%scan(&racename.,&r.," ");
		 
	%Pct_calc( var=PctUnemployed&race., label=&name. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._m_&_years., mult=100, num=PopUnemployed&race._&_years., den=PopInCivLaborForce&race._&_years., 
	                       num_moe=mPopUnemployed&race._&_years., den_moe=mPopInCivLaborForce&race._&_years., label_moe =&name. Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctEmp16to64&race., label=% persons &name. employed between 16 and 64 years old, num=Pop16_64Employed&race., den=Pop16_64years&race., years=&_years. )

	%Moe_prop_a( var=PctEmp16to64&race._m_&_years., mult=100, num=Pop16_64Employed&race._&_years., den=Pop16_64years&race._&_years., 
                       num_moe=mPop16_64Employed&race._&_years., den_moe=mPop16_64years&race._&_years., label_moe =% persons &name. employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=Pct16plusEmploy&race., label=% pop. 16+ yrs. employed &name., num=Pop16andOverEmploy&race., den=Pop16andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy&race._m_&_years., mult=100, num=Pop16andOverEmploy&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPop16andOverEmploy&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% pop. 16+ yrs. employed &name. MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWages&race., label=% persons &name. employed with earnings, num=PopWorkEarn&race., den=Pop16andOverYears&race., years=&_years. )

	%Moe_prop_a( var=Pct16plusWages&race._m_&_years., mult=100, num=PopWorkEarn&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPopWorkEarn&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% persons &name. employed with earnings MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWorkFT&race., label=% persons &name. employed full time, num=PopWorkFT&race., den=Pop16andOverYears&race., years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT&race._m_&_years., mult=100, num=PopWorkFT&race._&_years., den=Pop16andOverYears&race._&_years., 
                       num_moe=mPopWorkFT&race._&_years., den_moe=mPop16andOverYears&race._&_years., label_moe =% persons &name. employed full time MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race., label=% persons &name. employed full time with earnings less than 35000, num=PopWorkFTLT35K&race., den=PopWorkFT&race., years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._m_&_years., mult=100, num=PopWorkFTLT35k&race._&_years., den=PopWorkFT&race._&_years., 
                       num_moe=mPopWorkFTLT35k&race._&_years., den_moe=mPopWorkFT&race._&_years., label_moe =% persons &name. employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k&race., label=% persons &name. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race., den=PopWorkFT&race., years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._m_&_years., mult=100, num=PopWorkFTLT75k&race._&_years., den=PopWorkFT&race._&_years., 
                       num_moe=mPopWorkFTLT75k&race._&_years., den_moe=mPopWorkFT&race._&_years., label_moe =% persons &name. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctEmpMngmt&race., label=% persons &name. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt&race._m_&_years., mult=100, num=PopEmployedMngmt&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedMngmt&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ&race., label=% persons &name. 16+ years old employed in service occupations, num=PopEmployedServ&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpServ&race._m_&_years., mult=100, num=PopEmployedServ&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedServ&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales&race., label=% persons &name. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpSales&race._m_&_years., mult=100, num=PopEmployedSales&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedSales&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes&race., label=% persons &name. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes&race._m_&_years., mult=100, num=PopEmployedNatRes&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedNatRes&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd&race., label=% persons &name. employed in production transportation and material moving occupations, num=PopEmployedProd&race., den=PopEmployedByOcc&race., years=&_years. )

	%Moe_prop_a( var=PctEmpProd&race._m_&_years., mult=100, num=PopEmployedProd&race._&_years., den=PopEmployedByOcc&race._&_years., 
                       num_moe=mPopEmployedProd&race._&_years., den_moe=mPopEmployedByOcc&race._&_years., label_moe =% persons &name. employed in production transportation and material moving occupations MOE &y_lbl.);

/*gender breakout for employment*/

	%Pct_calc( var=Pct16plusEmploy&race._ML, label=% Male 16+ yrs. employed &name., num=Pop16andOverEmp&race._M, den=Pop16andOverYears&race._M, years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy&race._ML_m_&_years., mult=100, num=Pop16andOverEmp&race._M_&_years., den=Pop16andOverYears&race._M_&_years., 
                       num_moe=mPop16andOverEmp&race._M_&_years., den_moe=mPop16andOverYears&race._M_&_years., label_moe =% Male 16+ yrs. employed &name. MOE &y_lbl.);
	
	%Pct_calc( var=Pct16plusEmploy&race._F, label=% Female 16+ yrs. employed &name., num=Pop16andOverEmp&race._M, den=Pop16andOverYears&race._M, years=&_years. )

    %Moe_prop_a( var=Pct16plusEmploy&race._F_m_&_years., mult=100, num=Pop16andOverEmp&race._F_&_years., den=Pop16andOverYears&race._F_&_years., 
                       num_moe=mPop16andOverEmp&race._F_&_years., den_moe=mPop16andOverYears&race._F_&_years., label_moe =% Female 16+ yrs. employed &name. MOE &y_lbl.);


	%Pct_calc( var=PctEmp16to64&race._ML, label=% Male &name. employed between 16 and 64 years old, num=Pop16_64Employed&race._M, den=Pop16_64years&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64&race._ML_m_&_years., mult=100, num=Pop16_64Employed&race._M_&_years., den=Pop16_64years&race._M_&_years., 
                       num_moe=mPop16_64Employed&race._M_&_years., den_moe=mPop16_64years&race._M_&_years., label_moe =% male &name. employed between 16 and 64 years old MOE &y_lbl.);

	%Pct_calc( var=PctEmp16to64&race._F, label=% Female &name. employed between 16 and 64 years old, num=Pop16_64Employed_F, den=Pop16_64years_F, years=&_years. )

	%Moe_prop_a( var=PctEmp16to64&race._F_m_&_years., mult=100, num=Pop16_64Employed&race._F_&_years., den=Pop16_64years&race._F_&_years., 
                       num_moe=mPop16_64Employed&race._F_&_years., den_moe=mPop16_64years&race._F_&_years., label_moe =% female &name. employed between 16 and 64 years old MOE &y_lbl.);

	
	%Pct_calc( var=PctUnemployed&race._ML, label=Unemployment rate male &name. (%), num=PopUnemployed&race._M, den=PopInCivLaborFor&race._M, years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._ML_m_&_years., mult=100, num=PopUnemployed&race._M_&_years., den=PopInCivLaborFor&race._M_&_years., 
	                       num_moe=mPopUnemployed&race._M_&_years., den_moe=mPopInCivLaborFor&race._M_&_years., label_moe =Unemployment rate male &name. (%) MOE &y_lbl.);

    %Pct_calc( var=PctUnemployed&race._F, label=Unemployment rate female &name. (%), num=PopUnemployed&race._F, den=PopInCivLaborFor&race._F, years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._F_m_&_years., mult=100, num=PopUnemployed&race._F_&_years., den=PopInCivLaborFor&race._F_&_years., 
	                       num_moe=mPopUnemployed&race._F_&_years., den_moe=mPopInCivLaborFor&race._F_&_years., label_moe =Unemployment rate female &name. (%) MOE &y_lbl.);

	 %Pct_calc( var=Pct16plusWorkFT&race._ML, label=% male &name. employed full time, num=PopWorkFT&race._M, den=Pop16andOverYears&race._M, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT&race._ML_m_&_years., mult=100, num=PopWorkFT&race._M_&_years., den=Pop16andOverYears&race._M_&_years., 
                       num_moe=mPopWorkFT&race._M_&_years., den_moe=mPop16andOverYears&race._M_&_years., label_moe =% male &name. employed full time MOE &y_lbl.);

   %Pct_calc( var=Pct16plusWorkFT&race._F, label=% female &name. employed full time, num=PopWorkFT&race._F, den=Pop16andOverYears&race._F, years=&_years. )

    %Moe_prop_a( var=Pct16plusWorkFT&race._F_m_&_years., mult=100, num=PopWorkFT&race._F_&_years., den=Pop16andOverYears&race._F_&_years., 
                       num_moe=mPopWorkFT&race._F_&_years., den_moe=mPop16andOverYears&race._F_&_years., label_moe =% female &name. employed full time MOE &y_lbl.);

 %Pct_calc( var=Pct16plusWages&race._ML, label=% male &name. 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn&race._M, den=Pop16andOverYears&race._M, years=&_years. )

    %Moe_prop_a( var=Pct16plusWages&race._ML_m_&_years., mult=100, num=PopWorkEarn&race._M_&_years., den=Pop16andOverYears&race._M_&_years., 
                       num_moe=mPopWorkEarn&race._M_&_years., den_moe=mPop16andOverYears&race._M_&_years., label_moe =% male &name. 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	%Pct_calc( var=Pct16plusWages&race._F, label=% female &name. 16 and Older with Wage Earnings in the Past 12 Months, num=PopWorkEarn&race._F, den=Pop16andOverYears&race._F, years=&_years. )

    %Moe_prop_a( var=Pct16plusWages&race._F_m_&_years., mult=100, num=PopWorkEarn&race._F_&_years., den=Pop16andOverYears&race._F_&_years., 
                       num_moe=mPopWorkEarn&race._F_&_years., den_moe=mPop16andOverYears&race._F_&_years., label_moe =% female &name. 16 and Older with Wage Earnings in the Past 12 Months MOE &y_lbl.);

	
	%Pct_calc( var=PctWorkFTLT75k&race._ML, label=% male &name. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race._M, den=PopWorkFT&race._M, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._ML_m_&_years., mult=100, num=PopWorkFTLT75k&race._M_&_years., den=PopWorkFT&race._M_&_years., 
                       num_moe=mPopWorkFTLT75k&race._M_&_years., den_moe=mPopWorkFT&race._M_&_years., label_moe =% male &name. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT75k&race._F, label=% female &name. employed full time with earnings less than 75000, num=PopWorkFTLT75k&race._F, den=PopWorkFT&race._F, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT75k&race._F_m_&_years., mult=100, num=PopWorkFTLT75k&race._F_&_years., den=PopWorkFT&race._F_&_years., 
                       num_moe=mPopWorkFTLT75k&race._F_&_years., den_moe=mPopWorkFT&race._F_&_years., label_moe =% female &name. employed full time with earnings less than 75000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race._ML, label=% male &name. employed full time with earnings less than 35000, num=PopWorkFTLT35k&race._M, den=PopWorkFT&race._M, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._ML_m_&_years., mult=100, num=PopWorkFTLT35k&race._M_&_years., den=PopWorkFT&race._M_&_years., 
                       num_moe=mPopWorkFTLT35k&race._M_&_years., den_moe=mPopWorkFT&race._M_&_years., label_moe =% male &name. employed full time with earnings less than 35000 MOE &y_lbl.);

	%Pct_calc( var=PctWorkFTLT35k&race._F, label=% female &name. employed full time with earnings less than 35000, num=PopWorkFTLT35k&race._F, den=PopWorkFT&race._F, years=&_years. )

	%Moe_prop_a( var=PctWorkFTLT35k&race._F_m_&_years., mult=100, num=PopWorkFTLT35k&race._F_&_years., den=PopWorkFT&race._F_&_years., 
                       num_moe=mPopWorkFTLT35k&race._F_&_years., den_moe=mPopWorkFT&race._F_&_years., label_moe =% female &name. employed full time with earnings less than 35000 MOE &y_lbl.);


	%Pct_calc( var=PctEmpMngmt&race._ML, label=% male &name. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt&race._ML_m_&_years., mult=100, num=PopEmployedMngmt&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedMngmt&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &name. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ&race._ML, label=% male &name. 16+ years old employed in service occupations, num=PopEmployedServ&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpServ&race._ML_m_&_years., mult=100, num=PopEmployedServ&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedServ&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &name. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales&race._ML, label=% male &name. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpSales&race._ML_m_&_years., mult=100, num=PopEmployedSales&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedSales&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &name. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes&race._ML, label=% male &name. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes&race._ML_m_&_years., mult=100, num=PopEmployedNatRes&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedNatRes&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &name. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd&race._ML, label=% male &name. employed in production transportation and material moving occupations, num=PopEmployedProd&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpProd&race._ML_m_&_years., mult=100, num=PopEmployedProd&race._M_&_years., den=PopEmployedByOcc&race._M_&_years., 
                       num_moe=mPopEmployedProd&race._M_&_years., den_moe=mPopEmployedByOcc&race._M_&_years., label_moe =% male &name. employed in production transportation and material moving occupations MOE &y_lbl.);

    %Pct_calc( var=PctEmpMngmt&race._F, label=% female &name. 16+ years old employed in management business science and arts occupations, num=PopEmployedMngmt&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpMngmt&race._F_m_&_years., mult=100, num=PopEmployedMngmt&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedMngmt&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &name. 16+ years old employed in management business science and arts occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpServ&race._F, label=% female &name. 16+ years old employed in service occupations, num=PopEmployedServ&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpServ&race._F_m_&_years., mult=100, num=PopEmployedServ&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedServ&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &name. 16+ years old employed in service occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpSales&race._F, label=% female &name. 16+ years old employed in sales and office occupations, num=PopEmployedSales&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpSales&race._F_m_&_years., mult=100, num=PopEmployedSales&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedSales&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &name. 16+ years old employed in sales and office occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpNatRes&race._F, label=% female &name. 16+ years old employed in natural resources construction and maintenance occupations, num=PopEmployedNatRes&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpNatRes&race._F_m_&_years., mult=100, num=PopEmployedNatRes&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedNatRes&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &name. 16+ years old employed in natural resources construction and maintenance occupations MOE &y_lbl.);

	%Pct_calc( var=PctEmpProd&race._F, label=% female &name. employed in production transportation and material moving occupations, num=PopEmployedProd&race._M, den=PopEmployedByOcc&race._M, years=&_years. )

	%Moe_prop_a( var=PctEmpProd&race._F_m_&_years., mult=100, num=PopEmployedProd&race._F_&_years., den=PopEmployedByOcc&race._F_&_years., 
                       num_moe=mPopEmployedProd&race._F_&_years., den_moe=mPopEmployedByOcc&race._F_&_years., label_moe =% female &name. employed in production transportation and material moving occupations MOE &y_lbl.);

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

	%dollar_convert( AvgHshldIncome_&_years., AvgHshldIncAdj_&_years., &inc_from_yr, &inc_dollar_yr )

    AvgHshldIncome_m_&_years. = 
      %Moe_ratio( num=AggHshldIncome_&_years., den=NumHshlds_&_years., 
                  num_moe=mAggHshldIncome_&_years., den_moe=mNumHshlds_&_years.);
                        
    %dollar_convert( AvgHshldIncome_m_&_years., AvgHshldIncAdj_m_&_years., &inc_from_yr, &inc_dollar_yr )

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

	%dollar_convert( AvgHshldIncome&race._&_years., AvgHshldIncAdj&race._&_years., &inc_from_yr, &inc_dollar_yr )

    AvgHshldIncome&race._m_&_years. = 
      %Moe_ratio( num=AggHshldIncome&race._&_years., den=NumHshlds&race._&_years., 
                  num_moe=mAggHshldIncome&race._&_years., den_moe=mNumHshlds&race._&_years.);
                        
    %dollar_convert( AvgHshldIncome&race._m_&_years., AvgHshldIncAdj&race._m_&_years., &inc_from_yr, &inc_dollar_yr )

	%end;

	label
	  AvgHshldIncAdj_&_years. = "Average household income (adjusted) $&inc_from_yr., &y_lbl."
	  AvgHshldIncAdj_m_&_years. = "Average household income (adjusted) $&inc_from_yr. MOE, &y_lbl."
	  AvgHshldIncAdjB_&_years. = "Average household income (adjusted) $&inc_from_yr., Black/African American, &y_lbl."
	  AvgHshldIncAdjB_m_&_years. = "Average household income (adjusted) $&inc_from_yr., Black/African American MOE, &y_lbl."
	  AvgHshldIncAdjW_&_years. = "Average household income (adjusted) $&inc_from_yr., Non-Hispanic White, &y_lbl."
	  AvgHshldIncAdjW_m_&_years. = "Average household income (adjusted) $&inc_from_yr., Non-Hispanic White MOE, &y_lbl."
	  AvgHshldIncAdjH_&_years. = "Average household income (adjusted) $&inc_from_yr., Hispanic/Latino, &y_lbl."
	  AvgHshldIncAdjH_m_&_years. = "Average household income (adjusted) $&inc_from_yr., Hispanic/Latino MOE, &y_lbl."
	  AvgHshldIncAdjA_&_years. = "Average household income (adjusted) $&inc_from_yr., Asian-PI, &y_lbl."
	  AvgHshldIncAdjA_m_&_years. = "Average household income (adjusted) $&inc_from_yr., Asian-PI MOE, &y_lbl."
	  AvgHshldIncAdjIOM_&_years. = "Average household income (adjusted) $&inc_from_yr., Indigenous, Other or Multiple race, &y_lbl."
	  AvgHshldIncAdjIOM_m_&_years. = "Average household income (adjusted) $&inc_from_yr., Indigenous, Other or Multiple Race MOE, &y_lbl."
	  AvgHshldIncAdjAIOM_&_years. = "Average household income (adjusted) $&inc_from_yr., All remaining groups other than Black, Non-Hispanic White, Hispanic, &y_lbl."
	  AvgHshldIncAdjAIOM_m_&_years. = "Average household income (adjusted) $&inc_from_yr., All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &y_lbl."
	  AvgHshldIncome_m_&_years. = "Average household income $&inc_from_yr., MOE, &y_lbl."
	  AvgHshldIncomeB_m_&_years. = "Average household income $&inc_from_yr., Black/African American, MOE, &y_lbl."
	  AvgHshldIncomeW_m_&_years. = "Average household income $&inc_from_yr., Non-Hispanic White, MOE, &y_lbl."
	  AvgHshldIncomeH_m_&_years. = "Average household income $&inc_from_yr., Hispanic/Latino, MOE, &y_lbl."
	  AvgHshldIncomeA_m_&_years. = "Average household income $&inc_from_yr., Asian-PI, MOE, &y_lbl."
	  AvgHshldIncomeIOM_m_&_years. = "Average household income $&inc_from_yr., Indigenous, Other or Multiple Race  MOE, &y_lbl."
	  AvgHshldIncomeAIOM_m_&_years. = "Average household income $&inc_from_yr., All remaining groups other than Black, Non-Hispanic White, Hispanic, MOE, &y_lbl."
      ;

        

    ** Housing Conditions **;
    
    %Label_var_years( var=NumOccupiedHsgUnits, label=Occupied housing units, years=&_years. )

    %Pct_calc( var=PctVacantHsgUnitsForRent, label=Rental vacancy rate (%), num=NumVacantHsgUnitsForRent, den=NumRenterHsgUnits, years=&_years. )

	%Moe_prop_a( var=PctVacantHUForRent_m_&_years., mult=100, num=NumVacantHsgUnitsForRent_&_years., den=NumRenterHsgUnits_&_years., 
                       num_moe=mNumVacantHUForRent_&_years., den_moe=mNumRenterHsgUnits_&_years., label_moe =Rental vacancy rate (%) MOE &y_lbl.);

    %Pct_calc( var=PctOwnerOccupiedHU, label=Homeownership rate (%), num=NumOwnerOccupiedHU, den=NumOccupiedHsgUnits, years=&_years. )

    %Moe_prop_a( var=PctOwnerOccupiedHU_m_&_years., mult=100, num=NumOwnerOccupiedHU_&_years., den=NumOccupiedHsgUnits_&_years., 
                       num_moe=mNumOwnerOccupiedHU_&_years., den_moe=mNumOccupiedHsgUnits_&_years., label_moe =Homeownership rate (%) MOE &y_lbl.);


		*new vars beginning in 2019-23 data; 
		%if &lastyr. >= 2023 %then %do; 

		%Pct_calc( var=PctMortcstbrden, label=% Owners with Mortgage who are cost-burdened, num=Mortcstbrden, den=mortcstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctMortcstbrden_m_&_years., mult=100, num=Mortcstbrden_&_years., den=mortcstbrdencalc_&_years., 
	                       num_moe=mMortcstbrden_&_years., den_moe=mMortcstbrdencalc_&_years., label_moe =% Owners with Mortgage who are cost-burdened MOE &y_lbl.);
		%Pct_calc( var=PctMortSCstbrden, label=% Owners with Mortgage who are severely cost-burdened, num=Mortsvrecstbrden, den=mortcstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctMortSCstbrden_m_&_years., mult=100, num=Mortsvrecstbrden_&_years., den=mortcstbrdencalc_&_years., 
	                       num_moe=mMortSvrecstbrden_&_years., den_moe=mMortcstbrdencalc_&_years., label_moe =% Owners with Mortgage who are severely cost-burdened MOE &y_lbl.);

		%Pct_calc( var=PctNomortcstbrden, label=% Owners without Mortgage who are cost-burdened, num=NoMortcstbrden, den=Nomortcstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctNomortcstbrden_m_&_years., mult=100, num=Nomortcstbrden_&_years., den=Nomortcstbrdencalc_&_years., 
	                       num_moe=mNomortcstbrden_&_years., den_moe=mNoMortcstbrdencalc_&_years., label_moe =% Owners without Mortgage who are cost-burdened MOE &y_lbl.);
		%Pct_calc( var=PctNoMortSCstbrden, label=% Owners without Mortgage who are severely cost-burdened, num=NoMortsvrecstbrden, den=Nomortcstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctNoMortSCstbrden_m_&_years., mult=100, num=NoMortsvrecstbrden_&_years., den=Nomortcstbrdencalc_&_years., 
	                       num_moe=mNoMortSvrecstbrden_&_years., den_moe=mNoMortcstbrdencalc_&_years., label_moe =% Owners without Mortgage who are severely cost-burdened MOE &y_lbl.);

		%Pct_calc( var=PctAllOwnCstbrden, label=% All Owners who are cost-burdened, num=AllOwnCstbrden, den=AllOwnCstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctAllOwnCstbrden_m_&_years., mult=100, num=AllOwnCstbrden_&_years., den=AllOwnCstbrdencalc_&_years., 
	                       num_moe=mAllOwnCstbrden_&_years., den_moe=mAllOwnCstbrdencalc_&_years., label_moe =% All Owners who are cost-burdened MOE &y_lbl.);
		%Pct_calc( var=PctAllOwnSCstbrden, label=% All Owners who are severely cost-burdened, num=AllOwnSvrecstbrden, den=AllOwnCstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctAllOwnSCstbrden_m_&_years., mult=100, num=AllOwnSvrecstbrden_&_years., den=AllOwnCstbrdencalc_&_years., 
	                       num_moe=mAllOwnSvrecstbrden_&_years., den_moe=mAllOwnCstbrdencalc_&_years., label_moe =% All Owners who are severely cost-burdened MOE &y_lbl.);

		%Pct_calc( var=PctRentCstbrden, label=% Renters who are cost-burdened, num=RentCstbrden, den=RentCstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctRentCstbrden_m_&_years., mult=100, num=RentCstbrden_&_years., den=RentCstbrdencalc_&_years., 
	                       num_moe=mRentCstbrden_&_years., den_moe=mRentCstbrdencalc_&_years., label_moe =% Renters who are cost-burdened MOE &y_lbl.);
		%Pct_calc( var=PctRentSCstbrden, label=% Renters who are severely cost-burdened, num=RentSvrecstbrden, den=RentCstbrdencalc, years=&_years. )
			%Moe_prop_a( var=PctRentSCstbrden_m_&_years., mult=100, num=RentSvrecstbrden_&_years., den=RentCstbrdencalc_&_years., 
	                       num_moe=mRentSvrecstbrden_&_years., den_moe=mRentCstbrdencalc_&_years., label_moe =% Renters who are severely cost-burdened MOE &y_lbl.);

		%end; 

	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

    %Pct_calc( var=PctOwnerOccupiedHU&race., label=Homeownership rate &name.(%), num=NumOwnerOccupiedHU&race., den=NumOccupiedHsgUnits&race., years=&_years. )

    
    %Moe_prop_a( var=PctOwnerOccupiedHU&race._m_&_years., mult=100, num=NumOwnerOccupiedHU&race._&_years., den=NumOccupiedHsgUnits&race._&_years., 
                       num_moe=mNumOwnerOccupiedHU&race._&_years., den_moe=mNumOccupiedHsgUnits&race._&_years., label_moe =Homeownership rate &name.(%) MOE &y_lbl.);
    

					%if &lastyr. >= 2023 %then %do; 

		%Pct_calc( var=PctMortcstbrden&race., label=% Owners with Mortgage who are cost-burdened &name., num=Mortcstbrden&race., den=mortcstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctMortcstbrden&race._m_&_years., mult=100, num=Mortcstbrden&race._&_years., den=mortcstbrdencalc&race._&_years., 
	                       num_moe=mMortcstbrden&race._&_years., den_moe=mMortcstbrdencalc&race._&_years., label_moe =% Owners with Mortgage who are cost-burdened &name. MOE &y_lbl.);
		%Pct_calc( var=PctMortSCstbrden&race., label=% Owners with Mortgage who are severely cost-burdened &name., num=Mortsvrecstbrden&race., den=mortcstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctMortSCstbrden&race._m_&_years., mult=100, num=Mortsvrecstbrden&race._&_years., den=mortcstbrdencalc&race._&_years., 
	                       num_moe=mMortSvrecstbrden&race._&_years., den_moe=mMortcstbrdencalc&race._&_years., label_moe =% Owners with Mortgage who are severely cost-burdened &name.  MOE &y_lbl.);

		%Pct_calc( var=PctNomortcstbrden&race., label=% Owners without Mortgage who are cost-burdened &name., num=NoMortcstbrden&race., den=Nomortcstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctNomortcstbrden&race._m_&_years., mult=100, num=Nomortcstbrden&race._&_years., den=Nomortcstbrdencalc&race._&_years., 
	                       num_moe=mNomortcstbrden&race._&_years., den_moe=mNoMortcstbrdencalc&race._&_years., label_moe =% Owners without Mortgage who are cost-burdened &name. MOE &y_lbl.);
		%Pct_calc( var=PctNoMortSCstbrden&race., label=% Owners without Mortgage who are severely cost-burdened &name., num=NoMortsvrecstbrden&race., den=Nomortcstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctNoMortSCstbrden&race._m_&_years., mult=100, num=NoMortsvrecstbrden&race._&_years., den=Nomortcstbrdencalc&race._&_years., 
	                       num_moe=mNoMortSvrecstbrden&race._&_years., den_moe=mNoMortcstbrdencalc&race._&_years., label_moe =% Owners without Mortgage who are severely cost-burdened &name.  MOE &y_lbl.);

		%Pct_calc( var=PctAllOwnCstbrden&race., label=% All Owners who are cost-burdened &name., num=AllOwnCstbrden&race., den=AllOwnCstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctAllOwnCstbrden&race._m_&_years., mult=100, num=AllOwnCstbrden&race._&_years., den=AllOwnCstbrdencalc&race._&_years., 
	                       num_moe=mAllOwnCstbrden&race._&_years., den_moe=mAllOwnCstbrdencalc&race._&_years., label_moe =% All Owners who are cost-burdened &name.  MOE &y_lbl.);
		%Pct_calc( var=PctAllOwnSCstbrden&race., label=% All Owners who are severely cost-burdened &name., num=AllOwnSvrecstbrden&race., den=AllOwnCstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctAllOwnSCstbrden&race._m_&_years., mult=100, num=AllOwnSvrecstbrden&race._&_years., den=AllOwnCstbrdencalc&race._&_years., 
	                       num_moe=mAllOwnSvrecstbrden&race._&_years., den_moe=mAllOwnCstbrdencalc&race._&_years., label_moe =% All Owners who are severely cost-burdened &name. MOE &y_lbl.);

		%Pct_calc( var=PctRentCstbrden&race., label=% Renters who are cost-burdened &name., num=RentCstbrden&race., den=RentCstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctRentCstbrden&race._m_&_years., mult=100, num=RentCstbrden&race._&_years., den=RentCstbrdencalc&race._&_years., 
	                       num_moe=mRentCstbrden&race._&_years., den_moe=mRentCstbrdencalc&race._&_years., label_moe =% Renters who are cost-burdened &name.  MOE &y_lbl.);
		%Pct_calc( var=PctRentSCstbrden&race., label=% Renters who are severely cost-burdened &name., num=RentSvrecstbrden&race., den=RentCstbrdencalc&race., years=&_years. )
			%Moe_prop_a( var=PctRentSCstbrden&race._m_&_years., mult=100, num=RentSvrecstbrden&race._&_years., den=RentCstbrdencalc&race._&_years., 
	                       num_moe=mRentSvrecstbrden&race._&_years., den_moe=mRentCstbrdencalc&race._&_years., label_moe =% Renters who are severely cost-burdened &name. MOE &y_lbl.);

		%end; 

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

	ucounty = "0";
    
 
  run;

  %mend region_pct;
  %region_pct;


** Stack county and region data **;
data Profile_acs_region;
	set allcounty region_agg (drop = _type_ _freq_);

	if ucounty="0" and region="Washington" then ucounty="11XXX";
	if ucounty="0" and region="Baltimore" then ucounty="24XXX";
	if ucounty="0" and region="Richmond" then ucounty="51XXX";
	
	order=.;
	if region="Washington" then order=1;
	if ucounty="11001" then order=2;
	if ucounty="24017" then order=3;
	if ucounty="24021" then order=4; 
	if ucounty="24031" then order=5;
	if ucounty="24033" then order=6;
	if ucounty="51510" then order=7;
	if ucounty="51013" then order=8;
	if ucounty="51610" then order=9;
	if ucounty="51059" then order=10;
	if ucounty="51600" then order=11;
	if ucounty="51107" then order=12;
	if ucounty="51153" then order=13;
	if ucounty="51683" then order=14; 
	if ucounty="51685" then order=15; 

	if region="Baltimore" then order=16;
	if ucounty="24510" then order=17;
	if ucounty="24005" then order=18;
	if ucounty="24003" then order=19;
	if ucounty="24027" then order=20;
	if ucounty="24013" then order=21;
	if ucounty="24025" then order=22;
	if ucounty="24035" then order=23;

	if region="Richmond" then order=24;
	if ucounty="51760" then order=25;
	if ucounty="51041" then order=26;
	if ucounty="51087" then order=27;
	

	drop cv: p n x a_se b_se: uPct: uAvg: z c_se d_se den denA denAIOM denIOM denB denH denW f k lAvg: lPct: num numA numAIOM numIOM numB numH numW zA zAIOM zIOM zB zH zW ;
run;

proc sort data = Profile_acs_region; by order; run;


** Round numbers **;
%round_output (in=Profile_acs_region,out=Profile_acs_region_rounded);

%macro raceunemp;

	%do r=1 %to 6;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

		
	%Pct_calc( var=PctUnemployed&race., label=&name. Unemployment rate (%), num=PopUnemployed&race., den=PopInCivLaborForce&race., years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._m_&_years., mult=100, num=PopUnemployed&race._&_years., den=PopInCivLaborForce&race._&_years., 
	               num_moe=mPopUnemployed&race._&_years., den_moe=mPopInCivLaborForceW_&_years., label_moe =&name. Unemployment rate (%) MOE &y_lbl.);

	%Pct_calc( var=PctUnemployed&race._ML, label=Unemployment rate male &name. (%), num=PopUnemployed&race._M, den=PopInCivLaborFor&race._M, years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._ML_m_&_years., mult=100, num=PopUnemployed&race._M_&_years., den=PopInCivLaborFor&race._M_&_years., 
	                       num_moe=mPopUnemployed&race._M_&_years., den_moe=mPopInCivLaborFor&race._M_&_years., label_moe =Unemployment rate male &name. (%) MOE &y_lbl.);

    %Pct_calc( var=PctUnemployed&race._F, label=Unemployment rate female &name. (%), num=PopUnemployed&race._F, den=PopInCivLaborFor&race._F, years=&_years. )

	%Moe_prop_a( var=PctUnemployed&race._F_m_&_years., mult=100, num=PopUnemployed&race._F_&_years., den=PopInCivLaborFor&race._F_&_years., 
	                       num_moe=mPopUnemployed&race._F_&_years., den_moe=mPopInCivLaborFor&race._F_&_years., label_moe =Unemployment rate female &name. (%) MOE &y_lbl.);

	%end;
%mend;

*temporary fix;
data donotroundunemp;
	set Profile_acs_region_rounded (drop=PctUnemployed:);

	%Pct_calc( var=PctUnemployed, label=Unemployment rate (%), num=PopUnemployed, den=PopInCivLaborForce, years=&_years. )

		%Moe_prop_a( var=PctUnemployed_m_&_years., mult=100, num=PopUnemployed_&_years., den=PopInCivLaborForce_&_years., 
	                       num_moe=mPopUnemployed_&_years., den_moe=mPopInCivLaborForce_&_years., label_moe =Unemployment rate (%) MOE &y_lbl.);

%Pct_calc( var=PctUnemployed_ML, label=Unemployment rate male (%), num=PopUnemployed_M, den=PopInCivLaborForce_M, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_ML_m_&_years., mult=100, num=PopUnemployed_M_&_years., den=PopInCivLaborForce_M_&_years., 
	                       num_moe=mPopUnemployed_M_&_years., den_moe=mPopInCivLaborForce_M_&_years., label_moe =Unemployment rate male (%) MOE &y_lbl.);

    %Pct_calc( var=PctUnemployed_F, label=Unemployment rate female (%), num=PopUnemployed_F, den=PopInCivLaborForce_F, years=&_years. )

	%Moe_prop_a( var=PctUnemployed_F_m_&_years., mult=100, num=PopUnemployed_F_&_years., den=PopInCivLaborForce_F_&_years., 
	                       num_moe=mPopUnemployed_F_&_years., den_moe=mPopInCivLaborForce_F_&_years., label_moe =Unemployment rate female (%) MOE &y_lbl.);


	%raceunemp;

run;
** save data set for use in other repos;
%Finalize_data_set( 
		data=donotroundunemp,
		out=Reg_equity_acs_&dcregion._&_years.,
		outlib=Equity,
		label="DC-MD-VA Regional (ACS Equity Indicators and Gaps by Race/Ethnicity, &dcregion., County  &_years.",
		sortby=ucounty,
		restrictions=None,
		revisions=&revisions.
		)

proc sort data=donotroundunemp out=sortedbyorder;
by order;
run;
** Transpose for final excel output **;
proc transpose data=sortedbyorder (where=(region~=" " & order~=.))

out=profile_tabs_region ;/*(label="DC Equity Indicators and Gap Calculations for Equity Profile City & Ward, &y_lbl."); */
	var TotPop_tr:

		PctAloneA_: PctAloneB_: PctHisp_:
		PctAloneI_: PctAloneM_: PctAloneO_: 
		PctWhiteNonHispBridge_: PctAloneW_: 

		PctPopUnder18Years_: PctPopUnder18YearsA_:
		PctPopUnder18YearsB_: PctPopUnder18YearsH_:
		PctPopUnder18YearsIOM_: PctPopUnder18YearsW_: 

		PctPop18_34Years_: PctPop18_34YearsA_: 
		PctPop18_34YearsB_: PctPop18_34YearsH_:
		PctPop18_34YearsIOM_: PctPop18_34YearsW_: 

		PctPop35_64Years_:  PctPop35_64YearsA_: 
		PctPop35_64YearsB_: PctPop35_64YearsH_:
		PctPop35_64YearsIOM_: PctPop35_64YearsW_:

		PctPop65andOverYears_: PctPop65andOverYrs_:
		PctPop65andOverYearsA_: PctPop65andOverYrsA_: 
		PctPop65andOverYearsB_: PctPop65andOverYrsB_:
		PctPop65andOverYearsH_: PctPop65andOverYrsH_: 
		PctPop65andOverYearsIOM_: PctPop65andOverYrsIOM_:
		PctPop65andOverYearsW_: PctPop65andOverYrsW_:

		PctForeignBorn_: PctNativeBorn_: 

		PctForeignBornA_: PctForeignBornB_: 
		PctForeignBornH_: 
		PctForeignBornIOM_: PctForeignBornW_:

		PctOthLang_:

		Pct25andOverWoutHS_:
		Pct25andOverWoutHSA_:
		Pct25andOverWoutHSB_:
		Pct25andOverWoutHSH_:
		Pct25andOverWoutHSIOM_:
		Pct25andOverWoutHSW_:
		Pct25andOverWoutHSFB_:
		Pct25andOverWoutHSNB_:

		Gap25andOverWoutHSA_:
		Gap25andOverWoutHSB_:
		Gap25andOverWoutHSH_:
		Gap25andOverWoutHSIOM_:
		Gap25andOverWoutHSFB_:

		Pct25andOverWHS_:
		Pct25andOverWHSA_:
		Pct25andOverWHSB_:
		Pct25andOverWHSH_:
		Pct25andOverWHSIOM_:
		Pct25andOverWHSW_:
		Pct25andOverWHSFB_:
		Pct25andOverWHSNB_:

		Gap25andOverWHSA_:
		Gap25andOverWHSB_:
		Gap25andOverWHSH_:
		Gap25andOverWHSIOM_:
		Gap25andOverWHSFB_:
		
		Pct25andOverWSC_:
		Pct25andOverWSCA_:
		Pct25andOverWSCB_:
		Pct25andOverWSCH_:
		Pct25andOverWSCIOM_:
		Pct25andOverWSCW_:
		Pct25andOverWSCFB_:
		Pct25andOverWSCNB_:

		Gap25andOverWSCA_:
		Gap25andOverWSCB_:
		Gap25andOverWSCH_:
		Gap25andOverWSCIOM_:
		Gap25andOverWSCFB_:
		
		PctPoorPersons_:
		PctPoorPersonsA_:
		PctPoorPersonsB_:
		PctPoorPersonsH_:
		PctPoorPersonsIOM_:
		PctPoorPersonsW_:
		PctPoorPersonsFB_:

		GapPoorPersonsA_:
		GapPoorPersonsB_:
		GapPoorPersonsH_:
		GapPoorPersonsIOM_:
		GapPoorPersonsFB_:

		PctPoorChildren_:
		PctPoorChildrenA_:
		PctPoorChildrenB_:
		PctPoorChildrenH_:
		PctPoorChildrenIOM_:
		PctPoorChildrenW_:

		PctFamilyLT75000_:
		PctFamilyLT75000A_:
		PctFamilyLT75000B_:
		PctFamilyLT75000H_:
		PctFamilyLT75000IOM_:
		PctFamilyLT75000W_:

		GapFamilyLT75000A_:
		GapFamilyLT75000B_:
		GapFamilyLT75000H_:
		GapFamilyLT75000IOM_:

		PctFamilyGT200000_:
		PctFamilyGT200000A_:
		PctFamilyGT200000B_:
		PctFamilyGT200000H_:
		PctFamilyGT200000IOM_:
		PctFamilyGT200000W_:

		AvgHshldIncAdj_:
		AvgHshldIncAdjA_:
		AvgHshldIncAdjB_:
		AvgHshldIncAdjH_:
		AvgHshldIncAdjIOM_:
		AvgHshldIncAdjW_:
		
		Pct16plusEmploy_:
		Pct16plusEmployA_:
		Pct16plusEmployB_:
		Pct16plusEmployH_:
		Pct16plusEmployIOM_:
		Pct16plusEmployW_:

		Gap16plusEmployA_:
		Gap16plusEmployB_:
		Gap16plusEmployH_:
		Gap16plusEmployIOM_:

		PctEmp16to64_:
		PctEmp16to64A_:
		PctEmp16to64B_:
		PctEmp16to64H_:
		PctEmp16to64IOM_:
		PctEmp16to64W_:

		GapEmp16to64A_:
		GapEmp16to64B_:
		GapEmp16to64H_:
		GapEmp16to64IOM_:

		PctUnemployed_:
		PctUnemployedA_:
		PctUnemployedB_:
		PctUnemployedH_:
		PctUnemployedIOM_:
		PctUnemployedW_:

		GapUnemployedA_:
		GapUnemployedB_:
		GapUnemployedH_:
		GapUnemployedIOM_:

		Pct16plusWages_:
		Pct16plusWagesA_:
		Pct16plusWagesB_:
		Pct16plusWagesH_:
		Pct16plusWagesIOM_:
		Pct16plusWagesW_:

		Gap16plusWagesA_:
		Gap16plusWagesB_:
		Gap16plusWagesH_:
		Gap16plusWagesIOM_:

		Pct16plusWorkFT_:
		Pct16plusWorkFTA_:
		Pct16plusWorkFTB_:
		Pct16plusWorkFTH_:
		Pct16plusWorkFTIOM_:
		Pct16plusWorkFTW_:

		Gap16plusWorkFTA_:
		Gap16plusWorkFTB_:
		Gap16plusWorkFTH_:
		Gap16plusWorkFTIOM_:

		PctWorkFTLT35k_:
		PctWorkFTLT35kA_:
		PctWorkFTLT35kB_:
		PctWorkFTLT35kH_:
		PctWorkFTLT35kIOM_:
		PctWorkFTLT35kW_:

		GapWorkFTLT35kA_:
		GapWorkFTLT35kB_:
		GapWorkFTLT35kH_:
		GapWorkFTLT35kIOM_:

		PctWorkFTLT75k_:
		PctWorkFTLT75kA_:
		PctWorkFTLT75kB_:
		PctWorkFTLT75kH_:
		PctWorkFTLT75kIOM_:
		PctWorkFTLT75kW_:

		GapWorkFTLT75kA_:
		GapWorkFTLT75kB_:
		GapWorkFTLT75kH_:
		GapWorkFTLT75kIOM_:

		PctEmpMngmt_:
		PctEmpMngmtA_:
		PctEmpMngmtB_:
		PctEmpMngmtH_:
		PctEmpMngmtIOM_:
		PctEmpMngmtW_:
			
		PctEmpServ_:
		PctEmpServA_:
		PctEmpServB_:
		PctEmpServH_:
		PctEmpServIOM_:
		PctEmpServW_:

		PctEmpSales_:
		PctEmpSalesA_:
		PctEmpSalesB_:
		PctEmpSalesH_:
		PctEmpSalesIOM_:
		PctEmpSalesW_:

		PctEmpNatRes_:
		PctEmpNatResA_:
		PctEmpNatResB_:
		PctEmpNatResH_:
		PctEmpNatResIOM_:
		PctEmpNatResW_:

		PctEmpProd_:
		PctEmpProdA_:	
		PctEmpProdB_:
		PctEmpProdH_:
		PctEmpProdIOM_:
		PctEmpProdW_:

		PctOwnerOccupiedHU_:
		PctOwnerOccupiedHUA_:
		PctOwnerOccupiedHUB_:
		PctOwnerOccupiedHUH_:
		PctOwnerOccupiedHUIOM_:
		PctOwnerOccupiedHUW_:

		GapOwnerOccupiedHUA_:
		GapOwnerOccupiedHUB_:
		GapOwnerOccupiedHUH_:
		GapOwnerOccupiedHUIOM_:

		%if &lastyr. >= 2023 %then; %do;
		PctMortCstBrden_:
		PctMortCstBrdenA_:
		PctMortCstBrdenB_:
		PctMortCstBrdenH_:
		PctMortCstBrdenIOM_:
		PctMortCstBrdenW_:

		PctMortSCstBrden_:
		PctMortSCstBrdenA_:
		PctMortSCstBrdenB_:
		PctMortSCstBrdenH_:
		PctMortSCstBrdenIOM_:
		PctMortSCstBrdenW_:

		PctNoMortCstBrden_:
		PctNoMortCstBrdenA_:
		PctNoMortCstBrdenB_:
		PctNoMortCstBrdenH_:
		PctNoMortCstBrdenIOM_:
		PctNoMortCstBrdenW_:

		PctNoMortSCstBrden_:
		PctNoMortSCstBrdenA_:
		PctNoMortSCstBrdenB_:
		PctNoMortSCstBrdenH_:
		PctNoMortSCstBrdenIOM_:
		PctNoMortSCstBrdenW_:

		PctAllOwnCstBrden_:
		PctAllOwnCstBrdenA_:
		PctAllOwnCstBrdenB_:
		PctAllOwnCstBrdenH_:
		PctAllOwnCstBrdenIOM_:
		PctAllOwnCstBrdenW_:

		PctAllOwnSCstBrden_:
		PctAllOwnSCstBrdenA_:
		PctAllOwnSCstBrdenB_:
		PctAllOwnSCstBrdenH_:
		PctAllOwnSCstBrdenIOM_:
		PctAllOwnSCstBrdenW_:

		PctRentCstBrden_:
		PctRentCstBrdenA_:
		PctRentCstBrdenB_:
		PctRentCstBrdenH_:
		PctRentCstBrdenIOM_:
		PctRentCstBrdenW_:

		PctRentSCstBrden_:
		PctRentSCstBrdenA_:
		PctRentSCstBrdenB_:
		PctRentSCstBrdenH_:
		PctRentSCstBrdenIOM_:
		PctRentSCstBrdenW_:

		%end; 

		PctMovedLastYear_:
		PctMovedLastYearA_:
		PctMovedLastYearB_:
		PctMovedLastYearH_:
		PctMovedLastYearIOM_:
		PctMovedLastYearW_:

		PctMovedDiffCnty_:
		PctMovedDiffCntyA_:
		PctMovedDiffCntyB_:
		PctMovedDiffCntyH_:
		PctMovedDiffCntyIOM_:
		PctMovedDiffCntyW_:
	 	;

	id ucounty; 
run; 

** Export final file **;
proc export data=profile_tabs_region 
	outfile="&_dcdata_default_path.\Equity\Prog\profile_tabs_&dcregion._acs_&_years..csv"
	dbms=csv replace;
	run;

%mend; 
%pickregion(PDMV);
%pickregion(HIT); 
/* End of program */
