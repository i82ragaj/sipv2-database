


CREATE VIEW [dbo].[VSkidataCreditEntriesIssuedByDate] AS 
select a.[IDPK], cast([PaymentTime] as date) [Date], COUNT(*) [Operations], round(SUM(a.[TotalRevenue]), 2) Total
from [ALLPK].[dbo].[TRPayment] a left join [AA-ADMIN].[dbo].[MDParking] b on a.IDPK = b.ID
where [ConceptTypeID] = 'CEI'
group by a.[IDPK], cast([PaymentTime] as date)
