
1. Content of the replication files:

README.txt - this file
run analysis.bat - batch file that executes everything

documents folder:
 debt_and_growth_article.tex - LaTex with the text of the article
 debtandgrowth.bib - BibTex bibliography file
 debt_and_growth_article.pdf - pdf of the article
 tables_figures folder:
  <empty but on execution populated with tables and figures>

original_data folder:
 Debt Database Fall 2013 Vintage.xlsx
 wdidata08102017.dta
 meta_data folder:
  

command_files folder:
 rundirectory.bat
 get_and_clean_data.do
 analyze_annual.do
 create_five_year_data.do
 analyze5year.do

analysis_data folder:
 <empty but populated when analysis is executed>

2. No modification was made to original data files.
   
3. Instructions for replicating the study:

Running "run analysis.bat" executes all Stata programs and LaTex files. Users may need to modify "rundirectory.bat" in the command_files folder to make sure it points to their Stata.exe file, e.g. "C:\Program Files\Stata15\StataSE-64.exe"

Alternatively, users can execute .do files in the order they are listed above.

Stata needs to have outreg2 and estout installed. Each can be installed by typing
"ssc install outreg2
 ssc install estout"
in Stata command line.