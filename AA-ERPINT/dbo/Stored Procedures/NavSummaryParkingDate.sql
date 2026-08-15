-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Execute summary parking on a date
-- =============================================
CREATE   PROCEDURE [dbo].[NavSummaryParkingDate]
@parkingId varchar(10),
@summaryDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @type varchar(10);
	declare @sql varchar(max) = '';
	declare @DocumentNo varchar(50);
	declare @SCType varchar(10) = null;
	declare @multiCounter int
	declare @RowNum int = 0;

	select @SCType = [type], @DocumentNo = convert(varchar(25), @summaryDate, 112) + '-' + [DACode] + '-01', @multiCounter = coalesce(MultiCounter, 0)
	from [dbo].[VParking] where ID = @parkingId;

	IF OBJECT_ID('#NavSummary') IS NOT NULL DROP TABLE #NavSummary
	IF OBJECT_ID('#ParkingTrans') IS NOT NULL DROP TABLE #ParkingTrans
	IF OBJECT_ID('#RevenuePayments') IS NOT NULL DROP TABLE #RevenuePayments
	IF OBJECT_ID('#RevenuePaymentsFilter') IS NOT NULL DROP TABLE #RevenuePayments
	IF OBJECT_ID('#Shifts') IS NOT NULL DROP TABLE #Shifts;
	IF OBJECT_ID('#NILTicket') IS NOT NULL DROP TABLE #NILTicket;
	IF OBJECT_ID('#PaymentWithValueCard') IS NOT NULL DROP TABLE #PaymentWithValueCard;

	SELECT * INTO #NavSummary from [dbo].[NavSummary] where 1 != 1

	SELECT * INTO #ParkingTrans
	FROM
		 (SELECT [IDPK], [ParkingTransTime], [InvoiceNo], [PaymentTypeId], [ConceptTypeId], [PaymentDeviceName], [ParkingTransType], [ArticleCode], [Remarks] [Description], [OperatorSurname], [OperatorName]
		 FROM [ALLPK].[dbo].[TRParkingTrans] 
		 where IDPK = @parkingId and CAST([ParkingTransTime] as date) = @summaryDate
		 UNION
		 SELECT [IDPK], [InvoiceTime], [InvoiceNo], [PaymentTypeId], [ConceptTypeId], [PaymentDeviceName], 'P' [TransType], [ArticleCode], '' [Description], [OperatorSurname], [OperatorName]
		 FROM [ALLPK].[dbo].[TRInvoice] 
		 where IDPK = @parkingId and CAST([InvoiceTime] as date) = @summaryDate) a 

	SELECT a.*, 
	convert(varchar(8), a.[PaymentTime], 112) + '$' + SUBSTRING(a.[InvoiceNo], COALESCE(CHARINDEX('/', a.[InvoiceNo]), 1) + 1, LEN(a.[InvoiceNo])) [InvoiceNoM] 
	INTO #RevenuePayments
	FROM [ALLPK].[dbo].[TRPayment]  a join [dbo].[VParking] b on a.[IDPK] = b.[ID]
	where IDPK = @parkingId and CAST([PaymentTime] as date) = @summaryDate

	select [IDPK], [ShiftCode], [DeviceID], [DeviceName], 
	case when [ShiftStartupTime] < @summaryDate then @summaryDate else [ShiftStartupTime] end  [ShiftStartupTime], 
	[ShiftCloseTime], [Time],
	'T' + cast(ROW_NUMBER() OVER(partition by [DeviceId] order by [DeviceName], [ShiftStartupTime]) as varchar(10)) ShiftsNo into #Shifts
	from
	(SELECT [IDPK], [ShiftCode], [DeviceID], [DeviceName], [ShiftStartupTime],
	   case when (ShiftTime = '2100-01-01') then DATEADD(DD, 1, cast([ShiftStartupTime] as date)) else ShiftTime end [Time]
      ,case when ([ShiftCloseTime] = '2100-01-01') then DATEADD(DD, 1, cast([ShiftStartupTime] as date)) else [ShiftCloseTime] end [ShiftCloseTime]
	FROM [ALLPK].[dbo].[TRShift]) a
	where IDPK = @parkingId
	and (cast(a.[ShiftStartupTime] as date) = @summaryDate or cast(a.[ShiftCloseTime] as date) = @summaryDate)

	--PAGOS FILTRADOS
	SELECT a.* INTO #RevenuePaymentsFilter
	FROM #RevenuePayments a join [dbo].[VParking] b on a.[IDPK] = b.[ID]
	where 
	(b.[type] = 'SD' and a.[ConceptTypeID] = 'P') or
	(b.[type] = 'MY' and ConceptTypeID = 'P') or 
	(b.[type] = 'EQ' and a.NOrder = 1 and a.[PaymentTypeID] not in ('3','4','5')  and a.[ConceptTypeID] not in ('4', '9', '8', '13', '17'))

	--CAJEROS y OTROS DISPOSITIVOS
	INSERT INTO #NavSummary ([IDPK], [SumaryDate], [DACode], [DocumentType], 
	[DocumentNo], [PaymentTypeCode], [LineNo], [LineDescription], 
	[Quantity], [Amount], [Alias], [MachineId])
	select @parkingId, @summaryDate, s.DACode, 'P', 
	@DocumentNo, PaymentTypeName, ROW_NUMBER() OVER(order by [DeviceName], [PaymentTypeName]), DeviceName + ' - ' + PaymentTypeName, 
	Quantity, Total, null, s.DeviceId
	from 
		(select b.DACode, a.DeviceId, a.DeviceName, COUNT(*) Quantity, sum(a.TotalRevenue) Total, c.PaymentTypeName 
		from #RevenuePaymentsFilter a join [dbo].[VParking] b on a.IDPK = b.ID
		join  [ALLPK].[dbo].[MDPaymentType] c on a.IDPK = c.IDPK and a.PaymentTypeID = c.PaymentTypeID and c.TransType = 'P'
		where ((a.DeviceType <> 0 and b.type = 'SD') or (a.DeviceType <> 4 and b.type = 'EQ'))
		group by b.DACode, a.DeviceId, a.DeviceName, c.PaymentTypeName) s

	select @RowNum = MAX([LineNo]) from #NavSummary

	--CAJAS MANUALES
	INSERT INTO #NavSummary ([IDPK], [SumaryDate], [DACode], [DocumentType], 
	[DocumentNo], [PaymentTypeCode], [LineNo], [LineDescription], 
	[Quantity], [Amount], [Alias], [MachineId])
	select @parkingId, @summaryDate, s.DACode, 'P', 
	@DocumentNo, PaymentTypeName, @RowNum + ROW_NUMBER() OVER(order by [DeviceName], [PaymentTypeName]), DeviceName + ' - ' + PaymentTypeName + ' - ' + ShiftsNo, 
	Quantity, Total, null, s.[DeviceId]
	from
		(select g.DACode, g.DeviceId, g.DeviceName, g.PaymentTypeName, SUM(g.TotalRevenue) [Total], COUNT(*) Quantity, ShiftsNo
		from
			(select b.DACode, a.DeviceID, a.DeviceName, a.TotalRevenue, c.PaymentTypeName, a.InvoiceNoM,
			coalesce((select top 1 ShiftsNo from #Shifts t where a.DeviceName = t.DeviceName and a.[PaymentTime] >= t.ShiftStartupTime and a.[PaymentTime] <= t.[ShiftCloseTime]), 'Sin turno') ShiftsNo
				from #RevenuePaymentsFilter a join [dbo].[VParking] b on a.IDPK = b.ID
				join [ALLPK].[dbo].[MDPaymentType] c on a.IDPK = c.IDPK and a.PaymentTypeID = c.PaymentTypeID and c.TransType = 'P'
				where ((a.DeviceType = 0 and b.type = 'SD') or (a.DeviceType = 4 and b.type = 'EQ'))) g

		group by g.DACode, g.DeviceId, g.DeviceName, g.PaymentTypeName, g.ShiftsNo) s

	select @RowNum = MAX([LineNo]) from #NavSummary

	select [description], COUNT(*) [Quantity] into #NILTicket from #ParkingTrans where 1 != 1 group by [description]

	if(@SCType = 'EQ') 
	begin
		insert into #NILTicket
		select [description], COUNT(*) [Quantity]
		from #ParkingTrans where [ConceptTypeID] = 8 and [Description] not like '{"stay_id"%'
		group by [description];
	end

	if(@SCType = 'SD') 
	begin
		insert into #NILTicket
		select [OperatorSurname] + ' ' + [OperatorName] as [description], COUNT(*) [Quantity] 
		from #ParkingTrans
		where  [ParkingTransType] = 'G' and [PaymentTypeID] = 1 and [ArticleCode] = 'TAL'
		group by [OperatorSurname] + ' ' + [OperatorName]
	end
	
	INSERT INTO #NavSummary ([IDPK], [SumaryDate], [DACode], [DocumentType], 
	[DocumentNo], [PaymentTypeCode], [LineNo], [LineDescription], 
	[Quantity], [Amount], [Alias], [MachineId], [TicketNoBegin], [TicketNoEnd])
	select @parkingId, @summaryDate, b.DACode, 'E', 
	@DocumentNo, null, @RowNum + ROW_NUMBER() OVER(order by [description]), a.[Description], 
	a.[Quantity], null, null, null, null, null
	from #NILTicket a join [dbo].[VParking] b on b.ID = @parkingId

	select @RowNum = MAX([LineNo]) from #NavSummary

	SELECT a.[ArticleName] [description], count(*) [Quantity] INTO #PaymentWithValueCard
	FROM [ALLPK].[dbo].[TRPayment] a join [dbo].[VParking] b on a.IDPK = b.ID
	where a.[IDPK] = @parkingId and CAST(a.[PaymentTime] as date) = @summaryDate 
	and 
	((b.[type] = 'SD' and a.[ConceptTypeID] = 'PVC') or 
	 (b.[type] = 'EQ' and a.[ConceptTypeID] = '6') or 
	 (b.[type] = 'MY' and a.[PaymentTypeID] = '4'))
	group by [ArticleName]

	INSERT INTO #NavSummary ([IDPK], [SumaryDate], [DACode], [DocumentType], 
	[DocumentNo], [PaymentTypeCode], [LineNo], [LineDescription], 
	[Quantity], [Amount], [Alias], [MachineId], [TicketNoBegin], [TicketNoEnd])
	select @parkingId, @summaryDate, b.DACode, 'T', 
	@DocumentNo, null, @RowNum + ROW_NUMBER() OVER(order by [description]), null, 
	a.[Quantity], null, a.[Description], null, null, null
	from #PaymentWithValueCard a join [dbo].[VParking] b on b.ID = @parkingId

	select @RowNum = MAX([LineNo]) from #NavSummary

	if(@multiCounter = 0)
		INSERT INTO #NavSummary ([IDPK], [SumaryDate], [DACode], [DocumentType], 
		[DocumentNo], [PaymentTypeCode], [LineNo], [LineDescription], 
		[Quantity], [Amount], [Alias], [MachineId], [TicketNoBegin], [TicketNoEnd])
		select @parkingId, @summaryDate, b.DACode, 'T', 
		@DocumentNo, null, @RowNum + 1, null, 
		null, Total, null, null,
		SUBSTRING(a.[TicketNoBegin], 10, len(a.[TicketNoBegin])) [TicketNoBegin], 
		SUBSTRING(a.[TicketNoEnd], 10, len(a.[TicketNoEnd])) [TicketNoEnd]
		from (select min(p.[InvoiceNoM]) [TicketNoBegin], max(p.[InvoiceNoM]) [TicketNoEnd], sum(TotalRevenue) Total
			  from #RevenuePaymentsFilter p) a, [dbo].[VParking] b
		where b.ID = @parkingId
	else
		INSERT INTO #NavSummary ([IDPK], [SumaryDate], [DACode], [DocumentType], 
		[DocumentNo], [PaymentTypeCode], [LineNo], [LineDescription], 
		[Quantity], [Amount], [Alias], [MachineId], [TicketNoBegin], [TicketNoEnd])
		select @parkingId, @summaryDate, b.DACode, 'T', 
		@DocumentNo, null, @RowNum + ROW_NUMBER() OVER(order by a.[DeviceName]), a.[DeviceName], 
		null, Total, null, a.[DeviceID], 
		SUBSTRING(a.[TicketNoBegin], 10, len(a.[TicketNoBegin])) [TicketNoBegin], 
		SUBSTRING(a.[TicketNoEnd], 10, len(a.[TicketNoEnd])) [TicketNoEnd]
		from (select p.[DeviceName], p.[DeviceID], min(p.[InvoiceNoM]) [TicketNoBegin], max(p.[InvoiceNoM]) [TicketNoEnd], sum(TotalRevenue) Total
			  from #RevenuePaymentsFilter p 
			  group by  p.[DeviceName], p.[DeviceID]) a, [dbo].[VParking] b
		where b.ID = @parkingId

	delete from [dbo].[NavSummary] where [IDPK] = @parkingId and [SumaryDate] = @summaryDate;
	insert into [dbo].[NavSummary] select * from #NavSummary

	
	--select * from #NavSummary order by [LineNo]
	--select * from #NILTicket
END