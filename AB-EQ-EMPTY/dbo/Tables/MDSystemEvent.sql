CREATE TABLE [dbo].[MDSystemEvent] (
    [SystemEventID]   VARCHAR (40)  NOT NULL,
    [SystemEventName] NVARCHAR (50) NULL,
    [Inserted]        DATETIME      NULL,
    [Updated]         DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDSystemEvent-ID]
    ON [dbo].[MDSystemEvent]([SystemEventID] ASC);

