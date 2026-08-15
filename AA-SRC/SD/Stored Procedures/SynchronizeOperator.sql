-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize operators with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeOperator]
@PKSRV as varchar(10),
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
    SET [OperatorName] = p.[OperatorFirstName],
	    [OperatorSurname] = p.[OperatorSurname],
	    [Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDOperator] i, 	
	(SELECT distinct [StaffCode]
			,[OperatorSurname]
			,[OperatorFirstName]
			from [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents]
			where [StaffCode] in (Select [OperatorID] from [' + @DBNAME + '].[dbo].[MDOperator])) p
	where i.[OperatorID] = p.[StaffCode]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDOperator]
	([OperatorID]
     ,[OperatorName]
     ,[OperatorSurname]
	 ,[Inserted])
	(SELECT distinct [StaffCode]
			,[OperatorFirstName]
			,[OperatorSurname]
			,''' + convert(varchar, @updated,  126) + '''
			from [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents]
			where [StaffCode] not in (Select [OperatorID] from [' + @DBNAME + '].[dbo].[MDOperator]))' 

	exec(@sql);

END
