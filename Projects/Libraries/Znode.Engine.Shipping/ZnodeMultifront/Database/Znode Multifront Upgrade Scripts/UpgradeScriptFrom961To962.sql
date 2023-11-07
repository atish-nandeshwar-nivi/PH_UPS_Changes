IF EXISTS (SELECT TOP 1 1 FROM Sys.Tables WHERE Name = 'ZnodeMultifront')
BEGIN 
IF EXISTS (SELECT TOP 1 1 FROM ZnodeMultifront where BuildVersion =   962  )
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
VALUES ( N'Znode_Multifront_9_6_2', N'Upgrade GA Release by 962',9,6,2,962,0,2, GETDATE(),2, GETDATE())
GO 
SET ANSI_NULLS ON
GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'MediaManager' ,'MediaConfiguration','GenerateImages',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'MediaConfiguration' and ActionName = 'GenerateImages')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Settings')
,(select top 1 ActionId from ZnodeActions where ControllerName = 'MediaConfiguration' and ActionName = 'GenerateImages') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Settings')
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'MediaConfiguration' and ActionName = 'GenerateImages'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Settings'),
(select top 1 ActionId from ZnodeActions where ControllerName = 'MediaConfiguration' and ActionName = 'GenerateImages')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Settings')
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'MediaConfiguration' and ActionName = 'GenerateImages'))

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'MediaManager' ,'MediaManager','GenerateImageOnEdit',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'DAM')
,(select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'DAM')
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'DAM'),
(select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'DAM')
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit'))

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'MediaManager' ,'MediaManager','GenerateImageOnEdit',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Explorer')
,(select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Explorer')
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Explorer'),
(select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Media Explorer')
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'MediaManager' and ActionName = 'GenerateImageOnEdit'))
go
if not exists(select * from sys.tables where name = 'ZnodeGlobalMediaDisplaySetting')
begin
CREATE TABLE [dbo].[ZnodeGlobalMediaDisplaySetting](
	[GlobalMediaDisplaySettingsId] [int] IDENTITY(1,1) NOT NULL,
	[MediaId] [int] NULL,
	[MaxDisplayItems] [int] NULL,
	[MaxSmallThumbnailWidth] [int] NULL,
	[MaxSmallWidth] [int] NULL,
	[MaxMediumWidth] [int] NULL,
	[MaxThumbnailWidth] [int] NULL,
	[MaxLargeWidth] [int] NULL,
	[MaxCrossSellWidth] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ZnodeGlobalMediaDisplaySetting] PRIMARY KEY CLUSTERED (	[GlobalMediaDisplaySettingsId] ASC)WITH (FILLFACTOR = 90)
)
end
go
if exists(select * from sys.tables where name = 'ZnodePortalDisplaySetting')
begin
	drop table ZnodePortalDisplaySetting
