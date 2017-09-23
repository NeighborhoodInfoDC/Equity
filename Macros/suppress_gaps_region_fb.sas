/**************************************************************************
 Program:  suppress_gaps_region_fb.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  9/16/16
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 
 Description:  Suppresses foreign-born and native-born gaps if not significantly different from white rates
			   and if estimates are suppressed (see suppress_vars.sas).
Modifications: 9/23/17 LH Corrected program for the fact we aren't using "city" vars in the region
			  and added new methodology to calulate significance.   
**************************************************************************/

%macro suppress_gaps_region_fb;

	array c_est {7} 
		Pct25andOverWoutHSW_&_years.
		Pct25andOverWoutHSW_&_years.
		Pct25andOverWHSW_&_years.
		Pct25andOverWHSW_&_years.
		Pct25andOverWSCW_&_years.
		Pct25andOverWSCW_&_years.
		PctPoorPersonsW_&_years.
		;

	array c_moe {7} 	
		Pct25andOverWoutHSW_m_&_years.
		Pct25andOverWoutHSW_m_&_years.
		Pct25andOverWHSW_m_&_years.
		Pct25andOverWHSW_m_&_years.
		Pct25andOverWSCW_m_&_years.
		Pct25andOverWSCW_m_&_years.
		PctPoorPersonsW_m_&_years.
		;

	array d_est {7} 
		Pct25andOverWoutHSFB_&_years.
		Pct25andOverWoutHSNB_&_years.
		Pct25andOverWHSFB_&_years.
		Pct25andOverWHSNB_&_years.
		Pct25andOverWSCFB_&_years.
		Pct25andOverWSCNB_&_years.
		PctPoorPersonsFB_&_years.
		;
		
	array d_moe {7} 		
		Pct25andOverWoutHSFB_m_&_years.
		Pct25andOverWoutHSNB_m_&_years.
		Pct25andOverWHSFB_m_&_years.
		Pct25andOverWHSNB_m_&_years.
		Pct25andOverWSCFB_m_&_years.
		Pct25andOverWSCNB_m_&_years.
		PctPoorPersonsFB_m_&_years.
		;

	
	array f_gap {7} 		
	  	Gap25andOverWoutHSFB_&_years. 
		Gap25andOverWoutHSNB_&_years.
		Gap25andOverWHSFB_&_years. 
		Gap25andOverWHSNB_&_years. 
		Gap25andOverWSCFB_&_years. 
		Gap25andOverWSCNB_&_years.
		GapPoorPersonsFB_&_years.
		;

  	do X=1 to 7; 
   
   	/*old code
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
	
	*/
	** Suppression calculation based on guidance in this Census doc:
				   https://www2.census.gov/programs-surveys/acs/tech_docs/statistical_testing/2014StatisticalTesting5.pdf ;
	
				*Calculate standard error from MOE;
				c_se = c_moe{X} / 1.645;
				d_se = d_moe{X} / 1.645;
	
				*Calculate Z;
				num = c_est{X} - d_est{X};
				den = sqrt(c_se**2 + d_se**2);
				z = num / den;
	
				*From census doc: If Z < -1.645 or Z > 1.645, then the difference between A and B is significant at the 90 percent
				confidence level. Otherwise, the difference is not significant. ;
				if -1.645 <= z <= 1.645 then f_gap{X}=.n;
	
				 *suppress gaps where estimates are suppresed;
				if d_est{X}=.s then f_gap{X}=.s;
	
			
	end;

%mend suppress_gaps_region_fb;
