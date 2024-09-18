* ==============================================================================
*
* Project			: E-Commerce
* Purpose			: Fuzzy Matching for Location (Kecamatan)
* Authors   		: Fadli Setiawan
* Stata version  	: 14
* Date created		: January 2022
*
* ==============================================================================


clear
set more off

****************PREPARATION****************

use "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/podes2020_location.dta", clear

***Prepare tv2 dataset

duplicates drop R103N, force
duplicates list R103N

///there should be 0 observations that are duplicates

drop R104 R104N
///we don't need information on desa

save "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv2.dta", replace

***Basic string cleaning first for tv2

use "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv2.dta", clear

replace R101N = proper(R101N)
replace R102N = proper(R102N)
replace R103N = proper(R103N)

///the buyer/seller admin data is in 'proper' case not 'lower' case
///to be more neat, make r101n and r102n proper as well

***Create the idnum variable

gen idnum = _n

save "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv3.dta", replace
///we need to save another dataset (tv3) with idnum in it

***Install matchit and freqindex command

*ssc install matchit
*ssc install freqindex

****************MATCHING TO BUYER'S LOCATION****************

use "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/admin_buyerlocation.dta", clear

***Create the idnum1 variable

gen idnum1 = _n

***Matchit command and fuzzy matching

matchit idnum1 buyer_location using "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv3.dta",  idusing(idnum) txtusing(R103N) over

***Selecting the best matching
	
bys buyer_location: egen rankscore=rank(similscore)
bys buyer_location: egen maxscore=max(rankscore)
bys buyer_location: keep if maxscore==rankscore
drop rankscore maxscore
	
***Merge with tv3

merge m:1 R103N using "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv3.dta"
///m:1 because R103N is not a unique identifier in master data

drop if _merge<3
drop _merge

save "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/buyerlocation-matched.dta", replace

****************MATCHING TO SELLER'S LOCATION****************

use "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/admin_sellerlocation.dta", clear

***Create the idnum1 variable

gen idnum2 = _n

***Matchit command and fuzzy matching

matchit idnum2 location using "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv3.dta",  idusing(idnum) txtusing(R103N) over

***Selecting the best matching
	
bys location: egen rankscore=rank(similscore)
bys location: egen maxscore=max(rankscore)
bys location: keep if maxscore==rankscore
drop rankscore maxscore
	
***Merge with tv3

merge m:1 R103N using "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/tv3.dta"
///m:1 because R103N is not a unique identifier in master data

drop if _merge<3
drop _merge

save "/Users/nursjamsiah/Documents/1JPAL/IFII/E-Commerce/Fuzzy Matching/sellerlocation-matched.dta", replace