end
go
insert into ZnodeGlobalMediaDisplaySetting(
MediaId,MaxDisplayItems,MaxSmallThumbnailWidth,MaxSmallWidth,MaxMediumWidth,MaxThumbnailWidth
,MaxLargeWidth,MaxCrossSellWidth,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select null,0,	38,	250,	400,	150	,800,	150,	2,	getdate(),	2,	getdate()
where not exists(select * from ZnodeGlobalMediaDisplaySetting where MaxSmallThumbnailWidth = 38
and MaxSmallWidth = 250 and MaxMediumWidth=400 and MediaId is null and MaxThumbnailWidth=150 and MaxLargeWidth=800 and MaxCrossSellWidth = 150)
go
if exists(select * from sys.procedures where name ='Znode_CopyPortal')
	drop proc Znode_CopyPortal
go
CREATE PROCEDURE [dbo].[Znode_CopyPortal]    
(    
   @PortalId int,     
   @StoreName varchar(500),    
   @CompanyName varchar(500),     
   @UserId int,    
   @StoreCode nvarchar(200),    
   @Status bit OUT)    
AS    
    /*    
     
 Summary: Create copy of existing portal    
 Copy all corresponding data into following list of tables Catalog,Profile,Units,Countries,Shipping,Locale,SMTP    
    
 ZnodeTaxClass ZnodeTaxClassPortal;ZnodeTaxRuleTypes ZnodeCaseRequest,ZnodeUserPortal ZnodeDomain,AspNetZnodeUser ZnodePortalAccount,    
 ZnodePortal ZnodePortalAddress,ZnodePortalCatalog ZnodePortalLocale,ZnodePortalFeatureMapper, ZnodeOmsUsersReferralUrl,ZnodePortalProfile ,ZnodePortalSetting    
 ZnodePortalShippingDetails ZnodePortalSmtpSetting,ZnodePortalWarehouse ,ZnodeOmsCookieMapping,ZnodePortalUnit ,ZnodePromotion,    
 ZnodePriceListPortal ,ZnodeActivityLog,ZnodeShippingPortal,ZnodeGiftCard ,ZnodeCMSContentPages ,ZnodeCMSPortalMessage,    
 ZnodeCMSPortalProductPage ,ZnodeCMSPortalSEOSetting ,ZnodeCMSPortalTheme    
        
 Unit Testing       
    ------------------------------------------------------------------------------    
               
    begin tran    
    DECLARE @Status  bit     
       EXEC Znode_CopyPortal @PortalId =2 ,@StoreName  ='copy OF Maxwells FF' , @CompanyName = 'copy OF Maxwells FF' ,@UserId = 2, @StoreCode = '',@Status = @Status OUT     
       rollback tran    
    select @Status    
       SELECT * FROM dbo.ZnodePortal zp WHERE zp.CompanyName = 'copy OF Maxwells FF'    
       SELECT * FROM ZnodePortalCatalog WHERE dbo.ZnodePortalCatalog.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
       SELECT * FROM ZnodePortalProfile WHERE dbo.ZnodePortalProfile.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
       SELECT * FROM ZnodePortalUnit WHERE dbo.ZnodePortalUnit.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
       SELECT * FROM ZnodePortalCountry WHERE dbo.ZnodePortalCountry.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
       SELECT * FROM ZnodePortalShippingDetails WHERE dbo.ZnodePortalShippingDetails.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
       SELECT * FROM ZnodePortalLocale WHERE dbo.ZnodePortalLocale.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
       SELECT * FROM ZnodePortalSmtpSetting WHERE dbo.ZnodePortalSmtpSetting.PortalId IN (SELECT portalid FROM dbo.ZnodePortal zp  WHERE zp.CompanyName = 'copy OF Maxwells FF')    
          
    ---------------------------------------------------------------------------     
     */    
BEGIN    
 BEGIN TRAN A;    
 BEGIN TRY    
  SET NOCOUNT ON;    
  DECLARE @GetDate DATETIME = dbo.Fn_GetDate();    
  -- hold the newly created pim catalog id     
  DECLARE @NewPortalId int;     
  --Check if store name is not already exist then process copy    
      
      
  IF @StoreCode NOT IN (select  storecode from ZnodePortal )    
  BEGIN    
      
  IF EXISTS ( SELECT TOP 1 1 FROM dbo.ZnodePortal AS zp WHERE PortalId = @PortalId  )     
  AND @CompanyName <> '' AND @StoreName <> '' AND @StoreCode <> '' --AND  @StoreCode <> (select  storecode from ZnodePortal )     
      
  BEGIN    
    
   INSERT INTO dbo.ZnodePortal(    
   CompanyName, StoreName, LogoPath, UseSSL, AdminEmail, SalesEmail, CustomerServiceEmail, SalesPhoneNumber, CustomerServicePhoneNumber, ImageNotAvailablePath, ShowSwatchInCategory, ShowAlternateImageInCategory, ExternalID, MobileLogoPath, DefaultOrderStateID, DefaultReviewStatus, SplashCategoryID, SplashImageFile, MobileTheme,InStockMsg,OutOfStockMsg,BackOrderMsg,CreatedBy, CreatedDate, ModifiedBy, ModifiedDate ,StoreCode,UserVerificationType)    
   SELECT @CompanyName, @StoreName, LogoPath, UseSSL, AdminEmail, SalesEmail, CustomerServiceEmail, SalesPhoneNumber, CustomerServicePhoneNumber, ImageNotAvailablePath, ShowSwatchInCategory, ShowAlternateImageInCategory, ExternalID, MobileLogoPath, DefaultOrderStateID, DefaultReviewStatus, SplashCategoryID, SplashImageFile, MobileTheme,InStockMsg,OutOfStockMsg,BackOrderMsg, @UserId, @GetDate, @UserId, @GetDate ,@StoreCode,UserVerificationType   
   FROM ZnodePortal    
   WHERE PortalId = @PortalId;    
   SET @NewPortalId = SCOPE_IDENTITY();    
  END;    
  END    
    
  -- copy all data if New portalId will generate    
  IF @NewPortalId > -0     
  BEGIN    
   INSERT INTO dbo.ZnodePortalCatalog(    
   PortalId, PublishCatalogId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, PublishCatalogId, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalCatalog    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalProfile(    
   PortalId, ProfileId, IsDefaultAnonymousProfile, IsDefaultRegistedProfile, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, ProfileId, IsDefaultAnonymousProfile, IsDefaultRegistedProfile, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalProfile    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalUnit(       
   PortalId, CurrencyId,CultureId, WeightUnit, DimensionUnit,CurrencySuffix, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, CurrencyId,CultureId, WeightUnit, DimensionUnit,CurrencySuffix, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalUnit    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalCountry(    
   PortalId, CountryCode, IsDefault, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, CountryCode, IsDefault, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalCountry    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodeShippingPortal(        
   PortalId, ShippingOriginAddress1, ShippingOriginAddress2, ShippingOriginCity, ShippingOriginStateCode, ShippingOriginZipCode, ShippingOriginCountryCode, ShippingOriginPhone, FedExAccountNumber, FedExLTLAccountNumber, FedExMeterNumber, FedExProductionKey, FedExSecurityCode, FedExDropoffType, FedExPackagingType, FedExUseDiscountRate, FedExAddInsurance, UPSUserName, UPSPassword, UPSKey, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, ShippingOriginAddress1, ShippingOriginAddress2, ShippingOriginCity, ShippingOriginStateCode, ShippingOriginZipCode, ShippingOriginCountryCode, ShippingOriginPhone, FedExAccountNumber, FedExLTLAccountNumber, FedExMeterNumber, FedExProductionKey, FedExSecurityCode, FedExDropoffType, FedExPackagingType, FedExUseDiscountRate, FedExAddInsurance, UPSUserName, UPSPassword, UPSKey, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodeShippingPortal    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalLocale(      
   PortalId, LocaleId, IsDefault, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, LocaleId, IsDefault, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalLocale    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalSmtpSetting(     
   PortalId, ServerName, UserName, Password, Port, IsEnableSsl, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,DisableAllEmails )    
       SELECT @NewPortalId, ServerName, UserName, Password, Port, IsEnableSsl, @UserId, @GetDate, @UserId, @GetDate,DisableAllEmails    
 FROM ZnodePortalSmtpSetting    
       WHERE PortalId = @PortalId;    
  
   INSERT INTO dbo.ZnodeCMSPortalTheme(       
   PortalId, CMSThemeId, CMSThemeCSSId, MediaId, WebsiteTitle, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,WebsiteDescription )    
       SELECT @NewPortalId, CMSThemeId, CMSThemeCSSId, MediaId, WebsiteTitle, @UserId, @GetDate, @UserId, @GetDate ,WebsiteDescription   
       FROM ZnodeCMSPortalTheme    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalFeatureMapper(     
   PortalId, PortalFeatureId, PortalFeatureMapperValue, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, PortalFeatureId, PortalFeatureMapperValue, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalFeatureMapper    
       WHERE PortalId = @PortalId;    

		INSERT INTO ZnodePortalRecommendationSetting
		SELECT @NewPortalId,IsHomeRecommendation,IsPDPRecommendation,IsCartRecommendation,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate FROM ZnodePortalRecommendationSetting
		WHERE PortalId=@PortalId

      EXEC Znode_CopyPortalMessageAndContentPages @PortalId,@NewPortalId,@userId,0    
          
   EXEC Znode_CopyPortalEmailTemplate @NewPortalId,@PortalId,@userId    
   -- If copy process will complete successfully then return status 1     
   -- return the data set if     
   SELECT @PortalId AS ID, CAST(1 AS bit) AS [Status];     
   SET @Status = CAST(1 AS bit);    
   COMMIT TRAN A;    
  END;    
  ELSE    
  BEGIN    
   -- If copy process will not complete successfully then return status 0     
   SELECT @PortalId AS ID, CAST(0 AS bit) AS [Status];    
   SET @Status = CAST(0 AS bit);    
   ROLLBACK TRAN A;    
  END;    
 END TRY    
 BEGIN CATCH     
   select ERROR_MESSAGE()    
       SET @Status = 0;    
       DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_CopyPortal @PortalId = '+CAST(@PortalId AS VARCHAR(200))+',@StoreName='+@StoreName+',@CompanyName='+@CompanyName+',@UserId = '+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));    
                      
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                        
        
             EXEC Znode_InsertProcedureErrorLog    
    @ProcedureName = 'Znode_CopyPortal',    
    @ErrorInProcedure = @Error_procedure,    
    @ErrorMessage = @ErrorMessage,    
    @ErrorLine = @ErrorLine,    
    @ErrorCall = @ErrorCall;    
 END CATCH;    
END;
go
if exists(select * from sys.procedures where name ='Znode_DeletePortalByPortalId')
	drop proc Znode_DeletePortalByPortalId
go
CREATE PROCEDURE [dbo].[Znode_DeletePortalByPortalId]
(
	 @PortalId	varchar(2000) = '' ,
	 @StoreCode varchar(2000) = '',
	 @Status	bit OUT
)
AS
	/*
	 Summary : This Procedure Is Used to delete the all records of portal if order is not place against portal  
	 --Unit Testing   
	 BEGIN TRANSACTION 
	 DECLARE @Status    BIT = 0
	 EXEC Znode_DeletePortalByPortalId @PortalId = '1,7,8', @Status   = @Status   OUT
	 SELECT @Status   
	 ROLLBACK TRANSACTION

	*/
BEGIN
	BEGIN TRAN DeletePortalByPortalId;
	BEGIN TRY
		SET NOCOUNT ON;

		--SET @PortalId = (SELECT PortalId FROM ZnodePortal ZP  )

		DECLARE @TBL_PortalIds TABLE
		( 
								 PortalId int
		);
		DECLARE @TBL_Promotion TABLE
		( 
								 PromotionId int
		);
		DECLARE @TBL_DeletedUsers TABLE (AspNetUserId NVARCHAR(1000))

		DECLARE @TBL_DeletedZnodeUsers TABLE (UserId NVARCHAR(1000))

		DECLARE @DeletedIds varchar(max)= '';
		-- inserting PortalIds which are not present in Order and Quote

		
		INSERT INTO @TBL_PortalIds 
		SELECT PortalId FROM ZnodePortal ZP
		WHERE CASE WHEN @StoreCode = '' THEN CAST(PortalId AS NVARCHAR(2000)) ELSE StoreCode END IN (

		SELECT Item FROM dbo.Split( CASE WHEN @StoreCode = '' THEN @PortalId ELSE @StoreCode END, ',' ) AS SP ) 
		AND NOT EXISTS ( SELECT TOP 1 1 FROM ZnodeOmsOrderDetails AS ZOD WHERE ZOD.PortalId = ZP.PortalId) 
	
		DELETE FROM dbo.ZnodeRobotsTxt WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeRobotsTxt.PortalId)

		DELETE FROM dbo.ZnodePortalPixelTracking WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPixelTracking.PortalId)

		DELETE ZOH
		FROM ZnodeOmsQuotePersonalizeItem ZOH
		INNER JOIN ZnodeOmsQuoteLineItem ZOM ON ZOH.OmsQuoteLineItemId = ZOM.OmsQuoteLineItemId
		WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeOmsQuote ZOQ  
										WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZOQ.PortalId) AND ZOQ.OmsQuoteId = ZOM.OmsQuoteId )

		DELETE ZOH
		FROM ZnodeOmsHistory ZOH
		INNER JOIN ZnodeOmsNotes ZOM ON ZOH.OmsNotesId = ZOM.OmsNotesId
		WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeOmsQuote ZOQ  
										WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZOQ.PortalId) AND ZOQ.OmsQuoteId = ZOM.OmsQuoteId )

		DELETE FROM ZnodeOmsQuoteLineItem WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeOmsQuote ZOQ  
										WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZOQ.PortalId) AND ZOQ.OmsQuoteId = ZnodeOmsQuoteLineItem.OmsQuoteId )

		DELETE FROM ZnodeOmsNotes WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeOmsQuote ZOQ  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZOQ.PortalId) AND ZOQ.OmsQuoteId = ZnodeOmsNotes.OmsQuoteId )

		DELETE FROM ZnodeOmsQuote WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsQuote.PortalId);

	     DELETE FROM  ZnodeCustomPortalDetail  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCustomPortalDetail.PortalId);
	     DELETE FROM  ZnodeSupplier WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSupplier.PortalId)

	     DELETE FROM  ZnodeOmsTemplateLineItem  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeOmsTemplate ZOT ON 
	     TBP.PortalId = ZOT.PortalId AND ZOT.OmsTemplateId = ZnodeOmsTemplateLineItem.OmsTemplateId);

	     DELETE FROM ZnodeOmsTemplate WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsTemplate.PortalId);
	     DELETE FROM  ZnodeOmsUsersReferralUrl WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsUsersReferralUrl.PortalId)

		DELETE FROM ZnodePortalShipping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShipping.PortalId);
		DELETE FROM ZnodePortalTaxClass WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalTaxClass.PortalId);
		DELETE FROM ZnodePortalPaymentSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPaymentSetting.PortalId);
		DELETE FROM ZnodeCMSPortalMessageKeyTag WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessageKeyTag.PortalId);
		DELETE FROM ZnodePortalProfile WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalProfile.PortalId);
		DELETE FROM ZnodePortalFeatureMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalFeatureMapper.PortalId);
		DELETE FROM ZnodePortalShippingDetails WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShippingDetails.PortalId);
		DELETE FROM ZnodePortalUnit WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalUnit.PortalId);
		DELETE FROM ZnodeDomain WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeDomain.PortalId);
		DELETE FROM ZnodePortalSmtpSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSmtpSetting.PortalId);
		DELETE FROM ZnodeActivityLog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeActivityLog.PortalId);
		DELETE FROM ZnodePortalCatalog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCatalog.PortalId );
		DELETE FROM ZnodeCMSPortalMessage  WHERE EXISTS  ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessage.PortalId );
		DELETE FROM ZnodeGoogleTagManager WHERE  EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGoogleTagManager.PortalId);
		DELETE FROM ZnodeTaxRuleTypes WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRuleTypes.PortalId);
		DELETE FROM ZnodeCMSContentPagesProfile WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesProfile.CMSContentPagesId )
		DELETE FROM ZnodeCMSContentPageGroupMapping WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPageGroupMapping.CMSContentPagesId )
	     DELETE FROM ZnodeCMSContentPagesLocale WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesLocale.CMSContentPagesId )
		DELETE FROM ZnodeFormWidgetEmailConfiguration WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeFormWidgetEmailConfiguration.CMSContentPagesId )
		DELETE FROM ZnodeCMSContentPages WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSContentPages.PortalId);
		
		 DELETE FROM ZnodeCaseRequestHistory WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCaseRequest ZCR  
			WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCR.PortalId) AND ZCR.CaseRequestId = ZnodeCaseRequestHistory.CaseRequestId )

		 DELETE FROM ZnodeNote WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCaseRequest ZCR  
			WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCR.PortalId) AND ZCR.CaseRequestId = ZnodeNote.CaseRequestId )
		
		DELETE FROM ZnodeCaseRequest WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCaseRequest.PortalId);
		DELETE FROM ZnodePortalLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalLocale.PortalId);
		DELETE FROM ZnodeShippingPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeShippingPortal.PortalId);
		
		DELETE FROM ZnodeSalesRepCustomerUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSalesRepCustomerUserPortal.CustomerPortalId);

		delete from ZnodeSalesRepCustomerUserPortal 
		where exists(select * FROM ZnodeUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId) and ZnodeSalesRepCustomerUserPortal.UserPortalId = ZnodeUserPortal.UserPortalId);
		
		DELETE FROM ZnodeUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId);
		DELETE FROM AspNetZnodeUser OUTPUT DELETED.AspNetZnodeUserId   INTO @TBL_DeletedUsers WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = AspNetZnodeUser.PortalId )
		
	  

		DELETE FROM ZnodePortalAlternateWarehouse WHERE EXISTS ( SELECT TOP 1 1 FROM ZnodePortalWareHouse AS ZPWH WHERE EXISTS (
				SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZPWH.PortalId ) AND  ZPWH.PortalWarehouseId = ZnodePortalAlternateWarehouse.PortalWarehouseId);
		DELETE FROM ZnodePortalWareHouse WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalWareHouse.PortalId);
		DELETE ZnodePriceListPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePriceListPortal.PortalId );
		
		DELETE FROM ZnodeEmailTemplateMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeEmailTemplateMapper.PortalId);
		DELETE FROM ZnodeGiftCard WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGiftCard.PortalId );
		DELETE FROM ZnodeCMSPortalProductPage WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalProductPage.PortalId);

		DELETE FROM ZnodeCMSPortalSEOSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalSEOSetting.PortalId);

		DELETE FROM ZnodeCMSPortalTheme WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalTheme.PortalId);

		DELETE FROM ZnodeCMSSEODetailLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeCMSSEODetail AS zcsd ON TBP.PortalId = zcsd.PortalId WHERE zcsd.CMSSEODetailId = ZnodeCMSSEODetailLocale.CMSSEODetailId);

		DELETE FROM ZnodeCMSSEODetail WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSSEODetail.PortalId);
		DELETE FROM ZnodePortalAccount WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAccount.PortalId);

		DELETE FROM ZnodePortalAddress WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAddress.PortalId);

		DELETE FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId);

		DELETE FROM ZnodePortalCountry WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCountry.PortalId);

		DELETE FROM ZnodeCMSUrlRedirect WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSUrlRedirect.PortalId);

		DELETE FROM ZnodePortalCustomCss WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCustomCss.PortalId);
		   
		/* Remove Search index */
		--DELETE FROM ZnodeSearchIndexServerStatus WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodePortalIndex AS zpi ON TBP.PortalId = zpi.PortalId
		--		 INNER JOIN ZnodeSearchIndexMonitor AS zsim ON zpi.PortalIndexId = zsim.PortalIndexId WHERE zsim.SearchIndexMonitorId = ZnodeSearchIndexServerStatus.SearchIndexMonitorId);
		--DELETE FROM ZnodeSearchIndexMonitor WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodePortalIndex AS zpi ON TBP.PortalId = zpi.PortalId WHERE zpi.PortalIndexId = ZnodeSearchIndexMonitor.PortalIndexId );
		--DELETE FROM ZnodePortalIndex WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalIndex.PortalId);
		/* Remove Search index */
		DELETE FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePromotion.PortalId);
		DELETE FROM ZnodeTaxPortaL  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxPortaL.PortalId);

		INSERT INTO @TBL_Promotion( PromotionId ) SELECT PromotionId FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePromotion.PortalId);
		DELETE FROM ZnodePromotionProduct WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionProduct.PromotionId);

		DELETE FROM ZnodePromotionCategory WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCategory.PromotionId);
		DELETE FROM ZnodePromotionCatalogs WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCatalogs.PromotionId);
		DELETE FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotion.PromotionId);

		
		DELETE FROM ZnodeBlogNewsLocale where exists (select top 1 1 from ZnodeBlogNews ZBN
													where EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsLocale.BlogNewsId )



		DELETE FROM ZnodeBlogNewsCommentLocale where exists (select top 1 1 from ZnodeBlogNewsComment ZBC
													where exists (select top 1 1 from ZnodeBlogNews ZBN
														where exists (select top 1 1 from @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZBC.BlogNewsId ) and ZBC.BlogNewsCommentId = ZnodeBlogNewsCommentLocale.BlogNewsCommentId)
													



		DELETE FROM ZnodeBlogNewsComment WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
													WHERE EXISTS (select top 1 1 from @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsComment.BlogNewsId )



		DELETE FROM ZnodeBlogNews WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeBlogNews.PortalId)

		DELETE ZFBGAVL
		FROM ZnodeFormBuilderGlobalAttributeValueLocale ZFBGAVL
		INNER JOIN ZnodeFormBuilderGlobalAttributeValue ZFBGAV ON ZFBGAVL.FormBuilderGlobalAttributeValueId = ZFBGAV.FormBuilderGlobalAttributeValueId
		WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeFormBuilderSubmit ZFBS
														WHERE EXISTS (select top 1 1 from @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZFBS.PortalId) AND ZFBS.FormBuilderSubmitId = ZFBGAV.FormBuilderSubmitId )


		DELETE FROM ZnodeFormBuilderGlobalAttributeValue WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeFormBuilderSubmit ZFBS
														WHERE EXISTS (select top 1 1 from @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZFBS.PortalId) AND ZFBS.FormBuilderSubmitId = ZnodeFormBuilderGlobalAttributeValue.FormBuilderSubmitId )

	DELETE FROM ZnodeFormBuilderSubmit WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeFormBuilderSubmit.PortalId)

		DELETE FROM ZnodeCaseRequestHistory WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCaseRequest ZCR  
	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCR.PortalId) AND ZCR.CaseRequestId = ZnodeCaseRequestHistory.CaseRequestId )

		DELETE FROM ZnodeNote WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCaseRequest ZCR  
	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCR.PortalId) AND ZCR.CaseRequestId = ZnodeNote.CaseRequestId )

	DECLARE @DeleteUserId VARCHAR(MAX)
	  SET @DeleteUserId = SUBSTRING((SELECT TOP 100 ','+CAST(UserId AS VARCHAR(2000)) FROM ZnodeUser WHERE EXISTS 
					(SELECT TOP 1 1 FROM AspNetUsers ANU WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_DeletedUsers TBDU WHERE ANU.UserName = TBDU.AspNetUserId) AND ZnodeUser.AspNetUserId = ANU.Id) 
					FOR XML PATH('')), 2, 4000);
		
		DELETE FROM ZnodePortalRecommendationSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalRecommendationSetting.PortalId);

		DELETE FROM ZnodePortalPageSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPageSetting.PortalId);

		DELETE FROM ZnodePortalSortSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSortSetting.PortalId);

	    EXEC Znode_DeleteUserDetails @UserId = @DeleteUserId, @Status = 0,  @IsCallInternal = 1 
		
		DELETE FROM ZnodePortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortal.PortalId);
		
			IF (SELECT Count(1) FROM @TBL_PortalIds) = (SELECT Count(1) FROM dbo.Split( CASE WHEN @StoreCode = '' THEN @PortalId ELSE @StoreCode END, ',' ) )	 	
			BEGIN 		
			SELECT 1 AS ID, CAST(1 AS bit) AS Status;
			SET @Status = 1;
			END
		 
		ELSE 
			BEGIN 
			SELECT 0 AS ID, CAST(0 AS bit) AS Status;
			SET @Status = 0;
			END 
		
		

		COMMIT TRAN DeletePortalByPortalId;
	END TRY
	BEGIN CATCH
	
		 
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeletePortalByPortalId @PortalId = '+ISNULL(@PortalId,'''''')+',@StoreCode = '+ISNULL(@StoreCode,'''''')+',@Status='+ISNULL(CAST(@Status AS VARCHAR(10)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		     ROLLBACK TRAN DeletePortalByPortalId;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_DeletePortalByPortalId',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END;
go
if exists(select * from sys.procedures where name ='Znode_DeletePortalByStoreCode')
	drop proc Znode_DeletePortalByStoreCode
go
CREATE  PROCEDURE [dbo].[Znode_DeletePortalByStoreCode]
(
	 @PortalId	varchar(2000)
	,@Status	bit OUT)
AS
	/*
	 Summary : This Procedure Is Used to delete the all records of portal if order is not place against portal  
	 --Unit Testing   
	 BEGIN TRANSACTION 
	 DECLARE @Status    BIT = 0
	 EXEC Znode_DeletePortalByPortalId @PortalId = 36, @Status   = @Status   OUT
	 SELECT @Status   
	 ROLLBACK TRANSACTION
	*/
BEGIN
	BEGIN TRAN DeletePortalByPortalId;
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @TBL_PortalIds TABLE
		( 
								 PortalId int
		);
		DECLARE @TBL_Promotion TABLE
		( 
								 PromotionId int
		);
		DECLARE @TBL_DeletedUsers TABLE (AspNetUserId NVARCHAR(1000))

		DECLARE @DeletedIds varchar(max)= '';
		-- inserting PortalIds which are not present in Order and Quote

		INSERT INTO @TBL_PortalIds 
		SELECT Item FROM dbo.Split( @PortalId, ',' ) AS SP 
		WHERE NOT EXISTS ( SELECT TOP 1 1 FROM ZnodeOmsOrderDetails AS ZOD WHERE ZOD.PortalId = Sp.Item) 
		AND  NOT EXISTS (SELECT TOP 1 1 FROM ZnodeOmsQuote AS ZOQ WHERE ZOQ.PortalId = Sp.Item );


	     DELETE FROM  ZnodeCustomPortalDetail  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCustomPortalDetail.PortalId);
	     DELETE FROM  ZnodeSupplier WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSupplier.PortalId)

	     DELETE FROM  ZnodeOmsTemplateLineItem  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeOmsTemplate ZOT ON 
	     TBP.PortalId = ZOT.PortalId AND ZOT.OmsTemplateId = ZnodeOmsTemplateLineItem.OmsTemplateId);

	     DELETE FROM ZnodeOmsTemplate WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsTemplate.PortalId);
	     DELETE FROM  ZnodeOmsUsersReferralUrl WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsUsersReferralUrl.PortalId)

		DELETE FROM ZnodePortalShipping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShipping.PortalId);
		DELETE FROM ZnodePortalTaxClass WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalTaxClass.PortalId);
		DELETE FROM ZnodePortalPaymentSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPaymentSetting.PortalId);
		DELETE FROM ZnodeCMSPortalMessageKeyTag WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessageKeyTag.PortalId);
		DELETE FROM ZnodePortalProfile WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalProfile.PortalId);
		DELETE FROM ZnodePortalFeatureMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalFeatureMapper.PortalId);
		DELETE FROM ZnodePortalShippingDetails WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShippingDetails.PortalId);
		DELETE FROM ZnodePortalUnit WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalUnit.PortalId);
		DELETE FROM ZnodeDomain WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeDomain.PortalId);
		DELETE FROM ZnodePortalSmtpSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSmtpSetting.PortalId);
		DELETE FROM ZnodeActivityLog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeActivityLog.PortalId);
		DELETE FROM ZnodePortalCatalog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCatalog.PortalId );
		DELETE FROM ZnodeCMSPortalMessage  WHERE EXISTS  ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessage.PortalId );
		--DELETE FROM ZnodeTaxRule WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRule.PortalId);
		DELETE FROM ZnodeGoogleTagManager WHERE  EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGoogleTagManager.PortalId);
		DELETE FROM ZnodeTaxRuleTypes WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRuleTypes.PortalId);
		DELETE FROM ZnodeCMSContentPagesProfile WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesProfile.CMSContentPagesId )
		DELETE FROM ZnodeCMSContentPageGroupMapping WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPageGroupMapping.CMSContentPagesId )
	     DELETE FROM ZnodeCMSContentPagesLocale WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesLocale.CMSContentPagesId )
		DELETE FROM ZnodeCMSContentPages WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSContentPages.PortalId);
		DELETE FROM ZnodeCaseRequest WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCaseRequest.PortalId);
		DELETE FROM ZnodePortalLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalLocale.PortalId);
		DELETE FROM ZnodeShippingPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeShippingPortal.PortalId);
		
		DELETE FROM ZnodeSalesRepCustomerUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSalesRepCustomerUserPortal.CustomerPortalId);

		delete from ZnodeSalesRepCustomerUserPortal 
		where exists(select * FROM ZnodeUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId) and ZnodeSalesRepCustomerUserPortal.UserPortalId = ZnodeUserPortal.UserPortalId);
		
		DELETE FROM ZnodeUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId);
		DELETE FROM AspNetZnodeUser OUTPUT DELETED.AspNetZnodeUserId   INTO @TBL_DeletedUsers WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = AspNetZnodeUser.PortalId )
		
		DELETE FROM ZnodePortalAlternateWarehouse WHERE EXISTS ( SELECT TOP 1 1 FROM ZnodePortalWareHouse AS ZPWH WHERE EXISTS (
				SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZPWH.PortalId ) AND  ZPWH.PortalWarehouseId = ZnodePortalAlternateWarehouse.PortalWarehouseId);
		DELETE FROM ZnodePortalWareHouse WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalWareHouse.PortalId);
		DELETE ZnodePriceListPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePriceListPortal.PortalId );
		
		DELETE FROM ZnodeEmailTemplateMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeEmailTemplateMapper.PortalId);
		DELETE FROM ZnodeGiftCard WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGiftCard.PortalId );
		DELETE FROM ZnodeCMSPortalProductPage WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalProductPage.PortalId);

		DELETE FROM ZnodeCMSPortalSEOSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalSEOSetting.PortalId);

		DELETE FROM ZnodeCMSPortalTheme WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalTheme.PortalId);

		DELETE FROM ZnodeCMSSEODetailLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeCMSSEODetail AS zcsd ON TBP.PortalId = zcsd.PortalId WHERE zcsd.CMSSEODetailId = ZnodeCMSSEODetailLocale.CMSSEODetailId);

		DELETE FROM ZnodeCMSSEODetail WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSSEODetail.PortalId);
		DELETE FROM ZnodePortalAccount WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAccount.PortalId);

		DELETE FROM ZnodePortalAddress WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAddress.PortalId);

		DELETE FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId);

		DELETE FROM ZnodePortalCountry WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCountry.PortalId);

		DELETE FROM ZnodeCMSUrlRedirect WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSUrlRedirect.PortalId);

		DELETE FROM ZnodePortalCustomCss WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCustomCss.PortalId);
		   
		/* Remove Search index */
		--DELETE FROM ZnodeSearchIndexServerStatus WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodePortalIndex AS zpi ON TBP.PortalId = zpi.PortalId
		--		 INNER JOIN ZnodeSearchIndexMonitor AS zsim ON zpi.PortalIndexId = zsim.PortalIndexId WHERE zsim.SearchIndexMonitorId = ZnodeSearchIndexServerStatus.SearchIndexMonitorId);
		--DELETE FROM ZnodeSearchIndexMonitor WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodePortalIndex AS zpi ON TBP.PortalId = zpi.PortalId WHERE zpi.PortalIndexId = ZnodeSearchIndexMonitor.PortalIndexId );
		--DELETE FROM ZnodePortalIndex WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalIndex.PortalId);
		/* Remove Search index */
		DELETE FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePromotion.PortalId);
		DELETE FROM ZnodeTaxPortaL  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxPortaL.PortalId);

		INSERT INTO @TBL_Promotion( PromotionId ) SELECT PromotionId FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePromotion.PortalId);
		DELETE FROM ZnodePromotionProduct WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionProduct.PromotionId);

		DELETE FROM ZnodePromotionCategory WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCategory.PromotionId);
		DELETE FROM ZnodePromotionCatalogs WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCatalogs.PromotionId);
		DELETE FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotion.PromotionId);

		
		DELETE FROM ZnodeBlogNewsLocale where exists (select top 1 1 from ZnodeBlogNews ZBN
													where EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsLocale.BlogNewsId )



		DELETE FROM ZnodeBlogNewsCommentLocale where exists (select top 1 1 from ZnodeBlogNewsComment ZBC
													where exists (select top 1 1 from ZnodeBlogNews ZBN
														where exists (select top 1 1 from @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZBC.BlogNewsId ) and ZBC.BlogNewsCommentId = ZnodeBlogNewsCommentLocale.BlogNewsCommentId)
													



		DELETE FROM ZnodeBlogNewsComment WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
													WHERE EXISTS (select top 1 1 from @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsComment.BlogNewsId )



		DELETE FROM ZnodeBlogNews WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeBlogNews.PortalId)
		DELETE FROM ZnodePortalRecommendationSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalRecommendationSetting.PortalId);

		DELETE FROM ZnodePortalPageSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPageSetting.PortalId);

		DELETE FROM ZnodePortalSortSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSortSetting.PortalId);

		DELETE FROM ZnodePortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortal.PortalId);

		IF (SELECT Count(1) FROM @TBL_PortalIds) = (SELECT Count(1) FROM dbo.Split( @PortalId, ',' ) )
		BEGIN 
		SELECT 1 AS ID, CAST(1 AS bit) AS Status;
		SET @Status = 1;
		END 
		ELSE 
		BEGIN 
		SELECT 0 AS ID, CAST(0 AS bit) AS Status;
		SET @Status = 0;

		END 
		COMMIT TRAN DeletePortalByPortalId;
	END TRY
	BEGIN CATCH
		 
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeletePortalByPortalId @PortalId = '+@PortalId+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		     ROLLBACK TRAN DeletePortalByPortalId;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_DeletePortalByPortalId',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END;
go
if exists(select * from sys.procedures where name ='Znode_GetPublishProductbulk')
	drop proc Znode_GetPublishProductbulk
go
CREATE PROCEDURE [dbo].[Znode_GetPublishProductbulk]
(
@PublishCatalogId INT = 0 
,@VersionId       VARCHAR(50) = 0 
,@PimProductId    TransferId Readonly
,@UserId		  INT = 0 
,@PimCategoryHierarchyId  INT = 0 
,@PimCatalogId INT = 0 
,@LocaleIds TransferId READONLY
,@PublishStateId INT = 0 
)
With RECOMPILE
AS
/*
DECLARE @rrte transferId 
INSERT INTO @rrte
select 1

EXEC [Znode_GetPublishProductbulk] @PublishCatalogId=3,@UserId= 2 ,@localeIDs = @rrte,@PublishStateId = 3 

*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @PortalId INT = (SELECT TOP 1 POrtalId FROM ZnodePortalCatalog WHERE PublishCatalogId = @PublishCatalogId)
	DECLARE @PriceListId INT = (SELECT TOP 1 PriceListId FROM ZnodePriceListPortal WHERE PortalId = @PortalId )
	DECLARE @DomainUrl varchar(max) = (select TOp 1 URL FROM ZnodeMediaConfiguration WHERE IsActive =1)
	DECLARE @MaxSmallWidth INT  = (SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodeGlobalMediaDisplaySetting)
	DECLARE @PimMediaAttributeId INT = dbo.Fn_GetProductImageAttributeId()

	DECLARE --@ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),
	@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
		--,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
   DECLARE @GetDate DATETIME =dbo.Fn_GetDate()

   declare @DefaultPortal int, @IsAllowIndexing int
	select @DefaultPortal = ZPC.PortalId, @IsAllowIndexing = 1 from ZnodePimCatalog ZPC Inner Join ZnodePublishCatalog ZPC1 ON ZPC.PimCatalogId = ZPC1.PimCatalogId where ZPC1.PublishCatalogId =  @PublishCatalogId and isnull(ZPC.IsAllowIndexing,0) = 1 

	-----delete unwanted publish data
	delete ZPC from ZnodePublishCategoryProduct ZPC
	where not exists(select * from ZnodePublishCategory ZC where ZPC.PublishCategoryId = ZC.PublishCategoryId )

	delete ZPP from ZnodePublishCategoryProduct ZPP
	where not exists(select * from ZnodePublishProduct ZP where ZPP.PublishProductId = ZP.PublishProductId )

	delete ZPP from ZnodePublishCatalogProductDetail ZPP
	where not exists(select * from ZnodePublishProduct ZP where ZPP.PublishProductId = ZP.PublishProductId )

	delete ZPCP from ZnodePublishCatalogProductDetail ZPCP
	inner join ZnodePublishProduct b on ZPCP.PublishProductId = b.PublishProductId 
	where not exists(select * from ZnodePimCategoryProduct a
	inner join ZnodePimCategoryHierarchy ZPCH on ZPCH.PimCategoryID = a.PimCategoryId 
	where b.PimProductId = A.PimProductId and ZPCP.PimCategoryHierarchyId = ZPCH.PimCategoryHierarchyId)
	and isnull(ZPCP.PimCategoryHierarchyId,0) <> 0 and b.PublishCatalogId = @PublishCatalogId
	---------

	 DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )
			
	INSERT INTO @TBL_LocaleId (LocaleId)
	SELECT  LocaleId
	FROM ZnodeLocale MT 
	WHERE IsActive = 1
	AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
	OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) 

	DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 

	create table #ZnodePrice (RetailPrice numeric(28,13),SalesPrice numeric(28,13),CurrencyCode varchar(100), CultureCode varchar(100), CurrencySuffix varchar(100), PublishProductId int)
	
	create table #ProductSKU (SEOUrl nvarchar(max), SEODescription  nvarchar(max),SEOKeywords  nvarchar(max),SEOTitle  nvarchar(max), PublishProductId int)

	create table #ProductImages (PublishProductId int, ImageSmallPath  varchar(max))

	EXEC Znode_InsertUpdatePimAttributeXML 1 
	EXEC Znode_InsertUpdateCustomeFieldXML 1
	EXEC Znode_InsertUpdateAttributeDefaultValue 1 

	EXEC [Znode_InsertUpdatePimCatalogProductDetail] @PublishCatalogId=@PublishCatalogId,@LocaleId=@LocaleIds,@UserId=@UserId

	if (@IsAllowIndexing=1)
	begin 
		insert into #ZnodePrice
		SELECT RetailPrice,SalesPrice,ZC.CurrencyCode,ZCC.CultureCode ,ZCC.Symbol CurrencySuffix,TYU.PublishProductId
		FROM ZnodePrice ZP 
		INNER JOIN ZnodePriceList ZPL ON (ZPL.PriceListId = ZP.PriceListId)
		INNER JOIN ZnodeCurrency ZC oN (ZC.CurrencyId = ZPL.CurrencyId )
		INNER JOIN ZnodeCulture ZCC ON (ZCC.CultureId = ZPL.CultureId)
		INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZP.SKU ) 
		INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId) 
		WHERE ZP.PriceListId = @PriceListId 
		AND TY.LocaleId = @DefaultLocaleId
		AND TYU.PublishCatalogId = @PublishCatalogId
		AND EXISTS (SELECT TOP 1 1 FROM ZnodePriceListPortal ZPLP 
		INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=ZPLP.PortalId WHERE ZPLP.PriceListId=ZP.PriceListId )
		AND EXISTS(select * from ZnodePimProduct ZPP1 where TYU.PimProductId = ZPP1.PimProductId )
	
		insert INTO #ProductImages
		SELECT  TYU.PublishProductId , @DomainUrl +'Catalog/'  + CAST(@DefaultPortal AS VARCHAr(100)) + '/'+ CAST(@MaxSmallWidth AS VARCHAR(100)) + '/' + RT.MediaPath AS ImageSmallPath   
		FROM ZnodePimAttributeValue ZPAV 
		INNER JOIN ZnodePublishProduct TYU ON (TYU.PimProductId  = ZPAV.PimProductId)
		INNER JOIN ZnodePimProductAttributeMedia  RT ON ( RT.PimAttributeValueId = ZPAV.PimAttributeValueId )
		WHERE  TYU.PublishCatalogId = @PublishCatalogId
		AND RT.LocaleId = @DefaultLocaleId
		AND ZPAV.PimAttributeId = (SELECT TOp 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'ProductImage')
		AND EXISTS(select * from ZnodePimProduct ZPP1 where TYU.PimProductId = ZPP1.PimProductId )
	
		insert INTO #ProductSKU 
		SELECT ZCSD.SEOUrl , ZCDL.SEODescription,ZCDL.SEOKeywords ,ZCDL.SEOTitle, TYU.PublishProductId
		FROM ZnodeCMSSEODetail ZCSD 
		INNER JOIN ZnodeCMSSEODetailLocale ZCDL ON (ZCDL.CMSSEODetailId = ZCSD.CMSSEODetailId)
		INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZCSD.SEOCode AND ZCDL.LocaleId = TY.LocaleId) 
		INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId)
		WHERE CMSSEOTypeId = (SELECT TOP 1 CMSSEOTypeId FROM ZnodeCMSSEOType WHERE Name = 'Product') 
		AND ZCDL.LocaleId = @DefaultLocaleId
		AND TYU.PublishCatalogId = @PublishCatalogId
		--AND ZCSD.PublishStateId = @PublishStateId
		AND ZCSD.PortalId = @DefaultPortal
		AND EXISTS(select * from ZnodePimProduct ZPP1 where TYU.PimProductId = ZPP1.PimProductId )

	end
	
CREATE NONCLUSTERED INDEX Idx_#ProductSKU_PublishProductId
ON [dbo].[#ProductSKU] ([PublishProductId])


CREATE NONCLUSTERED INDEX Idx_#ProductImages_PublishProductId
ON [dbo].#ProductImages ([PublishProductId])

CREATE NONCLUSTERED INDEX Idx_#ZnodePrice_PublishProductId
ON [dbo].#ZnodePrice ([PublishProductId])



SELECT ZPP.Pimproductid,ZPCPD.LocaleId,(SELECT Attributes as AttributeEntity  from ZnodePublishProductAttributeXML a where a.pimproductid = ZPP.pimproductid and a.LocaleId = ZPCPD.LocaleId FOR XML PATH('Attributes'), TYPE)   ProductXML
into #ProductAttributeXML
FROM [ZnodePublishCatalogProductDetail] ZPCPD 
INNER JOIN ZnodePublishProduct ZPP ON ZPCPD.PublishProductId = ZPP.PublishProductId and ZPCPD.PublishCatalogId = ZPP.PublishCatalogId --where TY.PimProductId = ZPP.PimProductId  AND TY.LocaleId = ZPCPD.LocaleId 
WHERE ZPCPD.PublishCatalogId = @PublishCatalogId
group by pimproductid,ZPCPD.LocaleId


CREATE NONCLUSTERED INDEX Idx_#ProductAttributeXML_PimProductId_LocaleId
ON [dbo].#ProductAttributeXML (PimProductId,LocaleId)

DECLARE @MaxCount INT, @MinRow INT, @MaxRow INT, @Rows numeric(10,2);
		SELECT @MaxCount = COUNT(*) FROM [ZnodePublishCatalogProductDetail] WHERE PublishCatalogId = @PublishCatalogId;

		SELECT @Rows = 5000
        
		SELECT @MaxCount = CEILING(@MaxCount / @Rows);

select PimCatalogProductDetailId, PublishProductId,Row_Number() over(Order by PublishProductId) ID into #ZnodePublishCatalogProductDetail from [ZnodePublishCatalogProductDetail] WHERE PublishCatalogId = @PublishCatalogId


--CREATE NONCLUSTERED INDEX #ZnodePublishCatalogProductDetail

		IF OBJECT_ID('tempdb..#Temp_ImportLoop') IS NOT NULL
            DROP TABLE #Temp_ImportLoop;
        
		---- To get the min and max rows for import in loop
		;WITH cte AS 
		(
			SELECT RowId = 1, 
				   MinRow = 1, 
                   MaxRow = cast(@Rows as int)
            UNION ALL
            SELECT RowId + 1, 
                   MinRow + cast(@Rows as int), 
                   MaxRow + cast(@Rows as int)
            FROM cte
            WHERE RowId + 1 <= @MaxCount
		)
        SELECT RowId, MinRow, MaxRow
        INTO #Temp_ImportLoop
        FROM cte
		option (maxrecursion 0);


		DECLARE cur_BulkData CURSOR LOCAL FAST_FORWARD
        FOR SELECT MinRow, MaxRow, B.LocaleId 
		FROM #Temp_ImportLoop L
		CROSS APPLY @TBL_LocaleId B;

        OPEN cur_BulkData;
        FETCH NEXT FROM cur_BulkData INTO  @MinRow, @MaxRow,@LocaleId;

        WHILE @@FETCH_STATUS = 0
        BEGIN

			if @VersionId = 0 and @PimCatalogId <> 0
				select @VersionId = max(PublishCatalogLogId) from ZnodePublishCatalogLog 
				where PublishCatalogId = (select top 1 PublishCatalogId from ZnodePublishCatalog where PimCatalogId = @PimCatalogId )
				AND LocaleId = @LocaleId

			if @VersionId = 0 and @PublishCatalogId <> 0 and @PimCatalogId = 0
				select @VersionId = max(PublishCatalogLogId) from ZnodePublishCatalogLog where PublishCatalogId = PublishCatalogId AND LocaleId = @LocaleId

			--SET @LocaleId = 1
			--(SELECT TOP 1 LocaleId FROM @TBL_LocaleId MT 
			--WHERE  RowId = @Counter)
			--if OBJECT_ID('tempdb..#ConfigProductDetail') is not null
			--	drop table #ConfigProductDetail

			--SELECT DISTINCT ZPCPA.PimProductId, --ZPA.AttributeCode, 
			--'<SelectValues>'+STUFF((select  ' '+'<SelectValuesEntity>','<VariantDisplayOrder>'+CAST(ISNULL(ZPPTA.DisplayOrder,0) AS VARCHAR(200))+'</VariantDisplayOrder>
			--					<VariantSKU>'+ISNULL((SELECT ''+ZPAVL_SKU.AttributeValue FOR XML Path ('')) ,'')+'</VariantSKU>
			--					<VariantImagePath>'+ISNULL((SELECT ''+ZM.Path FOR XML Path ('')),'')+'</VariantImagePath></SelectValuesEntity>'  
			--			from ZnodePimProductTypeAssociation ZPPTA--YUP ON (YUP.PimProductId = ZPAV1.PimProductId)
			--				 INNER JOIN ZnodePimAttributeValue ZPAV_SKU ON(ZPPTA.PimProductId = ZPAV_SKU.PimProductId)
			--				 INNER JOIN ZnodePimAttributeValueLocale ZPAVL_SKU ON (ZPAVL_SKU.PimAttributeValueId = ZPAV_SKU.PimAttributeValueId)
			--				 inner join ZnodePimAttribute ZPA1 ON ZPA1.PimAttributeId = ZPAV_SKU.PimAttributeId
			--				 INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId =ZPAV_SKU.PimProductId)
			--				 INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPAV.PimAttributevalueid = ZPAVL.PimAttributeValueId AND ZPAVL.AttributeValue = 'True')
			--				 inner join ZnodePimAttribute ZPA2 ON ZPA2.PimAttributeId = ZPAV.PimAttributeId
			--				 LEFT  JOIN ZnodePimAttributeValue ZPAV12 ON (ZPAV12.PimProductId= ZPPTA.PimProductId  AND ZPAV12.PimAttributeId = @PimMediaAttributeId ) 
			--				 LEFT JOIN ZnodePimProductAttributeMedia ZPAVM ON (ZPAVM.PimAttributeValueId= ZPAV12.PimAttributeValueId ) 
			--				 LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = ZPAVM.MediaId)
			--			where ZPPTA.PimParentProductId = ZPCPA.PimProductId AND ZPA1.AttributeCode = 'SKU' and ZPA2.AttributeCode = 'IsActive'
			--FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues>' ConfigDataXML
			----FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues>' ConfigDataXML
			--into #ConfigProductDetail
			--FROM ZnodePimConfigureProductAttribute ZPCPA
			--inner join ZnodePimAttribute ZPA ON ZPA.PimAttributeId = ZPCPA.PimAttributeId
			--where exists(select * from #ZnodePublishCatalogProductDetail ZPCPD 
			--inner join ZnodePublishProduct ZPP ON ZPCPD.PublishProductId = ZPP.PublishProductId
			--where ZPCPA.PimProductId = ZPP.PimProductId and ZPCPD.Id BETWEEN @MinRow AND @MaxRow)

			INSERT INTO ZnodePublishedXml (PublishCatalogLogId
				,PublishedId
				,PublishedXML
				,IsProductXML
				,LocaleId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,PublishCategoryId)
			SELECT @VersionId,ZPCPD.PublishProductId, cast(replace(replace(replace('<ProductEntity><VersionId>'+CAST(@VersionId AS VARCHAR(50)) +'</VersionId><ZnodeProductId>'+CAST(ZPCPD.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><ZnodeCategoryIds>'+CAST(ISNULL(ZPCP.PublishCategoryId,'')  AS VARCHAR(50))+'</ZnodeCategoryIds><Name>'+CAST(ISNULL((SELECT ''+isnull(ZPCPD.ProductName,'') FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</Name>'+'<SKU>'+CAST(ISNULL((SELECT ''+ZPCPD.SKU FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKU>'+'<SKULower>'+CAST(ISNULL((SELECT ''+LOWER(ZPCPD.SKU) FOR XML PATH ('')),'') AS NVARCHAR(2000))+ '</SKULower>'+'<IsActive>'+CAST(ISNULL(ZPCPD.IsActive ,'0') AS VARCHAR(50))+'</IsActive>' 
				+'<ZnodeCatalogId>'+CAST(ZPCPD.PublishCatalogId  AS VARCHAR(50))+'</ZnodeCatalogId><IsParentProducts>'+CASE WHEN ZPCP.PublishCategoryId IS NULL THEN '0' ELSE '1' END  +'</IsParentProducts><CategoryName>'+CAST(ISNULL((SELECT ''+isnull(ZPCPD.CategoryName,'') FOR XML PATH ('')),'') AS NVARCHAR(2000)) +'</CategoryName><CatalogName>'+CAST(ISNULL((SELECT ''+isnull(ZPCPD.CatalogName,'') FOR XML PATH ('')),'') AS NVARCHAR(2000))+'</CatalogName><LocaleId>'+CAST( Isnull(ZPCPD.LocaleId,'') AS VARCHAR(50))+'</LocaleId>'
			+Case When @IsAllowIndexing = 1 then 	
				+'<RetailPrice>'+ISNULL(CAST(TBZP.RetailPrice  AS VARCHAr(500)),'')+'</RetailPrice>'
				+'<SalesPrice>'+ISNULL(CAST(TBZP.SalesPrice AS VARCHAr(500)), '') +'</SalesPrice>'
				+'<CurrencyCode>'+ISNULL(TBZP.CurrencyCode,'') +'</CurrencyCode>'
				+'<CultureCode>'+ISNULL(TBZP.CultureCode,'') +'</CultureCode>'
				+'<CurrencySuffix>'+ISNULL(TBZP.CurrencySuffix,'') +'</CurrencySuffix>'
				+'<SeoUrl>'+ISNULL(TBPS.SEOUrl,'') +'</SeoUrl>'
				+'<SeoDescription>'+ISNULL((SELECT ''+TBPS.SEODescription FOR XML PATH('') ),'') +'</SeoDescription>'
				+'<SeoKeywords>'+ISNULL((SELECT ''+TBPS.SEOKeywords FOR XML PATH('')),'') +'</SeoKeywords>'
				+'<SeoTitle>'+ISNULL((SELECT ''+SEOTitle FOR XML PATH('')),'') +'</SeoTitle>'
				+'<ImageSmallPath>'+ISNULL(TBPI.ImageSmallPath,'') +'</ImageSmallPath>'
			else '' End	
				+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
								FROM ZnodeProfile ZPFC 
								WHERE isnull(ZPFC.PimCatalogId,0) = isnull(ZPCH.PimCatalogId,0) FOR XML PATH('')),2,8000),'')+'</TempProfileIds>
				<ProductIndex>'+CAST(ZPCPD.ProductIndex AS VARCHAr(100))+'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
				'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+cast(PAX.ProductXML as varchar(max))
				+'</ProductEntity>','&','&amp;'),'&amp;amp;','&amp;'),'&amp;amp;amp;','&amp;') as XML)  xmlvalue,1,ZPCPD.LocaleId,@UserId , @GetDate , @UserId,@GetDate,ZPCP.PublishCategoryId
			FROM [ZnodePublishCatalogProductDetail] ZPCPD
			INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPCPD.PublishCatalogId)
			INNER JOIN ZnodePublishProduct ZPP ON ZPCPD.PublishProductId = ZPP.PublishProductId and ZPCPD.PublishCatalogId = ZPP.PublishCatalogId
			inner join #ProductAttributeXML PAX ON PAX.PimProductId = ZPP.PimProductId  AND PAX.LocaleId = ZPCPD.LocaleId 
			inner join #ZnodePublishCatalogProductDetail z on ZPCPD.PimCatalogProductDetailId = z.PimCatalogProductDetailId
			LEFT JOIN #ZnodePrice TBZP ON (TBZP.PublishProductId = ZPCPD.PublishProductId)
			LEFT JOIN #ProductSKU TBPS ON (TBPS.PublishProductId = ZPCPD.PublishProductId)
			LEFT JOIN #ProductImages TBPI ON (TBPI.PublishProductId = ZPCPD.PublishProductId)
			LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPCPD.PublishProductId AND ZPCP.PublishCatalogId = ZPCPD.PublishCatalogId AND ZPCP.PimCategoryHierarchyId = ZPCPD.PimCategoryHierarchyId)
			LEFT JOIN ZnodePublishCategory ZPC ON (ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId AND ZPCP.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId)
			LEFT JOIN ZnodePimCategoryHierarchy ZPCH ON ( ZPCH.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId AND ZPCH.PimCatalogId = ZPCV.PimCatalogId )
			LEFT JOIN ZnodePimCategoryProduct ZPCCF ON ( ZPCH.PimCategoryId = ZPCCF.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId )
			--LEFT JOIN #ConfigProductDetail CPD ON ZPP.PimProductId = CPD.PimProductId
			WHERE ZPCPD.LocaleId = @LocaleId and z.Id BETWEEN @MinRow AND @MaxRow
			AND ZPCPD.PublishCatalogId = @PublishCatalogId

			set @VersionId = 0

			FETCH NEXT FROM cur_BulkData INTO  @MinRow, @MaxRow,@LocaleId;
        END;
		CLOSE cur_BulkData;
		DEALLOCATE cur_BulkData;

	
	
END
go
if exists(select * from sys.procedures where name ='Znode_GetPublishProductJson')
	drop proc Znode_GetPublishProductJson
go
CREATE PROCEDURE [dbo].[Znode_GetPublishProductJson]
(
	 @PublishCatalogId INT = 0 
	,@PimProductId     TransferId Readonly
	,@UserId		   INT = 0	
	,@PimCatalogId     INT = 0 
	,@VersionIdString  VARCHAR(100)= ''
	,@Status		   Bit  OutPut
	,@RevisionState   Varchar(50) = ''
)
With RECOMPILE
AS
/*
DECLARE @rrte transferId 
INSERT INTO @rrte
select 1

EXEC [_POC_Znode_GetPublishProductbulk] @PublishCatalogId=9,@UserId= 2 ,@localeIDs = @rrte,@PublishStateId = 3 

*/
BEGIN
Begin Try 
	SET NOCOUNT ON;
	Set @Status = 0  
	Declare  @RevisionType VARCHAR(50) = '' 
	Declare @VersionId int = 0 
	DECLARE @PortalId INT = (SELECT TOP 1 POrtalId FROM ZnodePortalCatalog WHERE PublishCatalogId = @PublishCatalogId)
	DECLARE @PriceListId INT = (SELECT TOP 1 PriceListId FROM ZnodePriceListPortal WHERE PortalId = @PortalId )
	DECLARE @DomainUrl varchar(max) = (select TOp 1 URL FROM ZnodeMediaConfiguration WHERE IsActive =1)
	DECLARE @MaxSmallWidth INT  = (SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodeGlobalMediaDisplaySetting)
	DECLARE @PimMediaAttributeId INT = dbo.Fn_GetProductImageAttributeId()

	DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT , VersionId int,RevisionType varchar(50)  )
	DECLARE @LocaleIds transferId 

    INSERT INTO @TBL_LocaleId (LocaleId,VersionId,RevisionType)
	SELECT PV.LocaleId , PV.VersionId , PV.RevisionType  FROM ZnodePublishVersionEntity PV Inner join Split(@VersionIdString,',') S ON PV.VersionId = S.Item
	
		


	Insert into @LocaleIds  
	SELECT  LocaleId
	FROM ZnodeLocale MT 
	WHERE IsActive = 1
	
	DECLARE --@ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),
	@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
		--,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
    DECLARE @GetDate DATETIME =dbo.Fn_GetDate()

    DECLARE @DefaultPortal int, @IsAllowIndexing int
    select @DefaultPortal = ZPC.PortalId, @IsAllowIndexing = 1 from ZnodePimCatalog ZPC Inner Join ZnodePublishCatalog ZPC1 ON ZPC.PimCatalogId = ZPC1.PimCatalogId where ZPC1.PublishCatalogId =  @PublishCatalogId and isnull(ZPC.IsAllowIndexing,0) = 1 
   
   -----delete unwanted publish data
	delete ZPC from ZnodePublishCategoryProduct ZPC
	where not exists(select * from ZnodePublishCategory ZC where ZPC.PublishCategoryId = ZC.PublishCategoryId )

	delete ZPP from ZnodePublishCategoryProduct ZPP
	where not exists(select * from ZnodePublishProduct ZP where ZPP.PublishProductId = ZP.PublishProductId )

	delete ZPP from ZnodePublishCatalogProductDetail ZPP
	where not exists(select * from ZnodePublishProduct ZP where ZPP.PublishProductId = ZP.PublishProductId )

	delete ZPCP from ZnodePublishCatalogProductDetail ZPCP
	inner join ZnodePublishProduct b on ZPCP.PublishProductId = b.PublishProductId 
	where not exists(select * from ZnodePimCategoryProduct a
	inner join ZnodePimCategoryHierarchy ZPCH on ZPCH.PimCategoryID = a.PimCategoryId 
	where b.PimProductId = A.PimProductId and ZPCP.PimCategoryHierarchyId = ZPCH.PimCategoryHierarchyId)
	and isnull(ZPCP.PimCategoryHierarchyId,0) <> 0 and b.PublishCatalogId = @PublishCatalogId
	---------


   DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 

   CREATE TABLE #ZnodePrice (RetailPrice numeric(28,13),SalesPrice numeric(28,13),CurrencyCode varchar(100), CultureCode varchar(100), CurrencySuffix varchar(100), PublishProductId int)
	
   CREATE TABLE #ProductSKU (SEOUrl nvarchar(max), SEODescription  nvarchar(max),SEOKeywords  nvarchar(max),SEOTitle  nvarchar(max), PublishProductId int)

	create table #ProductImages (PublishProductId int, ImageSmallPath  varchar(max))

	EXEC Znode_InsertUpdateAttributeDefaultValueJson 1 
	EXEC Znode_InsertUpdateCustomeFieldJson 1 
	EXEC Znode_InsertUpdatePimAttributeJson 1 

	EXEC [Znode_InsertUpdatePimCatalogProductDetailJson] @PublishCatalogId=@PublishCatalogId,@LocaleId=@LocaleIds ,@UserId=@UserId
	

	if (@IsAllowIndexing=1)
	begin 
		insert into #ZnodePrice
		SELECT RetailPrice,SalesPrice,ZC.CurrencyCode,ZCC.CultureCode ,ZCC.Symbol CurrencySuffix,TYU.PublishProductId
		FROM ZnodePrice ZP 
		INNER JOIN ZnodePriceList ZPL ON (ZPL.PriceListId = ZP.PriceListId)
		INNER JOIN ZnodeCurrency ZC oN (ZC.CurrencyId = ZPL.CurrencyId )
		INNER JOIN ZnodeCulture ZCC ON (ZCC.CultureId = ZPL.CultureId)
		INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZP.SKU ) 
		INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId) 
		WHERE ZP.PriceListId = @PriceListId 
		AND TY.LocaleId = @DefaultLocaleId
		AND TYU.PublishCatalogId = @PublishCatalogId
		AND EXISTS (SELECT TOP 1 1 FROM ZnodePriceListPortal ZPLP 
		INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=ZPLP.PortalId WHERE ZPLP.PriceListId=ZP.PriceListId )
		AND EXISTS(select * from ZnodePimProduct ZPP1 where TYU.PimProductId = ZPP1.PimProductId )
	
		insert INTO #ProductImages
		SELECT  TYU.PublishProductId , @DomainUrl +'Catalog/'  + CAST(@DefaultPortal AS VARCHAr(100)) + '/'+ CAST(@MaxSmallWidth AS VARCHAR(100)) + '/' + RT.MediaPath AS ImageSmallPath   
		FROM ZnodePimAttributeValue ZPAV 
		INNER JOIN ZnodePublishProduct TYU ON (TYU.PimProductId  = ZPAV.PimProductId)
		INNER JOIN ZnodePimProductAttributeMedia  RT ON ( RT.PimAttributeValueId = ZPAV.PimAttributeValueId )
		WHERE  TYU.PublishCatalogId = @PublishCatalogId
		AND RT.LocaleId = @DefaultLocaleId
		AND ZPAV.PimAttributeId = (SELECT TOp 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'ProductImage')
		AND EXISTS(select * from ZnodePimProduct ZPP1 where TYU.PimProductId = ZPP1.PimProductId )
	
		insert INTO #ProductSKU 
		SELECT ZCSD.SEOUrl , ZCDL.SEODescription,ZCDL.SEOKeywords ,ZCDL.SEOTitle, TYU.PublishProductId
		FROM ZnodeCMSSEODetail ZCSD 
		INNER JOIN ZnodeCMSSEODetailLocale ZCDL ON (ZCDL.CMSSEODetailId = ZCSD.CMSSEODetailId)
		INNER JOIN ZnodePublishProductDetail TY ON (TY.SKU = ZCSD.SEOCode AND ZCDL.LocaleId = TY.LocaleId) 
		INNER JOIN ZnodePublishProduct TYU ON (TYU.PublishProductId = TY.PublishProductId)
		WHERE CMSSEOTypeId = (SELECT TOP 1 CMSSEOTypeId FROM ZnodeCMSSEOType WHERE Name = 'Product') 
		AND ZCDL.LocaleId = @DefaultLocaleId
		AND TYU.PublishCatalogId = @PublishCatalogId
		--AND ZCSD.PublishStateId = @PublishStateId
		AND ZCSD.PortalId = @DefaultPortal
		AND EXISTS(select * from ZnodePimProduct ZPP1 where TYU.PimProductId = ZPP1.PimProductId )

	end
	
	CREATE NONCLUSTERED INDEX Idx_#ProductSKU_PublishProductId
	ON [dbo].[#ProductSKU] ([PublishProductId])
	CREATE NONCLUSTERED INDEX Idx_#ProductImages_PublishProductId
	ON [dbo].#ProductImages ([PublishProductId])
	CREATE NONCLUSTERED INDEX Idx_#ZnodePrice_PublishProductId
	ON [dbo].#ZnodePrice ([PublishProductId])

	SELECT ZPP.Pimproductid,ZPCPD.LocaleId,
	--'{"Attributes":[' +
	  '[' +
			(Select STUFF((SELECT ','+ Attributes from ZnodePublishProductAttributeJson a 
			where a.pimproductid = ZPP.pimproductid and a.LocaleId = ZPCPD.LocaleId 
			FOR XML Path (''),Type).value('.', 'varchar(max)') ,1,1,'')  ) 
	+ ']'
	--']}' 
	ProductXML
	into #ProductAttributeXML
	FROM [ZnodePublishCatalogProductDetail] ZPCPD 
	INNER JOIN ZnodePublishProduct ZPP ON ZPCPD.PublishProductId = ZPP.PublishProductId and ZPCPD.PublishCatalogId = ZPP.PublishCatalogId --where TY.PimProductId = ZPP.PimProductId  AND TY.LocaleId = ZPCPD.LocaleId 
	WHERE ZPCPD.PublishCatalogId = @PublishCatalogId
	group by pimproductid,ZPCPD.LocaleId


	CREATE NONCLUSTERED INDEX Idx_#ProductAttributeXML_PimProductId_LocaleId
	ON [dbo].#ProductAttributeXML (PimProductId,LocaleId)

	DECLARE @MaxCount INT, @MinRow INT, @MaxRow INT, @Rows numeric(10,2);
			SELECT @MaxCount = COUNT(*) FROM [ZnodePublishCatalogProductDetail] WHERE PublishCatalogId = @PublishCatalogId;

			SELECT @Rows = 5000
        
			SELECT @MaxCount = CEILING(@MaxCount / @Rows);

			select PimCatalogProductDetailId, PublishProductId,Row_Number() over(Order by PublishProductId) ID into #ZnodePublishCatalogProductDetail from [ZnodePublishCatalogProductDetail] WHERE PublishCatalogId = @PublishCatalogId


		--CREATE NONCLUSTERED INDEX #ZnodePublishCatalogProductDetail

		 IF OBJECT_ID('tempdb..#Temp_ImportLoop') IS NOT NULL
             DROP TABLE #Temp_ImportLoop;
        
		 ---- To get the min and max rows for import in loop
		 ;WITH cte AS 
		 (
			SELECT RowId = 1, 
				   MinRow = 1, 
                   MaxRow = cast(@Rows as int)
            UNION ALL
            SELECT RowId + 1, 
                   MinRow + cast(@Rows as int), 
                   MaxRow + cast(@Rows as int)
            FROM cte
            WHERE RowId + 1 <= @MaxCount
		)
        SELECT RowId, MinRow, MaxRow
        INTO #Temp_ImportLoop
        FROM cte
		option (maxrecursion 0);
		



		DECLARE cur_BulkData CURSOR LOCAL FAST_FORWARD
        FOR SELECT MinRow, MaxRow, B.LocaleId ,B.VersionId, B.RevisionType
		FROM #Temp_ImportLoop L
		CROSS APPLY @TBL_LocaleId B;

        OPEN cur_BulkData;
        FETCH NEXT FROM cur_BulkData INTO  @MinRow, @MaxRow,@LocaleId,@VersionId, @RevisionType
		WHILE @@FETCH_STATUS = 0
        BEGIN
				INSERT INTO ZnodePublishProductEntity (
					VersionId, --1
					IndexId, --2 
					ZnodeProductId,ZnodeCatalogId, --3
					SKU,LocaleId, --4 
					Name,ZnodeCategoryIds, --5
					IsActive,Attributes,Brands,CategoryName, --6 
					CatalogName,DisplayOrder, --7 
					RevisionType,AssociatedProductDisplayOrder, --8
					ProductIndex,--9
					SalesPrice,RetailPrice,CultureCode,CurrencySuffix,CurrencyCode,SeoDescription,SeoKeywords,SeoTitle,SeoUrl,ImageSmallPath,SKULower)
		
				Select 
					CAST(@VersionId AS VARCHAR(50)) VersionId --1 
					,CAST(ZPCPD.ProductIndex AS VARCHAr(100)) + CAST(ISNULL(ZPCP.PublishCategoryId,'')  AS VARCHAR(50))  + CAST(Isnull(ZPCPD.PublishCatalogId ,'')  AS VARCHAR(50)) + CAST( Isnull(ZPCPD.LocaleId,'') AS VARCHAR(50)) IndexId  --2
					,CAST(ZPCPD.PublishProductId AS VARCHAR(50)) PublishProductId,CAST(ZPCPD.PublishCatalogId  AS VARCHAR(50)) PublishCatalogId  --3 
					,CAST(ISNULL(ZPCPD.SKU ,'') AS NVARCHAR(2000)) SKU,CAST( Isnull(ZPCPD.LocaleId,'') AS VARCHAR(50)) LocaleId -- 4 
					,CAST(isnull(ZPCPD.ProductName,'') AS NVARCHAR(2000) )  ProductName ,CAST(ISNULL(ZPCP.PublishCategoryId,'')  AS VARCHAR(50)) PublishCategoryId  -- 5 
					--'{"Attributes":[' + PAX.ProductXML + ']'
					,CAST(ISNULL(ZPCPD.IsActive ,'0') AS VARCHAR(50)) IsActive ,PAX.ProductXML,'[]' Brands,CAST(isnull(ZPCPD.CategoryName,'') AS NVARCHAR(2000)) CategoryName  --6
					,CAST(Isnull(ZPCPD.CatalogName,'')  AS NVARCHAR(2000)) CatalogName,CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50)) DisplayOrder  -- 7 
					,@RevisionType , 0 AssociatedProductDisplayOrder,-- pending  -- 8 
					ZPCPD.ProductIndex,  -- 9
					Case When @IsAllowIndexing = 1 then  ISNULL(CAST(TBZP.SalesPrice  AS VARCHAr(500)),'') else '' end SalesPrice , 
					Case When @IsAllowIndexing = 1 then  ISNULL(CAST(TBZP.RetailPrice  AS VARCHAr(500)),'') else '' end RetailPrice , 
					Case When @IsAllowIndexing = 1 then  ISNULL(TBZP.CultureCode ,'') else '' end CultureCode , 
					Case When @IsAllowIndexing = 1 then  ISNULL(TBZP.CurrencySuffix ,'') else '' end CurrencySuffix , 
					Case When @IsAllowIndexing = 1 then  ISNULL(TBZP.CurrencyCode ,'') else '' end CurrencyCode , 
					Case When @IsAllowIndexing = 1 then  ISNULL(TBPS.SEODescription,'') else '' end SEODescriptionForIndex,
					Case When @IsAllowIndexing = 1 then  ISNULL(TBPS.SEOKeywords,'') else '' end SEOKeywords,
					Case When @IsAllowIndexing = 1 then  ISNULL(SEOTitle,'') else '' end SEOTitle,
					Case When @IsAllowIndexing = 1 then  ISNULL(TBPS.SEOUrl ,'') else '' end SEOUrl,
					Case When @IsAllowIndexing = 1 then  ISNULL(TBPI.ImageSmallPath,'') else '' end ImageSmallPath,
					CAST(ISNULL(LOWER(ZPCPD.SKU) ,'') AS NVARCHAR(2000)) Lower_SKU
			
					FROM [ZnodePublishCatalogProductDetail] ZPCPD
					INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPCPD.PublishCatalogId)
					INNER JOIN ZnodePublishProduct ZPP ON ZPCPD.PublishProductId = ZPP.PublishProductId and ZPCPD.PublishCatalogId = ZPP.PublishCatalogId
					INNER JOIN #ProductAttributeXML PAX ON PAX.PimProductId = ZPP.PimProductId  AND PAX.LocaleId = ZPCPD.LocaleId 
					INNER JOIN #ZnodePublishCatalogProductDetail z on ZPCPD.PimCatalogProductDetailId = z.PimCatalogProductDetailId
					LEFT JOIN  #ZnodePrice TBZP ON (TBZP.PublishProductId = ZPCPD.PublishProductId)
					LEFT JOIN  #ProductSKU TBPS ON (TBPS.PublishProductId = ZPCPD.PublishProductId)
					LEFT JOIN  #ProductImages TBPI ON (TBPI.PublishProductId = ZPCPD.PublishProductId)
					LEFT JOIN  ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPCPD.PublishProductId AND ZPCP.PublishCatalogId = ZPCPD.PublishCatalogId AND ZPCP.PimCategoryHierarchyId = ZPCPD.PimCategoryHierarchyId)
					LEFT JOIN  ZnodePublishCategory ZPC ON (ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId AND ZPCP.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId)
					LEFT JOIN  ZnodePimCategoryProduct ZPCCF ON (ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId )
					LEFT JOIN  ZnodePimCategoryHierarchy ZPCH ON (ZPCH.PimCatalogId = ZPCV.PimCatalogId AND  ZPCH.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId)
					WHERE      ZPCPD.LocaleId = @LocaleId and z.Id BETWEEN @MinRow AND @MaxRow
					AND ZPCPD.PublishCatalogId = @PublishCatalogId
					SET @VersionId = 0
			FETCH NEXT FROM cur_BulkData INTO  @MinRow, @MaxRow,@LocaleId,@VersionId, @RevisionType
        END;
		CLOSE cur_BulkData;
		DEALLOCATE cur_BulkData;


		If @RevisionState = 'PREVIEW' 
			UPDATE ZnodePimProduct SET IsProductPublish = 1,PublishStateId =  DBO.Fn_GetPublishStateIdForPreview()  
			WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePublishProduct ZPP WHERE ZPP.PimProductId = ZnodePimProduct.PimProductId 
			AND ZPP.PublishCatalogId = @PublishCatalogId)
		Else
			UPDATE ZnodePimProduct SET IsProductPublish = 1,PublishStateId =  DBO.Fn_GetPublishStateIdForPublish()  
			WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePublishProduct ZPP WHERE ZPP.PimProductId = ZnodePimProduct.PimProductId 
			AND ZPP.PublishCatalogId = @PublishCatalogId)
		UPDATE ZnodePublishCatalogLog 
		SET IsProductPublished = 1 
		,PublishProductId = (SELECT  COUNT(DISTINCT PublishProductId) FROM ZnodePublishCategoryProduct ZPP 
		WHERE ZPP.PublishCatalogId = ZnodePublishCatalogLog.PublishCatalogId AND ZPP.PublishCategoryId IS NOT NULL) 
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_LocaleId TY  WHERE  TY.VersionId =ZnodePublishCatalogLog.PublishCatalogLogId )  


		SET @Status = 1 
END TRY 
BEGIN CATCH 
	SET @Status =0  
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
		@ErrorLine VARCHAR(100)= ERROR_LINE(),
		@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishProductJson 
		   @PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR	(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))
		+',@PimCatalogId = ' + CAST(@PimCatalogId AS varchar(20))
		+',@VersionIdString= ' + CAST(@VersionIdString AS varchar(20))
		  	
	EXEC Znode_InsertProcedureErrorLog
		@ProcedureName = 'Znode_GetPublishProductJson',
		@ErrorInProcedure = @Error_procedure,
		@ErrorMessage = @ErrorMessage,
		@ErrorLine = @ErrorLine,
		@ErrorCall = @ErrorCall;
END CATCH

END
go
if exists(select * from sys.procedures where name ='Znode_GetPublishSingleProduct')
	drop proc Znode_GetPublishSingleProduct
go
CREATE PROCEDURE [dbo].[Znode_GetPublishSingleProduct]
(
 @PublishCatalogId INT = 0 
,@VersionId       VARCHAR(50) = 0 
,@PimProductId    TransferId Readonly 
,@UserId		  INT = 0 
,@TokenId nvarchar(max)= ''	
,@LocaleIds TransferId READONLY
,@PublishStateId INT = 0  
)
AS


--Declare @PimProductId TransferId 
--insert into @PimProductId  select 128 
-- EXEC [Znode_GetPublishSingleProduct]  @PublishCatalogId = 0 ,@VersionId= 0 ,@PimProductId =@PimProductId, @UserId=2 

BEGIN 
 
 SET NOCOUNT ON 

EXEC Znode_InsertUpdatePimAttributeXML 1 
EXEC Znode_InsertUpdateCustomeFieldXML 1
EXEC Znode_InsertUpdateAttributeDefaultValue 1 

Select ZPLPD.PimParentProductId, ZPLPD.PimProductId, ZPLPD.PimAttributeId, ZPAVL.AttributeValue as SKU
into #LinkProduct
FROM ZnodePimLinkProductDetail ZPLPD 
INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = ZPLPD.PimProductId)
INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
WHERE exists(select * from ZnodePimAttribute ZPA where ZPA.PimAttributeId = ZPAV.PimAttributeId and ZPA.AttributeCode = 'SKU')
and exists(select * from @PimProductId pp where ZPLPD.PimParentProductId = pp.Id)

 IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
	DROP TABLE #Cte_BrandData
 END 

--DECLARE @PimProductAttributeXML TABLE(PimAttributeXMLId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
CREATE TABLE #PimProductAttributeXML (PimAttributeXMLId INT  PRIMARY KEY ,PimAttributeId INT,LocaleId INT  )
DECLARE @PimDefaultValueLocale  TABLE (PimAttributeDefaultXMLId INT  PRIMARY KEY ,PimAttributeDefaultValueId INT ,LocaleId INT ) 
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


DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 

 CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT   , VersionId INT ,LocaleId INT, PriceListId INT , PortalId INT ,MaxSmallWidth NVARCHAr(max)  )
CREATE INDEX idx_#TBL_PublishCatalogIdPimProductId on #TBL_PublishCatalogId(PimProductId)
CREATE INDEX idx_#TBL_PublishCatalogIdPimPublishCatalogId on #TBL_PublishCatalogId(PublishCatalogId)
			
			INSERT INTO #TBL_PublishCatalogId 
			 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId, MAX(PublishCatalogLogId) ,LocaleId ,
			 (SELECT TOP 1 PriceListId FROM ZnodePriceListPortal NT 
			 INNER JOIN ZnodePimCatalog ZPC on ZPC.PortalId=NT.PortalId  
			 ORDER BY NT.Precedence ASC ) ,TY.PortalId
							, (SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodeGlobalMediaDisplaySetting)
			 FROM ZnodePublishProduct ZPP 
			 INNER JOIN ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
			 LEFT JOIN ZnodePortalCatalog TY ON (TY.PublishCatalogId = ZPP.PublishCatalogId)
			 WHERE (EXISTS (SELECT TOP 1 1 FROM @PimProductId SP WHERE SP.Id = ZPP.PimProductId  AND  (@PublishCatalogId IS NULL OR @PublishCatalogId = 0 ))
			 OR  (ZPP.PublishCatalogId = @PublishCatalogId ))
			 AND IsCatalogPublished =1
			 AND ZPCP.PublishStateId = @PublishStateId 
			 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,PimProductId,LocaleId,TY.PortalId


		
             DECLARE   @TBL_ZnodeTempPublish TABLE (PimProductId INT , AttributeCode VARCHAR(300) ,AttributeValue NVARCHAR(max) ) 			
			 DECLARE @TBL_AttributeVAlueLocale TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT,LocaleId INT ,AttributeValue Nvarchar(1000) )


			 INSERT INTO @TBL_AttributeVAlueLocale (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId ,LocaleId ,AttributeValue )
			 SELECT VIR.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId,VIR.LocaleId, ''
			 FROM View_LoadManageProductInternal VIR
			 INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = VIR.PimProductId)
			 UNION ALL 
			 SELECT VIR.PimProductId,PimAttributeId,PimProductAttributeMediaId,ZPDE.LocaleId , ''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimProductAttributeMedia ZPDE ON (ZPDE.PimAttributeValueId = VIR.PimAttributeValueId )
			 WHERE EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,ZPDVL.PimAttributeDefaultValueLocaleId,ZPDVL.LocaleId ,ZPDVL.AttributeDefaultValue
			   FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON ZPADV.PimAttributeId = D.PimAttributeId
			 INNER JOIN ZnodePimAttributeDefaultValueLocale ZPDVL   on (ZPADV.PimAttributeDefaultValueId = ZPDVL.PimAttributeDefaultValueId)
			 --INNER JOIN ZnodePimProductAttributeDefaultValue ZPDVP ON (ZPDVP.PimAttributeValueId = VIR.PimAttributeValueId AND ZPADV.PimAttributeDefaultValueId = ZPDVP.PimAttributeDefaultValueId )
			 WHERE ( ZPDVL.LocaleId = @DefaultLocaleId OR ZPDVL.LocaleId = @LocaleId )
			 AND EXISTS(SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
			 Union All 
			 SELECT VIR.PimProductId,VIR.PimAttributeId,'','' ,''
			 FROM ZnodePimAttributeValue  VIR
			 INNER JOIN ZnodePimAttribute D ON ( D.PimAttributeId=VIR.PimAttributeId AND D.IsPersonalizable =1 )
			 WHERE  EXISTS(SELECT TOP 1 1 FROM #TBL_PublishCatalogId ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )

		
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
				--AND 
				--EXISTS (SELECT TOP 1 1  FROM #TBL_PublishCatalogId TUI WHERE  TUI.PublishProductId = TYU.PublishProductId AND TUI.PublishCatalogId = TYU.PublishCatalogId)
				INNER JOIN #TBL_PublishCatalogId TUI ON (TUI.PublishProductId = TYU.PublishProductId AND TUI.PublishCatalogId = TYU.PublishCatalogId
						AND  TUI.LocaleId = dbo.Fn_GetDefaultLocaleId() )
				INNER JOIN ZnodePublishCatalog ZPC ON (TYU.PublishCatalogId = ZPC.PublishCatalogId)
				INNER JOIN ZnodePimCatalog ZPC1 ON (ZPC.PimCatalogId = ZPC1.PimCatalogId)
				WHERE  RT.LocaleId = dbo.Fn_GetDefaultLocaleId()
				AND ZPAV.PimAttributeId = (SELECT TOp 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'ProductImage')
				group by TUI.PublishCatalogId, TYU.PublishProductId ,isnull(RT.MediaPath,''),isnull(ZPC1.IsAllowIndexing,0) 
		  -- end
		    
WHILE @Counter <= @maxCountId
BEGIN
 SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId WHERE RowId = @Counter)
 

  INSERT INTO #PimProductAttributeXML 
  SELECT PimAttributeXMLId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeXML
  WHERE LocaleId = @LocaleId

  INSERT INTO #PimProductAttributeXML 
  SELECT PimAttributeXMLId ,PimAttributeId,LocaleId
  FROM ZnodePimAttributeXML ZPAX
  WHERE ZPAX.LocaleId = @DefaultLocaleId  
  AND NOT EXISTS (SELECT TOP 1 1 FROM #PimProductAttributeXML ZPAXI WHERE ZPAXI.PimAttributeId = ZPAX.PimAttributeId )

  INSERT INTO @PimDefaultValueLocale
  SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultXML
  WHERE localeId = @LocaleId

  INSERT INTO @PimDefaultValueLocale 
   SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId 
  FROM ZnodePimAttributeDefaultXML ZX
  WHERE localeId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM @PimDefaultValueLocale TRTR WHERE TRTR.PimAttributeDefaultValueId = ZX.PimAttributeDefaultValueId)
  
 
  --DECLARE @TBL_AttributeVAlue TABLE(PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )
  --DECLARE @TBL_CustomeFiled TABLE (PimCustomeFieldXMLId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )
  CREATE TABLE #TBL_CustomeFiled  (PimCustomeFieldXMLId INT ,CustomCode VARCHAR(300),PimProductId INT ,LocaleId INT )
  CREATE TABLE #TBL_AttributeVAlue (PimProductId INT,PimAttributeId INT,ZnodePimAttributeValueLocaleId INT  )



  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldXMLId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldXMLId,RTR.PimProductId ,RTR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldXML RTR 
  INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = RTR.PimProductId)
  WHERE RTR.LocaleId = @LocaleId
 

  INSERT INTO #TBL_CustomeFiled (PimCustomeFieldXMLId,PimProductId ,LocaleId,CustomCode)
  SELECT  PimCustomeFieldXMLId,ITR.PimProductId ,ITR.LocaleId,CustomCode
  FROM ZnodePimCustomeFieldXML ITR
  INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ITR.PimProductId)
  WHERE ITR.LocaleId = @DefaultLocaleId
  AND NOT EXISTS (SELECT TOP 1 1 FROM #TBL_CustomeFiled TBL  WHERE ITR.CustomCode = TBL.CustomCode AND ITR.PimProductId = TBL.PimProductId)
  

    INSERT INTO #TBL_AttributeVAlue (PimProductId ,PimAttributeId ,ZnodePimAttributeValueLocaleId )
    SELECT PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId
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
	Select distinct ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
	Into #PimChildProductFacets
	from ZnodePimAttributeValue ZPAV_Parent
	inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Parent.PimAttributeValueId = ZPPADV.PimAttributeValueId 
	where exists(select * from #TBL_PublishCatalogId ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )

	----Getting child facets for merging	
	insert into #PimChildProductFacets	  
	Select distinct ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
	from ZnodePimAttributeValue ZPAV_Parent
	inner join ZnodePimProductTypeAssociation ZPPTA ON ZPAV_Parent.PimProductId = ZPPTA.PimParentProductId
	inner join ZnodePimAttributeValue ZPAV_Child ON ZPPTA.PimProductId = ZPAV_Child.PimProductId AND ZPAV_Parent.PimAttributeId = ZPAV_Child.PimAttributeId
	inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Child.PimAttributeValueId = ZPPADV.PimAttributeValueId 
	where exists(select * from ZnodePimFrontendProperties ZPFP where ZPAV_Parent.PimAttributeId = ZPFP.PimAttributeId and ZPFP.IsFacets = 1)
	and exists(select * from #TBL_PublishCatalogId ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )
	and not exists(select * from ZnodePimProductAttributeDefaultValue ZPPADV1 where ZPAV_Parent.PimAttributeValueId = ZPPADV1.PimAttributeValueId 
		            and ZPPADV1.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )

	----Merging childs facet attribute Default value XML for parent
	select  ZPADX.DefaultValueXML, ZPPADV.PimAttributeValueId, ZPPADV.LocaleId
	into #PimAttributeDefaultXML
	from #PimChildProductFacets ZPPADV		  
	inner join ZnodePimAttributeDefaultXML ZPADX ON ( ZPPADV.PimAttributeDefaultValueId = ZPADX.PimAttributeDefaultValueId AND ZPPADV.LocaleId = ZPADX.LocaleId)
	INNER JOIN @PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = ZPADX.PimAttributeDefaultXMLId)
	------------Facet Merging Patch --------------   

INSERT INTO @TBL_ZnodeTempPublish  
SELECT  a.PimProductId,a.AttributeCode , '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(a.AttributeValue,'')+'</AttributeValues> </AttributeEntity>  </Attributes>'  AttributeValue
FROM View_LoadManageProductInternal a 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = a.PimAttributeId )
INNER JOIN #PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN #TBL_AttributeVAlue CTE ON (Cte.PimAttributeId = a.PimAttributeId AND Cte.ZnodePimAttributeValueLocaleId = a.ZnodePimAttributeValueLocaleId)
UNION ALL 
SELECT  a.PimProductId,c.AttributeCode , '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+TAVL.AttributeValue+'</AttributeValues> </AttributeEntity>  </Attributes>'  AttributeValue
FROM ZnodePimAttributeValue  a 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = a.PimAttributeId )
INNER JOIN #PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN ZnodePImAttribute ZPA  ON (ZPA.PimAttributeId = a.PimAttributeId)
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = a.PimProductId)
Inner JOIN @TBL_AttributeVAlueLocale TAVL ON  (c.PimAttributeId = TAVL.PimAttributeId  and ZPP.PimProductId = TAVL.PimProductId )
WHERE ZPA.IsPersonalizable = 1 
AND NOT EXISTS ( SELECT TOP 1 1 FROM ZnodePimAttributeValueLocale q WHERE q.PimAttributeValueId = a.PimAttributeValueId) 



UNION ALL 
SELECT THB.PimProductId,THB.CustomCode,'<Attributes><AttributeEntity>'+CustomeFiledXML +'</AttributeEntity></Attributes>' 
FROM ZnodePimCustomeFieldXML THB 
INNER JOIN #TBL_CustomeFiled TRTE ON (TRTE.PimCustomeFieldXMLId = THB.PimCustomeFieldXMLId)
UNION ALL 
SELECT ZPAV.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues></AttributeValues>'+'<SelectValues>'+
			   STUFF((
                    SELECT '  '+ DefaultValueXML  FROM #PimAttributeDefaultXML ZPADV 
				 WHERE (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId)
    FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues> </AttributeEntity></Attributes>' AttributeValue
 
FROM ZnodePimAttributeValue ZPAV  With (NoLock)
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN #PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
UNION ALL 
SELECT DISTINCT  ZPAV.PimProductId,c.AttributeCode,'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+SUBSTRING((SELECT DISTINCT ',' +MediaPath 
	FROM ZnodePimProductAttributeMedia ZPPG
	INNER JOIN  #TBL_AttributeVAlue TBLV ON (TBLV.PimProductId=  ZPAV.PimProductId AND TBLV.PimAttributeId = ZPAV.PimAttributeId )
    WHERE ZPPG.PimProductAttributeMediaId = TBLV.ZnodePimAttributeValueLocaleId
	FOR XML PATH ('')
 ),2,4000)+'</AttributeValues></AttributeEntity></Attributes>' AttributeValue
 	 
FROM ZnodePimAttributeValue ZPAV 
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN #PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeMedia ZPADVL WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
UNION ALL 
SELECT ZPLP.PimParentProductId ,c.AttributeCode, '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(SUBSTRING((SELECT ','+cast( LP.SKU as varchar(600)) 
							 FROM #LinkProduct LP
							 WHERE LP.PimParentProductId = ZPLP.PimParentProductId 
							 AND LP.PimAttributeId = ZPLP.PimAttributeId
							 FOR XML PATH ('') ),2,4000),'')+'</AttributeValues></AttributeEntity></Attributes>'   AttributeValue 
							
FROM ZnodePimLinkProductDetail ZPLP 
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPLP.PimParentProductId)
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPLP.PimAttributeId )
INNER JOIN #PimProductAttributeXML b ON (b.PimAttributeXMLId = c.PimAttributeXMLId )
GROUP BY ZPLP.PimParentProductId , ZPP.PublishProductId  ,ZPLP.PimAttributeId,c.AttributeCode,c.AttributeXML,ZPP.PublishCatalogId

UNION ALL 
SELECT ZPAV.PimProductId,'DefaultSkuForConfigurable' ,'<Attributes><AttributeEntity>'+REPLACE(REPLACE (c.AttributeXML,'ProductType','DefaultSkuForConfigurable'),'Product Type','Default Sku For Configurable')+'<AttributeValues>'+
 (SELECT TOP 1 AttributeValue FROM View_LoadManageProductInternal ad 
 INNER JOIN ZnodePimProductTypeAssociation yt ON (yt.PimProductId = ad.PimProductId)
 WHERE Ad.AttributeCode = 'SKU'
 AND yt.PimParentProductId = ZPAV.PimProductId
ORDER BY yt.DisplayOrder , yt.PimProductTypeAssociationId ASC)
+'</AttributeValues></AttributeEntity></Attributes>' AttributeValue 
FROM ZnodePimAttributeValue ZPAV  
INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = ZPAV.PimAttributeId )
INNER JOIN #TBL_PublishCatalogId ZPP ON (ZPP.PimProductId = ZPAV.PimProductId)
WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPADVL 
INNER JOIN ZnodePimAttributeDefaultValue dr ON (dr.PimAttributeDefaultValueId = ZPADVL.PimAttributeDefaultValueId)
 WHERE ZPADVL.PimAttributeValueId = ZPAV.PimAttributeValueId
 AND dr.AttributeDefaultValueCode= 'ConfigurableProduct' 
)
AND EXISTS (select * from #PimProductAttributeXML b where b.PimAttributeXMLId = c.PimAttributeXMLId)
AND c.AttributeCode = 'ProductType' 

UNION ALL
SELECT DISTINCT  UOP.PimProductId,c.AttributeCode,
'<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues></AttributeValues>'+'<SelectValues>'+
STUFF((
SELECT DISTINCT '  '+REPLACE(AA.DefaultValueXML,'</SelectValuesEntity>','<VariantDisplayOrder>'+CAST(ISNULL(ZPA.DisplayOrder,0) AS VARCHAR(200))+'</VariantDisplayOrder>
<VariantSKU>'+ISNULL(ZPAVL_SKU.AttributeValue,'')+'</VariantSKU></SelectValuesEntity>')   
FROM ZnodePimAttributeDefaultXML AA 
--INNER JOIN #PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = AA.PimAttributeDefaultXMLId)
INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
INNER JOIN ZnodePimAttributeValue ZPAV1 ON (ZPAV1.PimAttributeValueId= ZPADV.PimAttributeValueId )
-- check/join for active variants 
INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId =ZPAV1.PimProductId)
INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPAV.PimAttributevalueid = ZPAVL.PimAttributeValueId AND ZPAVL.AttributeValue = 'True')
INNER JOIN ZnodePimProductTypeAssociation YUP ON (YUP.PimProductId = ZPAV1.PimProductId)
-- SKU
INNER JOIN ZnodePimAttributeValue ZPAV_SKU ON(YUP.PimProductId = ZPAV_SKU.PimProductId)
INNER JOIN ZnodePimAttributeValueLocale ZPAVL_SKU ON (ZPAVL_SKU.PimAttributeValueId = ZPAV_SKU.PimAttributeValueId)
--LEFT  JOIN ZnodePimAttributeValue ZPAV12 ON (ZPAV12.PimProductId= YUP.PimProductId  AND ZPAV12.PimAttributeId = @PimMediaAttributeId ) 
--LEFT JOIN ZnodePimProductAttributeMedia ZPAVM ON (ZPAVM.PimAttributeValueId= ZPAV12.PimAttributeValueId ) 
--LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = ZPAVM.MediaId)
LEFT JOIN ZnodePimAttribute ZPA ON (ZPA.PimattributeId = ZPAV1.PimAttributeId)
WHERE (YUP.PimParentProductId  = UOP.PimProductId AND ZPAV1.pimAttributeId = UOP.PimAttributeId )
-- Active Variants
AND ZPAV.PimAttributeId = (SELECT TOP 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'IsActive')
-- VariantSKU
AND ZPAV_SKU.PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'SKU')
		FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues></AttributeEntity></Attributes> ' AttributeValue  --</AttributeEntity></Attributes>' 
		FROM ZnodePimConfigureProductAttribute UOP 
		INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = UOP.PimAttributeId )
		WHERE  exists(select * from #TBL_PublishCatalogId PPCP1 where UOP.PimProductId = PPCP1.PimProductId )
		AND EXISTS (select * from #PimProductAttributeXML b where b.PimAttributeXMLId = c.PimAttributeXMLId)
		
		-------------configurable attribute 
---------------------------------------------------------------------


---------brand details 
CREATE TABLE #Cte_BrandData (PimProductId int,BrandXML nvarchar(max))

INSERT INTO #Cte_BrandData ( PimProductId, BrandXML )
SELECT  DISTINCT ZBP.PimProductId,'<Brands><BrandEntity><BrandId>'+CAST(ZBD.BrandId AS VARCHAR(50))+'</BrandId><BrandCode>'+ZBD.BrandCode+'</BrandCode><BrandName>'+(SELECT ''+ZBDL.BrandName FOR XML PATH(''))+'</BrandName></BrandEntity></Brands>' as BrandXML					   		   
FROM [ZnodeBrandDetails] AS ZBD
INNER JOIN ZnodeBrandDetaillocale ZBDL ON ZBD.BrandId = ZBDL.BrandId
INNER JOIN [ZnodeBrandProduct] AS ZBP ON ZBD.BrandId = ZBP.BrandId

 DELETE FROM ZnodePublishedXML WHERE  IsProductXML = 1  AND LocaleId = @localeId 
								AND  EXISTS ( SELECT TOP 1 1 FROM  #TBL_PublishCatalogId  TBL WHERE TBL.VersionId  = ZnodePublishedXML.PublishCatalogLogId AND TBL.PublishProductId = ZnodePublishedXML.PublishedId)


;WITH CTE AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY PimProductId	,AttributeCode
ORDER BY PimProductId	,AttributeCode) AS RN
FROM @TBL_ZnodeTempPublish
)

DELETE FROM CTE WHERE RN<>1

 MERGE INTO ZnodePublishedXML TARGET 
 USING (
 SELECT distinct zpp.PublishProductId,zpp.VersionId ,
'<ProductEntity><VersionId>'+CAST(zpp.VersionId AS VARCHAR(50)) +'</VersionId><ZnodeProductId>'+
CAST(zpp.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><ZnodeCategoryIds>'
+CAST(ISNULL(ZPC.PublishCategoryId,'')  AS VARCHAR(50))+
'</ZnodeCategoryIds><Name>'+CAST(ISNULL((SELECT ''+ZPPDFG.ProductName FOR XML PATH ('')),'') AS NVARCHAR(2000))+
'</Name>'+'<SKU>'+CAST(ISNULL((SELECT ''+ZPPDFG.SKU FOR XML PATH ('')),'') AS NVARCHAR(2000))+
'</SKU><SKULower>'+CAST(ISNULL((SELECT ''+Lower(ZPPDFG.SKU) FOR XML PATH ('')),'') AS NVARCHAR(2000))+ 
'</SKULower>'+'<IsActive>'+CAST(ISNULL(ZPPDFG.IsActive ,'0') AS VARCHAR(50))+'</IsActive>' 
+'<ZnodeCatalogId>'+CAST(ZPP.PublishCatalogId  AS VARCHAR(50))+'</ZnodeCatalogId><IsParentProducts>'+CASE WHEN ZPCD.PublishCategoryId IS NULL THEN '0' ELSE '1' END  +
'</IsParentProducts>'+
Case When TBPS.IsAllowIndexing = 1 then
+'<RetailPrice>'+ISNULL(CAST(RetailPrice  AS VARCHAr(500)),'')+'</RetailPrice>'
+'<SalesPrice>'+ISNULL(CAST(SalesPrice AS VARCHAr(500)), '') +'</SalesPrice>'
+'<CurrencyCode>'+ISNULL(CurrencyCode,'') +'</CurrencyCode>'
+'<CultureCode>'+ISNULL(CultureCode,'') +'</CultureCode>'
+'<CurrencySuffix>'+ISNULL(CurrencySuffix,'') +'</CurrencySuffix>'
+'<SeoUrl>'+ISNULL(SEOUrl,'') +'</SeoUrl>'
+'<SeoDescription>'+ISNULL(SEODescription,'') +'</SeoDescription>'
+'<SeoKeywords>'+ISNULL(SEOKeywords,'') +'</SeoKeywords>'
+'<SeoTitle>'+ISNULL(SEOTitle,'') +'</SeoTitle>'
+'<ImageSmallPath>'+ISNULL(ImageSmallPath,'') +'</ImageSmallPath>'
else '' end
+
'<ProductIndex>'+CAST(ISNULL(ZPCP.ProductIndex,1)  AS VARCHAr(100))+
'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
+'<CategoryName>'+CAST(ISNULL((SELECT ''+PublishCategoryName FOR XML PATH ('')),'') AS NVARCHAR(2000))+
'</CategoryName><CatalogName>'+CAST(ISNULL((SELECT ''+CatalogName FOR XML PATH ('')),'') AS NVARCHAR(2000))+
'</CatalogName><LocaleId>'+CAST( @LocaleId AS VARCHAR(50))+'</LocaleId>'
+'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+
ISNULL(STUFF(( SELECT '  '+ BrandXML  FROM #Cte_BrandData BD WHERE BD.PimProductId = ZPP.PimProductId   
				FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, ''),'')+
STUFF(( SELECT '  '+ AttributeValue  FROM @TBL_ZnodeTempPublish TY WHERE TY.PimProductId = ZPP.PimProductId   
	FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</ProductEntity>' xmlvalue
	FROM  #TBL_PublishCatalogId zpp
	INNER JOIN ZnodePublishCatalog ZPCV ON (ZPCV.PublishCatalogId = ZPP.PublishCatalogId)
	INNER JOIN ZnodePublishProductDetail ZPPDFG ON (ZPPDFG.PublishProductId =  ZPP.PublishProductId)

	LEFT JOIN #ZnodePrice TBZP ON (TBZP.PublishProductId = ZPP.PublishProductId)
	LEFT JOIN #ProductSKU TBPS ON (TBPS.PublishProductId = ZPP.PublishProductId)
	LEFT JOIN #ProductImages TBPI ON (TBPI.PublishProductId = ZPP.PublishProductId  )
	LEFT JOIN ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishProductId = ZPP.PublishProductId AND ZPCP.PublishCatalogId = ZPP.PublishCatalogId)
	LEFT JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCatalogId = ZPC.PublishCatalogId AND   ZPC.PublishCategoryId = ZPCP.PublishCategoryId)
	LEFT JOIN ZnodePimCategoryProduct ZPCCF ON (ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId )
	LEFT JOIN ZnodePimCategoryHierarchy ZPCH ON (ZPCH.PimCatalogId = ZPCV.PimCatalogId AND  ZPCH.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId) 
	LEFT JOIN ZnodePublishCategoryDetail ZPCD ON (ZPCD.PublishCategoryId = ZPCP.PublishCategoryId AND ZPCD.LocaleId = @LocaleId )
	WHERE ZPPDFG.LocaleId = @LocaleId
	AND zpp.LocaleId = @LocaleId
	) SOURCE 
	ON (
     TARGET.PublishCatalogLogId = SOURCE.versionId 
	 AND TARGET.PublishedId = SOURCE.PublishProductId
	 AND TARGET.IsProductXML = 1 
	 AND TARGET.LocaleId = @localeId 
)
WHEN MATCHED THEN 
UPDATE 
SET  PublishedXML = xmlvalue
   , ModifiedBy = @userId 
   ,ModifiedDate = @GetDate
   ,ImportedGuId = @TokenId 
WHEN NOT MATCHED THEN 
INSERT (PublishCatalogLogId
,PublishedId
,PublishedXML
,IsProductXML
,LocaleId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate,ImportedGuId)

VALUES (SOURCE.versionid , Source.publishProductid,Source.xmlvalue,1,@localeid,@userId,@getDate,@userId,@getDate,@TokenId);

DELETE FROM @TBL_ZnodeTempPublish
IF OBJECT_ID('tempdb..#PimProductAttributeXML') is not null
 BEGIN 
	DELETE FROM #PimProductAttributeXML
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


 IF OBJECT_ID('tempdb..#Cte_BrandData') is not null
 BEGIN 
  DROP TABLE #Cte_BrandData
 END 

SET @Counter = @counter + 1 
END

END
go
if exists(select * from sys.procedures where name ='Znode_GetPublishSingleProductJson')
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

			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(CAST(SalesPrice  AS varchar(500)),'') else '' end SalesPrice , 
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(CAST(RetailPrice  AS varchar(500)),'') else '' end RetailPrice , 
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(CultureCode ,'') else '' end CultureCode , 
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(CurrencySuffix ,'') else '' end CurrencySuffix , 
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(CurrencyCode ,'') else '' end CurrencyCode , 
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(SEODescription,'') else '' end SEODescriptionForIndex,
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(SEOKeywords,'') else '' end SEOKeywords,
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(SEOTitle,'') else '' end SEOTitle,
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(SEOUrl ,'') else '' end SEOUrl,
			Case When TBPS.IsAllowIndexing = 1 then  ISNULL(ImageSmallPath,'') else '' end ImageSmallPath,
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
if exists(select * from sys.procedures where name ='Znode_PurgeData')
	drop proc Znode_PurgeData
go

CREATE PROCEDURE [dbo].[Znode_PurgeData] 
(
 
  @DeleteAllProduct    							BIT = 0 -- This flag 1 will delete all product except ids in @ExceptProductId  table 
 ,@DeleteAllCategory							BIT = 0 -- This flag 1 will delete all category except ids in @ExceptCategoryId  table 
 ,@DeleteAllCatalog								BIT = 0 -- This flag 1 will delete all catalog except ids in @ExceptCatalogId  table 
 ,@DeleteAllSaveCart							Bit = 0	-- This flag 1 will delete all save carts of users.  
 ,@DeleteAllOrder								BIT = 0	-- This flag 1 will delete all orders. 
 ,@DeleteAllAccount								BIT = 0 -- This flag 1 will delete all Account. 
 ,@DeleteAllUser								BIT = 0 -- This flag 1 will delete all user. 
 ,@DeleteAllStore 								BIT = 0 -- This flag 1 will delete all store. 
 ,@DeleteAllGlobalAttribute  					BIT = 0 -- This flag 1 will delete all Global Attribute. 
 ,@DeleteAllProductCategoryAttribute			BIT = 0 -- This flag 1 will delete all Pim Attribute. 
 ,@DeleteAllMedia								BIT = 0 -- This flag 1 will delete all media. 
 ,@DeleteAllWarehouse							BIT = 0 -- This flag 1 will delete all warhouse. 
 ,@DeleteAllPricelist							BIT = 0 -- This flag 1 will delete all price list. 
 ,@DeleteAllProfile								BIT = 0 -- This flag 1 will delete all Profiles. 
 ,@DeleteAllSiteSearchData						BIT = 0	-- This flag 1 will delete all data related to search. 
 ,@DeleteAllCMSData								BIT = 0 -- This flag 1 will delete all CMS data. 
 ,@DeleteAllBrand								BIT = 0 -- This flag 1 will delete all brand. 
 ,@DeleteAllVendor								BIT = 0 -- This flag 1 will delete all vendor. 
 ,@DeleteAllCmsSeoDetails						BIT = 0 -- This flag 1 will delete all Seo details .   
 ,@ResetDomainData								BIT = 0 -- This flag 1 will delete and rest all domain. 
 ,@ExceptProductId								TransferId Readonly
 ,@ExceptCategoryId								TransferId Readonly
 ,@ExceptCatalogId								TransferId Readonly
 ,@ExceptAccountId								TransferId Readonly
 ,@ExceptUserId 								TransferId Readonly
 ,@ExceptStoreId 								TransferId Readonly 
 ,@ExceptGlobalAttributeId 						TransferId Readonly
 ,@ExceptProductCategoryAttributeId 		    TransferId Readonly
 ,@ExceptMediaId								TransferId Readonly
 ,@ExceptWarehouseId							TransferId ReadOnly 
 ,@ExceptPricelistId							TransferId ReadOnly 
 ,@ExceptProfileId								TransferId ReadOnly
 ,@ExceptSeoType								VARCHAR(2000) = ''
 ,@ResetIdentity								BIT = 0    -- Reset identity 
 ,@DeleteAllData								BIT = 0 	
 ,@DeleteAllShippingMethods						BIT = 0 
 ,@DeleteAllPaymentMethods						BIT = 0 
 ,@DeleteAllTaxes								BIT = 0 
)
AS 
BEGIN 
SET NOCOUNT ON 
 	 BEGIN TRY
	    DECLARE @StatusOut Table (Id INT ,Message NVARCHAR(max), Status BIT )
		DECLARE @DeletedIds TransferId 
		DECLARE @PortalId INT , @CMSThemeId INT , @CMSThemeCSSId INT,@PublishCatalogId INT
		,@PimCatalogId INT  
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  Object_Id('elmah_error')	 <> 0 
		BEGIN 
			 TRUNCATE TABLE elmah_error
			 DELETE FROM ZnodeImportLog
			 DELETE FROM ZnodeImportProcesslog
			 DELETE FROM ZnodeActivityLog	
             DELETE FROM ZnodePasswordLog	
             DELETE FROM ZnodeProceduresErrorLog
		END 
	
		DECLARE @DeleteId  NVARCHAR(max)= '', @StoreData NVARCHAR(max),@RunTime INT =1 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllVendor = 1   OR @DeleteAllData =1 
			BEGIN 
			 	INSERT INTO @DeletedIds 
				SELECT PimVendorId 
				FROM ZnodePimVendor ZP 
							
				INSERT INTO @StatusOut(id ,Status) 
				EXEC [dbo].[Znode_DeleteVendor] @PimVendorIds = @DeletedIds ,@Status = 0  
			    
				DELETE FROM ZnodePimProductAttributeDefaultValue WHERE PimAttributeValueId IN (
				SELECT PimAttributeValueId  
				FROM ZnodePimAttributeValue WHERE PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode= 'Vendor') )
				
				DELETE FROM ZnodePimAttributeValue WHERE PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode= 'Vendor') 

				DELETE FROM ZnodePimAttributeDefaultValueLocale  WHERE PimAttributeDefaultValueId IN (
				SELECT PimAttributeDefaultValueId FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode IN (SELECT VendorCode FROM ZnodePimVendor ))
				
				DELETE FROM  ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode IN (SELECT VendorCode FROM ZnodePimVendor )

			    PRINT '<-- Vendor Data Deleted Sucessfully-->'
				
			END
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			IF  @DeleteAllBrand = 1  OR @DeleteAllData =1 
			BEGIN 
			   INSERT INTO @DeletedIds 
			   SELECT BrandId
			   FROM ZnodeBrandDetails a
			   INSERT INTO @StatusOut (Id ,Status) 
			   EXEC [dbo].[Znode_DeleteBrand] @BrandIds = @DeletedIds, @Status = 0   
			 IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Brand Data Deleted Sucessfully-->'
			   END
			   ELSE 
				BEGIN 
				PRINT '<-- Brand Data Not Deleted Properly -->' 
				END  
		    END 
				
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllProduct = 1  OR @DeleteAllData =1 
		BEGIN 
		   	 INSERT INTO @DeletedIds 
		     SELECT PimProductId 
			 FROM ZnodePimProduct ZPP 
			 WHERE NOT EXISTS (SELECT TOP 1 1 FROM @ExceptProductId WHERE id = ZPP.PimProductId) 
			  INSERT INTO @StatusOut (Id ,Status) 
			  EXEC [dbo].[Znode_DeletePimProducts] @PimProductIds=@DeletedIds , @Status = 0   
			
			SELECT PimAddonGroupId,PimProductId,PimAddOnProductId  
			INTO #Temp_Addon 
			FROM ZnodePimAddOnProduct ZPP
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM @ExceptProductId WHERE id = ZPP.PimProductId)

			DELETE FROM ZnodePimAddOnProductDetail WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddOnProductId  = ZnodePimAddOnProductDetail.PimAddOnProductId )
			
			DELETE FROM  ZnodePimAddOnProduct  WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddOnProductId  = ZnodePimAddOnProduct.PimAddOnProductId )
			
			DELETE FROM ZnodePimAddonGroupLocale WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddonGroupId  = ZnodePimAddonGroupLocale.PimAddonGroupId )
			DELETE FROM ZnodePimAddonGroupProduct 	WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddonGroupId  = ZnodePimAddonGroupProduct.PimAddonGroupId )
			DELETE FROM ZnodePimAddonGroup 	WHERE NOT EXISTS (SELECT TOP 1 1 FROM #Temp_Addon t 
							 WHERE t.PimAddonGroupId  = ZnodePimAddonGroup.PimAddonGroupId )
			IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Product Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Product Data Not Deleted Properly -->' 
				END  
			  
	    END 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllCategory = 1 	  OR @DeleteAllData =1 
		BEGIN   
		   		INSERT INTO @DeletedIds 
				SELECT  PimCategoryId 
				FROM ZnodePimCategory ZPC
				WHERE NOT EXISTS  (SELECT TOP 1 1 FROM @ExceptCategoryId WHERE id =ZPC.PimCategoryId )
				--Remove extra products from catalog
				INSERT INTO @StatusOut (Id ,Status) 
				EXEC Znode_DeletePimCategory @PimCategoryId = @DeletedIds, @Status = 1;
			
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Category Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Category Data Not Deleted Properly -->' 
				END     
		  END
		  DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		  IF  @DeleteAllCatalog = 1 	OR @DeleteAllData =1 
		   BEGIN
		   	 INSERT INTO @DeletedIds 
		   	 SELECT PimCatalogId 
			 FROM ZnodePimCatalog ZP 
			 WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptCatalogId WHERE id = ZP.PimCatalogId)
		   	 INSERT INTO @StatusOut (Id ,Message,Status) 
			 EXEC [dbo].[Znode_DeletePimCatalog] @PimCatalogId = @DeletedIds ,@IsForceFullyDelete = 1  
		      

			 IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Catalog Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Catalog Data Not Deleted Properly -->' 
				END  
           END
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		   IF  @DeleteAllOrder = 1 	OR @DeleteAllData =1 
		   BEGIN
				 INSERT INTO @DeletedIds 
		   		 SELECT OmsOrderID 
				 FROM ZnodeOmsOrder  ZP 
				 INSERT INTO @StatusOut (Id ,Status) 
			     EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIds , @status = 0  
		    
		        IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Order Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Order Data Not Deleted Properly -->' 
				END  
		  END
		
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut
		   IF  @DeleteAllSaveCart = 1  OR @DeleteAllData =1 
		   BEGIN
		      DELETE FROM ZnodeOmsPersonalizeCartItem
			  DELETE FROM ZnodeOmsSavedCartLineItem 
			  DELETE FROM ZnodeOmsSavedCart
			  DELETE FROM ZnodeOmsCookieMapping
			  DELETE FROM ZnodeOmsQuotePersonalizeItem 
			  DELETE FROM ZnodeOmsQuoteLineItem
			  DELETE FROM ZnodeOmsQuote
			  DELETE FROM ZnodeOmsTemplateLineItem 
			  DELETE FROM ZnodeOmsTemplate
			 
		      PRINT '<-- Save Cart & Quote Data Deleted Sucessfully -->'
			  
		   END
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		   IF  @DeleteAllUser = 1 OR @DeleteAllData =1 
		   BEGIN  
		  
			   INSERT INTO @DeletedIds 
			   SELECT UserId
			   FROM ZnodeUser ZU 
			   WHERE NOT EXISTS (SELECT TOP 1  1 FROM @ExceptUserId RT WHERE RT.Id = ZU.UserId) 
			 --  INSERT INTO @StatusOut (Id ,Status) 
			   EXEC Znode_DeleteUserDetails @UserIds =@DeletedIds ,@Status = 0 , @IsForceFullyDelete =1 

			DELETE FROM AspNetUsers  WHERE NOT EXISTS (SELECT TOP 1 1 FROM AspNetZnodeUser rt WHERE rt.AspNetZnodeUserId = AspNetUsers.UserName )

		     	PRINT '<-- User Data Deleted Sucessfully-->'
			  
		   END
	    DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllAccount = 1 	OR @DeleteAllData =1 
		  BEGIN    
				 INSERT INTO @DeletedIds 
				  SELECT AccountId
			      FROM ZnodeAccount ZU 
			      WHERE NOT EXISTS (SELECT TOP 1  1 FROM @ExceptAccountId RT WHERE RT.Id = ZU.AccountiD) 
			    -- INSERT INTO @StatusOut (Id ,Status) 
				  EXEC Znode_DeleteAccount @AccountIds =  @DeletedIds,@Status= 0,@IsForceFullyDelete =1  
				 
		     	PRINT '<-- Accouts Data Deleted Sucessfully-->'
			    
		  END
		 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		 IF  @DeleteAllGlobalAttribute = 1 	 OR @DeleteAllData =1 
		   BEGIN 
		   	INSERT INTO @DeletedIds 
			SELECT GlobalAttributeId 
			FROM ZnodeGlobalAttribute ZP 
			WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptGlobalAttributeId a WHERE a.Id = ZP.GlobalAttributeId)
			AND ISNULL(ZP.IsSystemDefined,0) <> 1
			INSERT INTO @StatusOut (Id ,Status) 	   
			EXEC [dbo].[Znode_DeleteGlobalAttribute] @GlobalAttributeIds= @DeletedIds,@Status =0 , 	@IsForceFullyDelete= 1    
			
			DELETE FROM ZnodeGlobalAttributeGroupLocale	WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1 )
			DELETE FROM ZnodeGlobalAttributeGroupMapper WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)
			DELETE FROM ZnodeGlobalGroupEntityMapper WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)
			DELETE FROM ZnodeFormBuilderAttributeMapper	WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)
			DELETE FROM ZnodeGlobalAttributeGroup	WHERE GlobalAttributeGroupId IN  (SELECT GlobalAttributeGroupId  FROM ZnodeGlobalAttributeGroup WHERE IsSystemDefined <> 1)   
			 
			   IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Global Attribute Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Global Attribute Not Deleted Properly -->' 
				END 	   
		   END  
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		   IF  @DeleteAllProductCategoryAttribute = 1  OR @DeleteAllData =1 
		   BEGIN 
			   	INSERT INTO @DeletedIds 
				SELECT PimAttributeId
				FROM ZnodePimAttribute ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptProductCategoryAttributeId WHERE id = ZP.PimAttributeId )
				AND ZP.IsSystemDefined <> 1 
				INSERT INTO @StatusOut (Id ,Status) 			
				EXEC Znode_DeletePimAttributeWithReference @PimAttributeIds = @DeletedIds  , @Status = 1  
			  
			    DELETE FROM ZnodePimAttributeGroupLocale 
					WHERE PimAttributeGroupId IN (SELECT PimAttributeGroupId FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimAttributeGroupMapper wHERE PimAttributeGroupId IN (SELECT PimAttributeGroupId FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimFamilyGroupMapper 
					WHERE PimAttributeGroupId IN (SELECT PimAttributeGroupId FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimAttributeGroup WHERE IsSystemDefined <> 1  

				
				DELETE FROM ZnodePimFamilyLocale WHERE  PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )
				UPDATE ZP SET PimAttributeFamilyId = dbo.Fn_GetDefaultPimProductFamilyId() FROM ZnodePimProduct  ZP  WHERE  PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )

				DELETE FROM ZnodeImportTemplateMapping WHERE ImportTemplateId IN (SELECT ImportTemplateId FROM ZnodeImportTemplate WHERE PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  ))
				DELETE FROM ZnodeImportTemplate WHERE PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )
				DELETE FROM ZnodePimFamilyGroupMapper 
					WHERE PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  )
				
				DELETE  FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1 
				UPDATE ZP SET PimAttributeFamilyId = dbo.Fn_GetDefaultPimProductFamilyId() FROM ZnodePimAttributeValue  ZP  WHERE  PimAttributeFamilyId IN (SELECT PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsSystemDefined <> 1  ) 
			   	IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- PIM Attribute Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- PIM Attribute Not Deleted Properly -->' 
				END 
		   END
		   DELETE FROM @DeletedIds 
		   DELETE FROM @StatusOut 
		   IF  @DeleteAllMedia = 1  OR @DeleteAllData =1 
		   BEGIN 
		  		INSERT INTO @DeletedIds 
		   		SELECT  MediaId   
				FROM ZnodeMedia ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptMediaId WHERE id = ZP.Mediaid )
				INSERT INTO @StatusOut (Id ,Message,Status)
				EXEC Znode_DeleteMedia @MediaIds = @DeletedIds  , @Status = 1  ,@IsCallInternal =1 
				DELETE FROM ZnodeMediaPathLocale WHERE MediaPathId IN (SELECT MediaPathId FROM ZnodeMediaPath WHERE PathCode<>'Root')
				DELETE FROM ZnodeMediaPath WHERE PathCode<>'Root'
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Media Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Media Not Deleted Properly -->' 
				END
				
		   END 
		   DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		
		   IF  @DeleteAllWarehouse = 1 OR @DeleteAllData =1 
		   BEGIN 
		   	
		   		SET @DeleteId =  SUBSTRING((
				SELECT  ',' + CONVERT(NVARCHAR(500), WarehouseId)  
				FROM ZnodeWarehouse ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptWarehouseId WHERE id = ZP.WarehouseId )
				FOR XML PATH ('')
				),2,4000) 
				INSERT INTO @StatusOut (Id ,Status)
			    EXEC Znode_DeleteWarehouse @WarehouseId = @DeleteId  , @Status = 1 
		
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Warehouse Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Warehouse Not Deleted Properly -->' 
				END
		    END 
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		
			IF  @DeleteAllPricelist = 1   OR @DeleteAllData =1 
		    BEGIN 
				SET @DeleteId =  SUBSTRING((
				SELECT ',' + CONVERT(NVARCHAR(500), PriceListId)  
				FROM ZnodePriceList ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptPricelistId WHERE id = ZP.PriceListId )
				FOR XML PATH ('')
				),2,4000) 
			  
				INSERT INTO @StatusOut (Id ,Status)  
				EXEC Znode_DeletePriceList @PriceListId = @DeleteId  , @Status = 1 
		      
			   IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Price List Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Price List Not Deleted Properly -->' 
				END
		    END
		
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			IF  @DeleteAllProfile = 1  OR @DeleteAllData =1 
			 BEGIN 
				SET @DeleteId =  SUBSTRING((
				SELECT ',' + CONVERT(NVARCHAR(500), ProfileId)  
				FROM ZnodeProfile ZP 
				WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptProfileId WHERE id = ZP.ProfileId )
				FOR XML PATH ('')
				),2,4000) 
		   	 	INSERT INTO @StatusOut (Id ,Status)
				EXEC  Znode_DeleteProfile  @ProfileId=@DeleteId, @Status = 0 ,	@IsForceFullyDelete =1 
				
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Profile Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Profile Not Deleted Properly -->' 
				END
		    END
			DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			IF  @DeleteAllSiteSearchData  = 1  OR @DeleteAllData =1 
			BEGIN 
			
					DELETE FROM ZnodeSearchIndexServerStatus
					DELETE FROM ZnodeSearchIndexMonitor
					DELETE FROM ZnodeCatalogIndex
					DELETE FROM ZnodePublishCatalogSearchProfile
					DELETE FROM ZnodeCatalogIndex
					DELETE FROM ZnodeCMSCustomerReview 
					DELETE FROM ZnodePublishPortalLog
					DELETE FROM ZnodeListViewFilter
					DELETE FROM ZnodeListView
			
					PRINT '<-- Site Search Data Deleted Sucessfully-->'
			 END
			 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			 IF  @DeleteAllCMSData = 1 	OR @DeleteAllData =1 
			 BEGIN 
				IF EXISTS (SELECT TOP 1 1  FROM SYS.Tables WHERE name = '_ZnodeCMSPortalTheme' )
				BEGIN
				 DROP TABLE _ZnodeCMSPortalTheme 
				END 
				SELECT * 
				INTO _ZnodeCMSPortalTheme
				FROM ZnodeCMSPortalTheme
				DELETE FROM ZnodeCMSContentPagesProfile 
				DELETE FROM ZnodeFormWidgetEmailConfiguration
				DELETE FROM ZnodeCMSWidgetTitleConfigurationLocale
				DELETE FROM ZnodeCMSWidgetTitleConfiguration
				DELETE FROM ZnodeCMSTextWidgetConfiguration
				DELETE FROM ZnodeCMSFormWidgetConfiguration
				DELETE FROM ZnodeCMSPortalProductPage
				DELETE FROM ZnodeCMSContentPageGroupMapping
				DELETE FROM ZnodeCMSContentPageGroupLocale
				DELETE FROM ZnodeCMSContentPageGroup
				DELETE FROM ZnodeCMSContentPagesLocale
				DELETE FROM ZnodeCMSContentPages
				DELETE FROM ZnodeCMSContentPagesProfile
				DELETE FROM ZnodeCMSPortalTheme  
			    DELETE FROM ZnodeCMSThemeCSS 
				DELETE FROM ZnodeCMSTheme  
				DELETE FROM ZnodeEmailTemplateMapper
				DELETE FROM ZnodeEmailTemplateLocale
				DELETE FROM ZnodeEmailTemplateAreas
				DELETE FROM ZnodeEmailTemplate
			    DELETE FROM ZnodeCMSWidgetSliderBanner
				DELETE FROM ZnodeCMSSliderBannerLocale
				DELETE FROM ZnodeCMSSliderBanner
				DELETE FROM ZnodeCMSSlider
				DELETE FROM ZnodeCmsPortalMessage
				DELETE FROM ZnodeCMSPortalMessageKeyTag
				DELETE FROM ZnodeCMSMessage 
				DELETE FROM ZnodeCMSMessageKey 
				DELETE FROM ZnodeCMSTemplate
				DELETE FROM ZnodeFormBuilderGlobalAttributeValueLocale 
				DELETE FROM ZnodeFormBuilderGlobalAttributeValue
				DELETE FROM ZnodeFormBuilderAttributeMapper 
				DELETE FROM ZnodeFormBuilderSubmit 
				DELETE FROM ZnodeFormBuilder

				IF NOT EXISTS (SELECT TOP 1 1  FROM ZnodeCMSTheme)
				BEGIN 
			   INSERT INTO ZnodeCMSTheme(Name
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate
			,IsParentTheme
			,ParentThemeId)
			SELECT 'Default',2,GETDATE(),2,GETDATE(),1,NULL
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSTheme WHERE Name = 'Default')

			SET @CMSThemeId = CASE WHEN @CMSThemeId	 IS NULL THEN (SELECT TOP 1 CMSThemeId FROM ZnodeCMSTheme WHERE Name = 'Default'   )  ELSE  @CMSThemeId END 
			INSERT INTO ZnodeCMSThemeCSS  (CMSThemeId
			,CSSName
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate)
			SELECT @CMSThemeId,'DefaultCSS',2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSThemeCSS WHERE CSSName = 'DefaultCSS')
	  	
			SET @CMSThemeCSSId = CASE WHEN @CMSThemeCSSId IS NULL THEN (SELECT TOP 1 CMSThemeCSSId FROM ZnodeCMSThemeCSS 
			WHERE CSSName = 'DefaultCSS'
			) ELSE 	@CMSThemeCSSId END 

			 INSERT INTO ZnodeCMSPortalTheme (PortalId
					,CMSThemeId
					,CMSThemeCSSId
					,MediaId
					,FavIconId
					,WebsiteTitle
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate)
			 SELECT DISTINCT PortalId
					,@CMSThemeId
					,@CMSThemeCSSId
					,MediaId
					,FavIconId
					,WebsiteTitle
					,2
					,GETDATE()
					,2
					,GETDATE() 
			 FROM _ZnodeCMSPortalTheme	TYU 
			 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodeCMSPortalTheme TY  WHERE TY.PortalId = TYU.PortalId AND TY.CMSThemeId = @CMSThemeId AND TY.CMSThemeCSSId = @CMSThemeCSSId)
			 
			 END 

			 PRINT '<-- CMS Data Deleted Sucessfully-->'	  			   
			 IF  NOT EXISTS (SELECT TOP 1 1  FROM ZnodeCMSContentPageGroup )
			 BEGIN 
			    DECLARE @GroupId INT =0 
				INSERT INTO ZnodeCMSContentPageGroup (ParentCMSContentPageGroupId ,Code,CreatedBy,CreatedDate,ModIFiedBy,ModIFiedDate)
				SELECT NULL,'Root',2,GETDATE(),2,GETDATE()
			    SET @GroupId = SCOPE_IDENTITY()
				INSERT INTO ZnodeCMSContentPageGroupLocale(CMSContentPageGroupId,Name,LocaleId,CreatedBy,CreatedDate,ModIFiedBy,ModIFiedDate)
			    SELECT @GroupId,'Root',1,2,GETDATE(),2,GETDATE()
			 END
			 END 
	 		 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			 IF  @DeleteAllCmsSeoDetails =1 OR @DeleteAllData =1 
			 BEGIN 
			 
			   DELETE FROM ZnodeCMSSEODetailLocale 
			   WHERE CMSSEODetailId IN (SELECT CMSSEODetailId FROM ZnodeCMSSEODetail a 
			   INNER JOIN ZnodeCMSSEOType b ON (b.CMSSEOTypeId = a.CMSSEOTypeId)
			   WHERE NOT EXISTS (SELECT TOP 1 1 FROM dbo.split(@ExceptSeoType,',') t WHERE t.Item = b.Name))
			  
			   DELETE FROM ZnodeCMSSEODetail 
			   WHERE CMSSEODetailId IN (SELECT CMSSEODetailId FROM ZnodeCMSSEODetail a 
			   INNER JOIN ZnodeCMSSEOType b ON (b.CMSSEOTypeId = a.CMSSEOTypeId)
			   WHERE NOT EXISTS (SELECT TOP 1 1 FROM dbo.split(@ExceptSeoType,',') t WHERE t.Item = b.Name))
			   PRINT '<-- SEO Data Deleted Sucessfully-->'
			END 
			
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF  @DeleteAllStore = 1   OR @DeleteAllData =1 
		   BEGIN 
		   DECLARE @TBL_PortalIds TABLE	 ( PortalId int	);
		   DECLARE @TBL_Promotion TABLE ( PromotionId int	);
		  	IF NOT EXISTS (SELECT TOP 1 1 FROM sys.tables WHERE Name = '_ZnodeDomain')
			BEGIN
				   CREATE TABLE  _ZnodeDomain (PortalId INT  ,DomainName NVARCHAR(max),IsActive BIT ,ApplicationType NVARCHAR(max),CreatedBy INT
		   ,CreatedDate DATETIME ,ModifiedBy INT ,ModIFiedDate DATETIME )
			END 


		   INSERT INTO _ZnodeDomain ( PortalId,DomainName ,IsActive  ,ApplicationType ,CreatedBy,CreatedDate ,ModIFiedBy ,ModIFiedDate) 
		   SELECT PortalId,DomainName ,IsActive  ,ApplicationType ,CreatedBy,CreatedDate ,ModIFiedBy ,ModIFiedDate
		   FROM ZnodeDomain 
		   DECLARE @TBL_DeletedUsers TABLE (AspNetUserId NVARCHAR(1000))

		       SET @DeleteId = Substring((select  ',' + convert(nvarchar(500), PromotionId)  
					FROM ZnodePromotion  SP
					WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptStoreId WHERE id = SP.PortalId )
					for XML Path ('')),2,4000) 
			   
			   

		-- inserting PortalIds which are not present in Order and Quote
		   INSERT INTO @TBL_PortalIds 
		   SELECT PortalId FROM ZnodePortal AS SP
		   WHERE NOT EXISTS (SELECT TOP 1 1  FROM @ExceptStoreId WHERE id = SP.PortalId );

		  	INSERT INTO @StatusOut (Id ,Status)
				EXEC Znode_DeletePromotion  @PromotionId = @DeleteId ,@Status = 1;

		
				IF  EXISTS (SELECT TOP 1 1  FROM @StatusOut WHERE Status = 1 )
				BEGIN 
		     	PRINT '<-- Store Promotion Data Deleted Sucessfully-->'
			    END
			    ELSE 
				BEGIN 
				PRINT '<-- Store Promotion Data Not Deleted Properly -->' 
				END	

-------------------------------------------------

			   DELETE FROM ZnodeGiftCardHistory	
                 WHERE EXISTS( SELECT *  FROM ZnodeGiftCard B	
                               WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS a	
                                                              WHERE a.PortalId = B.PortalId	) AND ZnodeGiftCardHistory.GiftCardId = B.GiftCardId );
	
	
                    DELETE FROM ZnodeRmaRequestItem	
                    WHERE EXISTS( SELECT *  FROM ZnodeGiftCard B WHERE EXISTS ( SELECT TOP 1 1	FROM @TBL_PortalIds AS a  WHERE a.PortalId = B.PortalId	
                              ) AND ZnodeRmaRequestItem.GiftCardId = B.GiftCardId );
	
	
                DELETE FROM ZnodeGiftCardLocale
                    WHERE EXISTS( SELECT *  FROM ZnodeGiftCard B	
                                            WHERE EXISTS ( SELECT TOP 1 1	FROM @TBL_PortalIds AS a	
                                             WHERE a.PortalId = B.PortalId	  ) AND ZnodeGiftCardLocale.GiftCardId = B.GiftCardId );
	
                    	
                    DELETE FROM ZnodeGiftCard	
                    WHERE EXISTS ( SELECT TOP 1 1	
                        FROM @TBL_PortalIds AS a	
                        WHERE a.PortalId = ZnodeGiftCard.PortalId	 );
		
                    DELETE FROM ZnodePortalLoginProvider	
                    WHERE EXISTS ( SELECT TOP 1 1	  FROM @TBL_PortalIds AS a	 WHERE a.PortalId = ZnodePortalLoginProvider.PortalId  );

--------------------------------------------------------------------------------------------------------

		 DELETE FROM  ZnodeBrandPortal  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeBrandPortal.PortalId);
	    DELETE FROM  ZnodeCustomPortalDetail  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCustomPortalDetail.PortalId);
		
		 DELETE FROM  ZnodeSupplier WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSupplier.PortalId)

	     DELETE FROM  ZnodeOmsTemplateLineItem  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeOmsTemplate ZOT ON 
	     TBP.PortalId = ZOT.PortalId AND ZOT.OmsTemplateId = ZnodeOmsTemplateLineItem.OmsTemplateId);

	     DELETE FROM ZnodeOmsTemplate WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsTemplate.PortalId);
	     DELETE FROM  ZnodeOmsUsersReferralUrl WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsUsersReferralUrl.PortalId)

		DELETE FROM ZnodePortalShipping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShipping.PortalId);
		DELETE FROM ZnodePortalTaxClass WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalTaxClass.PortalId);
		DELETE FROM ZnodePortalPaymentSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPaymentSetting.PortalId);
		DELETE FROM ZnodeCMSPortalMessageKeyTag WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessageKeyTag.PortalId);
		DELETE FROM ZnodePriceListProfile WHERE PortalProfileID IN (SELECT PortalProfileID FROM ZnodePortalProfile WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalProfile.PortalId))
		DELETE FROM ZnodePortalProfile WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalProfile.PortalId);
		DELETE FROM ZnodePortalFeatureMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalFeatureMapper.PortalId);
		DELETE FROM ZnodePortalShippingDetails WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalShippingDetails.PortalId);
		DELETE FROM ZnodePortalUnit WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalUnit.PortalId);
		DELETE FROM ZnodeDomain WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeDomain.PortalId);
		
		DELETE FROM ZnodePortalSearchProfile   WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSearchProfile.PortalId);
		DELETE FROM dbo.ZnodePortalPixelTracking WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalPixelTracking.PortalId); 
		DELETE FROM ZnodeRobotsTxt WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeRobotsTxt.PortalId);
		DELETE FROM ZnodePortalSmtpSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalSmtpSetting.PortalId);
		DELETE FROM ZnodeActivityLog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeActivityLog.PortalId);
		DELETE FROM ZnodePortalCatalog WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCatalog.PortalId );
		DELETE FROM ZnodeCMSPortalMessage  WHERE EXISTS  ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalMessage.PortalId );
		DELETE FROM ZnodeGoogleTagManager WHERE  EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGoogleTagManager.PortalId);
		DELETE FROM ZnodeTaxRuleTypes WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRuleTypes.PortalId);
		DELETE FROM ZnodeCMSContentPagesProfile WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
											WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesProfile.CMSContentPagesId )
		DELETE FROM ZnodeCMSContentPageGroupMapping WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPageGroupMapping.CMSContentPagesId )
	     DELETE FROM ZnodeCMSContentPagesLocale WHERE EXISTS (SELECT TOP 1 1 FROM  ZnodeCMSContentPages ZCCP  
																	WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZCCP.PortalId) AND ZCCP.CMSContentPagesId = ZnodeCMSContentPagesLocale.CMSContentPagesId )
		
		DELETE FROM ZnodeBlogNewsCommentLocale WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNewsComment ZBC
													WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
														WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZBC.BlogNewsId ) and ZBC.BlogNewsCommentId = ZnodeBlogNewsCommentLocale.BlogNewsCommentId)
		DELETE FROM ZnodeBlogNewsComment WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
													WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsComment.BlogNewsId )
		 
		DELETE FROM ZnodeBlogNewsContent WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
													WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsContent.BlogNewsId )
		DELETE FROM ZnodeBlogNewsLocale WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeBlogNews ZBN
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsLocale.BlogNewsId )
													
		DELETE FROM ZnodeBlogNews WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeBlogNews.PortalId)
		DELETE FROM  ZnodeFormWidgetEmailConfiguration 	WHERE CMSContentPagesId IN (SELECT CMSContentPagesId FROM ZnodeCMSContentPages WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSContentPages.PortalId))
		DELETE FROM ZnodeCMSContentPages WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSContentPages.PortalId);
		DELETE FROM ZnodeCaseRequestHistory WHERE CaseRequestId IN (SELECT CaseRequestId   FROM ZnodeCaseRequest WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCaseRequest.PortalId))
		DELETE FROM ZnodeCaseRequest WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCaseRequest.PortalId);
		DELETE FROM ZnodePortalLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalLocale.PortalId);
		DELETE FROM ZnodeShippingPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeShippingPortal.PortalId);
		
		DELETE FROM   @DeletedIds
		INSERT INTO @DeletedIds 
		SELECT DISTINCT UserId 
		FROM ZnodeUserPortal 
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId);

		--INSERT INTO @StatusOut (Id ,Status) 
		EXEC [dbo].Znode_DeleteUserDetails @UserIds = @DeletedIds , @status = 0,@IsForceFullyDelete =1 ,@IsCallInternal=1 
		
		DELETE FROM AspNetZnodeUser OUTPUT DELETED.AspNetZnodeUserId   INTO @TBL_DeletedUsers WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = AspNetZnodeUser.PortalId )
		
		DELETE FROM ZnodePortalAlternateWarehouse WHERE EXISTS ( SELECT TOP 1 1 FROM ZnodePortalWareHouse AS ZPWH WHERE EXISTS (
				SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZPWH.PortalId ) AND  ZPWH.PortalWarehouseId = ZnodePortalAlternateWarehouse.PortalWarehouseId);
		DELETE FROM ZnodePortalWareHouse WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalWareHouse.PortalId);
		DELETE ZnodePriceListPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePriceListPortal.PortalId );
		
		DELETE FROM ZnodeEmailTemplateMapper WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeEmailTemplateMapper.PortalId);
		DELETE FROM ZnodeGIFtCard WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeGIFtCard.PortalId );
		DELETE FROM ZnodeCMSPortalProductPage WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalProductPage.PortalId);

		DELETE FROM ZnodeCMSPortalSEOSetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalSEOSetting.PortalId);

		DELETE FROM ZnodeCMSPortalTheme WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSPortalTheme.PortalId);

		DELETE FROM ZnodeCMSSEODetailLocale WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP INNER JOIN ZnodeCMSSEODetail AS zcsd ON TBP.PortalId = zcsd.PortalId WHERE zcsd.CMSSEODetailId = ZnodeCMSSEODetailLocale.CMSSEODetailId);
		 
		DELETE FROM ZnodeCMSSEODetail WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSSEODetail.PortalId);
		DELETE FROM ZnodePortalAccount WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAccount.PortalId);
		DELETE FROM ZnodePortalAddress WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalAddress.PortalId);
		DELETE FROM ZnodePortalCountry WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalCountry.PortalId);
		DELETE FROM ZnodeCMSUrlRedirect WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeCMSUrlRedirect.PortalId);
		DELETE FROM ZnodeTaxPortaL  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxPortaL.PortalId);
	   	INSERT INTO @TBL_Promotion( PromotionId ) SELECT PromotionId FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePromotion.PortalId);
		DELETE FROM ZnodePromotionProduct WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionProduct.PromotionId);
		DELETE FROM dbo.ZnodePromotionCoupon  WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCoupon.PromotionId);
		DELETE FROM ZnodePromotionCategory WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCategory.PromotionId);
		DELETE FROM ZnodePromotionCatalogs WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotionCatalogs.PromotionId);
		DELETE FROM ZnodePromotion WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_Promotion AS TBP WHERE TBP.PromotionId = ZnodePromotion.PromotionId);
		DELETE FROM ZnodeBlogNewsLocale WHERE exists (select top 1 1 from ZnodeBlogNews ZBN
													WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZBN.PortalId) AND ZBN.BlogNewsId = ZnodeBlogNewsLocale.BlogNewsId )
		
        DELETE a FROM ZnodeFormBuilderGlobalAttributeValueLocale	a 
			INNER JOIN ZnodeFormBuilderGlobalAttributeValue aa ON (a.FormBuilderGlobalAttributeValueId = aa.FormBuilderGlobalAttributeValueId)INNER JOIN ZnodeFormBuilderSubmit b ON (b.FormBuilderSubmitId =aa.FormBuilderSubmitId)
			 WHERE EXISTS ( SELECT TOP 1 1
									   FROM @TBL_PortalIds AS TBDL
									   WHERE TBDL.PortalId = b.PortalId      
									 ); 
		DELETE a FROM ZnodeFormBuilderGlobalAttributeValue a INNER JOIN ZnodeFormBuilderSubmit b ON (b.FormBuilderSubmitId =a.FormBuilderSubmitId)
		 WHERE EXISTS ( SELECT TOP 1 1
								   FROM @TBL_PortalIds AS TBDL
								   WHERE TBDL.PortalId = b.PortalId      
								 ); 
		DELETE FROM ZnodeFormBuilderSubmit 
		WHERE EXISTS ( SELECT TOP 1 1
								   FROM @TBL_PortalIds AS TBDL
								   WHERE TBDL.PortalId = ZnodeFormBuilderSubmit.PortalId      
								 );   
		DELETE FROM   @DeletedIds
		INSERT INTO @DeletedIds 
		SELECT DISTINCT a.OmsOrderId 
		FROM ZnodeOmsOrder A 
		INNER JOIN ZnodeOMsOrderDetails b  ON (b.OmsOrderId = a.OmsOrderId )
		WHERE   EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = b.PortalId)

		INSERT INTO @StatusOut (Id ,Status) 
		EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIds , @status = 0 

		DELETE FROM @DeletedIds DELETE FROM @StatusOut 									  
		
		DELETE FROM dbo.ZnodeSearchSynonyms	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeSearchSynonyms.PublishCatalogId )
		DELETE FROM ZnodePublishedXml 
		DELETE FROM ZnodePublishCatalogLog	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalogLog.PublishCatalogId )
		DELETE FROM ZnodePublishCatalogSearchProfile WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalogSearchProfile.PublishCatalogId )
		DELETE FROM ZnodePublishCategoryProduct   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCategoryProduct.PublishCatalogId )
		DELETE FROM ZnodePublishCategoryDetail 	WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePublishCategoryProduct Tt WHERE Tt.PublishCategoryId = ZnodePublishCategoryDetail.PublishCategoryId )
		DELETE FROM ZnodePublishProductDetail WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePublishCategoryProduct Tt WHERE Tt.PublishCategoryId = ZnodePublishProductDetail.PublishProductId )
		
		DELETE FROM ZnodeCMSWidgetCategory WHERE PublishCategoryId IN (SELECT PublishCategoryId FROM ZnodePublishCategory   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCategory.PublishCatalogId ))

		DELETE FROM ZnodePublishCategory   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCategory.PublishCatalogId )
		DELETE FROM dbo.ZnodeCMSWidgetProduct	WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePublishCategoryProduct Tt WHERE Tt.PublishProductId = ZnodeCMSWidgetProduct.PublishProductId )
		DELETE FROM dbo.ZnodeSearchGlobalProductBoost	WHERE PublishProductId IN (SELECT PublishProductId FROM ZnodePublishProduct	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishProduct.PublishCatalogId ))
		DELETE FROM ZnodeCMSCustomerReview 
			WHERE PublishProductId IN (SELECT PublishProductId FROM ZnodePublishProduct	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishProduct.PublishCatalogId ))
		DELETE FROM ZnodePublishProduct	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishProduct.PublishCatalogId )
		DELETE FROM dbo.ZnodeSearchIndexServerStatus WHERE SearchIndexMonitorId IN (SELECT SearchIndexMonitorId FROM dbo.ZnodeSearchIndexMonitor WHERE CatalogIndexId IN (SELECT CatalogIndexId FROM ZnodeCatalogIndex	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeCatalogIndex.PublishCatalogId )))
		DELETE FROM dbo.ZnodeSearchIndexMonitor WHERE CatalogIndexId IN (SELECT CatalogIndexId FROM ZnodeCatalogIndex	 WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeCatalogIndex.PublishCatalogId ))
		DELETE FROM  ZnodeCatalogIndex   WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodeCatalogIndex.PublishCatalogId )
		DELETE FROM ZnodeSearchDocumentMapping WHERE PublishCatalogId IN (SELECT PublishCatalogId FROM ZnodePublishCatalog	  WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalog.PublishCatalogId ))
		
		DELETE FROM ZnodePublishCatalog	  WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalCatalog Tt WHERE Tt.PublishCatalogId = ZnodePublishCatalog.PublishCatalogId )
		DELETE FROM ZnodeOmsPersonalizeCartItem WHERE OmsSavedCartLineItemId IN (SELECT OmsSavedCartLineItemId FROM ZnodeOmsSavedCartLineItem WHERE OmsSavedCartId IN (SELECT OmsSavedCartId FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId IN (SELECT OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId) ) 	 )) 
		DELETE FROM ZnodeOmsSavedCartLineItem WHERE OmsSavedCartId IN (SELECT OmsSavedCartId FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId IN (SELECT OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId) ) 	 )
		DELETE FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId IN (SELECT OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId) ) 
		DELETE FROM ZnodeOmsCookieMapping WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeOmsCookieMapping.PortalId); 
		DELETE FROM ZnodeDomain WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeDomain.PortalId);
		
		DELETE FROM ZnodeSalesRepCustomerUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeSalesRepCustomerUserPortal.CustomerPortalId);

		delete from ZnodeSalesRepCustomerUserPortal 
		where exists(select * FROM ZnodeUserPortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeUserPortal.PortalId) and ZnodeSalesRepCustomerUserPortal.UserPortalId = ZnodeUserPortal.UserPortalId);
		

		DELETE FROM ZnodePortalRecommendationSetting  
		WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalRecommendationSetting.PortalId);
		DELETE FROM ZnodePortal WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortal.PortalId);
		
		PRINT '<-- Store Data Deleted Sucessfully-->'
	   
	   IF  NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortal) 
	   BEGIN 
	        SET @CMSThemeId = NULL 
			SET @CMSThemeCSSId = NULL  
			
	        SET IDENTITY_INSERT [dbo].[ZnodePortal] ON 
			INSERT [dbo].[ZnodePortal] ([PortalId], [CompanyName], [StoreName], [LogoPath], [UseSSL], [AdminEmail], [SalesEmail], [CustomerServiceEmail], [SalesPhoneNumber], [CustomerServicePhoneNumber], [ImageNotAvailablePath], [ShowSwatchInCategory], [ShowAlternateImageInCategory], [ExternalID], [MobileLogoPath], [DefaultOrderStateID], [DefaultReviewStatus], [SplashCategoryID], [SplashImageFile], [MobileTheme], [CopyContentBasedOnPortalId], [CreatedBy], [CreatedDate], [ModIFiedBy], [ModIFiedDate], [InStockMsg], [OutOfStockMsg], [BackOrderMsg], [OrderAmount], [Email], [StoreCode]) 
			VALUES (1, N'DemoStore', N'DemoStore', NULL, 0, N'test@znode.com', N'test@znode.com', N'test@znode.com', N'123456789', N'123456789', N'', 0, 0, NULL, NULL, 50, N'N', NULL, NULL, NULL, NULL, 2, CAST(N'2018-04-23T01:05:48.620' AS DateTime), 2, CAST(N'2018-04-23T01:05:48.620' AS DateTime), N'Demo', N'Demo', N'Demo', NULL, NULL, 'DemoStore')
			SET IDENTITY_INSERT [dbo].[ZnodePortal] OFF
			SET @PortalId  = 1
			INSERT INTO ZnodePimCatalog (CatalogName,IsActive,ExternalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			SELECT 'DefaultCatalog' , 1 ,NULL,2 ,GETDATE(),2,GETDATE() 
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimCatalog r WHERE r.CatalogName = 'DefaultCatalog' )
			SET @PimCatalogId = CASE WHEN @PimCatalogId IS nULL THEN (SELECT TOP 1 PimCatalogId FROM ZnodePimCatalog WHERE	CatalogName = 'DefaultCatalog'  ) ELSE  @PimCatalogId END 	
			INSERT INTO ZnodePublishCatalog (PimCatalogId
			,CatalogName
			,ExternalId
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate
			,Tokem)
			SELECT @PimCatalogId,'DefaultCatalog' , '',2,GETDATE(),2,GETDAte(),''
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishCatalog WHERE CatalogName = 'DefaultCatalog')
			SET  @PublishCatalogId = CASE WHEN  @PublishCatalogId IS nULL THEN (SELECT TOP 1 PublishCatalogId  FROM ZnodePublishCatalog WHERE CatalogName = 'DefaultCatalog'   )  ELSE @PublishCatalogId END 
			INSERT INTO ZnodeCMSTheme(Name
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate
			,IsParentTheme
			,ParentThemeId)
			SELECT 'Default',2,GETDATE(),2,GETDATE(),1,NULL
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSTheme WHERE Name = 'Default')
			SET  @CMSThemeId = CASE WHEN @CMSThemeId IS nULL THEN (SELECT TOP 1 CMSThemeId FROM ZnodeCMSTheme WHERE Name = 'Default'   )  ELSE @CMSThemeId END  
		
			INSERT INTO ZnodeCMSThemeCSS  (CMSThemeId
			,CSSName
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate)
			SELECT @CMSThemeId,'DefaultCSS',2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSThemeCSS WHERE CSSName = 'DefaultCSS')
			SET  @CMSThemeCSSId = CASE WHEN @CMSThemeCSSId IS nULL THEN (SELECT TOP 1 CMSThemeCSSId FROM ZnodeCMSThemeCSS WHERE CSSName = 'DefaultCSS'  )  ELSE @CMSThemeCSSId END  
		
			INSERT INTO ZnodeCMSPortalTheme (PortalId
			,CMSThemeId
			,CMSThemeCSSId
			,MediaId
			,FavIconId
			,WebsiteTitle
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate	)    
			SELECT  @PortalId,@CMSThemeId,@CMSThemeCSSId,NULL,NULL,NULL,2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSPortalTheme WHERE PortalId  = @PortalId  )
			INSERT INTO ZnodePortalCatalog (PortalId
			,PublishCatalogId
			,CreatedBy
			,CreatedDate
			,ModIFiedBy
			,ModIFiedDate)
			SELECT @PortalId,@PublishCatalogId,2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePortalCatalog WHERE PortalId  = @PortalId )
			
			INSERT INTO ZnodeDomain (PortalId,DomainName ,IsActive,ApplicationType,CreatedBy ,CreatedDate ,ModIFiedBy ,ModIFiedDate)
			SELECT DISTINCT 1,DomainName ,IsActive,ApplicationType,CreatedBy ,GETDATE()CreatedDate ,ModIFiedBy ,GETDATE()ModIFiedDate 
			FROM _ZnodeDomain  TR
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeDomain TY WHERE TR.PortalId = TY.PortalId AND TR.DomainName = TY.DomainName) 
			GROUP BY DomainName ,IsActive,ApplicationType,CreatedBy,ModifiedBy

			INSERT INTO ZnodePortalUnit (PortalId,CurrencyId,WeightUnit,DimensionUnit,CurrencySuffix,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			SELECT @PortalId,(SELECT TOP 1 CurrencyId FROM ZnodeCulture WHERE CultureCode = 'en-US' ) 
			,'Lbs','IN','USD',2,GETDATE(),2,GETDATE()
			WHERE NOT EXISTS (SELECT TOP 1 1  FROM ZnodePortalUnit  WHERE PortalId = @PortalId AND CurrencyId = (SELECT TOP 1 CurrencyId FROM ZnodeCulture WHERE CultureCode = 'en-US')  )

	   END 
	   
		
		   END  
			 DELETE FROM @DeletedIds DELETE FROM @StatusOut 
			 IF  @ResetDomainData = 1  OR @DeleteAllData =1     
			 BEGIN 
			  DECLARE @OneportalId INT = (SELECT TOP 1 PortalId  FROM ZnodePortal)
			  DELETE FROM ZnodeDomain 
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT @OneportalId, 'localhost:6766',1, '115915F1-7E6B-4386-A623-9779F27D9A5E','Admin',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost:6766'  and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ))
			  
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT @OneportalId, 'localhost:3288',1, 'c58cc0c0-1349-4001-8416-cf1cea7960e8','WebStore',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost:3288'  and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ))
			  
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT @OneportalId, 'localhost:44762',1, '8a8b4931-7d57-42e8-a005-b1c0cce49f1d','Api',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost:44762' and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ) )
			  
			  INSERT INTO znodedomain(PortalId,DomainName,	IsActive,	ApiKey,	ApplicationType,	CreatedBy,	CreatedDate	,ModIFiedBy	,ModIFiedDate)
			  SELECT  @OneportalId  , 'localhost',1, '115915F1-7E6B-4386-A623-9779F27D9A5E','Admin',2,GETDATE(),2,GETDATE()
			  WHERE NOT EXISTS(SELECT * FROM znodedomain WHERE DomainName = 'localhost'  and PortalId = (SELECT TOP 1 PortalId FROM ZnodePortal ))
			 PRINT '<-- Domain reset Sucessfully-->'
			 END 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF @DeleteAllShippingMethods = 1 OR @DeleteAllData =1 
		BEGIN 
		
		   	SET @DeleteId = Substring((select  ',' + convert(nvarchar(500), ShippingId)  
					FROM ZnodeShipping for XML Path ('')),2,4000) 
		  -- INSERT INTO @StatusOut (Id ,Status)

		   EXEC Znode_DeleteShipping  @ShippingId = @DeleteId , @Status =0 ,@IsForceFullyDelete =1 
		   
		 PRINT '<-- Shipping Methods are Deleted Sucessfully-->'
			   
		END
		DELETE FROM @DeletedIds DELETE FROM @StatusOut  
		IF @DeleteAllPaymentMethods	 = 1  OR @DeleteAllData =1 
		BEGIN 
			 	 
		INSERT INTO @DeletedIds 
		SELECT DISTINCT a.OmsOrderId 
		FROM ZnodeOmsOrder A 
		INNER JOIN ZnodeOMsOrderDetails b  ON (b.OmsOrderId = a.OmsOrderId )
		WHERE   EXISTS ( SELECT TOP 1 1 FROM ZnodePaymentSetting AS TBP WHERE TBP.PaymentSettingId = b.PaymentSettingId)

		INSERT INTO @StatusOut (Id ,Status) 
		EXEC [dbo].[Znode_DeleteOrderById] @OmsOrderIds = @DeletedIds , @status = 0 
		 
		 DELETE FROM ZnodePortalPaymentSetting 
		 DELETE FROM ZnodeProfilePaymentSetting
		 DELETE FROM ZnodePaymentSetting
		
			  
		 PRINT '<-- Payment Methods are Deleted Sucessfully-->'
			   
		END 
		DELETE FROM @DeletedIds DELETE FROM @StatusOut 
		IF @DeleteAllTaxes	= 1 OR @DeleteAllData =1 		
		BEGIN 
		 
		  	SET @DeleteId = Substring((select  ',' + convert(nvarchar(500), TaxClassId)  
					FROM ZnodeTaxClass for XML Path ('')),2,4000) 
		-- INSERT INTO @StatusOut (Id ,Status) 
		 EXEC [dbo].[Znode_DeleteTaxClass] @TaxClassId =  @DeleteId, @status = 0 , @IsForceFullyDelete =1 
		 DELETE FROM ZnodeTaxRuleTypes   
     	 PRINT '<-- Taxes Data Deleted Sucessfully-->'
		 		 
		END 
		IF  @ResetIdentity =1  OR @DeleteAllData =1 
		 BEGIN
		 DECLARE @table_name varchar(100)= NULL, @showReport bit= 0, @debug bit= 0
	
		IF  OBJECT_ID('tempdb..#reseed_temp1') < 0 
			Drop TABLE #reseed_temp1 
		CREATE TABLE   #reseed_temp1 
		( 
					 tbame varchar(100), mvalue varchar(20) DEFAULT 0
		)

			DECLARE @Tablename varchar(256), @columnname varchar(256), @IndentValue numeric, @query varchar(4000), @query1 nvarchar(4000), @id int;

			DECLARE Cur_Reseed CURSOR LOCAL FAST_FORWARD
			FOR SELECT b.name, c.name
				FROM sys.objects AS a, sys.objects AS b, sys.columns AS c
				WHERE a.type = 'PK' AND 
					  a.parent_object_id = b.object_id AND 
					  b.object_id = c.object_id AND 
					  c.column_id = 1 AND 
					  is_identity <> 0 AND 
					  b.name NOT LIKE '%-%' AND 
					  b.name NOT LIKE '%(%' AND 
					  RTRIM(LTRIM(b.name)) = RTRIM(LTRIM(COALESCE(@table_name, b.name)));

			OPEN Cur_Reseed;

			FETCH NEXT FROM Cur_Reseed INTO @Tablename, @columnname;

			WHILE(@@FETCH_STATUS = 0)

			BEGIN

				 IF  @columnname <> ''

				BEGIN

					SET @query = 'insert into #reseed_temp1  (tbame, mvalue) ( select  '''+@Tablename+''', max( '+@columnname+') from '+@Tablename+')';

					EXECUTE (@query);

					SELECT @Tablename = tbame, @IndentValue = isnull(mvalue,1)
					FROM #reseed_temp1 ;



					DBCC CHECKIDENT(@Tablename, RESEED, @IndentValue);



				END;

				FETCH NEXT FROM Cur_Reseed INTO @Tablename, @columnname;

			END;
			CLOSE Cur_Reseed;
			DEALLOCATE Cur_Reseed;
			DROP TABLE #reseed_temp1
		PRINT '<---Reset Identity Sucessfully-->'
		END   
		--COMMIT TRAN  CleanUpProcess
	 END TRY 
	 BEGIN CATCH 
	 SELECT ERROR_MESSAGE()
	--ROLLBACK TRAN CleanUpProcess
	 END CATCH  
END
go
if not exists(select * from sys.tables where name = 'ZnodeCMSContentWidget')
begin
CREATE TABLE ZnodeCMSContentWidget (
    CMSContentWidgetId int NOT NULL  IDENTITY(1,1),
	Name nvarchar(100) NOT NULL,
	WidgetKey nvarchar(50) NOT NULL ,
	PortalId int ,
	FamilyId int NOT NULL,
    Tags nvarchar(1000),
    CreatedBy int NOT NULL,
    CreatedDate datetime NOT NULL, 
    ModifiedBy int NOT NULL,
	ModifiedDate datetime  NOT NULL ,
	CONSTRAINT [PK_ZnodeCMSContentWidget] PRIMARY KEY CLUSTERED ([CMSContentWidgetId] ASC) WITH (FILLFACTOR = 90),

);
end
go
if not exists(select * from sys.tables where name = 'ZnodeCMSWidgetTemplate')
begin
CREATE TABLE ZnodeCMSWidgetTemplate (
    CMSWidgetTemplateId int NOT NULL  IDENTITY(1,1),
	Code varchar(200) not null,
    Name nvarchar(100) NOT NULL,
	FileName nvarchar(2000) NOT NULL,
	MediaId int,
    CreatedBy int NOT NULL,
    CreatedDate datetime NOT NULL, 
    ModifiedBy int NOT NULL,
	ModifiedDate datetime  NOT NULL ,
	CONSTRAINT [PK_ZnodeCMSWidgetTemplate] PRIMARY KEY CLUSTERED ([CMSWidgetTemplateId] ASC) WITH (FILLFACTOR = 90)
);
end
go
if not exists(select * from sys.tables where name = 'ZnodeCMSWidgetProfileVariant')
begin
CREATE TABLE ZnodeCMSWidgetProfileVariant (
    CMSWidgetProfileVariantId int NOT NULL  IDENTITY(1,1),
    CMSContentWidgetId int  NOT NULL,
	ProfileId int,
	LocaleId int  NOT NULL,
	CMSWidgetTemplateId int,
	CONSTRAINT [PK_ZnodeCMSWidgetProfileLocale] PRIMARY KEY CLUSTERED ([CMSWidgetProfileVariantId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ZnodeCMSWidgetProfileLocale_ZnodeCMSContentWidget] FOREIGN KEY ([CMSContentWidgetId]) REFERENCES [dbo].[ZnodeCMSContentWidget] ([CMSContentWidgetId]),
    CONSTRAINT [FK_ZnodeCMSWidgetProfileLocale_ZnodeProfile] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[ZnodeProfile] ([ProfileId]),
    CONSTRAINT [FK_ZnodeCMSWidgetProfileLocale_ZnodeLocale] FOREIGN KEY ([LocaleId]) REFERENCES [dbo].[ZnodeLocale] ([LocaleId]),
    CONSTRAINT [FK_ZnodeCMSWidgetProfileLocale_ZnodeCMSWidgetTemplate] FOREIGN KEY ([CMSWidgetTemplateId]) REFERENCES [dbo].[ZnodeCMSWidgetTemplate] ([CMSWidgetTemplateId]),

);
end
go

if not exists(select * from sys.tables where name = 'ZnodeWidgetGlobalAttributeValue')
begin
CREATE TABLE [dbo].[ZnodeWidgetGlobalAttributeValue] (
    [WidgetGlobalAttributeValueId]  INT            IDENTITY (1, 1) NOT NULL,
    [CMSContentWidgetId]				INT			   Not NULL,
	[CMSWidgetProfileVariantId]        INT			   Not NULL,
    [GlobalAttributeId]             INT            NULL,
    [GlobalAttributeDefaultValueId] INT            NULL,
    [AttributeValue]                NVARCHAR (300) NULL,
    [CreatedBy]                     INT            NOT NULL,
    [CreatedDate]                   DATETIME       NOT NULL,
    [ModifiedBy]                    INT            NOT NULL,
    [ModifiedDate]                  DATETIME       NOT NULL,
    CONSTRAINT [PK_ZnodeWidgetGlobalAttributeValue] PRIMARY KEY CLUSTERED ([WidgetGlobalAttributeValueId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ZnodeWidgetGlobalAttributeValue_ZnodeGlobalAttribute] FOREIGN KEY ([GlobalAttributeId]) REFERENCES [dbo].[ZnodeGlobalAttribute] ([GlobalAttributeId]),
    CONSTRAINT [FK_ZnodeWidgetGlobalAttributeValue_ZnodeGlobalAttributeDefaultValue] FOREIGN KEY ([GlobalAttributeDefaultValueId]) REFERENCES [dbo].[ZnodeGlobalAttributeDefaultValue] ([GlobalAttributeDefaultValueId])
);
end
go
if not exists(select * from sys.tables where name = 'ZnodeWidgetGlobalAttributeValueLocale')
begin
CREATE TABLE [dbo].[ZnodeWidgetGlobalAttributeValueLocale] (
    [WidgetGlobalAttributeValueLocaleId] INT            IDENTITY (1, 1) NOT NULL,
    [WidgetGlobalAttributeValueId]       INT          NOT NULL,
    [LocaleId]                         INT            NOT NULL,
    [AttributeValue]                   NVARCHAR (MAX) NULL,
    [CreatedBy]                        INT            NOT NULL,
    [CreatedDate]                      DATETIME       NOT NULL,
    [ModifiedBy]                       INT            NOT NULL,
    [ModifiedDate]                     DATETIME       NOT NULL,
    [GlobalAttributeDefaultValueId]    INT            NULL,
    [MediaId]                          INT            NULL,
    [MediaPath]                        NVARCHAR (300) NULL,
    CONSTRAINT [PK_ZnodeWidgetGlobalAttributeValueLocale] PRIMARY KEY CLUSTERED ([WidgetGlobalAttributeValueLocaleId] ASC),
    CONSTRAINT [FK_ZnodeWidgetGlobalAttributeValueLocale_ZnodeMedia] FOREIGN KEY ([MediaId]) REFERENCES [dbo].[ZnodeMedia] ([MediaId]),
    CONSTRAINT [FK_ZnodeWidgetGlobalAttributeValueLocale_ZnodeWidgetGlobalAttributeValue] FOREIGN KEY ([WidgetGlobalAttributeValueId]) REFERENCES [dbo].[ZnodeWidgetGlobalAttributeValue] ([WidgetGlobalAttributeValueId])
);
end
go
insert into ZnodeApplicationSetting (GroupName,	ItemName,	Setting,	ViewOptions,	FrontPageName,	FrontObjectName,	IsCompressed,	OrderByFields,	ItemNameWithoutCurrency,	CreatedByName,	ModifiedByName,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
select 'Table','ZnodeCMSWidgetTemplate',
'<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>WidgetTemplateId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Image</headertext>      <width>20</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,Name</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Code</name>      <headertext>Template Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Name</name>      <headertext>Template Name</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/WidgetTemplate/Edit</islinkactionurl>      <islinkparamfield>Code</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>FileName</name>      <headertext>File Name</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Download|Copy|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Download|Copy|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WidgetTemplate/Edit|/WidgetTemplate/DownloadWidgetTemplate|/WidgetTemplate/Copy|/WidgetTemplate/Delete</manageactionurl>      <manageparamfield>Code|widgetTemplateId,FileName|Code|widgetTemplateId,FileName</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>',
'ZnodeCMSWidgetTemplate','ZnodeCMSWidgetTemplate','ZnodeCMSWidgetTemplate',0,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where GroupName = 'Table' and ItemName = 'ZnodeCMSWidgetTemplate')


insert into ZnodeApplicationSetting (GroupName,	ItemName,	Setting,	ViewOptions,	FrontPageName,	FrontObjectName,	IsCompressed,	OrderByFields,	ItemNameWithoutCurrency,	CreatedByName,	ModifiedByName,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
select 'Table','ZnodeCMSContentWidget',
'<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>ContentWidgetId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>WidgetKey</name>      <headertext>Widget Key</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>60</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Tags</name>      <headertext>Widget Tag</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>IsGlobalContentWidget</name>      <headertext>Is Global Content Widget</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/ContentWidget/Edit|/ContentWidget/Delete</manageactionurl>      <manageparamfield>widgetKey|ContentWidgetId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>',
'ZnodeCMSContentWidget','ZnodeCMSContentWidget','ZnodeCMSContentWidget',0,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where GroupName = 'Table' and ItemName = 'ZnodeCMSContentWidget')

go

insert into ZnodeMenu(ParentMenuId,MenuName,MenuSequence,AreaName,ControllerName,ActionName,CSSClassName,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'),'Widgets',3,null,'ContentWidget','List','z-content-widgets',1,
2,getdate(),2,getdate()
where not exists(select * from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))

insert into ZnodeMenu(ParentMenuId,MenuName,MenuSequence,AreaName,ControllerName,ActionName,CSSClassName,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')),
'Widgets',3,null,'ContentWidget','List','z-content-widgets',1,
2,getdate(),2,getdate()
where not exists(select * from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))

insert into ZnodeMenu(ParentMenuId,MenuName,MenuSequence,AreaName,ControllerName,ActionName,CSSClassName,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')),
'Widget Templates',2,null,'WidgetTemplate','List','z-widget-templates',1,
2,getdate(),2,getdate()
where not exists(select * from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))

go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','List',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'List')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'List') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'List'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'List')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'List'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','Create',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Create')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Create') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Create'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Create')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Create'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','Edit',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Edit')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Edit') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Edit'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Edit')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Edit'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','GetVariants',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetVariants')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetVariants') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetVariants'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetVariants')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId =(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetVariants'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','GetUnassociatedProfiles',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetUnassociatedProfiles')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetUnassociatedProfiles') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetUnassociatedProfiles'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetUnassociatedProfiles')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetUnassociatedProfiles'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','AssociateVariants',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateVariants')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateVariants') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateVariants'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateVariants')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateVariants'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','AssociateWidgetTemplate',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateWidgetTemplate')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateWidgetTemplate') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateWidgetTemplate'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateWidgetTemplate')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'AssociateWidgetTemplate'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','GetEntityAttributeDetails',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetEntityAttributeDetails')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetEntityAttributeDetails') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetEntityAttributeDetails'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetEntityAttributeDetails')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'GetEntityAttributeDetails'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','SaveEntityDetails',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'SaveEntityDetails')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'SaveEntityDetails') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'SaveEntityDetails'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'SaveEntityDetails')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'SaveEntityDetails'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','DeleteAssociatedVariant',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'DeleteAssociatedVariant')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'DeleteAssociatedVariant') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'DeleteAssociatedVariant'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'DeleteAssociatedVariant')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'DeleteAssociatedVariant'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','Delete',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Delete')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Delete') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Delete'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Delete')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'Delete'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'ContentWidget','IsWidgetExist',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'IsWidgetExist')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'IsWidgetExist') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'IsWidgetExist'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'IsWidgetExist')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widgets'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'ContentWidget' and ActionName = 'IsWidgetExist'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','List',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'List')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'List') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'List'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'List')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'List'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','Create',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Create')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Create') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Create'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Create')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Create'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','Edit',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Edit')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Edit') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Edit'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Edit')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Edit'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','Delete',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Delete')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Delete') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Delete'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Delete')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Delete'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','Copy',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Copy')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Copy') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Copy'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Copy')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'Copy'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','DownloadWidgetTemplate',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'DownloadWidgetTemplate')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'DownloadWidgetTemplate') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'DownloadWidgetTemplate'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'DownloadWidgetTemplate')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'DownloadWidgetTemplate'))



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WidgetTemplate','IsWidgetTemplateExist',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'IsWidgetTemplateExist')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
,(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'IsWidgetTemplateExist') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'IsWidgetTemplateExist'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS'))) ,
(select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'IsWidgetTemplateExist')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select top 1 MenuId from ZnodeMenu where MenuName = 'Widget Templates'
and ParentMenuId = ( select Top 1 MenuId from ZnodeMenu where MenuName = 'Widgets' and ParentMenuId =(select Top 1 MenuId from ZnodeMenu where MenuName = 'CMS')))
and ActionId = (select top 1 ActionId from ZnodeActions where ControllerName = 'WidgetTemplate' and ActionName = 'IsWidgetTemplateExist'))

go
if exists(select * from sys.procedures where name ='Znode_DeleteCMSWidgetTemplates')
	drop proc Znode_DeleteCMSWidgetTemplates
go

CREATE PROCEDURE [dbo].[Znode_DeleteCMSWidgetTemplates]
(@WidgetTemplateIds  VARCHAR(2000),
@status  BIT OUT)


AS

BEGIN
		BEGIN TRY
			 BEGIN TRAN DeleteWidgetTemplates

			 DECLARE @TBL_WidgetTemplate TABLE(WidgetTemplateId int)

			 INSERT INTO @TBL_WidgetTemplate (WidgetTemplateId)
			 SELECT item FROM dbo.Split(@WidgetTemplateIds,',')

			 DECLARE @TBL_DeleteIds TABLE(WidgetTemplateId int)
			 
			 INSERT INTO @TBL_DeleteIds(WidgetTemplateId)
			 SELECT WT.WidgetTemplateId FROM @TBL_WidgetTemplate WT inner join
			 ZnodeCMSWidgetTemplate CWT on WT.WidgetTemplateId = CWT.CMSWidgetTemplateId 
			 WHERE not exists
			 (
				SELECT top 1 1 FROM ZnodeCMSWidgetProfileVariant CW WHERE
				CW.CMSWidgetTemplateId = WT.WidgetTemplateId

			 )

			delete FROM ZnodeCMSWidgetTemplate
			 WHERE exists
			 (
				SELECT top 1 1 FROM @TBL_DeleteIds DI
				WHERE DI.WidgetTemplateId = ZnodeCMSWidgetTemplate.CMSWidgetTemplateId

			 );
			 IF(SELECT COUNT(1) FROM @TBL_DeleteIds) = (SELECT COUNT(1) FROM @TBL_WidgetTemplate )  
			 BEGIN
                     SET @Status = 1;
                     SELECT 1 AS ID,
                            CAST(1 AS BIT) AS [Status];
                 END;
             ELSE
                 BEGIN
                     SET @Status = 0;
                     SELECT 1 AS ID,
                            CAST(0 AS BIT) AS [Status];
                 END;

             COMMIT TRAN DeleteWidgetTemplates;
		END TRY

		BEGIN CATCH
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			 @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteCMSWidgetTemplates 
			 @WidgetTemplateIds = '+@WidgetTemplateIds+',@Status='+CAST(@Status AS VARCHAR(50));

			  	  SET @Status =0  
				  SELECT 1 AS ID,@Status AS Status;  
				  ROLLBACK TRAN DeleteWidgetTemplates;
				  EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_DeleteCMSWidgetTemplates',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
       
		END CATCH

END
go
if exists(select * from sys.procedures where name ='Znode_DeleteContentWidget')
	drop proc Znode_DeleteContentWidget
go

CREATE PROCEDURE [dbo].[Znode_DeleteContentWidget]
(@ContentWidgetIds  VARCHAR(2000),
@status  BIT OUT)


AS

BEGIN
		BEGIN TRY

			 BEGIN TRAN DeleteContentWidget
			
				 DECLARE @TBL_DeleteWidgetId TABLE(widgetId INT); 
             
					INSERT INTO @TBL_DeleteWidgetId(widgetId)
					SELECT Item FROM  dbo.Split(@ContentWidgetIds, ',')	
				 
					DELETE GWL  from ZnodeWidgetGlobalAttributeValueLocale GWL
					INNER JOIN ZnodeWidgetGlobalAttributeValue WGA ON 
					GWL.WidgetGlobalAttributeValueId = WGA.WidgetGlobalAttributeValueId
					INNER JOIN @TBL_DeleteWidgetId DC ON WGA.CMSContentWidgetId = DC.widgetId
					
					
					DELETE GAV  FROM ZnodeWidgetGlobalAttributeValue GAV
					INNER JOIN @TBL_DeleteWidgetId DC ON  GAV.CMSContentWidgetId = DC.widgetId	
					
					DELETE GEFM FROM ZnodeGlobalEntityFamilyMapper GEFM			
					INNER JOIN @TBL_DeleteWidgetId DC ON  GEFM.GlobalEntityValueId = DC.widgetId	
         

					DELETE WPV FROM ZnodeCMSWidgetProfileVariant WPV
					INNER JOIN @TBL_DeleteWidgetId DC ON  WPV.CMSContentWidgetId = DC.widgetId

					DELETE CW FROM ZnodeCMSContentWidget CW
					INNER JOIN @TBL_DeleteWidgetId DC ON  CW.CMSContentWidgetId = DC.widgetId

				  SET @Status = 1;
                     SELECT 1 AS ID,
                            CAST(1 AS BIT) AS [Status];

             COMMIT TRAN DeleteContentWidget;
		END TRY

		BEGIN CATCH

             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			 @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteContentWidget 
			 @ContentWidgetIds = '+@ContentWidgetIds+',@Status='+CAST(@Status AS VARCHAR(50));


			  	 SET @Status =0  
				 SELECT 1 AS ID,@Status AS Status;  
				 ROLLBACK TRAN DeleteContentWidget;
				 EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_DeleteContentWidget',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
       
		END CATCH

END
go
if exists(select * from sys.procedures where name ='Znode_GetCMSWidgetlist')
	drop proc Znode_GetCMSWidgetlist
go

CREATE procedure [dbo].[Znode_GetCMSWidgetlist]  
(    
  @WhereClause NVARCHAR(Max)       
 ,@Rows INT = 100       
 ,@PageNo INT = 1       
 ,@Order_BY VARCHAR(1000) = ''    
 ,@RowsCount INT OUT    
)    
AS    
  
BEGIN      
	  BEGIN TRY     
		SET NOCOUNT ON        
		DECLARE @SQL NVARCHAR(MAX)    
        

		DECLARE @TBL_ContentWidget TABLE (ContentWidgetId INT,WidgetKey NVARCHAR(max),PortalId INT,Tags NVARCHAR(max),StoreName NVARCHAR(max),RowId INT,CountNo INT,IsGlobalContentWidget nvarchar(5))  
      SET @SQL = '   
				 ;With Cte_ContentWidget AS   
				 (  
				 SELECT ZCW.CMSContentWidgetId, ZCW.WidgetKey, ZCW.PortalId, ZCW.Tags,
					Case when ZCW.PortalId is null then  ''All'' else ZP.StoreName end StoreName  ,
					cast(CASE WHEN ZCW.PortalId IS NULL  THEN  ''true'' ELSE  ''false'' END as varchar(10)) IsGlobalContentWidget  
				 FROM ZnodeCMSContentWidget ZCW  
				 LEFT JOIN ZnodePortal ZP  on (ZCW.PortalId = ZP.PortalId )        
				 )  
				 ,Cte_ContentWidgetList AS
				 (
					SELECT CMSContentWidgetId, WidgetKey, PortalId, Tags,StoreName,IsGlobalContentWidget,
					'+dbo.Fn_GetPagingRowId(@Order_BY,'WidgetKey ASC')+',Count(*)Over() CountNo 
					FROM Cte_ContentWidget    
					   WHERE 1=1 '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'    
				 )

				SELECT CMSContentWidgetId,WidgetKey,PortalId,Tags,StoreName,RowId,CountNo ,IsGlobalContentWidget   
				 FROM Cte_ContentWidgetList   
				 '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)  
       
				 print @sql  
  
  
				 INSERT INTO @TBL_ContentWidget (ContentWidgetId,WidgetKey,PortalId,Tags,StoreName,RowId,CountNo,IsGlobalContentWidget)  
				 EXEC (@SQL)  
				 SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_ContentWidget ),0)  

  
				 SELECT ContentWidgetId,PortalId,WidgetKey,Tags, StoreName,IsGlobalContentWidget
				 FROM @TBL_ContentWidget  

		 END TRY    
         BEGIN CATCH    
            DECLARE @Status BIT ;    
		    SET @Status = 0;    
		    DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= 
		    ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 
		   'EXEC Znode_GetCMSWidgetlist @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',
		    @Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',
		    @RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));    
                      
               SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                       
        
			EXEC Znode_InsertProcedureErrorLog    
			@ProcedureName = 'Znode_GetCMSWidgetlist',    
			@ErrorInProcedure = @Error_procedure,    
			@ErrorMessage = @ErrorMessage,    
			@ErrorLine = @ErrorLine,    
			@ErrorCall = @ErrorCall;                                
         END CATCH; 
 END;    

go
if exists(select * from sys.procedures where name ='Znode_GetGlobalEntityAttributeValue')
	drop proc Znode_GetGlobalEntityAttributeValue
go

CREATE   PROCEDURE [dbo].[Znode_GetGlobalEntityAttributeValue]
(
    @EntityName       nvarchar(200) = 0,
    @GlobalEntityValueId   INT = 0,
	@LocaleCode       nvarchar(200) = '',
	@GroupCode nvarchar(200)  = null,
	@SelectedValue bit = 0
)
AS
/*
	 Summary :- This procedure is used to get the Attribute and EntityValue attribute value as per filter pass 
	 Unit Testing 
	 BEGIN TRAN
	 EXEC [Znode_GetGlobalEntityAttributeValue] 'Store',1
	 ROLLBACK TRAN

*/	 
     BEGIN
         BEGIN TRY
 


		 IF @EntityName='Store'
			 Exec [dbo].[Znode_GetPortalGlobalAttributeValue] 
			 @EntityName=@EntityName,
			 @GlobalEntityValueId=@GlobalEntityValueId,@LocaleCode=@LocaleCode,
			 @GroupCode =@GroupCode,
			 @SelectedValue = @SelectedValue

		 Else IF @EntityName='User'
			 Exec [dbo].[Znode_GetUserGlobalAttributeValue] 
			 @EntityName=@EntityName,
			 @GlobalEntityValueId=@GlobalEntityValueId,
			 @LocaleCode=@LocaleCode,
			 @GroupCode =@GroupCode,
			 @SelectedValue = @SelectedValue

		Else IF @EntityName='Account'
			 Exec [dbo].[Znode_GetAccountGlobalAttributeValue] 
			 @EntityName=@EntityName,
			 @GlobalEntityValueId=@GlobalEntityValueId,
			 @LocaleCode=@LocaleCode,
			 @GroupCode =@GroupCode,
			 @SelectedValue = @SelectedValue
		--Else IF @EntityName='FormBuilder'
		--	 Exec [dbo].[Znode_GetFormBuilderGlobalAttributeValue] 
		--	 @EntityName=@EntityName,
		--	 @GlobalEntityValueId=@GlobalEntityValueId

		
			 Else IF @EntityName='Content Widgets'
			 Exec [dbo].[Znode_GetWidgetGlobalAttributeValue] 
			 @EntityName=@EntityName,
			 @GlobalEntityValueId=@GlobalEntityValueId,
			 @LocaleCode=@LocaleCode,
			 @GroupCode =@GroupCode,
			 @SelectedValue = @SelectedValue
   
		  END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;
		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		    @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetGlobalEntityAttributeValue @EntityName = '''+ISNULL(@EntityName,'''''')+''',@GlobalEntityValueId='+ISNULL(CAST(@GlobalEntityValueId AS VARCHAR(50)),'''')+
			''',@LocaleCode='+ISNULL(CAST(@LocaleCode AS VARCHAR(100)),'''')+''',@GroupCode='+ISNULL(CAST(@GroupCode AS VARCHAR(100)),'''')+''',@SelectedValue='+ISNULL(CAST(@SelectedValue AS VARCHAR(50)),'''')      			 
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                     
		 
          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetGlobalEntityAttributeValue',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;
go

if exists(select * from sys.procedures where name ='Znode_GetWidgetGlobalAttributeValue')
	drop proc Znode_GetWidgetGlobalAttributeValue
go

CREATE  PROCEDURE [dbo].[Znode_GetWidgetGlobalAttributeValue]
(
    @EntityName       nvarchar(200) = 0,
    @GlobalEntityValueId   INT = 0,
	@LocaleCode       VARCHAR(100) = '',
    @GroupCode  nvarchar(200) = null,
    @SelectedValue bit = 0
)
AS
 BEGIN
 BEGIN TRY
 declare @EntityValue nvarchar(200), @LocaleId int, @WidgetId int

 

  DECLARE @V_MediaServerThumbnailPath VARCHAR(4000);
          SET @V_MediaServerThumbnailPath =
         (
             SELECT ISNULL(CASE WHEN CDNURL = '' THEN NULL ELSE CDNURL END,URL)+ZMSM.ThumbnailFolderName+'/'  
             FROM ZnodeMediaConfiguration ZMC 
			 INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
		     WHERE IsActive = 1 
         );


 Select @EntityValue= Name,@WidgetId = CCW.CMSContentWidgetId from ZnodeCMSContentWidget CCW
 inner join ZnodeCMSWidgetProfileVariant CWPV  on CCW.CMSContentWidgetId = CWPV.CMSContentWidgetId
 Where CWPV.CMSWidgetProfileVariantId = @GlobalEntityValueId

 print @EntityValue

 	DECLARE @GlobalFamilyId int
	SET  @GlobalFamilyId = (select top 1 FM.GlobalAttributeFamilyId from ZnodeGlobalEntity GE inner join  ZnodeGlobalEntityFamilyMapper FM
	on GE.GlobalEntityId = FM.GlobalEntityId
	where GE.EntityName =  @EntityName and  (FM.GlobalEntityValueId = @WidgetId ))
  

            Declare	@EntityAttributeList as	table  (GlobalEntityId int,EntityName nvarchar(300),EntityValue nvarchar(max),
			GlobalAttributeGroupId int,GlobalAttributeId int,AttributeTypeId int,AttributeTypeName nvarchar(300),
			 AttributeCode nvarchar(300) ,IsRequired bit,IsLocalizable bit,AttributeName  nvarchar(300) , HelpDescription nvarchar(max),DisplayOrder int
			) 
			 
			Declare @EntityAttributeValidationList  as	table  
			( GlobalAttributeId int, ControlName nvarchar(300), ValidationName nvarchar(300),SubValidationName nvarchar(300),
			 RegExp nvarchar(300), ValidationValue nvarchar(300),IsRegExp Bit)

			Declare	@EntityAttributeValueList as	table  (GlobalAttributeId int,AttributeValue nvarchar(max),
			GlobalAttributeValueId int,GlobalAttributeDefaultValueId int,AttributeDefaultValueCode nvarchar(300),
			AttributeDefaultValue nvarchar(300),
			MediaId int,MediaPath nvarchar(300),IsEditable bit,DisplayOrder int )



			Declare	@EntityAttributeDefaultValueList as	table  (GlobalAttributeDefaultValueId int,GlobalAttributeId int,
			AttributeDefaultValueCode nvarchar(300),AttributeDefaultValue nvarchar(300),RowId int,IsEditable bit,DisplayOrder int )

			set @LocaleId = (select top 1 LocaleId from ZnodeLocale where Code = @LocaleCode)

            IF ISnull(@GroupCode, '') = ''
            Begin
			
				insert into @EntityAttributeList
					(	GlobalEntityId ,EntityName ,EntityValue ,
					GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
					AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription,DisplayOrder  ) 
				SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
					c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
					c.IsLocalizable,f.AttributeName,c.HelpDescription,c.DisplayOrder
				 FROM dbo.ZnodeGlobalEntity AS qq
					  INNER JOIN dbo.ZnodeGlobalAttributeFamily AS w ON qq.GlobalEntityId = w.GlobalEntityId
					  INNER JOIN dbo.ZnodeGlobalFamilyGroupMapper AS FGM ON FGM.GlobalAttributeFamilyId = w.GlobalAttributeFamilyId
					  INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = FGM.GlobalAttributeGroupId
					  INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
					  INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
					  INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
					  Where qq.EntityName=@EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
					  and w.GlobalAttributeFamilyId = @GlobalFamilyId

				
			END
			Else

               Begin
                       insert into @EntityAttributeList
                               ( GlobalEntityId ,EntityName ,EntityValue ,
                               GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
                               AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription,DisplayOrder  )
                               SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,ww.GlobalAttributeGroupId,
                               c.GlobalAttributeId,c.AttributeTypeId,q.AttributeTypeName,c.AttributeCode,c.IsRequired,
                               c.IsLocalizable,f.AttributeName,c.HelpDescription,c.DisplayOrder
                        FROM dbo.ZnodeGlobalEntity AS qq
						INNER JOIN dbo.ZnodeGlobalAttributeFamily AS w ON qq.GlobalEntityId = w.GlobalEntityId
					  INNER JOIN dbo.ZnodeGlobalFamilyGroupMapper AS FGM ON FGM.GlobalAttributeFamilyId = w.GlobalAttributeFamilyId
					  INNER JOIN dbo.ZnodeGlobalAttributeGroupMapper AS ww ON ww.GlobalAttributeGroupId = FGM.GlobalAttributeGroupId
					  INNER JOIN dbo.ZnodeGlobalAttribute AS c ON ww.GlobalAttributeId = c.GlobalAttributeId
					  INNER JOIN dbo.ZnodeAttributeType AS q ON c.AttributeTypeId = q.AttributeTypeId
					  INNER JOIN dbo.ZnodeGlobalAttributeLocale AS f ON c.GlobalAttributeId = f.GlobalAttributeId
					  Where qq.EntityName=@EntityName AND ( f.LocaleId = isnull(@LocaleId, 0 ) or isnull(@LocaleId,0) = 0 )
					  and w.GlobalAttributeFamilyId = @GlobalFamilyId	
                                 AND exists( select 1 from ZnodeGlobalAttributeGroup g where ww.GlobalAttributeGroupId = g.GlobalAttributeGroupId and g.GroupCode = @GroupCode )	
        
			   END


		  INSERT INTO @EntityAttributeValidationList
		  (GlobalAttributeId,ControlName , ValidationName ,SubValidationName ,
		RegExp, ValidationValue,IsRegExp)

		

		 Select aa.GlobalAttributeId,i.ControlName,i.Name AS ValidationName,j.ValidationName AS SubValidationName,
		j.RegExp,k.Name AS ValidationValue,CAST(CASE WHEN j.RegExp IS NULL THEN 0 ELSE 1 END AS BIT) AS IsRegExp
		
		fROM @EntityAttributeList aa
		  inner  JOIN dbo.ZnodeGlobalAttributeValidation AS k ON k.GlobalAttributeId = aa.GlobalAttributeId
          inner  JOIN dbo.ZnodeAttributeInputValidation AS i ON k.InputValidationId = i.InputValidationId
          LEFT  JOIN dbo.ZnodeAttributeInputValidationRule AS j ON k.InputValidationRuleId = j.InputValidationRuleId

		  insert into @EntityAttributeValueList
		  (GlobalAttributeId,GlobalAttributeValueId,GlobalAttributeDefaultValueId,AttributeValue ,MediaId,MediaPath)
		  Select DISTINCT GlobalAttributeId,aa.WidgetGlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
		  case when bb.MediaPath is not null then  @V_MediaServerThumbnailPath+bb.MediaPath--+'~'+convert(nvarchar(10),bb.MediaId) 
		  else bb.AttributeValue end,		  
		  bb.MediaId,bb.MediaPath
		  from  dbo.ZnodeWidgetGlobalAttributeValue aa
		   inner join ZnodeWidgetGlobalAttributeValueLocale bb ON bb.WidgetGlobalAttributeValueId = aa.WidgetGlobalAttributeValueId 
		  Where  aa.CMSWidgetProfileVariantId=@GlobalEntityValueId and aa.CMSContentWidgetId = @WidgetId		
	  
	

		  update aa
		  Set AttributeDefaultValueCode= h.AttributeDefaultValueCode,
              AttributeDefaultValue=g.AttributeDefaultValue,
			  GlobalAttributeDefaultValueId=g.GlobalAttributeDefaultValueId,
			  AttributeValue=case when aa.AttributeValue is  null then h.AttributeDefaultValueCode else aa.AttributeValue end,
			  IsEditable = ISNULL(h.IsEditable, 1),DisplayOrder = h.DisplayOrder
		  from  @EntityAttributeValueList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeDefaultValueId = aa.GlobalAttributeDefaultValueId                                       
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
          
		  insert into @EntityAttributeDefaultValueList
		  (GlobalAttributeDefaultValueId,GlobalAttributeId,AttributeDefaultValueCode,
			AttributeDefaultValue ,RowId ,IsEditable ,DisplayOrder )
		  Select  h.GlobalAttributeDefaultValueId, aa.GlobalAttributeId,h.AttributeDefaultValueCode,g.AttributeDefaultValue,0,ISNULL(h.IsEditable, 1),
		  h.DisplayOrder
		  from  @EntityAttributeList aa
		  inner JOIN dbo.ZnodeGlobalAttributeDefaultValue h ON h.GlobalAttributeId = aa.GlobalAttributeId
          inner JOIN dbo.ZnodeGlobalAttributeDefaultValueLocale g ON h.GlobalAttributeDefaultValueId = g.GlobalAttributeDefaultValueId
		  
		 
			if not exists (Select 1 from @EntityAttributeList )
			Begin
			insert into @EntityAttributeList
			(	GlobalEntityId ,EntityName ,EntityValue ,
			GlobalAttributeGroupId ,GlobalAttributeId ,AttributeTypeId ,AttributeTypeName ,
			AttributeCode  ,IsRequired ,IsLocalizable ,AttributeName,HelpDescription  ) 
			SELECT qq.GlobalEntityId,qq.EntityName,@EntityValue EntityValue,0 GlobalAttributeGroupId,
			0 GlobalAttributeId,0 AttributeTypeId,''AttributeTypeName,''AttributeCode,0 IsRequired,
			0 IsLocalizable,'' AttributeName,'' HelpDescription
			FROM dbo.ZnodeGlobalEntity AS qq
			 Where qq.EntityName=@EntityName 
			End
				

			SELECT GlobalEntityId,EntityName,EntityValue,GlobalAttributeGroupId,
			AA.GlobalAttributeId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,
			IsLocalizable,AttributeName,ControlName,ValidationName,SubValidationName,RegExp,
			ValidationValue,cast(isnull(IsRegExp,0) as bit)  IsRegExp,
			HelpDescription,AttributeValue,GlobalAttributeValueId,bb.GlobalAttributeDefaultValueId,
			aab.AttributeDefaultValueCode,
			aab.AttributeDefaultValue,isnull(aab.RowId,0)   RowId,cast(isnull(aab.IsEditable,0) as bit)   IsEditable
			,bb.MediaId,AA.DisplayOrder
			fROM @EntityAttributeList AA				
			left join @EntityAttributeDefaultValueList aab on aab.GlobalAttributeId=AA.GlobalAttributeId	
			left join @EntityAttributeValidationList vl on vl.GlobalAttributeId=aa.GlobalAttributeId			
			LEFT JOIN @EntityAttributeValueList BB ON BB.GlobalAttributeId=AA.GlobalAttributeId		 
		    and ( (aab.GlobalAttributeDefaultValueId=bb.GlobalAttributeDefaultValueId	)
			or  ( bb.MediaId is not null and isnull(vl.ValidationName,'')='IsAllowMultiUpload'  and bb.GlobalAttributeDefaultValueId is null )
			or  ( bb.MediaId is  null and  bb.GlobalAttributeDefaultValueId is null ))
			order by AA.DisplayOrder, aab.DisplayOrder

			SELECT 1 AS ID,CAST(1 AS BIT) AS Status;       
		  END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;

		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		   @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetWidgetGlobalAttributeValue 
		   @EntityName = '+@EntityName+',@GlobalEntityValueId='+CAST(@GlobalEntityValueId AS VARCHAR(10))+',@LocaleCode='+@LocaleCode+',
		   @GroupCode = '+@GroupCode+',@SelectedValue = '+CAST(@SelectedValue AS VARCHAR(10));   
		 
          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetWidgetGlobalAttributeValue',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;

go
if exists(select * from sys.procedures where name ='Znode_ImportInsertUpdateWidgetGlobalAttributeValue')
	drop proc Znode_ImportInsertUpdateWidgetGlobalAttributeValue
go

CREATE PROCEDURE [dbo].[Znode_ImportInsertUpdateWidgetGlobalAttributeValue]
(
    @GlobalEntityValueDetail  [GlobalEntityValueDetail] READONLY,
    @UserId            INT       ,
    @status            BIT    OUT,
    @IsNotReturnOutput BIT    = 0 )
AS
     BEGIN
         BEGIN TRAN A;
         BEGIN TRY
			 DECLARE @GlobalEntityId INT,
			  @MultiSelectGroupAttributeTypeName nvarchar(200)='Select'
			 ,@MediaGroupAttributeTypeName nvarchar(200)='Media'
             DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
			 DECLARE @LocaleId INT 
			 declare  @CMSContentWidgetId int
			 declare  @CMSWidgetProfileVariantId int
			 DECLARE @TBL_Widget TABLE (CMSWidgetProfileVariantId [int] NULL)
			 DECLARE @TBL_DeleteUser TABLE (CMSWidgetProfileVariantId [int] NULL,WidgetGlobalAttributeValueId int)
			 DECLARE @TBL_AttributeDefaultValueList TABLE 
			   (NewWidgetGlobalAttributeValueId int,WidgetGlobalAttributeValueId int,[AttributeValue] [varchar](300),[GlobalAttributeDefaultValueId] int,
			   [GlobalAttributeId] int,MediaId int,WidgetGlobalAttributeValueLocaleId int)


			 DECLARE @TBL_MediaValueList TABLE 
			   (NewWidgetGlobalAttributeValueId int,WidgetGlobalAttributeValueId int,GlobalAttributeId int,
			   MediaId int,MediaPath nvarchar(300),WidgetGlobalAttributeValueLocaleId int)
			 DECLARE @TBL_InsertGlobalEntityValue TABLE 
				([GlobalAttributeId] [int] NULL,GlobalAttributeDefaultValueId [int] NULL,CMSWidgetProfileVariantId [int] NULL,
					WidgetGlobalAttributeValueId int null)
		 	 DECLARE @TBL_GlobalEntityValueDetail TABLE ([GlobalAttributeId] [int] NULL,
				[AttributeCode] [varchar](300),[GlobalAttributeDefaultValueId] [int],[GlobalAttributeValueId] [int],
				[LocaleId] [int],CMSWidgetProfileVariantId [int], [AttributeValue] [nvarchar](max),WidgetGlobalAttributeValueId int,
				NewWidgetGlobalAttributeValueId int,GroupAttributeTypeName [varchar](300))
				
				
				SELECT TOP 1 @LocaleId = LocaleId FROM @GlobalEntityValueDetail;
				SELECT TOP 1 @CMSWidgetProfileVariantId = GlobalEntityValueId FROM @GlobalEntityValueDetail;


				
				 Select @CMSContentWidgetId = CCW.CMSContentWidgetId from ZnodeCMSContentWidget CCW
				 inner join ZnodeCMSWidgetProfileVariant CWPV  on CCW.CMSContentWidgetId = CWPV.CMSContentWidgetId
				 Where CWPV.CMSWidgetProfileVariantId = @CMSWidgetProfileVariantId

				Insert into @TBL_GlobalEntityValueDetail
				([GlobalAttributeId],[AttributeCode],[GlobalAttributeDefaultValueId],
				[GlobalAttributeValueId],[LocaleId],CMSWidgetProfileVariantId,[AttributeValue],GroupAttributeTypeName)
				Select dd.[GlobalAttributeId],dd.[AttributeCode],case when [GlobalAttributeDefaultValueId]=0 then null else 
				[GlobalAttributeDefaultValueId] end [GlobalAttributeDefaultValueId],
				case when [GlobalAttributeValueId]=0 then null else 
				[GlobalAttributeValueId] end [GlobalAttributeValueId],[LocaleId],[GlobalEntityValueId],[AttributeValue],ss.GroupAttributeType
				From @GlobalEntityValueDetail dd
				inner join [View_ZnodeGlobalAttribute] ss on ss.GlobalAttributeId=dd.GlobalAttributeId

				Update ss
				Set ss.WidgetGlobalAttributeValueId=dd.WidgetGlobalAttributeValueId
				From @TBL_GlobalEntityValueDetail ss
				inner join ZnodeWidgetGlobalAttributeValue dd on dd.CMSWidgetProfileVariantId=ss.CMSWidgetProfileVariantId
				and dd.GlobalAttributeId=ss.GlobalAttributeId
				
				insert into @TBL_Widget(CMSWidgetProfileVariantId)
				Select distinct  CMSWidgetProfileVariantId from @TBL_GlobalEntityValueDetail;

                insert into @TBL_DeleteUser
				Select p.CMSWidgetProfileVariantId,a.WidgetGlobalAttributeValueId
				from ZnodeWidgetGlobalAttributeValue a
				inner join @TBL_Widget p on p.CMSWidgetProfileVariantId=a.CMSWidgetProfileVariantId
				Where not exists(select 1 from @TBL_GlobalEntityValueDetail dd 
				where dd.CMSWidgetProfileVariantId=a.CMSWidgetProfileVariantId and dd.GlobalAttributeId=a.GlobalAttributeId)
				
				               
				Delete From ZnodeWidgetGlobalAttributeValueLocale
				WHere exists (select 1 from @TBL_DeleteUser dd 
				Where dd.WidgetGlobalAttributeValueId=ZnodeWidgetGlobalAttributeValueLocale.WidgetGlobalAttributeValueId)

				Delete From ZnodeWidgetGlobalAttributeValue
				WHere exists (select 1 from @TBL_DeleteUser dd 
				Where dd.WidgetGlobalAttributeValueId=ZnodeWidgetGlobalAttributeValue.WidgetGlobalAttributeValueId)
							

				INSERT INTO [dbo].[ZnodeWidgetGlobalAttributeValue]
				([CMSContentWidgetId],[CMSWidgetProfileVariantId],[GlobalAttributeId],[GlobalAttributeDefaultValueId],[CreatedBy],[CreatedDate],
				[ModifiedBy],[ModifiedDate])
				 output Inserted.GlobalAttributeId,inserted.[GlobalAttributeDefaultValueId],inserted.CMSWidgetProfileVariantId,
				 inserted.WidgetGlobalAttributeValueId into @TBL_InsertGlobalEntityValue
				Select @CMSContentWidgetId,[CMSWidgetProfileVariantId],[GlobalAttributeId],[GlobalAttributeDefaultValueId]
				,@UserId [CreatedBy],@GetDate [CreatedDate],@UserId [ModifiedBy],@GetDate [ModifiedDate]
				From @TBL_GlobalEntityValueDetail dd
				WHERE WidgetGlobalAttributeValueId IS NULL				

            
				Update dd
				Set dd.NewWidgetGlobalAttributeValueId=ss.WidgetGlobalAttributeValueId
				From @TBL_GlobalEntityValueDetail dd
				inner join @TBL_InsertGlobalEntityValue ss on dd.[CMSWidgetProfileVariantId]=ss.[CMSWidgetProfileVariantId]
				and dd.GlobalAttributeId=ss.GlobalAttributeId				

				INSERT INTO [dbo].[ZnodeWidgetGlobalAttributeValueLocale]
			   ([WidgetGlobalAttributeValueId],[LocaleId],[AttributeValue],[CreatedBy],[CreatedDate],[ModifiedBy]
			   ,[ModifiedDate])
				Select NewWidgetGlobalAttributeValueId,[LocaleId],[AttributeValue],@UserId [CreatedBy],@GetDate [CreatedDate],
				@UserId [ModifiedBy],@GetDate [ModifiedDate]
				From @TBL_GlobalEntityValueDetail dd
				WHERE NewWidgetGlobalAttributeValueId IS not NULL
				and isnull([AttributeValue],'') <>''    
				and isnull(GroupAttributeTypeName,'') != @MultiSelectGroupAttributeTypeName
				and isnull(GroupAttributeTypeName,'') != @MediaGroupAttributeTypeName		
				
				Update ss
				Set ss.AttributeValue=dd.AttributeValue,ss.ModifiedDate=@GetDate,ss.ModifiedBy=@UserId
				From @TBL_GlobalEntityValueDetail dd
				inner join [dbo].[ZnodeWidgetGlobalAttributeValueLocale] ss on ss.WidgetGlobalAttributeValueId =dd.WidgetGlobalAttributeValueId
				Where isnull(GroupAttributeTypeName,'') != @MultiSelectGroupAttributeTypeName
				and isnull(GroupAttributeTypeName,'') != @MediaGroupAttributeTypeName	

				insert into @TBL_AttributeDefaultValueList
				(NewWidgetGlobalAttributeValueId,WidgetGlobalAttributeValueId,dd.AttributeValue,GlobalAttributeId)
				Select dd.NewWidgetGlobalAttributeValueId, dd.WidgetGlobalAttributeValueId,ss.Item,dd.GlobalAttributeId
				From @TBL_GlobalEntityValueDetail dd
				cross apply dbo.Split(dd.AttributeValue,',') ss
				Where isnull(GroupAttributeTypeName,'') = @MultiSelectGroupAttributeTypeName

				Update dd
				Set dd.GlobalAttributeDefaultValueId=ss.GlobalAttributeDefaultValueId
				from  @TBL_AttributeDefaultValueList DD
				inner join [ZnodeGlobalAttributeDefaultValue] ss on dd.GlobalAttributeId=ss.GlobalAttributeId
				and dd.AttributeValue=ss.AttributeDefaultValueCode

				Update dd
				Set dd.WidgetGlobalAttributeValueLocaleId=ss.WidgetGlobalAttributeValueLocaleId
				from  @TBL_AttributeDefaultValueList DD
				inner join [ZnodeWidgetGlobalAttributeValueLocale] ss on dd.WidgetGlobalAttributeValueId=ss.WidgetGlobalAttributeValueId
				and ss.GlobalAttributeDefaultValueId=dd.GlobalAttributeDefaultValueId

				delete ss
				From @TBL_GlobalEntityValueDetail dd
				inner join [ZnodeWidgetGlobalAttributeValueLocale] ss on dd.WidgetGlobalAttributeValueId=ss.WidgetGlobalAttributeValueId
				Where isnull(GroupAttributeTypeName,'') = @MultiSelectGroupAttributeTypeName
				and not exists (Select 1 from @TBL_AttributeDefaultValueList cc 
				where cc.WidgetGlobalAttributeValueLocaleId=ss.WidgetGlobalAttributeValueLocaleId )

				INSERT INTO [dbo].[ZnodeWidgetGlobalAttributeValueLocale]
			   ([WidgetGlobalAttributeValueId],[LocaleId],GlobalAttributeDefaultValueId,[CreatedBy],[CreatedDate],[ModifiedBy]
			   ,[ModifiedDate])
				Select ss.NewWidgetGlobalAttributeValueId,dd.[LocaleId],ss.GlobalAttributeDefaultValueId,@UserId [CreatedBy],@GetDate [CreatedDate],
				@UserId [ModifiedBy],@GetDate [ModifiedDate]
				From @TBL_GlobalEntityValueDetail dd
				inner join @TBL_AttributeDefaultValueList ss on dd.GlobalAttributeId=ss.GlobalAttributeId
				and ss.NewWidgetGlobalAttributeValueId=dd.NewWidgetGlobalAttributeValueId
				WHERE isnull(dd.GroupAttributeTypeName,'') = @MultiSelectGroupAttributeTypeName

				INSERT INTO [dbo].[ZnodeWidgetGlobalAttributeValueLocale]
			   ([WidgetGlobalAttributeValueId],[LocaleId],GlobalAttributeDefaultValueId,[CreatedBy],[CreatedDate],[ModifiedBy]
			   ,[ModifiedDate])
				Select ss.WidgetGlobalAttributeValueId,dd.[LocaleId],ss.GlobalAttributeDefaultValueId,@UserId [CreatedBy],@GetDate [CreatedDate],
				@UserId [ModifiedBy],@GetDate [ModifiedDate]
				From @TBL_GlobalEntityValueDetail dd
				inner join @TBL_AttributeDefaultValueList ss on dd.GlobalAttributeId=ss.GlobalAttributeId
				and ss.WidgetGlobalAttributeValueId=dd.WidgetGlobalAttributeValueId				
				WHERE isnull(dd.GroupAttributeTypeName,'') = @MultiSelectGroupAttributeTypeName
				and ss.WidgetGlobalAttributeValueLocaleId is null 


				insert into @TBL_MediaValueList
				(NewWidgetGlobalAttributeValueId,WidgetGlobalAttributeValueId,GlobalAttributeId,MediaId)
				Select dd.NewWidgetGlobalAttributeValueId, dd.WidgetGlobalAttributeValueId,GlobalAttributeId,ss.Item 
				From @TBL_GlobalEntityValueDetail dd
				cross apply dbo.Split(dd.AttributeValue,',') ss
				Where isnull(GroupAttributeTypeName,'') = @MediaGroupAttributeTypeName

				Update dd
				Set dd.MediaPath=ss.Path
				from  @TBL_MediaValueList DD
				inner join ZnodeMedia ss on dd.MediaId=ss.MediaId

				Update dd
				Set dd.WidgetGlobalAttributeValueLocaleId=ss.WidgetGlobalAttributeValueLocaleId
				from  @TBL_MediaValueList DD
				inner join [ZnodeWidgetGlobalAttributeValueLocale] ss on dd.WidgetGlobalAttributeValueId=ss.WidgetGlobalAttributeValueId
				and ss.MediaId=dd.MediaId

				delete ss
				From @TBL_GlobalEntityValueDetail dd
				inner join [ZnodeWidgetGlobalAttributeValueLocale] ss on dd.WidgetGlobalAttributeValueId=ss.WidgetGlobalAttributeValueId
				Where isnull(GroupAttributeTypeName,'') = @MediaGroupAttributeTypeName
				and not exists (Select 1 from @TBL_MediaValueList cc 
				where cc.MediaId=ss.MediaId
				and cc.WidgetGlobalAttributeValueId=dd.WidgetGlobalAttributeValueId )

				INSERT INTO [dbo].[ZnodeWidgetGlobalAttributeValueLocale]
			   ([WidgetGlobalAttributeValueId],[LocaleId],MediaId,MediaPath,[CreatedBy],[CreatedDate],[ModifiedBy]
			   ,[ModifiedDate])
				Select ss.NewWidgetGlobalAttributeValueId,dd.[LocaleId],ss.MediaId,ss.MediaPath,@UserId [CreatedBy],@GetDate [CreatedDate],
				@UserId [ModifiedBy],@GetDate [ModifiedDate]
				From @TBL_GlobalEntityValueDetail dd
				inner join @TBL_MediaValueList ss on dd.GlobalAttributeId=ss.GlobalAttributeId
				and ss.NewWidgetGlobalAttributeValueId=dd.NewWidgetGlobalAttributeValueId
				WHERE isnull(dd.GroupAttributeTypeName,'') = @MediaGroupAttributeTypeName

				INSERT INTO [dbo].[ZnodeWidgetGlobalAttributeValueLocale]
			   ([WidgetGlobalAttributeValueId],[LocaleId],MediaId,MediaPath,[CreatedBy],[CreatedDate],[ModifiedBy]
			   ,[ModifiedDate])
				Select ss.WidgetGlobalAttributeValueId,dd.[LocaleId],ss.MediaId,ss.MediaPath,@UserId [CreatedBy],@GetDate [CreatedDate],
				@UserId [ModifiedBy],@GetDate [ModifiedDate]
				From @TBL_GlobalEntityValueDetail dd
				inner join @TBL_MediaValueList ss on dd.GlobalAttributeId=ss.GlobalAttributeId
				and ss.WidgetGlobalAttributeValueId=dd.WidgetGlobalAttributeValueId				
				WHERE isnull(dd.GroupAttributeTypeName,'') = @MediaGroupAttributeTypeName
				and ss.WidgetGlobalAttributeValueLocaleId is null 

				Update dd 
				Set dd.MediaPath=ss.MediaPath
				from [ZnodeWidgetGlobalAttributeValueLocale] dd
                inner join @TBL_MediaValueList ss on 
				ss.WidgetGlobalAttributeValueLocaleId =dd.WidgetGlobalAttributeValueLocaleId										    
		
		     SELECT 0 AS ID,CAST(1 AS BIT) AS Status;    
			   
             COMMIT TRAN A;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE()
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ImportInsertUpdateGlobalEntity @UserId = '+CAST(@UserId AS VARCHAR(50))+',@IsNotReturnOutput='+CAST(@IsNotReturnOutput AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
			ROLLBACK TRAN A;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ImportInsertUpdateWidgetGlobalAttributeValue',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;

go
if exists(select * from sys.procedures where name ='Znode_InsertUpdateGlobalEntityAttributeValue')
	drop proc Znode_InsertUpdateGlobalEntityAttributeValue
go

CREATE PROCEDURE [dbo].[Znode_InsertUpdateGlobalEntityAttributeValue]
(   @GlobalEntityValueXml NVARCHAR(max),
    @GlobalEntityValueId int,
	@EntityName varchar(200),
	@FamilyId  INT,
    @UserId     INT,
    @status     BIT OUT )
AS
/*
     Summary : To Insert / Update single Global Entity Value with multiple attribute values 
     Update Logic: 
*/
     BEGIN
         BEGIN TRAN A;
         BEGIN TRY

		     DECLARE @ConvertedXML XML = REPLACE(REPLACE(REPLACE(@GlobalEntityValueXml,' & ', '&amp;'),'"', '&quot;'),'''', '&apos;')
              DECLARE @GlobalEntityValueDetail_xml GlobalEntityValueDetail;

             INSERT INTO @GlobalEntityValueDetail_xml
			 (GlobalAttributeId,GlobalAttributeValueId,GlobalAttributeDefaultValueId,AttributeCode,AttributeValue
			 ,LocaleId,GlobalEntityValueId)
			SELECT Tbl.Col.value('GlobalAttributeId[1]', 'int') AS GlobalAttributeId,
			Tbl.Col.value('GlobalAttributeValueId[1]', 'int') AS GlobalAttributeValueId,
			Tbl.Col.value('GlobalAttributeDefaultValueId[1]', 'int') AS GlobalAttributeDefaultValueId,
			Tbl.Col.value('AttributeCode[1]', 'NVARCHAR(300)') AS AttributeCode,
			Tbl.Col.value('AttributeValue[1]', 'NVARCHAR(MAX)') AS AttributeValue,
			Tbl.Col.value('LocaleId[1]', 'INT') AS LocaleId,
			@GlobalEntityValueId AS GlobalEntityValueId
			FROM @ConvertedXML.nodes('//ArrayOfEntityAttributeDetailsModel/EntityAttributeDetailsModel') AS Tbl(Col);

			Declare @IsFamilyUnique BIT
			set @IsFamilyUnique = (select IsFamilyUnique from ZnodeGlobalEntity where EntityName = @EntityName)
			if(@IsFamilyUnique = 0)
			BEGIN
			   IF EXISTS(select top 1 1 from ZnodeGlobalEntityFamilyMapper where GlobalEntityId = (select GlobalEntityId from ZnodeGlobalEntity where EntityName = @EntityName) and GlobalAttributeFamilyId = @FamilyId  and GlobalEntityValueId = @GlobalEntityValueId )
					update ZnodeGlobalEntityFamilyMapper set GlobalAttributeFamilyId= @FamilyId where GlobalEntityValueId = @GlobalEntityValueId
			   ELSE
					insert into ZnodeGlobalEntityFamilyMapper values (@FamilyId,(select GlobalEntityId from ZnodeGlobalEntity where  EntityName = @EntityName),@GlobalEntityValueId)
			END

			If @EntityName='Store'
             EXEC [dbo].[Znode_ImportInsertUpdatePortalGlobalAttributeValue]
                  @GlobalEntityValueDetail_xml,
                  @UserId,
                  @status OUT,0 ; 
			else If @EntityName='User'
			EXEC [dbo].[Znode_ImportInsertUpdateUserGlobalAttributeValue]
                  @GlobalEntityValueDetail_xml,
                  @UserId,
                  @status OUT,0 ; 
			else If @EntityName='Account'
			EXEC [dbo].Znode_ImportInsertUpdateAccountGlobalAttributeValue
                  @GlobalEntityValueDetail_xml,
                  @UserId,
                  @status OUT,0 ; 
		    else if @EntityName = 'Content Widgets'
			EXEC [dbo].Znode_ImportInsertUpdateWidgetGlobalAttributeValue
                  @GlobalEntityValueDetail_xml,
                  @UserId,
                  @status OUT,0 ; 
			else If @EntityName='FormBuilder'
			EXEC [dbo].Znode_ImportInsertUpdateFormBuilderGlobalAttributeValue
                  @GlobalEntityValueDetail_xml,
                  @UserId,
                  @status OUT,0 ; 
			
             SET @status = 1;
             COMMIT TRAN A;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE()
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC [Znode_InsertUpdateGlobalEntityValue] @GlobalEntityValueXml= '+CAST(@GlobalEntityValueXml AS VARCHAR(max))+',@UserId = '+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
			 ROLLBACK TRAN A;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_InsertUpdateGlobalEntityValue',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
