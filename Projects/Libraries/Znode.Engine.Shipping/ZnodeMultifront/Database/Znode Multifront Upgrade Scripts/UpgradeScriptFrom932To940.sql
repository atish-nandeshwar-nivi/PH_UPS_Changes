
IF EXISTS (SELECT TOP 1 1 FROM Sys.Tables WHERE Name = 'ZnodeMultifront')
BEGIN 
IF EXISTS (SELECT TOP 1 1 FROM ZnodeMultifront where BuildVersion =   940  )
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
VALUES ( N'Znode_Multifront_9_4_0', N'Upgrade GA Release by 940',9,4,0,940,0,2, GETDATE(),2, GETDATE())
GO 
SET ANSI_NULLS ON
GO


if exists(select * from sys.procedures where name = 'Znode_ManageCategoryList_XML')
	drop proc Znode_ManageCategoryList_XML
go
CREATE PROCEDURE [dbo].[Znode_ManageCategoryList_XML](
      @WhereClause      XML ,
      @Rows             INT            = 100 ,
      @PageNo           INT            = 1 ,
      @Order_BY         NVARCHAR(1000) = '' ,
      @LocaleId         INT            = 1 ,
      @ProfileCatalogId INT            = 0,
	  @PimCatalogId     INT            = 0,
	  @IsCatalogFilter   BIT            = 0)
