SELECT * FROM Customer;
SELECT * FROM Payment;
SELECT * FROM Product;
SELECT * FROM [Order];
SELECT * FROM Order_Product;


 --5.1.2	Write a query (inner) to retrieve data from 3 or more tables
 -- show customers who made orders and details of order
SELECT o.Order_id, c.First_name, p.Product_name, op.Order_quantity
FROM [Order] o
INNER JOIN Customer c ON o.Cust_id = c.Cust_id
INNER JOIN Order_Product op ON o.Order_id = op.Order_id
INNER JOIN Product p ON op.Product_id = p.Product_id;

-- 5.2.2	Write a query (outer join) to retrieve data from 3 or more tables
-- show comprehensive information from the entire database
SELECT 
    c.Cust_id AS Customer_ID,
    c.First_name AS Customer_Name,
    o.Order_id AS Order_ID,
    o.Order_date AS Order_Date,
	o.Order_total AS Order_total,
    pr.Product_id AS Product_ID,
    pr.Product_name AS Product_Name,
    op.Order_quantity AS Order_Quantity,
    pa.Payment_id AS Payment_ID,
    pa.Payment_method AS Payment_Method,
    pa.Amount_paid AS Amount_Paid
FROM Customer c
FULL OUTER JOIN [Order] o ON c.Cust_id = o.Cust_id
FULL OUTER JOIN Order_Product op ON o.Order_id = op.Order_id
FULL OUTER JOIN Product pr ON op.Product_id = pr.Product_id
FULL OUTER JOIN Payment pa ON o.Payment_id = pa.Payment_id
ORDER BY c.Cust_id, o.Order_id, pr.Product_id;

-- 5.3.1	Write a non-correlated subquery
-- Retrieve products that belong to BTS
SELECT Product_id, Group_name, Product_name, Price
FROM Product
WHERE Group_name = 'BTS';

-- 5.4.1	Write a correlated subquery
-- Retrive products that has never been ordered
SELECT p.Product_id, p.Product_name
FROM Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM Order_Product op
    WHERE op.Product_id = p.Product_id
);

-- 5.5.2	Aggregate the data in some way
-- Calculate the total revenue earned by each products
SELECT p.Product_name, SUM(op.Order_quantity * p.Price) AS Total_Revenue
FROM Product p
INNER JOIN Order_Product op ON p.Product_id = op.Product_id
GROUP BY p.Product_name
ORDER BY Total_Revenue DESC;