/*
Consider the JSON file:
{
   "PurchaseOrders":[
      {
         "StockItemName":"Panzer Video Game",
         "Supplier":"7",
         "UnitPackageId":"1",
         "OuterPackageId":[
            6,
            7
         ],
         "Brand":"EA Sports",
         "LeadTimeDays":"5",
         "QuantityPerOuter":"1",
         "TaxRate":"6",
         "UnitPrice":"59.99",
         "RecommendedRetailPrice":"69.99",
         "TypicalWeightPerUnit":"0.5",
         "CountryOfManufacture":"Canada",
         "Range":"Adult",
         "OrderDate":"2018-01-01",
         "DeliveryMethod":"Post",
         "ExpectedDeliveryDate":"2018-02-02",
         "SupplierReference":"WWI2308"
      },
      {
         "StockItemName":"Panzer Video Game",
         "Supplier":"5",
         "UnitPackageId":"1",
         "OuterPackageId":"7",
         "Brand":"EA Sports",
         "LeadTimeDays":"5",
         "QuantityPerOuter":"1",
         "TaxRate":"6",
         "UnitPrice":"59.99",
         "RecommendedRetailPrice":"69.99",
         "TypicalWeightPerUnit":"0.5",
         "CountryOfManufacture":"Canada",
         "Range":"Adult",
         "OrderDate":"2018-01-025",
         "DeliveryMethod":"Post",
         "ExpectedDeliveryDate":"2018-02-02",
         "SupplierReference":"269622390"
      }
   ]
}

Looks like that it is our missed purchase orders. Migrate these data into Stock Item, Purchase Order and Purchase Order Lines tables. Of course, save the script.

*/

USE [WideWorldImporters]
GO

declare @json nvarchar(max)
set @json = N'{"PurchaseOrders":[{"StockItemName":"Panzer Video Game","Supplier":"7","UnitPackageId":"1","OuterPackageId":[6,7],"Brand":"EA Sports","LeadTimeDays":"5","QuantityPerOuter":"1","TaxRate":"6","UnitPrice":"59.99","RecommendedRetailPrice":"69.99","TypicalWeightPerUnit":"0.5","CountryOfManufacture":"Canada","Range":"Adult","OrderDate":"2018-01-01","DeliveryMethod":"Post","ExpectedDeliveryDate":"2018-02-02","SupplierReference":"WWI2308"},{"StockItemName":"Panzer Video Game","Supplier":"5","UnitPackageId":"1","OuterPackageId":"7","Brand":"EA Sports","LeadTimeDays":"5","QuantityPerOuter":"1","TaxRate":"6","UnitPrice":"59.99","RecommendedRetailPrice":"69.99","TypicalWeightPerUnit":"0.5","CountryOfManufacture":"Canada","Range":"Adult","OrderDate":"2018-01-025","DeliveryMethod":"Post","ExpectedDeliveryDate":"2018-02-02","SupplierReference":"269622390"}]}'


