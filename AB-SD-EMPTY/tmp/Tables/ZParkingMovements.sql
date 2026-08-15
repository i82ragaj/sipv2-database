CREATE TABLE [tmp].[ZParkingMovements] (
    [Quantity]               INT           NOT NULL,
    [Time]                   DATETIME      NOT NULL,
    [MovementType]           TINYINT       NOT NULL,
    [FacilityNo]             INT           NOT NULL,
    [CarparkNo]              TINYINT       NOT NULL,
    [CarparkDesig]           NVARCHAR (25) NOT NULL,
    [DeviceNo]               SMALLINT      NOT NULL,
    [DeviceDesig]            NVARCHAR (25) NOT NULL,
    [ArticleNo]              SMALLINT      NOT NULL,
    [ArticleDesig]           NVARCHAR (25) NOT NULL,
    [ArticleAbbr]            NVARCHAR (5)  NOT NULL,
    [Amount]                 FLOAT (53)    NOT NULL,
    [CurrencyOfAmount]       NCHAR (3)     NOT NULL,
    [CardValue]              FLOAT (53)    NOT NULL,
    [CurrencyOfCardValue]    NCHAR (3)     NOT NULL,
    [CardRemainingValue]     FLOAT (53)    NOT NULL,
    [AdditionalInfo]         NVARCHAR (20) NOT NULL,
    [CardNoMask]             INT           NOT NULL,
    [CardNo]                 CHAR (23)     NULL,
    [CardValueType]          TINYINT       NOT NULL,
    [CurrencyRemainingValue] NCHAR (3)     NOT NULL,
    [RejectionNo]            SMALLINT      NOT NULL,
    [RejectionDesig]         NVARCHAR (80) NOT NULL,
    [PlateNo]                NVARCHAR (20) NULL,
    [PaidFrom]               DATETIME      NOT NULL,
    [MovementTypeDesig]      NVARCHAR (80) NOT NULL,
    [FacilityDesig]          NVARCHAR (25) NOT NULL,
    [FacilityAbbr]           NVARCHAR (5)  NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZParkingMovements-Time]
    ON [tmp].[ZParkingMovements]([Time] ASC);

