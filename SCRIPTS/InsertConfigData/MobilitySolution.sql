USE [AB-MY-EMPTY]
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'0', N'0', N'Ticket', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'1', N'1', N'Tarjeta de Abonado', NULL, N'A', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'2', N'2', N'Tarjeta Monedero', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'3', N'3', N'Tarjeta Abonado Temporal', NULL, N'A', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'4', N'4', N'Tarjeta Abonado Reserva', NULL, N'A', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'5', N'5', N'Tarjeta Abonado Hotel', NULL, N'A', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'9', N'9', N'Otros', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'10', N'10', N'App el Parking.com', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'11', N'11', N'Proveedor externo tipo Meypar V1', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'12', N'12', N'Proveedor externo tipo Meypar V2', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDArticle] ([ArticleID], [ArticleCode], [ArticleName], [ArticleCategory], [ArticleType], [Inserted], [Updated]) VALUES (N'13', N'13', N'Proveedor externo tipo Galatea', NULL, N'R', NULL, NULL)
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'1', N'Cobro definido por usuario.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'2', N'Cobro de estancia de Ticket.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'3', N'Recobro de estancia de Ticket.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'4', N'Cobro de ticket perdido.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'5', N'Cobro de emisión de ticket validado.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'6', N'Cobro de emisión de ticket prepagado.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'7', N'Cobro de ticket prepago.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'8', N'Renovación de abono.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'9', N'Cobro de excedido de abono.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'10', N'Devolución por tira de haber.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'12', N'Cobro de emisión de vale.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'18', N'Cobro de renovación manual de abono cliente.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'19', N'Cobro de renovación manual de abono cliente con pr', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'22', N'Cobro de estancia de ticket bonificado.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'23', N'Recobro de estancia de ticket bonificado.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'24', N'Cuota de alta de abono-cliente.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'25', N'Cuota de mantenimiento de abono-cliente.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'26', N'Cobro de depósito de tarjeta de abonado.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'27', N'Devolución de depósito de tarjeta de abonado.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'29', N'Cobro por emisión de tarjeta monedero.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'30', N'Cobro por recarga de tarjeta monedero.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'31', N'Cobro por preventa excedido.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'32', N'Cobro estancia tarjeta monedero.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'33', N'Recobro estancia tarjeta monedero.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'34', N'Cobro recarga eléctrica.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'50', N'CONCEPTO_CONTRATACION_ABONO_CLIENTE.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDConceptType] ([ConceptTypeID], [ConceptTypeName], [Inserted], [Updated]) VALUES (N'51', N'CONCEPTO_AMPLIACION_PERIODO_VALIDEZ_ABONO_CLIENTE.', CAST(N'2026-04-13T14:11:22.033' AS DateTime), CAST(N'2026-04-13T14:11:22.033' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'1', N'Terminal ESP Entrada', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'2', N'Terminal ESP Salida', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'3', N'Terminal ESP Pago y Salida', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'4', N'Terminal ESP Circulación', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'5', N'Terminal TPM', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'6', N'Terminal TPM Pago y Entrada', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'7', N'Terminal TPM Pago y Salida', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'8', N'Terminal TPM Pago y Entrada – Salida', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'9', N'Terminal TPA', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'10', N'Terminal LPP', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'11', N'Terminal Validador Autónomo', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'12', N'User Terminal', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'13', N'TVI', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'14', N'Servidor', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'15', N'Cámara IP', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'16', N'Terminal TPV', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'17', N'Entidad Emisora de Descuentos', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDDeviceType] ([DeviceTypeID], [DeviceTypeName], [Inserted], [Updated]) VALUES (N'18', N'Terminal MTPM', CAST(N'2026-04-13T18:12:36.480' AS DateTime), CAST(N'2026-04-13T18:12:36.480' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'1', N'Efectivo', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'2', N'Efectivo datafono', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'3', N'Tarjeta de crédito (TC offline)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'4', N'Vale descuento', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'5', N'Tarjeta de abonado', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'6', N'[DISPONIBLE]', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'7', N'Tarjeta externa', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'8', N'Tira de Haber', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'9', N'Efectivo talón', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'10', N'[DISPONIBLE]', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'11', N'[DISPONIBLE]', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'13', N'EMV (TC online)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'14', N'Efectivo datafono GENERICO (EMV)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'15', N'Efectivo datafono (VISA)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'16', N'Efectivo datafono (AMEX)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'17', N'Efectivo datafono (DINERS CLUB)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'18', N'Efectivo datafono (MASTERCARD)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'19', N'Efectivo datafono (4B)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'20', N'Efectivo datafono (JCB)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'21', N'Efectivo datafono (MAESTRO)', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'22', N'Tarjeta Monedero', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'23', N'[DISPONIBLE]', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'24', N'[DISPONIBLE]', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'25', N'CreditCall', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'26', N'Tarjeta Cliente', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDPaymentType] ([PaymentTypeID], [PaymentTypeName], [TransType], [inserted], [updated]) VALUES (N'27', N'Externa', N'P', CAST(N'2026-04-13T14:15:19.487' AS DateTime), CAST(N'2026-04-13T14:15:19.487' AS DateTime))
GO
INSERT [dbo].[MDSystemEvent] ([SystemEventID], [SystemEventName], [Inserted], [Updated]) VALUES (N'1', N'1 Apertura de Barrera', CAST(N'2026-05-26T10:34:08.253' AS DateTime), CAST(N'2026-05-26T10:34:08.253' AS DateTime))
GO
