/*
Create a function, input: order id; return: total of that order. List invoices and use that function to attach the order total to the other fields of invoices. 
*/

USE [WideWorldImporters]
GO

create function Sales.ufn_OrderByID(@orderid int)
returns int
AS
BEGIN
	declare @ret int;
	select @ret = sum(ol.Quantity * ol.UnitPrice) from Sales.OrderLines ol where ol.OrderID = @orderid;
	if (@ret is null)
		set @ret = 0;
	return @ret;
END;

create function Sales.ufn_InvoiceOrderTtlByID(@orderid int)
returns table
as
return
(
	select o.OrderID, Sales.ufn_OrderByID(@orderid) as order_total, il.* from sales.Invoices i join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID right join Sales.Orders o on o.OrderID = i.OrderID where o.OrderID = @orderid
);

select * from Sales.ufn_InvoiceOrderTtlByID(694);
select * from Sales.ufn_InvoiceOrderTtlByID(17);
