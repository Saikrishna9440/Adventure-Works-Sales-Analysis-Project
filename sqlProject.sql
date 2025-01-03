create database Adventureworks;
select * from dimproduct;
select * from dimcustomer;
-- Q(0) union
create table sales(select * from factinternetsales
union
select * from fact_internet_sales_new);
select * from sales;
select firstname,middlename,lastname from dimcustomer;
-- Q(1) Lookup ProductNames
select s.*,p.EnglishProductName,p.SpanishProductName,p.FrenchProductName
from sales s join dimproduct p on s.ProductKey = p.ProductKey;
-- Q(2) Lookup CustomerFullname and unitprice
select s.*,concat(c.firstname,' ',c.middlename,' ',c.lastname) as FullName,P.unitprice
from
sales s join dimcustomer c on s.CustomerKey = c.CustomerKey
join dimproduct p on s.ProductKey = p.ProductKey;
-- Q(3) Dates
ALTER TABLE sales ADD COLUMN Order_Date DATE;
set sql_safe_updates=0;
UPDATE sales SET Order_Date = STR_TO_DATE(OrderDateKey, '%Y%m%d');
select * from sales;
select *,year(order_date) as year,month(order_date) as monthno,monthname(order_date) as monthName,quarter(order_date) as Quarter ,
dayofweek(Order_Date) AS Weekdayno,DAYNAME(Order_Date) AS WeekdayName,
MONTH(Order_Date) AS CalendarMonth, CASE WHEN MONTH(Order_Date) >= 4 THEN MONTH(Order_Date) - 3 ELSE MONTH(Order_Date) + 9 END AS FinancialMonth 
,MONTH(Order_Date) AS CalendarMonth, CASE WHEN MONTH(Order_Date) IN (4, 5, 6) THEN 'Q1' WHEN MONTH(Order_Date) IN (7, 8, 9) THEN 'Q2' WHEN MONTH(Order_Date) IN (10, 11, 12) THEN 'Q3' ELSE 'Q4'
 END AS FinancialQuarter from sales;
 describe sales;
 
 -- Q(4) SalesAmount
 select *,unitPrice*OrderQuantity*(1-unitpricediscountpct) as sales_amount from sales;
-- Q(5) ProductioCost
select *,productstandardCost*orderQuantity as Productioncost from sales;
-- Q(6)
alter table sales Add column Profit Double;
update sales set profit = SalesAmount-TotalProductCost;
select* from sales;
-- Q(7) MonthWiseSales with year filter
select month(order_date) months,sum(SalesAmount) as Totalsales from sales where year(order_date)=2012 group by month(Order_Date);
-- Q(8) YearWiseSales
select year(order_date) as years,sum(SalesAmount) as Totalsales from sales group by year(Order_Date);
-- Q(9) MonthWiseSales
select month(order_date) months,sum(SalesAmount) as Totalsales from sales group by month(Order_Date);
-- Q(10) QuarterWiseSales
select Quarter(order_date) Quarters,sum(SalesAmount) as Totalsales from sales where year(order_date)=2012 group by Quarter(Order_Date);
-- Q(11) Yearwise salesAmount & TotalProductCost
select year(order_date) as years,sum(salesAmount) as TotalSales,sum(TotalProductCost) as TotalProductCost from sales group by year(order_date);
-- Q(12) KPI(products,customers,Region)
alter table sales add column Region varchar(30);
UPDATE Sales s JOIN dimsalesterritory t ON s.salesTerritoryKey = t.SalesTerritorykey SET s.Region = t.SalesTerritoryRegion;
select * from sales;
-- TotalNoOfProducts
Select ProductKey,count(productKey) as TotalNoOfProducts from sales group by productkey;
-- customer wise total orders
select customerkey,count(customerkey) TotalNoOfOrders from sales group by CustomerKey;
-- RegionWiseSales
select region,sum(salesAmount) from sales group by region;


