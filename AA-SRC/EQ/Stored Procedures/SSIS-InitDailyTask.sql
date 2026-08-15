-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Execute initialization for daily process for a parking

CREATE     PROCEDURE [EQ].[SSIS-InitDailyTask]
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
    truncate table [' + @DBNAME + '].[tmp].[Zc_ins];
    truncate table [' + @DBNAME + '].[tmp].[Ztar];
	truncate table [' + @DBNAME + '].[tmp].[Zcob];
	truncate table [' + @DBNAME + '].[tmp].[Zdetcob];
	truncate table [' + @DBNAME + '].[tmp].[Zentsal];
	truncate table [' + @DBNAME + '].[tmp].[Ztur];
	truncate table [' + @DBNAME + '].[tmp].[Zinc];'

	exec(@sql);

	UPDATE [AA-ADMIN].[dbo].[MDParking] set LastImportedStatus = 'INICIADA' where ID = @DBNAME


END
