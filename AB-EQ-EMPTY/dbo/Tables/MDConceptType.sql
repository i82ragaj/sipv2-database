CREATE TABLE [dbo].[MDConceptType] (
    [ConceptTypeID]   VARCHAR (40)  NOT NULL,
    [ConceptTypeName] NVARCHAR (50) NULL,
    [Inserted]        DATETIME      NULL,
    [Updated]         DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MDConceptType-ID]
    ON [dbo].[MDConceptType]([ConceptTypeID] ASC);

