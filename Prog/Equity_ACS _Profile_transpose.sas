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
 Modifications: RP July-2017: Updated to run for DC, Fairfax, Prince George's and
			    Montgomery counties for 2017 equity study update. Removed AIOM variables
			    from final transpose.  
				LH 02-09-2020 update for 2014-18 ACS
				LH 12-22-2020 update for 2015-19 ACS and \\sas1\
				LH 12-18-2024 update for IOM indicators
				LH 1-14-2025 update for change in regcnt to cnty and lack of regcd post 2020 
**************************************************************************/
/*options symbolgen;*/

%include "\\sas1\DCDATA\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )

%let racelist=W B H A IOM AIOM ;
%let racename= NH-White Black-Alone Hispanic Asian-PI Indigenous-Other-Multi All-Other ;
*all-other is all other than NHWhite, Black, Hispanic; 
*all races except NH white, hispanic, and multiple race are race alone. ;

%let _years=2011_15;
%let endyear=2015; 

%macro acs_profiles_county (county);

options mprint=n; 


%let cnty = %upcase(&county.);

%if &cnty = DC %then %do;
	%let st = DC;
	%let ct = DC;
	%let fips = 11001;
	%let cdcodes = "1","2","3","4","5","6","7","8" ;
%end;
%else %if &cnty = FAIRFAX %then %do;
	%let st = VA;
	%let ct = FF;
	%let fips = 51059;
	%let cdcodes = "FF01","FF02","FF03","FF04","FF05","FF06","FF07","FF08","FF09" ;
%end;
%else %if &cnty = MONTGOMERY %then %do;
	%let st = MD;
	%let ct = MT;
	%let fips = 24031;
	%let cdcodes = "MT01","MT02","MT03","MT04","MT05";
%end;
%else %if &cnty = PG %then %do;
	%let st = MD;
	%let ct = PG;
	%let fips = 24033;
	%let cdcodes = "PG01","PG02","PG03","PG04","PG05","PG06","PG07","PG08","PG09";
%end;

*regcd not produced for MD/VA after 2019 with changes to council districts following census 2020 and changes to tract boundaries; 
*ran 2011-15 data for ward2022 for analysis in 2025.; 

%if &st=DC %then %do;

	%if &endyear. = 2015 %then %do; 
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
				equity_r.Profile_acs_&_years._&st._wd22 (rename=(ward2022=councildist)); 

			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

		run; 
	%end; 
	%else %if &endyear. < 2020 %then %do;
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
				equity_r.Profile_acs_&_years._&st.regcd; 

			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

		run; 
	%end; 

	%else %if &endyear. = 2020  %then %do;
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
				equity_r.Profile_acs_&_years._&st._wd22 (rename=(ward2022=councildist)); 

			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

		run; 
	%end; 

	%else %if &endyear. = 2021 %then %do;
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
				equity_r.Profile_acs_&_years._&st._wd22 (rename=(ward2022=councildist)); 

		if county ^= " " then councildist="0";
		_make_profile=1;

		if councildist in ("0",&cdcodes.);

		run; 
	%end; 

	%else %if &endyear. >= 2022 %then %do;
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._cnty (where=(ucounty="&fips."))
				equity_r.Profile_acs_&_years._&st._wd22 (rename=(ward2022=councildist)); 

			county=ucounty;
			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

				run; 
	%end; 
	
 %end; 

 %else %if &st~=DC %then %do;

	%if &endyear. < 2020 %then %do;
	data county_councildist_&ct.;
		set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
			equity_r.Profile_acs_&_years._&st._regcd; 

		if county ^= " " then councildist="0";
		_make_profile=1;

		if councildist in ("0",&cdcodes.);

	run; 
 %end; 

	%else %if &endyear. = 2020 %then %do; 
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
				; 

			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

		run; 
	%end; 

	%else %if &endyear.= 2021 %then %do; 
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."))
				; 

			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

		run; 
	%end; 

	%else %if  &endyear. >= 2022 %then %do;
		data county_councildist_&ct.;
			set equity_r.Profile_acs_&_years._&st._cnty (where=(ucounty="&fips."))
				; 
			county=ucounty;
			if county ^= " " then councildist="0";
			_make_profile=1;

			if councildist in ("0",&cdcodes.);

		run; 
	%end; 
%end;
*Add gap calculation - separate out city level white rates; 


data whiterates_&ct.;

%if &endyear. < 2022 %then %do;
	set equity_r.Profile_acs_&_years._&st._regcnt (where=(county="&fips."));
%end;
%else %do; 
 	set equity_r.Profile_acs_&_years._&st._cnty (where=(ucounty="&fips."));
%end;
	keep _make_profile
		   Pct25andOverWoutHSW: Pct25andOverWHSW: Pct25andOverWSCW:
           PctPoorPersonsW: PctPoorChildrenW:
           PctFamilyLT75000W: PctFamilyGT200000W:
           AvgHshldIncAdjW: PctUnemployedW: 
           PctEmp16to64W: Pct16plusEmployW:
           Pct16plusWagesW: Pct16plusWorkFTW: 
           PctWorkFTLT35kW:  PctWorkFTLT75kW:
           PctEmpMngmtW: PctEmpServW:
           PctEmpSalesW: PctEmpNatResW: 
           PctEmpProdW: PctOwnerOccupiedHUW: ;
		   			;
	_make_profile=1;
	run;

%rename(data=whiterates_&ct.,out=whiterates_new_&ct.);
run;


