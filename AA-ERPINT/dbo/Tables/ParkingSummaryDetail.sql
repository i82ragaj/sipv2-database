CREATE TABLE [dbo].[ParkingSummaryDetail] (
    [IDPK]            VARCHAR (10)    NOT NULL,
    [Date]            DATE            NULL,
    [PaymentTypeId]   VARCHAR (40)    NULL,
    [PaymentTypeName] NVARCHAR (50)   NULL,
    [Operations]      INT             NULL,
    [Total]           DECIMAL (38, 4) NULL
);

