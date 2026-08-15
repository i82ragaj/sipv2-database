CREATE VIEW [dbo].[VParkingTrans] AS 
SELECT a.[IDPK]
      ,cast(a.[ParkingTransTime] as Date) [Date]
	  ,SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]), 1) + 1, LEN(a.[InvoiceNo])) InvoiceNo
	  ,SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]) - 2, LEN(a.[InvoiceNo])), 2) Anno
	  ,convert(varchar(8), a.[ParkingTransTime], 112) + '$' + SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]), 1) + 1, LEN(a.[InvoiceNo])) InvoiceNoDate
      ,a.[Revenue]
	  ,a.[ParkingDuration]
	  ,a.[ParkingTransType]
	  ,a.[PaymentTypeID]
	  ,a.[ConceptTypeID]
  FROM [ALLPK].[dbo].[TRParkingTrans] a join [AA-ADMIN].[dbo].[MDParking] b on a.[IDPK] = b.[ID]
  where 
  (b.[type] = 'SD' and a.[ParkingTransType] = 'P') or 
  (b.[type] = 'MY' and a.[ParkingTransType] = 'P') or
  (b.[type] = 'EQ' and a.[PaymentTypeID] not in ('3','4','5') and a.[ConceptTypeID] not in ('4', '9', '13', '17'))