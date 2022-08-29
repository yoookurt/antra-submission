/*
List of States and Avg dates for processing (confirmed delivery date – order date) by month.
*/

USE [WideWorldImporters]
GO

-- assuming by order month
-- pivot table with order months as the header
with tmp as 
(select sp.StateProvinceName, sp.StateProvinceCode, MONTH(o.OrderDate) as OrderMonth, DATEDIFF(day, o.OrderDate, i.ConfirmedDeliveryTime) as LeadTime from Sales.Orders o join Sales.Customers c on o.CustomerID = c.CustomerID join Application.Cities ct on c.DeliveryCityID = ct.CityID join Application.StateProvinces sp on ct.StateProvinceID = sp.StateProvinceID join Sales.Invoices i on o.OrderID = i.OrderID where i.ConfirmedDeliveryTime is not null
)
select StateProvinceCode, StateProvinceName, coalesce([1] ,0) as  [Jan], coalesce([2] ,0) as  [Feb], coalesce([3] ,0) as  [Mar] , coalesce([4] ,0) as  [Apr], coalesce([5] ,0) as  [May], coalesce([6] ,0) as  [Jun], coalesce([7] ,0) as  [Jul], coalesce([8] ,0) as  [Aug], coalesce([9] ,0) as  [Sep], coalesce([10],0) as  [Oct], coalesce([11] ,0) as [Nov], coalesce([12],0) as  [Dec]
from tmp
pivot
	(AVG(LeadTime) for OrderMonth in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as pvt
order by StateProvinceCode;
