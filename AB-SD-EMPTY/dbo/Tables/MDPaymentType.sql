CREATE TABLE [dbo].[MDPaymentType] (
    [PaymentTypeID]   VARCHAR (40)  NOT NULL,
    [PaymentTypeName] NVARCHAR (50) NULL,
    [TransType]       VARCHAR (10)  NULL,
    [Inserted]        DATETIME      NULL,
    [Updated]         DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDPaymentType-ID]
    ON [dbo].[MDPaymentType]([PaymentTypeID] ASC);

