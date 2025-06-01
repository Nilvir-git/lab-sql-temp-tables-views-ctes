SELECT *
FROM customer;

SELECT *
FROM rental;

SELECT *
FROM customer;

CREATE VIEW customer_rental_summary AS
	SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
	FROM customer c
	LEFT JOIN rental r
	ON c.customer_id = r.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


SELECT *
FROM payment;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    crs.first_name,
    crs.last_name,
    crs.email,
    crs.rental_count,
    SUM(p.amount) AS total_paid
FROM 
    customer_rental_summary crs
LEFT JOIN 
    payment p ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id, crs.first_name, crs.last_name, crs.email, crs.rental_count;
    

WITH customer_summary_cte AS (
    SELECT 
        cps.first_name,
        cps.last_name,
        cps.email,
        cps.rental_count,
        cps.total_paid
    FROM 
        customer_payment_summary cps
)

SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(CASE 
              WHEN rental_count = 0 THEN 0
              ELSE total_paid / rental_count
         END, 2) AS average_payment_per_rental
FROM 
    customer_summary_cte
ORDER BY 
    total_paid DESC;