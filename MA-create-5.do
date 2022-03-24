********************************************************************************
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
********************************************************************************
*****+--------------------------------------------------------------------------
*****| 
*****|Preliminaries
*****|
*****+--------------------------------------------------------------------------

version 13
clear all
set more off	

global path_in "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/3 Daten"  
global path_out "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/4 Analyse" 

capture log close						
log using "$path_out/MA-create-Lisa-Maria-Keck.log", replace 

use hlt3 hlt4 hps1 lsr1i4 crn37k* crn2k*i* lsr1i2 crn15k* crn48k* crn33p* crn20i* crn30i* crn11i* crn32i* crn29i* crn19i* crn47i* crn22p* crn23k* frt* ehc7k*g ehc9k* ehc8k*y ehc11k* cle1i* cle2i* ehc10k* pmrd np ncoh nmar meetdur hhsizemrd nkidspalv nkidsliv nkidsbioliv nkidspliv pnkidsbioalv cla* hlt7 hlt10 hlt11i1 hlt11i2 hlt11i3 hlt12m hlt12y hlt13 hlt14 hlt1 per4i4 hlt17i7 hlt17i2 hlt15 hlt16 hlt17i3 hlt17i4 hlt17i1 per2i9 hlt17i5 hlt17i6 id cohort sex_gen dob*_gen age east cob migstatus relstat marstat reldur cohabdur mardur infertile pregnant enrol school vocat isced isced2 casmin yeduc kldb2010 isco08 isei siops casprim lfs nkids nkidsbio nkidsalv nkidsbioalv k*age ykage ykid nkidsliv nkidsbioliv k*type childmrd npu14mr npo14mr pmrd hhcomp mmrd fmrd incnet hhincnet hhincgcee hhincoecd frt7 frt9 using "$path_in/pairfam_anchor7_copy", clear
*using "$path_in/pairfam_anchor7_copy", clear 


*Feed pcs mcs from extra dataset // matched all
merge 1:1 id using "$path_in/anchor7_health_pcsmcs.dta", gen (merge_pcsmcs)
tab merge_pcsmcs 

*Paket estout inkl. esttab fŸr die Generierung professioneller Tabellen installieren
*ssc install estout , replace

*case reduction: elimintae cohort 1 and 2 --> n=2146
tab cohort
keep if cohort==3 

*recode all missings
mvdecode _all, mv(-11/-1) 

*Examining patterns of missing data for health variables 
*findit misschk 
*help missck
*generate a new variable with number of missings 
misschk hlt1 per4i4 hlt17i7 hlt17i2 hlt15 hlt16 hlt17i3 hlt17i4 hlt17i1 per2i9 hlt17i5 hlt17i6, gen(miss) replace
* delete cases with missings in health --> deleted 29 cases --> n=2117
keep if missnumber==0 


********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****|HEALTH: Calculating the SF12-Scores
*****|
*****+--------------------------------------------------------------------------
*****| Health Variables Overview
*****+--------------------------------------------------------------------------
*****|VARIABLES OF INTEREST Health:
*****|hlt1 hlt7 hlt15 hlt16 hlt17i1 sat6 hlt17i2 hlt17i3 hlt17i4 hlt17i5 hlt17i6 hlt17i7
*****|General health: 				hlt1	-->	gh
*****|Vitality:						per4i4 	-->	vt
*****|Social Functioning: 			hlt17i7	--> sf
*****|Physical Pain					hlt17i2 -->	pp
*****|Physical functioning 1:		hlt15 	-->	pf1
*****|Physical functioning 2:		hlt16 	-->	pf2
*****|Physical functioning sum:				--> pf
*****|Role problems, physical 1:	hlt17i3 --> pr1
*****|Role problems, physical 2:	hlt17i4 --> pr2
*****|Role problems, physical sum:			--> pr
*****|Mental health 1:				hlt17i1 --> mh1
*****|Mental health 2:				per2i9 	--> mh2
*****|Mental health sum:					--> mh
*****|Role problems, mental 1:		hlt17i5 --> mr1 
*****|Role problems, mental 2:		hlt17i6 --> mr2 
*****|Role problems, mental sum:			--> mr
*****+--------------------------------------------------------------------------
*****|renaming items and reverse coding when necessary (increasing value = increasing health)
*****+--------------------------------------------------------------------------

codebook hlt1 per4i4 hlt17i7 hlt17i2 hlt15 hlt16 hlt17i3 hlt17i4 hlt17i1 per2i9 hlt17i5 hlt17i6

generate gh=hlt1  
label variable gh "General health: How would you describe your health status in the past 4 weeks?"
label values gh liste118_ac7

generate vt=per4i4
label variable vt "Vitality: past four weeks, how often did you feel full of energy?" 
label values vt liste136_ac7

generate sf=hlt17i7
label variable sf "Past four weeks: due to physical or mental health problems you were limited socially?" 
recode sf (1=4) (2=3) (3=2) (4=1)  
label define liste250_ac7_rev 1 "1 Almost always" 2 "2 Often" 3 "3 Sometimes" 4 "4 Almost never" 
label values sf liste250_ac7_rev 

generate pp=hlt17i2
label variable pp "Physical pain: past four weeks, how often did you have severe physical pain?" 
recode pp (1=4) (2=3) (3=2) (4=1)
label values pp liste250_ac7_rev

generate pf1=hlt15
label variable pf1 "Physical functioning 1: does your health limit you to climb several flights of stairs on foot?" 
label define liste501_ac7_en 1 "1 Strongly" 2 "2 A little bit" 3 "3 Not at all"
label values pf1 liste501_ac7_en

generate pf2=hlt16 
label variable pf2 "Physical functioning 2: does your health limit you in other demanding everyday activities? (lifting something heavy or do something requiring physical mobility)"
label values pf2 liste501_ac7_en

generate pr1=hlt17i3
label variable pr1 "Role problems, physical 1: past four weeks, how often did you feel that due to physical health problems you achieved less than you wanted to at work or in everyday activities?"
recode pr1 (1=4) (2=3) (3=2) (4=1)
label values pr1 liste250_ac7_rev

