/*
List any orders that had more than one delivery attempt (located in invoice table).
*/

USE [WideWorldImporters]
GO

select i.InvoiceID, i.OrderID, JSON_value(ReturnedDeliveryData, '$.Events[1].Status') as atmpt_1_Status from Sales.Invoices i
where
JSON_value(ReturnedDeliveryData, '$.Events[1].Status') is null
or JSON_value(ReturnedDeliveryData, '$.Events[1].Status') <> 'Delivered'
and i.ConfirmedDeliveryTime is not null
;
