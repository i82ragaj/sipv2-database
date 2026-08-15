



CREATE VIEW [dbo].[VLastOccupationRotation] AS 
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
  where ([SCType] = 'SD' and [CounterId] = 1) or
  ([SCType] = 'EQ' and [CounterName] like '%Rot%')