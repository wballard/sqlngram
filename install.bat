net stop /Y MSSQLSERVER
copy x64\Release\sqlngram.dll "C:\Program Files\Microsoft SQL Server\MSSQL13.DEVLOCAL\MSSQL\Binn\"
net start MSSQLSERVER