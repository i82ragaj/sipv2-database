-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Execute summary from all parking in last week
-- =============================================

CREATE   PROCEDURE [dbo].[NavSummaryLastWeek]
AS

declare @dateBegin date = cast(dateadd(dd, -8, getdate()) as date);

while @dateBegin < cast(GETDATE() as date)
begin
	print @dateBegin
	EXEC [dbo].[NavSummaryAllParkingsDate] @dateBegin
	set @dateBegin = dateadd(dd, 1, @dateBegin);
end



