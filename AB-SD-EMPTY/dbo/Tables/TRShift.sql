CREATE TABLE [dbo].[TRShift] (
    [ShiftID]          VARCHAR (50)  NOT NULL,
    [ShiftCode]        VARCHAR (20)  NULL,
    [ShiftTime]        DATETIME      NOT NULL,
    [ShiftStartupTime] DATETIME      NULL,
    [ShiftCloseTime]   DATETIME      NULL,
    [IsOpen]           SMALLINT      NOT NULL,
    [DeviceID]         VARCHAR (40)  NULL,
    [DeviceCode]       VARCHAR (20)  NULL,
    [DeviceName]       NVARCHAR (50) NULL,
    [DeviceTypeID]     VARCHAR (40)  NULL,
    [OperatorID]       VARCHAR (40)  NULL,
    [OperatorName]     NVARCHAR (50) NULL,
    [OperatorSurname]  NVARCHAR (50) NULL,
    [Inserted]         DATETIME      NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_TRShift-ID]
    ON [dbo].[TRShift]([ShiftID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TRShift-Time]
    ON [dbo].[TRShift]([ShiftTime] ASC);

