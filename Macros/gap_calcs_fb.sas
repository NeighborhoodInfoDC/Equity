%macro gap_calcs_fb;

	array y_est {7} 
		Pct25andOverWoutHSW_2010_14
		Pct25andOverWoutHSW_2010_14
		Pct25andOverWHSW_2010_14
		Pct25andOverWHSW_2010_14
		Pct25andOverWSCW_2010_14
		Pct25andOverWSCW_2010_14
		PctPoorPersonsW_2010_14
		;

	array y_moe {7} 	
		Pct25andOverWoutHSW_m_2010_14
		Pct25andOverWoutHSW_m_2010_14
		Pct25andOverWHSW_m_2010_14
		Pct25andOverWHSW_m_2010_14
		Pct25andOverWSCW_m_2010_14
		Pct25andOverWSCW_m_2010_14
		PctPoorPersonsW_m_2010_14
		;

	array y_cv {7} 
		cvPct25andOverWoutHSW_2010_14
		cvPct25andOverWoutHSW_2010_14
		cvPct25andOverWHSW_2010_14
		cvPct25andOverWHSW_2010_14
		cvPct25andOverWSCW_2010_14
		cvPct25andOverWSCW_2010_14
		cvPctPoorPersonsW_2010_14
		;

	array y_upper {7} 		
		uPct25andOverWoutHSW_2010_14
		uPct25andOverWoutHSW_2010_14
		uPct25andOverWHSW_2010_14
		uPct25andOverWHSW_2010_14
		uPct25andOverWSCW_2010_14
		uPct25andOverWSCW_2010_14
		uPctPoorPersonsW_2010_14
		;

	array y_lower {7} 		
		lPct25andOverWoutHSW_2010_14
		lPct25andOverWoutHSW_2010_14
		lPct25andOverWHSW_2010_14
		lPct25andOverWHSW_2010_14
		lPct25andOverWSCW_2010_14
		lPct25andOverWSCW_2010_14
		lPctPoorPersonsW_2010_14
		;

	array n_gap {7} 		
	  	Gap25andOverWoutHSFB_2010_14 
		Gap25andOverWoutHSNB_2010_14
		Gap25andOverWHSFB_2010_14 
		Gap25andOverWHSNB_2010_14 
		Gap25andOverWSCFB_2010_14 
		Gap25andOverWSCNB_2010_14
		GapPoorPersonsFB_2010_14
		;

  	do j=1 to 7; 
   
                y_cv{j}=y_moe{j}/1.645/y_est{j}*100;
                y_lower{j}=y_est{j}- y_moe{j};
                y_upper{j}=y_est{j}+ y_moe{j};
          
                if y_cv{j} > 30 then do; 
					y_est{j}=.s; y_moe{j}=.s; 
				end; 

	 *write code to suppress gaps if not sign. diff froj white rates - probably need to add to array list;  
				if n_upper{j} < y_upper{j} and n_upper{j} > y_lower{j} then n_gap{j}=.n;
				if n_lower{j} > y_lower{j} and n_lower{j} < y_upper{j} then n_gap{j}=.n;  
	end;

%mend gap_calcs_fb;
