
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- @table: Table to join
-- Return: Nothing
-- Summary:	Join a table using same table from all parkings
-- =============================================

CREATE   PROCEDURE [dbo].[AllpkJoinTable]
@table varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @updated datetime = getdate();
	declare @sql varchar(max) = '';
	declare @ParkingId varchar(10), @ParkingName varchar(100)

	set @sql ='TRUNCATE TABLE [ALLPK].[dbo].[' + @table + ']';
	print @sql

	EXEC(@sql)


	DROP TABLE IF EXISTS #tempcolumnall
	DROP TABLE IF EXISTS #tempcolumnpk

	SELECT COLUMN_NAME name, ORDINAL_POSITION colorder INTO #tempcolumnall
	FROM [ALLPK].INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @table

	SELECT COLUMN_NAME name, ORDINAL_POSITION colorder, 0 flat INTO #tempcolumnpk
	FROM [ALLPK].INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @table and COLUMN_NAME <> 'IDPK'
	UNION 
	SELECT null name, 0 colorder, 1 flat

	DECLARE c CURSOR READ_ONLY FOR
	SELECT [ID], [Name]
	FROM  [dbo].[MDParking]
	WHERE Active = 1

	OPEN c  
	FETCH NEXT FROM c INTO @ParkingId, @ParkingName 

	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @sql ='INSERT INTO [ALLPK].[dbo].[' + @table + '](' +
		STUFF ((
			SELECT ', [' + name + ']'
			FROM #tempcolumnall
			ORDER BY colorder
			FOR XML PATH('')), 1, 1, '') +
				') SELECT ' +

		STUFF ((
			SELECT ', ' + case when flat = 0 then '[' + name + ']' else '''' + @ParkingId + '''' end
			FROM #tempcolumnpk
			ORDER BY colorder
			FOR XML PATH('')), 1, 1, '') +

		' FROM [' + @ParkingId + '].[dbo].[' + @table + ']'

		print @sql
		EXEC(@sql)

		FETCH NEXT FROM c INTO @ParkingId, @ParkingName 
	END

	close c
	deallocate c
END