/*
List of stock item groups and total quantity purchased, total quantity sold, and the remaining stock quantity (quantity purchased – quantity sold)
*/

USE [WideWorldImporters]
GO

-- [buy - sell] by [po - deliveries]  (problematic ???)
select b.StockGroupName, b.purchased_qty, s.sold_qty, b.purchased_qty - s.sold_qty as stock from
	(select sum(sit.Quantity) as , sg.StockGroupName from Warehouse.StockItemTransactions sit join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = sit.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID where sit.TransactionTypeID ='11' group by sg.StockGroupName) as b
join
	(select sg.StockGroupName, sum(-sit_out.Quantity) as sold_qty from Warehouse.StockItems si join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = si.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID join Warehouse.StockItemTransactions sit_out on si.StockItemID = sit_out.StockItemID
	where sit_out.TransactionTypeID = '10'
	group by sg.StockGroupName) as s
on b.StockGroupName = s.StockGroupName
order by b.StockGroupName;

-- Alternative: stock on hand by transactions
select sg.StockGroupName, sum(sih.QuantityOnHand) as stock from Warehouse.StockItems si join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = si.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID join Warehouse.StockItemHoldings sih on sih.StockItemID = si.StockItemID
group by sg.StockGroupName;

-------------- transactions / POs breakdown ---------------

-- Q13 buy by transactions
select sum(sit.Quantity) as , sg.StockGroupName from Warehouse.StockItemTransactions sit join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = sit.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID where sit.TransactionTypeID ='11' group by sg.StockGroupName order by sg.StockGroupName;

-- Q13 buy by orders
select sg.StockGroupName, sum(pol.OrderedOuters * si.QuantityPerOuter) as buy_qty, sum(pol.ReceivedOuters * si.QuantityPerOuter) as rcv_qty
from Purchasing.PurchaseOrderLines pol join Purchasing.PurchaseOrders po on po.PurchaseOrderID = pol.PurchaseOrderID join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = pol.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID join Warehouse.StockItems si on si.StockItemID = pol.StockItemID
group by sg.StockGroupName
order by sg.StockGroupName
;

-- Q13 sell by transactions
select sg.StockGroupName, sum(-sit_out.Quantity) as sold_qty from Warehouse.StockItems si join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = si.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID join Warehouse.StockItemTransactions sit_out on si.StockItemID = sit_out.StockItemID
	where sit_out.TransactionTypeID = '10'
	group by sg.StockGroupName order by sg.StockGroupName;

-- Q13 sell by orders
select sg.StockGroupName, sum(ol.Quantity) as sell_qty from Sales.OrderLines ol join Sales.Orders o on o.OrderID = ol.OrderID join Warehouse.StockItemStockGroups sisg on sisg.StockItemID = ol.StockItemID join Warehouse.StockGroups sg on sg.StockGroupID = sisg.StockGroupID
group by sg.StockGroupName 
order by sg.StockGroupName;

