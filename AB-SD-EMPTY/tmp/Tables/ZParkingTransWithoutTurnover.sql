CREATE TABLE [tmp].[ZParkingTransWithoutTurnover] (
    [Quantity]          INT           NOT NULL,
    [Time]              DATETIME      NOT NULL,
    [DeviceNo]          SMALLINT      NOT NULL,
    [DeviceDesig]       NVARCHAR (25) NOT NULL,
    [DeviceAbbr]        NVARCHAR (12) NOT NULL,
    [DeviceType]        TINYINT       NOT NULL,
    [CarparkNo]         TINYINT       NOT NULL,
    [CarparkDesig]      NVARCHAR (25) NOT NULL,
    [CarparkAbbr]       NVARCHAR (5)  NOT NULL,
    [TransactionNo]     SMALLINT      NOT NULL,
    [StaffCode]         SMALLINT      NOT NULL,
    [OperatorSurname]   NVARCHAR (25) NOT NULL,
    [OperatorFirstName] NVARCHAR (25) NOT NULL,
    [PaymentType]       TINYINT       NOT NULL,
    [Revenue]           FLOAT (53)    NOT NULL,
    [NetRevenue]        FLOAT (53)    NOT NULL,
    [ArticleNo]         INT           NOT NULL,
    [CCCompanyAbbr]     NVARCHAR (5)  NOT NULL,
    [ElpCompanyAbbr]    NVARCHAR (5)  NOT NULL,
    [ArticleCategory]   NVARCHAR (80) NOT NULL,
    [ArticleDesig]      NVARCHAR (25) NOT NULL,
    [ArticleAbbr]       NVARCHAR (5)  NOT NULL,
    [CardNo]            NVARCHAR (30) NULL,
    [CardNoMask]        INT           NULL,
    [ParkingDuration]   INT           NOT NULL,
    [RateNo]            TINYINT       NOT NULL,
    [RateDesig]         NVARCHAR (25) NOT NULL,
    [Name]              NVARCHAR (25) NOT NULL,
    [Street]            NVARCHAR (25) NOT NULL,
    [City]              NVARCHAR (25) NOT NULL,
    [TaxCode]           NVARCHAR (16) NOT NULL,
    [InvoiceNo]         INT           NOT NULL,
    [CreditCardMasked]  NVARCHAR (20) NOT NULL,
    [TransactionNoCalc] NVARCHAR (24) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZParkingTransWithoutTurnover-Search]
    ON [tmp].[ZParkingTransWithoutTurnover]([Time] ASC, [TransactionNo] ASC);

