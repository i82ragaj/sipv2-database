CREATE TABLE [dbo].[MDUserRol] (
    [Id]        UNIQUEIDENTIFIER NOT NULL,
    [Active]    BIT              CONSTRAINT [DF__MDUserRol__activ__48CFD27E] DEFAULT ((1)) NOT NULL,
    [CreatedBy] NVARCHAR (50)    CONSTRAINT [DF_MDUserRol_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy] NVARCHAR (50)    CONSTRAINT [DF_MDUserRol_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]   DATETIME         NULL,
    [Updated]   DATETIME         NULL,
    [UserId]    UNIQUEIDENTIFIER NULL,
    [RolId]     UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_MDUserRol] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MDUserRol_MDRol] FOREIGN KEY ([RolId]) REFERENCES [dbo].[MDRol] ([Id]),
    CONSTRAINT [FK_MDUserRol_MDUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[MDUser] ([Id])
);

