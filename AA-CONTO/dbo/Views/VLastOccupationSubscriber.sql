




CREATE VIEW [dbo].[VLastOccupationSubscriber] AS 
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
  where ([SCType] = 'SD' and [CounterId] = 2) or
  ([SCType] = 'EQ' and [CounterName] like '%Abo%')