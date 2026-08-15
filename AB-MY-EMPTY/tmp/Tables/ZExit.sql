CREATE TABLE [tmp].[ZExit] (
    [RecType]                   TINYINT        NULL,
    [CirculatoryTitleType]      INT            NULL,
    [TitleId]                   VARCHAR (40)   NULL,
    [StayNumber]                INT            NULL,
    [DateTimeExit]              DATETIME       NULL,
    [ExitDueByIncident]         INT            NULL,
    [ExitDueByIncidentReason]   NVARCHAR (200) NULL,
    [ExitDueByIncidentUserID]   NVARCHAR (40)  NULL,
    [ExitDueByIncidentUserName] NVARCHAR (100) NULL,
    [TerminalMeyparID]          VARCHAR (40)   NULL,
    [TerminalCodExt]            VARCHAR (40)   NULL,
    [TerminalName]              NVARCHAR (100) NULL,
    [TerminalType]              INT            NULL,
    [TerminalTypeName]          NVARCHAR (100) NULL,
    [CarLicensePlate]           VARCHAR (40)   NULL,
    [ExternalSupport]           VARCHAR (100)  NULL,
    [ExternalSupportType]       INT            NULL,
    [VehicleType]               INT            NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZExit]
    ON [tmp].[ZExit]([TitleId] ASC, [DateTimeExit] ASC);

