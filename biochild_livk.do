************************
*** COHABITION YEARS *** 
************************
******using biochild.dta


* Group A: Cohabitation from before-w1 until before-w1 --> livk0_0
* Group B: Cohabitation from before-w1 (or later) until/after-w1 --> livk0_7
*-------------------------------------------------------------------------------

global path_in "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/3 Daten"  
global path_out "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/4 Analyse" 
set more off
use "$path_in/biochild.dta", clear
mvdecode _all, mv(-99/-1) 
drop pno pid parentid mid fid smid sfid sex sexk surveykid demodiff number cid imp_livkbeg imp_livkend

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
save "$path_in/biochild_livk_all.dta", replace

* Collaps Cohabition years per anchor and child
collapse (sum) livk_all, by(id index)
save "$path_in/biochild_livk_all_perchild.dta", replace

* Collaps Cohabition years per anchor
collapse (sum) livk_all, by(id)
label var livk_all "years of summarized child cohabitation (all children of anchor)"
save "$path_in/biochild_livk_all_peranchor.dta", replace

*-------------------------------------------------------------------------------

*DatensŠtze zusammenfŸhren
*merge 1:1 id using "$path_in/biochild_livk_all_peranchor.dta"







************************
**** ANDERE IDEEN  ***** 
************************


*-nokids
1=childless	(371 Personen)
0=parents	(1741 Personen)		insg. 2112, alle abgedeckt


*-nkidsliv
(number of all kids living together with anchor)
1kidliv
(>1 kid living with anchor) 
only main residence or living in any way?


*chidlmrd + nokids
The variable childmrd indicates how many children LIVED at the anchor's main residence. Only cohabiting
children of the anchor are included, i.e. biological, adopted, step and foster children. The
information was derived from the household grid. The syntax used to compute the variable is contained
in Stata do-le hhsize.do.
childless (371)
Parents never lived with a child (121)
Parents lived with 1-9 children (1625)	insg. 2117 (?)
*generate nochildmrd (people never lived with at least 1 child in main residence)
*recode values, label variable, value lable container, value lables to varibale
generate nochildmrd =recode(childmrd, 0, 9)
recode nochildmrd (0=1) (9=0)
label var nochildmrd "people never lived with at least 1 child in main residence"
label define vnochildmrd 1"people never lived with at least 1 child in main residence" 0"people ever lived with at least 1 child in main residence"
label values nochildmrd vnochildmrd
numlabel vnochildmrd, add
tab nochildmrd
*generate parentnochildmrd (parents who have never lived with a child mrd)
gen pnochildmrd = nochildmrd if nokids==0
label var pnochildmrd "parents never lived with at least 1 child in main residence"
label define vpnochildmrd 1"parent never lived with at least 1 child in main residence" 0"parent ever lived with at least 1 child in main residence"
label values pnochildmrd vpnochildmrd
numlabel vpnochildmrd, add
tab pnochildmrd
*generate nokids_cohabs (excluding parents never lived with a child: containing childless and parents who have lived with a child)
gen nokids_cohabs = nochildmrd if pnochildmrd==0 | nokids==1
recode nokids_cohabs (0=1) (1=0)
label var nokids_cohabs "childless / parents lived with at least 1 child in main residence"
label define vnokids_cohabs 1"parents lived with at least 1 child mrd" 0"childless"
label values nokids_cohabs vnokids_cohabs
numlabel vnokids_cohabs, add
tab nokids_cohabs


*crn16k*
how often do you see child x?
bezieht sich nur auf kinder, die au§erhalb leben:
Respondents with one biological child x, who is still living and who is also the biological child of one of the
partners with whom the respondent was with after the previous wave, and who - if the respondent lives with this
partner - lives neither with the respondent nor with the other parent, or who - if the respondent does not live with
this partner - does not live exclusively with the respondent, or who is the child of a partner from a previous wave
and does not live exclusively with the respondent
1-5 mehrmals im Jahr oder šfter
generate seeing child


*-F-crn13k*i1 UND crn14k*i1
do you take care of child under 16 in the morning /afternoon
Respondents with a biological child x (irrespective of cohabitation) or a child x in the household (irrespective of
status), under the age of 16, to whom the respondent has contact (ag6kx=1 & (ehc10kx=1,...,8 | ehc9kx=1))
& (crn16kx?8,9,-1,-2)


