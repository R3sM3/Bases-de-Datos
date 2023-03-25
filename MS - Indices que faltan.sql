DECLARE @runtime datetime 
SET @runtime = GETDATE() 
SELECT CONVERT (varchar, @runtime, 126) AS runtime,  
mig.index_group_handle, mid.index_handle,  
CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS improvement_measure,  
'CREATE INDEX missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' + CONVERT (varchar, mid.index_handle)  
+ ' ON ' + mid.statement  
+ ' (' + ISNULL (mid.equality_columns,'')  
+ CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END + ISNULL (mid.inequality_columns, '') 
+ ')' 
+ ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement,  
migs.*, mid.database_id, mid.[object_id] 
FROM sys.dm_db_missing_index_groups mig 
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle 
WHERE CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) > 10 
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC 

CREATE INDEX IX_InfoCred ON [DB-MONACO-MACA].[dbo].[INFORMACION_CREDITO] ([ID_CREDITO]) INCLUDE ([ESTADO], [FECHA_PAGARE], [TMC_TRAMO1], [TMC_TRAMO2], [TMC_TRAMO3], [MONTO_BRUTO_CREDITO])

CREATE NONCLUSTERED INDEX [IX_IdCredito] ON [dbo].[INFORMACION_CREDITO]
(
    [ID_CREDITO] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_NumeroCuota] ON [dbo].[INFORMACION_CUOTA_CREDITO]
(
    [NUMERO_CUOTA] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


CREATE INDEX IX_periodo ON [DB-MONACO-MACA].[dbo].[TCUOTA] ([PERIODO]) INCLUDE ([ID_CREDITO], [CAPITAL_CUOTA], [SALDO_INSOLUTO_CUOTA])
CREATE INDEX IX_tipo_pago ON [DB-MONACO-MACA].[dbo].[TPAGO] ([TIPO_PAGO]) INCLUDE ([CREDITO_ID], [MONTO], [FECHA_PAGO], [REGISTRO_PAGO_ID], [REVERSADO])


SELECT SCHEMA_NAME(schema_id) AS [SchemaName],
[Tables].name AS [TableName],
SUM([Partitions].[rows]) AS [TotalRowCount]
FROM sys.tables AS [Tables]
JOIN sys.partitions AS [Partitions]
ON [Tables].[object_id] = [Partitions].[object_id]
AND [Partitions].index_id IN ( 0, 1 )
-- WHERE [Tables].name = N'name of the table'
GROUP BY SCHEMA_NAME(schema_id), [Tables].name;
