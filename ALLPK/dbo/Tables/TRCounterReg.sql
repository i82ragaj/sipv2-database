CREATE TABLE [dbo].[TRCounterReg] (
    [IDPK]         VARCHAR (10) NOT NULL,
    [CounterID]    VARCHAR (40) NOT NULL,
    [CounterDate]  DATETIME     NOT NULL,
    [CurrentLevel] SMALLINT     NOT NULL,
    [Capacity]     SMALLINT     NULL,
    [Inserted]     DATETIME     NULL,
    [Updated]      DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_TRCounterReg]
    ON [dbo].[TRCounterReg]([IDPK] ASC, [CounterID] ASC, [CounterDate] ASC);

