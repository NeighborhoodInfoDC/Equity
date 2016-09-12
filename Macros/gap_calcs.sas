%macro gap_calcs;

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

	array w_est&race. {21} 
		Pct25andOverWoutHSW_2010_14
		Pct25andOverWHSW_2010_14
		Pct25andOverWSCW_2010_14
		AvgHshldIncAdjW_2010_14
		PctFamilyGT200000W_2010_14
		PctFamilyLT75000W_2010_14
		PctPoorPersonsW_2010_14
		PctPoorChildrenW_2010_14
		Pct16andOverEmployW_2010_14
		PctEmployed16to64W_2010_14
		PctUnemployedW_2010_14
		Pct16andOverWagesW_2010_14
		Pct16andOverWorkFTW_2010_14
		PctWorkFTLT35kW_2010_14
		PctWorkFTLT75kW_2010_14
		PctEmployedMngmtW_2010_14
		PctEmployedServW_2010_14
		PctEmployedSalesW_2010_14
		PctEmployedNatResW_2010_14
		PctEmployedProdW_2010_14
		PctOwnerOccupiedHUW_2010_14
		;

	array w_moe&race. {21} 	
		Pct25andOverWoutHSW_m_2010_14
		Pct25andOverWHSW_m_2010_14
		Pct25andOverWSCW_m_2010_14
		AvgHshldIncAdjW_m_2010_14
		PctFamilyGT200000W_m_2010_14
		PctFamilyLT75000W_m_2010_14
		PctPoorPersonsW_m_2010_14
		PctPoorChildrenW_m_2010_14
		Pct16andOverEmployW_m_2010_14
		PctEmployed16to64W_m_2010_14
		PctUnemployedW_m_2010_14
		Pct16andOverWagesW_m_2010_14
		Pct16andOverWorkFTW_m_2010_14
		PctWorkFTLT35kW_m_2010_14
		PctWorkFTLT75kW_m_2010_14
		PctEmployedMngmtW_m_2010_14
		PctEmployedServW_m_2010_14
		PctEmployedSalesW_m_2010_14
		PctEmployedNatResW_m_2010_14
		PctEmployedProdW_m_2010_14
		PctOwnerOccupiedHUW_m_2010_14
		;

	array w_cv&race. {21} 
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

	array w_upper&race. {21} 		
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

	array w_lower&race. {21} 		
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

  	do m=1 to 21; 
   
                w_cv&race.{m}=w_moe&race.{m}/1.645/w_est&race.{m}*100;
                w_lower&race.{m}=w_est&race.{m}- w_moe&race.{m};
                w_upper&race.{m}=w_est&race.{m}+ w_moe&race.{m};
          
                if w_cv&race.{m} > 30 then do; 
					w_est&race.{m}=.s; w_moe&race.{m}=.s; 
				end; 

	 *suppress gaps if not sign. diff from white rates - probably need to add to array list;  
				if e_upper&race.{m} < w_upper&race.{m} and e_upper&race.{m} > w_lower&race.{m} then e_gap&race.{m}=.n;
				if e_lower&race.{m} > w_lower&race.{m} and e_lower&race.{m} < w_upper&race.{m} then e_gap&race.{m}=.n;  
	end;
       
	%end;
	%mend gap_calcs;
