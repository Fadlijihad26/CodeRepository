* ==============================================================================
*
* Project			: FII Gender Analysis - Data Visualization 
* Dataset			: FII 2020
* Purpose			: Create bar charts
* Authors   		: Fadli Jihad Dahana Setiawan
* Stata version  	: 14
* Date created		: November-December 2021
*
* =============================================================================


***PRELIM***

clear all
version 14 
set more off
cap log close

******************TABLE OF CONTENTS************************

*Graph 1-4: Rate of Savings Account
*Graph 5-8: Rate of Lending Account
*Graph 9-12: Knowledge of Savings Account
*Graph 13-16: Attitude Towards Savings Product
*Graph 17-20: Digital Readiness
*Graph 21-24: Involvement in Househop Spending Decisions
*Graph 25-28: Attitude Towards Lending Product
*Comparison Table: Reasons for Not Having Savings Account VS Attitude Towards Savings Product

******************GRAPH 1************************

***IMPORT DATA (EDITABLE)***

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Input/fii2020.dta"


***GROUPS DESCRIPTION***

/// The Target Groups

// Women (and Men) with Low Socioeconomic Status
count if female==1 & low_economic_status==1
count if female==0 & low_economic_status==1

// Women (and Men) who are a Worker (Fulltime, Parttime, and Seasonal)
count if female ==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
count if female ==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)

// Women (and Men) who are an MSME Owner
count if female==1 & is_umkm_workers_method==1
count if female==0 & is_umkm_workers_method==1

// Women (and Men) who are a Stay-at-home Spouse
count if female==1 & stayathome_spouse==1
count if female==0 & stayathome_spouse==1

///Savings Account 

//Rate of Bank Savings Account

*Currently Have Bank 

gen currentlyhave_bank = 0
replace currentlyhave_bank = 1 if bi_e1_1==1 | bi_e5s==1 | fnx_1==1

//Rate of Informal Savings

gen has_informalsavings = 0
replace has_informalsavings = 1 if bi_e13_1==1 | bi_e13_2 ==1 | bi_e13_3 ==1 | bi_e13_96==1

//Rate of Microfinance Savings

destring lkm_new1, gen(lkm_new1num)

gen has_microfinanceaccount = 0
replace has_microfinanceaccount = 1 if lkm_new1num==1

//Rate of Internet Banking or Mobile e-Money (DFS)

destring cvd3, gen (cvd3num)

gen currentlyhave_emoney = 0
replace currentlyhave_emoney = 1 if bi_e26_cd_3==1 | bi_e26_cd_4 ==1 | fnx_2==1 | cvd3num== 1

///Lending Account 

//Rate of Any Formal Loans

gen tookloan_formal = 0
replace tookloan_formal = 1 if bi_e14 == 1

//Rate of Bank Loans (Collateral or Non-Collateral)

gen tookloan_bank = 0
replace tookloan_bank = 1 if ojk1b_1==2 | ojk1b_1==3 | ojk1b_1==4 | ojk1b_2==2 | ojk1b_2==3 | ojk1b_2==4
replace tookloan_bank = . if ojk1b_1==999 | ojk1b_2==999

//Rate of Informal Loans

destring bi_e18a, gen(bi_e18anum)

gen tookloan_informal = 0
replace tookloan_informal = 1 if bi_e17==1 | bi_e18anum==1

//Rate of Microfinance Loans

gen tookloan_microfinance = 0
replace tookloan_microfinance = 1 if ojk1b_3==2 | ojk1b_3==3 | ojk1b_3==4 | ojk1b_5==2 | ojk1b_5==3 | ojk1b_5==4
replace tookloan_microfinance = . if ojk1b_3==999 | ojk1b_5==999

//Rate of Online Lending (DFS)

destring onl2, gen(onl2num)

gen everused_onlinelending = 0
replace everused_onlinelending = 1 if onl2num==1

save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta", replace

***COUNT***

count if female==1 & low_economic_status==1
gl c_female_low = `r(N)'

count if female==0 & low_economic_status==1
gl c_male_low = `r(N)'

