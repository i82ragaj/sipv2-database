-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize articles with system control database
-- =============================================

CREATE     PROCEDURE [MY].[SynchronizeDevice]
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
	truncate table [' + @DBNAME + '].[tmp].[TerminalsTmp];'
	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].[TerminalsTmp]
	SELECT distinct [TerminalMeyparID] 
		  ,[TerminalCodExt]
		  ,[TerminalName]
		  ,[TerminalType]
		  ,[TerminalTypeName] 
	FROM [' + @DBNAME + '].[tmp].[ZExit]
	UNION 
	SELECT distinct [TerminalMeyparID]
		  ,[TerminalCodExt]
		  ,[TerminalName]
		  ,[TerminaalType]
		  ,[TerminalTypeName]
	FROM [' + @DBNAME + '].[tmp].[ZEntry]
	UNION
	SELECT distinct [TerminalMeyparID]
		  ,[TerminalCodExt]
		  ,[TerminalName]
		  ,[TerminalType]
		  ,[TerminalTypeName]
	FROM [' + @DBNAME + '].[tmp].[ZIncident]
	UNION 
	SELECT distinct [TerminalMeyparID]
		  ,[TerminalCodExt]
		  ,[TerminalName]
		  ,[TerminalType]
		  ,[TerminalTypeName]
	FROM [' + @DBNAME + '].[tmp].[ZPayment]'

	exec(@sql);

	set @sql = '
    UPDATE [' + @DBNAME + '].[dbo].[MDDevice]
    SET [DeviceName] = p.[TerminalName]
      ,[DeviceCode] = p.[TerminalCodExt]
      ,[DeviceTypeID] = p.[TerminalType]
	  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDDevice] i, [' + @DBNAME + '].[tmp].[TerminalsTmp] p
	where i.[DeviceID] = p.[TerminalMeyparID]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDDevice]
	([DeviceID]
     ,[DeviceName]
     ,[DeviceCode]
     ,[DeviceTypeID]
	,[Inserted])
	(SELECT distinct [TerminalMeyparID]
			,[TerminalName]
			,[TerminalCodExt]
			,[TerminalType]
			,''' + convert(varchar, @updated,  126) + '''
			from [' + @DBNAME + '].[tmp].[TerminalsTmp]
			where [TerminalMeyparID] not in (Select [DeviceID] from [' + @DBNAME + '].[dbo].[MDDevice]))' 

	exec(@sql);


END