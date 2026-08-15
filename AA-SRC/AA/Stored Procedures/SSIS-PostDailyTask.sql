

-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Record information as part of daily routine


CREATE     PROCEDURE [AA].[SSIS-PostDailyTask]
@DBNAME as varchar(10) = null,
@dateinit as datetime,
@status as varchar(10),
@errorNumber as int = 0, 
@errorDescription as varchar(500) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	IF NOT EXISTS (
    SELECT 1 
    FROM [AA-ADMIN].[dbo].[MDParkingStatus]
    WHERE ID  = @DBNAME
	)
	BEGIN
	INSERT INTO [dbo].[MDParkingStatus]
			   ([ID]
			   ,[Active]
			   ,[CreatedBy]
			   ,[UpdatedBy]
			   ,[Created]
			   ,[Updated]
			   ,[LastImported]
			   ,[LastImportedStatus]
			   ,[LastImportedOK]
			   ,[LastCountTotals]
			   ,[LastCountTotalsStatus]
			   ,[LastImportedDuration])
		 VALUES
			   (@DBNAME
			   ,1
			   ,'system'
			   ,'system'
			   ,getdate()
			   ,getdate()
			   ,null
			   ,null
			   ,null
			   ,null
			   ,null
			   ,null)
	END

	if(@status = 'OK')
	begin
		
		UPDATE [AA-ADMIN].[dbo].[MDParkingStatus] set LastImported = getdate(), LastImportedStatus = 'OK', 
		LastImportedOK = getdate(), LastImportedDuration =  getdate() - @dateinit,
		[UpdatedBy] = 'system', [Updated] = getdate()
		where ID = @DBNAME

		INSERT INTO [AA-ADMIN].[dbo].[TRImportProcess]([ID],[IDPK],[Begin],[End],[Duration],[Status],[Description]
		,[CreatedBy],[UpdatedBy],[Created],[Updated])
		VALUES (NEWID(), @DBNAME, @dateinit, getdate(), getdate() - @dateinit, 'OK', ''
		,'system','system',getdate(),getdate())

		--Move data to history
		EXECUTE [AA].[MoveDataToHistory] @DBNAME

		--Remove old data client information 
		EXECUTE [AA].[DeleteClientsOldInformation] @DBNAME


	end

	if(@status = 'ERROR')
	begin

		UPDATE [AA-ADMIN].[dbo].[MDParkingStatus] set LastImported = getdate(), LastImportedStatus = 'ERROR', 
		LastImportedDuration =  getdate() - @dateinit, 
		[UpdatedBy] = 'system', [Updated] = getdate()
		where ID = @DBNAME
    
		INSERT INTO [AA-ADMIN].[dbo].[TRImportProcess]([ID],[IDPK],[Begin],[End],[Duration],[Status],[Description]
		,[CreatedBy],[UpdatedBy],[Created],[Updated])
		VALUES (NEWID(), @DBNAME, @dateinit, getdate(), getdate() - @dateinit, 'ERROR', ERROR_MESSAGE()
		,'system','system',getdate(),getdate())

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
		,[ExcutionId]
		,[CreatedBy]
		,[UpdatedBy]
		,[Created]
		,[Updated])
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
		   ,null
		   ,'system'
		   ,'system'
		   ,getdate()
		   ,getdate()
		   );


	end

END