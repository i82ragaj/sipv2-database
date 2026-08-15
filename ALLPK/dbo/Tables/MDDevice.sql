CREATE TABLE [dbo].[MDDevice] (
    [IDPK]         VARCHAR (10)  NOT NULL,
    [DeviceID]     VARCHAR (40)  NOT NULL,
    [DeviceCode]   VARCHAR (20)  NULL,
    [DeviceName]   NVARCHAR (50) NULL,
    [DeviceTypeID] VARCHAR (40)  NULL,
    [Inserted]     DATETIME      NULL,
    [Updated]      DATETIME      NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_MDDevice-ID]
    ON [dbo].[MDDevice]([IDPK] ASC, [DeviceID] ASC);

