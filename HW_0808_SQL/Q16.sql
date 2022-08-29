/*
List all stock items that are manufactured in China. (Country of Manufacture)
*/

USE [WideWorldImporters]
GO

select si.StockItemID, si.StockItemName, JSON_value(si.CustomFields, '$.CountryOfManufacture') as origin_country from Warehouse.StockItems si where JSON_value(si.CustomFields, '$.CountryOfManufacture') like '%china%';
