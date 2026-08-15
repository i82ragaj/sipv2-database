

CREATE VIEW [dbo].[VAllOperationsByDate] AS 
SELECT a.[IDPK],a.[Date],SUM(a.[Operations]) [Operations],SUM(a.[Total]) [Total], MIN([InvoiceNoMin]) [InvoiceNoMin], MAX([InvoiceNoMax]) [InvoiceNoMax] 
FROM 
(SELECT [IDPK],[Date],[Operations],[Total],[InvoiceNoMin],[InvoiceNoMax] FROM [dbo].[VParkingTransByDate]
union
SELECT [IDPK],[Date],[Operations],[Total],NULL,NULL FROM [dbo].[VInvoicesByDate]
union
SELECT [IDPK],[Date],[Operations],[Total],NULL,NULL FROM [dbo].[VSkidataAmountCancellationsByDate]
union
SELECT [IDPK],[Date],[Operations],[Total],NULL,NULL FROM [dbo].[VSkidataCreditEntriesIssuedByDate]
union
SELECT [IDPK],[Date],[Operations],[Total],NULL,NULL FROM [dbo].[VSkidataCreditEntriesRedeemedByDate]
) a
GROUP BY a.[IDPK],a.[Date]
