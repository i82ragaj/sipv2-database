CREATE TABLE [dbo].[MDParkingType] (
    [Id]          VARCHAR (10)   NOT NULL,
    [Active]      BIT            CONSTRAINT [DF__MDParkingType__active__3F466844] DEFAULT ((1)) NOT NULL,
    [CreatedBy]   NVARCHAR (50)  CONSTRAINT [DF_MDParkingType_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy]   NVARCHAR (50)  CONSTRAINT [DF_MDParkingType_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]     DATETIME       NULL,
    [Updated]     DATETIME       NULL,
    [Name]        NVARCHAR (MAX) NULL,
    [Description] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_MDParkingType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

