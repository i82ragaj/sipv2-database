CREATE TABLE [dbo].[MDRol] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [Active]      BIT              CONSTRAINT [DF__MDRol__active__3F466844] DEFAULT ((1)) NOT NULL,
    [CreatedBy]   NVARCHAR (50)    CONSTRAINT [DF_MDRol_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy]   NVARCHAR (50)    CONSTRAINT [DF_MDRol_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]     DATETIME         NULL,
    [Updated]     DATETIME         NULL,
    [Name]        NVARCHAR (MAX)   NULL,
    [Description] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_MDRol] PRIMARY KEY CLUSTERED ([Id] ASC)
);

