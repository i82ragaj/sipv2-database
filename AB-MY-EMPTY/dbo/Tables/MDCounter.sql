CREATE TABLE [dbo].[MDCounter] (
    [CounterID]      VARCHAR (40)  NOT NULL,
    [CounterName]    NVARCHAR (50) NULL,
    [OccupancyLimit] SMALLINT      NULL,
    [Inserted]       DATETIME      NULL,
    [Updated]        DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDCounter-ID]
    ON [dbo].[MDCounter]([CounterID] ASC);

