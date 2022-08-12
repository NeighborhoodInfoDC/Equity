/**************************************************************************
 Program:  suppress_gaps_region_z.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S.Diby
 Created:  09/12/16
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses racial gaps if not significantly different from white rates
			   and if estimates are suppressed (see suppress_vars.sas).

Modification: 7/31/17 RP - added correct statistical significance testing 
		9/23/17 LH - corrected program by creating new macro so it remove vars with "c" which aren't in the region file. 
		02/24/22 LH - Updated to 6 race categories
		08/11/22 LH - Updated for shorten var names
**************************************************************************/

%macro suppress_gaps_region_z;

	
		* white estimates; 
			array a_est{21} 
				Pct25andOverWoutHSW_&_years.
				Pct25andOverWHSW_&_years.
				Pct25andOverWSCW_&_years.
				AvgHshldIncAdjW_&_years.
				PctFamilyGT200000W_&_years. 
				PctFamilyLT75000W_&_years.
				PctPoorPersonsW_&_years. 
				PctPoorChildrenW_&_years.
				Pct16plusEmployW_&_years.
				PctEmp16to64W_&_years.
				PctUnemployedW_&_years.
				Pct16plusWagesW_&_years.
				Pct16plusWorkFTW_&_years.
				PctWorkFTLT35kW_&_years.
				PctWorkFTLT75kW_&_years.
				PctEmpMngmtW_&_years.
				PctEmpServW_&_years.
				PctEmpSalesW_&_years.
				PctEmpNatResW_&_years.
				PctEmpProdW_&_years.
				PctOwnerOccupiedHUW_&_years.
				;

			*white MOE; 

			array a_moe{21} 	
				Pct25andOverWoutHSW_m_&_years.
				Pct25andOverWHSW_m_&_years.
				Pct25andOverWSCW_m_&_years.
				AvgHshldIncAdjW_m_&_years.
				PctFamilyGT200000W_m_&_years.
				PctFamilyLT75000W_m_&_years.
				PctPoorPersonsW_m_&_years.
				PctPoorChildrenW_m_&_years.
				Pct16plusEmployW_m_&_years.
				PctEmp16to64W_m_&_years.
				PctUnemployedW_m_&_years.
				Pct16plusWagesW_m_&_years.
				Pct16plusWorkFTW_m_&_years.
				PctWorkFTLT35kW_m_&_years.
				PctWorkFTLT75kW_m_&_years.
				PctEmpMngmtW_m_&_years.
				PctEmpServW_m_&_years.
				PctEmpSalesW_m_&_years.
				PctEmpNatResW_m_&_years.
				PctEmpProdW_m_&_years.
				PctOwnerOccupiedHUW_m_&_years.
				;

		%do r=1 %to 6;

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
				Gap16plusEmploy&race._&_years.
				GapEmp16to64&race._&_years.
				GapUnemployed&race._&_years.
				Gap16plusWages&race._&_years.
				Gap16plusWorkFT&race._&_years.
				GapWorkFTLT35k&race._&_years.
				GapWorkFTLT75k&race._&_years.
				GapEmpMngmt&race._&_years.
				GapEmpServ&race._&_years.
				GapEmpSales&race._&_years.
				GapEmpNatRes&race._&_years.
				GapEmpProd&race._&_years.
				GapOwnerOccupiedHU&race._&_years.
				;

		 	do X=1 to 21; /* *2016 method;
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
			if b_est&race.{X}=.s then e_gap&race.{X}=.s;

			end;
       
	%end;
					

	%mend suppress_gaps_region_z;
