CREATE EXTERNAL FILE FORMAT DeltaLakeFormat
WITH (  
    FORMAT_TYPE = DELTA
);
GO


SELECT         
MONTH(lpep_pickup_datetime) AS mo ,
passenger_count,
COUNT(*) AS cnt
FROM OPENROWSET(

            BULK '/data/parquetfiles',
            DATA_SOURCE = 'ContosoLake',
            FORMAT = 'DELTA'
    ) nyc
WHERE MONTH(lpep_pickup_datetime) IN (8,9,10)
GROUP BY
MONTH(lpep_pickup_datetime),
passenger_count