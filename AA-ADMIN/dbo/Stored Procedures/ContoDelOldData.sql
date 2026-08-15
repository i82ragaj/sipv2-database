
-- =============================================
-- Author: Juan Fco Ramírez García
-- Date: 03-2026
-- Params:
-- Return: Nothing
-- Summary:	Move counter to history
-- =============================================

CREATE PROCEDURE [dbo].[ContoDelOldData]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [AA-CONTO].[dbo].[TRCounterReg]
	WHERE  CounterDate < dateadd(dd, -30, cast(getdate() as date))

	DELETE FROM [AA-CONTO].[dbo].[TRDailyTotal]
	WHERE  TotalDate < dateadd(dd, -30, cast(getdate() as date))

END