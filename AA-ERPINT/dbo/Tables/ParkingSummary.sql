CREATE TABLE [dbo].[ParkingSummary] (
    [IDPK]              VARCHAR (10)    NOT NULL,
    [Date]              DATE            NULL,
    [Operations]        INT             NULL,
    [Total]             DECIMAL (38, 4) NULL,
    [InvoiceNoMin]      VARCHAR (29)    NULL,
    [InvoiceNoMax]      VARCHAR (29)    NULL,
    [ParkingTransTotal] DECIMAL (38, 4) NULL,
    [ParkingTransNum]   INT             NULL,
    [SumMinutes]        INT             NULL,
    [InvoicesTotal]     DECIMAL (38, 4) NULL,
    [InvoicesNum]       INT             NULL,
    [ACATotal]          DECIMAL (38, 4) NULL,
    [ACANum]            INT             NULL,
    [CEITotal]          DECIMAL (38, 4) NULL,
    [CEINum]            INT             NULL,
    [CERTotal]          DECIMAL (38, 4) NULL,
    [CERNum]            INT             NULL,
    [CashTotal]         DECIMAL (38, 4) NULL,
    [CashNum]           INT             NULL,
    [RestTotal]         DECIMAL (38, 4) NULL,
    [RestNum]           INT             NULL
);

