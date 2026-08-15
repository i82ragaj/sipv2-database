
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize operators with system control database
-- =============================================
CREATE     PROCEDURE [MY].[SynchronizeOperator]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDOperator]
    SET [OperatorName] = p.[UserName],
	    [Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDOperator] i, 	
	(SELECT distinct [UserCod]
			,[UserName]
			from [' + @DBNAME + '].[tmp].[ZIncident]
			where [UserCod] in (Select [OperatorID] from [' + @DBNAME + '].[dbo].[MDOperator])) p
	where i.[OperatorID] = p.[UserCod]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDOperator]
	([OperatorID]
     ,[OperatorName]
	 ,[Inserted])
	(SELECT distinct [UserCod]
			,[UserName]
			,''' + convert(varchar, @updated,  126) + '''
			from [' + @DBNAME + '].[tmp].[ZIncident]
			where [UserCod] not in (Select [OperatorID] from [' + @DBNAME + '].[dbo].[MDOperator]))' 

	exec(@sql);

END