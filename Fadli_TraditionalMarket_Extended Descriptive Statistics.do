
clear all
set more off

***EXTENDED DESCRIPTIVE STATISTICS***

***REVITALIZED
clear
use "DirektoriPasar(Ready).dta"
keep if REVITALISASI == 1

**Median

*2014
egen median2014_general = median(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen median2014_`var' = median(NIGHTLIGHT_2014AV)
}

*2021
egen median2021_general = median(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen median2021_`var' = median(NIGHTLIGHT_2021AV)
}

**Std

*2014
egen std2014_general = sd(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen std2014_`var' = sd(NIGHTLIGHT_2014AV)
}

*2021
egen std2021_general = sd(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen std2021_`var' = sd(NIGHTLIGHT_2021AV)
}

**Min

*2014
egen min2014_general = min(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen min2014_`var' = min(NIGHTLIGHT_2014AV)
}

*2021
egen min2021_general = min(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen min2021_`var' = min(NIGHTLIGHT_2021AV)
}

**Max

*2014
egen max2014_general = max(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen max2014_`var' = max(NIGHTLIGHT_2014AV)
}

*2021
egen max2021_general = max(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen max2021_`var' = max(NIGHTLIGHT_2021AV)
}

**Mean

*2014
egen mean2014_general = mean(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen mean2014_`var' = mean(NIGHTLIGHT_2014AV)
}

*2021
egen mean2021_general = mean(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen mean2021_`var' = mean(NIGHTLIGHT_2021AV)
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
putexcel J1 = "Mean"
putexcel B2 = "2014"
putexcel C2 = "2021"
putexcel D2 = "2014"
putexcel E2 = "2021"
putexcel F2 = "2014"
putexcel G2 = "2021"
putexcel H2 = "2014"
putexcel I2 = "2021"
putexcel J2 = "2014"
putexcel K2 = "2021"
putexcel A3 = "JUMLAH_PEDAGANG"
putexcel A9 = "DENSITAS_CATEGORICAL"
putexcel A14 = "PENGELOLA_CATEGORICAL"
putexcel A19 = "JENIS_BANGUNAN"
putexcel A22 = "WAKTU"
putexcel A25 = "KOMODITAS_CATEGORICAL-Makanan"
putexcel A26 = "KOMODITAS_CATEGORICAL-Elektronik"
putexcel A27 = "KOMODITAS_CATEGORICAL-Makananjadi"
putexcel A28 = "KOMODITAS_CATEGORICAL-Tekstil"
putexcel A29 = "KOMODITAS_CATEGORICAL-Lainnya"
putexcel A33 = "KOTA"
putexcel A36 = "UMUR_CATEGORICAL"
putexcel A40 = "PULAU"
putexcel A48 = "GENERAL"

sum median2014_general
putexcel B48 = `r(mean)'
sum median2021_general
putexcel C48 = `r(mean)'
sum std2014_general
putexcel D48 = `r(mean)'
sum std2021_general
putexcel E48 = `r(mean)'
sum min2014_general
putexcel F48 = `r(mean)'
sum min2021_general
putexcel G48 = `r(mean)'
sum max2014_general
putexcel H48 = `r(mean)'
sum max2021_general
putexcel I48 = `r(mean)'
sum NIGHTLIGHT_2014AV
putexcel J48 = `r(mean)'
sum NIGHTLIGHT_2021AV
putexcel K48 = `r(mean)'

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

sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel B25 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel B26 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel B27 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel B28 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel B29 = `r(mean)'

sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel C25 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel C26 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel C27 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel C28 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel C29 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum median2014_KOTA if KOTA == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_KOTA if KOTA == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum median2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum median2014_PULAU if PULAU == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_PULAU if PULAU == `i'
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

sum std2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel D25 = `r(mean)'
sum std2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel D27 = `r(mean)'

sum std2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel E25 = `r(mean)'
sum std2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel E27 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum std2014_KOTA if KOTA == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_KOTA if KOTA == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum std2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum std2014_PULAU if PULAU == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_PULAU if PULAU == `i'
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

sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel F25 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel F26 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel F27 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel F28 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel F29 = `r(mean)'

sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel G25 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel G26 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel G27 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel G28 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel G29 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum min2014_KOTA if KOTA == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_KOTA if KOTA == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum min2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum min2014_PULAU if PULAU == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_PULAU if PULAU == `i'
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

sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel H25 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel H26 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel H27 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel H28 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel H29 = `r(mean)'

sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel I25 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel I26 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel I27 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel I28 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel I29 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum max2014_KOTA if KOTA == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_KOTA if KOTA == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum max2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum max2014_PULAU if PULAU == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_PULAU if PULAU == `i'
	putexcel I`n' = `r(mean)'
}

