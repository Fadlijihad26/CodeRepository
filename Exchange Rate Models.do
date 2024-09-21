
/*

Tech Transfer Materials: ER Models
Author: Fadli Setiawan
Last Edited: July 18, 2024

*/

clear all
set more off

*** Preliminaries
gl folder "/Users/macintoshhd/Documents/0 IFG Progress/2Modules/ER Modelling"

*** Importing Data
import excel "$folder/Database for Fadli.xlsx", sheet("BEER Model") firstrow case(lower)

/// Variables Creation

gen idrusd_prev = idrusd[_n+12]
gen yoyer = (idrusd-idrusd_prev)/idrusd_prev * 100

gen cpi_previous = cpi[_n+12]
gen inflation = (cpi-cpi_previous)/cpi_previous * 100

gen realir = polrate - inflation

gen relativeprice = cpi/wpiexport

gen termsoftrade = (wpiexport/wpiimport)*100

/// Varlist

gl uirp intdiff10y
gl stickyprice m2 gdp polrate inflation
gl beer inflationgap relativeprice realir gdp termsoftrade m2nfa
gl augmentedstickyprice m2 gdp polrate inflation vix mbankrate
gl beer_v2 inflationgap relativeprice realir gdp termsoftrade m2nfa fci
gl augmentedstickyprice_v2 m2 gdp polrate inflation vix mbankrate fci

/// OLS Regression

reg yoyer $uirp
predict uirp
outreg2 using "$folder/results.doc", replace addstat(RMSE, e(rmse))

reg yoyer $stickyprice
predict stickyprice
outreg2 using "$folder/results.doc", append addstat(RMSE, e(rmse))

reg yoyer $beer
predict beer
outreg2 using "$folder/results.doc", append addstat(RMSE, e(rmse))

reg yoyer $augmentedstickyprice
predict augmentedstickyprice
outreg2 using "$folder/results.doc", append addstat(RMSE, e(rmse))

reg yoyer $beer_v2
predict beer_v2
outreg2 using "$folder/results.doc", append addstat(RMSE, e(rmse))

reg yoyer $augmentedstickyprice_v2
predict augmentedstickyprice_v2
outreg2 using "$folder/results.doc", append addstat(RMSE, e(rmse))

/// Back to IDRUSD

gen uirp_idrusd = (1 + uirp/100) * idrusd_prev
gen stickyprice_idrusd = (1 + stickyprice/100) * idrusd_prev
gen beer_idrusd = (1 + beer/100) * idrusd_prev
gen augmentedstickyprice_idrusd = (1 + augmentedstickyprice/100) * idrusd_prev
gen beer_v2_idrusd = (1 + beer_v2/100) * idrusd_prev
gen augmentedstickyprice_v2_idrusd = (1 + augmentedstickyprice_v2/100) * idrusd_prev

/*
/// Loop Version:

*OLS Regression
reg yoyer $uirp
predict uirp
outreg2 using "$folder/results.doc", replace addstat(RMSE, e(rmse))

foreach var in stickyprice beer augmentedstickyprice beer_v2 augmentedstickyprice_v2 {
	reg yoyer $`var'
	predict `var'
	outreg2 using "$folder/results.doc", append addstat(RMSE, e(rmse))
}

*Back to IDRUSD
foreach var in uirp stickyprice beer augmentedstickyprice beer_v2 augmentedstickyprice_v2 {
	gen `var'_idrusd = (1 + `var'/100) * idrusd_prev
}

*** END OF DO-FILE ***
