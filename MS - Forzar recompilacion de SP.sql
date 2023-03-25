--Force recompilation of all objects
SET QUOTED_IDENTIFIER OFF
DECLARE @sql nvarchar(MAX);
SELECT @sql = (SELECT "EXEC sp_recompile '" + rtrim(sc.name) + "." + rtrim(so.name) + "' "
from sys.sysobjects so
join sys.schemas sc
on so.uid = sc.schema_id
where so.xtype = "U"
               FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)');
PRINT @sql
-- EXEC (@sql)
SET QUOTED_IDENTIFIER ON 
