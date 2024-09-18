
* ==============================================================================
*
* Project			: FII Analysis - Basic Stats
* Authors			: Fadli Jihad Dahana Setiawan
* Stata version  	: 14
* Date created		: November 2021
*
* =============================================================================



***PRELIM***
version 14 
set more off
clear all
cap log close



***IMPORT DATA (EDITABLE)***

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Input/fii2020.dta"


***VARIABLES CREATION***

*Categorical Variable: Women MSME

gen women_msme = 1 if female==1 & is_umkm_workers_method==1 & selfemploy==1
replace women_msme = 2 if female==1 & is_umkm_workers_method==1 & fulltime_salaried==1
replace women_msme = 3 if female==1 & is_umkm_workers_method==1 & parttime_salaried==1
replace women_msme = 4 if female==1 & is_umkm_workers_method==1 & temp_seasonal==1
replace women_msme = 5 if female==1 & is_umkm_workers_method==1 & stayathome_spouse==1
replace women_msme = 6 if female==1 & is_umkm_workers_method==1 & selfemploy==0 & fulltime_salaried==0 & parttime_salaried==0 & temp_seasonal==0 & stayathome_spouse==0

*Categorical Variable: Men MSME

gen men_msme = 1 if female==0 & is_umkm_workers_method==1 & selfemploy==1
replace men_msme = 2 if female==0 & is_umkm_workers_method==1 & fulltime_salaried==1
replace men_msme = 3 if female==0 & is_umkm_workers_method==1 & parttime_salaried==1
replace men_msme = 4 if female==0 & is_umkm_workers_method==1 & temp_seasonal==1
replace men_msme = 5 if female==0 & is_umkm_workers_method==1 & stayathome_spouse==1
replace men_msme = 6 if female==0 & is_umkm_workers_method==1 & selfemploy==0 & fulltime_salaried==0 & parttime_salaried==0 & temp_seasonal==0 & stayathome_spouse==0

*Categorical Variable: Women Non MSME

gen women_nonmsme = 1 if female==1 & is_umkm_workers_method==0 & fulltime_salaried==1
replace women_nonmsme = 2 if female==1 & is_umkm_workers_method==0 & parttime_salaried==1
replace women_nonmsme = 3 if female==1 & is_umkm_workers_method==0 & temp_seasonal==1
replace women_nonmsme = 4 if female==1 & is_umkm_workers_method==0 & stayathome_spouse==1
replace women_nonmsme = 5 if female==1 & is_umkm_workers_method==0 & selfemploy==0 & fulltime_salaried==0 & parttime_salaried==0 & temp_seasonal==0 & stayathome_spouse==0

*Categorical Variable: Men Non MSME

gen men_nonmsme= 1 if female==0 & is_umkm_workers_method==0 & fulltime_salaried==1
replace men_nonmsme = 2 if female==0 & is_umkm_workers_method==0 & parttime_salaried==1
replace men_nonmsme = 3 if female==0 & is_umkm_workers_method==0 & temp_seasonal==1
replace men_nonmsme = 4 if female==0 & is_umkm_workers_method==0 & stayathome_spouse==1
replace men_nonmsme = 5 if female==0 & is_umkm_workers_method==0 & selfemploy==0 & fulltime_salaried==0 & parttime_salaried==0 & temp_seasonal==0 & stayathome_spouse==0

*Categorical Variable: Government Support

destring q140_1, generate(sembako)
destring q140_2, generate(pkh)

gen gov_support = 1 if sembako==1 | pkh==1

*Categorical Variable: Education

gen education = 1 if noedu==1 | primary==1 | jrhigh==1
replace education = 2 if hs==1 | higher_than_hs==1

*Categorical Variable: Age

gen age = 1 if dg1 > 1981
replace age = 2 if dg1 <= 1981

**KNOWLEDGE**

*Know Bank

gen know_bank = 0
replace know_bank = 1 if bi_e24a_1==1 | bi_e4s==1 | bi_e24a_5==1

*Know E-Money

gen know_emoney = 0
replace know_emoney = 1 if bi_e24_3==1 | bi_e24_4==1

*Know Online Lending Platform 

gen know_onlinelending = 0
replace know_onlinelending = 1 if onl1==1

**EXPERIENCE**

