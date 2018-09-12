cap log close

***-----------------------------------
*** LED pull
*** Urban Institute
*** Created by:Yiepng Su
*** 9.12, 2018
***-----------------------------------
clear matrix
clear mata
clear
set more off
set maxvar 32000

import excel "L:\Libraries\Equity\Raw\LEHD_business.xlsx", sheet("LEHD_business") firstrow

gen SB50= CFS01+CFS02

collapse (sum) C000 SB50, by(geo2010)

rename C000 totaljobs_privatesector
rename SB50 privatesectorjobs1_50employees

save "L:\Libraries\Equity\Raw\LEHD_business_2015.dta", replace
