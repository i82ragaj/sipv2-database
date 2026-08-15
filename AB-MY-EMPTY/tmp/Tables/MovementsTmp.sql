CREATE TABLE [tmp].[MovementsTmp] (
    [DateTimeOpe]          DATETIME       NULL,
    [OpeType]              VARCHAR (3)    NULL,
    [CirculatoryTitleType] VARCHAR (10)   NULL,
    [TitleId]              VARCHAR (40)   NULL,
    [CarLicensePlate]      VARCHAR (40)   NULL,
    [TerminalMeyparID]     VARCHAR (40)   NULL,
    [TerminalCodExt]       VARCHAR (40)   NULL,
    [TerminalName]         NVARCHAR (100) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MovementsTmp]
    ON [tmp].[MovementsTmp]([TitleId] ASC, [OpeType] ASC, [CirculatoryTitleType] ASC, [DateTimeOpe] ASC);

