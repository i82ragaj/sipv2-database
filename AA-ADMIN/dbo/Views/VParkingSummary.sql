


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
      ,null [DiscountTotal]
      ,null [DiscountNum]
  FROM [AA-ERPINT].[dbo].[ParkingSummary]