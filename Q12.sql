/*
List all the Order Detail (Stock Item name, delivery address, delivery state, city, country, customer name, customer contact person name, customer phone, quantity) for the date of 2014-07-01. Info should be relevant to that date.
*/

USE [WideWorldImporters]
GO

-- Q12
-- Warehouse.StockItems -> #StockItems 
-- Sales.Customers -> #Customers
-- Application.Cities -> #Cities
-- Application.StateProvinces -> #StateProvinces
-- Application.Countries -> #Countries
-- Application.People -> #People

select * into #StockItems from Warehouse.StockItems where '2014-07-01' between sp.ValidFrom and sp.ValidTo
GO 

insert into #StockItems
select * from Warehouse.StockItems_Archive where '2014-07-01' between ValidFrom and ValidTo
GO 

select * into #Customers from Sales.Customers where '2014-07-01' between sp.ValidFrom and sp.ValidTo
GO 
insert into #Customers
select * from Sales.Customers_Archive where '2014-07-01' between ValidFrom and ValidTo
GO 

select * into #Cities from Application.Cities where '2014-07-01' between sp.ValidFrom and sp.ValidTo
GO 
insert into #Cities
select * from Application.Cities_Archive where '2014-07-01' between ValidFrom and ValidTo
GO 

select * into #StateProvinces from Application.StateProvinces where '2014-07-01' between sp.ValidFrom and sp.ValidTo
GO 
insert into #StateProvinces
select * from Application.StateProvinces_Archive where '2014-07-01' between ValidFrom and ValidTo
GO 

select * into #Countries from Application.Countries where '2014-07-01' between sp.ValidFrom and sp.ValidTo
GO 
insert into #Countries
select * from Application.Countries_Archive where '2014-07-01' between ValidFrom and ValidTo
GO

select * into #People from Application.People where '2014-07-01' between sp.ValidFrom and sp.ValidTo
GO 
insert into #People
select * from Application.People_Archive where '2014-07-01' between ValidFrom and ValidTo
GO

select si.StockItemName, c.DeliveryAddressLine1 + ', ' + c.DeliveryAddressLine2 + ', ' + ct.CityName + ', ' + sp.StateProvinceCode + ' ' + c.DeliveryPostalCode as Address, sp.StateProvinceName, ct.CityName, ct2.CountryName, c.CustomerName, p.FullName as PrimaryContactPerson, p2.FullName as AlternateContactPerson, c.PhoneNumber, ol.Quantity, o.OrderDate
from Sales.OrderLines ol join #StockItems si on si.StockItemID = ol.StockItemID join Sales.Orders o on ol.OrderID = o.OrderID join #Customers c on c.CustomerID = o.CustomerID join #Cities ct on c.DeliveryCityID = ct.CityID join #StateProvinces sp on sp.StateProvinceID = ct.StateProvinceID join #Countries ct2 on ct2.CountryID = sp.CountryID join #People p on p.PersonID = c.PrimaryContactPersonID join #People p2 on p2.PersonID = c.AlternateContactPersonID
where o.OrderDate = '2014-07-01'
GO
