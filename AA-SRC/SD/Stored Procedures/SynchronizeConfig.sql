-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
--	@PKSRV: Vinculed server name of the origin data
-- Return: Nothing
-- Summary:	Execute in order proccedures to sincotronize al configuration tables

CREATE     PROCEDURE [SD].[SynchronizeConfig]
@PKSRV as varchar(10),
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	EXEC [SD].[SynchronizeArticle] @PKSRV, @DBNAME;
	EXEC [SD].[SynchronizeClient] @PKSRV, @DBNAME;
	EXEC [SD].[SynchronizeClientUser] @PKSRV, @DBNAME;
	EXEC [SD].[SynchronizeClientUserCard] @PKSRV, @DBNAME;

	EXEC [SD].[SynchronizeCounter] @PKSRV, @DBNAME;
	EXEC [SD].[SynchronizeDevice] @PKSRV, @DBNAME;
	EXEC [SD].[SynchronizeOperator] @PKSRV, @DBNAME;
	EXEC [SD].[SynchronizeSystemEvent] @PKSRV, @DBNAME;


END
