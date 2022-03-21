* 16 mars 2022.

* COVID personnes âgées.

use "C:\Users\Alexandre Prud'homme\Dropbox\EnqueteCOVID\60ans+\Vagues_1-9.dta"

set more off
numlabel, add

********* % COVID par test et autodiagnostic (60 ans et plus) *********

by semaine, sort : tabulate covid_status1 Age_1, column
by Age_1 semaine, sort : ci proportions covid_status1, exact

by Age_1, sort : ttest covid_status1 if semaine==1 | semaine==2, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==2 | semaine==3, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==3 | semaine==4, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==4 | semaine==5, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==5 | semaine==6, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==6 | semaine==7, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==7 | semaine==8, by(semaine)
by Age_1, sort : ttest covid_status1 if semaine==8 | semaine==9, by(semaine)