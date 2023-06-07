# Rapport Technique Exploitation BDD
*Illies Douhab / Xavier Moyon*	
## ***Exercice 1 : Comprendre les données***
	

### Athlete_events.csv	
			
#### Nombre de lignes 
				
	cat athlete_events.csv | wc -l --> 271117 lignes

#### Première ligne
							
	cat athlete_events.csv | head -n1 --> "ID","Name","Sex","Age","Height","Weight","Team","NOC","Games","Year","Season","City","Sport","Event","Medal"
	
#### Séparateur de champs

	Le séparateur de champs est la virgule

#### Représentation d'une ligne

**Un retour à la ligne**
				
#### Nombre de colonnes 
				
	cat  athlete_events.csv |head -n1 | tr "," "\n" | wc -l --> 15


#### Colonne de distinction entre JO Hiver et JO ETE
				
	Season permet de distinguer les deux JO

#### Reference Jean Claude Killy

	cat  athlete_events.csv | grep "Jean-Claude Killy" | wc -l --> 6
			
#### Encodage Fichier 

	file -e encoding athlete_events.csv --> athlete_events.csv: ASCII text, with CRLF line terminators	
			
#### Importation Données
				
1. On identifie les données et leurs types

2. On crée la table import en utilisant des types textes pour récupérer toutes les données (On effectuera les conversion après pour éviter )
				
3. Pas besoin de convertir les données 

4. On indique qu'il y a un header 


### noc_regions.csv	

#### Conversion	

	cat noc_regions.csv | tr '\r\n' '\n' > new_noc_region.csv
		
#### Nombre de lignes 
	
	cat new_noc_region.csv | wc -l --> 230


#### Première ligne
	
	cat new_noc_region.csv | head -n1 --> NOC,region,notes

		
#### Séparateur de champs

	cat new_noc_region.csv | head -n1 --> NOC,region,notes

#### Représentation d'une ligne

	cat new_noc_region.csv | head -n3
		NOC,region,notes
		AFG,Afghanistan,
		AHO,Curacao,Netherlands Antilles
	

#### Nombre de colonnes 

	cat new_noc_region.csv | head -n1 | tr "," "\n" | wc -l --> 3


#### Encodage 

	file -e encoding new_noc_region.csv --> new_noc_region.csv: ASCII text

## Exercice 2 : **Importation**

### Table Import 
1. Création table import 

		Create temp Table import (
		
		 ID int,
		 Name varchar(120), 
		 Sex varchar(5) ,
		 Age text,
		 Height text,
		 Weight text,
		 Team text,
		 NOC varchar(3),
		 Games text,
		 Year int,
		 Season text,
		 City varchar(60),
		 Sport varchar(50),
		 Event varchar(250),
		 Medal text
		);
	Apres avoir consulté les données nous avons restreint le plus que possibles les types contenu dans la tables , cependant certaines colonnes néscecitait un typage plus large (dû a des exceptions)(Height , Weight , Age (Pour Age les valeur non renseigné étaient inscrite en 'NA' ne correspondant pas au type int souhaité ))

2.	Remplir La Table 
	
	La commande á utiliser pour l'importation est :
		`\copy import from data.csv with(format CSV ,delimiter ',' , Header);`
	On précise le format (CSV) , le délimiteur de colonne(' , ') ainsi que la présence d'un en-tête.
	
3. Suppression des données incorrectes
	
	Pour supprimer les données incorrectes (Années < 1920 ou/et épreuves artistique) on utilise la commandes suivantes :
		`delete from import where Year<1920 OR Sport LIKE '%Art%';`


4. Importer la table noc_région
	
	Pour l'importation on utilise la commande suivante :
		`\copy noc from new_noc_region.csv with (format CSV ,delimiter ',' , Header);`
		On précise le format (CSV) , le délimiteur de colonne(' , ') ainsi que la présence d'un en-tête.
	(Dans notre cas le document csv noc_regions.csv s'appelle new_noc_region car le fichier csv de noc_region n'était pas sur un format adéquat au départ)
	

