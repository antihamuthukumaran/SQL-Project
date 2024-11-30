/* Retrieving data from multiple tables: INNER JOIN */

-- Create a list of employee records for the business highligting their full names,
-- gender, marital status, jobtitle and hiredate.

select * 
from [HumanResources].[Employee];

select * 
from [Person].[Person];

select [FirstName] + ' ' + [LastName] as FullName, [Gender], [MaritalStatus], [JobTitle], [HireDate]
from [HumanResources].[Employee]
INNER JOIN [Person].[Person]
ON [employee].[BusinessEntityID] = [person].[BusinessEntityID];

select [FirstName] + ' ' + [LastName] as FullName, [Gender], [MaritalStatus], [JobTitle], [HireDate]
from [HumanResources].[Employee] as HRE
INNER JOIN [Person].[Person] as PP
ON HRE.[BusinessEntityID] = PP.[BusinessEntityID];

-- Retrieve a list of product names, their corresponding models and list price.

select ProductID, Name, ProductNumber, ListPrice 
from [Production].[Product]; --504

select * 
from [Production].[ProductModel];

select PPM.Name as Product, PP.Name AS Model, PP.ListPrice 
from [Production].[Product] as PP
INNER JOIN [Production].[ProductModel] as PPM
ON PP.[ProductModelID] = PPM.[ProductModelID];

-- Retrieve detailed information about transactions within the first 6 months of 2014
-- E.G. SalesOrderID, ProductNumber, Product Name, Quantity Sumtotal, OrderDate ... etc.

select [SalesOrderID],[SalesOrderDetailID],[ProductID],[ModifiedDate]
from [Sales].[SalesOrderDetail];

select
	SSOD.SalesOrderDetailID,
	PP.[Name] AS Product,
	SSOD.OrderQty,
	OrderQty * UnitPrice * (1-UnitPriceDiscount) AS SumTotal
from [Sales].[SalesOrderDetail] as SSOD
inner join [Sales].[SalesOrderHeader] as SSOH
on SSOD.[SalesOrderID] = SSOH.[SalesOrderID]
INNER JOIN Production.Product AS PP
ON PP.ProductID = SSOD.ProductID;

/* Retrieving data from multiples tables: LEFT JOIN */

-- Write a query that displays all the products along with the salesOrderID even if
-- an order have never been placed for the product. Join to the Sales.SalesOrderDetail
-- table using the ProductID column.

select * from [Production].[Product]; -- 504

select * from [Sales].[SalesOrderDetail]; -- 121317

select
	SSOD.SalesOrderID, PP.ProductID, PP.[Name]
from [Production].[Product] as PP
left join [Sales].[SalesOrderDetail] as SSOD
on PP.ProductID = SSOD.ProductID;


-- Write a query that returns all the rows from the Sales.SalesPerson table joined to the
-- Sales.SalesOrderHeader and SalesYTD columns in the results.

select * from [Sales].[SalesPerson];

select * from [Sales].[SalesOrderHeader]
where [SalesPersonID] IS NOT NULL;

select
	SalesOrderID, SalesPersonID, SalesYTD
from [Sales].[SalesPerson] as SSP
LEFT JOIN [Sales].[SalesOrderHeader] as SSOH
ON SSOH.SalesPersonID = SSP.BusinessEntityID;

-- Change the query written in question 3 so that the salesperson's name also displays
-- from the Person.Person table.

select
	SalesOrderID, SalesPersonID, SalesYTD, PP.FirstName, PP.LastName, SalesYTD
from [Sales].[SalesPerson] as SSP
LEFT JOIN [Sales].[SalesOrderHeader] as SSOH
ON SSOH.SalesPersonID = SSP.BusinessEntityID
LEFT JOIN [Person].[Person] AS PP
ON PP.BusinessEntityID = SSOH.SalesPersonID;

/* Retrieving data from multiples tables: RIGHT JOIN and FULL JOIN */

-- Join the product table to the Sales.SalesOrderDetail table using the ProductID column.
-- Focus on returning all transactions from the SalesOrderDetail table.

select * from [Production].[Product]; -- 504

select * from [Sales].[SalesOrderDetail]; -- 121317

select
	SSOD.SalesOrderID,
	PP.ProductID,
	PP.[Name]
from [Production].[Product] AS PP
LEFT JOIN [Sales].[SalesOrderDetail] AS SSOD
ON SSOD.ProductID = PP.ProductID; -- 121555

select
	SSOD.SalesOrderID,
	PP.ProductID,
	PP.Name
from [Sales].[SalesOrderDetail] AS SSOD
right join [Production].[Product] AS PP
on PP.ProductID = SSOD.ProductID;

-- Not every person in the AdventureWorks database is an employee. Create a list of every
-- person in the database, and some od their employment data, if it exists.

select * from [HumanResources].[Employee]; -- 290

select * from [Person].[Person]; -- 19972

