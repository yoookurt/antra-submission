/* Q4: List of Stock Items and total quantity for each stock item in Purchase Orders in Year 2013. */

USE [WideWorldImporters]
GO

select si.StockItemID, si.StockItemName, po.OrderDate from Purchasing.PurchaseOrderLines pol join Purchasing.PurchaseOrders po on pol.PurchaseOrderID = po.PurchaseOrderID join
	(select StockItemID, StockItemName from Warehouse.StockItems
	union
	select StockItemID, StockItemName from Warehouse.StockItems_Archive	
	) as si
on si.StockItemID = pol.StockItemID
where YEAR(po.OrderDate)='2013' order by si.StockItemID;
