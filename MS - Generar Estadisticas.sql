-- Update ALL Statistics WITH FULLSCAN 
-- This will update all the statistics on all the tables in your database.
-- remove the comments from EXEC sp_executesql in order to have the commands actually update stats, instead of just printing them.
SET NOCOUNT ON
GO
 
DECLARE updatestats CURSOR FOR
SELECT table_schema, table_name  
FROM information_schema.tables
where TABLE_TYPE = 'BASE TABLE'
OPEN updatestats
 
DECLARE @tableSchema NVARCHAR(128)
DECLARE @tableName NVARCHAR(128)
DECLARE @Statement NVARCHAR(300)
 
FETCH NEXT FROM updatestats INTO @tableSchema, @tableName
 
WHILE (@@FETCH_STATUS = 0)
BEGIN
   SET @Statement = 'UPDATE STATISTICS '  + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + ' WITH FULLSCAN'
   PRINT @Statement -- comment this print statement to prevent it from printing whenever you are ready to execute the command below.
  --EXEC sp_executesql @Statement -- remove the comment on the beginning of this line to run the commands 
   FETCH NEXT FROM updatestats INTO @tableSchema, @tableName
END
 
CLOSE updatestats
DEALLOCATE updatestats
GO
SET NOCOUNT OFF
GO
