/*
List of StockItems that the company purchased more than sold in the year of 2015.
*/


USE [WideWorldImporters]
GO

select b.StockItemID, b.StockItemName, b.buy_qty, s.sell_qty, b.buy_qty - s.sell_qty as dff from 
	(select si.StockItemID, si.StockItemName, sum(sit.Quantity) as buy_qty, YEAR(po.OrderDate) as buy_year from Warehouse.StockItems si join Purchasing.PurchaseOrderLines pol on pol.StockItemID =si.StockItemID join Purchasing.PurchaseOrders po on po.PurchaseOrderID = pol.PurchaseOrderID join Warehouse.StockItemTransactions sit on sit.PurchaseOrderID = po.PurchaseOrderID and sit.StockItemID = si.StockItemID
group by si.StockItemID, si.StockItemName, YEAR(po.OrderDate)
having YEAR(po.OrderDate) = '2015') as b
left join 
	(select si.StockItemID, si.StockItemName, sum(ol.Quantity) as sell_qty, YEAR(o.OrderDate) as sell_year from Warehouse.StockItems si join Sales.OrderLines ol on ol.StockItemID = si.StockItemID join Sales.Orders o on o.OrderID = ol.OrderID
group by si.StockItemID, si.StockItemName, YEAR(o.OrderDate)
having YEAR(o.OrderDate) = '2015') as s
on b.StockItemID = s.StockItemID
where (b.buy_qty - s.sell_qty) >0
;