generate pr2=hlt17i4
label variable pr2 "Role problems, physical 2: past four weeks, how often did you feel that due to physical health problems you were limited in some way at work or in everyday activities?" 
recode pr2 (1=4) (2=3) (3=2) (4=1)
label values pr2 liste250_ac7_rev

generate mh1=hlt17i1
label variable mh1 "Mental health 1: past four weeks, how often did you feel down and gloomy?" 
recode mh1 (1=4) (2=3) (3=2) (4=1)
label values mh1 liste250_ac7_rev

generate mh2=per2i9
label variable mh2 "Mental health 2: past four weeks, how often did you feel calm and composed?" 
label define liste250_ac7_en 1 "1 Almost never" 2 "2 Sometimes" 3 "3 Often" 4 "4 Almost always"
label values mh2 liste250_ac7_en

generate mr1=hlt17i5
label variable mr1 "Role problems, mental 1: past four weeks, how often did you feel that due to mental health or emotional problems you achieved less than you wanted to at work or in everyday activities?" 
recode mr1 (1=4) (2=3) (3=2) (4=1)
label values mr1 liste250_ac7_rev

generate mr2=hlt17i6
label variable mr2 "Role problems, mental 2: past four weeks, how often did you feel that due to mental health or emotional problems you carried out your work or everyday tasks less thoroughly than usual? " 
recode mr2 (1=4) (2=3) (3=2) (4=1)
label values mr2 liste250_ac7_rev 

codebook gh vt sf pp pf1 pf2 pr1 pr2 mh1 mh2 mr1 mr2
codebook hlt1 gh per4i4 vt hlt17i7 sf hlt17i2 pp hlt15 pf1 hlt16 pf2 hlt17i3 pr1 hlt17i4 pr2 hlt17i1 mh1 per2i9 mh2 hlt17i5 mr1 hlt17i6 mr2


*****+--------------------------------------------------------------------------
*****| standardizing scales (0-100), creating sumscores, z-transformation
*****+--------------------------------------------------------------------------

recode gh (1=0) (2=25) (3=50) (4=75) (5=100)
recode vt (1=0) (2=25) (3=50) (4=75) (5=100)
recode sf (1=0) (2=33.33) (3=66.66) (4=100)
recode pp (1=0) (2=33.33) (3=66.66) (4=100)
recode pf1 (1=0) (2=50) (3=100)
recode pf2 (1=0) (2=50) (3=100)
recode pr1 (1=0) (2=33.33) (3=66.66) (4=100)
recode pr2 (1=0) (2=33.33) (3=66.66) (4=100)
recode mh1 (2=33.33) (3=66.66) (4=100)
recode mh2 (2=33.33) (3=66.66) (4=100)
recode mr1 (2=33.33) (3=66.66) (4=100)
recode mr2 (2=33.33) (3=66.66) (4=100)

gen pf=(pf1+pf2)/2
gen pr=(pr1+pr2)/2
gen mh=(mh1+mh2)/2
gen mr=(mr1+mr2)/2

sum gh vt sf pp pf1 pf2 pf pr1 pr2 pr mh1 mh2 mh mr1 mr2 mr

foreach x of varlist gh vt sf pp pf1 pf2 pf pr1 pr2 pr mh1 mh2 mh mr1 mr2 mr {
quietly: sum `x' 
gen `x'_z = (`x'- r(mean)) / r(sd)
} 
sum *_z


*****+--------------------------------------------------------------------------
*****| factor analysis and generating SF-12v2 Variables
*****+--------------------------------------------------------------------------

*correlation
corr gh vt sf pp pf1 pf2 pf pr1 pr2 pr mh1 mh2 mh mr1 mr2 mr
corr gh_z vt_z sf_z pp_z pf1_z pf2_z pf_z pr1_z pr2_z pr_z mh1_z mh2_z mh_z mr1_z mr2_z mr_z
corr gh_z vt_z sf_z pp_z pf_z pr_z mh_z mr_z

*Hauptachsenanalyse / Principle factor analysis
factor gh_z vt_z sf_z pp_z pf_z  pr_z mh_z  mr_z, blanks(0.4) 
*Orthogonal Varimax rotation, do not show values under 0.4 --> 3 factors, ambiguous
rotate
rotate, blanks(0.4) 
*Kaiser-Meyer-Olkin measure of sampling adequacy. kmo interpretation: 0.60 to 0.69 mediocre, 0.70 to 0.79 middling, 0.80 to 0.89 meritorious, 0.90 to 1.00 marvelous
*search kmo 
estat kmo 
screeplot  

*Hauptkomponentenanalyse / Principal component factor anaylsis // --> 2 factors: 1 physical, 2 mental
rotate 
factor gh_z vt_z sf_z pp_z pf_z  pr_z mh_z  mr_z, pcf blanks(0.4)
rotate, blanks(0.4) 
estat kmo 
screeplot 
*check rotations
rotate, blanks(0.4)
rotate, promax(3) oblique blanks(0.4)
rotate, oblimin(0) oblique blanks(0.4) 

*illustration of factor loadings
loadingplot, yline(0) xscale(range(0 1)) xline(0) graphregion(fcolor(white))

*name factors and create variables with factor scores: 1 health physical score, 2 health mental score
predict hps hms 
*save factor scores in matrix pc
matrix pc = r(scoef)		

* calculation of aggregate scores hpcs and hmcs using factor score coefficients	
gen agg_hp = (pc[1,1]*gh_z)+(pc[2,1]*vt_z)+(pc[3,1]*sf_z)+(pc[4,1]*pp_z)+(pc[5,1]*pf_z)+(pc[6,1]*pr_z)+(pc[7,1]*mh_z)+(pc[8,1]*mr_z)
gen agg_hm = (pc[1,2]*gh_z)+(pc[2,2]*vt_z)+(pc[3,2]*sf_z)+(pc[4,2]*pp_z)+(pc[5,2]*pf_z)+(pc[6,2]*pr_z)+(pc[7,2]*mh_z)+(pc[8,2]*mr_z)
* norm based scoring scales (mean=50 sd=10)	
gen hpcs = (agg_hp*10)+50
gen hmcs = (agg_hm*10)+50

*compare own sf12 to pairfam sf12 variables
sum pcs hpcs mcs hmcs
***Unterschied zum Pairfam Do-File: genauere Werte auf Skala 0 bis 100, schiefwinklige Faktorrotation, Faktoranalyse nur mit cohort3

