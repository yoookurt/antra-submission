/*
List of States and Avg dates for processing (confirmed delivery date – order date).
*/

USE [WideWorldImporters]
GO

select sp.StateProvinceName, AVG(DATEDIFF(day, o.OrderDate, i.ConfirmedDeliveryTime)) as AvgLeadDays from Sales.Orders o join Sales.Customers c on o.CustomerID = c.CustomerID join Application.Cities ct on c.DeliveryCityID = ct.CityID join Application.StateProvinces sp on ct.StateProvinceID = sp.StateProvinceID join Sales.Invoices i on o.OrderID = i.OrderID where i.ConfirmedDeliveryTime is not null group by sp.StateProvinceName;
