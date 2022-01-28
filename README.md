Enquête Covid CIRANO
--------------------

*Nouveau: vague 2 disponible*

Ce répertoire contient les données des enquêtes CIRANO-Léger 360 sur la prévalence de la COVID-19 au Québec en Janvier 2022 ainsi que les codes utilisées afin de produire les résultats qui se trouvent dans la note publiée au CIRANO, *Combien de personnes ont développé des symptômes ou contracté la COVID-19 au Québec ? Une étude exploratoire*.

## Données 

Les données bruttes sont sous format Excel: 
* Brut/MW14273_027A-VAGUE1-2.xlsx: résultats enquête Léger
* Brut/ISQ-QC-age-sexe.xlsx: données de population ISQ
* Brut/COVID_Xjan2022_numbers.xlsx: extractions données INSPQ

Le fichier de données nettoyés propre pouvant servir à des analyses est disponible en format Stata et csv à Propre/cirano-leger-covid.*. Les données sont cumulatives, i.e. elles contiennent à ce jour les données des vagues 1 et 2.  

## Codes

Les codes (scripts) se trouvent sous Codes:
* Codes/prepare.do: script Stata pour nettoyer les données, mettre les etiquettes, etc. Son execution produit les données sous Propre/
* Codes/nsum-vague1.R: Script R qui fait les tableaux et figures de la note CIRANO. L'utilisateur doit ajuster les répertoires de travail et de sortie des tableaux et graphiques. 
* Codes/histoire.R: Script R pour générer la Figure 1 de la note  sur l'évolution de la 5e vague. 
* Codes/PCR_moyen.xlsx: Calculs du nombre de test PCR des 7 derniers jours pour nos répondants interrogés sur la période du 13 au 18 janvier. 

## Questionnaire 

Ce répertoire contient le questionnaire ainsi que son extraction pour l'annexe de la note. 

Pour toutes questions additionnelles, vous pouvez contacter [Pierre-Carl Michaud](mailto:pierre-carl.michaud@hec.ca) ou [Vincent Boucher](mailto:vincent.boucher@ecn.ulaval.ca). 

