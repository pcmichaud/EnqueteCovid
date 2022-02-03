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

fig3 <- readRDS("Tableaux-Figures/tableauV3.Rda")
fig3$vague <- "Semaine 3"

fig <- rbind(fig1,fig2,fig3)
fig$vague <- factor(fig$vague)

colorBlindGrey8   <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                       "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(fig, aes(x=reorder(estimations, cas), y=cas,fill=vague)) +
  geom_bar(stat="identity", position=position_dodge2(), alpha=0.7) +
  geom_errorbar( aes(ymin=cas-1.96*se, ymax=cas+1.96*se), colour="black", alpha=0.9, size=0.5,position=position_dodge2(0.9,padding=0.6)) +
  labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Estimations") + scale_fill_manual(values=colorBlindGrey8[c(6,4,2)]) +
  theme_bw() + theme(axis.text.x = element_text(angle = 90))
ggsave('Tableaux-Figures/incidence-covid-allwaves.png',dpi=1200)

diff12 <- as.data.frame(fig1$estimations)
diff12$diff <- fig2$cas-fig1$cas
diff12$diff_se <- sqrt(fig1$se^2+fig2$se^2)
diff12$tstat <- diff12$diff/diff12$diff_se
diff12$pval <- 2*pt(diff12$tstat,2999,lower.tail = T)
print(diff12)



diff13 <- as.data.frame(fig1$estimations)
diff13$diff <- fig3$cas-fig1$cas
diff13$diff_se <- sqrt(fig1$se^2+fig3$se^2)
diff13$tstat <- diff13$diff/diff13$diff_se
diff13$pval <- 2*pt(diff13$tstat,2999,lower.tail = T)
print(diff13)

diff23 <- as.data.frame(fig1$estimations)
diff23$diff <- fig3$cas-fig2$cas
diff23$diff_se <- sqrt(fig2$se^2+fig3$se^2)
diff23$tstat <- diff23$diff/diff23$diff_se
diff23$pval <- 2*pt(diff23$tstat,2999,lower.tail = T)
print(diff23)

diff_prnt <- diff23
diff_prnt$diff <- round(diff_prnt$diff*1000)
diff_prnt$diff_se <- round(diff_prnt$diff_se*1000)
diff_prnt$tstat <- round(diff_prnt$tstat,digits=2)
diff_prnt$pval <- round(diff_prnt$pval,digits=3)
print(diff_prnt)

round(100*(fig2$cas-fig1$cas)/fig1$cas)
round(100*(fig3$cas-fig2$cas)/fig2$cas)
