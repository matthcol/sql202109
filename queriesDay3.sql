-- jointures

-- liste des films avec leur réalisateur 
-- jointure interne : on ne garde que les films ayant des réalisateurs
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
	
-- liste des stars ayant joué James Bond avec le titre et l'année des films
select *
from
	stars s
	join play p on s.id = p.id_actor
	join movies m on p.id_movie = m.id
where 
	p.role like 'James Bond'
order by m.year;

-- liste des films de 1990 avec leur réalisateur si renseigné
-- on garde les films n'ayant pas de réalisateurs
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

-- apparté sur les verrous
SELECT * 
FROM sys.dm_exec_requests
WHERE DB_NAME(database_id) = 'dbmovie' 
AND blocking_session_id <> 0;

sp_who2

-- liste des réalisateurs avec leur nombre de réalisation
-- ERROR : La colonne 'movies.title' n'est pas valide dans la liste de sélection parce qu'elle n'est pas contenue dans une fonction d'agrégation ou dans la clause GROUP BY.
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

-- avec la pk dans le group by, les homonymes sont séparés
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
-- dans le même paquet
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

-- compter le nombre de films par année 
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






