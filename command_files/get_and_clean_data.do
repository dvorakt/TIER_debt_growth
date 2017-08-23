*this program gets two sources of data from original_data folder
*it outputs annual_data.dat into analysis_data folder

*the working directory needs to be the folder where this code is
*cd C:\Users\dvorakt\Documents\research\TIER\debt_growth_TIER\command_files

**************************************************
*retrieve data from WDI database
*wbopendata, indicator(NY.GDP.MKTP.KD.ZG ; GC.DOD.TOTL.GD.ZS; NY.GDP.PCAP.KD; SP.POP.TOTL) clear long 
*save retrieved data (preserves the data as of the date of retrieval)
*save original_data/wdidata08102017, replace
*the two commands above can be commented out after the data is retrieved
use ../original_data/wdidata08102017, clear
*drop "aggregates" (e.g. Europe), keep only countries
drop if region=="Aggregates" | region==""
*public debt data is sparse before 1990 so keep only data after 1990
*keep if year>=1990
*give the variables more recognizable names.
rename gc_dod_totl_gd_zs debttogdp_WDI
rename ny_gdp_mktp_kd_zg gdpgrowth
rename ny_gdp_pcap_kd gdppc
rename countryname country
drop iso2code region
save ../analysis_data/wdi, replace

******************************************************
*get historical IMF data on debt to GDP ratio
*http://www.imf.org/~/media/Websites/IMF/imported-datasets/external/pubs/ft/wp/2010/Data/_wp10245.ashx
import excel using "../original_data/Debt Database Fall 2013 Vintage.xlsx" ,sheet("Public debt (in percent of GDP)") firstrow allstring clear
drop B ifscode //don't need
drop LM-ACF    //blank columns
drop if country=="" //blank rows
*create variable names that have year in it (make var label var name)
*needs labutil2 package install "ssc install labutil2"
lab2varn  D-LL  //stitches variable label into variable name
*reshape the data from wide to long
reshape long _ , i(country) j(year) 
drop if year<1960 //WDI starts in 1960
destring _ , generate(debttogdp_IMF) force
drop _
*some of the country names have trailing blanks
replace country=trim(country)
*some of the names in the IMF data do not match names used in WDI
*I switch IMF names to match WDI names
replace country="Azerbaijan" if country=="Azerbaijan, Rep. of"
replace country="Bosnia and Herzegovina" if country=="Bosnia & Herzegovina"
replace country="Central African Republic" if country=="Central African Rep."
replace country="Iran, Islamic Rep." if country=="Iran, I.R. of"
replace country="Korea, Rep." if country=="Korea, Republic of"
replace country="Hong Kong SAR, China" if country=="China,P.R.: Hong Kong"
replace country="China" if country=="China,P.R.: Mainland"
replace country="Congo, Dem. Rep." if country=="Congo, Dem. Rep. of"
replace country="Congo, Rep." if country=="Congo, Republic of"
replace country="Cote d'Ivoire" if country=="Côte d'Ivoire"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Lao PDR" if country=="Lao People's Dem.Rep"
replace country="Philippines" if country=="Phillipines"
replace country="Trinidad and Tobago" if country=="Trinidad & Tobago"
replace country="Venezuela, RB" if country=="Venezuela, Rep. Bol."
replace country="Yemen, Rep." if country=="Yemen, Republic of"
save ../analysis_data/debttogdpIMF , replace

****************************************************
*merge WDI data and IMF data
merge 1:1 country year using ../analysis_data/wdi
*for some years (mostly after 1990) we have two sources of debt to GDP data
*I give preference to IMF except when IMF is missing and WDI is not
g debttogdp=debttogdp_IMF
replace debttogdp=debttogdp_WDI if debttogdp==. & debttogdp_WDI~=.
drop debttogdp_WDI debttogdp_IMF _merge
sort country year
*graph twoway scatter debttogdp_IMF debttogdp

****************************************************
*clean data
*drop countries that at any point had fewer than 500K people
*find the minimum population for each country
egen popmin=min(sp_pop_totl), by(countrycode)
drop if popmin<500000
drop popmin sp_pop_totl

*drop countries that have no debttogdp or gdpgrowth observations
egen no_debttogdp=count(debttogdp) ,by(country)
egen no_gdpgrowth=count(gdpgrowth) ,by(country)
drop if no_debttogdp==0 | no_gdpgrowth==0
*drop observations where we have both debt and growth missing
drop if debttogdp==. & gdpgrowth==.
drop no_debttogdp no_gdpgrowth

*give variables nice var labels
label var debttogdp "Debt to GDP (in \%)"
label var gdpgrowth "GDP growth (in \%)"
label var gdppc "GDP per cap (2010 USD)"

*create a debt_category variable that would put levels of debt in different buckets
g str15 debt_cat="0-30%" if debttogdp<=30
replace debt_cat="30-60%" if debttogdp>30 & debttogdp<=60
replace debt_cat="60-90%" if debttogdp>60 & debttogdp<=90
replace debt_cat="Above 90%" if debttogdp>90 & debttogdp~=.

*a quick look at summary stats
sum gdpgrowth debttogdp gdppc
table country ,contents(freq mean gdpgrowth mean debttogdp min year max year)

save ../analysis_data/annual_data , replace

