
***************************************
/*
Author			: Fadli Jihad Dahana Setiawan
Organization	: PROSPERA
Purpose			: Market Revitalization Project
Last Modified	: July 2022
*/
***************************************

***PRELIMINARIES***
clear all
set more off

***SETTING DIRECTORIES***

gl marketdir "C:\Users\Fadli JD Setiawan\Documents\1PROSPERA\Perdagangan Besar dan Revitalisasi Pasar Rakyat\Studi Literatur - Tujuan & Dampak Revitalisasi\Model Ekonometrika\Data Direktori Pasar"
gl graphs "$marketdir\Graphs"
gl results "$marketdir\Results"
macro list

cd "$marketdir"

***APPENDING DATA***

import excel "Direktori Pasar - BPS.xlsx", sheet("Sheet1") cellrange(A2:T252) firstrow clear
save "DirektoriPasar.dta", replace

forvalues i = 1/72 {
	clear
	import excel "Direktori Pasar - BPS (`i').xlsx", sheet("Sheet1") cellrange(A2:T252) firstrow
	save "DirektoriPasar (`i').dta", replace
}

	clear
	import excel "Direktori Pasar - BPS (73).xlsx", sheet("Sheet1") cellrange(A2:T120) firstrow
	save "DirektoriPasar (73).dta", replace

clear
use "DirektoriPasar.dta"

forvalues i = 1/73 {
	append using "DirektoriPasar (`i').dta"
}

**Drop if not Pasar Tradisional then Save"

drop if Klasifikasi != "PASAR TRADISIONAL"
drop Klasifikasi

save "DirektoriPasar(All).dta", replace

***CLEANING DATA***

clear
use "DirektoriPasar(All).dta"

**Variables Setting

*KOMODTAS
tab KelompokKomoditasUtama, missing
gen KOMODITAS = KelompokKomoditasUtama == "BAHAN MAKANAN"
tab KOMODITAS

*KOMODTAS_CATEGORICAL
tab KelompokKomoditasUtama, missing
gen KOMODITAS_CATEGORICAL = 0
replace KOMODITAS_CATEGORICAL = 1 if KelompokKomoditasUtama == "BAHAN MAKANAN"
replace KOMODITAS_CATEGORICAL = 2 if KelompokKomoditasUtama == "ELEKTRONIK & PERLENGKAPAN RUMAH TANGGA"
replace KOMODITAS_CATEGORICAL = 3 if KelompokKomoditasUtama == "HASIL LAUT DAN PERIKANAN"
replace KOMODITAS_CATEGORICAL = 4 if KelompokKomoditasUtama == "HEWAN TERNAK/PELIHARAAN"
replace KOMODITAS_CATEGORICAL = 5 if KelompokKomoditasUtama == "KERAJINAN DAN ALAT KESENIAN"
replace KOMODITAS_CATEGORICAL = 6 if KelompokKomoditasUtama == "MAKANAN JADI, MINUMAN, ROKOK, DAN TEMBAKAU"
replace KOMODITAS_CATEGORICAL = 7 if KelompokKomoditasUtama == "PERALATAN SEKOLAH DAN ALAT TULIS KANTOR (ATK)"
replace KOMODITAS_CATEGORICAL = 8 if KelompokKomoditasUtama == "TEKSTIL/BARANG DARI TEKSTIL"
replace KOMODITAS_CATEGORICAL = 9 if KelompokKomoditasUtama == "LAINNYA"
label define komoditas 1 "BAHAN MAKANAN" 2 "ELEKTRONIK & PERLENGKAPAN RUMAH TANGGA" 3 "HASIL LAUT & PERIKANAN" ///
4 "HEWAN TERNAK" 5 "KERAJINAN DAN ALAT KESENIAN" 6 "MAKANAN JADI, MINUMAN, ROKOK, & TEMBAKAU" ///
7 "PERALATAN SEKOLAH & ATK" 8 "TEKSTIL" 9 "LAINNYA"
label values KOMODITAS_CATEGORICAL komoditas
tab KOMODITAS_CATEGORICAL, missing

*WAKTU
tab WaktuOperasi, missing
gen WAKTU = WaktuOperasi == "SETIAP HARI"
tab WAKTU

*PENGELOLA
tab Pengelola, missing
gen PENGELOLA = Pengelola == "PEMERINTAH DAERAH" | Pengelola == "PEMERINTAH PUSAT" | Pengelola == "SWASTA"
tab PENGELOLA

