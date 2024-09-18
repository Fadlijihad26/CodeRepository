
/*

Tech Transfer Materials: FCI using PCA

Author: Fadli Setiawan
Last Edited: June 4, 2023

*/

clear all
set more off

*** Importing Data
import excel "/Users/macintoshhd/Documents/0 IFG Progress/2Modules/Financial Condition Index/FCI IFGP.xlsx", sheet("Clean") firstrow case(lower)

/// Varlist
gl varlist "vix yidnusd idn10y2y cdsindex deposityoy usdidryoy"

/// Check
corr $varlist jci

*** PCA - V1 (JCI not Inverted)
pca $varlist jci
predict pca1, score
rename pca1 fci_v1

*** PCA - V2 (JCI Inverted)
pca $varlist jciinv
predict pca1, score
rename pca1 fci_v2

*** Visualization ***
twoway (line fci_v1 date)
twoway (line fci_v2 date)

*** END OF DO-FILE ***

