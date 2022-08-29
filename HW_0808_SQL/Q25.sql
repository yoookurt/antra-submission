/*
Revisit your answer in (19). Convert the result in JSON string and save it to the server using TSQL FOR JSON PATH.
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
     FOR JSON PATH, INCLUDE_NULL_VALUES)
insert into dbo.Archive
select @x 
GO
