-- Creating Databases and Tables 

CREATE TABLE table_name;

-- The below query will produce a new table which will contain all the columns of the exsting table
and the columns defined in the CREATE TABLE statement 

CREATE TABLE table_name (column_name TYPE column_constraint, table_contraint) 
INHERITS existing_table_name;

-- Example Codes

CREATE TABLE account(
	user_id serial PRIMARY KEY,
	username VARCHAR (50) UNIQUE NOT NULL,
	password VARCHAR (50) NOT NULL,
	email VARCHAR (355) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP);

CREATE TABLE role(
	role_id serial PRIMARY KEY,
	role_name VARCHAR (255) UNIQUE NOT NULL);

-- Example Question: Produce a table which contains a customers first name,last name, email, sign-up date, 
-- and number of minutes spent on dvd rental site. You should also have some sort of id tracker for them.

CREATE TABLE leads( 
	user_id serial primary key,
	first_name varchar(50) not null, 
	last_name varchar(50) not null, 
	email varchar(150) unique not null, 
	minutes integer not null, 
	sign_up_date timestamp not null);

-- INSERT Statements

INSERT INTO table_name (column_1, column_2, ..., column_n)
                VALUES (value_1, value_2, ..., value_n), 
		           (value_1, value_2, ..., value_n), ...;

-- INSERT data from another table

INSERT INTO table_name 
SELECT column_1, column_2, ...
FROM copying_table_name
WHERE conditions;

-- Copy the structure of an existing table 

CREATE TABLE new_table (LIKE existing_table);

-- UPDATE Statements 

UPDATE table_name 
SET column_1 = value_1, column_2 = value_2, ...
WHERE condition
RETURNING column_1, column_2, ..., column_n;

-- DELETE Statement

DELETE FROM table_name
WHERE condition;

-- ALTER TABLE Statement
-- In the below query, 'action's include: ADD COLUMN, DROP COLUMN, RENAME COLUMN, ADD CONSTRAINT, RENAME TO
-- DATATYPE refers to datatypes such as BOOLEAN, CHAR(n), VARCHAR(n), FLOAT(n), NUMERIC(p,s), INT, DATE, TIME, TIMESTAMP,INTERVAL ... 

ALTER TABLE table_name action;
ALTER TABLE table_name TO new_table_name;
ALTER TABLE table_name ADD COLUMN column_name DATATYPE 

-- DROP TABLE Statement (RESTRICT will not allow you to drop the table if there are tables dependent on it.
-- CASCADE will remove the dependent objects alongside the table all at once).

DROP TABLE IF EXISTS table_name RESTRICT;
DROP TABLE IF EXISTS table_name CASCADE;

-- CHECK Constraint (if the values of the column pass the check, the value will be inserted/updated).

-- Example Code: The salary constraint will be named positive_salary, if any of the conditions are not met SQL will give us
-- an error stating which contraint has been violated and to check that particular constraint.

CREATE TABLE staff(
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	salary INTEGER CONSTRAINT positive_salary CHECK(salary >0),
	birth_date DATE CHECK(birth_date > '1900-01-01'),
	join_date DATE CHECK(join_date > birth_date));
