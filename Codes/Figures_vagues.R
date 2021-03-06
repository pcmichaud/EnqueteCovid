# Calculs NSUM - Semaine 1
library(ggplot2)
library(foreign)
library(xtable)
rm(list=ls()) # vider l'espace de travail
# fixer le répertoire de travail
setwd("~/Dropbox/EnqueteCOVID/Tableaux-Figures")
df <- read.dta(paste("~/Dropbox/EnqueteCOVID/Propre/cirano_leger_covid_",1,".dta",sep=""))
regtotlist <- unique(df$region)
rm(df)
SudQc <- c(2,5,9)
EstNQC <- c(1,3,11,15,17)
CentreQC <- c(8,10,12,14,16)
OuestQC <- c(4,6,7,13)
R1 <- c(2,5,6,9,13,14,4)
R2 <- c(8,10,12,16)
R3 <- c(1,3,7,11,15,17)

d <- c("Semaine 17","Semaine 18") # comparaisons entre les semaines
PCRalter <- NULL #c(7059.70,4365.70,3369.13,3038.46,2457.37,1690.83,1297.41,1125.64,1079.02,1248.52,1946.28,2759.62,3090)
PCRSante <- c(650, 537, 775, 719, 566, 455, 401, 353, 363, 468, 844, 1169, 1260, 1055, 877, 562,NA,NA)
semnorm <- 1 # normaliser quelle semaine pour les comparaisons avec PCR

