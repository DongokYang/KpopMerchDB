/**
** Name : Dongok Yang
** Final project - Kpop merch DB
** Date : October 12th, 2024
**/

-- 3.1	Create Database 
CREATE DATABASE KpopMerchDB;
GO

USE KpopMerchDB;
GO

/*
3.2	Create all Tables in the Database (mapped to ERD) 
3.3	Create all relationship constraints
	- Respecting Referential Integrity where appropriate
3.4	Create one other type of constraint included e.g. check constraint
*/

CREATE TABLE Customer (
    Cust_id		INT NOT NULL,
    First_name	VARCHAR(15) NOT NULL,
    Last_name	VARCHAR(15) NOT NULL,
    Phone		VARCHAR(15) NOT NULL,
    Address		VARCHAR(40),
    City		VARCHAR(30),
    State		VARCHAR(20),
	CONSTRAINT PK_Customer
		PRIMARY KEY (Cust_id)
);

CREATE TABLE Payment (
    Payment_id        INT NOT NULL,
    Payment_status    VARCHAR(6)	NOT NULL DEFAULT 'Unpaid',
    Payment_method    VARCHAR(15)	NOT NULL,
    Amount_paid       DECIMAL(6, 2) NOT NULL DEFAULT 0.00,
    Payment_total     DECIMAL(6, 2) DEFAULT 0.00,
	CONSTRAINT PK_Payment
		PRIMARY KEY (Payment_id),
	CONSTRAINT CK_Payment_status
		CHECK (Payment_status IN ('Paid', 'Unpaid'))
);

CREATE TABLE Product (
    Product_id			INT NOT NULL,       
    Product_name		NVARCHAR(100) NOT NULL,       
    Group_name			NVARCHAR(50),                        
    Remaining_quantity	INT NOT NULL DEFAULT 0,      
    Price				DECIMAL(5, 2) NOT NULL,
	CONSTRAINT PK_Product
		PRIMARY KEY (Product_id)
);

CREATE TABLE [Order] (
    Order_id	INT NOT NULL,
    Cust_id		INT,
    Payment_id	INT NOT NULL,
    Order_date	DATETIME DEFAULT GETDATE(),
	Order_total DECIMAL(6, 2) DEFAULT 0.00,
	CONSTRAINT PK_Order
		PRIMARY KEY (order_id),
	CONSTRAINT FK_Makes
		FOREIGN KEY (Cust_id)
		REFERENCES Customer,
	CONSTRAINT FK_Settles
		FOREIGN KEY (Payment_id)
		REFERENCES Payment
);

CREATE TABLE Order_Product (
    Order_id		INT NOT NULL,
    Product_id		INT NOT NULL,
    Order_quantity	INT NOT NULL,
	CONSTRAINT PK_Order_Product
		PRIMARY KEY (Order_id, Product_id),
	CONSTRAINT FK_Includes
		FOREIGN KEY (Order_id)
		REFERENCES [Order],
	CONSTRAINT FK_Details
		FOREIGN KEY (Product_id)
		REFERENCES Product
);


--3.5	Create a minimum of 2 indexes and explain purpose
-- Index on Customer's first name for faster search
-- I made this index to search customer's details using customer's firstname
CREATE NONCLUSTERED INDEX IX_First_name ON Customer(First_name);

-- Index on Product price for faster search
-- I made this index to search Product's details using product's name
CREATE NONCLUSTERED INDEX IX_Product_name ON Product(Product_name);
GO


--3.6	Create a minimum of 1 trigger, explain  and demonstrate purpose
-- Trigger to automatically update remaining_quantity after an order is placed
CREATE OR ALTER TRIGGER TriggerUpdateStock 
ON Order_Product AFTER INSERT
AS
BEGIN
    DECLARE 
        @productID INT,
        @orderQuantity INT;
    
    SELECT 
        @productID = Product_id, 
        @orderQuantity = Order_quantity 
    FROM inserted;
    
    UPDATE Product
    SET Remaining_quantity = Remaining_quantity - @orderQuantity
    WHERE Product_id = @productID;
END;
GO

