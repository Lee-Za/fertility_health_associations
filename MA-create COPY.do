********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****| Do-File zur Masterarbeit: Fertility / Parity and Health                            
*****|
*****+--------------------------------------------------------------------------	
*****|
*****| Author:	 Lisa-Maria Keck
*****| Abgabe:	 xx.xx.xxxx
*****+--------------------------------------------------------------------------
********************************************************************************
********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****| Variables Overview
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
*****|
*****|
*****|--------------------------------------------------------------------------
*****|INDEPENDENT VARIABLES, PARITY: 
*****|Number of all kids:			nkids 
*****|Number of all kids alive: 	nkidsalv 
*****|Number of all bio kids:		nkidsbio
*****|Number of all bio kids alive: nkidsbioalv
*****|Bio kids with partner alive:	nkidspalv
*****|Partners bio kids alive:		pnkidsbioalv
*****|anchor/partner is pregant:	pregnant
*****|Childless:					nokids nokids_parents nokids_cohabs
*****|
*****|Kids lived in household: 		childmrd nochildmrd	(main residence)
*****|Years of cohabition (sum):	livk0_7
*****|
*****|
*****|--------------------------------------------------------------------------
*****|CO-VARIABLES KIDS & PARENTING:
*****|Sex of child:					ehc7k*g 
*****|Type of chidlren 1-10:		k*type ehc9k*
*****|Age of children 1-10:			k*age
*****|Year of childs birth: 		ehc8k*y
*****|Dead child (year of death):	ehc11k* ehc11k*y
*****|
*****|ykage (age of anchor's youngest child living with anchor in months)
*****|ykid (position of anchor's youngest child)
*****|
*****|crn31k* (general health of child)
*****|
*****|Kids living with anchor:		nkidsliv
*****|Bio Kids living with anchor:	nkidsbioliv
*****|Bio kids with partner living:	nkidspliv
*****|Where is child * 1-15 living:	ehc10k* 
*****|(Where is child * 1-15 living:currliv, currliv_detail (aus Datensatz biochild)
*****|
*****|crn16k* (155. how often do you see child * who is not living with you (exclusively), daily - contact never established)
*****|crn13k* crn14k* (who takes care of child in morning and afternoon)
*****|
*****|crn64k* (not living together with other parent, child under 16 living with other paretn, but regular contact
*****|crn65k* (s.o. how many nights per month?)
*****|crn23k* (seperated from partner: how often in touch with child *s other parent)
*****|crn19i* (paretning goals, what do you want to tech your child?)
*****|crn47i* (seriousness / stress / expectations regarding own parenting skills)
*****|crn29i* (overprotectiveness, worries)
*****|crn32i* (sarifying for children)
*****|crn11i* (stress of life with child)
*****|crn30i* (social support in child rearing)
*****|crn20i* (support and appreciation from partner)
*****|crn48k* (relationship between children and coparent)
*****|crn33p* (parenting problems /discussions with coparent)
*****|crn15k* (satisfaction with childcare situation)
*****|
*****|crn2k* (new child since wave 6, complications at birth?)
*****|crn3k* (ne birth, by c-section?)
*****|crn37k* (has infant/toddler, was child breastfed?)
*****|crn26k* (has infant/toddler, burdened by childs sleeping behaviour at night?)
*****|crn28k* (has infant/toddler, burdened by crying  etc.?)
*****|crn10k* (infant/toddler, how is the child behaving?)
*****|crn43k* (infant/toddler, childs personality)
*****|crn45k* (preschool child, leisure activities with child)
*****|.... there is A LOT for every age group
*****|
*****|
*****|Kids Agegroups: CODEBOOK PAGE 51 VARIABELS NOT FOUND
*****|ag1k* (new child after previous wave, 1=child alive and newly born after previous wave, max 1 year before wave 7)
*****|ag2k* (infants, 1= child alive and born in the field start year or year thereafter)
*****|ag3k* (toddlers, 1= alive and born 1 or 2 years before the field start year)
*****|ag4k* (pre school, 1= born 3-5 years before wave 7)
*****|ag5k* (aged 6-7)
*****|ag6k* (children under 16)
*****|ag7k* (minors, under 18)
*****|ag8k* (chidlren under 21)
*****|
*****|
*****|
*****|CO-VARIABLES FERTILITY
*****|frt5 (how many children anchor would like to have altogether)
*****|frt26 (how many will you realistically have?)
*****|frt27 frt28 (will you realistically have more children in addition to your currentn children?)
*****|frt7 frt8(intend to have another child within the next 2 years)
*****|frt9 (how old will you be realistically when having your first child)
*****|frt25i* (how negativ/positive does being a parent affect your education/hobbies/social contacts/partnership?)
*****|frt13i* (reasons against having children) esp. frt13i1 (health does not permit it)
*****|... alle frt Variablen sind drin
*****|
*****|
*****|
*****|CO-VARIABLES HEALTH & STRESS:
*****|infertile (anchor/partner is infertile)
*****|hlt10 (currentlysmoking), hlt11i1 hlt11i2 hlt11i3 (smoking how many of)
*****|hlt12m (month of giving up smoking) hlt12y (year of giving up smoking)
*****|hlt13 (how often drinking alcohol), hlt14 (last month: how often drank 5+ alcoholic beverages on one occasion)
*****|cle1i* (experienced financial problems, illness/accidents, robbery, violence, sexual assault, bullying), cle2i* (events happened during last 2 years)
*****|cla11 (general health during childhood), cla13 (smoking, drinking, illness of guardian in childhood)
*****|
*****|
*****|
*****|
*****|
*****|
*****|CO-VARIABLES SOCIODEMOGRAPHY:
*****|cohort: 						cohort
*****|genrated date of birth:		dob*_gen
*****|age:							age
*****|generated sex:				sex_gen 
*****|birthcountry:					cob
*****|living in east germany:		east 
*****|Migrationssatus: migstatus 
*****|
*****|
*****|
*****|enrol (current enrollment in school or vocational training)
*****|school (highest school degree), vocat (highest vocational degree), 
*****|isced, isced2 or casmin? (ISECD-97, int. standard classification of education, 2=including students), yeduc (years of education)
*****|kldb2010 or isco08? (classification of occupation), siops or mps ? (prestige score, mps nicht gefunden)
*****|egp (class schema, nicht gefunden) or isei (int. socio-economic index of occupational status)
*****|casprim (surrent primary and secondary activity status), lfs (labor force status)
*****|incnet, hhincnet (personal and household net income) hhincgcee or hhincoecd (net equivalence income according to GCEE or modified OECD scale)
*****|
*****|
*****|Anchors Childhood: cla9 (financial situation at age 10), cla10 (book in household at age 10), 
*****|
*****|
*****|
*****|
*****|
*****|CO-VARIABLES PARTNER/RELATIONSHIPS: 
*****|homosex (anchor ist homosexual)
*****|relstat (relationship status), marstat (marital status), pmrd (partner lives in household main res.)
*****|reldur (duration of current relationship), cohabdur (duration cohabitation), mardur (duration marriage)
*****|np (number of previous partners), ncoh (number of previous partners cohabited with)
*****|nmar (nunber of previous marriages)
*****|meetdur (months of knowing current partner)
*****|
*****|
*****|
*****|CO-VARIABLES FAMILY/HOUSEHOLD:
*****|npu14mr (number persons under 14 main residence), npo14mr (number persons over 14 main residence)
*****|pmrd (partner lives in household main residence), mmrd, fmrd (mother, father living at anchors main residence), 
*****|hhsizemrd (household size main residemce), hhcomp (household composition main residence),
*****|
*****|
*****|
*****|
*****|
*****|
*****|anfŸgen: 
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

use hps1 lsr1i4 crn37k* crn2k*i* lsr1i2 crn15k* crn48k* crn33p* crn20i* crn30i* crn11i* crn32i* crn29i* crn19i* crn47i* frt* ehc7k*g ehc9k* ehc8k*y ehc11k* cle1i* cle2i* ehc10k* pmrd np ncoh nmar meetdur hhsizemrd nkidspalv nkidsliv nkidsbioliv nkidspliv pnkidsbioalv cla* hlt10 hlt11i1 hlt11i2 hlt11i3 hlt12m hlt12y hlt13 hlt14 hlt1 per4i4 hlt17i7 hlt17i2 hlt15 hlt16 hlt17i3 hlt17i4 hlt17i1 per2i9 hlt17i5 hlt17i6 id cohort sex_gen dob*_gen age east cob migstatus relstat marstat reldur cohabdur mardur infertile pregnant enrol school vocat isced isced2 casmin yeduc kldb2010 isco08 isei siops casprim lfs nkids nkidsbio nkidsalv nkidsbioalv k*age ykage ykid nkidsliv nkidsbioliv k*type childmrd npu14mr npo14mr pmrd hhcomp mmrd fmrd incnet hhincnet hhincgcee hhincoecd frt7 frt9 using "$path_in/pairfam_anchor7_copy", clear
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

*check number of non-biological kids --> 193. keeping them in analysis
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
label define vfem 1"Female" 0"Male"
label values fem vfem
numlabel vfem, add
tab fem


*BREASTFEEDING (women)
*breastfeeding in months - only 37 answers k1...
tab crn37k1
*how many children were breastfed (only 144, lots of missings here)
recode crn37k* (2/96=1) (97=0) (.=0)
gen nk_bfed=crn37k1+crn37k2+crn37k3+crn37k4+crn37k5+crn37k6+crn37k7+crn37k8+crn37k9+crn37k10
tab nk_bfed
*at least 1 child was breastfed
recode nk_bfed (2=1), gen(onek_bfed)






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
recode sport (1 2 3 = 0) (4 5 = 1), gen(sport1)
label var sport1 "doing sport at least once a week"
label define onceweek 1"at least once a week" 0"less than once a week"
label values sport1 onceweek
numlabel onceweek, add
tab sport1

******Social contacts: meeting friends
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




*****+--------------------------------------------------------------------------
*****| CO-VARIABLES HEALTH ISSUES
*****+--------------------------------------------------------------------------
*COMPLICATIONS DURING PREGNANCY & DELIVERY
tab crn2k1i1
tab crn2k1i2
*only one case k1

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


*HEALTH BEHAVIOR OF PARENTS
*Dummy: legal guardian smoked over long period in anchors childhood
tab cla13i1
recode cla13i1 (2=0), gen(smoking_parent)
label var smoking_parent "legal guardian smoked over long period in anchors childhood"
*Dummy: legal guardian drank over long period in anchors childhood
tab cla13i2
recode cla13i2 (2=0), gen(drinking_parent)
label var drinking_parent "legal guardian drank heavily over long period in anchors childhood"
*Dummy: legal guardian mentally ill over long period in anchors childhood
tab cla13i3
recode cla13i3 (2=0), gen(illmental_parent)
label var illmental_parent "legal guardian had mental illness over long period in anchors childhood"
*Dummy: legal guardian physically ill over long period in anchors childhood
tab cla13i4
recode cla13i4 (2=0), gen(illphysical_parent)
label var illphysical_parent "legal guardian had physical illness over long period in anchors childhood"
tab illphysical_parent

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

*SEX OF CHILDREN: 
tab ehc7k1g
*Dummy: at least 1 daughter
generate daughter = 1 if ehc7k1g==2 | ehc7k2g==2 | ehc7k3g==2 | ehc7k4g==2 | ehc7k5g==2 | ehc7k6g==2 | ehc7k7g==2 | ehc7k8g==2 | ehc7k9g==2 | ehc7k10g==2  
label var daughter "has at least one daughter"
recode daughter (.=0)
tab daughter parents



*****+--------------------------------------------------------------------------
*****| CO-VARIABLES PARENTING STRESS & SUPPORT (for model 2)
*****+--------------------------------------------------------------------------
*PARENTSTRESS 
*BURDEN: life is burdensome and i have no energy
tab crn11i1
tab crn11i6
*sum score of general parenting stress
gen parentburdens=(crn11i1+crn11i6)/2
label var parentburden "sum: general parenting stress"
tab parentburden
sum parentburden
*PRESSURE: seriousness / stress / expectations regarding own parenting skills
tab crn47i1
tab crn47i2
tab crn47i3
tab crn47i4
tab crn47i5
recode crn47i2 crn47i5 (5=1) (4=2) (3=3) (2=4) (1=5)
label define liste101_ac7_rev 1"Stimme voll und ganz zu" 5"Stimme Ÿberhaupt nicht zu" 
label values crn47i2 crn47i5 liste101_ac7_rev
numlabel liste101_ac7_rev, add
tab crn47i2
tab crn47i5
gen parentpress = (crn47i1+crn47i2+crn47i3+crn47i4+crn47i5)/5
label var parentpress "sum: parenting pressure, expectations etc."
tab parentpress
sum parentpress
*WORRIES and overprotectiveness
tab crn29i1
tab crn29i2
tab crn29i3
gen parentworry = (crn29i1+crn29i2+crn29i3)/3
label var parentworry "sum: parenting worries and overprotectiveness"
tab parentworry
sum parentworry
*SUM OF PARENTSTRESS
gen parentstr = (parentburden+parentpress+parentworry)/3
label var parentstr "sum parenting stress = parenting burden+pressure+worries"
tab parentstr
sum parentstr
*Scala from 0 to 4
gen parentstress=parentstr-1
recode parentstress (.=0) if nokids==1, gen(parentstress_all)

*COPARENT: relationship between children and coparent
*crn48k*

*PROBLEMS and discussions with coparent regarding parenting
*****|crn33p* (parenting problems /discussions with coparent)

*BURDEN of infants/toddlers
*crn26k* (has infant/toddler, burdened by childs sleeping behaviour at night?)
*crn28k* (has infant/toddler, burdened by crying  etc.?)

*parenting support and appreciation from partner 
tab crn20i5
tab crn20i6
gen parentsupportpart = (crn20i5+crn20i6)/2
label var parentsupportpart "sum: parenting support and appreciation from partner"
tab parentsupportpart
sum parentsupportpart
gen supportpart=parentsupportpart-1
*social support in child rearing: people looking after child / giving advice
tab crn30i1
tab crn30i2
gen parentsupportsoc = (crn30i1+crn30i2)/2
label var parentsupportsoc "sum: parenting support, looking after child / giving advice"
tab parentsupportsoc
sum parentsupportsoc
gen supportsoc=parentsupportsoc-1
*SUM OF PARENTSUPPORT
gen parentsupport=(supportsoc+supportpart)/2

*satisfaction with childcare situation for child 1-10
tab crn15k1



*****+--------------------------------------------------------------------------
*****| CO-VARIABLES SOES
*****+--------------------------------------------------------------------------

*Dummy:currently living in east germany
tab east

*EDUCATION
tab casmin
recode casmin (0=.) (2/3=1 "1 kein Abschluss/Hauptschulabschluss") (4/5=2 "2 Mittlere Reife") (6/7=3 "3 Fachhochschulreife/Abitur") (8/9=4 "4 Fachhochschulabschluss/Hochschulabschluss"), gen(edu) 
**Dummys: haupt, real, abi, uni - automatische 0/1 Codierung, automatisch durchnummeriert
tab edu, gen(edu_dum)
rename edu_dum1 haupt
rename edu_dum2 real
rename edu_dum3 abi
rename edu_dum4 uni
label var haupt "Kein Bildungsabschluss oder Hauptschulabschluss" 
label var real "Mittlere Reife"
label var abi "Fachhochschulreife/Abitur"
label var uni "Hochschulabschluss"
tab edu 

*OCCUPATIONAL STATUS
*Dummys: current acitivity status
tab casprim
recode casprim (1/8 14/16=1 "1 schooling/apprenticeship/university or marginally employed") (19=2 "2 not employed but seeking job") (17 20/22=3 "3 not employed: stay at home, retired, others") (12=4 "4 part-time employed") (11=5 "5 self-employed") (10=6 "6 full-time employed"), gen(occupation) 
tab occupation, gen(occupation_dum) 
rename occupation_dum1 scho
rename occupation_dum2 seek
rename occupation_dum3 home
rename occupation_dum4 part
rename occupation_dum5 self
rename occupation_dum6 full
label var scho "schooling (school apprenticeship university) or marginally employed"
label var seek "not employed but seeking job"
label var home "not employed: stay at home, retired, others"
label var part "part-time employed"
label var self "self-employed"
label var full "full-time employed"
tab occupation

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
*household net imcome
sum hhincnet

*CHILDHOOD SOES

*MIGRATION
tab migstat
recode migstat (1=0) (2 3=1)
label define vmigstat 0"no migration background" 1"1st or 2nd migration generation"
label values migstat vmigstat
numlabel vmigstat, add
tab migstat


*Dummy: experienced financial problems
tab cle1i1
gen moneystress = cle1i1
label var moneystress "ever had big financial problems, dept, insolvency" 


*****+--------------------------------------------------------------------------
*****| CO-VARIABLES PARTNERSHIP
*****+--------------------------------------------------------------------------
*Dummies: current lifestyle "single, lat, nel, ehe" (lat living apart together, nel nicht eheliche lebensgemeinschaft)
tab relstat
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
recode relstat (4=1 "Cohabition with spouse") (1/3=0) (5/11=0), gen(marcohab)


*Duration of current relationship 
sum reldur
generate relyears=reldur/12
label variable relyears "Duration of current relationship in years" 
sum relyears
*relationship of 41,3 years at age 43 possible?



********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****|  Tidy up Dataset and save
*****|
*****+--------------------------------------------------------------------------
drop k*agegroup k*_agegroup* k*age k*type k*dead k*nonbio reldur cohabdur mardur hhincgcee hhincoecd frt28 gh vt sf pp pf pf1 pf2 pr pr1 pr2 mh mh1 mh2 mr mr1 mr2 hps hms agg_hp agg_hm mh2 doby_gen dobm_gen meetdur hps1 cla12 frt30 hlt12* crn37* hhsizemrd npu14mr npo14mr mmrd fmrd pmrd hhcomp enrol school vocat isced isced2 casmin casprim lfs yeduc kldb2010 isco08 isei siops frt4* frt25i* np ncoh nmar crn11i1 crn11i6 crn47i1 crn47i2 crn47i3 crn47i4 crn47i5 crn29i1 crn29i2 crn29i3 lsr1i2 cla11 hlt10 hlt13 hlt14 hlt11i1 hlt11i2 hlt11i3 hlt1 per4i4 hlt17i7 hlt17i2 hlt15 hlt16 hlt17i3 hlt17i4 hlt17i1 per2i9 hlt17i5 hlt17i6 gh_z vt_z sf_z pp_z pf1_z pf2_z pf_z pr1_z pr2_z pr_z mh1_z mh2_z mh_z mr1_z mr2_z mr_z ehc7k* ehc8k* ehc9k* ehc10* ehc11* frt13* crn19* crn2k* crn15k* crn48k* crn33p*

save "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/3 Daten/pairfam_anchor7_lmk.dta", replace 
