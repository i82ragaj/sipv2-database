CREATE TABLE [dbo].[TRMovement] (
    [IDPK]         VARCHAR (10)    NOT NULL,
    [MovementID]   VARCHAR (50)    NOT NULL,
    [MovementTime] DATETIME        NOT NULL,
    [MovementType] VARCHAR (20)    NULL,
    [DeviceID]     VARCHAR (40)    NULL,
    [DeviceName]   NVARCHAR (50)   NULL,
    [ArticleID]    VARCHAR (40)    NULL,
    [ArticleCode]  VARCHAR (20)    NULL,
    [ArticleName]  NVARCHAR (50)   NULL,
    [Amount]       DECIMAL (18, 4) NULL,
    [SerialNo]     VARCHAR (30)    NULL,
    [PlateNo]      VARCHAR (20)    NULL,
    [Inserted]     DATETIME        NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_TRMovement-ID]
    ON [dbo].[TRMovement]([IDPK] ASC, [MovementID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TRMovement-Time]
    ON [dbo].[TRMovement]([IDPK] ASC, [MovementTime] ASC);

