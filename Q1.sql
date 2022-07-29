USE [WideWorldImporters]
GO

select PersonID, FullName, FaxNumber, PhoneNumber, FaxNumber as cpFaxNumber, PhoneNumber as cpPhoneNumber from Application.People where IsEmployee = 1
union
select PersonID, FullName, FaxNumber, PhoneNumber, cpFaxNumber, cpPhoneNumber from Application.People ppl join
(
select PrimaryContactPersonID p, SupplierID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Purchasing.Suppliers
union
select AlternateContactPersonID p, SupplierID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Purchasing.Suppliers
union
select PrimaryContactPersonID p, CustomerID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Sales.Customers
union
select AlternateContactPersonID p, CustomerID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Sales.Customers
) as tmp
on ppl.PersonID = tmp.p where IsEmployee = 0
order by PersonID;