*PENGELOLA_CATEGORICAL
tab Pengelola, missing
gen PENGELOLA_CATEGORICAL = 0
replace PENGELOLA_CATEGORICAL = 1 if Pengelola == "PEMERINTAH DAERAH" 
replace PENGELOLA_CATEGORICAL = 2 if Pengelola == "PEMERINTAH PUSAT" 
replace PENGELOLA_CATEGORICAL = 3 if Pengelola == "SWASTA"
replace PENGELOLA_CATEGORICAL = 4 if Pengelola == "PERORANGAN/TIDAK ADA PENGELOLA" | PENGELOLA_CATEGORICAL == 0
label define pengelola 1 "Pemerintah Daerah" 2 "Pemerintah Pusat" 3 "Swasta" 4 "Perorangan/Tidak Ada Pengelola"
label values PENGELOLA_CATEGORICAL pengelola
tab PENGELOLA_CATEGORICAL

*PENGELOLA_CATEGORICAL V2
tab Pengelola, missing
gen PENGELOLA_CATEGORICAL2 = 0
replace PENGELOLA_CATEGORICAL2 = 1 if Pengelola == "PEMERINTAH DAERAH" 
replace PENGELOLA_CATEGORICAL2 = 2 if Pengelola == "PEMERINTAH PUSAT" 
replace PENGELOLA_CATEGORICAL2 = 3 if Pengelola == "SWASTA" | Pengelola == "PERORANGAN/TIDAK ADA PENGELOLA" | PENGELOLA == 0
label define pengelola2 1 "Pemerintah Daerah" 2 "Pemerintah Pusat" 3 "Swasta"
label values PENGELOLA_CATEGORICAL2 pengelola2
tab PENGELOLA_CATEGORICAL2

*JUMLAH_PEDAGANG
gen JUMLAH_PEDAGANG = 0
replace JUMLAH_PEDAGANG = 1 if PerkiraanJumlahPedagang == "" | PerkiraanJumlahPedagang ==  "< 100 PEDAGANG"
replace JUMLAH_PEDAGANG = 2 if PerkiraanJumlahPedagang == "100 sd. 199 PEDAGANG"
replace JUMLAH_PEDAGANG = 3 if PerkiraanJumlahPedagang == "200 sd. 274 PEDAGANG"
replace JUMLAH_PEDAGANG = 4 if PerkiraanJumlahPedagang == "275 sd. 400 PEDAGANG"
replace JUMLAH_PEDAGANG = 5 if PerkiraanJumlahPedagang == "> 400 PEDAGANG"      

label define jumlahpedagang 1 "<100" 2 "100-199" 3 "200-274" 4 "275-400" 5 ">400"
label values JUMLAH_PEDAGANG jumlahpedagang
tab JUMLAH_PEDAGANG

*Dummies of JUMLAH_PEDAGANG
gen PEDAGANG_LT100 = JUMLAH_PEDAGANG == 1
gen PEDAGANG_100_199 = JUMLAH_PEDAGANG == 2
gen PEDAGANG_200_274 = JUMLAH_PEDAGANG == 3
gen PEDAGANG_275_400 = JUMLAH_PEDAGANG == 4
gen PEDAGANG_GT400 = JUMLAH_PEDAGANG == 5

tab PEDAGANG_LT100
tab PEDAGANG_100_199
tab PEDAGANG_200_274
tab PEDAGANG_275_400
tab PEDAGANG_GT400

*JENIS_BANGUNAN
tab JenisBangunan, missing
gen JENIS_BANGUNAN = JenisBangunan == "PERMANEN"
tab JENIS_BANGUNAN

*KOTA
gen KABKOT = substr(Kabupaten,1,4)
gen KOTA = KABKOT == "KOTA"
tab KOTA

*PULAU
gen PULAU = 0
replace PULAU = 1 if KodeProvinsi == 11 | KodeProvinsi == 12 | KodeProvinsi == 13 | KodeProvinsi == 14 | KodeProvinsi == 15 ///
| KodeProvinsi == 16 | KodeProvinsi == 17 | KodeProvinsi == 18 | KodeProvinsi == 19 | KodeProvinsi == 21
replace PULAU = 2 if KodeProvinsi == 31 | KodeProvinsi == 32 | KodeProvinsi == 33 | KodeProvinsi == 34 | KodeProvinsi == 35 ///
| KodeProvinsi == 36 | KodeProvinsi == 51
replace PULAU = 3 if KodeProvinsi == 61 | KodeProvinsi == 62 | KodeProvinsi == 63 | KodeProvinsi == 64 | KodeProvinsi == 65
replace PULAU = 4 if KodeProvinsi == 71 | KodeProvinsi == 72 | KodeProvinsi == 73 | KodeProvinsi == 74 | KodeProvinsi == 75 | KodeProvinsi == 76
replace PULAU = 5 if  KodeProvinsi == 52 | KodeProvinsi == 53
replace PULAU = 6 if KodeProvinsi == 81 | KodeProvinsi == 82 | KodeProvinsi == 91 | KodeProvinsi == 94

