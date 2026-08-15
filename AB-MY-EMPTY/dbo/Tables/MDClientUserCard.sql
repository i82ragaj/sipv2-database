CREATE TABLE [dbo].[MDClientUserCard] (
    [ClientUserCardID] VARCHAR (40)   NOT NULL,
    [ClientUserID]     VARCHAR (40)   NULL,
    [CardTypeID]       VARCHAR (40)   NULL,
    [SerialNo]         VARCHAR (40)   NULL,
    [ArticleID]        VARCHAR (40)   NULL,
    [CardValidFrom]    DATETIME       NULL,
    [CardValidUntil]   DATETIME       NULL,
    [CardIsBlocked]    TINYINT        NULL,
    [CardBlockedDate]  DATETIME       NULL,
    [Remarks]          NVARCHAR (100) NULL,
    [Inserted]         DATETIME       NULL,
    [Updated]          DATETIME       NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDClientUserCard-ID]
    ON [dbo].[MDClientUserCard]([ClientUserCardID] ASC);

