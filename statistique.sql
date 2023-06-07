

\copy (SELECT 'Question 1' as Question,a.id,a.name,count(*) FROM participe as p , athlete as a WHERE p.id=a.id GROUP BY a.id,a.name ORDER BY count(*) desc limit 20) TO './Question1.csv' with (FORMAT CSV , Delimiter ',' , HEADER);

\copy (SELECT 'Question 2 a' as Question , pa.Region,AVG(p.age) as Moyenne ,count(Distinct p.id) as Nb ,min(p.age) as Min ,max(p.age) as Max FROM participe as p , jo as j,TEAM as t , Pays as pa WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee=1988 AND j.season='Winter'GROUP BY pa.NOC,pa.Region ) TO 'Question2a.csv' WITH (format CSV , DELIMITER ',' , HEADER);

\copy (SELECT 'Question 2 b' as Question , m.NomMedal<>'NA' as Medaille,AVG(p.age) as Moyenne  FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee=1988 AND j.season='Winter'AND p.idM=m.idM GROUP BY m.NomMedal<>'NA')  TO 'Question2b.csv' WITH (format CSV , DELIMITER ',' , HEADER);

\copy (SELECT 'Question 2 c' as Question , m.NomMedal<>'NA' as Medaillé,a.SEX,AVG(p.poid) as Moyenne ,count(p.id) as Nb FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee=1988 AND j.season='Winter'AND p.idM=m.idM AND p.ID=a.ID GROUP BY m.NomMedal<>'NA',a.SEX)  TO 'Question2c.csv' WITH (format CSV , DELIMITER ',' , HEADER);


\copy (SELECT 'Question 3 a' as Question ,pa.region, count(*) as NBMedaillé FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID and m.NomMedal<>'NA'GROUP BY t.NOC,pa.region ORDER BY count(*) desc limit 15 ) TO 'Question3a.csv' WITH (format CSV , DELIMITER ',' , HEADER);


-- Choix Pays France UK Japan Germany South Korea

\copy (SELECT 'Question 3 b i' as Question ,pa.region, j.annee,count(Distinct p.id) as NbParticipants FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID AND( pa.region='France'OR pa.region='UK' OR pa.region='Japan'OR pa.region='Germany' OR pa.region='South Korea')GROUP BY t.NOC,pa.region,j.annee ORDER BY pa.region , j.annee ) TO 'Question3bi.csv' WITH (format CSV , DELIMITER ',' , HEADER);

\copy (SELECT 'Question 3 b ii' as Question ,pa.region, j.annee,count(Distinct p.id) as NbParticipants FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID AND( pa.region='France' OR pa.region='UK' OR pa.region='Japan' OR pa.region='Germany' OR pa.region='South Korea') and m.NomMedal<>'NA' GROUP BY t.NOC,pa.region,j.annee ORDER BY pa.region , j.annee  )TO 'Question3bii.csv' WITH (format CSV , DELIMITER ',' , HEADER);

\copy (SELECT 'Question 3 b iii' as Question ,pa.region, j.annee,count(Distinct p.id) as NbDeFemme FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID AND( pa.region='France' OR pa.region='UK' OR pa.region='Japan' OR pa.region='Germany' OR pa.region='South Korea') and a.SEX='F' GROUP BY t.NOC,pa.region,j.annee ORDER BY pa.region , j.annee)  TO 'Question3biii.csv' WITH (format CSV , DELIMITER ',' , HEADER);


Drop Table Effect;
CREATE Table Effect(
	NOC char(3),
	Year int, 
	effecfif int,
	Constraint pk_eff PRIMARY KEY(NOC,Year)
);
Insert Into Effect
	SELECT Distinct t.NOC,j.annee,count(DISTINCT p.id) 
	FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a 
	WHERE p.idjo=j.idjo
	AND p.idteam=t.idteam
	AND t.NOC=pa.NOC
	AND j.annee>=1992
	And j.annee<=2016
	AND p.idM=m.idM
	AND p.ID=a.ID
	AND( pa.region='France'  
	OR pa.region='UK'
	OR pa.region='Japan'
	OR pa.region='Germany'
	OR pa.region='South Korea')
	Group By t.NOC,j.annee;
	

