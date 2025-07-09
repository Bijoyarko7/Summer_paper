clear all

********************************************************************************
** Build Database **
********************************************************************************

********************************************************************************
*Import and Reformat BondQuant
cd Data
import delimited BondQuant.csv
keep if series=="PublicHoldings" | series=="ActiveOutstanding" | series=="TotalOutstanding"
reshape long v, i(l1id series) j(date)
reshape wide v, i(l1id date) j(series) string
rename v* *
replace date = date - 723
format %tm date
format date %10.0g
di (00 - 60)*12
gen date2 = dofm(date)
format date2 %d
gen month=month(date2)
gen year=year(date2)
*Keep End Fiscal Year - June
keep if month==6
rename l1id L1ID
keep L1ID year ActiveOutstanding PublicHoldings TotalOutstanding
rename PublicHoldings publicholdings
save BondQuant_JA.dta, replace
clear all

*Import BondList
import delimited BondList.csv, case(preserve) 
sort L1ID
drop in 2860/2865
drop in 4/5
destring L1ID, replace
save BondList_JA.dta, replace
clear all

*Merge BondQuant and BondList
use BondQuant_JA.dta
merge m:1 L1ID using BondList_JA
keep if _merge==3
drop _merge
sort L1ID year
save BondQuantList_JA.dta, replace

erase BondList_JA.dta
erase BondQuant_JA.dta
clear all
********************************************************************************

*cd Data
use BondQuantList_JA.dta

*Extract First Issue year and Payable Date year
gen FirstIssueDate2 = date(FirstIssueDate, "MDY")
format FirstIssueDate2 %td
gen FirstIssueDateYear=year( FirstIssueDate2 )
gen PayableDate2 = date(PayableDate, "MDY")
format PayableDate2 %td
gen PayableDateYear=year( PayableDate2 )

*Adjust First Issue year and Payable Date year for Fiscal Year End June
gen FirstIssueDateMonth=month( FirstIssueDate2 )
replace FirstIssueDateYear = FirstIssueDateYear + 1 if FirstIssueDateMonth>6
gen PayableDateMonth=month( PayableDate2 )
replace PayableDateYear = PayableDateYear + 1 if PayableDateMonth>6

*Identify Begin and End
xtset L1ID year
sort L1ID year
gen begin=.
by L1ID: replace begin = 1 if publicholdings!=. & l.publicholdings==.
gen end=.
by L1ID: replace end = 1 if publicholdings!=. & f.publicholdings==.
order begin end , a(publicholdings)
order FirstIssueDateYear PayableDateYear , a(end)

*Generate Begin_year and End_year
gen begin_year=year if begin==1
gen end_year=year if end==1
order  begin_year end_year , a( publicholdings )
by L1ID: replace begin_year=l.begin_year if begin_year==. & l.begin_year!=.
forvalues i = 1/100 {
by L1ID: replace end_year=f.end_year if end_year==. & f.begin_year!=.
}
drop begin end

*Compare Begin and End Year
gen test_begin_year = begin_year - FirstIssueDateYear if publicholdings!=.
gen test_end_year = end_year - PayableDateYear if publicholdings!=.
order test_begin_year test_end_year, b( begin_year )
/*
cd ../Output
preserve
keep if test_begin_year==. & test_end_year==.
drop if year<1942
drop if publicholdings==.
drop if publicholdings==0
drop if publicholdings>-50000 & publicholdings<50000
save MissingDates.dta, replace
*Check Unclassified Sales Only
restore
cd ../Data
*/

*Drop if FirstIssueDateYear AND PayableDateYear missing
drop if test_begin_year==. & test_end_year==.

*Some typos
drop if FirstIssueDateYear==1995
**Obviously a typo

*Adjust FirstIssueDateYear if unavailable
replace FirstIssueDateYear=begin_year if FirstIssueDateYear==.

*Consistency checks
/*
cd ../Output
preserve
gen test=1 if PayableDateYear<year
keep if test==1
save ConsistencyChecks.dta, replace
*Check Nothing left
restore
cd ../Data
*/

*Generate InitialMaturity and CurrentMaturity
gen InitialMaturity = PayableDateYear - FirstIssueDateYear
order InitialMaturity , b( publicholdings )
gen CurrentMaturity = PayableDateYear - year
order CurrentMaturity , b( publicholdings )