select
	PP.BusinessEntityID, 
	PP.FirstName, 
	PP.LastName,
	HRE.NationalIDNumber,
	HRE.JobTitle,
	HRE.OrganizationLevel,
	HRE.HireDate
from [HumanResources].[Employee] AS HRE
RIGHT OUTER JOIN [Person].[Person] AS PP
on PP.BusinessEntityID = HRE.BusinessEntityID;


/* Calculations using aggregate functions */

-- Return the average list price of all products in the products table

select avg([ListPrice]) from [Production].[Product];

-- Return the number of products whose price is greater than 500

select count([Name]) from [Production].[Product]
where ListPrice > 500;

-- Return the highest list price of all products

select max([ListPrice]) from [Production].[Product];

-- Return the lowest list price of all products

select min([ListPrice]) from [Production].[Product]
where ListPrice != 0;

-- Return the total sales made for all transactions in the SalesOrderHeader table

select round(SUM([TotalDue]),0) as TotalSales from [Sales].[SalesOrderHeader];

/* GROUP BY clause */

-- Find the number of transactions per year whose totaldue exceeded 1000

select count([TotalDue]), year([OrderDate]) as Order_Year
from [Sales].[SalesOrderHeader]
group by year([OrderDate])
having TotalDue > 1000;

select count([TotalDue]) as OrderCount, year([OrderDate]) as Order_Year
from [Sales].[SalesOrderHeader]
where TotalDue > 1000
group by year([OrderDate])
order by Order_Year;

-- Find the number of products in every product category

select * from [Production].[Product];
select * from [Production].[ProductSubcategory];
select * from Production.ProductCategory;

select PPC.Name AS category, count(PP.Name) AS ProductCount		
from Production.Product as PP
inner join Production.ProductSubcategory as PPSC
on PPSC.ProductSubcategoryID = PP.ProductSubcategoryID
inner join Production.ProductCategory as PPC
on PPC.ProductCategoryID = PPSC.ProductSubcategoryID
group by PPC.[Name]
order by ProductCount desc;

-- What is the Min and Max list price for each product category

select 
PPC.Name AS category, 
MIN(PP.ListPrice) as Min_Price, 
MAX(PP.ListPrice) as Max_Price	
from Production.Product as PP
inner join Production.ProductSubcategory as PPSC
on PPSC.ProductSubcategoryID = PP.ProductSubcategoryID
inner join Production.ProductCategory as PPC
on PPC.ProductCategoryID = PPSC.ProductCategoryID
group by PPC.[Name];


--  What is the total and average sales per territory in the year 2014?

select 
SST.Name AS Territory,
SUM(SSOH.totaldue) as Total_Sales,
avg(SSOH.totaldue) as Average_Sales
from Sales.SalesOrderHeader as SSOH
inner join Sales.SalesTerritory as SST
on SST.TerritoryID = SSOH.TerritoryID
where year(OrderDate) = 2014
group by SST.Name;

select
SST.[Group] as Continent,
SST.[Name] AS Territory,
SUM(SSOH.TotalDue) as Total_Sales,
avg(SSOH.TotalDue) as Average_Sales
from Sales.SalesOrderHeader as SSOH
inner join Sales.SalesTerritory as SST
on SST.TerritoryID = SSOH.TerritoryID
where year(OrderDate) = 2014
group by SST.[Name], SST.[Group]
order by Continent;

/* Filtering groups with HAVING clause */

-- Find the dates where more than 100 transactions occured

select cast([OrderDate] as date) as [Date], count(*) as OrderCount
from Sales.SalesOrderHeader
group by OrderDate
having count(*)>100;

-- Find product subcategories whose average list prices are between 500 and 2000

select 
	PPSC.[Name],
	avg(ListPrice) AS Average_Price
from Production.Product as PP
inner join Production.ProductSubcategory as PPSC
on PPSC.ProductSubcategoryID = PP.ProductSubcategoryID
group by PPSC.[Name]
having avg(ListPrice) between 500 and 2000;

/* Combining queries with UNION and UNION ALL */

-- Retrieve details of employees in a sales store

select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where JobTitle LIKE '%Sales%'; -- 18 rows

-- Retrieve details of employees in organisation level 1 or 2

select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where OrganizationLevel IN (1,2); -- 33 rows



select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where JobTitle LIKE '%Sales%'
union
select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where OrganizationLevel IN (1,2); -- 47 rows

-- Retrieve details of employees in either a sales role OR organisation level 1 or 2

select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where JobTitle LIKE '%Sales%'
intersect
select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where OrganizationLevel IN (1,2); -- 4 rows

-- Retrieve details of employees in a sales role who are NOT
-- within the organization level 1 or 2

select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where JobTitle LIKE '%Sales%'
except
select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where OrganizationLevel IN (1,2) -- 14 rows
union
select NationalIDNumber, JobTitle, HireDate, OrganizationLevel, BirthDate, MaritalStatus
from [HumanResources].[Employee]
where JobTitle LIKE '%Assistant%'; -- 29 rows in total

/* CASE Expressions: Simple & Searched Case Formats */

