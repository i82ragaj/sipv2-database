-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
--	@PKSRV: Vinculed server name of the origin data
-- Return: Nothing
-- Summary:	Truncate ZTables and insert data from origin between datafrom y dateto dates using [time] column

CREATE PROCEDURE [SD].[InsertZTables]
@PKSRV as varchar(10),
@DBNAME as varchar(10) = null,
@datefrom date = null,
@dateto date = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@datefrom is null)
		set @datefrom = cast(dateadd(dd, -7, getdate()) as date)

	if(@dateto is null)
		set @dateto = cast(getdate() as date);

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	declare @sql varchar(max);

	set @sql = '
	truncate table [' + @DBNAME + '].[tmp].[ZRevenueParkingTrans];
	truncate table [' + @DBNAME + '].[tmp].[ZRevenuePayments];
	truncate table [' + @DBNAME + '].[tmp].[ZRevenueSales];
	truncate table [' + @DBNAME + '].[tmp].[ZParkingTransWithoutTurnover];
	truncate table [' + @DBNAME + '].[tmp].[ZPaymentWithSkiDataValueCard];
	truncate table [' + @DBNAME + '].[tmp].[ZParkingMovements];
	truncate table [' + @DBNAME + '].[tmp].[ZContractParkerMovements];
	truncate table [' + @DBNAME + '].[tmp].[ZRevenueCreditEntriesIssued];
	truncate table [' + @DBNAME + '].[tmp].[ZRevenueCreditEntriesRedeemed];
	truncate table [' + @DBNAME + '].[tmp].[ZRevenueAmountCancellations];
	truncate table [' + @DBNAME + '].[tmp].[ZShifts];'
	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZRevenueParkingTrans]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[InvoiceNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[Revenue]
      ,[NetRevenue]
      ,[ArticleNo]
      ,[CCCompanyAbbr]
      ,[ElpCompanyAbbr]
      ,[ArticleCategory]
      ,[ArticleDesig]
      ,[ArticleAbbr]
      ,[CardNo]
      ,[CardNoMask]
      ,[ParkingDuration]
      ,[RateNo]
      ,[RateDesig]
      ,[Name]
      ,[Street]
      ,[City]
      ,[TaxCode]
      ,[VATNo]
      ,[VATDesig]
      ,'''' CreditCardMasked
      ,[' + @DBNAME + '].[dbo].GetUniqueTransNo([Time],[DeviceNo],[TransactionNo]) [TransactionNoCalc]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueParkingTrans]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZRevenuePayments]
	SELECT [PaymentType]
      ,[Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[Revenue]
      ,[InvoiceNo]
      ,[' + @DBNAME + '].[dbo].GetUniqueTransNo([Time], [DeviceNo], [TransactionNo]) [TransactionNoCalc]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenuePayments]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZRevenueSales]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[InvoiceNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[Revenue]
      ,[NetRevenue]
      ,[ArticleNo]
      ,[ArticleCategory]
      ,[ArticleDesig]
      ,[ArticleAbbr]
      ,[ValidFrom]
      ,[Expires]
      ,[StaffCodeSale]
      ,[RoomNumber]
      ,[FolioNumber]
      ,[GuestName]
      ,[PricePerDay]
      ,[CardNoFrom]
      ,[CardNoTo]
      ,[Name]
      ,[Street]
      ,[City]
      ,[TaxCode]
      ,[NoOfDays] 
      ,[' + @DBNAME + '].[dbo].GetUniqueTransNo([Time], [DeviceNo], [TransactionNo]) [TransactionNoCalc]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueSales]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZParkingTransWithoutTurnover]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[PaymentType]
      ,[Revenue]
      ,[NetRevenue]
      ,[ArticleNo]
      ,[CCCompanyAbbr]
      ,[ElpCompanyAbbr]
      ,[ArticleCategory]
      ,[ArticleDesig]
      ,[ArticleAbbr]
      ,[CardNo]
      ,[CardNoMask]
      ,[ParkingDuration]
      ,[RateNo]
      ,[RateDesig]
      ,[Name]
      ,[Street]
      ,[City]
      ,[TaxCode]
      ,[InvoiceNo]
      ,'''' CreditCardMasked
      ,[' + @DBNAME + '].[dbo].GetUniqueTransNo([Time], [DeviceNo], [TransactionNo]) [TransactionNoCalc]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[ParkingTransWithoutTurnover]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZParkingMovements]
	SELECT [Quantity]
      ,[Time]
      ,[MovementType]
      ,[FacilityNo]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[ArticleNo]
      ,[ArticleDesig]
      ,[ArticleAbbr]
      ,[Amount]
      ,[CurrencyOfAmount]
      ,[CardValue]
      ,[CurrencyOfCardValue]
      ,[CardRemainingValue]
      ,[AdditionalInfo]
      ,[CardNoMask]
      ,[CardNo]
      ,[CardValueType]
      ,[CurrencyRemainingValue]
      ,[RejectionNo]
      ,[RejectionDesig]
      ,[PlateNo]
      ,[PaidFrom]
      ,[MovementTypeDesig]
      ,[FacilityDesig]
      ,[FacilityAbbr] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[ParkingMovements]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZContractParkerMovements]
	SELECT [Quantity]
      ,[Time]
      ,[FacilityNo]
      ,[CustomerNo]
      ,[CustomerTitle]
      ,[CustomerSurname]
      ,[CustomerFirstName]
      ,[Street]
      ,[ZipCode]
      ,[City]
      ,[Country]
      ,[TaxCode]
      ,[IdDocumentNo]
      ,[Telephone]
      ,[RentalAgmtNo]
      ,[RentalAgmtBeginDate]
      ,[RentalAgmtTerminationDate]
      ,[Deposit]
      ,[MaximumLevel]
      ,[CurrentLevel]
      ,[CustomerRemarks]
      ,[CustomerRemarks2]
      ,[CustomerRemarks3]
      ,[CustomerDepartment]
      ,[CustomerEmail]
      ,[RentalAgmtIsBlocked]
      ,[RentalAgmtBlockedDate]
      ,[UserNo]
      ,[UserTitle]
      ,[UserSurname]
      ,[UserFirstName]
      ,[UserDateOfBirth]
      ,[UserSpaceNo]
      ,[UserRemarks]
      ,[UserRemarks2]
      ,[UserRemarks3]
      ,[UserDepartment]
      ,[UserEmail]
      ,[UserIdTag]
      ,[ArticleNo]
      ,[CardValidFrom]
      ,[CardValidUntil]
      ,[SuspendPeriodFrom]
      ,[SuspendPeriodUntil]
      ,[CardProductionStatus]
      ,[CardProductionReason]
      ,[CardIsNeutral]
      ,[CardIsSingleNeutral]
      ,[CardIsBlocked]
      ,[CardBlockedDate]
      ,[CardRemainingValue]
      ,[CurrencyRemainingValue]
      ,[CardType]
      ,[SerialNo]
      ,[CardNoMask]
      ,[ArticleDesig]
      ,[ArticleAbbr]
      ,[ArticleCategory]
      ,[CardNo]
      ,[MovementType]
      ,[MovementFacilityNo]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[Amount]
      ,[CurrencyOfAmount]
      ,[AdditionalInfo]
      ,[Nationality]
      ,[CardValueType]
      ,[RejectionNo]
      ,[RejectionDesig]
      ,[AccountingNo]
      ,[PaidFrom]
      ,[MovementTypeDesig]
      ,[FacilityDesig]
      ,[FacilityAbbr]
      ,'''' PlateNo
      ,'''' Vehicle
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[ContractParkerMovements]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZRevenueCreditEntriesIssued]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[Revenue]
      ,[NetRevenue] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueCreditEntriesIssued]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZRevenueCreditEntriesRedeemed]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[Revenue]
      ,[NetRevenue] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueCreditEntriesRedeemed]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZRevenueAmountCancellations]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[Revenue]
      ,[NetRevenue]
      ,[Remarks] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueAmountCancellations]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZPaymentWithSkiDataValueCard]
	SELECT [Quantity]
      ,[Time]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[TransactionNo]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[ArticleNo]
      ,[ArticleCategory]
      ,[ArticleDesig]
      ,[ArticleAbbr]
      ,[DebitValue]
      ,[CardValueType]
      ,[RateReduction]
      ,[RateReductionAliquot]
      ,[OpenAmount]
      ,[CardInvoiceNo]
      ,[CardProductionDate]
      ,[CardProductionFacilityNo]
      ,[InvoiceNo]
      ,'''' TicketType
      ,'''' CardKey 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[PaymentWithSkiDataValueCard]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[ZShifts]
	SELECT [ShiftNo]
      ,[Time]
      ,[ShiftStartupTime]
      ,[ShiftCloseTime]
      ,[IsOpen]
      ,[DeviceNo]
      ,[DeviceDesig]
      ,[DeviceAbbr]
      ,[DeviceType]
      ,[CarparkNo]
      ,[CarparkDesig]
      ,[CarparkAbbr]
      ,[StaffCode]
      ,[OperatorSurname]
      ,[OperatorFirstName]
      ,[SubstituteShiftNo]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[Shifts]
	WHERE CAST([Time] as date) >= ''' + convert(varchar, @datefrom, 112) + ''' and CAST([Time] as date) <=''' + convert(varchar, @dateto, 112) + '''';

	exec(@sql);


END