*Clean Data
drop if publicholdings==.
drop if publicholdings==0
drop if year<1942
sort L1ID year

*Additional Checks
/*
cd ../Output
preserve
keep if FirstIssueDateYear>1960 | InitialMaturity<0 | CurrentMaturity > InitialMaturity
save AdditionalChecks.dta, replace
*Check Nothing left
restore
cd ../Data
*/
drop if FirstIssueDateYear>1960
drop if InitialMaturity<0
drop if CurrentMaturity > InitialMaturity

*Last Checks
/*
cd ../Output
preserve
keep if CategoryL3=="Special Issues" | ActiveOutstanding==. | CurrentMaturity<-0.1
save LastChecks.dta, replace
*Check Drops
restore
cd ../Data
*/
keep if CategoryL1=="Interest Bearing"
drop if CategoryL3=="Special Issues"
drop if ActiveOutstanding==.
drop if CurrentMaturity<-0.1

*Save Database
replace CouponRate = CouponRateBis if CouponRate==.
save Database_JA.dta, replace
erase BondQuantList_JA.dta
clear all

/*
order year, a(L1ID)
keep L1ID year InitialMaturity CurrentMaturity publicholdings begin_year end_year FirstIssueDateYear PayableDateYear CategoryL1 CategoryL2 CategoryL3 TreasurysNameOfIssue TermOfLoan FirstIssueDate RedeemableAfterDate PayableDate CouponRate FirstIssueDate2 PayableDate2
save Data_JA.dta, replace
clear all
*/

********************************************************************************
** Build Output **
********************************************************************************

*ALL
use Database_JA.dta
cd ../Output

*Generate SumPublicHoldings  
egen sumpublicholdings_y = sum( publicholdings ), by (year)
order sumpublicholdings_y , b( publicholdings )
egen sumpublicholdings_y_by = sum( publicholdings ), by (year FirstIssueDateYear )
order sumpublicholdings_y_by , b( publicholdings )
egen sumpublicholdings_by_m = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity)
order sumpublicholdings_by_m , b( publicholdings )
egen sumpublicholdings_by_m_cr = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity CouponRate)
order sumpublicholdings_by_m_cr , b( publicholdings )

*Table 1
preserve
keep year sumpublicholdings_y 
sort year
rename year Year
duplicates drop
export excel using "Output_MSPD_ALL", sheet("Table1") sheetreplace firstrow(variables)
restore

*Table 2
preserve
keep year sumpublicholdings_y_by FirstIssueDateYear
duplicates drop
reshape wide sumpublicholdings_y_by , i(FirstIssueDateYear) j(year)
rename sumpublicholdings_y_by* end*
rename FirstIssueDateYear  issue_year
sort issue_year
*save "Table 2.dta", replace
export excel using "Output_MSPD_ALL", sheet("Table2") sheetreplace firstrow(variables)
restore

*Table 3
preserve
keep sumpublicholdings_by_m year FirstIssueDateYear InitialMaturity CurrentMaturity
duplicates drop
order FirstIssueDateYear, a(year)
sort year FirstIssueDateYear InitialMaturity
gen year_begin_year = year if year==FirstIssueDateYear
*Sum bonds issued in that year
egen sumpublicholdings_y_by = sum( sumpublicholdings_by_m ) if year_begin_year!=. , by ( year_begin_year )
*Share bonds with maturity m issued in that year
gen shsumpublicholdings_y_by = sumpublicholdings_by_m / sumpublicholdings_y_by * InitialMaturity if year_begin_year!=.
egen maturityatbegin = sum( shsumpublicholdings_y_by ) if year_begin_year!=. , by ( year_begin_year )
drop shsumpublicholdings_y_by
sort year FirstIssueDateYear InitialMaturity
*keep if CurrentMaturity>-0.1
egen sumpublicholdings_y = sum( sumpublicholdings_by_m ), by ( year )
gen shsumpublicholdings_y = sumpublicholdings_by_m / sumpublicholdings_y * CurrentMaturity
egen currentmaturity = sum( shsumpublicholdings_y ) , by ( year )
drop shsumpublicholdings_y
keep if year_begin_year!=.
keep year maturityatbegin currentmaturity
duplicates drop
*save "Table 3.dta", replace
export excel using "Output_MSPD_ALL", sheet("Table3") sheetreplace firstrow(variables)
restore

