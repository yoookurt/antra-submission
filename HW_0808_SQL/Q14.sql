/*
List of Cities in the US and the stock item that the city got the most deliveries in 2016. If the city did not purchase any stock items in 2016, print “No Sales”.
*/

USE [WideWorldImporters]
GO

with dvy as
	(SELECT c.DeliveryCityID, il.StockItemID, sum(il.Quantity) as dvy_qty from Sales.Orders o join sales.OrderLines ol on ol.OrderID = o.OrderID join Sales.Customers c on o.CustomerID = c.CustomerID join Sales.Invoices i on i.OrderID = o.OrderID join Sales.InvoiceLines il on il.InvoiceID = i.InvoiceID and il.StockItemID  = ol.StockItemID join  Application.Cities c2 on c.DeliveryCityID = c2.CityID join Application.StateProvinces sp on sp.StateProvinceID = c2.StateProvinceID join Application.Countries c3 on c3.CountryID = sp.CountryID
	where c3.CountryID = 230 and year(i.ConfirmedDeliveryTime) = '2016'
	group by c.DeliveryCityID, il.StockItemID),
	cty as
	(select ct.CityID, ct.CityName, c2.CountryID, c2.CountryName from Application.Cities ct join Application.StateProvinces sp on sp.StateProvinceID = ct.StateProvinceID join Application.Countries c2 on c2.CountryID = sp.CountryID)
select cty.CityID, cty.CityName, dvy.StockItemID, dvy.dvy_qty, rank() over (PARTITION by cty.CityID, cty.CityName order by dvy.dvy_qty desc) as rk 
into #tt
from cty left join dvy on dvy.DeliveryCityID = cty.CityID
GO

select CityID, CityName, iif(StockItemID is null, 'No Sales', cast(StockItemID as varchar)) as StockItemID, iif(dvy_qty is null, 'No Sales', cast(dvy_qty as varchar)) as dvy_qty from #tt where rk=1;
GO
