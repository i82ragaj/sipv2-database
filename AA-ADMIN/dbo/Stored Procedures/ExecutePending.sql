
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Execute jobs pending
-- =============================================

CREATE   PROCEDURE [dbo].[ExecutePending]
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @NumInit integer = 0
	declare @Job varchar(100) = null

	select @NumInit = count(*) from [dbo].[MDParkingStatus] where LastImportedStatus like 'INICIADA%'

	if @NumInit < 5
	begin
		select @Job = Job from [dbo].[MDParkingStatus] a join [dbo].[MDParking] b on a.ID = b.ID 
		where LastImportedStatus = 'PENDIENTE'
		if @Job is not null
			EXEC msdb.dbo.sp_start_job @Job
	end
	else
		print ('Numero máximo de procesos activos')
END TRY

BEGIN CATCH

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
			   'PEND',
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

END CATCH