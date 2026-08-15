
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize users clients with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeClientUser]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDClientUser]
    SET [ClientID] = p.[CustomerNo]
      ,[ClientUserName] = p.[UserFirstName]
      ,[ClientUserSurname] = p.[UserSurname]
      ,[Remarks] = p.[UserRemarks]
      ,[SerialNo] = p.[UserIdTag]
      ,[SpaceNo] = p.[UserSpaceNo]
	  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from  [' + @DBNAME + '].[dbo].[MDClientUser] i, [' + @PKSRV + '].[PARK_DB].[dbo].[Users] p
	where i.[ClientUserID] = p.[UserNo]'

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
	(SELECT     [UserNo]
				,[UserFirstName]				
				,[UserSurname]
				,[CustomerNo]
				,[UserRemarks]
				,[UserIdTag]
				,[UserSpaceNo]
				,''' + convert(varchar, @updated,  126) + '''
			from [' + @PKSRV + '].[PARK_DB].[dbo].[Users]
			where [UserNo] not in (Select [ClientUserID] from [' + @DBNAME + '].[dbo].[MDClientUser]))'
	
	exec(@sql);


END
