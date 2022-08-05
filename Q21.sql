/*
Create a new table called ods.Orders. Create a stored procedure, with proper error handling and transactions, that input is a date; when executed, it would find orders of that day, calculate order total, and save the information (order id, order date, order total, customer id) into the new table. If a given date is already existing in the new table, throw an error and roll back. Execute the stored procedure 5 times using different dates. 
*/

USE [WideWorldImporters]
GO

create SCHEMA ods;
GO

If object_ID (N'ods.uspOrders', 'P') is not null
	drop procedure ods.uspOrders;

If object_ID (N'ods.Orders', 'U') is not null
	drop table ods.Orders;

create table ods.Orders (
	OrderID int,
	OrderDate date,
	order_total money,
	CutomerID int);

create or alter procedure ods.uspOrders
	@OrderDate date
as
begin
	set NOCOUNT on
	declare @cnt int
	select @cnt = count(1) from ods.Orders o where o.OrderDate = @OrderDate
	
	begin try
		begin transaction
			insert into ods.Orders
			select o.OrderID, o.OrderDate, sum(il.Quantity * il.UnitPrice) as order_total, o.CustomerID from Sales.Orders o join Sales.OrderLines ol on ol.OrderID = o.OrderID join Sales.Invoices i on i.OrderID = o.OrderID join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID and il.StockItemID = ol.StockItemID where o.OrderDate = @OrderDate group by o.OrderID, o.OrderDate, o.CustomerID
	end try
	begin catch
		print '--ERROR--: ' + ERROR_MESSAGE()
		print 'ROLL BACK INSERTION ...'
		rollback transaction
	end catch	
	if @cnt > 0
		rollback transaction
		print 'STOP: The OrderDate already exists in the Orders table.'
		print 'ROLL BACK INSERTION ...'
		;throw 50050, 'ERROR: DUPLICATE INSERTION!', 1
	else
		commit transaction
		print 'INSERTION SUCESS :D'
end
GO

EXEC ods.uspOrders @OrderDate = '2015-05-05'
GO

EXEC ods.uspOrders @OrderDate = '2014-03-25'
GO

EXEC ods.uspOrders @OrderDate = '2013-10-08'
GO

EXEC ods.uspOrders @OrderDate = '2015-05-05'
GO

EXEC ods.uspOrders @OrderDate = '2014-03-25'
GO