*Mean
forvalues i = 1/5 {
	loc n = `i' + 2
	sum mean2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum mean2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum mean2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum mean2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum mean2014_WAKTU if WAKTU == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_WAKTU if WAKTU == `i'
	putexcel K`n' = `r(mean)'
}

sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel J25 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel J26 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel J27 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel J28 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel J29 = `r(mean)'

sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel K25 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 2
putexcel K26 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel K27 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel K28 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel K29 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum mean2014_KOTA if KOTA == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_KOTA if KOTA == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum mean2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum mean2014_PULAU if PULAU == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_PULAU if PULAU == `i'
	putexcel K`n' = `r(mean)'
}

***NON-REVITALIZED
clear
use "DirektoriPasar(Ready).dta"
keep if REVITALISASI == 0

**Median

*2014
egen median2014_general = median(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen median2014_`var' = median(NIGHTLIGHT_2014AV)
}

*2021
egen median2021_general = median(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen median2021_`var' = median(NIGHTLIGHT_2021AV)
}

**Std

*2014
egen std2014_general = sd(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen std2014_`var' = sd(NIGHTLIGHT_2014AV)
}

*2021
egen std2021_general = sd(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen std2021_`var' = sd(NIGHTLIGHT_2021AV)
}

**Min

*2014
egen min2014_general = min(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen min2014_`var' = min(NIGHTLIGHT_2014AV)
}

*2021
egen min2021_general = min(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen min2021_`var' = min(NIGHTLIGHT_2021AV)
}

**Max

*2014
egen max2014_general = max(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen max2014_`var' = max(NIGHTLIGHT_2014AV)
}

*2021
egen max2021_general = max(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen max2021_`var' = max(NIGHTLIGHT_2021AV)
}

**Mean

*2014
egen mean2014_general = mean(NIGHTLIGHT_2014AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen mean2014_`var' = mean(NIGHTLIGHT_2014AV)
}

*2021
egen mean2021_general = mean(NIGHTLIGHT_2021AV)
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': egen mean2021_`var' = mean(NIGHTLIGHT_2021AV)
}

export excel using "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\Perdagangan Besar dan Revitalisasi Pasar Rakyat\Studi Literatur - Tujuan & Dampak Revitalisasi\Model Ekonometrika\Data Direktori Pasar\Extended Descriptive Statistics (Revitalized).xls", firstrow(variables) replace

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
putexcel J1 = "Mean"
putexcel B2 = "2014"
putexcel C2 = "2021"
putexcel D2 = "2014"
putexcel E2 = "2021"
putexcel F2 = "2014"
putexcel G2 = "2021"
putexcel H2 = "2014"
putexcel I2 = "2021"
putexcel J2 = "2014"
putexcel K2 = "2021"
putexcel A3 = "JUMLAH_PEDAGANG"
putexcel A9 = "DENSITAS_CATEGORICAL"
putexcel A14 = "PENGELOLA_CATEGORICAL"
putexcel A19 = "JENIS_BANGUNAN"
putexcel A22 = "WAKTU"
putexcel A25 = "KOMODITAS_CATEGORICAL-Makanan"
putexcel A26 = "KOMODITAS_CATEGORICAL-Hasillaut"
putexcel A27 = "KOMODITAS_CATEGORICAL-Ternak"
putexcel A28 = "KOMODITAS_CATEGORICAL-Makananjadi"
putexcel A29 = "KOMODITAS_CATEGORICAL-Tekstil"
putexcel A30 = "KOMODITAS_CATEGORICAL-Lainnya"
putexcel A33 = "KOTA"
putexcel A36 = "UMUR_CATEGORICAL"
putexcel A40 = "PULAU"
putexcel A48 = "GENERAL"

