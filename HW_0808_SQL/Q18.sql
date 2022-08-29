/*
Create a view that shows the total quantity of stock items of each stock group sold (in orders) by year 2013-2017. [Stock Group Name, 2013, 2014, 2015, 2016, 2017]
*/

USE [WideWorldImporters]
GO

-- StockItemID ~ StockGroupID: 1 -> N
CREATE VIEW Sales.vStkGrpSldbyYr
	with SCHEMABINDING
AS
with tmp as (select sg.StockGroupName, ol.Quantity, year(o.OrderDate) as sold_yr
from Warehouse.StockItems si join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = si.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID join Sales.OrderLines ol on ol.StockItemID = si.StockItemID join Sales.Orders o on o.OrderID = ol.OrderID
where year(o.OrderDate) in (2013, 2014, 2015, 2016, 2017))
select pvt.StockGroupName, pvt.[2013], pvt.[2014], pvt.[2015], pvt.[2016], pvt.[2017] from tmp -- columns from pvt table, not origin; coalesce([2013],0) as [2013] or isnull([2013],0) as [2013] to assign 0 for NULL
pivot (sum(Quantity) for sold_yr in ([2013], [2014], [2015], [2016], [2017])) as pvt -- sum cannot followed by as alias; pivot need as alias to entail
;
