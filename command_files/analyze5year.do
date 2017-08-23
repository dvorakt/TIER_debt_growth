*this program uses ../analyze_data/five_year_data
*it outputs figure 2 and table 3

use ../analysis_data/five_year_data, clear

*create box plot of initial debt level on subsequent growth
graph box gdpgrowth ,over(debt_cat) medline(lcolor(black)) intensity(0) ///
	marker(1,msize(vsmall)) ///
	ytitle("Average real GDP growth over next four years") ///
	plotregion(style(none)) 
graph export ../documents/tables_figures/fig_box_5year.eps ,replace
	
*create log of gdppc
g loggdppc=ln(gdppc)
label var loggdppc "Log of GDP per capita"
*create descriptive statistics table
tabstat gdpgrowth debttogdp gdppc ,statistics(mean median sd min max) columns(statistics) format(%9.1f)

*I need to change the variable label because outreg automatically puts a "\" in front of %
label var debttogdp "Debt to GDP (in %)"
*average growth needs variable label
label var gdpgrowth "GDP Growth"
*outreg2 does not like directory hierarchy so I do it here
cd ../documents/tables_figures
reg gdpgrowth debttogdp
outreg2 m1 using tab_regression, replace dec(3) label 
reg gdpgrowth debttogdp gdppc 
outreg2 m2 using tab_regression, dec(3) label 
reg gdpgrowth debttogdp loggdppc
outreg2 m3 using tab_regression , dec(3) tex(frag) label 
cd ../../command_files

