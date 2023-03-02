/* Create External table as select is useful when committing 
the required data post data exploration
 to the storage for later use ****/
USE DataExplorationDB;
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Lz8oq1dn';

CREATE DATABASE SCOPED CREDENTIAL [WorkspaceIdentity] WITH IDENTITY = 'Managed Identity';
GO

CREATE EXTERNAL FILE FORMAT parquet_file_format
WITH
(  
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);
GO


CREATE EXTERNAL TABLE [dbo].taxideltatable WITH (
        LOCATION = '/data/curatedparquet1/',
        DATA_SOURCE = ContosoLake,
        FILE_FORMAT = parquet_file_format
) AS
SELECT * FROM dbo.GreenTaxiCleansed;
GO