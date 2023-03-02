/** There are two ways to read the JSON files using JSON_VALUE & OpenJSON as shown below **/
select
    TOP 100
    JSON_VALUE(doc, '$.date_rep') AS date_reported,
    JSON_VALUE(doc, '$.countries_and_territories') AS country,
    CAST(JSON_VALUE(doc, '$.deaths') AS INT) as fatal,
    JSON_VALUE(doc, '$.cases') as cases,
    doc
from openrowset(
        bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.jsonl',
                format='csv', fieldterminator ='0x0b', fieldquote = '0x0b'
    ) with (doc nvarchar(max)) as rows
order by JSON_VALUE(doc, '$.geo_id') desc;

select
date_rep,
cases,
fatal,
country
from openrowset(
        bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.jsonl',
        format='csv', 
        fieldterminator ='0x0b', 
        fieldquote = '0x0b'

    ) with (doc nvarchar(max)) as rows
    cross apply openjson (doc)
        with (  date_rep datetime2,
                cases int,
                fatal int '$.deaths',
                country varchar(100) '$.countries_and_territories')
where country = 'India'
order by country, date_rep desc;

/** The following query shows a way to read the nested json structure and apply business rules
to derive the diffent patterns **/
/** This example shows two patterns that are read to derive parentname **/

select
id,
CASE WHEN parent1 IS NULL THEN concat(parent1fname,' ',parent1lname) ELSE parent1 END Parent1Name,
CASE WHEN parent2 IS NULL THEN concat(parent2fname,' ',parent2lname) ELSE parent2 END Parent2Name
from openrowset(
        bulk 'https://srramsynstorage.blob.core.windows.net/data/jsonl/families.jsonl',
                format='csv', fieldterminator ='0x0b', fieldquote = '0x0b'
    ) with (doc nvarchar(max)) as rows
cross apply openjson (doc)
        with (  
                id varchar(100),
                parent1 varchar(25) '$.parents[0].firstName',
                parent2 varchar(25) '$.parents[1].firstName',
                parent1fname varchar(25) '$.parents[0].familyName',
                parent1lname varchar(25) '$.parents[0].givenName',
                parent2fname varchar(25) '$.parents[1].familyName',
                parent2lname varchar(25) '$.parents[1].givenName'
                );
