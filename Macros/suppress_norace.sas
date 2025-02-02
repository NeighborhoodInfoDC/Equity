/**************************************************************************
 Program:  suppress_norace.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   L. Hendey
 Created:  02/02/2025
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses  variable estimates and MOEs 
			   where coefficient of variation is greater than 30%
			   
		
**************************************************************************/


%macro suppress_norace; 

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

	%mend;