## Exercice 3 : **Requêtage sur les fichiers de départ (import et noc)**

1. Nombre de colonnes dans import
	
	Pour connaitre le nombre de colonne dans la table import, on utilise la commande suivante :
	
		select  count(COLUMN_NAME)
		from information_schema.columns
		where table_name =  'import';
	On utilise les données de la metabase sur les colonnes (information_schema.columns) , on ne récupère que les lignes de la tables import (Where table_name = 'import') et on sélectionne le nombre de lignes (SELECT Count(COLUMN_NAME)) 

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096788441481617418/image.png)

2. Nombre de lignes dans import
	
	Pour connaitre le nombre de ligne dans la table import, on utilise la commande suivante :
	
		`Select  count(*) from import;`
	Ici pas besoin d'utiliser la métabase étant donné que nous comptons les lignes et non colonnes.
![enter image description here](https://media.discordapp.net/attachments/1027631359591718962/1096788533118779412/image.png?width=123&height=145)

3. Nombres de code NOC dans noc
	
	Pour connaitre le nombre de code NOC dans la table noc, on utilise la commande suivante :
	
		SELECT  count(DISTINCT noc) FROM noc WHERE noc is  not  null;

	Ici on compte le nombre de noc différent dans la table noc, lorsque le code n'est pas null 
	
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096788635023589576/image.png)
4. Nombre d'athlètes différents
	Pour connaitre le nombre d'athlètes différents dans la table import, on utilise la commande suivante :

		SELECT  count(DISTINCT id) FROM import where id is  not  null;
	Ici on utilise un Distinct id car un athlète peut apparaitre dans plusieurs lignes (Si il a participé a plusieurs événement)
	
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096789181084213268/image.png)

5. Nombre de Médailles d'or 
	
	Pour connaitre le nombre de médaille d'or dans la table import, on utilise la commande suivante :

		SELECT  count(*) FROM import WHERE medal ='Gold';

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096790050810908763/image.png)
6. Nombre de lignes référençant Carl Lewis

	Pour connaitre le nombre de lignes référençant Carl Lewis  dans la table import, on utilise la commande suivante :

		SELECT  count(*)  FROM import 
		where name LIKE  '%Carl%Lewis%';

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096790251025989692/image.png)
## Exercice 4 : Ventilation des Données

### Q1
#### **1. **MCD Des Jeux Olympiques****

![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096522286753915021/image.png)

#### **2. MLD :**

