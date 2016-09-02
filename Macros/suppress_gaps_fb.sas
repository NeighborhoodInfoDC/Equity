%macro suppress_gaps_fb;

	array n_est {7} 		
	  	Pct25andOverWoutHSFB_2010_14 Pct25andOverWoutHSNB_2010_14
		Pct25andOverWHSFB_2010_14 Pct25andOverWHSNB_2010_14 
		Pct25andOverWSCFB_2010_14 Pct25andOverWSCNB_2010_14
		PctPoorPersonsFB_2010_14
		;

	array n_moe {7} 		
	  	Pct25andOverWoutHSFB_m_2010_14 Pct25andOverWoutHSNB_m_2010_14
		Pct25andOverWHSFB_m_2010_14 Pct25andOverWHSNB_m_2010_14 
		Pct25andOverWSCFB_m_2010_14 Pct25andOverWSCNB_m_2010_14
		PctPoorPersonsFB_m_2010_14
		;

	array n_cv {7} 		
	  	cvPct25andOverWoutHSFB_2010_14 cvPct25andOverWoutHSNB_2010_14
		cvPct25andOverWHSFB_2010_14 cvPct25andOverWHSNB_2010_14 
		cvPct25andOverWSCFB_2010_14 cvPct25andOverWSCNB_2010_14
		cvPctPoorPersonsFB_2010_14
		;

	array n_upper {7} 		
	  	uPct25andOverWoutHSFB_2010_14 uPct25andOverWoutHSNB_2010_14
		uPct25andOverWHSFB_2010_14 uPct25andOverWHSNB_2010_14 
		uPct25andOverWSCFB_2010_14 uPct25andOverWSCNB_2010_14
		uPctPoorPersonsFB_2010_14
		;

	array n_lower {7} 		
	  	lPct25andOverWoutHSFB_2010_14 lPct25andOverWoutHSNB_2010_14
		lPct25andOverWHSFB_2010_14 lPct25andOverWHSNB_2010_14 
		lPct25andOverWSCFB_2010_14 lPct25andOverWSCNB_2010_14
		lPctPoorPersonsFB_2010_14
		;

  	do f=1 to 7; 
   
                n_cv{f}=n_moe{f}/1.645/n_est{f}*100;
                n_lower{f}=n_est{f}- n_moe{f};
                n_upper{f}=n_est{f}+ n_moe{f};
				

                *code to suppress if cv > 30;
                if n_cv{f} > 30 then do; n_est{f}=.s; n_moe{f}=.s;
                end;

	end;

%mend suppress_gaps_fb;
