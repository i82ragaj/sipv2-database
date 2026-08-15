-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Execute initialization for daily process for a parking

CREATE     PROCEDURE [MY].[SSIS-InitDailyTask]
@DBNAME as varchar(10) = null,
@TruncateTables as integer = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	declare @sql varchar(max);

	EXEC [AA].[MoveDataToHistory] @DBNAME

	if(@TruncateTables = 1)
		EXEC [AA].[TruncateTables] @DBNAME

	set @sql = '
    truncate table [' + @DBNAME + '].[tmp].[ZEntry];
    truncate table [' + @DBNAME + '].[tmp].[ZExit];
	truncate table [' + @DBNAME + '].[tmp].[ZPayment];
	truncate table [' + @DBNAME + '].[tmp].[ZDomiciliaryCharge];
	truncate table [' + @DBNAME + '].[tmp].[ZIssuingInvoice];
	truncate table [' + @DBNAME + '].[tmp].[ZIncident];	
	truncate table [' + @DBNAME + '].[tmp].[ZClient];
	truncate table [' + @DBNAME + '].[tmp].[ZSubscriberContract];
	truncate table [' + @DBNAME + '].[tmp].[ZSubscriberProduct];
	'

	exec(@sql);

	UPDATE [AA-ADMIN].[dbo].[MDParking] set LastImportedStatus = 'INICIADA' where ID = @DBNAME


END