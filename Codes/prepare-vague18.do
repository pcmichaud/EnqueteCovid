* Préparation de la base d'analyse (vague 18)

clear all 
set more off
capture log close

capture cd ~/cedia/EnqueteCovid
capture cd C:\Users\Alexandre Prud'homme\Dropbox\EnqueteCOVID

import excel using "Brut\MW14273_028A-VAGUE18.xlsx", sheet("MW14273_028A-VAGUE18") firstrow

******************************
label var record "identifiant unique du répondant"
******************************
* Date de réponse au questionnaire.

generate eventdate = dofc(date)
format eventdate %td
label var eventdate "journée"

label var date "date (format Stata)"
******************************
* Région de résidence.
rename Q0QC region
label var region "Région administrative"
#d ;
label def region
1	"Bas-Saint-Laurent"
2	"Saguenay-Lac-Saint-Jean"
3	"Capitale-Nationale"
4	"Mauricie"
5	"Estrie"
6	"Montréal"
7	"Outaouais"
8	"Abitibi-Témiscamingue"
9	"Côte-Nord"
10	"Nord-du-Québec"
11	"Gaspésie/Îles-de-la-Madeleine"
12	"Chaudière-Appalaches"
13	"Laval"
14	"Lanaudière"
15	"Laurentides"
16	"Montérégie"
17	"Centre-du-Québec";
#d cr
label values region region

tab region
recode region (1=2) (2=2) (3=3) (4=3) (5=3) (6=1) (7=4) (8=4) (9=2) (10=2) (11=2) (12=3) (13=1) (14=4) (15=4) (16=1) (17=3), gen (region1)
label var region1 "Régions regroupées"
label def region1 1 "Sud du Québec (06,13,16)" 2 "Est et Nord du Québec (01,02,09,10,11)" 3 "Centre du Québec (03,04,05,12,17)" 4 "Ouest du Québec (07,08,14,15)" 
label values region1 region1
tab2 region region1
order region1, after(region)

tab REGIO
rename REGIO region2
label var region2 "RMR Montréal vs RMR Québec vs Autres régions"
label def region2 1 "RMR-Montréal" 2 "RMR-Québec" 3 "Autres régions" 
label values region2 region2
tab region2
order region2, after(region1)
******************************
* Sexe.
rename sexe sexe1
recode sexe1 (2=1) (1=0) (3=0)
label def sexe 0 "Homme" 1 "Femme"
label values sexe1 sexe 
label var sexe1 "Sexe"
******************************
* Age.
#d ;
recode age (0 99=.) (1=18) (2=25) (3=30) (4=35) (5=40) (6=45) 
(7=50) (8=55) (9=60) (10=65) (11=70) (12=75);
label def age 
	18	"18-24"
	25	"25-29"
	30	"30-34"
	35	"35-39"
	40	"40-44"
	45	"45-49"
	50	"50-54"
	55	"55-59"
	60	"60-64"
	65	"65-69"
	70	"70-74"
	75	"75+";
#d cr
label values age age
label var age "Groupe d'âge"

recode age (18/25=1) (30/35=2) (40/45=3) (50/55=4) (60/65=5) (70/75=6), gen (age_1)
label def age_1 1 "18-29 ans" 2 "30-39 ans" 3 "40-49 ans" 4 "50-59 ans" 5 "60-69 ans" 6 "70 ans ou plus"
label values age_1 age_1
label var age_1 "Groupe d'âge (en 6 catégories)"

recode age (18/25=1) (30/35=2) (40/45=3) (50/55=4) (60/75=5), gen (age_2)
label def age_2 1 "18-29 ans" 2 "30-39 ans" 3 "40-49 ans" 4 "50-59 ans" 5 "60 ans ou plus"
label values age_2 age_2
label var age_2 "Groupe d'âge (en 5 catégories)"