*Visualize
*twoway (histogram hpcs if fem==0, color(blue)) (histogram hpcs if fem==1, color(pink)), legend(order(1 "Male" 2 "Female" ))

label var hpcs "Physical Health Score"
label var hmcs "Mental Health Score"


********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| Defining predictor parenthood vs. childlessness (model 1)
*****|
*****+--------------------------------------------------------------------------

*Exlcluding former parents, who became childless through death of child/ren --> no such cases
tab ehc11k1
gen nkidsdead = ehc11k1 + ehc11k2 + ehc11k3 + ehc11k4 + ehc11k5 +ehc11k6 + ehc11k7 +ehc11k8 + ehc11k9 + ehc11k10
tab nkidsdead
*Deceased kids -->18
gen deadkids = nkids-nkidsalv


*Simple: parents vs. non-parents
*Dummy: nokids
generate nokids=nkids
recode nokids (1 2 3 4 5 6 7 8 9 10=0) (0=1) 
label var nokids "childless "
label define vnokids 0 "0. has kids" 1 "1. has no kids"
label values nokids vnokids
numlabel vnokids, add
tab nokids
*Dummy: parents (bio, foster, adoptive, everything)
generate parents=nokids
recode parents (1=0) (0=1) 
label var parents "parents of any sort of child"
label define vparents 1"parent" 0"childless"
label values parents vparents
numlabel vparents, add
tab parents


*More detail: parents who actually have lived with 1+ of their children in main resdidence vs. non-parents
**Dummy: cohabs 
tab childmrd
*The variable childmrd indicates how many children LIVED at the anchor's main residence
* childless (371) Parents never lived with a child (120) Parents lived with 1-9 children (1625)	=2116cases
generate childmrd_1 =recode(childmrd, 0, 9) 
*recode values, label variable, value lable container, value lables to varibale
recode childmrd_1 (9=1)
label var childmrd_1 "people lived with at least 1 child in main residence"
label define vchildmrd_1 1"people lived with at least 1 child in main residence" 0"people never lived with at least 1 child in main residence"
label values childmrd_1 vchildmrd_1
numlabel vchildmrd_1, add
tab childmrd_1
*generate childmrd_parent_1 (parents who have lived with a child mrd)
gen childmrd_parent_1 = childmrd_1 if parents==1
label var childmrd_parent_1 "parents lived with at least 1 child in main residence"
label define vchildmrd_parent_1 1"parent lived with at least 1 child in main residence" 0"parent never lived with at least 1 child in main residence"
label values childmrd_parent_1 vchildmrd_parent_1
numlabel vchildmrd_parent_1, add
tab childmrd_parent_1
*generate cohabs (containing: childless and parents who have lived with a child. excluding parents never lived with a child)
gen cohabs = childmrd_1 if childmrd_parent_1==1 | nokids==1
label var cohabs "parents lived with at least 1 child in main residence VS childless"
label define vcohabs 1"parents lived with at least 1 child mrd" 0"childless"
label values cohabs vcohabs
numlabel vcohabs, add
tab cohabs

*generate cohabs_curr (containing parents who currently live with a child and childless, excluding 118 parents not living with child)
tab nkidsliv
*people who are living with 0-1+ kids
gen nkidsliv_1 = nkidsliv
recode nkidsliv_1 (1/9=1)
tab nkidsliv_1
*parents who are living with 0-1+ kids
gen nkidsliv_parent_1 = nkidsliv_1 if parents==1
tab nkidsliv_parent_1
*parents who are living with 1+ kids and childless
gen cohabs_curr = nkidsliv_1 if nkidsliv_parent_1==1 | nokids==1



*More detail: parents who actually have lived with 1+ of BIO child
*ehc9k* (1 bio / 2 adoptive / 3 step / 4 foster)
tab ehc9k1
tab childmrd
tab childmrd if ehc9k1==1 | ehc9k2==1 | ehc9k3==1 | ehc9k4==1 | ehc9k5==1 | ehc9k6==1 | ehc9k7==1 | ehc9k8==1 | ehc9k9==1 | ehc9k10==1
*Dummy: at least 1 non-biological child (135 cases)
gen ehc9k1r = ehc9k1
gen ehc9k2r = ehc9k2
gen ehc9k3r = ehc9k3
gen ehc9k4r = ehc9k4
gen ehc9k5r = ehc9k5
gen ehc9k6r = ehc9k6
gen ehc9k7r = ehc9k7
gen ehc9k8r = ehc9k8
gen ehc9k9r = ehc9k9
gen ehc9k10r = ehc9k10
recode ehc9k1r ehc9k2r ehc9k3r ehc9k4r ehc9k5r ehc9k6r ehc9k7r ehc9k8r ehc9k9r ehc9k10r (.=0) (1=0) (2/4=1) 
gen hasnonbiokid = 1 if ehc9k1r==1 | ehc9k2r==1 | ehc9k3r==1 | ehc9k4r==1 | ehc9k5r==1 | ehc9k6r==1 | ehc9k7r==1 | ehc9k8r==1 | ehc9k9r==1 | ehc9k10r==1
recode hasnonbiokid (.=0)
label var hasnonbiokid "has at least one non-biological child"
tab hasnonbiokid
*number of non biological children (max. 4)
gen nnonbiokid = ehc9k1r + ehc9k2r + ehc9k3r + ehc9k4r + ehc9k5r + ehc9k6r + ehc9k7r + ehc9k8r + ehc9k9r + ehc9k10r
recode nnonbiokid (.=0)
label var nnonbiokid "number of non-biological children"
tab nnonbiokid
sum nnonbiokid
*generate cohabs_bio: parents having lived with 1+ bio child and childless 
gen cohabs_bio = cohabs if nnonbiokid==0
label var cohabs_bio "parents lived with at least 1 bio child in main residence VS childless"
label define vcohabsb 1"parents lived with at least 1 bio child mrd" 0"childless"
label values cohabs_bio vcohabsb
numlabel vcohabsb, add
tab cohabs_bio




