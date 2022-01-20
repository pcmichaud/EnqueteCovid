# Calculs NSUM - Semaine 1
library(foreign)
library(xtable)
library(ggplot2)
library(boot)
library(tidyverse)
library("readxl")
library(gridExtra)

rm(list=ls()) # vider l'espace de travail
# fixer le répertoire de travail
setwd("~/Dropbox (CEDIA)/EnqueteCOVID")
#setwd("~/Dropbox/EnqueteCOVID")

# xls files

df <- read_excel("Tableaux-Figures/COVID_14janv2022_numbers.xlsx",sheet='input')
df$date <- as.Date(df$date)
cas <- ggplot(df,aes(x=date)) + geom_line(aes(y=cas),colour='red') + 
    scale_x_date(breaks = scales::breaks_pretty(10)) + theme_bw() + xlab('') +
    ylab('nb de cas')
test <- ggplot(df,aes(x=date)) +geom_line(aes(y=tests),colour='blue') +
  scale_x_date(breaks = scales::breaks_pretty(10)) + theme_bw() + xlab('') +
  ylab('nb de tests')
pos<- ggplot(df) +geom_bar(aes(x=date,y=positif),stat="identity", fill="blue", alpha=0.7) +
  scale_x_date(breaks = scales::breaks_pretty(10)) + theme_bw() +
  ylab('fraction tests positif')
g <- arrangeGrob(cas,test,pos)
ggsave('Tableaux-Figures/histoire.png',g, dpi=1200)
