-- Question 1
-- Sql query to transform a table(ProductDetail) with a culumn(Products) that contains multiple values
-- into 1NF(First Normal Form) ensuring that each row represents a single
-- product for an order.

-- Create a table 
CREATE TABLE NormalizedProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Insert data into the NormalizedProductDetail table
INSERT INTO NormalizedProductDetail (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) numbers
WHERE CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
ORDER BY OrderID, Product;

-- Question 2
-- Sql query to transform a table(OrderDetails) in 1NF(First Normal Form) with a 
-- a column(CustomerName) partially depending on another column(OrderID) into 
-- 2NF(Second Normal Form) by removing the partial dependency and ensuring that
-- each non-key column fully depends on the entire primary key.

-- Create a table for Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(120)
);

-- Create a table for OrderedProducts
CREATE TABLE OrderedProducts (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert unique orders into the Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert ordered products into the OrderedProducts table
INSERT INTO OrderedProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

