********************************************************************************
*****+--------------------------------------------------------------------------
*****| Do-File 2 zur Masterarbeit:                         
*****| Examining the Relationship between Fertility Patterns and Midlife Health in Germany 
*****+--------------------------------------------------------------------------	
*****|
*****| Author:	 Lisa-Maria Keck
*****| Abgabe:	 31.03.2022
*****+--------------------------------------------------------------------------
********************************************************************************
*****+--------------------------------------------------------------------------
*****| 
*****| Calculating Cohabition Years, using biochild.dta
*****|
*****+--------------------------------------------------------------------------

global path_in "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/3 Daten"  
global path_out "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/4 Analyse" 
set more off
use "$path_in/biochild.dta", clear
mvdecode _all, mv(-99/-1) 
drop pno pid parentid mid fid smid sfid sex sexk surveykid demodiff number cid imp_livkbeg imp_livkend

capture log close						
log using "$path_out/Log2_cohabiting_years.log", replace 

*drop cohort 1 and 2
keep if cohort==3 

*-------------------------------------------------------------------------------
* Group A: Cohabitation from before-w1 until before-w1 --> livk0_0
* Group B: Cohabitation from before-w1 (or later) until/after-w1 --> livk0_7
*-------------------------------------------------------------------------------

*Dummy: current cohabition with child (w1-w7)
gen currlivk = currliv
recode currlivk (1 2 = 1) (9 10 11 12 13 = 0)
label var currlivk "child living with anchor / with anchor and elsewhere"
label define vcurrlivk 1"living with child" 0"not living with child"
label values currlivk vcurrlivk
numlabel vcurrlivk, add
tab currlivk

*Years before w1: livkbeg and livkend were only asked in wave1, in regard to what happened before w1 
gen livkbeg_year = livkbeg/12+1900
label var livkbeg_year "year of beginning child cohabitation, before w1"
tab livkbeg_year

gen livkend_year = livkend/12+1900
label var livkend_year "year of ending child cohabitation, before w1"
tab livkend_year


*Year of birth child
gen dobk_year = dobk/12+1900 
label var dobk_year "birth year of child"
tab dobk_year
*Year of birth anchor
gen dob_year = dob/12+1900 
label var dob_year "birth year of anchor"
tab dob_year
*Year of interview
gen intdat_year = intdat/12+1900
label var intdat_year "year of interview"
tab intdat_year if wave==1
*Age of child at w1  
gen agek_w1 = intdat_year-dobk_year if wave==1
label var agek_w1 "supposed age of child, at time of interview wave 1"
tab agek_w1
*Test Alter Kind / Eltern (12608,  9593: bio Kinder gleich alt wie ihre Eltern???)
list if dobk_year<1980 


*-------------------------------------------------------------------------------
* A Cohabitation from before-w1 until before-w1 --> livk0_0

* only cases who stopped cohabitation befor w1
* automatically excluding cases with missing at livkend_year | livkbeg_year 
generate livk0_0 = livkend_year-livkbeg_year
label var livk0_0 "years of child cohabitation, from before w1 until before w1"
tab livk0_0


*-------------------------------------------------------------------------------
* B Cohabitation from before-w1 (or later) until/after-w1 --> livk0_7

*Cohabition years between beginning of cohabition and w1 interview (min:0 / max:age of child)
*excluding cases with cohabition ending before w1
gen livk0_1 = intdat_year-livkbeg_year if livkend==.
label var livk0_1 "years of child cohabitation, from before w1 until w1 interview"

*Sum cohabition years before w1 with cohabition years after w1
recode livk0_1 (.=0) 
generate livk0_7 = livk0_1+currlivk
label var livk0_7 "years of child cohabitation, from before w1 until after w1"


*-------------------------------------------------------------------------------
* Cohabition years of all cases in one variable
recode livk0_0 (.=0)
generate livk_all = livk0_0+livk0_7
label var livk_all "years of child cohabitation"
save "$path_in/Data4_cohabiting_years.dta", replace

* Collaps Cohabition years per anchor and child
collapse (sum) livk_all, by(id index)
save "$path_in/Data4_cohabiting_years.dta", replace

* Collaps Cohabition years per anchor
collapse (sum) livk_all, by(id)
label var livk_all "years of summarized child cohabitation (all children of anchor)"
save "$path_in/Data4_cohabiting_years.dta", replace

*-------------------------------------------------------------------------------

*Datensätze zusammenführen
*merge 1:1 id using "$path_in/biochild_livk_all_peranchor.dta"
