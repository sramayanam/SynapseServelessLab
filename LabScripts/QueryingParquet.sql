CREATE DATABASE DataExplorationDB1 
                COLLATE Latin1_General_100_BIN2_UTF8;


USE DataExplorationDB1;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Lz8oq1dn';
GO
CREATE DATABASE SCOPED CREDENTIAL [storage_credential] WITH IDENTITY='Managed Identity';
GO
CREATE EXTERNAL DATA SOURCE ContosoLake1 WITH ( LOCATION = 'https://srramsynstorage.dfs.core.windows.net',CREDENTIAL = storage_credential);
GO

CREATE EXTERNAL FILE FORMAT ParquetFormat
    WITH (
        FORMAT_TYPE = PARQUET
    );
GO

SELECT
    TOP 100 *,result.filepath(1) as YearMonth
FROM
    OPENROWSET(
            BULK '/data/parquetfiles/green_tripdata_*.*',
            DATA_SOURCE = 'ContosoLake1',
            FORMAT='PARQUET'
    ) AS [result]
;

DROP EXTERNAL TABLE dbo.taxidata;
CREATE EXTERNAL TABLE dbo.taxidata
(
VendorID INT,
lpep_pickup_datetime DATETIME2,
lpep_dropoff_datetime DATETIME2,
store_and_fwd_flag	VARCHAR(2),
RatecodeID	float,
PULocationID INT,
DOLocationID INT,
passenger_count	float,
trip_distance float,
fare_amount	float,
extra float,
mta_tax	float,
tip_amount float,
tolls_amount float,
ehail_fee VARCHAR(10),
improvement_surcharge float,
total_amount float,
payment_type float,	
trip_type float,
congestion_surcharge float
)
WITH
(
    LOCATION='data/parquetfiles/green_tripdata_*.parquet',
    DATA_SOURCE=ContosoLake1,
    FILE_FORMAT=ParquetFormat
);
GO

SELECT TOP 100 * FROM dbo.taxidata;