********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| Refining predictor number of kids (model 2)
*****|
*****+--------------------------------------------------------------------------
*check number of deceased kids --> excluding 19 children
codebook k1type
recode k1type (2/3=1) (4/9=0) (.=0), gen(k1dead)
recode k2type (2/3=1) (4/9=0) (.=0), gen(k2dead)
recode k3type (2/3=1) (4/9=0) (.=0), gen(k3dead)
recode k4type (2/3=1) (4/9=0) (.=0), gen(k4dead)
recode k5type (2/3=1) (4/9=0) (.=0), gen(k5dead)
recode k6type (2/3=1) (4/9=0) (.=0), gen(k6dead)
recode k7type (2/3=1) (4/9=0) (.=0), gen(k7dead)
recode k8type (2/3=1) (4/9=0) (.=0), gen(k8dead)
recode k9type (2/3=1) (4/9=0) (.=0), gen(k9dead)
recode k10type (2/3=1) (4/9=0) (.=0), gen(k10dead)
*gen nkidsdead=k1dead+k2dead+k3dead+k4dead+k5dead+k6dead+k7dead+k8dead+k9dead+k10dead

*check number of non-biological kids --> keeping them in analysis
codebook k1type
recode k1type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k1nonbio)
recode k2type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k2nonbio)
recode k3type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k3nonbio)
recode k4type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k4nonbio)
recode k5type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k5nonbio)
recode k6type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k6nonbio)
recode k7type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k7nonbio)
recode k8type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k8nonbio)
recode k9type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k9nonbio)
recode k10type (4 7=1) (2 3 5 6 8 9=0) (.=0), gen(k10nonbio)
gen nkidsnonbio=k1nonbio+k2nonbio+k3nonbio+k4nonbio+k5nonbio+k6nonbio+k7nonbio+k8nonbio+k9nonbio+k10nonbio

*simple: number of kids alive, all anchors, automatically exclusing dead children
tab nkidsalv
sum nkidsalv
*grouping number of kids alive, sum 5+
recode nkidsalv (5/10=5), gen(nkidsalv5)
label var nkidsalv5 "number of all kids, 0-5+"
tab nkidsalv5
sum nkidsalv5
*grouping number of kids alive, sum 4+
recode nkidsalv (4/10=4), gen(nkidsalv4)
label var nkidsalv4 "number of all kids, 0-4+"
tab nkidsalv4
sum nkidsalv4
*Dummies: number of kids 0,1,2,3,4+
tab nkidsalv4, gen(nkidsalv4_dum)
label var nkidsalv4_dum1 "0 child" 
label var nkidsalv4_dum2 "1 child" 
label var nkidsalv4_dum3 "2 children"
label var nkidsalv4_dum4 "3 children"
label var nkidsalv4_dum5 "4+ chidlren"


*number of kids alive, only parents
recode nkidsalv (0=.), gen(nkidsalv_parents) 
label var nkidsalv_parents "number of all kids, only parents"
tab nkidsalv_parents
sum nkidsalv_parents
*grouping number of kids alive, only parents, sum 5+
recode nkidsalv_parents (5/10=5), gen(nkidsalv5_parents)
label var nkidsalv5_parents "number of all kids, only parents, 1-5+"
tab nkidsalv5_parents
sum nkidsalv5_parents
*grouping number of kids alive, only parents, sum 4+
recode nkidsalv_parents (4/10=4), gen(nkidsalv4_parents)
label var nkidsalv4_parents "number of all kids, only parents, 1-4+"
tab nkidsalv4_parents
sum nkidsalv4_parents
*Dummies: number of kids only parents 1,2,3,4+
tab nkidsalv4_parents, gen(nkidsalv4_p_dum)
label var nkidsalv4_p_dum1 "1 child" 
label var nkidsalv4_p_dum2 "2 children"
label var nkidsalv4_p_dum3 "3 children"
label var nkidsalv4_p_dum4 "4+ chidlren"



*More Detail: summarized cohabitation years as Indicator for Intensity of parentship
*used different dataset: biochild.dta 
*--> see dofile biochild_livk.do
*Feed livk0_7 from extra dataset (master only 358, using only 4305, matched 1759)
merge 1:1 id using "$path_in/biochild_livk_all_peranchor.dta", gen (merge_livk)
tab merge_livk
drop if merge_livk==2
label var livk_all "sum of cohabition years: parents and their children"
sum livk_all
*check childless, recode chidless
sum livk_all if nkidsalv == 0
replace livk_all = . if nkidsalv == 0
sum livk_all
*version including childless (=0)
gen livk_all_all = livk_all
replace livk_all_all = 0 if livk_all_all == .
label var livk_all_all "sum of cohabition years: parents and kids, including childless"


********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| Refining predictor age at first/last birth (model 3)
*****|
*****+--------------------------------------------------------------------------
*Age at first birth = Age at interview - Age of oldest child
*Age at interview
tab age
sum age
*Age of oldest child
tab k1age
sum k1age
*Age at first birth, delete 1 case (age 8), mean 28.55
generate age_fbirth = age-k1age
label var age_fbirth "age at first birth"
tab age_fbirth
keep if age_fbirth>12
sum age_fbirth
*mean: 28.5

*Age at first birth in 5 Agegroups (same size)
recode age_fbirth (8/22=0) (23/26=1) (27/30=2) (31/34=3) (35/43=4), gen(agegroup_fbirth)
label var agegroup_fbirth "Age at first birth in 5 agegroups"
label define vagegroup_fbirth 0"age -22 at first birth" 1"age 23-26 at first birth" 2"age 27-30 at first birth" 3"age 31-34 at first birth" 4"age 35-43 at first birth"
label values agegroup_fbirth vagegroup_fbirth
numlabel vagegroup_fbirth, add
tab agegroup_fbirth
*Dummies for age groups
tab agegroup_fbirth, gen(fbirth_dum)
label var fbirth_dum1 "-22" 
label var fbirth_dum2 "23-26" 
label var fbirth_dum3 "27-30" 
label var fbirth_dum4 "31-34" 
label var fbirth_dum5 "35-43" 
tab fbirth_dum1
*Dummy for early first birth up until 22 (both genders), including childless
gen early_fbirth = 1 if fbirth_dum1 == 1
replace early_fbirth = 0 if early_fbirth == .
* attach labels 
label var early_fbirth "early first birth: -22"
label define vnoyes 0"no" 1"yes" 
label values early_fbirth vnoyes
tab early_fbirth


