/*
Q3: List of customers to whom we made a sale prior to 2016 but no sale since 2016-01-01.
*/

USE [WideWorldImporters]
GO

with tmp as 
(select c.CustomerName, max(o.OrderDate) as lastOrderDate from
	(select CustomerName, CustomerID from Sales.Customers
	union
	select CustomerName, CustomerID from Sales.Customers_Archive) as c
join Sales.Orders o on c.CustomerID =o.CustomerID group by c.CustomerName)
select CustomerName, lastOrderDate from tmp where lastOrderDate < '2016-01-01';
