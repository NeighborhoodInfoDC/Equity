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

%macro suppress_gaps_z;

	
		*CITY white estimates; 
			array a_est{21} 
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

			array a_moe{21} 	
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

		%do r=1 %to 5;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

		*test indicator estimate ;

			array b_est&race.{21} 
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
				;

			*test indicator MOE *;
			array b_moe&race.{21} 		
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
				;

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

		 	do X=1 to 21; /*
		 	*suppress gaps if not significantly different from white rates;  
						if e_upper&race.{X} < w_upper{X} and e_upper&race.{X} > w_lower{X} then e_gap&race.{X}=.n;
						if e_lower&race.{X} > w_lower{X} and e_lower&race.{X} < w_upper{X} then e_gap&race.{X}=.n;  

			 *suppress gaps where estimates are suppresed;
						if e_est&race.{X}=.s then e_gap&race.{X}=.s;
			*/
			
			** Suppression calculation based on guidance in this Census doc:
			   https://www2.census.gov/programs-surveys/acs/tech_docs/statistical_testing/2014StatisticalTesting5.pdf ;

			*Calculate standard error from MOE;
			a_se = a_moe{X} / 1.645;
			b_se&race. = b_moe&race.{X} / 1.645;

			*Calculate Z;
			num&race. = a_est{X} - b_est&race.{X};
			den&race. = sqrt(a_se**2 + b_se&race.**2);
			z&race. = num&race. / den&race.;

			*From census doc: If Z < -1.645 or Z > 1.645, then the difference between A and B is significant at the 90 percent
			confidence level. Otherwise, the difference is not significant. ;
			if -1.645 <= z&race. <= 1.645 then e_gap&race.{X}=.n;

			 *suppress gaps where estimates are suppresed;
			if e_est&race.{X}=.s then e_gap&race.{X}=.s;

			end;
       
	%end;
					

	%mend suppress_gaps_z;
