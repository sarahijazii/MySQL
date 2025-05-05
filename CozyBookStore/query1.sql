-- Creating a temporary table to store unsubscribed customers before deleting.
CREATE TEMPORARY TABLE unsubscribed_backup AS
SELECT c.customer_id, ci.name FROM customers c
JOIN customer_info ci ON c.phone_number = ci.phone_number
WHERE c.customer_id NOT IN (SELECT customer_id FROM subscribed_customers);

--Now, we will delete those unsubscribed customers.
DELETE FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM subscribed_customers);

--Use union to combine unsubscribed and subscribed customer names
SELECT name AS 'Customer Name', 'Unsubscribed' AS Status
FROM unsubscribed_backup
UNION
SELECT ci.name AS 'Customer Name', 'Subscribed' AS Status
FROM customers c
JOIN customer_info ci ON c.phone_number = ci.phone_number
JOIN subscribed_customers sc ON c.customer_id = sc.customer_id;
