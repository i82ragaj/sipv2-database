-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
--  @datefrom: Date from which the data will be insert
-- Return: Nothing
-- Summary:	Insert system event records
-- =============================================
CREATE     PROCEDURE [EQ].[SSIS-InsertSystemEventReg]
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
	i.[fechor], 
	d.[DeviceID], 
	d.[DeviceCode], 
	d.[DeviceName], 
	e.[SystemEventID], 
	NULL,
	e.[SystemEventName], 
	o.[OperatorID], 
	o.[OperatorName], 
	o.[OperatorSurname], 
	cast(i.[infvar] as nvarchar(100)) [Remarks], 
	cast(i.[matrec] as varchar(40)),
	cast(case when [imp] > 0 then [imp] else 0 end as decimal(18,4)) [imp],
	getdate()
	FROM [' + @DBNAME + '].[tmp].[Zinc] i left join [' + @DBNAME + '].[dbo].[MDDevice] d on d.[DeviceID] = i.[numapa] and d.[DeviceTypeID] = i.[tipapa]
	left join[' + @DBNAME + '].[dbo].[MDSystemEvent] e on e.[SystemEventID] = i.[codtipinc]
	left join[' + @DBNAME + '].[dbo].[MDOperator] o on o.[OperatorID] = i.[codope]
	where [fechor] >= ''' + convert(varchar, @datefrom, 112) + '''';

	EXEC(@sql);

	set @sql = '
	update [' + @DBNAME + '].[dbo].[TRSystemEventReg] 
	set [SystemEventRegID] = RIGHT(''000''+ cast([DeviceID] as varchar), 3) + ''/'' + convert(varchar, [SystemEventRegTime], 112) + ''/'' +	RIGHT(''000000'' + cast(datepart(hh, [SystemEventRegTime]) as varchar) + cast(datepart(mi, [SystemEventRegTime]) as varchar) + cast(datepart(ss, [SystemEventRegTime]) as varchar) + cast(datepart(ms, [SystemEventRegTime]) as varchar),9) + ''/'' + [dbo].[getCustomPhysLoc](sys.fn_PhysLocFormatter(%%physloc%%))
	WHERE [SystemEventRegID] is null;'

	EXEC(@sql);

END
