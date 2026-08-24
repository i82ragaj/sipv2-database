


CREATE VIEW [dbo].[VParkingSummary] AS
SELECT [IDPK] + '_' + CAST([Date] as varchar) ID 
      ,[IDPK]
      ,[Date]
      ,[Operations]
      ,[Total]
      ,[InvoiceNoMin]
      ,[InvoiceNoMax]
      ,[ParkingTransTotal]
      ,[ParkingTransNum]
      ,[SumMinutes]
      ,[InvoicesTotal]
      ,[InvoicesNum]
      ,[ACATotal]
      ,[ACANum]
      ,[CEITotal]
      ,[CEINum]
      ,[CERTotal]
      ,[CERNum]
      ,[CashTotal]
      ,[CashNum]
      ,[RestTotal]
      ,[RestNum]
  FROM [AA-ERPINT].[dbo].[ParkingSummary]