recode age (18/25=5) (30/35=4) (40/45=3) (50/55=2) (60/75=1), gen (age_3)
label def age_3 1 "60 ans ou plus" 2 "50-59 ans" 3 "40-49 ans" 4 "30-39 ans" 5 "18-29 ans"
label values age_3 age_3
label var age_3 "Groupe d'âge (en 5 catégories inversées)"
tab2 age_3 age
******************************
* Semaine de l'enquête.
label var semaine "semaine de l'enquête"
******************************
* Langue.
tab QLANG
rename QLANG LangueQuest
label var LangueQuest "Langue du questionnaire"
recode LangueQuest (1=0) (2=1)
label def LangueQuest 0 "Anglais" 1 "Français"
label values LangueQuest LangueQuest
tab LangueQuest

tab LANGU
rename LANGU LangueMat
label var LangueMat "Langue maternelle"
label def langueMat 1 "Français" 2 "Anglais" 3 "Autre" 4 "Français et autres" 5 "Anglais et autres" 6 "Autres et autres" 7 "Français et anglais" 9 "Refus"
label values LangueMat LangueMat

recode LangueMat (1 4 7 = 1) (2 3 5 6=0) (9=.), gen(francais_langue)
label var francais_langue "Français première langue"
label def ouinon 0 "Non" 1 "Oui"
label values francais_langue ouinon

recode LangueMat (2 5 7 = 1) (1 3 4 6=0) (9=.), gen(anglais_langue)
label var anglais_langue "Anglais première langue"
label values anglais_langue ouinon
 
recode LangueMat (3 4 5 6 = 1) (1 2 7=0) (9=.), gen(autre_langue)
label var autre_langue "Autre première langue"
label values autre_langue ouinon
******************************
* Code postal.
tab FSA
rename FSA CP
label var CP "Code postal"
******************************
* Ménage.
rename FOY1 nbfam
label var nbfam "Taille du ménage"

rename FOY2r1 nbenf_age0004
label var nbenf_age0004 "Nb d'enfants de 0-4 ans"
rename FOY2r2 nbenf_age0512
label var nbenf_age0512 "Nb d'enfants de 5-12 ans"
rename FOY2r3 nbenf_age1317
label var nbenf_age1317 "Nb d'enfants de 13-17 ans"
**
recode nbenf_age0004 (0=0) (1/10=1) (99=.), generate(Enfant0_4)
label values Enfant0_4 ouinon 
label var Enfant0_4 "A au moins 1 enfant de 0-4 ans"
tab Enfant0_4

recode nbenf_age0512 (0=0) (1/10=1) (99=.), generate(Enfant5_12)
label values Enfant5_12 ouinon 
label var Enfant5_12 "A au moins 1 enfant de 5-12 ans"
tab Enfant5_12

recode nbenf_age1317 (0=0) (1/10=1) (99=.), generate(Enfant13_17)
label values Enfant13_17 ouinon 
label var Enfant13_17 "A au moins 1 enfant de 13-17 ans"
tab Enfant13_17
******************************
* Niveau de scolarité.
recode SCOL (1=1) (2=2) (3=3) (4/7=4) (9=.), gen(educ4)
label def educ4 1 "Primaire" 2 "Secondaire" 3 "Collégial" 4 "Universitaire"
label values educ4 educ4
label var educ4 "Niveau de scolarité (en 4 catégories)"

recode educ4 (1/2=1) (3=2) (4=3), gen(educ3)
label def educ3 1 "Secondaire ou moins" 2 "Collégial" 3 "Universitaire"
label values educ3 educ3
label var educ3 "Niveau de scolarité (en 3 catégories)"

******************************
* Symptômes COVID-19.
rename Q1r1 symptome_fievre
label var symptome_fievre "Symptôme de fièvre au cours des 7 derniers jours"
label values symptome_fievre ouinon 

rename Q1r2 symptome_genera 
label var symptome_genera "Symptômes généraux (mal de tête, fatigue, etc) au cours des 7 derniers jours"
label values symptome_fievre ouinon 

rename Q1r3 symptome_respir 
label var symptome_respir "Symptômes respiratoires (toux, mal de gorge, etc) au cours des 7 derniers jours"
label values symptome_respir ouinon 

