
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Generate ALLDBPK by join all tables
-- =============================================

CREATE  PROCEDURE [dbo].[AllpkGenerate]
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [dbo].[AllpkJoinTable] @table = N'MDArticle'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDClient'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDClientUser'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDClientUserCard'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDConceptType'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDCounter'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDDevice'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDDeviceType'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDOperator'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDPaymentType'
	EXEC [dbo].[AllpkJoinTable] @table = N'MDSystemEvent'

	EXEC [dbo].[AllpkJoinTable] @table = N'TRCounterReg'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRDailyTotal'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRInvoice'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRMovement'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRParkingTrans'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRPayment'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRShift'
	EXEC [dbo].[AllpkJoinTable] @table = N'TRSystemEventReg'
	
	EXEC [dbo].[AllpkRefreshConfigHistory]

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
			   'ALLDB',
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