Athlete(<u>ID</u>,Name,Sex) 
	Pays(<u>NOC</u>,Region,Notes)
	Team(<u>IDTeam</u>,Team,#NOC)
	Ville(<u>IDV</u>,NomVille)
	Médaille(<u>IdM</u>,NomMedal)
	JO(<u>IdJO</u>,Season,Annee)
	SousDiscipline(<u>IdSD</u>,SDname,#idS) 
	Discipline(<u>IdS</u>,Sport)
	Participe(<u>#ID,#IdTeam,#idV,#idJO,#idSD,#idM</u>, poids, taille, âge)

Nous avons tenté de créer un MCD permettant d'éviter au plus les redondances, notamment pour les équipe étant qu'une équipe ne change pas de pays il semble essentiel de créer une table pays indépendante de même pour les sous disciplines une sous discipline n'appartient que á une seule discipline.
Ce MCD permet une approche plus intuitive.

 **3. Ajout des données dans les tables correspondantes**

#### Différents problèmes :
1. Erreur dans la table noc , en effet nous avons constaté un plus tard que le noc de Singapour était différent dans la table import et dans la table noc nous avons donc du utilisé la commande suivante pour corriger l'erreur :

		UPDATE PAYS set NOC='SGP'  WHERE NOC='SIN'; 

2. Nous avons constaté problème avec l'âge des athlètes en effet lorsque l'âge de ces derniers n'est pas renseigné la valeur de base est 'NA' ce qui ne correspond á un int, nous avons donc du corriger ces problèmes en mettant á null tout les 'NA' avec cette commande :  
	`Update import set Age =  Null  Where Age =  'NA';`
	

3. Nous avons constaté le même problème que ci-dessus avec Weight et Height nous avons donc agit de la même manière avec ces commandes :
	
		Update import set Weight =  Null  Where Weight =  'NA';
		Update import set Height =  Null  Where Height =  'NA';

4. Pour les problèmes de type, il ne faut pas oublier de convertir les données text en format int/numeric lors de la ventilation 
		Exemple :  

		CAST(weight AS  numeric(5,2)) , CAST(height AS  numeric(5,2)) ,CAST( Age as  int) -- Dans un select
### Scripts de Création des Tables 

1. Pays 

		CREATE  TABLE PAYS(
		 noc varchar(3),
		 region varchar(60),
		 notes varchar(60),
		 COnstraint pk_Pays PRIMARY KEY(noc)
		);
2. Team 

		CREATE  Table TEAM(
		 idTeam serial,
		 team varchar(150),
		 noc varchar(3),
		 Constraint pk_noc primary key(idTeam),
		 Constraint fk_PaysTeam Foreign Key(noc)
		 References PAYS(noc)
		 ON  DELETE RESTRICT
		 ON  UPDATE CASCADE
		);

3. Athlete 

		CREATE  Table Athlete(
		 ID int,
		 Name varchar(120),
		 SEX varchar(2),
		 Constraint pk_idAthleteT primary key(ID)
		);

4. Discipline

		 CREATE  Table Discipline(
		 idS serial,
		 Sport varchar(50),
		 Constraint pk_idS primary key (idS)
		);
	
5. SousDiscipline

		Create  Table SousDiscipline(
		 idSD serial,
		 SDname varchar(250),
		 idS int,
		 Constraint pk_idSD primary key(idSD),
		 Constraint fk_Discipline foreign key(idS)
		 REFERENCES Discipline (idS)
		 ON  UPDATE CASCADE 
		 ON  DELETE RESTRICT 
		);

6. Ville 

		CREATE  Table ville(
		 idV serial,
		 NomVille varchar(60),
		 Constraint pk_idV primary key(idV)
		);

7. JO

		CREATE  Table JO (
		 idJO serial,
		 Season char(6),
		 Annee int,
		 Constraint pk_idJO primary key(idJO)
		);

8. Medal

		CREATE  Table Medal(
		 idM serial,
		 NomMedal varchar(15),
		 Constraint pk_idM primary key(idM)
		);

9. Participe 

		CREATE  Table participe (
		 idSD int,
		 ID int,
		 idJO int,
		 idM int,
		 idV int,
		 idTeam int,
		 poid numeric(5,2),
		 taille numeric(5,2),
		 age int,
		 Constraint pk_InfoGame primary key(idSD,ID,idJO,idM,idV,idTeam),
		 Constraint fk_JO foreign key(idJO)
		 REFERENCES JO (idJO)
		 ON  UPDATE CASCADE 
		 ON  DELETE RESTRICT, 
		 Constraint fk_SousDi foreign key(idSD)
		 REFERENCES SousDiscipline (idSD)
		 ON  UPDATE CASCADE 
		 ON  DELETE RESTRICT,
		 Constraint fk_Medal foreign key(idM)
		 REFERENCES Medal (idM)
		 ON  UPDATE CASCADE 
		 ON  DELETE RESTRICT,
		 Constraint fk_AthleteID foreign key(ID)
		 REFERENCES Athlete (ID)
		 ON  UPDATE CASCADE 
		 ON  DELETE RESTRICT,
		 Constraint fk_TeamNoc foreign key(idTeam)
		 REFERENCES TEAM(idTeam)
		 ON  UPDATE CASCADE
		 ON  DELETE RESTRICT,
		 Constraint fk_ville foreign key(idV)
		 REFERENCES ville (idV)
		 ON  UPDATE CASCADE 
		 ON  DELETE RESTRICT
		);

### Remplissage des Tables : 

1. Pays 
	
		INSERT  INTO PAYS
		 SELECT  DISTINCT NOC,region,notes from noc;

2. Team 
Pour la table Team nous compris qu'une Team était un nom (Team) mais aussi un Pays(noc). En effet nous avons constaté qu'il existait 2 équipes ayant le même nom (Alibaba II) mais ayant des pays d'origine différents (Suisse et Suède)
	
		INSERT  INTO TEAM(TEAM,noc)
		 SELECT  DISTINCT TEAM,noc from import;

3. Athlète

		INSERT  INTO Athlete
		 SELECT  Distinct ID , Name , Sex
		 FROM import;

4. Discipline

		INSERT  INTO Discipline(Sport)
		 Select  DISTINCT Sport 
		 From import;

5. SousDiscipline

		 INSERT  INTO SousDiscipline(SDname ,idS)
		 SELECT  DISTINCT i.Event,d.idS 
		 FROM Discipline AS d join import as i 
		 ON(i.Sport = d.Sport);
 
 6.Ville 
 
	INSERT  INTO ville(NomVille)
	SELECT  DISTINCT City 
	FROM import ;
6. JO
Nous avions au départ penser notre mld de manière a ce que un JO soit la combinaison d'une saison, d'une année et d'une ville cependant nous avons constaté que lors d'un des JO certaines épreuves se déroulait dans des villes différentes créant donc une nouvelle ligne JO n'étant pas censé exister 

		INSERT  INTO JO (Season,Annee)
		 SELECT  DISTINCT i.Season,i.YEAR 
		 FROM import as i; 
7. Medal 

INSERT  INTO Medal(NomMedal) 
 SELECT  DISTINCT Medal FROM import;

8. participe 

Il s'agit de la jointure entre toutes nos tables , c'est l'équivalent de notre table import mais sans les redondances 

	SELECT idSD , A.ID , idJO , idM , idV ,
	 t.idTeam ,CAST(weight AS  numeric(5,2)) ,
	 CAST(height AS  numeric(5,2)) ,CAST( Age as  int) 
	 FROM import as i JOIN JO as j ON(CAST(i.year AS  int)=j.annee AND i.Season = j.Season)
	 JOIN Athlete as A ON (i.ID = A.id) JOIN SousDiscipline as S ON (i.Event=S.SDname)
	 JOIN TEAM as t ON(i.Team=t.team and i.noc = t.noc) JOIN medal as m ON (i.medal=m.NomMedal)
	 JOIN Ville as c ON (c.NomVille=i.City)





		


 




### Q2
Tout D'abord pour connaitre les informations sur la taille en octet des tables on utilise la commande suivante :
	
	\d+
1. Taille en octet du fichier récupéré
	
	wc -c athlete_events.csv --> 41Ko
	
2. Taille en octet de la table import
	La table import a une taille de 98 Mo
3.  Taille en octet de la somme des tables créées
	La somme des tables créés est de 24 472 768o soit un peu plus de 24 Mo
	 
5.  Taille en octet de la somme des fichiers exportés
	wc -c data.csv new_noc_regions.csv --> 41500688

On constate donc que les fichiers csv sont moins que nos tables

## Exercice 5 : Requêtage : 

1.  Liste des pays classés par participation aux épreuves : 

	On utilise la commande suivante : 
			
		SELECT pa.region, count(*)
		FROM participe as p , team as t , Pays as pa
		WHERE p.idTeam = t.idTeam And t.noc = pa.noc 
		GROUP  BY pa.region;

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096763661030281457/image.png)
 
	

2. Liste des pays classés par nombre de médailles d’or
	
	On utilise la commande suivante : 

		SELECT p.region , count(*) 
		FROM pays as p , participe as p2 , team as t, medal as m
		WHERE p.noc = t.noc and p2.idTeam = t.idTeam and p2.idm=m.idM and m.nommedal='Gold'
		Group  by p.region
		order  by  count(*) desc;
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096764269690884136/image.png)
	

3.  Liste des pays classés par nombre médailles totales
	
	On utilise la commande suivante :
 
		SELECT p.region , count(*) 
		FROM pays as p , participe as p2 , team as t, medal as m
		WHERE p.noc = t.noc and p2.idTeam = t.idTeam and p2.idm=m.idM and m.nommedal<>'NA'
		Group  by p.region
		order  by  count(*) desc
		;

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096764666627231814/image.png)