data county_councildist_wr_&ct. (drop=_make_profile );
	merge county_councildist_&ct. whiterates_new_&ct. (rename=(c_make_profile=_make_profile));
	by _make_profile;
	
	Gap25andOverWoutHSB_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsB_&_years.-Pop25andOverWoutHSB_&_years.;
	Gap25andOverWoutHSW_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsW_&_years.-Pop25andOverWoutHSW_&_years.;
	Gap25andOverWoutHSH_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsH_&_years.-Pop25andOverWoutHSH_&_years.;
	Gap25andOverWoutHSA_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsA_&_years.-Pop25andOverWoutHSA_&_years.;
	Gap25andOverWoutHSIOM_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWoutHSIOM_&_years.;
	Gap25andOverWoutHSAIOM_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWoutHSAIOM_&_years.;
	Gap25andOverWoutHSFB_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsFB_&_years.-Pop25andOverWoutHSFB_&_years.;
	Gap25andOverWoutHSNB_&_years.=cPct25andOverWoutHSW_&_years./100*Pop25andOverYearsNB_&_years.-Pop25andOverWoutHSNB_&_years.;

	Gap25andOverWHSB_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsB_&_years.-Pop25andOverWHSB_&_years.;
	Gap25andOverWHSW_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsW_&_years.-Pop25andOverWHSW_&_years.;
	Gap25andOverWHSH_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsH_&_years.-Pop25andOverWHSH_&_years.;
	Gap25andOverWHSA_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsA_&_years.-Pop25andOverWHSA_&_years.;
	Gap25andOverWHSIOM_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWHSIOM_&_years.;
	Gap25andOverWHSAIOM_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsAIOM_&_years.-Pop25andOverWHSAIOM_&_years.;
	Gap25andOverWHSFB_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsFB_&_years.-Pop25andOverWHSFB_&_years.;
	Gap25andOverWHSNB_&_years.=cPct25andOverWHSW_&_years./100*Pop25andOverYearsNB_&_years.-Pop25andOverWHSNB_&_years.;

	Gap25andOverWSCB_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsB_&_years.-Pop25andOverWSCB_&_years.;
	Gap25andOverWSCW_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsW_&_years.-Pop25andOverWSCW_&_years.;
	Gap25andOverWSCH_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsH_&_years.-Pop25andOverWSCH_&_years.;
	Gap25andOverWSCA_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsA_&_years.-Pop25andOverWSCA_&_years.;
	Gap25andOverWSCIOM_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsIOM_&_years.-Pop25andOverWSCIOM_&_years.;
	Gap25andOverWSCAIOM_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsAIOM_&_years.-Pop25andOverWSCAIOM_&_years.;
	Gap25andOverWSCFB_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsFB_&_years.-Pop25andOverWSCFB_&_years.;
	Gap25andOverWSCNB_&_years.=cPct25andOverWSCW_&_years./100*Pop25andOverYearsNB_&_years.-Pop25andOverWSCNB_&_years.;

	GapPoorPersonsB_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefinedB_&_years.-PopPoorPersonsB_&_years.;
	GapPoorPersonsW_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefinedW_&_years.-PopPoorPersonsW_&_years.;
	GapPoorPersonsH_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefinedH_&_years.-PopPoorPersonsH_&_years.;
	GapPoorPersonsA_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefinedA_&_years.-PopPoorPersonsA_&_years.;
	GapPoorPersonsIOM_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefIOM_&_years.-PopPoorPersonsIOM_&_years.;
	GapPoorPersonsAIOM_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefAIOM_&_years.-PopPoorPersonsAIOM_&_years.;
	GapPoorPersonsFB_&_years.=cPctPoorPersonsW_&_years./100*PersonsPovertyDefinedFB_&_years.-PopPoorPersonsFB_&_years.;


	GapPoorChildrenB_&_years.=cPctPoorChildrenW_&_years./100*ChildrenPovertyDefinedB_&_years.-PopPoorChildrenB_&_years.;
	GapPoorChildrenW_&_years.=cPctPoorChildrenW_&_years./100*ChildrenPovertyDefinedW_&_years.-PopPoorChildrenW_&_years.;
	GapPoorChildrenH_&_years.=cPctPoorChildrenW_&_years./100*ChildrenPovertyDefinedH_&_years.-PopPoorChildrenH_&_years.;
	GapPoorChildrenA_&_years.=cPctPoorChildrenW_&_years./100*ChildrenPovertyDefinedA_&_years.-PopPoorChildrenA_&_years.;
	GapPoorChildrenIOM_&_years.=cPctPoorChildrenW_&_years./100*ChildrenPovertyDefIOM_&_years.-PopPoorChildrenIOM_&_years.;
	GapPoorChildrenAIOM_&_years.=cPctPoorChildrenW_&_years./100*ChildrenPovertyDefAIOM_&_years.-PopPoorChildrenAIOM_&_years.;


	GapFamilyLT75000B_&_years.=cPctFamilyLT75000W_&_years./100*NumFamiliesB_&_years.-FamIncomeLT75kB_&_years.;
	GapFamilyLT75000W_&_years.=cPctFamilyLT75000W_&_years./100*NumFamiliesW_&_years.-FamIncomeLT75kW_&_years.;
	GapFamilyLT75000H_&_years.=cPctFamilyLT75000W_&_years./100*NumFamiliesH_&_years.-FamIncomeLT75kH_&_years.;
	GapFamilyLT75000A_&_years.=cPctFamilyLT75000W_&_years./100*NumFamiliesA_&_years.-FamIncomeLT75kA_&_years.;
	GapFamilyLT75000IOM_&_years.=cPctFamilyLT75000W_&_years./100*NumFamiliesIOM_&_years.-FamIncomeLT75kIOM_&_years.;
	GapFamilyLT75000AIOM_&_years.=cPctFamilyLT75000W_&_years./100*NumFamiliesAIOM_&_years.-FamIncomeLT75kAIOM_&_years.;


	GapFamilyGT200000B_&_years.=cPctFamilyGT200000W_&_years./100*NumFamiliesB_&_years.-FamIncomeGT200kB_&_years.;
	GapFamilyGT200000W_&_years.=cPctFamilyGT200000W_&_years./100*NumFamiliesW_&_years.-FamIncomeGT200kW_&_years.;
	GapFamilyGT200000H_&_years.=cPctFamilyGT200000W_&_years./100*NumFamiliesH_&_years.-FamIncomeGT200kH_&_years.;
	GapFamilyGT200000A_&_years.=cPctFamilyGT200000W_&_years./100*NumFamiliesA_&_years.-FamIncomeGT200kA_&_years.;
	GapFamilyGT200000IOM_&_years.=cPctFamilyGT200000W_&_years./100*NumFamiliesIOM_&_years.-FamIncomeGT200kIOM_&_years.;
	GapFamilyGT200000AIOM_&_years.=cPctFamilyGT200000W_&_years./100*NumFamiliesAIOM_&_years.-FamIncomeGT200kAIOM_&_years.;


	GapAvgHshldIncAdjB_&_years.=cAvgHshldIncAdjW_&_years./100*NumHshldsB_&_years.-AggHshldIncomeB_&_years.;
	GapAvgHshldIncAdjW_&_years.=cAvgHshldIncAdjW_&_years./100*NumHshldsW_&_years.-AggHshldIncomeW_&_years.;
	GapAvgHshldIncAdjH_&_years.=cAvgHshldIncAdjW_&_years./100*NumHshldsH_&_years.-AggHshldIncomeH_&_years.;
	GapAvgHshldIncAdjA_&_years.=cAvgHshldIncAdjW_&_years./100*NumHshldsA_&_years.-AggHshldIncomeA_&_years.;
	GapAvgHshldIncAdjIOM_&_years.=cAvgHshldIncAdjW_&_years./100*NumHshldsIOM_&_years.-AggHshldIncomeIOM_&_years.;
	GapAvgHshldIncAdjAIOM_&_years.=cAvgHshldIncAdjW_&_years./100*NumHshldsAIOM_&_years.-AggHshldIncomeAIOM_&_years.;


	GapEmp16to64B_&_years.=cPctEmp16to64W_&_years./100*Pop16_64yearsB_&_years.-Pop16_64EmployedB_&_years.;
	GapEmp16to64W_&_years.=cPctEmp16to64W_&_years./100*Pop16_64yearsW_&_years.-Pop16_64EmployedW_&_years.;
	GapEmp16to64H_&_years.=cPctEmp16to64W_&_years./100*Pop16_64yearsH_&_years.-Pop16_64EmployedH_&_years.;
	GapEmp16to64A_&_years.=cPctEmp16to64W_&_years./100*Pop16_64yearsA_&_years.-Pop16_64EmployedA_&_years.;
	GapEmp16to64IOM_&_years.=cPctEmp16to64W_&_years./100*Pop16_64yearsIOM_&_years.-Pop16_64EmployedIOM_&_years.;
	GapEmp16to64AIOM_&_years.=cPctEmp16to64W_&_years./100*Pop16_64yearsAIOM_&_years.-Pop16_64EmployedAIOM_&_years.;

	Gap16plusEmployB_&_years.=cPct16plusEmployW_&_years./100*Pop16andOverYearsB_&_years.-Pop16andOverEmployB_&_years.;
	Gap16plusEmployW_&_years.=cPct16plusEmployW_&_years./100*Pop16andOverYearsW_&_years.-Pop16andOverEmployW_&_years.;
	Gap16plusEmployH_&_years.=cPct16plusEmployW_&_years./100*Pop16andOverYearsH_&_years.-Pop16andOverEmployH_&_years.;
	Gap16plusEmployA_&_years.=cPct16plusEmployW_&_years./100*Pop16andOverYearsA_&_years.-Pop16andOverEmployA_&_years.;
	Gap16plusEmployIOM_&_years.=cPct16plusEmployW_&_years./100*Pop16andOverYearsIOM_&_years.-Pop16andOverEmployIOM_&_years.;
	Gap16plusEmployAIOM_&_years.=cPct16plusEmployW_&_years./100*Pop16andOverYearsAIOM_&_years.-Pop16andOverEmployAIOM_&_years.;

	GapUnemployedB_&_years.=cPctUnemployedW_&_years./100*PopInCivLaborForceB_&_years.-PopUnemployedB_&_years.;
	GapUnemployedW_&_years.=cPctUnemployedW_&_years./100*PopInCivLaborForceW_&_years.-PopUnemployedW_&_years.;
	GapUnemployedH_&_years.=cPctUnemployedW_&_years./100*PopInCivLaborForceH_&_years.-PopUnemployedH_&_years.;
	GapUnemployedA_&_years.=cPctUnemployedW_&_years./100*PopInCivLaborForceA_&_years.-PopUnemployedA_&_years.;
	GapUnemployedIOM_&_years.=cPctUnemployedW_&_years./100*PopInCivLaborForceIOM_&_years.-PopUnemployedIOM_&_years.;
	GapUnemployedAIOM_&_years.=cPctUnemployedW_&_years./100*PopInCivLaborForceAIOM_&_years.-PopUnemployedAIOM_&_years.;

	Gap16plusWagesB_&_years.=cPct16plusWagesW_&_years./100*Pop16andOverYearsB_&_years.-PopWorkEarnB_&_years.;
	Gap16plusWagesW_&_years.=cPct16plusWagesW_&_years./100*Pop16andOverYearsW_&_years.-PopWorkEarnW_&_years.;
	Gap16plusWagesH_&_years.=cPct16plusWagesW_&_years./100*Pop16andOverYearsH_&_years.-PopWorkEarnH_&_years.;
	Gap16plusWagesA_&_years.=cPct16plusWagesW_&_years./100*Pop16andOverYearsA_&_years.-PopWorkEarnA_&_years.;
	Gap16plusWagesIOM_&_years.=cPct16plusWagesW_&_years./100*Pop16andOverYearsIOM_&_years.-PopWorkEarnIOM_&_years.;
	Gap16plusWagesAIOM_&_years.=cPct16plusWagesW_&_years./100*Pop16andOverYearsAIOM_&_years.-PopWorkEarnAIOM_&_years.;

	Gap16plusWorkFTB_&_years.=cPct16plusWorkFTW_&_years./100*Pop16andOverYearsB_&_years.-PopWorkFTB_&_years.;
	Gap16plusWorkFTW_&_years.=cPct16plusWorkFTW_&_years./100*Pop16andOverYearsW_&_years.-PopWorkFTW_&_years.;
	Gap16plusWorkFTH_&_years.=cPct16plusWorkFTW_&_years./100*Pop16andOverYearsH_&_years.-PopWorkFTH_&_years.;
	Gap16plusWorkFTA_&_years.=cPct16plusWorkFTW_&_years./100*Pop16andOverYearsA_&_years.-PopWorkFTA_&_years.;
	Gap16plusWorkFTIOM_&_years.=cPct16plusWorkFTW_&_years./100*Pop16andOverYearsIOM_&_years.-PopWorkFTIOM_&_years.;
	Gap16plusWorkFTAIOM_&_years.=cPct16plusWorkFTW_&_years./100*Pop16andOverYearsAIOM_&_years.-PopWorkFTAIOM_&_years.;

	GapWorkFTLT35kB_&_years.=cPctWorkFTLT35kW_&_years./100*PopWorkFTB_&_years.-PopWorkFTLT35KB_&_years.;
	GapWorkFTLT35kW_&_years.=cPctWorkFTLT35kW_&_years./100*PopWorkFTW_&_years.-PopWorkFTLT35KW_&_years.;
	GapWorkFTLT35kH_&_years.=cPctWorkFTLT35kW_&_years./100*PopWorkFTH_&_years.-PopWorkFTLT35KH_&_years.;
	GapWorkFTLT35kA_&_years.=cPctWorkFTLT35kW_&_years./100*PopWorkFTA_&_years.-PopWorkFTLT35KA_&_years.;
	GapWorkFTLT35kIOM_&_years.=cPctWorkFTLT35kW_&_years./100*PopWorkFTIOM_&_years.-PopWorkFTLT35KIOM_&_years.;
	GapWorkFTLT35kAIOM_&_years.=cPctWorkFTLT35kW_&_years./100*PopWorkFTAIOM_&_years.-PopWorkFTLT35KAIOM_&_years.;

	GapWorkFTLT75kB_&_years.=cPctWorkFTLT75kW_&_years./100*PopWorkFTB_&_years.-PopWorkFTLT75KB_&_years.;
	GapWorkFTLT75kW_&_years.=cPctWorkFTLT75kW_&_years./100*PopWorkFTW_&_years.-PopWorkFTLT75KW_&_years.;
	GapWorkFTLT75kH_&_years.=cPctWorkFTLT75kW_&_years./100*PopWorkFTH_&_years.-PopWorkFTLT75KH_&_years.;
	GapWorkFTLT75kA_&_years.=cPctWorkFTLT75kW_&_years./100*PopWorkFTA_&_years.-PopWorkFTLT75KA_&_years.;
	GapWorkFTLT75kIOM_&_years.=cPctWorkFTLT75kW_&_years./100*PopWorkFTIOM_&_years.-PopWorkFTLT75KIOM_&_years.;
	GapWorkFTLT75kAIOM_&_years.=cPctWorkFTLT75kW_&_years./100*PopWorkFTAIOM_&_years.-PopWorkFTLT75KAIOM_&_years.;

	GapEmpMngmtB_&_years.=cPctEmpMngmtW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedMngmtB_&_years.;
	GapEmpMngmtW_&_years.=cPctEmpMngmtW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedMngmtW_&_years.;
	GapEmpMngmtH_&_years.=cPctEmpMngmtW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedMngmtH_&_years.;
	GapEmpMngmtA_&_years.=cPctEmpMngmtW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedMngmtA_&_years.;
	GapEmpMngmtIOM_&_years.=cPctEmpMngmtW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedMngmtIOM_&_years.;
	GapEmpMngmtAIOM_&_years.=cPctEmpMngmtW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedMngmtAIOM_&_years.;

	GapEmpServB_&_years.=cPctEmpServW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedServB_&_years.;
	GapEmpServW_&_years.=cPctEmpServW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedServW_&_years.;
	GapEmpServH_&_years.=cPctEmpServW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedServH_&_years.;
	GapEmpServA_&_years.=cPctEmpServW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedServA_&_years.;
	GapEmpServIOM_&_years.=cPctEmpServW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedServIOM_&_years.;
	GapEmpServAIOM_&_years.=cPctEmpServW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedServAIOM_&_years.;

	GapEmpSalesB_&_years.=cPctEmpSalesW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedSalesB_&_years.;
	GapEmpSalesW_&_years.=cPctEmpSalesW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedSalesW_&_years.;
	GapEmpSalesH_&_years.=cPctEmpSalesW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedSalesH_&_years.;
	GapEmpSalesA_&_years.=cPctEmpSalesW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedSalesA_&_years.;
	GapEmpSalesIOM_&_years.=cPctEmpSalesW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedSalesIOM_&_years.;
	GapEmpSalesAIOM_&_years.=cPctEmpSalesW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedSalesAIOM_&_years.;

	GapEmpNatResB_&_years.=cPctEmpNatResW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedNatResB_&_years.;
	GapEmpNatResW_&_years.=cPctEmpNatResW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedNatResW_&_years.;
	GapEmpNatResH_&_years.=cPctEmpNatResW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedNatResH_&_years.;
	GapEmpNatResA_&_years.=cPctEmpNatResW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedNatResA_&_years.;
	GapEmpNatResIOM_&_years.=cPctEmpNatResW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedNatResIOM_&_years.;
	GapEmpNatResAIOM_&_years.=cPctEmpNatResW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedNatResAIOM_&_years.;

	GapEmpProdB_&_years.=cPctEmpProdW_&_years./100*PopEmployedByOccB_&_years.-PopEmployedProdB_&_years.;
	GapEmpProdW_&_years.=cPctEmpProdW_&_years./100*PopEmployedByOccW_&_years.-PopEmployedProdW_&_years.;
	GapEmpProdH_&_years.=cPctEmpProdW_&_years./100*PopEmployedByOccH_&_years.-PopEmployedProdH_&_years.;
	GapEmpProdA_&_years.=cPctEmpProdW_&_years./100*PopEmployedByOccA_&_years.-PopEmployedProdA_&_years.;
	GapEmpProdIOM_&_years.=cPctEmpProdW_&_years./100*PopEmployedByOccIOM_&_years.-PopEmployedProdIOM_&_years.;
	GapEmpProdAIOM_&_years.=cPctEmpProdW_&_years./100*PopEmployedByOccAIOM_&_years.-PopEmployedProdAIOM_&_years.;

	GapOwnerOccupiedHUB_&_years.=cPctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsB_&_years.-NumOwnerOccupiedHUB_&_years.;
	GapOwnerOccupiedHUW_&_years.=cPctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsW_&_years.-NumOwnerOccupiedHUW_&_years.;
	GapOwnerOccupiedHUH_&_years.=cPctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsH_&_years.-NumOwnerOccupiedHUH_&_years.;
	GapOwnerOccupiedHUA_&_years.=cPctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsA_&_years.-NumOwnerOccupiedHUA_&_years.;
	GapOwnerOccupiedHUIOM_&_years.=cPctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsIOM_&_years.-NumOwnerOccupiedHUIOM_&_years.;
	GapOwnerOccupiedHUAIOM_&_years.=cPctOwnerOccupiedHUW_&_years./100*NumOccupiedHsgUnitsAIOM_&_years.-NumOwnerOccupiedHUAIOM_&_years.;

