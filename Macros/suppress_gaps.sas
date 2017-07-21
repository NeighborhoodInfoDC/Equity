/**************************************************************************
 Program:  suppress_gaps.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses racial gaps if not significantly different from white rates
			   and if estimates are suppressed (see suppress_vars.sas).
**************************************************************************/

%macro suppress_gaps;

	
		*CITY white estimates; 
			array w_est{21} 
				cPct25andOverWoutHSW_&_years.
				cPct25andOverWHSW_&_years.
				cPct25andOverWSCW_&_years.
				cAvgHshldIncAdjW_&_years.
				cPctFamilyGT200000W_&_years. 
				cPctFamilyLT75000W_&_years.
				cPctPoorPersonsW_&_years. 
				cPctPoorChildrenW_&_years.
				cPct16andOverEmployW_&_years.
				cPctEmployed16to64W_&_years.
				cPctUnemployedW_&_years.
				cPct16andOverWagesW_&_years.
				cPct16andOverWorkFTW_&_years.
				cPctWorkFTLT35kW_&_years.
				cPctWorkFTLT75kW_&_years.
				cPctEmployedMngmtW_&_years.
				cPctEmployedServW_&_years.
				cPctEmployedSalesW_&_years.
				cPctEmployedNatResW_&_years.
				cPctEmployedProdW_&_years.
				cPctOwnerOccupiedHUW_&_years.
				;

			*CITY white MOE; 

			array w_moe{21} 	
				cPct25andOverWoutHSW_m_&_years.
				cPct25andOverWHSW_m_&_years.
				cPct25andOverWSCW_m_&_years.
				cAvgHshldIncAdjW_m_&_years.
				cPctFamilyGT200000W_m_&_years.
				cPctFamilyLT75000W_m_&_years.
				cPctPoorPersonsW_m_&_years.
				cPctPoorChildrenW_m_&_years.
				cPct16andOverEmployW_m_&_years.
				cPctEmployed16to64W_m_&_years.
				cPctUnemployedW_m_&_years.
				cPct16andOverWagesW_m_&_years.
				cPct16andOverWorkFTW_m_&_years.
				cPctWorkFTLT35kW_m_&_years.
				cPctWorkFTLT75kW_m_&_years.
				cPctEmployedMngmtW_m_&_years.
				cPctEmployedServW_m_&_years.
				cPctEmployedSalesW_m_&_years.
				cPctEmployedNatResW_m_&_years.
				cPctEmployedProdW_m_&_years.
				cPctOwnerOccupiedHUW_m_&_years.
				;

				*cv white MOE; 

			array w_cv{21} 
				ctycvPct25andOverWoutHSW_&_years.
				ctycvPct25andOverWHSW_&_years.
				ctycvPct25andOverWSCW_&_years.
				ctycvAvgHshldIncAdjW_&_years.
				ctycvPctFamilyGT200000W_&_years.
				ctycvPctFamilyLT75000W_&_years.
				ctycvPctPoorPersonsW_&_years.
				ctycvPctPoorChildrenW_&_years.
				ctycvPct16andOverEmployW_&_years.
				ctycvPctEmployed16to64W_&_years.
				ctycvPctUnemployedW_&_years.
				ctycvPct16andOverWagesW_&_years.
				ctycvPct16andOverWorkFTW_&_years.
				ctycvPctWorkFTLT35kW_&_years.
				ctycvPctWorkFTLT75kW_&_years.
				ctycvPctEmployedMngmtW_&_years.
				ctycvPctEmployedServW_&_years.
				ctycvPctEmployedSalesW_&_years.
				ctycvPctEmployedNatResW_&_years.
				ctycvPctEmployedProdW_&_years.
				ctycvPctOwnerOccupiedHUW_&_years.
				;

				*white upper bound;
			array w_upper{21} 		
				ctyuPct25andOverWoutHSW_&_years.
				ctyuPct25andOverWHSW_&_years.
				ctyuPct25andOverWSCW_&_years.
				ctyuAvgHshldIncAdjW_&_years.
				ctyuPctFamilyGT200000W_&_years.
				ctyuPctFamilyLT75000W_&_years.
				ctyuPctPoorPersonsW_&_years.
				ctyuPctPoorChildrenW_&_years.
				ctyuPct16andOverEmployW_&_years.
				ctyuPctEmployed16to64W_&_years.
				ctyuPctUnemployedW_&_years.
				ctyuPct16andOverWagesW_&_years.
				ctyuPct16andOverWorkFTW_&_years.
				ctyuPctWorkFTLT35kW_&_years.
				ctyuPctWorkFTLT75kW_&_years.
				ctyuPctEmployedMngmtW_&_years.
				ctyuPctEmployedServW_&_years.
				ctyuPctEmployedSalesW_&_years.
				ctyuPctEmployedNatResW_&_years.
				ctyuPctEmployedProdW_&_years.
				ctyuPctOwnerOccupiedHUW_&_years.
				;

				*white lower bound; 

			array w_lower{21} 		
				ctylPct25andOverWoutHSW_&_years.
				ctylPct25andOverWHSW_&_years.
				ctylPct25andOverWSCW_&_years.
				ctylAvgHshldIncAdjW_&_years.
				ctylPctFamilyGT200000W_&_years.
				ctylPctFamilyLT75000W_&_years.
				ctylPctPoorPersonsW_&_years.
				ctylPctPoorChildrenW_&_years.
				ctylPct16andOverEmployW_&_years.
				ctylPctEmployed16to64W_&_years.
				ctylPctUnemployedW_&_years.
				ctylPct16andOverWagesW_&_years.
				ctylPct16andOverWorkFTW_&_years.
				ctylPctWorkFTLT35kW_&_years.
				ctylPctWorkFTLT75kW_&_years.
				ctylPctEmployedMngmtW_&_years.
				ctylPctEmployedServW_&_years.
				ctylPctEmployedSalesW_&_years.
				ctylPctEmployedNatResW_&_years.
				ctylPctEmployedProdW_&_years.
				ctylPctOwnerOccupiedHUW_&_years.
				;

				  	do m=1 to 21; 
		   
		                w_cv{m}=w_moe{m}/1.645/w_est{m}*100;
		                w_lower{m}=w_est{m}- w_moe{m};
		                w_upper{m}=w_est{m}+ w_moe{m};
		          
		                if w_cv{m} > 30 then do; 
						w_est{m}=.s; w_moe{m}=.s; 
						end; 

					end;

		%do r=1 %to 5;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

				*gap race; 
			array e_gap&race. {21} 
				Gap25andOverWoutHS&race._&_years.
				Gap25andOverWHS&race._&_years.
				Gap25andOverWSC&race._&_years.
				GapAvgHshldIncAdj&race._&_years.
				GapFamilyGT200000&race._&_years.
				GapFamilyLT75000&race._&_years.
				GapPoorPersons&race._&_years.
				GapPoorChildren&race._&_years.
				Gap16andOverEmploy&race._&_years.
				GapEmployed16to64&race._&_years.
				GapUnemployed&race._&_years.
				Gap16andOverWages&race._&_years.
				Gap16andOverWorkFT&race._&_years.
				GapWorkFTLT35k&race._&_years.
				GapWorkFTLT75k&race._&_years.
				GapEmployedMngmt&race._&_years.
				GapEmployedServ&race._&_years.
				GapEmployedSales&race._&_years.
				GapEmployedNatRes&race._&_years.
				GapEmployedProd&race._&_years.
				GapOwnerOccupiedHU&race._&_years.
				;

		 	do X=1 to 21; 
		 	*suppress gaps if not significantly different from white rates;  
						if e_upper&race.{X} < w_upper{X} and e_upper&race.{X} > w_lower{X} then e_gap&race.{X}=.n;
						if e_lower&race.{X} > w_lower{X} and e_lower&race.{X} < w_upper{X} then e_gap&race.{X}=.n;  

			 *suppress gaps where estimates are suppresed;
						if e_est&race.{X}=.s then e_gap&race.{X}=.s;
			end;
       
	%end;
					

	%mend suppress_gaps;