sum median2014_general
putexcel B48 = `r(mean)'
sum median2021_general
putexcel C48 = `r(mean)'
sum std2014_general
putexcel D48 = `r(mean)'
sum std2021_general
putexcel E48 = `r(mean)'
sum min2014_general
putexcel F48 = `r(mean)'
sum min2021_general
putexcel G48 = `r(mean)'
sum max2014_general
putexcel H48 = `r(mean)'
sum max2021_general
putexcel I48 = `r(mean)'
sum NIGHTLIGHT_2014AV
putexcel J48 = `r(mean)'
sum NIGHTLIGHT_2021AV
putexcel K48 = `r(mean)'

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

sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel B25 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel B26 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel B27 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel B28 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel B29 = `r(mean)'
sum median2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel B30 = `r(mean)'

sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel C25 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel C26 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel C27 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel C28 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel C29 = `r(mean)'
sum median2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel C30 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum median2014_KOTA if KOTA == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_KOTA if KOTA == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum median2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel C`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum median2014_PULAU if PULAU == `i'
	putexcel B`n' = `r(mean)'
	sum median2021_PULAU if PULAU == `i'
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

sum std2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel D25 = `r(mean)'
sum std2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel D26 = `r(mean)'
sum std2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel D28 = `r(mean)'

sum std2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel E25 = `r(mean)'
sum std2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel E26 = `r(mean)'
sum std2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel E28 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum std2014_KOTA if KOTA == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_KOTA if KOTA == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum std2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel E`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum std2014_PULAU if PULAU == `i'
	putexcel D`n' = `r(mean)'
	sum std2021_PULAU if PULAU == `i'
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

sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel F25 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel F26 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel F27 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel F28 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel F29 = `r(mean)'
sum min2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel F30 = `r(mean)'

sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel G25 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel G26 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel G27 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel G28 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel G29 = `r(mean)'
sum min2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel G30 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum min2014_KOTA if KOTA == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_KOTA if KOTA == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum min2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel G`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum min2014_PULAU if PULAU == `i'
	putexcel F`n' = `r(mean)'
	sum min2021_PULAU if PULAU == `i'
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

sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel H25 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel H26 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel H27 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel H28 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel H29 = `r(mean)'
sum max2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel H30 = `r(mean)'

sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel I25 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel I26 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel I27 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel I28 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel I29 = `r(mean)'
sum max2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel I30 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum max2014_KOTA if KOTA == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_KOTA if KOTA == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum max2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel I`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum max2014_PULAU if PULAU == `i'
	putexcel H`n' = `r(mean)'
	sum max2021_PULAU if PULAU == `i'
	putexcel I`n' = `r(mean)'
}

*Mean
forvalues i = 1/5 {
	loc n = `i' + 2
	sum mean2014_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_JUMLAH_PEDAGANG if JUMLAH_PEDAGANG == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 8
	sum mean2014_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_DENSITAS_CATEGORICAL if DENSITAS_CATEGORICAL == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/4 {
	loc n = `i' + 13
	sum mean2014_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_PENGELOLA_CATEGORICAL if PENGELOLA_CATEGORICAL == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 18
	sum mean2014_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_JENIS_BANGUNAN if JENIS_BANGUNAN == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/2 {
	loc n = `i' + 21
	sum mean2014_WAKTU if WAKTU == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_WAKTU if WAKTU == `i'
	putexcel K`n' = `r(mean)'
}

sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel J25 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel J26 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel J27 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel J28 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel J29 = `r(mean)'
sum mean2014_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel J30 = `r(mean)'

sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 1
putexcel K25 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 3
putexcel K26 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 4
putexcel K27 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 6
putexcel K28 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 8
putexcel K29 = `r(mean)'
sum mean2021_KOMODITAS_CATEGORICAL if KOMODITAS_CATEGORICAL == 9
putexcel K30 = `r(mean)'

forvalues i = 1/2 {
	loc n = `i' + 32
	sum mean2014_KOTA if KOTA == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_KOTA if KOTA == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/3 {
	loc n = `i' + 35
	sum mean2014_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_UMUR_CATEGORICAL if UMUR_CATEGORICAL == `i'
	putexcel K`n' = `r(mean)'
}

forvalues i = 1/6 {
	loc n = `i' + 39
	sum mean2014_PULAU if PULAU == `i'
	putexcel J`n' = `r(mean)'
	sum mean2021_PULAU if PULAU == `i'
	putexcel K`n' = `r(mean)'
}

***END OF DO-FILE***