go
update ZnodeMenu set MenuSequence = 2 where ParentMenuId = (select Top 1 MenuId from  ZnodeMenu where MenuName = 'CMS') and MenuName = 'Widgets'
go
if exists(select * from sys.procedures where name ='Znode_DeleteAssociatedVariants')
	drop proc Znode_DeleteAssociatedVariants
go

CREATE PROCEDURE [dbo].[Znode_DeleteAssociatedVariants]
(@WidgetProfileVariantId  INT,
@status  BIT OUT)


AS

BEGIN
		BEGIN TRY
			 BEGIN TRAN DeleteAssociatedVariants
			
			DECLARE @DefaultId INT
			DECLARE @widgetId INT, @localeId INT, @profileId INT, @count INT
			SELECT TOP 1 @DefaultId  = LocaleId FROM ZnodeLocale WHERE IsDefault = 1

			SELECT TOP 1 @widgetId = CMSContentWidgetId,@localeId = LocaleId, @profileId = ProfileId  FROM ZnodeCMSWidgetProfileVariant 
			WHERE CMSWidgetProfileVariantId = @WidgetProfileVariantId

			 IF(@localeId = @DefaultId)
				 BEGIN
						SET @Status = 0;
						SELECT 1 AS ID,
						CAST(0 AS BIT) AS [Status];
				 End
			 
			 ELSE
				 BEGIN
						DELETE  L FROM ZnodeWidgetGlobalAttributeValueLocale L	
								inner join ZnodeWidgetGlobalAttributeValue V ON
								L.WidgetGlobalAttributeValueId = V.WidgetGlobalAttributeValueId
								WHERE V.CMSWidgetProfileVariantId = @WidgetProfileVariantId 

						DELETE  ZnodeWidgetGlobalAttributeValue WHERE CMSWidgetProfileVariantId = @WidgetProfileVariantId 

						DELETE  ZnodeCMSWidgetProfileVariant WHERE CMSWidgetProfileVariantId = @WidgetProfileVariantId 

						SET @Status = 1;
						SELECT 1 AS ID,
						CAST(1 AS BIT) AS [Status];
				 end			
		
             COMMIT TRAN DeleteAssociatedVariants;
		END TRY

		BEGIN CATCH

             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			 @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteAssociatedVariants 
			 @WidgetProfileVariantId = '+@WidgetProfileVariantId+',@Status='+CAST(@Status AS VARCHAR(50));

			 SET @Status =0  
			 SELECT 1 AS ID,@Status AS Status;  
             ROLLBACK TRAN DeleteAttributeFamily;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_DeleteAssociatedVariants',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
	       
		END CATCH

