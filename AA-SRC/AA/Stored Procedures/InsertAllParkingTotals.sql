

-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Insert and update all totals
-- =============================================
CREATE   PROCEDURE [AA].[InsertAllParkingTotals]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @updated datetime;
	declare @countingDate datetime;
	declare @executioId uniqueidentifier = newid();
	declare @tmpCount int = 0;

	set @updated = getdate();
	set @countingDate = DATEADD(HH, DATEPART(HOUR, @updated), CAST(CONVERT(date, @updated) AS datetime))
	
	declare @DBNAME varchar(10), @ParkingName varchar(100), @type varchar(10);
	declare @sql varchar(max) = '';

	DECLARE c CURSOR READ_ONLY FOR
	SELECT [ID], [Name], [type]
	FROM [AA-ADMIN].[dbo].[MDParking] where [Active] = 1;

	OPEN c  
	FETCH NEXT FROM c INTO @DBNAME, @ParkingName, @type

	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
		if(@type = 'SD')
			set @sql ='EXEC [SD].[InsertParkingTotals] ''' + @DBNAME + '''';
		
		exec(@sql)
		END TRY
			BEGIN CATCH

			INSERT INTO [AA-ADMIN].[dbo].[TRProcessError]
			([ID]
			,[IDPK]
			,[UserName]
			,[ErrorNumber]
			,[ErrorState]
			,[ErrorSeverity]
			,[ErrorLine]
			,[ErrorProcedure]
			,[ErrorMessage]
			,[ErrorDateTime]
			,[ExcutionId]
			,[CreatedBy]
			,[UpdatedBy]
			,[Created]
			,[Updated])
			VALUES
			  (NEWID(),
			   @DBNAME,
			   SUSER_SNAME(),
			   ERROR_NUMBER(),
			   ERROR_STATE(),
			   ERROR_SEVERITY(),
			   ERROR_LINE(),
			   ERROR_PROCEDURE(),
			   ERROR_MESSAGE(),
			   GETDATE()
			   ,null
			   ,'system'
			   ,'system'
			   ,getdate()
			   ,getdate()
			   );

			END CATCH

		FETCH NEXT FROM c INTO @DBNAME, @ParkingName, @type
	END
	close c
	deallocate c

END