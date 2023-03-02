/* Run the SynapseSparkBatchIngestion notebook before executing the following queries */
/* First create a credential */
IF (NOT EXISTS(SELECT * FROM sys.credentials WHERE name = 'srramcosmosdb'))
    THROW 50000, 'As a prerequisite, create a credential with Azure Cosmos DB key in SECRET option:
    CREATE CREDENTIAL [MyCosmosDbAccountCredential]
    WITH IDENTITY = ''SHARED ACCESS SIGNATURE'', SECRET = ''<Enter your Azure Cosmos DB key here>''', 0
GO

/*Query Analytical Container*/
SELECT TOP 10 *
FROM OPENROWSET(
      PROVIDER = 'CosmosDB',
      CONNECTION = 'Account=srramcosmosdb;Database=RetailSalesDemoDB',
      OBJECT = 'RetailSales',
      SERVER_CREDENTIAL = 'MyCosmosDbAccountCredential'
    ) as rows