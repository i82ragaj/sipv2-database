CREATE TABLE [tmp].[ZPaymentWithSkiDataValueCard] (
    [Quantity]                 INT           NOT NULL,
    [Time]                     DATETIME      NOT NULL,
    [DeviceNo]                 SMALLINT      NOT NULL,
    [DeviceDesig]              NVARCHAR (25) NOT NULL,
    [DeviceAbbr]               NVARCHAR (12) NOT NULL,
    [DeviceType]               TINYINT       NOT NULL,
    [CarparkNo]                TINYINT       NOT NULL,
    [CarparkDesig]             NVARCHAR (25) NOT NULL,
    [CarparkAbbr]              NVARCHAR (5)  NOT NULL,
    [TransactionNo]            SMALLINT      NOT NULL,
    [StaffCode]                SMALLINT      NOT NULL,
    [OperatorSurname]          NVARCHAR (25) NOT NULL,
    [OperatorFirstName]        NVARCHAR (25) NOT NULL,
    [ArticleNo]                SMALLINT      NOT NULL,
    [ArticleCategory]          NVARCHAR (80) NOT NULL,
    [ArticleDesig]             NVARCHAR (25) NOT NULL,
    [ArticleAbbr]              NVARCHAR (5)  NOT NULL,
    [DebitValue]               FLOAT (53)    NOT NULL,
    [CardValueType]            TINYINT       NOT NULL,
    [RateReduction]            FLOAT (53)    NOT NULL,
    [RateReductionAliquot]     FLOAT (53)    NOT NULL,
    [OpenAmount]               FLOAT (53)    NOT NULL,
    [CardInvoiceNo]            INT           NOT NULL,
    [CardProductionDate]       SMALLDATETIME NOT NULL,
    [CardProductionFacilityNo] INT           NOT NULL,
    [InvoiceNo]                INT           NOT NULL,
    [TicketType]               TINYINT       NOT NULL,
    [CardKey]                  NCHAR (30)    NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZPaymentWithSkiDataValueCard-Search]
    ON [tmp].[ZPaymentWithSkiDataValueCard]([Time] ASC, [DeviceNo] ASC, [TransactionNo] ASC);