*Table 4
preserve
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m CurrentMaturity
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity
order IssuedIn, a(Year) 
*save "Table 4.dta", replace
export excel using "Output_MSPD_ALL", sheet("Table4") sheetreplace firstrow(variables)
restore

*Table 5
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m_cr CurrentMaturity CouponRate
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m_cr PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity CouponRate
order IssuedIn, a(Year) 
egen sumpublicholdings_y_by = sum( PublicHoldings ), by (Year IssuedIn)
*Weight gives the share of a given InitialMaturity for a given Year-IssuedIn pair
gen weight = PublicHoldings / sumpublicholdings_y_by

*Adjusting Rates
egen avcoupon_by_im = mean(CouponRate), by (IssuedIn InitialMaturity)
replace CouponRate=avcoupon_by_im if CouponRate==.

*Adjusting Rates
replace CouponRate=0.8 if InitialMaturity<2  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.2 if InitialMaturity>1  & InitialMaturity<5  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.5 if InitialMaturity>4  & InitialMaturity<10 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.0 if InitialMaturity>9  & InitialMaturity<20 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.5 if InitialMaturity>19 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)

*replace CouponRate=2.0 if InitialMaturity>9 & CouponRate==.
*replace CouponRate=1.0 if InitialMaturity<4 & CouponRate==.

preserve
keep IssuedIn InitialMaturity avcoupon_by_im
duplicates drop 
reshape wide avcoupon_by_im , i(IssuedIn) j(InitialMaturity)
rename avcoupon_by_im* IM*
rename IssuedIn issue_year
sort issue_year
*save "Table 5.dta", replace
export excel using "Output_MSPD_ALL", sheet("Table5") sheetreplace firstrow(variables)
restore

gen weightCouponRate = weight * CouponRate
*gen weightCouponRateBis = weight * CouponRateBis

*save "Table 6.dta", replace
export excel using "Output_MSPD_ALL", sheet("Table6") sheetreplace firstrow(variables)
egen AverageRate = sum(weightCouponRate), by(Year IssuedIn)
*egen AverageRateBis = sum(weightCouponRateBis), by(Year IssuedIn)
keep Year IssuedIn AverageRate
duplicates drop

*Table 7
preserve
reshape wide AverageRate , i(IssuedIn) j(Year)
rename AverageRate* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 7.dta", replace
export excel using "Output_MSPD_ALL", sheet("Table7") sheetreplace firstrow(variables)
restore

/*
preserve
drop AverageRate
reshape wide AverageRateBis , i(IssuedIn) j(Year)
rename AverageRateBis* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 6 bis.dta", replace
export excel using "Output_MSPD", sheet("Table6bis") sheetreplace firstrow(variables)
restore
*/
clear all 

*Table 8
cd ../Data
use Database_JA.dta
cd ../Output
xtset L1ID year
sort L1ID year
drop if CouponRate==.
gen C = CouponRate/100 * l.publicholdings
egen sumC = sum(C), by(year)
egen sumpublicholdings_y = sum( publicholdings ), by (year)
keep sumC sumpublicholdings_y year
duplicates drop
tsset year
gen c = sumC / l.sumpublicholdings_y 
export excel using "Output_MSPD_ALL", sheet("Table8") sheetreplace firstrow(variables)

clear all

********************************************************************************

*MARKETABLE
cd ../Data
use Database_JA.dta
keep if CategoryL2=="Marketable"
cd ../Output

*Generate SumPublicHoldings  
egen sumpublicholdings_y = sum( publicholdings ), by (year)
order sumpublicholdings_y , b( publicholdings )
egen sumpublicholdings_y_by = sum( publicholdings ), by (year FirstIssueDateYear )
order sumpublicholdings_y_by , b( publicholdings )
egen sumpublicholdings_by_m = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity)
order sumpublicholdings_by_m , b( publicholdings )
egen sumpublicholdings_by_m_cr = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity CouponRate)
order sumpublicholdings_by_m_cr , b( publicholdings )

*Table 1
preserve
keep year sumpublicholdings_y 
sort year
rename year Year
duplicates drop
export excel using "Output_MSPD_MARKETABLE", sheet("Table1") sheetreplace firstrow(variables)
restore

