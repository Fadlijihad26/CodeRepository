
***************************************
/*
Author			: Fadli Jihad Dahana Setiawan
Organization	: PROSPERA
Purpose			: Obtaining NTM by OLS Residuals & SFA 
Last Modified	: October 2022
*/
***************************************

***PRELIMINARIES***

clear 			all
set 			more off

gl 				dir "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\Industry Revitalization\NTM"
cd 				"$dir"

***CONCORDANCE OF HS6 TO ISIC4(Rev3)***
import 			delimited "Concordance HS to ISIC\JobID-48_Concordance_H3_to_I3.CSV", stringcols(1 3) clear
keep 			hs2007productcode isicrevision3productcode
rename 			hs2007productcode ProductCode6d
rename 			isicrevision3productcode isic4d

save 			"Concordance HS to ISIC\concordance_hs_to_isic.dta", replace

***CLEANING - TARIFF***

use 			"Tariff\Tariff_Indonesia_2011.dta", clear

forval i = 2012/2015 {
	append 		using "Tariff\Tariff_Indonesia_`i'"
}

gen 			CountryCode = ""
replace 		CountryCode = "WLD" if PartnerName == 1
replace 		CountryCode = "CHN" if PartnerName == 2
replace 		CountryCode = "IND" if PartnerName == 3
replace 		CountryCode = "KOR" if PartnerName == 4
replace 		CountryCode = "ASN" if PartnerName == .

decode 			ProductCode, gen(strProductCode)
gen 			ProductCode6d = substr(strProductCode,1,6)
merge 			m:1 ProductCode6d using "Concordance HS to ISIC\concordance_hs_to_isic.dta"
drop 			_merge

bysort 			Year isic4d CountryCode: egen tariffavg_isic4d = mean(AdValorem)
keep 			Year ProductDescription CountryCode isic4d tariffavg_isic4d
sort 			Year isic4d CountryCode

save 			"Tariff\Tariff_Clean1.dta", replace

***CLEANING - EXPORT***

use 			"Export\Export_to_Indo_2011.dta", clear

forval i = 2012/2015 {
	append 		using "Export\Export_to_Indo_`i'"
}

decode 			ReporterName, gen(strReporterName)
gen 			CountryCode = ""
replace		 	CountryCode = "CHN" if strReporterName == "China"
replace 		CountryCode = "IND" if strReporterName == "India"
replace 		CountryCode = "KOR" if strReporterName == "Korea, Rep."
replace 		CountryCode = "ASN" if strReporterName == "Australia" | strReporterName == "Brunei" | ///
				strReporterName == "Cambodia" | strReporterName == "Malaysia" | strReporterName == "Singapore" | ///
				strReporterName == "Thailand" | strReporterName == "Vietnam" | strReporterName == "Japan" | ///
				strReporterName == "New Zealand" | strReporterName == "Lao PDR"
replace 		CountryCode = "WLD" if CountryCode == ""

decode 			ProductCode, gen(ProductCode6d)
merge 			m:1 ProductCode6d using "Concordance HS to ISIC\concordance_hs_to_isic.dta"
keep 			if _merge == 3
drop 			_merge

bysort 			Year ReporterISO3 isic4d: egen exporttotal_isic4d = total(TradeValuein1000USD)

gen 			cultural_proximity = 0
replace 		cultural_proximity = 1 if ReporterRegion == 1 | ReporterRegion == 3 | ///
				ReporterRegion == 4 | ReporterRegion == 7

keep 			ReporterISO3 isic4d ReporterName PartnerISO3 PartnerName Year strReporterName ///
				CountryCode exporttotal_isic4d cultural_proximity
sort 			Year isic4d ReporterName 

save 			"Export\Export_Clean1.dta", replace

***MERGING EXPORT AND TARIFF DATA***

use 			"Export\Export_Clean1.dta", clear

merge 			m:m Year isic4d CountryCode using "Tariff\Tariff_Clean1.dta"
sort 			Year isic4d CountryCode 
keep 			if _merge == 3
drop 			_merge

save 			"Tariff_and_Export1.dta", replace

***CLEANING & MERGING WITH OTHER DATA***

/// GDP
import 			excel "GDP\GDP_current.xls", sheet("Data") firstrow clear
drop 			CountryName
reshape 		long gdp, i(ISO3) j(Year)
sort 			Year ISO3
save 			"GDP\gdp_current.dta", replace