rename Q1r4 symptome_gastro 
label var symptome_gastro "Symptômes gastro-intestinaux (vomissements, diarrhée, etc) au cours des 7 derniers jours"
label values symptome_gastro ouinon 

egen nb_symptomes = anycount(symptome_*), values(1)
label var nb_symptomes "Nombre de symptômes de la COVID au cours des 7 derniers jours"
egen po_symptomes = anymatch(symptome_*), values(1)
label var po_symptomes "A ressenti au moins un symptôme de la COVID au cours des 7 derniers jours"
******************************
* Isolement dû à la COVID-19.
rename Q2 covid_isolement 
label var covid_isolement "A été en isolement dû à la COVID-19 au cours des 7 derniers jours"
recode covid_isolement (1=1) (2=0)
label values covid_isolement ouinon
******************************
* Statut COVID-19.
rename Q3 covid_status
label var covid_status "Statut COVID au cours des 7 derniers jours"
label def covid 1 "Oui, test positif" 2 "Non, pas de test positif" 3 "Non, mais autodiagnostic"
label values covid_status covid

recode covid_status (1=1) (2 3 = 0), gen(covid_test_positif)
label var covid_test_positif "A reçu un test positif au cours des 7 derniers jours"
label values covid_test_positif ouinon

recode covid_status (1 3 =1) (2 = 0), gen(covid_positif)
label var covid_positif "A reçu un test positif ou autodiagnostic au cours des 7 derniers jours"
label values covid_positif ouinon

rename Q3A covid_test_type 
label var covid_test_type "Type de test COVID utilisé (si résultat positif)"
label def covid_test_type 1 "Test PCR" 2 "Test rapide" 3 "Les deux"
label values covid_test_type covid_test_type

******************************
* Risque d'infection perçue.
rename Q3B covid_prob_7p 
label var covid_prob_7p "Probabilité perçue de développer des symptômes au cours des 7 prochains jours"

recode covid_prob_7p (0 = 0 "0%") (1/49 = 1 "1-49%") (50 = 2 "50%") (50/99 = 3 "50-99%") (100= 4 "100%"), generate (covid_prob_7p_cat4)
label var covid_prob_7p_cat4 "Probabilité perçue de développer des symptômes au cours des 7 prochains jours (5 catégories)"
******************************
* Autodéclaration du test positif sur la plateforme gouvernementale.
tab Q3C
rename Q3C plateforme_autodec 
label var plateforme_autodec "Déclaration du résultat du test rapide sur la plateforme gouvernementale"
recode plateforme_autodec (1=1) (2=0)
label values plateforme_autodec ouinon
tab plateforme_autodec
******************************
* Statut COVID-19.
rename Q4 dra_covid
label var dra_covid "Nb de personnes du réseau avec résultat positif au cours des 7 derniers jours"
rename Q5 dra_isolement
label var dra_isolement "Nb de personnes du réseau en isolement au cours des 7 derniers jours"
rename Q6 dra_medecins
label var dra_medecins "Nb de médecins connus"
rename Q7 dra_rpa
label var dra_rpa "Nb personnes connues qui résident en RPA, CHSLD ou RI-RTF"
rename Q8 dra_sansvaccin
label var dra_sansvaccin "Nb personnes du réseau sans dose de vaccin contre la COVID-19"
******************************
* Statut vaccinal.
rename Q9 vaccin_status
label var vaccin_status "Statut vaccinal"
recode vaccin_status (99=1) (else=0),gen(vaccin_status_rf)
label var vaccin_status_rf "Statut vaccinal: inconnu"
label values vaccin_status_rf ouinon

recode vaccin_status (5=1) (1 2 3 4=0) (99=.),gen(vaccin_status_4d)
label var vaccin_status_4d "Statut vaccinal: 4 doses"
label values vaccin_status_4d ouinon

recode vaccin_status (1=1) (2 3 4 5=0) (99=.),gen(vaccin_status_3d)
label var vaccin_status_3d "Statut vaccinal: 3 doses"
label values vaccin_status_3d ouinon

