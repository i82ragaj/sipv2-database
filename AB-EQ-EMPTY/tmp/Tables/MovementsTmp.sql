CREATE TABLE [tmp].[MovementsTmp] (
    [MovementDate] DATETIME      NOT NULL,
    [DeviceType]   SMALLINT      NOT NULL,
    [DeviceId]     VARCHAR (40)  NULL,
    [DeviceName]   NVARCHAR (50) NULL,
    [SerialNo]     VARCHAR (50)  NULL,
    [Article]      VARCHAR (40)  NULL,
    [LicencePlate] VARCHAR (20)  NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_MovementsTmp]
    ON [tmp].[MovementsTmp]([DeviceType] ASC, [SerialNo] ASC, [Article] ASC);

