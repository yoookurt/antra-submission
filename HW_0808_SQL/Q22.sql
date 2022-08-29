/*
Create a new table called ods.StockItem. It has following columns: [StockItemID], [StockItemName] ,[SupplierID] ,[ColorID] ,[UnitPackageID] ,[OuterPackageID] ,[Brand] ,[Size] ,[LeadTimeDays] ,[QuantityPerOuter] ,[IsChillerStock] ,[Barcode] ,[TaxRate]  ,[UnitPrice],[RecommendedRetailPrice] ,[TypicalWeightPerUnit] ,[MarketingComments]  ,[InternalComments], [CountryOfManufacture], [Range], [Shelflife]. 

Migrate all the data in the original stock item table.
*/

USE [WideWorldImporters]
GO

If object_ID (N'ods.StockItem', 'U') is not null
	drop table ods.StockItem;

-- [CountryOfManufacture], [Range], [Shelflife]
select [StockItemID], [StockItemName] ,[SupplierID] ,[ColorID] ,[UnitPackageID] ,[OuterPackageID] ,[Brand] ,[Size] ,[LeadTimeDays] ,[QuantityPerOuter] ,[IsChillerStock] ,[Barcode] ,[TaxRate]  ,[UnitPrice],[RecommendedRetailPrice] ,[TypicalWeightPerUnit] ,[MarketingComments]  ,[InternalComments], JSON_value(si.CustomFields, '$.CountryOfManufacture') as [CountryOfManufacture], JSON_value(si.CustomFields, '$.Range') as [Range], JSON_value(si.CustomFields, '$.ShelfLife') as [Shelflife] into ods.StockItem from Warehouse.StockItems si;
