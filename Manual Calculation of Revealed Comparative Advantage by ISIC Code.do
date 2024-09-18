
***************************************
/*
Author			: Fadli Jihad Dahana Setiawan
Organization	: PROSPERA
Purpose			: RCA by ISIC
Last Modified	: September 2022
*/
***************************************

***PRELIMINARIES***
clear all
set more off

***SETTING DIRECTORIES***

gl rcadir "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\RCEP Action Plan\Preparatory Works\Quantitative Explorations\Export Potential Map & RCA\UNIDO Data"
cd "$rcadir"

***CLEANING DATA***

clear
import excel "Exports by ISIC.xlsx", sheet("Data") firstrow 

drop ISICCombination 
foreach var in CountryCode ISIC ExportsWorld Year {
	destring `var', gen(num_`var') force
}
drop if num_ExportsWorld == .
drop if num_Year < 2010

***RCA CALCULATIONS***

/// Market Share of each goods in each country

bysort num_CountryCode Year: egen totalexport_country = total(num_ExportsWorld)
sort num_CountryCode Year num_ISIC
gen ms_goods_country = num_ExportsWorld / totalexport_country

/// Market Share of each goods in world

bysort num_ISIC Year: egen totalexport_goods = total(num_ExportsWorld)
bysort Year: egen totalexport_worldyearly = total(num_ExportsWorld)
sort num_CountryCode Year num_ISIC
gen ms_goods_product = totalexport_goods / totalexport_worldyearly

/// RCA 

gen rca_isic = ms_goods_country / ms_goods_product
gen dummy_rca_isic = rca_isic >= 1
tab dummy_rca_isic

export excel using "world-RCA-Comprehensive-Long.xlsx", firstrow(variables) replace
save "rca_world_long.dta", replace

***INDONESIA'S COMPETITIVENESS ASSESSMENT***

clear 
use "rca_world_long.dta"

*RCA > 1 for Indonesia during 2010-2019 (Total)
tab dummy_rca_isic if num_CountryCode == 360 

*RCA > 1 for Indonesia at 2019
tab dummy_rca_isic if num_CountryCode == 360 & num_Year == 2019

*RCA > 1 for Indonesia during 2010-2019 (Yearly)
tab num_Year dummy_rca_isic if num_CountryCode == 360 

*Cross-Country Assessments

/// Cross-country Competitiveness Analysis can only be assessed for 2019 because reshaping data to wide require unique identifiers (in this case that would be ISIC code).

drop if num_Year < 2019
keep num_CountryCode num_ISIC rca_isic
reshape wide rca_isic, i(num_ISIC) j(num_CountryCode)

rename rca_isic36 rca_Australia
rename rca_isic104 rca_Myanmar
rename rca_isic156 rca_China
rename rca_isic360 rca_Indonesia
rename rca_isic392 rca_Japan
rename rca_isic410 rca_Korea
rename rca_isic418 rca_LaoPDR
rename rca_isic458 rca_Malaysia
rename rca_isic554 rca_NewZealand
rename rca_isic608 rca_Philippines
rename rca_isic702 rca_Singapore
rename rca_isic704 rca_Vietnam
rename rca_isic764 rca_Thailand

keep num_ISIC rca_Australia rca_Myanmar rca_China rca_Indonesia rca_Japan rca_Korea rca_LaoPDR rca_Malaysia rca_NewZealand ///
rca_Philippines rca_Singapore rca_Vietnam rca_Thailand

/// Note: Brunei & Cambodia dont have data on ISIC Rev 4. However, on ISIC Rev 3, it is Myanmar the one that does not have data.
/// So, it is better to still do the analysis on the most updated one, ISIC Rev 4. 

*Competitive V1 --> If Indonesia has the highest RCA in that ISIC compared to other countries in RCEP
gen idn_more_competitive_v1 = 0
replace idn_more_competitive_v1 = 1 if rca_Indonesia > rca_Australia & rca_Indonesia > rca_China & rca_Indonesia > rca_Japan ///
& rca_Indonesia > rca_Korea & rca_Indonesia > rca_LaoPDR & rca_Indonesia > rca_Malaysia & rca_Indonesia > rca_NewZealand ///
& rca_Indonesia > rca_Philippines & rca_Indonesia > rca_Singapore & rca_Indonesia > rca_Vietnam & rca_Indonesia > rca_Thailand ///
& rca_Indonesia > rca_Myanmar
tab idn_more_competitive_v1

*Competitive V2 --> If Indonesia has the highest RCA in that ISIC compared to other countries in RCEP-5 (excl. ASEAN)
gen idn_more_competitive_v2 = 0
replace idn_more_competitive_v2 = 1 if rca_Indonesia > rca_Australia & rca_Indonesia > rca_China & rca_Indonesia > rca_Japan & ///
rca_Indonesia > rca_Korea & rca_Indonesia > rca_NewZealand
tab idn_more_competitive_v2

*Competitive V3 --> If Indonesia has RCA of > 1
gen idn_more_competitive_v3 = 0
replace idn_more_competitive_v3 = 1 if rca_Indonesia >= 1
tab idn_more_competitive_v3

br if idn_more_competitive_v1 == 1
br if idn_more_competitive_v2 == 1
br if idn_more_competitive_v3 == 1

export excel using "World RCA Comparison Indonesia vs RCEP (2019).xlsx", firstrow(variables) replace

***END OF DO FILE***