/*
Create a new table called ods.ConfirmedDeviveryJson with 3 columns (id, date, value) . Create a stored procedure, input is a date. The logic would load invoice information (all columns) as well as invoice line information (all columns) and forge them into a JSON string and then insert into the new table just created. Then write a query to run the stored procedure for each DATE that customer id 1 got something delivered to him.
*/

USE [WideWorldImporters]
GO

If object_ID (N'ods.ConfirmedDeviveryJson', 'U') is not null
	drop table ods.ConfirmedDeviveryJson
GO

create table ods.ConfirmedDeviveryJson (
	[ID] int identity(1,1) primary key,
	[Date] date,
	[Value] nvarchar(max))
GO

If object_ID (N'ods.uspLoadInvoiceJson', 'P') is not null
	drop procedure ods.uspLoadInvoiceJson
GO

create or alter procedure ods.uspLoadInvoiceJson
	@DeliveryDate date
as
begin
	set NOCOUNT on
	-- check existing records before committing transactions
	declare @cnt int
	select @cnt = count(1) from ods.ConfirmedDeviveryJson o where o.Date = @DeliveryDate
	if @cnt > 0
		begin
		print 'STOP: The DeliveryDate already exists in the table.'
		print 'ROLL BACK INSERTION ...'
		;throw 50050, 'ERROR: EXISTING RECORDS!', 1
		end
	else	
		declare @x NVARCHAR(MAX) =
		(select 
		i.InvoiceID,
		CustomerID,
		BillToCustomerID,
		OrderID,
		DeliveryMethodID,
		ContactPersonID,
		AccountsPersonID,
		SalespersonPersonID,
		PackedByPersonID,
		InvoiceDate,
		CustomerPurchaseOrderNumber,
		IsCreditNote,
		CreditNoteReason,
		Comments,
		DeliveryInstructions,
		InternalComments,
		TotalDryItems,
		TotalChillerItems,
		DeliveryRun,
		RunPosition,
		ReturnedDeliveryData,
		ConfirmedDeliveryTime,
		ConfirmedReceivedBy,
		InvoiceLineID,
		StockItemID,
		Description,
		PackageTypeID,
		Quantity,
		UnitPrice,
		TaxRate,
		TaxAmount,
		LineProfit,
		ExtendedPrice 
	    FROM Sales.Invoices i join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID where cast(i.ConfirmedDeliveryTime as date) = @DeliveryDate 
	    FOR JSON PATH, INCLUDE_NULL_VALUES)
		if @x is null
			begin
			print 'STOP: The date has no delivery.'
			;throw 50150, 'ERROR: NO DELIVERY RECORD!', 1
			end
	    else
			begin try
				begin transaction
	    		insert into ods.ConfirmedDeviveryJson ([Date], [Value])
				select @DeliveryDate, @x
				commit transaction
				print 'INSERT SUCESS :D'	
			end try
			begin catch
			print '--ERROR--: ' + ERROR_MESSAGE()
			print 'ROLL BACK INSERTION ...'
			rollback transaction
			end catch
end
GO

declare @Date date
declare date_cursor cursor
for (select distinct cast(ConfirmedDeliveryTime as date) from Sales.Invoices where CustomerID = 1)
open date_cursor
fetch next from date_cursor into @Date
while @@FETCH_STATUS=0
begin
	print @Date
	EXEC ods.uspLoadInvoiceJson @DeliveryDate = @Date
	fetch next from date_cursor into @Date
end
close date_cursor
deallocate date_cursor
GO
