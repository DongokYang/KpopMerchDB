USE master;

--6.1.3	Create and demonstrate more than 2 Roles/Users interacting with database objects
CREATE LOGIN Dongok_Yang WITH PASSWORD = 'dyang2', CHECK_POLICY = OFF;
CREATE LOGIN Emma_Watson WITH PASSWORD = 'dyang2', CHECK_POLICY = OFF;
CREATE LOGIN James_Potter WITH PASSWORD = 'dyang2', CHECK_POLICY = OFF;

USE KpopMerchDB;

CREATE USER Dongok FOR LOGIN Dongok_Yang WITH DEFAULT_SCHEMA = [dbo];
CREATE USER Emma FOR LOGIN Emma_Watson WITH DEFAULT_SCHEMA = [dbo];
CREATE USER James FOR LOGIN James_Potter WITH DEFAULT_SCHEMA = [dbo];

CREATE ROLE Business_Owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customer TO Business_Owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order] TO Business_Owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Order_Product TO Business_Owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Product TO Business_Owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Payment TO Business_Owner;

EXEC sp_addrolemember 'Business_Owner', 'Dongok';

CREATE ROLE Database_Manager;
GRANT SELECT, INSERT, UPDATE ON dbo.Customer TO Database_Manager;
GRANT SELECT, INSERT, UPDATE ON dbo.[Order] TO Database_Manager;
GRANT SELECT, INSERT, UPDATE ON dbo.Order_Product TO Database_Manager;
GRANT SELECT, INSERT, UPDATE ON dbo.Product TO Database_Manager;
GRANT SELECT, INSERT, UPDATE ON dbo.Payment TO Database_Manager;

EXEC sp_addrolemember 'Database_Manager', 'Emma';

CREATE ROLE Sales_Manager;
GRANT SELECT ON dbo.Customer TO Sales_Manager;
GRANT SELECT ON dbo.[Order] TO Sales_Manager;
GRANT SELECT ON dbo.Order_Product TO Sales_Manager;
GRANT SELECT ON dbo.Product TO Sales_Manager;
GRANT SELECT ON dbo.Payment TO Sales_Manager;

EXEC sp_addrolemember 'Sales_Manager', 'James';


EXECUTE AS USER = 'Dongok';
-- Testing Customer for 'Dongok'
SELECT * FROM dbo.Customer;

INSERT INTO Customer (Cust_id, First_name, Last_name,Phone, Address, City, State)
VALUES (501, 'Dongok', 'Yang', '2048699533', '1159 Valour St', 'Winnipeg', 'MB');

UPDATE Customer
SET First_name ='Dong'
WHERE Cust_id = 501;

DELETE FROM Customer
WHERE Cust_id = 501;

-- Testing Order for 'Dongok'
SELECT USER;

SELECT * FROM [Order];

INSERT INTO [Order](Order_id, Cust_id, Payment_id,Order_date,Order_total)
VALUES (13, 501, 11, Null, Null);

UPDATE [Order]
SET Order_total = 1
WHERE Cust_id = 501;

DELETE FROM [Order]
WHERE Cust_id = 501;

-- Testing Product for 'Dongok'

SELECT * FROM Product;
INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1001, 'Stray Kids Lightstick', 'Stray Kids', 30, 50.00);

UPDATE Product
SET Price = 45.00, Remaining_quantity = 25
WHERE Product_id = 1001;

DELETE FROM Product
WHERE Product_id = 1001;

-- Testing Payment for 'Dongok'

SELECT * FROM Payment;

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (11, 'Unpaid', 'Credit Card', 0.00, 200.00);

UPDATE Payment
SET Payment_status = 'Paid', Amount_paid = 200.00
WHERE Payment_id = 11;

DELETE FROM Payment
WHERE Payment_id = 11;


REVERT;
EXECUTE AS USER = 'Emma';

-- Testing Customer for 'Emma'
SELECT * FROM dbo.Customer;

INSERT INTO Customer (Cust_id, First_name, Last_name,Phone, Address, City, State)
VALUES (501, 'Dongok', 'Yang', '2048699533', '1159 Valour St', 'Winnipeg', 'MB');

UPDATE Customer
SET First_name ='Dong'
WHERE Cust_id = 501;

DELETE FROM Customer
WHERE Cust_id = 501;

-- Testing Order for 'Emma'
SELECT USER;

SELECT * FROM [Order];

INSERT INTO [Order](Order_id, Cust_id, Payment_id,Order_date,Order_total)
VALUES (13, 501, 11, Null, Null);

UPDATE [Order]
SET Order_total = 1
WHERE Cust_id = 501;

DELETE FROM [Order]
WHERE Cust_id = 501;

-- Testing Product for 'Emma'

SELECT * FROM Product;
INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1001, 'Stray Kids Lightstick', 'Stray Kids', 30, 50.00);

UPDATE Product
SET Price = 45.00, Remaining_quantity = 25
WHERE Product_id = 1001;

DELETE FROM Product
WHERE Product_id = 1001;

-- Testing Payment for 'Emma'

SELECT * FROM Payment;

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (11, 'Unpaid', 'Credit Card', 0.00, 200.00);

UPDATE Payment
SET Payment_status = 'Paid', Amount_paid = 200.00
WHERE Payment_id = 11;

DELETE FROM Payment
WHERE Payment_id = 11;


REVERT;
EXECUTE AS USER = 'James';

-- Testing Customer for 'James'
SELECT * FROM dbo.Customer;

INSERT INTO Customer (Cust_id, First_name, Last_name,Phone, Address, City, State)
VALUES (501, 'Dongok', 'Yang', '2048699533', '1159 Valour St', 'Winnipeg', 'MB');

UPDATE Customer
SET First_name ='Dong'
WHERE Cust_id = 501;

DELETE FROM Customer
WHERE Cust_id = 501;

-- Testing Order for 'James'
SELECT USER;

SELECT * FROM [Order];

INSERT INTO [Order](Order_id, Cust_id, Payment_id,Order_date,Order_total)
VALUES (13, 501, 11, Null, Null);

UPDATE [Order]
SET Order_total = 1
WHERE Cust_id = 501;

DELETE FROM [Order]
WHERE Cust_id = 501;

-- Testing Product for 'James'

SELECT * FROM Product;
INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1001, 'Stray Kids Lightstick', 'Stray Kids', 30, 50.00);

UPDATE Product
SET Price = 45.00, Remaining_quantity = 25
WHERE Product_id = 1001;

DELETE FROM Product
WHERE Product_id = 1001;

-- Testing Payment for 'James'

SELECT * FROM Payment;

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (11, 'Unpaid', 'Credit Card', 0.00, 200.00);

UPDATE Payment
SET Payment_status = 'Paid', Amount_paid = 200.00
WHERE Payment_id = 11;

DELETE FROM Payment
WHERE Payment_id = 11;