-- Demonstrate TriggerUpdateStock
-- Expected outcome : remaining_quantity = 20 ( Remaining_quantity - Order_quantity)
BEGIN TRANSACTION;
INSERT INTO Customer (Cust_id, First_name, Last_name, Phone, Address, City, State)
VALUES (1, 'Dongok', 'Yang', '204-869-9533', 'Valour 1159', 'Winnipeg', 'MB');

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (1, 'Unpaid', 'Credit Card', 0.00, null);

INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (1, 1, 1, GETDATE(), 0.00);

INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1, 'BTS Album', 'BTS', 50, 20.00);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (1, 1, 30);

SELECT Product_id, Remaining_quantity FROM Product WHERE Product_id = 1;
SELECT * FROM Product;
SELECT * FROM Order_Product;
ROLLBACK TRANSACTION;
GO

-- Trigger to automatically update order_total and payment_total after an order is placed
CREATE OR ALTER TRIGGER TriggerUpdateOrderAndPaymentTotals
ON Order_Product
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE [Order]
    SET order_total = (
        SELECT SUM(op.order_quantity * p.price)
        FROM Order_Product op
        INNER JOIN Product p ON op.product_id = p.product_id
        WHERE op.order_id = [Order].order_id
    )
    WHERE order_id IN (
        SELECT DISTINCT order_id
        FROM inserted
        UNION
        SELECT DISTINCT order_id
        FROM deleted
    );

    UPDATE Payment
    SET payment_total = (
        SELECT SUM(o.order_total)
        FROM [Order] o
        WHERE o.payment_id = Payment.payment_id
    )
    WHERE payment_id IN (
        SELECT DISTINCT o.payment_id
        FROM [Order] o
        INNER JOIN inserted i ON o.order_id = i.order_id
        UNION
        SELECT DISTINCT o.payment_id
        FROM [Order] o
        INNER JOIN deleted d ON o.order_id = d.order_id
    );
END;
GO

-- Demonstrate TriggerUpdateOrderAndPaymentTotals
-- Expected outcome : order_total = 600,300 (order_quantity * p.price) , payment_total = 900 (Sum of order_total) 
BEGIN TRANSACTION;
INSERT INTO Customer (Cust_id, First_name, Last_name, Phone, Address, City, State)
VALUES (1, 'Dongok', 'Yang', '204-869-9533', 'Valour 1159', 'Winnipeg', 'MB');

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (1, 'Unpaid', 'Credit Card', 0.00, null);

INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (1, 1, 1, GETDATE(),null);
INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (2, 1, 1, GETDATE(),null);

INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1, 'BTS Album', 'BTS', 50, 20.00);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (1, 1, 30);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (2, 1, 15);

SELECT * FROM Payment;
SELECT * FROM [Order];
SELECT * FROM Product;
SELECT * FROM Order_Product;
ROLLBACK TRANSACTION;
GO

-- Trigger to automatically update payment status after the change for the amount of payment
CREATE OR ALTER TRIGGER TriggerUpdatePaymentStatus
ON Payment
AFTER UPDATE
AS
BEGIN
    UPDATE Payment
    SET payment_status = 'Paid'
    WHERE payment_id IN (
        SELECT payment_id
        FROM inserted
        WHERE amount_paid = payment_total
    );
END;
GO

-- Demonstrate TriggerUpdatePaymentStatus
-- Expected outcome : payment_status = 'Paid' ( amount_paid = payment_total)
BEGIN TRANSACTION;
INSERT INTO Customer (Cust_id, First_name, Last_name, Phone, Address, City, State)
VALUES (1, 'Dongok', 'Yang', '204-869-9533', 'Valour 1159', 'Winnipeg', 'MB');

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (1, 'Unpaid', 'Credit Card', 0.00, null);

INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (1, 1, 1, GETDATE(),null);
INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (2, 1, 1, GETDATE(),null);

INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1, 'BTS Album', 'BTS', 50, 20.00);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (1, 1, 30);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (2, 1, 15);


UPDATE Payment
SET Amount_paid = 900.00
WHERE Payment_id = 1;

SELECT * FROM Payment;
ROLLBACK TRANSACTION;
GO


