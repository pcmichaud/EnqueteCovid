Enquête Covid CIRANO
--------------------

*Nouveau: vague 11 disponible*

Ce répertoire contient les données des enquêtes CIRANO-Léger 360 sur la prévalence de la COVID-19 au Québec en Janvier 2022 ainsi que les codes utilisées afin de produire les résultats qui se trouvent dans la note publiée au CIRANO, *Combien de personnes ont développé des symptômes ou contracté la COVID-19 au Québec ? Une étude exploratoire*, ainsi que dans les suppléments hebdomadaires.

## Données 

Les données brutes sont sous format Excel: 
* Brut/MW14273_027A-VAGUE1-<dernière vague>.xlsx: résultats enquête Léger
* Brut/ISQ-QC-age-sexe.xlsx: données de population ISQ
* Brut/COVID_Xjan2022_numbers.xlsx: extractions données INSPQ

Le fichier de données nettoyés propre pouvant servir à des analyses est disponible en format Stata et csv à Propre/cirano-leger-covid.*. Les données pour les chaques vagues sont présentées dans des fichiers séparés.

## Codes

Les codes (scripts) se trouvent sous Codes:
* Codes/prepare.do: script Stata pour nettoyer les données, mettre les etiquettes, etc. Son execution produit les données sous Propre/
* Codes/nsum-flex.R: Script R qui fait les calculs pour chaque vague. L'utilisateur doit ajuster les répertoires de travail et de sortie des tableaux et graphiques. 
* Codes/Figures_vagues.R: Script R pour faire la figure des deux vagues
* Codes/histoire.R: Script R pour générer la Figure sur l'évolution de la 5e vague. 
* Codes/PCR_moyen.xlsx: Calculs du nombre de test PCR des 7 derniers jours pour nos répondants interrogés sur la période de chaque enquête. 

## Questionnaire 

Ce répertoire contient le questionnaire ainsi que son extraction pour l'annexe. 

Pour toutes questions additionnelles, vous pouvez contacter [Pierre-Carl Michaud](mailto:pierre-carl.michaud@hec.ca) ou [Vincent Boucher](mailto:vincent.boucher@ecn.ulaval.ca). 

