/**************************************************************************
 Program:  Equity_ACS_profile_COMM.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey & S. Diby
 Created:  08/22/16
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Outputs  data in  decimal format for COMM. 
**************************************************************************/
%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( ACS )
%DCData_lib( Equity )


*output population by race;
data population (label="Population Race Variables for COMM" drop=Pct: q);  
set equity.profile_tabs_ACS_suppress (keep=  city ward2012 

		   PopWithRace: mPopWithRace:
		   PopBlackNonHispBridge: mPopBlackNonHispBridge:
           PopWhiteNonHispBridge: mPopWhiteNonHispBridge:
		   PopHisp: mPopHisp:
		   PopAsianPINonHispBridge: mPopAsianPINonHispBridge:
		   PopOtherRaceNonHispBridg: mPopOtherRaceNonHispBr:
		   PopMultiracialNonHisp: mPopMultiracialNonHisp:
		   PopAlone: mPopAlone:
	
	
	PctBlackNonHispBridge: PctWhiteNonHispBridge:
	PctHisp: PctAsnPINonHispBridge: PctOtherRace: PctOthRace:
	
	PctAloneB: PctAloneW: PctAloneH: PctAloneA_:
	PctAloneI_: PctAloneO: PctAloneM: PctAloneIOM: PctAloneAIOM:
	
	PopForeignBorn_2010_14
	PctForeignBorn_: 

	PctOthLang:
	PopNonEnglish_2010_14  mPopNonEnglish_2010_14 Pop5andOverYears_2010_14 mPop5andOverYears_2010_14);


			array oldvars_e {14}
				PctBlackNonHispBridge_2010_14 PctWhiteNonHispBridge_2010_14 PctHisp_2010_14 
				PctAsnPINonHispBridge_2010_14 PctOtherRaceNonHispBridg_2010_14 

				PctAloneA_2010_14 PctAloneB_2010_14 PctAloneW_2010_14 PctAloneI_2010_14 PctAloneO_2010_14 
				PctAloneM_2010_14 PctAloneAIOM_2010_14 

				PctForeignBorn_2010_14 PctOthLang_2010_14
				;

			array oldvars_m {14}
				PctBlackNonHispBridge_m_2010_14 PctWhiteNonHispBridge_m_2010_14 PctHisp_m_2010_14 
				PctAsnPINonHispBridge_m_2010_14 PctOthRaceNonHispBridg_m_2010_14 

				PctAloneA_m_2010_14 PctAloneB_m_2010_14 PctAloneW_m_2010_14 PctAloneI_m_2010_14 PctAloneO_m_2010_14 
				PctAloneM_m_2010_14 PctAloneAIOM_m_2010_14 

				PctForeignBorn_m_2010_14 PctOthLang_m_2010_14
				;

			array newvars_e {14}
				nPctBlackNonHispBridge_2010_14 nPctWhiteNonHispBridge_2010_14 nPctHisp_2010_14 
				nPctAsnPINonHispBridge_2010_14 nPctOthRaceNonHispBridg_2010_14 

				nPctAloneA_2010_14 nPctAloneB_2010_14 nPctAloneW_2010_14 nPctAloneI_2010_14 nPctAloneO_2010_14 
				nPctAloneM_2010_14 nPctAloneAIOM_2010_14 

				nPctForeignBorn_2010_14 nPctOthLang_2010_14	
				;

			array newvars_m {14}
				nPctBlackNonHispBridge_m_2010_14 nPctWhiteNonHispBridge_m_2010_14 nPctHisp_m_2010_14
				nPctAsnPINonHispBridge_m_2010_14 nPctOthRaceNonHisBridg_m_2010_14 

				nPctAloneA_m_2010_14 nPctAloneB_m_2010_14 nPctAloneW_m_2010_14 nPctAloneI_m_2010_14 nPctAloneO_m_2010_14 
				nPctAloneM_m_2010_14 nPctAloneAIOM_m_2010_14 

				nPctForeignBorn_m_2010_14 nPctOthLang_m_2010_14
				;

				do q=1 to 14; 

				   
						newvars_e{q}=oldvars_e{q}/100;
						newvars_m{q}=oldvars_m{q}/100;
					
					if oldvars_e{q}=.n then newvars_e{q}=.n;
					if oldvars_e{q}=.s then newvars_e{q}=.s;
					if oldvars_m{q}=.n then newvars_m{q}=.n;
					if oldvars_m{q}=.s then newvars_m{q}=.s;

				end;

	label
	nPctAloneA_2010_14="% Asian/P.I. alone, 2010-14"     
