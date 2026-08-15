

CREATE VIEW [dbo].[VLastOccupationTotal] AS 
SELECT [IDPK]
      ,[CounterID]
      ,[SCType]
      ,[CounterType]
      ,[CounterName]
      ,[Capacity]
      ,[CurrentLevel]
      ,[Perc]
      ,[Updated]
  FROM [dbo].[VLastOccupationAllDetail]
  --where 
  --([SCType] = 'SD' and [CounterId] = 3) or
  --([SCType] = 'EQ' and [CounterName] like '%Todos%') or
  --([SCType] = 'MY' and [CounterName] like '%Todos%')