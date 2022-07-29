/*
Q2: If the customer's primary contact person has the same phone number as the customer’s phone number, list the customer companies. 
*/

USE [WideWorldImporters]
GO

select CustomerName from 
	(select PersonID, PhoneNumber from Application.People
	union
	select PersonID, PhoneNumber from Application.People_Archive	
	) as p
join
	(
	select CustomerName, PrimaryContactPersonID, PhoneNumber from Sales.Customers
	union
	select CustomerName, PrimaryContactPersonID, PhoneNumber from Sales.Customers_Archive
	) as c
on p.PersonID = c.PrimaryContactPersonID where p.PhoneNumber = c.PhoneNumber;
