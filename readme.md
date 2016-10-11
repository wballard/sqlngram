#SQLNGRAM
This is an implementation of [IWordBreaker](https://msdn.microsoft.com/en-us/library/ms691079(v=vs.85).aspx)
that rather than breaking on words, breaks character ngrams, making it perfect for autocomplete search -- 
as opposed to the usual lazy tactic of `LIKE '%word%'` that folks fall into.

##Installation
Knowing how much folks just love building C++, I've checked in a built version. 

* Copy (./x64/Release/sqlngram.dll) to your SQL Server `BINN` folder 
* Run (./register.sql)
* *Not Entertaining**, search registry for `{0a275611-aa4d-4b39-8290-4baf77703f55}` `{d225281a-7ca9-4a46-ae7d-c63a9d4815d4}`, copy `DefaultData` to `(Default)`
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
SELECT TOP 20
  PRIMARY_NAME, *
FROM
  dbo.COMPANY 
  JOIN FREETEXTTABLE (dbo.COMPANY, (PRIMARY_NAME, SECONDARY_NAME), 'Gerson') ft ON [KEY] = COMPANY_ID
ORDER BY RANK DESC


SELECT TOP 20
  PRIMARY_NAME, *
FROM
  dbo.COMPANY 
  JOIN FREETEXTTABLE (dbo.COMPANY, (PRIMARY_NAME, SECONDARY_NAME), 'Gerson Leh') ft ON [KEY] = COMPANY_ID
ORDER BY RANK DESC
   
```

