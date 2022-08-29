/*
List all the cities that were updated after 2015-01-01.
*/

USE [WideWorldImporters]
GO

SELECT c.CityID, c.CityName, c.ValidFrom from Application.Cities c where ValidFrom >= '2015-01-01';
