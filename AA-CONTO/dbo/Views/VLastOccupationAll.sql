




CREATE VIEW [dbo].[VLastOccupationAll] AS 
select a.IDPK, a.CounterID, a.Capacity, a.CurrentLevel, a.updated, round((cast(a.CurrentLevel as decimal(6,2)) / cast(a.Capacity as decimal(6,2))) * 100, 2) Perc
from
(SELECT [IDPK]
      ,[CounterID]
      ,[CurrentLevel]
      ,case when [Capacity] is null or [Capacity] = 0 then 1 else [Capacity] end Capacity
      ,Updated
	  ,[index] = ROW_NUMBER() OVER (PARTITION BY [IDPK], [CounterID] ORDER BY [CounterDate] desc)
  FROM [dbo].[TRCounterReg]) a
where a.[index] = 1