/*
List of Customers and their phone number, together with the primary contact person’s name, to whom we did not sell more than 10  mugs (search by name) in the year 2016.
*/

USE [WideWorldImporters]
GO

select c.CustomerID, c.CustomerName, c.PhoneNumber, SUM(ol.Quantity) as sell_qty, YEAR(o.OrderDate) as sell_year from Sales.Customers c join Application.People p on c.PrimaryContactPersonID = p.PersonID join Sales.Orders o on o.CustomerID = c.CustomerID join Sales.OrderLines ol on ol.OrderID = o.OrderID
where YEAR (o.OrderDate) = '2016' and ol.Description like '%mug%'
group by c.CustomerID, c.CustomerName, c.PhoneNumber, YEAR(o.OrderDate)
having SUM(ol.Quantity) <10
order by CustomerID
;


-- Q10 alternative 
-- filter by stockGroupName
select c.CustomerID, c.CustomerName, c.PhoneNumber, SUM(ol.Quantity) as sell_qty, YEAR(o.OrderDate) as sell_year from Sales.Customers c join Application.People p on c.PrimaryContactPersonID = p.PersonID join Sales.Orders o on o.CustomerID = c.CustomerID join Sales.OrderLines ol on ol.OrderID = o.OrderID join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = ol.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID
where YEAR (o.OrderDate) = '2016' and sg.StockGroupName = 'Mugs'
group by c.CustomerID, c.CustomerName, c.PhoneNumber, YEAR(o.OrderDate)
having SUM(ol.Quantity) <10
order by CustomerID
;
