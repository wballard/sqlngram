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