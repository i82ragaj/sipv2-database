-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@PKSRV: Vinculed server name of the origin data
--	@DBNAME: Parking ID in system
--  @datefrom: Date from which the data will be insert
-- Return: Nothing
-- Summary:	Insert system event records
-- =============================================
CREATE     PROCEDURE [SD].[InsertSystemEventReg]
@PKSRV as varchar(10),
@DBNAME as varchar(10) = null,
@datefrom as date = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @sql varchar(max);

	if(@datefrom is null)
		set @datefrom = cast(dateadd(dd, -7, getdate()) as date)

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

    set @sql = '
	delete from [' + @DBNAME + '].[dbo].[TRSystemEventReg] where [SystemEventRegTime] >= ''' + convert(varchar, @datefrom, 112) + '''';
	EXEC(@sql)


	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[TRSystemEventReg]
	(  [SystemEventRegID]
      ,[SystemEventRegTime]
      ,[DeviceID]
      ,[DeviceCode]
      ,[DeviceName]
      ,[SystemEventID]
      ,[SystemEventCode]
      ,[SystemEventName]
      ,[OperatorID]
      ,[OperatorName]
      ,[OperatorSurname]
      ,[Remarks]
      ,[Inserted])
	SELECT 
    NULL
    ,[Time]
    ,cast([DeviceNo] as varchar(40))
    ,cast([DeviceAbbr] as  varchar(10))
    ,cast([DeviceDesig] as nvarchar(50))
    ,cast([SysEventNo] as varchar(40))
    ,cast([SystemEventRegNo] as varchar(10))
	,cast([SysEventDesig] as varchar(50))
    ,cast([StaffCode] as varchar(40))
    ,cast([OperatorFirstName] as nvarchar(50))
    ,cast([OperatorSurname] as nvarchar(50))
    ,cast([Remarks] as nvarchar(100))
	,getdate()  
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[SystemEvents] where [Time] >= ''' + convert(varchar, @datefrom, 112) + '''';

    EXEC(@sql);

	set @sql = '
	update [' + @DBNAME + '].[dbo].[TRSystemEventReg] 
	set [SystemEventRegID] = RIGHT(''000''+ cast([DeviceID] as varchar), 3) + ''/'' + convert(varchar, [SystemEventRegTime], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [SystemEventRegTime]) as varchar) + cast(datepart(mi, [SystemEventRegTime]) as varchar) + cast(datepart(ss, [SystemEventRegTime]) as varchar) + cast(datepart(ms, [SystemEventRegTime]) as varchar),9) + ''/'' + [dbo].[getCustomPhysLoc](sys.fn_PhysLocFormatter(%%physloc%%))
	WHERE [SystemEventRegID] is NULL'

	EXEC(@sql);

END