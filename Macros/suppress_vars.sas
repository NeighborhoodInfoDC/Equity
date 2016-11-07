/**************************************************************************
 Program:  suppress_vars.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses by-race variable estimates and MOEs 
			   where coefficient of variation is greater than 30%
**************************************************************************/


%macro suppress_vars;

%do r=1 %to 4;

	%let race=%scan(&racelist.,&r.," ");
	%let name=%scan(&racename.,&r.," ");

		array e_est&race. {21} 
			Pct25andOverWoutHS&race._2010_14
			Pct25andOverWHS&race._2010_14
			Pct25andOverWSC&race._2010_14
			AvgHshldIncAdj&race._2010_14
			PctFamilyGT200000&race._2010_14
			PctFamilyLT75000&race._2010_14
			PctPoorPersons&race._2010_14
			PctPoorChildren&race._2010_14
			Pct16andOverEmploy&race._2010_14
			PctEmployed16to64&race._2010_14
			PctUnemployed&race._2010_14
			Pct16andOverWages&race._2010_14
			Pct16andOverWorkFT&race._2010_14
			PctWorkFTLT35k&race._2010_14
			PctWorkFTLT75k&race._2010_14
			PctEmployedMngmt&race._2010_14
			PctEmployedServ&race._2010_14
			PctEmployedSales&race._2010_14
			PctEmployedNatRes&race._2010_14
			PctEmployedProd&race._2010_14
			PctOwnerOccupiedHU&race._2010_14
			;

		array e_moe&race. {21} 	
			Pct25andOverWoutHS&race._m_2010_14
			Pct25andOverWHS&race._m_2010_14
			Pct25andOverWSC&race._m_2010_14
			AvgHshldIncAdj&race._m_2010_14
			PctFamilyGT200000&race._m_2010_14
			PctFamilyLT75000&race._m_2010_14
			PctPoorPersons&race._m_2010_14
			PctPoorChildren&race._m_2010_14
			Pct16andOverEmploy&race._m_2010_14
			PctEmployed16to64&race._m_2010_14
			PctUnemployed&race._m_2010_14
			Pct16andOverWages&race._m_2010_14
			Pct16andOverWorkFT&race._m_2010_14
			PctWorkFTLT35k&race._m_2010_14
			PctWorkFTLT75k&race._m_2010_14
			PctEmployedMngmt&race._m_2010_14
			PctEmployedServ&race._m_2010_14
			PctEmployedSales&race._m_2010_14
			PctEmployedNatRes&race._m_2010_14
			PctEmployedProd&race._m_2010_14
			PctOwnerOccupiedHU&race._m_2010_14
			;

		array e_cv&race. {21} 
			cvPct25andOverWoutHS&race._2010_14
			cvPct25andOverWHS&race._2010_14
			cvPct25andOverWSC&race._2010_14
			cvAvgHshldIncAdj&race._2010_14
			cvPctFamilyGT200000&race._2010_14
			cvPctFamilyLT75000&race._2010_14
			cvPctPoorPersons&race._2010_14
			cvPctPoorChildren&race._2010_14
			cvPct16andOverEmploy&race._2010_14
			cvPctEmployed16to64&race._2010_14
			cvPctUnemployed&race._2010_14
			cvPct16andOverWages&race._2010_14
			cvPct16andOverWorkFT&race._2010_14
			cvPctWorkFTLT35k&race._2010_14
			cvPctWorkFTLT75k&race._2010_14
			cvPctEmployedMngmt&race._2010_14
			cvPctEmployedServ&race._2010_14
			cvPctEmployedSales&race._2010_14
			cvPctEmployedNatRes&race._2010_14
			cvPctEmployedProd&race._2010_14
			cvPctOwnerOccupiedHU&race._2010_14
			;

		array e_upper&race. {21} 		
			uPct25andOverWoutHS&race._2010_14
			uPct25andOverWHS&race._2010_14
			uPct25andOverWSC&race._2010_14
			uAvgHshldIncAdj&race._2010_14
			uPctFamilyGT200000&race._2010_14
			uPctFamilyLT75000&race._2010_14
			uPctPoorPersons&race._2010_14
			uPctPoorChildren&race._2010_14
			uPct16andOverEmploy&race._2010_14
			uPctEmployed16to64&race._2010_14
			uPctUnemployed&race._2010_14
			uPct16andOverWages&race._2010_14
			uPct16andOverWorkFT&race._2010_14
			uPctWorkFTLT35k&race._2010_14
			uPctWorkFTLT75k&race._2010_14
			uPctEmployedMngmt&race._2010_14
			uPctEmployedServ&race._2010_14
			uPctEmployedSales&race._2010_14
			uPctEmployedNatRes&race._2010_14
			uPctEmployedProd&race._2010_14
			uPctOwnerOccupiedHU&race._2010_14
			;

		array e_lower&race. {21} 		
			lPct25andOverWoutHS&race._2010_14
			lPct25andOverWHS&race._2010_14
			lPct25andOverWSC&race._2010_14
			lAvgHshldIncAdj&race._2010_14
			lPctFamilyGT200000&race._2010_14
			lPctFamilyLT75000&race._2010_14
			lPctPoorPersons&race._2010_14
			lPctPoorChildren&race._2010_14
			lPct16andOverEmploy&race._2010_14
			lPctEmployed16to64&race._2010_14
			lPctUnemployed&race._2010_14
			lPct16andOverWages&race._2010_14
			lPct16andOverWorkFT&race._2010_14
			lPctWorkFTLT35k&race._2010_14
			lPctWorkFTLT75k&race._2010_14
			lPctEmployedMngmt&race._2010_14
			lPctEmployedServ&race._2010_14
			lPctEmployedSales&race._2010_14
			lPctEmployedNatRes&race._2010_14
			lPctEmployedProd&race._2010_14
			lPctOwnerOccupiedHU&race._2010_14
			;

	  	do k=1 to 21; 
	   
	                e_cv&race.{k}=e_moe&race.{k}/1.645/e_est&race.{k}*100;
	                e_lower&race.{k}=e_est&race.{k}- e_moe&race.{k};
	                e_upper&race.{k}=e_est&race.{k}+ e_moe&race.{k};
					

	                *code to suppress if cv > 30;
	                if e_cv&race.{k} > 30 then do; e_est&race.{k}=.s; e_moe&race.{k}=.s;
	                end;

		end;

%end;
%mend suppress_vars;
