
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize user client cards with system control database
-- =============================================
CREATE     PROCEDURE [MY].[SynchronizeClientUserCard]
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
	 UPDATE [' + @DBNAME + '].[dbo].[MDClientUserCard]
	   SET [ClientUserID] = null
		  ,[CardTypeId] = null
		  ,[SerialNo] = p.[SubscriberContractCodExt]
		  ,[ArticleID] = p.[SubscriberProductMeyparId]
		  ,[CardValidFrom] = p.[ContractValidityStartDate]
		  ,[CardValidUntil] = p.[ContractValidityEndDate]
		  ,[CardIsBlocked] = null
		  ,[CardBlockedDate] = null
		  ,[Remarks] = null
		  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
		  FROM  [' + @DBNAME + '].[tmp].[ZSubscriberContract] p
	where [ClientUserCardID] = p.[SubscriberContractMeyparId]'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDClientUserCard]
			([ClientUserCardID]
           ,[ClientUserID]
		   ,[CardTypeId]
           ,[SerialNo]
           ,[ArticleID]
           ,[CardValidFrom]
           ,[CardValidUntil]
           ,[CardIsBlocked]
           ,[CardBlockedDate]
           ,[Remarks]
           ,[Inserted])
	SELECT   [SubscriberContractMeyparId]
			,null
			,null
			,[SubscriberContractCodExt]
			,[SubscriberProductMeyparId]
			,[ContractValidityStartDate]
			,[ContractValidityEndDate]
			,null
			,null
			,null
			,''' + convert(varchar, @updated,  126) + '''
	FROM [' + @DBNAME + '].[tmp].[ZSubscriberContract] where [SubscriberContractMeyparId] is not null AND
	[SubscriberContractMeyparId] not in (select [ClientUserCardID] from [' + @DBNAME + '].[dbo].[MDClientUserCard])'

	exec(@sql);

END