/**************************************************************************
 Program:  decimal_convert.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Converts percentages for by-race and total variable estimates and MOEs to decimals. 
			   Created in anticipation of Racial Equity interactive feature published on Urban.org--
			   Comms prefers decimals for csv format.
**************************************************************************/

%macro decimal_convert;

*Create arrays for total variable estimates and MOEs (not by race). 
Arrays list existing variables in percent format and new arrays will be in decimal format;

			array oldvars_e {45}
				PctBlackNonHispBridge_2010_14 PctWhiteNonHispBridge_2010_14 PctHisp_2010_14 
				PctAsnPINonHispBridge_2010_14 PctOtherRaceNonHispBridg_2010_14 

				PctAloneA_2010_14 PctAloneI_2010_14 PctAloneO_2010_14 
				PctAloneM_2010_14 PctAloneIOM_2010_14 

				PctNativeBorn_2010_14 PctForeignBorn_2010_14 PctOthLang_2010_14

				PctPopUnder18Years_2010_14 PctPop18_34Years_2010_14 
				PctPop35_64Years_2010_14 PctPop65andOverYears_2010_14

				Pct25andOverWoutHS_2010_14 Pct25andOverWoutHSFB_2010_14 Pct25andOverWoutHSNB_2010_14
				Pct25andOverWHS_2010_14 Pct25andOverWHSFB_2010_14 Pct25andOverWHSNB_2010_14
				Pct25andOverWSC_2010_14 Pct25andOverWSCFB_2010_14 Pct25andOverWSCNB_2010_14
				AvgHshldIncAdj_2010_14 PctFamilyGT200000_2010_14 PctFamilyLT75000_2010_14
				PctPoorPersons_2010_14 PctPoorPersonsFB_2010_14 PctPoorChildren_2010_14
				Pct16andOverEmploy_2010_14 PctEmployed16to64_2010_14 PctUnemployed_2010_14 
				Pct16andOverWages_2010_14 Pct16andOverWorkFT_2010_14 PctWorkFTLT35k_2010_14
				PctWorkFTLT75k_2010_14 PctEmployedMngmt_2010_14 PctEmployedServ_2010_14 
				PctEmployedSales_2010_14 PctEmployedNatRes_2010_14 PctEmployedProd_2010_14
				PctOwnerOccupiedHU_2010_14
				;

			array oldvars_m {45}
				PctBlackNonHispBridge_m_2010_14 PctWhiteNonHispBridge_m_2010_14 PctHisp_m_2010_14 
				PctAsnPINonHispBridge_m_2010_14 PctOthRaceNonHispBridg_m_2010_14 

				PctAloneA_m_2010_14 PctAloneI_m_2010_14 PctAloneO_m_2010_14 
				PctAloneM_m_2010_14 PctAloneIOM_m_2010_14 

				PctNativeBorn_m_2010_14 PctForeignBorn_m_2010_14 PctOthLang_m_2010_14

				PctPopUnder18Years_m_2010_14 PctPop18_34Years_m_2010_14 
				PctPop35_64Years_m_2010_14 PctPop65andOverYrs_m_2010_14

				Pct25andOverWoutHS_m_2010_14 Pct25andOverWoutHSFB_m_2010_14 Pct25andOverWoutHSNB_m_2010_14
				Pct25andOverWHS_m_2010_14 Pct25andOverWHSFB_m_2010_14 Pct25andOverWHSNB_m_2010_14
				Pct25andOverWSC_m_2010_14 Pct25andOverWSCFB_m_2010_14 Pct25andOverWSCNB_m_2010_14
				AvgHshldIncAdj_m_2010_14 PctFamilyGT200000_m_2010_14 PctFamilyLT75000_m_2010_14
				PctPoorPersons_m_2010_14 PctPoorPersonsFB_m_2010_14 PctPoorChildren_m_2010_14
				Pct16andOverEmploy_m_2010_14 PctEmployed16to64_m_2010_14 PctUnemployed_m_2010_14 
				Pct16andOverWages_m_2010_14 Pct16andOverWorkFT_m_2010_14 PctWorkFTLT35k_m_2010_14
				PctWorkFTLT75k_m_2010_14 PctEmployedMngmt_m_2010_14 PctEmployedServ_m_2010_14 
				PctEmployedSales_m_2010_14 PctEmployedNatRes_m_2010_14 PctEmployedProd_m_2010_14
				PctOwnerOccupiedHU_m_2010_14
				;

			array newvars_e {45}
				nPctBlackNonHispBridge_2010_14 nPctWhiteNonHispBridge_2010_14 nPctHisp_2010_14 
				nPctAsnPINonHispBridge_2010_14 nPctOthRaceNonHispBridg_2010_14 

				nPctAloneA_2010_14 nPctAloneI_2010_14 nPctAloneO_2010_14 
				nPctAloneM_2010_14 nPctAloneIOM_2010_14 

				nPctNativeBorn_2010_14 nPctForeignBorn_2010_14 nPctOthLang_2010_14

				nPctPopUnder18Years_2010_14 nPctPop18_34Years_2010_14 
				nPctPop35_64Years_2010_14 nPctPop65andOverYears_2010_14 

				nPct25andOverWoutHS_2010_14 nPct25andOverWoutHSFB_2010_14 nPct25andOverWoutHSNB_2010_14
				nPct25andOverWHS_2010_14 nPct25andOverWHSFB_2010_14 nPct25andOverWHSNB_2010_14
				nPct25andOverWSC_2010_14 nPct25andOverWSCFB_2010_14 nPct25andOverWSCNB_2010_14
				nAvgHshldIncAdj_2010_14 nPctFamilyGT200000_2010_14 nPctFamilyLT75000_2010_14
				nPctPoorPersons_2010_14 nPctPoorPersonsFB_2010_14 nPctPoorChildren_2010_14
				nPct16andOverEmploy_2010_14 nPctEmployed16to64_2010_14 nPctUnemployed_2010_14 
				nPct16andOverWages_2010_14 nPct16andOverWorkFT_2010_14 nPctWorkFTLT35k_2010_14
				nPctWorkFTLT75k_2010_14 nPctEmployedMngmt_2010_14 nPctEmployedServ_2010_14 
				nPctEmployedSales_2010_14 nPctEmployedNatRes_2010_14 nPctEmployedProd_2010_14
				nPctOwnerOccupiedHU_2010_14
				;

			array newvars_m {45}
				nPctBlackNonHispBridge_m_2010_14 nPctWhiteNonHispBridge_m_2010_14 nPctHisp_m_2010_14
				nPctAsnPINonHispBridge_m_2010_14 nPctOthRaceNonHisBridg_m_2010_14 

				nPctAloneA_m_2010_14 nPctAloneI_m_2010_14 nPctAloneO_m_2010_14 
				nPctAloneM_m_2010_14 nPctAloneIOM_m_2010_14 

				nPctNativeBorn_m_2010_14 nPctForeignBorn_m_2010_14 nPctOthLang_m_2010_14

				nPctPopUnder18Years_m_2010_14 nPctPop18_34Years_m_2010_14 
				nPctPop35_64Years_m_2010_14 nPctPop65andOverYrs_m_2010_14

				nPct25andOverWoutHS_m_2010_14 nPct25andOverWoutHSFB_m_2010_14 nPct25andOverWoutHSNB_m_2010_14
				nPct25andOverWHS_m_2010_14 nPct25andOverWHSFB_m_2010_14 nPct25andOverWHSNB_m_2010_14
				nPct25andOverWSC_m_2010_14 nPct25andOverWSCFB_m_2010_14 nPct25andOverWSCNB_m_2010_14
				nAvgHshldIncAdj_m_2010_14 nPctFamilyGT200000_m_2010_14 nPctFamilyLT75000_m_2010_14
				nPctPoorPersons_m_2010_14 nPctPoorPersonsFB_m_2010_14 nPctPoorChildren_m_2010_14
				nPct16andOverEmploy_m_2010_14 nPctEmployed16to64_m_2010_14 nPctUnemployed_m_2010_14 
				nPct16andOverWages_m_2010_14 nPct16andOverWorkFT_m_2010_14 nPctWorkFTLT35k_m_2010_14 
				nPctWorkFTLT75k_m_2010_14 nPctEmployedMngmt_m_2010_14 nPctEmployedServ_m_2010_14
				nPctEmployedSales_m_2010_14 nPctEmployedNatRes_m_2010_14 nPctEmployedProd_m_2010_14
				nPctOwnerOccupiedHU_m_2010_14
				;

				do q=1 to 45; 

				   
						newvars_e{q}=oldvars_e{q}/100;
						newvars_m{q}=oldvars_m{q}/100;
					
					if oldvars_e{q}=.n then newvars_e{q}=.n;
					if oldvars_e{q}=.s then newvars_e{q}=.s;
					if oldvars_m{q}=.n then newvars_m{q}=.n;
					if oldvars_m{q}=.s then newvars_m{q}=.s;

				end;

	*Create and convert arrays for foreign born gaps.;

			array oldgapsn {7}
			  	Gap25andOverWoutHSFB_2010_14 Gap25andOverWoutHSNB_2010_14
				Gap25andOverWHSFB_2010_14 Gap25andOverWHSNB_2010_14 
				Gap25andOverWSCFB_2010_14 Gap25andOverWSCNB_2010_14
				GapPoorPersonsFB_2010_14
				;

			array newgapsn {7} 
			  	nGap25andOverWoutHSFB_2010_14 nGap25andOverWoutHSNB_2010_14
				nGap25andOverWHSFB_2010_14 nGap25andOverWHSNB_2010_14 
				nGap25andOverWSCFB_2010_14 nGap25andOverWSCNB_2010_14
				nGapPoorPersonsFB_2010_14
				;

				do d=1 to 7; 

					newgapsn{d}=oldgapsn{d};
	
					if oldgapsn{d}=.n then newgapsn{d}=.n;
					if oldgapsn{d}=.s then newgapsn{d}=.s;

				end;


