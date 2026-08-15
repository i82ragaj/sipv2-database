-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize devices and devicestypes with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeDevice]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDDevice]
    SET [DeviceName] = p.[DeviceDesig]
      ,[DeviceCode] = p.[DeviceAbbr]
      ,[DeviceTypeID] = p.[DeviceType]
	  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDDevice] i,	
	(SELECT distinct [DeviceNo]
			,[DeviceDesig]
			,[DeviceAbbr]
			,[DeviceType]
			from [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents]
			where [DeviceNo] in (Select [DeviceNo] from [' + @DBNAME + '].[dbo].[MDDevice])) p
	where i.[DeviceID] = p.[DeviceNo]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDDevice]
	([DeviceID]
     ,[DeviceName]
     ,[DeviceCode]
     ,[DeviceTypeID]
	,[Inserted])
	(SELECT distinct [DeviceNo]
			,[DeviceDesig]
			,[DeviceAbbr]
			,[DeviceType]
			,''' + convert(varchar, @updated,  126) + '''
			from [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents]
			where [DeviceNo] not in (Select [DeviceID] from [' + @DBNAME + '].[dbo].[MDDevice]))' 

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDDeviceType]
	([DeviceTypeID]
     ,[DeviceTypeName]
	 ,[Inserted])
	SELECT distinct [DeviceTypeID], SUBSTRING([DeviceName],1,(CHARINDEX('' '',[DeviceName] + '' '')-1)), getdate()
	FROM [' + @DBNAME + '].[dbo].[MDDevice]
	WHERE [DeviceTypeID] not in (SELECT [DeviceTypeID] from [' + @DBNAME + '].[dbo].[MDDeviceType])'

	exec(@sql);


END