END
go
insert into ZnodePimAttributegroupmapper
select PimAttributeGroupId,PimAttributeId, null,0,2,getdate(),2,getdate()
from ZnodePimAttributeGroup PAG 
inner join ZnodePimAttribute ZPA on  GroupCode ='ShippingSettings'and attributecode = 'FreeShipping'
where not exists (select top 1 1 from ZnodePimAttributegroupmapper ZPAG where ZPAG.PimAttributeGroupId = PAG.PimAttributeGroupId and ZPA.PimAttributeId = ZPAG.PimAttributeId)

insert into ZnodePimFamilyGroupMapper
select PimAttributeFamilyId, PimAttributeGroupId,PimAttributeId, 500,0,2,getdate(),2,getdate()
from ZnodePimAttributeFamily ZAF 
inner join ZnodePimAttributeGroup PAG  on  GroupCode ='ShippingSettings'
inner join ZnodePimAttribute ZPA on   attributecode = 'FreeShipping'
where not exists (select top 1 1 from ZnodePimFamilyGroupMapper ZPAG where ZPAG.PimAttributeFamilyId = ZAF.PimAttributeFamilyId and ZPAG.PimAttributeGroupId = PAG.PimAttributeGroupId and ZPA.PimAttributeId= ZPAG.PimAttributeId)

