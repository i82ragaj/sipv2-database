CREATE TABLE [dbo].[MDCounterConfig] (
    [ID]             UNIQUEIDENTIFIER NOT NULL,
    [IsActive]       BIT              CONSTRAINT [DF_MDCounterConfig_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedBy]      NVARCHAR (50)    CONSTRAINT [DF_MDCounterConfig_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy]      NVARCHAR (50)    CONSTRAINT [DF_MDCounterConfig_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]        DATETIME         NULL,
    [Updated]        DATETIME         NULL,
    [IDPK]           VARCHAR (10)     NOT NULL,
    [CounterID]      VARCHAR (40)     NOT NULL,
    [CounterName]    NVARCHAR (50)    NULL,
    [OccupancyLimit] SMALLINT         NULL,
    [CounterType]    VARCHAR (10)     NULL,
    CONSTRAINT [PK_MDCounterConfig] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MDCounterConfig]
    ON [dbo].[MDCounterConfig]([IDPK] ASC, [CounterID] ASC);

