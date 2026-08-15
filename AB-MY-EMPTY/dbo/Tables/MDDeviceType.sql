CREATE TABLE [dbo].[MDDeviceType] (
    [DeviceTypeID]   VARCHAR (40)  NOT NULL,
    [DeviceTypeName] NVARCHAR (50) NULL,
    [Inserted]       DATETIME      NULL,
    [Updated]        DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDDeviceType-ID]
    ON [dbo].[MDDeviceType]([DeviceTypeID] ASC);

