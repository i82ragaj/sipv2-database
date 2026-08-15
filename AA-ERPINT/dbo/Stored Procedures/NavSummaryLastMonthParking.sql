-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Execute summary from one parking in last month
-- =============================================

CREATE   PROCEDURE [dbo].[NavSummaryLastMonthParking]
@parkingId varchar(10)
AS

declare @sql varchar(max) = '';
declare @executioId uniqueidentifier = newid();
declare @dateBegin date = cast(dateadd(dd, -30, getdate()) as date);

while @dateBegin < cast(GETDATE() as date)
begin
	print @dateBegin
	
	BEGIN TRY

		set @sql ='EXEC NavSummaryParkingDate ''' + @parkingId + ''',''' + cast(@dateBegin as varchar) + ''''

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
					'PEND',
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


	set @dateBegin = dateadd(dd, 1, @dateBegin);
end



