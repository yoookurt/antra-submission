/*
Rewrite your stored procedure in (21). Now with a given date, it should wipe out all the order data prior to the input date and load the order data that was placed in the next 7 days following the input date.
*/

USE [WideWorldImporters]
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
	select @cnt = count(1) from ods.Orders o where o.OrderDate between DATEADD(day, 1, @OrderDate) and DATEADD(day, 7, @OrderDate)
	
	begin try
		begin transaction
			delete from ods.Orders where OrderDate < @OrderDate
			commit transaction
			print 'DELETE SUCESS :D'
	end try
	begin catch
		print '--ERROR--: ' + ERROR_MESSAGE()
		print 'ROLL BACK DELETE ...'
		rollback transaction
	end catch
	
	begin try
		begin transaction
			insert into ods.Orders
			select o.OrderID, o.OrderDate, sum(il.Quantity * il.UnitPrice) as order_total, o.CustomerID from Sales.Orders o join Sales.OrderLines ol on ol.OrderID = o.OrderID join Sales.Invoices i on i.OrderID = o.OrderID join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID and il.StockItemID = ol.StockItemID where o.OrderDate between DATEADD(day, 1, @OrderDate) and DATEADD(day, 7, @OrderDate) group by o.OrderID, o.OrderDate, o.CustomerID
	end try
	begin catch
		print '--ERROR--: ' + ERROR_MESSAGE()
		print 'ROLL BACK INSERTION ...'
		rollback transaction
	end catch
	-- check existing records before committing transactions
	if @cnt > 0
		rollback transaction
		print 'STOP: The OrderDate already exists in the Orders table.'
		print 'ROLL BACK INSERTION ...'
		;throw 50050, 'ERROR: EXISTING RECORDS!', 1
	else
		commit transaction
		print 'INSERTION SUCESS :D'
end
GO

EXEC ods.uspOrders @OrderDate = '2014-05-05'
GO
