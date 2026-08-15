
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Check error in last hour and send users notifications
-- =============================================

CREATE PROCEDURE [dbo].[CheckErrorsAndSendUsers]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @count integer = 0
 
	select @count = count(*) from [dbo].[TRProcessError] where [ErrorDateTime] > dateadd(hh,-1,getdate())

	if(@count > 0)
	begin
		declare @tmp varchar(max) = 'SIP - Informe de errores en la ultima hora';
		declare @queryTmp varchar(2000) = 'select * from [dbo].[TRProcessError] where [ErrorDateTime] > dateadd(hh,-1,getdate()) order by [ErrorDateTime]';
		
		EXEC [dbo].[SendUsersNotifications] @tmp, @tmp, @queryTmp
	end
END