run;


data profile_tabs_ACS_suppress_&ct. (drop=cPct: cAvg: Pop:);
	set county_councildist_wr_&ct.;

	array t_est {21} 
		Pct25andOverWoutHS_&_years.
		Pct25andOverWHS_&_years.
		Pct25andOverWSC_&_years.
		AvgHshldIncAdj_&_years.
		PctFamilyGT200000_&_years.
		PctFamilyLT75000_&_years.
		PctPoorPersons_&_years.
		PctPoorChildren_&_years.
		Pct16plusEmploy_&_years.
		PctEmp16to64_&_years.
		PctUnemployed_&_years.
		Pct16plusWages_&_years.
		Pct16plusWorkFT_&_years.
		PctWorkFTLT35k_&_years.
		PctWorkFTLT75k_&_years.
		PctEmpMngmt_&_years.
		PctEmpServ_&_years.
		PctEmpSales_&_years.
		PctEmpNatRes_&_years.
		PctEmpProd_&_years.
		PctOwnerOccupiedHU_&_years.
		;

	array t_moe {21} 	
		Pct25andOverWoutHS_m_&_years.
		Pct25andOverWHS_m_&_years.
		Pct25andOverWSC_m_&_years.
		AvgHshldIncAdj_m_&_years.
		PctFamilyGT200000_m_&_years.
		PctFamilyLT75000_m_&_years.
		PctPoorPersons_m_&_years.
		PctPoorChildren_m_&_years.
		Pct16plusEmploy_m_&_years.
		PctEmp16to64_m_&_years.
		PctUnemployed_m_&_years.
		Pct16plusWages_m_&_years.
		Pct16plusWorkFT_m_&_years.
		PctWorkFTLT35k_m_&_years.
		PctWorkFTLT75k_m_&_years.
		PctEmpMngmt_m_&_years.
		PctEmpServ_m_&_years.
		PctEmpSales_m_&_years.
		PctEmpNatRes_m_&_years.
		PctEmpProd_m_&_years.
		PctOwnerOccupiedHU_m_&_years.
		;

	array t_cv {21} 
		cvPct25andOverWoutHS_&_years.
		cvPct25andOverWHS_&_years.
		cvPct25andOverWSC_&_years.
		cvAvgHshldIncAdj_&_years.
		cvPctFamilyGT200000_&_years.
		cvPctFamilyLT75000_&_years.
		cvPctPoorPersons_&_years.
		cvPctPoorChildren_&_years.
		cvPct16plusEmploy_&_years.
		cvPctEmp16to64_&_years.
		cvPctUnemployed_&_years.
		cvPct16plusWages_&_years.
		cvPct16plusWorkFT_&_years.
		cvPctWorkFTLT35k_&_years.
		cvPctWorkFTLT75k_&_years.
		cvPctEmpMngmt_&_years.
		cvPctEmpServ_&_years.
		cvPctEmpSales_&_years.
		cvPctEmpNatRes_&_years.
		cvPctEmpProd_&_years.
		cvPctOwnerOccupiedHU_&_years.
		;

	array t_upper {21} 		
		uPct25andOverWoutHS_&_years.
		uPct25andOverWHS_&_years.
		uPct25andOverWSC_&_years.
		uAvgHshldIncAdj_&_years.
		uPctFamilyGT200000_&_years.
		uPctFamilyLT75000_&_years.
		uPctPoorPersons_&_years.
		uPctPoorChildren_&_years.
		uPct16plusEmploy_&_years.
		uPctEmp16to64_&_years.
		uPctUnemployed_&_years.
		uPct16plusWages_&_years.
		uPct16plusWorkFT_&_years.
		uPctWorkFTLT35k_&_years.
		uPctWorkFTLT75k_&_years.
		uPctEmpMngmt_&_years.
		uPctEmpServ_&_years.
		uPctEmpSales_&_years.
		uPctEmpNatRes_&_years.
		uPctEmpProd_&_years.
		uPctOwnerOccupiedHU_&_years.
		;

	array t_lower {21} 		
		lPct25andOverWoutHS_&_years.
		lPct25andOverWHS_&_years.
		lPct25andOverWSC_&_years.
		lAvgHshldIncAdj_&_years.
		lPctFamilyGT200000_&_years.
		lPctFamilyLT75000_&_years.
		lPctPoorPersons_&_years.
		lPctPoorChildren_&_years.
		lPct16plusEmploy_&_years.
		lPctEmp16to64_&_years.
		lPctUnemployed_&_years.
		lPct16plusWages_&_years.
		lPct16plusWorkFT_&_years.
		lPctWorkFTLT35k_&_years.
		lPctWorkFTLT75k_&_years.
		lPctEmpMngmt_&_years.
		lPctEmpServ_&_years.
		lPctEmpSales_&_years.
		lPctEmpNatRes_&_years.
		lPctEmpProd_&_years.
		lPctOwnerOccupiedHU_&_years.
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
	/*%suppress_gaps;*/
	%suppress_gaps_z;
	%suppress_gaps_fb;

	%macro suppression;

	%do r=1 %to 6;

	%let race=%scan(&racelist.,&r.," ");
	%let name=%scan(&racename.,&r.," ");

	array f_gap&race. {21} 
		Gap25andOverWoutHS&race._&_years.
		Gap25andOverWHS&race._&_years.
		Gap25andOverWSC&race._&_years.
		GapAvgHshldIncAdj&race._&_years.
		GapFamilyGT200000&race._&_years.
		GapFamilyLT75000&race._&_years.
		GapPoorPersons&race._&_years.
		GapPoorChildren&race._&_years.
		Gap16plusEmploy&race._&_years.
		GapEmp16to64&race._&_years.
		GapUnemployed&race._&_years.
		Gap16plusWages&race._&_years.
		Gap16plusWorkFT&race._&_years.
		GapWorkFTLT35k&race._&_years.
		GapWorkFTLT75k&race._&_years.
		GapEmpMngmt&race._&_years.
		GapEmpServ&race._&_years.
		GapEmpSales&race._&_years.
		GapEmpNatRes&race._&_years.
		GapEmpProd&race._&_years.
		GapOwnerOccupiedHU&race._&_years.
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
/*
	%if &cnty = DC %then %do;
	if councildist="3" then do;
		PctPoorChildrenH_&_years.=.s;
		PctPoorChildrenH_m_&_years.=.s;
	end;
	else if councildist="5" then do; 
		PctPoorChildrenW_&_years.=.s;
	    PctPoorChildrenW_m_&_years.=.s;
	end;
	%end;*/

	%let y_lbl = %sysfunc( translate( &_years., '-', '_' ) );

	label
		Gap25andOverWoutHSW_&_years. = "Difference in # of NH-White people without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSB_&_years. = "Difference in # of Black-Alone people without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSH_&_years. = "Difference in # of Hispanic people without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSA_&_years. = "Difference in # of Asian-PI people without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSIOM_&_years. = "Difference in # of Indigenous-Other-Multi people without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSAIOM_&_years. = "Difference in # of All-Other people without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSFB_&_years. = "Difference in # of people foreign-born without HS diploma with equity, &y_lbl. "
		Gap25andOverWoutHSNB_&_years. = "Difference in # of people native-born without HS diploma with equity, &y_lbl. "

		Gap25andOverWHSW_&_years. = "Difference in # of NH-White people with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSB_&_years. = "Difference in # of Black-Alone people with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSH_&_years. = "Difference in # of Hispanic people with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSA_&_years. = "Difference in # of Asian-PI people with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSIOM_&_years. = "Difference in # of Indigenous-Other-Multi people with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSAIOM_&_years. = "Difference in # of All-Other people with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSFB_&_years. = "Difference in # of people foreign-born with HS diploma with equity, &y_lbl. "
		Gap25andOverWHSNB_&_years. = "Difference in # of people native-born with HS diploma with equity, &y_lbl. "

		Gap25andOverWSCW_&_years. = "Difference in # of NH-White people with some college with equity, &y_lbl. "
		Gap25andOverWSCB_&_years. = "Difference in # of Black-Alone people with some college with equity, &y_lbl. "
		Gap25andOverWSCH_&_years. = "Difference in # of Hispanic people with some college with equity, &y_lbl. "
		Gap25andOverWSCA_&_years. = "Difference in # of Asian-PI people with some college with equity, &y_lbl. "
		Gap25andOverWSCIOM_&_years. = "Difference in # of Indigenous-Other-Multi people with some college with equity, &y_lbl. "
		Gap25andOverWSCAIOM_&_years. = "Difference in # of All-Other people with some college with equity, &y_lbl. "
		Gap25andOverWSCFB_&_years. = "Difference in # of people foreign-born with some college with equity, &y_lbl. "
		Gap25andOverWSCNB_&_years. = "Difference in # of people native-born with some college with equity, &y_lbl. "

		GapAvgHshldIncAdjW_&_years. = "Average household income last year NH-White ($) with equity, &y_lbl. "
		GapAvgHshldIncAdjB_&_years. = "Average household income last year Black-Alone ($) with equity, &y_lbl. "
		GapAvgHshldIncAdjH_&_years. = "Average household income last year Hispanic ($) with equity, &y_lbl. "
		GapAvgHshldIncAdjA_&_years. = "Average household income last year Asian-PI ($) with equity, &y_lbl. "
		GapAvgHshldIncAdjIOM_&_years. = "Average household income last year Indigenous-Other-Multi ($) with equity, &y_lbl. "
		GapAvgHshldIncAdjAIOM_&_years. = "Average household income last year All-Other ($) with equity, &y_lbl. "

		GapFamilyGT200000W_&_years. = "Difference in # of families NH-White with income greater than 200000 with equity, &y_lbl. "
		GapFamilyGT200000B_&_years. = "Difference in # of families Black-Alone with income greater than 200000 with equity, &y_lbl. "
		GapFamilyGT200000H_&_years. = "Difference in # of families Hispanic with income greater than 200000 with equity, &y_lbl. "
		GapFamilyGT200000A_&_years. = "Difference in # of families Asian-PI with income greater than 200000 with equity, &y_lbl. "
		GapFamilyGT200000IOM_&_years. = "Difference in # of families Indigenous-Other-Multi with income greater than 200000 with equity, &y_lbl. "
		GapFamilyGT200000AIOM_&_years. = "Difference in # of families All-Other with income greater than 200000 with equity, &y_lbl. "

		GapFamilyLT75000W_&_years. = "Difference in # of families NH-White with income less than 75000 with equity, &y_lbl. "
		GapFamilyLT75000B_&_years. = "Difference in # of families Black-Alone with income less than 75000 with equity, &y_lbl. "
		GapFamilyLT75000H_&_years. = "Difference in # of families Hispanic with income less than 75000 with equity, &y_lbl. "
		GapFamilyLT75000A_&_years. = "Difference in # of families Asian-PI with income less than 75000 with equity, &y_lbl. "
		GapFamilyLT75000IOM_&_years. = "Difference in # of families Indigenous-Other-Multi with income less than 75000 with equity, &y_lbl. "
		GapFamilyLT75000AIOM_&_years. = "Difference in # of families All-Other with income less than 75000 with equity, &y_lbl. "

		GapPoorPersonsW_&_years. = "Difference in # of NH-White people living below poverty line with equity, &y_lbl. "
		GapPoorPersonsB_&_years. = "Difference in # of Black-Alone people living below poverty line with equity, &y_lbl. "
		GapPoorPersonsH_&_years. = "Difference in # of Hispanic people living below poverty line with equity, &y_lbl. "
		GapPoorPersonsA_&_years. = "Difference in # of Asian-PI people living below poverty line with equity, &y_lbl. "
		GapPoorPersonsIOM_&_years. = "Difference in # of Indigenous-Other-Multi people living below poverty line with equity, &y_lbl. "
		GapPoorPersonsAIOM_&_years. = "Difference in # of All-Other people living below poverty line with equity, &y_lbl. "
		GapPoorPersonsFB_&_years. = "Difference in # of foreign born people living below poverty line with equity, &y_lbl. "

		Gap16plusEmployW_&_years. = "Difference in # of people 16+ yrs. employed NH-White with equity, &y_lbl. "
		Gap16plusEmployB_&_years. = "Difference in # of people 16+ yrs. employed Black-Alone with equity, &y_lbl. "
		Gap16plusEmployH_&_years. = "Difference in # of people 16+ yrs. employed Hispanic with equity, &y_lbl. "
		Gap16plusEmployA_&_years. = "Difference in # of people 16+ yrs. employed Asian-PI with equity, &y_lbl. "
		Gap16plusEmployIOM_&_years. = "Difference in # of people 16+ yrs. employed Indigenous-Other-Multi with equity, &y_lbl. "
		Gap16plusEmployAIOM_&_years. = "Difference in # of people 16+ yrs. employed All-Other with equity, &y_lbl. "

		GapEmp16to64W_&_years. = "Difference in # of NH-White people employed between 16 and 64 years old with equity, &y_lbl. "
		GapEmp16to64B_&_years. = "Difference in # of Black-Alone people employed between 16 and 64 years old with equity, &y_lbl. "
		GapEmp16to64H_&_years. = "Difference in # of Hispanic people employed between 16 and 64 years old with equity, &y_lbl. "
		GapEmp16to64A_&_years. = "Difference in # of Asian-PI people employed between 16 and 64 years old with equity, &y_lbl. "
		GapEmp16to64IOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed between 16 and 64 years old with equity, &y_lbl. "
		GapEmp16to64AIOM_&_years. = "Difference in # of All-Other people employed between 16 and 64 years old with equity, &y_lbl. "

		GapUnemployedW_&_years. = "Difference in # of NH-White unemployed people with equity, &y_lbl. "
		GapUnemployedB_&_years. = "Difference in # of Black-Alone unemployed people with equity, &y_lbl. "
		GapUnemployedH_&_years. = "Difference in # of Hispanic unemployed people with equity, &y_lbl. "
		GapUnemployedA_&_years. = "Difference in # of Asian-PI unemployed people with equity, &y_lbl. "
		GapUnemployedIOM_&_years. = "Difference in # of Indigenous-Other-Multi unemployed people with equity, &y_lbl. "
		GapUnemployedAIOM_&_years. = "Difference in # of All-Other unemployed people with equity, &y_lbl. "

		Gap16plusWagesW_&_years. = "Difference in # of NH-White people employed with earnings with equity, &y_lbl. "
		Gap16plusWagesB_&_years. = "Difference in # of Black-Alone people employed with earnings with equity, &y_lbl. "
		Gap16plusWagesH_&_years. = "Difference in # of Hispanic people employed with earnings with equity, &y_lbl. "
		Gap16plusWagesA_&_years. = "Difference in # of Asian-PI people employed with earnings with equity, &y_lbl. "
		Gap16plusWagesIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed with earnings with equity, &y_lbl. "
		Gap16plusWagesAIOM_&_years. = "Difference in # of All-Other people employed with earnings with equity, &y_lbl. "

		Gap16plusWorkFTW_&_years. = "Difference in # of NH-White people employed full time with equity, &y_lbl. "
		Gap16plusWorkFTB_&_years. = "Difference in # of Black-Alone people employed full time with equity, &y_lbl. "
		Gap16plusWorkFTH_&_years. = "Difference in # of Hispanic people employed full time with equity, &y_lbl. "
		Gap16plusWorkFTA_&_years. = "Difference in # of Asian-PI people employed full time with equity, 2010-1 4"
		Gap16plusWorkFTIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with equity, 2010-1 4"
		Gap16plusWorkFTAIOM_&_years. = "Difference in # of All-Other people employed full time with equity, 2010-1 4"

		GapWorkFTLT35kW_&_years. = "Difference in # of NH-White people employed full time with earnings less than 35000 with equity, &y_lbl. "
		GapWorkFTLT35kB_&_years. = "Difference in # of Black-Alone people employed full time with earnings less than 35000 with equity, &y_lbl. "
		GapWorkFTLT35kH_&_years. = "Difference in # of Hispanic people employed full time with earnings less than 35000 with equity, &y_lbl. "
		GapWorkFTLT35kA_&_years. = "Difference in # of Asian people employed full time with earnings less than 35000 with equity, &y_lbl. "
		GapWorkFTLT35kIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with earnings less than 35000 with equity, &y_lbl. "
		GapWorkFTLT35kAIOM_&_years. = "Difference in # of All-Other people employed full time with earnings less than 35000 with equity, &y_lbl. "

		GapWorkFTLT75kW_&_years. = "Difference in # of NH-White people employed full time with earnings less than 75000 with equity, &y_lbl. "
		GapWorkFTLT75kB_&_years. = "Difference in # of Black-Alone people employed full time with earnings less than 75000 with equity, &y_lbl. "
		GapWorkFTLT75kH_&_years. = "Difference in # of Hispanic people employed full time with earnings less than 75000 with equity, &y_lbl. "
		GapWorkFTLT75kA_&_years. = "Difference in # of Asian-PI people employed full time with earnings less than 75000 with equity, &y_lbl. "
		GapWorkFTLT75kIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed full time with earnings less than 75000 with equity, &y_lbl. "
		GapWorkFTLT75kAIOM_&_years. = "Difference in # of All-Other people employed full time with earnings less than 75000 with equity, &y_lbl. "

		GapEmpMngmtW_&_years. = "Difference in # of NH-White people employed in management business science and arts occupations with equity, &y_lbl. "
		GapEmpMngmtB_&_years. = "Difference in # of Black-Alone people employed in management business science and arts occupations with equity, &y_lbl. "
		GapEmpMngmtH_&_years. = "Difference in # of Hispanic people employed in management business science and arts occupations with equity, &y_lbl. "
		GapEmpMngmtA_&_years. = "Difference in # of Asian-PI people employed in management business science and arts occupations with equity, &y_lbl. "
		GapEmpMngmtIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in management business science and arts occupations with equity, &y_lbl. "
		GapEmpMngmtAIOM_&_years. = "Difference in # of All-Other people employed in management business science and arts occupations with equity, &y_lbl. "

		GapEmpServW_&_years. = "Difference in # of NH-White people employed in service occupations with equity, &y_lbl. "
		GapEmpServB_&_years. = "Difference in # of Black-Alone people employed in service occupations with equity, &y_lbl. "
		GapEmpServH_&_years. = "Difference in # of Hispanic people employed in service occupations with equity, &y_lbl. "
		GapEmpServA_&_years. = "Difference in # of Asian-PI people employed in service occupations with equity, &y_lbl."
		GapEmpServIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in service occupations with equity, &y_lbl."
		GapEmpServAIOM_&_years. = "Difference in # of All-Other people employed in service occupations with equity, &y_lbl."

		GapEmpSalesW_&_years. = "Difference in # of NH-White people employed in sales and office occupations with equity, &y_lbl. "
		GapEmpSalesB_&_years. = "Difference in # of Black-Alone people employed in sales and office occupations with equity, &y_lbl. "
		GapEmpSalesH_&_years. = "Difference in # of Hispanic people employed in sales and office occupations with equity, &y_lbl. "
		GapEmpSalesA_&_years. = "Difference in # of Asian-PI people employed in sales and office occupations with equity, &y_lbl. "
		GapEmpSalesIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in sales and office occupations with equity, &y_lbl. "
		GapEmpSalesAIOM_&_years. = "Difference in # of All-Other people employed in sales and office occupations with equity, &y_lbl. "

		GapEmpNatResW_&_years. = "Difference in # of NH-White people employed in natural resources construction and maintenance occupations with equity, &y_lbl. "
		GapEmpNatResB_&_years. = "Difference in # of Black-Alone people employed in natural resources construction and maintenance occupations with equity, &y_lbl. "
		GapEmpNatResH_&_years. = "Difference in # of Hispanic people employed in natural resources construction and maintenance occupations with equity, &y_lbl. "
		GapEmpNatResA_&_years. = "Difference in # of Asian-PI people employed in natural resources construction and maintenance occupations with equity, &y_lbl. "
		GapEmpNatResIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in natural resources construction and maintenance occupations with equity, &y_lbl. "
		GapEmpNatResAIOM_&_years. = "Difference in # of All-Other people employed in natural resources construction and maintenance occupations with equity, &y_lbl. "

		GapEmpProdW_&_years. = "Difference in # of NH-White people employed in production transportation and material moving occupations with equity, &y_lbl. "
		GapEmpProdB_&_years. = "Difference in # of Black-Alone people employed in production transportation and material moving occupations with equity, &y_lbl. "
		GapEmpProdH_&_years. = "Difference in # of Hispanic people employed in production transportation and material moving occupations with equity, &y_lbl. "
		GapEmpProdA_&_years. = "Difference in # of Asian-PI people employed in production transportation and material moving occupations with equity, &y_lbl. "
		GapEmpProdIOM_&_years. = "Difference in # of Indigenous-Other-Multi people employed in production transportation and material moving occupations with equity, &y_lbl. "
		GapEmpProdAIOM_&_years. = "Difference in # of All-Other people employed in production transportation and material moving occupations with equity, &y_lbl. "

		GapOwnerOccupiedHUW_&_years. = "Difference in # of NH-White homeowners with equity, &y_lbl. "
		GapOwnerOccupiedHUB_&_years. = "Difference in # of Black-Alone homeowners with equity, &y_lbl. "
		GapOwnerOccupiedHUH_&_years. = "Difference in # of Hispanic homeowners with equity, &y_lbl. "
		GapOwnerOccupiedHUA_&_years. = "Difference in # of Asian-PI homeowners with equity, &y_lbl. "
		GapOwnerOccupiedHUIOM_&_years. = "Difference in # of Indigenous-Other-Multi homeowners with equity, &y_lbl. "
		GapOwnerOccupiedHUAIOM_&_years. = "Difference in # of All-Other homeowners with equity, &y_lbl. "
		;
	
