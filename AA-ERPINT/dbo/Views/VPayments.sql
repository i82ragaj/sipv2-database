CREATE VIEW [dbo].[VPayments] AS 
SELECT a.[IDPK]
      ,cast(a.[PaymentTime] as Date) [Date]
	  ,a.[PaymentTypeID]
      ,a.[ConceptTypeID]
      ,a.[TotalRevenue]
  FROM [ALLPK].[dbo].[TRPayment] a join [AA-ADMIN].[dbo].[MDParking] b on a.[IDPK] = b.[ID]
  where 
  ((b.[type] = 'SD' and ConceptTypeID = 'P') or
  (b.[type] = 'MY' and ConceptTypeID = 'P') or
  (b.[type] = 'EQ' and a.[PaymentTypeID] not in ('3','4','5')  and a.[ConceptTypeID] not in ('4', '9', '8', '13', '17')))