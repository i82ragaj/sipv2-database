USE [AB-SD-EMPTY]
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'ACA', N'AmountCacellations', CAST(N'2026-03-11T21:45:54.897' AS DateTime), NULL)
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'CEI', N'CreditEntriesIssued', CAST(N'2026-03-11T21:45:54.897' AS DateTime), NULL)
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'P', N'Payment', CAST(N'2026-03-11T21:45:54.897' AS DateTime), NULL)
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'CER', N'CreditEntriesRedeemed', CAST(N'2026-03-11T21:45:54.897' AS DateTime), NULL)
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'PVC', N'PaymentWithValueCard', CAST(N'2026-03-11T21:45:54.897' AS DateTime), NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'0', N'Normal', N'G', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'1', N'Forced NIL Ticket', N'G', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'2', N'NIL Ticket transit grace period', N'G', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'3', N'Flat Rate Prepayment', N'G', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'4', N'Card modification', N'G', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'1', N'Cash', N'P', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'2', N'Check', N'P', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'3', N'Creditcards', N'P', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'4', N'ELP', N'P', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'5', N'Invoice', N'P', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'6', N'Manual Payment', N'P', NULL, NULL)
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [Inserted], [Updated]) VALUES (N'7', N'SkiData Value Card', N'P', NULL, NULL)
GO
