-- Selection columns from the dataset

select
[FirstName],[LastName],[CompanyName],[EmailAddress],[Phone]
from [SalesLT].[Customer];

/* Selecting all columns from the dataset */

select * from [SalesLT].[Customer];

select [FirstName] + ' ' + [LastName] as FullName, [FirstName], [LastName]
from [SalesLT].[Customer];

-- Order By

select [FirstName] + ' ' + [LastName] as CustomerName,[CompanyName],[EmailAddress] as Email,[Phone]
from [SalesLT].[Customer]
order by CompanyName;

select [FirstName] + ' ' + [LastName] as CustomerName,[CompanyName],
		[EmailAddress] as Email,[Phone]
from [SalesLT].[Customer]
order by CustomerName;

/*
Limiting Results 
- Top N
- Top N Percent
- Ties
*/

-- First 20 most expensive products based on standardcost

select top 20 [ProductNumber], [Name], [Size], [StandardCost], [SellStartDate]
from [SalesLT].[Product]
order by StandardCost desc;

-- First 20 most affordable products based on standardcost
select top 20 [ProductNumber], [Name], [Size], [StandardCost], [SellStartDate]
from [SalesLT].[Product]
order by StandardCost;

-- First 25% of records present in the table
select top 25 percent [ProductNumber], [Name], [Size], [StandardCost], [SellStartDate]
from [SalesLT].[Product]
order by StandardCost;

-- First 14 most expensive products based on standardcost
-- We observe 18 rows as, although we expected 14 rows there 
-- are 4 more products that share the same cost, therefore bringing them to our attention too. 

select top 14 with ties 
	[ProductNumber], [Name], [Size], [StandardCost], [SellStartDate]
from [SalesLT].[Product]
order by StandardCost desc;

-- Removing Duplicates: DISTINCT

select distinct [Color]
from [SalesLT].[Product];

select distinct [Color],[SellStartDate]
from [SalesLT].[Product];

-- Built In Functions

select [ProductNumber],[SellStartDate],
	YEAR([SellStartDate]) AS StartYear,
	MONTH([SellStartDate]) AS StartMonth,
	DAY([SellStartDate]) AS StartDate,
	DATENAME(QQ, [SellStartDate]) StartQuarter, -- YY, QQ, DY, WK, hh, mi, ss, ms
	DATENAME(MM, [SellStartDate]) StartQuarter,
	GETDATE() AS CurrentDate,
	DATEDIFF(YY,[SellStartDate], GETDATE()) AS ProductAge,
	DATEADD(MM,-5,[SellStartDate]) AS FiveMonthsFromStartDate
from [SalesLT].[Product];

-- Find the number of days to ship for every transaction. 
-- Include the salesorderid, orderdate and shipdate.

select [SalesOrderID], [OrderDate], [ShipDate],
	DATEDIFF(DD, [OrderDate], [ShipDate]) AS NumberOfDaysToShip
from [SalesLT].[SalesOrderHeader];

-- Mathematical Functions

select ABS(-6), Ceiling(5.4), Floor(5.9), POWER(2,3), ROUND(88.444,2), SQRT(9);

-- String Function

select
	[ProductNumber], [Name],
	UPPER([Name]) AS UpName,
	LOWER([Name]) AS LowName,
	[ProductNumber] + ': ' + [Name],
	CONCAT([ProductNumber], ': ', [Name]),
	LEFT([ProductNumber], 2) AS ProductType,
	RIGHT([ProductNumber],1) AS RightMost1,
	SUBSTRING([ProductNumber],4,4) AS ModelNumber,
	REVERSE(SUBSTRING([ProductNumber],4,4)),
	LEN([ProductNumber])
from [SalesLT].[Product];

-- Write a query using the Product Table displaying the product ID, color, and name column.
-- If the color column contains a Null value, replace the color with no color.

select [ProductID], [Name], [Color], ISNULL([Color], 'No Color')
from [SalesLT].[Product]


-- Write a query using the Product Table displaying a description with the "ProductID:Name" format.

select [ProductID], [Name], CAST([ProductID] AS VARCHAR(50)) + ':' + [Name]
from [SalesLT].[Product];

select cast(2 as decimal(16,4)) -- Maximum of 16 characters, 4 decimal places.

/* Filtering Data with WHERE clause Basic Operators
=:  Equal to
<>: Not equal to
>:  Greater than
<:  Less than
>=: Greater than or equal to
<=: Less than or equal to
*/

-- Retrieve a list of products that began selling in year 2002
select
	[ProductNumber],[Name],[Color],[Size],[StandardCost],[SellStartDate]
from [SalesLT].[Product]
where year([SellStartDate]) = 2002;

