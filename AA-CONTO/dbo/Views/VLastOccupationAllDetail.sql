







CREATE VIEW [dbo].[VLastOccupationAllDetail] AS 
select c.IDPK, c.CounterID, p.[type] [SCType], b.[CounterType], c.[Updated],
coalesce(b.CounterName, a.CounterName) [CounterName],
coalesce(b.OccupancyLimit, c.Capacity, a.OccupancyLimit) [Capacity], c.CurrentLevel, 
round((cast(c.CurrentLevel as decimal(6,2)) / cast(case when coalesce(b.OccupancyLimit, c.Capacity, a.OccupancyLimit) = 0 then 1 else coalesce(b.OccupancyLimit, c.Capacity, a.OccupancyLimit) end as decimal(6,2))) * 100, 2) Perc
from
(SELECT [IDPK]
      ,[CounterID]
      ,[CurrentLevel]
      ,[Capacity]
      ,[Updated]
	  ,[index] = ROW_NUMBER() OVER (PARTITION BY [IDPK], [CounterID] ORDER BY [CounterDate] desc)
  FROM [dbo].[TRCounterReg]) c join [ALLPK].[dbo].[MDCounter] a on a.IDPK = c.IDPK and a.CounterID = c.CounterId
  join [dbo].[VParking] p on p.ID = c.IDPK
  left join [dbo].[MDCounterConfig] b on b.IDPK = c.IDPK and b.CounterID = c.CounterId
where c.[index] = 1