AS
    /*
	   Summary: This Procedure is used to get all category list 
				The Result displays CategortName with PimCategoryId where CategoryName and CategoryImage are pivoted values
	   Unit Testing 	  
	   EXEC Znode_ManageCategoryList_XML '' ,@LocaleId= 1
	
    */
     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
             DECLARE @TBL_PimcategoryDetails TABLE (PimCategoryId INT,CountId INT,RowId INT);
             DECLARE @TBL_CategoryIds TABLE (PimCategoryId INT ,ParentPimcategoryId INT);
             DECLARE @TBL_AttributeValue TABLE (PimCategoryAttributeValueId INT,PimCategoryId INT,CategoryValue NVARCHAR(MAX), AttributeCode VARCHAR(300), PimAttributeId  INT);
             DECLARE @TBL_FamilyDetails TABLE (PimCategoryId INT , PimAttributeFamilyId INT , AttributeFamilyName  NVARCHAR(MAX));
             DECLARE @TBL_DefaultAttributeValue TABLE (PimAttributeId INT ,AttributeDefaultValueCode VARCHAR(600) , IsEditable BIT ,AttributeDefaultValue NVARCHAR(MAX),DisplayOrder int);
			 DECLARE @TBL_MediaAttribute TABLE (Id INT ,PimAttributeId INT ,AttributeCode VARCHAR(600) )
             DECLARE @TBL_ProfileCatalogCategory TABLE (ProfileCatalogId INT ,PimCategoryId INT);
             DECLARE @PimCategoryIds VARCHAR(MAX)= '' , @PimAttributeIds VARCHAR(MAX),@CategoryXML NVARCHAr(max);
			 DECLARE @RowsCount INT 

		 IF @ProfileCatalogId > 0
			 BEGIN
			 INSERT INTO @TBL_ProfileCatalogCategory (ProfileCatalogId , PimCategoryId)
			 SELECT ZPC.ProfileCatalogId , PimCategoryId
			 FROM ZnodePimCatalogCategory AS ZCC 
			 INNER JOIN ZnodeProfileCatalog AS ZPC ON ( ZPC.PimCatalogId = ZCC.PimCatalogId )
			 WHERE ZPC.ProfileCatalogId = @ProfileCatalogId 
			 AND NOT EXISTS ( SELECT TOP 1 1 FROM ZnodeProfileCatalogCategory AS ZPCC WHERE ZPCC.PimCatalogCategoryId = ZCC.PimCatalogCategoryId);
                     
			 SET @PimCategoryIds = SUBSTRING( ( SELECT DISTINCT ','+CAST(PimCategoryId AS VARCHAR(20)) FROM @TBL_ProfileCatalogCategory FOR XML PATH('') ) , 2 , 4000);
			 END;

			IF @PimCatalogId = -1
			BEGIN
			SET @PimCategoryIds = SUBSTRING( ( SELECT DISTINCT ','+CAST(PimCategoryId AS VARCHAR(2000))
			FROM ZnodePimCategory ZPC 
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy ZPCC 
			WHERE ZPC.PimCategoryId = ZPCC.PimCategoryId)
			AND ZPC.PimCategoryId IS NOT NULL
			FOR XML PATH('') ) , 2 , 4000);

			END
			ELSE IF @PimCatalogId <> 0 AND @PimCatalogId <> -1
			BEGIN
			SET @PimCategoryIds = SUBSTRING( ( SELECT DISTINCT ','+CAST(PimCategoryId AS VARCHAR(2000)) 
			FROM ZnodePimCategory ZPC 
			WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy ZPCC WHERE ZPC.PimCategoryId = ZPCC.PimCategoryId
			AND ZPCC.PimCatalogId = @PimCatalogId)
			AND ZPC.PimCategoryId IS NOT NULL
			FOR XML PATH('') ) , 2 , 4000);
			END
			ELSE IF @PimCatalogId = 0 AND @IsCatalogFilter = 1 -- filter for all catalog category except category which are not associated with any catalog
			BEGIN
			SET @PimCategoryIds = SUBSTRING( ( SELECT DISTINCT ','+CAST(PimCategoryId AS VARCHAR(2000)) 
			FROM ZnodePimCategory ZPC 
			WHERE EXISTS (SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy ZPCC WHERE ZPC.PimCategoryId = ZPCC.PimCategoryId)
			AND ZPC.PimCategoryId IS NOT NULL
			FOR XML PATH('') ) , 2 , 4000);
			END

			

              INSERT INTO @TBL_PimcategoryDetails ( PimCategoryId , CountId , RowId)
             EXEC Znode_GetCategoryIdForPaging @WhereClause , @Rows , @PageNo , @Order_BY , @RowsCount  , @LocaleId , '' , @PimCategoryIds , 1; 


             SET @PimCategoryIds =  SUBSTRING( ( SELECT ','+ CAST(PimCategoryId AS VARCHAR(100)) FROM @TBL_PimcategoryDetails FOR XML PATH('')) , 2 , 4000);
             SET @PimAttributeIds = SUBSTRING( ( SELECT ','+ CAST(PimAttributeId AS VARCHAR(100)) FROM [dbo].[Fn_GetCategoryGridAttributeDetails]() FOR XML PATH('')) , 2 , 4000);

			 INSERT INTO @TBL_AttributeValue ( PimCategoryAttributeValueId , PimCategoryId , CategoryValue , AttributeCode , PimAttributeId)
             EXEC [dbo].[Znode_GetCategoryAttributeValue] @PimCategoryIds , @PimAttributeIds , @LocaleId;

             INSERT INTO @TBL_FamilyDetails ( PimAttributeFamilyId , AttributeFamilyName , PimCategoryId)
             EXEC Znode_GetCategoryFamilyDetails @PimCategoryIds , @LocaleId;
             
		     INSERT INTO @TBL_DefaultAttributeValue ( PimAttributeId , AttributeDefaultValueCode , IsEditable , AttributeDefaultValue,DisplayOrder)
             EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @PimAttributeIds , @LocaleId;
             
			 SET @RowsCount = ISNULL((SELECT TOP 1 CountId FROM @TBL_PimcategoryDetails ),0)
			 
			 INSERT INTO @TBL_MediaAttribute (Id,PimAttributeId,AttributeCode )
			 SELECT Id,PimAttributeId,AttributeCode 
			 FROM [dbo].[Fn_GetProductMediaAttributeId]()
			 		
		     ;WITH Cte_DefaultCategoryValue
              AS (SELECT PimCategoryId , PimAttributeId ,SUBSTRING( ( SELECT ','+AttributeDefaultValue FROM @TBL_DefaultAttributeValue AS TBDAV WHERE TBDAV.PimAttributeId = TBAV.PimAttributeId 
			     AND EXISTS ( SELECT TOP 1 1 FROM dbo.Split ( TBAV.CategoryValue , ',') AS SP WHERE sp.Item = TBDAV.AttributeDefaultValueCode)
                 FOR XML PATH('')) , 2 , 4000) AS AttributeValue FROM @TBL_AttributeValue AS TBAV							 
				 WHERE EXISTS ( SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryDefaultValueAttribute]() AS SP WHERE SP.PimAttributeId = TBAV.PimAttributeId))

             UPDATE TBAV SET TBAV.CategoryValue = CTDCV.AttributeValue
             FROM @TBL_AttributeValue TBAV 
			 INNER JOIN Cte_DefaultCategoryValue CTDCV ON ( CTDCV.PimCategoryId = TBAV.PimCategoryId AND CTDCV.PimAttributeId = TBAV.PimAttributeId );
                   
		    UPDATE  TBAV
			SET CategoryValue  = SUBSTRING ((SELECT ','+[dbo].FN_GetMediaThumbnailMediaPath(zm.Path) FROM ZnodeMedia ZM  WHERE EXISTS (SELECT TOP 1 1 FROM dbo.split(TBAV.CategoryValue ,',') SP  WHERE SP.Item = CAST(ZM.MediaId AS VARCHAR(50)) ) FOR XML PATH('')),2,4000)
			FROM @TBL_AttributeValue TBAV 
			INNER JOIN @TBL_MediaAttribute TBMA ON (TBMA.PimAttributeId = TBAV.PimAttributeId)	   
			
			INSERT INTO @TBL_AttributeValue ( PimCategoryId , CategoryValue , AttributeCode )

            SELECT PimCategoryId,AttributeFamilyName , 'AttributeFamily'
			FROM @TBL_FamilyDetails 				                           
		    

			INSERT INTO @TBL_AttributeValue             ( PimCategoryId , CategoryValue , AttributeCode     )
			--SELECT a.PimCategoryId  ,
			--CASE WHEN IsCategoryPublish = 1 THEN   'Published' WHEN IsCategoryPublish = 0 
			--THEN 'Draft'  ELSE 'Not Published' END, 'PublishStatus'
			--FROM @TBL_PimcategoryDetails a 
			--INNER JOIN ZnodePimCategory b ON (b.PimCategoryId = a.PimCategoryId)

			SELECT a.PimCategoryId PimCategoryId 
			,th.DisplayName, 'PublishStatus'
			FROM @TBL_PimcategoryDetails a 
			INNER JOIN ZnodePimCategory b ON (b.PimCategoryId = a.PimCategoryId)
			LEFT JOIN ZnodePublishState th ON (th.PublishStateId = b.PublishStateId)

			if (@PimCatalogId = -1)
			begin
				SET @CategoryXML =  '<MainCategory>'+ STUFF( (  SELECT '<Category>'+'<PimCategoryId>'+CAST(TBAD.PimCategoryId AS VARCHAR(50))+'</PimCategoryId>'+ STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST((SELECT ''+TBADI.CategoryValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
															FROM @TBL_AttributeValue TBADI      
																WHERE TBADI.PimCategoryId = TBAD.PimCategoryId 
																ORDER BY TBADI.PimCategoryId DESC
																FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Category>'	   

				FROM @TBL_AttributeValue TBAD
				INNER JOIN @TBL_PimcategoryDetails TBPI ON (TBAD.PimCategoryId = TBPI.PimCategoryId )
				WHERE not exists(select * from ZnodePimCategoryHierarchy ZPCH Where TBAD.PimCategoryId = ZPCH.PimCategoryId)
				GROUP BY TBAD.PimCategoryId,TBPI.RowId 
				ORDER BY TBPI.RowId 
				FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainCategory>'
			end
			else if (@PimCatalogId = 0)
			begin
				SET @CategoryXML =  '<MainCategory>'+ STUFF( (  SELECT '<Category>'+'<PimCategoryId>'+CAST(TBAD.PimCategoryId AS VARCHAR(50))+'</PimCategoryId>'+ STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST((SELECT ''+TBADI.CategoryValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
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
			end
			else if (@PimCatalogId > 0)
			begin
				SET @CategoryXML =  '<MainCategory>'+ STUFF( (  SELECT '<Category>'+'<PimCategoryId>'+CAST(TBAD.PimCategoryId AS VARCHAR(50))+'</PimCategoryId>'+ STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST((SELECT ''+TBADI.CategoryValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
														FROM @TBL_AttributeValue TBADI      
															WHERE TBADI.PimCategoryId = TBAD.PimCategoryId 
															ORDER BY TBADI.PimCategoryId DESC
															FOR XML PATH (''), TYPE
															).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Category>'	   

				FROM @TBL_AttributeValue TBAD
				INNER JOIN @TBL_PimcategoryDetails TBPI ON (TBAD.PimCategoryId = TBPI.PimCategoryId )
				WHERE exists(select * from ZnodePimCategoryHierarchy ZPCH Where TBAD.PimCategoryId = ZPCH.PimCategoryId and ZPCH.PimCatalogId = @PimCatalogId)
				GROUP BY TBAD.PimCategoryId,TBPI.RowId 
				ORDER BY TBPI.RowId 
				FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainCategory>'
			end

			SELECT  @CategoryXML  CategoryXMl
		   
		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA 
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1 
			 AND IsCategory = 1  
			 AND ZPA.IsShowOnGrid = 1  
			 UNION ALL 
			 SELECT 'PublishStatus','Publish Status'
		    SELECT ISNULL(@RowsCount,0) AS RowsCount;



			
			 --SELECT  PIV.PimCategoryId , PIV.CategoryName , ZPC.IsActive AS [Status] , dbo.FN_GetMediaThumbnailMediaPath ( Zm.Path ) AS CategoryImage , @LocaleId AS LocaleId , ISNULL(TBFD.AttributeFamilyName , '') AS AttributeFamilyName
             
			 --FROM @TBL_PimcategoryDetails AS TBCD 
			 --INNER JOIN ( SELECT PimCategoryId , CategoryValue , AttributeCode  FROM @TBL_AttributeValue) AS TBAV PIVOT(MAX(CategoryValue)                                                             
			 --FOR AttributeCode IN([CategoryName] , [CategoryImage])) PIV ON ( PIV.PimCategoryId = TBCD.PimCategoryId )
			 --LEFT JOIN @TBL_FamilyDetails AS TBFD ON ( TBFD.PimCategoryId = PIV.PimCategoryId )
			 --LEFT JOIN ZnodeMedia AS ZM ON ( CAST(ZM.MediaId AS VARCHAR(50)) = PIV.[CategoryImage] )
			 --LEFT JOIN ZnodePimCategory AS ZPC ON ( ZPC.PimCategoryId = PIV.PimCategoryId ) 
			 --ORDER BY RowId;
             
             --SET @RowsCount = ISNULL( ( SELECT TOP 1 CountId FROM @TBL_PimcategoryDetails) , 0);
         END TRY
         BEGIN CATCH
                DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_ManageCategoryList_XML @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+',@ProfileCatalogId='+CAST(@ProfileCatalogId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_ManageCategoryList_XML',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 go
	 if not exists(select * from sys.tables where name = 'ZnodePortalBrand')
begin
CREATE TABLE [dbo].[ZnodePortalBrand] (
    [PortalBrandId] INT      IDENTITY (1, 1) NOT NULL,
    [PortalId]      INT      NULL,
    [BrandId]       INT      NULL,
    [DisplayOrder]  INT      NULL,
    [CreatedBy]     INT      NOT NULL,
    [CreatedDate]   DATETIME NOT NULL,
    [ModifiedBy]    INT      NOT NULL,
    [ModifiedDate]  DATETIME NOT NULL,
    CONSTRAINT [PK_ZnodePortalBrandMapper] PRIMARY KEY CLUSTERED ([PortalBrandId] ASC),
    CONSTRAINT [FK_ZnodePortalBrand_ZnodeBrandDetails] FOREIGN KEY ([BrandId]) REFERENCES [dbo].[ZnodeBrandDetails] ([BrandId]),
    CONSTRAINT [FK_ZnodePortalBrand_ZnodePortal] FOREIGN KEY ([PortalId]) REFERENCES [dbo].[ZnodePortal] ([PortalId])
);
end
go
if exists(select * from sys.procedures where name = 'Znode_GetPortalBrandDetail')
	drop proc Znode_GetPortalBrandDetail
go
CREATE PROCEDURE [dbo].[Znode_GetPortalBrandDetail]  
( @WhereClause  NVARCHAR(MAX)='',  
  @Rows    INT           = 2147483647,  
  @PageNo   INT           = 1,  
  @Order_BY   VARCHAR(1000) = '',  
  @RowsCount  INT           = 0 OUT,  
  @LocaleId   INT           = 1,
  @PortalId     INT           = null ,     
  @IsAssociated  BIT           = 0,  
  @PromotionId      INT     = 0   
)  
AS  
  /*  
     Summary :- This Procedure is used to get brand localies   
     Unit Testing   
  begin tran  
     EXEC [Znode_GetPortalBrandDetail_R] @WhereClause='',@PortalId=null, @IsAssociated = 0
	 EXEC [Znode_GetPortalBrandDetail_R] @WhereClause   = '' ,    
     @Rows                    = 100 ,    
     @PageNo                  = 1 ,    
     @Order_BY      = '' ,    
     @RowsCount     =0  ,    
     @PortalId= 1 ,    
     @IsAssociated            = 1  
  rollback tran    
 */  
BEGIN  
BEGIN TRY  
        SET NOCOUNT ON;  
        DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();  
        DECLARE @SeoId VARCHAR(MAX)= '', @SQL NVARCHAR(MAX); --, @SeoCode NVARCHAR(MAX) ;
		DECLARE @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId')
        
		DECLARE @TBL_BrandDetails TABLE  
        (
			Description         NVARCHAR(MAX),  
			BrandId             INT,  
			BrandCode           VARCHAR(600),  
			DisplayOrder        INT,  
			IsActive            BIT,  
			WebsiteLink         NVARCHAR(1000),  
			BrandDetailLocaleId INT,  
			SEOFriendlyPageName NVARCHAR(600),  
			MediaPath           NVARCHAR(MAX),  
			MediaId             INT,  
			ImageName           VARCHAR(300),
			BrandName			VARCHAR(100),	
			Custom1				NVARCHAR(MAX),	
			Custom2				NVARCHAR(MAX),
			Custom3				NVARCHAR(MAX),
			Custom4				NVARCHAR(MAX),
			Custom5				NVARCHAR(MAX),
			PortalId			Int,
			IsAssociated        Bit 
        );  
  
    DECLARE @AttributeId INT= [dbo].[Fn_GetProductBrandAttributeId]();  
             
	DECLARE @TBL_AttributeDefault TABLE  
    (
		PimAttributeId            INT,  
		AttributeDefaultValueCode VARCHAR(600),  
		IsEditable                BIT,  
		AttributeDefaultValue     NVARCHAR(MAX),
		DisplayOrder			  INT   
    );  

    DECLARE @TBL_SeoDetails TABLE  
    (
		CMSSEODetailId       INT,  
		SEOTitle             NVARCHAR(MAX),  
		SEOKeywords          NVARCHAR(MAX),  
		SEOURL               NVARCHAR(MAX),  
		ModifiedDate         DATETIME,  
		SEODescription       NVARCHAR(MAX),  
		MetaInformation      NVARCHAR(MAX),  
		IsRedirect           BIT,  
		CMSSEODetailLocaleId INT,  
		--SEOId                INT ,
		PublishStatus        NVARCHAR(20),
		SEOCode				 NVARCHAR(4000),
		CanonicalURL		 VARCHAR(200),
		RobotTag			 VARCHAR(50)			   
    );  

    DECLARE @TBL_BrandDetail TABLE  
    (
		Description          NVARCHAR(MAX),  
		BrandId              INT,  
		BrandCode            VARCHAR(600),  
		DisplayOrder         INT,  
		IsActive             BIT,  
		WebsiteLink          NVARCHAR(1000),  
		BrandDetailLocaleId  INT,  
		MediaPath            NVARCHAR(MAX),  
		MediaId              INT,  
		ImageName      VARCHAr(300) ,  
		CMSSEODetailId       INT,  
		SEOTitle             NVARCHAR(MAX),  
		SEOKeywords          NVARCHAR(MAX),  
		SEOURL               NVARCHAR(MAX),  
		ModifiedDate         DATETIME,  
		SEODescription       NVARCHAR(MAX),  
		MetaInformation      NVARCHAR(MAX),  
		IsRedirect           BIT,  
		CMSSEODetailLocaleId INT,  
		--SEOId                INT,  
		BrandName            NVARCHAR(MAX),  
		RowId                INT,  
		CountId              INT ,
		SEOCode              NVARCHAR(4000), 
		Custom1              NVARCHAR(MAX),
		Custom2              NVARCHAR(MAX),
		Custom3              NVARCHAR(MAX),
		Custom4              NVARCHAR(MAX),
		Custom5              NVARCHAR(MAX),
		PortalId			 INT
    );  
             
	IF @PromotionId > 0  
    BEGIN         
		 SET @SeoId = ISNULL(SUBSTRING((SELECT ','+CAST(BrandId AS VARCHAR(50))  
		 FROM ZnodePromotionBrand   
		 WHERE PromotionId= @PromotionId  FOR XML PATH ('') ),2,4000),'0')  
  
		 SET @WhereClause = CASE WHEN @IsAssociated = 1 THEN ' BrandId IN (' ELSE ' BrandId NOT IN (' END  +@SeoId+') AND '+CASE WHEN @WhereClause = '' THEN '1=1' ELSE @WhereClause END   
		 SET @SeoId = ''  
    END    
  
    ;WITH Cte_GetBrandBothLocale AS 
	(
		SELECT ZBDL.Description,ZBD.BrandId,LocaleId,ZBD.BrandCode,isnull(ZPB.DisplayOrder,999) as DisplayOrder,ZBD.IsActive,ZBD.WebsiteLink,ZBDl.BrandDetailLocaleId,  
			SEOFriendlyPageName,[dbo].[Fn_GetMediaThumbnailMediaPath](Zm.path) MediaPath,ZBD.MediaId,Zm.path ImageName, ZBDL.BrandName, ZBD.Custom1, ZBD.Custom2, ZBD.Custom3, ZBD.Custom4, ZBD.Custom5, ZPB.PortalId,
			CASE WHEN ZPB.PortalBrandId IS NULL THEN 0 ELSE 1 END IsAssociated
		FROM ZnodeBrandDetails ZBD 
		LEFT JOIN ZnodePortalBrand ZPB ON ZBD.BrandId = ZPB.BrandId AND (ZPB.PortalId = @PortalId OR isnull(@PortalId,0) = 0 )
		LEFT JOIN ZnodeBrandDetailLocale ZBDL ON(ZBD.BrandId = ZBDL.BrandId)  
		LEFT JOIN ZnodeMedia ZM ON(ZM.MediaId = ZBD.MediaId)  
		WHERE LocaleId IN(@LocaleId, @DefaultLocaleId)  
		
              
    ),  
    Cte_BrandFirstLocale AS 
	(
		SELECT Description,BrandId,LocaleId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,SEOFriendlyPageName,MediaPath,MediaId,ImageName , BrandName, Custom1, Custom2, Custom3, Custom4, Custom5, PortalId , IsAssociated
        FROM Cte_GetBrandBothLocale CTGBBL  
        WHERE LocaleId = @LocaleId
	),  
    Cte_BrandDefaultLocale AS 
	(
		SELECT Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,SEOFriendlyPageName,MediaPath,MediaId,ImageName, BrandName, Custom1, Custom2, Custom3, Custom4, Custom5, PortalId, IsAssociated  
        FROM Cte_BrandFirstLocale  
        UNION ALL  
        SELECT Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,SEOFriendlyPageName,MediaPath,MediaId,ImageName , BrandName, Custom1, Custom2, Custom3, Custom4, Custom5, PortalId, IsAssociated
		FROM Cte_GetBrandBothLocale CTBBL  
		WHERE LocaleId = @DefaultLocaleId  
		AND NOT EXISTS  
		(  
			SELECT TOP 1 1  
			FROM Cte_BrandFirstLocale CTBFL  
			WHERE CTBBL.BrandId = CTBFL.BrandId  
		)
	)    
    INSERT INTO @TBL_BrandDetails (Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,MediaPath,MediaId,ImageName, BrandName, Custom1, Custom2, Custom3, Custom4, Custom5, PortalId, IsAssociated)  
    SELECT Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,MediaPath,MediaId,ImageName , BrandName, Custom1, Custom2, Custom3, Custom4, Custom5, PortalId, IsAssociated
    FROM Cte_BrandDefaultLocale CTEBD;  
       
	-----Update BrandName from attributedefault value
	;WITH Cte_GetBrandNameLocale AS 
	(
		select d.brandcode, a.AttributeDefaultValueCode, b.AttributeDefaultValue, b.LocaleId 
		from ZnodePimAttributeDefaultValue a
		inner join ZnodePimAttributeDefaultValueLocale b on a.PimAttributeDefaultValueId = b.PimAttributeDefaultValueId 
		inner join ZnodePimAttribute c on a.PimAttributeId = c.PimAttributeId
		inner join @TBL_BrandDetails d on a.AttributeDefaultValueCode = d.brandcode
		where c.attributecode = 'brand' and b.LocaleId IN(@LocaleId, @DefaultLocaleId)
              
    )
	,Cte_BrandNameFirstLocale AS 
	(
		SELECT brandcode, AttributeDefaultValueCode, AttributeDefaultValue, LocaleId  
        FROM Cte_GetBrandNameLocale CTGBBL  
        WHERE LocaleId = @LocaleId
	)
	,Cte_BrandDefaultLocale AS 
	(
		SELECT brandcode, AttributeDefaultValueCode, AttributeDefaultValue, LocaleId  
        FROM Cte_BrandNameFirstLocale  
        UNION ALL  
        SELECT brandcode, AttributeDefaultValueCode, AttributeDefaultValue, LocaleId  
		FROM Cte_GetBrandNameLocale CTBBL  
		WHERE LocaleId = @DefaultLocaleId  
		AND NOT EXISTS  
		(  
			SELECT TOP 1 1  
			FROM Cte_BrandNameFirstLocale CTBFL  
			WHERE CTBBL.brandcode = CTBFL.brandcode  
		)
	)  
	update b1 set b1.brandname = a1.AttributeDefaultValue
	from Cte_BrandDefaultLocale a1
	inner join @TBL_BrandDetails b1 on a1.brandcode = b1.brandcode

	DECLARE @SeoCode SelectColumnList
	INSERT INTO @SeoCode
	SELECT BrandCode FROM @TBL_BrandDetails
				
    INSERT INTO @TBL_SeoDetails 
	(
		CMSSEODetailId,SEOTitle,SEOKeywords,SEOURL,ModifiedDate,SEODescription,MetaInformation,IsRedirect,
		CMSSEODetailLocaleId,PublishStatus,SEOCode,CanonicalURL,RobotTag
	)  
    EXEC Znode_GetSeoDetails @SeoCode, 'Brand', @LocaleId;  
			              
    SELECT TBBD.*,TBSD.*--,TBAD.AttributeDefaultValue BrandName,TBAD.AttributeDefaultValueCode  
    INTO #TM_BrandLocale  
    FROM @TBL_BrandDetails TBBD  
    LEFT JOIN @TBL_SeoDetails TBSD ON(TBSD.SEOCode = TBBD.BrandCode)  
    --INNER JOIN @TBL_AttributeDefault TBAD ON(TBAD.AttributeDefaultValueCode = TBBD.BrandCode);  
  
	SET @SQL = 
	'  
     SELECT * ,Count(*)Over() CountId  
     into #Cte_BrandDetails
	 FROM #TM_BrandLocale TMADV  
     WHERE IsAssociated = '+cast(@IsAssociated as varchar(10))+'  
     '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+'  
     
    SELECT '+[dbo].[Fn_GetPagingRowId](@Order_BY, 'BrandId DESC')+',Description  , BrandId , BrandCode , DisplayOrder  ,IsActive  ,WebsiteLink ,BrandDetailLocaleId   
         , MediaPath ,MediaId,ImageName ,CMSSEODetailId ,SEOTitle ,SEOKeywords , SEOURL   
         , ModifiedDate  ,  SEODescription   ,MetaInformation   ,IsRedirect ,CMSSEODetailLocaleId  
         ,BrandName  ,CountId ,SEOCode,  Custom1, Custom2, Custom3, Custom4, Custom5, PortalId  
    into #BrandDetails 
	FROM #Cte_BrandDetails  
    '+[dbo].[Fn_GetOrderByClause](@Order_BY, 'BrandId DESC')+' 
	
	select Description  , BrandId , BrandCode , DisplayOrder  ,IsActive  ,WebsiteLink ,BrandDetailLocaleId   
         , MediaPath ,MediaId,ImageName ,CMSSEODetailId ,SEOTitle ,SEOKeywords , SEOURL   
         , ModifiedDate  ,  SEODescription   ,MetaInformation   ,IsRedirect ,CMSSEODetailLocaleId  
         ,BrandName ,RowId  ,CountId ,SEOCode,  Custom1, Custom2, Custom3, Custom4, Custom5, PortalId 
	from #BrandDetails'+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'BrandId DESC');  
  
	print @SQL
     INSERT INTO @TBL_BrandDetail  
     (  
		Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,  
		BrandDetailLocaleId,MediaPath,MediaId,ImageName,CMSSEODetailId,SEOTitle,  
		SEOKeywords,SEOURL,ModifiedDate,SEODescription,MetaInformation,IsRedirect,  
		CMSSEODetailLocaleId,BrandName,RowId,CountId ,SEOCode , Custom1, Custom2, Custom3, Custom4, Custom5, PortalId   
     )  
     EXEC (@SQL);  
             
	SET @RowsCount = ISNULL(  
                        (  
                            SELECT TOP 1 CountId  
                            FROM @TBL_BrandDetail  
                        ), 0);  
    SELECT BrandId,Description,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,MediaPath,MediaId,ImageName,CMSSEODetailId,SEOTitle,SEOKeywords,SEOURL SEOFriendlyPageName,SEODescription,MetaInformation,IsRedirect,CMSSEODetailLocaleId,BrandName,@PromotionId PromotionId   
    ,SEOCode,Custom1, Custom2, Custom3, Custom4, Custom5, PortalId
	FROM @TBL_BrandDetail;  
	
END TRY  
BEGIN CATCH  
	DECLARE @Status BIT ;  
	SET @Status = 0;  
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),   
	@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPortalBrandDetail @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))
	+',@PortalId='+CAST(@PortalId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@PromotionId='+CAST(@PromotionId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
		SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
		EXEC Znode_InsertProcedureErrorLog  
	@ProcedureName = 'Znode_GetPortalBrandDetail',  
	@ErrorInProcedure = @Error_procedure,  
	@ErrorMessage = @ErrorMessage,  
	@ErrorLine = @ErrorLine,  
	@ErrorCall = @ErrorCall;  
END CATCH;  
END;
go
if exists(select * from sys.procedures where name = 'Znode_AssociatePortalBrand')
	drop proc Znode_AssociatePortalBrand
go
  
CREATE PROCEDURE [dbo].[Znode_AssociatePortalBrand]   
(  
	 @PortalId INT = 0,  
	 @BrandId  VARCHAR(MAX) = '',  
	 @IsAssociated BIT, -----0 = UnAssociate, 1 = Associate  
	 @UserId INT,  
	 @Status BIT OUT  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
  
 BEGIN TRY  
 BEGIN TRAN
	 DECLARE @GetDate DATETIME= dbo.Fn_GetDate();  
	 DECLARE @DisplayOrder INT = 999; 
  
	 IF ( @IsAssociated = 1 )  
	 BEGIN  
		  INSERT INTO ZnodePortalBrand ( PortalId, BrandId, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )   
		  SELECT @PortalId, P.Item ,@DisplayOrder, @UserId, @GetDate, @UserId, @GetDate  
		  FROM dbo.Split ( @BrandId , ',' ) P  
		  WHERE NOT Exists ( SELECT  * FROM ZnodePortalBrand BP WHERE  BP.BrandId=P.Item AND BP.PortalId = @PortalId ) 
		   and P.Item <> '' 
	 END  
	 ELSE IF ( @IsAssociated = 0 )  
	 BEGIN    
		DELETE FROM ZnodePortalBrand  
		WHERE EXISTS( SELECT * FROM dbo.Split ( @BrandId , ',' ) P WHERE ZnodePortalBrand.BrandId = P.Item AND ZnodePortalBrand.PortalId = @PortalId )   
	 END  
  
	 SELECT 1 AS ID, CAST(1 AS bit) AS Status;  
 COMMIT TRAN
END TRY  
BEGIN CATCH    
	   ROLLBACK TRAN
       SET @Status = 0;  
       DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AssociatePortalBrand @PortalId = '+CAST(@PortalId AS VARCHAR(max))+',@BrandId='+CAST(@BrandId AS VARCHAR(50))+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@UserId='+CAST( @UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
		  SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
		  EXEC Znode_InsertProcedureErrorLog  
		  @ProcedureName = 'Znode_AssociatePortalBrand',  
		  @ErrorInProcedure = @Error_procedure,  
		  @ErrorMessage = @ErrorMessage,  
		  @ErrorLine = @ErrorLine,  
		  @ErrorCall = @ErrorCall;  
END CATCH  
  
END  
go
insert into ZnodeApplicationSetting (GroupName,	ItemName,	Setting,	ViewOptions,	FrontPageName,	FrontObjectName,	IsCompressed,	OrderByFields,	ItemNameWithoutCurrency,	CreatedByName,	ModifiedByName,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
select 'Table','ZnodePortalBrandList','<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>BrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PortalId</name>      <headertext>PortalId</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Brand Image</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>BrandId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,BrandName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>BrandCode</name>      <headertext>Brand Code</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/PIM/Brand/Edit</islinkactionurl>      <islinkparamfield>BrandId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>5</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsActive</name>      <headertext>Is Active</headertext>      <width>0</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Store/UpdateAssociatedPortalBrandDetail|/Store/UnAssociatePortalBrand</manageactionurl>      <manageparamfield>BrandId,PortalId,BrandCode,DisplayOrder|BrandId,PortalId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>',
'ZnodePortalBrandList','ZnodePortalBrandList','ZnodePortalBrandList',0,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where GroupName = 'Table' and ItemName = 'ZnodePortalBrandList')

insert into ZnodeApplicationSetting (GroupName,	ItemName,	Setting,	ViewOptions,	FrontPageName,	FrontObjectName,	IsCompressed,	OrderByFields,	ItemNameWithoutCurrency,	CreatedByName,	ModifiedByName,	CreatedBy,	CreatedDate,	ModifiedBy,	ModifiedDate)
select 'Table','ZnodePortalBrandAssociatedList','<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>BrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Brand Image</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>BrandId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,BrandName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>BrandCode</name>      <headertext>Brand Code</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/PIM/Brand/Edit</islinkactionurl>      <islinkparamfield>BrandId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>IsActive</name>      <headertext>Is Active</headertext>      <width>0</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>',
'ZnodePortalBrandAssociatedList','ZnodePortalBrandAssociatedList','ZnodePortalBrandAssociatedList',0,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where GroupName = 'Table' and ItemName = 'ZnodePortalBrandAssociatedList')

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>      <column>          <id>1</id>          <name>BrandId</name>          <headertext>Checkbox</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>Int32</columntype>          <allowsorting>false</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>y</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>2</id>          <name>Image</name>          <headertext>Brand Image</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>false</allowsorting>          <allowpaging>false</allowpaging>          <format>Edit</format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield>BrandId</checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext>Edit</displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield>MediaPath,BrandName</imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class>imageicon</Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>3</id>          <name>BrandCode</name>          <headertext>Brand Code</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>y</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>4</id>          <name>BrandName</name>          <headertext>Brand Name</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>y</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>y</isallowlink>          <islinkactionurl>/PIM/Brand/Edit</islinkactionurl>          <islinkparamfield>BrandId</islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>5</id>          <name>MediaId</name>          <headertext>MediaId</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>Int32</columntype>          <allowsorting>false</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>n</isvisible>          <mustshow>n</mustshow>          <musthide>y</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>6</id>          <name>WebsiteLink</name>          <headertext>Web SiteLink</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>n</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>7</id>          <name>SEOTitle</name>          <headertext>SEO Title</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>y</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>8</id>          <name>SEOKeywords</name>          <headertext>SEO Keyword</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>9</id>          <name>SEODescription</name>          <headertext>SEO Description</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>10</id>          <name>SEOFriendlyPageName</name>          <headertext>SEO Friendly Page Name</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>false</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>n</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>        <column>          <id>12</id>          <name>IsActive</name>          <headertext>Is Active</headertext>          <width>0</width>          <datatype>Boolean</datatype>          <columntype>Boolean</columntype>          <allowsorting>false</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>13</id>          <name>Manage</name>          <headertext>Action</headertext>          <width>0</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>false</allowsorting>          <allowpaging>true</allowpaging>          <format>Edit|Delete</format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext>Edit|Delete</displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl>/PIM/Brand/Edit|/PIM/Brand/Delete</manageactionurl>          <manageparamfield>BrandId|BrandId</manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>  </columns>'
where ItemName = 'ZnodeBrandDetails'

update  ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>BrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Brand Image</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>BrandId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,BrandName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>BrandCode</name>      <headertext>Brand Code</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/PIM/Brand/Edit</islinkactionurl>      <islinkparamfield>BrandId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>IsActive</name>      <headertext>Is Active</headertext>      <width>0</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodePortalBrandAssociatedList'

update  ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>BrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PortalId</name>      <headertext>PortalId</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Brand Image</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>BrandId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,BrandName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>BrandCode</name>      <headertext>Brand Code</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/PIM/Brand/Edit</islinkactionurl>      <islinkparamfield>BrandId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>5</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsActive</name>      <headertext>Is Active</headertext>      <width>0</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Store/UpdateAssociatedPortalBrandDetail|/Store/UnAssociatePortalBrand</manageactionurl>      <manageparamfield>BrandId,PortalId,BrandCode,DisplayOrder|BrandId,PortalId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodePortalBrandList'
go
if not exists(select * from INFORMATION_SCHEMA.columns where TABLE_NAME = 'ZnodePortalPageSetting' and COLUMN_NAME = 'IsDefault')
begin
alter table ZnodePortalPageSetting add [IsDefault] BIT CONSTRAINT [DF_ZnodePortalPageSetting_IsDefault] DEFAULT ((0)) NULL
end
go
UPDATE ZnodeApplicationSetting SET Setting ='<?xml version="1.0" encoding="UTF-8"?><columns><column><id>1</id><name>PortalPageSettingId</name><headertext>Checkbox</headertext><width>0</width><datatype>String</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>y</ischeckbox><checkboxparamfield /><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>PageDisplayName</name><headertext>Page</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>100</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>DisplayOrder</name><headertext>Display Order</headertext><width>40</width><datatype>String</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>IsDefault</name><headertext>Is Default</headertext><width>40</width><datatype>Boolean</datatype><columntype>Boolean</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>y</iscontrol><controltype>DropDown</controltype><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>Manage</name><headertext>Action</headertext><width>50</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Edit|Delete</format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>PortalId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Edit|Delete</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl>/Store/EditAssociatedPageSetting|/Store/RemoveAssociatedPageSetting</manageactionurl><manageparamfield>PortalPageSettingId,PortalId,IsDefault|PortalPageSettingId,PortalId</manageparamfield><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>' 
WHERE ItemName= 'AssociatedPageListToPortal'
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Store','EditAssociatedPageSetting',1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Store' and ActionName = 'EditAssociatedPageSetting')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores & Reps' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores & Reps' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting'))

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores & Reps' AND ControllerName = 'Store'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores & Reps' AND ControllerName = 'Store') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'EditAssociatedPageSetting'))

GO
;with cte as
(
	select * from ZnodePortalPageSetting zpps
	where IsDefault = 0 
	and not exists(select * from ZnodePortalPageSetting zpps1 where zpps.PortalId = zpps1.PortalId and IsDefault = 1)
)
update a set IsDefault = 1 
from ZnodePortalPageSetting a
inner join cte b on a.PortalId = b.PortalId
where not exists (select top 1 PageSettingId from cte zps where a.PortalId = zps.PortalId 
				and zps.PageSettingId = (select top 1 PageSettingId from ZnodePageSetting where PageName = 'Show 16') )
and a.PageSettingId = (select min(c.PageSettingId) from cte c where a.PortalId = c.PortalId )
go
;with cte as
(
	select * from ZnodePortalPageSetting zpps
	where IsDefault = 0 
	and not exists(select * from ZnodePortalPageSetting zpps1 where zpps.PortalId = zpps1.PortalId and IsDefault = 1)
)
update a set IsDefault = 1 
from ZnodePortalPageSetting a
inner join cte b on a.PortalId = b.PortalId
where a.PageSettingId = (select top 1 PageSettingId from ZnodePageSetting where PageName = 'Show 16') 

insert into ZnodePortalPageSetting(PortalId,PageSettingId,PageDisplayName,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsDefault)
select PortalId,PageSettingId,
PageName,1,2,getdate(),2,getdate(),case when PageName = 'Show 16' then 1 else 0 end
from ZnodePortal ZP
cross apply ZnodePageSetting zps 
where not exists(select * from ZnodePortalPageSetting ZPPS where ZP.PortalId = ZPPS.PortalId)
go
UPDATE ZnodeApplicationSetting SET Setting ='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>BrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Brand Image</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>BrandId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,BrandName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>BrandCode</name>      <headertext>Brand Code</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>IsActive</name>      <headertext>Is Active</headertext>      <width>0</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>' 
WHERE ItemName= 'ZnodePortalBrandAssociatedList'

UPDATE ZnodeApplicationSetting SET Setting ='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>BrandId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PortalId</name>      <headertext>PortalId</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Brand Image</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>BrandId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>MediaPath,BrandName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>BrandCode</name>      <headertext>Brand Code</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>BrandName</name>      <headertext>Brand Name</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>5</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsActive</name>      <headertext>Is Active</headertext>      <width>0</width>      <datatype>Boolean</datatype>      <columntype>Boolean</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Store/UpdateAssociatedPortalBrandDetail|/Store/UnAssociatePortalBrand</manageactionurl>      <manageparamfield>BrandId,PortalId,BrandCode,DisplayOrder|BrandId,PortalId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>' 
WHERE ItemName= 'ZnodePortalBrandList'
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Store','BrandList',1,2,Getdate(),2,Getdate() 
where not exists(select * from ZnodeActions where ControllerName = 'Store' and ActionName = 'BrandList')

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'BrandList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'BrandList'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'BrandList')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'BrandList'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WebSite','GetUnAssociatedBrandList',1,2,Getdate(),2,Getdate() 
where not exists(select * from ZnodeActions where ControllerName = 'WebSite' and ActionName = 'GetUnAssociatedBrandList')

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'GetUnAssociatedBrandList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'GetUnAssociatedBrandList'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'GetUnAssociatedBrandList')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'GetUnAssociatedBrandList'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Store','GetUnAssociatedBrandList',1,2,Getdate(),2,Getdate() 
where not exists(select * from ZnodeActions where ControllerName = 'Store' and ActionName = 'GetUnAssociatedBrandList')

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'GetUnAssociatedBrandList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'GetUnAssociatedBrandList'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'GetUnAssociatedBrandList')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'GetUnAssociatedBrandList'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Store','AssociatePortalBrand',1,2,Getdate(),2,Getdate() 
where not exists(select * from ZnodeActions where ControllerName = 'Store' and ActionName = 'AssociatePortalBrand')

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'AssociatePortalBrand') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'AssociatePortalBrand'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'AssociatePortalBrand')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'AssociatePortalBrand'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Store','UnAssociatePortalBrand',1,2,Getdate(),2,Getdate() 
where not exists(select * from ZnodeActions where ControllerName = 'Store' and ActionName = 'UnAssociatePortalBrand')

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UnAssociatePortalBrand') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UnAssociatePortalBrand'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UnAssociatePortalBrand')	
,4,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UnAssociatePortalBrand'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Store','UpdateAssociatedPortalBrandDetail',1,2,Getdate(),2,Getdate() 
where not exists(select * from ZnodeActions where ControllerName = 'Store' and ActionName = 'UpdateAssociatedPortalBrandDetail')

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UpdateAssociatedPortalBrandDetail') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UpdateAssociatedPortalBrandDetail'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store')	
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UpdateAssociatedPortalBrandDetail')	
,4,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Stores' AND ControllerName = 'Store') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Store' and ActionName= 'UpdateAssociatedPortalBrandDetail'))

GO
if not exists(select * from INFORMATION_SCHEMA.columns where TABLE_NAME = 'ZnodeInventory' and COLUMN_NAME = 'BackOrderQuantity')
begin
alter table ZnodeInventory add [BackOrderQuantity] NUMERIC (28, 6) CONSTRAINT [DF_ZnodeInventory_BackOrderQuantity] DEFAULT ((0)) NOT NULL
end
go
if not exists(select * from INFORMATION_SCHEMA.columns where TABLE_NAME = 'ZnodeInventory' and COLUMN_NAME = 'BackOrderExpectedDate')
begin
alter table ZnodeInventory add [BackOrderExpectedDate] DATETIME        NULL
end
go
if exists(select * from sys.procedures where name = 'Znode_GetSKUInventoryList')
	drop proc Znode_GetSKUInventoryList
go
  
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
			 CREATE TABLE #TBL_InventoryList  (PimProductId int,InventoryId INT ,WarehouseId INT ,WarehouseCode NVARCHAR(100),WarehouseName VARCHAR(100),SKU  VARCHAR(300)
			 ,Quantity NUMERIC (28,6),ReOrderLevel NUMERIC (28,6),BackOrderQuantity NUMERIC(28,6),BackOrderExpectedDate Datetime,IsDownloadable bit default 0,ProductName NVARCHAR(max),RowId INT,CountNo INT);

             DECLARE @DefaultLocaleId VARCHAR(100)= Dbo.Fn_GetDefaultValue('Locale');
             
             IF  OBJECT_ID('tempdb..#TBL_AttributeVAlue') is not null
			 BEGIN 
				DROP TABLE #TBL_AttributeVAlue
			 END 	

			 CREATE TABLE #TBL_AttributeVAlue (PimProductId int,	PimAttributeId int,	AttributeValue VARCHAR(1000),AttributeCode	VARCHAR(300),LocaleId int, IsDownloadable bit not null  default 0)

			 DECLARE @PimAttributeSKUId INT = dbo.FN_GetProductSKUAttributeid()
			 ,@PimAttributeProductNameId INT = dbo.FN_GetProductNameAttributeid()

			 if @DefaultLocaleId <> @LocaleId
			 begin
				 INSERT INTO #TBL_AttributeValue(PimProductId, PimAttributeId, AttributeValue, AttributeCode, LocaleId)
				 SELECT VI.PimProductId,VI.PimAttributeId,VI2.AttributeValue,Case when VI.PimAttributeId =@PimAttributeSKUId then 'SKU'
						Else 'ProductName' END  AttributeCode,VI2.LocaleId --,COUNT(*)Over(Partition By VI.PimProductId,VI.PimAttributeId ORDER BY VI.PimProductId,VI.PimAttributeId  ) RowId
				 FROM  ZnodePimAttributeValue  VI 
				 INNER JOIN ZnodePimAttributeValueLocale VI2 ON (VI.PimAttributeValueId = VI2.PimAttributeValueId )
				 WHERE ( LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId )
				 AND  VI.PimAttributeId IN ( @PimAttributeSKUId,@PimAttributeProductNameId)	
			end
			else
			begin
				INSERT INTO #TBL_AttributeValue(PimProductId, PimAttributeId, AttributeValue, AttributeCode, LocaleId)
				SELECT VI.PimProductId,VI.PimAttributeId,VI2.AttributeValue,Case when VI.PimAttributeId =@PimAttributeSKUId then 'SKU'
						Else 'ProductName' END  AttributeCode,VI2.LocaleId --,COUNT(*)Over(Partition By VI.PimProductId,VI.PimAttributeId ORDER BY VI.PimProductId,VI.PimAttributeId  ) RowId
				 FROM  ZnodePimAttributeValue  VI 
				 INNER JOIN ZnodePimAttributeValueLocale VI2 ON (VI.PimAttributeValueId = VI2.PimAttributeValueId )
				 WHERE (LocaleId = @DefaultLocaleId )
				 AND  VI.PimAttributeId IN ( @PimAttributeSKUId,@PimAttributeProductNameId)	
			end


			 Update a
			 set a.IsDownloadable=1
			 From #TBL_AttributeVAlue a
			 inner join ZnodePimDownloadableProduct b on  a.AttributeValue=b.SKU
			 WHERE a.AttributeCode = 'SKU'  

			SELECT  CTE.PimProductId , CTEI.AttributeValue ProductName,ZW.WarehouseCode,ZW.WarehouseName , CTEI.LocaleId,SKU,SPN.InventoryId,SPN.WarehouseId
				,SPN.Quantity,SPN.ReOrderLevel,SPN.BackOrderQuantity,SPN.BackOrderExpectedDate,cte.IsDownloadable
			into #CTE_InventoryListWithSKU
			FROM #TBL_AttributeVAlue CTE
			INNER JOIN #TBL_AttributeVAlue CTEI ON (CTEI.PimProductId = CTE.Pimproductid 
									AND CTEI.AttributeCode = 'ProductName' )
			INNER JOIN ZnodeInventory  SPN ON (SPN.SKU  = CTE.AttributeValue)
			LEFT JOIN ZnodeWarehouse ZW ON (ZW.WarehouseId = SPN.WarehouseId) 
			WHERE CTE.AttributeCode = 'SKU' 		
					
			 SET @SQL = '
					SELECT PimProductId, InventoryId,WarehouseId,WarehouseCode,WarehouseName,SKU,Quantity,ReOrderLevel,BackOrderQuantity,BackOrderExpectedDate,IsDownloadable,ProductName
					,'+dbo.Fn_GetPagingRowId(@Order_BY,'InventoryId DESC')+',Count(*)Over() CountNo 
					into #CTE_ListDetailForPaging
					FROM #CTE_InventoryListWithSKU
					WHERE 1=1 
						'+dbo.Fn_GetFilterWhereClause(@WhereClause)+'
				
				SELECT PimProductId,InventoryId,WarehouseId,WarehouseCode,WarehouseName,dbo.Fn_Trim(SKU)SKU,Quantity,ReOrderLevel,BackOrderQuantity,BackOrderExpectedDate,IsDownloadable,dbo.Fn_Trim(ProductName)ProductName,RowId,CountNo
				FROM #CTE_ListDetailForPaging 
				'+dbo.Fn_GetPaginationWhereClause(@PageNo,@Rows)



				INSERT INTO #TBL_InventoryList(PimProductId,InventoryId,WarehouseId,WarehouseCode,WarehouseName,SKU,Quantity,ReOrderLevel,BackOrderQuantity,BackOrderExpectedDate,IsDownloadable,ProductName,RowId,CountNo)
				EXEC (@SQL);

            SET @RowsCount = ISNULL((SELECT TOP 1 CountNo FROM #TBL_InventoryList), 0);

            SELECT PimProductId,InventoryId,WarehouseId,WarehouseCode,WarehouseName,SKU,Quantity,ReOrderLevel,BackOrderQuantity,BackOrderExpectedDate,IsDownloadable,ProductName
			FROM #TBL_InventoryList;
         
         END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetSKUInventoryList @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''');
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetSKUInventoryList',
				@ErrorInProcedure = 'Znode_GetSKUInventoryList',
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
go
if exists(select * from sys.procedures where name = 'Znode_GetCategoryIdForPaging')
	drop proc Znode_GetCategoryIdForPaging
go
CREATE PROCEDURE [dbo].[Znode_GetCategoryIdForPaging]
( @WhereClauseXML XML           = '',
  @Rows           INT           = 10,
  @PageNo         INT           = 1,
  @Order_BY       VARCHAR(1000) = '',
  @RowsCount      INT,
  @LocaleId       INT           = 1,
  @AttributeCode  VARCHAR(MAX)  = '',
  @PimCategoryId  VARCHAR(MAX) = 0,
  @IsAssociated   BIT           = 0,
  @IsDebug    int  = 0)
AS 
/*
     Summary:- This Procedure is used to get CategoryDetails With paging from XML
     Unit Testing 
	 begin tran
	 -- SELECT * FROM ZnodePimCategoryAttributeValueLocale WHERE CategoryValue LIKE '%test%'
     EXEC Znode_GetCategoryIdForPaging '' ,10,1,'',0,1,'','29,26,28',1
	rollback tran
	*/

     BEGIN
         BEGIN TRY
             DECLARE @WhereClause TABLE
             (Id          INT IDENTITY(1, 1),
              WhereClause NVARCHAR(MAX)
             );
             DECLARE @SQL NVARCHAR(MAX)= '', @OrderClause NVARCHAR(MAX), @JoinWhereClause NVARCHAR(MAX)= '', @DefaultLocaleId VARCHAR(20)= dbo.Fn_GetDefaultLocaleId(), @LocaleIds VARCHAR(20)= @LocaleId;
             DECLARE @ValueId INT= 1, @MaxValueId INT= 0;
             DECLARE @TBL_PimCategoryId TABLE (PimCategoryId INT ,RowId INT , CountNo INT )
				
			 IF @PimCategoryId <> '0' AND @PimCategoryId <> ''
                
                 BEGIN
                     SET @SQL = ' 
					     DECLARE @TBL_PimCategoryId TABLE (PimCategoryId INT )
						INSERT INTO @TBL_PimCategoryId
						SELECT Item FROM dbo.Split('''+@PimCategoryId+''','','') SP ';
                     IF @IsAssociated = 0
                         BEGIN
                             SET @JoinWhereClause = ' AND NOT EXISTS (SELECT TOP 1 1 FROM @TBL_PimCategoryId TBPC WHERE TBPC.PimCategoryid = ZPCAV.PimCategoryId )';
                         END;
                     ELSE
                         BEGIN
                             SET @JoinWhereClause = ' AND EXISTS (SELECT TOP 1 1 FROM @TBL_PimCategoryId TBPC WHERE TBPC.PimCategoryid = ZPCAV.PimCategoryId )';
                         END;
                 END;
             IF @Order_BY LIKE '%CategoryId%'
                 BEGIN
                     SET @OrderClause = REPLACE(@Order_BY, 'PimCategoryId', 'CTCDL.PimCategoryId');
                 END;
             ELSE
             IF @Order_BY = '%Family%'
                 BEGIN
                     SET @OrderClause = REPLACE(@Order_BY, 'PimCategoryId', 'CTCDL.PimCategoryId');
                 END;
             ELSE
             IF @Order_BY = ''
                 BEGIN
                     SET @OrderClause = 'CTCDL.PimCategoryId DESC';
                 END;;
             SET @SQL = @SQL+'  
			 ;WITH Cte_AttributeFamilyLocale
                  AS (SELECT ZPAF.PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,ZPFL.AttributeFamilyName,ZPFL.LocaleId
                      FROM ZnodePimAttributeFamily ZPAF
                      INNER JOIN ZnodePimFamilyLocale ZPFL ON(ZPFL.PimAttributeFamilyId = ZPAF.PimAttributeFamilyId)
                      WHERE LocaleId IN('+CAST(@LocaleId AS VARCHAR(50))+', '+CAST(@DefaultLocaleId AS VARCHAR(50))+')
                       ),

                  Cte_AttributeFirstLocale
                  AS (SELECT PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,AttributeFamilyName
                      FROM Cte_AttributeFamilyLocale
                      WHERE LocaleId = '+CAST(@LocaleId AS VARCHAR(50))+'),

                  Cte_AttributeBothLocale
                  AS (
                  SELECT PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,AttributeFamilyName
                  FROM Cte_AttributeFirstLocale
                  UNION ALL
                  SELECT PimAttributeFamilyId,FamilyCode,IsSystemDefined,IsDefaultFamily,IsCategory,AttributeFamilyName
                  FROM Cte_AttributeFamilyLocale CTAFL
                  WHERE LocaleId = '+CAST(@DefaultLocaleId AS VARCHAR(50))+'
                        AND NOT EXISTS
                  (
                      SELECT TOP 1 1
                      FROM Cte_AttributeFirstLocale CTAFL
                      WHERE CTAFL.PimAttributeFamilyId = CTAFL.PimAttributeFamilyId
                  ))
                
			 		 
			,Cte_CategoryAttributeValue AS  
		(
		  SELECT PimCategoryId,ZPA.AttributeCode ,ZPCAVL.CategoryValue AttributeValue , ZPCAVL.LocaleId
		  FROM ZnodePimCategoryAttributeValueLocale ZPCAVL  
		  LEFT JOIN ZnodePimCategoryAttributeValue ZPCAV ON (ZPCAV.PimCategoryAttributeValueId = ZPCAVL.PimCategoryAttributeValueId)
		  LEFT JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPCAV.PimAttributeId )  
		  WHERE LocaleId  IN ('+@LocaleIds+' , '+@DefaultLocaleId+')
		  AND EXISTS (SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryGridAttributeDetails]() FNGCGDA WHERE FNGCGDA.PimAttributeId = ZPA.PimAttributeId )
		  '+@JoinWhereClause+'
		 )
		 , Cte_CategoryAttributeValueFirstLocale AS 
		 (
		   SELECT PimCategoryId,AttributeCode ,AttributeValue  
		   FROM Cte_CategoryAttributeValue  CTCAV 
		   WHERE LocaleId = '+@LocaleIds+'
		 )
		 , Cte_CategoryDefaultLocale AS 
		 (
		   SELECT PimCategoryId,AttributeCode ,AttributeValue 
		   FROM Cte_CategoryAttributeValueFirstLocale 
		   UNION ALL 
		   SELECT PimCategoryId,AttributeCode ,AttributeValue 
		   FROM Cte_CategoryAttributeValue CTCAV 
		   WHERE LocaleId = '+@DefaultLocaleId+'
		   AND NOT EXISTS (SELECT TOP 1 1 FROM Cte_CategoryAttributeValueFirstLocale CTCAVFL WHERE CTCAVFL.PimCategoryId = CTCAV.PimCategoryId AND CTCAVFL.AttributeCode = CTCAV.AttributeCode)
		   UNION ALL 
		   SELECT ZPCAV.PimCategoryId , ''attributefamily'' , AttributeFamilyName AttributeValue
		   FROM ZnodePimCategory ZPCAV 
		   LEFT JOIN Cte_AttributeBothLocale		TBLF ON (TBLF.PimAttributeFamilyId = ZPCAV.PimAttributeFamilyId AND TBLF.IScategory = 1 )  
		   WHERE 1=1 '+@JoinWhereClause+'
		 ) ';
             INSERT INTO @WhereClause(WhereClause)
                    SELECT WhereClause
                    FROM dbo.Fn_GetWhereClauseXML(@WhereClauseXML);

					If @IsDebug =1 
					Begin 
						Select * from @WhereClause
					End 
             SET @MaxValueId =
             (
                 SELECT MAX(Id)
                 FROM @WhereClause
             );
             WHILE @ValueId <= @MaxValueId
                 BEGIN
                     SET @SQL = @SQL+' , Cte_CategoryDetails_'+CAST(@ValueId AS VARCHAR(10))+' AS  
		   ( 
						SELECT CTCDL.PimCategoryId 
					    FROM '+CASE
                                        WHEN @ValueId = 1
                                        THEN 'Cte_CategoryDefaultLocale CTCDL'
                                        ELSE 'Cte_CategoryDetails_'+CAST(@ValueId - 1 AS VARCHAR(10))+' CTCDN '
                                    END+' 
						'+CASE
                                    WHEN @ValueId = 1
                                    THEN ''
                                    ELSE ' INNER JOIN  Cte_CategoryDefaultLocale CTCDL ON (CTCDL.PimCategoryId = CTCDN.PimCategoryId ) '
                                END+'
						WHERE '+
                     (
                         SELECT TOP 1 WhereClause
                         FROM @WhereClause
                         WHERE id = @ValueId
                     )+'		             
		   )
		   ';
                     SET @ValueId = @ValueId + 1;
                 END;
             SET @JoinWhereClause = CASE
                                        WHEN @OrderClause IS NULL
                                        THEN 'AND CTCDLD.AttributeCode = '''+dbo.Fn_Trim(REPLACE(REPLACE(@Order_BY, 'DESC', ''), 'ASC', ''))+''''
                                        ELSE ''
                                    END;
             SET @OrderClause = ISNULL(@OrderClause, 'CTCDLD.AttributeValue'+CASE
                                                                                 WHEN @Order_BY LIKE '% DESC%'
                                                                                 THEN ' DESC'
                                                                                 ELSE ' ASC '
                                                                             END);
             SET @SQL = @SQL+' ,Cte_finalCategoryDetails AS 
		(
			SELECT CTCDL.PimCategoryId ,'+[dbo].[Fn_GetPagingRowId](@OrderClause, 'CTCDL.PimCategoryId')+',Count(*)Over() CountId  
			FROM '+CASE
                          WHEN NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM @WhereClause
             )
                          THEN 'Cte_CategoryDefaultLocale CTCDL'
                          ELSE 'Cte_CategoryDetails_'+CAST((@ValueId - 1) AS VARCHAR(10))+' CTCDL '
                      END+'
			'+CASE
                     WHEN NOT EXISTS
             (
                 SELECT TOP 1 1
                 FROM @WhereClause
             )
                          AND @Order_BY = ''
                     THEN ''
                     ELSE ' LEFT JOIN  Cte_CategoryDefaultLocale CTCDLD ON (CTCDL.PimCategoryId = CTCDLD.PimCategoryId '+@JoinWhereClause+') '
                 END+'  
			GROUP BY CTCDL.PimCategoryId'+','+REPLACE(REPLACE(ISNULL(@OrderClause, 'CTCDLD.AttributeValue'), 'DESC', ''), 'ASC', '')+'				   
		) 
		
		SELECT PimCategoryId , CountId ,RowId
		FROM Cte_finalCategoryDetails		'+[dbo].[Fn_GetPaginationWhereClause](@PageNo, @Rows);
         
		 
		     PRINT @SQL
			 EXEC (@SQL);

          
		 END TRY
         BEGIN CATCH
    --         DECLARE @Status BIT ;
		  --   SET @Status = 0;
		  --   DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCategoryIdForPaging @WhereClause = '+CAST(@WhereClause AS NVARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@UserId = '+CAST(@UserId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
    --         SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
    --         EXEC Znode_InsertProcedureErrorLog
				--@ProcedureName = 'Znode_GetCategoryIdForPaging',
				--@ErrorInProcedure = @Error_procedure,
				--@ErrorMessage = @ErrorMessage,
				--@ErrorLine = @ErrorLine,
				--@ErrorCall = @ErrorCall;
				select Error_message();
         END CATCH;
     END;

	go
	update ZnodeApplicationSetting 
set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>OmsOrderId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>OrderNumber</name>      <headertext>Order No</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Order/Manage</islinkactionurl>      <islinkparamfield>OmsOrderId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>UserName</name>      <headertext>Customer Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Email</name>      <headertext>Email</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PhoneNumber</name>      <headertext>Phone Number</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>OrderState</name>      <headertext>Order Status</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>orderState</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>PaymentStatus</name>      <headertext>Payment Status</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>paymentStatus</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>PaymentDisplayName</name>      <headertext>Payment Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>paymentType</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>OrderTotalWithCurrency</name>      <headertext>Total</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>Total</name>      <headertext>Total</headertext>      <width>30</width>      <datatype>Decimal</datatype>      <columntype>Decimal</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>SubTotalAmount</name>      <headertext>SubTotal</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>13</id>      <name>Tax</name>      <headertext>Tax</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>14</id>      <name>Shipping</name>      <headertext>Shipping</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>15</id>      <name>BillingPostalCode</name>      <headertext>Billing Zip Code</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>16</id>      <name>ShippingPostalCode</name>      <headertext>Shipping Zip Code</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>17</id>      <name>OrderDateWithTime</name>      <headertext>Order Date</headertext>      <width>0</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>18</id>      <name>CreatedByName</name>      <headertext>Created By</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>19</id>      <name>PublishState</name>      <headertext>Application Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>20</id>      <name>ModifiedByName</name>      <headertext>Modified By</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>21</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>View|void-payment</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Order/Manage</manageactionurl>      <manageparamfield>OmsOrderId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName= 'ZnodeOrder'
go
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="UTF-8"?> <columns>  <column>   <id>1</id>   <name>OmsQuoteId</name>   <headertext>Checkbox</headertext>   <width>0</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>y</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>2</id>   <name>OmsQuoteId</name>   <headertext>Pending Order ID</headertext>   <width>0</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>y</isallowlink>   <islinkactionurl>/Account/UpdateAccountQuote</islinkactionurl>   <islinkparamfield>omsQuoteId</islinkparamfield>   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>3</id>   <name>UserName</name>   <headertext>Customer Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>4</id>   <name>AccountName</name>   <headertext>Account Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>5</id>   <name>StoreName</name>   <headertext>Store Name</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>6</id>   <name>OrderStatus</name>   <headertext>Pending Order Status</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>7</id>   <name>QuoteOrderTotal</name>   <headertext>Pending Order Amount</headertext>   <width>0</width>   <datatype>Decimal</datatype>   <columntype>Decimal</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>8</id>   <name>CreatedDate</name>   <headertext>Created Date</headertext>   <width>0</width>   <datatype>Date</datatype>   <columntype>DateTime</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>9</id>   <name>CreatedByName</name>   <headertext>Created By</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>10</id>   <name>ModifiedByName</name>   <headertext>Modified By</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>n</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>18</id>   <name>PublishState</name>   <headertext>Publish Status</headertext>   <width>30</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>true</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>y</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>11</id>   <name>Manage</name>   <headertext>Action</headertext>   <width>0</width>   <datatype>String</datatype>   <columntype>String</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format>View|orders</format>   <isvisible>y</isvisible>   <mustshow>n</mustshow>   <musthide>n</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext>View|Convert to Order</displaytext>   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl>/Account/UpdateAccountQuote|/Quote/ConvertToOrder</manageactionurl>   <manageparamfield>omsQuoteId,orderStatus|omsQuoteId</manageparamfield>   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>12</id>   <name>AccountId</name>   <headertext>Account Id</headertext>   <width>0</width>   <datatype>Int32</datatype>   <columntype>Int32</columntype>   <allowsorting>false</allowsorting>   <allowpaging>true</allowpaging>   <format />   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>y</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext />   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class />   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column>  <column>   <id>13</id>   <name>IsConvertedToOrder</name>   <headertext />   <width>0</width>   <datatype>Boolean</datatype>   <columntype>Boolean</columntype>   <allowsorting>false</allowsorting>   <allowpaging>false</allowpaging>   <format />   <isvisible>n</isvisible>   <mustshow>n</mustshow>   <musthide>y</musthide>   <maxlength>0</maxlength>   <isallowsearch>n</isallowsearch>   <isconditional>n</isconditional>   <isallowlink>n</isallowlink>   <islinkactionurl />   <islinkparamfield />   <ischeckbox>n</ischeckbox>   <checkboxparamfield />   <iscontrol>n</iscontrol>   <controltype />   <controlparamfield />   <displaytext>Is Converted To Order</displaytext>   <editactionurl />   <editparamfield />   <deleteactionurl />   <deleteparamfield />   <viewactionurl />   <viewparamfield />   <imageactionurl />   <imageparamfield />   <manageactionurl />   <manageparamfield />   <copyactionurl />   <copyparamfield />   <xaxis>n</xaxis>   <yaxis>n</yaxis>   <isadvancesearch>y</isadvancesearch>   <Class>IsConvertedToOrder</Class>   <SearchControlType>--Select--</SearchControlType>   <SearchControlParameters />   <DbParamField />   <useMode>DataBase</useMode>   <IsGraph>n</IsGraph>   <allowdetailview>n</allowdetailview>  </column> </columns>'
WHERE ItemName ='ZnodeOmsQuote'
go
if exists(select * from sys.procedures where name = 'Znode_AssociatePortalBrand')
	drop proc Znode_AssociatePortalBrand
go
CREATE PROCEDURE [dbo].[Znode_AssociatePortalBrand]   
(  
	 @PortalId INT = 0,  
	 @BrandId  VARCHAR(MAX) = '',  
	 @IsAssociated BIT, -----0 = UnAssociate, 1 = Associate  
	 @UserId INT,  
	 @Status BIT OUT  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
  
 BEGIN TRY  
 BEGIN TRAN
	 DECLARE @GetDate DATETIME= dbo.Fn_GetDate();  
	 DECLARE @DisplayOrder INT = 999; 
  
	 IF ( @IsAssociated = 1 )  
	 BEGIN  
		  INSERT INTO ZnodePortalBrand ( PortalId, BrandId, DisplayOrder, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )   
		  SELECT @PortalId, P.Item ,@DisplayOrder, @UserId, @GetDate, @UserId, @GetDate  
		  FROM dbo.Split ( @BrandId , ',' ) P  
		  WHERE P.Item NOT IN ( SELECT PortalBrandId FROM ZnodePortalBrand BP WHERE  BP.BrandId=P.Item AND BP.PortalId = @PortalId ) 
		   and P.Item <> '' 
	 END  
	 ELSE IF ( @IsAssociated = 0 )  
	 BEGIN    
		DELETE FROM ZnodePortalBrand  
		WHERE EXISTS( SELECT * FROM dbo.Split ( @BrandId , ',' ) P WHERE ZnodePortalBrand.BrandId = P.Item AND ZnodePortalBrand.PortalId = @PortalId )   
		DELETE FROM ZnodeCMSWidgetBrand 
		WHERE EXISTS( SELECT * FROM dbo.Split ( @BrandId , ',' ) P WHERE ZnodeCMSWidgetBrand.BrandId = P.Item AND ZnodeCMSWidgetBrand.CMSMappingId = @PortalId AND ZnodeCMSWidgetBrand. TypeOFMapping = 'PortalMapping') 
	 END  
  
	 SELECT 1 AS ID, CAST(1 AS bit) AS Status;  
 COMMIT TRAN
END TRY  
BEGIN CATCH    
	   ROLLBACK TRAN
       SET @Status = 0;  
       DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AssociatePortalBrand @PortalId = '+CAST(@PortalId AS VARCHAR(max))+',@BrandId='+CAST(@BrandId AS VARCHAR(50))+',@IsUnAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@UserId='+CAST( @UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
		  SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
		  EXEC Znode_InsertProcedureErrorLog  
		  @ProcedureName = 'Znode_AssociatePortalBrand',  
		  @ErrorInProcedure = @Error_procedure,  
		  @ErrorMessage = @ErrorMessage,  
		  @ErrorLine = @ErrorLine,  
		  @ErrorCall = @ErrorCall;  
END CATCH  
  
END 
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'LogMessage','ImpersonationLogList',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'LogMessage' and ActionName = 'ImpersonationLogList')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList'))

GO



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'LogMessage','ImpersonationLogList',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'LogMessage' and ActionName = 'ImpersonationLogList')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Application Logs' AND ControllerName = 'LogMessage')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Application Logs' AND ControllerName = 'LogMessage')	 and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Application Logs' AND ControllerName = 'LogMessage')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Application Logs' AND ControllerName = 'LogMessage')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'LogMessage' and ActionName= 'ImpersonationLogList'))

GO
if not exists(select * from sys.indexes where name = 'IDX_ZnodeAddress_IsDefaultShipping')
begin
CREATE NONCLUSTERED INDEX [IDX_ZnodeAddress_IsDefaultShipping]
    ON [dbo].[ZnodeAddress]([IsDefaultShipping] ASC)
    INCLUDE([PostalCode]);
end
GO
if not exists(select * from sys.indexes where name = 'IDX_ZnodeAddress_IsDefaultBilling')
begin
CREATE NONCLUSTERED INDEX [IDX_ZnodeAddress_IsDefaultBilling]
    ON [dbo].[ZnodeAddress]([IsDefaultBilling] ASC)
    INCLUDE([PostalCode]);
end
go
if not exists(select * from sys.indexes where name = 'IDX_ZnodeAccountAddress_AccountId')
begin
CREATE NONCLUSTERED INDEX [IDX_ZnodeAccountAddress_AccountId]
    ON [dbo].[ZnodeAccountAddress]([AccountId] ASC)
    INCLUDE([AddressId]);
end
go
if exists(select * from sys.procedures where name = 'Znode_GetAccountListWithAddress')
	drop proc Znode_GetAccountListWithAddress
go
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

			SELECT  a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, b.Name AS ParentAccountName ,ZPA.PortalId,ZP.StoreName, PC.CatalogName,
			(select top 1 PostalCode from ZnodeAddress where AddressId in  (select AddressId from ZnodeAccountAddress where AccountId = a.AccountId AND IsDefaultShipping = 1)) AS ShippingPostalCode,
			(select top 1 PostalCode from ZnodeAddress where AddressId in  (select AddressId from ZnodeAccountAddress where AccountId = a.AccountId AND IsDefaultBilling = 1)) AS BillingPostalCode
			into #AccountListAis
			FROM dbo.ZnodeAccount AS a 
			LEFT OUTER JOIN dbo.ZnodeAccount AS b ON a.ParentAccountId = b.AccountId
			LEFT JOIN ZnodePortalAccount ZPA  ON (ZPA.AccountId = a.AccountId)
			LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZPA.PortalId)
			LEFT JOIN ZnodePortalCatalog ZPC ON ( ZPA.PortalId = ZPC.PortalId )
			LEFT JOIN ZnodePublishcatalog PC ON ( PC.PublishcatalogId = COALESCE(a.PublishCatalogId, ZPC.PublishcatalogId ) )

             DECLARE @SQL NVARCHAR(MAX), @Rows_start VARCHAR(1000), @Rows_end VARCHAR(1000);
             SET @Rows_start = CASE WHEN @Rows >= 1000000 THEN 0 ELSE(@Rows * (@PageNo - 1)) + 1 END;
             SET @Rows_end = CASE WHEN @Rows >= 1000000THEN @Rows ELSE @Rows * (@PageNo) END;
             SET @SQL = '
			 CREATE TABLE #TBL_AddressDetails (AccountId INT ,Address NVARCHAR(max),IsDefaultBilling BIT ,IsDefaultShipping BIT,RowId INT  )
			 CREATE TABLE #TBL_AddressDetailsFinal (AccountId INT ,Address NVARCHAR(max))
			 
			 SELECT *,RANK()OVER(ORDER BY '+CASE
                                                    WHEN @Order_BY = ''
                                                    THEN ' AccountId ,'
                                                    ELSE @Order_BY+' , '
                                                END+' AccountId ) RowId 
			 into #TBL_AccountsDetails
			 FROM #AccountListAis
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
			    
			 SELECT @COUNT= COUNT(1) FROM #TBL_AccountsDetails

			 INSERT INTO #TBL_AddressDetails (AccountId,Address,IsDefaultBilling,IsDefaultShipping,RowId)
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
			 WHERE EXISTS ( SELECT TOP 1 1 FROM  #TBL_AccountsDetails a  WHERE a.AccountId = c.AccountId AND a.RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+')  
			    
			 ;With AccountAddressShipping AS 
			 (
			 SELECT * FROM #TBL_AddressDetails mn WHERE IsDefaultShipping = 1 
			 )
			 ,  AccountAddressBilling AS 
			 (
				 SELECT * 
				 FROM AccountAddressShipping 
				 UNION ALL 
				 SELECT * 
				 FROM #TBL_AddressDetails mn 
				 WHERE IsDefaultBilling = 1 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM AccountAddressShipping sw WHERE sw.AccountId = mn.AccountId )
			 )


			 INSERT INTO #TBL_AddressDetailsFinal 

			 SELECT AccountId ,Address 
			 FROM AccountAddressBilling 

			    
			 INSERT INTO #TBL_AddressDetailsFinal 
			 SELECT AccountId , Address 
			 FROM #TBL_AddressDetails  q
			 WHERE NOT EXISTS (SELECT  TOP 1 1 FROM #TBL_AddressDetailsFinal  fg WHERE fg.AccountId = q.AccountId )
			 AND RowId = 1 



			 SELECT a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, a.ParentAccountName ,b.[Address] AccountAddress,a.PortalId,a.StoreName, a.CatalogName,ShippingPostalCode,BillingPostalCode
			 FROM #TBL_AccountsDetails a 
			 INNER JOIN #TBL_AddressDetailsFinal  b ON (a.AccountId = b.AccountId )
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
	go
	update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PublishProductId</name>      <headertext>PublishProductId</headertext>      <width>5</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PublishProductId,Quantity,SKU</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>HiddenField</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Single</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImageSmallThumbnailPath,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>JavaScript:void(0);</islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>sku</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Name</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>productname</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>SalesPriceWithCurrency</name>      <headertext>Sales Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>RetailPriceWithCurrency</name>      <headertext>Retail Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/SEO/SEODetails</manageactionurl>      <manageparamfield>ItemName,ItemId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeOrderProductList'
go
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PublishProductId</name>      <headertext>PublishProductId</headertext>      <width>5</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PublishProductId,Quantity,SKU</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>HiddenField</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Single</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImageSmallThumbnailPath,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>JavaScript:void(0);</islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>sku</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Name</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>productname</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>SalesPriceWithCurrency</name>      <headertext>Sales Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>RetailPriceWithCurrency</name>      <headertext>Retail Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/SEO/SEODetails</manageactionurl>      <manageparamfield>ItemName,ItemId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeOrderProductList'
go
if exists(select * from sys.procedures where name = 'Znode_AdminUsers')
	drop proc Znode_AdminUsers
go

CREATE PROCEDURE [dbo].[Znode_AdminUsers]
(	@RoleName		VARCHAR(200),
    @UserName		VARCHAR(200),
    @WhereClause	XML,
    @Rows			INT           = 100,
    @PageNo			INT           = 1,
    @Order_By		VARCHAR(1000) = '',
    @RowCount		INT        = 0 OUT,
	@IsCallOnSite   BIT = 0 ,
	@PortalId		VARCHAR(1000) = 0,
	@IsGuestUser    BIT = 0,
	@ColumnName     dbo.SelectColumnList ReadOnly
)
AS
   /* 
      Summary: List of users with detsils and shows link with ASPNet tables 
      This procedure is used for finding both users and admin users 
      here use three view "View_RoleUsers" for check  @UserName is present or not 
      "View_AdminUserDetail"  this view use for admin users 
      "View_CustomerUserDetail" Use for customer users 
      Unit Testing   
	  SELECT * FROM ZnodeUser 
      DECLARE @EDE INT=0  EXEC Znode_AdminUsers '','admin@znode.com',@WhereClause='',@Order_By='',@PageNo= 1 ,@Rows= 214,@IsCallOnSite='false',@PortalId=0,@RowCount=@EDE OUT  SELECT @EDE
   */
     BEGIN
         BEGIN TRY
            SET NOCOUNT ON;
			
            DECLARE @SQL NVARCHAR(MAX)= '', @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');
             
			-----Split where clause XMl 
			CREATE TABLE #WhereColumnList(RowId Int identity, filterName varchar(max), WhereCondition varchar(max))

			insert into #WhereColumnList(filterName,WhereCondition)
			SELECT 
					Tbl.Col.value('key[1]', 'varchar(max)') as filterName,
					Tbl.Col.value('condition[1]', 'varchar(max)') WhereCondition
			FROM   @WhereClause.nodes('//filter') Tbl(Col) 

			----Address column in global search
			declare @AddressGlobalSearch varchar(1000)
			declare @GlobalSearch varchar(100)
			select @GlobalSearch = substring(WhereCondition,charindex(' like ',WhereCondition), charindex(' OR ',WhereCondition)-charindex(' like ',WhereCondition)) 
			from #WhereColumnList
			where filtername like '%|%'
			and filtername <> ''
			and filterName in ('CityName','CountryName','PostalCode','StateName','CompanyName') 

			if isnull(@GlobalSearch,'') <> ''
			begin
				select @AddressGlobalSearch = '('+'CityName '+ @GlobalSearch+' OR '+'CountryName '+ @GlobalSearch+' OR '+'PostalCode '+ @GlobalSearch+' OR '+'StateName '+ @GlobalSearch+' OR '+'CompanyName '+ @GlobalSearch+')'
			end
			else
			begin
				SET @AddressGlobalSearch = ''
			end
			----Global search where clause
			declare @WhereClauseGlobal varchar(1000)=''
			select @WhereClauseGlobal = ISNULL(WhereCondition,'')
			from #WhereColumnList
			where filtername like '%|%'
			and filtername <> ''
			
			----Where clause columns except Address columns
			declare @WhereClause1 varchar(max) 
			select @WhereClause1 = COALESCE(@WhereClause1 + '', '') + WhereCondition+' And '
			--case when @WhereClause1 <> ''  then ' And ' else '' end
			from #WhereColumnList a
			where filterName not like '%|%' and
			filterName not in ('CountryName','CityName','StateName','PostalCode','CompanyName')
			and filtername <> ''

			if @WhereClause1 <> ''
			begin
				set @WhereClause1=isnull(substring(@WhereClause1,1,len(@WhereClause1)-3),'')
			end
			else
			begin
				set @WhereClause1 = ''
			end

			----Where clause columns
			declare @AddressColumnWhereClause varchar(max) 
			select @AddressColumnWhereClause = COALESCE(@AddressColumnWhereClause + '', '') + WhereCondition+' And '
			from #WhereColumnList a
			where filterName not like '%|%' and
			filterName in ('CountryName','CityName','StateName','PostalCode','CompanyName')
			and filtername <> ''
			
			if isnull(@AddressColumnWhereClause,'') <> ''
			begin
				set @AddressColumnWhereClause=isnull(substring(@AddressColumnWhereClause,1,len(@AddressColumnWhereClause)-3),'')
            end
			else
			begin
				set @AddressColumnWhereClause = ''
			end

			declare @WhereClauseAll varchar(max)
			select @WhereClauseAll = COALESCE(@WhereClauseAll + '', '') + WhereCondition+' And '
			from #WhereColumnList a

			set @WhereClauseAll=isnull(substring(@WhereClauseAll,1,len(@WhereClauseAll)-3),'')
			-------------- 

			IF @PortalId  <> '0' 
			BEGIN 
			    SET @WhereClauseAll = CASE WHEN  @WhereClauseAll = '' THEN ' (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' ELSE @WhereClauseAll+' AND (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' END 

				SET @WhereClause1 = CASE WHEN  @WhereClause1 = '' THEN ' (isnull(PortalId,0) IN ('+@PortalId+') OR PortalId IS NULL) ' ELSE @WhereClause1+' AND (isnull(PortalId,0) IN ('+@PortalId+') OR PortalId IS NULL) ' END 
			
			END 
			IF EXISTS
            (
            SELECT TOP 1 1
            FROM View_RoleUsers
            WHERE Username = @UserName
            )

			-- this check for admin user
            AND @RoleName <> ''  

			BEGIN
				SET @SQL = ' 
				--;with Cte_AdminUserDetail AS 
				--(
					 
				SELECT  A.UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,A.CreatedBy,A.CreatedDate,A.ModifiedBy,A.ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				INTO #Cte_AdminUserDetail
				FROM View_AdminUserDetail A
				'+CASE WHEN @PortalId  <> '0' THEN ' INNER JOIN ZnodeUserPortal ZUP ON (ZUP.UserId = A.UserId) 'ELSE '' END  +'	 
				'+dbo.Fn_GetWhereClause(@WhereClauseAll, ' WHERE ')+'
				--),
				;with Cte_AdminUserDetailRowId AS 
				(
				SELECT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId
				FROM  #Cte_AdminUserDetail
				)
					 
				SELECT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId,CustomerPaymentGUID ,RowId 
				INTO #AccountDetails
				FROM Cte_AdminUserDetailRowId 
					 
				SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetails ),0)
					 
				SELECT DISTINCT UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				FROM #AccountDetails '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC' );
			    PRINT @SQL
				EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;
			END;
			-- For Customer user
            ELSE   
      BEGIN
				IF @roleName = ''
				BEGIN
			
				if OBJECT_ID('tempdb..##CustomerUserAddDetail') is not null
					drop table ##CustomerUserAddDetail

				if OBJECT_ID('tempdb..##View_CustomerUserAddDetail') is not null
					drop table ##View_CustomerUserAddDetail
				
				if OBJECT_ID('tempdb..##UserList') is not null
					drop table ##UserList

				CREATE TABLE ##UserList(UserId int,AddressID int)

				declare @UserList varchar(1000)=''

				------To get the list of user having adress column in global search
				if (@AddressGlobalSearch <> '')
				begin
				
					set @UserList = 
					'select a.UserId, b.AddressID
					from ZnodeUserAddress a
					inner join ZnodeAddress b on a.AddressId = b.AddressId
					where '+@AddressGlobalSearch
					--print @UserList
					insert into ##UserList(UserId, b.AddressID)
					exec (@UserList)
			
				end
				----To get the list of user having adress column in where clause 
				if (@AddressColumnWhereClause <> '')
				begin
					
					set @UserList = 
					'select a.UserId, b.AddressID
					from ZnodeUserAddress a
					inner join ZnodeAddress b on a.AddressId = b.AddressId
					where '+@AddressColumnWhereClause
					--print @UserList
					insert into ##UserList(UserId,AddressID)
					exec (@UserList)
					
				end

				SELECT a.userId,a.AspNetuserId,azu.UserName,a.FirstName,a.MiddleName,a.LastName,a.PhoneNumber,
					a.Email,a.EmailOptIn,a.CreatedBy,CONVERT( DATE, a.CreatedDate) CreatedDate,A.ModifiedBy,
					CONVERT( DATE, a.ModifiedDate) ModifiedDate,ur.RoleId,r.Name RoleName,
					CASE
						WHEN B.LockoutEndDateUtc IS NULL
						THEN CAST(1 AS    BIT)
						ELSE CAST(0 AS BIT)
					END IsActive,
					CAST(CASE WHEN ISNULL(LockoutEndDateUtc, 0) = 0 THEN  0 ELSE  1 END  AS    BIT) AS IsLock,
					(ISNULL(RTRIM(LTRIM(a.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(a.MiddleName)), '')+CASE
																										  WHEN ISNULL(RTRIM(LTRIM(a.MiddleName)), '') = ''
																										  THEN ''
																										  ELSE ' '
																									  END+ISNULL(RTRIM(LTRIM(a.LastName)), '')) FullName,
					e.Name AccountName,a.AccountId,a.ExternalId,
					CASE
						WHEN a.AccountId IS NULL
						THEN 0
						ELSE 1
					END IsAccountCustomer,
					a.BudgetAmount,r.TypeOfRole,CASE WHEN a.AspNetuserId IS NULL THEN 1 ELSE 0 END IsGuestUser,a.CustomerPaymentGUID
		  ,CASE WHEN zp.StoreName IS NULL THEN 'ALL' ELSE zp.StoreName END StoreName,
		  CASE WHEN a.AccountId IS NULL THEN up.PortalId ELSE ZPA.PortalId END as PortalId
		  into ##View_CustomerUserAddDetail
		  FROM ZnodeUser a
          left JOIN ASPNetUsers B ON(a.AspNetuserId = b.Id)
          LEFT JOIN ZnodeAccount e ON(e.AccountId = a.AccountId)
          LEFT JOIN AspNetUserRoles ur ON(ur.UserId = a.AspNetUserId)
          LEFT JOIN AspNetRoles r ON(r.Id = ur.RoleId)                       
          LEFT JOIN AspNetZnodeUser azu ON(azu.AspNetZnodeUserId = b.UserName)
		  LEFT JOIN ZnodeUserPortal up ON(up.UserId = a.UserId)  
		  LEFT JOIN ZnodePortal zp ON (up.PortalId = zp.PortalId)
		  LEFT JOIN ZnodePortalAccount ZPA ON(ZPA.AccountId = a.AccountId) 
	  WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeUSer ZUQ WHERE ZUQ.UserId = a.UserId AND ZUQ.EmailOptIn = 1 AND ZUQ.AspNetUserId IS NULL )
	
	 alter table ##View_CustomerUserAddDetail 
	 add DepartmentId int, PermissionsName varchar(200), PermissionCode varchar(200), DepartmentName varchar(300), AccountPermissionAccessId int,
	 AccountUserOrderApprovalId int, ApprovalName varchar(1000) , ApprovalUserId int
	 --, PortalId int , StoreName varchar(1000)
	 ,CountryName varchar(1000),CityName varchar(1000),StateName varchar(1000),PostalCode varchar(1000), CompanyName varchar(1000),
	 SalesRepUserName varchar(600),SalesRepFullName varchar(1000)

	------To get data for StoreName
	--IF (EXISTS(SELECT * FROM @ColumnName where [StringColumn] = 'StoreName')
	--    OR @WhereClauseAll like '%StoreName%')
	--BEGIN
	--	select 1
	--	create index Ind_##View_CustomerUserAddDetail_UserId on ##View_CustomerUserAddDetail(UserId)
	--	 update  a set StoreName = CASE WHEN zp.StoreName IS NULL THEN 'ALL' ELSE zp.StoreName END 
	--	 from ##View_CustomerUserAddDetail a
	--	 LEFT JOIN ZnodeUserPortal up ON(up.UserId = a.UserId)  
	--	 LEFT JOIN ZnodePortal zp ON (up.PortalId = zp.PortalId)

	--END
	
	IF ((@AddressGlobalSearch like '%CountryName%' OR @AddressGlobalSearch like '%CityName%' OR @AddressGlobalSearch like '%StateName%' OR @AddressGlobalSearch like '%PostalCode%' OR @AddressGlobalSearch like '%CompanyName%')
	    and exists(select * from ##UserList))
		BEGIN
			 
			 update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, 
			               PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName
			 from ##View_CustomerUserAddDetail a
			 inner join ZnodeUserAddress ZUA on a.UserId = ZUA.UserId
			 inner  JOIN ZnodeAddress ZA on ZA.AddressId = zua.AddressId
			 where exists(select * from ##UserList UL where a.UserId = UL.UserId and UL.AddressId = ZA.AddressId )

			 update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, 
			               PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName
			 from ##View_CustomerUserAddDetail a
			 inner join ZnodeAccountAddress ZAA on a.AccountId = ZAA.AccountId
			 inner  JOIN ZnodeAddress ZA on ZA.AddressId = ZAA.AddressId
			 where isnull(a.AccountId,0)<> 0-- is not null
			 and exists(select * from ##UserList UL where a.UserId = UL.UserId and UL.AddressID = ZA.AddressId)
	  		 and (a.CountryName is null OR a.CityName is null OR a.StateName is null or a.PostalCode is null or a.CompanyName is null)
		
		END

	 SET @SQL = '			
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #Cte_CustomerUserDetail
				FROM ##View_CustomerUserAddDetail a 				
				WHERE 
				(EXISTS   -- this will check for customer 
				(
				SELECT TOP 1 1
				FROM AspNetUserRoles AS b
				WHERE a.AspNetUserId = b.userid
				AND EXISTS
				(SELECT TOP 1 1	FROM AspNetRoles AS d	WHERE(d.TypeOfRole is NULL OR d.TypeOfRole = ''B2B'')	AND d.Id = b.RoleId	)   
				) OR AspNetuserId IS NULL OR '+CAST(CAST(@IsCallOnSite AS INT ) AS VARCHAR(50))+'= ''1'' )
				'+ case when @IsGuestUser = 1 THEN 'AND a.AspNetuserId IS NULL' ELSE 'AND a.AspNetuserId IS NOT NULL
				' END +dbo.Fn_GetWhereClause(@WhereClauseGlobal+case when @WhereClauseGlobal<>'' and @WhereClause1 <> '' then ' And '+@WhereClause1 else @WhereClause1 end, ' AND ')+' 
				
				create table #AccountDetail
				(
					UserId int,AspNetuserId nvarchar(500),UserName nvarchar(500),FirstName nvarchar(1000),MiddleName nvarchar(1000),LastName nvarchar(1000),
					PhoneNumber nvarchar(100),Email nvarchar(100),EmailOptIn bit,CreatedBy int,CreatedDate datetime,ModifiedBy int,ModifiedDate datetime,
					RoleId varchar(200),RoleName varchar(200),IsActive bit,IsLock bit,FullName  varchar(1000),AccountName  varchar(200),PermissionsName  varchar(200),
					DepartmentName  varchar(200),DepartmentId int,AccountId int,AccountPermissionAccessId int, ExternalId  varchar(200),BudgetAmount numeric(10,6),
					AccountUserOrderApprovalId int,ApprovalName varchar(1000),ApprovalUserId int,PermissionCode varchar(1000),CustomerPaymentGUID varchar(1000),
					StoreName varchar(600),PortalId int,CountryName varchar(600), CityName varchar(600), StateName varchar(600), PostalCode varchar(600), CompanyName varchar(600)
					,SalesRepUserName varchar(600),SalesRepFullName varchar(1000) ,RowId int identity
				) '+

				+' insert into #AccountDetail(UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID
				,StoreName,PortalId, CountryName, CityName, StateName, PostalCode, CompanyName)
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID 
				,StoreName,PortalId, CountryName, CityName, StateName, PostalCode, CompanyName
				FROM #Cte_CustomerUserDetail '+
				dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+
				
				+' if ('+cast(len(@AddressColumnWhereClause) as varchar(10))+' <> 0 ) '+
				+' begin
					SET @Count= ISNULL((SELECT  Count(Distinct a.UserId) FROM #AccountDetail a inner join ##UserList b on a.UserId = b.UserId ),0)
				end '+
				+' else '+
				+' begin
					SET @Count= ISNULL((SELECT  Count(*) FROM #AccountDetail),0)
				end '+

				+' SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName, SalesRepUserName, SalesRepFullName
				,Row_Number()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowNumber
				into ##CustomerUserAddDetail
				FROM #AccountDetail '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC');
                PRINT @SQL    					
				EXEC SP_executesql @SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;

		ALTER TABLE ##CustomerUserAddDetail ADD AddressId Int

		--To get data for DepartmentId
		update CUD SET DepartmentId = i.DepartmentId
		from ##CustomerUserAddDetail cud
		INNER JOIN ZnodeDepartmentUser i ON(i.UserId = cud.UserId)

		--To get data for PermissionsName
		update CUD SET PermissionsName = h.PermissionsName, PermissionCode = h.PermissionCode
		from ##CustomerUserAddDetail cud
        INNER JOIN ZnodeAccountUserPermission f ON(f.UserId = cud.UserId)
        INNER JOIN ZnodeAccountPermissionAccess g ON(g.AccountPermissionAccessId = f.AccountPermissionAccessId)
        INNER JOIN ZnodeAccessPermission h ON(h.AccessPermissionId = g.AccessPermissionId)

		------To get data for DepartmentName
		update CUD SET DepartmentName = j.DepartmentName
		from ##CustomerUserAddDetail cud
        INNER JOIN ZnodeDepartmentUser i ON(i.UserId = cud.UserId)
        INNER JOIN ZnodeDepartment j ON(j.DepartmentId = i.DepartmentId)

		--To get data for AccountPermissionAccessId
		update CUD SET AccountPermissionAccessId = f.AccountPermissionAccessId
		from ##CustomerUserAddDetail cud
        INNER JOIN ZnodeAccountUserPermission f ON(f.UserId = cud.UserId)

		--To get data for AccountPermissionAccessId
		update CUD SET AccountPermissionAccessId = f.AccountPermissionAccessId
		from ##CustomerUserAddDetail cud
        INNER JOIN ZnodeAccountUserPermission f ON(f.UserId = cud.UserId)
	
		--To get data for AccountUserOrderApprovalId
		update CUD SET AccountUserOrderApprovalId = ZAUOA.AccountUserOrderApprovalId
		from ##CustomerUserAddDetail cud
	    INNER JOIN ZnodeAccountUserOrderApproval ZAUOA ON cud.UserId = ZAUOA.UserID
	
		--To get data for ApprovalName,ApprovalUserId
		update CUD SET ApprovalName = ISNULL(RTRIM(LTRIM(ZU.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '')
		                               +CASE
											WHEN ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '') = ''
											THEN ''
											ELSE ' '
										END,
					   ApprovalUserId = ZAUOA.ApprovalUserId
		from ##CustomerUserAddDetail cud
	    INNER JOIN ZnodeAccountUserOrderApproval ZAUOA ON cud.UserId = ZAUOA.UserID
		INNER JOIN ZnodeUser ZU ON(ZU.UserId = ZAUOA.ApprovalUserId)
	
		----To get data for PortalId
		--update CUD SET PortalId = CASE
		--								WHEN cud.AccountId IS NULL
		--								THEN up.PortalId
		--								ELSE ZPA.PortalId
		--							END 
		--from ##CustomerUserAddDetail cud
	 --   LEFT JOIN ZnodeUserPortal up ON(up.UserId = cud.UserId) 
		--LEFT JOIN ZnodePortalAccount ZPA ON(ZPA.AccountId = cud.AccountId) 
	
		----To get data for CountryName, CityName, StateName, PostalCode, CompanyName
		IF (EXISTS(SELECT * FROM @ColumnName where ([StringColumn] LIKE '%CountryName%' OR [StringColumn] LIKE '%CityName%' OR [StringColumn] LIKE '%StateName%' OR [StringColumn] LIKE '%PostalCode%' OR [StringColumn] LIKE '%CompanyName%'))
			OR (@WhereClauseAll like '%CountryName%' OR @WhereClauseAll like '%CityName%' OR @WhereClauseAll like '%StateName%' OR @WhereClauseAll like '%PostalCode%' OR @WhereClauseAll like '%CompanyName%'))
		BEGIN
			 
			 update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, 
			               PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName, a.AddressId = ZA.AddressId
			 from ##CustomerUserAddDetail a
			 inner join ZnodeAccountAddress ZAA on a.AccountId = ZAA.AccountId
			 inner  JOIN ZnodeAddress ZA on ZA.AddressId = ZAA.AddressId
			 where isnull(a.AccountId,0)<> 0-- is not null
	 
			 update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, 
			               PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName, a.AddressId = ZA.AddressId
			 from ##CustomerUserAddDetail a
			 inner join ZnodeUserAddress ZUA on a.UserId = ZUA.UserId
			 inner  JOIN ZnodeAddress ZA on ZA.AddressId = zua.AddressId
		END

		----Updating SalesRep for user if any 
		update CUAD
		set CUAD.SalesRepUserName = azu.UserName, 
			CUAD.SalesRepFullName = (ISNULL(RTRIM(LTRIM(ZU.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '')
								+CASE
									WHEN ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '') = ''
									THEN ''
									ELSE ' '
								END+ISNULL(RTRIM(LTRIM(ZU.LastName)), '')) 
		from ##CustomerUserAddDetail CUAD
		inner join ZnodeSalesRepCustomerUserPortal SRCUP ON CUAD.UserId = SRCUP.CustomerUserid 
		inner join ZnodeUser ZU ON SRCUP.SalesRepUserId = ZU.UserId
		inner join ASPNetUsers ANU ON(ZU.AspNetuserId = ANU.Id)
		inner join AspNetZnodeUser azu ON(azu.AspNetZnodeUserId = ANU.UserName)

		if ( exists(select * from ##UserList) OR @AddressColumnWhereClause <> '')
		begin
			SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				  EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				  AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				  BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				  CountryName, CityName, StateName, PostalCode, CompanyName, SalesRepUserName, SalesRepFullName
			from ##CustomerUserAddDetail CUAD
			where exists(select * from ##UserList UL where CUAD.UserId = UL.UserId and CUAD.AddressId = UL.AddressID )
			Order by RowNumber
		end
		else
		begin
			SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				  EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				  AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				  BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				  CountryName, CityName, StateName, PostalCode, CompanyName, SalesRepUserName, SalesRepFullName
			from ##CustomerUserAddDetail
			Order by RowNumber
		end
	
	if OBJECT_ID('tempdb..##CustomerUserAddDetail') is not null
		drop table ##CustomerUserAddDetail

	if OBJECT_ID('tempdb..##View_CustomerUserAddDetail') is not null
		drop table ##View_CustomerUserAddDetail

				END;
            ELSE
				BEGIN
					SELECT * FROM View_CustomerUserDetail AS VICUD WHERE 1 = 0;
					SET @RowCount = 0;
				END;
            END;			
         END TRY
         BEGIN CATCH
            DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUsers @RoleName = '+@RoleName+' ,@UserName='+@UserName+',@WhereClause='+cast(@WhereClause as varchar(max))+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50));
            EXEC Znode_InsertProcedureErrorLog
            @ProcedureName    = 'Znode_AdminUsers',
            @ErrorInProcedure = @ERROR_PROCEDURE,
            @ErrorMessage     = @ErrorMessage,
            @ErrorLine        = @ErrorLine,
            @ErrorCall        = @ErrorCall;
         END CATCH;


     END;
	 go
	 if exists(select * from sys.procedures where name = 'Znode_GetAccountListWithAddress')
	drop proc Znode_GetAccountListWithAddress
go

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

			------Commented query due to slowness
			--SELECT  a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, b.Name AS ParentAccountName ,ZPA.PortalId,ZP.StoreName, PC.CatalogName,
			--(select top 1 PostalCode from ZnodeAddress where AddressId in  (select AddressId from ZnodeAccountAddress where AccountId = a.AccountId AND IsDefaultShipping = 1)) AS ShippingPostalCode,
			--(select top 1 PostalCode from ZnodeAddress where AddressId in  (select AddressId from ZnodeAccountAddress where AccountId = a.AccountId AND IsDefaultBilling = 1)) AS BillingPostalCode
			--into #AccountListAis
			--FROM dbo.ZnodeAccount AS a 
			--LEFT OUTER JOIN dbo.ZnodeAccount AS b ON a.ParentAccountId = b.AccountId
			--LEFT JOIN ZnodePortalAccount ZPA  ON (ZPA.AccountId = a.AccountId)
			--LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZPA.PortalId)
			--LEFT JOIN ZnodePortalCatalog ZPC ON ( ZPA.PortalId = ZPC.PortalId )
			--LEFT JOIN ZnodePublishcatalog PC ON ( PC.PublishcatalogId = COALESCE(a.PublishCatalogId, ZPC.PublishcatalogId ) )

			----Re-write above query for optimization
			;with cte_Account as
			(
				SELECT  a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, b.Name AS ParentAccountName ,ZPA.PortalId,ZP.StoreName, PC.CatalogName
				FROM dbo.ZnodeAccount AS a 
				LEFT JOIN dbo.ZnodeAccount AS b ON a.ParentAccountId = b.AccountId
				LEFT JOIN ZnodePortalAccount ZPA  ON (ZPA.AccountId = a.AccountId)
				LEFT JOIN ZnodePortal ZP ON (ZP.PortalId = ZPA.PortalId)
				LEFT JOIN ZnodePortalCatalog ZPC ON ( ZPA.PortalId = ZPC.PortalId )
				LEFT JOIN ZnodePublishcatalog PC ON ( PC.PublishcatalogId = COALESCE(a.PublishCatalogId, ZPC.PublishcatalogId ) )
			)
			,cte_ShippingPostalCode as
			(
				select zaa.AccountId, min(PostalCode) as ShippingPostalCode 
				from ZnodeAccountAddress zaa 
				inner join ZnodeAddress za on za.AddressId = zaa.AddressId AND IsDefaultShipping = 1	
				where exists(select * from cte_Account a where zaa.AccountId = a.AccountId )
				and isnull(PostalCode,'0') <> '0'
				group by zaa.AccountId 	
			)
			,cte_BillingPostalCode as
			(
				select zaa.AccountId, min(PostalCode) as BillingPostalCode 
				from ZnodeAccountAddress zaa 
				inner join ZnodeAddress za on za.AddressId = zaa.AddressId AND IsDefaultBilling = 1	
				where exists(select * from cte_Account a where zaa.AccountId = a.AccountId )	
				and isnull(PostalCode,'0') <> '0'
				group by zaa.AccountId
			)
			select a.*, b.ShippingPostalCode, b1.BillingPostalCode
			into #AccountListAis
			from cte_Account a
			left join cte_ShippingPostalCode b on a.AccountId = b.AccountId
			left join cte_BillingPostalCode b1 on a.AccountId = b1.AccountId

             DECLARE @SQL NVARCHAR(MAX), @Rows_start VARCHAR(1000), @Rows_end VARCHAR(1000);
             SET @Rows_start = CASE WHEN @Rows >= 1000000 THEN 0 ELSE(@Rows * (@PageNo - 1)) + 1 END;
             SET @Rows_end = CASE WHEN @Rows >= 1000000THEN @Rows ELSE @Rows * (@PageNo) END;
             SET @SQL = '
			 CREATE TABLE #TBL_AddressDetails (AccountId INT ,Address NVARCHAR(max),IsDefaultBilling BIT ,IsDefaultShipping BIT,RowId INT  )
			 CREATE TABLE #TBL_AddressDetailsFinal (AccountId INT ,Address NVARCHAR(max))
			 
			 SELECT *,RANK()OVER(ORDER BY '+CASE
                                                    WHEN @Order_BY = ''
                                                    THEN ' AccountId ,'
                                                    ELSE @Order_BY+' , '
                                                END+' AccountId ) RowId 
			 into #TBL_AccountsDetails
			 FROM #AccountListAis
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
			    
			 SELECT @COUNT= COUNT(1) FROM #TBL_AccountsDetails

			 INSERT INTO #TBL_AddressDetails (AccountId,Address,IsDefaultBilling,IsDefaultShipping,RowId)
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
			 WHERE EXISTS ( SELECT TOP 1 1 FROM  #TBL_AccountsDetails a  WHERE a.AccountId = c.AccountId AND a.RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+')  
			    
			 ;With AccountAddressShipping AS 
			 (
			 SELECT * FROM #TBL_AddressDetails mn WHERE IsDefaultShipping = 1 
			 )
			 ,  AccountAddressBilling AS 
			 (
				 SELECT * 
				 FROM AccountAddressShipping 
				 UNION ALL 
				 SELECT * 
				 FROM #TBL_AddressDetails mn 
				 WHERE IsDefaultBilling = 1 
				 AND NOT EXISTS (SELECT TOP 1 1 FROM AccountAddressShipping sw WHERE sw.AccountId = mn.AccountId )
			 )


			 INSERT INTO #TBL_AddressDetailsFinal 

			 SELECT AccountId ,Address 
			 FROM AccountAddressBilling 

			    
			 INSERT INTO #TBL_AddressDetailsFinal 
			 SELECT AccountId , Address 
			 FROM #TBL_AddressDetails  q
			 WHERE NOT EXISTS (SELECT  TOP 1 1 FROM #TBL_AddressDetailsFinal  fg WHERE fg.AccountId = q.AccountId )
			 AND RowId = 1 



			 SELECT a.AccountId, a.ExternalId, a.Name,a.ParentAccountId, a.ParentAccountName ,b.[Address] AccountAddress,a.PortalId,a.StoreName, a.CatalogName,ShippingPostalCode,BillingPostalCode
			 FROM #TBL_AccountsDetails a 
			 INNER JOIN #TBL_AddressDetailsFinal  b ON (a.AccountId = b.AccountId )
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
go
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>OmsOrderId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>OrderNumber</name>      <headertext>Order No</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Order/Manage</islinkactionurl>      <islinkparamfield>OmsOrderId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>UserName</name>      <headertext>Customer Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Email</name>      <headertext>Email</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PhoneNumber</name>      <headertext>Phone Number</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>OrderState</name>      <headertext>Order Status</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>orderState</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>PaymentStatus</name>      <headertext>Payment Status</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>paymentStatus</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>PaymentDisplayName</name>      <headertext>Payment Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>paymentType</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>OrderTotalWithCurrency</name>      <headertext>Total</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>Total</name>      <headertext>Total</headertext>      <width>30</width>      <datatype>Decimal</datatype>      <columntype>Decimal</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>SubTotalAmount</name>      <headertext>SubTotal</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>13</id>      <name>Tax</name>      <headertext>Tax</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>14</id>      <name>Shipping</name>      <headertext>Shipping</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>15</id>      <name>BillingPostalCode</name>      <headertext>Billing Zip Code</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>16</id>      <name>ShippingPostalCode</name>      <headertext>Shipping Zip Code</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>17</id>      <name>OrderDateWithTime</name>      <headertext>Order Date</headertext>      <width>0</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>18</id>      <name>CreatedByName</name>      <headertext>Created By</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>19</id>      <name>PublishState</name>      <headertext>Application Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>20</id>      <name>ModifiedByName</name>      <headertext>Modified By</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Boolean</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>21</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>View|void-payment</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Order/Manage</manageactionurl>      <manageparamfield>OmsOrderId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where  ItemName = 'ZnodeOrder'
go
--dt 09-01-2020 ZPD-5709 --> ZPD-8620
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetAddressDetails',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetAddressDetails')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAddressDetails') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAddressDetails'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAddressDetails')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAddressDetails'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetUserAddress',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetUserAddress')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetUserAddress') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetUserAddress'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetUserAddress')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetUserAddress'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetCustomerListBySearchTerm',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetCustomerListBySearchTerm')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetCustomerListBySearchTerm') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetCustomerListBySearchTerm'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetCustomerListBySearchTerm')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetCustomerListBySearchTerm'))

GO

if exists(select * from sys.procedures where name = 'Znode_DeletePortalByPortalId')
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
		--AND  NOT EXISTS (SELECT TOP 1 1 FROM ZnodeOmsQuote AS ZOQ WHERE ZOQ.PortalId = ZP.PortalId );

		
		--END
		--select * from @TBL_PortalIds
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
		--DELETE FROM ZnodeTaxRule WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodeTaxRule.PortalId);
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
		DELETE FROM ZnodePortalDisplaySetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalDisplaySetting.PortalId);
		
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
if exists(select * from sys.procedures where name = 'Znode_DeletePortalByStoreCode')
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
		DELETE FROM ZnodePortalDisplaySetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalDisplaySetting.PortalId);
		
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
if exists(select * from sys.procedures where name = 'Znode_GetPublishProductbulk')
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

EXEC [Znode_GetPublishProductbulk_r1] @PublishCatalogId=9,@UserId= 2 ,@localeIDs = @rrte,@PublishStateId = 3 

*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @PortalId INT = (SELECT TOP 1 POrtalId FROM ZnodePortalCatalog WHERE PublishCatalogId = @PublishCatalogId)
	DECLARE @PriceListId INT = (SELECT TOP 1 PriceListId FROM ZnodePriceListPortal WHERE PortalId = @PortalId )
	DECLARE @DomainUrl varchar(max) = (select TOp 1 URL FROM ZnodeMediaConfiguration WHERE IsActive =1)
	DECLARE @MaxSmallWidth INT  = (SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodePortalDisplaySetting WHERE PortalId = @PortalId)
	DECLARE @PimMediaAttributeId INT = dbo.Fn_GetProductImageAttributeId()

	DECLARE --@ProductNamePimAttributeId INT = dbo.Fn_GetProductNameAttributeId(),
	@DefaultLocaleId INT= Dbo.Fn_GetDefaultLocaleId(),@LocaleId INT = 0 
		--,@SkuPimAttributeId  INT =  dbo.Fn_GetProductSKUAttributeId() , @IsActivePimAttributeId INT =  dbo.Fn_GetProductIsActiveAttributeId()
   DECLARE @GetDate DATETIME =dbo.Fn_GetDate()

   declare @DefaultPortal int, @IsAllowIndexing int
	select @DefaultPortal = ZPC.PortalId, @IsAllowIndexing = 1 from ZnodePimCatalog ZPC Inner Join ZnodePublishCatalog ZPC1 ON ZPC.PimCatalogId = ZPC1.PimCatalogId where ZPC1.PublishCatalogId =  @PublishCatalogId and isnull(ZPC.IsAllowIndexing,0) = 1 

	--if @VersionId = 0 and @PimCatalogId <> 0
	--	select @VersionId = max(PublishCatalogLogId) from ZnodePublishCatalogLog where PublishCatalogId = (select top 1 PublishCatalogId from ZnodePublishCatalog where PimCatalogId = @PimCatalogId )

	--if @VersionId = 0 and @PublishCatalogId <> 0 and @PimCatalogId = 0
	--	select @VersionId = max(PublishCatalogLogId) from ZnodePublishCatalogLog where PublishCatalogId = PublishCatalogId

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
	
	--truncate table ZnodePublishedXml
	
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
				---configdataxml 
				--+isnull(cast(CPD.ConfigDataXML as varchar(max)),'')--isnull((SELECT ''+CPD.ConfigDataXML FOR XML PATH('')), '')
				---
				+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
								FROM ZnodeProfileCatalog ZPFC 
								INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
								WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+'</TempProfileIds>
				<ProductIndex>'+CAST(ZPCPD.ProductIndex AS VARCHAr(100))+'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
				'<DisplayOrder>'+CAST(ISNULL(ZPCCF.DisplayOrder,'') AS VARCHAR(50))+'</DisplayOrder>'+cast(PAX.ProductXML as varchar(max))
				--cast(( SELECT Attributes as AttributeEntity   FROM ZnodePublishProductAttributeXML TY WHERE TY.PimProductId = ZPP.PimProductId  AND TY.LocaleId = ZPCPD.LocaleId 
				--FOR XML PATH('Attributes'), TYPE) as varchar(max))
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
			LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId)
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
if exists(select * from sys.procedures where name = 'Znode_ImportSEODetails')
	drop proc Znode_ImportSEODetails
go
  
CREATE  PROCEDURE [dbo].[Znode_ImportSEODetails](  
   @TableName nvarchar(100), 
   @Status bit OUT, @UserId int, 
   @ImportProcessLogId int, 
   @NewGUId nvarchar(200), 
   @LocaleId int= 1,
   @PortalId int ,
   @CsvColumnString nvarchar(max))  
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
    
    
  DECLARE @CMSSEOTypeProduct INT ,@CMSSEOTypeCategory INT  
  
  SELECT @CMSSEOTypeProduct = CMSSEOTypeId FROM ZnodeCMSSEOType WHERE Name = 'Product'  
  SELECT @CMSSEOTypeCategory = CMSSEOTypeId FROM ZnodeCMSSEOType WHERE Name = 'Category'  
  
  
  -- Three type of import required three table varible for product , category and brand  
  DECLARE @InsertSEODetails TABLE  
  (   
   RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300),   
   IsRedirect bit ,MetaInformation nvarchar(max),PortalId int ,SEOUrl nvarchar(max),IsActive varchar(10),  
   SEOTitle nvarchar(max),SEODescription nvarchar(max),SEOKeywords nvarchar(max),   
   RedirectFrom nvarchar(max),RedirectTo nvarchar(max), EnableRedirection bit, CanonicalURL VARCHAR(200),   
   RobotTag VARCHAR(50), GUID nvarchar(400)  
   --Index Ind_ImportType (ImportType),Index Ind_Code (Code)  
  );  
  
  DECLARE @InsertSEODetailsOFProducts TABLE  
  (   
   RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300),   
   IsRedirect bit ,MetaInformation nvarchar(max),PortalId int ,SEOUrl nvarchar(max),IsActive varchar(10),  
   SEOTitle nvarchar(max),SEODescription nvarchar(max),SEOKeywords nvarchar(max),  
   RedirectFrom nvarchar(max),RedirectTo nvarchar(max), EnableRedirection bit, CanonicalURL VARCHAR(200),  
   RobotTag VARCHAR(50),GUID nvarchar(400)  
   --Index Ind_ImportType (ImportType),Index Ind_Code (Code)  
  );  
  
  DECLARE @InsertSEODetailsOFCategory TABLE  
  (   
   RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300),   
   IsRedirect bit ,MetaInformation nvarchar(max),PortalId int ,SEOUrl nvarchar(max),IsActive varchar(10),  
   SEOTitle nvarchar(max),SEODescription nvarchar(max),SEOKeywords nvarchar(max),  
   RedirectFrom nvarchar(max),RedirectTo nvarchar(max), EnableRedirection bit, CanonicalURL VARCHAR(200), 
   RobotTag VARCHAR(50),GUID nvarchar(400)  
   --Index Ind_ImportType (ImportType),Index Ind_Code (Code)  
  );  
  
  DECLARE @InsertSEODetailsOFBrand TABLE  
  (   
   RowId int IDENTITY(1, 1) PRIMARY KEY, RowNumber int, ImportType varchar(20), Code nvarchar(300),   
   IsRedirect bit ,MetaInformation nvarchar(max),PortalId int ,SEOUrl nvarchar(max),IsActive varchar(10),  
   SEOTitle nvarchar(max),SEODescription nvarchar(max),SEOKeywords nvarchar(max),   
   RedirectFrom nvarchar(max),RedirectTo nvarchar(max), EnableRedirection bit, CanonicalURL VARCHAR(200),  
   RobotTag VARCHAR(50),GUID nvarchar(400)  
   --Index Ind_ImportType (ImportType),Index Ind_Code (Code)  
  );  
  
    
  DECLARE @InsertedZnodeCMSSEODetail TABLE  
  (   
   CMSSEODetailId int , SEOCode Varchar(4000), CMSSEOTypeId int  
  );  
    
  --SET @SSQL = 'Select RowNumber,ImportType,Code,IsRedirect,MetaInformation,SEOUrl,IsActive,SEOTitle,SEODescription,SEOKeywords,GUID  FROM '+@TableName;  
  SET @SSQL = 'Select RowNumber,'+@CsvColumnString+',GUID  FROM '+@TableName;  
  
  INSERT INTO @InsertSEODetails(RowNumber,ImportType,Code,IsRedirect,MetaInformation,SEOUrl,IsActive,SEOTitle,SEODescription,SEOKeywords,RedirectFrom,RedirectTo,EnableRedirection,CanonicalURL,RobotTag,GUID )  
  EXEC sys.sp_sqlexec @SSQL;  
  
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '30', 'SEOUrl', SEOUrl, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii   
      where ii.SEOURL in (Select ISD.SEOURL from @InsertSEODetails ISD Group by ISD.SEOUrl having count(*) > 1 ) 
	    
  
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '10', 'SEOUrl', SEOUrl, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii   
      where EXISTS (Select TOP 1 1 from ZnodeCMSSEODetail ZCSD WHERE ZCSD.SEOUrl = ii.SEOUrl AND ZCSD.PortalId = @PortalId
	  AND ZCSD.SEOCode <> ii.Code  AND EXISTS  
     (SELECT TOP 1 1 FROM ZnodeCMSSEODetailLocale dl WHERE dl.CMSSEODetailId = ZCSD.CMSSEODetailId AND dl.LocaleId = @LocaleId  
           AND dl.SEODescription = ii.SEODescription AND dl.SEOTitle = ii.SEOTitle AND dl.SEOKeywords = ii.SEOKeywords))   
  
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '53', 'RedirectFrom', RedirectFrom, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii   
      where ii.RedirectFrom in (Select ISD.RedirectFrom from @InsertSEODetails ISD Group by ISD.RedirectFrom having count(*) > 1 )   
  AND (ii.RedirectFrom <> '' )

  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '35', 'RedirectFrom\RedirectTo', RedirectFrom + '  ' + RedirectTo  , @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii   
      where ii.RedirectFrom = ii.RedirectTo  
	  AND (ii.RedirectFrom <> '' AND ii.RedirectTo <> '' )
  
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '35', 'SEOUrl', SEOUrl, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii  
      WHERE ltrim(rtrim(isnull(ii.SEOUrl,''))) like '% %' -----space not allowed  
  
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '19', 'ImportType', ImportType, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii  
      WHERE ii.ImportType NOT in   
      (  
       Select NAME from ZnodeCMSSEOType where NAME NOT IN ('Content Page','BlogNews','Brand')  
      );  

  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '35', 'IsActive', IsActive, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetails AS ii  
      WHERE ii.IsActive not in ('True','1','Yes','FALSE','0','No')
  
  --INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
  --    SELECT '30', 'CanonicalURL', CanonicalURL, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
  --    FROM @InsertSEODetails AS ii   
  --    where ii.CanonicalURL in (Select ISD.CanonicalURL from @InsertSEODetails ISD Group by ISD.CanonicalURL having count(*) > 1 )

  --INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
  --    SELECT '10', 'CanonicalURL', CanonicalURL, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
  --    FROM @InsertSEODetails AS ii   
  --    where EXISTS (Select TOP 1 1 from ZnodeCMSSEODetail ZCSD WHERE ZCSD.PortalId = @PortalId
	 -- AND ZCSD.SEOCode <> ii.Code  AND EXISTS  
  --   (SELECT TOP 1 1 FROM ZnodeCMSSEODetailLocale dl WHERE dl.CMSSEODetailId = ZCSD.CMSSEODetailId AND dl.LocaleId = @LocaleId  
  --         AND dl.CanonicalURL = ii.CanonicalURL AND dl.SEODescription = ii.SEODescription AND dl.SEOTitle = ii.SEOTitle AND dl.SEOKeywords = ii.SEOKeywords)) 

  --INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
  --    SELECT '35', 'CanonicalURL', CanonicalURL, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId  
  --    FROM @InsertSEODetails AS ii  
  --    WHERE ltrim(rtrim(isnull(ii.CanonicalURL,''))) like '% %'

  UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ SEOCode - ' + ISNULL(Code,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN @InsertSEODetails IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL


  
  DELETE FROM @InsertSEODetails  
  WHERE RowNumber IN  
  (  
   SELECT DISTINCT   
       RowNumber  
   FROM ZnodeImportLog  
   WHERE ImportProcessLogId = @ImportProcessLogId  and RowNumber is not null   
   --AND GUID = @NewGUID  
  );  
    
   
  
-------------------------------------------------------------------------------------------------------------------------------  
  
  INSERT INTO @InsertSEODetailsOFProducts(  RowNumber , ImportType , Code ,   
   IsRedirect ,MetaInformation ,SEOUrl ,IsActive ,  
   SEOTitle ,SEODescription ,SEOKeywords, RedirectFrom, RedirectTo,EnableRedirection, CanonicalURL, RobotTag, GUID )  
   SELECT RowNumber , ImportType , Code , IsRedirect ,MetaInformation ,SEOUrl , 
      CASE WHEN IsActive in ('True','1','Yes') 
	       Then 1 
           ELSE 0
      END as IsActive, SEOTitle ,SEODescription ,SEOKeywords, RedirectFrom, RedirectTo,EnableRedirection, CanonicalURL, RobotTag, GUID  
   FROM @InsertSEODetails WHERE ImportType = 'Product'  
  
  
  INSERT INTO @InsertSEODetailsOFCategory( RowNumber , ImportType , Code ,   
   IsRedirect ,MetaInformation,SEOUrl ,IsActive ,  
   SEOTitle ,SEODescription ,SEOKeywords, RedirectFrom, RedirectTo,EnableRedirection, CanonicalURL, RobotTag , GUID )  
   SELECT RowNumber , ImportType , Code , IsRedirect ,MetaInformation ,SEOUrl , 
	   CASE WHEN IsActive in ('True','1','Yes') 
			Then 1 
			ELSE 0
	   END as IsActive, SEOTitle ,SEODescription ,SEOKeywords, RedirectFrom, RedirectTo,EnableRedirection, CanonicalURL, RobotTag, GUID  
   FROM @InsertSEODetails WHERE ImportType = 'Category'  
  
  INSERT INTO @InsertSEODetailsOFBrand( RowNumber , ImportType , Code ,   
   IsRedirect ,MetaInformation ,SEOUrl ,IsActive ,  
   SEOTitle ,SEODescription ,SEOKeywords, RedirectFrom, RedirectTo,EnableRedirection, CanonicalURL, RobotTag , GUID )  
   SELECT RowNumber , ImportType , Code , IsRedirect ,MetaInformation ,SEOUrl ,
		CASE WHEN IsActive in ('True','1','Yes') 
			Then 1 
			ELSE 0
	    END as IsActive, SEOTitle ,SEODescription ,SEOKeywords, RedirectFrom, RedirectTo,EnableRedirection, CanonicalURL, RobotTag, GUID  
   FROM @InsertSEODetails WHERE ImportType = 'Brand'  
  
  
     -- start Functional Validation   
  --1. Product  
  --2. Category  
  --3. Content Page  
  --4. Brand  
  -----------------------------------------------  
  
    
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '19', 'SKU', CODE, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetailsOFProducts AS ii  
      WHERE ii.CODE NOT in   
      (  
     SELECT ZPAVL.AttributeValue  
     FROM ZnodePimAttributeValue ZPAV   
     inner join ZnodePimAttributeValueLocale ZPAVL ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId  
     inner join ZnodePimAttribute ZPA on ZPAV.PimAttributeId = ZPA.PimAttributeId  
     Where ZPA.AttributeCode = 'SKU' AND ZPAVL.AttributeValue IS NOT NULL   
      )  AND ImportType = 'Product';  
  
  
    
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '19', 'Category', CODE, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetailsOFCategory AS ii  
      WHERE ii.CODE NOT in   
      (  
     SELECT ZPCAVL.CategoryValue  
     FROM ZnodePimCategoryAttributeValue ZPCAV   
     INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL on ZPCAV.PimCategoryAttributeValueId = ZPCAVL.PimCategoryAttributeValueId  
     INNER JOIN ZnodePimAttribute ZPA on ZPCAV.PimAttributeId = ZPA.PimAttributeId  
     Where ZPA.AttributeCode = 'CategoryCode' AND ZPCAVL.CategoryValue IS NOT NULL  
      )  AND ImportType = 'Category';  
  
  INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )  
      SELECT '19', 'Brand', CODE, @NewGUId, RowNumber, @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId  
      FROM @InsertSEODetailsOFBrand AS ii  
      WHERE ii.CODE NOT in   
      (  
       Select BrandCode from ZnodeBrandDetails WHERE BrandCode IS NOT NULL  
      )  AND ImportType = 'Brand';  
    
    -- Update Record count in log 
        DECLARE @FailedRecordCount BIGINT
		DECLARE @SuccessRecordCount BIGINT
		SELECT @FailedRecordCount = COUNT(DISTINCT RowNumber) FROM ZnodeImportLog WHERE RowNumber IS NOT NULL AND  ImportProcessLogId = @ImportProcessLogId;
		Select @SuccessRecordCount = count(DISTINCT RowNumber) FROM @InsertSEODetails
		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount , 
		TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0))
		WHERE ImportProcessLogId = @ImportProcessLogId;
	

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
         ZCSD.SEOUrl=  ISD.SEOUrl,  
         ZCSD.IsPublish = 0  
   FROM   
   @InsertSEODetailsOFProducts ISD    
   INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = @CMSSEOTypeProduct AND ZCSD.SEOCode = ISD.Code  
   INNER JOIN ZnodeCMSSEODetailLocale ZCSDL ON ZCSD.CMSSEODetailId = ZCSDL.CMSSEODetailId  
   where  ZCSD.PortalId  =@PortalId  AND ZCSDL.LocaleId = @LocaleId;  
     
   Update ZCSDL SET ZCSDL.SEOTitle = ISD.SEOTitle  
       ,ZCSDL.SEODescription = ISD.SEODescription  
       ,ZCSDL.SEOKeywords= ISD.SEOKeywords
	   ,ZCSDL.CanonicalURL = ISD.CanonicalURL
	   ,ZCSDL.RobotTag = ISD.RobotTag  
    FROM   
   @InsertSEODetailsOFProducts ISD    
   INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = @CMSSEOTypeProduct AND ZCSD.SEOCode = ISD.Code  
   INNER JOIN ZnodeCMSSEODetailLocale ZCSDL ON ZCSD.CMSSEODetailId = ZCSDL.CMSSEODetailId  
   where  ZCSD.PortalId = @PortalId AND ZCSDL.LocaleId = @LocaleId;   
  
  ----Making product as draft if SEOUrl is changed for part of partial publish
   update ZPP SET ZPP.PublishStateId = (select top 1 PublishStateId from ZnodePublishState where StateName = 'Draft')
   from ZnodePimProduct ZPP
   inner join ZnodePimAttributeValue ZPAV ON ZPP.PimProductId = ZPAV.PimProductId
   inner join ZnodePimAttributeValueLocale ZPAVL ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
   where exists (select * from ZnodePimAttribute zpa where zpa.AttributeCode = 'SKU' and ZPAV.PimAttributeId = zpa.PimAttributeId)
   and exists(select * from @InsertSEODetailsOFProducts ISD    
			 INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = @CMSSEOTypeProduct AND ZCSD.SEOCode = ISD.Code
			 where ZPAVL.AttributeValue = ZCSD.SEOCode
			 )
     
   insert into ZnodeCMSSEODetailLocale (CMSSEODetailId,LocaleId,SEOTitle,SEODescription,SEOKeywords,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CanonicalURL,RobotTag)  
   SELECT distinct CSD.CMSSEODetailId,@LocaleId,ISD.SEOTitle,ISD.SEODescription,ISD.SEOKeywords,@USerId, @GetDate,@USerId, @GetDate, CanonicalURL,RobotTag  
   FROM ZnodeCMSSEODetail CSD  
   INNER JOIN @InsertSEODetailsOFProducts ISD ON CSD.SEOCode = ISD.Code AND CSD.CMSSEOTypeId = @CMSSEOTypeProduct AND CSD.SEOUrl = ISD.SEOUrl  
   WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEODetailLocale CSDL WHERE CSDL.LocaleId = @LocaleId AND CSD.CMSSEODetailId = CSDL.CMSSEODetailId )  
   AND CSD.portalId = @PortalId  
  
     
   Delete from @InsertedZnodeCMSSEODetail  
  
   IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEODetail SD INNER JOIN @InsertSEODetailsOFProducts DP ON SD.SEOCode = DP.Code AND SD.PortalId =  @PortalId  
                        AND  SD.CMSSEOTypeId = @CMSSEOTypeProduct)  
   BEGIN  
   INSERT INTO ZnodeCMSSEODetail(CMSSEOTypeId,SEOCode,IsRedirect,MetaInformation,PortalId,SEOUrl,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)    
   OUTPUT Inserted.CMSSEODetailId,Inserted.SEOCode,Inserted.CMSSEOTypeId INTO @InsertedZnodeCMSSEODetail    
   Select Distinct @CMSSEOTypeProduct,ISD.Code , ISD.IsRedirect,ISD.MetaInformation,@PortalId,ISD.SEOUrl,@USerId, @GetDate,@USerId, @GetDate from   
   @InsertSEODetailsOFProducts ISD    
   where NOT EXISTS (Select TOP 1 1 from ZnodeCMSSEODetail ZCSD where ZCSD.CMSSEOTypeId = @CMSSEOTypeProduct AND ZCSD.SEOCode = ISD.Code and  ZCSD.PortalId =@PortalId   );  
    
   insert into ZnodeCMSSEODetailLocale(CMSSEODetailId,LocaleId,SEOTitle,SEODescription,SEOKeywords,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CanonicalURL,RobotTag)  
   Select Distinct IZCSD.CMSSEODetailId,@LocaleId,ISD.SEOTitle,ISD.SEODescription,ISD.SEOKeywords,@USerId, @GetDate,@USerId, @GetDate,CanonicalURL,RobotTag   
   from @InsertedZnodeCMSSEODetail IZCSD   
   INNER JOIN @InsertSEODetailsOFProducts ISD ON IZCSD.SEOCode = ISD.Code   

   ----Making product as draft if SEOUrl is inserted for part of partial publish
   update ZPP SET ZPP.PublishStateId = (select top 1 PublishStateId from ZnodePublishState where StateName = 'Draft')
   from ZnodePimProduct ZPP
   inner join ZnodePimAttributeValue ZPAV ON ZPP.PimProductId = ZPAV.PimProductId
   inner join ZnodePimAttributeValueLocale ZPAVL ON ZPAV.PimAttributeValueId = ZPAVL.PimAttributeValueId
   where exists (select * from ZnodePimAttribute zpa where zpa.AttributeCode = 'SKU' and ZPAV.PimAttributeId = zpa.PimAttributeId)
   and exists(select * from @InsertedZnodeCMSSEODetail IZCSD where ZPAVL.AttributeValue = IZCSD.SEOCode)
  
   END  
     
  
   -----RedirectUrlInsert  
  -- INSERT INTO ZnodeCMSUrlRedirect ( RedirectFrom,RedirectTo,IsActive,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
  -- select RedirectFrom,RedirectTo,EnableRedirection,@PortalId as PortalId ,@USerId as CreatedBy,@GetDate as CreatedDate,@USerId as ModifiedBy,@GetDate as ModifiedDate  
  -- from @InsertSEODetailsOFProducts  
  -- where IsRedirect = 1  
  --END  
  
  
     INSERT INTO ZnodeCMSUrlRedirect ( RedirectFrom,RedirectTo,IsActive,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
   select RedirectFrom,RedirectTo,EnableRedirection 
 ,@PortalId as PortalId ,@USerId as CreatedBy,@GetDate as CreatedDate,@USerId as ModifiedBy,@GetDate as ModifiedDate  
   from @InsertSEODetailsOFProducts  SDP
   where IsRedirect = 1  
   AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSUrlRedirect ZCR 
								  WHERE ZCR.RedirectFrom = SDP.RedirectFrom AND ZCR.RedirectTo = SDP.RedirectTo)
   AND (SDP.RedirectFrom <> '' AND SDP.RedirectTo <> '' )
  END  
  
  -- Insert Category Data   
  If Exists (Select top 1 1 from @InsertSEODetailsOFCategory)  
  Begin  
  
   Update ZCSD SET ZCSD.IsRedirect = ISD.IsRedirect ,  
         ZCSD.MetaInformation =  ISD.MetaInformation,  
         ZCSD.SEOUrl=  ISD.SEOUrl,  
         ZCSD.IsPublish = 0  
   FROM   
   @InsertSEODetailsOFCategory ISD    
   INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = @CMSSEOTypeCategory AND ZCSD.SEOCode = ISD.Code  
   INNER JOIN ZnodeCMSSEODetailLocale ZCSDL ON ZCSD.CMSSEODetailId = ZCSDL.CMSSEODetailId  
   where  ZCSD.PortalId  =@PortalId  AND ZCSDL.LocaleId = @LocaleId;  
     
     
   Update ZCSDL SET ZCSDL.SEOTitle = ISD.SEOTitle  
       ,ZCSDL.SEODescription = ISD.SEODescription  
       ,ZCSDL.SEOKeywords= ISD.SEOKeywords 
	   ,CanonicalURL = ISD.CanonicalURL
	   ,RobotTag = ISD.RobotTag
    FROM   
   @InsertSEODetailsOFCategory ISD    
   INNER JOIN ZnodeCMSSEODetail ZCSD ON  ZCSD.CMSSEOTypeId = @CMSSEOTypeCategory AND ZCSD.SEOCode = ISD.Code  
   INNER JOIN ZnodeCMSSEODetailLocale ZCSDL ON ZCSD.CMSSEODetailId = ZCSDL.CMSSEODetailId  
   where  ZCSD.PortalId  =@PortalId AND ZCSDL.LocaleId = @LocaleId;   
  
   insert into ZnodeCMSSEODetailLocale (CMSSEODetailId,LocaleId,SEOTitle,SEODescription,SEOKeywords,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CanonicalURL,RobotTag)  
   SELECT distinct CSD.CMSSEODetailId,@LocaleId,ISD.SEOTitle,ISD.SEODescription,ISD.SEOKeywords,@USerId, @GetDate,@USerId, @GetDate,CanonicalURL,RobotTag  
   FROM ZnodeCMSSEODetail CSD  
   INNER JOIN @InsertSEODetailsOFProducts ISD ON CSD.SEOCode = ISD.Code AND CSD.CMSSEOTypeId = @CMSSEOTypeCategory AND CSD.SEOUrl = ISD.SEOUrl  
   WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEODetailLocale CSDL WHERE CSDL.LocaleId = @LocaleId AND CSD.CMSSEODetailId = CSDL.CMSSEODetailId )  
   AND CSD.portalId = @PortalId  
  
  
   Delete from @InsertedZnodeCMSSEODetail  
  
   IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSSEODetail SD INNER JOIN @InsertSEODetailsOFProducts DP ON SD.SEOCode = DP.Code AND SD.PortalId =  @PortalId  
                        AND  SD.CMSSEOTypeId = @CMSSEOTypeCategory)  
   BEGIN  
   INSERT INTO ZnodeCMSSEODetail(CMSSEOTypeId,SEOCode,IsRedirect,MetaInformation,PortalId,SEOUrl,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)    
   OUTPUT Inserted.CMSSEODetailId,Inserted.SEOCode,Inserted.CMSSEOTypeId INTO @InsertedZnodeCMSSEODetail    
   Select Distinct @CMSSEOTypeCategory,ISD.Code , ISD.IsRedirect,ISD.MetaInformation,@PortalId,ISD.SEOUrl,@USerId, @GetDate,@USerId, @GetDate   
   from @InsertSEODetailsOFCategory ISD    
   where NOT EXISTS (Select TOP 1 1 from ZnodeCMSSEODetail ZCSD where ZCSD.CMSSEOTypeId = @CMSSEOTypeCategory AND ZCSD.SEOCode  = ISD.Code AND ZCSD.PortalId = @PortalId );  
  
   insert into ZnodeCMSSEODetailLocale(CMSSEODetailId,LocaleId,SEOTitle,SEODescription,SEOKeywords,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CanonicalURL,RobotTag)  
   Select Distinct IZCSD.CMSSEODetailId,@LocaleId,ISD.SEOTitle,ISD.SEODescription,ISD.SEOKeywords,@USerId, @GetDate,@USerId, @GetDate,CanonicalURL,RobotTag   
   from @InsertedZnodeCMSSEODetail IZCSD   
   INNER JOIN @InsertSEODetailsOFCategory ISD ON IZCSD.SEOCode = ISD.Code   
   WHERE IZCSD.CMSSEOTypeId =@CMSSEOTypeCategory    
   END  
  
   -----RedirectUrlInsert  
   INSERT INTO ZnodeCMSUrlRedirect ( RedirectFrom,RedirectTo,IsActive,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
   SELECT RedirectFrom,RedirectTo,
   EnableRedirection,@PortalId as PortalId ,2 as CreatedBy,@GetDate as CreatedDate,2 as ModifiedBy,@GetDate as ModifiedDate  
   FROM @InsertSEODetailsOFProducts SDP  
   WHERE IsRedirect = 1 
   --AND (SDP.RedirectFrom <> '' AND SDP.RedirectTo <> '' ) 
   AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSUrlRedirect ZCR 
								  WHERE ZCR.RedirectFrom = SDP.RedirectFrom AND ZCR.RedirectTo = SDP.RedirectTo)
   AND (SDP.RedirectFrom <> '' AND SDP.RedirectTo <> '' )
   --AND ((SDP.RedirectFrom <> '' OR SDP.RedirectFrom IS NOT NULL )
   --OR ( SDP.RedirectTo <> '' OR SDP.RedirectTo IS NOT NULL ))
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
go
insert into ZnodeApplicationSetting (GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 
'Table',	'ZnodeAccountUnAssociatedCustomer',	'<?xml version="1.0" encoding="UTF-8"?><columns><column><id>1</id><name>UserId</name><headertext>Checkbox</headertext><width>0</width><datatype>String</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>y</ischeckbox><checkboxparamfield /><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>FullName</name><headertext>Full Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>100</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>UserName</name><headertext>User Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>100</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>Email</name><headertext>Email ID</headertext><width>50</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>100</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>StoreName</name><headertext>Store Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>100</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>n</ischeckbox><checkboxparamfield /><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>',	
'ZnodeAccountUnAssociatedCustomer',	'ZnodeAccountUnAssociatedCustomer',	'ZnodeAccountUnAssociatedCustomer',	0,	NULL,	NULL,	NULL,	NULL,	2,	getdate(),	2	, getdate()
where not exists (select TOP 1 1 from ZnodeApplicationSetting where ItemName = 'ZnodeAccountUnAssociatedCustomer')
go

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Account','GetUnAssociatedCustomerList',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Account' and ActionName = 'GetUnAssociatedCustomerList')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'GetUnAssociatedCustomerList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'GetUnAssociatedCustomerList'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'GetUnAssociatedCustomerList')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'GetUnAssociatedCustomerList'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Account','AssociateUsersWithAccount',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Account' and ActionName = 'AssociateUsersWithAccount')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'AssociateUsersWithAccount') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'AssociateUsersWithAccount'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'AssociateUsersWithAccount')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Accounts' AND ControllerName = 'Account') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Account' and ActionName= 'AssociateUsersWithAccount'))

GO
if exists(select * from sys.procedures where name = 'Znode_AdminUnassociatedUsers')
	drop proc Znode_AdminUnassociatedUsers
go
  
CREATE PROCEDURE [dbo].[Znode_AdminUnassociatedUsers]
(
	@WhereClause    VARCHAR(max) = '',
	@Rows			INT           = 100,
	@PageNo			INT           = 1,
	@Order_By		VARCHAR(1000) = '',
	@RowCount		INT        = 0 OUT,
	@PortalId		INT = 0
)
/*
	exec Znode_AdminUnassociatedUsers @AccountId = 5, @Rows = 50, @PageNo = 1, @Order_By = 'UserId asc'
	,@WhereClause='Username like ''%abhilash.dadhe%'''
*/
AS
BEGIN

	BEGIN TRY
	SET NOCOUNT ON;

	--DECLARE @PortalId INT = isnull((select top 1 PortalId from ZnodePortalAccount where AccountId = @AccountId ),0)

	DECLARE @SQL NVARCHAR(MAX) = '',
	        @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');

	set @SQL = '
	;with cte_UserListPortalWise as
	(
		SELECT ZU.Userid, isnull(ZU.FirstName,'''')+'' ''+isnull(ZU.MiddleName,'''')+'' ''+isnull(ZU.LastName, '''') as FullName, ANZU.UserName, ZU.Email, 
			   case when ANZU.PortalId is null then ''ALL'' Else ZP.StoreName end as StoreName, ZU.ModifiedDate
		FROM AspNetZnodeUser ANZU
		inner join AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
		inner join ZnodeUser ZU ON ANU.Id = ZU.AspNetUserId
		left join ZnodePortal ZP ON ANZU.PortalId = ZP.PortalId
		WHERE ZU.AccountId is null
		and ( ANZU.PortalId = '+Cast(@PortalId as varchar(10))+' OR ANZU.PortalId is null )
	)
	select Userid,FullName, UserName, Email, StoreName,ModifiedDate 
	into #UserListPortalWise
	from cte_UserListPortalWise
	where 1=1 '+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+'

		select Userid,FullName, UserName, Email, StoreName,ModifiedDate,
	       Row_Number()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'ModifiedDate DESC, UserId DESC')+',ModifiedDate DESC, UserId DESC) RowId
		into #UserListPortalWise_RowNumber
		from #UserListPortalWise

		SET @Count= ISNULL((SELECT  Count(1) FROM #UserListPortalWise_RowNumber ),0)
	
		select Userid, FullName, UserName, Email, StoreName
		from #UserListPortalWise_RowNumber 
		'+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'ModifiedDate DESC, UserId DESC');

		print @SQL
		EXEC SP_executesql
					@SQL,
					N'@Count INT OUT',
					@Count = @RowCount OUT;

		--select @RowCount AS [RowCount]
		
	END TRY
    BEGIN CATCH
		DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUnassociatedUsers @WhereClause='+cast(@WhereClause as varchar(max))+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50))+'
		@PortalId='+CAST(@PortalId AS VARCHAR(50));
		EXEC Znode_InsertProcedureErrorLog
		@ProcedureName    = 'Znode_AdminUnassociatedUsers',
		@ErrorInProcedure = @ERROR_PROCEDURE,
		@ErrorMessage     = @ErrorMessage,
		@ErrorLine        = @ErrorLine,
		@ErrorCall        = @ErrorCall;
    END CATCH;

END
go

if exists(select * from sys.procedures where name = 'Znode_GetBrandDetailsLocale')
	drop proc Znode_GetBrandDetailsLocale
go
  

CREATE PROCEDURE [dbo].[Znode_GetBrandDetailsLocale]  
( @WhereClause  NVARCHAR(MAX),  
  @Rows    INT           = 10,  
  @PageNo   INT           = 1,  
  @Order_BY   VARCHAR(1000) = '',  
  @RowsCount  INT           = 0 OUT,  
  @LocaleId   INT           = 1,    
  @IsAssociated  BIT           = 0,  
  @PromotionId      INT     = 0   
)  
AS  
  /*  
     Summary :- This Procedure is used to get brand localies   
     Unit Testing   
  begin tran  
     EXEC Znode_GetBrandDetailsLocale ''isactive = 'true''',@RowsCount= 1,@LocaleId = 1   
  rollback tran    
 */  
  BEGIN  
         BEGIN TRY  
             SET NOCOUNT ON;  
             DECLARE @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId();  
             DECLARE @SeoId VARCHAR(MAX)= '', @SQL NVARCHAR(MAX); --, @SeoCode NVARCHAR(MAX) ;
			 DECLARE @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId')

             DECLARE @TBL_BrandDetails TABLE  
             (Description         NVARCHAR(MAX),  
              BrandId             INT,  
              BrandCode           VARCHAR(600),  
              DisplayOrder        INT,  
              IsActive            BIT,  
              WebsiteLink         NVARCHAR(1000),  
              BrandDetailLocaleId INT,  
              SEOFriendlyPageName NVARCHAR(600),  
              MediaPath           NVARCHAR(MAX),  
              MediaId             INT,  
			  ImageName           VARCHAR(300),
			  BrandName VARCHAR(100),	
              Custom1 NVARCHAR(MAX),	
              Custom2 NVARCHAR(MAX),
			  Custom3 NVARCHAR(MAX),
			  Custom4 NVARCHAR(MAX),
			  Custom5 NVARCHAR(MAX)  
             );  
  
    DECLARE @AttributeId INT= [dbo].[Fn_GetProductBrandAttributeId]();  
             DECLARE @TBL_AttributeDefault TABLE  
             (PimAttributeId            INT,  
              AttributeDefaultValueCode VARCHAR(600),  
              IsEditable                BIT,  
              AttributeDefaultValue     NVARCHAR(MAX)  
			 ,DisplayOrder INT   
             );  
             DECLARE @TBL_SeoDetails TABLE  
             (CMSSEODetailId       INT,  
              SEOTitle             NVARCHAR(MAX),  
              SEOKeywords          NVARCHAR(MAX),  
              SEOURL               NVARCHAR(MAX),  
              ModifiedDate         DATETIME,  
              SEODescription       NVARCHAR(MAX),  
              MetaInformation      NVARCHAR(MAX),  
              IsRedirect           BIT,  
              CMSSEODetailLocaleId INT,  
              --SEOId                INT ,
			  PublishStatus        NVARCHAR(20),
			  SEOCode				NVARCHAR(4000),
			  CanonicalURL  VARCHAR(200),
			  RobotTag      VARCHAR(50)
			   
             );  
             DECLARE @TBL_BrandDetail TABLE  
             (Description          NVARCHAR(MAX),  
              BrandId              INT,  
              BrandCode            VARCHAR(600),  
              DisplayOrder         INT,  
              IsActive             BIT,  
              WebsiteLink          NVARCHAR(1000),  
              BrandDetailLocaleId  INT,  
              MediaPath            NVARCHAR(MAX),  
              MediaId              INT,  
			  ImageName      VARCHAr(300) ,  
              CMSSEODetailId       INT,  
              SEOTitle             NVARCHAR(MAX),  
              SEOKeywords          NVARCHAR(MAX),  
              SEOURL               NVARCHAR(MAX),  
              ModifiedDate         DATETIME,  
              SEODescription       NVARCHAR(MAX),  
              MetaInformation      NVARCHAR(MAX),  
              IsRedirect           BIT,  
              CMSSEODetailLocaleId INT,  
              --SEOId                INT,  
              BrandName            NVARCHAR(MAX),  
              RowId                INT,  
              CountId              INT ,
			  SEOCode              NVARCHAR(4000), 
			  Custom1              NVARCHAR(MAX),
			  Custom2              NVARCHAR(MAX),
			  Custom3              NVARCHAR(MAX),
			  Custom4              NVARCHAR(MAX),
			  Custom5              NVARCHAR(MAX)
             );  
             IF @PromotionId > 0  
    BEGIN   
      
     SET @SeoId = ISNULL(SUBSTRING((SELECT ','+CAST(BrandId AS VARCHAR(50))  
     FROM ZnodePromotionBrand   
     WHERE PromotionId= @PromotionId  FOR XML PATH ('') ),2,4000),'0')  
  
     SET @WhereClause = CASE WHEN @IsAssociated = 1 THEN ' BrandId IN (' ELSE ' BrandId NOT IN (' END  +@SeoId+') AND '+CASE WHEN @WhereClause = '' THEN '1=1' ELSE @WhereClause END   
     SET @SeoId = ''  
    END    
      
   --  INSERT INTO @TBL_AttributeDefault  
   --EXEC Znode_GetAttributeDefaultValueLocale @AttributeId,@LocaleId;  
      
  
   --  IF @PromotionId = 0  
   -- BEGIN   
      
     
   --           SET @WhereClause = ' '+@WhereClause+CASE  
   --                                           WHEN @IsAssociated = 1  
   --                                                  THEN CASE  
   --                                                           WHEN @WhereClause = ''  
   --                                                           THEN ' '  
   --                                                           ELSE ' AND '  
   --                                                       END+' EXISTS ( SELECT TOP 1 1 FROM ZnodeBrandDetails BD INNER JOIN ZnodeBrandDetailLocale BDL ON (BD.BrandId = BDL.BrandId)   
                    
   --                                        WHERE ( BD.BrandCode = TMADV.BrandCode))'  
   --                                                  ELSE CASE  
   --                                                           WHEN @WhereClause = ''  
   --                                                           THEN ' 1 = 1  '  
   --                                                           ELSE ''  
   --                                                       END  
   --                                               END;  
   --END    
  
    
             ;WITH Cte_GetBrandBothLocale AS 
			 (
				SELECT ZBDL.Description,ZBD.BrandId,LocaleId,ZBD.BrandCode,ZBD.DisplayOrder,ZBD.IsActive,ZBD.WebsiteLink,ZBDl.BrandDetailLocaleId,  
				 SEOFriendlyPageName,[dbo].[Fn_GetMediaThumbnailMediaPath](Zm.path) MediaPath,ZBD.MediaId,Zm.path ImageName, ZBDL.BrandName, ZBD.Custom1, ZBD.Custom2, ZBD.Custom3, ZBD.Custom4, ZBD.Custom5 
				FROM ZnodeBrandDetails ZBD  
				LEFT JOIN ZnodeBrandDetailLocale ZBDL ON(ZBD.BrandId = ZBDL.BrandId)  
				LEFT JOIN ZnodeMedia ZM ON(ZM.MediaId = ZBD.MediaId)  
				WHERE LocaleId IN(@LocaleId, @DefaultLocaleId)  
              
             ),  
             Cte_BrandFirstLocale AS 
			(
				SELECT Description,BrandId,LocaleId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,SEOFriendlyPageName,MediaPath,MediaId,ImageName , BrandName, Custom1, Custom2, Custom3, Custom4, Custom5  
                FROM Cte_GetBrandBothLocale CTGBBL  
                WHERE LocaleId = @LocaleId
			),  
            Cte_BrandDefaultLocale AS 
			(
				SELECT Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,SEOFriendlyPageName,MediaPath,MediaId,ImageName, BrandName, Custom1, Custom2, Custom3, Custom4, Custom5  
                FROM Cte_BrandFirstLocale  
                UNION ALL  
                SELECT Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,SEOFriendlyPageName,MediaPath,MediaId,ImageName , BrandName, Custom1, Custom2, Custom3, Custom4, Custom5 
				FROM Cte_GetBrandBothLocale CTBBL  
				WHERE LocaleId = @DefaultLocaleId  
				AND NOT EXISTS  
            (  
                SELECT TOP 1 1  
                FROM Cte_BrandFirstLocale CTBFL  
                WHERE CTBBL.BrandId = CTBFL.BrandId  
            ))  
  
            INSERT INTO @TBL_BrandDetails (Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,MediaPath,MediaId,ImageName, BrandName, Custom1, Custom2, Custom3, Custom4, Custom5)  
            SELECT Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,MediaPath,MediaId,ImageName , BrandName, Custom1, Custom2, Custom3, Custom4, Custom5 
            FROM Cte_BrandDefaultLocale CTEBD;  
            
			-----Update BrandName from attributedefault value
			;WITH Cte_GetBrandNameLocale AS 
			 (
				select d.brandcode, a.AttributeDefaultValueCode, b.AttributeDefaultValue, b.LocaleId 
				from ZnodePimAttributeDefaultValue a
				inner join ZnodePimAttributeDefaultValueLocale b on a.PimAttributeDefaultValueId = b.PimAttributeDefaultValueId 
				inner join ZnodePimAttribute c on a.PimAttributeId = c.PimAttributeId
				inner join @TBL_BrandDetails d on a.AttributeDefaultValueCode = d.brandcode
				where c.attributecode = 'brand' and b.LocaleId IN(@LocaleId, @DefaultLocaleId)
              
             )
			 ,Cte_BrandNameFirstLocale AS 
			(
				SELECT brandcode, AttributeDefaultValueCode, AttributeDefaultValue, LocaleId  
                FROM Cte_GetBrandNameLocale CTGBBL  
                WHERE LocaleId = @LocaleId
			)
			,Cte_BrandDefaultLocale AS 
			(
				SELECT brandcode, AttributeDefaultValueCode, AttributeDefaultValue, LocaleId  
                FROM Cte_BrandNameFirstLocale  
                UNION ALL  
                SELECT brandcode, AttributeDefaultValueCode, AttributeDefaultValue, LocaleId  
				FROM Cte_GetBrandNameLocale CTBBL  
				WHERE LocaleId = @DefaultLocaleId  
				AND NOT EXISTS  
				(  
					SELECT TOP 1 1  
					FROM Cte_BrandNameFirstLocale CTBFL  
					WHERE CTBBL.brandcode = CTBFL.brandcode  
				)
			)  
			update b1 set b1.brandname = a1.AttributeDefaultValue
			from Cte_BrandDefaultLocale a1
			inner join @TBL_BrandDetails b1 on a1.brandcode = b1.brandcode
			     
     -- SET @SeoCode = SUBSTRING(  
     --                              (  
     --                                  SELECT ','+CAST(BrandCode AS VARCHAR(600))  
     --FROM @TBL_BrandDetails  
     --                                  FOR XML PATH('')  
     --                              ), 2, 8000);  

				DECLARE @SeoCode SelectColumnList
				INSERT INTO @SeoCode
				SELECT BrandCode FROM @TBL_BrandDetails

			
                  INSERT INTO @TBL_SeoDetails (CMSSEODetailId,SEOTitle,SEOKeywords,SEOURL,ModifiedDate,SEODescription,MetaInformation,IsRedirect,CMSSEODetailLocaleId,PublishStatus,SEOCode
				  ,CanonicalURL,RobotTag)  
                  EXEC Znode_GetSeoDetails
				  @SeoCode,  
                  'Brand',  
                  @LocaleId;  
                  
      SELECT TBBD.*,TBSD.*--,TBAD.AttributeDefaultValue BrandName,TBAD.AttributeDefaultValueCode  
      INTO #TM_BrandLocale  
      FROM @TBL_BrandDetails TBBD  
                  LEFT JOIN @TBL_SeoDetails TBSD ON(TBSD.SEOCode = TBBD.BrandCode)  
                  --INNER JOIN @TBL_AttributeDefault TBAD ON(TBAD.AttributeDefaultValueCode = TBBD.BrandCode);  
  

 

             SET @SQL = '   
             ;With Cte_BrandDetails AS   
    (  
     SELECT * ,'+[dbo].[Fn_GetPagingRowId](@Order_BY, 'BrandId DESC')+',Count(*)Over() CountId  
     FROM #TM_BrandLocale TMADV  
     WHERE 1=1  
     '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+'  
  
       )  
    SELECT Description  , BrandId , BrandCode , DisplayOrder  ,IsActive  ,WebsiteLink ,BrandDetailLocaleId   
         , MediaPath ,MediaId,ImageName ,CMSSEODetailId ,SEOTitle ,SEOKeywords , SEOURL   
         , ModifiedDate  ,  SEODescription   ,MetaInformation   ,IsRedirect ,CMSSEODetailLocaleId  
         ,BrandName ,RowId  ,CountId ,SEOCode,  Custom1, Custom2, Custom3, Custom4, Custom5   
    into #BrandDetailsPagination
	FROM Cte_BrandDetails  
    '+[dbo].[Fn_GetOrderByClause](@Order_BY, 'BrandId DESC')+' 
	
	SELECT Description  , BrandId , BrandCode , DisplayOrder  ,IsActive  ,WebsiteLink ,BrandDetailLocaleId   
         , MediaPath ,MediaId,ImageName ,CMSSEODetailId ,SEOTitle ,SEOKeywords , SEOURL   
         , ModifiedDate  ,  SEODescription   ,MetaInformation   ,IsRedirect ,CMSSEODetailLocaleId  
         ,BrandName ,RowId  ,CountId ,SEOCode,  Custom1, Custom2, Custom3, Custom4, Custom5
	from #BrandDetailsPagination'+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'BrandId DESC');  
  
  print @SQL
             INSERT INTO @TBL_BrandDetail  
             (  
    Description,BrandId,BrandCode,DisplayOrder,IsActive,WebsiteLink,  
    BrandDetailLocaleId,MediaPath,MediaId,ImageName,CMSSEODetailId,SEOTitle,  
    SEOKeywords,SEOURL,ModifiedDate,SEODescription,MetaInformation,IsRedirect,  
    CMSSEODetailLocaleId,BrandName,RowId,CountId ,SEOCode , Custom1, Custom2, Custom3, Custom4, Custom5   
    )  
             EXEC (@SQL);  
             SET @RowsCount = ISNULL(  
                                    (  
                                        SELECT TOP 1 CountId  
                                        FROM @TBL_BrandDetail  
                                    ), 0);  
             SELECT BrandId,Description,BrandCode,DisplayOrder,IsActive,WebsiteLink,BrandDetailLocaleId,MediaPath,MediaId,ImageName,CMSSEODetailId,SEOTitle,SEOKeywords,SEOURL SEOFriendlyPageName,SEODescription,MetaInformation,IsRedirect,CMSSEODetailLocaleId,BrandName,@PromotionId PromotionId   
             ,SEOCode,Custom1, Custom2, Custom3, Custom4, Custom5
			 FROM @TBL_BrandDetail;  
         END TRY  
         BEGIN CATCH  
            DECLARE @Status BIT ;  
       SET @Status = 0;  
       DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),   
    @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetBrandDetailsLocale @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@LocaleId = '+CAST(@LocaleId AS VARCHAR(50))
	+',@IsAssociated='+CAST(@IsAssociated AS VARCHAR(50))+',@PromotionId='+CAST(@PromotionId AS VARCHAR(50))+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
             EXEC Znode_InsertProcedureErrorLog  
    @ProcedureName = 'Znode_GetBrandDetailsLocale',  
    @ErrorInProcedure = @Error_procedure,  
    @ErrorMessage = @ErrorMessage,  
    @ErrorLine = @ErrorLine,  
    @ErrorCall = @ErrorCall;  
         END CATCH;  
     END;
	go
	
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Customer','GetImpersonationByUserId',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Customer' and ActionName = 'GetImpersonationByUserId')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationByUserId') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationByUserId'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationByUserId')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationByUserId'))

