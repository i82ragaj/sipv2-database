


CREATE VIEW [dbo].[VParkingTransByDate] AS 
select a.[IDPK], a.[Date], COUNT(*) Operations, round(SUM(a.[Revenue]), 2) Total, SUM(ParkingDuration) [SumMinutes], MIN(InvoiceNoDate) InvoiceNoMin, MAX(InvoiceNoDate) InvoiceNoMax
from dbo.[VParkingTrans] a left join [AA-ADMIN].[dbo].[MDParking] b on a.IDPK = b.ID
group by a.[IDPK], a.[Date];
