/* first slide : display the number of the movies in the categories */
/* and total count of movies */
WITH tab1 AS
  (SELECT c.name AS category,
          COUNT(*) AS number_of_movies
   FROM film AS f
   JOIN film_category AS fc
     ON f.film_id = fc.film_id
   JOIN category c
     ON fc.category_id = c.category_id
   GROUP BY
         1
   ORDER BY
         1
)
SELECT category,
       number_of_movies AS movies_in_category,
       SUM(number_of_movies) OVER (
         ORDER BY category) AS all_movies
FROM tab1 ;

/* second slide : What is real number of movies and how many actors played in there */
SELECT f.film_id,
       COUNT(fa.actor_id) AS number_of_actors,
       ROW_NUMBER() OVER (
          ORDER BY f.film_id) AS number_of_movies
FROM film AS f
JOIN film_actor AS fa
  ON fa.film_id = f.film_id
GROUP BY
       1
ORDER BY
       1
;

/* third slide: Find min, avg, max of rental duration in all rental period*/
WITH tab1 AS (
  SELECT f.film_id AS film_id,
          f.title AS film_title,
          f.length AS film_length,
          f.rental_duration AS rental_duration
   FROM film AS f
   JOIN film_actor AS fa
     ON fa.film_id = f.film_id
   JOIN actor AS a
     ON fa.actor_id = a.actor_id
),
tab2 AS (
  SELECT film_id,
          film_title,
          film_length,
          rental_duration
   FROM tab1
   GROUP BY 1,
            2,
            3,
            4
)
  SELECT MIN(film_length) AS min_movie_length,
         AVG(film_length) AS avg_movie_length,
         MAX(film_length) AS max_movie_length
   FROM tab2;

/* fourth slide: The graph shows the number of customer from the countries (>25) */
/* WINDOW function counts all the customers*/
WITH tab1 AS (
  SELECT co.country AS country,
          co.country_id AS country_id,
          COUNT(*) AS customers_per_country
   FROM customer AS cu
   JOIN address AS a
     ON cu.address_id = a.address_id
   JOIN city c
     ON a.city_id = c.city_id
   JOIN country co
     ON co.country_id = c.country_id
   GROUP BY 1,
            2
)
SELECT country_id,
       country,
       customers_per_country,
       SUM(customers_per_country) OVER (ORDER BY country) AS all_customers
FROM tab1
GROUP BY 1,
         2,
         3
;
