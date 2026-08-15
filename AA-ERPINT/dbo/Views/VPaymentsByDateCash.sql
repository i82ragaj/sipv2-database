


CREATE VIEW [dbo].[VPaymentsByDateCash] AS 
select a.[IDPK], a.[Date], COUNT(*) [Operations], round(SUM(a.[TotalRevenue]), 2) Total
from [dbo].[VPayments] a left join [AA-ADMIN].[dbo].[MDParking] b on a.IDPK = b.ID
where (PaymentTypeId = '0' and b.type = 'EQ') or (PaymentTypeId = '1' and b.type = 'SD')
group by a.[IDPK], a.[Date]
