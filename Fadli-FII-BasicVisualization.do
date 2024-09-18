
* ==============================================================================
*
* Project			: FII Analysis - Basic Visualization
* Authors			: Fadli Jihad Dahana Setiawan
* Stata version  	: 14
* Date created		: January 2022
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

*KNOWLEDGE

*Know Bank

gen know_bank = 0
replace know_bank = 1 if bi_e24a_1==1 | bi_e4s==1 | bi_e24a_5==1

*Know E-Money

gen know_emoney = 0
replace know_emoney = 1 if bi_e24_3==1 | bi_e24_4==1

*Know Online Lending Platform 

gen know_onlinelending = 0
replace know_onlinelending = 1 if onl1==1

*EXPERIENCE - SAVINGS

*Ever Used Bank 

destring bi_e6s, gen(bi_e6snum)
destring bi_e25a, gen(bi_e25anum)

gen everused_saving_bank = 0
replace everused_saving_bank = 1 if ojk1a_1==2 | ojk1a_1==3 | ojk1a_1==4 | bi_e6snum==1 | bi_e25anum==1
replace everused_saving_bank = . if ojk1a_1==999 

*Ever Used Microfinance

gen everused_saving_microfinance = 0
replace everused_saving_microfinance = 1 if ojk13_1==1

*Ever Used E-Money

gen everused_saving_emoney = 0
replace everused_saving_emoney = 1 if bi_e25_3==1 | bi_e25_4 == 1

*EXPERIENCE - LENDING

*Ever Used Loan from Bank

gen everused_lending_bank = 0
replace everused_lending_bank = 1 if ojk1b_1==2 | ojk1b_1==3 | ojk1b_1==4 | ojk1b_2==2 | ojk1b_2==3 | ojk1b_2==4
replace everused_lending_bank = . if ojk1b_1==999 | ojk1b_2==999

*Ever Used Loan from Microfinance

gen everused_lending_microfinance = 0
replace everused_lending_microfinance = 1 if ojk13_2==1

*Ever Used Loan from Online Lending Platform

destring onl2, gen(onl2num)

gen everused_lending_online = 0
replace everused_lending_online = 1 if onl2num==1

*Ever Used Loan from Informal Platform

destring bi_e18a, gen(bi_e18anum)

gen everused_lending_informal = 0
replace everused_lending_informal = 1 if bi_e18anum==1

*OWNERSHIP

*Currently Have Bank 

gen currentlyhave_bank = 0
replace currentlyhave_bank = 1 if bi_e1_1==1 | bi_e5s==1 | fnx_1==1

*Currently Have Formal Loan

gen currentlyhave_formalloan = 0
replace currentlyhave_formalloan = 1 if bi_e14==1

*Currently Have Microfinance Account 

destring lkm_new1, gen(lkm_new1num)
destring cop3, gen(cop3_new)

gen currentlyhave_microfinance = 0
replace currentlyhave_microfinance = 1 if lkm_new1num==1 | cop3_new==1

*Currently Have E-Money 

gen currentlyhave_emoney = 0
replace currentlyhave_emoney = 1 if bi_e26_cd_3==1 | bi_e26_cd_4 ==1 | fnx_2==1

*Currently Have Informal Loan

gen currentlyhave_informalloan = 0
replace currentlyhave_informalloan = 1 if bi_e17==1

*USAGE (LAST 6 MONTHS)

*Used Bank Savings in Last 6 Months

gen used_banksavings_6mon = 0
replace used_banksavings_6mon = 1 if ojk14_1_6mon==1 | ojk14_2_6mon==1 | ojk14_3_6mon==1 | ojk14_4_6mon==1

*Used Bank Loans in Last 6 Months

gen used_bankloans_6mon = 0
replace used_bankloans_6mon = 1 if ojk14_5_6mon==1 | ojk14_6_6mon==1 

*Used Microfinance Savings in Last 6 Months

gen used_microfinancesavings_6mon = 0
replace used_microfinancesavings_6mon = 1 if ojk24_1_6mon==1 | ojk25_1_6mon==1 | ojk26_1_6mon==1

*Used Microfinance Lending in Last 6 Months

gen used_microfinancelending_6mon = 0
replace used_microfinancelending_6mon = 1 if ojk24_2_6mon==1 | ojk25_2_6mon==1 | ojk26_2_6mon==1

*Used E-Money in Last 6 Months

gen used_emoney_6mon = 0
replace used_emoney_6mon = 1 if gf3b_6mon

*Used Informal Savings in Last 6 Months

gen used_informalsavings_6mon = 0
replace used_informalsavings_6mon = 1 if bi_e13_1==1 | bi_e13_2 ==1 | bi_e13_3 ==1 | bi_e13_96==1

///Variable Check///

foreach var in know_bank know_emoney know_onlinelending ///
everused_saving_bank everused_saving_microfinance everused_saving_emoney ///
everused_lending_bank everused_lending_microfinance everused_lending_online everused_lending_informal ///
currentlyhave_bank currentlyhave_formalloan currentlyhave_microfinance currentlyhave_emoney currentlyhave_informalloan ///
used_banksavings_6mon used_bankloans_6mon used_microfinancesavings_6mon used_microfinancelending_6mon used_emoney_6mon used_informalsavings_6mon {

sum `var'
tab `var'
} 