run;

%round_output (in=profile_tabs_ACS_suppress_&ct.,out=profile_tabs_ACS_rounded_&ct.);

proc transpose data=profile_tabs_ACS_rounded_&ct. out=profile_tabs_&_years._&ct._ACS ;/*(label="DC Equity Indicators and Gap Calculations for Equity Profile City & Ward, &y_lbl."); */
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
		PctPop35_64YearsA_: PctPop35_64YearsIOM_: 

		PctPop65andOverYears_: PctPop65andOverYrs_:
		PctPop65andOverYearsW_: PctPop65andOverYrsW_:
		PctPop65andOverYearsB_: PctPop65andOverYrsB_:
		PctPop65andOverYearsH_: PctPop65andOverYrsH_:
		PctPop65andOverYearsA_: PctPop65andOverYrsA_:
		PctPop65andOverYearsIOM_: PctPop65andOverYrsIOM_:


		PctForeignBorn_: PctNativeBorn_: 

		PctForeignBornB_: PctForeignBornW_:
		PctForeignBornH_: PctForeignBornA_: PctForeignBornIOM_: 

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
		
		Pct16plusEmploy_:
		Pct16plusEmployW_:
		Pct16plusEmployB_:
		Pct16plusEmployH_:
		Pct16plusEmployA_:
		Pct16plusEmployIOM_:

		Gap16plusEmployB_:
		Gap16plusEmployH_:
		Gap16plusEmployA_:
		Gap16plusEmployIOM_:

		PctEmp16to64_:
		PctEmp16to64W_:
		PctEmp16to64B_:
		PctEmp16to64H_:
		PctEmp16to64A_:
		PctEmp16to64IOM_:

		GapEmp16to64B_:
		GapEmp16to64H_:
		GapEmp16to64A_:
		GapEmp16to64IOM_:

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

		Pct16plusWages_:
		Pct16plusWagesW_:
		Pct16plusWagesB_:
		Pct16plusWagesH_:
		Pct16plusWagesA_:
		Pct16plusWagesIOM_:

		Gap16plusWagesB_:
		Gap16plusWagesH_:
		Gap16plusWagesA_:
		Gap16plusWagesIOM_:

		Pct16plusWorkFT_:
		Pct16plusWorkFTW_:
		Pct16plusWorkFTB_:
		Pct16plusWorkFTH_:
		Pct16plusWorkFTA_:
		Pct16plusWorkFTIOM_:

		Gap16plusWorkFTB_:
		Gap16plusWorkFTH_:
		Gap16plusWorkFTA_:
		Gap16plusWorkFTIOM_:

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

		PctEmpMngmt_:
		PctEmpMngmtW_:
		PctEmpMngmtB_:
		PctEmpMngmtH_:
		PctEmpMngmtA_:
		PctEmpMngmtIOM_:

		PctEmpServ_:
		PctEmpServW_:
		PctEmpServB_:
		PctEmpServH_:
		PctEmpServA_:
		PctEmpServIOM_:

		PctEmpSales_:
		PctEmpSalesW_:
		PctEmpSalesB_:
		PctEmpSalesH_:
		PctEmpSalesA_:
		PctEmpSalesIOM_:

		PctEmpNatRes_:
		PctEmpNatResW_:
		PctEmpNatResB_:
		PctEmpNatResH_:
		PctEmpNatResA_:
		PctEmpNatResIOM_:

		PctEmpProd_:
		PctEmpProdW_:
		PctEmpProdB_:
		PctEmpProdH_:
		PctEmpProdA_:
		PctEmpProdIOM_:

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

	id councildist; 
run; 

options mprint=y; 

proc export data=profile_tabs_&_years._&ct._ACS
	outfile="&_dcdata_default_path.\Equity\Prog\profile_tabs_&ct._ACS_&_years..csv"
	dbms=csv replace;
	run;

%mend acs_profiles_county;

%acs_profiles_county (DC);
%acs_profiles_county (Fairfax);
%acs_profiles_county (Montgomery);
%acs_profiles_county (PG);


/* End of program */
