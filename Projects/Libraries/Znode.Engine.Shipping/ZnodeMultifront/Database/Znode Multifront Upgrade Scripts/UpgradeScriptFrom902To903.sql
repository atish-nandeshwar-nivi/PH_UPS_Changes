/*
 This Script will delete the old portal index beacuse of new catalog index implentation 
  after execution of script once regenrate indexes  


*/
IF EXISTS (SELECT TOP 1 1 FROM Sys.Tables WHERE Name = 'ZnodeMultifront')
BEGIN 
 IF EXISTS (SELECT TOP 1 1 FROM ZnodeMultifront Having Max(BuildVersion) =   902114 )
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
VALUES ( N'Znode_Multifront_9_0_3', N'Upgrade GA Realese by 903', 9, 0, 2, 902114, 0, 2, GETDATE(), 2, GETDATE())
GO 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.Tables WHERE name = 'ZnodePortalIndex')
BEGIN 
ALTER TABLE [dbo].[ZnodePortalIndex] DROP CONSTRAINT [FK_ZnodePortalIndex_ZnodePortal]; 
ALTER TABLE [dbo].[ZnodeSearchIndexMonitor] DROP CONSTRAINT [FK_ZnodeSearchIndexMonitor_ZnodePortalIndex];
DROP TABLE [dbo].[ZnodePortalIndex];
END 
GO 
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE name = 'Znode_GetPublishAssociatedProductsInnerOut')
BEGIN 
DROP PROCEDURE [dbo].[Znode_GetPublishAssociatedProductsInnerOut];
END 
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeAccount' AND COLUMN_NAME = 'PublishCatalogId')
BEGIN 
 ALTER TABLE ZnodeAccount ADD PublishCatalogId INT NULL 

END 
GO
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeBlogNews' AND COLUMN_NAME = 'CMSContentPagesId')
BEGIN 
 ALTER TABLE ZnodeBlogNews ADD  [CMSContentPagesId] INT NuLL 
 ALTER TABLE ZnodeBlogNews ADD CONSTRAINT [FK_ZnodeBlogNews_ZnodeCMSContentPages] FOREIGN KEY ([CMSContentPagesId]) REFERENCES [dbo].[ZnodeCMSContentPages] ([CMSContentPagesId])
END 
GO 
IF  EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeBlogNewsLocale' AND COLUMN_NAME = 'CMSContentPagesId')
BEGIN 
ALTER TABLE [dbo].[ZnodeBlogNewsLocale] DROP CONSTRAINT FK_ZnodeBlogNewsLocale_ZnodeCMSContentPages 
ALTER TABLE [dbo].[ZnodeBlogNewsLocale] DROP COLUMN [CMSContentPagesId];
END 
GO 
ALTER TABLE [dbo].[ZnodeCity] ALTER COLUMN [CountyCode] NVARCHAR (255) NULL;
ALTER TABLE [dbo].[ZnodeCity] ALTER COLUMN [CountyFIPS] NVARCHAR (50) NULL;
ALTER TABLE [dbo].[ZnodeCity] ALTER COLUMN [MSACode] NVARCHAR (50) NULL;
ALTER TABLE [dbo].[ZnodeCity] ALTER COLUMN [StateFIPS] NVARCHAR (50) NULL;
ALTER TABLE [dbo].[ZnodeCity] ALTER COLUMN [TimeZone] NVARCHAR (50) NULL;
ALTER TABLE [dbo].[ZnodeCMSSEOType] ALTER COLUMN [Name] NVARCHAR (100) NULL;
ALTER TABLE [dbo].[ZnodeImportProcessLog] ALTER COLUMN [ImportTemplateId] INT NULL;
ALTER TABLE [dbo].[ZnodeImportProcessLog] ALTER COLUMN [Status] NVARCHAR (50) NULL;
ALTER TABLE [dbo].[ZnodeImportTemplate] ALTER COLUMN [TemplateName] NVARCHAR (300) NULL;
ALTER TABLE [dbo].[ZnodeImportTemplate] ALTER COLUMN [TemplateVersion] NVARCHAR (100) NULL;
ALTER TABLE [dbo].[ZnodeLocale] ALTER COLUMN [Name] NVARCHAR (100) NULL;
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeImportAttributeValidation' AND COLUMN_NAME = 'SequenceNumber')
BEGIN 
ALTER TABLE [dbo].[ZnodeImportAttributeValidation]
    ADD [SequenceNumber] INT NULL;
END 
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeImportProcessLog' AND COLUMN_NAME = 'SuccessRecordCount')
BEGIN 
ALTER TABLE [dbo].[ZnodeImportProcessLog]
    ADD [ERPTaskSchedulerId] INT    NULL,
        [SuccessRecordCount] BIGINT NULL,
        [FailedRecordcount]  BIGINT NULL;
END 
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeOmsOrderLineItems' AND COLUMN_NAME = 'IsShippingReturn')
BEGIN 
ALTER TABLE [dbo].[ZnodeOmsOrderLineItems]
    ADD [IsShippingReturn]    BIT             NULL,
        [PartialRefundAmount] NUMERIC (28, 6) NULL;
END 
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeOmsOrderWarehouse' AND COLUMN_NAME = 'Quantity')
BEGIN 
ALTER TABLE ZnodeOmsOrderWarehouse ADD [Quantity]  NUMERIC (13) NULL
END 
GO 
ALTER TABLE [dbo].[ZnodePimAttribute] ALTER COLUMN [AttributeCode] NVARCHAR (300) NULL;
ALTER TABLE [dbo].[ZnodePimAttribute] ALTER COLUMN [HelpDescription] NVARCHAR (MAX) NULL;
ALTER TABLE [dbo].[ZnodePimAttributeValue] ALTER COLUMN [AttributeValue] NVARCHAR (300) NULL;
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodePortalPixelTracking' AND COLUMN_NAME = 'DisplayName1')
BEGIN 
ALTER TABLE  ZnodePortalPixelTracking ADD   [DisplayName1]          NVARCHAR (100) NULL
											,[DisplayName2]          NVARCHAR (100) NULL
											,[DisplayName3]          NVARCHAR (100) NULL
											,[DisplayName4]          NVARCHAR (100) NULL
											,[DisplayName5]          NVARCHAR (100) NULL
END 
GO 
ALTER TABLE [dbo].[ZnodeProductFeed] ALTER COLUMN [Date] NVARCHAR (100) NULL;
ALTER TABLE [dbo].[ZnodePublishCategory] ALTER COLUMN [PimParentCategoryId] NVARCHAR (4000) NULL;
ALTER TABLE [dbo].[ZnodePublishCategory] ALTER COLUMN [PublishParentCategoryId] NVARCHAR (4000) NULL;
GO
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeSearchIndexMonitor' AND COLUMN_NAME = 'CatalogIndexId')
BEGIN 
CREATE TABLE [dbo].[ZnodeCatalogIndex] (
    [CatalogIndexId]   INT           IDENTITY (1, 1) NOT NULL,
    [PublishCatalogId] INT           NOT NULL,
    [IndexName]        NVARCHAR (50) NOT NULL,
    [CreatedBy]        INT           NOT NULL,
    [CreatedDate]      DATETIME      NOT NULL,
    [ModifiedBy]       INT           NOT NULL,
    [ModifiedDate]     DATETIME      NOT NULL,
    CONSTRAINT [PK_ZnodePortalIndex] PRIMARY KEY CLUSTERED ([CatalogIndexId] ASC)
);

EXECUTE sp_rename N'ZnodeSearchIndexMonitor.PortalIndexId', N'CatalogIndexId';

DELETE FROM ZnodeSearchIndexServerStatus

DELETE FROM ZnodeSearchIndexMonitor  

ALTER TABLE [dbo].[ZnodeSearchIndexMonitor] ADD CONSTRAINT [FK_ZnodeSearchIndexMonitor_ZnodeCatalogIndex] FOREIGN KEY ([CatalogIndexId]) REFERENCES [dbo].[ZnodeCatalogIndex] ([CatalogIndexId])
ALTER TABLE ZnodeCatalogIndex ADD  CONSTRAINT [FK_ZnodeCatalogIndex_ZnodePublishCatalog] FOREIGN KEY ([PublishCatalogId]) REFERENCES [dbo].[ZnodePublishCatalog] ([PublishCatalogId])


END 
GO 
IF NOT EXISTS (SELECT TOP 1 1  FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'AnalyticsUId' AND TABLE_NAME = 'ZnodeGoogleTagManager' )
BEGIN 
 ALTER TABLE ZnodeGoogleTagManager ADD    [AnalyticsIsActive]   BIT ,AnalyticsUId NVARCHAR(100)
END 
GO 
ALTER TABLE [dbo].[ZnodeShipping] ALTER COLUMN [HandlingChargeBasedOn] NVARCHAR (50) NULL;
ALTER TABLE [dbo].[ZnodeShipping] ALTER COLUMN [ShippingName] NVARCHAR (200) NULL;
ALTER TABLE [dbo].[ZnodeTaxPortal] ALTER COLUMN [AvataxUrl]    NVARCHAR (100) NULL;
GO 
IF NOT EXISTS (SELECT TOP 1  1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZnodeTaxPortal' AND COLUMN_NAME = 'AvalaraAccount')
BEGIN 
  ALTER TABLE [dbo].[ZnodeTaxPortal] DROP COLUMN [UserName],[Password],[SecretKey]          
  ALTER TABLE  [dbo].[ZnodeTaxPortal] ADD  [AvalaraAccount]           NVARCHAR (100) NULL,
    [AvalaraLicense]           NVARCHAR (100) NULL,
    [AvalaraCompanyCode]       NVARCHAR (100) NULL,
    [AvalaraFreightIdentifier] NVARCHAR (100) NULL
END 
GO 
CREATE NONCLUSTERED INDEX [Ind_ZnodeImportLog]
    ON [dbo].[ZnodeImportLog]([ImportProcessLogId] ASC, [Guid] ASC);

GO 
CREATE TABLE [dbo].[ZnodeImportClient] (
    [ImportClientId]       INT            IDENTITY (1, 1) NOT NULL,
    [ImportClientName]     NVARCHAR (200) NULL,
    [ImportClientIsActive] BIT            NULL,
    [CreatedBy]            INT            NOT NULL,
    [CreatedDate]          DATETIME       NOT NULL,
    [ModifiedBy]           INT            NOT NULL,
    [ModifiedDate]         DATETIME       NOT NULL,
    CONSTRAINT [PK_ZnodeImportClient] PRIMARY KEY CLUSTERED ([ImportClientId] ASC)
);
GO 
CREATE TABLE [dbo].[ZnodeImportTableColumnDetail] (
    [ImportTableColumnId]       INT            IDENTITY (1, 1) NOT NULL,
    [ImportTableId]             INT            NULL,
    [ImportTableColumnName]     NVARCHAR (200) NULL,
    [ImportTableColumnIsActive] BIT            NULL,
    [CreatedBy]                 INT            NOT NULL,
    [CreatedDate]               DATETIME       NOT NULL,
    [ModifiedBy]                INT            NOT NULL,
    [ModifiedDate]              DATETIME       NOT NULL,
    [BaseImportColumn]          NVARCHAR (255) NULL,
    [ColumnSequence]            INT            NULL,
    CONSTRAINT [ZnodeImportTableColumnDetails] PRIMARY KEY CLUSTERED ([ImportTableColumnId] ASC)
);
GO 

CREATE TABLE [dbo].[ZnodeImportTableDetail] (
    [ImportTableId]       INT            IDENTITY (1, 1) NOT NULL,
    [ImportClientId]      INT            NULL,
    [ImportHeadId]        INT            NULL,
    [ImportTableName]     NVARCHAR (200) NULL,
    [ImportTableIsActive] BIT            NULL,
    [ImportTableNature]   NVARCHAR (50)  NULL,
    [CreatedBy]           INT            NOT NULL,
    [CreatedDate]         DATETIME       NOT NULL,
    [ModifiedBy]          INT            NOT NULL,
    [ModifiedDate]        DATETIME       NOT NULL,
    CONSTRAINT [ZnodeImportTable] PRIMARY KEY CLUSTERED ([ImportTableId] ASC)
);
GO 
CREATE TABLE [dbo].[ZnodeOmsCustomerShipping] (
    [OmsCustomerShippingId] INT             IDENTITY (1, 1) NOT NULL,
    [OmsOrderDetailsId]     INT             NULL,
    [UserId]                INT             NULL,
    [ShippingTypeId]        INT             NULL,
    [AccountNumber]         NVARCHAR (2000) NULL,
    [ShippingMethod]        NVARCHAR (2000) NULL,
    [CreatedBy]             INT             NOT NULL,
    [CreatedDate]           DATETIME        NOT NULL,
    [ModifiedBy]            INT             NOT NULL,
    [ModifiedDate]          DATETIME        NOT NULL,
    PRIMARY KEY CLUSTERED ([OmsCustomerShippingId] ASC)
);

GO
CREATE TABLE [dbo].[ZnodeRobotsTxt] (
    [RobotsTxtId]      INT            IDENTITY (1, 1) NOT NULL,
    [PortalId]         INT            NULL,
    [RobotsTxtContent] NVARCHAR (MAX) NULL,
    [CreatedBy]        INT            NOT NULL,
    [CreatedDate]      DATETIME       NOT NULL,
    [ModifiedBy]       INT            NOT NULL,
    [ModifiedDate]     DATETIME       NOT NULL,
    CONSTRAINT [PK_ZnodeRobotsTxt] PRIMARY KEY CLUSTERED ([RobotsTxtId] ASC)
);
GO
CREATE TABLE [dbo].[ZnodeSearchKeywordsRedirect] (
    [SearchKeywordsRedirectId] INT            IDENTITY (1, 1) NOT NULL,
    [PublishCatalogId]         INT            NULL,
    [Keywords]                 NVARCHAR (MAX) NULL,
    [URL]                      NVARCHAR (MAX) NULL,
    [LocaleId]                 INT            NULL,
    [CreatedBy]                INT            NOT NULL,
    [CreatedDate]              DATETIME       NOT NULL,
    [ModifiedBy]               INT            NOT NULL,
    [ModifiedDate]             DATETIME       NOT NULL,
    CONSTRAINT [PK_ZnodeSearchKeywordsRedirect] PRIMARY KEY CLUSTERED ([SearchKeywordsRedirectId] ASC)
);
GO
CREATE TABLE [dbo].[ZnodeSearchSynonyms] (
    [SearchSynonymsId] INT            IDENTITY (1, 1) NOT NULL,
    [PublishCatalogId] INT            NULL,
    [OriginalTerm]     NVARCHAR (MAX) NULL,
    [ReplacedBy]       NVARCHAR (MAX) NULL,
    [IsBidirectional]  BIT            NULL,
    [LocaleId]         INT            NULL,
    [CreatedBy]        INT            NOT NULL,
    [CreatedDate]      DATETIME       NOT NULL,
    [ModifiedBy]       INT            NOT NULL,
    [ModifiedDate]     DATETIME       NOT NULL,
    CONSTRAINT [PK_ZnodeSearchSynonyms] PRIMARY KEY CLUSTERED ([SearchSynonymsId] ASC)
);
GO 
ALTER TABLE ZnodeImportTableColumnDetail ADD CONSTRAINT [FK_ZnodeImportTableColumnDetail_ZnodeImportTable] FOREIGN KEY ([ImportTableId]) REFERENCES [dbo].[ZnodeImportTableDetail] ([ImportTableId])
 ALTER TABLE ZnodeImportTableDetail ADD CONSTRAINT [FK_ZnodeImportTable_ZnodeImportClient] FOREIGN KEY ([ImportClientId]) REFERENCES [dbo].[ZnodeImportClient] ([ImportClientId])
 ALTER TABLE ZnodeImportTableDetail ADD CONSTRAINT [FK_ZnodeImportTable_ZnodeImportHead] FOREIGN KEY ([ImportHeadId]) REFERENCES [dbo].[ZnodeImportHead] ([ImportHeadId])
  ALTER TABLE ZnodeOmsCustomerShipping ADD CONSTRAINT [FK_ZnodeOmsCustomerShipping_ZnodeOmsOrderDetails] FOREIGN KEY ([OmsOrderDetailsId]) REFERENCES [dbo].[ZnodeOmsOrderDetails] ([OmsOrderDetailsId])
  ALTER TABLE ZnodeOmsCustomerShipping ADD CONSTRAINT [FK_ZnodeOmsCustomerShipping_ZnodeShippingTypes] FOREIGN KEY ([ShippingTypeId]) REFERENCES [dbo].[ZnodeShippingTypes] ([ShippingTypeId])
  ALTER TABLE ZnodeOmsCustomerShipping ADD CONSTRAINT [FK_ZnodeOmsCustomerShipping_ZnodeUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[ZnodeUser] ([UserId])
  ALTER TABLE ZnodeRobotsTxt ADD CONSTRAINT [FK_ZnodeRobotsTxt_ZnodePortal] FOREIGN KEY ([PortalId]) REFERENCES [dbo].[ZnodePortal] ([PortalId])
  ALTER TABLE  ZnodeSearchKeywordsRedirect ADD CONSTRAINT [FK_ZnodeSearchKeywordsRedirect_ZnodePublishCatalog] FOREIGN KEY ([PublishCatalogId]) REFERENCES [dbo].[ZnodePublishCatalog] ([PublishCatalogId])
 ALTER TABLE ZnodeSearchSynonyms ADD CONSTRAINT [FK_ZnodeSearchSynonyms_ZnodePublishCatalog] FOREIGN KEY ([PublishCatalogId]) REFERENCES [dbo].[ZnodePublishCatalog] ([PublishCatalogId])
GO 
IF EXISTS (SELECT TOP 1 1 FROM Sys.triggers WHERE Name = 'Trg_ZnodeLocale_GlobalSetting')
BEGIN 
DROP TRIGGER [dbo].[Trg_ZnodeLocale_GlobalSetting] 

END 
GO 
CREATE TRIGGER [dbo].[Trg_ZnodeLocale_GlobalSetting]  ON [dbo].[ZnodeLocale] 
AFTER UPDATE AS 
BEGIN
  IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodeGlobalSetting WHERE FeatureName = 'Locale')
  BEGIN
		   INSERT INTO ZnodeGlobalSetting (FeatureName
					,FeatureValues
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate)
			SELECT 'Locale',Code,1,GetDate(),1,Getdate() FROM [dbo].[ZnodeLocale] WHERE IsActive = 1 AND IsDefault = 1
  END 
  ELSE 
  BEGIN 
		  UPDATE ZnodeGlobalSetting
		  SET
			FeatureValues = (SELECT LocaleId FROM [ZnodeLocale] WHERE IsActive = 1 AND IsDefault = 1)
			,ModifiedBy = (SELECT ModifiedBy FROM Inserted ) 
			,ModifiedDate = (SELECT ModifiedDate FROM Inserted ) 
		  WHERE FeatureName = 'Locale'
  
  END 
    EXEC dbo.AspNet_SqlCacheUpdateChangeIdStoredProcedure N'View_GetLocaleDetails'

 END
GO
IF EXISTS (SELECT TOP 1 1 FROM Sys.triggers WHERE Name = 'Trg_ZnodeMediaConfiguration')
BEGIN 
DROP TRIGGER [dbo].[Trg_ZnodeMediaConfiguration] 

END 
GO
CREATE TRIGGER [dbo].[Trg_ZnodeMediaConfiguration] ON [dbo].[ZnodeMediaConfiguration]
                       FOR INSERT, UPDATE, DELETE AS BEGIN
                       SET NOCOUNT ON
                       EXEC dbo.AspNet_SqlCacheUpdateChangeIdStoredProcedure N'ZnodeMediaConfiguration'
                       END
GO
IF EXISTS (SELECT TOP 1  1 FROM sys.Objects WHERE OBJECT_NAME(object_id) = 'Fn_GetGridPimAttributes')
BEGIN 
DROP FUNCTION dbo.Fn_GetGridPimAttributes
END 
GO 
CREATE  FUNCTION [dbo].[Fn_GetGridPimAttributes]
(
)
-- Summary :- This function is used to     
-- Unit Testing 
-- EXEC [dbo].[Fn_GetAttributeDefault] 

RETURNS @Items TABLE
(Id             INT IDENTITY(1, 1),
 PimAttributeId INT,
 AttributeCode  VARCHAR(600)
)
AS
     BEGIN
    BEGIN
        INSERT INTO @Items
        (PimAttributeId,
         AttributeCode
        )
               SELECT PimAttributeId,
                      AttributeCode
               FROM ZnodePimAttribute ZPA
               WHERE IsShowOnGrid = 1 AND 
				     IsCategory = 0;
    END;
         RETURN;
     END; -- End Function
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.views WHERE Name = 'View_GetMediaPathDetail')
BEGIN 
DROP VIEW View_GetMediaPathDetail
END 
GO 
CREATE VIEW [dbo].[View_GetMediaPathDetail]
AS
     SELECT MediaCategoryId,
            MediaPathId,
            [Folder],
            [FileName],
            Size,
			Height,
			Width,
		    Type,
            [MediaType],
            CreatedDate,
            ModifiedDate,
            MediaId,
            Path,
            MediaServerPath MediaServerPath,
            MediaThumbnailPath MediaServerThumbnailPath,
            FamilyCode,
            CreatedBy,
            [DisplayName] [DisplayName],
            [Description] [ShortDescription]

     /* INTO #temp2*/

     FROM
     (
         SELECT Zmc.MediaCategoryId,
                ZMPL.MediaPathId,
                ZMPL.[PathName] [Folder],
                zM.[FileName],
                Zm.Size,
				Zm.Height,
				Zm.Width,
				Zm.Type,
                Zm.Type [MediaType],
                CONVERT( DATE, zm.CreatedDate) CreatedDate,
                CONVERT( DATE, zm.ModifiedDate) ModifiedDate,
                Zm.MediaId,
                zma.AttributeCode,
                Zmav.AttributeValue,
                 [dbo].[Fn_GetMediaThumbnailMediaPath](zM.Path) MediaThumbnailPath,
				[dbo].[Fn_GetMediaThumbnailMediaPath]( zM.Path ) MediaServerPath,
				zM.Path,
               zmafl.FamilyCode FamilyCode,
                Zm.CreatedBy
         FROM ZnodeMediaCategory ZMC
              LEFT JOIN ZnodeMediaAttributeFamily zmafl ON(zmc.MediaAttributeFamilyId = zmafl.MediaAttributeFamilyId)
			  INNER JOIN ZnodeMediaPathLocale ZMPL ON(ZMC.MediaPathId = ZMPL.MediaPathId)
              INNER JOIN ZnodeMedia zM ON(Zm.MediaId = Zmc.MediaId)
		      LEFT JOIN ZnodeMediaConfiguration ZMCF ON (ZMCF.MediaConfigurationId = ZM.MediaConfigurationId )
			  LEFT JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMCF.MediaServerMasterId)
              LEFT JOIN dbo.ZnodeMediaAttributeValue Zmav ON(zmav.MediaCategoryId = zmc.MediaCategoryId)
              LEFT JOIN dbo.ZnodeMediaAttribute zma ON(zma.MediaAttributeId = Zmav.MediaAttributeId
                                                       AND AttributeCode IN('DisplayName', 'Description'))  
    
     ) v PIVOT(MAX(AttributeValue) FOR AttributeCode IN([DisplayName],
                                                        [Description])) PV;
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.views WHERE Name = 'View_PimDefaultValue')
BEGIN 
DROP VIEW View_PimDefaultValue
END 
GO 
CREATE  VIEW [dbo].[View_PimDefaultValue] AS 
Select a.PimAttributeDefaultValueId
,a.PimAttributeId
,a.AttributeDefaultValueCode
,a.IsEditable
,a.CreatedBy,a.DisplayOrder
,CONVERT(DATE,a.CreatedDate)CreatedDate
,a.ModifiedBy
,CONVERt(DATE,a.ModifiedDate)ModifiedDate,b.AttributeDefaultValue,b.LocaleId,b.Description,b.PimAttributeDefaultValueLocaleId from [dbo].[ZnodePimAttributeDefaultValue] a
INNER JOIN  [dbo].[ZnodePimAttributeDefaultValueLocale] b ON (a.PimAttributeDefaultValueId =b.PimAttributeDefaultValueId )
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.views WHERE Name = 'View_GetLocaleDetails')
BEGIN 
DROP VIEW View_GetLocaleDetails
END 
GO 
CREATE VIEW [dbo].[View_GetLocaleDetails] 
AS 
SELECT * 
FROM ZNodeLocale 
WHERE IsActive  = 1
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.views WHERE Name = 'View_GetAllMediaInRoot')
BEGIN 
DROP VIEW View_GetAllMediaInRoot
END 
GO 
CREATE VIEW [dbo].[View_GetAllMediaInRoot]
AS
     SELECT MediaCategoryId,
            MediaPathId,
            [Folder],
            [FileName],
            Size,
			Height,
			Width,
			Type,
            [MediaType],
            CreatedDate,
            ModifiedDate,
            MediaId,
            Path,
            MediaServerPath MediaServerPath,
            MediaThumbnailPath MediaServerThumbnailPath,
            FamilyCode,
            CreatedBy,
            [DisplayName] [DisplayName],
            [Description] [ShortDescription]
     FROM
     (
         SELECT 0 AS MediaCategoryId,
                ZMPL.MediaPathId,
                '-1' ParentMediaPathId,
                CASE
                    WHEN ZMPL.[PathName] IS NULL
                    THEN 'Root'
                    ELSE ZMPL.[PathName]
                END AS Folder,
                zM.FileName,
                zM.Size,
				zM.Height,
				zM.Width,
				zM.Type,
                zM.Type AS MediaType,
                CONVERT( DATE, zm.CreatedDate) CreatedDate,
                CONVERT( DATE, zm.ModifiedDate) ModifiedDate,
                zM.MediaId,
                NULL AS MediaAttributeName,
                NULL AS MediaAttributeValue,
                zmf.FamilyCode,
                [dbo].[Fn_GetMediaThumbnailMediaPath]( zM.Path) MediaThumbnailPath,
				[dbo].[Fn_GetMediaThumbnailMediaPath]( zM.Path)  MediaServerPath,
				zM.Path,
                zM.CreatedBy,
                zmae.AttributeCode,
                zmav.AttributeValue
         FROM dbo.ZnodeMedia AS zM
              LEFT JOIN ZnodeMediaCategory zma ON(zm.mediaid = zma.MediaId)
     --         LEFT JOIN ZnodeMediaConfiguration ZMC ON (ZMC.MediaConfigurationId = ZM.MediaConfigurationId )
			  --LEFT JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			  LEFT JOIN ZnodeMediaAttributeFamily zmf ON(zma.MediaAttributeFamilyId = zmf.MediaAttributeFamilyId)
              LEFT OUTER JOIN dbo.ZnodeMediaPath AS zmp ON(zma.MediaPathId = zmp.MediaPathId)
              LEFT OUTER JOIN dbo.ZnodeMediaPathLocale AS ZMPL ON zmp.MediaPathId = ZMPL.MediaPathId
              LEFT JOIN dbo.ZnodeMediaAttributeValue Zmav ON(zmav.MediaCategoryId = zma.MediaCategoryId)
              LEFT JOIN dbo.ZnodeMediaAttribute zmae ON(zmae.MediaAttributeId = Zmav.MediaAttributeId
                                                        AND zmae.AttributeCode IN('DisplayName', 'Description'))) v 
	 PIVOT(MAX(AttributeValue) FOR AttributeCode IN([DisplayName],
                                                        [Description])) PV;
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetQuoteOrderTemplateDetail')
BEGIN 
	DROP PROCEDURE Znode_GetQuoteOrderTemplateDetail
END 
GO 
CREATE PROCEDURE [dbo].[Znode_GetQuoteOrderTemplateDetail]
(   @WhereClause NVARCHAR(MAX),
	@Rows        INT           = 100,
	@PageNo      INT           = 1,
	@Order_BY    VARCHAR(100)  = '',
	@UserId		 INT,										 
	@RowsCount   INT OUT)
AS 
    /*
		 Summary :- this procedure is used to find QuoteOrderTemplate details 
	     SELECT * FROM ZnodeUser  WHERE AspNeTUSerId = 'ae464cfc-95d3-40de-bf71-47993fabb41f'
		 SELECT * FROM AspNetUserRoles WHERE RoleID = 'A529A670-F446-45EC-BBCB-C00D64D7C964' Userid = '50fe1032-e810-4606-b522-ebf1559e81cf'
		 SELECT * FROM AspNetRoles WHERE ID = '8622E90D-7652-41E7-8563-5DED4CC671DE'

		 Unit Testing 
		 EXEC Znode_GetQuoteOrderTemplateDetail '',@RowsCount = 0, @Order_BY = '', @UserId = 85
	*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @SQL NVARCHAR(MAX);
			 DECLARE @TBL_QuoteOrderTemplate TABLE (OmsTemplateId INT,PortalId INT,UserId INT,TemplateName NVARCHAR(1000),CreatedBy INT,CreatedDate DATETIME
			  ,ModifiedBy INT,ModifiedDate DATETIME,Items INT,RowId INT,CountNo INT )
			 DECLARE @AccountId VARCHAR(2000) ,@UsersId VARCHAR(2000), @ProcessType  varchar(50)='Template'
			 -- SELECT * FROM aspnetRoles
			
			SET @UsersId = SUBSTRING (( SELECT ','+CAST(userId AS VARCHAr(50))  FROM Fn_GetRecurciveUserId(@UserId,@ProcessType) FOR XML PATH ('')),2,4000)
			
			 SET @SQL = '
						; WITH CTE_GetOrderTemplate
						  AS (
						       SELECT ZOT.OmsTemplateId,ZOT.PortalId,ZOT.UserId,ZOT.TemplateName,ZOT.CreatedBy,ZOT.CreatedDate,ZOT.ModifiedBy,ZOT.ModifiedDate,SUM(ZOTL.Quantity) Items 
							   FROM ZnodeOmsTemplate ZOT
                               LEFT JOIN ZnodeOmsTemplateLineItem ZOTL ON(ZOTL.OmsTemplateId = ZOT.OmsTemplateId)
							   WHERE ZOT.userid IN ('+@UsersId+') 
							  AND OrderLineItemRelationshipTypeId IS  NULL AND  ParentOmsTemplateLineItemId IS nULL 
                               GROUP BY ZOT.OmsTemplateId,ZOT.PortalId,ZOT.UserId,ZOT.TemplateName,ZOT.CreatedBy,ZOT.CreatedDate,ZOT.ModifiedBy,ZOT.ModifiedDate						  
						  
						     )
						, CTE_GetQuoteOrderDetails AS
						(
						  SELECT DISTINCT  OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items
						  ,'+dbo.Fn_GetPagingRowId(@Order_BY,'OmsTemplateId DESC,UserId')+',Count(*)Over() CountNo
						  FROM CTE_GetOrderTemplate
						   WHERE 1=1 
				          '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'					  
						
						)

						SELECT OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items,RowId,CountNo
						FROM CTE_GetQuoteOrderDetails
						'+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)

						Print @sql
						INSERT INTO @TBL_QuoteOrderTemplate (OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items,RowId,CountNo)
						EXEC(@SQL)

						SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_QuoteOrderTemplate),0)
   
						SELECT OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items
						FROM @TBL_QuoteOrderTemplate 


	     END TRY
		 BEGIN CATCH
		 
		     DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetQuoteOrderTemplateDetail @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@UserId= '+CAST(@UserId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetQuoteOrderTemplateDetail',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
		 END CATCH

   END
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetZnodeShippingDetails')
BEGIN 
DROP PROCEDURE Znode_GetZnodeShippingDetails
END 
GO 
CREATE PROCEDURE [dbo].[Znode_GetZnodeShippingDetails]
(
     @ZipCode VARCHAR(20)
	,@ProfileId int = 0
	,@PortalId  INT = 0
	,@UserId    INT = 0 
	,@ShippingTypeName VARCHAR(200) = ''  
	,@CountryCode NVARCHAR(300) =''
	,@StateCode  Nvarchar(max) = ''
)
AS 
/*

    Summary: Retrive List of shipping 
    Input Parameters:ZipCode
    Unit Testing   
    -- select * from znodecity where statecode = 'sy'
	Exec Znode_GetZnodeShippingDetails  @ZipCode = '440015'	
	Exec Znode_GetZnodeShippingDetails '53202', 3
	Exec Znode_GetZnodeShippingDetails '53202', NULL
	Exec Znode_GetZnodeShippingDetails '', 1,1
	--select * from ZnodeShipping
	exec Znode_GetZnodeShippingDetails '71342', 0,1,-1,'', 'US'
*/
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @CountryCodeInter VARCHAR(200) 
		DECLARE @Tlb_ShippingDetails TABLE
		( 
			[ShippingId] [int] NOT NULL, [ShippingTypeId] [int] NOT NULL, [ShippingCode] [nvarchar](max) NOT NULL, 
			[HandlingCharge] [numeric](12, 6) NOT NULL, [HandlingChargeBasedOn] [varchar](50) NULL, [DestinationCountryCode] [nvarchar](10) NULL, 
			[StateCode] [nvarchar](20) NULL, [CountyFIPS] [nvarchar](50) NULL, [Description] [nvarchar](max) NOT NULL, [IsActive] [bit] NOT NULL, 
			[DisplayOrder] [int] NOT NULL, [ZipCode] [nvarchar](50) NULL,
			[ShippingTypeName] [nvarchar](50) NULL,
			[ClassName] [nvarchar](100) NULL
		);
		
		DECLARE @Tlb_ShippingDetailsResult TABLE
		( 
			[ShippingId] [int] NOT NULL, 
			[ShippingTypeId] [int] NOT NULL,  
			[ShippingCode] [nvarchar](max) NOT NULL,
		    [HandlingCharge] [numeric](12, 6) NOT NULL, 
			[HandlingChargeBasedOn] [varchar](50) NULL, 
			[DestinationCountryCode] [nvarchar](10) NULL, 
			[StateCode] [nvarchar](20) NULL, 
			[CountyFIPS] [nvarchar](50) NULL, 
			[Description] [nvarchar](max) NOT NULL, 
			[IsActive] [bit] NOT NULL, 
			[DisplayOrder] [int] NOT NULL, 
			[ZipCode] [nvarchar](50) NULL,
			[ShippingTypeName] [nvarchar](50) NULL,
			[ClassName] [nvarchar](100) NULL
		);

		DECLARE @ShippingIds VARCHAR(2000) = '' ,@ProfileIds varchar(2000)= ''

		IF ISNULL(@UserId, 0) <> 0 OR 
		   (ISNULL(@PortalId, 0) > 0 AND 
		   ISNULL(@ProfileId, 0) > 0)
		BEGIN
			DECLARE @PortalIds varchar(2000)= '';
			IF ISNULL(@UserId, 0) <> 0
			BEGIN
			    SET @PortalIds = @PortalId
				EXEC Znode_GetUserPortalAndProfile @UserId, @PortalIds OUT, @ProfileIds OUT;
			END;
			ELSE
			BEGIN
				SET @PortalIds = @PortalId;
				SET @ProfileIds = @ProfileId;
			END;

			EXEC Znode_GetCommonShipping @PortalIds, @ProfileIds, @ShippingIds OUT;
		
			
		END;
		
		DECLARE @ZipCodeLength int, @Attempt int, @Criteria nvarchar(100);
		SET @ZipCodeLength = LEN(@ZipCode);
		SET @Attempt = 1;
		
		
		--SELECT @ShippingIds
		SET @CountryCodeInter =  ISNULL((SELECT TOP 1 CountryCode FROM ZnodeCity WHERE ZIP = @ZipCode ),  @CountryCode)


	--	SELECT @CountryCodeInter

		INSERT INTO @Tlb_ShippingDetails( ShippingId, 
		ShippingTypeId, 
		ShippingCode,
		 HandlingCharge, 
		 HandlingChargeBasedOn, 
		 DestinationCountryCode, 
		 StateCode, 
		 CountyFIPS, 
		 Description,
		  IsActive, 
		  DisplayOrder, 
		  ZipCode,
		 ShippingTypeName,
		 ClassName
		   )
		SELECT ZS.ShippingId, 
			   ZS.ShippingTypeId,  
			   ShippingCode, 
			   HandlingCharge, 
			   HandlingChargeBasedOn, 
			   DestinationCountryCode, 
			   StateCode, 
			   CountyFIPS, 
			   ZS.Description, 
			   ZS.IsActive, 
			   DisplayOrder, 
			   ZipCode,
			   ZST.Name as ShippingTypeName,
			   ZST.ClassName
		FROM ZnodeShipping  ZS 
		LEFT JOIN ZnodeShippingTypes ZST ON (ZS.ShippingTypeId = ZST.ShippingTypeId)
			   WHERE EXISTS (SELECT TOP 1 1 FROM dbo.Split(@ShippingIds,',') SP WHERE ZS.ShippingId = SP.Item) 
			   AND ZST.Name like '%'+ @ShippingTypeName +'%'
	
		INSERT INTO @Tlb_ShippingDetailsResult
		SELECT ShippingId, ShippingTypeId,  ShippingCode, HandlingCharge, HandlingChargeBasedOn, DestinationCountryCode, StateCode, CountyFIPS, Description, IsActive, DisplayOrder, ZipCode, ShippingTypeName,ClassName
		FROM  @Tlb_ShippingDetails  ZS 
		CROSS APPLY dbo.split(ZipCode   ,',') SP
		WHERE     @ZipCode LIKE REPLACE(dbo.FN_TRIM(sp.Item),'*','%')

	--	SELECT @CountryCodeInter

        Select [ShippingId] , 
				[ShippingTypeId] ,  
				[ShippingCode] , 
				[HandlingCharge],
				[HandlingChargeBasedOn] , 
				[DestinationCountryCode] , 
				[StateCode] , 
				[CountyFIPS] , 
				[Description] ,
				[IsActive] ,
				[DisplayOrder] , 
				[ZipCode]  ,
				[ShippingTypeName],
				ClassName
		from @Tlb_ShippingDetailsResult 

		UNION    
		
		Select ZS.[ShippingId] , ZS.[ShippingTypeId] , [ShippingCode] , [HandlingCharge],[HandlingChargeBasedOn] , [DestinationCountryCode] , [StateCode] , [CountyFIPS] , 
			   ZS.[Description] , ZS.[IsActive] , [DisplayOrder] , [ZipCode]   , ZST.[Name] as [ShippingTypeName],ClassName
		from ZnodeShipping ZS 
		LEFT JOIN ZnodeShippingTypes ZST ON (ZS.ShippingTypeId = ZST.ShippingTypeId)
	   -- INNER JOIN ZnodeProfileShipping ZPS ON(ZS.ShippingId = ZPS.ShippingId)
		where ( [DestinationCountryCode] is null  OR [DestinationCountryCode]  = @CountryCodeInter ) 
		and  ZS.ShippingId not in (Select ShippingId from @Tlb_ShippingDetailsResult)
		--and  (ZS.StateCode = @StateCode  OR @StateCode = '')
		and   EXISTS (SELECT TOP 1 1 FROM dbo.Split(@ShippingIds,',') SP WHERE ZS.ShippingId = SP.Item)
		and ZST.Name like '%'+ @ShippingTypeName +'%'

			END TRY
	BEGIN CATCH
		DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetZnodeShippingDetails @ZipCode = '+@ZipCode+',@ProfileId='+CAST(@ProfileId AS VARCHAR(50))+',@PortalId='+CAST(@PortalId AS VARCHAR(50))+',@UserId = '+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetZnodeShippingDetails',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END;
GO
PRINT N'Altering [dbo].[Znode_DeletePortalByPortalId]...';
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_DeletePortalByPortalId')
BEGIN 
DROP PROCEDURE Znode_DeletePortalByPortalId
END 
GO 
CREATE PROCEDURE [dbo].[Znode_DeletePortalByPortalId]
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
		DELETE FROM ZnodeTaxRule WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRule.PortalId);
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
		DELETE FROM ZnodePortalDisplaySetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalDisplaySetting.PortalId);
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


--GO

----Select * from ZnodeCMSPortalMessageKeyTag
 --Declare @Status Bit
	--Exec Znode_DeletePortalByPortalId @PortalId = 1 ,@Status =@Status 

--		select * from dbo.ZnodeCMSPortalMessageKeyTag

--		Msg 547, Level 16, State 0, Procedure Znode_DeletePortalByPortalId, Line 254
--The DELETE statement conflicted with the REFERENCE constraint "FK_ZnodeCMSPortalMessageKeyTag_ZnodePortal". The conflict occurred in database "Installer_01_08_2017_QA_03_05_2017", table "dbo.ZnodeCMSPortalMessageKeyTag", column 'PortalId'.

--Select * from Sysobjects where id in (select id from syscolumns where name  = 'OmsUsersReferralUrlId')
--Select * from ZnodePortal
--Select * from ZnodePortalTaxClass
GO
PRINT N'Altering [dbo].[Znode_InsertPublishProductIds]...';

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_InsertPublishProductIds')
BEGIN 
DROP PROCEDURE Znode_InsertPublishProductIds
END 
GO
CREATE PROCEDURE [dbo].[Znode_InsertPublishProductIds]
(
	@PublishCatalogId        INT            = NULL,
     @UserId                 INT				  ,
	 @PimProductId           VARCHAR(2000) = 0,
	 @IsCallAssociated       BIT           = 0     
	)
AS
    
/*
  Summary :	Publish Product on the basis of publish catalog
				Retrive all Product details with attributes and insert into following tables 
				1.	ZnodePublishedXml
				2.	ZnodePublishCategoryProduct
				3.	ZnodePublishProduct
				4.	ZnodePublishProductDetail

                Product details include all the type of products link, grouped, configure and bundel products (include addon) their associated products 
				collect their attributes and values into tables variables to process for publish.  
                
				Finally genrate XML for products with their attributes and inserted into ZnodePublishedXml Znode Admin process xml from sql server to mongodb
				one by one.

     Unit Testing
    
     SELECT * FROM ZnodePimCustomField WHERE CustomCode = 'Test'
     SELECT * FROM ZnodePimCatalogCategory WHERE pimCatalogId = 3 AND PimProductId = 181
     SELECT * FROM ZnodePimCustomFieldLocale WHERE PimCustomFieldId = 1
	 SELECT * FROM ZnodePublishProduct WHERE PublishProductid = 213 = 30
     select * from znodepublishcatalog
	 SELECT * FROM view_loadmanageProduct WHERE Attributecode = 'ProductNAme' AND AttributeValue LIKE '%Apple%'
     SELECT * FROM ZnodePimCategoryProduct WHERE  PimProductId = 181
	 SELECT * FROM ZnodePimCatalogcategory WHERE pimcatalogId = 3 
     EXEC Znode_GetPublishProducts  @PublishCatalogId = 9 ,@UserId= 2 ,@NotReturnXML= NULL,@PimProductId = 117,@IsDebug= 1 
     EXEC Znode_InsertPublishProductIds  @PublishCatalogId = 0,@UserId= 2  ,@PimProductId = 29 ,@NotReturnXML= NULL,@IsDebug= 1 
     EXEC Znode_GetPublishProducts  @PublishCatalogId =1,@UserId= 2 ,@RequiredXML= 1	
	 SELECT * FROM 	ZnodePimCatalogCategory  WHERE pimcatalogId = 3  
	 SELECT * FROM [dbo].[ZnodePimCategoryHierarchy]  WHERE pimcatalogId = 3 
    */ 

     BEGIN
      --  BEGIN TRAN InsertPublishProductIds;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate(); 
			 DECLARE @PimCatalogId int= ISNULL((SELECT PimCatalogId FROM ZnodePublishcatalog WHERE PublishCatalogId = @PublishCatalogId), 0);  --- this variable is used to carry y pim catalog id by using published catalog id
             DECLARE @ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
			,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
			,@ProductTypeAttributeId INT = dbo.Fn_GetProductTypeAttributeId()
			DECLARE @TBL_LocaleId  TABLE (RowId INT IDENTITY(1,1) PRIMARY KEY  , LocaleId INT )
			INSERT INTO @TBL_LocaleId (LocaleId)
			SELECT LocaleId
			FROM ZnodeLocale 
			WHERE IsActive = 1

			 -- This variable used to carry the locale in loop 
			 -- This variable is used to carry the default locale which is globaly set
             DECLARE @Counter INT =1 ,@maxCountId INT = (SELECT max(RowId) FROM @TBL_LocaleId ) 
			 DECLARE @DeletePublishProductId VARCHAR(MAX)= '', @PimProductIds VARCHAR(MAX)= '', @PimAttributeId VARCHAR(MAX)= '';
             
			 -- This table will used to hold the all currently active locale ids  
			 


		     -- This table hold the complete xml of product with other information like category and catalog
            
			 DECLARE @TBL_PimProductIds TABLE(PimProductId INT  ,PimCategoryId INT,PimCatalogId INT,PublishCatalogId INT,IsParentProducts BIT
									,DisplayOrder INT,ProductName NVARCHAR(MAX),SKU  NVARCHAR(MAX),IsActive NVARCHAR(MAX),PimAttributeFamilyId INT
									,ProfileId   VARCHAR(MAX),CategoryDisplayOrder INT ,ProductIndex INT,PRIMARY KEY (PimCatalogId,PimCategoryId,PimProductId) );  
		
			  -- This table is used to hold the product which publish in current process 
             DECLARE @TBL_PublishProductIds TABLE(PublishProductId  INT  ,PimProductId INT,PublishCatalogId  INT
													,PublishCategoryId VARCHAR(MAX),CategoryProfileIds VARCHAR(max),VersionId INT , PRIMARY KEY (PimProductId,PublishProductId,PublishCatalogId)); 
	 
			-- this check is used when this procedure is call by internal procedure to publish only product and no need to return publish xml;    
			   
			--Collected list of products for  publish 
   
			 INSERT INTO @TBL_PimProductIds ( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId,CategoryDisplayOrder,PublishCatalogId )
				SELECT ZPCC.PimProductId, ZPCC.PimCategoryId, 1 AS IsParentProducts, NULL AS DisplayOrder, ZPCC.PimCatalogId,ZPCC.DisplayOrder ,ZPC.PublishCatalogId
				FROM ZnodePimCatalogCategory AS ZPCC
				INNER JOIN ZnodePublishCatalog ZPC ON ZPC.PimCatalogId = ZPCC.PimCatalogId
		    	WHERE  (ZPCC.PimCatalogId = @PimCatalogId OR 
				EXISTS( SELECT TOP 1 1 FROM dbo.split(@PimProductId,',') SP WHERE SP.Item = ZPCC.PimProductId) ) AND ZPCC.PimProductId IS NOT NULL

				
             --Collected list of link products for  publish
			 INSERT INTO @TBL_PimProductIds( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId , PublishCatalogId)
				 SELECT ZPLPD.PimProductId, ZPCC.PimCategoryId, 0 AS IsParentProducts, NULL AS DisplayOrder, CTPP.PimCatalogId,CTPP.PublishCatalogId 
				 FROM ZnodePimLinkProductDetail AS ZPLPD
				 INNER JOIN @TBL_PimProductIds AS CTPP ON ZPLPD.PimParentProductId = CTPP.PimProductId AND  IsParentProducts = 1 
				 INNER JOIN ZnodePimCatalogCategory AS ZPCC ON ZPCC.PimProductId = ZPLPD.PimProductId AND ZPCC.PimCatalogId = CTPP.PimCatalogId
				 WHERE NOT EXISTS ( SELECT TOP 1 1 FROM @TBL_PimProductIds AS CTPPI WHERE CTPPI.PimProductId = ZPLPD.PimProductId) 
				-- AND EXISTS ( SELECT TOP 1 1 FROM ZnodePimAttributeValue AS VILMP WHERE VILMP.PimProductId = ZPLPD.PimProductId ) 
				 AND ZPCC.PimProductId IS NOT NULL
				 GROUP BY ZPLPD.PimProductId, ZPCC.PimCategoryId,CTPP.PimCatalogId,CTPP.PublishCatalogId 
             --Collected list of Addon products for  publish
        
		     INSERT INTO @TBL_PimProductIds( PimProductId, PimCategoryId, IsParentProducts, DisplayOrder, PimCatalogId,PublishCatalogId)
					 SELECT ZPAPD.PimChildProductId, ISNULL(ZPCC.PimCategoryId,0) AS PublishCategoryId, 0 AS IsParentProducts, null AS DisplayOrder,CTALP.PimCatalogId,CTALP.PublishCatalogId
					 FROM ZnodePimAddOnProductDetail AS ZPAPD 
					 INNER JOIN ZnodePimAddOnProduct AS ZPAP ON ZPAP.PimAddOnProductId = ZPAPD.PimAddOnProductId
					 INNER JOIN @TBL_PimProductIds AS CTALP ON CTALP.PimProductId = ZPAP.PimProductId AND  IsParentProducts = 1
					 LEFT JOIN ZnodePimCatalogCategory AS ZPCC ON ZPCC.PimProductId = ZPAPD.PimChildProductId AND ZPCC.PimCatalogId = CTALP.PimCatalogId
					 WHERE NOT EXISTS (SELECT TOP 1 1 FROM @TBL_PimProductIds AS CTALPI WHERE CTALPI.PimProductId = ZPAPD.PimChildProductId) 
				---	 AND EXISTS(SELECT TOP 1 1FROM ZnodePimAttributeValue AS VILMP WHERE VILMP.PimProductId = ZPAPD.PimChildProductId)  
					 GROUP BY ZPAPD.PimChildProductId, ZPCC.PimCategoryId , CTALP.PimCatalogId,CTALP.PublishCatalogId

					 		 	

             --Collected list of Bundle / Group / Config products for  publish
             INSERT INTO @TBL_PimProductIds(PimProductId,PimCategoryId,IsParentProducts,DisplayOrder,PimCatalogId,PublishCatalogId)
                    SELECT ZPTA.PimProductId,ISNULL(ZPCC.PimCategoryId,0),0 AS IsParentProducts,NULL DisplayOrder,CTAAP.PimCatalogId,CTAAP.PublishCatalogId
                    FROM ZnodePimProductTypeAssociation AS ZPTA INNER JOIN @TBL_PimProductIds AS CTAAP ON CTAAP.PimProductId = ZPTA.PimParentProductId AND IsParentProducts = 1
                    LEFT JOIN ZnodePimCatalogCategory AS ZPCC ON ZPCC.PimProductId = ZPTA.PimProductId AND ZPCC.PimCatalogId = CTAAP.PimCatalogId
                    WHERE NOT EXISTS( SELECT TOP 1 1 FROM @TBL_PimProductIds AS CTAAPI WHERE CTAAPI.PimProductId = ZPTA.PimProductId)
					--AND EXISTS(SELECT TOP 1 1 FROM ZnodePimAttributeValue AS VILMP WHERE VILMP.PimProductId = ZPTA.PimProductId)
					GROUP BY ZPTA.PimProductId,ZPCC.PimCategoryId,CTAAP.PimCatalogId,CTAAP.PublishCatalogId
        				  

			   UPDATE TBPP
               SET PublishCatalogId = ZPC.PublishCatalogId 
			   FROM @TBL_PimProductIds TBPP 
			   INNER JOIN ZnodePublishCatalog ZPC ON ZpC.PimCatalogId = TBPP.PimCatalogId;
        
		DECLARE @PublishProductId TRANSFERId 


		IF @PublishCatalogId IS NOT NULL AND @PublishCatalogId <> 0 
			  BEGIN 
			  -- SELECT * FROM @TBL_PimProductIds AS TBP
			
			  INSERT INTO @PublishProductId
			    SELECT DISTINCT ZPP.PublishProductId 
				FROM ZnodePublishProduct AS ZPP 
				INNER JOIN ZnodePublishCategoryProduct ZPPC ON (ZPPC.PublishProductId = ZPP.PublishProductId AND ZPPC.PublishCatalogId = ZPP.PublishCatalogId)
				--INNER JOIN ZnodePublishCategory ZPC ON (ZPC.PublishCategoryId = ZPPC.PublishCategoryId)
				WHERE NOT EXISTS(SELECT TOP 1 1 FROM @TBL_PimProductIds AS TBP WHERE ZPP.PimProductId = TBP.PimProductId AND TBP.PublishCatalogId = ZPP.PublishCatalogId)
				AND ZPP.PublishCatalogId = @PublishCatalogId
					--Remove extra products from catalog
				
		END
		ELSE IF @IsCallAssociated = 0 
		BEGIN 
		DECLARE @TBL_ProductIdscollect TABLE(PublishProductId INT , PimproductId INT , PublishcatalogId  INT  , ProductType NVARCHAr(max))

	
		INSERT INTO @TBL_ProductIdscollect (PublishProductId,PimproductId,PublishcatalogId,ProductType)
		SELECT PublishProductId,ZPAV.PimproductId,TBPOCI.PublishcatalogId,ZPATF.AttributeDefaultValueCode
		FROM ZnodePimAttributeValue ZPAV 
		INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON (ZPADV.PimAttributeValueId = ZPAV.PimAttributeValueId )
		INNER JOIN @TBL_PimProductIds TBLIDF ON (TBLIDF.PimProductId = ZPAV.PimProductId )
		INNER JOIN ZnodePublishProduct TBPOCI ON (TBPOCI.PimProductId = TBLIDF.PimProductId AND TBPOCI.PublishCatalogId = TBLIDF.PublishCatalogId 	)
		INNER JOIN ZnodePimAttributeDefaultValue ZPATF ON (ZPATF.PimAttributeId =  @ProductTypeAttributeId 
						AND ZPADV.PimAttributeDefaultValueId = ZPATF.PimAttributeDefaultValueId )
         WHERE  IsParentProducts = 1	
		 AND LocaleId =@DefaultLocaleId
    

        IF EXISTS (SELECT TOP 1 1 FROM @TBL_ProductIdscollect WHERE ProductType IN ('GroupedProduct','BundleProduct','ConfigurableProduct','SimpleProduct') )
		     
		BEGIN 
	
		   DECLARE @TBL_DeleteTrackProduct TABLE (PublishProductId INT,AssociatedZnodeProductId INT  ,PublishCatalogId INT,PublishCatalogLogId INT ,IsDelete BIT  )

		   ;With Cte_PublishProduct AS
		   (
		     SELECT TBL.PublishProductId,PimproductId,TBL.PublishcatalogId,ProductType ,MAx(PublishCatalogLogId) PublishCatalogLogId
			 FROM  @TBL_ProductIdscollect TBL 
			 INNER JOIN ZnodePublishCatalogLog TBLG ON (TBLG.PublishCatalogId = TBL.PublishcatalogId)
			 WHERE IsCatalogPublished = 1 
		     GROUP BY TBL.PublishProductId,PimproductId,TBL.PublishcatalogId,ProductType
		   
		   )
		   , Cte_ConfigData AS 
			 (
			 SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
			 FROM ZnodePublishedXml ZPXML 
			 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
			 CROSS APPLY ZPXML.PublishedXML.nodes('/ConfigurableProductEntity') t(p)
			 WHERE  IsConfigProductXML = 1
			 AND ProductType = 'ConfigurableProduct'
			 UNION ALL 
			  SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
			 FROM ZnodePublishedXml ZPXML 
			 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
			 CROSS APPLY ZPXML.PublishedXML.nodes('/GroupProductEntity') t(p)
			 WHERE  IsGroupProductXML = 1
			 AND ProductType = 'GroupedProduct'
			 UNION ALL 
			  SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
			 FROM ZnodePublishedXml ZPXML 
			 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
			 CROSS APPLY ZPXML.PublishedXML.nodes('/BundleProductEntity') t(p)
			 WHERE  IsBundleProductXML = 1
			 AND ProductType = 'BundleProduct'
			 UNION ALL 
			 SELECT p.value('(./AssociatedZnodeProductId)[1]', 'INT')  AssociatedZnodeProductId,PublishProductId,PimproductId,PublishcatalogId,ProductType,CTR.PublishCatalogLogId
			 FROM ZnodePublishedXml ZPXML 
			 INNER JOIN Cte_PublishProduct CTR ON (CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId AND CTR.PublishProductId = ZPXML.PublishedId)
			 CROSS APPLY ZPXML.PublishedXML.nodes('/AddonEntity') t(p)
			 WHERE  IsAddOnXML = 1
			 AND LocaleId = @DefaultLocaleId 
			
			 )

		--	 SELECT * FROM ZnodePublishCatalogLog WHERE PublishCatalogId = 8 

		INSERT INTO @TBL_DeleteTrackProduct (PublishProductId,AssociatedZnodeProductId,PublishcatalogId,PublishCatalogLogId)
		SELECT ZPP.PublishProductId,AssociatedZnodeProductId,PublishcatalogId,PublishCatalogLogId
		FROM Cte_ConfigData ZPP	
		WHERE NOT EXISTS (SELECT TOP 1 1 FROM  @TBL_PublishProductIds TBLP WHERE TBLP.PublishProductId = ZPP.AssociatedZnodeProductId)
		
	

		;With Cte_updateStatus AS
		(
		 
		     SELECT  PublishProductId,PublishcatalogId
			  FROM @TBL_DeleteTrackProduct CTR 
			 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
			 CROSS APPLY ZPXML.PublishedXML.nodes('/ConfigurableProductEntity') t(p)
			 WHERE  IsConfigProductXML = 1 
			 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
			 AND LocaleId = @DefaultLocaleId 
		     AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
		     AND CTR.PublishProductId = ZPXML.PublishedId ) 

			 UNION ALL 
			  SELECT PublishProductId,PublishcatalogId
			 FROM @TBL_DeleteTrackProduct CTR 
			 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
			 CROSS APPLY ZPXML.PublishedXML.nodes('/GroupProductEntity') t(p)
			 WHERE  IsGroupProductXML = 1 
			 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
			 AND LocaleId = @DefaultLocaleId 
		     AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
		     AND CTR.PublishProductId = ZPXML.PublishedId ) 

			 UNION ALL 
			  SELECT  PublishProductId,PublishcatalogId
			   FROM @TBL_DeleteTrackProduct CTR 
			 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
			 CROSS APPLY ZPXML.PublishedXML.nodes('/BundleProductEntity') t(p)
			 WHERE  IsBundleProductXML = 1 
			 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
			 AND LocaleId = @DefaultLocaleId 
		     AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
		     AND CTR.PublishProductId = ZPXML.PublishedId ) 


			 UNION ALL 
			 SELECT PublishProductId,PublishcatalogId
			 FROM @TBL_DeleteTrackProduct CTR 
			 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePublishedXml ZPXML  
			 CROSS APPLY ZPXML.PublishedXML.nodes('/AddonEntity') t(p)
			 WHERE  IsAddOnXML = 1 
			 AND  CTR.PublishCatalogLogId = ZPXML.PublishCatalogLogId 
			 AND LocaleId = @DefaultLocaleId 
		     AND CTR.PublishProductId = p.value('(./AssociatedZnodeProductId)[1]', 'INT') 
		     AND CTR.PublishProductId = ZPXML.PublishedId ) 
		
		)

		UPDATE a 
		SET IsDelete = CASE WHEN TYR.PublishProductId IS NULL THEN 1 ELSE 0 END 
		FROM @TBL_DeleteTrackProduct a 
		LEFT JOIN Cte_updateStatus TYR ON (TYR.PublishProductId = a.PublishProductId AND TYR.PublishCatalogId = a.PublishCatalogId)

		
		INSERT INTO @PublishProductId 
		SELECT DISTINCT AssociatedZnodeProductId 
		FROM @TBL_DeleteTrackProduct
		WHERE IsDelete =1  
		

		END 

	
		INSERT INTO @PublishProductId
		SELECT PublishProductid
		FROM ZnodePublishProduct ZPP
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId =  ZPP.PublishCatalogId )
        WHERE Not EXISTS (SELECT TOP 1 1 FROM ZnodePimCatalogCategory ZPPP WHERE (ZPPP.PimCatalogid = ZPc.PimCatalogId AND ZPPP.PimProductId = ZPP.PimProductId))  
		AND EXISTS (SELECT TOP 1 1 FROM @TBL_PimProductIds TYR WHERE TYR.PimProductId = ZPP.PimProductId )
		AND NOT EXISTS (SELECT TOP 1 1 FROM @PublishProductId YTR WHERE YTR.Id = ZPP.PublishProductId  )	
		END  

		EXEC dbo.Znode_DeletePublishCatalogProduct  @PublishProductIds = @PublishProductId,@PublishCatalogId = @PublishCatalogId ;

		

			 -- This merge statement is used for crude oprtaion with publisgh product table
			MERGE INTO ZnodePublishProduct TARGET USING  (
				SELECT PimProductId, PublishCatalogId
				FROM @TBL_PimProductIds AS TBP
				GROUP BY PimProductId, PublishCatalogId
			 )  SOURCE
				ON --check for if already exists then just update otherwise insert the product  
				TARGET.PimProductId = SOURCE.PimProductId AND  TARGET.PublishCatalogId = SOURCE.PublishCataLogId 
				WHEN MATCHED      THEN UPDATE SET TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate	
				WHEN NOT MATCHED  THEN INSERT(PimProductId, PublishCatalogId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
									   VALUES( SOURCE.PimProductId, SOURCE.PublishCatalogId, @UserId, @GetDate, @UserId, @GetDate )
				OUTPUT INSERTED.PublishProductId, INSERTED.PimProductId, INSERTED.PublishCatalogId
				INTO @TBL_PublishProductIds(PublishProductId, PimProductId, PublishCatalogId); 
			
			-- Here used the ouput clause to catch what data inserted or updated into variable table
	    	
		 --   SELECT a.PublishCatalogId,a.PublishCategoryId,b.PimProductId
			--FROM @TBL_PublishProductIds a 
			--INNER JOIN @TBL_PimProductIds b ON (a.PimProductId = b.PimCategoryId)
			----INNER JOIN ZnodePublishProduct ZPP  ON (ZPP.PimProductId = b.PimProductId AND ZPP.PublishCatalogId =  a.PublishCatalogId)
			--WHERE PimCategoryId = 2 
				
			
			-- This merge staetment is used for crude opration with  ZnodePublishCategoryProduct table
			 MERGE INTO ZnodePublishCategoryProduct TARGET USING  (
				 SELECT PublishProductId,
				 ISNULL(ZPC.PublishCategoryId,0)PublishCategoryId,
				 TBP.PublishCatalogId
				 FROM @TBL_PimProductIds AS TBP 
				 LEFT JOIN ZnodePublishCategory AS ZPC ON (ISNULL(TBP.PimCategoryId, 0) = ISNULL(ZPC.PimCategoryId, -1) AND ZPC.PublishCatalogId = TBP.PublishCatalogId)
				 INNER JOIN @TBL_PublishProductIds AS TBPP ON TBP.PimProductId = TBPP.PimProductId
				 AND TBP.PublishCatalogId = TBPP.PublishCatalogId
				 GROUP BY PublishProductId, ZPC.PublishCategoryId, TBP.PublishCatalogId
			  ) SOURCE
					ON  TARGET.PublishCatalogId = SOURCE.PublishCatalogId AND ISNULL(TARGET.PublishCategoryId, 0) = ISNULL(SOURCE.PublishCategoryId, 0) AND TARGET.PublishProductId = SOURCE.PublishProductId
					
					WHEN MATCHED THEN UPDATE SET TARGET.PublishCategoryId = CASE WHEN SOURCE.PublishCategoryId = 0 THEN NULL ELSE SOURCE.PublishCategoryId END 
												 ,TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate					
					WHEN NOT MATCHED THEN INSERT(PublishProductId,PublishCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
										  VALUES(SOURCE.PublishProductId,CASE WHEN SOURCE.PublishCategoryId =0 THEN NULL ELSE SOURCE.PublishCategoryId  END , SOURCE.PublishCatalogId,@UserId,@GetDate,@userId,@GetDate);
   
    
   WHILE @Counter <= @maxCountId
   BEGIN 
    SET @LocaleId = (SELECT TOP 1 LocaleId FROM @TBL_LocaleId WHERE RowId = @Counter)
   
     
	 SELECT VIR.PimProductId,PimAttributeId,AttributeValue,ZnodePimAttributeValueLocaleId,VIR.LocaleId ,COUNT(*)Over(Partition By VIR.PimProductId,PimAttributeId ORDER BY VIR.PimProductId,PimAttributeId  ) RowId
	 INTO #TBL_AttributeVAlue
	 FROM View_LoadManageProductInternal VIR
	 WHERE (LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId )
	 AND EXISTS (SELECT TOP 1 1 FROM @TBL_PublishProductIds ZPP WHERE (ZPP.PimProductId = VIR.PimProductId) )
	 AND (PimAttributeId = @ProductNamePimAttributeId  OR PimAttributeId = @SKUPimAttributeId OR PimAttributeId = @IsActivePimAttributeId  )
  
   

		
	          MERGE INTO ZnodePublishProductDetail   TARGET
			  USING  (SELECT   ZPP.PublishProductId ,TBLA.AttributeValue PRoductName,TBLAI.AttributeValue SKU ,ISNULL(TBLAII.AttributeValue,'0') IsActive --,TBLAIII.AttributeValue ProductType
						FROM  @TBL_PublishProductIds zpp
						INNER JOIN #TBL_AttributeVAlue TBLA ON (TBLA.PimAttributeId = @ProductNamePimAttributeId AND TBLA.PimProductId = ZPP.PimProductId AND TBLA.LocaleId  = CASE WHEN TBLA.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
					--	INNER JOIN @TBL_AttributeVAlue  TBLA ON (TBLA.PimProductId = ZPP.PimProductId AND TBLA.PimAttributeId = @ProductNamePimAttributeId)
					    INNER JOIN #TBL_AttributeVAlue TBLAI ON (TBLAI.PimAttributeId = @SKUPimAttributeId AND TBLAI.PimProductId = ZPP.PimProductId AND TBLAI.LocaleId  = CASE WHEN TBLAI.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
					--	INNER JOIN @TBL_AttributeVAlue  TBLAI ON (TBLAI.PimProductId = ZPP.PimProductId AND TBLAI.PimAttributeId = @SKUPimAttributeId)
					    INNER JOIN #TBL_AttributeVAlue TBLAII ON (TBLAII.PimAttributeId = @IsActivePimAttributeId AND TBLAII.PimProductId = ZPP.PimProductId AND TBLAII.LocaleId  = CASE WHEN TBLAII.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
						--INNER JOIN #TBL_AttributeVAlue TBLAIII ON (TBLAIII.PimAttributeId = @ProductTypePimAttributeId AND TBLAIII.PimProductId = ZPP.PimProductId AND TBLAIII.LocaleId  = CASE WHEN TBLAIII.RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END )
					--	INNER JOIN @TBL_AttributeVAlue  TBLAIII ON (TBLAII.PimProductId = ZPP.PimProductId AND TBLAII.PimAttributeId = @ProductTypeAttributeId)
						GROUP BY ZPP.PublishProductId,TBLA.AttributeValue,TBLAI.AttributeValue,TBLAII.AttributeValue --,TBLAIII.AttributeValue
						)   SOURCE
			ON (TARGET.PublishProductId = SOURCE.PublishProductId
				 AND TARGET.LocaleId = @LocaleId 
			) 
			WHEN MATCHED THEN 
			UPDATE 
			SET TARGET.ProductName   = SOURCE.ProductName
				,TARGET.SKU			 = SOURCE.SKU
				,TARGET.IsActive	= SOURCE.IsActive
				,TARGET.ModifiedBy	 = @userid
				,TARGET.ModifiedDate  = @GetDate
			WHEN NOT MATCHED THEN 
			INSERT (PublishProductId
					,ProductName
					,SKU
					,IsActive
					,LocaleId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate)
			VALUES ( SOURCE.PublishProductId
					,SOURCE.ProductName
					,SOURCE.SKU
					,SOURCE.IsActive
					,@LocaleId
					,@userId
					,@GetDate
					,@userId
					,@GetDate);

		 
         DROP TABLE #TBL_AttributeVAlue 
		
		 SET @Counter = @counter + 1 
			  END 

			  IF @PublishCatalogId IS NULL OR @PublishCatalogId =0 
			  BEGIN 
			  SELECT PublishProductId, PimProductId, PublishCatalogId 
			  FROM @TBL_PublishProductIds
			  END 

		--COMMIT TRAN InsertPublishProductIds;
		END TRY 
		BEGIN CATCH 
		 SELECT ERROR_MESSAGE()
	--	 ROLLBACK TRAN InsertPublishProductIds;
		END CATCH 
	END
GO
PRINT N'Altering [dbo].[Znode_ImportGetTemplateDetails]...';

IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_ImportGetTemplateDetails')
BEGIN 
DROP PROCEDURE Znode_ImportGetTemplateDetails
END 
GO
CREATE PROCEDURE [dbo].[Znode_ImportGetTemplateDetails](
	@TemplateId					int,
	@IsValidationRules			bit= 1,
	@IsIncludeRespectiveFamily	bit= 0,
	@IsProductPriceTemplate		bit= 0,
	@IsCategory					int= 0, 
	@DefaultFamilyId			int= 0,
	@ImportHeadId				int = 0 )
AS
	/*
	  Summary:  Get template details for import process
	  SourceColumnName : CSV file column headers
	  TargetColumnName : Attributecode from ZnodePimAttribute Table 
	  Unit Testing   
	  Exec Znode_ImportGetTemplateDetails @TemplateId =4
	  Exec Znode_ImportGetTemplateDetails @TemplateId =5 ,@IsValidationRules = 0 ,@IsIncludeRespectiveFamily = 0,@IsProductPriceTemplate =1 
*/
BEGIN
	BEGIN TRY
	    DECLARE @DefaultAttributePimFamilyId INT 
	    SET @DefaultAttributePimFamilyId = dbo.Fn_GetDefaultPimProductFamilyId();

		IF @IsValidationRules = 1 AND  @IsIncludeRespectiveFamily = 0 AND  @IsProductPriceTemplate = 0 
		BEGIN
			SELECT zpa.PimAttributeId, zat.AttributeTypeName, zpa.AttributeCode, zitm.SourceColumnName, zpa.IsRequired, b.ControlName, b.Name AS ValidationName, c.ValidationName AS SubValidationName, a.Name AS ValidationValue, c.RegExp
			FROM dbo.ZnodePimAttribute AS zpa INNER JOIN dbo.ZnodeAttributeType AS zat ON zat.AttributeTypeId = zpa.AttributeTypeId
				 INNER JOIN dbo.ZnodeImportTemplateMapping AS zitm ON zpa.AttributeCode = zitm.TargetColumnName 
				 LEFT OUTER JOIN dbo.ZnodePimAttributeValidation AS a ON zpa.PimAttributeId = a.PimAttributeId
				 LEFT OUTER JOIN dbo.ZnodeAttributeInputValidation AS b ON a.InputValidationId = b.InputValidationId
				 LEFT OUTER JOIN dbo.ZnodeAttributeInputValidationRule AS c ON a.InputValidationRuleId = c.InputValidationRuleId
			WHERE zitm.ImportTemplateId = @TemplateId;
		END;
		ELSE 
		BEGIN
			IF @IsValidationRules = 0 AND @IsIncludeRespectiveFamily = 0 AND @IsProductPriceTemplate = 0
			BEGIN
				SELECT zpa.PimAttributeId, zat.AttributeTypeName, zpa.AttributeCode, zitm.SourceColumnName, zpa.IsRequired
				FROM dbo.ZnodePimAttribute AS zpa INNER JOIN dbo.ZnodeAttributeType AS zat ON zat.AttributeTypeId = zpa.AttributeTypeId
					 INNER JOIN dbo.ZnodeImportTemplateMapping AS zitm ON zpa.AttributeCode = zitm.TargetColumnName
				WHERE zitm.ImportTemplateId = @TemplateId;
			END;
			ELSE
			BEGIN
				IF @IsValidationRules = 0 AND  @IsIncludeRespectiveFamily = 0 AND @IsProductPriceTemplate = 1
				BEGIN
					SELECT DISTINCT  zpa.AttributeCode, zitm.SourceColumnName, zpa.IsRequired
					FROM dbo.ZnodeImportAttributeValidation AS zpa LEFT OUTER JOIN dbo.ZnodeImportTemplateMapping AS zitm ON zpa.AttributeCode = zitm.TargetColumnName AND 
							zitm.ImportTemplateId = @TemplateId;
				END;
				ELSE
				BEGIN
					--IF @IsValidationRules = 0 AND @IsIncludeRespectiveFamily = 1 AND @IsProductPriceTemplate = 0 AND @DefaultFamilyId = 0
					--BEGIN
					--	SELECT zpa.PimAttributeId, zat.AttributeTypeName, zpa.AttributeCode, zitm.SourceColumnName, zpa.IsRequired, 0 AS PimAttributeFamilyId
					--	FROM dbo.ZnodePimAttribute AS zpa INNER JOIN dbo.ZnodeAttributeType AS zat ON zat.AttributeTypeId = zpa.AttributeTypeId
					--		 LEFT OUTER JOIN dbo.ZnodeImportTemplateMapping AS zitm ON zpa.AttributeCode = zitm.TargetColumnName AND zitm.ImportTemplateId = @TemplateId
					--	WHERE zpa.IsCategory = @IsCategory ORDER BY zpa.PimAttributeId;
					--END;
					--ELSE
					BEGIN
						IF @IsValidationRules = 0 AND @IsIncludeRespectiveFamily = 1 AND  @IsProductPriceTemplate = 0 --AND @DefaultFamilyId <> 0
						BEGIN
							SELECT distinct zpa.PimAttributeId, zat.AttributeTypeName, zpa.AttributeCode, zitm.SourceColumnName, zpa.IsRequired ,@DefaultFamilyId
							FROM dbo.ZnodePimAttributeFamily AS zpaf INNER JOIN dbo.ZnodePimFamilyGroupMapper AS zpfgm ON zpaf.PimAttributeFamilyId = zpfgm.PimAttributeFamilyId
								 INNER JOIN dbo.ZnodePimAttribute AS zpa ON zpa.PimAttributeId = zpfgm.PimAttributeId AND zpa.PimAttributeId = zpfgm.PimAttributeId
								 INNER JOIN dbo.ZnodeAttributeType AS zat ON zat.AttributeTypeId = zpa.AttributeTypeId 
								 LEFT OUTER JOIN dbo.ZnodeImportTemplateMapping AS zitm
								 ON zpa.AttributeCode = zitm.SourceColumnName AND zitm.ImportTemplateId = @TemplateId
							WHERE zpaf.IsCategory = @IsCategory AND zpfgm.PimAttributeFamilyId in (@DefaultAttributePimFamilyId, @DefaultFamilyId)  AND zpfgm.PimAttributeId IS NOT NULL
							
						END;
					END;

				END;;
			END;
		END;
		
	END TRY
	BEGIN CATCH
		DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ImportGetTemplateDetails @TemplateId = '+CAST(@TemplateId AS VARCHAR(20))+',@IsValidationRules='+CAST(@IsValidationRules AS VARCHAR(50))+',@IsIncludeRespectiveFamily='+CAST(@IsIncludeRespectiveFamily AS VARCHAR(50
))+',@IsProductPriceTemplate='+CAST(@IsProductPriceTemplate AS VARCHAR(50))+',@IsCategory = '+CAST(@IsCategory AS VARCHAR(50))+',@DefaultFamilyId='+CAST(@DefaultFamilyId AS VARCHAR(50))+',@ImportHeadId='+CAST(@ImportHeadId AS VARCHAR(50))+',@Status='+CAST
(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ImportGetTemplateDetails',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
	END CATCH;
END;
GO
PRINT N'Altering [dbo].[Znode_ImportAttributes]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportAttributes' )
BEGIN
	DROP PROCEDURE Znode_ImportAttributes
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportAttributes](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @PimCatalogId int= 0)
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import Attribute Code Name and their default input validation rule other 
	--			  flag will be inserted as default we need to modify front end
	
	-- Unit Testing: 

	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max);
		DECLARE @GetDate datetime= dbo.Fn_GetDate(), @LocaleId int  ;
		SELECT @LocaleId = DBO.Fn_GetDefaultLocaleId();
		-- Retrive RoundOff Value from global setting 
		DECLARE @InsertPimAtrribute TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, AttributeName varchar(300), AttributeCode varchar(300), AttributeType varchar(300), DisplayOrder int, GUID nvarchar(400)
		
		);
		DECLARE @InsertedPimAttributeIds TABLE (PimAttributeId int ,AttributeTypeId int,AttributeCode nvarchar(300))
		
		SET @SSQL = 'Select RowNumber,AttributeName,AttributeCode,AttributeType,DisplayOrder ,GUID FROM '+@TableName;
		INSERT INTO @InsertPimAtrribute( RowNumber,AttributeName,AttributeCode,AttributeType,DisplayOrder ,GUID)
		EXEC sys.sp_sqlexec @SSQL;


		--@MessageDisplay will use to display validate message for input inventory value  
		DECLARE @AttributeCode TABLE
		( 
		   AttributeCode nvarchar(300)
		);
		INSERT INTO @AttributeCode
			   SELECT AttributeCode
			   FROM ZnodePimAttribute 

		-- Start Functional Validation 
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '10', 'AttributeCode', AttributeCode, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPimAtrribute AS ii
			   WHERE ii.AttributeCode in 
			   (
				   SELECT AttributeCode FROM @AttributeCode  where AttributeCode is not null 
			   );

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'AttributeType', AttributeType, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPimAtrribute AS ii
			   WHERE ii.AttributeType NOT in 
			   (
				   SELECT AttributeTypeName  FROM ZnodeAttributeType  where IsPimAttributeType = 1 
			   );
		-- End Function Validation 	
		-----------------------------------------------
		-- Delete Invalid Data after functional validatin  
		DELETE FROM @InsertPimAtrribute
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
		);
		
		--- Insert data into base table ZnodePimatrribute with their validation 

		INSERT INTO ZnodePimAttribute (AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined
			,IsConfigurable,IsPersonalizable,IsShowOnGrid,DisplayOrder,HelpDescription,IsCategory,IsHidden,IsSwatch,
			CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		
		OUTPUT Inserted.PimAttributeId,Inserted.AttributeTypeId,Inserted.AttributeCode INTO @InsertedPimAttributeIds  
		
		SELECT ZAT.AttributeTypeId,AttributeCode, 1 IsRequired , 1 IsLocalizable,1 IsFilterable, 0 IsSystemDefined, 0 IsConfigurable,
		0 IsPersonalizable,  1 IsShowOnGrid , DisplayOrder, 'Imported Data' HelpDescription ,0  IsCategory , 0 IsHidden , 0 IsSwatch,
		@UserId , @GetDate ,@UserId , @GetDate from @InsertPimAtrribute IPA INNER JOIN ZnodeAttributeType ZAT 
		ON IPA.AttributeType = ZAT.AttributeTypeName  
		
		
		INSERT INTO ZnodePimAttributeLocale (LocaleId,PimAttributeId,AttributeName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select @LocaleId ,IPAS.PimAttributeId, IPA.AttributeName, '', @UserId , @GetDate ,@UserId , @GetDate   
		 FROM @InsertedPimAttributeIds IPAS INNER JOIN @InsertPimAtrribute IPA ON IPAS.AttributeCode= IPA.AttributeCode 
		
		INSERT INTO ZnodePimAttributeValidation
		(PimAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		SELECT IPA.PimAttributeId,ZAIV.InputValidationId,NULL,null , @UserId , @GetDate ,@UserId , @GetDate  
		FROM @InsertedPimAttributeIds IPA INNER JOIN ZnodeAttributeInputValidation ZAIV ON IPA.AttributeTypeId = ZAIV.AttributeTypeId

		--      SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET STATUS = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
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
GO
PRINT N'Altering [dbo].[Znode_ImportCatalogCategory]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportCatalogCategory' )
BEGIN
	DROP PROCEDURE Znode_ImportCatalogCategory
END
GO
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
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, SKU varchar(300), CategoryName varchar(200), DisplayOrder int, IsActive bit, GUID nvarchar(400)
			--,Index Ind_SKU1 (SKU),Index Ind_CategoryName (CategoryName)
		);

		DECLARE @CategoryAttributId int;

		SET @CategoryAttributId =
		(
			SELECT TOP 1 PimAttributeId
			FROM ZnodePimAttribute AS ZPA
			WHERE ZPA.AttributeCode = 'CategoryName' AND 
				  ZPA.IsCategory = 1
		);

		DECLARE @InventoryListId int;

		SET @SSQL = 'Select RowNumber,SKU,CategoryName,DisplayOrder ,IsActive,GUID FROM '+@TableName;
		INSERT INTO @InsertCatalogCategory( RowNumber, SKU, CategoryName, DisplayOrder, IsActive, GUID )
		EXEC sys.sp_sqlexec @SSQL;


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


		DECLARE @CategoryName TABLE
		( 
			CategoryName nvarchar(300), PimCategoryId int --index ind_101 (CategoryName)
		);
		INSERT INTO @CategoryName
			   SELECT ZPCAL.CategoryValue, ZPCA.PimCategoryId
			   FROM ZnodePimCategoryAttributeValue AS ZPCA
					INNER JOIN
					ZnodePimCategoryAttributeValueLocale AS ZPCAL
					ON ZPCA.PimAttributeId = 5 AND 
					ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId;
					
		-- start Functional Validation 
		
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertCatalogCategory AS ii
			   WHERE ii.SKU NOT in 
			   (
				   SELECT SKU FROM @SKU  where SKU is not null 
			   );
		
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'CategoryName', CategoryName, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertCatalogCategory AS ii
			   WHERE ii.CategoryName NOT in 
			   (
				   SELECT CategoryName FROM @CategoryName  where CategoryName is not null 
			   );
		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  
		DELETE FROM @InsertCatalogCategory
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);

			
		IF(ISNULL(@PimCatalogId, 0) <> 0)
		BEGIN
			WITH Cte_CategorySKUAssociation
				 AS(SELECT SKU.PimProductId, 
				   (Select top 1 PimCategoryId from @CategoryName where ICC.CategoryName = CategoryName )  
				   PimCategoryId
				   , DisplayOrder, IsActive FROM @InsertCatalogCategory AS ICC INNER JOIN @SKU AS SKU ON ICC.SKU = SKU.SKU)
				 MERGE INTO ZnodePimCatalogCategory TARGET
				 USING Cte_CategorySKUAssociation SOURCE
				 ON( TARGET.PimCategoryId = SOURCE.PimCategoryId AND 
					 Target.PimCatalogId = @PimCatalogId
				   )
				 WHEN MATCHED
					   THEN UPDATE SET TARGET.PimProductId = SOURCE.PimProductId, TARGET.IsActive = SOURCE.IsActive, TARGET.DisplayOrder = SOURCE.DisplayOrder, TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate
				 WHEN NOT MATCHED
					   THEN INSERT(PimCatalogId, PimCategoryId, PimProductId, IsActive, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) VALUES( @PimCatalogId, SOURCE.PimCategoryId, SOURCE.PimProductId, SOURCE.IsActive, SOURCE.DisplayOrder, @UserId, @GetDate, @UserId, @GetDate );
		END;
		ELSE
		BEGIN
			
			  Declare @ZnodePimCategoryProduct TABLE (PimProductId int , PimCategoryId int , Status bit , DisplayOrder int) 
			  	
			  insert into @ZnodePimCategoryProduct (PimProductId , PimCategoryId , Status , DisplayOrder )
			  SELECT SKU.PimProductId, (Select top 1 PimCategoryId from @CategoryName where ICC.CategoryName = CategoryName )  PimCategoryId
				 , IsActive , DisplayOrder FROM @InsertCatalogCategory AS ICC INNER JOIN	 @SKU AS SKU ON ICC.SKU = SKU.SKU 
			
			  INSERT into ZnodePimCategoryProduct ( PimProductId, PimCategoryId, Status, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
			  Select TABL.PimProductId, TABL.PimCategoryId, TABL.Status, TABL.DisplayOrder,@UserId, @GetDate, @UserId, @GetDate   from @ZnodePimCategoryProduct TABL    
			  Where NOT EXISTS (Select top 1 1 from ZnodePimCategoryProduct ZPCP where ZPCP.PimProductId = TABL.PimProductId and  ZPCP.PimCategoryId = TABL.PimCategoryId)

		END;										 
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
GO
PRINT N'Altering [dbo].[Znode_ImportCustomer]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportCustomer' )
BEGIN
	DROP PROCEDURE Znode_ImportCustomer
END
GO
CREATE  PROCEDURE [dbo].[Znode_ImportCustomer](
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
			LastName nvarchar(200),	MiddleName	nvarchar(200),BudgetAmount	numeric,Email	nvarchar(100),PhoneNumber	nvarchar(100),
		    EmailOptIn	bit	,ReferralStatus	nvarchar(40),IsActive	bit	,ExternalId	nvarchar(max), GUID NVARCHAR(400)
		);

			--SET @SSQL = 'SELECT RowNumber,UserName,FirstName,LastName,MiddleName,BudgetAmount,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId,GUID FROM '+ @TableName;
		SET @SSQL = 'SELECT RowNumber,' + @CsvColumnString + ',GUID FROM '+ @TableName;
		INSERT INTO @InsertCustomer( RowNumber,UserName,FirstName,LastName,MiddleName,Email,PhoneNumber,       EmailOptIn,IsActive,ExternalId,GUID )
		EXEC sys.sp_sqlexec @SSQL;
		


		--UserName,FirstName,LastName,MiddleName,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId
	
	    -- start Functional Validation 

		-----------------------------------------------
		--If @IsAllowGlobalLevelUserCreation = 'true'
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			   WHERE ii.UserName in 
		--			   (
		--				   SELECT UserName FROM AspNetZnodeUser   where PortalId = @PortalId
		--			   );
		--Else 
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			   WHERE ii.UserName in 
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
					   WHERE ii.UserName in 
					   (SELECT UserName  FROM @InsertCustomer group by UserName  having count(*) > 1 )

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
		-- Insert Product Data 
				
				
				DECLARE @InsertedAspNetZnodeUser TABLE (AspNetZnodeUserId nvarchar(256) ,UserName nvarchar(512),PortalId int )
				DECLARE @InsertedASPNetUsers TABLE (Id nvarchar(256) ,UserName nvarchar(512))
				DECLARE @InsertZnodeUser TABLE (UserId int,AspNetUserId nvarchar(256) )

				UPDATE ANU SET 
				ANU.PhoneNumber	= IC.PhoneNumber
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				UPDATE ZU SET 
				ZU.FirstName	= IC.FirstName,
				ZU.LastName		= IC.LastName,
				ZU.MiddleName	= IC.MiddleName,
				ZU.BudgetAmount = IC.BudgetAmount,
				ZU.Email		= IC.Email,
				ZU.PhoneNumber	= IC.PhoneNumber,
				ZU.EmailOptIn	= IC.EmailOptIn,
				ZU.IsActive		= IC.IsActive
				--ZU.ExternalId = ExternalId
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

	
				Insert into AspNetZnodeUser (AspNetZnodeUserId, UserName, PortalId)		
				OUTPUT INSERTED.AspNetZnodeUserId, INSERTED.UserName, INSERTED.PortalId	INTO  @InsertedAspNetZnodeUser 			 
				Select NEWID(),IC.UserName, @PortalId FROM @InsertCustomer IC 
				where Not Exists (Select TOP 1 1  from AspNetZnodeUser ANZ where Isnull(ANZ.PortalId,0) = Isnull(@PortalId,0) AND ANZ.UserName = IC.UserName)

				INSERT INTO ASPNetUsers (Id,Email,EmailConfirmed,PasswordHash,SecurityStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,
				LockoutEndDateUtc,LockOutEnabled,AccessFailedCount,PasswordChangedDate,UserName)
				output inserted.Id, inserted.UserName into @InsertedASPNetUsers
				SELECT NewId(), Email,0 ,@PasswordHash,@SecurityStamp,PhoneNumber,0,0,NULL LockoutEndDateUtc,1 LockoutEnabled,
				0,@GetDate,AspNetZnodeUserId from @InsertCustomer A INNER JOIN @InsertedAspNetZnodeUser  B 
				ON A.UserName = B.UserName
				
				INSERT INTO  ZnodeUser(AspNetUserId,FirstName,LastName,MiddleName,CustomerPaymentGUID,Email,PhoneNumber,EmailOptIn,
				IsActive,ExternalId, CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				OUTPUT Inserted.UserId, Inserted.AspNetUserId into @InsertZnodeUser
				SELECT IANU.Id AspNetUserId ,IC.FirstName,IC.LastName,IC.MiddleName,null CustomerPaymentGUID,IC.Email
				,IC.PhoneNumber,Isnull(IC.EmailOptIn,0),IC.IsActive,IC.ExternalId, @UserId,@Getdate,@UserId,@Getdate
				from @InsertCustomer IC Inner join 
				@InsertedAspNetZnodeUser IANZU ON IC.UserName = IANZU.UserName  INNER JOIN 
				@InsertedASPNetUsers IANU ON IANZU.AspNetZnodeUserId = IANU.UserName 
				  	     
				INSERT INTO AspNetUserRoles (UserId,RoleId)  Select AspNetUserId, @RoleID from @InsertZnodeUser 
				INSERT INTO ZnodeUserPortal (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
				SELECT UserId, @PortalId , @UserId,@Getdate,@UserId,@Getdate from @InsertZnodeUser

		-- 'End'
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
GO
PRINT N'Altering [dbo].[Znode_ImportInventory_Ver1]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportInventory_Ver1' )
BEGIN
	DROP PROCEDURE Znode_ImportInventory_Ver1
END
GO
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
				RowNumber int, SKU varchar(max), Quantity varchar(max), ReOrderLevel varchar(max), WarehouseCode varchar(max), GUID nvarchar(400)
		);
		CREATE TABLE tempdb..#InsertInventory  
		( 
				InsertInventoryId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, SKU varchar(300) , Quantity numeric(28, 6), ReOrderLevel numeric(28, 6), WarehouseCode varchar(200), GUID nvarchar(400) 
		);
		--DECLARE tempdb..#InsertInventory  TABLE
		--( 
		--		InsertInventoryId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, SKU varchar(300) INDEX Ix CLUSTERED (SKU), Quantity numeric(28, 6), ReOrderLevel numeric(28, 6), WarehouseCode varchar(200), GUID nvarchar(400) 
		--);
	
		DECLARE @SKU TABLE
		( 
				SKU nvarchar(300)
		);
			
		INSERT INTO @SKU
			   SELECT b.AttributeValue
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;

		DECLARE @InventoryListId int;
		SET @SSQL = 'Select RowNumber,SKU,Quantity,ReOrderLevel,WarehouseCode ,GUID FROM '+@TableName;
		INSERT INTO tempdb..#InserInventoryForValidation( RowNumber, SKU, Quantity, ReOrderLevel, WarehouseCode, GUID )
		EXEC sys.sp_sqlexec @SSQL;
		
		
		--Required Validation 
		--UomName should not be null 
		--Data for this Inventory list is already available  
		-- 
		-- 1)  Validation for SKU is pending Proper data not found and 
		--Discussion still open for Publish version where we create SKU and use thi SKU code for validation 
		--Select * from ZnodePimAttributeValue  where PimAttributeId =248
		--select * from View_ZnodePimAttributeValue Vzpa Inner join ZnodePimAttribute Zpa on Vzpa.PimAttributeId=Zpa.PimAttributeId where Zpa.AttributeCode = 'SKU'
		--Select * from ZnodePimAttribute where AttributeCode = 'SKU'
		--2)  Start Data Type Validation for XML Data  
		--SELECT * FROM ZnodeInventory
		--SELECT * FROM ZNodeInventoryList
		UPDATE tempdb..#InserInventoryForValidation
		  SET ReOrderLevel = 0
		WHERE ReOrderLevel = '';

		DELETE FROM tempdb..#InserInventoryForValidation
		WHERE RowNumber IN
		(

			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  GUID = @NewGUID
		);
	
		INSERT INTO tempdb..#InsertInventory ( RowNumber, SKU, Quantity, ReOrderLevel, WarehouseCode )
			   SELECT RowNumber, SKU, Quantity, ReOrderLevel, WarehouseCode
			   FROM tempdb..#InserInventoryForValidation;
					 
		-- start Functional Validation 
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM tempdb..#InsertInventory  AS ii
			   WHERE ii.SKU NOT IN
			   (
				   SELECT SKU
				   FROM @SKU
			   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'WarehouseCode', WarehouseCode, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM tempdb..#InsertInventory  AS ii
			   WHERE NOT EXISTS
			   (
				   SELECT TOP 1 1
				   FROM ZnodeWarehouse AS zw
				   WHERE zw.WarehouseCode = ii.WarehouseCode
			   );

		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  
		DELETE FROM tempdb..#InsertInventory 
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

		INSERT INTO @TBL_ReadyToInsertInventory( RowNumber, SKU, Quantity, ReOrderLevel, WarehouseId )
			   SELECT ii.RowNumber, ii.SKU, ii.Quantity, ISNULL(ii.ReOrderLevel, 0), zw.WarehouseId
			   FROM tempdb..#InsertInventory  AS ii
					INNER JOIN
					ZnodeWarehouse AS zw
					ON ii.WarehouseCode = zw.WarehouseCode AND 
					   ii.RowNumber IN
			   (
				   SELECT MAX(ii1.RowNumber)
				   FROM tempdb..#InsertInventory  AS ii1
				   WHERE ii1.WarehouseCode = ii.WarehouseCode AND 
						 ii1.SKU = ii.SKU
			   );
			   	
		
		--select 'update started'  
		UPDATE zi
		  SET Quantity = rtii.Quantity, ReOrderLevel = ISNULL(rtii.ReOrderLevel, 0), ModifiedBy = @UserId, ModifiedDate = @GetDate
		FROM ZNodeInventory zi
			 INNER JOIN
			 @TBL_ReadyToInsertInventory rtii
			 ON( zi.WarehouseId = rtii.WarehouseId AND 
				 zi.SKU = rtii.SKU
			   );
			   
		--select 'update End'                
		INSERT INTO ZnodeInventory( WarehouseId, SKU, Quantity, ReOrderLevel, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
			   SELECT WarehouseId, SKU, Quantity, ISNULL(ReOrderLevel, 0), @UserId, @GetDate, @UserId, @GetDate
			   FROM @TBL_ReadyToInsertInventory AS rtii
			   WHERE NOT EXISTS
			   (
				   SELECT TOP 1 1
				   FROM ZnodeInventory AS zi
				   WHERE zi.WarehouseId = rtii.WarehouseId AND 
						 zi.SKU = rtii.SKU
			   ); 
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
GO
PRINT N'Altering [dbo].[Znode_ImportPriceList]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportPriceList' )
BEGIN
	DROP PROCEDURE Znode_ImportPriceList
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportPriceList]
(
	@TableName nvarchar(100),
	@Status bit OUT, 
	@UserId int, 
	@ImportProcessLogId int,
	@NewGUId nvarchar(200),
	@PriceListId int )
AS 
	/*
	----Summary:  Import RetailPrice List 
	----		  Input XML data extracted in table format (table variable name:  @InsertPriceForValidation) by using  @xml.nodes 
	----		  Validate data column wise and store error log into @ErrorLogForInsertPrice table 
	----          Remove wrong data from table @InsertPriceForValidation and inserted correct data into @InsertPrice table for 
	----		  further processing (Importing to target database )
	---- Version 1 : Required Validation 
	---- UomName should not be null 
	---- Data for this RetailPrice list is already available  
	---- Version 2 : Required Validation 
	---- If UomName will be null then insert first record from UomTable and If UomName is wrong then raise error
	---- SKU with retailprice data is available with price list id will insert 
	---- multiple SKU with retail price is available then updated last sku details to price table and price tier table for respective price list
	----1. Import functionality should be provided only for single price list (Validate - Pending) 
	----  Tier price : TierStartQuantity should not between TierStartQuantity and TierEndQuantity for already existing SKU 
	----  In case of update details for SKU if any kind of price value will null then avoid it to update on existing value. 
	----2. From XML only SKU and RetailPrice is mandatory
	----3. SKUActivation date sholud be less than SKUExpriration date
	----4. Activation date sholud be less than Expiration date
	----5. If Tier RetailPrice has values and TierSartQuantity /TierEndQuantity or both has null value then it should not get updated/created.
	----6. ActivationDate and ExpirationDate value for tier price will be SKUActivationDate SKUExprirationDate 
	--- Change History : 
	--Remove column which is used to store range of qunatity by single column Quantity from table ZnodeTierProduct 
	--Manditory Retail price in Znodepricetable 
	-- SKUActivationfrom date and to date will used for tier price will store in single table ZnodePrice
	--Unit Testing   
	
*/
BEGIN
	BEGIN TRAN A;
	BEGIN TRY
	    DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
		DECLARE @InsertPriceForValidation TABLE
		( 
			SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL
		);
		DECLARE @InsertPrice TABLE
		( 
			SKU varchar(300), TierStartQuantity numeric(28, 6) NULL, RetailPrice numeric(28, 6) NULL, SalesPrice numeric(28, 6) NULL, TierPrice numeric(28, 6) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300)
		);
	
		DECLARE @SKU TABLE
		( 
				SKU nvarchar(300)
		);
		INSERT INTO @SKU
			   SELECT b.AttributeValue
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;


		--SET @CategoryXML =  REPLACE(@CategoryXML,'<?xml version="1.0" encoding="utf-16"?>','')

		DECLARE @RoundOffValue int, @MessageDisplay nvarchar(100); 
		-- Retrive RoundOff Value from global setting 

		SELECT @RoundOffValue = FeatureValues FROM ZnodeGlobalSetting WHERE FeatureName = 'PriceRoundOff';
	
		--@MessageDisplay will use to display validate message for input inventory value  

		DECLARE @sSql nvarchar(max);
		SET @sSql = ' Select @MessageDisplay_new = Convert(Numeric(28, '+CONVERT(nvarchar(200), @RoundOffValue)+'), 999999.000000000 ) ';
		EXEC SP_EXecutesql @sSql, N'@MessageDisplay_new NVARCHAR(100) OUT', @MessageDisplay_new = @MessageDisplay OUT;
		
		SET @SSQL = 'Select SKU,TierStartQuantity ,RetailPrice,SalesPrice,TierPrice,SKUActivationDate ,SKUExpirationDate ,RowNumber FROM '+@TableName;
		INSERT INTO @InsertPriceForValidation( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate, RowNumber )
		EXEC sys.sp_sqlexec @SSQL;


		-- 1)  Validation for SKU is pending Proper data not found and 
		--Discussion still open for Publish version where we create SKU and use the SKU code for validation 
		--Select * from ZnodePimAttributeValue  where PimAttributeId =248
		--select * from View_ZnodePimAttributeValue Vzpa Inner join ZnodePimAttribute Zpa on Vzpa.PimAttributeId=Zpa.PimAttributeId where Zpa.AttributeCode = 'SKU'
		--Select * from ZnodePimAttribute where AttributeCode = 'SKU'
		--------------------------------------------------------------------------------------
		--2)  Start Data Type Validation for XML Data  
		--------------------------------------------------------------------------------------			
		---------------------------------------------------------------------------------------
		---------If UOM will blank then retrive top -- Finctionality pending 
		---Validate 
		
		
		INSERT INTO @InsertPrice( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate, RowNumber )
			   SELECT SKU,
					  CASE
					  WHEN CONVERT(Varchar(100),TierStartQuantity) = '' THEN 0
					  ELSE CONVERT(numeric(28, 6), TierStartQuantity)
					  END, CONVERT(numeric(28, 6), RetailPrice),
															  CASE
															  WHEN SalesPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), SalesPrice)
															  END,
															  CASE
															  WHEN TierPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), TierPrice)
															  END, SKUActivationDate, SKUExpirationDate, RowNumber
			   FROM @InsertPriceForValidation;
				
		--------------------------------------------------------------------------------------
		--- start Functional Validation 
		--------------------------------------------------------------------------------------
		--- Verify SKU is present or not 

		--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--	   SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		--	   FROM @InsertPrice
		--	   WHERE SKU NOT IN
		--	   (
		--		   SELECT ZPAVL.AttributeValue
		--		   FROM ZnodePimAttribute AS ZPA
		--				INNER JOIN
		--				ZnodePimAttributeValue AS ZPAV
		--				ON ZPA.PimAttributeId = ZPAV.PimAttributeId
		--				INNER JOIN
		--				ZnodePimAttributeValueLocale AS ZPAVL
		--				ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
		--		   WHERE ZPA.AttributeCode = 'SKU'
		--	   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		FROM @InsertPrice AS ii
		WHERE ii.SKU NOT IN
		(
			SELECT SKU
			FROM @SKU
		);

			 
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'RetailPrice', RetailPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPriceForValidation
			   WHERE ISNULL(CAST(RetailPrice AS numeric(28, 6)), 0) <= 0 AND 
					 RetailPrice <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '39', 'SKUActivationDate', SKUActivationDate, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPrice AS IP
			   WHERE SKUActivationDate > SKUExpirationDate AND 
					 ISNULL(SKUExpirationDate, '') <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPriceForValidation
			   WHERE( TierPrice IS NULL OR TierPrice = '0') AND  TierStartQuantity = '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierPrice', TierPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPriceForValidation WHERE( TierPrice IS NULL OR  TierPrice = '') AND TierStartQuantity <> 0;
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPriceForValidation
			   WHERE ISNULL(CAST(TierStartQuantity AS numeric(28, 6)), 0) < 0 AND 
					 TierPrice <> '';
 
		-- End Function Validation 	
		---------------------------
		--- Delete Invalid Data after functional validation 
		DELETE FROM @InsertPrice
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  Guid = @NewGUId
		);
	
		-- Remove duplicate records 
		--insert into @RemoveDuplicateInsertPrice
		--(SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber )
		--Select SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber FROM @InsertPrice 
		
		--Delete from @InsertPrice 

		--insert into @InsertPrice (SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber)
		--Select SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber from @RemoveDuplicateInsertPrice rdip WHERE rdip.RowNumber IN
		--(
		--	SELECT MAX(ipi.RowNumber) FROM @InsertPrice ipi WHERE rdip.PriceListCode = ipi.PriceListCode AND rdip.SKU = ipi.SKU
		--);

		--Validate StartQuantity and EndQuantity from PriceTier : This validation only for existing data 
		--INSERT INTO @ErrorLogForInsertPrice (RowNumber,SKU,TierStartQuantity ,RetailPrice ,SalesPrice,TierPrice,Uom ,UnitSize,PriceListCode,PriceListName,CurrencyId ,ActivationDate,ExpirationDate,SKUActivationDate,SKUExpirationDate,SequenceNumber,ErrorDescription) 
		--Select IP.RowNumber,IP.SKU,IP.TierStartQuantity ,IP.RetailPrice ,IP.SalesPrice,IP.TierPrice,IP.Uom ,IP.UnitSize,IP.PriceListCode,IP.PriceListName,IP.CurrencyId ,IP.ActivationDate,IP.ExpirationDate,IP.SKUActivationDate,IP.SKUExpirationDate,IP.SequenceNumber,
		--'TierStartQuantity already exists in PriceTier table for SKU '
		--From @InsertPrice IP  Inner join
		--ZnodePriceList Zpl ON Zpl.Listcode = IP.PriceListcode and Zpl.ListName = IP.PriceListName
		--INNER JOIN ZnodeUOM Zu ON ltrim(rtrim(IP.Uom)) = ltrim(rtrim(Zu.Uom)) 
		--INNER JOIN ZnodePriceTier ZPT  ON ZPT.PriceListId = Zpl.PriceListId 
		--AND ZPT.SKU = IP.SKU
		--Where IP.TierStartQuantity  = ZPT.Quantity  
		--- Delete Invalid Data after  Validate StartQuantity and EndQuantity from PriceTier
		
		--INSERT INTO ZnodeUOM (Uom,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		--Select distinct ltrim(rtrim(Uom)) , @UserId,@GetDate,@UserId,@GetDate  from @InsertPrice 
		--where ltrim(rtrim(Uom)) not in (Select ltrim(rtrim(UOM)) From ZnodeUOM where UOM  is not null )
		
		DECLARE @FailedRecordCount BIGINT, @SuccessRecordCount BIGINT 
	
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;

		SELECT @SuccessRecordCount = COUNT(DISTINCT ROWNUMBER) FROM @InsertPrice WHERE 	ROWNUMBER IS NOT NULL ;

		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;

		UPDATE ZP
				SET ZP.SalesPrice = IP.SalesPrice, ZP.RetailPrice = CASE
				WHEN CONVERT(varchar(100), ISNULL(IP.RetailPrice, '')) <> '' THEN IP.RetailPrice
				END, ZP.ActivationDate = CASE
				WHEN ISNULL(IP.SKUActivationDate, '') <> '' THEN IP.SKUActivationDate
				ELSE NULL
				END, ZP.ExpirationDate = CASE
				WHEN ISNULL(IP.SKUExpirationDate, '') <> '' THEN IP.SKUExpirationDate
				ELSE NULL
				END, ZP.ModifiedBy = @UserId, ZP.ModifiedDate = @GetDate
		FROM @InsertPrice IP INNER JOIN ZnodePrice ZP ON ZP.PriceListId = @PriceListId AND  ZP.SKU = IP.SKU  
			 --Retrive last record from prince list of specific SKU ListCode and Name 									
		WHERE IP.RowNumber IN
		(
			SELECT MAX(IPI.RowNumber) FROM @InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
		);
		INSERT INTO ZnodePrice( PriceListId, SKU, SalesPrice, RetailPrice, ActivationDate, ExpirationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
			   SELECT @PriceListId, IP.SKU, IP.SalesPrice, IP.RetailPrice,
																						   CASE
																						   WHEN ISNULL(IP.SKUActivationDate, '') = '' THEN NULL
																						   ELSE IP.SKUActivationDate
																						   END,
																						   CASE
																						   WHEN ISNULL(IP.SKUExpirationDate, '') = '' THEN NULL
																						   ELSE IP.SKUExpirationDate
																						   END, @UserId, @GetDate, @UserId, @GetDate
			   FROM @InsertPrice AS IP
			   WHERE NOT EXISTS
			   (
				   SELECT TOP 1 1
				   FROM ZnodePrice
				   WHERE ZnodePrice.PriceListId = @PriceListId AND 
						 ZnodePrice.SKU = IP.SKU AND 
						 ISNULL(ZnodePrice.SalesPrice, 0) = ISNULL(IP.SalesPrice, 0) AND 
						 ZnodePrice.RetailPrice = IP.RetailPrice
			   ) AND 
					 IP.RowNumber IN
			   (
					SELECT MAX(IPI.RowNumber)
					FROM @InsertPrice AS IPI
					WHERE IPI.SKU = IP.SKU 
			   );
		IF EXISTS
		(
			SELECT TOP 1 1
			FROM @InsertPrice
			WHERE CONVERT(varchar(100), TierStartQuantity) <> '' AND 
				  (CONVERT(varchar(100), TierPrice) <> '')
		)
		BEGIN
			UPDATE ZPT
			  SET ZPT.Price = IP.TierPrice, ZPT.ModifiedBy = @UserId, ZPT.ModifiedDate = @GetDate
			FROM @InsertPrice IP INNER JOIN ZnodePriceTier ZPT ON ZPT.PriceListId = @PriceListId AND  ZPT.SKU = IP.SKU AND ZPT.Quantity = IP.TierStartQuantity 
		    --Retrive last record from prince list of specific SKU ListCode and Name 
			WHERE IP.RowNumber IN
			(
				SELECT MAX(IPI.RowNumber) FROM @InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
			);
			INSERT INTO ZnodePriceTier( PriceListId, SKU, Price, Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
				   SELECT @PriceListId, IP.SKU, IP.TierPrice, IP.TierStartQuantity,  @UserId, @GetDate, @UserId, @GetDate
				   FROM @InsertPrice AS IP 
				   WHERE NOT EXISTS
				   (
					   SELECT TOP 1 1 FROM ZnodePriceTier WHERE ZnodePriceTier.PriceListId = @PriceListId AND  ZnodePriceTier.SKU = IP.SKU AND 
							 ZnodePriceTier.Quantity = IP.TierStartQuantity
				   ) AND  IP.RowNumber IN
				   (
					   SELECT MAX(IPI.RowNumber) FROM @InsertPrice AS IPI WHERE IPI.SKU = IP.SKU AND  IPI.TierStartQuantity = IP.TierStartQuantity
				   );
		END;  
		--SELECT @PriceListId ID , cast(1 As Bit ) Status  
		--SELECT RowNumber , ErrorDescription , SKU , TierStartQuantity , RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate
		--FROM @ErrorLogForInsertPrice;
		SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- COMMIT TRAN ImportProducts;
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
GO
PRINT N'Altering [dbo].[Znode_ImportData]...';


GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportData' )
BEGIN
	DROP PROCEDURE Znode_ImportData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportData](
	  @TableName varchar(200), @NewGUID nvarchar(max), @TemplateId nvarchar(200), @UserId int, @LocaleId int= 1, @DefaultFamilyId int= 0, @IsDebug bit= 0, @PriceListId int= 0,@CountryCode Nvarchar(100) = '',@PortalId int = 0 ,
	  @IsDoNotCreateJob bit = 0 , @IsDoNotStartJob bit = 0, @StepName nvarchar(50) = 'Import' , @StartStepName nvarchar(50) = 'Import' ,
	  @step_id int  = 1 ,@Nextstep_id  int = 3 , @ERPTaskSchedulerId int = 0  )
AS
/*
    Summary :  Import Process call respective import method from @TemplateId 
    Process :  
	EXEC Znode_ImportValidatePimProductData @TableName = 'tempdb..[##SEODetails_61bbcb4c-5b83-49a0-8bb6-48eaf07f9ce0]',@NewGUID = '61bbcb4c-5b83-49a0-8bb6-48eaf07f9ce0' ,@TemplateId = 9,@UserId = 2,@PortalId = 0,@LocaleId = 1,@IsCategory= 1 ,@DefaultFamilyId = 0 ,@ImportHeadName = 'SEODetails', @ImportProcessLogId = 11, @PriceListId = 0, @CountryCode = ''
*/
BEGIN
	 DECLARE @ImportHeadName nvarchar(100), @SPScript nvarchar(max), @DatabaseName nvarchar(100), @ServerName nvarchar(100),
	 @ImportProcessLogId int= 0, @SPScript1 nvarchar(max),@UserName nvarchar(100);
	 DECLARE @GetDate datetime= dbo.Fn_GetDate();
	
	 
	 SELECT TOP 1 @ImportHeadName = Name
	 FROM ZnodeImportTemplate AS zit
		 INNER JOIN
		 ZnodeImportHead AS zih
		 ON zit.ImportHeadId = zih.ImportHeadId
	 WHERE zit.ImportTemplateId = @TemplateId;
	 SET @DatabaseName = DB_NAME();
	 SET @ServerName = @@serverName;
	 SET @UserName = SYSTEM_USER;
	 
	--Generate new process for current import 
	If @ERPTaskSchedulerId = 0 
		INSERT INTO ZnodeImportProcessLog( ImportTemplateId, Status, ProcessStartedDate, ProcessCompletedDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
		   SELECT @TemplateId, dbo.Fn_GetImportStatus( 0 ), @GetDate, NULL, @UserId, @GetDate, @UserId, @GetDate;
	else 
		INSERT INTO ZnodeImportProcessLog( ImportTemplateId, Status, ProcessStartedDate, ProcessCompletedDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate ,ERPTaskSchedulerId)
		   SELECT @TemplateId, dbo.Fn_GetImportStatus( 0 ), @GetDate, NULL, @UserId, @GetDate, @UserId, @GetDate , @ERPTaskSchedulerId;
	
	SET @ImportProcessLogId = @@IDENTITY;
	SET @SPScript1 = N' EXEC Znode_ImportValidatePimProductData @TableName = '''+@TableName+''',@NewGUID = '''+@NewGUID+''' ,@TemplateId = '
					+CONVERT(varchar(100), @TemplateId)+',@UserId = '+CONVERT(varchar(100), @UserId)
					+',@PortalId = '+CONVERT(varchar(100), @PortalId)+
					+',@LocaleId = '+CONVERT(varchar(100), @LocaleId)+',@IsCategory= '+CASE
					WHEN @ImportHeadName IN( 'Pricing', 'Product', 'Inventory' ) THEN '0'
					ELSE '1'
					END+' ,@DefaultFamilyId = '+CONVERT(varchar(100), @DefaultFamilyId)+' ,@ImportHeadName = '''+@ImportHeadName+''', @ImportProcessLogId = '
					+CONVERT(varchar(100), @ImportProcessLogId)+', @PriceListId = '+CONVERT(varchar(100), @PriceListId)
					+ ', @CountryCode = ''' + @CountryCode  + '''';




	
	IF @@VERSION LIKE '%Azure%' OR @@VERSION LIKE '%Express Edition%'
	BEGIN
	      EXEC sys.sp_sqlexec @SPScript1;
	END;
	ELSE
	BEGIN 
		
		IF @IsDebug = 1
		          BEGIN
		              EXEC sys.sp_sqlexec
		                   @SPScript1;
		              RETURN 0;
		          END;
		--DECLARE @jobId binary(16)
		--SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'Name of Your Job')
		--IF (@jobId IS NOT NULL)
		--BEGIN
		--EXEC msdb.dbo.sp_delete_job @jobId
		--END
		--Add a job

		SET @SPScript1 = N' EXEC Znode_ImportValidatePimProductData @TableName = '''''+@TableName+''''',@NewGUID = '''''+@NewGUID+''''' ,@TemplateId = '+CONVERT(varchar(100), @TemplateId)+',@UserId = '+CONVERT(varchar(100), @UserId)+',@PortalId = '+CONVERT(varchar(100), @PortalId)+',@LocaleId = '+CONVERT(varchar(100), @LocaleId)+',@IsCategory= '+CASE
																																																																										   WHEN @ImportHeadName IN( 'Pricing', 'Product', 'Inventory' ) THEN '0'
																																																																										   ELSE '1'
																																																																										   END+' ,@DefaultFamilyId = '+CONVERT(varchar(100), @DefaultFamilyId)+' ,@ImportHeadName = '''''+@ImportHeadName+''''', @ImportProcessLogId = '+CONVERT(varchar(100), @ImportProcessLogId)+', @PriceListId = '+CONVERT(varchar(100), @PriceListId)
																																																																										   + ', @CountryCode = ''''' + @CountryCode  +'''''';



		DECLARE @jobId binary(16);
		SET @NewGUID = 'Import_'+REPLACE(@NewGUID, '''', '');
		

		IF @IsDoNotCreateJob =0 
		Begin
			SET @SPScript = N'EXEC msdb.dbo.sp_add_job
				  @job_name = '''+@NewGUID+''' ,
				  @enabled = 1,
				  @notify_level_eventlog = 0,
				  @notify_level_email = 2,
				  @notify_level_netsend = 2,
				  @notify_level_page = 2,
				  @delete_level = 3,
				  @category_name = N''[Uncategorized (Local)]'',
				  @owner_login_name = N'''+ @UserName +'''';
			--@job_id = '' + Convert(NVARCHAR(MAX),@jobId ) + '' OUTPUT; '

			EXEC sys.sp_sqlexec @SPScript;

			SET @SPScript = N' EXEC msdb.dbo.sp_add_jobserver
				  @job_name = '''+@NewGUID+''',
				  @server_name = '''+@ServerName+'''';

			EXEC sys.sp_sqlexec @SPScript;
		END
		SET @SPScript = N' EXEC msdb.dbo.sp_add_jobstep
              @job_name = '''+ @NewGUID +''',
              @step_name = N'''+ @StepName +''',
			  @step_id =  ' + Convert(nvarchar(10),@step_id ) +  ',
			  @cmdexec_success_code = 0,
              @on_success_action = ' + Convert(nvarchar(10),@Nextstep_id ) +  ',
              @on_fail_action = '    + Convert(nvarchar(10),@Nextstep_id ) +  ',
			  @retry_attempts = 0,
              @retry_interval = 0,
              @os_run_priority = 0,
              @subsystem = N''TSQL'',
              @command = N'''+ @SPScript1 +''',
              @database_name = '''+@DatabaseName+''',
              @flags = 0 ';
		EXEC sys.sp_sqlexec @SPScript;

		DECLARE @ReturnCode tinyint= 0; -- 0 (success) or 1 (failure)
		IF @IsDoNotStartJob = 0 
		Begin
			SET @SPScript = N'EXEC @ReturnCode = msdb.dbo.sp_start_job 
				  @job_name = '''+ @NewGUID +''',
				  @server_name = '''+ @ServerName +''',
				  @step_name = N''' + @StartStepName +'''';

			EXEC sys.SP_EXECUTESQL @SPScript, N'@ReturnCode TINYINT OUT', @ReturnCode = @ReturnCode OUT;
		END 
		--      select 3  , @SPScript

		--RETURN (@ReturnCode)
		IF @ReturnCode = 1
		BEGIN
			UPDATE ZnodeImportProcessLog
			  SET Status = dbo.Fn_GetImportStatus( 3 ), ProcessCompletedDate = @GetDate
			WHERE ImportProcessLogId = @ImportProcessLogId
		END;

		--EXEC msdb.dbo.sp_delete_job @job_id=N'4470113c-a592-41d8-951e-45d9982071da', @delete_unused_schedule=1
	END;
END;
GO
PRINT N'Altering [dbo].[ZnodeReport_DashboardTopBrands]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'ZnodeReport_DashboardTopBrands' )
BEGIN
	DROP PROCEDURE ZnodeReport_DashboardTopBrands
END
GO
CREATE PROCEDURE [dbo].[ZnodeReport_DashboardTopBrands]
(       
	@PortalId       VARCHAR(MAX)  = '',
	@BeginDate      DATE          = NULL,
	@EndDate        DATE          = NULL
	
)
AS 
   /*  Summary:- This procedure is used to get the order details 
    Unit Testing:
     EXEC ZnodeReport_DashboardTopBrands

	*/
     BEGIN
	 BEGIN TRY
        SET NOCOUNT ON;
		
		DECLARE @TopBrand TABLE (Brands nvarchar(100), Orders int , Sales  Nvarchar(100),Symbol NVARCHAR(10)) 
		
		INSERT INTO @TopBrand (Brands, Orders, Sales,Symbol )
			SELECT ZOOA.AttributeValue Brands,count(Distinct zood.OmsOrderDetailsId) Orders ,
			--[dbo].[Fn_GetDefaultPriceRoundOff]( Sum(zoolit.price)) Sales
			[dbo].[Fn_GetDefaultPriceRoundOff]( Sum(zoolit.Quantity * zoolit.price)) Sales
			,ISNULL(ZC.Symbol,[dbo].[Fn_GetDefaultCurrencySymbol]()) Symbol
			from ZnodeOmsOrderLineItems zoolit INNER JOIN ZnodeOmsOrderDetails zood 
			ON zoolit.OmsOrderDetailsId = zood.OmsOrderDetailsId LEFT JOIN ZnodeCurrency ZC ON (ZC.CurrencyCode = ZOOD.CurrencyCode )
			INNER JOIN ZnodeOmsOrderAttribute ZOOA ON zoolit.OmsOrderLineItemsId = ZOOA.OmsOrderLineItemsId AND  ZOOA.AttributeCode = 'Brand' 
			AND ZOOA.AttributeValue IS NOT NULL
			WHERE ZOOD.IsActive =1 AND 
			 ((EXISTS
				   (
					   SELECT TOP 1 1
					   FROM dbo.split(@PortalId, ',') SP
					   WHERE CAST(zood.PortalId AS VARCHAR(100)) = SP.Item
							 OR @PortalId = ''
				   ))
			  )
			 AND (CAST(ZOOD.OrderDate AS DATE) BETWEEN CASE
													WHEN @BeginDate IS NULL
													THEN CAST(ZOOD.OrderDate AS DATE)
													ELSE @BeginDate
												 END AND CASE
														   WHEN @EndDate IS NULL
														   THEN CAST(ZOOD.OrderDate AS DATE)
														   ELSE @EndDate
														END)
			Group by ZOOA.AttributeValue,ISNULL(ZC.Symbol,[dbo].[Fn_GetDefaultCurrencySymbol]()) 

			select top 5 Brands, Orders, Sales  ,Symbol   from @TopBrand Order by  Convert(numeric,Sales )  desc 	
			END TRY
			BEGIN CATCH
			DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardTopBrands @PortalId = '+@PortalId+',@BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'ZnodeReport_DashboardTopBrands',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
			END CATCH

	 END;
GO
PRINT N'Altering [dbo].[ZnodeReport_DashboardTopProducts]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'ZnodeReport_DashboardTopProducts' )
BEGIN
	DROP PROCEDURE ZnodeReport_DashboardTopProducts
END
GO
CREATE PROCEDURE [dbo].[ZnodeReport_DashboardTopProducts]
(       
	@PortalId       VARCHAR(MAX)  = '',
	@BeginDate      DATE          = NULL,
	@EndDate        DATE          = NULL
)
AS 
/*
     Summary:- This procedure is used to get the order details 
     Unit Testing:
     EXEC ZnodeReport_DashboardTopProducts
	*/
     BEGIN
	 BEGIN TRY
        SET NOCOUNT ON;
		Declare @TopOrders TABLE (Products nvarchar(100), Orders int , Sales Nvarchar(100),Symbol NVARCHAR(10)) 
		INSERT INTO @TopOrders (Products, Orders, Sales,Symbol )
			SELECT ProductName,count(zood.OmsOrderDetailsId) Orders ,
			--[dbo].[Fn_GetDefaultPriceRoundOff]( Sum(zoolit.price)) Sales
			[dbo].[Fn_GetDefaultPriceRoundOff]( Sum(zoolit.Quantity * zoolit.price)) Sales
			,ISNULL(ZC.Symbol,[dbo].[Fn_GetDefaultCurrencySymbol]()) Symbol
			from ZnodeOmsOrderLineItems zoolit INNER JOIN ZnodeOmsOrderDetails zood 
			ON zoolit.OmsOrderDetailsId = zood.OmsOrderDetailsId 		LEFT JOIN ZnodeCurrency ZC ON (ZC.CurrencyCode = ZOOD.CurrencyCode )
				              
			WHERE ZOOD.IsActive =1 AND 
			 ((EXISTS
				   (
					   SELECT TOP 1 1
					   FROM dbo.split(@PortalId, ',') SP
					   WHERE CAST(zood.PortalId AS VARCHAR(100)) = SP.Item
							 OR @PortalId = ''
				   ))
			  )
			 AND (CAST(ZOOD.OrderDate AS DATE) BETWEEN CASE
													WHEN @BeginDate IS NULL
													THEN CAST(ZOOD.OrderDate AS DATE)
													ELSE @BeginDate
												 END AND CASE
														   WHEN @EndDate IS NULL
														   THEN CAST(ZOOD.OrderDate AS DATE)
														   ELSE @EndDate
														END)
			Group by zoolit.ProductName,zoolit.sku ,ISNULL(ZC.Symbol,[dbo].[Fn_GetDefaultCurrencySymbol]()) 

			select top 5 Products, Orders, Sales  ,Symbol   from @TopOrders Order by  Convert(numeric,Sales )  desc 	
			
			END TRY
			BEGIN CATCH
			DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardTopProducts @PortalId = '+@PortalId+',@BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'ZnodeReport_DashboardTopProducts',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
			END CATCH	
     END;
GO
PRINT N'Altering [dbo].[Znode_ReturnOrderLineItem]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ReturnOrderLineItem' )
BEGIN
	DROP PROCEDURE Znode_ReturnOrderLineItem
END
GO
CREATE PROCEDURE [dbo].[Znode_ReturnOrderLineItem]
(	@OrderLineItemIds nvarchar(500),
	@OmsOrderDetailsId int,
	@OrderStateName nvarchar(100) ,
	@ReasonForReturnId int,
	@Quantity [numeric](28, 6),
	@IsShippingReturn bit,
	@ShippingCost [numeric](28, 6),
	@Status BIT OUT
)
AS

/*
begin tran
exec Znode_DeleteOrderById 6
rollback tran
*/
BEGIN
  SET NOCOUNT ON
   BEGIN  TRAN _TranReturnOrderLineItem
  BEGIN TRY 


			DECLARE @RETURNSTATEID INT, @ORDERSHIPMENTID INT
			
			select  top 1 @ORDERSHIPMENTID = OmsOrderShipmentId from ZNODEOMSORDERLINEITEMS where OmsOrderDetailsId = @OmsOrderDetailsId and IsActive = 1

			SELECT @RETURNSTATEID=OMSORDERSTATEID FROM ZNODEOMSORDERSTATE WHERE ORDERSTATENAME = @OrderStateName

			UPDATE ZNODEOMSORDERLINEITEMS
			SET ISACTIVE = 1 ,OMSORDERDETAILSID = @OmsOrderDetailsId ,
			ORDERLINEITEMSTATEID = @RETURNSTATEID , 
			RmaReasonForReturnId = @ReasonForReturnId,
			OmsOrderShipmentId= @ORDERSHIPMENTID,
			Quantity = CASE WHEN Quantity =0 THEN 0 ELSE @Quantity END,
			ShippingCost = CASE WHEN ISNULL(ShippingCost,0) =0 THEN 0 ELSE @ShippingCost END,
			IsShippingReturn =  @IsShippingReturn
			WHERE OMSORDERLINEITEMSID 
			IN(
			SELECT ITEM FROM DBO.SPLIT(@OrderLineItemIds,',')) OR 
			PARENTOMSORDERLINEITEMSID IN(SELECT ITEM FROM DBO.SPLIT(@OrderLineItemIds,',')
			)   


            SELECT 1 AS ID , CAST(1 AS BIT) AS Status;
        SET @Status = 1;    
		 COMMIT  TRAN _TranReturnOrderLineItem
	END TRY
	BEGIN CATCH
	   SELECT 0 AS ID , CAST(0 AS BIT) AS Status;
	    SET @Status = 0;
		ROLLBACK TRAN _TranReturnOrderLineItem
	SELECT ERROR_MESSAGE()
	END CATCH

END
GO
PRINT N'Altering [dbo].[Znode_RevertOrderInventory]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_RevertOrderInventory' )
BEGIN
	DROP PROCEDURE Znode_RevertOrderInventory
END
GO
CREATE  PROCEDURE [dbo].[Znode_RevertOrderInventory]
(   @OmsOrderDetailsId   INT,
    @OmsOrderLineItemIds VARCHAR(2000) = '',
    @Status              BIT OUT,
    @UserId              INT)
AS 
   /* Summary: this proceedure is used to revert the order  inventory in case of order revert
      Unit Testing:
	  begin tran
	  EXEC  Znode_RevertOrderInventory 
      rollback tran
    */
     BEGIN
         BEGIN TRAN ZROI;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             UPDATE ZI
               SET
                   ZI.Quantity = ZI.Quantity + ZOOW.Quantity,
                   ZI.MOdifiedBy = @UserId,
                   ZI.ModifiedDate = @GetDate
             FROM ZnodeOmsOrderWarehouse ZOOW
                  INNER JOIN ZnodeOmsOrderLineItems ZOOLI ON(ZOOLI.OmsOrderLineItemsId = ZOOW.OmsOrderLineItemsId)
                  INNER JOIN ZnodeInventory ZI ON(ZI.WarehouseId = ZOOW.WarehouseId
                                                  AND ZI.SKU = ZOOLI.SKU)
             WHERE ZOOLI.OmsOrderDetailsId = @OmsOrderDetailsId
                   AND EXISTS
             (
                 SELECT TOP 1 1     FROM dbo.split(@OmsOrderLineItemIds, ',') SP WHERE Sp.Item = ZOOLI.OmsOrderLineItemsId OR @OmsOrderLineItemIds = ''
             );

             SET @Status = 1;
             SELECT 1 ID,
                    CAST(1 AS BIT) Status;
             COMMIT TRAN ZROI;
         END TRY
         BEGIN CATCH
              DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			   @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_RevertOrderInventory @OmsOrderDetailsId = '+CAST(@OmsOrderDetailsId AS VARCHAR(200))+',@OmsOrderLineItemIds='+@OmsOrderLineItemIds+',@UserId='+CAST(@UserId AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(200));
             SET @Status = 0;
             SELECT 0 AS ID,
                    CAST(0 AS BIT) AS Status;
			 ROLLBACK TRAN ZROI;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_RevertOrderInventory',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_UpdateInventory]...';


GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_UpdateInventory' )
BEGIN
	DROP PROCEDURE Znode_UpdateInventory
END
GO
CREATE PROCEDURE [dbo].[Znode_UpdateInventory]
(
	@SkuXml xml,
	@PortalId int, 
	@UserId int, 
	@Status bit OUT, 
	@IsDebug bit= 0)
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
		DECLARE @TBL_XmlReturnToTable TABLE
		( 
			OrderLineItemId int, SKU nvarchar(max), InventoryTracking nvarchar(1000), Quantity numeric(28, 6), SequenceNo int IDENTITY
		);
		DECLARE @TBL_ErrorInventoryTracking TABLE
		( 
			SKU nvarchar(max), Quantity numeric(28, 6), InventoryTracking nvarchar(2000)
		);
		INSERT INTO @TBL_XmlReturnToTable( OrderLineItemId, SKU, InventoryTracking, Quantity )
			   SELECT Tbl.Col.value( 'OrderLineItemId[1]', 'INT' ) AS OrderLineItemId, Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' ) AS SKU, Tbl.Col.value( 'InventoryTracking[1]', 'NVARCHAR(2000)' ) AS InventoryTracking, Tbl.Col.value( 'Quantity[1]', 'Numeric(28,6)' ) AS Quantity
			   FROM @SkuXml.nodes( '//ArrayOfOrderWarehouseLineItemsModel/OrderWarehouseLineItemsModel' ) AS Tbl(Col)
			   WHERE Tbl.Col.value( 'InventoryTracking[1]', 'NVARCHAR(2000)' ) <> 'DontTrackInventory' 
			   AND Tbl.Col.value( 'Quantity[1]', 'Numeric(28,6)' ) > 0
			   ;
		DECLARE @Cur_WarehouseId int, @Cur_PortalId int, @Cur_PortalWarehouseId int, @Cur_WarehouseSequence int, @Cur_SKU varchar(200), @Cur_Quantity numeric(28, 6), @Cur_ReOrderLevel numeric(28, 6), @Cur_InventoryId int;
             
	
		DECLARE @RecurringQuantity numeric(28, 6), @BalanceQuantity numeric(28, 6)
		SET @Status = 0; 
      		

		DECLARE @TBL_CalculateQuntity TABLE
		( 
			WarehouseId int, SKU varchar(200), MainQuantity numeric(28, 6), InventoryId int, OrderQuantity numeric(28, 6), UpdatedQuantity numeric(28, 6), WarehouseSequenceId int, InventoryTracking nvarchar(2000)
		);
		DECLARE @TBL_AllwareHouseToportal TABLE
		( 
			WarehouseId int, PortalId int, PortalWarehouseId int, WarehouseSequenceFirst int, WarehouseSequence int, SKU varchar(200), Quantity numeric(28, 6), ReOrderLevel numeric(28, 6), InventoryId int
		);

		INSERT INTO @TBL_AllwareHouseToportal( WarehouseId, PortalId, PortalWarehouseId, SKU, Quantity, ReOrderLevel, InventoryId, WarehouseSequence, WarehouseSequenceFirst )
			SELECT ZPW.WarehouseId, ZPW.PortalId, zpw.PortalWarehouseId, zi.SKU, zi.Quantity, zi.ReOrderLevel, zi.InventoryId, DENSE_RANK() OVER(ORDER BY ZPW.WarehouseId), 1
			FROM dbo.ZnodeInventory AS zi
			INNER JOIN [ZnodePortalWarehouse] AS ZPW ON ZPW.WarehouseId = ZI.WareHouseId AND  ZPW.PortalId = @PortalId
			WHERE EXISTS ( SELECT TOP 1 1  FROM @TBL_XmlReturnToTable AS TBXRT WHERE RTRIM(LTRIM(TBXRT.SKU)) = RTRIM(LTRIM(zi.SKU))) ORDER BY ZPW.Precedence DESC;
			
		INSERT INTO @TBL_AllwareHouseToportal( WarehouseId, PortalId, PortalWarehouseId, SKU, Quantity, ReOrderLevel, InventoryId, WarehouseSequence, WarehouseSequenceFirst )
			SELECT zpaw.WarehouseId, @PortalId, zpaw.PortalWarehouseId, zi.SKU, zi.Quantity, zi.ReOrderLevel, zi.InventoryId, DENSE_RANK() OVER (ORDER BY zpaw.WarehouseId),
			CASE WHEN EXISTS ( SELECT TOP 1 1 FROM @TBL_AllwareHouseToportal WE WHERE WE.SKU = ZI.SKU  ) THEN 2 ELSE 1 END
				FROM dbo.ZnodeInventory AS zi INNER JOIN [dbo].[ZnodePortalAlternateWarehouse] AS zpaw ON zpaw.WarehouseId = ZI.WareHouseId
				WHERE EXISTS ( SELECT TOP 1 1 FROM [ZnodePortalWarehouse] AS a WHERE zpaw.PortalWarehouseId = a.PortalWarehouseId AND  a.PortalId = @PortalId) AND 
				EXISTS ( SELECT TOP 1 1 FROM @TBL_XmlReturnToTable AS TBXRT WHERE RTRIM(LTRIM(TBXRT.SKU)) = RTRIM(LTRIM(zi.SKU))) ORDER BY ZPAW.Precedence DESC;
   
		--Total Avaialble qunatity in all warehouse 
		IF EXISTS ( SELECT TOP 1 1 FROM @TBL_XmlReturnToTable WHERE InventoryTracking = 'DisablePurchasing')
		BEGIN
			INSERT INTO @TBL_ErrorInventoryTracking 
			SELECT TBAHL.SKU, SUM(TBAHL.Quantity), InventoryTracking FROM @TBL_XmlReturnToTable AS TBXML
			LEFT JOIN @TBL_AllwareHouseToportal AS TBAHL ON(TBAHL.SKU = TBXML.SKU) WHERE InventoryTracking = 'DisablePurchasing'
			GROUP BY TBAHL.SKU, InventoryTracking HAVING SUM(TBAHL.Quantity) < 1 ORDER BY TBAHL.SKU;
			IF EXISTS ( SELECT TOP 1 1 FROM @TBL_ErrorInventoryTracking )
			BEGIN
				SET @Status = 0;
				RAISERROR(15600, -1, -1, 'DisablePurchasing');
			END;
		END;
			

			INSERT INTO @TBL_CalculateQuntity
			   SELECT WarehouseId, TBXML.SKU, TBAHL.Quantity, TBAHL.InventoryId, TBXML.Quantity, NULL AS UpdatedQuantity, DENSE_RANK() 
			   OVER(ORDER BY WarehouseSequenceFirst,WarehouseSequence), InventoryTracking
			   FROM @TBL_XmlReturnToTable AS TBXML	
			   inner  JOIN @TBL_AllwareHouseToportal AS TBAHL ON(TBAHL.SKU = TBXML.SKU)
			   ORDER BY  WarehouseSequenceFirst,WarehouseSequence;
			  -- SELECT * FROM @TBL_CalculateQuntity
		
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
			FROM dbo.ZnodeInventory ZI INNER JOIN @TBL_CalculateQuntity TBCQ ON(Zi.InventoryId = TBCQ.InventoryId)
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
		
	
		--	SELECT * FROM @TBL_CalculateQuntity
		--SELECT OrderLineItemId, WarehouseId, @UserId, dbo.Fn_GetDate(), @UserId, dbo.Fn_GetDate() 
		--FROM @TBL_CalculateQuntity AS TBCQ 
		--INNER JOIN @TBL_XmlReturnToTable AS TBXR
		--	   ON(TBXR.SKU = TBCQ.SKU) WHERE UpdatedQuantity IS NOT NULL;


		INSERT INTO ZnodeOmsOrderWarehouse( OmsOrderLineItemsId, WarehouseId,Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
		SELECT OrderLineItemId, WarehouseId,CASE WHEN UpdatedQuantity = 0 THEN MainQuantity ELSE MainQuantity - UpdatedQuantity END , @UserId, dbo.Fn_GetDate(), @UserId, dbo.Fn_GetDate() 
		FROM @TBL_CalculateQuntity AS TBCQ 
		INNER JOIN @TBL_XmlReturnToTable AS TBXR
			   ON(TBXR.SKU = TBCQ.SKU) WHERE UpdatedQuantity IS NOT NULL;

		SELECT SKU, Quantity, InventoryTracking
		FROM @TBL_ErrorInventoryTracking;
		SET @Status = 1;
		COMMIT TRAN UpdateInventory;
	END TRY
	BEGIN CATCH
		SET @Status = 0;
		SELECT SKU, Quantity, InventoryTracking
		FROM @TBL_ErrorInventoryTracking;
		SELECT ERROR_MESSAGE();
		ROLLBACK TRAN UpdateInventory;
	END CATCH;
END;
GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetPimAttributeValues' )
BEGIN
	DROP PROCEDURE Znode_GetPimAttributeValues
END
GO
CREATE  PROCEDURE [dbo].[Znode_GetPimAttributeValues]
( @PimAttributeFamilyId INT = 0,
  @IsCategory           BIT = 0,
  @LocaleId             INT = 0)
AS
   /*
   Summary: This procedure is used to get PimAttributeValues locale wise
			Result is fetched order by DisplayOrder, PimAttributeId
			If IsCategory = 1, FamilyCode is DefaultCategory and IsCategory = 0 then FamilyCode is Default
   Unit Testing:
   begin tran
   EXEC [Znode_GetPimAttributeValues] @PimAttributeFamilyId = 1,@IsCategory=0,@LocaleId=1
   rollback tran

   */
   
     BEGIN
         BEGIN TRY
             IF @LocaleId = 0
                 BEGIN 
				     -- find the default locale id 
                     SELECT TOP 1 @LocaleId = FeatureValues FROM ZnodeGlobalSetting WHERE FeatureName = 'Locale';                                        
                 END;

             -- this block required for the default family use to remove the configurable attribute from family  
             DECLARE @PimAttributeFamilyId2 INT;  
             SELECT @PimAttributeFamilyId2 = PimAttributeFamilyId FROM ZnodePimAttributeFamily WHERE IsDefaultFamily = 1 AND IsCategory = 0;
                                      
             IF @PimAttributeFamilyId = 0
                 BEGIN  
				     -- find the default family id
                     SET @PimAttributeFamilyId = @PimAttributeFamilyId2;
                 END;
             DECLARE @TBL_Detailrecord TABLE

             (DisplayOrder               INT,
              DisplayOrder1              INT,
              PimAttributeFamilyId       INT,
              FamilyCode                 VARCHAR(300),
              PimAttributeId             INT,
              PimAttributeGroupId        INT,
              AttributeTypeId            INT,
              AttributeTypeName          VARCHAR(300),
              AttributeCode              VARCHAR(300),
              IsRequired                 BIT,
              IsLocalizable              BIT,
              IsFilterable               BIT,
              AttributeName              NVARCHAR(600),
              AttributeValue             VARCHAR(300),
              PimAttributeValueId        INT,
              PimAttributeDefaultValueId INT,
              AttributeDefaultValueCode  VARCHAR(200),
              AttributeDefaultValue      NVARCHAR(300),
              RowId                      INT,
              IsEditable                 BIT,
              ControlName                VARCHAR(300),
              ValidationName             VARCHAR(100),
              SubValidationName          VARCHAR(300),
              RegExp                     VARCHAR(300),
              ValidationValue            VARCHAR(300),
              IsRegExp                   BIT,
              IsConfigurable             BIT,
              HelpDescription            VARCHAR(MAX),DisplayOrderDefault INT 
             );
             -- temp table to store value on temporary basis

              INSERT INTO @TBL_Detailrecord
              (DisplayOrder,PimAttributeFamilyId,FamilyCode,PimAttributeId,PimAttributeGroupId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,
			  IsLocalizable,IsFilterable,AttributeName,AttributeValue,PimAttributeValueId,PimAttributeDefaultValueId,AttributeDefaultValueCode,AttributeDefaultValue,RowId
			  ,IsEditable,ControlName,ValidationName,SubValidationName,RegExp,ValidationValue,IsRegExp,IsConfigurable,HelpDescription,DisplayOrderDefault)
                  
		      SELECT DISTINCT ZPA.displayorder,ZPAF.PimAttributeFamilyId,ZPAF.FamilyCode,ZPA.PimAttributeId,ZPFGM.PimAttributeGroupId,ZPA.AttributeTypeId,ZAT.AttributeTypeName,
              ZPA.AttributeCode,ZPA.IsRequired,ZPA.IsLocalizable,ZPA.IsFilterable,ZPAL.AttributeName,'' AS AttributeValue,NULL AS PimAttributeValueId,VPDV.PimAttributeDefaultValueId,
			  VPDV.AttributeDefaultValueCode,VPDV.AttributeDefaultValue,ISNULL(NULL, 0) AS RowId,ISNULL(VPDV.IsEditable, 1) AS IsEditable,ZAIV.ControlName,
			  ZAIV.Name AS ValidationName,ZAIVR.ValidationName AS SubValidationName,ZAIVR.RegExp,ZPAV.Name AS ValidationValue,
              CAST(CASE WHEN ZAIVR.RegExp IS NULL THEN 0 ELSE 1  END AS BIT) AS IsRegExp,ZPA.IsConfigurable,ZPA.HelpDescription ,VPDV.DisplayOrder                                                                                                                                                                                              
              FROM dbo.ZnodePimAttributeFamily AS ZPAF
			  INNER JOIN dbo.ZnodePimFamilyGroupMapper AS ZPFGM ON(ZPAF.PimAttributeFamilyId = ZPFGM.PimAttributeFamilyId)
			  INNER JOIN [dbo].[ZnodePimAttribute] AS ZPA ON(ZPFGM.PimAttributeId = ZPA.PimAttributeId  AND ZPA.IsPersonalizable = 0)
              LEFT JOIN [dbo].ZnodeAttributeType AS ZAT ON(ZPA.AttributeTypeId = ZAT.AttributeTypeId)
              LEFT JOIN [dbo].[ZnodePimAttributeLocale] AS ZPAL ON(ZPAL.LocaleId = @LocaleId  AND ZPAL.PimAttributeId = ZPA.PimAttributeId) 
              LEFT JOIN View_PimDefaultValue AS VPDV ON(VPDV.PimAttributeId = ZPA.PimAttributeId  AND VPDV.LocaleId = @LocaleId)                                                              
              LEFT JOIN [dbo].ZnodePimAttributeValidation AS ZPAV ON(ZPAV.PimAttributeId = ZPA.PimAttributeId)
              LEFT JOIN [dbo].ZnodeAttributeInputValidation AS ZAIV ON(ZPAV.InputValidationId = ZAIV.InputValidationId)
              LEFT JOIN [dbo].ZnodeAttributeInputValidationRule AS ZAIVR ON(ZPAV.InputValidationRuleId = ZAIVR.InputValidationRuleId)
              WHERE(ZPAF.PimAttributeFamilyId = @PimAttributeFamilyId OR ZPAF.IsDefaultFamily = 1) AND ZPAF.IsCategory = @IsCategory;
                                                   				
             -- changes for isconfigurable attribute 
             SELECT PimAttributeFamilyId,FamilyCode,PimAttributeId,PimAttributeGroupId,AttributeTypeId,AttributeTypeName,AttributeCode,IsRequired,IsLocalizable,
			 IsFilterable,AttributeName,AttributeValue,PimAttributeValueId,PimAttributeDefaultValueId,AttributeDefaultValueCode,AttributeDefaultValue,RowId,
			 IsEditable,ControlName,ValidationName,SubValidationName,RegExp,ValidationValue,IsRegExp,HelpDescription  FROM @TBL_Detailrecord                        
             ORDER BY CASE WHEN DisplayOrder IS NULL THEN 0 ELSE 1  END, DisplayOrder,PimAttributeId,DisplayOrderDefault;                     
                      
         END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPimAttributeValues @PimAttributeFamilyId = '+CAST(@PimAttributeFamilyId AS VARCHAR(50))+',@IsCategory='+CAST(@IsCategory AS VARCHAR(50))+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPimAttributeValues',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetProductsAttributeValue' )
BEGIN
	DROP PROCEDURE Znode_GetProductsAttributeValue
END
GO
CREATE PROCEDURE [dbo].[Znode_GetProductsAttributeValue]
(   @PimProductId  VARCHAR(MAX),
    @AttributeCode VARCHAR(MAX),
    @LocaleId      INT = 0,
	@IsPublish bit = 0  )
AS
/* 
    
     Summary:- This Procedure is used to get the product attribute values 
			   The result is fetched from all locale for ProductId provided
     Unit Testing 
     EXEC Znode_GetProductsAttributeValue_1 '2146','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',0
	 SELECT * FROM ZnodePIMProduct
	 EXEC Znode_GetProductsAttributeValue '121','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',1
	 
	 EXEC Znode_GetProductsAttributeValue '121','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',2,@IsPublish =1 
    
*/	
	 BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 		
				DECLARE @TBL_AttributeValue TABLE (PimAttributeValueId INT,PimProductId INT,AttributeValue NVARCHAR(MAX),PimAttributeId INT)
				DECLARE @TBL_AttributeDefault TABLE (PimAttributeId INT,AttributeDefaultValueCode VARCHAR(100),IsEditable BIT,AttributeDefaultValue NVARCHAR(MAX),DisplayOrder INT)
				DECLARE @DefaultLocaleId INT = DBO.FN_GetDefaultLocaleId()
				DECLARE @TBL_MediaValue TABLE (PimAttributeValueId INT,PimProductId INT,MediaPath NVARCHAR(MAX),PimAttributeId INT ,LocaleId INT )
				DECLARE @TBL_PimProductId TABLE (PimProductId INT)
			
				
				INSERT INTO @TBL_PimProductId 
				SELECT Item FROM dbo.Split( @PimProductId, ',' ) AS SP 
				
				INSERT INTO @TBL_MediaValue
					SELECT ZPAV.PimAttributeValueId	
							,PimProductId
							,ZPPAM.MediaId MediaPath
							,ZPAV.PimAttributeId , ZPPAM.LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER JOIN ZnodePimProductAttributeMedia ZPPAM ON ( ZPPAM.PimAttributeValueId = ZPAV.PimAttributeValueId)
					LEFT JOIN ZnodeMedia ZM ON (Zm.Path = ZPPAM.MediaPath)  
				
			
				;WITH Cte_GetDefaultData 
				AS 
				(
					SELECT ZPPADV.PimAttributeValueId ,ZPADVL.AttributeDefaultValue ,ZPADVL.LocaleId 
					FROM ZnodePimProductAttributeDefaultValue ZPPADV 
					INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)
					INNER JOIN ZnodePimAttributeDefaultValueLocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )
					WHERE ZPADVL.LocaleID IN (@LocaleId,@DefaultLocaleId)
					AND EXISTS (SELECT TOP 1 1 FROM @TBL_PimProductId TBPP  WHERE TBPP.PimProductId = ZPAV.PimProductId)
					)
				
				,Cte_AttributeValueDefault AS 
				(
				 SELECT PimAttributeValueId ,AttributeDefaultValue ,@DefaultLocaleId LocaleId 
				 FROM Cte_GetDefaultData 
				 WHERE LocaleId = @LocaleId 
				 UNION  
				 SELECT PimAttributeValueId ,AttributeDefaultValue ,@DefaultLocaleId LocaleId 
				 FROM Cte_GetDefaultData a 
				 WHERE LocaleId = @DefaultLocaleId 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)
     			)
				,Cte_AttributeLocaleComma 
				AS 
				(
				SELECT DISTINCT PimAttributeValueId ,SUBSTRING ((SELECT ',' + AttributeDefaultValue 
													FROM Cte_AttributeValueDefault CTEAI 
													WHERE CTEAI.PimAttributeValueId = CTEA.PimAttributeValueId 
													FOR XML PATH ('')   ),2,4000) AttributeDefaultValue , LocaleId
				
				FROM Cte_AttributeValueDefault  CTEA 
				)
				,Cte_AllAttributeData AS 
				(
					SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,ZPPATV.AttributeValue,ZPAV.PimAttributeId,ZPPATV.LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER join ZnodePimProductAttributeTextAreaValue ZPPATV ON (ZPPATV.PimAttributeValueId= ZPAV.PimAttributeValueId)
					INNER JOIN @TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
					UNION ALL
					
					SELECT PimAttributeValueId,TBM.PimProductId
							,MediaPath
							,PimAttributeId,LocaleId
					from @TBL_PimProductId TBPP   
					INNER JOIN @TBL_MediaValue TBM ON (TBM.PimProductId = TBPP.PimProductId)

					UNION ALL 
					SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,ZPAVL.AttributeValue,ZPAV.PimAttributeId,ZPAVL.LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER JOIN ZnodePimAttributeValueLocale  ZPAVL ON ( ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
					INNER JOIN @TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
					WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@AttributeCode,',') SP WHERE (SP.Item = ZPA.AttributeCode  OR SP.Item = CAST(ZPA.PimATtributeId  AS VARCHAR(50)) )) 
					AND ZPAVL.LocaleId IN (@LocaleId,@DefaultLocaleId)
					 
					UNION ALL
					SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,CS.AttributeDefaultValue,ZPAV.PimAttributeId,LocaleId
					FROM ZnodePimAttributeValue ZPAV
					INNER JOIN Cte_AttributeLocaleComma CS ON (ZPAV.PimAttributeValueId = CS.PimAttributeValueId)
					INNER JOIN @TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
				)
				, Cte_AttributeFirstLocal AS 
				(
					SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
					FROM Cte_AllAttributeData
					WHERE LocaleId = @LocaleId
				)
				,Cte_DefaultAttributeValue AS 
				(
					SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
					FROM Cte_AttributeFirstLocal
					UNION ALL 
					SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
					FROM Cte_AllAttributeData CTAAD
					WHERE LocaleId = @DefaultLocaleId
					AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_AttributeFirstLocal CTRT WHERE CTRT.PimAttributeValueId = CTAAD.PimAttributeValueId   )
			 	)

				INSERT INTO @TBL_AttributeValue
				SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
				FROM  Cte_DefaultAttributeValue 
				
				If @IsPublish = 1 
				Begin
				
					DECLARE @Tlb_ReadMultiSelectValue TABLE ( AttributeDefaultValueCode NVARCHAR(300),PimAttributeId INT)
					INSERT INTO @Tlb_ReadMultiSelectValue ( AttributeDefaultValueCode ,PimAttributeId ) 
					SELECT zpav.AttributeDefaultValueCode,zpa.PimAttributeId 
					   FROM ZnodePimAttributeDefaultValue AS zpav 
					   RIGHT  OUTER JOIN dbo.ZnodePimAttribute AS zpa ON zpav.PimAttributeId = zpa.PimAttributeId
					   INNER JOIN dbo.ZnodeAttributeType AS zat ON zpa.AttributeTypeId = zat.AttributeTypeId
					   WHERE 
					   zat.AttributeTypeName IN ('Multi Select')
                    union All 
					 Select ZPA.AttributeCode,ZPA.PimAttributeId   from ZnodePimAttributeValidation ZPAV INNER JOIN ZnodeAttributeInputValidation ZAIV 
					ON ZPAV.InputValidationId = ZAIV.InputValidationId 
					INNER JOIN ZnodePimAttribute ZPA ON ZPAV.PimAttributeId = ZPA.PimAttributeId
					where ZAIV.Name  in ('IsAllowMultiUpload') and ltrim(rtrim(ZPAV.Name)) = 'true'
	
					SELECT PimProductId,AttributeValue,ZPA.AttributeCode,TBAV.PimAttributeId FROM @TBL_AttributeValue TBAV
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
					WHERE NOT Exists (Select TOP 1 1 FROM @Tlb_ReadMultiSelectValue where PimAttributeId = TBAV.PimAttributeId) 
					UNION ALL 
					Select PimProductId, SUBSTRING((Select ','+ CAST(ZPAXML.AttributeValue  AS VARCHAR(50)) from @TBL_AttributeValue ZPAXML where  
					ZPAXML.PimProductId = TBAV.PimProductId AND ZPAXML.PimAttributeId = TBAV.PimAttributeId FOR XML PATH('') ), 2, 4000) 
					AttributeValue, ZPA.AttributeCode,TBAV.PimAttributeId 
					FROM @TBL_AttributeValue TBAV
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
					WHERE Exists (Select TOP 1 1 FROM @Tlb_ReadMultiSelectValue where PimAttributeId = TBAV.PimAttributeId  ) 
					GROUP BY TBAV.PimProductId ,TBAV.PimAttributeId ,ZPA.AttributeCode
			
				End
				Else 
				Begin	
					SELECT PimProductId, AttributeValue,ZPA.AttributeCode,TBAV.PimAttributeId 
					FROM @TBL_AttributeValue TBAV
					INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
					WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@AttributeCode,',') SP WHERE (SP.Item = ZPA.AttributeCode  OR SP.Item = CAST(ZPA.PimATtributeId  AS VARCHAR(50)) )) 
				End
		 END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
			SET @Status = 0;
			--DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			--@ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductsAttributeValue_1 @PimProductId = '+@PimProductId+
			--',@AttributeCode='+@AttributeCode+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			--SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			--EXEC Znode_InsertProcedureErrorLog
			--	@ProcedureName = 'Znode_GetProductsAttributeValue_1',
			--	@ErrorInProcedure = @Error_procedure,
			--	@ErrorMessage = @ErrorMessage,
			--	@ErrorLine = @ErrorLine,
			--	@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportInsertUpdatePimProduct' )
BEGIN
	DROP PROCEDURE Znode_ImportInsertUpdatePimProduct
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportInsertUpdatePimProduct]
(
    @PimProductDetail  PIMPRODUCTDETAIL READONLY,
    @UserId            INT       ,
    @status            BIT    OUT,
    @IsNotReturnOutput BIT    = 0,
	@CopyPimProductId  INT	  = 0 )
AS
   /*
     Summary : To Insert / Update single Product with multiple attribute values 
     Update Logic: 
*/
     BEGIN
         BEGIN TRAN A;
         BEGIN TRY
			 DECLARE @PimProductId INT;
			 DECLARE @TBL_PimProductId TABLE(PimAttributeValueId INT,ZnodePimAttributeValueLocaleId INT );
			 DECLARE @TBL_CopyPimProductId TABLE(PimAttributeValueId INT,OldPimAttributeValueId INT);
			 DECLARE @PimDefaultFamily INT= dbo.Fn_GetDefaultPimProductFamilyId()
			 DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
			 DECLARE @TBL_DefaultAttributeId TABLE (PimAttributeId INT PRIMARY KEY , AttributeCode VARCHAR(600))
			 DECLARE @TBL_MediaAttributeId TABLE (PimAttributeId INT PRIMARY KEY, AttributeCode VARCHAR(600))
			 DECLARE @TBL_TextAreaAttributeId TABLE (PimAttributeId INT PRIMARY KEY , AttributeCode VARCHAR(600))
			 DECLARE @TBL_MediaAttributeValue TABLE (PimAttributeValueId INT ,LocaleId INT ,AttributeValue VARCHAr(300),MediaId INT)
			 DECLARE @TBL_DefaultAttributeValue TABLE (PimAttributeValueId INT , LocaleId INT , AttributeValue INT)
			 DECLARE @ZnodePimAttributeValue TABLE (PimAttributeValueId  INT, PimAttributeFamilyId INT,PimAttributeId INT);

			 DECLARE @AssociatedProduct VARCHAR(4000);
			 DECLARE @ConfigureAttributeId VARCHAR(4000);
			 DECLARE @ConfigureFamilyId VARCHAR(4000);
			 DECLARE @PimAttributeFamilyId INT;
			 DECLARE @LocaleId INT 
             
			 INSERT INTO @TBL_DefaultAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM  [dbo].[Fn_GetDefaultAttributeId] ()
			 
			 INSERT INTO @TBL_MediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM [dbo].[Fn_GetProductMediaAttributeId]()

			 INSERT INTO @TBL_TextAreaAttributeId (PimAttributeId ,AttributeCode)
			 SELECT PimAttributeId, AttributeCode   FROM [dbo].[Fn_GetTextAreaAttributeId]()

			 
			 SELECT TOP 1 @PimAttributeFamilyId = PimAttributeFamilyId
                FROM @PimProductDetail;

			 SELECT TOP 1 @LocaleId = LocaleId
                FROM @PimProductDetail;

             -- Retrive input productId from @PimProductDetail table ( having multiple attribute values with common productId) 

             SELECT TOP 1 @PimProductId = PimProductId
             FROM @PimProductDetail;
			
             IF ISNULL(@PimProductId, 0) = 0
                 BEGIN
                     INSERT INTO ZnodePimProduct
                     (PimAttributeFamilyId,
                      CreatedBy,
                      CreatedDate,
                      ModifiedBy,
                      ModifiedDate
                     )
                            SELECT @PimAttributeFamilyId,
                                   @UserId,
                                   @GetDate,
                                   @UserId,
                                   @GetDate;
                     SET @PimProductId = SCOPE_IDENTITY();
                 END;
             ELSE 
                 BEGIN
                     UPDATE ZNodePimProduct
                       SET
                           PimAttributeFamilyId = @PimAttributeFamilyId,
						   IsProductPublish = 0 ,
                           ModifiedBy = @UserId,
                           ModifiedDate = @GetDate
                     WHERE PimProductId = @PimProductId;
            									
					 INSERT INTO @TBL_PimProductId(PimAttributeValueId)
					 SELECT ZPAV.PimAttributeValueId
                     FROM ZnodePimAttributeValue ZPAV
					 INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId AND ( @localeID = @DefaultLocaleId OR ZPA.IsLocalizable = 1 OR EXISTS (SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FN WHERE FN.PimAttributeId = ZPAV.PimAttributeId)))
					 INNER JOIN ZnodePimFamilyGroupMapper ZPFGMI  ON (ZPFGMI.PimAttributeId = ZPAV.PimAttributeId AND ZPFGMI.PimAttributeFamilyId = @PimAttributeFamilyId)
					 WHERE ZPAV.PimProductId = @PimProductId
					 AND NOT EXISTS
                            (
                                SELECT TOP 1 1
                                FROM @PimProductDetail TBPDI
                                WHERE TBPDI.PimAttributeId = ZPAV.PimAttributeId
                                      AND TBPDI.PimProductId = ZPAV.PimProductId
							 )
                     
				    --  SELECT * FROM @TBL_PimProductId

			
                     DELETE FROM ZnodePimAttributeValueLocale
                     WHERE EXISTS
                     (
                         SELECT TOP 1 1
                         FROM @TBL_PimProductId TBPD
                         WHERE TBPD.PimAttributeValueId = ZnodePimAttributeValueLocale.PimAttributeValueId 
								
                     ) AND LocaleId = @LocaleId;
					 DELETE  ZnodePimProductAttributeDefaultValue 
					  WHERE EXISTS
                     (
                         SELECT TOP 1 1
                         FROM @TBL_PimProductId TBPD
                         WHERE TBPD.PimAttributeValueId = ZnodePimProductAttributeDefaultValue.PimAttributeValueId 
								
                     ) AND LocaleId = @LocaleId;
					 DELETE FROM ZnodePimProductAttributeMedia 
					  WHERE EXISTS
                     (
                         SELECT TOP 1 1
                         FROM @TBL_PimProductId TBPD
                         WHERE TBPD.PimAttributeValueId = ZnodePimProductAttributeMedia.PimAttributeValueId 
								
                     ) 
					 AND LocaleId = @LocaleId;

					-- SELECT * FROM @TBL_PimProductId

					 DELETE FROM ZnodePimProductAttributeTextAreaValue
					   WHERE EXISTS
                     (
                         SELECT TOP 1 1
                         FROM @TBL_PimProductId TBPD
                         WHERE TBPD.PimAttributeValueId = ZnodePimProductAttributeTextAreaValue.PimAttributeValueId 
								
                     ) AND LocaleId = @LocaleId ;

                     DELETE FROM ZnodePimAttributeValue
                     WHERE EXISTS
                     (
                         SELECT TOP 1 1
                         FROM @TBL_PimProductId TBPD
                         WHERE TBPD.PimAttributeValueId = ZnodePimAttributeValue.PimAttributeValueId
                     )
					 AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeValueLocale ZPVD WHERE ZPVD.PimAttributeValueId = ZnodePimAttributeValue.PimAttributeValueId )
					 AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeTextAreaValue ZPVD WHERE ZPVD.PimAttributeValueId = ZnodePimAttributeValue.PimAttributeValueId )
					 AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimProductAttributeDefaultValue ZPVD WHERE ZPVD.PimAttributeValueId = ZnodePimAttributeValue.PimAttributeValueId )
					 ;
                 END;
		
		    MERGE INTO ZnodePimAttributeValue TARGET
              USING @pimProductDetail SOURCE
              ON(
				TARGET.PimProductId = @PimProductId
                AND TARGET.PimAttributeId = SOURCE.PimAttributeId)
                --AND ISNULL(TARGET.PimAttributeFamilyId, 0) = ISNULL(SOURCE.PimAttributeFamilyId, 0))
                 WHEN MATCHED
                 THEN UPDATE SET
                                 TARGET.PimAttributeFamilyId = CASE
                                                                   WHEN Source.PimAttributeFamilyId = 0
                                                                   THEN NULL
                                                                   ELSE Source.PimAttributeFamilyId
                                                               END,
                                 --TARGET.PimAttributeDefaultValueId = CASE
                                 --                                        WHEN SOURCE.ProductAttributeDefaultValueId = 0
                                 --                                        THEN NULL
                                 --                                        ELSE SOURCE.ProductAttributeDefaultValueId
                                 --                                    END, 
                                 -- ,TARGET.AttributeValue					= SOURCE.AttributeValue
                                 TARGET.CreatedBy = @UserId,
                                 TARGET.CreatedDate = @GetDate,
                                 TARGET.ModifiedBy = @UserId,
                                 TARGET.ModifiedDate = @GetDate
                 WHEN NOT MATCHED
                 THEN INSERT(PimAttributeFamilyId,
                             PimProductId,
                             PimAttributeId,
                             PimAttributeDefaultValueId,
                             --,AttributeValue
                             CreatedBy,
                             CreatedDate,
                             ModifiedBy,
                             ModifiedDate) VALUES
             (CASE
                  WHEN Source.PimAttributeFamilyId = 0
                  THEN @PimDefaultFamily
                  ELSE Source.PimAttributeFamilyId
              END,
              @PimProductId,
              SOURCE.PimAttributeId,
              CASE
                  WHEN SOURCE.ProductAttributeDefaultValueId = 0
                  THEN NULL
                  ELSE SOURCE.ProductAttributeDefaultValueId
              END, 
              --,SOURCE.AttributeValue
              @UserId,
              @GetDate,
              @UserId,
              @GetDate
             )
             --WHEN NOT MATCHED BY SOURCE AND TARGET.PimProductId = @PimProductId
             --                               AND Target.PimAttributeFamilyId IS NOT NULL
             --THEN DELETE
             OUTPUT INSERTED.PimAttributeValueId,
                    INSERTED.PimAttributeFamilyId,
                    INSERTED.PimAttributeId
                    INTO @ZnodePimAttributeValue;
        		 
		INSERT INTO @TBL_MediaAttributeValue (PimAttributeValueId,LocaleId , AttributeValue,MediaId)
		SELECT a.PimAttributeValueId,
                        b.LocaleId,
                         zm.Path AttributeValue
						 ,ZM.MediaId
        FROM @ZnodePimAttributeValue AS a
        INNER JOIN @PimProductDetail AS b ON(a.PimAttributeId = b.PimAttributeId
                                                AND ISNULL(a.PimAttributeFamilyId, 0) = ISNULL(b.PimAttributeFamilyId, 0))
		INNER JOIN @TBL_MediaAttributeId c ON ( c.PimAttributeId  = b.PimAttributeId )
		INNER JOIN ZnodeMedia ZM ON (EXISTS (SELECT TOP 1 1 FROM dbo.split(b.AttributeValue ,',') SP WHERE sp.Item = ZM.MediaId ))
		
		DELETE FROM ZnodePimProductAttributeMedia 
		WHERE EXISTS 
		 (SELECT TOP 1 1 FROM @TBL_MediaAttributeValue TBLM WHERE ZnodePimProductAttributeMedia.PimAttributeValueId = TBLM.PimAttributeValueId 
		 AND TBLM.MediaId <> ZnodePimProductAttributeMedia.MediaId  AND ZnodePimProductAttributeMedia.Localeid = @LocaleId)



		MERGE INTO ZnodePimProductAttributeMedia TARGET 
		USING @TBL_MediaAttributeValue SOURCE 
		ON (        TARGET.PimAttributeValueId = SOURCE.PimAttributeValueId
		        AND TARGET.MediaPAth = SOURCE.AttributeValue
                  AND TARGET.LocaleId = SOURCE.LocaleId)
		WHEN MATCHED THEN 
		UPDATE SET
                                 TARGET.MediaPath = SOURCE.AttributeValue,
						   TARGET.MediaId   = SOURCE.MediaId,
                                 TARGET.CreatedBy = @UserId,
                                 TARGET.CreatedDate = @GetDate,
                                 TARGET.ModifiedBy = @UserId,
                                 TARGET.ModifiedDate = @GetDate
                 WHEN NOT MATCHED
                 THEN 
		    INSERT(PimAttributeValueId,
                             LocaleId,
                             MediaPath,
							 MediaId ,
                             CreatedBy,
                             CreatedDate,
                             ModifiedBy,
                             ModifiedDate) 
			VALUES
             (SOURCE.PimAttributeValueId,
              SOURCE.LocaleId,
              SOURCE.AttributeValue,
			  SOURCE.MediaId,
              @UserId,
              @GetDate,
              @UserId,
              @GetDate
             );
		 --WHEN NOT MATCHED BY SOURCE AND EXISTS 
		 --(SELECT TOP 1 1 FROM @TBL_MediaAttributeValue TBLM WHERE TARGET.PimAttributeValueId = TBLM.PimAttributeValueId AND TBLM.MediaId = TARGET.MediaId  AND TARGET.Localeid = @LocaleId)
		 --  THEN 
		 --DELETE  ;


	   ;With Cte_TextAreaAttributeValue AS 
		 (
		SELECT a.PimAttributeValueId,
                        b.LocaleId,
                        AttributeValue
        FROM @ZnodePimAttributeValue AS a
        INNER JOIN @PimProductDetail AS b ON(a.PimAttributeId = b.PimAttributeId
                                                AND ISNULL(a.PimAttributeFamilyId, 0) = ISNULL(b.PimAttributeFamilyId, 0))
		INNER JOIN @TBL_TextAreaAttributeId c ON ( c.PimAttributeId  = b.PimAttributeId )
		
		)
		
		MERGE INTO ZnodePimProductAttributeTextAreaValue TARGET 
		USING Cte_TextAreaAttributeValue SOURCE 
		ON (TARGET.PimAttributeValueId = SOURCE.PimAttributeValueId
                AND TARGET.LocaleId = SOURCE.LocaleId)
		WHEN MATCHED THEN 
		UPDATE SET
                                 TARGET.AttributeValue = SOURCE.AttributeValue,
                                 TARGET.CreatedBy = @UserId,
                                 TARGET.CreatedDate = @GetDate,
                                 TARGET.ModifiedBy = @UserId,
                                 TARGET.ModifiedDate = @GetDate
                 WHEN NOT MATCHED
                 THEN 
		    INSERT(PimAttributeValueId,
                             LocaleId,
                             AttributeValue,
                             CreatedBy,
                             CreatedDate,
                             ModifiedBy,
                             ModifiedDate) 
			VALUES
             (SOURCE.PimAttributeValueId,
              SOURCE.LocaleId,
              SOURCE.AttributeValue,
              @UserId,
              @GetDate,
              @UserId,
              @GetDate
             );
		-- SELECT a.PimAttributeValueId,
  --                      b.LocaleId,
  --                      d.PimAttributeDefaultValueId  AttributeValue,b.PimAttributeId
  --      FROM @ZnodePimAttributeValue AS a
  --        INNER JOIN @PimProductDetail AS b ON(a.PimAttributeId = b.PimAttributeId
  --                                              AND ISNULL(a.PimAttributeFamilyId, 0) = ISNULL(b.PimAttributeFamilyId, 0))
		--INNER JOIN @TBL_DefaultAttributeId c ON ( c.PimAttributeId  = b.PimAttributeId )
		--INNER JOIN ZnodePimAttributeDefaultValue d ON (EXISTS (SELECT TOP 1 1 FROM dbo.split(b.AttributeValue,',') SP WHERE d.PimAttributeId = b.PimAttributeId AND SP.Item = d.AttributeDefaultValueCode))
	



        INSERT INTO @TBL_DefaultAttributeValue (PimAttributeValueId,LocaleId,AttributeValue)  
		SELECT a.PimAttributeValueId,
                        b.LocaleId,
                        d.PimAttributeDefaultValueId  AttributeValue
        FROM @ZnodePimAttributeValue AS a
          INNER JOIN @PimProductDetail AS b ON(a.PimAttributeId = b.PimAttributeId
                                                AND ISNULL(a.PimAttributeFamilyId, 0) = ISNULL(b.PimAttributeFamilyId, 0))
		INNER JOIN @TBL_DefaultAttributeId c ON ( c.PimAttributeId  = b.PimAttributeId )
		INNER JOIN ZnodePimAttributeDefaultValue d ON (EXISTS (SELECT TOP 1 1 FROM dbo.split(b.AttributeValue,',') SP WHERE d.PimAttributeId = b.PimAttributeId AND SP.Item = d.AttributeDefaultValueCode))
	
	     -- SELECT * FROM @TBL_DefaultAttributeValue

		--  SELECT * FROM Cte_DefaultAttributeValue
		DELETE FROM ZnodePimProductAttributeDefaultValue 
		WHERE  EXISTS (SELECT TOP 1 1 FROM @TBL_DefaultAttributeValue TBLAV WHERE TBLAV.PimAttributeValueId = ZnodePimProductAttributeDefaultValue.PimAttributeValueId 
												AND TBLAV.AttributeValue   <> ZnodePimProductAttributeDefaultValue.PimAttributeDefaultValueId 
												 AND ZnodePimProductAttributeDefaultValue.LocaleId = @LocaleId )

		MERGE INTO ZnodePimProductAttributeDefaultValue TARGET 
		USING @TBL_DefaultAttributeValue SOURCE 
		ON (TARGET.PimAttributeValueId = SOURCE.PimAttributeValueId
              AND TARGET.PimAttributeDefaultValueId =  SOURCE.AttributeValue
			    AND TARGET.LocaleId = SOURCE.LocaleId)
		WHEN MATCHED THEN 
		UPDATE SET
                                 TARGET.PimAttributeDefaultValueId = SOURCE.AttributeValue,
                                 TARGET.CreatedBy = @UserId,
                                 TARGET.CreatedDate = @GetDate,
                                 TARGET.ModifiedBy = @UserId,
                                 TARGET.ModifiedDate = @GetDate
                 WHEN NOT MATCHED
                 THEN 
		    INSERT(PimAttributeValueId,
                             LocaleId,
                             PimAttributeDefaultValueId,
                             CreatedBy,
                             CreatedDate,
                             ModifiedBy,
                             ModifiedDate) 
			VALUES
             (SOURCE.PimAttributeValueId,
              SOURCE.LocaleId,
              SOURCE.AttributeValue,
              @UserId,
              @GetDate,
              @UserId,
              @GetDate
             );
			 --WHEN NOT MATCHED BY SOURCE  AND EXISTS (SELECT TOP 1 1 FROM @TBL_DefaultAttributeValue TBLAV WHERE TBLAV.PimAttributeValueId = TARGET.PimAttributeValueId 
				--								AND TBLAV.AttributeValue   = TARGET.PimAttributeDefaultValueId  AND TARGET.LocaleId = @LocaleId )
			 --THEN 
			 --DELETE 
			 --;
		
   
			 
		   MERGE INTO ZnodePimAttributeValueLocale TARGET
             USING
             (
                 SELECT a.PimAttributeValueId,
                        b.LocaleId,
                        AttributeValue
                 FROM @ZnodePimAttributeValue AS a
                      INNER JOIN @PimProductDetail AS b ON(a.PimAttributeId = b.PimAttributeId
                                                             AND ISNULL(a.PimAttributeFamilyId, 0) = ISNULL(b.PimAttributeFamilyId, 0))
                 WHERE NOT EXISTS (SELECT TOP 1 1 FROM @TBL_DefaultAttributeId TBLDA WHERE TBLDA.PimAttributeId = b.PimAttributeId  )
			     AND NOT EXISTS (SELECT TOP 1 1 FROM @TBL_MediaAttributeId TBLMA WHERE TBLMA.PimAttributeId = b.PimAttributeId  )
				 AND NOT EXISTS (SELECT TOP 1 1 FROM @TBL_TextAreaAttributeId TBLTA WHERE TBLTA.PimAttributeId = b.PimAttributeId  )
			 ) SOURCE
             ON(TARGET.PimAttributeValueId = SOURCE.PimAttributeValueId
                AND TARGET.LocaleId = SOURCE.LocaleId)
                 WHEN MATCHED
                 THEN UPDATE SET
                                 TARGET.AttributeValue = SOURCE.AttributeValue,
                                 TARGET.CreatedBy = @UserId,
                                 TARGET.CreatedDate = @GetDate,
                                 TARGET.ModifiedBy = @UserId,
                                 TARGET.ModifiedDate = @GetDate
                 WHEN NOT MATCHED
                 THEN INSERT(PimAttributeValueId,
                             LocaleId,
                             AttributeValue,
                             CreatedBy,
                             CreatedDate,
                             ModifiedBy,
                             ModifiedDate) VALUES
             (SOURCE.PimAttributeValueId,
              SOURCE.LocaleId,
              SOURCE.AttributeValue,
              @UserId,
              @GetDate,
              @UserId,
              @GetDate
             );
             SET @AssociatedProduct =
             (
                 SELECT MAX(AssociatedProducts)
                 FROM @PimProductDetail AS a
             );
             INSERT INTO ZnodePimProductTypeAssociation
             (PimParentProductId,
              PimProductId,
              DisplayOrder,
              CreatedBy,
              CreatedDate,
              ModifiedBy,
              ModifiedDate
             )
                    SELECT @PimProductId,
                           Item,
                           ID AS RowId,
                           @UserId,
                           @GetDate,
                           @UserId,
                           @GetDate
                    FROM dbo.Split(@AssociatedProduct, ',') AS b
                         INNER JOIN ZNodePimProduct AS q ON(q.PimProductId = b.Item);
             SET @ConfigureAttributeId =
             (
                 SELECT MAX(ConfigureAttributeIds)
                 FROM @PimProductDetail AS a
             );
             SET @ConfigureFamilyId =
             (
                 SELECT MAX(ConfigureFamilyIds)
                 FROM @PimProductDetail AS a
             );
             INSERT INTO [ZnodePimConfigureProductAttribute]
             (PimProductId,
              PimFamilyId,
              PimAttributeId,
              CreatedBy,
              CreatedDate,
              ModifiedBy,
              ModifiedDate
             )
                    SELECT @PimProductId,
                           @ConfigureFamilyId,
                           q.PimAttributeId,
                           @UserId,
                           @GetDate,
                           @UserId,
                           @GetDate
                    FROM dbo.Split(@ConfigureAttributeId, ',') AS b
                         INNER JOIN ZnodePimAttribute AS q ON(q.PimAttributeId = b.Item)
					WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimConfigureProductAttribute RTR  WHERE  RTR.PimProductId = @PimProductId AND RTR.PimAttributeId = q.PimAttributeId);



             IF @IsNotReturnOutput = 0
                 SELECT @PimProductId AS Id,
                        CAST(1 AS BIT) AS Status;
             SET @status = 1;

			 IF @CopyPimProductId > 0 
			 BEGIN 
			   INSERT INTO ZnodePimAttributeValueLocale  (PimAttributeValueId,LocaleId,AttributeValue,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			   SELECT ZPAVI.PimAttributeValueId,ZPAVL.LocaleId,ZPAVL.AttributeValue,@UserId,@GetDate,@UserId,@GetDate
			   FROM ZnodePimAttributeValueLocale ZPAVL 
			   INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId )
			   INNER JOIN ZnodePimAttributeValue ZPAVI ON (ZPAVI.PimAttributeId = ZPAV.PimAttributeId AND ZPAVI.PimProductId = @PimProductId )
			   WHERE ZPAVL.LocaleId <> dbo.Fn_GetDefaultLocaleId()
			   AND ZPAV.PimProductId = @CopyPimProductId

			    INSERT INTO ZnodePimProductAttributeDefaultValue  (PimAttributeValueId,LocaleId,PimAttributeDefaultValueId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			   SELECT ZPAVI.PimAttributeValueId,ZPAVL.LocaleId,ZPAVL.PimAttributeDefaultValueId,@UserId,@GetDate,@UserId,@GetDate
			   FROM ZnodePimProductAttributeDefaultValue ZPAVL 
			   INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId )
			   INNER JOIN ZnodePimAttributeValue ZPAVI ON (ZPAVI.PimAttributeId = ZPAV.PimAttributeId AND ZPAVI.PimProductId = @PimProductId )
			   WHERE ZPAVL.LocaleId <> dbo.Fn_GetDefaultLocaleId()
			   AND ZPAV.PimProductId = @CopyPimProductId


			   INSERT INTO ZnodePimProductAttributeTextAreaValue  (PimAttributeValueId,LocaleId,AttributeValue,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			   SELECT ZPAVI.PimAttributeValueId,ZPAVL.LocaleId,ZPAVL.AttributeValue,@UserId,@GetDate,@UserId,@GetDate
			   FROM ZnodePimProductAttributeTextAreaValue ZPAVL 
			   INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId )
			   INNER JOIN ZnodePimAttributeValue ZPAVI ON (ZPAVI.PimAttributeId = ZPAV.PimAttributeId AND ZPAVI.PimProductId = @PimProductId )
			   WHERE ZPAVL.LocaleId <> dbo.Fn_GetDefaultLocaleId()
			   AND ZPAV.PimProductId = @CopyPimProductId
			   			   
			   INSERT INTO ZnodePimProductAttributeMedia  (PimAttributeValueId,LocaleId,MediaPath,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			   SELECT ZPAVI.PimAttributeValueId,ZPAVL.LocaleId,ZPAVL.MediaPath,@UserId,@GetDate,@UserId,@GetDate
			   FROM ZnodePimProductAttributeMedia ZPAVL 
			   INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId )
			   INNER JOIN ZnodePimAttributeValue ZPAVI ON (ZPAVI.PimAttributeId = ZPAV.PimAttributeId AND ZPAVI.PimProductId = @PimProductId )
			   WHERE ZPAVL.LocaleId <> dbo.Fn_GetDefaultLocaleId()
			   AND ZPAV.PimProductId = @CopyPimProductId
			   
			 END 

             COMMIT TRAN A;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE()
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ImportInsertUpdatePimProduct @UserId = '+CAST(@UserId AS VARCHAR(50))+',@IsNotReturnOutput='+CAST(@IsNotReturnOutput AS VARCHAR(50))+',@CopyPimProductId='+CAST(@CopyPimProductId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
			ROLLBACK TRAN A;
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ImportInsertUpdatePimProduct',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetPimCatalogAssociatedCategory]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetPimCatalogAssociatedCategory' )
BEGIN
	DROP PROCEDURE Znode_GetPimCatalogAssociatedCategory
END
GO
CREATE PROCEDURE [dbo].[Znode_GetPimCatalogAssociatedCategory]
(	@WhereClause      XML,
	@Rows             INT           = 100,
	@PageNo           INT           = 1,
	@Order_BY         VARCHAR(1000) = '',
	@RowsCount        INT OUT,
	@LocaleId         INT           = 1,
	@PimCatalogId     INT           = 0,
	@IsAssociated     BIT           = 0,
	@ProfileCatalogId INT           = 0,
	@PimCategoryId    INT           = -1)
AS
/*
     Summary :- This procedure is used to get the attribute values as per changes 
     Unit Testing 
	 begin tran
     EXEC [dbo].[Znode_GetPimCatalogAssociatedCategory_new] @WhereClause = '',@RowsCount = 0 ,@PimCatalogId = 4 ,@ProfileCatalogId= 0,@IsAssociated = 1,@PimCategoryId = 0
     rollback tran
	 SELECT * FROM ZnodePimCategoryHierarchy
*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             DECLARE @TBL_PimcategoryDetails TABLE
             (PimCategoryId INT,
              CountId       INT,
              RowId         INT
             );
             DECLARE @TBL_CategoryIds TABLE
             (PimCategoryId       INT,
              ParentPimcategoryId INT
             );
             DECLARE @TBL_AttributeValue TABLE
             (PimCategoryAttributeValueId INT,
              PimCategoryId               INT,
              CategoryValue               NVARCHAR(MAX),
              AttributeCode               VARCHAR(300),
              PimAttributeId              INT
             );
             DECLARE @TBL_FamilyDetails TABLE
             (PimCategoryId        INT,
              PimAttributeFamilyId INT,
              AttributeFamilyName  NVARCHAR(MAX)
             );
             DECLARE @TBL_DefaultAttributeValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(600),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder             INT 
             );
             DECLARE @TBL_ProfileCatalogCategory TABLE
             (ProfileCatalogId       INT,
              PimCategoryHierarchyId INT,
              PimCategoryId          INT,
              PimParentCategoryId    INT
             );
             DECLARE @PimCategoryIds VARCHAR(MAX), @PimAttributeIds VARCHAR(MAX);
             IF @ProfileCatalogId > 0
                 BEGIN
						INSERT INTO @TBL_ProfileCatalogCategory(ProfileCatalogId,PimCategoryHierarchyId,PimCategoryId,PimParentCategoryId)
						SELECT ZPCC.ProfileCatalogId,ZPCC.PimCategoryHierarchyId,PimCategoryId,PimParentCategoryId
						FROM ZnodePimCategoryHierarchy AS ZCC
						INNER JOIN ZnodeProfileCategoryHierarchy AS ZPCC ON(ZPCC.PimCategoryHierarchyId = ZCC.PimCategoryHierarchyId)
						WHERE ZPCC.ProfileCatalogId = @ProfileCatalogId AND (ZCC.PimParentCategoryId = @PimCategoryId OR @PimCategoryId = -1);								
									
                     IF @IsAssociated = 1
                     BEGIN
						INSERT INTO @TBL_CategoryIds(PimCategoryId,ParentPimcategoryId)
						SELECT PimCategoryId, ParentPimcategoryId  FROM [dbo].[Fn_GetRecurciveCategoryIds]('', @PimCatalogId) AS FNGTRCT                                      							
						WHERE EXISTS
						(SELECT TOP 1 1 FROM @TBL_ProfileCatalogCategory AS TBPCC WHERE TBPCC.PimCategoryId = FNGTRCT.PimCategoryId OR TBPCC.PimParentCategoryId = FNGTRCT.ParentPimcategoryId);
																																								
                     END;
                     ELSE
					 BEGIN
						INSERT INTO @TBL_CategoryIds(PimCategoryId, ParentPimcategoryId)                                                                                    
						SELECT PimCategoryId,ParentPimcategoryId  FROM [dbo].[Fn_GetRecurciveCategoryIds]('', @PimCatalogId) AS FNGTRCT
						WHERE NOT EXISTS(SELECT TOP 1 1 FROM @TBL_ProfileCatalogCategory AS TBPCC WHERE TBPCC.PimCategoryId = FNGTRCT.PimCategoryId                
						AND ISNULL(TBPCC.PimParentCategoryId, 0) = ISNULL(FNGTRCT.ParentPimcategoryId, 0) ) AND (ISNULL(FNGTRCT.ParentPimcategoryId, 0) = @PimCategoryId
						OR @PimCategoryId = -1);           
                                                                                                                                                                                                                                                                                                                                 
					 IF @PimCategoryId = -1
						BEGIN
						DELETE FROM @TBL_CategoryIds  WHERE PimCategoryId IN (SELECT PimCategoryId FROM @TBL_CategoryIds WHERE ParentPimcategoryId IS NOT NULL );                                                                                                                                                                                                                                     
						END;
					 SET @IsAssociated = 1;
					 END;
                   
                     IF NOT EXISTS (SELECT TOP 1 1 FROM @TBL_CategoryIds)                                                                                           
                        BEGIN
                        INSERT INTO @TBL_CategoryIds(PimCategoryId,ParentPimcategoryId)
                        SELECT -1,0;                                                                                                                                        
                        END;
                 END;
					 ELSE
						BEGIN
						INSERT INTO @TBL_CategoryIds(PimCategoryId,ParentPimcategoryId )
						SELECT PimCategoryId,ParentPimcategoryId 
						FROM [dbo].[Fn_GetRecurciveCategoryIds]('', @PimCatalogId) AS FNGTRCT; 
						
						 SET @IsAssociated = 0                                                                                                                               
						
						END;
						
						SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(100)) FROM @TBL_CategoryIds  FOR XML PATH('')), 2, 4000);
                       
					    -- SELECT    @PimCategoryIds               
                                                
                        INSERT INTO @TBL_PimcategoryDetails(PimCategoryId, CountId,RowId  )                      
                        EXEC Znode_GetCategoryIdForPaging @WhereClause,@Rows,@PageNo,@Order_BY,@RowsCount,@LocaleId,'',@PimCategoryIds,@IsAssociated;
						
						SET @RowsCount = ISNULL((SELECT TOP 1 CountId FROM @TBL_PimcategoryDetails), 0);
																																														
						SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(100)) FROM @TBL_PimcategoryDetails FOR XML PATH('') ), 2, 4000);
																																																																				
						SET @PimAttributeIds = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(100)) FROM [dbo].[Fn_GetCategoryGridAttributeDetails]()
											   FOR XML PATH('')	), 2, 4000);	
						DECLARE @TBL_MediaAttribute TABLE (Id INT ,PimAttributeId INT ,AttributeCode VARCHAR(600) )

						 INSERT INTO @TBL_MediaAttribute (Id,PimAttributeId,AttributeCode )
						 SELECT Id,PimAttributeId,AttributeCode 
						 FROM [dbo].[Fn_GetProductMediaAttributeId]()
																																																															
						INSERT INTO @TBL_AttributeValue(PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
						EXEC [dbo].[Znode_GetCategoryAttributeValue]@PimCategoryIds,@PimAttributeIds,@LocaleId;

						INSERT INTO @TBL_FamilyDetails(PimAttributeFamilyId,AttributeFamilyName,PimCategoryId)
						EXEC Znode_GetCategoryFamilyDetails @PimCategoryIds,@LocaleId;
							
							
						INSERT INTO @TBL_DefaultAttributeValue(PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder )
						EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @PimAttributeIds,@LocaleId;
						
						INSERT INTO @TBL_AttributeValue ( PimCategoryId , CategoryValue , AttributeCode )

						SELECT PimCategoryId,AttributeFamilyName , 'AttributeFamily'
						FROM @TBL_FamilyDetails 		

						UPDATE  TBAV
						SET CategoryValue  = SUBSTRING ((SELECT ','+[dbo].FN_GetMediaThumbnailMediaPath(zm.Path) FROM ZnodeMedia ZM  WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(TBAV.CategoryValue ,',') SP  WHERE SP.Item = CAST(ZM.MediaId AS VARCHAR(50)) ) FOR XML PATH('')),2,4000)
						FROM @TBL_AttributeValue TBAV 
						INNER JOIN @TBL_MediaAttribute TBMA ON (TBMA.PimAttributeId = TBAV.PimAttributeId)	

						DECLARE @CategoryXML XML 

						SET @CategoryXML =  '<MainCategory>'+ STUFF( ( SELECT '<Category>'+'<PimCategoryId>'+CAST(TBAD.PimCategoryId AS VARCHAR(50))+'</PimCategoryId>'+ STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST((SELECT ''+TBADI.CategoryValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
						 									 FROM @TBL_AttributeValue TBADI      
															 WHERE TBADI.PimCategoryId = TBAD.PimCategoryId 
															 ORDER BY TBADI.PimCategoryId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Category>'	   

			FROM @TBL_AttributeValue TBAD
			INNER JOIN @TBL_PimcategoryDetails TBPI ON (TBAD.PimCategoryId = TBPI.PimCategoryId )
			GROUP BY TBAD.PimCategoryId,TBPI.RowId 
			ORDER BY TBPI.RowId 
			FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainCategory>'


			SELECT  @CategoryXML  CategoryXMl
		   
		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA 
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1 
			 AND IsCategory = 1  
			 AND ZPA.IsShowOnGrid = 1  

		    SELECT ISNULL(@RowsCount,0) AS RowsCount;
						
						
						
						
						
						--WITH Cte_DefaultCategoryValue	
						--AS (SELECT PimCategoryId,PimAttributeId,
						--	SUBSTRING((SELECT ','+AttributeDefaultValue FROM @TBL_DefaultAttributeValue AS TBDAV WHERE TBDAV.PimAttributeId = TBAV.PimAttributeId
						--	AND EXISTS(SELECT TOP 1 1 FROM dbo.Split(TBAV.CategoryValue, ',') AS SP WHERE sp.Item = TBDAV.AttributeDefaultValueCode)
						--	FOR XML PATH('')), 2, 4000) AS AttributeValue FROM @TBL_AttributeValue AS TBAV
						--	WHERE EXISTS(SELECT TOP 1 1	FROM [dbo].[Fn_GetCategoryDefaultValueAttribute]() AS SP WHERE SP.PimAttributeId = TBAV.PimAttributeId))
																																																			
						--UPDATE TBAV SET TBAV.CategoryValue = CTDCV.AttributeValue FROM @TBL_AttributeValue TBAV
						--INNER JOIN Cte_DefaultCategoryValue CTDCV ON(CTDCV.PimCategoryId = TBAV.PimCategoryId AND CTDCV.PimAttributeId = TBAV.PimAttributeId);
																																										
						--SELECT TBCD.PimCategoryId,Piv.CategoryName,ZPC.IsActive AS [Status],dbo.FN_GetMediaThumbnailMediaPath(Zm.Path) AS CategoryImage,
						--ISNULL(TBFD.AttributeFamilyName, '') AS AttributeFamilyName FROM @TBL_PimcategoryDetails AS TBCD
						--INNER JOIN(SELECT PimCategoryId,CategoryValue,AttributeCode FROM @TBL_AttributeValue)
					 --   AS TBAV PIVOT(MAX(CategoryValue) FOR AttributeCode IN([CategoryName],[CategoryImage])) PIV ON(Piv.PimCategoryId = TBCD.PimCategoryId)																				
						--LEFT JOIN @TBL_FamilyDetails AS TBFD ON(TBFD.PimCategoryId = PIV.PimCategoryId)
						--LEFT JOIN ZnodeMedia AS ZM ON(CAST(ZM.MediaId AS VARCHAR(50)) = PIV.[CategoryImage])
						--LEFT JOIN ZnodePimCategory AS ZPC ON(ZPC.PimCategoryId = Piv.PimCategoryId)
						--ORDER BY RowId;
         END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPimCatalogAssociatedCategory @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PimCatalogId='+CAST(@PimCatalogId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@ProfileCatalogId='+CAST(@ProfileCatalogId AS VARCHAR(50))+',@PimCategoryId='+CAST(@PimCategoryId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPimCatalogAssociatedCategory',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetProductIdForPaging]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetProductIdForPaging' )
BEGIN
	DROP PROCEDURE Znode_GetProductIdForPaging
END
GO
CREATE PROCEDURE [dbo].[Znode_GetProductIdForPaging]
(
	@WhereClauseXML  XML           = NULL,
	@Rows            INT           = 10,
	@PageNo          INT           = 1,
	@Order_BY        VARCHAR(1000) = '',
	@RowsCount       INT OUT,
	@LocaleId        INT           = 1,
	@AttributeCode   VARCHAR(MAX)  = '',
	@PimProductId    TransferId READONLY , 
	@IsProductNotIn  BIT           = 0,
	@OutProductId    VARCHAR(MAX)	= 0 OUT )
AS	
 /* Summary :- This procedure is used to find the product ids with paging 
     Unit Testing
	 begin tran
	 DECLARE @ttr NVARCHAR(max)
	 DECLARE @PimProductId TransferId 
	 INSERT INTO @PimProductId
	 SELECT -1
     EXEC Znode_GetProductIdForPaging   N'' ,  10 ,  2 ,'productname desc',0, 1, '',@PimProductId ,0 ,@ttr OUT SELECT @ttr
	 rollback tran

	 begin tran

	 DECLARE @ttr NVARCHAR(max)
	 DECLARE @PimProductId TransferId 
	 INSERT INTO @PimProductId
	 SELECT 1
	EXEC Znode_GetProductIdForPaging N'', 50,1,'productname desc',0,1,'',@PimProductId,0,@ttr OUT SELECT @ttr
  rollback tran





	Create Index ZnodePimAttributeValue_ForPaging_Include ON  ZnodePimAttributeValue(PimAttributeId) include (PimAttributeValueId  ,PimProductId,CreatedDate,ModifiedDate )
	Create Index ZnodePimProductAttributeDefaultValue_ForPaging_Include ON  ZnodePimProductAttributeDefaultValue(PimAttributeValueId) include (PimAttributeDefaultValueId)
	Create Index ZnodePimFamilyGroupMapper_PimAttributeFamilyId ON ZnodePimFamilyGroupMapper(PimAttributeFamilyId,PimAttributeId)

	create  index IDX_ZnodePimAttributeValue_PimAttributeId on ZnodePimAttributeValue(PimAttributeId)
*/
BEGIN
 BEGIN TRY 

  SET NOCOUNT ON 

       DECLARE @SQL NVARCHAR(MAX) = '',
			   @InternalSQL NVARCHAR(MAX) = ''
	   DECLARE @UseCtePart VARCHAR(1000) = ''
	   DECLARE @InternalOrderby VARCHAR(1000) = ''
	   DECLARE @InternalWhereClause NVARCHAR(MAX) = '',
			   @InternalProductWhereClause NVARCHAR(MAX) = '',
			   @InternalUpperWhereClause NVARCHAR(MAX)='',
			   @InternaleProductJoin NVARCHAR(MAX) = ''

	   DECLARE @TBL_PimProductId  TABLE (PimProductId INT  , CountNo INT)
	   DECLARE @TBL_DefaultAttributeId TABLE (PimAttributeId INT PRIMARY KEY , AttributeCode VARCHAR(600))
	  
	   DECLARE @DefaultLocaleId INT = dbo.FN_GetDefaultLocaleId()
	   DECLARE @PimProductIds TransferId 
	   INSERT INTO @TBL_DefaultAttributeId (PimAttributeId,AttributeCode)
	   SELECT PimAttributeId,AttributeCode FROM  [dbo].[Fn_GetDefaultAttributeId] ()

	   DECLARE @TBL_Attributeids TABLE(PimAttributeId INT , AttributeCode VARCHAr(600))

	  
	   INSERT INTO @PimProductIds (id)
	   SELECT Id
	   FROM @PimProductId 


	   IF  EXISTS (SELECT TOP 1 1 FROM @PimProductId )  AND @IsProductNotIn = 1 
	   BEGIN 
	    	     SET @InternalWhereClause = ' WHERE NOT EXISTS ( SELECT TOP 1 1 FROM @TBL_ProductFilter TBLFP WHERE  TBLFP.PimProductId = ZPP.PimProductId )'
	   END 
	   ELSE IF @IsProductNotIn = 0 AND EXISTS (SELECT TOP 1 1 FROM @PimProductId )  
	   BEGIN 
		  SET @InternalWhereClause = ''
		  SET @InternalUpperWhereClause = ' A '
	   END 	  

	  -- if Not Exists (select top 1 1 from Sysobjects where name  = '@TBL_DefaultValue') 
	  -- Begin 
			--Create TABLE @TBL_DefaultValue  (PimAttributeId INT,AttributeDefaultValueCode NVARCHAR(600),IsEditable BIT,AttributeDefaultValue NVARCHAR(max),DisplayOrder INT,PimAttributeDefaultValueId INT 
		 --   Index Ind_PimAttributeDefaultValueId (PimAttributeDefaultValueId))
	  -- END
	 

	   SET @SQl = ' 
				DECLARE @TBL_ProductFilter TABLE (PimProductId INT PRIMARY KEY,RowId INT IDENTITY(1,1)  ) '

				IF (@AttributeCode like  '%highlights%' or @AttributeCode like '%brand%' or @AttributeCode like '%vendor%' )
				BEGIN
			
					SET @SQl = @SQl + 'INSERT INTO @TBL_ProductFilter  (PimProductId )
										SELECT a.Id 
										FROM @TransferId a
										INNER JOIN ZnodePimAttributeValue ZPAV ON a.Id = ZPAV.PimProductId
										LEFT JOIN ZnodePimAttribute PA ON ( PA.PimAttributeId = ZPAV.PimAttributeId ) 
										WHERE PA.AttributeCode in (select top 1 item from dbo.Split ('''+@AttributeCode+''','',''))
										ORDER BY ZPAV.ModifiedDate desc;'

				END
				ELSE
				BEGIN 

					SET @SQl = @SQl + 'INSERT INTO @TBL_ProductFilter  (PimProductId )
										SELECT Id 
										FROM @TransferId '
				END

				
				SET @SQl = @SQl+'							
								DECLARE @TBL_PimProductId TABLE (PimProductId  INT PRIMARY KEY,RowId INT, CountNo INT)
								;With Cte_PimProductId AS
								(  
										SELECT ZPP.PimProductId , ZPP.PimAttributeFamilyId , '+CASE WHEN @InternalUpperWhereClause <> '' THEN ' TBPF.RowId ' ELSE ' 1 ' END+'  DisplayOrder 
										FROM ZnodePimProduct ZPP 
									'+CASE WHEN @InternalUpperWhereClause <> '' AND @InternalWhereClause = '' THEN ' INNER JOIN @TBL_ProductFilter TBPF ON (TBPF.PimProductId = ZPP.PimProductId ) ' ELSE '' END +'
										'+@InternalWhereClause+' 
								) '
	
	 SET @AttributeCode = @AttributeCode +CASE WHEN @Order_By <> '' THEN ','+ REPLACE(REPLACE(RTRIM(LTRIM(@Order_By)),'DESC',''),'ASC','') ELSE '' END 
	 
	 IF @AttributeCode = ''
	 BEGIN 
	 SET @AttributeCode = SUBSTRING( (SELECT ','+AttributeCode  FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000)	
	 END 

	   INSERT INTO @TBL_Attributeids (PimAttributeId, AttributeCode )
	   SELECT PimAttributeId,AttributeCode
	   FROM [dbo].[Fn_GetProductGridAttributes]() FNGA  
	   WHERE EXISTS (SELECT Top 1 1 FROM dbo.split(@AttributeCode , ',') SP WHERE sp.Item = FNGA.AttributeCode   )

	  -- 	 SELECT @AttributeCode

	   

	    DECLARE @PimAttributeIds VARCHAR(MAX) = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) 
																		FROM @TBL_Attributeids FNGA  
																		FOR XML PATH ('') ) ,2,4000)


	SET @InternalOrderby = dbo.FN_trim(REPLACE(REPLACE(@Order_By,'DESC',''),'ASC',''))
	
	IF EXISTS (SELECT TOP 1 1 FROM [dbo].[Fn_GetProductGridAttributes]() FN WHERE FN.AttributeCode = @InternalOrderby) OR @InternalOrderby = 'AttributeFamily'
	BEGIN
		--If @InternalOrderby = 'assortment'
		--Begin
		--	SET @InternalWhereClause = ' AttributeCode = ''SKU'' ' 
		--End
	 --   Else
		--Begin 
		
		SET @InternalWhereClause = 'AttributeCode = '''+@InternalOrderby+''''
		--END 
				SET @InternalOrderby = 'AttributeValue '+CASE WHEN @Order_By LIKE '% DESC' THEN 'DESC' ELSE 'ASC' END
				
	END
	ELSE IF  @InternalOrderby IN ('CreatedDate','ModifiedDate')
	
	BEGIN
	
	 SET @InternalOrderby = @Order_By
	 SET @InternalWhereClause = ' AttributeCode = ''SKU'' ' 
	END 
	ELSE 
	BEGIN 
	 SET @InternalOrderby = CASE WHEN @InternalOrderby = 'DisplayOrder' THEN @Order_By ELSE ' CTLA.PimProductId DESC ' END  
	 SET @InternalWhereClause = '' 
	END    

	IF (@AttributeCode like  '%highlights%' or @AttributeCode like '%brand%' or @AttributeCode like '%vendor%' )
	BEGIN

		SET @InternalOrderby = 'DisplayOrder, '+@InternalOrderby

	END
	  
    IF CAST(@WhereClauseXML AS NVARCHAR(max)) NOT LIKE '%AttributeCode%' AND @InternalWhereClause = '' 
	BEGIN 
	
	 SET @SQL = @SQL + ' , Cte_FilterData AS 
								( SELECT PimProductId ,'+[dbo].[Fn_GetPagingRowId](@InternalOrderby,'PimProductId DESC')+',Count(*)Over() CountNo
								   FROM Cte_PimProductId CTLA
								 )
								 INSERT INTO  @TBL_PimProductId  (PimProductId,RowId,CountNo )
								 SELECT DISTINCT PimProductId,RowId ,CountNo
								 FROM Cte_FilterData 
								 '+[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)


	END 
	ELSE IF CAST(@WhereClauseXML AS NVARCHAR(max)) NOT LIKE '%AttributeCode%' AND @InternalWhereClause <> '' 
	BEGIN

						 
	   SET @InternalSQL = '
						   DECLARE @TBL_FamilyLocale  TABLE(PimAttributeFamilyId INT PRIMARY KEY ,FamilyCode NVARCHAR(600),IsSystemDefined BIT,IsDefaultFamily BIT,IsCategory BIT ,AttributeFamilyName NVARCHAR(max) ) 
						   DECLARE @TBL_DefaultValue  TABLE(PimAttributeId INT,AttributeDefaultValueCode NVARCHAR(600),IsEditable BIT,AttributeDefaultValue NVARCHAR(max),DisplayOrder INT,PimAttributeDefaultValueId INT )
						   
						   INSERT INTO @TBL_FamilyLocale(PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,AttributeFamilyName)
						   EXEC [dbo].[Znode_GetFamilyValueLocale] '''','+CAST(@LocaleId AS VARCHAR(50))+'	
						   
						   INSERT INTO @TBL_DefaultValue(PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder,PimAttributeDefaultValueId)
						   EXEC [dbo].[Znode_GetAttributeDefaultValueLocaleNew] '''+@PimAttributeIds+''','+CAST(@LocaleId AS VARCHAR(50))+''

							SET @SQL = @SQL + ' ,Cte_getAttributeValue AS 
									(	
										SELECT CTP.PimProductId , ZPA.AttributeCode  ,ZPAV.PimAttributeValueId  ,ZPA.PimAttributeId
										,ZPAV.CreatedDate,ZPAV.ModifiedDate,CTP.DisplayOrder     
										FROM Cte_PimProductId CTP             
										INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = CTP.PimProductId)             
										INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)    
										INNER JOIN ZnodePimFamilyGroupMapper ZPFGM ON (ZPFGM.PimAttributeFamilyId = CTP.PimAttributeFamilyId                      
										AND ZPFGM.PimAttributeId = ZPA.PimAttributeId)   
									)
		                            , Cte_CollectData AS 
									( 
										SELECT ZPA.PimProductId , ZPA.AttributeCode  ,  ZPAVL.AttributeValue ,ZPA.CreatedDate,ZPA.ModifiedDate,ZPA.DisplayOrder             
										FROM Cte_getAttributeValue   ZPA INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPA.PimAttributeValueId = ZPAVL.PimAttributeValueId ) 
										WHERE  ZPA.PimAttributeId IN ('+@PimAttributeIds+') AND ZPAVL.LocaleId in  (' + CAST(@DefaultLocaleId AS VARCHAR(50)) +')
										
										UNION ALL 
										
										SELECT CTP.PimProductId , ''AttributeFamily'', TBFM.AttributeFamilyName AttributeValue,NULL,NULL,CTP.DisplayOrder
										FROM Cte_PimProductId CTP INNER JOIN @TBL_FamilyLocale  TBFM ON (TBFM.PimAttributeFamilyId = CTP.PimAttributeFamilyId)
										

										UNION ALL 
										
										SELECT DISTINCT PimProductId, AttributeCode , SUBSTRING((SELECT '',''+AttributeDefaultValue 
										FROM @TBL_DefaultValue TBDV WHERE (TBDV.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )                            
										FOR XML PATH ('''')),2,4000) AttributeValue  , CTETY.CreatedDate,CTETY.ModifiedDate,DisplayOrder         
										FROM ZnodePimProductAttributeDefaultValue ZPPADV INNER JOIN Cte_getAttributeValue CTETY 
										ON (CTETY.PimAttributeValueId = ZPPADV.PimAttributeValueId)
										WHERE  CTETY.PimAttributeId IN ('+@PimAttributeIds+')
								 )
								 ,Cte_GetAttributeValueI AS 
								 (
									SELECT PimProductId,'+CASE WHEN @InternalOrderby LIKE '%DisplayOrder%' THEN 'DisplayOrder' ELSE   'AttributeValue'  END+'  , 1 DefaultOrderBy      
									FROM  Cte_CollectData CTCD
									WHERE '+@InternalWhereClause+'
									UNION ALL 
									SELECT CTP.PimProductId , NULL , 2 
									FROM Cte_PimProductId CTP 	
									where NOT EXISTS (SELECT TOP 1 1 FROM  Cte_CollectData CTCD
									WHERE '+@InternalWhereClause+' AND CTCD.PimProductId = CTP.PimProductId  )				  
								 )
								, Cte_FilterData As 
								(
									SELECT DISTINCT PimProductId,'+[dbo].[Fn_GetPagingRowId](' DefaultOrderBy , '+@InternalOrderby+' ','PimProductId DESC')+'
									FROM Cte_GetAttributeValueI CTCD
								 )
								,Cte_GetAllData AS 
								(
									SELECT PimProductId ,RowId ,Count(*)Over() CountNo
									FROM Cte_FilterData
									GROUP BY PimProductId ,RowId 
								)
								INSERT INTO  @TBL_PimProductId  (PimProductId,RowId,CountNo )
								SELECT  PimProductId,RowId ,CountNo
								FROM  Cte_GetAllData
								'+[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)

		SET @SQL =  @InternalSQL + @SQL
			
	    END
		ELSE 
		BEGIN 
		  SET @InternalSQL = ''
		  DECLARE @AttachINDefault  VARCHAr(max) = ''
		  SET  @InternalProductWhereClause = 
							STUFF( (  SELECT ' INNER JOIN Cte_AttributeValueLocale AS CTAL'+CAST(ID AS VARCHAR(50))
							+' ON ( CTAL'+CAST(ID AS VARCHAR(50))+'.PimProductId = CTAL'+CASE WHEN ID-1= 0 THEN '' ELSE CAST(ID-1 AS VARCHAR(50)) END +'.PimProductId AND '+
							REPLACE(REPLACE(WhereClause,'AttributeCode ',' CTAL'+CAST(ID AS VARCHAR(50))+'.AttributeCode '),' AttributeValue ',' CTAL'+CAST(ID AS VARCHAR(50))+'.AttributeValue ')+' )'
							FROM dbo.Fn_GetWhereClauseXML(@WhereClauseXML)      
							FOR XML PATH (''), TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')

          SET @SQL = @SQL + '   ,Cte_getAttributeValue AS 
								(	
										SELECT CTP.PimProductId , ZPA.AttributeCode  ,ZPAV.PimAttributeValueId  ,ZPA.PimAttributeId
														,ZPAV.CreatedDate,ZPAV.ModifiedDate,CTP.DisplayOrder     
										FROM Cte_PimProductId CTP             
										INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = CTP.PimProductId)       
										INNER JOIN ZnodePimAttribute ZPA ON (ZPAV.PimAttributeId = ZPA.PimAttributeId)    
										INNER JOIN ZnodePimFamilyGroupMapper ZPFGM ON 
										(CTP.PimAttributeFamilyId = ZPFGM.PimAttributeFamilyId AND ZPFGM.PimAttributeId = ZPA.PimAttributeId) 
										WHERE (EXISTS (SELECT TOP 1 1 FROM dbo.split('''+@AttributeCode+''','','') SP WHERE Sp.Item = ZPA.AttributeCode )  OR NOT EXISTS (SELECT TOP 1 1 FROM dbo.split('''+@AttributeCode+''','','') ))
								)'
		  IF EXISTS (SELECT Top 1 1 FROM @TBL_Attributeids TBH WHERE NOT EXISTS (SELECT Top 1 1 FROM @TBL_DefaultAttributeId TBL WHERE TBL.PimAttributeId = TBH.PimAttributeId)
		  AND TBH.AttributeCode <> 'AttributeFamily' )
         BEGIN 
		    SET @SQL = @SQL+' , Cte_CollectData AS 
								( 
									SELECT ZPA.PimProductId , ZPA.AttributeCode  ,  ZPAVL.AttributeValue,ZPAVL.LocaleId ,
											ZPA.PimAttributeId,ZPA.CreatedDate,ZPA.ModifiedDate,ZPA.DisplayOrder             
									FROM Cte_getAttributeValue ZPA          
									INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (ZPA.PimAttributeValueId  = ZPAVL.PimAttributeValueId )
									where ZPA.PimAttributeId IN ('+@PimAttributeIds+')
									AND  ZPAVL.LocaleId IN ( '+CAST(@LocaleId AS VARCHAR(50))+','+CAST(@DefaultLocaleId AS VARCHAR(50))+')
								)
								, Cte_FilterDataLocale AS 
								(
										SELECT PimProductId,AttributeCode,AttributeValue,PimAttributeId,CreatedDate,ModifiedDate,DisplayOrder
										FROM Cte_CollectData
										WHERE LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+'
										UNION All 
										SELECT M.PimProductId,M.AttributeCode,M.AttributeValue ,M.PimAttributeId,M.CreatedDate,M.ModifiedDate,M.DisplayOrder
										FROM Cte_CollectData M 
										WHERE LocaleId = '+CAST(@DefaultLocaleId AS VARCHAR(50))+'
										AND NOT Exists (Select TOP 1 1  from Cte_CollectData X where  M.PimProductId = X.PimProductId AND M.AttributeCode = X.AttributeCode And X.localeId =  '+CAST(@LocaleId AS VARCHAR(50))+' )
								)'

						SET @AttachINDefault =			'SELECT PimProductId,AttributeCode,CTFD.AttributeValue ,CreatedDate,ModifiedDate,CTFD.DisplayOrder	 
										FROM Cte_FilterDataLocale CTFD'

		 END 
		 
		 IF EXISTS (SELECT Top 1 1 FROM @TBL_Attributeids TBH WHERE EXISTS (SELECT Top 1 1 FROM @TBL_DefaultAttributeId TBL WHERE TBL.PimAttributeId = TBH.PimAttributeId))
         BEGIN 
		 SET  @InternalSQL = 'DECLARE @TBL_DefaultValue  TABLE(PimAttributeId INT,AttributeDefaultValueCode NVARCHAR(600),IsEditable BIT,AttributeDefaultValue NVARCHAR(max),DisplayOrder INT,PimAttributeDefaultValueId INT  ) 
		                     INSERT INTO @TBL_DefaultValue(PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder,PimAttributeDefaultValueId)
						     EXEC [dbo].[Znode_GetAttributeDefaultValueLocaleNew] '''+@PimAttributeIds+''','+CAST(@LocaleId AS VARCHAR(50))
	   
			  SET @AttachINDefault = CASE WHEN @AttachINDefault = '' THEN '' ELSE @AttachINDefault+' UNION ALL ' END + ' SELECT PimProductId, AttributeCode , 
										SUBSTRING(
											(SELECT '',''+AttributeDefaultValue FROM @TBL_DefaultValue TBDV 
											WHERE (TBDV.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )                            
											FOR XML PATH (''''))
										,2,4000) 
										AttributeValue  , CTETY.CreatedDate,CTETY.ModifiedDate,DisplayOrder         
										FROM Cte_getAttributeValue CTETY
										INNER JOIN  ZnodePimProductAttributeDefaultValue ZPPADV ON (CTETY.PimAttributeValueId =ZPPADV.PimAttributeValueId  )
										WHERE  CTETY.PimAttributeId IN ('+@PimAttributeIds+') '

		 END
		 IF EXISTS (SELECT Top 1 1 FROM @TBL_Attributeids TBH WHERE AttributeCode = 'attributefamily')
         BEGIN 
		 SET  @InternalSQL = @InternalSQL +' DECLARE @TBL_FamilyLocale  TABLE(PimAttributeFamilyId INT PRIMARY KEY ,FamilyCode NVARCHAR(600),IsSystemDefined BIT,IsDefaultFamily BIT,IsCategory BIT ,AttributeFamilyName NVARCHAR(max) ) 
		                    INSERT INTO @TBL_FamilyLocale(PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,AttributeFamilyName)
						   EXEC [dbo].[Znode_GetFamilyValueLocale] '''','+CAST(@LocaleId AS VARCHAR(50))
						   
			SET @AttachINDefault = CASE WHEN @AttachINDefault = '' THEN '' ELSE @AttachINDefault+' UNION ALL '	END + 'SELECT CTP.PimProductId , ''AttributeFamily'' AttributeCode, TBFM.AttributeFamilyName AttributeValue,NULL CreatedDate, NULL ModifiedDate,DisplayOrder	
										FROM Cte_PimProductId CTP 
										INNER JOIN @TBL_FamilyLocale  TBFM ON (TBFM.PimAttributeFamilyId = CTP.PimAttributeFamilyId)'
		 END
		

								--SET  @InternalProductWhereClause =' INNER JOIN Cte_AttributeValueLocale AS CTAL1 ON ( CTAL1.PimProductId = CTAL.PimProductId AND  CTAL1.AttributeCode = ''ProductType'' and CTAL1.AttributeValue  = ''Simple Product'' )'
								--Print '---------1--------'
								--Print @SQL
								--Print '---------2--------'
		  --SELECT @InternalOrderby
									--Print @SQL
									--Print '---------3--------'
									SET @SQL = @SQL + ' 
									,Cte_AttributeValueLocale AS
									(
									 '+@AttachINDefault+'										
									)'
									--Print @SQL
									--Print '---------4--------'
									SET @SQL = @SQL + ' 

									, Cte_AttributeLocale AS
									(
										 SELECT CTAL.PimProductId 
										 FROM Cte_AttributeValueLocale  CTAL
										 '+@InternalProductWhereClause+'
										 GROUP BY CTAL.PimProductId 
									)
									, Cte_FinalProductData AS
									(
										SELECT DISTINCT CTLA.PimProductId, 1 DefaultOrderBy  ,'+[dbo].[Fn_GetPagingRowId](@InternalOrderby,' CTLA.PimProductId DESC')+' 
										FROM Cte_AttributeValueLocale  CTAVL
										INNER JOIN Cte_AttributeLocale CTLA ON (CTLA.PimProductId = CTAVL.PimProductId)
							        	'+CASE WHEN @InternalWhereClause <> '' THEN  ' WHERE CTAVL.'+dbo.FN_Trim(@InternalWhereClause) ELSE '' END +'
									)
									,Cte_GEtSortingProduct AS 
									(
										  SELECT PimProductId, DefaultOrderBy,RowId
										  FROM Cte_FinalProductData 
										  UNION ALL 
										  SELECT PimProductId ,2 DefaultOrderBy,'+[dbo].[Fn_GetPagingRowId]( 'DERE.PimProductId',' DERE.PimProductId ')+'
										  FROM Cte_AttributeLocale DERE 
										  WHERE NOT EXISTS (SELECT TOP 1 1 FROM Cte_FinalProductData TTRR WHERE TTRR.PimProductId = DERE.PimProductId  ) 
									  
									 )
									 ,Cte_getPagingData 
									 AS 
									 (
										  SELECT PimProductId ,'+[dbo].[Fn_GetPagingRowId](' DefaultOrderBy ',' RowId ')+' ,Count(*)Over() CountNo
										  FROM Cte_GEtSortingProduct
									 )

									,Cte_GetAllData AS 
									(
										  SELECT PimProductId ,RowId ,CountNo
										  FROM Cte_getPagingData
										  GROUP BY PimProductId ,RowId ,CountNo
									)
									'
									--Print @SQL
									--Print '---------5--------'
									SET @SQL = @SQL + ' 

								 INSERT INTO  @TBL_PimProductId  (PimProductId,RowId,CountNo )
								 SELECT  PimProductId,RowId , CountNo
								 FROM Cte_GetAllData '
								 +[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)

			SET @SQl = @InternalSQL+@SQL
     		END
			SET @SQl = @SQl + ' 
								SET @OutProductId = ISNULL(SUBSTRING((SELECT '',''+CAST(PimProductid AS VARCHAR(50)) 
										FROM @TBL_PimProductId TBPP
										ORDER BY RowId
										FOR XML PATH ('''')   ),2,4000),'''')
								SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM  @TBL_PimProductId TBPP),0)
							 '
			
			--PRINT  @SQl
           -- SELECT  @SQl
		
			EXEC SP_EXECUTESQl  @SQL ,N' @OutProductId VARCHAR(max) OUT ,@RowsCount INT OUT ,@TransferId TransferId READONLY  ',  @OutProductId = @OutProductId OUT, @RowsCount = @RowsCount OUT ,@TransferId  = @PimProductIds
		

	 -- SELECT  @OutProductId,@RowsCount

     END TRY 
    BEGIN CATCH
	 DECLARE @Status BIT ;
		     SET @Status = 0;
			 SELECT ERROR_MESSAGE()
		  --   DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductIdForPaging @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@AccountList='+CAST(@AccountList AS VARCHAR(50))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
    --         SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
    --         EXEC Znode_InsertProcedureErrorLog
				--@ProcedureName = 'Znode_GetProductIdForPaging',
				--@ErrorInProcedure = @Error_procedure,
				--@ErrorMessage = @ErrorMessage,
				--@ErrorLine = @ErrorLine,
				--@ErrorCall = @ErrorCall;
	 END CATCH 
     END
GO
PRINT N'Altering [dbo].[Znode_ManageProductList]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ManageProductList' )
BEGIN
	DROP PROCEDURE Znode_ManageProductList
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageProductList]
(   @WhereClause		 XML,
	@Rows				 INT           = 10,
	@PageNo			     INT           = 1,
	@Order_BY			 VARCHAR(1000) = '',
	@RowsCount			 INT OUT,
	@LocaleId			 INT           = 1,
	@PimProductId		 VARCHAR(2000) = 0,
	@IsProductNotIn	     BIT           = 0,
	@IsCallForAttribute  BIT	       = 0,
	@AttributeCode       VARCHAR(max)  = ''
	)
AS
    
/*
 Summary:-  This Procedure is used for getting product List  
			Procedure will pivot verticle table(ZnodePimattributeValues) into horizontal table with columns 
			ProductId,ProductName,ProductType,AttributeFamily,SKU,Price,Quantity,IsActive,ImagePath,Assortment,LocaleId,DisplayOrder        
 Unit Testing
		  DECLARE @D INT= 1 
		  EXEC  [dbo].[Znode_ManageProductList]   @WhereClause = N'' , @Rows = 100 , @PageNo = 1 ,@Order_BY = '',@LocaleId= 1,@PimProductId = '',@IsProductNotIn = 1 , @RowsCount = @D OUT SELECT @D
    
    */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @PimProductIds VARCHAR(MAX), @PimAttributeId VARCHAR(MAX), @FirstWhereClause VARCHAR(MAX)= '', @SQL NVARCHAR(MAX)= '' ,@OutPimProductIds VARCHAR(max);
             DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();
             DECLARE @TransferPimProductId TransferId 
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

			 DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT 
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             DECLARE @DefaultAttributeFamily INT= dbo.Fn_GetDefaultPimProductFamilyId();
             DECLARE @ProductIdTable TABLE
             (PimProductId INT,
              CountId      INT,
              RowId        INT IDENTITY(1,1)
             );
             SET @FirstWhereClause =
             (SELECT WhereClause FROM dbo.Fn_GetWhereClauseXML(@WhereClause) WHERE id = 1);

             IF (@FirstWhereClause LIKE '%Brand%'
                OR @FirstWhereClause LIKE '%Vendor%'
                OR @FirstWhereClause LIKE '%ShippingCostRules%'
                OR @FirstWhereClause LIKE '%Highlights%') and @IsCallForAttribute=1
                 BEGIN

				 SET @SQL = ' DECLARE @TBL_ProductIds TABLE (PimProductId INT,ModifiedDate DATETIME  )
				            ;WIth Cte_DefaultValue AS (
						    SELECT AttributeDefaultValueCode , ZPDF.PimAttributeId ,FNPA.AttributeCode FROM ZnodePImAttributeDefaultValue ZPDF
						    INNER JOIN [dbo].[Fn_GetProductDefaultFilterAttributes] () FNPA ON ( FNPA.PimAttributeId = ZPDF.PimAttributeId))
							
							, Cte_productIds AS 
							(SELECT a.PimProductId, c.AttributeCode , CTDV.AttributeDefaultValueCode AttributeValue,b.ModifiedDate 
							FROM  ZnodePimAttributeValue a
							LEFT JOIN ZnodePimAttribute c ON(c.PimAttributeId = a.PimAttributeId)
							LEFT JOIN ZnodePimAttributeValueLocale b ON(b.PimAttributeValueId = a.PimAttributeValueId)  
							INNER JOIN Cte_DefaultValue CTDV ON (CTDV.AttributeCode = c.AttributeCode AND EXISTS (SELECT TOP 1 1 FROM dbo.split(b.AttributeValue,'','') SP WHERE SP.Item = CTDV.AttributeDefaultValueCode) )
 
						    )
							INSERT INTO @TBL_ProductIds (PimProductId ,ModifiedDate)
							SELECT PimProductId ,ModifiedDate
							FROM Cte_productIds WHERE   '+@FirstWhereClause+' GROUP BY PimProductId,ModifiedDate Order By ModifiedDate DESC 
										
							SELECT PimProductId FROM @TBL_ProductIds GROUP BY PimProductId,ModifiedDate ORDER BY ModifiedDate DESC';
					 
					 Print @sql
                     INSERT INTO @ProductIdTable(PimProductId)
                     EXEC (@SQL);

                     INSERT INTO @TransferPimProductId
					 SELECT PimProductId
                     FROM @ProductIdTable
                     UNION ALL 
					 SELECT 0
					 
					                                    
                     DELETE FROM @ProductIdTable;

                     SET @WhereClause = CAST(REPLACE(CAST(@WhereClause AS NVARCHAR(MAX)), '<WhereClauseModel><WhereClause>'+@FirstWhereClause+'</WhereClause></WhereClauseModel>', '') AS XML);
                 END
				 ELSE IF @PimProductId <> ''
			    BEGIN 
				 INSERT INTO @TransferPimProductId(id)
				 SELECT Item 
				 FROM dbo.split(@PimProductId,',')
			    END 
					                    
             EXEC Znode_GetProductIdForPaging @whereClauseXML = @WhereClause,@Rows = @Rows,@PageNo = @PageNo,@Order_BY = @Order_BY,@RowsCount = @RowsCount OUT,
             @LocaleId = @LocaleId,@AttributeCode = @AttributeCode,@PimProductId = @TransferPimProductId, @IsProductNotIn = @IsProductNotIn,@OutProductId = @OutPimProductIds OUT;
			
			 INSERT INTO @ProductIdTable (PimProductId)              
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP 
				 
				            
             SET @PimProductIds = SUBSTRING((SELECT ','+CAST(PimProductId AS VARCHAR(100)) FROM @ProductIdTable FOR XML PATH('')), 2, 4000);
             SET @PimAttributeId = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetGridPimAttributes]() FOR XML PATH('')), 2, 4000);;
            
			 INSERT INTO @TBL_AttributeDefaultValue
             (PimAttributeId,
              AttributeDefaultValueCode,
              IsEditable,
              AttributeDefaultValue,
			  DisplayOrder
             )
             EXEC Znode_GetAttributeDefaultValueLocale
                  @PimAttributeId,
                  @LocaleId;

             INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )
             EXEC Znode_GetProductsAttributeValue
                  @PimProductIds,
                  @PimAttributeId,
                  @localeId;
     
             INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1;
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';
            
			;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+ dbo.Fn_GetMediaThumbnailMediaPath(zm.PATH) 
			   FROM ZnodeMedia AS ZM
               INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;


			
			 SELECT zpp.PimProductid AS ProductId,
                    [ProductName],
                    ProductType,
                    ISNULL(zf.FamilyName, '') AS AttributeFamily,
                    [SKU],
                    [Price],
                    [Quantity],
                    CASE
                        WHEN [IsActive] IS NULL
                        THEN CAST(0 AS BIT)
                        ELSE CAST([IsActive] AS BIT)
                    END AS [IsActive],
                   piv.[ProductImage] AS ImagePath,
                    [Assortment],
                    @LocaleId AS LocaleId,
                    [DisplayOrder]
             FROM @ProductIdTable AS zpp
                  LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
                  INNER JOIN
             (
                 SELECT PimProductId,
                        AttributeValue,
                        AttributeCode
                 FROM @TBL_AttributeDetails
             ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
                                                                 [SKU],
                                                                 [Price],
                                                                 [Quantity],
                                                                 [IsActive],
                                                                 [ProductType],
                                                                 [ProductImage],
                                                                 [Assortment],
                                                                 [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
                --  LEFT JOIN ZnodeMedia AS zm ON(zm.MediaId = piv.[ProductImage])
             ORDER BY zpp.RowId;
         
         END TRY
         BEGIN CATCH
               DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageProductList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PimProductId='+@PimProductId+',@IsProductNotIn='+CAST(@IsProductNotIn AS VARCHAR(50))+',@IsCallForAttribute='+CAST(@IsCallForAttribute AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageProductList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetCatalogCategoryProducts]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetCatalogCategoryProducts' )
BEGIN
	DROP PROCEDURE Znode_GetCatalogCategoryProducts
END
GO
CREATE PROCEDURE [dbo].[Znode_GetCatalogCategoryProducts]
( @WhereClause      XML,
  @Rows             INT           = 100,
  @PageNo           INT           = 1,
  @Order_BY         VARCHAR(1000) = '',
  @RowsCount        INT OUT,
  @LocaleId         INT           = 1,
  @PimCategoryId    INT,
  @PimCatalogId     INT           = 0,
  @IsAssociated     BIT           = 0,
  @ProfileCatalogId INT           = 0
  ,@AttributeCode   VARCHAR(max) = ''
  )
AS
   
/*
	   Summary:  Get product List  Catalog / category / respective product list   		   
	   Unit Testing   
	   begin tran
	   declare @p7 int = 0  
	   EXEC Znode_GetCatalogCategoryProducts @WhereClause=N'',@Rows=10,@PageNo=1,@Order_By=N'',
	   @RowsCount=@p7 output,@PimCategoryId=11,@PimCatalogId = 1 ,@LocaleId=1 ,@ProfileCatalogId = 1 
	   rollback tran
	  
    */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @DefaultAttributeFamily INT= dbo.Fn_GetDefaultPimProductFamilyId(), @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @OrderId INT= 0;
             DECLARE @SQL VARCHAR(MAX), @PimProductId VARCHAR(MAX)= '', @PimAttributeId VARCHAR(MAX),@OutPimProductIds VARCHAR(max);
             DECLARE @TransferPimProductId TransferId 
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

			 DECLARE @TBL_ProfileCatalogCategory TABLE
             (ProfileCatalogId     INT,
              PimProductId         INT,
              PimCategoryId        INT,
              PimCatalogCategoryId INT
             );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT 
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             DECLARE @TBL_AttributeValue TABLE
             (PimCategoryAttributeValueId INT,
              PimCategoryId               INT,
              CategoryValue               NVARCHAR(MAX),
              AttributeCode               VARCHAR(300),
              PimAttributeId              INT
             );
             IF @Order_By LIKE ''
                 BEGIN
                     SET @OrderId = 1;
                 END;
             IF @ProfileCatalogId > 0
                 BEGIN
                     INSERT INTO @TBL_ProfileCatalogCategory (ProfileCatalogId,PimProductId,PimCategoryId,PimCatalogCategoryId)
                     SELECT ZPC.ProfileCatalogId,PimProductId,PimCategoryId,ZCC.PimCatalogCategoryId
                     FROM ZnodePimCatalogCategory AS ZCC
                     INNER JOIN ZnodeProfileCatalog AS ZPC ON(ZPC.PimCatalogId = ZCC.PimCatalogId)
                     WHERE ZPC.ProfileCatalogId = @ProfileCatalogId
                     AND NOT EXISTS
                         (
                            SELECT TOP 1 1
                            FROM ZnodeProfileCatalogCategory AS ZPCC
                            WHERE ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId
                         );
                 END;
             IF @PimCatalogId = 0
                 BEGIN
					INSERT INTO @TransferPimProductId 
                    SELECT PimProductId 
                    FROM ZnodePimCategoryProduct AS ZCP
                    WHERE ZCP.PimCategoryId = @PimCategoryId
					AND PimProductId IS NOT NULL 
                                                   
                 END;
             ELSE
                 BEGIN
                     IF @IsAssociated = 0
                        AND @ProfileCatalogId > 0
                         BEGIN
				INSERT INTO @TransferPimProductId 
                SELECT PimProductId 
                FROM ZnodePimCatalogCategory AS ZCP
                WHERE ZCP.PimCatalogId = @PimCatalogId
                AND ZCP.PimCategoryId = @PimCategoryId
                AND NOT EXISTS
                (
                    SELECT TOP 1 1
                    FROM ZnodeProfileCatalogCategory AS TBPCC
                    WHERE TBPCC.PimCatalogCategoryId = ZCP.PimCatalogCategoryId
                        AND TBPCC.ProfileCatalogId = @ProfileCatalogId
                )
               	AND PimProductId IS NOT NULL                                         
                        END;
                     ELSE
                         BEGIN
                             IF @IsAssociated = 1
                                AND @ProfileCatalogId > 0
                                 BEGIN
						INSERT INTO @TransferPimProductId 
                        SELECT PimProductId
                        FROM ZnodePimCatalogCategory AS ZCP
                        WHERE ZCP.PimCatalogId = @PimCatalogId
                            AND ZCP.PimCategoryId = @PimCategoryId
                            AND EXISTS
                        (
                            SELECT TOP 1 1
                            FROM ZnodeProfileCatalogCategory AS TBPCC
                            WHERE TBPCC.PimCatalogCategoryId = ZCP.PimCatalogCategoryId
                                AND TBPCC.ProfileCatalogId = @ProfileCatalogId
                        )
                       AND PimProductId IS NOT NULL                                             
                                     SET @IsAssociated = 0;
                                 END;
                             ELSE
                                 BEGIN
					INSERT INTO @TransferPimProductId 
                    SELECT PimProductId 
                    FROM ZnodePimCatalogCategory AS ZCP
                    WHERE ZCP.PimCatalogId = @PimCatalogId
                    AND ZCP.PimCategoryId = @PimCategoryId
				    AND PimProductId IS NOT NULL    
                    ORDER BY CASE
                                WHEN @OrderId = 0
                                THEN 1
                                ELSE ZCP.PimCatalogCategoryId
                            END DESC
                                   
                                 END;
                         END;
                 END;
				 
				 IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId)
				 BEGIN 
                  INSERT INTO @TransferPimProductId
				  SELECT '0'

				 END 


             DECLARE @ProductIdTable TABLE
             ([PimProductId] INT,
              [CountId]      INT,
              PimCategoryId  INT,
              RowId          INT IDENTITY(1,1)
             );
              EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = @AttributeCode,
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = @IsAssociated,
				  @OutProductId = @OutPimProductIds OUT
				  ;
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP 
             UPDATE @ProductIdTable
               SET
                   PimCategoryId = @PimCategoryId;
             SET @PimProductId = SUBSTRING(
                                          (
                                              SELECT ','+CAST(PimProductId AS VARCHAR(100))
                                              FROM @ProductIdTable
                                              FOR XML PATH('')
                                          ), 2, 4000);
             SET @PimAttributeId = SUBSTRING((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetGridPimAttributes]() FOR XML PATH('')), 2, 4000);
             INSERT INTO @TBL_AttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder )
            
			 EXEC Znode_GetAttributeDefaultValueLocale @PimAttributeId,@LocaleId;
            
			 INSERT INTO @TBL_AttributeDetails (PimProductId,AttributeValue,AttributeCode,PimAttributeId)

             EXEC Znode_GetProductsAttributeValue @PimProductId,@PimAttributeId,@localeId;
             SET @PimAttributeId = [dbo].[Fn_GetCategoryNameAttributeId]();

             INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)

             EXEC [dbo].[Znode_GetCategoryAttributeValue] @PimCategoryId,@PimAttributeId,@LocaleId;
          
		    ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+URL+ZMSM.ThumbnailFolderName+'/'+ zm.PATH 
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;

		  
		     --WITH Cte_UpdateDefaultAttributeValue
             --     AS (SELECT PimProductId,
             --                AttributeCode,
             --                AttributeValue,
             --                SUBSTRING(
             --                         (
             --                             SELECT ','+TBADV.AttributeDefaultValue
             --                             FROM @TBL_AttributeDefaultValue AS TBADV
             --                             INNER JOIN ZnodePimAttribute AS TBAC ON(TBADV.PimAttributeId = TBAC.PimAttributeId)
             --                             WHERE TBAC.AttributeCode = TBAD.AttributeCode
             --                                   AND EXISTS
             --                             (
             --                                 SELECT TOP 1 1
             --                                 FROM dbo.split(TBAD.AttributeValue, ',') AS SP
             --                                 WHERE Sp.item = TBADV.AttributeDefaultValueCode
             --                             )
             --                             FOR XML PATH('')
             --                         ), 2, 4000) AS AttributeDefaultValue
             --         FROM @TBL_AttributeDetails AS TBAD)
             --UPDATE TBAD
             --SET
             --   AttributeValue = CTUDAV.AttributeDefaultValue
             --FROM @TBL_AttributeDetails TBAD
             --INNER JOIN Cte_UpdateDefaultAttributeValue CTUDAV ON(CTUDAV.PimProductId = TBAD.PimProductId
             --                                                     AND CTUDAV.AttributeCode = TBAD.AttributeCode)
             --WHERE AttributeDefaultValue IS NOT NULL;
             INSERT INTO @FamilyDetails (PimAttributeFamilyId,PimProductId)
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId] @PimProductId,1;
             UPDATE a
             SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                  AND LocaleId = @LocaleId);
             UPDATE a
             SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                  AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';
             SELECT zpp.PimProductid AS ProductId,zpp.PimProductId,@PimCatalogId AS PimCatalogId,zpp.PimCategoryId,[ProductName],ProductType,ISNULL(zf.FamilyName, '') AS AttributeFamily,[SKU],[Price],[Quantity],
                    CASE
                        WHEN Piv.[IsActive] IS NULL
                        THEN CAST(0 AS BIT)
                        ELSE CAST(Piv.[IsActive] AS BIT)
                    END AS [IsActive],
                    piv.[ProductImage] ImagePath,
                    [Assortment],
                    TBAV.CategoryValue AS [CategoryName],
                    @LocaleId AS LocaleId,
                    ZCC.[DisplayOrder],
                    ZPCC.ProfileCatalogCategoryId,
                    RowId
             FROM @ProductIdTable AS zpp
                  LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
                  INNER JOIN
             (
                 SELECT PimProductId,
                        AttributeValue,
                        AttributeCode
                 FROM @TBL_AttributeDetails
             ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
                                                                 [SKU],
                                                                 [Price],
                                                                 [Quantity],
                                                                 [IsActive],
                                                                 [ProductType],
                                                                 [ProductImage],
                                                                 [Assortment],
                                                                 [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
                  LEFT JOIN @TBL_AttributeValue AS TBAV ON(TBAV.PimCategoryId = ZPP.PimCategoryId)
                  LEFT JOIN ZnodePimCategoryProduct AS ZPCP ON(ZPCP.PimProductId = Zpp.PimProductId
                                                               AND ZPCP.PimCategoryId = Zpp.PimCategoryId)
                  LEFT JOIN ZnodePimCatalogCategory AS ZCC ON(ZCC.PimProductId = Zpp.PimProductId
                                                              AND ZCC.PimCategoryId = Zpp.PimCategoryId
                                                              AND ZCC.PimCatalogId = @PimCatalogId)
                  LEFT JOIN ZnodeProfileCatalogCategory AS ZPCC ON(ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId
                                                                   AND ZPCC.ProfileCatalogId = @ProfileCatalogId)
                  --LEFT JOIN ZnodeMedia AS zm ON(zm.MediaId = piv.[ProductImage])
             ORDER BY CASE
                          WHEN @OrderId = 0
                          THEN 1
                          ELSE ZCC.PimCatalogCategoryId
                      END DESC,
                      zpp.RowId;

         END TRY
         BEGIN CATCH
		    SELECT ERROR_message()
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCatalogCategoryProducts @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PimCategoryId='+CAST(@PimCategoryId AS VARCHAR(50))+',@PimCatalogId='+CAST(@PimCatalogId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@ProfileCatalogId='+CAST(@ProfileCatalogId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetCatalogCategoryProducts',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetSkuListForInventoryAndPrice]...';


GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.procedures WHERE name = 'Znode_GetSkuListForInventoryAndPrice')
BEGIN 
DROP PROC Znode_GetSkuListForInventoryAndPrice
END 
GO 
CREATE  PROCEDURE [dbo].[Znode_GetSkuListForInventoryAndPrice](
       @WhereClause VARCHAR(MAX) ,
       @Rows        INT           = 100 ,
       @PageNo      INT           = 1 ,
       @Order_BY    VARCHAR(1000) = '' ,
       @RowsCount   INT OUT ,
       @LocaleId    INT           = 1 ,
       @PriceListId INT           = 0)
AS 
   /* 
    Summary : this procedure is used to Get the inventory list by sku 
    Unit Testing 
     EXEC Znode_GetSkuListForInventoryAndPrice  '',@Order_BY = '',@RowsCount= 1 ,@Rows = 10,@PageNo= 1,@PriceListId = 26,@LocaleId =1 
     SELECT * FROM ZnodePublishProduct WHERE PimProductid  = 4
   */
     BEGIN
         BEGIN TRY
		     DECLARE @PimProductIds NVARCHAR(max)= '', @OutPimProductIds NVARCHAR(max)= '',@PimAttributeId NVARCHAR(max)=''
			 DECLARE @pimSkuAttributeId VARCHAR(50) = [dbo].[Fn_GetProductSKUAttributeId] ()
			 DECLARE @PimProductNameAttributeId VARCHAR(50) = [dbo].[Fn_GetProductNameAttributeId]()
			 DECLARE @PimProductTypeAttributeId VARCHAR(50) = [dbo].[Fn_GetProductTypeAttributeId]()
			 DECLARE @DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleId()
			 DECLARE @TransferPimProductId TransferId 
			 DECLARE @IsProductNotIn BIT = 1 
			 DECLARE @IMamgePAth NVARCHAR(max) = [dbo].[Fn_GetServerThumbnailMediaPath]()

			 DECLARE @ProductIdTable TABLE
             (
				PimProductId INT,
				CountId      INT,
				RowId        INT IDENTITY(1,1)
             );

			 DECLARE @TBL_AttributeDetails AS TABLE
             (
				PimProductId   INT,
				AttributeValue NVARCHAR(MAX),
				AttributeCode  VARCHAR(600),
				PimAttributeId INT
             );

             IF @PriceListId > 0
             BEGIN
				INSERT INTO @TransferPimProductId 
				SELECT PimProductId 
				FROM  [dbo].[View_PimProductAttributeValueLocale] VIMP
				INNER JOIN ZnodePrice  ZP ON (Zp.SKU = VIMP.AttributeValue )
				WHERE VIMP.PimAttributeid = @pimSkuAttributeId
				AND VIMP.LocaleId = @LocaleId
				AND ZP.PriceListId = @PriceListId
					
               SET @IsProductNotIn = 1 --CASE WHEN @PimProductIds IS NULL OR @PimProductIds = '' then 1 else 0 end 

			   IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId )
			   BEGIN 
					INSERT INTO @TransferPimProductId
					SELECT '-1'
			   END 
			 --  set @PimProductIds = CASE WHEN @PimProductIds IS NULL OR @PimProductIds = '' then  else @PimProductIds end 
		     END;
			-- SELECT * FROM ZnodePrice WHERE PriceListId = 21

		    EXEC Znode_GetProductIdForPaging @whereClauseXML = @WhereClause,@Rows = @Rows,@PageNo = @PageNo,@Order_BY = @Order_BY,@RowsCount = @RowsCount OUT,
             @LocaleId = @LocaleId,@AttributeCode = '',@PimProductId = @TransferPimProductId, @IsProductNotIn = @IsProductNotIn,@OutProductId = @OutPimProductIds OUT;
			
			 INSERT INTO @ProductIdTable (PimProductId)              
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP 
				  	           
             SET @PimProductIds = SUBSTRING((SELECT ','+CAST(PimProductId AS VARCHAR(100)) FROM @ProductIdTable FOR XML PATH('')), 2, 4000);
             SET @PimAttributeId = @pimSkuAttributeId  + ',' + @PimProductNameAttributeId + ',' +@PimProductTypeAttributeId;
			 
			  DECLARE @FamilyDetails TABLE
             (
				PimProductId         INT,
				PimAttributeFamilyId INT,
				FamilyName           NVARCHAR(3000)
             );	


			 INSERT INTO @FamilyDetails ( PimAttributeFamilyId, PimProductId )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId] @PimProductIds, 1;

             UPDATE a
             SET  FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
             INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId AND LocaleId = @LocaleId);

             UPDATE a
             SET FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a 
			 INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL OR a.FamilyName = '';


             INSERT INTO @TBL_AttributeDetails ( PimProductId, AttributeValue, AttributeCode, PimAttributeId )
             EXEC Znode_GetProductsAttributeValue @PimProductIds, @PimAttributeId, @localeId;

           INSERT INTO @TBL_AttributeDetails ( PimProductId, AttributeValue, AttributeCode )
		   SELECT PimProductId,FamilyName ,'AttributeFamily'
		   FROM @FamilyDetails

		    ;With Cte_pimProductDetails AS
			(
			  SELECT PimProductId,
              AttributeValue,
              AttributeCode
			  FROM @TBL_AttributeDetails
			)
			SELECT PimProductId,ProductName,SKU , @IMamgePAth+ZM.[Path] ProductImage, AttributeFamily,[ProductType]
			FROM Cte_pimProductDetails CTEPD
			PIVOT
			(
				Max(AttributeValue) FOR AttributeCode IN ([ProductName],[SKU],[ProductImage],[AttributeFamily],[ProductType])
			) PIV
			LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = Piv.[ProductImage])
			 
			SET @RowsCount = CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM @TBL_AttributeDetails  ) THEN 0 ELSE @RowsCount END 
			
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			 @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetSkuListForInventoryAndPrice @WhereClause = '+
			 CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+
			 @Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PriceListId='+CAST(@PriceListId AS VARCHAR(50))+',@RowsCount='+
			 CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetSkuListForInventoryAndPrice',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_DeletePimProducts]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_DeletePimProducts' )
BEGIN
	DROP PROCEDURE Znode_DeletePimProducts
END
GO
CREATE PROCEDURE [dbo].[Znode_DeletePimProducts]
(
       @PimProductId VARCHAR(2000) ,
       @Status       INT OUT
)
AS
	/* Summary :- This Procedures is used to hard delete the product details on the basis of product ids 
	 Unit Testing
	 begin tran 
	 EXEC [dbo].[Znode_DeletePimProducts] 115,0
	 rollback tran
	*/
    BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN DeletePimProducts;
             DECLARE @TBL_DeletdProductId TABLE (
                                              PimProductId INT
                                              );
             INSERT INTO @TBL_DeletdProductId
                    SELECT Item
                    FROM dbo.split ( @PimProductId , ','
                                   ) AS SP; 
           

		   Delete from ZnodePimConfigureProductAttribute where Exists (SELECT TOP 1 1 FROM @TBL_DeletdProductId TDPI where 
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

		   Delete from ZnodeProfileCatalogCategory where EXISTS (
		   SELECT TOP 1 1 FROM @TBL_DeletdProductId TDPI INNER JOIN ZnodePimCatalogCategory ZPCC ON TDPI.PimProductId = ZPCC.PimProductId
		   AND ZPCC.PimCatalogCategoryId =  ZnodeProfileCatalogCategory.PimCatalogCategoryId ) 

             DELETE FROM ZnodePimCatalogCategory
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimCatalogCategory.PimProductId
                          );
             DELETE FROM ZnodePimCategoryProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimCategoryProduct.PimProductId
                          );
             DELETE FROM ZnodePimProduct
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeletdProductId AS a
                            WHERE a.PimProductId = ZnodePimProduct.PimProductId
                          );

		

             IF ( SELECT COUNT(1)
                  FROM @TBL_DeletdProductId
                ) = ( SELECT COUNT(1)
                      FROM dbo.split ( @PimProductId , ','
                                     ) AS a
                    )
                 BEGIN
                     SELECT 1 AS ID , CAST(1 AS BIT) AS Status;
                 END;
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
GO
PRINT N'Altering [dbo].[Znode_GetAccountListWithAddress]...';


GO


IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetAccountListWithAddress' )
BEGIN
	DROP PROCEDURE Znode_GetAccountListWithAddress
END
GO
CREATE PROCEDURE [dbo].[Znode_GetAccountListWithAddress]
(   @WhereClause VARCHAR(1000),
	@Rows        INT           = 100,
	@PageNo      INT           = 1,
	@Order_BY    VARCHAR(100)  = '',
	@RowsCount   INT OUT,
	@LocaleId    INT           = 0
)
AS
    
/*
     Summary : This procedure is used to find the Account and related address list 
			   1. ZNodePortalAddress          
			   2. ZnodeAddress	
    Unit Testing
	begin tran	 
    Declare @Status int 
    Exec [Znode_GetAccountListWithAddress] @WhereClause = ' name = ''suchita acc'' ' ,@Rows = 10 ,@PageNo = 1 , @Order_BY = ' AccountId DESC ',@RowsCount = 1   
    rollback tran
    Select @Status
    select * from ZNodePortalAddress where PortalAddressId = 8 
    select * from ZNodeAddress where AddressId in (select AddressId from ZNodePortalAddress where PortalAddressId = 8 )
    addressid : 57
*/
  


     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @SQL NVARCHAR(MAX), @Rows_start VARCHAR(1000), @Rows_end VARCHAR(1000);
             SET @Rows_start = CASE WHEN @Rows >= 1000000 THEN 0 ELSE(@Rows * (@PageNo - 1)) + 1 END;
             SET @Rows_end = CASE WHEN @Rows >= 1000000THEN @Rows ELSE @Rows * (@PageNo) END;
             SET @SQL = ' 
			 DECLARE @TBL_AccountsDetails TABLE (AccountId INT ,ExternalId NVARCHAR(200),Name NVARCHAR(200),ParentAccountId INT,ParentAccountName  NVARCHAR(200),PortalId INT ,StoreName nvarchar(MAX),CatalogName nvarchar(MAX),ShippingPostalCode nvarchar(MAX),BillingPostalCode nvarchar(MAX),RowId INT )
			 DECLARE @TBL_AddressDetails TABLE (AccountId INT ,Address NVARCHAR(max),IsDefaultBilling BIT ,IsDefaultShipping BIT,RowId INT  )
			 DECLARE @TBL_AddressDetailsFinal TABLE (AccountId INT ,Address NVARCHAR(max))
			   
			 ;WITH AccountListAis AS 
			 (
				 SELECT  a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, b.Name AS ParentAccountName ,ZPA.PortalId,ZP.StoreName, PC.CatalogName,
				 (select top 1 PostalCode from ZnodeAddress where AddressId in  (select AddressId from ZnodeAccountAddress where AccountId = a.AccountId AND IsDefaultShipping = 1)) AS ShippingPostalCode,
				 (select top 1 PostalCode from ZnodeAddress where AddressId in  (select AddressId from ZnodeAccountAddress where AccountId = a.AccountId AND IsDefaultBilling = 1)) AS BillingPostalCode
				 FROM dbo.ZnodeAccount AS a 
				 LEFT OUTER JOIN dbo.ZnodeAccount AS b ON a.ParentAccountId = b.AccountId
				 LEFT JOIN ZnodePortalAccount ZPA  ON (ZPA.AccountId = a.AccountId)
				 LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZPA.PortalId)
				 LEFT JOIN ZnodePortalCatalog ZPC ON ( ZPA.PortalId = ZPC.PortalId )
				 LEFT JOIN ZnodePublishcatalog PC ON ( PC.PublishcatalogId = COALESCE(a.PublishCatalogId, ZPC.PublishcatalogId ) )
			 )

			 INSERT INTO @TBL_AccountsDetails
			 SELECT *,RANK()OVER(ORDER BY '+CASE
                                                    WHEN @Order_BY = ''
                                                    THEN ' AccountId ,'
                                                    ELSE @Order_BY+' , '
                                                END+' AccountId ) RowId 
			 FROM AccountListAis
			   '+CASE
                        WHEN @WhereClause IS NOT NULL
                             AND @WhereClause <> ''
                        THEN ' WHERE '+@WhereClause
                        ELSE ''
                    END+'
			   '+CASE
                        WHEN @Order_BY = ''
                        THEN ''
                        ELSE ' ORDER BY '+@Order_BY
                    END+'
			    
			 SELECT @COUNT= COUNT(1) FROM @TBL_AccountsDetails

			 INSERT INTO @TBL_AddressDetails (AccountId,Address,IsDefaultBilling,IsDefaultShipping,RowId)
			 SELECT c.AccountId , CASE WHEN D.FirstName IS NULL THEN '''' ELSE D.FirstName END + CASE WHEN D.LastName IS NULL  THEN '''' ELSE '' ''+D.LastName END  
			                    + CASE WHEN D.Address1 IS NULL  THEN  ''''  ELSE '', '' + D.Address1 END 	
								+ CASE WHEN D.Address2 IS NULL THEN ''''  ELSE '', '' + D.Address2 END 
								+ CASE WHEN D.Address3 IS NULL THEN '''' ELSE  '', '' + D.Address3 END 
								+ CASE WHEN D.CityName IS NULL THEN  ''''  ELSE  '', '' + D.CityName  END 
								+ CASE WHEN D.StateName IS NULL THEN ''''  ELSE  '', '' + D.StateName  END 
								+ CASE WHEN D.PostalCode IS NULL THEN  '''' ELSE '', '' + D.PostalCode  END 
								+ CASE WHEN D.CountryName IS NULL THEN '''' ELSE  '', '' + D.CountryName END  									
								+ CASE WHEN D.PhoneNumber IS NULL THEN ''''  ELSE '', PH NO. ''+  D.PhoneNumber END  AS AccountAddress ,ISNULL(d.IsDefaultBilling,0) IsDefaultBilling ,ISNULL(d.IsDefaultShipping,0)IsDefaultShipping
						,ROW_NUMBER()OVER(PARTITION BY c.AccountId ORDER BY  c.AddressId) RowId
			 FROM dbo.ZnodeAccountAddress AS c 
			 LEFT JOIN dbo.ZnodeAddress AS D ON D.AddressId = c.AddressId
			 WHERE EXISTS ( SELECT TOP 1 1 FROM  @TBL_AccountsDetails a  WHERE a.AccountId = c.AccountId AND a.RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+')  
			    
			 ;With AccountAddressShipping AS 
			 (
			 SELECT * FROM @TBL_AddressDetails mn WHERE IsDefaultShipping = 1 
			 )
			 ,  AccountAddressBilling AS 
			 (
				 SELECT * 
				 FROM AccountAddressShipping 
				 UNION ALL 
				 SELECT * 
				 FROM @TBL_AddressDetails mn 
				 WHERE IsDefaultBilling = 1 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM AccountAddressShipping sw WHERE sw.AccountId = mn.AccountId )
			 )


			 INSERT INTO @TBL_AddressDetailsFinal 

			 SELECT AccountId ,Address 
			 FROM AccountAddressBilling 

			    
			 INSERT INTO @TBL_AddressDetailsFinal 
			 SELECT AccountId , Address 
			 FROM @TBL_AddressDetails  q
			 WHERE NOT EXISTS (SELECT  TOP 1 1 FROM @TBL_AddressDetailsFinal  fg WHERE fg.AccountId = q.AccountId )
			 AND RowId = 1 



			 SELECT a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, a.ParentAccountName ,b.[Address] AccountAddress,a.PortalId,a.StoreName, a.CatalogName,ShippingPostalCode,BillingPostalCode
			 FROM @TBL_AccountsDetails a 
			 INNER JOIN @TBL_AddressDetailsFinal  b ON (a.AccountId = b.AccountId )
			 WHERE a.RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+'  
			   '+CASE
                        WHEN @Order_BY = ''
                        THEN ''
                        ELSE ' ORDER BY '+@Order_BY
                 END;
           
		   PRINT(@SQL);
             EXEC SP_executesql
                  @SQL,
                  N'@Count INT OUT',
                  @Count = @RowsCount OUT;
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetAccountListWithAddress @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetAccountListWithAddress',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetBlogNewsList]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetBlogNewsList' )
BEGIN
	DROP PROCEDURE Znode_GetBlogNewsList
END
GO
CREATE PROCEDURE [dbo].[Znode_GetBlogNewsList] 
(   @WhereClause NVarchar(Max) = '',
	@Rows        INT           = 100,
	@PageNo      INT           = 1,
	@Order_BY VARCHAR(1000)    = '',
	@RowsCount   INT OUT,
	@LocaleId    INT           = 0
)
AS 
/*
   Summary:- This proceudre is used to get the blog commets details 
    SELECT * FROM ZnodeCMSSeoType
	Title(BlogNewsTitle)  
 Type (BlogNewsType)
 View Comment (Show total count of comments against that blog/news)
 Start Date (ActivationDate)
 End date(ExpirationDate)
 Created On (CreatedDate)
 Store Name (StoreName)
 SEO Title (SEOTitle)
 SEO Description (SEODescription)
 SEO Keywords (SEOKeywords)
 SEO Friendly URL(SEOUrl)
 Is Active (IsBlogNewsActive)
 Is Allow Guest Comment (IsAllowGuestComment)
   
   EXEC Znode_GetBlogNewsList '' ,100,1,'',0,1
     
*/
BEGIN 
BEGIN TRY 
SET NOCOUNT ON 
 
 DECLARE @DefaultlocaleId INT = dbo.fn_GetDefaultLocaleId()
 DECLARE @TBL_GetBlogComments TABLE (BlogNewsId INT  ,BlogNewsTitle NVARCHAR(1200),BlogNewsType VARCHAR(300),CountComments VARCHAR(2000) 
    ,ActivationDate DATETIME ,ExpirationDate DATETIME , CreatedDate DATETIME
	,StoreName NVARCHAR(max) ,IsAllowGuestComment BIT,IsBlogNewsActive BIT
	--,SEOTitle NVARCHAR(max) ,SEODescription NVARCHAr(max), SEOKeywords NVARCHAR(max),SEOUrl NVARCHAR(max) 
	, RowID INT , CountNo INT )
DECLARE @SQL NVARCHAR(max) = '' 

SET @SQL = '
 ;With Cte_GetBlogComments AS 
 (
   SELECT ZBN.BlogNewsId,BlogNewsTitle ,BlogNewsType ,(SELECT COUNT(1) FROM ZnodeBlogNewsComment ZBC WHERE ZBC.BlogNewsId = ZBN.BlogNewsId)  CountComments
    ,ActivationDate,ExpirationDate ,ZBN.CreatedDate 
	,ZP.StoreName ,ZBCL.localeId ,'+CAST(@DefaultlocaleId AS VARCHAR(50))+' SeoLocaleId ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
   FROM  ZnodeBlogNews  ZBN
   LEFT JOIN ZnodeBlogNewsLocale ZBCL ON (ZBCL.BlogNewsId = ZBN.BlogNewsId)
   LEFT JOIN ZnodePortal ZP ON (Zp.PortalId = ZBN.PortalId )
   --LEFT JOIN ZnodeCMSSeoDetail ZSD ON ( ZSD.SEOId= ZBN.BlogNewsId AND EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSeoType ZCST WHERE ZCST.CMSSEOTypeId= ZSD.CMSSEOTypeId AND ZCST.Name = ''BlogNews''))
   --LEFT JOIN ZnodeCmsSeoDetailLocale ZSDL ON (ZSDL.CMSSEODetailId = ZSD.CMSSEODetailId  AND ZSDL.localeId IN ('+CAST(@DefaultlocaleId AS VARCHAR(50))+','+CAST(@LocaleId AS VARCHAR(50))+'))
   WHERE ZBCL.localeId IN ('+CAST(@DefaultlocaleId AS VARCHAR(50))+','+CAST(@LocaleId AS VARCHAR(50))+' )
 )
 ,Cte_BlogNewForLocale AS 
 (
   SELECT BlogNewsId ,BlogNewsTitle,BlogNewsType ,CountComments
    ,ActivationDate,ExpirationDate , [CreatedDate]
	,StoreName ,localeId , SeoLocaleId ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
   FROM Cte_GetBlogComments 
   WHERE localeId = '+CAST(@LocaleId AS VARCHAR(50))+'
   AND (SeoLocaleId IS NULL OR SeoLocaleId = '+CAST(@LocaleId AS VARCHAR(50))+')
   '+[dbo].[Fn_GetFilterWhereClause](@whereClause)+'
 )
 ,Cte_DefaultLocaleData AS 
 (
   SELECT BlogNewsId ,BlogNewsTitle,BlogNewsType ,CountComments
    ,ActivationDate,ExpirationDate , [CreatedDate]
	,StoreName ,localeId , SeoLocaleId ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
   FROM Cte_BlogNewForLocale
   UNION ALL 
   SELECT BlogNewsId ,BlogNewsTitle,BlogNewsType ,CountComments
    ,ActivationDate,ExpirationDate , [CreatedDate]
	,StoreName ,localeId , SeoLocaleId ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
  FROM Cte_GetBlogComments CTED 
  WHERE NOT EXISTS (SELECT TOP 1 1 FROM Cte_BlogNewForLocale CteBN WHERE CteBN.BlogNewsId= CTED.BlogNewsId )
  AND localeId = '+CAST(@DefaultlocaleId AS VARCHAR(50))+'
  AND (SeoLocaleId IS NULL OR SeoLocaleId = '+CAST(@DefaultlocaleId AS VARCHAR(50))+')
   '+[dbo].[Fn_GetFilterWhereClause](@whereClause)+'
 )
 ,Cte_filterData AS 
 (
 SELECT BlogNewsId ,BlogNewsTitle,BlogNewsType ,CountComments
    ,ActivationDate,ExpirationDate , [CreatedDate]
	,StoreName ,localeId , SeoLocaleId ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
	, '+dbo.Fn_GetPagingRowId(@Order_BY,'BlogNewsId DESC')+',Count(*)Over() CountNo
 FROM Cte_DefaultLocaleData 
 ) 
  SELECT BlogNewsId ,BlogNewsTitle,BlogNewsType ,''View Comments - ''+ CAST(CountComments AS VARCHAR(500)) CountComments
    ,ActivationDate,ExpirationDate , [CreatedDate]
	,StoreName ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
	,RowId,CountNo
  FROM Cte_filterData
  '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows) 
  PRINT @SQL 

 INSERT INTO @TBL_GetBlogComments (BlogNewsId ,BlogNewsTitle,BlogNewsType ,CountComments
    ,ActivationDate,ExpirationDate , [CreatedDate]
	,StoreName  ,IsAllowGuestComment,IsBlogNewsActive
--	,SEOTitle,SEODescription, SEOKeywords,SEOUrl
	,RowId,CountNo)
 EXEC (@SQL)

 SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_GetBlogComments),0)

 SELECT BlogNewsId ,BlogNewsTitle,BlogNewsType ,CountComments
    ,ActivationDate,ExpirationDate , CreatedDate
	,StoreName  ,IsAllowGuestComment,IsBlogNewsActive
	--,SEOTitle,SEODescription, SEOKeywords,SEOUrl
 FROM @TBL_GetBlogComments
 END TRY 
 BEGIN CATCH 
  SELECT ERROR_MESSAGE ()
 END CATCH 
 END
GO
PRINT N'Altering [dbo].[Znode_GetCMSContentPagesFolderDetails]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetCMSContentPagesFolderDetails' )
BEGIN
	DROP PROCEDURE Znode_GetCMSContentPagesFolderDetails
END
GO
CREATE PROCEDURE [dbo].[Znode_GetCMSContentPagesFolderDetails]
( @WhereClause VARCHAR(1000),
  @Rows        INT           = 100,
  @PageNo      INT           = 1,
  @Order_BY    VARCHAR(100)  = NULL,
  @RowsCount   INT OUT,
  @LocaleId    INT           = 1)
AS  
   /* 
    Summary: To get content page folder details 
             Provide output for paging with dynamic where cluase                  
    		 User view : View_CMSContentPagesFolderDetails
    Unit Testing  
    Exec Znode_GetCMSContentPagesFolderDetails '',@RowsCount = 1 
    
	*/
     BEGIN
        BEGIN TRY
          SET NOCOUNT ON;

		     DECLARE @SQL NVARCHAR(MAX);
             DECLARE @DefaultLocaleId VARCHAR(100)= dbo.Fn_GetDefaultLocaleId();
             DECLARE @TBL_ContenetPageLocale TABLE(CMSContentPagesId INT,PortalId INT,CMSTemplateId INT,PageTitle NVARCHAR(200),PageName NVARCHAR(200),ActivationDate DATETIME, ExpirationDate DATETIME,IsActive BIT
				    ,CreatedBy INT,CreatedDate DATETIME,ModifiedBy INT,ModifiedDate DATETIME,PortalName  NVARCHAR(max) ,CMSContentPageGroupId INT 
				    , PageTemplateName NVARCHAR(200),SEOUrl NVARCHAR(max),MetaInformation NVARCHAR(max),SEODescription NVARCHAR(max),SEOTitle NVARCHAR(max),SEOKeywords NVARCHAR(max),CMSContentPageGroupName NVARCHAR(200),RowId INT ,CountNo INT )

             SET @SQL = '  
						;With CMSContentPages AS (
		
						SELECT DISTINCT ZCCP.CMSContentPagesId,ZCCP.PortalId,ZCCP.CMSTemplateId,ZCCPL.PageTitle,ZCCP.PageName,ZCCP.ActivationDate, ZCCP.ExpirationDate,ZCCP.IsActive
						,ZCCP.CreatedBy,ZCCP.CreatedDate,ZCCP.ModifiedBy,ZCCP.ModifiedDate,e.StoreName PortalName   ,ZCCPG.CMSContentPageGroupId 
						,zct.Name PageTemplateName ,zcsd.SEOUrl,zcsd.MetaInformation,ZCCPGL.Name CMSContentPageGroupName,ZCCPL.LocaleId,ZCSDL.SEODescription,ZCSDL.SEOTitle,ZCSDL.SEOKeywords	,ZCSDL.LocaleId LocaleSeo,ZCCPGL.LocaleId LocaeIdRTR 
					    FROM ZnodeCMSContentPages ZCCP 
						LEFt Outer JOIN [ZnodeCMSContentPageGroupMapping] ZCCPGM ON (ZCCPGM.CMSContentPagesId = ZCCP.CMSContentPagesId) 
					    LEFt Outer JOIN [ZnodeCMSContentPageGroup] ZCCPG ON (ZCCPG.CMSContentPageGroupId = ZCCPGM.CMSContentPageGroupId)
						LEFt Outer JOIN [ZnodeCMSContentPagesLocale] ZCCPL ON (ZCCP.CMSContentPagesId = ZCCPL.CMSContentPagesId  )
						LEFt Outer JOIN [ZnodeCMSContentPageGroupLocale] ZCCPGL ON (ZCCPGL.CMSContentPageGroupId = ZCCPG.CMSContentPageGroupId AND ZCCPGL.LocaleId = ZCCPL.LocaleId  )
					
						LEFT JOIN ZnodeCMSTemplate zct ON (zct.CMSTemplateId = ZCCP.CMSTemplateId )
						LEFT JOIN ZnodeCMSSEODetail zcsd ON (zcsd.SEOId = ZCCP.CMSContentPagesId AND ZCSD.Portalid = ZCCP.portalId AND 
					    EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEOType zcst WHERE zcst.CMSSEOTypeId = zcsd.CMSSEOTypeId AND zcst.Name = ''Content Page'' ))
					    LEFT JOIN ZnodeCMSSEODetailLocale ZCSDL ON (ZCSDL.CMSSEODetailId = zcsd.CMSSEODetailId  AND ZCSDL.LocaleId = ZCCPL.LocaleId ) 
						LEFt Outer JOIN ZnodePortal e on ZCCP.PortalId = e.PortalId 
					    WHERE  ZCCPL.LocaleId IN ('+CAST(@LocaleId AS VARCHAR(50))+' , '+CAST(@DefaultLocaleId AS VARCHAR(50))+') 
						--AND ZCSDL.LocaleId IN ('+CAST(@LocaleId AS VARCHAR(50))+' , '+CAST(@DefaultLocaleId AS VARCHAR(50))+') 
						--AND ZCCPGL.LocaleId IN ('+CAST(@LocaleId AS VARCHAR(50))+' , '+CAST(@DefaultLocaleId AS VARCHAR(50))+') 
						AND zcsd.PortalId IS NOT NULL 
						 ) 
						, Cte_ContaintPageDetails AS 
						(
						SELECT CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate, ExpirationDate,IsActive
									,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName,CMSContentPageGroupId 
									, PageTemplateName ,SEOUrl,CMSContentPageGroupName,SEODescription,SEOTitle,SEOKeywords,MetaInformation
						FROM CMSContentPages
						WHERE LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+'
      --                  AND LocaleSeo = '+CAST(@LocaleId AS VARCHAR(50))+'
						--AND LocaeIdRTR   = '+CAST(@LocaleId AS VARCHAR(50))+'
						)
						, Cte_ContentPage  AS (     
	 
							SELECT CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate, ExpirationDate,IsActive
									,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName,CMSContentPageGroupId 
									, PageTemplateName ,SEOUrl,CMSContentPageGroupName,SEOKeywords,SEOTitle,SEODescription,MetaInformation
							FROM Cte_ContaintPageDetails 

						UNION ALL 

						SELECT CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate, ExpirationDate,IsActive
								,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName ,CMSContentPageGroupId 
								, PageTemplateName ,SEOUrl,CMSContentPageGroupName,SEOKeywords,SEOTitle,SEODescription,MetaInformation
					    FROM CMSContentPages CCP 
						WHERE LocaleId = '+CAST(@DefaultLocaleId AS VARCHAR(50))+'
					    AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_ContaintPageDetails CTCPD WHERE CTCPD.CMSContentPagesId  = CCP.CMSContentPagesId AND  CTCPD.Portalid = CCp.PortalId)
					    AND  LocaleSeo = '+CAST(@DefaultLocaleId AS VARCHAR(50))+'
					    	AND LocaeIdRTR   = '+CAST(@DefaultLocaleId AS VARCHAR(50))+'
						)

					    ,Cte_ContenetPageFilter AS 
					    (
					    SELECT CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate, ExpirationDate,IsActive,SEOKeywords,SEOTitle,SEODescription,MetaInformation
									,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName   ,CMSContentPageGroupId 
									, PageTemplateName ,SEOUrl,CMSContentPageGroupName,'+[dbo].[Fn_GetPagingRowId](@Order_BY,'CMSContentPagesId')+',COUNT(*)OVER() CountNo
					    FROM Cte_ContentPage
					    WHERE  1=1 '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+' 
					    )
   
					    SELECT CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate, ExpirationDate,IsActive
									,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName   ,CMSContentPageGroupId 
									, PageTemplateName ,SEOUrl,CMSContentPageGroupName,RowId,CountNo,SEOKeywords,SEOTitle,SEODescription,MetaInformation
					    FROM Cte_ContenetPageFilter
					    '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
   
					   PRINT @SQL
					    INSERT INTO @TBL_ContenetPageLocale (CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate, ExpirationDate,IsActive
									,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName,CMSContentPageGroupId 
									, PageTemplateName ,SEOUrl,CMSContentPageGroupName,RowId,CountNo,SEOKeywords,SEOTitle,SEODescription,MetaInformation)                                                                                                                                            
					   
				
					    EXEC (@SQL)                                                           
					    SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_ContenetPageLocale) ,0)        
					    SELECT CMSContentPagesId,PortalId,CMSTemplateId,PageTitle,PageName,ActivationDate,ExpirationDate,IsActive
							   ,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalName,CMSContentPageGroupId 
							   ,PageTemplateName ,SEOUrl,CMSContentPageGroupName,SEOKeywords,SEOTitle,SEODescription,MetaInformation
						FROM @TBL_ContenetPageLocale

            
    END TRY
    BEGIN CATCH
        DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCMSContentPagesFolderDetails @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		 
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetCMSContentPagesFolderDetails',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
    END CATCH;
END;
GO
PRINT N'Altering [dbo].[Znode_GetCMSCustomerReviewInformation]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetCMSCustomerReviewInformation' )
BEGIN
	DROP PROCEDURE Znode_GetCMSCustomerReviewInformation
END
GO
CREATE PROCEDURE [dbo].[Znode_GetCMSCustomerReviewInformation]
( @WhereClause NVARCHAR(Max),
  @Rows        INT           = 100,
  @PageNo      INT           = 1,
  @Order_BY    VARCHAR(1000)  = '',
  @RowsCount   INT OUT,
  @LocaleId    INT           = 0,
  @PortalId    INT           = 0
  )
AS
/*
 Summary : Procedure is used to Get Customer Review Information.
 Unit Testing:
 exec Znode_GetCMSCustomerReviewInformation @WhereClause='',@RowsCount=null,@Rows = 100,@PageNo=1,@Order_BY = '',@PortalId = 0,@LocaleId = 1
*/
 BEGIN
   BEGIN TRY
      SET NOCOUNT ON;
             DECLARE @SQL NVARCHAR(MAX);
             IF @LocaleId = 0
                 BEGIN
                     SELECT @LocaleId = dbo.Fn_GetDefaultLocaleId();
                 END;
             DECLARE @TBL_CustomerReview TABLE (CMSCustomerReviewId INT ,PublishProductId INT ,UserId INT,Headline NVARCHAR(400) ,Comments NVARCHAR(1000),UserName NVARCHAR(600),StoreName NVARCHAR(600)
												,UserLocation NVARCHAR(2000),Rating INT,[Status] NVARCHAR(20),ProductName NVARCHAR(max),CreatedDate DATETIME,ModifiedDate DATETIME,CreatedBy INT,ModifiedBy INT,SEOUrl NVARCHAR(max),RowId INT,CountNo INT)
			 
		 SET @SQL = ' 
		  ;With Cte_CustomerReview AS 
		  (
		   SELECT CMSCustomerReviewId,a.PublishProductId,UserId,Headline,Comments,UserName,UserLocation,Rating,Status,ZPPD.ProductName,ZPPD.LocaleId,ZP.StoreName
					,a.CreatedDate
					,a.ModifiedDate,a.CreatedBy,a.ModifiedBy,ZCSD.SEOUrl,ZCSD.PortalId
			FROM ZNODECMSCUSTOMERREVIEW A 
			INNER JOIN ZnodePublishProductDetail ZPPD ON (A.PUBLISHPRODUCTID = ZPPD.PUBLISHPRODUCTID AND ZPPD.LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+')
			LEFT OUTER JOIN ZnodeCMSSEODetail ZCSD on (ZPPD.PublishProductId = ZCSD.SEOId AND  (ZCSD.PortalId = '+CAST(@PortalId AS VARCHAR(50))+' OR '+CAST(@PortalId AS VARCHAR(50))+' = 0 )
			AND EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEOType ZCST WHERE  (ZCSD.CMSSEOTypeId = ZCST.CMSSEOTypeId AND ZCST.NAME = ''Product'')
			)
			 )
	
			INNER  JOIN ZnodePortal ZP ON (A.PortalId = ZP.PortalId)
			WHERE ZP.PortalId = '+CAST(@PortalId AS VARCHAR(50))+' OR '+CAST(@PortalId AS VARCHAR(50))+' = 0 
		  )
		  ,Cte_CustomerInfo AS 
		  (		  
		   SELECT CMSCustomerReviewId,PublishProductId,UserId,Headline,Comments,UserName,UserLocation,Rating,Status,ProductName,StoreName
					,CreatedDate,ModifiedDate,CreatedBy,ModifiedBy,SEOUrl ,'+dbo.Fn_GetPagingRowId(@Order_BY,'CMSCustomerReviewId')+',Count(*)Over() CountNo  
		   FROM Cte_CustomerReview 
		   WHERE 1=1
		   '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'
		  )
		  SELECT CMSCustomerReviewId,PublishProductId,UserId,Headline,Comments,UserName,UserLocation,Rating,Status,ProductName,StoreName
					,CreatedDate,ModifiedDate,CreatedBy,ModifiedBy,SEOUrl,RowId,CountNo
		  FROM Cte_CustomerInfo 
		  '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)                                                                                                                                                                                                                                                                        
          
		 PRINT @SQL
		  INSERT INTO @TBL_CustomerReview (CMSCustomerReviewId,PublishProductId,UserId,Headline,Comments,UserName,UserLocation,Rating,[Status],ProductName,StoreName
					,CreatedDate,ModifiedDate,CreatedBy,ModifiedBy,SEOUrl,RowId,CountNo)                                                                                                                                                                                                                                        
          EXEC (@SQL)

		  SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_CustomerReview ),0)

		  SELECT CMSCustomerReviewId,PublishProductId,UserId,Headline,Comments,UserName,UserLocation,Rating,[Status],ProductName
					,CreatedDate,ModifiedDate,CreatedBy,ModifiedBy,SEOUrl,StoreName
		  FROM @TBL_CustomerReview

           
         END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCMSCustomerReviewInformation @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PortalId='+CAST(@PortalId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetCMSCustomerReviewInformation',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetCreateIndexServerStatus]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetCreateIndexServerStatus' )
BEGIN
	DROP PROCEDURE Znode_GetCreateIndexServerStatus
END
GO
CREATE PROCEDURE [dbo].[Znode_GetCreateIndexServerStatus]
(   @WhereClause NVARCHAR(MAX),
    @Rows        INT           = 100,
    @PageNo      INT           = 1,
    @Order_BY    VARCHAR(100)  = '',
    @RowsCount   INT OUT)
AS 
/*
     Summary :- This procedure is used to get the publish products details 
     Unit Testing 
     EXEC Znode_GetCreateIndexServerStatus '',@RowsCount=0
	*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             DECLARE @SQL NVARCHAR(MAX);
             DECLARE @TBL_GetCreateIndexServerStatus TABLE (CatalogIndexId INT,SearchIndexMonitorId INT,SourceId	INT,SourceType NVARCHAR(500),SourceTransactionType NVARCHAR(500),
             AffectedType NVARCHAR(500),ServerName NVARCHAR(200),Status NVARCHAR(200),UserName NVARCHAR(512),CreatedBy INT,CreatedDate DATETIME,ModifiedBy INT,ModifiedDate DATETIME
             ,RowId INT,CountNo INT);

             SET @SQL = '
				;With Cte_GetCreateIndexServerStatusDetails AS 
				(
				SELECT zsim.CatalogIndexId,zsim.SearchIndexMonitorId, zsim.SourceId, zsim.SourceType, zsim.SourceTransactionType, zsim.AffectedType, zsiss.ServerName
					, zsiss.Status,zsiss.CreatedBy,zsiss.CreatedDate,zsiss.ModifiedBy,zsiss.ModifiedDate, IsNull(VIUSD.UserName,''Scheduled Task'') as UserName 
				FROM ZnodeSearchIndexMonitor zsim 
				LEFT OUTER JOIN ZnodeSearchIndexServerStatus zsiss ON zsim.SearchIndexMonitorId=zsiss.SearchIndexMonitorId
				LEFT JOIN View_GetUserDetails VIUSD ON (VIUSD.UserId = ZSIM.CreatedBy) 
				)
				, Cte_GetCreateIndexServerStatusDetailsData AS
				(
		
				SELECT *,'+dbo.Fn_GetPagingRowId(@Order_BY,'SearchIndexMonitorId ')+',Count(*)Over() CountNo
				FROM Cte_GetCreateIndexServerStatusDetails CTPC 
				WHERE 1=1 
						  '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'
				)

				SELECT CatalogIndexId,SearchIndexMonitorId,SourceId,SourceType,SourceTransactionType,AffectedType,ServerName,Status,UserName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowId,CountNo
				FROM Cte_GetCreateIndexServerStatusDetailsData 
				'+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
            
             INSERT INTO @TBL_GetCreateIndexServerStatus
             EXEC (@SQL);
             SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_GetCreateIndexServerStatus), 0);

             SELECT CatalogIndexId,SearchIndexMonitorId,SourceId,SourceType,SourceTransactionType,AffectedType,ISNULL(ServerName,'') as ServerName,ISNULL(Status,'') as Status,
             ISNULL(CreatedBy,'')as CreatedBy,UserName,ISNULL(CreatedDate,'')as CreatedDate,ISNULL(ModifiedBy,'')as ModifiedBy,ISNULL(ModifiedDate,'')as ModifiedDate FROM @TBL_GetCreateIndexServerStatus;

         END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCreateIndexServerStatus @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetCreateIndexServerStatus',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetImportProcessLog]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetImportProcessLog' )
BEGIN
	DROP PROCEDURE Znode_GetImportProcessLog
END
GO
CREATE PROCEDURE [dbo].[Znode_GetImportProcessLog]
( @WhereClause VARCHAR(max),
  @Rows        INT           = 100,
  @PageNo      INT           = 1,
  @Order_BY    VARCHAR(1000)  = '',
  @RowsCount   INT OUT)
AS
  /*
    Summary : Get import process log details include rowwise errors in details.    	
	Unit Testing   
	begin tran 
	DECLARE @RowsCount INT;
    EXEC Znode_GetImportProcessLog @WhereClause = 'ImportProcessLogId = 1151',@Rows = 1000,@PageNo = 0,@Order_BY = '',@RowsCount = @RowsCount OUT;
	rollback tran
    SELECT @RowsCount;
    
  */
     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @SQL NVARCHAR(MAX);
             DECLARE @TBL_ImportLog TABLE(ImportLogId INT,ImportProcessLogId INT,RowNumber BIgInt,ColumnName NVARCHAR(1000),ColumnValue NVARCHAR(max),ErrorDescription NVARCHAR(max)
										,RowId INt , CountNo Int )  ;
             SET @SQL = ' 
							;with Cte_ErrorLog AS 
							(
								SELECT zil.ImportLogId, zil.ImportProcessLogId, ISNULL(zil.RowNumber, 0) [RowNumber], ISNULL(zil.ColumnName, '''') [ColumnName],
								ISNULL(zil.Data, '''') [ColumnValue], zm.MessageName + 
								CASE 
								WHEN zm.MessageCode IN (17,4)	AND Name in (''Pricing'') AND ISNULL(zil.ColumnName, '''') NOT like ''%Quantity%'' THEN +''  ''+ dbo.Fn_GetDefaultPriceRoundOff(isnull(DefaultErrorValue,''0000000.00'') - 1)
								WHEN zm.MessageCode IN (17,4)	AND Name in (''Pricing'') AND ISNULL(zil.ColumnName, '''') like ''%Quantity%''  THEN +''  ''+ dbo.Fn_GetDefaultInventoryRoundOff(isnull(DefaultErrorValue,''0000000.00'') - 1) 
								WHEN zm.MessageCode IN (17,4)	AND Name in (''Inventory'')  THEN +''  ''+ dbo.Fn_GetDefaultInventoryRoundOff(isnull(DefaultErrorValue,''0000000.00'') - 1) 
								WHEN zm.MessageCode IN (16,41,4) AND Name in (''Pricing'') AND ISNULL(zil.ColumnName, '''') NOT like ''%Quantity%'' THEN +''  ''+ dbo.Fn_GetDefaultPriceRoundOff(isnull(DefaultErrorValue,''0000000.00'' ))
								WHEN zm.MessageCode IN (16,41,4) AND Name in (''Pricing'') AND ISNULL(zil.ColumnName, '''')  like ''%Quantity%'' THEN +''  ''+ dbo.Fn_GetDefaultInventoryRoundOff(isnull(DefaultErrorValue,''0000000.00'' ))
								WHEN zm.MessageCode IN (16,41,4) AND Name in (''Inventory'') THEN +''  ''+ dbo.Fn_GetDefaultInventoryRoundOff(isnull(DefaultErrorValue,''0000000.00'' ))
								WHEN zm.MessageCode IN (44) AND Name in (''Pricing'') THEN +''  ''+ isnull(DefaultErrorValue,''0000000.00'' )
								ELSE ''''END ''ErrorDescription'' ,zil.ModifiedDate,zil.GUID
								FROM ZnodeImportLog AS zil INNER JOIN ZnodeMessage AS zm ON zil.ErrorDescription = CONVERT(VARCHAR(50) , zm.MessageCode)
								INNER JOIN ZnodeImportProcessLog zipl ON zil.ImportProcessLogId = zipl.ImportProcessLogId
								LEFT Outer JOIN ZnodeImportTemplate zit  ON zipl.ImportTemplateId = zit.ImportTemplateId
								LEFT Outer JOIN ZnodeImportHead zih ON zit.ImportHeadId =zih.ImportHeadId 
								)
								,Cte_ErrorLogFilter As ( SELECT ImportLogId,ImportProcessLogId,[RowNumber],[ColumnName],[ColumnValue],[ErrorDescription],[ModifiedDate],GUID
												,'+dbo.Fn_GetPagingRowId(@Order_BY , 'ImportLogId')+',Count(*)Over() CountNo 
								 FROM Cte_ErrorLog
								 WHERE 1 = 1 '+dbo.Fn_GetFilterWhereClause(@WhereClause)+' 
							 )

							SELECT ImportLogId,ImportProcessLogId,RowNumber,ColumnName,ColumnValue,ErrorDescription,RowId, CountNo 
							FROM Cte_ErrorLogFilter '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
print @SQL
			 INSERT INTO @TBL_ImportLog (ImportLogId,ImportProcessLogId,RowNumber,ColumnName,ColumnValue,ErrorDescription,RowId, CountNo)
			 EXEC (@SQL)
				 SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_ImportLog), 0);
             SELECT ImportLogId,ImportProcessLogId,RowNumber,ColumnName,ColumnValue,ErrorDescription
			 FROM @TBL_ImportLog
		 END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetImportProcessLog @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetImportProcessLog',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;                                    
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetSKUInventoryList]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetSKUInventoryList' )
BEGIN
	DROP PROCEDURE Znode_GetSKUInventoryList
END
GO
CREATE PROCEDURE [dbo].[Znode_GetSKUInventoryList]
(   @WhereClause VARCHAR(1000),
    @Rows        INT           = 100,
    @PageNo      INT           = 1,
    @Order_BY    VARCHAR(100)  = '',
    @RowsCount   INT OUT,
    @LocaleId    INT           = 1)
AS 
    /*
    Summary : this procedure is used to Get the inventory list by sku 
    Unit Testing 
     EXEC Znode_GetSKUInventoryList  '' ,@RowsCount= 1,@PageNo= 1 ,@Rows = 100
     SELECT * FROM ZnodePublishProduct WHERE PimProductid  = 4
    */
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             DECLARE @SQL NVARCHAR(MAX);
			 DECLARE @TBL_InventoryList TABLE (InventoryId INT ,WarehouseId INT ,WarehouseCode NVARCHAR(100),WarehouseName VARCHAR(100),SKU  VARCHAR(300)
			 ,Quantity NUMERIC (28,6),ReOrderLevel NUMERIC (28,6),ProductName NVARCHAR(max),RowId INT,CountNo INT);

             DECLARE @DefaultLocaleId VARCHAR(100)= Dbo.Fn_GetDefaultValue('Locale');
             SET @SQL = '
						DECLARE @TBL_ZnodeInventoryList TABLE (InventoryId INT ,WarehouseId INT ,WarehouseCode NVARCHAR(100),WarehouseName VARCHAR(100),SKU  VARCHAR(300),Quantity NUMERIC (28,6),ReOrderLevel NUMERIC (28,6) )
						DECLARE @TBL_InventoryListFindProduct TABLE (InventoryId INT ,WarehouseId INT ,WarehouseCode NVARCHAR(100),WarehouseName VARCHAR(100),SKU  VARCHAR(300),Quantity NUMERIC (28,6),ReOrderLevel NUMERIC (28,6),ProductName NVARCHAR(max),LocaleId INT  )				
						DECLARE @TBL_InventorySKU TABLE (PimProductId INT ,InventoryId INT,SKU VARCHAR(600) )
						
						
                  IF  OBJECT_ID(''tempdb..#test'') is not null
				  BEGIN 
					DROP TABLE #TBL_AttributeVAlue
				  END 	
					 SELECT VIR.PimProductId,PimAttributeId,ZnodePimAttributeValueLocaleId,VIR.LocaleId ,COUNT(*)Over(Partition By VIR.PimProductId,PimAttributeId ORDER BY VIR.PimProductId,PimAttributeId  ) RowId
					 INTO #TBL_AttributeVAlue
					 FROM View_LoadManageProductInternal VIR
					 WHERE LocaleId = '+CAST(@LocaleId AS VARCHAR(100))+' OR LocaleId ='+@DefaultLocaleId+'
					 AND  AttributeCode IN ( ''SKU'',''ProductName'')	
					
					;With CTE_InventoryListWithSKU AS 
						(
					SELECT  CTE.PimProductId , CTEI.AttributeValue ProductName,ZW.WarehouseCode,ZW.WarehouseName , CTEI.LocaleId,SKU,SPN.InventoryId,SPN.WarehouseId
						,SPN.Quantity,SPN.ReOrderLevel
                    FROM View_LoadManageProductInternal CTE
					INNER JOIN View_LoadManageProductInternal CTEI ON (CTEI.PimProductId = CTE.Pimproductid AND CTEI.AttributeCode = ''ProductName'' )
					INNER JOIN #TBL_AttributeVAlue CT ON (Ct.PimAttributeId = CTEI.PimAttributeId AND Ct.ZnodePimAttributeValueLocaleId = CTEI.ZnodePimAttributeValueLocaleId AND CT.LocaleId  = CASE WHEN ct.RowId = 2 THEN  '+CAST(@LocaleId AS VARCHAR(100))+' ELSE '+@DefaultLocaleId+' END )
					INNER JOIN ZnodeInventory  SPN ON ((SELECT ''''+SPN.SKU FOR XML PATH(''''))  = CTE.AttributeValue)
					INNER JOIN ZnodeWarehouse ZW ON (ZW.WarehouseId = SPN.WarehouseId) 
					INNER JOIN #TBL_AttributeVAlue CT2 ON (Ct2.PimAttributeId = CTE.PimAttributeId AND Ct2.ZnodePimAttributeValueLocaleId = CTE.ZnodePimAttributeValueLocaleId AND CT2.LocaleId  = CASE WHEN ct2.RowId = 2 THEN  '+CAST(@LocaleId AS VARCHAR(100))+' ELSE '+@DefaultLocaleId+' END )
					WHERE CTE.AttributeCode = ''SKU''
						)


						,CTE_ListDetailForPaging AS 
						(SELECT InventoryId,WarehouseId,WarehouseCode,WarehouseName,SKU,Quantity,ReOrderLevel,ProductName
						,'+dbo.Fn_GetPagingRowId(@Order_BY,'InventoryId DESC')+',Count(*)Over() CountNo 
						FROM CTE_InventoryListWithSKU
						WHERE 1=1 
						 '+dbo.Fn_GetFilterWhereClause(@WhereClause)+')
				
						SELECT InventoryId,WarehouseId,WarehouseCode,WarehouseName,dbo.Fn_Trim(SKU)SKU,Quantity,ReOrderLevel,dbo.Fn_Trim(ProductName)ProductName,RowId,CountNo
						FROM CTE_ListDetailForPaging 
						'+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
			PRINT @SQL

				--SElect @SQL
				INSERT INTO @TBL_InventoryList(InventoryId,WarehouseId,WarehouseCode,WarehouseName,SKU,Quantity,ReOrderLevel,ProductName,RowId,CountNo)
				EXEC (@SQL);

            SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_InventoryList), 0);

            SELECT InventoryId,WarehouseId,WarehouseCode,WarehouseName,SKU,Quantity,ReOrderLevel,ProductName
			FROM @TBL_InventoryList;
           
         END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetSKUInventoryList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetSKUInventoryList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetTouchPointConfigurationList]...';


GO
  
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetTouchPointConfigurationList' )
BEGIN
	DROP PROCEDURE Znode_GetTouchPointConfigurationList
END
GO
CREATE PROCEDURE [dbo].[Znode_GetTouchPointConfigurationList]
(   @TouchPointConfigurationXML XML,
	@WhereClause                VARCHAR(1000) = NULL,
	@Rows                       INT           = 1000,
	@PageNo                     INT           = 1,
	@Order_BY                   VARCHAR(100)  = 'ConnectorTouchPoints',
	@IsAssigned					bit			  = 0,
	@RowsCount                  INT OUT)  

AS
/*
Summary: This Procedure is used to get
Unit Testing :
 EXEC [dbo].[Znode_GetTouchPointConfigurationList]
*/

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
		  DECLARE  @TBL_TouchPointConfiguration  TABLE  (ERPTaskSchedulerId INT ,ERPConfiguratorId int,Interface Nvarchar(200) ,SchedulerName Nvarchar(200), SchedulerType varchar(20),ConnectorTouchPoints nvarchar(500)
											   ,IsEnabled bit,Triggers VArchar(max),NextRunTime VArchar(50),SchedulerCreatedDate Varchar(50),EventID int,LastRunResult VArchar(200),LastRunTime VArchar(50),RowId INT  , CountId INT)
											 

		 IF @Order_BY LIKE '%ConnectorTouchPoints%'
		 BEGIN 
		   SET @Order_BY = @Order_BY+',Interface'
		 END 
		 ELSE IF @Order_BY LIKE '%Interface%' 
		 BEGIN 
		 SET @Order_BY = @Order_BY+',ConnectorTouchPoints' 
		 END 
		 ELSE IF @Order_BY LIKE '%schedulername%' 
		 BEGIN 
		 SET @Order_BY = +''+@Order_BY+',ConnectorTouchPoints' 
		 END 
		 ELSE IF @Order_BY LIKE '%schedulertype%' 
		 BEGIN 
		 SET @Order_BY = +''+@Order_BY+',ConnectorTouchPoints' 
		 END 
		 ELSE IF @Order_BY LIKE '%IsEnabled%' 
		 BEGIN 
		 SET @Order_BY = +''+@Order_BY+',ConnectorTouchPoints' 
		 END 
		 ELSE IF @Order_BY = '' OR  @Order_BY IS NULL 
		 BEGIN 
		  SET @Order_BY ='IsEnabled desc,Interface,ConnectorTouchPoints' 
		 END 
		 ELSE 
		 BEGIN 
		  SET  @Order_BY = @Order_BY+',ConnectorTouchPoints,Interface' 
		 END 



             DECLARE @SQL NVARCHAR(MAX);
             SET @SQL = ' 
   
     DECLARE  @TBL_TouchPointConfiguration  TABLE  (ERPTaskSchedulerId INT ,ERPConfiguratorId int,Interface Nvarchar(200) ,SchedulerName Nvarchar(200),SchedulerType varchar(20),ConnectorTouchPoints nvarchar(500)
											   ,IsEnabled bit,Triggers VArchar(max),NextRunTime VArchar(50),SchedulerCreatedDate Varchar(50),EventID int,LastRunResult VArchar(200),LastRunTime VArchar(50)
											 )
   
    INSERT INTO @TBL_TouchPointConfiguration
		SELECT 
				 Tbl.Col.value(''ERPTaskSchedulerId[1]'', ''NVARCHAR(max)'') ERPTaskSchedulerId
				,Tbl.Col.value(''ERPConfiguratorId[1]'', ''NVARCHAR(max)'') ERPConfiguratorId
				,Tbl.Col.value(''Interface[1]'', ''NVARCHAR(max)'') Interface
				,Tbl.Col.value(''SchedulerName[1]'', ''NVARCHAR(max)'') SchedulerName
				,Tbl.Col.value(''SchedulerType[1]'', ''VARCHAR(max)'') SchedulerType
				,Tbl.Col.value(''ConnectorTouchPoints[1]'', ''NVARCHAR(max)'') ConnectorTouchPoints
				,Tbl.Col.value(''IsEnabled[1]'', ''NVARCHAR(max)'') IsEnabled
				,Tbl.Col.value(''Triggers[1]'', ''NVARCHAR(max)'') Triggers
				,Tbl.Col.value(''NextRunTime[1]'', ''NVARCHAR(max)'') NextRunTime
				,Tbl.Col.value(''SchedulerCreatedDate[1]'', ''NVARCHAR(max)'') SchedulerCreatedDate
				,Tbl.Col.value(''EventID[1]'', ''NVARCHAR(max)'') EventID
				,Tbl.Col.value(''LastRunResult[1]'', ''NVARCHAR(max)'') LastRunResult
				,Tbl.Col.value(''LastRunTime[1]'', ''NVARCHAR(max)'') LastRunTime
		 FROM   @TouchPointConfigurationXML.nodes(''//ArrayOfTouchPointConfigurationModel//TouchPointConfigurationModel'') Tbl(Col)




  ;With Cte_GetTouchPointList AS
   (
	   SELECT  a.ERPTaskSchedulerId ,a.ERPConfiguratorId,Interface ,ISNULL(a.SchedulerName,'''') as SchedulerName,ISNULL(a.SchedulerType,'''') as SchedulerType,ConnectorTouchPoints ,a.IsEnabled  ,ISNULL(Triggers,'''') as Triggers ,ISNULL(NextRunTime,'''') as NextRunTime
					,SchedulerCreatedDate ,EventID,ISNULL(LastRunResult,'''') as LastRunResult, ISNULL(LastRunTime,'''') as LastRunTime
	   FROM @TBL_TouchPointConfiguration a
	   left outer join ZnodeERPTaskScheduler b on(a.ERPConfiguratorId =b.ERPConfiguratorId and a.ConnectorTouchPoints = b.TouchPointName and '+cast(@IsAssigned as varchar(1))+' = 1 )
	   WHERE b.TouchPointName IS NULL
    ), 
   Cte_GetTouchPointListDetails as 
   (
   SELECT *,'+[dbo].[Fn_GetPagingRowId](@Order_BY,'IsEnabled desc,Interface,ConnectorTouchPoints')+' ,Count(*)Over() CountId
   FROM Cte_GetTouchPointList 
   where 1=1  '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)
   +'
   ) SELECT * 
   FROM Cte_GetTouchPointListDetails 
   '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)+'
   '  
             PRINT @SQL
         
			INSERT INTO @TBL_TouchPointConfiguration 
		
		     EXEC SP_executesql
                  @SQL,
                  N'@TouchPointConfigurationXML XML ',
                  @TouchPointConfigurationXML = @TouchPointConfigurationXML;
           SET @RowsCount = ISNULL((SELECT TOP 1 CountId FROM @TBL_TouchPointConfiguration ),0)

		   SELECT a.ERPTaskSchedulerId ,a.ERPConfiguratorId,Interface , a.SchedulerName,a.SchedulerType,ConnectorTouchPoints ,a.IsEnabled  , Triggers ,NextRunTime
				,SchedulerCreatedDate ,EventID, LastRunResult ,LastRunTime
		   FROM @TBL_TouchPointConfiguration  a
		
         END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetTouchPointConfigurationList @TouchPointConfigurationXML='+CAST(@TouchPointConfigurationXML AS VARCHAR(max))+', @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetTouchPointConfigurationList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[ZnodeReport_DashboardTopSearches]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'ZnodeReport_DashboardTopSearches' )
BEGIN
	DROP PROCEDURE ZnodeReport_DashboardTopSearches
END
GO
CREATE PROCEDURE [dbo].[ZnodeReport_DashboardTopSearches]
(       
	@PortalId       VARCHAR(MAX)  = '',
	@BeginDate      DATE          = NULL,
	@EndDate        DATE          = NULL
)
AS 
/*
     Summary:- This procedure is used to get the order details 
    Unit Testing:
     EXEC ZnodeReport_DashboardTopSearches 10
	*/
     BEGIN
	 BEGIN TRY
       SET NOCOUNT ON;
	   SELECT TOP 5  Data1 Searches , Count(*) Times  FROM ZnodeActivityLog where ActivityLogTypeId = 9500
		AND 	 ((EXISTS
				   (
					   SELECT TOP 1 1
					   FROM dbo.split(@PortalId, ',') SP
					   WHERE CAST(PortalId AS VARCHAR(100)) = SP.Item
							 OR @PortalId = ''
				   ))
			  )	
		AND (CAST(ActivityCreateDate AS DATE) BETWEEN CASE
											WHEN @BeginDate IS NULL
											THEN CAST(ActivityCreateDate AS DATE)
											ELSE @BeginDate
											END AND CASE
													WHEN @EndDate IS NULL
													THEN CAST(ActivityCreateDate AS DATE)
													ELSE @EndDate
												END)
		Group by Data1 Order by Count(*)  desc 
		END TRY

		BEGIN CATCH
		DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardTopSearches @PortalId = '+@PortalId+',@BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'ZnodeReport_DashboardTopSearches',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
		END CATCH
     END;
GO
PRINT N'Creating [dbo].[Znode_GetBlogNewsCommentList]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetBlogNewsCommentList' )
BEGIN
	DROP PROCEDURE Znode_GetBlogNewsCommentList
END
GO
CREATE PROCEDURE [dbo].[Znode_GetBlogNewsCommentList]
(   @WhereClause NVarchar(Max) = '',
	@Rows        INT           = 100,
	@PageNo      INT           = 1,
	@Order_BY VARCHAR(1000)    = '',
	@RowsCount   INT OUT,
	@LocaleId    INT           = 0
)
AS 
/*
   Summary:- This proceudre is used to get the blog comments details 
    SELECT * FROM ZnodeCMSSeoType
	Title(BlogNewsTitle)  
 Type (BlogNewsType)
 Created On (CreatedDate)
 Store Name (StoreName)
 Customer (Email)
 Comment (BlogNewsComment)
 Is Approved (IsApproved)
 EXEC Znode_GetBlogNewsCommentList @RowsCount =0 
   
 
*/
BEGIN 
BEGIN TRY 
SET NOCOUNT ON 
 
 DECLARE @DefaultlocaleId INT = dbo.fn_GetDefaultLocaleId()
 DECLARE @TBL_GetBlogNewsComments TABLE (
											BlogNewsCommentId INT  ,
											BlogNewsTitle NVARCHAR(1200),
											BlogNewsType VARCHAR(300), 
											CreatedDate DATETIME,
											StoreName NVARCHAR(max),
											IsApproved BIT,
											Customer NVARCHAR(max),
											BlogNewsComment NVARCHAR(max),
											RowID INT ,
											CountNo INT,LocaleName NVARCHAR(200)  )
DECLARE @SQL VARCHAR(max) = '' 

	SET @SQL = '
	 ;With Cte_GetBlogComments AS 
	 (
	   SELECT ZBNC.BlogNewsCommentId,ZBNCLL.BlogNewsTitle ,ZBN.BlogNewsType ,ZBNC.CreatedDate ,ZBNCL.BlogComment BlogNewsComment
		,ZP.StoreName ,ZBNCLL.localeId ,ZBNCL.localeId  SeoLocaleId ,ZBNC.IsApproved,
		CASE WHEN ZU.AspNetUserId IS NOT NULL THEN  ISNULL(ASZU.FirstName,'''')+'' ''+ISNULL(ASZU.LastName,'''') ELSE  ''Guest'' END  Customer ,ZBN.BlogNewsId,ZL.Name LocaleName  
	   FROM  ZnodeBlogNews ZBN
	   INNER  JOIN ZnodeBlogNewsLocale ZBNCLL On(ZBNCLL.BlogNewsId = ZBN.BlogNewsId)
	   INNER  JOIN ZnodeBlogNewsComment ZBNC ON (ZBNC.BlogNewsId = ZBN.BlogNewsId)
	   INNER  JOIN ZnodeBlogNewsCommentLocale ZBNCL ON (ZBNCL.BlogNewsCommentId = ZBNC.BlogNewsCommentId AND ZBNCLL.LocaleId = ZBNCL.LocaleID )
	   LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZBN.PortalId )
	   LEFT JOIN ZnodeUser ZU ON (ZU.UserId=ZBNC.UserId)
	   LEFT JOIN AspNetUsers ASU ON (Asu.Id = ZU.AspNetUserId )
	   LEFT JOIN ZnodeUSer ASZU ON (ASZU.AspNetUserId = ASU.Id )
	   LEFT JOIN ZnodeLocale ZL ON (ZL.LocaleID = ZBNCL.localeId)
	  -- WHERE ZBNCL.localeId IN ('+CAST(@DefaultlocaleId AS VARCHAR(50))+','+CAST(@LocaleId AS VARCHAR(50))+' )
	)
	 ,Cte_BlogNewForLocale AS 
	 (
	   SELECT *--BlogNewsCommentId,BlogNewsTitle,BlogNewsType,[CreatedDate],StoreName,IsApproved,Customer,BlogNewsComment,localeId,BlogNewsId,LocaleName
	   FROM Cte_GetBlogComments
	   WHERE 1 = 1
	   --localeId = '+CAST(@LocaleId AS VARCHAR(50))+'
	   --AND (SeoLocaleId IS NULL OR SeoLocaleId = '+CAST(@LocaleId AS VARCHAR(50))+')
	   '+[dbo].[Fn_GetFilterWhereClause](@whereClause)+'
	 )
	,Cte_BlogComments AS
	(
	   SELECT ZBNC.BlogNewsCommentId,ZBNCLL.BlogNewsTitle ,ZBN.BlogNewsType ,ZBNC.CreatedDate ,ZBNCL.BlogComment BlogNewsComment
		,ZP.StoreName ,ZBNCLL.localeId ,ZBNCL.localeId  SeoLocaleId ,ZBNC.IsApproved,
		CASE WHEN ZU.AspNetUserId IS NOT NULL THEN  ISNULL(ASZU.FirstName,'''')+'' ''+ISNULL(ASZU.LastName,'''') ELSE  ''Guest'' END  Customer ,ZBN.BlogNewsId,ZL1.Name LocaleName  
	   FROM  ZnodeBlogNews ZBN
	   INNER JOIN ZnodeBlogNewsLocale ZBNCLL On(ZBNCLL.BlogNewsId = ZBN.BlogNewsId)
	   LEFT JOIN ZnodeBlogNewsComment ZBNC ON (ZBNC.BlogNewsId = ZBN.BlogNewsId)
	   LEFT JOIN ZnodeBlogNewsCommentLocale ZBNCL ON (ZBNCL.BlogNewsCommentId = ZBNC.BlogNewsCommentId )--AND ZBNCLL.LocaleId = ZBNCL.LocaleID )
	   LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZBN.PortalId )
	   LEFT JOIN ZnodeUser ZU ON (ZU.UserId=ZBNC.UserId)
	   LEFT JOIN AspNetUsers ASU ON (Asu.Id = ZU.AspNetUserId )
	   LEFT JOIN ZnodeUSer ASZU ON (ASZU.AspNetUserId = ASU.Id )
	   LEFT JOIN ZnodeLocale ZL ON (ZL.LocaleID = ZBNCLL.localeId)
	   LEFT JOIN ZnodeLocale ZL1 ON (ZL1.LocaleID = ZBNCL.localeId)
	   INNER JOIN Cte_BlogNewForLocale BNL ON ( ZBNCLL.BlogNewsTitle = BNL.BlogNewsTitle )
	   WHERE NOT EXISTS( SELECT * FROM Cte_BlogNewForLocale A WHERE ZBNC.BlogNewsCommentId = ISNULL( A.BlogNewsCommentId, 0 ) )
	    AND ZL.IsDefault = 1 AND ZBNC.BlogNewsCommentId  IS NOT NULL 
	   UNION
	   SELECT ZBNC.BlogNewsCommentId,ZBNCLL.BlogNewsTitle ,ZBN.BlogNewsType ,ZBNC.CreatedDate ,ZBNCL.BlogComment BlogNewsComment
		,ZP.StoreName ,ZBNCLL.localeId ,ZBNCL.localeId  SeoLocaleId ,ZBNC.IsApproved,
		CASE WHEN ZU.AspNetUserId IS NOT NULL THEN  ISNULL(ASZU.FirstName,'''')+'' ''+ISNULL(ASZU.LastName,'''') ELSE  ''Guest'' END  Customer ,ZBN.BlogNewsId,ZL1.Name LocaleName
	   FROM  ZnodeBlogNews ZBN
	   INNER  JOIN ZnodeBlogNewsLocale ZBNCLL On(ZBNCLL.BlogNewsId = ZBN.BlogNewsId)
	   INNER  JOIN ZnodeBlogNewsComment ZBNC ON (ZBNC.BlogNewsId = ZBN.BlogNewsId)
	   INNER  JOIN ZnodeBlogNewsCommentLocale ZBNCL ON (ZBNCL.BlogNewsCommentId = ZBNC.BlogNewsCommentId )-- AND ZBNCLL.LocaleId = ZBNCL.LocaleID )
	   LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZBN.PortalId )
	   LEFT JOIN ZnodeUser ZU ON (ZU.UserId=ZBNC.UserId)
	   LEFT JOIN AspNetUsers ASU ON ( Asu.Id = ZU.AspNetUserId )
	   LEFT JOIN ZnodeUSer ASZU ON ( ASZU.AspNetUserId = ASU.Id )
	   LEFT JOIN ZnodeLocale ZL ON (ZL.LocaleID = ZBNCLL.localeId)
	   LEFT JOIN ZnodeLocale ZL1 ON (ZL1.LocaleID = ZBNCL.localeId)
	   WHERE EXISTS ( SELECT * FROM ZnodeBlogNewsCommentLocale ZBNC1 WHERE ZBNC.BlogNewsCommentId = ZBNC1.BlogNewsCommentId AND ZBNCL.localeId = ZBNC1.localeId )  
	   AND NOT EXiSTS ( SELECT * FROM ZnodeBlogNewsLocale ZBNL1 WHERE ZBNCLL.BlogNewsId = ZBNL1.BlogNewsId AND ZBNCL.localeId = ZBNL1.localeId )
	   AND NOT EXISTS( SELECT * FROM Cte_BlogNewForLocale A WHERE ZBNC.BlogNewsCommentId = ISNULL( A.BlogNewsCommentId, 0 ) )
	   AND ZL.IsDefault = 1 
	)
	,Cte_BlogCommentsfilter AS
	(
		SELECT * FROM Cte_BlogComments
		WHERE 1 = 1 '+[dbo].[Fn_GetFilterWhereClause](@whereClause)+'
	)
	,Cte_BlogWiseComments AS
	(
		SELECT * FROM Cte_BlogNewForLocale
		UNION ALL
		SELECT * FROM Cte_BlogCommentsfilter
	)
	,Cte_filterData AS 
	(
	  SELECT BlogNewsCommentId,BlogNewsTitle,BlogNewsType,[CreatedDate],StoreName,IsApproved,Customer,BlogNewsComment,'+dbo.Fn_GetPagingRowId(@Order_BY,'BlogNewsId DESC')+',Count(*)Over() CountNo,LocaleName
	  FROM Cte_BlogWiseComments
	) 
	SELECT BlogNewsCommentId,BlogNewsTitle,BlogNewsType,[CreatedDate],StoreName,IsApproved,Customer,BlogNewsComment,RowId, CountNo,LocaleName
	FROM Cte_filterData
	  '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows) 

	  PRINT @SQL 
 
	 INSERT INTO @TBL_GetBlogNewsComments (BlogNewsCommentId,BlogNewsTitle,BlogNewsType,[CreatedDate],StoreName,IsApproved,Customer,BlogNewsComment,RowId,CountNo,LocaleName)
	 EXEC (@SQL)

	 SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_GetBlogNewsComments),0)

	 SELECT BlogNewsCommentId,BlogNewsTitle,BlogNewsType,CreatedDate,StoreName,IsApproved,Customer,BlogNewsComment,RowId,CountNo,LocaleName
	 FROM @TBL_GetBlogNewsComments

 END TRY 
 BEGIN CATCH 
  SELECT ERROR_MESSAGE ()
 END CATCH 
 END
GO
PRINT N'Creating [dbo].[Znode_GetFromOrderWarehouse]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetFromOrderWarehouse' )
BEGIN
	DROP PROCEDURE Znode_GetFromOrderWarehouse
END
GO
CREATE  Procedure [dbo].[Znode_GetFromOrderWarehouse]
(
@OmsOrderLineItemsId NVARCHAR(MAX),
@Sku nvarchar(max)
--@RowsCount INT = 0 OUT
)
As
begin

select zow.OmsOrderLineItemsId, zow.WarehouseId, DRE.Quantity ,ZCP.SKU
from ZnodeOmsOrderWarehouse zow 
INNER JOIN ZNodeOmsOrderLineItems DRE ON (DRE.OmsOrderLineItemsId = ZOW.OmsOrderLineItemsId)
INNER JOIN ZnodeOmsOrderDetails TTY ON (TTY.OmsOrderDetailsId = DRE.OmsOrderDetailsId )
INNER JOIN ZnodeInventory ZCP ON zow.WarehouseId = ZCP.WarehouseId 
where EXISTS (SELECT TOP 1 1 FROM dbo.split(@OmsOrderLineItemsId,',') SP WHERE  zow.OmsOrderLineItemsId = Sp.Item)
AND EXISTS (SELECT TOP 1 1 FROM dbo.Split(@Sku,',') SP WHERE SP.item = ZCP.SKU AND SP.Item = DRE.SKU )
AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodeOmsOrderState THDD WHERE THDD.OmsOrderStateId = TTY.OmsOrderStateId  AND THDD.OrderStateName='SHIPPED' )

--SELECT @RowsCount  RowsCount 

End


 --var skus = (from orderlineItem in orderModel.OrderLineItems
 --                      join warehouse in _orderWarehouseRepository.Table on orderlineItem.OmsOrderLineItemsId equals warehouse.OmsOrderLineItemsId
 --                      join inventory in _inventoryRepository.Table on warehouse.WarehouseId equals inventory.WarehouseId
 --                      where inventory.SKU == orderlineItem.Sku & orderlineItem.OrderLineItemState != ZNodeOrderStatusEnum.SHIPPED.ToString()
 --                      select new { sku = orderlineItem.Sku, warehouseId = warehouse.WarehouseId, quantity = orderlineItem.Quantity });
GO
PRINT N'Creating [dbo].[Znode_GetImportERPConnectorLogs]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetImportERPConnectorLogs' )
BEGIN
	DROP PROCEDURE Znode_GetImportERPConnectorLogs
END
GO
CREATE  PROCEDURE [dbo].[Znode_GetImportERPConnectorLogs]
( @WhereClause NVARCHAR(max),
  @Rows        INT           = 100,
  @PageNo      INT           = 1,
  @Order_BY    VARCHAR(1000)  = '',
  @RowsCount   INT OUT)
AS
    /*
	
    Summary : Get Import Template Log details and errorlog associated to it
    Unit Testing 
	BEGIN TRAN
    DECLARE @RowsCount INT;
    EXEC Znode_GetImportERPConnectorLogs @WhereClause = ' ',@Rows = 1000,@PageNo = 1,@Order_BY = NULL,@RowsCount = @RowsCount OUT;
	rollback tran
   
    */
	 BEGIN
        BEGIN TRY
          SET NOCOUNT ON;
		     DECLARE @SQL NVARCHAR(MAX);
             DECLARE @TBL_ErrorLog TABLE(ERPTaskSchedulerId INT, SchedulerName NVARCHAR(200),SchedulerType VARCHAR(20) ,
										TouchPointName NVARCHAR(200),
										[ImportStatus] VARCHAR(50) ,ProcessStartedDate DATETIME ,ProcessCompletedDate DATETIME
										,ImportProcessLogId INT,RowId INT,CountNo  INT,SuccessRecordCount int,FailedRecordcount INT)

             SET @SQL = ' 
			 	

					   ;With Cte_ErrorLog AS (
									   select zih.ERPTaskSchedulerId, 
									   Case when zih.SchedulerType = ''RealTime'' then zih.SchedulerName + '' - '' + ''RealTime''
									   else zih.SchedulerName end SchedulerName, 
									   zih.SchedulerType,
									   CASE when ZIT.ImportTemplateId is not null THEN 
									   zih.TouchPointName + '' - '' + ZIT.TemplateName
									   ELSE zih.TouchPointName END TouchPointName
									   ,zipl.Status ImportStatus ,
									   zipl.ProcessStartedDate,
									   zipl.ProcessCompletedDate,zipl.ImportProcessLogId,
									   zipl.SuccessRecordCount,zipl.FailedRecordcount
									   from ZnodeImportProcessLog zipl 
									   Inner join ZnodeERPTaskScheduler zih on zipl.ERPTaskSchedulerId = zih.ERPTaskSchedulerId
									   LEFT Outer JOIN ZnodeImportTemplate ZIT ON zipl.ImportTemplateId = ZIT.ImportTemplateId
								     ) 
						,Cte_ErrorlogFilter AS
						(
					   SELECT ERPTaskSchedulerId,SchedulerName,SchedulerType,TouchPointName,ImportStatus,
						ProcessStartedDate,ProcessCompletedDate,ImportProcessLogId
						,'+dbo.Fn_GetPagingRowId(@Order_BY,'ImportProcessLogId DESC')+', Count(*)Over() CountNo
					   ,SuccessRecordCount,FailedRecordcount FROM Cte_ErrorLog
					   WHERE 1 = 1 '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'
						) 
					   SELECT ERPTaskSchedulerId,SchedulerName,SchedulerType,TouchPointName,ImportStatus,
							ProcessStartedDate,ProcessCompletedDate,ImportProcessLogId
							,RowId,CountNo ,SuccessRecordCount,FailedRecordcount
					   FROM Cte_ErrorlogFilter 
					   '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
	        
			 INSERT INTO @TBL_ErrorLog (ERPTaskSchedulerId,SchedulerName,SchedulerType,TouchPointName,ImportStatus,ProcessStartedDate,ProcessCompletedDate,ImportProcessLogId,RowId,CountNo,SuccessRecordCount,FailedRecordcount )
			 EXEC(@SQl)												
             SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_ErrorLog ), 0);

			 SELECT ERPTaskSchedulerId , SchedulerName ,SchedulerType  ,
										TouchPointName ,
										[ImportStatus] ,ProcessStartedDate ,ProcessCompletedDate 
										,ImportProcessLogId ,RowId ,CountNo  ,SuccessRecordCount,FailedRecordcount
			 FROM @TBL_ErrorLog
             
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetImportTemplateLogs @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status,ERROR_MESSAGE();                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetImportTemplateLogs',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;                   
         END CATCH;
     END;
GO
PRINT N'Creating [dbo].[Znode_GetProductsAttributeValue_newTesting]...';


GO


IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetProductsAttributeValue_newTesting' )
BEGIN
	DROP PROCEDURE Znode_GetProductsAttributeValue_newTesting
END
GO
CREATE PROCEDURE [dbo].[Znode_GetProductsAttributeValue_newTesting]
(   @PimProductId  transferid readonly ,
    @AttributeId transferid readonly,
    @LocaleId      INT = 0,
	@IsPublish bit = 0  )
AS
/* 
    
     Summary:- This Procedure is used to get the product attribute values 
			   The result is fetched from all locale for ProductId provided
     Unit Testing 
     EXEC Znode_GetProductsAttributeValue_1 '2146','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',0
	 SELECT * FROM ZnodePIMProduct
	 EXEC Znode_GetProductsAttributeValue '121','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',1
	 
	 EXEC Znode_GetProductsAttributeValue '121','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',2,@IsPublish =1 
    
*/	
	 BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 		
			--  DECLARE #TBL_AttributeValue1 TABLE (PimAttributeValueId INT , PimAttributeId INT , PimProductId INT,AttributeCode VARCHAR(200)  )
			  DECLARE @DefaultLocaleId INT = dbo.FN_GetDefaultLocaleID()

			--  INSERT INTO  (PimAttributeValueId , PimAttributeId , PimProductId,AttributeCode )
	          SELECT PimAttributeValueId , ZPAV.PimAttributeId , PimProductId,AttributeCode
			  INTO #TBL_AttributeValue1
			  FROM ZnodePimAttributeValue ZPAV 
			  INNER JOIN  ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)		
			  WHERE EXISTS (SELECT TOP 1 1 FROM @PimProductId TBLP WHERE TBLP.Id = ZPAV.PimProductId )
			  AND EXISTS (SELECT TOP 1 1 FROM @AttributeId TBLA WHERE TBLA.Id = ZPAV.PimAttributeId  )
			
			CREATE TABLE #TBL_AttributeValue  (PimAttributeValueId INT  , PimAttributeId  INT , PimProductId INT ,AttributeCode NVARCHAR(600),AttributeValue NVARCHAR(max),TypeOfData INT 
						,PimAttributeValueLocaleId INT ,LocaleId INT , RowId INT )
	         
			 INSERT INTO #TBL_AttributeValue		 
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.AttributeValue,1 TypeOfData
						,ZPAVL.ZnodePimAttributeValueLocaleId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
	     	 FROM ZnodePimAttributeValueLocale  ZPAVL 
			 INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 
			-- UNION ALL 
			 INSERT INTO #TBL_AttributeValue
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.AttributeValue,1 TypeOfData
						,ZPAVL.PimProductAttributeTextAreaValueId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 FROM ZnodePimProductAttributeTextAreaValue  ZPAVL 
			 INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 
			
			 INSERT INTO #TBL_AttributeValue
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,
			CAST( ZPAVL.PimAttributeDefaultValueId AS VARCHAR(2000)),2 TypeOfData
						,ZPAVL.PimProductAttributeDefaultValueId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 FROM ZnodePimProductAttributeDefaultValue  ZPAVL 
			 INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 
			 
			 INSERT INTO #TBL_AttributeValue
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,CAST( ZPAVL.MediaId AS VARCHAR(2000)) ,3 TypeOfData
						,ZPAVL.PimProductAttributeMediaId PimAttributeValueLocaleId,ZPAVL.LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 FROM ZnodePimProductAttributeMedia  ZPAVL 
			 INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 

			 
			 ;WITH Cte_GetDefaultData 
				AS 
				(
					SELECT ZPPADV.PimAttributeValueId ,ZPADVL.AttributeDefaultValue ,ZPADVL.LocaleId ,ZPPADV.PimProductId ,ZPPADV.AttributeCode,ZPPADV.PimAttributeId
					FROM #TBL_AttributeValue ZPPADV 
					INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)
					INNER JOIN ZnodePimAttributeDefaultValueLocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = ZPPADV.AttributeValue )
					WHERE ZPADVL.LocaleID IN (@LocaleId,@DefaultLocaleId)
					AND TypeOfData = 2 
					AND ZPPADV.LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END 
				
				)
				
				,Cte_AttributeValueDefault AS 
				(
				 SELECT AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId
				 FROM Cte_GetDefaultData 
				 WHERE LocaleId = @LocaleId 
				 UNION  
				 SELECT  AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId
				 FROM Cte_GetDefaultData a 
				 WHERE LocaleId = @DefaultLocaleId 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)
     			)
			
			 SELECT  PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId  
			 FROM  #TBL_AttributeValue 
             WHERE LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END 
			 AND TypeOfData = 1  

			 UNION ALL 

			 SELECT DISTINCT PimProductId,
			         SUBSTRING ((SELECT ','+[dbo].[Fn_GetMediaThumbnailMediaPath]( zm.PATH) FROM ZnodeMedia ZM WHERE ZM.MediaId = TBLAV.AttributeValue 
					 FOR XML PATH ('')  ),2,4000) ,AttributeCode,PimAttributeId
			 FROM #TBL_AttributeValue TBLAV 
			 WHERE  LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END 
			 AND TypeOfData = 3
			 -- GROUP BY PimAttributeId,PimProductId,AttributeCode
			UNION ALL
			SELECT DISTINCT PimProductId,
			 SUBSTRING ((SELECT ',' + AttributeDefaultValue 
													FROM Cte_AttributeValueDefault CTEAI 
													WHERE CTEAI.PimProductId = CTEA.PimProductId 
													AND CTEAI.PimAttributeId = CTEA.PimAttributeId
													FOR XML PATH ('')   ),2,4000) AttributeDefaultValue,AttributeCode ,PimAttributeId
				
			FROM Cte_AttributeValueDefault  CTEA 
			
		
		 END TRY
         BEGIN CATCH
		    SELECT ERROR_MESSAGE()
            DECLARE @Status BIT ;
			SET @Status = 0;
			--DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			--@ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductsAttributeValue_1 @PimProductId = '+@PimProductId+
			--',@AttributeCode='+@AttributeCode+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			--SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			--EXEC Znode_InsertProcedureErrorLog
			--	@ProcedureName = 'Znode_GetProductsAttributeValue_1',
			--	@ErrorInProcedure = @Error_procedure,
			--	@ErrorMessage = @ErrorMessage,
			--	@ErrorLine = @ErrorLine,
			--	@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Creating [dbo].[Znode_GetProductsAttributeValue_newTesting2]...';


GO


IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetProductsAttributeValue_newTesting2' )
BEGIN
	DROP PROCEDURE Znode_GetProductsAttributeValue_newTesting2
END
GO
CREATE  PROCEDURE [dbo].[Znode_GetProductsAttributeValue_newTesting2]
(   @PimProductId  transferid readonly ,
    @AttributeId transferid readonly,
    @LocaleId      INT = 0,
	@IsPublish bit = 0  )
AS
/* 
    
     Summary:- This Procedure is used to get the product attribute values 
			   The result is fetched from all locale for ProductId provided
     Unit Testing 
     EXEC Znode_GetProductsAttributeValue_1 '2146','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',0
	 SELECT * FROM ZnodePIMProduct
	 EXEC Znode_GetProductsAttributeValue '121','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',1
	 
	 EXEC Znode_GetProductsAttributeValue '121','ProductName,SKU,Price,Quantity,IsActive,ProductType,Image,Assortment,DisplayOrder,Style,Material',2,@IsPublish =1 
    
*/	
	 BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 		
			  DECLARE @TBL_AttributeValue TABLE (PimAttributeValueId INT , PimAttributeId INT , PimProductId INT,AttributeCode VARCHAR(200)  )
			  DECLARE @DefaultLocaleId INT = dbo.FN_GetDefaultLocaleID()

			  INSERT INTO @TBL_AttributeValue (PimAttributeValueId , PimAttributeId , PimProductId,AttributeCode )
	          SELECT PimAttributeValueId , ZPAV.PimAttributeId , PimProductId,AttributeCode
			  FROM ZnodePimAttributeValue ZPAV 
			  INNER JOIN  ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)		
			  WHERE EXISTS (SELECT TOP 1 1 FROM @PimProductId TBLP WHERE TBLP.Id = ZPAV.PimProductId )
			  AND EXISTS (SELECT TOP 1 1 FROM @AttributeId TBLA WHERE TBLA.Id = ZPAV.PimAttributeId  )
			
			 
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.AttributeValue,1 TypeOfData
						,ZPAVL.ZnodePimAttributeValueLocaleId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 INTO #TBL_AttributeValue 
			 FROM ZnodePimAttributeValueLocale  ZPAVL 
			 INNER JOIN @TBL_AttributeValue TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 
			 UNION ALL 
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.AttributeValue,1 TypeOfData
						,ZPAVL.PimProductAttributeTextAreaValueId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 FROM ZnodePimProductAttributeTextAreaValue  ZPAVL 
			 INNER JOIN @TBL_AttributeValue TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 
			 UNION ALL
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,
			 ZPAVL.PimAttributeDefaultValueId,2 TypeOfData
						,ZPAVL.PimProductAttributeDefaultValueId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 FROM ZnodePimProductAttributeDefaultValue  ZPAVL 
			 INNER JOIN @TBL_AttributeValue TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 
			 UNION ALL
			 SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.MediaId,3 TypeOfData
						,ZPAVL.PimProductAttributeMediaId PimAttributeValueLocaleId,ZPAVL.LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId
			 FROM ZnodePimProductAttributeMedia  ZPAVL 
			 INNER JOIN @TBL_AttributeValue TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)
			 WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId 

			 ;WITH Cte_GetDefaultData 
				AS 
				(
					SELECT ZPPADV.PimAttributeValueId ,ZPADVL.AttributeDefaultValue ,ZPADVL.LocaleId ,ZPPADV.PimProductId ,ZPPADV.AttributeCode,ZPPADV.PimAttributeId
					FROM #TBL_AttributeValue ZPPADV 
					INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)
					INNER JOIN ZnodePimAttributeDefaultValueLocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = ZPPADV.AttributeValue )
					WHERE ZPADVL.LocaleID IN (@LocaleId,@DefaultLocaleId)
					AND TypeOfData = 2 
					AND ZPPADV.LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END 
				
				)
				
				,Cte_AttributeValueDefault AS 
				(
				 SELECT AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId
				 FROM Cte_GetDefaultData 
				 WHERE LocaleId = @LocaleId 
				 UNION  
				 SELECT  AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId
				 FROM Cte_GetDefaultData a 
				 WHERE LocaleId = @DefaultLocaleId 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)
     			)
			
			 SELECT PimAttributeId,PimProductId,AttributeCode,AttributeValue 
			 FROM  #TBL_AttributeValue 
             WHERE LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END 
			 AND TypeOfData = 1  

			 UNION ALL 

			 SELECT DISTINCT PimAttributeId,PimProductId,AttributeCode,
			         SUBSTRING ((SELECT ','+[dbo].[Fn_GetMediaThumbnailMediaPath]( zm.PATH) FROM ZnodeMedia ZM WHERE ZM.MediaId = TBLAV.AttributeValue 
					 FOR XML PATH ('')  ),2,4000) 
			 FROM #TBL_AttributeValue TBLAV 
			 WHERE  LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END 
			 AND TypeOfData = 3
			 -- GROUP BY PimAttributeId,PimProductId,AttributeCode
			UNION ALL
			SELECT DISTINCT PimAttributeId,PimProductId,AttributeCode,
			 SUBSTRING ((SELECT ',' + AttributeDefaultValue 
													FROM Cte_AttributeValueDefault CTEAI 
													WHERE CTEAI.PimProductId = CTEA.PimProductId 
													AND CTEAI.PimAttributeId = CTEA.PimAttributeId
													FOR XML PATH ('')   ),2,4000) AttributeDefaultValue , LocaleId
				
			FROM Cte_AttributeValueDefault  CTEA 
			
			
			
			
			
			
			
			
			
				--DECLARE @TBL_AttributeDefault TABLE (PimAttributeId INT,AttributeDefaultValueCode VARCHAR(100),IsEditable BIT,AttributeDefaultValue NVARCHAR(MAX),DisplayOrder INT)
				--DECLARE @DefaultLocaleId INT = DBO.FN_GetDefaultLocaleId()
				--DECLARE @TBL_MediaValue TABLE (PimAttributeValueId INT,PimProductId INT,MediaPath NVARCHAR(MAX),PimAttributeId INT ,LocaleId INT )
				--DECLARE @TBL_PimProductId TABLE (PimProductId INT)
			
				
				--INSERT INTO @TBL_PimProductId 
				--SELECT Item FROM dbo.Split( @PimProductId, ',' ) AS SP 
				
				--INSERT INTO @TBL_MediaValue
				--	SELECT ZPAV.PimAttributeValueId	
				--			,PimProductId
				--			,ZPPAM.MediaId MediaPath
				--			,ZPAV.PimAttributeId , ZPPAM.LocaleId
				--	FROM ZnodePimAttributeValue ZPAV
				--	INNER JOIN ZnodePimProductAttributeMedia ZPPAM ON ( ZPPAM.PimAttributeValueId = ZPAV.PimAttributeValueId)
				--	LEFT JOIN ZnodeMedia ZM ON (Zm.Path = ZPPAM.MediaPath)  
				
			
				--;WITH Cte_GetDefaultData 
				--AS 
				--(
				--	SELECT ZPPADV.PimAttributeValueId ,ZPADVL.AttributeDefaultValue ,ZPADVL.LocaleId 
				--	FROM ZnodePimProductAttributeDefaultValue ZPPADV 
				--	INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)
				--	INNER JOIN ZnodePimAttributeDefaultValueLocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )
				--	WHERE ZPADVL.LocaleID IN (@LocaleId,@DefaultLocaleId)
				--	AND EXISTS (SELECT TOP 1 1 FROM @TBL_PimProductId TBPP  WHERE TBPP.PimProductId = ZPAV.PimProductId)
				--	)
				
				--,Cte_AttributeValueDefault AS 
				--(
				-- SELECT PimAttributeValueId ,AttributeDefaultValue ,@DefaultLocaleId LocaleId 
				-- FROM Cte_GetDefaultData 
				-- WHERE LocaleId = @LocaleId 
				-- UNION  
				-- SELECT PimAttributeValueId ,AttributeDefaultValue ,@DefaultLocaleId LocaleId 
				-- FROM Cte_GetDefaultData a 
				-- WHERE LocaleId = @DefaultLocaleId 
				-- AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)
    -- 			)
				--,Cte_AttributeLocaleComma 
				--AS 
				--(
				--SELECT DISTINCT PimAttributeValueId ,SUBSTRING ((SELECT ',' + AttributeDefaultValue 
				--									FROM Cte_AttributeValueDefault CTEAI 
				--									WHERE CTEAI.PimAttributeValueId = CTEA.PimAttributeValueId 
				--									FOR XML PATH ('')   ),2,4000) AttributeDefaultValue , LocaleId
				
				--FROM Cte_AttributeValueDefault  CTEA 
				--)
				--,Cte_AllAttributeData AS 
				--(
				--	SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,ZPPATV.AttributeValue,ZPAV.PimAttributeId,ZPPATV.LocaleId
				--	FROM ZnodePimAttributeValue ZPAV
				--	INNER join ZnodePimProductAttributeTextAreaValue ZPPATV ON (ZPPATV.PimAttributeValueId= ZPAV.PimAttributeValueId)
				--	INNER JOIN @TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
				--	UNION ALL
					
				--	SELECT PimAttributeValueId,TBM.PimProductId
				--			,MediaPath
				--			,PimAttributeId,LocaleId
				--	from @TBL_PimProductId TBPP   
				--	INNER JOIN @TBL_MediaValue TBM ON (TBM.PimProductId = TBPP.PimProductId)

				--	UNION ALL 
				--	SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,ZPAVL.AttributeValue,ZPAV.PimAttributeId,ZPAVL.LocaleId
				--	FROM ZnodePimAttributeValue ZPAV
				--	INNER JOIN ZnodePimAttributeValueLocale  ZPAVL ON ( ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId)
				--	INNER JOIN @TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
				--	INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
				--	WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@AttributeCode,',') SP WHERE (SP.Item = ZPA.AttributeCode  OR SP.Item = CAST(ZPA.PimATtributeId  AS VARCHAR(50)) )) 
				--	AND ZPAVL.LocaleId IN (@LocaleId,@DefaultLocaleId)
					 
				--	UNION ALL
				--	SELECT ZPAV.PimAttributeValueId,ZPAV.PimProductId,CS.AttributeDefaultValue,ZPAV.PimAttributeId,LocaleId
				--	FROM ZnodePimAttributeValue ZPAV
				--	INNER JOIN Cte_AttributeLocaleComma CS ON (ZPAV.PimAttributeValueId = CS.PimAttributeValueId)
				--	INNER JOIN @TBL_PimProductId TBPP ON (ZPAV.PimProductId = TBPP.PimProductId)
				--)
				--, Cte_AttributeFirstLocal AS 
				--(
				--	SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
				--	FROM Cte_AllAttributeData
				--	WHERE LocaleId = @LocaleId
				--)
				--,Cte_DefaultAttributeValue AS 
				--(
				--	SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
				--	FROM Cte_AttributeFirstLocal
				--	UNION ALL 
				--	SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
				--	FROM Cte_AllAttributeData CTAAD
				--	WHERE LocaleId = @DefaultLocaleId
				--	AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_AttributeFirstLocal CTRT WHERE CTRT.PimAttributeValueId = CTAAD.PimAttributeValueId   )
			 --	)

				--INSERT INTO @TBL_AttributeValue
				--SELECT PimAttributeValueId,PimProductId,AttributeValue,PimAttributeId
				--FROM  Cte_DefaultAttributeValue 
				
				--If @IsPublish = 1 
				--Begin
				
				--	DECLARE @Tlb_ReadMultiSelectValue TABLE ( AttributeDefaultValueCode NVARCHAR(300),PimAttributeId INT)
				--	INSERT INTO @Tlb_ReadMultiSelectValue ( AttributeDefaultValueCode ,PimAttributeId ) 
				--	SELECT zpav.AttributeDefaultValueCode,zpa.PimAttributeId 
				--	   FROM ZnodePimAttributeDefaultValue AS zpav 
				--	   RIGHT  OUTER JOIN dbo.ZnodePimAttribute AS zpa ON zpav.PimAttributeId = zpa.PimAttributeId
				--	   INNER JOIN dbo.ZnodeAttributeType AS zat ON zpa.AttributeTypeId = zat.AttributeTypeId
				--	   WHERE 
				--	   zat.AttributeTypeName IN ('Multi Select')
    --                union All 
				--	 Select ZPA.AttributeCode,ZPA.PimAttributeId   from ZnodePimAttributeValidation ZPAV INNER JOIN ZnodeAttributeInputValidation ZAIV 
				--	ON ZPAV.InputValidationId = ZAIV.InputValidationId 
				--	INNER JOIN ZnodePimAttribute ZPA ON ZPAV.PimAttributeId = ZPA.PimAttributeId
				--	where ZAIV.Name  in ('IsAllowMultiUpload') and ltrim(rtrim(ZPAV.Name)) = 'true'
	
				--	SELECT PimProductId,AttributeValue,ZPA.AttributeCode,TBAV.PimAttributeId FROM @TBL_AttributeValue TBAV
				--	INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
				--	WHERE NOT Exists (Select TOP 1 1 FROM @Tlb_ReadMultiSelectValue where PimAttributeId = TBAV.PimAttributeId) 
				--	UNION ALL 
				--	Select PimProductId, SUBSTRING((Select ','+ CAST(ZPAXML.AttributeValue  AS VARCHAR(50)) from @TBL_AttributeValue ZPAXML where  
				--	ZPAXML.PimProductId = TBAV.PimProductId AND ZPAXML.PimAttributeId = TBAV.PimAttributeId FOR XML PATH('') ), 2, 4000) 
				--	AttributeValue, ZPA.AttributeCode,TBAV.PimAttributeId 
				--	FROM @TBL_AttributeValue TBAV
				--	INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
				--	WHERE Exists (Select TOP 1 1 FROM @Tlb_ReadMultiSelectValue where PimAttributeId = TBAV.PimAttributeId  ) 
				--	GROUP BY TBAV.PimProductId ,TBAV.PimAttributeId ,ZPA.AttributeCode
			
				--End
				--Else 
				--Begin	
				--	SELECT PimProductId, AttributeValue,ZPA.AttributeCode,TBAV.PimAttributeId 
				--	FROM @TBL_AttributeValue TBAV
				--	INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = TBAV.PimAttributeId)
				--	WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@AttributeCode,',') SP WHERE (SP.Item = ZPA.AttributeCode  OR SP.Item = CAST(ZPA.PimATtributeId  AS VARCHAR(50)) )) 
				--End
		 END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
			SET @Status = 0;
			--DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			--@ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductsAttributeValue_1 @PimProductId = '+@PimProductId+
			--',@AttributeCode='+@AttributeCode+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			--SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			--EXEC Znode_InsertProcedureErrorLog
			--	@ProcedureName = 'Znode_GetProductsAttributeValue_1',
			--	@ErrorInProcedure = @Error_procedure,
			--	@ErrorMessage = @ErrorMessage,
			--	@ErrorLine = @ErrorLine,
			--	@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Creating [dbo].[Znode_GetPublishBlogNews]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetPublishBlogNews' )
BEGIN
	DROP PROCEDURE Znode_GetPublishBlogNews
END
GO
CREATE  PROCEDURE [dbo].[Znode_GetPublishBlogNews]
(
 @PortalId INT = 0 
)
AS
/*
   This Procedure is used to publish the blog news against the store 
  
 EXEC Znode_GetPublishBlogNews 1 



*/
BEGIN 
BEGIN TRY 
SET NOCOUNT ON
   DECLARE @LocaleId INT , @DefaultLocaleId INT = dbo.Fn_GetDefaultLocaleId(), @MaxCount INT =0 , @IncrementalId INT = 1  
   DECLARE @TBL_Locale TABLE (LocaleId INT , RowId INT IDENTITY(1,1))
   DECLARE @TBL_BlogData TABLE (BlogNewsId INT,PortalId INT ,MediaId INT ,BlogNewsType NVARCHAR(max),IsBlogNewsActive BIT ,IsAllowGuestComment BIT,LocaleId INT ,BlogNewsTitle NVARCHAR(max),CMSContentPagesId INT
   ,BodyOverview NVARCHAR(max),Tags NVARCHAR(max),BlogNewsContent NVARCHAR(max),CreatedDate DATETIME,ActivationDate DATETIME ,ExpirationDate DATETIME, MediaPath varchar(max) )
   INSERT INTO @TBL_Locale (LocaleId)
   SELECT LocaleId 
   FROM ZnodeLocale 
   WHERE IsActive =1 

   SET @MaxCount = ISNULL((SELECT MAx(RowId) FROM @TBL_Locale),0)
   
   WHILE @IncrementalId <= @MaxCount
   BEGIN 

   SET @localeId = (SELECT Top 1 LocaleId FROM @TBL_locale WHERE RowId = @IncrementalId)

  ;With Cte_GetCmsBlogNewsData AS 
  (
    SELECT ZBN.BlogNewsId,PortalId,ZBN.MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,ZBNL.LocaleId
	,BlogNewsTitle,ZBN.CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,ZBN.CreatedDate,ActivationDate,ExpirationDate,zm.Path MediaPath
	FROM ZnodeBlogNews ZBN 
	INNER JOIN ZnodeBlogNewsLocale ZBNL ON (ZBNL.BlogNewsId = ZBN.BlogNewsId)
	LEFT JOIN ZnodeBlogNewsContent ZBNC ON ( ZBNC.BlogNewsId = ZBN.BlogNewsId AND ZBNC.LocaleId = ZBNL.LocaleId) 
	left join znodemedia ZM on(ZM.MediaId = ZBN.MediaId)
	WHERE (ZBNL.LocaleId = @localeId OR ZBNL.LocaleId = @DefaultLocaleId)  
	AND ZBn.PortalId = @PortalId 
	AND ZBN.IsBlogNewsActive = 1 
  )
  , Cte_GetFirstFilterData AS
  (
    SELECT BlogNewsId,PortalId,MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,LocaleId
	,BlogNewsTitle,CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,CreatedDate,ActivationDate,ExpirationDate,MediaPath
	FROM Cte_GetCmsBlogNewsData 
	WHERE LocaleId = @localeId
  )
  , Cte_GetDefaultFilterData AS
  (
   SELECT BlogNewsId,PortalId,MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,LocaleId
   ,BlogNewsTitle,CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,CreatedDate,ActivationDate,ExpirationDate,MediaPath
   FROM  Cte_GetFirstFilterData 
   UNION ALL 
   SELECT BlogNewsId,PortalId,MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,LocaleId
   ,BlogNewsTitle,CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,CreatedDate,ActivationDate,ExpirationDate,MediaPath
   FROM Cte_GetCmsBlogNewsData CTEC 
   WHERE LocaleId = @DefaultLocaleId 
   AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_GetFirstFilterData CTEFD WHERE CTEFD.BlogNewsId = CTEC.BlogNewsId )
   )
   INSERT INTO @TBL_BlogData (BlogNewsId,PortalId,MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,LocaleId,BlogNewsTitle
   ,CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,CreatedDate,ActivationDate,ExpirationDate,MediaPath)
   SELECT BlogNewsId,PortalId,MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,@localeId,BlogNewsTitle
   ,CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,CreatedDate,ActivationDate,ExpirationDate,MediaPath
   FROM Cte_GetDefaultFilterData

  SET @IncrementalId = @IncrementalId +1 
  END 

SELECT BlogNewsId,PortalId,MediaId,BlogNewsType,IsBlogNewsActive,IsAllowGuestComment,LocaleId,BlogNewsTitle,CMSContentPagesId,BodyOverview,Tags,BlogNewsContent,CreatedDate,ActivationDate,ExpirationDate,MediaPath
FROM @TBL_BlogData 


END TRY 
BEGIN CATCH 
SELECT ERROR_MESSAGE()
END CATCH
END
GO
PRINT N'Creating [dbo].[Znode_ImportCustomerAddress]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportCustomerAddress' )
BEGIN
	DROP PROCEDURE Znode_ImportCustomerAddress
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportCustomerAddress](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @LocaleId int= 0,@PortalId int ,@CsvColumnString nvarchar(max))
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import SEO Details
	
	-- Unit Testing : 
	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max),@IsAllowGlobalLevelUserCreation nvarchar(10)

		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive Value from global setting 
		Select @IsAllowGlobalLevelUserCreation = FeatureValues from ZnodeGlobalsetting where FeatureName = 'AllowGlobalLevelUserCreation'
		-- Three type of import required three table varible for product , category and brand

		DECLARE @InsertCustomerAddress TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int,UserName	nvarchar(512)
			,FirstName	varchar	(300),LastName	varchar	(300),DisplayName	nvarchar(1200),Address1	varchar	(300),Address2	varchar	(300)
			,CountryName	varchar	(3000),StateName	varchar	(3000),CityName	varchar	(3000),PostalCode	varchar	(50)
			,PhoneNumber	varchar	(50),Mobilenumber	varchar(50),AlternateMobileNumber	varchar(50),FaxNumber	varchar(30),IsDefaultBilling	bit 
			,IsDefaultShipping	bit	,IsActive	bit	,ExternalId	nvarchar(2000), GUID NVARCHAR(400)
		);
		
		--SET @SSQL = 'SELECT RowNumber,UserName,FirstName,LastName,MiddleName,BudgetAmount,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId,GUID FROM '+ @TableName;
		SET @SSQL = 'SELECT RowNumber,' + @CsvColumnString + ',GUID FROM '+ @TableName;
		INSERT INTO @InsertCustomerAddress( RowNumber,UserName,FirstName,LastName,DisplayName,Address1,Address2,CountryName,
											StateName,CityName,PostalCode,PhoneNumber,Mobilenumber,AlternateMobileNumber,FaxNumber,
											IsDefaultBilling,IsActive,IsDefaultShipping,ExternalId,GUID )
		EXEC sys.sp_sqlexec @SSQL;

	
		-- start Functional Validation 

		-----------------------------------------------
		If @IsAllowGlobalLevelUserCreation = 'true'
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '19', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomerAddress AS ii
					   WHERE ii.UserName NOT IN 
					   (
						   SELECT UserName FROM AspNetZnodeUser   where PortalId = @PortalId
					   );
		Else 
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '19', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomerAddress AS ii
					   WHERE ii.UserName NOT IN 
					   (
						   SELECT UserName FROM AspNetZnodeUser   
					   );
		
				--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				--	   SELECT '35', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				--	   FROM @InsertCustomer AS ii
				--	   WHERE ii.UserName not like '%_@_%_.__%' 
		 
		--Note : Content page import is not required 
		
		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  

		DELETE FROM @InsertCustomerAddress
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);
		-- Insert Product Data 
				
				DECLARE @InsertedUserAddress TABLE (AddressId  nvarchar(256), UserId nvarchar(max)) 
		-- Pending for discussion include one identity column for modify address
				
				--UPDATE ANU SET 
				--ANU.PhoneNumber	= IC.PhoneNumber
				--from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				--INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				--INNER JOIN @InsertCustomerAddress IC ON ANZU.UserName = IC.UserName 
				--INNER JOIN ZnodeUserAddress ZUA ON ZUA.UserId = ZU.UserId
				--INNER JOIN ZnodeAddress ZA ON ZUA.AddressId = ZA.AddressId
				 
				--where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				Insert into ZnodeAddress (FirstName,LastName,DisplayName,Address1,Address2,Address3,CountryName,
											StateName,CityName,PostalCode,PhoneNumber,Mobilenumber,AlternateMobileNumber,FaxNumber,
											IsDefaultBilling,IsDefaultShipping,IsActive,ExternalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)		
				OUTPUT INSERTED.AddressId, INSERTED.Address3 INTO  @InsertedUserAddress (AddressId, UserId ) 			 
				SELECT IC.FirstName,IC.LastName,IC.DisplayName,IC.Address1,IC.Address2,convert(nvarchar(100),ZU.UserId),IC.CountryName,
				IC.StateName,IC.CityName,IC.PostalCode,IC.PhoneNumber,IC.Mobilenumber,IC.AlternateMobileNumber,IC.FaxNumber,
				isnull(IC.IsDefaultBilling,0),isnull(IC.IsDefaultShipping,0),isnull(IC.IsActive,0),IC.ExternalId, @UserId , @GetDate, @UserId , @GetDate
				FROM AspNetZnodeUser ANZU 
				INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomerAddress IC ON ANZU.UserName = IC.UserName 

			    insert into ZnodeUserAddress(UserId,AddressId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				select cast( UserId as int ) , Addressid , @UserId , @GetDate, @UserId , @GetDate from  @InsertedUserAddress
	
				UPDATE ZA SET ZA.Address3 = null 
				From ZnodeAddress ZA INNER JOIN @InsertedUserAddress IUA ON ZA.AddressId = IUA.AddressId 

		-- 'End'
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
GO
PRINT N'Creating [dbo].[Znode_ImportGetTableDetails]...';


GO

--Znode_ImportGetTableDeatils 'MAGSHIP',7  
--Znode_ImportGetTableDeatils 'MAGSOLD',6  

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportGetTableDetails' )
BEGIN
	DROP PROCEDURE Znode_ImportGetTableDetails
END
GO
CREATE PROC [dbo].[Znode_ImportGetTableDetails]  
(  
 @TableName Nvarchar(200),  
 @ImportHeadId int  
)  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
  
 DECLARE @ImportTableColumnName NVARCHAR(2000) = '',  
   @SQL NVARCHAR(MAX) = '';  
  
 SET @SQL =   
  'SELECT @ImportTableColumnNameS = SUBSTRING ((Select '','' +  ''[''+ISNULL(ImportTableColumnName ,''NULL'')+'']'' FROM ZnodeImportTableDetail ITD   
   INNER JOIN ZnodeImportTableColumnDetail ITCD ON ITD.ImportTableId = ITCD.ImportTableId  
   WHERE ITD.ImportTableName = @TableName AND ITD.ImportHeadId = @ImportHeadId Order by ColumnSequence FOR XML PATH ('''') ),2,4000) '  
  
 print @SQL  
 EXEC sp_executesql @SQL, N'@TableName Nvarchar(200), @ImportHeadId INT, @ImportTableColumnNameS NVARCHAR(MAX) OUTPUT ', @TableName = @TableName, @ImportHeadId = @ImportHeadId,  @ImportTableColumnNameS = @ImportTableColumnName OUTPUT  
  
 SELECT @ImportTableColumnName AS ImportTableColumnName  
  
END
GO
PRINT N'Creating [dbo].[Znode_ImportProcessAttributeData]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessAttributeData' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessAttributeData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportProcessAttributeData](@TblGUID nvarchar(255), @ERPTaskSchedulerId int )
AS
BEGIN
	
	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255),@TemplateId INT , @PortalId INT 
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal
	set @NewuGuId = newid()
	Declare @GlobalTemporaryTable nvarchar(255)
	IF OBJECT_ID('tempdb.dbo.##AttributeDetail', 'U') IS NOT NULL 
		DROP TABLE tempdb..##AttributeDetail
	SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'AttributeTemplate'
	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
			@TableName NVARCHAR(200) = 'AttributeRawData',	
		    @InsertColumnName   NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@Sql NVARCHAR(MAX) = ''
	SET @GlobalTemporaryTable = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
	SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##AttributeDetail (GUID nvarchar(255),'+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
	FROM [dbo].[ZnodeImportTemplateMapping]
	WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' )'
	 		
	EXEC ( @CreateTableScriptSql )
	
	 SET @Sql = '
	SELECT @InsertColumnName = COALESCE(@InsertColumnName + '', '', '''') + ''[''+ ITCD.BaseImportColumn +'']'' ,
		   @ImportTableColumnName = COALESCE(@ImportTableColumnName + '', '', '''') +''[''+ImportTableColumnName+'']''
	FROM [ZnodeImportTableColumnDetail] ITCD 
	INNER JOIN [ZnodeImportTableDetail] ITD ON ITCD.ImportTableId = ITD.ImportTableId
	WHERE  ITD.ImportTableName = @TableName  AND ITCD.BaseImportColumn is not null '
	
	EXEC sp_executesql @SQL, N'@TableName Nvarchar(200), @InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName,  @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

    IF( LEN(@InsertColumnName) > 0 )
	BEGIN
	
		SET @SQL = 
		'INSERT INTO tempdb..[##AttributeDetail] ( '+@InsertColumnName+' )
		 SELECT '+ @ImportTableColumnName +' 
		 FROM '+ @GlobalTemporaryTable+    ' PRD '
		EXEC sp_executesql @SQL

		SET @SQL = 'update tempdb..##AttributeDetail SET AttributeCode= AttributeName, GUID= '''+@NewuGuId  + ''''
		EXEC sp_executesql @SQL
		
	END
	EXEC Znode_ImportData @TableName = 'tempdb..[##AttributeDetail]',	@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
	     @UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = '' ,
		 @ERPTaskSchedulerId  = @ERPTaskSchedulerId 

	select 'Job started successfully.' 
END
GO
PRINT N'Creating [dbo].[Znode_ImportProcessCustomer]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessCustomer' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessCustomer
END
GO
CREATE   PROCEDURE [dbo].[Znode_ImportProcessCustomer](@TblGUID nvarchar(255) = '' ,@ERPTaskSchedulerId  int )
AS
BEGIN

	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255)
	set @NewuGuId = newid()
	Declare @CurrencyId int ,@PortalId int,@TemplateId INT ,@ImportHeadId INT 
	
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	Select @CurrencyId = CurrencyId  from ZnodeCurrency where CurrencyCode in (Select FeatureValues from   ZnodeGlobalSetting where FeatureName = 'Currency') 

	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@TableName NVARCHAR(255) = 'MAGSOLD',			
			@Sql NVARCHAR(MAX) = '',
			@PriceListId int,
			@RowNum int, 
			@MaxRowNum int,
			@FirstStep nvarchar(255),
			@PriceTableName  nvarchar(255),
			@WarehouseCode varchar(100)
			
	   IF OBJECT_ID('tempdb..##Customer', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##Customer

	   IF OBJECT_ID('tempdb.dbo.##CustomerAddress', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##CustomerAddress

		--SELECT @CustomerTableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =6 --AND ImportTableName = 'PRDH'
		--SELECT @CustomerAddTableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =7 --AND ImportTableName = 'PRDH'

	    SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
	    -- User Data
	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
				
			--Create Temp table for customer 
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'CustomerTemplate'
			SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'Customer'

			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##Customer ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
			EXEC ( @CreateTableScriptSql )
		
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Insert'' 
			AND ImportHeadId =  ' + CONVERT(NVARCHAR(100), @ImportHeadId) + '	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD''  
			AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Insert'' 
			AND ImportHeadId = ' + CONVERT(NVARCHAR(100), @ImportHeadId) + ' AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT
	
			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##Customer ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##Customer  SET IsActive =  1 , LastName = ISNULL(LastName,''.'') , Email = UserName '
				EXEC sp_executesql @SQL

				--SET @SQL = 'Select * from  tempdb..##Customer' 
				--EXEC sp_executesql @SQL
				
				EXEC Znode_ImportData @TableName = 'tempdb..##Customer' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				 @UserId = 2,@PortalId = 1,@LocaleId = 1,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 1, @StepName = 'Import' ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId
			END

			-- User Address Data
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'CustomerAddressTemplate'
			SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'CustomerAddress'

	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
			
			--Create Temp table for customer Address 
			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##CustomerAddress ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= 9 FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
			EXEC ( @CreateTableScriptSql )
		
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##CustomerAddress ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL
				SET @SQL = 'Update tempdb..##CustomerAddress  SET IsActive =  1 '
				EXEC sp_executesql @SQL
			END

			--Append address data from shipping table 
	
			
			SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			Declare @CustomerTableName  nvarchar(255)
			SET @CustomerTableName = @TableName 
			SET @TableName = 'MAGSHIP'	
			SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSHIP'' ) 
			AND ITD.ImportTableName = ''MAGSHIP''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSHIP'' ) 
			AND ITD.ImportTableName = ''MAGSHIP'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##CustomerAddress ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##CustomerAddress  SET IsActive =  1 '
				EXEC sp_executesql @SQL

				SET @SQL = 'Update A SET A.UserName = b.[EMAIL LOGON ID] from tempdb..##CustomerAddress A INNER JOIN '+@CustomerTableName+' B ON
				            A.ExternalId = b.[Sold-to number] AND A.UserName is null   '
				EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##CustomerAddress  SET LastName = ISNULL(LastName,''.''),FirstName  = ISNULL(UserName,'''')'
				EXEC sp_executesql @SQL



				--SET @SQL = 'Select * from  tempdb..##CustomerAddress' 
				--EXEC sp_executesql @SQL
				
				EXEC Znode_ImportData @TableName = 'tempdb..##CustomerAddress' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				@UserId = 2,@PortalId = 1,@LocaleId = 1,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 0, @StepName = 'Import1', @StartStepName  ='Import',@step_id = 2 
			    ,@Nextstep_id  = 1,@ERPTaskSchedulerId  =@ERPTaskSchedulerId 
				select 'Job Successfully Started'
			END

END
GO
PRINT N'Creating [dbo].[Znode_ImportProcessInventoryData]...';


GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessInventoryData' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessInventoryData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportProcessInventoryData](@TblGUID nvarchar(255) = '' ,@ERPTaskSchedulerId  int )
AS
BEGIN

	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255)
	set @NewuGuId = newid()
	Declare @CurrencyId int ,@PortalId int ,@TemplateId INT 
	SELECT @CurrencyId = CurrencyId  from ZnodeCurrency where CurrencyCode in (Select FeatureValues from   ZnodeGlobalSetting where FeatureName = 'Currency') 
	
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@TableName NVARCHAR(255) = 'MAGINV',			
			@Sql NVARCHAR(MAX) = '',
			@PriceListId int,
			@ListCode nvarchar(255) = 'TempMAGINV' ,
			@RowNum int, 
			@MaxRowNum int,
			@FirstStep nvarchar(255),
			@PriceTableName  nvarchar(255),
			@WarehouseCode varchar(100)

	Select TOP 1  @WarehouseCode = ZW.WarehouseCode from ZnodePortalWarehouse zpw inner join ZnodeWarehouse ZW on zpw.WarehouseId = ZW.WarehouseId
	where PortalId =@PortalId
	
	   IF OBJECT_ID('tempdb.dbo.##Inventory', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##Inventory

		
	if Isnull(@WarehouseCode ,'') <> '' 
	BEGIN 
		SELECT @TableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =3 --AND ImportTableName = 'PRDH'
	    SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
	
	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
			
			--Create Temp table for price with respective their code 
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'InventoryTemplate'
			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb.dbo.##Inventory ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
		
			EXEC ( @CreateTableScriptSql )

			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = ''MAGINV''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = ''MAGINV'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT
	

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb.dbo.##Inventory ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL
				SET @SQL = 'Update tempdb.dbo.##Inventory  SET WarehouseCode = ''' + @WarehouseCode + ''''
				EXEC sp_executesql @SQL
				--SET @SQL = 'Select * from tempdb..##' + @ListCode
				--EXEC sp_executesql @SQL
			

				EXEC Znode_ImportData @TableName = 'tempdb..##Inventory' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				@UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 0,@Nextstep_id  = 1 ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId  
				select 'Job Successfully Started'
			END
			
	END
END
GO
PRINT N'Creating [dbo].[Znode_ImportProcessPriceData]...';


GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessPriceData' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessPriceData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportProcessPriceData](@TblGUID nvarchar(255) = '',@ERPTaskSchedulerId int  )
AS
BEGIN
	
	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255)
	set @NewuGuId = newid()
	Declare @CurrencyId int 
	DECLARE @TemplateId INT , @PortalId INT 
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal
	Select @CurrencyId = CurrencyId  from ZnodeCurrency where CurrencyCode in (Select FeatureValues from   ZnodeGlobalSetting where FeatureName = 'Currency') 
	IF OBJECT_ID('tempdb.dbo.##PriceDetail', 'U') IS NOT NULL 
	   DROP TABLE ##PriceDetail

	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@TableName NVARCHAR(500) = 'TPRICE',			
			@Sql NVARCHAR(MAX) = '',
			@PriceListId int,
			@ListCode nvarchar(255),
			@RowNum int, 
			@MaxRowNum int,
			@FirstStep nvarchar(255),
			@PriceTableName  nvarchar(255)
	
	
	SELECT @TableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =2 --AND ImportTableName = 'PRDH'
	SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 

	IF OBJECT_ID('tempdb.dbo.##PriceListcode', 'U') IS NOT NULL 
		DROP TABLE #PriceListcode 
	CREATE TABLE #PriceListcode (RowNum int Identity, ListCode nvarchar(255),	ListName	nvarchar(255) , CurrencyId int)
	
	SET @SQL = 
	'INSERT INTO #PriceListcode ( ListCode,ListName,CurrencyId )
	SELECT  Distinct ltrim(rtrim(Replace(PRD.PricelistCode,''"'',''''))),ltrim(rtrim(Replace(PRD.PricelistCode,''"'',''''))), '+ Convert (nvarchar(30),@CurrencyId ) + '  FROM ' +@TableName+ ' PRD '
	EXEC sp_executesql @SQL



	SET @SQL = 
	'INSERT INTO ZnodePriceList ( ListCode,ListName,CurrencyId , CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	SELECT  Distinct PRD.ListCode,PRD.ListCode,'+ Convert (nvarchar(30),@CurrencyId ) + ',2,GETDATE(),2,GETDATE() FROM  #PriceListcode PRD 
	WHERE NOT EXISTS ( SELECT TOP 1 1  FROM ZnodePriceList ZPL WHERE ZPL.ListCode = PRD.ListCode ) AND PRD.ListCode is not null '
	EXEC sp_executesql @SQL
	
	 Select  @MaxRowNum = MAx(RowNum) from #PriceListcode  where Isnull(ListCode,'') <> '' 
	DECLARE Cur_ListCode CURSOR FOR SELECT TPLC.RowNum ,ZPL.PriceListId, TPLC.ListCode FROM #PriceListcode TPLC INNER JOIN ZnodePriceList ZPL On 
	TPLC.ListCode = ZPL.ListCode  where ZPL.ListCode    is not null  Order by  TPLC.RowNum
    OPEN Cur_ListCode
    FETCH NEXT FROM Cur_ListCode INTO @RowNum,@PriceListId, @ListCode
    WHILE ( @@FETCH_STATUS = 0 )
	BEGIN	
	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
			
			IF OBJECT_ID('tempdb.dbo.##' + @ListCode , 'U') IS NOT NULL 
			BEGIN
				SET @Sql = 'DROP TABLE tempdb.dbo.##' + @ListCode
				EXEC sp_executesql @SQL
			END
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'PriceTemplate'
	
			--Create Temp table for price with respective their code 
			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##' + @ListCode + '('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
		
			EXEC ( @CreateTableScriptSql )

			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = ''TPRICE'' AND ITCD.BaseImportColumn is not null FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = ''TPRICE''  AND ITCD.BaseImportColumn is not null FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##' + @ListCode+'  ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD 
					WHERE EXISTS ( SELECT TOP 1 1  FROM ZnodePriceList ZPL WHERE ZPL.ListCode = ltrim(rtrim(replace(PRD.PricelistCode,''"'',''''))) )'
				EXEC sp_executesql @SQL
				
				
				
				SET @PriceTableName  ='tempdb..[##' + @ListCode +']'

				If @RowNum = 1 
					Begin
					    --Print 'Create Job  ' + Convert(nvarchar(100),@RowNum) 
						EXEC Znode_ImportData @TableName = @PriceTableName ,	@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
						@UserId = 2,@PortalId = @PortalId, @LocaleId = @LocaleId, @DefaultFamilyId = 0,@PriceListId = @PriceListId, @CountryCode = ''--, @IsDebug =1 
						,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 1, @StepName = @ListCode,@ERPTaskSchedulerId  =@ERPTaskSchedulerId  
						SET @FirstStep = @ListCode 
					END
				ELSE If @RowNum = @MaxRowNum
					Begin
						--Print 'Start Job  ' + Convert(nvarchar(100),@RowNum) 
						EXEC Znode_ImportData @TableName = @PriceTableName,	@NewGUID =  @TblGUID ,@TemplateId = @TemplateId,
						 @UserId = 2,@PortalId = @PortalId, @LocaleId = @LocaleId, @DefaultFamilyId = 0,@PriceListId = @PriceListId, @CountryCode = ''--, @IsDebug =1 
						,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 0, @StepName = @ListCode, @StartStepName  = @FirstStep ,@step_id = @RowNum --, @IsDebug =1
						,@Nextstep_id  = 1,@ERPTaskSchedulerId  = @ERPTaskSchedulerId  
					END 
				ELSE 
					BEGIN
						--Print 'Create another  Job  ' + Convert(nvarchar(100),@RowNum) 
						EXEC Znode_ImportData @TableName = @PriceTableName ,	@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
						@UserId = 2,@PortalId = @PortalId, @LocaleId = @LocaleId, @DefaultFamilyId = 0,@PriceListId = @PriceListId, @CountryCode = ''--, @IsDebug =1 
						,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 1, @StepName = @ListCode ,@step_id = @RowNum
						,@ERPTaskSchedulerId  = @ERPTaskSchedulerId  
					END
			END
	
		FETCH NEXT FROM Cur_ListCode INTO  @RowNum,@PriceListId, @ListCode

	END
		select 'Job Successfully Started'
	CLOSE Cur_ListCode
	DEALLOCATE Cur_ListCode
END
GO
PRINT N'Creating [dbo].[Znode_ImportProcessProductData]...';


GO

--  [dbo].[Znode_ImportProcessProductData] '1928de37-30d3-4cc1-b5e3-0c498c0da183'
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessProductData' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessProductData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportProcessProductData](@TblGUID nvarchar(255),@ERPTaskSchedulerId int )
AS
BEGIN
	SET NOCOUNT ON;
	SET TEXTSIZE 2147483647;
	DECLARE @NewuGuId nvarchar(255),@ImportHeadId INT 
	set @NewuGuId = newid()
    DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
	DECLARE @DefaultFamilyId  INT = dbo.Fn_GetDefaultPimProductFamilyId();
	DECLARE @LocaleId  INT = dbo.Fn_GetDefaultLocaleId()
	DECLARE @TemplateId INT , @PortalId INT 
	
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	IF OBJECT_ID('tempdb.dbo.##ProductDetail', 'U') IS NOT NULL 
		DROP TABLE ##ProductDetail

	IF OBJECT_ID('tempdb.dbo.#Attributecode', 'U') IS NOT NULL 
		DROP TABLE #Attributecode
	
	IF OBJECT_ID('tempdb.dbo.#ConfigurableAttributecode', 'U') IS NOT NULL 
		DROP TABLE #ConfigurableAttributecode 
	
	IF OBJECT_ID('tempdb.dbo.#DefaultAttributeCode', 'U') IS NOT NULL 
		DROP TABLE #DefaultAttributeCode 

    IF OBJECT_ID('tempdb.dbo.[##ProductAssociation]', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.[##ProductAssociation]

		
	Declare @GlobalTemporaryTable nvarchar(255)
	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName   NVARCHAR(MAX), 
			@UpdateTable2Column NVARCHAR(MAX),
			@UpdateTable3Column NVARCHAR(MAX),
			@UpdateTable4Column NVARCHAR(MAX),
			@ImportTableColumnName NVARCHAR(MAX),
			@ImportTableName VARCHAR(200),
			@TableName4 NVARCHAR(255) = 'tempdb..[##PRDDA_' + @TblGUID + ']',
			@Sql NVARCHAR(MAX) = '',
			@Attribute NVARCHAR(MAX)

	DECLARE @Attributecode TABLE ( Attrcode NVARCHAR(255) )

	CREATE TABLE #Attributecode ( Attrcode NVARCHAR(255) )
	CREATE TABLE #ConfigurableAttributecode (SKU NVARCHAR(255) , PimAttributeId  int , DefaultValue nvarchar(255) ,AttributeCode nvarchar(255) ,ParentSKU nvarchar(255)) 
	
	SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'ProductTemplate'

	SET @Sql = '
	INSERT INTO ZnodeImportTemplateMapping ( ImportTemplateId, SourceColumnName, TargetColumnName, DisplayOrder, IsActive, IsAllowNull, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
	SELECT Distinct 1 AS ImportTemplateId,  PA.AttributeCode AS SourceColumnName,  PA.AttributeCode AS TargetColumnName, 0 AS DisplayOrder, 0 AS IsActive, 0 AS IsAllowNull, 2 AS CreatedBy, GETDATE() AS CreatedDate, 2 AS ModifiedBy, GETDATE() AS ModifiedDate
	FROM '+@TableName4+' PRD
	INNER JOIN ZnodePimAttribute PA ON PRD.Attribute = PA.AttributeCode
	WHERE NOT EXISTS ( SELECT * FROM ZNODEIMPORTTEMPLATEMAPPING ITM WHERE ImportTemplateId = ' + CONVERT(NVARCHAR(100), @TemplateId ) + ' AND PRD.ATTRIBUTE =  ITM.SOURCECOLUMNNAME )'


	EXEC ( @Sql )
	
	SELECT @CreateTableScriptSql = 'CREATE TABLE ##ProductDetail ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
	FROM [dbo].[ZnodeImportTemplateMapping]
	WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , ParentStyle NVARCHAR(MAX),GUID nvarchar(255), BaseProductType nvarchar(255) )'

	EXEC ( @CreateTableScriptSql )
	
	SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'Product'

	SELECT * FROM ZnodeImportHead
	--Merge all the tables which is type is inserted / updated 
	DECLARE Cur_InsertProduct CURSOR FOR
	
	SELECT ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId = @ImportHeadId --AND ImportTableName = 'PRDH'
	
	OPEN Cur_InsertProduct 

	FETCH NEXT FROM Cur_InsertProduct INTO @ImportTableName

	WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
	    SET @GlobalTemporaryTable = 'tempdb..[##' + @ImportTableName + '_' + @TblGUID + ']' 
		--1 simple 
		    SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = @ImportTableName  AND ITCD.BaseImportColumn is not null FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = @ImportTableName  AND ITCD.BaseImportColumn is not null FOR XML PATH ('''')),2,4000)'

		PRINT @Sql
		EXEC sp_executesql @SQL, N'@ImportTableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @ImportTableName = @ImportTableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

		
		IF( LEN(@InsertColumnName) > 0 )
		BEGIN
			SET @SQL = 'INSERT INTO ##ProductDetail ( ParentStyle, '+@InsertColumnName+' )	SELECT [Parent Style], '+@ImportTableColumnName +' FROM '+@GlobalTemporaryTable
			EXEC sp_executesql @SQL
		END

		SELECT @InsertColumnName ='', @GlobalTemporaryTable=''

		FETCH NEXT FROM Cur_InsertProduct INTO @ImportTableName
	END

	CLOSE Cur_InsertProduct
	DEALLOCATE Cur_InsertProduct

	DECLARE @UpdateTableColumn varchar(max)
	

	SET @Sql = 
		'SELECT @UpdateTableColumn = 
		COALESCE(@UpdateTableColumn + '','', '''') + ''[''+BaseImportColumn+''] = B.[''+BaseImportColumn+'']''
		FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
		ON ITCD.ImportTableId = ITD.ImportTableId
		WHERE  ITD.ImportTableName = ''PRDH''  AND ITCD.BaseImportColumn IS NOT NULL AND ITCD.BaseImportColumn <> ''SKU'' '


	EXEC sp_executesql @SQL, N'@UpdateTableColumn VARCHAR(200) OUTPUT', @UpdateTableColumn = @UpdateTableColumn OUTPUT
	
	SET @Sql = 
		';WITH CTE AS
		(
			SELECT * FROM ##ProductDetail WHERE ProductName IS NOT NULL
		)
		UPDATE A 
		SET '+@UpdateTableColumn+'
		FROM ##ProductDetail A 
		INNER JOIN CTE B ON B.ParentStyle = A.ParentStyle'
	EXEC ( @Sql )
    
	SET @Sql = 'INSERT INTO #Attributecode ( Attrcode ) SELECT DISTINCT ltrim(rtrim([Attribute])) FROM '+ @TableName4
	 + ' where ltrim(rtrim([Attribute]))  in (Select AttributeCode from ZnodePimAttribute where IsCategory = 0 )'
	EXEC ( @Sql )

	DECLARE Cur_AttributeCode CURSOR FOR SELECT Attrcode FROM #Attributecode where Attrcode is not null 
    OPEN Cur_AttributeCode
    FETCH NEXT FROM Cur_AttributeCode INTO @Attribute
    WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
		SET @SQL = ''
		SET @SQL =  'UPDATE PD SET PD.' + @Attribute  + '= ' + ' Replace(Replace(PDD.[Attribute Value], ''/'', ''''), '' '', '''')' +'  FROM ##ProductDetail PD inner join '+@TableName4+ ' PDD on PD.SKU = PDD.SKU# WHERE PDD.Attribute =  '''+@Attribute + ''' '
		EXEC sp_executesql @SQL
		FETCH NEXT FROM Cur_AttributeCode INTO @Attribute
	END
	CLOSE Cur_AttributeCode
	DEALLOCATE Cur_AttributeCode
	
	SET @Sql = 'UPDATE ##ProductDetail SET GUID= '''+@NewuGuId  + ''', BaseProductType = ProductType'
	EXEC sp_executesql @SQL

	SET @Sql = 'UPDATE ##ProductDetail SET ProductType =  CASE when [ParentStyle] = SKU 
	then ''ConfigurableProduct'' ELSE ''SimpleProduct'' END ,
	MinimumQuantity = 1 , MaximumQuantity = 10 ,ShippingCostRules = ''WeightBasedRate'',OutOfStockOptions = ''DontTrackInventory''
	,ProductCode = CASE When ProductCode Is Null then SKU ELSE ProductCode  END , 
	IsActive = CASE when Isnull(IsActive,'''') = '''' then 1 END'
	EXEC sp_executesql @SQL
	
	DELETE  FROM ##ProductDetail where isnull(SKU,'') = ''
	---- Read All default data 
	
	-- Product Association data prepartion 
	Create TABLE tempdb..[##ProductAssociation] (ParentSKU nvarchar(255),ChildSKU nvarchar(255), DisplayOrder int,GUID nvarchar(100) )
	SET @Sql = '
	insert into tempdb..[##ProductAssociation]  (ParentSKU ,ChildSKU , DisplayOrder,GUID )
	select [ParentStyle], SKU  ,1, ''' + @NewuGuId + ''' from ##ProductDetail  where [ParentStyle] <>  SKU and [ParentStyle] is not null 
	'
	EXEC (@Sql)
	
	-- Configrable Attributes
	SET @Sql = 'INSERT INTO #ConfigurableAttributecode (PimAttributeId ,DefaultValue ,AttributeCode,ParentSKU)
	            SELECT Distinct ZPA.PimAttributeId,[Attribute Value]	 ,ltrim(rtrim(PDA.[Attribute])), PDA.[Parent Style]  FROM '+ @TableName4
	 + ' PDA Inner join  tempdb..##ProductDetail PD  ON PDA.[SKU#]= PD.SKU and PD.BaseProductType = ''C''
	  Inner join ZnodePimAttribute ZPA ON ZPA.AttributeCode = ltrim(rtrim(PDA.[Attribute])) AND ZPA.IsCategory = 0 and ZPA.IsConfigurable =1 '
	EXEC ( @Sql )

	-- Update default vaule of confi attribute in main template
	SET @Sql = '
	Select * from ##ProductDetail PD INNER JOIN #ConfigurableAttributecode CA ON CA.ParentSKU = PD.SKU '

	DECLARE @DefaultValue nvarchar(255),@ParentSKU  nvarchar(255),@AttributeName nvarchar(255)
	DECLARE Cur_ConfigAttributeCode CURSOR FOR SELECT DefaultValue, AttributeCode,ParentSKU 
	FROM #ConfigurableAttributecode  where DefaultValue is not null 
    OPEN Cur_ConfigAttributeCode
    FETCH NEXT FROM Cur_ConfigAttributeCode INTO @DefaultValue, @AttributeName,@ParentSKU
    WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
		SET @SQL = ''
		SET @SQL =  'UPDATE ##ProductDetail SET ' + @AttributeName  + ' = ''' +  Replace(Replace(@DefaultValue, '/', ''), ' ', '') + 
		''' WHERE SKU  =  '''+	@ParentSKU + ''''
		EXEC sp_executesql @SQL
		FETCH NEXT FROM Cur_ConfigAttributeCode INTO @DefaultValue, @AttributeName,@ParentSKU
	END
	CLOSE Cur_ConfigAttributeCode
	DEALLOCATE Cur_ConfigAttributeCode
		
	SET @Sql = 'Alter TABLE ##ProductDetail drop column [ParentStyle],[BaseProductType]'
	EXEC sp_executesql @SQL
	

	SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'ProductTemplate'
	-- Import product    
	EXEC Znode_ImportData @TableName = 'tempdb..[##ProductDetail]',	@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
	      @UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = @DefaultFamilyId,@PriceListId = 0, @CountryCode = ''
		 ,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 1, @StepName = 'Import' ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId 


	If Exists (select TOP 1 1 from #ConfigurableAttributecode ) 
	BEGIN
	--SET @Sql = 'SELECT * FROM tempdb..[##ProductAssociation]' 
	--	EXEC sp_executesql @SQL
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'ProductAssociation'

			EXEC Znode_ImportData @TableName = 'tempdb..[##ProductAssociation]',	@NewGUID =  @TblGUID ,@TemplateId = @TemplateId,
			 @UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
			,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 0, @StepName = 'Import1', @StartStepName  ='Import',@step_id = 2 --, @IsDebug =1
			,@Nextstep_id  = 1,@ERPTaskSchedulerId  = @ERPTaskSchedulerId  
		
	END
	 select 'Job create successfully.' 
	
END
GO
PRINT N'Altering [dbo].[Znode_ImportPimProductData]...';


GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportPimProductData' )
BEGIN
	DROP PROCEDURE Znode_ImportPimProductData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportPimProductData]
(   @TableName          VARCHAR(200),
    @NewGUID            NVARCHAR(200),
    @TemplateId         NVARCHAR(200),
    @ImportProcessLogId INT,
    @UserId             INT,
    @LocaleId           INT,
    @DefaultFamilyId    INT)
AS
    
	/*
      Summary : Finally Import data into ZnodePimProduct, ZnodePimAttributeValue and ZnodePimAttributeValueLocale Table 
      Process : Flat global temporary table will split into cloumn wise and associted with Znode Attributecodes,
    		      Create group of product with their attribute code and values and inserted one by one products. 	   
    
      SourceColumnName : CSV file column headers
      TargetColumnName : Attributecode from ZnodePimAttribute Table 

	 ***  Need to log error if transaction failed during insertion of records into table.
    */

     BEGIN
		 SET NOCOUNT ON
         BEGIN TRY
             --BEGIN TRAN ImportProducts;
             DECLARE @SQLQuery NVARCHAR(MAX);
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @AttributeTypeName NVARCHAR(10), @AttributeCode NVARCHAR(300), @AttributeId INT, @IsRequired BIT, @SourceColumnName NVARCHAR(600), @PimAttributeFamilyId INT, @NewProductId INT, @PimAttributeValueId INT, @status BIT= 0; 
             --Declare error Log Table 


			 DECLARE @FamilyAttributeDetail TABLE
			 ( 
				PimAttributeId int, AttributeTypeName varchar(300), AttributeCode varchar(300), SourceColumnName nvarchar(600), IsRequired bit, PimAttributeFamilyId int
			 );
             IF @DefaultFamilyId = 0
                 BEGIN
					INSERT INTO @FamilyAttributeDetail( PimAttributeId, AttributeTypeName, AttributeCode, SourceColumnName, IsRequired, PimAttributeFamilyId )
					--Call Process to insert data of defeult family with cource column name and target column name 
					EXEC Znode_ImportGetTemplateDetails @TemplateId = @TemplateId, @IsValidationRules = 0, @IsIncludeRespectiveFamily = 1,@DefaultFamilyId = @DefaultFamilyId;
                    UPDATE @FamilyAttributeDetail SET PimAttributeFamilyId = DBO.Fn_GetCategoryDefaultFamilyId();
                 END;
             ELSE
                 BEGIN
                     INSERT INTO @FamilyAttributeDetail(PimAttributeId,AttributeTypeName,AttributeCode,SourceColumnName,IsRequired,PimAttributeFamilyId)
                     --Call Process to insert data of defeult family with cource column name and target column name 
                     EXEC Znode_ImportGetTemplateDetails @TemplateId = @TemplateId,@IsValidationRules = 0,@IsIncludeRespectiveFamily = 1,@DefaultFamilyId = @DefaultFamilyId;
                 END;  

            -- Retrive PimProductId on the basis of SKU for update product 
			SET @SQLQuery = 'UPDATE tlb SET tlb.PimProductId = ZPAV.PimProductId 
							FROM ZnodePimAttributeValue AS ZPAV INNER JOIN ZnodePimAttributeValueLocale AS ZPAVL ON 
							(ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId) 
							INNER JOIN [dbo].[ZnodePimAttribute] ZPA on ZPAV.PimAttributeId = ZPA.PimAttributeId AND ZPA.AttributeCode= ''SKU'' 
							INNER JOIN '+@TableName+' tlb ON ZPAVL.AttributeValue = ltrim(rtrim(tlb.SKU)) ';
			EXEC sys.sp_sqlexec	@SQLQuery	 	
				 	
					
             --Read all attribute details with their datatype 
			 IF NOT EXISTS(SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLES WHERE INFORMATION_SCHEMA.TABLES.TABLE_NAME = '#DefaultAttributeValue')
				BEGIN
					   CREATE TABLE #DefaultAttributeValue (AttributeTypeName  VARCHAR(300),PimAttributeDefaultValueId INT,PimAttributeId INT,
					   AttributeDefaultValueCode  VARCHAR(100));
					   -- ELSE 
					   -- CREATE TABLE #DefaultAttributeValue (AttributeTypeName  VARCHAR(300),PimAttributeDefaultValueId INT,PimAttributeId INT,
					   -- AttributeDefaultValueCode  VARCHAR(100)
					   -- Index Ix_Default (PimAttributeId, AttributeDefaultValueCode));
					   --IF @@VERSION LIKE '%Azure%' OR @@VERSION LIKE '%Express Edition%'
					   --Begin
						  --Select 'Without Index'
					   --END
					   --Else
						  --Alter TABLE #DefaultAttributeValue ADD Index Ix_Default (PimAttributeId, AttributeDefaultValueCode);
					


					INSERT INTO #DefaultAttributeValue(AttributeTypeName,PimAttributeDefaultValueId,PimAttributeId,AttributeDefaultValueCode)
					--Call Process to insert default data value 
					EXEC Znode_ImportGetPimAttributeDefaultValue;
				END;
             ELSE
                BEGIN
                    DROP TABLE #DefaultAttributeValue;
                END;
             EXEC sys.sp_sqlexec
                  @SQLQuery;
          
             -- Split horizontal table into verticle table by column name and attribute Value with their 
             -- corresponding AttributeId, Default family , Default AttributeValue Id  
    --         DECLARE @PimProductDetail TABLE 
			 --(
			      
				-- PimAttributeId INT, PimAttributeFamilyId INT,ProductAttributeCode VARCHAR(300) NULL,
				--  ProductAttributeDefaultValueId INT NULL,PimAttributeValueId  INT NULL,LocaleId INT,
				--  PimProductId INT NULL,AttributeValue NVARCHAR(MAX) NULL,AssociatedProducts NVARCHAR(4000) NULL,ConfigureAttributeIds VARCHAR(2000) NULL,
				--  ConfigureFamilyIds VARCHAR(2000) NULL,RowNumber INT  INDEX Ix CLUSTERED (RowNumber) 
    --            );

			DECLARE @PimProductDetail TABLE 
			 (
			      
				  PimAttributeId INT, PimAttributeFamilyId INT,ProductAttributeCode VARCHAR(300) NULL,
				  ProductAttributeDefaultValueId INT NULL,PimAttributeValueId  INT NULL,LocaleId INT,
				  PimProductId INT NULL,AttributeValue NVARCHAR(MAX) NULL,AssociatedProducts NVARCHAR(4000) NULL,ConfigureAttributeIds VARCHAR(2000) NULL,
				  ConfigureFamilyIds VARCHAR(2000) NULL,RowNumber INT  
                );

		-- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		SET @SQLQuery = ' Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM '+ @TableName ;
		EXEC	sp_executesql @SQLQuery, N'@SuccessRecordCount BIGINT out' , @SuccessRecordCount=@SuccessRecordCount
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End

			
             -- Column wise split data from source table ( global temporary table ) and inserted into temporary table variable @PimProductDetail
             -- Add PimAttributeDefaultValue 
             DECLARE Cr_AttributeDetails CURSOR LOCAL FAST_FORWARD
             FOR SELECT PimAttributeId,AttributeTypeName,AttributeCode,IsRequired,SourceColumnName,PimAttributeFamilyId FROM @FamilyAttributeDetail  WHERE ISNULL(SourceColumnName, '') <> '';
             OPEN Cr_AttributeDetails;
             FETCH NEXT FROM Cr_AttributeDetails INTO @AttributeId, @AttributeTypeName, @AttributeCode, @IsRequired, @SourceColumnName, @PimAttributeFamilyId;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                    SET @NewProductId = 0;
                    SET @SQLQuery = ' SELECT '''+CONVERT(VARCHAR(100), @PimAttributeFamilyId)+''' PimAttributeFamilyId , PimProductId PimProductId ,'''+CONVERT(VARCHAR(100), @AttributeId)+''' AttributeId ,
									(SELECT TOP 1  PimAttributeDefaultValueId FROM #DefaultAttributeValue Where PimAttributeId =  '
									+ CONVERT(VARCHAR(100), @AttributeId)+'AND  AttributeDefaultValueCode = TN.'+@SourceColumnName+' ) PimAttributeDefaultValueId ,'
									+ @SourceColumnName+','+CONVERT(VARCHAR(100), @LocaleId)+'LocaleId
									
									, RowNumber FROM '+@TableName+' TN';
                    INSERT INTO @PimProductDetail( PimAttributeFamilyId, PimProductId, PimAttributeId, ProductAttributeDefaultValueId, AttributeValue, LocaleId, RowNumber )
					EXEC sys.sp_sqlexec @SQLQuery;
                    FETCH NEXT FROM Cr_AttributeDetails INTO @AttributeId, @AttributeTypeName, @AttributeCode, @IsRequired, @SourceColumnName, @PimAttributeFamilyId;
                 END;
             CLOSE Cr_AttributeDetails;
             DEALLOCATE Cr_AttributeDetails;

			 UPDATE a 
			 SET ConfigureAttributeIds =  SUBSTRING((SELECT ','+CAST(c.PimAttributeId As VARCHAR(100)) 
			 FROM @PimProductDetail c 
			 INNER JOIN ZnodePimAttribute b ON (b.PimAttributeId = c.PimAttributeId)
			 WHERE IsConfigurable =1  AND c.RowNumber = a.RowNumber  FOR XML PATH('')),2,4000) 
			 FROM @PimProductDetail a 
		
             -- In case of Yes/No : If value is not TRUE OR  1 then it will be  False else True
			 --If default Value set not need of hard code for IsActive
			 UPDATE ppdti SET ppdti.AttributeValue = CASE WHEN Upper(ISNULL(ppdti.AttributeValue, '')) in ( 'TRUE','1')  THEN 'true'  ELSE 'false' END FROM @PimProductDetail ppdti
                INNER JOIN #DefaultAttributeValue dav ON ppdti.PimAttributeId = dav.PimAttributeId WHERE   dav.AttributeTypeName = 'Yes/No';
             -- Pass product records one by one 
             DECLARE @IncrementalId INT= 1;
             DECLARE @SequenceId INT=
             (
                 SELECT MAX(RowNumber) FROM @PimProductDetail
             );
             DECLARE @PimProductDetailToInsert PIMPRODUCTDETAIL;  --User define table type to pass multiple records of product in single step

             WHILE @IncrementalId <= @SequenceId
                 BEGIN
					   	INSERT INTO @PimProductDetailToInsert(PimAttributeId,PimAttributeFamilyId,ProductAttributeCode,ProductAttributeDefaultValueId,
						PimAttributeValueId,LocaleId,PimProductId,AttributeValue,AssociatedProducts,ConfigureAttributeIds,ConfigureFamilyIds)
						SELECT PimAttributeId,PimAttributeFamilyId,ProductAttributeCode,ProductAttributeDefaultValueId,PimAttributeValueId,LocaleId,
						PimProductId,AttributeValue,AssociatedProducts,ConfigureAttributeIds,ConfigureFamilyIds FROM @PimProductDetail
						WHERE [@PimProductDetail].RowNumber = @IncrementalId; --AND RTRIM(LTRIM(AttributeValue)) <> '';

						Delete from @PimProductDetailToInsert where RTRIM(LTRIM(AttributeValue)) = '';
	                    --ORDER BY [@PimProductDetail].RowNumber;
                        ----Call process to finally insert data into 
                        ----------------------------------------------------------
						--1. [dbo].[ZnodePimProduct]
						--2. [dbo].[ZnodePimAttributeValue]
						--3. [dbo].[ZnodePimAttributeValueLocale]
						if Exists (select TOP 1 1 from @PimProductDetailToInsert)
							EXEC [Znode_ImportInsertUpdatePimProduct] @PimProductDetail = @PimProductDetailToInsert,@UserID = @UserID,@status = @status OUT,@IsNotReturnOutput = 1;
						DELETE FROM @PimProductDetailToInsert;
						SET @IncrementalId = @IncrementalId + 1;
						
                 END;
             UPDATE ZnodeImportProcessLog SET Status = dbo.Fn_GetImportStatus(2), ProcessCompletedDate = @GetDate WHERE ImportProcessLogId = @ImportProcessLogId;
            -- COMMIT TRAN ImportProducts;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_PROCEDURE();
             UPDATE ZnodeImportProcessLog SET Status = dbo.Fn_GetImportStatus(3), ProcessCompletedDate = @GetDate WHERE ImportProcessLogId = @ImportProcessLogId;
            -- ROLLBACK TRAN ImportProducts;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_ManageProductList_XML]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ManageProductList_XML' )
BEGIN
	DROP PROCEDURE Znode_ManageProductList_XML
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageProductList_XML]
(   @WhereClause		 XML,
    @Rows				 INT           = 100,
    @PageNo			 INT           = 1,
    @Order_BY			 VARCHAR(1000) = '',
    @LocaleId			 INT           = 1,
    @PimProductId		 VARCHAR(2000) = 0,
    @IsProductNotIn	 BIT           = 0,
	@IsCallForAttribute BIT		   = 0,
	@AttributeCode      VARCHAR(max ) = '' ,
	@IsDebug            Bit		   = 0 )
AS
    
/*
		  Summary:-   This Procedure is used for get product List  
				    Procedure will pivot verticle table(ZnodePimattributeValues) into horizontal table with columns 
				    ProductId,ProductName,ProductType,AttributeFamily,SKU,Price,Quantity,IsActive,ImagePath,Assortment,LocaleId,DisplayOrder
        
		  Unit Testing
		  DECLARE @D INT= 1  EXEC  [dbo].[Znode_ManageProductList_XML]   @WhereClause = N'' , @Rows = 100 , @PageNo = 1 ,@Order_BY = '',@LocaleId= 1,@PimProductId = '',@IsProductNotIn = 1  SELECT @D
          select * from ZnodeAttributeType  WHERE AttributeValue LIKE '%&%'
		  UPDATE VieW_lOADMANAGEpRODUCT SET  AttributeValue = 'A & B'  WHERE AttributeValue LIKE '% and %' AND PimProductId = 158
    */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @PimProductIds VARCHAR(MAX), @PimAttributeId VARCHAR(MAX), @FirstWhereClause VARCHAR(MAX)= ''
			 , @SQL NVARCHAR(MAX)= '' ,@OutPimProductIds VARCHAR(max),@ProductXML NVARCHAR(max) ;
             DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId()
					 ,@RowsCount INT =0 ;
             DECLARE @TransferPimProductId TransferId 
			 DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT 
			  ,PimAttributedefaultValueId INT 
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
			   DECLARE @TBL_AttributeDetailsLocale AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
			 DECLARE @TBL_MultiSelectAttribute TABLE (PimAttributeId INT , AttributeCode VARCHAR(600))
			-- DECLARE @TBL_AttributeValueFinale TABLE (PimProductId INT , AttributeValue NVARCHAR(max),AttributeCode VARCHAR(300),PimAttributeId INT)
			 --INSERT INTO @TBL_MultiSelectAttribute (PimAttributeId,AttributeCode)
			 --SELECT PimAttributeId,AttributeCode FROM dbo.Fn_GetProductMediaAttributeId() 
			 DECLARE @TBL_MediaAttribute TABLE (Id INT ,PimAttributeId INT ,AttributeCode VARCHAR(600) )

			 DECLARE @TBL_ProductIds TABLE 
			 (
			  PimProductId INT,
			  ModifiedDate DATETIME  
			 )

			 DECLARE @FamilyDetails TABLE
             (
			  PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(Max)
             );
             DECLARE @DefaultAttributeFamily INT= dbo.Fn_GetDefaultPimProductFamilyId();
             DECLARE @ProductIdTable TABLE
             (PimProductId INT,
              CountId      INT,
              RowId        INT IDENTITY(1,1)
             );
             SET @FirstWhereClause =
             (
                 SELECT WhereClause
                 FROM Fn_GetWhereClauseXML(@WhereClause)
                 WHERE id = 1
             );

             IF (@FirstWhereClause LIKE '%Brand%'
                OR @FirstWhereClause LIKE '%Vendor%'
                OR @FirstWhereClause LIKE '%ShippingCostRules%'
                OR @FirstWhereClause LIKE '%Highlights%') and @IsCallForAttribute=1
                 BEGIN

				SET @SQL =   
				           ';WIth Cte_DefaultValue AS (
										  SELECT AttributeDefaultValueCode , ZPDF.PimAttributeId ,FNPA.AttributeCode
										  FROM ZnodePImAttributeDefaultValue ZPDF
										  INNER JOIN [dbo].[Fn_GetProductDefaultFilterAttributes] () FNPA ON ( FNPA.PimAttributeId = ZPDF.PimAttributeId) 

										)
										, Cte_productIds AS 
										(
										  SELECT a.PimProductId, c.AttributeCode , CTDV.AttributeDefaultValueCode AttributeValue,b.ModifiedDate 
										  FROM  ZnodePimAttributeValue a
										  LEFT JOIN ZnodePimAttribute c ON(c.PimAttributeId = a.PimAttributeId)
										  LEFT JOIN ZnodePimAttributeValueLocale b ON(b.PimAttributeValueId = a.PimAttributeValueId)  
										  INNER JOIN Cte_DefaultValue CTDV ON (CTDV.AttributeCode = c.AttributeCode 
										  AND EXISTS (SELECT TOP 1 1 FROM dbo.split(b.AttributeValue,'','') SP WHERE SP.Item = CTDV.AttributeDefaultValueCode) )
										  Union all 
										  
											SELECT a.PimProductId,c.AttributeCode,ZPADV.AttributeDefaultValueCode AttributeValue ,a.ModifiedDate 
											FROM ZnodePimProductAttributeDefaultValue ZPPADV
											INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON (ZPPADV.PimAttributeDefaultValueId = ZPADV.PimAttributeDefaultValueId)
											LEFT JOIN ZnodePimAttributeValue a ON (a.PimAttributeValueId = ZPPADV.PimAttributeValueId )
											LEFT JOIN ZnodePimAttribute c ON ( c.PimAttributeId=a.PimAttributeId )
											INNER JOIN Cte_DefaultValue CTDV ON (CTDV.AttributeCode = c.AttributeCode )
										)										
										SELECT PimProductId ,ModifiedDate
										FROM Cte_productIds WHERE   '+@FirstWhereClause+' GROUP BY PimProductId,ModifiedDate Order By ModifiedDate DESC ';

					 INSERT INTO @TBL_ProductIds ( PimProductId, ModifiedDate )
					 EXEC (@SQL);

                     INSERT INTO @ProductIdTable( PimProductId )
                     SELECT PimProductId FROM @TBL_ProductIds

                     INSERT INTO @TransferPimProductId
					 SELECT PimProductId
                     FROM @ProductIdTable
                     UNION ALL 
					 SELECT 0

                     DELETE FROM @ProductIdTable;
                     SET @WhereClause = CAST(REPLACE(CAST(@WhereClause AS NVARCHAR(MAX)), @FirstWhereClause, ' 1 = 1') AS XML);
                 END
	            ELSE IF @PimProductId <> ''
			    BEGIN 
				 INSERT INTO @TransferPimProductId(id)
				 SELECT Item 
				 FROM dbo.split(@PimProductId,',')
			    END 

				--SELECT id , @IsProductNotIn
				--FROM @TransferPimProductId 
 
             EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = @AttributeCode,
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = @IsProductNotIn,
				  @OutProductId = @OutPimProductIds OUT
				  ;
		
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP 


			 --SELECT * FROM @ProductIdTable

			 INSERT INTO @TBL_MediaAttribute (Id,PimAttributeId,AttributeCode )
			 SELECT Id,PimAttributeId,AttributeCode 
			 FROM [dbo].[Fn_GetProductMediaAttributeId]()
           
             SET @PimProductIds = SUBSTRING(
                                           (
                                               SELECT ','+CAST(PimProductId AS VARCHAR(100))
                                               FROM @ProductIdTable
                                               FOR XML PATH('')
                                           ), 2, 4000);
             SET @PimAttributeId = SUBSTRING( (SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000)	 
			  SET @AttributeCode = SUBSTRING( (SELECT ','+AttributeCode  FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000)	;
           
			 INSERT INTO @TBL_AttributeDefaultValue
             (PimAttributeId,
              AttributeDefaultValueCode,
              IsEditable,
              AttributeDefaultValue,
			  DisplayOrder
			  ,PimAttributedefaultValueId
             )
             EXEC Znode_GetAttributeDefaultValueLocaleNew
                  @PimAttributeId,
                  @LocaleId;



             INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )
             EXEC Znode_GetProductsAttributeValue
                  @PimProductIds,
                  @PimAttributeId,
                  @localeId;
				        		
			 INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1;
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';
           
		 	INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT PimProductId ,FamilyName, 'AttributeFamily',NULL
			FROM @FamilyDetails 
            
			INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT a.PimProductId ,CASE WHEN IsProductPublish = 1 THEN   'Published' WHEN IsProductPublish = 0 THEN 'Draft'  ELSE 'Not Published' END, 'PublishStatus',NULL
			FROM @ProductIdTable a 
			INNER JOIN ZnodePimProduct b ON (b.PimProductId = a.PimProductId)


			INSERT INTO @TBL_AttributeDetailsLocale (PimProductId ,PimAttributeId,AttributeCode )
			SELECT  TBLAD.PimProductId ,TBLAD.PimAttributeId,TBLAD.AttributeCode 
			    --   CASE WHEN CTDD.AttributeValue IS NULL THEN TBLAD.AttributeValue ELSE CTDD.AttributeValue END AttributeValue
			FROM @TBL_AttributeDetails TBLAD 
			GROUP BY  TBLAD.PimProductId ,TBLAD.PimAttributeId,TBLAD.AttributeCode 

		--	;With Cte_DistinctData  AS 
		--	(
		--	   SELECT DISTINCT PimProductId ,TBLADI.PimAttributeId 
		--	                                             ,SUBSTRING((SELECT ','+ TBADV.AttributeDefaultValue 
		--																 FROM  @TBL_AttributeDefaultValue TBADV 
		--																WHERE (TBADV.AttributeDefaultValueCode  = TBLADI.AttributeValue AND TBADV.PimAttributeId = TBLADI.PimAttributeId )
		--												  FOR XML PATH('') ),2,4000 ) AttributeValue 
		--	   FROM @TBL_AttributeDetails  TBLADI
		--	   INNER JOIN   @TBL_AttributeDefaultValue TBLMSW ON (TBLMSW.PimAttributeId = TBLADI.PimAttributeId)
		--	)

		--UPDATE TBLPP 
		--SET AttributeValue = CTDD.AttributeValue 
		--FROM  Cte_DistinctData CTDD 
		--INNER JOIN @TBL_AttributeDetailsLocale TBLPP ON (TBLPP.PimProductId = CTDD.PimProductId AND TBLPP.PimAttributeId  = CTDD.PimAttributeid)
		--WHERE CTDD.AttributeValue IS NOT NULL  
				
	    UPDATE TBLPP 
		SET AttributeValue = CTDD.AttributeValue 
		FROM  @TBL_AttributeDetails CTDD 
		INNER JOIN @TBL_AttributeDetailsLocale TBLPP ON (TBLPP.PimProductId = CTDD.PimProductId AND TBLPP.AttributeCode  = CTDD.AttributeCode)
		WHERE TBLPP.AttributeValue IS NULL 

		;WITH Cte_ProductMedia
               AS (SELECT DISTINCT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+[dbo].[Fn_GetMediaThumbnailMediaPath]( zm.PATH )
			   FROM ZnodeMedia AS ZM
               INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_MediaAttribute AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_MediaAttribute AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVaLue
			  FROM @TBL_AttributeDetailsLocale TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;

			    

		
		   	 SET @ProductXML =  '<MainProduct>'+ STUFF( (  SELECT '<Product>'+'<PimProductId>'+CAST(TBAD.PimProductId AS VARCHAR(50))+'</PimProductId>'+ STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST( (SELECT ''+TBADI.AttributeValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
															FROM @TBL_AttributeDetailsLocale TBADI      
															 WHERE TBADI.PimProductId = TBAD.PimProductId 
															 ORDER BY TBADI.PimProductId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Product>'	   

			FROM @TBL_AttributeDetailsLocale TBAD
			INNER JOIN @ProductIdTable TBPI ON (TBAD.PimProductid = TBPI.PimProductId )
			LEFT JOIN @TBL_ProductIds TPT ON TBAD.PimProductId = TPT.PimProductId
			GROUP BY TBAD.pimProductid, TPT.ModifiedDate, TBPI.RowId 
			ORDER BY TPT.ModifiedDate DESC, TBPI.RowId 
			FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainProduct>'
			--FOR XML PATH ('MainProduct'))


			SELECT  @ProductXML  ProductXMl
		   
		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA 
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1  
			 AND  IsCategory = 0 
			 AND ZPA.IsShowOnGrid = 1  
			 UNION ALL 
			 SELECT 'PublishStatus','Publish Status'


			  SELECT @RowsCount AS RowsCount;

             -- find the all locale values 
         END TRY
         BEGIN CATCH
		    SELECT ERROR_MESSAGE()
                DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageProductList_XML @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PimProductId='+@PimProductId+',@IsProductNotIn='+CAST(@IsProductNotIn AS VARCHAR(50))+',@IsCallForAttribute='+CAST(@IsCallForAttribute AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageProductList_XML',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;

         END CATCH;

     END;
GO
PRINT N'Altering [dbo].[Znode_ManageProductListByAttributes]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ManageProductListByAttributes' )
BEGIN
	DROP PROCEDURE Znode_ManageProductListByAttributes
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageProductListByAttributes]
(   @WhereClause      XML,
	@PimAttributeIds  VARCHAR(3000) = NULL,
	@Rows             INT           = 100,
	@PageNo           INT           = 0,
	@Order_BY         VARCHAR(1000) = '',
	@LocaleId         INT,
	@PimProductId     VARCHAR(1000) = NULL,
	@IsProductNotIn   BIT           = 0,
	@RelatedProductId INT           = 0, 
	@IsDebug		    BIT = 0 
	)
AS
   /*  Summary:-  This Procedure is used for get product List with extra column attribute supllied to the procedure 
     Unit Testing 
     DECLARE @EDE INT=0 
	exec Znode_ManageProductListByAttributes @WhereClause='',@PimAttributeIds = '35,81',@Rows = 10,@PageNo=1,@Order_BY = '',@RelatedProductId = 10746,@PimProductId = '',@IsProductNotIn= 0 ,@LocaleId=1 --SELECT @EDE 
	*/
     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
		 
             DECLARE @SQL NVARCHAR(MAX), @AttributeCode_filter NVARCHAR(2000), @WhereClauseChanges NVARCHAR(MAX)= '',@OutPimProductIds varchar(max) ;
             SET @WhereClauseChanges = CONVERT(NVARCHAR(MAX), @WhereClause);
             DECLARE @PimAttributeFamilyId INT= Dbo.Fn_GetDefaultValue('PimFamily'), @RowsCount INT, @DefaultLocaleId INT= Dbo.Fn_GetDefaultlocaleId();
             DECLARE @TransferPimProductId TransferId 
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()					 
			 DECLARE @ProductIdTable TABLE
             (PimProductId INT,
              CountId      INT,
              RowId        INT identity(1,1)
             );
             DECLARE @TBL_PimAttributeId TABLE
             (PimAttributeId INT,
              AttributeCode  VARCHAR(600)
             );
             INSERT INTO @TBL_PimAttributeId
             (PimAttributeId,
              AttributeCode
             )
                    SELECT PimAttributeId,
                           AttributeCode
                    FROM ZnodePimAttribute ZPA
                    WHERE EXISTS
                    (
                        SELECT TOP 1 1
                        FROM dbo.Split(@PimAttributeIds, ',') SP
                        WHERE SP.Item = ZPA.PimAttributeId
                    );
             SET @AttributeCode_filter = ISNULL(CAST((
                                                      SELECT CAST('<WhereClauseModel><WhereClause> '+ ' AttributeCode = '+''''+TBPA.AttributeCode+''''+'</WhereClause></WhereClauseModel>' AS XML )
                                                      FROM @TBL_PimAttributeId TBPA
                                                      FOR XML PATH(''),TYPE
                                                  ) AS NVARCHAR(max)),'');
             SET @WhereClauseChanges = [dbo].[Fn_GetXmlWhereClauseForAttribute](@WhereClauseChanges,@AttributeCode_filter, @LocaleId);
             SET @WhereClause = CONVERT(XML, @WhereClauseChanges);	
		 
		  INSERT INTO @TransferPimProductId
		  SELECT ITEM
		  FROM DBO.SPLIT(@PIMPRODUCTID,',')
		  
		   DECLARE @AttributeCode NVARCHAR(max)
			 SET @AttributeCode = SUBSTRING ((SELECT ','+AttributeCode FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH('') ),2,4000)

		   EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = @AttributeCode,
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = @IsProductNotIn,
				  @OutProductId = @OutPimProductIds OUT
				  ;
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP 
			 
		
             SET @AttributeCode_filter = SUBSTRING(
                                                  (
                                                      SELECT ','+TBPA.AttributeCode
                                                      FROM @TBL_PimAttributeId TBPA
                                                      FOR XML PATH('')
                                                  ), 1, 4000);
             DECLARE @PimProductIds VARCHAR(MAX)= SUBSTRING(
                                                           (
                                                               SELECT ','+CAST(PimProductId AS VARCHAR(100))
                                                               FROM @ProductIdTable
                                                               FOR XML PATH('')
                                                           ), 2, 4000);

														      		
             DECLARE @DefaultAttributeCode VARCHAR(MAX)= dbo.Fn_GetDefaultValue('AttributeCode');
             
			 INSERT INTO @TBL_PimAttributeId
             (PimAttributeId,
              AttributeCode
             )
                    SELECT PimAttributeId,
                           AttributeCode
                    FROM ZnodePimAttribute ZPA
                    WHERE EXISTS
                    (
                        SELECT TOP 1 1
                        FROM dbo.Split(@DefaultAttributeCode, ',') SP
                        WHERE SP.Item = ZPA.AttributeCode
                    );
			
			INSERT INTO @TBL_PimAttributeId
             (PimAttributeId,
              AttributeCode
             )
                    SELECT PimAttributeId,
                           'OR_'+AttributeCode
                    FROM ZnodePimAttribute ZPA
                    WHERE EXISTS
                    (
                        SELECT TOP 1 1
                        FROM dbo.Split(@PimAttributeIds, ',') SP
                        WHERE SP.Item = ZPA.PimAttributeId
                    );
             
	
             SET @DefaultAttributeCode = @DefaultAttributeCode + @AttributeCode_filter;
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId                INT,
              AttributeValue              NVARCHAR(MAX),
              AttributeCode               VARCHAR(600),
              PimAttributeId              INT,
              PimProductTypeAssociationId INT,
              DisplayOrder                INT,
              IsNonEditableRow            BIT DEFAULT 0
             );
             DECLARE @TBL_AttributeCode TABLE
             (PimAttributeId INT,
              AttributeCode  VARCHAR(300)
             );
             INSERT INTO @TBL_AttributeCode
             (PimAttributeId,
              AttributeCode
             )
                    SELECT PimAttributeId,
                           AttributeCode
                    FROM ZnodePimAttribute ZPA
                    WHERE EXISTS
                    (
                        SELECT TOP 1 1
                        FROM dbo.split(@DefaultAttributeCode, ',') SP
                        WHERE Sp.Item = ZPA.AttributeCode
                    );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT
             );
			  
             DECLARE @PimAttributeId VARCHAR(MAX);
             SET @PimAttributeId = SUBSTRING(
                                            (
                                                SELECT ','+CAST(TBAC.PimAttributeId AS VARCHAR(50))
                                                FROM @TBL_AttributeCode TBAC
                                                     INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON(ZPADV.PimAttributeId = TBAC.PimAttributeId)
                                                FOR XML PATH('')
                                            ), 2, 4000);

													
             INSERT INTO @TBL_AttributeDefaultValue
             (
			  PimAttributeId,
              AttributeDefaultValueCode,
              IsEditable,
              AttributeDefaultValue
			  ,DisplayOrder
             )
             EXEC Znode_GetAttributeDefaultValueLocale
                  @PimAttributeId,
                  @LocaleId;


             INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )
             EXEC Znode_GetProductsAttributeValue
                  @PimProductIds,
                  @DefaultAttributeCode,
                  @localeId;

			  INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )

			 SELECT ZPAV.PimProductId ,ZPPAVD.PimAttributeDefaultValueId,'OR_'+ZPA.AttributeCode,ZPA.PimAttributeId
             FROM ZnodePimAttributeValue ZPAV 
			 INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId) 
			 INNER JOIN @ProductIdTable TBL ON (TBL.PimProductId = ZPAV.PimProductId )
			INNER JOIN ZnodePimProductAttributeDefaultValue ZPPAVD ON (ZPPAVD.PimAttributeValueId = ZPAV.PimAttributeValueId  )
			WHERE ZPPAVD.LocaleId = @DefaultLocaleId 
			AND EXISTS (SELECT TOP 1 1 FROM dbo.Split(@PimAttributeIds,',') SP WHERE Sp.Item = ZPA.PimAttributeId )
             --;WITH Cte_UpdateDefaultAttributeValue
             --     AS (SELECT PimProductId,
             --                AttributeCode,
             --                AttributeValue,
             --                SUBSTRING(
             --                         (
             --                             SELECT ','+TBADV.AttributeDefaultValue
             --                             FROM @TBL_AttributeDefaultValue TBADV
             --                                  INNER JOIN @TBL_AttributeCode TBAC ON(TBADV.PimAttributeId = TBAC.PimAttributeId)
             --                             WHERE TBAC.AttributeCode = TBAD.AttributeCode
             --                                   AND EXISTS
             --                             (
             --                                 SELECT TOP 1 1
             --                                 FROM dbo.split(TBAD.AttributeValue, ',') SP
             --                                 WHERE Sp.item = TBADV.AttributeDefaultValueCode
             --                             )
             --                             FOR XML PATH('')
             --                         ), 2, 4000) AttributeDefaultValue
             --         FROM @TBL_AttributeDetails TBAD)
                  --UPDATE TBAD
                  --  SET
                  --      AttributeValue = CTUDAV.AttributeDefaultValue
                  --FROM @TBL_AttributeDetails TBAD
                  --     INNER JOIN Cte_UpdateDefaultAttributeValue CTUDAV ON(CTUDAV.PimProductId = TBAD.PimProductId
                  --                                                          AND CTUDAV.AttributeCode = TBAD.AttributeCode)
                  --WHERE AttributeDefaultValue IS NOT NULL;

             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );

             INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1;
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';
			
             --- Update the  product families name locale wise   


			 	;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+dbo.Fn_GetMediaThumbnailMediaPath (zm.PATH) 
			   FROM ZnodeMedia AS ZM
              
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;

		


             UPDATE TBAD
               SET
                   PimProductTypeAssociationId = ZPTA.PimProductTypeAssociationId,
                   DisplayOrder = ZPTA.DisplayOrder
             FROM @TBL_AttributeDetails TBAD
                  INNER JOIN ZnodePimproductTypeAssociation ZPTA ON(ZPTA.PimProductId = TBAD.PimProductId)
             WHERE ZPTA.PimParentProductId = @RelatedProductId;
            
			-- DECLARE @AttributeCode NVARCHAR(4000);
             SET @AttributeCode = SUBSTRING(
                                           (
                                               SELECT DISTINCT
                                                      ','+QUOTENAME(AttributeCode)
                                               FROM @TBL_PimAttributeId
                                               FOR XML PATH('')
                                           ), 2, 4000);
             DECLARE @AttributeCode_Duplicate NVARCHAR(4000)= SUBSTRING(
                                                                       (
                                                                           SELECT 
                                                                                  ', Piv.'+QUOTENAME(AttributeCode)
                                                                           FROM ZnodePimAttribute ZPA
                                                                           WHERE EXISTS
                                                                           (
                                                                               SELECT TOP 1 1
                                                                               FROM dbo.Split(@PimAttributeIds, ',') SP
                                                                               WHERE SP.Item = ZPA.PimAttributeId
                                                                               ORDER BY AttributeCode
                                                                           )
																		   GROUP BY ZPA.AttributeCode,ZPA.DisplayOrder
																		   ORDER BY ZPA.DisplayOrder  DESC
                                                                           FOR XML PATH('')
                                                                       ), 1, 4000);
             DECLARE @AttributeCode_Duplicate_Data NVARCHAR(4000);
			 	 
			

			  SET  @AttributeCode_Duplicate_Data= SUBSTRING(
                                                                       (
                                                                           SELECT 
                                                                                  'AND Piv.'+QUOTENAME('OR_'+AttributeCode) +'= Isa.'+QUOTENAME(AttributeCode)+' '
                                                                           FROM ZnodePimAttribute ZPA
                                                                           WHERE EXISTS
                                                                           (
                                                                               SELECT TOP 1 1
                                                                               FROM dbo.Split(@PimAttributeIds, ',') SP
                                                                               WHERE SP.Item = ZPA.PimAttributeId
                                                                               ORDER BY AttributeCode
                                                                           )
																		   GROUP BY ZPA.AttributeCode,ZPA.DisplayOrder
																		   ORDER BY ZPA.DisplayOrder  DESC
                                                                           FOR XML PATH('')
                                                                       ), 4, 4000) +' '

            -- SET @AttributeCode_Duplicate_Data = REPLACE(SUBSTRING(@AttributeCode_Duplicate, 2, 4000), ',', '+'',''+');
             SELECT PimProductId,
                    AttributeValue,
                    AttributeCode,
                    PimProductTypeAssociationId,
                    DisplayOrder
             INTO #Temp_attribute
             FROM @Tbl_AttributeDetails
             ORDER BY DisplayOrder;
             SELECT *
             INTO #temp_Family
             FROM @FamilyDetails;
             
			 DECLARE @IsSelectedAttributeValue TABLE
             (ProductId      INT,
              AttributeValue NVARCHAR(500),
              AttributeCode  NVARCHAR(500),
              PimAttributeId INT,PimAttributeDefaultValueId INT 
             );

			  
		   DECLARE @IsSelectedAttributeValueLocale TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode NVARCHAR(600),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(max),
			  DisplayOrder   INT 
             );
          

		  -- select @PimProductId ,@AttributeCode ,@LocaleId 
		  ;With Cte_AttributeVAkuestest AS 
		  (
		    SELECT PimAttributeId , ZPPAD.PimAttributeDefaultValueId ,ZPAV.PimProductId
			FROM ZnodePimAttributeVAlue ZPAV 
			INNER JOIN ZnodePimProductAttributeDefaultValue ZPPAD ON (ZPPAD.PimAttributeValueId = ZPAV.PimAttributeValueId)
			WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(@PimAttributeIds,',') SP WHERE SP.Item = ZPAV.PimAttributeId )
			AND EXISTS (SELECT TOP 1 1 FROM dbo.split(@PimProductId,',') SP WHERE SP.Item = ZPAV.PimProductId )
		) ,Cte_PimAttributeDefaultValueLocale AS 
		(
		  SELECT  AttributeDefaultValue ,PimAttributeId,PimProductId,CTA.PimAttributeDefaultValueId
		  FROM ZnodePimAttributeDefaultValueLocale CTA  
		  INNER JOIN Cte_AttributeVAkuestest CTB ON (CTB.PimAttributeDefaultValueId = CTA.PimAttributeDefaultValueId)		
		  WHERE LocaleId = @DefaultLocaleId 
		  UNION 
		  SELECT  AttributeDefaultValue ,PimAttributeId,PimProductId,CTA.PimAttributeDefaultValueId
		  FROM ZnodePimAttributeDefaultValueLocale CTA 
		  INNER JOIN Cte_AttributeVAkuestest CTB ON (CTB.PimAttributeDefaultValueId = CTA.PimAttributeDefaultValueId)		
		  WHERE LocaleId = @DefaultLocaleId 	
		)
		,Cte_AttributeValueForCode 
		As
		(
		  SELECT AttributeDefaultValue AtributeValue , AttributeCode ,PimProductId ,a.PimAttributeDefaultValueId
		  FROM Cte_PimAttributeDefaultValueLocale a
		  INNER JOIN ZnodePimAttribute b ON (b.PimAttributeId = a.PimAttributeId )
		)
			 INSERT INTO @IsSelectedAttributeValue (ProductId,AttributeCode,AttributeValue,PimAttributeDefaultValueId)
             SELECT PimProductId,AttributeCode,AtributeValue,PimAttributeDefaultValueId
			 FROM Cte_AttributeValueForCode
             
			 --INSERT INTO @IsSelectedAttributeValueLocale
    --         EXEC Znode_GetAttributeDefaultValueLocale
    --              @PimAttributeIds,
    --              @LocaleId;
             
			 --UPDATE izav
    --           SET
    --               izav.AttributeValue = isval.AttributeDefaultValue
    --         FROM @IsSelectedAttributeValue izav
    --              INNER JOIN @IsSelectedAttributeValueLocale isval ON izav.AttributeValue = isval.AttributeDefaultValueCode AND izav.PimAttributeId = isval.PimAttributeId ;
             

			 SELECT * 
			 --SUBSTRING(
    --                         (
    --                             SELECT ','+isav.AttributeValue
    --                             FROM @IsSelectedAttributeValue isav
				--				 INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ISAV.PimAttributeID )
    --                             WHERE isa.ProductId = isav.ProductId
    --                             ORDER BY ZPA.DisplayOrder DESC
    --                             FOR XML PATH('')
    --                         ), 2, 4000) AttributeValue,
							

             INTO #IsSelectedAttribute
             FROM @IsSelectedAttributeValue isa
			; 
				 
			 IF @IsDebug = 1 
			 BEGIN 
			 SELECT * FROM @IsSelectedAttributeValue izav

			 SELECT * FROM #IsSelectedAttribute

			 END 
             --select * from @IsSelectedAttributeValue
             --select @AttributeCode_Duplicate,@AttributeCode_Duplicate_data
             --select * from #IsSelectedAttribute
			 
             SET @AttributeCode = REPLACE(@AttributeCode, ',[DisplayOrder]', '');
             SET @SQL = '
			     
				 ;with Cte_Getvalue AS (
				 SELECT ProductId , '+SUBSTRING(@AttributeCode_Duplicate, 2, 4000)+'
				 FROM ( SELECT ProductId,AttributeCode,PimAttributeDefaultValueId FROM #IsSelectedAttribute gt ) dd 
				 PIVOT ( MAX (PimAttributeDefaultValueId) FOR AttributeCode IN ('+REPLACE(SUBSTRING(@AttributeCode_Duplicate, 2, 4000),'Piv.','')+')  ) PIV 
				 )

				

				SELECT DISTINCT  piv.PimProductTypeAssociationId, zpp.PimProductid ProductId, [ProductName],ProductType ,ISNULL(zf.FamilyName,'''')  AttributeFamily , [SKU]
						  , CASE WHEN [IsActive] IS NULL THEN ''false'' ELSE   [IsActive]  END  [Status],  piv.[ProductImage] ImagePath,[Assortment],DisplayOrder  ,'+CAST(@LocaleId AS VARCHAR(50))+' LocaleId
						  ,DENSE_RANK()Over(Order By'+SUBSTRING(@AttributeCode_Duplicate, 2, 4000)+') CombinationId '+@AttributeCode_Duplicate+'
					, CASE When isa.ProductId Is Null then 0 ELSE 1 END IsNonEditableRow,'+ CAST(@RelatedProductId AS VARCHAR(50))+' RelatedProductId
				FROM ZNodePimProduct zpp 
				LEFT JOIN  #temp_Family zf ON (zf.PimProductId = zpp.PimProductId)
				INNER JOIN #Temp_attribute 
				PIVOT 
				(
				Max(AttributeValue) FOR AttributeCode  IN ( '+@AttributeCode+')
				)Piv  
				ON (Piv.PimProductId = zpp.PimProductid) 
				--LEFT JOIN ZnodeMedia zm ON (zm.MediaId = piv.[ProductImage])
				LEFT OUTER JOIN Cte_Getvalue isa ON ('+@AttributeCode_Duplicate_Data+')
				    '+' Order BY '+ISNULL(CASE
                                                  WHEN @Order_BY = ''
                                                  THEN 'DisplayOrder'
                                                  ELSE @Order_BY
                                              END, 'DisplayOrder');
		
	
             -- SELECT '''+SUBSTRINg(REPLACE(@AttributeCode_Duplicate,'Piv.',''),2,4000)+''' Ids
			 
             SELECT AttributeCode
             FROM ZnodePimAttribute ZPA
             WHERE EXISTS
             (
                 SELECT TOP 1 1
                 FROM dbo.Split(@PimAttributeIds, ',') SP
                 WHERE SP.Item = ZPA.PimAttributeId
             );
             
			PRINT @SQL
             EXEC SP_executesql
                  @SQL;
             SELECT @RowsCount AS RowsCount;
             DROP TABLE #Temp_attribute;
             DROP TABLE #temp_Family;
   
             -- find the all locale values 
         END TRY
         BEGIN CATCH
                DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageProductListByAttributes @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@PimAttributeIds='+@PimAttributeIds+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@PimProductId='+@PimProductId+',@IsProductNotIn='+CAST(@IsProductNotIn AS VARCHAR(50))+',@RelatedProductId='+CAST(@RelatedProductId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageProductListByAttributes',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_GetPimProductAttributeValues]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetPimProductAttributeValues' )
BEGIN
	DROP PROCEDURE Znode_GetPimProductAttributeValues
END
GO
CREATE PROCEDURE [dbo].[Znode_GetPimProductAttributeValues]
(
    @ChangeFamilyId INT = 0,
    @PimProductId   INT = 0,
    @LocaleId       INT = 0,
    @IsCopy         BIT = 0
)
AS
/*
	 Summary :- This procedure is used to get the Attribute and Product attribute value as per filter pass 
	 Unit Testing 
	 BEGIN TRAN
	 EXEC Znode_GetPimProductAttributeValues 0, 198,1,0
	 ROLLBACK TRAN

*/	 
     BEGIN
	     BEGIN TRAN PimProductAttributeValues
         BEGIN TRY
             DECLARE  @V_LocaleId INT= @LocaleId, @LocaleIdDefault INT= dbo.Fn_GetDefaultLocaleId(), @PimAttributeFamilyId  INT; 
			 DECLARE @PimAttributeId VARCHAR(max),@PimProductIds  VARCHAR(max) 
             
			 DECLARE @TBL_PimAttribute TABLE (PimAttributeId INT ,ParentPimAttributeId INT ,AttributeTypeId INT ,AttributeCode VARCHAR(600),IsRequired BIT,IsLocalizable BIT,IsFilterable BIT
						,IsSystemDefined BIT,IsConfigurable BIT ,IsPersonalizable BIT,DisplayOrder INT ,HelpDescription NVARCHAR(max),IsCategory BIT,IsHidden BIT,CreatedDate DATETIME ,ModifiedDate DATETIME 
						,AttributeName NVARCHAR(max) ,AttributeTypeName VARCHAR(600) )
			 
			 DECLARE @TBL_PimAttributeDefault TABLE (PimAttributeId INT,AttributeDefaultValueCode VARCHAR(600),IsEditable BIT,AttributeDefaultValue NVARCHAR(max),DisplayOrder int,PimAttributeDefaultValueId INT )
			 DECLARE @TBL_AttributeValue TABLE (PimProductId INT , AttributeValue NVARCHAR(max),AttributeCode VARCHAR(300),PimAttributeId INT)
			 DECLARE @TBL_AttributeFamily TABLE (PimAttributeFamilyId INT ,FamilyCode VARCHAR(600),IsSystemDefined BIT ,IsDefaultFamily BIT ,IsCategory BIT ,AttributeFamilyName NVARCHAR(max))
			 DECLARE @TBL_MultiSelectAttribute TABLE (PimAttributeId INT , AttributeCode VARCHAR(600))
			 DECLARE @TBL_AttributeValueFinale TABLE (PimProductId INT , AttributeValue NVARCHAR(max),AttributeCode VARCHAR(300),PimAttributeId INT)
			 INSERT INTO @TBL_MultiSelectAttribute (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM [dbo].[Fn_GetProductMultiSelectAttributes] ()
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()
			   --- Get the default family id 
			 IF @ChangeFamilyId = 0 
			   BEGIN 			    
				SET @PimAttributeFamilyId = ISNULL((SELECT TOP 1 PimAttributeFamilyId FROM ZnodePimProduct ZPP WHERE PimProductId = @PimProductId ), dbo.Fn_GetDefaultPimProductFamilyId() )
			   END   
		     ELSE 
			   BEGIN 
				SET @PimAttributeFamilyId = @ChangeFamilyId
			   END 
			 
			 ;With Cte_AttributeIdss AS 
			(SELECT PimAttributeId FROM ZnodePimFamilyGroupMapper  ZPFGM 
			WHERE PimAttributeFamilyId = @PimAttributeFamilyId 
			AND NOT EXISTS
			(SELECT TOP 1 1 FROM ZnodePimConfigureProductAttribute ZPCPA WHERE ZPCPA.PimAttributeId = ZPFGM.PimAttributeId AND ZPCPA.PimProductId = @PimProductId)
               UNION  
                SELECT PimAttributeId FROM ZnodePimAttributeValue ZPAV WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimAttribute ZPA WHERE ZPA.PimAttributeId = ZPAV.PimAttributeId AND ZPA.IsPersonalizable = 1 ) 
			  AND ZPAV.PimProductId = @PimProductId AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimConfigureProductAttribute ZPCPA WHERE ZPCPA.PimAttributeId = ZPAV.PimAttributeId AND ZPCPA.PimProductId = @PimProductId))
			   
			  SELECT  @PimAttributeId = SUBSTRING ((SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM Cte_AttributeIdss FOR XML PATH ('')),2,4000)
			 
			  INSERT INTO @TBL_PImAttribute (PimAttributeId,ParentPimAttributeId,AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable
			  ,IsSystemDefined,IsConfigurable,IsPersonalizable,DisplayOrder,HelpDescription,IsCategory,IsHidden,CreatedDate,ModifiedDate,AttributeName ,AttributeTypeName )
			  EXEC [dbo].[Znode_GetPimAttributesDetails] @PimAttributeId,@LocaleId
		
			  INSERT INTO @TBL_AttributeValue (PimProductId,AttributeValue,AttributeCode,PimAttributeId)
			  EXEC [dbo].[Znode_GetProductsAttributeValueWithCode]  @PimProductId , @PimAttributeId ,@LocaleId
		
			  INSERT INTO @TBL_PimAttributeDefault (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder,PimAttributeDefaultValueId)
			  EXEC [dbo].[Znode_GetAttributeDefaultValueLocaleNew] @PimAttributeId,@LocaleId


			  INSERT INTO @TBL_AttributeFamily (PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,AttributeFamilyName)
			  EXEC Znode_GetFamilyValueLocale  @PimAttributeFamilyId, @LocaleId 


				--  update the media path 
			  ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+dbo.Fn_GetMediaThumbnailMediaPath( zm.PATH )
			   FROM ZnodeMedia AS ZM
			   INNER JOIN @TBL_AttributeValue AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue , SUBSTRING( ( SELECT ','+AttributeValue
			   FROM  @TBL_AttributeValue AS TBAI
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) MediaIds  
			   FROM @TBL_AttributeValue AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue+'~'+CTPM.MediaIds 
			  FROM @TBL_AttributeValue TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;
				
		

				-- IF IsCopy Is True then Unique value are blank 
			   ;With Cte_UniqueAttributeId AS  
			   (SELECT c.PimAttributeId FROM ZnodePimAttributeValidation AS c INNER JOIN ZnodeAttributeInputValidation AS d ON(c.InputValidationId = d.InputValidationId)
			   WHERE d.Name = 'UniqueValue' AND c.Name = 'true' AND @Iscopy = 1 GROUP BY c.PimAttributeId)

			   UPDATE TBAV SET AttributeValue = '' FROM @TBL_AttributeValue  TBAV INNER JOIN Cte_UniqueAttributeId CTUA ON (CTUA.PimAttributeId = TBAV.PimAttributeId)

			   INSERT INTO @TBL_AttributeValueFinale (PimProductId  , AttributeValue ,AttributeCode ,PimAttributeId)

			   SELECT DISTINCT  PimProductId  ,AttributeValue

													 ,AttributeCode ,PimAttributeId
			   FROM @TBL_AttributeValue TBLA 
			  
			  --;With Cte_getAttributevalues AS 
			  --(
			  --SELECT ZPAV.PimProductId ,PimAttributeId ,SUBSTRING ((SELECT ','+ AttributeDefaultValueCode FROM @TBL_PimAttributeDefault ZPADF 
					--			WHERE (ZPADF.PimAttributeDefaultValueId = ZPAVL.PimAttributeDefaultValueId)
					--			FOR XML PATH ('') ),2,4000) AttributeValue 
			  --FROM  ZnodePimAttributeValue ZPAV
			  --INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPAV.PimAttributeValueId )
			  --WHERE PimProductId = @PimProductId
			  --)

			  --UPDATE TRTR
			  --SET  AttributeValue = CTEON.AttributeValue
			  --FROM @TBL_AttributeValueFinale  TRTR 
			  --INNER JOIN Cte_getAttributevalues CTEON ON (TRTR.PimProductId = CTEON.PimProductId AND TRTR.PimAttributeId = CTEON.PimAttributeId )
			 
			
			   
			   SELECT TBAF.PimAttributeFamilyId,FamilyCode,TBPA.PimAttributeId,PimAttributeGroupId,TBPA.AttributeTypeId,AttributeTypeName,TBPA.AttributeCode,
						IsRequired,IsLocalizable,IsFilterable,AttributeName, TBAV.AttributeValue  ,PimAttributeValueId,ZPV.PimAttributeDefaultValueId,
						TBADV.AttributeDefaultValueCode ,AttributeDefaultValue AS AttributeDefaultValue,ISNULL(NULL, 0) AS RowId,ISNULL(IsEditable, 1) AS IsEditable,
						ZAIV.ControlName,ZAIV.Name AS ValidationName,ZAIVR.ValidationName AS SubValidationName,ZAIVR.RegExp,ZPAV.Name AS ValidationValue,
						CAST(CASE WHEN ZAIVR.RegExp IS NULL THEN 0 ELSE 1 END AS BIT) AS IsRegExp,HelpDescription
				FROM @TBL_PimAttribute  TBPA 
				LEFT JOIN @TBL_AttributeValueFinale  TBAV ON (TBAV.PimAttributeId = TBPA.PimAttributeId)
				LEFT JOIN @TBL_PimAttributeDefault TBADV ON (TBADV.PimAttributeId = TBPA.PimAttributeId)
				LEFT JOIN ZnodePimAttributeValidation AS ZPAV ON(ZPAV.PimAttributeId = TBPA.PimAttributeId)
				LEFT JOIN ZnodeAttributeInputValidation AS ZAIV ON(ZPAV.InputValidationId = ZAIV.InputValidationId)
				LEFT JOIN ZnodeAttributeInputValidationRule AS ZAIVR ON(ZPAV.InputValidationRuleId = ZAIVR.InputValidationRuleId)
				LEFT JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = TBAV.PimProductId AND ZPV.PimAttributeId = TBAV.PimAttributeId)
				LEFT JOIN @TBL_AttributeFamily TBAF ON (TBAF.PimAttributeFamilyId = @PimAttributeFamilyId)
				LEFT JOIN ZnodePimFamilyGroupMapper ZPFG ON (ZPFG.PimAttributeFamilyId = TBAF.PimAttributeFamilyId AND ZPFG.PimAttributeId = TBPA.PimAttributeId)
				ORDER BY TBPA.DisplayOrder,	TBADV.DisplayOrder
		
		 COMMIT TRAN PimProductAttributeValues;
         END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
             DECLARE @Status BIT ;
		  SET @Status = 0;
		  DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
		   @ErrorLine VARCHAR(100)= ERROR_LINE(),
		    @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPimProductAttributeValues @ChangeFamilyId='+cast (@ChangeFamilyId AS VARCHAR(50))
		    +',@PimProductId = '+cast (@PimProductId AS VARCHAR(50))+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@IsCopy='+CAST(@IsCopy AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
          SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  ROLLBACK TRAN PimProductAttributeValues;

          EXEC Znode_InsertProcedureErrorLog
            @ProcedureName = 'Znode_GetPimProductAttributeValues',
            @ErrorInProcedure = @Error_procedure,
            @ErrorMessage = @ErrorMessage,
            @ErrorLine = @ErrorLine,
            @ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Altering [dbo].[Znode_ManageLinkProductList]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ManageLinkProductList' )
BEGIN
	DROP PROCEDURE Znode_ManageLinkProductList
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageLinkProductList]
(   @WhereClause      XML,
    @Rows             INT          = 100,
    @PageNo           INT          = 1,
    @Order_BY         VARCHAR(100) = '',
    @RowsCount        INT OUT,
    @LocaleId         INT          = 1,
    @RelatedProductId INT          = 0,
    @PimAttributeId   INT          = 0)
AS
   /*  Summary :- This Procedure is used to find the link product Detail 
     Unit Testing 
     EXEC Znode_ManageLinkProductList '' , @RowsCount = 0 ,@RelatedProductId=128
   */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @PimProductIds VARCHAR(MAX), @PimAttributeIds VARCHAR(MAX),@OutPimProductIds VARCHAR(max);
             DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();
             DECLARE @TransferPimProductId TransferId 
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

		     DECLARE @TBL_LinkProductDetail TABLE
             (PimProductId           INT,
              PimLinkProductDetailId INT,
              RelatedProductId       INT,
              PimAttributeId         INT
             );
             DECLARE @TBL_AttributeDefaultValue TABLE
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder INT
             );
             DECLARE @TBL_AttributeDetails AS TABLE
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             DECLARE @DefaultAttributeFamily INT=
             (
                 SELECT PimAttributeFamilyId
                 FROM ZnodePimAttributeFamily
                 WHERE IsCategory = 0
                       AND IsDefaultFamily = 1
             );
             DECLARE @ProductIdTable TABLE
             (PimProductId INT,
              CountId      INT,
              RowId        INT IDENTITY(1,1)
             );
             INSERT INTO @TBL_LinkProductDetail
             (PimProductId,
              PimLinkProductDetailId,
              RelatedProductId,
              PimAttributeId
             )
                    SELECT PimProductId,
                           PimLinkProductDetailId,
                           PimParentProductId,
                           PimAttributeId
                    FROM ZnodePimLinkProductDetail
                    WHERE PimParentProductId = @RelatedProductId
                          AND PimAttributeId = @PimAttributeId;
                
				INSERT INTO @TransferPimProductId 
                SELECT PimProductId 
                FROM @TBL_LinkProductDetail
             
			 IF NOT EXISTS (SELECT TOP 1 1 FROM @TransferPimProductId) 
			 BEGIN 
			  INSERT INTO @TransferPimProductId 
			  SELECT '-1'
			                                  
             END 
			 DECLARE @AttributeCode NVARCHAR(max)
			 SET @AttributeCode = SUBSTRING ((SELECT ','+AttributeCode FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH('') ),2,4000)

			 EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = @AttributeCode,
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = 0,
				  @OutProductId = @OutPimProductIds OUT;

			
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP 
			 
			 SET @PimProductIds = SUBSTRING(
                                           (
                                               SELECT ','+CAST(PimProductId AS VARCHAR(100))
                                               FROM @ProductIdTable
                                               FOR XML PATH('')
                                           ), 2, 4000);


             SET @PimAttributeIds = SUBSTRING( (SELECT ','+CAST(PimAttributeId AS VARCHAR(50)) FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000);
            
			 INSERT INTO @TBL_AttributeDefaultValue
             (PimAttributeId,
              AttributeDefaultValueCode,
              IsEditable,
              AttributeDefaultValue,
			  DisplayOrder 
             )
             EXEC Znode_GetAttributeDefaultValueLocale
                  @PimAttributeIds,
                  @LocaleId;
             INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId
             )
             EXEC Znode_GetProductsAttributeValue
                  @PimProductIds,
                  @PimAttributeIds,
                  @localeId;
             WITH Cte_UpdateDefaultAttributeValue
                  AS (SELECT PimProductId,
                             AttributeCode,
                             AttributeValue,
                             SUBSTRING(
                                      (
                                          SELECT ','+TBADV.AttributeDefaultValue
                                          FROM @TBL_AttributeDefaultValue TBADV
                                               INNER JOIN ZnodePimAttribute TBAC ON(TBADV.PimAttributeId = TBAC.PimAttributeId)
                                          WHERE TBAC.AttributeCode = TBAD.AttributeCode
                                                AND EXISTS
                                          (
                                              SELECT TOP 1 1
                                              FROM dbo.split(TBAD.AttributeValue, ',') SP
                                              WHERE Sp.item = TBADV.AttributeDefaultValueCode
                                          )
                                          FOR XML PATH('')
                                      ), 2, 4000) AttributeDefaultValue
                      FROM @TBL_AttributeDetails TBAD)
                  UPDATE TBAD
                    SET AttributeValue = CTUDAV.AttributeDefaultValue
                  FROM @TBL_AttributeDetails TBAD
                       INNER JOIN Cte_UpdateDefaultAttributeValue CTUDAV ON(CTUDAV.PimProductId = TBAD.PimProductId
                                                                            AND CTUDAV.AttributeCode = TBAD.AttributeCode)
                  WHERE AttributeDefaultValue IS NOT NULL;
             INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1;
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';
            
			 ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+URL+ZMSM.ThumbnailFolderName+'/'+ zm.PATH 
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;


				
			INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT PimProductId ,FamilyName, 'AttributeFamily',NULL
			FROM @FamilyDetails 
				
				-- LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
             --- Update the  product families name locale wise   
        UPDATE  @TBL_AttributeDetails SET PimAttributeId = 0 WHERE PimAttributeId IS nULL 
	     DECLARE @ProductXML XML 

		--SELECT * FROM @TBL_AttributeDetails

	   	 SET @ProductXML =   '<MainProduct>'+ STUFF( (  SELECT '<Product>'
		                                                    +'<PimLinkProductDetailId>'+CAST(ISNULL(TBLPD.PimLinkProductDetailId,'') AS VARCHAR(50))+'</PimLinkProductDetailId>'
															+'<PimProductId>'+CAST(zpp.PimProductId AS VARCHAR(50))+'</PimProductId>'
															+'<RelatedProductId>'+CAST(ISNULL(TBLPD.RelatedProductId,'') AS VARCHAR(50))+'</RelatedProductId>'
		
		 + STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST( (SELECT ''+TBADI.AttributeValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
															FROM @TBL_AttributeDetails TBADI      
															 WHERE TBADI.PimProductId = zpp.PimProductId 
															 ORDER BY TBADI.PimProductId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Product>'	   

			 FROM @ProductIdTable AS zpp
             LEFT JOIN @TBL_LinkProductDetail AS TBLPD ON(TBLPD.PimProductId = ZPP.PimProductId)
             ORDER BY zpp.RowId
			FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainProduct>'
			--FOR XML PATH ('MainProduct'))


			SELECT  @ProductXML  ProductXMl
		   
		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA 
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1  
			 AND  IsCategory = 0 
			 AND ZPA.IsShowOnGrid = 1  
			 UNION ALL 
			 SELECT 'PublishStatus','Publish Status'


			SELECT @RowsCount AS RowsCount;

			
			
			
			
			
			
			
			
			
			
			
			
			 --SELECT zpp.PimProductid AS ProductId,
    --                [ProductName],
    --                ProductType,
    --                ISNULL(zf.FamilyName, '') AS AttributeFamily,
    --                [SKU],
    --                [Price],
    --                [Quantity],
    --                CASE
    --                    WHEN [IsActive] IS NULL
    --                    THEN CAST(0 AS BIT)
    --                    ELSE CAST([IsActive] AS BIT)
    --                END AS [IsActive],
    --                PimLinkProductDetailId,
    --                RelatedProductId,
    --                TBLPD.PimAttributeId,
    --                [dbo].FN_GetMediaThumbnailMediaPath(zm.Path) AS ImagePath,
    --                [Assortment],
    --                @LocaleId AS LocaleId,
    --                [DisplayOrder]
    --         FROM @ProductIdTable AS zpp
    --              INNER JOIN @TBL_LinkProductDetail AS TBLPD ON(TBLPD.PimProductId = ZPP.PimProductId)
    --              LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
    --              INNER JOIN
    --         (
    --             SELECT PimProductId,
    --                    AttributeValue,
    --                    AttributeCode
    --             FROM @TBL_AttributeDetails
    --         ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN([ProductName],
    --                                                             [SKU],
    --                                                             [Price],
    --                                                             [Quantity],
    --                                                             [IsActive],
    --                                                             [ProductType],
    --                                                             [ProductImage],
    --                                                             [Assortment],
    --                                                             [DisplayOrder])) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
    --              LEFT JOIN ZnodeMedia AS zm ON(zm.MediaId = piv.[ProductImage])
    --         ORDER BY zpp.RowId;
         END TRY
         BEGIN CATCH
		     
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageLinkProductList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@RelatedProductId='+CAST(@RelatedProductId AS VARCHAR(50))+',@PimAttributeId='+CAST(@PimAttributeId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageLinkProductList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;   


         --
GO
PRINT N'Altering [dbo].[Znode_ManageProductTypeAssociationList]...';


GO

IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ManageProductTypeAssociationList' )
BEGIN
	DROP PROCEDURE Znode_ManageProductTypeAssociationList
END
GO
CREATE PROCEDURE [dbo].[Znode_ManageProductTypeAssociationList]
(   @WhereClause      NVARCHAR(MAX) = '',
    @Rows             INT           = 10,
    @PageNo           INT           = 1,
    @Order_BY         VARCHAR(1000) = '',
    @RelatedProductId INT           = 0,
    @IsAssociated     BIT           = 0,
    @RowsCount        INT OUT,
    @LocaleId         INT           = 1)
AS
/*
Summary: This Procedure is used to manage Product association
Unit Testing :
 EXEC [Znode_ManageProductTypeAssociationList] '', @RowsCount = 0,@RelatedProductId = 44
*/
     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @SQL NVARCHAR(MAX), @AlternetOrderBy NVARCHAR(2000),@OutPimProductIds VARCHAR(max);
             DECLARE @DefaultLocaleId INT= Dbo.Fn_GetDefaultValue('Locale');
             DECLARE @DefaultAttributeFamily INT= Dbo.Fn_GetDefaultValue('PimFamily');
			 DECLARE @ProductIdTable TABLE (  PimProductId int, CountId int, RowId int IDENTITY(1,1));
			 DECLARE @ProductAttributeDetials TABLE ( PimProductId int, AttributeCode nvarchar(600), AttributeValue nvarchar(max), LocaleId int);
			 DECLARE @OrderByDisplay INT= 0;
			 DECLARE @ProductFinalDetails TABLE( PimProductId int, ProductName nvarchar(max), SKU nvarchar(max));             
			 DECLARE @PimProductId VARCHAR(MAX)= '';
             DECLARE @TransferPimProductId TransferId 
			 DECLARE @TBL_PimMediaAttributeId TABLE (PimAttributeId INT ,AttributeCode VARCHAR(600))
			 INSERT INTO @TBL_PimMediaAttributeId (PimAttributeId,AttributeCode)
			 SELECT PimAttributeId,AttributeCode FROM Dbo.Fn_GetProductMediaAttributeId ()

			 IF @Order_BY LIKE '%DisplayOrder%'
             BEGIN
                SET @OrderByDisplay = 1;
             END;

            INSERT INTO @TransferPimProductId 
			SELECT PimProductId
			FROM ZnodePimProductTypeAssociation 
			WHERE PimParentProductId = @RelatedProductId
            ORDER BY CASE WHEN @Order_By LIKE '% DESC%' THEN CASE WHEN @OrderByDisplay = 1 THEN DisplayOrder ELSE 1 END ELSE 1 END DESC,
                    CASE WHEN @Order_By LIKE '% ASC%'  THEN CASE WHEN @OrderByDisplay = 1 THEN DisplayOrder ELSE 1 END ELSE 1 END
					
					
								
			
            EXEC Znode_GetProductIdForPaging
                  @whereClauseXML = @WhereClause,
                  @Rows = @Rows,
                  @PageNo = @PageNo,
                  @Order_BY = @Order_BY,
                  @RowsCount = @RowsCount OUT,
                  @LocaleId = @LocaleId,
                  @AttributeCode = '',
                  @PimProductId = @TransferPimProductId,
                  @IsProductNotIn = @IsAssociated,
				  @OutProductId = @OutPimProductIds OUT
				  ;
	
			 INSERT INTO @ProductIdTable
             (PimProductId) 
			 SELECT item 
			 FROM dbo.split(@OutPimProductIds,',') SP            
       


			 DECLARE @PimProductIds VARCHAR(MAX)= SUBSTRING((SELECT ','+CAST(PimProductId AS VARCHAR(100)) FROM @ProductIdTable FOR XML PATH('')), 2, 4000);
			 DECLARE @DefaultAttributeCode VARCHAR(MAX)= SUBSTRING( (SELECT ','+AttributeCode  FROM [dbo].[Fn_GetProductGridAttributes]() FOR XML PATH ('') ),2,4000);
            
             
			 DECLARE @TBL_AttributeDetails AS TABLE (PimProductId int, AttributeValue nvarchar(max), AttributeCode varchar(600), PimAttributeId int);

			 DECLARE @TBL_AttributeCode TABLE (PimAttributeId int, AttributeCode varchar(300));

			 INSERT INTO @TBL_AttributeCode( PimAttributeId, AttributeCode )
			 SELECT PimAttributeId, AttributeCode FROM ZnodePimAttribute AS ZPA WHERE EXISTS ( SELECT TOP 1 1 FROM dbo.split( @DefaultAttributeCode, ',' ) AS SP WHERE Sp.Item = ZPA.AttributeCode );
             DECLARE @TBL_AttributeDefaultValue TABLE (PimAttributeId INT, AttributeDefaultValueCode VARCHAR(100), IsEditable BIT,AttributeDefaultValue NVARCHAR(MAX),DisplayOrder INT);
             DECLARE @PimAttributeId VARCHAR(MAX);
             SET @PimAttributeId = SUBSTRING((SELECT ','+CAST(TBAC.PimAttributeId AS VARCHAR(50)) FROM @TBL_AttributeCode TBAC
                                                     INNER JOIN ZnodePimAttributeDefaultValue ZPADV ON(ZPADV.PimAttributeId = TBAC.PimAttributeId)FOR XML PATH('')), 2, 4000);
			 
			 INSERT INTO @TBL_AttributeDetails( PimProductId, AttributeValue, AttributeCode, PimAttributeId )
			 EXEC Znode_GetProductsAttributeValue @PimProductIds, @DefaultAttributeCode, @LocaleId;  
			 
			 INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT a.PimProductId ,CASE WHEN IsProductPublish = 1 THEN   'Published' WHEN IsProductPublish = 0 THEN 'Draft'  ELSE 'Not Published' END, 'PublishStatus',NULL
			FROM @ProductIdTable a 
			INNER JOIN ZnodePimProduct b ON (b.PimProductId = a.PimProductId)


             DECLARE @FamilyDetails TABLE
             (PimProductId         INT,
              PimAttributeFamilyId INT,
              FamilyName           NVARCHAR(3000)
             );
             INSERT INTO @FamilyDetails
             (PimAttributeFamilyId,
              PimProductId
             )
             EXEC [dbo].[Znode_GetPimProductAttributeFamilyId]
                  @PimProductIds,
                  1; 
             -- find the product families  
			 ;WITH Cte_ProductMedia
               AS (SELECT TBA.PimProductId , TBA.PimAttributeId 
			   , SUBSTRING( ( SELECT ','+URL+ZMSM.ThumbnailFolderName+'/'+ zm.PATH 
			   FROM ZnodeMedia AS ZM
               INNER JOIN ZnodeMediaConfiguration ZMC  ON (ZM.MediaConfigurationId = ZMC.MediaConfigurationId)
			   INNER JOIN ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMC.MediaServerMasterId)
			   INNER JOIN @TBL_AttributeDetails AS TBAI ON (TBAI.AttributeValue  = CAST(ZM.MediaId AS VARCHAR(50)) )
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBAI.PimATtributeId)
			   WHERE TBAI.PimProductId = TBA.PimProductId AND TBAI.PimAttributeId = TBA.PimAttributeId 
			   FOR XML PATH('') ), 2 , 4000) AS AttributeValue 
			   FROM @TBL_AttributeDetails AS TBA 
			   INNER JOIN  @TBL_PimMediaAttributeId AS FNMA ON (FNMA.PImAttributeId = TBA.PimATtributeId ))
                          
		      UPDATE TBAV SET AttributeValue = CTPM.AttributeVALue
			  FROM @TBL_AttributeDetails TBAV 
			  INNER JOIN Cte_ProductMedia CTPM ON CTPM.PimProductId = TBAV.PimProductId  AND CTPM.PimAttributeId = TBAV.PimAttributeId 
			  AND CTPM.PimAttributeId = TBAV.PimAttributeId;

			  

             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @LocaleId);
             UPDATE a
               SET
                   FamilyName = b.AttributeFamilyName
             FROM @FamilyDetails a
                  INNER JOIN ZnodePimFamilyLocale b ON(a.PimAttributeFamilyId = b.PimAttributeFamilyId
                                                       AND LocaleId = @DefaultLocaleId)
             WHERE a.FamilyName IS NULL
                   OR a.FamilyName = '';
			
			INSERT INTO @TBL_AttributeDetails             (PimProductId,              AttributeValue,              AttributeCode,              PimAttributeId             )
			SELECT PimProductId ,FamilyName, 'AttributeFamily',NULL
			FROM @FamilyDetails 
				
				-- LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
             --- Update the  product families name locale wise   
        UPDATE  @TBL_AttributeDetails SET PimAttributeId = 0 WHERE PimAttributeId IS nULL 
	     DECLARE @ProductXML XML 

		-- SELECT * FROM @TBL_AttributeDetails

	   	 SET @ProductXML =   '<MainProduct>'+ STUFF( (  SELECT '<Product>'
		                                                    +'<PimProductTypeAssociationId>'+CAST(ISNULL(ZPTA.PimProductTypeAssociationId,'') AS VARCHAR(50))+'</PimProductTypeAssociationId>'
															+'<PimProductId>'+CAST(zpp.PimProductId AS VARCHAR(50))+'</PimProductId>'
															+'<RelatedProductId>'+CAST(ISNULL(ZPTA.PimParentProductId,'') AS VARCHAR(50))+'</RelatedProductId>'
															+'<DisplayOrder>'+CAST(ZPTA.[DisplayOrder] AS VARCHAR(50))+'</DisplayOrder>'

		 + STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST( (SELECT ''+TBADI.AttributeValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
															FROM @TBL_AttributeDetails TBADI      
															 WHERE TBADI.PimProductId = zpp.PimProductId 
															 ORDER BY TBADI.PimProductId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Product>'	   

			 FROM @ProductIdTable AS zpp
             LEFT JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimProductId = Zpp.PimProductId
                                                                    AND ZPTA.PimParentProductId = @RelatedProductId)
             ORDER BY CASE
                          WHEN @Order_By LIKE '% DESC%'
                          THEN CASE
                                   WHEN @OrderByDisplay = 1
                                   THEN ZPTA.DisplayOrder
								   ELSE 1
                               END
                          ELSE 1
                      END DESC,
                      CASE
                          WHEN @Order_By LIKE '% ASC%'
                          THEN CASE
                                   WHEN @OrderByDisplay = 1
                                   THEN ZPTA.DisplayOrder
                                   ELSE 1
                               END
                          ELSE 1
                      END,RowId
			FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainProduct>'
			--FOR XML PATH ('MainProduct'))


			SELECT  @ProductXML  ProductXMl
		   
		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA 
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1  
			 AND  IsCategory = 0 
			 AND ZPA.IsShowOnGrid = 1  
			 UNION ALL 
			 SELECT 'PublishStatus','Publish Status'


			  SELECT @RowsCount AS RowsCount;

			    
	  
	       --  SELECT PimProductTypeAssociationId,
        --            ZPTA.PimParentProductId RelatedProductId,
        --            zpp.PimProductId ProductId,
        --            [ProductName],
        --            ProductType,
        --            ISNULL(zf.FamilyName, '') AS AttributeFamily,
        --            [SKU],
        --            [Price],
        --            [Quantity],
        --            CASE
        --                WHEN [IsActive] IS NULL
        --                THEN CAST(0 AS BIT)
        --                ELSE CAST([IsActive] AS BIT)
        --            END AS [IsActive],
        --            [ProductImage] AS ImagePath,
        --            [Assortment],
        --            @LocaleId AS LocaleId,
        --            ZPTA.[DisplayOrder]
        --     FROM @ProductIdTable AS zpp
        --          LEFT JOIN @FamilyDetails AS zf ON(zf.PimProductId = zpp.PimProductId)
        --          INNER JOIN
        --     (
        --         SELECT PimProductId,
        --                AttributeValue,
        --                AttributeCode
        --         FROM @TBL_AttributeDetails
        --     ) TB PIVOT(MAX(AttributeValue) FOR AttributeCode IN(
								--								 [ProductName],
        --                                                         [SKU],
        --                                                         [Price],
        --                                                         [Quantity],
        --                                                         [IsActive],
        --                                                         [ProductType],
        --                                                         [ProductImage],
        --                                                         [Assortment],
        --                                                         [DisplayOrder]
								--								 )) AS Piv ON(Piv.PimProductId = zpp.PimProductid)
        --          INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimProductId = Zpp.PimProductId
        --                                                            AND ZPTA.PimParentProductId = @RelatedProductId)
             

					   --ORDER BY CASE
        --                  WHEN @Order_By LIKE '% DESC%'
        --                  THEN CASE
        --                           WHEN @OrderByDisplay = 1
        --                           THEN ZPTA.DisplayOrder
								--   ELSE 1
        --                       END
        --                  ELSE 1
        --              END DESC,
        --              CASE
        --                  WHEN @Order_By LIKE '% ASC%'
        --                  THEN CASE
        --                           WHEN @OrderByDisplay = 1
        --                           THEN ZPTA.DisplayOrder
        --                           ELSE 1
        --                       END
        --                  ELSE 1
        --              END,

        --              RowId;

         END TRY
         BEGIN CATCH
               DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageProductTypeAssociationList @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@RelatedProductId='+CAST(@RelatedProductId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageProductTypeAssociationList',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
PRINT N'Creating [dbo].[Znode_ImportProcessData]...';


GO

--EXEC Znode_ImportProcessData 1
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessData' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessData
END
GO
CREATE  PROCEDURE [dbo].[Znode_ImportProcessData] 
(

	@ImportHeadId INT , @TblGUID nvarchar(255),@TouchPointName nvarchar(200) 

)
AS 
BEGIN

	Declare @ERPTaskSchedulerId int 
	SET NOCOUNT ON;
	
	select @ERPTaskSchedulerId = ERPTaskSchedulerId from ZnodeERPTaskScheduler a
	inner join ZnodeERPConfigurator b on(a.ERPConfiguratorId = b.ERPConfiguratorId and TouchPointName = @TouchPointName)


	IF EXISTS ( SELECT ImportHeadId From ZnodeImportHead where ImportHeadId = @ImportHeadId AND Name = 'Product' )
	Begin
		EXEC [dbo].[Znode_ImportProcessProductData] @TblGUID=@TblGUID,@ERPTaskSchedulerId= @ERPTaskSchedulerId
	End
	Else If EXISTS ( SELECT ImportHeadId From ZnodeImportHead where ImportHeadId = @ImportHeadId AND Name = 'Pricing' )
	Begin
		EXEC [dbo].[Znode_ImportProcessPriceData] @TblGUID=@TblGUID,@ERPTaskSchedulerId= @ERPTaskSchedulerId
	End
	Else If EXISTS ( SELECT ImportHeadId From ZnodeImportHead where ImportHeadId = @ImportHeadId AND Name = 'Inventory' )
	Begin
		EXEC [dbo].[Znode_ImportProcessInventoryData] @TblGUID=@TblGUID,@ERPTaskSchedulerId= @ERPTaskSchedulerId
	End

	Else If EXISTS ( SELECT ImportHeadId From ZnodeImportHead where ImportHeadId = @ImportHeadId AND Name IN ( 'ProductAttribute' ))
	Begin
		EXEC [dbo].[Znode_ImportProcessAttributeData] @TblGUID=@TblGUID,@ERPTaskSchedulerId= @ERPTaskSchedulerId
	End
	Else If EXISTS ( SELECT ImportHeadId From ZnodeImportHead where ImportHeadId = @ImportHeadId AND Name in ('CustomerAddress', 'Customer' ))
	Begin
		EXEC [dbo].[Znode_ImportProcessCustomer] @TblGUID=@TblGUID,@ERPTaskSchedulerId= @ERPTaskSchedulerId
	End


END
GO
PRINT N'Altering [dbo].[Znode_ImportValidatePimProductData]...';


GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportValidatePimProductData' )
BEGIN
	DROP PROCEDURE Znode_ImportValidatePimProductData
END
GO
CREATE PROCEDURE [dbo].[Znode_ImportValidatePimProductData]
(   @ImportHeadName     VARCHAR(200),
    @TableName          VARCHAR(200),
    @NewGUID            NVARCHAR(200),
    @TemplateId         INT,
    @UserId             INT,
    @LocaleId           INT           = 1,
    @IsCategory         INT           = 0,
    @DefaultFamilyId    INT           = 0,
    @ImportProcessLogId INT,
    @PriceListId        INT,
	@CountryCode VARCHAR(100) = '',
	@PimCatalogId         INT    = 0 ,
	@PortalId int = 0 )
AS
     SET NOCOUNT ON;

/*
    Summary :   Import PimProduct / Price / Inventory / Category / Category Associated Data 
    Process :   Admin site will upload excel / csv file in database and create global temporary table
				Procedure Znode_ImportValidatePimProductData will validate data with attribute validation rule
				If datatype validation issue found in input daata will logged into table "ZnodeImportLog"
				If Data is correct and record count in table ZnodeImportLog will be 0 then process for import data into Base tables
				To import data call procedure "Znode_ImportPimProductData"
    		  
				SourceColumnName: CSV file column headers
				TargetColumnName: Attributecode from ZnodePimAttribute Table (Consider those Attributecodes configured with default family only)
*/

     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN TRN_ImportValidProductData;
             DECLARE @GetDate DATETIME= dbo.Fn_GetDate();
             DECLARE @SQLQuery NVARCHAR(MAX), @AttributeTypeName NVARCHAR(10), @AttributeCode NVARCHAR(300), @AttributeId INT, @IsRequired BIT, @SourceColumnName NVARCHAR(600), @ControlName VARCHAR(300), @ValidationName VARCHAR(100), @SubValidationName VARCHAR(300), @ValidationValue VARCHAR(300), @RegExp VARCHAR(300), @CreateDateString NVARCHAR(300), @DefaultLocaleId INT, @ImportHeadId INT, @CheckedSourceColumn NVARCHAR(600)= '', @Status BIT= 0,
			    @CsvColumnString nvarchar(max)
             DECLARE @FamilyAttributeDetail TABLE
             (PimAttributeId       INT,
              AttributeTypeName    VARCHAR(300),
              AttributeCode        VARCHAR(300),
              SourceColumnName     NVARCHAR(600),
              IsRequired           BIT,
              PimAttributeFamilyId INT
             );
             DECLARE @AttributeDetail TABLE
             (PimAttributeId    INT,
              AttributeTypeName VARCHAR(300),
              AttributeCode     VARCHAR(300),
              SourceColumnName  NVARCHAR(600),
              IsRequired        BIT,
              ControlName       VARCHAR(300),
              ValidationName    VARCHAR(100),
              SubValidationName VARCHAR(300),
              ValidationValue   VARCHAR(300),
              RegExp            VARCHAR(300)
             );
		
             DECLARE @GlobalTempTableColumns TABLE(ColumnName NVARCHAR);
             IF NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM INFORMATION_SCHEMA.TABLES
                 WHERE INFORMATION_SCHEMA.TABLES.TABLE_NAME = '#InvalidDefaultData'
             )
                 CREATE TABLE #InvalidDefaultData
                 (RowNumber  INT,
                  Value      NVARCHAR(MAX),
                  ColumnName NVARCHAR(600)
                 );
             ELSE
             DROP TABLE #InvalidDefaultData;
             IF NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM INFORMATION_SCHEMA.TABLES
                 WHERE INFORMATION_SCHEMA.TABLES.TABLE_NAME = '#GlobalTempTableColumns'
             )
                 BEGIN

                     SET @SQLQuery = 'SELECT Column_Name, '''+@ImportHeadName+''' AS ImportHeadName  from tempdb.INFORMATION_SCHEMA.COLUMNS	where table_name = object_name(object_id('''+@TableName+'''),
					(select database_id from sys.databases where name = ''tempdb''))';
                     CREATE TABLE #GlobalTempTableColumns
                     (ColumnName   NVARCHAR(MAX),
                      TypeOfImport NVARCHAR(100)
                     );
                     INSERT INTO #GlobalTempTableColumns
                     (ColumnName,
                      TypeOfImport
                     )
                     EXEC sys.sp_sqlexec
                          @SQLQuery;
                 END;
		  -- If Exists ( Select  count(1)  from #GlobalTempTableColumns GROUP BY ColumnName  Having count(1) > 1 )
		  -- Begin
			 --   INSERT INTO ZnodeImportLog(ErrorDescription,ColumnName,Data,GUID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ImportProcessLogId)
    --               Select  46,ColumnName,'',@newGUID,@UserId,@GetDate,@UserId,@GetDate, @ImportProcessLogId  from #GlobalTempTableColumns GROUP BY ColumnName  Having count(1) > 1 
				
				----'Multiple occurance of column are not allow for'
		  -- END

             IF EXISTS
             (
                 SELECT TOP 1 1
                 FROM #GlobalTempTableColumns
                 WHERE ColumnName IN('PimCategoryId', 'PimProductId', 'RowNumber')
             )
                 BEGIN
                     INSERT INTO ZnodeImportLog
                     (ErrorDescription,
                      ColumnName,
                      Data,
                      GUID,
                      CreatedBy,
                      CreatedDate,
                      ModifiedBy,
                      ModifiedDate,
                      ImportProcessLogId
                     )
                     VALUES
                     (43,
                      '',
                      '',
                      @newGUID,
                      @UserId,
                      @GetDate,
                      @UserId,
                      @GetDate,
                      @ImportProcessLogId
                     );
                 END;
             SET @DefaultLocaleId = dbo.Fn_GetDefaultLocaleId();
             --Remove old error log 
             --DELETE FROM ZnodeImportLog WHERE ImportProcessLogId in (select ImportProcessLogId  FROM ZnodeImportProcessLog  WHERE ImportTemplateId  = @TemplateId )
             --GUID = @NewGUID;
             --Delete FROM ZnodeImportProcessLog  WHERE ImportTemplateId  = @TemplateId 
		
             IF NOT EXISTS
             (
                 SELECT TOP 1 1  FROM ZnodeImportLog
                 WHERE Guid = @NewGUID
                       AND ErrorDescription IN(43, 42)
                 AND ImportProcessLogId = @ImportProcessLogId
             )
                 BEGIN
                     IF @ImportHeadName = 'Product'
                      BEGIN
						  IF @@VERSION LIKE '%Azure%' OR @@VERSION LIKE '%Express Edition%'
							  SET @SQLQuery = 'Alter table '+@TableName+' Add  RowNumber BIGINT Identity(1,1),PimProductId int null ';
						  ELSE 
							 SET @SQLQuery = 'Alter table '+@TableName+' Add  RowNumber BIGINT Identity(1,1),PimProductId int null Primary KEY CLUSTERED(RowNumber)';
						 
						  EXEC sys.sp_sqlexec @SQLQuery;
			         END;
                     ELSE
                     IF @ImportHeadName = 'Category'
                         BEGIN
							  IF @@VERSION LIKE '%Azure%' OR @@VERSION LIKE '%Express Edition%'
								SET @SQLQuery = 'Alter table '+@TableName+' Add  RowNumber BIGINT Identity(1,1),PimCategoryId int null ';
							  ElSE
								SET @SQLQuery = 'Alter table '+@TableName+' Add  RowNumber BIGINT Identity(1,1),PimCategoryId int null Primary KEY CLUSTERED(RowNumber) ';
						  
							  EXEC sys.sp_sqlexec @SQLQuery;
                         END;
                     ELSE
                         BEGIN
							IF @@VERSION LIKE '%Azure%' OR @@VERSION LIKE '%Express Edition%'
								SET @SQLQuery = 'Alter table '+@TableName+' Add  RowNumber BIGINT Identity(1,1) ';
							Else 
								SET @SQLQuery = 'Alter table '+@TableName+' Add  RowNumber BIGINT Identity(1,1) Primary KEY CLUSTERED(RowNumber)';
							
							EXEC sys.sp_sqlexec @SQLQuery;
                         END;;
                 END;
				
             --Generate new process for current import 
             --INSERT INTO ZnodeImportProcessLog(ImportTemplateId,Status,ProcessStartedDate,ProcessCompletedDate,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
             --SELECT @TemplateId,dbo.Fn_GetImportStatus(0),@GetDate,NULL,@UserId,@GetDate,@UserId,@GetDate;
             --SET @ImportProcessLogId = @@IDENTITY;

             SET @CreateDateString = CONVERT(VARCHAR(100), @UserId)+','''+CONVERT(VARCHAR(100), @GetDate)+''','+CONVERT(VARCHAR(100), @UserId)+','''+CONVERT(VARCHAR(100), @GetDate)+''', '+CONVERT(VARCHAR(100), @ImportProcessLogId);

             SELECT TOP 1 @ImportHeadId = ImportHeadId FROM ZnodeImportTemplate WHERE ImportTemplateId = @TemplateId;
             IF @DefaultFamilyId = 0
                AND @ImportHeadName IN('Product', 'Category')
                 BEGIN 
                     --Get all default attribute values in attribute 
                     INSERT INTO @FamilyAttributeDetail
                     (PimAttributeId,
                      AttributeTypeName,
                      AttributeCode,
                      SourceColumnName,
                      IsRequired,
                      PimAttributeFamilyId
                     )
                     --Call Process to insert data of defeult family with source column name and target column name 
                     EXEC Znode_ImportGetTemplateDetails
                          @TemplateId = @TemplateId,
                          @IsValidationRules = 0,
                          @IsIncludeRespectiveFamily = 1,
                          @IsCategory = @IsCategory,
                          @DefaultFamilyId = @DefaultFamilyId;
                 END;
             ELSE
             IF @ImportHeadName IN('Product', 'Category')
                 BEGIN
                     --Get all default attribute values in attribute 
                     INSERT INTO @FamilyAttributeDetail
                     (PimAttributeId,
                      AttributeTypeName,
                      AttributeCode,
                      SourceColumnName,
                      IsRequired,
                      PimAttributeFamilyId
                     )
                     --Call Process to insert data of defeult family with source column name and target column name 
                     EXEC Znode_ImportGetTemplateDetails
                          @TemplateId = @TemplateId,
                          @IsValidationRules = 0,
                          @IsIncludeRespectiveFamily = 1,
                          @IsCategory = @IsCategory,
                          @DefaultFamilyId = @DefaultFamilyId;
                 END;      
             -- Check attributes are manditory and not provided with source table
		   	 
			if @TABLENAME	like '%tempdb..%'
				SET @SQLQuery = 'SELECT 42 AS ErrorDescription , SourceColumnName , '''' , '''+@NewGUID+''','+@CreateDateString+' from ZnodeImportTemplateMapping where ImportTemplateId = '+CONVERT(VARCHAR(100), @TemplateId)+' and ltrim(rtrim(SourceColumnName)) <> '''' AND ltrim(rtrim(SourceColumnName)) not in ( select isnull(Name ,'''') from tempdb.sys.columns where object_id = object_id('''+@TABLENAME+'''));';
			else 
				SET @SQLQuery = 'SELECT 42 AS ErrorDescription , SourceColumnName , '''' , '''+@NewGUID+''','+@CreateDateString+' from ZnodeImportTemplateMapping where ImportTemplateId = '+CONVERT(VARCHAR(100), @TemplateId)+' and ltrim(rtrim(SourceColumnName)) <> '''' AND ltrim(rtrim(SourceColumnName)) not in ( select isnull(Name ,'''') from sys.columns where object_id = object_id('''+@TABLENAME+'''));';
		 
			Declare @Tbl_CsvDynamicColulmns TABLE (ColumnName nvarchar(300), SequenceNumber int, DataType nvarchar(50),IsRequired bit )

			INSERT INTO @Tbl_CsvDynamicColulmns(ColumnName , SequenceNumber , DataType ,IsRequired)
			SELECT DISTINCT ZITM.SourceColumnName ,ZIAV.SequenceNumber, ZIAV.AttributeTypeName, ZIAV.IsRequired
			FROM ZnodeImportAttributeValidation ZIAV LEFT OUTER JOIN 
			ZnodeImportTemplate  ZIT ON ZIT.ImportHeadId =  ZIAV.ImportHeadId AND ZIT.ImportTemplateId  = @TemplateId
			LEFT OUTER JOIN ZnodeImportTemplateMapping  ZITM ON ZITM.ImportTemplateId = ZIT.ImportTemplateId  
			and ZIAV.AttributeCode = ZITM.TargetColumnName
			AND ZITM.ImportTemplateId  = @TemplateId
			WHERE ZIAV.ImportHeadId = @ImportHeadId --ORDER BY ZIAV.SequenceNumber

		    SELECT @CsvColumnString = SUBSTRING ((Select ',' +  ISNULL(ColumnName ,'NULL') from @Tbl_CsvDynamicColulmns ORDER BY SequenceNumber FOR XML PATH ('')),2,4000) 


     		INSERT INTO ZnodeImportLog(ErrorDescription, ColumnName, Data, GUID,CreatedBy, CreatedDate,  ModifiedBy,ModifiedDate,ImportProcessLogId
             )
             EXEC sys.sp_sqlexec  @SQLQuery;
             IF NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM ZnodeImportLog
                 WHERE Guid = @NewGUID
                       AND ErrorDescription IN(43, 42)
                 AND ImportProcessLogId = @ImportProcessLogId
             )
                 BEGIN
                     --Get all default attribute values in attribute 
                     IF @ImportHeadName IN('Product', 'Category')
                         BEGIN
                             -- Check attributes are manditory and not provided with source table
                             INSERT INTO ZnodeImportLog
                             (ErrorDescription,
                              ColumnName,
                              Data,
                              GUID,
                              CreatedBy,
                              CreatedDate,
                              ModifiedBy,
                              ModifiedDate,
                              ImportProcessLogId
                             )
                                    SELECT '14' AS ErrorDescription,
                                           AttributeCode,
                                           '',
                                           @NewGUID,
                                           @UserId,
                                           @GetDate,
                                           @UserId,
                                           @GetDate,
                                           @ImportProcessLogId
                                    FROM @FamilyAttributeDetail
                                    WHERE ISNULL(SourceColumnName, '') = ''
                                          AND IsRequired = 1;  

                             -- Read all attribute details with their datatype
                             INSERT INTO @AttributeDetail
                             (PimAttributeId,
                              AttributeTypeName,
                              AttributeCode,
                              SourceColumnName,
                              IsRequired,
                              ControlName,
                              ValidationName,
                              SubValidationName,
                              ValidationValue,
                              RegExp
                             )
                             EXEC Znode_ImportGetTemplateDetails
                                  @TemplateId;
                             DELETE FROM @AttributeDetail
                             WHERE AttributeTypeName = 'Image'
                                   AND ValidationName <> 'IsAllowMultiUpload';
                             IF NOT EXISTS
                             (
                                 SELECT TOP 1 1
                                 FROM INFORMATION_SCHEMA.TABLES
                                 WHERE INFORMATION_SCHEMA.TABLES.TABLE_NAME = '#DefaultAttributeCode'
                             )
                                 BEGIN
                                     CREATE TABLE #DefaultAttributeCode
                                     (AttributeTypeName          VARCHAR(300),
                                      PimAttributeDefaultValueId INT,
                                      PimAttributeId             INT,
                                      AttributeDefaultValueCode  VARCHAR(100)
                                     );
                                     INSERT INTO #DefaultAttributeCode
                                     (AttributeTypeName,
                                      PimAttributeDefaultValueId,
                                      PimAttributeId,
                                      AttributeDefaultValueCode
                                     )
                                     --Call Process to insert default data value 
                                     EXEC Znode_ImportGetPimAttributeDefaultValue;
                                     DELETE FROM #DefaultAttributeCode
                                     WHERE AttributeTypeName = 'Yes/No';
                                 END;
                             ELSE
                                 BEGIN
                                     DROP TABLE #DefaultAttributeCode;
                                 END;
                         END;
                     ELSE
                         BEGIN
					
					
                             --Read all attribute details with their datatype
                             INSERT INTO @AttributeDetail
                             (AttributeTypeName,
                              AttributeCode,
                              SourceColumnName,
                              IsRequired,
                              ControlName,
                              ValidationName,
                              SubValidationName,
                              ValidationValue,
                              RegExp
                             )
                             EXEC [Znode_ImportGetOtherTemplateDetails]
                                  @TemplateId = @TemplateId,
                                  @ImportHeadId = @ImportHeadId;
						
                             --Check attributes are not mapped with any family of Pim Product
                             INSERT INTO ZnodeImportLog
                             (ErrorDescription,
                              ColumnName,
                              Data,
                              GUID,
                              CreatedBy,
                              CreatedDate,
                              ModifiedBy,
                              ModifiedDate,
                              ImportProcessLogId
                             )
                                    SELECT DISTINCT
                                           '14' AS ErrorDescription,
                                           AttributeCode,
                                           '',
                                           @NewGUID,
                                           @UserId,
                                           @GetDate,
                                           @UserId,
                                           @GetDate,
                                           @ImportProcessLogId
                                    FROM @AttributeDetail
                                    WHERE ISNULL(SourceColumnName, '') = ''   AND IsRequired = 1;  ;

                         END;
						
                     --	Check attributes are not mapped with (Default / Other) family of Pim Product
                     --	INSERT INTO ZnodeImportLog ( ErrorDescription , ColumnName , Data , GUID , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate , ImportProcessLogId)
                     --	SELECT '1' AS ErrorDescription , SourceColumnName , '' , @NewGUID , @UserId , @GetDate , @UserId , @GetDate , @ImportProcessLogId
                     --	FROM @AttributeDetail WHERE PimAttributeId NOT IN ( SELECT zpfgm.PimAttributeId FROM dbo.ZnodePimFamilyGroupMapper AS zpfgm);
                     --	Verify data in global temporary table (column wise)
					
                     DECLARE Cr_Attribute CURSOR LOCAL FAST_FORWARD
                     FOR SELECT PimAttributeId,
                                AttributeTypeName,
                                AttributeCode,
                                IsRequired,
                                SourceColumnName,
                                ControlName,
                                ValidationName,
                                SubValidationName,
                                ValidationValue,
                                RegExp
                         FROM @AttributeDetail
                         WHERE ISNULL(SourceColumnName, '') <> '';
                     OPEN Cr_Attribute;
                     FETCH NEXT FROM Cr_Attribute INTO @AttributeId, @AttributeTypeName, @AttributeCode, @IsRequired, @SourceColumnName, @ControlName, @ValidationName, @SubValidationName, @ValidationValue, @RegExp;
                     WHILE @@FETCH_STATUS = 0
                         BEGIN
				             IF @AttributeTypeName = 'Number'
                                 BEGIN
							      EXEC Znode_ImportValidateNumber
                                          @TableName = @TableName,
                                          @SourceColumnName = @SourceColumnName,
                                          @CreateDateString = @CreateDateString,
                                          @ValidationName = @ValidationName,
                                          @ControlName = @ControlName,
                                          @ValidationValue = @ValidationValue,
                                          @NewGUID = @NewGUID,
                                          @ImportHeadId = @ImportHeadId,
                                          @ImportProcessLogId = @ImportProcessLogId;
                                 END;
							 -- Check invalid date
							
                             IF @AttributeTypeName = 'Date'
                                 BEGIN
                                     EXEC Znode_ImportValidateDate
                                          @TableName = @TableName,
                                          @SourceColumnName = @SourceColumnName,
                                          @CreateDateString = @CreateDateString,
                                          @ValidationName = @ValidationName,
                                          @ControlName = @ControlName,
                                          @ValidationValue = @ValidationValue,
                                          @NewGUID = @NewGUID,
                                          @ImportHeadId = @ImportHeadId,
                                          @ImportProcessLogId = @ImportProcessLogId;
                                 END;
							 -- Check Manditory Data
		 					 IF @IsRequired = 1 AND @CheckedSourceColumn <> @SourceColumnName
								BEGIN
									SET @CheckedSourceColumn = @SourceColumnName;
									EXEC Znode_ImportValidateManditoryData
									@TableName = @TableName,
									@SourceColumnName = @SourceColumnName,
									@CreateDateString = @CreateDateString,
									@ValidationName = @ValidationName,
									@ControlName = @ControlName,
									@ValidationValue = @ValidationValue,
									@NewGUID = @NewGUID,
									@ImportHeadId = @ImportHeadId;
								END;
							 --END 
							
                             IF @AttributeTypeName = 'Text'
                                 BEGIN
								 
						              EXEC Znode_ImportValidateManditoryText
                                          @TableName = @TableName,
                                          @SourceColumnName = @SourceColumnName,
                                          @CreateDateString = @CreateDateString,
                                          @ValidationName = @ValidationName,
                                          @ControlName = @ControlName,
                                          @ValidationValue = @ValidationValue,
                                          @NewGUID = @NewGUID,
                                          @LocaleId = @LocaleId,
                                          @DefaultLocaleId = @DefaultLocaleId,
                                          @AttributeId = @AttributeId,
                                          @ImportProcessLogId = @ImportProcessLogId,
                                          @ImportHeadId = @ImportHeadId;
                                 END;
                             IF @AttributeTypeName = 'Image'
                                 BEGIN
                                     EXEC Znode_ImportValidateImageData
                                          @TableName = @TableName,
                                          @SourceColumnName = @SourceColumnName,
                                          @CreateDateString = @CreateDateString,
                                          @ValidationName = @ValidationName,
                                          @ControlName = @ControlName,
                                          @ValidationValue = @ValidationValue,
                                          @NewGUID = @NewGUID,
                                          @LocaleId = @LocaleId,
                                          @DefaultLocaleId = @DefaultLocaleId,
                                          @AttributeId = @AttributeId,
                                          @ImportProcessLogId = @ImportProcessLogId,
                                          @ImportHeadId = @ImportHeadId;
                                 END;
                             --Check Default data value is valid 
                             IF @ImportHeadName IN('Product', 'Category')
                                 BEGIN
                                     IF @AttributeId IN
                                     (
                                         SELECT PimAttributeId
                                         FROM #DefaultAttributeCode
                                     )
                                         BEGIN
							
                                                   ---Verify Image file is exists in media table or not 
                                             SET @SQLQuery = ' INSERT INTO #InvalidDefaultData (RowNumber, Value, ColumnName) 
                                             SELECT ROWNUMBER , (Select TOP 1 Item from dbo.split(' + @SourceColumnName + ','','')  SP WHERE NOT EXISTS 
                                             (Select ToP 1 1 FROM #DefaultAttributeCode DAC WHERE 
                                              DAC.AttributeTypeName <> ''Yes/No'' AND DAC.AttributeDefaultValueCode IS NOT NULL AND DAC.PimAttributeId = 
                                             ' + CONVERT(VARCHAR(100), @AttributeId) + ' AND ltrim(rtrim(SP.Item) ) = DAC.AttributeDefaultValueCode
                                             )), ''' + @SourceColumnName + ''' as [ColumnName]  FROM ' + @TableName
                                             + ' Where ISnull(' + @SourceColumnName +  ','''') <> '''''

						
                                             EXEC sys.sp_sqlexec @SQLQuery;
                                             -- Check Invalid Image 
                                             
											 SET @SQLQuery = 'SELECT ''9 '' ErrorDescription,'''+@SourceColumnName+''' as [ColumnName], 
                                             Value AS  AttributeValue,RowNumber ,'''+@NewGUID+''',  '+@CreateDateString+' FROM #InvalidDefaultData Where Value IS NOT NULL'
                                             INSERT INTO ZnodeImportLog (ErrorDescription, ColumnName, Data, RowNumber, GUID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ImportProcessLogId)
                                             EXEC sys.sp_sqlexec @SQLQuery;

											 Delete from #InvalidDefaultData

       
                                         END;
                                 END;
							
                             FETCH NEXT FROM Cr_Attribute INTO @AttributeId, @AttributeTypeName, @AttributeCode, @IsRequired, @SourceColumnName, @ControlName, @ValidationName, @SubValidationName, @ValidationValue, @RegExp;
                         END;
                     CLOSE Cr_Attribute;
                     DEALLOCATE Cr_Attribute;
                     --SELECT top 1 1 FROM @FamilyAttributeDetail where  iSNULL(SourceColumnName,'') = ''  and IsRequired = 1
                 END;
             COMMIT TRAN TRN_ImportValidProductData;
			 
		
			 
  			 SET @SQLQuery = 'Delete FROM  '+@TableName+' Where Rownumber in (Select Rownumber from ZnodeImportLog  WHERE ImportProcessLogId = '+CONVERT(VARCHAR(100), @ImportProcessLogId)+' AND Rownumber is not null)';
             EXEC sys.sp_sqlexec  @SQLQuery;
			 

			 --SET @SQLQuery = 'Select * FROM  '+@TableName
    --         EXEC sys.sp_sqlexec  @SQLQuery;
	  
             IF @ImportHeadName IN('Product', 'Category')
                 BEGIN
                     IF NOT EXISTS
                     (
                         SELECT TOP 1 1
                         FROM @FamilyAttributeDetail
                         WHERE ISNULL(SourceColumnName, '') = ''
                               AND IsRequired = 1
                     ) AND NOT EXISTS
					 (
						 SELECT TOP 1 1
						 FROM ZnodeImportLog
						 WHERE Guid = @NewGUID
							   AND ErrorDescription IN(43, 42)
						 AND ImportProcessLogId = @ImportProcessLogId
					 )
                         BEGIN
                             IF @IsCategory = 0
                                 BEGIN
			
                                     EXEC Znode_ImportPimProductData
                                          @TableName = @TableName,
                                          @NewGUID = @NewGUID,
                                          @TemplateId = @TemplateId,
                                          @ImportProcessLogId = @ImportProcessLogId,
                                          @UserId = @UserId,
                                          @LocaleId = @LocaleId,
                                          @DefaultFamilyId = @DefaultFamilyId;

                                 END;
                             ELSE
                                 BEGIN
                                     EXEC Znode_ImportPimCategoryData
                                          @TableName = @TableName,
                                          @NewGUID = @NewGUID,
                                          @TemplateId = @TemplateId,
                                          @ImportProcessLogId = @ImportProcessLogId,
                                          @UserId = @UserId,
                                          @LocaleId = @LocaleId,
                                          @DefaultFamilyId = @DefaultFamilyId;
                                 END;
                         END;
                 END;
				IF NOT EXISTS
					 (
						 SELECT TOP 1 1
						 FROM ZnodeImportLog
						 WHERE Guid = @NewGUID
							   AND ErrorDescription IN(43, 42)
						 AND ImportProcessLogId = @ImportProcessLogId
					 )
             BEGIN
                 IF @ImportHeadName = 'Pricing'
                     BEGIN
                         EXEC [Znode_ImportPriceList]
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID,
                              @PriceListId = @PriceListId;
                     END;

                 IF @ImportHeadName = 'Inventory'
                     BEGIN
				
                         EXEC Znode_ImportInventory_Ver1
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID;
                     END;
                 IF @ImportHeadName = 'ZipCode'
                     BEGIN
						 EXEC Znode_ImportZipCode
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID,
							  @CountryCode = @CountryCode;
                     END;
					 IF @ImportHeadName = 'CategoryAssociation'
                     BEGIN
						 EXEC Znode_ImportCatalogCategory
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID,
							  @PimCatalogId = @PimCatalogId;
                     END;
					 IF @ImportHeadName = 'ProductAssociation'
                     BEGIN
						 EXEC Znode_ImportAssociateProducts
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID
                     END;
			
					 IF @ImportHeadName = 'SEODetails' AND @PortalId > 0 
                     BEGIN
						 EXEC Znode_ImportSEODetails
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
							  @LocaleId = @LocaleId,
							  @PortalId =@PortalId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID,
							  @CsvColumnString = @CsvColumnString 

				
                     END;
				
					 IF @ImportHeadName = 'ProductAttribute' 
                     BEGIN
						 EXEC Znode_ImportAttributes
                              @TableName = @TableName,
                              @Status = @Status,
                              @UserId = @UserId,
							  @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID = @NewGUID
				
                     END;

					 IF @ImportHeadName = 'Customer' AND @PortalId > 0 
                     BEGIN
						 EXEC Znode_ImportCustomer
                              @TableName = @TableName,
                              @Status	 = @Status,
                              @UserId	 = @UserId,
							  @LocaleId	 = @LocaleId,
							  @PortalId  = @PortalId,
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID	 = @NewGUID,
							  @CsvColumnString =@CsvColumnString
				
                     END;

					 IF @ImportHeadName = 'CustomerAddress' --AND @PortalId > 0 
                     BEGIN
						 EXEC Znode_ImportCustomerAddress
                              @TableName = @TableName,
                              @Status	 = @Status,
                              @UserId	 = @UserId,
							  @LocaleId	 = @LocaleId,
							  @PortalId  = 1, -- not implemented from forntend 
                              @ImportProcessLogId = @ImportProcessLogId,
                              @NewGUID	 = @NewGUID,
							  @CsvColumnString =@CsvColumnString
				
                     END;
 
				 
             END;

             EXEC Znode_ImportReadErrorLog
                  @ImportProcessLogId = @ImportProcessLogId,
                  @NewGUID = @NewGUID;
             DROP TABLE #GlobalTempTableColumns;

             -- Finally call product insert process if error not found in error log table 
             IF EXISTS
             (
                 SELECT TOP 1 1
                 FROM ZnodeImportLog
                 WHERE ImportProcessLogId = @ImportProcessLogId
                       AND Guid = @NewGUID
             )
                 BEGIN
                     --Update process with completed status for current import 
                     UPDATE ZnodeImportProcessLog
                       SET
                           Status = dbo.Fn_GetImportStatus(3),
                           ProcessCompletedDate = @GetDate
                       WHERE ImportProcessLogId = @ImportProcessLogId;
                 END;
				 SET @SQLQuery = 'Drop Table ' + @TableName
               --  EXEC sys.sp_sqlexec @SQLQuery;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE(),
                    ERROR_LINE(),
                    ERROR_PROCEDURE();
             EXEC Znode_ImportReadErrorLog
                  @ImportProcessLogId = @ImportProcessLogId,
                  @NewGUID = @NewGUID; 
             --Update process with failed status for current import 
             UPDATE ZnodeImportProcessLog
               SET
                   Status = dbo.Fn_GetImportStatus(3),
                   ProcessCompletedDate = @GetDate
             WHERE ImportProcessLogId = @ImportProcessLogId;
			 				 SET @SQLQuery = 'Drop Table ' + @TableName
                 EXEC sys.sp_sqlexec @SQLQuery;
             ROLLBACK TRAN TRN_ImportValidProductData;
         END CATCH;
     END;
GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetQuoteOrderTemplateDetail' )
BEGIN
	DROP PROCEDURE Znode_GetQuoteOrderTemplateDetail
END
GO
CREATE PROCEDURE [dbo].[Znode_GetQuoteOrderTemplateDetail]
(   @WhereClause NVARCHAR(MAX),
	@Rows        INT           = 100,
	@PageNo      INT           = 1,
	@Order_BY    VARCHAR(100)  = '',
	@UserId		 INT,										 
	@RowsCount   INT OUT)
AS 
    /*
		 Summary :- this procedure is used to find QuoteOrderTemplate details 
	     SELECT * FROM ZnodeUser  WHERE AspNeTUSerId = 'ae464cfc-95d3-40de-bf71-47993fabb41f'
		 SELECT * FROM AspNetUserRoles WHERE RoleID = 'A529A670-F446-45EC-BBCB-C00D64D7C964' Userid = '50fe1032-e810-4606-b522-ebf1559e81cf'
		 SELECT * FROM AspNetRoles WHERE ID = '8622E90D-7652-41E7-8563-5DED4CC671DE'

		 Unit Testing 
		 EXEC Znode_GetQuoteOrderTemplateDetail '',@RowsCount = 0, @Order_BY = '', @UserId = 85
	*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @SQL NVARCHAR(MAX);
			 DECLARE @TBL_QuoteOrderTemplate TABLE (OmsTemplateId INT,PortalId INT,UserId INT,TemplateName NVARCHAR(1000),CreatedBy INT,CreatedDate DATETIME
			  ,ModifiedBy INT,ModifiedDate DATETIME,Items INT,RowId INT,CountNo INT )
			 DECLARE @AccountId VARCHAR(2000) ,@UsersId VARCHAR(2000), @ProcessType  varchar(50)='Template'
			 -- SELECT * FROM aspnetRoles
			
			SET @UsersId = SUBSTRING (( SELECT ','+CAST(userId AS VARCHAr(50))  FROM Fn_GetRecurciveUserId(@UserId,@ProcessType) FOR XML PATH ('')),2,4000)
			
			 SET @SQL = '
						; WITH CTE_GetOrderTemplate
						  AS (
						       SELECT ZOT.OmsTemplateId,ZOT.PortalId,ZOT.UserId,ZOT.TemplateName,ZOT.CreatedBy,ZOT.CreatedDate,ZOT.ModifiedBy,ZOT.ModifiedDate,SUM(ZOTL.Quantity) Items 
							   FROM ZnodeOmsTemplate ZOT
                               LEFT JOIN ZnodeOmsTemplateLineItem ZOTL ON(ZOTL.OmsTemplateId = ZOT.OmsTemplateId)
							   WHERE ZOT.userid IN ('+@UsersId+') 
							  AND OrderLineItemRelationshipTypeId IS  NULL AND  ParentOmsTemplateLineItemId IS nULL 
                               GROUP BY ZOT.OmsTemplateId,ZOT.PortalId,ZOT.UserId,ZOT.TemplateName,ZOT.CreatedBy,ZOT.CreatedDate,ZOT.ModifiedBy,ZOT.ModifiedDate						  
						  
						     )
						, CTE_GetQuoteOrderDetails AS
						(
						  SELECT DISTINCT  OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items
						  ,'+dbo.Fn_GetPagingRowId(@Order_BY,'OmsTemplateId DESC,UserId')+',Count(*)Over() CountNo
						  FROM CTE_GetOrderTemplate
						   WHERE 1=1 
				          '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'					  
						
						)

						SELECT OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items,RowId,CountNo
						FROM CTE_GetQuoteOrderDetails
						'+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)

						Print @sql
						INSERT INTO @TBL_QuoteOrderTemplate (OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items,RowId,CountNo)
						EXEC(@SQL)

						SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_QuoteOrderTemplate),0)
   
						SELECT OmsTemplateId,PortalId,UserId,TemplateName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Items
						FROM @TBL_QuoteOrderTemplate 


	     END TRY
		 BEGIN CATCH
		 
		     DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetQuoteOrderTemplateDetail @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@UserId= '+CAST(@UserId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetQuoteOrderTemplateDetail',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
		 END CATCH

   END
GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportAssociateProducts' )
BEGIN
	DROP PROCEDURE Znode_ImportAssociateProducts
END

GO 
CREATE  PROCEDURE [dbo].[Znode_ImportAssociateProducts](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @PimCatalogId int= 0)
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import Product Association 
	
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
		DECLARE @InsertProductAssociation TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ParentSKU varchar(300), ChildSKU varchar(200), DisplayOrder int, GUID nvarchar(400)
		);
		
		IF OBJECT_ID('#InsertProduct', 'U') IS NOT NULL 
			DROP TABLE #InsertProduct
		ELSE 
		CREATE TABLE #InsertProduct 
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ParentProductId varchar(300), ChildProductId varchar(200), DisplayOrder int, GUID nvarchar(400)
		);


		DECLARE @CategoryAttributId int;

		DECLARE @InventoryListId int;

		SET @SSQL = 'Select RowNumber,ParentSKU,ChildSKU,DisplayOrder,GUID FROM '+@TableName;
		INSERT INTO @InsertProductAssociation( RowNumber, ParentSKU,ChildSKU,DisplayOrder, GUID )
		EXEC sys.sp_sqlexec @SSQL;


		--@MessageDisplay will use to display validate message for input inventory value  
		DECLARE @SKU TABLE
		( 
						   SKU nvarchar(300), PimProductId int
		);
		INSERT INTO @SKU
			   SELECT b.AttributeValue, a.PimProductId
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;


		-- start Functional Validation 
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'ParentSKU', ParentSKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii
			   WHERE ii.ParentSKU NOT IN
			   (
				   SELECT SKU
				   FROM @SKU
			   );
			INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'ChildSKU', ChildSKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii
			   WHERE ii.ChildSKU NOT IN
			   (
				   SELECT SKU
				   FROM @SKU
			   );

		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  
		DELETE FROM @InsertProductAssociation
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  GUID = @NewGUID
		);

		insert into #InsertProduct (RowNumber,  ParentProductId , ChildProductId , DisplayOrder)
			SELECT RowNumber , SKUParent.PimProductId SKUParentId , 
				   ( Select TOP 1 SKUChild.PimProductId from @SKU AS SKUChild where  SKUChild.SKU = IPAC.ChildSKU ) SKUChildId,
				    DisplayOrder
					FROM @InsertProductAssociation AS IPAC INNER JOIN @SKU AS SKUParent ON IPAC.ParentSKU = SKUParent.SKU 


		INSERT INTO ZnodePimProductTypeAssociation (PimParentProductId, PimProductId, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
		select  ParentProductId , ChildProductId , DisplayOrder, @UserId, @GetDate, @UserId, @GetDate  from #InsertProduct 
		where  NOT Exists (Select TOP 1 1 from ZnodePimProductTypeAssociation where PimParentProductId =  #InsertProduct.ParentProductId
		AND PimProductId = #InsertProduct.ChildProductId )


		--SELECT SKUParent.PimProductId SKUParentId , 
		--		   ( Select TOP 1 SKUChild.PimProductId from @SKU AS SKUChild where  SKUChild.SKU = IPAC.ChildSKU ) SKUChildId,
		--		    DisplayOrder
		--			FROM @InsertProductAssociation AS IPAC INNER JOIN @SKU AS SKUParent ON IPAC.ParentSKU = SKUParent.SKU 



		--	WITH Cte_ProductAssociation
		--		 AS( SELECT SKUParent.PimProductId SKUParentId , 
		--		   ( Select TOP 1 SKUChild.PimProductId from @SKU AS SKUChild where  SKUChild.SKU = IPAC.ChildSKU ) SKUChildId,
		--		    DisplayOrder
		--			FROM @InsertProductAssociation AS IPAC INNER JOIN @SKU AS SKUParent ON IPAC.ParentSKU = SKUParent.SKU )

		--		 MERGE INTO ZnodePimProductTypeAssociation TARGET
		--		 USING Cte_ProductAssociation SOURCE
		--		 ON( TARGET.PimParentProductId = SOURCE.SKUParentId )
		--		 WHEN MATCHED
		--			   THEN UPDATE SET TARGET.PimProductId = SOURCE.SKUChildId,TARGET.DisplayOrder = SOURCE.DisplayOrder, TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate
		--		 WHEN NOT MATCHED
		--			   THEN INSERT(PimParentProductId, PimProductId,      DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
		--					VALUES(SOURCE.SKUParentId, SOURCE.SKUChildId, SOURCE.DisplayOrder, @UserId, @GetDate, @UserId, @GetDate );

				--INSERT INTO  ZnodePimConfigureProductAttribute  (PimProductId,PimFamilyId,PimAttributeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				--SELECT  a.PimProductId , b.PimAttributeFamilyId,35,2,GETDATE(),2,GETDATE()
				--FROM View_LoadManageProduct a 
				--INNER JOIN ZnodePimProduct B ON (b.PimProductId = a.PimProductId)
				--WHERE AttributeCode = 'ProductType'
				--AND AttributeValue LIKE 'Config%'


								 
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
GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportPriceList' )
BEGIN
	DROP PROCEDURE Znode_ImportPriceList
END
GO 
CREATE PROCEDURE [dbo].[Znode_ImportPriceList]
(
	@TableName nvarchar(100),
	@Status bit OUT, 
	@UserId int, 
	@ImportProcessLogId int,
	@NewGUId nvarchar(200),
	@PriceListId int )
AS 
	/*
	----Summary:  Import RetailPrice List 
	----		  Input XML data extracted in table format (table variable name:  #InsertPriceForValidation) by using  @xml.nodes 
	----		  Validate data column wise and store error log into @ErrorLogForInsertPrice table 
	----          Remove wrong data from table #InsertPriceForValidation and inserted correct data into @InsertPrice table for 
	----		  further processing (Importing to target database )
	--Unit Testing   
*/
BEGIN
	BEGIN TRAN A;
	BEGIN TRY
	    DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
		
		IF OBJECT_ID('#InsertPriceForValidation', 'U') IS NOT NULL 
			DROP TABLE #InsertPriceForValidation
		ELSE 
			CREATE TABLE #InsertPriceForValidation 
			(SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL)
	
		--DECLARE #InsertPriceForValidation TABLE
		--( 
		--	SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL
		--);
		IF OBJECT_ID('#InsertPrice', 'U') IS NOT NULL 
			DROP TABLE #InsertPrice
		ELSE 
			CREATE TABLE #InsertPrice 
			( 
				SKU varchar(300), TierStartQuantity numeric(28, 6) NULL, RetailPrice numeric(28, 6) NULL, SalesPrice numeric(28, 6) NULL, TierPrice numeric(28, 6) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300)
			);
	


		DECLARE @SKU TABLE
		( 
				SKU nvarchar(300)
		);
		INSERT INTO @SKU
			   SELECT b.AttributeValue
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;


		--SET @CategoryXML =  REPLACE(@CategoryXML,'<?xml version="1.0" encoding="utf-16"?>','')

		DECLARE @RoundOffValue int, @MessageDisplay nvarchar(100); 
		-- Retrive RoundOff Value from global setting 

		SELECT @RoundOffValue = FeatureValues FROM ZnodeGlobalSetting WHERE FeatureName = 'PriceRoundOff';
	
		--@MessageDisplay will use to display validate message for input inventory value  

		DECLARE @sSql nvarchar(max);
		SET @sSql = ' Select @MessageDisplay_new = Convert(Numeric(28, '+CONVERT(nvarchar(200), @RoundOffValue)+'), 999999.000000000 ) ';
		EXEC SP_EXecutesql @sSql, N'@MessageDisplay_new NVARCHAR(100) OUT', @MessageDisplay_new = @MessageDisplay OUT;
		
		SET @SSQL = 'Select SKU,TierStartQuantity ,RetailPrice,SalesPrice,TierPrice,SKUActivationDate ,SKUExpirationDate ,RowNumber FROM '+@TableName;
		INSERT INTO #InsertPriceForValidation( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate, RowNumber )
		EXEC sys.sp_sqlexec @SSQL;


		-- 1)  Validation for SKU is pending Proper data not found and 
		--Discussion still open for Publish version where we create SKU and use the SKU code for validation 
		--Select * from ZnodePimAttributeValue  where PimAttributeId =248
		--select * from View_ZnodePimAttributeValue Vzpa Inner join ZnodePimAttribute Zpa on Vzpa.PimAttributeId=Zpa.PimAttributeId where Zpa.AttributeCode = 'SKU'
		--Select * from ZnodePimAttribute where AttributeCode = 'SKU'
		--------------------------------------------------------------------------------------
		--2)  Start Data Type Validation for XML Data  
		--------------------------------------------------------------------------------------			
		---------------------------------------------------------------------------------------
		---------If UOM will blank then retrive top -- Finctionality pending 
		---Validate 
		
		
		INSERT INTO #InsertPrice( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate, RowNumber )
			   SELECT SKU,
					  CASE
					  WHEN CONVERT(Varchar(100),TierStartQuantity) = '' THEN 0
					  ELSE CONVERT(numeric(28, 6), TierStartQuantity)
					  END, CONVERT(numeric(28, 6), RetailPrice),
															  CASE
															  WHEN SalesPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), SalesPrice)
															  END,
															  CASE
															  WHEN TierPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), TierPrice)
															  END, SKUActivationDate, SKUExpirationDate, RowNumber
			   FROM #InsertPriceForValidation;
				
		--------------------------------------------------------------------------------------
		--- start Functional Validation 
		--------------------------------------------------------------------------------------
		--- Verify SKU is present or not 

		--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--	   SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		--	   FROM @InsertPrice
		--	   WHERE SKU NOT IN
		--	   (
		--		   SELECT ZPAVL.AttributeValue
		--		   FROM ZnodePimAttribute AS ZPA
		--				INNER JOIN
		--				ZnodePimAttributeValue AS ZPAV
		--				ON ZPA.PimAttributeId = ZPAV.PimAttributeId
		--				INNER JOIN
		--				ZnodePimAttributeValueLocale AS ZPAVL
		--				ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
		--		   WHERE ZPA.AttributeCode = 'SKU'
		--	   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		FROM #InsertPrice AS ii
		WHERE ii.SKU NOT IN
		(
			SELECT SKU
			FROM @SKU
		);

			 
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'RetailPrice', RetailPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE ISNULL(CAST(RetailPrice AS numeric(28, 6)), 0) <= 0 AND 
					 RetailPrice <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '39', 'SKUActivationDate', SKUActivationDate, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPrice AS IP
			   WHERE SKUActivationDate > SKUExpirationDate AND 
					 ISNULL(SKUExpirationDate, '') <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE( TierPrice IS NULL OR TierPrice = '0') AND  TierStartQuantity = '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierPrice', TierPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation WHERE( TierPrice IS NULL OR  TierPrice = '') AND TierStartQuantity <> 0;
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE ISNULL(CAST(TierStartQuantity AS numeric(28, 6)), 0) < 0 AND 
					 TierPrice <> '';
 
		-- End Function Validation 	
		---------------------------
		--- Delete Invalid Data after functional validation 
		DELETE FROM #InsertPrice
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  Guid = @NewGUId
		);
	
		-- Remove duplicate records 
		--insert into @RemoveDuplicateInsertPrice
		--(SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber )
		--Select SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber FROM @InsertPrice 
		
		--Delete from @InsertPrice 

		--insert into @InsertPrice (SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber)
		--Select SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber from @RemoveDuplicateInsertPrice rdip WHERE rdip.RowNumber IN
		--(
		--	SELECT MAX(ipi.RowNumber) FROM @InsertPrice ipi WHERE rdip.PriceListCode = ipi.PriceListCode AND rdip.SKU = ipi.SKU
		--);

		--Validate StartQuantity and EndQuantity from PriceTier : This validation only for existing data 
		--INSERT INTO @ErrorLogForInsertPrice (RowNumber,SKU,TierStartQuantity ,RetailPrice ,SalesPrice,TierPrice,Uom ,UnitSize,PriceListCode,PriceListName,CurrencyId ,ActivationDate,ExpirationDate,SKUActivationDate,SKUExpirationDate,SequenceNumber,ErrorDescription) 
		--Select IP.RowNumber,IP.SKU,IP.TierStartQuantity ,IP.RetailPrice ,IP.SalesPrice,IP.TierPrice,IP.Uom ,IP.UnitSize,IP.PriceListCode,IP.PriceListName,IP.CurrencyId ,IP.ActivationDate,IP.ExpirationDate,IP.SKUActivationDate,IP.SKUExpirationDate,IP.SequenceNumber,
		--'TierStartQuantity already exists in PriceTier table for SKU '
		--From @InsertPrice IP  Inner join
		--ZnodePriceList Zpl ON Zpl.Listcode = IP.PriceListcode and Zpl.ListName = IP.PriceListName
		--INNER JOIN ZnodeUOM Zu ON ltrim(rtrim(IP.Uom)) = ltrim(rtrim(Zu.Uom)) 
		--INNER JOIN ZnodePriceTier ZPT  ON ZPT.PriceListId = Zpl.PriceListId 
		--AND ZPT.SKU = IP.SKU
		--Where IP.TierStartQuantity  = ZPT.Quantity  
		--- Delete Invalid Data after  Validate StartQuantity and EndQuantity from PriceTier
		
		--INSERT INTO ZnodeUOM (Uom,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		--Select distinct ltrim(rtrim(Uom)) , @UserId,@GetDate,@UserId,@GetDate  from @InsertPrice 
		--where ltrim(rtrim(Uom)) not in (Select ltrim(rtrim(UOM)) From ZnodeUOM where UOM  is not null )
		
		DECLARE @FailedRecordCount BIGINT, @SuccessRecordCount BIGINT 
	
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;

		SELECT @SuccessRecordCount = COUNT(DISTINCT ROWNUMBER) FROM #InsertPrice WHERE 	ROWNUMBER IS NOT NULL ;

		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;

		UPDATE ZP
				SET ZP.SalesPrice = IP.SalesPrice, ZP.RetailPrice = CASE
				WHEN CONVERT(varchar(100), ISNULL(IP.RetailPrice, '')) <> '' THEN IP.RetailPrice
				END, ZP.ActivationDate = CASE
				WHEN ISNULL(IP.SKUActivationDate, '') <> '' THEN IP.SKUActivationDate
				ELSE NULL
				END, ZP.ExpirationDate = CASE
				WHEN ISNULL(IP.SKUExpirationDate, '') <> '' THEN IP.SKUExpirationDate
				ELSE NULL
				END, ZP.ModifiedBy = @UserId, ZP.ModifiedDate = @GetDate
		FROM #InsertPrice IP INNER JOIN ZnodePrice ZP ON ZP.PriceListId = @PriceListId AND  ZP.SKU = IP.SKU  
			 --Retrive last record from prince list of specific SKU ListCode and Name 									
		WHERE IP.RowNumber IN
		(
			SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
		);
		INSERT INTO ZnodePrice( PriceListId, SKU, SalesPrice, RetailPrice, ActivationDate, ExpirationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
			   SELECT @PriceListId, IP.SKU, IP.SalesPrice, IP.RetailPrice,
																						   CASE
																						   WHEN ISNULL(IP.SKUActivationDate, '') = '' THEN NULL
																						   ELSE IP.SKUActivationDate
																						   END,
																						   CASE
																						   WHEN ISNULL(IP.SKUExpirationDate, '') = '' THEN NULL
																						   ELSE IP.SKUExpirationDate
																						   END, @UserId, @GetDate, @UserId, @GetDate
			   FROM #InsertPrice AS IP
			   WHERE NOT EXISTS
			   (
				   SELECT TOP 1 1
				   FROM ZnodePrice
				   WHERE ZnodePrice.PriceListId = @PriceListId AND 
						 ZnodePrice.SKU = IP.SKU AND 
						 ISNULL(ZnodePrice.SalesPrice, 0) = ISNULL(IP.SalesPrice, 0) AND 
						 ZnodePrice.RetailPrice = IP.RetailPrice
			   ) AND 
					 IP.RowNumber IN
			   (
					SELECT MAX(IPI.RowNumber)
					FROM #InsertPrice AS IPI
					WHERE IPI.SKU = IP.SKU 
			   );
		IF EXISTS
		(
			SELECT TOP 1 1
			FROM #InsertPrice
			WHERE CONVERT(varchar(100), TierStartQuantity) <> '' AND 
				  (CONVERT(varchar(100), TierPrice) <> '')
		)
		BEGIN
			UPDATE ZPT
			  SET ZPT.Price = IP.TierPrice, ZPT.ModifiedBy = @UserId, ZPT.ModifiedDate = @GetDate
			FROM #InsertPrice IP INNER JOIN ZnodePriceTier ZPT ON ZPT.PriceListId = @PriceListId AND  ZPT.SKU = IP.SKU AND ZPT.Quantity = IP.TierStartQuantity 
		    --Retrive last record from prince list of specific SKU ListCode and Name 
			WHERE IP.RowNumber IN
			(
				SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
			);
			INSERT INTO ZnodePriceTier( PriceListId, SKU, Price, Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
				   SELECT @PriceListId, IP.SKU, IP.TierPrice, IP.TierStartQuantity,  @UserId, @GetDate, @UserId, @GetDate
				   FROM #InsertPrice AS IP 
				   WHERE NOT EXISTS
				   (
					   SELECT TOP 1 1 FROM ZnodePriceTier WHERE ZnodePriceTier.PriceListId = @PriceListId AND  ZnodePriceTier.SKU = IP.SKU AND 
							 ZnodePriceTier.Quantity = IP.TierStartQuantity
				   ) AND  IP.RowNumber IN
				   (
					   SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU AND  IPI.TierStartQuantity = IP.TierStartQuantity
				   );
		END;  
		--SELECT @PriceListId ID , cast(1 As Bit ) Status  
		--SELECT RowNumber , ErrorDescription , SKU , TierStartQuantity , RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate
		--FROM @ErrorLogForInsertPrice;
		SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- COMMIT TRAN ImportProducts;
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
GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessCustomer' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessCustomer
END
GO 
CREATE   PROCEDURE [dbo].[Znode_ImportProcessCustomer](@TblGUID nvarchar(255) = '' ,@ERPTaskSchedulerId  int )
AS
BEGIN

	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255)
	set @NewuGuId = newid()
	Declare @CurrencyId int ,@PortalId int,@TemplateId INT ,@ImportHeadId INT 
	
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	Select @CurrencyId = CurrencyId  from ZnodeCurrency where CurrencyCode in (Select FeatureValues from   ZnodeGlobalSetting where FeatureName = 'Currency') 

	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@TableName NVARCHAR(255) = 'MAGSOLD',			
			@Sql NVARCHAR(MAX) = '',
			@PriceListId int,
			@RowNum int, 
			@MaxRowNum int,
			@FirstStep nvarchar(255),
			@PriceTableName  nvarchar(255),
			@WarehouseCode varchar(100)
			
	   IF OBJECT_ID('tempdb..##Customer', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##Customer

	   IF OBJECT_ID('tempdb.dbo.##CustomerAddress', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##CustomerAddress

		--SELECT @CustomerTableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =6 --AND ImportTableName = 'PRDH'
		--SELECT @CustomerAddTableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =7 --AND ImportTableName = 'PRDH'

	    SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
	    -- User Data
	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
				
			--Create Temp table for customer 
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'CustomerTemplate'
			SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'Customer'

			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##Customer ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
			EXEC ( @CreateTableScriptSql )
		
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Insert'' 
			AND ImportHeadId = @ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD''  
			AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Insert'' 
			AND ImportHeadId = @ImportHeadId AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@ImportHeadId int , @TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT',@ImportHeadId = @ImportHeadId ,  @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT
	
			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##Customer ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##Customer  SET IsActive =  1 , LastName = ISNULL(LastName,''.'') , Email = UserName '
				EXEC sp_executesql @SQL

				SET @SQL = 'Select * from  tempdb..##Customer' 
				EXEC sp_executesql @SQL
				
				EXEC Znode_ImportData @TableName = 'tempdb..##Customer' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				 @UserId = 2,@PortalId = 1,@LocaleId = 1,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 1, @StepName = 'Import' ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId
			END

			-- User Address Data
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'CustomerAddressTemplate'
			SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'CustomerAddress'
			SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
			
			--Create Temp table for customer Address 
			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##CustomerAddress ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
			EXEC ( @CreateTableScriptSql )
		
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@ImportHeadId int ,@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT',@ImportHeadId = @ImportHeadId,@TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##CustomerAddress ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL
				SET @SQL = 'Update tempdb..##CustomerAddress  SET IsActive =  1 '
				EXEC sp_executesql @SQL
			END

			--Append address data from shipping table 
	
			
			SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			Declare @CustomerTableName  nvarchar(255)
			SET @CustomerTableName = @TableName 
			SET @TableName = 'MAGSHIP'	
			SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSHIP'' ) 
			AND ITD.ImportTableName = ''MAGSHIP''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSHIP'' ) 
			AND ITD.ImportTableName = ''MAGSHIP'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@ImportHeadId int , @TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @ImportHeadId=@ImportHeadId , @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##CustomerAddress ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##CustomerAddress  SET IsActive =  1 '
				EXEC sp_executesql @SQL

				SET @SQL = 'Update A SET A.UserName = b.[EMAIL LOGON ID] from tempdb..##CustomerAddress A INNER JOIN '+@CustomerTableName+' B ON
				            A.ExternalId = b.[Sold-to number] AND A.UserName is null   '
				EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##CustomerAddress  SET LastName = ISNULL(LastName,''.''),FirstName  = ISNULL(UserName,'''')'
				EXEC sp_executesql @SQL



				SET @SQL = 'Select * from  tempdb..##CustomerAddress' 
				EXEC sp_executesql @SQL
				
				EXEC Znode_ImportData @TableName = 'tempdb..##CustomerAddress' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				@UserId = 2,@PortalId = 1,@LocaleId = 1,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 0, @StepName = 'Import1', @StartStepName  ='Import',@step_id = 2 
			    ,@Nextstep_id  = 1,@ERPTaskSchedulerId  =@ERPTaskSchedulerId 
				select 'Job Successfully Started'
			END

END

--GO 
--Znode_ImportProcessCustomer @TblGUID ='a766b8b2-a683-4710-a612-41fb86db53a8'  ,@ERPTaskSchedulerId  =  26 
GO
IF EXISTS( SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportProcessInventoryData' )
BEGIN
	DROP PROCEDURE Znode_ImportProcessInventoryData
END
GO 

CREATE  PROCEDURE [dbo].[Znode_ImportProcessInventoryData](@TblGUID nvarchar(255) = '' ,@ERPTaskSchedulerId  int )
AS
BEGIN

	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255)
	set @NewuGuId = newid()
	Declare @CurrencyId int ,@PortalId int ,@TemplateId INT ,@ImportHeadId INT 
	SELECT @CurrencyId = CurrencyId  from ZnodeCurrency where CurrencyCode in (Select FeatureValues from   ZnodeGlobalSetting where FeatureName = 'Currency') 
	
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@TableName NVARCHAR(255) = 'MAGINV',			
			@Sql NVARCHAR(MAX) = '',
			@PriceListId int,
			@ListCode nvarchar(255) = 'TempMAGINV' ,
			@RowNum int, 
			@MaxRowNum int,
			@FirstStep nvarchar(255),
			@PriceTableName  nvarchar(255),
			@WarehouseCode varchar(100)

	Select TOP 1  @WarehouseCode = ZW.WarehouseCode from ZnodePortalWarehouse zpw inner join ZnodeWarehouse ZW on zpw.WarehouseId = ZW.WarehouseId
	where PortalId =@PortalId
	
	   IF OBJECT_ID('tempdb.dbo.##Inventory', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##Inventory

	SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'Inventory'
	if Isnull(@WarehouseCode ,'') <> '' 
	BEGIN 
		SELECT @TableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =@ImportHeadId --AND ImportTableName = 'PRDH'
	    SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
	
	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
			
			--Create Temp table for price with respective their code 
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'InventoryTemplate'
			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb.dbo.##Inventory ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
		
			EXEC ( @CreateTableScriptSql )

			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = ''MAGINV''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = ''MAGINV'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT
	

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb.dbo.##Inventory ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL
				SET @SQL = 'Update tempdb.dbo.##Inventory  SET WarehouseCode = ''' + @WarehouseCode + ''''
				EXEC sp_executesql @SQL
				--SET @SQL = 'Select * from tempdb..##' + @ListCode
				--EXEC sp_executesql @SQL
			

				EXEC Znode_ImportData @TableName = 'tempdb..##Inventory' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				@UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 0,@Nextstep_id  = 1 ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId  
				select 'Job Successfully Started'
			END
			
	END
END
GO
PRINT N'Altering [dbo].[Znode_ImportProcessProductData]...';


GO
IF EXISTS (SELECT TOP 1 1 FROM Sys.Procedures WHERE name = 'Znode_ImportProcessProductData')
BEGIN 
 DROP PROC Znode_ImportProcessProductData
END 
GO 
--  [dbo].[Znode_ImportProcessProductData] '1928de37-30d3-4cc1-b5e3-0c498c0da183'
CREATE  PROCEDURE [dbo].[Znode_ImportProcessProductData](@TblGUID nvarchar(255),@ERPTaskSchedulerId int )
AS
BEGIN
	SET NOCOUNT ON;
	SET TEXTSIZE 2147483647;
	DECLARE @NewuGuId nvarchar(255),@ImportHeadId INT 
	set @NewuGuId = newid()
    DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
	DECLARE @DefaultFamilyId  INT = dbo.Fn_GetDefaultPimProductFamilyId();
	DECLARE @LocaleId  INT = dbo.Fn_GetDefaultLocaleId()
	DECLARE @TemplateId INT , @PortalId INT 
	
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	IF OBJECT_ID('tempdb.dbo.##ProductDetail', 'U') IS NOT NULL 
		DROP TABLE ##ProductDetail

	IF OBJECT_ID('tempdb.dbo.#Attributecode', 'U') IS NOT NULL 
		DROP TABLE #Attributecode
	
	IF OBJECT_ID('tempdb.dbo.#ConfigurableAttributecode', 'U') IS NOT NULL 
		DROP TABLE #ConfigurableAttributecode 
	
	IF OBJECT_ID('tempdb.dbo.#DefaultAttributeCode', 'U') IS NOT NULL 
		DROP TABLE #DefaultAttributeCode 

    IF OBJECT_ID('tempdb.dbo.[##ProductAssociation]', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.[##ProductAssociation]

		
	Declare @GlobalTemporaryTable nvarchar(255)
	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName   NVARCHAR(MAX), 
			@UpdateTable2Column NVARCHAR(MAX),
			@UpdateTable3Column NVARCHAR(MAX),
			@UpdateTable4Column NVARCHAR(MAX),
			@ImportTableColumnName NVARCHAR(MAX),
			@ImportTableName VARCHAR(200),
			@TableName4 NVARCHAR(255) = 'tempdb..[##PRDDA_' + @TblGUID + ']',
			@Sql NVARCHAR(MAX) = '',
			@Attribute NVARCHAR(MAX)

	DECLARE @Attributecode TABLE ( Attrcode NVARCHAR(255) )

	CREATE TABLE #Attributecode ( Attrcode NVARCHAR(255) )
	CREATE TABLE #ConfigurableAttributecode (SKU NVARCHAR(255) , PimAttributeId  int , DefaultValue nvarchar(255) ,AttributeCode nvarchar(255) ,ParentSKU nvarchar(255)) 
	
	SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'ProductTemplate'

	SET @Sql = '
	INSERT INTO ZnodeImportTemplateMapping ( ImportTemplateId, SourceColumnName, TargetColumnName, DisplayOrder, IsActive, IsAllowNull, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
	SELECT Distinct 1 AS ImportTemplateId,  PA.AttributeCode AS SourceColumnName,  PA.AttributeCode AS TargetColumnName, 0 AS DisplayOrder, 0 AS IsActive, 0 AS IsAllowNull, 2 AS CreatedBy, GETDATE() AS CreatedDate, 2 AS ModifiedBy, GETDATE() AS ModifiedDate
	FROM '+@TableName4+' PRD
	INNER JOIN ZnodePimAttribute PA ON PRD.Attribute = PA.AttributeCode
	WHERE NOT EXISTS ( SELECT * FROM ZNODEIMPORTTEMPLATEMAPPING ITM WHERE ImportTemplateId = ' + CONVERT(NVARCHAR(100), @TemplateId ) + ' AND PRD.ATTRIBUTE =  ITM.SOURCECOLUMNNAME )'


	EXEC ( @Sql )
	
	SELECT @CreateTableScriptSql = 'CREATE TABLE ##ProductDetail ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
	FROM [dbo].[ZnodeImportTemplateMapping]
	WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , ParentStyle NVARCHAR(MAX),GUID nvarchar(255), BaseProductType nvarchar(255) )'

	EXEC ( @CreateTableScriptSql )
	
	SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'Product'

	SELECT * FROM ZnodeImportHead
	--Merge all the tables which is type is inserted / updated 
	DECLARE Cur_InsertProduct CURSOR FOR
	
	SELECT ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId = @ImportHeadId --AND ImportTableName = 'PRDH'
	
	OPEN Cur_InsertProduct 

	FETCH NEXT FROM Cur_InsertProduct INTO @ImportTableName

	WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
	    SET @GlobalTemporaryTable = 'tempdb..[##' + @ImportTableName + '_' + @TblGUID + ']' 
		--1 simple 
		    SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = @ImportTableName  AND ITCD.BaseImportColumn is not null FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  ITD.ImportTableName = @ImportTableName  AND ITCD.BaseImportColumn is not null FOR XML PATH ('''')),2,4000)'

		PRINT @Sql
		EXEC sp_executesql @SQL, N'@ImportTableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @ImportTableName = @ImportTableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

		
		IF( LEN(@InsertColumnName) > 0 )
		BEGIN
			SET @SQL = 'INSERT INTO ##ProductDetail ( ParentStyle, '+@InsertColumnName+' )	SELECT [Parent Style], '+@ImportTableColumnName +' FROM '+@GlobalTemporaryTable
			EXEC sp_executesql @SQL
		END

		SELECT @InsertColumnName ='', @GlobalTemporaryTable=''

		FETCH NEXT FROM Cur_InsertProduct INTO @ImportTableName
	END

	CLOSE Cur_InsertProduct
	DEALLOCATE Cur_InsertProduct

	DECLARE @UpdateTableColumn varchar(max)
	

	SET @Sql = 
		'SELECT @UpdateTableColumn = 
		 COALESCE(@UpdateTableColumn + '','', '''') + ''[''+BaseImportColumn+''] = B.[''+BaseImportColumn+'']''
		 FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
		 ON ITCD.ImportTableId = ITD.ImportTableId
		 WHERE  ITD.ImportTableName = ''PRDH''  AND ITCD.BaseImportColumn IS NOT NULL AND ITCD.BaseImportColumn <> ''SKU'''

	EXEC sp_executesql @SQL, N'@UpdateTableColumn VARCHAR(200) OUTPUT', @UpdateTableColumn = @UpdateTableColumn OUTPUT
	
	SET @Sql = 
		';WITH CTE AS
		(
			SELECT * FROM ##ProductDetail WHERE ProductName IS NOT NULL
		)
		UPDATE A 
		SET '+@UpdateTableColumn+'
		FROM ##ProductDetail A 
		INNER JOIN CTE B ON B.ParentStyle = A.ParentStyle'
	EXEC ( @Sql )
    
	SET @Sql = 'INSERT INTO #Attributecode ( Attrcode ) SELECT DISTINCT ltrim(rtrim([Attribute])) FROM '+ @TableName4
	 + ' where ltrim(rtrim([Attribute]))  in (Select AttributeCode from ZnodePimAttribute where IsCategory = 0 )'
	EXEC ( @Sql )

	DECLARE Cur_AttributeCode CURSOR FOR SELECT Attrcode FROM #Attributecode where Attrcode is not null 
    OPEN Cur_AttributeCode
    FETCH NEXT FROM Cur_AttributeCode INTO @Attribute
    WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
		SET @SQL = ''
		SET @SQL =  'UPDATE PD SET PD.' + @Attribute  + '= ' + ' Replace(Replace(PDD.[Attribute Value], ''/'', ''''), '' '', '''')' +'  FROM ##ProductDetail PD inner join '+@TableName4+ ' PDD on PD.SKU = PDD.SKU# WHERE PDD.Attribute =  '''+@Attribute + ''' '
		EXEC sp_executesql @SQL
		FETCH NEXT FROM Cur_AttributeCode INTO @Attribute
	END
	CLOSE Cur_AttributeCode
	DEALLOCATE Cur_AttributeCode
	
	SET @Sql = 'UPDATE ##ProductDetail SET GUID= '''+@NewuGuId  + ''', BaseProductType = ProductType'
	EXEC sp_executesql @SQL

	SET @Sql = 'UPDATE ##ProductDetail SET ProductType =  CASE when [ParentStyle] = SKU 
	then ''ConfigurableProduct'' ELSE ''SimpleProduct'' END ,
	MinimumQuantity = 1 , MaximumQuantity = 10 ,ShippingCostRules = ''WeightBasedRate'',OutOfStockOptions = ''DontTrackInventory''
	,ProductCode = CASE When ProductCode Is Null then SKU ELSE ProductCode  END , 
	IsActive = CASE when Isnull(IsActive,'''') = '''' then 1 END'
	EXEC sp_executesql @SQL
	
	DELETE  FROM ##ProductDetail where isnull(SKU,'') = ''
	---- Read All default data 
	
	-- Product Association data prepartion 
	Create TABLE tempdb..[##ProductAssociation] (ParentSKU nvarchar(255),ChildSKU nvarchar(255), DisplayOrder int,GUID nvarchar(100) )
	SET @Sql = '
	insert into tempdb..[##ProductAssociation]  (ParentSKU ,ChildSKU , DisplayOrder,GUID )
	select [ParentStyle], SKU  ,1, ''' + @NewuGuId + ''' from ##ProductDetail  where [ParentStyle] <>  SKU and [ParentStyle] is not null 
	'
	EXEC (@Sql)
	
	-- Configrable Attributes
	SET @Sql = 'INSERT INTO #ConfigurableAttributecode (PimAttributeId ,DefaultValue ,AttributeCode,ParentSKU)
	            SELECT Distinct ZPA.PimAttributeId,[Attribute Value]	 ,ltrim(rtrim(PDA.[Attribute])), PDA.[Parent Style]  FROM '+ @TableName4
	 + ' PDA Inner join  tempdb..##ProductDetail PD  ON PDA.[SKU#]= PD.SKU and PD.BaseProductType = ''C''
	  Inner join ZnodePimAttribute ZPA ON ZPA.AttributeCode = ltrim(rtrim(PDA.[Attribute])) AND ZPA.IsCategory = 0 and ZPA.IsConfigurable =1 '
	EXEC ( @Sql )

	-- Update default vaule of confi attribute in main template
	SET @Sql = '
	Select * from ##ProductDetail PD INNER JOIN #ConfigurableAttributecode CA ON CA.ParentSKU = PD.SKU '

	DECLARE @DefaultValue nvarchar(255),@ParentSKU  nvarchar(255),@AttributeName nvarchar(255)
	DECLARE Cur_ConfigAttributeCode CURSOR FOR SELECT DefaultValue, AttributeCode,ParentSKU 
	FROM #ConfigurableAttributecode  where DefaultValue is not null 
    OPEN Cur_ConfigAttributeCode
    FETCH NEXT FROM Cur_ConfigAttributeCode INTO @DefaultValue, @AttributeName,@ParentSKU
    WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
		SET @SQL = ''
		SET @SQL =  'UPDATE ##ProductDetail SET ' + @AttributeName  + ' = ''' +  Replace(Replace(@DefaultValue, '/', ''), ' ', '') + 
		''' WHERE SKU  =  '''+	@ParentSKU + ''''
		EXEC sp_executesql @SQL
		FETCH NEXT FROM Cur_ConfigAttributeCode INTO @DefaultValue, @AttributeName,@ParentSKU
	END
	CLOSE Cur_ConfigAttributeCode
	DEALLOCATE Cur_ConfigAttributeCode
		
	SET @Sql = 'Alter TABLE ##ProductDetail drop column [ParentStyle],[BaseProductType]'
	EXEC sp_executesql @SQL
	

	SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'ProductTemplate'
	-- Import product    
	EXEC Znode_ImportData @TableName = 'tempdb..[##ProductDetail]',	@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
	      @UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = @DefaultFamilyId,@PriceListId = 0, @CountryCode = ''
		 ,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 1, @StepName = 'Import' ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId ,@IsDebug =1


	If Exists (select TOP 1 1 from #ConfigurableAttributecode ) 
	BEGIN
	--SET @Sql = 'SELECT * FROM tempdb..[##ProductAssociation]' 
	--	EXEC sp_executesql @SQL
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'ProductAssociation'

			EXEC Znode_ImportData @TableName = 'tempdb..[##ProductAssociation]',	@NewGUID =  @TblGUID ,@TemplateId = @TemplateId,
			 @UserId = 2,@PortalId = @PortalId,@LocaleId = @LocaleId,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
			,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 0, @StepName = 'Import1', @StartStepName  ='Import',@step_id = 2 , @IsDebug =1
			,@Nextstep_id  = 1,@ERPTaskSchedulerId  = @ERPTaskSchedulerId  
		
	END
	 select 'Job create successfully.' 
	
END
GO


IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_GetImportERPConnectorLogs')
BEGIN 
 DROP PROC Znode_GetImportERPConnectorLogs
END 
GO 
CREATE   PROCEDURE [dbo].[Znode_GetImportERPConnectorLogs]
( @WhereClause NVARCHAR(max),
  @Rows        INT           = 100,
  @PageNo      INT           = 1,
  @Order_BY    VARCHAR(1000)  = '',
  @RowsCount   INT OUT)
AS
    /*
	
    Summary : Get Import Template Log details and errorlog associated to it
    Unit Testing 
	BEGIN TRAN
    DECLARE @RowsCount INT;
    EXEC Znode_GetImportERPConnectorLogs @WhereClause = ' ',@Rows = 1000,@PageNo = 1,@Order_BY = NULL,@RowsCount = @RowsCount OUT;
	rollback tran
   
    */
	 BEGIN
        BEGIN TRY
          SET NOCOUNT ON;
		     DECLARE @SQL NVARCHAR(MAX);
             DECLARE @TBL_ErrorLog TABLE(ERPTaskSchedulerId INT, SchedulerName NVARCHAR(200),SchedulerType VARCHAR(20) ,
										TouchPointName NVARCHAR(200),
										[ImportStatus] VARCHAR(50) ,ProcessStartedDate DATETIME ,ProcessCompletedDate DATETIME
										,ImportProcessLogId INT,RowId INT,CountNo  INT,SuccessRecordCount int,FailedRecordcount INT)

             SET @SQL = ' 
			 	

					   ;With Cte_ErrorLog AS (
									   select zih.ERPTaskSchedulerId, 
									   Case when zih.SchedulerType = ''RealTime'' then zih.SchedulerName + '' - '' + ''RealTime''
									   else zih.SchedulerName end SchedulerName, 
									   zih.SchedulerType,
									   CASE when ZIT.ImportTemplateId is not null THEN 
									   zih.TouchPointName + '' - '' + ZIT.TemplateName
									   ELSE zih.TouchPointName END TouchPointName
									   ,zipl.Status ImportStatus ,
									   zipl.ProcessStartedDate,
									   zipl.ProcessCompletedDate,zipl.ImportProcessLogId,
									   zipl.SuccessRecordCount,zipl.FailedRecordcount
									   from ZnodeImportProcessLog zipl 
									   Inner join ZnodeERPTaskScheduler zih on zipl.ERPTaskSchedulerId = zih.ERPTaskSchedulerId
									   LEFT Outer JOIN ZnodeImportTemplate ZIT ON zipl.ImportTemplateId = ZIT.ImportTemplateId
									   Inner join ZnodeERPConfigurator ZEC ON zih.ERPConfiguratorId = ZEC.ERPConfiguratorId 
									   AND ZEC.IsActive = 1 
								     ) 
						,Cte_ErrorlogFilter AS
						(
					   SELECT ERPTaskSchedulerId,SchedulerName,SchedulerType,TouchPointName,ImportStatus,
						ProcessStartedDate,ProcessCompletedDate,ImportProcessLogId
						,'+dbo.Fn_GetPagingRowId(@Order_BY,'ImportProcessLogId DESC')+', Count(*)Over() CountNo
					   ,SuccessRecordCount,FailedRecordcount FROM Cte_ErrorLog
					   WHERE 1 = 1 '+dbo.Fn_GetFilterWhereClause(@WhereClause)+'
						) 
					   SELECT ERPTaskSchedulerId,SchedulerName,SchedulerType,TouchPointName,ImportStatus,
							ProcessStartedDate,ProcessCompletedDate,ImportProcessLogId
							,RowId,CountNo ,SuccessRecordCount,FailedRecordcount
					   FROM Cte_ErrorlogFilter 
					   '+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)
	        
			 INSERT INTO @TBL_ErrorLog (ERPTaskSchedulerId,SchedulerName,SchedulerType,TouchPointName,ImportStatus,ProcessStartedDate,ProcessCompletedDate,ImportProcessLogId,RowId,CountNo,SuccessRecordCount,FailedRecordcount )
			 EXEC(@SQl)												
             SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM @TBL_ErrorLog ), 0);

			 SELECT ERPTaskSchedulerId , SchedulerName ,SchedulerType  ,
										TouchPointName ,
										[ImportStatus] ,ProcessStartedDate ,ProcessCompletedDate 
										,ImportProcessLogId ,RowId ,CountNo  ,SuccessRecordCount,FailedRecordcount
			 FROM @TBL_ErrorLog
             
         END TRY
         BEGIN CATCH
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetImportTemplateLogs @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status,ERROR_MESSAGE();                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetImportTemplateLogs',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;                   
         END CATCH;
     END;
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportAssociateProducts')
BEGIN 
 DROP PROC Znode_ImportAssociateProducts
END 
GO 
CREATE  PROCEDURE [dbo].[Znode_ImportAssociateProducts](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @PimCatalogId int= 0)
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import Product Association 
	
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
		DECLARE @InsertProductAssociation TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ParentSKU varchar(300), ChildSKU varchar(200), DisplayOrder int, GUID nvarchar(400)
		);
		
		IF OBJECT_ID('#InsertProduct', 'U') IS NOT NULL 
			DROP TABLE #InsertProduct
		ELSE 
		CREATE TABLE #InsertProduct 
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ParentProductId varchar(300), ChildProductId varchar(200), DisplayOrder int, GUID nvarchar(400)
		);


		DECLARE @CategoryAttributId int;

		DECLARE @InventoryListId int;

		SET @SSQL = 'Select RowNumber,ParentSKU,ChildSKU,DisplayOrder,GUID FROM '+@TableName;
		INSERT INTO @InsertProductAssociation( RowNumber, ParentSKU,ChildSKU,DisplayOrder, GUID )
		EXEC sys.sp_sqlexec @SSQL;


		--@MessageDisplay will use to display validate message for input inventory value  
		DECLARE @SKU TABLE
		( 
						   SKU nvarchar(300), PimProductId int
		);
		INSERT INTO @SKU
			   SELECT b.AttributeValue, a.PimProductId
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;

		DECLARE @ProductType TABLE
		( 
			ProductType nvarchar(100) ,PimProductId int
		);
		INSERT INTO @ProductType
			   SELECT  ZPADV.AttributeDefaultValueCode, a.PimProductId
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimProductAttributeDefaultValue AS b
					ON a.PimAttributeId = dbo.Fn_GetProductTypeAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId
					   Inner join ZnodePimAttributeDefaultValue ZPADV On b.PimAttributeDefaultValueId = ZPADV.PimAttributeDefaultValueId
					   where  ZPADV.AttributeDefaultValueCode in ('GroupedProduct','BundleProduct','ConfigurableProduct');
		-- start Functional Validation 
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'ParentSKU', ParentSKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii
			   WHERE ii.ParentSKU NOT IN
			   (
				   SELECT SKU
				   FROM @SKU
			   );
			INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'ChildSKU', ChildSKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii
			   WHERE ii.ChildSKU NOT IN
			   (
				   SELECT SKU
				   FROM @SKU
			   );

		DELETE FROM @InsertProductAssociation
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  GUID = @NewGUID
		);

			INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '49', 'ParentSKU',   ParentSKU , @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii
			   WHERE ii.ParentSKU NOT IN
			   (
				   SELECT SKU  FROM @SKU SKU inner join @ProductType  PT ON SKU.PimProductId = PT.PimProductId 
	
			   );

			INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '51', 'ChildSKU',   ChildSKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii
			   WHERE ii.ChildSKU IN
			   (
				   SELECT SKU  FROM @SKU SKU inner join @ProductType  PT ON SKU.PimProductId = PT.PimProductId 
	
			   );

			INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'ParentSKU',  'Configure Attribute Missing: '+ Convert(nvarchar(400),isnull(ParentSKU,'')), @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertProductAssociation AS ii Inner join @SKU PS ON 
			   ii.ParentSKU = PS.SKU 
			   Inner join @ProductType  PT ON PS.PimProductId = PT.PimProductId  AND PT.ProductType  in ('ConfigurableProduct')
			   where  PS.PimProductId NOT in 
			   (select Distinct PimProductId  from ZnodePimConfigureProductAttribute)
			   -- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  
		DELETE FROM @InsertProductAssociation
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  GUID = @NewGUID
		);

		insert into #InsertProduct (RowNumber,  ParentProductId , ChildProductId , DisplayOrder)
			SELECT RowNumber , SKUParent.PimProductId SKUParentId , 
				   ( Select TOP 1 SKUChild.PimProductId from @SKU AS SKUChild where  SKUChild.SKU = IPAC.ChildSKU ) SKUChildId,
				    DisplayOrder
					FROM @InsertProductAssociation AS IPAC INNER JOIN @SKU AS SKUParent ON IPAC.ParentSKU = SKUParent.SKU 

	-- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM #InsertProduct
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End

		INSERT INTO ZnodePimProductTypeAssociation (PimParentProductId, PimProductId, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
		select  ParentProductId , ChildProductId , DisplayOrder, @UserId, @GetDate, @UserId, @GetDate  from #InsertProduct 
		where  NOT Exists (Select TOP 1 1 from ZnodePimProductTypeAssociation where PimParentProductId =  #InsertProduct.ParentProductId
		AND PimProductId = #InsertProduct.ChildProductId )


		--SELECT SKUParent.PimProductId SKUParentId , 
		--		   ( Select TOP 1 SKUChild.PimProductId from @SKU AS SKUChild where  SKUChild.SKU = IPAC.ChildSKU ) SKUChildId,
		--		    DisplayOrder
		--			FROM @InsertProductAssociation AS IPAC INNER JOIN @SKU AS SKUParent ON IPAC.ParentSKU = SKUParent.SKU 



		--	WITH Cte_ProductAssociation
		--		 AS( SELECT SKUParent.PimProductId SKUParentId , 
		--		   ( Select TOP 1 SKUChild.PimProductId from @SKU AS SKUChild where  SKUChild.SKU = IPAC.ChildSKU ) SKUChildId,
		--		    DisplayOrder
		--			FROM @InsertProductAssociation AS IPAC INNER JOIN @SKU AS SKUParent ON IPAC.ParentSKU = SKUParent.SKU )

		--		 MERGE INTO ZnodePimProductTypeAssociation TARGET
		--		 USING Cte_ProductAssociation SOURCE
		--		 ON( TARGET.PimParentProductId = SOURCE.SKUParentId )
		--		 WHEN MATCHED
		--			   THEN UPDATE SET TARGET.PimProductId = SOURCE.SKUChildId,TARGET.DisplayOrder = SOURCE.DisplayOrder, TARGET.CreatedBy = @UserId, TARGET.CreatedDate = @GetDate, TARGET.ModifiedBy = @UserId, TARGET.ModifiedDate = @GetDate
		--		 WHEN NOT MATCHED
		--			   THEN INSERT(PimParentProductId, PimProductId,      DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate) 
		--					VALUES(SOURCE.SKUParentId, SOURCE.SKUChildId, SOURCE.DisplayOrder, @UserId, @GetDate, @UserId, @GetDate );

				--INSERT INTO  ZnodePimConfigureProductAttribute  (PimProductId,PimFamilyId,PimAttributeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				--SELECT  a.PimProductId , b.PimAttributeFamilyId,35,2,GETDATE(),2,GETDATE()
				--FROM View_LoadManageProduct a 
				--INNER JOIN ZnodePimProduct B ON (b.PimProductId = a.PimProductId)
				--WHERE AttributeCode = 'ProductType'
				--AND AttributeValue LIKE 'Config%'


								 
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
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportAttributes')
BEGIN 
 DROP PROC Znode_ImportAttributes
END 
GO 
CREATE  PROCEDURE [dbo].[Znode_ImportAttributes](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @PimCatalogId int= 0)
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import Attribute Code Name and their default input validation rule other 
	--			  flag will be inserted as default we need to modify front end
	
	-- Unit Testing: 

	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max);
		DECLARE @GetDate datetime= dbo.Fn_GetDate(), @LocaleId int  ;
		SELECT @LocaleId = DBO.Fn_GetDefaultLocaleId();
		-- Retrive RoundOff Value from global setting 
		DECLARE @InsertPimAtrribute TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, AttributeName varchar(300), AttributeCode varchar(300), AttributeType varchar(300), DisplayOrder int, GUID nvarchar(400)
		
		);
		DECLARE @InsertedPimAttributeIds TABLE (PimAttributeId int ,AttributeTypeId int,AttributeCode nvarchar(300))
		
		SET @SSQL = 'Select RowNumber,AttributeName,AttributeCode,AttributeType,DisplayOrder ,GUID FROM '+@TableName;
		INSERT INTO @InsertPimAtrribute( RowNumber,AttributeName,AttributeCode,AttributeType,DisplayOrder ,GUID)
		EXEC sys.sp_sqlexec @SSQL;


		--@MessageDisplay will use to display validate message for input inventory value  
		DECLARE @AttributeCode TABLE
		( 
		   AttributeCode nvarchar(300)
		);
		INSERT INTO @AttributeCode
			   SELECT AttributeCode
			   FROM ZnodePimAttribute 

		-- Start Functional Validation 
		-----------------------------------------------
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '10', 'AttributeCode', AttributeCode, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPimAtrribute AS ii
			   WHERE ii.AttributeCode in 
			   (
				   SELECT AttributeCode FROM @AttributeCode  where AttributeCode is not null 
			   );

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'AttributeType', AttributeType, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPimAtrribute AS ii
			   WHERE ii.AttributeType NOT in 
			   (
				   SELECT AttributeTypeName  FROM ZnodeAttributeType  where IsPimAttributeType = 1 
			   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '50', 'AttributeCode', AttributeCode, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM @InsertPimAtrribute AS ii
			   WHERE ltrim(rtrim(isnull(ii.AttributeCode,''))) like '%[^0-9A-Za-z]%'


		-- End Function Validation 	
		-----------------------------------------------
		-- Delete Invalid Data after functional validatin  
		DELETE FROM @InsertPimAtrribute
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
		);
		
		-- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertPimAtrribute
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End


		--- Insert data into base table ZnodePimatrribute with their validation 

		INSERT INTO ZnodePimAttribute (AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined
			,IsConfigurable,IsPersonalizable,IsShowOnGrid,DisplayOrder,HelpDescription,IsCategory,IsHidden,IsSwatch,
			CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		
		OUTPUT Inserted.PimAttributeId,Inserted.AttributeTypeId,Inserted.AttributeCode INTO @InsertedPimAttributeIds  
		
		SELECT ZAT.AttributeTypeId,AttributeCode, 1 IsRequired , 1 IsLocalizable,1 IsFilterable, 0 IsSystemDefined, 0 IsConfigurable,
		0 IsPersonalizable,  1 IsShowOnGrid , DisplayOrder, '' HelpDescription ,0  IsCategory , 0 IsHidden , 0 IsSwatch,
		@UserId , @GetDate ,@UserId , @GetDate from @InsertPimAtrribute IPA INNER JOIN ZnodeAttributeType ZAT 
		ON IPA.AttributeType = ZAT.AttributeTypeName  
		
		
		INSERT INTO ZnodePimAttributeLocale (LocaleId,PimAttributeId,AttributeName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select @LocaleId ,IPAS.PimAttributeId, IPA.AttributeName, '', @UserId , @GetDate ,@UserId , @GetDate   
		 FROM @InsertedPimAttributeIds IPAS INNER JOIN @InsertPimAtrribute IPA ON IPAS.AttributeCode= IPA.AttributeCode 
		
		INSERT INTO ZnodePimAttributeValidation
		(PimAttributeId,InputValidationId,InputValidationRuleId,Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		SELECT IPA.PimAttributeId,ZAIV.InputValidationId,NULL,null , @UserId , @GetDate ,@UserId , @GetDate  
		FROM @InsertedPimAttributeIds IPA INNER JOIN ZnodeAttributeInputValidation ZAIV ON IPA.AttributeTypeId = ZAIV.AttributeTypeId

		--      SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET STATUS = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
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
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportCustomer')
BEGIN 
 DROP PROC Znode_ImportCustomer
END 
GO 
CREATE  PROCEDURE [dbo].[Znode_ImportCustomer](
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
			LastName nvarchar(200),	MiddleName	nvarchar(200),BudgetAmount	numeric,Email	nvarchar(100),PhoneNumber	nvarchar(100),
		    EmailOptIn	bit	,ReferralStatus	nvarchar(40),IsActive	bit	,ExternalId	nvarchar(max), GUID NVARCHAR(400)
		);

			--SET @SSQL = 'SELECT RowNumber,UserName,FirstName,LastName,MiddleName,BudgetAmount,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId,GUID FROM '+ @TableName;
		SET @SSQL = 'SELECT RowNumber,' + @CsvColumnString + ',GUID FROM '+ @TableName;
		INSERT INTO @InsertCustomer( RowNumber,UserName,FirstName,LastName,MiddleName,Email,PhoneNumber,       EmailOptIn,IsActive,ExternalId,GUID )
		EXEC sys.sp_sqlexec @SSQL;
		


		--UserName,FirstName,LastName,MiddleName,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId
	
	    -- start Functional Validation 

		-----------------------------------------------
		--If @IsAllowGlobalLevelUserCreation = 'true'
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			   WHERE ii.UserName in 
		--			   (
		--				   SELECT UserName FROM AspNetZnodeUser   where PortalId = @PortalId
		--			   );
		--Else 
		--		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--			   SELECT '10', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
		--			   FROM @InsertCustomer AS ii
		--			   WHERE ii.UserName in 
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
					   WHERE ii.UserName in 
					   (SELECT UserName  FROM @InsertCustomer group by UserName  having count(*) > 1 )

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
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertCustomer
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End

		-- Insert Product Data 
				
				
				DECLARE @InsertedAspNetZnodeUser TABLE (AspNetZnodeUserId nvarchar(256) ,UserName nvarchar(512),PortalId int )
				DECLARE @InsertedASPNetUsers TABLE (Id nvarchar(256) ,UserName nvarchar(512))
				DECLARE @InsertZnodeUser TABLE (UserId int,AspNetUserId nvarchar(256) )

				UPDATE ANU SET 
				ANU.PhoneNumber	= IC.PhoneNumber
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				UPDATE ZU SET 
				ZU.FirstName	= IC.FirstName,
				ZU.LastName		= IC.LastName,
				ZU.MiddleName	= IC.MiddleName,
				ZU.BudgetAmount = IC.BudgetAmount,
				ZU.Email		= IC.Email,
				ZU.PhoneNumber	= IC.PhoneNumber,
				ZU.EmailOptIn	= Isnull(IC.EmailOptIn,0),
				ZU.IsActive		= IC.IsActive
				--ZU.ExternalId = ExternalId
				from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomer IC ON ANZU.UserName = IC.UserName 
				where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

	
				Insert into AspNetZnodeUser (AspNetZnodeUserId, UserName, PortalId)		
				OUTPUT INSERTED.AspNetZnodeUserId, INSERTED.UserName, INSERTED.PortalId	INTO  @InsertedAspNetZnodeUser 			 
				Select NEWID(),IC.UserName, @PortalId FROM @InsertCustomer IC 
				where Not Exists (Select TOP 1 1  from AspNetZnodeUser ANZ where Isnull(ANZ.PortalId,0) = Isnull(@PortalId,0) AND ANZ.UserName = IC.UserName)

				INSERT INTO ASPNetUsers (Id,Email,EmailConfirmed,PasswordHash,SecurityStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,
				LockoutEndDateUtc,LockOutEnabled,AccessFailedCount,PasswordChangedDate,UserName)
				output inserted.Id, inserted.UserName into @InsertedASPNetUsers
				SELECT NewId(), Email,0 ,@PasswordHash,@SecurityStamp,PhoneNumber,0,0,NULL LockoutEndDateUtc,1 LockoutEnabled,
				0,@GetDate,AspNetZnodeUserId from @InsertCustomer A INNER JOIN @InsertedAspNetZnodeUser  B 
				ON A.UserName = B.UserName
				
				INSERT INTO  ZnodeUser(AspNetUserId,FirstName,LastName,MiddleName,CustomerPaymentGUID,Email,PhoneNumber,EmailOptIn,
				IsActive,ExternalId, CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				OUTPUT Inserted.UserId, Inserted.AspNetUserId into @InsertZnodeUser
				SELECT IANU.Id AspNetUserId ,IC.FirstName,IC.LastName,IC.MiddleName,null CustomerPaymentGUID,IC.Email
				,IC.PhoneNumber,Isnull(IC.EmailOptIn,0),IC.IsActive,IC.ExternalId, @UserId,@Getdate,@UserId,@Getdate
				from @InsertCustomer IC Inner join 
				@InsertedAspNetZnodeUser IANZU ON IC.UserName = IANZU.UserName  INNER JOIN 
				@InsertedASPNetUsers IANU ON IANZU.AspNetZnodeUserId = IANU.UserName 
				  	     
				INSERT INTO AspNetUserRoles (UserId,RoleId)  Select AspNetUserId, @RoleID from @InsertZnodeUser 
				INSERT INTO ZnodeUserPortal (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
				SELECT UserId, @PortalId , @UserId,@Getdate,@UserId,@Getdate from @InsertZnodeUser
				Declare @ProfileId  int 
				select TOP 1 @ProfileId   =  ProfileId from ZnodePortalprofile where Portalid = 4 and IsDefaultRegistedProfile=1

				insert into ZnodeUserProfile (ProfileId,UserId,IsDefault,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT @ProfileId  , UserId, 1 , @UserId,@Getdate,@UserId,@Getdate from @InsertZnodeUser
		-- 'End'
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
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportCustomerAddress')
BEGIN 
 DROP PROC Znode_ImportCustomerAddress
END 
GO 
CREATE  PROCEDURE [dbo].[Znode_ImportCustomerAddress](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @LocaleId int= 0,@PortalId int ,@CsvColumnString nvarchar(max))
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import SEO Details
	
	-- Unit Testing : 
	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max),@IsAllowGlobalLevelUserCreation nvarchar(10)

		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive Value from global setting 
		Select @IsAllowGlobalLevelUserCreation = FeatureValues from ZnodeGlobalsetting where FeatureName = 'AllowGlobalLevelUserCreation'
		-- Three type of import required three table varible for product , category and brand

		DECLARE @InsertCustomerAddress TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int,UserName	nvarchar(512)
			,FirstName	varchar	(300),LastName	varchar	(300),DisplayName	nvarchar(1200),Address1	varchar	(300),Address2	varchar	(300)
			,CountryName	varchar	(3000),StateName	varchar	(3000),CityName	varchar	(3000),PostalCode	varchar	(50)
			,PhoneNumber	varchar	(50),
			--Mobilenumber	varchar(50),AlternateMobileNumber	varchar(50),FaxNumber	varchar(30),
			IsDefaultBilling	bit 
			,IsDefaultShipping	bit	,IsActive	bit	,ExternalId	nvarchar(2000), GUID NVARCHAR(400)
		);
		
		--SET @SSQL = 'SELECT RowNumber,UserName,FirstName,LastName,MiddleName,BudgetAmount,Email,PhoneNumber,EmailOptIn,IsActive,ExternalId,GUID FROM '+ @TableName;
		SET @SSQL = 'SELECT RowNumber,' + @CsvColumnString + ',GUID FROM '+ @TableName;
		INSERT INTO @InsertCustomerAddress( RowNumber,UserName,FirstName,LastName,DisplayName,Address1,Address2,CountryName,
											StateName,CityName,PostalCode,PhoneNumber,
											IsDefaultBilling,IsActive,IsDefaultShipping,ExternalId,GUID )
		EXEC sys.sp_sqlexec @SSQL;

	
		-- start Functional Validation 

		-----------------------------------------------
		If @IsAllowGlobalLevelUserCreation = 'true'
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '19', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomerAddress AS ii
					   WHERE ii.UserName NOT IN 
					   (
						   SELECT UserName FROM AspNetZnodeUser   where PortalId = @PortalId
					   );
		Else 
				INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '19', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomerAddress AS ii
					   WHERE ii.UserName NOT IN 
					   (
						   SELECT UserName FROM AspNetZnodeUser   
					   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '35', 'IsDefaultBilling', IsDefaultBilling, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomerAddress IC where  exists (
		SElect TOP 1 1  from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
		INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
		INNER JOIN ZnodeUserAddress ZUA ON ZUA.UserId = ZU.UserId
		INNER JOIN ZnodeAddress ZA ON ZUA.AddressId = ZA.AddressId
		where ANZU.UserName = IC.UserName AND ZA.IsDefaultBilling =IC.IsDefaultBilling 
		AND ZA.IsDefaultShipping =IC.IsDefaultShipping )
			
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
					   SELECT '35', 'IsDefaultBilling', IsDefaultBilling, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
					   FROM @InsertCustomerAddress IC WHERE IsDefaultBilling = 0 AND IsDefaultShipping = 0 
				--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				--	   SELECT '35', 'UserName', UserName, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				--	   FROM @InsertCustomer AS ii
				--	   WHERE ii.UserName not like '%_@_%_.__%' 
		 
		--Note : Content page import is not required 
		
		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  

		DELETE FROM @InsertCustomerAddress
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);

		-- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertCustomerAddress
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- End


		-- Insert Product Data 
				
				DECLARE @InsertedUserAddress TABLE (AddressId  nvarchar(256), UserId nvarchar(max)) 
		-- Pending for discussion include one identity column for modify address
				
				--UPDATE ANU SET 
				--ANU.PhoneNumber	= IC.PhoneNumber
				--from AspNetZnodeUser ANZU INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				--INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				--INNER JOIN @InsertCustomerAddress IC ON ANZU.UserName = IC.UserName 
				--INNER JOIN ZnodeUserAddress ZUA ON ZUA.UserId = ZU.UserId
				--INNER JOIN ZnodeAddress ZA ON ZUA.AddressId = ZA.AddressId
				 
				--where Isnull(ANZU.PortalId,0) = Isnull(@PortalId ,0)

				Insert into ZnodeAddress (FirstName,LastName,DisplayName,Address1,Address2,Address3,CountryName,
											StateName,CityName,PostalCode,PhoneNumber,
											IsDefaultBilling,IsDefaultShipping,IsActive,ExternalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)		
				OUTPUT INSERTED.AddressId, INSERTED.Address3 INTO  @InsertedUserAddress (AddressId, UserId ) 			 
				SELECT IC.FirstName,IC.LastName,IC.DisplayName,IC.Address1,IC.Address2,convert(nvarchar(100),ZU.UserId),IC.CountryName,
				IC.StateName,IC.CityName,IC.PostalCode,IC.PhoneNumber,
				isnull(IC.IsDefaultBilling,0),isnull(IC.IsDefaultShipping,0),isnull(IC.IsActive,0),IC.ExternalId, @UserId , @GetDate, @UserId , @GetDate
				FROM AspNetZnodeUser ANZU 
				INNER JOIN ASPNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName 
				INNER JOIN ZnodeUser ZU ON ANU.ID = ZU.AspNetUserId	
				INNER JOIN @InsertCustomerAddress IC ON ANZU.UserName = IC.UserName 

			    insert into ZnodeUserAddress(UserId,AddressId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				select cast( UserId as int ) , Addressid , @UserId , @GetDate, @UserId , @GetDate from  @InsertedUserAddress
	
				UPDATE ZA SET ZA.Address3 = null 
				From ZnodeAddress ZA INNER JOIN @InsertedUserAddress IUA ON ZA.AddressId = IUA.AddressId 

		-- 'End'
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
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportPriceList')
BEGIN 
 DROP PROC Znode_ImportPriceList
END 
GO 
CREATE PROCEDURE [dbo].[Znode_ImportPriceList]
(
	@TableName nvarchar(100),
	@Status bit OUT, 
	@UserId int, 
	@ImportProcessLogId int,
	@NewGUId nvarchar(200),
	@PriceListId int )
AS 
	/*
	----Summary:  Import RetailPrice List 
	----		  Input XML data extracted in table format (table variable name:  #InsertPriceForValidation) by using  @xml.nodes 
	----		  Validate data column wise and store error log into @ErrorLogForInsertPrice table 
	----          Remove wrong data from table #InsertPriceForValidation and inserted correct data into @InsertPrice table for 
	----		  further processing (Importing to target database )
	---- Version 1 : Required Validation 
	---- UomName should not be null 
	---- Data for this RetailPrice list is already available  
	---- Version 2 : Required Validation 
	---- If UomName will be null then insert first record from UomTable and If UomName is wrong then raise error
	---- SKU with retailprice data is available with price list id will insert 
	---- multiple SKU with retail price is available then updated last sku details to price table and price tier table for respective price list
	----1. Import functionality should be provided only for single price list (Validate - Pending) 
	----  Tier price : TierStartQuantity should not between TierStartQuantity and TierEndQuantity for already existing SKU 
	----  In case of update details for SKU if any kind of price value will null then avoid it to update on existing value. 
	----2. From XML only SKU and RetailPrice is mandatory
	----3. SKUActivation date sholud be less than SKUExpriration date
	----4. Activation date sholud be less than Expiration date
	----5. If Tier RetailPrice has values and TierSartQuantity /TierEndQuantity or both has null value then it should not get updated/created.
	----6. ActivationDate and ExpirationDate value for tier price will be SKUActivationDate SKUExprirationDate 
	--- Change History : 
	--Remove column which is used to store range of qunatity by single column Quantity from table ZnodeTierProduct 
	--Manditory Retail price in Znodepricetable 
	-- SKUActivationfrom date and to date will used for tier price will store in single table ZnodePrice
	--Unit Testing   
	
*/
BEGIN
	BEGIN TRAN A;
	BEGIN TRY
	    DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
		
		IF OBJECT_ID('#InsertPriceForValidation', 'U') IS NOT NULL 
			DROP TABLE #InsertPriceForValidation
		ELSE 
			CREATE TABLE #InsertPriceForValidation 
			(SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL)
	
		--DECLARE #InsertPriceForValidation TABLE
		--( 
		--	SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL
		--);
		IF OBJECT_ID('#InsertPrice', 'U') IS NOT NULL 
			DROP TABLE #InsertPrice
		ELSE 
			CREATE TABLE #InsertPrice 
			( 
				SKU varchar(300), TierStartQuantity numeric(28, 6) NULL, RetailPrice numeric(28, 6) NULL, SalesPrice numeric(28, 6) NULL, TierPrice numeric(28, 6) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300)
			);
	


		DECLARE @SKU TABLE
		( 
				SKU nvarchar(300)
		);
		INSERT INTO @SKU
			   SELECT b.AttributeValue
			   FROM ZnodePimAttributeValue AS a
					INNER JOIN
					ZnodePimAttributeValueLocale AS b
					ON a.PimAttributeId = dbo.Fn_GetProductSKUAttributeId() AND 
					   a.PimAttributeValueId = b.PimAttributeValueId;


		--SET @CategoryXML =  REPLACE(@CategoryXML,'<?xml version="1.0" encoding="utf-16"?>','')

		DECLARE @RoundOffValue int, @MessageDisplay nvarchar(100); 
		-- Retrive RoundOff Value from global setting 

		SELECT @RoundOffValue = FeatureValues FROM ZnodeGlobalSetting WHERE FeatureName = 'PriceRoundOff';
	
		--@MessageDisplay will use to display validate message for input inventory value  

		DECLARE @sSql nvarchar(max);
		SET @sSql = ' Select @MessageDisplay_new = Convert(Numeric(28, '+CONVERT(nvarchar(200), @RoundOffValue)+'), 999999.000000000 ) ';
		EXEC SP_EXecutesql @sSql, N'@MessageDisplay_new NVARCHAR(100) OUT', @MessageDisplay_new = @MessageDisplay OUT;
		
		SET @SSQL = 'Select SKU,TierStartQuantity ,RetailPrice,SalesPrice,TierPrice,SKUActivationDate ,SKUExpirationDate ,RowNumber FROM '+@TableName;
		INSERT INTO #InsertPriceForValidation( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate, RowNumber )
		EXEC sys.sp_sqlexec @SSQL;


		-- 1)  Validation for SKU is pending Proper data not found and 
		--Discussion still open for Publish version where we create SKU and use the SKU code for validation 
		--Select * from ZnodePimAttributeValue  where PimAttributeId =248
		--select * from View_ZnodePimAttributeValue Vzpa Inner join ZnodePimAttribute Zpa on Vzpa.PimAttributeId=Zpa.PimAttributeId where Zpa.AttributeCode = 'SKU'
		--Select * from ZnodePimAttribute where AttributeCode = 'SKU'
		--------------------------------------------------------------------------------------
		--2)  Start Data Type Validation for XML Data  
		--------------------------------------------------------------------------------------			
		---------------------------------------------------------------------------------------
		---------If UOM will blank then retrive top -- Finctionality pending 
		---Validate 
		
		
		INSERT INTO #InsertPrice( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate, RowNumber )
			   SELECT SKU,
					  CASE
					  WHEN CONVERT(Varchar(100),TierStartQuantity) = '' THEN 0
					  ELSE CONVERT(numeric(28, 6), TierStartQuantity)
					  END, CONVERT(numeric(28, 6), RetailPrice),
															  CASE
															  WHEN SalesPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), SalesPrice)
															  END,
															  CASE
															  WHEN TierPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), TierPrice)
															  END, SKUActivationDate, SKUExpirationDate, RowNumber
			   FROM #InsertPriceForValidation;
				
		--------------------------------------------------------------------------------------
		--- start Functional Validation 
		--------------------------------------------------------------------------------------
		--- Verify SKU is present or not 

		--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--	   SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		--	   FROM @InsertPrice
		--	   WHERE SKU NOT IN
		--	   (
		--		   SELECT ZPAVL.AttributeValue
		--		   FROM ZnodePimAttribute AS ZPA
		--				INNER JOIN
		--				ZnodePimAttributeValue AS ZPAV
		--				ON ZPA.PimAttributeId = ZPAV.PimAttributeId
		--				INNER JOIN
		--				ZnodePimAttributeValueLocale AS ZPAVL
		--				ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
		--		   WHERE ZPA.AttributeCode = 'SKU'
		--	   );
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		SELECT '19', 'SKU', SKU, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		FROM #InsertPrice AS ii
		WHERE ii.SKU NOT IN
		(
			SELECT SKU
			FROM @SKU
		);

			 
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'RetailPrice', RetailPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE ISNULL(CAST(RetailPrice AS numeric(28, 6)), 0) <= 0 AND 
					 RetailPrice <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '39', 'SKUActivationDate', SKUActivationDate, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPrice AS IP
			   WHERE SKUActivationDate > SKUExpirationDate AND 
					 ISNULL(SKUExpirationDate, '') <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE( TierPrice IS NULL OR TierPrice = '0') AND  TierStartQuantity = '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierPrice', TierPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation WHERE( TierPrice IS NULL OR  TierPrice = '') AND TierStartQuantity <> 0;
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE ISNULL(CAST(TierStartQuantity AS numeric(28, 6)), 0) < 0 AND 
					 TierPrice <> '';
 
		-- End Function Validation 	
		---------------------------
		--- Delete Invalid Data after functional validation 
		DELETE FROM #InsertPrice
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  Guid = @NewGUId
		);
	
		-- Remove duplicate records 
		--insert into @RemoveDuplicateInsertPrice
		--(SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber )
		--Select SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber FROM @InsertPrice 
		
		--Delete from @InsertPrice 

		--insert into @InsertPrice (SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber)
		--Select SKU,TierStartQuantity, RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate 
		--, SKUActivationDate , SKUExpirationDate , RowNumber from @RemoveDuplicateInsertPrice rdip WHERE rdip.RowNumber IN
		--(
		--	SELECT MAX(ipi.RowNumber) FROM @InsertPrice ipi WHERE rdip.PriceListCode = ipi.PriceListCode AND rdip.SKU = ipi.SKU
		--);

		--Validate StartQuantity and EndQuantity from PriceTier : This validation only for existing data 
		--INSERT INTO @ErrorLogForInsertPrice (RowNumber,SKU,TierStartQuantity ,RetailPrice ,SalesPrice,TierPrice,Uom ,UnitSize,PriceListCode,PriceListName,CurrencyId ,ActivationDate,ExpirationDate,SKUActivationDate,SKUExpirationDate,SequenceNumber,ErrorDescription) 
		--Select IP.RowNumber,IP.SKU,IP.TierStartQuantity ,IP.RetailPrice ,IP.SalesPrice,IP.TierPrice,IP.Uom ,IP.UnitSize,IP.PriceListCode,IP.PriceListName,IP.CurrencyId ,IP.ActivationDate,IP.ExpirationDate,IP.SKUActivationDate,IP.SKUExpirationDate,IP.SequenceNumber,
		--'TierStartQuantity already exists in PriceTier table for SKU '
		--From @InsertPrice IP  Inner join
		--ZnodePriceList Zpl ON Zpl.Listcode = IP.PriceListcode and Zpl.ListName = IP.PriceListName
		--INNER JOIN ZnodeUOM Zu ON ltrim(rtrim(IP.Uom)) = ltrim(rtrim(Zu.Uom)) 
		--INNER JOIN ZnodePriceTier ZPT  ON ZPT.PriceListId = Zpl.PriceListId 
		--AND ZPT.SKU = IP.SKU
		--Where IP.TierStartQuantity  = ZPT.Quantity  
		--- Delete Invalid Data after  Validate StartQuantity and EndQuantity from PriceTier
		
		--INSERT INTO ZnodeUOM (Uom,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		--Select distinct ltrim(rtrim(Uom)) , @UserId,@GetDate,@UserId,@GetDate  from @InsertPrice 
		--where ltrim(rtrim(Uom)) not in (Select ltrim(rtrim(UOM)) From ZnodeUOM where UOM  is not null )
		
		DECLARE @FailedRecordCount BIGINT, @SuccessRecordCount BIGINT 
	
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;

		SELECT @SuccessRecordCount = COUNT(DISTINCT ROWNUMBER) FROM #InsertPrice WHERE 	ROWNUMBER IS NOT NULL ;

		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount 
		WHERE ImportProcessLogId = @ImportProcessLogId;

		UPDATE ZP
				SET ZP.SalesPrice = IP.SalesPrice, ZP.RetailPrice = CASE
				WHEN CONVERT(varchar(100), ISNULL(IP.RetailPrice, '')) <> '' THEN IP.RetailPrice
				END, ZP.ActivationDate = CASE
				WHEN ISNULL(IP.SKUActivationDate, '') <> '' THEN IP.SKUActivationDate
				ELSE NULL
				END, ZP.ExpirationDate = CASE
				WHEN ISNULL(IP.SKUExpirationDate, '') <> '' THEN IP.SKUExpirationDate
				ELSE NULL
				END, ZP.ModifiedBy = @UserId, ZP.ModifiedDate = @GetDate
		FROM #InsertPrice IP INNER JOIN ZnodePrice ZP ON ZP.PriceListId = @PriceListId AND  ZP.SKU = IP.SKU  
			 --Retrive last record from prince list of specific SKU ListCode and Name 									
		WHERE IP.RowNumber IN
		(
			SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
		);
		INSERT INTO ZnodePrice( PriceListId, SKU, SalesPrice, RetailPrice, ActivationDate, ExpirationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
			   SELECT @PriceListId, IP.SKU, IP.SalesPrice, IP.RetailPrice,
																						   CASE
																						   WHEN ISNULL(IP.SKUActivationDate, '') = '' THEN NULL
																						   ELSE IP.SKUActivationDate
																						   END,
																						   CASE
																						   WHEN ISNULL(IP.SKUExpirationDate, '') = '' THEN NULL
																						   ELSE IP.SKUExpirationDate
																						   END, @UserId, @GetDate, @UserId, @GetDate
			   FROM #InsertPrice AS IP
			   WHERE NOT EXISTS
			   (
				   SELECT TOP 1 1
				   FROM ZnodePrice
				   WHERE ZnodePrice.PriceListId = @PriceListId AND 
						 ZnodePrice.SKU = IP.SKU AND 
						 ISNULL(ZnodePrice.SalesPrice, 0) = ISNULL(IP.SalesPrice, 0) AND 
						 ZnodePrice.RetailPrice = IP.RetailPrice
			   ) AND 
					 IP.RowNumber IN
			   (
					SELECT MAX(IPI.RowNumber)
					FROM #InsertPrice AS IPI
					WHERE IPI.SKU = IP.SKU 
			   );
		IF EXISTS
		(
			SELECT TOP 1 1
			FROM #InsertPrice
			WHERE CONVERT(varchar(100), TierStartQuantity) <> '' AND 
				  (CONVERT(varchar(100), TierPrice) <> '')
		)
		BEGIN
			UPDATE ZPT
			  SET ZPT.Price = IP.TierPrice, ZPT.ModifiedBy = @UserId, ZPT.ModifiedDate = @GetDate
			FROM #InsertPrice IP INNER JOIN ZnodePriceTier ZPT ON ZPT.PriceListId = @PriceListId AND  ZPT.SKU = IP.SKU AND ZPT.Quantity = IP.TierStartQuantity 
		    --Retrive last record from prince list of specific SKU ListCode and Name 
			WHERE IP.RowNumber IN
			(
				SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
			);
			INSERT INTO ZnodePriceTier( PriceListId, SKU, Price, Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )
				   SELECT @PriceListId, IP.SKU, IP.TierPrice, IP.TierStartQuantity,  @UserId, @GetDate, @UserId, @GetDate
				   FROM #InsertPrice AS IP 
				   WHERE NOT EXISTS
				   (
					   SELECT TOP 1 1 FROM ZnodePriceTier WHERE ZnodePriceTier.PriceListId = @PriceListId AND  ZnodePriceTier.SKU = IP.SKU AND 
							 ZnodePriceTier.Quantity = IP.TierStartQuantity
				   ) AND  IP.RowNumber IN
				   (
					   SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU AND  IPI.TierStartQuantity = IP.TierStartQuantity
				   );
		END;  
		--SELECT @PriceListId ID , cast(1 As Bit ) Status  
		--SELECT RowNumber , ErrorDescription , SKU , TierStartQuantity , RetailPrice , SalesPrice , TierPrice , Uom , UnitSize , PriceListCode , PriceListName , CurrencyId , ActivationDate , ExpirationDate
		--FROM @ErrorLogForInsertPrice;
		SET @Status = 1;
		UPDATE ZnodeImportProcessLog
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = @GetDate
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- COMMIT TRAN ImportProducts;
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
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportSEODetails')
BEGIN 
 DROP PROC Znode_ImportSEODetails
END 
GO 
CREATE PROCEDURE [dbo].[Znode_ImportSEODetails](
	  @TableName nvarchar(100), @Status bit OUT, @UserId int, @ImportProcessLogId int, @NewGUId nvarchar(200), @LocaleId int= 0,@PortalId int ,@CsvColumnString nvarchar(max))
AS
	--------------------------------------------------------------------------------------
	-- Summary :  Import SEO Details
	
	-- Unit Testing : 
	--------------------------------------------------------------------------------------

BEGIN
	BEGIN TRAN A;
	BEGIN TRY
		DECLARE @MessageDisplay nvarchar(100), @SSQL nvarchar(max);
		DECLARE @GetDate datetime= dbo.Fn_GetDate();
		-- Retrive RoundOff Value from global setting 

		-- Three type of import required three table varible for product , category and brand
		DECLARE @InsertSEODetails TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300), 
			IsRedirect	bit	,MetaInformation	nvarchar(max),PortalId	int	,SEOUrl	nvarchar(max),IsActive bit,
			SEOTitle	nvarchar(max),SEODescription	nvarchar(max),SEOKeywords	nvarchar(max), GUID nvarchar(400)
			--Index Ind_ImportType (ImportType),Index Ind_Code (Code)
		);

		DECLARE @InsertSEODetailsOFProducts TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300), 
			IsRedirect	bit	,MetaInformation	nvarchar(max),PortalId	int	,SEOUrl	nvarchar(max),IsActive bit,
			SEOTitle	nvarchar(max),SEODescription	nvarchar(max),SEOKeywords	nvarchar(max), GUID nvarchar(400)
			--Index Ind_ImportType (ImportType),Index Ind_Code (Code)
		);

		DECLARE @InsertSEODetailsOFCategory TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300), 
			IsRedirect	bit	,MetaInformation	nvarchar(max),PortalId	int	,SEOUrl	nvarchar(max),IsActive bit,
			SEOTitle	nvarchar(max),SEODescription	nvarchar(max),SEOKeywords	nvarchar(max), GUID nvarchar(400)
			--Index Ind_ImportType (ImportType),Index Ind_Code (Code)
		);

		DECLARE @InsertSEODetailsOFBrand TABLE
		( 
			RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300), 
			IsRedirect	bit	,MetaInformation	nvarchar(max),PortalId	int	,SEOUrl	nvarchar(max),IsActive bit,
			SEOTitle	nvarchar(max),SEODescription	nvarchar(max),SEOKeywords	nvarchar(max), GUID nvarchar(400)
			--Index Ind_ImportType (ImportType),Index Ind_Code (Code)
		);

		
		DECLARE @InsertedZnodeCMSSEODetail TABLE
		( 
			CMSSEODetailId int , SEOId int, CMSSEOTypeId int
		);
		
		--SET @SSQL = 'Select RowNumber,ImportType,Code,IsRedirect,MetaInformation,SEOUrl,IsActive,SEOTitle,SEODescription,SEOKeywords,GUID  FROM '+@TableName;
		SET @SSQL = 'Select RowNumber,'+@CsvColumnString+',GUID  FROM '+@TableName;

		
		INSERT INTO @InsertSEODetails(RowNumber,ImportType,Code,IsRedirect,MetaInformation,SEOUrl,IsActive,SEOTitle,SEODescription,SEOKeywords,GUID )
		EXEC sys.sp_sqlexec @SSQL;
	
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '30', 'SEOUrl', SEOUrl, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
			   FROM @InsertSEODetails AS ii 
			   where ii.SEOURL in (Select ISD.SEOURL from @InsertSEODetails ISD Group by ISD.SEOUrl having count(*) > 1 ) 

		DELETE FROM @InsertSEODetails
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);

		SET @SSQL = 'Select RowNumber,' +@CsvColumnString +',GUID  FROM '+@TableName
		+ ' Where ImportType = ''Product'' ';
		INSERT INTO @InsertSEODetailsOFProducts(  RowNumber , ImportType , Code , 
			IsRedirect	,MetaInformation	,SEOUrl	,IsActive ,
			SEOTitle	,SEODescription	,SEOKeywords	, GUID )
		EXEC sys.sp_sqlexec @SSQL;

		SET @SSQL = 'Select RowNumber,' +@CsvColumnString +',GUID  FROM '+@TableName
		+ ' Where ImportType = ''Category'' ';
		INSERT INTO @InsertSEODetailsOFCategory( RowNumber , ImportType , Code , 
			IsRedirect	,MetaInformation,SEOUrl	,IsActive ,
			SEOTitle	,SEODescription	,SEOKeywords	, GUID )
		EXEC sys.sp_sqlexec @SSQL;

		SET @SSQL = 'Select RowNumber,' +@CsvColumnString +',GUID  FROM '+@TableName
		+ ' Where ImportType = ''Brand'' ';
		INSERT INTO @InsertSEODetailsOFBrand( RowNumber , ImportType , Code , 
			IsRedirect	,MetaInformation	,SEOUrl	,IsActive ,
			SEOTitle	,SEODescription	,SEOKeywords	, GUID )
		EXEC sys.sp_sqlexec @SSQL;


	    -- start Functional Validation 
		--1. Product
		--2. Category
		--3. Content Page
		--4. Brand
		-----------------------------------------------

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'ImportType', ImportType, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
			   FROM @InsertSEODetails AS ii
			   WHERE ii.ImportType NOT in 
			   (
				   Select NAME from ZnodeCMSSEOType where NAME <> 'Content Page'
			   );

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'SKU', CODE, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
			   FROM @InsertSEODetailsOFProducts AS ii
			   WHERE ii.CODE NOT in 
			   (
				   Select SKU from ZnodePublishProductDetail ZPPD
					INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishProductId = ZPPD.PublishProductId
					INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId 
					AND ZPC.PortalId  = @PortalId AND SKU is not null 
			   )  AND ImportType = 'Product';


		
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'Category', CODE, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
			   FROM @InsertSEODetailsOFCategory AS ii
			   WHERE ii.CODE NOT in 
			   (
				   Select PublishCategoryName from ZnodePublishCategoryDetail ZPPD
				   	INNER JOIN ZnodePublishCategory ZPP ON ZPP.PublishCategoryId = ZPPD.PublishCategoryId
					INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId 
				   where ZPPD.PublishCategoryName is not null  AND   ZPC.PortalId = @PortalId
			   )  AND ImportType = 'Category';

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '19', 'Brand', CODE, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
			   FROM @InsertSEODetailsOFBrand AS ii
			   WHERE ii.CODE NOT in 
			   (
				   Select BrandCode from ZnodeBrandDetails 
			   )  AND ImportType = 'Brand';
		
		
		--Note : Content page import is not required 
		
		-- End Function Validation 	
		-----------------------------------------------
		--- Delete Invalid Data after functional validatin  

		DELETE FROM @InsertSEODetailsOFProducts
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);

		DELETE FROM @InsertSEODetailsOFCategory
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);

		DELETE FROM @InsertSEODetailsOFBrand
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null 
			--AND GUID = @NewGUID
		);

		-- Insert Product Data 
		If Exists (Select top 1 1 from @InsertSEODetailsOFProducts)
		Begin
			Update ZCSD SET ZCSD.IsRedirect = ISD.IsRedirect ,
						   ZCSD.MetaInformation =  ISD.MetaInformation,
						   ZCSD.SEOUrl=  ISD.SEOUrl
			FROM 
			@InsertSEODetailsOFProducts ISD  INNER JOIN ZnodePublishProductDetail ZPPD ON ISD.Code = ZPPD.SKU 
			INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = 1 AND ZCSD.SEOId = ZPPD.PublishProductId
			INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishProductId = ZPPD.PublishProductId
			INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId AND   ZPC.PortalId = ZCSD.PortalId
			where  ZCSD.PortalId  =@PortalId;
			
			Update ZCSDL SET ZCSDL.SEOTitle = ISD.SEOTitle
							,ZCSDL.SEODescription = ISD.SEODescription
							,ZCSDL.SEOKeywords= ISD.SEOKeywords
 			FROM 
			@InsertSEODetailsOFProducts ISD  INNER JOIN ZnodePublishProductDetail ZPPD ON ISD.Code = ZPPD.SKU 
			INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = 1 AND ZCSD.SEOId = ZPPD.PublishProductId
			INNER JOIN ZnodeCMSSEODetailLocale ZCSDL ON ZCSD.CMSSEODetailId = ZCSDL.CMSSEODetailId
			INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishProductId = ZPPD.PublishProductId
			INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId AND   ZPC.PortalId = ZCSD.PortalId
			where  ZCSD.PortalId  =@PortalId AND ZCSDL.LocaleId = @LocaleId; 

			Delete from @InsertedZnodeCMSSEODetail
			INSERT INTO ZnodeCMSSEODetail(CMSSEOTypeId,SEOId,IsRedirect,MetaInformation,PortalId,SEOUrl,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		
			OUTPUT Inserted.CMSSEODetailId,Inserted.SEOId,Inserted.CMSSEOTypeId INTO @InsertedZnodeCMSSEODetail
		
			Select Distinct 1,ZPPD.PublishProductId , ISD.IsRedirect,ISD.MetaInformation,@PortalId,ISD.SEOUrl,@USerId, @GetDate,@USerId, @GetDate from 
			@InsertSEODetailsOFProducts ISD  INNER JOIN ZnodePublishProductDetail ZPPD ON ISD.Code = ZPPD.SKU 
			INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishProductId = ZPPD.PublishProductId
			INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId 
			where  ZPC.PortalId  =@PortalId AND
			 NOT EXISTS (Select TOP 1 1 from ZnodeCMSSEODetail ZCSD where ZCSD.CMSSEOTypeId = 1 AND ZCSD.SEOId  = ZPPD.PublishProductId
			 and  ZCSD .PortalId =@PortalId   );
		
        	insert into ZnodeCMSSEODetailLocale(CMSSEODetailId,LocaleId,SEOTitle,SEODescription,SEOKeywords,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select Distinct IZCSD.CMSSEODetailId,@LocaleId,ISD.SEOTitle,ISD.SEODescription,ISD.SEOKeywords,@USerId, @GetDate,@USerId, @GetDate from 
			@InsertedZnodeCMSSEODetail IZCSD INNER JOIN ZnodePublishProductDetail ZPPD ON IZCSD.SEOId = ZPPD.PublishProductId AND IZCSD.CMSSEOTypeId =1  
											 INNER JOIN @InsertSEODetailsOFProducts ISD ON ZPPD.SKU = ISD.Code 
											 INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishProductId = ZPPD.PublishProductId
											 INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId 
			where  ZPC.PortalId  =@PortalId 
		END

		-- Insert Category Data 
		
		If Exists (Select top 1 1 from @InsertSEODetailsOFCategory)
		Begin

			Update ZCSD SET ZCSD.IsRedirect = ISD.IsRedirect ,
						   ZCSD.MetaInformation =  ISD.MetaInformation,
						   ZCSD.SEOUrl=  ISD.SEOUrl
			FROM 
			@InsertSEODetailsOFCategory ISD  INNER JOIN ZnodePublishCategoryDetail ZPPD ON ISD.Code = ZPPD.PublishCategoryName 
			INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = 2 AND ZCSD.SEOId = ZPPD.PublishCategoryId
			where  ZCSD.PortalId  =@PortalId;
			
			Update ZCSDL SET ZCSDL.SEOTitle = ISD.SEOTitle
							,ZCSDL.SEODescription = ISD.SEODescription
							,ZCSDL.SEOKeywords= ISD.SEOKeywords
 			FROM 
			@InsertSEODetailsOFCategory ISD  INNER JOIN ZnodePublishCategoryDetail ZPPD ON ISD.Code = ZPPD.PublishCategoryName 
			INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = 2 AND ZCSD.SEOId = ZPPD.PublishCategoryId
			INNER JOIN ZnodeCMSSEODetailLocale ZCSDL ON ZCSD.CMSSEODetailId = ZCSDL.CMSSEODetailId
			where  ZCSD.PortalId  =@PortalId AND ZCSDL.LocaleId = @LocaleId; 

			Delete from @InsertedZnodeCMSSEODetail
			INSERT INTO ZnodeCMSSEODetail(CMSSEOTypeId,SEOId,IsRedirect,MetaInformation,PortalId,SEOUrl,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		
			OUTPUT Inserted.CMSSEODetailId,Inserted.SEOId,Inserted.CMSSEOTypeId INTO @InsertedZnodeCMSSEODetail
		
			Select Distinct 2,ZPPD.PublishCategoryId , ISD.IsRedirect,ISD.MetaInformation,@PortalId,ISD.SEOUrl,@USerId, @GetDate,@USerId, @GetDate from 
			@InsertSEODetailsOFCategory ISD  INNER JOIN ZnodePublishCategoryDetail ZPPD ON ISD.Code = ZPPD.PublishCategoryName 
			INNER JOIN ZnodePublishCategory ZPP ON ZPP.PublishCategoryId = ZPPD.PublishCategoryId
			INNER JOIN ZnodePortalCatalog ZPC ON ZPC.PublishCatalogId = ZPP.PublishCatalogId AND   ZPC.PortalId = @PortalId
			where NOT EXISTS (Select TOP 1 1 from ZnodeCMSSEODetail ZCSD where ZCSD.CMSSEOTypeId = 2 AND ZCSD.SEOId  = ZPPD.PublishCategoryId AND ZCSD.PortalId = @PortalId );
		


			insert into ZnodeCMSSEODetailLocale(CMSSEODetailId,LocaleId,SEOTitle,SEODescription,SEOKeywords,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select Distinct IZCSD.CMSSEODetailId,@LocaleId,ISD.SEOTitle,ISD.SEODescription,ISD.SEOKeywords,@USerId, @GetDate,@USerId, @GetDate from 
			@InsertedZnodeCMSSEODetail IZCSD INNER JOIN ZnodePublishCategoryDetail ZPPD ON IZCSD.SEOId = ZPPD.PublishCategoryId AND IZCSD.CMSSEOTypeId =2  
											 INNER JOIN @InsertSEODetailsOFCategory ISD ON ZPPD.PublishCategoryName = ISD.Code 
		END
										 
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
GO
IF EXISTS (SELECT TOP 1 1 FROM SYS.PROCEDURES WHERE Name = 'Znode_ImportProcessCustomer')
BEGIN 
 DROP PROC Znode_ImportProcessCustomer
END 
GO 
CREATE   PROCEDURE [dbo].[Znode_ImportProcessCustomer](@TblGUID nvarchar(255) = '' ,@ERPTaskSchedulerId  int )
AS
BEGIN

	SET NOCOUNT ON;
	Declare @NewuGuId nvarchar(255)
	set @NewuGuId = newid()
	Declare @CurrencyId int ,@PortalId int,@TemplateId INT ,@ImportHeadId INT 
	
	DECLARE @LocaleId  int = dbo.Fn_GetDefaultLocaleId()
	SELECT TOP 1 @PortalId  = PortalId FROM dbo.ZnodePortal

	Select @CurrencyId = CurrencyId  from ZnodeCurrency where CurrencyCode in (Select FeatureValues from   ZnodeGlobalSetting where FeatureName = 'Currency') 

	DECLARE @CreateTableScriptSql NVARCHAR(MAX) = '', 
		    @InsertColumnName NVARCHAR(MAX), 
			@ImportTableColumnName NVARCHAR(MAX),
			@TableName NVARCHAR(255) = 'MAGSOLD',			
			@Sql NVARCHAR(MAX) = '',
			@PriceListId int,
			@RowNum int, 
			@MaxRowNum int,
			@FirstStep nvarchar(255),
			@PriceTableName  nvarchar(255),
			@WarehouseCode varchar(100)
			
	   IF OBJECT_ID('tempdb..##Customer', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##Customer

	   IF OBJECT_ID('tempdb.dbo.##CustomerAddress', 'U') IS NOT NULL 
		DROP TABLE tempdb.dbo.##CustomerAddress

		--SELECT @CustomerTableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =6 --AND ImportTableName = 'PRDH'
		--SELECT @CustomerAddTableName = ImportTableName FROM ZnodeImportTableDetail WHERE ImportTableNature = 'Insert' AND ImportHeadId =7 --AND ImportTableName = 'PRDH'

	    SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
	    -- User Data
	    	SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
				
			--Create Temp table for customer 
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'CustomerTemplate'
			SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'Customer'

			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##Customer ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
			EXEC ( @CreateTableScriptSql )
		
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Insert'' 
			AND ImportHeadId = @ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD''  
			AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Insert'' 
			AND ImportHeadId = @ImportHeadId AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@ImportHeadId int , @TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT',@ImportHeadId = @ImportHeadId ,  @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT
	
			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##Customer ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##Customer  SET IsActive =  1 , LastName = ISNULL(LastName,''.'') , Email = UserName '
				EXEC sp_executesql @SQL

				SET @SQL = 'Select * from  tempdb..##Customer' 
				EXEC sp_executesql @SQL
				
				EXEC Znode_ImportData @TableName = 'tempdb..##Customer' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				 @UserId = 2,@PortalId = 1,@LocaleId = 1,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 0 , @IsDoNotStartJob = 1, @StepName = 'Import' ,@ERPTaskSchedulerId  = @ERPTaskSchedulerId
			END

			-- User Address Data
			SELECT @TemplateId= ImportTemplateId FROM dbo.ZnodeImportTemplate WHERE TemplateName = 'CustomerAddressTemplate'
			SELECT @ImportHeadId= ImportHeadId FROM dbo.ZnodeImportHead WHERE Name = 'CustomerAddress'
			SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			SET @CreateTableScriptSql = ''
			
			--Create Temp table for customer Address 
			SELECT @CreateTableScriptSql = 'CREATE TABLE tempdb..##CustomerAddress ('+SUBSTRING ((Select ',' +  ISNULL([TargetColumnName] ,'NULL')+ ' nvarchar(max)' 
			FROM [dbo].[ZnodeImportTemplateMapping]
			WHERE [ImportTemplateId]= @TemplateId FOR XML PATH ('')),2,4000)+' , GUID nvarchar(255) )'
			EXEC ( @CreateTableScriptSql )
		
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSOLD'' ) 
			AND ITD.ImportTableName = ''MAGSOLD'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@ImportHeadId int ,@TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT',@ImportHeadId = @ImportHeadId,@TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##CustomerAddress ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL
				SET @SQL = 'Update tempdb..##CustomerAddress  SET IsActive =  1 '
				EXEC sp_executesql @SQL
			END

			--Append address data from shipping table 
	
			
			SET @InsertColumnName = ''  
			SET @ImportTableColumnName = ''
			Declare @CustomerTableName  nvarchar(255)
			SET @CustomerTableName = @TableName 
			SET @TableName = 'MAGSHIP'	
			SET @TableName = 'tempdb..[##' + @TableName + '_' + @TblGUID + ']' 
			SET @Sql = ' 
			SELECT @InsertColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ITCD.BaseImportColumn +'']''  ,''NULL'')
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSHIP'' ) 
			AND ITD.ImportTableName = ''MAGSHIP''  AND Isnull(ITCD.BaseImportColumn,'''' ) <> ''''  FOR XML PATH ('''')),2,4000)

			SELECT @ImportTableColumnName = SUBSTRING ((Select '','' +  ISNULL(''[''+ ImportTableColumnName +'']''  ,''NULL'') 
			FROM [ZnodeImportTableColumnDetail] ITCD INNER JOIN [ZnodeImportTableDetail] ITD 
			ON ITCD.ImportTableId = ITD.ImportTableId
			WHERE  
			ITD.ImportTableId in (SELECT ImportTableId FROM ZnodeImportTableDetail WHERE ImportTableNature = ''Update'' 
			AND ImportHeadId =@ImportHeadId	AND ImportTableName = ''MAGSHIP'' ) 
			AND ITD.ImportTableName = ''MAGSHIP'' AND Isnull(ITCD.BaseImportColumn,'''' ) <> '''' FOR XML PATH ('''')),2,4000)'

			EXEC sp_executesql @SQL, N'@ImportHeadId int , @TableName VARCHAR(200),@InsertColumnName NVARCHAR(MAX) OUTPUT, @ImportTableColumnName  NVARCHAR(MAX) OUTPUT', @ImportHeadId=@ImportHeadId , @TableName = @TableName, @InsertColumnName = @InsertColumnName OUTPUT, @ImportTableColumnName = @ImportTableColumnName OUTPUT

			IF( LEN(@InsertColumnName) > 0 )
			BEGIN
				SET @SQL = 'INSERT INTO tempdb..##CustomerAddress ( '+@InsertColumnName+',GUID )
					SELECT '+ @ImportTableColumnName +',''' + @TblGUID  + ''' 
					FROM '+ @TableName + ' PRD '
					EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##CustomerAddress  SET IsActive =  1 '
				EXEC sp_executesql @SQL

				SET @SQL = 'Update A SET A.UserName = b.[EMAIL LOGON ID] from tempdb..##CustomerAddress A INNER JOIN '+@CustomerTableName+' B ON
				            A.ExternalId = b.[Sold-to number] AND A.UserName is null   '
				EXEC sp_executesql @SQL

				SET @SQL = 'Update tempdb..##CustomerAddress  SET LastName = ISNULL(LastName,''.''),FirstName  = ISNULL(UserName,'''')'
				EXEC sp_executesql @SQL



				SET @SQL = 'Select * from  tempdb..##CustomerAddress' 
				EXEC sp_executesql @SQL
				
				EXEC Znode_ImportData @TableName = 'tempdb..##CustomerAddress' ,@NewGUID = @TblGUID ,@TemplateId = @TemplateId,
				@UserId = 2,@PortalId = 1,@LocaleId = 1,@DefaultFamilyId = 0,@PriceListId = 0, @CountryCode = ''--, @IsDebug =1 
				,@IsDoNotCreateJob = 1 , @IsDoNotStartJob = 0, @StepName = 'Import1', @StartStepName  ='Import',@step_id = 2 
			    ,@Nextstep_id  = 1,@ERPTaskSchedulerId  =@ERPTaskSchedulerId 
				select 'Job Successfully Started'
			END

END


GO 
INSERT INTO AspNet_SqlCacheTablesForChangeNotification(tableName
,notificationCreated
,changeId )
SELECT 'View_GetLocaleDetails',GETDATE(),0 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM  AspNet_SqlCacheTablesForChangeNotification TRTR WHERE tableName = 'View_GetLocaleDetails')

INSERT INTO AspNet_SqlCacheTablesForChangeNotification(tableName
,notificationCreated
,changeId )
SELECT 'ZnodeMediaConfiguration',GETDATE(),0 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM  AspNet_SqlCacheTablesForChangeNotification TRTR WHERE tableName = 'ZnodeMediaConfiguration')

GO 

GO 
DECLARE @MenuId INT 
INSERT INTO ZnodeMenu (ParentMenuId,MenuName,MenuSequence,AreaName,ControllerName,ActionName,CSSClassName,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 	(SELECT MenuId FROM ZnodeMenu WHERE MenuName = 'CMS' AND ControllerName='Content' AND ActionName='ContentPageList'),	'Blogs & News',	7	,NULL	,'BlogNews'	,'BlogNewsList'	,NULL,1,	2	,GETDATE()	,2,	GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeMenu WHERE MenuName  =  'Blogs & News' AND ControllerName =  'BlogNews')
SET @MenuId = SCOPE_IDENTITY()


INSERT INTO ZnodeActions(ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'BlogNews'	,'AddBlogNews',0,2,GETDATE(),2,GETDATE() 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActions WHERE ControllerName = 'BlogNews' AND ActionName = 'AddBlogNews')
INSERT INTO ZnodeActions(ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'BlogNews'	,'EditBlogNews'	,0,2,GETDATE(),2,GETDATE() 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActions WHERE ControllerName = 'BlogNews' AND ActionName = 'EditBlogNews')
INSERT INTO ZnodeActions(ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'BlogNews'	,'BlogNewsCommentList' ,0,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActions WHERE ControllerName = 'BlogNews' AND ActionName = 'BlogNewsCommentList')
INSERT INTO ZnodeActions(ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'Store'	,'GetAnalytics'	,0,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActions WHERE ControllerName = 'BlogNews' AND ActionName = 'GetAnalytics')
INSERT INTO ZnodeActions(ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'Store'	,'GetRobotsTxt'	,0,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActions WHERE ControllerName = 'BlogNews' AND ActionName = 'GetRobotsTxt')

INSERT INTO ZnodeActionMenu (MenuId,ActionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @MenuId , ActionId , 2,GETDATE(),2,GETDATE()
FROM ZnodeActions ZA 
WHERE ControllerName = 'BlogNews' AND ActionName IN ('AddBlogNews','EditBlogNews','BlogNewsCommentList')
AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActionMenu ZAM WHERE ZAM.ActionId = ZA.ActionId AND ZAM.MenuId = @MenuId)
INSERT INTO ZnodeActionMenu (MenuId,ActionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT (SELECT MenuId FROM ZnodeMenu WHERE MenuName = 'Stores' AND ControllerName='Store' AND ActionName='List') , ActionId , 2,GETDATE(),2,GETDATE()
FROM ZnodeActions ZA 
WHERE ControllerName = 'Store' AND ActionName IN ('GetAnalytics','GetRobotsTxt')
AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodeActionMenu ZAM WHERE ZAM.ActionId = ZA.ActionId AND ZAM.MenuId = (SELECT MenuId FROM ZnodeMenu WHERE MenuName = 'Stores' AND ControllerName='Store' AND ActionName='List'))
DELETE FROM ZnodeActions WHERE ControllerName = 'Account' AND ActionName IN ('SetDefaultProfile') 
GO 
INSERT INTO ZnodeApplicationSetting (GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName
,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'Table','ZnodeBlogNewsCommentList','<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>BlogNewsCommentId</name>
    <headertext>Checkbox</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>BlogNewsTitle</name>
    <headertext>Title</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>BlogNewsType</name>
    <headertext>Type</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>StoreName</name>
    <headertext>Store Name</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>Customer</name>
    <headertext>Customer</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>LocaleName</name>
    <headertext>Locale</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>BlogNewsComment</name>
    <headertext>Comment</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>8</id>
    <name>IsApproved</name>
    <headertext>Is Approved</headertext>
    <width>60</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>y</iscontrol>
    <controltype>DropDown</controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>9</id>
    <name>CreatedDate</name>
    <headertext>Created Date </headertext>
    <width>60</width>
    <datatype>DateTime</datatype>
    <columntype>DateTime</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>10</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/BlogNews/EditBlogNewsComment|/BlogNews/DeleteBlogNewsComment</manageactionurl>
    <manageparamfield>blogNewsCommentId|blogNewsCommentId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>','ZnodeBlogNewsCommentList'	,'ZnodeBlogNewsCommentList'	,'ZnodeBlogNewsCommentList',0,NULL,	NULL,	NULL,	NULL,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1  1  FROM ZnodeApplicationSetting WHERE ItemNAme = 'ZnodeBlogNewsCommentList')
GO 
INSERT INTO ZnodeApplicationSetting (GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName
,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'Table','ZnodeSearchSynonymsList','<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>SearchSynonymsId</name>
    <headertext>Checkbox</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>SearchSynonymsId</name>
    <headertext>ID</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/SearchConfiguration/EditSearchSynonyms</islinkactionurl>
    <islinkparamfield>searchSynonymsId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>OriginalTerm</name>
    <headertext>Original Term</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>ReplacedBy</name>
    <headertext>Replaced By</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>IsBidirectional</name>
    <headertext>Is Bidirectional</headertext>
    <width>60</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/SearchConfiguration/EditSearchSynonyms|/SearchConfiguration/DeleteSearchSynonyms</manageactionurl>
    <manageparamfield>searchSynonymsId|searchSynonymsId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>','ZnodeSearchSynonymsList'	,'ZnodeSearchSynonymsList'	,'ZnodeSearchSynonymsList',0,NULL,	NULL,	NULL,	NULL,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1  1  FROM ZnodeApplicationSetting WHERE ItemNAme = 'ZnodeSearchSynonymsList')
GO 
INSERT INTO ZnodeApplicationSetting (GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName
,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'Table','ZnodeSearchKeywordsRedirectList','<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>SearchKeywordsRedirectId</name>
    <headertext>Checkbox</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>SearchKeywordsRedirectId</name>
    <headertext>ID</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/SearchConfiguration/EditSearchKeywords</islinkactionurl>
    <islinkparamfield>SearchKeywordsRedirectId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>Keywords</name>
    <headertext>Keywords</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>URL</name>
    <headertext>URL</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/SearchConfiguration/EditSearchKeyword|/SearchConfiguration/DeleteSearchKeywordsRedirect</manageactionurl>
    <manageparamfield>SearchKeywordsRedirectId|SearchKeywordsRedirectId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>','ZnodeSearchKeywordsRedirectList'	,'ZnodeSearchKeywordsRedirectList'	,'ZnodeSearchKeywordsRedirectList',0,NULL,	NULL,	NULL,	NULL,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1  1  FROM ZnodeApplicationSetting WHERE ItemNAme = 'ZnodeSearchKeywordsRedirectList')
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>TaxClassId</name>
    <headertext>Checkbox</headertext>
    <width>20</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>Name</name>
    <headertext>Name</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/TaxClass/Edit</islinkactionurl>
    <islinkparamfield>taxClassId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>DisplayOrder</name>
    <headertext>Display Order</headertext>
    <width>30</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>IsActive</name>
    <headertext>Enable</headertext>
    <width>20</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>y</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>y</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>taxClassId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/TaxClass/Edit|/TaxClass/Delete</manageactionurl>
    <manageparamfield>taxClassId|taxClassId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>SKU</name>
    <headertext>SKU</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>y</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>y</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'ZnodeTaxClass'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>PimProductId</name>
    <headertext>Checkbox</headertext>
    <width>20</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>PimProductId</checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>Image</name>
    <headertext>Image</headertext>
    <width>20</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>ProductImage,ProductName</imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>imageicon</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>ProductName</name>
    <headertext>Product Name</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/PIM/Products/Edit</islinkactionurl>
    <islinkparamfield>PimProductId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>ProductType</name>
    <headertext>Product Type</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>AttributeFamily</name>
    <headertext>Attribute Family</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>SKU</name>
    <headertext>SKU</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>PublishStatus</name>
    <headertext>Publish Status</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>8</id>
    <name>IsActive</name>
    <headertext>Status</headertext>
    <width>0</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>9</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Edit|Copy|Delete|Publish</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Copy|Delete|Publish</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/PIM/Products/Edit|/PIM/Products/Copy|/PIM/Products/Delete|/PIM/Products/PublishProduct</manageactionurl>
    <manageparamfield>PimProductId|PimProductId|PimProductId|PimProductId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'View_ManageProductList'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>PimAttributeId</name><headertext>Checkbox</headertext><width>20</width><datatype>String</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>y</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>AttributeCode</name><headertext>Attribute Code</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>y</isallowlink><islinkactionurl>/PIM/CategoryAttribute/Edit</islinkactionurl><islinkparamfield>PimAttributeId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>AttributeName</name><headertext>Attribute Label</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl>/Attributes/Attributes/Edit</islinkactionurl><islinkparamfield>MediaAttributeId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>y</allowdetailview></column><column><id>4</id><name>AttributeTypeName</name><headertext>Attribute Type</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl>/PIM/PIMAttribute/Edit</islinkactionurl><islinkparamfield>PimAttributeId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>y</allowdetailview></column><column><id>5</id><name>IsRequired</name><headertext>Is Required</headertext><width>10</width><datatype>Boolean</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>6</id><name>IsLocalizable</name><headertext>Is Localizable</headertext><width>10</width><datatype>Boolean</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>7</id><name>IsSystemDefined</name><headertext>Is SystemDefined</headertext><width>10</width><datatype>Boolean</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>8</id><name>Manage</name><headertext>Action</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Edit|Delete</format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Edit|Delete</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl>/PIM/CategoryAttribute/Edit|/PIM/CategoryAttribute/Delete</manageactionurl><manageparamfield>PimAttributeId|pimAttributeId</manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
WHERE ItemName = 'ZnodeCategoryAttribute'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>PimCategoryId</name>
    <headertext>Checkbox</headertext>
    <width>30</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>PimCategoryId</name>
    <headertext>ID</headertext>
    <width>40</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>Image</name>
    <headertext>Image</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>Edit</format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>PimCategoryId</checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>CategoryImage,CategoryName</imageparamfield>
    <manageactionurl>/Pim/Category/Edit</manageactionurl>
    <manageparamfield>PimCategoryId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>imageicon</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>CategoryName</name>
    <headertext>Category Name</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/PIM/Category/Edit</islinkactionurl>
    <islinkparamfield>PimCategoryId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>CategoryTitle</name>
    <headertext>Category Title</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>AttributeFamily</name>
    <headertext>Attribute Family</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/PIM/Category/Edit|/PIM/Category/Delete</manageactionurl>
    <manageparamfield>PimCategoryId|PimCategoryId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'View_PimCategoryDetail'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>PimProductId</name>
    <headertext>Checkbox</headertext>
    <width>30</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>PimProductId</name>
    <headertext>ID</headertext>
    <width>30</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>Image</name>
    <headertext>Image</headertext>
    <width>20</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>ImagePath,ProductName</imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>imageicon</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>ProductName</name>
    <headertext>Product Name</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>ProductType</name>
    <headertext>Product Type</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>AttributeFamily</name>
    <headertext>Attribute Family</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>y</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>SKU</name>
    <headertext>SKU</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>8</id>
    <name>Assortment</name>
    <headertext>Assortment</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>9</id>
    <name>IsActive</name>
    <headertext>Status</headertext>
    <width>0</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'UnAssociatedCategoryProducts'
GO
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>AccountId</name>
    <headertext>Checkbox</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>AccountId</name>
    <headertext>Account ID</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/Account/EditAccount</islinkactionurl>
    <islinkparamfield>accountId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>ExternalId</name>
    <headertext>External ID</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>Name</name>
    <headertext>Account Name</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>ParentAccountName</name>
    <headertext>Parent Account Name</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>CatalogName</name>
    <headertext>Catalog Name</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>StoreName</name>
    <headertext>Store Name</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>8</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Manage|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Manage|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/Account/EditAccount|/Account/Delete</manageactionurl>
    <manageparamfield>accountId|accountId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'ZnodeAccount'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSSliderBannerId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>CMSSliderId</name>      <headertext>CMSSliderId</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>50</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,Title</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Title</name>      <headertext>Banner Title</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/WebSite/EditBanner</islinkactionurl>      <islinkparamfield>CMSSliderBannerId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ButtonLink</name>      <headertext>Banner Link</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>BannerSequence</name>      <headertext>Banner Sequence</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>ActivationDate</name>      <headertext>Activation Date</headertext>      <width>0</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>ExpirationDate</name>      <headertext>Expiration Date</headertext>      <width>0</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditBanner|/WebSite/DeleteBanner</manageactionurl>      <manageparamfield>CMSSliderBannerId|CMSSliderBannerId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName = 'View_GetCMSSliderBannerPath'
GO
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>PublishProductId</name>
    <headertext>Checkbox</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>PublishProductId</name>
    <headertext>ID</headertext>
    <width>40</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>Image</name>
    <headertext>Image</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>ImagePath,ProductImage</imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>imageicon</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>ProductName</name>
    <headertext>Product Name</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>SKU</name>
    <headertext>SKU</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'UnAssociatedCMSOfferPageProduct'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?> <columns>  <column>   <id>1</id>   <name>PimCategoryId</name>   <headertext>Checkbox</headertext>   <width>30</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>y</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>2</id>   <name>PimCategoryId</name>   <headertext>ID</headertext>   <width>40</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>3</id>   <name>Image</name>   <headertext>Image</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format>Edit</format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield>PimCategoryId</checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext>Edit</displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield>CategoryImage,CategoryName</imageparamfield>   <manageactionurl>/Pim/Category/Edit</manageactionurl>   <manageparamfield>PimCategoryId</manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>imageicon</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>4</id>   <name>CategoryName</name>   <headertext>Category</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>5</id>   <name>CategoryTitle</name>   <headertext>Title</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>6</id>   <name>AttributeFamily</name>   <headertext>Attribute Family</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>7</id>   <name>Manage</name>   <headertext>Action</headertext>   <width>40</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format>Edit|Delete</format>   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>y</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext>Edit|Delete</displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl>/PIM/Category/Edit|/PIM/Category/Delete</manageactionurl>   <manageparamfield>pimCategoryId|pimCategoryId</manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column> </columns>'
WHERE ItemName = 'UnAssociatedCategoriesToCatalog'
GO
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>PublishProductId</name>
    <headertext>Checkbox</headertext>
    <width>20</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>PublishProductId</name>
    <headertext>Publish Product ID</headertext>
    <width>20</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>Name</name>
    <headertext>Product Name</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>productnameclass</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>ProductType</name>
    <headertext>Product Type</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>SKU</name>
    <headertext>SKU</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>CatalogName</name>
    <headertext>Catalog Name</headertext>
    <width>40</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>IsActive</name>
    <headertext>Status</headertext>
    <width>0</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'PublishedProductList'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?> <columns>  <column>   <id>1</id>   <name>SchedulerName</name>   <headertext>Scheduler Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>2</id>   <name>SchedulerType</name>   <headertext>Scheduler Type</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>n</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>3</id>   <name>TouchPointName</name>   <headertext>Touch Point Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>4</id>   <name>ProcessStartedDate</name>   <headertext>Process Started Date</headertext>   <width>0</width>   <datatype>DateTime</datatype>   <columntype>DateTime</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>5</id>   <name>ProcessCompletedDate</name>   <headertext>Process Completed Date</headertext>   <width>0</width>   <datatype>DateTime</datatype>   <columntype>DateTime</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>6</id>   <name>ImportStatus</name>   <headertext>Status</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>7</id>   <name>SuccessRecordCount</name>   <headertext>Success Record Count</headertext>   <width>0</width>   <datatype>Int</datatype>   <columntype>Int</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>8</id>   <name>SuccessRecordCount</name>   <headertext>Failed Record Count</headertext>   <width>0</width>   <datatype>Int</datatype>   <columntype>Int</columntype>   <allowsorting>true</allowsorting>   <allowpaging>false</allowpaging>   <format></format>   <isvisible>y</isvisible>   <mustshow>y</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext></displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl></manageactionurl>   <manageparamfield></manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>9</id>   <name>Manage</name>   <headertext>Action</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format>View</format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl></islinkactionurl>   <islinkparamfield></islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield></checkboxparamfield>   <iscontrol>n</iscontrol>   <controltype></controltype>   <controlparamfield></controlparamfield>   <displaytext>Log Details</displaytext>   <editactionurl></editactionurl>   <editparamfield></editparamfield>   <deleteactionurl></deleteactionurl>   <deleteparamfield></deleteparamfield>   <viewactionurl></viewactionurl>   <viewparamfield></viewparamfield>   <imageactionurl></imageactionurl>   <imageparamfield></imageparamfield>   <manageactionurl>/Import/ShowLogDetails</manageactionurl>   <manageparamfield>ImportProcessLogId</manageparamfield>   <copyactionurl></copyactionurl>   <copyparamfield></copyparamfield>   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class></Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters></SearchControlParameters>   <DbParamField></DbParamField>   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column> </columns>'
WHERE ItemName = 'TouchPointSchedulerHistory'
GO
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>PimProductTypeAssociationId</name>
    <headertext>
    </headertext>
    <width>20</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>y</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>PimProductTypeAssociationId</checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>PimProductId</name>
    <headertext>Product Id</headertext>
    <width>30</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>y</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>Image</name>
    <headertext>Image</headertext>
    <width>20</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>ProductImage,ProductName</imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>imageicon</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>ProductName</name>
    <headertext>Product Name</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>ProductType</name>
    <headertext>Product Type</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>SKU</name>
    <headertext>SKU</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>SKU</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>Assortment</name>
    <headertext>Assortment</headertext>
    <width>0</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>8</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>true</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>y</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/PIM/Products/UpdateAssociatedProducts|/PIM/Products/UnassociateProducts</manageactionurl>
    <manageparamfield>PimProductTypeAssociationId|PimProductTypeAssociationId,PimProductId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'AssociatedShippingProductList'
GO 
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>CMSContentPagesId</name>
    <headertext>Content Page Id</headertext>
    <width>30</width>
    <datatype>Int32</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>PageName</name>
    <headertext>Page Name</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>cmsContentPagesId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>CMSContentPagesId</checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>pagenamecolumn</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>PageTitle</name>
    <headertext>Page Title</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>CMSContentPagesId</checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>pagetitlecolumn</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'ZnodeCMSContentPageList'
GO
UPDATE ZnodeApplicationSetting 
SET Setting = '<?xml version="1.0" encoding="utf-16"?>
<columns>
  <column>
    <id>1</id>
    <name>BlogNewsId</name>
    <headertext>Checkbox</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>Int32</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>y</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>2</id>
    <name>BlogNewstitle</name>
    <headertext>Title</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/BlogNews/EditBlogNews</islinkactionurl>
    <islinkparamfield>blogNewsId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>3</id>
    <name>BlogNewsType</name>
    <headertext>Type</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>4</id>
    <name>CountComments</name>
    <headertext>Comments</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>y</isallowlink>
    <islinkactionurl>/BlogNews/BlogNewsCommentList</islinkactionurl>
    <islinkparamfield>blogNewsId</islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>y</iscontrol>
    <controltype>Button</controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>btn-grid</Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>5</id>
    <name>StoreName</name>
    <headertext>Store Name</headertext>
    <width>60</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>6</id>
    <name>ActivationDate</name>
    <headertext>Activation Date </headertext>
    <width>60</width>
    <datatype>DateTime</datatype>
    <columntype>DateTime</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>7</id>
    <name>ExpirationDate</name>
    <headertext>Expiration Date </headertext>
    <width>60</width>
    <datatype>DateTime</datatype>
    <columntype>DateTime</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>8</id>
    <name>CreatedDate</name>
    <headertext>Created Date </headertext>
    <width>60</width>
    <datatype>DateTime</datatype>
    <columntype>DateTime</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>n</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>y</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>n</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>9</id>
    <name>IsBlogNewsActive</name>
    <headertext>Is Active</headertext>
    <width>60</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>10</id>
    <name>IsAllowGuestComment</name>
    <headertext>Is Allow Comments</headertext>
    <width>60</width>
    <datatype>Boolean</datatype>
    <columntype>Boolean</columntype>
    <allowsorting>true</allowsorting>
    <allowpaging>true</allowpaging>
    <format>
    </format>
    <isvisible>y</isvisible>
    <mustshow>n</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>
    </displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>
    </manageactionurl>
    <manageparamfield>
    </manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
  <column>
    <id>11</id>
    <name>Manage</name>
    <headertext>Action</headertext>
    <width>30</width>
    <datatype>String</datatype>
    <columntype>String</columntype>
    <allowsorting>false</allowsorting>
    <allowpaging>false</allowpaging>
    <format>Edit|Delete</format>
    <isvisible>y</isvisible>
    <mustshow>y</mustshow>
    <musthide>n</musthide>
    <maxlength>0</maxlength>
    <isallowsearch>n</isallowsearch>
    <isconditional>n</isconditional>
    <isallowlink>n</isallowlink>
    <islinkactionurl>
    </islinkactionurl>
    <islinkparamfield>
    </islinkparamfield>
    <ischeckbox>n</ischeckbox>
    <checkboxparamfield>
    </checkboxparamfield>
    <iscontrol>n</iscontrol>
    <controltype>
    </controltype>
    <controlparamfield>
    </controlparamfield>
    <displaytext>Edit|Delete</displaytext>
    <editactionurl>
    </editactionurl>
    <editparamfield>
    </editparamfield>
    <deleteactionurl>
    </deleteactionurl>
    <deleteparamfield>
    </deleteparamfield>
    <viewactionurl>
    </viewactionurl>
    <viewparamfield>
    </viewparamfield>
    <imageactionurl>
    </imageactionurl>
    <imageparamfield>
    </imageparamfield>
    <manageactionurl>/BlogNews/EditBlogNews|/BlogNews/DeleteBlogNews</manageactionurl>
    <manageparamfield>blogNewsId|blogNewsId</manageparamfield>
    <copyactionurl>
    </copyactionurl>
    <copyparamfield>
    </copyparamfield>
    <xaxis>n</xaxis>
    <yaxis>n</yaxis>
    <isadvancesearch>y</isadvancesearch>
    <Class>
    </Class>
    <SearchControlType>--Select--</SearchControlType>
    <SearchControlParameters>
    </SearchControlParameters>
    <DbParamField>
    </DbParamField>
    <useMode>DataBase</useMode>
    <IsGraph>n</IsGraph>
    <allowdetailview>n</allowdetailview>
  </column>
</columns>'
WHERE ItemName = 'ZnodeBlogNewsList'
GO 
UPDATE ZnodeCMSMessage 
SET Message = '<p>Recently Viewed Product</p>'
WHERE Message = '<p>Recently View Product</p>'
GO 
INSERT INTO ZnodeRobotsTxt (PortalId
,RobotsTxtContent
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)
SELECT PortalId ,'<pre style="word-wrap: break-word; white-space: pre-wrap;">User-Agent: *  Allow: /    <br /><br />## zNode Specific  <br />Disallow: /Admin/*  <br />Disallow: /Activate/*  <br />Disallow: /webservices/*  <br />Disallow: /PlugIns/*</pre>'
		,2,GETDATE(),2,GETDATE()	
 FROM ZnodePortal 
 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeRobotsTxt WHERE ZnodeRobotsTxt.PortalId = ZnodePortal.PortalId )
 GO 
 INSERT INTO ZnodeOmsDiscountType (Name
,Discription
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)

SELECT  'PARTIALREFUND','PARTIAL REFUND',2,GETDATE(),2,GETDATE()
 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeOmsDiscountType  WHERE Name = 'PARTIALREFUND')
 GO 

INSERT [dbo].[ZnodePortalPixelTracking] ( [PortalId], [PixelId1], [CodePixel1], [DisplayName1], [HelpTextPixel1], [PixelId2], [CodePixel2], [DisplayName2], [HelpTextPixel2], [PixelId3], [CodePixel3], [DisplayName3], [HelpTextPixel3], [PixelId4], [CodePixel4], [DisplayName4], [HelpTextPixel4], [PixelId5], [CodePixel5], [DisplayName5], [HelpTextPixel5], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) 
SELECT  PortalId , NULL, N'CJ', N'Commission Junction', N'Comma separated commission junction parameters.First one is cid and another is action id.', NULL, N'Ovative', N'Ovative', N'Comma separated ovative parameters.First one is cid', NULL, NULL, N'Pixel1', N'Pixel1', NULL, NULL, N'Pixel2', N'Pixel2', NULL, NULL, N'Pixel3', N'Pixel3', 2, CAST(N'2017-10-10 20:58:23.393' AS DateTime), 2, CAST(N'2017-10-10 20:58:23.393' AS DateTime)
FROM ZnodePortal 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePortalPixelTracking WHERE  ZnodePortalPixelTracking.PortalId = ZnodePortal.PortalId )
GO 
IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSMessageKey WHERE MessageKey = 'GoogleTagManagerScript') 
BEGIN 
DECLARE @MessageId INT =0 
DECLARE @CmsMessageId INT =0 
INSERT INTO  ZnodeCMSMessageKey (MessageKey,MessageTag,CreatedBY,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'GoogleTagManagerScript',NULL,2,GETDATE(),2,GETDATE()

SET @MessageId = SCOPE_IDENTITY()
INSERT INTO ZnodeCMSMessage (LocaleId,Message,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 1,'<p>&lt;script&gt;(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({''gtm.start'':new Date().getTime(),event:''gtm.js''});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!=''dataLayer''?''&amp;l=''+l:'';j.async=true;j.src=''https://www.googletagmanager.com/gtm.js?id=''+i+dl;f.parentNode.insertBefore(j,f);})(window,document,''script'',''dataLayer'',''{0}'');&lt;/script&gt;</p>',2,GETDATE(),2,GETDATE()
SET @CmsMessageId = SCOPE_IDENTITY()

 INSERT INTO ZnodeCMSPortalMessage (PortalId,CMSMessageKeyId,CMSMessageId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
 SELECT ZP.portalId , @MessageId,@CmsMessageId,2,GETDATE(),2,GETDATE()
  FROM ZnodePOrtal ZP 

 
 INSERT INTO ZnodeCMSPortalMessageKeyTag (PortalId,CMSMessageKeyId,TagXML,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
 SELECT ZP.portalId,@MessageId,NULL,2,GETDATE(),2,GETDATE()
  FROM ZnodePOrtal ZP 
  END 
  GO 
IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSMessageKey WHERE MessageKey = 'CJ') 
BEGIN 
DECLARE @MessageId INT =0 
DECLARE @CmsMessageId INT =0 
INSERT INTO  ZnodeCMSMessageKey (MessageKey,MessageTag,CreatedBY,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'CJ',NULL,2,GETDATE(),2,GETDATE()

SET @MessageId = SCOPE_IDENTITY()
INSERT INTO ZnodeCMSMessage (LocaleId,Message,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 1,'<p><iframe src="https://www.emjcd.com/tags/c?containerTagId={0}&amp;CID={1}&amp;TYPE={2}&amp;CURRENCY={3}&amp;OID={4}{5}" name="cj_conversion" width="1" height="1" frameborder="0" scrolling="no"></iframe></p>',2,GETDATE(),2,GETDATE()
SET @CmsMessageId = SCOPE_IDENTITY()

 INSERT INTO ZnodeCMSPortalMessage (PortalId,CMSMessageKeyId,CMSMessageId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
 SELECT ZP.portalId , @MessageId,@CmsMessageId,2,GETDATE(),2,GETDATE()
  FROM ZnodePOrtal ZP 

 
  INSERT INTO ZnodeCMSPortalMessageKeyTag (PortalId,CMSMessageKeyId,TagXML,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
  SELECT ZP.portalId,@MessageId,NULL,2,GETDATE(),2,GETDATE()
  FROM ZnodePOrtal ZP 
  END 
GO 
INSERT INTO ZnodeCMSSEOType (Name,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'BlogNews',2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEOType WHERE Name = 'BlogNews')
GO 
IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodeEmailTemplate WHERE TemplateName = 'NewUserAccountWebstore')
BEGIN 
DECLARE @Id INT =0 ,@emailTemplateId INT =0 
INSERT INTO ZnodeEmailTemplate(TemplateName
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate) 
SELECT 'NewUserAccountWebstore' ,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeEmailTemplate ZET WHERE ZET.TemplateName = 'NewUserAccountWebstore' )

SET @Id = @@IDENTITY

INSERT INTO ZnodeEmailTemplateLocale (EmailTemplateId
,Subject
,Descriptions
,Content
,LocaleId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)
SELECT @id, 'New User Creation','NewUserAccountWebstore_en','<div style="font-family: Arial, Helvetica; text-align: left; color: black; border: solid 1px black;">  <div class="Head" style="background: #cc0000; color: #fff; padding: 5px; border-bottom: 1px solid #c3c3c3; width: 100%;"><strong>&nbsp; &nbsp;New Account &amp; Password Notification</strong></div>  <div style="padding: 1em;">  <div><strong>Dear</strong> #UserName#,</div>  <br />  <div>A new account has been created for you.Please use the link and password below to login. If this account was created in error, please contact customer service at 1-888-MY-STORE.<br /><br /></div>  <div><a href="#Url#">#Url#</a></div>  <br /><br />  <div>Password:</div>  <br />  <div>#Password#</div>  <br /><br />  <div>Thank you.<br />Store Admin</div>  </div>  </div>',1,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeEmailTemplateLocale WHERE Subject = 'New User Creation' AND  EmailTemplateId = @Id)
INSERT INTO [dbo].[ZnodeEmailTemplateAreas] ( [Name], [Code], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) 
 SELECT N'NewUserAccountWebstore', N'NewUserAccountWebstore', 2, '20160223 11:30:13.227', 2, '20160223 11:30:13.227'
 WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeEmailTemplateAreas WHERE [Name] = N'NewUserAccountWebstore'  )

SET @emailTemplateId = SCOPE_IDENTITY()

INSERT INTO [dbo].[ZnodeEmailTemplateMapper] ( [EmailTemplateId], [PortalId], [EmailTemplateAreasId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) 
SELECT  @Id, PortalId, @emailTemplateId, 1, 2, GETDATE(), 2, GETDATE()
FROM ZnodePortal ZP 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM  [dbo].[ZnodeEmailTemplateMapper] DT WHERE DT.PortalId = ZP.PortalId AND  DT.EmailTemplateId = @Id AND DT.EmailTemplateAreasId = @emailTemplateId ) 
END 
GO 
INSERT INTO ZnodeOmsOrderState (OmsOrderStateId,OrderStateName
,IsShowToCustomer
,IsAccountStatus
,DisplayOrder
,Description
,IsEdit
,IsSendEmail
,IsOrderState
,IsOrderLineItemState
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)
SELECT 110,'PARTIAL REFUND',1,	0,	99,	'PARTIAL REFUND',	1,	1,	0,	1,	2,	GETDATE()	,2,	GETDATE()
WHERE NOT EXISTS (SELECT TOP 1  1 FROM ZnodeOmsOrderState WHERE OrderStateName = 'PARTIAL REFUND' )
GO 
update ZnodeOmsOrderState set OrderStateName = 'PARTIAL REFUND', Description = 'PARTIAL REFUND' where OrderStateName = 'PARTIALREFUND'
GO 
DECLARE @ContenaerAttributeId INT , @PackageSizeFromRequest INT ,@DEfaultLocaleId INT = dbo.FN_GetdefaultLocaleID()
 DECLARE @TRYRR TABLE (Id INT )

INSERT INTO ZnodePimAttribute (AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,IsConfigurable,IsPersonalizable,IsShowOnGrid,DisplayOrder,HelpDescription,IsCategory,IsHidden,IsSwatch,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT (SELECT AttributeTypeId FROM ZnodeAttributeType WHERE AttributeTypeName = 'Simple Select')	,'Container',	0,	0,	1	,0,	0,	0,	0,	500,	'RateV4Response /  Package / Container',	0,	0	,NULL,	2	,'2017-07-27 16:10:09.187',	2,	'2017-07-27 16:15:41.530'
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttribute ZPA WHERE ZPA.AttributeCode = 'Container')
SET @ContenaerAttributeId = SCOPE_IDENTITY()

INSERT INTO ZnodePimAttributeLocale (LocaleId,PimAttributeId,AttributeName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @DEfaultLocaleId,@ContenaerAttributeId,'Container','Container',2,GETDATE(),2,GETDATE() 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeLocale WHERE AttributeName = 'Container' AND PimAttributeId = @ContenaerAttributeId AND  LocaleId = @DEfaultLocaleId  )

INSERT INTO ZnodePimAttribute (AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,IsConfigurable,IsPersonalizable,IsShowOnGrid,DisplayOrder,HelpDescription,IsCategory,IsHidden,IsSwatch,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT (SELECT AttributeTypeId FROM ZnodeAttributeType WHERE AttributeTypeName = 'Simple Select')	,'PackageSizeFromRequest',	0,	0,	1,	0,	0,	0,	0,	500,	NULL,	0,	0,	NULL,	2,	'2017-07-27 16:25:50.733',	2,	'2017-07-27 16:25:50.733'
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttribute ZPA WHERE ZPA.AttributeCode = 'PackageSizeFromRequest')
SET @PackageSizeFromRequest = SCOPE_IDENTITY()

INSERT INTO ZnodePimAttributeLocale (LocaleId,PimAttributeId,AttributeName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @DEfaultLocaleId,@PackageSizeFromRequest,'PackageSizeFromRequest','PackageSizeFromRequest',2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeLocale WHERE AttributeName = 'PackageSizeFromRequest' AND PimAttributeId = @PackageSizeFromRequest AND  LocaleId = @DEfaultLocaleId  )

INSERT INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'VARIABLE'	,NULL,	1	,0,	'#FFFFFF',	NULL,	2	,'2017-07-27 16:16:19.900',	2,	'2017-07-27 16:17:06.110'
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'VARIABLE'  AND PimAttributeId =@ContenaerAttributeId )					
INSERT INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'FLATRATEENVELOPE',	NULL,	2,	1,	'#FFFFFF'	,NULL,	2	,'2017-07-27 16:17:06.157',	2,	'2017-07-27 16:18:21.030'				
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'FLATRATEENVELOPE'  AND PimAttributeId =@ContenaerAttributeId )	
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'PADDEDFLATRATEENVELOPE'	,NULL,	3,	0	,'#FFFFFF'	,NULL	,2,	'2017-07-27 16:18:38.993',	2,	'2017-07-27 16:18:38.993'		
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'PADDEDFLATRATEENVELOPE'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'LEGALFLATRATEENVELOPE',	NULL,	4,	0,	'#FFFFFF',	NULL,	2,	'2017-07-27 16:19:01.113',	2,	'2017-07-27 16:19:01.113'	
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'LEGALFLATRATEENVELOPE'  AND PimAttributeId =@ContenaerAttributeId )	
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'SMFLATRATEENVELOPE',	NULL,	5	,0,	'#FFFFFF'	,NULL,	2	,'2017-07-27 16:19:27.057',	2,	'2017-07-27 16:19:27.057'		
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'SMFLATRATEENVELOPE'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'WINDOWFLATRATEENVELOPE',	NULL,	6,	0,	'#FFFFFF'	,NULL,	2	,'2017-07-27 16:20:04.410',	2	,'2017-07-27 16:20:04.410'	
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'WINDOWFLATRATEENVELOPE'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'GIFTCARDFLATRATEENVELOPE',	NULL,	7,	0,	'#FFFFFF',	NULL,	2,	'2017-07-27 16:20:37.707'	,2,	'2017-07-27 16:20:37.707'	
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'GIFTCARDFLATRATEENVELOPE'  AND PimAttributeId =@ContenaerAttributeId )	
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'SMFLATRATEBOX',	NULL,	8,	0,	'#FFFFFF',	NULL,	2,	'2017-07-27 16:21:20.773',	2,	'2017-07-27 16:21:20.773'				
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'SMFLATRATEBOX'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'MDFLATRATEBOX',	NULL	,9	,0	,'#FFFFFF',	NULL,	2	,'2017-07-27 16:21:45.837'	,2	,'2017-07-27 16:21:45.837'			
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'MDFLATRATEBOX'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'LGFLATRATEBOX'	,NULL,	10,	0,	'#FFFFFF',	NULL,	2,	'2017-07-27 16:22:21.160'	,2	,'2017-07-27 16:22:21.160'				
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'LGFLATRATEBOX'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'REGIONALRATEBOXA'	,NULL	,11,	0	,'#FFFFFF',	NULL	,2	,'2017-07-27 16:22:58.910'	,2	,'2017-07-27 16:22:58.910'	
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'REGIONALRATEBOXA'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'REGIONALRATEBOXB'	,NULL,	12,	0,	'#FFFFFF'	,NULL,	2	,'2017-07-27 16:23:16.460',	2	,'2017-07-27 16:23:16.460'			
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'REGIONALRATEBOXB'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'RECTANGULAR'	,NULL	,13,	0	,'#FFFFFF',	NULL	,2	,'2017-07-27 16:23:37.653'	,2	,'2017-07-27 16:23:37.653'		
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'RECTANGULAR'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @ContenaerAttributeId	,'NONRECTANGULAR',	NULL,	14,	0,	'#FFFFFF',	NULL,	2	,'2017-07-27 16:23:52.070',	2,	'2017-07-27 16:23:52.070'		
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'NONRECTANGULAR'  AND PimAttributeId =@ContenaerAttributeId )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @PackageSizeFromRequest	,'LARGE',NULL,	1	,1	,'#FFFFFF',	NULL,	2	,'2017-07-27 16:26:30.220',	2	,'2017-07-27 16:26:30.220'					
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'LARGE'  AND PimAttributeId =@PackageSizeFromRequest )
INSERT  INTO ZnodePimAttributeDefaultValue (PimAttributeId,AttributeDefaultValueCode,IsEditable,DisplayOrder,IsDefault,SwatchText,MediaId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @PackageSizeFromRequest	,'REGULAR'	,NULL,	2,	0,	'#FFFFFF',	NULL,	2,	'2017-07-27 16:26:43.737'	,2,	'2017-07-27 16:26:43.737'
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = 'REGULAR'  AND PimAttributeId =@PackageSizeFromRequest )
DECLARE @SaveDefaultValue TABLE (
	[LocaleId] [int] NULL,
	[PimAttributeDefaultValueId] [int] NULL,
	[AttributeDefaultValue] [nvarchar](max) NULL,
	[Description] [nvarchar](300) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[AttributeDefaultValueCode] [varchar](100) NULL
) 


INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 257, N'VARIABLE', NULL, 2, CAST(N'2017-07-27T16:16:20.067' AS DateTime), 2, CAST(N'2017-07-27T16:16:20.067' AS DateTime), N'VARIABLE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 258, N'FLAT RATE ENVELOPE', NULL, 2, CAST(N'2017-07-27T16:17:06.200' AS DateTime), 2, CAST(N'2017-07-27T16:18:21.093' AS DateTime), N'FLATRATEENVELOPE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 259, N'PADDED FLAT RATE ENVELOPE', NULL, 2, CAST(N'2017-07-27T16:18:39.110' AS DateTime), 2, CAST(N'2017-07-27T16:18:39.110' AS DateTime), N'PADDEDFLATRATEENVELOPE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 260, N'LEGAL FLAT RATE ENVELOPE', NULL, 2, CAST(N'2017-07-27T16:19:01.147' AS DateTime), 2, CAST(N'2017-07-27T16:19:01.147' AS DateTime), N'LEGALFLATRATEENVELOPE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 261, N'SM FLAT RATE ENVELOPE', NULL, 2, CAST(N'2017-07-27T16:19:27.090' AS DateTime), 2, CAST(N'2017-07-27T16:19:27.090' AS DateTime), N'SMFLATRATEENVELOPE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 262, N'WINDOW FLAT RATE ENVELOPE', NULL, 2, CAST(N'2017-07-27T16:20:04.470' AS DateTime), 2, CAST(N'2017-07-27T16:20:04.470' AS DateTime), N'WINDOWFLATRATEENVELOPE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 263, N'GIFT CARD FLAT RATE ENVELOPE', NULL, 2, CAST(N'2017-07-27T16:20:37.740' AS DateTime), 2, CAST(N'2017-07-27T16:20:37.740' AS DateTime), N'GIFTCARDFLATRATEENVELOPE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 264, N'SM FLAT RATE BOX', NULL, 2, CAST(N'2017-07-27T16:21:20.800' AS DateTime), 2, CAST(N'2017-07-27T16:21:20.800' AS DateTime), N'SMFLATRATEBOX')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 265, N'MD FLAT RATE BOX', NULL, 2, CAST(N'2017-07-27T16:21:45.967' AS DateTime), 2, CAST(N'2017-07-27T16:21:45.967' AS DateTime), N'MDFLATRATEBOX')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 266, N'LG FLAT RATE BOX', NULL, 2, CAST(N'2017-07-27T16:22:21.190' AS DateTime), 2, CAST(N'2017-07-27T16:22:21.190' AS DateTime), N'LGFLATRATEBOX')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 267, N'REGIONALRATEBOXA', NULL, 2, CAST(N'2017-07-27T16:22:58.960' AS DateTime), 2, CAST(N'2017-07-27T16:22:58.960' AS DateTime), N'REGIONALRATEBOXA')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 268, N'REGIONALRATEBOXB', NULL, 2, CAST(N'2017-07-27T16:23:16.490' AS DateTime), 2, CAST(N'2017-07-27T16:23:16.490' AS DateTime), N'REGIONALRATEBOXB')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 269, N'RECTANGULAR', NULL, 2, CAST(N'2017-07-27T16:23:37.700' AS DateTime), 2, CAST(N'2017-07-27T16:23:37.700' AS DateTime), N'RECTANGULAR')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 270, N'NONRECTANGULAR', NULL, 2, CAST(N'2017-07-27T16:23:52.103' AS DateTime), 2, CAST(N'2017-07-27T16:23:52.103' AS DateTime), N'NONRECTANGULAR')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 271, N'LARGE', NULL, 2, CAST(N'2017-07-27T16:26:30.270' AS DateTime), 2, CAST(N'2017-07-27T16:26:30.270' AS DateTime), N'LARGE')

INSERT @SaveDefaultValue ([LocaleId], [PimAttributeDefaultValueId], [AttributeDefaultValue], [Description], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [AttributeDefaultValueCode]) VALUES (1, 272, N'REGULAR', NULL, 2, CAST(N'2017-07-27T16:26:43.770' AS DateTime), 2, CAST(N'2017-07-27T16:26:43.770' AS DateTime), N'REGULAR')

INSERT INTO ZnodePimAttributeDefaultValueLocale (LocaleId
,PimAttributeDefaultValueId
,AttributeDefaultValue
,Description
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)

SELECT a.LocaleId , f.PimAttributeDefaultValueId,a.AttributeDefaultValue
,a.Description
,a.CreatedBy
,a.CreatedDate
,a.ModifiedBy
,a.ModifiedDate  
FROM @SaveDefaultValue a 
INNER JOIN ZnodePimAttributeDefaultValue F ON (f.[AttributeDefaultValueCode] = a.[AttributeDefaultValueCode])
WHERE NOT EXISTS (SELECT TOP  1 1 FROM ZnodePimAttributeDefaultValueLocale Ab WHERE  Ab.AttributeDefaultValue = a.AttributeDefaultValue AND AB.LocaleId = a.LocaleId)
GO 
INSERT INTO ZnodePimFrontendProperties (PimAttributeId,IsComparable,IsUseInSearch,IsHtmlTags,IsFacets,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT PimAttributeId,0,0,0,0,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate FROM ZnodePimAttribute  A 
WHERE AttributeCode IN ('PackageSizeFromRequest')
AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimFrontendProperties TR WHERE TR.PimAttributeId = A.PimAttributeId )
GO 
INSERT INTO ZnodePimFrontendProperties (PimAttributeId,IsComparable,IsUseInSearch,IsHtmlTags,IsFacets,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT PimAttributeId,0,0,0,0,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate FROM ZnodePimAttribute a
WHERE AttributeCode IN ('Container')
AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimFrontendProperties TR WHERE TR.PimAttributeId = A.PimAttributeId )
GO 
INSERT INTO ZnodeProductFeedSiteMapType (ProductFeedSiteMapTypeCode,ProductFeedSiteMapTypeName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'Product','Product',2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeProductFeedSiteMapType WHERE ProductFeedSiteMapTypeCode = 'Product' )
GO 


IF NOT EXISTS ( SELECT TOP 1 1 FROM [dbo].[ZnodeShippingServiceCode] WHERE [ShippingTypeId] = (SELECT TOP 1 ShippingTypeId FROM  ZnodeShippingTypes WHERE ClassName='ZnodeShippingUsps' AND Name = 'USPS' ) AND [Code] = 'PRIORITY' )
BEGIN
	INSERT [dbo].[ZnodeShippingServiceCode] ( [ShippingTypeId], [Code], [Description], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES ( (SELECT TOP 1 ShippingTypeId FROM  ZnodeShippingTypes WHERE ClassName='ZnodeShippingUsps' AND Name = 'USPS' ), N'PRIORITY', N'USPS - Priority', 2, 1, 2, GETDATE(), 2, GETDATE())
END
GO 
IF NOT EXISTS ( SELECT TOP 1 1 FROM [dbo].[ZnodeShippingServiceCode] WHERE [ShippingTypeId] = (SELECT TOP 1 ShippingTypeId FROM  ZnodeShippingTypes WHERE ClassName='ZnodeShippingUsps' AND Name = 'USPS' ) AND [Code] = 'PRIORITY MAIL INTERNATIONAL' )
BEGIN
	INSERT [dbo].[ZnodeShippingServiceCode] ( [ShippingTypeId], [Code], [Description], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES ( (SELECT TOP 1 ShippingTypeId FROM  ZnodeShippingTypes WHERE ClassName='ZnodeShippingUsps' AND Name = 'USPS' ), N'PRIORITY MAIL INTERNATIONAL', N'USPS - Priority Mail International', 2, 1, 2, GETDATE(), 2, GETDATE())
END
GO 
IF NOT EXISTS ( SELECT TOP 1 1 FROM [dbo].[ZnodeShippingServiceCode] WHERE [ShippingTypeId] = (SELECT TOP 1 ShippingTypeId FROM  ZnodeShippingTypes WHERE ClassName='ZnodeShippingUsps' AND Name = 'USPS' ) AND [Code] = 'FIRST CLASS' )
BEGIN
	INSERT [dbo].[ZnodeShippingServiceCode] ( [ShippingTypeId], [Code], [Description], [DisplayOrder], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES ( (SELECT TOP 1 ShippingTypeId FROM  ZnodeShippingTypes WHERE ClassName='ZnodeShippingUsps' AND Name = 'USPS' ), N'FIRST CLASS', N'USPS - First Class', 2, 1, 2, GETDATE(), 2, GETDATE())
END

GO 
INSERT INTO ZnodeShippingTypes (ClassName
,Name
,Description
,IsActive
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate)
SELECT 'ZnodeCustomerShipping','Customer''s Shipping','Use for Customers Shipping',1,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeShippingTypes WHERE ClassName = 'ZnodeCustomerShipping' AND  Name = 'Customer''s Shipping')
GO 
IF NOT EXISTS ( SELECT * FROM ZnodeImportHead WHERE Name = 'ProductAttribute' )
BEGIN
	Declare @ID int 

	insert into ZnodeImportHead (Name,IsUsedInImport,IsUsedInDynamicReport,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Values ('ProductAttribute',1,0,1,2,Getdate() ,2,Getdate())
	SET @ID  = @@Identity

	
	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'AttributeName', @ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,1,ModifiedDate 
		FROM ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)
	
	
	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'AttributeCode',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,2,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'AttributeType',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,3,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'DisplayOrder',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,4,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)
	
--Template 

	DEclare @TemplateId int 
	insert into ZnodeImportTemplate (ImportHeadId,TemplateName,TemplateVersion,PimAttributeFamilyId,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	select top 1 @ID,'AttributeTemplate',TemplateVersion,null,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from ZnodeImportTemplate 

	SET @TemplateId = @@Identity

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'AttributeName','AttributeName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
		from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
		insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'AttributeCode','AttributeCode',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
		from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
	
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'AttributeType','AttributeType',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
		from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
	
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'DisplayOrder','DisplayOrder',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
		from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
	
END 
go
---- CategoryAssociation
IF NOT EXISTS( SELECT * FROM ZnodeImportHead WHERE Name = 'CategoryAssociation' )
BEGIN
	Declare @ID int 

	insert into ZnodeImportHead (Name,IsUsedInImport,IsUsedInDynamicReport,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Values ('CategoryAssociation',1,0,1,2,Getdate() ,2,Getdate())
	SET @ID  = @@Identity

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select AttributeTypeName,'SKU',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)
	
		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select AttributeTypeName,'CategoryName',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select AttributeTypeName,'DisplayOrder',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		Select AttributeTypeName,'IsActive',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

	DEclare @TemplateId int 
	

		insert into ZnodeImportTemplate (ImportHeadId,TemplateName,TemplateVersion,PimAttributeFamilyId,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		select top 1 @ID,'CategoryAssociation',TemplateVersion,null,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from ZnodeImportTemplate 

		SET @TemplateId = @@Identity

		
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'SKU','SKU',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
	
			 insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'CategoryName','CategoryName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			 insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'DisplayOrder','DisplayOrder',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			 insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'IsActive','IsActive',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
 END
go

---- Customer
IF NOT EXISTS( SELECT * FROM ZnodeImportHead WHERE Name = 'Customer' )
BEGIN
	Declare @ID int 

	insert into ZnodeImportHead (Name,IsUsedInImport,IsUsedInDynamicReport,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Values ('Customer',1,0,1,2,Getdate() ,2,Getdate())
	SET @ID  = @@Identity


		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'UserName', @ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,1,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'FirstName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,2,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'LastName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,3,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'MiddleName',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,4,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'Email',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,5,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'PhoneNumber',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,6,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'EmailOptIn',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,7,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'IsActive',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,8,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

		insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
		Select AttributeTypeName,'ExternalId',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,9,ModifiedDate 
		from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)
	
--Template 

		DEclare @TemplateId int 
		insert into ZnodeImportTemplate (ImportHeadId,TemplateName,TemplateVersion,PimAttributeFamilyId,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		select top 1 @ID,'CustomerTemplate',TemplateVersion,null,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from ZnodeImportTemplate 

		SET @TemplateId = @@Identity

			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'UserName','UserName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

			 insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'FirstName','FirstName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
	
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'LastName','LastName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'MiddleName','MiddleName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'Email','Email',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'PhoneNumber','PhoneNumber',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'EmailOptIn','EmailOptIn',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'IsActive','IsActive',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
			insert into ZnodeImportTemplateMapping
			(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			Select @TemplateId,'ExternalId','ExternalId',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
			 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
		
 END
 go

 ---- CustomerAddress
 IF NOT EXISTS( SELECT * FROM ZnodeImportHead WHERE Name = 'CustomerAddress' )
BEGIN
	Declare @ID int 
	insert into ZnodeImportHead (Name,IsUsedInImport,IsUsedInDynamicReport,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Values ('CustomerAddress',1,0,1,2,Getdate() ,2,Getdate())
	SET @ID  = @@IDENTITY

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'UserName', @ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,1,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'FirstName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,2,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'LastName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,3,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'DisplayName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,4,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'Address1',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,5,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'Address2',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,6,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'CountryName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,7,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'StateName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,8,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'CityName',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,9,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'PostalCode',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,10,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)


	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'PhoneNumber',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,11,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'Mobilenumber',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,12,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'AlternateMobileNumber',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,13,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'FaxNumber',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,14,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'IsDefaultBilling',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,15,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'IsActive',@ID,1,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,16,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'IsDefaultShipping',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,17,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,SequenceNumber,ModifiedDate)
	Select AttributeTypeName,'ExternalId',@ID,0,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,18,ModifiedDate 
	from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	--Template 

	DEclare @TemplateId int 
	insert into ZnodeImportTemplate (ImportHeadId,TemplateName,TemplateVersion,PimAttributeFamilyId,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	select top 1 @ID,'CustomerAddressTemplate',TemplateVersion,null,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from ZnodeImportTemplate 

	SET @TemplateId = @@Identity

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'UserName','UserName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	 insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'FirstName','FirstName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'LastName','LastName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'DisplayName','DisplayName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'Address1','Address1',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'Address2','Address2',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'CountryName','CountryName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'StateName','StateName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'CityName','CityName',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

 
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'PostalCode','PostalCode',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))


  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'PhoneNumber','PhoneNumber',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'Mobilenumber','Mobilenumber',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'AlternateMobileNumber','AlternateMobileNumber',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'FaxNumber','FaxNumber',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'IsDefaultBilling','IsDefaultBilling',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'IsActive','IsActive',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

  
	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'IsDefaultShipping','IsDefaultShipping',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))


	 insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'ExternalId','ExternalId',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in ( (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping))

 END 
 go

 ---- ProductAssociation
IF NOT EXISTS( SELECT * FROM ZnodeImportHead WHERE Name = 'ProductAssociation' )
BEGIN	
	DECLARE @Id INT;
    INSERT INTO ZnodeImportHead ( Name , IsUsedInImport , IsUsedInDynamicReport , IsActive , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate   )
    VALUES ( 'ProductAssociation' , 1 , 0 , 1 , 2 , GETDATE() , 2 , GETDATE());
    SET @Id = @@Identity;

    INSERT INTO ZnodeImportAttributeValidation ( AttributeTypeName , AttributeCode , ImportHeadId , IsRequired , ControlName , ValidationName , SubValidationName , ValidationValue , RegExp , DisplayOrder , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                               )
           SELECT AttributeTypeName , 'ParentSKU' , @Id , IsRequired , ControlName , ValidationName , SubValidationName , ValidationValue , RegExp , DisplayOrder , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportAttributeValidation
           WHERE ImportAttributeValidationId IN ( 1
                                                );
    INSERT INTO ZnodeImportAttributeValidation ( AttributeTypeName , AttributeCode , ImportHeadId , IsRequired , ControlName , ValidationName , SubValidationName , ValidationValue , RegExp , DisplayOrder , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                               )
           SELECT AttributeTypeName , 'ChildSKU' , @Id , IsRequired , ControlName , ValidationName , SubValidationName , ValidationValue , RegExp , DisplayOrder , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportAttributeValidation
           WHERE ImportAttributeValidationId IN ( 1
                                                );
    INSERT INTO ZnodeImportAttributeValidation ( AttributeTypeName , AttributeCode , ImportHeadId , IsRequired , ControlName , ValidationName , SubValidationName , ValidationValue , RegExp , DisplayOrder , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                               )
           SELECT AttributeTypeName , 'DisplayOrder' , @Id , IsRequired , ControlName , ValidationName , SubValidationName , ValidationValue , RegExp , DisplayOrder , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportAttributeValidation
           WHERE ImportAttributeValidationId IN ( 36 , 37 , 38 , 39
                                                );
    DECLARE @TemplateId INT;
    INSERT INTO ZnodeImportTemplate ( ImportHeadId , TemplateName , TemplateVersion , PimAttributeFamilyId , IsActive , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                    )
           SELECT TOP 1 @Id , 'ProductAssociation' , TemplateVersion , NULL , IsActive , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportTemplate;
    SET @TemplateId = @@Identity;
    INSERT INTO ZnodeImportTemplateMapping ( ImportTemplateId , SourceColumnName , TargetColumnName , DisplayOrder , IsActive , IsAllowNull , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                           )
           SELECT @TemplateId , 'ParentSKU' , 'ParentSKU' , DisplayOrder , IsActive , IsAllowNull , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportTemplateMapping
           WHERE ImportTemplateMappingId IN (  (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
                                            );
    INSERT INTO ZnodeImportTemplateMapping ( ImportTemplateId , SourceColumnName , TargetColumnName , DisplayOrder , IsActive , IsAllowNull , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                           )
           SELECT @TemplateId , 'ChildSKU' , 'ChildSKU' , DisplayOrder , IsActive , IsAllowNull , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportTemplateMapping
           WHERE ImportTemplateMappingId IN (  (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
                                            );
    INSERT INTO ZnodeImportTemplateMapping ( ImportTemplateId , SourceColumnName , TargetColumnName , DisplayOrder , IsActive , IsAllowNull , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
                                           )
           SELECT @TemplateId , 'DisplayOrder' , 'DisplayOrder' , DisplayOrder , IsActive , IsAllowNull , CreatedBy , CreatedDate , ModifiedBy , ModifiedDate
           FROM ZnodeImportTemplateMapping
           WHERE ImportTemplateMappingId IN (  (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)
                                            );
END

go
---- SEODetails
IF NOT EXISTS( SELECT * FROM ZnodeImportHead WHERE Name = 'SEODetails' )
BEGIN
	Declare @ID int 

	insert into ZnodeImportHead (Name,IsUsedInImport,IsUsedInDynamicReport,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Values ('SEODetails',1,0,1,2,Getdate() ,2,Getdate())
	SET @ID  = @@Identity

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'ImportType',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,1 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'Code',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,2 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'IsRedirect',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,3 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'MetaInformation',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,4 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'SEOUrl',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,5 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'IsActive',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,6 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (36,37,38,39)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'SEOTitle',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,7 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)


	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'SEODescription',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,8 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)

	insert into ZnodeImportAttributeValidation (AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber )
	Select AttributeTypeName,'SEOKeywords',@ID,IsRequired,ControlName,ValidationName,SubValidationName,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate 
	,9 from ZnodeImportAttributeValidation where ImportAttributeValidationId in (1)


	--Template 

	DEclare @TemplateId int 
	insert into ZnodeImportTemplate (ImportHeadId,TemplateName,TemplateVersion,PimAttributeFamilyId,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	select top 1 @ID,'SEODetailsTemplate',TemplateVersion,null,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate from ZnodeImportTemplate 

	SET @TemplateId = @@Identity

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'ImportType','ImportType',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	 insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'Code','Code',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'IsRedirect','IsRedirect',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'MetaInformation','MetaInformation',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'SEOUrl','SEOUrl',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'IsActive','IsActive',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'SEOTitle','SEOTitle',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'SEODescription','SEODescription',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	insert into ZnodeImportTemplateMapping
	(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Select @TemplateId,'SEOKeywords','SEOKeywords',DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
	 from ZnodeImportTemplateMapping where ImportTemplateMappingId in (SELECT TOP 1 ImportTemplateMappingId FROM  ZnodeImportTemplateMapping)

	 update ZnodeImportAttributeValidation set IsRequired=0 where AttributeCode='SEODescription'
	 update ZnodeImportAttributeValidation set IsRequired=0 where AttributeCode='MetaInformation'
END

----UpdateSequenceNumber1
	update ZnodeImportAttributeValidation SET SequenceNumber =1  where  AttributeCode = 'SKU' and ImportHeadId =2 
	update ZnodeImportAttributeValidation SET SequenceNumber =2  where  AttributeCode = 'TierStartQuantity' and ImportHeadId =2 
	update ZnodeImportAttributeValidation SET SequenceNumber =3  where  AttributeCode = 'RetailPrice' and ImportHeadId =2 
	update ZnodeImportAttributeValidation SET SequenceNumber =4  where  AttributeCode = 'SalesPrice' and ImportHeadId =2 
	update ZnodeImportAttributeValidation SET SequenceNumber =5  where  AttributeCode = 'TierPrice' and ImportHeadId =2 
	update ZnodeImportAttributeValidation SET SequenceNumber =6  where  AttributeCode = 'SKUActivationDate' and ImportHeadId =2 
	update ZnodeImportAttributeValidation SET SequenceNumber =7  where  AttributeCode = 'SKUExpirationDate' and ImportHeadId =2
	GO 
IF NOT EXISTS (SELECT TOP 1 1  FROM ZnodeRoleMenu WHERE ZnodeRoleMenu.MenuId = (SELECT MenuId FROM ZnodeMenu WHERE MenuName = 'Blogs & News' AND ControllerName='BlogNews')  )
BEGIN 
DECLARE @id INT 
INSERT INTO ZnodeRoleMenu (RoleId,MenuId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'c120e647-4cdd-48a8-8113-6fe0eae87b3d',(SELECT MenuId FROM ZnodeMenu WHERE MenuName = 'Blogs & News' AND ControllerName='BlogNews'),2,GETDATE(),2,GETDATE()

SET @id = Scope_identity()
INSERT INTO ZnodeRoleMenuAccessMapper(RoleMenuId,AccessPermissionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @id , 1,2,GETDATE(),2,GETDATE()
INSERT INTO ZnodeRoleMenuAccessMapper(RoleMenuId,AccessPermissionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @id , 2,2,GETDATE(),2,GETDATE()
INSERT INTO ZnodeRoleMenuAccessMapper(RoleMenuId,AccessPermissionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @id , 3,2,GETDATE(),2,GETDATE()
INSERT INTO ZnodeRoleMenuAccessMapper(RoleMenuId,AccessPermissionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT @id , 4,2,GETDATE(),2,GETDATE()
END 
GO 
UPDATE ZnodeShipping SET ShippingCode = 'PRIORITY' WHERE ShippingCode='USPS'
GO 

INSERT INTO ZnodeTaxRuleTypes (PortalId,ClassName,Name,Description,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT NULL,'AvataxTaxSales',	'Avatax Tax Class',	'Applies Avatax to the shopping cart.',	1,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeTaxRuleTypes WHERE ClassName = 'AvataxTaxSales' )
GO 
INSERT INTO ZnodeTaxRuleTypes (PortalId,ClassName,Name,Description,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT NULL,'STOCCHTax',	'STO CCH Tax',	'Applies STO CCH tax to the shopping cart.',	1,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeTaxRuleTypes WHERE ClassName = 'STOCCHTax' )
GO 
if NOT exists (Select TOP 1 1 from ZnodeMessage where MessageCode = '49' )
Begin
	insert into ZnodeMessage (MessageCode,MessageType,MessageName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
	Values ('49','Text', 'Product should be (GroupedProduct,BundleProduct,ConfigurableProduct)',2,getdate(),2,getdate())
END
GO 
if NOT exists (Select TOP 1 1 from ZnodeMessage where MessageCode = '51' )
Begin
insert into ZnodeMessage (MessageCode,MessageType,MessageName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Values ('51','Text', 'Product should be SimpleProduct',2,getdate(),2,getdate())
END
GO

delete  from ZnodeImportAttributeValidation where importheadid in 
(select ImportHeadId from Znodeimporthead where name  = 'CustomerAddress') 
and  attributeCode in ('Mobilenumber','AlternateMobileNumber','FaxNumber')

delete  from ZnodeImportTemplateMapping where  ImportTemplateId in (
Select ImportTemplateID from ZnodeImportTemplate where ImportHeadid in 
(select ImportHeadId from Znodeimporthead where name  = 'CustomerAddress') )
and  TargetColumnName in ('Mobilenumber','AlternateMobileNumber','FaxNumber')
GO 
UPDATE ZnodeApplicationSetting 
SET Setting ='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PublishProductId</name>      <headertext>Checkbox</headertext>      <width>20</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PublishProductId,Quantity,SKU</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Single</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImageSmallThumbnailPath,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>sku</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Name</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>productname</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>SalesPriceWithCurrency</name>      <headertext>Sales Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>RetailPriceWithCurrency</name>      <headertext>Retail Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/SEO/SEODetails</manageactionurl>      <manageparamfield>ItemName,ItemId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE itemName = 'ZnodeOrderProductList'
GO 
 UPDATE ZnodeDomain 
 SET DomainName = 'winewebstore.multifront903.localhost.com'
 WHERE DomainName = 'winewebstore.multifront902.localhost.com'
 UPDATE ZnodeDomain 
 SET DomainName = 'webstore.multifront903.localhost.com'
 WHERE DomainName = 'webstore.multifront902.localhost.com'
 UPDATE ZnodeDomain 
 SET DomainName = 'admin.multifront903.localhost.com'
 WHERE DomainName = 'admin.multifront902.localhost.com'
 UPDATE ZnodeDomain 
 SET DomainName = 'api.multifront903.localhost.com'
 WHERE DomainName = 'api.multifront902.localhost.com'
 UPDATE ZnodeDomain 
 SET DomainName = 'nutswebstore.multifront903.localhost.com'
 WHERE DomainName = 'nutswebstore.multifront902.localhost.com'
 GO 
insert into ZnodeMessage (MessageCode,MessageType,MessageName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT '50','Text', 'Data should be alphanumeric',2,getdate(),2,getdate()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeMessage WHERE MessageType = 'Text' AND MessageName = 'Data should be alphanumeric')
Go
PRINT 'Upgrade Successfully'