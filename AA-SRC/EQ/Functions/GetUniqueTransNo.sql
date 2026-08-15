-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [EQ].[GetUniqueTransNo](@dFecha as datetime, @nDeviceNo as smallint, @nTransNo as smallint)
RETURNS varchar(24)
AS
BEGIN
	declare @logid varchar(24);

	set @logid = RIGHT('000'+ cast(@nDeviceNo as varchar), 3) + '/';
	set @logid += convert(varchar, @dFecha, 112) + '/';
	set @logid += RIGHT('000000' + cast(datepart(hh, @dFecha) as varchar) + cast(datepart(mi, @dFecha) as varchar) + cast(datepart(ss, @dFecha) as varchar),6) + '/';
	
	if(@nTransNo > 0)
		set @logid +=  RIGHT('0000'+ cast(@nTransNo as varchar), 4);
	else
		set @logid +=  RIGHT('MMMM'+  cast(datepart(ms, @dFecha) as varchar), 4)

	return @logid;
END
