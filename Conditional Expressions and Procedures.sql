-- CASE Statements

General syntax:

CASE
	WHEN condition_1 THEN result_1
	WHEN condition_2 THEN result_2
	ELSE some_other_result
END;


SELECT customer_id,
CASE
	WHEN (customer_id <= 100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
	ELSE 'Normal'
END AS customer_class
FROM customer;

SELECT customer_id,
CASE customer_id
	WHEN 2 THEN 'Winner'
	WHEN 5 THEN 'Second Place'
	ELSE 'Unsuccessful'
END AS raffle_results
FROM customer;

-- How many films are bargains, normal or premium?

SELECT
SUM(CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END) AS Bargains,
SUM(CASE rental_rate
   WHEN 2.99 THEN 1
   ELSE 0
END) AS Regular,
SUM(CASE rental_rate
   WHEN 4.99 THEN 1
   ELSE 0
END) AS Premium
FROM film;

-- How many films do we have that are rated r, pg and pg13.

SELECT DISTINCT(rating) FROM film;

SELECT
SUM(CASE rating
	WHEN 'R' THEN 1
	ELSE 0
END) AS R,
SUM(CASE rating
   WHEN 'PG' THEN 1
   ELSE 0
END) AS PG,
SUM(CASE rating
   WHEN 'PG-13' THEN 1
   ELSE 0
END) AS PG13
FROM film;

-- COALESCE: Becomes useful when quering a table with nulls and wish to substitute the null with another value.

CREATE TABLE products ( 
	Product varchar(10) primary key,
	RRP integer not null,
    Discount integer);

INSERT INTO products (Product, RRP, Discount)
values ('A',100,10), ('B',250, null ), ('C',500,50);

SELECT * FROM products;

SELECT product, (rrp - COALESCE(discount,0)) AS final_price FROM products;

-- CAST: Convert from one data type to another.

SELECT cast('5' as integer) AS new_int;

SELECT '10'::integer;

SELECT * FROM rental;

SELECT char_length(CAST(inventory_id AS varchar)) FROM rental;

-- NULLIF: Retuns null if both inputs are equal, if not, it will return the first input.

CREATE TABLE depts(
first_name VARCHAR(50),
department VARCHAR(50));

INSERT INTO depts(
first_name,
department
)
VALUES
('Vinton', 'A'),
('Lauren', 'A'),
('Claire', 'B');

SELECT * FROM depts;

SELECT(
SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END)
) AS department_ratio
FROM depts;

DELETE FROM depts
WHERE department = 'B';

SELECT * FROM depts;

SELECT(
SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
NULLIF(SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END),0)
) AS department_ratio
FROM depts;

-- View: A view is a database object that is of a stored query. It does store data physically, it simply stores the query.

CREATE VIEW customer_info AS
SELECT first_name, last_name, address FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;

SELECT * FROM customer_info;

CREATE OR REPLACE VIEW customer_info AS
SELECT first_name, last_name, address, district FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;

SELECT * FROM customer_info;

ALTER VIEW customer_info RENAME TO customer_information;

FROP VIEW IF EXISTS customer_info;

-- Import and Export: Allows us to import data from a csv file to an already existing table.

CREATE TABLE simple(
a integer,
b integer,
c integer);

SELECT * FROM simple;