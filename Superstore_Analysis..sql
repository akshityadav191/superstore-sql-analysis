-- -- Superstore Sales Analysis
-- 4 business questions answered using SQL
-- Data: Orders, Customers, Products tables (9,994 orders, 2014-2017)
-- ============================================
-- Q1: Top 10 customers by total lifetime sales value
-- ============================================
SELECT c.Customer_Name, SUM(o.Sales) AS Lifetime_Sales
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Lifetime_Sales DESC
LIMIT 10;
-- Finding: Sean Miller is the top lifetime customer at $25,043.07 in total sales, roughly $6,000 ahead of the #2 customer (Tamara Chand at $19,052.22)
-- ============================================
-- Q2: Which Sub-Categories had declining year-over-year profit?
-- ============================================
WITH YearlyProfit AS (
  SELECT Sub_Category, strftime('%Y', Order_Date) AS Order_Year, SUM(Profit) AS Total_Profit
  FROM Orders
  GROUP BY Sub_Category, Order_Year
),
WithPriorYear AS (
  SELECT *, LAG(Total_Profit) OVER (PARTITION BY Sub_Category ORDER BY Order_Year) AS Prev_Year_Profit
  FROM YearlyProfit
)
SELECT * FROM WithPriorYear
WHERE Prev_Year_Profit IS NOT NULL AND Total_Profit < Prev_Year_Profit
ORDER BY Sub_Category, Order_Year;
-- Finding: 20 Sub-Category-year combinations declined year over year; the sharpest was Tables in 2017, whose loss deepened from -$2,950.99 to -$8,140.71 — Machines also flipped from a $2,907.31 profit in 2016 to a -$2,869.21 loss in 2017

-- ============================================
-- Q3: Average days from order to ship, by shipping mode
-- ============================================
SELECT Ship_Mode, AVG(julianday(Ship_Date) - julianday(Order_Date)) AS Avg_Days_To_Ship
FROM Orders
GROUP BY Ship_Mode
ORDER BY Avg_Days_To_Ship;
-- Finding: Same Day shipping averages 0.04 days, First Class 2.18 days, Second Class 3.24 days, and Standard Class 5.01 days — shipping speed scales almost exactly with the service tier name
-- ============================================
-- Q4: Most profitable city in each Region
-- ============================================
WITH CityProfit AS (
  SELECT Region, City, SUM(Profit) AS Total_Profit
  FROM Orders
  GROUP BY Region, City
),
Ranked AS (
  SELECT *, RANK() OVER (PARTITION BY Region ORDER BY Total_Profit DESC) AS Profit_Rank
  FROM CityProfit
)
SELECT Region, City, Total_Profit FROM Ranked WHERE Profit_Rank = 1;
-- Finding: New York City drives East region profit at $62,037.08 — more than double the next-highest city (Los Angeles, West region, at $30,440.94), and nearly 5x Central's top city (Detroit, $13,181.79)