/* SOME NOTES

sum resp_age if female==1 & know_emoney==1
sum resp_age if female==1 & know_emoney==0
sum resp_age if female==0 & know_emoney==1
sum resp_age if female==0 & know_emoney==0

tab highestedu_respondent if know_emoney==1
tab highestedu_respondent if know_emoney==0

sum urban if know_emoney==1 & everused_saving_emoney==1
sum urban if know_emoney==1 & everused_saving_emoney==0
sum everused_saving_emoney if urban==1
sum everused_saving_emoney if urban==0

sum own_smartphone if know_emoney==1 & everused_saving_emoney==1 
sum own_smartphone if know_emoney==1 & everused_saving_emoney==0  

sum low_economic_status if know_emoney==1 & everused_saving_emoney==1 
sum low_economic_status if know_emoney==1 & everused_saving_emoney==0 

gen know_used_emoney = know_emoney==1 & everused_saving_emoney==1 
logit digital_readiness own_smartphone low_economic_status female urban

sum everused_saving_emoney if digital_readiness==1 & know_emoney==1
sum everused_saving_emoney if digital_readiness==0 & know_emoney==1
sum everused_saving_emoney if urban==1 & know_emoney==1
sum everused_saving_emoney if urban==0 & know_emoney==1
sum everused_saving_emoney if low_economic_status==1 & know_emoney==1
sum everused_saving_emoney if low_economic_status==0 & know_emoney==1 

tab currentlyhave_emoney if everused_saving_emoney==1
tab currentlyhave_bank if everused_saving_bank==1 
sum currentlyhave_emoney if female==1 & everused_saving_emoney==1
sum currentlyhave_emoney if female==0 & everused_saving_emoney==1
sum female if everused_saving_emoney==1 & currentlyhave_emoney==0
sum female if everused_saving_emoney==1 & currentlyhave_emoney==1
sum urban if everused_saving_emoney==1 & currentlyhave_emoney==0
sum urban if everused_saving_emoney==1 & currentlyhave_emoney==1
sum negative_attitude if everused_saving_emoney==1 & currentlyhave_emoney==0
sum negative_attitude  if everused_saving_emoney==1 & currentlyhave_emoney==1

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

egen negative_attitude = rowmean (att_1 att_2 att_3 att_4 att_5 att_6 att_7 att_8 att_9 att_10 att_11 att_12 att_13)

egen negative_attitude_savings = rowmean (att_1 att_2 att_3 att_4 att_5 att_12 att_13)



sum negative_attitude if everused_saving_emoney==1 & currentlyhave_emoney==1

sum negative_attitude if everused_saving_emoney==1 & currentlyhave_emoney==0

sum negative_attitude if everused_saving_bank==1 & currentlyhave_bank==1

sum negative_attitude if everused_saving_bank==1 & currentlyhave_bank==0

sum negative_attitude_savings if everused_saving_emoney==1 & currentlyhave_emoney==1

sum negative_attitude_savings if everused_saving_emoney==1 & currentlyhave_emoney==0

sum negative_attitude_savings if everused_saving_bank==1 & currentlyhave_bank==1

sum negative_attitude_savings if everused_saving_bank==1 & currentlyhave_bank==0

*/


*Save Temp Dataset

save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta", replace

***GRAPHS CREATION***

