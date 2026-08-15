




CREATE VIEW [dbo].[VInvoices] AS 
SELECT a.[IDPK]
      ,cast(a.[InvoiceTime] as Date) [Date]
	  ,SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]), 1) + 1, LEN(a.[InvoiceNo])) InvoiceNo
	  ,SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]) - 2, LEN(a.[InvoiceNo])), 2) Anno
	  ,CONVERT(varchar(8), a.[InvoiceTime], 112) + '$' + SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]), 1) + 1, LEN(a.[InvoiceNo])) InvoiceNoDate
      ,a.[Revenue]
	  ,a.[PaymentTypeID]
	  ,a.[ConceptTypeID]
  FROM [ALLPK].[dbo].[TRInvoice] a
