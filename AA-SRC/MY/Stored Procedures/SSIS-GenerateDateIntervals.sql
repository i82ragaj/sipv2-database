
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Generate the date ranges for the daily procedure
CREATE PROCEDURE [MY].[SSIS-GenerateDateIntervals]
@DBNAME as varchar(10) = null
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @datefrom date = null
	declare @dateto date = null
	declare @NDays int = null

	select @datefrom = DateFromTable, @dateto = DateToTable, @NDays = NDays
	from [AA-ADMIN].[dbo].[MDParking] where ID = @DBNAME

	if(@NDays is not null)
	begin
		set @dateto = cast(getdate() as date)
		set @datefrom = DATEADD(DAY,-1 * @NDays, @dateto)
	end

	if(@datefrom is null)
		set @datefrom = cast(dateadd(dd, -7, getdate()) as date)

	if(@dateto is null)
		set @dateto = cast(getdate() as date);

	declare @sql varchar(max);
	declare @datefromtmp as date = @datefrom;
	declare @i as integer = 0;
	declare @nday integer = 1;

	set @sql ='delete from [' + @DBNAME + '].[tmp].[Ztmp];'
	exec (@sql);

	while (@datefromtmp < @dateto)
	begin
		if(DATEADD(dd, @nday, @datefromtmp) < @dateto)
			set @sql ='INSERT INTO [' + @DBNAME + '].[tmp].[ZTmp](id, dateFrom, dateTo, Processed) VALUES(' + cast(@i as varchar(5)) + ',''' + convert(varchar(20), @datefromtmp, 112) + ''', DATEADD(dd,' + cast(@nday as varchar(3)) + ',''' + convert(varchar(20), @datefromtmp, 112) + '''), ''N'');'
		else
			set @sql ='INSERT INTO [' + @DBNAME + '].[tmp].[ZTmp](id, dateFrom, dateTo, Processed) VALUES(' + cast(@i as varchar(5)) + ',''' + convert(varchar(20), @datefromtmp, 112) + ''',''' + convert(varchar(20), @dateto, 112) + ''', ''N'');'

		exec (@sql);

		set @datefromtmp = DATEADD(dd, @nday, @datefromtmp);
		set @i = @i + 1;
	end
END