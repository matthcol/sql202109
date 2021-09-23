set DATEFORMAT dmy;
set DATEFORMAT mdy;

select name, birthdate
from stars
where 
	birthdate is not null
	and birthdate < '1900-01-01';

select name, birthdate
from stars
where 
	birthdate is not null
	and birthdate = '1884-03-16';

select name, birthdate
from stars
where 
	birthdate is not null
	and birthdate = '16/03/1884';

select * from stars
where name = 'Harrison Ford';

-- en fonction du dateformat
select * from stars where birthdate = '01/06/1926';
select * from stars where birthdate = '06/01/1926';
select * from stars where birthdate = '1926-06-01';

select * from stars where birthdate = '1930'; -- 1930-01-01
select * from stars where 
	birthdate >= '1930'
	and birthdate < '1931';

-- BOF: tous ceux de 1930 et du 01/01/1931
select * from stars where 
	birthdate between '1930' and '1931';

select 
	name, birthdate,
	datepart(year, birthdate) as birthyear
from stars 
where birthdate is not null;


select *
from stars
where datepart(year, birthdate) = 1930;

select *
from stars
where 
	datepart(month, birthdate) = 1
	and datepart(day, birthdate) = 1;

-- DML de maj : insert, update, delete
update stars
set birthdate = '1889-05-10'
where id = 1;

select *
from stars
where id = 1;

begin transaction;

update stars
set birthdate = '1924-09-16'
where id = 2;

-- on voit le changement à l'interieur de la transaction
select *
from stars
where id = 2;

-- 2 possibilités de fin de transaction
rollback;
commit;

select * from stars where name like '%Belmondo';

-- id auto généré (identity) et deathdate NULL
insert into stars (name, birthdate)
values ('Jean-Paul Belmondo', '1933-04-09');

-- Impossible d'insérer la valeur NULL dans la colonne 'name', table 'dbmovie.dbo.stars'. Cette colonne n'accepte pas les valeurs NULL. Échec de INSERT.
insert into stars (birthdate)
values ('1933-04-09');

