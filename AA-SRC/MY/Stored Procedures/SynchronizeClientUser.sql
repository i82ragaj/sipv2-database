

-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize users clients with system control database
-- =============================================
CREATE     PROCEDURE [MY].[SynchronizeClientUser]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDClientUser]
    SET [ClientID] = p.[ClientMeyparId]
      ,[ClientUserName] = p.[ClientName]
      ,[ClientUserSurname] = cast(p.[ClientSurname1] + '' '' + p.[ClientSurname2] as nvarchar(100))
      ,[Remarks] = p.[Observations]
	  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from  [' + @DBNAME + '].[dbo].[MDClientUser] i, [' + @DBNAME + '].[tmp].[ZClient] p
	where i.[ClientUserID] = p.[ClientMeyparId]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDClientUser]
			([ClientUserID]
           ,[ClientUserName]
           ,[ClientUserSurname]
           ,[ClientID]
           ,[Remarks]
           ,[SerialNo]
           ,[SpaceNo]
           ,[Inserted])
	(SELECT     [ClientMeyparId]
				,[ClientName]
				,cast([ClientSurname1] + '' '' + [ClientSurname2] as nvarchar(100))
				,[ClientMeyparId]
				,[Observations]
				,null
				,null
				,''' + convert(varchar, @updated,  126) + '''
			from [' + @DBNAME + '].[tmp].[ZClient]
			where [ClientMeyparId] not in (Select [ClientUserID] from [' + @DBNAME + '].[dbo].[MDClientUser]))'
	
	exec(@sql);


END