nPctAloneA_m_2010_14="MOE for % Asian/P.I. alone, 2010-14"
nPctAloneAIOM_2010_14="% All other than Black-White-Hispanic, 2010-14"    
nPctAloneAIOM_m_2010_14="MOE for % All other than Black-White-Hispanic, 2010-14"     
nPctAloneI_2010_14="% Indigenous alone, 2010-14"    
nPctAloneI_m_2010_14="MOE for % Indigenous alone, 2010-14"    
nPctAloneM_2010_14="% Multiracial, 2010-14"
nPctAloneM_m_2010_14="MOE for% Multiracial, 2010-14"
nPctAloneO_2010_14="% Other race alone, 2010-14"
nPctAloneO_m_2010_14="MOE for % Other race alone, 2010-14"
nPctAsnPINonHispBridge_2010_14="% Asian/P.I. non-Hispanic, 2010-14"     
nPctAsnPINonHispBridge_m_2010_14="MOE for % Asian/P.I. non-Hispanic, 2010-14"
nPctBlackNonHispBridge_2010_14="% black non-Hispanic, 2010-14"     
nPctBlackNonHispBridge_m_2010_14="MOE for % black non-Hispanic, 2010-14"
nPctForeignBorn_2010_14="% foreign born, 2010-14"     
nPctForeignBorn_m_2010_14="MOE for % foreign born, 2010-14"   
nPctHisp_2010_14="% Hispanic, 2010-14"    
nPctHisp_m_2010_14="MOE for % Hispanic, 2010-14"
nPctOthLang_2010_14="% pop. that speaks a language other than English at home, 2010-14"
nPctOthLang_m_2010_14="MOE for % pop. that speaks a language other than English at home, 2010-14"  
nPctOthRaceNonHisBridg_m_2010_14="MOE for % Non-Hispanic Black/African American population, 2010-14"
nPctOthRaceNonHispBridg_2010_14="% Non-Hispanic Black/African American population, 2010-14"  
nPctWhiteNonHispBridge_2010_14="% Non-Hispanic White population, 2010-14"     
nPctWhiteNonHispBridge_m_2010_14="MOE for % Non-Hispanic White population, 2010-14"     
nPctAloneB_2010_14="% black alone, 2010-14"
nPctAloneW_2010_14="% white alone, 2010-14" 
nPctAloneB_m_2010_14="MOE for % black alone, 2010-14"
nPctAloneW_m_2010_14="MOE for % white alone, 2010-14"
;


	run;
	proc contents data=population;
	run; 
	proc export data=population 
	outfile="D:\DCDATA\Libraries\Equity\Prog\ACS_ward_population_COMM.csv"
	dbms=csv replace;
	run;