sum age_fbirth if age_fbirth < 20 & sex_gen == 2
*are 64 obs. enough?
sum age_fbirth if age_fbirth < 21 & sex_gen == 2
sum age_fbirth if age_fbirth < 25 & sex_gen ==1 
* --> *better fem: 21  male: 25?



*Age at last birth = Age at interview - Age of youngest child
*Age of youngest child 
gen kyage = ykage/12
replace kyage = round(kyage, 1)
gen age_lbirth=age-kyage 
label var age_lbirth "age at last birth"
tab age_lbirth
sum age_lbirth
*mean 32.6
*Dummy for late first birth 35-43 (both genders), including childless
gen late_fbirth = 1 if fbirth_dum5 == 1
replace late_fbirth = 0 if late_fbirth == .
tab late_fbirth sex_gen
* attach labels 
label var late_fbirth "late first birth: 35-43"
label values late_fbirth vnoyes
tab late_fbirth


********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| Defining Co-Variables
*****|
*****+--------------------------------------------------------------------------
*****| CO-VARIABLES BIOLOGICAL FACTORS
*****+--------------------------------------------------------------------------

*GENDER
tab sex_gen
recode sex_gen (1=0) (2=1), gen(fem)
label define lfem 1"Women" 0"Men"
label values fem lfem
numlabel lfem, add
tab fem


*BREASTFEEDING (women)
*breastfeeding in months - only 37 answers k1...
tab crn37k1
*how many children were breastfed (only 144, lots of missings here)
recode crn37k* (1/96=1) (97=0) (.=0)
gen nk_bfed=crn37k1+crn37k2+crn37k3+crn37k4+crn37k5+crn37k6+crn37k7+crn37k8+crn37k9+crn37k10
tab nk_bfed
*at least 1 child was breastfed
recode nk_bfed (2=1), gen(onek_bfed)
*more men than women!?!?!
tab onek_bfed fem



*****+--------------------------------------------------------------------------
*****| CO-VARIABLES LIFESTYLE
*****+--------------------------------------------------------------------------
*SMOKING
*Dummy: Currently Smoking
generate smoking = hlt10
recode smoking (2=0) 
label var smoking "are you currently smoking"
label values smoking vnoyes
numlabel vnoyes, add
tab smoking
*Intensity of smoking (only smokers): cigarettes, pipes, cigars per day (Respondents who smoke now)
gen nsmoking_all = hlt11i1 + hlt11i2 + hlt11i3
recode nsmoking_all (.=0) if smoking==0
*Vergangenheit fehlt
*Scatterplot
twoway (scatter hpcs nsmoking_all) (lfit hpcs nsmoking_all)

*DRINKING ALCOHOL
*regularity: how often do you drink? (never - every day)
tab hlt13
generate alc_reg = hlt13 
recode alc_reg (7=0) (6=1) (5=2) (4=3) (3=4) (2=5) (1=6)
label var alc_reg "how often do you drink alcohol?"
label define howoften1 0"never" 1"less than once a month" 2"1 to 3 times a month" 3"1 to 2 times a week" 4"3 to 4 times a week" 5"5 to 6 times a week" 6"every day"
label values alc_reg howoften1
numlabel howoften1, add
tab alc_reg

*Dummy for regular alcohol consumption
generate alc_often = 1 if inlist(alc_reg, 4, 5, 6)
replace alc_often = 0 if inlist(alc_reg, 0, 1, 2, 3)
label var alc_often "drinking alcohol at least 3 times per week"
label values alc_often vnoyes


*intensity: last month: how often drank 5+ alcoholic beverages on one occasion
*(Respondents who did not indicate never drinking alcohol)
tab hlt14
generate alc_int = hlt14
replace alc_in = 6 if alc_int >= 6 & alc_int != .
label var alc_int "last month: how often drank 5+ alcoholic beverages on one occasion 1-6+"


*SPORT
*regularity: how often
tab lsr1i2
generate sport = lsr1i2 
recode sport (1=4) (2=3) (3=2) (4=1) (5=0)
label var sport "how often do you do sports?"
label define howoften2 0"never" 1"less than once a month" 2"at least once a month" 3"at least once a week" 4"everyday" 
label values sport howoften2
numlabel howoften2, add
tab sport
*dummy: at least once a week
recode sport (1 2 = 0) (3 4 = 1), gen(sport1)
label var sport1 "doing sport at least once a week"
label define onceweek 1"at least once a week" 0"less than once a week"
label values sport1 onceweek
numlabel onceweek, add
tab sport1

*SOCIAL CONTACTS
*meeting friends
tab lsr1i4
recode lsr1i4 (1=4) (2=3) (3=2) (4=1) (5=0), gen(friends)
label values friends howoften2
numlabel howoften2, add
tab friends
*dummy: at least once a month
recode friends (0 1 2 = 0) (3 4 = 1), gen(friends1)
label var friends1 "seeing friends at least once a week"
label values friends1 onceweek
numlabel onceweek, add
tab friends1

*SLEEP
* On average, how many hours do you sleep during working week?
tab hlt7 
twoway (scatter hpcs hlt7) (qfit hpcs hlt7) (qfit hmcs hlt7)
gen sleep = hlt7
recode sleep (1/5.5 = 0) (6/8 = 1) (8.5/12 = 0)
label var sleep "sleeping 6-8h per night"
tab sleep fem, col


*OVERWEIGHT
*no data on height, so no BMI
sum hlt4
tw (scatter hpcs hlt4) (lpoly hpcs hlt4 if fem==0) (lpoly hpcs hlt4 if fem==1) 
egen weight_groups_f = cut(hlt4) if fem ==1,group(4)
egen weight_groups_m = cut(hlt4) if fem ==0,group(4)
* high weight women: 80-140kg (289 obs.)
sum hlt4 if weight_groups_f == 3
* high weight men: 95-165kg (255 obs.)
sum hlt4 if weight_groups_m == 3
*Dummy for high weight people
gen weight_high = 1 if weight_groups_f == 3 | weight_groups_m == 3
replace weight_high = 0 if weight_groups_f == 0 | weight_groups_m == 0 | weight_groups_f == 1 | weight_groups_m == 1 | weight_groups_f == 2 | weight_groups_m == 2  
sum weight_high


