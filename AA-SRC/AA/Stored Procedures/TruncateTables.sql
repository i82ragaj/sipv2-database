-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Delete all data for a parking

CREATE     PROCEDURE [AA].[TruncateTables]
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	declare @systemtype varchar(5) = null
	select @systemtype = [type]
	from [AA-ADMIN].[dbo].[MDParking] where ID = @DBNAME

	declare @sql varchar(max);

	set @sql ='	
	truncate table [' + @DBNAME + '].[dbo].[MDClient];
	truncate table [' + @DBNAME + '].[dbo].[MDClientUser];
	truncate table [' + @DBNAME + '].[dbo].[MDClientUserCard];

	truncate table [' + @DBNAME + '].[dbo].[MDCounter];
	truncate table [' + @DBNAME + '].[dbo].[MDDevice];
	truncate table [' + @DBNAME + '].[dbo].[MDOperator];

	truncate table [' + @DBNAME + '].[dbo].[TRCounterReg];
	truncate table [' + @DBNAME + '].[dbo].[TRDailyTotal];
	
	truncate table [' + @DBNAME + '].[dbo].[TRInvoice];
	truncate table [' + @DBNAME + '].[dbo].[TRMovement];
	truncate table [' + @DBNAME + '].[dbo].[TRParkingTrans];
	truncate table [' + @DBNAME + '].[dbo].[TRPayment];
	truncate table [' + @DBNAME + '].[dbo].[TRShift];
	truncate table [' + @DBNAME + '].[dbo].[TRSystemEventReg];'
	
	if(@systemtype is null or (@systemtype <> 'SD' and @systemtype <> 'MY'))
		set @sql +='	
		truncate table [' + @DBNAME + '].[dbo].[MDConceptType];'	

	if(@systemtype is null or (@systemtype <> 'SD' and @systemtype <> 'MY'))
		set @sql +='	
		truncate table [' + @DBNAME + '].[dbo].[MDPaymentType];'	
	
	if(@systemtype is null or @systemtype <> 'MY')
		set @sql +='
		truncate table [' + @DBNAME + '].[dbo].[MDDeviceType];'

	if(@systemtype is null or @systemtype <> 'MY')
		set @sql +='
		truncate table [' + @DBNAME + '].[dbo].[MDSystemEvent];'
	
	if(@systemtype is null or @systemtype <> 'MY')
		set @sql +='
		truncate table [' + @DBNAME + '].[dbo].[MDArticle];'

	exec (@sql);



END