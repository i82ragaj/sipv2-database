CREATE TABLE [tmp].[MovementsTmp] (
    [Time]                   DATETIME      NOT NULL,
    [CardNo]                 NVARCHAR (30) NOT NULL,
    [MovementType]           TINYINT       NOT NULL,
    [ArticleType]            VARCHAR (1)   NOT NULL,
    [DeviceNo]               SMALLINT      NULL,
    [DeviceDesig]            NVARCHAR (25) NULL,
    [ArticleNo]              SMALLINT      NULL,
    [ArticleDesig]           NVARCHAR (25) NULL,
    [ArticleAbbr]            NVARCHAR (5)  NULL,
    [Amount]                 FLOAT (53)    NULL,
    [CurrencyOfAmount]       NCHAR (3)     NULL,
    [CardRemainingValue]     FLOAT (53)    NULL,
    [AdditionalInfo]         NVARCHAR (20) NULL,
    [CardNoMask]             INT           NULL,
    [CardValueType]          TINYINT       NULL,
    [CurrencyRemainingValue] NCHAR (3)     NULL,
    [RejectionNo]            SMALLINT      NULL,
    [RejectionDesig]         NVARCHAR (80) NULL,
    [PlateNo]                NVARCHAR (20) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MovementsTmp-Search]
    ON [tmp].[MovementsTmp]([CardNo] ASC, [MovementType] ASC, [ArticleType] ASC, [Time] ASC);


GO
CREATE NONCLUSTERED INDEX [MomementsTmpSearch]
    ON [tmp].[MovementsTmp]([CardNo] ASC, [MovementType] ASC, [ArticleType] ASC);