*Table 2
preserve
keep year sumpublicholdings_y_by FirstIssueDateYear
duplicates drop
reshape wide sumpublicholdings_y_by , i(FirstIssueDateYear) j(year)
rename sumpublicholdings_y_by* end*
rename FirstIssueDateYear  issue_year
sort issue_year
*save "Table 2.dta", replace
export excel using "Output_MSPD_MARKETABLE", sheet("Table2") sheetreplace firstrow(variables)
restore

*Table 3
preserve
keep sumpublicholdings_by_m year FirstIssueDateYear InitialMaturity CurrentMaturity
duplicates drop
order FirstIssueDateYear, a(year)
sort year FirstIssueDateYear InitialMaturity
gen year_begin_year = year if year==FirstIssueDateYear
*Sum bonds issued in that year
egen sumpublicholdings_y_by = sum( sumpublicholdings_by_m ) if year_begin_year!=. , by ( year_begin_year )
*Share bonds with maturity m issued in that year
gen shsumpublicholdings_y_by = sumpublicholdings_by_m / sumpublicholdings_y_by * InitialMaturity if year_begin_year!=.
egen maturityatbegin = sum( shsumpublicholdings_y_by ) if year_begin_year!=. , by ( year_begin_year )
drop shsumpublicholdings_y_by
sort year FirstIssueDateYear InitialMaturity
*keep if CurrentMaturity>-0.1
egen sumpublicholdings_y = sum( sumpublicholdings_by_m ), by ( year )
gen shsumpublicholdings_y = sumpublicholdings_by_m / sumpublicholdings_y * CurrentMaturity
egen currentmaturity = sum( shsumpublicholdings_y ) , by ( year )
drop shsumpublicholdings_y
keep if year_begin_year!=.
keep year maturityatbegin currentmaturity
duplicates drop
*save "Table 3.dta", replace
export excel using "Output_MSPD_MARKETABLE", sheet("Table3") sheetreplace firstrow(variables)
restore

*Table 4
preserve
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m CurrentMaturity
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity
order IssuedIn, a(Year) 
*save "Table 4.dta", replace
export excel using "Output_MSPD_MARKETABLE", sheet("Table4") sheetreplace firstrow(variables)
restore

*Table 5
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m_cr CurrentMaturity CouponRate
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m_cr PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity CouponRate
order IssuedIn, a(Year) 
egen sumpublicholdings_y_by = sum( PublicHoldings ), by (Year IssuedIn)
*Weight gives the share of a given InitialMaturity for a given Year-IssuedIn pair
gen weight = PublicHoldings / sumpublicholdings_y_by

*Adjusting Rates
egen avcoupon_by_im = mean(CouponRate), by (IssuedIn InitialMaturity)
replace CouponRate=avcoupon_by_im if CouponRate==.

*Adjusting Rates
replace CouponRate=0.8 if InitialMaturity<2  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.2 if InitialMaturity>1  & InitialMaturity<5  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.5 if InitialMaturity>4  & InitialMaturity<10 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.0 if InitialMaturity>9  & InitialMaturity<20 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.5 if InitialMaturity>19 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)

*replace CouponRate=2.0 if InitialMaturity>9 & CouponRate==.
*replace CouponRate=1.0 if InitialMaturity<4 & CouponRate==.

preserve
keep IssuedIn InitialMaturity avcoupon_by_im
duplicates drop 
reshape wide avcoupon_by_im , i(IssuedIn) j(InitialMaturity)
rename avcoupon_by_im* IM*
rename IssuedIn issue_year
sort issue_year
*save "Table 5.dta", replace
export excel using "Output_MSPD_MARKETABLE", sheet("Table5") sheetreplace firstrow(variables)
restore

gen weightCouponRate = weight * CouponRate
*gen weightCouponRateBis = weight * CouponRateBis

*save "Table 6.dta", replace
export excel using "Output_MSPD_MARKETABLE", sheet("Table6") sheetreplace firstrow(variables)
egen AverageRate = sum(weightCouponRate), by(Year IssuedIn)
*egen AverageRateBis = sum(weightCouponRateBis), by(Year IssuedIn)
keep Year IssuedIn AverageRate
duplicates drop

