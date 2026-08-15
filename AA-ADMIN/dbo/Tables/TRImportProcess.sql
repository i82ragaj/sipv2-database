CREATE TABLE [dbo].[TRImportProcess] (
    [ID]          UNIQUEIDENTIFIER NOT NULL,
    [Active]      BIT              CONSTRAINT [DF_TRImportProcess_Active] DEFAULT ((1)) NOT NULL,
    [CreatedBy]   NVARCHAR (50)    CONSTRAINT [DF_TRImportProcess_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy]   NVARCHAR (50)    CONSTRAINT [DF_TRImportProcess_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]     DATETIME         NULL,
    [Updated]     DATETIME         NULL,
    [IDPK]        VARCHAR (10)     NULL,
    [Begin]       DATETIME         NULL,
    [End]         DATETIME         NULL,
    [Duration]    TIME (7)         NULL,
    [Status]      VARCHAR (20)     NULL,
    [Description] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_TRImportProcess] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_TRImportProcess_MDParking] FOREIGN KEY ([IDPK]) REFERENCES [dbo].[MDParking] ([ID])
);

