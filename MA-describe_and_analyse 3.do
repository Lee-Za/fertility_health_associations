********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****| Do-File 3 zur Masterarbeit:                         
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
global path_out "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik" 

use "$path_in/pairfam_anchor7_thesis.dta", clear

capture log close						
log using "$path_out/MA-analyse-Lisa-Maria-Keck.log", replace 


********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| Describing & Visualizing Sample
*****|
*****+--------------------------------------------------------------------------

*SEX
tab fem

*AGE
sum age

*Non biological children --> 189
tab nkidsnonbio 

*Additional children planned?
tab frt27
tab frt27 fem, column

*Deceased kids -->18
sum deadkids


*****+--------------------------------------------------------------------------
*****| HEALTH
*****+--------------------------------------------------------------------------
sum hpcs 
tab fem, sum(hpcs)

sum hmcs
tab fem, sum(hmcs)

*histograms
hist hpcs, percent graphregion(fcolor(white)) fcolor(navy) lcolor(white) lwidth(medthin) barwidth(1.5) xlabel(#10) ylabel(#5)
hist hmcs, percent graphregion(fcolor(white)) fcolor(orange) lcolor(white) lwidth(medthin) barwidth(1.5) xlabel(#10) ylabel(#5)

*boxplot
graph box hpcs hmcs, by(fem)


*****+--------------------------------------------------------------------------
*****| FERTILITY
*****+--------------------------------------------------------------------------
tab parents
tab parents fem, col


*AGE AT FIRST BIRTH 
histogram agegroup_fbirth, discrete frequency graphregion(fcolor(white)) fcolor(gray) lcolor(white) barwidth(0.9) addlabel
*graph use "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik/Graph-age at first birth all.gph", name(graph1, replace)
*graph use "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik/Graph-age at first birth agegroups.gph", name(graph2, replace)
*graph combine graph1 graph2
*Average age at first birth
sum age_fbirth
tab fem, sum(age_fbirth)


*PARITY
sum nkidsalv

histogram nkidsalv, frequency graphregion(fcolor(white)) fcolor(gray) lcolor(white) lwidth(medthin) barwidth(0.8) addlabel xlabel(#10) xtitle(Number of all Children alive)
graph save Graph "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik/Graph - number ok kids alive per parent.gph", replace

histogram nkidsalv4_parents, frequency graphregion(fcolor(white)) fcolor(gray) lcolor(white) barwidth(0.5) addlabel xtitle(Number of all children alive (only Parents)) xsize(2) ysize(2)
graph save Graph "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik/Graph - number ok kids alive per parent.gph", replace


*****+--------------------------------------------------------------------------
*****| Investigating & Reeducing Covariables
*****+--------------------------------------------------------------------------

*Income VS Household Income --> similar 
tw (scatter hpcs incnet, msize(0.6)) (lfit hpcs incnet, lwidth(medthick)) (scatter hpcs hhincnet, msize(0.6)) (lfit hpcs hhincnet, lwidth(medthick))

*Education
tw (scatter hpcs yeduc, jitter(33)) (lfit hpcs yeduc) 


*COMPARING MEANS OF CATEGORICAL DATA
*physical health 
grmeanby parents cohabs_bio fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 parentstress_high parentsupport_partner_high parentsupport_social_high onek_bfed hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 married_cohab edu_high employed moneystress east smoking alc_often sport1 friends1 sleep weight_high h_childhood_good, xlabel(,grid) ylabel(,grid) sum(hpcs)
*mental health 
grmeanby parents cohabs_bio fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 parentstress_high parentsupport_partner_high parentsupport_social_high onek_bfed hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 married_cohab edu_high employed moneystress east smoking alc_often sport1 friends1 sleep weight_high h_childhood_good, xlabel(,grid) ylabel(,grid) sum(hmcs)


*CORRELATION MATRIX + SIGNIFICANCE (siehe Github von Ben Jann)
*ssc install palettes, replace
*ssc install heatplot, replace

*Parenting related Variables I
pwcorr hpcs hmcs parentstress_high childcare_sat_avg parentsupport_partner_high parentsupport_social_high onek_bfed, sig
*Parenting related Variables II
pwcorr hpcs hmcs hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 livk_all, sig
*Lifestyle Variables I
pwcorr hpcs hmcs married_cohab relyears edu_high yeduc siops0 employed moneystress hhincnet east migstat, sig 
*Lifestyle Variables II
pwcorr hpcs hmcs smoking nsmoking_all alc_often alc_int  sport1 friends1 sleep weight_high h_childhood_good, sig
pwcorr hpcs hmcs nsmoking_all sport1 friends1 sleep weight_high h_childhood_good, sig

**check correlations again with full (slightly different) variable set for both scales
pwcorr hpcs parentstress_high onek_bfed	hask_agegroup1 hask_agegroup4 hask_agegroup5 married_cohab yeduc moneystress hhincnet childcare_sat_avg parentsupport_partner_high parentsupport_social_high employed nsmoking_all sport1 sleep weight_high h_childhood_good, sig
pwcorr hmcs parentstress_high married_cohab yeduc moneystress hhincnet friends1 childcare_sat_avg parentsupport_partner_high parentsupport_social_high employed nsmoking_all sport1 sleep weight_high h_childhood_good, sig

*HEATPLOTS 
*Pyhscial & mental health & covariables
quietly correlate hpcs parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good hmcs
matrix Physical = r(C)
heatplot Physical, values(format(%9.3f) size(tiny)) color(ptol, diverging intensity(.6)) aspectratio(1) xlabel(,labsize(vsmall) angle(45)) ylabel(,labsize(vsmall)) graphregion(fcolor(white)) lower nodiagonal
*Predictors and Covariables
quietly correlate hpcs fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 livk_all onek_bfed	 hask_agegroup1 hask_agegroup4 hask_agegroup5 married_cohab yeduc moneystress hhincnet childcare_sat_avg parentsupport_partner_high parentsupport_social_high employed nsmoking_all sport1 sleep weight_high h_childhood_good
matrix Test = r(C)
heatplot Test, values(format(%9.3f) size(minuscule)) color(ptol, diverging intensity(.6)) aspectratio(1) xlabel(,labsize(vsmall) angle(45)) ylabel(,labsize(vsmall)) graphregion(fcolor(white)) lower nodiagonal


*CORRELATION TABLE
*PHYSICAL FEMALE/MALE
estpost correlate hpcs parents cohabs_bio fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 livk_all parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good if fem == 1
eststo hpcs_fem
estpost correlate hpcs parents cohabs_bio fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 livk_all parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good if fem == 0
eststo hpcs_male
*MENTAL FEMALE/MALE
estpost correlate hmcs parents cohabs_bio fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 livk_all parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good if fem == 1
eststo hmcs_fem
estpost correlate hmcs parents cohabs_bio fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 nkidsalv4_dum5 livk_all parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good if fem == 0
eststo hmcs_male
*Combine tables and save as one 
esttab hpcs_fem hpcs_male hmcs_fem hmcs_male using "$path_out/test2.rtf", replace b(2) label compress not
*add missings and means?



*****+--------------------------------------------------------------------------
*****| FINAL SET OF COVARIABLES
*****+--------------------------------------------------------------------------
* hpcs: 
* parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 sleep weight_high h_childhood_good
* hmcs: 
* parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good



********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| QUESTION 1: Parents vs Childless
*****|
*****+--------------------------------------------------------------------------

*simple mean comparison 
tab parents, sum (hpcs)
tab parents, sum (hmcs)
mean hpcs, over(parents)
mean hmcs, over(parents)
grmeanby parents cohabs cohabs_curr cohabs_bio, sum(hpcs)

*****+--------------------------------------------------------------------------
*****| T-Test: mean comparison
*****+--------------------------------------------------------------------------
*https://www.methodenberatung.uzh.ch/de/datenanalyse_spss/unterschiede/zentral/ttestunabh.html
*Voraussetzungen: VarianzhomogenitŠt (Varianzen von zwei Stichproben gleich/homogen) + Normalverteilung (Health muss in beiden Gruppen normalverteilt sein) + 
*https://www.skillshare.com/classes/Learn-Data-Analytics-with-Stata/604566713/projects?via=search-layout-grid


*Variance homogeneity test: Levene /F-Test | H0=homogeneity/same sd for parents/childless | 
*"Unterscheiden sich die Varianzen/Standardabweichungen eines interessierenden Merkmals in zwei unabhŠngigen Stichproben?" hpcs/hmcs fŸr parents/childless
*--> hpcs has equal variances, hmcs has unequal variances
robvar  hpcs, by(parents)
robvar  hmcs, by(parents)

*Standard distribution test: Shapiro Wilk Normality Test (Janssen 249) | H0=normality | all significant--> H0 rejected=>no normality
hist hpcs, by(parents) normal graphregion(fcolor(white)) fcolor(emidblue) lcolor(white)
hist hmcs, by(parents) normal graphregion(fcolor(white)) fcolor(emidblue) lcolor(white)
by parents, sort : swilk hpcs
by parents, sort : swilk hmcs

*Two-sample t-test | H0=no difference | no significance --> H0 not rejected=>no difference
ttest hpcs, by(parents) 
ttest hmcs, by(parents) unequal
*nonparametric equivalent for t-test: Mann-Whitney-U test | H0=no difference | no significance --> H0 not rejected=>no difference
*https://www.methodenberatung.uzh.ch/de/datenanalyse_spss/unterschiede/zentral/mann.html
help ranksum
ranksum hpcs, by(parents)
ranksum hmcs, by(parents)

*Testing other variables of parenthood
ranksum hpcs, by(cohabs) 
ranksum hmcs, by(cohabs)
ranksum hpcs, by(cohabs_bio) 
ranksum hmcs, by(cohabs_bio)
mean hpcs, over(parents) 
mean hpcs, over(cohabs)
mean hpcs, over(cohabs_bio)
mean hmcs, over(parents) 
mean hmcs, over(cohabs)
mean hmcs, over(cohabs_bio)


*Testing Age of Children: having young kids vs. no kids (excluding other parents)
tab hask_agegroup1
*recoding to get parents with kid in agegroup x VS. childless
replace hask_agegroup1 = 2 if parents == 0
replace hask_agegroup2 = 2 if parents == 0
replace hask_agegroup3 = 2 if parents == 0
replace hask_agegroup4 = 2 if parents == 0
replace hask_agegroup5 = 2 if parents == 0
recode hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 (0 = .) (2 = 0)
ttest hpcs, by(hask_agegroup1) 
ttest hmcs, by(hask_agegroup1) unequal


*comapring men and women 
estpost correlate hpcs parents cohabs cohabs_bio has_infant hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 if fem == 1
eststo a
estpost correlate hpcs parents cohabs cohabs_bio has_infant hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 if fem == 0
eststo b
estpost correlate hmcs parents cohabs cohabs_bio has_infant hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 if fem == 1
eststo c
estpost correlate hmcs parents cohabs cohabs_bio has_infant hask_agegroup1 hask_agegroup2 hask_agegroup3 hask_agegroup4 hask_agegroup5 if fem == 0
eststo d
esttab a b c d using "$path_out/abcd.rtf", replace b(2) label compress not


*REGRESSION FOR FATHERS
*mental health
reg hmcs cohabs if fem == 0
reg hmcs cohabs married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 friends1 sleep weight_high h_childhood_good if fem == 0, beta
reg hmcs cohabs employed if fem == 0
*physical health
reg hpcs has_infant if fem == 0
reg hpcs has_infant onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 sleep weight_high h_childhood_good if fem==0, beta
*check how many father with young children have only 1 child
tab hask_agegroup1 nkidsalv if fem == 0, row




********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| QUESTION 2: Best Time for first birth
*****|
*****+--------------------------------------------------------------------------

*VISUALIZATIONS
*Scatter over sex with continous age at frist birth
*physical 
tw (scatter hpcs age_fbirth, name(a, replace) jitter(10) msize(tiny) mcolor(emidblue) graphregion(fcolor(white)) title("Women")) (lpolyci hpcs age_fbirth if fem == 1, lwidth(medium) lcolor(cranberry) ytitle("Physical Health") xtitle("Age at first Birth"))
tw (scatter hpcs age_fbirth, name(b, replace) jitter(10) msize(tiny) mcolor(emidblue) graphregion(fcolor(white)) title("Men")) (lpolyci hpcs age_fbirth if fem == 0, lwidth(medium) lcolor(cranberry) ytitle("Physical Health") xtitle("Age at first Birth"))
*mental
tw (scatter hmcs age_fbirth, name(c, replace) jitter(10) msize(tiny) mcolor(dkorange) graphregion(fcolor(white)) title("Women")) (lpolyci hmcs age_fbirth if fem == 1, lwidth(medium) lcolor(cranberry) ytitle("Mental Health") xtitle("Age at first Birth"))
tw (scatter hmcs age_fbirth, name(d, replace) jitter(10) msize(tiny) mcolor(dkorange) graphregion(fcolor(white)) title("Men")) (lpolyci hmcs age_fbirth if fem == 0, lwidth(medium) lcolor(cranberry) ytitle("Mental Health") xtitle("Age at first Birth"))
graph combine a b c d, ycommon col(2) 
*graph save Graph "$path_out/scatter_abcd.gph", replace

*grmeanby with age groups
grmeanby fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5, sum(hpcs)
grmeanby fbirth_dum1 fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5, sum(hmcs)


*****+--------------------------------------------------------------------------
*****| REGRESSION ANALYSIS
*****+--------------------------------------------------------------------------
*BRUT MODELS
regress hmcs age_fbirth if fem == 1
regress hmcs age_fbirth if fem == 0
regress hpcs age_fbirth if fem == 1
regress hpcs age_fbirth if fem == 0
mean hpcs, over(agegroup_fbirth)
reg hmcs fbirth_dum1 fbirth_dum2 fbirth_dum4 fbirth_dum5 if fem == 1
reg hmcs fbirth_dum1 fbirth_dum2 fbirth_dum4 fbirth_dum5 if fem == 0
* --> no relationship for mental health and age_fbirth
* --> only early first birth has significant association


*NET MODELS using Dummies for early birth
* check for relevant moderators using beta coefficients
*Women
reg hpcs early_fbirth_w if fem == 1
eststo a
reg hpcs early_fbirth_w parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 sleep weight_high h_childhood_good if fem == 1
eststo b
*Men
reg hpcs early_fbirth_m if fem == 0
eststo c
reg hpcs early_fbirth_m parentstress_high parentsupport_partner_high parentsupport_social_high childcare_sat_avg onek_bfed married_cohab yeduc employed moneystress hhincnet nsmoking_all sport1 sleep weight_high h_childhood_good if fem == 0
eststo d
esttab a b c d using "$path_out/abcd.rtf", replace not nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant") beta
*--> relevant factors: parentstress_high employed moneystress sport1 weight_high h_childhood_good onek_bfed
*Reduced Model
*Women
* (1)
reg hpcs early_fbirth_w if fem == 1
eststo a
* (2)
reg hpcs early_fbirth_w employed moneystress if fem == 1
eststo b
* (3)
reg hpcs early_fbirth_w employed moneystress sport1 weight_high h_childhood_good onek_bfed if fem == 1
eststo c
*Men
* (4)
reg hpcs early_fbirth_m if fem == 0
eststo d
* (5)
reg hpcs early_fbirth_m employed moneystress if fem == 0
eststo e
* (6)
reg hpcs early_fbirth_m employed moneystress sport1 weight_high h_childhood_good onek_bfed if fem == 0
eststo f
esttab a b c d e f using "$path_out/abcdef.rtf", replace not nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")


*Check correlation early-first-birth - parity
pwcorr early_fbirth_w early_fbirth_m nkidsalv4, sig


*What about late birth? And parity?
* (7)
reg hpcs fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 if fem==1
eststo a
* (8)
reg hpcs fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4 if fem==1
eststo aa
* (9)
reg hpcs fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4 employed moneystress sport1 weight_high h_childhood_good onek_bfed if fem == 1
eststo aaa
* (10)
reg hpcs fbirth_dum3 fbirth_dum4 fbirth_dum5 if fem == 0
eststo b
* (11)
reg hpcs fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4 if fem== 0
eststo bb
* (12)
reg hpcs fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4 employed moneystress sport1 weight_high h_childhood_good onek_bfed if fem==0
eststo bbb
esttab a aa aaa b bb bbb using "$path_out/aaabbb.rtf", replace not nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")


*testing interaction effects between age at first birth and education/occupation on physical health
reg hpcs agegroup_fbirth 
reg hpcs employed
reg hpcs i.agegroup_fbirth#i.employed 

*Conditional-Effects-Plots unemployed / employed, aufgesplittet nach altersgruppen auf hpcs
reg hpcs i.agegroup_fbirth#i.employed if fem == 1
margins, at (employed=(0,1) agegroup_fbirth=(0(1)4))
marginsplot, bydim(employed) byopt(rows(1)) graphregion(fcolor(white))

reg hpcs i.agegroup_fbirth#i.employed if fem == 0
margins, at (employed=(0,1) agegroup_fbirth=(0(1)4))
marginsplot, bydim(employed) byopt(rows(1)) graphregion(fcolor(white))

*graph save Graph "$path_out\margins1.gph", replace

*who are the unemployed late fathers?
tab casprim if fem == 0 & employed == 0 & age > 34



********************************************************************************
********************************************************************************
*****+--------------------------------------------------------------------------
*****|
*****| QUESTION 3: Optimal Parity
*****|
*****+--------------------------------------------------------------------------

*VISUALIZATION
tw (scatter hpcs nkidsalv4, jitter(5) msize(tiny) mcolor(emidblue) yscale(range (65))) (lpolyci hpcs nkidsalv4, lcolor(cranberry) lwidth(medthin) by(male,compact))
tw (scatter hmcs nkidsalv4, jitter(5) msize(tiny) mcolor(dkorange) yscale(range (65))) (lpolyci hmcs nkidsalv4, lcolor(cranberry) lwidth(medthin) by(male,compact))


*Cohabition Years vs. Number of Kids 1-4+
*hpcs
tw (scatter hpcs livk_all if livk_all < 60, msize(0.6)) (lpolyci hpcs livk_all if livk_all < 60, lwidth(medthick) by(male, compact)) 
tw (scatter hpcs nkidsalv4, jitter(5) msize(0.6)) (lpolyci hpcs nkidsalv4,  lwidth(medthick) by(fem,compact))
*hmcs
tw (scatter hmcs livk_all if livk_all < 60, msize(0.6)) (lpolyci hmcs livk_all if livk_all < 60, lwidth(medthick) by(male, compact)) 
tw (scatter hmcs nkidsalv4, jitter(5) msize(0.6)) (lpolyci hmcs nkidsalv4, lwidth(medthick) by(fem,compact))
*Comparing Parity Versions
pwcorr hpcs hmcs livk_all nkidsalv4 nkidsalv4_dum5, sig




*****+--------------------------------------------------------------------------
*****| REGRESSION ANALYSIS
*****+--------------------------------------------------------------------------
*BRUT & NET MODELS WITH PARITY DUMMIES
*Physical
* (13)
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 if fem == 1 
eststo a
* (14)
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 if fem == 0 
eststo b
*(14b)
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 employed moneystress if fem == 0
eststo bb
*Mental
* (15)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 if fem == 1 
eststo c
* (16)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 if fem == 0 
eststo d
* (17)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 employed moneystress if fem == 0 
eststo dd
* (18)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 employed moneystress sport1 sleep if fem == 0 
eststo ddd
* (19)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 employed moneystress sport1 sleep h_childhood_good if fem == 0 
eststo dddd
* (20)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum4 nkidsalv4_dum5 employed moneystress sport1 sleep h_childhood_good married_cohab yeduc if fem == 0 
eststo ddddd
esttab a b bb c d dd ddd dddd ddddd using "$path_out/abbbcddddddd.rtf", replace not nonumbers legend stats(r2_a N, fmt(2) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")


*Conditional-Effects-Plots unemployed / employed, aufgesplittet nach altersgruppen auf hpcs
reg hmcs i.nkidsalv4#i.employed if fem == 1
margins, at (employed=(0,1) nkidsalv4=(0(1)4))
marginsplot, bydim(employed) byopt(rows(1)) graphregion(fcolor(white)) name(w)
*graph save Graph "$path_out\margins-nkids-w.gph", replace
reg hmcs i.nkidsalv4#i.employed if fem == 0
margins, at (employed=(0,1) nkidsalv4=(0(1)4))
marginsplot, bydim(employed) byopt(rows(1)) graphregion(fcolor(white)) name(m)
*graph save Graph "$path_out\margins-nkids-m.gph", replace
graph combine w m, col(1)
*graph save Graph "$path_out\margins1.gph", replace




*BRUT MODELS WITH COHABITION YEARS
*Physical
*(21)
reg hpcs nkidsalv4_parents if fem == 1
eststo a
*(22)
reg hpcs livk_all if fem == 1
eststo aa
*(23)
reg hpcs nkidsalv4_parents if fem == 0
eststo b
*(24)
reg hpcs livk_all if fem == 0
eststo bb
*Mental
*(25)
reg hmcs nkidsalv4_parents if fem == 1
eststo c
*(26)
reg hmcs livk_all if fem == 1
eststo cc
*(27)
reg hmcs nkidsalv4_parents if fem == 0
eststo d
*(28)
reg hmcs livk_all if fem == 0
eststo dd
esttab a aa b bb c cc d dd using "$path_out/abcd.rtf", replace not nonumbers legend stats(r2_a N, fmt(2) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")

*NET MODELS WITH COHABITION YEARS (only women)





***********************************************************************************************************



























**********************************************************************************



*Visualization
mean hpcs, over(nkidsalv5)
mean hmcs, over(nkidsalv5)
graph box hpcs, over(nkidsalv5) graphregion(fcolor(white)) ytitle(Physical Health) 
graph box hmcs, over(nkidsalv5) graphregion(fcolor(white)) ytitle(Mental Health)

*****+--------------------------------------------------------------------------
*****| ANOVA: mean comparisons 0-5+ kids
*****+--------------------------------------------------------------------------
*https://www.methodenberatung.uzh.ch/de/datenanalyse_spss/unterschiede/zentral/evarianz.html
*"Unterscheiden sich die Mittelwerte einer abhŠngigen Variable zwischen mehreren Gruppen? Welche Faktorstufen unterscheiden sich?"
*Voraussetzungen: VarianzhomogenitŠt (Varianzen von zwei Stichproben gleich/homogen) + Normalverteilung (Health muss in beiden Gruppen normalverteilt sein) aber: (Ab > 25 Probanden pro Gruppe sind Verletzungen in der Regel unproblematisch)

*Variance homogeneity test: Levene /F-Test | H0=homogeneity/same sd for all groups | 
*"Unterscheiden sich die Varianzen/Standardabweichungen eines interessierenden Merkmals in zwei unabhŠngigen Stichproben?" hpcs/hmcs fŸr parents/childless
*--> ????
robvar  hpcs, by(nkidsalv5)
robvar  hmcs, by(nkidsalv5)

*Standard distribution test: Shapiro Wilk Normality Test (Janssen 249) | H0=normality | all significant--> H0 rejected=>no normality
hist hpcs, by(nkidsalv5) normal graphregion(fcolor(white)) fcolor(emidblue) lcolor(white)
hist hmcs, by(nkidsalv5) normal graphregion(fcolor(white)) fcolor(emidblue) lcolor(white)
by nkidsalv5, sort : swilk hpcs
by nkidsalv5, sort : swilk hmcs

*ANOVA | H0=means of all groups have the same mean |
mean hpcs, over(nkidsalv5)
anova hpcs nkidsalv5
anova hmcs nkidsalv5
*post-hoc Bonferroni
oneway hpcs nkidsalv5, tab bonferroni
oneway hpms nkidsalv5, tab bonferroni

*Kruskal-Wallis-Test/H-test: nicht-parametrisches €quivalent zu ANOVA (Voraussetzungsfrei)
*https://www.methodenberatung.uzh.ch/de/datenanalyse_spss/unterschiede/zentral/kruskal.html
*ttps://statistics.laerd.com/stata-tutorials/kruskal-wallis-h-test-using-stata.php
kwallis hpcs, by(nkidsalv5)
kwallis hmcs, by(nkidsalv5)

*Visualization
*BoxPlot
sum hpcs
local mhp=r(mean)
graph box hpcs, over(nkidsalv5) graphregion(fcolor(white)) yline(`mhp') ytitle(Physical Health) ylabel(, angle(horizontal))
*Plot of means with confidence intervals
ci hpcs, by(nkidsalv5)
*help ciplot / install ciplot
ciplot hpcs, by(nkidsalv5) graphregion(fcolor(white)) yline(`mhp') xtitle(Number of kids 0-5+) ytitle(Physical Health) ylabel(, angle(horizontal))

*visualizing relationships, looking for possible non-linear relationships:
pwcorr hpcs nkidsalv5, sig


*****+--------------------------------------------------------------------------
*****| REGRESSION: Checking preconditions
*****+--------------------------------------------------------------------------

*VORAUSSETZUNGEN --> all violated!?!?!
*https://www.youtube.com/watch?v=4g_iCiQe7W4
*Lineare Beziehung zueineander AV und UV: viseulle Inspektion des Streudiagrammes --> NO Linearity
*Scatterplot
graph twoway (lfit hpcs nkidsalv5) (scatter hpcs nkidsalv5, jitter(30))
graph twoway (qfit hmcs nkidsalv5) (scatter hmcs nkidsalv5, jitter(30))
*--> keinerlei LinearitŠt dabei, Dummy-Codierung setzt keine LinearitŠt voraus

**Residual normality: normal distributed residuals around predicted values
*Nomality plot
reg hpcs nkidsalv4_dum*
predict res1, resid
hist res1, normal
reg hmcs nkidsalv4_dum*
predict res2, resid
hist res2, normal
*Statistical Normality test: Shapiro Wil --> NO Normality
swilk res1
swilk res2
  
*Residual homogeneity/homoskedaziditŠt: equal variances of residuals /SD --> NO / YES
*Residuals Plot --> needs to be random display predictionairs 
reg hpcs nkidsalv4_dum*
rvfplot, recast scatter
*Statistical Residual Test --> Heteroskedasticity hpcs (0.0242) Homoskedasticity hmcs (0.0629)?
reg hpcs nkidsalv4_dum*
estat imtest
reg hmcs nkidsalv4_dum*
estat imtest

*low levels of multicollinerity between predictors


*****+--------------------------------------------------------------------------
*****| REGRESSION: only parents
*****+--------------------------------------------------------------------------
*Examining patterns of missing data for covariables 
misschk nkidsalv4_parents livk_all, gen(miss_pre1) replace

reg hpcs nkidsalv4_parents if miss_pre1number==0, beta
eststo r9p
reg hpcs livk_all if miss_pre1number==0, beta
eststo r10p
reg hmcs nkidsalv4_parents if miss_pre1number==0, beta
eststo r9m
reg hmcs livk_all if miss_pre1number==0, beta
eststo r10m
esttab r9p r10p r9m r10m using "$path_out/r1.rtf" , replace nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculation") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant") beta




*****+--------------------------------------------------------------------------
*****| NET MULTIPLE LINEAR DUMMY REGRESSION: 0-4+ kids
*****+--------------------------------------------------------------------------
*Examining patterns of missing data for covariables 
misschk fem h_childhood smoking sport1 friends1 marcohab haupt uni seek full moneystress, gen(miss_co1) replace

*physical health (with beta coefficients)
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 if miss_co1number==0, beta
eststo r2p
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem if miss_co1number==0, beta
eststo r3p
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood if miss_co1number==0, beta
eststo r4p
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 if miss_co1number==0, beta
eststo r5p
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 i.marcohab if miss_co1number==0, beta
eststo r6p
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 i.marcohab i.haupt i.uni if miss_co1number==0, beta
eststo r7p
reg hpcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 i.marcohab i.haupt i.uni i.seek i.full i.moneystress if miss_co1number==0, beta
eststo r8p
esttab r2p r3p r4p r5p r6p r7p r8p using "$path_out/r2p-r8p.rtf" , replace nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")
esttab r2p r3p r4p r5p r6p r7p r8p using "$path_out/r2p-r8p_beta.rtf" , replace nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant") beta

*mental health (with beta coefficients)
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 if miss_co1number==0, beta
eststo r2m
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem if miss_co1number==0, beta
eststo r3m
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood if miss_co1number==0, beta
eststo r4m
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 if miss_co1number==0, beta
eststo r5m
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 i.marcohab if miss_co1number==0, beta
eststo r6m
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 i.marcohab i.haupt i.uni if miss_co1number==0, beta
eststo r7m
reg hmcs nkidsalv4_dum1 nkidsalv4_dum2 nkidsalv4_dum3 nkidsalv4_dum4 fem h_childhood i.smoking i.sport1 i.friends1 i.marcohab i.haupt i.uni i.seek i.full i.moneystress if miss_co1number==0, beta
eststo r8m
esttab r2m r3m r4m r5m r6m r7m r8m using "$path_out/r2m-r8m.rtf" , replace nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")
esttab r2m r3m r4m r5m r6m r7m r8m using "$path_out/r2m-r8m_beta.rtf" , replace nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant") beta



*****+--------------------------------------------------------------------------
*****| NET MULTIPLE LINEAR DUMMY REGRESSION: parents, biological factors
*****+--------------------------------------------------------------------------
*Examining patterns of missing data for covariables 
misschk fem nnonbiokid nk_bfed h_childhood smoking uni seek moneystress, gen(miss_co2) replace

*physical
reg hpcs nkidsalv4_p_dum1 nkidsalv4_p_dum2 nkidsalv4_p_dum3 if miss_co2number==0, beta
eststo r11p
reg hpcs nkidsalv4_p_dum1 nkidsalv4_p_dum2 nkidsalv4_p_dum3 fem if miss_co2number==0, beta
eststo r12p
reg hpcs nkidsalv4_p_dum1 nkidsalv4_p_dum2 nkidsalv4_p_dum3 fem nnonbiokid if miss_co2number==0, beta
eststo r13p
reg hpcs nkidsalv4_p_dum1 nkidsalv4_p_dum2 nkidsalv4_p_dum3 fem nnonbiokid nk_bfed if miss_co2number==0, beta
eststo r14p
reg hpcs nkidsalv4_p_dum1 nkidsalv4_p_dum2 nkidsalv4_p_dum3 fem nnonbiokid nk_bfed h_childhood i.smoking i.uni i.seek i.moneystress if miss_co2number==0, beta
eststo r15p
esttab r11p r12p r13p r14p r15p using "$path_out/r11p-r15p_beta.rtf" , replace nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. RÂ²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant") beta

*mental

*****+--------------------------------------------------------------------------
*Visualization the relationship between the variables (not for Dummies)
graph matrix 
scatter
*correlation matrix of all variables with significance levels
pwcorr, sig


parentstress nk_bfed

*HomoskedastizitŠt (Gauss-Markov-Annahme 5): FŸr jeden Wert der unabhŠngigen Variablen hat der Fehlerwert dieselbe Varianz.

* 	Normalverteilung des Fehlerwerts: Die Fehlerwerte sind nŠherungsweise normalverteilt.


*Bivariate Normalverteilung, Test fŸr das gesamte Sample: Shapiro Wilk fŸr hmcs hpcs nkidsalv4
swilk hpcs hmcs nkidsalv4
*--> hpcs und hmcs nicht normverteilt, aber ok, da gro§e Stichprobe



*1 Histogramme: einfache HŠufigkeits-Verteilungskurven
kdensity hpcs, addplot(kdensity hmcs) title(Physical and Mental Health) xtitle(Health)
graph save Graph "$path_out/1kdensPM.gph", replace
*P nach Geschlecht
kdensity hpcs if fem==1, addplot(kdensity hpcs if fem==0) title(Physical Health by Gender) xtitle(Health)
*M nach Geschlecht
kdensity hmcs if fem==1, addplot(kdensity hmcs if fem==0) title(Mental Health by Gender) xtitle(Health)

kdensity hpcs if edu==1, addplot(kdensity hpcs if edu==4) title(Physical Health by Education) xtitle(Health)
kdensity hmcs if edu==1, addplot(kdensity hmcs if edu==4) title(Mental Health by Education) xtitle(Health)
kdensity hpcs if occupation==2, addplot(kdensity hpcs if occupation==6) title(Physical Health by Occupation) xtitle(Health)
kdensity hmcs if occupation==2, addplot(kdensity hmcs if occupation==6) title(Mental Health by Occupation) xtitle(Health)


kdensity hmcs if edu==1, addplot(kdensity hmcs if edu==0) title(Mental Health by Income) xtitle(Health)



*P
hist hpcs, bin(15) percent fcolor(black) lcolor(white) addlabel addlabopts(mlabsize(tiny))
graph save Graph "$path_out/1histP.gph", replace
hist hpcs, bin(15) percent fcolor(black) lcolor(white) addlabel addlabopts(mlabsize(tiny)) by(sex_gen)  title(Physical Health by Gender)
graph save Graph "$path_out/1histPsex.gph", replace
*M
hist hmcs, bin(15) percent fcolor(white) lcolor(black) addlabel addlabopts(mlabsize(tiny))
graph save Graph "$path_out/1histM.gph", replace
hist hmcs, bin(20) percent fcolor(white) lcolor(black) addlabel addlabopts(mlabsize(tiny)) by(sex_gen) title(Mental Health by Gender)
graph save Graph "$path_out/1histMsex.gph", replace

*2 Boxplots (mean und median)
label define veast 1"East" 0"West"
label values east veast
*P
graph box hpcs
graph save Graph "$path_out/2boxP.gph", replace
graph box hpcs, over(sex_gen)
graph save Graph "$path_out/2boxPsex.gph", replace
graph box hpcs, over(sex_gen) over(east) 
graph save Graph "$path_out/2boxPsexeast.gph", replace
graph box hpcs, over(edu)
graph save Graph "$path_out/2boxPedu.gph", replace
graph box hpcs, over(nkids)
graph save Graph "$path_out/2boxPnkids.gph", replace
*M
graph box hmcs
graph save Graph "$path_out/2boxM.gph", replace
graph box hmcs, over(sex_gen)  
graph save Graph "$path_out/2boxMsex.gph", replace
graph box hmcs, over(sex_gen) over(east) 
graph save Graph "$path_out/2boxMsexeast.gph", replace
graph box hmcs, over(edu)
graph save Graph "$path_out/2boxMedu.gph", replace
graph box hmcs, over(nkids)
graph save Graph "$path_out/2boxnPkids.gph", replace







*Breastfeeding, stronger effect on P for women, but also significant for men...
*no effect on M
reg pcs onek_bfed if sex_gen==2
reg pcs onek_bfed if sex_gen==1

reg pcs onek_bfed if sex_gen==1 & nnonbiokid==0
reg pcs onek_bfed if sex_gen==2 & nnonbiokid==0
*Effect of bio kids stronger on men?!






********************************************************************************
exit
