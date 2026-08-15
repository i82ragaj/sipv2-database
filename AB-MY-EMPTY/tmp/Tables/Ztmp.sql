CREATE TABLE [tmp].[Ztmp] (
    [id]                  INT        NOT NULL,
    [dateFrom]            DATE       NOT NULL,
    [dateTo]              DATE       NOT NULL,
    [processed]           NCHAR (10) NOT NULL,
    [eentry]              NCHAR (10) DEFAULT (N'N') NULL,
    [eexit]               NCHAR (10) DEFAULT (N'N') NULL,
    [epayment]            NCHAR (10) DEFAULT (N'N') NULL,
    [edomiciliarycharge]  NCHAR (10) DEFAULT (N'N') NULL,
    [eissuinginvoice]     NCHAR (10) DEFAULT (N'N') NULL,
    [eincident]           NCHAR (10) DEFAULT (N'N') NULL,
    [eclient]             NCHAR (10) DEFAULT (N'N') NULL,
    [esubscriberproduct]  NCHAR (10) DEFAULT (N'N') NULL,
    [esubscribercontract] NCHAR (10) DEFAULT (N'N') NULL,
    CONSTRAINT [PK_Ztmp] PRIMARY KEY CLUSTERED ([id] ASC)
);

