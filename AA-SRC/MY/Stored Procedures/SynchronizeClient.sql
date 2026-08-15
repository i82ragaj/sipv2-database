

-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize clients with system control database
-- =============================================
CREATE     PROCEDURE [MY].[SynchronizeClient]
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
	   SET [ClientName] = p.[ClientName]
		  ,[ClientSurname] = cast(p.[ClientSurname1] + '' '' + p.[ClientSurname2] as nvarchar(100))
		  ,[Address] = p.[ClientAddress]
		  ,[ZipCode] = cast(p.[ClientPostalCode] as varchar(10))
		  ,[City] = p.[ClientCity]
		  ,[Country] = p.[ClientCountry]
		  ,[VATID] = p.[ClientIdenDocument]
		  ,[Telephone] = p.[ClientPhone]
		  ,[Email] = p.[ClientEmail]
		  ,[ClientBeginDate] = p.[RegistrationDate]
		  ,[ClientEndDate] = p.[TerminationDate]
		  ,[Remarks] = p.[Observations]
		  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDClient] i, [' + @DBNAME + '].[tmp].[ZClient] p
	where i.[ClientID] = p.[ClientMeyparId]'

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
           ,[VATID]
           ,[Telephone]
           ,[Email]
           ,[ClientBeginDate]
           ,[ClientEndDate]
           ,[Remarks]
           ,[Inserted])
	(SELECT     [ClientMeyparId]
				,[ClientName]
				,cast([ClientSurname1] + '' '' + [ClientSurname2] as nvarchar(100))
				,[ClientAddress]
				,cast([ClientPostalCode] as varchar(10))
				,[ClientCity]
				,[ClientCountry]
				,[ClientIdenDocument]
				,[ClientPhone]
				,[ClientEmail]
				,[RegistrationDate]
				,[TerminationDate]
				,[Observations]
				,''' + convert(varchar, @updated,  126) + '''
			from [' + @DBNAME + '].[tmp].[ZClient]
			where [ClientMeyparId] not in (Select [ClientID] from [' + @DBNAME + '].[dbo].[MDClient]))' 

	exec(@sql);

END