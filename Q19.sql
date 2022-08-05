/*
Create a view that shows the total quantity of stock items of each stock group sold (in orders) by year 2013-2017. [Year, Stock Group Name1, Stock Group Name2, Stock Group Name3, … , Stock Group Name10] 
*/

USE [WideWorldImporters]
GO

CREATE VIEW Sales.vStkGrpSldbyName
	with SCHEMABINDING
AS
with tmp as (select sg.StockGroupName, ol.Quantity, year(o.OrderDate) as sold_yr
from Warehouse.StockItems si join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = si.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID join Sales.OrderLines ol on ol.StockItemID = si.StockItemID join Sales.Orders o on o.OrderID = ol.OrderID
where year(o.OrderDate) in (2013, 2014, 2015, 2016, 2017))
select sold_yr, [Novelty Items], [Clothing], [Mugs], [T-Shirts], [Airline Novelties], [Computing Novelties], [USB Novelties], [Furry Footwear], [Toys], [Packaging Materials] from tmp -- columns from pvt table, not origin; coalesce is not necessary
pivot
(sum(Quantity) for StockGroupName in ([Novelty Items], [Clothing], [Mugs], [T-Shirts], [Airline Novelties], [Computing Novelties], [USB Novelties], [Furry Footwear], [Toys], [Packaging Materials])) as pvt -- sum cannot followed by as alias; pivot need as alias to entail
;
