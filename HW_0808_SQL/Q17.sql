/*
Total quantity of stock items sold in 2015, group by country of manufacturing.
*/

USE [WideWorldImporters]
GO

select JSON_value(si.CustomFields, '$.CountryOfManufacture') as origin_country, sum(ol.Quantity) as sold_qty
from Warehouse.StockItems si join Sales.OrderLines ol on ol.StockItemID = si.StockItemID join Sales.Orders o on o.OrderID = ol.OrderID
where year(o.OrderDate) = '2015'
group by JSON_value(si.CustomFields, '$.CountryOfManufacture')
;
