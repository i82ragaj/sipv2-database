CREATE TABLE [dbo].[MDDeviceType] (
    [IDPK]           VARCHAR (10)  NOT NULL,
    [DeviceTypeID]   VARCHAR (40)  NOT NULL,
    [DeviceTypeName] NVARCHAR (50) NULL,
    [Inserted]       DATETIME      NULL,
    [Updated]        DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDDeviceType-ID]
    ON [dbo].[MDDeviceType]([IDPK] ASC, [DeviceTypeID] ASC);

