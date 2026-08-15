CREATE TABLE [dbo].[MDClientUser] (
    [ClientUserID]      VARCHAR (40)   NOT NULL,
    [ClientUserName]    NVARCHAR (50)  NULL,
    [ClientUserSurname] NVARCHAR (50)  NULL,
    [ClientID]          VARCHAR (40)   NULL,
    [Remarks]           NVARCHAR (100) NULL,
    [SerialNo]          VARCHAR (30)   NULL,
    [SpaceNo]           VARCHAR (10)   NULL,
    [Inserted]          DATETIME       NULL,
    [Updated]           DATETIME       NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_MDClientUser-ID]
    ON [dbo].[MDClientUser]([ClientUserID] ASC);

