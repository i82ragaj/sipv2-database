





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[GenerateParkingSummary]
AS
BEGIN
  

  drop table if exists [dbo].[ParkingSummaryTmp];
  drop table if exists [dbo].[ParkingSummaryDetailTmp];


  SELECT a.[IDPK]
      ,a.[Date] 
      ,a.[Operations]
      ,a.[Total]
      ,case when p.sii = 1 then SUBSTRING(a.[InvoiceNoMin], 10, len(a.[InvoiceNoMin])) else '-' end  InvoiceNoMin
      ,case when p.sii = 1 then SUBSTRING(a.[InvoiceNoMax], 10, len(a.[InvoiceNoMax])) else '-' end  InvoiceNoMax
	  ,coalesce(b.[Total], 0) [ParkingTransTotal]
	  ,coalesce(b.[Operations], 0) [ParkingTransNum]
	  ,coalesce(b.[SumMinutes], 0) [SumMinutes]
	  ,coalesce(c.[Total], 0) [InvoicesTotal]
	  ,coalesce(c.[Operations], 0) [InvoicesNum]
	  ,coalesce(d.[Total], 0) [ACATotal]
	  ,coalesce(d.[Operations], 0) [ACANum]
	  ,coalesce(e.[Total], 0) [CEITotal]
	  ,coalesce(e.[Operations], 0) [CEINum]
	  ,coalesce(h.[Total], 0)  [CERTotal]
	  ,coalesce(h.[Operations], 0) [CERNum] 
	  ,coalesce(f.[Total], 0) [CashTotal]
	  ,coalesce(f.[Operations], 0) [CashNum]
	  ,coalesce(g.[Total] , 0) [RestTotal]
	  ,coalesce(g.[Operations] , 0) [RestNum]
	  into [ParkingSummaryTmp]
  FROM [VAllOperationsByDate] a 
  left join [VParkingTransByDate] b on a.[IDPK] = b.[IDPK] and a.[Date] = b.[Date]
  left join [VInvoicesByDate] c on a.[IDPK] = c.[IDPK] and a.[Date] = c.[Date]
  left join [VSkidataAmountCancellationsByDate] d on a.[IDPK] = d.[IDPK] and a.[Date] = d.[Date]
  left join [VSkidataCreditEntriesIssuedByDate] e on a.[IDPK] = e.[IDPK] and a.[Date] = e.[Date]
  left join [VSkidataCreditEntriesRedeemedByDate] h on a.[IDPK] = h.[IDPK] and a.[Date] = h.[Date]
  left join [VPaymentsByDateCash] f on a.[IDPK] = f.[IDPK] and a.[Date] = f.[Date]
  left join [VPaymentsByDateRest] g on a.[IDPK] = g.[IDPK] and a.[Date] = g.[Date]
  left join [AA-ADMIN].[dbo].[MDParking] p on a.IDPK = p.ID


  SELECT a.[IDPK]
      ,a.[Date]
	  ,a.[PaymentTypeId]
      ,c.PaymentTypeName
      ,a.[Operations]
      ,a.[Total] Total
  into [ParkingSummaryDetailTmp]
  FROM [VPaymentsByDatePaymentType] a
  left join [ALLPK].[dbo].[MDPaymentType] c on c.[PaymentTypeID] = a.[PaymentTypeId] and c.[IDPK] = a.[IDPK] and c.[TransType] = 'P'
	
  drop table if exists [dbo].[ParkingSummary];
  drop table if exists [dbo].[ParkingSummaryDetail];

  EXEC sp_rename 'ParkingSummaryTmp', 'ParkingSummary';  
  EXEC sp_rename 'ParkingSummaryDetailTmp', 'ParkingSummaryDetail';  


END