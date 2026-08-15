


CREATE VIEW [dbo].[VPaymentsByDatePaymentType] AS 
select a.[IDPK], a.[Date], a.[PaymentTypeID], COUNT(*) [Operations], round(SUM(a.[TotalRevenue]), 2) Total
from [dbo].[VPayments] a left join [AA-ADMIN].[dbo].[MDParking] b on a.IDPK = b.ID
group by a.[IDPK], a.[Date], a.[PaymentTypeID]
