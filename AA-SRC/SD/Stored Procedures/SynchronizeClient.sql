
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize clients with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeClient]
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
	UPDATE [' + @DBNAME + '].[dbo].[MDClient]
	   SET [ClientName] = p.[CustomerFirstName]
		  ,[ClientSurname] = p.[CustomerSurname]
		  ,[Address] = p.[Street]
		  ,[ZipCode] = p.[ZipCode]
		  ,[City] = p.[City]
		  ,[Country] = p.[Country]
		  ,[Nationality] = p.[Nationality]
		  ,[VATID] = p.[IdDocumentNo]
		  ,[Telephone] = p.[Telephone]
		  ,[Email] = p.[CustomerEmail]
		  ,[ClientBeginDate] = p.[RentalAgmtBeginDate]
		  ,[ClientEndDate] = p.[RentalAgmtTerminationDate]
		  ,[Remarks] = p.[CustomerRemarks]
		  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDClient] i, [' + @PKSRV + '].[PARK_DB].[dbo].[Customers] p
	where i.[ClientID] = p.[CustomerNo]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDClient]
			([ClientID]
           ,[ClientName]
           ,[ClientSurname]
           ,[Address]
           ,[ZipCode]
           ,[City]
           ,[Country]
           ,[Nationality]
           ,[VATID]
           ,[Telephone]
           ,[Email]
           ,[ClientBeginDate]
           ,[ClientEndDate]
           ,[Remarks]
           ,[Inserted])
	(SELECT     [CustomerNo]
				,[CustomerFirstName]
				,[CustomerSurname]
				,[Street]
				,[ZipCode]
				,[City]
				,[Country]
				,[Nationality]
				,[IdDocumentNo]
				,[Telephone]
				,[CustomerEmail]
				,[RentalAgmtBeginDate]
				,[RentalAgmtTerminationDate]
				,[CustomerRemarks]
				,''' + convert(varchar, @updated,  126) + '''
			from [' + @PKSRV + '].[PARK_DB].[dbo].[Customers]
			where [CustomerNo] not in (Select [ClientID] from [' + @DBNAME + '].[dbo].[MDClient]))' 

	exec(@sql);

END