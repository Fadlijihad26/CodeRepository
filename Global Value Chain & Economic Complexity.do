
***************************************
/*
Author			: Fadli Jihad Dahana Setiawan
Organization	: PROSPERA
Purpose			: Testing Relationship Between GVC & ECI
Last Modified	: November 2022
*/
***************************************

*********PRELIMINARIES*********

clear 			all
set 			more off

cd 				"C:\Users\Fadli JD Setiawan\Documents\2Personal\M.Phil in Economics - Oxford\Writing Sample\GVC & ECI"

*********CLEANING*********

*Cleaning ECI*

import 			delimited "Country Complexity Rankings 1995 - 2020.csv"
keep 			country eci1995 eci1996 eci1997 eci1998 eci1999 eci2000 eci2001 eci2002 eci2003 eci2004 eci2005 eci2006 ///
				eci2007 eci2008 eci2009 eci2010 eci2011 eci2012 eci2013 eci2014 eci2015 eci2016 eci2017 eci2018 eci2019 eci2020
				
replace 		country = "People's Republic of China" if country == "China"
replace 		country = "Czech Republic" if country == "Czechia"
replace 		country = "Republic of Korea" if country == "South Korea"
replace 		country = "Slovak Republic" if country == "Slovakia"
replace 		country = "United States" if country == "United States of America"
replace 		country = "Viet Nam" if country == "Vietnam"
replace 		country = "Lao People's Democratic Republic" if country == "Laos"
replace 		country = "Kyrgyz Republic" if country == "Kyrgyzstan"

reshape 		long eci, i(country) j(year)
save 			"eci_long.dta", replace

*Cleaning GVC*

clear
import 			excel "ADB-MRIO_GVC-Indicators_2000-2007-2020.xlsx", sheet("2000, 2007-2012") cellrange(B4:K24701) firstrow case(lower)
keep 			if aggregation == "Economy"
drop 			if year == "2000"
rename 			year year_str
destring 		year_str, gen(year)
drop 			aggregation sector year_str
save 			"gvc_2007_2012.dta", replace

clear
import 			excel "ADB-MRIO_GVC-Indicators_2000-2007-2020.xlsx", sheet("2013-2019") cellrange(B4:K24701) firstrow case(lower) 
keep 			if aggregation == "Economy"
rename 			year year_str
destring 		year_str, gen(year)
drop 			aggregation sector year_str
save 			"gvc_2013_2019.dta", replace

clear
import 			excel "ADB-MRIO_GVC-Indicators_2000-2007-2020.xlsx", sheet("2020") cellrange(B4:K3532) firstrow case(lower) 
keep 			if aggregation == "Economy"
drop 			aggregation sector
save 			"gvc_2020.dta", replace

/// Appending Data
clear
use 			"gvc_2007_2012.dta"
append 			using "gvc_2013_2019.dta" 
append 			using "gvc_2020.dta"
rename 			home_country country
gen 			gvc_total = gvc_f + gvc_b
save 			"gvc_long.dta", replace

*Merging ECI & GVC*

clear
use 			"gvc_long.dta"
merge 			1:1 country year using "eci_long.dta"
keep 			if _merge == 3
drop 			_merge
sort 			year country
save 			"eci_gvc_data.dta", replace

*Cleaning GDP & FDI*
/// GDP per Capita
import 			excel "GDP_per_Capita.xls", sheet("Data") firstrow clear
rename			CountryName country

replace 		country = "Czech Republic" if country == "Czechia"
replace 		country = "Lao People's Democratic Republic" if country == "Lao PDR"
replace 		country = "People's Republic of China" if country == "China"
replace 		country = "Republic of Korea" if country == "Korea, Rep."
replace 		country = "Russia" if country == "Russia Federation"
replace 		country = "Turkey" if country == "Turkiye"
replace 		country = "Viet Nam" if country == "Vietnam"

reshape 		long gdp, i(country) j(year)
save 			"gdp_long.dta", replace

/// FDI
import 			excel "FDI_pct_GDP.xls", sheet("Data") firstrow clear
rename			CountryName country

