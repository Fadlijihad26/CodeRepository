
/*

MTPL Project

Author: Fadli Setiawan
Last Edited: July 4, 2024

*/

clear all
set more off

gl input "/Users/macintoshhd/Documents/0 IFG Progress/3Short-term Projects/MTPL/1input"
gl output "/Users/macintoshhd/Documents/0 IFG Progress/3Short-term Projects/MTPL/2output"

*MTPL

foreach var in MTPL1 MTPL2 MTPL3 MTPL4 MTPL5 MTPL6 MTPL7 MTPL8 MTPL9 MTPL10 MTPL11 MTPL12 {
		import excel "$input/MTPLedit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/MTPL1.dta"

foreach var in MTPL2 MTPL3 MTPL4 MTPL5 MTPL6 MTPL7 MTPL8 MTPL9 MTPL10 MTPL11 MTPL12 {
		merge 1:1 country year using "$output/all_vars/`var'.dta"
		drop _merge
}

save "$output/MTPL.dta", replace

*CALCMTPL

foreach var in CALCMTPL1 CALCMTPL2 CALCMTPL3 CALCMTPL4 CALCMTPL5 CALCMTPL6 CALCMTPL7 CALCMTPL8 CALCMTPL9 CALCMTPL10 CALCMTPL11 CALCMTPL12 CALCMTPL13 CALCMTPL14 {
		import excel "$input/CALCMTPLedit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/CALCMTPL1.dta"

foreach var in CALCMTPL2 CALCMTPL3 CALCMTPL4 CALCMTPL5 CALCMTPL6 CALCMTPL7 CALCMTPL8 CALCMTPL9 CALCMTPL10 CALCMTPL11 CALCMTPL12 CALCMTPL13 CALCMTPL14 {
		merge 1:1 country year using "$output/all_vars/`var'.dta"
		drop _merge
}

save "$output/CALCMTPL.dta", replace

*Structural

foreach var in Structural1 Structural2 {
import excel "$input/Structuraledit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/Structural1.dta"
merge 1:1 country year using "$output/all_vars/Structural2.dta"
drop _merge

save "$output/Structural.dta", replace

*TOTAL

foreach var in TOTAL1 TOTAL2 TOTAL3 TOTAL4 TOTAL5 TOTAL6 TOTAL7 TOTAL8 TOTAL9 {
		import excel "$input/TOTALedit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/TOTAL1.dta"

foreach var in TOTAL2 TOTAL3 TOTAL4 TOTAL5 TOTAL6 TOTAL7 TOTAL8 TOTAL9 {
		merge 1:1 country year using "$output/all_vars/`var'.dta"
		drop _merge
}

save "$output/TOTAL.dta", replace

*CALCTOTAL

foreach var in CALCTOTAL1 CALCTOTAL2 CALCTOTAL3 CALCTOTAL4 CALCTOTAL5 CALCTOTAL6 CALCTOTAL7 {
		import excel "$input/CALCTOTALedit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/CALCTOTAL1.dta"

foreach var in CALCTOTAL2 CALCTOTAL3 CALCTOTAL4 CALCTOTAL5 CALCTOTAL6 CALCTOTAL7 {
		merge 1:1 country year using "$output/all_vars/`var'.dta"
		drop _merge
}

save "$output/CALCTOTAL.dta", replace

*DMG

foreach var in DMG1 DMG2 DMG3 DMG4 DMG5 DMG6 DMG7 DMG8 {
		import excel "$input/DMGedit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/DMG1.dta"

foreach var in DMG2 DMG3 DMG4 DMG5 DMG6 DMG7 DMG8 {
		merge 1:1 country year using "$output/all_vars/`var'.dta"
		drop _merge
}

save "$output/DMG.dta", replace

*CALCDMG

foreach var in CALCDMG1 CALCDMG2 CALCDMG3 CALCDMG4 CALCDMG5 CALCDMG6 CALCDMG7 CALCDMG8 CALCDMG9 {
		import excel "$input/CALCDMGedit.xlsx", sheet("`var'") firstrow case(lower) clear
		rename value `var'
		save "$output/all_vars/`var'.dta", replace
}

clear
use "$output/all_vars/CALCDMG1.dta"

foreach var in CALCDMG2 CALCDMG3 CALCDMG4 CALCDMG5 CALCDMG6 CALCDMG7 CALCDMG8 CALCDMG9 {
		merge 1:1 country year using "$output/all_vars/`var'.dta"
		drop _merge
}

save "$output/CALCDMG.dta", replace

*** MERGE ALL ***

use "$output/MTPL.dta", clear

foreach var in CALCMTPL Structural TOTAL CALCTOTAL DMG CALCDMG {
		merge 1:1 country year using "$output/`var'.dta"
		drop _merge
}

renvars, lower

la var mtpl1 "Motor Third Party Liability: direct premiums written on Domestic Market"
la var mtpl2 "Motor Third Party Liability: gross earned premiums on Domestic Market" 
la var mtpl3 "Motor Third Party Liability: claims expenditure"
la var mtpl4 "Motor Third Party Liability: claims expenditure involving bodily injury"
la var mtpl5 "Motor Third Party Liability: claims paid involving bodily injury"
la var mtpl6 "Motor Third Party Liability: operating expenses"
la var mtpl7 "Motor Third Party Liability: number of insured vehicle years"
la var mtpl8 "Motor Third Party Liability: number of policies (if not available, number of total motor policies)"
la var mtpl9 "Motor Third Party Liability: number of claims notified in current accident year (excluding nil claims)"
la var mtpl10 "Motor Third Party Liability: number of claims notified in current accident year (excluding nil claims) involving bodily injury"
la var mtpl11 "Motor Third Party Liability: number of claims notified in current accident year (including nil claims)"
la var mtpl12 "Motor Third Party Liability: number of claims notified in current accident year (including nil claims) involving bodily injury"

la var calcmtpl1 "Claim cost: gross claims expenditure divided by the number of claims notified, excluding nil claims (in not available, including nil claims)"
la var calcmtpl2 "Claims frequency: number of claims notified divided by the number of insured vehicle years (if not available, by number of insured vehicles or number of policies)" 
la var calcmtpl3 "Combined ratio: sum of the loss ratio and the expense ratio"
la var calcmtpl4 "Expense ratio: gross operating expenses as a percentage of gross direct premiums written"
la var calcmtpl5 "Loss or claims ratio: gross claims expenditure as a percentage of gross earned premiums (if not available, direct written premiums)"
la var calcmtpl6 "Underwriting result: (1-combined ratio)*gross direct premiums written"
la var calcmtpl7 "Bodily injury claims frequency: number of claims notified divided by the number of insured vehicle years (if not available, by number of insureds or number of policies)"
la var calcmtpl8 "Average MTPL premiums (MTPL premiums/number of policies)"
la var calcmtpl9 "Average MTPL premiums PPP-adjusted"
la var calcmtpl10 "Net risk premiums (Average claims cost * average claims frequency)"
la var calcmtpl11 "Net risk premiums (Average claims cost * average claims frequency)"
la var calcmtpl12 "Values are for Total Premiums, depending on whether MTPL premiums are reported - to calculate share of MTPL in Total Motor" 
la var calcmtpl13 "Cost of claims involving bodily injury (ppp-adjusted): gross claims expenditure divided by the number of claims notified, excluding nil claims (in not available, including nil claims)"
la var calcmtpl14 "Number of claims per 1000 policies"

la var structural1 "Number of active companies in motor insurance on Domestic Market"
la var structural2 "Number of active companies in motor insurance on Total Market"

la var total1 "Total motor insurance (MTPL and damage): direct premiums written on Domestic Market"
la var total2 "Total motor insurance (MTPL and damage): gross earned premiums on Domestic Market"
la var total3 "Total motor insurance (MTPL and damage): claims expenditure"
la var total4 "Total motor insurance (MTPL and damage): operating expenses" 
la var total5 "Total motor insurance (MTPL and damage): number of insured vehicle years (if not available, number of insured vehicle years from MTPL)"
la var total6 "Total motor insurance (MTPL and damage): number of policies (if not available, number of insured vehicles)" 
la var total7 "Total motor insurance (MTPL and damage): number of claims notified in current accident year (excluding nil claims)"
la var total8 "Total motor insurance (MTPL and damage): number of claims notified in current accident year (including nil claims)" 
la var total9 "Total motor insurance (MTPL and damage): number of insured vehicles"

la var calctotal1 "Claim cost: gross claims expenditure divided by the number of claims notified, excluding nil claims (in not available, including nil claims)"
la var calctotal2 "Claims frequency: number of claims notified divided by the number of insured vehicle years (if not available, by number of insured vehicles or number of policies)"
la var calctotal3 "Combined ratio: sum of the loss ratio and the expense ratio"
la var calctotal4 "Expense ratio: gross operating expenses as a percentage of gross direct premiums written"
la var calctotal5 "Loss or claims ratio: gross claims expenditure as a percentage of gross earned premiums (if not available, direct written premiums)"
la var calctotal6 "Underwriting result: (1-combined ratio)*gross direct premiums written"
la var calctotal7 "Average premiums - ppp-adjusted"

la var dmg1 "Damage to or loss of land vehicles: direct premiums written on Domestic Market"
la var dmg2 "Damage to or loss of land vehicles: gross earned premiums on Domestic Market"
la var dmg3 "Damage to or loss of land vehicles: claims expenditure"
la var dmg4 "Damage to or loss of land vehicles: operating expenses"
la var dmg5 "Damage to loss of land vehicles: number of insured vehicle years" 
la var dmg6 "Damage to loss of land vehicles: number of policies"
la var dmg7 "Damage to loss of land vehicles: number of claims notified in current accident year (excluding nil claims)"
la var dmg8 "Damage to loss of land vehicles: number of claims notified in current accident year (including nil claims)"

la var calcdmg1 "Claim cost: gross claims expenditure divided by the number of claims notified, excluding nil claims (in not available, including nil claims)"
la var calcdmg2 "Claims frequency: number of claims notified divided by the number of insured vehicle years (if not available, by number of insured vehicles or number of policies)"
la var calcdmg3 "Combined ratio: sum of the loss ratio and the expense ratio"
la var calcdmg4 "Expense ratio: gross operating expenses as a percentage of gross direct premiums written"
la var calcdmg5 "Loss or claims ratio: gross claims expenditure as a percentage of gross earned premiums (if not available, direct written premiums)"
la var calcdmg6 "Underwriting result: (1-combined ratio)*gross direct premiums written"
la var calcdmg7 "Average damage premiums (damage premiums/number of policies)"
la var calcdmg8 "Average damage premiums (damage premiums/number of policies) - ppp-adjusted"
la var calcdmg9 "Cost of damage claims - ppp-adjusted"

save "$output/mtpl_master_data.dta", replace

** Merge with Total Vehicle

import excel "$input/Total_Vehicles_in_Europe_2006_2015_Long.xlsx", sheet("Sheet1") firstrow case(lower) clear
rename value totalvehicle

save "$output/totalvehicle.dta", replace

use "$output/mtpl_master_data.dta", clear

merge 1:1 country year using "$output/totalvehicle.dta"
drop if _merge == 2
drop _merge

save "$output/mtpl_master_data_v3.dta", replace

*** Determinants of CALCMTPL5 ***

use "$output/mtpl_master_data_v3.dta", clear

corr calcmtpl5 mtpl1 mtpl2 mtpl3 mtpl4 mtpl5 mtpl6 mtpl7 mtpl8 mtpl9 mtpl10 mtpl11 mtpl12

corr calcmtpl5 calcmtpl1 calcmtpl2 calcmtpl3 calcmtpl4 calcmtpl6 calcmtpl7 calcmtpl8 calcmtpl9 calcmtpl10 calcmtpl11 calcmtpl12 calcmtpl13 calcmtpl14

corr calcmtpl5 structural1 structural2

corr calcmtpl5 total1 total2 total3 total4 total5 total6 total7 total8 total9

corr calcmtpl5 calctotal1 calctotal2 calctotal3 calctotal4 calctotal5 calctotal6 calctotal7

corr calcmtpl5 dmg1 dmg2 dmg3 dmg4 dmg5 dmg6 dmg7 dmg8

corr calcmtpl5 calcdmg1 calcdmg2 calcdmg3 calcdmg4 calcdmg5 calcdmg6 calcdmg7 calcdmg8 calcdmg9 totalvehicle

encode country, gen(country_n)
xtset country_n year

// Vars with > 0.2 in absolute value: mtpl8 mtpl9 calcmtpl1 calcmtpl3 calcmtpl4 calcmtpl6 calcmtpl7 calcmtpl10 calcmtpl14 structural1 total1 total3 total5 total6 total7 total8 total9 calctotal1 calctotal5 dmg1 dmg7 calcdmg1 calcdmg4 calcdmg5 calcdmg7 calcdmg8 calcdmg9 totalvehicle

reg calcmtpl5 mtpl8 mtpl9 calcmtpl1 calcmtpl3 calcmtpl4 calcmtpl6 calcmtpl7 calcmtpl10 calcmtpl14 structural1 total1 total3 total5 total6 total7 total8 total9 calctotal1 calctotal5 dmg1 dmg7 calcdmg1 calcdmg4 calcdmg5 calcdmg7 calcdmg8 calcdmg9 totalvehicle

xtreg calcmtpl5 mtpl8 mtpl9 calcmtpl1 calcmtpl3 calcmtpl4 calcmtpl6 calcmtpl7 calcmtpl10 calcmtpl14 structural1 total1 total3 total5 total6 total7 total8 total9 calctotal1 calctotal5 dmg1 dmg7 calcdmg1 calcdmg4 calcdmg5 calcdmg7 calcdmg8 calcdmg9 totalvehicle, fe

// Vars with > 0.4 in absolute value: calcmtpl1 calcmtpl3 calcmtpl10 structural1 calcdmg4 calcdmg8 calcdmg9 totalvehicle

reg calcmtpl5 calcmtpl1 calcmtpl3 calcmtpl10 structural1 calcdmg4 calcdmg8 calcdmg9 totalvehicle

xtreg calcmtpl5 calcmtpl1 calcmtpl3 calcmtpl10 structural1 calcdmg4 calcdmg8 calcdmg9 totalvehicle, fe

// Vars with > 0.5 in absolute value: calcmtpl3 structural1 calcdmg4 calcdmg8 totalvehicle

reg calcmtpl5 calcmtpl3 structural1 calcdmg4 calcdmg8 totalvehicle

xtreg calcmtpl5 calcmtpl3 structural1 calcdmg4 calcdmg8 totalvehicle, fe

// From GPT-4o:

gen calcmtpl2_100 = calcmtpl2*100

corr calcmtpl5 calcmtpl2 calcmtpl1 mtpl2 mtpl6 mtpl7 mtpl8

reg calcmtpl5 calcmtpl2_100 calcmtpl1 mtpl2 mtpl6 mtpl7 mtpl8
outreg2 using "$output/mtpl_regression.doc", replace
xtreg calcmtpl5 calcmtpl2_100 calcmtpl1 mtpl2 mtpl6 mtpl7 mtpl8, fe
outreg2 using "$output/mtpl_regression.doc", append

corr calcmtpl5 calcmtpl2_100 calcmtpl1 mtpl2 mtpl6 mtpl7 mtpl8 mtpl3 mtpl5 mtpl4 mtpl9

reg calcmtpl5 calcmtpl2_100 calcmtpl1 mtpl2 mtpl6 mtpl7 mtpl8 mtpl3 mtpl5 mtpl4 mtpl9
outreg2 using "$output/mtpl_regression.doc", append
xtreg calcmtpl5 calcmtpl2_100 calcmtpl1 mtpl2 mtpl6 mtpl7 mtpl8 mtpl3 mtpl5 mtpl4 mtpl9, fe
outreg2 using "$output/mtpl_regression.doc", append

*** END OF DO-FILE ***
