GROUP BY Statements Cheat Sheet

-- Aggeregate Functions: MIN,MAX,AVG,SUM,ROUND.

-- In the example below 'Function' will be replaced by an aggeragate function such as 
'MIN','MAX','AVG' OR 'SUM'.

SELECT Function(column_name) 
FROM table_name; 

-- In the example below 'Function' will be replaced by an aggeragate function such as 
'MIN','MAX','AVG' OR 'SUM' and 'X' is an integer representing the number of decimal places
we are rounding to.

SELECT ROUND(Function(column_name),X) 
FROM table_name;

-- GROUP BY Statements 
-- In the example below 'Function' will be replaced by an aggeragate function such as 
'MIN','MAX','AVG' OR 'SUM'.

SELECT column1_name, Function(Column2_name)
FROM table_name GROUP BY column1_name;

-- We have two staff members with staff IDs 1 and 2. We want to give a bonus to 
the staff member that handled the most payments. Which staff member gets the bonus?

SELECT staff_id, count(amount), round(sum(amount),0)
FROM payment 
GROUP BY by staff_id;

-- Corprate HQ is auditing our store. They want to know the average replacement cost of
movies by rating.

SELECT rating, ROUND(AVG(replacement_cost),2)
FROM film 
GROUP BY rating 
ORDER BY AVG(replacement_cost);

-- We want to send coupons to the 5 top spending customers, find their customer ids.

SELECT customer_id, ROUND(SUM(amount),2)
FROM payment 
GROUP BY customer_id
ORDER BY SUM(amount) 
DESC LIMIT 5;

-- HAVING Statements
-- In the example below 'Function' will be replaced by an aggeragate function such as 
'MIN','MAX','AVG' OR 'SUM', and 'condition' for instance is column1_name > a number.

SELECT column1_name, Function(column2_name) 
FROM table_name 
GROUP BY column1_name 
HAVING condition;

-- We wish to provide customers that have at least 40 transaction payments with 
a platinum credit card, find the customer ids that are eligible. 

SELECT customer_id, COUNT(amount) 
FROM payment 
GROUP BY customer_id 
HAVING COUNT(amount)>=40;

-- What movie ratings have an average rental duration of more than 5 days?

SELECT rating, ROUND(AVG(rental_duration),2) 
FROM film 
GROUP BY rating 
HAVING AVG(rental_duration)>5 
ORDER BY AVG(rental_duration);