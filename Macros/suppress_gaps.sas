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
				cPct25andOverWoutHSW_2010_14
				cPct25andOverWHSW_2010_14
				cPct25andOverWSCW_2010_14
				cAvgHshldIncAdjW_2010_14
				cPctFamilyGT200000W_2010_14 
				cPctFamilyLT75000W_2010_14
				cPctPoorPersonsW_2010_14 
				cPctPoorChildrenW_2010_14
				cPct16andOverEmployW_2010_14
				cPctEmployed16to64W_2010_14
				cPctUnemployedW_2010_14
				cPct16andOverWagesW_2010_14
				cPct16andOverWorkFTW_2010_14
				cPctWorkFTLT35kW_2010_14
				cPctWorkFTLT75kW_2010_14
				cPctEmployedMngmtW_2010_14
				cPctEmployedServW_2010_14
				cPctEmployedSalesW_2010_14
				cPctEmployedNatResW_2010_14
				cPctEmployedProdW_2010_14
				cPctOwnerOccupiedHUW_2010_14
				;

			*CITY white MOE; 

			array w_moe{21} 	
				cPct25andOverWoutHSW_m_2010_14
				cPct25andOverWHSW_m_2010_14
				cPct25andOverWSCW_m_2010_14
				cAvgHshldIncAdjW_m_2010_14
				cPctFamilyGT200000W_m_2010_14
				cPctFamilyLT75000W_m_2010_14
				cPctPoorPersonsW_m_2010_14
				cPctPoorChildrenW_m_2010_14
				cPct16andOverEmployW_m_2010_14
				cPctEmployed16to64W_m_2010_14
				cPctUnemployedW_m_2010_14
				cPct16andOverWagesW_m_2010_14
				cPct16andOverWorkFTW_m_2010_14
				cPctWorkFTLT35kW_m_2010_14
				cPctWorkFTLT75kW_m_2010_14
				cPctEmployedMngmtW_m_2010_14
				cPctEmployedServW_m_2010_14
				cPctEmployedSalesW_m_2010_14
				cPctEmployedNatResW_m_2010_14
				cPctEmployedProdW_m_2010_14
				cPctOwnerOccupiedHUW_m_2010_14
				;

				*cv white MOE; 

			array w_cv{21} 
				ctycvPct25andOverWoutHSW_2010_14
				ctycvPct25andOverWHSW_2010_14
				ctycvPct25andOverWSCW_2010_14
				ctycvAvgHshldIncAdjW_2010_14
				ctycvPctFamilyGT200000W_2010_14
				ctycvPctFamilyLT75000W_2010_14
				ctycvPctPoorPersonsW_2010_14
				ctycvPctPoorChildrenW_2010_14
				ctycvPct16andOverEmployW_2010_14
				ctycvPctEmployed16to64W_2010_14
				ctycvPctUnemployedW_2010_14
				ctycvPct16andOverWagesW_2010_14
				ctycvPct16andOverWorkFTW_2010_14
				ctycvPctWorkFTLT35kW_2010_14
				ctycvPctWorkFTLT75kW_2010_14
				ctycvPctEmployedMngmtW_2010_14
				ctycvPctEmployedServW_2010_14
				ctycvPctEmployedSalesW_2010_14
				ctycvPctEmployedNatResW_2010_14
				ctycvPctEmployedProdW_2010_14
				ctycvPctOwnerOccupiedHUW_2010_14
				;

				*white upper bound;
			array w_upper{21} 		
				ctyuPct25andOverWoutHSW_2010_14
				ctyuPct25andOverWHSW_2010_14
				ctyuPct25andOverWSCW_2010_14
				ctyuAvgHshldIncAdjW_2010_14
				ctyuPctFamilyGT200000W_2010_14
				ctyuPctFamilyLT75000W_2010_14
				ctyuPctPoorPersonsW_2010_14
				ctyuPctPoorChildrenW_2010_14
				ctyuPct16andOverEmployW_2010_14
				ctyuPctEmployed16to64W_2010_14
				ctyuPctUnemployedW_2010_14
				ctyuPct16andOverWagesW_2010_14
				ctyuPct16andOverWorkFTW_2010_14
				ctyuPctWorkFTLT35kW_2010_14
				ctyuPctWorkFTLT75kW_2010_14
				ctyuPctEmployedMngmtW_2010_14
				ctyuPctEmployedServW_2010_14
				ctyuPctEmployedSalesW_2010_14
				ctyuPctEmployedNatResW_2010_14
				ctyuPctEmployedProdW_2010_14
				ctyuPctOwnerOccupiedHUW_2010_14
				;

				*white lower bound; 

			array w_lower{21} 		
				ctylPct25andOverWoutHSW_2010_14
				ctylPct25andOverWHSW_2010_14
				ctylPct25andOverWSCW_2010_14
				ctylAvgHshldIncAdjW_2010_14
				ctylPctFamilyGT200000W_2010_14
				ctylPctFamilyLT75000W_2010_14
				ctylPctPoorPersonsW_2010_14
				ctylPctPoorChildrenW_2010_14
				ctylPct16andOverEmployW_2010_14
				ctylPctEmployed16to64W_2010_14
				ctylPctUnemployedW_2010_14
				ctylPct16andOverWagesW_2010_14
				ctylPct16andOverWorkFTW_2010_14
				ctylPctWorkFTLT35kW_2010_14
				ctylPctWorkFTLT75kW_2010_14
				ctylPctEmployedMngmtW_2010_14
				ctylPctEmployedServW_2010_14
				ctylPctEmployedSalesW_2010_14
				ctylPctEmployedNatResW_2010_14
				ctylPctEmployedProdW_2010_14
				ctylPctOwnerOccupiedHUW_2010_14
				;

				  	do m=1 to 21; 
		   
		                w_cv{m}=w_moe{m}/1.645/w_est{m}*100;
		                w_lower{m}=w_est{m}- w_moe{m};
		                w_upper{m}=w_est{m}+ w_moe{m};
		          
		                if w_cv{m} > 30 then do; 
						w_est{m}=.s; w_moe{m}=.s; 
						end; 

					end;

		%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

				*gap race; 
			array e_gap&race. {21} 
				Gap25andOverWoutHS&race._2010_14
				Gap25andOverWHS&race._2010_14
				Gap25andOverWSC&race._2010_14
				GapAvgHshldIncAdj&race._2010_14
				GapFamilyGT200000&race._2010_14
				GapFamilyLT75000&race._2010_14
				GapPoorPersons&race._2010_14
				GapPoorChildren&race._2010_14
				Gap16andOverEmploy&race._2010_14
				GapEmployed16to64&race._2010_14
				GapUnemployed&race._2010_14
				Gap16andOverWages&race._2010_14
				Gap16andOverWorkFT&race._2010_14
				GapWorkFTLT35k&race._2010_14
				GapWorkFTLT75k&race._2010_14
				GapEmployedMngmt&race._2010_14
				GapEmployedServ&race._2010_14
				GapEmployedSales&race._2010_14
				GapEmployedNatRes&race._2010_14
				GapEmployedProd&race._2010_14
				GapOwnerOccupiedHU&race._2010_14
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