*****+--------------------------------------------------------------------------
*****| CO-VARIABLES PRIOR HEALTH
*****+--------------------------------------------------------------------------


*CHILDHOOD HEALTH
* scale from bad - very good (5 steps)
tab cla11
gen h_childhood = cla11-1
*Dummy for good or very good health in own childhood
gen h_childhood_good = cla11
replace h_childhood_good = 1 if cla11 == 4 | cla11 == 5
replace h_childhood_good = 0 if inlist(cla11, 0, 1, 2, 3)
tab h_childhood_good
label var h_childhood_good "good or very good health during own childhood"
tab h_childhood_good fem, col 

*****+--------------------------------------------------------------------------
*****| CO-VARIABLES AGE OF KIDS (for model 2)
*****+--------------------------------------------------------------------------

*AGE OF CHILDREN
*child 1 not dead (ehc11k1==0)
tab ehc11k1
*child 1 birthyear / age
*tab ehc8k1y
tab k1age

*Agegroups (for reasonable group sizes):
*1 babies, toddlers, pre-school kids 0-5
*2 elementary school kids 6-10
*3 young teenagers 11-14  
*4 adolescence 15-18
*5 full aged / students 19-30
*children 1-10 in agegroups
recode k1age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k1agegroup)
recode k2age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k2agegroup)
recode k3age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k3agegroup)
recode k4age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k4agegroup)
recode k5age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k5agegroup)
recode k6age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k6agegroup)
recode k7age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k7agegroup)
recode k8age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k8agegroup)
recode k9age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k9agegroup)
recode k10age (0/5=1) (6/10=2) (11/14=3) (15/18=4) (19/30=5), gen(k10agegroup)
tab k1agegroup
*kid 1-10 agegroup 1 (k1agegroup==1)
recode k1agegroup (.=0) (2/5=0), gen(k1_agegroup1)
recode k2agegroup (.=0) (2/5=0), gen(k2_agegroup1)
recode k3agegroup (.=0) (2/5=0), gen(k3_agegroup1)
recode k4agegroup (.=0) (2/5=0), gen(k4_agegroup1)
recode k5agegroup (.=0) (2/5=0), gen(k5_agegroup1)
recode k6agegroup (.=0) (2/5=0), gen(k6_agegroup1)
recode k7agegroup (.=0) (2/5=0), gen(k7_agegroup1)
recode k8agegroup (.=0) (2/5=0), gen(k8_agegroup1)
recode k9agegroup (.=0) (2/5=0), gen(k9_agegroup1)
recode k10agegroup (.=0) (2/5=0), gen(k10_agegroup1)
*kid 1-10 agegroup 2 (k1agegroup==2)
recode k1agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k1_agegroup2)
recode k2agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k2_agegroup2)
recode k3agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k3_agegroup2)
recode k4agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k4_agegroup2)
recode k5agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k5_agegroup2)
recode k6agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k6_agegroup2)
recode k7agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k7_agegroup2)
recode k8agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k8_agegroup2)
recode k9agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k9_agegroup2)
recode k10agegroup (.=0) (1=0) (2=1) (3/5=0), gen(k10_agegroup2)
*kid 1-10 agegroup 3 (k1agegroup==3)
recode k1agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k1_agegroup3)
recode k2agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k2_agegroup3)
recode k3agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k3_agegroup3)
recode k4agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k4_agegroup3)
recode k5agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k5_agegroup3)
recode k6agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k6_agegroup3)
recode k7agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k7_agegroup3)
recode k8agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k8_agegroup3)
recode k9agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k9_agegroup3)
recode k10agegroup (.=0) (1/2=0) (3=1) (4/5=0), gen(k10_agegroup3)
*kid 1-10 agegroup 4 (k1agegroup==4)
recode k1agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k1_agegroup4)
recode k2agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k2_agegroup4)
recode k3agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k3_agegroup4)
recode k4agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k4_agegroup4)
recode k5agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k5_agegroup4)
recode k6agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k6_agegroup4)
recode k7agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k7_agegroup4)
recode k8agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k8_agegroup4)
recode k9agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k9_agegroup4)
recode k10agegroup (.=0) (1/3=0) (4=1) (5=0), gen(k10_agegroup4)
*kid 1-10 agegroup 5 (k1agegroup==5)
recode k1agegroup (.=0) (1/4=0) (5=1), gen(k1_agegroup5)
recode k2agegroup (.=0) (1/4=0) (5=1), gen(k2_agegroup5)
recode k3agegroup (.=0) (1/4=0) (5=1), gen(k3_agegroup5)
recode k4agegroup (.=0) (1/4=0) (5=1), gen(k4_agegroup5)
recode k5agegroup (.=0) (1/4=0) (5=1), gen(k5_agegroup5)
recode k6agegroup (.=0) (1/4=0) (5=1), gen(k6_agegroup5)
recode k7agegroup (.=0) (1/4=0) (5=1), gen(k7_agegroup5)
recode k8agegroup (.=0) (1/4=0) (5=1), gen(k8_agegroup5)
recode k9agegroup (.=0) (1/4=0) (5=1), gen(k9_agegroup5)
recode k10agegroup (.=0) (1/4=0) (5=1), gen(k10_agegroup5)


