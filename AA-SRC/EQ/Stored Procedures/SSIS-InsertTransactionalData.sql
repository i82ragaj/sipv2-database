

-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
--  @datefrom: Date from which the data will be insert
-- Return: Nothing
-- Summary:	Execute the daily process for a parking
-- =============================================


CREATE     PROCEDURE [EQ].[SSIS-InsertTransactionalData]
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

	--Devices type
	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDDeviceType]
	([DeviceTypeID]
     ,[DeviceTypeName]
	 ,[Inserted])
	SELECT distinct [DeviceTypeID], SUBSTRING([DeviceName],1,(CHARINDEX('' '',[DeviceName] + '' '')-1)), getdate()
	FROM [' + @DBNAME + '].[dbo].[MDDevice]
	WHERE [DeviceTypeID] not in (SELECT [DeviceTypeID] from [' + @DBNAME + '].[dbo].[MDDeviceType])'

	exec(@sql);

	--Insert parking trans in temporary table
	set @sql = 'INSERT INTO [' + @DBNAME + '].[tmp].[ParkingTransTmp]
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
			   ,[Inserted]
		       )
		SELECT t.[cod] [ID], 
		t.[fechor] [Time], 
		''P'' as TransType, 

		m.[DeviceId],
		m.[DeviceCode],
		m.[DeviceName],
		m.[DeviceTypeId],

		o.[OperatorId],
		o.[OperatorSurname],
		o.[OperatorName],		
		
		a.[ArticleId],
		a.[ArticleCode],
		SUBSTRING(a.[ArticleName],1,50),
		a.[ArticleCategory], 		
		a.[ArticleType],
		d.numpro [CardNo], 
		
		d.[entest] [Time_IN],
		null,
		null,
		d.[mat] [PlateNo_IN], 

		null,
		null,
		null,
		d.[mat] [PlateNo_OUT],

		DATEDIFF (Minute, ''1899-12-30'', d.[tie]) [ParkingDuration],
		d.[codtar] [RateNo], 
		SUBSTRING(u.[des],1,25)  [RateDesig],

		d.[ord] [TransactionNo], 
		t.[codfac] [InvoiceNo], 
		t.[imptot] [Revenue], 
		t.[basimp] [NetRevenue], 
		d.[imp] as [RevenueExt], 

		1 [VATNo], 
		t.[nomimp] [VATDesig], 		 
		t.[codforpag] [PaymentType], 
		d.[codtipcon], 
		SUBSTRING(t.[obs],1,100) [Description], 

		getdate() fecha
		from [' + @DBNAME + '].[tmp].[Zcob] t join [' + @DBNAME + '].[tmp].[Zdetcob] d on t.[cod] = d.[codcob] and d.[ord] = 1
		join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleID] = d.[codgrupro]
		left join [' + @DBNAME + '].[dbo].[MDDevice] m on m.[DeviceId] = t.numapa and m.DeviceTypeId = t.tipapa
		left join [' + @DBNAME + '].[dbo].[MDOperator] o on o.[OperatorId] = t.[codope]
		left join [' + @DBNAME + '].[tmp].[Zc_ins] p on p.[cod] = t.[codins]
		left join [' + @DBNAME + '].[tmp].[Ztar] u on u.[cod] =  d.[codtar]  
		where d.[codtipcon]  IN (1, 2, 8, 14, 16)
		and not exists (select 1 from [' + @DBNAME + '].[dbo].[TRParkingTrans] h where h.ParkingTransID = t.cod)' 
		
		EXEC(@sql)

		--Insert in temporary table all parking movements
		set @sql = 'INSERT INTO  [' + @DBNAME + '].[tmp].[MovementsTmp]
		([MovementDate]
         ,[DeviceType]
         ,[DeviceId]
         ,[DeviceName]
         ,[SerialNo]
         ,[Article]
		 ,[LicencePlate])
		SELECT a.[fechor]
		,a.[tipapa]
		,a.[numapa]
		,b.[DeviceName]
		,a.[numpro]
		,a.[codgrupro] 
		,coalesce(nullif(replace(a.[matrec], ''+'', ''''),''''), a.[matasopro]) mat
		FROM [' + @DBNAME + '].[tmp].[Zentsal] a 
		left join [' + @DBNAME + '].[dbo].[MDDevice] b on a.tipapa = b.DeviceTypeID and a.numapa = b.DeviceID
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
		WHERE [ParkingTransType] = ''P'';
		
		
		OPEN Trans_Cursor  
		FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleType
		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @Trans_Time_IN = NULL, @Trans_DeviceNo_IN = NULL, @Trans_DeviceDesig_IN = NULL, @Trans_Plate_IN  = NULL
			select @Trans_Time_OUT = NULL, @Trans_DeviceNo_OUT = NULL, @Trans_DeviceDesig_OUT = NULL, @Trans_Plate_OUT  = NULL
			SELECT TOP 1 @Trans_Time_IN = [MovementDate], @Trans_DeviceNo_IN = [DeviceId], @Trans_DeviceDesig_IN = [DeviceName], @Trans_Plate_IN = [LicencePlate]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [SerialNo] = @Trans_CardNo AND [DeviceType] = 5 AND [Article] = @Trans_ArticleType AND
			[MovementDate] = (SELECT MAX([MovementDate]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [SerialNo] = @Trans_CardNo
								AND [MovementDate] <= @Trans_Time
								AND [DeviceType] = 5)
			
			SELECT TOP 1 @Trans_Time_OUT = [MovementDate], @Trans_DeviceNo_OUT = [DeviceId], @Trans_DeviceDesig_OUT = [DeviceName], @Trans_Plate_OUT = [LicencePlate]
			FROM [' + @DBNAME + '].[tmp].[MovementsTmp]
			WHERE [SerialNo] = @Trans_CardNo AND [DeviceType] = 6 AND [Article] = @Trans_ArticleType AND
			[MovementDate] = (SELECT MIN([MovementDate]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [SerialNo] = @Trans_CardNo
								AND [MovementDate] >= dateadd(ss, -10, @Trans_Time) 
								AND [DeviceType] = 6)
			
			UPDATE [' + @DBNAME + '].[tmp].[ParkingTransTmp]
			set 
			EntryTime = coalesce(EntryTime, @Trans_Time_IN),
			EntryDeviceID = coalesce(EntryDeviceID, @Trans_DeviceNo_IN),
			EntryDeviceName = coalesce(EntryDeviceName, @Trans_DeviceDesig_IN),
			EntryPlate = coalesce(EntryPlate, @Trans_Plate_IN),
			ExitTime = coalesce(ExitTime, @Trans_Time_OUT),
			ExitDeviceID = coalesce(ExitDeviceID, @Trans_DeviceNo_OUT),
			ExitDeviceName = coalesce(ExitDeviceName, @Trans_DeviceDesig_OUT),
			ExitPlate = coalesce(ExitPlate, @Trans_Plate_OUT)
			where [ParkingTransID] = @Trans_ID;

			FETCH NEXT FROM Trans_Cursor INTO @Trans_ID, @Trans_Time, @Trans_CardNo, @Trans_ArticleType
		END 
		CLOSE Trans_Cursor  
		DEALLOCATE Trans_Cursor'
		
		EXEC(@sql)
		
		--Adapt and copy transactions from temporary table to final transactions table
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRParkingTrans]
        SELECT * FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp]'
		
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
			RIGHT(''0000000000''+ cast(t.[numapa] as varchar), 10) + ''/'' + convert(varchar, t.[fechor], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[fechor]) as varchar) + cast(datepart(mi, t.[fechor]) as varchar) + cast(datepart(ss, t.[fechor]) as varchar) + cast(datepart(ms, t.[fechor]) as varchar),9) + ''/'' + 
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''0000000000''+ cast(t.[numapa] as varchar), 10) + ''/'' + convert(varchar, t.[fechor], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, t.[fechor]) as varchar) + cast(datepart(mi, t.[fechor]) as varchar) + cast(datepart(ss, t.[fechor]) as varchar) + cast(datepart(ms, t.[fechor]) as varchar),9) ORDER BY t.[fechor] ASC) AS varchar(5)) [ID]
			,t.[fechor] [Time]
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

			,t.[fechor]
			,t.[numapa] 
			,b.[DeviceName]
			,coalesce(nullif(replace(t.[matrec], ''+'', ''''),''''), t.[matasopro])
			
			,null
			,null
			,null
			
			,null
			,null
			,0
			,0
			,0

			,null
			,null
			,null
			,null
			,null

			,getdate()
			FROM [' + @DBNAME + '].[tmp].[Zentsal] t
			join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleId] = t.[codgrupro]
			left join [' + @DBNAME + '].[dbo].[MDDevice] b on b.[DeviceId] = t.[numapa] and b.[DeviceTypeID] = t.[tipapa]
			WHERE t.[tipapa] = 6 and t.[codgrupro] IN (select ArticleID from [' + @DBNAME + '].[dbo].[MDArticle] where ArticleType = ''A'')
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
			WHERE [SerialNo] = @Trans_CardNo AND [DeviceType] = 5 AND [Article] = @Trans_ArticleType AND
			[MovementDate] = (SELECT MAX([MovementDate]) FROM [' + @DBNAME + '].[tmp].[MovementsTmp] 
								WHERE [SerialNo] = @Trans_CardNo
								AND [MovementDate] <= @Trans_Time
								AND [DeviceType] = 5)
			
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

		--Adapt and copy transactions from temporary table to final transactions table
		set @sql = '
		INSERT INTO [' + @DBNAME + '].[dbo].[TRParkingTrans]
        SELECT * FROM [' + @DBNAME + '].[tmp].[ParkingTransTmp]'
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

			SELECT t.[cod] [ID], 
			t.[fechor] [Time], 

			m.[DeviceId],
			m.[DeviceCode],
			m.[DeviceName],
			m.[DeviceTypeId],

			o.[OperatorId],
			o.[OperatorSurname],
			o.[OperatorName],		
		
			a.[ArticleId],
			a.[ArticleCode],
			SUBSTRING(a.[ArticleName],1,50),
			a.[ArticleCategory], 		

			d.[can] [Quantity],
			d.[entest],
			d.numpro [CardNo], 
			null,
			t.[fechor],
			null,

			d.[ord] [TransactionNo], 
			t.[codfac] [InvoiceNo], 
			t.[imptot] [Revenue], 
			t.[basimp] [NetRevenue],
			
			1 [VATNo], 
			t.[nomimp] [VATDesig], 				
			t.[codforpag] [PaymentType], 
			d.[codtipcon], 
			SUBSTRING(t.[obs],1,100) [Description], 

			t.[nif],
			t.[nomrazsoc],
			t.[domsoc],
			null,
			null,

			getdate() fecha
			from [' + @DBNAME + '].[tmp].[Zcob] t join [' + @DBNAME + '].[tmp].[Zdetcob] d on t.[cod] = d.[codcob] and d.[ord] = 1
			join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleID] = d.[codgrupro]
			left join [' + @DBNAME + '].[dbo].[MDDevice] m on m.[DeviceId] = t.numapa and m.DeviceTypeId = t.tipapa
			left join [' + @DBNAME + '].[dbo].[MDOperator] o on o.[OperatorId] = t.[codope]
			left join [' + @DBNAME + '].[tmp].[Zc_ins] p on p.[cod] = t.[codins]
			left join [' + @DBNAME + '].[tmp].[Ztar] u on u.[cod] =  d.[codtar]  
			where d.[codtipcon]  NOT IN (1, 2, 8, 14, 16)
			and not exists (select 1 from [' + @DBNAME + '].[dbo].[TRParkingTrans] h where h.ParkingTransID = t.cod)' 
		
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
			RIGHT(''000''+ cast(numapa as varchar), 3) + ''/'' + convert(varchar, [fechor], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [fechor]) as varchar) + cast(datepart(mi, [fechor]) as varchar) + cast(datepart(ss, [fechor]) as varchar) + cast(datepart(ms, [fechor]) as varchar),9) + ''/'' + 
		    cast(ROW_NUMBER() OVER(PARTITION BY RIGHT(''000''+ cast([numapa] as varchar), 3) + ''/'' + convert(varchar, [fechor], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [fechor]) as varchar) + cast(datepart(mi, [fechor]) as varchar) + cast(datepart(ss, [fechor]) as varchar) + cast(datepart(ms, [fechor]) as varchar),9) ORDER BY [fechor] ASC) AS varchar(5)) [ID]
			,e.[fechor] [Time]
			,e.[tipapa] [MovementType]
			,d.[DeviceId] 
			,d.[DeviceName]
			,a.[ArticleId]
			,a.[ArticleCode]
			,a.[ArticleName]
			,CAST(e.[imp] as decimal(18,4)) [Amount]
			,CAST(e.numpro as varchar(50)) [CardNo]
			,CAST([matrec] as varchar(50)) [PlateNo]
			,getdate()
			FROM [' + @DBNAME + '].[tmp].[Zentsal] e
			join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleId] = e.[codgrupro]
			left join [' + @DBNAME + '].[tmp].[Zc_ins] p on p.[cod] = e.[codins]
			left join [' + @DBNAME + '].[dbo].[MDDevice] d on d.[DeviceId] = e.[numapa] and d.[DeviceTypeId] = e.[tipapa]'
		
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
            ,[Revenue]
			,[LineRevenue]
			,[TotalRevenue]
            ,[TransactionNo]
            ,[InvoiceNo]
			,[Remarks]
            ,[Inserted])
		SELECT 
			cast(d.[ord] as varchar(40)) + ''/'' + cast(t.[cod] as varchar(40))
			,t.[fechor] [Time]		
			,t.[codforpag] [PaymentType] 
			,d.[codtipcon] [ConceptTypeID]
			,m.[DeviceId]
			,m.[DeviceCode]
			,m.[DeviceName]
			,m.[DeviceTypeId]
			,o.[OperatorId]
			,o.[OperatorName]
			,o.[OperatorSurname]
			,a.[ArticleID]
            ,a.[ArticleCode]
            ,a.[ArticleName]
            ,a.[ArticleCategory]
			,d.[ord]
			,d.[can] [Quantity]
			,d.[imp] [Revenue] 
			,d.[imptot] [LineRevenue]
			,t.[imptot] [TotalRevenue] 
			,t.[cod] [TransactionNo]
			,t.[codfac] [InvoiceNo] 
			,cast(t.[obs] as varchar(100))  as [Remarks]
			,getdate()
		from [' + @DBNAME + '].[tmp].[Zcob] t join [' + @DBNAME + '].[tmp].[Zdetcob] d on t.[cod] = d.[codcob]
		left join [' + @DBNAME + '].[dbo].[MDDevice] m on m.[DeviceId] = t.[numapa] and m.[DeviceTypeId] = t.[tipapa]
		left join [' + @DBNAME + '].[dbo].[MDOperator] o on o.[OperatorId] = t.[codope]
		left join [' + @DBNAME + '].[dbo].[MDArticle] a on a.[ArticleID] = d.[codgrupro]
		left join [' + @DBNAME + '].[tmp].[Zc_ins] p on p.[cod] = t.[codins]'
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
		t.[num] [ShiftId]
		,t.[num] [ShiftCode]
		,coalesce(t.[fechorcie], ''2100-01-01'') [Time]
		,t.[fechorape] [ShiftStartupTime]
		,coalesce(t.[fechorcie], ''2100-01-01'') [ShiftCloseTime]
		,case when t.[fechorcie] is null then 1 else 0 end [IsOpen]
		,m.[DeviceId]
		,m.[DeviceCode]
		,m.[DeviceName]
		,m.[DeviceTypeId]
		,o.[OperatorId]
		,o.[OperatorName]
		,o.[OperatorSurname]
		,0 [SubstituteShiftNo]
		FROM [' + @DBNAME + '].[tmp].[Ztur] t
		left join [' + @DBNAME + '].[dbo].[MDDevice] m on m.[DeviceId] = t.numapa and m.DeviceTypeId = t.tipapa
		left join [' + @DBNAME + '].[dbo].[MDOperator] o on o.[OperatorId] = t.[codopecie]
		left join [' + @DBNAME + '].[tmp].[Zc_ins] p on p.[cod] = t.[codins]'
		
		EXEC (@sql)
end