*Table 7
preserve
reshape wide AverageRate , i(IssuedIn) j(Year)
rename AverageRate* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 7.dta", replace
export excel using "Output_MSPD_MARKETABLE", sheet("Table7") sheetreplace firstrow(variables)
restore

/*
preserve
drop AverageRate
reshape wide AverageRateBis , i(IssuedIn) j(Year)
rename AverageRateBis* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 6 bis.dta", replace
export excel using "Output_MSPD", sheet("Table6bis") sheetreplace firstrow(variables)
restore
*/
clear all 

********************************************************************************

*NON-MARKETABLE
cd ../Data
use Database_JA.dta
keep if CategoryL2!="Marketable"
cd ../Output

*Generate SumPublicHoldings  
egen sumpublicholdings_y = sum( publicholdings ), by (year)
order sumpublicholdings_y , b( publicholdings )
egen sumpublicholdings_y_by = sum( publicholdings ), by (year FirstIssueDateYear )
order sumpublicholdings_y_by , b( publicholdings )
egen sumpublicholdings_by_m = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity)
order sumpublicholdings_by_m , b( publicholdings )
egen sumpublicholdings_by_m_cr = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity CouponRate)
order sumpublicholdings_by_m_cr , b( publicholdings )

*Table 1
preserve
keep year sumpublicholdings_y 
sort year
rename year Year
duplicates drop
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table1") sheetreplace firstrow(variables)
restore

*Table 2
preserve
keep year sumpublicholdings_y_by FirstIssueDateYear
duplicates drop
reshape wide sumpublicholdings_y_by , i(FirstIssueDateYear) j(year)
rename sumpublicholdings_y_by* end*
rename FirstIssueDateYear  issue_year
sort issue_year
*save "Table 2.dta", replace
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table2") sheetreplace firstrow(variables)
restore

*Table 3
preserve
keep sumpublicholdings_by_m year FirstIssueDateYear InitialMaturity CurrentMaturity
duplicates drop
order FirstIssueDateYear, a(year)
sort year FirstIssueDateYear InitialMaturity
gen year_begin_year = year if year==FirstIssueDateYear
*Sum bonds issued in that year
egen sumpublicholdings_y_by = sum( sumpublicholdings_by_m ) if year_begin_year!=. , by ( year_begin_year )
*Share bonds with maturity m issued in that year
gen shsumpublicholdings_y_by = sumpublicholdings_by_m / sumpublicholdings_y_by * InitialMaturity if year_begin_year!=.
egen maturityatbegin = sum( shsumpublicholdings_y_by ) if year_begin_year!=. , by ( year_begin_year )
drop shsumpublicholdings_y_by
sort year FirstIssueDateYear InitialMaturity
*keep if CurrentMaturity>-0.1
egen sumpublicholdings_y = sum( sumpublicholdings_by_m ), by ( year )
gen shsumpublicholdings_y = sumpublicholdings_by_m / sumpublicholdings_y * CurrentMaturity
egen currentmaturity = sum( shsumpublicholdings_y ) , by ( year )
drop shsumpublicholdings_y
keep if year_begin_year!=.
keep year maturityatbegin currentmaturity
duplicates drop
*save "Table 3.dta", replace
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table3") sheetreplace firstrow(variables)
restore

*Table 4
preserve
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m CurrentMaturity
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity
order IssuedIn, a(Year) 
*save "Table 4.dta", replace
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table4") sheetreplace firstrow(variables)
restore

*Table 5
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m_cr CurrentMaturity CouponRate
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m_cr PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity CouponRate
order IssuedIn, a(Year) 
egen sumpublicholdings_y_by = sum( PublicHoldings ), by (Year IssuedIn)
*Weight gives the share of a given InitialMaturity for a given Year-IssuedIn pair
gen weight = PublicHoldings / sumpublicholdings_y_by

*Adjusting Rates
egen avcoupon_by_im = mean(CouponRate), by (IssuedIn InitialMaturity)
replace CouponRate=avcoupon_by_im if CouponRate==.

*Adjusting Rates
replace CouponRate=0.8 if InitialMaturity<2  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.2 if InitialMaturity>1  & InitialMaturity<5  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.5 if InitialMaturity>4  & InitialMaturity<10 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.0 if InitialMaturity>9  & InitialMaturity<20 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.5 if InitialMaturity>19 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)

