-- Subqueries notes:
-- Records are returned from Subquery first, as they are part of Parent query
-- often in SELECT (us!) and FROM
-- usually in or act as WHERE or HAVING clauses
--Example Join and Subquery:
--JOIN:
SELECT first_name
FROM customer
    JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
HAVING SUM(amount) >= 175;
-- This search is same as the above join
--SUBQUERY:
-- work from back to front
SELECT first_name
FROM customer
WHERE customer_id IN (
        SELECT customer_id
        FROM payment
        GROUP BY customer_id
        HAVING SUM(amount) >= 175
        ORDER BY SUM(amount)
    );
-- ++++++++++++++++++++++++++++++ --
-- Another Example: films in English language
-- Start with inside first
(
    SELECT language_id
    FROM "language"
    WHERE name = 'English'
) -- Do outside
SELECT *
FROM film
WHERE language_id IN -- Put the parts together
SELECT *
FROM film
WHERE language_id IN (
        SELECT language_id
        FROM "language"
        WHERE name = 'English'
    ) -- This is the same inquiry with a join
SELECT name
FROM "language"
    JOIN film ON "language".language_id = film.language_id
GROUP BY "language" _id
HAVING name = 'English';
SELECT title
FROM film
    JOIN language ON film.language_id = "language".language_id
WHERE language.name = 'English';
-- ++++++++++++++++++++++++++++++ --
-- SQL Order of Operations:
-- SELECT
-- FROM
-- JOIN
-- ON
-- WHERE = applies condition to individual rows before rows are grouped
-- GROUP BY - usually a Primary and/or Foreign key (_id)
-- HAVING = applies condition to rows after rows are grouped
-- ORDER BY
-- ============================= --
-- Aggregates group info together, and include; 
-- avg, count, min max, sum
-- Use HAVING instead of WHERE
-- Must be accompanied by GROUP BY or the return will break!