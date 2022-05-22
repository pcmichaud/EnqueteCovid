  # Calculs NSUM 
  library(foreign)
  library(xtable)
  library(ggplot2)
  library(boot)
  library(plyr)
  library(tidyverse)
  
  rm(list=ls()) # vider l'espace de travail
  # fixer le répertoire de travail
  setwd("~/Dropbox/EnqueteCOVID")
  df <- read.dta(paste("~/Dropbox/EnqueteCOVID/Propre/cirano_leger_covid_",1,".dta",sep=""))
  regtotlist <- unique(df$region)
  print(matrix(regtotlist,length(regtotlist),1))
  rm(df)
  ####
  #QUELLE VAGUE (dernière)
  dvag <- 18
  
  ## QUELLES RÉGIONS
  SudQc <- c(2,5,9)
  EstNQC <- c(1,3,11,15,17)
  CentreQC <- c(8,10,12,14,16)
  OuestQC <- c(4,6,7,13)
  R1 <- c(2,5,6,9,13,14,4)
  R2 <- c(8,10,12,16)
  R3 <- c(1,3,7,11,15,17)
  reglistuse <- list(regtotlist,regtotlist[SudQc],regtotlist[EstNQC],regtotlist[CentreQC],regtotlist[OuestQC],regtotlist[R1],regtotlist[R2],regtotlist[R3])
  
  ##historique nombre de personnes non vaccinées
  #lstnovax <- c(536544, 522123, 511947, 505156, 500638, 498334, 496848, 495749, 494709, 493979, 493179, 492291, 491341, 490361, 489620)
  lstnovax <- c(554735, 540381, 530227, 523463, 518950, 516644, 515161, 514057, 513019, 512283, 511481, 510590, 509632, 508661, 507706, 506598, 505508, 504440)
  
  ## valeurs connues
  # medecins actifs: http://www.cmq.org/hub/fr/statistiques.aspx
  # RPA (https://www.cmhc-schl.gc.ca/fr/professionals/housing-markets-data-and-research/housing-data/data-tables/rental-market/seniors-housing-survey-data-tables)
  # CHSLD, https://m02.pub.msss.rtss.qc.ca/M02SommLitsPlacesProv.asp
  # RI-RTF: https://creei.ca/wp-content/uploads/2021/02/cahier_21_01_financement_soutien_autonomie_personnes_agees_croisee_chemins.pdf
  # non-vaccinés: calculé par Alexandre Prudhomme selon données INSPQ. 
  
  wrap <- function(vag,reglist){
    set.seed(12345) # fixer le seed pour réplications
    
    if (vag==1){
      nks <- c(25222,127897+43861+9897,lstnovax[vag])
      tests <- 48815
    }
    if (vag==2){
      nks <- c(25222,127897+43861+9897,lstnovax[vag])
      tests <- 30393
    }
    if (vag==3){
      nks <- c(25240,181561,lstnovax[vag])
      tests <- 23270
    }
    if (vag==4){
      nks <- c(25246,181561,lstnovax[vag])
      tests <- 21032
    }
    if (vag==5){
      nks <- c(25248,181561,lstnovax[vag])
      tests <- 17090
    }
    if (vag==6){
      nks <- c(25251,181561,lstnovax[vag])
      tests <- 11783
    }
    if (vag==7){
      nks <- c(25254,181561,lstnovax[vag])
      tests <- 1296*7
    }
    if (vag==8){
      nks <- c(25251,181561,lstnovax[vag])
      tests <- 7839
    }
    if (vag==9){
      nks <- c(25251,181561,lstnovax[vag])
      tests <- 7521
    }
    if (vag==10){
      nks <- c(25248,181561,lstnovax[vag])
      tests <- 8616
    }
    if (vag==11){
      nks <- c(25241,181561,lstnovax[vag])
      tests <- 1921*7
    }
    if (vag==12){
      nks <- c(24984,181561,lstnovax[vag])
      tests <- 2739*7
    }
    if (vag==13){
      nks <- c(24716,181561,lstnovax[vag])
      tests <- 3090*7
    }
    if (vag==14){
      nks <- c(24984,181561,lstnovax[vag])
      tests <- 7*2642
    }
    if (vag==15){
      nks <- c(24792,181561,lstnovax[vag])
      tests <- 7*2088
    }
    if (vag==16){
      nks <- c( 24801 ,181561,lstnovax[vag])
      tests <- 1528*7
    }
    if (vag==17){
      nks <- c( 24821 ,181561,lstnovax[vag])
      tests <- 1106*7
    }
    if (vag==18){
      nks <- c( 24827 ,181561,lstnovax[vag])
      tests <- 801*7
    }
    nks <- c(nks,sum(nks))
    ####
    if (paste(as.character(reglist),collapse="")==paste(regtotlist,collapse="")){
      titre <- "Québec"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[SudQc],collapse="")){
      titre <- "Sud du Québec"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[EstNQC],collapse="")){
      titre <- "Est et Nord du Québec"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[CentreQC],collapse="")){
      titre <- "Centre du Québec"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[OuestQC],collapse="")){
      titre <- "Ouest du Québec"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[R1],collapse="")){
      titre <- "Regroupement 1"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[R2],collapse="")){
      titre <- "Regroupement 2"
    }
    if (paste(reglist,collapse="")==paste(regtotlist[R3],collapse="")){
      titre <- "Regroupement 3"
    }
    
    # charger les données
    df <- read.dta(paste("~/Dropbox/EnqueteCOVID/Propre/cirano_leger_covid_",vag,".dta",sep=""))
    if (vag == 18){
      df$covid_positif <- as.numeric(df$covid_positif=="Oui")
      df$covid_test_positif <- as.numeric(df$covid_test_positif=="Oui")
    }
    df <- df[df$semaine==vag,]
    df <- df[!is.na(df$record),]
    df <- df[(df$region %in% reglist),]
    df$strata <- with(df, interaction(region,  age)) # ajouter la strate age*region (strate d'échantillonage)
    # définir les ARD de contrôle
    dra <- df[,c('dra_medecins','dra_rpa','dra_sansvaccin')]
    colnames(dra) <- c('medecins','rpa','sansvaccin')
    
    dra <- cbind(dra, total = rowSums(dra))
    # définir la ARD d'intérêt
    dra_u <- df[,c('dra_covid')]
    
    # contrôle de qualité sur les réponses: distributions
    summary(dra)
    summary(dra_u)
    
    # poids
    wgt <- df[,c('poids')]
    sum(wgt)
    
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
      w <- d[i,pos.w] # position des poids
      mw <- matrix(rep(w,ncol(d)),nrow(d),ncol(d)) # vecteur de poids sous forme de matrice 
      nd <- colSums(mw*d) # sommes pondérées
      lbd <- nks/nd[pos.ardk] # facteurs amplification réseaux
      nc <- nd[pos.ardu]*lbd # estimateurs réseau
      popav <- d[i,pos.av,drop=FALSE] # estimateurs de la moyenne
      
      w2 <- w/sum(w) # frequency weights
      mw2 <- matrix(rep(w2,ncol(popav)),nrow(popav),ncol(popav)) # vecteur de poids sous forme de matrice
      popav <- colSums(mw2*popav)
      nc <- c(nc,mean(nc[1:(length(pos.ardk)-1)]),nd[pos.direct],popav) # estimateur moyen et estimateur par échantillonage direct
      return(nc)
    }
    if (vag>3 & vag<17){
      dtaboot <- cbind(dra,dra_u,wgt,df$covid_test_positif,df$covid_positif,as.numeric(df$ResultPos_miDec=="oui" | df$ResultPos_miDec=="oui, autodiagnostic"),df$ResultPos_enfantTotal_miDec,(as.numeric(df$ResultPos_miDec=="oui" | df$ResultPos_miDec=="oui, autodiagnostic")+df$ResultPos_enfantTotal_miDec), df$dra_covid,as.numeric(df$strata)) # données pour les estimateurs
      colnames(dtaboot)[7:13] <- c("covid_test_positif","covid_positif","EgoTot","EnfantTot","EgoEnfantTot","dra_covid","strata")
      print((cbind(1:length(colnames(dtaboot)),colnames(dtaboot))))
      pos.w <- 6
      pos.ardk <- c(1:4)
      pos.ardu <- 5
      pos.direct <- c(7:11)
      pos.av <- c(7,8,12)
    }
    if (vag<=3 | vag>=17){
      dtaboot <- cbind(dra,dra_u,wgt,df$covid_test_positif,df$covid_positif,df$dra_covid, as.numeric(df$strata)) # données pour les estimateurs
      colnames(dtaboot)[7:10] <- c("covid_test_positif","covid_positif","dra_covid","strata")
      print((cbind(1:length(colnames(dtaboot)),colnames(dtaboot))))
      pos.w <- 6
      pos.ardk <- c(1:4)
      pos.ardu <- 5
      pos.direct <- c(7:8)
      pos.av <- c(7,8,9)
    }
    
    ## clean les données en enlevant les valeur extêmes
    upbnd <- 100 # upper bound sur les valeurs crédibles
    dropi <- dtaboot$medecins>upbnd | dtaboot$rpa>upbnd | dtaboot$sansvaccin>upbnd | dtaboot$dra_u>upbnd # vecteur logique =TRUE si à enlever
    dtaboot <- dtaboot[!dropi,] # enlève les données extrêmes
    dtaboot$wgt <- dtaboot$wgt*sum(wgt)/sum(dtaboot$wgt) ## repondère les poids supposant missing at random
    
    covid <- boot(data=dtaboot,statistic=ncases,R=999,sim="ordinary",strata=dtaboot$strata,j = dtaboot$wgt) # calcule l'estimateur ainsi qu'un échantillon bootstrap
    nsums_covid <- covid$t0 # estimateur
    nsums_covid_se <- apply(covid$t,2,sd) # écart-type
    
    tableau <- rbind(nsums_covid,nsums_covid_se)
    #tableau <- tableau[,((ncol(tableau)-2):ncol(tableau)),drop=FALSE]
    rownames(tableau) <- c('Nb cas 7 jours','écart-type')
    colnames(tableau)[5] <- "cirano"
    colnames(tableau)[(length(colnames(tableau))-2):(length(colnames(tableau))-1)] <- c("covid_test_positif_av", "covid_positif_av")
    print(colnames(tableau))
    
    
    tableau <- rbind(tableau,tableau/7)
    rownames(tableau) <- c('Nb cas (7j)','écart-type (7j)','Nb cas (j)','écart-type (j)')
    tableau <- t(tableau)
    print(round(tableau,digits=0))
    if (titre=="Québec"){
      print(xtable(tableau,digits=0),file=paste('Tableaux-Figures/covid-prevalence-vague',vag,"_",'Quebec.tex',sep=""))
    }
    
    
    fig <- data.frame(
      estimations = c(rownames(tableau),'Officiel (PCR)'),
      cas = c(tableau[,'Nb cas (7j)'],sum(tests))*1e-3,
      se = c(tableau[,'écart-type (7j)'],0.0)*1e-3
    )
    
    saveRDS(fig,file=paste("Tableaux-Figures/tableauV",vag,"_",titre,".Rda",sep=""))
  }
  
  for (vag in 1:dvag){
    for (reg in 1:length(reglistuse)){
      wrap(vag,reglistuse[[reg]])
    }
  }
  
