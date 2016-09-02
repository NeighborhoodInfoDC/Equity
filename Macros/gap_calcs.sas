%macro gap_calcs;

	%do r=1 %to 4;

		%let race=%scan(&racelist.,&r.," ");
		%let name=%scan(&racename.,&r.," ");

	array c_est {21} 
		Pct25andOverWoutHSW_2010_14
		Pct25andOverWHSW_2010_14
		Pct25andOverWSCW_2010_14
		AvgHshldIncAdjW_2010_14
		PctFamilyGT200000W_2010_14
		PctFamilyLT75000W_2010_14
		PctPoorPersonsW_2010_14
		PctPoorChildrenW_2010_14
		Pct16andOverEmployedW_2010_14
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

	array c_moe {21} 	
		Pct25andOverWoutHSW_m_2010_14
		Pct25andOverWHSW_m_2010_14
		Pct25andOverWSCW_m_2010_14
		AvgHshldIncAdjW_m_2010_14
		PctFamilyGT200000W_m_2010_14
		PctFamilyLT75000W_m_2010_14
		PctPoorPersonsW_m_2010_14
		PctPoorChildrenW_m_2010_14
		Pct16andOverEmployedW_m_2010_14
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

	array c_cv {21} 
		cvPct25andOverWoutHSW_2010_14
		cvPct25andOverWHSW_2010_14
		cvPct25andOverWSCW_2010_14
		cvAvgHshldIncAdjW_2010_14
		cvPctFamilyGT200000W_2010_14
		cvPctFamilyLT75000W_2010_14
		cvPctPoorPersonsW_2010_14
		cvPctPoorChildrenW_2010_14
		cvPct16andOverEmployedW_2010_14
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

	array c_upper {21} 		
		uPct25andOverWoutHSW_2010_14
		uPct25andOverWHSW_2010_14
		uPct25andOverWSCW_2010_14
		uAvgHshldIncAdjW_2010_14
		uPctFamilyGT200000W_2010_14
		uPctFamilyLT75000W_2010_14
		uPctPoorPersonsW_2010_14
		uPctPoorChildrenW_2010_14
		uPct16andOverEmployedW_2010_14
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

	array c_lower {21} 		
		lPct25andOverWoutHSW_2010_14
		lPct25andOverWHSW_2010_14
		lPct25andOverWSCW_2010_14
		lAvgHshldIncAdjW_2010_14
		lPctFamilyGT200000W_2010_14
		lPctFamilyLT75000W_2010_14
		lPctPoorPersonsW_2010_14
		lPctPoorChildrenW_2010_14
		lPct16andOverEmployedW_2010_14
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

	array r_gap {21} 
		Gap25andOverWoutHS&race._2010_14
		Gap25andOverWHS&race._2010_14
		Gap25andOverWSC&race._2010_14
		GapAvgHshldIncAdj&race._2010_14
		GapFamilyGT200000&race._2010_14
		GapFamilyLT75000&race._2010_14
		GapPoorPersons&race._2010_14
		GapPoorChildren&race._2010_14
		Gap16andOverEmployed&race._2010_14
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
   
                c_cv{m}=c_moe{m}/1.645/c_est{m}*100;
                c_lower{m}=c_est{m}- c_moe{m};
                c_upper{m}=c_est{m}+ c_moe{m};
          
                if c_cv{m} > 30 then do; 
					c_est{m}=.s; c_moe{m}=.s; 
				end; 

	 *write code to suppress gaps if not sign. diff from white rates - probably need to add to array list;  
				if r_upper{m} < c_upper{m} and r_upper{m} > c_lower{m} then r_gap{m}=.s;
				if r_lower{m} > c_lower{m} and r_lower{m} < c_upper{m} then r_gap{m}=.s;  
	end;

           
	%end;
	%mend gap_calcs;