recode vaccin_status (2=1) (1 3 4 5=0) (99=.),gen(vaccin_status_2d)
label var vaccin_status_2d "statut vaccinal: 2 doses"
label values vaccin_status_2d ouinon

recode vaccin_status (3=1) (1 2 4 5=0) (99=.),gen(vaccin_status_1d)
label var vaccin_status_1d "statut vaccinal: 1 dose"
label values vaccin_status_1d ouinon

recode vaccin_status (4=1) (1 2 3 5=0) (99=.),gen(vaccin_status_0d)
label var vaccin_status_0d "statut vaccinal: aucune dose"
label values vaccin_status_0d ouinon
**********************************
* Emploi.
tab EMPLOr1

generate sit_emploi = .
 replace sit_emploi = 1 if EMPLOr1 == 1| EMPLOr3 == 3
 replace sit_emploi = 2 if EMPLOr2 == 2
 replace sit_emploi = 3 if EMPLOr4 == 4
 replace sit_emploi = 4 if EMPLOr5 == 5| EMPLOr6 == 6
 replace sit_emploi = 5 if EMPLOr7 == 7
 replace sit_emploi = 6 if EMPLOr9 == 9
label var sit_emploi "Situation d'emploi"
label define sit_emploi 1 "Employé temps plein ou travailleur autonome" 2 "Employé temps partiel" 3 "Étudiant" 4 "Au foyer ou sans emploi" 5 "Retraité" 6 "Refus"
label values sit_emploi sit_emploi
tab sit_emploi
mvdecode sit_emploi, mv(6)

rename EMPLOr1 emploi_temps_plein
label var emploi_temps_plein "Travail à temps plein"
rename EMPLOr2 emploi_temps_partiel
label var emploi_temps_partiel "Travail à temps partiel"
egen emploi_salarie = anymatch(emploi_temps_plein emploi_temps_partiel), values(1)
label var emploi_salarie "emploi salarié (temps plein ou partiel)"
rename EMPLOr3 emploi_autonome
label var emploi_autonome "travailleur autonome"
egen travailleur = anymatch(emploi_autonome emploi_salarie), values(1)
label var travailleur "Travailleur (salarié ou autonome)"
rename EMPLOr4 etudiant
label var etudiant "Étudiant"
rename EMPLOr5 foyer
label var foyer "Au foyer"
rename EMPLOr6 chomeur
label var chomeur "Sans emploi"
rename EMPLOr7 retraite
label var retraite "Retraité"

rename Q10 travail_lieu
label def travail_lieu 1 "Présentiel" 2 "Télétravail" 3 "Les deux" 4 "Absent du travail"
label values travail_lieu travail_lieu
label var travail_lieu "Lieu de travail cette semaine"

rename Q11 secteur 
#d ;
label def secteur 1 "Agriculture" 2 "Ressources naturelles" 3 "Services publics" 
	4 "Construction" 5 "Fabrication" 6 "Commerce de gros" 7 "commerce de détail" 8 "Transport" 
	9 "Information et culture" 10 "Finances et assurances" 11 "Immobiliers et location" 12 "Services prof.,science et techologie"
	13 "Gestion" 14 "Services admin., soutien, déchets" 15 "Enseignement" 16 "Santé et services sociaux" 17 "Arts et loisirs" 18 "Hébergement ou restauration"
	19 "Autres services" 20 "Administration publique";
#d cr
label values secteur secteur 
label var secteur "Secteur d'activité (si travailleur)"

recode secteur (1/2=1) (4=1) (10/14=2) (19=2) (3=3) (20=3) (7=4) (9=4) (17/18=4) (5/6=5) (8=5) (15=6) (16=7), gen (secteur_1)
label def secteur_1 1 "Agriculture, exploitation, construction" 2 "Finance, admin, immobilier, gestion, professionnel" 3 "Admin/Services publics" 4 "Culture, loisirs, commerce de détail" 5 "Transport, commerce de gros, fabrication" 6 "Enseignement" 7 "Santé"
label values secteur_1 secteur_1
label var secteur_1 "Secteur d'activité regroupé (si travailleur)"
tab secteur_1
********************
tab Q12
rename Q12 ResultPos_miDec
label var ResultPos_miDec "A reçu un résultat positif depuis mi-déc"
recode ResultPos_miDec (1=1) (2=0) (3=2)
label def ResultPos_miDec 0 "Non" 1 "Oui" 2 "Non, mais autodiagnostic"
label values ResultPos_miDec ResultPos_miDec
tab ResultPos_miDec

