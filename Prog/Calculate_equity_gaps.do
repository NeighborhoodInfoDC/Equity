* Program: Calculate_equity_gaps
* Created by: Yipeng Su
* Last modified: 10/22/2018

import excel using "L:\Libraries\Equity\Prog\JPMC feature\For stata.xlsx", firstrow

drop GID

*index is a simplified ID variable I created for each of the equity variables so we can reshape
reshape wide numerator denom equityvariable, i(index) j(geo) string

save "L:\Libraries\Equity\Prog\JPMC feature\Wide data.dta", replace

*merge the wide file back to long file for calculating gaps
import excel using "L:\Libraries\Equity\Prog\JPMC feature\For stata.xlsx", firstrow clear

merge m:1 index using "L:\Libraries\Equity\Prog\JPMC feature\Wide data.dta"

*calculate equity gap = (dealta equity var)*denominator of each geography of interest
local geography DC Ward1 Ward2 Ward3 Ward4 Ward5 Ward6 Ward7 Ward8 Cluster1 Cluster2 Cluster3 Cluster4 Cluster5 Cluster6 ///
                Cluster7 Cluster8 Cluster9 Cluster10 Cluster11 Cluster12 Cluster13 Cluster14 Cluster15 Cluster16 Cluster17 ///
				Cluster18 Cluster19 Cluster20 Cluster21	Cluster22 Cluster23 Cluster24 Cluster25 Cluster26 Cluster27 Cluster28 Cluster29 ///
				Cluster30 Cluster31 Cluster32 Cluster33 Cluster34 Cluster35 Cluster36 Cluster37 Cluster38 Cluster39 Cluster40 Cluster41 Cluster43 Cluster44
				
forvalues i= 1/22 { 
  
	foreach geo of local geography {
	gen `geo'_index`i'=.
	replace `geo'_index`i' = (equityvariable-equityvariable`geo')*denom

	}

}

sort index GID


*export the square shaped dataset
levelsof index, local(indicatorvar)
foreach var of local indicatorvar {
    preserve
    export excel indicator geo GID DC_index`var' Ward1_index`var' Ward2_index`var' Ward3_index`var' Ward4_index`var' Ward5_index`var' ///
	Ward6_index`var' Ward7_index`var' Ward8_index`var' Cluster1_index`var' Cluster2_index`var' Cluster3_index`var' Cluster4_index`var' Cluster5_index`var' Cluster6_index`var' ///
	Cluster7_index`var' Cluster8_index`var' Cluster9_index`var' Cluster10_index`var' Cluster11_index`var' Cluster12_index`var' Cluster13_index`var' Cluster14_index`var' ///
	Cluster15_index`var' Cluster16_index`var' Cluster17_index`var' Cluster18_index`var' Cluster19_index`var' Cluster20_index`var' Cluster21_index`var' Cluster22_index`var' ///
	Cluster23_index`var' Cluster24_index`var' Cluster25_index`var' Cluster26_index`var' Cluster27_index`var' Cluster28_index`var' Cluster29_index`var' Cluster30_index`var' ///
	Cluster31_index`var' Cluster32_index`var' Cluster33_index`var' Cluster34_index`var' Cluster35_index`var' Cluster36_index`var' Cluster37_index`var' Cluster38_index`var' ///
	Cluster39_index`var' Cluster40_index`var' Cluster41_index`var' Cluster43_index`var' Cluster44_index`var' ///
	using "L:\Libraries\Equity\Prog\JPMC feature\EquityGaps.xlsx" if index == `var', firstrow(variables) ///
    sheet(`var') sheetreplace
	restore
}





