* this program uses analyze_data/annual_data.dta
* it outputs fig_box_annual.eps

*the working directory needs to be the folder where this code is
*cd C:\Users\dvorakt\Documents\research\TIER\debt_growth_TIER\command_files

use ../analysis_data/annual_data, clear
*********************************************************
*create descriptive statistics table
estpost sum  gdpgrowth debttogdp gdppc ,detail

esttab using "../documents/tables_figures/tab_descriptive_stats.tex",  replace ///
	label title(Summary Statistics) ///
	cells("count(fmt(%9.0gc)) mean(fmt(%9.1fc)) p50(fmt(%9.1fc)) sd(fmt(%9.1fc)) min(fmt(%9.0fc)) max(fmt(%9.0fc))") ///
	noobs nomtitle nonum

**********************************************************
*create table with mean and median growth by debt category
estpost sum gdpgrowth debttogdp if debt_cat=="0-30%", detail
est store cat1
estpost sum gdpgrowth debttogdp if debt_cat=="30-60%", detail
est store cat2
estpost sum gdpgrowth debttogdp if debt_cat=="60-90%", detail
est store cat3
estpost sum gdpgrowth debttogdp if debt_cat=="Above 90%", detail
est store cat4

esttab cat1 cat2 cat3 cat4 using "../documents/tables_figures/tab_growth_by_debt.tex", replace ///
	label title(GDP Growth by Debt to GDP Category) ///
	mtitle("0-30\%" "30-60\%" "60-90\%" "Above 90\%") ///
	cells(mean(fmt(2) label("Mean")) p50(fmt(2) label("Med"))) ///
	nonum  
	
************************************************************
*create figure with box plot of GDP growth by debt category	
set scheme s1mono
graph box gdpgrowth , over(debt_cat) medline(lcolor(black)) intensity(0) ///
	marker(1,msize(vsmall)) ///
	ytitle("Real GDP Growth (in %)") ///
	/*title("Contemporaneous relationship between debt and growth")*/ ///
	plotregion(style(none)) 
graph export ../documents/tables_figures/fig_box_annual.eps ,replace



