



CREATE VIEW [dbo].[VParkingSummaryDetail] as
SELECT IDPK + '_' + CAST([Date] as varchar) + '_' + COALESCE(CAST([PaymentTypeId] as varchar), 'NULL') ID
      ,IDPK +'_' + CAST([Date] as varchar) IDSummary
      ,[IDPK]
      ,[Date]
      ,[PaymentTypeId]
      ,[PaymentTypeName]
      ,[Operations]
      ,[Total]
      ,NULL Discount
  FROM [AA-ERPINT].[dbo].[ParkingSummaryDetail]