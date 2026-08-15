-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
--	@DBNAME: Parking ID in system
-- Return: Nothing
-- Summary:	Syncronize articles with system control database
-- =============================================

CREATE     PROCEDURE [SD].[SynchronizeArticle]
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
	truncate table [' + @DBNAME + '].[tmp].ArticlesTmp;'
	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].ArticlesTmp(
			[ArticleNo]
		   ,[ArticleDesig]
           ,[ArticleAbbr]
           ,[ArticleCategory]
           ,[ArticleType])
	SELECT distinct 
		  [ArticleNo]
		  ,[ArticleDesig]
		  ,[ArticleAbbr]
		  ,''Rotación'' [ArticleCategory]
		  ,''R'' [ArticleType] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[ParkingMovements]'
	
	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].ArticlesTmp(
			[ArticleNo]
		   ,[ArticleDesig]
           ,[ArticleAbbr]
           ,[ArticleCategory]
           ,[ArticleType])
	SELECT distinct
		  [ArticleNo]
		  ,[ArticleDesig]
		  ,[ArticleAbbr]
		  ,[ArticleCategory]
		  ,''R'' [ArticleType] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueParkingTrans] 
	where [ArticleNo] not in (select [ArticleNo] from [' + @DBNAME + '].[tmp].ArticlesTmp)'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].ArticlesTmp(
		[ArticleNo]
		,[ArticleDesig]
        ,[ArticleAbbr]
        ,[ArticleCategory]
        ,[ArticleType])
	SELECT distinct
		  [ArticleNo]
		  ,[ArticleDesig]
		  ,[ArticleAbbr]
		  ,[ArticleCategory]
		  ,''A'' [ArticleType] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[ParkingTransWithoutTurnover]
	where [ArticleNo] not in (select [ArticleNo] from [' + @DBNAME + '].[tmp].[ArticlesTmp])'

	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[tmp].ArticlesTmp(
			[ArticleNo]
		   ,[ArticleDesig]
           ,[ArticleAbbr]
           ,[ArticleCategory]
           ,[ArticleType])
	SELECT distinct
		  [ArticleNo]
		  ,[ArticleDesig]
		  ,[ArticleAbbr]
		  ,[ArticleCategory]
		  ,''A'' [ArticleType] 
	FROM [' + @PKSRV + '].[PARK_DB].[dbo].[RevenueSales]
	where [ArticleNo] not in (select [ArticleNo] from [' + @DBNAME + '].[tmp].[ArticlesTmp])'

	exec(@sql);

	set @sql = '
    UPDATE [' + @DBNAME + '].[dbo].[MDArticle]
    SET [ArticleName] = p.[ArticleDesig]
      ,[ArticleCode] = p.[ArticleAbbr]
      ,[ArticleCategory] = p.[ArticleCategory]
      ,[Updated] = ''' + convert(varchar, @updated,  126) + '''
	from [' + @DBNAME + '].[dbo].[MDArticle] i, [' + @DBNAME + '].[tmp].[ArticlesTmp] p
	where i.[ArticleID] = p.[ArticleNo]'
	
	exec(@sql);

	set @sql = '
	INSERT INTO [' + @DBNAME + '].[dbo].[MDArticle]
	([ArticleID]
	,[ArticleName]
	,[ArticleCode]
	,[ArticleCategory]
	,[ArticleType]
	,[Inserted])
	(SELECT    [ArticleNo]
			  ,[ArticleDesig]
			  ,[ArticleAbbr]
			  ,[ArticleCategory]
			  ,[ArticleType]
			  ,''' + convert(varchar, @updated,  126) + '''
			from [' + @DBNAME + '].[tmp].ArticlesTmp
			where [ArticleNo] not in (Select [ArticleID] from [' + @DBNAME + '].[dbo].[MDArticle]))'
	
	exec(@sql);

	set @sql = '
	update [' + @DBNAME + '].[dbo].[MDArticle] set [ArticleType]  = ''A'' where  
	([ArticleName] like ''%Bono%'' 
	 or [ArticleCategory] like ''%Bono%''
	 or [ArticleName] like ''%abonado%''
	 or [ArticleCategory] like ''%TA. Permanente%'');'
	
	exec(@sql);

END