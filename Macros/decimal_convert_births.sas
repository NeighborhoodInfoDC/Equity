/**************************************************************************
 Program:  decimal_convert_births.sas
 Library:  Equity
 Project:  NeighborhoodInfo DC
 Author:   S. Diby
 Created:  09/29/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Converts percentages for by-race and total birth variable percentages and gaps to decimals. 
			   Created in anticipation of Racial Equity interactive feature published on Urban.org--
			   Comms prefers decimals for csv format.
**************************************************************************/

%macro decimal_convert_births;

*Create arrays for birth indicators--Arrays list existing variables in percent format and new arrays will be in decimal format;

			array pctbirthvars{29}
				Pct_births_w_race_2011

				Pct_births_white_2011
				Pct_births_asian_2011
				Pct_births_black_2011
				Pct_births_hisp_2011
				Pct_births_oth_rac_2011

				Pct_births_white_3yr_2011
				Pct_births_asian_3yr_2011
				Pct_births_black_3yr_2011
				Pct_births_hisp_3yr_2011
				Pct_births_oth_rac_3yr_2011

				Pct_births_low_wt_2011
				Pct_births_low_wt_wht_2011
				Pct_births_low_wt_blk_2011
				Pct_births_low_wt_hsp_2011
				Pct_births_low_wt_asn_2011
				Pct_births_low_wt_oth_2011

				Pct_births_prenat_adeq_2011
				Pct_births_prenat_adeq_wht_2011
				Pct_births_prenat_adeq_blk_2011
				Pct_births_prenat_adeq_hsp_2011
				Pct_births_prenat_adeq_asn_2011
				Pct_births_prenat_adeq_oth_2011

				Pct_births_teen_2011
				Pct_births_teen_wht_2011
				Pct_births_teen_blk_2011
				Pct_births_teen_hsp_2011
				Pct_births_teen_asn_2011
				Pct_births_teen_oth_2011

				;

			array decibirthvars{29}
				nPct_births_w_race_2011

				nPct_births_white_2011
				nPct_births_asian_2011
				nPct_births_black_2011
				nPct_births_hisp_2011
				nPct_births_oth_rac_2011

				nPct_births_white_3yr_2011
				nPct_births_asian_3yr_2011
				nPct_births_black_3yr_2011
				nPct_births_hisp_3yr_2011
				nPct_births_oth_rac_3yr_2011

				nPct_births_low_wt_2011
				nPct_births_low_wt_wht_2011
				nPct_births_low_wt_blk_2011
				nPct_births_low_wt_hsp_2011
				nPct_births_low_wt_asn_2011
				nPct_births_low_wt_oth_2011

				nPct_births_prenat_adeq_2011
				nPct_births_prenat_adeq_wht_2011
				nPct_births_prenat_adeq_blk_2011
				nPct_births_prenat_adeq_hsp_2011
				nPct_births_prenat_adeq_asn_2011
				nPct_births_prenat_adeq_oth_2011

				nPct_births_teen_2011
				nPct_births_teen_wht_2011
				nPct_births_teen_blk_2011
				nPct_births_teen_hsp_2011
				nPct_births_teen_asn_2011
				nPct_births_teen_oth_2011
				;

				do z=1 to 29; 

					decibirthvars{z}=pctbirthvars{z}/100;
					
					if pctbirthvars{z}=.s then decibirthvars{z}=.s;

				end;

	*Create and convert arrays for birth var gaps.;

			array oldbirthgaps {12} 		
				Gap_births_low_wt_blk_2011
				Gap_births_low_wt_hsp_2011
				Gap_births_low_wt_asn_2011
				Gap_births_low_wt_oth_2011
				Gap_births_prenat_adeq_blk_2011
				Gap_births_prenat_adeq_hsp_2011
				Gap_births_prenat_adeq_asn_2011
				Gap_births_prenat_adeq_oth_2011
				Gap_births_teen_blk_2011
				Gap_births_teen_hsp_2011
				Gap_births_teen_asn_2011
				Gap_births_teen_oth_2011
				;

			array newbirthgaps {12} 	
				nGap_births_low_wt_blk_2011
				nGap_births_low_wt_hsp_2011
				nGap_births_low_wt_asn_2011
				nGap_births_low_wt_oth_2011
				nGap_births_prenat_adeq_blk_2011
				nGap_births_prenat_adeq_hsp_2011
				nGap_births_prenat_adeq_asn_2011
				nGap_births_prenat_adeq_oth_2011
				nGap_births_teen_blk_2011
				nGap_births_teen_hsp_2011
				nGap_births_teen_asn_2011
				nGap_births_teen_oth_2011				
				;

				do y=1 to 12; 

					newbirthgaps{y}=oldbirthgaps{y};
	
					if oldbirthgaps{y}=.s then newbirthgaps{y}=.s;

				end;

%mend decimal_convert_births;
