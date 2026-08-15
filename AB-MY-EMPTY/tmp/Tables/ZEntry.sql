CREATE TABLE [tmp].[ZEntry] (
    [RecType]              TINYINT       NULL,
    [CirculatoryTitleType] INT           NULL,
    [TitleId]              VARCHAR (40)  NULL,
    [StayNumber]           INT           NULL,
    [DateTimeEntry]        DATETIME      NULL,
    [TerminalMeyparID]     VARCHAR (40)  NULL,
    [TerminalCodExt]       VARCHAR (40)  NULL,
    [TerminalName]         VARCHAR (100) NULL,
    [TerminaalType]        INT           NULL,
    [TerminalTypeName]     VARCHAR (100) NULL,
    [CarLicensePlate]      VARCHAR (40)  NULL,
    [ExternalSupport]      VARCHAR (40)  NULL,
    [ExternalSupportType]  INT           NULL,
    [VehicleType]          INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZEntry]
    ON [tmp].[ZEntry]([TitleId] ASC, [DateTimeEntry] ASC);

