:: this batch file executes the entire analysis of debt and growth article
:: first run all Stata files in the command_files directory 
cd command_files
rundirectory.bat
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