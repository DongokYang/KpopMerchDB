/*
 * Dongok Yang
 * December 1, 2024
 * Import data from csv files
 */ 
DECLARE @sql NVARCHAR(MAX);
DECLARE @filePath NVARCHAR(255) = 'C:\\Temp\\dbms_final\\';

SET @sql = N'BULK INSERT [Order] FROM ''' + @filePath + N'KpopMerchDB_Order.csv'' ' +
           N'WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', FIRSTROW = 2);';
EXEC sp_executesql @sql;

SET @sql = N'BULK INSERT Customer FROM ''' + @filePath + N'KpopMerchDB_Customer.csv'' ' +
           N'WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', FIRSTROW = 2);';
EXEC sp_executesql @sql;

SET @sql = N'BULK INSERT Product FROM ''' + @filePath + N'Cleaned_KpopMerchDB_Product.csv'' ' +
           N'WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', FIRSTROW = 2);';
EXEC sp_executesql @sql;

SET @sql = N'BULK INSERT Payment FROM ''' + @filePath + N'KpopMerchDB_Payment.csv'' ' +
           N'WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', FIRSTROW = 2);';
EXEC sp_executesql @sql;

SET @sql = N'BULK INSERT Order_Product FROM ''' + @filePath + N'KpopMerchDB_Order_Product.csv'' ' +
           N'WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', FIRSTROW = 2);';
EXEC sp_executesql @sql;