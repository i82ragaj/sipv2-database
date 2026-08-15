-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize system event types with system control database
-- =============================================
CREATE     PROCEDURE [MY].[SynchronizeSystemEvent]
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	declare @updated datetime;
	set @updated = getdate();

	declare @sql varchar(max);
	set @sql = '
   
	INSERT INTO [' + @DBNAME + '].[dbo].[MDSystemEvent]
			   ([SystemEventID]
			   ,[SystemEventName]
			   ,[Inserted]
			   ,[Updated])

	select distinct actionType, actionName, getdate(), getdate()
	from [' + @DBNAME + '].[tmp].[ZIncident] WHERE actionType NOT IN (SELECT [SystemEventID] from [' + @DBNAME + '].[dbo].[MDSystemEvent])
	'

	exec(@sql);


END