*replace CouponRate=2.0 if InitialMaturity>9 & CouponRate==.
*replace CouponRate=1.0 if InitialMaturity<4 & CouponRate==.

preserve
keep IssuedIn InitialMaturity avcoupon_by_im
duplicates drop 
reshape wide avcoupon_by_im , i(IssuedIn) j(InitialMaturity)
rename avcoupon_by_im* IM*
rename IssuedIn issue_year
sort issue_year
*save "Table 5.dta", replace
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table5") sheetreplace firstrow(variables)
restore

gen weightCouponRate = weight * CouponRate
*gen weightCouponRateBis = weight * CouponRateBis

*save "Table 6.dta", replace
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table6") sheetreplace firstrow(variables)
egen AverageRate = sum(weightCouponRate), by(Year IssuedIn)
*egen AverageRateBis = sum(weightCouponRateBis), by(Year IssuedIn)
keep Year IssuedIn AverageRate
duplicates drop

*Table 7
preserve
reshape wide AverageRate , i(IssuedIn) j(Year)
rename AverageRate* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 7.dta", replace
export excel using "Output_MSPD_NONMARKETABLE", sheet("Table7") sheetreplace firstrow(variables)
restore

/*
preserve
drop AverageRate
reshape wide AverageRateBis , i(IssuedIn) j(Year)
rename AverageRateBis* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 6 bis.dta", replace
export excel using "Output_MSPD", sheet("Table6bis") sheetreplace firstrow(variables)
restore
*/
clear all 

********************************************************************************

*ALL EXCLUDING TREASURY BILLS
cd ../Data
use Database_JA.dta
drop if CategoryL3=="Treasury Bill"
cd ../Output

*Generate SumPublicHoldings  
egen sumpublicholdings_y = sum( publicholdings ), by (year)
order sumpublicholdings_y , b( publicholdings )
egen sumpublicholdings_y_by = sum( publicholdings ), by (year FirstIssueDateYear )
order sumpublicholdings_y_by , b( publicholdings )
egen sumpublicholdings_by_m = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity)
order sumpublicholdings_by_m , b( publicholdings )
egen sumpublicholdings_by_m_cr = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity CouponRate)
order sumpublicholdings_by_m_cr , b( publicholdings )

*Table 1
preserve
keep year sumpublicholdings_y 
sort year
rename year Year
duplicates drop
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table1") sheetreplace firstrow(variables)
restore

*Table 2
preserve
keep year sumpublicholdings_y_by FirstIssueDateYear
duplicates drop
reshape wide sumpublicholdings_y_by , i(FirstIssueDateYear) j(year)
rename sumpublicholdings_y_by* end*
rename FirstIssueDateYear  issue_year
sort issue_year
*save "Table 2.dta", replace
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table2") sheetreplace firstrow(variables)
restore

*Table 3
preserve
keep sumpublicholdings_by_m year FirstIssueDateYear InitialMaturity CurrentMaturity
duplicates drop
order FirstIssueDateYear, a(year)
sort year FirstIssueDateYear InitialMaturity
gen year_begin_year = year if year==FirstIssueDateYear
*Sum bonds issued in that year
egen sumpublicholdings_y_by = sum( sumpublicholdings_by_m ) if year_begin_year!=. , by ( year_begin_year )
*Share bonds with maturity m issued in that year
gen shsumpublicholdings_y_by = sumpublicholdings_by_m / sumpublicholdings_y_by * InitialMaturity if year_begin_year!=.
egen maturityatbegin = sum( shsumpublicholdings_y_by ) if year_begin_year!=. , by ( year_begin_year )
drop shsumpublicholdings_y_by
sort year FirstIssueDateYear InitialMaturity
*keep if CurrentMaturity>-0.1
egen sumpublicholdings_y = sum( sumpublicholdings_by_m ), by ( year )
gen shsumpublicholdings_y = sumpublicholdings_by_m / sumpublicholdings_y * CurrentMaturity
egen currentmaturity = sum( shsumpublicholdings_y ) , by ( year )
drop shsumpublicholdings_y
keep if year_begin_year!=.
keep year maturityatbegin currentmaturity
duplicates drop
*save "Table 3.dta", replace
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table3") sheetreplace firstrow(variables)
restore

