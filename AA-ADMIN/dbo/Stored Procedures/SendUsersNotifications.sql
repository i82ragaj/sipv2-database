-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Send users notifications
-- =============================================
CREATE PROCEDURE [dbo].[SendUsersNotifications]
@psubject varchar(max),
@pbody varchar(max),
@pquery varchar(max)
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @emailid varchar(max)
	declare @subjecttmp varchar(max)
	set @subjecttmp = 'Parkia SIP - '

	declare cursor1 CURSOR for
	select distinct u.email 
	from MDUser u 
	where u.active = 1 and exists 
		(select 1 from MDUserRol ur join MDRol r on ur.rolId = r.id 
		 where r.name like 'emailnotif' and u.id = ur.userId)

	open cursor1

	fetch next from cursor1 into @emailid

	while @@FETCH_STATUS = 0
	BEGIN

		exec msdb.dbo.sp_send_dbmail @profile_name='noreply@iccaweb.com',
							@recipients= @emailid,
							@subject= @subjecttmp,
							@body= @pbody,
							@query= @pquery,
							@body_format = 'HTML'

		fetch next from cursor1 into @emailid
			
	END
	close cursor1
	deallocate cursor1
END