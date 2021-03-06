-- jointures

-- liste des films avec leur r?alisateur 
-- jointure interne : on ne garde que les films ayant des r?alisateurs
select * 
from 
	movies m
	join stars s on m.id_director = s.id
order by s.id, s.name, m.year;

select m.title, m.year, s.id, s.name 
from 
	movies m
	join stars s on m.id_director = s.id
order by s.id, s.name, m.year;

select m.*, s.name
from 
	movies m
	join stars s on m.id_director = s.id
order by s.name, m.year;

-- elements absents de la jointure
select * from movies where id_director is null;

select * 
from 
	movies m
	join stars s on m.id_director = s.id
where m.title like 'Tiny Toon Adventures'
order by s.id, s.name, m.year;

select *
from 
	movies m, stars s
where
	m.id_director = s.id
	and m.year between 1970 and 1979;
	
-- liste des stars ayant jou? James Bond avec le titre et l'ann?e des films
select *
from
	stars s
	join play p on s.id = p.id_actor
	join movies m on p.id_movie = m.id
where 
	p.role like 'James Bond'
order by m.year;

-- liste des films de 1990 avec leur r?alisateur si renseign?
-- on garde les films n'ayant pas de r?alisateurs
select *
from 
	movies m 
	left join stars s on m.id_director = s.id
where m.year = 1990
order by m.title;

-- toutes les jointures
-- join = inner join
-- left join = left outer join
-- right join = right outer join
-- full join = full outer join
-- cross join

select * from stars s
cross join movies m
where s.name = 'Clint Eastwood';

-- appart? sur les verrous
SELECT * 
FROM sys.dm_exec_requests
WHERE DB_NAME(database_id) = 'dbmovie' 
AND blocking_session_id <> 0;

sp_who2

-- liste des r?alisateurs avec leur nombre de r?alisation
-- ERROR : La colonne 'movies.title' n'est pas valide dans la liste de s?lection parce qu'elle n'est pas contenue dans une fonction d'agr?gation ou dans la clause GROUP BY.
select id_director, title, count(*)
from movies
group by id_director;

-- ok
select id_director, count(*) as nb_movies
from movies
group by id_director
order by nb_movies desc;

select 
	id_director, 
	count(*) as nb_movies,
	min(year) as year_min,
	max(year) as year_max,
	string_agg(title, ', ') as titles
from movies
group by id_director
order by nb_movies desc;

select 
	s.id, s.name,
	count(*) as nb_movies,
	min(m.year) as year_min,
	max(m.year) as year_max,
	string_agg(m.title, ', ') as titles
from 
	stars s join movies m on s.id = m.id_director
group by s.id, s.name
order by nb_movies desc;

select 
	s.name,
	count(*) as nb_movies,
	min(m.year) as year_min,
	max(m.year) as year_max,
	string_agg(m.title, ', ') as titles
from 
	stars s join movies m on s.id = m.id_director
group by  s.id, s.name
order by nb_movies desc;

-- et steve mcqueen ?

-- avec la pk dans le group by, les homonymes sont s?par?s
select 
	s.name,
	count(*) as nb_movies,
	min(m.year) as year_min,
	max(m.year) as year_max,
	string_agg(m.title, ', ') as titles
from 
	stars s left join movies m on s.id = m.id_director
where s.name like '%McQueen'
group by  s.id, s.name
order by nb_movies desc;

-- sans la pk dans le group by, les homonymes sont mis
-- dans le m?me paquet
select 
	s.name,
	count(*) as nb_movies,
	min(m.year) as year_min,
	max(m.year) as year_max,
	string_agg(m.title, ', ') as titles
from 
	stars s left join movies m on s.id = m.id_director
where s.name like '%McQueen'
group by  s.name
order by nb_movies desc;

-- compter le nombre de films par ann?e 
-- en les classant du plus grand nb au plus petit
select year, count(*) as nb_movies
from movies
group by year
order by nb_movies desc;

-- liste des films avec leur nombre d'acteurs
-- en les classant du plus grand nb au plus petit
select 
	m.id, m.title, m.year, count(*) as nb_actors
from 
	movies m join play p on m.id = p.id_movie
group by m.id, m.title, m.year
order by nb_actors desc;

-- 2e methode pour join + group by
-- warning : pour jointure interne
select 
	s.id, s.name, s.birthdate, 
	nb_movies, year_min, year_max, titles
from 
	stars s 
	join (select 
			id_director, 
			count(*) as nb_movies,
			min(year) as year_min,
			max(year) as year_max,
			string_agg(title, ', ') as titles
		from movies
		group by id_director) stat on s.id = stat.id_director
order by nb_movies desc;

-- s?lection/filtrage avec un group by

-- filtre 1 : ann?es 70 et +
-- filtre 2 : nb de films ? 14 et +
select 
	s.name,
	count(*) as nb_movies,
	min(m.year) as year_min,
	max(m.year) as year_max,
	string_agg(m.title, ', ') as titles
from 
	stars s join movies m on s.id = m.id_director
where 
	m.year >= 1970
group by  s.id, s.name
having 	count(*) >= 14
order by nb_movies desc;

-- le ou les r?alisateurs ayant r?alis? le plus de film
-- D?composition
-- 1+2: table movies
-- 1. trouver le nombre maximum de films r?alis?s
-- 2. garder les r?alisateurs avec ce nombre
-- 3. joindre table stars pour avoir les noms
select max(nb_movies) from (
	select count(*) as nb_movies
	from movies 
	group by id_director) nbs;

-- raccourci chez Oracle :
select 
	max(count(*)) as max_nb_movies
from 
	stars s join movies m on s.id = m.id_director
group by s.id, s.name;

-- selection du r?alisateur ayant fait 60 films
select 
	s.id, s.name, count(*) as nb_movies
from 
	stars s join movies m on s.id = m.id_director
group by s.id, s.name
having count(*) = 60;

-- r?unir les 2 requ?tes
select 
	s.id, s.name, count(*) as nb_movies
from 
	stars s join movies m on s.id = m.id_director
group by s.id, s.name
having count(*) = (
	select max(nb_movies) from (
		select count(*) as nb_movies
		from movies 
		group by id_director) nbs
);

-- pour les personnes : 
--	- Clint Eastwood, Steve McQueen (les 2), Quentin Tarentino
--  - Leonardo DiCaprio
-- compter le nombre de r?alisation (y compris 0) 
-- et la dur?e totale des films r?alis?s
select 
	s.id, s.name, 
	count(m.id) as nb_movies,
	coalesce(sum(m.duration), 0) as total_duration
from stars s left join movies m on s.id = m.id_director
where s.name in (
	'Clint Eastwood', 'Steve McQueen', 'Leoardo DiCaprio', 
	'Quentin Tarantino')
group by s.id, s.name;

-- m?me requ?te en ajoutant le nombre de films jou?s 
-- et la dur?e totale des films jou?s











select * from movies where id_director = 33 order by year desc;




