-- Total orders
;SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM dbo.fact_orders


-- Total orders by year
;SELECT 
	YEAR(Order_Date) AS year_id,
	COUNT(DISTINCT Order_ID) AS Total_Orders_By_Year
FROM dbo.fact_orders
GROUP BY YEAR(Order_Date)
ORDER BY year_id


-- Total quantity
;SELECT SUM(Quantity) AS Total_Quantity
FROM dbo.fact_orders


-- Total quantity by year
;SELECT 
	YEAR(Order_Date) AS year_id,
	SUM(Quantity) AS Total_Quantity_By_Year
FROM dbo.fact_orders
GROUP BY YEAR(Order_Date)
ORDER BY year_id


-- Total sales
;SELECT SUM(Sales) AS Total_Sale
FROM dbo.fact_orders


-- Total sales by year
;SELECT 
	YEAR(Order_Date) AS year_id,
	SUM(Sales) AS Total_Sales_By_Year
FROM dbo.fact_orders
GROUP BY YEAR(Order_Date)
ORDER BY year_id


-- Total shipping cost
;SELECT SUM(Shipping_Cost) AS Total_Shipping_Cost
FROM dbo.fact_orders


-- Total shipping cost by year
;SELECT 
	YEAR(Order_Date) AS year_id,
	SUM(Shipping_Cost) AS Total_Shipping_Cost_By_Year
FROM dbo.fact_orders
GROUP BY YEAR(Order_Date)
ORDER BY year_id


-- Total Profit
;SELECT SUM(Profit) AS Total_Profit
FROM dbo.fact_orders


-- Total profit cost by year
;SELECT 
	YEAR(Order_Date) AS year_id,
	SUM(Profit) AS Total_Profit_By_Year
FROM dbo.fact_orders
GROUP BY YEAR(Order_Date)
ORDER BY year_id


-- Top 10 total sales by country
;SELECT TOP 10
	Country,
	SUM(Sales) AS Total_Sales_By_Country
FROM dbo.fact_orders
GROUP BY Country
ORDER BY Total_Sales_By_Country DESC, Country


-- Total sales distribution by segment through time
;WITH sales_segment AS (
	SELECT
		YEAR(Order_Date) AS year_id,
		Segment,
		SUM(Sales) AS Total_sales
	FROM dbo.fact_orders
	GROUP BY YEAR(Order_Date),Segment
)
SELECT 
	year_id,
	Segment,
	CAST(Total_sales *100.0 / SUM(Total_sales) OVER(
		PARTITION BY year_id)
		AS decimal(6,2)
		) AS Segment_percentage
FROM sales_segment
ORDER BY year_id,Segment


--Top 10 customer by total sales
;SELECT TOP 10
	Customer_Name,
	SUM(Sales) AS Total_sales
FROM dbo.fact_orders
GROUP BY Customer_Name
ORDER BY Total_sales DESC


-- Profit margin through time (by quarter)
SELECT
	YEAR(Order_Date) AS year_id,
	DATEPART(QUARTER,Order_date) AS quarter_id,
	CAST( 
		SUM(Profit)* 100 / SUM(Sales) AS decimal(6,2) 
	) AS Profit_margin
FROM dbo.fact_orders
GROUP BY YEAR(Order_Date), DATEPART(QUARTER,Order_date)
ORDER BY YEAR(Order_Date), DATEPART(QUARTER,Order_date)


-- Shipping cost on Total Sales
;SELECT 
	CAST(
		SUM(Shipping_Cost) * 100.0 / SUM(Sales) AS decimal(6,3)
		) AS Shipping_cost_On_Total_Sales
FROM dbo.fact_orders


-- Total Return Sales
;SELECT 
	SUM(fo.Sales) AS Total_Return_Sales
FROM dbo.fact_returns AS fr
join dbo.fact_orders AS fo
ON fr.Order_ID = fo.Order_ID


-- Total Return Orders
;SELECT 
	COUNT(DISTINCT fr.Order_ID) AS Total_return_orders
FROM dbo.fact_returns AS fr
join dbo.fact_orders AS fo
ON fr.Order_ID = fo.Order_ID


-- Sales return rate
SELECT 
	CAST(
		SUM(Sales) * 100.0 / (
			SELECT
				SUM(Sales)
			FROM dbo.fact_orders)
			AS decimal(6,3) ) AS Sales_return_rate
FROM dbo.fact_returns AS fr
	join dbo.fact_orders AS fo
	ON fr.Order_ID = fo.Order_ID


-- Orders return rate
SELECT 
	CAST(
		COUNT(DISTINCT fr.Order_ID) * 100.0 / (
			SELECT
				COUNT(DISTINCT Order_ID)
			FROM dbo.fact_orders)
			AS decimal(6,3) ) AS Orders_return_rate
FROM dbo.fact_returns AS fr
	join dbo.fact_orders AS fo
	ON fr.Order_ID = fo.Order_ID
