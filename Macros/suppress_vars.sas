/**************************************************************************
 Program:  suppress_vars.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses by-race variable estimates and MOEs 
			   where coefficient of variation is greater than 30%
			   
Modifications : LH 02/24/22 Update for 6 race categories
				YS 08/10/22 Update for new gender breakout variables
**************************************************************************/


%macro suppress_vars;

%do r=1 %to 6;

	%let race=%scan(&racelist.,&r.," ");
	%let name=%scan(&racename.,&r.," ");

		array e_est&race. {47} 
			Pct25andOverWoutHS&race._&_years.
			Pct25andOverWHS&race._&_years.
			Pct25andOverWSC&race._&_years.
			AvgHshldIncAdj&race._&_years.
			PctFamilyGT200000&race._&_years.
			PctFamilyLT75000&race._&_years.
			PctPoorPersons&race._&_years.
			PctPoorChildren&race._&_years.
			Pct16plusEmploy&race._&_years.
			PctEmp16to64&race._&_years.
			PctUnemployed&race._&_years.
			Pct16plusWages&race._&_years.
			Pct16plusWorkFT&race._&_years.
			PctWorkFTLT35k&race._&_years.
			PctWorkFTLT75k&race._&_years.
			PctEmpMngmt&race._&_years.
			PctEmpServ&race._&_years.
			PctEmpSales&race._&_years.
			PctEmpNatRes&race._&_years.
			PctEmpProd&race._&_years.
			PctOwnerOccupiedHU&race._&_years.
			PctMovedLastYear&race._&_years.
			PctMovedDiffCnty&race._&_years.
			Pct16plusEmploy&race._ML_&_years.
			Pct16plusEmploy&race._F_&_years.
			PctEmp16to64&race._ML_&_years.
			PctEmp16to64&race._F_&_years.
			PctWorkFTLT75k&race._ML_&_years.
			PctWorkFTLT75k&race._F_&_years.
			PctWorkFTLT35k&race._ML_&_years.
			PctWorkFTLT35k&race._F_&_years.
			Pct16plusWorkFT&race._ML_&_years.
			Pct16plusWorkFT&race._F_&_years.
			Pct16plusWages&race._ML_&_years.
			Pct16plusWages&race._F_&_years.
			PctUnemployed&race._ML_&_years.
			PctUnemployed&race._F_&_years.
			PctEmpMngmt&race._ML_&_years.
			PctEmpServ&race._ML_&_years.
			PctEmpSales&race._ML_&_years.
			PctEmpNatRes&race._ML_&_years.
			PctEmpProd&race._ML_&_years.
			PctEmpMngmt&race._F_&_years.
			PctEmpServ&race._F_&_years.
			PctEmpSales&race._F_&_years.
			PctEmpNatRes&race._F_&_years.
			PctEmpProd&race._F_&_years.

			;

		array e_moe&race. {47} 	
			Pct25andOverWoutHS&race._m_&_years.
			Pct25andOverWHS&race._m_&_years.
			Pct25andOverWSC&race._m_&_years.
			AvgHshldIncAdj&race._m_&_years.
			PctFamilyGT200000&race._m_&_years.
			PctFamilyLT75000&race._m_&_years.
			PctPoorPersons&race._m_&_years.
			PctPoorChildren&race._m_&_years.
			Pct16plusEmploy&race._m_&_years.
			PctEmp16to64&race._m_&_years.
			PctUnemployed&race._m_&_years.
			Pct16plusWages&race._m_&_years.
			Pct16plusWorkFT&race._m_&_years.
			PctWorkFTLT35k&race._m_&_years.
			PctWorkFTLT75k&race._m_&_years.
			PctEmpMngmt&race._m_&_years.
			PctEmpServ&race._m_&_years.
			PctEmpSales&race._m_&_years.
			PctEmpNatRes&race._m_&_years.
			PctEmpProd&race._m_&_years.
			PctOwnerOccupiedHU&race._m_&_years.
			PctMovedLastYear&race._m_&_years.
			PctMovedDiffCnty&race._m_&_years.
			Pct16plusEmploy&race._ML_m_&_years.
			Pct16plusEmploy&race._F_m_&_years.
            PctEmp16to64&race._ML_m_&_years.
			PctEmp16to64&race._F_m_&_years.
			PctWorkFTLT75k&race._ML_m_&_years.
			PctWorkFTLT75k&race._F_m_&_years.
			PctWorkFTLT35k&race._ML_m_&_years.
			PctWorkFTLT35k&race._F_m_&_years.
			Pct16plusWorkFT&race._ML_m_&_years.
			Pct16plusWorkFT&race._F_m_&_years.
			Pct16plusWages&race._ML_m_&_years.
			Pct16plusWages&race._F_m_&_years.
			PctUnemployed&race._ML_m_&_years.
			PctUnemployed&race._F_m_&_years.
			PctEmpMngmt&race._ML_m_&_years.
			PctEmpServ&race._ML_m_&_years.
			PctEmpSales&race._ML_m_&_years.
			PctEmpNatRes&race._ML_m_&_years.
			PctEmpProd&race._ML_m_&_years.
			PctEmpMngmt&race._F_m_&_years.
			PctEmpServ&race._F_m_&_years.
			PctEmpSales&race._F_m_&_years.
			PctEmpNatRes&race._F_m_&_years.
			PctEmpProd&race._F_m_&_years.
			;

		array e_cv&race. {47} 
			cvPct25andOverWoutHS&race._&_years.
			cvPct25andOverWHS&race._&_years.
			cvPct25andOverWSC&race._&_years.
			cvAvgHshldIncAdj&race._&_years.
			cvPctFamilyGT200000&race._&_years.
			cvPctFamilyLT75000&race._&_years.
			cvPctPoorPersons&race._&_years.
			cvPctPoorChildren&race._&_years.
			cvPct16plusEmploy&race._&_years.
			cvPctEmp16to64&race._&_years.
			cvPctUnemployed&race._&_years.
			cvPct16plusWages&race._&_years.
			cvPct16plusWorkFT&race._&_years.
			cvPctWorkFTLT35k&race._&_years.
			cvPctWorkFTLT75k&race._&_years.
			cvPctEmpMngmt&race._&_years.
			cvPctEmpServ&race._&_years.
			cvPctEmpSales&race._&_years.
			cvPctEmpNatRes&race._&_years.
			cvPctEmpProd&race._&_years.
			cvPctOwnerOccupiedHU&race._&_years.
			cvPctMovedLastYear&race._&_years.
			cvPctMovedDiffCnty&race._&_years.
			cvPct16plusEmploy&race._ML_&_years.
			cvPct16plusEmploy&race._F_&_years.
			cvPctEmp16to64&race._ML_&_years.
			cvPctEmp16to64&race._F_&_years.
			cvPctWorkFTLT75k&race._ML_&_years.
			cvPctWorkFTLT75k&race._F_&_years.
			cvPctWorkFTLT35k&race._ML_&_years.
			cvPctWorkFTLT35k&race._F_&_years.
			cvPct16plusWorkFT&race._ML_&_years.
			cvPct16plusWorkFT&race._F_&_years.
			cvPct16plusWages&race._ML_&_years.
			cvPct16plusWage&race._F_&_years.
			cvPctUnemployed&race._ML_&_years.
			cvPctUnemployed&race._F_&_years.
			cvPctEmpMngmt&race._ML_&_years.
			cvPctEmpServ&race._ML_&_years.
			cvPctEmpSales&race._ML_&_years.
			cvPctEmpNatRes&race._ML_&_years.
			cvPctEmpProd&race._ML_&_years.
			cvPctEmpMngmt&race._F_&_years.
			cvPctEmpServ&race._F_&_years.
			cvPctEmpSales&race._F_&_years.
			cvPctEmpNatRes&race._F_&_years.
			cvPctEmpProd&race._F_&_years.
			;

		array e_upper&race. {47} 		
			uPct25andOverWoutHS&race._&_years.
			uPct25andOverWHS&race._&_years.
			uPct25andOverWSC&race._&_years.
			uAvgHshldIncAdj&race._&_years.
			uPctFamilyGT200000&race._&_years.
			uPctFamilyLT75000&race._&_years.
			uPctPoorPersons&race._&_years.
			uPctPoorChildren&race._&_years.
			uPct16plusEmploy&race._&_years.
			uPctEmp16to64&race._&_years.
			uPctUnemployed&race._&_years.
			uPct16plusWages&race._&_years.
			uPct16plusWorkFT&race._&_years.
			uPctWorkFTLT35k&race._&_years.
			uPctWorkFTLT75k&race._&_years.
			uPctEmpMngmt&race._&_years.
			uPctEmpServ&race._&_years.
			uPctEmpSales&race._&_years.
			uPctEmpNatRes&race._&_years.
			uPctEmpProd&race._&_years.
			uPctOwnerOccupiedHU&race._&_years.
			uPctMovedLastYear&race._&_years.
			uPctMovedDiffCnty&race._&_years.
			uPct16plusEmploy&race._ML_&_years.
			uPct16plusEmploy&race._F_&_years.
			uPctEmp16to64&race._ML_&_years.
			uPctEmp16to64&race._F_&_years.
			uPctWorkFTLT75k&race._ML_&_years.
			uPctWorkFTLT75k&race._F_&_years.
			uPctWorkFTLT35k&race._ML_&_years.
			uPctWorkFTLT35k&race._F_&_years.
			uPct16plusWorkFT&race._ML_&_years.
			uPct16plusWorkFT&race._F_&_years.
			uPct16plusWages&race._ML_&_years.
			uPct16plusWages&race._F_&_years.
			uPctUnemployed&race._ML_&_years.
			uPctUnemployed&race._F_&_years.
			uPctEmpMngmt&race._ML_&_years.
			uPctEmpServ&race._ML_&_years.
			uPctEmpSales&race._ML_&_years.
			uPctEmpNatRes&race._ML_&_years.
			uPctEmpProd&race._ML_&_years.
			uPctEmpMngmt&race._F_&_years.
			uPctEmpServ&race._F_&_years.
			uPctEmpSales&race._F_&_years.
			uPctEmpNatRes&race._F_&_years.
			uPctEmpProd&race._F_&_years.
			;

		array e_lower&race. {47} 		
			lPct25andOverWoutHS&race._&_years.
			lPct25andOverWHS&race._&_years.
			lPct25andOverWSC&race._&_years.
			lAvgHshldIncAdj&race._&_years.
			lPctFamilyGT200000&race._&_years.
			lPctFamilyLT75000&race._&_years.
			lPctPoorPersons&race._&_years.
			lPctPoorChildren&race._&_years.
			lPct16plusEmploy&race._&_years.
			lPctEmp16to64&race._&_years.
			lPctUnemployed&race._&_years.
			lPct1plusWages&race._&_years.
			lPct16plusWorkFT&race._&_years.
			lPctWorkFTLT35k&race._&_years.
			lPctWorkFTLT75k&race._&_years.
			lPctEmpMngmt&race._&_years.
			lPctEmpServ&race._&_years.
			lPctEmpSales&race._&_years.
			lPctEmpNatRes&race._&_years.
			lPctEmpProd&race._&_years.
			lPctOwnerOccupiedHU&race._&_years.
			lPctMovedLastYear&race._&_years.
			lPctMovedDiffCnty&race._&_years.
			lPct16plusEmploy&race._ML_&_years.
			lPct16plusEmploy&race._F_&_years.
			lPctEmp16to64&race._ML_&_years.
			lPctEmp16to64&race._F_&_years.
			lPctWorkFTLT75k&race._ML_&_years.
			lPctWorkFTLT75k&race._F_&_years.
			lPctWorkFTLT35k&race._ML_&_years.
			lPctWorkFTLT35k&race._F_&_years.
			lPct16plusWorkFT&race._ML_&_years.
			lPct16plusWorkFT&race._F_&_years.
			lPct16plusWages&race._ML_&_years.
			lPct16plusWages&race._F_&_years.
			lPctUnemployed&race._ML_&_years.
			lPctUnemployed&race._F_&_years.
			lPctEmpMngmt&race._ML_&_years.
			lPctEmpServ&race._ML_&_years.
			lPctEmpSales&race._ML_&_years.
			lPctEmpNatRes&race._ML_&_years.
			lPctEmpProd&race._ML_&_years.
			lPctEmpMngmt&race._F_&_years.
			lPctEmpServ&race._F_&_years.
			lPctEmpSales&race._F_&_years.
			lPctEmpNatRes&race._F_&_years.
			lPctEmpProd&race._F_&_years.
			;

	  	do k=1 to 47; 

			if e_est&race.{k}=0 then do;
				e_est&race.{k}=.s;
				e_moe&race.{k}=.s;
			end;

			else do;
	   
	                e_cv&race.{k}=e_moe&race.{k}/1.645/e_est&race.{k}*100;
	                e_lower&race.{k}=e_est&race.{k}- e_moe&race.{k};
	                e_upper&race.{k}=e_est&race.{k}+ e_moe&race.{k};
					

	                *code to suppress if cv > 30;
	                if e_cv&race.{k} > 30 then do; e_est&race.{k}=.s; e_moe&race.{k}=.s;
	                end;

			end;

		end;

%end;
%mend suppress_vars;


