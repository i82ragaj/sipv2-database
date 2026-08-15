
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Resfresh ALLDBPK-HIST config
-- =============================================

CREATE  PROCEDURE [dbo].[AllpkRefreshConfigHistory]
AS

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

truncate table [ALLPK-HIST].[dbo].[MDArticle]
truncate table [ALLPK-HIST].[dbo].[MDClient]
truncate table [ALLPK-HIST].[dbo].[MDClientUser]
truncate table [ALLPK-HIST].[dbo].[MDClientUserCard]
truncate table [ALLPK-HIST].[dbo].[MDConceptType]
truncate table [ALLPK-HIST].[dbo].[MDCounter]
truncate table [ALLPK-HIST].[dbo].[MDDevice]
truncate table [ALLPK-HIST].[dbo].[MDDeviceType]
truncate table [ALLPK-HIST].[dbo].[MDOperator]
truncate table [ALLPK-HIST].[dbo].[MDPaymentType]
truncate table [ALLPK-HIST].[dbo].[MDSystemEvent]

insert into [ALLPK-HIST].[dbo].[MDArticle] select * from [ALLPK].[dbo].[MDArticle]
insert into [ALLPK-HIST].[dbo].[MDClient] select * from [ALLPK].[dbo].[MDClient]
insert into [ALLPK-HIST].[dbo].[MDClientUser] select * from [ALLPK].[dbo].[MDClientUser]
insert into [ALLPK-HIST].[dbo].[MDClientUserCard] select * from [ALLPK].[dbo].[MDClientUserCard]
insert into [ALLPK-HIST].[dbo].[MDConceptType] select * from [ALLPK].[dbo].[MDConceptType]
insert into [ALLPK-HIST].[dbo].[MDCounter] select * from [ALLPK].[dbo].[MDCounter]
insert into [ALLPK-HIST].[dbo].[MDDevice] select * from [ALLPK].[dbo].[MDDevice]
insert into [ALLPK-HIST].[dbo].[MDDeviceType] select * from [ALLPK].[dbo].[MDDeviceType]
insert into [ALLPK-HIST].[dbo].[MDOperator] select * from [ALLPK].[dbo].[MDOperator]
insert into [ALLPK-HIST].[dbo].[MDPaymentType] select * from [ALLPK].[dbo].[MDPaymentType]
insert into [ALLPK-HIST].[dbo].[MDSystemEvent] select * from [ALLPK].[dbo].[MDSystemEvent]