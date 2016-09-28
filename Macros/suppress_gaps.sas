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
				cvPct25andOverWoutHSW_2010_14
				cvPct25andOverWHSW_2010_14
				cvPct25andOverWSCW_2010_14
				cvAvgHshldIncAdjW_2010_14
				cvPctFamilyGT200000W_2010_14
				cvPctFamilyLT75000W_2010_14
				cvPctPoorPersonsW_2010_14
				cvPctPoorChildrenW_2010_14
				cvPct16andOverEmployW_2010_14
				cvPctEmployed16to64W_2010_14
				cvPctUnemployedW_2010_14
				cvPct16andOverWagesW_2010_14
				cvPct16andOverWorkFTW_2010_14
				cvPctWorkFTLT35kW_2010_14
				cvPctWorkFTLT75kW_2010_14
				cvPctEmployedMngmtW_2010_14
				cvPctEmployedServW_2010_14
				cvPctEmployedSalesW_2010_14
				cvPctEmployedNatResW_2010_14
				cvPctEmployedProdW_2010_14
				cvPctOwnerOccupiedHUW_2010_14
				;

				*white upper bound;
			array w_upper{21} 		
				uPct25andOverWoutHSW_2010_14
				uPct25andOverWHSW_2010_14
				uPct25andOverWSCW_2010_14
				uAvgHshldIncAdjW_2010_14
				uPctFamilyGT200000W_2010_14
				uPctFamilyLT75000W_2010_14
				uPctPoorPersonsW_2010_14
				uPctPoorChildrenW_2010_14
				uPct16andOverEmployW_2010_14
				uPctEmployed16to64W_2010_14
				uPctUnemployedW_2010_14
				uPct16andOverWagesW_2010_14
				uPct16andOverWorkFTW_2010_14
				uPctWorkFTLT35kW_2010_14
				uPctWorkFTLT75kW_2010_14
				uPctEmployedMngmtW_2010_14
				uPctEmployedServW_2010_14
				uPctEmployedSalesW_2010_14
				uPctEmployedNatResW_2010_14
				uPctEmployedProdW_2010_14
				uPctOwnerOccupiedHUW_2010_14
				;

				*white lower bound; 

			array w_lower{21} 		
				lPct25andOverWoutHSW_2010_14
				lPct25andOverWHSW_2010_14
				lPct25andOverWSCW_2010_14
				lAvgHshldIncAdjW_2010_14
				lPctFamilyGT200000W_2010_14
				lPctFamilyLT75000W_2010_14
				lPctPoorPersonsW_2010_14
				lPctPoorChildrenW_2010_14
				lPct16andOverEmployW_2010_14
				lPctEmployed16to64W_2010_14
				lPctUnemployedW_2010_14
				lPct16andOverWagesW_2010_14
				lPct16andOverWorkFTW_2010_14
				lPctWorkFTLT35kW_2010_14
				lPctWorkFTLT75kW_2010_14
				lPctEmployedMngmtW_2010_14
				lPctEmployedServW_2010_14
				lPctEmployedSalesW_2010_14
				lPctEmployedNatResW_2010_14
				lPctEmployedProdW_2010_14
				lPctOwnerOccupiedHUW_2010_14
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
				Gap25andOverWoutHS&race._2010_1
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