*Create and convert arrays for by-race variable estimates, MOEs, and gaps from percent to decimal format. 
Arrays list existing variables in percent format and new arrays will be in decimal format;

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

			array oldvarsr_e&race. {27}
				PctAlone&race._2010_14 PctForeignBorn&race._2010_14
				PctPopUnder18Years&race._2010_14 PctPop18_34Years&race._2010_14 
				PctPop35_64Years&race._2010_14 PctPop65andOverYears&race._2010_14 
				Pct25andOverWoutHS&race._2010_14 Pct25andOverWHS&race._2010_14
				Pct25andOverWSC&race._2010_14 AvgHshldIncAdj&race._2010_14
				PctFamilyGT200000&race._2010_14 PctFamilyLT75000&race._2010_14
				PctPoorPersons&race._2010_14 PctPoorChildren&race._2010_14
				Pct16andOverEmploy&race._2010_14 PctEmployed16to64&race._2010_14
				PctUnemployed&race._2010_14 Pct16andOverWages&race._2010_14
				Pct16andOverWorkFT&race._2010_14 PctWorkFTLT35k&race._2010_14
				PctWorkFTLT75k&race._2010_14 PctEmployedMngmt&race._2010_14
				PctEmployedServ&race._2010_14 PctEmployedSales&race._2010_14
				PctEmployedNatRes&race._2010_14 PctEmployedProd&race._2010_14
				PctOwnerOccupiedHU&race._2010_14
				;

			array oldvarsr_m&race. {27}
				PctAlone&race._m_2010_14 PctForeignBorn&race._m_2010_14 
				PctPopUnder18Years&race._m_2010_14 PctPop18_34Years&race._m_2010_14
				PctPop35_64Years&race._m_2010_14 PctPop65andOverYrs&race._m_2010_14
				Pct25andOverWoutHS&race._m_2010_14 Pct25andOverWHS&race._m_2010_14
				Pct25andOverWSC&race._m_2010_14 AvgHshldIncAdj&race._m_2010_14
				PctFamilyGT200000&race._m_2010_14 PctFamilyLT75000&race._m_2010_14
				PctPoorPersons&race._m_2010_14 PctPoorChildren&race._m_2010_14
				Pct16andOverEmploy&race._m_2010_14 PctEmployed16to64&race._m_2010_14
				PctUnemployed&race._m_2010_14 Pct16andOverWages&race._m_2010_14
				Pct16andOverWorkFT&race._m_2010_14 PctWorkFTLT35k&race._m_2010_14
				PctWorkFTLT75k&race._m_2010_14 PctEmployedMngmt&race._m_2010_14
				PctEmployedServ&race._m_2010_14 PctEmployedSales&race._m_2010_14
				PctEmployedNatRes&race._m_2010_14 PctEmployedProd&race._m_2010_14
				PctOwnerOccupiedHU&race._m_2010_14
				;

			array newvarsr_e&race. {27}
				nPctAlone&race._2010_14 nPctForeignBorn&race._2010_14
				nPctPopUnder18Years&race._2010_14 nPctPop18_34Years&race._2010_14 
				nPctPop35_64Years&race._2010_14 nPctPop65andOverYrs&race._2010_14 
				nPct25andOverWoutHS&race._2010_14 nPct25andOverWHS&race._2010_14
				nPct25andOverWSC&race._2010_14 nAvgHshldIncAdj&race._2010_14
				nPctFamilyGT200000&race._2010_14 nPctFamilyLT75000&race._2010_14
				nPctPoorPersons&race._2010_14 nPctPoorChildren&race._2010_14
				nPct16andOverEmploy&race._2010_14 nPctEmployed16to64&race._2010_14
				nPctUnemployed&race._2010_14 nPct16andOverWages&race._2010_14
				nPct16andOverWorkFT&race._2010_14 nPctWorkFTLT35k&race._2010_14
				nPctWorkFTLT75k&race._2010_14 nPctEmployedMngmt&race._2010_14
				nPctEmployedServ&race._2010_14 nPctEmployedSales&race._2010_14
				nPctEmployedNatRes&race._2010_14 nPctEmployedProd&race._2010_14
				nPctOwnerOccupiedHU&race._2010_14
				;

		*Note that the following original MOE vars have been renamed as follows to keep character count at 32 or below:
		PctPopUnder18Years&race_m_2010_14 = nPctPopUnder18Yrs&race._m_2010_14.
		Pct25andOverWoutHS&race._m_2010_14 = nPct25andOvrWoutHS&race._m_2010_14.
		PctOwnerOccupiedHU&race._m_2010_14 = nctOwnerOccpiedHU&race._m_2010_14
 		Pct16andOverEmploy&race._m_2010_14= nPct16andOverEmply&race._m_2010_14
		;

			array newvarsr_m&race. {27}
				nPctAlone&race._m_2010_14 nPctForeignBorn&race._m_2010_14 
				nPctPopUnder18Yrs&race._m_2010_14 nPctPop18_34Years&race._m_2010_14
				nPctPop35_64Years&race._m_2010_14 nPctPop65andOvrYrs&race._m_2010_14
				nPct25andOvrWoutHS&race._m_2010_14 nPct25andOverWHS&race._m_2010_14
				nPct25andOverWSC&race._m_2010_14 nAvgHshldIncAdj&race._m_2010_14
				nPctFamilyGT200000&race._m_2010_14 nPctFamilyLT75000&race._m_2010_14
				nPctPoorPersons&race._m_2010_14 nPctPoorChildren&race._m_2010_14
				nPct16andOverEmply&race._m_2010_14 nPctEmployed16to64&race._m_2010_14
				nPctUnemployed&race._m_2010_14 nPct16andOverWages&race._m_2010_14
				nPct16andOverWrkFT&race._m_2010_14 nPctWorkFTLT35k&race._m_2010_14
				nPctWorkFTLT75k&race._m_2010_14 nPctEmployedMngmt&race._m_2010_14
				nPctEmployedServ&race._m_2010_14 nPctEmployedSales&race._m_2010_14
				nPctEmployedNatRes&race._m_2010_14 nPctEmployedProd&race._m_2010_14
				nPctOwnerOccpiedHU&race._m_2010_14
				;

			array oldgaps&race. {27}
				GapAlone&race._2010_14 GapForeignBorn&race._2010_14 
				GapPopUnder18Years&race._2010_14 GapPop18_34Years&race._2010_14
				GapPop35_64Years&race._2010_14 GapPop65andOvrYrs&race._2010_14
				Gap25andOverWoutHS&race._2010_14 Gap25andOverWHS&race._2010_14
				Gap25andOverWSC&race._2010_14 GapAvgHshldIncAdj&race._2010_14
				GapFamilyGT200000&race._2010_14 GapFamilyLT75000&race._2010_14
				GapPoorPersons&race._2010_14 GapPoorChildren&race._2010_14
				Gap16andOverEmploy&race._2010_14 GapEmployed16to64&race._2010_14
				GapUnemployed&race._2010_14 Gap16andOverWages&race._2010_14
				Gap16andOverWorkFT&race._2010_14 GapWorkFTLT35k&race._2010_14
				GapWorkFTLT75k&race._2010_14 GapEmployedMngmt&race._2010_14
				GapEmployedServ&race._2010_14 GapEmployedSales&race._2010_14
				GapEmployedNatRes&race._2010_14 GapEmployedProd&race._2010_14
				GapOwnerOccupiedHU&race._2010_14
				;

			array newgaps&race. {27}
				nGapAlone&race._2010_14 nGapForeignBorn&race._2010_14 
				nGapPopUnder18Years&race._2010_14 nGapPop18_34Years&race._2010_14
				nGapPop35_64Years&race._2010_14 nGapPop65andOvrYrs&race._2010_14
				nGap25andOverWoutHS&race._2010_14 nGap25andOverWHS&race._2010_14
				nGap25andOverWSC&race._2010_14 nGapAvgHshldIncAdj&race._2010_14
				nGapFamilyGT200000&race._2010_14 nGapFamilyLT75000&race._2010_14
				nGapPoorPersons&race._2010_14 nGapPoorChildren&race._2010_14
				nGap16andOverEmploy&race._2010_14 nGapEmployed16to64&race._2010_14
				nGapUnemployed&race._2010_14 nGap16andOverWages&race._2010_14
				nGap16andOverWorkFT&race._2010_14 nGapWorkFTLT35k&race._2010_14
				nGapWorkFTLT75k&race._2010_14 nGapEmployedMngmt&race._2010_14
				nGapEmployedServ&race._2010_14 nGapEmployedSales&race._2010_14
				nGapEmployedNatRes&race._2010_14 nGapEmployedProd&race._2010_14
				nGapOwnerOccupiedHU&race._2010_14
				;

				do b=1 to 27; 
		   
				*conversion from percent to decimal and importing variable suppression from suppress gaps and suppress vars progs;

					newvarsr_e&race.{b}=oldvarsr_e&race.{b}/100;
					newvarsr_m&race.{b}=oldvarsr_m&race.{b}/100;
					newgaps&race.{b}=oldgaps&race.{b};

					if oldvarsr_e&race.{b}=.n then newvarsr_e&race.{b}=.n;
					if oldvarsr_e&race.{b}=.s then newvarsr_e&race.{b}=.s;
					if oldvarsr_m&race.{b}=.n then newvarsr_m&race.{b}=.n;
					if oldvarsr_m&race.{b}=.s then newvarsr_m&race.{b}=.s;
					if oldgaps&race.{b}=.n then newgaps&race.{b}=.n;
					if oldgaps&race.{b}=.s then newgaps&race.{b}=.s;

				end;
	%end;


%mend decimal_convert;
