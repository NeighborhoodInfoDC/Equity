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

collapse (sum) C000 CFS01, by(geo2010)

rename C000 totaljobs_privatesector
rename CFS01 privatesectorjobs1_20employees

save "L:\Libraries\Equity\Raw\LEHD_business_2015.dta", replace
