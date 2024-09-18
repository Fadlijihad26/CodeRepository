
/*

Decoding Global Portfolio Investment Flow

Author: Fadli Setiawan
Last Edited: June 25, 2024

*/

clear all
set more off

gl folder "/Users/macintoshhd/Documents/0 IFG Progress/1Projects/Stock Exchange Volume/CEIC"
gl countries "argentina australia austria belgium brazil canada chile china colombia denmark finland france germany greece hungary india indonesia ireland italy japan mexico netherlands newzealand norway poland portugal saudiarabia slovenia southafrica spain sweden switzerland unitedkingdom unitedstates"

*** CLEANING AND MERGING ***

foreach var in gdpqoq npi pricereturn {
	import excel "$folder/NPI & GDP v3.xlsx", sheet("`var'") firstrow case(lower)
	keep $countries quarter
	renvars $countries, pref(`var')
	reshape long `var', i(quarter) j(country) string
	sort country quarter
	export excel using "$folder/`var'.xlsx", replace firstrow(variables)
	save "$folder/`var'.dta", replace
	clear
}

use "$folder/gdpqoq.dta"

foreach var in npi pricereturn {
	merge 1:1 country quarter using "$folder/`var'.dta"
	drop _merge
}

save "$folder/temp1.dta", replace

*** ANALYSIS ***

use "$folder/temp1.dta", clear

/// Create standardized vars

foreach var in gdpqoq npi pricereturn {	
	egen std_`var' = std(`var')
	sort country quarter
}

/// Diff!

gen diff = std_gdpqoq - std_pricereturn
bysort country: egen meandiff = mean(diff) 

gen meandiff_abs = abs(meandiff)

sum meandiff_abs, d
gen efficiency_lvl = 0
replace efficiency_lvl = 1 if meandiff_abs < r(p50)
replace efficiency_lvl = 2 if meandiff_abs >= r(p50)

/// Quarters to Period!

gen quarter_date = qofd(quarter)
format quarter_date %tq

gen period = 0 
replace period = 1 if quarter_date < tq(1998q1)
replace period = 2 if quarter_date >= tq(1998q1) & quarter_date < tq(2008q1)
replace period = 3 if quarter_date >= tq(2008q1) & quarter_date < tq(2013q1)
replace period = 4 if quarter_date >= tq(2013q1) & quarter_date < tq(2021q1)
replace period = 5 if quarter_date >= tq(2021q1)

tab period

/// Means of Diff!!

bysort country: egen meandiff_abs_total = mean(meandiff_abs)
bysort country: egen std_npi_total = mean(std_npi)

bysort country period: egen meandiff_abs_periodic = mean(meandiff_abs)
bysort country period: egen std_npi_periodic = mean(std_npi)

save "$folder/ready.dta", replace

/// Visualization - Pt 1: Slope

use "$folder/ready.dta", clear

set scheme white_tableau

*Total
twoway (scatter std_npi_total meandiff_abs_total, mlabel(country))(lfit std_npi_total meandiff_abs_total) if quarter_date == tq(2020q4), ytitle("Standardized Net Portfolio Inflow") xtitle("Mean Difference of Standardized QoQ GDP vs Standardized Price Returns")
graph export "$folder/zGraphs/Graph1.png", as(png) replace

*Periodic
twoway (scatter std_npi_periodic meandiff_abs_periodic, mlabel(country))(lfit std_npi_periodic meandiff_abs_periodic) if period == 1, ytitle("Standardized Net Portfolio Inflow") xtitle("Mean Difference of Standardized QoQ GDP vs Standardized Price Returns")
graph export "$folder/zGraphs/Graph2.png", as(png) replace

twoway (scatter std_npi_periodic meandiff_abs_periodic, mlabel(country))(lfit std_npi_periodic meandiff_abs_periodic) if period == 2, ytitle("Standardized Net Portfolio Inflow") xtitle("Mean Difference of Standardized QoQ GDP vs Standardized Price Returns")
graph export "$folder/zGraphs/Graph3.png", as(png) replace

twoway (scatter std_npi_periodic meandiff_abs_periodic, mlabel(country))(lfit std_npi_periodic meandiff_abs_periodic) if period == 3, ytitle("Standardized Net Portfolio Inflow") xtitle("Mean Difference of Standardized QoQ GDP vs Standardized Price Returns")
graph export "$folder/zGraphs/Graph4.png", as(png) replace

twoway (scatter std_npi_periodic meandiff_abs_periodic, mlabel(country))(lfit std_npi_periodic meandiff_abs_periodic) if period == 4, ytitle("Standardized Net Portfolio Inflow") xtitle("Mean Difference of Standardized QoQ GDP vs Standardized Price Returns")
graph export "$folder/zGraphs/Graph5.png", as(png) replace

twoway (scatter std_npi_periodic meandiff_abs_periodic, mlabel(country))(lfit std_npi_periodic meandiff_abs_periodic) if period == 5, ytitle("Standardized Net Portfolio Inflow") xtitle("Mean Difference of Standardized QoQ GDP vs Standardized Price Returns")
graph export "$folder/zGraphs/Graph6.png", as(png) replace

/// Visualization - Pt 2: Time Series

bysort efficiency_lvl quarter: egen meannpi_std = mean(std_npi)
bysort efficiency_lvl quarter: egen meannpi = mean(npi)
set scheme white_viridis

***** by Efficiency

twoway (line meannpi_std quarter if efficiency_lvl == 1, lcolor(blue)), ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter")
graph export "$folder/zGraphs/Graph7.png", as(png) replace

twoway (line meannpi_std quarter if efficiency_lvl == 2, lcolor(red)), ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter")
graph export "$folder/zGraphs/Graph8.png", as(png) replace

***** byPeriod

twoway (line meannpi_std quarter if efficiency_lvl == 1, lcolor(blue)) ///
       (line meannpi_std quarter if efficiency_lvl == 2, lcolor(red)) ///
	   if period == 1, by(efficiency_lvl) ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter") legend(order(1 "Eff. Level 1" 2 "Eff. Level 2"))
graph export "$folder/zGraphs/Graph9.png", as(png) replace
	   
twoway (line meannpi_std quarter if efficiency_lvl == 1, lcolor(blue)) ///
       (line meannpi_std quarter if efficiency_lvl == 2, lcolor(red)) ///
	   if period == 2, by(efficiency_lvl) ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter") legend(order(1 "Eff. Level 1" 2 "Eff. Level 2"))
graph export "$folder/zGraphs/Graph10.png", as(png) replace
	   
twoway (line meannpi_std quarter if efficiency_lvl == 1, lcolor(blue)) ///
       (line meannpi_std quarter if efficiency_lvl == 2, lcolor(red)) ///
	   if period == 3, by(efficiency_lvl) ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter") legend(order(1 "Eff. Level 1" 2 "Eff. Level 2"))
graph export "$folder/zGraphs/Graph11.png", as(png) replace
	   
twoway (line meannpi_std quarter if efficiency_lvl == 1, lcolor(blue)) ///
       (line meannpi_std quarter if efficiency_lvl == 2, lcolor(red)) ///
	   if period == 4, by(efficiency_lvl) ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter") legend(order(1 "Eff. Level 1" 2 "Eff. Level 2"))
graph export "$folder/zGraphs/Graph12.png", as(png) replace	
	
twoway (line meannpi_std quarter if efficiency_lvl == 1, lcolor(blue)) ///
       (line meannpi_std quarter if efficiency_lvl == 2, lcolor(red)) ///
	   if period == 5, by(efficiency_lvl) ytitle("Standardized Net Portfolio Inflow") xtitle("Quarter") legend(order(1 "Eff. Level 1" 2 "Eff. Level 2"))
graph export "$folder/zGraphs/Graph13.png", as(png) replace
	   
/// T-Test

ttest std_npi_total, by (efficiency_lvl) unequal
ttest std_npi_periodic if period == 1, by (efficiency_lvl) unequal
ttest std_npi_periodic if period == 2, by (efficiency_lvl) unequal
ttest std_npi_periodic if period == 3, by (efficiency_lvl) unequal
ttest std_npi_periodic if period == 4, by (efficiency_lvl) unequal
ttest std_npi_periodic if period == 5, by (efficiency_lvl) unequal

/// Regression 

reg std_npi meandiff_abs, robust
outreg2 using "$folder/regression.doc", replace

reg std_npi meandiff_abs if period == 1, robust
outreg2 using "$folder/regression.doc", append

reg std_npi meandiff_abs if period == 2, robust
outreg2 using "$folder/regression.doc", append

reg std_npi meandiff_abs if period == 3, robust
outreg2 using "$folder/regression.doc", append

reg std_npi meandiff_abs if period == 4, robust
outreg2 using "$folder/regression.doc", append

reg std_npi meandiff_abs if period == 5, robust
outreg2 using "$folder/regression.doc", append

/// More Graphs

import excel "$folder/NPI & GDP v3.xlsx", sheet("Sheet1") firstrow case(lower) clear

twoway (line flow quarter if type == "EM", lcolor(blue)) ///
       (line flow quarter if type == "AM", lcolor(red)) ///
	   , by(type) ytitle("Net Portfolio Inflow") xtitle("Quarter") 
graph export "$folder/zGraphs/Graph14.png", as(png) replace

/// Additionals

use "$folder/ready.dta", clear

set scheme white_tableau

gen diff_abs = abs(diff)
histogram diff_abs

reg std_npi diff_abs, robust
outreg2 using "$folder/regression2.doc", replace

reg std_npi diff_abs if period == 1, robust
outreg2 using "$folder/regression2.doc", append

reg std_npi diff_abs if period == 2, robust
outreg2 using "$folder/regression2.doc", append

reg std_npi diff_abs if period == 3, robust
outreg2 using "$folder/regression2.doc", append

reg std_npi diff_abs if period == 4, robust
outreg2 using "$folder/regression2.doc", append

reg std_npi diff_abs if period == 5, robust
outreg2 using "$folder/regression2.doc", append

drop if diff_abs > 5.8

reg std_npi diff_abs, robust
outreg2 using "$folder/regression3.doc", replace

reg std_npi diff_abs if period == 1, robust
outreg2 using "$folder/regression3.doc", append

reg std_npi diff_abs if period == 2, robust
outreg2 using "$folder/regression3.doc", append

reg std_npi diff_abs if period == 3, robust
outreg2 using "$folder/regression3.doc", append

reg std_npi diff_abs if period == 4, robust
outreg2 using "$folder/regression3.doc", append

reg std_npi diff_abs if period == 5, robust
outreg2 using "$folder/regression3.doc", append

*** END OF DO-FILE ***