4.  Liste des sportifs ayant le plus de médailles d’or, avec le nombre
	
	On utilise la commande suivante : 
		
		SELECT a.id ,a.name , count(*) 
		FROM participe as p, Athlete as a ,  medal as m
		WHERE p.id = a.id and p.idm=m.idM and m.nommedal='Gold'
		Group  by a.id,a.name
		order  by  count(*) desc
		;
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096765038372597821/image.png)

5.  Nombre de médailles cumulées par pays pour les Jeux d’Albertville, par ordre décroissant 
	
	On utilise la commande suivante : 
	
		SELECT region , count(*)
		FROM participe as p ,TEAM as t , Pays as pa , Medal as M , Ville as v
		WHERE v.nomville='Albertville'  AND v.idv=p.idv AND p.idTeam = t.idTeam AND pa.noc = t.noc AND p.idM=M.idM and M.nommedal <>  'NA'
		GROUP  BY pa.region
		ORDER  BY  count(*) desc;

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096765455663898715/image.png)
	
6.  Combien de sportifs ont fait les jeux olympiques sous 2 drapeaux différents, le dernier étant la France ?  Selon vous quel est le plus connu
	
	On utilise la commande suivante : 
	
		SELECT  count(Distinct p.id)
		FROM participe as p , participe as p2 , jo as j1 , jo as j2,team as t
		WHERE p.idTeam > p2.idTeam and p.id=p2.id and p.idJo = j1.idJo and p2.idJo=j2.idJo
		AND j1.annee < j2.annee and p2.idTeam = t.idTeam and t.noc='FRA'; --le dernier est la france
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096765946120642630/image.png)	

