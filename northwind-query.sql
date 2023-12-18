-- Total Sales by Employee
CREATE VIEW ProductSales AS
SELECT 
    Employees.EmployeeID,
    Products.ProductName,
    SUM(OrderDetails.Quantity * Products.Price) AS TotalSale
FROM OrderDetails
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Employees.EmployeeID, Products.ProductName;

-- Moving AVG Sales by Employee by Month
CREATE VIEW EmployeeSales AS
SELECT 
    YEAR(Orders.OrderDate) AS Year,
    MONTH(Orders.OrderDate) AS Month,
    CONCAT(Employees.LastName, ' ', Employees.FirstName) AS EmployeeName,
    SUM(Products.Price * OrderDetails.Quantity) AS MonthlySales,
    AVG(SUM(Products.Price * OrderDetails.Quantity)) OVER (
        PARTITION BY Employees.EmployeeID 
        ORDER BY YEAR(Orders.OrderDate), MONTH(Orders.OrderDate) 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW        
    ) AS MovingAverageSales
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY 
    YEAR(Orders.OrderDate), 
    MONTH(Orders.OrderDate), 
    Employees.EmployeeID;

-- Row Number of Orders by Customer
SELECT 
    Customers.CustomerID, 
    Orders.OrderID, 
    ROW_NUMBER() OVER (PARTITION BY Customers.CustomerID ORDER BY Orders.OrderID) AS RowNumber
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- Rank of Orders by Customers
SELECT 
    Customers.CustomerID, 
    COUNT(Orders.OrderID) AS TotalOrders, 
    RANK() OVER (ORDER BY COUNT(Orders.OrderID) DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY COUNT(Orders.OrderID) DESC) AS dense_rnk
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID;

-- LEAD, LAG, FIRST_VALUE, LAST_VALUE, NTH_VALUE
SELECT 
    Customers.CustomerID, 
    Orders.OrderID, 
    FIRST_VALUE(Orders.OrderID) OVER (w) AS FirstOrderID,
    LEAD(Orders.OrderID) OVER (w) AS NextOrderID,
    LAG(Orders.OrderID) OVER (w) AS PreviousOrderID,
    LAST_VALUE(Orders.OrderID) OVER (w) AS LastOrderID,
    NTH_VALUE(Orders.OrderID, 2) OVER (w) AS SecondOrderID
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WINDOW w AS (PARTITION BY Customers.CustomerID ORDER BY Orders.OrderID);

-- NTILE - Distribute rows into groups
SELECT 
    Products.ProductName,
    Products.Price,
    NTILE(4) OVER (ORDER BY Products.Price) AS PriceGroup
FROM Products;

-- PERCENT_RANK - calculates the relative rank of each product's price within its category.
-- CUME_DIST - calculates the cumulative distribution of each product's price within its category.
SELECT 
    Categories.CategoryName,
    Products.ProductName,
    Products.Price,
    ROUND(PERCENT_RANK() OVER (
        PARTITION BY Categories.CategoryName 
        ORDER BY Products.Price
    ), 3) AS PricePercentRank,
    ROUND(CUME_DIST() OVER (
        PARTITION BY Categories.CategoryName 
        ORDER BY Products.Price
    ), 3) AS PriceCumulativeDist
FROM Products
JOIN Categories ON Products.CategoryID = Categories.CategoryID;