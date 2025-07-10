*Original Code from Blanchard (2019) - Edited by J.Acalin

*===============================================================================
*
*
*				Low rates project - Historical analysis - US - comparison R - G 
*				
*				dataset from MeasuringWorth, Shiller, OMB, CBO forecasts after 2017
*
*
*										created from Main do.file
*							ADDED R and R_ADJ FOR MATURITY AND TAX ADJUSTMENT
*										
*				Amended version of Thomas Pellet's do file "r-g evidence 02 28 bis"
*										
*				Colombe Ladreit, Peterson institute for International economics
*
*									  7-10-2018 - version 1.0.0

*
*===============================================================================

clear all

use "USinterestrates_final.dta"

set more off

tsset year


*===============================================================================
*
*				V-Generate 1+r/1+g
*
*===============================================================================

*Constructing 1+R/1+G using different interest rates
*===============================================================================

*With interest rate on 3 months r1y
*-----------------------------------------

gen rog2 = (1+r1y/100)/(1+g/100)
label variable rog2 "1+ 1Y T over 1 + nominal g."

*with interest rate on 10 year goverment bonds
*---------------------------------------------

gen rlog2 = (1+r10y/100)/(1+g/100)
label variable rlog2 "1+ 10-y T over 1+ nominal g."

*With interest rate adjusted for maturity
*-----------------------------------------

gen rog_mat2 = (1+r2/100)/(1+g/100)
label variable rog_mat2 "1+ 1Y T adj for mat over 1 + nominal g."

*with interest rate adjusted for maturity and tax
*---------------------------------------------

gen rog_adj2 = (1+r_adj/100)/(1+g/100)
label variable rog_adj2 "1+ 1Y T adj for mat and tax over 1+ nominal g."

*===============================================================================
*
*				V-bis. Generate implied debt path starting in 1960,1970,1980,1990,2000
*
*===============================================================================

*generate debt path conditional on realized growth and safe rate

foreach year in 1946 1960 1970 1979 1980 1990 2000  {

	foreach var of varlist rog2  rlog2 rog_mat2 rog_adj2  {
		*short rate
		
		*path of r and g
		gen debt`var'`year' =`var'
		*initial debt to GDP
		replace debt`var'`year' = 100 if year == `year'
		replace debt`var'`year' = . if year < `year'
		* generate path conditional on initial debt to GDP
		replace debt`var'`year' = debt`var'`year'*debt`var'`year'[_n-1] if year > `year'
	

		}
}

pause on

* Figure 5
tsline debtrog_mat21946 debtrog_mat21960 debtrog_mat21970 debtrog_mat21980 debtrog_mat21990 debtrog_mat22000 if year > 1949, ytitle("index") lcolor(green blue dkorange dkgreen red black) xlab(1950(10)2020) legend(off) graphregion(color(white)) bgcolor(white) 

* Figure 6
tsline debtrog_adj21946 debtrog_adj21960 debtrog_adj21970 debtrog_adj21980 debtrog_adj21990 debtrog_adj22000 if year > 1949, ytitle("index") lcolor(green blue dkorange dkgreen red black) xlab(1950(10)2020) legend(off) graphregion(color(white)) bgcolor(white) 

* Export Results to Excel
keep year debtrog_mat21979 debtrog_adj21979
rename debtrog_mat21979 Blanchard2019NonTaxAdjustedRate
rename debtrog_adj21979 Blanchard2019withTaxAdjustment
export excel using "Blanchard2019.xlsx", replace firstrow(variables)