*Ever Used Bank 

destring bi_e6s, gen(bi_e6snum)
destring bi_e25a, gen(bi_e25anum)

gen everused_bank = 0
replace everused_bank = 1 if ojk1a_1==2 | ojk1a_1==3 | ojk1a_1==4 | bi_e6snum==1 | bi_e25anum==1
replace everused_bank = . if ojk1a_1==999 

*Ever Used E-Money

gen everused_emoney = 0
replace everused_emoney = 1 if bi_e25_3==1 | bi_e25_4 == 1

*Ever Used Microfinance

gen everused_microfinance = 0
replace everused_microfinance = 1 if ojk13_1==1 | ojk13_2==1

*Ever Used Online Lending Platform 

destring onl2, gen(onl2num)

gen everused_onlinelending = 0
replace everused_onlinelending = 1 if onl2num==1

**OWNERSHIP**

*Currently Have Bank 

gen currentlyhave_bank = 0
replace currentlyhave_bank = 1 if bi_e1_1==1 | bi_e5s==1 | fnx_1==1

*Currently Have E-Money 

gen currentlyhave_emoney = 0
replace currentlyhave_emoney = 1 if bi_e26_cd_3==1 | bi_e26_cd_4 ==1 | fnx_2==1

*Has Microfinance Account 

destring lkm_new1, gen(lkm_new1num)

gen has_microfinanceaccount = 0
replace has_microfinanceaccount = 1 if lkm_new1num==1

*Has Informal Savings

gen has_informalsavings = 0
replace has_informalsavings = 1 if bi_e13_1==1 | bi_e13_2 ==1 | bi_e13_3 ==1 | bi_e13_96==1

**LOANS**

*Took Loan From Bank 

gen tookloan_bank = 0
replace tookloan_bank = 1 if ojk1b_1==2 | ojk1b_1==3 | ojk1b_1==4 | ojk1b_2==2 | ojk1b_2==3 | ojk1b_2==4
replace tookloan_bank = . if ojk1b_1==999 | ojk1b_2==999

*Took Loan From Microfinance 

gen tookloan_microfinance = 0
replace tookloan_microfinance = 1 if ojk1b_3==2 | ojk1b_3==3 | ojk1b_3==4 | ojk1b_5==2 | ojk1b_5==3 | ojk1b_5==4
replace tookloan_microfinance = . if ojk1b_3==999 | ojk1b_5==999

*Took Loan From Informal Institution 

destring bi_e18a, gen(bi_e18anum)

gen tookloan_informal = 0
replace tookloan_informal = 1 if bi_e17==1 | bi_e18anum==1

**INSURANCE**

*Has BPJS Health Benefit

gen has_bpjs_health = 0
replace has_bpjs_health = 1 if ojk9_1 == 1 

*Has BPJS Employment Benefit

gen has_bpjs_employment = 0
replace has_bpjs_employment = 1 if ojk9_2 == 1 

*Has Life Insurance 

gen has_lifeinsc = 0
replace has_lifeinsc = 1 if ojk2_1==1

*Has Health Insurance Other than BPJS

gen has_healthinsc_oththanbpjs = 0
replace has_healthinsc_oththanbpjs = 1 if ojk2_4==1

*Has Agriculture Insurance 

gen has_agriinsc = 0
replace has_agriinsc = 1 if ojk2_9==1

*Has Micro Insurance 

gen has_microinsc = 0
replace has_microinsc = 1 if ojk2_10==1

**ATTITUDES 

destring qua1_1, gen(qua1_1num)
destring qua1_2, gen(qua1_2num)
destring qua1_3, gen(qua1_3num)
destring qua1_4, gen(qua1_4num)
destring qua1_5, gen(qua1_5num)
destring qua1_6, gen(qua1_6num)
destring qua1_7, gen(qua1_7num)
destring qua1_8, gen(qua1_8num)
destring qua1_9, gen(qua1_9num)
destring qua1_10, gen(qua1_10num)
destring qua1_11, gen(qua1_11num)
destring qua1_12, gen(qua1_12num)
destring qua1_13, gen(qua1_13num)

gen att_1 = 0
replace att_1 = 1 if qua1_1num==1 

gen att_2 = 0
replace att_2 = 1 if qua1_2num==1 

