-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize user client cards with system control database
-- =============================================
CREATE     PROCEDURE [SD].[SynchronizeClientUserCard]
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
	 UPDATE [' + @DBNAME + '].[dbo].[MDClientUserCard]
	   SET [ClientUserID] = p.[UserNo]
		  ,[CardTypeId] = p.[CardType]
		  ,[SerialNo] = p.[CardNo]
		  ,[ArticleID] = p.[ArticleNo]
		  ,[CardValidFrom] = p.[CardValidFrom]
		  ,[CardValidUntil] = p.[CardValidUntil]
		  ,[CardIsBlocked] = p.[CardIsBlocked]
		  ,[CardBlockedDate] = p.[CardBlockedDate]
		  ,[Remarks] = p.[Displaytext1]
		  ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
		  FROM [' + @DBNAME + '].[dbo].[MDClientUserCard] i, [' + @PKSRV + '].[PARK_DB].[dbo].[ContractParkingCardsDueToExpire] p
	where i.[ClientUserCardID] = p.[CardNo] COLLATE Modern_Spanish_CS_AS'

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
	SELECT   [CardNo]
			,[UserNo]
			,[CardType]
			,[CardNo]
			,[ArticleNo]
			,[CardValidFrom]
			,[CardValidUntil]
			,[CardIsBlocked]
			,[CardBlockedDate]
			,[Displaytext1]
			,''' + convert(varchar, @updated,  126) + '''
	FROM [' +@PKSRV + '].[PARK_DB].[dbo].[ContractParkingCardsDueToExpire] where [CardNo] COLLATE Modern_Spanish_CS_AS not in (select [ClientUserCardID] from [' + @DBNAME + '].[dbo].[MDClientUserCard])'

	exec(@sql);

END