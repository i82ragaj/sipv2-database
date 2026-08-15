CREATE TABLE [dbo].[TRDailyTotal] (
    [IDPK]                 VARCHAR (10)    NOT NULL,
    [TotalDate]            DATETIME        NOT NULL,
    [DailyTotalAmount]     DECIMAL (18, 2) NULL,
    [DailyTransWithPay]    INT             NULL,
    [DailyTransWithOutPay] INT             NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_TRDailyTotal]
    ON [dbo].[TRDailyTotal]([IDPK] ASC, [TotalDate] ASC);

