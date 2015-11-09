#1 Find the film title and language name of all films in which ADAM GRANT acted
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)

SELECT f.title, l.name 
	FROM film f INNER JOIN language l ON f.language_id = l.language_id
	INNER JOIN film_actor fa ON fa.film_id = f.film_id
	INNER JOIN actor a ON a.actor_id = fa.actor_id
	WHERE a.first_name = "ADAM" AND a.last_name = "GRANT"
	ORDER BY title DESC;
	 

#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).


SELECT COUNT(fc.film_id) as count, c.name
	FROM (
	SELECT f.film_id AS movieID, l.name 
	FROM film f INNER JOIN language l ON f.language_id = l.language_id
	INNER JOIN film_actor fa ON fa.film_id = f.film_id
	INNER JOIN actor a ON a.actor_id = fa.actor_id
	WHERE a.first_name = "ED" AND a.last_name = "CHASE"
	) as movies

	LEFT JOIN film_category fc ON movies.movieID = fc.film_id
	RIGHT JOIN category c ON c.category_id = fc.category_id
	GROUP BY c.name
	ORDER BY count DESC;



#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT allActors.first_name, allActors.last_name, sfActors.total
FROM 
    (SELECT a.first_name, a.last_name, a.actor_id
     FROM actor a
     ) 
    AS allActors
LEFT JOIN 
    (SELECT a.first_name, a.last_name, a.actor_id, SUM( f.length ) AS total, c.name
    FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
	INNER JOIN film f ON f.film_id = fa.film_id 
	INNER JOIN film_category fc ON fc.film_id = f.film_id
	INNER JOIN category c ON c.category_id = fc.category_id
	WHERE c.name = 'sci-fi'
	GROUP BY a.actor_id)
	AS sfActors
ON allActors.actor_id = sfActors.actor_id;



#4 Find the first name and last name of all actors who have never been in a Sci-Fi film

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN 
    (SELECT a.actor_id
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    INNER JOIN actor a ON fa.actor_id = a.actor_id
    WHERE c.name =  'sc-fi'
    GROUP BY f.title);


#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies


SELECT T1.title, T1.first_name, T1.last_name, T2.first_name, T2.last_name FROM

(SELECT f.title, a.first_name, a.last_name 
    FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
    INNER JOIN film f ON fa.film_id = f.film_id
    WHERE a.first_name = 'KIRSTEN' AND a.last_name='PALTROW') as T1

INNER JOIN

(SELECT f.title, a.first_name, a.last_name 
    FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
    INNER JOIN film f ON fa.film_id = f.film_id
    WHERE a.first_name = 'WARREN' AND a.last_name='NOLTE') as T2

ON T1.title = T2.title;