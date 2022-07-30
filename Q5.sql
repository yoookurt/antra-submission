/* Q5: List of stock items that have at least 10 characters in description. */

USE [WideWorldImporters]
GO

-- StockItemName is the same as Purchasing.PurchaseOrderLines.Description
-- StockItemName is the same as Sales.OrderLines.Description
-- StockItemName is not longer than the SearchDetails column
select StockItemID, StockItemName as Description from Warehouse.StockItems where len(StockItemName) >= 10
union
select StockItemID, StockItemName as Description from Warehouse.StockItems_Archive where len(StockItemName) >= 10;
