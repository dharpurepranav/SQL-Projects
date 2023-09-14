-- 1] How much did movies cost per minute
SELECT title, budget, runtime, round(budget/runtime, 0) as "Budget_Per_Minute"
FROM movie;


-- 2] What are the top 5 movies in terms of budget
select title, budget 
from movie
order by budget desc
limit 5;

-- 3] In terms of release date, how old is every single movie? Show the to 10 youngest movies
select release_date, title, (year(curdate()) - year(release_date)) as age 
from movie
order by age asc
limit 10;

-- 4] In which year did the producer make movie regardless of the number of movies?
select distinct year(release_date) 
from movie;



-- 5] Which movies did cost less than 50000 and what were there genre? Just top 10
select movie.title, movie.budget, genre.genre_name
from movie
join movie_genres on movie.movie_id = movie_genres.movie_id
join genre on genre.genre_id = movie_genres.genre_id
where movie.budget < 50000
order by movie.budget desc
limit 10;

-- 6] Which director did make the most popular movie in English and French language?
select person.person_name, language.language_name, count(*) as movie_count, sum(movie.popularity)
from movie
join movie_crew on movie.movie_id = movie_crew.movie_id
join person on movie_crew.person_id = person.person_id
join movie_languages on movie.movie_id = movie_languages.movie_id
join language on language.language_id = movie_languages.language_id
group by language.language_name, person.person_name
having language.language_name in ('English', 'French')
limit 1;

-- 7] Make a list of actor/actress who played after the year 2010
select person.person_name, movie.title, movie_crew.job
from movie
join movie_crew on movie.movie_id = movie_crew.movie_id
join person on movie_crew.person_id = person.person_id
where movie_crew.job = 'Characters' and movie.release_date > '2010-01-01'
group by person.person_name, movie.title, movie_crew.job;

-- 8] How many horror movies did their budget exceed the budget of average budget of all movies?
select movie.title, movie.budget, movie_genres.genre_id, genre.genre_name
from movie
join movie_genres on movie.movie_id = movie_genres.movie_id
join genre on genre.genre_id = movie_genres.genre_id
where genre.genre_name = 'Horror' and movie.budget > (select avg(movie.budget) from movie);

-- 9] What is the bottom 10 popular movies and which comapany made them?
select  movie.title, sum(movie.popularity) as popularity, production_company.company_name
from movie
join movie_company on movie.movie_id = movie_company.movie_id
join production_company on  production_company.company_id = movie_company.company_id
group by movie.title, production_company.company_name
order by sum(movie.popularity) asc
limit 10;

-- 10] Which movie companies invested the budget between 150k to 200k and for which movies?
select movie.title, movie.budget, production_company.company_name
from movie
join movie_company on movie.movie_id = movie_company.movie_id
join production_company on movie_company.company_id = production_company.company_id
where movie.budget between 15000 and 200000
order by budget desc
limit 1;