\copy (SELECT 'Question 3 b iv' as Question ,pa.region, a.SEX,j.annee,CAST (CAST(count(Distinct p.id)AS Numeric(6,3))/(e.effecfif) AS Numeric(6,3))As proportion FROM participe as p , jo as j,TEAM as t ,Effect as e, Pays as pa,Medal as m, athlete as a WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND e.NOC=t.NOC And e.year=j.annee AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID AND( pa.region='France' OR pa.region='UK' OR pa.region='Japan' OR pa.region='Germany' OR pa.region='South Korea') GROUP BY t.NOC,pa.region,j.annee,a.SEX,e.effecfif ORDER BY pa.region , j.annee) TO 'Question3biv.csv' WITH (format CSV , DELIMITER ',' , HEADER);

DELETE FROM effect;


Insert Into Effect
	SELECT Distinct t.NOC,j.annee,count(DISTINCT p.id) 
	FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a 
	WHERE p.idjo=j.idjo
	AND p.idteam=t.idteam
	AND t.NOC=pa.NOC
	AND j.annee>=1992
	And j.annee<=2016
	AND p.idM=m.idM
	AND p.ID=a.ID
	AND( pa.region='France'  
	OR pa.region='UK'
	OR pa.region='Japan'
	OR pa.region='Germany'
	OR pa.region='South Korea')
	AND a.SEX='F'
	Group By t.NOC,j.annee;

\copy (SELECT 'Question 3 b v' as Question ,pa.region, a.SEX,m.nomMedal<>'NA' as Medaille, j.annee,Cast(count(DISTINCT p.id )AS numeric(6,3))/e.effecfif  as NbDeFemme FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a , effect as e WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND e.NOC=t.NOC AND e.year=j.annee AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID AND( pa.region='France' OR pa.region='UK' OR pa.region='Japan' OR pa.region='Germany' OR pa.region='South Korea') AND a.SEX='F' AND m.nomMedal<>'NA' GROUP BY t.NOC,pa.region,j.annee,a.SEX,m.nomMedal<>'NA',e.effecfif ORDER BY pa.region , j.annee ) TO 'Question3bv.csv' WITH (format CSV , DELIMITER ',' , HEADER);


DELETE FROM effect;


Insert Into Effect
	SELECT Distinct t.NOC,j.annee,count(p.id) 
	FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a 
	WHERE p.idjo=j.idjo
	AND p.idteam=t.idteam
	AND t.NOC=pa.NOC
	AND j.annee>=1992
	And j.annee<=2016
	AND p.idM=m.idM
	AND p.ID=a.ID
	AND( pa.region='France'  
	OR pa.region='UK'
	OR pa.region='Japan'
	OR pa.region='Germany'
	OR pa.region='South Korea')
	AND m.nomMedal<>'NA'
	Group By t.NOC,j.annee;

\copy (SELECT 'Question 3 b vi' as Question ,pa.region, a.SEX,m.nomMedal<>'NA' as Medaille, j.annee,Cast(count(p.id )AS numeric(6,3))/e.effecfif  as NbDeFemme FROM participe as p , jo as j,TEAM as t , Pays as pa,Medal as m, athlete as a , effect as e WHERE p.idjo=j.idjo AND p.idteam=t.idteam AND t.NOC=pa.NOC AND e.NOC=t.NOC AND e.year=j.annee AND j.annee>=1992 And j.annee<=2016 AND p.idM=m.idM AND p.ID=a.ID AND( pa.region='France'  OR pa.region='UK' OR pa.region='Japan' OR pa.region='Germany' OR pa.region='South Korea') AND m.nomMedal<>'NA'GROUP BY t.NOC,pa.region,j.annee,a.SEX,m.nomMedal<>'NA',e.effecfif ORDER BY pa.region , j.annee) TO 'Question3bvi.csv' WITH (format CSV , DELIMITER ',' , HEADER);





 
 