-- texte trop grand
insert into stars (name) values ('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

-- exo : maj fiche Jean-Paul Belmondo pour signaler son décès (06/09/2021)
select * from stars where name like '%Belmondo';
update stars set deathdate = '2021-09-06' where id = 11749102;
select * from stars where id = 11749102;

-- MAJ sur 2 colonnes
--Born: August 29, 1915 in Stockholm, Sweden
-- Died: August 29, 1982 (age 67) in Chelsea, London, England, UK
update stars
set birthdate = '1915-08-29', deathdate = '1982-08-29'
where id = 6;

select * from stars where id = 6;

-- supprime TOUTES les lignes de la table play
delete from play;

-- L'instruction DELETE est en conflit avec la contrainte REFERENCE "FK_PLAY_ACTOR". Le conflit s'est produit dans la base de données "dbmovie", table "dbo.play", column 'id_actor'.
delete from stars where name like '%Bardot';
select * from stars where name like '%Bardot';
select * from play where id_actor = 3;
-- suppression des lignes play concernat Brigite Bardot 
-- avant de la supprimer de la table play
delete from play where id_actor = 3;
delete from stars where id = 3;
-- ses films sont toujours là
select * from movies where id in (63592, 973844);

-- year est obligatoire
insert into movies (title) values ('BAC Nord');
-- ok
insert into movies (title, year) values ('BAC Nord', 2020);
delete from movies where title = 'BAC Nord';
-- nok : star 5 n'existe pas
insert into movies (title, year, id_director) 
	values ('BAC Nord', 2020, 5);
insert into stars (name) values ('Cédric Jimenez');
select * from stars where name like 'Cédric Jimenez';
insert into movies (title, year, id_director) 
	values ('BAC Nord', 2020, 11749105);

-- colonne unique (PK => unique)
SET IDENTITY_INSERT stars ON
-- Violation de la contrainte PRIMARY KEY « pk_stars ». Impossible d'insérer une clé en double dans l'objet « dbo.stars ». Valeur de clé dupliquée : (1).
insert into stars (id, name) values (1, 'Nobody');

-- différents types de contraintes
-- primary key (=> NOT NULL, UNIQUE)
-- foreign key
-- not null / null
-- unique
-- check (predicat)

-- title n'est pas unique
alter table movies add constraint uniq_title_year unique (title);
-- title, year unique
alter table movies add constraint uniq_title_year unique (title, year);

insert into movies (title, year, id_director) 
	values ('BAC Nord', 2020, 11749105);

select * from movies where title like '%Lion%';
insert into movies (title, year) values ('The Lion King', 1994);
insert into movies (title, year) values ('The Lion King', 2019);

alter table movies add constraint check_movie_year 
	check (year >= 1850);
insert into movies (title, year) values ('Prehistoric', -10000);

-- retour aux fonctions temprelles
select 
	sysdatetime(), -- datetime actuel 
	CURRENT_TIMESTAMP, -- idem (nom standard SQL),
	getdate(), -- idem
	cast (getdate() as date),  -- eq standard sql current_date
	convert( date, getdate()), -- eq standard sql current_date
	datefromparts(2021,9,24), -- date fabriquée à partir des composantes
	cast (getdate() as time) -- eq standard sql current_time
;

-- films de moins de 10 ans
-- 1. enquete
select 
	title, year,
	datepart(year,getdate()) - year
from movies
where datepart(year,getdate()) - year < 10;

-- 2. requete répondant au pb
select *
from movies
where datepart(year, getdate()) - year < 10;

-- personnes de la tranche d'age 50-59 (année d'aujourd'hui)
select 
	name, birthdate, 
	datepart(year, birthdate) as birth_year,
	datepart(year, getdate()) as current_year,
	datepart(year, getdate()) - datepart(year, birthdate) as age_this_year
from stars
where datepart(year, getdate()) - datepart(year, birthdate)
	 between 50 and 59
order by age_this_year;

select * from stars
where datepart(year, getdate()) - datepart(year, birthdate)
	between 50 and 59;

select 
	EOMONTH(getdate()),
	EOMONTH(DATEFROMPARTS(2021,2,5)),
	EOMONTH(DATEFROMPARTS(2020,2,5)),
	EOMONTH(DATEFROMPARTS(2100,2,5)),
	EOMONTH(DATEFROMPARTS(2000,2,5)),
	-- DATEFROMPARTS(1712,2,30)
	DATEFROMPARTS(1712,2,28)
	;

select 
	DATEDIFF(day, birthdate, getdate()),
	DATEDIFF(day, '2021-09-01', getdate())
from stars;

select 
	DATEADD(day, 20, cast('2021-01-31' as date)),
	DATEADD(month, 1, '2021-01-31'),
	DATEADD(month, 1, '2020-01-31');

select 	1 + 4 as res;

select year
from
	(values 
		(1+2004),
		(2006),
		(datepart(year, getdate()))
	) N(year);

select * from
	(values 
		(1, 1+2004),
		(2, 2006),
		(3, datepart(year, getdate()))
	) N(num, year);

-- statistiques : fonctions d'agrégation

-- compter des lignes
select count(*) from movies;

-- 3 variantes de count
select 
	count(*) as nb_stars,
	count(birthdate) as nb_birthdate,
	count(distinct birthdate) as nb_birthdate_distinct,
	count(distinct datepart(year, birthdate)) as nb_year_distinct
from stars;

-- autres stats
select 
	min(year) as year_min, max(year) as year_max,
	min(duration) as duration_min, 
	max(duration) as duration_max,
	avg(duration) as duration_avg,
	sum(duration) / 60 as duration_total_h
from movies;

select * from stars where name like '%Tarantino';

select * 
from movies
where id_director = 233;

select * 
from movies
where id_director = (
	select id from stars
	where name like '%Tarantino'
)
order by year;

select * 
from movies
where id_director in (
	select id from stars
	where name like 'Steve McQueen'
)
order by year;

-- film(s) de durée maximale
-- 1. décomposition du pb
select max(duration) from movies;  -- 594
select * from movies where duration = 594;
-- 2. réunit les morceaux
select * from movies where duration = (
	select max(duration) from movies
);

-- films de durée au dessus de la moyenne
select * from movies where duration > (
	select avg(duration) from movies
);

-- liste des réalisateurs
-- sol 1 : sous-requete indépendante
select * from stars where id in (
	select id_director from movies)
order by name;

-- sol 2 : sous-requete dépendante
select * from stars s where exists (
	select * from movies m where m.id_director = s.id)
order by s.name;

-- liste des stars n'ayant jamais réalisé de films
select * from stars s 
where not exists (
		select * from movies m where m.id_director = s.id)
order by s.name;

select * from stars s 
where not exists (
		select * from movies m where m.id_director = s.id)
	and s.name like 'Clint Eastwood'
order by s.name;

select * from stars s 
where not exists (
		select * from movies m where m.id_director = s.id)
	and s.name like 'Steve McQueen'
order by s.name;

-- liste des acteurs
select * from stars where id in (
	select id_actor from play);

select * from stars 
where id in (
		select id_actor from play)
	and name like 'Steve McQueen';

select * from stars s
where exists (select * from play p where p.id_actor = s.id)
	and s.name like 'Steve McQueen';



-- liste des acteurs-realisateurs
select * from stars 
where 
	id in (
		select id_director from movies)
	and id in (
		select id_actor from play)
order by name;













select string_agg(title, ', ')
from movies
where id_director = 233;

select 
	string_agg(title, ', ') WITHIN GROUP (ORDER BY year)
from movies
where id_director = 233;

select 
	string_agg(title, ', ') WITHIN GROUP (ORDER BY year desc)
from movies
where id_director = 233;



















































select * from stars where name like '%Eastwood';
