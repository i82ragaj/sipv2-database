CREATE VIEW [dbo].[VUser]
AS
SELECT        [name], lastname, lastname1,  login, email, phone, active, id, 
		(SELECT STUFF (( SELECT ', ' + d.[name] FROM MDUserRol b, MDRol d WHERE b.rolId = d.id and b.userId = a.id and b.active = 1 FOR XML PATH ( '' )) , 1 , 1 , '' )) rols
FROM            dbo.MDUser a