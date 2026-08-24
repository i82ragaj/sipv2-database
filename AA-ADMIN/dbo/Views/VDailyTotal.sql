
create view VDailyTotal as
SELECT [IDPK]
      ,[TotalDate]
      ,[DailyTotalAmount]
      ,[DailyTransWithPay]
      ,[DailyTransWithOutPay]
  FROM [AA-CONTO].[dbo].[TRDailyTotal]