data all (label="ACS Vars Edu Pov EMP for COMM" drop= q Pct:); 
set equity.profile_tabs_ACS_suppress 
	(keep=city ward2012 
				Pct25andOverWHS_2010_14 Pct25andOverWHS_m_2010_14
				Pct25andOverWSC_2010_14 Pct25andOverWSC_m_2010_14
				Pop25andOverYears_2010_14 mPop25andOverYears_2010_14
 				Pop25andOverWHS_2010_14 mPop25andOverWHS_2010_14
				Pop25andOverWSC_2010_14 mPop25andOverWSC_2010_14

				PctPoorPersons_2010_14 PctPoorPersons_m_2010_14  
				PersonsPovertyDefined_2010_14 mPersonsPovertyDefined_2010_14
				PopPoorPersons_2010_14 mPopPoorPersons_2010_14

				PctPoorChildren_2010_14 PctPoorChildren_m_2010_14
				ChildrenPovertyDefined_2010_14 mChildrenPovertyDefined_2010_14 
           		PopPoorChildren_2010_14 mPopPoorChildren_2010_14

				PctUnemployed_2010_14 PctUnemployed_m_2010_14 
				PopUnemployed_2010_14 mPopUnemployed_2010_14
				PopInCivLaborForce_2010_14 mPopInCivLaborForce_2010_14 

				PctWorkFTLT35k_2010_14 PctWorkFTLT35k_m_2010_14
				PctWorkFTLT75k_2010_14 PctWorkFTLT75k_m_2010_14 
				
				PopWorkFT_2010_14 mPopWorkFT_2010_14
				PopWorkFTLT35K_2010_14 mPopWorkFTLT35K_2010_14
		   		PopWorkFTLT75K_2010_14 mPopWorkFTLT75K_2010_14
								 								); 
length race $10.;

race="All";

array old {14} 	Pct25andOverWHS_2010_14 Pct25andOverWHS_m_2010_14
				Pct25andOverWSC_2010_14 Pct25andOverWSC_m_2010_14
				PctPoorPersons_2010_14 PctPoorPersons_m_2010_14  
				PctPoorChildren_2010_14 PctPoorChildren_m_2010_14
				PctUnemployed_2010_14 PctUnemployed_m_2010_14 
				PctWorkFTLT35k_2010_14 PctWorkFTLT35k_m_2010_14
				PctWorkFTLT75k_2010_14 PctWorkFTLT75k_m_2010_14;

array new {14} nPct25andOverWHS_2010_14 nPct25andOverWHS_m_2010_14
			   nPct25andOverWSC_2010_14 nPct25andOverWSC_m_2010_14
			   nPctPoorPersons_2010_14 nPctPoorPersons_m_2010_14  
			   nPctPoorChildren_2010_14 nPctPoorChildren_m_2010_14
				nPctUnemployed_2010_14 nPctUnemployed_m_2010_14 
				nPctWorkFTLT35k_2010_14 nPctWorkFTLT35k_m_2010_14
				nPctWorkFTLT75k_2010_14 nPctWorkFTLT75k_m_2010_14;

				do q=1 to 14; 

				   	new{q}=old{q}/100;
					if old{q}=.n then new{q}=.n;
					if old{q}=.s then new{q}=.s;

				end; 
run;
data white (drop= q Pct:); 
set equity.profile_tabs_ACS_suppress 
	(keep=city ward2012 
				Pct25andOverWHSW_2010_14 Pct25andOverWHSW_m_2010_14
				Pct25andOverWSCW_2010_14 Pct25andOverWSCW_m_2010_14
				Pop25andOverYearsW_2010_14 mPop25andOverYearsW_2010_14
 				Pop25andOverWHSW_2010_14 mPop25andOverWHSW_2010_14
				Pop25andOverWSCW_2010_14 mPop25andOverWSCW_2010_14

				PctPoorPersonsW_2010_14 PctPoorPersonsW_m_2010_14  
				PersonsPovertyDefinedW_2010_14 mPersonsPovertyDefinedW_2010_14
				PopPoorPersonsW_2010_14 mPopPoorPersonsW_2010_14

				PctPoorChildrenW_2010_14 PctPoorChildrenW_m_2010_14
				ChildrenPovertyDefinedW_2010_14 mChildrenPovertyDefinedW_2010_14 
           		PopPoorChildrenW_2010_14 mPopPoorChildrenW_2010_14

				PctUnemployedW_2010_14 PctUnemployedW_m_2010_14 
				PopUnemployedW_2010_14 mPopUnemployedW_2010_14
				PopInCivLaborForceW_2010_14 mPopInCivLaborForceW_2010_14 

				PctWorkFTLT35kW_2010_14 PctWorkFTLT35kW_m_2010_14
				PctWorkFTLT75kW_2010_14 PctWorkFTLT75kW_m_2010_14 
				
				PopWorkFTW_2010_14 mPopWorkFTW_2010_14
				PopWorkFTLT35KW_2010_14 mPopWorkFTLT35KW_2010_14
		   		PopWorkFTLT75KW_2010_14 mPopWorkFTLT75KW_2010_14
								 								); 