-- Write a query to retrieve the following information from the product table:
-- ProductNumber, Name, Productline, Makeflag, and Discontinued Date. Include a case
-- statement for productline such the R = Road, T = Touring, S = Standard, M = Mountain.
-- Also define the actual meanings of Makeflag such that 0 = Purchased, and 1 = Manufactured
-- In-House.

select [ProductNumber], [Name], [ProductLine], [MakeFlag], [DiscontinuedDate],
	case [ProductLine]
		when 'R' then 'Road'
		when 'S' then 'Standard'
		when 'M' then 'Mountain'
		when 'T' then 'Touring'
		else 'N/A'
	end as ProductLine,
	case MakeFlag
		when 1 then 'Manufactured In-House'
		else 'Purchased'
	end as MakeFlag
from [Production].[Product];


-- Write a query using the Sales.SalesOrderDetail table to display a value ("Under 10,
-- "10-19" or "20-29" or "30-39" or "40 and over") based on the OrderQty value by 
-- using the CASE function. Include the SalesOrderID and OrderQty columns in the results.

select [SalesOrderID], [OrderQty],
	case
		when [OrderQty] between 0 and 9 then 'Under 10'
		when [OrderQty] between 10 and 19 then '10-19'
		when [OrderQty] between 20 and 29 then '20-29'
		when [OrderQty] between 30 and 39 then '30-39'
		else '40 or over'
	end as QtyRange
from [Sales].[SalesOrderDetail]
order by OrderQty;

/* Introduction to SQL Views */

-- Create a view named "Product_Catalog". The view should include the following columns:
-- ProductID, ProductNumber, ProductName, Color, Size, StandardCost, ProductSubcategory,
-- ProductCategory.

create view Product_Catalog as
select
	PP.ProductID, PP.ProductNumber,
	PP.Name AS ProductName,
	isnull(PP.Color,'') as Color, isnull(PP.Size,'') as Size, PP.StandardCost,
	isnull(PPSC.Name,'') AS ProductSubcategory,
	ISNULL(PPC.Name,'') AS ProductCategory
from [Production].[Product] as PP
LEFT JOIN Production.ProductSubcategory as PPSC
ON PP.ProductSubcategoryID = PPSC.ProductSubcategoryID
LEFT JOIN Production.ProductCategory as PPC
on PPC.ProductCategoryID = PPSC.ProductCategoryID;

select * from [dbo].[Product_Catalog];

/* Introduction to SQL Subquery */

-- Using a subquery, display the product names and product ID numbers from the
-- Production.Product table that have been ordered.

select ProductID, Name from Production.Product
where ProductID IN (select ProductID from Sales.SalesOrderDetail);


-- Display the product details in the product table. Include the ProductNumber, Name,
-- ListPrice and average ListPrice.

select ProductNumber, Name, ListPrice, 
(select avg([ListPrice]) as AvgPrice from Production.Product)
from Production.Product;

-- Write a query to display the SalesOrderID and OrderDate of orders whose 
-- TotalDue/SalesAmount is greater than the average value.

select SalesOrderID, OrderDate, TotalDue,
(select avg([TotalDue]) from Sales.SalesOrderHeader) AS AvgTotalDue
from Sales.SalesOrderHeader
where TotalDue > (select avg([TotalDue]) from Sales.SalesOrderHeader);

/* Introduction to CTE in SQL Server */

-- Single CTE
-- Calculate the total sales and commission value of each Sales Person for year 2014

WITH SalesPerson AS (

	select
		A.BusinessEntityID,
		FirstName + ' ' + LastName AS SalesPerson,
		CommissionPct
	from Sales.SalesPerson as A
	inner join Person.Person as B
	on A.BusinessEntityID = B.BusinessEntityID
	where SalesQuota is not null
	)
select
	SalesPerson,
	sum([SubTotal]) as Sales,
	sum([SubTotal]) * CommissionPct as Commission,
	CommissionPct
from Sales.SalesOrderHeader as A
inner join SalesPerson as B
on B.BusinessEntityID = A.SalesPersonID
where year(OrderDate) = 2014
group by SalesPerson, CommissionPct;

-- Multiple CTE in a single query
-- Calculate the total sales and Commission of each Sales Person for year 2014

WITH SalesPerson AS (

	select
		A.BusinessEntityID,
		FirstName + ' ' + LastName AS SalesPerson,
		CommissionPct
	from Sales.SalesPerson as A
	inner join Person.Person as B
	on A.BusinessEntityID = B.BusinessEntityID
	where SalesQuota is not null
),
	Sales2014 AS (
	select
		SalesPerson,
		sum([SubTotal]) as Sales,
		sum([SubTotal]) * CommissionPct as Commission,
		CommissionPct
	from Sales.SalesOrderHeader as A
	inner join SalesPerson as B
	on B.BusinessEntityID = A.SalesPersonID
	where year(OrderDate) = 2014
	group by SalesPerson, CommissionPct
)
select SalesPerson, Sales, Commission
from Sales2014;