GO
if not exists(select * from sys.tables where name  = 'ZnodeSearchActivity')
begin
CREATE TABLE [dbo].[ZnodeSearchActivity] (
    [SearchActivityId]      INT            IDENTITY (1, 1) NOT NULL,
    [PortalId]              INT            NOT NULL,
    [UserId]                INT            NULL,
    [SearchProfileId]       INT            NULL,
    [SearchKeyword]         VARCHAR (2000) NOT NULL,
    [TransformationKeyword] VARCHAR (2000) NULL,
    [ResultCount]           INT            NULL,
    [CreatedBy]             INT            NOT NULL,
    [CreatedDate]           DATETIME       NOT NULL,
    [ModifiedBy]            INT            NOT NULL,
    [ModifiedDate]          DATETIME       NOT NULL,
    [UserProfileId]         INT            NULL,
    CONSTRAINT [PK_ZnodeSearchActivity] PRIMARY KEY CLUSTERED ([SearchActivityId] ASC),
    CONSTRAINT [FK_ZnodeSearchActivity_ZnodePortal] FOREIGN KEY ([PortalId]) REFERENCES [dbo].[ZnodePortal] ([PortalId]),
    CONSTRAINT [FK_ZnodeSearchActivity_ZnodeSearchProfile] FOREIGN KEY ([SearchProfileId]) REFERENCES [dbo].[ZnodeSearchProfile] ([SearchProfileId]),
    CONSTRAINT [FK_ZnodeSearchActivity_ZnodeUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[ZnodeUser] ([UserId])
);
end
go
if exists(select * from sys.procedures where name = 'Znode_GetKeywordSearchNoResultsFoundReport')
	drop proc Znode_GetKeywordSearchNoResultsFoundReport
go
  
CREATE procedure [dbo].[Znode_GetKeywordSearchNoResultsFoundReport] 
(
	@WhereClause    VARCHAR(max) = '',
	@Rows			INT           = 100,
	@PageNo			INT           = 1,
	@Order_By		VARCHAR(1000) = '',
	@RowCount		INT        = 0 OUT,
	@PortalId		VARCHAR(1000) = 0
)
/*
	exec [Znode_GetKeywordSearchNoResultsFoundReport] @PortalId = 1, @Rows = 1, @PageNo = 1, @Order_By = ''
	,@WhereClause='SearchKeyword=''Test'''
*/
as 
begin
	BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(MAX) = '',
	        @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');

	SET @SQL = '
	;with cte_SearchActivityData as
	(
		select ZSA.PortalId, ZSA.SearchKeyword, ZP.StoreName as PortalName, 0 AS ResultCount, 
		cast(cast(convert(date,ZSA.CreatedDate) as varchar(10))+'' ''+cast(DATEPART(hour, ZSA.CreatedDate) as varchar) + '':'' + cast(DATEPART(minute, ZSA.CreatedDate) as varchar) as datetime) as CreatedDate
		from ZnodeSearchActivity ZSA
		INNER JOIN ZnodePortal ZP ON ZSA.PortalId = ZP.PortalId
		WHERE ZSA.ResultCount = 0 AND ZSA.PortalId = '+CAST(@PortalId AS VARCHAR(10))+ ' 
		
	)
	,cte_SearchActivity_WhereClause as
	(
		select PortalId, SearchKeyword, PortalName, ResultCount, COUNT(1) AS  NumberOfSearches
		from cte_SearchActivityData
		where 1 = 1 '+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+' 
		GROUP By PortalId, SearchKeyword, PortalName, ResultCount
	)
	select PortalId, SearchKeyword, PortalName, NumberOfSearches, ResultCount
	into #SearchActivity_Filter
	from cte_SearchActivity_WhereClause
	
	select PortalId, SearchKeyword, PortalName, NumberOfSearches, ResultCount,
	       Row_Number()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'NumberOfSearches DESC, ResultCount DESC')+',NumberOfSearches DESC, ResultCount DESC) RowId
	into #SearchActivity_RowNumber
	from #SearchActivity_Filter

	SET @Count= ISNULL((SELECT  Count(1) FROM #SearchActivity_RowNumber ),0)
	
	select PortalId, SearchKeyword, PortalName, NumberOfSearches, ResultCount
	from #SearchActivity_RowNumber 
	'+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'NumberOfSearches DESC, ResultCount DESC');
	print @SQL
	EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;

	END TRY
    BEGIN CATCH
		DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetKeywordSearchNoResultsFoundReport @WhereClause='+cast(@WhereClause as varchar(max))+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50))+'
		@PortalId='+CAST(@PortalId AS VARCHAR(50));
		EXEC Znode_InsertProcedureErrorLog
		@ProcedureName    = 'Znode_GetKeywordSearchNoResultsFoundReport',
		@ErrorInProcedure = @ERROR_PROCEDURE,
		@ErrorMessage     = @ErrorMessage,
		@ErrorLine        = @ErrorLine,
		@ErrorCall        = @ErrorCall;
    END CATCH;

	

END
go

if exists(select * from sys.procedures where name = 'Znode_GetTopKeywordSearchResult')
	drop proc Znode_GetTopKeywordSearchResult
go
  
CREATE procedure [dbo].[Znode_GetTopKeywordSearchResult]
(
	@WhereClause    VARCHAR(max) = '',
	@Rows			INT           = 100,
	@PageNo			INT           = 1,
	@Order_By		VARCHAR(1000) = '',
	@RowCount		INT        = 0 OUT,
	@PortalId		VARCHAR(1000) = 0
)
/*
	exec Znode_GetTopKeywordSearchResult @PortalId = 1, @Rows = 10, @PageNo = 1, @Order_By = ''
	,@WhereClause='SearchKeyword=''Test'''
*/
as 
begin
	BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(MAX) = '',
	        @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');

	SET @SQL = '
	;with cte_SearchActivityData as
	(
		select ZSA.PortalId, ZSA.SearchKeyword, ZP.StoreName as PortalName, 
		cast(cast(convert(date,ZSA.CreatedDate) as varchar(10))+'' ''+cast(DATEPART(hour, ZSA.CreatedDate) as varchar) + '':'' + cast(DATEPART(minute, ZSA.CreatedDate) as varchar) as datetime) as CreatedDate,
		ZSA.CreatedDate as CreatedDate1
		from ZnodeSearchActivity ZSA
		INNER JOIN ZnodePortal ZP ON ZSA.PortalId = ZP.PortalId
		WHERE ZSA.ResultCount > 0 AND ZSA.PortalId = '+CAST(@PortalId AS VARCHAR(10))+ '  
	)
	,cte_SearchActivity_WhereClause as
	(
		select PortalId, SearchKeyword, PortalName, COUNT(1) AS  NumberOfSearches, max(CreatedDate1) as CreatedDate
		from cte_SearchActivityData
		WHERE 1 = 1 '+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+' 
		GROUP By PortalId, SearchKeyword, PortalName
	)
	,cte_SearchActivity_ResultCount as
	(
		select SNS.PortalId, SNS.SearchKeyword, SNS.PortalName, SNS.NumberOfSearches, max(ZSA.ResultCount) as ResultCount
		from ZnodeSearchActivity ZSA
		inner join cte_SearchActivity_WhereClause SNS on ZSA.SearchKeyword = SNS.SearchKeyword 
			and ZSA.CreatedDate = SNS.CreatedDate and ZSA.PortalId = SNS.PortalId
		where ZSA.ResultCount > 0
		group by SNS.PortalId, SNS.SearchKeyword, SNS.PortalName, SNS.NumberOfSearches
	)
	select PortalId, SearchKeyword, PortalName, NumberOfSearches, ResultCount
	into #SearchActivity_Filter
	from cte_SearchActivity_ResultCount
	
	select PortalId, SearchKeyword, PortalName, NumberOfSearches, ResultCount,
	       Row_Number()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'NumberOfSearches DESC, ResultCount DESC')+',NumberOfSearches DESC, ResultCount DESC) RowId
	into #SearchActivity_RowNumber
	from #SearchActivity_Filter
	where NumberOfSearches>0

	SET @Count= ISNULL((SELECT  Count(1) FROM #SearchActivity_RowNumber ),0)
	
	select PortalId, SearchKeyword, PortalName, NumberOfSearches, ResultCount
	from #SearchActivity_RowNumber 
	'+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'NumberOfSearches DESC, ResultCount DESC');
	print @SQL
	EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;

	END TRY
    BEGIN CATCH
		DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetTopKeywordSearchResult @WhereClause='+cast(@WhereClause as varchar(max))+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50))+'
		@PortalId='+CAST(@PortalId AS VARCHAR(50));
		EXEC Znode_InsertProcedureErrorLog
		@ProcedureName    = 'Znode_GetTopKeywordSearchResult',
		@ErrorInProcedure = @ERROR_PROCEDURE,
		@ErrorMessage     = @ErrorMessage,
		@ErrorLine        = @ErrorLine,
		@ErrorCall        = @ErrorCall;
    END CATCH;

	

END
go
insert into ZnodeApplicationSetting(GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'Table', 'SearchNoResultsFoundReport','<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>SearchKeyword</name><headertext>Search Query</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>50</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>PortalName</name><headertext>Portal Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>NumberOfSearches</name><headertext>Searches</headertext><width>30</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>',
'SearchNoResultsFoundReport','SearchNoResultsFoundReport','SearchNoResultsFoundReport',1,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where ItemName = 'SearchNoResultsFoundReport')

insert into ZnodeApplicationSetting(GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'Table', 'SearchTopKeywordsReport','<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>SearchKeyword</name><headertext>Search Query</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>50</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>PortalName</name><headertext>Portal Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>NumberOfSearches</name><headertext>Searches</headertext><width>30</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>ResultCount</name><headertext>Results</headertext><width>30</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>',
'SearchTopKeywordsReport','SearchTopKeywordsReport','SearchTopKeywordsReport',1,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where ItemName = 'SearchTopKeywordsReport')

go

update ZnodeMenu set AreaName = 'Search', ControllerName = 'SearchReport', ActionName = 'GetTabStructureSearchReport'
where MenuName = 'Site Search'

insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'SearchReport','GetTabStructureSearchReport',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'SearchReport' and ActionName = 'GetTabStructureSearchReport')
 

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy	,CreatedDate,	ModifiedBy,	ModifiedDate )
select 
	   (select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport')	
      ,(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTabStructureSearchReport')	,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
       (select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport') and ActionId = 
       (select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTabStructureSearchReport'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy	,CreatedDate,	ModifiedBy,	ModifiedDate )
select 
(select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport'),
(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTabStructureSearchReport')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport')	 and ActionId = 
(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTabStructureSearchReport'))


---------------------------------------------------------
insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'SearchReport','GetTopKeywordsReport',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'SearchReport' and ActionName = 'GetTopKeywordsReport')
 

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy	,CreatedDate,	ModifiedBy,	ModifiedDate )
select 
	   (select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport')	
      ,(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTopKeywordsReport')	,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
       (select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport') and ActionId = 
       (select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTopKeywordsReport'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy	,CreatedDate,	ModifiedBy,	ModifiedDate )
select 
(select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport'),
(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTopKeywordsReport')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport') and ActionId = 
(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetTopKeywordsReport'))

---------------------------------------------------------------
insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'SearchReport','GetNoResultsFoundReport',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'SearchReport' and ActionName = 'GetNoResultsFoundReport')
 

insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy	,CreatedDate,	ModifiedBy,	ModifiedDate )
select 
	   (select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport')	
      ,(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetNoResultsFoundReport')	,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
       (select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport') and ActionId = 
       (select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetNoResultsFoundReport'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy	,CreatedDate,	ModifiedBy,	ModifiedDate )
select 
(select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport'),
(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetNoResultsFoundReport')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select MenuId from ZnodeMenu where MenuName = 'Site Search' AND ControllerName = 'SearchReport') and ActionId = 
(select ActionId from ZnodeActions where ControllerName = 'SearchReport' and ActionName= 'GetNoResultsFoundReport'))
----------------
go

if exists(select * from sys.procedures where name = 'Znode_GetSearchProfileDetails')
	drop proc Znode_GetSearchProfileDetails
go
  

CREATE PROCEDURE [dbo].[Znode_GetSearchProfileDetails]
(
	@SearchProfileId int 
)
AS 
/*
	 Summary :- This Procedure is used to get the publish status of the catalog 
	 Unit Testig 
	 EXEC  Znode_GetCatalogList '',100,1,'',0
*/
   BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 

		   Declare @SearchQueryTypeId int 

				Select @SearchQueryTypeId=SearchQueryTypeId 
				from ZnodeSearchProfile
				Where  SearchProfileId=@SearchProfileId	

				Exec [dbo].[Znode_GetSearchQueryTypeWiseFeatureDetails] @SearchProfileId=@SearchProfileId,@SearchQueryTypeId=@SearchQueryTypeId
						

				Select b.SearchProfileId,b.AttributeCode,b.BoostValue,b.IsUseInSearch,b.IsFacets
				from ZnodeSearchProfileAttributeMapping b
				Where  b.SearchProfileId=@SearchProfileId AND IsUseInSearch=1

				Select b.SearchProfileId,b.AttributeCode,b.BoostValue,b.IsFacets,b.IsUseInSearch
				from ZnodeSearchProfileAttributeMapping b
				Where  b.SearchProfileId=@SearchProfileId AND IsFacets=1

				Select b.SearchQueryTypeId , b.SearchQueryTypeId ,b.ProfileName,b.Operator,
				c.QueryTypeName,c.QueryBuilderClassName,
				b.SearchSubQueryTypeId,d.QueryTypeName SubQueryTypeName,d.QueryBuilderClassName SubQueryBuilderClassName,
				pc.PublishCatalogId,pc.CatalogName, b.SearchProfileId
				from  ZnodeSearchProfile B 
				left join dbo.ZnodePublishCatalogSearchProfile cc on cc.SearchProfileId=b.SearchProfileId
				left join dbo.ZnodePublishCatalog pc on pc.PublishCatalogId=cc.PublishCatalogId
				inner join ZnodeSearchQueryType C on b.SearchQueryTypeId=C.SearchQueryTypeId 
				Left join ZnodeSearchQueryType d on  d.SearchQueryTypeId =b.SearchSubQueryTypeId
				Where  b.SearchProfileId=@SearchProfileId	 

				select pfv.FieldName,pfv.FieldValueFactor 
				from ZnodeSearchProfileFieldValueFactor pfv
				WHERE pfv.SearchProfileId = @SearchProfileId

		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			@ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)
	--		= 'EXEC Znode_GetCatalogList @WhereClause = '+@WhereClause+',@Rows='+CAST(@Rows AS
 --VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znode_GetZnodeSearchProfileList',
					@ErrorInProcedure = @Error_procedure,
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END
   go
   update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>SearchKeyword</name><headertext>Search Query</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>50</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>PortalName</name><headertext>Portal Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>NumberOfSearches</name><headertext>Searches</headertext><width>30</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
where  ItemName = 'SearchNoResultsFoundReport'

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>SearchKeyword</name><headertext>Search Query</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>50</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>PortalName</name><headertext>Portal Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>NumberOfSearches</name><headertext>Searches</headertext><width>30</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>ResultCount</name><headertext>Results</headertext><width>30</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
where  ItemName = 'SearchTopKeywordsReport'
go

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>SearchKeyword</name>      <headertext>Search Query</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>50</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PortalName</name>      <headertext>Store Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>NumberOfSearches</name>      <headertext>Searches</headertext>      <width>30</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where  ItemName = 'SearchNoResultsFoundReport'

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>SearchKeyword</name>      <headertext>Search Query</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PortalName</name>      <headertext>Store Name</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>NumberOfSearches</name>      <headertext>Searches</headertext>      <width>30</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ResultCount</name>      <headertext>Number Of Results</headertext>      <width>30</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where  ItemName = 'SearchTopKeywordsReport'
go
if not exists(select * from INFORMATION_SCHEMA.columns where TABLE_NAME = 'ZnodeUserWishList' and COLUMN_NAME = 'PortalId')
begin
	ALTER TABLE ZnodeUserWishList ADD [PortalId] INT NULL
end
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Customer','GetImpersonationUrl',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Customer' and ActionName = 'GetImpersonationUrl')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl'))

GO

--dt ZPD-8727 --> ZPD-8683
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Customer','GetImpersonationUrl',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Customer' and ActionName = 'GetImpersonationUrl')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetImpersonationUrl'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdatePaymentStatus',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdatePaymentStatus')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdatePaymentStatus') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdatePaymentStatus'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdatePaymentStatus')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdatePaymentStatus'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdateShippingHandling',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdateShippingHandling')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingHandling') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingHandling'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingHandling')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingHandling'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdateDiscount',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdateDiscount')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateDiscount') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateDiscount'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateDiscount')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateDiscount'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetAdditionalNotes',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetAdditionalNotes')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAdditionalNotes') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAdditionalNotes'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAdditionalNotes')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetAdditionalNotes'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetOrderDetails',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetOrderDetails')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetOrderDetails') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetOrderDetails'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetOrderDetails')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetOrderDetails'))

GO



Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetPaymentMethods',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetPaymentMethods')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetPaymentMethods') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetPaymentMethods'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetPaymentMethods')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetPaymentMethods'))

