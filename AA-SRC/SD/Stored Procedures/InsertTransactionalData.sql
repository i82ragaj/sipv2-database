-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
--  @datefrom: Date from which the data will be insert
-- Return: Nothing
-- Summary:	Execute the daily process for a parking
-- =============================================
CREATE  PROCEDURE [SD].[InsertTransactionalData]
@DBNAME as varchar(10) = null,
@datefrom as date = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	if @datefrom is null
		set @datefrom = dateadd(dd, -1, getdate())

	declare @sql varchar(max);

	--Truncate temporary tables
	set @sql = '
	truncate table [' + @DBNAME + '].[tmp].[ParkingTransTmp];
	truncate table [' + @DBNAME + '].[tmp].[MovementsTmp]'
	EXEC(@sql)
	
	set @sql = '
	delete from [' + @DBNAME + '].[dbo].[TRParkingTrans] where [ParkingTransTime] >= ''' + convert(varchar, @datefrom, 112) + '''';
	EXEC(@sql)

	set @sql = '
	delete from [' + @DBNAME + '].[dbo].[TRInvoice] where [InvoiceTime] >= ''' + convert(varchar, @datefrom, 112) + '''';
	EXEC(@sql)

	set @sql = '
	delete from [' + @DBNAME + '].[dbo].[TRMovement] where [MovementTime] >= ''' + convert(varchar, @datefrom, 112) + '''';
	EXEC(@sql)

	set @sql = '
	delete from [' + @DBNAME + '].[dbo].[TRPayment] where [PaymentTime] >= ''' + convert(varchar, @datefrom, 112) + '''';
	EXEC(@sql)


	--Insert parking trans in temporary table
	set @sql = 'INSERT INTO [' + @DBNAME + '].[tmp].[ParkingTransTmp]
           ([ID]
           ,[TransType]
           ,[ArticleType]
           ,[Time]
		   ,[TransactionNo]
		   ,[InvoiceNo]
           ,[Revenue]
		   ,[NetRevenue]
		   ,[ParkingDuration]
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
           ,[ArticleNo]
           ,[ArticleCategory]
           ,[ArticleDesig]
           ,[ArticleAbbr]
           ,[CCCompanyAbbr]
           ,[ElpCompanyAbbr]
           ,[CardNo]
           ,[CardNoMask]
           ,[RateNo]
           ,[RateDesig]
           ,[Name]
           ,[Street]
           ,[City]
           ,[TaxCode]
		   ,[PaymentType]
           ,[VATNo]
           ,[VATDesig]
		   ,[Inserted])
		SELECT [TransactionNoCalc] ID, ''P'' as TransType, a.ArticleType,
		t.[Time], t.[TransactionNo], t.[InvoiceNo], t.[Revenue], t.[NetRevenue], t.[ParkingDuration],
		t.[DeviceNo],t.[DeviceDesig],t.[DeviceAbbr],t.[DeviceType],t.[CarparkNo],t.[CarparkDesig],t.[CarparkAbbr],
		t.[StaffCode],t.[OperatorSurname],t.[OperatorFirstName],t.[ArticleNo],t.[ArticleCategory],t.[ArticleDesig],t.[ArticleAbbr],
		t.[CCCompanyAbbr],t.[ElpCompanyAbbr],t.[CardNo],t.[CardNoMask],
		t.[RateNo],t.[RateDesig],t.[Name],t.[Street],t.[City],t.[TaxCode],
		NULL as [PaymentType],t.[VATNo],t.[VATDesig],getdate()
		from [' + @DBNAME + '].[tmp].[ZRevenueParkingTrans] t join [' + @DBNAME + '].[dbo].[MDArticle] a on t.ArticleNo = a.ArticleId
		where not exists (select 1 from [' + @DBNAME + '].[dbo].[TRParkingTrans] h where [ParkingTransID] = t.[TransactionNoCalc]) 
		union
		SELECT [TransactionNoCalc] ID, ''G'' as TransType, a.ArticleType,
		t.[Time], t.[TransactionNo], t.[InvoiceNo], t.[Revenue], t.[NetRevenue], t.[ParkingDuration],
		t.[DeviceNo],t.[DeviceDesig],t.[DeviceAbbr],t.[DeviceType],t.[CarparkNo],t.[CarparkDesig],t.[CarparkAbbr],
		t.[StaffCode],t.[OperatorSurname],t.[OperatorFirstName],t.[ArticleNo],t.[ArticleCategory],t.[ArticleDesig],t.[ArticleAbbr],
		t.[CCCompanyAbbr],t.[ElpCompanyAbbr],t.[CardNo],t.[CardNoMask],
		t.[RateNo],t.[RateDesig],t.[Name],t.[Street],t.[City],t.[TaxCode],
		t.[PaymentType], NULL [VATNo], '''' [VATDesig],getdate()
		from [' + @DBNAME + '].[tmp].[ZParkingTransWithoutTurnover] t join [' + @DBNAME + '].[dbo].[MDArticle] a on t.ArticleNo = a.ArticleId
		where not exists (select 1 from [' + @DBNAME + '].[dbo].[TRParkingTrans] h where [ParkingTransID] = t.[TransactionNoCalc])' 
		EXEC(@sql)
		
		--Update payment type for normal payments
		set @sql = '
		UPDATE [' + @DBNAME + '].[tmp].[ParkingTransTmp]
		SET [PaymentType] = p.[PaymentType]
		FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp] i,  [' + @DBNAME + '].[tmp].[ZRevenuePayments] p
		WHERE i.[ID] = p.[TransactionNoCalc]'
		
		EXEC(@sql)

		--Update payment type for skidata value car
		set @sql = '
		UPDATE [' + @DBNAME + '].[tmp].[ParkingTransTmp]
		SET [PaymentType] = 7
		FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp] i, [' + @DBNAME + '].[tmp].[ZPaymentWithSkiDataValueCard] p
		WHERE i.[ID] = [' + @DBNAME + '].[dbo].GetUniqueTransNo(p.[Time], p.[DeviceNo], p.[TransactionNo])
		and i.[PaymentType] is null'
		
		EXEC(@sql)


		--Insert in temporary table all parking movements
		set @sql = '
		INSERT INTO  [' + @DBNAME + '].[tmp].[MovementsTmp]
		(
		[Time]
		,[CardNo]
		,[MovementType]
		,[ArticleType]
		,[DeviceNo]
		,[DeviceDesig]
		,[ArticleNo]
		,[ArticleDesig]
		,[ArticleAbbr]
		,[Amount]
		,[CurrencyOfAmount]
		,[CardRemainingValue]
		,[AdditionalInfo]
		,[CardNoMask]
		,[CardValueType]
		,[CurrencyRemainingValue]
		,[RejectionNo]
		,[RejectionDesig]
		,[PlateNo]
		)
		SELECT A.* FROM
		(SELECT [Time]
			  ,[CardNo]
			  ,[MovementType]
			  ,''R'' [ArticleType]
			  ,[DeviceNo]
			  ,[DeviceDesig]
			  ,[ArticleNo]
			  ,[ArticleDesig]
			  ,[ArticleAbbr]
			  ,[Amount]
			  ,[CurrencyOfAmount]
			  ,[CardRemainingValue]
			  ,[AdditionalInfo]
			  ,[CardNoMask]
			  ,[CardValueType]
			  ,[CurrencyRemainingValue]
			  ,[RejectionNo]
			  ,[RejectionDesig]
			  ,[PlateNo]
		  FROM [' + @DBNAME + '].[tmp].[ZParkingMovements] where CardNo in (select [CardNo] from [' + @DBNAME + '].[tmp].[ParkingTransTmp])
		  UNION 
		  SELECT [Time]
			  ,[CardNo]
			  ,[MovementType]
			  ,''A'' [ArticleType]
			  ,[DeviceNo]
			  ,[DeviceDesig]
			  ,[ArticleNo]
			  ,[ArticleDesig]
			  ,[ArticleAbbr]
			  ,[Amount]
			  ,[CurrencyOfAmount]
			  ,[CardRemainingValue]
			  ,[AdditionalInfo]
			  ,[CardNoMask]
			  ,[CardValueType]
			  ,[CurrencyRemainingValue]
			  ,[RejectionNo]
			  ,[RejectionDesig]
			  ,NULL
		  FROM [' + @DBNAME + '].[tmp].[ZContractParkerMovements] where CardNo in (select [CardNo] from [' + @DBNAME + '].[tmp].[ParkingTransTmp])
		  ) A'
		EXEC(@sql)
		
		--Update temporaly table's data about entry and exit
		set @sql = '
		DECLARE @Trans_ID nvarchar(24), @Trans_Time datetime, @Trans_CardNo nvarchar(30), @Trans_ArticleType nvarchar(1),
		@Trans_Time_IN datetime, @Trans_DeviceNo_IN smallint, @Trans_DeviceDesig_IN  nvarchar(25), @Trans_Plate_IN nvarchar(20),
		@Trans_Time_OUT datetime, @Trans_DeviceNo_OUT smallint, @Trans_DeviceDesig_OUT  nvarchar(25), @Trans_Plate_OUT nvarchar(20);
		DECLARE Trans_Cursor CURSOR READ_ONLY FOR
		SELECT [ID], [Time], [CardNo], [ArticleType]   
		FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp];
		
		
		OPEN Trans_Cursor  
		FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @Trans_Time_IN = NULL, @Trans_DeviceNo_IN = NULL, @Trans_DeviceDesig_IN = NULL, @Trans_Plate_IN  = NULL
			select @Trans_Time_OUT = NULL, @Trans_DeviceNo_OUT = NULL, @Trans_DeviceDesig_OUT = NULL, @Trans_Plate_OUT  = NULL
			SELECT TOP 1 @Trans_Time_IN = [Time], @Trans_DeviceNo_IN = [DeviceNo], @Trans_DeviceDesig_IN = [DeviceDesig], @Trans_Plate_IN = [PlateNo]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [CardNo] = @Trans_CardNo AND [MovementType] = 0 AND [ArticleType] = @Trans_ArticleType AND
			[Time] = (SELECT MAX([Time]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [CardNo] = @Trans_CardNo
								AND [Time] <= @Trans_Time
								AND [MovementType] = 0)
			
			SELECT TOP 1 @Trans_Time_OUT = [Time], @Trans_DeviceNo_OUT = [DeviceNo], @Trans_DeviceDesig_OUT = [DeviceDesig], @Trans_Plate_OUT = [PlateNo]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [CardNo] = @Trans_CardNo AND [MovementType] = 4 AND [ArticleType] = @Trans_ArticleType AND
			[Time] = (SELECT MIN([Time]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [CardNo] = @Trans_CardNo
								AND [Time] >= dateadd(ss, -10, @Trans_Time) 
								AND [MovementType] = 4)
			UPDATE [' + @DBNAME + '].[tmp].[ParkingTransTmp]
			set Time_IN = @Trans_Time_IN,
			DeviceNo_IN = @Trans_DeviceNo_IN,
			DeviceDesign_IN = @Trans_DeviceDesig_IN,
			PlateNo_IN = @Trans_Plate_IN,
			Time_OUT = @Trans_Time_OUT,
			DeviceNo_OUT = @Trans_DeviceNo_OUT,
			DeviceDesign_OUT = @Trans_DeviceDesig_OUT,
			PlateNo_OUT = @Trans_Plate_OUT
			where ID = @Trans_ID;
			FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleType
		END 
		CLOSE Trans_Cursor  
		DEALLOCATE Trans_Cursor'
		EXEC(@sql)

		--Adapt and copy transactions from temporary table to final transactions table
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRParkingTrans]
           ([ParkingTransID]
           ,[ParkingTransTime]
           ,[ParkingTransType]
           ,[PaymentDeviceID]
           ,[PaymentDeviceCode]
           ,[PaymentDeviceName]
           ,[PaymentDeviceTypeID]
           ,[OperatorID]
           ,[OperatorName]
           ,[OperatorSurname]
           ,[ArticleID]
           ,[ArticleCode]
           ,[ArticleName]
           ,[ArticleCategory]
           ,[ArticleType]
           ,[SerialNo]
           ,[EntryTime]
           ,[EntryDeviceID]
           ,[EntryDeviceName]
           ,[EntryPlate]
           ,[ExitTime]
           ,[ExitDeviceID]
           ,[ExitDeviceName]
           ,[ExitPlate]
           ,[ParkingDuration]
           ,[RateNo]
           ,[RateName]
           ,[TransactionNo]
           ,[InvoiceNo]
           ,[Revenue]
           ,[NetRevenue]
           ,[RevenueExt]
           ,[TaxId]
           ,[TaxName]
           ,[PaymentTypeID]
           ,[ConceptTypeID]
           ,[Remarks]
           ,[Inserted])
        SELECT  cast([ID] as varchar(50))
           ,[Time]
           ,[TransType]
           ,cast([DeviceNo] as varchar(40))
           ,cast([DeviceAbbr] as  varchar(10))
           ,cast([DeviceDesig] as nvarchar(50))
           ,cast([DeviceType] as varchar(40))
           ,cast([StaffCode] as varchar(40))
           ,cast([OperatorFirstName] as nvarchar(50))
           ,cast([OperatorSurname] as nvarchar(50))
           ,cast([ArticleNo] as varchar(40))
           ,cast([ArticleAbbr] as nvarchar(10))
           ,cast([ArticleDesig] as nvarchar(50))
           ,cast([ArticleCategory] as nvarchar(50))
           ,cast([ArticleType] as varchar(10))
           ,cast([CardNo] as varchar(50))
           ,[Time_IN]
           ,cast([DeviceNo_IN] as varchar(40))
           ,cast([DeviceDesign_IN] as nvarchar(50))
           ,cast([PlateNo_IN] as nvarchar(20))
           ,[Time_OUT]
           ,cast([DeviceNo_OUT] as varchar(40))
           ,cast([DeviceDesign_OUT] as nvarchar(50))
           ,cast([PlateNo_OUT] as nvarchar(20))
           ,[ParkingDuration]
           ,cast([RateNo] as varchar(40))
           ,cast([RateDesig] as nvarchar(50))
           ,cast([TransactionNo] as varchar(20))
           ,case when InvoiceNo > 0 then cast([InvoiceNo] as varchar(20)) else null end [InvoiceNo]
           ,cast([Revenue] as decimal(18,4))
           ,cast([NetRevenue] as decimal(18,4))
           ,cast([RevenueExt] as decimal(18,4))
           ,cast([VATNo] as varchar(40))
           ,cast([VATDesig] as nvarchar(50))
           ,cast([PaymentType] as varchar(40))
           ,cast([ConceptType] as varchar(40))
           ,cast([Description] as nvarchar(100))
           ,[Inserted]
		 FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp]'
		
		EXEC(@sql)

	
		--Adapt and copy invoices
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRInvoice]
            ([InvoiceID]
           ,[InvoiceTime]
           ,[PaymentDeviceID]
           ,[PaymentDeviceCode]
           ,[PaymentDeviceName]
           ,[PaymentDeviceTypeID]
           ,[OperatorID]
           ,[OperatorName]           
           ,[OperatorSurname]
           ,[ArticleID]
           ,[ArticleCode]
           ,[ArticleName]
           ,[ArticleCategory]
           ,[Quantity]
           ,[ValidFrom]
           ,[SerialNoFrom]
           ,[SerialNoTo]
           ,[Expires]
           ,[NoOfDays]
           ,[TransactionNo]
           ,[InvoiceNo]
           ,[Revenue]
           ,[NetRevenue]
           ,[TaxId]
           ,[TaxName]
           ,[PaymentTypeID]
           ,[ConceptTypeID]
           ,[Remarks]           
           ,[VATID]
           ,[Name]
           ,[Address]
           ,[City]
           ,[Country]
           ,[Inserted])
        SELECT 
		    RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([InvoiceNo] as varchar(10))  + ''/'' +
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([InvoiceNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
           ,[Time]
           ,cast([DeviceNo] as varchar(40))
           ,cast([DeviceAbbr] as  varchar(10))
           ,cast([DeviceDesig] as nvarchar(50))
           ,cast([DeviceType] as varchar(40))
           ,cast([StaffCode] as varchar(40))
           ,cast([OperatorFirstName] as nvarchar(50))
           ,cast([OperatorSurname] as nvarchar(50))
           ,cast([ArticleNo] as varchar(40))
           ,cast([ArticleAbbr] as nvarchar(10))
           ,cast([ArticleDesig] as nvarchar(50))          
           ,cast([ArticleCategory] as nvarchar(50))
           ,[Quantity]
           ,[ValidFrom]
           ,cast([CardNoFrom] as varchar(30))
           ,cast([CardNoTo] as varchar(30))
           ,[Expires]
           ,[NoOfDays]
           ,cast([TransactionNo] as varchar(20))
           ,case when InvoiceNo > 0 then cast([InvoiceNo] as varchar(20)) else null end [InvoiceNo]
           ,cast([Revenue] as decimal(18,4))
           ,cast([NetRevenue] as decimal(18,4))
           ,null [VATNo]
           ,null [VATDesig]
           ,null [PaymentTypeID]
           ,null [ConceptTypeID]
           ,null [Remarks]          
           ,cast([TaxCode] as varchar(40))
           ,cast([Name] as varchar(100))
           ,cast([Street] as varchar(100))
           ,cast([City] as varchar(25))
           ,null [Country]
           ,getdate()
		FROM [' + @DBNAME + '].[tmp].[ZRevenueSales]'
		
		EXEC(@sql)

		--Set payment type to invoices using payment temporary table
		set @sql = '
		UPDATE [' + @DBNAME + '].[dbo].[TRInvoice]
		SET [PaymentTypeId] = p.[PaymentType]
		FROM [' + @DBNAME + '].[dbo].[TRInvoice] i, [' + @DBNAME + '].[tmp].[ZRevenuePayments] p
		WHERE [' + @DBNAME + '].[dbo].GetUniqueTransNo(i.[InvoiceTime], i.[PaymentDeviceID], i.[TransactionNo]) = p.[TransactionNoCalc]'

		EXEC(@sql)

		--Adapt and copy all parkings movements
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRMovement]
			([MovementID]
           ,[MovementTime]
           ,[MovementType]
           ,[DeviceID]
           ,[DeviceName]
           ,[ArticleID]
           ,[ArticleCode]
           ,[ArticleName]
           ,[Amount]
           ,[SerialNo]
           ,[PlateNo]
           ,[Inserted])
			SELECT 
			RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + SUBSTRING([CardNo], len([CardNo]) - 5, 6)  + ''/'' +
			cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + SUBSTRING(CardNo, len(CardNo) - 5, 6) ORDER BY [time] ASC) AS varchar(5)) [ID]
			,[Time]
			,[MovementType]
            ,cast([DeviceNo] as varchar(40))
            ,cast([DeviceDesig] as nvarchar(50))
			,cast([ArticleNo] as varchar(40))
            ,cast([ArticleAbbr] as nvarchar(10))
            ,cast([ArticleDesig] as nvarchar(50)) 
			,cast([Amount] as decimal(18,4))
            ,cast([CardNo] as varchar(50))
            ,cast([PlateNo] as nvarchar(20))
			,getdate()
			FROM [' + @DBNAME + '].[tmp].[ZParkingMovements]
				UNION 
			SELECT 
			RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + SUBSTRING([CardNo], len([CardNo]) - 5, 6)  + ''/'' +
			cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + SUBSTRING(CardNo, len(CardNo) - 5, 6) ORDER BY [time] ASC) AS varchar(5)) [ID]
			,[Time]
			,[MovementType]
            ,cast([DeviceNo] as varchar(40))
            ,cast([DeviceDesig] as nvarchar(50))
			,cast([ArticleNo] as varchar(40))
            ,cast([ArticleAbbr] as nvarchar(10))
            ,cast([ArticleDesig] as nvarchar(50)) 
			,cast([Amount] as decimal(18,4))
            ,cast([CardNo] as varchar(50))
            ,cast([PlateNo] as nvarchar(20))
			,getdate()
			FROM [' + @DBNAME + '].[tmp].[ZContractParkerMovements]'
		
		EXEC(@sql)

		--Adapt and copy payments
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRPayment]
           ([PaymentID]
            ,[PaymentTime]
            ,[PaymentTypeID]
            ,[ConceptTypeID]
            ,[DeviceID]
            ,[DeviceCode]
            ,[DeviceName]
            ,[DeviceType]
            ,[OperatorID]
            ,[OperatorName]
            ,[OperatorSurname]
			,[NOrder]
            ,[Quantity]
            ,[Revenue]
			,[LineRevenue]
			,[TotalRevenue]
            ,[TransactionNo]
            ,[InvoiceNo]
            ,[Inserted])
			SELECT 
            RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([InvoiceNo] as varchar(10))  + ''/'' +
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([InvoiceNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
           ,[Time]
		   ,[PaymentType]
           ,''P''
           ,cast([DeviceNo] as varchar(40))
           ,cast([DeviceAbbr] as  varchar(10))
           ,cast([DeviceDesig] as nvarchar(50))
           ,cast([DeviceType] as varchar(40))
           ,cast([StaffCode] as varchar(40))
           ,cast([OperatorFirstName] as nvarchar(50))
           ,cast([OperatorSurname] as nvarchar(50))
		   ,1
           ,[Quantity]
           ,[Revenue]
           ,[Revenue]
		   ,[Revenue]
		   ,cast([TransactionNo] as varchar(20))
           ,case when InvoiceNo > 0 then cast([InvoiceNo] as varchar(20)) else null end [InvoiceNo]
           ,getdate()
			FROM [' + @DBNAME + '].[tmp].[ZRevenuePayments]'

		EXEC(@sql)
		
		--Adapt and copy other payments types
		set @sql = 'INSERT INTO [' + @DBNAME + '].[dbo].[TRPayment] (PaymentID, PaymentTime, PaymentTypeID, ConceptTypeID, DeviceID, DeviceCode, DeviceName, DeviceType, OperatorID, OperatorName, OperatorSurname, Norder, Quantity, Revenue, LineRevenue, TotalRevenue, TransactionNo, InvoiceNo, Remarks, SerialNo, ArticleID, ArticleCode, ArticleName, ArticleCategory)
		SELECT 	RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10))  + ''/'' +
		  cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
		  , Time, CONVERT(varchar(40), ''E''), CONVERT(varchar(40), ''CEI''), CONVERT(varchar(40), DeviceNo), CONVERT(varchar(10), DeviceAbbr), DeviceDesig, CONVERT(varchar(40), DeviceType), CONVERT(varchar(40), StaffCode), OperatorFirstName, OperatorSurname, 1, Quantity, CONVERT(decimal(18, 4), Revenue), CONVERT(decimal(18, 4), Revenue), CONVERT(decimal(18, 4), Revenue), CONVERT(varchar(20), TransactionNo), CONVERT(varchar(20), null), null, null, null, null, null, null 
		FROM [' + @DBNAME + '].[tmp].[ZRevenueCreditEntriesIssued]
		UNION
		SELECT 	RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10))  + ''/'' +
		  cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
		  , Time, CONVERT(varchar(40), ''E''), CONVERT(varchar(40), ''CER''), CONVERT(varchar(40), DeviceNo), CONVERT(varchar(10), DeviceAbbr), DeviceDesig, CONVERT(varchar(40), DeviceType), CONVERT(varchar(40), StaffCode), OperatorFirstName, OperatorSurname, 1, Quantity, CONVERT(decimal(18, 4), Revenue), CONVERT(decimal(18, 4), Revenue), CONVERT(decimal(18, 4), Revenue), CONVERT(varchar(20), TransactionNo), CONVERT(varchar(20), null), null, null, null, null, null, null 
		  FROM [' + @DBNAME + '].[tmp].[ZRevenueCreditEntriesRedeemed]
		UNION
		SELECT RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10))  + ''/'' +
		  cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
		  , Time, CONVERT(varchar(40), ''E''), CONVERT(varchar(40), ''ACA''), CONVERT(varchar(40), DeviceNo), CONVERT(varchar(10), DeviceAbbr), DeviceDesig, CONVERT(varchar(40), DeviceType), CONVERT(varchar(40), StaffCode), OperatorFirstName, OperatorSurname, 1, Quantity, CONVERT(decimal(18, 4), Revenue), CONVERT(decimal(18, 4), Revenue), CONVERT(decimal(18, 4), Revenue), CONVERT(varchar(20), TransactionNo), CONVERT(varchar(20), null), Remarks, null, null, null, null, null 
		FROM [' + @DBNAME + '].[tmp].[ZRevenueAmountCancellations]
		UNION
		SELECT RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10))  + ''/'' +
		  cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([TransactionNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
		, Time, CONVERT(varchar(40), ''E''), CONVERT(varchar(40), ''PVC''), CONVERT(varchar(40), DeviceNo), CONVERT(varchar(10), DeviceAbbr), DeviceDesig, CONVERT(varchar(40), DeviceType), CONVERT(varchar(40), StaffCode), OperatorFirstName, OperatorSurname, 1, Quantity, CONVERT(decimal(18, 4), DebitValue), CONVERT(decimal(18, 4), RateReduction), CONVERT(decimal(18, 4), OpenAmount), CONVERT(varchar(20), TransactionNo), CONVERT(varchar(20), InvoiceNo), null, CardKey, ArticleNo, ArticleAbbr, ArticleDesig, ArticleCategory 
		FROM [' + @DBNAME + '].[tmp].[ZPaymentWithSkiDataValueCard]'

		EXEC(@sql)
		
		--Adapt and copy shifts
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRShift]
			([ShiftID]
           ,[ShiftCode]
           ,[ShiftTime]
           ,[ShiftStartupTime]
           ,[ShiftCloseTime]
           ,[IsOpen]
           ,[DeviceID]
           ,[DeviceCode]
           ,[DeviceName]
           ,[DeviceTypeID]
           ,[OperatorID]
           ,[OperatorName]
           ,[OperatorSurname]
           ,[inserted])
			SELECT 
			  RIGHT(''000''+ cast(DeviceNo as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([ShiftNo] as varchar(10))  + ''/'' +
			   cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([DeviceNo] as varchar), 3) + ''/'' + convert(varchar, [time], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [time]) as varchar) + cast(datepart(mi, [time]) as varchar) + cast(datepart(ss, [time]) as varchar) + cast(datepart(ms, [time]) as varchar),9) + ''/'' + cast([ShiftNo] as varchar(10)) ORDER BY [time] ASC) AS varchar(5)) [ID]
			  ,[ShiftNo]
			  ,[Time]
			  ,[ShiftStartupTime]
			  ,[ShiftCloseTime]
			  ,[IsOpen]
              ,cast([DeviceNo] as varchar(40))
              ,cast([DeviceAbbr] as  varchar(10))
              ,cast([DeviceDesig] as nvarchar(50))
              ,cast([DeviceType] as varchar(40))
              ,cast([StaffCode] as varchar(40))
              ,cast([OperatorFirstName] as nvarchar(50))
              ,cast([OperatorSurname] as nvarchar(50))
              ,getdate()
			FROM [' + @DBNAME + '].[tmp].[ZShifts]'
		
		EXEC(@sql)


END