update ZnodePimAttributeGroupMapper set IsSystemDefined = 1
where PimAttributeId = (select top 1 PimAttributeId from znodePimAttribute where AttributeCode = 'FreeShipping' and IsSystemDefined = 1)
and isnull(IsSystemDefined,0) = 0

update ZnodePimFamilyGroupMapper set IsSystemDefined = 1
where PimAttributeId = (select top 1 PimAttributeId from znodePimAttribute where AttributeCode = 'FreeShipping' and IsSystemDefined = 1)
and isnull(IsSystemDefined,0) = 0
go
IF OBJECT_ID('tempdb..#inputdata') IS NOT NULL 
	DROP TABLE #inputdata
create table #inputdata  (product varchar(500), code varchar(100), datavalue varchar(max));
insert into #inputdata (product,code,datavalue) values
('Apple iPhone 11 (128GB) - Black','LongDescription',N'<ul class="a-unordered-list a-vertical a-spacing-mini" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">6.1-inch (15.5 cm) Liquid Retina HD LCD display</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Water and dust resistant (2 meters for up to 30 minutes, IP68)</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Dual-camera system with 12MP Ultra Wide and Wide cameras; Night mode, Portrait mode, and 4K video up to 60fps</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">12MP TrueDepth front camera with Portrait mode, 4K video, and Slo-Mo</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Face ID for secure authentication and Apple Pay</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">A13 Bionic chip with third-generation Neural Engine</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Fast-charge capable</span></li> </ul> <div class="a-row a-expander-container a-expander-inline-container" style="box-sizing: border-box; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <div class="a-expander-content a-expander-extend-content a-expander-content-expanded" style="box-sizing: border-box; overflow: hidden;"> <ul class="a-unordered-list a-vertical a-spacing-none" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Wireless charging</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">iOS13 with Dark Mode, new tools for editing photos and video, and brand new privacy features</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Manufacturer Detail: 1. One Apple Park Way, Cupertino, California 95014, USA,</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Importer: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Country of Origin: China</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Packer Details: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> </ul> </div> </div>')
insert into #inputdata(product,code,datavalue) values
('Apple iPhone 11 (128GB) - Black','ShortDescription',N'<div id="unifiedPrice_feature_div" class="feature" style="box-sizing: border-box; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;" data-feature-name="unifiedPrice" data-cel-widget="unifiedPrice_feature_div"> <div id="price" class="a-section a-spacing-small" style="box-sizing: border-box; margin-bottom: 0px;"> <table class="a-lineitem" style="border-collapse: collapse; width: 698px; margin-bottom: 0px !important;"> <tbody style="box-sizing: border-box;"> <tr id="priceblock_ourprice_row" style="box-sizing: border-box;"> <td id="priceblock_ourprice_lbl" class="a-color-secondary a-size-base a-text-right a-nowrap" style="box-sizing: border-box; vertical-align: top; padding: 0px 3px 0px 0px; font-size: 13px !important; line-height: 19px !important; color: #565959 !important; text-align: right !important; white-space: nowrap;">Price:</td> <td class="a-span12" style="box-sizing: border-box; vertical-align: top; padding: 0px 0px 0px 3px; width: 663px; margin-right: 0px; float: none !important;"><span id="ourprice_shippingmessage" style="box-sizing: border-box;"><span id="price-shipping-message" class="a-size-base a-color-base" style="box-sizing: border-box; font-size: 13px !important; line-height: 19px !important;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">FREE Delivery</span></span></span></td> </tr> <tr id="vatMessage" style="box-sizing: border-box;"> <td style="box-sizing: border-box; vertical-align: top; padding: 0px 3px 0px 0px;">&nbsp;</td> <td style="box-sizing: border-box; vertical-align: top; padding: 0px 0px 0px 3px;"><span class="a-size-base" style="box-sizing: border-box; font-size: 13px !important; line-height: 19px !important;">Inclusive of all taxes</span></td> </tr> </tbody> </table> </div> </div> <div id="dynamicDeliveryMessage_feature_div" class="feature" style="box-sizing: border-box; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;" data-feature-name="dynamicDeliveryMessage" data-cel-widget="dynamicDeliveryMessage_feature_div"> <div id="dynamicDeliveryMessage" class="a-section a-spacing-mini a-spacing-top-mini" style="box-sizing: border-box; margin-bottom: 22px; margin-top: 0px !important; padding-top: 6px;"> <div id="ddmDeliveryMessage" class="a-section a-spacing-mini" style="box-sizing: border-box; margin-bottom: 0px;">Delivery by:&nbsp;<span style="box-sizing: border-box; font-weight: bold;">Friday, Aug 2</span></div> <div class="a-section a-spacing-mini" style="box-sizing: border-box; margin-bottom: 0px;">&nbsp;</div> <div class="a-section a-spacing-mini" style="box-sizing: border-box; margin-bottom: 0px;"> <ul class="a-unordered-list a-vertical a-spacing-mini" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">6.1-inch (15.5 cm) Liquid Retina HD LCD display</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Water and dust resistant (2 meters for up to 30 minutes, IP68)</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Dual-camera system with 12MP Ultra Wide and Wide cameras; Night mode, Portrait mode, and 4K video up to 60fps</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">12MP TrueDepth front camera with Portrait mode, 4K video, and Slo-Mo</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Face ID for secure authentication and Apple Pay</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">A13 Bionic chip with third-generation Neural Engine</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Fast-charge capable</span></li> </ul> <div class="a-row a-expander-container a-expander-inline-container" style="box-sizing: border-box; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <div class="a-expander-content a-expander-extend-content a-expander-content-expanded" style="box-sizing: border-box; overflow: hidden;"> <ul class="a-unordered-list a-vertical a-spacing-none" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Wireless charging</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">iOS13 with Dark Mode, new tools for editing photos and video, and brand new privacy features</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Manufacturer Detail: 1. One Apple Park Way, Cupertino, California 95014, USA,</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Importer: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Country of Origin: China</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Packer Details: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> </ul> </div> </div> </div> </div> </div>')
insert into #inputdata(product,code,datavalue) values
('Apple iPhone 11 (128GB) - Black','ProductSpecification','<ul class="a-unordered-list a-vertical a-spacing-mini" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"> <div id="sopp-btf-title" class="a-section a-spacing-mini sopp-offer-title" style="box-sizing: border-box; margin-bottom: 0px; color: #b12704; font-size: 16px;">Save Extra with 5 offers</div> <ul class="a-unordered-list a-vertical a-spacing-small" style="box-sizing: border-box; margin: 0px 0px 0px 18px; padding: 0px;"> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-instant-bank-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Bank Offer (2):&nbsp;</span>Flat INR 5000 instant discount with HDFC Bank Credit Card, Credit/Debit EMI transactions and Flat INR 1500 on HDFC Bank Debit Card.</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Get 5% up to Rs. 1200 Instant Discount on Citibank Credit Card EMI transactions&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-emi-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">No Cost EMI:&nbsp;</span>No cost EMI available on select cards. Please check ''EMI options'' above for more details&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-buyback-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Exchange Offer:&nbsp;</span>Up to ?&nbsp;11,200.00 off on Exchange</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-cartLevel-cashBack-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Cashback:&nbsp;</span>Get daily rewards up to ?100 on shopping with Amazon Pay UPI</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-seller-promotion-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Partner Offers (4):&nbsp;</span>Get FLAT 5% BACK with&nbsp;for Prime members. Flat 3% BACK for non-Prime members.&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Buy now &amp; pay next month at 0% interest or pay in EMIs with Amazon Pay Later. Instant credit upto ?20,000.&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Avail EMI on Debit Cards. Get credit up to ?1,00,000.&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Get GST invoice and save up to 28% on business purchases.<a style="box-sizing: border-box; color: #0066c0;" href="https://www.amazon.in/gp/b/ref=apay_upi_sopp?node=16179244031">&nbsp;</a></span></li> </ul> </li> </ul>')