7.  Combien de sportifs ont fait les jeux olympiques sous 2 drapeaux différents, le premier étant la France ?  Selon vous quel est le plus connu

	On utilise la commande suivante : 

		SELECT  count(Distinct p.id)
		FROM participe as p , participe as p2 , jo as j1 , jo as j2,team as t
		WHERE p.idTeam > p2.idTeam and p.id=p2.id and p.idJo = j1.idJo and p2.idJo=j2.idJo
		AND j1.annee > j2.annee and p2.idTeam = t.idTeam and t.noc='FRA'; --le premier est la france
	
	![enter image description here](https://media.discordapp.net/attachments/1027631359591718962/1096766144251166740/image.png?width=123&height=136)
8.  Distribution des âges des médaillés d’or 

	On utilise la commande suivante : 

		SELECT p.age , count(*) 
		FROM participe as p , medal as m
		WHERE p.idm=m.idM and m.nommedal='Gold'
		Group  by p.age
		order  by  count(*) desc
		;

	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096767261894770728/image.png)

9.  Distribution des disciplines donnant des médailles aux plus de 50 ans par ordre décroissant 

	On utilise la commande suivante : 

		SELECT d.sport , count(*) 
		FROM participe as p , medal as m , sousdiscipline as sd , discipline as d
		WHERE p.idsd = sd.idsd and sd.ids = d.ids and p.idm=m.idM and m.nommedal<>'NA'  and age>49
		group  by d.sport
		order  by  count(*) desc
		;
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096769134827688056/image.png)

	
10.  Nombre d’épreuves par type de jeux (hivers,été), par année croissante 

       On utilise la commande suivante :  

			SELECT j.season , j.annee , count(Distinct idsd) 
			FROM participe as p ,JO as j
			WHERE p.idJO=j.idJO 
			group  by j.annee , j.season 
			order  by j.annee;	
	
	![enter image description here]	(https://media.discordapp.net/attachments/1027631359591718962/1096769543520657469/image.png?width=256&height=655)	
	
11.  Nombre de médailles féminines aux jeux d’été par année croissante 
	
		On utilise la commande suivante : 

			Select j.annee , count(*)
			From participe as p ,athlete as a, Medal as m , JO as j
			WHERE p.id = a.id and a.Sex ='F'  and p.idm = m.idm and m.nommedal<>'NA'  and p.idJO = j.idJO
			GROUP  BY j.annee
			Order  by j.annee;
		![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096770574598025358/image.png)


## Exercice 6 :  Équipe De France D'aviron:

### Points Importants pour la suite :
1. L'aviron s'écrit Rowing dans la table discipline

2. La France á pour noc FRA dans la table Pays

**Ces deux points sont essentiels pour la suite car ce sont eux qui vont permettre d'identifier notre équipe**

### Requêtes

1. On souhaite connaitre l'année durant laquelle il y a eu le plus de participant pour l'aviron dans notre équipe.
On utilise la commande suivante : 
 
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096773059794444298/image.png)