replace 		country = "Czech Republic" if country == "Czechia"
replace 		country = "Lao People's Democratic Republic" if country == "Lao PDR"
replace 		country = "People's Republic of China" if country == "China"
replace 		country = "Republic of Korea" if country == "Korea, Rep."
replace 		country = "Russia" if country == "Russia Federation"
replace 		country = "Turkey" if country == "Turkiye"
replace 		country = "Viet Nam" if country == "Vietnam"

reshape 		long fdi, i(country) j(year)
save 			"fdi_long.dta", replace

*Merging GDP & FDI to ECI & GVC*

clear
use				"gdp_long.dta"
merge 			1:1 country year using "fdi_long.dta"
drop 			_merge
merge			1:1 country year using "eci_gvc_data.dta"
keep			if _merge == 3
drop			_merge CountryCode IndicatorName IndicatorCode
gen				ln_gdp_capita = ln(gdp)
save			"eci_gvc_data_ready.dta", replace

*********ANALYSIS*********

*Simple Linear Regression* /// Good Result, significant and positive

clear
use 			"eci_gvc_data_ready.dta"

asdoc 			reg eci gvc_f gvc_b if year > 2010, nest replace label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_f if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_b if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_total if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_f gvc_b ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_f ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_b ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)
asdoc 			reg eci gvc_total ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_ols.doc) dec(3)

*Fixed-Effect Regression* /// Good Result, significant and positive

clear
use 			"eci_gvc_data_ready.dta"
encode			country, gen(country_num)
xtset			country_num year

asdoc 			xtreg eci gvc_f gvc_b ln_gdp_capita if year > 2010, nest replace label font(Times New Roman) save(eci_gvc_fe.doc) dec(3)
asdoc 			xtreg eci gvc_f ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_fe.doc) dec(3)
asdoc 			xtreg eci gvc_b ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_fe.doc) dec(3)
asdoc 			xtreg eci gvc_total ln_gdp_capita if year > 2010, nest append label font(Times New Roman) save(eci_gvc_fe.doc) dec(3)

*Correlation Analysis* /// Good result

clear
use 			"eci_gvc_data_ready.dta"

corr 			eci gvc_f gvc_b gvc_total if year > 2010

set 			scheme white_tableau
twoway 			scatter eci gvc_f || lfit eci gvc_f if year > 2010
graph 			export "gvcforward_eciex2010.png", as(png) replace
twoway 			scatter eci gvc_b || lfit eci gvc_b if year > 2010
graph 			export "gvcbackward_eciex2010.png", as(png) replace 
twoway 			scatter eci gvc_total || lfit eci gvc_total if year > 2010
graph 			export "gvctotal_eciex2010.png", as(png) replace

*Using VWLS* // Significant and positive only for forward(on its own), backward(on its own), and total

clear
use 			"eci_gvc_data_ready.dta"

reg 			eci gvc_f gvc_b if year > 2010
hettest

reg 			eci gvc_f if year > 2010
hettest

reg 			eci gvc_b if year > 2010
hettest

reg 			eci gvc_total if year > 2010
hettest

reg 			eci gvc_f gvc_b ln_gdp_capita if year > 2010
hettest

reg 			eci gvc_f ln_gdp_capita if year > 2010
hettest

reg 			eci gvc_b ln_gdp_capita if year > 2010
hettest

reg 			eci gvc_total ln_gdp_capita if year > 2010
hettest

/// BP test shows the presence of heteroskedasticity in most equations!

egen 			sd_eci = sd(eci)

asdoc 			vwls eci gvc_f gvc_b if year > 2010, sd(sd_eci) nest replace label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_f if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_b if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_total if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_f gvc_b ln_gdp_capita if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_f ln_gdp_capita if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_b ln_gdp_capita if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)
asdoc 			vwls eci gvc_total ln_gdp_capita if year > 2010, sd(sd_eci) nest append label font(Times New Roman) save(eci_gvc_vwls.doc) dec(3)

***END OF DO FILE***