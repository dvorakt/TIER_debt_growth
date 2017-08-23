:: this batch file executes the entire analysis of debt and growth article
:: first run all Stata files in the command_files directory 
cd command_files
:: the path to Stata.exe may need to be changed based on individual installation
:: option /e means we don't have to click ok
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  get_and_clean_data.do
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  analyze_annual.do
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  create5year_data.do
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  analyze5year.do
:: each Stata run generates log file, I delete these
del *.log
:: rundirectory.bat
:: now run LaTex and BibTex files to create a pdf
cd ..
cd documents
pdflatex debt_and_growth_article.tex
bibtex debt_and_growth_article.aux
pdflatex debt_and_growth_article.tex
pdflatex debt_and_growth_article.tex 
::clean up by deleting auxiliary and log files
del *.aux
del *.bbl
del *.blg
del *.out
del *.log
START "" debt_and_growth_article.pdf