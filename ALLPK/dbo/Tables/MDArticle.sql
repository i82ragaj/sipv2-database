CREATE TABLE [dbo].[MDArticle] (
    [IDPK]            VARCHAR (10)  NOT NULL,
    [ArticleID]       VARCHAR (40)  NOT NULL,
    [ArticleCode]     VARCHAR (20)  NULL,
    [ArticleName]     NVARCHAR (50) NULL,
    [ArticleCategory] NVARCHAR (50) NULL,
    [ArticleType]     VARCHAR (10)  NULL,
    [Inserted]        DATETIME      NULL,
    [Updated]         DATETIME      NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_MDArticle-ID]
    ON [dbo].[MDArticle]([IDPK] ASC, [ArticleID] ASC);

