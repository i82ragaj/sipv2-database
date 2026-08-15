-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
--  @datefrom: Date from which the data will be insert
-- Return: Nothing
-- Summary:	Insert system event records
-- =============================================
CREATE     PROCEDURE [MY].[SSIS-InsertSystemEventReg]
@DBNAME as varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @datefrom as date = null
	declare @NDays int = null
	declare @sql varchar(max);

	if(@DBNAME is null)
		set @DBNAME = DB_NAME();

	select @datefrom = DateFromTable, @NDays = NDays
	from [AA-ADMIN].[dbo].[MDParking] where ID = @DBNAME

	if(@NDays is not null)
		set @datefrom = DATEADD(DAY,-1 * @NDays, cast(getdate() as date))

	if(@datefrom is null)
		set @datefrom = cast(dateadd(dd, -7, getdate()) as date)

	set @sql = '
	delete from [' + @DBNAME + '].[dbo].[TRSystemEventReg] where [SystemEventRegID] >= ''' + convert(varchar, @datefrom, 112) + '''';
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
	  ,[PlateNo]
	  ,[Amount]
      ,[Inserted])
	SELECT 
	NULL,
	i.[DateTimeIncident], 
	i.[TerminalMeyparID], 
	i.[TerminalCodExt], 
	i.[TerminalName], 
	i.[ActionType], 
	NULL,
	i.[ActionName], 
	i.[UserCod], 
	i.[UserName], 
	null, 
	cast(i.[ReasonDesc] as nvarchar(100)) [Remarks], 
	null,
	null,
	getdate()
	FROM [' + @DBNAME + '].[tmp].[ZIncident] i
	where [DateTimeIncident] >= ''' + convert(varchar, @datefrom, 112) + '''';

	exec(@sql);

	set @sql = '
	update [' + @DBNAME + '].[dbo].[TRSystemEventReg] 
	set [SystemEventRegID] = RIGHT(''0000000000''+ cast([DeviceID] as varchar), 10) + ''/'' + convert(varchar, [SystemEventRegTime], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [SystemEventRegTime]) as varchar) + cast(datepart(mi, [SystemEventRegTime]) as varchar) + cast(datepart(ss, [SystemEventRegTime]) as varchar) + cast(datepart(ms, [SystemEventRegTime]) as varchar),9) + ''/'' + [dbo].[getCustomPhysLoc](sys.fn_PhysLocFormatter(%%physloc%%))
	WHERE [SystemEventRegID] is null;'

	exec(@sql);

END