length race $10.;

race="White";

array old {14} 	Pct25andOverWHSW_2010_14 Pct25andOverWHSW_m_2010_14
				Pct25andOverWSCW_2010_14 Pct25andOverWSCW_m_2010_14
				PctPoorPersonsW_2010_14 PctPoorPersonsW_m_2010_14  
				PctPoorChildrenW_2010_14 PctPoorChildrenW_m_2010_14
				PctUnemployedW_2010_14 PctUnemployedW_m_2010_14 
				PctWorkFTLT35kW_2010_14 PctWorkFTLT35kW_m_2010_14
				PctWorkFTLT75kW_2010_14 PctWorkFTLT75kW_m_2010_14;

array new {14} nPct25andOverWHS_2010_14 nPct25andOverWHS_m_2010_14
			   nPct25andOverWSC_2010_14 nPct25andOverWSC_m_2010_14
			   nPctPoorPersons_2010_14 nPctPoorPersons_m_2010_14  
			   nPctPoorChildren_2010_14 nPctPoorChildren_m_2010_14
				nPctUnemployed_2010_14 nPctUnemployed_m_2010_14 
				nPctWorkFTLT35k_2010_14 nPctWorkFTLT35k_m_2010_14
				nPctWorkFTLT75k_2010_14 nPctWorkFTLT75k_m_2010_14;

				do q=1 to 14; 

				   	new{q}=old{q}/100;
					if old{q}=.n then new{q}=.n;
					if old{q}=.s then new{q}=.s;

				end; 

	rename Pop25andOverYearsW_2010_14=Pop25andOverYears_2010_14
			mPop25andOverYearsW_2010_14=mPop25andOverYears_2010_14
			Pop25andOverWHSW_2010_14=Pop25andOverWHS_2010_14
			mPop25andOverWHSW_2010_14=mPop25andOverWHS_2010_14
			Pop25andOverWSCW_2010_14=Pop25andOverWSC_2010_14
			mPop25andOverWSCW_2010_14=mPop25andOverWSC_2010_14
			PersonsPovertyDefinedW_2010_14=PersonsPovertyDefined_2010_14 
			mPersonsPovertyDefinedW_2010_14=mPersonsPovertyDefined_2010_14
				PopPoorPersonsW_2010_14=PopPoorPersons_2010_14
				mPopPoorPersonsW_2010_14=mPopPoorPersons_2010_14
				ChildrenPovertyDefinedW_2010_14=ChildrenPovertyDefined_2010_14
				mChildrenPovertyDefinedW_2010_14=mChildrenPovertyDefined_2010_14 
           		PopPoorChildrenW_2010_14=PopPoorChildren_2010_14
				mPopPoorChildrenW_2010_14=mPopPoorChildren_2010_14
				PopUnemployedW_2010_14=PopUnemployed_2010_14  
				mPopUnemployedW_2010_14=mPopUnemployed_2010_14
				PopInCivLaborForceW_2010_14=PopInCivLaborForce_2010_14 
				mPopInCivLaborForceW_2010_14=mPopInCivLaborForce_2010_14 
				PopWorkFTW_2010_14=PopWorkFT_2010_14  
				mPopWorkFTW_2010_14=mPopWorkFT_2010_14
				PopWorkFTLT35KW_2010_14=PopWorkFTLT35K_2010_14 
				mPopWorkFTLT35KW_2010_14=mPopWorkFTLT35K_2010_14
		   		PopWorkFTLT75KW_2010_14=PopWorkFTLT75K_2010_14 
				mPopWorkFTLT75KW_2010_14=mPopWorkFTLT75K_2010_14;

