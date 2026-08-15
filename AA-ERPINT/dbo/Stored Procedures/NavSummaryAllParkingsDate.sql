-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Execute summary from all parking on a date
-- =============================================
CREATE   PROCEDURE [dbo].[NavSummaryAllParkingsDate]
@summaryDate date = null
AS
BEGIN

	if(@summaryDate is null)
	set @summaryDate = cast(dateadd(dd,-1,getdate()) as date)

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @executioId uniqueidentifier = newid();
	declare @sql varchar(max) = '';
	declare @parkingId varchar(10)

	DECLARE c CURSOR READ_ONLY FOR
	SELECT [ID]
	FROM [AA-ADMIN].[dbo].[MDParking] where [Active] = 1;

	OPEN c  
	FETCH NEXT FROM c INTO @ParkingId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY

		set @sql ='EXEC NavSummaryParkingDate ''' + @parkingId + ''',''' + cast(@summaryDate as varchar) + ''''

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
				,[ExcutionId])
				VALUES
					(NEWID(),
					'NAV',
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
					,null);

			END CATCH

		FETCH NEXT FROM c INTO @ParkingId
	END
	close c
	deallocate c

END