--3.7	Create two views that operate and restrict data in some way
-- This view only shows information of customer who didn't paid for order without showing address
CREATE VIEW Unpaid_orders AS
SELECT o.Order_id, o.Order_date, c.First_name, c.Last_name, c.Phone
FROM [Order] o
JOIN Customer c ON o.Cust_id = c.Cust_id
JOIN Payment p ON o.Payment_id = p.Payment_id
WHERE p.Payment_status = 'Unpaid';
GO

-- This view only shows information of product which has low stock without unnecesary information.
CREATE VIEW Low_stock AS
SELECT Product_id, Product_name, Remaining_quantity
FROM Product
WHERE Remaining_quantity < 10;
GO

--3.8	Create 1 function, explain and demonstrate its use
-- Function to calculate outstanding balance 
CREATE OR ALTER FUNCTION ufn_GetOutstandingBalance (@CustID INT)
RETURNS DECIMAL(7, 2)
AS
BEGIN
    RETURN (
        SELECT SUM(o.Order_total - p.Amount_paid)
        FROM [Order] o
        JOIN Payment p ON o.Payment_id = p.Payment_id
        WHERE o.Cust_id = @CustID AND p.Payment_status = 'Unpaid'
    );
END;
GO

BEGIN TRANSACTION;
INSERT INTO Customer (Cust_id, First_name, Last_name, Phone, Address, City, State)
VALUES 
	(1, 'Dongok', 'Yang', '204-869-9533', 'Valour 1159', 'Winnipeg', 'MB'),
	(2, 'Anh', 'Phi', '202-869-9533', 'Academy 1159', 'Winnipeg', 'MB');
INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES 
	(1, 'Unpaid', 'Credit Card', 100.00, null),
	(2, 'Unpaid', 'Credit Card', 0.00, null);
INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES 
	(1, 1, 1, GETDATE(),null),
	(2, 2, 2, GETDATE(),null);

INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1, 'BTS Album', 'BTS', 50, 20.00);
INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES 
	(1, 1, 30),
	(2, 1, 10);

SELECT * FROM Payment;
SELECT dbo.ufn_GetOutstandingBalance(1) AS OutstandingBalance;
SELECT dbo.ufn_GetOutstandingBalance(2) AS OutstandingBalance;
ROLLBACK TRANSACTION;
GO

/*
3.9.2	Create 1 Stored procedure including the use of a transaction, explain and demonstrate its use
*/
/*
 * Dongok Yang
 * November 18, 2024
 * Change payment status depending the amount of payment made 
 */ 
GO
CREATE OR ALTER PROCEDURE usp_changePaymentStatus
(
    @Payment_id INT,
    @paymentAmount DECIMAL(7, 2)
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Payment
            WHERE Payment_id = @Payment_id
        )
            THROW 50002, 'Payment ID is not found.', 1;

        UPDATE dbo.Payment
        SET Amount_paid = Amount_paid + @paymentAmount
        WHERE Payment_id = @Payment_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

BEGIN TRANSACTION;
INSERT INTO Customer (Cust_id, First_name, Last_name, Phone, Address, City, State)
VALUES (1, 'Dongok', 'Yang', '204-869-9533', 'Valour 1159', 'Winnipeg', 'MB');

INSERT INTO Payment (Payment_id, Payment_status, Payment_method, Amount_paid, Payment_total)
VALUES (1, 'Unpaid', 'Credit Card', 0.00, null);

INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (1, 1, 1, GETDATE(),null);
INSERT INTO [Order] (Order_id, Cust_id, Payment_id, Order_date, Order_total)
VALUES (2, 1, 1, GETDATE(),null);

INSERT INTO Product (Product_id, Product_name, Group_name, Remaining_quantity, Price)
VALUES (1, 'BTS Album', 'BTS', 50, 20.00);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (1, 1, 30);

INSERT INTO Order_Product (Order_id, Product_id, Order_quantity)
VALUES (2, 1, 15);

SELECT * FROM Payment;
EXEC usp_changePaymentStatus @Payment_id = 1, @paymentAmount = 100.00;
SELECT * FROM Payment;
ROLLBACK TRANSACTION;

GO