recode ResultPos_miDec (0=0) (1/2=1),gen(ResultPos_miDec1)
label var ResultPos_miDec1 "A reçu un test positif depuis mi-déc. (+ autodiagnostic)"
label values ResultPos_miDec1 ouinon
tab ResultPos_miDec1
********************
tab Q13
rename Q13 ResultPos_foyer_miDec
label var ResultPos_foyer_miDec "Nb de personnes du foyer avec résultat positif (depuis mi-déc pour T4-T15)"
tab ResultPos_foyer_miDec
********************
tab Q13Ar1
rename Q13Ar1 ResultPos_enf0_4_miDec
label var ResultPos_enf0_4_miDec "Nb d'enfants (0-4 ans) avec résultat positif (depuis mi-déc pour T4-T15)"
tab ResultPos_enf0_4_miDec
********************
tab Q13Ar2
rename Q13Ar2 ResultPos_enf5_12_miDec
label var ResultPos_enf5_12_miDec "Nb d'enfants (5-12 ans) avec résultat positif (depuis mi-déc pour T4-T15)"
tab ResultPos_enf5_12_miDec
********************
tab Q13Ar3
rename Q13Ar3 ResultPos_enf13_17_miDec
label var ResultPos_enf13_17_miDec "Nb d'enfants (13-17 ans) avec résultat positif (depuis mi-déc pour T4-T15)"
tab ResultPos_enf13_17_miDec
********************
generate ResultPos_enfantTotal_miDec = ResultPos_enf0_4_miDec + ResultPos_enf5_12_miDec + ResultPos_enf13_17_miDec, after(ResultPos_enf13_17_miDec)
label var ResultPos_enfantTotal_miDec "Nb d'enfants (0-17 ans) avec résultat positif (depuis mi-déc pour T4-T15)" 
tab ResultPos_enfantTotal_miDec
*********************************************************************
* Réinfection.

tab Q14AA
label var Q14AA "A déjà été infecté par la COVID-19 dans le passé (parmi ceux pas infectés pas cette semaine)"
recode Q14AA (1=2) (2=3) (3=1)
label def Q14AA 1 "Non, jamais" 2 "Oui, une fois" 3 "Oui, plus d'une fois"
label values Q14AA Q14AA
mvencode Q14AA, mv(0)
tab Q14AA

tab Q14
label var Q14 "A déjà été infecté par la COVID-19 dans le passé (Parmi ceux infectés cette semaine)"
recode Q14 (1=2) (2=3) (3=1)
label def Q14 1 "Non, jamais" 2 "Oui, une fois" 3 "Oui, plus d'une fois"
label values Q14 Q14
mvencode Q14, mv(0)
tab Q14

generate Infection_passee = .
 replace Infection_passee = 1 if Q14AA == 1 | Q14 == 1
 replace Infection_passee = 2 if Q14AA == 2 | Q14 == 2
 replace Infection_passee = 3 if Q14AA == 3 | Q14 == 3
label var Infection_passee "A déjà été infecté par la COVID-19 (avant cette semaine)"
label def Infection_passee 1 "Non, jamais" 2 "Oui, une fois" 3 "Oui, plus d'une fois"
label values Infection_passee Infection_passee
tab Infection_passee

generate Infection_passee1 = .
 replace Infection_passee1 = 1 if Infection_passee == 2 | Infection_passee == 3
 replace Infection_passee1 = 0 if Infection_passee == 1
label var Infection_passee1 "A déjà été infecté par la COVID-19 (avant cette semaine)"
label def Infection_passee1 0 "Non, jamais" 1 "Oui, au moins une fois"
label values Infection_passee1 Infection_passee1
tab Infection_passee1

