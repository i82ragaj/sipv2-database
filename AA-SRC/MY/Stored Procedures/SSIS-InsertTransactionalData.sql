-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
--  @datefrom: Date from which the data will be insert
-- Return: Nothing
-- Summary:	Execute the daily process for a parking
-- =============================================


CREATE     PROCEDURE [MY].[SSIS-InsertTransactionalData]
@DBNAME as varchar(10) = null
	AS
	BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from XX
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @datefrom as date = null
	declare @NDays int = null
	declare @sql varchar(max);

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	select @datefrom = DateFromTable, @NDays = NDays
	from [AA-ADMIN].[dbo].[MDParking] where ID = @DBNAME

	if(@NDays is not null)
		set @datefrom = DATEADD(DAY,-1 * @NDays, cast(getdate() as date))

	if(@datefrom is null)
		set @datefrom = cast(dateadd(dd, -7, getdate()) as date)


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
		
		--Insert in temporary table all parking movements
		set @sql = 'INSERT INTO  [' + @DBNAME + '].[tmp].[MovementsTmp]
		(
		  [MovementDate]
         ,[DeviceType]
         ,[DeviceId]
         ,[DeviceName]
         ,[SerialNo]
         ,[Article]
		 ,[LicencePlate]
		)
		SELECT [DateTimeEntry] [DateTimeOpe]
			  ,''ENT''
			  ,[TerminalMeyparID]
			  ,[TerminalName]
			  ,[TitleId]
			  ,[CirculatoryTitleType]
			  ,[CarLicensePlate] 
		FROM [' + @DBNAME + '].[tmp].[ZEntry]
		  UNION
		SELECT [DateTimeExit] [DateTimeOpe]
			  ,''EXI''
			  ,[TerminalMeyparID]
			  ,[TerminalName]
			  ,[TitleId]
			  ,[CirculatoryTitleType]
			  ,[CarLicensePlate] 
		  FROM [' + @DBNAME + '].[tmp].[ZExit]
		'
		EXEC(@sql)

		--Adapt and copy transactions with payment
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[tmp].[ParkingTransTmp]
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
		SELECT 
			cast(t.[PaymentConceptNumber] as varchar(40)) + ''/'' + cast(t.[PaymentId] as varchar(40))
			,t.[DateTimePayment] [Time]
			,''P''
			,t.[TerminalMeyparID]
			,t.[TerminalCodExt]
			,t.[TerminalName]
			,t.[TerminalType]
			,t.[PaymentOperationUserCod]
			,t.[PaymentOperationUserName]
            ,null
			,p.[ArticleID]
			,p.[ArticleCode]
            ,p.[ArticleName]
            ,p.[ArticleCategory]
			,p.[ArticleType]
			,t.[TitleId]
			
			,t.[DateTimePaymentStart]
			,null
			,null
			,t.[CarLicensePlate]
			
			,t.[DateTimePaymentEnd]
			,null
			,null
			,t.[CarLicensePlate]

			,t.[PaidTimeInMin]
			,null
			,null

			,t.[PaymentId] [TransactionNo]
			,cast(t.[ReceiptSerialId] as varchar(10)) + ''/'' + cast(t.[ReceiptSequenceId] as varchar(10)) [InvoiceNo] 
			,t.[AmountPaid] [TotalRevenue] 
			,t.[AmountPriceStay] [Revenue] 
			,t.[AmountDiscount] [RevenueExt]

			,null
			,null
			,t.[PaymentMethod1Type] [PaymentType] 
			,t.[PaymentOperationType] [ConceptTypeID]
			,cast(t.[DiscountTemplateName] as varchar(100))  as [Remarks]
			,getdate()
		from [' + @DBNAME + '].[tmp].[ZPayment] t 
		left join [' + @DBNAME + '].[dbo].[MDArticle] p on p.[ArticleId] = cast(t.[CirculatoryTitleType] as varchar(10))
		where t.[DateTimePaymentStart] is not null'

		EXEC(@sql)
				
		--Update temporaly table's data about entry and exit
		set @sql = '
		DECLARE @Trans_ID varchar(40), @Trans_Time datetime, @Trans_CardNo nvarchar(30), @Trans_ArticleId nvarchar(10),
		@Trans_Time_IN datetime, @Trans_DeviceNo_IN varchar(40), @Trans_DeviceDesig_IN  nvarchar(50), @Trans_Plate_IN nvarchar(20),
		@Trans_Time_OUT datetime, @Trans_DeviceNo_OUT varchar(40), @Trans_DeviceDesig_OUT  nvarchar(50), @Trans_Plate_OUT nvarchar(20);
		DECLARE Trans_Cursor CURSOR READ_ONLY FOR
		SELECT [ParkingTransID], [ParkingTransTime], [SerialNo], [ArticleId]   
		FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp]
		WHERE [ParkingTransType] = ''P'';
		
		
		OPEN Trans_Cursor  
		FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @Trans_Time_IN = NULL, @Trans_DeviceNo_IN = NULL, @Trans_DeviceDesig_IN = NULL, @Trans_Plate_IN  = NULL
			select @Trans_Time_OUT = NULL, @Trans_DeviceNo_OUT = NULL, @Trans_DeviceDesig_OUT = NULL, @Trans_Plate_OUT  = NULL
			SELECT TOP 1 @Trans_Time_IN = [MovementDate], @Trans_DeviceNo_IN = [DeviceId], @Trans_DeviceDesig_IN = [DeviceName], @Trans_Plate_IN = [LicencePlate]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [SerialNo] = @Trans_CardNo AND [DeviceType] = ''ENT'' AND [Article] = @Trans_ArticleType AND
			[MovementDate] = (SELECT MAX([MovementDate]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [SerialNo] = @Trans_CardNo
								AND [MovementDate] <= @Trans_Time
								AND [DeviceType] = ''ENT'')
			
			SELECT TOP 1 @Trans_Time_OUT = [MovementDate], @Trans_DeviceNo_OUT = [DeviceId], @Trans_DeviceDesig_OUT = [DeviceName], @Trans_Plate_OUT = [LicencePlate]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [SerialNo] = @Trans_CardNo AND [DeviceType] = ''EXI'' AND [Article] = @Trans_ArticleType AND
			[MovementDate] = (SELECT MIN([MovementDate]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [SerialNo] = @Trans_CardNo
								AND [MovementDate] >= dateadd(ss, -10, @Trans_Time) 
								AND [DeviceType] = ''EXI'')
			
			UPDATE [' + @DBNAME + '].[tmp].[ParkingTransTmp]
			set	EntryDeviceID = coalesce(EntryDeviceID, @Trans_DeviceNo_IN),
			EntryDeviceName = coalesce(EntryDeviceName, @Trans_DeviceDesig_IN),
			EntryPlate = coalesce(EntryPlate, @Trans_Plate_IN),
			ExitDeviceID = coalesce(ExitDeviceID, @Trans_DeviceNo_OUT),
			ExitDeviceName = coalesce(ExitDeviceName, @Trans_DeviceDesig_OUT),
			ExitPlate = coalesce(ExitPlate, @Trans_Plate_OUT)
			where [ParkingTransID] = @Trans_ID;
			FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleId
		END 
		CLOSE Trans_Cursor  
		DEALLOCATE Trans_Cursor'
		
		PRINT(@sql)

		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRParkingTrans]
        SELECT * FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp]
		'
		EXEC(@sql)

		set @sql = '
		truncate table [' + @DBNAME + '].[tmp].[ParkingTransTmp];'
		EXEC(@sql)

		--Adapt and copy transactions without payment
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[tmp].[ParkingTransTmp]
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
			
			SELECT 
			RIGHT(''0000000000''+ cast(t.[TerminalMeyparID] as varchar), 10) + ''/'' + convert(varchar, t.[DateTimeExit], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[DateTimeExit]) as varchar) + cast(datepart(mi, t.[DateTimeExit]) as varchar) + cast(datepart(ss, t.[DateTimeExit]) as varchar) + cast(datepart(ms, t.[DateTimeExit]) as varchar),9) + ''/'' + 
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''0000000000''+ cast(t.[TerminalMeyparID] as varchar), 10) + ''/'' + convert(varchar, t.[DateTimeExit], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[DateTimeExit]) as varchar) + cast(datepart(mi, t.[DateTimeExit]) as varchar) + cast(datepart(ss, t.[DateTimeExit]) as varchar) + cast(datepart(ms, t.[DateTimeExit]) as varchar),9) ORDER BY t.[DateTimeExit] ASC) AS varchar(5)) [ID]
			,t.[DateTimeExit] [Time]
			,''G''
			
			,null
			,null
			,null
			,null

			,null
			,null
			,null
			
			,a.[ArticleId]
			,a.[ArticleCode]
			,a.[ArticleName]
			,a.[ArticleCategory]
			,a.[ArticleType]
			,t.[numpro]

			,null
			,null
			,null
			,null

			,t.[DateTimeExit]
			,t.[TerminalMeyparID] 
			,t.[TerminalName]
			,CAST(t.[CarLicensePlate] as varchar(20)) 			
			
			,null
			,null
			,null
			
			,null
			,null
			,null
			,null
			,null

			,null
			,null
			,null
			,null
			,null

			,getdate()
			from [' + @DBNAME + '].[tmp].[ZExit] t 
			left join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleId] = cast(t.[CirculatoryTitleType] as varchar(10))
			WHERE t.[CirculatoryTitleType] IN (select ArticleID from [' + @DBNAME + '].[dbo].[MDArticle] where ArticleType = ''A'' and ISNUMERIC(ArticleID) = 1)
			'

		EXEC(@sql)

		--Update temporaly table's data about entry and exit
		set @sql = '
		DECLARE @Trans_ID nvarchar(40), @Trans_Time datetime, @Trans_CardNo nvarchar(30), @Trans_ArticleType nvarchar(10),
		@Trans_Time_IN datetime, @Trans_DeviceNo_IN smallint, @Trans_DeviceDesig_IN  nvarchar(25), @Trans_Plate_IN nvarchar(20),
		@Trans_Time_OUT datetime, @Trans_DeviceNo_OUT smallint, @Trans_DeviceDesig_OUT  nvarchar(25), @Trans_Plate_OUT nvarchar(20);
		DECLARE Trans_Cursor CURSOR READ_ONLY FOR
		SELECT [ParkingTransID], [ParkingTransTime], [SerialNo], [ArticleId]   
		FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp]
		WHERE [ParkingTransType] = ''G'';
		
		
		OPEN Trans_Cursor  
		FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @Trans_Time_IN = NULL, @Trans_DeviceNo_IN = NULL, @Trans_DeviceDesig_IN = NULL, @Trans_Plate_IN  = NULL
			SELECT TOP 1 @Trans_Time_IN = [MovementDate], @Trans_DeviceNo_IN = [DeviceId], @Trans_DeviceDesig_IN = [DeviceName], @Trans_Plate_IN = [LicencePlate]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [SerialNo] = @Trans_CardNo AND [DeviceType] = ''ENT'' AND [Article] = @Trans_ArticleType AND
			[MovementDate] = (SELECT MAX([MovementDate]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [SerialNo] = @Trans_CardNo
								AND [MovementDate] <= @Trans_Time
								AND [DeviceType] = ''ENT'')
			
			UPDATE [' + @DBNAME + '].[tmp].[ParkingTransTmp]
			set 
			EntryTime = coalesce(EntryTime, @Trans_Time_IN),
			EntryDeviceID = coalesce(EntryDeviceID, @Trans_DeviceNo_IN),
			EntryDeviceName = coalesce(EntryDeviceName, @Trans_DeviceDesig_IN),
			EntryPlate = coalesce(EntryPlate, @Trans_Plate_IN),
			ExitTime = coalesce(ExitTime, @Trans_Time_OUT),
			ParkingDuration = datediff(mi, coalesce(EntryTime, @Trans_Time_IN), coalesce(ExitTime, @Trans_Time_OUT)) 		
			where [ParkingTransID] = @Trans_ID;
			FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleType
		END 
		CLOSE Trans_Cursor  
		DEALLOCATE Trans_Cursor'
		
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
			cast(t.[PaymentConceptNumber] as varchar(40)) + ''/'' + cast(t.[PaymentId] as varchar(40))
			,t.[DateTimePayment] [Time]	
			,t.[TerminalMeyparID]
			,t.[TerminalCodExt]
			,t.[TerminalName]
			,t.[TerminalType]
			,t.[PaymentOperationUserCod]
			,t.[PaymentOperationUserName]
            ,null
			,p.[ArticleID]
			,p.[ArticleCode]
            ,p.[ArticleName]
            ,p.[ArticleCategory]
			,1 [Quantity]
			,null
			,t.[TitleId]
			,null
			,null
			,null
			,t.[PaymentId] [TransactionNo]
			,cast(t.[ReceiptSerialId] as varchar(10)) + ''/'' + cast(t.[ReceiptSequenceId] as varchar(10)) [InvoiceNo] 
			,t.[AmountPaid] [TotalRevenue] 
			,t.[AmountPriceStay] [Revenue] 
			,null
			,null
			,t.[PaymentMethod1Type] [PaymentType] 
			,t.[PaymentOperationType] [ConceptTypeID]
			,cast(t.[DiscountTemplateName] as varchar(100))  as [Remarks]
			,null
			,null
			,null
			,null
			,null
			,getdate()
		from [' + @DBNAME + '].[tmp].[ZPayment] t 
		left join [' + @DBNAME + '].[dbo].[MDArticle] p on p.[ArticleId] = cast(t.[CirculatoryTitleType] as varchar(10))
		where t.[DateTimePaymentStart] is null 
		'
		
		EXEC (@sql)


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
			RIGHT(''0000000000''+ cast(t.[TerminalMeyparID] as varchar), 10) + ''/'' + convert(varchar, t.[DateTimeEntry], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[DateTimeEntry]) as varchar) + cast(datepart(mi, t.[DateTimeEntry]) as varchar) + cast(datepart(ss, t.[DateTimeEntry]) as varchar) + cast(datepart(ms, t.[DateTimeEntry]) as varchar),9) + ''/'' + 
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''0000000000''+ cast(t.[TerminalMeyparID] as varchar), 10) + ''/'' + convert(varchar, t.[DateTimeEntry], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[DateTimeEntry]) as varchar) + cast(datepart(mi, t.[DateTimeEntry]) as varchar) + cast(datepart(ss, t.[DateTimeEntry]) as varchar) + cast(datepart(ms, t.[DateTimeEntry]) as varchar),9) ORDER BY t.[DateTimeEntry] ASC) AS varchar(5)) [ID]
			,t.[DateTimeEntry] [Time]
			,t.[TerminaalType] [MovementType]
			,t.[TerminalMeyparID] 
			,t.[TerminalName]
			,a.[ArticleId]
			,a.[ArticleCode]
			,a.[ArticleName]
			,0 [Amount]
			,CAST(t.TitleId as varchar(50)) [CardNo]
			,CAST(t.[CarLicensePlate] as varchar(20)) [PlateNo]
			,getdate()
			from [' + @DBNAME + '].[tmp].[ZEntry] t 
			left join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleId] = cast(t.[CirculatoryTitleType] as varchar(10))
			'
		
		EXEC (@sql)
		
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
			RIGHT(''0000000000''+ cast(t.[TerminalMeyparID] as varchar), 10) + ''/'' + convert(varchar, t.[DateTimeExit], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[DateTimeExit]) as varchar) + cast(datepart(mi, t.[DateTimeExit]) as varchar) + cast(datepart(ss, t.[DateTimeExit]) as varchar) + cast(datepart(ms, t.[DateTimeExit]) as varchar),9) + ''/'' + 
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''0000000000''+ cast(t.[TerminalMeyparID] as varchar), 10) + ''/'' + convert(varchar, t.[DateTimeExit], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[DateTimeExit]) as varchar) + cast(datepart(mi, t.[DateTimeExit]) as varchar) + cast(datepart(ss, t.[DateTimeExit]) as varchar) + cast(datepart(ms, t.[DateTimeExit]) as varchar),9) ORDER BY t.[DateTimeExit] ASC) AS varchar(5)) [ID]
			,t.[DateTimeExit] [Time]
			,t.[TerminalType] [MovementType]
			,t.[TerminalMeyparID] 
			,t.[TerminalName]
			,a.[ArticleId]
			,a.[ArticleCode]
			,a.[ArticleName]
			,0 [Amount]
			,CAST(t.TitleId as varchar(50)) [CardNo]
			,CAST(t.[CarLicensePlate] as varchar(20)) [PlateNo]
			,getdate()
			from [' + @DBNAME + '].[tmp].[ZExit] t 
			left join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleId] = cast(t.[CirculatoryTitleType] as varchar(10))
			'
		
		EXEC (@sql)

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
			,[ArticleID]
            ,[ArticleCode]
            ,[ArticleName]
            ,[ArticleCategory]
			,[NOrder]
			,[Quantity]
			,[SerialNo]
            ,[Revenue]
			,[LineRevenue]
			,[TotalRevenue]
            ,[TransactionNo]
            ,[InvoiceNo]
			,[Remarks]
            ,[Inserted])
		SELECT 
			cast(t.[PaymentConceptNumber] as varchar(40)) + ''/'' + cast(t.[PaymentId] as varchar(40))
			,t.[DateTimePayment] [Time]		
			,t.[PaymentMethod1Type] [PaymentType] 
			,t.[PaymentOperationType] [ConceptTypeID]
			,t.[TerminalMeyparID]
			,t.[TerminalCodExt]
			,t.[TerminalName]
			,t.[TerminalType]
			,t.[PaymentOperationUserCod]
			,t.[PaymentOperationUserName]
            ,null
			,p.[ArticleID]
			,p.[ArticleCode]
            ,p.[ArticleName]
            ,null
			,t.[PaymentConceptNumber]
			,1 [Quantity]
			,t.[TitleId]
			,t.[AmountPriceStay] [Revenue] 
			,t.[AmountDiscount] [LineRevenue]
			,t.[AmountPaid] [TotalRevenue] 
			,t.[PaymentId] [TransactionNo]
			,cast(t.[ReceiptSerialId] as varchar(10)) + ''/'' + cast(t.[ReceiptSequenceId] as varchar(10)) [InvoiceNo] 
			,cast(t.[DiscountTemplateName] as varchar(100))  as [Remarks]
			,getdate()
		from [' + @DBNAME + '].[tmp].[ZPayment] t 
		left join [' + @DBNAME + '].[dbo].[MDArticle] p on p.[ArticleId] = cast(t.[CirculatoryTitleType] as varchar(10))
		'

		EXEC(@sql)


end