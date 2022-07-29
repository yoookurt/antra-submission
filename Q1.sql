/*
Q1: List of Persons’ full name, all their fax and phone numbers, as well as the phone number and fax of the company they are working for (if any). 
*/

USE [WideWorldImporters]
GO

select PersonID, FullName, FaxNumber, PhoneNumber, FaxNumber as cpFaxNumber, PhoneNumber as cpPhoneNumber from Application.People where IsEmployee = 1
union
select PersonID, FullName, FaxNumber, PhoneNumber, FaxNumber as cpFaxNumber, PhoneNumber as cpPhoneNumber from Application.People_Archive where IsEmployee = 1
union
select PersonID, FullName, FaxNumber, PhoneNumber, cpFaxNumber, cpPhoneNumber from 
	(
	select PersonID, FullName, FaxNumber, PhoneNumber from Application.People where IsEmployee = 0
	UNION
	select PersonID, FullName, FaxNumber, PhoneNumber from Application.People_Archive where IsEmployee = 0
	) as ppl
join
	(
	select PrimaryContactPersonID p, SupplierID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Purchasing.Suppliers
	union
	select PrimaryContactPersonID p, SupplierID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Purchasing.Suppliers_Archive
	union
	select AlternateContactPersonID p, SupplierID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Purchasing.Suppliers
	union
	select AlternateContactPersonID p, SupplierID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Purchasing.Suppliers_Archive
	union
	select PrimaryContactPersonID p, CustomerID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Sales.Customers
	union
	select PrimaryContactPersonID p, CustomerID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Sales.Customers_Archive
	union
	select AlternateContactPersonID p, CustomerID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Sales.Customers
	union
	select AlternateContactPersonID p, CustomerID, PhoneNumber as cpPhoneNumber, FaxNumber as cpFaxNumber from Sales.Customers_Archive
	) as tmp
on ppl.PersonID = tmp.p
order by PersonID;
