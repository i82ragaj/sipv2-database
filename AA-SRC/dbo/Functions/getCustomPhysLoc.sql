

CREATE FUNCTION [dbo].[getCustomPhysLoc](@id as varchar(24))
RETURNS varchar(24)
AS
BEGIN
	return replace(replace(replace(@id, '(', ''), ')', ''), ':', '/')
END
