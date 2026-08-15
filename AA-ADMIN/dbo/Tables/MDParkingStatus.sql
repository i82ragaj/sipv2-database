CREATE TABLE [dbo].[MDParkingStatus] (
    [ID]                    VARCHAR (10)  NOT NULL,
    [Active]                BIT           CONSTRAINT [DF_MDParkingStatus_Active] DEFAULT ((1)) NOT NULL,
    [CreatedBy]             NVARCHAR (50) CONSTRAINT [DF_MDParkingStatus_CreatedBy] DEFAULT (N'system') NULL,
    [UpdatedBy]             NVARCHAR (50) CONSTRAINT [DF_MDParkingStatus_UpdatedBy] DEFAULT (N'system') NULL,
    [Created]               DATETIME      NULL,
    [Updated]               DATETIME      NULL,
    [LastImported]          DATETIME      NULL,
    [LastImportedStatus]    VARCHAR (20)  NULL,
    [LastImportedOK]        DATETIME      NULL,
    [LastCountTotals]       DATETIME      NULL,
    [LastCountTotalsStatus] DATETIME      NULL,
    [LastImportedDuration]  DATETIME      NULL,
    CONSTRAINT [PK_MDParkingStatus] PRIMARY KEY CLUSTERED ([ID] ASC)
);