label define pulau 1 "SUMATERA" 2 "JAWA-BALI" 3 "KALIMANTAN" 4 "SULAWESI" 5 "NTT-NTB" 6 "MALUKU-PAPUA"
label values PULAU pulau 
tab PULAU

*Dummies of PULAU
gen SUMATERA = PULAU == 1
gen JAWA_BALI = PULAU == 2
gen KALIMANTAN = PULAU == 3
gen SULAWESI = PULAU == 4
gen NTT_NTB = PULAU == 5
gen MALUKU_PAPUA = PULAU == 6
gen SUMATERA_JAWA = PULAU == 1 | PULAU == 2

*UMUR
gen UMUR = 2022 - TahunMulaiberoperasi
sum UMUR

*UMUR_CATEGORICAL
gen UMUR_CATEGORICAL = 0
replace UMUR_CATEGORICAL = 1 if UMUR < 10 
replace UMUR_CATEGORICAL = 2 if UMUR >= 10 & UMUR <= 25 
replace UMUR_CATEGORICAL = 3 if UMUR >25

label define umur 1 "< 10" 2 "10-25" 3 ">25"
label values UMUR_CATEGORICAL umur 
tab UMUR_CATEGORICAL

*REVITALISASI (Variable of Concern - ver.1)
tab TahunTerakhirRenovasi, missing
gen REVITALISASI = TahunTerakhirRenovasi == 2015 | TahunTerakhirRenovasi == 2016  | TahunTerakhirRenovasi == 2017  ///
| TahunTerakhirRenovasi == 2018 | TahunTerakhirRenovasi == 2019 | TahunTerakhirRenovasi == 2020
tab REVITALISASI, missing

/// Menurut BPS, sekitar 5000 pasar sudah direvitalisasi per 2020, sesuai dengan pembentukan variabel ini.

*UMUR_RENOVASI (Variable of Concern - ver.2)
gen UMUR_RENOVASI = 2022 - TahunTerakhirRenovasi
replace UMUR_RENOVASI = . if UMUR_RENOVASI < 0
replace UMUR_RENOVASI = UMUR if UMUR_RENOVASI == .
sum UMUR_RENOVASI

*UMUR_REVITALISASI
gen UMUR_REVITALISASI = 0
replace UMUR_REVITALISASI = 1 if UMUR_RENOVASI == 7
replace UMUR_REVITALISASI = 2 if UMUR_RENOVASI == 6
replace UMUR_REVITALISASI = 3 if UMUR_RENOVASI == 5
replace UMUR_REVITALISASI = 4 if UMUR_RENOVASI == 4
replace UMUR_REVITALISASI = 5 if UMUR_RENOVASI < 4
replace UMUR_REVITALISASI = 6 if UMUR_RENOVASI > 7
label define umurrevitalisasi 1 "7 Tahun" 2 "6 Tahun" 3 "5 Tahun" 4 "4 Tahun" 5 "1-3 Tahun" 6 ">7 Tahun (Not included)"
tab UMUR_REVITALISASI, missing

