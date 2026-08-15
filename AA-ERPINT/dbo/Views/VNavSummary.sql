

CREATE VIEW [dbo].[VNavSummary] as
SELECT a.[IDPK]
      ,b.[Name] [NombreParking] 
      ,b.[DACode] [Departamento]
      ,CAST(FORMAT(a.[SumaryDate], 'dd/MM/yyyy') as VARCHAR(12)) [FechaEmision] 
      ,a.[DocumentType] [TipoDocumento]
      ,a.[DocumentNo] [NoDocumento]
      ,a.[PaymentTypeCode] [FormaPago]
      ,a.[LineNo] [LineaNo]
      ,a.[LineDescription] [Expendedor]
      ,a.[Quantity] [Cantidad]
      ,a.[Amount] [Total]
      ,a.[Alias]
      ,a.[MachineId] [Dispositivo]
      ,a.[TicketNoBegin] [FacturaSimplificadaDesde]
      ,a.[TicketNoEnd] [FacturaSimplificadaHasta]
      ,a.[SumaryDate]
      ,b.[Company]
  FROM [AA-ERPINT].[dbo].[NavSummary] a
  join [AA-ADMIN].[dbo].[MDParking] b on a.[IDPK] = b.[ID]