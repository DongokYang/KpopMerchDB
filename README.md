# Kpop Merch Database Project

**Author**: Dongok Yang  
**Date**: December 3th, 2024  
**Project**: Final Project - Kpop Merch DB

## Overview

This project involves creating a database for managing a Kpop merchandise store. The database handles customers, products, orders, payments, and inventory with proper relationships and constraints to maintain data integrity.

## Features

1. **Database Creation**:

   - Created a database named `KpopMerchDB` with the following tables:
     - `Customer`
     - `Payment`
     - `Product`
     - `Order`
     - `Order_Product` (junction table for many-to-many relationships).

2. **Constraints**:

   - Primary keys for unique identification.
   - Foreign keys to enforce relationships.
   - Check constraints for payment status validation (`Paid`, `Unpaid`).

3. **Indexes**:

   - Non-clustered index on `Customer.First_name` for faster customer lookups.
   - Non-clustered index on `Product.Product_name` for faster product searches.

4. **Triggers**:

   - Automatically update product stock after an order.
   - Update order and payment totals after modifications.
   - Change payment status to `Paid` when the full amount is received.

5. **Views**:

   - `Unpaid_orders`: Displays unpaid orders without customer addresses.
   - `Low_stock`: Shows products with low inventory.

6. **Function**:

   - `ufn_GetOutstandingBalance`: Calculates a customer's outstanding balance.

7. **Stored Procedure**:
   - `usp_changePaymentStatus`: Updates payment amounts and handles transactions.

## Data Population

- Inserted sample data into tables:
  - Customers, products, orders, and payments.
- Demonstrated functionality using transactions and queries.

## Queries

- **Joins**:
  - Inner and outer joins to retrieve related data from multiple tables.
- **Subqueries**:
  - Correlated and non-correlated subqueries for advanced queries.
- **Aggregations**:
  - Summarized data such as total payments and order values.

## How to Run

1. Clone this repository or copy the provided files.
2. Execute the `kpopmerchDB.sql` script in SQL Server Management Studio (SSMS).
3. Run the sample queries to test functionality.

## Technologies Used

- **SQL Server**: Database management system.
- **T-SQL**: Used for all scripts, triggers, views, functions, and stored procedures.

## Author

This project was developed by Dongok Yang as part of a final project for database management coursework.