2. On souhaite connaitre la nombre de médailles gagne par âge et par sexe pour l'aviron dans notre équipe.
On utilise la commande suivante : 
		
		SELECT a.sex , p.age , count(*)
		FROM participe as p , athlete as a , medal as m, Team as t , Pays as pa ,SousDiscipline as sd , Discipline as D
		WHERE p.id=a.id 
		AND p.idM = m.idM
		AND m.nommedal<>'NA' --ici on vérifie qu'il s'agisse bien du médaille 
		AND p.idTeam=t.idTeam AND t.noc=pa.noc 
		AND pa.noc='FRA' -- ici on verifie qu'il s'agit de la france
		AND p.idsd=sd.idsd AND sd.ids=d.ids 
		AND d.sport='Rowing' --on vérifie qu'il s'agit bien d'aviron
		GROUP  By a.sex ,p.age
		ORDER  BY a.sex ,count(*) ,p.age;
	 
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096785319992512562/image.png)


3. On souhaite connaitre l'âge moyen des participants participants pour l'aviron dans notre équipe.
On utilise la commande suivante : 
 
			 SELECT  AVG(p.age)
			FROM participe as p , Team as t , Pays as pa ,SousDiscipline as sd , Discipline as D
			WHERE p.idTeam=t.idTeam 
			AND t.noc=pa.noc 
			AND pa.noc='FRA'
			AND p.idsd=sd.idsd 
			AND sd.ids=d.ids 
			AND d.sport='Rowing';
	 
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096785747119456346/image.png)

4. On souhaite connaitre l'année durant laquelle il y a eu le plus de médailles pour l'aviron dans notre équipe.
	On utilise la commande suivante : 

			SELECT j.annee,count(*)
			FROM participe as p , athlete as a , medal as m, Team as t , Pays as pa ,SousDiscipline as sd , Discipline as D, JO as j
			WHERE p.id=a.id AND p.idM = m.idM 
			AND m.nommedal<>'NA'
			AND p.idTeam=t.idTeam AND t.noc=pa.noc 
			AND pa.noc='FRA'
			AND p.idsd=sd.idsd AND sd.ids=d.ids 
			AND d.sport='Rowing'
			AND p.idJO=j.idJO
			GROUP  BY j.annee
			Having  count(*)>=ALL(SELECT  count(*)
									 FROM participe as p , athlete as a , medal as m, Team as t , Pays as pa 
									 ,SousDiscipline as sd , Discipline as D, JO as j
									 WHERE p.id=a.id
									 AND p.idM = m.idM 
									 AND m.nommedal<>'NA'
									 AND p.idTeam=t.idTeam 
									 AND t.noc=pa.noc 
									 AND pa.noc='FRA'
									 AND p.idsd=sd.idsd
									 AND sd.ids=d.ids 
									 AND d.sport='Rowing'
									 AND p.idJO=j.idJO
									 GROUP  BY j.annee);
						 
	![enter image description here](https://cdn.discordapp.com/attachments/1027631359591718962/1096786174179295303/image.png)
