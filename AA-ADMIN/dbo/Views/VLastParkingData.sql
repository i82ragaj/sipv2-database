
CREATE VIEW [dbo].[VLastParkingData] AS 
SELECT a.[ID]
      ,a.[Name]
      ,coalesce(z.[LastCountTotals], '1900-01-01') [LastCountTotals]
	  ,z.[LastCountTotalsStatus]
	  ,b.[DailyTrans]
	  ,b.[DailyTotalAmount]
	  ,c.[perc] ocupTotal
	  ,d.[perc] ocupAbo
	  ,e.[perc] ocupRot
  FROM [AA-ADMIN].[dbo].[MDParking] a join [AA-ADMIN].[dbo].[MDParkingStatus] z on a.ID = z.ID
  left join [AA-CONTO].[dbo].[VLastTotals] b on a.ID = b.IDPK
  left join [AA-CONTO].[dbo].[VLastOccupationTotal] c on a.ID = c.IDPK
  left join [AA-CONTO].[dbo].[VLastOccupationRotation] d on  a.ID = d.IDPK 
  left join [AA-CONTO].[dbo].[VLastOccupationSubscriber] e on a.ID = e.IDPK
  where a.Active = 1