******************GRAPH 1: KNOWLEDGE************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0 
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney know_onlinelending  {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 
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
		sum `var' [w=weight] if female==0
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Knowledge of Financial Services") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "E-Money" ///
		4.25  "Online Lending Platform", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank savings, basic savings account (BSA), and ATM/Debit Card" "E-Money variable includes bank-based and non-bank-based mobile electronic money") ///
		xsize (7) name(graph1, replace) 

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Knowledge by Gender.png", replace	

******************GRAPH 2: KNOWLEDGE (Low Economic Status)***********************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & low_economic_status==1
gl c_female = `r(N)'

count if female==0 & low_economic_status==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney know_onlinelending  {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "E-Money" ///
		4.25  "Online Lending Platform", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph2, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Knowledge by Gender (Low Economic Status).png", replace	

******************GRAPH 3: KNOWLEDGE (Workers)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney know_onlinelending  {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "E-Money" ///
		4.25  "Online Lending Platform", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph3, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Knowledge by Gender (Workers).png", replace	

******************GRAPH 4: KNOWLEDGE (MSME)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney know_onlinelending  {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "E-Money" ///
		4.25  "Online Lending Platform", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph4, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Knowledge by Gender (MSME).png", replace	

******************GRAPH 5: KNOWLEDGE (Stay-at-Home Spouse)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in know_bank know_emoney know_onlinelending  {

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
 mat res [1,6] = 1.25
 mat res [2,6] = 2.75
 mat res [3,6] = 4.25

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "E-Money" ///
		4.25  "Online Lending Platform", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph5, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Knowledge by Gender (Stay-at-Home Spouse).png", replace	

graph combine graph2 graph3 graph4 graph5, iscale(0.5) ///
		title("Knowledge of Financial Services") ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank savings, basic savings account (BSA), and ATM/Debit Card" "E-Money variable includes bank-based and non-bank-based mobile electronic money")

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Knowledge by Gender (Combined).png", replace	

******************GRAPH 6: EXPERIENCE - SAVINGS************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0 
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_saving_bank everused_saving_microfinance everused_saving_emoney {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 
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
		sum `var' [w=weight] if female==0
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Experience of Using Financial Services (Savings)") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "E-Money" "', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank savings (sharia and conventional), basic savings account (BSA), and ATM/Debit Card" "E-Money variable includes bank-based and non-bank-based mobile electronic money as well as internet banking") ///
		xsize (7) name(graph6, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Savings) by Gender.png", replace	

******************GRAPH 7: EXPERIENCE - SAVINGS (Low Economic Status)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & low_economic_status==1
gl c_female = `r(N)'

count if female==0 & low_economic_status==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_saving_bank everused_saving_microfinance everused_saving_emoney {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "E-Money" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph7, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Savings) by Gender (Low Economic Status).png", replace	

******************GRAPH 8: EXPERIENCE - SAVINGS (Workers)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_saving_bank everused_saving_microfinance everused_saving_emoney {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "E-Money" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph8, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Savings) by Gender (Workers).png", replace	

******************GRAPH 9: EXPERIENCE - SAVINGS (MSME)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_saving_bank everused_saving_microfinance everused_saving_emoney {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "E-Money" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph9, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Savings) by Gender (MSME).png", replace	

******************GRAPH 10: EXPERIENCE - SAVINGS (Stay-at-Home Spouse)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_saving_bank everused_saving_microfinance everused_saving_emoney {

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
 mat res [1,6] = 1.25
 mat res [2,6] = 2.75
 mat res [3,6] = 4.25

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .8)) ylab(#5, labsize(small)) ///
		xtit("") title("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "E-Money" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph10, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Savings) by Gender (Stay-at-Home Spouse).png", replace	

graph combine graph7 graph8 graph9 graph10, iscale(0.5) ///
		title("Experience of Using Financial Services (Savings)") ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank savings (sharia and conventional), basic savings account (BSA), and ATM/Debit Card" "E-Money variable includes bank-based and non-bank-based mobile electronic money as well as internet banking")		

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Savings) by Gender (Combined).png", replace	

******************GRAPH 11: EXPERIENCE - LENDING************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0 
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_lending_bank everused_lending_microfinance everused_lending_online everused_lending_informal {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 
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
		sum `var' [w=weight] if female==0
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .2)) ylab(#5, labsize(small)) ///
		xtit("") title("Experience of Using Financial Services (Lending)") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "Online Lending Platforms" "' ///
		5.75  `" "Everused"  "Informal Platforms" "', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank loan both with and without collateral" "Informal Platforms include friends, family, neighbour, social gatherings, and loan sharks") ///
		xsize (7) name(graph11, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Lending) by Gender.png", replace	

******************GRAPH 12: EXPERIENCE - LENDING (Low Economic Status)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & low_economic_status==1
gl c_female = `r(N)'

count if female==0 & low_economic_status==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_lending_bank everused_lending_microfinance everused_lending_online everused_lending_informal {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .2)) ylab(#5, labsize(small)) ///
		xtit("") title("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "Online Lending Platforms" "' ///
		5.75  `" "Everused"  "Informal Platforms" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph12, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Lending) by Gender (Low Economic Status).png", replace	

******************GRAPH 13: EXPERIENCE - LENDING (Workers)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_lending_bank everused_lending_microfinance everused_lending_online everused_lending_informal {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .2)) ylab(#5, labsize(small)) ///
		xtit("") title("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "Online Lending Platforms" "' ///
		5.75  `" "Everused"  "Informal Platforms" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph13, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Lending) by Gender (Workers).png", replace	

******************GRAPH 14: EXPERIENCE - LENDING (MSME)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_lending_bank everused_lending_microfinance everused_lending_online everused_lending_informal {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .2)) ylab(#5, labsize(small)) ///
		xtit("") title("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "Online Lending Platforms" "' ///
		5.75  `" "Everused"  "Informal Platforms" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph14, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Lending) by Gender (MSME).png", replace	

******************GRAPH 15: EXPERIENCE - LENDING (Stay-at-Home Spouse)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in everused_lending_bank everused_lending_microfinance everused_lending_online everused_lending_informal {

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
 mat res [1,6] = 1.25
 mat res [2,6] = 2.75
 mat res [3,6] = 4.25
 mat res [4,6] = 5.75
 
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .2)) ylab(#5, labsize(small)) ///
		xtit("") title("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female]") size(small)) ///
		xlabel(1.25 `" "Everused"  "Bank" "' ///
		2.75  `" "Everused"  "Microfinance" "' ///
		4.25  `" "Everused"  "Online Lending Platforms" "' ///
		5.75  `" "Everused"  "Informal Platforms" "', ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph15, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Lending) by Gender (Stay-at-Home Spouse).png", replace	

graph combine graph12 graph13 graph14 graph15, iscale(0.5) ///
		title("Experience of Using Financial Services (Lending)") ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank loan both with and without collateral" "Informal Platforms include friends, family, neighbour, social gatherings, and loan sharks")		

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Experience (Lending) by Gender (Combined).png", replace	

******************GRAPH 16: OWNERSHIP************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0 
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank currentlyhave_formalloan currentlyhave_microfinance currentlyhave_emoney currentlyhave_informalloan {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 
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
		sum `var' [w=weight] if female==0
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Ownership of Financial Services Account") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "Formal Loan" ///
		4.25  "Microfinance & Cooperatives" ///
		5.75  "E-Money" ///
		7.25 "Informal Loan", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank savings and BSA" "E-Money variable includes bank-based and non-bank-based mobile electronic money" "Informal Loan includes friends, family, neighbour, social gatherings, and loan sharks") ///
		xsize (7) name(graph16, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Ownership by Gender.png", replace	

******************GRAPH 17: OWNERSHIP (Low Economic Status)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & low_economic_status==1
gl c_female = `r(N)'

count if female==0 & low_economic_status==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank currentlyhave_formalloan currentlyhave_microfinance currentlyhave_emoney currentlyhave_informalloan {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "Formal Loan" ///
		4.25  "Microfinance & Cooperatives" ///
		5.75  "E-Money" ///
		7.25 "Informal Loan", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph17, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Ownership by Gender (Low Economic Status).png", replace	

******************GRAPH 18: OWNERSHIP (Workers)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank currentlyhave_formalloan currentlyhave_microfinance currentlyhave_emoney currentlyhave_informalloan {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "Formal Loan" ///
		4.25  "Microfinance & Cooperatives" ///
		5.75  "E-Money" ///
		7.25 "Informal Loan", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph18, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Ownership by Gender (Workers).png", replace	

******************GRAPH 19: OWNERSHIP (MSME)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank currentlyhave_formalloan currentlyhave_microfinance currentlyhave_emoney currentlyhave_informalloan {

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "Formal Loan" ///
		4.25  "Microfinance & Cooperatives" ///
		5.75  "E-Money" ///
		7.25 "Informal Loan", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph19, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Ownership by Gender (MSME).png", replace	

******************GRAPH 20: OWNERSHIP (Stay-at-Home Spouse)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in currentlyhave_bank currentlyhave_formalloan currentlyhave_microfinance currentlyhave_emoney currentlyhave_informalloan {

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
 mat res [1,6] = 1.25
 mat res [2,6] = 2.75
 mat res [3,6] = 4.25
 mat res [4,6] = 5.75
 mat res [5,6] = 7.25

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female]") size(small)) ///
		xlabel(1.25 "Bank" ///
		2.75  "Formal Loan" ///
		4.25  "Microfinance & Cooperatives" ///
		5.75  "E-Money" ///
		7.25 "Informal Loan", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph20, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Ownership by Gender (Stay-at-Home Spouse).png", replace	

graph combine graph17 graph18 graph19 graph20, iscale(0.5) ///
		title("Ownership of Financial Services Account") ///	
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank variable includes bank savings and BSA" "E-Money variable includes bank-based and non-bank-based mobile electronic money" "Informal Loan includes friends, family, neighbour, social gatherings, and loan sharks")

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Ownership by Gender (Combined).png", replace	

******************GRAPH 21: USAGE (LAST 6 MONTHS)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0 
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_banksavings_6mon used_bankloans_6mon used_microfinancesavings_6mon used_microfinancelending_6mon used_emoney_6mon used_informalsavings_6mon {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 
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
		sum `var' [w=weight] if female==0
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
 mat res [11,6] = 8.5
 mat res [12,6] = 9


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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Usage of Financial Services in the Last 6 Months") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Bank Loans" ///
		4.25  "MF Savings" ///
		5.75  "MF Lending" ///
		7.25 "E-Money" ///
		8.75 "InformalSavings", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank savings also includes BSA" "Microfinance variables also include cooperatives" "E-Money variable includes bank-based and non-bank-based mobile electronic money" "Informal savings includes friends, family, neighbour, social gatherings, and loan sharks") ///
		xsize (7) name(graph21, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Usage (Last 6 Months) by Gender.png", replace	

******************GRAPH 22: USAGE (LAST 6 MONTHS - Low Economic Status)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & low_economic_status==1
gl c_female = `r(N)'

count if female==0 & low_economic_status==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_banksavings_6mon used_bankloans_6mon used_microfinancesavings_6mon used_microfinancelending_6mon used_emoney_6mon used_informalsavings_6mon {

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
 mat res [11,6] = 8.5
 mat res [12,6] = 9


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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Bank Loans" ///
		4.25  "MF Savings" ///
		5.75  "MF Lending" ///
		7.25 "E-Money" ///
		8.75 "InformalSavings", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph22, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Usage (Last 6 Months) by Gender (Low Economic Status).png", replace	

******************GRAPH 23: USAGE (LAST 6 MONTHS - Workers)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_female = `r(N)'

count if female==0 & (fulltime_salaried== 1 | parttime_salaried==1 | temp_seasonal==1)
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_banksavings_6mon used_bankloans_6mon used_microfinancesavings_6mon used_microfinancelending_6mon used_emoney_6mon used_informalsavings_6mon {

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
 mat res [11,6] = 8.5
 mat res [12,6] = 9


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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Workers") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Bank Loans" ///
		4.25  "MF Savings" ///
		5.75  "MF Lending" ///
		7.25 "E-Money" ///
		8.75 "InformalSavings", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph23, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Usage (Last 6 Months) by Gender (Workers).png", replace	

******************GRAPH 24: USAGE (LAST 6 MONTHS - MSME)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & is_umkm_workers_method==1
gl c_female = `r(N)'

count if female==0 & is_umkm_workers_method==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_banksavings_6mon used_bankloans_6mon used_microfinancesavings_6mon used_microfinancelending_6mon used_emoney_6mon used_informalsavings_6mon {

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
 mat res [11,6] = 8.5
 mat res [12,6] = 9


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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("MSME") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Bank Loans" ///
		4.25  "MF Savings" ///
		5.75  "MF Lending" ///
		7.25 "E-Money" ///
		8.75 "InformalSavings", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph24, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Usage (Last 6 Months) by Gender (MSME).png", replace	

******************GRAPH 25: USAGE (LAST 6 MONTHS - Stay-at-Home Spouse)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

***COUNT***

count if female==1 & stayathome_spouse==1
gl c_female = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_banksavings_6mon used_bankloans_6mon used_microfinancesavings_6mon used_microfinancelending_6mon used_emoney_6mon used_informalsavings_6mon {

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
 mat res [1,6] = 1.25
 mat res [2,6] = 2.75
 mat res [3,6] = 4.25
 mat res [4,6] = 5.75
 mat res [5,6] = 7.25
 mat res [6,6] = 8.75
 

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 .6)) ylab(#5, labsize(small)) ///
		xtit("") title("Stay-at-Home Spouse") ///
		legend(order(1) label(1 "Female [n=$c_female]") size(small)) ///
		xlabel(1.25 "Bank Savings" ///
		2.75  "Bank Loans" ///
		4.25  "MF Savings" ///
		5.75  "MF Lending" ///
		7.25 "E-Money" ///
		8.75 "InformalSavings", ///
		angle(hor) labsize(small) notick) ///
		xsize (7) name(graph25, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Usage (Last 6 Months) by Gender (Stay-at-Home Spouse).png", replace	

graph combine graph22 graph23 graph24 graph25, iscale(0.5) ///
		title("Usage of Financial Services in the Last 6 Months") ///
				caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Bank savings also includes BSA" "Microfinance variables also include cooperatives" "E-Money variable includes bank-based and non-bank-based mobile electronic money" "Informal savings includes friends, family, neighbour, social gatherings, and loan sharks")

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/DFS Usage (Last 6 Months) by Gender (Combined).png", replace	

******************GRAPH 26: Bank Savings Ownership Among Experienced Men and Women************************	

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen have_used_bank = everused_saving_bank==1 & currentlyhave_bank==1
gen nothave_used_bank = everused_saving_bank==1 & currentlyhave_bank==0

count if female==1 & everused_saving_bank==1
gl c_female = `r(N)'

count if female==0 & everused_saving_bank==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar have_used_bank nothave_used_bank if everused_saving_bank==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Bank Savings") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
legend(label(1 "Currently Have") ///
			label(2 "Not Currently Have"))
			
graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Bank Savings Ownership Among Experienced Men and Women.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph26.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph26.gph", replace
			
******************GRAPH 27: Bank Loan Ownership Among Experienced Men and Women************************	
	
gen have_used_bankloan = everused_lending_bank==1 & currentlyhave_formalloan==1
gen nothave_used_bankloan = everused_lending_bank==1 & currentlyhave_formalloan==0

count if female==1 & everused_lending_bank==1
gl c_female = `r(N)'

count if female==0 & everused_lending_bank==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar have_used_bankloan nothave_used_bankloan if everused_lending_bank==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Bank Loans") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
legend(label(1 "Currently Have") ///
			label(2 "Not Currently Have"))
			
graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Bank Loan Ownership Among Experienced Men and Women.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph27.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph27.gph", replace
			
******************GRAPH 28: Emoney Ownership Among Experienced Men and Women************************	
			
gen have_used_emoney = everused_saving_emoney==1 & currentlyhave_emoney==1
gen nothave_used_emoney = everused_saving_emoney==1 & currentlyhave_emoney==0

count if female==1 & everused_saving_emoney==1
gl c_female = `r(N)'

count if female==0 & everused_saving_emoney==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar have_used_emoney nothave_used_emoney if everused_saving_emoney==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Emoney") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
legend(label(1 "Currently Have") ///
			label(2 "Not Currently Have")) 
			
graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Emoney Ownership Among Experienced Men and Women.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph28.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph28.gph", replace
			
graph combine graph26.gph graph27.gph graph28.gph, row(1) iscale(0.4) ///
		title("Financial Services Ownership") subtit("Among Experienced Men and Women") ///
		caption(" " "Source: Financial Inclusion Insights 2020", size(tiny) position(7)) 

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/(Combined) Ownership Among Experienced Men and Women.png", replace	

******************GRAPH 29: Emoney Knowledge (Know) Among Different Education Levels************************	

gen know_emoney_noformaleduc = know_emoney==1 & highestedu_respondent==1 | highestedu_respondent==9
gen know_emoney_primaryeduc = know_emoney==1 & highestedu_respondent==2 | highestedu_respondent==3
gen know_emoney_secondaryeduc = know_emoney==1 & highestedu_respondent==5 | highestedu_respondent==6
gen know_emoney_tertiaryeduc = know_emoney==1 & highestedu_respondent==7 | highestedu_respondent==8

count if female==1 & know_emoney==1
gl c_female = `r(N)'

count if female==0 & know_emoney==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar know_emoney_noformaleduc know_emoney_primaryeduc know_emoney_secondaryeduc know_emoney_tertiaryeduc if know_emoney==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Emoney Knowledge: Know") subtit("Among Different Education Levels") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
caption(" " "Source: Financial Inclusion Insights 2020", size(tiny) position(7)) name(graph29, replace) ///
legend(label(1 "No Education") label(2 "Primary") label(3 "Secondary") label(4 "Tertiary")) 

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Emoney Knowledge (Know) Among Different Education Levels.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph29.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph29.gph", replace
			
******************GRAPH 30: Emoney Knowledge (Don't Know) Among Different Education Levels************************	
		
gen noknow_emoney_noformaleduc = know_emoney==0 & highestedu_respondent==1 | highestedu_respondent==9
gen noknow_emoney_primaryeduc = know_emoney==0 & highestedu_respondent==2 | highestedu_respondent==3
gen noknow_emoney_secondaryeduc = know_emoney==0 & highestedu_respondent==5 | highestedu_respondent==6
gen noknow_emoney_tertiaryeduc = know_emoney==0 & highestedu_respondent==7 | highestedu_respondent==8

count if female==1 & know_emoney==0
gl c_female = `r(N)'

count if female==0 & know_emoney==0
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar noknow_emoney_noformaleduc noknow_emoney_primaryeduc noknow_emoney_secondaryeduc noknow_emoney_tertiaryeduc if know_emoney==0 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Emoney Knowledge: Don't Know") subtit("Among Different Education Levels") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
caption(" " "Source: Financial Inclusion Insights 2020", size(tiny) position(7)) name(graph30, replace) ///
legend(label(1 "No Education") label(2 "Primary") label(3 "Secondary") label(4 "Tertiary")) 

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Emoney Knowledge (Don't Know) Among Different Education Levels.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph30.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph30.gph", replace

graph combine graph29.gph graph30.gph, row(1) iscale(0.6)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Emoney Knowledge (Combined) Among Different Education Levels.png", replace	

******************GRAPH 31: Emoney Knowledge Among Different Average Age************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

egen avgage_female_knowemoney = mean(resp_age) if female==1 & know_emoney==1
egen avgage_female_noknowemoney = mean(resp_age) if female==1 & know_emoney==0

***COUNT***

count if female==1 
gl c_female = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in avgage_female_knowemoney avgage_female_noknowemoney {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 
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
mat res [1,6] = 1.25
mat res [2,6] = 2.75

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
set scheme jpalblue
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Average Age (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(1 45)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Knowledge By Average Age") subtit("Women") ///
		legend(order(1) label(1 "Female [n=$c_female]") size(small)) ///
		xlabel(1.25 "Know Emoney" ///
		2.75  "Don't Know Emoney", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph31a, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Knowledge by Average Age (Women).png", replace	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

egen avgage_male_knowemoney = mean(resp_age) if female==0 & know_emoney==1
egen avgage_male_noknowemoney = mean(resp_age) if female==0 & know_emoney==0

***COUNT***

count if female==0 
gl c_male = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in avgage_male_knowemoney avgage_male_noknowemoney {

	** Male respondents
		// Mean
		sum `var' [w=weight] if female==0
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
mat res [1,6] = 1.25
mat res [2,6] = 2.75

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
set scheme jpalteal
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Average Age (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(1 45)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Knowledge By Average Age") subtit("Men") ///
		legend(order(1) label(1 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Know Emoney" ///
		2.75  "Don't Know Emoney", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph31b, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Knowledge by Average Age (Men).png", replace	

graph combine graph31a graph31b, row(1) iscale(0.7)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Knowledge by Average Age (Combined).png", replace	

******************GRAPH 31: Emoney Knowledge Among Different Average Age (Alternate Version)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

egen avgage_female_knowemoney = mean(resp_age) if female==1 & know_emoney==1
egen avgage_female_noknowemoney = mean(resp_age) if female==1 & know_emoney==0
egen avgage_male_knowemoney = mean(resp_age) if female==0 & know_emoney==1
egen avgage_male_noknowemoney = mean(resp_age) if female==0 & know_emoney==0

sum resp_age if female==1 & know_emoney==1

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0
gl c_male = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in avgage_female_knowemoney avgage_female_noknowemoney avgage_male_knowemoney avgage_male_noknowemoney {

	** Female respondents
		// Mean
		sum `var' [w=weight] 
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
mat res [2,6] = 2
mat res [3,6] = 3
mat res [4,6] = 4

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
twoway 	(bar mean marker, barwidth(0.5)) ||, ///
		ytit("Average Age (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(1 45)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Knowledge By Average Age") subtit("Among Men and Women") ///
		xlabel(1 "Female - Know" ///
		2  "Female - Don't Know" ///
		3  "Male - Know" ///
		4  "Male - Don't Know", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		note("Number of Observation for Female = $c_female" "Number of Observation for Male = $c_male") ///
		xsize (7) name(graph31, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Knowledge by Average Age.png", replace	

******************GRAPH 31: Emoney Knowledge Among Different Average Age (Alternate Version-2)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

egen avgage_female_knowemoney = mean(resp_age) if female==1 & know_emoney==1
egen avgage_female_noknowemoney = mean(resp_age) if female==1 & know_emoney==0
egen avgage_male_knowemoney = mean(resp_age) if female==0 & know_emoney==1
egen avgage_male_noknowemoney = mean(resp_age) if female==0 & know_emoney==0

gen noknow_emoney = know_emoney == 0


***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0
gl c_male = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1

foreach var in know_emoney noknow_emoney {

	local gender = 1

	** Female respondents
		// Mean
		sum resp_age [w=weight] if female==1 & `var'==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `gender'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
		local ++gender
	
	** Male respondents
		// Mean
		sum resp_age [w=weight] if female==0 & `var'==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `gender'
		
		// Male
		mat res[`row',5] = 1
	
	local ++row
}

***GENERATE MARKERS***
mat res [1,6] = 1
mat res [2,6] = 1.5
mat res [3,6] = 2.5
mat res [4,6] = 3

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 female
rename res5 others
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==2, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Average Age (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(1 45)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Knowledge By Average Age") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Know E-Money" ///
		2.75  "Don't Know E-Money", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph31, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Knowledge by Average Age(VER-2).png", replace	

******************GRAPH 32: E-money Experience: Urban-Rural************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen used_emoney_urban = everused_saving_emoney==1 & urban==1
gen used_emoney_rural = everused_saving_emoney==1 & urban==0

***COUNT***

count if female==1 & everused_saving_emoney==1
gl c_female = `r(N)'

count if female==0 & everused_saving_emoney==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_emoney_urban used_emoney_rural {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & everused_saving_emoney==1
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
		sum `var' [w=weight] if female==0 & everused_saving_emoney==1
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Experience") subtit("Urban-Rural") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Urban" ///
		2.75  "Rural", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph32, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Experience (Urban-Rural).png", replace	

******************GRAPH 33: E-money Experience: Digital Readiness************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen used_emoney_digitalready = everused_saving_emoney==1 & digital_readiness==1
gen used_emoney_notdigitalready = everused_saving_emoney==1 & digital_readiness==0

***COUNT***

count if female==1 & everused_saving_emoney==1
gl c_female = `r(N)'

count if female==0 & everused_saving_emoney==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_emoney_digitalready used_emoney_notdigitalready {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & everused_saving_emoney==1
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
		sum `var' [w=weight] if female==0 & everused_saving_emoney==1
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Experience") subtit("Digital Readiness") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Digitally Ready" ///
		2.75  "Not Digitally Ready", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph33, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Experience (Digital Readiness).png", replace	

******************GRAPH 34: E-money Experience: Low Economic Status************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen used_emoney_lowecon = everused_saving_emoney==1 & low_economic_status==1
gen used_emoney_notlowecon = everused_saving_emoney==1 & low_economic_status==0

***COUNT***

count if female==1 & everused_saving_emoney==1
gl c_female = `r(N)'

count if female==0 & everused_saving_emoney==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_emoney_lowecon used_emoney_notlowecon {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & everused_saving_emoney==1
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
		sum `var' [w=weight] if female==0 & everused_saving_emoney==1
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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Experience") subtit("Low Economic Status") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Low Economic Status" ///
		2.75  "Not Low Economic Status", ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph34, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Experience (Low Economic Status).png", replace	

graph combine graph32 graph33 graph34, row(1) iscale(0.5)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Experience (Combined).png", replace	

******************GRAPH 35: Bank Savings Usage Among Experienced Men and Women************************	

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen use_used_bank = everused_saving_bank==1 & used_banksavings_6mon==1
gen notuse_used_bank = everused_saving_bank==1 & used_banksavings_6mon==0

count if female==1 & everused_saving_bank==1
gl c_female = `r(N)'

count if female==0 & everused_saving_bank==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar use_used_bank notuse_used_bank if everused_saving_bank==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Bank Savings") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
		legend(label(1 "Active User") ///
			label(2 "Not Active User")) 
			
graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Bank Savings Usage Among Experienced Men and Women.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph35.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph35.gph", replace
			
******************GRAPH 36: Bank Loan Usage Among Experienced Men and Women************************	
	
gen use_used_bankloan = everused_lending_bank==1 & used_bankloans_6mon==1
gen notuse_used_bankloan = everused_lending_bank==1 & used_bankloans_6mon==0

count if female==1 & everused_lending_bank==1
gl c_female = `r(N)'

count if female==0 & everused_lending_bank==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar use_used_bankloan notuse_used_bankloan if everused_lending_bank==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Bank Loans") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
		legend(label(1 "Active User") ///
			label(2 "Not Active User")) 
			
graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Bank Loan Usage Among Experienced Men and Women.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph36.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph36.gph", replace
			
******************GRAPH 37: Emoney Usage Among Experienced Men and Women************************	
			
gen use_used_emoney = everused_saving_emoney==1 & used_emoney_6mon==1
gen notuse_used_emoney = everused_saving_emoney==1 & used_emoney_6mon==0

count if female==1 & everused_saving_emoney==1
gl c_female = `r(N)'

count if female==0 & everused_saving_emoney==1
gl c_male = `r(N)'

set scheme jpalfull
graph set window fontface "Century Gothic"

graph bar use_used_emoney notuse_used_emoney if everused_saving_emoney==1 [w=weight], ///
over(female, ///
	relabel(1 `" "Men" "[n=$c_male]""' ///
				2 `" "Women" "[n=$c_female]""') label(labsize(*.8))) /// 
stack percentage nofill ///
title("Emoney") ///
ytit ("Proportion (weighted)", size(vsmall)) ///
		ylab (#5, labsize(vsmall)) ///
		legend(label(1 "Active User") ///
			label(2 "Not Active User")) 

			
graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/Emoney Usage Among Experienced Men and Women.png", replace	

graph save "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/graph37.gph", replace	

graph save "/Users/nursjamsiah/Documents/1JPAL/IFII/FII Gender Analysis/graph37.gph", replace
			
graph combine graph35.gph graph36.gph graph37.gph, row(1) iscale(0.4) ///
		title("Financial Services Usage") subtit("Among Experienced Men and Women") ///
		caption(" " "Source: Financial Inclusion Insights 2020", size(tiny) position(7)) 

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/(Combined) Usage Among Experienced Men and Women.png", replace	

******************GRAPH 38: Emoney Experience: Urban-Rural, Digital Readiness, & Low Economic Status************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen no_urban = urban== 0
gen no_digital_readiness = digital_readiness== 0
gen no_low_economic_status = low_economic_status==0

gen used_emoney_urban = everused_saving_emoney==1 & urban==1
gen used_emoney_rural = everused_saving_emoney==1 & no_urban==1
gen used_emoney_digitalready = everused_saving_emoney==1 & digital_readiness==1
gen used_emoney_notdigitalready = everused_saving_emoney==1 & no_digital_readiness==1
gen used_emoney_lowecon = everused_saving_emoney==1 & low_economic_status==1
gen used_emoney_nolowecon = everused_saving_emoney==1 & no_low_economic_status==1

***COUNT***

count if female==1 
gl c_female = `r(N)'

count if female==0
gl c_male = `r(N)'
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1

foreach var in used_emoney_urban used_emoney_rural used_emoney_digitalready used_emoney_notdigitalready used_emoney_lowecon used_emoney_nolowecon {

	local gender = 1

	** Female respondents
		// Mean
		sum everused_saving_emoney [w=weight] if female==1 & `var'==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `gender'
		
		// Female
		mat res[`row',5] = 1
		
		local ++row
		local ++gender
	
	** Male respondents
		// Mean
		sum everused_saving_emoney [w=weight] if female==0 & `var'==1
			mat res[`row',1] = r(mean)
			
		// Error bars
		local se = r(sd) / sqrt(r(N))	
			mat res[`row',2] = 	r(mean)-1.96*`se'
			mat res[`row',3] = 	r(mean)+1.96*`se'

		// Challenge type
		mat res[`row',4] = `gender'
		
		// Male
		mat res[`row',5] = 1
	
	local ++row
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
mat res [11,6] = 8.5
mat res [12,6] = 9

***REPLACE DATASET WITH MATRIX***

drop _all
svmat res
rename res1 mean
rename res2 ll
rename res3 ul
rename res4 female
rename res5 others
rename res6 marker

 
***CREATING THE GRAPH***

// Set scheme
set scheme jpalfull
graph set window fontface "Century Gothic"

// Vertical bar chart
twoway 	(bar mean marker if female==1, barwidth(0.5)) || ///
		(bar mean marker if female==2, barwidth(0.5)) || ///
		(rcap ll ul marker, lcol(gs4) lwidth(thin) msize(tiny)), ///
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Experience by Several Variables") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Urban" ///
		2.75  "Rural" ///
		4.25  "Digitally Ready" ///
		5.75  `" "Not"  "Digitally Ready" "' ///
		7.25  "Low Economic Status" ///
		8.75  `" "Not"  "Low Economic Status" "', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph38, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Experience by Several Variables.png", replace	

******************GRAPH 38: Emoney Experience: Urban-Rural, Digital Readiness, & Low Economic Status (VER-2)************************	

***IMPORT DATA (EDITABLE)***

clear 
set more off

use "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Build/Temp/fii2020forgenderanalysis-2.dta"

gen used_emoney_urban = everused_saving_emoney==1 & urban==1
gen used_emoney_rural = everused_saving_emoney==1 & urban==0
gen used_emoney_dr = everused_saving_emoney==1 & digital_readiness==1
gen used_emoney_nodr = everused_saving_emoney==1 & digital_readiness==0
gen used_emoney_lowecon = everused_saving_emoney==1 & low_economic_status==1
gen used_emoney_nolowecon = everused_saving_emoney==1 & low_economic_status==0

***COUNT***

count if female==1 & everused_saving_emoney==1
gl c_female = `r(N)'

count if female==0 & everused_saving_emoney==1
gl c_male = `r(N)'	
		
***MATRIX***

// Create matrix
clear matrix
mat res=J(50,6,.)

// Fill in matrix

local row = 1
local perception = 1

foreach var in used_emoney_urban used_emoney_rural used_emoney_dr used_emoney_nodr used_emoney_lowecon used_emoney_nolowecon {

	** Female respondents
		// Mean
		sum `var' [w=weight] if female==1 & everused_saving_emoney==1
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
		sum `var' [w=weight] if female==0 & everused_saving_emoney==1
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
mat res [11,6] = 8.5
mat res [12,6] = 9

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
		ytit("Percentage (Weighted)", size(small)) ///
		graphregion(color(white) fcolor(white)) ///
		yscale(range(0 1)) ylab(#5, labsize(small)) ///
		xtit("") title("E-Money Experience by Several Variables") subtit("Among Men and Women") ///
		legend(order(1 2) label(1 "Female [n=$c_female]") label(2 "Male [n=$c_male]") size(small)) ///
		xlabel(1.25 "Urban" ///
		2.75  "Rural" ///
		4.25  "Digitally Ready" ///
		5.75  `" "Not"  "Digitally Ready" "' ///
		7.25  "Low Economic Status" ///
		8.75  `" "Not"  "Low Economic Status" "', ///
		angle(hor) labsize(small) notick) ///
		caption(Source: Financial Inclusion Insights 2020, size(tiny) position(7) ) ///
		xsize (7) name(graph38, replace)

graph export "/Users/nursjamsiah/Dropbox/FII Analysis 2021/Data/Analysis/Gender Analysis/Graphs/NEW-January 2022/E-Money Experience by Several Variables(VER-2).png", replace	
