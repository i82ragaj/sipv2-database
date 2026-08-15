
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Execute initialization for daily process for a parking

CREATE     PROCEDURE [MY].[SSIS-ParkingTotals]
@DBNAME as varchar(10) = null,
@TruncateTables as integer = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @updated datetime;
	declare @countingDate datetime;
	set @updated = getdate();
	set @countingDate = DATEADD(HH, DATEPART(HOUR, @updated), CAST(CONVERT(date, @updated) AS datetime))
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
	coalesce(a.num, 0), 0, coalesce(a.total,0)
	from
	(SELECT count(*) num, sum([AmountPaid]) total
	from [' + @DBNAME + '].[tmp].[ZPaymentCalc]  ) a'
	
	exec(@sql)


	set @sql ='INSERT INTO [' + @DBNAME + '].[dbo].[TRDailyTotal]
           ([TotalDate]
           ,[DailyTransWithPay]
           ,[DailyTransWithOutPay]
           ,[DailyTotalAmount])
	select ''' + convert(varchar, @countingDate,  126) + ''', 
	coalesce(a.num, 0), 0, coalesce(a.total,0)
	from
	(SELECT count(*) num, sum([AmountPaid]) total
	from [' + @DBNAME + '].[tmp].[ZPaymentCalc]  ) a'

	exec(@sql)

END