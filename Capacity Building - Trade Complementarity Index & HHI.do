

***************************************
/*
Author			: Fadli Jihad Dahana Setiawan
Organization	: PROSPERA
Purpose			: BKF Capacity Building
Last Modified	: June 2022
*/
***************************************

***PRELIMINARIES***
clear all
set more off

gl dir "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA - Fadli\zTrainings\BKF Capacity Building\"
gl tci "$dir\TCI"
gl expy "$dir\EXPY"
gl hhi "$dir\HHI"

**TCI
cd "$tci"

*TCI Indonesia to RCEP

forvalues i = 2010/2019 {
	use "OG_TCI_`i'_EXPORT_2020Jul09.dta"
	drop if ReporterISO3 != "IDN"
	keep if PartnerISO3 == "MYS" | PartnerISO3 == "SGP" | PartnerISO3 == "THA" | PartnerISO3 == "VNM" ///
	| PartnerISO3 == "PHL" | PartnerISO3 == "MMR" | PartnerISO3 == "LAO" | PartnerISO3 == "KHM" /// 
	| PartnerISO3 == "BRN" | PartnerISO3 == "AUS" | PartnerISO3 == "CHN" | PartnerISO3 == "IND" ///
	| PartnerISO3 == "JPN" | PartnerISO3 == "KOR" | PartnerISO3 == "NZL" | PartnerISO3 == "WLD"
	save "TCI_IndoRCEP`i'.dta", replace
}

clear
use "TCI_IndoRCEP2010.dta"

forvalues i = 2011/2019 {
	append using "TCI_IndoRCEP`i'.dta"
}

save "TCI_IndoRCEP2010-2019.dta", replace

*TCI RCEP to Indonesia

forvalues i = 2010/2019 {
	use "OG_TCI_`i'_EXPORT_2020Jul09.dta"
	keep if ReporterISO3 == "MYS" | ReporterISO3 == "SGP" | ReporterISO3 == "THA" | ReporterISO3 == "VNM" ///
	| ReporterISO3 == "PHL" | ReporterISO3 == "MMR" | ReporterISO3 == "LAO" | ReporterISO3 == "KHM" /// 
	| ReporterISO3 == "BRN" | ReporterISO3 == "AUS" | ReporterISO3 == "CHN" | ReporterISO3 == "IND" ///
	| ReporterISO3 == "JPN" | ReporterISO3 == "KOR" | ReporterISO3 == "NZL" |PartnerISO3 == "WLD"
	drop if PartnerISO3 != "IDN"
	save "TCI_RCEPIndo`i'.dta", replace
}

clear
use "TCI_IndoRCEP2010-2019.dta"

forvalues i = 2011/2019 {
	append using "TCI_RCEPIndo`i'"
}

save, replace

**EXPY
cd "$expy"

*EXPY Indonesia to RCEP

forvalues i = 2010/2019 {
	use "ES_EXPY_`i'_EXPORT_2020Jul09.dta"
	drop if ReporterISO3 != "IDN"
	keep if PartnerISO3 == "MYS" | PartnerISO3 == "SGP" | PartnerISO3 == "THA" | PartnerISO3 == "VNM" ///
	| PartnerISO3 == "PHL" | PartnerISO3 == "MMR" | PartnerISO3 == "LAO" | PartnerISO3 == "KHM" /// 
	| PartnerISO3 == "BRN" | PartnerISO3 == "AUS" | PartnerISO3 == "CHN" | PartnerISO3 == "IND" ///
	| PartnerISO3 == "JPN" | PartnerISO3 == "KOR" | PartnerISO3 == "NZL" |PartnerISO3 == "WLD"
	save "EXPY_IndoRCEP`i'.dta", replace
}

clear
use "EXPY_IndoRCEP2010.dta"

forvalues i = 2011/2019 {
	append using "EXPY_IndoRCEP`i'.dta"
}

save "EXPY_IndoRCEP2010-2019.dta", replace

*EXPY RCEP to Indonesia

forvalues i = 2010/2019 {
	use "ES_EXPY_`i'_EXPORT_2020Jul09.dta"
	keep if ReporterISO3 == "MYS" | ReporterISO3 == "SGP" | ReporterISO3 == "THA" | ReporterISO3 == "VNM" ///
	| ReporterISO3 == "PHL" | ReporterISO3 == "MMR" | ReporterISO3 == "LAO" | ReporterISO3 == "KHM" /// 
	| ReporterISO3 == "BRN" | ReporterISO3 == "AUS" | ReporterISO3 == "CHN" | ReporterISO3 == "IND" ///
	| ReporterISO3 == "JPN" | ReporterISO3 == "KOR" | ReporterISO3 == "NZL" |PartnerISO3 == "WLD"
	drop if PartnerISO3 != "IDN"
	save "EXPY_RCEPIndo`i'.dta", replace
}

clear
use "EXPY_IndoRCEP2010-2019.dta"

forvalues i = 2011/2019 {
	append using "EXPY_RCEPIndo`i'"
}

save, replace

**HHI
cd "$hhi"

*HHI Indonesia to RCEP

forvalues i = 2010/2019 {
	use "ED_HHPCI_`i'_EXPORT_2020Jul09"
	drop if ReporterISO3 != "IDN"
	keep if PartnerISO3 == "MYS" | PartnerISO3 == "SGP" | PartnerISO3 == "THA" | PartnerISO3 == "VNM" ///
	| PartnerISO3 == "PHL" | PartnerISO3 == "MMR" | PartnerISO3 == "LAO" | PartnerISO3 == "KHM" /// 
	| PartnerISO3 == "BRN" | PartnerISO3 == "AUS" | PartnerISO3 == "CHN" | PartnerISO3 == "IND" ///
	| PartnerISO3 == "JPN" | PartnerISO3 == "KOR" | PartnerISO3 == "NZL" |PartnerISO3 == "WLD"
	save "HHI_IndoRCEP`i'.dta", replace
}

clear
use "HHI_IndoRCEP2010.dta"

forvalues i = 2011/2019 {
	append using "HHI_IndoRCEP`i'.dta"
}

save "HHI_IndoRCEP2010-2019.dta", replace

*HHI RCEP to Indonesia

forvalues i = 2010/2019 {
	use "ED_HHPCI_`i'_EXPORT_2020Jul09"
	keep if ReporterISO3 == "MYS" | ReporterISO3 == "SGP" | ReporterISO3 == "THA" | ReporterISO3 == "VNM" ///
	| ReporterISO3 == "PHL" | ReporterISO3 == "MMR" | ReporterISO3 == "LAO" | ReporterISO3 == "KHM" /// 
	| ReporterISO3 == "BRN" | ReporterISO3 == "AUS" | ReporterISO3 == "CHN" | ReporterISO3 == "IND" ///
	| ReporterISO3 == "JPN" | ReporterISO3 == "KOR" | ReporterISO3 == "NZL" |PartnerISO3 == "WLD"
	drop if PartnerISO3 != "IDN"
	save "HHI_RCEPIndo`i'.dta", replace
}

clear
use "HHI_IndoRCEP2010-2019.dta"

forvalues i = 2011/2019 {
	append using "HHI_RCEPIndo`i'"
}

save, replace