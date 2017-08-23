:: the path to Stata.exe may need to be changed based on individual installation
:: option /e means we don't have to click ok
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  get_and_clean_data.do
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  analyze_annual.do
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  create5year_data.do
"C:\Program Files (x86)\Stata15\StataSE-64.exe" /e do  analyze5year.do
:: each Stata run generates log file, I delete these
::del *.log
PAUSE