*Table 4
preserve
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m CurrentMaturity
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity
order IssuedIn, a(Year) 
*save "Table 4.dta", replace
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table4") sheetreplace firstrow(variables)
restore

*Table 5
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m_cr CurrentMaturity CouponRate
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m_cr PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity CouponRate
order IssuedIn, a(Year) 
egen sumpublicholdings_y_by = sum( PublicHoldings ), by (Year IssuedIn)
*Weight gives the share of a given InitialMaturity for a given Year-IssuedIn pair
gen weight = PublicHoldings / sumpublicholdings_y_by

*Adjusting Rates
egen avcoupon_by_im = mean(CouponRate), by (IssuedIn InitialMaturity)
replace CouponRate=avcoupon_by_im if CouponRate==.

*Adjusting Rates
replace CouponRate=0.8 if InitialMaturity<2  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.2 if InitialMaturity>1  & InitialMaturity<5  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.5 if InitialMaturity>4  & InitialMaturity<10 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.0 if InitialMaturity>9  & InitialMaturity<20 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.5 if InitialMaturity>19 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)

*replace CouponRate=2.0 if InitialMaturity>9 & CouponRate==.
*replace CouponRate=1.0 if InitialMaturity<4 & CouponRate==.

preserve
keep IssuedIn InitialMaturity avcoupon_by_im
duplicates drop 
reshape wide avcoupon_by_im , i(IssuedIn) j(InitialMaturity)
rename avcoupon_by_im* IM*
rename IssuedIn issue_year
sort issue_year
*save "Table 5.dta", replace
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table5") sheetreplace firstrow(variables)
restore

gen weightCouponRate = weight * CouponRate
*gen weightCouponRateBis = weight * CouponRateBis

*save "Table 6.dta", replace
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table6") sheetreplace firstrow(variables)
egen AverageRate = sum(weightCouponRate), by(Year IssuedIn)
*egen AverageRateBis = sum(weightCouponRateBis), by(Year IssuedIn)
keep Year IssuedIn AverageRate
duplicates drop

*Table 7
preserve
reshape wide AverageRate , i(IssuedIn) j(Year)
rename AverageRate* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 7.dta", replace
export excel using "Output_MSPD_ALLEXCLTBILLS", sheet("Table7") sheetreplace firstrow(variables)
restore

/*
preserve
drop AverageRate
reshape wide AverageRateBis , i(IssuedIn) j(Year)
rename AverageRateBis* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 6 bis.dta", replace
export excel using "Output_MSPD", sheet("Table6bis") sheetreplace firstrow(variables)
restore
*/
clear all 

********************************************************************************

*CRSP
cd ../Data
use Database_JA.dta
keep if CategoryL2=="Marketable"
drop if CategoryL3=="Treasury Bill"
cd ../Output

*Generate SumPublicHoldings  
egen sumpublicholdings_y = sum( publicholdings ), by (year)
order sumpublicholdings_y , b( publicholdings )
egen sumpublicholdings_y_by = sum( publicholdings ), by (year FirstIssueDateYear )
order sumpublicholdings_y_by , b( publicholdings )
egen sumpublicholdings_by_m = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity)
order sumpublicholdings_by_m , b( publicholdings )
egen sumpublicholdings_by_m_cr = sum( publicholdings ), by (year FirstIssueDateYear InitialMaturity CouponRate)
order sumpublicholdings_by_m_cr , b( publicholdings )

*Table 1
preserve
keep year sumpublicholdings_y 
sort year
rename year Year
duplicates drop
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table1") sheetreplace firstrow(variables)
restore

*Table 2
preserve
keep year sumpublicholdings_y_by FirstIssueDateYear
duplicates drop
reshape wide sumpublicholdings_y_by , i(FirstIssueDateYear) j(year)
rename sumpublicholdings_y_by* end*
rename FirstIssueDateYear  issue_year
sort issue_year
*save "Table 2.dta", replace
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table2") sheetreplace firstrow(variables)
restore

