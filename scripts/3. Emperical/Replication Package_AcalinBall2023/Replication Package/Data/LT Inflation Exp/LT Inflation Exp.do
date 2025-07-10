clear all
use InflationData.dta
tsset fy

*Filter ST
keep if fy>1949
tsfilter hp ct= pi_exp_short , trend(pi_exp_short_hp) smooth(100)

*Regress LT on Filtered ST 
gen pi_exp_short_hp_chg = pi_exp_short_hp - l.pi_exp_short_hp
gen pi_exp_long_minus_short = pi_exp_long_true - pi_exp_short_hp
reg pi_exp_long_minus_short pi_exp_short_hp_chg if fy<1998 & fy>1949, noconstant
outreg2 using TableA1.xls, excel dec(3) br
predict pi_exp_long_predict, xb
replace pi_exp_long_predict = pi_exp_long_predict + pi_exp_short_hp

*LT series
gen exp_long= pi_exp_long_true
replace exp_long = pi_exp_long_predict if exp_long==.

*Export
keep fy pi_exp_short pi_exp_short_hp pi_exp_long_true pi_exp_long_predict exp_long  
export excel "Inflation Expectations.xlsx", firstrow(variables) replace
