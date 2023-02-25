--SQL Advance Case Study

use db_SQLCaseStudies

--Q1--BEGIN 
	
	select State from DIM_LOCATION as T1 inner join FACT_TRANSACTIONS as T2
	on T1.IDLocation = T2.IDLocation
	where year(date) between 2005 and GETDATE()
	group by State
	   	 
--Q1--END

--Q2--BEGIN
	
	select top 1 State from FACT_TRANSACTIONS as T1 inner join DIM_LOCATION as T2
	on T1.IDLocation = T2.IDLocation
	inner join DIM_MODEL as T3
	on T1.IDModel = T3.IDModel
	inner join DIM_MANUFACTURER as T4
	on T3.IDManufacturer = t4.IDManufacturer
	where country = 'US' and Manufacturer_Name = 'Samsung'
	group by State
	order by count(Quantity) desc


--Q2--END

--Q3--BEGIN      
	

	select count(idcustomer) [no_of_transaction] , IDModel, zipcode, State 
	from FACT_TRANSACTIONS as T1 inner join DIM_LOCATION as T2
	on T1.IDLocation = T2.IDLocation
	group by IDModel, ZipCode, State


--Q3--END

--Q4--BEGIN


select top 1 Manufacturer_Name, model_name, unit_price from DIM_MODEL as T1 inner join DIM_MANUFACTURER as T2
on T1.IDManufacturer = T2.IDManufacturer
order by Unit_price asc


--Q4--END

--Q5--BEGIN

select top 5 Manufacturer_Name, avg(T3.TotalPrice) [avg_price] , T2.Model_Name, count(T3.Quantity) [sales_Qty] 
from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer = T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
group by T1.Manufacturer_Name, T2.Model_Name
order by avg_price


--Q5--END

--Q6--BEGIN


Select T1.Customer_Name, Avg(TotalPrice) 
from DIM_CUSTOMER as T1 
inner join FACT_TRANSACTIONS as T2
on T1.IDCustomer = T2.IDCustomer
where year(date) = 2009
group by T1.Customer_Name
having Avg(TotalPrice) > 500


--Q6--END
	
--Q7--BEGIN  
	

select * from (
select top 5 FACT_TRANSACTIONS.IDModel, Model_Name
from FACT_TRANSACTIONS LEFT JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
where YEAR(Date) = '2008'
GROUP BY FACT_TRANSACTIONS.IDModel, Model_Name
ORDER BY SUM(Quantity) DESC) AS [T1] 
INTERSECT
select * from (
select top 5 FACT_TRANSACTIONS.IDModel, Model_Name
from FACT_TRANSACTIONS LEFT JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
where YEAR(Date) = '2009'
GROUP BY FACT_TRANSACTIONS.IDModel, Model_Name
ORDER BY SUM(Quantity) DESC) AS [T2] 
INTERSECT
select * from (
select top 5 FACT_TRANSACTIONS.IDModel, Model_Name
from FACT_TRANSACTIONS LEFT JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
where YEAR(Date) = '2010'
group by FACT_TRANSACTIONS.IDModel, Model_Name
order by SUM(Quantity) DESC) AS [T3]


--Q7--END	
--Q8--BEGIN


select * from
(select manufacturer_name, sum(TotalPrice) as sales 
from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer = T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
where year(date) = 2009
group by Manufacturer_Name
order by sales desc
offset 1 rows
fetch next 1 rows only) as t1

union

select * from
(select manufacturer_name, sum(TotalPrice) as sales 
from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer = T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
where year(date) = 2010
group by Manufacturer_Name
order by sales desc
offset 1 rows
fetch next 1 rows only) as t2


--Q8--END
--Q9--BEGIN


select Manufacturer_Name from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer = T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
where year(date) = 2010
except
select Manufacturer_Name from DIM_MANUFACTURER as T1 inner join DIM_MODEL as T2
on T1.IDManufacturer = T2.IDManufacturer inner join FACT_TRANSACTIONS as T3
on T2.IDModel = T3.IDModel
where year(date) = 2009


--Q9--END

--Q10--BEGIN
	

SELECT TOP 100
Customer_Name, Year, AverageSpend, AverageQuantity, Difference/PreviousSpend * 100 AS [% of Change in Spend]
FROM(
SELECT 
     Customer_Name, YEAR(Date) AS [Year], AVG(TotalPrice) AS [AverageSpend], AVG(Quantity) AS [AverageQuantity],
	 AVG(TotalPrice) - LAG(AVG(TotalPrice)) OVER (PARTITION BY Customer_Name ORDER BY YEAR(Date)) AS [Difference],
	 LAG(AVG(TotalPrice)) OVER (PARTITION BY Customer_Name ORDER BY YEAR(Date)) AS [PreviousSpend]
     FROM DIM_CUSTOMER INNER JOIN 
	 FACT_TRANSACTIONS ON DIM_CUSTOMER.IDCustomer = FACT_TRANSACTIONS.IDCustomer
	 GROUP BY Customer_Name, YEAR(Date)) AS [T1]
	ORDER BY AverageSpend DESC, AverageQuantity DESC;




--Q10--END
	

