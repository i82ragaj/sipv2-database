
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	It deletes all client information not present in PMS and cleans other temploraly tables with client information.
-- =============================================

CREATE PROCEDURE [AA].[DeleteClientsOldInformation]
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @sql varchar(max);
	declare @dateToDelete varchar(10) = DATEADD(yy, -10, CAST(GETDATE() as date))


	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	set @sql ='
	delete from [' + @DBNAME + '].[dbo].[MDClient] where [Updated] < ''' + @dateToDelete + ''';
	delete from [' + @DBNAME + '].[dbo].[MDClientUser] where [Updated] < ''' + @dateToDelete + ''';
	delete from [' + @DBNAME + '].[dbo].[MDClientUserCard] where [Updated] < ''' + @dateToDelete + ''';
	'

	exec(@sql);


	set @sql ='
	IF EXISTS (
    SELECT 1 
    FROM [' + @DBNAME + '].[tmp].[ZSubscriberContract]
    WHERE ID  = @DBNAME
	)
	BEGIN
		TRUNCATE TABLE [' + @DBNAME + '].[tmp].[ZClient]
		TRUNCATE TABLE [' + @DBNAME + '].[tmp].[ZDomiciliaryCharge]
		TRUNCATE TABLE [' + @DBNAME + '].[tmp].[ZSubscriberContract]
	END
	'

	exec(@sql);


END