CREATE TABLE [dbo].[TRProcessError] (
    [ID]             UNIQUEIDENTIFIER NOT NULL,
    [Active]         BIT              CONSTRAINT [DF_TRProcessError_Active] DEFAULT ((1)) NULL,
    [CreatedBy]      NVARCHAR (50)    CONSTRAINT [DF_TRProcessError_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy]      NVARCHAR (50)    CONSTRAINT [DF_TRProcessError_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]        DATETIME         NULL,
    [Updated]        DATETIME         NULL,
    [IDPK]           VARCHAR (10)     NULL,
    [UserName]       VARCHAR (100)    NULL,
    [ErrorNumber]    INT              NULL,
    [ErrorState]     INT              NULL,
    [ErrorSeverity]  INT              NULL,
    [ErrorLine]      INT              NULL,
    [ErrorProcedure] VARCHAR (MAX)    NULL,
    [ErrorMessage]   VARCHAR (MAX)    NULL,
    [ErrorDateTime]  DATETIME         NULL,
    [ExcutionId]     UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_TRProcessError] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_Errores]
    ON [dbo].[TRProcessError]([ExcutionId] ASC);