gen att_3 = 0
replace att_3 = 1 if qua1_3num==1 

gen att_4 = 0
replace att_4 = 1 if qua1_4num==1 

gen att_5 = 0
replace att_5 = 1 if qua1_5num==1 

gen att_6 = 0
replace att_6 = 1 if qua1_6num==1 

gen att_7 = 0
replace att_7 = 1 if qua1_7num==1 

gen att_8 = 0
replace att_8 = 1 if qua1_8num==1 

gen att_9 = 0
replace att_9 = 1 if qua1_9num==1 

gen att_10 = 0
replace att_10 = 1 if qua1_10num==1 

gen att_11 = 0
replace att_11 = 1 if qua1_11num==1 

gen att_12 = 0
replace att_12 = 1 if qua1_12num==1 

gen att_13 = 0
replace att_13 = 1 if qua1_13num==1 

egen negative_attitude = rowtotal (att_1 att_2 att_3 att_4 att_5 att_6 att_7 att_8 att_9 att_10 att_11 att_12 att_13)


**VARIABLES LABELLING**

	lab var women_msme "Women MSME"
	lab var men_msme "Men MSME"
	lab var women_nonmsme "Women Non-MSME"
	lab var men_nonmsme "Men Non-MSME"
	lab var gov_support "Government Support"
	lab var education "Education Level"
	lab var age "Age"
	
	lab var know_bank "Know Bank"
	lab var know_emoney "Know E-Money"
	lab var know_onlinelending "Know Online Lending Platforms"
	lab var everused_bank "Ever Used Bank"
	lab var everused_emoney "Ever Used E-Money"
	lab var everused_microfinance "Ever Used Microfinance"
	lab var everused_onlinelending "Ever Used Online Lending Platform"
	lab var currentlyhave_bank "Currently Have Bank"
	lab var currentlyhave_emoney "Currently Have E-Money"
	lab var has_microfinanceaccount "Has Microfinance Account"
	lab var has_informalsavings "Has Informal Savings"
	lab var tookloan_bank "Took Loan from Bank"
	lab var tookloan_microfinance "Took Loan from Microfinance"
	lab var tookloan_informal "Took Loan from Informal Institution"
	lab var has_bpjs_health "Has BPJS Health Benefit"
	lab var has_bpjs_employment "Has BPJS Employment Benefit"
	lab var has_lifeinsc "Has Life Insurance"
	lab var has_healthinsc_oththanbpjs "Has Life Insurance Other than BPJS"
	lab var has_agriinsc "Has Agriculture Insurance"
	lab var has_microinsc "Has Micro Insurance"
	lab var negative_attitude "Has Negative Towards Financial Service"

**DUMMY LABELLING**

label define women_msme 1 "Self-Employed" 2 "Fulltime-Salaried" 3 "Parttime-Salaried" 4 "Seasonal" 5 "Stay at Home" 6 "Others"
label define men_msme 1 "Self-Employed" 2 "Fulltime-Salaried" 3 "Parttime-Salaried" 4 "Seasonal" 5 "Stay at Home" 6 "Others"
label define women_nonmsme 1 "Fulltime-Salaried" 2 "Parttime-Salaried" 3 "Seasonal" 4 "Stay at Home" 5 "Others"
label define men_nonmsme 1 "Fulltime-Salaried" 2 "Parttime-Salaried" 3 "Seasonal" 4 "Stay at Home" 5 "Others"
label define education 1 "Lower than HS" 2 "HS and Higher"
label define age 1 "Millenials and Younger" 2 "Older than Millenials"

//Summary of Variables
sum know_bank know_emoney know_onlinelending everused_bank everused_emoney everused_microfinance everused_onlinelending currentlyhave_bank currentlyhave_emoney has_microfinanceaccount has_informalsavings tookloan_bank tookloan_microfinance tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude

***TABLES TO LATEX***	
	
