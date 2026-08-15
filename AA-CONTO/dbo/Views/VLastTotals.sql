
CREATE VIEW [dbo].[VLastTotals] AS 
select a.IDPK, a.DailyTrans, a.DailyTotalAmount
from
(SELECT [IDPK]
      ,[DailyTransWithPay] + [DailyTransWithOutPay] DailyTrans 
	  ,DailyTotalAmount
	  ,indice = ROW_NUMBER() OVER (PARTITION BY [IDPK] ORDER BY [TotalDate] desc)
  FROM [dbo].[TRDailyTotal] ) a
where a.indice = 1