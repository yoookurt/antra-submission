/* Q6: List of stock items that are not sold to the state of Alabama and Georgia in 2014. */

USE [WideWorldImporters]
GO

select si.StockItemID, si.StockItemName, o.OrderDate, ct.CityName, sp.StateProvinceName from Warehouse.StockItems si join Sales.OrderLines ol on si.StockItemID = ol.StockItemID join Sales.Orders o on ol.OrderID = o.OrderID join Sales.Customers c on o.CustomerID = c.CustomerID join Application.Cities ct on c.DeliveryCityID = ct.CityID join Application.StateProvinces sp on ct.StateProvinceID = sp.StateProvinceID where not ((sp.StateProvinceCode in ('AL','GA')) and YEAR(o.OrderDate)='2014'); 