-- Retrieve a list of products that began selling in year 2007
select
	[ProductNumber],[Name],[Color],[Size],[StandardCost],[SellStartDate]
from [SalesLT].[Product]
where year([SellStartDate]) = 2007;

-- Retrieve a list of products excluding those from the year 2007
select
	[ProductNumber],[Name],[Color],[Size],[StandardCost],[SellStartDate]
from [SalesLT].[Product]
where year([SellStartDate]) <> 2007;

select
	[ProductNumber],[Name],[Color],[Size],[StandardCost],[SellStartDate]
from [SalesLT].[Product]
where [Color] = 'Black';

-- Retrieve a list of products that started selling between 2006 and 2007

select *
from [SalesLT].[Product]
where year([SellStartDate]) between 2006 and 2007;

-- Retrieve a list of products between 500 and 1000 standardcost

select *
from [SalesLT].[Product]
where [StandardCost] between 500 and 1000;

-- Retrieve a list of products that have red, silver or black as their color

select *
from [SalesLT].[Product]
where [color] in ('Red','Silver','Black');

-- Retrieve a list of products that started selling between 2006 and 2007

select *
from [SalesLT].[Product]
where year([SellStartDate]) IN (2006,2007);

-- Retrieve the list of customers with lastname starting with A

select [CustomerID], [FirstName], [LastName], [EmailAddress], [CompanyName]
from [SalesLT].[Customer]
where LastName like 'A%';

-- Retrieve the list of customers with lastname ending with er

select [CustomerID], [FirstName], [LastName], [EmailAddress], [CompanyName]
from [SalesLT].[Customer]
where LastName like '%er';

-- Retrieve the list of customers with their latsname starting with T and ending with S

select [CustomerID], [FirstName], [LastName], [EmailAddress], [CompanyName]
from [SalesLT].[Customer]
where LastName like 'T%S';

-- Retrieve the list of customers having A in their lastname

select [CustomerID], [FirstName], [LastName], [EmailAddress], [CompanyName]
from [SalesLT].[Customer]
where LastName like '%A%'
order by LastName;

-- Retrieve the list of customers where the second character of their lastname is U

select [CustomerID], [FirstName], [LastName], [EmailAddress], [CompanyName]
from [SalesLT].[Customer]
where LastName like '_U%';

-- Retrieve the details of red color products with a standardcost lesser than 150

select [Name],[Color],[StandardCost], [SellStartDate]
from [SalesLT].[Product]
where color = 'Red' and StandardCost < 150;

-- Retrieve information about products like Jersey that began selling in 2005

select [Name],[Color],[StandardCost],[SellStartDate]
from [SalesLT].[Product]
where Name like '%jersey%' and year([SellStartDate]) = 2005;

-- Retrieve information about products that are either color red or are cheaper than 500

select [Name],[Color],[StandardCost]
from [SalesLT].[Product]
where color = 'Red' or StandardCost < 500;

-- Retrieve the details of red color products with a standardcost lesser than 150
-- or began selling in 2005

select [Name],[Color],[StandardCost]
from [SalesLT].[Product]
where YEAR([SellStartDate]) = 2005 or (color = 'Red' and StandardCost < 150);

-- Retrieve the details of products that are not red with a standardcost lesser than 150

select [Name],[Color],[StandardCost]
from [SalesLT].[Product]
where color != 'Red' and StandardCost < 150;

select [Name],[Color],[StandardCost]
from [SalesLT].[Product]
where not color = 'Red' and StandardCost < 150;

/* Handling Null values using: IS NULL, IS NOT NULL, ISNULL() and COALESCE */

-- Retrieve details of products that are no longer sold i.e. having a sell end date

select [ProductID], [Name], [Color], [StandardCost], [SellStartDate], [SellEndDate]
from [SalesLT].[Product]
where SellEndDate is not null;

-- Retrieve details of products that are still being sold i.e. has no sellenddate

select [ProductID], [Name], [Color], [StandardCost], [SellStartDate], [SellEndDate]
from [SalesLT].[Product]
where SellEndDate is null and SellStartDate is not null;

-- Retrieve details of products that have no color

select [ProductID], [Name], [Color], [StandardCost], [SellStartDate], [SellEndDate]
from [SalesLT].[Product]
where color is null;

/* Retrieving data from multiple tables: INNER JOIN */

-- Create a list of employee records for the business highligting their full names,
-- gender, marital status, jobtitle and hiredate.



-- Retrieve a list of product names, their corresponding models and list price.



-- Retieve detailed information about transactions within the first 6 months of 2014
-- e.g. SalesOrderID, ProductNumber, Product Name, Quantity Sumtotal, OrderDate ... etc.

