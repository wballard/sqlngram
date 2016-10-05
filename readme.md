#SQLNGRAM
This is an implementation of [IWordBreaker](https://msdn.microsoft.com/en-us/library/ms691079(v=vs.85).aspx)
that rather than breaking on words, breaks character ngrams, making it perfect for autocomplete search -- 
as opposed to the usual lazy tactic of `LIKE '%word%'` that folks fall into.

##Installation
Knowing how much folks just love building C++, I've checked in a built version. 

* Copy (./x64/Release/sqlngram.dll) to your SQL Server `BINN` folder 
* Run (./register.sql)
* *Not Entertaining**, search registry for `{d225281a-7ca9-4a46-ae7d-c63a9d4815d4}`, copy `DefaultData` to `(Default)`
  ***let me know if you can figure a way to automate writing the default value :) ***
* Test
```
  SELECT * FROM sys.dm_fts_parser (' "Hello World" ', 1, 0, 0)
```


##Samples
```
USE GLGLIVE
EXEC sys.sp_cdc_enable_db  

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'COMPANY',  
@role_name     = NULL,  
@supports_net_changes = 1 

CREATE FULLTEXT CATALOG GLGLIVE_FULLTEXT

CREATE FULLTEXT INDEX ON dbo.COMPANY
  (   
  PRIMARY_NAME  
      Language 1,   
  SECONDARY_NAME  
      Language 1   
  )  
  KEY INDEX PK_COMPANY ON GLGLIVE_FULLTEXT WITH STOPLIST = OFF, CHANGE_TRACKING AUTO  

--wait for it ....

SELECT 
  PRIMARY_NAME, *
FROM
  dbo.COMPANY 
  JOIN CONTAINSTABLE(dbo.COMPANY, (PRIMARY_NAME, SECONDARY_NAME), 'Gerso') ft ON [KEY] = COMPANY_ID
ORDER BY RANK DESC

--or even, notice the 'words' separated by ~ that's the 'near operator'
--effectively replace all the spaces in your query with ' ~ '

SELECT 
  PRIMARY_NAME, *
FROM
  dbo.COMPANY 
  JOIN CONTAINSTABLE(dbo.COMPANY, (PRIMARY_NAME, SECONDARY_NAME), 'Gerso ~ Leh') ft ON [KEY] = COMPANY_ID
ORDER BY RANK DESC
   
```


##Using with Table Valued Functions
create an auto complete table valued function

```
create function dbo.sqlAutoComplete (@searchTerm nvarchar(256))
returns @results table (
  COMPANY_ID INT
  ,PRIMARY_NAME nvarchar(255)
  ,SECONDARY_NAME nvarchar(255)
  )
AS 
BEGIN
  SET @searchTerm = REPLACE(@searchTerm,' ', ' ~ ');
  
  INSERT INTO @results
  SELECT  COMPANY_ID
      ,PRIMARY_NAME
      ,SECONDARY_NAME
  FROM  dbo.COMPANY 
    JOIN CONTAINSTABLE(dbo.COMPANY, (PRIMARY_NAME, SECONDARY_NAME), @searchTerm ) ft ON [KEY] = COMPANY_ID
  ORDER BY RANK DESC;
  RETURN
END
```

then search on it as if you're querying a table
```
select * from dbo.sqlAutoComplete('Gerson Leh')
```

This function can be used among all your auto complete functions to format search input terms
```

create function dbo.sqlAutoCompleteFormatInput (@searchTerm nvarchar(256))
returns nvarchar(256)
as 
begin
  -- sub special characters for spaces
  SET @searchTerm = REPLACE(REPLACE(REPLACE(
      @searchTerm
      ,char(9), ' ')
      ,char(10), ' ')
      ,char(13), ' ');

  -- get rid of multiple spaces
  WHILE CHARINDEX('  ',@searchTerm) > 0
    SET @searchTerm = REPLACE(@searchTerm, '  ', ' ')

  -- sub out spaces for CONTAINS "NEAR" syntax
  SET @searchTerm = replace(@searchTerm,' ', ' ~ ')
  return @searchTerm
end
GO
```