keep 			if ISO3 == "IDN"
rename 			ISO3 ISO3_indo
rename 			gdp gdp_indo
save 			"GDP\gdp_current_indo.dta", replace

/// Distance
import 			excel "Distance\geo_cepii.xls", firstrow clear
sum 			lat if iso3 == "IDN"
gen 			latindo = `r(mean)'
sum 			lon if iso3 == "IDN"
gen 			longindo = `r(mean)'
geodist 		latindo longindo lat lon, gen(dist_to_indo)
rename 			iso3 ISO3

gen 			same_colonizer = 0
replace 		same_colonizer = 1 if colonizer1 == "NLD" | colonizer2 == "NLD" | colonizer3 == "NLD" | colonizer4 == "NLD"
keep 			ISO3 area landlocked dist_to_indo same_colonizer
save 			"Distance\distance.dta", replace

/// LPI
import 			excel "LPI\LPI_data.xlsx", sheet("Comprehensive") firstrow clear
forvalues i = 2011/2015 {
	sum 		score if ISO3 == "IDN" & Year == `i'
	gen 		indoscore`i' = `r(mean)'
	replace 	indoscore`i' = 0 if Year != `i' 
}
egen 			lpi_indo = rowtotal(indoscore*) 
rename 			score lpi
keep 			ISO3 lpi Year lpi_indo
save 			"LPI\lpi.dta", replace

/// Merge!!!
use 			"Tariff_and_Export1.dta", clear
decode 			ReporterISO3, gen(ISO3)
decode 			PartnerISO3, gen(ISO3_indo)

merge 			m:m Year ISO3 using "GDP\gdp_current.dta"
keep 			if _merge == 3
drop 			_merge

merge 			m:1 Year ISO3_indo using "GDP\gdp_current_indo.dta"
keep 			if _merge == 3
drop 			_merge

merge 			m:m ISO3 using "Distance\distance.dta"
keep 			if _merge == 3
drop 			_merge

merge 			m:m Year ISO3 using "LPI\lpi.dta"
keep 			if _merge == 3
drop 			_merge

duplicates 		drop exporttotal_isic4d, force
sort 			Year isic4d ReporterISO3

save 			"Gravity_Model1.dta", replace

***REGRESSION***

/// Preparing for Regression
use 			"Gravity_Model1.dta", clear

gen 			lnexport = ln(exporttotal_isic4d)
gen 			lngdp = ln(gdp)
gen 			lngdpindo = ln(gdp_indo)

///		1. OLS REGRESSION		///

/// Regression
reg 			lnexport tariffavg_isic4d lngdp lngdpindo dist_to_indo landlocked ///
				area same_colonizer cultural_proximity lpi lpi_indo i.Year

/// Obtaining Residuals				
predict 		ntm_individual, residuals

/// Creating NTM Estimate by ISIC
gen 			std_ntm = ntm_individual * -1
replace 		std_ntm = 0 if std_ntm < 0
bysort 			Year isic4d: egen ntm_avg_ols_isic4d = mean(std_ntm)

///		2. FRONTIER (SFA)		///

/// SFA Regression
frontier 		lnexport tariffavg_isic4d lngdp lngdpindo dist_to_indo landlocked ///
				area same_colonizer cultural_proximity lpi lpi_indo i.Year
				
/// Obtaining (Two Type of) Residuals				
predict 		ntm_u, u
predict 		ntm_m, m

/// Creating NTM Estimate by ISIC
bysort 			Year isic4d: egen ntm_avg_sfau_isic4d = mean(ntm_u)
bysort 			Year isic4d: egen ntm_avg_sfam_isic4d = mean(ntm_m)

save 			"Gravity_Model_Clean1.dta", replace

***EXPORT DATA FOR SFA***

use 			"Gravity_Model_Clean1.dta", clear

keep 			Year isic4d ntm_avg_ols_isic4d ntm_avg_sfau_isic4d ntm_avg_sfam_isic4d
duplicates 		drop isic4d Year, force
sort 			Year isic4d

save 			"ntm_residuals_isic4d_clean.dta", replace
export 			excel using "ntm_residuals_isic4d_clean.xlsx", firstrow(variables) replace

***END OF DO-FILE***
