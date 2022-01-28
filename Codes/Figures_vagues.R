# Calculs NSUM - Semaine 1
library(ggplot2)

rm(list=ls()) # vider l'espace de travail
# fixer le répertoire de travail
#setwd("~/Dropbox (CEDIA)/EnqueteCOVID")
setwd("~/Dropbox/EnqueteCOVID")

fig1 <- readRDS("Tableaux-Figures/tableauV1.Rda")
fig1$vague <- "Semaine 1"

fig2 <- readRDS("Tableaux-Figures/tableauV2.Rda")
fig2$vague <- "Semaine 2"


fig <- rbind(fig1,fig2)
fig$vague <- factor(fig$vague)

colorBlindGrey8   <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                       "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(fig, aes(x=reorder(estimations, cas), y=cas,fill=vague)) +
  geom_bar(stat="identity", position=position_dodge2(), alpha=0.7) +
  geom_errorbar( aes(ymin=cas-1.96*se, ymax=cas+1.96*se), colour="black", alpha=0.9, size=0.5,position=position_dodge2(0.9,padding=0.6)) +
  labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Estimations") + scale_fill_manual(values=colorBlindGrey8[c(6,4)]) +
  theme_bw() + theme(axis.text.x = element_text(angle = 90))
ggsave('Tableaux-Figures/incidence-covid-allwaves.png',dpi=1200)


diff <- as.data.frame(fig1$estimations)
diff$diff <- fig2$cas-fig1$cas
diff$diff_se <- sqrt(fig1$se^2+fig2$se^2)
diff$tstat <- diff$diff/diff$diff_se
print(diff)
