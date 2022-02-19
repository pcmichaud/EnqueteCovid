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

fig4 <- readRDS("Tableaux-Figures/tableauV4.Rda")
fig4$vague <- "Semaine 4"

fig5 <- readRDS("Tableaux-Figures/tableauV5.Rda")
fig5$vague <- "Semaine 5"

fig <- rbind(fig1,fig2,fig3,fig4,fig5)
fig$vague <- factor(fig$vague)

colorBlindGrey8   <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                       "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
ograph <- levels(factor(fig$estimations))[c(5,1,2,4,3)]
fig$estimations <- factor(fig$estimations,levels = ograph)

ggplot(fig, aes(x=estimations, y=cas,fill=vague)) +
  geom_bar(stat="identity", position=position_dodge2(), alpha=0.7) +
  geom_errorbar( aes(ymin=cas-1.96*se, ymax=cas+1.96*se), colour="black", alpha=0.9, size=0.5,position=position_dodge2(0.9,padding=0.6)) +
  labs(y="Nombre de cas en milliers (7 derniers jours)", x = "Estimations") + scale_fill_manual(values=colorBlindGrey8[c(6,4,2,1,3)]) +
  theme_bw() + theme(axis.text.x = element_text(angle = 90))
ggsave('Tableaux-Figures/incidence-covid-allwaves.png',dpi=1200)

fig_alter <- fig[fig$estimations!="Officiel (PCR)",]

ggplot(fig_alter, aes(x=vague, y=cas,group=estimations,colour=estimations)) +
  geom_point() + geom_line() + geom_ribbon(aes(ymin=cas-1.96*se, ymax=cas+1.96*se), linetype=2, alpha=0.1) +
  theme_bw() + theme(axis.text.x = element_text(angle = 90))
ggsave('Tableaux-Figures/incidence-covid-allwaves-lines.png',dpi=1200)


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

diff34 <- as.data.frame(fig1$estimations)
diff34$diff <- fig4$cas-fig3$cas
diff34$diff_se <- sqrt(fig3$se^2+fig4$se^2)
diff34$tstat <- diff34$diff/diff34$diff_se
diff34$pval <- 2*pt(diff34$tstat,2999,lower.tail = T)
print(diff34)

diff45 <- as.data.frame(fig1$estimations)
diff45$diff <- fig5$cas-fig4$cas
diff45$diff_se <- sqrt(fig4$se^2+fig5$se^2)
diff45$tstat <- diff45$diff/diff45$diff_se
diff45$pval <- 2*pt(diff45$tstat,2999,lower.tail = T)
print(diff45)

diff_prnt <- diff45
diff_prnt$diff <- round(diff_prnt$diff*1000)
diff_prnt$diff_se <- round(diff_prnt$diff_se*1000)
diff_prnt$tstat <- round(diff_prnt$tstat,digits=2)
diff_prnt$pval <- round(diff_prnt$pval,digits=3)
print(diff_prnt)

