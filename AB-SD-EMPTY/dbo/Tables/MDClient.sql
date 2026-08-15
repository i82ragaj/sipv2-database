CREATE TABLE [dbo].[MDClient] (
    [ClientID]        VARCHAR (40)   NOT NULL,
    [ClientName]      NVARCHAR (50)  NULL,
    [ClientSurname]   NVARCHAR (50)  NULL,
    [Address]         NVARCHAR (100) NULL,
    [ZipCode]         NVARCHAR (10)  NULL,
    [City]            NVARCHAR (50)  NULL,
    [Country]         NVARCHAR (50)  NULL,
    [Nationality]     NVARCHAR (50)  NULL,
    [VATID]           NVARCHAR (20)  NULL,
    [Telephone]       NVARCHAR (20)  NULL,
    [Email]           NVARCHAR (120) NULL,
    [ClientBeginDate] DATETIME       NULL,
    [ClientEndDate]   DATETIME       NULL,
    [Remarks]         NVARCHAR (100) NULL,
    [Inserted]        DATETIME       NULL,
    [Updated]         DATETIME       NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDClient-ID]
    ON [dbo].[MDClient]([ClientID] ASC);