insert into #inputdata(product,code,datavalue) values
('Apple iPhone 11 (64GB) - (Product) RED','LongDescription','<table class="a-lineitem" style="border-collapse: collapse; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px; margin-bottom: 0px !important;"> <tbody style="box-sizing: border-box;"> <tr id="priceblock_ourprice_row" style="box-sizing: border-box;"> <td id="priceblock_ourprice_lbl" class="a-color-secondary a-size-base a-text-right a-nowrap" style="box-sizing: border-box; vertical-align: top; padding: 0px 3px 0px 0px; font-size: 13px !important; line-height: 19px !important; color: #565959 !important; text-align: right !important; white-space: nowrap;">Price:</td> <td class="a-span12" style="box-sizing: border-box; vertical-align: top; padding: 0px 0px 0px 3px; width: 663px; margin-right: 0px; float: none !important;"> <p><span id="priceblock_ourprice" class="a-size-medium a-color-price priceBlockBuyingPriceString" style="box-sizing: border-box; font-size: 17px !important; line-height: 1.255 !important; text-rendering: optimizelegibility; color: #b12704 !important;">?&nbsp;68,300.00</span>&nbsp;</p> <p><span id="ourprice_shippingmessage" style="box-sizing: border-box;"><span id="price-shipping-message" class="a-size-base a-color-base" style="box-sizing: border-box; font-size: 13px !important; line-height: 19px !important;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">FREE Delivery</span>.&nbsp;<a style="box-sizing: border-box; color: #0066c0;" href="https://www.amazon.in/gp/help/customer/display.html?ie=UTF8&amp;pop-up=1&amp;nodeId=200904360" target="AmazonHelp">Details</a></span></span></p> </td> </tr> <tr id="vatMessage" style="box-sizing: border-box;"> <td style="box-sizing: border-box; vertical-align: top; padding: 0px 3px 0px 0px;">&nbsp;</td> <td style="box-sizing: border-box; vertical-align: top; padding: 0px 0px 0px 3px;"><span class="a-size-base" style="box-sizing: border-box; font-size: 13px !important; line-height: 19px !important;">Inclusive of all taxes</span></td> </tr> </tbody> </table> <p>&nbsp;</p> <ul class="a-unordered-list a-vertical a-spacing-mini" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">6.1-inch (15.5 cm) Liquid Retina HD LCD display</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Water and dust resistant (2 meters for up to 30 minutes, IP68)</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Dual-camera system with 12MP Ultra Wide and Wide cameras; Night mode, Portrait mode, and 4K video up to 60fps</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">12MP TrueDepth front camera with Portrait mode, 4K video, and Slo-Mo</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Face ID for secure authentication and Apple Pay</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">A13 Bionic chip with third-generation Neural Engine</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Fast-charge capable</span></li> </ul> <div class="a-row a-expander-container a-expander-inline-container" style="box-sizing: border-box; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <div class="a-expander-content a-expander-extend-content a-expander-content-expanded" style="box-sizing: border-box; overflow: hidden;"> <ul class="a-unordered-list a-vertical a-spacing-none" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Wireless charging</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">iOS13 with Dark Mode, new tools for editing photos and video, and brand new privacy features</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Manufacturer Detail: 1. One Apple Park Way, Cupertino, California 95014, USA,</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Importer: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Country of Origin: China</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Packer Details: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> </ul> </div> </div>')
insert into #inputdata(product,code,datavalue) values
('Apple iPhone 11 (64GB) - (Product) RED','ShortDescription','<ul class="a-unordered-list a-vertical a-spacing-mini" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">6.1-inch (15.5 cm) Liquid Retina HD LCD display</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Water and dust resistant (2 meters for up to 30 minutes, IP68)</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Dual-camera system with 12MP Ultra Wide and Wide cameras; Night mode, Portrait mode, and 4K video up to 60fps</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">12MP TrueDepth front camera with Portrait mode, 4K video, and Slo-Mo</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Face ID for secure authentication and Apple Pay</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">A13 Bionic chip with third-generation Neural Engine</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Fast-charge capable</span></li> </ul> <div class="a-row a-expander-container a-expander-inline-container" style="box-sizing: border-box; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <div class="a-expander-content a-expander-extend-content a-expander-content-expanded" style="box-sizing: border-box; overflow: hidden;"> <ul class="a-unordered-list a-vertical a-spacing-none" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px;"> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Wireless charging</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">iOS13 with Dark Mode, new tools for editing photos and video, and brand new privacy features</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Manufacturer Detail: 1. One Apple Park Way, Cupertino, California 95014, USA,</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Importer: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Country of Origin: China</span></li> <li style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Packer Details: Apple India Private Limited No,24, 19th floor, Concorde Tower C, UB City, Vittal Mallya Road, Bangalore-560 002</span></li> </ul> </div> </div>')
insert into #inputdata(product,code,datavalue) values
('Apple iPhone 11 (64GB) - (Product) RED','ProductSpecification','<div id="sopp-btf-title" class="a-section a-spacing-mini sopp-offer-title" style="box-sizing: border-box; margin-bottom: 0px; color: #b12704; font-size: 16px;">Save Extra with 5 offers</div> <ul class="a-unordered-list a-vertical a-spacing-small" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #111111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 13px;"> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-instant-bank-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Bank Offer (2):&nbsp;</span>Flat INR 5000 instant discount with HDFC Bank Credit Card, Credit/Debit EMI transactions and Flat INR 1500 on HDFC Bank Debit Card.</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Get 5% up to Rs. 1200 Instant Discount on Citibank Credit Card EMI transactions&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-emi-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">No Cost EMI:&nbsp;</span>No cost EMI available on select cards. Please check ''EMI options'' above for more details&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-buyback-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Exchange Offer:&nbsp;</span>Up to ?&nbsp;11,200.00 off on Exchange</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-cartLevel-cashBack-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Cashback:&nbsp;</span>Get daily rewards up to ?100 on shopping with Amazon Pay UPI.</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;"><span id="sopp-seller-promotion-label" class="sopp-offer-title" style="box-sizing: border-box; color: #b12704; font-weight: bold;">Partner Offers (4):&nbsp;</span>Get FLAT 5% BACK with&nbsp;&nbsp;for Prime members. Flat 3% BACK for non-Prime members.&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Buy now &amp; pay next month at 0% interest or pay in EMIs with Amazon Pay Later. Instant credit upto ?20,000.&nbsp;</span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Avail EMI on Debit Cards. Get credit up to ?1,00,000.&nbsp;<span id="sopp-tc-modal" class="a-declarative" style="box-sizing: border-box;" data-action="a-modal" data-a-modal="{"></span></span></li> <li class="a-spacing-small a-spacing-top-small" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Get GST invoice and save up to 28% on business purchases.<a style="box-sizing: border-box; color: #0066c0;" href="https://www.amazon.in/gp/b/ref=apay_upi_sopp?node=16179244031">&nbsp;</a><span style="box-sizing: border-box;"><span id="sopp-tc-modal" class="a-declarative" style="box-sizing: border-box;" data-action="a-modal" data-a-modal="{"><a class="a-popover-trigger a-declarative" style="box-sizing: border-box; color: #0066c0;">how&nbsp;</a></span></span></span></li> </ul>')


