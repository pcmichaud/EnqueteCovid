* preparation de la base d'analyse


clear all 
set more off
capture log close

capture cd ~/cedia/EnqueteCovid

import excel using Brut/MW14273_027A-VAGUE1.xlsx, sheet(MW14273_027A-VAGUE1) firstrow

label var record "identifiant unique du répondant"

* region
rename Q0QC region
label var region "region administrative"
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

* sexe
rename sexe femme
recode femme (2=1) (1=0) (3=0)
label def ouinon 0 "non" 1 "oui"
label values femme ouinon 
label var femme "répondant est une femme"

* date
label var date "date (format Stata)"

* age
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
label var age "age du répondant (groupes de 5 ans)"

* semaine
label var semaine "semaine de l'enquête"

* langue
recode LANGU (1 4 7 = 1) (2 3 5 6=0) (9=.), gen(francais_langue)
label var francais_langue "français première langue"
label values francais_langue ouinon

recode LANGU (2 5 7 = 1) (1 3 4 6=0) (9=.), gen(anglais_langue)
label var anglais_langue "anglais première langue"
label values anglais_langue ouinon
 
recode LANGU (3 4 5 6 = 1) (1 2 7=0) (9=.), gen(autre_langue)
label var autre_langue "autres première langue"
label values autre_langue ouinon

rename FOY1 nbfam
label var nbfam "taille du ménage"

rename FOY2r1 nbenf_age0004
label var nbenf_age0004 "nb enfants 0-4 ans"
rename FOY2r2 nbenf_age0512
label var nbenf_age0512 "nb enfants 5-12 ans"
rename FOY2r3 nbenf_age1317
label var nbenf_age1317 "nb enfants 13-17 ans"

recode SCOL (1=1) (2=2) (3=3) (4/7=4) (9=.), gen(educ4)
label def educ4 1 "primaire" 2 "secondaire" 3 "collegial" 4 "universitaire"
label values educ4 educ4
label var educ4 "éducation (regroupé 4 groupes)"

rename Q1r1 symptome_fievre
label var symptome_fievre "symptomes de fievre"

rename Q1r2 symptome_genera 
label var symptome_genera "symptomes généraux"

rename Q1r3 symptome_respir 
label var symptome_respir "symptomes respiratoires"

rename Q1r4 symptome_gastro 
label var symptome_gastro "symptomes gastro-intestinaux"

egen nb_symptomes = anycount(symptome_*), values(1)
label var nb_symptomes "nombre de symptômes de la COVID"
egen po_symptomes = anymatch(symptome_*), values(1)
label var po_symptomes "au moins un symptôme de la COVID"

rename Q2 covid_isolement 
label var covid_isolement "répondant en isolement dans les 7 derniers jours"
recode covid_isolement (1=1) (2=0)
label values covid_isolement ouinon

rename Q3 covid_status
label var covid_status "statut covid 7 derniers jours"
label def covid 1 "oui" 2 "non" 3 "autodiagnostic"
label values covid_status covid
recode covid_status (1=1) (2 3 = 0), gen(covid_test_positif)
label var covid_test_positif "reçu un test positif 7 derniers jours"
recode covid_status (1 3 =1) (2 = 0), gen(covid_positif)
label var covid_positif "reçu un test positif ou autodiagnostic 7 derniers jours"

rename Q3A covid_test_type 
label var covid_test_type "type de test covid résultat positif (si test positif)"
label def covid_test_type 1 "Test PCR" 2 "Test rapide" 3 "Les deux"
label values covid_test_type covid_test_type

rename Q3B covid_prob_7p 
label var covid_prob_7p "probabilité symptômes COVID 7 prochains jours"

rename Q4 dra_covid
label var dra_covid "nb personnes dans réseau avec test positif COVID-19"
rename Q5 dra_isolement
label var dra_isolement "nb personnes dans réseau en isolement COVID-19"
rename Q6 dra_medecins
label var dra_medecins "nb médecins dans réseau"
rename Q7 dra_rpa
label var dra_rpa "nb personnes dans réseau RPA, CHSLD, RI-RTF"
rename Q8 dra_sansvaccin
label var dra_sansvaccin "nb personnes dans réseau sans vaccination"

rename Q9 vaccin_status
label var vaccin_status "statut vaccinal"
recode vaccin_status (99=1) (else=0),gen(vaccin_status_rf)
label var vaccin_status_rf "statut vaccinal: inconnu"
label values vaccin_status_rf ouinon
recode vaccin_status (1=1) (2 3 4=0) (99=.),gen(vaccin_status_3d)
label var vaccin_status_3d "statut vaccinal: 3 doses"
label values vaccin_status_3d ouinon