*Table 3
preserve
keep sumpublicholdings_by_m year FirstIssueDateYear InitialMaturity CurrentMaturity
duplicates drop
order FirstIssueDateYear, a(year)
sort year FirstIssueDateYear InitialMaturity
gen year_begin_year = year if year==FirstIssueDateYear
*Sum bonds issued in that year
egen sumpublicholdings_y_by = sum( sumpublicholdings_by_m ) if year_begin_year!=. , by ( year_begin_year )
*Share bonds with maturity m issued in that year
gen shsumpublicholdings_y_by = sumpublicholdings_by_m / sumpublicholdings_y_by * InitialMaturity if year_begin_year!=.
egen maturityatbegin = sum( shsumpublicholdings_y_by ) if year_begin_year!=. , by ( year_begin_year )
drop shsumpublicholdings_y_by
sort year FirstIssueDateYear InitialMaturity
*keep if CurrentMaturity>-0.1
egen sumpublicholdings_y = sum( sumpublicholdings_by_m ), by ( year )
gen shsumpublicholdings_y = sumpublicholdings_by_m / sumpublicholdings_y * CurrentMaturity
egen currentmaturity = sum( shsumpublicholdings_y ) , by ( year )
drop shsumpublicholdings_y
keep if year_begin_year!=.
keep year maturityatbegin currentmaturity
duplicates drop
*save "Table 3.dta", replace
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table3") sheetreplace firstrow(variables)
restore

*Table 4
preserve
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m CurrentMaturity
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity
order IssuedIn, a(Year) 
*save "Table 4.dta", replace
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table4") sheetreplace firstrow(variables)
restore

*Table 5
*keep if FirstIssueDateYear<1952
keep year FirstIssueDateYear InitialMaturity sumpublicholdings_by_m_cr CurrentMaturity CouponRate
rename FirstIssueDateYear IssuedIn
rename year Year
rename sumpublicholdings_by_m_cr PublicHoldings
duplicates drop
sort Year IssuedIn InitialMaturity CouponRate
order IssuedIn, a(Year) 
egen sumpublicholdings_y_by = sum( PublicHoldings ), by (Year IssuedIn)
*Weight gives the share of a given InitialMaturity for a given Year-IssuedIn pair
gen weight = PublicHoldings / sumpublicholdings_y_by

*Adjusting Rates
egen avcoupon_by_im = mean(CouponRate), by (IssuedIn InitialMaturity)
replace CouponRate=avcoupon_by_im if CouponRate==.

*Adjusting Rates
replace CouponRate=0.8 if InitialMaturity<2  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.2 if InitialMaturity>1  & InitialMaturity<5  & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=1.5 if InitialMaturity>4  & InitialMaturity<10 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.0 if InitialMaturity>9  & InitialMaturity<20 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)
replace CouponRate=2.5 if InitialMaturity>19 & CouponRate==. &(IssuedIn>1941 & IssuedIn<1952)

*replace CouponRate=2.0 if InitialMaturity>9 & CouponRate==.
*replace CouponRate=1.0 if InitialMaturity<4 & CouponRate==.

preserve
keep IssuedIn InitialMaturity avcoupon_by_im
duplicates drop 
reshape wide avcoupon_by_im , i(IssuedIn) j(InitialMaturity)
rename avcoupon_by_im* IM*
rename IssuedIn issue_year
sort issue_year
*save "Table 5.dta", replace
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table5") sheetreplace firstrow(variables)
restore

gen weightCouponRate = weight * CouponRate
*gen weightCouponRateBis = weight * CouponRateBis

*save "Table 6.dta", replace
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table6") sheetreplace firstrow(variables)
egen AverageRate = sum(weightCouponRate), by(Year IssuedIn)
*egen AverageRateBis = sum(weightCouponRateBis), by(Year IssuedIn)
keep Year IssuedIn AverageRate
duplicates drop

*Table 7
preserve
reshape wide AverageRate , i(IssuedIn) j(Year)
rename AverageRate* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 7.dta", replace
export excel using "Output_MSPD_MARKETABLEEXCLTBILLS", sheet("Table7") sheetreplace firstrow(variables)
restore

/*
preserve
drop AverageRate
reshape wide AverageRateBis , i(IssuedIn) j(Year)
rename AverageRateBis* end*
rename IssuedIn issue_year
sort issue_year
*save "Table 6 bis.dta", replace
export excel using "Output_MSPD", sheet("Table6bis") sheetreplace firstrow(variables)
restore
*/
clear all 
