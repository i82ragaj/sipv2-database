CREATE TABLE [tmp].[ZShifts] (
    [ShiftNo]           INT           NOT NULL,
    [Time]              DATETIME      NOT NULL,
    [ShiftStartupTime]  DATETIME      NOT NULL,
    [ShiftCloseTime]    DATETIME      NOT NULL,
    [IsOpen]            BIT           NOT NULL,
    [DeviceNo]          SMALLINT      NOT NULL,
    [DeviceDesig]       NVARCHAR (25) NOT NULL,
    [DeviceAbbr]        NVARCHAR (12) NOT NULL,
    [DeviceType]        TINYINT       NOT NULL,
    [CarparkNo]         TINYINT       NOT NULL,
    [CarparkDesig]      NVARCHAR (25) NOT NULL,
    [CarparkAbbr]       NVARCHAR (5)  NOT NULL,
    [StaffCode]         INT           NOT NULL,
    [OperatorSurname]   NVARCHAR (25) NOT NULL,
    [OperatorFirstName] NVARCHAR (25) NOT NULL,
    [SubstituteShiftNo] INT           NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_ZShifts-Time]
    ON [tmp].[ZShifts]([Time] ASC);