*Table 1: MSME

	eststo clear
	eststo AllF: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==1 & is_umkm_workers_method==1
	eststo AllM: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==0 & is_umkm_workers_method==1
	bysort women_msme: eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude
	bysort men_msme: eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude
	esttab using "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Stata to Latex Output/Table MSME (All).tex", ///
		title ("MSME") mtitle ("All (F)" "All (M)" "Self-employed (F)" "Fulltime (F)" "Parttime (F)" "Seasonal (F)" "Stay-at-Home (F)" "Others (F)" "Self-employed (M)" "Fulltime (M)" "Parttime (M)" "Seasonal (M)" "Stay-at-Home (M)" "Others (M)") ///
		main("mean" %20.2fc) aux("sd" %20.2fc) ///
		label nodepvar nonumbers nonotes replace

	
*Table 2: Non-MSME

	eststo clear
	eststo AllF: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==1 & is_umkm_workers_method==0
	eststo AllM: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==0 & is_umkm_workers_method==0
	bysort women_nonmsme: eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude
	bysort men_nonmsme: eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude
	esttab using "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Stata to Latex Output/Table Non-Msme (All).tex", ///
		title ("Non-MSME") mtitle ("All (F)" "All (M)" "Fulltime (F)" "Parttime (F)" "Seasonal (F)" "Stay-at-Home (F)" "Others (F)" "Fulltime (M)" "Parttime (M)" "Seasonal (M)" "Stay-at-Home (M)" "Others (M)") ///
		main("mean" %20.2fc) aux("sd" %20.2fc) ///
		label nodepvar nonumbers nonotes replace
	
*Table 3: Government Support 
	eststo clear
	eststo AllF: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==1 & gov_support==1
	eststo AllM: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==0 & gov_support==1
		foreach group in urban java {
	bysort `group': eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==1 & gov_support==1
		}
		foreach group in urban java {
	bysort `group': eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==0 & gov_support==1
		}
	esttab using "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Stata to Latex Output/Table Government Support (All).tex", ///
		title ("Government Support") mtitle ("All (F)" "All (M)" "Urban (F)" "Rural (F)" "Java (F)" "Non-Java (F)" "Urban (M)" "Rural (M)" "Java (M)" "Non-Java (M)") ///
		main("mean" %20.2fc) aux("sd" %20.2fc) ///
		label nodepvar nonumbers nonotes replace
	
*Table 4: Female (General)

	eststo clear
	eststo All: estpost summarize know_bank know_emoney know_onlinelending /// 
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount /// 
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==1
	foreach group in urban java economic_status education age {
	bysort `group': eststo : estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney has_microfinanceaccount ///
		has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==1
		}
	esttab using "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Stata to Latex Output/Table Female (General).tex", ///
		title ("Female (General)") mtitle ("All" "Rural" "Urban" "Non-Java" "Java" "Lower Economic Status" "Middle Economic Status" "Upper Economic Status" "Lower than HS" "HS and Higher" "Millenials and Younger" "Older than Millenials") ///
		main("mean" %20.2fc) aux("sd" %20.2fc) ///
		label nodepvar nonumbers nonotes replace

*Table 5: Male (General)

	eststo clear
	eststo All: estpost summarize know_bank know_emoney know_onlinelending ///
		everused_bank everused_emoney everused_microfinance everused_onlinelending ///
		currentlyhave_bank currentlyhave_emoney ///
		has_microfinanceaccount has_informalsavings tookloan_bank tookloan_microfinance ///
		tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
		has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
		if female==0
	foreach group in urban java economic_status education age {
	bysort `group': eststo: estpost summarize know_bank know_emoney know_onlinelending ///
								everused_bank everused_emoney everused_microfinance everused_onlinelending ///
								currentlyhave_bank currentlyhave_emoney ///
								has_microfinanceaccount has_informalsavings tookloan_bank tookloan_microfinance ///
								tookloan_informal has_bpjs_health has_bpjs_employment has_lifeinsc ///
								has_healthinsc_oththanbpjs has_agriinsc has_microinsc negative_attitude ///
								if female==0
								}
	esttab using "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Stata to Latex Output/Table Male (General).tex", ///
		title ("Male (General") mtitle ("All" "Rural" "Urban" "Non-Java" "Java" "Lower Economic Status" "Middle Economic Status" "Upper Economic Status" "Lower than HS" "HS and Higher" "Millenials and Younger" "Older than Millenials") ///
		main("mean" %20.2fc) aux("sd" %20.2fc) ///
		label nodepvar nonumbers nonotes replace	
	
	
	
	

***END OF DO FILE***




