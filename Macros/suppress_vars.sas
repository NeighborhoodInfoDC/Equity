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

%do r=1 %to 5;

	%let race=%scan(&racelist.,&r.," ");
	%let name=%scan(&racename.,&r.," ");

		array e_est&race. {23} 
			Pct25andOverWoutHS&race._&_years.
			Pct25andOverWHS&race._&_years.
			Pct25andOverWSC&race._&_years.
			AvgHshldIncAdj&race._&_years.
			PctFamilyGT200000&race._&_years.
			PctFamilyLT75000&race._&_years.
			PctPoorPersons&race._&_years.
			PctPoorChildren&race._&_years.
			Pct16andOverEmploy&race._&_years.
			PctEmployed16to64&race._&_years.
			PctUnemployed&race._&_years.
			Pct16andOverWages&race._&_years.
			Pct16andOverWorkFT&race._&_years.
			PctWorkFTLT35k&race._&_years.
			PctWorkFTLT75k&race._&_years.
			PctEmployedMngmt&race._&_years.
			PctEmployedServ&race._&_years.
			PctEmployedSales&race._&_years.
			PctEmployedNatRes&race._&_years.
			PctEmployedProd&race._&_years.
			PctOwnerOccupiedHU&race._&_years.
			PctMovedLastYear&race._&_years.
			PctMovedDiffCnty&race._&_years.
			;

		array e_moe&race. {23} 	
			Pct25andOverWoutHS&race._m_&_years.
			Pct25andOverWHS&race._m_&_years.
			Pct25andOverWSC&race._m_&_years.
			AvgHshldIncAdj&race._m_&_years.
			PctFamilyGT200000&race._m_&_years.
			PctFamilyLT75000&race._m_&_years.
			PctPoorPersons&race._m_&_years.
			PctPoorChildren&race._m_&_years.
			Pct16andOverEmploy&race._m_&_years.
			PctEmployed16to64&race._m_&_years.
			PctUnemployed&race._m_&_years.
			Pct16andOverWages&race._m_&_years.
			Pct16andOverWorkFT&race._m_&_years.
			PctWorkFTLT35k&race._m_&_years.
			PctWorkFTLT75k&race._m_&_years.
			PctEmployedMngmt&race._m_&_years.
			PctEmployedServ&race._m_&_years.
			PctEmployedSales&race._m_&_years.
			PctEmployedNatRes&race._m_&_years.
			PctEmployedProd&race._m_&_years.
			PctOwnerOccupiedHU&race._m_&_years.
			PctMovedLastYear&race._m_&_years.
			PctMovedDiffCnty&race._m_&_years.
			;

		array e_cv&race. {23} 
			cvPct25andOverWoutHS&race._&_years.
			cvPct25andOverWHS&race._&_years.
			cvPct25andOverWSC&race._&_years.
			cvAvgHshldIncAdj&race._&_years.
			cvPctFamilyGT200000&race._&_years.
			cvPctFamilyLT75000&race._&_years.
			cvPctPoorPersons&race._&_years.
			cvPctPoorChildren&race._&_years.
			cvPct16andOverEmploy&race._&_years.
			cvPctEmployed16to64&race._&_years.
			cvPctUnemployed&race._&_years.
			cvPct16andOverWages&race._&_years.
			cvPct16andOverWorkFT&race._&_years.
			cvPctWorkFTLT35k&race._&_years.
			cvPctWorkFTLT75k&race._&_years.
			cvPctEmployedMngmt&race._&_years.
			cvPctEmployedServ&race._&_years.
			cvPctEmployedSales&race._&_years.
			cvPctEmployedNatRes&race._&_years.
			cvPctEmployedProd&race._&_years.
			cvPctOwnerOccupiedHU&race._&_years.
			cvPctMovedLastYear&race._&_years.
			cvPctMovedDiffCnty&race._&_years.
			;

		array e_upper&race. {23} 		
			uPct25andOverWoutHS&race._&_years.
			uPct25andOverWHS&race._&_years.
			uPct25andOverWSC&race._&_years.
			uAvgHshldIncAdj&race._&_years.
			uPctFamilyGT200000&race._&_years.
			uPctFamilyLT75000&race._&_years.
			uPctPoorPersons&race._&_years.
			uPctPoorChildren&race._&_years.
			uPct16andOverEmploy&race._&_years.
			uPctEmployed16to64&race._&_years.
			uPctUnemployed&race._&_years.
			uPct16andOverWages&race._&_years.
			uPct16andOverWorkFT&race._&_years.
			uPctWorkFTLT35k&race._&_years.
			uPctWorkFTLT75k&race._&_years.
			uPctEmployedMngmt&race._&_years.
			uPctEmployedServ&race._&_years.
			uPctEmployedSales&race._&_years.
			uPctEmployedNatRes&race._&_years.
			uPctEmployedProd&race._&_years.
			uPctOwnerOccupiedHU&race._&_years.
			uPctMovedLastYear&race._&_years.
			uPctMovedDiffCnty&race._&_years.
			;

		array e_lower&race. {23} 		
			lPct25andOverWoutHS&race._&_years.
			lPct25andOverWHS&race._&_years.
			lPct25andOverWSC&race._&_years.
			lAvgHshldIncAdj&race._&_years.
			lPctFamilyGT200000&race._&_years.
			lPctFamilyLT75000&race._&_years.
			lPctPoorPersons&race._&_years.
			lPctPoorChildren&race._&_years.
			lPct16andOverEmploy&race._&_years.
			lPctEmployed16to64&race._&_years.
			lPctUnemployed&race._&_years.
			lPct16andOverWages&race._&_years.
			lPct16andOverWorkFT&race._&_years.
			lPctWorkFTLT35k&race._&_years.
			lPctWorkFTLT75k&race._&_years.
			lPctEmployedMngmt&race._&_years.
			lPctEmployedServ&race._&_years.
			lPctEmployedSales&race._&_years.
			lPctEmployedNatRes&race._&_years.
			lPctEmployedProd&race._&_years.
			lPctOwnerOccupiedHU&race._&_years.
			lPctMovedLastYear&race._&_years.
			lPctMovedDiffCnty&race._&_years.
			;

	  	do k=1 to 23; 
	   
	                e_cv&race.{k}=e_moe&race.{k}/1.645/e_est&race.{k}*100;
	                e_lower&race.{k}=e_est&race.{k}- e_moe&race.{k};
	                e_upper&race.{k}=e_est&race.{k}+ e_moe&race.{k};
					

	                *code to suppress if cv > 30;
	                if e_cv&race.{k} > 30 then do; e_est&race.{k}=.s; e_moe&race.{k}=.s;
	                end;

		end;

%end;
%mend suppress_vars;