run;

data black (drop= q Pct:); 
set equity.profile_tabs_ACS_suppress 
	(keep=city ward2012 
				Pct25andOverWHSB_2010_14 Pct25andOverWHSB_m_2010_14
				Pct25andOverWSCB_2010_14 Pct25andOverWSCB_m_2010_14
				Pop25andOverYearsB_2010_14 mPop25andOverYearsB_2010_14
 				Pop25andOverWHSB_2010_14 mPop25andOverWHSB_2010_14
				Pop25andOverWSCB_2010_14 mPop25andOverWSCB_2010_14
				Gap25andOverWHSB_2010_14
				Gap25andOverWSCB_2010_14

				PctPoorPersonsB_2010_14 PctPoorPersonsB_m_2010_14  
				PersonsPovertyDefinedB_2010_14 mPersonsPovertyDefinedB_2010_14
				PopPoorPersonsB_2010_14 mPopPoorPersonsB_2010_14
				GapPoorPersonsB_2010_14

				PctPoorChildrenB_2010_14 PctPoorChildrenB_m_2010_14
				ChildrenPovertyDefinedB_2010_14 mChildrenPovertyDefinedB_2010_14 
           		PopPoorChildrenB_2010_14 mPopPoorChildrenB_2010_14

				PctUnemployedB_2010_14 PctUnemployedB_m_2010_14 
				PopUnemployedB_2010_14 mPopUnemployedB_2010_14
				PopInCivLaborForceB_2010_14 mPopInCivLaborForceB_2010_14 
				GapUnemployedB_2010_14

				PctWorkFTLT35kB_2010_14 PctWorkFTLT35kB_m_2010_14
				PctWorkFTLT75kB_2010_14 PctWorkFTLT75kB_m_2010_14 
				
				PopWorkFTB_2010_14 mPopWorkFTB_2010_14
				PopWorkFTLT35KB_2010_14 mPopWorkFTLT35KB_2010_14
		   		PopWorkFTLT75KB_2010_14 mPopWorkFTLT75KB_2010_14
				GapWorkFTLT35kB_2010_14
				GapWorkFTLT75kB_2010_14); 

length race $10.;

race="Black";

array old {14} 	Pct25andOverWHSB_2010_14 Pct25andOverWHSB_m_2010_14
				Pct25andOverWSCB_2010_14 Pct25andOverWSCB_m_2010_14
				PctPoorPersonsB_2010_14 PctPoorPersonsB_m_2010_14  
				PctPoorChildrenB_2010_14 PctPoorChildrenB_m_2010_14
				PctUnemployedB_2010_14 PctUnemployedB_m_2010_14 
				PctWorkFTLT35kB_2010_14 PctWorkFTLT35kB_m_2010_14
				PctWorkFTLT75kB_2010_14 PctWorkFTLT75kB_m_2010_14;

