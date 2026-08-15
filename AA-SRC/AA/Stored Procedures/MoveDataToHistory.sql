-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Move to historic all transactional data previus a date configured in procedure for a parking
-- =============================================

CREATE PROCEDURE [AA].[MoveDataToHistory]
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	--If first day of month
	if(DAY(GETDATE()) = 1)
	begin

		--Move data to history from first month day of previus year
		declare @prevToDate varchar(10) = convert(varchar(20), DATEFROMPARTS(YEAR(GETDATE())-1, MONTH(GETDATE()), 1), 112);
		declare @sql varchar(max);
			
		set @sql ='
		insert into [ALLPK-HIST].[dbo].[TRCounterReg] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRCounterReg] where [CounterDate] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRDailyTotal] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRDailyTotal] where [TotalDate] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRInvoice] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRInvoice] where [InvoiceTime] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRMovement] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRMovement] where [MovementTime] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRParkingTrans] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRParkingTrans] where [ParkingTransTime] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRPayment] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRPayment] where [PaymentTime] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRShift] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRShift] where [ShiftTime] < ''' + @prevToDate + ''';
		insert into [ALLPK-HIST].[dbo].[TRSystemEventReg] select ''' + @DBNAME + ''' [IDPK], * from [' + @DBNAME + '].[dbo].[TRSystemEventReg] where [SystemEventRegTime] < ''' + @prevToDate + '''';

		exec(@sql);

		set @sql ='
		delete from [' + @DBNAME + '].[dbo].[TRCounterReg] where [CounterDate] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRDailyTotal] where [TotalDate] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRInvoice] where [InvoiceTime] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRMovement] where [MovementTime] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRParkingTrans] where [ParkingTransTime] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRPayment] where [PaymentTime] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRShift] where [ShiftTime] < ''' + @prevToDate + ''';
		delete from [' + @DBNAME + '].[dbo].[TRSystemEventReg] where [SystemEventRegTime] < ''' + @prevToDate + '''';

		exec(@sql);
	end

END