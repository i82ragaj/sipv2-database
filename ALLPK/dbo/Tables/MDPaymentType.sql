CREATE TABLE [dbo].[MDPaymentType] (
    [IDPK]            VARCHAR (10)  NOT NULL,
    [PaymentTypeID]   VARCHAR (40)  NOT NULL,
    [PaymentTypeName] NVARCHAR (50) NULL,
    [TransType]       VARCHAR (10)  NULL,
    [inserted]        DATETIME      NULL,
    [updated]         DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDPaymentType-ID]
    ON [dbo].[MDPaymentType]([IDPK] ASC, [PaymentTypeID] ASC);

