CREATE TABLE [dbo].[MDUser] (
    [Id]        UNIQUEIDENTIFIER NOT NULL,
    [Active]    BIT              CONSTRAINT [DF__MDUser__active__45F365D3] DEFAULT ((1)) NOT NULL,
    [CreatedBy] NVARCHAR (50)    CONSTRAINT [DF_MDUser_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy] NVARCHAR (50)    CONSTRAINT [DF_MDUser_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]   DATETIME         NULL,
    [Updated]   DATETIME         NULL,
    [Name]      NVARCHAR (50)    NOT NULL,
    [LastName]  NVARCHAR (50)    NULL,
    [LastName1] NVARCHAR (50)    NULL,
    [Login]     NVARCHAR (100)   NOT NULL,
    [Password]  NVARCHAR (100)   NULL,
    [Email]     NVARCHAR (MAX)   NULL,
    [Phone]     NVARCHAR (50)    NULL,
    CONSTRAINT [PK_MDUser] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_login] UNIQUE NONCLUSTERED ([Login] ASC)
);

