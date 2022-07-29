/*
Q2: If the customer's primary contact person has the same phone number as the customer’s phone number, list the customer companies. 
*/

USE [WideWorldImporters]
GO

select CustomerName from Application.People p join Sales.Customers c on p.PersonID = c.PrimaryContactPersonID where p.PhoneNumber = c.PhoneNumber;
