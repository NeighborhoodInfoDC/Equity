/**************************************************************************
 Program:  suppress_vars_fb.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/12/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses foreign-born and native-born variable estimates and MOEs 
			   where coefficient of variation is greater than 30%.
**************************************************************************/

%macro suppress_vars_fb;

	array n_est {7} 		
	  	Pct25andOverWoutHSFB_&_years. Pct25andOverWoutHSNB_&_years.
		Pct25andOverWHSFB_&_years. Pct25andOverWHSNB_&_years. 
		Pct25andOverWSCFB_&_years. Pct25andOverWSCNB_&_years.
		PctPoorPersonsFB_&_years.
		;

	array n_moe {7} 		
	  	Pct25andOverWoutHSFB_m_&_years. Pct25andOverWoutHSNB_m_&_years.
		Pct25andOverWHSFB_m_&_years. Pct25andOverWHSNB_m_&_years. 
		Pct25andOverWSCFB_m_&_years. Pct25andOverWSCNB_m_&_years.
		PctPoorPersonsFB_m_&_years.
		;

	array n_cv {7} 		
	  	cvPct25andOverWoutHSFB_&_years. cvPct25andOverWoutHSNB_&_years.
		cvPct25andOverWHSFB_&_years. cvPct25andOverWHSNB_&_years. 
		cvPct25andOverWSCFB_&_years. cvPct25andOverWSCNB_&_years.
		cvPctPoorPersonsFB_&_years.
		;

	array n_upper {7} 		
	  	uPct25andOverWoutHSFB_&_years. uPct25andOverWoutHSNB_&_years.
		uPct25andOverWHSFB_&_years. uPct25andOverWHSNB_&_years. 
		uPct25andOverWSCFB_&_years. uPct25andOverWSCNB_&_years.
		uPctPoorPersonsFB_&_years.
		;

	array n_lower {7} 		
	  	lPct25andOverWoutHSFB_&_years. lPct25andOverWoutHSNB_&_years.
		lPct25andOverWHSFB_&_years. lPct25andOverWHSNB_&_years. 
		lPct25andOverWSCFB_&_years. lPct25andOverWSCNB_&_years.
		lPctPoorPersonsFB_&_years.
		;

  	do f=1 to 7; 
   
                n_cv{f}=n_moe{f}/1.645/n_est{f}*100;
                n_lower{f}=n_est{f}- n_moe{f};
                n_upper{f}=n_est{f}+ n_moe{f};
				

                *code to suppress if cv > 30;
                if n_cv{f} > 30 then do; n_est{f}=.s; n_moe{f}=.s;
                end;

	end;

%mend suppress_vars_fb;