array new {14} nPct25andOverWHS_2010_14 nPct25andOverWHS_m_2010_14
			   nPct25andOverWSC_2010_14 nPct25andOverWSC_m_2010_14
			   nPctPoorPersons_2010_14 nPctPoorPersons_m_2010_14  
			   nPctPoorChildren_2010_14 nPctPoorChildren_m_2010_14
				nPctUnemployed_2010_14 nPctUnemployed_m_2010_14 
				nPctWorkFTLT35k_2010_14 nPctWorkFTLT35k_m_2010_14
				nPctWorkFTLT75k_2010_14 nPctWorkFTLT75k_m_2010_14;

				do q=1 to 14; 

				   	new{q}=old{q}/100;
					if old{q}=.n then new{q}=.n;
					if old{q}=.s then new{q}=.s;

				end; 

					rename Pop25andOverYearsB_2010_14=Pop25andOverYears_2010_14
			mPop25andOverYearsB_2010_14=mPop25andOverYears_2010_14
			Pop25andOverWHSB_2010_14=Pop25andOverWHS_2010_14
			mPop25andOverWHSB_2010_14=mPop25andOverWHS_2010_14
			Pop25andOverWSCB_2010_14=Pop25andOverWSC_2010_14
			mPop25andOverWSCB_2010_14=mPop25andOverWSC_2010_14
			PersonsPovertyDefinedB_2010_14=PersonsPovertyDefined_2010_14 
			mPersonsPovertyDefinedB_2010_14=mPersonsPovertyDefined_2010_14
				PopPoorPersonsB_2010_14=PopPoorPersons_2010_14
				mPopPoorPersonsB_2010_14=mPopPoorPersons_2010_14
				ChildrenPovertyDefinedB_2010_14=ChildrenPovertyDefined_2010_14
				mChildrenPovertyDefinedB_2010_14=mChildrenPovertyDefined_2010_14 
           		PopPoorChildrenB_2010_14=PopPoorChildren_2010_14
				mPopPoorChildrenB_2010_14=mPopPoorChildren_2010_14
				PopUnemployedB_2010_14=PopUnemployed_2010_14  
				mPopUnemployedB_2010_14=mPopUnemployed_2010_14
				PopInCivLaborForceB_2010_14=PopInCivLaborForce_2010_14 
				mPopInCivLaborForceB_2010_14=mPopInCivLaborForce_2010_14 
				PopWorkFTB_2010_14=PopWorkFT_2010_14  
				mPopWorkFTB_2010_14=mPopWorkFT_2010_14
				PopWorkFTLT35KB_2010_14=PopWorkFTLT35K_2010_14 
				mPopWorkFTLT35KB_2010_14=mPopWorkFTLT35K_2010_14
		   		PopWorkFTLT75KB_2010_14=PopWorkFTLT75K_2010_14 
				mPopWorkFTLT75KB_2010_14=mPopWorkFTLT75K_2010_14
				Gap25andOverWHSB_2010_14=Gap25andOverWHS_2010_14
				Gap25andOverWSCB_2010_14=Gap25andOverWSC_2010_14
				GapPoorPersonsB_2010_14=GapPoorPersons_2010_14
				GapUnemployedB_2010_14=GapUnemployed_2010_14
				GapWorkFTLT35kB_2010_14=GapWorkFTLT35k_2010_14
				GapWorkFTLT75kB_2010_14=GapWorkFTLT75k_2010_14;
run;

data hispanic (drop= q Pct:); 
set equity.profile_tabs_ACS_suppress 
	(keep=city ward2012 
				Pct25andOverWHSH_2010_14 Pct25andOverWHSH_m_2010_14
				Pct25andOverWSCH_2010_14 Pct25andOverWSCH_m_2010_14
				Pop25andOverYearsH_2010_14 mPop25andOverYearsH_2010_14
 				Pop25andOverWHSH_2010_14 mPop25andOverWHSH_2010_14
				Pop25andOverWSCH_2010_14 mPop25andOverWSCH_2010_14
				Gap25andOverWHSH_2010_14
				Gap25andOverWSCH_2010_14

				PctPoorPersonsH_2010_14 PctPoorPersonsH_m_2010_14  
				PersonsPovertyDefinedH_2010_14 mPersonsPovertyDefinedH_2010_14
				PopPoorPersonsH_2010_14 mPopPoorPersonsH_2010_14
				GapPoorPersonsH_2010_14

				PctPoorChildrenH_2010_14 PctPoorChildrenH_m_2010_14
				ChildrenPovertyDefinedH_2010_14 mChildrenPovertyDefinedH_2010_14 
           		PopPoorChildrenH_2010_14 mPopPoorChildrenH_2010_14

				PctUnemployedH_2010_14 PctUnemployedH_m_2010_14 
				PopUnemployedH_2010_14 mPopUnemployedH_2010_14
				PopInCivLaborForceH_2010_14 mPopInCivLaborForceH_2010_14 
				GapUnemployedH_2010_14

				PctWorkFTLT35kH_2010_14 PctWorkFTLT35kH_m_2010_14
				PctWorkFTLT75kH_2010_14 PctWorkFTLT75kH_m_2010_14 
				
				PopWorkFTH_2010_14 mPopWorkFTH_2010_14
				PopWorkFTLT35KH_2010_14 mPopWorkFTLT35KH_2010_14
		   		PopWorkFTLT75KH_2010_14 mPopWorkFTLT75KH_2010_14
				GapWorkFTLT35kH_2010_14
				GapWorkFTLT75kH_2010_14); 

