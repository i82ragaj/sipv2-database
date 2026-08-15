CREATE TABLE [dbo].[TRDailyTotal] (
    [TotalDate]            DATETIME        NOT NULL,
    [DailyTotalAmount]     DECIMAL (18, 2) NULL,
    [DailyTransWithPay]    INT             NULL,
    [DailyTransWithOutPay] INT             NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_TRDailyTotal]
    ON [dbo].[TRDailyTotal]([TotalDate] ASC);

