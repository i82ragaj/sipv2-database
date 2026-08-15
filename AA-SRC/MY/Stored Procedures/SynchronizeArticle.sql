-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 04-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize articles with system control database
-- =============================================

CREATE     PROCEDURE [MY].[SynchronizeArticle]
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
    UPDATE [' + @DBNAME + '].[dbo].[MDArticle]
    SET [ArticleName] = p.[SubscriberProductName]
      ,[ArticleCode] = p.[SubscriberProductCodExt]
      ,[ArticleCategory] = ''SubscriberProduct''
	  ,[ArticleType] = ''A''
      ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDArticle] i, [' + @DBNAME + '].[tmp].[ZSubscriberProduct] p
	where i.[ArticleID] = p.[SubscriberProductMeyparId]'
	
	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDArticle]
	([ArticleID]
	,[ArticleName]
	,[ArticleCode]
	,[ArticleCategory]
	,[ArticleType]
	,[Inserted])
	(SELECT    [SubscriberProductMeyparId]
			  ,[SubscriberProductName]
			  ,[SubscriberProductCodExt]
			  ,''SubscriberProduct''
			  ,''A''
			  ,''' + convert(varchar, @updated,  126) + '''
			from [' + @DBNAME + '].[tmp].[ZSubscriberProduct]
			where [SubscriberProductMeyparId] not in (Select [ArticleID] from [' + @DBNAME + '].[dbo].[MDArticle]))'
	
	exec(@sql);
	
END