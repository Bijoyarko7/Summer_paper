clear all
cd Data
use Database_JA.dta

*Merge ex ante real rate Data from GFD
cd ../../GFD/
merge m:1 InitialMaturity using exanterealrate
replace exanterealrate=2.68 if InitialMaturity>30

**Robustness Assumptions
*replace exanterealrate=exanterealrate-1
*replace exanterealrate=exanterealrate-0.5
*replace exanterealrate=exanterealrate+0.5
*replace exanterealrate=exanterealrate+1
**

drop if _merge==2
drop if exanterealrate==.
cd ../MSPD/Output/

*Keep PEG period
keep if FirstIssueDateYear>1941 & FirstIssueDateYear<1952
keep FirstIssueDateYear publicholdings year InitialMaturity exanterealrate
sort FirstIssueDateYear InitialMaturity
rename year Year
rename FirstIssueDateYear IssuedIn

*Generate Average Ex ante real rate by Year-IssuedIn
egen sumpublicholdings_by_m = sum( publicholdings ), by (Year IssuedIn InitialMaturity)
rename sumpublicholdings_by_m PublicHoldings
drop publicholdings
duplicates drop
sort Year IssuedIn InitialMaturity exanterealrate
egen sumpublicholdings_y_by = sum( PublicHoldings ), by (Year IssuedIn)
*Weight gives the share of a given InitialMaturity for a given Year-IssuedIn pair
gen weight = PublicHoldings / sumpublicholdings_y_by
gen weightRate = weight * exanterealrate
egen AverageExAnteRealRate = sum(weightRate), by(Year IssuedIn)
keep Year IssuedIn AverageExAnteRealRate
duplicates drop

*Save
reshape wide AverageExAnteRealRate , i(IssuedIn) j(Year)
rename AverageExAnteRealRate* end*
rename IssuedIn issue_year
sort issue_year
export excel using "Output_GFD_PEG", sheet("ExAnteRealRatePeg") sheetreplace firstrow(variables)
