CREATE TABLE [dbo].[TRSystemEventReg] (
    [IDPK]               VARCHAR (10)    NOT NULL,
    [SystemEventRegID]   VARCHAR (50)    NULL,
    [SystemEventRegTime] DATETIME        NOT NULL,
    [DeviceID]           VARCHAR (40)    NULL,
    [DeviceCode]         VARCHAR (20)    NULL,
    [DeviceName]         NVARCHAR (50)   NULL,
    [SystemEventID]      VARCHAR (40)    NULL,
    [SystemEventCode]    VARCHAR (20)    NULL,
    [SystemEventName]    NVARCHAR (50)   NULL,
    [OperatorID]         VARCHAR (40)    NULL,
    [OperatorName]       NVARCHAR (50)   NULL,
    [OperatorSurname]    NVARCHAR (50)   NULL,
    [PlateNo]            VARCHAR (20)    NULL,
    [Amount]             DECIMAL (18, 4) NULL,
    [Remarks]            NVARCHAR (100)  NULL,
    [Inserted]           DATETIME        NULL
);






GO
CREATE NONCLUSTERED INDEX [IX_TRSystemEventReg-ID]
    ON [dbo].[TRSystemEventReg]([IDPK] ASC, [SystemEventRegID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TRSystemEventReg-Time]
    ON [dbo].[TRSystemEventReg]([IDPK] ASC, [SystemEventRegTime] ASC);

