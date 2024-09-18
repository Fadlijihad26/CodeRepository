
***************************************
/*
Author			: Fadli Jihad Dahana Setiawan
Organization	: PROSPERA
Purpose			: Data Visualizationn for Market Revitalization Project
Last Modified	: July 2022
*/
***************************************

***PRELIMINARIES***
clear all
set more off
set dp comma

***SETTING DIRECTORIES***

gl marketdir "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\Perdagangan Besar dan Revitalisasi Pasar Rakyat\Studi Literatur - Tujuan & Dampak Revitalisasi\Model Ekonometrika\Data Direktori Pasar"
gl graphs "$marketdir\Graphs"
gl results "$marketdir\Results"
macro list

cd "$marketdir"

***********DATA VISUALIZATION***********
clear
use "DirektoriPasar(Ready).dta"

***GENERAL***

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1, replace save($results\Asdoc\direct_comparison_categorical1.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1, append save($results\Asdoc\direct_comparison_categorical1.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1, append save($results\Asdoc\direct_comparison_categorical1.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1, append save($results\Asdoc\direct_comparison_categorical1.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0, replace save($results\Asdoc\direct_comparison_categorical2.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0, append save($results\Asdoc\direct_comparison_categorical2.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0, append save($results\Asdoc\direct_comparison_categorical2.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0, append save($results\Asdoc\direct_comparison_categorical2.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0
}

***EXTENDED DESCRIPTIVE STATISTICS***

***REVITALIZED
clear
use "DirektoriPasar(Ready).dta"
keep if REVITALISASI == 1

**Median

*2014
egen median2014_general = median(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen median2014_`var' = median(NIGHTLIGHT_2014AV)
}

*2021
egen median2021_general = median(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen median2021_`var' = median(NIGHTLIGHT_2021AV)
}

**Std

*2014
egen std2014_general = std(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen std2014_`var' = std(NIGHTLIGHT_2014AV)
}

*2021
egen std2021_general = std(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen std2021_`var' = std(NIGHTLIGHT_2021AV)
}

**Min

*2014
egen min2014_general = min(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen min2014_`var' = min(NIGHTLIGHT_2014AV)
}

*2021
egen min2021_general = min(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen min2021_`var' = min(NIGHTLIGHT_2021AV)
}

**Max

*2014
egen max2014_general = max(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen max2014_`var' = max(NIGHTLIGHT_2014AV)
}

*2021
egen max2021_general = max(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen max2021_`var' = max(NIGHTLIGHT_2021AV)
}

export excel using "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\Perdagangan Besar dan Revitalisasi Pasar Rakyat\Studi Literatur - Tujuan & Dampak Revitalisasi\Model Ekonometrika\Data Direktori Pasar\Extended Descriptive Statistics (Revitalized).xls", firstrow(variables) replace

**PUTEXCEL

foreach var in JENIS_BANGUNAN WAKTU KOMODITAS KOTA SUMATERA_JAWA {
	recode `var' (0=2)
}

putexcel set revitalized_eds, replace

putexcel A1 = "Variable"
putexcel A2 = "All variables are already in their categorical order"
putexcel B1 = "Median"
putexcel D1 = "Std"
putexcel F1 = "Min"
putexcel H1 = "Max"
putexcel B2 = "2014"
putexcel C2 = "2021"
putexcel D2 = "2014"
putexcel E2 = "2021"
putexcel F2 = "2014"
putexcel G2 = "2021"
putexcel H2 = "2014"
putexcel I2 = "2021"
putexcel A3 = "JUMLAH_PEDAGANG"
putexcel A9 = "DENSITAS_CATEGORICAL"
putexcel A14 = "PENGELOLA_CATEGORICAL"
putexcel A19 = "JENIS_BANGUNAN"
putexcel A22 = "WAKTU"
putexcel A25 = "KOMODITAS"
putexcel A28 = "KOTA"
putexcel A31 = "SUMATERA_JAWA"
putexcel A34 = "UMUR_CATEGORICAL"
putexcel A38 = "GENERAL"

sum median2014_general
putexcel B38 = `r(mean)'
sum median2021_general
putexcel C38 = `r(mean)'
sum std2014_general
putexcel D38 = `r(mean)'
sum std2021_general
putexcel E38 = `r(mean)'
sum min2014_general
putexcel F38 = `r(mean)'
sum min2021_general
putexcel G38 = `r(mean)'
sum max2014_general
putexcel H38 = `r(mean)'
sum max2021_general
putexcel I38 = `r(mean)'

*Median
forvalues i = 1/5 {
	loc n = `i' + 2
	sum median2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum median2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum median2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum median2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum median2014_WAKTU if WAKTU == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_WAKTU if WAKTU == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum median2014_KOMODITAS if KOMODITAS == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_KOMODITAS if KOMODITAS == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum median2014_KOTA if KOTA == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_KOTA if KOTA == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum median2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum median2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

*Std
forvalues i = 1/5 {
	loc n = `i' + 2
	sum std2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum std2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum std2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum std2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum std2014_WAKTU if WAKTU == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_WAKTU if WAKTU == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum std2014_KOMODITAS if KOMODITAS == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_KOMODITAS if KOMODITAS == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum std2014_KOTA if KOTA == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_KOTA if KOTA == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum std2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum std2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

*Min
forvalues i = 1/5 {
	loc n = `i' + 2
	sum min2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum min2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum min2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum min2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum min2014_WAKTU if WAKTU == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_WAKTU if WAKTU == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum min2014_KOMODITAS if KOMODITAS == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_KOMODITAS if KOMODITAS == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum min2014_KOTA if KOTA == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_KOTA if KOTA == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum min2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum min2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

*Max
forvalues i = 1/5 {
	loc n = `i' + 2
	sum max2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum max2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum max2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum max2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum max2014_WAKTU if WAKTU == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_WAKTU if WAKTU == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum max2014_KOMODITAS if KOMODITAS == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_KOMODITAS if KOMODITAS == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum max2014_KOTA if KOTA == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_KOTA if KOTA == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum max2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum max2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

***NON-REVITALIZED
clear
use "DirektoriPasar(Ready).dta"
keep if REVITALISASI == 0

**Median

*2014
egen median2014_general = median(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen median2014_`var' = median(NIGHTLIGHT_2014AV)
}

*2021
egen median2021_general = median(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen median2021_`var' = median(NIGHTLIGHT_2021AV)
}

**Std

*2014
egen std2014_general = std(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen std2014_`var' = std(NIGHTLIGHT_2014AV)
}

*2021
egen std2021_general = std(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen std2021_`var' = std(NIGHTLIGHT_2021AV)
}

**Min

*2014
egen min2014_general = min(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen min2014_`var' = min(NIGHTLIGHT_2014AV)
}

*2021
egen min2021_general = min(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen min2021_`var' = min(NIGHTLIGHT_2021AV)
}

**Max

*2014
egen max2014_general = max(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen max2014_`var' = max(NIGHTLIGHT_2014AV)
}

*2021
egen max2021_general = max(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': egen max2021_`var' = max(NIGHTLIGHT_2021AV)
}

export excel using "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\Perdagangan Besar dan Revitalisasi Pasar Rakyat\Studi Literatur - Tujuan & Dampak Revitalisasi\Model Ekonometrika\Data Direktori Pasar\Extended Descriptive Statistics (Non-Revitalized).xls", firstrow(variables) replace

**PUTEXCEL

foreach var in JENIS_BANGUNAN WAKTU KOMODITAS KOTA SUMATERA_JAWA {
	recode `var' (0=2)
}

putexcel set non-revitalized_eds, replace

putexcel A1 = "Variable"
putexcel A2 = "All variables are already in their categorical order"
putexcel B1 = "Median"
putexcel D1 = "Std"
putexcel F1 = "Min"
putexcel H1 = "Max"
putexcel B2 = "2014"
putexcel C2 = "2021"
putexcel D2 = "2014"
putexcel E2 = "2021"
putexcel F2 = "2014"
putexcel G2 = "2021"
putexcel H2 = "2014"
putexcel I2 = "2021"
putexcel A3 = "JUMLAH_PEDAGANG"
putexcel A9 = "DENSITAS_CATEGORICAL"
putexcel A14 = "PENGELOLA_CATEGORICAL"
putexcel A19 = "JENIS_BANGUNAN"
putexcel A22 = "WAKTU"
putexcel A25 = "KOMODITAS"
putexcel A28 = "KOTA"
putexcel A31 = "SUMATERA_JAWA"
putexcel A34 = "UMUR_CATEGORICAL"
putexcel A38 = "GENERAL"

sum median2014_general
putexcel B38 = `r(mean)'
sum median2021_general
putexcel C38 = `r(mean)'
sum std2014_general
putexcel D38 = `r(mean)'
sum std2021_general
putexcel E38 = `r(mean)'
sum min2014_general
putexcel F38 = `r(mean)'
sum min2021_general
putexcel G38 = `r(mean)'
sum max2014_general
putexcel H38 = `r(mean)'
sum max2021_general
putexcel I38 = `r(mean)'

*Median
forvalues i = 1/5 {
	loc n = `i' + 2
	sum median2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum median2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum median2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum median2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum median2014_WAKTU if WAKTU == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_WAKTU if WAKTU == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum median2014_KOMODITAS if KOMODITAS == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_KOMODITAS if KOMODITAS == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum median2014_KOTA if KOTA == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_KOTA if KOTA == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum median2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum median2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

*Std
forvalues i = 1/5 {
	loc n = `i' + 2
	sum std2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum std2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum std2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum std2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum std2014_WAKTU if WAKTU == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_WAKTU if WAKTU == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum std2014_KOMODITAS if KOMODITAS == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_KOMODITAS if KOMODITAS == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum std2014_KOTA if KOTA == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_KOTA if KOTA == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum std2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum std2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

*Min
forvalues i = 1/5 {
	loc n = `i' + 2
	sum min2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum min2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum min2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum min2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum min2014_WAKTU if WAKTU == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_WAKTU if WAKTU == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum min2014_KOMODITAS if KOMODITAS == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_KOMODITAS if KOMODITAS == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum min2014_KOTA if KOTA == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_KOTA if KOTA == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum min2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum min2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

*Max
forvalues i = 1/5 {
	loc n = `i' + 2
	sum max2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum max2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum max2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum max2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum max2014_WAKTU if WAKTU == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_WAKTU if WAKTU == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 24
	sum max2014_KOMODITAS if KOMODITAS == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_KOMODITAS if KOMODITAS == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 27
	sum max2014_KOTA if KOTA == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_KOTA if KOTA == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 30
	sum max2014_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_SUMATERA_JAWA if SUMATERA_JAWA == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 33
	sum max2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

***BY JUMLAH PEDAGANG***
clear
use "DirektoriPasar(Ready).dta"
tab JUMLAH_PEDAGANG, nolabel

**Jumlah Pedagang < 100 (==1)

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 1, replace save($results\Asdoc\direct_comparison_jmlhpedagang11.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 1, append save($results\Asdoc\direct_comparison_jmlhpedagang11.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 1, append save($results\Asdoc\direct_comparison_jmlhpedagang11.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 1, append save($results\Asdoc\direct_comparison_jmlhpedagang11.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 1, replace save($results\Asdoc\direct_comparison_jmlhpedagang12.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 1, append save($results\Asdoc\direct_comparison_jmlhpedagang12.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 1, append save($results\Asdoc\direct_comparison_jmlhpedagang12.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 1, append save($results\Asdoc\direct_comparison_jmlhpedagang12.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 1
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 1
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 1
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 1
}

**Jumlah Pedagang 100-199 (==2)

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 2, replace save($results\Asdoc\direct_comparison_jmlhpedagang21.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 2, append save($results\Asdoc\direct_comparison_jmlhpedagang21.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 2, append save($results\Asdoc\direct_comparison_jmlhpedagang21.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 2, append save($results\Asdoc\direct_comparison_jmlhpedagang21.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 2, replace save($results\Asdoc\direct_comparison_jmlhpedagang22.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 2, append save($results\Asdoc\direct_comparison_jmlhpedagang22.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 2, append save($results\Asdoc\direct_comparison_jmlhpedagang22.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 2, append save($results\Asdoc\direct_comparison_jmlhpedagang22.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 2
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 2
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 2
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 2
}

**Jumlah Pedagang 200-274 (==3)

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 3, replace save($results\Asdoc\direct_comparison_jmlhpedagang31.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 3, append save($results\Asdoc\direct_comparison_jmlhpedagang31.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 3, append save($results\Asdoc\direct_comparison_jmlhpedagang31.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 3, append save($results\Asdoc\direct_comparison_jmlhpedagang31.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 3, replace save($results\Asdoc\direct_comparison_jmlhpedagang32.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 3, append save($results\Asdoc\direct_comparison_jmlhpedagang32.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 3, append save($results\Asdoc\direct_comparison_jmlhpedagang32.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 3, append save($results\Asdoc\direct_comparison_jmlhpedagang32.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 3
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 3
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 3
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 3
}

**Jumlah Pedagang 275-400 (==4)

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 4, replace save($results\Asdoc\direct_comparison_jmlhpedagang41.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 4, append save($results\Asdoc\direct_comparison_jmlhpedagang41.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 4, append save($results\Asdoc\direct_comparison_jmlhpedagang41.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 4, append save($results\Asdoc\direct_comparison_jmlhpedagang41.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 4, replace save($results\Asdoc\direct_comparison_jmlhpedagang42.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 4, append save($results\Asdoc\direct_comparison_jmlhpedagang42.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 4, append save($results\Asdoc\direct_comparison_jmlhpedagang42.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 4, append save($results\Asdoc\direct_comparison_jmlhpedagang42.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 4
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 4
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 4
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 4
}

**Jumlah Pedagang >400 (==5)

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 5, replace save($results\Asdoc\direct_comparison_jmlhpedagang51.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 5, append save($results\Asdoc\direct_comparison_jmlhpedagang51.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 5, append save($results\Asdoc\direct_comparison_jmlhpedagang51.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 5, append save($results\Asdoc\direct_comparison_jmlhpedagang51.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 5, replace save($results\Asdoc\direct_comparison_jmlhpedagang52.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 5, append save($results\Asdoc\direct_comparison_jmlhpedagang52.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 5, append save($results\Asdoc\direct_comparison_jmlhpedagang52.doc) font(Arial) fs(8)
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 5, append save($results\Asdoc\direct_comparison_jmlhpedagang52.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 5
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & JUMLAH_PEDAGANG == 5
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 5
foreach var in DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & JUMLAH_PEDAGANG == 5
}

***BY URBAN/RURAL***
clear
use "DirektoriPasar(Ready).dta"
tab KOTA, nolabel

**Kota==1

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & KOTA == 1, replace save($results\Asdoc\direct_comparison_kota11.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & KOTA == 1, append save($results\Asdoc\direct_comparison_kota11.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 1, append save($results\Asdoc\direct_comparison_kota11.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 1, append save($results\Asdoc\direct_comparison_kota11.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & KOTA == 1, replace save($results\Asdoc\direct_comparison_kota12.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & KOTA == 1, append save($results\Asdoc\direct_comparison_kota12.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 1, append save($results\Asdoc\direct_comparison_kota12.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 1, append save($results\Asdoc\direct_comparison_kota12.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if KOTA == 1

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 1
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 1
}

**Kota==0 (Rural)

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & KOTA == 0, replace save($results\Asdoc\direct_comparison_kota01.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & KOTA == 0, append save($results\Asdoc\direct_comparison_kota01.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 0, append save($results\Asdoc\direct_comparison_kota01.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 0, append save($results\Asdoc\direct_comparison_kota01.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & KOTA == 0, replace save($results\Asdoc\direct_comparison_kota02.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & KOTA == 0, append save($results\Asdoc\direct_comparison_kota02.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 0, append save($results\Asdoc\direct_comparison_kota02.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 0, append save($results\Asdoc\direct_comparison_kota02.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if KOTA == 0

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & KOTA == 0
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS SUMATERA_JAWA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & KOTA == 0
}

***BY SUMATERA_JAWA/NOT***
clear
use "DirektoriPasar(Ready).dta"
tab SUMATERA_JAWA, nolabel

**SUMATERA_JAWA==1

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & SUMATERA_JAWA == 1, replace save($results\Asdoc\direct_comparison_sumjaw11.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & SUMATERA_JAWA == 1, append save($results\Asdoc\direct_comparison_sumjaw11.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 1, append save($results\Asdoc\direct_comparison_sumjaw11.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 1, append save($results\Asdoc\direct_comparison_sumjaw11.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & SUMATERA_JAWA == 1, replace save($results\Asdoc\direct_comparison_sumjaw12.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & SUMATERA_JAWA == 1, append save($results\Asdoc\direct_comparison_sumjaw12.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 1, append save($results\Asdoc\direct_comparison_sumjaw12.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 1, append save($results\Asdoc\direct_comparison_sumjaw12.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if SUMATERA_JAWA == 1

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 1
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 1
}

**SUMATERA_JAWA==0

*First Part: Activity of Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & SUMATERA_JAWA == 0, replace save($results\Asdoc\direct_comparison_sumjaw01.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 1 & SUMATERA_JAWA == 0, append save($results\Asdoc\direct_comparison_sumjaw01.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 0, append save($results\Asdoc\direct_comparison_sumjaw01.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 0, append save($results\Asdoc\direct_comparison_sumjaw01.doc) font(Arial) fs(8)
}

*Second Part: Activity of Non-Revitalized market (2014 vs 2021)
/// 2014
asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & SUMATERA_JAWA == 0, replace save($results\Asdoc\direct_comparison_sumjaw02.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2014AVG if REVITALISASI == 0 & SUMATERA_JAWA == 0, append save($results\Asdoc\direct_comparison_sumjaw02.doc) font(Arial) fs(8)
}

/// 2021
asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 0, append save($results\Asdoc\direct_comparison_sumjaw02.doc) font(Arial) fs(8)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': asdoc sum NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 0, append save($results\Asdoc\direct_comparison_sumjaw02.doc) font(Arial) fs(8)
}

***T-TEST STATISTICS***
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if SUMATERA_JAWA == 0

*Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1 & SUMATERA_JAWA == 0
}

*Non-Revitalized MArket
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS KOTA {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0 & SUMATERA_JAWA == 0
}

**********END OF DO-FILE**********