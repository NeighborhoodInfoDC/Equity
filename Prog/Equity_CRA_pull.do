cap log close


***-----------------------------------
*** CRA\SBA
*** Urban Institute
*** Created by: Brady Meixell
*** February 22, 2018
***-----------------------------------
clear matrix
clear mata
clear
set more off

*Change name of global to use your username accessing from Box Sycn*
global folder L:\Libraries\Equity\Raw
global output "L:\Libraries\Equity\Raw"

**********************************************************************************************************
**************ONLY READ IN AS D-6 VARIABLES DO NOT USE THIS READ-IN FOR ANY OTHER TABLE******************
**********************************************************************************************************

*Read In 2016 CRA Data*

infix str TableID 1-5 str ActYear 6-9 str LoanType 10 str ActionTakenType 11 str State 12-13 str County 14-16 str MSA_MD 17-21 str Tract 22-28 str Split_County 29 str Pop_Class 30 str Inc_Group_Total 31-33 str Report_Level 34-36 Num_SBL_Under100k 37-46 Amt_SBL_Under100k 47-56 Num_SBL_100k_250k 57-66 Amt_SBL_100k_250k 67-76 Num_SBL_250k_1m 77-86 Amt_SBL_250k_1m 87-96 Num_SBL_Rev 97-106 Amt_SBL_Rev 107-116 Filler 117-145 using "${folder}\cra2016_Aggr_A11.txt", clear
rename Tract tracta
save "${folder}\16exp_aggr.dta", replace

use "${folder}\14exp_aggr.dta", clear
append using "${folder}\15exp_aggr.dta"
append using "${folder}\16exp_aggr.dta"

keep if State=="11"

save "${folder}\MERGED_16_14_exp_aggr.dta", replace

*Clean Data*
keep if TableID=="A1-1"
drop if Report_Level=="200" | Report_Level=="210"

*APPROACH 1: Create Total Num + Amt of SB Loans (SB Defined as Loan Amt under 1m)*
gen AvgSizeSBLu100=Amt_SBL_Under100k/Num_SBL_Under100k

*Create proxy for credit card loans and drop
gen creditcardproxy=0
replace creditcardproxy=1 if AvgSizeSBLu100<10
replace Amt_SBL_Under100k=0 if creditcardproxy==1
replace Num_SBL_Under100k=0 if creditcardproxy==1

gen TotalNumSBL=Num_SBL_Under100k+Num_SBL_100k_250k+Num_SBL_250k_1m
gen TotalAmtSBL=Amt_SBL_Under100k+Amt_SBL_100k_250k+Amt_SBL_250k_1m

*Get rid of periods in tract number*

destring tracta, generate(Tract)
replace Tract=Tract*100
gen tract_=string(Tract, "%06.0f") 
drop tracta Tract
rename tract_ trct
egen geoid=concat(State County trct)

******************************
******KEEP YEARS WANTED*******
/*destring ActYear, replace
keep if ActYear>2010 & ActYear<2017
*/

*Collapse all years to one observation*
collapse (first) Inc_Group_Total trct (sum) TotalNumSBL TotalAmtSBL, by (geoid)
drop if trct=="."

save "L:\Libraries\Equity\Raw\CRA_to_merge.dta", replace 

use "L:\Libraries\Equity\Raw\CRA_to_merge.dta", clear
*Convert from 000s*
/*replace TotalAmtSBL=. if TotalAmtSBL==0*/
replace TotalAmtSBL=TotalAmtSBL*1000

/*YS: 3 year average of 14-16*/
gen AvgAnnualAmt=TotalAmtSBL/3


*Divide by # Emplyoees of Small Biz (1-19 employees)
rename geoid geo2010

merge 1:1 geo2010 using "L:\Libraries\Equity\Raw\LEHD_business_2015.dta" 
keep if _merge==3
drop _merge


xtile SBjobs=privatesectorjobs1_50employees, nq(100)
sort privatesectorjobs1_50employees

gen over49emp=1 if privatesectorjobs1_50employees>49 /*flag for tracts that have less than 50 small business jobs*/

gen CRAperEmp=AvgAnnualAmt/privatesectorjobs1_50employees /*if over49emp==1*/  

sort CRAperEmp
rename privatesectorjobs1_50employees SBemployees_total


keep geo2010 CRAperEmp AvgAnnualAmt SBemployees_total

export excel using "L:\Libraries\Equity\Raw\CRAbyTract.xlsx", firstrow(variables) replace 

********************************