length race $10.;

race="Hispanic";

array old {14} 	Pct25andOverWHSH_2010_14 Pct25andOverWHSH_m_2010_14
				Pct25andOverWSCH_2010_14 Pct25andOverWSCH_m_2010_14
				PctPoorPersonsH_2010_14 PctPoorPersonsH_m_2010_14  
				PctPoorChildrenH_2010_14 PctPoorChildrenH_m_2010_14
				PctUnemployedH_2010_14 PctUnemployedH_m_2010_14 
				PctWorkFTLT35kH_2010_14 PctWorkFTLT35kH_m_2010_14
				PctWorkFTLT75kH_2010_14 PctWorkFTLT75kH_m_2010_14;

array new {14} nPct25andOverWHS_2010_14 nPct25andOverWHS_m_2010_14
			   nPct25andOverWSC_2010_14 nPct25andOverWSC_m_2010_14
			   nPctPoorPersons_2010_14 nPctPoorPersons_m_2010_14  
			   nPctPoorChildren_2010_14 nPctPoorChildren_m_2010_14
				nPctUnemployed_2010_14 nPctUnemployed_m_2010_14 
				nPctWorkFTLT35k_2010_14 nPctWorkFTLT35k_m_2010_14
				nPctWorkFTLT75k_2010_14 nPctWorkFTLT75k_m_2010_14;

				do q=1 to 14; 

				   	new{q}=old{q}/100;
					if old{q}=.n then new{q}=.n;
					if old{q}=.s then new{q}=.s;

				end; 
					rename Pop25andOverYearsH_2010_14=Pop25andOverYears_2010_14
			mPop25andOverYearsH_2010_14=mPop25andOverYears_2010_14
			Pop25andOverWHSH_2010_14=Pop25andOverWHS_2010_14
			mPop25andOverWHSH_2010_14=mPop25andOverWHS_2010_14
			Pop25andOverWSCH_2010_14=Pop25andOverWSC_2010_14
			mPop25andOverWSCH_2010_14=mPop25andOverWSC_2010_14
			PersonsPovertyDefinedH_2010_14=PersonsPovertyDefined_2010_14 
			mPersonsPovertyDefinedH_2010_14=mPersonsPovertyDefined_2010_14
				PopPoorPersonsH_2010_14=PopPoorPersons_2010_14
				mPopPoorPersonsH_2010_14=mPopPoorPersons_2010_14
				ChildrenPovertyDefinedH_2010_14=ChildrenPovertyDefined_2010_14
				mChildrenPovertyDefinedH_2010_14=mChildrenPovertyDefined_2010_14 
           		PopPoorChildrenH_2010_14=PopPoorChildren_2010_14
				mPopPoorChildrenH_2010_14=mPopPoorChildren_2010_14
				PopUnemployedH_2010_14=PopUnemployed_2010_14  
				mPopUnemployedH_2010_14=mPopUnemployed_2010_14
				PopInCivLaborForceH_2010_14=PopInCivLaborForce_2010_14 
				mPopInCivLaborForceH_2010_14=mPopInCivLaborForce_2010_14 
				PopWorkFTH_2010_14=PopWorkFT_2010_14  
				mPopWorkFTH_2010_14=mPopWorkFT_2010_14
				PopWorkFTLT35KH_2010_14=PopWorkFTLT35K_2010_14 
				mPopWorkFTLT35KH_2010_14=mPopWorkFTLT35K_2010_14
		   		PopWorkFTLT75KH_2010_14=PopWorkFTLT75K_2010_14 
				mPopWorkFTLT75KH_2010_14=mPopWorkFTLT75K_2010_14
				Gap25andOverWHSH_2010_14=Gap25andOverWHS_2010_14
				Gap25andOverWSCH_2010_14=Gap25andOverWSC_2010_14
				GapPoorPersonsH_2010_14=GapPoorPersons_2010_14
				GapUnemployedH_2010_14=GapUnemployed_2010_14
				GapWorkFTLT35kH_2010_14=GapWorkFTLT35k_2010_14
				GapWorkFTLT75kH_2010_14=GapWorkFTLT75k_2010_14;



