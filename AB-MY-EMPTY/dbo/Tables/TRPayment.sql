CREATE TABLE [dbo].[TRPayment] (
    [PaymentID]       VARCHAR (50)    NOT NULL,
    [PaymentTime]     DATETIME        NOT NULL,
    [PaymentTypeID]   VARCHAR (40)    NULL,
    [ConceptTypeID]   VARCHAR (40)    NULL,
    [DeviceID]        VARCHAR (40)    NULL,
    [DeviceCode]      VARCHAR (20)    NULL,
    [DeviceName]      NVARCHAR (50)   NULL,
    [DeviceType]      VARCHAR (40)    NULL,
    [OperatorID]      VARCHAR (40)    NULL,
    [OperatorName]    NVARCHAR (50)   NULL,
    [OperatorSurname] NVARCHAR (50)   NULL,
    [ArticleID]       VARCHAR (40)    NULL,
    [ArticleCode]     VARCHAR (20)    NULL,
    [ArticleName]     NVARCHAR (50)   NULL,
    [ArticleCategory] NVARCHAR (50)   NULL,
    [NOrder]          VARCHAR (10)    NULL,
    [Quantity]        INT             NULL,
    [SerialNo]        VARCHAR (30)    NULL,
    [Revenue]         DECIMAL (18, 4) NULL,
    [LineRevenue]     DECIMAL (18, 4) NULL,
    [TotalRevenue]    DECIMAL (18, 4) NULL,
    [TransactionNo]   VARCHAR (20)    NULL,
    [InvoiceNo]       VARCHAR (20)    NULL,
    [Remarks]         NVARCHAR (100)  NULL,
    [Inserted]        DATETIME        NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_TRPayment-Time]
    ON [dbo].[TRPayment]([PaymentTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TRPayment-ID]
    ON [dbo].[TRPayment]([PaymentID] ASC);

