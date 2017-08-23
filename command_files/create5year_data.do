* this program uses analyze_data/annual_data.dta
* it outputs analyze_data/five_year_data.dta

use ../analysis_data/annual_data, clear

*********************************************************
*create five-year periods for each country
*find when the country enters the data set 
egen minyear=min(year), by(countrycode)
*create a number for each five year period (0 for first five-year period, 1 for the second five-year period etc.)
g fiveyearid = floor((year-minyear)/5)
*create a number (0,1,2,4 or 5)for each year in each five-year period 
g year_in_five = year-minyear-fiveyearid*5 
save ../analysis_data/temp, replace


*let's now split the dataset into two: one that has the first year for every country
*and every five year period; and one that has the average GDP growth for the
*subsequent four years for every country and every five-year period
*then we merge the data sets back together.
*keep only the first years in each five year period
keep if year_in_five==0 
keep country debttogdp gdppc debt_cat fiveyearid
save ../analysis_data/first_years, replace

use ../analysis_data/temp
*keep only the subsequent years
drop if year_in_five==0 
keep country gdpgrowth fiveyearid
*average across the four subsequent years
collapse (mean) gdpgrowth (count) n=gdpgrowth, by(country fiveyearid)
*merge back the inital debt
merge 1:1 country fiveyearid using ../analysis_data/first_years 
*some observations will not match because may have first year without any subsequent years 
*or since there are gaps in the data, we could have subsequent without initial
drop if _merge~=3
*also drop observations with fewer than two subsequent periods 
drop if n<3

drop _merge n 
save ../analysis_data/five_year_data ,replace
