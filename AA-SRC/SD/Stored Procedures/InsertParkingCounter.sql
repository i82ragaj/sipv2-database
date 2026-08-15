-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Insert and update parking counters
-- =============================================
CREATE   PROCEDURE [SD].[InsertParkingCounter]
@DBNAME varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @updated datetime;
	declare @countingDate datetime;
	set @updated = getdate();
	set @countingDate = DATEADD(HH, DATEPART(HOUR, @updated), CAST(CONVERT(date, @updated) AS datetime))

	declare @PKSRV varchar(10) = @DBNAME;
	select @PKSRV = [SRV] from [AA-ADMIN].[dbo].[MDParking] where ID = @DBNAME;

	declare @sql varchar(max) = '';

	set @sql ='	INSERT INTO [' + @DBNAME + '].[dbo].[TRCounterReg]
				([CounterID]
				,[CounterDate]
				,[CurrentLevel]
				,[Capacity]
				,[Inserted]
				,[Updated])
		
	SELECT 	  	[CountingCategoryNo] + ([CarparkNo] * 100)
				,''' + convert(varchar, @countingDate,  126) + ''' 
				,coalesce([CurrentLevel],0)
				,coalesce([Capacity],0)
				,''' + convert(varchar, @updated,  126) + '''
				,''' + convert(varchar, @updated,  126) + '''
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[CPCounting]
	WHERE NOT EXISTS (SELECT 1 FROM [' + @DBNAME +  '].[dbo].[TRCounterReg] WHERE [CounterDate] = ''' + convert(varchar, @countingDate,  126) + ''')';

	EXEC(@sql)

	set @sql ='	INSERT INTO [AA-CONTO].[dbo].[TRCounterReg]
				([IDPK]
				,[CounterID]
				,[CounterDate]
				,[CurrentLevel]
				,[Capacity]
				,[Inserted]
				,[Updated])
		
	SELECT 	   ''' + @DBNAME + ''',
				[CountingCategoryNo] + ([CarparkNo] * 100)
				,''' + convert(varchar, @countingDate,  126) + ''' 
				,coalesce([CurrentLevel], 0)
				,coalesce([Capacity], 0)
				,''' + convert(varchar, @updated,  126) + '''
				,''' + convert(varchar, @updated,  126) + '''
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[CPCounting]
	WHERE NOT EXISTS (SELECT 1 FROM [AA-CONTO].[dbo].[TRCounterReg]  WHERE [IDPK] = ''' + @DBNAME + ''' AND [CounterDate] = ''' + convert(varchar, @countingDate,  126) + ''')';

	EXEC(@sql)
	
	set @sql ='	UPDATE a
	SET a.[CurrentLevel] = b.[CurrentLevel],
	a.[Capacity] = b.[Capacity],
	a.[Updated] = b.[Updated]

	FROM [AA-CONTO].[dbo].[TRCounterReg] a, 
	(SELECT 	   ''' + @DBNAME + ''' [IDPK],
				''' + convert(varchar, @countingDate,  126) + ''' [CountingDate] 
				,[CountingCategoryNo] + ([CarparkNo] * 100) [CountingCategoryNo]
				,coalesce([CurrentLevel],0) [CurrentLevel]
				,coalesce([Capacity],0) [Capacity]
				,''' + convert(varchar, @updated,  126) + ''' [Updated]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[CPCounting]) b
	WHERE a.[IDPK] = b.[IDPK] and a.[CounterDate] = b.[CountingDate] and a.[CounterID] = b.[CountingCategoryNo]'

	EXEC(@sql)

	set @sql ='	UPDATE a
	SET a.[CurrentLevel] = b.[CurrentLevel],
	a.[Capacity] = b.[Capacity],
	a.[Updated] = b.[Updated]

	FROM  [' + @DBNAME + '].[dbo].[TRCounterReg] a, 
	(SELECT 	   ''' + @DBNAME + ''' [IDPK],
				''' + convert(varchar, @countingDate,  126) + ''' [CountingDate] 
				,[CountingCategoryNo]
				,coalesce([CurrentLevel],0) [CurrentLevel]
				,coalesce([Capacity],0) [Capacity]
				,''' + convert(varchar, @updated,  126) + ''' [Updated]
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[CPCounting]) b
	WHERE a.[CounterDate] = b.[CountingDate] and a.[CounterID] = b.[CountingCategoryNo]'

	EXEC(@sql)

	set @sql ='UPDATE [AA-ADMIN].[dbo].[MDParkingStatus] set LastCountTotals = getdate(), LastCountTotalsStatus = ''OK'' where ID = ''' + @DBNAME + ''''
	
	EXEC(@sql)

	return 1;
END