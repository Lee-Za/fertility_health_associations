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
*****|Preliminaries
*****+--------------------------------------------------------------------------

version 13
clear all
set more off	

global path_in "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/3 Daten"  
global path_out "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/8 Grafik" 

use "$path_in/Data5_thesis.dta", clear

capture log close						
log using "/Users/lisa/Documents/0 - Uni Halle/7 MASTERARBEIT/4 Analyse/Log3_thesis_analyse.log", replace 



*****+--------------------------------------------------------------------------
*****| DESCRIBING HEALTH
*****+--------------------------------------------------------------------------

*Distribution Table
estpost sum hpcs hmcs
eststo a
esttab a using "$path_out/scores.rtf", cells("obs(fmt(2)) min(fmt(2)) max(fmt(2)) mean(fmt(2)) sd(fmt(2))") nonumber label varwidth(30) modelwidth(5) replace 

sum hpcs 
tab fem, sum(hpcs)

sum hmcs
tab fem, sum(hmcs)

*histograms
hist hpcs, percent graphregion(fcolor(white)) fcolor(navy) lcolor(white) lwidth(medthin) barwidth(1.5) xlabel(#10) ylabel(#5)
hist hmcs, percent graphregion(fcolor(white)) fcolor(orange) lcolor(white) lwidth(medthin) barwidth(1.5) xlabel(#10) ylabel(#5)

*Density line plot
kdensity hpcs, addplot(kdensity hmcs)

*boxplot
graph box hpcs hmcs, ylabel(#10) by(male)


*****+--------------------------------------------------------------------------
*****| DESCRIBING FERTILITY
*****+--------------------------------------------------------------------------
tab parents
tab parents fem, col


*Additional children planned?
tab frt27
tab frt27 fem, column


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
*****| INVESTIGATING & REDUCING COVARIABLES
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


*CORRELATION HEATPLOTS 
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
*****| ANALYSIS
*****|
*****+--------------------------------------------------------------------------
*****+--------------------------------------------------------------------------
*****| QUESTION 1: Parents vs Childless
*****+--------------------------------------------------------------------------
*simple mean comparison 
tab parents, sum (hpcs)
tab parents, sum (hmcs)
mean hpcs, over(parents)
mean hmcs, over(parents)
grmeanby parents cohabs cohabs_curr cohabs_bio, sum(hpcs)

*t-test mean comparison
*Variance homogeneity test: Levene /F-Test | H0=homogeneity/same sd for parents/childless | 
*"Unterscheiden sich die Varianzen/Standardabweichungen eines interessierenden Merkmals in zwei unabh�ngigen Stichproben?" hpcs/hmcs f�r parents/childless
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


*****+--------------------------------------------------------------------------
*****| QUESTION 1: First Birth Timing
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


*REGRESSION ANALYSIS
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
esttab a b c d using "$path_out/abcd.rtf", replace not nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. R²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant") beta
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
esttab a b c d e f using "$path_out/abcdef.rtf", replace not nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. R²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")


*Check correlation early-first-birth - parity
pwcorr early_fbirth_w early_fbirth_m nkidsalv4, sig


*What about late birth? And parity?
* (7)
reg hpcs fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 if fem==1
eststo a
* (8)
reg hpcs fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_parents if fem==1
eststo aa
* (9)
reg hpcs fbirth_dum2 fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_parents employed moneystress sport1 weight_high h_childhood_good onek_bfed if fem == 1
eststo aaa
* (10)
reg hpcs fbirth_dum3 fbirth_dum4 fbirth_dum5 if fem == 0
eststo b
* (11)
reg hpcs fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_parents if fem== 0
eststo bb
* (12)
reg hpcs fbirth_dum3 fbirth_dum4 fbirth_dum5 nkidsalv4_parents employed moneystress sport1 weight_high h_childhood_good onek_bfed if fem==0
eststo bbb
esttab a aa aaa b bb bbb using "$path_out/aaabbb.rtf", replace not nonumbers legend stats(r2_a N, fmt (2 0) labels("korr. R²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")


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



*****+--------------------------------------------------------------------------
*****| QUESTION 3: Optimal Parity
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


*REGRESSION ANALYSIS
*Brut & net models with parity dummies
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
esttab a b bb c d dd ddd dddd ddddd using "$path_out/abbbcddddddd.rtf", replace not nonumbers legend stats(r2_a N, fmt(2) labels("korr. R²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")


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


*Brut Models with Cohabition Years
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
esttab a aa b bb c cc d dd using "$path_out/abcd.rtf", replace not nonumbers legend stats(r2_a N, fmt(2) labels("korr. R²""n"))  dmarker(,) label mtitle addnote("Data: Pairfam wave 7, own calculations") starlevel (* 0.05 ** 0.01 *** 0.001) rename(_cons "Constant")



********************************************************************************
exit
