-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
--	@PKSRV: Vinculed server name of the origin data
-- Return: Nothing
-- Summary:	Execute in order proccedures to sincotronize al configuration tables

CREATE     PROCEDURE [MY].[SynchronizeConfig]
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	EXEC [MY].[SynchronizeArticle] @DBNAME;
	EXEC [MY].[SynchronizeClient] @DBNAME;
	EXEC [MY].[SynchronizeClientUser] @DBNAME;
	EXEC [MY].[SynchronizeClientUserCard] @DBNAME;
	
	EXEC [MY].[SynchronizeSystemEvent] @DBNAME;
	EXEC [MY].[SynchronizeDevice] @DBNAME;
	EXEC [MY].[SynchronizeOperator] @DBNAME;

	--EXEC [MY].[SynchronizeCounter] @DBNAME;


END