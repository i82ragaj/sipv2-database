CREATE TABLE [dbo].[TRInvoice] (
    [InvoiceID]           VARCHAR (50)    NOT NULL,
    [InvoiceTime]         DATETIME        NOT NULL,
    [PaymentDeviceID]     VARCHAR (40)    NULL,
    [PaymentDeviceCode]   VARCHAR (20)    NULL,
    [PaymentDeviceName]   NVARCHAR (50)   NULL,
    [PaymentDeviceTypeID] VARCHAR (40)    NULL,
    [OperatorID]          VARCHAR (40)    NULL,
    [OperatorName]        NVARCHAR (50)   NULL,
    [OperatorSurname]     NVARCHAR (50)   NULL,
    [ArticleID]           VARCHAR (40)    NULL,
    [ArticleCode]         VARCHAR (20)    NULL,
    [ArticleName]         NVARCHAR (50)   NULL,
    [ArticleCategory]     NVARCHAR (50)   NULL,
    [Quantity]            SMALLINT        NULL,
    [ValidFrom]           DATETIME        NULL,
    [SerialNoFrom]        VARCHAR (30)    NULL,
    [SerialNoTo]          VARCHAR (30)    NULL,
    [Expires]             DATETIME        NULL,
    [NoOfDays]            INT             NULL,
    [TransactionNo]       VARCHAR (20)    NULL,
    [InvoiceNo]           VARCHAR (20)    NULL,
    [Revenue]             DECIMAL (18, 4) NULL,
    [NetRevenue]          DECIMAL (18, 4) NULL,
    [TaxId]               VARCHAR (40)    NULL,
    [TaxName]             NVARCHAR (50)   NULL,
    [PaymentTypeID]       VARCHAR (40)    NULL,
    [ConceptTypeID]       VARCHAR (40)    NULL,
    [Remarks]             NVARCHAR (100)  NULL,
    [VATID]               VARCHAR (40)    NULL,
    [Name]                NVARCHAR (100)  NULL,
    [Address]             NVARCHAR (100)  NULL,
    [City]                NVARCHAR (25)   NULL,
    [Country]             NVARCHAR (50)   NULL,
    [Inserted]            DATETIME        NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_TRInvoice-Time]
    ON [dbo].[TRInvoice]([InvoiceTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TRInvoice-ID]
    ON [dbo].[TRInvoice]([InvoiceID] ASC);

