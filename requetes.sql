

--Q1

select count(COLUMN_NAME)
from information_schema.columns
where table_name = 'import';

--Q2

Select count(*) from import;

--Q3

SELECT count(DISTINCT noc) FROM noc WHERE noc is not null;


--Q4

SELECT count(DISTINCT id) FROM import 
where id is not null;

--Q5

SELECT count(*) FROM import WHERE medal ='Gold';

--Q6

SELECT count(*) FROM import 
where name LIKE '%Carl%Lewis%';

--Exercice 5 


SELECT 'Exercice 5';
--Q1

SELECT pa.region, count(*)
FROM participe as p , team as t , Pays as pa
WHERE p.idTeam = t.idTeam And t.noc = pa.noc 
GROUP BY pa.region
Order by count(*) desc ;
--Q2

SELECT p.region , count(*) 
FROM pays as p , participe as p2 , team as t, medal as m
WHERE p.noc = t.noc and p2.idTeam = t.idTeam and p2.idm=m.idM and m.nommedal='Gold'
Group by p.region
order by count(*) desc
;

--Q3


SELECT p.region , count(*) 
FROM pays as p , participe as p2 , team as t, medal as m
WHERE p.noc = t.noc and p2.idTeam = t.idTeam and p2.idm=m.idM and m.nommedal<>'NA'
Group by p.region
order by count(*) desc
;

--Q4


SELECT a.id ,a.name , count(*) 
FROM  participe as p, Athlete as a ,  medal as m
WHERE p.id = a.id and p.idm=m.idM and m.nommedal='Gold'
Group by a.id,a.name
order by count(*) desc
;

--Q5

SELECT region , count(*)
FROM participe as p ,TEAM as t , Pays as pa , Medal as M , Ville as v
WHERE v.nomville='Albertville' AND v.idv=p.idv AND p.idTeam = t.idTeam AND pa.noc = t.noc AND p.idM=M.idM and M.nommedal <> 'NA'
GROUP BY  pa.region
ORDER BY count(*) desc;
--Q6

SELECT p.id count(Distinct p.id)
FROM participe as p , participe as p2 , jo as j1 , jo as j2,team as t,Medal as m, Medal as m2
WHERE p.idTeam > p2.idTeam and p.id=p2.id and p.idJo = j1.idJo and p2.idJo=j2.idJo 
AND p.idM = m.idm and p2.idm = m2.idm
AND j1.annee < j2.annee and p2.idTeam = t.idTeam and t.noc='FRA'; --le dernier est la france


--Q7

SELECT p.id count(Distinct p.id)
FROM participe as p , participe as p2 , jo as j1 , jo as j2,team as t
WHERE p.idTeam > p2.idTeam and p.id=p2.id and p.idJo = j1.idJo and p2.idJo=j2.idJo
AND j1.annee > j2.annee and p2.idTeam = t.idTeam and t.noc='FRA'; --le premier est la france


--Q8

SELECT p.age , count(*) 
FROM participe as p , medal as m
WHERE p.idm=m.idM and m.nommedal='Gold'
Group by p.age
order by count(*) desc
;


--Q9 


SELECT d.sport , count(*) 
FROM participe as p , medal as m , sousdiscipline as sd , discipline as d
WHERE p.idsd = sd.idsd and sd.ids = d.ids and p.idm=m.idM and m.nommedal<>'NA' and age>49
group by d.sport
order by count(*) desc
;

--Q10

SELECT j.season , j.annee , count(Distinct idsd) 
FROM participe as p ,JO as j
WHERE p.idJO=j.idJO 
group by j.annee , j.season 
order by j.annee;

--Q11


Select  j.annee , count(*)
From participe as p ,athlete as a, Medal as m , JO as j
WHERE p.id = a.id and a.Sex ='F' and p.idm = m.idm and m.nommedal<>'NA' and p.idJO = j.idJO
GROUP BY j.annee
Order by j.annee;

-- EXERCICE 6

---Choix France Rowing

--L'annee ou il y a eu le plus de participants

Select j.annee , count(*)
FROM participe as p , sousdiscipline as sd ,
discipline as d , Team as t , Pays as pa , JO as j
WHERE p.idTeam = t.idTeam AND t.noc = pa.noc
AND pa.noc='FRA'
AND p.idsd = sd.idSD AND sd.idS=d.ids AND d.sport='Rowing'
AND p.idJO = j.idJO
Group By j.annee
Order by count(*) desc
Limit 1;

 --Une Moyenne du nombre de medailles gagne par age et par sex

SELECT a.sex , p.age , count(*)
FROM participe as p , athlete as a , medal as m, Team as t , Pays as pa 
,SousDiscipline as sd , Discipline as D
WHERE p.id=a.id AND p.idM = m.idM AND m.nommedal<>'NA'
AND p.idTeam=t.idTeam AND t.noc=pa.noc AND pa.noc='FRA'
AND p.idsd=sd.idsd AND sd.ids=d.ids AND d.sport='Rowing'
GROUP By a.sex ,p.age
ORDER BY a.sex ,count(*) ,p.age;

 --Moyenne d'age des participants


SELECT AVG(p.age)
FROM participe as p , Team as t , Pays as pa 
,SousDiscipline as sd , Discipline as D
WHERE p.idTeam=t.idTeam AND t.noc=pa.noc AND pa.noc='FRA'
AND p.idsd=sd.idsd AND sd.ids=d.ids AND d.sport='Rowing';


 --Annee durant laquelle il y a eu le plus de medaille


SELECT j.annee,count(*)
FROM participe as p , athlete as a , medal as m, Team as t , Pays as pa 
,SousDiscipline as sd , Discipline as D, JO as j
WHERE p.id=a.id AND p.idM = m.idM AND m.nommedal<>'NA'
AND p.idTeam=t.idTeam AND t.noc=pa.noc AND pa.noc='FRA'
AND p.idsd=sd.idsd AND sd.ids=d.ids AND d.sport='Rowing'
AND p.idJO=j.idJO
GROUP BY j.annee
Having count(*)>=ALL(SELECT  count(*)
			FROM participe as p , athlete as a , medal as m, Team as t , Pays as pa 
			,SousDiscipline as sd , Discipline as D, JO as j
			WHERE p.id=a.id AND p.idM = m.idM AND m.nommedal<>'NA'
			AND p.idTeam=t.idTeam AND t.noc=pa.noc AND pa.noc='FRA'
			AND p.idsd=sd.idsd AND sd.ids=d.ids AND d.sport='Rowing'
			AND p.idJO=j.idJO
			GROUP BY j.annee);


