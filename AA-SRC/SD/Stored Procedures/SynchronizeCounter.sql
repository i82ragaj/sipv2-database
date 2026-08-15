-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize counters with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeCounter]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDCounter]
    SET [CounterName] = p.[CountingCategory]
    ,[OccupancyLimit] = p.[OccupancyLimit]
	,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDCounter] i, [' + @PKSRV + '].[PARK_DB].[dbo].[CPCounting] p
	where i.[CounterID] = p.[CountingCategoryNo] + (p.[CarparkNo] * 100)'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDCounter]
	( [CounterID]
      ,[CounterName]
      ,[OccupancyLimit]
	  ,[Inserted])
	(SELECT  [CountingCategoryNo] + ([CarparkNo] * 100)
			,[CountingCategory]
			,[OccupancyLimit]
			,''' + convert(varchar, @updated,  126) + '''
			from [' + @PKSRV + '].[PARK_DB].[dbo].[CPCounting]
			where [CountingCategoryNo] + ([CarparkNo] * 100) not in (Select [CounterID] from [' + @DBNAME + '].[dbo].[MDCounter]))'

	exec(@sql);

END