*NUMBER OF KIDS IN AGEGROUPS PER PARENT
*number of kids in agegroup 1
gen nk_agegroup1 = k1_agegroup1+k2_agegroup1+k3_agegroup1+k4_agegroup1+k5_agegroup1+k6_agegroup1+k7_agegroup1+k8_agegroup1+k9_agegroup1+k10_agegroup1
label var nk_agegroup1 "number of kids in agegroup 1: babies, toddlers, pre-school kids 0-5 years"
*number of kids in agegroup 2
gen nk_agegroup2 = k1_agegroup2+k2_agegroup2+k3_agegroup2+k4_agegroup2+k5_agegroup2+k6_agegroup2+k7_agegroup2+k8_agegroup2+k9_agegroup2+k10_agegroup2
label var nk_agegroup2 "number of kids in agegroup 2: elementary school kids 6-10 years"
*number of kids in agegroup 3
gen nk_agegroup3 = k1_agegroup3+k2_agegroup3+k3_agegroup3+k4_agegroup3+k5_agegroup3+k6_agegroup3+k7_agegroup3+k8_agegroup3+k9_agegroup3+k10_agegroup3
label var nk_agegroup3 "number of kids in agegroup 3: young teenagers 11-14 years"
*number of kids in agegroup 4
gen nk_agegroup4 = k1_agegroup4+k2_agegroup4+k3_agegroup4+k4_agegroup4+k5_agegroup4+k6_agegroup4+k7_agegroup4+k8_agegroup4+k9_agegroup4+k10_agegroup4
label var nk_agegroup4 "number of kids in agegroup 4: adolescence 15-18 years"
*number of kids in agegroup 5
gen nk_agegroup5 = k1_agegroup5+k2_agegroup5+k3_agegroup5+k4_agegroup5+k5_agegroup5+k6_agegroup5+k7_agegroup5+k8_agegroup5+k9_agegroup5+k10_agegroup5
label var nk_agegroup5 "number of kids in agegroup 5: full aged 19-30 years"

*AT LEAST 1 KID IN AGEGROUPS
*has at least 1 kid in agegroup 1
recode nk_agegroup1 (1/10=1), gen(hask_agegroup1)
label var hask_agegroup1 "has at least 1 kid in agegroup 1: babies, toddlers, pre-school kids 0-5 years"
*has at least 1 kid in agegroup 2
recode nk_agegroup2 (1/10=1), gen(hask_agegroup2)
label var hask_agegroup2 "has at least 1 kid in agegroup 2: elementary school kids 6-10 years"
*has at least 1 kid in agegroup 3
recode nk_agegroup3 (1/10=1), gen(hask_agegroup3)
label var hask_agegroup3 "has at least 1 kid in agegroup 3: young teenagers 11-14 years"
*has at least 1 kid in agegroup 4
recode nk_agegroup4 (1/10=1), gen(hask_agegroup4)
label var hask_agegroup4 "has at least 1 kid in agegroup 4: adolescence 15-18 years"
*has at least 1 kid in agegroup 5
recode nk_agegroup5 (1/10=1), gen(hask_agegroup5)
label var hask_agegroup5 "has at least 1 kid in agegroup 5: full aged 19-30 years"
tab hask_agegroup5


*NUMBER OF KIDS PER AGEGROUP OVERALL
egen sum_allk_agegroup1 = sum(nk_agegroup1)
egen sum_allk_agegroup2 = sum(nk_agegroup2)
egen sum_allk_agegroup3 = sum(nk_agegroup3)
egen sum_allk_agegroup4 = sum(nk_agegroup4)
egen sum_allk_agegroup5 = sum(nk_agegroup5)
label var sum_allk_agegroup1 "0-5"
label var sum_allk_agegroup2 "6-10"
label var sum_allk_agegroup3 "11-14"
label var sum_allk_agegroup4 "15-18"
label var sum_allk_agegroup5 "19-30"
*Visualize distribution
graph use "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik/Graph-kids_per_agegroup.gph"



*****+--------------------------------------------------------------------------
*****| CO-VARIABLES PARENTING STRESS & SUPPORT 
*****+--------------------------------------------------------------------------
*PARENTSTRESS 
*BURDEN: life is burdensome and i have no energy
tab crn11i1
tab crn11i6
*PRESSURE: seriousness / stress / expectations regarding own parenting skills
tab crn47i1
tab crn47i2
recode crn47i2 (1=5) (2=4) (4=2) (5=1)
label define zustimmung 1 "1 Stimme voll und ganz zu" 5 "5 Stimme Ÿberhaupt nicht zu"
label values crn47i2 zustimmung
tab crn47i3
tab crn47i4
tab crn47i5
recode crn47i5 (1=5) (2=4) (4=2) (5=1)
label values crn47i5 zustimmung
*WORRIES and overprotectiveness
tab crn29i1
tab crn29i2
tab crn29i3
*SUM OF PARENTSTRESS ( how can I excludee missings?)
gen parentstress = (crn11i1 + crn11i6 + crn47i1 + crn47i2 + crn47i3 + crn47i4 + crn47i5 + crn29i1 + crn29i2 + crn29i3)
label var parentstress "sum parenting stress = parenting burden+pressure+worries"
twoway (scatter hpcs parentstress) (lpolyci hpcs parentstress) (lpoly hmcs parentstress)
twoway (scatter hpcs parentstress, jitter(20)) (lpolyci hpcs parentstress if fem==1) (lpoly hpcs parentstress if fem == 0)
sum parentstress
replace parentstress = round(parentstress, 0.1)
*DUMMY for high parentstress
recode parentstress (1/25 = 0) (26/50 = 1), gen(parentstress_high)
label var parentstress_high "high levels of parenting stress/pressure/worries"


*SATISFACTION with general childcare situation for child 1-10
*10 step likert scale, ok to keep as interval scale?
tab crn15k1 
* calculation average satisfaction over 1-10 kids
egen rowmiss_childcare =rowmiss(crn15k1-crn15k10)
gen rowanswers_childcare = (10 - rowmiss_childcare)
egen rowtotal_childcare = rowtotal(crn15k1-crn15k10)
gen childcare_sat_avg = rowtotal_childcare / rowanswers_childcare
tw (scatter hmcs childcare_sat_avg, jitter(20)) (lpoly hpcs childcare_sat_avg) (lpolyci hmcs childcare_sat_avg)


*PARENTING SUPPORT FROM PARTNER
*parenting support and appreciation from partner 
tab crn20i5
tab crn20i6
tw (scatter crn20i5 crn20i6, jitter(30)) (lfit crn20i5 crn20i6)
gen parentsupport_partner = (crn20i5+crn20i6)
label var parentsupport_partner "sum: parenting support and appreciation from partner"
tab parentsupport_partner
sum parentsupport_partner
*mean=8.9
*Dummy for above average support from partner
gen parentsupport_partner_high = parentsupport_partner 
recode parentsupport_partner_high (2/8=0) (9/10=1)
*gender differences
tab parentsupport_partner_high fem, col


