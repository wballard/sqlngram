--EXEC sp_fulltext_service @action='load_os_resources', @value=1;
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'Locale', 'REG_DWORD', 1
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'NoiseFile', 'REG_SZ', 'noiseenu.txt'
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'StemmerClass', 'REG_SZ', '{0a275611-aa4d-4b39-8290-4baf77703f55}'
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'TSaurusFile', 'REG_SZ', 'TSENU.XML'
exec master.dbo.xp_instance_regwrite  'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\MSSQLSERVER\MSSearch\Language\ngram', 'WBreakerClass', 'REG_SZ', '{d225281a-7ca9-4a46-ae7d-c63a9d4815d4}'
exec sp_fulltext_service 'verify_signature' , 0;
exec sp_fulltext_service 'update_languages';
exec sp_fulltext_service 'restart_all_fdhosts';
EXEC sp_help_fulltext_system_components 'wordbreaker';