recode vaccin_status (2=1) (1 3 4=0) (99=.),gen(vaccin_status_2d)
label var vaccin_status_2d "statut vaccinal: 2 doses"
label values vaccin_status_2d ouinon

recode vaccin_status (3=1) (1 2 4=0) (99=.),gen(vaccin_status_1d)
label var vaccin_status_1d "statut vaccinal: 1 dose"
label values vaccin_status_1d ouinon

recode vaccin_status (4=1) (1 2 3=0) (99=.),gen(vaccin_status_0d)
label var vaccin_status_0d "statut vaccinal: aucune dose"
label values vaccin_status_0d ouinon


rename EMPLOr1 emploi_temps_plein
label var emploi_temps_plein "travail à temps plein"
rename EMPLOr2 emploi_temps_partiel
label var emploi_temps_partiel "travail à temps partiel"
egen emploi_salarie = anymatch(emploi_temps_plein emploi_temps_partiel), values(1)
label var emploi_salarie "emploi salarié (temps plein ou partiel)"
rename EMPLOr3 emploi_autonome
label var emploi_autonome "travailleur autonome"
egen travailleur = anymatch(emploi_autonome emploi_salarie), values(1)
label var travailleur "travailleur (salarié ou autonome)"
rename EMPLOr4 etudiant
label var etudiant "étudiant"
rename EMPLOr5 foyer
label var foyer "au foyer"
rename EMPLOr6 chomeur
label var chomeur "sans emploi"
rename EMPLOr7 retraite
label var retraite "retraité"

rename Q10 travail_lieu
label def travail 1 "presentiel" 2 "teletravail" 3 "les deux" 4 "absent"
label values travail_lieu travail
label var travail_lieu "lieu de travail"

rename Q11 secteur 
#d ;
label def secteur 1 "agriculture" 2 "ressources naturelles" 3 "srvs. publics" 
	4 "construction" 5 "fabrication" 6 "commerce gros" 7 "commerce detail" 8 "transport" 
	9 "information et culture" 10 "finances et assurances" 11 "immobiliers et location" 12 "srvs profs,science,tech"
	13 "gestion" 14 "srvs. admin, soutien, dechets" 15 "enseignement" 16 "sante et ss" 17 "arts et loisirs" 18 "heberg-restauration"
	19 "autres srvs" 20 "adm publiques";
#d cr
label values secteur secteur 
label var secteur "secteur d'activité (si travailleur)"

rename MARIT mstat 
recode mstat (99=.)
label var mstat "statut civil"
label def mstat 1 "celibataire" 2 "marie ou conj. fait" 3 "veuf(ve)" 4 "separe" 5 "divorce"
label values mstat mstat

rename REVEN revenu 
recode revenu (99=.)
label def rev 1 "<20k" 2 "20-40k" 3 "40-60k" 4 "60-80k" 5 "80-100k" 6 ">100k"
label values revenu rev
label var revenu "revenu du menage 2021"

* poids échantillonal Léger
rename  PONDPOP poids
label var poids "poids échantillonal Léger"

generate eventdate = dofc(date)
format eventdate %td
gen jour = day(eventdate)
label var jour "journée"



#d ;
keep record date semaine region femme age *_langue nbfam nbenf_a* educ4 symptome_* nb_symptomes po_symptomes
covid_isolement covid_status covid_test_positif covid_positif covid_test_type covid_prob_7p dra_* 
vaccin_status* emploi_temps_plein emploi_temps_partiel emploi_salarie emploi_autonome travailleur 
etudiant foyer chomeur retraite travail_lieu secteur mstat revenu poids jour;
order record date semaine region femme age *_langue nbfam nbenf_a* educ4 symptome_* nb_symptomes po_symptomes
covid_isolement covid_status covid_test_positif covid_positif covid_test_type covid_prob_7p dra_* 
vaccin_status* emploi_temps_plein emploi_temps_partiel emploi_salarie emploi_autonome travailleur 
etudiant foyer chomeur retraite travail_lieu secteur mstat revenu poids jour;
#d cr

label data "Enquête CIRANO-Léger sur la prévalence de la COVID-19, janvier 2022"

saveold Propre/cirano-leger-covid.dta, replace version(11)

outsheet * using Propre/cirano-leger-covid.csv , comma replace

des 

sum *

capture log close

exit





