Drop Table import;
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

\copy import from data.csv with (format CSV ,delimiter ',' , Header); 


delete from import where Year<1920 OR Sport LIKE '%Art%';
Update import set Age = Null Where Age = 'NA';
Update import set Age = Cast(Age AS int);
Update import set Weight = Null Where Weight = 'NA';
Update import set Height = Null Where Height = 'NA';


Drop Table noc;
Create temp Table noc (
    NOC varchar(3),
    region varchar(60),
    notes varchar(60)
);

\copy noc from new_noc_region.csv with (format CSV ,delimiter ',' , Header);


--Exercice 4 Creation des tables

--Exercice 4
DROP Table participe;
DROP table Medal;
drop table JO;
drop table ville;
drop table SousDiscipline;
drop table Discipline;
drop table Athlete;
drop table TEAM;
drop table PAYS;
CREATE TABLE PAYS(
	noc varchar(3),
	region varchar(60),
	notes varchar(60),
	COnstraint pk_Pays PRIMARY KEY(noc)
);
CREATE Table TEAM(
    idTeam serial,
    team varchar(150),
    noc varchar(3),
    Constraint pk_noc primary key(idTeam),
    Constraint fk_PaysTeam Foreign Key(noc)
	References PAYS(noc)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE Table Athlete(
    ID int,
    Name varchar(120),
    SEX varchar(2),
    Constraint pk_idAthleteT primary key(ID)

);

CREATE Table Discipline(
    idS serial,
    Sport varchar(50),
    Constraint pk_idS primary key (idS)
);

Create Table SousDiscipline(
    idSD serial,
    SDname varchar(250),
    idS int,
    Constraint pk_idSD primary key(idSD),
    Constraint fk_Discipline foreign key(idS)
        REFERENCES Discipline (idS)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT 
);

CREATE Table ville(
    idV serial,
    NomVille varchar(60),
    Constraint pk_idV primary key(idV)
);

CREATE Table JO (
    idJO serial,
    Season char(6),
    Annee int,
    Constraint pk_idJO primary key(idJO)
);

CREATE Table Medal(
    idM serial,
    NomMedal varchar(15),
    Constraint pk_idM primary key(idM)
);

CREATE Table participe (
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
        ON UPDATE CASCADE 
        ON DELETE RESTRICT, 
    Constraint fk_SousDi foreign key(idSD)
        REFERENCES SousDiscipline (idSD)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    Constraint fk_Medal foreign key(idM)
        REFERENCES Medal (idM)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    Constraint fk_AthleteID foreign key(ID)
        REFERENCES Athlete (ID)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
   Constraint fk_TeamNoc foreign key(idTeam)
	REFERENCES TEAM(idTeam)
	ON UPDATE CASCADE
	ON DELETE RESTRICT,
   Constraint fk_ville foreign key(idV)
        REFERENCES ville (idV)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);

DELETE FROM participe;
DELETE FROM JO;
DELETE FROM Season;
DELETE FROM ville;
DELETE FROM SousDiscipline;
DELETE FROM TEAM;
DELETE FROM Athlete;
DELETE FROM Discipline;
DELETE FROM PAYS;
INSERT INTO PAYS
	SELECT DISTINCT NOC,region,notes from noc;

UPDATE PAYS set NOC='SGP' WHERE NOC='SIN'; --Nous avons constate une erreur dans le code de singapour 
INSERT INTO TEAM(TEAM,noc)
	SELECT DISTINCT TEAM,noc from import;

INSERT INTO Athlete
	SELECT Distinct ID , Name , Sex
	FROM import;

INSERT INTO Discipline(Sport)
	Select DISTINCT Sport 
	From import;

INSERT INTO SousDiscipline(SDname ,idS)
	SELECT DISTINCT i.Event,d.idS  
	FROM Discipline AS d join import as i 
	ON(i.Sport = d.Sport);

INSERT INTO ville(NomVille)
	SELECT DISTINCT City FROM import ;

INSERT INTO JO (Season,Annee)
	SELECT DISTINCT i.Season,i.YEAR 
	FROM import as i;

INSERT INTO Medal(NomMedal) 
	SELECT DISTINCT Medal FROM import;

INSERT INTO participe(idSD,ID,idJO,idM,idV,idTeam,poid,taille,age)

	SELECT idSD , A.ID , idJO , idM , idV ,
	t.idTeam ,CAST(weight AS numeric(5,2)) ,
	CAST(height AS numeric(5,2)) ,CAST( Age as int) 
	FROM import as i JOIN JO as j ON(CAST(i.year AS int)=j.annee AND i.Season = j.Season)
	JOIN Athlete as A ON (i.ID = A.id) JOIN SousDiscipline as S ON (i.Event=S.SDname)
	JOIN TEAM as t ON(i.Team=t.team and i.noc = t.noc) JOIN medal as m ON (i.medal=m.NomMedal)
	JOIN Ville as c ON (c.NomVille=i.City)
	--FROM import as i ,JO as j, Medal as m ,--JO contient La Saison et 
	--L'année / Medal contient les différentes médaille /  
	--SousDiscipline as S , Athlete as A , TEAM as t ,
	--Ville as v 
	
	--WHERE Cast(i.Year AS int) = j.Annee And i.Season = j.Season --liaison table JO
	--AND i.ID = A.id --liaison table athlete
	--AND i.medal = m.NomMedal -- liaison table medaille
	--AND i.Event = S.SDname -- liaison table SousDiscipline
	--AND i.Team = t.Team -- liaison table TEAM
	--AND i.City = v.NomVille -- liaison table ville
;
