-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize system event types with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeSystemEvent]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDSystemEvent]
    SET [SystemEventName] = p.[SysEventDesig]
	  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDSystemEvent] i,  
	(SELECT distinct [SysEventNo]
			,[SysEventDesig]
			from [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents]
			where cast([SysEventNo] as varchar) + [SysEventDesig] COLLATE Modern_Spanish_CS_AS in (Select cast([SystemEventID] as varchar)+[SystemEventName] from [' + @DBNAME + '].[dbo].[MDSystemEvent])) p
	where i.[SystemEventID] = p.[SysEventNo] and i.[SystemEventName] = p.[SysEventDesig] COLLATE Modern_Spanish_CS_AS'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDSystemEvent]
	([SystemEventID]
    ,[SystemEventName]
	,[Inserted])
	(SELECT distinct [SysEventNo]
			,[SysEventDesig]
			,''' + convert(varchar, @updated,  126) + '''
			from [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents]
			where cast([SysEventNo] as varchar) + [SysEventDesig] COLLATE Modern_Spanish_CS_AS not in (Select cast([SystemEventID] as varchar)+[SystemEventName] from [' + @DBNAME + '].[dbo].[MDSystemEvent]))'

	exec(@sql);

END
