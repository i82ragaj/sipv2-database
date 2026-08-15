CREATE TABLE [dbo].[MDOperator] (
    [IDPK]            VARCHAR (10)  NOT NULL,
    [OperatorID]      VARCHAR (40)  NOT NULL,
    [OperatorName]    NVARCHAR (50) NULL,
    [OperatorSurname] NVARCHAR (50) NULL,
    [Inserted]        DATETIME      NULL,
    [Updated]         DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDOperator-ID]
    ON [dbo].[MDOperator]([IDPK] ASC, [OperatorID] ASC);

