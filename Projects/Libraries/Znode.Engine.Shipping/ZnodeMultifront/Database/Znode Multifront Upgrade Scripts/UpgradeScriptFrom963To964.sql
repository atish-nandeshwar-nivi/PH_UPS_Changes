IF EXISTS (SELECT TOP 1 1 FROM Sys.Tables WHERE Name = 'ZnodeMultifront')
BEGIN 
IF EXISTS (SELECT top 1 1 FROM ZnodeMultifront where BuildVersion = 964 and VersionName = 'Znode_Multifront_9_6_4' )
BEGIN 
PRINT 'Script is already executed....'
 SET NOEXEC ON 
END 
END
ELSE 
BEGIN 
  SET NOEXEC ON
END 


INSERT INTO [dbo].[ZnodeMultifront] ( [VersionName], [Descriptions], [MajorVersion], [MinorVersion], [LowerVersion], [BuildVersion], [PatchIndex], [CreatedBy], 
[CreatedDate], [ModifiedBy], [ModifiedDate]) 
VALUES ( N'Znode_Multifront_9_6_4', N'Upgrade GA Release by 964',9,6,4,964,0,2, GETDATE(),2, GETDATE())
GO 
SET ANSI_NULLS ON
GO

IF exists(select * from sys.procedures where name = 'ZnodeReport_DashboardTopAccounts')
	drop proc ZnodeReport_DashboardTopAccounts
go
CREATE PROCEDURE [dbo].[ZnodeReport_DashboardTopAccounts]              
(            
	@PortalId  bigint  = null,        
	@AccountId bigint  = null,    
	@SalesRepUserId int = 0                
)              
AS              
/*              
     Summary:- This procedure is used to get the order details              
    Unit Testing:              
     EXEC [ZnodeReport_DashboardTopAccounts]  @PortalId=7, @AccountId=0 ,@SalesRepUserId=0         
*/              
BEGIN              
BEGIN TRY              
    SET NOCOUNT ON;    
	----Verifying that the @SalesRepUserId is having 'Sales Rep' role
	IF NOT EXISTS
	(
	SELECT * FROM ZnodeUser ZU
	INNER JOIN AspNetZnodeUser ANZU ON ZU.UserName = ANZU.UserName
	INNER JOIN AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
	INNER JOIN AspNetUserRoles ANUR ON ANU.Id = ANUR.UserId
	Where Exists(select * from AspNetRoles ANR Where Name = 'Sales Rep' AND ANUR.RoleId = ANR.Id)
	AND ZU.UserId = @SalesRepUserId
	)  
	Begin
	SET @SalesRepUserId = 0
	End            
 
	DECLARE @TopItem TABLE (ItemName nvarchar(100),CustomerName nvarchar(200),ItemId nvarchar(10), Total numeric(28,6),ItemDate datetime,Symbol NVARCHAR(10))            
             
    INSERT INTO @TopItem(ItemId, ItemName,CustomerName,ItemDate,Total,Symbol)          
       
	select ZA.AccountId,ZA.[Name], isnull(ZU.FirstNAme,'')+' '+isnull(ZU.LastName,'') as UserName, ZU.CreatedDate,0,''        
	from ZnodeAccount ZA      
	left join ZnodeUser ZU on ZU.AccountId = ZA.AccountId      
	left join  ZnodePortalAccount ZUP on ZUP.AccountId = ZA.AccountId          
	WHERE (ZUP.PortalId = @PortalId OR ISNULL(@PortalId,0) = 0) AND (ZA.AccountId = @AccountId OR  ISNULL(@AccountId,0) = 0)            
	and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)        
   
   SELECT TOP 5 ItemId, ItemName,CustomerName,ItemDate,Total,Symbol FROM @TopItem Order by  Convert(numeric,Total )  desc                
   
END TRY              
             
BEGIN CATCH              
	DECLARE @Status BIT ;              
	SET @Status = 0;              
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),              
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardTopAccount @PortalId = '+@PortalId;            
                               
	SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                                  
                 
	EXEC Znode_InsertProcedureErrorLog              
	@ProcedureName = 'ZnodeReport_DashboardTopAccount',              
	@ErrorInProcedure = @Error_procedure,              
	@ErrorMessage = @ErrorMessage,              
	@ErrorLine = @ErrorLine,              
	@ErrorCall = @ErrorCall;              
END CATCH              
             
END;
go

IF exists(select * from sys.procedures where name = 'ZnodeReport_DashboardOrders')
	drop proc ZnodeReport_DashboardOrders
go

CREATE PROCEDURE [dbo].[ZnodeReport_DashboardOrders]              
(            
	@PortalId  bigint  = null,        
	@AccountId bigint  = null  ,    
	@SalesRepUserId int = 0              
)              
AS              
/*              
Summary:- This procedure is used to get the order details              
Unit Testing:              
EXEC [ZnodeReport_DashboardOrders]              
*/              
BEGIN              
BEGIN TRY              
SET NOCOUNT ON;              
	DECLARE @TopItem TABLE (ItemName nvarchar(100),CustomerName nvarchar(100),ItemId nvarchar(10), Total numeric(28,6) , Date datetime,Symbol NVARCHAR(10))              
           
                 
	DECLARE @RoundOffValue INT= dbo.Fn_GetDefaultValue('PriceRoundOff')          
   
	----Verifying that the @SalesRepUserId is having 'Sales Rep' role
	IF NOT EXISTS
	(
		SELECT * FROM ZnodeUser ZU
		INNER JOIN AspNetZnodeUser ANZU ON ZU.UserName = ANZU.UserName
		INNER JOIN AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
		INNER JOIN AspNetUserRoles ANUR ON ANU.Id = ANUR.UserId
		Where Exists(select * from AspNetRoles ANR Where Name = 'Sales Rep' AND ANUR.RoleId = ANR.Id)
		AND ZU.UserId = @SalesRepUserId
	)  
	Begin
		SET @SalesRepUserId = 0
	End    
             
	DECLARE @TBL_CultureCurrency TaBLE (Symbol Varchar(100),CurrencyCode varchar(100))              
	INSERT INTO @TBL_CultureCurrency (Symbol,CurrencyCode)              
	SELECT Symbol,CultureCode FROM  ZnodeCulture ZC              
	DECLARE @PortalCurrencySymbol nvarchar(20)          
	DECLARE @DefaultCurrencySymbol nvarchar(20)            
           
	SET @PortalCurrencySymbol = [dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalID AS INTEGER) )          
	SET @DefaultCurrencySymbol = [dbo].[Fn_GetDefaultCurrencySymbol]()          
         
	IF @PortalCurrencySymbol IS NULL          
	UPDATE @TBL_CultureCurrency SET Symbol  =@DefaultCurrencySymbol WHERE  Symbol IS NULL          
	ELSE          
	UPDATE @TBL_CultureCurrency SET Symbol  =@PortalCurrencySymbol WHERE  Symbol IS NULL          
   
	IF @AccountId = -1
	Begin
		INSERT INTO @TopItem(ItemId, ItemName,CustomerName,Date,Total,Symbol)          
		SELECT Zoo.OmsOrderId,Zoo.OrderNumber,ISNULL(RTRIM(LTRIM(ZODD.FirstName)),'')          
		+' '+ISNULL(RTRIM(LTRIM(ZODD.LastName)),'') UserName ,ZODD.OrderDate,ZODD.Total,        
		COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]())          
		FROM ZnodeOmsOrder (nolock) ZOO          
		INNER JOIN ZnodeOmsOrderDetails (nolock) ZODD ON (ZODD.OmsOrderId = ZOO.OmsOrderId AND  ZODD.IsActive = 1)          
		INNER JOIN ZnodePortal (nolock) ZP ON (ZP.PortalId = ZODD.portalId )          
		INNER JOIN ZnodePublishState ZODPS ON (ZODPS.PublishStateId = ZOO.PublishStateId)          
		LEFT JOIN ZnodePaymentType (nolock) ZPS ON (ZPS.PaymentTypeId = ZODD.PaymentTypeId )          
		LEFT JOIN  ZnodeOmsOrderStateShowToCustomer (nolock) ZOSC ON (ZOSC.OmsOrderStateId = ZODD.OmsOrderStateId)          
		LEFT JOIN ZnodeOmsOrderState (nolock) ZOS ON (ZOS.OmsOrderStateId = ZODD.OmsOrderStateId)          
		LEFT JOIN ZnodeOmsPaymentState (nolock) ZOPS ON (ZOPS.OmsPaymentStateId = ZODD.OmsPaymentStateId)          
		LEft JOIN ZnodeUser ZU ON (ZU.UserId = ZODD.UserId)          
		LEFT JOIN [dbo].[View_GetUserDetails]  (nolock) ZVGD ON (ZVGD.UserId = ZODD.CreatedBy )          
		LEFT JOIN [dbo].[View_GetUserDetails]  (nolock) ZVGDI ON (ZVGDI.UserId = ZODD.ModifiedBy)          
		LEFT JOIN ZnodeShipping ZS ON (ZS.ShippingId = ZODD.ShippingId)          
		LEFT OUTER JOIN ZnodePaymentSetting (nolock) ZPSS ON (ZPSS.PaymentSettingId = ZODD.PaymentSettingId)          
		LEFT JOIN ZnodePortalPaymentSetting (nolock) ZPPS ON (ZPPS.PaymentSettingId = ZPSS.PaymentSettingId  AND ZPPS.PortalId = ZODD.PortalId   )          
		LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZODD.CultureCode )        
		WHERE (ZP.PortalId = @PortalId OR  ISNULL(@PortalId,0) = 0)        
		and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)      
		and not Exists(Select * from ZnodeAccount ZA Where isnull(ZU.AccountId,0) = ZA.AccountId)
	End
	Else
	Begin
		INSERT INTO @TopItem(ItemId, ItemName,CustomerName,Date,Total,Symbol)          
		SELECT Zoo.OmsOrderId,Zoo.OrderNumber,ISNULL(RTRIM(LTRIM(ZODD.FirstName)),'')          
		+' '+ISNULL(RTRIM(LTRIM(ZODD.LastName)),'') UserName ,ZODD.OrderDate,ZODD.Total,        
		COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]())          
		FROM ZnodeOmsOrder (nolock) ZOO          
		INNER JOIN ZnodeOmsOrderDetails (nolock) ZODD ON (ZODD.OmsOrderId = ZOO.OmsOrderId AND  ZODD.IsActive = 1)          
		INNER JOIN ZnodePortal (nolock) ZP ON (ZP.PortalId = ZODD.portalId )          
		INNER JOIN ZnodePublishState ZODPS ON (ZODPS.PublishStateId = ZOO.PublishStateId)          
		LEFT JOIN ZnodePaymentType (nolock) ZPS ON (ZPS.PaymentTypeId = ZODD.PaymentTypeId )          
		LEFT JOIN  ZnodeOmsOrderStateShowToCustomer (nolock) ZOSC ON (ZOSC.OmsOrderStateId = ZODD.OmsOrderStateId)          
		LEFT JOIN ZnodeOmsOrderState (nolock) ZOS ON (ZOS.OmsOrderStateId = ZODD.OmsOrderStateId)          
		LEFT JOIN ZnodeOmsPaymentState (nolock) ZOPS ON (ZOPS.OmsPaymentStateId = ZODD.OmsPaymentStateId)          
		LEFT JOIN ZnodeUser ZU ON (ZU.UserId = ZODD.UserId)          
		LEFT JOIN [dbo].[View_GetUserDetails]  (nolock) ZVGD ON (ZVGD.UserId = ZODD.CreatedBy )          
		LEFT JOIN [dbo].[View_GetUserDetails]  (nolock) ZVGDI ON (ZVGDI.UserId = ZODD.ModifiedBy)          
		LEFT JOIN ZnodeShipping ZS ON (ZS.ShippingId = ZODD.ShippingId)          
		LEFT OUTER JOIN ZnodePaymentSetting (nolock) ZPSS ON (ZPSS.PaymentSettingId = ZODD.PaymentSettingId)          
		LEFT JOIN ZnodePortalPaymentSetting (nolock) ZPPS ON (ZPPS.PaymentSettingId = ZPSS.PaymentSettingId  AND ZPPS.PortalId = ZODD.PortalId   )          
		LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZODD.CultureCode )        
		WHERE (ZP.PortalId = @PortalId OR  ISNULL(@PortalId,0) = 0) AND (ZU.AccountId = @AccountId OR  ISNULL(@AccountId,0) = 0)        
		and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)      
	End

	SELECT TOP 5 ItemId, ItemName,CustomerName,Date,Total,Symbol FROM @TopItem Order by  Convert(datetime,Date )  desc                
   
END TRY              
             
BEGIN CATCH              
	DECLARE @Status BIT ;        
	SET @Status = 0;              
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),              
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardOrders @PortalId = '+@PortalId;            
                               
	SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                                  
                 
	EXEC Znode_InsertProcedureErrorLog              
	@ProcedureName = 'ZnodeReport_DashboardOrders',              
	@ErrorInProcedure = @Error_procedure,              
	@ErrorMessage = @ErrorMessage,              
	@ErrorLine = @ErrorLine,              
	@ErrorCall = @ErrorCall;              
END CATCH              
             
END;
go

IF exists(select * from sys.procedures where name = 'ZnodeReport_DashboardQuotes')
	drop proc ZnodeReport_DashboardQuotes
go

CREATE PROCEDURE [dbo].[ZnodeReport_DashboardQuotes]              
(             
	@PortalId  bigint  = null,        
	@AccountId bigint  = null,    
	@SalesRepUserId int = 0                
)              
AS               
/*              
     Summary:- This procedure is used to get the order details               
    Unit Testing:              
     EXEC [ZnodeReport_DashboardTopCategory]              
*/              
BEGIN              
BEGIN TRY              
SET NOCOUNT ON;              
	
	DECLARE @TopItem TABLE (ItemName nvarchar(100),CustomerName nvarchar(100),ItemId nvarchar(10), Total numeric(28,6) , Date datetime,Symbol NVARCHAR(10))               
     
	DECLARE @RoundOffValue INT= dbo.Fn_GetDefaultValue('PriceRoundOff')      
        
	----Verifying that the @SalesRepUserId is having 'Sales Rep' role
	IF NOT EXISTS
	(
		SELECT * FROM ZnodeUser ZU
		INNER JOIN AspNetZnodeUser ANZU ON ZU.UserName = ANZU.UserName
		INNER JOIN AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
		INNER JOIN AspNetUserRoles ANUR ON ANU.Id = ANUR.UserId
		Where Exists(select * from AspNetRoles ANR Where Name = 'Sales Rep' AND ANUR.RoleId = ANR.Id) 
		AND ZU.UserId = @SalesRepUserId
	)   
	Begin
		SET @SalesRepUserId = 0
	End              
  
	DECLARE @TBL_CultureCurrency TaBLE (Symbol Varchar(100),CurrencyCode varchar(100))              
	INSERT INTO @TBL_CultureCurrency (Symbol,CurrencyCode)              
	SELECT Symbol,CultureCode FROM  ZnodeCulture ZC               
	DECLARE @PortalCurrencySymbol nvarchar(20)          
	DECLARE @DefaultCurrencySymbol nvarchar(20)            
            
	SET @PortalCurrencySymbol = [dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalID AS INTEGER) )          
	SET @DefaultCurrencySymbol = [dbo].[Fn_GetDefaultCurrencySymbol]()           
          
	IF @PortalCurrencySymbol IS NULL           
	UPDATE @TBL_CultureCurrency SET Symbol  =@DefaultCurrencySymbol WHERE  Symbol IS NULL          
	ELSE           
	UPDATE @TBL_CultureCurrency SET Symbol  =@PortalCurrencySymbol WHERE  Symbol IS NULL          
     
	CREATE TABLE #User(UserId INT, FirstName varchar(100), MiddleName varchar(100), LastName varchar(100), Email varchar(50), PhoneNumber varchar(50))

	IF @AccountId = -1
		INSERT INTO #User(UserId, FirstName, MiddleName, LastName, Email , PhoneNumber )
		SELECT ZU.UserId, ZU.FirstName, ZU.MiddleName, ZU.LastName, ZU.Email , ZU.PhoneNumber                    
		FROM ZnodeUser ZU           
		WHERE EXISTS(SELECT * FROM ZnodeOmsQuote ZOQ where ZU.UserId = ZOQ.UserID )        
		and ISNULL(ZU.AccountId,0) = 0      
	Else
		INSERT INTO #User(UserId, FirstName, MiddleName, LastName, Email , PhoneNumber )
		SELECT ZU.UserId, ZU.FirstName, ZU.MiddleName, ZU.LastName, ZU.Email , ZU.PhoneNumber          
		FROM ZnodeUser ZU           
		WHERE EXISTS(SELECT * FROM ZnodeOmsQuote ZOQ where ZU.UserId = ZOQ.UserID )        
		and (ZU.AccountId = @AccountId or isnull(@AccountId,0) = 0 ) 
          
	Update ZOQ set OmsOrderStateId = (select top 1 OmsOrderStateId from ZnodeOMSOrderState where OrderStateName = 'EXPIRED')          
	from ZnodeOmsQuote ZOQ          
	Inner Join ZnodeOmsQuoteType ZOQT ON ZOQ.OmsQuoteTypeId = ZOQT.OmsQuoteTypeId          
	INNER JOIN #User U ON ZOQ.UserId = U.UserId           
	INNER JOIN ZnodePortal ZP ON ZOQ.PortalID = ZP.PortalID          
	INNER JOIN ZnodeOMSOrderState ZOOS ON ZOOS.OmsOrderStateId = ZOQ.OmsOrderStateId          
	where  (ZOQ.PortalID = @PortalId OR @PortalId = 0 OR @PortalId is null)          
	and cast(ZOQ.QuoteExpirationDate as date) < cast(GETDATE() as date)          
	and ZOQ.OmsOrderStateId <> (select top 1 OmsOrderStateId from ZnodeOMSOrderState where OrderStateName = 'EXPIRED')          
          
	insert into @TopItem(ItemId, ItemName,CustomerName,Date,Total,Symbol)          
	Select ZOQ.OmsQuoteId,ZOQ.QuoteNumber as QuoteNumber,isnull(U.FirstName,'')+case when U.MiddleName is not null then ' ' else '' end+ isnull(U.MiddleName,'')+' '+isnull(U.LastName,'') as CustomerName,          
	ZOQ.CreatedDate as QuoteDate,ZOQ.QuoteOrderTotal as TotalAmount        
	,COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]()) Symbol              
	from ZnodeOmsQuote ZOQ          
	Inner Join ZnodeOmsQuoteType ZOQT ON ZOQ.OmsQuoteTypeId = ZOQT.OmsQuoteTypeId          
	INNER JOIN #User U ON ZOQ.UserId = U.UserId           
	INNER JOIN ZnodePortal ZP ON ZOQ.PortalID = ZP.PortalID          
	INNER JOIN ZnodeOMSOrderState ZOOS ON ZOOS.OmsOrderStateId = ZOQ.OmsOrderStateId          
	LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZOQ.CultureCode )           
	where  (ZOQ.PortalID = @PortalId OR @PortalId = 0 OR @PortalId is null)          
	and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and U.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)              
	and ZOQT.QuoteTypeCode = 'QUOTE'
	
	SELECT TOP 5 ItemId, ItemName,CustomerName,Date,Total,Symbol FROM @TopItem Order by  Convert(datetime,Date )  desc                
   
END TRY              
              
BEGIN CATCH              
	DECLARE @Status BIT ;              
		SET @Status = 0;              
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),              
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardQuotes @PortalId = '+@PortalId;             
                                
				SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                                  
                  
				EXEC Znode_InsertProcedureErrorLog              
	@ProcedureName = 'ZnodeReport_DashboardQuotes',              
	@ErrorInProcedure = @Error_procedure,              
	@ErrorMessage = @ErrorMessage,              
	@ErrorLine = @ErrorLine,              
	@ErrorCall = @ErrorCall;              
END CATCH              
              
END;
go
IF exists(select * from sys.procedures where name = 'ZnodeReport_DashboardReturns')
	drop proc ZnodeReport_DashboardReturns
go

CREATE PROCEDURE [dbo].[ZnodeReport_DashboardReturns]              
(             
	 @PortalId  bigint  = null,        
	 @AccountId bigint  = null  ,    
	 @SalesRepUserId int = 0              
)              
AS               
/*              
     Summary:- This procedure is used to get the order details               
    Unit Testing:              
     EXEC [ZnodeReport_DashboardReturns]              
*/              
BEGIN              
BEGIN TRY              
  SET NOCOUNT ON;              
  DECLARE @TopItem TABLE (ItemName nvarchar(100),CustomerName nvarchar(100),ItemId nvarchar(10), Total numeric(28,6) , Date datetime,Symbol NVARCHAR(10))               
            
                 
  DECLARE @RoundOffValue INT= dbo.Fn_GetDefaultValue('PriceRoundOff')   
           
  ----Verifying that the @SalesRepUserId is having 'Sales Rep' role
	IF NOT EXISTS
	(
		SELECT * FROM ZnodeUser ZU
		INNER JOIN AspNetZnodeUser ANZU ON ZU.UserName = ANZU.UserName
		INNER JOIN AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
		INNER JOIN AspNetUserRoles ANUR ON ANU.Id = ANUR.UserId
		Where Exists(select * from AspNetRoles ANR Where Name = 'Sales Rep' AND ANUR.RoleId = ANR.Id) 
		AND ZU.UserId = @SalesRepUserId
	)   
	Begin
		SET @SalesRepUserId = 0
	End               
  
  DECLARE @TBL_CultureCurrency TaBLE (Symbol Varchar(100),CurrencyCode varchar(100))              
  INSERT INTO @TBL_CultureCurrency (Symbol,CurrencyCode)              
  SELECT Symbol,CultureCode FROM  ZnodeCulture ZC               
  DECLARE @PortalCurrencySymbol nvarchar(20)          
  DECLARE @DefaultCurrencySymbol nvarchar(20)            
            
  SET @PortalCurrencySymbol = [dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalID AS INTEGER) )          
  SET @DefaultCurrencySymbol = [dbo].[Fn_GetDefaultCurrencySymbol]()           
          
  IF @PortalCurrencySymbol IS NULL           
  UPDATE @TBL_CultureCurrency SET Symbol  =@DefaultCurrencySymbol WHERE  Symbol IS NULL          
  ELSE           
  UPDATE @TBL_CultureCurrency SET Symbol  =@PortalCurrencySymbol WHERE  Symbol IS NULL          
              
   IF @AccountId = -1
   Begin
		INSERT INTO @TopItem(ItemId, ItemName,CustomerName,Date,Total,Symbol)                
		select ZRRD.RmaReturnDetailsId,ZRRD.ReturnNumber, isnull(ZU.FirstNAme,'''')+' '+isnull(ZU.LastName,'') as UserName,ZRRD.ReturnDate,          
		round(ZRRD.TotalReturnAmount,@RoundOffValue) TotalReturnAmount,          
		COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]())               
		from ZnodeRmaReturnDetails ZRRD          
		inner join ZnodeUser ZU ON ZRRD.UserId = ZU.UserId          
		inner join ZnodePortal ZP ON ZRRD.PortalId = ZP.PortalId           
		inner join ZnodeRmaReturnState ZRRS on ZRRD.RmaReturnStateId = ZRRS.RmaReturnStateId          
		LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZRRD.CultureCode )         
		where isnull(ZRRD.RmaReturnStateId,0) not in (select isnull(RmaReturnStateId,0) from ZnodeRmaReturnState where ReturnStateName = 'Not Submitted')          
		AND (ZRRD.PortalId = @PortalId OR  isnull(@PortalId,0)= 0)            
		and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)       
		and IsNull(ZU.AccountId,0) = 0
   End
   Else
   Begin
	   INSERT INTO @TopItem(ItemId, ItemName,CustomerName,Date,Total,Symbol)  
	   select ZRRD.RmaReturnDetailsId,ZRRD.ReturnNumber, isnull(ZU.FirstNAme,'''')+' '+isnull(ZU.LastName,'') as UserName,ZRRD.ReturnDate,          
		round(ZRRD.TotalReturnAmount,@RoundOffValue) TotalReturnAmount,          
		COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]())               
	   from ZnodeRmaReturnDetails ZRRD          
	   inner join ZnodeUser ZU ON ZRRD.UserId = ZU.UserId          
	   inner join ZnodePortal ZP ON ZRRD.PortalId = ZP.PortalId           
	   inner join ZnodeRmaReturnState ZRRS on ZRRD.RmaReturnStateId = ZRRS.RmaReturnStateId          
	   LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZRRD.CultureCode )         
	   where isnull(ZRRD.RmaReturnStateId,0) not in (select isnull(RmaReturnStateId,0) from ZnodeRmaReturnState where ReturnStateName = 'Not Submitted')          
	   AND (ZRRD.PortalId = @PortalId OR  isnull(@PortalId,0)= 0) AND (ZU.AccountId = @AccountId OR  ISNULL(@AccountId,0) = 0)            
	   and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)       
   End

   SELECT TOP 5 ItemId, ItemName,CustomerName,Date,Total,Symbol FROM @TopItem Order by  Convert(numeric,Total )  desc                
   
END TRY              
              
BEGIN CATCH              
	DECLARE @Status BIT ;              
		SET @Status = 0;              
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),              
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardReturns @PortalId = '+@PortalId;             
                                
				SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                                  
                  
				EXEC Znode_InsertProcedureErrorLog              
	@ProcedureName = 'ZnodeReport_DashboardReturns',              
	@ErrorInProcedure = @Error_procedure,              
	@ErrorMessage = @ErrorMessage,              
	@ErrorLine = @ErrorLine,              
	@ErrorCall = @ErrorCall;              
END CATCH              
              
END;
go

IF exists(select * from sys.procedures where name = 'ZnodeReport_DashboardSales')
	drop proc ZnodeReport_DashboardSales
go

CREATE PROCEDURE [dbo].[ZnodeReport_DashboardSales]            
(                  
@PortalId  bigint  = null,        
@AccountId bigint  = null,    
@SalesRepUserId int = 0                      
)            
AS            
/*            
    Summary:- This procedure is used to get the order details            
    Unit Testing:            
    EXEC [ZnodeReport_DashboardSales] @PortalId=8, @AccountId=0, @SalesRepUserId=19          
*/            
  BEGIN            
  BEGIN TRY            
  SET NOCOUNT ON;            
         
  DECLARE @TotalNewCust int, @Frequency int, @TotalQuotes int, @TotalReturns int            
         
  DECLARE @TBL_CultureCurrency TaBLE (Symbol Varchar(100),CurrencyCode varchar(100),IsDefault bit)            
  INSERT INTO @TBL_CultureCurrency (Symbol,CurrencyCode,IsDefault)            
  SELECT Symbol,CultureCode, IsDefault from  ZnodeCulture ZC  -- Changed ZnodeCurrency to ZnodeCulture here.          
           
  DECLARE @PortalCurrencySymbol nvarchar(20)        
  DECLARE @DefaultCurrencySymbol nvarchar(20)          
   
----Verifying that the @SalesRepUserId is having 'Sales Rep' role
IF NOT EXISTS
(
SELECT * FROM ZnodeUser ZU
INNER JOIN AspNetZnodeUser ANZU ON ZU.UserName = ANZU.UserName
INNER JOIN AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
INNER JOIN AspNetUserRoles ANUR ON ANU.Id = ANUR.UserId
Where Exists(select * from AspNetRoles ANR Where Name = 'Sales Rep' AND ANUR.RoleId = ANR.Id)
AND ZU.UserId = @SalesRepUserId
)  
Begin
SET @SalesRepUserId = 0
End  
 
  SET @PortalCurrencySymbol = [dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalID AS INTEGER) )        
  SET @DefaultCurrencySymbol = [dbo].[Fn_GetDefaultCurrencySymbol]()        
       
  IF @PortalCurrencySymbol IS NULL        
 UPDATE @TBL_CultureCurrency SET Symbol  =@DefaultCurrencySymbol WHERE  Symbol IS NULL        
  ELSE        
    UPDATE @TBL_CultureCurrency SET Symbol  =@PortalCurrencySymbol WHERE  Symbol IS NULL        
       
               
    -- this will CHECK for customer            
 
  CREATE TABLE #User(UserId int, FirstName varchar(100), MiddleName varchar(100), LastName varchar(100), Email varchar(50), PhoneNumber varchar(50),AccountId int )
 
  Create table #CalculateTotalValues(TotalOrders int, TotalSales int, Symbol varchar(100))

  IF @AccountId = -1
  Begin
INSERT INTO #User(UserId, FirstName, MiddleName, LastName, Email , PhoneNumber,AccountId)
SELECT ZU.UserId, ZU.FirstName, ZU.MiddleName, ZU.LastName, ZU.Email , ZU.PhoneNumber ,ZU.AccountId                  
FROM ZnodeUser ZU          
WHERE EXISTS(SELECT * FROM ZnodeOmsQuote ZOQ where ZU.UserId = ZOQ.UserID )      
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)  
AND ISNULL(ZU.AccountId,0)=0

SELECT @TotalNewCust = COUNT(*)        
FROM View_CustomerUserDetail CUD  WHERE                      
(CUD.PortalId=@PortalId OR ISNULL(@PortalId,0)=0) AND  (ISNULL(CUD.AccountId,0)=0)    
     
INSERT INTO #CalculateTotalValues(TotalOrders, TotalSales, Symbol)        
SELECT   count(*)  TotalOrders , sum(ZOOD.Total) TotalSales,      
COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]()) Symbol                
FROM ZNodeOmsOrder ZOO            
INNER JOIN ZnodeOmsOrderDetails ZOOD ON(ZOOD.OmsOrderId = ZOO.OmsOrderId AND IsActive = 1)            
INNER JOIN ZNodePortal P ON (P.PortalID = ZOOD.PortalId )        
LEFT JOIN ZnodeUser ZU ON (ZU.UserId = ZOOD.UserId)    
LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZOOD.CurrencyCode )            
WHERE ZOOD.IsActive =1 AND (P.PortalId = @PortalId OR ISNULL(@PortalId,0)=0)    
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)          
and not Exists(Select * from ZnodeAccount ZA Where isnull(ZU.AccountId,0) = ZA.AccountId)
Group by ZC.Symbol

Select @TotalQuotes = COUNT(*)                    
from ZnodeOmsQuote ZOQ          
Inner Join ZnodeOmsQuoteType ZOQT ON ZOQ.OmsQuoteTypeId = ZOQT.OmsQuoteTypeId          
INNER JOIN #User U ON ZOQ.UserId = U.UserId          
INNER JOIN ZnodePortal ZP ON ZOQ.PortalID = ZP.PortalID          
INNER JOIN ZnodeOMSOrderState ZOOS ON ZOOS.OmsOrderStateId = ZOQ.OmsOrderStateId          
LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZOQ.CultureCode )          
where  (ZOQ.PortalID = @PortalId OR @PortalId = 0 OR @PortalId is null)    
and not Exists(Select * from ZnodeAccount ZA Where isnull(U.AccountId,0) = ZA.AccountId)
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and U.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)      
     
-- This will get returns count      
select @TotalReturns = COUNT(*)              
from ZnodeRmaReturnDetails ZRRD          
inner join ZnodeUser ZU ON ZRRD.UserId = ZU.UserId          
inner join ZnodePortal ZP ON ZRRD.PortalId = ZP.PortalId          
inner join ZnodeRmaReturnState ZRRS on ZRRD.RmaReturnStateId = ZRRS.RmaReturnStateId          
LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZRRD.CultureCode )        
where isnull(ZRRD.RmaReturnStateId,0) not in (select isnull(RmaReturnStateId,0) from ZnodeRmaReturnState where ReturnStateName = 'Not Submitted')          
AND (ZRRD.PortalId = @PortalId OR @PortalId  =0 or @PortalId is null)    
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)  
and not Exists(Select * from ZnodeAccount ZA Where isnull(ZU.AccountId,0) = ZA.AccountId)
 End
 Else
 Begin
   -- This will get quotes count
INSERT INTO #User(UserId, FirstName, MiddleName, LastName, Email , PhoneNumber)
SELECT ZU.UserId, ZU.FirstName, ZU.MiddleName, ZU.LastName, ZU.Email , ZU.PhoneNumber                
FROM ZnodeUser ZU          
WHERE EXISTS(SELECT * FROM ZnodeOmsQuote ZOQ where ZU.UserId = ZOQ.UserID )    AND (ZU.AccountId = @AccountId OR ISNULL(@AccountId,0)=0)    
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)  
     
SELECT @TotalNewCust = COUNT(*)        
 FROM View_CustomerUserDetail CUD  WHERE                      
 (CUD.PortalId=@PortalId OR ISNULL(@PortalId,0)=0) AND  (CUD.AccountId = @AccountId OR ISNULL(@AccountId,0)=0)    
     
INSERT INTO #CalculateTotalValues (TotalOrders, TotalSales, Symbol)
SELECT   count(*)  TotalOrders , sum(ZOOD.Total) TotalSales,      
COALESCE (ZC.Symbol,[dbo].[Fn_GetPortalCurrencySymbol](CAST(@PortalId AS INTEGER)),[dbo].[Fn_GetDefaultCurrencySymbol]()) Symbol                      
FROM ZNodeOmsOrder ZOO            
INNER JOIN ZnodeOmsOrderDetails ZOOD ON(ZOOD.OmsOrderId = ZOO.OmsOrderId AND IsActive = 1)            
INNER JOIN ZNodePortal P ON (P.PortalID = ZOOD.PortalId )        
LEFT JOIN #User ZU ON (ZU.UserId = ZOOD.UserId)    
LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZOOD.CurrencyCode )            
WHERE ZOOD.IsActive =1 AND (P.PortalId = @PortalId OR ISNULL(@PortalId,0)=0) AND (ZU.AccountId = @AccountId OR ISNULL(@AccountId,0)=0)    
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)          
Group by ZC.Symbol

Select @TotalQuotes = COUNT(*)                    
from ZnodeOmsQuote ZOQ          
Inner Join ZnodeOmsQuoteType ZOQT ON ZOQ.OmsQuoteTypeId = ZOQT.OmsQuoteTypeId          
INNER JOIN #User U ON ZOQ.UserId = U.UserId          
INNER JOIN ZnodePortal ZP ON ZOQ.PortalID = ZP.PortalID          
INNER JOIN ZnodeOMSOrderState ZOOS ON ZOOS.OmsOrderStateId = ZOQ.OmsOrderStateId          
LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZOQ.CultureCode )          
where  (ZOQ.PortalID = @PortalId OR @PortalId = 0 OR @PortalId is null)          
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and U.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)      
     
-- This will get returns count      
select @TotalReturns = COUNT(*)              
from ZnodeRmaReturnDetails ZRRD          
inner join ZnodeUser ZU ON ZRRD.UserId = ZU.UserId          
inner join ZnodePortal ZP ON ZRRD.PortalId = ZP.PortalId          
inner join ZnodeRmaReturnState ZRRS on ZRRD.RmaReturnStateId = ZRRS.RmaReturnStateId          
LEFT JOIN @TBL_CultureCurrency ZC ON (ZC.CurrencyCode = ZRRD.CultureCode )        
where isnull(ZRRD.RmaReturnStateId,0) not in (select isnull(RmaReturnStateId,0) from ZnodeRmaReturnState where ReturnStateName = 'Not Submitted')          
AND (ZRRD.PortalId = @PortalId OR @PortalId  =0 or @PortalId is null)  AND (ZU.AccountId = @AccountId OR ISNULL(@AccountId,0)=0)    
and (exists(select * from ZnodeSalesRepCustomerUserPortal SalRep where SalRep.SalesRepUserId = @SalesRepUserId and ZU.UserId = SalRep.CustomerUserid) or @SalesRepUserId = 0)  
 
 End

  Update ZOQ set OmsOrderStateId = (select top 1 OmsOrderStateId from ZnodeOMSOrderState where OrderStateName = 'EXPIRED')          
  from ZnodeOmsQuote ZOQ          
  Inner Join ZnodeOmsQuoteType ZOQT ON ZOQ.OmsQuoteTypeId = ZOQT.OmsQuoteTypeId          
  INNER JOIN #User U ON ZOQ.UserId = U.UserId          
  INNER JOIN ZnodePortal ZP ON ZOQ.PortalID = ZP.PortalID          
  INNER JOIN ZnodeOMSOrderState ZOOS ON ZOOS.OmsOrderStateId = ZOQ.OmsOrderStateId          
  where  (ZOQ.PortalID = @PortalId OR ISNULL(@PortalId,0)=0)          
  and cast(ZOQ.QuoteExpirationDate as date) < cast(GETDATE() as date)          
  and ZOQ.OmsOrderStateId <> (select top 1 OmsOrderStateId from ZnodeOMSOrderState where OrderStateName = 'EXPIRED')          
         
           
  SELECT  Sum(TotalOrders) AS TotalOrders,Sum(TotalSales) AS TotalSales,Symbol,@TotalNewCust AS TotalNewCust, @TotalQuotes as TotalQuotes, @TotalReturns as TotalReturns      
  INTO #TotalValues        
  FROM #CalculateTotalValues          
  GROUP BY Symbol            
       
  IF not exists(select * from #TotalValues)
  Begin
SELECT 0 as TotalOrders, cast('0' as varchar(10)) as TotalSales            
 , 0 as TotalNewCust ,0 AS TotalAvgOrders,0 as TotalQuotes,0 as TotalReturns ,
 [dbo].[Fn_GetDefaultCurrencySymbol]() Symbol          
 
  End
  Else
  Begin
 SELECT TotalOrders, [dbo].[Fn_GetDefaultPriceRoundOff](TotalSales) TotalSales            
 , TotalNewCust ,Isnull(TotalOrders / @Frequency,0) AS TotalAvgOrders,TotalQuotes,TotalReturns ,Symbol        
 FROM #TotalValues
  End

       
  END TRY            
  BEGIN CATCH            
  DECLARE @Status BIT ;            
 SET @Status = 0;            
 DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),            
 @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardSales @PortalId='+CAST(@PortalId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));            
                             
 SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                                
               
    EXEC Znode_InsertProcedureErrorLog            
    @ProcedureName = 'ZnodeReport_DashboardSales',            
    @ErrorInProcedure = @Error_procedure,            
    @ErrorMessage = @ErrorMessage,            
    @ErrorLine = @ErrorLine,            
    @ErrorCall = @ErrorCall;            
  END CATCH            
  END;
  go
  
 IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IDX_ZnodeOmsPersonalizeCartItem_OmsSavedCartLineItemId' AND object_id = OBJECT_ID('ZnodeOmsPersonalizeCartItem'))
    BEGIN
       CREATE NONCLUSTERED INDEX IDX_ZnodeOmsPersonalizeCartItem_OmsSavedCartLineItemId
			ON [dbo].ZnodeOmsPersonalizeCartItem (OmsSavedCartLineItemId)
			
    END

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IDX_ZnodeOmsSavedCartLineItemDetails_OmsSavedCartLineItemId' AND object_id = OBJECT_ID('ZnodeOmsSavedCartLineItemDetails'))
    BEGIN
        CREATE NONCLUSTERED INDEX IDX_ZnodeOmsSavedCartLineItemDetails_OmsSavedCartLineItemId
			ON [dbo].ZnodeOmsSavedCartLineItemDetails (OmsSavedCartLineItemId)
    END
go	
  IF exists(select * from sys.procedures where name = 'Znode_DeleteSaveCartLineItem')
	drop proc Znode_DeleteSaveCartLineItem
go

CREATE PROCEDURE [dbo].[Znode_DeleteSaveCartLineItem]
(
	  @OmsSavedCartLineItemId  int,
	  @Status bit OUT 
)
AS 
BEGIN
	
	BEGIN TRY
	SET NOCOUNT ON;

		DECLARE @TBL_DeleteSavecartLineitems TABLE (OmsSavedCartLineItemId int)
		IF OBJECT_ID(N'tempdb..#TBL_ZnodeOmsSavedCartLineItem') IS NOT NULL
			DROP TABLE #TBL_ZnodeOmsSavedCartLineItem

		----Getting date related to @OmsSavedCartLineItemId input parameter into a table
		SELECT OmsSavedCartLineItemId,	ParentOmsSavedCartLineItemId   
			INTO #TBL_ZnodeOmsSavedCartLineItem  from ZnodeOmsSavedCartLineItem  with (NOLOCK)
			where OmsSavedCartLineItemId = @OmsSavedCartLineItemId or ParentOmsSavedCartLineItemId =@OmsSavedCartLineItemId 

		--selecting all the child line items and the parent line Item which has no child item
			INSERT INTO @TBL_DeleteSavecartLineitems
				SELECT OmsSavedCartLineItemId from #TBL_ZnodeOmsSavedCartLineItem
					union
					SELECT ParentOmsSavedCartLineItemId from #TBL_ZnodeOmsSavedCartLineItem
						where not exists (select  OmsSavedCartLineItemId,	ParentOmsSavedCartLineItemId from ZnodeOmsSavedCartLineItem   with (NOLOCK)
								where OmsSavedCartLineItemId != #TBL_ZnodeOmsSavedCartLineItem.OmsSavedCartLineItemId and  ParentOmsSavedCartLineItemId =#TBL_ZnodeOmsSavedCartLineItem.ParentOmsSavedCartLineItemId)
								and ParentOmsSavedCartLineItemId is not null
	BEGIN TRAN DeleteSaveCartLineItem;

			IF exists (select top 1 1 from @TBL_DeleteSavecartLineitems)
			Begin
						DELETE FROM ZnodeOmsPersonalizeCartItem
						WHERE EXISTS
						(
							SELECT TOP 1 1
							FROM @TBL_DeleteSavecartLineitems DeleteSaveCart
							WHERE DeleteSaveCart.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId
						);
						DELETE ZnodeOmsSavedCartLineItemDetails
						WHERE EXISTS
						(
							SELECT TOP 1 1
							FROM @TBL_DeleteSavecartLineitems DeleteSaveCart
							WHERE DeleteSaveCart.OmsSavedCartLineItemId = ZnodeOmsSavedCartLineItemDetails.OmsSavedCartLineItemId
		
						);
						DELETE FROM ZnodeOmsSavedCartLineItem 
						WHERE EXISTS
						(
							SELECT TOP 1 1
							FROM @TBL_DeleteSavecartLineitems DeleteSaveCart
							WHERE DeleteSaveCart.OmsSavedCartLineItemId = ZnodeOmsSavedCartLineItem.OmsSavedCartLineItemId
						);

			End	
	COMMIT TRAN DeleteSaveCartLineItem;
	SET @Status = 1;
	
	END TRY
	BEGIN CATCH
		SET @Status = 0;
		DECLARE @Error_procedure varchar(1000)= ERROR_PROCEDURE(), @ErrorMessage nvarchar(max)= ERROR_MESSAGE(), @ErrorLine varchar(100)= ERROR_LINE(), @ErrorCall nvarchar(max)= 'EXEC Znode_DeleteSaveCartLineItem @OmsSavedCartLineItemId = '+CAST(@OmsSavedCartLineItemId AS varchar(max))
		SELECT 0 AS ID, CAST(0 AS bit) AS Status,ERROR_MESSAGE();
		ROLLBACK TRAN DeleteSaveCartLineItem;
		EXEC Znode_InsertProcedureErrorLog @ProcedureName = 'Znode_DeleteSaveCartLineItem', @ErrorInProcedure = @Error_procedure, @ErrorMessage = @ErrorMessage, @ErrorLine = @ErrorLine, @ErrorCall = @ErrorCall;
	END CATCH;
END

go	
  IF exists(select * from sys.procedures where name = 'Znode_GetUserDetailsByAspNetUserId')
	drop proc Znode_GetUserDetailsByAspNetUserId
go

CREATE PROCEDURE [dbo].[Znode_GetUserDetailsByAspNetUserId]
(
	@AspNetUserId NVARCHAR(256),
	@PortalId INT
)
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	Declare @UserId INT,@AcountId INT, @UserPortalStatus BIT

	SELECT @UserId = UserId,@AcountId=AccountId FROM ZnodeUser 
	WHERE AspNetUserId = @AspNetUserId
	
	--To get the user data
	SELECT * FROM ZnodeUser 
	where UserId = @UserId
	
	--To get the users addresses
	SELECT ZUA.UserAddressId,ZUA.UserId,ZA.AddressId,ZA.FirstName,ZA.LastName,ZA.DisplayName,ZA.CompanyName,ZA.Address1,ZA.Address2,ZA.Address3,
		   ZA.CountryName,ZA.StateName,ZA.CityName,ZA.PostalCode,ZA.PhoneNumber,ZA.Mobilenumber,ZA.AlternateMobileNumber,
		   ZA.FaxNumber,ZA.IsDefaultBilling,ZA.IsDefaultShipping,ZA.IsActive,ZA.ExternalId,ZA.IsShipping,ZA.IsBilling,ZA.EmailAddress 
	FROM ZnodeAddress ZA
	INNER JOIN ZnodeUserAddress ZUA ON ZUA.AddressId = ZA.AddressId 
	WHERE ZUA.UserId = @UserId
	Union All
	--To get the users account addresses
	SELECT ZUA.AccountAddressId,@UserId as UserId,ZA.AddressId,ZA.FirstName,ZA.LastName,ZA.DisplayName,ZA.CompanyName,ZA.Address1,ZA.Address2,ZA.Address3,
		   ZA.CountryName,ZA.StateName,ZA.CityName,ZA.PostalCode,ZA.PhoneNumber,ZA.Mobilenumber,ZA.AlternateMobileNumber,
		   ZA.FaxNumber,ZA.IsDefaultBilling,ZA.IsDefaultShipping,ZA.IsActive,ZA.ExternalId,ZA.IsShipping,ZA.IsBilling,ZA.EmailAddress 
	FROM ZnodeAddress ZA
	INNER JOIN ZnodeAccountAddress ZUA ON ZUA.AddressId = ZA.AddressId 
	WHERE ZUA.AccountId = @AcountId 
	
	--To get the users whishlists
	SELECT UserWishListId,UserId,SKU,WishListAddedDate,AddOnSKUs 
	FROM ZnodeUserWishList
	WHERE UserId = @UserId
	
	--To get the users profiles	
	SELECT ZP.ProfileId,ZP.ProfileName,ZP.ShowOnPartnerSignup,ZP.Weighting,ZP.TaxExempt,ZP.DefaultExternalAccountNo,ZP.ParentProfileId, ZUP.IsDefault
	FROM ZnodeProfile ZP
	INNER JOIN ZnodeUserProfile ZUP ON ZP.ProfileId = ZUP.ProfileId 
	WHERE ZUP.UserId = @UserId

	IF EXISTS(SELECT * FROM ZnodeUserPortal WHERE PortalId = @PortalId AND UserId = @UserId)
		SET @UserPortalStatus = 1
	ELSE
		SET @UserPortalStatus = 0

	Select @UserPortalStatus as UserPortalStatus

END TRY 
BEGIN CATCH 

	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetUserDetailsByAspNetUserId @AspNetUserId = '+CAST(@AspNetUserId AS VARCHAR(200))+', @PortalId = '+CAST(@PortalId AS VARCHAR(200))+',@UserPortalStatus ='+CAST(@UserPortalStatus AS VARCHAR(10));
    EXEC Znode_InsertProcedureErrorLog
	@ProcedureName = 'Znode_GetUserDetailsByAspNetUserId',
	@ErrorInProcedure = @Error_procedure,
	@ErrorMessage = @ErrorMessage,
	@ErrorLine = @ErrorLine,
	@ErrorCall = @ErrorCall;

END CATCH 
END

go	
  IF exists(select * from sys.procedures where name = 'Znode_GetUserDetailsByAspNetUserId')
	drop proc Znode_GetUserDetailsByAspNetUserId
go

CREATE PROCEDURE [dbo].[Znode_GetUserDetailsByAspNetUserId]
(
	@AspNetUserId NVARCHAR(256),
	@PortalId INT
)
AS
--execute [Znode_GetUserDetailsByAspNetUserId] 'ab9ac88f-cdeb-4ddd-a7e7-9193d71cc91d',1
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	Declare @UserId INT,@AcountId INT, @UserPortalStatus BIT

	SELECT @UserId = UserId,@AcountId=AccountId FROM ZnodeUser 
	WHERE AspNetUserId = @AspNetUserId
	
	--To get the user data
	SELECT * FROM ZnodeUser 
	where UserId = @UserId
	
	--To get the users addresses
	SELECT ZUA.UserAddressId,ZUA.UserId,ZA.AddressId,ZA.FirstName,ZA.LastName,ZA.DisplayName,ZA.CompanyName,ZA.Address1,ZA.Address2,ZA.Address3,
		   ZA.CountryName,ZA.StateName,ZA.CityName,ZA.PostalCode,ZA.PhoneNumber,ZA.Mobilenumber,ZA.AlternateMobileNumber,
		   ZA.FaxNumber,ZA.IsDefaultBilling,ZA.IsDefaultShipping,ZA.IsActive,ZA.ExternalId,ZA.IsShipping,ZA.IsBilling,ZA.EmailAddress 
	FROM ZnodeAddress ZA
	INNER JOIN ZnodeUserAddress ZUA ON ZUA.AddressId = ZA.AddressId 
	WHERE ZUA.UserId = @UserId
	Union All
	--To get the users account addresses
	SELECT ZUA.AccountAddressId,@UserId as UserId,ZA.AddressId,ZA.FirstName,ZA.LastName,ZA.DisplayName,ZA.CompanyName,ZA.Address1,ZA.Address2,ZA.Address3,
		   ZA.CountryName,ZA.StateName,ZA.CityName,ZA.PostalCode,ZA.PhoneNumber,ZA.Mobilenumber,ZA.AlternateMobileNumber,
		   ZA.FaxNumber,ZA.IsDefaultBilling,ZA.IsDefaultShipping,ZA.IsActive,ZA.ExternalId,ZA.IsShipping,ZA.IsBilling,ZA.EmailAddress 
	FROM ZnodeAddress ZA
	INNER JOIN ZnodeAccountAddress ZUA ON ZUA.AddressId = ZA.AddressId 
	WHERE ZUA.AccountId = @AcountId 
	
	--To get the users whishlists
	SELECT UserWishListId,UserId,SKU,WishListAddedDate,AddOnSKUs 
	FROM ZnodeUserWishList
	WHERE UserId = @UserId
	
	--To get the users profiles	
	SELECT ZP.ProfileId,ZP.ProfileName,ZP.ShowOnPartnerSignup,ZP.Weighting,ZP.TaxExempt,ZP.DefaultExternalAccountNo,ZP.ParentProfileId, ZUP.IsDefault
	FROM ZnodeProfile ZP
	INNER JOIN ZnodeUserProfile ZUP ON ZP.ProfileId = ZUP.ProfileId 
	WHERE ZUP.UserId = @UserId

	IF EXISTS(SELECT * FROM ZnodeUserPortal WHERE (PortalId = @PortalId OR PortalId IS NULL) AND UserId = @UserId)
		SET @UserPortalStatus = 1
	ELSE
		SET @UserPortalStatus = 0

	Select @UserPortalStatus as UserPortalStatus
END TRY 
BEGIN CATCH 

	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetUserDetailsByAspNetUserId @AspNetUserId = '+CAST(@AspNetUserId AS VARCHAR(200))+', @PortalId = '+CAST(@PortalId AS VARCHAR(200))+',@UserPortalStatus ='+CAST(@UserPortalStatus AS VARCHAR(10));
    EXEC Znode_InsertProcedureErrorLog
	@ProcedureName = 'Znode_GetUserDetailsByAspNetUserId',
	@ErrorInProcedure = @Error_procedure,
	@ErrorMessage = @ErrorMessage,
	@ErrorLine = @ErrorLine,
	@ErrorCall = @ErrorCall;

END CATCH 
END
go

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ZnodeOmsCookieMapping_UserId_PortalId' AND object_id = OBJECT_ID('ZnodeOmsCookieMapping'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_ZnodeOmsCookieMapping_UserId_PortalId
			ON [dbo].ZnodeOmsCookieMapping (UserId,PortalId)
    END
	 
go
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ZnodeOmsSavedCart_OmsCookieMappingId' AND object_id = OBJECT_ID('ZnodeOmsSavedCart'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_ZnodeOmsSavedCart_OmsCookieMappingId
			ON [dbo].[ZnodeOmsSavedCart] (OmsCookieMappingId)
    END
	go
	


go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetOmsSavedCartLineItemCount')
	drop proc Znode_GetOmsSavedCartLineItemCount
go

CREATE PROCEDURE [dbo].[Znode_GetOmsSavedCartLineItemCount]
( 
	@OmsCookieMappingId INT ,
	@UserId INT NULL ,
	@PortalId INT NULL
)
AS 
   /*  
    Summary : This procedure is used to get the count of OmsSavedCartLineItem	 	 
Unit Testing:

    EXEC [Znode_GetOmsSavedCartLineItemCount] @OmsCookieMappingId=83503
	Create Index IX_ZnodeOmsCookieMapping_UserId_PortalId on ZnodeOmsCookieMapping(UserId,PortalId)
       
*/
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		Declare @QuantityOfOthersType Numeric(28,6) ,@QuantityOfBundles Numeric(28,6) ,@OmsSavedCartId int,
				@AddonRelationshipType int , @BundleRelationshipType int 


	    IF @OmsCookieMappingId = 0
		BEGIN
				IF isnull(@UserId,0) = 0
				BEGIN
					Select CAST(@QuantityOfOthersType AS varchar(10))
					Return
				End
			   Select TOP 1 @OmsCookieMappingId =   OmsCookieMappingId from ZnodeOmsCookieMapping WITH (NOLOCK) WHERE UserId = @UserId and PortalId = @PortalId 
		END

		IF Object_id('tempdb..#BundlesProductsQuantity') <>0 
		DROP TABLE #BundlesProductsQuantity

		IF Object_id('tempdb..#ZnodeOmsSavedCartLineItem') <>0 
		DROP TABLE #ZnodeOmsSavedCartLineItem


		Select @OmsSavedCartId = OmsSavedCartId from ZnodeOmsSavedCart  WITH (NOLOCK) WHERE OmsCookieMappingId =@OmsCookieMappingId
		Select @AddonRelationshipType = OrderLineItemRelationshipTypeId	 From ZnodeOmsOrderLineItemRelationshipType WITH (NOLOCK) Where Name = 'AddOns'
		Select @BundleRelationshipType = OrderLineItemRelationshipTypeId From ZnodeOmsOrderLineItemRelationshipType WITH (NOLOCK) Where Name = 'Bundles'
		Select Quantity, OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OrderLineItemRelationshipTypeId into #ZnodeOmsSavedCartLineItem
		from ZnodeOmsSavedCartLineItem  WITH (NOLOCK) where  OmsSavedCartId = @OmsSavedCartId  

		--Read quantity of all others type of products except Bundle type
		SELECT @QuantityOfOthersType  = Sum(Quantity) FROM #ZnodeOmsSavedCartLineItem oscl WITH (NOLOCK)
        WHERE (ParentOmsSavedCartLineItemId IS NOT NULL AND OrderLineItemRelationshipTypeId not in  (@AddonRelationshipType ,@BundleRelationshipType) 
		AND OrderLineItemRelationshipTypeId IS NOT NUll)  

		--Read quantity of Bundle type from their parent Quantity only
		Select Distinct ParentOmsSavedCartLineItemId into #BundlesProductsQuantity FROM #ZnodeOmsSavedCartLineItem oscl WITH (NOLOCK) 
		where OrderLineItemRelationshipTypeId = @BundleRelationshipType
		If Exists (Select TOP 1 1 #BundlesProductsQuantity )
			SELECT @QuantityOfBundles = Sum(Quantity)   FROM #ZnodeOmsSavedCartLineItem oscl WITH (NOLOCK)
			Where Exists ( Select  TOP 1 1 From #BundlesProductsQuantity BPQ Where BPQ.ParentOmsSavedCartLineItemId = oscl.OmsSavedCartLineItemId ) 
			And (ParentOmsSavedCartLineItemId IS NULL AND OrderLineItemRelationshipTypeId IS NUll)  
		
		SET @QuantityOfOthersType = Isnull(@QuantityOfOthersType,0) + Isnull(@QuantityOfBundles,0)

		Select CAST(@QuantityOfOthersType AS varchar(10))

    END TRY
	BEGIN CATCH
		DECLARE @Status BIT ;
		SET @Status = 0;
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetOmsSavedCartLineItemCount '+ISNULL(CAST(@OmsCookieMappingId AS VARCHAR(50)),'''');
              			 
		SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
		EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'Znode_GetOmsSavedCartLineItemCount',
		@ErrorInProcedure = 'Znode_GetOmsSavedCartLineItemCount',
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
	@ErrorCall = @ErrorCall;
END CATCH;
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetBillingShippingAddress')
	drop proc Znode_GetBillingShippingAddress
go

create PROCEDURE [dbo].Znode_GetBillingShippingAddress
(
	 @BillingaddressId        INT   = 0,
    @orderShipmentId        INT   = 0
   
)
AS 
/*
	 Summary :- This Procedure is used to get the display the shipping and billing address 
	 Unit Testig 
	 EXEC  GetBillingShippingAddress 1,1
	 
*/
   BEGIN 
		BEGIN TRY 
		--SET NOCOUNT ON ;
		
			declare @addressid int =0;
			select @addressid =AddressId  from ZnodeOmsOrderShipment where OmsOrderShipmentId = @orderShipmentId
			
			
			IF OBJECT_ID('tempdb..#ZnodeAddress') IS NOT NULL DROP TABLE #ZnodeAddress
			select AddressId,
FirstName,
LastName,
DisplayName,
CompanyName,
Address1,
Address2,
Address3,
CountryName,
StateName StateCode,
CityName,
PostalCode,
PhoneNumber,
Mobilenumber,
AlternateMobileNumber,
FaxNumber,
IsDefaultBilling,
IsDefaultShipping,
IsActive,
ExternalId,
IsShipping,
IsBilling,
EmailAddress  into #ZnodeAddress  from ZnodeAddress where AddressId= @BillingaddressId or AddressId= @addressid

			select ZA.*,ZS.StateName from #ZnodeAddress ZA
				inner join ZnodeState ZS on ZS.StateCode = ZA.StateCode and ZS.CountryCode = ZA.CountryName
		
		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetBillingShippingAddress @BillingaddressId = '''+ISNULL(@BillingaddressId,'''''')+''',@orderShipmentId='+ISNULL(CAST(@orderShipmentId AS
			VARCHAR(50)),'''''')
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znode_GetBillingShippingAddress',
					@ErrorInProcedure = 'Znode_GetBillingShippingAddress',
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END
GO

go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetShippingRuleDetails')
	drop proc Znode_GetShippingRuleDetails
go

CREATE PROCEDURE [dbo].[Znode_GetShippingRuleDetails] 
(
	@ShippingRuleTypeCode NVARCHAR(500)='',
	@CountryCode VARCHAR(100)='',
	@ShippingId INT,
	@PortalId INT
)
AS 
BEGIN
BEGIN TRY
	SET NOCOUNT ON;

	SELECT ShipRule.[ShippingRuleId] AS [ShippingRuleId], Ship.[ShippingId] AS [ShippingId], ShipRule.[ClassName] AS [ClassName],
	   ShipRule.[LowerLimit] AS [LowerLimit], ShipRule.[UpperLimit] AS [UpperLimit], ShipRule.[BaseCost] AS [BaseCost],
	   ShipRule.[PerItemCost] AS [PerItemCost], ShipRule.[Custom1] AS [Custom1], ShipRule.[Custom2] AS [Custom2],
	   ShipRule.[Custom3] AS [Custom3], ShipRule.[ExternalId] AS [ExternalId], ShipRule.[ShippingRuleTypeCode] AS [ShippingRuleTypeCode]
	FROM [dbo].[ZnodeShippingRule] AS ShipRule
	INNER JOIN [dbo].[ZnodeShipping] AS Ship ON ShipRule.[ShippingId] = Ship.[ShippingId]
	INNER JOIN [dbo].[ZnodePortalShipping] AS PortalShip ON Ship.[ShippingId] = PortalShip.[ShippingId]
	LEFT OUTER JOIN [dbo].[ZnodeCountry] AS Country ON (Ship.[DestinationCountryCode] = Country.[CountryCode]) 
	WHERE (ShipRule.[ShippingRuleTypeCode] = @ShippingRuleTypeCode) AND ((Country.[CountryCode] = @CountryCode) OR ISNULL(@CountryCode,'') = '') 
	AND (PortalShip.[PortalId] = @PortalId) AND (PortalShip.[ShippingId] = @ShippingId) 
END TRY
BEGIN CATCH
	DECLARE @Status BIT ;
		SET @Status = 0;
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetShippingRuleDetails @PortalId = '+cast (@PortalId AS VARCHAR(50))+',@ShippingId='+CAST(@ShippingId AS VARCHAR(50))+',@ShippingRuleTypeCode='+@ShippingRuleTypeCode+',@CountryCode='+@CountryCode;
              			 
        SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
        EXEC Znode_InsertProcedureErrorLog
			@ProcedureName = 'Znode_GetShippingRuleDetails',
			@ErrorInProcedure = @Error_procedure,
			@ErrorMessage = @ErrorMessage,
			@ErrorLine = @ErrorLine,
			@ErrorCall = @ErrorCall;
END CATCH;
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemBundle')
	drop proc Znode_InsertUpdateSaveCartLineItemBundle
go


CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemBundle]
 (
	 @SaveCartLineItemType TT_SavecartLineitems READONLY  
	,@Userid  INT = 0
 )
AS 
BEGIN 
BEGIN TRY 
SET NOCOUNT ON 
   DECLARE @GetDate datetime= dbo.Fn_GetDate(); 
   DECLARE @OrderLineItemRelationshipTypeIdBundle int=
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Bundles'
	);
	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'AddOns'
	);
   
	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT ) 	

	DECLARE @TBL_Personalise TABLE (SKU Varchar(600),OmsSavedCartLineItemId INT, ParentOmsSavedCartLineItemId int,BundleProductIds Varchar(600) ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	INSERT INTO @TBL_Personalise
	SELECT a.SKU,Null, a.ParentOmsSavedCartLineItemId,a.BundleProductIds
			,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM @SaveCartLineItemType a 
	CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)   

	CREATE TABLE #tempoi 
	(
		GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
		,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
		,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
		,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
		,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max)
	)
	 
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
		,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
	FROM @SaveCartLineItemType a 
	GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
		,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
	 
	INSERT INTO #tempoi 
	SELECT   Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, BundleProductIds
				,Quantity, @OrderLineItemRelationshipTypeIdBundle, CustomText, CartAddOnDetails, Sequence
				,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU  
	FROM @SaveCartLineItemType  a 
	WHERE BundleProductIds <> ''
	GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, BundleProductIds
	,Quantity,  CustomText, CartAddOnDetails, Sequence ,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
			 
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
	,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
	,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
	,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
			WHEN  GroupProductIds <> '' THEN GroupProductIds 
			WHEN BundleProductIds <> '' THEN BundleProductIds 
			ELSE SKU END     ParentSKU 
	FROM @SaveCartLineItemType  a 
	WHERE AddOnValueIds <> ''
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
		,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU

    CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
	INSERT INTO #OldValue  
	SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	FROM ZnodeOmsSavedCartLineItem a   
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.BundleProductIds,'')   )   
    AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle   

	INSERT INTO #OldValue 
	SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM ZnodeOmsSavedCartLineItem b 
	INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
	AND  b.OrderLineItemRelationshipTypeID IS NULL 

	------Merge Addon for same product
	SELECT * INTO #OldValueForAddon from #OldValue

	DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
	AND a.ParentOmsSavedCartLineItemId IS NOT NULL 

	INSERT INTO #OldValue 
	SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM ZnodeOmsSavedCartLineItem b 
	INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
	AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon	

	------Merge Addon for same product
	IF EXISTS(SELECT * FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'') <> '' )
	BEGIN

		INSERT INTO #OldValueForAddon 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		SELECT distinct SKU, STUFF(
									( SELECT  ', ' + SKU FROM    
										( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											where a.ParentOmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											FOR XML PATH('')
									), 1, 2, ''
									) AddOns
		INTO #AddOnsExists
		from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

		SELECT distinct a.BundleProductIds SKU, STUFF(
										( SELECT  ', ' + x.AddOnValueIds FROM    
										( SELECT DISTINCT b.AddOnValueIds FROM @SaveCartLineItemType b
											where a.SKU=b.SKU ) x
											FOR XML PATH('')
										), 1, 2, ''
									) AddOns
		INTO #AddOnAdded
		from @SaveCartLineItemType a

		if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
		begin
			delete from #OldValue
		end

	END

	IF NOT EXISTS (SELECT TOP 1 1  FROM @SaveCartLineItemType ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
	ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
	AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
	BEGIN 
		
		DELETE FROM #OldValue 
	END 
	ELSE 
	BEGIN 
		IF EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		BEGIN 

			 DECLARE @parenTofAddon INT  = 0 
			 SET @parenTofAddon = (SELECT TOP 1 ParentOmsSavedCartLineItemId 
			 FROM #OldValue a
			 WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 
			 AND (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem  t WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
			  )

			 DELETE FROM #OldValue WHERE ParentOmsSavedCartLineItemId <> @parenTofAddon  AND ParentOmsSavedCartLineItemId IS NOT NULL  

			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
			 AND ParentOmsSavedCartLineItemId IS  NULL  
		 
			 IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
			  BEGIN 
				DELETE FROM #OldValue
			  END 
			IF (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem   WHERE ParentOmsSavedCartLineItemId =@parenTofAddon AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
			BEGIN 
				DELETE FROM #OldValue
			END 

		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a 
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		 END 
		 ELSE IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		   ELSE IF  EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		      AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  = '' )
		 BEGIN 
		   DELETE FROM #OldValue
		 END 

	END 
		 
	DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
	INSERT INTO @TBL_Personaloldvalues
	SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
	FROM ZnodeOmsPersonalizeCartItem  a 
	WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
	AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
	IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
	BEGIN 
		DELETE FROM #OldValue
	END 
	ELSE 
	BEGIN 
		 IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) <>
		     (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM ZnodeOmsSavedCartLineItem WHERE ParentOmsSavedCartLineItemId IS nULL and OmsSavedCartLineItemId in (select OmsSavedCartLineItemId from #OldValue)  )
		 BEGIN 
		   
			   DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
			   SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
			   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
			   OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
			   AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		 
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) <>
		     (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM ZnodeOmsSavedCartLineItem WHERE ParentOmsSavedCartLineItemId IS nULL and OmsSavedCartLineItemId in (select OmsSavedCartLineItemId from #OldValue)  )
		 BEGIN 
		   
			   DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
			   OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
		
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		        AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		       AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		 BEGIN 
		     DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		 END 
	END 

	----delete old value from table which having personalise data in ZnodeOmsPersonalizeCartItem but same SKU not having personalise value for new cart item
	;with cte as
	(
		select distinct b.*
		FROM @SaveCartLineItemType a 
		Inner Join #OldValue b on ( a.BundleProductIds = b.SKU or a.SKU = b.sku)
		where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') = ''
	)
	,cte2 as
	(
		select a.ParentOmsSavedCartLineItemId
		from #OldValue a
		inner join ZnodeOmsPersonalizeCartItem b on b.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId
	)
	delete a from #OldValue a
	inner join cte b on a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	inner join cte2 c on (a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or a.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId)

	----delete old value from table which having personalise data in ZnodeOmsPersonalizeCartItem but same SKU having personalise value for new cart item
	;with cte as
	(
		select distinct b.*, 
			a.PersonalizeCode
			,a.PersonalizeValue
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on ( a.BundleProductIds = b.SKU or a.SKU = b.sku)
		where isnull(a.PersonalizeValue,'') <> ''
	)
	,cte2 as
	(
		select a.ParentOmsSavedCartLineItemId, b.PersonalizeCode, b.PersonalizeValue
		from #OldValue a
		inner join ZnodeOmsPersonalizeCartItem b on b.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId
		where not exists(select * from cte c where b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and b.PersonalizeCode = c.PersonalizeCode 
			                and b.PersonalizeValue = c.PersonalizeValue )
	)
	delete a from #OldValue a
	inner join cte b on a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	inner join cte2 c on (a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or a.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId)

	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,b.ParentOmsSavedCartLineItemId , a.SKU as SKU
				,a.PersonalizeCode
			  	,a.PersonalizeValue
				,a.DesignId
				,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.SKU = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete b1
	from #OldValue b1 
	where not exists(select * from cte c where (b1.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or b1.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId))
	and exists(select * from cte)

	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.BundleProductIds as SKU
				,a.PersonalizeCode
			  	,a.PersonalizeValue
				,a.DesignId
				,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.BundleProductIds = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete c1
	from cte a1		  
	Inner Join #OldValue b1 on a1.SKU = b1.SKU
	inner join #OldValue c1 on (b1.ParentOmsSavedCartLineItemId = c1.OmsSavedCartLineItemId OR b1.OmsSavedCartLineItemId = c1.OmsSavedCartLineItemId)
	where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)

	IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
	BEGIN 

		UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5,
		a.ModifiedDate = @GetDate
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity,
		 a.ModifiedDate = @GetDate
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon

		 UPDATE Ab 
		 SET Ab.Quantity = Ab.Quantity+ty.Quantity,
		 Ab.Custom1 = ty.Custom1,
		 Ab.Custom2 = ty.Custom2,
		 Ab.Custom3 = ty.Custom3,
		 Ab.Custom4 = ty.Custom4,
		 Ab.Custom5 = ty.Custom5,
		 ab.ModifiedDate = @GetDate  
         FROM ZnodeOmsSavedCartLineItem a  
         INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
         INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  ) 
		 INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)  
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  
		 and exists(select * from #OldValue ov where a.OmsSavedCartLineItemId = ov.OmsSavedCartLineItemId)  

	END 
	ELSE 
	BEGIN 
			
		UPDATE #tempoi
		SET ParentSKU = (SELECT TOP 1 SKU FROM #tempoi WHERE OrderLineItemRelationshipTypeID IS NULL )
		WHERE OrderLineItemRelationshipTypeID  = @OrderLineItemRelationshipTypeIdAddon 
		AND EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) 
		   
		SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		   ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
		   ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
		 INTO #yuuete   
		 FROM  #tempoi  
		 GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		   ,CustomText,CartAddOnDetails ,AutoAddon  
		   ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
		 ORDER BY RowId, Id   
   
		DELETE FROM #yuuete WHERE Quantity <=0  

		;WITH Add_Dup AS
		(
			SELECT  Min(NewRowId)NewRowId ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID 
			FROM  #yuuete
			GROUP BY SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID
			HAVING OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon	
		)
		DELETE FROM #yuuete
		WHERE NOT EXISTS (SELECT TOP 1 1 FROM Add_Dup WHERE Add_Dup.NewRowId = #yuuete.NewRowId)
		AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		 ;WITH VTTY AS   
		(  
			SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
			   FROM #yuuete m  
			INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
			WHERE m.OrderLineItemRelationshipTypeID IN ( @OrderLineItemRelationshipTypeIdAddon , @OrderLineItemRelationshipTypeIdBundle)   
		)   
		UPDATE m1   
		SET m1.RowId = TYU.RowId  
		FROM #yuuete m1   
		INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
      
		;WITH VTRET AS   
		(  
			SELECT RowId,id,Min(NewRowId)NewRowId ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID   
			FROM #yuuete   
			GROUP BY RowId,id ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID  
			Having  SKU = ParentSKU  AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		)   
		DELETE FROM #yuuete WHERE NewRowId  IN (SELECT NewRowId FROM VTRET)   
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
       OUTPUT INSERTED.OmsSavedCartLineItemId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  

		SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
		INTO #Cte_newData 
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
			AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		 GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			

		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
		AND a.ParentOmsSavedCartLineItemId IS nULL  
		AND  EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) 
  
  --------------------------------------------------------------------------------------------------------

		SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
		INTO #Cte_newData1
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
			AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		 GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			

		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData1  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon   
		AND  EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) 
		AND  a.sequence in (SELECT  MIN(ab.sequence) FROM ZnodeOmsSavedCartLineItem ab where a.OmsSavedCartId = ab.OmsSavedCartId and 
		 a.SKU = ab.sku and ab.OrderLineItemRelationshipTypeId is not null  ) 

 -----------------------------------------------------------------------------------------------------

		SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
		INTO #Cte_newAddon
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = b.id OR b.Id = 1  ))  
		INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
		WHERE ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = ISNULL(a.ParentOmsSavedCartLineItemId,0) OR ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
		AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  AND c.ParentOmsSavedCartLineItemId IS NULL

	   ;with table_update AS 
	   (
		 SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
		 FROM ZnodeOmsSavedCartLineItem a
		 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		 AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
		 AND a.ParentOmsSavedCartLineItemId IS NULL  
		 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
		 AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	   )
		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 max(OmsSavedCartLineItemId) 
		  FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU  GROUP BY r.ParentSKU, r.SKU  )   
		FROM table_update a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
		WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
		  FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )    IS nOT NULL 
	 
  
		;with Cte_Th AS   
		(             
			  SELECT RowId    
			 FROM #yuuete a   
			 GROUP BY RowId   
			 HAVING COUNT(NewRowId) <= 1   
		)   
		UPDATE a SET a.Quantity =  NULL,
			a.ModifiedDate = @GetDate   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
		WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
		 AND a.OrderLineItemRelationshipTypeId IS NULL   
  
		UPDATE Ab SET ab.Quantity = a.Quantity,
			ab.ModifiedDate = @GetDate   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
		INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  )   
		WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  

		UPDATE  ZnodeOmsSavedCartLineItem   
		SET GROUPID = NULL   
		WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		AND OrderLineItemRelationshipTypeId IS NOT NULL     
       
	   ;With Cte_UpdateSequence AS   
		 (  
		   SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
		   FROM ZnodeOmsSavedCartLineItem   
		   WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		 )   
		UPDATE Cte_UpdateSequence  
		SET  Sequence = RowId  
			
		UPDATE @TBL_Personalise
		SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
		FROM @OmsInsertedData a 
		INNER JOIN ZnodeOmsSavedCartLineItem b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
		WHERE b.ParentOmsSavedCartLineItemId IS not nULL
		and b.OmsSavedCartLineItemId = (select min(OmsSavedCartLineItemId) from @OmsInsertedData d where b.OmsSavedCartLineItemId = d.OmsSavedCartLineItemId)
	 
		DELETE FROM ZnodeOmsPersonalizeCartItem	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
		MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
		USING @TBL_Personalise SOURCE
			   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
			   WHEN NOT MATCHED THEN 
				INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
								,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
				VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
								,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
	END 

END TRY
BEGIN CATCH 
  SELECT ERROR_MESSAGE()
END CATCH 
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemConfigurable')
	drop proc Znode_InsertUpdateSaveCartLineItemConfigurable
go


CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemConfigurable]
(
	@SaveCartLineItemType TT_SavecartLineitems READONLY  
	,@Userid  INT = 0 
	
)
AS 
BEGIN 
BEGIN TRY 
 SET NOCOUNT ON 
   DECLARE @GetDate datetime= dbo.Fn_GetDate(); 
   DECLARE @OrderLineItemRelationshipTypeIdConfigurable int=
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Configurable'
	);
	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'AddOns'
	);

	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT, OmsSavedCartId INT,SKU NVARCHAr(max),GroupId  NVARCHAr(max),ParentOmsSavedCartLineItemId INT,OrderLineItemRelationshipTypeId INT  ) 

	DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT, ParentOmsSavedCartLineItemId int,ConfigurableProductIds Varchar(600) ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	INSERT INTO @TBL_Personalise
	SELECT Null, a.ParentOmsSavedCartLineItemId,a.ConfigurableProductIds
			,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM @SaveCartLineItemType a 
	CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi 
	 (
		GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
		,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
		,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
		,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
		,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max)
	 )
	 
	INSERT INTO #tempoi
		SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
			,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
		FROM @SaveCartLineItemType a 
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
			,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
	 
	INSERT INTO #tempoi 
	SELECT   Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, ConfigurableProductIds
				,Quantity, @OrderLineItemRelationshipTypeIdConfigurable, CustomText, CartAddOnDetails, Sequence
				,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU  
	FROM @SaveCartLineItemType  a 
	WHERE ConfigurableProductIds <> ''
	GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, ConfigurableProductIds
	,Quantity,  CustomText, CartAddOnDetails, Sequence ,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
			 
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
	,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
	,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
	,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
			WHEN  GroupProductIds <> '' THEN GroupProductIds 
			WHEN BundleProductIds <> '' THEN BundleProductIds 
			ELSE SKU END     ParentSKU 
	FROM @SaveCartLineItemType  a 
	WHERE AddOnValueIds <> ''
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
		,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
		 
	SELECT * 
	INTO #ZnodeOmsSavedCartLineItem_NT
	FROM ZnodeOmsSavedCartLineItem a with (nolock)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId)

    CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
	INSERT INTO #OldValue  
	SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	FROM #ZnodeOmsSavedCartLineItem_NT a   
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.ConfigurableProductIds,'')   )   
    AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdConfigurable   

	INSERT INTO #OldValue 
	SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM #ZnodeOmsSavedCartLineItem_NT b 
	INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
	AND  b.OrderLineItemRelationshipTypeID IS NULL 
		
	------Merge Addon for same product
	SELECT * INTO #OldValueForAddon from #OldValue
		  
	DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
	AND a.ParentOmsSavedCartLineItemId IS NOT NULL 

	INSERT INTO #OldValue 
	SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM #ZnodeOmsSavedCartLineItem_NT b 
	INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
	AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon
		
	------Merge Addon for same product
	IF EXISTS(SELECT * FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'') <> '' )
	BEGIN
		
		
		INSERT INTO #OldValueForAddon 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM #ZnodeOmsSavedCartLineItem_NT b 
		INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		SELECT distinct SKU, STUFF(
									( SELECT  ', ' + SKU FROM    
										( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											FOR XML PATH('')
									), 1, 2, ''
									) AddOns
		INTO #AddOnsExists
		from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

		SELECT distinct a.ConfigurableProductIds SKU, STUFF(
										( SELECT  ', ' + x.AddOnValueIds FROM    
										( SELECT DISTINCT b.AddOnValueIds FROM @SaveCartLineItemType b
											where a.SKU=b.SKU ) x
											FOR XML PATH('')
										), 1, 2, ''
									) AddOns
		INTO #AddOnAdded
		from @SaveCartLineItemType a

			

		if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
		begin
			   
			delete from #OldValue

				
		end

	END

	IF NOT EXISTS (SELECT TOP 1 1  FROM @SaveCartLineItemType ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
	ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
	AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
	BEGIN 
		
		DELETE FROM #OldValue 
	END 
	ELSE 
	BEGIN 
		
		 IF EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		 BEGIN 
		 
			 DECLARE @parenTofAddon  TABLE( ParentOmsSavedCartLineItemId INT  )  
			 INSERT INTO  @parenTofAddon 
			 SELECT  ParentOmsSavedCartLineItemId FROM #OldValue a  WHERE a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
			 AND (SELECT COUNT (DISTINCT SKU ) FROM  #ZnodeOmsSavedCartLineItem_NT  t WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  

			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
					AND ParentOmsSavedCartLineItemId IS NOT NULL  
					AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
			 AND ParentOmsSavedCartLineItemId IS  NULL  
		 
			 IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
			 BEGIN 
				DELETE FROM #OldValue
			 END 
			 IF (SELECT COUNT (DISTINCT SKU ) FROM  #ZnodeOmsSavedCartLineItem_NT   WHERE ParentOmsSavedCartLineItemId IN (SELECT ParentOmsSavedCartLineItemId FROM @parenTofAddon)AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
			 BEGIN 
				DELETE FROM #OldValue
			 END 

		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM #ZnodeOmsSavedCartLineItem_NT a 
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdConfigurable  )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		    
			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		    AND ParentOmsSavedCartLineItemId IS  NULL  

		 END
		 ELSE IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END  
		 ELSE IF  EXISTS (SELECT TOP 1 1 FROM #ZnodeOmsSavedCartLineItem_NT Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdConfigurable AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		      AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  = '' )
		 BEGIN 
		   DELETE FROM #OldValue
		 END 

	END 

	DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
		
	INSERT INTO @TBL_Personaloldvalues
	SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
	FROM ZnodeOmsPersonalizeCartItem  a 
	WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
	AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
	IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
	BEGIN 
		 DELETE FROM #OldValue
	END 
	ELSE 
	BEGIN 
		 IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		    DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
		    SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		    AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
		    OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		    AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		 AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		 BEGIN 
		 
		   DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
		   OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
	
		 END 
		 ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		        AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		       AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		 BEGIN 
		     DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		 END 
	END 

	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.ConfigurableProductIds as SKU
				,a.PersonalizeCode
			  	,a.PersonalizeValue
				,a.DesignId
				,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.ConfigurableProductIds = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete c1
	from cte a1		  
	Inner Join #OldValue b1 on a1.SKU = b1.SKU
	inner join #OldValue c1 on (b1.ParentOmsSavedCartLineItemId = c1.OmsSavedCartLineItemId OR b1.OmsSavedCartLineItemId = c1.OmsSavedCartLineItemId)
	where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)
		
	IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
	BEGIN 

		UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5,
		a.ModifiedDate = @GetDate  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon
		 
		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity,
		 a.ModifiedDate = @GetDate
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
	END 
	ELSE 
	BEGIN 

		SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		   ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
		   ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
		 INTO #yuuete   
		 FROM  #tempoi  
		 GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		   ,CustomText,CartAddOnDetails ,AutoAddon  
		   ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
		 ORDER BY RowId, Id   
       	     
		DELETE FROM #yuuete WHERE Quantity <=0  
  
		 ;WITH VTTY AS   
		(  
			SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
			   FROM #yuuete m  
			INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
			WHERE m.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon   
		)   
		UPDATE m1   
		SET m1.RowId = TYU.RowId  
		FROM #yuuete m1   
		INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
           
		;WITH VTRET AS   
		(  
			SELECT RowId,id,Min(NewRowId)NewRowId ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID  
			FROM #yuuete   
			GROUP BY RowId,id ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeID  
			Having  SKU = ParentSKU  AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		)   
		DELETE FROM #yuuete WHERE NewRowId  IN (SELECT NewRowId FROM VTRET)   
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,	CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
        OUTPUT INSERTED.OmsSavedCartLineItemId,INSERTED.OmsSavedCartId,inserted.SKU,inserted.GroupId,INSERTED.ParentOmsSavedCartLineItemId,INSERTED.OrderLineItemRelationshipTypeId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  

		SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU
		INTO   #Cte_newData
		FROM @OmsInsertedData a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
			AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		 GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			  
	
		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
		AND a.ParentOmsSavedCartLineItemId IS nULL   
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )

	---------------------------------------------------------------------------------------------------------------------

		SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
		INTO #Cte_newData1 
		FROM @OmsInsertedData a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		 GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			

		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData1  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon     
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
		AND  a.sequence in (SELECT  MIN(ab.sequence) FROM ZnodeOmsSavedCartLineItem ab where a.OmsSavedCartId = ab.OmsSavedCartId and 
		 a.SKU = ab.sku and ab.OrderLineItemRelationshipTypeId is not null  ) 
 
	---------------------------------------------------------------------------------------------------------------------------

		SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId  )RowIdNo
		INTO #Cte_newAddon
		FROM ZnodeOmsSavedCartLineItem a with (nolock) 
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
		INNER JOIN ZnodeOmsSavedCartLineItem c with (nolock) on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1 
		WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
		AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) and c.ParentOmsSavedCartLineItemId is null
  
	   ;with table_update AS 
	   (
		 SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
		 FROM ZnodeOmsSavedCartLineItem a with (nolock)
		 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		 AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
		 AND a.ParentOmsSavedCartLineItemId IS NULL  
		 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
		 AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	   )
		UPDATE a SET  
		a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 max(OmsSavedCartLineItemId) 
			FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )   
		FROM table_update a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
		WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
			FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )    IS nOT NULL 

		;with Cte_Th AS   
		(             
			  SELECT RowId    
			 FROM #yuuete a   
			 GROUP BY RowId   
			 HAVING COUNT(NewRowId) <= 1   
		)   
		UPDATE a SET a.Quantity =  NULL,
			a.ModifiedDate = @GetDate   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
		WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
		 AND a.OrderLineItemRelationshipTypeId IS NULL   
  
		UPDATE  ZnodeOmsSavedCartLineItem   
		SET GROUPID = NULL   
		WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		AND OrderLineItemRelationshipTypeId IS NOT NULL     
       
	   ;With Cte_UpdateSequence AS   
		(  
		   SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
		   FROM ZnodeOmsSavedCartLineItem   
		   WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		)   
		UPDATE Cte_UpdateSequence  
		SET  Sequence = RowId  

		UPDATE @TBL_Personalise
		SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
		FROM @OmsInsertedData a 
		INNER JOIN ZnodeOmsSavedCartLineItem b with (nolock) ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId  and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
		WHERE b.ParentOmsSavedCartLineItemId IS not nULL 
	
		DELETE FROM ZnodeOmsPersonalizeCartItem WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
		MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
		USING @TBL_Personalise SOURCE
			   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
			   WHEN NOT MATCHED THEN 
				INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
								,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
				VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
								,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
	END 

END TRY
BEGIN CATCH 
  SELECT ERROR_MESSAGE()
END CATCH 
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemGroup')
	drop proc Znode_InsertUpdateSaveCartLineItemGroup
go

CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemGroup]
 (
	 @SaveCartLineItemType TT_SavecartLineitems READONLY  
	,@Userid  INT = 0 
 )
AS 
BEGIN 
BEGIN TRY 
SET NOCOUNT ON 
	DECLARE @GetDate datetime= dbo.Fn_GetDate(); 
	DECLARE @OrderLineItemRelationshipTypeIdGroup int=
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Group'
	);
	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'AddOns'
	);
   
	DECLARE @OmsInsertedData TABLE (SKU varchar(600),OmsSavedCartLineItemId INT ) 	

	DECLARE @TBL_Personalise TABLE (SKU varchar(600),OmsSavedCartLineItemId INT, ParentOmsSavedCartLineItemId int,GroupProductIds varchar(600),PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	INSERT INTO @TBL_Personalise
	SELECT  a.SKU,Null, a.ParentOmsSavedCartLineItemId,a.GroupProductIds
			,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM @SaveCartLineItemType a 
	CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	CREATE TABLE #tempoi 
	(
		GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
		,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
		,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
		,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
		,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max)
	)
	 
	INSERT INTO #tempoi
		SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
			,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
		FROM @SaveCartLineItemType a 
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
			,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
			,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
	 
	INSERT INTO #tempoi 
	SELECT   Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, GroupProductIds
				,Quantity, @OrderLineItemRelationshipTypeIdGroup, CustomText, CartAddOnDetails, Sequence
				,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU  
	FROM @SaveCartLineItemType  a 
	WHERE GroupProductIds <> ''
	GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, GroupProductIds
	,Quantity,  CustomText, CartAddOnDetails, Sequence ,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
			 
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
	,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
	,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
	,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
			WHEN  GroupProductIds <> '' THEN GroupProductIds 
			WHEN BundleProductIds <> '' THEN BundleProductIds 
			ELSE SKU END     ParentSKU 
	FROM @SaveCartLineItemType  a 
	WHERE AddOnValueIds <> ''
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
		,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
		 

	CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
	INSERT INTO #OldValue  
	SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	FROM ZnodeOmsSavedCartLineItem a with (nolock)  
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.GroupProductIds,'')   )   
	AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup   

	INSERT INTO #OldValue 
	SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM ZnodeOmsSavedCartLineItem b with (nolock)
	INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
	AND  b.OrderLineItemRelationshipTypeID IS NULL 

	------Merge Addon for same product
	SELECT * INTO #OldValueForAddon from #OldValue

	DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
	AND a.ParentOmsSavedCartLineItemId IS NOT NULL 

	INSERT INTO #OldValue 
	SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM ZnodeOmsSavedCartLineItem b with (nolock)
	INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
	AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

	------Merge Addon for same product
	IF EXISTS(SELECT * FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'') <> '' )
	BEGIN

		INSERT INTO #OldValueForAddon 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b with (nolock)
		INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		SELECT distinct SKU, STUFF(
									( SELECT  ', ' + SKU FROM    
										( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
											where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
											FOR XML PATH('')
									), 1, 2, ''
									) AddOns
		INTO #AddOnsExists
		from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

		SELECT distinct a.GroupProductIds SKU, STUFF(
										( SELECT  ', ' + x.AddOnValueIds FROM    
										( SELECT DISTINCT b.AddOnValueIds FROM @SaveCartLineItemType b
											where a.SKU=b.SKU ) x
											FOR XML PATH('')
										), 1, 2, ''
									) AddOns
		INTO #AddOnAdded
		from @SaveCartLineItemType a

		if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
		begin
			delete from #OldValue
		end

	END

	IF NOT EXISTS (SELECT TOP 1 1  FROM @SaveCartLineItemType ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
	ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
	AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
	BEGIN 
		
		DELETE FROM #OldValue 
	END 
	ELSE 
	BEGIN 
		
		 IF EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  <> '' )
		 BEGIN 
		 
			 DECLARE @parenTofAddon  TABLE( ParentOmsSavedCartLineItemId INT  )  
			 INSERT INTO  @parenTofAddon 
			 SELECT  ParentOmsSavedCartLineItemId FROM #OldValue a
			 WHERE a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
			 AND (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem  t with (nolock) WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  
			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
						AND ParentOmsSavedCartLineItemId IS NOT NULL  
						AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
			 AND ParentOmsSavedCartLineItemId IS  NULL  
		 

		  IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		 IF (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem with (nolock)  WHERE ParentOmsSavedCartLineItemId IN (SELECT ParentOmsSavedCartLineItemId FROM @parenTofAddon)AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 

		 END 
		 ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		 BEGIN 
		 -- SELECT 3
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a with (nolock)
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup  )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		    
			 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		     AND ParentOmsSavedCartLineItemId IS  NULL  

		 END
		 ELSE IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		   ELSE IF  EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		   AND EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType WHERE ISNULL(AddOnValueIds,'')  = '' )
			BEGIN 
			   DELETE FROM #OldValue
			END  
	END 

	DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
	INSERT INTO @TBL_Personaloldvalues
	SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
	FROM ZnodeOmsPersonalizeCartItem  a 
	WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
	AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)
		
	IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
	BEGIN 
		DELETE FROM #OldValue
	END 
	ELSE 
	BEGIN 
		IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		BEGIN 
		   
		DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
		SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
		OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
		AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		
		END 
		ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) <>
			(SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM ZnodeOmsSavedCartLineItem WHERE ParentOmsSavedCartLineItemId IS nULL and OmsSavedCartLineItemId in (select OmsSavedCartLineItemId from #OldValue)  )
		BEGIN 
		 
		DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
		OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
		
		END 
		ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
			AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
			AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		BEGIN 
			DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		END 
	END 
		
	----delete old value from table which having personalise data in ZnodeOmsPersonalizeCartItem but same SKU not having personalise value for new cart item
	;with cte as
	(
		select distinct b.*
		FROM @SaveCartLineItemType a 
				Inner Join #OldValue b on ( a.GroupProductIds = b.SKU or a.SKU = b.sku)
				where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') = ''
	)
	,cte2 as
	(
		select a.ParentOmsSavedCartLineItemId
		from #OldValue a
		inner join ZnodeOmsPersonalizeCartItem b on b.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId
	)
	delete a from #OldValue a
	inner join cte b on a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	inner join cte2 c on (a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or a.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId)

	----delete old value from table which having personalise data in ZnodeOmsPersonalizeCartItem but same SKU having personalise value for new cart item
	;with cte as
	(
		select distinct b.*, 
		a.PersonalizeCode
		,a.PersonalizeValue
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on ( a.GroupProductIds = b.SKU or a.SKU = b.sku)
		where isnull(a.PersonalizeValue,'') <> ''
	)
	,cte2 as
	(
		select a.ParentOmsSavedCartLineItemId, b.PersonalizeCode, b.PersonalizeValue
		from #OldValue a
		inner join ZnodeOmsPersonalizeCartItem b on b.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId
		where not exists(select * from cte c where b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and b.PersonalizeCode = c.PersonalizeCode 
			                and b.PersonalizeValue = c.PersonalizeValue )
	)
	delete a from #OldValue a
	inner join cte b on a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	inner join cte2 c on (a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or a.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId)

	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,b.ParentOmsSavedCartLineItemId , a.SKU
				,a.PersonalizeCode
			  	,a.PersonalizeValue
				,a.DesignId
				,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.SKU = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete b1
	from #OldValue b1 
	where not exists(select * from cte c where (b1.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or b1.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId))
	and exists(select * from cte)

	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.SKU as SKU
				,a.PersonalizeCode
			  	,a.PersonalizeValue
				,a.DesignId
				,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.SKU = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete c1
	from cte a1		  
	Inner Join #OldValue b1 on a1.SKU = b1.SKU
	inner join #OldValue c1 on (b1.ParentOmsSavedCartLineItemId = c1.OmsSavedCartLineItemId OR b1.OmsSavedCartLineItemId = c1.OmsSavedCartLineItemId)
	where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)
		
	IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
	BEGIN 

		 UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5,
		a.ModifiedDate = @GetDate  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity,
		 a.ModifiedDate = @GetDate
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon


	END 
	ELSE 
	BEGIN 
	   
		SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		   ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
		   ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
		 INTO #yuuete   
		 FROM  #tempoi  
		 GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		   ,CustomText,CartAddOnDetails ,AutoAddon  
		   ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
		 ORDER BY RowId, Id   
 
		DELETE FROM #yuuete WHERE Quantity <=0  
  
		 ;WITH VTTY AS   
		(  
			SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
			   FROM #yuuete m  
			INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
			WHERE m.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon   
		)   
		UPDATE m1   
		SET m1.RowId = TYU.RowId  
		FROM #yuuete m1   
		INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  

		;WITH VTRET AS   
		(  
			SELECT RowId,id,Min(NewRowId)NewRowId ,SKU ,ParentSKU, OrderLineItemRelationshipTypeId 
			FROM #yuuete   
			GROUP BY RowId,id ,SKU ,ParentSKU  ,OrderLineItemRelationshipTypeId
			HAVING SKU = ParentSKU AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		)   
		DELETE FROM #yuuete WHERE NewRowId  IN (SELECT NewRowId FROM VTRET)   
     
       INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,Sequence,CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
       OUTPUT INSERTED.SKU,INSERTED.OmsSavedCartLineItemId  INTO @OmsInsertedData 
	   SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
       ,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
       ,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
       FROM  #yuuete  TH  

		SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
		INTO  #Cte_newData
		FROM ZnodeOmsSavedCartLineItem a  with (nolock)
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
			AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		 GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID	  

		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
		AND a.ParentOmsSavedCartLineItemId IS nULL   
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
  
		-----------------------------------------------------------------------------------------------------------------------------------

		SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
		INTO #Cte_newData1
		FROM ZnodeOmsSavedCartLineItem a with (nolock)
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
			AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		 GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID	  

		 UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData1  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon   
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
		AND  a.sequence in (SELECT  MIN(ab.sequence) FROM ZnodeOmsSavedCartLineItem ab where a.OmsSavedCartId = ab.OmsSavedCartId and 
		 a.SKU = ab.sku and ab.OrderLineItemRelationshipTypeId is not null  ) 

		----------------------------------------------------------------------------------------------------------------------------

		SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
		INTO #Cte_newAddon
		FROM ZnodeOmsSavedCartLineItem a with (nolock) 
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
		INNER JOIN ZnodeOmsSavedCartLineItem c with (nolock) on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
		WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
		AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
		AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) and c.ParentOmsSavedCartLineItemId is null

	   ;with table_update AS 
	   (
			 SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
			 FROM ZnodeOmsSavedCartLineItem a with (nolock)
			 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
			 AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
			 AND a.ParentOmsSavedCartLineItemId IS NULL  
			 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
			 AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	   )
		UPDATE a SET  
			a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 max(OmsSavedCartLineItemId) 
		FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )   
		FROM table_update a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
		WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId)  FROM #Cte_newAddon  r  
			WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU AND a.RowIdNo = r.RowIdNo  GROUP BY r.ParentSKU, r.SKU  )    IS nOT NULL 

		;with Cte_Th AS   
		(             
			  SELECT RowId    
			 FROM #yuuete a   
			 GROUP BY RowId   
			 HAVING COUNT(NewRowId) <= 1   
		  )   
		UPDATE a SET a.Quantity =  NULL,
			a.ModifiedDate = @GetDate   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
		WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
		 AND a.OrderLineItemRelationshipTypeId IS NULL   
  
		UPDATE  ZnodeOmsSavedCartLineItem   
		SET GROUPID = NULL   
		WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		AND OrderLineItemRelationshipTypeId IS NOT NULL     
       
	   ;With Cte_UpdateSequence AS   
		 (  
		   SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
		   FROM ZnodeOmsSavedCartLineItem with (nolock)  
		   WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		 )   
		UPDATE Cte_UpdateSequence  
		SET  Sequence = RowId  
			
		update a set a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
		from @TBL_Personalise a
		inner join @OmsInsertedData b on a.SKU = b.SKU
	
		DELETE FROM ZnodeOmsPersonalizeCartItem	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
		MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
		USING @TBL_Personalise SOURCE
			   ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
			   WHEN NOT MATCHED THEN 
				INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
								,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
				VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
								,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
	END 

END TRY
BEGIN CATCH 
  SELECT ERROR_MESSAGE()
END CATCH 
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemQuantityWrapper')
	drop proc Znode_InsertUpdateSaveCartLineItemQuantityWrapper
go

CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemQuantityWrapper]
(
	@CartLineItemXML xml, 
	@UserId int,
	@PortalId Int,
	@OmsCookieMappingId INT = 0 
)
AS 
   /* 
    Summary: THis Procedure is USed to save and edit the saved cart line item      
    Unit Testing 
	begin tran  
    Exec Znode_InsertUpdateSaveCartLineItem @CartLineItemXML= '<ArrayOfSavedCartLineItemModel>
  <SavedCartLineItemModel>
    <OmsSavedCartLineItemId>0</OmsSavedCartLineItemId>
    <ParentOmsSavedCartLineItemId>0</ParentOmsSavedCartLineItemId>
    <OmsSavedCartId>1259</OmsSavedCartId>
    <SKU>BlueGreenYellow</SKU>
    <Quantity>1.000000</Quantity>
    <OrderLineItemRelationshipTypeId>0</OrderLineItemRelationshipTypeId>
    <Sequence>1</Sequence>
    <AddonProducts>YELLOW</AddonProducts>
    <BundleProducts />
    <ConfigurableProducts>GREEN</ConfigurableProducts>
  </SavedCartLineItemModel>
  <SavedCartLineItemModel>
    <OmsSavedCartLineItemId>0</OmsSavedCartLineItemId>
    <ParentOmsSavedCartLineItemId>0</ParentOmsSavedCartLineItemId>
    <OmsSavedCartId>1259</OmsSavedCartId>
    <SKU>ap1534</SKU>
    <Quantity>1.0</Quantity>
    <OrderLineItemRelationshipTypeId>0</OrderLineItemRelationshipTypeId>
    <Sequence>2</Sequence>
    <AddonProducts >PINK</AddonProducts>
    <BundleProducts />
    <ConfigurableProducts />
    <PersonaliseValuesList>Address~Hello</PersonaliseValuesList>
  </SavedCartLineItemModel>
</ArrayOfSavedCartLineItemModel>' , @UserId=1 ,@Status=0
	rollback tran
*/
BEGIN
BEGIN TRAN InsertUpdateSaveCartLineItem;
BEGIN TRY
SET NOCOUNT ON;
	DECLARE @GetDate datetime= dbo.Fn_GetDate();
	DECLARE @AddOnQuantity numeric(28, 6)= 0;
	DECLARE @IsAddProduct   BIT = 0 
	DECLARE @OmsSavedCartLineItemId INT = 0
	
	DECLARE @TBL_SavecartLineitems TABLE
	( 
		RowId int , OmsSavedCartLineItemId int, ParentOmsSavedCartLineItemId int, OmsSavedCartId int, SKU nvarchar(600), Quantity numeric(28, 6), OrderLineItemRelationshipTypeID int, CustomText nvarchar(max), 
		CartAddOnDetails nvarchar(max), Sequence int, AddOnValueIds varchar(max), BundleProductIds varchar(max), ConfigurableProductIds varchar(max), GroupProductIds varchar(max), PersonalisedAttribute XML, 
		AutoAddon varchar(max), OmsOrderId int, ItemDetails nvarchar(max),
		Custom1	nvarchar(max),Custom2 nvarchar(max),Custom3 nvarchar(max),Custom4
		nvarchar(max),Custom5 nvarchar(max),GroupId NVARCHAR(max) ,ProductName Nvarchar(1000) , Description NVARCHAR(max),AddOnQuantity NVARCHAR(max)
	);

	DECLARE @OrderLineItemRelationshipTypeIdAddon int =
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'AddOns'
	);
	DECLARE @OrderLineItemRelationshipTypeIdSimple int =
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Simple'
	);
	DECLARE @OrderLineItemRelationshipTypeIdGroup int=
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Group'
	);
	DECLARE @OrderLineItemRelationshipTypeIdConfigurable int=
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Configurable'
	);
	DECLARE @OrderLineItemRelationshipTypeIdBundle int=
	(
		SELECT TOP 1 OrderLineItemRelationshipTypeId
		FROM ZnodeOmsOrderLineItemRelationshipType
		WHERE [Name] = 'Bundles'
	);

	-----Getting OmsSaveCartId from @OmsCookieMappingId
	DECLARE @OmsSavedCartId int
	--Getting OmsCookieMappingId on basis of @UserId and portalid if @UserId > 0 (Not a guest User)
	IF isnull(@OmsCookieMappingId,0)=0 and isnull(@UserId,0) <> 0  
	Begin
		SET @OmsCookieMappingId = (select top 1 OmsCookieMappingId from ZnodeOmsCookieMapping with (nolock) where isnull(UserId,0) = @UserID AND isnull(PortalId,0) = @PortalId)
	END

	IF Not Exists(select top 1 OmsCookieMappingId from ZnodeOmsCookieMapping with (nolock) Where OmsCookieMappingId = @OmsCookieMappingId)
	Begin
		Insert Into ZnodeOmsCookieMapping (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select case when @UserId = 0 then null else @UserId end ,@PortalId,@UserId,@GetDate,@UserId,@GetDate

		SET @OmsCookieMappingId = @@IDENTITY
	End
	----To get the oms savecartid on basis of @OmsCookieMappingId 
	SET @OmsSavedCartId = (select top 1 OmsSavedCartId from ZnodeOmsSavedCart with (nolock) where OmsCookieMappingId = @OmsCookieMappingId)
	
	----If omssavecartid not present in ZnodeOmsSavedCart table then inserting new record to generated omssavecartid 
	IF isnull(@OmsSavedCartId,0) = 0
	Begin
		Insert Into ZnodeOmsSavedCart(OmsCookieMappingId,SalesTax,RecurringSalesTax,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select @OmsCookieMappingId,Null,Null,@UserId,@GetDate,@UserId,@GetDate

		SET @OmsSavedCartId = @@IDENTITY
	End

	INSERT INTO @TBL_SavecartLineitems( RowId,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU, Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence, AddOnValueIds, BundleProductIds, ConfigurableProductIds, GroupProductIds, PersonalisedAttribute, AutoAddon, OmsOrderId, ItemDetails,
	Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,Description,AddOnQuantity )
	SELECT DENSE_RANK()Over(Order BY Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' )) RowId ,Tbl.Col.value( 'OmsSavedCartLineItemId[1]', 'NVARCHAR(2000)' ) AS OmsSavedCartLineItemId, Tbl.Col.value( 'ParentOmsSavedCartLineItemId[1]', 'NVARCHAR(2000)' ) AS ParentOmsSavedCartLineItemId, @OmsSavedCartId AS OmsSavedCartId, Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' ) AS SKU, Tbl.Col.value( 'Quantity[1]', 'NVARCHAR(2000)' ) AS Quantity
	, Tbl.Col.value( 'OrderLineItemRelationshipTypeID[1]', 'NVARCHAR(2000)' ) AS OrderLineItemRelationshipTypeID, Tbl.Col.value( 'CustomText[1]', 'NVARCHAR(2000)' ) AS CustomText, Tbl.Col.value( 'CartAddOnDetails[1]', 'NVARCHAR(2000)' ) AS CartAddOnDetails, Tbl.Col.value( 'Sequence[1]', 'NVARCHAR(2000)' ) AS Sequence, Tbl.Col.value( 'AddonProducts[1]', 'NVARCHAR(2000)' ) AS AddOnValueIds, ISNULL(Tbl.Col.value( 'BundleProducts[1]', 'NVARCHAR(2000)' ),'') AS BundleProductIds, ISNULL(Tbl.Col.value( 'ConfigurableProducts[1]', 'NVARCHAR(2000)' ),'') AS ConfigurableProductIds, ISNULL(Tbl.Col.value( 'GroupProducts[1]', 'NVARCHAR(Max)' ),'') AS GroupProductIds, 
			Tbl.Col.query('(PersonaliseValuesDetail/node())') AS PersonaliseValuesDetail, Tbl.Col.value( 'AutoAddon[1]', 'NVARCHAR(Max)' ) AS AutoAddon, Tbl.Col.value( 'OmsOrderId[1]', 'NVARCHAR(Max)' ) AS OmsOrderId,
			Tbl.Col.value( 'ItemDetails[1]', 'NVARCHAR(Max)' ) AS ItemDetails,
			Tbl.Col.value( 'Custom1[1]', 'NVARCHAR(Max)' ) AS Custom1,
			Tbl.Col.value( 'Custom2[1]', 'NVARCHAR(Max)' ) AS Custom2,
			Tbl.Col.value( 'Custom3[1]', 'NVARCHAR(Max)' ) AS Custom3,
			Tbl.Col.value( 'Custom4[1]', 'NVARCHAR(Max)' ) AS Custom4,
			Tbl.Col.value( 'Custom5[1]', 'NVARCHAR(Max)' ) AS Custom5,
			Tbl.Col.value( 'GroupId[1]', 'NVARCHAR(Max)' ) AS GroupId,
			Tbl.Col.value( 'ProductName[1]', 'NVARCHAR(Max)' ) AS ProductName,
			Tbl.Col.value( 'Description[1]', 'NVARCHAR(Max)' ) AS Description, 
			Tbl.Col.value( 'AddOnQuantity[1]', 'NVARCHAR(2000)' ) AS AddOnQuantity
	FROM @CartLineItemXML.nodes( '//ArrayOfSavedCartLineItemModel/SavedCartLineItemModel' ) AS Tbl(Col);
			  
	IF OBJECT_ID('tempdb..#TBL_SavecartLineitems') is not null
	drop table #TBL_SavecartLineitems

	IF OBJECT_ID('tempdb..#OldValueForAddon') is not null
	drop table #OldValueForAddon

	SELECT * INTO #TBL_SavecartLineitems FROM @TBL_SavecartLineitems
			
	UPDATE ZnodeOmsSavedCart
	SET ModifiedDate = GETDATE()
	WHERE OmsSavedCartId = (SELECT TOP 1  OmsSavedCartId FROM @TBL_SavecartLineitems)

	UPDATE  @TBL_SavecartLineitems
	SET 	Description = ISNUll(Description,'') 

	IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' )
	BEGIN 				
		IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0  ) 
		BEGIN 
			SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0 )

			UPDATE ZnodeOmsSavedCartLineItem 
			SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0)
			, ModifiedDate = @GetDate
			WHERE ( OmsSavedCartLineItemId = @OmsSavedCartLineItemId  
			OR ParentOmsSavedCartLineItemId =  @OmsSavedCartLineItemId   ) 

			UPDATE ZnodeOmsSavedCartLineItem 
			SET Quantity = AddOnQuantity, ModifiedDate = @GetDate
			FROM ZnodeOmsSavedCartLineItem ZOSCLI with (nolock)
			INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = SCLI.OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
			WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
			AND SCLI.BundleProductIds <> ''

			DELETE	FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0
		END 
		DECLARE @TBL_bundleProduct TT_SavecartLineitems 
		INSERT INTO @TBL_bundleProduct 
		SELECT *  
		FROM @TBL_SavecartLineitems 
		WHERE ISNULL(BundleProductIds,'') <> '' 
				
		EXEC Znode_InsertUpdateSaveCartLineItemBundle @TBL_bundleProduct,@userId
				 
		DELETE FROM  @TBL_SavecartLineitems WHERE ISNULL(BundleProductIds,'') <> '' 
		SET @OmsSavedCartLineItemId = 0 
	END 
	IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' )
	BEGIN 				
		IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0  ) 
		BEGIN 

			SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0 )
				 
			UPDATE ZnodeOmsSavedCartLineItem 
			SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId = @OmsSavedCartLineItemId )
			, ModifiedDate = @GetDate
			WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId

			UPDATE ZnodeOmsSavedCartLineItem 
			SET Quantity = AddOnQuantity, ModifiedDate = @GetDate
			FROM ZnodeOmsSavedCartLineItem ZOSCLI with (nolock)
			INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = SCLI.OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
			WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
			AND SCLI.ConfigurableProductIds <> ''

			DELETE	FROM @TBL_SavecartLineitems WHERE ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0
		END 
		DECLARE @TBL_Configurable TT_SavecartLineitems 
		INSERT INTO @TBL_Configurable 
		SELECT *  
		FROM @TBL_SavecartLineitems 
		WHERE ISNULL(ConfigurableProductIds,'') <> '' 

				  
		EXEC Znode_InsertUpdateSaveCartLineItemConfigurable @TBL_Configurable,@userId
				  
		DELETE FROM @TBL_SavecartLineitems 
		WHERE ISNULL(ConfigurableProductIds,'') <> ''
		SET @OmsSavedCartLineItemId = 0  
	END 
	IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' )
	BEGIN 				
		IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId <> 0  ) 
		BEGIN 
			SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId <> 0 )
			UPDATE ZnodeOmsSavedCartLineItem 
			SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId = @OmsSavedCartLineItemId )
			WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId

			UPDATE ZnodeOmsSavedCartLineItem 
			SET Quantity = AddOnQuantity, ModifiedDate = @GetDate
			FROM ZnodeOmsSavedCartLineItem ZOSCLI with (nolock)
			INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = SCLI.OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
			WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
			AND SCLI.GroupProductIds <> ''

			DELETE	FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND OmsSavedCartLineItemId <> 0
		END 
		DECLARE @TBL_Group TT_SavecartLineitems 
		INSERT INTO @TBL_Group 
		SELECT *  
		FROM @TBL_SavecartLineitems 
		WHERE ISNULL(GroupProductIds,'') <> '' 

				
		EXEC Znode_InsertUpdateSaveCartLineItemGroup @TBL_Group,@userId
				  
		DELETE FROM @TBL_SavecartLineitems 
		WHERE ISNULL(GroupProductIds,'') <> ''
		SET @OmsSavedCartLineItemId = 0  
	END 
				 
	IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId <> 0  ) 
	BEGIN 
				 
		SET @OmsSavedCartLineItemId  = (SELECT TOP 1 OmsSavedCartLineItemId FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId <> 0 )
		UPDATE ZnodeOmsSavedCartLineItem 
		SET Quantity = (SELECT TOP 1 Quantity FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId = @OmsSavedCartLineItemId )
		, ModifiedDate = @GetDate
		WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId

		UPDATE ZnodeOmsSavedCartLineItem 
		SET Quantity = AddOnQuantity, ModifiedDate = @GetDate
		FROM ZnodeOmsSavedCartLineItem ZOSCLI with (nolock)
		INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
		WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					
		DELETE	FROM @TBL_SavecartLineitems WHERE OmsSavedCartLineItemId <> 0
	END 

	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT )
	DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT, ParentOmsSavedCartLineItemId int,SKU Varchar(600) ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	INSERT INTO @TBL_Personalise
	SELECT Null, a.ParentOmsSavedCartLineItemId,a.SKU
			,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM @TBL_SavecartLineitems a 
	CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 
			  
	----To update saved cart item personalise value from given line item
	DECLARE @TBL_Personalise1 TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	INSERT INTO @TBL_Personalise1
	SELECT  a.OmsSavedCartLineItemId 
			,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM (SELECT TOP 1 OmsSavedCartLineItemId,PersonalisedAttribute Valuex FROM  #TBL_SavecartLineitems TRTR ) a 
	CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
		    
			
	CREATE TABLE #tempoi 
	(
		GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
		,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
		,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
		,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
		,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max)
	)
				   
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
		,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,  GroupId ,ProductName,min(Description)Description	,0 Id,NULL ParentSKU 
	FROM @TBL_SavecartLineitems a 
	GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
		,Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
			  
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
		,Quantity, @OrderLineItemRelationshipTypeIdSimple, CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id,SKU ParentSKU 
	FROM @TBL_SavecartLineitems  a 
	WHERE ISNULL(BundleProductIds,'') =  '' 
	AND  ISNULL(GroupProductIds,'') = ''	AND ISNULL(	ConfigurableProductIds,'') = ''
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU
		,Quantity,  CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName
			  
	INSERT INTO #tempoi
	SELECT  Min(RowId )RowId ,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
		,AddOnQuantity, @OrderLineItemRelationshipTypeIdAddon, CustomText, CartAddOnDetails, Sequence
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,min(Description)Description	,1 Id 
		,CASE WHEN ConfigurableProductIds <> ''  THEN ConfigurableProductIds
		WHEN  GroupProductIds <> '' THEN GroupProductIds 
		WHEN BundleProductIds <> '' THEN BundleProductIds 
			ELSE SKU END     ParentSKU 
	FROM @TBL_SavecartLineitems  a 
	WHERE AddOnValueIds <> ''
		GROUP BY  OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, AddOnValueIds
		,AddOnQuantity,  CustomText, CartAddOnDetails, Sequence ,ConfigurableProductIds,GroupProductIds,	BundleProductIds
		,AutoAddon, OmsOrderId, ItemDetails,Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,SKU
	
	CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
	INSERT INTO #OldValue  
	SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	FROM ZnodeOmsSavedCartLineItem a with (nolock)  
	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.SKU,'')   )   
	AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple   

	INSERT INTO #OldValue 
	SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM ZnodeOmsSavedCartLineItem b with (nolock)
	INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
	AND  b.OrderLineItemRelationshipTypeID IS NULL 
		 
	DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
	AND a.ParentOmsSavedCartLineItemId IS NOT NULL 
		
	------Merge Addon for same product
	SELECT * INTO #OldValueForAddon from #OldValue
		
	INSERT INTO #OldValue 
	SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
	FROM ZnodeOmsSavedCartLineItem b with (nolock)
	INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
	WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
	AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

	------Merge Addon for same product
	IF EXISTS(SELECT * FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'') <> '' )
	BEGIN

		INSERT INTO #OldValueForAddon 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b with (nolock)
		INNER JOIN #OldValueForAddon c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId )--AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		SELECT distinct SKU, STUFF(
								( SELECT  ', ' + SKU FROM    
									( SELECT DISTINCT SKU FROM     #OldValueForAddon b 
										where a.OmsSavedCartLineItemId=b.ParentOmsSavedCartLineItemId and OrderLineItemRelationshipTypeID = 1 ) x 
										FOR XML PATH('')
								), 1, 2, ''
								) AddOns
		INTO #AddOnsExists
		from #OldValueForAddon a where a.ParentOmsSavedCartLineItemId is not null and OrderLineItemRelationshipTypeID<>1

		SELECT distinct a.SKU, STUFF(
									( SELECT  ', ' + x.AddOnValueIds FROM    
									( SELECT DISTINCT b.AddOnValueIds FROM @TBL_SavecartLineitems b
										where a.SKU=b.SKU ) x
										FOR XML PATH('')
									), 1, 2, ''
								) AddOns
		INTO #AddOnAdded
		from @TBL_SavecartLineitems a

		if not exists(select * from #AddOnsExists a inner join #AddOnAdded b on a.SKU = b.SKU and a.AddOns = b.AddOns )
		begin
			delete from #OldValue
		end

	END

	IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_SavecartLineitems ty WHERE EXISTS (SELECT TOP 1 1 FROM 	#OldValue a WHERE	
	ISNULL(TY.AddOnValueIds,'') = a.SKU AND  a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ))
	AND EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'')  <> '' )
	BEGIN 
		
		DELETE FROM #OldValue 
	END 
	ELSE 
	BEGIN 
	    
		IF EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'')  <> '' )
		BEGIN 
		 
			DECLARE @parenTofAddon  TABLE( ParentOmsSavedCartLineItemId INT  )  
			INSERT INTO  @parenTofAddon 
			SELECT  ParentOmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
				AND ParentOmsSavedCartLineItemId IS NOT NULL  
				AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
			AND ParentOmsSavedCartLineItemId IS  NULL  
		 
		END 
		ELSE IF (SELECT COUNT (OmsSavedCartLineItemId) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS NULL ) > 1 
		BEGIN 

			DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a with (nolock)
			WHERE ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple  )
			AND OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon 

			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
			OR ParentOmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM @TBL_deleteParentOmsSavedCartLineItemId)
		    
			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
			AND ParentOmsSavedCartLineItemId IS  NULL  

		END
		ELSE IF  EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem Wt WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue ty WHERE ty.OmsSavedCartId = wt.OmsSavedCartId AND ty.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple AND wt.ParentOmsSavedCartLineItemId= ty.OmsSavedCartLineItemId  ) AND wt.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon)
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'')  = '' )
		BEGIN 

			DELETE FROM #OldValue
		END 
	END 

	DECLARE @TBL_Personaloldvalues TABLE (OmsSavedCartLineItemId INT , PersonalizeCode NVARCHAr(max), PersonalizeValue NVARCHAr(max))
	INSERT INTO @TBL_Personaloldvalues
	SELECT OmsSavedCartLineItemId , PersonalizeCode, PersonalizeValue
	FROM ZnodeOmsPersonalizeCartItem  a 
	WHERE EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
	AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise TU WHERE TU.PersonalizeCode = a.PersonalizeCode AND TU.PersonalizeValue = a.PersonalizeValue)

	IF  NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
	AND EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise )
	BEGIN 
		DELETE FROM #OldValue
	END 
	ELSE 
	BEGIN 
		IF EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		BEGIN 
		   
			DELETE FROM #OldValue WHERE OmsSavedCartLineItemId IN (
			SELECT OmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
			AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ) ) 
			OR OmsSavedCartLineItemId IN ( SELECT ParentOmsSavedCartLineItemId FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues )
			AND ParentOmsSavedCartLineItemId NOT IN (SELECT OmsSavedCartLineItemId FROM @TBL_Personaloldvalues ))
		      
		END 
		ELSE IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_Personaloldvalues)
		AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) > 1 
		BEGIN 

			DELETE n FROM #OldValue n WHERE OmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem WHERE n.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId  )
			OR ParentOmsSavedCartLineItemId  IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsPersonalizeCartItem   )
	   
		END 
		ELSE IF NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		AND EXISTS (SELECT TOP 1 1 FROM ZnodeOmsPersonalizeCartItem m WHERE EXISTS (SELECT Top 1 1 FROM #OldValue YU WHERE YU.OmsSavedCartLineItemId = m.OmsSavedCartLineItemId )) 
		AND (SELECT COUNT (DISTINCT OmsSavedCartLineItemId ) FROM #OldValue WHERE ParentOmsSavedCartLineItemId IS nULL ) = 1
		BEGIN 
			DELETE FROM #OldValue WHERE NOT EXISTS (SELECT TOP 1 1  FROM @TBL_Personalise)
		END 
	  
	END 

	----delete old value from table which having personalise data in ZnodeOmsPersonalizeCartItem but same SKU not having personalise value for new cart item
	;with cte as
	(
		select distinct b.*
		FROM @TBL_SavecartLineitems a 
		Inner Join #OldValue b on ( a.SKU = b.sku)
		where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') = ''
	)
	,cte2 as
	(
		select c.ParentOmsSavedCartLineItemId
		from #OldValue a
		inner join ZnodeOmsSavedCartLineItem c on a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId
		inner join ZnodeOmsPersonalizeCartItem b on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
	)
	delete a from #OldValue a
	inner join cte b on a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	inner join cte2 c on (a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or a.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId)

	----delete old value from table which having personalise data in ZnodeOmsPersonalizeCartItem but same SKU having personalise value for new cart item
	;with cte as
	(
		select distinct b.*, 
			a.PersonalizeCode
			,a.PersonalizeValue
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on ( a.SKU = b.sku)
		where a.PersonalizeValue <> ''
	)
	,cte2 as
	(
		select a.ParentOmsSavedCartLineItemId, b.PersonalizeCode, b.PersonalizeValue
		from #OldValue a
		inner join ZnodeOmsPersonalizeCartItem b on b.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId
		where not exists(select * from cte c where b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and b.PersonalizeCode = c.PersonalizeCode 
					and b.PersonalizeValue = c.PersonalizeValue )
	)
	delete a from #OldValue a
	inner join cte b on a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
	inner join cte2 c on (a.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or a.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId)

	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,b.ParentOmsSavedCartLineItemId , a.SKU as SKU
			,a.PersonalizeCode
			,a.PersonalizeValue
			,a.DesignId
			,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.SKU = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete b1
	from #OldValue b1 
	where not exists(select * from cte c where (b1.OmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId or b1.ParentOmsSavedCartLineItemId = c.ParentOmsSavedCartLineItemId))
	and exists(select * from cte)

	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is different for same line item then New lineItem will generate
	--------If lineitem present in ZnodeOmsPersonalizeCartItem and personalize value is same for same line item then Quantity will added
	;with cte as
	(
		SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.SKU
			,a.PersonalizeCode
			,a.PersonalizeValue
			,a.DesignId
			,a.ThumbnailURL
		FROM @TBL_Personalise a 
		Inner Join #OldValue b on a.SKU = b.SKU
		Inner join ZnodeOmsPersonalizeCartItem c on b.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId
		WHERE a.OmsSavedCartLineItemId = 0
	)
	delete b1
	from cte a1		  
	Inner Join #OldValue b1 on a1.sku = b1.SKU
	where not exists(select * from ZnodeOmsPersonalizeCartItem c where a1.OmsSavedCartLineItemId = c.OmsSavedCartLineItemId and a1.PersonalizeValue = c.PersonalizeValue)

	IF EXISTS (SELECT TOP 1 1 FROM #OldValue )
	BEGIN 

		UPDATE a
		SET a.Quantity = a.Quantity+ty.Quantity,
		a.Custom1 = ty.Custom1,
		a.Custom2 = ty.Custom2,
		a.Custom3 = ty.Custom3,
		a.Custom4 = ty.Custom4,
		a.Custom5 = ty.Custom5, 
		a.ModifiedDate = @GetDate
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)

	END 
	ELSE 
	BEGIN 
	   
		SELECT RowId, Id ,Row_number()Over(Order BY RowId, Id,GenId) NewRowId , ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewId() ) Sequence ,AutoAddon  
		,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,min(Description)Description  ,ParentSKU  
		INTO #yuuete   
		FROM  #tempoi  
		GROUP BY ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		,CustomText,CartAddOnDetails ,AutoAddon  
		,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,RowId, Id ,GenId,ParentSKU   
		ORDER BY RowId, Id   
       	
			     
		DELETE FROM #yuuete WHERE Quantity <=0  
  
		;WITH VTTY AS   
		(  
		SELECT m.RowId OldRowId , TY1.RowId , TY1.SKU   
		FROM #yuuete m  
		INNER JOIN  #yuuete TY1 ON TY1.SKU = m.ParentSKU   
		WHERE m.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon   
		)   
		UPDATE m1   
		SET m1.RowId = TYU.RowId  
		FROM #yuuete m1   
		INNER JOIN VTTY TYU ON (TYU.OldRowId = m1.RowId)  
        
		;WITH VTRET AS   
		(  
		SELECT RowId,id,Min(NewRowId) NewRowId ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID  
		FROM #yuuete   
		GROUP BY RowId,id ,SKU ,ParentSKU ,OrderLineItemRelationshipTypeID
		Having  SKU = ParentSKU  AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdSimple
		)   
    
		DELETE FROM #yuuete WHERE NewRowId IN (SELECT NewRowId FROM VTRET)  

		INSERT INTO  ZnodeOmsSavedCartLineItem (ParentOmsSavedCartLineItemId ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		,CustomText,CartAddOnDetails,Sequence,CreatedBY,CreatedDate,ModifiedBy ,ModifiedDate,AutoAddon  
		,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description)  
		OUTPUT INSERTED.OmsSavedCartLineItemId  INTO @OmsInsertedData 
		SELECT NULL ,OmsSavedCartId,SKU,Quantity,OrderLineItemRelationshipTypeId  
		,CustomText,CartAddOnDetails,ROW_NUMBER()Over(Order BY NewRowId)  sequence,@UserId,@GetDate,@UserId,@GetDate,AutoAddon  
		,OmsOrderId,Custom1,Custom2,Custom3 ,Custom4 ,Custom5,GroupId,ProductName ,Description   
		FROM  #yuuete  TH  

		SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
		, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
		INTO #Cte_newData
		FROM ZnodeOmsSavedCartLineItem a with (nolock) 
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
		WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
		GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID

		UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
		WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
		WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
		AND a.ParentOmsSavedCartLineItemId IS nULL   

		SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
		INTO #Cte_newAddon
		FROM ZnodeOmsSavedCartLineItem a with (nolock) 
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
		INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1 
		WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
		AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  and c.ParentOmsSavedCartLineItemId is null


		;with table_update AS 
		(
			SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
			FROM ZnodeOmsSavedCartLineItem a with (nolock)
			WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
			AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
			AND a.ParentOmsSavedCartLineItemId IS NULL  
			AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
			AND EXISTS (SELECT TOP 1 1 FROM #Cte_newAddon TI WHERE TI.SKU = a.SKU)
		)
		UPDATE a SET  
		a.ParentOmsSavedCartLineItemId =(SELECT TOP 1 max(OmsSavedCartLineItemId) 
		FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU  GROUP BY r.ParentSKU, r.SKU  )   
		FROM table_update a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon AND  b.id =1 )   
		WHERE (SELECT TOP 1 max(OmsSavedCartLineItemId) 
		FROM #Cte_newAddon  r  
		WHERE  r.ParentSKU = b.ParentSKU AND a.SKU = r.SKU   GROUP BY r.ParentSKU, r.SKU  )    IS NOT NULL 
	 
		;with Cte_Th AS   
		(             
			SELECT RowId    
			FROM #yuuete a   
			GROUP BY RowId   
			HAVING COUNT(NewRowId) <= 1   
		)   
		UPDATE a SET a.Quantity =  NULL , a.ModifiedDate = @GetDate  
		FROM ZnodeOmsSavedCartLineItem a  
		INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
		WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
		AND a.OrderLineItemRelationshipTypeId IS NULL   
  
		UPDATE  ZnodeOmsSavedCartLineItem   
		SET GROUPID = NULL   
		WHERE  EXISTS (SELECT TOP 1 1  FROM #yuuete RT WHERE RT.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		AND OrderLineItemRelationshipTypeId IS NOT NULL     

		;With Cte_UpdateSequence AS   
		(  
			SELECT OmsSavedCartLineItemId ,Row_Number()Over(Order By OmsSavedCartLineItemId) RowId , Sequence   
			FROM ZnodeOmsSavedCartLineItem with (nolock)  
			WHERE EXISTS (SELECT TOP 1 1 FROM #yuuete TH WHERE TH.OmsSavedCartId = ZnodeOmsSavedCartLineItem.OmsSavedCartId )  
		)   
		UPDATE Cte_UpdateSequence  
		SET  Sequence = RowId  
	
		----To update saved cart item personalise value from given line item	
		if exists(select * from @TBL_Personalise1 where isnull(PersonalizeValue,'') <> '' and isnull(OmsSavedCartLineItemId,0) <> 0)
		Begin
			DELETE FROM ZnodeOmsPersonalizeCartItem 
			WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise1 yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )

			MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
			USING @TBL_Personalise1 SOURCE
			ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
			WHEN NOT MATCHED THEN 
			INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
							,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
			VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
							,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
		end		
	
		UPDATE @TBL_Personalise
		SET OmsSavedCartLineItemId = b.OmsSavedCartLineItemId
		FROM @OmsInsertedData a 
		INNER JOIN ZnodeOmsSavedCartLineItem b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId and b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon)
		WHERE b.ParentOmsSavedCartLineItemId IS NOT NULL 
	
		DELETE FROM ZnodeOmsPersonalizeCartItem 
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_Personalise yu WHERE yu.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId )
						
		MERGE INTO ZnodeOmsPersonalizeCartItem TARGET 
		USING @TBL_Personalise SOURCE
		ON (TARGET.OmsSavedCartLineItemId = SOURCE.OmsSavedCartLineItemId ) 
		WHEN NOT MATCHED THEN 
		INSERT  ( OmsSavedCartLineItemId,  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
					,PersonalizeCode, PersonalizeValue,DesignId	,ThumbnailURL )
		VALUES (  SOURCE.OmsSavedCartLineItemId,  @userId, @getdate, @userId, @getdate
					,SOURCE.PersonalizeCode, SOURCE.PersonalizeValue,SOURCE.DesignId	,SOURCE.ThumbnailURL ) ;
  
		
		 
	END 

	Declare @OutputTable Table (CartCount numeric(28,6))

	insert into @OutputTable
	EXEC [Znode_GetOmsSavedCartLineItemCount] @OmsCookieMappingId = @OmsCookieMappingId,@UserId=@UserId,@PortalId=@UserId
	

	Select CAST(1 AS bit) as Status,@OmsSavedCartId as SavedCartId,@OmsCookieMappingId as CookieMappingId,CartCount
	From @OutputTable

COMMIT TRAN InsertUpdateSaveCartLineItem;
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()	
	DECLARE @Error_procedure varchar(1000)= ERROR_PROCEDURE(), @ErrorMessage nvarchar(max)= ERROR_MESSAGE(), @ErrorLine varchar(100)= ERROR_LINE(), @ErrorCall nvarchar(max)= 'EXEC Znode_InsertUpdateSaveCartLineItem @CartLineItemXML = '+CAST(@CartLineItemXML
	AS varchar(max))+',@UserId = '+CAST(@UserId AS varchar(50))+',@PortalId='+CAST(@PortalId AS varchar(10))+',@OmsCookieMappingId='+CAST(@OmsCookieMappingId AS varchar(10));

	SELECT 0 AS ID, CAST(0 AS bit) AS Status,ERROR_MESSAGE();
	ROLLBACK TRAN InsertUpdateSaveCartLineItem;
	EXEC Znode_InsertProcedureErrorLog @ProcedureName = 'Znode_InsertUpdateSaveCartLineItem', @ErrorInProcedure = @Error_procedure, @ErrorMessage = @ErrorMessage, @ErrorLine = @ErrorLine, @ErrorCall = @ErrorCall;
END CATCH;
END;


go
	
  IF exists(select * from sys.procedures where name = 'Znode_DeletePimProducts')
	drop proc Znode_DeletePimProducts
go

CREATE PROCEDURE [dbo].[Znode_DeletePimProducts]
(
       @PimProductId VARCHAR(MAX)= '' ,
       @Status       INT OUT,
	   @PimProductIds TransferId READONLY
	 
	    
)
AS
	/* Summary :- This Procedures is used to hard delete the product details on the basis of product ids 
	 Unit Testing
	 begin tran 

	 rollback tran
	*/
    BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN DeletePimProducts;
			 DECLARE @FinalCount INT = 0 
             DECLARE @TBL_DeletdProductId TABLE ( PimProductId INT);
             INSERT INTO @TBL_DeletdProductId
                    SELECT Item
                    FROM dbo.split ( @PimProductId , ',' ) AS SP
					WHERE @PimProductId <> '' ; 
           	INSERT INTO @TBL_DeletdProductId
			SELECT ID 
			FROM @PimProductIds

			 DELETE FROM ZnodePimConfigureProductAttribute WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_DeletdProductId TDPI WHERE 
			   ZnodePimConfigureProductAttribute.PimProductId = PimProductId )

             DELETE FROM dbo.ZnodePimAttributeValueLocale
             WHERE PimAttributeValueId IN ( SELECT b.PimAttributeValueId
                                            FROM @TBL_DeletdProductId AS a INNER JOIN ZnodePimAttributeValue AS b ON a.PimProductId = b.PimProductId
                                          );

										  	 DELETE FROM dbo.ZnodePimProductAttributeDefaultValue
             WHERE PimAttributeValueId IN ( SELECT b.PimAttributeValueId
                                            FROM @TBL_DeletdProductId AS a INNER JOIN ZnodePimAttributeValue AS b ON a.PimProductId = b.PimProductId
                                          );

			 DELETE FROM dbo.ZnodePimProductAttributeTextAreaValue
             WHERE PimAttributeValueId IN ( SELECT b.PimAttributeValueId
                                            FROM @TBL_DeletdProductId AS a INNER JOIN ZnodePimAttributeValue AS b ON a.PimProductId = b.PimProductId
                                          );

			
			 DELETE FROM dbo.ZnodePimProductAttributeMedia
             WHERE PimAttributeValueId IN ( SELECT b.PimAttributeValueId
                                            FROM @TBL_DeletdProductId AS a INNER JOIN ZnodePimAttributeValue AS b ON a.PimProductId = b.PimProductId
                                          );

             DELETE FROM ZnodePimAttributeValue
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimAttributeValue.PimProductId
                          );
		   
		    DELETE FROM ZnodePimAddonGroupProduct  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.pimProductId = ZnodePimAddonGroupProduct.PimChildProductId
                          )
		    DELETE FROM ZnodePimAddOnProductDetail
            WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.pimProductId = ZnodePimAddOnProductDetail.PimChildProductId
                          )
				OR EXISTS (SELECT TOP 1 1 FROM ZnodePimAddOnProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimAddOnProduct.PimProductId
                          ) AND ZnodePimAddOnProduct.PimAddOnProductId  = ZnodePimAddOnProductDetail.PimAddOnProductId );		  
						  
				
			 DELETE FROM ZnodePimAddOnProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimAddOnProduct.PimProductId
                          );
			DELETE FROM ZnodePimCustomFieldLocale
            WHERE EXISTS ( SELECT TOP 1 1
                            FROM ZnodePimCustomField AS zm
                            WHERE zm.PimCustomFieldId = ZnodePimCustomFieldLocale.PimCustomFieldId
                                  AND
                                  EXISTS ( SELECT TOP 1 1
                                           FROM @TBL_DeletdProductId AS a
                                           WHERE a.PimProductId = Zm.PimProductId
                                         )
                          );
             DELETE FROM ZnodePimCustomField
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimCustomField.PimProductId
                          );
             DELETE FROM ZnodePimLinkProductDetail
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimLinkProductDetail.PimProductId
                                  OR
                                  a.PimProductId = ZnodePimLinkProductDetail.PimParentProductId
                          );
             DELETE FROM ZnodePimProductImage
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimProductImage.PimProductId
                          );
             DELETE FROM ZnodePimProductTypeAssociation
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimProductTypeAssociation.PimProductId
                                  OR
                                  a.pimproductId = ZnodePimProductTypeAssociation.PimParentProductId
                          );


             DELETE FROM ZnodePimCategoryProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimCategoryProduct.PimProductId
                          );

			DELETE FROM ZnodeBrandProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodeBrandProduct.PimProductId
                          );

             DELETE FROM ZnodePimProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimProduct.PimProductId
                          );
			 SET @FinalCount = 	( SELECT COUNT(1) FROM dbo.split ( @PimProductId , ',') AS a WHERE @PimProductId <> '')
			 SET @FinalCount = 	CASE WHEN @FinalCount = 0 THEN  ( SELECT COUNT(1) FROM @TBL_DeletdProductId AS a ) ELSE   @FinalCount END 

             IF ( SELECT COUNT(1) FROM @TBL_DeletdProductId ) = @FinalCount
                 BEGIN
                     SELECT 1 AS ID , CAST(1 AS BIT) AS Status;
                 END
             ELSE
                 BEGIN
                     SELECT 0 AS ID , CAST(0 AS BIT) AS Status;
                 END;
             SET @Status = 1;
             COMMIT TRAN DeletePimProducts;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE()
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeletePimProducts @PimProductId = '+@PimProductId+',@Status='+CAST(@Status AS VARCHAR(10));
              
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		     ROLLBACK TRAN DeletePimProducts;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_DeletePimProducts',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 
go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetShippingRuleDetails')
	drop proc Znode_GetShippingRuleDetails
go

CREATE PROCEDURE [dbo].[Znode_GetShippingRuleDetails] 
(
	@ShippingRuleTypeCode NVARCHAR(500)='',
	@CountryCode VARCHAR(100)='',
	@ShippingId INT,
	@PortalId INT
)
AS 
BEGIN
BEGIN TRY
	SET NOCOUNT ON;

	SELECT ShipRule.[ShippingRuleId] AS [ShippingRuleId], Ship.[ShippingId] AS [ShippingId], ShipRule.[ClassName] AS [ClassName],
	   ShipRule.[LowerLimit] AS [LowerLimit], ShipRule.[UpperLimit] AS [UpperLimit], ShipRule.[BaseCost] AS [BaseCost],
	   ShipRule.[PerItemCost] AS [PerItemCost], ShipRule.[Custom1] AS [Custom1], ShipRule.[Custom2] AS [Custom2],
	   ShipRule.[Custom3] AS [Custom3], ShipRule.[ExternalId] AS [ExternalId], ShipRule.[ShippingRuleTypeCode] AS [ShippingRuleTypeCode]
	FROM [dbo].[ZnodeShippingRule] AS ShipRule
	INNER JOIN [dbo].[ZnodeShipping] AS Ship ON ShipRule.[ShippingId] = Ship.[ShippingId]
	INNER JOIN [dbo].[ZnodePortalShipping] AS PortalShip ON Ship.[ShippingId] = PortalShip.[ShippingId]
	LEFT OUTER JOIN [dbo].[ZnodeCountry] AS Country ON (Ship.[DestinationCountryCode] = Country.[CountryCode]) 
	WHERE (ShipRule.[ShippingRuleTypeCode] = @ShippingRuleTypeCode) AND ((Country.[CountryCode] = @CountryCode) OR ISNULL(@CountryCode,'') = '') 
	AND (PortalShip.[PortalId] = @PortalId) AND (PortalShip.[ShippingId] = @ShippingId) 
END TRY
BEGIN CATCH
	DECLARE @Status BIT ;
		SET @Status = 0;
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetShippingRuleDetails @PortalId = '+cast (@PortalId AS VARCHAR(50))+',@ShippingId='+CAST(@ShippingId AS VARCHAR(50))+',@ShippingRuleTypeCode='+@ShippingRuleTypeCode+',@CountryCode='+@CountryCode;
              			 
        SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
        EXEC Znode_InsertProcedureErrorLog
			@ProcedureName = 'Znode_GetShippingRuleDetails',
			@ErrorInProcedure = @Error_procedure,
			@ErrorMessage = @ErrorMessage,
			@ErrorLine = @ErrorLine,
			@ErrorCall = @ErrorCall;
END CATCH;
END

go

update  ZnodeGlobalSetting set FeatureValues = 15000 where FeatureName = 'ProductImportBulk';
go
	
  IF exists(select * from sys.procedures where name = 'Znode_UpdateInventory')
	drop proc Znode_UpdateInventory
go
CREATE PROCEDURE [dbo].[Znode_UpdateInventory]
(
	@SkuXml xml,
	@PortalId int, 
	@UserId int, 
	@Status bit OUT, 
	@IsDebug bit= 0
)
AS 
	/*
	Summary: (13671)   Inventory will be updated on the basis of "InventoryTracking" (Attribute Code) value in locale table 
				    If value id "DisablePurchasing" then subtracts currently selected quantity only when it will greater than zero.
				    If "AllowBackordering" then inventory will become negative
				    If "DontTrackInventory" then don't update inventory.
				    inventory will be get deducted from associated warehouse where quantity is available as per warehouse precedence. 
				    Validate total quantity 
	Input Parameters:
	SKU(Comma separated multiple), PortalId
	Unit Testing   
		Declare @Status bit 
		Exec Znode_UpdateInventory  @SkuXml = '<ArrayOfOrderWarehouseLineItemsModel>
		<OrderWarehouseLineItemsModel>
		<OrderLineItemId>418</OrderLineItemId>
		<SKU>ap1534</SKU>
		<InventoryTracking>DisablePurchasing</InventoryTracking>
		<Quantity>1.000000</Quantity>
		</OrderWarehouseLineItemsModel>
		<OrderWarehouseLineItemsModel>
		<OrderLineItemId>419</OrderLineItemId>
		<SKU>al8907</SKU>
		<InventoryTracking>DisablePurchasing</InventoryTracking>
		<Quantity>1.000000</Quantity>
		</OrderWarehouseLineItemsModel>
		</ArrayOfOrderWarehouseLineItemsModel>',@PortalId = 1,@UserId = 2,@Status = @Status

	*/
BEGIN
	BEGIN TRAN UpdateInventory;
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @RoundOffValue INT= dbo.Fn_GetDefaultValue('InventoryRoundOff');
		DECLARE @TBL_XmlReturnToTable TABLE
		( 
			OrderLineItemId int, SKU nvarchar(max), InventoryTracking nvarchar(1000), Quantity numeric(28, 6),
			AllowBackOrder VARCHAR(100), SequenceNo int IDENTITY, OrderLineItemRelationshipTypeId int 
		);
		DECLARE @TBL_ErrorInventoryTracking TABLE
		( 
			SKU nvarchar(max), Quantity numeric(28, 6), InventoryTracking nvarchar(2000), AllowBackOrder varchar(100)
		);
		INSERT INTO @TBL_XmlReturnToTable( OrderLineItemId, SKU, InventoryTracking, Quantity,AllowBackOrder )
			   SELECT Tbl.Col.value( 'OrderLineItemId[1]', 'INT' ) AS OrderLineItemId, Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' ) AS SKU, Tbl.Col.value( 'InventoryTracking[1]', 'NVARCHAR(2000)' ) AS InventoryTracking, Tbl.Col.value( 'Quantity[1]', 'Numeric(28,6)' ) AS Quantity
			   , Tbl.Col.value( 'AllowBackOrder[1]', 'VARCHAR(100)' ) AS AllowBackOrder
			   FROM @SkuXml.nodes( '//ArrayOfOrderWarehouseLineItemsModel/OrderWarehouseLineItemsModel' ) AS Tbl(Col)
			   WHERE Tbl.Col.value( 'InventoryTracking[1]', 'NVARCHAR(2000)' ) <> 'DontTrackInventory' 
			   AND Tbl.Col.value( 'Quantity[1]', 'Numeric(28,6)' ) > 0
			   ;
		DECLARE @Cur_WarehouseId int, @Cur_PortalId int, @Cur_PortalWarehouseId int, @Cur_WarehouseSequence int, @Cur_SKU varchar(200), @Cur_Quantity numeric(28, 6), @Cur_ReOrderLevel numeric(28, 6), @Cur_InventoryId int;

		DECLARE @RecurringQuantity numeric(28, 6), @BalanceQuantity numeric(28, 6)
		SET @Status = 0; 
   
		Update X SET x.OrderLineItemRelationshipTypeId = b.OrderLineItemRelationshipTypeId 
		FROM ZnodeOmsOrderLineItems a
		inner join ZnodeOmsOrderLineItems b on a.OmsOrderLineItemsId = b.ParentOmsOrderLineItemsId 
		inner join @TBL_XmlReturnToTable X on x.OrderLineItemId = a.OmsOrderLineItemsId
		where a.ParentOmsOrderLineItemsId is null
		and b.ParentOmsOrderLineItemsId is not null


		DECLARE @TBL_CalculateQuntity TABLE
		( 
			WarehouseId int, SKU varchar(200), MainQuantity numeric(28, 6), InventoryId int, OrderQuantity numeric(28, 6), UpdatedQuantity numeric(28, 6), WarehouseSequenceId int, InventoryTracking nvarchar(2000)
			, AllowBackOrder varchar(100)
		);
		
		DECLARE @TBL_AllwareHouseToportal TABLE
		( 
			WarehouseId int, PortalId int, PortalWarehouseId int, WarehouseSequenceFirst int, WarehouseSequence int, SKU varchar(200), Quantity numeric(28, 6), ReOrderLevel numeric(28, 6), InventoryId int
		);
		
	
		INSERT INTO @TBL_AllwareHouseToportal( WarehouseId, PortalId, PortalWarehouseId, SKU, Quantity, ReOrderLevel, InventoryId, WarehouseSequence, WarehouseSequenceFirst )
			SELECT ZPW.WarehouseId, ZPW.PortalId, zpw.PortalWarehouseId, zi.SKU, zi.Quantity, zi.ReOrderLevel, zi.InventoryId, DENSE_RANK() OVER(ORDER BY ZPW.WarehouseId), 1
			FROM dbo.ZnodeInventory AS zi
			LEFT JOIN [ZnodePortalWarehouse] AS ZPW ON ZPW.WarehouseId = ZI.WareHouseId AND  ZPW.PortalId = @PortalId
			WHERE EXISTS ( SELECT TOP 1 1  FROM @TBL_XmlReturnToTable AS TBXRT WHERE RTRIM(LTRIM(TBXRT.SKU)) = RTRIM(LTRIM(zi.SKU))) 
			AND ZPW.WarehouseId IS NOT NULL
			ORDER BY ZPW.Precedence DESC
			
			INSERT INTO @TBL_AllwareHouseToportal( WarehouseId, PortalId, PortalWarehouseId, SKU, Quantity, ReOrderLevel, InventoryId, WarehouseSequence, WarehouseSequenceFirst )
			SELECT zpaw.WarehouseId, @PortalId, zpaw.PortalWarehouseId, zi.SKU, zi.Quantity, zi.ReOrderLevel, zi.InventoryId, DENSE_RANK() OVER (ORDER BY zpaw.WarehouseId),
			CASE WHEN EXISTS ( SELECT TOP 1 1 FROM @TBL_AllwareHouseToportal WE WHERE WE.SKU = ZI.SKU  ) THEN 2 ELSE 1 END
			FROM dbo.ZnodeInventory AS zi 
			INNER JOIN [dbo].[ZnodePortalAlternateWarehouse] AS zpaw ON zpaw.WarehouseId = ZI.WareHouseId
			WHERE EXISTS ( SELECT TOP 1 1 FROM [ZnodePortalWarehouse] AS a WHERE zpaw.PortalWarehouseId = a.PortalWarehouseId AND  a.PortalId = @PortalId) AND 
			EXISTS ( SELECT TOP 1 1 FROM @TBL_XmlReturnToTable AS TBXRT WHERE RTRIM(LTRIM(TBXRT.SKU)) = RTRIM(LTRIM(zi.SKU))) ORDER BY ZPAW.Precedence DESC;

		--Total Avaialble qunatity in all warehouse 
		IF EXISTS ( SELECT TOP 1 1 FROM @TBL_XmlReturnToTable WHERE InventoryTracking = 'DisablePurchasing')
		BEGIN
			INSERT INTO @TBL_ErrorInventoryTracking 
			SELECT TBAHL.SKU, SUM(TBAHL.Quantity), InventoryTracking,TBXML.AllowBackOrder 
			FROM @TBL_XmlReturnToTable AS TBXML
			LEFT JOIN @TBL_AllwareHouseToportal AS TBAHL ON(TBAHL.SKU = TBXML.SKU) 
			INNER JOIN ZnodeOmsOrderLineItems b on (TBXML.orderlineitemid = b.OmsOrderLineItemsId)
			WHERE InventoryTracking = 'DisablePurchasing'
			AND b.OrderLineItemRelationshipTypeId IS NOT NULL
			GROUP BY TBXML.AllowBackOrder ,TBAHL.SKU, InventoryTracking HAVING SUM(TBAHL.Quantity) < 1 ORDER BY TBAHL.SKU;
			IF EXISTS ( SELECT TOP 1 1 FROM @TBL_ErrorInventoryTracking )
			BEGIN
				SET @Status = 0;
				RAISERROR(15600, -1, -1, 'DisablePurchasing');
			END;
		END;

		---Getting data for simple , configurable and group
		INSERT INTO @TBL_CalculateQuntity
		SELECT WarehouseId, TBXML.SKU, TBAHL.Quantity, TBAHL.InventoryId, TBXML.Quantity, NULL AS UpdatedQuantity, DENSE_RANK() 
		OVER(ORDER BY WarehouseSequenceFirst,WarehouseSequence), InventoryTracking, TBXML.AllowBackOrder
		FROM @TBL_XmlReturnToTable AS TBXML	
		INNER  JOIN @TBL_AllwareHouseToportal AS TBAHL ON(TBAHL.SKU = TBXML.SKU)
		where exists(select * from ZnodeOmsOrderLineItems ZOOLI where TBXML.OrderLineItemId = ZOOLI.OmsOrderLineItemsId and ZOOLI.ParentOmsOrderLineItemsId is not null)
		AND isnull(TBXML.OrderLineItemRelationshipTypeId,0) <> (Select top 1 OrderLineItemRelationshipTypeId From ZnodeOmsOrderLineItemRelationshipType Where Name = 'Bundles')
		ORDER BY  WarehouseSequenceFirst,WarehouseSequence;

		---Getting data for bundle products
		INSERT INTO @TBL_CalculateQuntity
		SELECT WarehouseId, TBXML.SKU, TBAHL.Quantity, TBAHL.InventoryId, TBXML.Quantity, NULL AS UpdatedQuantity, DENSE_RANK() 
		OVER(ORDER BY WarehouseSequenceFirst,WarehouseSequence), InventoryTracking, TBXML.AllowBackOrder
		FROM @TBL_XmlReturnToTable AS TBXML	
		INNER  JOIN @TBL_AllwareHouseToportal AS TBAHL ON(TBAHL.SKU = TBXML.SKU)
		where exists(select * from ZnodeOmsOrderLineItems ZOOLI where TBXML.OrderLineItemId = ZOOLI.OmsOrderLineItemsId and ZOOLI.ParentOmsOrderLineItemsId is null)
		AND TBXML.OrderLineItemRelationshipTypeId = (Select top 1 OrderLineItemRelationshipTypeId From ZnodeOmsOrderLineItemRelationshipType Where Name = 'Bundles')
		ORDER BY  WarehouseSequenceFirst,WarehouseSequence;

		;with cte as
		(
			select WarehouseId,	a.SKU,	MainQuantity,	InventoryId,	WarehouseSequenceId,	a.InventoryTracking,	AllowBackOrder,sum(OrderQuantity) as OrderQuantity
			from @TBL_CalculateQuntity A
			group by WarehouseId,	a.SKU,	MainQuantity,	InventoryId,	WarehouseSequenceId,	InventoryTracking,	AllowBackOrder
		)
		update b set  b.OrderQuantity = a.OrderQuantity
		from cte a
		inner join @TBL_CalculateQuntity b on a.SKU = b.SKU and a.InventoryId = b.InventoryId and a.WarehouseId = b.WarehouseId

		
		UPDATE @TBL_CalculateQuntity 
		SET UpdatedQuantity = MainQuantity - OrderQuantity  
		WHERE WarehouseSequenceId = 1;
		 		
		DECLARE @CountToRepeate int= ( SELECT count( distinct WarehouseId) FROM @TBL_CalculateQuntity),@Initializationofloop int= 2;
       
		WHILE @Initializationofloop <= @CountToRepeate 
				AND EXISTS (SELECT TOP 1 1 FROM @TBL_CalculateQuntity AS a 
					WHERE UpdatedQuantity < 0  )
		BEGIN
		 
			UPDATE a  
			SET a.UpdatedQuantity = a.MainQuantity + b.UpdatedQuantity 
			FROM @TBL_CalculateQuntity a 
			INNER JOIN @TBL_CalculateQuntity b ON (a.Sku = b.Sku AND b.WarehouseSequenceId = (@Initializationofloop - 1)) 
			WHERE a.WarehouseSequenceId = @Initializationofloop 
			AND b.UpdatedQuantity < 0
			AND b.UpdatedQuantity IS NOT NULL 
			--AND a.WarehouseSequenceId = @Initializationofloop - 1

			UPDATE @TBL_CalculateQuntity 
			SET UpdatedQuantity  = 0 
			WHERE WarehouseSequenceId = @Initializationofloop -1 
			--AND  InventoryTracking <> 'AllowBackordering'
			AND UpdatedQuantity < 0
			AND UpdatedQuantity IS NOT NULL 
			--AND WarehouseSequenceId = @Initializationofloop - 1


			SET @Initializationofloop = @Initializationofloop + 1;
		END; 
		
		
		   IF EXISTS (SELECT TOP 1 1 FROM @TBL_CalculateQuntity WHERE ISNULL(UpdatedQuantity,0) < 0 AND @CountToRepeate >1)
		   BEGIN 
		    UPDATE a  
			SET a.UpdatedQuantity = b.UpdatedQuantity 
			FROM @TBL_CalculateQuntity a 
			INNER JOIN @TBL_CalculateQuntity b ON (a.Sku = b.Sku AND b.WarehouseSequenceId = @Initializationofloop -1 ) 
			WHERE a.WarehouseSequenceId = 1 
			AND ISNULL(b.UpdatedQuantity,0) < 0

			UPDATE @TBL_CalculateQuntity 
			SET UpdatedQuantity  = 0 
			WHERE WarehouseSequenceId = @Initializationofloop -1 
			--AND  InventoryTracking <> 'AllowBackordering'
		    AND ISNULL(UpdatedQuantity,0) < 0
		   END 
			
			
		--If "AllowBackordering" then inventory will go to be negative conside only single warehouse
		IF EXISTS(SELECT TOP 1 1 FROM @TBL_XmlReturnToTable WHERE InventoryTracking = 'AllowBackordering')
		BEGIN
			UPDATE ZI SET Quantity = Isnull(TBCQ.UpdatedQuantity,0) 
			FROM dbo.ZnodeInventory ZI 
			INNER JOIN @TBL_CalculateQuntity TBCQ ON(Zi.InventoryId = TBCQ.InventoryId)
			WHERE InventoryTracking = 'AllowBackordering' AND  UpdatedQuantity IS NOT NULL  ;
			SET @Status = 1;
		END;
		
		-- If @InventoryTracking is "DisablePurchasing" then subtracts currently selected quantity only when it will greater than zero.
		IF EXISTS ( SELECT TOP 1 1 FROM @TBL_XmlReturnToTable WHERE InventoryTracking = 'DisablePurchasing')
		BEGIN
			SET @BalanceQuantity = 1;
			UPDATE ZI 
			SET Quantity = CASE WHEN TBCQ.UpdatedQuantity < 0 THEN 0 ELSE TBCQ.UpdatedQuantity END 
			FROM dbo.ZnodeInventory ZI 
			INNER JOIN  @TBL_CalculateQuntity TBCQ ON(Zi.InventoryId = TBCQ.InventoryId) WHERE InventoryTracking = 'DisablePurchasing'
			AND TBCQ.UpdatedQuantity IS NOT NULL 
			;
		END;
		
		INSERT INTO ZnodeOmsOrderWarehouse( OmsOrderLineItemsId, WarehouseId,Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
		SELECT OrderLineItemId, WarehouseId,CASE WHEN UpdatedQuantity = 0 THEN MainQuantity ELSE MainQuantity - UpdatedQuantity END , @UserId, dbo.Fn_GetDate(), @UserId, dbo.Fn_GetDate() 
		FROM @TBL_CalculateQuntity AS TBCQ 
		INNER JOIN @TBL_XmlReturnToTable AS TBXR
			   ON(TBXR.SKU = TBCQ.SKU) WHERE UpdatedQuantity IS NOT NULL;
  
		SELECT DISTINCT SKU,
		 [dbo].[Fn_GetDefaultPriceRoundOffReturnNumeric](UpdatedQuantity) AS Quantity,
		  InventoryTracking,CAST(AllowBackOrder AS BIT) AllowBackOrder
		FROM @TBL_CalculateQuntity
		WHERE UpdatedQuantity IS NOT NULL;

		SET @Status = 1;
		COMMIT TRAN UpdateInventory;
	END TRY
	BEGIN CATCH
	
		SET @Status = 0;
		SELECT SKU, Quantity, InventoryTracking,AllowBackOrder
		FROM @TBL_ErrorInventoryTracking;
		
		ROLLBACK TRAN UpdateInventory;
	END CATCH;
END;
go

Update ZnodeApplicationSetting Set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>UserId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>UserName</name>      <headertext>Username</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Customer/CustomerEdit</islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>FullName</name>      <headertext>Full Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Customer/CustomerEdit</islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Email</name>      <headertext>Email ID</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Email Id</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PhoneNumber</name>      <headertext>Phone Number</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Phone Number</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>AccountCode</name>      <headertext>Account Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Account Code</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Accountname</name>      <headertext>Account Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Account Name</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>RoleName</name>      <headertext>Role Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>DepartmentName</name>      <headertext>Department Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>LastName</name>      <headertext>Last Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Last Name</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>IsLock</name>      <headertext>Is Lock</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Is Disable</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>13</id>      <name>CreatedDate</name>      <headertext>Created Date </headertext>      <width>60</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>14</id>      <name>CompanyName</name>      <headertext>Company Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>15</id>      <name>CityName</name>      <headertext>City</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>16</id>      <name>StateName</name>      <headertext>State</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>17</id>      <name>PostalCode</name>      <headertext>Postal Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>18</id>      <name>CountryName</name>      <headertext>Country</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>19</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Manage|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Manage|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Customer/CustomerEdit|/User/CustomerDelete</manageactionurl>      <manageparamfield>UserId|UserId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeCustomerAccount';

go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetPublishSingleCategoryJson')
	drop proc Znode_GetPublishSingleCategoryJson
go
CREATE PROCEDURE [dbo].[Znode_GetPublishSingleCategoryJson]
(   @PimCategoryId    INT, 
    @UserId           INT,
    @Status           int = 0 OUT,
	@IsDebug          BIT = 0,
	--@LocaleIds		  TransferId READONLY,
	@PimCatalogId     INT = 0, 
	@RevisionType varchar(50)= '',
	@IsAssociate      int = 0 Out 
)
AS 
/*
       Summary:Publish category with their respective products and details 
	            The result is fetched in xml form   
       Unit Testing   
	            During Catalog Publish Publish status should be updated 
				   
       Begin transaction 
       SELECT * FROM ZnodePIMAttribute 
	   SELECT * FROM ZnodePublishCatalog 
	   SELECT * FROM ZnodePublishCategory WHERE publishCAtegoryID = 167 

       EXEC [Znode_GetPublishSingleCategory] @PimCategoryId= 27 ,@UserId =2 ,@IsDebug = 1 
       Rollback Transaction 
	*/
     BEGIN
         
         BEGIN TRY
             SET NOCOUNT ON;
			 BEGIN TRAN GetPublishCategory
			 DECLARE @PublishCatalogLogId int , @PublishCataLogId int , @VersionId  int --,@PimCatalogId int 
			 
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @LocaleId INT= 0, @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @Counter INT= 1, @MaxId INT= 0, @CategoryIdCount INT;
             DECLARE @IsActive BIT= [dbo].[Fn_GetIsActiveTrue]();
             DECLARE @AttributeIds VARCHAR(MAX)= '', @PimCategoryIds VARCHAR(MAX)= '', @DeletedPublishCategoryIds VARCHAR(MAX)= '', @DeletedPublishProductIds VARCHAR(MAX);
			 DECLARE @TBL_PublishCatalogId TABLE(PublishCatalogId INT,PimCatalogId  INT , VersionId INT )
			 
			 INSERT INTO @TBL_PublishCatalogId  (PublishCatalogId,PimCatalogId,VersionId ) 
			 SELECT ZPCL.PublishCatalogId, ZPCL.PimCatalogId,ZPCL.PublishCatalogLogId
			 FROM ZnodePimCategoryHierarchy ZPCH 
			 INNER JOIN ZnodePublishCatalogLog  ZPCL  ON ZPCH.PimCatalogId = ZPCL.PimCatalogId and ZPCH.PimCategoryId = @PimCategoryId 
			 where  PublishCatalogLogId in (Select MAX (PublishCatalogLogId) from ZnodePublishCatalogLog ZPCL where 
			 ZPCH.PimCatalogId = ZPCL.PimCatalogId)
			 AND ZPCL.PimCatalogId = CASE WHEN @PimCatalogId <> 0 THEN @PimCatalogId ELSE ZPCL.PimCatalogId END

			 IF (NOT EXISTS (Select TOP 1 1 from @TBL_PublishCatalogId) 
			 OR NOT EXISTS (select TOP 1 1  from ZnodePimCategoryProduct ZPCP inner join ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId where ZPCP.PimCategoryId = @PimCategoryId  ))
			 AND NOT Exists(select * from ZnodePimCategoryHierarchy where PimCategoryId = @PimCategoryId  ) 
			 Begin
				Commit tran GetPublishCategory;
				SET @Status = 1  -- Category not associated or catalog not publish
				SET @IsAssociate   = 0 
				Return 0 ;
			 END 

             DECLARE @TBL_AttributeIds TABLE
             (PimAttributeId       INT,
              ParentPimAttributeId INT,
              AttributeTypeId      INT,
              AttributeCode        VARCHAR(600),
              IsRequired           BIT,
              IsLocalizable        BIT,
              IsFilterable         BIT,
              IsSystemDefined      BIT,
              IsConfigurable       BIT,
              IsPersonalizable     BIT,
              DisplayOrder         INT,
              HelpDescription      VARCHAR(MAX),
              IsCategory           BIT,
              IsHidden             BIT,
              CreatedDate          DATETIME,
              ModifiedDate         DATETIME,
              AttributeName        NVARCHAR(MAX),
              AttributeTypeName    VARCHAR(300)
             );
             DECLARE @TBL_AttributeDefault TABLE
             (
				  PimAttributeId            INT,
				  AttributeDefaultValueCode VARCHAR(100),
				  IsEditable                BIT,
				  AttributeDefaultValue     NVARCHAR(MAX),
				  DisplayOrder   INT
             );
             DECLARE @TBL_AttributeValue TABLE
             (
				  PimCategoryAttributeValueId INT,
				  PimCategoryId               INT,
				  CategoryValue               NVARCHAR(MAX),
				  AttributeCode               VARCHAR(300),
				  PimAttributeId              INT
             );
             DECLARE @TBL_LocaleIds TABLE
             (
				  RowId     INT IDENTITY(1, 1),
				  LocaleId  INT,
				  IsDefault BIT
             );
			 DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
			  PublishCatalogId  INT,
              CategoryXml       XML,
              LocaleId          INT,
			  VersionId		    INT
             );

             DECLARE @TBL_PimCategoryIds TABLE
             (
				  PimCategoryId       INT,
				  PimParentCategoryId INT,
				  DisplayOrder        INT,
				  ActivationDate      DATETIME,
				  ExpirationDate      DATETIME,
				  CategoryName        NVARCHAR(MAX),
				  ProfileId           VARCHAR(MAX),
				  IsActive            BIT,
				  PimCategoryHierarchyId INT,
				  ParentPimCategoryHierarchyId INT,
				  PublishCatalogId INT,
				  PimCatalogId  INT,
				  VersionId INT  ,
				  CategoryCode  NVARCHAR(MAX)          
			 );
             DECLARE @TBL_PublishPimCategoryIds TABLE
             (PublishCategoryId       INT,
              PimCategoryId           INT,
              PublishProductId        varchar(max),
              PublishParentCategoryId INT ,
			  PimCategoryHierarchyId INT ,
			  parentPimCategoryHierarchyId INT,
			  RowIndex INT
             );
             DECLARE @TBL_DeletedPublishCategoryIds TABLE
             (PublishCategoryId INT,
              PublishProductId  INT
             );
            
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
            SELECT LocaleId,IsDefault FROM ZnodeLocale MT WHERE IsActive = @IsActive

			----Getting all recursive category hirarchy
			;WITH GetCategoryHierarchy
			AS     
			(
				SELECT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
				,PublishCatalogId,PCI.PimCatalogId,VersionId
				FROM ZnodePimCategoryHierarchy AS ZPCH 
				LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
				Inner join @TBL_PublishCatalogId PCI on ZPCH.PimCatalogId = PCI.PimCatalogId 
				WHERE ZPCH.PimCategoryId = @PimCategoryId 
				union all
				SELECT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
				,PCI.PublishCatalogId,PCI.PimCatalogId,PCI.VersionId
				FROM ZnodePimCategoryHierarchy AS ZPCH 
				inner join GetCategoryHierarchy c on c.PimCategoryHierarchyId = ZPCH.ParentPimCategoryHierarchyId
				inner JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
				Inner join @TBL_PublishCatalogId PCI on ZPCH.PimCatalogId = PCI.PimCatalogId 
			)
			INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId,
			 PublishCatalogId,PimCatalogId,VersionId)
			 SELECT PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive ,PimCategoryHierarchyId,ParentPimCategoryHierarchyId,
				 PublishCatalogId,PimCatalogId,VersionId
			 FROM GetCategoryHierarchy;


			 MERGE INTO ZnodePublishCategory TARGET USING 
			 ( Select PC.PimCategoryId,
					  PC.PimCategoryHierarchyId,
					  PC.PimParentCategoryId,
					  PC.ParentPimCategoryHierarchyId,
					  PC.PublishCatalogId
					  FROM @TBL_PimCategoryIds PC ) 
			 SOURCE ON
			 (
				 TARGET.PimCategoryId = SOURCE.PimCategoryId 
				 AND TARGET.PublishCatalogId = SOURCE.PublishCatalogId 
				 AND TARGET.PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId
			 )
			 WHEN MATCHED THEN UPDATE SET TARGET.PimParentCategoryId = SOURCE.PimParentCategoryId,TARGET.CreatedBy = @UserId,TARGET.CreatedDate = @GetDate,
				TARGET.ModifiedBy = @UserId,TARGET.ModifiedDate = @GetDate,
			 PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId,ParentPimCategoryHierarchyId=SOURCE.ParentPimCategoryHierarchyId
             
			 WHEN NOT MATCHED THEN 
			 INSERT(PimCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 ,PimCategoryHierarchyId,ParentPimCategoryHierarchyId) 
			 VALUES(SOURCE.PimCategoryId,SOURCE.PublishCatalogId,@UserId,@GetDate,@UserId,@GetDate,SOURCE.PimCategoryHierarchyId
			 ,SOURCE.ParentPimCategoryHierarchyId)

				OUTPUT INSERTED.PublishCategoryId,INSERTED.PimCategoryId,INSERTED.PimCategoryHierarchyId,
			 INSERTED.parentPimCategoryHierarchyId 
			 INTO @TBL_PublishPimCategoryIds(PublishCategoryId,PimCategoryId,PimCategoryHierarchyId,parentPimCategoryHierarchyId);
			     	    
			---- here update the publish parent category id
            UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] ,ZPC.PublishParentCategoryId = TBPC.PublishCategoryId
			FROM ZnodePublishCategory ZPC
            INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			WHERE ZPC.PublishCatalogId = TBPC.PublishCatalogId 
			AND TBPC.PublishCatalogId  in (Select PublishCatalogId from @TBL_PublishCatalogId)
			AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL 
			AND EXISTS(SELECT * FROM @TBL_PimCategoryIds T WHERE ZPC.PimCategoryId = T.PimCategoryId ) ;

			--UPDATE a
			--SET  a.PublishParentCategoryId = b.PublishCategoryId
			--FROM ZnodePublishCategory a 
			--INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
			--WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
			--AND a.PublishCatalogId = b.PublishCatalogId AND b.PublishCatalogId in (Select PublishCatalogId from @TBL_PublishCatalogId)
			--AND EXISTS(SELECT * FROM @TBL_PimCategoryIds T WHERE ZPC.PimCategoryId = T.PimCategoryId ) ;

			 -- product are published here 
            --  EXEC Znode_GetPublishProducts @PublishCatalogId,0,@UserId,1,0,0;
			
		     SET @MaxId =(SELECT MAX(RowId)FROM @TBL_LocaleIds);
			 DECLARE @TransferID TRANSFERID 
			 INSERT INTO @TransferID 
			 SELECT DISTINCT  PimCategoryId	 FROM @TBL_PublishPimCategoryIds 

             SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(50)) FROM @TBL_PublishPimCategoryIds FOR XML PATH('')), 2, 4000);
			 
             WHILE @Counter <= @MaxId -- Loop on Locale id 
                 BEGIN
                     SET @LocaleId =(SELECT LocaleId FROM @TBL_LocaleIds WHERE RowId = @Counter);
                   
				     SET @AttributeIds = SUBSTRING((SELECT ','+CAST(ZPCAV.PimAttributeId AS VARCHAR(50)) FROM ZnodePimCategoryAttributeValue ZPCAV 
										 WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC WHERE TBPC.PimCategoryId = ZPCAV.PimCategoryId) GROUP BY ZPCAV.PimAttributeId FOR XML PATH('')), 2, 4000);
                
				     SET @CategoryIdCount =(SELECT COUNT(1) FROM @TBL_PimCategoryIds);

                     INSERT INTO @TBL_AttributeIds (PimAttributeId,ParentPimAttributeId,AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,
					 IsConfigurable,IsPersonalizable,DisplayOrder,HelpDescription,IsCategory,IsHidden,CreatedDate,ModifiedDate,AttributeName,AttributeTypeName)
                     EXEC [Znode_GetPimAttributesDetails] @AttributeIds,@LocaleId;

                     INSERT INTO @TBL_AttributeDefault (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)
                     EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @AttributeIds,@LocaleId;

                     INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
                     EXEC [dbo].[Znode_GetCategoryAttributeValueId] @TransferID,@AttributeIds,@LocaleId;

					 
			

                     ;WITH Cte_UpdateDefaultAttributeValue
                     AS (
					  SELECT TBAV.PimCategoryId,TBAV.PimAttributeId,SUBSTRING((SELECT ','+AttributeDefaultValue FROM @TBL_AttributeDefault TBD WHERE TBAV.PimAttributeId = TBD.PimAttributeId
						AND EXISTS(SELECT TOP 1 1 FROM Split(TBAV.CategoryValue, ',') SP WHERE SP.Item = TBD.AttributeDefaultValueCode)FOR XML PATH('')), 2, 4000) DefaultCategoryAttributeValue
						FROM @TBL_AttributeValue TBAV WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_AttributeDefault TBAD WHERE TBAD.PimAttributeId = TBAV.PimAttributeId))
					 
					 -- update the default value with locale 
                     UPDATE TBAV SET CategoryValue = CTUDFAV.DefaultCategoryAttributeValue FROM @TBL_AttributeValue TBAV 
					 INNER JOIN Cte_UpdateDefaultAttributeValue CTUDFAV ON(CTUDFAV.PimCategoryId = TBAV.PimCategoryId AND CTUDFAV.PimAttributeId = TBAV.PimAttributeId)
					 WHERE CategoryValue IS NULL ;
					 
					 -- here is update the media path  
						WITH Cte_productMedia
						AS (
							SELECT TBA.PimCategoryId,TBA.PimAttributeId,
							Isnull(
							(STUFF((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
							(SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP
							WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH(''),Type).value('.', 'varchar(max)'), 1, 1,'')) ,'no-image.png')
							CategoryValue
							FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId)
						)


					 UPDATE TBAV SET CategoryValue = CTCM.CategoryValue 
					 FROM @TBL_AttributeValue TBAV 
					 INNER JOIN Cte_productMedia CTCM ON(CTCM.PimCategoryId = TBAV.PimCategoryId
					 AND CTCM.PimAttributeId = TBAV.PimAttributeId);

                     WITH Cte_PublishProductIds
					 AS (SELECT TBPC.PublishcategoryId,SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50))
					  FROM ZnodePublishCategoryProduct ZPCP 
					  WHERE ZPCP.PublishCategoryId = TBPC.publishCategoryId
					  AND ZPCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId
                      AND ZPCP.PublishCatalogId in (Select PublishCatalogId from @TBL_PublishCatalogId)
					   FOR XML PATH('')), 2, 8000) PublishProductId ,PimCategoryHierarchyId
					  FROM @TBL_PublishPimCategoryIds TBPC)
                          
					 UPDATE TBPPC SET PublishProductId = CTPP.PublishProductId FROM @TBL_PublishPimCategoryIds TBPPC INNER JOIN Cte_PublishProductIds CTPP ON(TBPPC.PublishCategoryId = CTPP.PublishCategoryId 
					 AND TBPPC.PimCategoryHierarchyId = CTPP.PimCategoryHierarchyId);

                     WITH Cte_CategoryProfile
                     AS (
							SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,
									SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
									FROM ZnodeProfile ZPC 
									INNER JOIN ZnodePimCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
									AND ZPRCC.PimCatalogId = ZPC.PimCatalogId) 
									WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
						   FROM ZnodePimCategoryHierarchy ZPCC 
						   WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
						   WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId in (Select PimCatalogId from @TBL_PublishCatalogId)
						   AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId)
					   )                          
				      UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds 
					  FROM @TBL_PimCategoryIds TBPC 
					  LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
               
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId))


					 UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )

					 -- here update the publish category details 
                     ;WITH Cte_UpdateCategoryDetails
                     AS (
					 SELECT TBC.PimCategoryId,PublishCategoryId,CategoryName, TBPPC.PimCategoryHierarchyId,CategoryCode
					 FROM @TBL_PimCategoryIds TBC
                     INNER JOIN @TBL_PublishPimCategoryIds TBPPC ON(TBC.PimCategoryId = TBPPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPPC.PimCategoryHierarchyId)
					 )						
                     MERGE INTO ZnodePublishCategoryDetail TARGET USING Cte_UpdateCategoryDetails SOURCE ON(TARGET.PublishCategoryId = SOURCE.PublishCategoryId
					 AND TARGET.LocaleId = @LocaleId)
                     WHEN MATCHED THEN UPDATE SET PublishCategoryId = SOURCE.PublishcategoryId,PublishCategoryName = SOURCE.CategoryName,LocaleId = @LocaleId,ModifiedBy = @userId,ModifiedDate = @GetDate,CategoryCode= SOURCE.CategoryCode
                     WHEN NOT MATCHED THEN INSERT(PublishCategoryId,PublishCategoryName,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CategoryCode) VALUES
                     (SOURCE.PublishCategoryId,SOURCE.CategoryName,@LocaleId,@userId,@GetDate,@userId,@GetDate,CategoryCode);


					DECLARE @UpdateCategoryLog  TABLE (PublishCatalogLogId INT , LocaleId INT ,PublishCatalogId INT  )
					INSERT INTO @UpdateCategoryLog
					SELECT MAX(PublishCatalogLogId) PublishCatalogLogId , LocaleId , PublishCatalogId 
					FROM ZnodePublishCatalogLog a 
					WHERE a.PublishCatalogId =@PublishCatalogId
					AND  a.LocaleId = @LocaleId 
					GROUP BY 	LocaleId,PublishCatalogId  

					-----------------------------------------------------------------
					IF OBJECT_ID('tempdb..#Index') is not null
					BEGIN 
						DROP TABLE #Index
					END 
					CREATE TABLE #Index (RowIndex int ,PimCategoryId int , PimCategoryHierarchyId  int,ParentPimCategoryHierarchyId int )		
					insert into  #Index ( RowIndex ,PimCategoryId , PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
					SELECT CAST(Row_number() OVER (Partition By TBL.PimCategoryId Order by ISNULL(TBL.PimCategoryId,0) desc) AS VARCHAR(100))
					,ZPC.PimCategoryId, ZPC.PimCategoryHierarchyId, ZPC.ParentPimCategoryHierarchyId
					FROM @TBL_PublishPimCategoryIds TBL
					INNER JOIN ZnodePublishCategory ZPC ON (TBL.PimCategoryId = ZPC.PimCategoryId AND TBL.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId)
					WHERE ZPC.PublishCatalogId = @PublishCatalogId

					UPDATE TBP SET  TBP.[RowIndex]=  IDX.RowIndex 
					FROM @TBL_PublishPimCategoryIds TBP INNER JOIN #Index IDX ON (IDX.PimCategoryId = TBP.PimCategoryId AND IDX.PimCategoryHierarchyId = TBP.PimCategoryHierarchyId)  

					------------------------------------------------------------------
					If (@RevisionType like '%Preview%'  OR @RevisionType like '%Production%'  ) 
						Delete a from ZnodePublishCategoryEntity a Where 
						Exists(Select * from @TBL_PublishPimCategoryIds b where (a.ZnodeCategoryId = b.PublishCategoryId or a.ZnodeParentCategoryIds = '['+cast(b.PublishCategoryId as varchar(10))+']')) AND LocaleId = @LocaleId
						AND VersionId in (SELECT VersionId FROM ZnodePublishVersionEntity where RevisionType = 'PREVIEW')
					If (@RevisionType like '%Production%' OR @RevisionType = 'None')
						Delete a from ZnodePublishCategoryEntity a Where 
						Exists(Select * from @TBL_PublishPimCategoryIds b where (a.ZnodeCategoryId = b.PublishCategoryId or a.ZnodeParentCategoryIds = '['+cast(b.PublishCategoryId as varchar(10))+']')) AND LocaleId = @LocaleId
						AND VersionId in (SELECT VersionId FROM ZnodePublishVersionEntity where RevisionType = 'PRODUCTION')
				

					INSERT INTO ZnodePublishCategoryEntity
					(
						 VersionId,ZnodeCategoryId,
						 Name,CategoryCode,
						 ZnodeCatalogId,CatalogName,ZnodeParentCategoryIds,
						 ProductIds,LocaleId,IsActive,DisplayOrder,
						 Attributes,
						 ActivationDate,ExpirationDate,CategoryIndex
					)
					OUTPUT INSERTED.ZnodeCategoryId,INSERTED.ZnodeCatalogId, INSERTED.LocaleId  , Inserted.VersionId
					INTO  @TBL_CategoryXml (PublishCategoryId,PublishCatalogId,localeId,VersionId) 
					SELECT ISNULL(TYU.VersionId,'') VersionId,TBPC.PublishCategoryId ZnodeCategoryId,
						   ISNULL(CategoryName, '') Name,ISNULL(CategoryCode,'') CategoryCode,
						   ZPC.PublishCatalogId, ZPC.CatalogName ,
						   Isnull('[' + THR.PublishParentCategoryId + ']',NULL) TempZnodeParentCategoryIds,
						   ISNULL('[' + TBPC.PublishProductId + ']', NULL)  TempProductIds,
						   @LocaleId LocaleId,TBC.IsActive,ISNULL(DisplayOrder, '0') DisplayOrder,
						      ISNULL(
									(
										SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
										ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,
										TBAV.CategoryValue AttributeValues,TBA.AttributeTypeName 
										FROM @TBL_AttributeValue TBAV
										INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) 
										LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
										WHERE TBC.PimCategoryId = TBAV.PimCategoryId  
										FOR JSON PATH) 
									, '[]')  ,
							ActivationDate,ExpirationDate,ISNULL(TBPC.RowIndex,1) CategoryIndex
						   --,ProfileId TempProfileIds

						FROM @TBL_PublishPimCategoryIds TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId in  (Select PublishCatalogId from @TBL_PublishCatalogId))
						INNER JOIN ZnodePublishCategory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId =ZPC.PublishCatalogId  )
						LEFT JOIN @UpdateCategoryLog TY ON ( TY.PublishCatalogId IN (Select PublishCatalogId from @TBL_PublishCatalogId) AND TY.localeId = @LocaleId  )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) 
						INNER JOIN ZnodePublishVersionEntity TYU ON (TYU.ZnodeCatalogId  = ZPC.PublishCatalogId AND TYU.IsPublishSuccess =1 AND TYU.LocaleId = @LocaleId )
						where 
						(	
							(TYU.RevisionType =  Case when  (@RevisionType like '%Preview%'  OR @RevisionType like '%Production%' ) then 'Preview' End ) 
							OR 
							(TYU.RevisionType =  Case when (@RevisionType like '%Production%' OR @RevisionType = 'None') then  'Production'  end )
						)


				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;
	

			Select PublishCategoryId ,VersionId	, 0 PimCatalogId, LocaleId,PublishCatalogId, '404test' SeoUrl
			into #OutPublish from @TBL_CategoryXml 

			Alter TABLE #OutPublish ADD Id int Identity 
			SET @MaxId =(SELECT COUNT(*) FROM #OutPublish);
			 --SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(50)) FROM @TBL_PublishPimCategoryIds FOR XML PATH('')), 2, 4000);
			Declare @ExistingPublishCategoryId  nvarchar(max), @PublishCategoryId  int 
			SET @Counter =1 
            WHILE @Counter <= @MaxId -- Loop on Locale id 
            BEGIN
				SELECT @VersionId = VersionId  ,
				@PublishCategoryId = PublishCategoryId 
				from #OutPublish where ID = @Counter

		----Single category publish. Category count update for verison for specific catalog
		if Exists (select count(1) from @TBL_PublishPimCategoryIds)
	    begin
			UPDATE ZnodePublishCatalogLog 
				SET PublishCategoryId = (select count(distinct a.PimCategoryId)
				from ZnodePublishCategory a 
				inner join ZnodePublishCatalog c on a.PublishCatalogId = c.PublishCatalogId
				inner join ZnodePimCategoryProduct b on  a.PimCategoryId = b.PimCategoryId 
				inner join ZnodePimCategoryHierarchy ZPCH ON b.PimCategoryId = ZPCH.PimCategoryId and c.PimCatalogId = ZPCH.PimCatalogId
				where a.PublishCatalogId = ZnodePublishCatalogLog.PublishCatalogId)
				,ModifiedDate = @GetDate
			FROM ZnodePublishCatalogLog
			WHERE ZnodePublishCatalogLog.PublishCatalogLogId = @VersionId 
			AND exists(select * from ZnodePublishCatalog ZPC where ZnodePublishCatalogLog.PublishCatalogId = ZPC.PublishCatalogId and ZPC.PimCatalogId = @PimCatalogId )
		end

		----Single category publish. Category count update in all associated catalog 
		if isnull(@PimCatalogId,0)=0 and isnull(@PimcategoryId,0)<>0
		begin
			if object_Id('tempdb..#temp_CatalogCategory') is not null
				drop table #temp_CatalogCategory

			select max(c.PublishCatalogLogId) PublishCatalogLogId, C.PublishCatalogId
			into #temp_CatalogCategory
			from ZnodePimCategoryProduct a
			inner join ZnodePimCategoryHierarchy ZPCH ON a.PimCategoryId = ZPCH.PimCategoryId
			inner join ZnodePublishCatalog b on ZPCH.PimCatalogId = b.PimCatalogId
			inner join ZnodePublishCatalogLog c on b.PublishCatalogId = c.PublishCatalogId
			where a.PimCategoryId = @PimcategoryId
			group by C.PublishCatalogId

		   UPDATE ZPCC 
				SET PublishCategoryId = (select count(distinct a.PimCategoryId)
				from ZnodePublishCategory a 
				inner join ZnodePublishCatalog c on a.PublishCatalogId = c.PublishCatalogId
				inner join ZnodePimCategoryProduct b on  a.PimCategoryId = b.PimCategoryId 
				inner join ZnodePimCategoryHierarchy ZPCH ON b.PimCategoryId = ZPCH.PimCategoryId and c.PimCatalogId = ZPCH.PimCatalogId
				where a.PublishCatalogId = ZPCC.PublishCatalogId)
				,ModifiedDate = @GetDate
			FROM ZnodePublishCatalogLog ZPCC
			WHERE exists(select * from #temp_CatalogCategory CC where ZPCC.PublishCatalogLogId = CC.PublishCatalogLogId )
		end

				SET @Counter  = @Counter  + 1  
			END

			SET @Status = 1 

			If  @RevisionType = 'PREVIEW'
				UPDATE ZnodePimCategory	SET IsCategoryPublish = 1,PublishStateId =  DBO.Fn_GetPublishStateIdForPreview()  WHERE PimCategoryId = @PimCategoryId 
			else 
				UPDATE ZnodePimCategory	SET IsCategoryPublish = 1,PublishStateId =  DBO.Fn_GetPublishStateIdForPublish()  WHERE PimCategoryId = @PimCategoryId 


			if object_Id('tempdb..##PublishCategoryDetails') is not null
				drop table ##PublishCategoryDetails
			Select PublishCategoryId,VersionId,LocaleId,PublishCatalogId INTO ##PublishCategoryDetails  from @TBL_CategoryXml 
			SET @IsAssociate     = 1  
			Commit TRAN GetPublishCategory;

         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishSingleCategoryJson @PimCategoryId= '+CAST(@PimCategoryId AS VARCHAR(50))+',@PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0 -- Publish Falies 

             ROLLBACK TRAN GetPublishCategory;
			 	SET @IsAssociate     =   0
				 SELECT ERROR_MESSAGE();
			 EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishSingleCategoryJson',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetPublishSingleProductJson')
	drop proc Znode_GetPublishSingleProductJson
go
CREATE PROCEDURE [dbo].[Znode_GetPublishSingleProductJson]
(
	 @PublishCatalogId INT = 0 
	,@VersionId       VARCHAR(50) = 0 
	,@PimProductId    TransferId Readonly 
	,@UserId		  INT = 0 
	,@TokenId nvarchar(max)= ''	
	,@LocaleIds TransferId READONLY
	,@PublishStateId INT = 0  
	,@RevisionType varchar(50)
	,@Status bit = 0 OutPut
	
)
AS


--Declare @PimProductId TransferId 
--insert into @PimProductId  select 230147
-- EXEC Znode_GetPublishSingleProductJson  @PublishCatalogId = 0 ,@VersionId= 0 ,@PimProductId =@PimProductId, @UserId=2 ,@RevisionType ='Production'


BEGIN 
BEGIN TRY 
 SET NOCOUNT ON 

EXEC Znode_InsertUpdatePimAttributeJson 1 
EXEC Znode_InsertUpdateCustomeFieldJson 1
EXEC Znode_InsertUpdateAttributeDefaultValueJson 1 
				
Select ZPLPD.PimParentProductId, ZPLPD.PimProductId, ZPLPD.PimAttributeId, ZPAVL.AttributeValue as SKU
into #LinkProduct
FROM ZnodePimLinkProductDetail ZPLPD 
INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = ZPLPD.PimProductId)
INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
WHERE exists(select * from ZnodePimAttribute ZPA where ZPA.PimAttributeId = ZPAV.PimAttributeId and ZPA.AttributeCode = 'SKU')
and exists(select * from @PimProductId pp where ZPLPD.PimParentProductId = pp.Id)

select * into #PimProductId from @PimProductId

create index Idx_#PimProductId_Id on #PimProductId(Id)
 IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
	DROP TABLE #Cte_BrandData
 END 
 

 IF OBJECT_ID('tempdb..#ProductIds') is not null
 BEGIN 
	DROP TABLE #ProductIds
 END 

			Create Table #ProductIds (PimProductId int, PublishProductId  int )
			
			--DECLARE @PimProductAttributeJson TABLE(PimAttributeJsonId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
			CREATE TABLE #PimProductAttributeJson (PimAttributeJsonId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
			DECLARE @PimDefaultValueLocale  TABLE (PimAttributeDefaultJsonId INT  PRIMARY KEY ,PimAttributeDefaultValueId INT ,LocaleId INT ) 
			DECLARE @ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
			,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
			DECLARE @GetDate DATETIME =dbo.Fn_GetDate()
			DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )

			DECLARE @DomainUrl varchar(max) = (select TOp 1 URL FROM ZnodeMediaConfiguration WHERE IsActive =1)

			INSERT INTO @TBL_LocaleId (LocaleId)
			SELECT  LocaleId
			FROM ZnodeLocale MT
			WHERE IsActive = 1
			AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
			OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) 
	
			-----to update link products newly addded and deleted from PIM
			delete ZPAP
			from ZnodePublishAssociatedProduct ZPAP
			where ZPAP.IsLink = 1
			AND not exists(select * from ZnodePimLinkProductDetail ZPPD where ZPAP.ParentPimProductId = ZPPD.PimParentProductId AND ZPAP.PimProductId = ZPPD.PimProductId)
			and exists(select * from #PimProductId PP where PP.Id = ZPAP.ParentPimProductId )

			UPDATE ZPACP SET ZPACP.DisplayOrder = ZPLPD.DisplayOrder
			from ZnodePimLinkProductDetail ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			INNER JOIN ZnodePublishAssociatedProduct ZPACP ON ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId 
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			AND ZPACP.IsLink = 1

			insert into ZnodePublishAssociatedProduct(PimCatalogId,ParentPimProductId,PimProductId,PublishStateId,IsConfigurable,IsBundle,IsGroup,IsAddOn,IsLink,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			select distinct ZPCH.PimCatalogId, ZPLPD.PimParentProductId, ZPLPD.PimProductId, @PublishStateId, 0, 0, 0, 0, 1, ZPLPD.DisplayOrder, @UserId,@GetDate ,@UserId , @GetDate
			from ZnodePimLinkProductDetail ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			and not exists(select * from ZnodePublishAssociatedProduct ZPACP where ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId  )
		
			-----to update config products newly addded and deleted from PIM
			delete ZPAP
			from ZnodePublishAssociatedProduct ZPAP
			where ZPAP.IsConfigurable = 1
			AND exists(select * from ZnodePimProductTypeAssociation ZPPD where ZPAP.ParentPimProductId = ZPPD.PimParentProductId )
			and exists(select * from #PimProductId PP where PP.Id = ZPAP.ParentPimProductId )

			Update ZPACP SET ZPACP.DisplayOrder = ZPLPD.DisplayOrder
			from ZnodePimProductTypeAssociation ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			INNER JOIN ZnodePublishAssociatedProduct ZPACP ON ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			AND ZPACP.IsConfigurable = 1

			insert into ZnodePublishAssociatedProduct(PimCatalogId,ParentPimProductId,PimProductId,PublishStateId,IsConfigurable,IsBundle,IsGroup,IsAddOn,IsLink,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, IsDefault)
			select distinct ZPCH.PimCatalogId, ZPLPD.PimParentProductId, ZPLPD.PimProductId, @PublishStateId, 1, 0, 0, 0, 0, ZPLPD.DisplayOrder, @UserId,@GetDate ,@UserId , @GetDate, ZPLPD.IsDefault
			from ZnodePimProductTypeAssociation ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			and not exists(select * from ZnodePublishAssociatedProduct ZPACP where ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId  )
			--group by ZPCH.PimCatalogId, ZPLPD.PimParentProductId, ZPLPD.PimProductId, ZPLPD.DisplayOrder, ZPLPD.IsDefault
			-------

			DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 

			CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT   , VersionId INT ,LocaleId INT, PriceListId INT , PortalId INT ,MaxSmallWidth NVARCHAr(max)  )
			CREATE INDEX idx_#TBL_PublishCatalogIdPimProductId on #TBL_PublishCatalogId(PimProductId)
			CREATE INDEX idx_#TBL_PublishCatalogIdPimPublishCatalogId on #TBL_PublishCatalogId(PublishCatalogId)

			INSERT INTO #TBL_PublishCatalogId 
			SELECT Distinct ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId, 0,0 ,
			(SELECT TOP 1 PriceListId FROM ZnodePriceListPortal NT 
			INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=NT.PortalId  
			ORDER BY NT.Precedence ASC ) ,TY.PortalId,
			(SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodeGlobalMediaDisplaySetting)
			FROM ZnodePublishProduct ZPP 
			LEFT JOIN ZnodePortalCatalog TY ON (TY.PublishCatalogId = ZPP.PublishCatalogId)
			WHERE (EXISTS (SELECT TOP 1 1 FROM #PimProductId SP WHERE SP.Id = ZPP.PimProductId  
			AND  (@PublishCatalogId IS NULL OR @PublishCatalogId = 0 ))
			OR  (ZPP.PublishCatalogId = @PublishCatalogId ))
			And Exists 
			(Select TOP 1 1 from ZnodePublishVersionEntity ZPCP  where ZPCP.ZnodeCatalogId  = ZPP.PublishCatalogId AND ZPCP.IsPublishSuccess =1 )

			Insert into #ProductIds (PimProductId,PublishProductId) Select distinct PimProductId,PublishProductId from #TBL_PublishCatalogId  

             Create TABLE #TBL_ZnodeTempPublish (PimProductId INT , AttributeCode VARCHAR(300) ,AttributeValue NVARCHAR(max) ) 			
			 DECLARE @TBL_AttributeVAlueLocale TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT,LocaleId INT ,AttributeValue Nvarchar(1000) )


			 INSERT INTO @TBL_AttributeValueLocale (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId ,LocaleId ,AttributeValue )
			 SELECT VIR.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId,VIR.LocaleId, ''
			 FROM View_LoadManageProductInternal VIR
			 INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = VIR.PimProductId)
			 UNION ALL 
			 SELECT VIR.PimProductId,PimAttributeId,PimProductAttributeMediaId,ZPDE.LocaleId , ''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimProductAttributeMedia ZPDE ON (ZPDE.PimAttributeValueId = VIR.PimAttributeValueId )
			 WHERE EXISTS (SELECT TOP 1 1 FROM #ProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,ZPDVL.PimAttributeDefaultValueLocaleId,ZPDVL.LocaleId ,ZPDVL.AttributeDefaultValue
			   FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON ZPADV.PimAttributeId = D.PimAttributeId
			 INNER JOIN ZnodePimAttributeDefaultValueLocale ZPDVL   on (ZPADV.PimAttributeDefaultValueId = ZPDVL.PimAttributeDefaultValueId)
			 WHERE ( ZPDVL.LocaleId = @DefaultLocaleId OR ZPDVL.LocaleId = @LocaleId )
			 AND EXISTS(SELECT TOP 1 1 FROM #ProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,'','' ,''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 WHERE  EXISTS(SELECT TOP 1 1 FROM #ProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
		
				--insert INTO #ZnodePrice
				SELECT RetailPrice,SalesPrice,ZC.CurrencyCode,ZCC.CultureCode ,ZCC.Symbol CurrencySuffix,TYU.PublishProductId ,isnull(ZPC1.IsAllowIndexing,0) as IsAllowIndexing
				into #ZnodePrice
				FROM ZnodePrice ZP 
				INNER JOIN ZnodePriceList ZPL ON (ZPL.PriceListId = ZP.PriceListId)
				INNER JOIN ZnodeCurrency ZC oN (ZC.CurrencyId = ZPL.CurrencyId )
				INNER JOIN ZnodeCulture ZCC ON (ZCC.CultureId = ZPL.CultureId)
				INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZP.SKU ) 
				INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId)
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TYUR WHERE TYUR.PriceListId = ZPL.PriceListId AND TYUR.PublishCatalogId = TYU.PublishCatalogId
				AND TYU.PublishProductId = TYUR.PublishProductId)
				AND TY.LocaleId = dbo.Fn_GetDefaultLocaleId()
				AND EXISTS (SELECT TOP 1 1 FROM ZnodePriceListPortal ZPLP 
				INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=ZPLP.PortalId WHERE ZPLP.PriceListId=ZP.PriceListId )
				
				--insert INTO #ProductSKU
				SELECT ZCSD.SEOUrl , ZCDL.SEODescription,ZCDL.SEOKeywords ,ZCDL.SEOTitle, TYU.PublishProductId ,isnull(ZPC1.IsAllowIndexing,0) as IsAllowIndexing
				INTO #ProductSKU
				FROM ZnodeCMSSEODetail ZCSD 
				INNER JOIN ZnodeCMSSEODetailLocale ZCDL ON (ZCDL.CMSSEODetailId = ZCSD.CMSSEODetailId)
				INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZCSD.SEOCode AND ZCDL.LocaleId = TY.LocaleId) 
				INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId)
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE CMSSEOTypeId = (SELECT TOP 1 CMSSEOTypeId FROM ZnodeCMSSEOType WHERE Name = 'Product') 
				AND EXISTS (SELECT TOP 1 1  FROM #TBL_PublishCatalogId TYUR WHERE  TYUR.PublishCatalogId = TYU.PublishCatalogId
				AND TYU.PublishProductId = TYUR.PublishProductId)
				AND ZCDL.LocaleId = dbo.Fn_GetDefaultLocaleId()
				and ZCSD.PortalId = isnull(ZPC1.PortalId,0)

			
				--insert INTO #ProductImages
				SELECT  TUI.PublishCatalogId, TYU.PublishProductId , @DomainUrl +'Catalog/'  + CAST(Max(ZPC1.PortalId) AS VARCHAr(100)) + '/'+ CAST(Isnull(Max(TUI.MaxSmallWidth),'') AS VARCHAR(100)) + '/' + Isnull(RT.MediaPath,'') AS ImageSmallPath    
				,isnull(ZPC1.IsAllowIndexing,0) as IsAllowIndexing
				INTO #ProductImages
				FROM ZnodePimAttributeValue ZPAV 
				INNER JOIN ZnodePublishProduct TYU ON (TYU.PimProductId  = ZPAV.PimProductId)
				INNER JOIN ZnodePimProductAttributeMedia  RT ON ( RT.PimAttributeValueId = ZPAV.PimAttributeValueId )
				INNER JOIN #TBL_PublishCatalogId TUI ON (TUI.PublishProductId = TYU.PublishProductId AND TUI.PublishCatalogId = TYU.PublishCatalogId
						 )--AND  TUI.LocaleId = dbo.Fn_GetDefaultLocaleId()
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE  RT.LocaleId = dbo.Fn_GetDefaultLocaleId()
				AND ZPAV.PimAttributeId = (SELECT TOp 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'ProductImage')
				group by TUI.PublishCatalogId, TYU.PublishProductId ,isnull(RT.MediaPath,''),isnull(ZPC1.IsAllowIndexing,0) 
		  -- end
	  
WHILE @Counter <= @maxCountId
BEGIN
 SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId WHERE RowId = @Counter)

  INSERT INTO #PimProductAttributeJson 
  SELECT PimAttributeJsonId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeJSON
  WHERE LocaleId = @LocaleId
  
  INSERT INTO #PimProductAttributeJson 
  SELECT PimAttributeJsonId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeJSON ZPAX
  WHERE ZPAX.LocaleId = @DefaultLocaleId  
  AND NOT EXISTS (SELECT TOP 1 1 FROM #PimProductAttributeJson ZPAXI WHERE ZPAXI.PimAttributeId = ZPAX.PimAttributeId )

  INSERT INTO @PimDefaultValueLocale
  SELECT PimAttributeDefaultJsonId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultJson
  WHERE localeId = @LocaleId

  INSERT INTO @PimDefaultValueLocale 
   SELECT PimAttributeDefaultJsonId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultJson ZX
  WHERE localeId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM @PimDefaultValueLocale TRTR WHERE TRTR.PimAttributeDefaultValueId = ZX.PimAttributeDefaultValueId)
  
 
  --DECLARE @TBL_AttributeVAlue TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )
  --DECLARE @TBL_CustomeFiled TABLE (PimCustomeFieldJsonId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )
  CREATE TABLE #TBL_CustomeFiled  (PimCustomeFieldJsonId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )
  CREATE TABLE #TBL_AttributeVAlue (PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )



  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldJsonId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldJsonId,RTR.PimProductId ,RTR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldJson RTR 
  INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = RTR.PimProductId)
  WHERE RTR.LocaleId = @LocaleId
 

  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldJsonId,PimProductId ,LocaleId,CustomCode)
  SELECT  Distinct  PimCustomeFieldJsonId,ITR.PimProductId ,ITR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldJson ITR
  INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ITR.PimProductId)
  WHERE ITR.LocaleId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM #TBL_CustomeFiled TBL  WHERE ITR.CustomCode = TBL.CustomCode AND ITR.PimProductId = TBL.PimProductId)
  

    INSERT INTO #TBL_AttributeVAlue (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
    SELECT Distinct  PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
	FROM @TBL_AttributeVAlueLocale
    WHERE LocaleId = @LocaleId

    
	INSERT INTO #TBL_AttributeVAlue(PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
	SELECT VI.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
	FROM @TBL_AttributeVAlueLocale VI 
    WHERE VI.LocaleId = @DefaultLocaleId 
	AND NOT EXISTS (SELECT TOP 1 1 FROM #TBL_AttributeVAlue  CTE WHERE CTE.PimProductId = VI.PimProductId AND CTE.PimAttributeId = VI.PimAttributeId )
 
	------------Facet Merging Patch --------------
	IF OBJECT_ID('tempdb..#PimChildProductFacets') is not null
	BEGIN 
		DROP TABLE #PimChildProductFacets
	END 

	IF OBJECT_ID('tempdb..#PimAttributeDefaultXML') is not null
	BEGIN 
		DROP TABLE #PimAttributeDefaultXML
	END
	----Getting parent facets data
	Select  ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
	Into #PimChildProductFacets
	from ZnodePimAttributeValue ZPAV_Parent
	inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Parent.PimAttributeValueId = ZPPADV.PimAttributeValueId 
	where exists(select * from #ProductIds ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )

	----Getting child facets for merging	
	insert into #PimChildProductFacets	  
	Select distinct ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
	from ZnodePimAttributeValue ZPAV_Parent
	inner join ZnodePimProductTypeAssociation ZPPTA ON ZPAV_Parent.PimProductId = ZPPTA.PimParentProductId
	inner join ZnodePimAttributeValue ZPAV_Child ON ZPPTA.PimProductId = ZPAV_Child.PimProductId AND ZPAV_Parent.PimAttributeId = ZPAV_Child.PimAttributeId
	inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Child.PimAttributeValueId = ZPPADV.PimAttributeValueId 
	where exists(select * from ZnodePimFrontendProperties ZPFP where ZPAV_Parent.PimAttributeId = ZPFP.PimAttributeId and ZPFP.IsFacets = 1)
	and exists(select * from #ProductIds ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )
	and not exists(select * from ZnodePimProductAttributeDefaultValue ZPPADV1 where ZPAV_Parent.PimAttributeValueId = ZPPADV1.PimAttributeValueId 
		            and ZPPADV1.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )

	----Merging childs facet attribute Default value XML for parent
	select  ZPADX.DefaultValueJson, ZPPADV.PimAttributeValueId, ZPPADV.LocaleId
	into #PimAttributeDefaultXML
	from #PimChildProductFacets ZPPADV		  
	inner join ZnodePimAttributeDefaultJson ZPADX ON ( ZPPADV.PimAttributeDefaultValueId = ZPADX.PimAttributeDefaultValueId )--AND ZPPADV.LocaleId = ZPADX.LocaleId)
	INNER JOIN @PimDefaultValueLocale GH ON (GH.PimAttributeDefaultJsonId = ZPADX.PimAttributeDefaultJsonId)
	------------Facet Merging Patch --------------   

	 IF OBJECT_ID('tempdb..#View_LoadManageProductInternal') is not null
	 BEGIN 
		DROP TABLE #View_LoadManageProductInternal
	 END 

	SELECT a.PimProductId ,b.AttributeValue as AttributeValue , b.LocaleId  ,a.PimAttributeId,c.AttributeCode ,b.ZnodePimAttributeValueLocaleId
	into #View_LoadManageProductInternal
	FROM ZnodePimAttributeValue a 
	INNER JOIN  ZnodePimAttributeValueLocale b ON ( b.PimAttributeValueId = a.PimAttributeValueId )
	INNER JOIN ZnodePimAttribute c ON ( c.PimAttributeId=a.PimAttributeId )
	INNER JOIN ZnodePimAttributeJSON c1   ON (c1.PimAttributeId = a.PimAttributeId )
	INNER JOIN #PimProductAttributeJson b1 ON (b1.PimAttributeJsonId = c1.PimAttributeJsonId )
	INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = b.ZnodePimAttributeValueLocaleId)
	UNION ALL
	SELECT a.PimProductId,ZPPATAV.AttributeValue AS AttributeValue  
	,ZPPATAV.LocaleId,a.PimAttributeId,c.AttributeCode  ,ZPPATAV.PimProductAttributeTextAreaValueId
	FROM ZnodePimAttributeValue a 
	INNER JOIN ZnodePimProductAttributeTextAreaValue ZPPATAV ON (ZPPATAV.PimAttributeValueId = a.PimAttributeValueId )
	INNER JOIN ZnodePimAttribute c ON ( c.PimAttributeId=a.PimAttributeId )
	INNER JOIN ZnodePimAttributeJSON c1   ON (c1.PimAttributeId = a.PimAttributeId )
	INNER JOIN #PimProductAttributeJson b1 ON (b1.PimAttributeJsonId = c1.PimAttributeJsonId )
	INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = ZPPATAV.PimProductAttributeTextAreaValueId)
	
	INSERT INTO #TBL_ZnodeTempPublish  
		SELECT  a.PimProductId,a.AttributeCode , 
			JSON_MODIFY (JSON_MODIFY (Json_Query( c.AttributeJSON  ) , '$.AttributeValues' ,  
			ISNULL(a.AttributeValue,'') ) ,'$.SelectValues',Json_Query('[]'))
			AS 'AttributeValue'
		FROM #View_LoadManageProductInternal a 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = a.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = a.ZnodePimAttributeValueLocaleId)
	UNION ALL 
			SELECT  a.PimProductId,c.AttributeCode , 
			JSON_MODIFY (JSON_MODIFY (Json_Query( c.AttributeJSON  ) , '$.AttributeValues' ,  
			ISNULL(TAVL.AttributeValue,'') ) ,'$.SelectValues',Json_Query('[]'))
			AS 'AttributeValue'
		FROM ZnodePimAttributeValue  a 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = a.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN ZnodePImAttribute ZPA  ON (ZPA.PimAttributeId = a.PimAttributeId)
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = a.PimProductId)
		Inner JOIN @TBL_AttributeVAlueLocale TAVL ON  (c.PimAttributeId = TAVL.PimAttributeId  and ZPP.PimProductId = TAVL.PimProductId )
		WHERE ZPA.IsPersonalizable = 1 
		AND NOT EXISTS ( SELECT TOP 1 1 FROM ZnodePimAttributeValueLocale q WHERE q.PimAttributeValueId = a.PimAttributeValueId) 
	UNION ALL 
		SELECT THB.PimProductId,THB.CustomCode,
		--'<Attributes><AttributeEntity>'+CustomeFiledJson +'</AttributeEntity></Attributes>' 
		JSON_MODIFY (Json_Query( CustomeFiledJson ) ,'$.SelectValues',Json_Query('[]')) 
		FROM ZnodePimCustomeFieldJson THB 
		INNER JOIN #TBL_CustomeFiled TRTE ON (TRTE.PimCustomeFieldJsonId = THB.PimCustomeFieldJsonId)
		UNION ALL 
		SELECT ZPAV.PimProductId,c.AttributeCode,
			JSON_MODIFY (JSON_MODIFY (c.AttributeJson,'$.AttributeValues',''), '$.SelectValues',
			Isnull((SELECT 
			Isnull(JSON_VALUE(DefaultValueJson, '$.Code'),'') Code 
			,Isnull(JSON_VALUE(DefaultValueJson, '$.LocaleId'),0) LocaleId
			,IsNull(JSON_VALUE(DefaultValueJson, '$.Value'),'') Value
			,IsNull(JSON_VALUE(DefaultValueJson, '$.AttributeDefaultValue'),'') AttributeDefaultValue
			,Isnull(JSON_VALUE(DefaultValueJson, '$.DisplayOrder'),0) DisplayOrder
			,Isnull(JSON_VALUE(DefaultValueJson, '$.IsEditable'),'false') IsEditable
			,Isnull(JSON_VALUE(DefaultValueJson, '$.SwatchText'),'') SwatchText
			,Isnull(JSON_VALUE(DefaultValueJson, '$.Path'),'') Path
			FROM #PimAttributeDefaultXML ZPADV
			WHERE (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId) For JSON Auto 
			),'[]') 
		)  AttributeValue
		FROM ZnodePimAttributeValue ZPAV  With (NoLock)
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
		WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
	UNION ALL 
		SELECT DISTINCT  ZPAV.PimProductId,c.AttributeCode,
			JSON_MODIFY (JSON_MODIFY (Json_Query( c.AttributeJson  ) , '$.AttributeValues',  
			ISNULL((Select stuff( 
			(SELECT ','+ZPPG.MediaPath 
			FROM ZnodePimProductAttributeMedia ZPPG INNER JOIN  #TBL_AttributeVAlue TBLV ON 
			(	TBLV.PimProductId=  ZPAV.PimProductId AND TBLV.PimAttributeId = ZPAV.PimAttributeId )
			WHERE ZPPG.PimProductAttributeMediaId = TBLV.ZnodePimAttributeValueLocaleId
			FOR XML PATH(''),Type).value('.', 'varchar(max)'), 1, 1, '')),'') ) ,'$.SelectValues',Json_Query('[]'))   
			AS 'AttributeEntity'
		FROM ZnodePimAttributeValue ZPAV 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeMedia ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
	UNION ALL 
		SELECT ZPLP.PimParentProductId ,c.AttributeCode, 
			JSON_MODIFY( JSON_Modify(c.AttributeJson , '$.AttributeValues' , 
			ISNULL(SUBSTRING((SELECT ','+cast( LP.SKU as varchar(600)) 
							 FROM #LinkProduct LP
							 WHERE LP.PimParentProductId = ZPLP.PimParentProductId 
							 AND LP.PimAttributeId = ZPLP.PimAttributeId
		FOR XML PATH ('') ),2,4000),'')),'$.SelectValues',Json_Query('[]'))   
	
		FROM ZnodePimLinkProductDetail ZPLP 
		INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPLP.PimParentProductId)
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPLP.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		GROUP BY ZPLP.PimParentProductId , ZPP.PublishProductId  ,ZPLP.PimAttributeId,c.AttributeCode,c.AttributeJson,ZPP.PublishCatalogId
	UNION ALL 
		SELECT ZPAV.PimProductId,'DefaultSkuForConfigurable' ,
			JSON_MODIFY( JSON_Modify(
			REPLACE(REPLACE (c.AttributeJson,'ProductType','DefaultSkuForConfigurable'),'Product Type','Default Sku For Configurable'),
			'$.AttributeValues' , 
			ISNULL(SUBSTRING((SELECT ','+CAST(adl.AttributeValue AS VARCHAR(50)) 
		FROM ZnodePimAttributeValue ad 
		inner join ZnodePimAttributeValueLocale adl on ad.PimattributeValueId = adl.PimAttributeValueId
		INNER JOIN ZnodePimProductTypeAssociation yt ON (yt.PimProductId = ad.PimProductId)
		WHERE EXISTS (select * from #ProductIds p where yt.PimParentProductId = p.PimProductId)
		AND Ad.PimAttributeId =(select top 1 PimAttributeId from ZnodePimAttribute zpa where zpa.AttributeCode = 'SKU')
		AND yt.PimParentProductId = ZPAV.PimProductId 
		ORDER BY yt.DisplayOrder , yt.PimProductTypeAssociationId ASC FOR XML PATH ('') ),2,4000),'')),'$.SelectValues',Json_Query('[]'))   
		FROM ZnodePimAttributeValue ZPAV  
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
		INNER JOIN ZnodePimAttributeDefaultValue dr ON (dr.PimAttributeDefaultValueId = ZPADVL.PimAttributeDefaultValueId)
		WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId
		AND dr.AttributeDefaultValueCode= 'ConfigurableProduct' 
		)
		AND EXISTS (select * from #PimProductAttributeJson b where b.PimAttributeJsonId = c.PimAttributeJsonId)
		AND c.AttributeCode = 'ProductType' 
	UNION ALL
		SELECT DISTINCT  UOP.PimProductId,c.AttributeCode,
			JSON_MODIFY (JSON_MODIFY (c.AttributeJson,'$.AttributeValues',''), '$.SelectValues',
			Isnull((SELECT  DISTINCT 
			Isnull(JSON_VALUE(AA.DefaultValueJson, '$.Code'),'') Code 
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.LocaleId'),0) LocaleId
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.Value'),'') Value
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.AttributeDefaultValue'),'') AttributeDefaultValue
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.DisplayOrder'),0) DisplayOrder
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.IsEditable'),'false') IsEditable
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.SwatchText'),'') SwatchText
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.Path'),'') Path 
			,ISNULL(ZPA.DisplayOrder,0)  AS VariantDisplayOrder 
			,ISNULL(ZPAVL_SKU.AttributeValue,'')   AS VariantSKU 
			--,Isnull(ZM.Path,'') 
		,'' AS VariantImagePath 
		FROM ZnodePimAttributeDefaultJson AA 
		INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
		INNER JOIN ZnodePimAttributeValue ZPAV1 ON (ZPAV1.PimAttributeValueId= ZPADV.PimAttributeValueId )
		-- check/join for active variants 
		INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId =ZPAV1.PimProductId)
		INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPAV.PimAttributevalueid = ZPAVL.PimAttributeValueId AND ZPAVL.AttributeValue = 'True')
		INNER JOIN ZnodePimProductTypeAssociation YUP ON (YUP.PimProductId = ZPAV1.PimProductId)
		-- SKU
		INNER JOIN ZnodePimAttributeValue ZPAV_SKU ON(YUP.PimProductId = ZPAV_SKU.PimProductId)
		INNER JOIN ZnodePimAttributeValueLocale ZPAVL_SKU ON (ZPAVL_SKU.PimAttributeValueId = ZPAV_SKU.PimAttributeValueId)
		LEFT JOIN ZnodePimAttribute ZPA ON (ZPA.PimattributeId = ZPAV1.PimAttributeId)
		WHERE (YUP.PimParentProductId  = UOP.PimProductId AND ZPAV1.pimAttributeId = UOP.PimAttributeId )
		-- Active Variants
		AND ZPAV.PimAttributeId = (SELECT TOP 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'IsActive')
		-- VariantSKU
		AND ZPAV_SKU.PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'SKU')
		For JSON Auto 
		),'[]')) 
				
		--</AttributeEntity></Attributes>' 
		FROM ZnodePimConfigureProductAttribute UOP 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = UOP.PimAttributeId )
		WHERE  exists(select * from #TBL_PublishCatalogId PPCP1 where UOP.PimProductId = PPCP1.PimProductId )
		AND EXISTS (select * from #PimProductAttributeJson b where b.PimAttributeJsonId = c.PimAttributeJsonId)

			-------------configurable attribute 
			---------------------------------------------------------------------
			
			If (@RevisionType like '%Preview%'  OR @RevisionType like '%Production%'  ) 
				Delete from ZnodePublishProductEntity where SKU  in (select SKU from #TBL_PublishCatalogId
				A inner join ZnodePublishProductDetail B on A.PublishProductId   =B.PublishProductId   )
				AND LocaleId = @LocaleId
				AND VersionId in (SELECT VersionId FROM ZnodePublishVersionEntity where RevisionType = 'PREVIEW')
			If (@RevisionType like '%Production%' OR @RevisionType = 'None')
				Delete from ZnodePublishProductEntity where SKU  in (select SKU from #TBL_PublishCatalogId
				A inner join ZnodePublishProductDetail B on A.PublishProductId   =B.PublishProductId   )
				AND LocaleId = @LocaleId
				AND VersionId in (SELECT VersionId FROM ZnodePublishVersionEntity where RevisionType = 'PRODUCTION')

			Insert into ZnodePublishProductEntity (
					VersionId, --1
					IndexId, --2 
					ZnodeProductId,ZnodeCatalogId, --3
					SKU,LocaleId, --4 
					Name,ZnodeCategoryIds, --5
					IsActive, -- 6 
					Attributes, -- 7 
					Brands, -- 9
					CategoryName, --9
					CatalogName,DisplayOrder, --10 
					RevisionType,AssociatedProductDisplayOrder, --11
					ProductIndex,--12
					SalesPrice,RetailPrice,CultureCode,CurrencySuffix,CurrencyCode,SeoDescription,SeoKeywords,SeoTitle,SeoUrl,ImageSmallPath,SKULower --13 
					)
 			SELECT distinct ZPVE.VersionId, --1 
			CAST(ISNULL(ZPCP.ProductIndex,1) AS VARCHAr(100)) + CAST(ISNULL(ZPC.PublishCategoryId,'')  AS VARCHAR(50))  + 
			CAST(Isnull(ZPP.PublishCatalogId ,'')  AS VARCHAR(50)) + CAST( @LocaleId AS VARCHAR(50)) IndexId, --2 
			CAST(ZPP.PublishProductId AS VARCHAR(50)) PublishProductId,CAST(ZPP.PublishCatalogId  AS VARCHAR(50)) PublishCatalogId,  --3 
			CAST(ISNULL(ZPPDFG.SKU ,'') AS NVARCHAR(2000)) SKU,CAST( Isnull(@LocaleId ,'') AS VARCHAR(50)) LocaleId, -- 4 
			CAST(isnull(ZPPDFG.ProductName,'') AS NVARCHAR(2000) )  ProductName ,CAST(ISNULL(ZPCD.PublishCategoryId,'')  AS VARCHAR(50)) PublishCategoryId  -- 5 
			,CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50)) IsActive , --6 
			'[' +
				(Select STUFF((SELECT distinct ','+ AttributeValue from #TBL_ZnodeTempPublish TY WHERE TY.PimProductId = ZPP.PimProductId   
				FOR XML Path ('')) ,1,1,'')  ) 
			+ ']' xmlvalue,  -- 7 
			'[]' Brands  --8 
			,CAST(isnull(PublishCategoryName,'') AS NVARCHAR(2000)) CategoryName  --9
			,CAST(Isnull(CatalogName,'')  AS NVARCHAR(2000)) CatalogName,CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50)) DisplayOrder  -- 10  
			,ZPVE.RevisionType RevisionType , 0 AssociatedProductDisplayOrder,-- pending  -- 11 
			Isnull(ZPCP.ProductIndex,1),  -- 12 

			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CAST(SalesPrice  AS varchar(500)),'') else '' end SalesPrice , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CAST(RetailPrice  AS varchar(500)),'') else '' end RetailPrice , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CultureCode ,'') else '' end CultureCode , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CurrencySuffix ,'') else '' end CurrencySuffix , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CurrencyCode ,'') else '' end CurrencyCode , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEODescription,'') else '' end SEODescriptionForIndex,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEOKeywords,'') else '' end SEOKeywords,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEOTitle,'') else '' end SEOTitle,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEOUrl ,'') else '' end SEOUrl,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(ImageSmallPath,'') else '' end ImageSmallPath,
			CAST(ISNULL(LOWER(ZPPDFG.SKU) ,'') AS NVARCHAR(100)) Lower_SKU -- 13
	FROM  #TBL_PublishCatalogId zpp
	INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
	INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)
	INNER JOIN ZnodePublishVersionEntity ZPVE ON (ZPVE.ZnodeCatalogId  = ZPP.PublishCatalogId AND ZPVE.IsPublishSuccess =1 AND ZPVE.LocaleId = @LocaleId )
	LEFT JOIN #ZnodePrice TBZP ON (TBZP.PublishProductId = ZPP.PublishProductId)
	LEFT JOIN #ProductSKU TBPS ON (TBPS.PublishProductId = ZPP.PublishProductId)
	LEFT JOIN #ProductImages TBPI ON (TBPI.PublishProductId = ZPP.PublishProductId  )
	LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
	LEFT JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCatalogId = ZPCP.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId)
	LEFT JOIN ZnodePimCategoryProduct ZPCCF ON (ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId )
	LEFT JOIN ZnodePimCategoryHierarchy ZPCH ON (ZPCH.PimCatalogId = ZPCV.PimCatalogId AND  ZPCH.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId) 
	LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ZPCP.PublishCategoryId AND ZPCD.LocaleId = @LocaleId )
	WHERE ZPPDFG.LocaleId = @LocaleId
		--AND zpp.LocaleId = @LocaleId
	AND 
		(
			(ZPVE.RevisionType =  Case when  (@RevisionType like '%Preview%'  OR @RevisionType like '%Production%' ) then 'Preview' End ) 
			OR 
			(ZPVE.RevisionType =  Case when (@RevisionType like '%Production%' OR @RevisionType = 'None') then  'Production'  end )
		)


	DELETE FROM #TBL_ZnodeTempPublish
	IF OBJECT_ID('tempdb..#PimProductAttributeJson') is not null
	 BEGIN 
		DELETE FROM #PimProductAttributeJson
	 END
	 IF OBJECT_ID('tempdb..#TBL_CustomeFiled') is not null
	 BEGIN 
	 DROP TABLE #TBL_CustomeFiled
	 END
	 IF OBJECT_ID('tempdb..#TBL_AttributeVAlue') is not null
	 BEGIN 
	 DROP TABLE #TBL_AttributeVAlue
	 END
 
	DELETE FROM @PimDefaultValueLocale
SET @Counter = @counter + 1 
END

SET @Status =1 

END TRY 
BEGIN CATCH 
	SET @Status =0  
	 SELECT 1 AS ID,@Status AS Status;   
	 DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
		@ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC [Znode_GetPublishSingleProductJson] 
		@PublishCatalogId = '+CAST(@PublishCatalogId  AS VARCHAR	(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10))
				
	EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'Znode_GetPublishSingleProductJson',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;
END CATCH
END

go

INSERT INTO ZnodeAttributeInputValidationRule(InputValidationId,ValidationRule,ValidationName,DisplayOrder,RegExp,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),null,'.dwg',9,null,
	2,getdate(),2,getdate()
where not exists(select * from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.dwg')

INSERT INTO ZnodeAttributeInputValidationRule(InputValidationId,ValidationRule,ValidationName,DisplayOrder,RegExp,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),null,'.bin',9,null,
	2,getdate(),2,getdate()
where not exists(select * from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.bin')

INSERT INTO ZnodeAttributeInputValidationRule(InputValidationId,ValidationRule,ValidationName,DisplayOrder,RegExp,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),null,'.file',9,null,
	2,getdate(),2,getdate()
where not exists(select * from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.file')

INSERT INTO ZnodeAttributeInputValidationRule(InputValidationId,ValidationRule,ValidationName,DisplayOrder,RegExp,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),null,'.tar',9,null,
	2,getdate(),2,getdate()
where not exists(select * from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.tar')

INSERT INTO ZnodeAttributeInputValidationRule(InputValidationId,ValidationRule,ValidationName,DisplayOrder,RegExp,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),null,'.gz',9,null,
	2,getdate(),2,getdate()
where not exists(select * from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.gz')

INSERT INTO ZnodeMediaAttributeValidation(MediaAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'Image'),
(select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),
(select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.dwg'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeMediaAttributeValidation where 
MediaAttributeId = (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'Image') and
InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions') and 
InputValidationRuleId = (select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.dwg'))

INSERT INTO ZnodeMediaAttributeValidation(MediaAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File'),
(select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),
(select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.bin'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeMediaAttributeValidation where 
MediaAttributeId = (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File') and
InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions') and 
InputValidationRuleId = (select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.bin'))

INSERT INTO ZnodeMediaAttributeValidation(MediaAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File'),
(select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),
(select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.file'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeMediaAttributeValidation where 
MediaAttributeId = (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File') and
InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions') and 
InputValidationRuleId = (select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.file'))

INSERT INTO ZnodeMediaAttributeValidation(MediaAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File'),
(select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),
(select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.tar'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeMediaAttributeValidation where 
MediaAttributeId = (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File') and
InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions') and 
InputValidationRuleId = (select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.tar'))

INSERT INTO ZnodeMediaAttributeValidation(MediaAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File'),
(select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),
(select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.gz'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeMediaAttributeValidation where 
MediaAttributeId = (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File') and
InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions') and 
InputValidationRuleId = (select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.gz'))


go
	
  IF exists(select * from sys.procedures where name = 'Znode_PublishPortalEntity')
	drop proc Znode_PublishPortalEntity
go

CREATE PROCEDURE [dbo].[Znode_PublishPortalEntity]
(
   @PortalId  INT = 0 
  ,@LocaleId  INT = 0 
  ,@RevisionState varchar(50) = '' 
  ,@UserId int = 0
  ,@Status Bit =0 OUTPUT 
  ,@IsContentType Bit= 1
  ,@NewGUID nvarchar(500)  
)
AS
/*
  To publish all Contenet pages and their mapping into their respective entities 
	ZnodePublishContentPageConfigEntity
	ZnodePublishSEOEntity
	ZnodePublishWidgetProductEntity
	ZnodePublishMediaWidgetEntity
	ZnodePublishSearchWidgetEntity
	ZnodePublishTextWidgetEntity
	ZnodePublishWidgetSliderBannerEntity
	ZnodePublishWidgetTitleEntity

	Unit Testing : 
	Declare @Status bit 
	

	Declare @Status bit 
	Exec [dbo].[Znode_PublishPortalEntity]
     @PortalId  = 1 
	,@LocaleId  = 0 
	,@RevisionState = 'PRODUCTION' 
	,@UserId = 2
	,@Status = @Status 
	--Select @Status 


*/
BEGIN
BEGIN TRY 
SET NOCOUNT ON
	Declare @PortalCode Varchar(100)
	Declare @Type varchar(50) = '',	@CMSSEOCode varchar(300),@UserName Varchar(50);
	SET @Status = 1 
	Declare @IsPreviewEnable int,@PreviewVersionId INT = 0  ,@ProductionVersionId INT = 0
	
	Select TOP 1  @UserName = aspNetZnodeUser.UserName from ZnodeUser Inner Join aspNetUsers ON ZnodeUser.aspNetUserId = aspNetUsers.Id 
	Inner Join aspNetZnodeUser on aspNetUsers.UserName = aspNetZnodeUser.AspNetZnodeUserId
	where ZnodeUser.UserId = @userId
            


 		If Exists (SELECT  * from ZnodePublishStateApplicationTypeMapping PSA where PSA.IsEnabled =1 and  
		Exists (select TOP 1 1  from ZnodePublishState PS where PS.PublishStateId = PSA.PublishStateId ) and ApplicationType =  'WebstorePreview')
			SET @IsPreviewEnable = 1 
		else 
			SET @IsPreviewEnable = 0 

		--Genrate preview entry 
		DECLARE @SetLocaleId INT , @DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleId(), @MaxCount INT =0 , @IncrementalId INT = 1  
		DECLARE @TBL_Locale TABLE (LocaleId INT , RowId INT IDENTITY(1,1))
		
		DECLARE @TBL_StoreEntity TABLE 
		(
			 PortalThemeId	int,PortalId	int,ThemeId	int,ThemeName	varchar(200),CSSId	int,CSSName	nvarchar(2000),
			 WebsiteLogo	varchar(300),WebsiteTitle	nvarchar(400),FaviconImage	varchar(300),WebsiteDescription	nvarchar(MAX),
			 PublishState	varchar(100),LocaleId	int	
		)
		
		IF object_id('tempdb..[#Tbl_VersionEntity]') IS NOT NULL
			drop table tempdb..#Tbl_VersionEntity
		Create Table #Tbl_VersionEntity(PortalId int , VersionId int , LocaleId int , PublishType varchar(50) )

		IF object_id('tempdb..[#Tbl_OldVersionEntity]') IS NOT NULL
			drop table tempdb..#Tbl_OldVersionEntity
		Create Table #Tbl_OldVersionEntity(PortalId int , NewVersionId int ,OldVersionId int , LocaleId int , PublishType varchar(50) )

	
		DECLARE @WebStoreEntityId int 
		
		select @PortalCode  = StoreName  from ZnodePortal where PortalId = @PortalId 
		
		INSERT INTO @TBL_Locale (LocaleId) SELECT LocaleId FROM ZnodeLocale WHERE IsActive =1 AND (LocaleId  = @LocaleId OR @LocaleId = 0 )
		
		
		SET @MaxCount = ISNULL((SELECT MAx(RowId) FROM @TBL_Locale),0)
		WHILE @IncrementalId <= @MaxCount
		BEGIN 
			SET @SetLocaleId = (SELECT Top 1 LocaleId FROM @TBL_locale WHERE RowId = @IncrementalId)
			if (@IsPreviewEnable = 1 AND ( @RevisionState like '%Preview%'  OR @RevisionState like '%Production%' ) ) 
			Begin
				Insert into ZnodePublishPortalLog
				(PortalId,IsPortalPublished,UserId,LogDateTime,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Tokem,PublishStateId)
				Select @PortalId ,1 , @UserId , Getdate(),@UserId ,Getdate() ,@UserId ,Getdate(), NULL, DBO.Fn_GetPublishStateIdForProcessing()
				
				insert into #Tbl_VersionEntity (PortalId,VersionId,LocaleId,PublishType)
				select @PortalId, @@Identity , @SetLocaleId ,'PREVIEW'
				
			End
			If (@RevisionState like '%Production%' OR @RevisionState = 'None')
			Begin
				--Genrate production entry 
				Insert into ZnodePublishPortalLog
				(PortalId,IsPortalPublished,UserId,LogDateTime,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Tokem,PublishStateId)
				Select @PortalId ,1 , @UserId , Getdate(),@UserId ,Getdate() ,@UserId ,Getdate(), NULL, DBO.Fn_GetPublishStateIdForProcessing()
			
				insert into #Tbl_VersionEntity (PortalId,VersionId,LocaleId,PublishType)
				select @PortalId, @@Identity , @SetLocaleId ,'PRODUCTION'
			End 
	   	SET @IncrementalId = @IncrementalId +1 
		END 

	Truncate table ZnodePublishPortalErrorLogEntity

	Declare @IsFirstTimeContentPublish bit 
	If Exists (Select TOP 1 1  from ZnodePublishWebStoreEntity where PortalId = @PortalId)
		SET @IsFirstTimeContentPublish =1 
	else 
		SET @IsFirstTimeContentPublish =0
    
	Declare @Tbl_PreviewVersionId  TABLE (VersionId int , PortalId int , LocaleId int )
	Declare @Tbl_ProductionVersionId  TABLE (VersionId int , PortalId int , LocaleId int )

	If @IsContentType = 0 AND @IsFirstTimeContentPublish =1 
	Begin 
		Insert into #Tbl_OldVersionEntity (PortalId,NewVersionId,OldVersionId, LocaleId, PublishType)
		Select A.PortalId , A.VersionId, B.VersionId, a.LocaleId,a.PublishType from #Tbl_VersionEntity A Inner join ZnodePublishWebStoreEntity B on 
		A.PortalId = B.PortalId and A.LocaleId = B.LocaleId AND A.PublishType= B.PublishState  
	End
	Delete from ZnodePublishProgressNotifierEntity where JobName  = @PortalCode 
	
	INSERT INTO ZnodePublishProgressNotifierEntity
	(VersionId,JobId,JobName,ProgressMark,IsCompleted,IsFailed,ExceptionMessage,StartedBy,StartedByFriendlyName)
	Values(0,@NewGUID , Isnull(@PortalCode,'') + ' Store' , 0 , 0 , 0 , '' , @UserId, @UserName)

	if @Type = 'ZnodePublishWebStoreEntity' OR @Type = ''
	Begin
		 Declare  @PreviewVersionIdString varchar(1000)= ''  ,@ProductionVersionIdString varchar(1000) = '' 
		 SELECT   @PreviewVersionIdString = STUFF((SELECT ',' + cast (VersionId as varchar(50))  FROM #Tbl_VersionEntity   where PublishType = 'PREVIEW'  FOR XML PATH ('')), 1, 1, '') 
		 SELECT   @ProductionVersionIdString = STUFF((SELECT ',' + cast (VersionId as varchar(50))  FROM #Tbl_VersionEntity   where PublishType = 'PRODUCTION'  FOR XML PATH ('')), 1, 1, '') 
		 
		 EXEC [dbo].[Znode_SetPublishWebStoreEntity]
			 @PortalId  = @PortalId 
			,@LocaleId   = @LocaleId 
			,@IsPreviewEnable =@IsPreviewEnable 
			,@PreviewVersionId  = @PreviewVersionIdString 
			,@ProductionVersionId = @ProductionVersionIdString 
			,@RevisionState = @RevisionState 
			,@UserId = @UserId	
			,@Status = @Status Output 

			INSERT INTO ZnodePublishPortalErrorLogEntity
			(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
			SELECT 'ZnodePublishWebStoreEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
			@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

			Update ZnodePublishProgressNotifierEntity SET 
			ProgressMark =5 , 
			IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
			IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
			where  JobId = @NewGUID
	End
	
	if (@Type = 'ZnodePublishPortalBrandEntity' OR @Type = '' ) AND @Status = 1 
	Begin
			Exec [Znode_SetPublishPortalBrandEntity]
			 @PortalId  = @PortalId
			,@IsPreviewEnable =@IsPreviewEnable 
			,@PreviewVersionId  = 0 
			,@ProductionVersionId = 0
			,@RevisionState = @RevisionState 
			,@UserId = @UserId  
			,@Status = @Status Output 

			INSERT INTO ZnodePublishPortalErrorLogEntity
			(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
			SELECT 'ZnodePublishPortalBrandEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
			@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
			
			Update ZnodePublishProgressNotifierEntity SET 
			ProgressMark = CASE When (@IsContentType = 1 OR (@IsFirstTimeContentPublish = 0 AND @IsContentType = 0 ) ) THEN 10 Else 100 End , 
			IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
			IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
			where  JobId = @NewGUID
	End 

	if (@Type = 'ZnodePublishSEOEntity' OR @Type = '') AND @Status = 1 and (@IsContentType = 0 or @PortalId > 0)
			Begin
					Exec [Znode_SetPublishSEOEntity]
					 @PortalId  = @PortalId
					,@LocaleId  = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = 0 
					,@ProductionVersionId = 0
					,@RevisionState = @RevisionState 
					,@CMSSEOTypeId = '4'
					,@CMSSEOCode = ''
					,@UserId = @UserId  
					,@Status = @Status Output 

			End 
	If (@IsContentType = 1 OR (@IsFirstTimeContentPublish = 0 AND @IsContentType = 0 ) ) AND @Status = 1  
	Begin
			if @Type = 'ZnodePublishBlogNewsEntity' OR @Type = '' 
			Begin
				 EXEC [dbo].[Znode_SetPublishBlogNewsEntity]
					 @PortalId  = @PortalId 
					,@LocaleId   = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@UserId = @UserId	
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishBlogNewsEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 15 , 
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID

			End
			if (@Type = 'ZnodePublishPortalCustomCssEntity' OR @Type = '' ) AND @Status = 1  
			Begin
				 EXEC [dbo].[Znode_SetPublishPortalCustomCssEntity]
					 @PortalId  = @PortalId 
					,@LocaleId   = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@UserId = @UserId	
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishPortalCustomCssEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 20  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID


			End
			if (@Type = 'ZnodePublishWidgetCategoryEntity' OR @Type = '' ) AND @Status = 1 
			Begin
				 EXEC [dbo].[Znode_SetPublishWidgetCategoryEntity]
					 @PortalId  = @PortalId 
					,@LocaleId   = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@UserId = @UserId	
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishWidgetCategoryEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 25  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID
			End
	
			if (@Type = 'ZnodePublishWidgetProductEntity' OR @Type = '') AND @Status = 1  
			Begin
					EXEC Znode_SetPublishWidgetProductEntity
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSMappingId = 0
					,@UserId = @UserId 
					,@Status = @Status  Output
			
					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishWidgetProductEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 30  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID
			END 

			if (@Type = 'ZnodePublishWidgetTitleEntity' OR @Type = '') AND @Status = 1  
			Begin
					EXEC Znode_SetPublishWidgetTitleEntity
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSContentPagesId = 0
					,@UserId = @UserId 
					,@Status = @Status  Output

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishWidgetTitleEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 35  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID

			END 
			if (@Type = 'ZnodePublishWidgetSliderBannerEntity' OR @Type = '')AND @Status = 1  
			Begin
					EXEC Znode_SetPublishWidgetSliderBannerEntity
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSContentPagesId = 0
					,@CMSSliderId = 0 
					,@UserId = @UserId 
					,@Status = @Status  Output
			
					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishWidgetSliderBannerEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
					
					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 40  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			
			END 
			if (@Type = 'ZnodePublishTextWidgetEntity' OR @Type = '' ) AND @Status = 1  
			Begin
					EXEC Znode_SetPublishTextWidgetEntity
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSMappingId = 0
					,@UserId = @UserId 
					,@Status = @Status  Output
			
					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishTextWidgetEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 45  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			

			END 
			if (@Type = 'ZnodeSetPublishMediaWidgetEntity' OR @Type = '') AND @Status = 1
			Begin
					EXEC Znode_SetPublishMediaWidgetEntity
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSMappingId = 0
					,@UserId = @UserId 
					,@Status = @Status  Output
			
					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishMediaWidgetEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
										
					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 50  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			
			END 
			if (@Type = 'ZnodePublishSearchWidgetEntity' OR @Type = '') AND @Status = 1
			Begin
					EXEC Znode_SetPublishSearchWidgetEntity
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSMappingId = 0
					,@UserId = @UserId 
					,@Status = @Status  Output
			
					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishSearchWidgetEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
					
					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 55  ,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			
			END 

			if (@Type = 'ZnodePublishContentPageConfigEntity' OR @Type = '') AND @Status = 1
			Begin
				 EXEC [dbo].[Znode_SetPublishContentPageConfigEntity]
					 @PortalId  = @PortalId 
					,@LocaleId   = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = @PreviewVersionId 
					,@ProductionVersionId = @ProductionVersionId 
					,@RevisionState = @RevisionState 
					,@CMSContentPagesId = 0
					,@UserId = @UserId	
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishContentPageConfigEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
					
					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 60,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			
			End

			if (@Type = 'ZnodePublishSEOEntity' OR @Type = '') AND @Status = 1
			Begin
					Exec [Znode_SetPublishSEOEntity]
					 @PortalId  = @PortalId
					,@LocaleId  = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = 0 
					,@ProductionVersionId = 0
					,@RevisionState = @RevisionState 
					,@CMSSEOTypeId = '3,5'
					,@CMSSEOCode = ''
					,@UserId = @UserId  
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishSEOEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					
					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 60,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			

			End 
			if (@Type = 'ZnodePublishMessageEntity' OR @Type = '') AND @Status = 1
			Begin
					Exec [Znode_SetPublishMessageEntity]
					 @PortalId  = @PortalId
					,@LocaleId  = @LocaleId 
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = 0 
					,@ProductionVersionId = 0
					,@RevisionState = @RevisionState 
					,@UserId = @UserId  
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishMessageEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 65,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			

			End 

		   if (@Type = 'ZnodePublishPortalGlobalAttributeEntity' OR @Type = '') AND @Status = 1
			Begin
					Exec [Znode_SetPublishPortalGlobalAttributeEntity]
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = 0 
					,@ProductionVersionId = 0
					,@RevisionState = @RevisionState 
					,@UserId = @UserId  
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishPortalGlobalAttributeEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
					
					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 67,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			

			End 
 
		   if (@Type = 'ZnodePublishProductPageEntity' OR @Type = '') AND @Status = 1
			Begin
					Exec [Znode_SetPublishProductPageEntity]
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = 0 
					,@ProductionVersionId = 0
					,@RevisionState = @RevisionState 
					,@UserId = @UserId  
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishProductPageEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 73,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			


			End 
			
			if (@Type = 'ZnodePublishWidgetBrandEntity' OR @Type = '') AND @Status = 1
			Begin
					Exec [Znode_SetPublishWidgetBrandEntity]
					 @PortalId  = @PortalId
					,@IsPreviewEnable =@IsPreviewEnable 
					,@PreviewVersionId  = 0 
					,@ProductionVersionId = 0
					,@RevisionState = @RevisionState 
					,@UserId = @UserId  
					,@Status = @Status Output 

					INSERT INTO ZnodePublishPortalErrorLogEntity
					(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
					SELECT 'ZnodePublishWidgetBrandEntity', @RevisionState, Case when Isnull(@Status,0) = 0 then 'Fail' Else 'Success' end , Getdate(), 
					@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

					Update ZnodePublishProgressNotifierEntity SET 
					ProgressMark = 80,
					IsCompleted  = Case when Isnull(@Status,0) = 0 then 1  Else 0 end,
					IsFailed =Case when Isnull(@Status,0) = 0 then 1  Else 0 end  
					where  JobId = @NewGUID			

			End 
	End
		IF Exists (select TOP 1 1  from ZnodePublishPortalErrorLogEntity where  ProcessStatus = 'Fail') 
		Begin
			SET @Status  =0 
			SELECT 1 AS ID,@Status AS Status;
			INSERT INTO ZnodePublishPortalErrorLogEntity
			(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
			SELECT 'ZnodePublishPortalEntity', @RevisionState , 'Fail' , Getdate(), 
			@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 
			Update ZnodePublishPortalLog SET PublishStateId = DBO.Fn_GetPublishStateIdForPublishFailed()  where  PublishPortalLogId in  (Select VersionId from #Tbl_VersionEntity Where PublishType = 'PREVIEW' )
			Update ZnodePublishPortalLog SET PublishStateId = DBO.Fn_GetPublishStateIdForPublishFailed()  where  PublishPortalLogId in (Select VersionId from #Tbl_VersionEntity Where PublishType = 'PRODUCTION' )

			Delete  From ZnodePublishWebStoreEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId
			Delete  From ZnodePublishBlogNewsEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishPortalCustomCssEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishWidgetCategoryEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishWidgetProductEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishWidgetTitleEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishWidgetSliderBannerEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishTextWidgetEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishMediaWidgetEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishSearchWidgetEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishContentPageConfigEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishSEOEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId and CMSSEOTypeId in (3,5)
			Delete  From ZnodePublishMessageEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishPortalGlobalAttributeEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishPortalBrandEntity Where  VersionId  in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishProductPageEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
			Delete  From ZnodePublishWidgetBrandEntity Where  VersionId in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
		End
	Else 
		Begin
			Update ZnodePublishPortalLog SET PublishStateId = DBO.Fn_GetPublishStateIdForPreview()  where  PublishPortalLogId in 
			(Select VersionId from #Tbl_VersionEntity Where PublishType = 'PREVIEW' )
			Update ZnodePublishPortalLog SET PublishStateId = DBO.Fn_GetPublishStateIdForPublish()  where  PublishPortalLogId in
			(Select VersionId from #Tbl_VersionEntity Where PublishType = 'PRODUCTION' )
			 
			Insert into ZnodePublishPreviewLogEntity
			(VersionId,PublishStartTime,IsDisposed,SourcePublishState,EntityId,EntityType,LogMessage,LogCreatedDate,PreviousVersionId,LocaleId,LocaleDisplayValue)
				Select A.VersionId,NULL,NULL,A.PublishType,@PortalId,'portal','portal has been published successfully' , Getdate(),  
				(select TOP 1 VersionId   from ZnodePublishWebStoreEntity where LocaleId = A.LocaleId AND PublishState = A.PublishType
				 and PortalId = @PortalId),A.LocaleId,B.Name
				from #Tbl_VersionEntity  A  Inner join ZnodeLocale B on A.LocaleId = B.LocaleId

			If @RevisionState = 'PREVIEW'
			Begin
				update ZnodeCMSContentPages SET  IsPublished = 1 , PublishStateId  = DBO.Fn_GetPublishStateIdForPreview() where (PortalId = @PortalId OR @PortalId  =0 ) 
				update ZnodeCMSSEODEtail SET  IsPublish = 1 , PublishStateId  = DBO.Fn_GetPublishStateIdForPreview() where 
				(PortalId = @PortalId OR @PortalId  =0 )  AND CMSSEOTypeId = 3 
			End 
			Else 
			Begin
				update ZnodeCMSContentPages SET  IsPublished = 1 , PublishStateId  = DBO.Fn_GetPublishStateIdForPublish() where (PortalId = @PortalId OR @PortalId  =0 ) 
				update ZnodeCMSSEODEtail SET  IsPublish = 1 , PublishStateId  = DBO.Fn_GetPublishStateIdForPublish() where 
				(PortalId = @PortalId OR @PortalId  =0 )  AND CMSSEOTypeId = 3 
			End
			
			if (@IsContentType =1  OR (@IsContentType = 0 AND @IsFirstTimeContentPublish =0))
			Begin
				If @IsPreviewEnable = 1 AND (@RevisionState like '%Preview%'  OR @RevisionState like '%Production%'  ) 
				Begin
					Delete  From ZnodePublishWebStoreEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishBlogNewsEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishPortalCustomCssEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetCategoryEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetProductEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetTitleEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetSliderBannerEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishTextWidgetEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishMediaWidgetEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishSearchWidgetEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishContentPageConfigEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishSEOEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId) And CMSSEOTypeId in (3,5) 
					Delete  From ZnodePublishMessageEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishPortalGlobalAttributeEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishPortalBrandEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishProductPageEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetBrandEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
				End
				If (@RevisionState like '%Production%' OR @RevisionState = 'None')
				Begin
					Delete  From ZnodePublishWebStoreEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishBlogNewsEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishPortalCustomCssEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetCategoryEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetProductEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetTitleEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetSliderBannerEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishTextWidgetEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishMediaWidgetEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishSearchWidgetEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishContentPageConfigEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishSEOEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId) And CMSSEOTypeId in (3,5) 
					Delete  From ZnodePublishMessageEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishPortalGlobalAttributeEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishPortalBrandEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishProductPageEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					Delete  From ZnodePublishWidgetBrandEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
				End
			End
			Else 
			Begin
				
				If @IsPreviewEnable = 1 AND (@RevisionState like '%Preview%'  OR @RevisionState like '%Production%'  ) 
				Begin
					Delete  From ZnodePublishWebStoreEntity           Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Delete  From ZnodePublishPortalBrandEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
				
					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishBlogNewsEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishPortalCustomCssEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					
					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetCategoryEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetProductEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetTitleEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetSliderBannerEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishTextWidgetEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishMediaWidgetEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishSearchWidgetEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId =6)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishContentPageConfigEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishSEOEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
					And CMSSEOTypeId in (3,5) 

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishMessageEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishPortalGlobalAttributeEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishProductPageEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetBrandEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PRODUCTION' AND PortalId = @PortalId)
				End
				If (@RevisionState like '%Production%' OR @RevisionState = 'None')
				Begin
					Delete  From ZnodePublishWebStoreEntity           Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Delete  From ZnodePublishPortalBrandEntity Where  VersionId not in (Select VersionId from #Tbl_VersionEntity) AND PortalId = @PortalId 
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
				
					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishBlogNewsEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishPortalCustomCssEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					
					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetCategoryEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetProductEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetTitleEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetSliderBannerEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishTextWidgetEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishMediaWidgetEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishSearchWidgetEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishContentPageConfigEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishSEOEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
					And CMSSEOTypeId in (3,5)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishMessageEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishPortalGlobalAttributeEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishProductPageEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)

					Update BA SET BA.VersionId = OV.NewVersionId from 
					ZnodePublishWidgetBrandEntity BA Inner join #Tbl_OldVersionEntity  OV on BA.VersionId = Ov.OldVersionId  AND BA.PortalId =Ov.PortalId  
					AND VersionId NOT IN (select VersionId  from ZnodePublishWebStoreEntity where PublishState = 'PREVIEW' AND PortalId = @PortalId)
				End 
			End

			--update ZnodeCMSContentPages SET  IsPublished = 1 , PublishStateId  = DBO.Fn_GetPublishStateIdForPublish() where @CMSContentPagesId = CMSContentPagesId and  (PortalId = @PortalId OR @PortalId  =0 ) 
			--update ZnodeCMSSEODEtail SET  IsPublish = 1 , PublishStateId  = DBO.Fn_GetPublishStateIdForPublish() where 
			--SEOCode = @CMSSEOCode and  (PortalId = @PortalId OR @PortalId  =0 )  AND CMSSEOTypeId = 3 
		 SET @Status = 1
		End
	SELECT 1 AS ID,@Status AS Status;   

END TRY 
BEGIN CATCH 
	SET @Status =0  
	 SELECT 1 AS ID,@Status AS Status;   

	 DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
		@ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_PublishPortalEntity 
		@PortalId = '+CAST(@PortalId AS VARCHAR	(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10))
		+',@PreviewVersionId = ' + CAST(@PreviewVersionId  AS varchar(20))
		+',@ProductionVersionId = ' + CAST(@ProductionVersionId  AS varchar(20))
		+',@RevisionState = ''' + CAST(@RevisionState  AS varchar(50))
		+',@UserId = ' + CAST(@UserId AS varchar(20));	SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
	
			
	INSERT INTO ZnodePublishPortalErrorLogEntity
	(EntityName,ErrorDescription,ProcessStatus,CreatedDate,CreatedBy,VersionId)
	SELECT 'ZnodePublishPortalEntity', @RevisionState + isnull(@ErrorMessage,'') , 'Fail' , Getdate(), 
	@UserId , Convert( varchar(100), @PreviewVersionId) + '/' + Convert( varchar(100), @ProductionVersionId) 

		                			 
	EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'Znode_PublishPortalEntity',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;
END CATCH
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_SetPublishSEOEntity')
	drop proc Znode_SetPublishSEOEntity
go


CREATE PROCEDURE [dbo].[Znode_SetPublishSEOEntity]
(
   @PortalId  INT = 0 
  ,@LocaleId  INT = 0 
  ,@IsPreviewEnable int = 0 
  ,@PreviewVersionId INT = 0 
  ,@ProductionVersionId INT = 0 
  ,@RevisionState varchar(50) = '' 
  ,@CMSSEOTypeId varchar(500) = '' 
  ,@CMSSEOCode varchar(300) = ''
  ,@UserId int = 0 
  ,@Status int OUTPUT 
  ,@IsCatalogPublish bit = 0 
  ,@VersionIdString varchar(300) = ''
  ,@IsSingleProductPublish bit = 0 
)
AS
/*
    This Procedure is used to publish the blog news against the store 
  
	EXEC ZnodeSetPublishSEOEntity 1 2,3
	A. 
		1. Preview - Preview
		2. None    - Production   --- 
		3. Production - Preview/Production
	B.
		select * from ZnodePublishStateApplicationTypeMapping
		select * from ZnodePublishState where PublishStateId in (3,4) 
		select * from ZnodePublishPortalLog 
	C.
		Select * from ZnodePublishState where IsDefaultContentState = 1  and IsContentState = 1  --Production 
    
	Unit testing 
	
	Exec [ZnodeSetPublishSEOEntity]
	   @PortalId  = 1 
	  ,@LocaleId  = 0 
	  ,@PreviewVersionId = 0 
	  ,@ProductionVersionId = 0 
	  ,@RevisionState = 'Preview/Production' 
	  ,@CMSSEOTypeId = 0
	  ,@CMSSEOCode = ''
	  ,@UserId = 0 

	 Exec [ZnodeSetPublishSEOEntity]
   @PortalId  = 1 
  ,@LocaleId  = 0 
  ,@PreviewVersionId = 0 
  ,@ProductionVersionId = 0 
  ,@RevisionState = 'Preview&Production' 
  ,@CMSSEOTypeId = 3
  ,@CMSSEOCode = ''
  ,@UserId = 0 




	
	*/
BEGIN 
BEGIN TRY 
SET NOCOUNT ON
   Begin 
		DECLARE @Tbl_PreviewVersionId    TABLE    (PreviewVersionId int , PortalId int , LocaleId int)
		DECLARE @Tbl_ProductionVersionId TABLE    (ProductionVersionId int  , PortalId int , LocaleId int)
		If (@IsCatalogPublish = 0  AND @IsSingleProductPublish = 0 )
		Begin
			If @PreviewVersionId = 0 
				Begin
   					Insert into @Tbl_PreviewVersionId 
					SELECT distinct VersionId , PortalId, LocaleId from  ZnodePublishWebStoreEntity where (PortalId = @PortalId or @PortalId=0 ) and  (LocaleId = 	@LocaleId OR @LocaleId = 0  ) and PublishState ='PREVIEW'
				end
			Else 
					Insert into @Tbl_PreviewVersionId SELECT distinct VersionId , PortalId, LocaleId from  ZnodePublishWebStoreEntity 
					where VersionId = @PreviewVersionId
			If @ProductionVersionId = 0 
   				Begin
					Insert into @Tbl_ProductionVersionId 
					SELECT distinct VersionId , PortalId , LocaleId from  ZnodePublishWebStoreEntity where (PortalId = @PortalId or @PortalId=0 ) and  (LocaleId = 	@LocaleId OR @LocaleId = 0  ) and PublishState ='PRODUCTION'
				End 
			Else 
				Insert into @Tbl_ProductionVersionId SELECT distinct VersionId , PortalId, LocaleId from  ZnodePublishWebStoreEntity 
				where VersionId = @ProductionVersionId
 		End
		Else if (@IsCatalogPublish= 1  AND @IsSingleProductPublish = 0 )
		Begin
			 IF OBJECT_ID('tempdb..#VesionIds') is not null
				DROP TABLE #VesionIds
  				 
			 SELECT PV.* into #VesionIds FROM ZnodePublishVersionEntity PV Inner join Split(@VersionIdString,',') S ON PV.VersionId = S.Item
		End
		
		DECLARE @SetLocaleId INT , @DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleId(), @MaxCount INT =0 , @IncrementalId INT = 1  
		DECLARE @TBL_Locale TABLE (LocaleId INT , RowId INT IDENTITY(1,1))
		DECLARE @TBL_SEO TABLE 
		(
			ItemName varchar(50),CMSSEODetailId int ,CMSSEODetailLocaleId int ,CMSSEOTypeId int ,SEOId int ,SEOTypeName varchar(50),SEOTitle nvarchar(Max)
			,SEODescription nvarchar(Max),
			SEOKeywords nvarchar(Max),SEOUrl nvarchar(Max) ,IsRedirect bit ,MetaInformation nvarchar(Max) ,LocaleId int ,
			OldSEOURL nvarchar(Max),CMSContentPagesId int ,PortalId int ,SEOCode varchar(300) ,CanonicalURL varchar(200),RobotTag varchar(50)
		)
		
		BEGIN 
			INSERT INTO @TBL_Locale (LocaleId) SELECT LocaleId FROM ZnodeLocale WHERE IsActive =1 AND (LocaleId  = @LocaleId OR @LocaleId = 0 )
			
			SET @MaxCount = ISNULL((SELECT MAx(RowId) FROM @TBL_Locale),0)
			WHILE @IncrementalId <= @MaxCount
			BEGIN 
				SET @SetLocaleId = (SELECT Top 1 LocaleId FROM @TBL_locale WHERE RowId = @IncrementalId)
				IF @IsSingleProductPublish = 0
				Begin
					;With Cte_GetCMSSEODetails AS 
					(
							select CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
								 CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
								 CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
								 CDL.LocaleId,
								 NULL OldSEOURL, 
								 NULL CMSContentPagesId,ZPB.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
								 from ZnodeCMSSEODetail CD 
								 INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
								 INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId
								 INNER JOIN ZnodeBrandDetails ZBD ON CD.SeoCode = ZBD.BrandCode
								 INNER JOIN ZnodePortalBrand ZPB ON ZBD.BrandId = ZPB.BrandId
								 WHERE (CDL.LocaleId = @SetLocaleId OR CDL.LocaleId = @DefaultLocaleId)  
								 AND (ZPB.PortalId = @PortalId  OR @PortalId  = 0 ) 
								 AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
								 AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CD.CMSSEOTypeId ) )
							 Union All 
							 select CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
								 CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
								 CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
								 CDL.LocaleId,
								 NULL OldSEOURL, 
								 NULL CMSContentPagesId,ZPB.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
								 from ZnodeCMSSEODetail CD 
								 INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
								 INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId 
								 INNER JOIN ZnodeBrandDetails ZBD ON CD.SeoCode = ZBD.BrandCode
								 INNER JOIN ZnodePortalBrand ZPB ON ZBD.BrandId = ZPB.BrandId
								 WHERE (CDL.LocaleId = @SetLocaleId OR CDL.LocaleId = @DefaultLocaleId)  
								 AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
								 AND (CT.Name = 'Brand' ) 
								 AND @IsCatalogPublish= 1 
					)
					, Cte_GetFirstCMSSEODetails  AS
					(
						SELECT 
							ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
							SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation, LocaleId ,OldSEOURL,CMSContentPagesId,
							PortalId,SEOCode,CanonicalURL,RobotTag	
						FROM Cte_GetCMSSEODetails 
						WHERE LocaleId = @SetLocaleId
					)
					, Cte_GetDefaultFilterData AS
					(
						SELECT 
							ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
							SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
							PortalId,SEOCode,CanonicalURL,RobotTag	  FROM  Cte_GetFirstCMSSEODetails 
						UNION ALL 
						SELECT 
							ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
							SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
							PortalId,SEOCode,CanonicalURL,RobotTag	 FROM Cte_GetCMSSEODetails CTEC 
						WHERE LocaleId = @DefaultLocaleId 
						AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetFirstCMSSEODetails CTEFD WHERE CTEFD.CMSSEOTypeId = CTEC.CMSSEOTypeId 
						and CTEFD.seoCode = CTEC.seoCode )
					)
	
					INSERT INTO @TBL_SEO (ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
					SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
					PortalId,SEOCode,CanonicalURL,RobotTag)
					SELECT 
						ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
						SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,@SetLocaleId,OldSEOURL,CMSContentPagesId,
						PortalId,SEOCode,CanonicalURL,RobotTag	
					FROM Cte_GetDefaultFilterData  A 

					End 
					Else If @IsSingleProductPublish = 1  
						INSERT INTO @TBL_SEO (ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
						SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
						PortalId,SEOCode,CanonicalURL,RobotTag)
							SELECT CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
							CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
							CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
							CDL.LocaleId,
							NULL OldSEOURL, 
							NULL CMSContentPagesId,CD.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
							from ZnodeCMSSEODetail CD 
							INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
							INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId 
							WHERE (CDL.LocaleId = @LocaleId )  
							AND (CD.PortalId = @PortalId  ) 
							AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
							AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CD.CMSSEOTypeId ) )

				SET @IncrementalId = @IncrementalId +1 
			END 
		End 
		End			

	If @IsPreviewEnable = 1 AND (@RevisionState like '%Preview%' OR  @RevisionState like '%Production%')  AND @IsSingleProductPublish = 0
	Begin
	    --Data inserted into flat table ZnodePublishSeoEntity (Replica of MongoDB Collection )  
		Delete from ZnodePublishSeoEntity where PortalId = @PortalId  and VersionId  in (Select PreviewVersionId  from @TBL_PreviewVersionId ) 
		AND (SEOCode = @CMSSEOCode OR @CMSSEOCode = '' )
		AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CMSSEOTypeId ) )
		AND @IsCatalogPublish= 0   

		If @IsCatalogPublish= 0
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
				PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.PreviewVersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join @TBL_PreviewVersionId B on A.PortalId = B.PortalId and A.LocaleId = B.LocaleId

		If @IsCatalogPublish= 1 
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
				PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.VersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join #VesionIds B on A.LocaleId = B.LocaleId Where B.RevisionType = 'PREVIEW'

	End

	-------------------------- End Preview 
	If (@RevisionState like '%Production%' OR @RevisionState = 'None') and @IsSingleProductPublish = 0
	Begin
		-- Only production version id will process 
		Delete from ZnodePublishSeoEntity where PortalId = @PortalId  and VersionId in (Select ProductionVersionId from  @TBL_ProductionVersionId ) 
		AND (SEOCode = @CMSSEOCode OR @CMSSEOCode = '' )
		AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CMSSEOTypeId ) )
		AND @IsCatalogPublish= 0   

		If @IsCatalogPublish= 0 				
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL
				,CMSContentPagesId,	PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.ProductionVersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join @TBL_ProductionVersionId B on A.PortalId = B.PortalId and A.LocaleId = B.LocaleId
	   If @IsCatalogPublish= 1 				
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL
				,CMSContentPagesId,	PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.VersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join #VesionIds B on A.LocaleId = B.LocaleId AND B.RevisionType = 'PRODUCTION'
	
	End

	--Single Product Publish 
	If @IsSingleProductPublish =1  
	Begin
			Delete from ZnodePublishSeoEntity where PortalId = @PortalId  and VersionId in (Select Item from Split(@VersionIdString,',')) 
			AND (SEOCode = @CMSSEOCode OR @CMSSEOCode = '' )
			AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CMSSEOTypeId ) )
		
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL
				,CMSContentPagesId,	PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT (Select Item from Split(@VersionIdString,',')), Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,@LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A 
		
	end 
			If (@RevisionState = 'Preview'  )
			Update B SET PublishStateId = (select dbo.Fn_GetPublishStateIdForPreview()) , ISPublish = 1 
			from @TBL_SEO  A inner join ZnodeCMSSEODetail B  ON A.CMSSEODetailId  = B.CMSSEODetailId
			else If (@RevisionState = 'Production'  Or @RevisionState = 'None' )
			Update B SET PublishStateId = (select dbo.Fn_GetPublishStateIdForPublish()) , ISPublish = 1 
			from @TBL_SEO  A inner join ZnodeCMSSEODetail B  ON A.CMSSEODetailId  = B.CMSSEODetailId
	SET @Status =1 
END TRY 
BEGIN CATCH 
	SET @Status =0  
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeSetPublishSEOEntity 
	@PortalId = '+CAST(@PortalId AS VARCHAR	(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10))
	+',@PreviewVersionId = ' + CAST(@PreviewVersionId  AS varchar(20))
	+',@ProductionVersionId = ' + CAST(@ProductionVersionId  AS varchar(20))
	+',@RevisionState = ''' + CAST(@RevisionState  AS varchar(50))
	+''',@CMSSEOTypeId= ' + CAST(@CMSSEOTypeId  AS varchar(20))
	+',@UserId = ' + CAST(@UserId AS varchar(20))
	+',@CMSSEOCode  = ''' + CAST(@CMSSEOCode  AS varchar(20)) + '''';
	        			 
	SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
	EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'ZnodeSetPublishSEOEntity',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;

END CATCH
END

go
	
  IF exists(select * from sys.procedures where name = 'Znode_ImportCatalogCategory')
	drop proc Znode_ImportCatalogCategory
go
CREATE PROCEDURE [dbo].[Znode_ImportCatalogCategory](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @PimCatalogId int= 0)
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import Catalog Category Product association
	
	-- Unit Testing : 
	--BEGIN TRANSACTION;
	--update ZnodeGlobalSetting set FeatureValues = '5' WHERE FeatureName = 'InventoryRoundOff' 
	--    DECLARE @status INT;
	--    EXEC [Znode_ImportInventory] @InventoryXML = '<ArrayOfImportInventoryModel>
	-- <ImportInventoryModel>
	--   <SKU>S1002</SKU>
	--   <Quantity>999998.33</Quantity>
	--   <ReOrderLevel>10</ReOrderLevel>
	--   <RowNumber>1</RowNumber>
	--   <ListCode>TestInventory</ListCode>
	--   <ListName>TestInventory</ListName>
	-- </ImportInventoryModel>
	--</ArrayOfImportInventoryModel>' , @status = @status OUT , @UserId = 2;
	--    SELECT @status;
	--    ROLLBACK TRANSACTION;
	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max);
		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive RoundOff Value from global setting 
		DECLARE @InsertCatalogCategory TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, SKU varchar(300), CategoryCode varchar(200), DisplayOrder int, IsActive varchar(10), GUID nvarchar(400)
			--,Index Ind_SKU1 (SKU),Index Ind_CategoryName (CategoryName)
		);

		DECLARE @CategoryAttributId int;

		SET @CategoryAttributId =
		(
			SELECT TOP 1 PimAttributeId
			FROM ZnodePimAttribute AS ZPA
			WHERE ZPA.AttributeCode = 'CategoryCode' AND 
				  ZPA.IsCategory = 1
		);

		DECLARE @InventoryListId int;

		SET @SSQL = 'Select RowNumber,SKU,CategoryCode,DisplayOrder ,IsActive,GUID FROM '+@TableName;
		INSERT INTO @InsertCatalogCategory( RowNumber, SKU, CategoryCode, DisplayOrder, IsActive, GUID )
		EXEC sys.sp_sqlexec @SSQL;

		----Removing Duplicate data
		;with cte as
		(
			select SKU, CategoryCode,max(RowNumber) as RowNumber from @InsertCatalogCategory
			group by SKU, CategoryCode
		)
		delete a from @InsertCatalogCategory a
		where  not exists (select * from CTE b where a.RowNumber = b.RowNumber )

		--@MessageDisplay will use to display validate message for input inventory value  
		DECLARE @SKU TABLE
		( 
		   SKU nvarchar(300), PimProductId INT--, Index Ins_SKU (SKU)
		);
		INSERT INTO @SKU
			   SELECT b.AttributeValue, a.PimProductId
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;

		Declare @PimCategoryAttributeId int 
		set @PimCategoryAttributeId = (select top 1 PimAttributeId from ZnodePimAttribute where AttributeCode = 'CategoryCode')

		DECLARE @CategoryCode TABLE
		( 
			CategoryCode nvarchar(300), PimCategoryId int --index ind_101 (CategoryName)
		);
		INSERT INTO @CategoryCode
			   SELECT ZPCAL.CategoryValue, ZPCA.PimCategoryId
			   FROM ZnodePimCategoryAttributeValue AS ZPCA
					INNER JOIN
					ZnodePimCategoryAttributeValueLocale AS ZPCAL
					ON ZPCA.PimAttributeId = @PimCategoryAttributeId AND 
					ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId;
					
		-- start Functional Validation 
		
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertCatalogCategory AS ii
			   WHERE ii.SKU NOT in 
			   (
				   SELECT SKU FROM @SKU  where SKU IS NOT NULL 
			   );
		
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'CategoryCode', CategoryCode, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertCatalogCategory AS ii
			   WHERE ii.CategoryCode NOT IN 
			   (
				   SELECT CategoryCode FROM @CategoryCode  where CategoryCode IS NOT NULL 
			   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			SELECT '17', 'DisplayOrder', DisplayOrder, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			FROM @InsertCatalogCategory AS ii
			WHERE (ii.DisplayOrder <> '' OR ii.DisplayOrder IS NOT NULL )AND  ii.DisplayOrder = 0

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			SELECT '64', 'DisplayOrder', DisplayOrder, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			FROM @InsertCatalogCategory AS ii
			WHERE (ii.DisplayOrder <> '' OR ii.DisplayOrder IS NOT NULL )AND  ii.DisplayOrder > 999

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
		  SELECT '35', 'IsActive', IsActive, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
		  FROM @InsertCatalogCategory AS ii  
		  WHERE ii.IsActive not in ('True','1','Yes','FALSE','0','No')

		UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ CategoryCode - ' + ISNULL(CategoryCode,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN @InsertCatalogCategory IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL


		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  
		DELETE FROM @InsertCatalogCategory
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  AND RowNumber IS NOT NULL 
			--AND GUID = @NewGUID
		);

	
		
			  Declare @ZnodePimCategoryProduct TABLE (PimProductId int , PimCategoryId int , Status bit , DisplayOrder int) 
			  	
			  insert into @ZnodePimCategoryProduct (PimProductId , PimCategoryId , Status , DisplayOrder )
			  SELECT SKU.PimProductId, (Select top 1 PimCategoryId from @CategoryCode where ICC.CategoryCode = CategoryCode )  PimCategoryId
				 , CASE WHEN IsActive in ('True','1','Yes') Then 1 ELSE 0 END , DisplayOrder FROM @InsertCatalogCategory AS ICC INNER JOIN	 @SKU AS SKU ON ICC.SKU = SKU.SKU 
			
			  INSERT into ZnodePimCategoryProduct ( PimProductId, PimCategoryId, Status, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
			  Select TABL.PimProductId, TABL.PimCategoryId, TABL.Status, TABL.DisplayOrder,@UserId, @GetDate, @UserId, @GetDate   from @ZnodePimCategoryProduct TABL    
			  Where NOT EXISTS (Select top 1 1 from ZnodePimCategoryProduct ZPCP where ZPCP.PimProductId = TABL.PimProductId and  ZPCP.PimCategoryId = TABL.PimCategoryId)

		
		-- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertCatalogCategory
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount, TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0))
		WHERE ImportProcessLogId = @ImportProcessLogId;
												 
		--select 'End'
		--      SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;

		COMMIT TRAN A;
	END TRY
	BEGIN CATCH

		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 3 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;

		SET @Status = 0;
		SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE();
		ROLLBACK TRAN A;
	END CATCH;
END;

go
insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select 'Number','EmailOptIn',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Yes/No','AllowNegative',	NULL,	'false',' '	,	NULL,	2,getdate(),2,getdate(),15
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EmailOptIn' 
      and ControlName = 'Yes/No' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'AllowNegative')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select'Number','EmailOptIn',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Yes/No','AllowDecimals',	NULL,	'false',' ',		NULL,	2,getdate(),2,getdate(),15
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EmailOptIn' 
      and ControlName = 'Yes/No' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'AllowDecimals')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select'Number','EmailOptIn',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Number','MinNumber',	NULL,	0	,'',	NULL,	2,getdate(),2,getdate(),15
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EmailOptIn' 
      and ControlName = 'Number' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'MinNumber')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)  
select 'Number','EmailOptIn',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Number','MaxNumber',	NULL,	999999,'',		NULL,	2,getdate(),2,getdate(),15
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EmailOptIn' 
      and ControlName = 'Number' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'MaxNumber')


insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select 'Text','PerOrderAnnualLimit',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Text','RegularExpression',	NULL,'',	'',		NULL,	2,getdate(),2,getdate(),16
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Text' and AttributeCode = 'PerOrderAnnualLimit' 
      and ControlName = 'Text' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'RegularExpression')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)  
select 'Text','BillingAccountNumber',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Text','RegularExpression',	NULL,'',	'',		NULL,	2,getdate(),2,getdate(),17
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Text' and AttributeCode = 'BillingAccountNumber' 
      and ControlName = 'Text' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'RegularExpression')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select 'Text','EnableUserShippingAddressSuggestion',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Text','RegularExpression',	NULL,'',	'',		NULL,	2,getdate(),2,getdate(),18
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Text' and AttributeCode = 'EnableUserShippingAddressSuggestion' 
      and ControlName = 'Text' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'RegularExpression')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select 'Number','EnablePowerBIReportOnWebStore',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Yes/No','AllowNegative',	NULL,	'false'	,' '	,	NULL,	2,getdate(),2,getdate(),19
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EnablePowerBIReportOnWebStore' 
      and ControlName = 'Yes/No' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'AllowNegative')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)   
select 'Number','EnablePowerBIReportOnWebStore',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Yes/No','AllowDecimals',	NULL,	'false',' '	,		NULL,	2,getdate(),2,getdate(),19
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EnablePowerBIReportOnWebStore' 
      and ControlName = 'Yes/No' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'AllowDecimals')
insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select 'Number','EnablePowerBIReportOnWebStore',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Number','MinNumber',	NULL,	0	,' '	,	NULL,	2,getdate(),2,getdate(),19
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EnablePowerBIReportOnWebStore' 
      and ControlName = 'Number' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'MinNumber')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)  
select 'Number','EnablePowerBIReportOnWebStore',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Number','MaxNumber',	NULL,	999999,' '	,		NULL,	2,getdate(),2,getdate(),19
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'EnablePowerBIReportOnWebStore' 
      and ControlName = 'Number' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'MaxNumber')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber) 
select 'Text','PerOrderLimit',	(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer'),	0,	'Text','RegularExpression',	NULL,'',	'',		NULL,	2,getdate(),2,getdate(),20
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Text' and AttributeCode = 'PerOrderLimit' 
      and ControlName = 'Text' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Customer')
	  and ValidationName = 'RegularExpression')

	
go
INSERT ZnodeImportTemplateMapping(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') ,'EnablePowerBIReportOnWebStore','EnablePowerBIReportOnWebStore',0,1,1,2,getdate(),2,getdate()
WHERE NOT EXISTS(SELECT * FROM ZnodeImportTemplateMapping WHERE ImportTemplateId=(select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') 
	AND SourceColumnName ='EnablePowerBIReportOnWebStore')

INSERT ZnodeImportTemplateMapping(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') ,'EnableUserShippingAddressSuggestion','EnableUserShippingAddressSuggestion',0,1,1,2,getdate(),2,getdate()
WHERE NOT EXISTS(SELECT * FROM ZnodeImportTemplateMapping WHERE ImportTemplateId=(select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') 
	AND SourceColumnName ='EnableUserShippingAddressSuggestion')

INSERT ZnodeImportTemplateMapping(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') ,'BillingAccountNumber','BillingAccountNumber',0,1,1,2,getdate(),2,getdate()
WHERE NOT EXISTS(SELECT * FROM ZnodeImportTemplateMapping WHERE ImportTemplateId=(select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') 
	AND SourceColumnName ='BillingAccountNumber')


INSERT ZnodeImportTemplateMapping(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') ,'PerOrderAnnualLimit','PerOrderAnnualLimit',0,1,1,2,getdate(),2,getdate()
WHERE NOT EXISTS(SELECT * FROM ZnodeImportTemplateMapping WHERE ImportTemplateId=(select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') 
	AND SourceColumnName ='PerOrderAnnualLimit')


INSERT ZnodeImportTemplateMapping(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') ,'PerOrderLimit','PerOrderLimit',0,1,1,2,getdate(),2,getdate()
WHERE NOT EXISTS(SELECT * FROM ZnodeImportTemplateMapping WHERE ImportTemplateId=(select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'CustomerTemplate') 
	AND SourceColumnName ='PerOrderLimit')

go
	
  IF exists(select * from sys.procedures where name = 'Znode_ImportCustomer')
	drop proc Znode_ImportCustomer
go

CREATE PROCEDURE [dbo].[Znode_ImportCustomer](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @LocaleId int= 0,@PortalId int ,@CsvColumnString nvarchar(max))
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import SEO Details
	
	-- Unit Testing : 
	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max),@AspNetZnodeUserId nvarchar(256),@ASPNetUsersId nvarchar(256),
		@PasswordHash nvarchar(max),@SecurityStamp nvarchar(max),@RoleId nvarchar(256),@IsAllowGlobalLevelUserCreation nvarchar(10)
		Declare @ProfileId  int
		DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		 
		SET @SecurityStamp = '0wVYOZNK4g4kKz9wNs-UHw2'
		SET @PasswordHash = 'APy4Tm1KbRG6oy7h3r85UDh/lCW4JeOi2O2Mfsb3OjkpWTp1YfucMAvvcmUqNaSOlA==';
		SELECT  @RoleId  = Id from AspNetRoles where   NAME = 'Customer'  

		Select @IsAllowGlobalLevelUserCreation = FeatureValues from ZnodeGlobalsetting where FeatureName = 'AllowGlobalLevelUserCreation'

		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive RoundOff Value from global setting 

		-- Three type of import required three table varible for product , category and brand
		DECLARE @InsertCustomer TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, UserName nvarchar(512) ,FirstName	nvarchar(200),
			LastName nvarchar(200), BudgetAmount	numeric,Email	nvarchar(100),PhoneNumber	nvarchar(100),
		    EmailOptIn	bit	,ReferralStatus	nvarchar(40),IsActive	bit	,ExternalId	nvarchar(max),CreatedDate Datetime,
			ProfileName varchar(200),AccountCode nvarchar(100),DepartmentName varchar(300),RoleName nvarchar(256), GUID NVARCHAR(400)
			,PerOrderLimit int,
				PerOrderAnnualLimit nvarchar(100),
				BillingAccountNumber nvarchar(100),
				EnableUserShippingAddressSuggestion  nvarchar(100),
				EnablePowerBIReportOnWebStore bit
		);

			--SET @SSQL = 'SELECT RowNumber,UserName,FirstName,LastName,BudgetAmount,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId,GUID FROM '+ @TableName;
		SET @SSQL = 'SELECT RowNumber,' + @CsvColumnString + ',GUID FROM '+ @TableName;
		INSERT INTO @InsertCustomer( RowNumber,UserName,FirstName,LastName,Email,PhoneNumber, EmailOptIn,IsActive,ExternalId,CreatedDate,ProfileName,AccountCode,DepartmentName,RoleName 
										,PerOrderAnnualLimit
										,BillingAccountNumber
										,EnableUserShippingAddressSuggestion
										,EnablePowerBIReportOnWebStore
										,PerOrderLimit,GUID)
		EXEC sys.sp_sqlexec @SSQL;
		
		
		select TOP 1 @ProfileId   =  ProfileId from ZnodePortalprofile where Portalid = @Portalid and IsDefaultRegistedProfile=1
		If( Isnull(@ProfileId ,0) = 0 ) 
		Begin
		
		
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '62', 'Default Portal Profile', '', @NewGUId, 1 , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
							
				UPDATE ZnodeImportProcessLog
				SET Status = dbo.Fn_GetImportStatus( 3 ), ProcessCompletedDate = @GetDate
				WHERE ImportProcessLogId = @ImportProcessLogId;
			

				SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog 
				WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
				Select @SuccessRecordCount = 0

				UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount , 
				TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0))
				WHERE ImportProcessLogId = @ImportProcessLogId;

				DELETE FROM @InsertCustomer 
				SET @Status = 0;

				COMMIT TRAN A;
				Return 0 
		End
	
	    -- start Functional Validation 

		-----------------------------------------------
		--If @IsAllowGlobalLevelUserCreation = 'false'
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			    WHERE ltrim(rtrim(ii.UserName)) in 
		--			   (
		--				   SELECT UserName FROM AspNetZnodeUser   where PortalId = @PortalId
		--			   );
		--Else 
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			   WHERE ltrim(rtrim(ii.UserName)) in 
		--			   (
		--				   SELECT UserName FROM AspNetZnodeUser   
		--			   );
		
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '35', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomer AS ii
					   WHERE ii.UserName not like '%_@_%_.__%' 
				
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '30', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomer AS ii
					   WHERE ltrim(rtrim(ii.UserName)) in 
					   (SELECT ltrim(rtrim(UserName))  FROM @InsertCustomer group by ltrim(rtrim(UserName))  having count(*) > 1 )

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				select '77', 'AccountCode', ii.AccountCode, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				from @InsertCustomer ii 
				where isnull(ltrim(rtrim(ii.AccountCode)),'') !='' 
				and not exists(select * from ZnodeAccount za inner join ZnodePortalAccount zpa on za.AccountId = zpa.AccountId
					where  isnull(ltrim(rtrim(ii.AccountCode)),'') = za.AccountCode and zpa.PortalId = @PortalId )
				and exists(SELECT isnull(ltrim(rtrim(AccountCode)),'') FROM ZnodeAccount za1 where isnull(ltrim(rtrim(ii.AccountCode)),'') = za1.AccountCode );

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '73', 'AccountCode', AccountCode, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE   isnull(ltrim(rtrim(ii.AccountCode)),'') !=''   and isnull(ltrim(rtrim(ii.AccountCode)),'') not in 
				(
					SELECT isnull(ltrim(rtrim(AccountCode)),'') FROM ZnodeAccount   
				);

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '88', 'AccountCode', AccountCode, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE   isnull(ltrim(rtrim(ii.AccountCode)),'') !='' and  exists
				(
					SELECT top 1 1 FROM  AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	 
				inner join ZnodeAccount ZA on  ZU.AccountId = ZA.AccountId
				where ANZU.UserName = ii.UserName and  ZA.AccountCode != ii.AccountCode
				);

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '92', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				where isnull(ltrim(rtrim(ii.RoleName)),'') <> '' and  isnull(ltrim(rtrim(ii.RoleName)),'') in ('User','Manager','Administrator')
				and exists(select * from ZnodeUser a INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
						inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
						--inner join @InsertCustomer IC on (IC.UserName = c.UserName)						
						inner join AspNetUserRoles u on u.UserId = b.Id
						inner join AspNetRoles ZD on u.RoleId = zd.Id
						where (ii.UserName = c.UserName) and isnull(ltrim(rtrim(ii.RoleName)),'') <> ZD.Name )

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '75', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE   isnull(ltrim(rtrim(ii.AccountCode)),'') ='' and isnull(ltrim(rtrim(RoleName)),'') <> '' 

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '74', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE --ltrim(rtrim(ii.RoleName)) not in ('User','Manager','Administrator') and isnull(ltrim(rtrim(RoleName)),'') <> '' and
				 isnull(ltrim(rtrim(RoleName)),'') <> '' and not exists (select top 1 1 from  AspNetRoles ANR where name in ('User','Manager','Administrator') and  ANR.name =ii.RoleName)


				--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				--SELECT '75', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				--FROM @InsertCustomer AS ii
				--WHERE  isnull(ltrim(rtrim(AccountCode)),'') != '' and isnull(ltrim(rtrim(RoleName)),'') <> ''

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '76', 'DepartmentName', DepartmentName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE isnull(ltrim(rtrim(ii.DepartmentName)),'') <> ''
				and not exists(select * from  ZnodeAccount ZA inner join ZnodeDepartment ZD on ZA.AccountId = ZD.AccountId
					where isnull(ltrim(rtrim(ii.AccountCode)),'') = ltrim(rtrim(za.AccountCode))
					and isnull(ltrim(rtrim(ii.DepartmentName)),'') = ltrim(rtrim(ZD.DepartmentName)))
				

		 UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ UserName - ' + ISNULL(UserName,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN @InsertCustomer IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL

		--Note : Content page import is not required 
		
		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  

		DELETE FROM @InsertCustomer
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);


		-- Update Record count in log 
        
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertCustomer
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount , 
		TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0))
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End

		-- Insert Product Data 
				
				
				DECLARE @InsertedAspNetZnodeUser TABLE (AspNetZnodeUserId nvarchar(256) ,UserName nvarchar(512),PortalId int )
				DECLARE @InsertedASPNetUsers TABLE (Id nvarchar(256) ,UserName nvarchar(512))
				DECLARE @InsertZnodeUser TABLE (UserId int,AspNetUserId nvarchar(256),CreatedDate Datetime )

				UPDATE ANU SET 
				ANU.PhoneNumber	= IC.PhoneNumber, ANU.LockoutEndDateUtc = case when IC.IsActive = 0 then @GetDate when IC.IsActive = 1 then null else ANU.LockoutEndDateUtc end
				from AspNetZnodeUser ANZU 
				INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(ANZU.PortalId,0) end = case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(@PortalId ,0) end
				----Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				UPDATE ZU SET 
				ZU.FirstName	= IC.FirstName,
				ZU.LastName		= IC.LastName,
				--ZU.MiddleName	= IC.MiddleName,
				ZU.BudgetAmount = IC.BudgetAmount,
				ZU.Email		= IC.Email,
				ZU.PhoneNumber	= IC.PhoneNumber,
				ZU.EmailOptIn	= Isnull(IC.EmailOptIn,0),
				ZU.IsActive		= IC.IsActive
				--ZU.ExternalId = ExternalId
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(ANZU.PortalId,0) end = case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(@PortalId ,0) end
				--where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				Insert into AspNetZnodeUser (AspNetZnodeUserId, UserName, PortalId)		
				OUTPUT INSERTED.AspNetZnodeUserId, INSERTED.UserName, INSERTED.PortalId	INTO  @InsertedAspNetZnodeUser 			 
				Select NEWID(),IC.UserName, @PortalId FROM @InsertCustomer IC 
				where Not Exists (Select TOP 1 1  from AspNetZnodeUser ANZ 
				where Isnull(ANZ.PortalId,0) = Isnull(@PortalId,0) AND ANZ.UserName = IC.UserName)

				INSERT INTO ASPNetUsers (Id,Email,EmailConfirmed,PasswordHash,SecurityStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,
				LockoutEndDateUtc,LockOutEnabled,AccessFailedCount,PasswordChangedDate,UserName)
				output inserted.Id, inserted.UserName into @InsertedASPNetUsers
				SELECT NewId(), Email,0 ,@PasswordHash,@SecurityStamp,PhoneNumber,0,0,case when A.IsActive = 0 then @GetDate else null end LockoutEndDateUtc,1 LockoutEnabled,
				0,@GetDate,AspNetZnodeUserId from @InsertCustomer A INNER JOIN @InsertedAspNetZnodeUser  B 
				ON A.UserName = B.UserName
				
				INSERT INTO  ZnodeUser(AspNetUserId,FirstName,LastName,CustomerPaymentGUID,Email,PhoneNumber,EmailOptIn,
				IsActive,ExternalId, CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,UserName)
				OUTPUT Inserted.UserId, Inserted.AspNetUserId,Inserted.CreatedDate into @InsertZnodeUser
				SELECT IANU.Id AspNetUserId ,IC.FirstName,IC.LastName,null CustomerPaymentGUID,IC.Email
				,IC.PhoneNumber,Isnull(IC.EmailOptIn,0),IC.IsActive,IC.ExternalId, @UserId,
				CASE WHEN IC.CreatedDate IS NULL OR IC.CreatedDate = '' THEN  @Getdate ELSE IC.CreatedDate END,
				@UserId,@Getdate,IC.UserName
				from @InsertCustomer IC Inner join 
				@InsertedAspNetZnodeUser IANZU ON IC.UserName = IANZU.UserName  INNER JOIN 
				@InsertedASPNetUsers IANU ON IANZU.AspNetZnodeUserId = IANU.UserName 
				  	     
				INSERT INTO AspNetUserRoles (UserId,RoleId)  Select AspNetUserId, @RoleID from @InsertZnodeUser 
				INSERT INTO ZnodeUserPortal (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
				SELECT UserId, @PortalId , @UserId, IZU.CreatedDate,@UserId,@Getdate 
				from @InsertZnodeUser IZU

				insert into ZnodeAccountUserPermission(UserId,AccountPermissionAccessId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT UserId, 4 , @UserId, @Getdate,@UserId,@Getdate 
				from @InsertZnodeUser IZU
				--Declare @ProfileId  int 
				--select TOP 1 @ProfileId   =  ProfileId from ZnodePortalprofile where Portalid = @Portalid and IsDefaultRegistedProfile=1

				--insert into ZnodeUserProfile (ProfileId,UserId,IsDefault,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				--SELECT @ProfileId  , UserId, 1 , @UserId,CreatedDate,@UserId,@Getdate from @InsertZnodeUser


------------insert into ZnodeUserGlobalAttributeValue
	
				IF OBJECT_ID('tempdb..#globaldata') IS NOT NULL DROP TABLE #globaldata
				select ZU.userid,PerOrderLimit,
									PerOrderAnnualLimit,
									BillingAccountNumber,
									EnableUserShippingAddressSuggestion,
									EnablePowerBIReportOnWebStore 
									into #globaldata
				from znodeuser ZU inner join  @InsertCustomer IC on IC.Email =ZU.EMAIL
				where ZU.userid in (select userid from @InsertZnodeUser)
				group by ZU.userid,PerOrderLimit,
									PerOrderAnnualLimit,
									BillingAccountNumber,
									EnableUserShippingAddressSuggestion,
									EnablePowerBIReportOnWebStore 

				IF OBJECT_ID('tempdb..#globaldata1') IS NOT NULL DROP TABLE #globaldata1
				select * into #globaldata1 from (select userid, Cast(PerOrderLimit as varchar(100)) PerOrderLimit,
				 Cast(PerOrderAnnualLimit as varchar(100)) PerOrderAnnualLimit,
				 Cast(BillingAccountNumber as varchar(100)) BillingAccountNumber,
				 Cast(case when EnableUserShippingAddressSuggestion= '1' or EnableUserShippingAddressSuggestion ='YES' or  EnableUserShippingAddressSuggestion ='True' then 'True' else 'False'  end  as varchar(100)) EnableUserShippingAddressSuggestion,
				 Cast(case when EnablePowerBIReportOnWebStore= '1'  or EnablePowerBIReportOnWebStore ='YES' or  EnablePowerBIReportOnWebStore ='True' then 'True' else 'False' end  as varchar(100)) EnablePowerBIReportOnWebStore from #globaldata) ab
				UNPIVOT  
				   (avalue FOR acode IN   
					  (PerOrderLimit,
				PerOrderAnnualLimit,
				BillingAccountNumber,
				EnableUserShippingAddressSuggestion,
				EnablePowerBIReportOnWebStore)  
				)AS unpvt;  

				insert into ZnodeUserGlobalAttributeValue (UserId,	GlobalAttributeId,	GlobalAttributeDefaultValueId,	AttributeValue,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
				Select g.Userid,ZGA.GlobalAttributeId,null,null,@UserId,@Getdate,@UserId,@Getdate
					from #globaldata1 g inner join ZnodeGlobalAttribute ZGA on ZGA.AttributeCode =g.acode
					where not exists (select top 1 1 from ZnodeUserGlobalAttributeValue ZGAV where ZGAV.Userid =g.Userid and ZGA.GlobalAttributeId=ZGAV.GlobalAttributeId)

				insert into ZnodeUserGlobalAttributeValuelocale(UserGlobalAttributeValueId,	LocaleId,	AttributeValue,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate,	GlobalAttributeDefaultValueId,	MediaId,	MediaPath)
				select UserGlobalAttributeValueId, @LocaleId,avalue ,@UserId,@Getdate,@UserId,@Getdate,null,null,null
					from ZnodeUserGlobalAttributeValue ZUGAV inner join #globaldata1 g on ZUGAV.userid =g.userid
						inner join ZnodeGlobalAttribute ZGA on ZGA.AttributeCode =g.acode and ZGA.GlobalAttributeId = ZUGAV.GlobalAttributeId
						where not exists (select Top 1 1 from ZnodeUserGlobalAttributeValuelocale z where z.UserGlobalAttributeValueId = ZUGAV.UserGlobalAttributeValueId)

---------------------------------------------------------------------------------

				declare @Profile table (ProfileId int)

				INSERT INTO ZnodeProfile (ProfileName,ShowOnPartnerSignup,Weighting,TaxExempt,DefaultExternalAccountNo,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ParentProfileId)
				OUTPUT inserted.ProfileId INTO @Profile(ProfileId)
				SELECT Distinct ProfileName, 0, null,0, replace(ltrim(rtrim(ProfileName)),' ','') as DefaultExternalAccountNo, @UserId,@Getdate, @UserId,@Getdate, null as ParentProfileId				
				from @InsertCustomer IC
				where not exists(select * from ZnodeProfile ZP where IC.ProfileName = ZP.ProfileName )
				AND ISNULL(ic.ProfileName,'') <> ''

				INSERT INTO ZnodePortalProfile (PortalId,	ProfileId,	IsDefaultAnonymousProfile,	IsDefaultRegistedProfile,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
				SELECT @PortalId, ProfileId, 0 AS IsDefaultAnonymousProfile, 0 AS IsDefaultRegistedProfile, @UserId,@Getdate, @UserId,@Getdate
				from @Profile

				UPDATE ZnodeUserProfile 
				SET ProfileId = COALESCE(ZP.ProfileId,@ProfileId)
				FROM ZnodeUser a
				inner join ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join ZnodeUserProfile u ON u.UserId = a.UserId
				LEFT join ZnodeProfile ZP on IC.ProfileName = ZP.ProfileName
				--where IC.ProfileName <> ''
				
				INSERT INTO ZnodeUserProfile (ProfileId,UserId,IsDefault,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT COALESCE(ZP.ProfileId,@ProfileId)  , a.UserId, 1 , @UserId,a.CreatedDate,@UserId,@Getdate 
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				LEFT join ZnodeProfile ZP on IC.ProfileName = ZP.ProfileName
				where NOT EXISTS (SELECT TOP  1 1 FROM ZnodeUserProfile u WHERE u.UserId = a.UserId )
				AND EXISTS(SELECT * FROM @InsertZnodeUser IZU WHERE A.UserId = IZU.UserId)

				---to update accountid agaist user
				UPDATE ZU SET ZU.AccountId = ZA.AccountId 
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	 
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName
				INNER JOIN ZnodeAccount ZA ON ZA.AccountCode = IC.AccountCode 
				--inner join @InsertZnodeUser IZU on IZU.UserId =ZU.UserId
				where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0) and isnull(IC.AccountCode,'') <> ''
				
				update ZDU set ZDU.DepartmentId = ZD.DepartmentId, ModifiedBy = @UserId, ModifiedDate = @Getdate
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join ZnodeDepartment ZD on IC.DepartmentName = ZD.DepartmentName
				inner join ZnodeDepartmentUser ZDU on ZDU.UserId = a.UserId
				where isnull(IC.DepartmentName,'') <> ''

				insert into ZnodeDepartmentUser(UserId,DepartmentId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT a.UserId, ZD.DepartmentId, @UserId,a.CreatedDate,@UserId,@Getdate 
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join ZnodeDepartment ZD on IC.DepartmentName = ZD.DepartmentName
				where NOT EXISTS (SELECT TOP  1 1 FROM ZnodeDepartmentUser u WHERE u.UserId = a.UserId)
				AND isnull(IC.DepartmentName,'') <> ''
		
				update u set u.RoleId = ZD.Id
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join AspNetRoles ZD on IC.RoleName = ZD.Name
				inner join AspNetUserRoles u on u.UserId = b.Id
				where isnull(IC.RoleName,'') <> ''
				
				insert into AspNetUserRoles(UserId,RoleId)
				SELECT b.Id as ASPNetUserId, ZD.Id as RoleId
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join AspNetRoles ZD on IC.RoleName = ZD.Name
				where NOT EXISTS (SELECT TOP  1 1 FROM AspNetUserRoles u WHERE u.UserId = b.Id)
				AND EXISTS(SELECT * FROM @InsertZnodeUser IZU WHERE A.UserId = IZU.UserId)
				AND isnull(IC.RoleName,'') <> ''


		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;

		COMMIT TRAN A;
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN A;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 3 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;

		SET @Status = 0;
		SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE();
		
		 DECLARE @Error_procedure VARCHAR(8000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ImportCustomer @TableName = '+CAST(@TableName AS VARCHAR(max))+',@UserId = '+CAST(@UserId AS VARCHAR(50))+',@ImportProcessLogId='+CAST(@ImportProcessLogId AS VARCHAR(10))+',@PortalId='+CAST(@PortalId AS VARCHAR(10))+',@CsvColumnString='+CAST(@CsvColumnString AS VARCHAR(max));
              			
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ImportCustomer',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END;

go
	
  IF exists(select * from sys.procedures where name = 'ZnodeGetMediaAttributeValues')
	drop proc ZnodeGetMediaAttributeValues
go

CREATE PROCEDURE [dbo].[ZnodeGetMediaAttributeValues]
( 
	@MediaID  INT = 0,
	@LocaleId INT = 1
)
AS
/*
Summary: This Procedure is used to get values of media attribute
Unit Testing:
Exec ZnodeGetMediaAttributeValues

*/
BEGIN
BEGIN TRY
SET NOCOUNT ON

	Declare @ServerPath varchar(500)
	SET @ServerPath = 
	(
		SELECT top 1 ZnodeMediaConfiguration.URL+ZnodeMediaServerMaster.ThumbnailFolderName    
		FROM [dbo].[ZnodeMediaServerMaster] 
		INNER JOIN [dbo].[ZnodeMediaConfiguration] on [dbo].[ZnodeMediaServerMaster].MediaServerMasterId=ZnodeMediaConfiguration.MediaServerMasterId 
		WHERE ZnodeMediaConfiguration.IsActive='True' 
	)

    DECLARE @AttributeValue TABLE
    (
		[MediaCategoryId]              [INT] NOT NULL,
		[MediaId]                      [INT] NULL,
		[MediaPathId]                  [INT] NULL,
		[MediaAttributeFamilyId]       [INT] NULL,
		[FamilyCode]                   [VARCHAR](200) NULL,
		[MediaAttributeId]             [INT] NULL,
		[AttributeTypeId]              [INT] NULL,
		[AttributeTypeName]            [VARCHAR](300) NULL,
		[AttributeCode]                [VARCHAR](300) NULL,
		[IsRequired]                   [BIT] NULL,
		[IsLocalizable]                [BIT] NULL,
		[IsFilterable]                 [BIT] NULL,
		[AttributeName]                [NVARCHAR](300) NULL,
		[AttributeValue]               [VARCHAR](300) NULL,
		[MediaAttributeValueId]        [INT] NULL,
		[MediaAttributeDefaultValueId] [INT] NULL,
		[DefaultAttributeValue]        [NVARCHAR](300) NULL,
		[MediaPath]                    [VARCHAR](8000) NULL,
		[RowId]                        [INT] NOT NULL,
		[IsEditable]                   [BIT] NOT NULL,
		[ControlName]                  [VARCHAR](300) NULL,
		[ValidationName]               [VARCHAR](100) NULL,
		[SubValidationName]            [VARCHAR](300) NULL,
		[RegExp]                       [VARCHAR](300) NULL,
		[ValidationValue]              [VARCHAR](300) NULL,
		[IsRegExp]                     [BIT] NULL,
		[AttributeGroupName]           [NVARCHAR](300) NULL,
		DisplayOrder                   INT,
		[HelpDescription]              [NVARCHAR](MAX) NULL,
		GroupDisplayOrder              INT,
		MediaAttributeThumbnailPath    Varchar(1000)
    );
    INSERT INTO @AttributeValue
        SELECT DISTINCT
                a.MediaCategoryId,
                a.MediaId,
                a.MediaPathId,
                a.MediaAttributeFamilyId,
                qq.FamilyCode,
                c.MediaAttributeId,
                c.AttributeTypeId,
                Q.AttributeTypeName,
                c.AttributeCode,
                c.IsRequired,
                c.IsLocalizable,
                c.IsFilterable,
                f.AttributeName,
                b.AttributeValue,
                b.MediaAttributeValueId,
                h.MediaAttributeDefaultValueId,
                g.DefaultAttributeValue,
                dbo.Fn_ZnodeMediaRecurcivePath(a.MediaPathId, @LocaleId) AS MediaPath,
                ISNULL(NULL, 0) AS RowId,
                ISNULL(h.IsEditable, 1) AS IsEditable,
                i.ControlName,
                i.Name AS ValidationName,
                j.ValidationName AS SubValidationName,
                j.RegExp,
                k.Name AS ValidationValue,
                CAST(CASE
                        WHEN j.RegExp IS NULL
                        THEN 0
                        ELSE 1
                    END AS BIT) AS IsRegExp,
                Zmagm.AttributeGroupName,
                c.DisplayOrder,
                c.HelpDescription,
                Zmag.DisplayOrder,
				@ServerPath+'/'+ZM.Path+'?'+'V='+cast(ZM.Version as varchar(10)) as MediaAttributeThumbnailPath				
        FROM [dbo].[ZnodeMediaCategory] AS a
                INNER JOIN dbo.ZnodeMediaAttributeFamily AS qq ON(a.MediaAttributeFamilyId = qq.MediaAttributeFamilyId)
                INNER JOIN dbo.ZnodeMediaFamilyGroupMapper AS w ON(qq.MediaAttributeFamilyId = w.MediaAttributeFamilyId)
                INNER JOIN dbo.ZnodeMediaAttributeGroupMapper AS t ON(t.MediaAttributeGroupId = w.MediaAttributeGroupId)
                INNER JOIN dbo.ZnodeMediaAttributeGroup AS Zmag ON(t.MediaAttributeGroupId = Zmag.MediaAttributeGroupId
                                                                AND Zmag.IsHidden = 0)
                INNER JOIN ZnodeMediaAttributeGroupLocale AS Zmagm ON t.MediaAttributeGroupId = Zmagm.MediaAttributeGroupId
                                                                    AND Zmagm.LocaleId = @LocaleId
                LEFT JOIN [dbo].[ZnodeMediaAttributeValue] AS b ON(t.MediaAttributeId = b.MediaAttributeId
                                                                AND a.MediaCategoryId = b.MediaCategoryId)
                LEFT JOIN [dbo].[ZnodeMediaAttribute] AS c ON(c.MediaAttributeId = t.MediaAttributeId)
                LEFT JOIN [dbo].ZnodeAttributeType AS q ON(c.AttributeTypeId = Q.AttributeTypeId)
                LEFT JOIN [dbo].[ZnodeMediaAttributeLocale] AS f ON(c.MediaAttributeId = f.MediaAttributeId
                                                                    AND f.LocaleId = @LocaleId)
                LEFT JOIN [dbo].[ZnodeMediaAttributeDefaultValue] AS h ON(h.MediaAttributeDefaultValueId = b.MediaAttributeDefaultValueId
                                                                        OR h.MediaAttributeId = t.MediaAttributeId)
                LEFT JOIN [dbo].[ZnodeMediaAttributeDefaultValueLocale] AS g ON(h.MediaAttributeDefaultValueId = g.MediaAttributeDefaultValueId
                                                                                AND g.LocaleId = @LocaleId)
                LEFT JOIN [dbo].ZnodeMediaAttributeValidation AS k ON(k.MediaAttributeId = c.MediaAttributeId)
                LEFT JOIN [dbo].ZnodeAttributeInputValidation AS i ON(k.InputValidationId = i.InputValidationId)
                LEFT JOIN [dbo].ZnodeAttributeInputValidationRule AS j ON(k.InputValidationRuleId = j.InputValidationRuleId)
				LEFT JOIN ZnodeMedia ZM ON a.MediaId = ZM.MediaId
		WHERE CASE WHEN @MediaID = 0 THEN  0 ELSE  a.MediaId END  = ISNULL(@MediaID, 0);
    SELECT MediaCategoryId,
        MediaId,
        MediaPathId,
        MediaAttributeFamilyId,
        FamilyCode,
        MediaAttributeId,
        AttributeTypeId,
        AttributeTypeName,
        AttributeCode,
        IsRequired,
        IsLocalizable,
        IsFilterable,
        AttributeName,
        AttributeValue,
        MediaAttributeValueId,
        MediaAttributeDefaultValueId,
        DefaultAttributeValue,
        MediaPath,
        RowId,
        IsEditable,
        ControlName,
        ValidationName,
        SubValidationName,
        RegExp,
        ValidationValue,
        IsRegExp,
        AttributeGroupName,
        HelpDescription,
        GroupDisplayOrder,
		MediaAttributeThumbnailPath
    FROM @AttributeValue
    ORDER BY GroupDisplayOrder,
            DisplayOrder;
			
END TRY
BEGIN CATCH
		DECLARE @Status BIT ;
		SET @Status = 0;
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeGetMediaAttributeValues @MediaID = '+CAST(@MediaID AS VARCHAR(100))+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
        SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
        EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'ZnodeGetMediaAttributeValues',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;
END CATCH
END;

go
if exists(select 1 from sys.views where name='View_MediaAttributeValues' and type='v')
drop view View_MediaAttributeValues;
print 1;
go

CREATE VIEW [dbo].[View_MediaAttributeValues]
AS

     SELECT a.MediaCategoryId,
            a.MediaId,
            a.MediaPathId,
            a.MediaAttributeFamilyId,
            qq.FamilyCode,
            c.MediaAttributeId,
            c.AttributeTypeId,
            q.AttributeTypeName,
            c.AttributeCode,
            c.IsRequired,
            c.IsLocalizable,
            c.IsFilterable,
            f.AttributeName,
            b.AttributeValue,
            b.MediaAttributeValueId,
            b.MediaAttributeDefaultValueId,
            g.DefaultAttributeValue,
            dbo.Fn_ZnodeMediaRecurcivePath(a.MediaPathId, 1) AS MediaPath,
            ISNULL(NULL, 0) AS RowId,
            h.IsEditable,
            i.ControlName,
            i.Name AS ValidationName,
            j.ValidationName AS SubValidationName,
            j.RegExp,
            k.Name AS ValidationValue,
            CAST(CASE
                     WHEN j.RegExp IS NULL
                     THEN 0
                     ELSE 1
                 END AS BIT) AS IsRegExp,
            Zmagm.AttributeGroupName,
            c.HelpDescription,
			Z.ServerPath+'/'+ZM.Path+'?'+'V='+cast(ZM.Version as varchar(10)) as MediaAttributeThumbnailPath	
     FROM dbo.ZnodeMediaCategory AS a
          INNER JOIN dbo.ZnodeMediaAttributeFamily AS qq ON a.MediaAttributeFamilyId = qq.MediaAttributeFamilyId
          INNER JOIN dbo.ZnodeMediaFamilyGroupMapper AS w ON qq.MediaAttributeFamilyId = w.MediaAttributeFamilyId
          INNER JOIN dbo.ZnodeMediaAttributeGroupMapper AS t ON t.MediaAttributeGroupId = w.MediaAttributeGroupId
          INNER JOIN ZnodeMediaAttributeGroupLocale Zmagm ON t.MediaAttributeGroupId = Zmagm.MediaAttributeGroupId
          LEFT OUTER JOIN dbo.ZnodeMediaAttributeValue AS b ON t.MediaAttributeId = b.MediaAttributeId
                                                               AND a.MediaCategoryId = b.MediaCategoryId
          LEFT OUTER JOIN dbo.ZnodeMediaAttribute AS c ON c.MediaAttributeId = t.MediaAttributeId
          LEFT OUTER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
          LEFT OUTER JOIN dbo.ZnodeMediaAttributeLocale AS f ON c.MediaAttributeId = f.MediaAttributeId
          LEFT OUTER JOIN dbo.ZnodeMediaAttributeDefaultValue AS h ON h.MediaAttributeDefaultValueId = b.MediaAttributeDefaultValueId
          LEFT OUTER JOIN dbo.ZnodeMediaAttributeDefaultValueLocale AS g ON b.MediaAttributeDefaultValueId = g.MediaAttributeDefaultValueId
          LEFT OUTER JOIN dbo.ZnodeMediaAttributeValidation AS k ON k.MediaAttributeId = c.MediaAttributeId
          LEFT OUTER JOIN dbo.ZnodeAttributeInputValidation AS i ON k.InputValidationId = i.InputValidationId
          LEFT OUTER JOIN dbo.ZnodeAttributeInputValidationRule AS j ON k.InputValidationRuleId = j.InputValidationRuleId
		  LEFT OUTER JOIN ZnodeMedia ZM ON a.MediaId = ZM.MediaId
		  CROSS APPLY (
						SELECT top 1 ZnodeMediaConfiguration.URL+ZnodeMediaServerMaster.ThumbnailFolderName  AS ServerPath  
						FROM [dbo].[ZnodeMediaServerMaster] 
						INNER JOIN [dbo].[ZnodeMediaConfiguration] on [dbo].[ZnodeMediaServerMaster].MediaServerMasterId=ZnodeMediaConfiguration.MediaServerMasterId 
						WHERE ZnodeMediaConfiguration.IsActive='True' 
					)z
;
GO
go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetPublishSingleProductJson')
	drop proc Znode_GetPublishSingleProductJson
go
CREATE PROCEDURE [dbo].[Znode_GetPublishSingleProductJson]
(
	 @PublishCatalogId INT = 0 
	,@VersionId       VARCHAR(50) = 0 
	,@PimProductId    TransferId Readonly 
	,@UserId		  INT = 0 
	,@TokenId nvarchar(max)= ''	
	,@LocaleIds TransferId READONLY
	,@PublishStateId INT = 0  
	,@RevisionType varchar(50)
	,@Status bit = 0 OutPut
	
)
AS


--Declare @PimProductId TransferId 
--insert into @PimProductId  select 230147
-- EXEC Znode_GetPublishSingleProductJson  @PublishCatalogId = 0 ,@VersionId= 0 ,@PimProductId =@PimProductId, @UserId=2 ,@RevisionType ='Production'


BEGIN 
BEGIN TRY 
 SET NOCOUNT ON 

EXEC Znode_InsertUpdatePimAttributeJson 1 
EXEC Znode_InsertUpdateCustomeFieldJson 1
EXEC Znode_InsertUpdateAttributeDefaultValueJson 1 

DECLARE @PimMediaAttributeId INT = dbo.Fn_GetProductImageAttributeId()
				
Select ZPLPD.PimParentProductId, ZPLPD.PimProductId, ZPLPD.PimAttributeId, ZPAVL.AttributeValue as SKU
into #LinkProduct
FROM ZnodePimLinkProductDetail ZPLPD 
INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = ZPLPD.PimProductId)
INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
WHERE exists(select * from ZnodePimAttribute ZPA where ZPA.PimAttributeId = ZPAV.PimAttributeId and ZPA.AttributeCode = 'SKU')
and exists(select * from @PimProductId pp where ZPLPD.PimParentProductId = pp.Id)

select * into #PimProductId from @PimProductId

create index Idx_#PimProductId_Id on #PimProductId(Id)
 IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
	DROP TABLE #Cte_BrandData
 END 
 

 IF OBJECT_ID('tempdb..#ProductIds') is not null
 BEGIN 
	DROP TABLE #ProductIds
 END 

			Create Table #ProductIds (PimProductId int, PublishProductId  int )
			
			--DECLARE @PimProductAttributeJson TABLE(PimAttributeJsonId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
			CREATE TABLE #PimProductAttributeJson (PimAttributeJsonId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
			DECLARE @PimDefaultValueLocale  TABLE (PimAttributeDefaultJsonId INT  PRIMARY KEY ,PimAttributeDefaultValueId INT ,LocaleId INT ) 
			DECLARE @ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
			,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
			DECLARE @GetDate DATETIME =dbo.Fn_GetDate()
			DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )

			DECLARE @DomainUrl varchar(max) = (select TOp 1 URL FROM ZnodeMediaConfiguration WHERE IsActive =1)

			INSERT INTO @TBL_LocaleId (LocaleId)
			SELECT  LocaleId
			FROM ZnodeLocale MT
			WHERE IsActive = 1
			AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
			OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) 
	
			-----to update link products newly addded and deleted from PIM
			delete ZPAP
			from ZnodePublishAssociatedProduct ZPAP
			where ZPAP.IsLink = 1
			AND not exists(select * from ZnodePimLinkProductDetail ZPPD where ZPAP.ParentPimProductId = ZPPD.PimParentProductId AND ZPAP.PimProductId = ZPPD.PimProductId)
			and exists(select * from #PimProductId PP where PP.Id = ZPAP.ParentPimProductId )

			UPDATE ZPACP SET ZPACP.DisplayOrder = ZPLPD.DisplayOrder
			from ZnodePimLinkProductDetail ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			INNER JOIN ZnodePublishAssociatedProduct ZPACP ON ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId 
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			AND ZPACP.IsLink = 1

			insert into ZnodePublishAssociatedProduct(PimCatalogId,ParentPimProductId,PimProductId,PublishStateId,IsConfigurable,IsBundle,IsGroup,IsAddOn,IsLink,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			select distinct ZPCH.PimCatalogId, ZPLPD.PimParentProductId, ZPLPD.PimProductId, @PublishStateId, 0, 0, 0, 0, 1, ZPLPD.DisplayOrder, @UserId,@GetDate ,@UserId , @GetDate
			from ZnodePimLinkProductDetail ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			and not exists(select * from ZnodePublishAssociatedProduct ZPACP where ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId  )
		
			-----to update config products newly addded and deleted from PIM
			delete ZPAP
			from ZnodePublishAssociatedProduct ZPAP
			where ZPAP.IsConfigurable = 1
			AND exists(select * from ZnodePimProductTypeAssociation ZPPD where ZPAP.ParentPimProductId = ZPPD.PimParentProductId )
			and exists(select * from #PimProductId PP where PP.Id = ZPAP.ParentPimProductId )

			Update ZPACP SET ZPACP.DisplayOrder = ZPLPD.DisplayOrder
			from ZnodePimProductTypeAssociation ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			INNER JOIN ZnodePublishAssociatedProduct ZPACP ON ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			AND ZPACP.IsConfigurable = 1

			insert into ZnodePublishAssociatedProduct(PimCatalogId,ParentPimProductId,PimProductId,PublishStateId,IsConfigurable,IsBundle,IsGroup,IsAddOn,IsLink,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate, IsDefault)
			select distinct ZPCH.PimCatalogId, ZPLPD.PimParentProductId, ZPLPD.PimProductId, @PublishStateId, 1, 0, 0, 0, 0, ZPLPD.DisplayOrder, @UserId,@GetDate ,@UserId , @GetDate, ZPLPD.IsDefault
			from ZnodePimProductTypeAssociation ZPLPD
			INNER JOIN ZnodePimCategoryProduct ZPCP ON ZPLPD.PimParentProductId = ZPCP.PimProductId
			INNER JOIN ZnodePimCategoryHierarchy ZPCH ON ZPCP.PimCategoryId = ZPCH.PimCategoryId
			where exists(select * from #PimProductId PP where PP.Id = ZPLPD.PimParentProductId )
			and not exists(select * from ZnodePublishAssociatedProduct ZPACP where ZPCH.PimCatalogId = ZPACP.PimCatalogId and ZPLPD.PimParentProductId = ZPACP.ParentPimProductId AND ZPLPD.PimProductId = ZPACP.PimProductId  )
			--group by ZPCH.PimCatalogId, ZPLPD.PimParentProductId, ZPLPD.PimProductId, ZPLPD.DisplayOrder, ZPLPD.IsDefault
			-------

			DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 

			CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT   , VersionId INT ,LocaleId INT, PriceListId INT , PortalId INT ,MaxSmallWidth NVARCHAr(max)  )
			CREATE INDEX idx_#TBL_PublishCatalogIdPimProductId on #TBL_PublishCatalogId(PimProductId)
			CREATE INDEX idx_#TBL_PublishCatalogIdPimPublishCatalogId on #TBL_PublishCatalogId(PublishCatalogId)

			INSERT INTO #TBL_PublishCatalogId 
			SELECT Distinct ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId, 0,0 ,
			(SELECT TOP 1 PriceListId FROM ZnodePriceListPortal NT 
			INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=NT.PortalId  
			ORDER BY NT.Precedence ASC ) ,TY.PortalId,
			(SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodeGlobalMediaDisplaySetting)
			FROM ZnodePublishProduct ZPP 
			LEFT JOIN ZnodePortalCatalog TY ON (TY.PublishCatalogId = ZPP.PublishCatalogId)
			WHERE (EXISTS (SELECT TOP 1 1 FROM #PimProductId SP WHERE SP.Id = ZPP.PimProductId  
			AND  (@PublishCatalogId IS NULL OR @PublishCatalogId = 0 ))
			OR  (ZPP.PublishCatalogId = @PublishCatalogId ))
			And Exists 
			(Select TOP 1 1 from ZnodePublishVersionEntity ZPCP  where ZPCP.ZnodeCatalogId  = ZPP.PublishCatalogId AND ZPCP.IsPublishSuccess =1 )

			Insert into #ProductIds (PimProductId,PublishProductId) Select distinct PimProductId,PublishProductId from #TBL_PublishCatalogId  

             Create TABLE #TBL_ZnodeTempPublish (PimProductId INT , AttributeCode VARCHAR(300) ,AttributeValue NVARCHAR(max) ) 			
			 DECLARE @TBL_AttributeVAlueLocale TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT,LocaleId INT ,AttributeValue Nvarchar(1000) )


			 INSERT INTO @TBL_AttributeValueLocale (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId ,LocaleId ,AttributeValue )
			 SELECT VIR.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId,VIR.LocaleId, ''
			 FROM View_LoadManageProductInternal VIR
			 INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = VIR.PimProductId)
			 UNION ALL 
			 SELECT VIR.PimProductId,PimAttributeId,PimProductAttributeMediaId,ZPDE.LocaleId , ''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimProductAttributeMedia ZPDE ON (ZPDE.PimAttributeValueId = VIR.PimAttributeValueId )
			 WHERE EXISTS (SELECT TOP 1 1 FROM #ProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,ZPDVL.PimAttributeDefaultValueLocaleId,ZPDVL.LocaleId ,ZPDVL.AttributeDefaultValue
			   FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON ZPADV.PimAttributeId = D.PimAttributeId
			 INNER JOIN ZnodePimAttributeDefaultValueLocale ZPDVL   on (ZPADV.PimAttributeDefaultValueId = ZPDVL.PimAttributeDefaultValueId)
			 WHERE ( ZPDVL.LocaleId = @DefaultLocaleId OR ZPDVL.LocaleId = @LocaleId )
			 AND EXISTS(SELECT TOP 1 1 FROM #ProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,'','' ,''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 WHERE  EXISTS(SELECT TOP 1 1 FROM #ProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
		
				--insert INTO #ZnodePrice
				SELECT RetailPrice,SalesPrice,ZC.CurrencyCode,ZCC.CultureCode ,ZCC.Symbol CurrencySuffix,TYU.PublishProductId ,isnull(ZPC1.IsAllowIndexing,0) as IsAllowIndexing
				into #ZnodePrice
				FROM ZnodePrice ZP 
				INNER JOIN ZnodePriceList ZPL ON (ZPL.PriceListId = ZP.PriceListId)
				INNER JOIN ZnodeCurrency ZC oN (ZC.CurrencyId = ZPL.CurrencyId )
				INNER JOIN ZnodeCulture ZCC ON (ZCC.CultureId = ZPL.CultureId)
				INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZP.SKU ) 
				INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId)
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TYUR WHERE TYUR.PriceListId = ZPL.PriceListId AND TYUR.PublishCatalogId = TYU.PublishCatalogId
				AND TYU.PublishProductId = TYUR.PublishProductId)
				AND TY.LocaleId = dbo.Fn_GetDefaultLocaleId()
				AND EXISTS (SELECT TOP 1 1 FROM ZnodePriceListPortal ZPLP 
				INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=ZPLP.PortalId WHERE ZPLP.PriceListId=ZP.PriceListId )
				
				--insert INTO #ProductSKU
				SELECT ZCSD.SEOUrl , ZCDL.SEODescription,ZCDL.SEOKeywords ,ZCDL.SEOTitle, TYU.PublishProductId ,isnull(ZPC1.IsAllowIndexing,0) as IsAllowIndexing
				INTO #ProductSKU
				FROM ZnodeCMSSEODetail ZCSD 
				INNER JOIN ZnodeCMSSEODetailLocale ZCDL ON (ZCDL.CMSSEODetailId = ZCSD.CMSSEODetailId)
				INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZCSD.SEOCode AND ZCDL.LocaleId = TY.LocaleId) 
				INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId)
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE CMSSEOTypeId = (SELECT TOP 1 CMSSEOTypeId FROM ZnodeCMSSEOType WHERE Name = 'Product') 
				AND EXISTS (SELECT TOP 1 1  FROM #TBL_PublishCatalogId TYUR WHERE  TYUR.PublishCatalogId = TYU.PublishCatalogId
				AND TYU.PublishProductId = TYUR.PublishProductId)
				AND ZCDL.LocaleId = dbo.Fn_GetDefaultLocaleId()
				and ZCSD.PortalId = isnull(ZPC1.PortalId,0)

			
				--insert INTO #ProductImages
				SELECT  TUI.PublishCatalogId, TYU.PublishProductId , @DomainUrl +'Catalog/'  + CAST(Max(ZPC1.PortalId) AS VARCHAr(100)) + '/'+ CAST(Isnull(Max(TUI.MaxSmallWidth),'') AS VARCHAR(100)) + '/' + Isnull(RT.MediaPath,'') AS ImageSmallPath    
				,isnull(ZPC1.IsAllowIndexing,0) as IsAllowIndexing
				INTO #ProductImages
				FROM ZnodePimAttributeValue ZPAV 
				INNER JOIN ZnodePublishProduct TYU ON (TYU.PimProductId  = ZPAV.PimProductId)
				INNER JOIN ZnodePimProductAttributeMedia  RT ON ( RT.PimAttributeValueId = ZPAV.PimAttributeValueId )
				INNER JOIN #TBL_PublishCatalogId TUI ON (TUI.PublishProductId = TYU.PublishProductId AND TUI.PublishCatalogId = TYU.PublishCatalogId
						 )--AND  TUI.LocaleId = dbo.Fn_GetDefaultLocaleId()
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE  RT.LocaleId = dbo.Fn_GetDefaultLocaleId()
				AND ZPAV.PimAttributeId = (SELECT TOp 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'ProductImage')
				group by TUI.PublishCatalogId, TYU.PublishProductId ,isnull(RT.MediaPath,''),isnull(ZPC1.IsAllowIndexing,0) 
		  -- end
	  
WHILE @Counter <= @maxCountId
BEGIN
 SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId WHERE RowId = @Counter)

  INSERT INTO #PimProductAttributeJson 
  SELECT PimAttributeJsonId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeJSON
  WHERE LocaleId = @LocaleId
  
  INSERT INTO #PimProductAttributeJson 
  SELECT PimAttributeJsonId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeJSON ZPAX
  WHERE ZPAX.LocaleId = @DefaultLocaleId  
  AND NOT EXISTS (SELECT TOP 1 1 FROM #PimProductAttributeJson ZPAXI WHERE ZPAXI.PimAttributeId = ZPAX.PimAttributeId )

  INSERT INTO @PimDefaultValueLocale
  SELECT PimAttributeDefaultJsonId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultJson
  WHERE localeId = @LocaleId

  INSERT INTO @PimDefaultValueLocale 
   SELECT PimAttributeDefaultJsonId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultJson ZX
  WHERE localeId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM @PimDefaultValueLocale TRTR WHERE TRTR.PimAttributeDefaultValueId = ZX.PimAttributeDefaultValueId)
  
 
  --DECLARE @TBL_AttributeVAlue TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )
  --DECLARE @TBL_CustomeFiled TABLE (PimCustomeFieldJsonId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )
  CREATE TABLE #TBL_CustomeFiled  (PimCustomeFieldJsonId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )
  CREATE TABLE #TBL_AttributeVAlue (PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )



  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldJsonId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldJsonId,RTR.PimProductId ,RTR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldJson RTR 
  INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = RTR.PimProductId)
  WHERE RTR.LocaleId = @LocaleId
 

  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldJsonId,PimProductId ,LocaleId,CustomCode)
  SELECT  Distinct  PimCustomeFieldJsonId,ITR.PimProductId ,ITR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldJson ITR
  INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ITR.PimProductId)
  WHERE ITR.LocaleId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM #TBL_CustomeFiled TBL  WHERE ITR.CustomCode = TBL.CustomCode AND ITR.PimProductId = TBL.PimProductId)
  

    INSERT INTO #TBL_AttributeVAlue (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
    SELECT Distinct  PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
	FROM @TBL_AttributeVAlueLocale
    WHERE LocaleId = @LocaleId

    
	INSERT INTO #TBL_AttributeVAlue(PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
	SELECT VI.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
	FROM @TBL_AttributeVAlueLocale VI 
    WHERE VI.LocaleId = @DefaultLocaleId 
	AND NOT EXISTS (SELECT TOP 1 1 FROM #TBL_AttributeVAlue  CTE WHERE CTE.PimProductId = VI.PimProductId AND CTE.PimAttributeId = VI.PimAttributeId )
 
	------------Facet Merging Patch --------------
	IF OBJECT_ID('tempdb..#PimChildProductFacets') is not null
	BEGIN 
		DROP TABLE #PimChildProductFacets
	END 

	IF OBJECT_ID('tempdb..#PimAttributeDefaultXML') is not null
	BEGIN 
		DROP TABLE #PimAttributeDefaultXML
	END
	----Getting parent facets data
	Select  ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
	Into #PimChildProductFacets
	from ZnodePimAttributeValue ZPAV_Parent
	inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Parent.PimAttributeValueId = ZPPADV.PimAttributeValueId 
	where exists(select * from #ProductIds ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )

	----Getting child facets for merging	
	insert into #PimChildProductFacets	  
	Select distinct ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
	from ZnodePimAttributeValue ZPAV_Parent
	inner join ZnodePimProductTypeAssociation ZPPTA ON ZPAV_Parent.PimProductId = ZPPTA.PimParentProductId
	inner join ZnodePimAttributeValue ZPAV_Child ON ZPPTA.PimProductId = ZPAV_Child.PimProductId AND ZPAV_Parent.PimAttributeId = ZPAV_Child.PimAttributeId
	inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Child.PimAttributeValueId = ZPPADV.PimAttributeValueId 
	where exists(select * from ZnodePimFrontendProperties ZPFP where ZPAV_Parent.PimAttributeId = ZPFP.PimAttributeId and ZPFP.IsFacets = 1)
	and exists(select * from #ProductIds ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )
	and not exists(select * from ZnodePimProductAttributeDefaultValue ZPPADV1 where ZPAV_Parent.PimAttributeValueId = ZPPADV1.PimAttributeValueId 
		            and ZPPADV1.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )

	----Merging childs facet attribute Default value XML for parent
	select  ZPADX.DefaultValueJson, ZPPADV.PimAttributeValueId, ZPPADV.LocaleId
	into #PimAttributeDefaultXML
	from #PimChildProductFacets ZPPADV		  
	inner join ZnodePimAttributeDefaultJson ZPADX ON ( ZPPADV.PimAttributeDefaultValueId = ZPADX.PimAttributeDefaultValueId )--AND ZPPADV.LocaleId = ZPADX.LocaleId)
	INNER JOIN @PimDefaultValueLocale GH ON (GH.PimAttributeDefaultJsonId = ZPADX.PimAttributeDefaultJsonId)
	------------Facet Merging Patch --------------   

	 IF OBJECT_ID('tempdb..#View_LoadManageProductInternal') is not null
	 BEGIN 
		DROP TABLE #View_LoadManageProductInternal
	 END 

	SELECT a.PimProductId ,b.AttributeValue as AttributeValue , b.LocaleId  ,a.PimAttributeId,c.AttributeCode ,b.ZnodePimAttributeValueLocaleId
	into #View_LoadManageProductInternal
	FROM ZnodePimAttributeValue a 
	INNER JOIN  ZnodePimAttributeValueLocale b ON ( b.PimAttributeValueId = a.PimAttributeValueId )
	INNER JOIN ZnodePimAttribute c ON ( c.PimAttributeId=a.PimAttributeId )
	INNER JOIN ZnodePimAttributeJSON c1   ON (c1.PimAttributeId = a.PimAttributeId )
	INNER JOIN #PimProductAttributeJson b1 ON (b1.PimAttributeJsonId = c1.PimAttributeJsonId )
	INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = b.ZnodePimAttributeValueLocaleId)
	UNION ALL
	SELECT a.PimProductId,ZPPATAV.AttributeValue AS AttributeValue  
	,ZPPATAV.LocaleId,a.PimAttributeId,c.AttributeCode  ,ZPPATAV.PimProductAttributeTextAreaValueId
	FROM ZnodePimAttributeValue a 
	INNER JOIN ZnodePimProductAttributeTextAreaValue ZPPATAV ON (ZPPATAV.PimAttributeValueId = a.PimAttributeValueId )
	INNER JOIN ZnodePimAttribute c ON ( c.PimAttributeId=a.PimAttributeId )
	INNER JOIN ZnodePimAttributeJSON c1   ON (c1.PimAttributeId = a.PimAttributeId )
	INNER JOIN #PimProductAttributeJson b1 ON (b1.PimAttributeJsonId = c1.PimAttributeJsonId )
	INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = ZPPATAV.PimProductAttributeTextAreaValueId)
	
	INSERT INTO #TBL_ZnodeTempPublish  
		SELECT  a.PimProductId,a.AttributeCode , 
			JSON_MODIFY (JSON_MODIFY (Json_Query( c.AttributeJSON  ) , '$.AttributeValues' ,  
			ISNULL(a.AttributeValue,'') ) ,'$.SelectValues',Json_Query('[]'))
			AS 'AttributeValue'
		FROM #View_LoadManageProductInternal a 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = a.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = a.ZnodePimAttributeValueLocaleId)
	UNION ALL 
			SELECT  a.PimProductId,c.AttributeCode , 
			JSON_MODIFY (JSON_MODIFY (Json_Query( c.AttributeJSON  ) , '$.AttributeValues' ,  
			ISNULL(TAVL.AttributeValue,'') ) ,'$.SelectValues',Json_Query('[]'))
			AS 'AttributeValue'
		FROM ZnodePimAttributeValue  a 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = a.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN ZnodePImAttribute ZPA  ON (ZPA.PimAttributeId = a.PimAttributeId)
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = a.PimProductId)
		Inner JOIN @TBL_AttributeVAlueLocale TAVL ON  (c.PimAttributeId = TAVL.PimAttributeId  and ZPP.PimProductId = TAVL.PimProductId )
		WHERE ZPA.IsPersonalizable = 1 
		AND NOT EXISTS ( SELECT TOP 1 1 FROM ZnodePimAttributeValueLocale q WHERE q.PimAttributeValueId = a.PimAttributeValueId) 
	UNION ALL 
		SELECT THB.PimProductId,THB.CustomCode,
		--'<Attributes><AttributeEntity>'+CustomeFiledJson +'</AttributeEntity></Attributes>' 
		JSON_MODIFY (Json_Query( CustomeFiledJson ) ,'$.SelectValues',Json_Query('[]')) 
		FROM ZnodePimCustomeFieldJson THB 
		INNER JOIN #TBL_CustomeFiled TRTE ON (TRTE.PimCustomeFieldJsonId = THB.PimCustomeFieldJsonId)
		UNION ALL 
		SELECT ZPAV.PimProductId,c.AttributeCode,
			JSON_MODIFY (JSON_MODIFY (c.AttributeJson,'$.AttributeValues',''), '$.SelectValues',
			Isnull((SELECT 
			Isnull(JSON_VALUE(DefaultValueJson, '$.Code'),'') Code 
			,Isnull(JSON_VALUE(DefaultValueJson, '$.LocaleId'),0) LocaleId
			,IsNull(JSON_VALUE(DefaultValueJson, '$.Value'),'') Value
			,IsNull(JSON_VALUE(DefaultValueJson, '$.AttributeDefaultValue'),'') AttributeDefaultValue
			,Isnull(JSON_VALUE(DefaultValueJson, '$.DisplayOrder'),0) DisplayOrder
			,Isnull(JSON_VALUE(DefaultValueJson, '$.IsEditable'),'false') IsEditable
			,Isnull(JSON_VALUE(DefaultValueJson, '$.SwatchText'),'') SwatchText
			,Isnull(JSON_VALUE(DefaultValueJson, '$.Path'),'') Path
			FROM #PimAttributeDefaultXML ZPADV
			WHERE (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId) For JSON Auto 
			),'[]') 
		)  AttributeValue
		FROM ZnodePimAttributeValue ZPAV  With (NoLock)
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
		WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
	UNION ALL 
		SELECT DISTINCT  ZPAV.PimProductId,c.AttributeCode,
			JSON_MODIFY (JSON_MODIFY (Json_Query( c.AttributeJson  ) , '$.AttributeValues',  
			ISNULL((Select stuff( 
			(SELECT ','+ZPPG.MediaPath 
			FROM ZnodePimProductAttributeMedia ZPPG INNER JOIN  #TBL_AttributeVAlue TBLV ON 
			(	TBLV.PimProductId=  ZPAV.PimProductId AND TBLV.PimAttributeId = ZPAV.PimAttributeId )
			WHERE ZPPG.PimProductAttributeMediaId = TBLV.ZnodePimAttributeValueLocaleId
			FOR XML PATH(''),Type).value('.', 'varchar(max)'), 1, 1, '')),'') ) ,'$.SelectValues',Json_Query('[]'))   
			AS 'AttributeEntity'
		FROM ZnodePimAttributeValue ZPAV 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeMedia ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
	UNION ALL 
		SELECT ZPLP.PimParentProductId ,c.AttributeCode, 
			JSON_MODIFY( JSON_Modify(c.AttributeJson , '$.AttributeValues' , 
			ISNULL(SUBSTRING((SELECT ','+cast( LP.SKU as varchar(600)) 
							 FROM #LinkProduct LP
							 WHERE LP.PimParentProductId = ZPLP.PimParentProductId 
							 AND LP.PimAttributeId = ZPLP.PimAttributeId
		FOR XML PATH ('') ),2,4000),'')),'$.SelectValues',Json_Query('[]'))   
	
		FROM ZnodePimLinkProductDetail ZPLP 
		INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPLP.PimParentProductId)
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPLP.PimAttributeId )
		INNER JOIN #PimProductAttributeJson b ON (b.PimAttributeJsonId = c.PimAttributeJsonId )
		GROUP BY ZPLP.PimParentProductId , ZPP.PublishProductId  ,ZPLP.PimAttributeId,c.AttributeCode,c.AttributeJson,ZPP.PublishCatalogId
	UNION ALL 
		SELECT ZPAV.PimProductId,'DefaultSkuForConfigurable' ,
			JSON_MODIFY( JSON_Modify(
			REPLACE(REPLACE (c.AttributeJson,'ProductType','DefaultSkuForConfigurable'),'Product Type','Default Sku For Configurable'),
			'$.AttributeValues' , 
			ISNULL(SUBSTRING((SELECT ','+CAST(adl.AttributeValue AS VARCHAR(50)) 
		FROM ZnodePimAttributeValue ad 
		inner join ZnodePimAttributeValueLocale adl on ad.PimattributeValueId = adl.PimAttributeValueId
		INNER JOIN ZnodePimProductTypeAssociation yt ON (yt.PimProductId = ad.PimProductId)
		WHERE EXISTS (select * from #ProductIds p where yt.PimParentProductId = p.PimProductId)
		AND Ad.PimAttributeId =(select top 1 PimAttributeId from ZnodePimAttribute zpa where zpa.AttributeCode = 'SKU')
		AND yt.PimParentProductId = ZPAV.PimProductId 
		ORDER BY yt.DisplayOrder , yt.PimProductTypeAssociationId ASC FOR XML PATH ('') ),2,4000),'')),'$.SelectValues',Json_Query('[]'))   
		FROM ZnodePimAttributeValue ZPAV  
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
		INNER JOIN #ProductIds ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
		INNER JOIN ZnodePimAttributeDefaultValue dr ON (dr.PimAttributeDefaultValueId = ZPADVL.PimAttributeDefaultValueId)
		WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId
		AND dr.AttributeDefaultValueCode= 'ConfigurableProduct' 
		)
		AND EXISTS (select * from #PimProductAttributeJson b where b.PimAttributeJsonId = c.PimAttributeJsonId)
		AND c.AttributeCode = 'ProductType' 
	UNION ALL
		SELECT DISTINCT  UOP.PimProductId,c.AttributeCode,
			JSON_MODIFY (JSON_MODIFY (c.AttributeJson,'$.AttributeValues',''), '$.SelectValues',
			Isnull((SELECT  DISTINCT 
			Isnull(JSON_VALUE(AA.DefaultValueJson, '$.Code'),'') Code 
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.LocaleId'),0) LocaleId
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.Value'),'') Value
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.AttributeDefaultValue'),'') AttributeDefaultValue
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.DisplayOrder'),0) DisplayOrder
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.IsEditable'),'false') IsEditable
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.SwatchText'),'') SwatchText
			,Isnull(JSON_VALUE(AA.DefaultValueJson, '$.Path'),'') Path 
			,ISNULL(ZPA.DisplayOrder,0)  AS VariantDisplayOrder 
			,ISNULL(ZPAVL_SKU.AttributeValue,'')   AS VariantSKU 
			--,Isnull(ZM.Path,'') 
		,ZM.Path AS VariantImagePath 
		FROM ZnodePimAttributeDefaultJson AA 
		INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
		INNER JOIN ZnodePimAttributeValue ZPAV1 ON (ZPAV1.PimAttributeValueId= ZPADV.PimAttributeValueId )
		-- check/join for active variants 
		INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId =ZPAV1.PimProductId)
		INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPAV.PimAttributevalueid = ZPAVL.PimAttributeValueId AND ZPAVL.AttributeValue = 'True')
		INNER JOIN ZnodePimProductTypeAssociation YUP ON (YUP.PimProductId = ZPAV1.PimProductId)
		-- SKU
		INNER JOIN ZnodePimAttributeValue ZPAV_SKU ON(YUP.PimProductId = ZPAV_SKU.PimProductId)
		INNER JOIN ZnodePimAttributeValueLocale ZPAVL_SKU ON (ZPAVL_SKU.PimAttributeValueId = ZPAV_SKU.PimAttributeValueId)
		LEFT JOIN ZnodePimAttribute ZPA ON (ZPA.PimattributeId = ZPAV1.PimAttributeId)
		--VariantImagePath
		LEFT  JOIN ZnodePimAttributeValue ZPAV12 ON (ZPAV12.PimProductId= YUP.PimProductId  AND ZPAV12.PimAttributeId = @PimMediaAttributeId ) 
		LEFT JOIN ZnodePimProductAttributeMedia ZPAVM ON (ZPAVM.PimAttributeValueId= ZPAV12.PimAttributeValueId ) 
		LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = ZPAVM.MediaId)
		WHERE (YUP.PimParentProductId  = UOP.PimProductId AND ZPAV1.pimAttributeId = UOP.PimAttributeId )
		-- Active Variants
		AND ZPAV.PimAttributeId = (SELECT TOP 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'IsActive')
		-- VariantSKU
		AND ZPAV_SKU.PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'SKU')
		For JSON Auto 
		),'[]')) 
				
		--</AttributeEntity></Attributes>' 
		FROM ZnodePimConfigureProductAttribute UOP 
		INNER JOIN ZnodePimAttributeJSON c   ON (c.PimAttributeId = UOP.PimAttributeId )
		WHERE  exists(select * from #TBL_PublishCatalogId PPCP1 where UOP.PimProductId = PPCP1.PimProductId )
		AND EXISTS (select * from #PimProductAttributeJson b where b.PimAttributeJsonId = c.PimAttributeJsonId)

			-------------configurable attribute 
			---------------------------------------------------------------------
			
			If (@RevisionType like '%Preview%'  OR @RevisionType like '%Production%'  ) 
				Delete from ZnodePublishProductEntity where SKU  in (select SKU from #TBL_PublishCatalogId
				A inner join ZnodePublishProductDetail B on A.PublishProductId   =B.PublishProductId   )
				AND LocaleId = @LocaleId
				AND VersionId in (SELECT VersionId FROM ZnodePublishVersionEntity where RevisionType = 'PREVIEW')
			If (@RevisionType like '%Production%' OR @RevisionType = 'None')
				Delete from ZnodePublishProductEntity where SKU  in (select SKU from #TBL_PublishCatalogId
				A inner join ZnodePublishProductDetail B on A.PublishProductId   =B.PublishProductId   )
				AND LocaleId = @LocaleId
				AND VersionId in (SELECT VersionId FROM ZnodePublishVersionEntity where RevisionType = 'PRODUCTION')

			Insert into ZnodePublishProductEntity (
					VersionId, --1
					IndexId, --2 
					ZnodeProductId,ZnodeCatalogId, --3
					SKU,LocaleId, --4 
					Name,ZnodeCategoryIds, --5
					IsActive, -- 6 
					Attributes, -- 7 
					Brands, -- 9
					CategoryName, --9
					CatalogName,DisplayOrder, --10 
					RevisionType,AssociatedProductDisplayOrder, --11
					ProductIndex,--12
					SalesPrice,RetailPrice,CultureCode,CurrencySuffix,CurrencyCode,SeoDescription,SeoKeywords,SeoTitle,SeoUrl,ImageSmallPath,SKULower --13 
					)
 			SELECT distinct ZPVE.VersionId, --1 
			CAST(ISNULL(ZPCP.ProductIndex,1) AS VARCHAr(100)) + CAST(ISNULL(ZPC.PublishCategoryId,'')  AS VARCHAR(50))  + 
			CAST(Isnull(ZPP.PublishCatalogId ,'')  AS VARCHAR(50)) + CAST( @LocaleId AS VARCHAR(50)) IndexId, --2 
			CAST(ZPP.PublishProductId AS VARCHAR(50)) PublishProductId,CAST(ZPP.PublishCatalogId  AS VARCHAR(50)) PublishCatalogId,  --3 
			CAST(ISNULL(ZPPDFG.SKU ,'') AS NVARCHAR(2000)) SKU,CAST( Isnull(@LocaleId ,'') AS VARCHAR(50)) LocaleId, -- 4 
			CAST(isnull(ZPPDFG.ProductName,'') AS NVARCHAR(2000) )  ProductName ,CAST(ISNULL(ZPCD.PublishCategoryId,'')  AS VARCHAR(50)) PublishCategoryId  -- 5 
			,CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50)) IsActive , --6 
			'[' +
				(Select STUFF((SELECT distinct ','+ AttributeValue from #TBL_ZnodeTempPublish TY WHERE TY.PimProductId = ZPP.PimProductId   
				FOR XML Path ('')) ,1,1,'')  ) 
			+ ']' xmlvalue,  -- 7 
			'[]' Brands  --8 
			,CAST(isnull(PublishCategoryName,'') AS NVARCHAR(2000)) CategoryName  --9
			,CAST(Isnull(CatalogName,'')  AS NVARCHAR(2000)) CatalogName,CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50)) DisplayOrder  -- 10  
			,ZPVE.RevisionType RevisionType , 0 AssociatedProductDisplayOrder,-- pending  -- 11 
			Isnull(ZPCP.ProductIndex,1),  -- 12 

			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CAST(SalesPrice  AS varchar(500)),'') else '' end SalesPrice , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CAST(RetailPrice  AS varchar(500)),'') else '' end RetailPrice , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CultureCode ,'') else '' end CultureCode , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CurrencySuffix ,'') else '' end CurrencySuffix , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(CurrencyCode ,'') else '' end CurrencyCode , 
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEODescription,'') else '' end SEODescriptionForIndex,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEOKeywords,'') else '' end SEOKeywords,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEOTitle,'') else '' end SEOTitle,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(SEOUrl ,'') else '' end SEOUrl,
			Case When TBZP.IsAllowIndexing = 1 then  ISNULL(ImageSmallPath,'') else '' end ImageSmallPath,
			CAST(ISNULL(LOWER(ZPPDFG.SKU) ,'') AS NVARCHAR(100)) Lower_SKU -- 13
	FROM  #TBL_PublishCatalogId zpp
	INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
	INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)
	INNER JOIN ZnodePublishVersionEntity ZPVE ON (ZPVE.ZnodeCatalogId  = ZPP.PublishCatalogId AND ZPVE.IsPublishSuccess =1 AND ZPVE.LocaleId = @LocaleId )
	LEFT JOIN #ZnodePrice TBZP ON (TBZP.PublishProductId = ZPP.PublishProductId)
	LEFT JOIN #ProductSKU TBPS ON (TBPS.PublishProductId = ZPP.PublishProductId)
	LEFT JOIN #ProductImages TBPI ON (TBPI.PublishProductId = ZPP.PublishProductId  )
	LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
	LEFT JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCatalogId = ZPCP.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId)
	LEFT JOIN ZnodePimCategoryProduct ZPCCF ON (ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId )
	LEFT JOIN ZnodePimCategoryHierarchy ZPCH ON (ZPCH.PimCatalogId = ZPCV.PimCatalogId AND  ZPCH.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId) 
	LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ZPCP.PublishCategoryId AND ZPCD.LocaleId = @LocaleId )
	WHERE ZPPDFG.LocaleId = @LocaleId
		--AND zpp.LocaleId = @LocaleId
	AND 
		(
			(ZPVE.RevisionType =  Case when  (@RevisionType like '%Preview%'  OR @RevisionType like '%Production%' ) then 'Preview' End ) 
			OR 
			(ZPVE.RevisionType =  Case when (@RevisionType like '%Production%' OR @RevisionType = 'None') then  'Production'  end )
		)


	DELETE FROM #TBL_ZnodeTempPublish
	IF OBJECT_ID('tempdb..#PimProductAttributeJson') is not null
	 BEGIN 
		DELETE FROM #PimProductAttributeJson
	 END
	 IF OBJECT_ID('tempdb..#TBL_CustomeFiled') is not null
	 BEGIN 
	 DROP TABLE #TBL_CustomeFiled
	 END
	 IF OBJECT_ID('tempdb..#TBL_AttributeVAlue') is not null
	 BEGIN 
	 DROP TABLE #TBL_AttributeVAlue
	 END
 
	DELETE FROM @PimDefaultValueLocale
SET @Counter = @counter + 1 
END

SET @Status =1 

END TRY 
BEGIN CATCH 
	SET @Status =0  
	 SELECT 1 AS ID,@Status AS Status;   
	 DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
		@ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC [Znode_GetPublishSingleProductJson] 
		@PublishCatalogId = '+CAST(@PublishCatalogId  AS VARCHAR	(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10))
				
	EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'Znode_GetPublishSingleProductJson',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;
END CATCH
END

go
	
  IF exists(select * from sys.procedures where name = 'ZnodeGetMediaAttributeValues')
	drop proc ZnodeGetMediaAttributeValues
go

CREATE PROCEDURE [dbo].[ZnodeGetMediaAttributeValues]
( 
	@MediaID  INT = 0,
	@LocaleId INT = 1
)
AS
/*
Summary: This Procedure is used to get values of media attribute
Unit Testing:
Exec ZnodeGetMediaAttributeValues

*/
BEGIN
BEGIN TRY
SET NOCOUNT ON

	Declare @ServerPath varchar(500)
	SET @ServerPath = 
	(
		SELECT top 1 ZnodeMediaConfiguration.URL+ZnodeMediaServerMaster.ThumbnailFolderName    
		FROM [dbo].[ZnodeMediaServerMaster] 
		INNER JOIN [dbo].[ZnodeMediaConfiguration] on [dbo].[ZnodeMediaServerMaster].MediaServerMasterId=ZnodeMediaConfiguration.MediaServerMasterId 
		WHERE ZnodeMediaConfiguration.IsActive='True' 
	)

    DECLARE @AttributeValue TABLE
    (
		[MediaCategoryId]              [INT] NOT NULL,
		[MediaId]                      [INT] NULL,
		[MediaPathId]                  [INT] NULL,
		[MediaAttributeFamilyId]       [INT] NULL,
		[FamilyCode]                   [VARCHAR](200) NULL,
		[MediaAttributeId]             [INT] NULL,
		[AttributeTypeId]              [INT] NULL,
		[AttributeTypeName]            [VARCHAR](300) NULL,
		[AttributeCode]                [VARCHAR](300) NULL,
		[IsRequired]                   [BIT] NULL,
		[IsLocalizable]                [BIT] NULL,
		[IsFilterable]                 [BIT] NULL,
		[AttributeName]                [NVARCHAR](300) NULL,
		[AttributeValue]               [VARCHAR](300) NULL,
		[MediaAttributeValueId]        [INT] NULL,
		[MediaAttributeDefaultValueId] [INT] NULL,
		[DefaultAttributeValue]        [NVARCHAR](300) NULL,
		[MediaPath]                    [VARCHAR](8000) NULL,
		[RowId]                        [INT] NOT NULL,
		[IsEditable]                   [BIT] NOT NULL,
		[ControlName]                  [VARCHAR](300) NULL,
		[ValidationName]               [VARCHAR](100) NULL,
		[SubValidationName]            [VARCHAR](300) NULL,
		[RegExp]                       [VARCHAR](300) NULL,
		[ValidationValue]              [VARCHAR](300) NULL,
		[IsRegExp]                     [BIT] NULL,
		[AttributeGroupName]           [NVARCHAR](300) NULL,
		DisplayOrder                   INT,
		[HelpDescription]              [NVARCHAR](MAX) NULL,
		GroupDisplayOrder              INT,
		MediaAttributeThumbnailPath    varchar(1000)
    );
    INSERT INTO @AttributeValue([MediaCategoryId]  ,[MediaId],[MediaPathId],[MediaAttributeFamilyId] ,[FamilyCode],[MediaAttributeId] ,           
				[AttributeTypeId],[AttributeTypeName] ,[AttributeCode] ,[IsRequired],[IsLocalizable],[IsFilterable] ,               
				[AttributeName],[AttributeValue],[MediaAttributeValueId],[MediaAttributeDefaultValueId],[DefaultAttributeValue],       
				[MediaPath],[RowId],[IsEditable] ,[ControlName] ,[ValidationName],[SubValidationName],[RegExp],[ValidationValue],             
				[IsRegExp],[AttributeGroupName],DisplayOrder,[HelpDescription] ,GroupDisplayOrder )
    SELECT DISTINCT
            a.MediaCategoryId,
            a.MediaId,
            a.MediaPathId,
            a.MediaAttributeFamilyId,
            qq.FamilyCode,
            c.MediaAttributeId,
            c.AttributeTypeId,
            Q.AttributeTypeName,
            c.AttributeCode,
            c.IsRequired,
            c.IsLocalizable,
            c.IsFilterable,
            f.AttributeName,
            b.AttributeValue,
            b.MediaAttributeValueId,
            h.MediaAttributeDefaultValueId,
            g.DefaultAttributeValue,
            dbo.Fn_ZnodeMediaRecurcivePath(a.MediaPathId, @LocaleId) AS MediaPath,
            ISNULL(NULL, 0) AS RowId,
            ISNULL(h.IsEditable, 1) AS IsEditable,
            i.ControlName,
            i.Name AS ValidationName,
            j.ValidationName AS SubValidationName,
            j.RegExp,
            k.Name AS ValidationValue,
            CAST(CASE
                    WHEN j.RegExp IS NULL
                    THEN 0
                    ELSE 1
                END AS BIT) AS IsRegExp,
            Zmagm.AttributeGroupName,
            c.DisplayOrder,
            c.HelpDescription,
            Zmag.DisplayOrder	
    FROM [dbo].[ZnodeMediaCategory] AS a
            INNER JOIN dbo.ZnodeMediaAttributeFamily AS qq ON(a.MediaAttributeFamilyId = qq.MediaAttributeFamilyId)
            INNER JOIN dbo.ZnodeMediaFamilyGroupMapper AS w ON(qq.MediaAttributeFamilyId = w.MediaAttributeFamilyId)
            INNER JOIN dbo.ZnodeMediaAttributeGroupMapper AS t ON(t.MediaAttributeGroupId = w.MediaAttributeGroupId)
            INNER JOIN dbo.ZnodeMediaAttributeGroup AS Zmag ON(t.MediaAttributeGroupId = Zmag.MediaAttributeGroupId
                                                            AND Zmag.IsHidden = 0)
            INNER JOIN ZnodeMediaAttributeGroupLocale AS Zmagm ON t.MediaAttributeGroupId = Zmagm.MediaAttributeGroupId
                                                                AND Zmagm.LocaleId = @LocaleId
            LEFT JOIN [dbo].[ZnodeMediaAttributeValue] AS b ON(t.MediaAttributeId = b.MediaAttributeId
                                                            AND a.MediaCategoryId = b.MediaCategoryId)
            LEFT JOIN [dbo].[ZnodeMediaAttribute] AS c ON(c.MediaAttributeId = t.MediaAttributeId)
            LEFT JOIN [dbo].ZnodeAttributeType AS q ON(c.AttributeTypeId = Q.AttributeTypeId)
            LEFT JOIN [dbo].[ZnodeMediaAttributeLocale] AS f ON(c.MediaAttributeId = f.MediaAttributeId
                                                                AND f.LocaleId = @LocaleId)
            LEFT JOIN [dbo].[ZnodeMediaAttributeDefaultValue] AS h ON(h.MediaAttributeDefaultValueId = b.MediaAttributeDefaultValueId
                                                                    OR h.MediaAttributeId = t.MediaAttributeId)
            LEFT JOIN [dbo].[ZnodeMediaAttributeDefaultValueLocale] AS g ON(h.MediaAttributeDefaultValueId = g.MediaAttributeDefaultValueId
                                                                            AND g.LocaleId = @LocaleId)
            LEFT JOIN [dbo].ZnodeMediaAttributeValidation AS k ON(k.MediaAttributeId = c.MediaAttributeId)
            LEFT JOIN [dbo].ZnodeAttributeInputValidation AS i ON(k.InputValidationId = i.InputValidationId)
            LEFT JOIN [dbo].ZnodeAttributeInputValidationRule AS j ON(k.InputValidationRuleId = j.InputValidationRuleId)			
	WHERE CASE WHEN @MediaID = 0 THEN  0 ELSE  a.MediaId END  = ISNULL(@MediaID, 0);

	update a set MediaAttributeThumbnailPath = @ServerPath+'/'+ZM.Path+'?'+'V='+cast(ZM.Version as varchar(10))
	from @AttributeValue a
	INNER JOIN ZnodeMedia ZM ON a.AttributeValue = ZM.MediaId 
	where a.AttributeTypeName = 'Image' 

    SELECT MediaCategoryId,
        MediaId,
        MediaPathId,
        MediaAttributeFamilyId,
        FamilyCode,
        MediaAttributeId,
        AttributeTypeId,
        AttributeTypeName,
        AttributeCode,
        IsRequired,
        IsLocalizable,
        IsFilterable,
        AttributeName,
        AttributeValue,
        MediaAttributeValueId,
        MediaAttributeDefaultValueId,
        DefaultAttributeValue,
        MediaPath,
        RowId,
        IsEditable,
        ControlName,
        ValidationName,
        SubValidationName,
        RegExp,
        ValidationValue,
        IsRegExp,
        AttributeGroupName,
        HelpDescription,
        GroupDisplayOrder,
		MediaAttributeThumbnailPath
		--@ServerPath+'/'+ZM.Path+'?'+'V='+cast(ZM.Version as varchar(10)) as MediaAttributeThumbnailPath			
    FROM @AttributeValue
	
    ORDER BY GroupDisplayOrder,
            DisplayOrder;
			
END TRY
BEGIN CATCH
		DECLARE @Status BIT ;
		SET @Status = 0;
		DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeGetMediaAttributeValues @MediaID = '+CAST(@MediaID AS VARCHAR(100))+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
        SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
        EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'ZnodeGetMediaAttributeValues',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;
END CATCH
END;


go
	
  IF exists(select * from sys.procedures where name = 'Znode_ImportCustomer')
	drop proc Znode_ImportCustomer
go

CREATE PROCEDURE [dbo].[Znode_ImportCustomer](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @LocaleId int= 0,@PortalId int ,@CsvColumnString nvarchar(max))
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import SEO Details
	
	-- Unit Testing : 
	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max),@AspNetZnodeUserId nvarchar(256),@ASPNetUsersId nvarchar(256),
		@PasswordHash nvarchar(max),@SecurityStamp nvarchar(max),@RoleId nvarchar(256),@IsAllowGlobalLevelUserCreation nvarchar(10)
		Declare @ProfileId  int
		DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		 
		SET @SecurityStamp = '0wVYOZNK4g4kKz9wNs-UHw2'
		SET @PasswordHash = 'APy4Tm1KbRG6oy7h3r85UDh/lCW4JeOi2O2Mfsb3OjkpWTp1YfucMAvvcmUqNaSOlA==';
		SELECT  @RoleId  = Id from AspNetRoles where   NAME = 'Customer'  

		Select @IsAllowGlobalLevelUserCreation = FeatureValues from ZnodeGlobalsetting where FeatureName = 'AllowGlobalLevelUserCreation'

		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive RoundOff Value from global setting 

		-- Three type of import required three table varible for product , category and brand
		DECLARE @InsertCustomer TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, UserName nvarchar(512) ,FirstName	nvarchar(200),
			LastName nvarchar(200), BudgetAmount	numeric,Email	nvarchar(100),PhoneNumber	nvarchar(100),
		    EmailOptIn	bit	,ReferralStatus	nvarchar(40),IsActive	bit	,ExternalId	nvarchar(max),CreatedDate Datetime,
			ProfileName varchar(200),AccountCode nvarchar(100),DepartmentName varchar(300),RoleName nvarchar(256), GUID NVARCHAR(400)
			,PerOrderLimit int,
				PerOrderAnnualLimit nvarchar(100),
				BillingAccountNumber nvarchar(100),
				EnableUserShippingAddressSuggestion  nvarchar(100),
				EnablePowerBIReportOnWebStore bit
		);

			--SET @SSQL = 'SELECT RowNumber,UserName,FirstName,LastName,BudgetAmount,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId,GUID FROM '+ @TableName;
		SET @SSQL = 'SELECT RowNumber,' + @CsvColumnString + ',GUID FROM '+ @TableName;
		INSERT INTO @InsertCustomer( RowNumber,UserName,FirstName,LastName,Email,PhoneNumber, EmailOptIn,IsActive,ExternalId,CreatedDate,ProfileName,AccountCode,DepartmentName,RoleName 
										,PerOrderAnnualLimit
										,BillingAccountNumber
										,EnableUserShippingAddressSuggestion
										,EnablePowerBIReportOnWebStore
										,PerOrderLimit,GUID)
		EXEC sys.sp_sqlexec @SSQL;
		
		
		select TOP 1 @ProfileId   =  ProfileId from ZnodePortalprofile where Portalid = @Portalid and IsDefaultRegistedProfile=1
		If( Isnull(@ProfileId ,0) = 0 ) 
		Begin
		
		
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '62', 'Default Portal Profile', '', @NewGUId, 1 , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
							
				UPDATE ZnodeImportProcessLog
				SET Status = dbo.Fn_GetImportStatus( 3 ), ProcessCompletedDate = @GetDate
				WHERE ImportProcessLogId = @ImportProcessLogId;
			

				SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog 
				WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
				Select @SuccessRecordCount = 0

				UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount , 
				TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0))
				WHERE ImportProcessLogId = @ImportProcessLogId;

				DELETE FROM @InsertCustomer 
				SET @Status = 0;

				COMMIT TRAN A;
				Return 0 
		End
	
	    -- start Functional Validation 

		-----------------------------------------------
		--If @IsAllowGlobalLevelUserCreation = 'false'
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			    WHERE ltrim(rtrim(ii.UserName)) in 
		--			   (
		--				   SELECT UserName FROM AspNetZnodeUser   where PortalId = @PortalId
		--			   );
		--Else 
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			   WHERE ltrim(rtrim(ii.UserName)) in 
		--			   (
		--				   SELECT UserName FROM AspNetZnodeUser   
		--			   );
		
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '35', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomer AS ii
					   WHERE ii.UserName not like '%_@_%_.__%' 
				
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '30', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomer AS ii
					   WHERE ltrim(rtrim(ii.UserName)) in 
					   (SELECT ltrim(rtrim(UserName))  FROM @InsertCustomer group by ltrim(rtrim(UserName))  having count(*) > 1 )

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				select '77', 'AccountCode', ii.AccountCode, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				from @InsertCustomer ii 
				where isnull(ltrim(rtrim(ii.AccountCode)),'') !='' 
				and not exists(select * from ZnodeAccount za inner join ZnodePortalAccount zpa on za.AccountId = zpa.AccountId
					where  isnull(ltrim(rtrim(ii.AccountCode)),'') = za.AccountCode and zpa.PortalId = @PortalId )
				and exists(SELECT isnull(ltrim(rtrim(AccountCode)),'') FROM ZnodeAccount za1 where isnull(ltrim(rtrim(ii.AccountCode)),'') = za1.AccountCode );

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '73', 'AccountCode', AccountCode, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE   isnull(ltrim(rtrim(ii.AccountCode)),'') !=''   and isnull(ltrim(rtrim(ii.AccountCode)),'') not in 
				(
					SELECT isnull(ltrim(rtrim(AccountCode)),'') FROM ZnodeAccount   
				);

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '88', 'AccountCode', AccountCode, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE   isnull(ltrim(rtrim(ii.AccountCode)),'') !='' and  exists
				(
					SELECT top 1 1 FROM  AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	 
				inner join ZnodeAccount ZA on  ZU.AccountId = ZA.AccountId
				where ANZU.UserName = ii.UserName and  ZA.AccountCode != ii.AccountCode
				);

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '92', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				where isnull(ltrim(rtrim(ii.RoleName)),'') <> '' and  isnull(ltrim(rtrim(ii.RoleName)),'') in ('User','Manager','Administrator')
				and exists(select * from ZnodeUser a INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
						inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
						--inner join @InsertCustomer IC on (IC.UserName = c.UserName)						
						inner join AspNetUserRoles u on u.UserId = b.Id
						inner join AspNetRoles ZD on u.RoleId = zd.Id
						where (ii.UserName = c.UserName) and isnull(ltrim(rtrim(ii.RoleName)),'') <> ZD.Name )

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '75', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE   isnull(ltrim(rtrim(ii.AccountCode)),'') ='' and isnull(ltrim(rtrim(RoleName)),'') <> '' 

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '74', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE --ltrim(rtrim(ii.RoleName)) not in ('User','Manager','Administrator') and isnull(ltrim(rtrim(RoleName)),'') <> '' and
				 isnull(ltrim(rtrim(RoleName)),'') <> '' and not exists (select top 1 1 from  AspNetRoles ANR where name in ('User','Manager','Administrator') and  ANR.name =ii.RoleName)


				--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				--SELECT '75', 'RoleName', RoleName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				--FROM @InsertCustomer AS ii
				--WHERE  isnull(ltrim(rtrim(AccountCode)),'') != '' and isnull(ltrim(rtrim(RoleName)),'') <> ''

				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '76', 'DepartmentName', DepartmentName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM @InsertCustomer AS ii
				WHERE isnull(ltrim(rtrim(ii.DepartmentName)),'') <> ''
				and not exists(select * from  ZnodeAccount ZA inner join ZnodeDepartment ZD on ZA.AccountId = ZD.AccountId
					where isnull(ltrim(rtrim(ii.AccountCode)),'') = ltrim(rtrim(za.AccountCode))
					and isnull(ltrim(rtrim(ii.DepartmentName)),'') = ltrim(rtrim(ZD.DepartmentName)))
				

		 UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ UserName - ' + ISNULL(UserName,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN @InsertCustomer IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL

		--Note : Content page import is not required 
		
		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  

		DELETE FROM @InsertCustomer
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);


		-- Update Record count in log 
        
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertCustomer
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount , 
		TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0))
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End

		-- Insert Product Data 
				
				
				DECLARE @InsertedAspNetZnodeUser TABLE (AspNetZnodeUserId nvarchar(256) ,UserName nvarchar(512),PortalId int )
				DECLARE @InsertedASPNetUsers TABLE (Id nvarchar(256) ,UserName nvarchar(512))
				DECLARE @InsertZnodeUser TABLE (UserId int,AspNetUserId nvarchar(256),CreatedDate Datetime )

				UPDATE ANU SET 
				ANU.PhoneNumber	= IC.PhoneNumber, ANU.LockoutEndDateUtc = case when IC.IsActive = 0 then @GetDate when IC.IsActive = 1 then null else ANU.LockoutEndDateUtc end
				from AspNetZnodeUser ANZU 
				INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(ANZU.PortalId,0) end = case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(@PortalId ,0) end
				----Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				UPDATE ZU SET 
				ZU.FirstName	= IC.FirstName,
				ZU.LastName		= IC.LastName,
				--ZU.MiddleName	= IC.MiddleName,
				ZU.BudgetAmount = IC.BudgetAmount,
				ZU.Email		= IC.Email,
				ZU.PhoneNumber	= IC.PhoneNumber,
				ZU.EmailOptIn	= Isnull(IC.EmailOptIn,0),
				ZU.IsActive		= IC.IsActive
				--ZU.ExternalId = ExternalId
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(ANZU.PortalId,0) end = case when @IsAllowGlobalLevelUserCreation = 'true' then -1 else Isnull(@PortalId ,0) end
				--where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				Insert into AspNetZnodeUser (AspNetZnodeUserId, UserName, PortalId)		
				OUTPUT INSERTED.AspNetZnodeUserId, INSERTED.UserName, INSERTED.PortalId	INTO  @InsertedAspNetZnodeUser 			 
				Select NEWID(),IC.UserName, @PortalId FROM @InsertCustomer IC 
				where Not Exists (Select TOP 1 1  from AspNetZnodeUser ANZ 
				where Isnull(ANZ.PortalId,0) = Isnull(@PortalId,0) AND ANZ.UserName = IC.UserName)

				INSERT INTO ASPNetUsers (Id,Email,EmailConfirmed,PasswordHash,SecurityStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,
				LockoutEndDateUtc,LockOutEnabled,AccessFailedCount,PasswordChangedDate,UserName)
				output inserted.Id, inserted.UserName into @InsertedASPNetUsers
				SELECT NewId(), Email,0 ,@PasswordHash,@SecurityStamp,PhoneNumber,0,0,case when A.IsActive = 0 then @GetDate else null end LockoutEndDateUtc,1 LockoutEnabled,
				0,@GetDate,AspNetZnodeUserId from @InsertCustomer A INNER JOIN @InsertedAspNetZnodeUser  B 
				ON A.UserName = B.UserName
				
				INSERT INTO  ZnodeUser(AspNetUserId,FirstName,LastName,CustomerPaymentGUID,Email,PhoneNumber,EmailOptIn,
				IsActive,ExternalId, CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,UserName)
				OUTPUT Inserted.UserId, Inserted.AspNetUserId,Inserted.CreatedDate into @InsertZnodeUser
				SELECT IANU.Id AspNetUserId ,IC.FirstName,IC.LastName,null CustomerPaymentGUID,IC.Email
				,IC.PhoneNumber,Isnull(IC.EmailOptIn,0),IC.IsActive,IC.ExternalId, @UserId,
				CASE WHEN IC.CreatedDate IS NULL OR IC.CreatedDate = '' THEN  @Getdate ELSE IC.CreatedDate END,
				@UserId,@Getdate,IC.UserName
				from @InsertCustomer IC Inner join 
				@InsertedAspNetZnodeUser IANZU ON IC.UserName = IANZU.UserName  INNER JOIN 
				@InsertedASPNetUsers IANU ON IANZU.AspNetZnodeUserId = IANU.UserName 
				  	     
				INSERT INTO AspNetUserRoles (UserId,RoleId)  Select AspNetUserId, @RoleID from @InsertZnodeUser 
				INSERT INTO ZnodeUserPortal (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
				SELECT UserId, @PortalId , @UserId, IZU.CreatedDate,@UserId,@Getdate 
				from @InsertZnodeUser IZU

				insert into ZnodeAccountUserPermission(UserId,AccountPermissionAccessId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT UserId, 4 , @UserId, @Getdate,@UserId,@Getdate 
				from @InsertZnodeUser IZU
				--Declare @ProfileId  int 
				--select TOP 1 @ProfileId   =  ProfileId from ZnodePortalprofile where Portalid = @Portalid and IsDefaultRegistedProfile=1

				--insert into ZnodeUserProfile (ProfileId,UserId,IsDefault,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				--SELECT @ProfileId  , UserId, 1 , @UserId,CreatedDate,@UserId,@Getdate from @InsertZnodeUser


------------insert into ZnodeUserGlobalAttributeValue
	
				IF OBJECT_ID('tempdb..#globaldata') IS NOT NULL DROP TABLE #globaldata
				select ZU.userid,PerOrderLimit,
									PerOrderAnnualLimit,
									BillingAccountNumber,
									EnableUserShippingAddressSuggestion,
									EnablePowerBIReportOnWebStore 
									into #globaldata
				from znodeuser ZU inner join  @InsertCustomer IC on IC.Email =ZU.EMAIL
				where ZU.userid in (select userid from @InsertZnodeUser)
				group by ZU.userid,PerOrderLimit,
									PerOrderAnnualLimit,
									BillingAccountNumber,
									EnableUserShippingAddressSuggestion,
									EnablePowerBIReportOnWebStore 

				IF OBJECT_ID('tempdb..#globaldata1') IS NOT NULL DROP TABLE #globaldata1
				select * into #globaldata1 from (select userid, Cast(PerOrderLimit as varchar(100)) PerOrderLimit,
				 Cast(PerOrderAnnualLimit as varchar(100)) PerOrderAnnualLimit,
				 Cast(BillingAccountNumber as varchar(100)) BillingAccountNumber,
				 Cast(case when cast(EnableUserShippingAddressSuggestion as varchar(10))= '1' or cast(EnableUserShippingAddressSuggestion as varchar(10)) ='YES' or  cast(EnableUserShippingAddressSuggestion as varchar(10)) ='True' then 'True' else 'False'  end  as varchar(100)) EnableUserShippingAddressSuggestion,
				 Cast(case when cast(EnablePowerBIReportOnWebStore as varchar(10))= '1'  or cast(EnablePowerBIReportOnWebStore as varchar(10)) ='YES' or  cast(EnablePowerBIReportOnWebStore as varchar(10)) ='True' then 'True' else 'False' end  as varchar(100)) EnablePowerBIReportOnWebStore from #globaldata) ab
				UNPIVOT  
				   (avalue FOR acode IN   
					  (PerOrderLimit,
				PerOrderAnnualLimit,
				BillingAccountNumber,
				EnableUserShippingAddressSuggestion,
				EnablePowerBIReportOnWebStore)  
				)AS unpvt;  

				insert into ZnodeUserGlobalAttributeValue (UserId,	GlobalAttributeId,	GlobalAttributeDefaultValueId,	AttributeValue,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
				Select g.Userid,ZGA.GlobalAttributeId,null,null,@UserId,@Getdate,@UserId,@Getdate
					from #globaldata1 g inner join ZnodeGlobalAttribute ZGA on ZGA.AttributeCode =g.acode
					where not exists (select top 1 1 from ZnodeUserGlobalAttributeValue ZGAV where ZGAV.Userid =g.Userid and ZGA.GlobalAttributeId=ZGAV.GlobalAttributeId)

				insert into ZnodeUserGlobalAttributeValuelocale(UserGlobalAttributeValueId,	LocaleId,	AttributeValue,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate,	GlobalAttributeDefaultValueId,	MediaId,	MediaPath)
				select UserGlobalAttributeValueId, @LocaleId,avalue ,@UserId,@Getdate,@UserId,@Getdate,null,null,null
					from ZnodeUserGlobalAttributeValue ZUGAV inner join #globaldata1 g on ZUGAV.userid =g.userid
						inner join ZnodeGlobalAttribute ZGA on ZGA.AttributeCode =g.acode and ZGA.GlobalAttributeId = ZUGAV.GlobalAttributeId
						where not exists (select Top 1 1 from ZnodeUserGlobalAttributeValuelocale z where z.UserGlobalAttributeValueId = ZUGAV.UserGlobalAttributeValueId)

---------------------------------------------------------------------------------

				declare @Profile table (ProfileId int)

				INSERT INTO ZnodeProfile (ProfileName,ShowOnPartnerSignup,Weighting,TaxExempt,DefaultExternalAccountNo,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ParentProfileId)
				OUTPUT inserted.ProfileId INTO @Profile(ProfileId)
				SELECT Distinct ProfileName, 0, null,0, replace(ltrim(rtrim(ProfileName)),' ','') as DefaultExternalAccountNo, @UserId,@Getdate, @UserId,@Getdate, null as ParentProfileId				
				from @InsertCustomer IC
				where not exists(select * from ZnodeProfile ZP where IC.ProfileName = ZP.ProfileName )
				AND ISNULL(ic.ProfileName,'') <> ''

				INSERT INTO ZnodePortalProfile (PortalId,	ProfileId,	IsDefaultAnonymousProfile,	IsDefaultRegistedProfile,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
				SELECT @PortalId, ProfileId, 0 AS IsDefaultAnonymousProfile, 0 AS IsDefaultRegistedProfile, @UserId,@Getdate, @UserId,@Getdate
				from @Profile

				UPDATE ZnodeUserProfile 
				SET ProfileId = COALESCE(ZP.ProfileId,@ProfileId)
				FROM ZnodeUser a
				inner join ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join ZnodeUserProfile u ON u.UserId = a.UserId
				LEFT join ZnodeProfile ZP on IC.ProfileName = ZP.ProfileName
				--where IC.ProfileName <> ''
				
				INSERT INTO ZnodeUserProfile (ProfileId,UserId,IsDefault,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT COALESCE(ZP.ProfileId,@ProfileId)  , a.UserId, 1 , @UserId,a.CreatedDate,@UserId,@Getdate 
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				LEFT join ZnodeProfile ZP on IC.ProfileName = ZP.ProfileName
				where NOT EXISTS (SELECT TOP  1 1 FROM ZnodeUserProfile u WHERE u.UserId = a.UserId )
				AND EXISTS(SELECT * FROM @InsertZnodeUser IZU WHERE A.UserId = IZU.UserId)

				---to update accountid agaist user
				UPDATE ZU SET ZU.AccountId = ZA.AccountId 
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	 
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName
				INNER JOIN ZnodeAccount ZA ON ZA.AccountCode = IC.AccountCode 
				--inner join @InsertZnodeUser IZU on IZU.UserId =ZU.UserId
				where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0) and isnull(IC.AccountCode,'') <> ''
				
				update ZDU set ZDU.DepartmentId = ZD.DepartmentId, ModifiedBy = @UserId, ModifiedDate = @Getdate
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join ZnodeDepartment ZD on IC.DepartmentName = ZD.DepartmentName
				inner join ZnodeDepartmentUser ZDU on ZDU.UserId = a.UserId
				where isnull(IC.DepartmentName,'') <> ''

				insert into ZnodeDepartmentUser(UserId,DepartmentId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT a.UserId, ZD.DepartmentId, @UserId,a.CreatedDate,@UserId,@Getdate 
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join ZnodeDepartment ZD on IC.DepartmentName = ZD.DepartmentName
				where NOT EXISTS (SELECT TOP  1 1 FROM ZnodeDepartmentUser u WHERE u.UserId = a.UserId)
				AND isnull(IC.DepartmentName,'') <> ''
		
				update u set u.RoleId = ZD.Id
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join AspNetRoles ZD on IC.RoleName = ZD.Name
				inner join AspNetUserRoles u on u.UserId = b.Id
				where isnull(IC.RoleName,'') <> ''
				
				insert into AspNetUserRoles(UserId,RoleId)
				SELECT b.Id as ASPNetUserId, ZD.Id as RoleId
				from ZnodeUser a
				INNER JOIN ASPNetUsers b on (b.Id = a.AspNetUserId)
				inner join AspNetZnodeUser c on (c.AspNetZnodeUserId = b.UserName)
				inner join @InsertCustomer IC on (IC.UserName = c.UserName)
				inner join AspNetRoles ZD on IC.RoleName = ZD.Name
				where NOT EXISTS (SELECT TOP  1 1 FROM AspNetUserRoles u WHERE u.UserId = b.Id)
				AND EXISTS(SELECT * FROM @InsertZnodeUser IZU WHERE A.UserId = IZU.UserId)
				AND isnull(IC.RoleName,'') <> ''


		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;

		COMMIT TRAN A;
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN A;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 3 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;

		SET @Status = 0;
		SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE();
		
		 DECLARE @Error_procedure VARCHAR(8000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ImportCustomer @TableName = '+CAST(@TableName AS VARCHAR(max))+',@UserId = '+CAST(@UserId AS VARCHAR(50))+',@ImportProcessLogId='+CAST(@ImportProcessLogId AS VARCHAR(10))+',@PortalId='+CAST(@PortalId AS VARCHAR(10))+',@CsvColumnString='+CAST(@CsvColumnString AS VARCHAR(max));
              			
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ImportCustomer',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END;

go
	
  IF exists(select * from sys.procedures where name = 'Znode_SetPublishSEOEntity')
	drop proc Znode_SetPublishSEOEntity
go

CREATE PROCEDURE [dbo].[Znode_SetPublishSEOEntity]
(
   @PortalId  INT = 0 
  ,@LocaleId  INT = 0 
  ,@IsPreviewEnable int = 0 
  ,@PreviewVersionId INT = 0 
  ,@ProductionVersionId INT = 0 
  ,@RevisionState varchar(50) = '' 
  ,@CMSSEOTypeId varchar(500) = '' 
  ,@CMSSEOCode varchar(300) = ''
  ,@UserId int = 0 
  ,@Status int OUTPUT 
  ,@IsCatalogPublish bit = 0 
  ,@VersionIdString varchar(300) = ''
  ,@IsSingleProductPublish bit = 0 
)
AS
/*
    This Procedure is used to publish the blog news against the store 
  
	EXEC ZnodeSetPublishSEOEntity 1 2,3
	A. 
		1. Preview - Preview
		2. None    - Production   --- 
		3. Production - Preview/Production
	B.
		select * from ZnodePublishStateApplicationTypeMapping
		select * from ZnodePublishState where PublishStateId in (3,4) 
		select * from ZnodePublishPortalLog 
	C.
		Select * from ZnodePublishState where IsDefaultContentState = 1  and IsContentState = 1  --Production 
    
	Unit testing 
	
	Exec [ZnodeSetPublishSEOEntity]
	   @PortalId  = 1 
	  ,@LocaleId  = 0 
	  ,@PreviewVersionId = 0 
	  ,@ProductionVersionId = 0 
	  ,@RevisionState = 'Preview/Production' 
	  ,@CMSSEOTypeId = 0
	  ,@CMSSEOCode = ''
	  ,@UserId = 0 

	 Exec [ZnodeSetPublishSEOEntity]
   @PortalId  = 1 
  ,@LocaleId  = 0 
  ,@PreviewVersionId = 0 
  ,@ProductionVersionId = 0 
  ,@RevisionState = 'Preview&Production' 
  ,@CMSSEOTypeId = 3
  ,@CMSSEOCode = ''
  ,@UserId = 0 




	
	*/
BEGIN 
BEGIN TRY 
SET NOCOUNT ON
   Begin 
		DECLARE @Tbl_PreviewVersionId    TABLE    (PreviewVersionId int , PortalId int , LocaleId int)
		DECLARE @Tbl_ProductionVersionId TABLE    (ProductionVersionId int  , PortalId int , LocaleId int)
		If (@IsCatalogPublish = 0  AND @IsSingleProductPublish = 0 )
		Begin
			If @PreviewVersionId = 0 
				Begin
   					Insert into @Tbl_PreviewVersionId 
					SELECT distinct VersionId , PortalId, LocaleId from  ZnodePublishWebStoreEntity where (PortalId = @PortalId or @PortalId=0 ) and  (LocaleId = 	@LocaleId OR @LocaleId = 0  ) and PublishState ='PREVIEW'
				end
			Else 
					Insert into @Tbl_PreviewVersionId SELECT distinct VersionId , PortalId, LocaleId from  ZnodePublishWebStoreEntity 
					where VersionId = @PreviewVersionId
			If @ProductionVersionId = 0 
   				Begin
					Insert into @Tbl_ProductionVersionId 
					SELECT distinct VersionId , PortalId , LocaleId from  ZnodePublishWebStoreEntity where (PortalId = @PortalId or @PortalId=0 ) and  (LocaleId = 	@LocaleId OR @LocaleId = 0  ) and PublishState ='PRODUCTION'
				End 
			Else 
				Insert into @Tbl_ProductionVersionId SELECT distinct VersionId , PortalId, LocaleId from  ZnodePublishWebStoreEntity 
				where VersionId = @ProductionVersionId
 		End
		Else if (@IsCatalogPublish= 1  AND @IsSingleProductPublish = 0 )
		Begin
			 IF OBJECT_ID('tempdb..#VesionIds') is not null
				DROP TABLE #VesionIds
  				 
			 SELECT PV.* into #VesionIds FROM ZnodePublishVersionEntity PV Inner join Split(@VersionIdString,',') S ON PV.VersionId = S.Item
		End
		
		DECLARE @SetLocaleId INT , @DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleId(), @MaxCount INT =0 , @IncrementalId INT = 1  
		DECLARE @TBL_Locale TABLE (LocaleId INT , RowId INT IDENTITY(1,1))
		DECLARE @TBL_SEO TABLE 
		(
			ItemName varchar(50),CMSSEODetailId int ,CMSSEODetailLocaleId int ,CMSSEOTypeId int ,SEOId int ,SEOTypeName varchar(50),SEOTitle nvarchar(Max)
			,SEODescription nvarchar(Max),
			SEOKeywords nvarchar(Max),SEOUrl nvarchar(Max) ,IsRedirect bit ,MetaInformation nvarchar(Max) ,LocaleId int ,
			OldSEOURL nvarchar(Max),CMSContentPagesId int ,PortalId int ,SEOCode varchar(300) ,CanonicalURL varchar(200),RobotTag varchar(50)
		)
		
		BEGIN 
			INSERT INTO @TBL_Locale (LocaleId) SELECT LocaleId FROM ZnodeLocale WHERE IsActive =1 AND (LocaleId  = @LocaleId OR @LocaleId = 0 )
			
			SET @MaxCount = ISNULL((SELECT MAx(RowId) FROM @TBL_Locale),0)
			WHILE @IncrementalId <= @MaxCount
			BEGIN 
				SET @SetLocaleId = (SELECT Top 1 LocaleId FROM @TBL_locale WHERE RowId = @IncrementalId)
				IF @IsSingleProductPublish = 0
				Begin
					;With Cte_GetCMSSEODetails AS 
					(
							select CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
									 CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
									 CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
									 CDL.LocaleId,
									 NULL OldSEOURL, 
									 NULL CMSContentPagesId,CD.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
									 from ZnodeCMSSEODetail CD 
									 INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
									 INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId 
									 WHERE (CDL.LocaleId = @SetLocaleId OR CDL.LocaleId = @DefaultLocaleId)  
									 AND (CD.PortalId = @PortalId  OR @PortalId  = 0 ) 
									 AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
									 AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CD.CMSSEOTypeId ) )
									union all
									select CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
										 CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
										 CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
										 CDL.LocaleId,
										 NULL OldSEOURL, 
										 NULL CMSContentPagesId,ZPB.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
										 from ZnodeCMSSEODetail CD 
										 INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
										 INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId
										 INNER JOIN ZnodeBrandDetails ZBD ON CD.SeoCode = ZBD.BrandCode
										 INNER JOIN ZnodePortalBrand ZPB ON ZBD.BrandId = ZPB.BrandId
										 WHERE (CDL.LocaleId = @SetLocaleId OR CDL.LocaleId = @DefaultLocaleId)  
										 AND (ZPB.PortalId = @PortalId  OR @PortalId  = 0 ) 
										 AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
										 AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CD.CMSSEOTypeId ) )
										 AND CT.Name = 'Brand' 
										 AND @IsCatalogPublish = 0
									 Union All 
									 select CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
								 CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
								 CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
								 CDL.LocaleId,
								 NULL OldSEOURL, 
								 NULL CMSContentPagesId,ZPB.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
								 from ZnodeCMSSEODetail CD 
								 INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
								 INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId 
								 INNER JOIN ZnodeBrandDetails ZBD ON CD.SeoCode = ZBD.BrandCode
								 INNER JOIN ZnodePortalBrand ZPB ON ZBD.BrandId = ZPB.BrandId
								 WHERE (CDL.LocaleId = @SetLocaleId OR CDL.LocaleId = @DefaultLocaleId)  
								 AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
								 AND (CT.Name = 'Brand' ) 
								 AND @IsCatalogPublish= 1 
					)
					, Cte_GetFirstCMSSEODetails  AS
					(
						SELECT 
							ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
							SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation, LocaleId ,OldSEOURL,CMSContentPagesId,
							PortalId,SEOCode,CanonicalURL,RobotTag	
						FROM Cte_GetCMSSEODetails 
						WHERE LocaleId = @SetLocaleId
					)
					, Cte_GetDefaultFilterData AS
					(
						SELECT 
							ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
							SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
							PortalId,SEOCode,CanonicalURL,RobotTag	  FROM  Cte_GetFirstCMSSEODetails 
						UNION ALL 
						SELECT 
							ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
							SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
							PortalId,SEOCode,CanonicalURL,RobotTag	 FROM Cte_GetCMSSEODetails CTEC 
						WHERE LocaleId = @DefaultLocaleId 
						AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetFirstCMSSEODetails CTEFD WHERE CTEFD.CMSSEOTypeId = CTEC.CMSSEOTypeId 
						and CTEFD.seoCode = CTEC.seoCode )
					)
	
					INSERT INTO @TBL_SEO (ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
					SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
					PortalId,SEOCode,CanonicalURL,RobotTag)
					SELECT 
						ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
						SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,@SetLocaleId,OldSEOURL,CMSContentPagesId,
						PortalId,SEOCode,CanonicalURL,RobotTag	
					FROM Cte_GetDefaultFilterData  A 

					End 
					Else If @IsSingleProductPublish = 1  
						INSERT INTO @TBL_SEO (ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
						SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
						PortalId,SEOCode,CanonicalURL,RobotTag)
							SELECT CT.Name ItemName,CD.CMSSEODetailId, CDL.CMSSEODetailLocaleId ,  CD.CMSSEOTypeId ,
							CD.SEOId ,CDL.SEOTitle,CDL.SEODescription,
							CDL.SEOKeywords,Lower(CD.SEOUrl) SEOUrl,CD.IsRedirect,CD.MetaInformation,
							CDL.LocaleId,
							NULL OldSEOURL, 
							NULL CMSContentPagesId,CD.PortalId, CD.seoCode,CDL.CanonicalURL,CDL.RobotTag
							from ZnodeCMSSEODetail CD 
							INNER JOIN ZnodeCMSSEOType CT ON CD.CMSSEOTypeId = CT.CMSSEOTypeId 
							INNER JOIN ZnodeCMSSEODetailLocale CDL ON CD.CMSSEODetailId = CDL.CMSSEODetailId 
							WHERE (CDL.LocaleId = @LocaleId )  
							AND (CD.PortalId = @PortalId  ) 
							AND (Isnull(CD.SEOCode ,'') = @CMSSEOCode OR @CMSSEOCode = '' )
							AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CD.CMSSEOTypeId ) )

				SET @IncrementalId = @IncrementalId +1 
			END 
		End 
		End			

	If @IsPreviewEnable = 1 AND (@RevisionState like '%Preview%' OR  @RevisionState like '%Production%')  AND @IsSingleProductPublish = 0
	Begin
	    --Data inserted into flat table ZnodePublishSeoEntity (Replica of MongoDB Collection )  
		Delete from ZnodePublishSeoEntity where PortalId = @PortalId  and VersionId  in (Select PreviewVersionId  from @TBL_PreviewVersionId ) 
		AND (SEOCode = @CMSSEOCode OR @CMSSEOCode = '' )
		AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CMSSEOTypeId ) )
		AND @IsCatalogPublish= 0   

		If @IsCatalogPublish= 0
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
				PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.PreviewVersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join @TBL_PreviewVersionId B on A.PortalId = B.PortalId and A.LocaleId = B.LocaleId

		If @IsCatalogPublish= 1 
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL,CMSContentPagesId,
				PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.VersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join #VesionIds B on A.LocaleId = B.LocaleId Where B.RevisionType = 'PREVIEW'

	End

	-------------------------- End Preview 
	If (@RevisionState like '%Production%' OR @RevisionState = 'None') and @IsSingleProductPublish = 0
	Begin
		-- Only production version id will process 
		Delete from ZnodePublishSeoEntity where PortalId = @PortalId  and VersionId in (Select ProductionVersionId from  @TBL_ProductionVersionId ) 
		AND (SEOCode = @CMSSEOCode OR @CMSSEOCode = '' )
		AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CMSSEOTypeId ) )
		AND @IsCatalogPublish= 0   

		If @IsCatalogPublish= 0 				
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL
				,CMSContentPagesId,	PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.ProductionVersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join @TBL_ProductionVersionId B on A.PortalId = B.PortalId and A.LocaleId = B.LocaleId
	   If @IsCatalogPublish= 1 				
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL
				,CMSContentPagesId,	PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT B.VersionId , Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,A.LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A Inner join #VesionIds B on A.LocaleId = B.LocaleId AND B.RevisionType = 'PRODUCTION'
	
	End

	--Single Product Publish 
	If @IsSingleProductPublish =1  
	Begin
			Delete from ZnodePublishSeoEntity where PortalId = @PortalId  and VersionId in (Select Item from Split(@VersionIdString,',')) 
			AND (SEOCode = @CMSSEOCode OR @CMSSEOCode = '' )
			AND (Exists  (SELECT TOP 1 1 FROM dbo.Split(@CMSSEOTypeId ,',') SP WHERE SP.Item = CMSSEOTypeId ) )
		
			Insert Into ZnodePublishSeoEntity 
			(
				VersionId,PublishStartTime,ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				SEOTypeName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,LocaleId,OldSEOURL
				,CMSContentPagesId,	PortalId,SEOCode,CanonicalURL,RobotTag	
			)
			SELECT (Select Item from Split(@VersionIdString,',')), Getdate(), ItemName,CMSSEODetailId,CMSSEODetailLocaleId,CMSSEOTypeId,SEOId,
				ItemName,SEOTitle,SEODescription,SEOKeywords,SEOUrl,IsRedirect,MetaInformation,@LocaleId,OldSEOURL,Isnull(CMSContentPagesId,0),
				A.PortalId,SEOCode,CanonicalURL,RobotTag
			FROM @TBL_SEO A 
		
	end 
			If (@RevisionState = 'Preview'  )
			Update B SET PublishStateId = (select dbo.Fn_GetPublishStateIdForPreview()) , ISPublish = 1 
			from @TBL_SEO  A inner join ZnodeCMSSEODetail B  ON A.CMSSEODetailId  = B.CMSSEODetailId
			else If (@RevisionState = 'Production'  Or @RevisionState = 'None' )
			Update B SET PublishStateId = (select dbo.Fn_GetPublishStateIdForPublish()) , ISPublish = 1 
			from @TBL_SEO  A inner join ZnodeCMSSEODetail B  ON A.CMSSEODetailId  = B.CMSSEODetailId
	SET @Status =1 
END TRY 
BEGIN CATCH 
	SET @Status =0  
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeSetPublishSEOEntity 
	@PortalId = '+CAST(@PortalId AS VARCHAR	(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10))
	+',@PreviewVersionId = ' + CAST(@PreviewVersionId  AS varchar(20))
	+',@ProductionVersionId = ' + CAST(@ProductionVersionId  AS varchar(20))
	+',@RevisionState = ''' + CAST(@RevisionState  AS varchar(50))
	+''',@CMSSEOTypeId= ' + CAST(@CMSSEOTypeId  AS varchar(20))
	+',@UserId = ' + CAST(@UserId AS varchar(20))
	+',@CMSSEOCode  = ''' + CAST(@CMSSEOCode  AS varchar(20)) + '''';
	        			 
	SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
	EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'ZnodeSetPublishSEOEntity',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;

END CATCH
END
go

INSERT INTO ZnodeAttributeInputValidationRule(InputValidationId,ValidationRule,ValidationName,DisplayOrder,RegExp,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),null,'.rfa',9,null,
	2,getdate(),2,getdate()
where not exists(select * from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.rfa')


INSERT INTO ZnodeMediaAttributeValidation(MediaAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File'),
(select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions'),
(select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.rfa'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeMediaAttributeValidation where 
MediaAttributeId = (select top 1 MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'File') and
InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions') and 
InputValidationRuleId = (select top 1 InputValidationRuleId from ZnodeAttributeInputValidationRule where InputValidationId = (select top 1 InputValidationId from ZnodeAttributeInputValidation where name = 'Extensions')
and ValidationName = '.rfa'))


go
	
  IF exists(select * from sys.procedures where name = 'Znod_GetAddressListWithShipment')
	drop proc Znod_GetAddressListWithShipment
go
Create PROCEDURE [dbo].Znod_GetAddressListWithShipment
(
	 @UserId       INT   = 0,
    @OrderId        INT   = 0
   
)
AS 
/*
	 Summary :- This Procedure is used to returns address and shipment id(omsOrderShipmentId).
	 Unit Testig 
	 EXEC  Znod_GetAddressListWithShipment 4,1
	 
*/
   BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON ;

		if ((select AccountId from znodeuser where UserId =@UserId) is not null)
		begin
		 Select ZA.*
	  , cast(Case when ZU.AspNetUserId is null then 1 else 0 end as bit) IsGuest
	  ,(select top 1 omsOrderShipmentId from ZnodeOmsOrderLineItems ZOLI inner join 
				 ZnodeOmsOrderDetails	Zood on ZOOD.OmsOrderDetailsId = ZOLI.OmsOrderDetailsId
				 where ZOOD.OmsOrderId= @OrderId) omsOrderShipmentId
	  from ZnodeUser ZU inner join ZnodeAccountAddress ZAA on ZAA.AccountId =ZU.AccountId
			inner Join ZnodeAddress ZA on ZA.AddressId =ZAA.AddressId
			where ZU.UserId =@UserId
		end 
		else 
		begin
				 Select ZA.*
	  , cast(Case when ZU.AspNetUserId is null then 1 else 0 end as bit) IsGuest
	  ,(select top 1 omsOrderShipmentId from ZnodeOmsOrderLineItems ZOLI inner join 
				 ZnodeOmsOrderDetails	Zood on ZOOD.OmsOrderDetailsId = ZOLI.OmsOrderDetailsId
				 where ZOOD.OmsOrderId= @OrderId) omsOrderShipmentId
	   
	  from ZnodeUser ZU inner join ZnodeUserAddress ZUA on ZUA.UserId =ZU.UserId
			inner Join ZnodeAddress ZA on ZA.AddressId =ZUA.AddressId
			where ZU.UserId =@UserId
		end
		
		
			
		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)= 'EXEC Znod_GetAddressListWithShipment @UserId = '''+ISNULL(@UserId,'''''')+''',@OrderId='+ISNULL(CAST(@OrderId AS
			VARCHAR(50)),'''''')
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znod_GetAddressListWithShipment',
					@ErrorInProcedure = 'Znod_GetAddressListWithShipment',
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END
GO

go
	
  IF exists(select * from sys.procedures where name = 'Znode_GetOrderDetailsByOrderId')
	drop proc Znode_GetOrderDetailsByOrderId
go
CREATE PROCEDURE [dbo].[Znode_GetOrderDetailsByOrderId]
(
	@OmsOrderId	INT
)
AS
/* 
	Summary: This SP is used to get Order Details using OrderId
	EXEC Znode_GetOrderDetailsByOrderId @OmsOrderId = 105557
*/
BEGIN
BEGIN TRY
    SET NOCOUNT ON;

	SELECT OmsOrderId,OrderNumber,IsQuoteOrder,OmsQuoteId
	FROM ZnodeOmsOrder WHERE OmsOrderId = @OmsOrderId

	SELECT OrderDetail.OmsOrderDetailsId, OrderDetail.OmsOrderId, OrderDetail.PortalId AS PortalId, 
		OrderDetail.UserId, OrderDetail.OrderDate, OrderDetail.OmsOrderStateId, OrderDetail.ShippingId, 
		OrderDetail.PaymentTypeId, OrderDetail.BillingFirstName, OrderDetail.BillingLastName, OrderDetail.BillingCompanyName, 
		OrderDetail.BillingStreet1, OrderDetail.BillingStreet2, OrderDetail.BillingCity, OrderDetail.BillingStateCode, 
		OrderDetail.BillingPostalCode, OrderDetail.BillingCountry, OrderDetail.BillingPhoneNumber, OrderDetail.BillingEmailId, 
		OrderDetail.TaxCost, OrderDetail.ShippingCost, OrderDetail.SubTotal, OrderDetail.DiscountAmount, OrderDetail.CurrencyCode, 
		OrderDetail.OverDueAmount, OrderDetail.Total, OrderDetail.ShippingNumber, OrderDetail.TrackingNumber, OrderDetail.CouponCode, 
		OrderDetail.PromoDescription, OrderDetail.ReferralUserId, OrderDetail.PurchaseOrderNumber, OrderDetail.OmsPaymentStateId, 
		OrderDetail.WebServiceDownloadDate, OrderDetail.PaymentSettingId, OrderDetail.PaymentTransactionToken, OrderDetail.ShipDate, 
		OrderDetail.ReturnDate, OrderDetail.AddressId, OrderDetail.PoDocument, OrderDetail.IsActive, OrderDetail.ExternalId, 
		OrderDetail.CreatedBy, OrderDetail.CreatedDate, OrderDetail.ModifiedBy, OrderDetail.ModifiedDate, OrderDetail.CreditCardNumber, 
		OrderDetail.IsShippingCostEdited, OrderDetail.IsTaxCostEdited, OrderDetail.ShippingDifference, OrderDetail.EstimateShippingCost, 
		OrderDetail.TransactionId, OrderDetail.Custom1, OrderDetail.Custom2, OrderDetail.Custom3, OrderDetail.Custom4, OrderDetail.Custom5, 
		OrderDetail.FirstName, OrderDetail.LastName, OrderDetail.CardType,  OrderDetail.CreditCardExpMonth, OrderDetail.CreditCardExpYear, 
		OrderDetail.TotalAdditionalCost, OrderDetail.PaymentDisplayName, OrderDetail.PaymentExternalId, OrderDetail.CultureCode, 
		OrderDetail.DisplayName, OrderDetail.Email, OrderDetail.PhoneNumber, OrderDetail.InHandDate, OrderDetail.ShippingConstraintCode
	FROM  dbo.ZnodeOmsOrderDetails AS OrderDetail
	WHERE OrderDetail.OmsOrderId = @OmsOrderId

	SELECT Ship.ShippingId, Ship.ShippingTypeId, Ship.CurrencyId, 
		Ship.ShippingCode, Ship.ShippingName, Ship.HandlingCharge, Ship.HandlingChargeBasedOn, Ship.DestinationCountryCode, Ship.StateCode, 
		Ship.CountyFIPS, Ship.TrackingUrl, Ship.Description, Ship.IsActive, Ship.DisplayOrder, Ship.ZipCode, Ship.CreatedBy, Ship.CreatedDate, 
		Ship.ModifiedBy, Ship.ModifiedDate, Ship.DeliveryTimeframe, Ship.CultureId
	FROM ZnodeShipping Ship 
	WHERE EXISTS(SELECT * FROM ZnodeOmsOrderDetails OrderDetail WHERE OrderDetail.ShippingId = Ship.ShippingId AND OrderDetail.OmsOrderId = @OmsOrderId)


	SELECT OrderLine.OmsOrderLineItemsId, OrderLine.ParentOmsOrderLineItemsId, OrderLine.OrderLineItemRelationshipTypeId, 
		OrderLine.OmsOrderDetailsId, OrderLine.OmsOrderShipmentId, OrderLine.RmaReasonForReturnId, OrderLine.Sku, OrderLine.ProductName, 
		OrderLine.Description, OrderLine.Quantity, OrderLine.Price, OrderLine.Weight, OrderLine.DownloadLink, OrderLine.DiscountAmount, 
		OrderLine.ShipSeparately, OrderLine.ShipDate, OrderLine.ReturnDate, OrderLine.ShippingCost, OrderLine.PromoDescription, 
		OrderLine.TransactionNumber, OrderLine.PaymentStatusId, OrderLine.TrackingNumber, OrderLine.IsAutoGeneratedTracking, 
		OrderLine.OrderLineItemStateId, OrderLine.IsRecurringBilling, OrderLine.RecurringBillingPeriod, OrderLine.RecurringBillingCycles, 
		OrderLine.RecurringBillingFrequency, OrderLine.RecurringBillingAmount, OrderLine.AppliedPromo, OrderLine.CouponsApplied, 
		OrderLine.ExternalId, OrderLine.IsActive, OrderLine.CreatedBy, OrderLine.CreatedDate, OrderLine.ModifiedBy, OrderLine.ModifiedDate, 
		OrderLine.AutoAddonSKU, OrderLine.IsShippingReturn, OrderLine.PartialRefundAmount, OrderLine.Custom1, OrderLine.Custom2, OrderLine.Custom3, 
		OrderLine.Custom4, OrderLine.Custom5, OrderLine.GroupId
    FROM  dbo.ZnodeOmsOrderLineItems AS OrderLine
    WHERE Exists(select * from ZnodeOmsOrderDetails OrderDetail Where OrderLine.OmsOrderDetailsId = OrderDetail.OmsOrderDetailsId 
	     AND OrderDetail.IsActive = 1 AND OrderDetail.OmsOrderId = @OmsOrderId) 
	AND OrderLine.IsActive = 1
    ORDER BY OrderLine.OmsOrderLineItemsId ASC

	SELECT OrderState.OmsOrderStateId, OrderState.OrderStateName, OrderState.IsShowToCustomer, 
		OrderState.IsAccountStatus, OrderState.DisplayOrder, OrderState.Description, OrderState.IsEdit, OrderState.IsSendEmail, OrderState.IsOrderState, 
		OrderState.IsOrderLineItemState, OrderState.CreatedBy, OrderState.CreatedDate, OrderState.ModifiedBy, OrderState.ModifiedDate
	FROM dbo.ZnodeOmsOrderState AS OrderState
	WHERE EXISTS(SELECT * FROM dbo.ZnodeOmsOrderLineItems AS OrderLine WHERE OrderLine.IsActive = 1 AND 
				 Exists(select * from ZnodeOmsOrderDetails OrderDetail Where OrderLine.OmsOrderDetailsId = OrderDetail.OmsOrderDetailsId 
				 AND OrderDetail.IsActive = 1 AND OrderDetail.OmsOrderId = @OmsOrderId) 
				 AND OrderLine.OrderLineItemStateId = OrderState.OmsOrderStateId)
END TRY
BEGIN CATCH
	DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetOrderDetailsByOrderId @OmsOrderId='+cast(@OmsOrderId as varchar(10));
	EXEC Znode_InsertProcedureErrorLog
	@ProcedureName    = 'Znode_GetOrderDetailsByOrderId',
	@ErrorInProcedure = @ERROR_PROCEDURE,
	@ErrorMessage     = @ErrorMessage,
	@ErrorLine        = @ErrorLine,
	@ErrorCall        = @ErrorCall;
END CATCH;
END
go


    IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ZnodeOmsSavedCart_OmsCookieMappingId')
BEGIN
    CREATE NONCLUSTERED INDEX IX_ZnodeOmsSavedCart_OmsCookieMappingId
	ON [dbo].[ZnodeOmsSavedCart] (OmsCookieMappingId)
END


IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ZnodeOmsCookieMapping_UserId_PortalId' AND object_id = OBJECT_ID('ZnodeOmsCookieMapping'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ZnodeOmsCookieMapping_UserId_PortalId
	ON [dbo].ZnodeOmsCookieMapping (UserId,PortalId)
END  

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ZnodeOmsCookieMapping_UserId_PortalId')
BEGIN
    Create Index IX_ZnodeOmsCookieMapping_UserId_PortalId on ZnodeOmsCookieMapping(UserId,PortalId)
END

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'IX_ZnodeOmsSavedCartLineItem_OmsSavedCartId')
BEGIN
    CREATE NONCLUSTERED INDEX IX_ZnodeOmsSavedCartLineItem_OmsSavedCartId
	ON [dbo].[ZnodeOmsSavedCartLineItem] (OmsSavedCartId)
END


go
	
  IF exists(select * from sys.procedures where name = 'Znode_DeleteSaveCartLineItem')
	drop proc Znode_DeleteSaveCartLineItem
go
CREATE PROCEDURE [dbo].[Znode_DeleteSaveCartLineItem]
(
	  @OmsSavedCartLineItemId  int,
	  @Status bit OUT 
)
AS 
BEGIN
	
	BEGIN TRY
	SET NOCOUNT ON;

	----Adding dummy CookieMappingId if not present
	if not exists(select * from ZnodeOmsCookieMapping where OmsCookieMappingId = 1)
	begin
		SET IDENTITY_INSERT ZnodeOmsCookieMapping ON
		INSERT INTO ZnodeOmsCookieMapping(OmsCookieMappingId,UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		SELECT 1,null,(select top 1 PortalId from ZnodePortal order by 1 ASC),2,getdate(),2,getdate()
		SET IDENTITY_INSERT ZnodeOmsCookieMapping OFF
	end

	----geting dummy OmsSavedCartId on basis of OmsCookieMappingId = 1 if not present then add
	Declare @OmsSavedCartId int = 0
	SET @OmsSavedCartId = (Select Top 1 OmsSavedCartId  from ZnodeOmsSavedCart With(NoLock) where OmsCookieMappingId = 1)
	If Isnull(@OmsSavedCartId ,0) = 0 
	Begin 
		Insert into ZnodeOmsSavedCart(OmsCookieMappingId,SalesTax,RecurringSalesTax,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select  1,null,null,2,Getdate(),2,Getdate()
		SET @OmsSavedCartId  = @@IDENTITY
	end
	
	DECLARE @TBL_DeleteSavecartLineitems TABLE (OmsSavedCartLineItemId int)

	-- Declare  @OmsSavedCartLineItemId  int =59
	IF OBJECT_ID(N'tempdb..#TBL_ZnodeOmsSavedCartLineItem') IS NOT NULL
		DROP TABLE #TBL_ZnodeOmsSavedCartLineItem

	----Getting date related to @OmsSavedCartLineItemId input parameter into a table
	select OmsSavedCartLineItemId,	ParentOmsSavedCartLineItemId   
	INTO #TBL_ZnodeOmsSavedCartLineItem  
	from ZnodeOmsSavedCartLineItem  with (NOLOCK)
	where OmsSavedCartLineItemId = @OmsSavedCartLineItemId or ParentOmsSavedCartLineItemId =@OmsSavedCartLineItemId 

	--selecting all the record which needs to be deleted
	INSERT INTO @TBL_DeleteSavecartLineitems	
	select OmsSavedCartLineItemId from #TBL_ZnodeOmsSavedCartLineItem
	union
	select ParentOmsSavedCartLineItemId from #TBL_ZnodeOmsSavedCartLineItem
		where not exists (select  OmsSavedCartLineItemId,	ParentOmsSavedCartLineItemId from ZnodeOmsSavedCartLineItem 
				where OmsSavedCartLineItemId != #TBL_ZnodeOmsSavedCartLineItem.OmsSavedCartLineItemId and  ParentOmsSavedCartLineItemId =#TBL_ZnodeOmsSavedCartLineItem.ParentOmsSavedCartLineItemId)
				and ParentOmsSavedCartLineItemId is not null

	BEGIN TRAN DeleteSaveCartLineItem;

	IF exists (select top 1 1 from @TBL_DeleteSavecartLineitems)
	Begin
			--DELETE ZnodeOmsPersonalizeCartItem 
			--WHERE EXISTS
			--(
			--	SELECT TOP 1 1
			--	FROM @TBL_DeleteSavecartLineitems DeleteSaveCart
			--	WHERE DeleteSaveCart.OmsSavedCartLineItemId = ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId
			--);

	
			Update ZnodeOmsSavedCartLineItemDetails SET OmsSavedCartId = @OmsSavedCartId
			WHERE EXISTS
			(
				SELECT TOP 1 1
				FROM @TBL_DeleteSavecartLineitems DeleteSaveCart
				WHERE DeleteSaveCart.OmsSavedCartLineItemId = ZnodeOmsSavedCartLineItemDetails.OmsSavedCartLineItemId
		
			);
	  
			Update ZnodeOmsSavedCartLineItem SET OmsSavedCartId = @OmsSavedCartId
			WHERE EXISTS
			(
				SELECT TOP 1 1
				FROM @TBL_DeleteSavecartLineitems DeleteSaveCart
				WHERE DeleteSaveCart.OmsSavedCartLineItemId = ZnodeOmsSavedCartLineItem.OmsSavedCartLineItemId
			);

	End	

	SET @Status = 1;
	COMMIT TRAN DeleteSaveCartLineItem;
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()	
		SET @Status = 0;
		DECLARE @Error_procedure varchar(1000)= ERROR_PROCEDURE(), @ErrorMessage nvarchar(max)= ERROR_MESSAGE(), @ErrorLine varchar(100)= ERROR_LINE(), @ErrorCall nvarchar(max)= 'EXEC Znode_DeleteSaveCartLineItem @OmsSavedCartLineItemId = '+CAST(@OmsSavedCartLineItemId AS varchar(max))
		SELECT 0 AS ID, CAST(0 AS bit) AS Status,ERROR_MESSAGE();
		ROLLBACK TRAN DeleteSaveCartLineItem;
		EXEC Znode_InsertProcedureErrorLog @ProcedureName = 'Znode_DeleteSaveCartLineItem', @ErrorInProcedure = @Error_procedure, @ErrorMessage = @ErrorMessage, @ErrorLine = @ErrorLine, @ErrorCall = @ErrorCall;
	END CATCH;
END   


go
	
  IF exists(select * from sys.procedures where name = 'Znode_PurgeSaveCartUserData')
	drop proc Znode_PurgeSaveCartUserData
go
 CREATE PROCEDURE [dbo].[Znode_PurgeSaveCartUserData]
As
Begin
	BEGIN TRY
		SET NOCOUNT ON;

		Declare @OmsSavedCartId int
	    Select Top 1 @OmsSavedCartId = OmsSavedCartId  from ZnodeOmsSavedCart With(NoLock) where OmsCookieMappingId = 1 


		DELETE pci
		FROM ZnodeOmsPersonalizeCartItem pci
		INNER JOIN ZnodeOmsSavedCartLineItem sci ON pci.OmsSavedCartLineItemId = sci.OmsSavedCartLineItemId 
		INNER JOIN ZnodeOmsSavedCart sc ON sci.OmsSavedCartId = sc.OmsSavedCartId
		WHERE sc.OmsSavedCartId = @OmsSavedCartId

		DELETE scid 
		FROM ZnodeOmsSavedCartLineItemDetails scid
		INNER JOIN ZnodeOmsSavedCartLineItem sci ON scid.OmsSavedCartLineItemId = sci.OmsSavedCartLineItemId 
		INNER JOIN ZnodeOmsSavedCart sc ON sci.OmsSavedCartId = sc.OmsSavedCartId
		WHERE sc.OmsSavedCartId = @OmsSavedCartId

		DELETE sci
		FROM ZnodeOmsSavedCartLineItem sci 
		INNER JOIN ZnodeOmsSavedCart sc ON sci.OmsSavedCartId = sc.OmsSavedCartId
		WHERE sc.OmsSavedCartId = @OmsSavedCartId

		--Delete Orphan items
		DELETE sosclid FROM ZnodeOmsSavedCartLineItemDetails sosclid 
		LEFT JOIN ZnodeOmsSavedCart zosc ON sosclid.OmsSavedCartId=zosc.OmsSavedCartId
		WHERE zosc.OmsSavedCartId IS NULL

		DELETE zoscli FROM ZnodeOmsSavedCartLineItem zoscli
			LEFT JOIN ZnodeOmsSavedCart zosc ON zoscli.OmsSavedCartId=zosc.OmsSavedCartId
			WHERE zosc.OmsSavedCartId IS NULL

		DELETE zosc FROM ZnodeOmsSavedCart zosc
			LEFT JOIN ZnodeOmsSavedCartLineItem zoscli ON zosc.OmsSavedCartId=zoscli.OmsSavedCartId
			WHERE zoscli.OmsSavedCartId IS NULL 
			AND zosc.OmsSavedCartId<>@OmsSavedCartId  


	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()	
		DECLARE @Error_procedure varchar(1000)= ERROR_PROCEDURE(), @ErrorMessage nvarchar(max)= ERROR_MESSAGE(), @ErrorLine varchar(100)= ERROR_LINE(), @ErrorCall nvarchar(max) = 'EXEC Znode_PurgeSaveCartUserData'
		SELECT 0 AS ID, CAST(0 AS bit) AS Status,ERROR_MESSAGE();
		EXEC Znode_InsertProcedureErrorLog @ProcedureName = 'Znode_PurgeSaveCartUserData', @ErrorInProcedure = @Error_procedure, @ErrorMessage = @ErrorMessage, @ErrorLine = @ErrorLine, @ErrorCall = @ErrorCall;
	END CATCH;
End   


go
Update ZnodeApplicationSetting Set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>DomainId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>DomainId</name>      <headertext>Domain ID</headertext>      <width>10</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>DomainName</name>      <headertext>Domain Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>100</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ApiKey</name>      <headertext>API Key</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ApplicationType</name>      <headertext>Application Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>DropDown</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>Status</name>      <headertext>Is Active</headertext>      <width>40</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsDefault</name>      <headertext>Is Default</headertext>      <width>40</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>DropDown</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>50</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|clear-cache|Disable|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>PortalId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|clear-cache|Disable|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Store/EditUrl|/Store/ClearDemoWebsiteCache|/Store/EnableDisableDomain|/Store/DeleteUrl</manageactionurl>      <manageparamfield>portalId,domainId,ApiKey,Status,IsDefault|portalId,domainId|PortalId,DomainId,IsActive|domainId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeDomain'

go
	
  IF exists(select * from sys.procedures where name = 'Znode_AdminUsersEditProfile')
	drop proc Znode_AdminUsersEditProfile
go

CREATE PROCEDURE [dbo].[Znode_AdminUsersEditProfile]
(	
    @LoggedInUserId	int
)
AS
   /* 
      Summary: This SP is used to get User Details
      EXEC Znode_AdminUsersEditProfile @LoggedInUserId = 1006
   */
BEGIN
BEGIN TRY
    SET NOCOUNT ON;

	SELECT UserId,	AspNetUserId, FirstName, LastName,	MiddleName,	CustomerPaymentGUID,BudgetAmount,Email,	PhoneNumber,EmailOptIn,
			ReferralStatus,	ReferralCommission,	ReferralCommissionTypeId,	IsActive,	ExternalId,	IsShowMessage,	CreatedBy,	
			CreatedDate,	ModifiedBy,	ModifiedDate,	Custom1,	Custom2,	Custom3,	Custom4,	Custom5,	IsVerified,
			MediaId,	UserVerificationType,	UserName
	FROM ZnodeUser a
	WHERE a.UserId = @LoggedInUserId 
		
END TRY
BEGIN CATCH
	DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUsersEditProfile @LoggedInUserId='+cast(@LoggedInUserId as varchar(10));
	EXEC Znode_InsertProcedureErrorLog
	@ProcedureName    = 'Znode_AdminUsersEditProfile',
	@ErrorInProcedure = @ERROR_PROCEDURE,
	@ErrorMessage     = @ErrorMessage,
	@ErrorLine        = @ErrorLine,
	@ErrorCall        = @ErrorCall;
END CATCH;
END;
go

USE [master]
GO
/****** Object:  Database [Hangfire]    Script Date: 2/12/2021 6:52:30 PM ******/
if not exists(select * from sys.databases where name = 'Hangfire')
begin
	CREATE DATABASE [Hangfire]


	IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
	begin
	EXEC [Hangfire].[dbo].[sp_fulltext_database] @action = 'enable'
	end

	ALTER DATABASE [Hangfire] SET ANSI_NULL_DEFAULT OFF 

	ALTER DATABASE [Hangfire] SET ANSI_NULLS OFF 

	ALTER DATABASE [Hangfire] SET ANSI_PADDING OFF 

	ALTER DATABASE [Hangfire] SET ANSI_WARNINGS OFF 

	ALTER DATABASE [Hangfire] SET ARITHABORT OFF 

	ALTER DATABASE [Hangfire] SET AUTO_CLOSE OFF 

	ALTER DATABASE [Hangfire] SET AUTO_SHRINK OFF 

	ALTER DATABASE [Hangfire] SET AUTO_UPDATE_STATISTICS ON 

	ALTER DATABASE [Hangfire] SET CURSOR_CLOSE_ON_COMMIT OFF 

	ALTER DATABASE [Hangfire] SET CURSOR_DEFAULT  GLOBAL 

	ALTER DATABASE [Hangfire] SET CONCAT_NULL_YIELDS_NULL OFF 

	ALTER DATABASE [Hangfire] SET NUMERIC_ROUNDABORT OFF 

	ALTER DATABASE [Hangfire] SET QUOTED_IDENTIFIER OFF 

	ALTER DATABASE [Hangfire] SET RECURSIVE_TRIGGERS OFF 

	ALTER DATABASE [Hangfire] SET  ENABLE_BROKER 

	ALTER DATABASE [Hangfire] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 

	ALTER DATABASE [Hangfire] SET DATE_CORRELATION_OPTIMIZATION OFF 

	ALTER DATABASE [Hangfire] SET TRUSTWORTHY OFF 

	ALTER DATABASE [Hangfire] SET ALLOW_SNAPSHOT_ISOLATION OFF 

	ALTER DATABASE [Hangfire] SET PARAMETERIZATION SIMPLE 

	ALTER DATABASE [Hangfire] SET READ_COMMITTED_SNAPSHOT OFF 

	ALTER DATABASE [Hangfire] SET HONOR_BROKER_PRIORITY OFF 

	ALTER DATABASE [Hangfire] SET RECOVERY FULL 

	ALTER DATABASE [Hangfire] SET  MULTI_USER 

	ALTER DATABASE [Hangfire] SET PAGE_VERIFY CHECKSUM  

	ALTER DATABASE [Hangfire] SET DB_CHAINING OFF 

	ALTER DATABASE [Hangfire] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 

	ALTER DATABASE [Hangfire] SET TARGET_RECOVERY_TIME = 60 SECONDS 

	ALTER DATABASE [Hangfire] SET DELAYED_DURABILITY = DISABLED 

	EXEC sys.sp_db_vardecimal_storage_format N'Hangfire', N'ON'

	ALTER DATABASE [Hangfire] SET QUERY_STORE = OFF
end
go
USE [Hangfire]
GO
if not exists(select * from sys.schemas where name = 'Hangfire')
	EXEC('CREATE SCHEMA [Hangfire]')

go
if not exists(select * from sys.tables where name = 'AggregatedCounter')
begin
	CREATE TABLE [Hangfire].[AggregatedCounter](
		[Key] [nvarchar](100) NOT NULL,
		[Value] [bigint] NOT NULL,
		[ExpireAt] [datetime] NULL,
	 CONSTRAINT [PK_HangFire_CounterAggregated] PRIMARY KEY CLUSTERED 
	(
		[Key] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
End
GO
if not exists(select * from sys.tables where name = 'Counter')
begin
	CREATE TABLE [Hangfire].[Counter](
		[Key] [nvarchar](100) NOT NULL,
		[Value] [int] NOT NULL,
		[ExpireAt] [datetime] NULL
	) ON [PRIMARY]
	
End
GO

if not exists(select * from sys.indexes where name = 'CX_HangFire_Counter')
Begin
	CREATE CLUSTERED INDEX [CX_HangFire_Counter] ON [Hangfire].[Counter]
	(
		[Key] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.tables where name = 'Hash')
begin
	CREATE TABLE [Hangfire].[Hash](
		[Key] [nvarchar](100) NOT NULL,
		[Field] [nvarchar](100) NOT NULL,
		[Value] [nvarchar](max) NULL,
		[ExpireAt] [datetime2](7) NULL,
	 CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED 
	(
		[Key] ASC,
		[Field] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end
GO
if not exists(select * from sys.tables where name = 'Job')
begin
	CREATE TABLE [Hangfire].[Job](
		[Id] [bigint] IDENTITY(1,1) NOT NULL,
		[StateId] [bigint] NULL,
		[StateName] [nvarchar](20) NULL,
		[InvocationData] [nvarchar](max) NOT NULL,
		[Arguments] [nvarchar](max) NOT NULL,
		[CreatedAt] [datetime] NOT NULL,
		[ExpireAt] [datetime] NULL,
	 CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End
GO
if not exists(select * from sys.tables where name = 'JobParameter')
begin
	CREATE TABLE [Hangfire].[JobParameter](
		[JobId] [bigint] NOT NULL,
		[Name] [nvarchar](40) NOT NULL,
		[Value] [nvarchar](max) NULL,
	 CONSTRAINT [PK_HangFire_JobParameter] PRIMARY KEY CLUSTERED 
	(
		[JobId] ASC,
		[Name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End
GO
if not exists(select * from sys.tables where name = 'JobQueue')
begin
	CREATE TABLE [Hangfire].[JobQueue](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[JobId] [bigint] NOT NULL,
		[Queue] [nvarchar](50) NOT NULL,
		[FetchedAt] [datetime] NULL,
	 CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED 
	(
		[Queue] ASC,
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
end
GO
if not exists(select * from sys.tables where name = 'List')
begin
	CREATE TABLE [Hangfire].[List](
		[Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Key] [nvarchar](100) NOT NULL,
		[Value] [nvarchar](max) NULL,
		[ExpireAt] [datetime] NULL,
	 CONSTRAINT [PK_HangFire_List] PRIMARY KEY CLUSTERED 
	(
		[Key] ASC,
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End
GO
if not exists(select * from sys.tables where name = 'Schema')
begin
	CREATE TABLE [Hangfire].[Schema](
		[Version] [int] NOT NULL,
	 CONSTRAINT [PK_HangFire_Schema] PRIMARY KEY CLUSTERED 
	(
		[Version] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
End
GO
if not exists(select * from sys.tables where name = 'Server')
begin
	CREATE TABLE [Hangfire].[Server](
		[Id] [nvarchar](200) NOT NULL,
		[Data] [nvarchar](max) NULL,
		[LastHeartbeat] [datetime] NOT NULL,
	 CONSTRAINT [PK_HangFire_Server] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End
GO
if not exists(select * from sys.tables where name = 'Set')
begin
	CREATE TABLE [Hangfire].[Set](
		[Key] [nvarchar](100) NOT NULL,
		[Score] [float] NOT NULL,
		[Value] [nvarchar](256) NOT NULL,
		[ExpireAt] [datetime] NULL,
	 CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED 
	(
		[Key] ASC,
		[Value] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
end
GO
if not exists(select * from sys.tables where name = 'State')
begin
	CREATE TABLE [Hangfire].[State](
		[Id] [bigint] IDENTITY(1,1) NOT NULL,
		[JobId] [bigint] NOT NULL,
		[Name] [nvarchar](20) NOT NULL,
		[Reason] [nvarchar](100) NULL,
		[CreatedAt] [datetime] NOT NULL,
		[Data] [nvarchar](max) NULL,
	 CONSTRAINT [PK_HangFire_State] PRIMARY KEY CLUSTERED 
	(
		[JobId] ASC,
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_AggregatedCounter_ExpireAt')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_AggregatedCounter_ExpireAt] ON [Hangfire].[AggregatedCounter]
	(
		[ExpireAt] ASC
	)
	WHERE ([ExpireAt] IS NOT NULL)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_Hash_ExpireAt')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_Hash_ExpireAt] ON [Hangfire].[Hash]
	(
		[ExpireAt] ASC
	)
	WHERE ([ExpireAt] IS NOT NULL)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_Job_ExpireAt')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_Job_ExpireAt] ON [Hangfire].[Job]
	(
		[ExpireAt] ASC
	)
	INCLUDE([StateName]) 
	WHERE ([ExpireAt] IS NOT NULL)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_Job_StateName')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_Job_StateName] ON [Hangfire].[Job]
	(
		[StateName] ASC
	)
	WHERE ([StateName] IS NOT NULL)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_List_ExpireAt')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_List_ExpireAt] ON [Hangfire].[List]
	(
		[ExpireAt] ASC
	)
	WHERE ([ExpireAt] IS NOT NULL)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_Server_LastHeartbeat')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_Server_LastHeartbeat] ON [Hangfire].[Server]
	(
		[LastHeartbeat] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_Set_ExpireAt')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_Set_ExpireAt] ON [Hangfire].[Set]
	(
		[ExpireAt] ASC
	)
	WHERE ([ExpireAt] IS NOT NULL)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if not exists(select * from sys.indexes where name = 'IX_HangFire_Set_Score')
begin
	CREATE NONCLUSTERED INDEX [IX_HangFire_Set_Score] ON [Hangfire].[Set]
	(
		[Key] ASC,
		[Score] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO
if (exists(select * from information_schema.columns where table_name = 'JobParameter' and Column_name = 'JobId') and
	exists(select * from information_schema.columns where table_name = 'Job' and Column_name = 'Id') )
begin
	if not exists(select object_name(constid),* from sys.sysconstraints where object_name(constid) = 'FK_HangFire_JobParameter_Job')
	begin
		ALTER TABLE [Hangfire].[JobParameter]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_JobParameter_Job] FOREIGN KEY([JobId])
		REFERENCES [Hangfire].[Job] ([Id])
		ON UPDATE CASCADE
		ON DELETE CASCADE

		ALTER TABLE [Hangfire].[JobParameter] CHECK CONSTRAINT [FK_HangFire_JobParameter_Job]
	end
End
GO
if (exists(select * from information_schema.columns where table_name = 'State' and Column_name = 'JobId') and
	exists(select * from information_schema.columns where table_name = 'Job' and Column_name = 'Id') )
begin
	if not exists(select object_name(constid),* from sys.sysconstraints where object_name(constid) = 'FK_HangFire_State_Job')
	begin
		ALTER TABLE [Hangfire].[State]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_State_Job] FOREIGN KEY([JobId])
		REFERENCES [Hangfire].[Job] ([Id])
		ON UPDATE CASCADE
		ON DELETE CASCADE

		ALTER TABLE [Hangfire].[State] CHECK CONSTRAINT [FK_HangFire_State_Job]
	end
end
GO
USE [master]
GO
ALTER DATABASE [Hangfire] SET  READ_WRITE 
GO
