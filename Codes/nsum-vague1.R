# Calculs NSUM - Semaine 1
library(foreign)
library(xtable)
library(ggplot2)
library(boot)
library(tidyverse)

rm(list=ls()) # vider l'espace de travail
# fixer le répertoire de travail
#setwd("~/Dropbox (CEDIA)/EnqueteCOVID")
setwd("~/Dropbox/EnqueteCOVID")
set.seed(12345) # fixer le seed pour réplications

# charger les données
df <- read.dta("Propre/cirano-leger-covid.dta")
df <- df[df$semaine==1,]
df$strata <- with(df, interaction(region,  age)) # ajouter la strate age*region (strate d'échantillonage)
# définir les ARD de contrôle
dra <- df[,c('dra_medecins','dra_rpa','dra_sansvaccin')]
colnames(dra) <- c('medecins','rpa','sansvaccin')

# QUESTION POUR VINCENT: A-T-ON ENCORE BESOIN DE CETTE LIGNE?
#dra$medecins <- pmax(dra$medecins-1,0) ## test

dra <- cbind(dra, total = rowSums(dra))
# définir la ARD d'intérêt
dra_u <- df[,c('dra_covid')]

# contrôle de qualité sur les réponses: distributions
summary(dra)
summary(dra_u)

# poids
wgt <- df[,c('poids')]
sum(wgt)

# définir les tailles connues pour questions de contrôle
# medecins actifs: http://www.cmq.org/hub/fr/statistiques.aspx
# RPA (https://www.cmhc-schl.gc.ca/fr/professionals/housing-markets-data-and-research/housing-data/data-tables/rental-market/seniors-housing-survey-data-tables)
# CHSLD, https://m02.pub.msss.rtss.qc.ca/M02SommLitsPlacesProv.asp
# RI-RTF: https://creei.ca/wp-content/uploads/2021/02/cahier_21_01_financement_soutien_autonomie_personnes_agees_croisee_chemins.pdf
# non-vaccinés: calculé par Alexandre Prudhomme selon données INSPQ. 

#nks <- c(25222,127897+43861+9897,515771)
nks <- c(25222,127897+43861+9897,515455) # mise à jour (+précision) 9 mars

nks <- c(nks,sum(nks))
nks

# faire les sommes d'ARD (pondérées)
n_dra <- mapply(sum,wgt*dra)
n_dra_u <- sum(wgt*dra_u)

# calculer les facteurs d'amplificateur de réseaux
lambdas <- nks/n_dra
lambdas


### fonction qui calcule l'ensemble des estimateurs
### pour un échantillon donné (appelée par le package "boot" pour calculer aussi les écart-types)
ncases <- function(d,i,j){
  d <- d[i,] # données utilisant la liste d'indices i (i=1:n est le sample original)
  w <- d[i,6] # position des poids
  mw <- matrix(rep(w,ncol(d)),nrow(d),ncol(d)) # vecteur de poids sous forme de matrice 
  nd <- colSums(mw*d) # sommes pondérées
  lbd <- nks/nd[1:4] # facteurs amplification réseaux
  nc <- nd[5]*lbd # estimateurs réseau
  nc <- c(nc,mean(nc[1:3]),nd[c("covid_test_positif","covid_positif")]) # estimateur moyen et estimateur par échantillonage direct
  return(nc)
}

dtaboot <- cbind(dra,dra_u,wgt,df$covid_test_positif,df$covid_positif,as.numeric(df$strata)) # données pour les estimateurs
colnames(dtaboot)[7:9] <- c("covid_test_positif","covid_positif","strata")

## clean les données en enlevant les valeur extêmes
upbnd <- 100 # upper bound sur les valeurs crédibles
dropi <- dtaboot$medecins>upbnd | dtaboot$rpa>upbnd | dtaboot$sansvaccin>upbnd | dtaboot$dra_u>upbnd # vecteur logique =TRUE si à enlever
dtaboot <- dtaboot[!dropi,] # enlève les données extrêmes
dtaboot$wgt <- dtaboot$wgt*sum(wgt)/sum(dtaboot$wgt) ## repondère les poids supposant missing at random

covid <- boot(data=dtaboot,statistic=ncases,R=999,sim="ordinary",strata=dtaboot$strata,j = dtaboot$wgt) # calcule l'estimateur ainsi qu'un échantillon bootstrap
nsums_covid <- covid$t0 # estimateur
nsums_covid_se <- apply(covid$t,2,sd) # écart-type

# nombres de test positifs PCR derniers 7 jours (on va faire moyenne pondérée)
# source: https://www.inspq.qc.ca/covid-19/donnees
tests <- 48815 #c(12370,9702,7903,7992,6875,6398,3213)
sum(tests)

# présenter le tout dans un tableau
tableau <- rbind(nsums_covid,nsums_covid_se)
colnames(tableau) <- c('medecins','rpa','sansvaccin','total','moyenne','covid_test_positif','covid_positif')
tableau <- tableau[,c('covid_test_positif','covid_positif','total','moyenne')]
rownames(tableau) <- c('Nb cas 7 jours','écart-type')
colnames(tableau) <- c('Direct positifs','Avec auto-diag.','APR, Killworth et al. (1998)','APR, Habecker et al. (2015)')
tableau

tableau <- rbind(tableau,tableau/7)
rownames(tableau) <- c('Nb cas (7j)','écart-type (7j)','Nb cas (j)','écart-type (j)')
tableau <- t(tableau)
print(xtable(tableau,digits=0),file='Tableaux-Figures/covid-prevalence-vague1.tex')
tableau

fig <- data.frame(
  estimations = c(rownames(tableau),'Officiel (PCR)'),
  cas = c(tableau[,'Nb cas (7j)'],sum(tests))*1e-3,
  se = c(tableau[,'écart-type (7j)'],0.0)*1e-3
)

ggplot(fig) +
  geom_bar( aes(x=reorder(estimations, cas), y=cas), stat="identity", fill="blue", alpha=0.7) +
  geom_errorbar( aes(x=reorder(estimations, cas), ymin=cas-1.96*se, ymax=cas+1.96*se), width=0.5, colour="black", alpha=0.9, size=0.5) +
  labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Estimations") +
  theme_bw()
ggsave('Tableaux-Figures/prevalence-covid-vague1.png',dpi=1200)

saveRDS(fig,file="Tableaux-Figures/tableauV1.Rda")