*PARENTING SUPPOERT FROM OTHERS 
*social support in child rearing: people looking after child / giving advice
tab crn30i1
tab crn30i2
gen parentsupport_social = (crn30i1+crn30i2)
label var parentsupport_social "sum: parenting support, looking after child / giving advice"
tab parentsupport_social
sum parentsupport_social
*mean=7.2
*age at first birth differences
tw (lfit parentsupport_social age_fbirth) (scatter parentsupport_social age_fbirth, jitter(33))
*Dummy for above average support from others
gen parentsupport_social_high = parentsupport_social 
recode parentsupport_social_high (2/7=0) (8/10=1)
tab parentsupport_social_high fem, col



*****+--------------------------------------------------------------------------
*****| CO-VARIABLES SOES
*****+--------------------------------------------------------------------------

*Dummy:currently living in east germany
tab east

*EDUCATION
*years of education
tab yeduc
tw (scatter yeduc hpcs, jitter(33)) (lfit yeduc hpcs) (lfit yeduc hmcs)
*Dummy for Hoschschulabschluss
tab casmin
recode casmin (0/7 = 0 "no university degree") (8/9 = 1 "university degree"), gen(edu_high) 
tab edu_high


*OCCUPATIONAL STATUS
*Dummy: employed vs. unemployed
tab casprim
recode casprim (1/8 14/22 =0 "0 unemployed / marginally/occasionally employed / retired / parenatl leave etc.") (10/12=1 "1 full time/part-time employed/self-employed"), gen(employed) 
label var employed "employment status"
tab employed


*OCCUPATIONAL PRESTIGE
*siops: Standard International Occupational Prestige Scale weist Berufen einen empirisch ermittelten Prestigewert zu
*Index liegt zwischen 12 (z.B. Schuhputzer) und 78 (€rzte)
tab siops
sum siops
gen siops0=siops-12
*isei: Der Internationale Sozioškonomische Index des beruflichen Status verbindet Einkommen und Bildung, um so den Status eines Berufs abzubilden
tab isei
sum isei
gen isei0=isei-12


*INCOME per month
*personal net income
sum incnet
hist incnet
*drop outliers > 6000 (9 casees)
replace incnet = . if incnet > 6000

*household net imcome
sum hhincnet
hist hhincnet
*drop outliers > 12000 (9 cases)
replace hhincnet = . if hhincnet > 12000



*MIGRATION
tab migstat
recode migstat (1=0) (2 3=1)
label define vmigstat 0"no migration background" 1"1st or 2nd migration generation"
label values migstat vmigstat
numlabel vmigstat, add
tab migstat


*Dummy: experienced financial hardship
tab cle1i1
gen moneystress = cle1i1
label var moneystress "ever had big financial problems, dept, insolvency" 


*****+--------------------------------------------------------------------------
*****| CO-VARIABLES PARTNERSHIP
*****+--------------------------------------------------------------------------
*Dummies: current lifestyle "single, lat, nel, ehe" (lat living apart together, nel nicht eheliche lebensgemeinschaft)
tab relstat
tw (scatter hpcs relstat, jitter(33)) (lpoly hpcs relstat) (lpoly hmcs relstat)  
recode relstat (1 6 9=0 "1 Single") (2 7 10=1 "2 LAT") (3 8 11=2 "3 NEL") (4 5=3 "4 Ehe") , gen(rel) 
tab rel, gen(rel_dum)
rename rel_dum1 single
rename rel_dum2 lat
rename rel_dum3 nel
rename rel_dum4 ehe
label var single "Single"
label var lat "LAT living apart together"
label var nel "NEL nicht eheliche Lebensgemeinschaft"
label var ehe "Ehe"
tab rel
tw (lpoly hpcs rel) (lpoly hmcs rel) (scatter hpcs rel, jitter(33)) (scatter hmcs rel, jitter(33))

*Dummy: married & cohab VS single & lat
recode rel (1/2=0 "0 Single or LAT") (3/4=1 "1 Married and/or Cohab"), gen(married_cohab)


*Duration of current relationship in months / years
sum reldur
hist reldur
generate relyears=reldur/12
replace relyears = round(relyears, 1)
label variable relyears "Duration of current relationship in years" 
sum relyears
tw (scatter hpcs relyears, jitter(33)) (lpoly hpcs relyears) (lpoly hmcs relyears) 
hist relyears
*browse if relyears > 29 & relyears != .
*relationship of 41,3 years at age 43 possible?
recode relyears (30/43 = .)

*Dummy for (quasi) Single Parents married_cohab == 0


********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****|  Tidy up Dataset and save
*****|
*****+--------------------------------------------------------------------------
*drop redundant data
drop k*agegroup k*_agegroup* k*age k*type k*dead k*nonbio reldur cohabdur mardur hhincgcee hhincoecd frt28 gh vt sf pp pf pf1 pf2 pr pr1 pr2 mh mh1 mh2 mr mr1 mr2 hps hms agg_hp agg_hm mh2 doby_gen dobm_gen meetdur hps1 cla12 frt30 hlt12* crn37* hhsizemrd npu14mr npo14mr mmrd fmrd pmrd hhcomp enrol school vocat isced isced2 casmin casprim lfs kldb2010 isco08 isei siops frt4* frt25i* np ncoh nmar crn11i1 crn11i6 crn47i1 crn47i2 crn47i3 crn47i4 crn47i5 crn29i1 crn29i2 crn29i3 lsr1i2 cla11 hlt10 hlt13 hlt14 hlt11i1 hlt11i2 hlt11i3 hlt1 per4i4 hlt17i7 hlt17i2 hlt15 hlt16 hlt17i3 hlt17i4 hlt17i1 per2i9 hlt17i5 hlt17i6 gh_z vt_z sf_z pp_z pf1_z pf2_z pf_z pr1_z pr2_z pr_z mh1_z mh2_z mh_z mr1_z mr2_z mr_z ehc7k* ehc8k* ehc9k* ehc10* ehc11* frt13* crn19* crn2k* crn15k* crn48k* crn33p*

save "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/3 Daten/pairfam_anchor7_thesis.dta", replace 

exit
