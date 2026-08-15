CREATE TABLE [tmp].[Ztmp] (
    [id]        INT        NOT NULL,
    [dateFrom]  DATE       NOT NULL,
    [dateTo]    DATE       NOT NULL,
    [processed] NCHAR (10) NOT NULL,
    [ecob]      NCHAR (10) DEFAULT (N'N') NULL,
    [edetcob]   NCHAR (10) DEFAULT (N'N') NULL,
    [eentsal]   NCHAR (10) DEFAULT (N'N') NULL,
    [etur]      NCHAR (10) DEFAULT (N'N') NULL,
    [einc]      NCHAR (10) DEFAULT (N'N') NULL,
    CONSTRAINT [PK_Ztmp] PRIMARY KEY CLUSTERED ([id] ASC)
);

