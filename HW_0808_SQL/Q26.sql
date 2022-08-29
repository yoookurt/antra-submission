/*
Revisit your answer in (19). Convert the result into an XML string and save it to the server using TSQL FOR XML PATH.
*/

USE [WideWorldImporters]
GO

CREATE TABLE dbo.Archive (
	ID int identity(1,1) primary key,
	Content nvarchar(max)
	)
GO

DECLARE @x NVARCHAR(MAX) =
  (SELECT *
     FROM Sales.vStkGrpSldbyName
     FOR XML AUTO)
insert into dbo.Archive
select @x 
