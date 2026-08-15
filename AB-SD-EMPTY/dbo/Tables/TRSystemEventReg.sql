CREATE TABLE [dbo].[TRSystemEventReg] (
    [SystemEventRegID]   VARCHAR (50)    NULL,
    [SystemEventRegTime] DATETIME        NOT NULL,
    [DeviceID]           VARCHAR (40)    NULL,
    [DeviceName]         NVARCHAR (50)   NULL,
    [DeviceCode]         VARCHAR (20)    NULL,
    [SystemEventID]      VARCHAR (40)    NULL,
    [SystemEventCode]    VARCHAR (20)    NULL,
    [SystemEventName]    NVARCHAR (50)   NULL,
    [OperatorID]         VARCHAR (40)    NULL,
    [OperatorName]       NVARCHAR (50)   NULL,
    [OperatorSurname]    NVARCHAR (50)   NULL,
    [Remarks]            NVARCHAR (100)  NULL,
    [Inserted]           DATETIME        NULL,
    [PlateNo]            VARCHAR (20)    NULL,
    [Amount]             DECIMAL (18, 4) NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_TRSystemEventReg-ID]
    ON [dbo].[TRSystemEventReg]([SystemEventRegID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TRSystemEventReg-Time]
    ON [dbo].[TRSystemEventReg]([SystemEventRegTime] ASC);

