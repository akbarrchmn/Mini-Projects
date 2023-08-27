/* 1. Identify the top 10 customers and their email so we can reward them */

SELECT customer.first_name, customer.last_name, customer.email, SUM (amount) AS total_spent
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name, customer.email ORDER BY total_spent DESC limit 10;

/* 2. Identify the bottom 10 customers and their emails so we can follow up about their issues */

SELECT customer.first_name, customer.last_name, customer.email, SUM (amount) AS total_spent
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name, customer.email ORDER BY total_spent ASC limit 10;

/* 3. What are the most profitable movie genres (ratings) ? */

SELECT film.rating, SUM (payment.amount) AS total_revenue
FROM payment
JOIN rental
ON payment.rental_id = rental.rental_id
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.rating ORDER BY total_revenue DESC;

/* 4. How many rented movies were returned late, early, and on time ? */

SELECT 
SUM (CASE
	WHEN film.rental_duration - (rental.return_date::DATE - rental.rental_date::DATE) < 0 
	THEN 1
	ELSE 0
	END) AS "Late",
SUM (CASE
	WHEN film.rental_duration - (rental.return_date::DATE - rental.rental_date::DATE) > 0 
	THEN 1
	ELSE 0
	END) AS "Early",
SUM (CASE
	WHEN film.rental_duration - (rental.return_date::DATE - rental.rental_date::DATE) = 0 
	THEN 1
	ELSE 0
	END) AS "On time"
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id;

/* 5. What is the customer base in the countries where we have a presence ? */

SELECT country.country, SUM (customer.active) AS customer_base
FROM country
JOIN city
ON country.country_id = city.country_id
JOIN address
ON city.city_id = address.city_id
JOIN customer
ON address.address_id = customer.address_id
GROUP BY country.country ORDER BY customer_base DESC;

/* 6. Which country is the most profitable for the business ? */

SELECT country.country, SUM (payment.amount) AS total_revenue
FROM country
JOIN city
ON country.country_id = city.country_id
JOIN address
ON city.city_id = address.city_id
JOIN customer
ON address.address_id = customer.address_id
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY country.country ORDER BY total_revenue DESC limit 5;

/* 7. What is the average rental rate per movie genre (rating) ? */

SELECT rating AS genre, ROUND(AVG (rental_rate),2) AS avg_rent_rate 
FROM film
GROUP BY rating;
