-- Statement Fundamentals Cheat Sheet

-- SELECT Statements

SELECT * FROM table_name;

SELECT column_x, column_y, column_z 
FROM table_name;

-- Select DISTINCT

SELECT distinct(column_name) 
FROM table_name;

-- Select WHERE

SELECT * FROM table_name 
WHERE conditions;

-- Example Below

SELECT first_name, last_name 
FROM customer 
WHERE first_name = 'Jamie' AND last_name = 'Rice';
  
-- COUNT Function

SELECT count(*) FROM table_name;

-- LIMIT Statement (Top N Entries)

SELECT column_name 
FROM table_name 
LIMIT N; 

-- ORDER BY Statement

SELECT * FROM table_name 
ORDER BY column_name ASC;

-- BETWEEN/NOT BETWEEN Statement

SELECT * FROM table_name 
WHERE column_name BETWEEN X AND Y;

SELECT * FROM table_name 
WHERE column_name NOT BETWEEN X AND Y;

-- IN statement (When we have multiple OR)

SELECT * FROM table_name 
WHERE column_name IN (X,Y,Z);

-- The above can be rewritten as

SELECT * FROM table_name 
WHERE column_name = X OR column_name = Y OR column_name = Z;

-- LIKE/ILIKE Statement

SELECT * FROM table_name 
WHERE column_name LIKE 'string%';

-- Example

SELECT first_name, last_name FROM customer 
WHERE first_name LIKE 'John%';