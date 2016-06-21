exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\CLSID\{d225281a-7ca9-4a46-ae7d-c63a9d4815d4}', 'DefaultData', 'REG_SZ', 'sqlngram.dll'
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'Locale', 'REG_DWORD', 1
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'WBreakerClass', 'REG_SZ', '{d225281a-7ca9-4a46-ae7d-c63a9d4815d4}'
exec sp_fulltext_service 'verify_signature' , 0;
exec sp_fulltext_service 'update_languages';
exec sp_fulltext_service 'restart_all_fdhosts';