run;

data all_race (label="ACS Tabulations Edu, Pov, Unemp, Living Wage for COMM");
	set all white black hispanic;
label Gap25andOverWHS_2010_14="Gap in number of adults over age 25 with HS degree compared to white rate citywide, 2010-14"
Gap25andOverWSC_2010_14="Gap in number of adults over age 25 with some college compared to white rate citywide, 2010-14"   
GapPoorPersons_2010_14="Gap in number of poor people compared to white rate citywide, 2010-14" 
GapUnemployed_2010_14="Gap in number of unemployed people over age 16 compared to white rate citywide, 2010-14"  
GapWorkFTLT35k_2010_14="Gap in number of people over age 16 working full-time earning less than $35K/yr compared to white rate citywide, 2010-14"  
GapWorkFTLT75k_2010_14="Gap in number of peoplee over age 16 working full-time earning less than $75K/yr compared to white rate citywide, 2010-14"   
nPct25andOverWHS_2010_14="Pct. Persons 25 years old and over with a high school diploma or GED, 2010-14"  
nPct25andOverWHS_m_2010_14="MOE for Pct. Persons 25 years old and over with a high school diploma or GED, 2010-14"      
nPct25andOverWSC_2010_14="Pct. Persons 25 years old and over with some college, 2010-14"  
nPct25andOverWSC_m_2010_14="MOE for Pct. Persons 25 years old and over with some college, 2010-14"      
nPctPoorChildren_2010_14="Pct. Children under 18 years old below the poverty level last year, 2010-14"  
nPctPoorChildren_m_2010_14="MOE for Pct. Children under 18 years old below the poverty level last year, 2010-14"      
nPctPoorPersons_2010_14="Pct. Persons below the poverty level last year, 2010-14" 
nPctPoorPersons_m_2010_14="MOE for Pct. Persons below the poverty level last year, 2010-14"    
nPctUnemployed_2010_14="Pct. Persons 16+ years old in the civilian labor force and unemployed, 2010-14"
nPctUnemployed_m_2010_14="MOE for Pct. Persons 16+ years old in the civilian labor force and unemployed, 2010-14" 
nPctWorkFTLT35k_2010_14="Pct. Persons 16+ years old working full time with earnings less than $35K/yr, 2010-14"
nPctWorkFTLT35k_m_2010_14="MOE for Pct. Persons 16+ years old working full time with earnings less than $35K/yr, 2010-14"    
nPctWorkFTLT75k_2010_14="Pct. Persons 16+ years old working full time with earnings less than $75K/yr, 2010-14" 
nPctWorkFTLT75k_m_2010_14="MOE for Pct. Persons 16+ years old working full time with earnings less than $75K/yr, 2010-14"   
race="Race Indicator"  

; 

	run;
proc sort data=all_race;
by ward2012 race;

proc export data=all_race 
	outfile="D:\DCDATA\Libraries\Equity\Prog\ACS_Ward_COMMOutput.csv"
	dbms=csv replace;
	run;

proc contents data=all_race;
run;
