SELECT
TOP 100 *
FROM
    OPENROWSET(
            BULK '/data/csvfiles/taxi_zone_lookup.csv',
            DATA_SOURCE = 'ContosoLake',
            FORMAT='csv',
            PARSER_VERSION = '2.0'
    ) AS [location];

DROP EXTERNAL FILE FORMAT CsvFormat;
CREATE EXTERNAL FILE FORMAT CsvFormat
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS(
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '"',
            FIRST_ROW = 2
        )
    );
GO

DROP EXTERNAL TABLE dbo.location;
CREATE EXTERNAL TABLE dbo.location
(
         LocationID INT,
         Borough VARCHAR(50),
         Zone VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
         service_zone VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8
)
WITH
(
    LOCATION='/data/csvfiles/taxi_zone_lookup.csv',
    DATA_SOURCE=ContosoLake,
    FILE_FORMAT=CsvFormat
);
GO

SELECT TOP 100 * from  dbo.location
