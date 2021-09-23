-- lire une table en entier
select * from stars;

-- projection : sélection colonnes
select name, birthdate from stars;
select name from stars;

-- sélection (de lignes) : filtres

-- 1 resultat qui matche, insensible à la casse 
select * from stars where name = 'fred Astaire';
select * from stars where name = 'Steve McQueen';
select * from movies where year = 2020; -- clean
select * from movies where year = '2020'; -- conversion implicite texte => nombre
select * from stars where name like 'steve McQueen';
select * from stars where name like '%McQueen';
select * from stars where name like 'Fred%'; -- inclus Fred
select * from stars where name like 'Fred %'; -- sans Fred
select * from stars where name like '%Tarant%';
select * from stars where name like '%Tarant_';

-- filtre avec notion d'ordre : < <= > >=
select * from movies where year >= 2000
order by year desc, title;

-- films Terminator réalisés après 2000
select * from movies 
where 
	year >= 2000
	and title like '%Terminator%'
order by year;

-- films Terminator réalisés dans les années 2010
-- sol naïve
select * from movies 
where 
	year >= 2010
	and year <= 2019
	and title like '%Terminator%'
order by year;

-- conversion implicite nombre => texte
-- sol moyenne
select * from movies 
where 
	year like '201_'
	and title like '%Terminator%'
order by year;

-- sol propre
select * from movies 
where 
	year between 2010 and 2019
	and title like '%Terminator%'
order by year;

select * from movies 
where 
	year = 2019
	or title like '%Terminator%'
order by year;

select * from movies
where year = 2019
	and title not like '%Terminator%';

-- différent version 1
select * from movies
where year != 2019
	and title like '%Terminator%';

-- différent version 2 (historique)
select * from movies
where year <> 2019
	and title like '%Terminator%';

select * from movies
where not (year between 1920 and 2020);

select * from movies
where year not between 1920 and 2020;

-- les stars s'appelant John

-- Les films contenant le mot star

-- Les années des films contenant le mot star (sans les doublons)
select distinct year from movies
where title like '%star%'
order by year;

select distinct title, year from movies
where title like 'The Man who%';

-- tri : asc, desc
select name from stars order by name;
select name, birthdate from stars order by birthdate;

select name, birthdate from stars 
order by birthdate desc;

-- date de naissance inconnue
select name, birthdate from stars 
where birthdate is NULL
order by birthdate desc;

-- date de naissance connue
select name, birthdate from stars 
where birthdate is not NULL
order by birthdate desc;

-- NULL n'est pas une valeur (tout le temps faux)
select name, birthdate from stars 
where birthdate = NULL
order by birthdate desc;

-- films sans durée
select * from movies
where duration is null;

select title, coalesce(duration, 0) as duration
from movies
where year = 1922;

select 
	title as titre, coalesce(duration, 0) as durée
from movies
where year = 1922;

-- attention à ne pas abuser du code suivant
-- str : convertit un nombre en texte
select 
	title as titre, coalesce(str(duration), 'INC') as durée
from movies
where year = 1922;

-- substituer une valeur avec NULL : NULLIF
-- valeur projetée en fonction de prédicat(s) : case
select 
	title, year, duration,
	nullif(duration, 8) as durationExcept8,
	case
		when duration < 60 then 'COURT'
		else 'LONG'
	end as movie_type
from movies
where year between 1950 and 1959;

-- fonctions en lignes et opérateurs arithmétiques : 
-- pour sélection, projection
select 
	title, year,
	floor(year / 10) * 10 as decennie,
	concat(upper(left(title, 4)), year) as code
from movies
where left(title, 3) = 'Sta'; -- title like 'Sta%'

-- + concatene 2 textes avec un espace : BOF
-- NB : autres éditeurs : ||
select 
	title, year,
	floor(year / 10) * 10 as decennie,
	upper(left(title, 4)) + str(year) as code
from movies
where left(title, 3) = 'Sta';

-- fonctions textes
select
	title,
	left(title, 3),
	right(title, 3),
	'#' + SUBSTRING(title, 3, 5) + '#',
	'#' + trim(SUBSTRING(title, 3, 5)) + '#',
	upper(title),
	lower(title)
from movies;

select * from stars where name like '%é%';

-- liste des films dont le titre fait plus de 100 caractères
select * from movies
where len(title) >= 100;

-- preuve : 
select m.*, len(title) 
from movies m
where len(title) >= 100;

-- maths

-- films qui dure 2H (120 mn) à 5% près

select 120*1.05, 120*0.95;

select * from movies
where duration between 120 - 5*120/100 and 120 + 5*120/100
order by duration;

select * from movies
where abs(duration - 120) <= 5*120/100
order by duration;