wrap <- function(sreg){
  ## choose region
  if (sreg==1){
    reglist <- regtotlist
    name <- titre <- "Québec"
  }
  if (sreg==2){
    reglist <- regtotlist[SudQc]
    name <- titre <- "Sud du Québec"
  }
  if (sreg==3){
    reglist <- regtotlist[EstNQC]
    name <- titre <- "Est et Nord du Québec"
  }
  if (sreg==4){
    reglist <- regtotlist[CentreQC]
    name <- titre <- "Centre du Québec"
  }
  if (sreg==5){
    reglist <- regtotlist[OuestQC]
    name <- titre <- "Ouest du Québec"
  }
  if (sreg==6){
    reglist <- regtotlist[R1]
    titre <- "Montréal, Montérégie, Laval, Laurentides, Lanaudière, Estrie, Outaouais"
    name <- "Regroupement 1"
  }
  if (sreg==7){
    reglist <- regtotlist[R2]
    titre <- "Capitale Nationale, Mauricie, Centre-du-Québec, Chaudières-Appalaches"
    name <- "Regroupement 2"
  }
  if (sreg==8){
    reglist <- regtotlist[R3]
    titre <- "Gaspésie-Iles-de-la-Madeleine, Côte-Nord, Saguenay, Bas-St-Laurent, Abitibi, Nord du Québec"
    name <- "Regroupement 3"
  }
  
  
  fig1 <- readRDS(paste("tableauV1_",name,".Rda",sep=""))
  fig1$vague <- "Semaine 1"
  fig2 <- readRDS(paste("tableauV2_",name,".Rda",sep=""))
  fig2$vague <- "Semaine 2"
  fig3 <- readRDS(paste("tableauV3_",name,".Rda",sep=""))
  fig3$vague <- "Semaine 3"
  fig4 <- readRDS(paste("tableauV4_",name,".Rda",sep=""))
  fig4$vague <- "Semaine 4"
  fig5 <- readRDS(paste("tableauV5_",name,".Rda",sep=""))
  fig5$vague <- "Semaine 5"
  fig6 <- readRDS(paste("tableauV6_",name,".Rda",sep=""))
  fig6$vague <- "Semaine 6"
  fig7 <- readRDS(paste("tableauV7_",name,".Rda",sep=""))
  fig7$vague <- "Semaine 7"
  fig8 <- readRDS(paste("tableauV8_",name,".Rda",sep=""))
  fig8$vague <- "Semaine 8"
  fig9 <- readRDS(paste("tableauV9_",name,".Rda",sep=""))
  fig9$vague <- "Semaine 9"
  fig10 <- readRDS(paste("tableauV10_",name,".Rda",sep=""))
  fig10$vague <- "Semaine 10"
  fig11 <- readRDS(paste("tableauV11_",name,".Rda",sep=""))
  fig11$vague <- "Semaine 11"
  fig12 <- readRDS(paste("tableauV12_",name,".Rda",sep=""))
  fig12$vague <- "Semaine 12"
  fig13 <- readRDS(paste("tableauV13_",name,".Rda",sep=""))
  fig13$vague <- "Semaine 13"
  fig14 <- readRDS(paste("tableauV14_",name,".Rda",sep=""))
  fig14$vague <- "Semaine 14"
  fig15 <- readRDS(paste("tableauV15_",name,".Rda",sep=""))
  fig15$vague <- "Semaine 15"
  fig16 <- readRDS(paste("tableauV16_",name,".Rda",sep=""))
  fig16$vague <- "Semaine 16"
  fig17 <- readRDS(paste("tableauV17_",name,".Rda",sep=""))
  fig17$vague <- "Semaine 17"
  fig18 <- readRDS(paste("tableauV18_",name,".Rda",sep=""))
  fig18$vague <- "Semaine 18"
  
  fig <- rbind(fig1,fig2,fig3,fig4,fig5,fig6,fig7,fig8,fig9,fig10,fig11,fig12,fig13,fig14,fig15,fig16,fig17,fig18)
  fig$vague <- factor(fig$vague,levels=c("Semaine 1", "Semaine 2","Semaine 3",  "Semaine 4",  "Semaine 5",
                                         "Semaine 6",  "Semaine 7",  "Semaine 8","Semaine 9", "Semaine 10", "Semaine 11", "Semaine 12",
                                         "Semaine 13", "Semaine 14", "Semaine 15", "Semaine 16", "Semaine 17", "Semaine 18"))
  fig$estimations <- as.character(fig$estimations)
  
  colorBlindGrey8   <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                         "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                               "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888")
  safe_colorblind_palette <- c(safe_colorblind_palette,"#FFBD59","#4472C4","#172243","#428A91","#F1CABA","#652051")
  
  ## Classical graph
  figclassic <- fig[fig$estimations %in% c("total","cirano","covid_test_positif","covid_positif","Officiel (PCR)"),]
  figclassic[figclassic$estimations=="total","estimations"] <- "APR, Killworth et al. (1998)"
  figclassic[figclassic$estimations=="cirano","estimations"] <- 'APR, CIRANO (2022)'
  figclassic[figclassic$estimations=="covid_test_positif","estimations"] <- 'Direct positifs'
  figclassic[figclassic$estimations=="covid_positif","estimations"] <- 'Avec auto-diag.'
  ograph <- unique(figclassic$estimations)[c(5,2,1,3,4)]
  figclassic$estimations <- factor(figclassic$estimations,levels = ograph)
  
  reg <- 0
  if (length(reglist) != length(regtotlist)){
    reg <- 1
  } else {
    if (!all(reglist == regtotlist)){
      reg <- 1
    }
  }
  if (reg == 1){
    figclassic <- figclassic[figclassic$estimations %in% c("Officiel (PCR)","Direct positifs","Avec auto-diag."),]
  }
  if (reg==0){
    print(rbind(figclassic[figclassic$estimations=='APR, Killworth et al. (1998)',"cas"]/figclassic[figclassic$estimations=='Officiel (PCR)',"cas"],figclassic[figclassic$estimations=='Officiel (PCR)',"vague"]))
    print(rbind(figclassic[figclassic$estimations=='APR, CIRANO (2022)',"cas"]/figclassic[figclassic$estimations=='Officiel (PCR)',"cas"],figclassic[figclassic$estimations=='Officiel (PCR)',"vague"]))
    print(rbind(figclassic[figclassic$estimations=='Direct positifs',"cas"]/figclassic[figclassic$estimations=='Officiel (PCR)',"cas"],figclassic[figclassic$estimations=='Officiel (PCR)',"vague"]))
  
    ggplot(figclassic, aes(x=estimations, y=cas,fill=vague)) +
      geom_bar(stat="identity", position=position_dodge2(), alpha=0.7) +
      geom_errorbar( aes(ymin=cas-1.96*se, ymax=cas+1.96*se), colour="black", alpha=0.9, size=0.5,position=position_dodge2(0.9,padding=0.6)) +
      labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Estimations") + scale_fill_manual(values=safe_colorblind_palette[1:length(unique(fig$vague))]) +
      theme_bw() + theme(axis.text.x = element_text(angle = 90)) + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
    ggsave(paste("incidence-covid-allwaves_",name,".png",sep=""),dpi=1200, width = 16, height = 9)
    figw <- figclassic
    figw$estimations <- as.character(figw$estimations)
    
    for (i in 1:length(levels(figw$vague))){
      if (length(PCRalter)>0){
        figw <- rbind(figw,c("PCR (ajustés)",PCRalter[i],0,paste("Semaine ",i,sep="")))
      }
      if (length(PCRSante)>0){
        figw <- rbind(figw,c("PCR (T. Santé)",PCRSante[i],0,paste("Semaine ",i,sep="")))
      }
      
    }
    figw$estimations <- factor(figw$estimations)
    figw$cas <- as.numeric(figw$cas)
    figw$se <- as.numeric(figw$se)
    if (length(PCRalter)>0){
      figw[figw$estimations=="PCR (ajustés)","cas"] <- figw[figw$estimations=="PCR (ajustés)","cas"]/figw[figw$estimations=="PCR (ajustés)","cas"][semnorm]
    }
    if (length(PCRSante)>0){
      figw[figw$estimations=="PCR (T. Santé)","cas"] <- figw[figw$estimations=="PCR (T. Santé)","cas"]/figw[figw$estimations=="PCR (T. Santé)","cas"][semnorm]
    }
    
    figw[figw$estimations=="Officiel (PCR)","cas"] <- figw[figw$estimations=="Officiel (PCR)","cas"]/figw[figw$estimations=="Officiel (PCR)","cas"][semnorm]
    figw[figw$estimations=='APR, Killworth et al. (1998)',"se"] <- figw[figw$estimations=='APR, Killworth et al. (1998)',"se"]/figw[figw$estimations=='APR, Killworth et al. (1998)',"cas"][semnorm]
    figw[figw$estimations=='APR, Killworth et al. (1998)',"cas"] <- figw[figw$estimations=='APR, Killworth et al. (1998)',"cas"]/figw[figw$estimations=='APR, Killworth et al. (1998)',"cas"][semnorm]
    figw[figw$estimations=='APR, CIRANO (2022)',"se"] <- figw[figw$estimations=='APR, CIRANO (2022)',"se"]/figw[figw$estimations=='APR, CIRANO (2022)',"cas"][semnorm]
    figw[figw$estimations=='APR, CIRANO (2022)',"cas"] <- figw[figw$estimations=='APR, CIRANO (2022)',"cas"]/figw[figw$estimations=='APR, CIRANO (2022)',"cas"][semnorm]
    figw[figw$estimations=='Direct positifs',"se"] <- figw[figw$estimations=='Direct positifs',"se"]/figw[figw$estimations=='Direct positifs',"cas"][semnorm]
    figw[figw$estimations=='Direct positifs',"cas"] <- figw[figw$estimations=='Direct positifs',"cas"]/figw[figw$estimations=='Direct positifs',"cas"][semnorm]
    figw[figw$estimations=='Avec auto-diag.',"se"] <- figw[figw$estimations=='Avec auto-diag.',"se"]/figw[figw$estimations=='Avec auto-diag.',"cas"][semnorm]
    figw[figw$estimations=='Avec auto-diag.',"cas"] <- figw[figw$estimations=='Avec auto-diag.',"cas"]/figw[figw$estimations=='Avec auto-diag.',"cas"][semnorm]
    
    ggplot(figw, aes(x=vague, y=cas,group=estimations,colour=estimations)) +
      geom_point() + geom_line() + geom_ribbon(aes(ymin=cas-1.96*se, ymax=cas+1.96*se), linetype=2, alpha=0.1) +
      theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(y="Nombre de cas normalisés (Semaine 1=1)", x = "Semaines") +
      coord_cartesian(ylim = c(0, NA))  + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
    ggsave(paste("incidence-covid-allwaves-normalized_",semnorm,name,".png",sep=""),dpi=1200, width = 16, height = 9)
    
    figsplit <- fig[fig$estimations %in% c("medecins","rpa","sansvaccin"),]
    figsplit[figsplit$estimations=="medecins","estimations"] <- "Médecins"
    figsplit[figsplit$estimations=="rpa","estimations"] <- "Résidences pour aînés"
    figsplit[figsplit$estimations=="sansvaccin","estimations"] <- "Aucune dose Vac."
    figsplit$estimations <- factor(figsplit$estimations)
    ggplot(figsplit, aes(x=vague, y=cas,group=estimations,colour=estimations)) +
     geom_point() + geom_line() + geom_ribbon(aes(ymin=cas-1.96*se, ymax=cas+1.96*se), linetype=2, alpha=0.1) +
     theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Semaines") +
     coord_cartesian(ylim = c(0, NA))  + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
    ggsave(paste("incidence-covid-allwaves-splitAPR_",name,".png",sep=""),dpi=1200, width = 16, height = 9)

  }
  
  
  fig_lines <- figclassic[figclassic$estimations!="Officiel (PCR)",]
  
  ggplot(fig_lines, aes(x=vague, y=cas,group=estimations,colour=estimations)) +
    geom_point() + geom_line() + geom_ribbon(aes(ymin=cas-1.96*se, ymax=cas+1.96*se), linetype=2, alpha=0.1) +
    theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Semaines") +
    coord_cartesian(ylim = c(0, NA))  + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
  ggsave(paste("incidence-covid-allwaves-lines_",name,".png",sep=""),dpi=1200, width = 16, height = 9)
  
  
  fig_lines2 <- fig_lines[fig_lines$estimations!="Avec auto-diag.",]
  
  ggplot(fig_lines2, aes(x=vague, y=cas,group=estimations,colour=estimations)) +
    geom_point() + geom_line() + geom_ribbon(aes(ymin=cas-1.96*se, ymax=cas+1.96*se), linetype=2, alpha=0.1) +
    theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Semaines") +
    coord_cartesian(ylim = c(0, NA)) + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
  ggsave(paste("incidence-covid-allwaves-lines-testsonly_",name,".png",sep=""),dpi=1200, width = 16, height = 9)
  
  
  figtaux <- fig[fig$estimations %in% c("covid_test_positif_av","covid_positif_av"),]
  figtaux[figtaux$estimations=="covid_test_positif_av","estimations"] <- 'Direct positifs'
  figtaux[figtaux$estimations=="covid_positif_av","estimations"] <- 'Avec auto-diag.'
  ograph <- unique(figtaux$estimations)
  figtaux$estimations <- factor(figtaux$estimations,levels=ograph)
  
  ggplot(figtaux, aes(x=vague, y=100*cas*1e3,group=estimations,colour=estimations)) +
    geom_point() + geom_line() + geom_ribbon(aes(ymin=100*(cas-1.96*se)*1e3, ymax=100*(cas+1.96*se)*1e3), linetype=2, alpha=0.1) +
    theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(y="Incidence (taux en %, 7 derniers jours)", x = "Semaines") +
    coord_cartesian(ylim = c(0, 10)) + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
  ggsave(paste("incidence-covid-allwaves-lines-taux_",name,".png",sep=""),dpi=1200, width = 16, height = 9)
  
  figdrau <- fig[fig$estimations == "dra_covid",]
  ggplot(figdrau, aes(x=vague, y=cas*1e3,group=estimations)) +
    geom_point() + geom_line() + geom_ribbon(aes(ymin=(cas-1.96*se)*1e3, ymax=(cas+1.96*se)*1e3), linetype=2, alpha=0.1) +
    theme_bw() + theme(axis.text.x = element_text(angle = 90)) + labs(y="Connaissances positives à la covid (Moyenne, 7 derniers jours)", x = "Semaines") +
    coord_cartesian(ylim = c(0, NA)) + ggtitle(titre) + theme(plot.title = element_text(hjust = 0.5))
  ggsave(paste("incidence-covid-allwaves-lines-dra-covid_",name,".png",sep=""),dpi=1200, width = 16, height = 9)
  
  diff <- as.data.frame(figclassic[figclassic$vague=="Semaine 1","estimations"])
  colnames(diff) <- "estimations"
  diff$diff <- figclassic[figclassic$vague==d[2],"cas"]-figclassic[figclassic$vague==d[1],"cas"]
  diff$diff_se <- sqrt(figclassic[figclassic$vague==d[1],"se"]^2+figclassic[figclassic$vague==d[2],"se"]^2)
  diff$tstat <- diff$diff/diff$diff_se
  diff$pval <- 2*pt(abs(diff$tstat),2999,lower.tail = F)
  print(diff)
  
  diff_prnt <- diff
  diff_prnt$diff <- round(diff_prnt$diff*1000)
  diff_prnt$diff_se <- round(diff_prnt$diff_se*1000)
  diff_prnt$tstat <- round(diff_prnt$tstat,digits=2)
  diff_prnt$pval <- round(diff_prnt$pval,digits=3)
  print(diff_prnt)
  
  if (sreg==1){
    print(xtable(diff_prnt),file='currentdiff_Quebec.tex')
    print(xtable(diff_prnt),file=paste(paste(d,collapse=""),".tex",sep=""))
  }
  
  
}

for (i in 1:8){
  wrap(i)
}