tab Q14A
rename Q14A Date_infection_passee
label var Date_infection_passee "Date de l'infection passée à la COVID'"
label def Date_infection_passee 1 "Avant mars 2021" 2 "Entre avril 2021 et novembre 2021" 3 "Entre décembre 2021 et février 2022" 4 "Depuis mars 2022"
label values Date_infection_passee Date_infection_passee
tab Date_infection_passee

mvencode ResultPos_miDec1 if semaine >=16, mv(999)
tab ResultPos_miDec1 if semaine>=16
replace ResultPos_miDec1 = 1 if semaine>=16 & Date_infection_passee >= 3
recode ResultPos_miDec1 (999 = 0)
tab ResultPos_miDec1 if semaine>=16

********************************************************
rename MARIT mstat 
recode mstat (99=.)
label var mstat "Statut civil"
label def mstat 1 "Célibataire" 2 "Marié ou conjoint de fait" 3 "Veuf" 4 "Separé" 5 "Divorcé"
label values mstat mstat

rename REVEN revenu 
recode revenu (99=.)
label def revenu 1 "<20k" 2 "20-40k" 3 "40-60k" 4 "60-80k" 5 "80-100k" 6 ">100k"
label values revenu revenu
label var revenu "Revenu du ménage (2021)"
********************************************************
* Pondération.
rename PONDPOP poids
label var poids "Poids échantillonal (Léger)"

rename PONDWEIGHT poids1
label var poids1 "Poids (Léger)"
********************************************************

#d ;
keep record eventdate semaine region region1 region2 LangueQuest CP LangueMat sexe1 age age_1 age_2 age_3 *_langue nbfam nbenf_a* educ4 educ3 symptome_* nb_symptomes po_symptomes
covid_isolement covid_status covid_test_positif covid_positif covid_test_type covid_prob_7p covid_prob_7p_cat4 plateforme_autodec dra_* nbenf_age0004 nbenf_age0512 nbenf_age1317 Enfant0_4 Enfant5_12 Enfant13_17
vaccin_status* sit_emploi emploi_temps_plein emploi_temps_partiel emploi_salarie emploi_autonome travailleur etudiant foyer chomeur retraite travail_lieu secteur secteur_1 ResultPos_miDec ResultPos_foyer_miDec ResultPos_miDec1 ResultPos_enf0_4_miDec ResultPos_enf5_12_miDec ResultPos_enf13_17_miDec ResultPos_enfantTotal_miDec Q14AA Q14 Infection_passee Infection_passee1 Date_infection_passee mstat revenu poids poids1;
order record eventdate semaine region region1 region2 CP LangueQuest LangueMat *_langue sexe1 age age_1 age_2 age_3 nbfam nbenf_a* educ4 educ3 revenu sit_emploi emploi_temps_plein emploi_temps_partiel emploi_salarie emploi_autonome travailleur etudiant foyer chomeur retraite mstat  travail_lieu secteur secteur_1 symptome_* nb_symptomes po_symptomes
covid_isolement covid_status covid_test_positif covid_positif covid_test_type covid_prob_7p covid_prob_7p_cat4 plateforme_autodec dra_* nbenf_age0004 nbenf_age0512 nbenf_age1317 Enfant0_4 Enfant5_12 Enfant13_17 vaccin_status*  ResultPos_miDec ResultPos_foyer_miDec ResultPos_miDec1 ResultPos_enf0_4_miDec ResultPos_enf5_12_miDec ResultPos_enf13_17_miDec ResultPos_enfantTotal_miDec Q14AA Q14 Infection_passee Infection_passee1 Date_infection_passee poids poids1;
#d cr

label data "Enquête CIRANO-Léger sur la prévalence de la COVID-19, 18 mai 2022"

saveold "C:\Users\Alexandre Prud'homme\Dropbox\EnqueteCOVID\Propre\cirano_leger_covid_18.dta", replace version(11)

des

sum *

capture log close

exit