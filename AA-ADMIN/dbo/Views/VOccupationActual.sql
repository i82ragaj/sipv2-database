

CREATE VIEW [dbo].[VOccupationActual] AS 
SELECT a.[IDPK] + '-' + a.[CounterID] [CounterID]
      ,a.[IDPK] [ParkingId]
      ,b.[Name] [ParkingName]
      ,a.[CounterID] [CounterCode]
      ,a.[CounterName]      
      ,a.[SCType] [ControlSystem]
      ,a.[Capacity]
      ,a.[CurrentLevel]
      ,a.[Perc]
      ,a.[Updated]
  FROM [AA-CONTO].[dbo].[VLastOccupationTotal] a join [dbo].[MDParking] b on a.[IDPK] = b.[ID]