**Labelling Values for Dummies
label define dummy 0 "Tidak" 1 "Ya"
foreach var in KOMODITAS WAKTU PENGELOLA JENIS_BANGUNAN SUMATERA JAWA_BALI KALIMANTAN ///
SULAWESI NTT_NTB MALUKU_PAPUA SUMATERA_JAWA PEDAGANG_LT100 PEDAGANG_100_199 PEDAGANG_200_274 /// 
PEDAGANG_275_400 PEDAGANG_GT400 KOTA REVITALISASI {
	label values `var' dummy
}

**Labelling Variables

la var KOMODITAS "Komoditas utama adalah bahan makanan"
la var WAKTU "Waktu operasional adalah setiap aari"
la var PENGELOLA "Dikelola secara resmi"
la var PENGELOLA_CATEGORICAL "Jenis pengelola (Categorical)"
la var JENIS_BANGUNAN "Memiliki bangunan permanen"
la var JUMLAH_PEDAGANG "Jumlah pedagang di pasar"
la var PULAU "Lokasi pasar"
la var SUMATERA_JAWA "Lokasi pasar di Sumatera atau Jawa"
la var PEDAGANG_LT100 "Jumlah Pedagang kurang dari 100"
la var PEDAGANG_100_199 "Jumlah Pedagang antara 100-199"
la var PEDAGANG_200_274 "Jumlah Pedagang antara 200-274"
la var PEDAGANG_275_400 "Jumlah Pedagang antara 275-400"
la var PEDAGANG_GT400 "Jumlah Pedagang lebih dari 400"
la var REVITALISASI "Pasar sudah di-revitalisasi"
la var KOTA "Pasar terletak di Kota"
la var UMUR "Umur pasar sejak awal berdiri"
la var UMUR_CATEGORICAL "Umur pasar sejak awal berdiri (Categorical)"
la var UMUR_RENOVASI "Umur pasar sejak terakhir direnovasi"

**Keep Variables

keep ID NamaPasar KodeProvinsi Provinsi KodeKab Kabupaten KodeKec Kecamatan KodeKel ///
Kelurahan Alamat KOMODITAS KOMODITAS_CATEGORICAL WAKTU PENGELOLA ///
PENGELOLA_CATEGORICAL PENGELOLA_CATEGORICAL2 JENIS_BANGUNAN ///
JUMLAH_PEDAGANG PULAU SUMATERA JAWA_BALI KALIMANTAN SULAWESI ///
NTT_NTB MALUKU_PAPUA SUMATERA_JAWA UMUR UMUR_CATEGORICAL UMUR_RENOVASI ///
PEDAGANG_LT100 PEDAGANG_100_199 PEDAGANG_200_274 ///
PEDAGANG_275_400 PEDAGANG_GT400 KOTA REVITALISASI UMUR_REVITALISASI

**Save to Clean

save "DirektoriPasar(Clean).dta", replace

***MERGING DATA WITH AKTIVITAS (NIGHTLIGHT) FILE***

clear
import excel "2014-2021_Nightlight_Data.xlsx", sheet("Sheet1") firstrow clear
keep ID lat V coord min_land_a layer path NIGHTLIGHT_2021AVG A2C_BPS A2N_BPS NIGHTLIGHT_2021DISTAVG NIGHTLIGHT_2014AVG AF AG NIGHTLIGHT_2014DISTAVG
gen PCT_CHG = ((NIGHTLIGHT_2021AVG - NIGHTLIGHT_2014AVG) / NIGHTLIGHT_2014AVG)*100
gen PCT_CHGDIST = ((NIGHTLIGHT_2021DISTAVG - NIGHTLIGHT_2014DISTAVG) / NIGHTLIGHT_2014DISTAVG)*100
gen lndiff = ln(exp(NIGHTLIGHT_2021AVG) - exp(NIGHTLIGHT_2014AVG))
gen lndiffdist = ln(exp(NIGHTLIGHT_2021DISTAVG) - exp(NIGHTLIGHT_2014DISTAVG))
save "Aktivitas_Nightlight.dta", replace

clear
use "DirektoriPasar(Clean).dta"

merge 1:1 ID using "Aktivitas_Nightlight.dta"
drop _merge
drop if lat == .

save "DirektoriPasar(Ready).dta", replace

**Merging Data with Densitas File
clear 
import excel "DensitybyProvince.xlsx", sheet("Sheet1") firstrow clear
replace PROVINCE = proper(PROVINCE)
replace PROVINCE = "Kepulauan Bangka Belitung" if PROVINCE == "Kep. Bangka Belitung"
replace PROVINCE = "Kepulauan Riau" if PROVINCE == "Kep. Riau"
rename PROVINCE Provinsi
destring Density2019, gen(DENSITAS_PROVINSI)
la var DENSITAS_PROVINSI "Jiwa/km2 - 2019"

sum DENSITAS_PROVINSI, detail
gen DENSITAS_CATEGORICAL = 0
replace DENSITAS_CATEGORICAL = 1 if DENSITAS_PROVINSI < 50
replace DENSITAS_CATEGORICAL = 2 if DENSITAS_PROVINSI >= 50 & DENSITAS_PROVINSI < 108
replace DENSITAS_CATEGORICAL = 3 if DENSITAS_PROVINSI >= 108 & DENSITAS_PROVINSI < 268
replace DENSITAS_CATEGORICAL = 4 if DENSITAS_PROVINSI >= 268

label define densitas 1 "1-25" 2 "25-50" 3 "50-75" 4 "75-100"
label values DENSITAS_CATEGORICAL densitas

save "DensitybyProvince.dta", replace

clear
use "DirektoriPasar(Ready).dta"

merge m:1 Provinsi using "DensitybyProvince.dta"
drop if _merge != 3
drop _merge

save "DirektoriPasar(Ready).dta", replace

***DATA VISUALIZATION (From 26/07/2022)***
clear
use "DirektoriPasar(Ready).dta"

/// Sample size
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	tab `var' REVITALISASI
}

