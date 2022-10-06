-- 1. List all customers who live in Texas (use JOINs)
SELECT *
FROM address;
-- state = address.district
--
SELECT first_name,
    last_name,
    district
FROM customer
JOIN address 
ON customer.address_id = "address".address_id
WHERE address.district = 'Texas'
ORDER BY address.district;
--*************************************
--*** ANSWER: 5 people (see output) ***
--*************************************
-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT first_name,
    last_name,
    amount
FROM customer
    JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY first_name,
    last_name,
    amount
HAVING amount > 6.99
ORDER BY last_name ASC;
--
-- Had an error, used this below to make sure there were amounts greater than 6.99
SELECT amount,
    payment_id
FROM payment
GROUP BY payment_id,
    amount
WHERE amount < 6.99;
--
-- Saw the numbers on the bottom of the side panel and wanted to know if there was a way to create row numbers. There is!
-- Generate numbered rows using ROW_NUMBER() in query:
SELECT ROW_NUMBER() OVER() AS row_num,
    first_name,
    last_name,
    amount
FROM customer
    JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY amount, first_name, last_name
HAVING amount > 6.99
ORDER BY last_name ASC;
--***************************************************************
--*** ANSWER: There are 998 payments above $6.99 (see output) ***
--***************************************************************
-- 3. Show all customers names who have made payments over $175(use subqueries)
-- NOTE: payments = SUM!
-- This seems like the one we did in class.
-- SUBQUERY version:
SELECT first_name, last_name
FROM customer
WHERE customer_id IN 
(       
    SELECT customer_id
    FROM payment
    --GROUP BY customer.last_name, customer.first_name
    --error: payment.customer_id must appear in GROUP BY clause
    GROUP BY payment.customer_id
    HAVING SUM(amount) > 175
    --ORDER BY last_name ASC --> doesn't work here!
)
ORDER BY last_name ASC --works here!
;
-- JOIN version:
SELECT first_name, last_name
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY last_name, first_name
HAVING SUM(amount) > 175
ORDER BY last_name ASC;
--******************************************************************************************************
--*** ANSWER: There are 7 people who appear alphabetically by last name in the output (see output) *****
--******************************************************************************************************
-- 4. List all customers that live in Nepal (use the city table)
-- This is like in class African nation one.
-- customer to address to city to country!
--JOIN version:
SELECT ROW_NUMBER() OVER() AS row_num, 
first_name, last_name, country
FROM customer
JOIN "address"
ON customer.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
WHERE country = 'Nepal'
ORDER BY last_name ASC;
-- SUBQUERY version:
-- ERROR
-- SELECT first_name, last_name
-- FROM customer
-- WHERE address_id IN 
--     (SELECT address_id
--     FROM "address"
--     WHERE city_id IN 
--             (SELECT city_id
--             FROM city
--             WHERE country_id IN
--                 (SELECT country_id, country
--                 FROM country
--                 WHERE country.country = 'Nepal'
--                 GROUP BY country.country_id
--             )))
-- ORDER BY last_name ASC
-- ;
--*********************************************************************
--*** ANSWER: Kevin Schuler is the only customer listed from Nepal. ***
--*********************************************************************
-- 
-- 5. Which staff member had the most transactions?
SELECT * FROM rental; 
-- rental date & staff ID
SELECT * FROM payment;
--rentals and payments generally mean the same transaction;
--choosing payments
--payment date & staff ID
SELECT * FROM staff;
-- staff ID, first_name, last_name
--
--JOIN version:
SELECT staff.first_name, staff.last_name, 
staff.staff_id, SUM(payment.amount)
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id
ORDER BY staff.last_name;
--**************************************************************************
--*** ANSWER: Jon Stephens is the employee with the most transactions. *****
--**************************************************************************
-- 6. How many movies of each rating are there?
SELECT * FROM film;
--film.rating - can ratings be added?
--JOIN version:
SELECT rating, COUNT(rating)
FROM film
GROUP BY rating
ORDER BY COUNT(rating);
--******************************************
--*** ANSWER: 5 categories (see output). ***
--******************************************
--
-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN 
(   SELECT customer_id
    FROM payment
    GROUP BY customer_id, amount
    HAVING amount > 6.99
)
ORDER BY last_name ASC;
--
--JOIN version:
SELECT first_name, last_name, payment.amount
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY last_name, first_name, payment.customer_id, amount
HAVING amount > 6.99
ORDER BY last_name;

--***************************
--*** ANSWER: (see output)***
--***************************
--
-- 8. How many free rentals did our stores give away?
SELECT * FROM rental;
SELECT * FROM payment;
SELECT COUNT(amount) 
FROM payment
WHERE amount = 0.00;
--***************************************************
--*** ANSWER: Our store gave away 24 free rentals.***
--***************************************************

