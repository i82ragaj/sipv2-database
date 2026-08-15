CREATE TABLE [dbo].[MDSystemEvent] (
    [IDPK]            VARCHAR (10)  NOT NULL,
    [SystemEventID]   VARCHAR (40)  NOT NULL,
    [SystemEventName] NVARCHAR (50) NULL,
    [Inserted]        DATETIME      NULL,
    [Updated]         DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDSystemEvent-ID]
    ON [dbo].[MDSystemEvent]([IDPK] ASC, [SystemEventID] ASC);