alter table #inputdata add pimprodid int

update #inputdata
set pimprodid =asd.PimProductId
from ( 
select ZPAVL.AttributeValue,PimProductId,ZPA.PimAttributeValueId,ZPA.PimAttributeId from ZnodePimAttributeValue ZPA
inner join znodepimattributevaluelocale ZPAVL on ZPAVL.PimAttributeValueId = ZPA.PimAttributeValueId
where PimAttributeId in (select PimAttributeId from ZnodePimAttribute where  AttributeCode ='SKU') )asd
where asd.AttributeValue = #inputdata.product


update ZnodePimProductAttributeTextAreaValue
set AttributeValue = datavalue
from (
select * from #inputdata a
inner join (select PimAttributeValueId,ZPA.AttributeCode,PimProductId from ZnodePimAttribute ZPA inner join  
ZnodePimAttributeValue ZPAV on ZPA.PimAttributeId = ZPAV.PimAttributeId
where ZPA.AttributeCode in(
'ProductSpecification',
'LongDescription',
'ShortDescription') and ZPA.IsCategory = 0
and PimProductId in (select PimProductId from ZnodePimAttributeValue ZPA
inner join znodepimattributevaluelocale ZPAVL on ZPAVL.PimAttributeValueId = ZPA.PimAttributeValueId
where PimAttributeId in (select PimAttributeId from ZnodePimAttribute where  AttributeCode ='SKU') 
and 
ZPAVL.AttributeValue in ('Apple iPhone 11 (128GB) - Black','Apple iPhone 11 (64GB) - (Product) RED'))
) b on a.code=b.AttributeCode and a.pimprodid =b.PimProductId)def
where ZnodePimProductAttributeTextAreaValue.PimAttributeValueId = def.PimAttributeValueId
go
if exists(select * from sys.procedures where name ='Znode_DeletePimCategory')
	drop proc Znode_DeletePimCategory
