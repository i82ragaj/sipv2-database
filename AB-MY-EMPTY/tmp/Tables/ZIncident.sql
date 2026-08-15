CREATE TABLE [tmp].[ZIncident] (
    [RecType]             TINYINT        NULL,
    [DateTimeIncident]    DATETIME       NULL,
    [TerminalMeyparID]    VARCHAR (40)   NULL,
    [TerminalCodExt]      VARCHAR (40)   NULL,
    [TerminalName]        NVARCHAR (100) NULL,
    [TerminalType]        INT            NULL,
    [TerminalTypeName]    NVARCHAR (100) NULL,
    [UserTerminalIP]      NVARCHAR (40)  NULL,
    [UserTerminalSession] VARCHAR (40)   NULL,
    [UserCod]             VARCHAR (40)   NULL,
    [UserName]            VARCHAR (100)  NULL,
    [ReasonDesc]          NVARCHAR (200) NULL,
    [ActionType]          INT            NULL,
    [ActionName]          VARCHAR (100)  NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZIncident]
    ON [tmp].[ZIncident]([TerminalMeyparID] ASC, [DateTimeIncident] ASC);