GO

--dt 21-01-2020 ZPD-8812
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','AddToCartProduct',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'AddToCartProduct')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct'))



insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'AddToCartProduct'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','GetShoppingCartItems',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'GetShoppingCartItems')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems'))



insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'GetShoppingCartItems'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','CalculateShoppingCart',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'CalculateShoppingCart')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart'))



insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'CalculateShoppingCart'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','RemoveCartItem',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'RemoveCartItem')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem'))



insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveCartItem'))

GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdateTaxExemptOnCreateOrder',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdateTaxExemptOnCreateOrder')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder'))



insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder')	
,3,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	 and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateTaxExemptOnCreateOrder'))

GO
if exists(select * from sys.procedures where name = 'Znode_GetPublishSingleProduct')
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
							, (SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodePortalDisplaySetting TYR WHERE TYR.PortalId = TY.PortalId)
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
	where exists(select * from ZnodePimFrontendProperties ZPFP where ZPAV_Parent.PimAttributeId = ZPFP.PimAttributeId and ZPFP.IsFacets = 1)
	and exists(select * from #TBL_PublishCatalogId ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )

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
SELECT ZPLP.PimParentProductId ,c.AttributeCode, '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50)) 
							 FROM ZnodePublishProduct ZPPI 
							 INNER JOIN ZnodePimLinkProductDetail ZPLPI ON (ZPLPI.PimProductId = ZPPI.PimProductId)
							 WHERE ZPLPI.PimParentProductId = ZPLP.PimParentProductId
							 AND ZPLPI.PimAttributeId   = ZPLP.PimAttributeId
							 AND ZPPI.PublishCatalogId = ZPP.PublishCatalogId
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
+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
FROM ZnodeProfileCatalog ZPFC 
INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+'</TempProfileIds><ProductIndex>'+CAST(ISNULL(ZPCP.ProductIndex,1)  AS VARCHAr(100))+'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
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
	LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId)
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
if exists(select * from sys.procedures where name = 'Znode_InsertUpdatePimCatalogProductDetail')
	drop proc Znode_InsertUpdatePimCatalogProductDetail