***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank has_informalsavings has_microfinanceaccount currentlyhave_emoney  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
	
	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 1.5
 mat res [3,6] = 2.5
 mat res [4,6] = 3
 mat res [5,6] = 4
 mat res [6,6] = 4.5
 mat res [7,6] = 5.5
 mat res [8,6] = 6

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("DFS Saving Behavior by Gender") subtit("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female_low]") label(2 "Male [n=$c_male_low]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Informal Savings" ///
		4.25  "Microfinance Savings"  ///
		5.75 `""Internet Banking or" "Mobile E-money""', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph1, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/DFS Saving Behavior by Gender (Low Economic Status).png", replace

******************GRAPH 2************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female_low = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male_low = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank has_informalsavings has_microfinanceaccount currentlyhave_emoney  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
	
	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 1.5
 mat res [3,6] = 2.5
 mat res [4,6] = 3
 mat res [5,6] = 4
 mat res [6,6] = 4.5
 mat res [7,6] = 5.5
 mat res [8,6] = 6

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("DFS Saving Behavior by Gender") subtit("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female_low]") label(2 "Male [n=$c_male_low]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Informal Savings" ///
		4.25  "Microfinance Savings"  ///
		5.75 `""Internet Banking or" "Mobile E-money""', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph2, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/DFS Saving Behavior by Gender (Workers).png", replace	
		
******************GRAPH 3************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female_low = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male_low = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank has_informalsavings has_microfinanceaccount currentlyhave_emoney  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
	
	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 1.5
 mat res [3,6] = 2.5
 mat res [4,6] = 3
 mat res [5,6] = 4
 mat res [6,6] = 4.5
 mat res [7,6] = 5.5
 mat res [8,6] = 6

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("DFS Saving Behavior by Gender") subtit("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female_low]") label(2 "Male [n=$c_male_low]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Informal Savings" ///
		4.25  "Microfinance Savings"  ///
		5.75 `""Internet Banking or" "Mobile E-money""', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph3, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/DFS Saving Behavior by Gender (MSME).png", replace	
		
******************GRAPH 4************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female_low = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank has_informalsavings has_microfinanceaccount currentlyhave_emoney  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 2.5
 mat res [3,6] = 4
 mat res [4,6] = 5.5

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Women's DFS Saving Behavior") subtit("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female_low]") size(small)) ///
		xlabel(1 "Bank Savings" ///
		2.5  "Informal Savings" ///
		4  "Microfinance Savings"  ///
		5.5 `""Internet Banking or" "Mobile E-money""', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph4, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Women's DFS Saving Behavior (Stay-at-Home Spouse).png", replace	
		
graph combine graph1 graph2 graph3 graph4, iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/DFS Saving Behavior by Gender (Combined).png", replace	
		
******************GRAPH 5************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & low_economic_status==1
gl c_female_low = `r(N)'

count if female==0 & low_economic_status==1
gl c_male_low = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in tookloan_informal tookloan_formal tookloan_bank tookloan_microfinance everused_onlinelending  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
	
	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 1.5
 mat res [3,6] = 2.5
 mat res [4,6] = 3
 mat res [5,6] = 4
 mat res [6,6] = 4.5
 mat res [7,6] = 5.5
 mat res [8,6] = 6
 mat res [9,6] = 7
 mat res [10,6] = 7.5
 

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("DFS Lending Behavior by Gender") subtit("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female_low]") label(2 "Male [n=$c_male_low]") size(small)) ///
		xlabel(1.25 "Informal Loan" ///
		2.75  "Formal Loan" ///
		4.25  "Bank Loa/n"  ///
		5.75 "Microfinance Loan" ///
		7.25 "Online Lending", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph5, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/DFS Lending Behavior by Gender (Low Economic Status).png", replace	
		
******************GRAPH 6************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female_low = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male_low = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in tookloan_informal tookloan_formal tookloan_bank tookloan_microfinance everused_onlinelending  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
	
	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 1.5
 mat res [3,6] = 2.5
 mat res [4,6] = 3
 mat res [5,6] = 4
 mat res [6,6] = 4.5
 mat res [7,6] = 5.5
 mat res [8,6] = 6
 mat res [9,6] = 7
 mat res [10,6] = 7.5
 

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("DFS Lending Behavior by Gender") subtit("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female_low]") label(2 "Male [n=$c_male_low]") size(small)) ///
		xlabel(1.25 "Informal Loan" ///
		2.75  "Formal Loan" ///
		4.25  "Bank Loa/n"  ///
		5.75 "Microfinance Loan" ///
		7.25 "Online Lending", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph6, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/DFS Lending Behavior by Gender (Workers).png", replace	
		
******************GRAPH 7************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female_low = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male_low = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in tookloan_informal tookloan_formal tookloan_bank tookloan_microfinance everused_onlinelending  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
	
	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 1.5
 mat res [3,6] = 2.5
 mat res [4,6] = 3
 mat res [5,6] = 4
 mat res [6,6] = 4.5
 mat res [7,6] = 5.5
 mat res [8,6] = 6
 mat res [9,6] = 7
 mat res [10,6] = 7.5
 

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("DFS Lending Behavior by Gender") subtit("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female_low]") label(2 "Male [n=$c_male_low]") size(small)) ///
		xlabel(1.25 "Informal Loan" ///
		2.75  "Formal Loan" ///
		4.25  "Bank Loa/n"  ///
		5.75 "Microfinance Loan" ///
		7.25 "Online Lending", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph7, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/DFS Lending Behavior by Gender (MSME).png", replace	
		
******************GRAPH 8************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female_low = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in tookloan_informal tookloan_formal tookloan_bank tookloan_microfinance everused_onlinelending  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `perception'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1
 mat res [2,6] = 2.5
 mat res [3,6] = 4
 mat res [4,6] = 5.5
 mat res [5,6] = 7
 

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 female
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Women's DFS Lending Behavior") subtit("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female_low]") size(small)) ///
		xlabel(1 "Informal Loan" ///
		2.5  "Formal Loan" ///
		4  "Bank Loan"  ///
		5.5 "Microfinance Loan" ///
		7 `""Online" "Lending""', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph8, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Women's DFS Lending Behavior (Stay-at-Home Spouse).png", replace	
		
graph combine graph5 graph6 graph7 graph8, iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/DFS Lending Behavior by Gender (Combined).png", replace	

******************GRAPH 9************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis.dta" 

***VARIABLES CREATION FOR DFS, KNOWLEDGE, SAVINGS ATTITUTDE, & INVOLVEMENT***

///DFS

gen everused_dfs = 0
replace everused_dfs = 1 if bi_e25_3==1 | bi_e25_4 == 1 | cvd3num==1

gen women_dfs = 0
replace women_dfs = 1 if female==1 & everused_dfs==1

gen women_no_dfs = 0
replace women_no_dfs = 1 if female==1 & everused_dfs==0

gen men_dfs = 0
replace men_dfs = 1 if female==0 & everused_dfs==1

gen men_no_dfs = 0
replace men_no_dfs = 1 if female==0 & everused_dfs==0

///Knowledge

gen know_bank = 0
replace know_bank = 1 if bi_e24a_1==1 | bi_e4s==1 | bi_e24a_5==1

gen know_emoney = 0
replace know_emoney = 1 if bi_e24_3==1 | bi_e24_4==1

///Attitude

*Note From Codebook: QUA1.1 - 1.5 = Savings, QUA1.6 - 1.11 = Loan, QUA1.12 - 1.13 = Customer Service

destring qua1_1, gen(qua1_1num)
destring qua1_2, gen(qua1_2num)
destring qua1_3, gen(qua1_3num)
destring qua1_4, gen(qua1_4num)
destring qua1_5, gen(qua1_5num)

recode qua1_1num (2=0)
recode qua1_2num (2=0)
recode qua1_3num (2=0)
recode qua1_4num (2=0)
recode qua1_5num (2=0)

egen savings_att = rowtotal (qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num)
replace savings_att = . if qua1_1num==. | qua1_2num==. | qua1_3num==. | qua1_4num==. | qua1_5num==. 

destring qua1_6, gen(qua1_6num)
destring qua1_7, gen(qua1_7num)
destring qua1_8, gen(qua1_8num)
destring qua1_9, gen(qua1_9num)
destring qua1_10, gen(qua1_10num)
destring qua1_11, gen(qua1_11num)

recode qua1_6num (2=0)
recode qua1_7num (2=0)
recode qua1_8num (2=0)
recode qua1_9num (2=0)
recode qua1_10num (2=0)
recode qua1_11num (2=0)

egen lending_att = rowtotal (qua1_6num qua1_7num qua1_8num qua1_9num qua1_10num qua1_11num)
replace lending_att = . if qua1_6num==. | qua1_7num==. | qua1_8num==. | qua1_9num==. | qua1_10num==. | qua1_11num==. 

///Involvement

gen gn1dummy = 0
replace gn1dummy = 1 if gn1==4 | gn1== 5
replace gn1dummy = . if gn1==98 | gn1==99

gen gn5dummy = 0
replace gn5dummy = 1 if gn5==4 | gn5== 5
replace gn5dummy = . if gn5==98 | gn5==99

gen gn6dummy = 0
replace gn6dummy = 1 if gn6==4 | gn6== 5
replace gn6dummy = . if gn6==98 | gn6==99

gen involvement = 0
replace involvement = 1 if gn1dummy==1 | gn5dummy==1 | gn6dummy==1

gen high_involvement = 0
replace high_involvement = 1 if gn1dummy==1 & gn5dummy==1 & gn6dummy==1

save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta", replace

***COUNT***

count if women_no_dfs==1 & low_economic_status==1
gl c_womennodfs = `r(N)'	

count if men_no_dfs==1 & low_economic_status==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney  {
	
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 1
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.5
 mat res [2,6] = 2
 mat res [3,6] = 3
 mat res [4,6] = 3.5

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 women
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if women==1, barwidth(0.5)) || ///
		(bar mean marker if women==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Knowledge of Savings Account") subtit("Low Economic Status") ///
		legend(order(1 2) label(1 "Women No DFS [n=$c_womennodfs]") label(2 "Men No DFS [n=$c_mennodfs]") size(small)) ///
		xlabel(1.75 "Know Bank" 3.25 "Know E-Money", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph9, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Knowledge of Savings Account (Low Economic Status).png", replace	
		
******************GRAPH 10************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womennodfs = `r(N)'	

count if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney  {
	
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 1
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.5
 mat res [2,6] = 2
 mat res [3,6] = 3
 mat res [4,6] = 3.5

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 women
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if women==1, barwidth(0.5)) || ///
		(bar mean marker if women==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Knowledge of Savings Account") subtit("Workers") ///
		legend(order(1 2) label(1 "Women No DFS [n=$c_womennodfs]") label(2 "Men No DFS [n=$c_mennodfs]") size(small)) ///
		xlabel(1.75 "Know Bank" 3.25 "Know E-Money", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph10, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Knowledge of Savings Account (Workers).png", replace	
		
******************GRAPH 11************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_no_dfs==1 & is_umkm_workers_method==1
gl c_womennodfs = `r(N)'	

count if men_no_dfs==1 & is_umkm_workers_method==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney  {
	
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 1
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.5
 mat res [2,6] = 2
 mat res [3,6] = 3
 mat res [4,6] = 3.5

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 women
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if women==1, barwidth(0.5)) || ///
		(bar mean marker if women==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Knowledge of Savings Account") subtit("MSME") ///
		legend(order(1 2) label(1 "Women No DFS [n=$c_womennodfs]") label(2 "Men No DFS [n=$c_mennodfs]") size(small)) ///
		xlabel(1.75 "Know Bank" 3.25 "Know E-Money", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph11, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Knowledge of Savings Account (MSME).png", replace	
		
******************GRAPH 12************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_no_dfs==1 & stayathome_spouse==1
gl c_womennodfs = `r(N)'	

count if men_no_dfs==1 & stayathome_spouse==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney  {
	
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 1
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// Women
		mat res[`row',5] = 0
	
		local ++row
		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.5
 mat res [2,6] = 2
 mat res [3,6] = 3
 mat res [4,6] = 3.5

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 women
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if women==1, barwidth(0.5)) || ///
		(bar mean marker if women==0, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Knowledge of Savings Account") subtit("Stay-at-Home Spouse") ///
		legend(order(1 2) label(1 "Women No DFS [n=$c_womennodfs]") label(2 "Men No DFS [n=$c_mennodfs]") size(small)) ///
		xlabel(1.75 "Know Bank" 3.25 "Know E-Money", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph12, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Knowledge of Savings Account (Stay-at-Home Spouse).png", replace	
		
graph combine graph9 graph10 graph11 graph12, iscale(0.6)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/Knowledge of Savings Account (Combined).png", replace	

******************GRAPH 13************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & low_economic_status==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & low_economic_status==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & low_economic_status==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & low_economic_status==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in savings_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 3)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Savings Product") subtit("Low Economic Status") /// 
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph13, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Savings Product (Low Economic Status).png", replace	
		
******************GRAPH 14************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in savings_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 3)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Savings Product") subtit("Workers") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph14, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Savings Product (Workers).png", replace	

******************GRAPH 15************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & is_umkm_workers_method==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & is_umkm_workers_method==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & is_umkm_workers_method==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & is_umkm_workers_method==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in savings_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 3)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Savings Product") subtit("MSME") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph15, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Savings Product (MSME).png", replace	

******************GRAPH 16************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & stayathome_spouse==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & stayathome_spouse==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & stayathome_spouse==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & stayathome_spouse==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in savings_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 3)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Savings Product") subtit("Stay-at-Home Spouse") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph16, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Savings Product (Stay-at-Home Spouse).png", replace	

graph combine graph13 graph14 graph15 graph16, iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/Attitude Towards Savings Product (Combined).png", replace	

******************GRAPH 17************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & low_economic_status==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & low_economic_status==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & low_economic_status==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & low_economic_status==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in digital_readiness {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Digital Readiness") subtit("Low Economic Status") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph17, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Digital Readiness (Low Economic Status).png", replace	

******************GRAPH 18************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in digital_readiness {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Digital Readiness") subtit("Workers") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph18, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Digital Readiness (Workers).png", replace	

******************GRAPH 19************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & is_umkm_workers_method==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & is_umkm_workers_method==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & is_umkm_workers_method==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & is_umkm_workers_method==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in digital_readiness {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Digital Readiness") subtit("MSME") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph19, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Digital Readiness (MSME).png", replace	

******************GRAPH 20************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & stayathome_spouse==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & stayathome_spouse==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & stayathome_spouse==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & stayathome_spouse==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in digital_readiness {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Digital Readiness") subtit("Stay-at-Home Spouse") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph20, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Digital Readiness (Stay-at-Home Spouse).png", replace	

graph combine graph17 graph18 graph19 graph20, iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/Digital Readiness (Combined).png", replace	

******************GRAPH 21************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & low_economic_status==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & low_economic_status==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & low_economic_status==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & low_economic_status==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in high_involvement {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Involvement in Household Spending Decision") subtit("Low Economic Status") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph21, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Involvement in Household Spending Decision (Low Economic Status).png", replace	

******************GRAPH 22************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in high_involvement {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Involvement in Household Spending Decision") subtit("Workers") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph22, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Involvement in Household Spending Decision (Workers).png", replace	

******************GRAPH 23************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & is_umkm_workers_method==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & is_umkm_workers_method==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & is_umkm_workers_method==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & is_umkm_workers_method==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in high_involvement {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Involvement in Household Spending Decision") subtit("MSME") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph23, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Involvement in Household Spending Decision (MSME).png", replace	

******************GRAPH 24************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & stayathome_spouse==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & stayathome_spouse==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & stayathome_spouse==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & stayathome_spouse==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in high_involvement {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Share (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("Involvement in Household Spending Decision") subtit("Stay-at-Home Spouse") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph24, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Involvement in Household Spending Decision (Stay-at-Home Spouse).png", replace	

graph combine graph21 graph22 graph23 graph24, iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/Involvement in Household Spending Decision (Combined).png", replace	

******************GRAPH 25************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & low_economic_status==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & low_economic_status==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & low_economic_status==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & low_economic_status==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in lending_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & low_economic_status==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 4)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Lending Product") subtit("Low Economic Status") /// 
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph25, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Lending Product (Low Economic Status).png", replace	
		
******************GRAPH 26************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in lending_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 4)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Lending Product") subtit("Workers") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph26, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Lending Product (Workers).png", replace	

******************GRAPH 27************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & is_umkm_workers_method==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & is_umkm_workers_method==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & is_umkm_workers_method==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & is_umkm_workers_method==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in lending_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & is_umkm_workers_method==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 4)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Lending Product") subtit("MSME") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph27, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Lending Product (MSME).png", replace	

******************GRAPH 28************************	
		
***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***COUNT***

count if women_dfs==1 & stayathome_spouse==1
gl c_womendfs = `r(N)'	

count if women_no_dfs==1 & stayathome_spouse==1
gl c_womennodfs = `r(N)'	

count if men_dfs==1 & stayathome_spouse==1
gl c_mendfs = `r(N)'	

count if men_no_dfs==1 & stayathome_spouse==1
gl c_mennodfs = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in lending_att  {
	
	** Women DFS
		// Mean
		sum `var' [w=weight] if women_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 1
	
		local ++row
		
	** Women No DFS
		// Mean
		sum `var' [w=weight] if women_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 2
	
		local ++row
		
	** Men DFS
		// Mean
		sum `var' [w=weight] if men_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 3
	
		local ++row
		
	** Men No DFS
		// Mean
		sum `var' [w=weight] if men_no_dfs==1 & stayathome_spouse==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Perception
		mat res[`row',4] = `perception'
		
		// DFS
		mat res[`row',5] = 4
	
		local ++row


		
	local ++perception
}

***GENERATE MARKERS***
 mat res [1,6] = 1.75
 mat res [2,6] = 2.25
 mat res [3,6] = 3.25
 mat res [4,6] = 3.75

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 perception
rename res5 dfs
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if dfs==1, barwidth(0.5)) || ///
		(bar mean marker if dfs==2, barwidth(0.5)) || ///
		(bar mean marker if dfs==3, barwidth(0.5)) || ///
		(bar mean marker if dfs==4, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Points", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 4)) ylab(#5, labsize(small)) ///
		xtit("") title("Attitude Towards Lending Product") subtit("Stay-at-Home Spouse") ///
		legend(off) ///
		xlabel(1.75 "Women DFS [n=$c_womendfs]" 2.25 "Women No DFS [n=$c_womennodfs]" 3.25 "Men DFS [n=$c_mendfs]" 3.75 "Men No DFS [n=$c_mennodfs]", ///
		angle(hor) labsize(2) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (5) name(graph28, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Attitude Towards Lending Product (Stay-at-Home Spouse).png", replace	

graph combine graph25 graph26 graph27 graph28, iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/Combined/Attitude Towards Lending Product (Combined).png", replace	

******************COMPARISON TABLE: REASONS FOR NOT HAVING SAVINGS ACCOUNT VS ATTITUDE TOWARDS SAVINGS PRODUCTS************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis2.dta" 

***Variables Generation***

gen women_no_bank_dfs = 0
replace women_no_bank_dfs = 1 if female==1 & currentlyhave_bank==0 & everused_dfs == 0

gen men_no_bank_dfs = 0
replace men_no_bank_dfs = 1 if female==0 & currentlyhave_bank==0 & everused_dfs == 0

gen loweconstatus1only = 1 if low_economic_status== 1

gen workers1only = 1 if fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1

gen msme1only = 1 if is_umkm_workers_method==1

gen stayathome1only = 1 if stayathome_spouse==1

destring bi_e2a1, gen(nobank_reason_religion)
destring bi_e2a2, gen(nobank_reason_donotneed)
destring bi_e2a3, gen(nobank_reason_donotbelieve)
destring bi_e2a4, gen(nobank_reason_faraway)
destring bi_e2a5, gen(nobank_reason_admincost)
destring bi_e2a6, gen(nobank_reason_notenoughmoney)
destring bi_e2a7, gen(nobank_reason_notenoughdocument)
destring bi_e2a8, gen(nobank_reason_badservice)
destring bi_e2a9, gen(nobank_reason_familyalreadyhave)
destring bi_e2a10, gen(nobank_reason_prefercash)
destring bi_e2a11, gen(nobank_reason_notenoughinfo)
destring bi_e2a12, gen(nobank_reason_neverknew)
destring bi_e2a13, gen(nobank_reason_complicatedform)
destring bi_e2a96, gen(nobank_reason_others)


recode nobank_reason_religion (2=0)
recode nobank_reason_donotneed (2=0)
recode nobank_reason_donotbelieve (2=0)
recode nobank_reason_faraway (2=0)
recode nobank_reason_admincost (2=0)
recode nobank_reason_notenoughmoney (2=0)
recode nobank_reason_notenoughdocument (2=0)
recode nobank_reason_badservice (2=0)
recode nobank_reason_familyalreadyhave (2=0)
recode nobank_reason_prefercash (2=0)
recode nobank_reason_notenoughinfo (2=0)
recode nobank_reason_neverknew (2=0)
recode nobank_reason_complicatedform (2=0)
recode nobank_reason_others (2=0)

lab var nobank_reason_religion "Religious Reason"
lab var nobank_reason_donotneed "Don't Need One"
lab var nobank_reason_donotbelieve "Don't Believe"
lab var nobank_reason_faraway "Too Far Away"
lab var nobank_reason_admincost "Administration Cost"
lab var nobank_reason_notenoughmoney "Not Enough Money"
lab var nobank_reason_notenoughdocument "Not Enough Document"
lab var nobank_reason_badservice "Bad Service"
lab var nobank_reason_familyalreadyhave "Family Already Have"
lab var nobank_reason_prefercash "Prefer Cash"
lab var nobank_reason_notenoughinfo "Not Enough Information"
lab var nobank_reason_neverknew "Never Knew About Bank"
lab var nobank_reason_complicatedform "Complicated Registration Form"
lab var nobank_reason_others "Other Reasons"

lab var qua1_1num "QUA1.1: Expensive Administration Cost"
lab var qua1_2num "QUA1.2: High Minimum Balance"
lab var qua1_3num "QUA1.3: Burdensome Transaction Fee"
lab var qua1_4num "QUA1.4: Complicated Process"
lab var qua1_5num "QUA1.5: Too Many Requirements"


save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis3.dta", replace

foreach var in nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
 nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
 nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
 nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
 nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num {
	sum `var' if women_no_bank_dfs==1
	}


foreach var in nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
 nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
 nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
 nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
 nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num {
	sum `var' if women_no_bank_dfs==0
	}


foreach var in nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
 nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
 nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
 nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
 nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num {
	sum `var' if women_no_bank_dfs==1 | women_no_bank_dfs==0
	}

***TABLE TO LATEX***	

	eststo clear
	eststo AllF: estpost summarize nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
		nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
		nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
		nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
		nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num ///
		if women_no_bank_dfs==1
	eststo AllM: estpost summarize nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
		nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
		nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
		nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
		nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num ///
		if men_no_bank_dfs==1
		foreach group in loweconstatus1only workers1only msme1only stayathome1only {
	bysort `group': eststo : estpost summarize nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
		nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
		nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
		nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
		nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num ///
		if women_no_bank_dfs==1
		}
		foreach group in loweconstatus1only workers1only msme1only stayathome1only {
	bysort `group': eststo : estpost summarize nobank_reason_religion nobank_reason_donotneed nobank_reason_donotbelieve ///
		nobank_reason_faraway nobank_reason_admincost nobank_reason_notenoughmoney /// 
		nobank_reason_notenoughdocument nobank_reason_badservice nobank_reason_familyalreadyhave /// 
		nobank_reason_prefercash nobank_reason_notenoughinfo nobank_reason_neverknew /// 
		nobank_reason_complicatedform nobank_reason_others qua1_1num qua1_2num qua1_3num qua1_4num qua1_5num ///
		if men_no_bank_dfs==1
		}
	esttab using "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Stata to Latex Output/Reasons for Not Having Savings Account.tex", ///
	title ("Reasons for Not Having Savings Account") mtitle ("All (F)" "All (M)" "Low Economic Status (F)" "Workers (F)" "MSME (F)" "Stay-at-Home Spouse (F)" "Low Economic Status (M)" "Workers (M)" "MSME (M)" "Stay-at-Home Spouse (M)") ///
	main("mean" %20.2fc) aux("sd" %20.2fc) ///
	label nodepvar nonumbers nonotes replace	