tab JUMLAH_PEDAGANG if REVITALISASI == 1
foreach var in PENGELOLA_CATEGORICAL JENIS_BANGUNAN UMUR_CATEGORICAL KOMODITAS_CATEGORICAL PULAU {
	tab `var' JUMLAH_PEDAGANG if REVITALISASI == 1
}

tab JUMLAH_PEDAGANG if REVITALISASI == 0
foreach var in PENGELOLA_CATEGORICAL JENIS_BANGUNAN UMUR_CATEGORICAL KOMODITAS_CATEGORICAL PULAU {
	tab `var' JUMLAH_PEDAGANG if REVITALISASI == 0
}

/// For Tabulation in Excel's PIVOT

/*export excel using "Data Direktori Pasar (Ready).xls", firstrow(variables) replace

clear
use "DirektoriPasar(Ready).dta"
keep if REVITALISASI == 1
export excel using "Data Direktori Pasar (Revitalized).xls", firstrow(variables) replace

clear
use "DirektoriPasar(Ready).dta"
keep if REVITALISASI == 0
export excel using "Data Direktori Pasar (Non-Revitalized).xls", firstrow(variables) replace */


/// T-Test
clear
use "DirektoriPasar(Ready).dta"

*General
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG

*Revitalized Market
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 1
}

*Non-Revitalized Market
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if REVITALISASI == 0
}

/// Extended Descriptive Statistics
*do "Extended Descriptive Statistics.do"

/// T-Test (Cross Tabulation)
clear
use "DirektoriPasar(Ready).dta"

**Full Sample
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5
}

**Revitalized
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1 & REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1 & REVITALISASI == 1
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2 & REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2 & REVITALISASI == 1
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3 & REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3 & REVITALISASI == 1
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4 & REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4 & REVITALISASI == 1
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5 & REVITALISASI == 1
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5 & REVITALISASI == 1
}

**Non-Revitalized
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1 & REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 1 & REVITALISASI == 0
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2 & REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 2 & REVITALISASI == 0
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3 & REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 3 & REVITALISASI == 0
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4 & REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 4 & REVITALISASI == 0
}
ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5 & REVITALISASI == 0
foreach var in JUMLAH_PEDAGANG DENSITAS_CATEGORICAL PENGELOLA_CATEGORICAL JENIS_BANGUNAN WAKTU UMUR_CATEGORICAL KOMODITAS_CATEGORICAL KOTA PULAU UMUR_REVITALISASI {
	bysort `var': ttest NIGHTLIGHT_2014AVG == NIGHTLIGHT_2021AVG if JUMLAH_PEDAGANG == 5 & REVITALISASI == 0
}

/// Data Support for NTL Photos
clear
use "DirektoriPasar(Ready).dta"

gen BOGOR = Kabupaten == "KOTA BOGOR"
gen CILEGON = Kabupaten == "KOTA CILEGON"
gen SEMARANG = Kabupaten == "KOTA SEMARANG"
gen ACEH = Provinsi == "Aceh"

foreach var in BOGOR CILEGON SEMARANG ACEH {
	sum NIGHTLIGHT_2014AVG if `var' == 1
	sum NIGHTLIGHT_2021AVG if `var' == 1
	sum NIGHTLIGHT_2014AVG if `var' == 1 & REVITALISASI == 1
	sum NIGHTLIGHT_2021AVG if `var' == 1 & REVITALISASI == 1
	sum NIGHTLIGHT_2014AVG if `var' == 1 & REVITALISASI == 0
	sum NIGHTLIGHT_2021AVG if `var' == 1 & REVITALISASI == 0
}

**********END OF DO-FILE**********