go

CREATE PROCEDURE [dbo].[Znode_DeletePimCategory](
       @PimCategoryIds VARCHAR(500)= '' ,
       @Status         BIT OUT,
	   @PimCategoryId TransferId READONLY  
	   )
AS
/*
Summary: This Procedure is used to delete PimCategory with their reference details from respective tables
Unit Testing:
	Declare @status bit 
	EXEC [Znode_DeletePimCategory]  16,@status =@status 
	Select @status 
 Alter table ZnodePublishCategory Drop Constraint FK_ZnodePublishCategory_ZnodePimCategory
*/
     BEGIN
         BEGIN TRAN;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @FinalCount INT = 0 
             DECLARE @CategoryIds TABLE (
                                        PimCategoryId INT
                                        );
             INSERT INTO @CategoryIds
                    SELECT item
                    FROM dbo.Split ( @PimCategoryIds , ','
                                   )
								   WHERE @PimCategoryIds <> '' ;
			 INSERT INTO @CategoryIds
			 SELECT  Id 
			 FROM @PimCategoryId
			  
             DECLARE @V_CategorryCount INT;
             DECLARE @DeletePimCategoryId TABLE (
                                                PimCategoryId               INT ,
                                                PimCategoryAttributeValueId INT
                                                );
             INSERT INTO @DeletePimCategoryId
                    SELECT a.PimCategoryId , c.PimCategoryAttributeValueId
                    FROM [dbo].ZnodePimCategory AS a 
                                                     INNER JOIN @CategoryIds AS b ON ( a.PimCategoryId = b.PimCategoryId )
										   LEFT OUTER JOIN ZnodePimCategoryAttributeValue AS c ON ( a.PimCategoryId = c.PimCategoryId )

             SELECT @V_CategorryCount = COUNT(1)
             FROM ( SELECT PimCategoryId
                    FROM @DeletePimCategoryId
                    GROUP BY PimCategoryId
                  ) AS a;

		   DELETE FROM ZnodePimCategoryHierarchy WHERE EXISTS (SELECT TOP 1 1 FROM @DeletePimCategoryId DPCI  where DPCI.PimCategoryId = ZnodePimCategoryHierarchy.PimCategoryId )
		
			DELETE FROM ZnodeCMSSEODetaillocale
				where CMSSEODetailId in (
				select CMSSEODetailId from ZnodeCMSSEODetail where SEOCode in (
				select CategoryValue from ZnodePimCategoryAttributeValueLocale where PimCategoryAttributeValueId in
				(select a.PimCategoryAttributeValueId from ZnodePimCategoryAttributeValue a inner join @DeletePimCategoryId AS b on a. PimCategoryId = b.PimCategoryId 
				where PimAttributeId in (select PimAttributeId from ZnodePimAttribute where IsCategory = 1 and AttributeCode ='CategoryCode')
				)))



			DELETE FROM ZnodeCMSSEODetail where SEOCode in (
						select CategoryValue from ZnodePimCategoryAttributeValueLocale where PimCategoryAttributeValueId in
						(select a.PimCategoryAttributeValueId from ZnodePimCategoryAttributeValue a inner join @DeletePimCategoryId AS b on a. PimCategoryId = b.PimCategoryId 
						where PimAttributeId in (select PimAttributeId from ZnodePimAttribute where IsCategory = 1 and AttributeCode ='CategoryCode')
						))

             DELETE FROM ZnodePimCategoryAttributeValueLocale
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @DeletePimCategoryId AS b
                            WHERE b.PimCategoryAttributeValueId = ZnodePimCategoryAttributeValueLocale.PimCategoryAttributeValueId
                          );
             DELETE FROM ZnodePimCategoryAttributeValue
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @DeletePimCategoryId AS b
                            WHERE b.PimCategoryAttributeValueId = ZnodePimCategoryAttributeValue.PimCategoryAttributeValueId
                          );
             DELETE FROM ZnodePimCategoryProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @DeletePimCategoryId AS b
                            WHERE b.PimCategoryId = ZnodePimCategoryProduct.PimCategoryId
                          );

             DELETE FROM ZnodePimCategory
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @DeletePimCategoryId AS b
                            WHERE b.PimCategoryId = ZnodePimCategory.PimCategoryId
                          );

             SET @Status = 1;
             IF ( SELECT COUNT(1)
                  FROM @CategoryIds
                ) = @V_CategorryCount
                 BEGIN
                     SELECT 1 AS ID , CAST(1 AS BIT) AS Status;
                 END;
             ELSE
                 BEGIN
                     SELECT 0 AS ID , CAST(0 AS BIT) AS Status;
                 END;
             COMMIT TRAN;
         END TRY
         BEGIN CATCH
                        
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeletePimCategory @PimCategoryIds = '+@PimCategoryIds+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status,ERROR_MESSAGE();                    
		     ROLLBACK TRAN;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_DeletePimCategory',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
go
if exists(select * from sys.procedures where name ='Znode_ImportInventory_Ver1')
	drop proc Znode_ImportInventory_Ver1
go


CREATE PROCEDURE [dbo].[Znode_ImportInventory_Ver1](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200))
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import Inventory data 
	--		   Input data in XML format Validate data with all scenario 
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
		DECLARE @RoundOffValue int, @MessageDisplay nvarchar(100), @MessageDisplayForFloat nvarchar(100);
		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive RoundOff Value from global setting 
		SELECT @RoundOffValue = FeatureValues
		FROM ZnodeGlobalSetting
		WHERE FeatureName = 'InventoryRoundOff';
		
		IF OBJECT_ID('tempdb.dbo.#InserInventoryForValidation', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.#InserInventoryForValidation
		
		IF OBJECT_ID('tempdb.dbo.#InsertInventory ', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.#InsertInventory 

		--@MessageDisplay will use to display validate message for input inventory value  

		DECLARE @sSql nvarchar(max);
		SET @sSql = ' Select @MessageDisplay_new = Convert(Numeric(28, '+CONVERT(nvarchar(200), @RoundOffValue)+'), 123.12345699 ) ';
		EXEC SP_EXecutesql @sSql, N'@MessageDisplay_new NVARCHAR(100) OUT', @MessageDisplay_new = @MessageDisplay OUT;
		SET @sSql = ' Select @MessageDisplay_new = Convert(Numeric(28, '+CONVERT(nvarchar(200), @RoundOffValue)+'), 0.999999 ) ';
		EXEC SP_EXecutesql @sSql, N'@MessageDisplay_new NVARCHAR(100) OUT', @MessageDisplay_new = @MessageDisplayForFloat OUT;
		Create TABLE tempdb..#InserInventoryForValidation 
		( 
				RowNumber int, SKU varchar(600), Quantity varchar(100), ReOrderLevel varchar(100), WarehouseCode varchar(300), GUID nvarchar(200)
		);

		CREATE INDEX IDX_#InserInventoryForValidation_SKU ON #InserInventoryForValidation(SKU)
		
		DECLARE @InventoryListId int;
		SET @SSQL = 'Select RowNumber,SKU,Quantity,ReOrderLevel,WarehouseCode ,GUID FROM '+@TableName;
		INSERT INTO tempdb..#InserInventoryForValidation( RowNumber, SKU, Quantity, ReOrderLevel, WarehouseCode, GUID )
		EXEC sys.sp_sqlexec @SSQL;
		

		UPDATE tempdb..#InserInventoryForValidation
		  SET ReOrderLevel = 0
		WHERE ISNULL(ReOrderLevel,'') = '';

		-- start Functional Validation 
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		FROM tempdb..#InserInventoryForValidation  AS ii
		WHERE NOT EXISTS( SELECT * FROM ZnodePimAttributeValue  AS a with(nolock)
			INNER JOIN ZnodePimAttributeValueLocale AS b with(nolock) ON a.PimAttributeValueId = b.PimAttributeValueId
			WHERE exists(Select top 1 PimAttributeId from ZnodePimAttribute zpa Where zpa.AttributeCode = 'SKU' and a.PimAttributeId = zpa.PimAttributeId)
			AND b.AttributeValue = ii.SKU);

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		SELECT '19', 'WarehouseCode', WarehouseCode, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		FROM tempdb..#InserInventoryForValidation  AS ii
		WHERE NOT EXISTS ( SELECT TOP 1 1 FROM ZnodeWarehouse AS zw WHERE zw.WarehouseCode = ii.WarehouseCode );

		UPDATE ZIL SET ZIL.ColumnName =   ZIL.ColumnName + ' [ SKU - ' + ISNULL(SKU,'') + ' ] '
		FROM ZnodeImportLog ZIL 
		INNER JOIN #InserInventoryForValidation IPA ON (ZIL.RowNumber = IPA.RowNumber)
		WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL

		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  
		DELETE FROM tempdb..#InserInventoryForValidation 
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  GUID = @NewGUID
		);
		
		DECLARE @TBL_ReadyToInsertInventory TABLE
		( 
			RowNumber int, SKU varchar(300), Quantity numeric(28, 6), ReOrderLevel numeric(28, 6), WarehouseId int
		);

		--deleting duplicate rows
		delete  ii
		FROM tempdb..#InserInventoryForValidation  ii
		where ii.RowNumber not IN
			   (
				   SELECT MAX(ii1.RowNumber)
				   FROM tempdb..#InserInventoryForValidation  AS ii1
				   WHERE ii1.WarehouseCode = ii.WarehouseCode AND 
						 ii1.SKU = ii.SKU
			   );

		-- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM #InserInventoryForValidation
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount,
		TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0)) 
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End
		   	
		
		--select 'update started'  
		UPDATE zi SET Quantity = rtii.Quantity, ReOrderLevel = ISNULL(rtii.ReOrderLevel, 0), ModifiedBy = @UserId, ModifiedDate = @GetDate
		FROM ZNodeInventory zi
		INNER JOIN #InserInventoryForValidation rtii ON( zi.SKU = rtii.SKU )
		INNER JOIN ZnodeWarehouse AS zw ON rtii.WarehouseCode = zw.WarehouseCode and zi.WarehouseId = zw.WarehouseId;
			   
		--select 'update End'                
		INSERT INTO ZnodeInventory( WarehouseId, SKU, Quantity, ReOrderLevel, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
		SELECT zw.WarehouseId, SKU, Quantity, ISNULL(ReOrderLevel, 0), @UserId, @GetDate, @UserId, @GetDate
		FROM #InserInventoryForValidation AS rtii
		INNER JOIN ZnodeWarehouse AS zw on rtii.WarehouseCode = zw.WarehouseCode
		WHERE NOT EXISTS ( SELECT TOP 1 1 FROM ZnodeInventory AS zi WHERE zi.WarehouseId = zw.WarehouseId AND zi.SKU = rtii.SKU );
		 
		--select 'End'
		--      SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = GETDATE()
		WHERE ImportProcessLogId = @ImportProcessLogId;

		COMMIT TRAN A;
	END TRY
	BEGIN CATCH

		SET @Status = 0;
		SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE();
		ROLLBACK TRAN A;
	END CATCH;
END;
go
if exists(select * from sys.procedures where name ='Znode_GetHighlightDetail')
	drop proc Znode_GetHighlightDetail
go

CREATE PROCEDURE [dbo].[Znode_GetHighlightDetail]
( @WhereClause nvarchar(max),
 @Rows int= 10,
 @PageNo int= 1,
 @Order_BY varchar(1000)= '',
 @RowsCount int= 0 OUT,
 @LocaleId int= 1,
      @IsAssociated bit= 0,
      @Isdebug bit= 0)
AS
/*
Summary :- This Procedure is used to get the highlights details
Unit Testing
begin tran
EXEC Znode_GetHighlightDetail '',10,1,'',0,1,0
rollback tran

*/
BEGIN
BEGIN TRY
SET NOCOUNT ON;

DECLARE @DefaultLocaleId int= dbo.Fn_GetDefaultLocaleId();
DECLARE @SeoId varchar(max)= '', @SQL nvarchar(max);
DECLARE @TBL_HighlightsDetails TABLE
(
Description nvarchar(max),
HighlightId int,
HighlightCode varchar(600),
HighlightType NVARCHAR(400),
DisplayOrder int,
IsActive bit,
HighlightLocaleId int,
MediaPath nvarchar(max),
MediaId int,
Hyperlink nvarchar(max),
ImageAltTag NVARCHAR(4000),DisplayPopup BIT
);
--Get default attributeid for ProductHighlights
DECLARE @AttributeId int= [dbo].[Fn_GetProductHighlightsAttributeId]();
DECLARE @TBL_AttributeDefault TABLE
(
PimAttributeId int,
AttributeDefaultValueCode varchar(600),
IsEditable bit,
AttributeDefaultValue nvarchar(max),
DisplayOrder INT
);
   DECLARE @TBL_HighlightsDetail TABLE
(
Description nvarchar(max),
HighlightId int,
HighlightCode varchar(600),
HighlightType NVARCHAR(400),
DisplayOrder int,
IsActive bit,
HighlightLocaleId int,
MediaPath nvarchar(max),
MediaId int,
Hyperlink nvarchar(max),
ImageAltTag NVARCHAR(4000),DisplayPopup BIT,
HighlightName nvarchar(max),
RowId int,
CountId int
);


INSERT INTO @TBL_AttributeDefault
EXEC Znode_GetAttributeDefaultValueLocale @AttributeId, @LocaleId;

SET @WhereClause = ' '+@WhereClause+CASE
WHEN @IsAssociated = 1 THEN CASE
WHEN @WhereClause = '' THEN ' '
ELSE ' AND '
END+' EXISTS ( SELECT TOP 1 1
FROM ZnodePimAttributeValue ZAV
INNER JOIN ZnodePimAttribute ZA ON (ZA.PimAttributeId = ZAV.PimAttributeId AND ZA.AttributeCode = ''Highlights'')
       INNER JOIN ZnodePimProductAttributeDefaultValue ZAVL ON (ZAV.PimAttributeValueId= ZAVL.PimAttributeValueId )
WHERE ( ZAVL.AttributeValue = TMADV.AttributeDefaultValueCode))'
ELSE CASE
WHEN @WhereClause = '' THEN ' 1 = 1  '
ELSE ''
END
END;

WITH Cte_GetHighlightsBothLocale
AS (SELECT Row_Number()Over( PARTITION BY   ZH.HighlightCode ORDER BY ZADV.MediaId desc) RowId, ZHL.Description, ZH.HighlightId, LocaleId, ZH.HighlightCode,ZPHT.Name HighlightType , ZADV.DisplayOrder, ZH.IsActive, ZHL.HighlightLocaleId, [dbo].[Fn_GetMediaThumbnailMediaPath]( Zm.path ) AS MediaPath
, ZADV.MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM ZnodeHighlight AS ZH
 left Join ZnodePimAttributeDefaultValue ZADV on ZADV.AttributeDefaultValueCode =ZH.HighlightCode
 left JOIN  ZnodeHighlightLocale AS ZHL ON(ZHL.HighlightId = ZH.HighlightId)  
 left JOIN ZnodeMedia AS ZM ON(ZM.MediaId = ZH.MediaId)
 left JOIN ZnodeHighLightType ZPHT ON (ZPHT.HighlightTypeId = ZH.HighlightTypeId)  
WHERE LocaleId IN( @LocaleId, @DefaultLocaleId )
   ),

Cte_HighlightsFirstLocale
AS (SELECT Description, HighlightId, LocaleId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath
          , MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_GetHighlightsBothLocale AS CTGBBL
WHERE LocaleId = @LocaleId and RowId = 1),

Cte_HighlightsDefaultLocale
AS (
SELECT Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath
           , MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_HighlightsFirstLocale
UNION ALL
SELECT Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath
            , MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_GetHighlightsBothLocale AS CTBBL
WHERE LocaleId = @DefaultLocaleId and RowId = 1 AND
  NOT EXISTS
(
SELECT TOP 1 1
FROM Cte_HighlightsFirstLocale AS CTBFL
WHERE CTBBL.HighlightId = CTBFL.HighlightId
))


INSERT INTO @TBL_HighlightsDetails( Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup )
SELECT Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_HighlightsDefaultLocale AS CTEBD;


SELECT TBBD.*, TBAD.AttributeDefaultValue AS HighlightName, TBAD.AttributeDefaultValueCode
INTO #TM_HighlightsLocale
FROM @TBL_HighlightsDetails AS TBBD
INNER JOIN @TBL_AttributeDefault AS TBAD  ON(TBAD.AttributeDefaultValueCode = TBBD.HighlightCode);

SET @SQL = '
           ;With Cte_HighlightsDetails AS
(
SELECT * ,'+[dbo].[Fn_GetPagingRowId]( @Order_BY, 'HighlightId DESC' )+',Count(*)Over() CountId
FROM #TM_HighlightsLocale TMADV
WHERE 1=1
'+[dbo].[Fn_GetFilterWhereClause]( @WhereClause )+'

   )
SELECT Description ,HighlightId , HighlightCode,HighlightType , DisplayOrder  ,IsActive   ,HighlightLocaleId
,MediaPath ,MediaId ,Hyperlink,ImageAltTag,DisplayPopup
   ,HighlightName ,RowId  ,CountId
FROM Cte_HighlightsDetails
'+[dbo].[Fn_GetOrderByClause]( @Order_BY, 'HighlightId DESC' )+' ';

INSERT INTO @TBL_HighlightsDetail( Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup, HighlightName, RowId, CountId )
EXEC (@SQL);

SET @RowsCount = ISNULL(( SELECT TOP 1 CountId FROM @TBL_HighlightsDetail), 0);

SELECT distinct HighlightId, Description, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup, HighlightName
FROM @TBL_HighlightsDetail order by DisplayOrder;
END TRY
BEGIN CATCH
DECLARE @Status BIT ;
    SET @Status = 0;
    DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetHighlightDetail @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
             
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
 
             EXEC Znode_InsertProcedureErrorLog
@ProcedureName = 'Znode_GetHighlightDetail',
@ErrorInProcedure = @Error_procedure,
@ErrorMessage = @ErrorMessage,
@ErrorLine = @ErrorLine,
@ErrorCall = @ErrorCall;
END CATCH;
END;
go
delete from ZnodeListViewFilter where ListViewId in (select ListViewId from ZnodeListView where ApplicationSettingId = 209 and ViewName = 'san')
delete from ZnodeListViewFilter where ListViewId in (select ListViewId from ZnodeListView where ApplicationSettingId = 67 and ViewName = 'New View')
delete from ZnodeListViewFilter where ListViewId in (select ListViewId from ZnodeListView where ApplicationSettingId = 210 and ViewName = 'sdsdsd1')
delete from ZnodeListViewFilter where ListViewId in (select ListViewId from ZnodeListView where ApplicationSettingId = 203 and ViewName = '222')

delete from ZnodeListView where ApplicationSettingId = 209 and ViewName = 'san'
delete from ZnodeListView where ApplicationSettingId = 67 and ViewName = 'New View'
delete from ZnodeListView where ApplicationSettingId = 210 and ViewName = 'sdsdsd1'
delete from ZnodeListView where ApplicationSettingId = 203 and ViewName = '222'
GO
IF EXISTS(SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_DeleteHighlights')
	DROP PROC Znode_DeleteHighlights
GO
CREATE  PROCEDURE [dbo].[Znode_DeleteHighlights] 
	(
       @HighlighId VARCHAR(300) = NULL ,
       @Status         INT OUT)
AS
/*
    Summary:  Remove Highlights with their respective details and from reference tables		   	             
    Unit Testing   
    			
     DECLARE @Status INT 
	 EXEC Znode_DeleteHighlights @HighlighId = 3 ,@Status=@Status OUT  
    */
BEGIN

	BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN A;
             DECLARE @DeletdHighlightId TABLE (
                                              HighlightCode VARCHAR(300)
                                              );

			




             INSERT INTO @DeletdHighlightId
                    SELECT b.HighlightCode
                    FROM dbo.split ( @HighlighId , ','
                                   ) AS a INNER JOIN ZnodeHighlight AS B ON ( a.item = b.HighlightId )


			
update ZPP set PublishStateId = (select top 1 PublishStateId from ZnodePublishState where StateName = 'Draft')
from ZnodePimProduct ZPP
INNER JOIN ZnodePimAttributeValue ZPAV ON ZPP.PimProductId = ZPAV.PimProductId
INNER JOIN ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId
inner join ZnodePimAttributeDefaultValue ZPDV ON ZPPADV.PimAttributeDefaultValueId = ZPDV.PimAttributeDefaultValueId and ZPAV.PimAttributeId = ZPDV.PimAttributeId
INNER JOIN ZnodeHighlight ZHL ON ZPDV.AttributeDefaultValueCode = ZHL.HighlightCode
where ZPDV.PimAttributeId = (select TOP 1 PimAttributeId from ZnodePimAttribute ZPD where AttributeCode = 'Highlights')
and ZHL.HighlightCode in ( select HighlightCode from  @DeletdHighlightId)
              
			  Delete from ZnodePimAttributeDefaultValueLocale
			  where exists (select top 1 1 from ZnodePimAttributeDefaultValue ZD 
								inner join @DeletdHighlightId h on h.HighlightCode =zd.AttributeDefaultValueCode and zd.PimAttributeId = dbo.Fn_GetProductHighlightsAttributeId()
								where zd.PimAttributeDefaultValueId =ZnodePimAttributeDefaultValueLocale.PimAttributeDefaultValueId);
				
	  		 
			Delete from ZnodePimProductAttributeDefaultValue
				where exists (  select top 1 1 from ZnodePimAttributeDefaultValue ZD 
								inner join @DeletdHighlightId h on h.HighlightCode =zd.AttributeDefaultValueCode 
								INNER JOIN ZnodePimAttributeValue za ON zd.PimAttributeDefaultValueId = ZA.PimAttributeDefaultValueId
								where ZA.PimAttributeValueId =ZnodePimProductAttributeDefaultValue.PimAttributeValueId and ZA.PimAttributeDefaultValueId =ZnodePimProductAttributeDefaultValue.PimAttributeDefaultValueId);
  			
			Delete from ZnodePimAttributeValue
			  where exists (select top 1 1 from ZnodePimAttributeDefaultValue ZD 
								inner join @DeletdHighlightId h on h.HighlightCode =zd.AttributeDefaultValueCode and zd.PimAttributeId = dbo.Fn_GetProductHighlightsAttributeId()
								where zd.PimAttributeDefaultValueId =ZnodePimAttributeValue.PimAttributeDefaultValueId)
								and PimAttributeValueId not in ( select PimAttributeValueId from  ZnodePimProductAttributeDefaultValue);
			--Delete from ZnodePimAttributeDefaultValue
			--	where exists (select Top 1 1 from @DeletdHighlightId H where H.HighlightCode= ZnodePimAttributeDefaultValue.AttributeDefaultValueCode
			--			and ZnodePimAttributeDefaultValue.PimAttributeId = dbo.Fn_GetProductHighlightsAttributeId());
  
			Delete from ZnodeHighlightLocale
				where exists (select top 1 1 from @DeletdHighlightId h inner join ZnodeHighlight ZH on h.HighlightCode =ZH.HighlightCode
					where ZH.HighlightId  = ZnodeHighlightLocale.HighlightId);
  
			Delete from ZnodeHighlight
				where exists (select top 1 1 from @DeletdHighlightId h where  h.HighlightCode =ZnodeHighlight.HighlightCode);

			   SET @Status = 1;
             COMMIT TRAN A;
                         
	END TRY
	BEGIN CATCH
			ROLLBACK TRAN A;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteHighlights @HighlighId = '+@HighlighId+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		     
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_DeleteHighlights',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;

				select  ERROR_MESSAGE(),ERROR_LINE()
	END CATCH

   
END
go
if exists(select * from sys.procedures where name = 'Znode_GetAllMedia')
	drop proc Znode_GetAllMedia
go
CREATE PROCEDURE [dbo].[Znode_GetAllMedia]
( @WhereClause VARCHAR(1000), 
  @Order_BY    VARCHAR(1000)  = '',  
  @Rows        INT           = 100,
  @PageNo      INT           = 1, 
  @RowsCount   INT OUT
)
AS
/*  
    Summary: This procedure is used to get Media list   
    Unit Testing:   
    EXEC Znode_GetAllMedia @WhereClause='' ,@Order_BY ='',  @Rows= 10, @PageNo = 1, @RowsCount=0 
*/  
  
BEGIN
	BEGIN TRY
            SET NOCOUNT ON;
            DECLARE @SQL NVARCHAR(MAX);
			DECLARE @TBL_AllMedia TABLE (MediaId INT,MediaConfigurationId INT,Path VARCHAR(300),
										 FileName VARCHAR(300) ,Type NVARCHAR(3000),RowId INT,CountNo INT)  
			
	  SET @SQL = '
	 ;WITH CTE_GetMediaList AS  
      (  
		  SELECT MediaId ,MediaConfigurationId ,Path ,FileName ,Type ,
		  ' + dbo.Fn_GetPagingRowId(@Order_BY,'MediaId ASC')+',Count(*)Over() CountNo   
		  FROM ZnodeMedia  
		  WHERE 1=1 '+ dbo.Fn_GetFilterWhereClause(@WhereClause)+'       
      )  
  
      SELECT MediaId ,MediaConfigurationId ,Path ,FileName ,Type,RowId,CountNo
	  FROM CTE_GetMediaList' + dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)  

   INSERT INTO @TBL_AllMedia  
   EXEC(@SQL)  
  
   SET @RowsCount =ISNULL((SELECT TOP 1 CountNo FROM @TBL_AllMedia ),0)  
     
   SELECT * FROM @TBL_AllMedia  

   END TRY
   BEGIN CATCH
	       DECLARE @Status BIT ;
		    SET @Status = 0;
		    DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(),
				    @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
				    @ErrorLine VARCHAR(100)= ERROR_LINE(),
				    @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetAllMedia @WhereClause = '+ cast (@WhereClause AS VARCHAR(50))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
            SELECT 0 AS ID,CAST(0 AS BIT) AS Status; 
	  
            EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetAllMedia',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END
go
if exists(select * from sys.procedures where NAME = 'Znode_GetHighlightDetail')
	drop proc Znode_GetHighlightDetail
go
CREATE PROCEDURE [dbo].[Znode_GetHighlightDetail]
( @WhereClause nvarchar(max),
 @Rows int= 10,
 @PageNo int= 1,
 @Order_BY varchar(1000)= '',
 @RowsCount int= 0 OUT,
 @LocaleId int= 1,
      @IsAssociated bit= 0,
      @Isdebug bit= 0)
AS
/*
Summary :- This Procedure is used to get the highlights details
Unit Testing
begin tran
EXEC Znode_GetHighlightDetail '',10,1,'',0,1,0
rollback tran

*/
BEGIN
BEGIN TRY
SET NOCOUNT ON;

DECLARE @DefaultLocaleId int= dbo.Fn_GetDefaultLocaleId();
DECLARE @SeoId varchar(max)= '', @SQL nvarchar(max);
DECLARE @TBL_HighlightsDetails TABLE
(
Description nvarchar(max),
HighlightId int,
HighlightCode varchar(600),
HighlightType NVARCHAR(400),
DisplayOrder int,
IsActive bit,
HighlightLocaleId int,
MediaPath nvarchar(max),
MediaId int,
Hyperlink nvarchar(max),
ImageAltTag NVARCHAR(4000),DisplayPopup BIT
);
--Get default attributeid for ProductHighlights
DECLARE @AttributeId int= [dbo].[Fn_GetProductHighlightsAttributeId]();
DECLARE @TBL_AttributeDefault TABLE
(
PimAttributeId int,
AttributeDefaultValueCode varchar(600),
IsEditable bit,
AttributeDefaultValue nvarchar(max),
DisplayOrder INT
);
   DECLARE @TBL_HighlightsDetail TABLE
(
Description nvarchar(max),
HighlightId int,
HighlightCode varchar(600),
HighlightType NVARCHAR(400),
DisplayOrder int,
IsActive bit,
HighlightLocaleId int,
MediaPath nvarchar(max),
MediaId int,
Hyperlink nvarchar(max),
ImageAltTag NVARCHAR(4000),DisplayPopup BIT,
HighlightName nvarchar(max),
RowId int,
CountId int
);


INSERT INTO @TBL_AttributeDefault
EXEC Znode_GetAttributeDefaultValueLocale @AttributeId, @LocaleId;

SET @WhereClause = ' '+@WhereClause+CASE
WHEN @IsAssociated = 1 THEN CASE
WHEN @WhereClause = '' THEN ' '
ELSE ' AND '
END+' EXISTS ( SELECT TOP 1 1
FROM ZnodePimAttributeValue ZAV
INNER JOIN ZnodePimAttribute ZA ON (ZA.PimAttributeId = ZAV.PimAttributeId AND ZA.AttributeCode = ''Highlights'')
       INNER JOIN ZnodePimProductAttributeDefaultValue ZAVL ON (ZAV.PimAttributeValueId= ZAVL.PimAttributeValueId )
WHERE ( ZAVL.AttributeValue = TMADV.AttributeDefaultValueCode))'
ELSE CASE
WHEN @WhereClause = '' THEN ' 1 = 1  '
ELSE ''
END
END;

WITH Cte_GetHighlightsBothLocale
AS (SELECT Row_Number()Over( PARTITION BY   ZH.HighlightCode ORDER BY ZH.MediaId desc) RowId, ZHL.Description, ZH.HighlightId, LocaleId, ZH.HighlightCode,ZPHT.Name HighlightType , ZADV.DisplayOrder, ZH.IsActive, ZHL.HighlightLocaleId, [dbo].[Fn_GetMediaThumbnailMediaPath]( Zm.path ) AS MediaPath
, ZH.MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM ZnodeHighlight AS ZH
 left Join ZnodePimAttributeDefaultValue ZADV on ZADV.AttributeDefaultValueCode =ZH.HighlightCode
 left JOIN  ZnodeHighlightLocale AS ZHL ON(ZHL.HighlightId = ZH.HighlightId)  
 left JOIN ZnodeMedia AS ZM ON(ZM.MediaId = ZH.MediaId)
 left JOIN ZnodeHighLightType ZPHT ON (ZPHT.HighlightTypeId = ZH.HighlightTypeId)  
WHERE LocaleId IN( @LocaleId, @DefaultLocaleId )
   ),

Cte_HighlightsFirstLocale
AS (SELECT Description, HighlightId, LocaleId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath
          , MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_GetHighlightsBothLocale AS CTGBBL
WHERE LocaleId = @LocaleId and RowId = 1),

Cte_HighlightsDefaultLocale
AS (
SELECT Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath
           , MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_HighlightsFirstLocale
UNION ALL
SELECT Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath
            , MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_GetHighlightsBothLocale AS CTBBL
WHERE LocaleId = @DefaultLocaleId and RowId = 1 AND
  NOT EXISTS
(
SELECT TOP 1 1
FROM Cte_HighlightsFirstLocale AS CTBFL
WHERE CTBBL.HighlightId = CTBFL.HighlightId
))


INSERT INTO @TBL_HighlightsDetails( Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup )
SELECT Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup
FROM Cte_HighlightsDefaultLocale AS CTEBD;


SELECT TBBD.*, TBAD.AttributeDefaultValue AS HighlightName, TBAD.AttributeDefaultValueCode
INTO #TM_HighlightsLocale
FROM @TBL_HighlightsDetails AS TBBD
INNER JOIN @TBL_AttributeDefault AS TBAD  ON(TBAD.AttributeDefaultValueCode = TBBD.HighlightCode);

SET @SQL = '
           ;With Cte_HighlightsDetails AS
(
SELECT * ,'+[dbo].[Fn_GetPagingRowId]( @Order_BY, 'HighlightId DESC' )+',Count(*)Over() CountId
FROM #TM_HighlightsLocale TMADV
WHERE 1=1
'+[dbo].[Fn_GetFilterWhereClause]( @WhereClause )+'

   )
SELECT Description ,HighlightId , HighlightCode,HighlightType , DisplayOrder  ,IsActive   ,HighlightLocaleId
,MediaPath ,MediaId ,Hyperlink,ImageAltTag,DisplayPopup
   ,HighlightName ,RowId  ,CountId
FROM Cte_HighlightsDetails
'+[dbo].[Fn_GetOrderByClause]( @Order_BY, 'HighlightId DESC' )+' ';

INSERT INTO @TBL_HighlightsDetail( Description, HighlightId, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup, HighlightName, RowId, CountId )
EXEC (@SQL);

SET @RowsCount = ISNULL(( SELECT TOP 1 CountId FROM @TBL_HighlightsDetail), 0);

SELECT distinct HighlightId, Description, HighlightCode,HighlightType, DisplayOrder, IsActive, HighlightLocaleId, MediaPath, MediaId, Hyperlink,ImageAltTag,DisplayPopup, HighlightName
FROM @TBL_HighlightsDetail order by DisplayOrder;
END TRY
BEGIN CATCH
DECLARE @Status BIT ;
    SET @Status = 0;
    DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetHighlightDetail @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
             
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
 
             EXEC Znode_InsertProcedureErrorLog
@ProcedureName = 'Znode_GetHighlightDetail',
@ErrorInProcedure = @Error_procedure,
@ErrorMessage = @ErrorMessage,
@ErrorLine = @ErrorLine,
@ErrorCall = @ErrorCall;
END CATCH;
END;
go