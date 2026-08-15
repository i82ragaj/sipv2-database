CREATE TABLE [tmp].[ZRevenueSales] (
    [Quantity]          SMALLINT      NOT NULL,
    [Time]              DATETIME      NOT NULL,
    [DeviceNo]          SMALLINT      NOT NULL,
    [DeviceDesig]       NVARCHAR (25) NOT NULL,
    [DeviceAbbr]        NVARCHAR (12) NOT NULL,
    [DeviceType]        TINYINT       NOT NULL,
    [CarparkNo]         TINYINT       NOT NULL,
    [CarparkDesig]      NVARCHAR (25) NOT NULL,
    [CarparkAbbr]       NVARCHAR (5)  NOT NULL,
    [TransactionNo]     SMALLINT      NOT NULL,
    [InvoiceNo]         INT           NOT NULL,
    [StaffCode]         SMALLINT      NOT NULL,
    [OperatorSurname]   NVARCHAR (25) NOT NULL,
    [OperatorFirstName] NVARCHAR (25) NOT NULL,
    [Revenue]           FLOAT (53)    NOT NULL,
    [NetRevenue]        FLOAT (53)    NOT NULL,
    [ArticleNo]         SMALLINT      NOT NULL,
    [ArticleCategory]   NVARCHAR (80) NOT NULL,
    [ArticleDesig]      NVARCHAR (25) NOT NULL,
    [ArticleAbbr]       NVARCHAR (5)  NOT NULL,
    [ValidFrom]         SMALLDATETIME NOT NULL,
    [Expires]           SMALLDATETIME NOT NULL,
    [StaffCodeSale]     SMALLINT      NOT NULL,
    [RoomNumber]        NVARCHAR (6)  NOT NULL,
    [FolioNumber]       NVARCHAR (10) NOT NULL,
    [GuestName]         NVARCHAR (25) NOT NULL,
    [PricePerDay]       FLOAT (53)    NOT NULL,
    [CardNoFrom]        INT           NOT NULL,
    [CardNoTo]          INT           NOT NULL,
    [Name]              NVARCHAR (25) NOT NULL,
    [Street]            NVARCHAR (25) NOT NULL,
    [City]              NVARCHAR (25) NOT NULL,
    [TaxCode]           NVARCHAR (16) NOT NULL,
    [NoOfDays]          INT           NULL,
    [TransactionNoCalc] NVARCHAR (24) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZRevenueSales-Search]
    ON [tmp].[ZRevenueSales]([Time] ASC, [TransactionNo] ASC);

