/**************************************************************************
 Program:  suppress_gaps_fb.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  9/16/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses foreign-born and native-born gaps if not significantly different from white rates
			   and if estimates are suppressed (see suppress_vars.sas).
**************************************************************************/

%macro suppress_gaps_fb;

	array y_est {7} 
		CPct25andOverWoutHSW_&_years.
		CPct25andOverWoutHSW_&_years.
		CPct25andOverWHSW_&_years.
		CPct25andOverWHSW_&_years.
		CPct25andOverWSCW_&_years.
		CPct25andOverWSCW_&_years.
		CPctPoorPersonsW_&_years.
		;

	array y_moe {7} 	
		CPct25andOverWoutHSW_m_&_years.
		CPct25andOverWoutHSW_m_&_years.
		CPct25andOverWHSW_m_&_years.
		CPct25andOverWHSW_m_&_years.
		CPct25andOverWSCW_m_&_years.
		CPct25andOverWSCW_m_&_years.
		CPctPoorPersonsW_m_&_years.
		;

	array y_cv {7} 
		wfbcvPct25andOverWoutHSW_&_years.
		wfbcvPct25andOverWoutHSW_&_years.
		wfbcvPct25andOverWHSW_&_years.
		wfbcvPct25andOverWHSW_&_years.
		wfbcvPct25andOverWSCW_&_years.
		wfbcvPct25andOverWSCW_&_years.
		wfbcvPctPoorPersonsW_&_years.
		;

	array y_upper {7} 		
		wfbuPct25andOverWoutHSW_&_years.
		wfbuPct25andOverWoutHSW_&_years.
		wfbuPct25andOverWHSW_&_years.
		wfbuPct25andOverWHSW_&_years.
		wfbuPct25andOverWSCW_&_years.
		wfbuPct25andOverWSCW_&_years.
		wfbuPctPoorPersonsW_&_years.
		;

	array y_lower {7} 		
		wfblPct25andOverWoutHSW_&_years.
		wfblPct25andOverWoutHSW_&_years.
		wfblPct25andOverWHSW_&_years.
		wfblPct25andOverWHSW_&_years.
		wfblPct25andOverWSCW_&_years.
		wfblPct25andOverWSCW_&_years.
		wfblPctPoorPersonsW_&_years.
		;

	array n_gap {7} 		
	  	Gap25andOverWoutHSFB_&_years. 
		Gap25andOverWoutHSNB_&_years.
		Gap25andOverWHSFB_&_years. 
		Gap25andOverWHSNB_&_years. 
		Gap25andOverWSCFB_&_years. 
		Gap25andOverWSCNB_&_years.
		GapPoorPersonsFB_&_years.
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

	*suppressing gaps where estimates are suppresed;
				if n_est{j}=.s then n_gap{j}=.s;
	end;

%mend suppress_gaps_fb;