go
  

CREATE PROCEDURE [dbo].[Znode_InsertUpdatePimCatalogProductDetail] 
(
  @PublishCatalogId INT = 0 
  ,@LocaleId TransferId READONLY 
  ,@UserId INT = 0   
)
AS 
--declare @LocaleId TransferId
--insert into @LocaleId
--select 1
--exec [Znode_InsertUpdatePimCatalogProductDetail] @PublishCatalogId=7,@LocaleId=@LocaleId,@UserId=2
BEGIN 
 BEGIN TRY 

  SET NOCOUNT ON 
       DECLARE @LocaleId_In INT = 0 , @DefaultLocaleId INT = dbo.FN_GETDefaultLocaleId()
			   ,@Date DATETIME = dbo.fn_GetDate()
	   DECLARE @PimMediaAttributeId INT = dbo.Fn_GetProductImageAttributeId()		   

	   CREATE TABLE #PimDefaultValueLocale  (PimAttributeDefaultXMLId INT  PRIMARY KEY ,PimAttributeDefaultValueId INT ,LocaleId INT, DefaultValueXML	nvarchar(max) )

	   CREATE TABLE #AttributeValueLocale  ( ID Int Identity Primary Key,PimProductId int, AttributeCode Varchar(300), AttributeValue varchar(max), AttributeEntity varchar(max), LocaleId int )

		SELECT BTM.PimProductId , ZPCPD.PublishProductId, ZPCPD.PublishCatalogId,BTM.ModifiedDate
		into #ProductAttributeXML
		FROM ZnodePublishProductAttributeXML BTM 
		inner join ZnodePublishProduct ZPP1 ON BTM.PimProductId = ZPP1.PimProductId
		inner join ZnodePublishCatalogProductDetail ZPCPD ON ZPP1.PublishProductId = ZPCPD.PublishProductId AND ZPCPD.PublishCatalogId = ZPP1.PublishCatalogId 
		WHERE ZPCPD.PublishCatalogId =  @PublishCatalogId 

	    -------- Products Attribute modified 
		SELECT DISTINCT ZPCC.PublishProductId,  ZPCC.PimCategoryHierarchyId 
		Into #ModifiedProducts
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = ZPP.PimProductId )
		INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND EXISTS(SELECT * FROM ZnodePimFamilyGroupMapper ZPFGM WHERE (ZPFGM.PimAttributeFamilyId = ZPPI.PimAttributeFamilyId AND ZPFGM.PimAttributeId = ZPAV.PimAttributeId))
		AND EXISTS (SELECT TOP 1 1 FROM #ProductAttributeXML BTM WHERE BTM.PimProductId = ZPP.PimProductId AND BTM.PublishCatalogId = ZPP.PublishCatalogId
						AND (BTM.ModifiedDate < ZPAV.ModifiedDate OR BTM.ModifiedDate < ZPA.ModifiedDate)   ) 
		
		-------- Products not published  
		Insert Into #ModifiedProducts
		SELECT ZPCC.PublishProductId,  ZPCC.PimCategoryHierarchyId 
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND EXISTS(SELECT * FROM ZnodePimFamilyGroupMapper ZPFGM WHERE (ZPFGM.PimAttributeFamilyId = ZPPI.PimAttributeFamilyId ))--AND ZPFGM.PimAttributeId = ZPAV.PimAttributeId))
		AND exists(select * from ZnodePimProduct ZPP1 INNER JOIN ZnodePublishState ZPS ON ZPP1.PublishStateId = ZPS.PublishStateId
					where StateName <> 'Publish' and ZPP.PimProductId = ZPP1.PimProductId )	
			
		-------- Products associated to catalog or category or modified catalog category products
		Insert Into #ModifiedProducts		
		SELECT ZPCC.PublishProductId,  ZPCC.PimCategoryHierarchyId 
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		INNER JOIN ZnodePimCatalogCategory ZPCC1 ON ZPC.PimCatalogId = ZPCC1.PimCatalogId AND ZPP.PimProductId = ZPCC1.PimProductId 
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND EXISTS(SELECT * FROM ZnodePimFamilyGroupMapper ZPFGM WHERE (ZPFGM.PimAttributeFamilyId = ZPPI.PimAttributeFamilyId ))--AND ZPFGM.PimAttributeId = ZPAV.PimAttributeId))
		AND EXISTS (SELECT TOP 1 1 FROM #ProductAttributeXML BTM WHERE BTM.PimProductId = ZPCC1.PimProductId AND BTM.PublishCatalogId = ZPP.PublishCatalogId
						AND (BTM.ModifiedDate < ZPCC1.ModifiedDate )   )	 

		-------- Link Product modified 
		Insert Into #ModifiedProducts	
		SELECT ZPCC.PublishProductId,  ZPCC.PimCategoryHierarchyId 
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePimLinkProductDetail ZPAV ON (ZPAV.PimParentProductId = ZPP.PimProductId )
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		--AND EXISTS(SELECT * FROM ZnodePimFamilyGroupMapper ZPFGM WHERE (ZPFGM.PimAttributeFamilyId = ZPPI.PimAttributeFamilyId AND ZPFGM.PimAttributeId = ZPAV.PimAttributeId))
		AND EXISTS (SELECT TOP 1 1 FROM #ProductAttributeXML BTM WHERE BTM.PimProductId = ZPP.PimProductId AND BTM.PublishCatalogId = ZPP.PublishCatalogId
						AND (BTM.ModifiedDate < ZPAV.ModifiedDate)   ) 

		--------Associated child Products (varients, Group) not published	
		Insert Into #ModifiedProducts	
		SELECT ZPCC.PublishProductId,  ZPCC.PimCategoryHierarchyId 
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePimProductTypeAssociation ZPAV ON (ZPAV.PimProductId = ZPP.PimProductId )
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND exists(select * from ZnodePimProduct ZPP1 INNER JOIN ZnodePublishState ZPS ON ZPP1.PublishStateId = ZPS.PublishStateId
					where StateName <> 'Publish' and ZPAV.PimProductId = ZPP1.PimProductId )

		--------Link child Products (Bundle) not published 	
		Insert Into #ModifiedProducts
		SELECT ZPCC.PublishProductId,  ZPCC.PimCategoryHierarchyId 
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePimLinkProductDetail ZPAV ON (ZPAV.PimProductId = ZPP.PimProductId )
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND exists(select * from ZnodePimProduct ZPP1 INNER JOIN ZnodePublishState ZPS ON ZPP1.PublishStateId = ZPS.PublishStateId
					where StateName <> 'Publish' and ZPAV.PimProductId = ZPP1.PimProductId )

		--Getting all products of catalog for publish first time 
		SELECT ZPCC.PublishProductId,  ZPAV.PimAttributeId, ZPCC.PublishCatalogId , ZPCC.PimCategoryHierarchyId , ZPCC.PublishCategoryId,
		       ZPAV.PimAttributeValueId, ZPC.CatalogName ,ZPP.PimProductId ,ZPA.AttributeCode				
		INTO #ZnodePublishCategoryProduct
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = ZPP.PimProductId )
		INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (isnull(ZPPC.PimCategoryHierarchyId,0) = isnull(ZPCC.PimCategoryHierarchyId,0) AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND EXISTS(SELECT * FROM ZnodePimFamilyGroupMapper ZPFGM WHERE (ZPFGM.PimAttributeFamilyId = ZPPI.PimAttributeFamilyId AND ZPFGM.PimAttributeId = ZPAV.PimAttributeId))
		AND NOT EXISTS (SELECT TOP 1 1 FROM #ProductAttributeXML BTM WHERE BTM.PimProductId = ZPP.PimProductId AND BTM.PublishCatalogId = ZPP.PublishCatalogId)
		
		--Getting all products of catalog for publish which are modified after last publish
		INSERT INTO #ZnodePublishCategoryProduct 
		SELECT ZPCC.PublishProductId,  ZPAV.PimAttributeId, ZPCC.PublishCatalogId , ZPCC.PimCategoryHierarchyId , ZPCC.PublishCategoryId
			   ,ZPAV.PimAttributeValueId, ZPC.CatalogName--,CASE WHEN ZPCC.PublishProductId IS NULL THEN 1 ELSE  dense_rank()Over(ORDER BY ZPCC.PimCategoryHierarchyId,ZPCC.PublishProductId) END  ProductIndex 	
			   ,ZPP.PimProductId ,ZPA.AttributeCode				
		FROM ZnodePublishProduct  ZPP
		INNER JOIN ZnodePimProduct ZPPI ON (ZPPI.PimProductId = ZPP.PimProductId)
		INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimProductId = ZPP.PimProductId )
		INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = ZPAV.PimAttributeId)
		INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategoryProduct ZPCC  ON (ZPP.PublishProductId = ZPCC.PublishProductId AND ZPCC.PublishCatalogId = ZPP.PublishCatalogId)
		LEFT  JOIN ZnodePublishCategory ZPPC ON (ZPPC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId AND ZPPC.PublishCategoryId = ZPCC.PublishCategoryId)
		WHERE ZPP.PublishCatalogId =  @PublishCatalogId 
		AND EXISTS(SELECT * FROM ZnodePimFamilyGroupMapper ZPFGM WHERE (ZPFGM.PimAttributeFamilyId = ZPPI.PimAttributeFamilyId AND ZPFGM.PimAttributeId = ZPAV.PimAttributeId))
		AND EXISTS (SELECT * from #ModifiedProducts MP where ZPCC.PublishProductId = MP.PublishProductId AND isnull(ZPCC.PimCategoryHierarchyId,0) = isnull(MP.PimCategoryHierarchyId,0)) 

		CREATE INDEX IDX_#ZnodePublishCategoryProduct_PimProductId ON #ZnodePublishCategoryProduct(PimProductId)
		CREATE INDEX IDX_#ZnodePublishCategoryProduct_PublishCategoryId ON #ZnodePublishCategoryProduct(PublishCategoryId)

		CREATE INDEX IDX_#ZnodePublishCategoryProduct_PimAttributeValueId ON #ZnodePublishCategoryProduct(PimAttributeValueId)
		CREATE INDEX IDX_#ZnodePublishCategoryProduct_PimAttributeId ON #ZnodePublishCategoryProduct(PimAttributeId)
		 
		 ----Getting products link product value entity
	     INSERT INTO #AttributeValueLocale ( PimProductId, AttributeCode, AttributeValue, AttributeEntity, LocaleId )
	     SELECT ZPLP.PimParentProductId ,ZPAX.AttributeCode, '' AttributeValue , ZPAX.AttributeXML+'<AttributeValues>' + 
		 stuff( (SELECT ','+cast(ZPP.PublishProductId as varchar(10))
							FROM ZnodePimLinkProductDetail ZPLPD 
							INNER JOIN ZnodePublishProduct ZPP ON (ZPP.PimProductId = ZPLPD.PimProductId)
							WHERE ZPLPD.PimParentProductId = ZPLP.PimParentProductId and ZPP.PublishCatalogId = @PublishCatalogId
							AND ZPLPD.PimAttributeId = ZPLP.PimAttributeId
							FOR XML PATH ('')), 1, 1, '')  +'</AttributeValues>', ZPAX.LocaleId
		 FROM ZnodePimLinkProductDetail ZPLP
		 INNER JOIN ZnodePimAttributeXML ZPAX ON (ZPAX.PimAttributeId = ZPLP.PimAttributeId )
		 WHERE EXISTS(SELECT * FROM #ZnodePublishCategoryProduct PPCP  WHERE (ZPLP.PimParentProductId = PPCP.PimProductId ))
		 GROUP BY ZPLP.PimParentProductId ,ZPAX.AttributeCode , ZPAX.AttributeXML,ZPAX.LocaleId,ZPAX.AttributeCode,ZPLP.PimAttributeId

	   --DECLARE  CR_Locale_id CURSOR FOR 
	   --SELECT Id 
	   --FROM @LocaleId
	   --ORDER BY Id ASC

	   --OPEN CR_Locale_id  
	   --FETCH NEXT FROM CR_Locale_id INTO @LocaleId_In

	   --WHILE @@FETCH_STATUS = 0  
	   --BEGIN 
		  ----Getting product attribute value entity
	      INSERT INTO #AttributeValueLocale ( PimProductId, AttributeCode, AttributeValue, AttributeEntity, LocaleId )
		  SELECT PPCP.PimProductId , ZPA.AttributeCode,ZPAVL.AttributeValue ,
		         ZPAX.AttributeXML + '<AttributeValues>'+(select ''+ISNULL(ZPAVL.AttributeValue,'') FOR XML PATH (''))+'</AttributeValues>'  AttributeEntity, ZPAVL.LocaleId
		  FROM ZnodePimAttributeValue PPCP
		  INNER JOIN ZnodePimAttribute ZPA ON (ZPA.PimAttributeId = PPCP.PimAttributeId)
		  INNER JOIN ZnodePimAttributeValueLocale ZPAVL ON (PPCP.PimAttributeValueId =ZPAVL.PimAttributeValueId)
		  INNER JOIN ZnodePimAttributeXML ZPAX ON (ZPAX.PimAttributeId = ZPA.PimAttributeId and ZPAX.LocaleId = ZPAVL.LocaleId)
		  WHERE --ZPAVL.LocaleId = @LocaleId_In AND
		  EXISTS(SELECT * FROM #ZnodePublishCategoryProduct PPCP1  WHERE PPCP1.PimProductId = PPCP.PimProductId)--(PPCP1.PimAttributeValueId =PPCP.PimAttributeValueId) AND (ZPA.PimAttributeId = PPCP1.PimAttributeId))
		  AND not exists(select * from #AttributeValueLocale AVL where PPCP.PimProductId = AVL.PimProductId and ZPA.AttributeCode = AVL.AttributeCode and ZPAVL.LocaleId = AVL.LocaleId )
		  and not exists(select * from ZnodePimConfigureProductAttribute UOP where ZPAX.PimAttributeId = UOP.PimAttributeId and PPCP.PimProductId = UOP.PimProductId )
		  --group by PPCP.PimProductId , ZPA.AttributeCode,ZPAVL.AttributeValue , ZPAX.AttributeXML

		  IF OBJECT_ID('TEMPDB..#ZnodePublishCatalogProductDetail') IS NOT NULL
			DROP TABLE #ZnodePublishCatalogProductDetail

		  IF OBJECT_ID('TEMPDB..#ZnodePublishCatalogProductDetail1') IS NOT NULL
			DROP TABLE #ZnodePublishCatalogProductDetail1

		  IF OBJECT_ID('TEMPDB..#TBL_ProductRequiredAttribute') IS NOT NULL
			DROP TABLE #TBL_ProductRequiredAttribute
		  			
		  --SELECT PIV.PimProductId,max(PIV.SKU) as SKU, max(PIV.ProductName) as ProductName,max(PIV.IsActive ) as IsActive
		  --INTO #TBL_ProductRequiredAttribute
		  --FROM #AttributeValueLocale 
		  --PIVOT 
		  --(
		  -- Max(AttributeValue) FOR AttributeCode IN (SKU, ProductName,IsActive)
		  --) PIV 
		  --group by PIV.PimProductId 

		  
		create table #TBL_ProductRequiredAttribute (PimProductId int,SKU varchar(600),ProductName varchar(600), IsActive varchar(10), LocaleId INT)

		insert into #TBL_ProductRequiredAttribute(PimProductId, LocaleId)
		select distinct PimProductId, LocaleId from #AttributeValueLocale

		update #TBL_ProductRequiredAttribute 
		set SKU = b.AttributeValue
		from #TBL_ProductRequiredAttribute a
		inner join #AttributeValueLocale b on a.PimproductId = b.PimProductId AND a.LocaleId = b.LocaleId
		where b.AttributeCode = 'SKU'

		update #TBL_ProductRequiredAttribute 
		set ProductName = b.AttributeValue
		from #TBL_ProductRequiredAttribute a
		inner join #AttributeValueLocale b on a.PimproductId = b.PimProductId AND a.LocaleId = b.LocaleId
		where b.AttributeCode = 'ProductName'

		update #TBL_ProductRequiredAttribute 
		set IsActive = b.AttributeValue
		from #TBL_ProductRequiredAttribute a
		inner join #AttributeValueLocale b on a.PimproductId = b.PimProductId AND a.LocaleId = b.LocaleId
		where b.AttributeCode = 'IsActive'

		  CREATE INDEX IDX_#TBL_ProductRequiredAttribute_PimProductId ON #TBL_ProductRequiredAttribute(PimProductId)

		  SELECT ZPI.PublishProductId, ZPI.PublishCatalogId ,TYU.PublishCategoryId,ZPI.CatalogName,ISNULL(ZPI.PimCategoryHierarchyId,0) PimCategoryHierarchyId
					,TPAR.SKU,TPAR.ProductName,TPAR.IsActive,TYU.PublishCategoryName CategoryName,TPAR.LocaleId
		   into #ZnodePublishCatalogProductDetail
		   FROM #ZnodePublishCategoryProduct ZPI
		   INNER JOIN #TBL_ProductRequiredAttribute TPAR ON (TPAR.PimProductId = ZPI.PimProductId )
		   LEFT JOIN ZnodePublishCategoryDetail TYU ON (TYU.PublishCategoryId = ZPI.PublishCategoryId)
		   --where TPAR.LocaleId = @LocaleId_In
		   GROUP BY PublishProductId, PublishCatalogId ,TYU.PublishCategoryId,CatalogName,PimCategoryHierarchyId
					,SKU,ProductName,TPAR.IsActive,PublishCategoryName, TPAR.LocaleId  

						
			CREATE INDEX IDX_#ZnodePublishCatalogProductDetail ON #ZnodePublishCatalogProductDetail(PublishProductId,PublishCatalogId,PimCategoryHierarchyId,LocaleId)

			SELECT PublishProductId,PublishCatalogId,PimCategoryHierarchyId,SKU,ProductName,CategoryName, CatalogName, LocaleId ,IsActive
			      ,CASE WHEN PublishProductId IS NULL THEN 1 ELSE Row_Number()Over(Partition by PublishProductId ORDER BY PublishProductId,PimCategoryHierarchyId) END  ProductIndex
			INTO #ZnodePublishCatalogProductDetail1
			from #ZnodePublishCatalogProductDetail
			--where LocaleId = @LocaleId_In			

			----Update data ZnodePublishCatalogProductDetail 
			UPDATE TARGET
			SET  TARGET.SKU			    =SOURCE.SKU
				,TARGET.ProductName		=SOURCE.ProductName
				,TARGET.CategoryName	=SOURCE.CategoryName
				,TARGET.CatalogName		=SOURCE.CatalogName
				,TARGET.IsActive		=case when SOURCE.IsActive in ('0','false') then 0 else 1 end 
				,TARGET.ProductIndex	=SOURCE.ProductIndex
				,TARGET.ModifiedBy		= @UserId	
				,TARGET.ModifiedDate	= @Date
			from ZnodePublishCatalogProductDetail TARGET
			INNER JOIN #ZnodePublishCatalogProductDetail1 SOURCE
			ON (
		        SOURCE.PublishProductId = TARGET.PublishProductId
				AND SOURCE.PublishCatalogId = TARGET.PublishCatalogId 
				AND isnull(SOURCE.PimCategoryHierarchyId,0) = isnull(TARGET.PimCategoryHierarchyId,0)
				AND SOURCE.LocaleId = TARGET.LocaleId --@LocaleId_In
				)

			----Insert data ZnodePublishCatalogProductDetail 
			INSERT INTO ZnodePublishCatalogProductDetail
				( PublishProductId,PublishCatalogId,PimCategoryHierarchyId,SKU,ProductName,CategoryName, CatalogName,
				  LocaleId ,IsActive,ProductIndex,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate )
			SELECT SOURCE.PublishProductId ,SOURCE.PublishCatalogId ,SOURCE.PimCategoryHierarchyId ,SOURCE.SKU ,SOURCE.ProductName
			,SOURCE.CategoryName ,SOURCE.CatalogName ,SOURCE.LocaleId ,SOURCE.IsActive ,SOURCE.ProductIndex ,@UserId ,@Date ,@UserId ,@Date
			FROM #ZnodePublishCatalogProductDetail1 SOURCE
			WHERE NOT EXISTS(SELECT * FROM ZnodePublishCatalogProductDetail TARGET WHERE SOURCE.PublishProductId = TARGET.PublishProductId
							AND SOURCE.PublishCatalogId = TARGET.PublishCatalogId 
							AND SOURCE.PimCategoryHierarchyId = TARGET.PimCategoryHierarchyId 
							AND TARGET.LocaleId = SOURCE.LocaleId )
							  
		 
	   -- FETCH NEXT FROM CR_Locale_id INTO @LocaleId_In
	   --END    
	   
	   --CLOSE CR_Locale_id  
	   --DEALLOCATE CR_Locale_id 

		  select a.PimProductId,  a.PimAttributeId
		  into #PimProductAttributeDefaultValue
		  from ZnodePimAttributeValue a 
		  Inner join ZnodePimProductAttributeDefaultValue b on a.PimAttributeValueId = b.PimAttributeValueId 

		  create index Idx_#PimProductAttributeDefaultValue on #PimProductAttributeDefaultValue (PimProductId,PimAttributeId)

		  INSERT INTO #PimDefaultValueLocale
		  SELECT PimAttributeDefaultXMLId,PimAttributeDefaultValueId,LocaleId ,DefaultValueXML
		  FROM ZnodePimAttributeDefaultXML

		  SELECT  AA.DefaultValueXML , ZPADV.PimAttributeValueId, AA.LocaleId 
		  into #PimAttributeDefaultXML
		  FROM ZnodePimAttributeDefaultXML AA 
		  INNER JOIN #PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = AA.PimAttributeDefaultXMLId AND AA.LocaleId = GH.LocaleId)
		  INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId AND AA.LocaleId = ZPADV.LocaleId)

		  ----Getting child facets for merging		  
		  Select distinct ZPPADV.PimAttributeDefaultValueId, ZPAV_Parent.PimAttributeValueId, ZPPADV.LocaleId
		  Into #PimChildProductFacets
		  from ZnodePimAttributeValue ZPAV_Parent
		  inner join ZnodePimProductTypeAssociation ZPPTA ON ZPAV_Parent.PimProductId = ZPPTA.PimParentProductId
		  inner join ZnodePimAttributeValue ZPAV_Child ON ZPPTA.PimProductId = ZPAV_Child.PimProductId AND ZPAV_Parent.PimAttributeId = ZPAV_Child.PimAttributeId
		  inner join ZnodePimProductAttributeDefaultValue ZPPADV ON ZPAV_Child.PimAttributeValueId = ZPPADV.PimAttributeValueId 
		  where exists(select * from ZnodePimFrontendProperties ZPFP where ZPAV_Parent.PimAttributeId = ZPFP.PimAttributeId and ZPFP.IsFacets = 1)
		  and exists(select * from #ZnodePublishCategoryProduct ZPPC where ZPAV_Parent.PimProductId = ZPPC.PimProductId )
		  and not exists(select * from ZnodePimProductAttributeDefaultValue ZPPADV1 where ZPAV_Parent.PimAttributeValueId = ZPPADV1.PimAttributeValueId 
		                 and ZPPADV1.PimAttributeDefaultValueId = ZPPADV.PimAttributeDefaultValueId )

		  ----Merging childs facet attribute Default value XML for parent
		  insert into #PimAttributeDefaultXML (DefaultValueXML, PimAttributeValueId, LocaleId)
		  select ZPADX.DefaultValueXML, ZPPADV.PimAttributeValueId, ZPPADV.LocaleId
		  from #PimChildProductFacets ZPPADV		  
		  inner join ZnodePimAttributeDefaultXML ZPADX ON ( ZPPADV.PimAttributeDefaultValueId = ZPADX.PimAttributeDefaultValueId AND ZPPADV.LocaleId = ZPADX.LocaleId)

		  CREATE INDEX Idx_#PimDefaultValueLocale ON #PimDefaultValueLocale(PimAttributeDefaultXMLId,LocaleId)

		  CREATE INDEX Idx_#PimAttributeDefaultXML ON #PimAttributeDefaultXML(PimAttributeValueId,LocaleId)
		  INCLUDE (DefaultValueXML)

		  ----Getting default attribute value entity
		 INSERT INTO #AttributeValueLocale
		 SELECT PPCP.PimProductId, PPCP.AttributeCode,'' AttributeValue,ZPAX.AttributeXML+'<AttributeValues></AttributeValues>'
			    +CAST(( SELECT  cast(DefaultValueXML as xml) SelectValues  FROM #PimAttributeDefaultXML aa
				 WHERE (aa.PimAttributeValueId = PPCP.PimAttributeValueId and AA.LocaleId = ZPAX.LocaleId)
				 FOR XML PATH('') , TYPE ) AS NVARCHAR(max))  AttributeEntity , ZPAX.LocaleId
		 FROM #ZnodePublishCategoryProduct PPCP 
		 INNER JOIN ZnodePimAttributeXML ZPAX ON (ZPAX.PimAttributeId = PPCP.PimAttributeId)
		 where not exists(select * from #AttributeValueLocale AVL where PPCP.PimProductId = AVL.PimProductId and PPCP.AttributeCode = AVL.AttributeCode and ZPAX.LocaleId = AVL.LocaleId )
		and exists(select * from #PimProductAttributeDefaultValue a  where PPCP.PimProductId = a.PimProductId and ZPAX.PimAttributeId = a.PimAttributeId )
		 and exists(select * from ZnodePimAttributeValue a Inner join ZnodePimProductAttributeDefaultValue b on a.PimAttributeValueId = b.PimAttributeValueId 
		            and PPCP.PimProductId = a.PimProductId and ZPAX.PimAttributeId = a.PimAttributeId )
		and not exists(select * from ZnodePimConfigureProductAttribute UOP where ZPAX.PimAttributeId = UOP.PimAttributeId and PPCP.PimProductId = UOP.PimProductId )

		 ----Getting text attribute value entity
		 INSERT INTO #AttributeValueLocale ( PimProductId, AttributeCode, AttributeValue, AttributeEntity, LocaleId )
		 SELECT PPCP.PimProductId , ZPA.AttributeCode,ZPAVL.AttributeValue ,ZPAX.AttributeXML + '<AttributeValues>'+(SELECT ISNULL(ZPAVL.AttributeValue,'') FOR XML PATH (''))+'</AttributeValues>'  AttributeEntity, ZPAVL.LocaleId
		 FROM ZnodePimAttributeValue PPCP
		 INNER JOIN ZnodePimProductAttributeTextAreaValue ZPAVL ON (PPCP.PimAttributeValueId =ZPAVL.PimAttributeValueId)
		 INNER JOIN ZnodePimAttributeXML ZPAX ON (ZPAX.PimAttributeId = PPCP.PimAttributeId AND ZPAX.LocaleId = ZPAVL.LocaleId)
		 INNER JOIN ZnodePimAttribute ZPA on PPCP.PimAttributeId = ZPA.PimAttributeId
	     where exists(select * from #ZnodePublishCategoryProduct PPCP1 WHERE PPCP1.PimProductId = PPCP.PimProductId) --(PPCP1.PimAttributeValueId =ZPAVL.PimAttributeValueId) and (ZPAX.PimAttributeId = PPCP1.PimAttributeId))
		 and not exists(select * from #AttributeValueLocale AVL where PPCP.PimProductId = AVL.PimProductId and ZPA.AttributeCode = AVL.AttributeCode and ZPAVL.LocaleId = AVL.LocaleId )
		 group by PPCP.PimProductId , ZPA.AttributeCode,ZPAVL.AttributeValue ,ZPAX.AttributeXML,ZPAVL.AttributeValue, ZPAVL.LocaleId

		 ----Getting custome field value entity
		 INSERT INTO #AttributeValueLocale ( PimProductId, AttributeCode, AttributeValue, AttributeEntity, LocaleId )
	     SELECT ZPCFX.PimProductId , ZPCFX.CustomCode, '' AttributeValue ,ZPCFX.CustomeFiledXML  AttributeEntity, ZPCFX.LocaleId
		 FROM ZnodePimCustomeFieldXML ZPCFX 
		 where exists(select * from #ZnodePublishCategoryProduct PPCP where (PPCP.PimProductId = ZPCFX.PimProductId ))
		 and not exists(select * from #AttributeValueLocale AVL where ZPCFX.PimProductId = AVL.PimProductId and ZPCFX.CustomCode = AVL.AttributeCode and ZPCFX.LocaleId = AVL.LocaleId )
		 group by ZPCFX.PimProductId , ZPCFX.CustomCode, ZPCFX.CustomeFiledXML , ZPCFX.LocaleId

		  ----Getting image attribute value entity
		 INSERT INTO #AttributeValueLocale ( PimProductId, AttributeCode, AttributeValue, AttributeEntity, LocaleId )
		 SELECT PPCP.PimProductId, ZPA.AttributeCode,'' AttributeValue,ZPAX.AttributeXML+'<AttributeValues>'
			    +stuff( (SELECT ','+ZPPAM.MediaPath FROM ZnodePimProductAttributeMedia ZPPAM WHERE (ZPPAM.PimAttributeValueId = PPCP.PimAttributeValueId)
				 FOR XML PATH('')), 1, 1, '') +'</AttributeValues>' , ZPAX.LocaleId
		 FROM ZnodePimAttributeValue PPCP 
		 INNER JOIN ZnodePimAttributeXML ZPAX ON (ZPAX.PimAttributeId = PPCP.PimAttributeId)
		 INNER JOIN ZnodePimAttribute ZPA ON ZPA.PimAttributeId = PPCP.PimAttributeId
		 where not exists(select * from #AttributeValueLocale AVL where PPCP.PimProductId = AVL.PimProductId and ZPA.AttributeCode = AVL.AttributeCode and ZPAX.LocaleId = AVL.LocaleId )
		 and exists(select * from ZnodePimProductAttributeMedia b where PPCP.PimAttributeValueId = b.PimAttributeValueId )
		 and exists(select * from #ZnodePublishCategoryProduct PPCP1 where PPCP.PimProductId = PPCP1.PimProductId )
		 and not exists(select * from ZnodePimConfigureProductAttribute UOP where ZPAX.PimAttributeId = UOP.PimAttributeId and PPCP.PimProductId = UOP.PimProductId )

		 -------------configurable attribute 		 
		INSERT INTO #AttributeValueLocale ( PimProductId, AttributeCode, AttributeValue, AttributeEntity, LocaleId )
		SELECT DISTINCT  UOP.PimProductId,c.AttributeCode,'' AttributeValue ,--'<Attributes><AttributeEntity>'+
		c.AttributeXML+'<AttributeValues></AttributeValues>'+'<SelectValues>'+
					   STUFF((
							SELECT DISTINCT '  '+REPLACE(AA.DefaultValueXML,'</SelectValuesEntity>','<VariantDisplayOrder>'+CAST(ISNULL(ZPA.DisplayOrder,0) AS VARCHAR(200))+'</VariantDisplayOrder>
							<VariantSKU>'+ISNULL(ZPAVL_SKU.AttributeValue,'')+'</VariantSKU>
							<VariantImagePath>'+ISNULL((SELECT ''+ZM.Path FOR XML Path ('')),'')+'</VariantImagePath></SelectValuesEntity>')   
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
						 LEFT  JOIN ZnodePimAttributeValue ZPAV12 ON (ZPAV12.PimProductId= YUP.PimProductId  AND ZPAV12.PimAttributeId = @PimMediaAttributeId ) 
						 LEFT JOIN ZnodePimProductAttributeMedia ZPAVM ON (ZPAVM.PimAttributeValueId= ZPAV12.PimAttributeValueId ) 
						 LEFT JOIN ZnodeMedia ZM ON (ZM.MediaId = ZPAVM.MediaId)
						 LEFT JOIN ZnodePimAttribute ZPA ON (ZPA.PimattributeId = ZPAV1.PimAttributeId)
						 WHERE (YUP.PimParentProductId  = UOP.PimProductId AND ZPAV1.pimAttributeId = UOP.PimAttributeId )
						 -- Active Variants
						 AND ZPAV.PimAttributeId = (SELECT TOP 1 PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'IsActive')
						 -- VariantSKU
						 AND ZPAV_SKU.PimAttributeId = (SELECT PimAttributeId FROM ZnodePimAttribute WHERE AttributeCode = 'SKU')
		FOR XML PATH, TYPE).value(N'.[1]', N'Nvarchar(max)'), 1, 1, '')+'</SelectValues> ' AttributeValue , --</AttributeEntity></Attributes>' 
		c.LocaleId
		FROM ZnodePimConfigureProductAttribute UOP 
		INNER JOIN ZnodePimAttributeXML c   ON (c.PimAttributeId = UOP.PimAttributeId )
		WHERE  exists(select * from #ZnodePublishCategoryProduct PPCP1 where UOP.PimProductId = PPCP1.PimProductId )
		-------------configurable attribute 
			  
		 CREATE INDEX IDX_#AttributeValueLocale ON #AttributeValueLocale(PimProductId,AttributeCode,LocaleId)
		 
		delete ZPPAX from ZnodePublishProductAttributeXML ZPPAX
		where exists (select * from #AttributeValueLocale AVL where ZPPAX.PimProductId = AVL.PimProductId and AVL.LocaleId = ZPPAX.LocaleId )
		and not exists(select * from #AttributeValueLocale AVL where ZPPAX.PimProductId = AVL.PimProductId and AVL.LocaleId = ZPPAX.LocaleId AND ZPPAX.AttributeCode = AVL.AttributeCode )

		DECLARE @MaxCount INT, @MinRow INT, @MaxRow INT, @Rows numeric(10,2);
		SELECT @MaxCount = COUNT(*) FROM #AttributeValueLocale;

		SELECT @Rows = 200000
        
		SELECT @MaxCount = CEILING(@MaxCount / @Rows);

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
        FOR SELECT MinRow, MaxRow FROM #Temp_ImportLoop
		WHERE EXISTS(SELECT * FROM #AttributeValueLocale);

        OPEN cur_BulkData;
        FETCH NEXT FROM cur_BulkData INTO  @MinRow, @MaxRow;

        WHILE @@FETCH_STATUS = 0
        BEGIN

			  ----Update Product Attribute XML
			 UPDATE ZPPAX SET ZPPAX.Attributes = AVL.AttributeEntity, ZPPAX.ModifiedBy = @UserId, ZPPAX.ModifiedDate = GETDATE() 
			 FROM ZnodePublishProductAttributeXML ZPPAX 
			 INNER JOIN #AttributeValueLocale AVL ON ZPPAX.PimProductId = AVL.PimProductId and AVL.LocaleId = ZPPAX.LocaleId AND ZPPAX.AttributeCode = AVL.AttributeCode 
			 where  AVL.Id BETWEEN @MinRow AND @MaxRow and AVL.AttributeEntity is not null
		 
			 ----Insert Product Attribute XML
			 INSERT INTO ZnodePublishProductAttributeXML(PimProductId,LocaleId,AttributeCode,Attributes,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			 SELECT AVL.PimProductId, AVL.LocaleId, AVL.AttributeCode, cast(AVL.AttributeEntity as varchar(max)), @UserId CreatedBy, GETDATE() CreatedDate, @UserId ModifiedBy, GETDATE() ModifiedDate
			 FROM #AttributeValueLocale AVL
			 WHERE NOT EXISTS(SELECT * FROM ZnodePublishProductAttributeXML ZPPAX WHERE AVL.PimProductId = ZPPAX.PimProductId AND  AVL.LocaleId = ZPPAX.LocaleId AND AVL.AttributeCode = ZPPAX.AttributeCode )
			 and  AVL.Id BETWEEN @MinRow AND @MaxRow and AVL.AttributeEntity is not null
			 GROUP BY AVL.PimProductId, AVL.AttributeEntity, AVL.LocaleId, AVL.AttributeCode

			 FETCH NEXT FROM cur_BulkData INTO  @MinRow, @MaxRow;
        END;
		CLOSE cur_BulkData;
		DEALLOCATE cur_BulkData;

 END TRY 
 BEGIN CATCH 
  SELECT ERROR_MESSAGE()
 END CATCH 
END
go

if exists(select * from sys.procedures where name = 'Znode_AdminUnassociatedUsers')
	drop proc Znode_AdminUnassociatedUsers
go
  

CREATE PROCEDURE [dbo].[Znode_AdminUnassociatedUsers]
(
	@WhereClause    VARCHAR(max) = '',
	@Rows			INT           = 100,
	@PageNo			INT           = 1,
	@Order_By		VARCHAR(1000) = '',
	@RowCount		INT        = 0 OUT,
	@PortalId		INT = 0
)
/*
	exec Znode_AdminUnassociatedUsers @AccountId = 5, @Rows = 50, @PageNo = 1, @Order_By = 'UserId asc'
	,@WhereClause='Username like ''%abhilash.dadhe%'''
*/
AS
BEGIN

	BEGIN TRY
	SET NOCOUNT ON;

	--DECLARE @PortalId INT = isnull((select top 1 PortalId from ZnodePortalAccount where AccountId = @AccountId ),0)

	DECLARE @SQL NVARCHAR(MAX) = '',
	        @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');

	set @SQL = '
	;with cte_UserListPortalWise as
	(
		SELECT ZU.Userid, isnull(ZU.FirstName,'''')+case when ZU.FirstName is null then '''' else '' '' end +isnull(ZU.MiddleName,'''')+case when ZU.MiddleName is null then '''' else '' '' end +isnull(ZU.LastName, '''') as FullName, ANZU.UserName, ZU.Email, 
			   case when ANZU.PortalId is null then ''ALL'' Else ZP.StoreName end as StoreName, ZU.ModifiedDate
		FROM AspNetZnodeUser ANZU
		inner join AspNetUsers ANU ON ANZU.AspNetZnodeUserId = ANU.UserName
		inner join ZnodeUser ZU ON ANU.Id = ZU.AspNetUserId
		left join ZnodePortal ZP ON ANZU.PortalId = ZP.PortalId
		WHERE ZU.AccountId is null
		and ( ANZU.PortalId = '+Cast(@PortalId as varchar(10))+' OR ANZU.PortalId is null )
	)
	select Userid,FullName, UserName, Email, StoreName,ModifiedDate 
	into #UserListPortalWise
	from cte_UserListPortalWise
	where 1=1 '+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+'

		select Userid,FullName, UserName, Email, StoreName,ModifiedDate,
	       Row_Number()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'ModifiedDate DESC, UserId DESC')+',ModifiedDate DESC, UserId DESC) RowId
		into #UserListPortalWise_RowNumber
		from #UserListPortalWise

		SET @Count= ISNULL((SELECT  Count(1) FROM #UserListPortalWise_RowNumber ),0)
	
		select Userid, FullName, UserName, Email, StoreName
		from #UserListPortalWise_RowNumber 
		'+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'ModifiedDate DESC, UserId DESC');

		print @SQL
		EXEC SP_executesql
					@SQL,
					N'@Count INT OUT',
					@Count = @RowCount OUT;

		--select @RowCount AS [RowCount]
		
	END TRY
    BEGIN CATCH
		DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUnassociatedUsers @WhereClause='+cast(@WhereClause as varchar(max))+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50))+'
		@PortalId='+CAST(@PortalId AS VARCHAR(50));
		EXEC Znode_InsertProcedureErrorLog
		@ProcedureName    = 'Znode_AdminUnassociatedUsers',
		@ErrorInProcedure = @ERROR_PROCEDURE,
		@ErrorMessage     = @ErrorMessage,
		@ErrorLine        = @ErrorLine,
		@ErrorCall        = @ErrorCall;
    END CATCH;

END
go
Update ZnodeActions SET ActionName =  Rtrim(Ltrim(A.ActionName))
FROM ZnodeActions A where ActionName in  ('UpdateTaxExemptOnCreateOrder ', 'AddToCartProduct' , 'GetShoppingCartItems', 'CalculateShoppingCart', 'UpdateCartQuantity', 'RemoveCartItem') 
go

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PublishProductId</name>      <headertext>PublishProductId</headertext>      <width>5</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PublishProductId,Quantity,SKU</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>HiddenField</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Single</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImageSmallThumbnailPath,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>JavaScript:void(0);</islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>sku</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Name</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>productname</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>SalesPriceWithCurrency</name>      <headertext>Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/SEO/SEODetails</manageactionurl>      <manageparamfield>ItemName,ItemId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where  ItemName = 'ZnodeOrderProductList'
go
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PublishProductId</name>      <headertext>PublishProductId</headertext>      <width>5</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>PublishProductId,Quantity,SKU</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>HiddenField</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>Single</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImageSmallThumbnailPath,ProductName</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>JavaScript:void(0);</islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>sku</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Name</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>productname</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>SalesPriceWithCurrency</name>      <headertext>Sales Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>RetailPriceWithCurrency</name>      <headertext>Retail Price</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/SEO/SEODetails</manageactionurl>      <manageparamfield>ItemName,ItemId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeOrderProductList'

go

INSERT ZnodeImportTemplateMapping(ImportTemplateId,SourceColumnName,TargetColumnName,DisplayOrder,IsActive,IsAllowNull,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT (select Top 1 ImportTemplateId from ZnodeImportTemplate where TemplateName = 'PriceTemplate'),
'CostPrice' SourceColumnName,'CostPrice' TargetColumnName,0 DisplayOrder,0 IsActive, 0 IsAllowNull,2 CreatedBy,GETDATE() CreatedDate,2 ModifiedBy,GETDATE() ModifiedDate
WHERE NOT EXISTS(SELECT * FROM ZnodeImportTemplateMapping WHERE ImportTemplateId=3 AND SourceColumnName ='CostPrice')
go
insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)
select 'Number','CostPrice',(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing'),0,'Yes/No','AllowNegative',
null,'false','',null,2,getdate(),2,getdate(),11
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'CostPrice' 
      and ControlName = 'Yes/No' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing')
	  and ValidationName = 'AllowNegative')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)
select 'Number','CostPrice',(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing'),0,'Yes/No','AllowDecimals',
null,'false','',null,2,getdate(),2,getdate(),11
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'CostPrice' 
      and ControlName = 'Yes/No' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing')
	  and ValidationName = 'AllowDecimals')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)
select 'Number','CostPrice',(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing'),0,'Number','MinNumber',
null,'0','',null,2,getdate(),2,getdate(),11
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'CostPrice' 
      and ControlName = 'Number' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing')
	  and ValidationName = 'MinNumber')

insert into ZnodeImportAttributeValidation(AttributeTypeName,AttributeCode,ImportHeadId,IsRequired,ControlName,ValidationName,SubValidationName
,ValidationValue,RegExp,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,SequenceNumber)
select 'Number','CostPrice',(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing'),0,'Number','MaxNumber',
null,'999999','',null,2,getdate(),2,getdate(),11
where not exists(select * from ZnodeImportAttributeValidation where AttributeTypeName ='Number' and AttributeCode = 'CostPrice' 
      and ControlName = 'Number' and ImportHeadId=(select Top 1 ImportHeadId from ZnodeImportHead where Name = 'Pricing')
	  and ValidationName = 'MaxNumber')
go

if exists(select * from sys.procedures where name = 'Znode_ImportPriceList')
	drop proc Znode_ImportPriceList
go
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
			(SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL,
			Custom1 varchar(300) NULL, Custom2 varchar(300) NULL, Custom3 varchar(300) NULL,CostPrice numeric(28,6), RowNumber varchar(300) NULL)
	
		--DECLARE #InsertPriceForValidation TABLE
		--( 
		--	SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL
		--);
		IF OBJECT_ID('#InsertPrice', 'U') IS NOT NULL 
			DROP TABLE #InsertPrice
		ELSE 
			CREATE TABLE #InsertPrice 
			( 
				SKU varchar(300), TierStartQuantity numeric(28, 6) NULL, RetailPrice numeric(28, 6) NULL, SalesPrice numeric(28, 6) NULL, TierPrice numeric(28, 6) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL,
				Custom1 varchar(300) NULL, Custom2 varchar(300) NULL, Custom3 varchar(300) NULL,CostPrice numeric(28,6), RowNumber varchar(300)
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
		

		SET @SSQL = 'Select SKU,TierStartQuantity ,RetailPrice,SalesPrice,TierPrice,SKUActivationDate ,SKUExpirationDate ,
		 Custom1, Custom2, Custom3,CostPrice, RowNumber FROM '+@TableName;
		INSERT INTO #InsertPriceForValidation( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate,
		 Custom1, Custom2, Custom3,CostPrice, RowNumber )
		EXEC sys.sp_sqlexec @SSQL;

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'TierPrice', TierPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(TierPrice)=0  
				or exists(select * from ZnodeCulture where Symbol is not null and TierPrice like '%'+Symbol+'%')) and ISNULL(TierPrice,'')<>''
		
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'SalesPrice', SalesPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(SalesPrice)=0	or exists(select * from ZnodeCulture where Symbol is not null and SalesPrice like '%'+Symbol+'%'))
				and ISNULL(SalesPrice,'')<>''

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'RetailPrice', RetailPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(RetailPrice)=0 or exists(select * from ZnodeCulture where Symbol is not null and RetailPrice like '%'+Symbol+'%')) and ISNULL(RetailPrice,'')<>''
		
		UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ SKU - ' + ISNULL(SKU,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN #InsertPriceForValidation IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL
			   			  	
	    --- Delete Invalid Data after functional validation 
		DELETE FROM #InsertPriceForValidation
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  Guid = @NewGUId
		);
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
		
		INSERT INTO #InsertPrice( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate,
		 Custom1, Custom2, Custom3,CostPrice, RowNumber )
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
															  END, SKUActivationDate, SKUExpirationDate,
															   Custom1, Custom2, Custom3,CostPrice, RowNumber
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

			
		--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--	   SELECT '26', 'RetailPrice', RetailPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		--	   FROM #InsertPriceForValidation
		--	   WHERE ISNULL(CAST(RetailPrice AS numeric(28, 6)), 0) <= 0 AND 
		--			 RetailPrice <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '39', 'SKUActivationDate', SKUActivationDate, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPrice AS IP
			   WHERE SKUActivationDate > SKUExpirationDate AND 
					 ISNULL(SKUExpirationDate, '') <> '';
					 
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE( TierPrice IS NULL OR TierPrice = '0') AND  TierStartQuantity  = '';
			  
			  
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierPrice', TierPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation WHERE( TierPrice IS NULL OR  TierPrice = '') AND TierStartQuantity  <> 0;

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation IPV
			   WHERE TierStartQuantity = ''  
				AND	( TierPrice <> ''  OR TierPrice IS NULL ) 

			  
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation IPV
			   WHERE TierStartQuantity <> '' AND 
			    ISNULL(CAST(TierStartQuantity AS numeric(28, 6)), 0) <= 0 
				AND	( TierPrice <> ''  OR TierPrice IS NULL ) 
		
		
				  
		UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ SKU - ' + ISNULL(SKU,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN #InsertPrice IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL

			 
 	
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

		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount,
		TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0)) 
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
				END, ZP.ModifiedBy = @UserId, ZP.ModifiedDate = @GetDate,
				ZP.CostPrice =IP.CostPrice
		FROM #InsertPrice IP INNER JOIN ZnodePrice ZP ON ZP.PriceListId = @PriceListId AND  ZP.SKU = IP.SKU  
			 --Retrive last record from price list of specific SKU ListCode and Name 									
		WHERE IP.RowNumber IN
		(
			SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
		);
		INSERT INTO ZnodePrice( PriceListId, SKU, SalesPrice, RetailPrice, ActivationDate, ExpirationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,CostPrice )
			   SELECT @PriceListId, IP.SKU, IP.SalesPrice, IP.RetailPrice,
																						   CASE
																						   WHEN ISNULL(IP.SKUActivationDate, '') = '' THEN NULL
																						   ELSE IP.SKUActivationDate
																						   END,
																						   CASE
																						   WHEN ISNULL(IP.SKUExpirationDate, '') = '' THEN NULL
																						   ELSE IP.SKUExpirationDate
																						   END, @UserId, @GetDate, @UserId, @GetDate,IP.CostPrice
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
				  (CONVERT(varchar(100), TierPrice) <> '' OR CONVERT (varchar(100), TierPrice) IS NOT NULL)
		)
		BEGIN
		
			UPDATE ZPT
			  SET ZPT.Price = IP.TierPrice, ZPT.ModifiedBy = @UserId, ZPT.ModifiedDate = @GetDate,
			  ZPT.Custom1 = IP.Custom1,ZPT.Custom2 = IP.Custom2, ZPT.Custom3 = IP.Custom3 
			FROM #InsertPrice IP INNER JOIN ZnodePriceTier ZPT ON ZPT.PriceListId = @PriceListId AND  ZPT.SKU = IP.SKU AND ZPT.Quantity = IP.TierStartQuantity 
		    --Retrive last record from price list of specific SKU ListCode and Name 
			WHERE IP.RowNumber IN
			(
				SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU AND IPI.TierStartQuantity = IP.TierStartQuantity 
			);

			INSERT INTO ZnodePriceTier( PriceListId, SKU, Price, Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Custom1, Custom2, Custom3 )
				   SELECT @PriceListId, IP.SKU, IP.TierPrice, IP.TierStartQuantity,  @UserId, @GetDate, @UserId, @GetDate, Custom1, Custom2, Custom3
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
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = GETDATE()
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- COMMIT TRAN ImportProducts;
		COMMIT TRAN A;
	END TRY
	BEGIN CATCH
		
		SET @Status = 0;
		SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE();
		ROLLBACK TRAN A;
	END CATCH;
END;
go

if exists(select * from sys.procedures where name = 'Znode_GetProductsAttributeValue_newTesting')
	drop proc Znode_GetProductsAttributeValue_newTesting
go
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
  DECLARE @Tyr TransferId   
  ,  @Tyr1   TransferId   
  INSERT INTO @Tyr   
  SELECT   
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
      ,PimAttributeValueLocaleId INT ,LocaleId INT , RowId INT,PimAttributeDefaultValueId INT  )  
          INSERT INTO #TBL_AttributeValue (PimAttributeValueId   , PimAttributeId   , PimProductId  ,AttributeCode ,AttributeValue ,TypeOfData    
      ,PimAttributeValueLocaleId  ,LocaleId  , RowId    )     
    SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.AttributeValue,1 TypeOfData  
      ,ZPAVL.ZnodePimAttributeValueLocaleId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId  
        FROM ZnodePimAttributeValueLocale  ZPAVL   
    INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)  
    WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId   
     
    INSERT INTO #TBL_AttributeValue (PimAttributeValueId   , PimAttributeId   , PimProductId  ,AttributeCode ,AttributeValue ,TypeOfData    
      ,PimAttributeValueLocaleId  ,LocaleId  , RowId )  
    SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,ZPAVL.AttributeValue,1 TypeOfData  
      ,ZPAVL.PimProductAttributeTextAreaValueId PimAttributeValueLocaleId,LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId  
    FROM ZnodePimProductAttributeTextAreaValue  ZPAVL   
    INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)  
    WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId   
     
    INSERT INTO #TBL_AttributeValue (PimAttributeValueId   , PimAttributeId   , PimProductId  ,AttributeCode ,AttributeValue ,TypeOfData    
      ,PimAttributeValueLocaleId  ,LocaleId  , RowId ,PimAttributeDefaultValueId   )  
    SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,  
           CAST( ZPAVL.PimAttributeDefaultValueId AS VARCHAR(2000)),2 TypeOfData  
      ,ZPAVL.PimProductAttributeDefaultValueId PimAttributeValueLocaleId,LocaleId  
      ,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId  
      ,PimAttributeDefaultValueId  
    FROM ZnodePimProductAttributeDefaultValue  ZPAVL   
    INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)  
    WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId   
      
    INSERT INTO #TBL_AttributeValue (PimAttributeValueId   , PimAttributeId   , PimProductId  ,AttributeCode ,AttributeValue ,TypeOfData    
      ,PimAttributeValueLocaleId  ,LocaleId  , RowId   )  
    SELECT TBLAV.PimAttributeValueId , TBLAV.PimAttributeId , PimProductId,AttributeCode,CAST( ZPAVL.MediaId AS VARCHAR(2000)) ,3 TypeOfData  
      ,ZPAVL.PimProductAttributeMediaId PimAttributeValueLocaleId,ZPAVL.LocaleId,COUNT(*)Over(Partition By TBLAV.PimProductId,PimAttributeId ORDER BY TBLAV.PimProductId,PimAttributeId  ) RowId  
    FROM ZnodePimProductAttributeMedia  ZPAVL   
    INNER JOIN #TBL_AttributeValue1 TBLAV ON (TBLAV.PimAttributeValueId = ZPAVL.PimAttributeValueId)  
    WHERE LocaleId = @DefaultLocaleId OR LocaleId = @LocaleId   
    

     SELECT ZPPADV.PimAttributeValueId   
     ,ZPADVL.AttributeDefaultValue AttributeDefaultValue ,ZPADVL.localeID LocaleId ,ZPPADV.PimProductId   
     ,ZPPADV.AttributeCode,ZPPADV.PimAttributeId,TEY.AttributeDefaultValueCode    
     into #Cte_GetDefaultData
	 FROM #TBL_AttributeValue ZPPADV   
     INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)  
     INNER JOIN ZnodePimAttributeDefaultValue TEY ON (TEY.PimAttributeDefaultValueId  = ZPPADV.PimAttributeDefaultValueId )  
     INNER JOIN ZnodePimAttributeDefaultValuelocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = TEY.PimAttributeDefaultValueId )  
     WHERE ZPADVL.localeID  IN (@LocaleId,@DefaultLocaleId)  
     AND TypeOfData = 2   
     AND ZPPADV.LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END   
   
	--insert into Cte_AttributeValueDefault
     SELECT AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId ,AttributeDefaultValueCode   
     into #Cte_AttributeValueDefault
	 FROM #Cte_GetDefaultData   
     WHERE LocaleId = @LocaleId   
     --UNION 
	 insert into #Cte_AttributeValueDefault   
     SELECT  AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId,AttributeDefaultValueCode   
     FROM #Cte_GetDefaultData a   
     WHERE LocaleId = @DefaultLocaleId   
     AND NOT EXISTS (SELECT TOP 1 1 FROM #Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)  
      --  )  
    
	create table #AttributeValueDefaultData( PimProductId int,	AttributeValue varchar(max),	AttributeCode varchar(300),	PimAttributeId int,	AttributeDefaultValue varchar(2000), PimAttributeValueLocaleId int)  
     
	insert into #AttributeValueDefaultData(PimProductId,AttributeValue,AttributeCode,PimAttributeId,AttributeDefaultValue)  
    SELECT  PimProductId, AttributeValue,  AttributeCode,  PimAttributeId, NULL AttributeDefaultValue    
    FROM  #TBL_AttributeValue   
             WHERE LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END   
    AND TypeOfData = 1    

   UNION ALL  
   SELECT DISTINCT PimProductId,
			 SUBSTRING ((SELECT ',' + AttributeDefaultValue 
													FROM #Cte_AttributeValueDefault CTEAI 
													WHERE CTEAI.PimProductId = CTEA.PimProductId 
													AND CTEAI.PimAttributeId = CTEA.PimAttributeId
													FOR XML PATH ('')   ),2,4000) AttributeDefaultValue,AttributeCode ,PimAttributeId
			 ,SUBSTRING ((SELECT ',' + AttributeDefaultValueCode 
													FROM #Cte_AttributeValueDefault CTEAI1 
													WHERE CTEAI1.PimProductId = CTEA.PimProductId 
													AND CTEAI1.PimAttributeId = CTEA.PimAttributeId
													FOR XML PATH ('')   ),2,4000) AttributeDefaultValue
				
			FROM #Cte_AttributeValueDefault  CTEA 
     
	-- UNION ALL   
     insert into #AttributeValueDefaultData( PimProductId ,	AttributeValue,	AttributeCode ,	PimAttributeId ,	AttributeDefaultValue , PimAttributeValueLocaleId )  
    SELECT DISTINCT PimProductId,  
            SUBSTRING ((SELECT ','+[dbo].[Fn_GetMediaThumbnailMediaPath]( zm.PATH) FROM ZnodeMedia ZM WHERE ZM.MediaId = TBLAV.AttributeValue   
      FOR XML PATH (''), TYPE).value('.', 'varchar(Max)') ,2,4000)  ,AttributeCode,PimAttributeId, NULL AttributeDefaultValue , PimAttributeValueLocaleId
    FROM #TBL_AttributeValue TBLAV   
    WHERE  LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END   
    AND TypeOfData = 3  
    -- GROUP BY PimAttributeId,PimProductId,AttributeCode  
    
	select PimProductId,AttributeValue,AttributeCode,PimAttributeId,AttributeDefaultValue from #AttributeValueDefaultData
	order by PimAttributeValueLocaleId

   END TRY  
         BEGIN CATCH  
    
      SELECT ERROR_MESSAGE()  
            DECLARE @Status BIT ;  
   SET @Status = 0;  
   
         END CATCH;  
     END;
	go
insert into ZnodeApplicationSetting (GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 
'Table',	'ZnodeCloudflareDomainList',	'<?xml version="1.0" encoding="UTF-8"?>  <columns>     <column>        <id>1</id>        <name>DomainId</name>        <headertext>Checkbox</headertext>        <width>0</width>        <datatype>String</datatype>        <columntype>Int32</columntype>        <allowsorting>false</allowsorting>        <allowpaging>true</allowpaging>        <format />        <isvisible>y</isvisible>        <mustshow>y</mustshow>        <musthide>n</musthide>        <maxlength>0</maxlength>        <isallowsearch>n</isallowsearch>        <isconditional>n</isconditional>        <isallowlink>n</isallowlink>        <islinkactionurl />        <islinkparamfield />        <ischeckbox>y</ischeckbox>        <checkboxparamfield />        <iscontrol>n</iscontrol>        <controltype />        <controlparamfield />        <displaytext />        <editactionurl />        <editparamfield />        <deleteactionurl />        <deleteparamfield />        <viewactionurl />        <viewparamfield />        <imageactionurl />        <imageparamfield />        <manageactionurl />        <manageparamfield />        <copyactionurl />        <copyparamfield />        <xaxis>n</xaxis>        <yaxis>n</yaxis>        <isadvancesearch>y</isadvancesearch>        <Class />        <SearchControlType>--Select--</SearchControlType>        <SearchControlParameters />        <DbParamField />        <useMode>DataBase</useMode>        <IsGraph>n</IsGraph>        <allowdetailview>n</allowdetailview>     </column>     <column>        <id>2</id>        <name>DomainId</name>        <headertext>Domain ID</headertext>        <width>10</width>        <datatype>Int32</datatype>        <columntype>Int32</columntype>        <allowsorting>true</allowsorting>        <allowpaging>true</allowpaging>        <format />        <isvisible>y</isvisible>        <mustshow>n</mustshow>        <musthide>n</musthide>        <maxlength>0</maxlength>        <isallowsearch>n</isallowsearch>        <isconditional>n</isconditional>        <isallowlink>n</isallowlink>        <islinkactionurl />        <islinkparamfield />        <ischeckbox>n</ischeckbox>        <checkboxparamfield />        <iscontrol>n</iscontrol>        <controltype />        <controlparamfield />        <displaytext />        <editactionurl />        <editparamfield />        <deleteactionurl />        <deleteparamfield />        <viewactionurl />        <viewparamfield />        <imageactionurl />        <imageparamfield />        <manageactionurl />        <manageparamfield />        <copyactionurl />        <copyparamfield />        <xaxis>n</xaxis>        <yaxis>n</yaxis>        <isadvancesearch>y</isadvancesearch>        <Class />        <SearchControlType>--Select--</SearchControlType>        <SearchControlParameters />        <DbParamField />        <useMode>DataBase</useMode>        <IsGraph>n</IsGraph>        <allowdetailview>n</allowdetailview>     </column>     <column>        <id>3</id>        <name>StoreName</name>        <headertext>Webstore Name</headertext>        <width>0</width>        <datatype>String</datatype>        <columntype>String</columntype>        <allowsorting>true</allowsorting>        <allowpaging>true</allowpaging>        <format />        <isvisible>y</isvisible>        <mustshow>y</mustshow>        <musthide>n</musthide>        <maxlength>0</maxlength>        <isallowsearch>n</isallowsearch>        <isconditional>n</isconditional>        <isallowlink>n</isallowlink>        <islinkactionurl />        <islinkparamfield />        <ischeckbox>n</ischeckbox>        <checkboxparamfield />        <iscontrol>n</iscontrol>        <controltype />        <controlparamfield />        <displaytext />        <editactionurl />        <editparamfield />        <deleteactionurl />        <deleteparamfield />        <viewactionurl />        <viewparamfield />        <imageactionurl />        <imageparamfield />        <manageactionurl />        <manageparamfield />        <copyactionurl />        <copyparamfield />        <xaxis>n</xaxis>        <yaxis>n</yaxis>        <isadvancesearch>y</isadvancesearch>        <Class />        <SearchControlType>--Select--</SearchControlType>        <SearchControlParameters />        <DbParamField />        <useMode>DataBase</useMode>        <IsGraph>n</IsGraph>        <allowdetailview>n</allowdetailview>     </column>     <column>        <id>4</id>        <name>DomainName</name>        <headertext>Domain Name</headertext>        <width>40</width>        <datatype>String</datatype>        <columntype>String</columntype>        <allowsorting>true</allowsorting>        <allowpaging>true</allowpaging>        <format />        <isvisible>y</isvisible>        <mustshow>y</mustshow>        <musthide>n</musthide>        <maxlength>100</maxlength>        <isallowsearch>y</isallowsearch>        <isconditional>n</isconditional>        <isallowlink>n</isallowlink>        <islinkactionurl />        <islinkparamfield />        <ischeckbox>n</ischeckbox>        <checkboxparamfield />        <iscontrol>y</iscontrol>        <controltype>Text</controltype>        <controlparamfield />        <displaytext />        <editactionurl />        <editparamfield />        <deleteactionurl />        <deleteparamfield />        <viewactionurl />        <viewparamfield />        <imageactionurl />        <imageparamfield />        <manageactionurl />        <manageparamfield />        <copyactionurl />        <copyparamfield />        <xaxis>n</xaxis>        <yaxis>n</yaxis>        <isadvancesearch>y</isadvancesearch>        <Class />        <SearchControlType>--Select--</SearchControlType>        <SearchControlParameters />        <DbParamField />        <useMode>DataBase</useMode>        <IsGraph>n</IsGraph>        <allowdetailview>n</allowdetailview>     </column>     <column>        <id>5</id>        <name />        <headertext>Refresh Status</headertext>        <width>40</width>        <datatype>String</datatype>        <columntype>String</columntype>        <allowsorting>true</allowsorting>        <allowpaging>true</allowpaging>        <format />        <isvisible>y</isvisible>        <mustshow>y</mustshow>        <musthide>n</musthide>        <maxlength>100</maxlength>        <isallowsearch>y</isallowsearch>        <isconditional>n</isconditional>        <isallowlink>n</isallowlink>        <islinkactionurl />        <islinkparamfield />        <ischeckbox>n</ischeckbox>        <checkboxparamfield />        <iscontrol>y</iscontrol>        <controltype>Text</controltype>        <controlparamfield />        <displaytext />        <editactionurl />        <editparamfield />        <deleteactionurl />        <deleteparamfield />        <viewactionurl />        <viewparamfield />        <imageactionurl />        <imageparamfield />        <manageactionurl />        <manageparamfield />        <copyactionurl />        <copyparamfield />        <xaxis>n</xaxis>        <yaxis>n</yaxis>        <isadvancesearch>y</isadvancesearch>        <Class />        <SearchControlType>--Select--</SearchControlType>        <SearchControlParameters />        <DbParamField />        <useMode>DataBase</useMode>        <IsGraph>n</IsGraph>        <allowdetailview>n</allowdetailview>     </column>     <column>        <id>6</id>        <name>ApiKey</name>        <headertext>API Key</headertext>        <width>40</width>        <datatype>String</datatype>        <columntype>String</columntype>        <allowsorting>true</allowsorting>        <allowpaging>true</allowpaging>        <format />        <isvisible>n</isvisible>        <mustshow>n</mustshow>        <musthide>n</musthide>        <maxlength>0</maxlength>        <isallowsearch>n</isallowsearch>        <isconditional>n</isconditional>        <isallowlink>n</isallowlink>        <islinkactionurl />        <islinkparamfield />        <ischeckbox>n</ischeckbox>        <checkboxparamfield />        <iscontrol>n</iscontrol>        <controltype />        <controlparamfield />        <displaytext />        <editactionurl />        <editparamfield />        <deleteactionurl />        <deleteparamfield />        <viewactionurl />        <viewparamfield />        <imageactionurl />        <imageparamfield />        <manageactionurl />        <manageparamfield />        <copyactionurl />        <copyparamfield />        <xaxis>n</xaxis>        <yaxis>n</yaxis>        <isadvancesearch>n</isadvancesearch>        <Class />        <SearchControlType>--Select--</SearchControlType>        <SearchControlParameters />        <DbParamField />        <useMode>DataBase</useMode>        <IsGraph>n</IsGraph>        <allowdetailview>n</allowdetailview>     </column>  </columns>',	
'ZnodeDomainList',	'ZnodeDomainList',	'ZnodeDomainList',	0,	NULL,	NULL,	NULL,	NULL,	2,	getdate(),	2	, getdate()
where not exists (select TOP 1 1 from ZnodeApplicationSetting where ItemName = 'ZnodeCloudflareDomainList')

go
declare @ActivityLogTypeId int
select @ActivityLogTypeId = max(ActivityLogTypeId) from ZnodeActivityLogType
insert ZnodeActivityLogType(ActivityLogTypeId, [Name],TypeCategory)
select @ActivityLogTypeId+1,'CLOUDFLARE_PURGE_ALL','CLOUDFLARE'
where not exists(select * from ZnodeActivityLogType where [Name] = 'CLOUDFLARE_PURGE_ALL')

insert ZnodeActivityLogType(ActivityLogTypeId, [Name],TypeCategory)
select @ActivityLogTypeId+2,'CLOUDFLARE_PURGE_CUSTOM','CLOUDFLARE'
where not exists(select * from ZnodeActivityLogType where [Name] = 'CLOUDFLARE_PURGE_CUSTOM')
go
insert into ZnodeApplicationCache(ApplicationType,IsActive,StartDate,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Duration)
select 'CloudflareCache' ApplicationType,1 IsActive,GETDATE() StartDate,2 CreatedBy,GETDATE() CreatedDate,2 ModifiedBy,GETDATE() ModifiedDate,0 Duration
where not exists(select * from ZnodeApplicationCache where ApplicationType = 'CloudflareCache' )
go
insert into ZnodeGlobalAttribute(AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsActive,DisplayOrder,HelpDescription,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsSystemDefined)
select (select top 1 AttributeTypeId from ZnodeAttributeType where AttributeTypeName = 'Yes/No'),'IsCloudflareEnabled',1,0,0,1,
'Decide is the Clouflare enabled on webstore?',2,getdate(),2,getdate(),0
where not exists(select * from ZnodeGlobalAttribute where  AttributeCode = 'IsCloudflareEnabled')

insert into ZnodeGlobalAttribute(AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsActive,DisplayOrder,HelpDescription,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsSystemDefined)
select (select top 1 AttributeTypeId from ZnodeAttributeType where AttributeTypeName = 'Text'),'CloudflareZoneId',1,1,0,2,
'ZoneId for Cloudflare',2,getdate(),2,getdate(),0
where not exists(select * from ZnodeGlobalAttribute where  AttributeCode = 'CloudflareZoneId')

insert into ZnodePortalGlobalAttributeValue(PortalId,GlobalAttributeId,GlobalAttributeDefaultValueId,AttributeValue,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select PortalId,(select top 1 GlobalAttributeId from ZnodeGlobalAttribute where  AttributeCode = 'IsCloudflareEnabled'),null,null,2,getdate(),2,getdate()
from ZnodePortal ZP
where not exists(select * from ZnodePortalGlobalAttributeValue ZPGA where ZP.PortalId = ZPGA.PortalId
      and ZPGA.GlobalAttributeId = (select top 1 GlobalAttributeId from ZnodeGlobalAttribute where  AttributeCode = 'IsCloudflareEnabled'))


insert into ZnodePortalGlobalAttributeValueLocale(PortalGlobalAttributeValueId,	LocaleId,	AttributeValue	,CreatedBy,	CreatedDate,	ModifiedBy	,ModifiedDate)
select PortalGlobalAttributeValueId,1,'false',2,getdate(),2,getdate()
from ZnodePortalGlobalAttributeValue ZPGA
where ZPGA.GlobalAttributeId = (select top 1 GlobalAttributeId from ZnodeGlobalAttribute where  AttributeCode = 'IsCloudflareEnabled')
and not exists(select * from ZnodePortalGlobalAttributeValueLocale ZPGAVL where ZPGAVL.PortalGlobalAttributeValueId = ZPGA.PortalGlobalAttributeValueId)

insert into ZnodePortalGlobalAttributeValue(PortalId,GlobalAttributeId,GlobalAttributeDefaultValueId,AttributeValue,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select PortalId,(select top 1 GlobalAttributeId from ZnodeGlobalAttribute where  AttributeCode = 'CloudflareZoneId'),null,null,2,getdate(),2,getdate()
from ZnodePortal ZP
where not exists(select * from ZnodePortalGlobalAttributeValue ZPGA where ZP.PortalId = ZPGA.PortalId
      and ZPGA.GlobalAttributeId = (select top 1 GlobalAttributeId from ZnodeGlobalAttribute where  AttributeCode = 'CloudflareZoneId'))

insert into ZnodePortalGlobalAttributeValueLocale(PortalGlobalAttributeValueId,	LocaleId,	AttributeValue	,CreatedBy,	CreatedDate,	ModifiedBy	,ModifiedDate)
select PortalGlobalAttributeValueId,1,'',2,getdate(),2,getdate()
from ZnodePortalGlobalAttributeValue ZPGA
where ZPGA.GlobalAttributeId = (select top 1 GlobalAttributeId from ZnodeGlobalAttribute where  AttributeCode = 'CloudflareZoneId')
and not exists(select * from ZnodePortalGlobalAttributeValueLocale ZPGAVL where ZPGAVL.PortalGlobalAttributeValueId = ZPGA.PortalGlobalAttributeValueId)

insert into ZnodeGlobalAttributeLocale(LocaleId,GlobalAttributeId,AttributeName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 1,GlobalAttributeId,'Enable Cloudflare',null,2,getdate(),2,getdate()
from ZnodeGlobalAttribute a
where AttributeCode = 'IsCloudflareEnabled' and 
not exists(select * from ZnodeGlobalAttributeLocale b where a.GlobalAttributeId = b.GlobalAttributeId and b.LocaleId = 1)

insert into ZnodeGlobalAttributeLocale(LocaleId,GlobalAttributeId,AttributeName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 1,GlobalAttributeId,'ZoneId',null,2,getdate(),2,getdate()
from ZnodeGlobalAttribute a
where AttributeCode = 'CloudflareZoneId' and 
not exists(select * from ZnodeGlobalAttributeLocale b where a.GlobalAttributeId = b.GlobalAttributeId and b.LocaleId = 1)

----
insert into ZnodeGlobalAttributeGroup(GroupCode,DisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,IsSystemDefined)
select 'Cloudflaresetting',null,2,getdate(),2,getdate(),0
where not exists(select * from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting')

insert into ZnodeGlobalAttributeGroupLocale(LocaleId,GlobalAttributeGroupId,AttributeGroupName,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 1,GlobalAttributeGroupId,'Cloudflare Setting',null,2,getdate(),2,getdate()
from ZnodeGlobalAttributeGroup a
where GroupCode = 'Cloudflaresetting'
and not exists(select * from ZnodeGlobalAttributeGroupLocale b where b.GlobalAttributeGroupId= a.GlobalAttributeGroupId and b.LocaleId = 1)


insert into ZnodeGlobalAttributeGroupMapper (GlobalAttributeGroupId,GlobalAttributeId,AttributeDisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 GlobalAttributeGroupId from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting'),
(select top 1 GlobalAttributeId from ZnodeGlobalAttribute where AttributeCode = 'IsCloudflareEnabled'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeGlobalAttributeGroupMapper 
     where GlobalAttributeGroupId = (select top 1 GlobalAttributeGroupId from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting')
	 and GlobalAttributeId = (select top 1 GlobalAttributeId from ZnodeGlobalAttribute where AttributeCode = 'IsCloudflareEnabled'))

insert into ZnodeGlobalAttributeGroupMapper (GlobalAttributeGroupId,GlobalAttributeId,AttributeDisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 GlobalAttributeGroupId from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting'),
(select top 1 GlobalAttributeId from ZnodeGlobalAttribute where AttributeCode = 'CloudflareZoneId'),null,2,getdate(),2,getdate()
where not exists(select * from ZnodeGlobalAttributeGroupMapper 
     where GlobalAttributeGroupId = (select top 1 GlobalAttributeGroupId from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting')
	 and GlobalAttributeId = (select top 1 GlobalAttributeId from ZnodeGlobalAttribute where AttributeCode = 'CloudflareZoneId'))

	 
insert into ZnodeGlobalGroupEntityMapper(GlobalAttributeGroupId,GlobalEntityId,AttributeGroupDisplayOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 GlobalAttributeGroupId from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting'),
(select top 1 GlobalEntityId from ZnodeGlobalEntity where EntityName = 'Store'),1, 2,getdate(),2,GETDATE()
where not exists(select * from ZnodeGlobalGroupEntityMapper where GlobalAttributeGroupId=(select top 1 GlobalAttributeGroupId from ZnodeGlobalAttributeGroup where GroupCode = 'Cloudflaresetting')
      and GlobalEntityId = (select top 1 GlobalEntityId from ZnodeGlobalEntity where EntityName = 'Store'))
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Recommendation','GenerateRecommendationData',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Recommendation' and ActionName = 'GenerateRecommendationData')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Store Experience' AND ControllerName = 'StoreExperience')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Recommendation' and ActionName= 'GenerateRecommendationData') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Store Experience' AND ControllerName = 'StoreExperience') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Recommendation' and ActionName= 'GenerateRecommendationData'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Store Experience' AND ControllerName = 'StoreExperience'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Recommendation' and ActionName= 'GenerateRecommendationData')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Store Experience' AND ControllerName = 'StoreExperience') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Recommendation' and ActionName= 'GenerateRecommendationData'))

GO
if exists(select * from sys.procedures where name = 'Znode_GetPublishSingleProduct')
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
							, (SELECT TOP 1  MAX(MaxSmallWidth) FROM ZnodePortalDisplaySetting TYR WHERE TYR.PortalId = TY.PortalId)
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
SELECT ZPLP.PimParentProductId ,c.AttributeCode, '<Attributes><AttributeEntity>'+c.AttributeXML+'<AttributeValues>'+ISNULL(SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50)) 
							 FROM ZnodePublishProduct ZPPI 
							 INNER JOIN ZnodePimLinkProductDetail ZPLPI ON (ZPLPI.PimProductId = ZPPI.PimProductId)
							 WHERE ZPLPI.PimParentProductId = ZPLP.PimParentProductId
							 AND ZPLPI.PimAttributeId   = ZPLP.PimAttributeId
							 AND ZPPI.PublishCatalogId = ZPP.PublishCatalogId
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
+'<TempProfileIds>'+ISNULL(SUBSTRING( (SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
FROM ZnodeProfileCatalog ZPFC 
INNER JOIN ZnodeProfileCatalogCategory ZPCCH  ON ( ZPCCH.ProfileCatalogId = ZPFC.ProfileCatalogId )
WHERE ZPCCH.PimCatalogCategoryId = ZPCCF.PimCatalogCategoryId  FOR XML PATH('')),2,8000),'')+'</TempProfileIds><ProductIndex>'+CAST(ISNULL(ZPCP.ProductIndex,1)  AS VARCHAr(100))+'</ProductIndex><IndexId>'+CAST( ISNULL(ZPCP.PublishCategoryProductId,'0') AS VARCHAr(100))+'</IndexId>'+
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
	LEFT JOIN ZnodePimCatalogCategory ZPCCF ON (ZPCCF.PimCatalogId = ZPCV.PimCatalogId AND ZPCCF.PimCategoryId = ZPC.PimCategoryId  AND ZPCCF.PimProductId = ZPP.PimProductId AND  ZPCCF.PimCategoryHierarchyId =  ZPC.PimCategoryHierarchyId)
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
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','RemoveAllShoppingCartItems',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'RemoveAllShoppingCartItems')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveAllShoppingCartItems') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveAllShoppingCartItems'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveAllShoppingCartItems')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'OMS' AND ControllerName = 'Order') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'RemoveAllShoppingCartItems'))
go
if exists(select * from sys.procedures where name = 'Znode_GetInventoryBySkus')
	drop proc Znode_GetInventoryBySkus
go
CREATE PROCEDURE [dbo].[Znode_GetInventoryBySkus]
( @SKUs     NVARCHAR(MAX),
  @PortalId VARCHAR(2000))
AS 
  /* 
    Summary: This procedure is used to get inventory details of sku portal wise    		   
    Unit Testing   
     EXEC Znode_GetInventoryBySkus @SKUs='ap1234,LI001',@PortalId=1
 
   */ 
	 BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
           
			 Create table #TBL_SKUs (SKU NVARCHAR(MAX));
             Create table #TBL_PortalIds (PortalId INT);
			 

             INSERT INTO #TBL_SKUs 
                    SELECT item
                    FROM dbo.split(@SKUs, ',');

             INSERT INTO #TBL_PortalIds
                    SELECT item
                    FROM dbo.split(@PortalId, ',');

           
			 CREATE TABLE #TLB_SKUSumInventory 
             (SKU          VARCHAR(600),
              Quantity     NUMERIC(28, 6),
              ReOrderLevel NUMERIC(28, 6),
              PortalId     INT
             );
			 
			 CREATE TABLE #TBL_AllwareHouseToportal 
             (WarehouseId       INT,
              PortalId          INT,
              PortalWarehouseId INT,
			  Id int ----For PortalWareHouse = 1 and AlternatePortalWarehouse = 2
             );

             INSERT INTO #TBL_AllwareHouseToportal
                    SELECT zpw.WarehouseId,zp.PortalId,zpw.PortalWarehouseId, 1 as Id 
                    FROM [dbo].ZnodePortal AS zp
                         INNER JOIN [ZnodePortalWarehouse] AS zpw ON(zpw.PortalId = zp.PortalId)
                    WHERE EXISTS
                    (
                        SELECT TOP 1 1
                        FROM #TBL_PortalIds AS tp
                        WHERE tp.PortalId = zp.PortalId
                    );
             INSERT INTO #TBL_AllwareHouseToportal
                    SELECT zpaw.WarehouseId,a.PortalId,zpaw.PortalWarehouseId, 2 as Id
                    FROM [dbo].[ZnodePortalAlternateWarehouse] AS zpaw
                         INNER JOIN #TBL_AllwareHouseToportal AS a ON(zpaw.PortalWarehouseId = a.PortalWarehouseId);

			 SELECT TY.SKU,SUM(ISNULL( zi.Quantity, 0)) AS Quantity,SUM(ISNULL(Zi.ReOrderLevel, 0)) AS ReOrderLevel,zpw.PortalId
             FROM #TBL_AllwareHouseToportal AS zpw
			 CROSS APPLY #TBL_SKUs  TY 
             LEFT JOIN [dbo].[ZnodeInventory] AS ZI ON (  ZI.SKU=TY.SKU )--(SELECT ''+ZI.SKU FOR XML PATH ('')) = TY.SKU )
             where zpw.Id = 1 AND Zi.WarehouseId is null
			 GROUP BY TY.SKU, zpw.PortalId
			 Union All	
             SELECT TY.SKU,SUM(ISNULL( zi.Quantity, 0)) AS Quantity,SUM(ISNULL(Zi.ReOrderLevel, 0)) AS ReOrderLevel,zpw.PortalId
             FROM #TBL_AllwareHouseToportal AS zpw
			 CROSS APPLY #TBL_SKUs  TY 
             LEFT JOIN [dbo].[ZnodeInventory] AS ZI ON (  ISNULL(Zi.WarehouseId,-1) = CASE WHEN ISNULL(Zi.WarehouseId,-1) = -1 THEN -1 ELSE  zpw.WarehouseId END  AND   ZI.SKU=TY.SKU )--(SELECT ''+ZI.SKU FOR XML PATH ('')) = TY.SKU )
             where Zi.WarehouseId is not null
			 GROUP BY TY.SKU, zpw.PortalId;
                     
         END TRY
         BEGIN CATCH
            DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetInventoryBySkus @SKUs = '+@SKUs+',@PortalId='+@PortalId+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		    
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetInventoryBySkus',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;

go
insert into ZnodeMenu(ParentMenuId,MenuName,MenuSequence,AreaName,ControllerName,ActionName,CSSClassName,IsActive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select Top 1 MenuId from ZnodeMenu where MenuName = 'Reports'),'Analytics',3,null,'Analytics','AnalyticsDashboard','z-analytics-report',1,
2,getdate(),2,getdate()
where not exists(select * from ZnodeMenu where MenuName = 'Analytics')

go

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Analytics','AnalyticsDashboard',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Analytics' and ActionName = 'AnalyticsDashboard')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Analytics' AND ControllerName = 'Analytics')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Analytics' and ActionName= 'AnalyticsDashboard') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Analytics' AND ControllerName = 'Analytics') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Analytics' and ActionName= 'AnalyticsDashboard'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Analytics' AND ControllerName = 'Analytics'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Analytics' and ActionName= 'AnalyticsDashboard')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Analytics' AND ControllerName = 'Analytics') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Analytics' and ActionName= 'AnalyticsDashboard'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'GeneralSetting','GetAnalyticsData',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName = 'GetAnalyticsData')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'GetAnalyticsData') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'GetAnalyticsData'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'GetAnalyticsData')	
,1,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'GetAnalyticsData'))

GO

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'GeneralSetting','UpdateAnalyticsData',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName = 'UpdateAnalyticsData')


insert into ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
 (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting')	
    ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'UpdateAnalyticsData') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId = 
     (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting') and ActionId = 
     (select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'UpdateAnalyticsData'))

insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'UpdateAnalyticsData')	
,2,2,Getdate(),2,Getdate() where not exists 
(select * from ZnodeMenuActionsPermission where MenuId = 
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Global Settings' AND ControllerName = 'GeneralSetting') and ActionId = 
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'GeneralSetting' and ActionName= 'UpdateAnalyticsData'))
go
if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ZnodeGlobalSetting' and COLUMN_NAME = 'FeatureValues')
begin
	alter table ZnodeGlobalSetting alter column [FeatureValues] NVARCHAR (MAX) NULL
end
GO
insert into ZnodeGlobalSetting(FeatureName,FeatureValues,FeatureSubValues,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'AnalyticsJSONKey','',
null,2,getdate(),2,getdate()
where not exists(select * from ZnodeGlobalSetting where FeatureName = 'AnalyticsJSONKey')

go
if exists(select * from sys.procedures where name = 'Znode_ImportPriceList')
	drop proc Znode_ImportPriceList
go
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
			(SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL,
			Custom1 varchar(300) NULL, Custom2 varchar(300) NULL, Custom3 varchar(300) NULL,CostPrice varchar(100), RowNumber varchar(300) NULL)
	
		--DECLARE #InsertPriceForValidation TABLE
		--( 
		--	SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL, RowNumber varchar(300) NULL
		--);
		IF OBJECT_ID('#InsertPrice', 'U') IS NOT NULL 
			DROP TABLE #InsertPrice
		ELSE 
			CREATE TABLE #InsertPrice 
			( 
				SKU varchar(300), TierStartQuantity numeric(28, 6) NULL, RetailPrice numeric(28, 6) NULL, SalesPrice numeric(28, 6) NULL, TierPrice numeric(28, 6) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL,
				Custom1 varchar(300) NULL, Custom2 varchar(300) NULL, Custom3 varchar(300) NULL,CostPrice numeric(28, 6), RowNumber varchar(300)
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
		

		SET @SSQL = 'Select SKU,TierStartQuantity ,RetailPrice,SalesPrice,TierPrice,SKUActivationDate ,SKUExpirationDate ,
		 Custom1, Custom2, Custom3,CostPrice, RowNumber FROM '+@TableName;
		INSERT INTO #InsertPriceForValidation( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate,
		 Custom1, Custom2, Custom3,CostPrice, RowNumber )
		EXEC sys.sp_sqlexec @SSQL;

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'TierPrice', TierPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(TierPrice)=0  
				or exists(select * from ZnodeCulture where Symbol is not null and TierPrice like '%'+Symbol+'%')) and ISNULL(TierPrice,'')<>''
		
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'SalesPrice', SalesPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(SalesPrice)=0	or exists(select * from ZnodeCulture where Symbol is not null and SalesPrice like '%'+Symbol+'%'))
				and ISNULL(SalesPrice,'')<>''

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'RetailPrice', RetailPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(RetailPrice)=0 or exists(select * from ZnodeCulture where Symbol is not null and RetailPrice like '%'+Symbol+'%')) and ISNULL(RetailPrice,'')<>''
		
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'CostPrice', CostPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(CostPrice)=0	or exists(select * from ZnodeCulture where Symbol is not null and CostPrice like '%'+Symbol+'%'))
				and ISNULL(CostPrice,'')<>''
		
		UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ SKU - ' + ISNULL(SKU,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN #InsertPriceForValidation IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL
			   			  	
	    --- Delete Invalid Data after functional validation 
		DELETE FROM #InsertPriceForValidation
		WHERE RowNumber IN
		(
			SELECT DISTINCT 
				   RowNumber
			FROM ZnodeImportLog
			WHERE ImportProcessLogId = @ImportProcessLogId AND 
				  Guid = @NewGUId
		);
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
		
		INSERT INTO #InsertPrice( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate,
		 Custom1, Custom2, Custom3,CostPrice, RowNumber )
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
															  END, SKUActivationDate, SKUExpirationDate,
															   Custom1, Custom2, Custom3,
															   CASE
															  WHEN CostPrice = '' THEN NULL
															  ELSE CONVERT(numeric(28, 6), CostPrice)
															  END, RowNumber
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

			
		--INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
		--	   SELECT '26', 'RetailPrice', RetailPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
		--	   FROM #InsertPriceForValidation
		--	   WHERE ISNULL(CAST(RetailPrice AS numeric(28, 6)), 0) <= 0 AND 
		--			 RetailPrice <> '';
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '39', 'SKUActivationDate', SKUActivationDate, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPrice AS IP
			   WHERE SKUActivationDate > SKUExpirationDate AND 
					 ISNULL(SKUExpirationDate, '') <> '';
					 
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation
			   WHERE( TierPrice IS NULL OR TierPrice = '0') AND  TierStartQuantity  = '';
			  
			  
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '35', 'TierPrice', TierPrice, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation WHERE( TierPrice IS NULL OR  TierPrice = '') AND TierStartQuantity  <> 0;

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation IPV
			   WHERE TierStartQuantity = ''  
				AND	( TierPrice <> ''  OR TierPrice IS NULL ) 

			  
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
			   SELECT '26', 'TierStartQuantity', TierStartQuantity, @NewGUId, RowNumber, 2, @GetDate, 2, @GetDate, @ImportProcessLogId
			   FROM #InsertPriceForValidation IPV
			   WHERE TierStartQuantity <> '' AND 
			    ISNULL(CAST(TierStartQuantity AS numeric(28, 6)), 0) <= 0 
				AND	( TierPrice <> ''  OR TierPrice IS NULL ) 
		
		
				  
		UPDATE ZIL
			   SET ZIL.ColumnName =   ZIL.ColumnName + ' [ SKU - ' + ISNULL(SKU,'') + ' ] '
			   FROM ZnodeImportLog ZIL 
			   INNER JOIN #InsertPrice IPA ON (ZIL.RowNumber = IPA.RowNumber)
			   WHERE  ZIL.ImportProcessLogId = @ImportProcessLogId AND ZIL.RowNumber IS NOT NULL

			 
 	
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

		UPDATE ZnodeImportProcessLog SET FailedRecordcount = @FailedRecordCount , SuccessRecordCount = @SuccessRecordCount,
		TotalProcessedRecords = (ISNULL(@FailedRecordCount,0) + ISNULL(@SuccessRecordCount,0)) 
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
				END, ZP.ModifiedBy = @UserId, ZP.ModifiedDate = @GetDate,
				ZP.CostPrice =IP.CostPrice
		FROM #InsertPrice IP INNER JOIN ZnodePrice ZP ON ZP.PriceListId = @PriceListId AND  ZP.SKU = IP.SKU  
			 --Retrive last record from price list of specific SKU ListCode and Name 									
		WHERE IP.RowNumber IN
		(
			SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU 
		);
		INSERT INTO ZnodePrice( PriceListId, SKU, SalesPrice, RetailPrice, ActivationDate, ExpirationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,CostPrice )
			   SELECT @PriceListId, IP.SKU, IP.SalesPrice, IP.RetailPrice,
																						   CASE
																						   WHEN ISNULL(IP.SKUActivationDate, '') = '' THEN NULL
																						   ELSE IP.SKUActivationDate
																						   END,
																						   CASE
																						   WHEN ISNULL(IP.SKUExpirationDate, '') = '' THEN NULL
																						   ELSE IP.SKUExpirationDate
																						   END, @UserId, @GetDate, @UserId, @GetDate,IP.CostPrice
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
				  (CONVERT(varchar(100), TierPrice) <> '' OR CONVERT (varchar(100), TierPrice) IS NOT NULL)
		)
		BEGIN
		
			UPDATE ZPT
			  SET ZPT.Price = IP.TierPrice, ZPT.ModifiedBy = @UserId, ZPT.ModifiedDate = @GetDate,
			  ZPT.Custom1 = IP.Custom1,ZPT.Custom2 = IP.Custom2, ZPT.Custom3 = IP.Custom3 
			FROM #InsertPrice IP INNER JOIN ZnodePriceTier ZPT ON ZPT.PriceListId = @PriceListId AND  ZPT.SKU = IP.SKU AND ZPT.Quantity = IP.TierStartQuantity 
		    --Retrive last record from price list of specific SKU ListCode and Name 
			WHERE IP.RowNumber IN
			(
				SELECT MAX(IPI.RowNumber) FROM #InsertPrice AS IPI WHERE IPI.SKU = IP.SKU AND IPI.TierStartQuantity = IP.TierStartQuantity 
			);

			INSERT INTO ZnodePriceTier( PriceListId, SKU, Price, Quantity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, Custom1, Custom2, Custom3 )
				   SELECT @PriceListId, IP.SKU, IP.TierPrice, IP.TierStartQuantity,  @UserId, @GetDate, @UserId, @GetDate, Custom1, Custom2, Custom3
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
		  SET Status = dbo.Fn_GetImportStatus( 2 ), ProcessCompletedDate = GETDATE()
		WHERE ImportProcessLogId = @ImportProcessLogId;
		-- COMMIT TRAN ImportProducts;
		COMMIT TRAN A;
	END TRY
	BEGIN CATCH
		
		SET @Status = 0;
		SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_PROCEDURE();
		ROLLBACK TRAN A;
	END CATCH;
END;
GO
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdateShippingAccountNumber',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdateShippingAccountNumber')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingAccountNumber') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingAccountNumber'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') ,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingAccountNumber')
,3,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingAccountNumber'))


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdateShippingMethod',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdateShippingMethod')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') ,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod')
,3,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod'))
go
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="UTF-8"?><columns><column><id>1</id><name>UserId</name><headertext>Checkbox</headertext><width>40</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield /><ischeckbox>y</ischeckbox><checkboxparamfield>UserId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext /><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>FullName</name><headertext>Full Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>false</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Full Name</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>6</id><name>UserName</name><headertext>Username</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>false</allowpaging><format /><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>User Name</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>Email</name><headertext>Email ID</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Email Id</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>7</id><name>RoleName</name><headertext>Role Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Phone Number</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>8</id><name>DepartmentName</name><headertext>Department</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Phone Number</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>10</id><name>Manage</name><headertext>Pending Order History</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format>View</format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>View</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl>/Account/AccountQuoteList</manageactionurl><manageparamfield>UserId,AccountId</manageparamfield><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class>grid-action</Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>11</id><name>Manage</name><headertext>Order History</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format>View</format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>View</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl>/Account/AccountUserOrderList</manageactionurl><manageparamfield>UserId,AccountId</manageparamfield><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class>grid-action</Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>12</id><name>Manage</name><headertext>Action</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format>Manage|Disable|Delete</format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Manage|Disable|Delete</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl>/Customer/CustomerEdit|/User/CustomerEnableDisableAccount|/User/CustomerDelete</manageactionurl><manageparamfield>UserId|UserId,IsLock|UserId</manageparamfield><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class>grid-action</Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>13</id><name>LastName</name><headertext>Last Name</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format /><isvisible>n</isvisible><mustshow>n</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Last Name</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>14</id><name>IsLock</name><headertext>Is Lock</headertext><width>40</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format /><isvisible>n</isvisible><mustshow>n</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Is Lock</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>15</id><name>AccountId</name><headertext>User ID</headertext><width>40</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>false</allowpaging><format /><isvisible>n</isvisible><mustshow>n</mustshow><musthide>y</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl /><islinkparamfield>AccountId</islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield>AccountId</checkboxparamfield><iscontrol>n</iscontrol><controltype /><controlparamfield /><displaytext>Is Lock</displaytext><editactionurl /><editparamfield /><deleteactionurl /><deleteparamfield /><viewactionurl /><viewparamfield /><imageactionurl /><imageparamfield /><manageactionurl /><manageparamfield /><copyactionurl /><copyparamfield /><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>n</isadvancesearch><Class /><SearchControlType>--Select--</SearchControlType><SearchControlParameters /><DbParamField /><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
where ItemName = 'ZnodeAccountsCustomer'
GO

if exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemBundle')
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
    DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT ) 	

	INSERT INTO @TBL_Personalise
	SELECT  NULL 
				,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @SaveCartLineItemType TRTR  ) a 
	CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
	 
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
			Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on ( a.BundleProductIds = b.SKU or a.SKU = b.sku)
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') <> ''
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
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.SKU = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.BundleProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
		a.Custom5 = ty.Custom5  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon

		 --UPDATE Ab SET ab.Quantity = a.Quantity   
   --      FROM ZnodeOmsSavedCartLineItem a  
   --      INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
   --      INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  )   
		 --WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  

		 UPDATE Ab 
		 SET Ab.Quantity = Ab.Quantity+ty.Quantity,
		 Ab.Custom1 = ty.Custom1,
		 Ab.Custom2 = ty.Custom2,
		 Ab.Custom3 = ty.Custom3,
		 Ab.Custom4 = ty.Custom4,
		 Ab.Custom5 = ty.Custom5  
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
  
 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
	INTO #Cte_newData 
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
    --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL  
	AND  EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) 
  
  --------------------------------------------------------------------------------------------------------

   --;with Cte_newData AS   
   -- (  
    SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData1
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
   -- )

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

    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = b.id OR b.Id = 1  ))  
    INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
    WHERE ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = ISNULL(a.ParentOmsSavedCartLineItemId,0) OR ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  AND c.ParentOmsSavedCartLineItemId IS NULL
  --  )   
  
 

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
    UPDATE a SET a.Quantity =  NULL   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
    WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
     AND a.OrderLineItemRelationshipTypeId IS NULL   
  
    UPDATE Ab SET ab.Quantity = a.Quantity   
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
if exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemGroup')
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
    DECLARE @TBL_Personalise TABLE (SKU varchar(600),OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	DECLARE @OmsInsertedData TABLE (SKU varchar(600),OmsSavedCartLineItemId INT ) 	

	INSERT INTO @TBL_Personalise
	select a.GroupProductIds, null,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	from @SaveCartLineItemType a
	CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 
	--INSERT INTO @TBL_Personalise
	--SELECT  NULL 
	--			,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
	--		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
	--		,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
	--		,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	--FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @SaveCartLineItemType TRTR  ) a 
	--CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
	 
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
	  	FROM ZnodeOmsSavedCartLineItem a   
		WHERE EXISTS (SELECT TOP 1 1 FROM @SaveCartLineItemType  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.GroupProductIds,'')   )   
        AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdGroup   

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
		 AND (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem  t WHERE t.ParentOmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId AND   t.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) = (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  
		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ParentOmsSavedCartLineItemId FROM  @parenTofAddon)   
					AND ParentOmsSavedCartLineItemId IS NOT NULL  
					AND OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon

		 DELETE FROM #OldValue WHERE OmsSavedCartLineItemId NOT IN (SELECT ISNULL(m.ParentOmsSavedCartLineItemId,0) FROM #OldValue m)
		 AND ParentOmsSavedCartLineItemId IS  NULL  
		 

		  IF (SELECT COUNT (DISTINCT SKU ) FROM  #OldValue  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
		  BEGIN 
		    DELETE FROM #OldValue
		  END 
		 IF (SELECT COUNT (DISTINCT SKU ) FROM  ZnodeOmsSavedCartLineItem   WHERE ParentOmsSavedCartLineItemId IN (SELECT ParentOmsSavedCartLineItemId FROM @parenTofAddon)AND   OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon ) <> (SELECT COUNT (DISTINCT SKU ) FROM  #tempoi  WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  )
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
			FROM ZnodeOmsSavedCartLineItem a 
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
			Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on ( a.BundleProductIds = b.SKU or a.SKU = b.sku)
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') <> ''
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
			SELECT b.OmsSavedCartLineItemId ,b.ParentOmsSavedCartLineItemId , a.GroupProductIds as SKU
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.GroupProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
			SELECT b.OmsSavedCartLineItemId ,a.ParentOmsSavedCartLineItemId , a.GroupProductIds as SKU
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.GroupProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
		a.Custom5 = ty.Custom5  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity
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
       	    --select * from #yuuete
			
			 
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
  
 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
	INTO  #Cte_newData
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID	  
	 --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL   
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
  
  -----------------------------------------------------------------------------------------------------------------------------------

  	 --;with Cte_newData AS   
    --(  
    SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData1
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID	  
	 --)

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

    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
    INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
	WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) and c.ParentOmsSavedCartLineItemId is null
  --  )   
  
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
    UPDATE a SET a.Quantity =  NULL   
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
if exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemQuantity')
	drop proc Znode_InsertUpdateSaveCartLineItemQuantity
go

CREATE PROCEDURE [dbo].[Znode_InsertUpdateSaveCartLineItemQuantity](
	  @CartLineItemXML xml, @UserId int,@Status bit OUT )
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
		INSERT INTO @TBL_SavecartLineitems( RowId,OmsSavedCartLineItemId, ParentOmsSavedCartLineItemId, OmsSavedCartId, SKU, Quantity, OrderLineItemRelationshipTypeID, CustomText, CartAddOnDetails, Sequence, AddOnValueIds, BundleProductIds, ConfigurableProductIds, GroupProductIds, PersonalisedAttribute, AutoAddon, OmsOrderId, ItemDetails,
		Custom1,Custom2,Custom3,Custom4,Custom5,GroupId,ProductName,Description,AddOnQuantity )
			   SELECT DENSE_RANK()Over(Order BY Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' )) RowId ,Tbl.Col.value( 'OmsSavedCartLineItemId[1]', 'NVARCHAR(2000)' ) AS OmsSavedCartLineItemId, Tbl.Col.value( 'ParentOmsSavedCartLineItemId[1]', 'NVARCHAR(2000)' ) AS ParentOmsSavedCartLineItemId, Tbl.Col.value( 'OmsSavedCartId[1]', 'NVARCHAR(2000)' ) AS OmsSavedCartId, Tbl.Col.value( 'SKU[1]', 'NVARCHAR(2000)' ) AS SKU, Tbl.Col.value( 'Quantity[1]', 'NVARCHAR(2000)' ) AS Quantity
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
					WHERE ( OmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					OR ParentOmsSavedCartLineItemId =  @OmsSavedCartLineItemId   ) 
					 
					--UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE BundleProductIds <> '' AND OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
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
					WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId
					
					--UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE  ConfigurableProductIds <> '' AND OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
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
					
					--UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE GroupProductIds <> '' AND  OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
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
					WHERE OmsSavedCartLineItemId = @OmsSavedCartLineItemId
				
				 --   UPDATE ZnodeOmsSavedCartLineItem 
					--SET Quantity = (SELECT TOP 1 AddOnQuantity FROM @TBL_SavecartLineitems WHERE  OmsSavedCartLineItemId <> 0)
					--WHERE ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId  
					--AND OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					UPDATE ZnodeOmsSavedCartLineItem 
					SET Quantity = AddOnQuantity
					FROM ZnodeOmsSavedCartLineItem ZOSCLI
					INNER JOIN @TBL_SavecartLineitems SCLI ON ZOSCLI.ParentOmsSavedCartLineItemId = @OmsSavedCartLineItemId AND ZOSCLI.OmsSavedCartId = SCLI.OmsSavedCartId AND ZOSCLI.SKU = SCLI.AddOnValueIds
					WHERE ZOSCLI.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon
					
					DELETE	FROM @TBL_SavecartLineitems WHERE OmsSavedCartLineItemId <> 0
				 END 
			 
			

			  DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT )
			  DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
			  INSERT INTO @TBL_Personalise
			  SELECT  NULL 
							,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		  ,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					  ,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					  ,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			  FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @TBL_SavecartLineitems TRTR  ) a 
			  CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 
			  
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
		    
			
			  CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
				   
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
           --hack
		
		 CREATE TABLE #OldValue (OmsSavedCartId INT ,OmsSavedCartLineItemId INT,ParentOmsSavedCartLineItemId INT , SKU  NVARCHAr(2000),OrderLineItemRelationshipTypeID INT  )
		 
		INSERT INTO #OldValue  
		SELECT  a.OmsSavedCartId,a.OmsSavedCartLineItemId,a.ParentOmsSavedCartLineItemId , a.SKU  ,a.OrderLineItemRelationshipTypeID 
	  	FROM ZnodeOmsSavedCartLineItem a   
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = a.OmsSavedCartId AND ISNULL(a.SKU,'') = ISNULL(TY.SKU,'')   )   
        AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple   

			

		INSERT INTO #OldValue 
		SELECT DISTINCT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.ParentOmsSavedCartLineItemId  = b.OmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.SKU,'') AND ISNULL(b.Groupid,'-') = ISNULL(TY.Groupid,'-')  )
		AND  b.OrderLineItemRelationshipTypeID IS NULL 
		 
		DELETE a FROM #OldValue a WHERE NOT EXISTS (SELECT TOP 1 1  FROM #OldValue b WHERE b.ParentOmsSavedCartLineItemId IS NULL AND b.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)
		AND a.ParentOmsSavedCartLineItemId IS NOT NULL 
		
		------Merge Addon for same product
		SELECT * INTO #OldValueForAddon from #OldValue
		
		INSERT INTO #OldValue 
		SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
		FROM ZnodeOmsSavedCartLineItem b 
		INNER JOIN #OldValue c ON (c.OmsSavedCartLineItemId  = b.ParentOmsSavedCartLineItemId AND c.OmsSavedCartId = b.OmsSavedCartId)
		WHERE EXISTS (SELECT TOP 1 1 FROM @TBL_SavecartLineitems  TY WHERE TY.OmsSavedCartId = b.OmsSavedCartId AND ISNULL(b.SKU,'') = ISNULL(TY.AddOnValueIds,'') )
		AND  b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon

		
		
		------Merge Addon for same product
		IF EXISTS(SELECT * FROM @TBL_SavecartLineitems WHERE ISNULL(AddOnValueIds,'') <> '' )
		BEGIN

			INSERT INTO #OldValueForAddon 
			SELECT b.OmsSavedCartId,b.OmsSavedCartLineItemId,b.ParentOmsSavedCartLineItemId , b.SKU  ,b.OrderLineItemRelationshipTypeID  
			FROM ZnodeOmsSavedCartLineItem b 
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

		 -- SELECT 3
		    DECLARE @TBL_deleteParentOmsSavedCartLineItemId TABLE (OmsSavedCartLineItemId INT )
			INSERT INTO @TBL_deleteParentOmsSavedCartLineItemId 
			SELECT ParentOmsSavedCartLineItemId
			FROM ZnodeOmsSavedCartLineItem a 
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
			Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			FROM @TBL_SavecartLineitems a 
			Inner Join #OldValue b on ( a.SKU = b.sku)
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') <> ''
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
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @TBL_SavecartLineitems a 
			Inner Join #OldValue b on a.SKU = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @TBL_SavecartLineitems a 
			Inner Join #OldValue b on a.SKU = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
		a.Custom5 = ty.Custom5
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

 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID
				
    --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL   
  

    
    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( b.Id = 1  ))  
	INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1 
    WHERE ( ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  and c.ParentOmsSavedCartLineItemId is null
  --  )   
  


  --  SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 --FROM ZnodeOmsSavedCartLineItem a
	 --WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
  --   AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
  --   AND a.ParentOmsSavedCartLineItemId IS NULL  
	 --AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 --AND EXISTS (SELECT TOP 1 1 FROM #Cte_newAddon TI WHERE TI.SKU = a.SKU)



   ;with table_update AS 
   (
     SELECT * , ROW_NUMBER()Over(Order BY OmsSavedCartLineItemId  ) RowIdNo
	 FROM ZnodeOmsSavedCartLineItem a
	 WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
     AND a.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  
     AND a.ParentOmsSavedCartLineItemId IS NULL  
	 AND EXISTS (SELECT TOP 1 1  FROM  #yuuete ty WHERE ty.OmsSavedCartId = a.OmsSavedCartId )
	 AND EXISTS (SELECT TOP 1 1 FROM #Cte_newAddon TI WHERE TI.SKU = a.SKU)
   )

    UPDATE a SET  
   --SELECT  a.OmsSavedCartLineItemId,
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
    UPDATE a SET a.Quantity =  NULL   
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

	
	SET @Status = 1;
	COMMIT TRAN InsertUpdateSaveCartLineItem;
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()	
		SET @Status = 0;
		DECLARE @Error_procedure varchar(1000)= ERROR_PROCEDURE(), @ErrorMessage nvarchar(max)= ERROR_MESSAGE(), @ErrorLine varchar(100)= ERROR_LINE(), @ErrorCall nvarchar(max)= 'EXEC Znode_InsertUpdateSaveCartLineItem @CartLineItemXML = '+CAST(@CartLineItemXML
 AS varchar(max))+',@UserId = '+CAST(@UserId AS varchar(50))+',@Status='+CAST(@Status AS varchar(10));

		SELECT 0 AS ID, CAST(0 AS bit) AS Status,ERROR_MESSAGE();
		ROLLBACK TRAN InsertUpdateSaveCartLineItem;
		EXEC Znode_InsertProcedureErrorLog @ProcedureName = 'Znode_InsertUpdateSaveCartLineItem', @ErrorInProcedure = @Error_procedure, @ErrorMessage = @ErrorMessage, @ErrorLine = @ErrorLine, @ErrorCall = @ErrorCall;
	END CATCH;
END;
go
update c set Message = '<div class="row">  <div class="col-12 col-md-6 col-lg-12 p-3 promo-one"><img class="img-fluid w-100" src="http://api9x.znodellc.com/Data/Media/1f0b6a6e-9e09-445a-b314-75f1bbee5abb10percent-Dewalt.png" alt="" /></div>  <div class="col-12 col-md-6 col-lg-12 p-3"><img class="img-fluid w-100" src="http://api9x.znodellc.com/Data/Media/9c27a9ad-339f-43b9-847c-41a12d2a37f0freebattery-mketool.png" alt="" /></div>  <div class="col-12 col-md-6 col-lg-12 p-3"><img class="img-fluid w-100" src="http://api9x.znodellc.com/Data/Media/1f0b6a6e-9e09-445a-b314-75f1bbee5abb10percent-Dewalt.png" alt="" /></div>  </div>' 
from ZnodeCMSMessageKey a
inner join ZnodeCMSPortalMessage b on a.CMSMessageKeyId = b.CMSMessageKeyId
inner join ZnodeCMSMessage c on b.CMSMessageId = c.CMSMessageId
where a.MessageKey = 'PromoSpot'
go
update ZnodeGlobalAttribute set IsRequired = 0 where AttributeCode = 'CloudflareZoneId'
go
update a set Content = '<!DOCTYPE html><html><body><p>&nbsp;</p>  <div>  <div style="font-family: Arial, Helvetica; font-size: 10px; text-align: left; color: #292a2a; border: solid 1px #c3c3c3; margin-top: 10px;">  <div style="background-color: #eff3fb; color: #292a2a; font-size: 1.5em; font-weight: bold; padding: .5em; border-bottom: solid 1px #c3c3c3;">#StoreLogo# #SiteName#&nbsp;Customer Receipt</div>  <div style="padding: 10px;">  <div style="font-family: Verdana; color: #333333; font-size: 11px;">#ReceiptText#</div>  <table style="font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" border="0" width="100%" cellspacing="3" cellpadding="0">  <tbody>  <tr>  <td colspan="5"><hr /></td>  </tr>  <tr>  <td colspan="2" align="left" nowrap="nowrap" width="25%">  <div style="color: #292a2a; font-weight: bold; font-size: 11px; padding-bottom: 5px;">Order Information</div>  </td>  <td colspan="2" align="left" nowrap="nowrap">  <div style="color: #292a2a; font-weight: bold; font-size: 11px; padding-bottom: 5px;">Customer Service</div>  </td>  </tr>  <tr>  <td align="left" nowrap="nowrap" width="10%"><strong>Order Number:</strong></td>  <td align="left" nowrap="nowrap" width="30%">#OrderId#</td>  <td align="left" nowrap="nowrap" width="10%"><strong>E-Mail:</strong></td>  <td align="left" nowrap="nowrap">#CustomerServiceEmail#</td>  </tr>  <tr>  <td align="left" nowrap="nowrap"><strong>Order Date:</strong></td>  <td align="left" nowrap="nowrap">#OrderDate#</td>  <td align="left" nowrap="nowrap"><strong>Phone:</strong></td>  <td align="left" nowrap="nowrap">#CustomerServicePhoneNumber#</td>  </tr>  <tr>  <td style="vertical-align: top;" align="left" nowrap="nowrap"><strong>Promotion Code:</strong></td>  <td align="left" nowrap="nowrap">#PromotionCode#</td>  <td align="left" nowrap="nowrap"><strong>Account Name:</strong></td>  <td align="left" nowrap="nowrap">#AccountName#</td>  </tr>  <tr>  <td align="left" nowrap="nowrap"><strong>Payment Method:</strong></td>  <td align="left" nowrap="nowrap">#PaymentName#</td>  <td>&nbsp;</td>  <td>&nbsp;</td>  </tr>  <tr>  <td align="left" nowrap="nowrap"><strong>#CardTransactionLabel#</strong></td>  <td align="left" nowrap="nowrap">#CardTransactionID#</td>  <td>&nbsp;</td>  <td>&nbsp;</td>  </tr>  <tr>  <td align="left" nowrap="nowrap"><strong>#PurchaseNumberLabel#</strong></td>  <td align="left" nowrap="nowrap">#PONumber#</td>  <td>&nbsp;</td>  <td>&nbsp;</td>  </tr>  <tr>  <td colspan="4"><hr /></td>  </tr>  <tr>  <td style="font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" colspan="2" align="left" nowrap="nowrap" width="45%">  <div style="color: #292a2a; font-weight: bold; font-size: 11px; padding-bottom: 5px;">Billing Address</div>  </td>  <td colspan="2" align="left">  <div style="color: #292a2a; font-weight: bold; font-size: 11px; padding-bottom: 5px;">Shipping Address</div>  </td>  </tr>  <tr>  <td colspan="2" align="Left" nowrap="nowrap">#BillingAddress#</td>  <td colspan="3" valign="top">#ShippingAddress#</td>  </tr>  <tr>  <td colspan="7">&nbsp;</td>  </tr>  </tbody>  </table>  <div data-info="#AddressItems#">  <table width="100%" cellspacing="0" cellpadding="3">  <tbody>  <tr>  <td style="color: #292a2a; font-weight: bold; font-size: 11px; padding-bottom: 5px;" colspan="6">#ShipmentNo#</td>  </tr>  <tr>  <td style="color: black; font-size: 10px;" colspan="6">#ShipTo#</td>  </tr>  <tr style="background-color: #eff3fb;">  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;"><strong>SKU</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;"><strong>Item</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;"><strong>Description</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" align="center"><strong>Qty</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;"><strong>Price</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;"><strong>Total</strong></td>  </tr>  <tr data-info="#LineItems#OmsOrderShipmentID##">  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" align="left" width="10%">#SKU#&nbsp;</td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" align="left" width="25%">#Name#</td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" align="left" width="25%">#Description#&nbsp;  <p>#ShortDescription#</p>  #UOMDescription#<br /><br />#Column1#</td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" align="center" width="5%">#Quantity#</td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" align="left" width="20%">#Price#</td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; min-width: 170px; padding: 0 5px;" align="right" width="20%">#ExtendedPrice#</td>  </tr>  <tr data-info="#AmountLineItems#OmsOrderShipmentID##">  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" colspan="5" align="right"><strong>#Title#</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; min-width: 170px; padding: 0 5px;" align="right" width="20%">#Amount#</td>  </tr>  <tr data-info="#GrandAmountLineItems#">  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; padding: 0 5px;" colspan="5" align="right"><strong>#Title#</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; min-width: 170px; padding: 0 5px;" align="right" width="20%">#Amount#</td>  </tr>  <tr>  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #292a2a; font-size: 11px; padding: 0 5px 5px 5px;" colspan="5" align="right"><strong>Total</strong></td>  <td style="border: silver 1px solid; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px; min-width: 170px; padding: 0 5px;" align="right" width="20%"><strong>#TotalCost#</strong></td>  </tr>  </tbody>  </table>  </div>  <table style="width: 100%; padding: 10px; display: inline-block;" cellspacing="0" cellpadding="3">  <tbody>  <tr>  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" colspan="2" align="left" nowrap="nowrap">  <div style="color: #292a2a; font-weight: bold; font-size: 11px; padding-bottom: 5px;">#AdditionalInstructLabel#</div>  </td>  </tr>  <tr>  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" colspan="2">  <div style="width: 675px;" align="justify">#AdditionalInstructions#</div>  </td>  </tr>  <tr>  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" colspan="2">  <div style="margin-bottom: 5px;">&nbsp;</div>  </td>  </tr>  <tr>  <td style="border: none; font-family: Verdana, Helvetica, sans-serif; color: #333333; font-size: 10px;" colspan="2" align="left" nowrap="nowrap">#FeedBack#</td>  </tr>  </tbody>  </table>  </div>  </div>  </div></body></html>'
from ZnodeEmailTemplateLocale a
inner join ZnodeEmailTemplate b on a.EmailTemplateId = b.EmailTemplateId
where TemplateName = 'OrderReceipt' and a.LocaleId = 1
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Order','UpdateShippingMethod',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Order' and ActionName = 'UpdateShippingMethod')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order')
,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') ,
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod')
,3,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Orders' AND ControllerName = 'Order') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Order' and ActionName= 'UpdateShippingMethod'))
go
update b set Content = '<!DOCTYPE html><html><body><p>&nbsp;</p>  <table style="display: table; border: 1px solid #af0604;" border="0" width="75%" cellspacing="0" cellpadding="0" align="center" bgcolor="#ffffff">  <tbody><!--Header-->  <tr>  <td align="left" valign="top" width="100%">  <table border="0" width="100%" cellspacing="0" cellpadding="0" align="center" bgcolor="#FFFFFF">  <tbody>  <tr style="border-bottom: 0;" bgcolor="#ffffff">  <td align="left" valign="top">  <table border="0" width="100%" cellspacing="0" cellpadding="0">  <tbody>  <tr style="background-color: #ffffff;">  <td style="padding-left: 10px; padding-top: 15px;" align="left" valign="top" width="300"><img class="CToWUd" style="display: block;" src="#StoreLogo#" width="200" height="70" border="0" /></td>  <td style="padding: 15px 10px 10px 0;" align="right" valign="top" width="350">  <p style="font-size: 17px; font-family: Arial,Helvetica; color: #af0604; font-weight: 800; padding: 10px 0 10px 0; margin: 0;">#CustomerServicePhoneNumber#</p>  <p style="font-size: 17px; font-family: Arial,Helvetica; font-weight: 800; padding: 5px 0; margin: 0;"><a style="color: #af0604; text-decoration: none; padding-bottom: 10px;" href="mailto:#CustomerServiceEmail#" target="_blank">#CustomerServiceEmail#</a></p>  </td>  </tr>  <tr style="background-color: #af0604;">  <td align="left" valign="top" width="350" height="5">&nbsp;</td>  <td align="right" valign="bottom" width="300" height="5">&nbsp;</td>  </tr>  </tbody>  </table>  </td>  </tr>  </tbody>  </table>  </td>  </tr>  <tr>  <td id="#ComparedProducts#" style="float: left; width: 25%;"><!--Product-Container-->  <div style="float: left; width: 100%; min-height: 300px; font-size: 12px; padding: 10px 5px;">  <div>#Image#</div>  <div style="padding: 5px; width: 100%;">  <div style="color: #af0604; font-weight: bold;">Product Name</div>  <div>#ProductName#</div>  </div>  <div style="padding: 5px; width: 100%;">  <div style="color: #af0604; font-weight: bold;">Price</div>  <div>#Price#</div>  </div>  <div style="padding: 5px; width: 100%;">  <div style="color: #af0604; font-weight: bold;">Variants</div>  <div>#Variants#</div>  </div>  DyanamicHtml</div>  </td>  </tr>  <!--Footer-->  <tr bgcolor="#ffffff">  <td style="padding: 10px 0 10px 0; background: #af0604;" align="center" valign="middle">  <p style="font-family: Arial,Helvetica; font-size: 14px; font-style: italic; text-align: center; color: #fff; margin: 0; padding: 0;"><span style="font-size: small;">Copyright @ 2020 Maxwell''s Inc. All Rights Reserved.</span></p>  </td>  </tr>  </tbody>  </table></body></html>'
from ZnodeEmailTemplate a
inner join ZnodeEmailTemplateLocale b on a.EmailTemplateId = b.EmailTemplateId
where a.TemplateName = 'ProductCompare'
GO
update c set message = replace(replace(message,'2019','2020'),'2018','2020')
from ZnodeCMSPortalMessage a
inner join znodecmsmessagekey b on a.CMSMessageKeyId = b.CMSMessageKeyId
inner join znodecmsmessage c on a.CMSMessageId = c.CMSMessageId
 where b.messagekey = 'FooterCopyrightText'
 go
 insert into [ZnodeCMSWidgets] ([Code],[DisplayName],[IsConfigurable],[FileName],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate])
select 'MegaMenuNavigation','MegaMenuNavigation',0,'Top-Menu.png',2,GETDATE(),2,GETDATE()
where not exists(select * from [ZnodeCMSWidgets] where [Code] = 'MegaMenuNavigation')
go
if exists(select * from sys.procedures where name = 'Znode_InsertUpdateSaveCartLineItemBundle')
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
    DECLARE @TBL_Personalise TABLE (OmsSavedCartLineItemId INT ,PersonalizeCode NVARCHAr(max),PersonalizeValue NVARCHAr(max),DesignId NVARCHAr(max), ThumbnailURL NVARCHAr(max))
	DECLARE @OmsInsertedData TABLE (OmsSavedCartLineItemId INT ) 	

	INSERT INTO @TBL_Personalise
	SELECT  NULL 
				,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
			,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
	FROM (SELECT TOP 1 PersonalisedAttribute Valuex FROM  @SaveCartLineItemType TRTR  ) a 
	CROSS APPLY	a.Valuex.nodes( '//PersonaliseValueModel' ) AS Tbl(Col) 

	 CREATE TABLE #tempoi (GenId INT IDENTITY(1,1),RowId	int	,OmsSavedCartLineItemId	int	 ,ParentOmsSavedCartLineItemId	int,OmsSavedCartId	int
									,SKU	nvarchar(max) ,Quantity	numeric(28,6)	,OrderLineItemRelationshipTypeID	int	,CustomText	nvarchar(max)
									,CartAddOnDetails	nvarchar(max),Sequence	int	,AutoAddon	varchar(max)	,OmsOrderId	int	,ItemDetails	nvarchar(max)
									,Custom1	nvarchar(max)  ,Custom2	nvarchar(max),Custom3	nvarchar(max),Custom4	nvarchar(max),Custom5	nvarchar(max)
									,GroupId	nvarchar(max) ,ProductName	nvarchar(max),Description	nvarchar(max),Id	int,ParentSKU NVARCHAR(max))
	 
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
			Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on ( a.BundleProductIds = b.SKU or a.SKU = b.sku)
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
			where isnull(cast(a.PersonalisedAttribute as varchar(max)),'') <> ''
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
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.SKU = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
					,Tbl.Col.value( 'PersonalizeCode[1]', 'NVARCHAR(Max)' ) AS PersonalizeCode
			  		,Tbl.Col.value( 'PersonalizeValue[1]', 'NVARCHAR(Max)' ) AS PersonalizeValue
					,Tbl.Col.value( 'DesignId[1]', 'NVARCHAR(Max)' ) AS DesignId
					,Tbl.Col.value( 'ThumbnailURL[1]', 'NVARCHAR(Max)' ) AS ThumbnailURL
			FROM @SaveCartLineItemType a 
			Inner Join #OldValue b on a.BundleProductIds = b.SKU
			CROSS APPLY a.PersonalisedAttribute.nodes( '//PersonaliseValueModel' ) AS Tbl(Col)  
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
		a.Custom5 = ty.Custom5  
		FROM ZnodeOmsSavedCartLineItem a
		INNER JOIN #OldValue b ON (a.OmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		INNER JOIN #tempoi ty ON (ty.SKU = b.SKU)
		WHERE a.OrderLineItemRelationshipTypeId <> @OrderLineItemRelationshipTypeIdAddon

		 UPDATE a
		 SET a.Quantity = a.Quantity+s.AddOnQuantity
		 FROM ZnodeOmsSavedCartLineItem a
		 INNER JOIN #OldValue b ON (a.ParentOmsSavedCartLineItemId = b.OmsSavedCartLineItemId)
		 INNER JOIN @SaveCartLineItemType S on a.OmsSavedCartId = s.OmsSavedCartId and a.SKU = s.AddOnValueIds
		 WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdAddon

		 --UPDATE Ab SET ab.Quantity = a.Quantity   
   --      FROM ZnodeOmsSavedCartLineItem a  
   --      INNER JOIN ZnodeOmsSavedCartLineItem ab ON (ab.OmsSavedCartLineItemId = a.ParentOmsSavedCartLineItemId)  
   --      INNER JOIN @SaveCartLineItemType b ON (a.OmsSavedCartId = b.OmsSavedCartId  )   
		 --WHERE a.OrderLineItemRelationshipTypeId = @OrderLineItemRelationshipTypeIdBundle  

		 UPDATE Ab 
		 SET Ab.Quantity = Ab.Quantity+ty.Quantity,
		 Ab.Custom1 = ty.Custom1,
		 Ab.Custom2 = ty.Custom2,
		 Ab.Custom3 = ty.Custom3,
		 Ab.Custom4 = ty.Custom4,
		 Ab.Custom5 = ty.Custom5  
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
  
 
	 --;with Cte_newData AS   
  --  (  
    SELECT  MAX(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU 
	INTO #Cte_newData 
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
    --)   
	
  
    UPDATE a SET a.ParentOmsSavedCartLineItemId = (SELECT TOP 1 OmsSavedCartLineItemId FROM  #Cte_newData  r  
    WHERE  r.RowId = b.RowId AND ISNULL(r.GroupId,'-') = ISNULL(a.GroupId,'-')  Order by b.RowId )   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =1  )   
    WHERE a.OrderLineItemRelationshipTypeId IS NOT NULL   
    AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon  
    AND a.ParentOmsSavedCartLineItemId IS nULL  
	AND  EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId ) 
  
  --------------------------------------------------------------------------------------------------------

   --;with Cte_newData AS   
   -- (  
    SELECT  MIN(a.OmsSavedCartLineItemId ) OmsSavedCartLineItemId 
	, b.RowId ,b.GroupId ,b.SKU ,b.ParentSKU  
	INTO #Cte_newData1
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ISNULL(b.GroupId,'-') = ISNULL(a.GroupId,'-')  )  
    WHERE ISNULL(a.ParentOmsSavedCartLineItemId,0) =0  
	AND EXISTS (SELECT TOP 1 1  FROM @OmsInsertedData ui WHERE ui.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId )
	--	AND NOT EXISTS (SELECT TOP 1 1 FROM #OldValue TY WHERE TY.OmsSavedCartLineItemId = a.OmsSavedCartLineItemId)
		AND b.OrderLineItemRelationshipTypeID <> @OrderLineItemRelationshipTypeIdAddon
		-- AND CASE WHEN EXISTS (SELECT TOP 1 1 FROM #yuuete TU WHERE TU.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdSimple)  THEN ISNULL(a.OrderLineItemRelationshipTypeID,0) ELSE 0 END = 0 
     GROUP BY b.RowId ,b.GroupId ,b.SKU	,b.ParentSKU,b.OrderLineItemRelationshipTypeID			
   -- )

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

    --;with Cte_newAddon AS   
    --(  
    SELECT a.OmsSavedCartLineItemId , b.RowId  ,b.SKU ,b.ParentSKU  ,Row_number()Over(Order BY c.OmsSavedCartLineItemId )RowIdNo
    INTO #Cte_newAddon
	FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.ParentSKU AND ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = b.id OR b.Id = 1  ))  
    INNER JOIN ZnodeOmsSavedCartLineItem c on b.sku = c.sku and b.OmsSavedCartId=c.OmsSavedCartId and b.Id = 1
    WHERE ( CASE WHEN EXISTS (SELECT TOP 1 1 FROM #tempoi WHERE OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdBundle) THEN 0 ELSE 1 END = ISNULL(a.ParentOmsSavedCartLineItemId,0) OR ISNULL(a.ParentOmsSavedCartLineItemId,0) <> 0   )
    AND b.OrderLineItemRelationshipTypeID = @OrderLineItemRelationshipTypeIdAddon  AND c.ParentOmsSavedCartLineItemId IS NULL
  --  )   
  
 

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
    UPDATE a SET a.Quantity =  NULL   
    FROM ZnodeOmsSavedCartLineItem a  
    INNER JOIN #yuuete b ON (a.OmsSavedCartId = b.OmsSavedCartId AND a.SKU = b.SKU AND b.id =0)   
    WHERE NOT EXISTS (SELECT TOP 1 1  FROM Cte_Th TY WHERE TY.RowId = b.RowId )  
     AND a.OrderLineItemRelationshipTypeId IS NULL   
  
    UPDATE Ab SET ab.Quantity = a.Quantity   
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

GO
if not exists(select * from sys.databases where name = 'Znode_Multifront_RecommendationEngine')
begin
CREATE DATABASE [Znode_Multifront_RecommendationEngine]
 
ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET ANSI_NULL_DEFAULT ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET ANSI_NULLS ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET ANSI_PADDING ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET ANSI_WARNINGS ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET ARITHABORT ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET AUTO_CLOSE OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET AUTO_SHRINK OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET AUTO_UPDATE_STATISTICS ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET CURSOR_CLOSE_ON_COMMIT OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET CURSOR_DEFAULT  LOCAL 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET CONCAT_NULL_YIELDS_NULL ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET NUMERIC_ROUNDABORT OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET QUOTED_IDENTIFIER ON 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET RECURSIVE_TRIGGERS OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET  DISABLE_BROKER 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET DATE_CORRELATION_OPTIMIZATION OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET TRUSTWORTHY OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET ALLOW_SNAPSHOT_ISOLATION OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET PARAMETERIZATION SIMPLE 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET READ_COMMITTED_SNAPSHOT OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET HONOR_BROKER_PRIORITY OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET RECOVERY FULL 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET  MULTI_USER 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET PAGE_VERIFY NONE  

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET DB_CHAINING OFF 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET TARGET_RECOVERY_TIME = 0 SECONDS 

ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET DELAYED_DURABILITY = DISABLED 

end
go
USE [Znode_Multifront_RecommendationEngine]
GO


if not exists(select * from sys.tables where name = 'ZnodeRecommendationProcessingLogs')
begin 
	CREATE TABLE ZnodeRecommendationProcessingLogs
	(
	RecommendationProcessingLogsId  Int Primary Key Identity(1,1),
	PortalId  int,
	Status nvarchar(600) not null,
	LastProcessedOrderId  int not null,
	LastProcessedOrderDate  DateTime not null,
	CreatedBy int not null,
	CreatedDate datetime not null,
	ModifiedBy int not null,
	ModifiedDate datetime not null
	)
end

go
if not exists(select * from sys.tables where name = 'ZnodeRecommendationBaseProducts')
begin 
	CREATE TABLE ZnodeRecommendationBaseProducts  
	(
	RecommendationBaseProductsId  BigInt Primary Key Identity(1,1),
	SKU  nvarchar(600) not null,
	PortalId  int,
	RecommendationProcessingLogsId  int not null,
	CreatedBy int not null,
	CreatedDate datetime not null,
	ModifiedBy int not null,
	ModifiedDate datetime not null
	)

	alter table ZnodeRecommendationBaseProducts add constraint  FK_ZnodeRecommendationBaseProducts_RecommendationProcessingLogsId foreign key (RecommendationProcessingLogsId)
	references ZnodeRecommendationProcessingLogs(RecommendationProcessingLogsId)
end
 go
 if not exists(select * from sys.tables where name = 'ZnodeRecommendedProducts')
begin 
	CREATE TABLE ZnodeRecommendedProducts  
	(
	RecommendedProductsId  BigInt Primary Key Identity,
	RecommendationBaseProductsId BigInt not null,
	SKU  nvarchar(600) not null,
	Quantity  decimal(28,6),
	Occurrence  int not null,
	CreatedBy int not null,
	CreatedDate datetime not null,
	ModifiedBy int not null,
	ModifiedDate datetime not null
	)
	alter table ZnodeRecommendedProducts add constraint  FK_ZnodeRecommendedProducts_RecommendationBaseProductsId 
	foreign key (RecommendationBaseProductsId)
	references ZnodeRecommendationBaseProducts(RecommendationBaseProductsId)
end

go
if not exists(SELECT * FROM SYS.TABLE_TYPES WHERE IS_USER_DEFINED = 1 and name = 'RecommendationProcessedData')
begin 
	CREATE TYPE [dbo].[RecommendationProcessedData] AS TABLE(
		[RecommendationBaseProductsId] [bigint] NULL,
		[BaseSKU] [nvarchar](600) NULL,
		[PortalID] [int] NULL,
		[RecommendationProcessingLogsId] [int] NULL,
		[RecommendedProductsId] [bigint] NULL,
		[RecommendedSKU] [nvarchar](600) NULL,
		[Quantity] [numeric](28, 6) NULL,
		[Occurrence] [int] NULL
	)
end
go
 if exists(select * from sys.procedures where name = 'Znode_RecommendationProcessedData')
	drop proc Znode_RecommendationProcessedData
 go
CREATE PROCEDURE [dbo].[Znode_RecommendationProcessedData] 
(
	@UserID int = 2,
	@TableName varchar(500),
	@ProcessingTimeLimit int,
	@Status bit out
)
--Exec [Znode_RecommendationProcessedData] @TableName = '[##RecommendationData_1810e12a-cbed-4ceb-903c-0640f15c1e78]'
--,@ProcessingTimeLimit = 1000,@Status=0
as
begin

	begin tran
	set nocount on;
	declare @getdate datetime= getdate()
	
	if OBJECT_ID ('tempdb..#RecommendationProcessedData') is not null
		drop table #RecommendationProcessedData

	CREATE TABLE #RecommendationProcessedData(
	    ID int Primary Key identity,
		[RecommendationBaseProductsId] [bigint] NULL,
		[BaseSKU] [nvarchar](600) NULL,
		[PortalID] [int] NULL,
		[RecommendationProcessingLogsId] [int] NULL,
		[RecommendedProductsId] [bigint] NULL,
		[RecommendedSKU] [nvarchar](600) NULL,
		[Quantity] [numeric](28, 6) NULL,
		[Occurrence] [int] NULL
	)

	DECLARE @SQL VARCHAR(MAX)

	SET @SQL = '
	SELECT [RecommendationBaseProductsId],[BaseSKU],[PortalID],[RecommendationProcessingLogsId],
	       [RecommendedProductsId],[RecommendedSKU],[Quantity],[Occurrence]   FROM '+@TableName
	
	INSERT INTO #RecommendationProcessedData
	EXEC (@SQL)

	DECLARE @MaxCount INT, @MinRow INT, @MaxRow INT, @Rows numeric(10,2),@RowId int = 1, @ProcessTimeInLoop int = 0;
	SELECT @MaxCount = COUNT(*) FROM #RecommendationProcessedData 

	SELECT @Rows = 20000
        
	SELECT @MaxCount = CEILING(@MaxCount / @Rows);

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
	
	while ( @ProcessTimeInLoop <= @ProcessingTimeLimit and @RowId <= @MaxCount )
	begin
		select @MinRow = MinRow, @MaxRow = MaxRow from #Temp_ImportLoop where RowId = @RowId
		
		----updating RecommendationBaseProducts data
		update ZRBP set ModifiedBy = @UserID, ModifiedDate = @getdate
		from #RecommendationProcessedData RPD
		inner join ZnodeRecommendationBaseProducts ZRBP ON RPD.BaseSKU = ZRBP.SKU 
						 and ISNULL(RPD.PortalId,0) = isnull(ZRBP.PortalId,0) and RPD.RecommendationProcessingLogsId = ZRBP.RecommendationProcessingLogsId
        where RPD.Id BETWEEN @MinRow AND @MaxRow

		----Inserting RecommendationBaseProducts data against portal
		insert into ZnodeRecommendationBaseProducts (SKU,PortalId,RecommendationProcessingLogsId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		select distinct BaseSKU, PortalID, RecommendationProcessingLogsId, @UserID, @getdate, @UserID, @getdate 
		from #RecommendationProcessedData RPD
		where not exists(select * from ZnodeRecommendationBaseProducts ZRBP where RPD.BaseSKU = ZRBP.SKU 
						 and ISNULL(RPD.PortalId,0) = isnull(ZRBP.PortalId,0) and RPD.RecommendationProcessingLogsId = ZRBP.RecommendationProcessingLogsId)
		and isnull(RPD.RecommendationBaseProductsId,0) = 0
		and RPD.Id BETWEEN @MinRow AND @MaxRow

		----updating new inserted base SKU RecommendationBaseProductsId in temp table
		update RPD set RecommendationBaseProductsId = ZRBP.RecommendationBaseProductsId
		from #RecommendationProcessedData RPD
		inner join ZnodeRecommendationBaseProducts ZRBP ON RPD.BaseSKU = ZRBP.SKU 
						 and ISNULL(RPD.PortalId,0) = isnull(ZRBP.PortalId,0) and RPD.RecommendationProcessingLogsId = ZRBP.RecommendationProcessingLogsId
		where isnull(RPD.RecommendationBaseProductsId,0) = 0 and RPD.Id BETWEEN @MinRow AND @MaxRow	 

		----Updating RecommendedProducts data for base SKU
		update ZRBP set Quantity = RPD.Quantity, Occurrence = RPD.Occurrence,ModifiedBy = @UserID, ModifiedDate = @getdate
		from #RecommendationProcessedData RPD
		inner join ZnodeRecommendedProducts ZRBP ON RPD.RecommendedSKU = ZRBP.SKU AND RPD.RecommendationBaseProductsId = ZRBP.RecommendationBaseProductsId
		where RPD.Id BETWEEN @MinRow AND @MaxRow

		----Inserting RecommendedProducts data against base SKU
		insert into ZnodeRecommendedProducts (RecommendationBaseProductsId,SKU,Quantity,Occurrence,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		select distinct RecommendationBaseProductsId, RecommendedSKU, Quantity, Occurrence, @UserID, @getdate, @UserID, @getdate
		from #RecommendationProcessedData RPD
		where not exists(select * from ZnodeRecommendedProducts ZRBP where RPD.RecommendedSKU = ZRBP.SKU AND RPD.RecommendationBaseProductsId = ZRBP.RecommendationBaseProductsId)
	    and RPD.Id BETWEEN @MinRow AND @MaxRow
		
		set @RowId = @RowId+1
		set @ProcessTimeInLoop = (cast(Datediff(ms, @getdate,getdate()) AS bigint))
	end


	if (@ProcessTimeInLoop>@ProcessingTimeLimit)
	begin
		rollback tran
		set @Status = 0  
		--select @Status
	end
	else 
	begin
		commit tran
		set @Status = 1
		--select @Status
	end

end
go
USE [master]
GO
ALTER DATABASE [Znode_Multifront_RecommendationEngine] SET  READ_WRITE 
GO
