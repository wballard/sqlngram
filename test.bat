sqlcmd -H localhost -E -d GLGLIVE -Q "SELECT occurrence, display_term FROM sys.dm_fts_parser ('""Hello World""', 1, 0, 0)" -Y 40
