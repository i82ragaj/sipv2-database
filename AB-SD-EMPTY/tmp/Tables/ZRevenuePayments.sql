CREATE TABLE [tmp].[ZRevenuePayments] (
    [PaymentType]       INT           NOT NULL,
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
    [Revenue]           FLOAT (53)    NOT NULL,
    [InvoiceNo]         INT           NOT NULL,
    [TransactionNoCalc] NVARCHAR (24) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZRevenuePayments-Search]
    ON [tmp].[ZRevenuePayments]([Time] ASC, [DeviceNo] ASC, [TransactionNo] ASC);

