CREATE TABLE [dbo].[NavSummary] (
    [IDPK]            VARCHAR (10)    NOT NULL,
    [SumaryDate]      DATE            NOT NULL,
    [DACode]          VARCHAR (10)    NULL,
    [DocumentType]    VARCHAR (20)    NULL,
    [DocumentNo]      VARCHAR (50)    NULL,
    [PaymentTypeCode] VARCHAR (100)   NULL,
    [LineNo]          INT             NULL,
    [LineDescription] NVARCHAR (200)  NULL,
    [Quantity]        DECIMAL (10)    NULL,
    [Amount]          DECIMAL (18, 2) NULL,
    [Alias]           NVARCHAR (200)  NULL,
    [MachineId]       VARCHAR (50)    NULL,
    [TicketNoBegin]   VARCHAR (20)    NULL,
    [TicketNoEnd]     VARCHAR (20)    NULL
);

