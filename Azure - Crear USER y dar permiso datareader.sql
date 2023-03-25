CREATE USER [sql_developer] FROM  EXTERNAL PROVIDER 
GO
ALTER ROLE db_owner ADD MEMBER [sql_developer];
go
ALTER ROLE db_datawriter ADD MEMBER [sql_developer];

ALTER ROLE db_datareader ADD MEMBER  [sql_sn4]

