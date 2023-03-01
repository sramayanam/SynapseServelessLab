CREATE VIEW TaxiPartitioningView AS
SELECT
result.*,result.filepath(1) as yearmonth
FROM
    OPENROWSET(
            BULK '/data/parquetfiles/green_tripdata_*.*',
            DATA_SOURCE='ContosoLake1',
            FORMAT='PARQUET'
    ) AS [result]
where result.filepath(1) = '2022-11';

