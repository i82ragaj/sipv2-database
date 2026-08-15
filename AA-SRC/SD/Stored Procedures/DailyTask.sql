-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Execute the daily process for a parking

CREATE PROCEDURE [SD].[DailyTask]
@DBNAME as varchar(10) = null
AS
declare @PKSRV as varchar(10)
declare @datefrom date = null
declare @dateto date = null
declare @NDays int = null
declare @TruncateTables bit = null	
declare @dateinit datetime = getdate();

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;


BEGIN TRY
	
	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	declare @sql varchar(max);
	select @PKSRV = SRV, @datefrom = DateFromTable, @dateto = DateToTable, @NDays = NDays, @TruncateTables = TruncateTables 
	from [AA-ADMIN].[dbo].[MDParking] where ID = @DBNAME
	
	if(@NDays is not null)
	begin
		set @dateto = cast(getdate() as date)
		set @datefrom = DATEADD(DAY,-1 * @NDays, @dateto)
	end
	
	EXEC [AA].[MoveDataToHistory] @DBNAME

	if(@TruncateTables = 1)
		EXEC [AA].[TruncateTables] @DBNAME
		
	UPDATE [AA-ADMIN].[dbo].[MDParking] set LastImportedStatus = 'INICIADA' where ID = @DBNAME

	EXEC [SD].[SynchronizeConfig] @PKSRV, @DBNAME;
	EXEC [SD].[InsertZTables] @PKSRV, @DBNAME, @datefrom, @dateto;
	
	EXEC [SD].[InsertSystemEventReg] @PKSRV, @DBNAME;
	EXEC [SD].[InsertTransactionalData] @DBNAME, @datefrom;

	UPDATE [AA-ADMIN].[dbo].[MDParking] set LastImported = getdate(), LastImportedStatus = 'OK', LastImportedOK = getdate(), LastImportedDuration =  getdate() - @dateinit where ID = @DBNAME

	INSERT INTO [AA-ADMIN].[dbo].[TRImportProcess]([ID],[IDPK],[Begin],[End],[Duration],[Status],[Description])
	VALUES (NEWID(), @DBNAME, @dateinit, getdate(), getdate() - @dateinit, 'OK', '')

END TRY


BEGIN CATCH
	UPDATE [AA-ADMIN].[dbo].[MDParking] set LastImported = getdate(), LastImportedStatus = 'ERROR', LastImportedDuration =  getdate() - @dateinit where ID = @DBNAME
    
	INSERT INTO [AA-ADMIN].[dbo].[TRImportProcess]([ID],[IDPK],[Begin],[End],[Duration],[Status],[Description])
	VALUES (NEWID(), @DBNAME, @dateinit, getdate(), getdate() - @dateinit, 'ERROR', ERROR_MESSAGE())
	INSERT INTO [AA-ADMIN].[dbo].[TRProcessError]
	([ID]
	,[IDPK]
    ,[UserName]
    ,[ErrorNumber]
    ,[ErrorState]
    ,[ErrorSeverity]
    ,[ErrorLine]
    ,[ErrorProcedure]
    ,[ErrorMessage]
    ,[ErrorDateTime]
    ,[ExcutionId])
    VALUES
	  (NEWID(),
	   @DBNAME,
	   SUSER_SNAME(),
	   ERROR_NUMBER(),
	   ERROR_STATE(),
	   ERROR_SEVERITY(),
	   ERROR_LINE(),
	   ERROR_PROCEDURE(),
	   ERROR_MESSAGE(),
	   GETDATE()
	   ,null);

	--Launc exception to detect execution fail
	THROW;

END CATCH
