-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Insert and update parking totals
-- =============================================
CREATE   PROCEDURE  [SD].[InsertParkingTotals]
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

	set @sql ='DELETE FROM [AA-CONTO].[dbo].[TRDailyTotal] WHERE [IDPK] = ''' + @DBNAME + ''' AND [TotalDate] = ''' + convert(varchar, @countingDate,  126) + '''';
	exec(@sql)
	set @sql ='DELETE FROM [' + @DBNAME +  '].[dbo].[TRDailyTotal] WHERE [TotalDate] = ''' + convert(varchar, @countingDate,  126) + '''';
	exec(@sql)

	set @sql ='INSERT INTO [AA-CONTO].[dbo].[TRDailyTotal]
           ([IDPK]
		   ,[TotalDate]
           ,[DailyTransWithPay]
           ,[DailyTransWithOutPay]
           ,[DailyTotalAmount])
	
	SELECT 	   ''' + @DBNAME + ''',
			   ''' + convert(varchar, @countingDate,  126) + ''',
	coalesce(cp.num, 0), coalesce(sp.num,0), coalesce(cp.total,0)
	from
	(SELECT count(*) num, sum([Revenue]) total
	from 
		(select [time], [Revenue] from [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueParkingTrans] 
		 union
		 select [time], [Revenue] from [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueSales]
		)a
	where time > cast(getdate() as date)) cp,
	(SELECT count(*) num, sum([Revenue]) total
	from [' + @PKSRV + '].[PARK_DB].[dbo].[ParkingTransWithoutTurnover] 
	where time > cast(getdate() as date)) sp'

	exec(@sql)


	set @sql ='INSERT INTO [' + @DBNAME + '].[dbo].[TRDailyTotal]
           ([TotalDate]
           ,[DailyTransWithPay]
           ,[DailyTransWithOutPay]
           ,[DailyTotalAmount])
	select ''' + convert(varchar, @countingDate,  126) + ''', 
	coalesce(cp.num, 0), coalesce(sp.num,0), coalesce(cp.total,0)
	from
	(SELECT count(*) num, sum([Revenue]) total
	from 
		(select [time], [Revenue] from [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueParkingTrans] 
		 union
		 select [time], [Revenue] from [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueSales]
		)a
	where time > cast(getdate() as date)) cp,
	(SELECT count(*) num, sum([Revenue]) total
	from [' + @PKSRV + '].[PARK_DB].[dbo].[ParkingTransWithoutTurnover] 
	where time > cast(getdate() as date)) sp'

	exec(@sql)


	return 1;
END
