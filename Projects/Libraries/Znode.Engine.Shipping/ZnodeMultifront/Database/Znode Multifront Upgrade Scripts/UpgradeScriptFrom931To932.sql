
IF EXISTS (SELECT TOP 1 1 FROM Sys.Tables WHERE Name = 'ZnodeMultifront')
BEGIN 
IF EXISTS (SELECT TOP 1 1 FROM ZnodeMultifront where BuildVersion =   932  )
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
VALUES ( N'Znode_Multifront_9_3_2', N'Upgrade GA Release by 932',9,3,2,932,0,2, GETDATE(),2, GETDATE())
GO 
SET ANSI_NULLS ON
GO

IF EXISTS (SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetProductsAttributeValue_newTesting')
	DROP PROC Znode_GetProductsAttributeValue_newTesting
GO
CREATE   PROCEDURE [dbo].[Znode_GetProductsAttributeValue_newTesting]  
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
        
   DECLARE @DefaultLocaleId INT = dbo.FN_GetDefaultLocaleID()  
    
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
     INTO #Cte_GetDefaultData
	 FROM #TBL_AttributeValue ZPPADV   
     INNER JOIN ZnodePimAttributeValue ZPAV ON (ZPAV.PimAttributeValueId = ZPPADV.PimAttributeValueId)  
     INNER JOIN ZnodePimAttributeDefaultValue TEY ON (TEY.PimAttributeDefaultValueId  = ZPPADV.PimAttributeDefaultValueId )  
     INNER JOIN ZnodePimAttributeDefaultValuelocale ZPADVL ON (ZPADVL.PimAttributeDefaultValueId = TEY.PimAttributeDefaultValueId )  
     WHERE ZPADVL.localeID  IN (@LocaleId,@DefaultLocaleId)  
     AND TypeOfData = 2   
     AND ZPPADV.LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END   
     
	 SELECT AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId ,AttributeDefaultValueCode   
     INTO #Cte_AttributeValueDefault
	 FROM #Cte_GetDefaultData   
     WHERE LocaleId = @LocaleId   
     UNION    
     SELECT  AttributeDefaultValue  ,PimProductId ,AttributeCode,PimAttributeId,AttributeDefaultValueCode   
     FROM #Cte_GetDefaultData a   
     WHERE LocaleId = @DefaultLocaleId   
     AND NOT EXISTS (SELECT TOP 1 1 FROM #Cte_GetDefaultData b WHERE b.PimAttributeValueId = a.PimAttributeValueId AND b.LocaleId= @LocaleId)  
     
    SELECT  PimProductId, AttributeValue,  AttributeCode,  PimAttributeId, NULL AttributeDefaultValue    
    FROM  #TBL_AttributeValue   
             WHERE LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END   
    AND TypeOfData = 1    
  
    UNION ALL   
  
    SELECT DISTINCT PimProductId,  
            SUBSTRING ((SELECT ','+[dbo].[Fn_GetMediaThumbnailMediaPath]( zm.PATH) FROM ZnodeMedia ZM WHERE ZM.MediaId = TBLAV.AttributeValue   
      FOR XML PATH (''), TYPE).value('.', 'varchar(Max)') ,2,4000)  ,AttributeCode,PimAttributeId, NULL AttributeDefaultValue  
    FROM #TBL_AttributeValue TBLAV   
    WHERE  LocaleId  = CASE WHEN RowId = 2 THEN  @LocaleId ELSE @DefaultLocaleId END   
    AND TypeOfData = 3  
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
     
    
   END TRY  
         BEGIN CATCH  
    DECLARE @Status BIT ;
			SET @Status = 0;
			
      SELECT ERROR_MESSAGE()  
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), 
			@ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductsAttributeValue_newTesting 
			,@LocaleId='+CAST(@LocaleId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetProductsAttributeValue_newTesting',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall; 
   
         END CATCH;  
     END;
GO
IF EXISTS (SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ManageProductList_XML')
	DROP PROC Znode_ManageProductList_XML
GO
CREATE  PROCEDURE [dbo].[Znode_ManageProductList_XML]
(   @WhereClause						 XML,
    @Rows								 INT           = 100,
    @PageNo								 INT           = 1,
    @Order_BY			 VARCHAR(1000) = '',
    @LocaleId			 INT           = 1,
    @PimProductId		 VARCHAR(2000) = 0,
    @IsProductNotIn	 BIT           = 0,
	@IsCallForAttribute BIT		   = 0,
	@AttributeCode      VARCHAR(max ) = '' ,
	@PimCatalogId   INT = 0,
	@IsCatalogFilter   BIT            = 0,
	@IsDebug            Bit		   = 0 )
AS
    
/*
		  Summary:-   This Procedure is used for get product List  
				    Procedure will pivot verticle table(ZnodePimattributeValues) into horizontal table with columns 
				    ProductId,ProductName,ProductType,AttributeFamily,SKU,Price,Quantity,IsActive,ImagePath,Assortment,LocaleId,DisplayOrder
        
		  Unit Testing
		  
exec Znode_ManageProductList_XML @WhereClause=N'',@Rows=50,@PageNo=1,@Order_By=N'',@LocaleId=1,@PimProductId=N'',@IsProductNotIn=1,@IsCallForAttribute=0,@AttributeCode=''
          select * from ZnodeAttributeType  WHERE AttributeValue LIKE '%&%'
		  UPDATE VieW_lOADMANAGEpRODUCT SET  AttributeValue = 'A & B'  WHERE AttributeValue LIKE '% and %' AND PimProductId = 158
    */

     BEGIN
         SET NOCOUNT ON;
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
             DECLARE @PimProductIds TransferId, --VARCHAR(MAX), 
					 @FirstWhereClause NVARCHAR(MAX)= '', 
					 @SQL NVARCHAR(MAX)= '' ,
					 @OutPimProductIds VARCHAR(max),
					 @ProductXML NVARCHAR(max) ;

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
              PimAttributeId INT,
			  AttributeDefaultValue NVARCHAR(MAX)
             );
			 Create table #TBL_AttributeDetailsLocale
             (PimProductId   INT,
              AttributeValue NVARCHAR(MAX),
              AttributeCode  VARCHAR(600),
              PimAttributeId INT
             );
			 DECLARE @TBL_MultiSelectAttribute TABLE (PimAttributeId INT , AttributeCode VARCHAR(600))
			
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
          		
             IF EXISTS ( SELECT TOP 1 1 FROM @WhereClause.nodes ( '//ArrayOfWhereClauseModel/WhereClauseModel'  ) AS Tbl(Col)
			 WHERE LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''',''))))  =  'Brand'
                OR LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''','')))) = 'Vendor'
                OR LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''',''))))  =  'ShippingCostRules'
                OR LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''','')))) =  'Highlights') and @IsCallForAttribute=1
                 BEGIN
                DECLARE @AttributeCodeValue TABLE (AttributeValue NVARCHAr(max),AttributeCode NVARCHAR(max))

				INSERT INTO @AttributeCodeValue(AttributeValue,AttributeCode)
				SELECT  Tbl.Col.value ( 'attributevalue[1]' , 'NVARCHAR(max)') AS AttributeValue
						 ,Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)') AS AttributeCode
				FROM @WhereClause.nodes ( '//ArrayOfWhereClauseModel/WhereClauseModel'  ) AS Tbl(Col)
				WHERE LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''',''))))  =  'Brand'
                OR LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''',''))))  = 'Vendor'
                OR LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''',''))))  =  'ShippingCostRules'
                OR LTRIM(RTRIM((REPLACE(REPLACE(Tbl.Col.value ( 'attributecode[1]' , 'NVARCHAR(max)'),' = ',''),'''',''))))  =  'Highlights'
		
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
										FROM Cte_productIds WHERE  AttributeCode '+(SELECT TOP 1 AttributeCode  FROM @AttributeCodeValue )+' AND 
										AttributeValue '+(SELECT TOP 1 AttributeValue  FROM @AttributeCodeValue )+' 
										GROUP BY PimProductId,ModifiedDate Order By ModifiedDate DESC ';


					 SET @Order_BY = CASE WHEN @Order_BY = '' THEN 'ModifiedDate DESC' ELSE @Order_BY END 
					 	
					 SET @WhereClause = CAST(REPLACE(CAST(@WhereClause AS NVARCHAR(max)),'<WhereClauseModel><attributecode>'+(SELECT TOP 1 AttributeCode  FROM @AttributeCodeValue )+'</attributecode><attributevalue>'+(SELECT TOP 1 AttributeValue   FROM @AttributeCodeValue )+'</attributevalue></WhereClauseModel>','') AS XML )
					
				     INSERT INTO @TBL_ProductIds ( PimProductId, ModifiedDate )
					 EXEC (@SQL);
			  					 
					
						 INSERT INTO @ProductIdTable( PimProductId )
						 SELECT PimProductId 
						 FROM @TBL_ProductIds
					

                     INSERT INTO @TransferPimProductId
					 SELECT PimProductId
                     FROM @ProductIdTable
                   
				   			  
     DELETE FROM @ProductIdTable;
   --  SET @WhereClause = CAST(REPLACE(CAST(@WhereClause AS NVARCHAR(MAX)), @FirstWhereClause, ' 1 = 1') AS XML);
                 END
	            ELSE IF @PimProductId <> ''
			    BEGIN 
		
				 INSERT INTO @TransferPimProductId(id)
				 SELECT Item 
				 FROM dbo.split(@PimProductId,',')
			    END 
		
			
	 DECLARE  @ProductListIdRTR TransferId
	 DECLARE @TAb Transferid 
	 --DECLARE @tBL_mainList TABLE (Id INT,RowId INT)
	 Create table #TBL_ProductMainList (Id INT,RowId INT)

	 	IF @PimProductId <> ''  OR   @IsCallForAttribute=1 --OR (CAST(@WhereClause AS NVARCHAR(max))= N'' AND @Order_by <> N'' AND @AttributeCode = N'')
		BEGIN 
	 SET @IsProductNotIn = CASE WHEN @IsProductNotIn = 0 THEN 1  
					 WHEN @IsProductNotIn = 1 THEN 0 END 
		END 
	
	 INSERT INTO @ProductListIdRTR
	 EXEC Znode_GetProductList  @IsProductNotIn,@TransferPimProductId
 
	 IF CAST(@WhereClause AS NVARCHAR(max))<> N''
	 BEGIN 
	 
	  SET @SQL = 'SELECT Distinct PimProductId FROM ##Temp_PimProductId'+CAST(@@SPID AS VARCHAR(500))

	  EXEC Znode_GetFilterPimProductId @WhereClause,@ProductListIdRTR,@localeId
	  
      INSERT INTO @TAB 
	  EXEC (@SQL)
	 
	 END 
	 
	

	 IF EXISTS (SELECT Top 1 1 FROM @TAb ) OR CAST(@WhereClause AS NVARCHAR(max)) <> N''
	 BEGIN 
	 
	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO #TBL_ProductMainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @TAb ,@AttributeCode,@localeId
	 
	 END 
	 ELSE 
	 BEGIN
	      
	 SET @AttributeCode = REPLACE(dbo.FN_TRIM(REPLACE(REPLACE(@order_by,' DESC',''),' ASC','')),'DisplayOrder','ProductName')
	 SET @order_by = REPLACE(@order_by,'DisplayOrder','ProductName')
	 INSERT INTO #TBL_ProductMainList(id,RowId)
	 EXEC Znode_GetOrderByPagingProduct @order_by,@rows,@PageNo, @ProductListIdRTR ,@AttributeCode,@localeId 
	 END 
          

  			 INSERT INTO @PimProductIds ( Id  )
			 SELECT id FROM #TBL_ProductMainList

			 DECLARE @TBL_PimProductIds transferId 
			 INSERT INTO @TBL_PimProductIds
			 SELECT id 
             FROM @PimProductIds
			 			 	
			 DECLARE @PimAttributeIds TransferId  
			 INSERT INTO @PimAttributeIds
			 SELECT PimAttributeId  
			 FROM [dbo].[Fn_GetProductGridAttributes]()
			 
			

			 INSERT INTO @TBL_AttributeDetails
             (PimProductId,
              AttributeValue,
              AttributeCode,
              PimAttributeId,
			  AttributeDefaultValue
             )
             EXEC Znode_GetProductsAttributeValue_newTesting
                  @TBL_PimProductIds,
                  @PimAttributeIds,
                  @localeId;
			
			
			UPDATE @TBL_AttributeDetails
			SET AttributeValue = ISNULL(AttributeValue,'')
			WHERE AttributeValue IS NULL 

----------------------------------------------------------------------------------------------------

			

		    declare @SKU SelectColumnList
			declare @TBL_Inventorydetails table (Quantity NVARCHAR(MAx),PimProductId INT)

			INSERT INTO @SKU
			SELECT AttributeValue 
			FROM @TBL_AttributeDetails
			WHERE AttributeCode = 'SKU'
 
 			INSERT INTO @TBL_Inventorydetails(Quantity,PimProductId)
			EXEC Znode_GetPimProductAttributeInventory @SKU--vishal

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
			SELECT a.ID PimProductId ,th.DisplayName, 'PublishStatus',NULL
			FROM @PimProductIds a 
			INNER JOIN ZnodePimProduct b ON (b.PimProductId = a.ID)
			LEFT JOIN ZnodePublishState th ON (th.PublishStateId = b.PublishStateId)

	  INSERT INTO #TBL_AttributeDetailsLocale (PimProductId ,PimAttributeId,AttributeCode )
			SELECT  TBLAD.PimProductId ,TBLAD.PimAttributeId,TBLAD.AttributeCode 
			FROM @TBL_AttributeDetails TBLAD 
			GROUP BY  TBLAD.PimProductId ,TBLAD.PimAttributeId,TBLAD.AttributeCode 
       					

	    UPDATE TBLPP 
		SET AttributeValue = CTDD.AttributeValue 
		FROM  @TBL_AttributeDetails CTDD 
		INNER JOIN #TBL_AttributeDetailsLocale TBLPP ON (TBLPP.PimProductId = CTDD.PimProductId AND TBLPP.AttributeCode  = CTDD.AttributeCode)
		WHERE TBLPP.AttributeValue IS NULL 

    	SET @ProductXML =  '<MainProduct>'+ STUFF( (  SELECT '<Product>'+'<PimProductId>'+CAST(TBAD.PimProductId AS VARCHAR(50))+'</PimProductId>'
																		+'<AvailableInventory>'+CAST(ISNULL(IDD.[Quantity],'') AS VARCHAR(50))+'</AvailableInventory>'
		+ STUFF(    (  SELECT '<'+TBADI.AttributeCode+'>'+CAST( (SELECT  ''+TBADI.AttributeValue FOR XML PATH('')) AS NVARCHAR(max))+'</'+TBADI.AttributeCode+'>'   
															FROM #TBL_AttributeDetailsLocale TBADI      
															 WHERE TBADI.PimProductId = TBAD.PimProductId 
															 ORDER BY TBADI.PimProductId DESC
															 FOR XML PATH (''), TYPE
																).value('.', ' Nvarchar(max)'), 1, 0, '')+'</Product>'	   

		FROM #TBL_AttributeDetailsLocale TBAD
		INNER JOIN #TBL_ProductMainList TBPI ON (TBAD.PimProductid = TBPI.id )
		LEFT JOIN @TBL_ProductIds TPT ON TBAD.PimProductId = TPT.PimProductId
		LEFT JOIN @TBL_InventoryDetails IDD ON (TBPI.id = IDD.PimProductId)
		GROUP BY TBAD.pimProductid, TPT.ModifiedDate,TBPI.RowId,IDD.Quantity
		ORDER BY TBPI.RowId 
		FOR XML PATH (''),TYPE).value('.', ' Nvarchar(max)'), 1, 0, '')+'</MainProduct>'
			--FOR XML PATH ('MainProduct'))
 

			SELECT  CAST(@ProductXML AS XML ) ProductXMl
		   
		     SELECT AttributeCode ,  ZPAL.AttributeName
			 FROM ZnodePimAttribute ZPA 
			 LEFT JOIN ZnodePiMAttributeLOcale ZPAL ON (ZPAL.PimAttributeId = ZPA.PimAttributeId )
             WHERE LocaleId = 1  
			 AND  IsCategory = 0 
			 AND ZPA.IsShowOnGrid = 1  
			 UNION ALL 
			 SELECT 'PublishStatus','Publish Status'

     IF EXISTS (SELECT Top 1 1 FROM @TAb )
	 BEGIN 

		  SELECT (SELECT COUNT(1) FROM @TAb) AS RowsCount   
	 END 
	 ELSE 
	 BEGIN
	 		  SELECT (SELECT COUNT(1) FROM @ProductListIdRTR) AS RowsCount   
	 END 
		;

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
	 go

	  IF EXISTS (SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportSEODetails')
	DROP PROC Znode_ImportSEODetails
GO 
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
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSWidgetProductId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImagePath,ProductImage</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ProductName</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ProductType</name>      <headertext>Product Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>ModifiedDate</name>      <headertext>Modified Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditCMSAssociateProduct|/WebSite/UnassociateProduct</manageactionurl>      <manageparamfield>CMSWidgetProductId|CMSWidgetProductId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where itemname='AssociatedCMSOfferPageProduct' 

go
update  ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>CMSWidgetBrandId</name><headertext>Checkbox</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>y</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>BrandId</name><headertext>ID</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>BrandName</name><headertext>Brand Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>DisplayOrder</name><headertext>Display Order</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>3</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>Manage</name><headertext>Action</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Edit|Delete</format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Edit|Delete</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl>/WebSite/EditCMSWidgetBrand|/WebSite/RemoveAssociatedBrands</manageactionurl><manageparamfield>cmsWidgetBrandId|cmsWidgetBrandId</manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
WHERE ItemName ='ZnodeCMSWidgetBrand'

go
IF EXISTS(SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_DeleteSavedCartItem')
	DROP PROC Znode_DeleteSavedCartItem
GO
CREATE PROCEDURE Znode_DeleteSavedCartItem  
(  
@OmsCookieMappingId INT = 0  
,@UserId INT = 0  
,@Status Bit OUT  
)  
/*  
 EXEC Znode_DeleteSavedCartItem  
 
*/  
 
AS  
BEGIN  
  BEGIN TRAN  
  BEGIN TRY  
     if(@OmsCookieMappingId < 1)
BEGIN
set @OmsCookieMappingId =(SELECT TOP 1 OmsCookieMappingId FROM ZnodeOmsCookieMapping WHERE USERID = @UserId )
END

    DECLARE @OmsSavedCartId INT =  (SELECT TOP 1 OmsSavedCartId FROM ZnodeOmsSavedCart WHERE OmsCookieMappingId = @OmsCookieMappingId )  
     
 DELETE FROM ZnodeOmsPersonalizeCartItem WHERE EXISTS (SELECT TOP 1 1 FROM ZnodeOmsSavedCartLineItem  
  WHERE ZnodeOmsPersonalizeCartItem.OmsSavedCartLineItemId =  ZnodeOmsSavedCartLineItem.OmsSavedCartLineItemId  
  AND ZnodeOmsSavedCartLineItem.OmsSavedCartId = @OmsSavedCartId )  
   
 DELETE FROM ZnodeOmsSavedCartLineItem  
  WHERE ZnodeOmsSavedCartLineItem.OmsSavedCartId = @OmsSavedCartId  
   
 --DELETE FROM ZnodeOmsSavedCart WHERE OmsSavedCartId = @OmsSavedCartId  
 
 --DELETE FROM ZnodeOmsCookieMapping WHERE OmsCookieMappingId = @OmsCookieMappingId  
 
  SET @Status = 1  
 
  SELECT @OmsCookieMappingId Id , CAST(1 AS BIT ) Status  
 
  COMMIT TRAN  
 
  END TRY  
  BEGIN CATCH  
     SET @Status = 1  
  
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
	@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteSavedCartItem @OmsCookieMappingId = '+CAST(@OmsCookieMappingId AS VARCHAR(50))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
	SELECT @OmsCookieMappingId Id , CAST(0 AS BIT ) Status                  
		  
	EXEC Znode_InsertProcedureErrorLog
	@ProcedureName = 'Znode_DeleteSavedCartItem',
	@ErrorInProcedure = @Error_procedure,
	@ErrorMessage = @ErrorMessage,
	@ErrorLine = @ErrorLine,
	@ErrorCall = @ErrorCall; 

  ROLLBACK TRAN  
    
  END CATCH  
 
END
GO
IF EXISTS(SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_GetPublishCategoryGroup')
	DROP PROC Znode_GetPublishCategoryGroup
GO
CREATE PROCEDURE [dbo].[Znode_GetPublishCategoryGroup]
(   
	@PublishCatalogId INT,
    @UserId           INT,
    @VersionId        INT,
    @Status           BIT = 0 OUT,
	@PimCategoryHierarchyId int = 0, 
    @IsDebug          BIT = 0,
	@LocaleId TransferId READONLY,
	@PublishStateId INT = 0 
)
AS 
/*

       Summary:Publish category with their respective products and details 
	            The result is fetched in xml form   
       Unit Testing   
       Begin transaction 
       SELECT * FROM ZnodePIMAttribute 
	   SELECT * FROM ZnodePublishCatalog 
	   SELECT * FROM ZnodePublishCategory WHERE publishCAtegoryID = 167 


       EXEC [Znode_GetPublishCategory] @PublishCatalogId = 5,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 
       EXEC [Znode_GetPublishCategory] @PublishCatalogId = 5,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 ,@PimCategoryHierarchyId = ? 


       Rollback Transaction 
	*/
     BEGIN
         BEGIN TRAN GetPublishCategory;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @LocaleIdIn INT= 0, @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @Counter INT= 1, @MaxId INT= 0, @CategoryIdCount INT;
             DECLARE @IsActive BIT= [dbo].[Fn_GetIsActiveTrue]();
             DECLARE @AttributeIds VARCHAR(MAX)= '', @PimCategoryIds VARCHAR(MAX)= '', @DeletedPublishCategoryIds VARCHAR(MAX)= '', @DeletedPublishProductIds VARCHAR(MAX);
             --get the pim catalog id 
			 DECLARE @PimCatalogId INT=(SELECT PimCatalogId FROM ZnodePublishcatalog WHERE PublishCatalogId = @PublishCatalogId); 

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
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder   INT
             );
             DECLARE @TBL_AttributeValue TABLE
             (PimCategoryAttributeValueId INT,
              PimCategoryId               INT,
              CategoryValue               NVARCHAR(MAX),
              AttributeCode               VARCHAR(300),
              PimAttributeId              INT
             );
             DECLARE @TBL_LocaleIds TABLE
             (RowId     INT IDENTITY(1, 1),
              LocaleId  INT,
              IsDefault BIT
             );
             DECLARE @TBL_PimCategoryIds TABLE
             (PimCategoryId       INT,
              PimParentCategoryId INT,
              DisplayOrder        INT,
              ActivationDate      DATETIME,
              ExpirationDate      DATETIME,
              CategoryName        NVARCHAR(MAX),
              ProfileId           VARCHAR(MAX),
              IsActive            BIT,PimCategoryHierarchyId INT,ParentPimCategoryHierarchyId INT   ,
			  CategoryCode  NVARCHAR(MAX)    );


             DECLARE @TBL_PublishPimCategoryIds TABLE
             (PublishCategoryId       INT,
              PimCategoryId           INT,
              PublishProductId        varchar(max),
              PublishParentCategoryId INT ,
			  PimCategoryHierarchyId INT ,parentPimCategoryHierarchyId INT
			  
             );

			  DECLARE @TBL_PublishPimCategoryIdsLatest TABLE
             (PublishCategoryId       INT,
              PimCategoryId           INT,
              PublishProductId        varchar(max),
              PublishParentCategoryId INT ,
			  PimCategoryHierarchyId INT ,parentPimCategoryHierarchyId INT,PublishCatalogLogId INT,LocaleId INT 
			  ,RowIndex INT 
             );

             DECLARE @TBL_DeletedPublishCategoryIds TABLE
             (PublishCategoryId INT,
              PublishProductId  INT
             );

			     DECLARE @TBL_DeletedPublishCategoryIds_new TABLE
             (PublishCategoryId INT,
              PublishProductId  INT
             );
             DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
              CategoryXml       XML,
              LocaleId          INT
			  ,PublishCatalogLogId INT
             );
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
             SELECT LocaleId,IsDefault FROM ZnodeLocale mt WHERE IsActive = @IsActive
			  AND (EXISTS (SELECT TOP 1 1  FROM @LocaleId RT WHERE RT.Id = MT.LocaleId )
			 OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleId ));


			IF @PimCategoryHierarchyId > 0 
			Begin 
				 DECLARE @TBL_CategoryCategoryHierarchyIds TABLE (CategoryId int,ParentCategoryId int,PimCategoryHierarchyId INT ,ParentPimCategoryHierarchyId INT  ) 
				 INSERT INTO @TBL_CategoryCategoryHierarchyIds(CategoryId , ParentCategoryId, PimCategoryHierarchyId , ParentPimCategoryHierarchyId)
				 Select Distinct PimCategoryId , Null,PimCategoryHierarchyId,NULL FROM (
				 SELECT PimCategoryId,ParentPimCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId from DBO.[Fn_GetRecurciveCategoryIds_PimCategoryHierarchy](@PimCategoryHierarchyId,@PimCatalogId)
				 Union 
				 Select PimCategoryId , null,PimCategoryHierarchyId,NULL  from ZnodePimCategoryHierarchy where PimCategoryHierarchyId = @PimCategoryHierarchyId 
				 Union 
				 Select PimCategoryId , null,PimCategoryHierarchyId,NULL  from [Fn_GetRecurciveCategoryIds_PimCategoryHierarchyIdNew] (@PimCategoryHierarchyId,@PimCatalogId) ) Category  

			
				 INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
				
				 SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
				 FROM ZnodePimCategoryHierarchy AS ZPCH 
				 LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
				 WHERE ZPCH.PimCatalogId = @PimCatalogId  AND ZPCH.PimCategoryHierarchyId in 
				 (SELECT PimCategoryHierarchyId from @TBL_CategoryCategoryHierarchyIds where CategoryId is not null )  ; 
				
				-- Delete from @TBL_PimCategoryIds where PimCategoryId  in (
				-- select PimCategoryId  from ZnodePublishCategory where PublishCatalogId = @PublishCatalogId 
				--)
		
	
		  
				SELECT @VersionId  = PublishCatalogLogId from ZnodePublishCatalogLog where PublishCatalogId = @PublishCatalogId  and IsCatalogPublished =1 

			

			 	 INSERT INTO @TBL_DeletedPublishCategoryIds (PublishCategoryId,PublishProductId)
				 SELECT ZPC.PublishCategoryId,ZPCP.PublishProductId 
				 FROM ZnodePublishCategory AS ZPC 
				 LEFT JOIN  ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishCategoryId = ZPC.PublishCategoryId AND ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND  ZPCP.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId  )                                                  
				 LEFT JOIN ZnodePublishProduct ZPP ON (zpp.PublishProductId = zpcp.PublishProductId AND zpp.PublishCatalogId = zpcp.PublishCatalogId)
				 LEFT JOIN ZnodePublishCatalog ZPCC ON (ZPCC.PublishCatalogId = ZPCP.PublishCatalogId)
				 WHERE ZPC.PublishCatalogId = @PublishCataLogId 
				 --AND NOT EXISTS
				 --(SELECT TOP 1 1 FROM ZnodePimCatalogCategory AS TBPC WHERE TBPC.PimCategoryId = ZPC.PimCategoryId 
				 --AND TBPC.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId AND TBPC.PimProductId = ZPP.PimProductId 
				 --AND TBPC.PimCatalogId = ZPCC.PimCatalogId  AND  ZPCP.PimCategoryHierarchyId=  @PimCategoryHierarchyId   ) 
				 AND ZPC.ParentPimCategoryHierarchyId  in (@PimCategoryHierarchyId)
				 AND ZPC.PimCategoryHierarchyId NOT IN (select PimCategoryHierarchyId FROM @TBL_PimCategoryIds)  ;
				

				 INSERT INTO @TBL_DeletedPublishCategoryIds_new (PublishCategoryId,PublishProductId)
				  SELECT ZPC.PublishCategoryId,ZPCP.PublishProductId 
				 FROM ZnodePublishCategory AS ZPC 
				 LEFT JOIN  ZnodePublishCategoryProduct ZPCP ON (ZPCP.PublishCategoryId = ZPC.PublishCategoryId AND ZPCP.PublishCatalogId = ZPC.PublishCatalogId AND  ZPCP.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId  )                                                  
				 LEFT JOIN ZnodePublishProduct ZPP ON (zpp.PublishProductId = zpcp.PublishProductId AND zpp.PublishCatalogId = zpcp.PublishCatalogId)
				 LEFT JOIN ZnodePublishCatalog ZPCC ON (ZPCC.PublishCatalogId = ZPCP.PublishCatalogId)
				 WHERE ZPC.PublishCatalogId = @PublishCataLogId 
				 AND ZPC.ParentPimCategoryHierarchyId  in (@PimCategoryHierarchyId)
				 AND ZPC.PimCategoryHierarchyId NOT IN (select PimCategoryHierarchyId FROM @TBL_PimCategoryIds)
				 AND NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy TU WHERE TU.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId )  ;

			End
			ELSE 
			Begin
				INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
				SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
				FROM ZnodePimCategoryHierarchy AS ZPCH 
				LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
				WHERE ZPCH.PimCatalogId = @PimCatalogId; 

			 -- AND IsActive = @IsActive ; -- As discussed with @anup active flag maintain on demo site 23/12/2016
			 --	SELECT * FROM @TBL_PimCategoryIds
			 -- here is find the deleted publish category id on basis of publish catalog

             INSERT INTO @TBL_DeletedPublishCategoryIds_new(PublishCategoryId,PublishProductId)
			 SELECT ZPC.PublishCategoryId,ZPCP.PublishProductId 
				 FROM ZnodePublishCategoryProduct ZPCP
				 INNER JOIN ZnodePublishCategory AS ZPC ON(ZPCP.PublishCategoryId = ZPC.PublishCategoryId AND ZPCP.PublishCatalogId = ZPC.PublishCatalogId)                                                  
				 INNER JOIN ZnodePublishProduct ZPP ON(zpp.PublishProductId = zpcp.PublishProductId AND zpp.PublishCatalogId = zpcp.PublishCatalogId)
				 INNER JOIN ZnodePublishCatalog ZPCC ON(ZPCC.PublishCatalogId = ZPCP.PublishCatalogId)
				 WHERE ZPC.PublishCatalogId = @PublishCataLogId 
				 AND NOT EXISTS
				 (SELECT TOP 1 1 FROM ZnodePimCatalogCategory AS TBPC WHERE TBPC.PimCategoryId = ZPC.PimCategoryId 
				 AND TBPC.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId AND TBPC.PimProductId = ZPP.PimProductId 
				 AND TBPC.PimCatalogId = ZPCC.PimCatalogId);

			End
			
          

			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishCategoryIds = ISNULL(SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_DeletedPublishCategoryIds_new AS ZPC
                                              GROUP BY ZPC.PublishCategoryId FOR XML PATH('') ), 2, 4000), '');
			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishProductIds = '';
			 -- Delete the publish category id 
	         EXEC Znode_DeletePublishCatalog @PublishCatalogIds = @PublishCatalogId,@PublishCategoryIds = @DeletedPublishCategoryIds,@PublishProductIds = @DeletedPublishProductIds; 
			
			

             MERGE INTO ZnodePublishCategory TARGET USING  @TBL_PimCategoryIds SOURCE ON
			 (
				 TARGET.PimCategoryId = SOURCE.PimCategoryId 
				 AND TARGET.PublishCatalogId = @PublishCataLogId 
				 AND TARGET.PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId
			 )
			 WHEN MATCHED THEN UPDATE SET TARGET.PimParentCategoryId = SOURCE.PimParentCategoryId,TARGET.CreatedBy = @UserId,TARGET.CreatedDate = @GetDate,
             TARGET.ModifiedBy = @UserId,TARGET.ModifiedDate = @GetDate,PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId,ParentPimCategoryHierarchyId=SOURCE.ParentPimCategoryHierarchyId
             WHEN NOT MATCHED THEN INSERT(PimCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PimCategoryHierarchyId,ParentPimCategoryHierarchyId) 
			 VALUES(SOURCE.PimCategoryId,@PublishCatalogId,@UserId,@GetDate,@UserId,@GetDate,SOURCE.PimCategoryHierarchyId
			 ,SOURCE.ParentPimCategoryHierarchyId)
             OUTPUT INSERTED.PublishCategoryId,INSERTED.PimCategoryId,INSERTED.PimCategoryHierarchyId,
			 INSERTED.parentPimCategoryHierarchyId 
			 INTO @TBL_PublishPimCategoryIds(PublishCategoryId,PimCategoryId,PimCategoryHierarchyId,parentPimCategoryHierarchyId);
			       
				   
		     -- here update the publish parent category id
             UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] 
				FROM ZnodePublishCategory ZPC
				INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
				WHERE ZPC.PublishCatalogId =@PublishCatalogId
				AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL
				AND TBPC.PublishCatalogId =@PublishCatalogId
				AND ZPC.PimCategoryId in (select PimCategoryId FROM @TBL_PimCategoryIds);
				;
			 UPDATE a
				SET  a.PublishParentCategoryId = b.PublishCategoryId
				FROM ZnodePublishCategory a 
				INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
				WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
				AND a.PublishCatalogId =@PublishCatalogId
				AND b.PublishCatalogId =@PublishCatalogId
				AND a.PimCategoryId in (select PimCategoryId FROM @TBL_PimCategoryIds);

			 --UPDATE ZPC SET [PimParentCategoryId] = TBPC.[PimCategoryId] 
			 --FROM ZnodePublishCategory ZPC
    --         INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 --WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 --AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL ;

			 -- product are published here 
            --  EXEC Znode_GetPublishProducts @PublishCatalogId,0,@UserId,1,0,0;

             SET @MaxId =(SELECT MAX(RowId)FROM @TBL_LocaleIds);
			 DECLARE @TransferID TRANSFERID 
			 INSERT INTO @TransferID 
			 SELECT DISTINCT  PimCategoryId
			 FROM @TBL_PublishPimCategoryIds 

		          
			 INSERT INTO @TBL_PublishPimCategoryIdsLatest (PublishCategoryId,PimCategoryId,PublishProductId,
			PublishParentCategoryId,PimCategoryHierarchyId,parentPimCategoryHierarchyId, PublishCatalogLogId,
			LocaleId ) 
			 SELECT a.*,Max(b.PublishCatalogLogId) PublishCatalogLogId,b.LocaleId
			 FROM @TBL_PublishPimCategoryIds a
			 LEFT JOIN ZnodePublishCatalogLog b ON (b.PublishCatalogId = @PublishCatalogId)
			 WHERE EXISTS (SELECT TOP 1 1  FROM @LocaleId YTU WHERE YTU.Id = b.LocaleId )
			 AND b.PublishStateId = @PublishStateId
			 GROUP BY a.PublishCategoryId  ,PimCategoryId ,a.PublishProductId ,PublishParentCategoryId ,
			  PimCategoryHierarchyId  ,parentPimCategoryHierarchyId,b.LocaleId

			 			 
             WHILE @Counter <= @MaxId -- Loop on Locale id 
                 BEGIN
                     SET @LocaleIdIn =(SELECT LocaleId FROM @TBL_LocaleIds WHERE RowId = @Counter);
                   
				     SET @AttributeIds = SUBSTRING((SELECT ','+CAST(ZPCAV.PimAttributeId AS VARCHAR(50)) FROM ZnodePimCategoryAttributeValue ZPCAV 
										 WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC WHERE TBPC.PimCategoryId = ZPCAV.PimCategoryId) GROUP BY ZPCAV.PimAttributeId FOR XML PATH('')), 2, 4000);
                
				     SET @CategoryIdCount =(SELECT COUNT(1) FROM @TBL_PimCategoryIds);

                     INSERT INTO @TBL_AttributeIds (PimAttributeId,ParentPimAttributeId,AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,
					 IsConfigurable,IsPersonalizable,DisplayOrder,HelpDescription,IsCategory,IsHidden,CreatedDate,ModifiedDate,AttributeName,AttributeTypeName)
                     EXEC [Znode_GetPimAttributesDetails] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeDefault (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)
                     EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
                     EXEC [dbo].[Znode_GetCategoryAttributeValueId] @TransferID,@AttributeIds,@LocaleIdIn;

					-- SELECT * FROM @TBL_AttributeValue WHERE PimCategoryId = 281


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
                     AS (SELECT TBA.PimCategoryId,TBA.PimAttributeId,[dbo].[FN_GetThumbnailMediaPathPublish](SUBSTRING((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
					    (SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH('')), 2, 4000)) CategoryValue
						FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId))
                         
					 UPDATE TBAV SET CategoryValue = CTCM.CategoryValue 
					 FROM @TBL_AttributeValue TBAV 
					 INNER JOIN Cte_productMedia CTCM ON(CTCM.PimCategoryId = TBAV.PimCategoryId
					 AND CTCM.PimAttributeId = TBAV.PimAttributeId);

                     WITH Cte_PublishProductIds
					 AS (SELECT TBPC.PublishcategoryId,SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50))
					  FROM ZnodePublishCategoryProduct ZPCP 
					  WHERE ZPCP.PublishCategoryId = TBPC.publishCategoryId
					  AND ZPCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId
                      AND ZPCP.PublishCatalogId = @PublishCatalogId FOR XML PATH('')), 2, 8000) PublishProductId ,PimCategoryHierarchyId
					  FROM @TBL_PublishPimCategoryIds TBPC)
                          
					 UPDATE TBPPC SET PublishProductId = CTPP.PublishProductId FROM @TBL_PublishPimCategoryIds TBPPC INNER JOIN Cte_PublishProductIds CTPP ON(TBPPC.PublishCategoryId = CTPP.PublishCategoryId 
					 AND TBPPC.PimCategoryHierarchyId = CTPP.PimCategoryHierarchyId);

					 WITH Cte_CategoryProfile
						AS (SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
						FROM ZnodeProfileCatalog ZPC 
						INNER JOIN ZnodeProfileCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
						AND ZPRCC.ProfileCatalogId = ZPC.ProfileCatalogId) 
						WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
                      
						FROM ZnodePimCategoryHierarchy ZPCC 
						WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
						WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId = @PimCatalogId 
						AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId))
                          
				     UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds FROM @TBL_PimCategoryIds TBPC 
					 LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
                     
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId));

					   UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )


					-- SELECT * FROM @TBL_AttributeValue WHERE pimCategoryId = 369

					 -- here update the publish category details 
                     ;WITH Cte_UpdateCategoryDetails
                     AS 
					 (
							 SELECT TBC.PimCategoryId,PublishCategoryId,CategoryName, TBPPC.PimCategoryHierarchyId,CategoryCode
							 FROM @TBL_PimCategoryIds TBC
							 INNER JOIN @TBL_PublishPimCategoryIds TBPPC ON(TBC.PimCategoryId = TBPPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPPC.PimCategoryHierarchyId)
					 )						
                     MERGE INTO ZnodePublishCategoryDetail TARGET USING Cte_UpdateCategoryDetails SOURCE ON(
					 TARGET.PublishCategoryId = SOURCE.PublishCategoryId
					 AND TARGET.LocaleId = @LocaleIdIn)
                     WHEN MATCHED THEN UPDATE SET PublishCategoryId = SOURCE.PublishcategoryId,PublishCategoryName = SOURCE.CategoryName,LocaleId = @LocaleIdIn,ModifiedBy = @userId,ModifiedDate = @GetDate,CategoryCode=SOURCE.CategoryCode
                     WHEN NOT MATCHED THEN INSERT(PublishCategoryId,PublishCategoryName,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CategoryCode) VALUES
                     (SOURCE.PublishCategoryId,SOURCE.CategoryName,@LocaleIdIn,@userId,@GetDate,@userId,@GetDate,SOURCE.CategoryCode);

------------------------------------------------------------------
					IF OBJECT_ID('tempdb..#Index') is not null
					BEGIN 
						DROP TABLE #Index
					END 
					CREATE TABLE #Index (RowIndex int ,PimCategoryId int , PimCategoryHierarchyId  int,ParentPimCategoryHierarchyId int )		
					insert into  #Index ( RowIndex ,PimCategoryId , PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
					SELECT CAST(Row_number() OVER (Partition By TBL.PimCategoryId Order by ISNULL(TBL.PimCategoryId,0) desc) AS VARCHAR(100))
					,ZPC.PimCategoryId, ZPC.PimCategoryHierarchyId, ZPC.ParentPimCategoryHierarchyId
					FROM @TBL_PublishPimCategoryIdsLatest TBL
					INNER JOIN ZnodePublishCategory ZPC ON (TBL.PimCategoryId = ZPC.PimCategoryId AND TBL.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId)
					WHERE ZPC.PublishCatalogId = @PublishCatalogId

					UPDATE TBP SET  TBP.[RowIndex]=  IDX.RowIndex 
					FROM @TBL_PublishPimCategoryIdsLatest TBP INNER JOIN #Index IDX ON (IDX.PimCategoryId = TBP.PimCategoryId AND IDX.PimCategoryHierarchyId = TBP.PimCategoryHierarchyId)  

					------------------------------------------------------------------


                     ;WITH Cte_CategoryXML
                     AS (SELECT PublishCatalogLogId,PublishcategoryId,PimCategoryId,(SELECT PublishCatalogLogId VersionId,TBPC.PublishCategoryId ZnodeCategoryId,@PublishCatalogId ZnodeCatalogId
																		,THR.PublishParentCategoryId TempZnodeParentCategoryIds,ZPC.CatalogName ,
																		 ISNULL(DisplayOrder, '0') DisplayOrder,@LocaleIdIn LocaleId,ActivationDate 
																		 ,ExpirationDate,TBC.IsActive,ISNULL(CategoryName, '') Name,ProfileId TempProfileIds,ISNULL(PublishProductId, '') TempProductIds,ISNULL(CategoryCode,'') CategoryCode 
																		 ,ISNULL(TBPC.RowIndex,1) CategoryIndex
                        FROM @TBL_PublishPimCategoryIdsLatest TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId= @PublishCatalogId)
						INNER JOIN ZnodePublishCAtegory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId= @PublishCatalogId )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) 
						WHERE TBPC.PublishCategoryId = TBPCO.PublishCategoryId 
						AND TBPC.LocaleId = @localeIdIn
						FOR XML PATH('')) CategoryXml 
						FROM @TBL_PublishPimCategoryIdsLatest TBPCO 
						WHERE LocaleId = @localeIdIn),

                     Cte_CategoryAttributeXml
                     AS (SELECT PublishCatalogLogId, CTCX.PublishCategoryId,'<CategoryEntity>'+ISNULL(CategoryXml, '')+ISNULL((SELECT(SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
                        ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,(SELECT ''+TBAV.CategoryValue FOR XML PATH('')) AttributeValues,TBA.AttributeTypeName FROM @TBL_AttributeValue TBAV
                        INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
                        WHERE CTCX.PimCategoryId = TBAV.PimCategoryId AND TBAO.PimAttributeId = TBA.PimAttributeId FOR XML PATH('AttributeEntity'), TYPE) FROM @TBL_AttributeIds TBAO
                        FOR XML PATH('Attributes')), '')+'</CategoryEntity>' CategoryXMl FROM Cte_CategoryXML CTCX)

                     INSERT INTO @TBL_CategoryXml(PublishCategoryId,CategoryXml,LocaleId,PublishCatalogLogId)
                     SELECT PublishCategoryId,CategoryXml,@localeIdIn LocaleId,PublishCatalogLogId 
					 FROM Cte_CategoryAttributeXml;
                   
				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;

				

				 -----------------------
			IF @PimCategoryHierarchyId > 0 
			Begin 
				Select PublishCategoryId ,PublishCatalogLogId VersionId	, @PimCatalogId PimCatalogId	, LocaleId
				into #OutPublish  
				FROM @TBL_CategoryXml  
				--group by PimCatalogId,VersionId,PublishCategoryId
  

				Alter TABLE #OutPublish ADD Id int Identity 

				SET @MaxId =(SELECT COUNT(*) FROM #OutPublish);
				--SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(50)) FROM @TBL_PublishPimCategoryIds FOR XML PATH('')), 2, 4000);
				Declare @ExistingPublishCategoryId  nvarchar(max), @PublishCategoryId  int 
				SET @Counter =1 
				WHILE @Counter <= @MaxId -- Loop on Locale id 
				BEGIN
					SELECT @VersionId = VersionId  ,
					@PublishCategoryId = PublishCategoryId 
					from #OutPublish where Id = @Counter

					SELECT @ExistingPublishCategoryId  = PublishCategoryId 
					FROM ZnodePublishCatalogLog ZPCL 
					where ZPCL.PublishCatalogLogId = @VersionId  and IsCategoryPublished =1 

			IF NOT EXISTS (SELECT TOP 1 1 FROM Split(@ExistingPublishCategoryId  , ',') SP WHERE SP.Item = Convert(nvarchar(50),  @PublishCategoryId) )
					BEGIN
					
						If Isnull(@ExistingPublishCategoryId,'')  = '' 
							SET @ExistingPublishCategoryId  = Convert(nvarchar(100),@PublishCategoryId )
						else 
							SET @ExistingPublishCategoryId  = Isnull(@ExistingPublishCategoryId,'') + ',' +  Convert(nvarchar(100),@PublishCategoryId )

							
				
						UPDATE ZnodePublishCatalogLog SET PublishCategoryId = @MaxId ,
						ModifiedDate = @GetDate
						WHERE PublishCatalogLogId = @VersionId;
					END
					DELETE FROM ZnodePublishedXml where  IsCategoryXML =1  and  PublishCataloglogId = @VersionId  and  PublishedId = @PublishCategoryId 
					SET @Counter  = @Counter  + 1  
				END
			END 
			ElSE
			Begin
				 UPDATE ZnodePublishCatalogLog 
				 SET PublishCategoryId = (SELECT COUNT(PublishCategoryId)  FROM @TBL_CategoryXml
				 GROUP BY PublishCategoryId																				
				 ), IsCategoryPublished = 1 WHERE PublishCatalogLogId = @VersionId;

				 DELETE FROM ZnodePublishedXml WHERE PublishCataloglogId = @VersionId;
             End
             
			 INSERT INTO ZnodePublishedXml (PublishCatalogLogId,PublishedId,PublishedXML,IsCategoryXML,IsProductXML,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
             SELECT PublishCatalogLogId PublishCataloglogId,PublishCategoryId,CategoryXml,1,0,LocaleId,@UserId,@GetDate,@UserId,@GetDate 
			 FROM @TBL_CategoryXml 
		
			
			-----------------------------------------------------------------------------------------------------------------------------
			---To get published categories which are published but removed after last publish
			;With Cte_RecursiveAccountId AS
			(
			   SELECT ZPCH.PublishCategoryId ,PimCategoryHierarchyId ,ParentPimCategoryHierarchyId --,PimCategoryId
			   FROM ZnodePublishCategory   ZPCH 
			   WHERE PimCategoryHierarchyId = @PimCategoryHierarchyId
			   UNION ALL 
			   SELECT ZPCH.PublishCategoryId,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId --,ZPCH.PimCategoryId 
			   FROM ZnodePublishCategory   ZPCH 
			   INNER JOIN Cte_RecursiveAccountId CTRA ON (CTRA.PimCategoryHierarchyId = ZPCH.ParentPimCategoryHierarchyId )
			  )
			  select PublishCategoryId from Cte_RecursiveAccountId
			  UNION
			  Select PublishCategoryId from @TBL_DeletedPublishCategoryIds
			  UNION
			  --not published parentcategory
			  SELECT PublishCategoryId FROM ZnodePublishCategory A
			  INNER JOIN @TBL_PimCategoryIds B ON (A.PimCategoryId = B.PimCategoryId)
			  WHERE A.PublishCatalogId = @PublishCataLogId AND B.PimCategoryHierarchyId = A.PimCategoryHierarchyId
			--UNION
			--SELECT DISTINCT PublishCategoryId from ZnodePublishCategory A
			--INNER JOIN @TBL_PimCategoryIds B ON (A.PimParentCategoryId = B.PimCategoryId)
			--WHERE
			--A.PublishCatalogId =@PublishCataLogId

			 SELECT CategoryXml 
			 FROM @TBL_CategoryXml 
			
			 UPDATE ZnodePimCategory SET IsCategoryPublish =1,PublishStateId = @PublishStateId WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_PimCategoryIds)
             COMMIT TRAN GetPublishCategory;
			 
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishCategoryGroup @PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0;
             ROLLBACK TRAN GetPublishCategory;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishCategoryGroup',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 GO
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>CMSWidgetCategoryId</name><headertext>Checkbox</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>y</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>CategoryCode</name><headertext>Category Code</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>CategoryName</name><headertext>Category Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>DisplayOrder</name><headertext>Display Order</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>3</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>Manage</name><headertext>Action</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Edit|Delete</format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Edit|Delete</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl>/WebSite/EditCMSWidgetCategory|/WebSite/RemoveAssociatedCategories</manageactionurl><manageparamfield>cmsWidgetCategoryId|cmsWidgetCategoryId</manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
where ItemName='ZnodeCMSWidgetCategory'
GO

IF EXISTS(SELECT * FROM SYS.PROCEDURES WHERE NAME = 'Znode_ImportPriceList')
	DROP PROC Znode_ImportPriceList
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
			(SKU varchar(300) NULL, TierStartQuantity varchar(300) NULL, RetailPrice varchar(300) NULL, SalesPrice varchar(300) NULL, TierPrice varchar(300) NULL, SKUActivationDate varchar(300) NULL, SKUExpirationDate varchar(300) NULL,
			Custom1 varchar(300) NULL, Custom2 varchar(300) NULL, Custom3 varchar(300) NULL, RowNumber varchar(300) NULL)
	
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
				Custom1 varchar(300) NULL, Custom2 varchar(300) NULL, Custom3 varchar(300) NULL, RowNumber varchar(300)
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
		 Custom1, Custom2, Custom3, RowNumber FROM '+@TableName;
		INSERT INTO #InsertPriceForValidation( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate,
		 Custom1, Custom2, Custom3, RowNumber )
		EXEC sys.sp_sqlexec @SSQL;

		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'TierPrice', TierPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(TierPrice)=0 or TierPrice Like '%£%' or TierPrice Like '%$%') and ISNULL(TierPrice,'')<>''
				
		INSERT INTO ZnodeImportLog( ErrorDescription, ColumnName, Data, GUID, RowNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ImportProcessLogId )
				SELECT '2', 'SalesPrice', SalesPrice, @NewGUId, RowNumber , @UserId, @GetDate, @UserId, @GetDate, @ImportProcessLogId
				FROM #InsertPriceForValidation
				WHERE (isnumeric(SalesPrice)=0 or SalesPrice Like '%£%' or SalesPrice Like '%$%') and ISNULL(SalesPrice,'')<>''
				  	
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
		
		--select * from #InsertPrice
		
		INSERT INTO #InsertPrice( SKU, TierStartQuantity, RetailPrice, SalesPrice, TierPrice, SKUActivationDate, SKUExpirationDate,
		 Custom1, Custom2, Custom3, RowNumber )
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
															   Custom1, Custom2, Custom3, RowNumber
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
				END, ZP.ModifiedBy = @UserId, ZP.ModifiedDate = @GetDate
		FROM #InsertPrice IP INNER JOIN ZnodePrice ZP ON ZP.PriceListId = @PriceListId AND  ZP.SKU = IP.SKU  
			 --Retrive last record from price list of specific SKU ListCode and Name 									
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
if exists(select * from sys.procedures where name = 'Znode_GetPublishAssociatedProducts')
	drop proc Znode_GetPublishAssociatedProducts
go
CREATE PROCEDURE [dbo].[Znode_GetPublishAssociatedProducts]
(   
	@PublishCatalogId VARCHAR(MAX) = '',
    @PimProductId     TransferId Readonly,
    @ProductType      VARCHAR(300) = 'BundleProduct',
    @VersionId        INT          = 0,
    @UserId           INT,
	@PimCategoryHierarchyId int = 0,
	@PublishStateId INT = 0  
)
AS
  /*
    Summary : If PimcatalogId is provided then get all  Bundles / Group / Configurable product and  provide above mentioned data
              If PimProductId is provided then get all Bundles / Group / Configurable if associated with given product id and provide above mentioned data
    		 Input: @PublishCatalogId or @PimProductId
    		 Output should be in XML format
             Required o/p
    			<BundleProductEntity>
    			<ZnodeProductId></ZnodeProductId>
    			<ZnodeCatalogId></ZnodeCatalogId>
    			<AsscociadedZnodeProductIds></AsscociadedZnodeProductIds>
    			</BundleProductEntity>
    Unit Testing 
    BundleProduct
	DECLARE 
    EXEC [dbo].[Znode_GetPublishAssociatedProducts] @PublishCatalogId = 1  , @ProductType = 'BundleProduct' ,@userId = 2 
    EXEC [dbo].[Znode_GetPublishAssociatedProducts] @PublishCatalogId =2 , @ProductType = 'ConfigurableProduct',@userId = 2 ,@PimCategoryHierarchyId = 7 
    Group Product
    EXEC [dbo].[Znode_GetPublishAssociatedProducts]  @PublishCatalogId ='2',@PimProductIdh =''  , @PimProducttType = 'GroupedProduct'
    EXEC [dbo].[Znode_GetPublishAssociatedProducts]  @PublishCatalogId ='',@PimProductId ='200066'  , @PimProducttType = 'GroupedProduct'
    EXEC [dbo].[Znode_GetPublishAssociatedProducts] @PimProductId ='200066'  , @PimProducttType = 'GroupedProduct'
   */
     BEGIN
         BEGIN TRAN GetPublishAssociatedProducts;
         BEGIN TRY
             SET NOCOUNT ON;
			 
			 IF OBJECT_ID('tempdb..#TBL_PublishCatalogId') is not null
				DROP TABLE #TBL_PublishCatalogId
			
			  CREATE TABLE #TBL_PublishCatalogId (PublishCatalogId INT,PublishProductId INT,PimProductId  INT , VersionId INT,LocaleId INT  );
			  DECLARE @PimAttributeId INT = [dbo].[Fn_GetProductTypeAttributeId]()
					  ,@PimAttributeDefaultValueId INT = (SELECT TOP 1 PimAttributeDefaultValueId FROM ZnodePimAttributeDefaultValue WHERE AttributeDefaultValueCode = @ProductType)
					,@DefaultLocaleId INT = dbo.fn_getDefaultlocaleId() 
			 DECLARE @GetDate DATETIME =dbo.Fn_GetDate()
			 
			 DECLARE @TBL_PublisshIds TABLE (PublishProductId INT , PimProductId INT , PublishCatalogId INT)
			 DECLARE  @PimProductId_New TransferId
					 
			 IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			 BEGIN 
			   INSERT INTO @TBL_PublisshIds 
			   EXEC [dbo].[Znode_InsertPublishProductIds] @PublishCatalogId,@userid,@PimProductId,1
			   
			   --SET @PimProductId = SUBSTRING((SELECT DISTINCT ','+CAST(PimProductId AS VARCHAr(50)) FROM @TBL_PublisshIds FOR XML PATH ('')),2,8000 )

			   INSERT INTO @PimProductId_New
			   SELECT DISTINCT PimProductId FROM @TBL_PublisshIds

			  -- SELECT 	@PimProductId	
			 END 
			 
			 IF  ISnull(@PimCategoryHierarchyId,0) <> 0 
			 BEGIN 
			 
			   INSERT INTO @TBL_PublisshIds 
			   EXEC [dbo].[Znode_InsertPublishProductIds] @PublishCatalogId,@userid,@PimProductId,1,@PimCategoryHierarchyId
			   
			   --SET @PimProductId = SUBSTRING((SELECT DISTINCT ','+CAST(PimProductId AS VARCHAr(50)) FROM @TBL_PublisshIds FOR XML PATH ('')),2,8000 )

			   INSERT INTO @PimProductId_New
			   SELECT PimProductId FROM @TBL_PublisshIds

			   
			 END 

			

			 IF  ISnull(@PimCategoryHierarchyId,0) <> 0 
			 BEGIN 
				 INSERT INTO #TBL_PublishCatalogId 
				 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,MAX(ZPCP.PublishCatalogLogId) ,ZPCP.LocaleID  
				 FROM ZnodePublishProduct ZPP 
				 INNER JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = ZPP.PimProductId )
				 INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPV.PimAttributeValueId)
				 LEFT JOIN  ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId)
				 WHERE (EXISTS (SELECT TOP 1 1 FROM @TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId   ) 
				 AND  (ZPP.PublishCatalogId =  @PublishCatalogId ))
				 AND ZPV.PimAttributeId  = @PimAttributeId
				 AND ZPAVL.PimAttributeDefaultValueId= @PimAttributeDefaultValueId
				 AND ZPAVL.LocaleId = @DefaultLocaleId
				 AND ISNULL(ZPCP.LocaleId,0) <> 0 
				 AND ZPCP.PublishStateId= @PublishStateId
				 AND EXISTS(SELECT * FROM ZnodeLocale ZL where ZL.IsActive = 1  and ZPCP.LocaleId = ZL.LocaleId )
				 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,ZPCP.LocaleID 
					
			 END
			 ELSE 
			 BEGIN 
			 
				IF NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0
				BEGIN
					 INSERT INTO #TBL_PublishCatalogId 
					 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,  MAX(ZPCP.PublishCatalogLogId) PublishCatalogLogId	,ZPCP.LocaleID 
					 FROM ZnodePublishProduct ZPP 
					 INNER JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = ZPP.PimProductId )
					 INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPV.PimAttributeValueId)
					 LEFT JOIN  ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId AND ISNULL(ZPCP.LocaleId,0) <> 0 )			 			 
					 WHERE (EXISTS (SELECT TOP 1 1 FROM @TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId  AND  @PublishCatalogId = '' ) 
					 OR (ZPP.PublishCatalogId =  @PublishCatalogId ))
					 AND ZPV.PimAttributeId  = @PimAttributeId
					 AND ZPAVL.PimAttributeDefaultValueId= @PimAttributeDefaultValueId
					 AND ZPAVL.LocaleId = @DefaultLocaleId
					 AND EXISTS(SELECT * FROM ZnodeLocale ZL where ZL.IsActive = 1  and ZPCP.LocaleId = ZL.LocaleId )
					 --AND ISNULL(ZPCP.LocaleId,0) <> 0 
					 --AND CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0   THEN  @PublishStateId ELSE  ZPCP.Publishstateid END  = @PublishStateId
					 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,ZPCP.LocaleID
				END
				ELSE
				BEGIN
					 INSERT INTO #TBL_PublishCatalogId 
					 SELECT ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,  MAX(ZPCP.PublishCatalogLogId) PublishCatalogLogId	,ZPCP.LocaleID 
					 FROM ZnodePublishProduct ZPP 
					 INNER JOIN ZnodePimAttributeValue ZPV ON (ZPV.PimProductId = ZPP.PimProductId )
					 INNER JOIN ZnodePimProductAttributeDefaultValue ZPAVL ON (ZPAVL.PimAttributeValueId = ZPV.PimAttributeValueId)
					 LEFT JOIN  ZnodePublishCatalogLog ZPCP ON (ZPCP.PublishCatalogId  = ZPP.PublishCatalogId AND ISNULL(ZPCP.LocaleId,0) <> 0 )			 			 
					 WHERE (EXISTS (SELECT TOP 1 1 FROM @TBL_PublisshIds SP WHERE SP.PublishProductId = ZPP.PublishProductId  AND  @PublishCatalogId = '' ) 
					 OR (ZPP.PublishCatalogId =  @PublishCatalogId ))
					 AND ZPV.PimAttributeId  = @PimAttributeId
					 AND ZPAVL.PimAttributeDefaultValueId= @PimAttributeDefaultValueId
					 AND ZPAVL.LocaleId = @DefaultLocaleId
					 AND EXISTS(SELECT * FROM ZnodeLocale ZL where ZL.IsActive = 1  and ZPCP.LocaleId = ZL.LocaleId )
					 --AND ISNULL(ZPCP.LocaleId,0) <> 0 
					 --AND CASE WHEN NOT EXISTS (SELECT TOP 1 1 FROM @PimProductId ) AND @PublishCatalogId <> 0   THEN  @PublishStateId ELSE  ZPCP.Publishstateid END  = @PublishStateId
					 AND ZPCP.Publishstateid = @PublishStateId
					 GROUP BY ZPP.PublishCatalogId , ZPP.PublishProductId,ZPP.PimProductId,ZPCP.LocaleID
				END 
				 
			 END
	 		
             DECLARE @TBL_ProductTypeXML TABLE
             (PublishProductId INT,
			  PublishCatalogId INT,
              ReturnXML        XML,
              VersionId        INT
             );
             DECLARE @TBL_PimProductId TABLE
             ([PimProductId]   INT,
              PublishCatalogId INT,
              PublishProductId INT
             );
            
             DECLARE @TBL_PimAssociatedEntity TABLE
             (
			  ZnodeProductId                  INT,
              ZnodeCatalogId                  INT,
              AsscociadedZnodeProductIds  VARCHAR(MAX),
			  ConfigurableProductEntity       NVARCHAR(MAX),
              LocaleId                        INT,
			  DisplayOrder					  INT,
              VersionId                       INT
             );
			
		
		     SET @versionid  =(SELECT TOP 1 VersionId FROM #TBL_PublishCatalogId TBLV )

             IF @ProductType = 'BundleProduct'
             BEGIN
				    
					IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			        BEGIN 
			 		 
						 DELETE FROM ZnodePublishedXML WHERE  IsBundleProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )

					 END 
					 ELSE 
					 BEGIN 
				 
						 DELETE FROM ZnodePublishedXML WHERE  IsBundleProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			           
					 END 

					 IF OBJECT_ID('tempdb..#BundleProductPublishedXML') is not null
						drop table #BundleProductPublishedXML

					 SELECT TBP.PublishProductId, TBP.VersionId, '<BundleProductEntity><VersionId>'+CAST(TBP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeCatalogId>'+CAST(TBP.PublishCatalogId AS VARCHAR(50))+'</ZnodeCatalogId><ZnodeProductId>'
					 +CAST(TBP.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><AssociatedZnodeProductId>'
					 +CAST(TBPU.PublishProductId AS VARCHAR(50))+'</AssociatedZnodeProductId><AssociatedProductDisplayOrder>'+CAST(ISNULL(ZPTA.DisplayOrder,0) AS VARCHAR(50))+'</AssociatedProductDisplayOrder></BundleProductEntity>' ReturnXML 
					 INTO #BundleProductPublishedXML
					 FROM #TBL_PublishCatalogId TBP
					 INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
					 INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )
					 
					 UPDATE TARGET
					 SET  PublishedXML = ReturnXML
						 ,ModifiedBy = @userId 
						 ,ModifiedDate = @GetDate
					 FROM ZnodePublishedXML TARGET
					 INNER JOIN #BundleProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
																	AND TARGET.IsBundleProductXML = 1 AND TARGET.LocaleId = 0 

				 	 INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsBundleProductXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
					 SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
					 FROM #BundleProductPublishedXML SOURCE
					 WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
																	AND TARGET.IsBundleProductXML = 1 AND TARGET.LocaleId = 0 )
                                         
             END;
             ELSE
             IF @ProductType = 'GroupedProduct'
             BEGIN
				  
				     IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
			         BEGIN 
			 		 
						 DELETE FROM ZnodePublishedXML WHERE  IsGroupProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )

					 END 
					 ELSE 
					 BEGIN 					 

						 DELETE FROM ZnodePublishedXML WHERE  IsGroupProductXML = 1 
						 AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			           
					 END 
				     
					 IF OBJECT_ID('tempdb..#GroupedProductPublishedXML') is not null
						drop table #GroupedProductPublishedXML

					 SELECT TBP.PublishProductId, TBP.VersionId, '<GroupProductEntity><VersionId>'+CAST(TBP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeCatalogId>'+CAST(TBP.PublishCatalogId AS VARCHAR(50))+'</ZnodeCatalogId><ZnodeProductId>'
					 +CAST(TBP.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><AssociatedZnodeProductId>'
					 +CAST(TBPU.PublishProductId AS VARCHAR(50))+'</AssociatedZnodeProductId><AssociatedProductDisplayOrder>'+CAST(ISNULL(ZPTA.DisplayOrder,0) AS VARCHAR(50))+'</AssociatedProductDisplayOrder></GroupProductEntity>'  ReturnXML
					 INTO #GroupedProductPublishedXML
					 FROM #TBL_PublishCatalogId TBP
					 INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
					 INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )

					 UPDATE TARGET
					 SET PublishedXML = ReturnXML
						 ,ModifiedBy = @userId 
						 ,ModifiedDate = @GetDate
					 FROM ZnodePublishedXML TARGET
					 INNER JOIN #GroupedProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
																	AND TARGET.IsGroupProductXML = 1 AND TARGET.LocaleId = 0 

				 	 INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsGroupProductXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
					 SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
					 FROM #GroupedProductPublishedXML SOURCE
					 WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
										AND TARGET.IsGroupProductXML = 1 AND TARGET.LocaleId = 0 )

             END;
             ELSE
             IF @ProductType = 'ConfigurableProduct'
             BEGIN
					IF  @PublishCatalogId IS NULL  OR @PublishCatalogId = 0 
					BEGIN 	
						 		 
						DELETE FROM ZnodePublishedXML WHERE  IsConfigProductXML = 1 
						AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
		        
					END 
					ELSE 
					BEGIN 						
							DELETE FROM ZnodePublishedXML WHERE  IsConfigProductXML = 1 
							AND EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLV 
							WHERE ZnodePublishedXML.PublishedId = TBLV.PublishProductId   
							AND ZnodePublishedXML.PublishCatalogLogId = TBLV.VersionId )
			           
							;WITH CTE_ConfigProductXML as
							(
								SELECT DISTINCT TBP.PublishProductId , TBP.VersionId, TBPU.PublishProductId as AssociatedZnodeProductId
								FROM #TBL_PublishCatalogId TBP
								INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
								INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )
							)
							,CTE_PublishedXML as
							(
								SELECT ZPX.PublishCatalogLogId,ZPX.PublishedId,ZPX.IsAddonXML,ZPX.IsConfigProductXML, p.value('(./AssociatedZnodeProductId)[1]', 'INT')  as AssociatedZnodeProductId
								FROM ZnodePublishedXML ZPX
								CROSS APPLY ZPX.PublishedXML.nodes('/ConfigurableProductEntity') t(p)
								where ZPX.IsConfigProductXML = 1
							)
							DELETE ZPXML  
							FROM ZnodePublishedXML ZPXML
							INNER JOIN CTE_PublishedXML CPX	ON ZPXML.PublishCatalogLogId = CPX.PublishCatalogLogId AND ZPXML.PublishedId = CPX.PublishedId AND ZPXML.IsConfigProductXML = CPX.IsConfigProductXML		
							INNER JOIN CTE_ConfigProductXML CAX on CPX.PublishCatalogLogId = CAX.VersionId 
							AND CPX.PublishedId = CAX.PublishProductId
							AND CPX.IsConfigProductXML = 1
							AND CPX.AssociatedZnodeProductId = CAX.AssociatedZnodeProductId
					 END 
						IF OBJECT_ID('tempdb..#ConfigurableProductPublishedXML') is not null
							drop table #ConfigurableProductPublishedXML

						SELECT DISTINCT TBP.PublishProductId , TBP.VersionId, '<ConfigurableProductEntity><VersionId>'+CAST(TBP.VersionId AS VARCHAR(50))+'</VersionId><ZnodeCatalogId>'+CAST(TBP.PublishCatalogId AS VARCHAR(50))+'</ZnodeCatalogId><ZnodeProductId>'
						+CAST(TBP.PublishProductId AS VARCHAR(50))+'</ZnodeProductId><AssociatedZnodeProductId>'
						+CAST(TBPU.PublishProductId AS VARCHAR(50))+'</AssociatedZnodeProductId><AssociatedProductDisplayOrder>'+CAST(ISNULL(ZPTA.DisplayOrder,0) AS VARCHAR(50))+'</AssociatedProductDisplayOrder>'
						+(SELECT DISTINCT  ZPA.AttributeCode ConfigurableAttributeCode 
														FROM ZnodePimConfigureProductAttribute ZPCPA 
														LEFT JOIN ZnodePimAttribute ZPA ON (Zpa.PimAttributeId = ZPCPA.PimAttributeId) 
														WHERE  ZPCPA.PimProductId = TBP.PimProductId 
														FOR XML PATH('ConfigurableAttributeCodes')) +'</ConfigurableProductEntity>'  ReturnXML
						INTO #ConfigurableProductPublishedXML
						FROM #TBL_PublishCatalogId TBP
						INNER JOIN ZnodePimProductTypeAssociation ZPTA ON(ZPTA.PimParentProductId = TBP.PimProductId)
						INNER JOIN ZnodePublishProduct TBPU ON (TBPU.PimProductId = ZPTA.PimProductId AND TBPU.PublishCatalogId = TBP.PublishCatalogId )
			
						UPDATE TARGET
						SET PublishedXML = ReturnXML
								, ModifiedBy = @userId 
								,ModifiedDate = @GetDate
						FROM ZnodePublishedXML TARGET
						INNER JOIN #ConfigurableProductPublishedXML SOURCE ON TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId AND TARGET.IsConfigProductXML = 1 AND TARGET.LocaleId = 0
																			   AND TARGET.IsConfigProductXML = 1 AND TARGET.LocaleId = 0

						INSERT  INTO ZnodePublishedXML(PublishCatalogLogId ,PublishedId ,PublishedXML ,IsConfigProductXML ,LocaleId ,CreatedBy ,CreatedDate ,ModifiedBy ,ModifiedDate)
						SELECT SOURCE.versionid , Source.PublishProductid,Source.ReturnXML,1,0,@userId,@getDate,@userId,@getDate
						FROM #ConfigurableProductPublishedXML SOURCE
						WHERE NOT EXISTS(select * from ZnodePublishedXML TARGET where TARGET.PublishCatalogLogId = SOURCE.versionId AND TARGET.PublishedId = SOURCE.PublishProductId
										 AND TARGET.IsConfigProductXML = 1 AND TARGET.LocaleId = 0 )

             END;

				

			SELECT PublishedXML ReturnXML
			FROM ZnodePublishedXML  ZPXM 
			WHERE EXISTS (SELECT TOP 1 1 FROM #TBL_PublishCatalogId TBLP WHERE TBLP.VersionId = ZPXM.PublishCatalogLogId and TBLP.PublishProductid = ZPXm.PublishedId )
			AND IsConfigProductXML = CASE WHEN @ProductType = 'ConfigurableProduct' THEN  1 ELSE 0 END 
			AND IsGroupProductXML = CASE WHEN @ProductType = 'GroupedProduct' THEN  1 ELSE 0 END 
			AND IsBundleProductXML = CASE WHEN @ProductType = 'BundleProduct' THEN  1 ELSE 0 END 
				  

			IF OBJECT_ID('tempdb..#TBL_PublishCatalogId') is not null
				drop table #TBL_PublishCatalogId

			IF OBJECT_ID('tempdb..#ConfigurableProductPublishedXML') is not null
				drop table #ConfigurableProductPublishedXML
		
		    COMMIT TRAN GetPublishAssociatedProducts;
			
         END TRY
         BEGIN CATCH
		    SELECT ERROR_MESSAGE()
            DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishAssociatedProducts @PublishCatalogId = '+@PublishCatalogId+',@ProductType= '+@ProductType+',@VersionId='+CAST(@VersionId AS VARCHAR(50))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
			ROLLBACK TRANSACTION GetPublishAssociatedProducts;
			EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetPublishAssociatedProducts',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;

go
update  ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PromotionId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PromoCode</name>      <headertext>Promotion Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Name</name>      <headertext>Promotion Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Discount</name>      <headertext>Discount</headertext>      <width>40</width>      <datatype>Decimal</datatype>      <columntype>Decimal</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PromotionTypeName</name>      <headertext>Discount Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>QuantityMinimum</name>      <headertext>Minimum Quantity</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>OrderMinimum</name>      <headertext>Minimum Order</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>StartDate</name>      <headertext>Start Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>EndDate</name>      <headertext>End Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete|View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>shippingId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete|View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Promotion/Edit|/Promotion/Delete</manageactionurl>      <manageparamfield>promotionId|promotionId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodePromotion'
go
UPDATE ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>VersionId</name>      <headertext>Checkbox</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>SourcePublishState</name>      <headertext>Publish State</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>LocaleDisplayValue</name>      <headertext>Locale</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>LogCreatedDate</name>      <headertext>Created On</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PreviousVersionId</name>      <headertext>Previous Version</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Delete</format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>VersionId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/PublishHistory/DeletePublishHistory</manageactionurl>      <manageparamfield>VersionId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
WHERE ItemName ='ZnodePublishHistory'
go
if exists(select * from sys.procedures where name = 'Znode_GetProductInfoForWebStore')
	drop proc Znode_GetProductInfoForWebStore
go
CREATE PROCEDURE [dbo].[Znode_GetProductInfoForWebStore]
(   
	@PortalId         INT,
    @LocaleId         INT,
	@UserId			  INT = 2,
	@currentUtcDate    VARCHAR(200) = '',
	@ProductDetailsFromWebStore   DBO.ProductDetailsFromWebStore READONLY,
	@IsAllLocation bit =0)
AS 
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
			 
			 DECLARE @Tlb_SKU TABLE (SKU VARCHAR(100))
			 DECLARE @PublishProductIds  NVARCHAR(max) ,@SKU NVARCHAR(max) 

			 DECLARE @Fn_GetDefaultLocaleId int = Dbo.Fn_GetDefaultLocaleId()
				
			 DECLARE @TBL_PricebyCatalogforAssociateProduct TABLE (PimProductId int ,AssociatedProductId int,ParentSKU NVARCHAR(300),
				ChildSKU NVARCHAR(300),RetailPrice  numeric(28,6),AssociatedProductDisplayOrder int ,
				TypeOfProduct nvarchar(100),SalesPrice  numeric(28,6))
		     DECLARE @tbl_PricingSkuOfAssociatedProduct TABLE (sku nvarchar(200),RetailPrice numeric(28,6),SalesPrice numeric(28,6),TierPrice numeric(28,6),
				TierQuantity numeric(28,6),CurrencyCode varchar(200),CurrencySuffix varchar(2000), ExternalId NVARCHAR(2000))				
		

			--Create TABLE #Tlb_PromotionProductData 
   --          (
			--	  PromotionId      INT,
			--	  PromotionType	   INT, 
			--	  ExpirationDate   Datetime, 
			--	  ActivationDate   Datetime,
			--	  PublishProductId INT,
			--	  PromotionMessage Nvarchar(max)  
   --          );
			 Create TABLE #Tbl_PriceListWisePrice 
             (
				  SKU            VARCHAR(300),
				  RetailPrice    NUMERIC(28, 6),
				  SalesPrice     NUMERIC(28, 6),
				  TierPrice      NUMERIC(28, 6),
				  TierQuantity   NUMERIC(28, 6),
				  CurrencyCode   Varchar(100),
				  CurrencySuffix Varchar(1000),
				  CultureCode      VARCHAr(1000),
				  ExternalId NVARCHAR(2000),
				  Custom1        NVARCHAR(MAX),
				  Custom2        NVARCHAR(MAX),
				  Custom3        NVARCHAR(MAX)
             );

			 CREATE TABLE #Tlb_ProductData 
             (
				  PublishProductId INT,
				  SKU              NVARCHAR(100),
				  SEOTitle         NVARCHAR(200),
				  SEODescription   NVARCHAR(MAX),
				  SEOKeywords      NVARCHAR(MAX),
				  SEOUrl           NVARCHAR(MAX),
				  Rating           Numeric(28,6),
				  TotalReviews     INT,
				  RetailPrice      NUMERIC(28, 6),
				  SalesPrice       NUMERIC(28, 6),
				  TierPrice        NUMERIC(28, 6),
				  TierQuantity     NUMERIC(28, 6),
				  CurrencyCode     Varchar(100),
				  CurrencySuffix   Varchar(1000),
				
				  ExternalId       NVARCHAR(2000),
				  Quantity    NUMERIC(28, 6),
				  ReOrderLevel     NUMERIC(28, 6),
				  Custom1        NVARCHAR(MAX),
				  Custom2        NVARCHAR(MAX),
				  Custom3        NVARCHAR(MAX),
				  CanonicalURL VARCHAR(200),   
				  RobotTag VARCHAR(50)
			   );


			 Create TABLE #Tbl_Inventory
             (
				  SKU            VARCHAR(300),
				  Quantity    NUMERIC(28, 6),
				  ReOrderLevel     NUMERIC(28, 6),
				  PortalId      int
				
             );
			 
			 Create TABLE #Tbl_WarehouseWiseInventory
             (
				  SKU            VARCHAR(300),
				  Quantity    NUMERIC(28, 6),
				  ReOrderLevel NUMERIC(28, 6),
				  PortalId      int,
				  WarehouseCode VARCHAR(100),
				  WarehouseName VARCHAR(100),
				  IsDefaultWarehouse BIT

             );

            INSERT INTO #Tlb_ProductData (PublishProductId,SKU)
            SELECT id,SKU FROM @ProductDetailsFromWebStore
			  		
			SELECT @SKU = Substring((SELECT ',' + SKU FROM @ProductDetailsFromWebStore FOR XML PAth('')),2,4000) 

			SELECT @PublishProductIds = Substring((SELECT ',' + CONVERT(NVARCHAR(100),id ) FROM @ProductDetailsFromWebStore FOR XML PAth('')),2,4000) 
			
			--INSERT INTO  #Tlb_PromotionProductData(PromotionId,PromotionType, ExpirationDate,  ActivationDate, PublishProductId,PromotionMessage)
			--Exec [Znode_GetPromotionByPublishProductId] @PublishProductIds = @PublishProductIds ,@UserId  = @UserId	,@PortalId  = @PortalId  
			 
			INSERT INTO #Tbl_PriceListWisePrice( SKU, RetailPrice,SalesPrice,TierPrice,TierQuantity,CurrencyCode,CurrencySuffix,CultureCode,ExternalId,Custom1,Custom2,Custom3)
			EXEC Znode_GetPublishProductPricingBySku @SKU = @SKU ,@PortalId = @PortalId ,@currentUtcDate = @currentUtcDate,@UserId = @UserId 

			IF @IsAllLocation=1
			BEGIN 
				Insert into #Tbl_WarehouseWiseInventory(SKU,	Quantity,ReOrderLevel,PortalId,	WarehouseCode,	WarehouseName,	IsDefaultWarehouse)
				EXEC Znode_GetWarehouseInventoryBySkus  @SKUs=@SKU,@PortalId=@PortalId
			END

			insert into #Tbl_Inventory (SKU,	Quantity,	ReOrderLevel,	PortalId)
			EXEC Znode_GetInventoryBySkus @SKUs=@SKU,@PortalId=@PortalId
			
			--Price logic for Associate products
			----INSERT INTO @TBL_PricebyCatalogforAssociateProduct(AssociatedProductId,ChildSKU,ParentSKU,PimProductId,RetailPrice,SalesPrice,TypeOfProduct)
			----SELECT cl.Item, NULL , PR.SKU, PR.ID, null, null , PR.[ProductType]  FROM @ProductDetailsFromWebStore PR
			----Cross Apply dbo.split (AssociateProducts, ',') CL 

			----UPDATE PDI SET PDI.ChildSKU = ZPPD.SKU 
			----from @TBL_PricebyCatalogforAssociateProduct PDI inner join
			----ZnodePublishProductDetail ZPPD On PDI.AssociatedProductId = ZPPD.PublishProductId
			
			----SELECT @SKU = Substring((SELECT ',' + Convert(nvarchar(100),AssociatedProductId) 
			----FROM @TBL_PricebyCatalogforAssociateProduct where AssociatedProductId is not null FOR XML PAth('')),2,4000) 

			----INSERT INTO @tbl_PricingSkuOfAssociatedProduct (SKU,RetailPrice ,SalesPrice,TierPrice,TierQuantity,CurrencyCode,CurrencySuffix, ExternalId)	
			----EXEC Znode_GetPublishProductPricingBySku  @Sku ,@portalID  ,@currentUtcDate,@UserId 

			----update PLC SET PLC.RetailPrice = PLCA.RetailPrice ,
			----PLC.SalesPrice = PLCA.SalesPrice 
			----from @TBL_PricebyCatalogforAssociateProduct PLC inner join @tbl_PricingSkuOfAssociatedProduct
			----PLCA on PLC.ChildSKU = PLCA.sku
			
			----Update PBC SET PBC.RetailPrice = 
			----	(Select TOP 1 Isnull(RetailPrice ,SalesPrice) from @TBL_PricebyCatalogforAssociateProduct PCBA  where PCBA.ParentSKU =PBC.SKU
			----		and PCBA.ParentSKU is not null and PCBA.ChildSKU is not null
			----	Order by AssociatedProductDisplayOrder)
			----	from #Tbl_PriceListWisePrice  PBC  where 
			----	Exists (Select TOP 1 1  from @TBL_PricebyCatalogforAssociateProduct PCBA
			----	where PCBA.ParentSKU =PBC.SKU and PCBA.TypeOfProduct = 'ConfigurableProduct')
			----	and PBC.RetailPrice IS null 

			Update PD SET 
			 PD.SKU             = PLWP.SKU            
			,PD.RetailPrice     = PLWP.RetailPrice     
			,PD.SalesPrice      = PLWP.SalesPrice      
			,PD.TierPrice       = PLWP.TierPrice       
			,PD.TierQuantity    = PLWP.TierQuantity    
			,PD.CurrencyCode    = PLWP.CurrencyCode    
			,PD.CurrencySuffix  = PLWP.CurrencySuffix  
			,PD.ExternalId 	    = PLWP.ExternalId
			,PD.Custom1			= PLWP.Custom1
			,PD.Custom2			= PLWP.Custom2
			,PD.Custom3			= PLWP.Custom3
			FROM #Tlb_ProductData PD Inner join #Tbl_PriceListWisePrice PLWP on 
			PD.SKU = PLWP.SKU

			Update PD SET 
			 PD.Quantity = TLI.Quantity,
			 PD.ReOrderLevel= TLI.ReOrderLevel
			 FROM #Tlb_ProductData PD Inner join #Tbl_Inventory TLI on 
			PD.SKU = TLI.SKU

			 

			----Update PD SET 
			----	  PD.PromotionId      =PLWP.PromotionId,
			----	  PD.PromotionType	  =PLWP.PromotionType, 
			----	  PD.ExpirationDate   =PLWP.ExpirationDate, 
			----	  PD.ActivationDate   =PLWP.ActivationDate,
			----	  PD.PublishProductId =PLWP.PublishProductId,
			----	  PD.PromotionMessage  =PLWP.PromotionMessage   
			----from #Tlb_ProductData PD Inner join #Tlb_PromotionProductData PLWP on 
			----PD.PublishProductId = PLWP.PublishProductId


			 DECLARE @Tlb_CustomerAverageRatings TABLE
             (PublishProductId INT,
              Rating           NUMERIC(28,6),
              TotalReviews     INT
             ); 
             -- Calculate Average rating 
             INSERT INTO @Tlb_CustomerAverageRatings(PublishProductId,Rating,TotalReviews)
             SELECT CCR.PublishProductId,SUM(CAST(CCR.Rating AS NUMERIC(28,6)) )/ COUNT(CCR.PublishProductId),COUNT(CCR.PublishProductId) 
			 FROM ZnodeCMSCustomerReview AS CCR
             INNER JOIN #Tlb_ProductData AS PD ON CCR.PublishProductId = PD.PublishProductId AND CCR.Status = 'A' 
			 AND  (CCR.PortalId  = @PortalId OR @PortalId = 0 )
			 GROUP BY CCR.PublishProductId    ;

             UPDATE PD SET PD.Rating = CAR.Rating,PD.TotalReviews = CAR.TotalReviews 
			 FROM @Tlb_CustomerAverageRatings CAR
             INNER JOIN #Tlb_ProductData PD ON CAR.PublishProductId = PD.PublishProductId;

             UPDATE PD SET PD.SEOTitle = ZCSDL.SEOTitle,PD.SEODescription = ZCSDL.SEODescription,PD.SEOKeywords = ZCSDL.SEOKeywords,PD.SEOUrl = ZCSO.SEOUrl,
			               PD.CanonicalURL = ZCSDL.CanonicalURL, PD.RobotTag = ZCSDL.RobotTag
			 FROM #Tlb_ProductData PD
             INNER JOIN ZnodeCMSSEODetail ZCSO ON PD.SKU = ZCSO.SEOCode
             LEFT JOIN ZnodeCMSSEODetailLocale ZCSDL ON(ZCSDL.CMSSEODetailId = ZCSO.CMSSEODetailId AND ZCSDL.LocaleId = @LocaleId)
             INNER JOIN ZnodeCMSSEOType ZCOT ON ZCOT.CMSSEOTypeId = ZCSO.CMSSEOTypeId AND ZCOT.Name = 'Product'
			 WHERE ZCSO.PortalId = @PortalId
             
			 --UPDATE PD SET PD.SEOTitle = ZCSDL.SEOTitle,PD.SEODescription = ZCSDL.SEODescription,PD.SEOKeywords = ZCSDL.SEOKeywords,PD.SEOUrl = ZCSO.SEOUrl 
			 --FROM #Tlb_ProductData PD
    --         INNER JOIN ZnodeCMSSEODetail ZCSO ON PD.SKU = ZCSO.SEOCode
    --         LEFT JOIN ZnodeCMSSEODetailLocale ZCSDL ON(ZCSDL.CMSSEODetailId = ZCSO.CMSSEODetailId AND ZCSDL.LocaleId = @LocaleId)
    --         INNER JOIN ZnodeCMSSEOType ZCOT ON ZCOT.CMSSEOTypeId = ZCSO.CMSSEOTypeId AND ZCOT.Name = 'Product'
			 --WHERE ZCSO.PortalId = @PortalId

             UPDATE PD SET PD.SEOTitle = ZCPS.ProductTitle,PD.SEODescription = ZCPS.ProductDescription,PD.SEOKeywords = ZCPS.ProductKeyword FROM #Tlb_ProductData PD
             INNER JOIN ZnodeCMSPortalSEOSetting ZCPS ON ZCPS.PortalId = @PortalId WHERE PD.SEOTitle IS NULL AND PD.SEODescription IS NULL AND PD.SEOKeywords IS NULL AND PD.SEOUrl IS NULL
			  --AND ZCSO.PortalId = @PortalId

			 
			 -- ;With Cte_Catalogdaata AS 
			 --(
			   SELECT  a.PublishCatalogId ,Max(PublishCatalogLogId) PublishCatalogLogId
			   into #Cte_Catalogdaata
			   FROM ZnodePortalCatalog a 
			   INNER JOIN ZnodePublishCatalogLog b ON (b.PublishCatalogId = a.PublishCatalogId )
			   WHERE a.PortalId = @PortalId
			   GROUP BY a.PublishCatalogId 
	 
			 --)
			 SELECT Row_Number()Over( PARTITION BY  BTY.SKU ORDER BY ZPAP.DisplayOrder, ZPAP.PublishAssociatedProductId) RowId ,
					BTY.SKU ParentSKU, BTY1.SKU --, UI.Quantity, UI.ReOrderLevel ,UI.WarehouseId
			 INTO #TempPublishData
			 FROM ZnodePublishProduct CTR 
			 INNER JOIN ZnodePublishProductDetail BTY ON (BTY.PublishProductId = CTR.PublishProductId)
			 INNER JOIN ZnodePublishAssociatedProduct ZPAP ON (ZPAP.ParentPimProductId = CTR.PimProductId)	
			 INNER JOIN ZnodePublishProduct CTR1 ON (ZPAP.PimProductId = CTR1.PimProductId)
			 INNER JOIN ZnodePublishProductDetail BTY1 ON (BTY1.PublishProductId = CTR1.PublishProductId)
			 --LEFT JOIN ZnodeInventory UI ON (UI.SKU = BTY1.SKU)
			 WHERE ZPAP.IsConfigurable = 1  
			 AND EXISTS (SELECT TOP 1 1 FROM #Cte_Catalogdaata TY WHERE TY.PublishCatalogId = CTR.PublishCatalogId )-- AND TY.PublishCatalogLogId =ZPXML.PublishCatalogLogId)
			 AND EXISTS (SELECT TOP 1 1 FROM #Tlb_ProductData TU WHERE TU.SKU = BTY.SKU)
			 AND BTY.LocaleId = @Fn_GetDefaultLocaleId
			 AND BTY1.LocaleId = @Fn_GetDefaultLocaleId

			 alter table #TempPublishData add Quantity numeric(28,6), ReOrderLevel numeric(28,6), WarehouseId int

			 update TPD set Quantity = UI.Quantity ,  ReOrderLevel = UI.ReOrderLevel , WarehouseId = UI.WarehouseId
			 from #TempPublishData TPD
			 inner join ZnodeInventory UI ON (UI.SKU = TPD.SKU)

			DELETE FROM #TempPublishData WHERE RowId <> 1
			IF @IsAllLocation=1
			BEGIN 
				SELECT A.PublishProductId,a.SKU,a.SEOTitle,a.SEODescription,a.SEOKeywords,a.SEOUrl,a.Rating,a.TotalReviews ,  
				a.RetailPrice,a.SalesPrice,a.TierPrice, a.TierQuantity,a.CurrencyCode,a.CurrencySuffix,a.ExternalId, 
				CASE WHEN TYI.ParentSKU IS NULL AND ZPCPA.PimProductId IS NULL THEN  b.Quantity ELSE ISNULL(TYI.Quantity,0) END as Quantity , 
				CASE WHEN TYI.ParentSKU IS NULL THEN  b.ReOrderLevel ELSE TYI.ReOrderLevel END ReOrderLevel, a.CanonicalURL, a.RobotTag,
				INV.Quantity AllLocationQuantity,
				b.WarehouseCode,b.WarehouseName,ISNULL(b.IsDefaultWarehouse,0) AS IsDefaultWarehouse
				FROM #Tlb_ProductData a
				LEFT JOIN #TempPublishData TYI ON (TYI.ParentSKU = a.SKU AND  TYI.WarehouseId  IN (SELECT  WarehouseId FROM ZnodePortalWarehouse WHERE PortalId = @PortalId))
				LEFT JOIN  #Tbl_WarehouseWiseInventory   b ON b.SKU  = a.SKU   
				LEFT JOIN ZnodePublishProduct ZPP on a.PublishProductId = ZPP.PublishProductId 
				LEFT join ZnodePimConfigureProductAttribute ZPCPA on ZPP.PimProductId = ZPCPA.PimProductId
				LEFT JOIN #Tbl_Inventory INV ON b.SKU = INV.SKU
			END
			ELSE 
			Begin 
			 SELECT A.PublishProductId,a.SKU,a.SEOTitle,a.SEODescription,a.SEOKeywords,a.SEOUrl,a.Rating,a.TotalReviews ,  
					a.RetailPrice,a.SalesPrice,a.TierPrice, a.TierQuantity,a.CurrencyCode,a.CurrencySuffix,a.ExternalId, 
					CASE WHEN TYI.ParentSKU IS NULL AND ZPCPA.PimProductId IS NULL THEN  b.Quantity ELSE ISNULL(TYI.Quantity,0) END as Quantity , 
			 CASE WHEN TYI.ParentSKU IS NULL THEN  b.ReOrderLevel ELSE TYI.ReOrderLevel END ReOrderLevel, a.CanonicalURL, a.RobotTag,
			 INV.Quantity AllLocationQuantity
			 FROM #Tlb_ProductData a
			 LEFT JOIN #TempPublishData TYI ON (TYI.ParentSKU = a.SKU AND  TYI.WarehouseId  IN (SELECT  WarehouseId FROM ZnodePortalWarehouse WHERE PortalId = @PortalId))
			 LEFT JOIN ZnodeInventory b ON (b.SKU  = a.SKU  AND  b.WarehouseId  IN (SELECT  WarehouseId FROM ZnodePortalWarehouse WHERE PortalId = @PortalId)) 
			 LEFT JOIN ZnodePublishProduct ZPP on a.PublishProductId = ZPP.PublishProductId 
			 LEFT join ZnodePimConfigureProductAttribute ZPCPA on ZPP.PimProductId = ZPCPA.PimProductId
			 LEFT JOIN #Tbl_Inventory INV ON b.SKU = INV.SKU
			 END
			
			
         END TRY
         BEGIN CATCH
		
              DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), 
			 @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(),
			  @ErrorLine VARCHAR(100)= ERROR_LINE(),
			   @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetProductInfoForWebStore @PortalId='+CAST(@PortalId AS VARCHAR(50))+',@LocaleId='+CAST(@LocaleId AS VARCHAR(50));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetProductInfoForWebStore',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

update ZnodePimAttribute set HelpDescription= 'Enter the minimum quantity that can be selected when adding an item to the cart.' where AttributeCode = 'MinimumQuantity'
GO
update ZnodePimAttribute set HelpDescription= 'Enter the maximum quantity that can be selected when adding an item to the cart.' where AttributeCode = 'MaximumQuantity'
go
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>CMSWidgetProductId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>SKU</name>      <headertext>SKU</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Image</name>      <headertext>Image</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>ImagePath,ProductImage</imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>imageicon</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>ProductName</name>      <headertext>Product Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>ProductType</name>      <headertext>Product Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>ModifiedDate</name>      <headertext>Modified Date</headertext>      <width>40</width>      <datatype>DateTime</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>0</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>3</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>y</iscontrol>      <controltype>Text</controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Edit|Delete</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/WebSite/EditCMSAssociateProduct|/WebSite/UnassociateProduct</manageactionurl>      <manageparamfield>CMSWidgetProductId|CMSWidgetProductId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where itemname='AssociatedCMSOfferPageProduct'
GO
update  ZnodeApplicationSetting 
SET Setting='<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>CMSWidgetBrandId</name><headertext>Checkbox</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>y</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>BrandId</name><headertext>ID</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>BrandName</name><headertext>Brand Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>DisplayOrder</name><headertext>Display Order</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>3</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>Manage</name><headertext>Action</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Edit|Delete</format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Edit|Delete</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl>/WebSite/EditCMSWidgetBrand|/WebSite/RemoveAssociatedBrands</manageactionurl><manageparamfield>cmsWidgetBrandId|cmsWidgetBrandId</manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
WHERE ItemName ='ZnodeCMSWidgetBrand'
GO
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?><columns><column><id>1</id><name>CMSWidgetCategoryId</name><headertext>Checkbox</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>y</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>2</id><name>CategoryCode</name><headertext>Category Code</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>3</id><name>CategoryName</name><headertext>Category Name</headertext><width>30</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>y</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>y</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>4</id><name>DisplayOrder</name><headertext>Display Order</headertext><width>0</width><datatype>Int32</datatype><columntype>Int32</columntype><allowsorting>true</allowsorting><allowpaging>true</allowpaging><format></format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>3</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>y</iscontrol><controltype>Text</controltype><controlparamfield></controlparamfield><displaytext></displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl></manageactionurl><manageparamfield></manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column><column><id>5</id><name>Manage</name><headertext>Action</headertext><width>0</width><datatype>String</datatype><columntype>String</columntype><allowsorting>false</allowsorting><allowpaging>true</allowpaging><format>Edit|Delete</format><isvisible>y</isvisible><mustshow>n</mustshow><musthide>n</musthide><maxlength>0</maxlength><isallowsearch>n</isallowsearch><isconditional>n</isconditional><isallowlink>n</isallowlink><islinkactionurl></islinkactionurl><islinkparamfield></islinkparamfield><ischeckbox>n</ischeckbox><checkboxparamfield></checkboxparamfield><iscontrol>n</iscontrol><controltype></controltype><controlparamfield></controlparamfield><displaytext>Edit|Delete</displaytext><editactionurl></editactionurl><editparamfield></editparamfield><deleteactionurl></deleteactionurl><deleteparamfield></deleteparamfield><viewactionurl></viewactionurl><viewparamfield></viewparamfield><imageactionurl></imageactionurl><imageparamfield></imageparamfield><manageactionurl>/WebSite/EditCMSWidgetCategory|/WebSite/RemoveAssociatedCategories</manageactionurl><manageparamfield>cmsWidgetCategoryId|cmsWidgetCategoryId</manageparamfield><copyactionurl></copyactionurl><copyparamfield></copyparamfield><xaxis>n</xaxis><yaxis>n</yaxis><isadvancesearch>y</isadvancesearch><Class></Class><SearchControlType>--Select--</SearchControlType><SearchControlParameters></SearchControlParameters><DbParamField></DbParamField><useMode>DataBase</useMode><IsGraph>n</IsGraph><allowdetailview>n</allowdetailview></column></columns>'
where ItemName='ZnodeCMSWidgetCategory'
go
Update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>      <column>          <id>1</id>          <name>CMSTemplateId</name>          <headertext>Checkbox</headertext>          <width>30</width>          <datatype>Int32</datatype>          <columntype>Int32</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>y</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>y</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>2</id>          <name>Image</name>          <headertext>Image</headertext>          <width>20</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>false</allowsorting>          <allowpaging>false</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>y</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield>MediaPath,Name</imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>n</isadvancesearch>          <Class>imageicon</Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>3</id>          <name>Name</name>          <headertext>Template Name</headertext>          <width>60</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>y</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>y</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>y</isallowlink>          <islinkactionurl>/Template/Edit</islinkactionurl>          <islinkparamfield>CMSTemplateId</islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>4</id>          <name>FileName</name>          <headertext>File Name</headertext>          <width>60</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>true</allowsorting>          <allowpaging>true</allowpaging>          <format></format>          <isvisible>y</isvisible>          <mustshow>n</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>y</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext></displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl></manageactionurl>          <manageparamfield></manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>      <column>          <id>5</id>          <name>Manage</name>          <headertext>Action</headertext>          <width>30</width>          <datatype>String</datatype>          <columntype>String</columntype>          <allowsorting>false</allowsorting>          <allowpaging>false</allowpaging>          <format>Edit|Download|Copy|Delete</format>          <isvisible>y</isvisible>          <mustshow>y</mustshow>          <musthide>n</musthide>          <maxlength>0</maxlength>          <isallowsearch>n</isallowsearch>          <isconditional>n</isconditional>          <isallowlink>n</isallowlink>          <islinkactionurl></islinkactionurl>          <islinkparamfield></islinkparamfield>          <ischeckbox>n</ischeckbox>          <checkboxparamfield></checkboxparamfield>          <iscontrol>n</iscontrol>          <controltype></controltype>          <controlparamfield></controlparamfield>          <displaytext>Edit|Download|Copy|Delete</displaytext>          <editactionurl></editactionurl>          <editparamfield></editparamfield>          <deleteactionurl></deleteactionurl>          <deleteparamfield></deleteparamfield>          <viewactionurl></viewactionurl>          <viewparamfield></viewparamfield>          <imageactionurl></imageactionurl>          <imageparamfield></imageparamfield>          <manageactionurl>/Template/Edit|/Template/DownloadTemplate|/Template/Copy|/Template/Delete</manageactionurl>          <manageparamfield>CMSTemplateId|CMSTemplateId,FileName|CMSTemplateId|CMSTemplateId,FileName</manageparamfield>          <copyactionurl></copyactionurl>          <copyparamfield></copyparamfield>          <xaxis>n</xaxis>          <yaxis>n</yaxis>          <isadvancesearch>y</isadvancesearch>          <Class></Class>          <SearchControlType>--Select--</SearchControlType>          <SearchControlParameters></SearchControlParameters>          <DbParamField></DbParamField>          <useMode>DataBase</useMode>          <IsGraph>n</IsGraph>          <allowdetailview>n</allowdetailview>      </column>  </columns>'
where ItemName='ZnodeCMSTemplate'
go

if exists(select * from sys.procedures where name = 'Znode_GetSearchRuleDetails')
	drop proc Znode_GetSearchRuleDetails
go
CREATE PROCEDURE [dbo].[Znode_GetSearchRuleDetails]
(
	@WhereClause         VARCHAR(MAX)  = '',
    @Rows                INT           = 100,
    @PageNo              INT           = 1,
    @Order_BY            VARCHAR(1000) = '',
    @RowsCount           INT OUT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		Declare @TBL_SerchRuleDetail Table (SearchCatalogRuleId Int, RuleName varchar(600), UserName nvarchar(512), CreatedDate Datetime, StartDate Datetime, EndDate Datetime, IsPause Bit,RowId Int, CountId Int)
		Declare @SQL Varchar(max)

		SET @SQL = '
		;With Cte_SerchRuleDetail As'+
		+'('+
			+' SELECT ZSCR.publishcatalogid, ZSCR.SearchCatalogRuleId, ZSCR.RuleName, ANZU.UserName, ZSCR.CreatedDate, ZSCR.StartDate, ZSCR.EndDate, ZSCR.IsPause '+ 
			+' FROM ZnodeSearchCatalogRule ZSCR '+ 
			+' LEFT JOIN ZnodeUser ZU ON ZSCR.CreatedBy = ZU.UserId '+
			+' INNER JOIN AspNetUsers ANU ON ZU.AspNetUserId = ANU.Id '+
			+' INNER JOIN AspNetZnodeUser ANZU ON ANU.UserName = ANZU.AspNetZnodeUserId '+
		 +')'+
		 +',Cte_SerchRuleDetail_OrderBy AS '+
		 +'('
			+' SELECT publishcatalogid,SearchCatalogRuleId, RuleName, UserName, CreatedDate, StartDate, EndDate, IsPause '+
			+' , '+[dbo].[Fn_GetPagingRowId](@Order_BY, ' SearchCatalogRuleId ASC')+
			+' FROM Cte_SerchRuleDetail '+
		+')'+
		 +' SELECT CSRD.SearchCatalogRuleId, CSRD.RuleName, CSRD.UserName, CSRD.CreatedDate, StartDate, EndDate, IsPause, Count(*)Over() As CountId '+
		 +' FROM Cte_SerchRuleDetail_OrderBy CSRD 
		 '+[dbo].[Fn_GetPaginationWhereClause](@PageNo, @Rows)+'
		 '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+'
		 '+[dbo].[Fn_GetOrderByClause](@Order_BY, 'CSRD.SearchCatalogRuleId ASC')
		
		 print @SQL
		 INSERT INTO @TBL_SerchRuleDetail (SearchCatalogRuleId, RuleName, UserName, CreatedDate, StartDate, EndDate, IsPause, CountId)
		 EXEC (@SQL)

		 SELECT SearchCatalogRuleId, RuleName, UserName, CreatedDate, StartDate, EndDate,IsPause, 
		        CASE WHEN IsPause = 1 THEN 'Yes' ELSE 'No' END AS Paused, 
				CountId
		 FROM @TBL_SerchRuleDetail

		 SET @RowsCount = ISNULL((SELECT top 1 CountId FROM @TBL_SerchRuleDetail), 0);
	END TRY
         BEGIN CATCH
		
		DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetSearchRuleDetails @WhereClause = '+CAST(@WhereClause AS VARCHAR(max))+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetSearchRuleDetails',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
            
      END CATCH;
END
GO

if exists(select * from sys.procedures where name = 'Znode_InsertUpdateGlobalEntityAttributeValue')
	drop proc Znode_InsertUpdateGlobalEntityAttributeValue
go
CREATE PROCEDURE [dbo].[Znode_InsertUpdateGlobalEntityAttributeValue]
(   @GlobalEntityValueXml NVARCHAR(max),
    @GlobalEntityValueId int,
	@EntityName varchar(200),
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
                    SELECT '  '+ DefaultValueXML  FROM ZnodePimAttributeDefaultXML AA 
				 INNER JOIN @PimDefaultValueLocale GH ON (GH.PimAttributeDefaultXMLId = AA.PimAttributeDefaultXMLId)
				 INNER JOIN ZnodePimProductAttributeDefaultValue ZPADV ON ( ZPADV.PimAttributeDefaultValueId = AA.PimAttributeDefaultValueId )
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

  --select *  delete  from ZnodePublishedXML
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

--select * from ZnodePublishCatalogLog where PublishCatalogLogId in (1702,1701)
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
GO

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

--exec [Znode_InsertUpdatePimCatalogProductDetail] @PublishCatalogId=10,@LocaleId=@LocaleId,@UserId=2
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
GO

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>PromotionId</name>      <headertext>Checkbox</headertext>      <width>30</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>y</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>PromoCode</name>      <headertext>Promotion Code</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>Name</name>      <headertext>Promotion Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>/Promotion/Edit</islinkactionurl>      <islinkparamfield>promotionId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Discount</name>      <headertext>Discount</headertext>      <width>40</width>      <datatype>Decimal</datatype>      <columntype>Decimal</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PromotionTypeName</name>      <headertext>Discount Type</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>StoreName</name>      <headertext>Store Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>QuantityMinimum</name>      <headertext>Minimum Quantity</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>OrderMinimum</name>      <headertext>Minimum Order</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>DisplayOrder</name>      <headertext>Display Order</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>StartDate</name>      <headertext>Start Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>11</id>      <name>EndDate</name>      <headertext>End Date</headertext>      <width>50</width>      <datatype>Date</datatype>      <columntype>DateTime</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>12</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>Edit|Delete|View</format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>shippingId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Edit|Delete|View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>/Promotion/Edit|/Promotion/Delete</manageactionurl>      <manageparamfield>promotionId|promotionId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodePromotion'
go
if exists(select * from sys.procedures where name = 'Znode_GetCatalogList')
	drop proc Znode_GetCatalogList
go
CREATE PROCEDURE [dbo].[Znode_GetCatalogList]
(
	@WhereClause NVARCHAR(MAX),
    @Rows        INT           = 100,
    @PageNo      INT           = 1,
    @Order_BY    VARCHAR(100)  = '',
    @RowsCount   INT OUT
)
AS 
/*
	 Summary :- This Procedure is used to get the publish status of the catalog 
	 Unit Testig 
	 EXEC  Znode_GetCatalogList '',100,1,'',0
	  EXEC  Znode_GetCatalogList null,100,1,'',0
*/
   BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 

		 DECLARE @SQL  NVARCHAR(max) 
		 DECLARE @TBL_CatalogId TABLE (PimCatalogId int, PublishCatalogLogId int,CatalogName VARCHAR(max),PublishStatus VARCHAR(300),RowId INT ,CountId INT,PublishCreatedDate DATETIME ,PublishModifiedDate DATETIME,PublishCategoryCount INT ,PublishProductCount INT, IsActive BIT)
	 
		 SET @SQL = '


		DECLARE @TBL_PublishProductId TABLE (PublishProductId int,PublishCatalogId int )
		INSERT INTO @TBL_PublishProductId
		SELECT COUNT( DISTINCT PublishProductId ),PublishCatalogId
		FROM ZnodePublishCategoryProduct a
		WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where a.PublishCatalogId = b.PublishCatalogId)
		AND a.PublishCategoryId  <> 0 and a.PublishCategoryId is not null
		GROUP BY PublishCatalogId 

		DECLARE @TBL_PublishCategoryId TABLE (PublishCategoryId int,PublishCatalogId int )
		INSERT INTO @TBL_PublishCategoryId
		SELECT COUNT(DISTINCT PimCategoryId ),PublishCatalogId
		FROM ZnodePublishCategory ZPC
		WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where ZPC.PublishCatalogId = b.PublishCatalogId)
		GROUP BY PublishCatalogId


		--SELECT COUNT(DISTINCT PublishCategoryId ),PublishCatalogId
		--FROM ZnodePublishCategoryProduct ZPC
		--WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where ZPC.PublishCatalogId = b.PublishCatalogId)
		--AND ZPC.PublishCategoryId  <> 0 and ZPC.PublishCategoryId is not null
		--GROUP BY PublishCatalogId

		;With Cte_MaxPublish AS 
		(
			 SELECT max(PublishCatalogLogId) PublishCatalogLogId,PimCatalogId
			 FROM ZnodePublishCatalogLog ZPCL   
			 GROUP BY PimCatalogId
		)
		,Cte_CatalogLog AS (
		SELECT ZPC.CatalogName CatalogName, PublishCatalogLogId PublishCatalogLogId,  TYU.DisplayName   PublishStatus ,ZPC.PimCatalogId,ZPCL.CreatedDate AS PublishCreatedDate,ZPCL.ModifiedDate AS PublishModifiedDate,
		
		ISNULL(ZPCL.PublishCategoryId,0) 
	 
		PublishCategoryCount,ISNULL(a.PublishProductId,0) 
		PublishProductCount,ZPC.IsActive
		FROM ZnodePimCatalog ZPC 
		LEFT JOIN ZnodePublishCatalogLog ZPCL  ON ( EXISTS (SELECT TOP 1 1 FROM Cte_MaxPublish CTE 											
		WHERE CTE.PimCatalogId = ZPC.PimCatalogId AND CTE.PublishCatalogLogId =  ZPCL.PublishCatalogLogId) )	
		LEFT JOIN ZnodePublishState TYU ON (TYU.PublishStateId = ZPCL.PublishStateId )
		LEFT JOIN  @TBL_PublishProductId a on (zpcl.PublishCatalogId = a.PublishCatalogId)
		LEFT JOIN  @TBL_PublishCategoryId PC ON (PC.PublishCatalogId = zpcl.PublishCatalogId))

	     ,Cte_PublishStatus 
		 AS (
		 SELECT PimCatalogId, PublishCatalogLogId, CatalogName, PublishStatus,PublishCreatedDate,PublishModifiedDate,PublishCategoryCount,PublishProductCount,IsActive,
		 '+[dbo].[Fn_GetPagingRowId](@Order_BY,'PublishCatalogLogId DESC')+' , Count(*)Over() CountId FROM Cte_CatalogLog
         WHERE 1=1 '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+' )
	 
		 SELECT PimCatalogId, PublishCatalogLogId,CatalogName,PublishStatus,RowId,CountId,PublishCreatedDate,PublishModifiedDate,PublishCategoryCount,PublishProductCount,IsActive
		 FROM Cte_PublishStatus 
		 '+[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)+' '
	

	     PRINT @sql 
		 INSERT INTO @TBL_CatalogId 
		 EXEC (@SQL)

		 SELECT  PimCatalogId,PublishCatalogLogId,CatalogName,PublishStatus,PublishCreatedDate,PublishModifiedDate,PublishCategoryCount,PublishProductCount,IsActive
		 FROM @TBL_CatalogId

		 SET @RowsCount = ISNULL((SELECT TOP 1 COUNTID FROM @TBL_CatalogId),0)
	 

	 
		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), 
			@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetCatalogList @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
			VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znode_GetCatalogList',
					@ErrorInProcedure = 'Znode_GetCatalogList',
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END
GO

if exists(select * from sys.procedures where name = 'Znode_GetPublishCategory')
	drop proc Znode_GetPublishCategory
go

CREATE PROCEDURE [dbo].[Znode_GetPublishCategory]
(   @PublishCatalogId INT,
    @UserId           INT,
    @VersionId        INT,
    @Status           BIT = 0 OUT,
    @IsDebug          BIT = 0,
	@LocaleId         TransferID READONLY)
AS 
/*
       Summary:Publish category with their respective products and details 
	            The result is fetched in xml form   
       Unit Testing   
       Begin transaction 
       SELECT * FROM ZnodePIMAttribute 
	   SELECT * FROM ZnodePublishCatalog 
	   SELECT * FROM ZnodePublishCategory WHERE publishCAtegoryID = 167 


       EXEC [Znode_GetPublishCategory] @PublishCatalogId = 3,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 
     


       Rollback Transaction 
	*/
     BEGIN
         BEGIN TRAN GetPublishCategory;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @LocaleIdIn INT= 0, @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @Counter INT= 1, @MaxId INT= 0, @CategoryIdCount INT;
             DECLARE @IsActive BIT= [dbo].[Fn_GetIsActiveTrue]();
             DECLARE @AttributeIds VARCHAR(MAX)= '', @PimCategoryIds VARCHAR(MAX)= '', @DeletedPublishCategoryIds VARCHAR(MAX)= '', @DeletedPublishProductIds VARCHAR(MAX);
             --get the pim catalog id 
			 DECLARE @PimCatalogId INT=(SELECT PimCatalogId FROM ZnodePublishcatalog WHERE PublishCatalogId = @PublishCatalogId); 

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
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder   INT
             );
             DECLARE @TBL_AttributeValue TABLE
             (PimCategoryAttributeValueId INT,
              PimCategoryId               INT,
              CategoryValue               NVARCHAR(MAX),
              AttributeCode               VARCHAR(300),
              PimAttributeId              INT
             );
             DECLARE @TBL_LocaleIds TABLE
             (RowId     INT IDENTITY(1, 1),
              LocaleId  INT,
              IsDefault BIT
             );
             DECLARE @TBL_PimCategoryIds TABLE
             (PimCategoryId       INT,
              PimParentCategoryId INT,
              DisplayOrder        INT,
              ActivationDate      DATETIME,
              ExpirationDate      DATETIME,
              CategoryName        NVARCHAR(MAX),
              ProfileId           VARCHAR(MAX),
              IsActive            BIT,
			  PimCategoryHierarchyId INT,
			  ParentPimCategoryHierarchyId INT ,
			   CategoryCode  NVARCHAR(MAX)             );


             DECLARE @TBL_PublishPimCategoryIds TABLE
             (PublishCategoryId       INT,
              PimCategoryId           INT,
              PublishProductId        varchar(max),
              PublishParentCategoryId INT ,
			  PimCategoryHierarchyId INT ,parentPimCategoryHierarchyId INT,
			  RowIndex INT
             );
             DECLARE @TBL_DeletedPublishCategoryIds TABLE
             (PublishCategoryId INT,
              PublishProductId  INT
             );
             DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
              CategoryXml       XML,
              LocaleId          INT
             );
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
             SELECT LocaleId,IsDefault FROM ZnodeLocale MT WHERE IsActive = @IsActive
			  AND (EXISTS (SELECT TOP 1 1  FROM @LocaleId RT WHERE RT.Id = MT.LocaleId )
			 OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleId ));

			 if object_id('tempdb..#CategoryData')is not null
				drop table #CategoryData

			 ------------for CategoryCode update
			SELECT ZPCAL.CategoryValue as CategoryCode,MAX(ZPC.PublishCategoryId) as PublishCategoryId ,ZPCA.PimCategoryId, ZPoC.PortalId
			INTO #CategoryData
			FROM ZnodePimCategoryAttributeValue ZPCA
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAL on ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCA.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePublishCategory ZPC on ZPCA.PimCategoryId = ZPC.PimCategoryId
			INNER JOIN ZnodePortalCatalog ZPoC on ZPC.PublishCatalogId = ZPoC.PublishCatalogId
			where ZPA.AttributeCode = 'CategoryCode' AND ZPC.PublishCatalogId = @PublishCatalogId
			AND EXISTS(SELECT * FROM ZnodeCMSWidgetCategory ZCWC WHERE ZPC.PublishCategoryId = ZCWC.PublishCategoryId )
			group by ZPCAL.CategoryValue, ZPCA.PimCategoryId, ZPoC.PortalId

			UPDATE ZCWC SET ZCWC.CategoryCode = CD.CategoryCode
			from ZnodeCMSWidgetCategory ZCWC
			INNER JOIN #CategoryData CD ON ZCWC.PublishCategoryId = CD.PublishCategoryId and ZCWC.CMSMappingId = CD.PortalId
			where ZCWC.TypeOFMapping = 'PortalMapping'
			----------

             INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
             SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
			 FROM ZnodePimCategoryHierarchy AS ZPCH 
			 LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
			 WHERE ZPCH.PimCatalogId = @PimCatalogId; 
             -- AND IsActive = @IsActive ; -- As discussed with @anup active flag maintain on demo site 23/12/2016
			 --	SELECT * FROM @TBL_PimCategoryIds
			 -- here is find the deleted publish category id on basis of publish catalog
             INSERT INTO @TBL_DeletedPublishCategoryIds(PublishCategoryId,PublishProductId)
             SELECT ZPC.PublishCategoryId,ZPCP.PublishProductId 
			 FROM ZnodePublishCategoryProduct ZPCP
             INNER JOIN ZnodePublishCategory AS ZPC ON(ZPCP.PublishCategoryId = ZPC.PublishCategoryId AND ZPCP.PublishCatalogId = ZPC.PublishCatalogId)                                                  
             INNER JOIN ZnodePublishProduct ZPP ON(zpp.PublishProductId = zpcp.PublishProductId AND zpp.PublishCatalogId = zpcp.PublishCatalogId)
             INNER JOIN ZnodePublishCatalog ZPCC ON(ZPCC.PublishCatalogId = ZPCP.PublishCatalogId)
             WHERE ZPC.PublishCatalogId = @PublishCataLogId 
			 AND NOT EXISTS(SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy AS TBPC WHERE TBPC.PimCategoryId = ZPC.PimCategoryId AND TBPC.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId
			 AND TBPC.PimCatalogId = ZPCC.PimCatalogId);

			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishCategoryIds = ISNULL(SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_DeletedPublishCategoryIds AS ZPC
                                              GROUP BY ZPC.PublishCategoryId FOR XML PATH('') ), 2, 4000), '');
			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishProductIds = '';
			 -- Delete the publish category id 
	
	        --   SELECT * FROM @TBL_DeletedPublishCategoryIds 

             EXEC Znode_DeletePublishCatalog @PublishCatalogIds = @PublishCatalogId,@PublishCategoryIds = @DeletedPublishCategoryIds,@PublishProductIds = @DeletedPublishProductIds; 
			
             MERGE INTO ZnodePublishCategory TARGET USING  @TBL_PimCategoryIds SOURCE ON
			 (
			 TARGET.PimCategoryId = SOURCE.PimCategoryId 
			 AND TARGET.PublishCatalogId = @PublishCataLogId 
			 AND TARGET.PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId
			 )
			 WHEN MATCHED THEN UPDATE SET TARGET.PimParentCategoryId = SOURCE.PimParentCategoryId,TARGET.CreatedBy = @UserId,TARGET.CreatedDate = @GetDate,
             TARGET.ModifiedBy = @UserId,TARGET.ModifiedDate = @GetDate,PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId,ParentPimCategoryHierarchyId=SOURCE.ParentPimCategoryHierarchyId
             WHEN NOT MATCHED THEN INSERT(PimCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PimCategoryHierarchyId,ParentPimCategoryHierarchyId) 
			 VALUES(SOURCE.PimCategoryId,@PublishCatalogId,@UserId,@GetDate,@UserId,@GetDate,SOURCE.PimCategoryHierarchyId,SOURCE.ParentPimCategoryHierarchyId)
             OUTPUT INSERTED.PublishCategoryId,INSERTED.PimCategoryId,INSERTED.PimCategoryHierarchyId,INSERTED.parentPimCategoryHierarchyId INTO @TBL_PublishPimCategoryIds(PublishCategoryId,PimCategoryId,PimCategoryHierarchyId,parentPimCategoryHierarchyId);
			
    --         UPDATE TBPC SET PublishParentCategoryId = TBPCS.PublishCategoryId 
			 --FROM @TBL_PublishPimCategoryIds TBPC
    --         INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId)
    --         INNER JOIN @TBL_PublishPimCategoryIds TBPCS ON(TBC.PimCategoryHierarchyId = TBPCS.parentPimCategoryHierarchyId  ) 
			 --WHERE TBC.parentPimCategoryHierarchyId IS NOT NULL;
           
		     -- here update the publish parent category id
             UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] 
			 FROM ZnodePublishCategory ZPC
             INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL
			 AND TBPC.PublishCatalogId =@PublishCatalogId
			 ;
			 UPDATE a
			 SET  a.PublishParentCategoryId = b.PublishCategoryId
			FROM ZnodePublishCategory a 
			INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
			WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
			AND a.PublishCatalogId =@PublishCatalogId
			AND b.PublishCatalogId =@PublishCatalogId

			UPDATE a set a.PublishParentCategoryId = NULL
			FROM ZnodePublishCategory a 
			WHERE a.parentpimCategoryHierarchyId IS NULL AND PimParentCategoryId IS NULL
			AND a.PublishCatalogId = @PublishCatalogId AND a.PublishParentCategoryId IS NOT NULL

			 --UPDATE ZPC SET [PimParentCategoryId] = TBPC.[PimCategoryId] 
			 --FROM ZnodePublishCategory ZPC
    --         INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 --WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 --AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL ;

			 -- product are published here 
            --  EXEC Znode_GetPublishProducts @PublishCatalogId,0,@UserId,1,0,0;

             SET @MaxId =(SELECT MAX(RowId)FROM @TBL_LocaleIds);
			 DECLARE @TransferID TRANSFERID 
			 INSERT INTO @TransferID 
			 SELECT DISTINCT  PimCategoryId
			 FROM @TBL_PublishPimCategoryIds 

             SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(50)) FROM @TBL_PublishPimCategoryIds FOR XML PATH('')), 2, 4000);
			 
             WHILE @Counter <= @MaxId -- Loop on Locale id 
                 BEGIN
                     SET @LocaleIdIn =(SELECT LocaleId FROM @TBL_LocaleIds WHERE RowId = @Counter);
                   
				     SET @AttributeIds = SUBSTRING((SELECT ','+CAST(ZPCAV.PimAttributeId AS VARCHAR(50)) FROM ZnodePimCategoryAttributeValue ZPCAV 
										 WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC WHERE TBPC.PimCategoryId = ZPCAV.PimCategoryId) GROUP BY ZPCAV.PimAttributeId FOR XML PATH('')), 2, 4000);
                
				     SET @CategoryIdCount =(SELECT COUNT(1) FROM @TBL_PimCategoryIds);

                     INSERT INTO @TBL_AttributeIds (PimAttributeId,ParentPimAttributeId,AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,
					 IsConfigurable,IsPersonalizable,DisplayOrder,HelpDescription,IsCategory,IsHidden,CreatedDate,ModifiedDate,AttributeName,AttributeTypeName)
                     EXEC [Znode_GetPimAttributesDetails] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeDefault (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)
                     EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
                     EXEC [dbo].[Znode_GetCategoryAttributeValueId] @TransferID,@AttributeIds,@LocaleIdIn;

					-- SELECT * FROM @TBL_AttributeValue WHERE PimCategoryId = 281


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
                     AS (SELECT TBA.PimCategoryId,TBA.PimAttributeId,[dbo].[FN_GetThumbnailMediaPathPublish](SUBSTRING((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
					    (SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH('')), 2, 4000)) CategoryValue
						FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId))
                         
					 UPDATE TBAV SET CategoryValue = CTCM.CategoryValue 
					 FROM @TBL_AttributeValue TBAV 
					 INNER JOIN Cte_productMedia CTCM ON(CTCM.PimCategoryId = TBAV.PimCategoryId
					 AND CTCM.PimAttributeId = TBAV.PimAttributeId);

                     WITH Cte_PublishProductIds
					 AS (SELECT TBPC.PublishcategoryId,SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50))
					  FROM ZnodePublishCategoryProduct ZPCP 
					  WHERE ZPCP.PublishCategoryId = TBPC.publishCategoryId
					  AND ZPCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId
                      AND ZPCP.PublishCatalogId = @PublishCatalogId FOR XML PATH('')), 2, 8000) PublishProductId ,PimCategoryHierarchyId
					  FROM @TBL_PublishPimCategoryIds TBPC)
                          
					 UPDATE TBPPC SET PublishProductId = CTPP.PublishProductId FROM @TBL_PublishPimCategoryIds TBPPC INNER JOIN Cte_PublishProductIds CTPP ON(TBPPC.PublishCategoryId = CTPP.PublishCategoryId 
					 AND TBPPC.PimCategoryHierarchyId = CTPP.PimCategoryHierarchyId);

                     WITH Cte_CategoryProfile
                     AS (SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
					 FROM ZnodeProfileCatalog ZPC 
					 INNER JOIN ZnodeProfileCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
                        AND ZPRCC.ProfileCatalogId = ZPC.ProfileCatalogId) 
						WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
                      
					   FROM ZnodePimCategoryHierarchy ZPCC 
					   WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
					   WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId = @PimCatalogId 
					   AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId))
                          
				     UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds FROM @TBL_PimCategoryIds TBPC 
					 LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
                     
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId));


					  UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )


					DECLARE @UpdateCategoryLog  TABLE (PublishCatalogLogId INT , LocaleId INT ,PublishCatalogId INT  )
					INSERT INTO @UpdateCategoryLog
					SELECT MAX(PublishCatalogLogId) PublishCatalogLogId , LocaleId , PublishCatalogId 
					FROM ZnodePublishCatalogLog a 
					WHERE a.PublishCatalogId =@PublishCatalogId
					AND  a.LocaleId = @LocaleIdIn 
					GROUP BY 	LocaleId,PublishCatalogId 



					 -- here update the publish category details 
                     ;WITH Cte_UpdateCategoryDetails
                     AS (
					 SELECT TBC.PimCategoryId,PublishCategoryId,CategoryName, TBPPC.PimCategoryHierarchyId,CategoryCode
					 FROM @TBL_PimCategoryIds TBC
                     INNER JOIN @TBL_PublishPimCategoryIds TBPPC ON(TBC.PimCategoryId = TBPPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPPC.PimCategoryHierarchyId)
					 )						
                     MERGE INTO ZnodePublishCategoryDetail TARGET USING Cte_UpdateCategoryDetails SOURCE ON(TARGET.PublishCategoryId = SOURCE.PublishCategoryId
					 AND TARGET.LocaleId = @LocaleIdIn)
                     WHEN MATCHED THEN UPDATE SET PublishCategoryId = SOURCE.PublishcategoryId,PublishCategoryName = SOURCE.CategoryName,LocaleId = @LocaleIdIn,ModifiedBy = @userId,ModifiedDate = @GetDate,CategoryCode=SOURCE.CategoryCode
                     WHEN NOT MATCHED THEN INSERT(PublishCategoryId,PublishCategoryName,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CategoryCode) VALUES
                     (SOURCE.PublishCategoryId,SOURCE.CategoryName,@LocaleIdIn,@userId,@GetDate,@userId,@GetDate,SOURCE.CategoryCode);

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

                     ;WITH Cte_CategoryXML
                     AS (SELECT PublishcategoryId,PimCategoryId,(SELECT ISNULL(TYU.PublishCatalogLogId,'') VersionId,TBPC.PublishCategoryId ZnodeCategoryId,@PublishCatalogId ZnodeCatalogId
																		,THR.PublishParentCategoryId TempZnodeParentCategoryIds,ZPC.CatalogName ,
																		 ISNULL(DisplayOrder, '0') DisplayOrder,@LocaleIdIn LocaleId,ActivationDate 
																		 ,ExpirationDate,TBC.IsActive,ISNULL(CategoryName, '') Name,ProfileId TempProfileIds,ISNULL(TBPC.PublishProductId, '') TempProductIds
																		 ,ISNULL(TBPC.RowIndex,1) CategoryIndex
																		 ,ISNULL(CategoryCode,'') CategoryCode
                        FROM @TBL_PublishPimCategoryIds TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId= @PublishCatalogId)
						LEFT JOIN @UpdateCategoryLog TYU ON (TYU.PublishCatalogId = @PublishCatalogId AND TYU.LocaleId = @LocaleIdIn)
						INNER JOIN ZnodePublishCAtegory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId= @PublishCatalogId )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) WHERE TBPC.PublishCategoryId = TBPCO.PublishCategoryId 
						FOR XML PATH('')) CategoryXml 
						FROM @TBL_PublishPimCategoryIds TBPCO),

                     Cte_CategoryAttributeXml
                     AS (SELECT CTCX.PublishCategoryId,'<CategoryEntity>'+ISNULL(CategoryXml, '')+ISNULL((SELECT(SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
                        ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,(SELECT ''+TBAV.CategoryValue FOR XML PATH('')) AttributeValues,TBA.AttributeTypeName FROM @TBL_AttributeValue TBAV
                        INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
                        WHERE CTCX.PimCategoryId = TBAV.PimCategoryId AND TBAO.PimAttributeId = TBA.PimAttributeId FOR XML PATH('AttributeEntity'), TYPE) FROM @TBL_AttributeIds TBAO
                        FOR XML PATH('Attributes')), '')+'</CategoryEntity>' CategoryXMl FROM Cte_CategoryXML CTCX)

                     INSERT INTO @TBL_CategoryXml(PublishCategoryId,CategoryXml,LocaleId)
                     SELECT PublishCategoryId,CategoryXml,@LocaleIdIn LocaleId FROM Cte_CategoryAttributeXml;
                   
				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;

    --         UPDATE ZnodePublishCatalogLog SET PublishCategoryId = SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_CategoryXml
			 --GROUP BY PublishCategoryId																				
    --         FOR XML PATH('')), 2, 4000), IsCategoryPublished = 1 WHERE PublishCatalogLogId = @VersionId;

			 --UPDATE ZnodePublishCatalogLog 
			 --SET PublishCategoryId = (SELECT COunt(DISTINCT PublishCategoryId ) FROM ZnodePublishCategory WHERE PublishCatalogId =@PublishCatalogId), IsCategoryPublished = 1 
			 --WHERE EXISTS (SELECT TOP 1 1 FROM @UpdateCategoryLog TY WHERE TY.PublishCatalogLogId =  ZnodePublishCatalogLog.PublishCatalogLogId ) ;


			 UPDATE ZnodePublishCatalogLog 
			 SET PublishCategoryId = (SELECT COunt(DISTINCT PublishCategoryId ) 
			 FROM @TBL_PublishPimCategoryIds WHERE PublishCatalogId =@PublishCatalogId), 
			 IsCategoryPublished = 1 
			 WHERE EXISTS (SELECT TOP 1 1 FROM @UpdateCategoryLog TY WHERE TY.PublishCatalogLogId =  ZnodePublishCatalogLog.PublishCatalogLogId ) ;
			 


             DELETE FROM ZnodePublishedXml WHERE PublishCataloglogId = @VersionId;
            
             INSERT INTO ZnodePublishedXml (PublishCatalogLogId,PublishedId,PublishedXML,IsCategoryXML,IsProductXML,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
             SELECT @VersionId PublishCataloglogId,PublishCategoryId,CategoryXml,1,0,LocaleId,@UserId,@GetDate,@UserId,@GetDate FROM @TBL_CategoryXml WHERE @VersionId <> 0;
             
			 SELECT CategoryXml  
			 FROM @TBL_CategoryXml 
			 

			 ------------for CategoryPublishId update
			SELECT ZPCAL.CategoryValue as CategoryCode,MAX(ZPC.PublishCategoryId) as PublishCategoryId ,ZPCA.PimCategoryId,ZPoC.PortalId
			INTO #CategoryData1
			FROM ZnodePimCategoryAttributeValue ZPCA
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAL on ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCA.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePublishCategory ZPC on ZPCA.PimCategoryId = ZPC.PimCategoryId
			INNER JOIN ZnodePortalCatalog ZPoC on ZPC.PublishCatalogId = ZPoC.PublishCatalogId
			where ZPA.AttributeCode = 'CategoryCode' AND ZPC.PublishCatalogId = @PublishCatalogId
			group by ZPCAL.CategoryValue, ZPCA.PimCategoryId, ZPoC.PortalId

			UPDATE ZCWC SET ZCWC.PublishCategoryId = CD.PublishCategoryId
			from ZnodeCMSWidgetCategory ZCWC
			INNER JOIN #CategoryData1 CD ON ZCWC.CategoryCode = CD.CategoryCode and ZCWC.CMSMappingId = CD.PortalId
			where ZCWC.TypeOFMapping = 'PortalMapping'
			----------------

			 --UPDATE ZnodePimCategory 
			 --SET IsCategoryPublish =1 
			 --WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_PimCategoryIds)

			 UPDATE ZnodePimCategory 
			 SET PublishStateId = Dbo.Fn_GetPublishStateIdForPreview()
			 WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_CategoryXml)

              
             COMMIT TRAN GetPublishCategory;
			 
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishCategory @PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0;
             ROLLBACK TRAN GetPublishCategory;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishCategory',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

if exists(select * from sys.procedures where name = 'Znode_GetPublishSingleCategory')
	drop proc Znode_GetPublishSingleCategory
go

CREATE PROCEDURE [dbo].[Znode_GetPublishSingleCategory]
(   @PimCategoryId    INT, 
    @UserId           INT,
    @Status           int = 0 OUT,
	@IsDebug          BIT = 0
	,@LocaleIds		  TransferId READONLY,
	@PimCatalogId     INT = 0 )
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

       EXEC [Znode_GetPublishSingleCategory @PublishCatalogId = 5,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 
       Rollback Transaction 
	*/
     BEGIN
         BEGIN TRAN GetPublishCategory;
         BEGIN TRY
             SET NOCOUNT ON;
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

			 IF NOT EXISTS (Select TOP 1 1 from @TBL_PublishCatalogId) OR NOT EXISTS (select TOP 1 1  from ZnodePimCatalogCategory where PimCategoryId = @PimCategoryId  )
			 Begin
				SET @Status = 1  -- Category not associated or catalog not publish
				ROLLBACK TRAN GetPublishCategory;
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
             DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
              CategoryXml       XML,
              LocaleId          INT
			 
             );
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
            SELECT LocaleId,IsDefault FROM ZnodeLocale MT WHERE IsActive = @IsActive
			AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
			OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) ;

             INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId,
			 PublishCatalogId,PimCatalogId,VersionId)
			 --select @PimCategoryId, NULL , NULL , NULL , NULL ,NULL , NULL ,NULL 
			 SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId,
			 PublishCatalogId,PCI.PimCatalogId,VersionId
			 FROM ZnodePimCategoryHierarchy AS ZPCH 
			 LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
			 Inner join @TBL_PublishCatalogId PCI on ZPCH.PimCatalogId = PCI.PimCatalogId 
			 WHERE ZPCH.PimCategoryId = @PimCategoryId ; 

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
			     	    
			 -- here update the publish parent category id
            UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] 
			FROM ZnodePublishCategory ZPC
            INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			WHERE ZPC.PublishCatalogId = TBPC.PublishCatalogId 
			AND TBPC.PublishCatalogId  in (Select PublishCatalogId from @TBL_PublishCatalogId)
			AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL AND 
			ZPC.PimCategoryId = @PimCategoryId  ;

			UPDATE a
			SET  a.PublishParentCategoryId = b.PublishCategoryId
			FROM ZnodePublishCategory a 
			INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
			WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
			AND a.PublishCatalogId = b.PublishCatalogId AND b.PublishCatalogId in (Select PublishCatalogId from @TBL_PublishCatalogId)
			AND a.PimCategoryId = @PimCategoryId 
			 --UPDATE ZPC SET [PimParentCategoryId] = TBPC.[PimCategoryId] 
			 --FROM ZnodePublishCategory ZPC
			 --INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 --WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 --AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL ;

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

					-- SELECT * FROM @TBL_AttributeValue WHERE PimCategoryId = 281

					--select * from @TBL_AttributeValue



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
                     AS (SELECT TBA.PimCategoryId,TBA.PimAttributeId,[dbo].[FN_GetThumbnailMediaPathPublish](SUBSTRING((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
					    (SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH('')), 2, 4000)) CategoryValue
						FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId))
                         
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
                     AS (SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
					 FROM ZnodeProfileCatalog ZPC 
					 INNER JOIN ZnodeProfileCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
                        AND ZPRCC.ProfileCatalogId = ZPC.ProfileCatalogId) 
						WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
                      
					   FROM ZnodePimCategoryHierarchy ZPCC 
					   WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
					   WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId in (Select PimCatalogId from @TBL_PublishCatalogId)
					   AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId))
                          
				     UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds FROM @TBL_PimCategoryIds TBPC 
					 LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
                     
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId))


					 UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )
					 
					 --select * from @TBL_PimCategoryIds

					 --select * from @TBL_AttributeValue
					-- SELECT * FROM @TBL_AttributeValue WHERE pimCategoryId = 369


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

                     ;WITH Cte_CategoryXML
                     AS (SELECT PublishcategoryId,PimCategoryId,(SELECT TY.PublishCatalogLogId,TBPC.PublishCategoryId ZnodeCategoryId,TBC.PublishCatalogId ZnodeCatalogId
																		,THR.PublishParentCategoryId TempZnodeParentCategoryIds,ZPC.CatalogName ,
																		 ISNULL(DisplayOrder, '0') DisplayOrder,@LocaleId LocaleId,ActivationDate 
																		 ,ExpirationDate,TBC.IsActive,ISNULL(CategoryName, '') Name,ProfileId TempProfileIds,ISNULL(PublishProductId, '') TempProductIds,ISNULL(CategoryCode,'') as CategoryCode
																		 ,ISNULL(TBPC.RowIndex,1) CategoryIndex
                        FROM @TBL_PublishPimCategoryIds TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId in  (Select PublishCatalogId from @TBL_PublishCatalogId))
						INNER JOIN ZnodePublishCAtegory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId in  (Select PublishCatalogId from @TBL_PublishCatalogId) )
						LEFT JOIN @UpdateCategoryLog TY ON ( TY.PublishCatalogId IN (Select PublishCatalogId from @TBL_PublishCatalogId) AND TY.localeId = @LocaleId  )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) WHERE TBPC.PublishCategoryId = TBPCO.PublishCategoryId 
						FOR XML PATH('')) CategoryXml 
						FROM @TBL_PublishPimCategoryIds TBPCO),


                     Cte_CategoryAttributeXml
                     AS (SELECT CTCX.PublishCategoryId,'<CategoryEntity>'+ISNULL(CategoryXml, '')+
					  ISNULL((SELECT(SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
                        ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,TBAV.CategoryValue AttributeValues,TBA.AttributeTypeName FROM @TBL_AttributeValue TBAV
                        INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
                        WHERE CTCX.PimCategoryId = TBAV.PimCategoryId AND TBAO.PimAttributeId = TBA.PimAttributeId FOR XML PATH('AttributeEntity'), TYPE) FROM @TBL_AttributeIds TBAO
                        FOR XML PATH('Attributes')), '')+'</CategoryEntity>' CategoryXMl FROM Cte_CategoryXML CTCX)

						
                     INSERT INTO @TBL_CategoryXml(PublishCategoryId,CategoryXml,LocaleId)
                     SELECT PublishCategoryId,CategoryXml,@LocaleId LocaleId FROM Cte_CategoryAttributeXml;

                  
				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;
	
			Select PublishCategoryId ,VersionId	, PimCatalogId	, LocaleId,PublishCatalogId
			into #OutPublish from @TBL_PublishCatalogId CLI CROSS JOIN @TBL_CategoryXml  
			--group by PimCatalogId,VersionId,PublishCategoryId

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

				if Exists (select count(1) from @TBL_PublishPimCategoryIds)
		UPDATE ZnodePublishCatalogLog 
		SET PublishCategoryId = (select COUNT(DISTINCT a.PimCategoryId )
		from ZnodePimCatalogCategory a
		inner join ZnodePimCategoryHierarchy b on (a.PimCategoryId = b.PimCategoryId)
		INNER JOIN ZnodePublishCategoryProduct c ON (b.PimCategoryHierarchyId = c.PimCategoryHierarchyId)
		WHERE	a.PimCatalogId IN  
		(SELECT DISTINCT PimCatalogId FROM @TBL_PublishCatalogId PLL 
		WHERE PLL.VersionId = @VersionId 
		)
		)
		,ModifiedDate = @GetDate
		WHERE ZnodePublishCatalogLog.PublishCatalogLogId = @VersionId

				SET @Counter  = @Counter  + 1  
			END
           	Select distinct 
			SUBSTRING(( SELECT Distinct ',' + CAST(PublishCategoryId AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) PublishCategoryId,
			SUBSTRING(( SELECT Distinct ',' + CAST(VersionId	 AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) VersionId,	
			SUBSTRING(( SELECT Distinct ',' + CAST(PublishCatalogId	 AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) PimCatalogId,
			SUBSTRING(( SELECT Distinct ',' + CAST(LocaleId AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) LocaleId
			from #OutPublish
			--group by PimCatalogId,VersionId,PublishCategoryId

			--Select PublishCategoryId ,VersionId	, PimCatalogId, LocaleId  from #OutPublish 

			Select CategoryXml from @TBL_CategoryXml 

			SELECT CategoryCode FROM @TBL_PimCategoryIds
			GROUP BY CategoryCode

			UPDATE ZnodePimCategory	SET IsCategoryPublish = 1 WHERE PimCategoryId = @PimCategoryId 

			Commit TRAN GetPublishCategory;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishCategory @PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0 -- Publish Falies 
             ROLLBACK TRAN GetPublishCategory;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishCategory',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO

if exists(select * from sys.procedures where name = 'Znode_GetPublishStatus')
	drop proc Znode_GetPublishStatus
go

CREATE PROCEDURE [dbo].[Znode_GetPublishStatus]
(
	@WhereClause NVARCHAR(MAX),
    @Rows        INT           = 100,
    @PageNo      INT           = 1,
    @Order_BY    VARCHAR(100)  = '',
    @RowsCount   INT OUT
)
AS 
/*
	 Summary :- This Procedure is used to get the publish status of the catalog 
	 Unit Testig 
	 EXEC  Znode_GetPublishStatus_TP '',10,1,'',0
*/
   BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 

		 DECLARE @SQL  NVARCHAR(max) 
		 DECLARE @TBL_CatalogId TABLE (PublishCatalogLogId INT,PublishStatus VARCHAR(300),UserName NVARCHAR(512),PublishCategoryCount INT ,PublishProductCount INT ,CreatedDate DATETIME ,ModifiedDate DATETIME ,RowId INT ,CountId INT)
	 
		 SET @SQL = '

		  DECLARE @TBL_PublishProductId TABLE (PublishProductId int,PublishCatalogId int )
		INSERT INTO @TBL_PublishProductId
		SELECT COUNT( DISTINCT PublishProductId ),PublishCatalogId
		FROM ZnodePublishCategoryProduct a
		WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where a.PublishCatalogId = b.PublishCatalogId)
		AND a.PublishCategoryId  <> 0 and a.PublishCategoryId is not null
		GROUP BY PublishCatalogId 


		 ;With Cte_CatalogLog AS
		 (
		 SELECT PublishCatalogLogId,CASE WHEN IsCatalogPublished IS NULL THEN ''Processing'' WHEN IsCatalogPublished = 0 THEN ''Publish Failed''
         WHEN IsCatalogPublished = 1 THEN  ''Published Successfully'' END   PublishStatus ,APZU.UserName ,ISNULL(ZPCL.PublishCategoryId,0) PublishCategoryCount,
		 ISNULL(a.PublishProductId,0) PublishProductCount,ZPCL.CreatedDate,ZPCL.ModifiedDate ,PimCatalogId
	     FROM ZnodePublishCatalogLog  ZPCL 
		 LEFT JOIN ZnodeUser ZU ON (ZU.UserId = ZPCL.CreatedBy )
	     LEFT JOIN AspNetUsers APU ON (APU.Id = ZU.AspNetUserId) 
		 LEFT JOIN AspNetZnodeUser APZU ON (APZU.AspNetZnodeUserId = APU.UserName)
		 LEFT JOIN  @TBL_PublishProductId a on (zpcl.PublishCatalogId = a.PublishCatalogId)
		 )
	 
	     ,Cte_PublishStatus 
		 AS (SELECT PublishCatalogLogId, PublishStatus ,UserName , PublishCategoryCount, PublishProductCount,CreatedDate,ModifiedDate ,
		 '+[dbo].[Fn_GetPagingRowId](@Order_BY,'PublishCatalogLogId DESC')+' , Count(*)Over() CountId FROM Cte_CatalogLog
         WHERE 1=1 '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+' )
	 
		 SELECT PublishCatalogLogId,PublishStatus,UserName,PublishCategoryCount,PublishProductCount,CreatedDate,ModifiedDate,RowId,CountId 
		 FROM Cte_PublishStatus 
		 '+[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)+' '
	
		 PRINT @SQL
		 INSERT INTO @TBL_CatalogId
		 EXEC (@SQL)

		 SELECT  PublishCatalogLogId,PublishStatus,UserName,PublishCategoryCount,PublishProductCount,CreatedDate,ModifiedDate
		 FROM @TBL_CatalogId
		 ORDER BY PublishCatalogLogId DESC

		 SET @RowsCount = ISNULL((SELECT TOP 1 COUNTID FROM @TBL_CatalogId),0)
	 
		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishStatus @WhereClause = '+@WhereClause+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znode_GetPublishStatus',
					@ErrorInProcedure = @Error_procedure,
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END
GO

if exists(select * from sys.procedures where name = 'Znode_GetSEODefaultSetting')
	drop proc Znode_GetSEODefaultSetting
go

CREATE PROCEDURE [dbo].[Znode_GetSEODefaultSetting]
( 
	@PortalId INT = 0,
	@SEOType Varchar(200) = '',
	@Id INT = 0
)
as 
Begin
	SET NOCOUNT ON;
	DECLARE @Title VARCHAR(MAX), @Description VARCHAR(MAX),@Keyword VARCHAR(MAX)
	DECLARE @SQL VARCHAR(MAX)
	 
	IF @SEOType = 'Product'
	BEGIN
			SELECT @Title = case when ProductTitle = '<NAME>' then 'ProductName' when ProductTitle = '<Product_Num>' then 'cast(PimProductId as varchar(10))'  when ProductTitle = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end,
				   @Description = case when ProductDescription = '<NAME>' then 'ProductName' when ProductDescription = '<Product_Num>' then 'cast(PimProductId as varchar(10))' when ProductDescription = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end,
				   @Keyword = case when ProductKeyword = '<NAME>' then 'ProductName' when ProductKeyword = '<Product_Num>' then 'cast(PimProductId as varchar(10))' when ProductKeyword = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT PimProductId, max(LongDescription) as LongDescription, max(SKU) as SKU, max(ShortDescription) as ShortDescription, max(ProductName) as ProductName,max(Brand) as Brand
			into #ProductDetail
			FROM  
			(
				select PimProductId,	AttributeValue,	AttributeCode
				from View_LoadManageProductInternal 
				where PimProductId = @Id and AttributeCode in ('LongDescription', 'SKU', 'ShortDescription','ProductName','ProductCode')
				union all
				select a.PimProductId, d.AttributeDefaultValueCode as AttributeValue , 'Brand' as AttributeCode
				from ZnodePimAttributeValue a
				inner join ZnodePimProductAttributeDefaultValue b on a.PimAttributeValueId = b.PimAttributeValueId
				inner join ZnodePimAttributeDefaultValue d on b.PimAttributeDefaultValueId = d.PimAttributeDefaultValueId
				inner join ZnodePimAttribute c on a.PimAttributeId = c.PimAttributeId
				where c.AttributeCode = 'Brand' and a.PimProductId = @Id
			) AS SourceTable  
			PIVOT  
			(  
			max(AttributeValue)  
			FOR AttributeCode IN (LongDescription, SKU, ShortDescription, ProductName,Brand)  
			) AS PivotTable
			group by PimProductId 

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ProductDetail'
				print @SQL
				exec (@SQL)
			end

		end
		IF @SEOType = 'Category'
		BEGIN
			
			SELECT @Title = case when CategoryTitle = '<NAME>' then 'CategoryName' when CategoryTitle = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryTitle = '<SKU>' then 'CategoryCode' end,
				   @Description = case when CategoryDescription = '<NAME>' then 'CategoryName' when CategoryDescription = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryDescription = '<SKU>' then 'CategoryCode' end,
				   @Keyword = case when CategoryKeyword = '<NAME>' then 'CategoryName' when CategoryKeyword = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryKeyword = '<SKU>' then 'CategoryCode' end
		    FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT ZPCAV.PimCategoryId, ZPCAVL.CategoryValue as CategoryCode,  ZPCAVL1.CategoryValue as CategoryName
			INTO #CategoryDetail
			FROM ZnodePimCategoryAttributeValue ZPCAV
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL ON ZPCAV.PimCategoryAttributeValueId = ZPCAVL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCAV.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePimCategoryAttributeValue ZPCAV1 ON ZPCAV.PimCategoryId = ZPCAV1.PimCategoryId
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL1 ON ZPCAV1.PimCategoryAttributeValueId = ZPCAVL1.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA1 ON ZPCAV1.PimAttributeId = ZPA1.PimAttributeId
			WHERE ZPA.AttributeCode = 'CategoryCode' AND ZPA1.AttributeCode = 'CategoryName'
			and ZPCAV.PimCategoryId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #CategoryDetail'
				
				exec (@SQL)
			end

		end

		IF @SEOType = 'Content_Page'
		BEGIN
			
			SELECT @Title = case when ContentTitle = '<Name>' then 'PageName' when ContentTitle = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentTitle = '<SKU>' then 'PageName' end,
					@Description = case when ContentDescription = '<Name>' then 'PageName' when ContentDescription = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentDescription = '<SKU>' then 'PageName' end,
					@Keyword = case when ContentKeyword = '<Name>' then 'PageName' when ContentKeyword = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentKeyword = '<SKU>' then 'PageName' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT CMSContentPagesId, PageName into #ContentPageDetail from ZnodeCMSContentPages where CMSContentPagesId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin

				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ContentPageDetail'

				exec (@SQL)
			end


		end

	

end
GO

if exists(select * from sys.procedures where name = 'Znode_GetSEODefaultSetting')
	drop proc Znode_GetSEODefaultSetting
go

CREATE PROCEDURE [dbo].[Znode_GetSEODefaultSetting]
( 
	@PortalId INT = 0,
	@SEOType Varchar(200) = '',
	@Id INT = 0
)
as 
Begin
	SET NOCOUNT ON;
	DECLARE @Title VARCHAR(MAX), @Description VARCHAR(MAX),@Keyword VARCHAR(MAX)
	DECLARE @SQL VARCHAR(MAX)
	 
	IF @SEOType = 'Product'
	BEGIN
			SELECT @Title = case when ProductTitle = '<NAME>' then 'ProductName' when ProductTitle = '<Product_Num>' then 'ProductCode'  when ProductTitle = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end,
				   @Description = case when ProductDescription = '<NAME>' then 'ProductName' when ProductDescription = '<Product_Num>' then 'ProductCode' when ProductDescription = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end,
				   @Keyword = case when ProductKeyword = '<NAME>' then 'ProductName' when ProductKeyword = '<Product_Num>' then 'ProductCode' when ProductKeyword = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT PimProductId, max(LongDescription) as LongDescription, max(SKU) as SKU, max(ShortDescription) as ShortDescription, 
			       max(ProductName) as ProductName,max(Brand) as Brand, max(ProductCode) as ProductCode
			into #ProductDetail
			FROM  
			(
				select PimProductId,	AttributeValue,	AttributeCode
				from View_LoadManageProductInternal 
				where PimProductId = @Id and AttributeCode in ('LongDescription', 'SKU', 'ShortDescription','ProductName','ProductCode')
				union all
				select a.PimProductId, d.AttributeDefaultValueCode as AttributeValue , 'Brand' as AttributeCode
				from ZnodePimAttributeValue a
				inner join ZnodePimProductAttributeDefaultValue b on a.PimAttributeValueId = b.PimAttributeValueId
				inner join ZnodePimAttributeDefaultValue d on b.PimAttributeDefaultValueId = d.PimAttributeDefaultValueId
				inner join ZnodePimAttribute c on a.PimAttributeId = c.PimAttributeId
				where c.AttributeCode = 'Brand' and a.PimProductId = @Id
			) AS SourceTable  
			PIVOT  
			(  
			max(AttributeValue)  
			FOR AttributeCode IN (LongDescription, SKU, ShortDescription, ProductName,Brand,ProductCode)  
			) AS PivotTable
			group by PimProductId 

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ProductDetail'
				print @SQL
				exec (@SQL)
			end

		end
		IF @SEOType = 'Category'
		BEGIN
			
			SELECT @Title = case when CategoryTitle = '<NAME>' then 'CategoryName' when CategoryTitle = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryTitle = '<SKU>' then 'CategoryCode' end,
				   @Description = case when CategoryDescription = '<NAME>' then 'CategoryName' when CategoryDescription = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryDescription = '<SKU>' then 'CategoryCode' end,
				   @Keyword = case when CategoryKeyword = '<NAME>' then 'CategoryName' when CategoryKeyword = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryKeyword = '<SKU>' then 'CategoryCode' end
		    FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT ZPCAV.PimCategoryId, ZPCAVL.CategoryValue as CategoryCode,  ZPCAVL1.CategoryValue as CategoryName
			INTO #CategoryDetail
			FROM ZnodePimCategoryAttributeValue ZPCAV
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL ON ZPCAV.PimCategoryAttributeValueId = ZPCAVL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCAV.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePimCategoryAttributeValue ZPCAV1 ON ZPCAV.PimCategoryId = ZPCAV1.PimCategoryId
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL1 ON ZPCAV1.PimCategoryAttributeValueId = ZPCAVL1.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA1 ON ZPCAV1.PimAttributeId = ZPA1.PimAttributeId
			WHERE ZPA.AttributeCode = 'CategoryCode' AND ZPA1.AttributeCode = 'CategoryName'
			and ZPCAV.PimCategoryId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #CategoryDetail'
				
				exec (@SQL)
			end

		end

		IF @SEOType = 'Content_Page'
		BEGIN
			
			SELECT @Title = case when ContentTitle = '<Name>' then 'PageName' when ContentTitle = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentTitle = '<SKU>' then 'PageName' end,
					@Description = case when ContentDescription = '<Name>' then 'PageName' when ContentDescription = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentDescription = '<SKU>' then 'PageName' end,
					@Keyword = case when ContentKeyword = '<Name>' then 'PageName' when ContentKeyword = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentKeyword = '<SKU>' then 'PageName' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT CMSContentPagesId, PageName into #ContentPageDetail from ZnodeCMSContentPages where CMSContentPagesId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin

				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ContentPageDetail'

				exec (@SQL)
			end


		end

	

end
GO

if exists(select * from sys.procedures where name = 'Znode_GetPublishStatus')
	drop proc Znode_GetPublishStatus
go


CREATE PROCEDURE [dbo].[Znode_GetPublishStatus]
(
	@WhereClause NVARCHAR(MAX),
    @Rows        INT           = 100,
    @PageNo      INT           = 1,
    @Order_BY    VARCHAR(100)  = '',
    @RowsCount   INT OUT
)
AS 
/*
	 Summary :- This Procedure is used to get the publish status of the catalog 
	 Unit Testig 
	 EXEC  Znode_GetPublishStatus_TP '',10,1,'',0
*/
   BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 

		 DECLARE @SQL  NVARCHAR(max) 
		 DECLARE @TBL_CatalogId TABLE (PublishCatalogLogId INT,PublishStatus VARCHAR(300),UserName NVARCHAR(512),PublishCategoryCount INT ,PublishProductCount INT ,CreatedDate DATETIME ,ModifiedDate DATETIME ,RowId INT ,CountId INT)
	 
		 SET @SQL = '

		  DECLARE @TBL_PublishProductId TABLE (PublishProductId int,PublishCatalogId int )
		INSERT INTO @TBL_PublishProductId
		SELECT COUNT( DISTINCT PublishProductId ),PublishCatalogId
		FROM ZnodePublishCategoryProduct a
		WHERE PublishCatalogId IN  (select PublishCatalogId from ZnodePublishCatalog b where a.PublishCatalogId = b.PublishCatalogId)
		AND a.PublishCategoryId  <> 0 and a.PublishCategoryId is not null
		GROUP BY PublishCatalogId 


		 ;With Cte_CatalogLog AS
		 (
		 SELECT PublishCatalogLogId,CASE WHEN IsCatalogPublished IS NULL THEN ''Processing'' WHEN IsCatalogPublished = 0 THEN ''Publish Failed''
         WHEN IsCatalogPublished = 1 THEN  ''Published Successfully'' END   PublishStatus ,APZU.UserName ,ISNULL(ZPCL.PublishCategoryId,0) PublishCategoryCount,
		 ISNULL(ZPCL.PublishProductId,0) PublishProductCount,ZPCL.CreatedDate,ZPCL.ModifiedDate ,PimCatalogId
	     FROM ZnodePublishCatalogLog  ZPCL 
		 LEFT JOIN ZnodeUser ZU ON (ZU.UserId = ZPCL.CreatedBy )
	     LEFT JOIN AspNetUsers APU ON (APU.Id = ZU.AspNetUserId) 
		 LEFT JOIN AspNetZnodeUser APZU ON (APZU.AspNetZnodeUserId = APU.UserName)
		 LEFT JOIN  @TBL_PublishProductId a on (zpcl.PublishCatalogId = a.PublishCatalogId)
		 )
	 
	     ,Cte_PublishStatus 
		 AS (SELECT PublishCatalogLogId, PublishStatus ,UserName , PublishCategoryCount, PublishProductCount,CreatedDate,ModifiedDate ,
		 '+[dbo].[Fn_GetPagingRowId](@Order_BY,'PublishCatalogLogId DESC')+' , Count(*)Over() CountId FROM Cte_CatalogLog
         WHERE 1=1 '+[dbo].[Fn_GetFilterWhereClause](@WhereClause)+' )
	 
		 SELECT PublishCatalogLogId,PublishStatus,UserName,PublishCategoryCount,PublishProductCount,CreatedDate,ModifiedDate,RowId,CountId 
		 FROM Cte_PublishStatus 
		 '+[dbo].[Fn_GetPaginationWhereClause](@PageNo,@Rows)+' '
	
		 PRINT @SQL
		 INSERT INTO @TBL_CatalogId
		 EXEC (@SQL)

		 SELECT  PublishCatalogLogId,PublishStatus,UserName,PublishCategoryCount,PublishProductCount,CreatedDate,ModifiedDate
		 FROM @TBL_CatalogId
		 ORDER BY PublishCatalogLogId DESC

		 SET @RowsCount = ISNULL((SELECT TOP 1 COUNTID FROM @TBL_CatalogId),0)
	 
		 END TRY 
		 BEGIN CATCH 
			DECLARE @Status BIT ;
			SET @Status = 0;
			DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishStatus @WhereClause = '+@WhereClause+',@Rows='+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_BY='+@Order_BY+',@RowsCount='+CAST(@RowsCount AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
			SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
			EXEC Znode_InsertProcedureErrorLog
					@ProcedureName = 'Znode_GetPublishStatus',
					@ErrorInProcedure = @Error_procedure,
					@ErrorMessage = @ErrorMessage,
					@ErrorLine = @ErrorLine,
					@ErrorCall = @ErrorCall;
		 END CATCH 
   END
GO

if exists(select * from sys.procedures where name = 'Znode_GetPublishCategoryProducts')
	drop proc Znode_GetPublishCategoryProducts
go


CREATE PROCEDURE [dbo].[Znode_GetPublishCategoryProducts]
( @pimCatalogId int = 0,@pimCategoryHierarchyId int = 0,@userId int,@versionId int= 0,@status int = 0 OUT,@isDebug bit = 0 ,@LocaleId TransferId READONLY , @PublishStateId INT = 0,   @ProductPublishStateId INT=NULL)  AS  /*
    Summary :	Publish Product on the basis of publish catalog and category
				Calling sp [Znode_InsertPublishProductIds] to retrive category and their child category with associated products 
				 
				1.	ZnodePublishedXml
				2.	ZnodePublishCategoryProduct
				3.	ZnodePublishProduct
				4.	ZnodePublishProductDetail

                Product details include all the type of products link, grouped, configure and bundel products (include addon) their associated products 
				collect their attributes and values into tables variables to process for publish.  
                
				Finally genrate XML for products with their attributes and inserted into ZnodePublishedXml Znode Admin process xml from sql server to mongodb
				one by one.
	
	Unit Testing
    ------------------------------------------------------------------------------------------------
	Declare @Status int 
	DECLARE @r transferid 
	INSERT INTO @r
	VALUES (1)
	,(24)
	EXEC [Znode_GetPublishCategoryProducts]  @PimCatalogId = 9
	, @PimCategoryHierarchyId = 48 
	, @UserId = 2 
	, @VersionId = 0
	, @IsDebug = 1
	, @Status  = @Status  out
	,@localeId = @r
	,@PublishStateId = 4
	Select @Status  

 */
	BEGIN   
		BEGIN TRY
			SET NOCOUNT ON;
			 DECLARE @IsCatalogPublishInProcess INT  = 0
			DECLARE @tBL_PublishIds table (PublishProductId int,PimProductId int,PublishCatalogId int)
			DECLARE @publishCatalogId int= isnull((SELECT TOP 1 PublishCatalogId FROM ZnodePublishCatalog ZPC WHERE ZPC.PimCatalogId = @pimCatalogId),0),@publishCataloglogId int= 0;
			DECLARE @tBL_CategoryCategoryHierarchyIds table (CategoryId int,ParentCategoryId int ,PimCategoryHierarchyId INT ,ParentPimCategoryHierarchyId INT  )
			DECLARE @pimProductId TransferId
			DECLARE @insertPublishProductIds table (PublishProductId int,PimProductId int,PublishCatalogId int )
			--DECLARE @TBL_CategoryXml TABLE ( CategoryXml XML);
				SELECT @versionId = max(PublishCataloglogId)
			FROM ZnodePublishCatalogLog 
			WHERE PublishCatalogId =@publishCatalogId

				 --IF EXISTS (SELECT TOP 1 1  FROM ZnodePublishCatalogLog a 
			  -- INNER JOIN ZnodePimCatalogCategory b ON (b.PimCatalogId =a.PimCatalogId )
			  -- WHERE b.PimCategoryHierarchyId = @PimCategoryHierarchyId
			  -- AND a.IsCatalogPublished IS NULL 
			  -- AND a.IsCategoryPublished IS NULL
			  -- ) 
			  -- BEGIN 
				 --SET   @IsCatalogPublishInProcess =1 
			  -- END 


			INSERT INTO @tBL_CategoryCategoryHierarchyIds(CategoryId,ParentCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId ) 
			SELECT DISTINCT PimCategoryId, Null,PimCategoryHierarchyId,NULL  FROM ( SELECT PimCategoryId,ParentPimCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId
			FROM DBO.[Fn_GetRecurciveCategoryIds_PimCategoryHierarchy](@pimCategoryHierarchyId,@pimCatalogId) 
			UNION SELECT PimCategoryId, Null,PimCategoryHierarchyId,NULL FROM ZnodePimCategoryHierarchy WHERE PimCategoryHierarchyId = @pimCategoryHierarchyId 
			UNION SELECT PimCategoryId, Null,PimCategoryHierarchyId,NULL  FROM dbo.[Fn_GetRecurciveCategoryIds_PimCategoryHierarchyIdnew] (@pimCategoryHierarchyId,@pimCatalogId) ) Category

			

			
			IF NOT EXISTS (SELECT TOP 1 1 FROM ZnodePimCatalogCategory ty 
			WHERE EXISTS (SELECT TOP 1 1 FROM ( SELECT PimCategoryId,PimCategoryHierarchyId,ParentPimCategoryHierarchyId 
			FROM dbo.[Fn_GetRecurciveCategoryIds_ForChild](@pimCategoryHierarchyId,@pimCatalogId) UNION ALL SELECT NULL ,@pimCategoryHierarchyId,NULL  ) TN WHERE TN.PimCategoryHierarchyId = TY.PimCategoryHierarchyId  ) AND ty.PimProductId IS NOT NULL )
			BEGIN 
			  SET @IsCatalogPublishInProcess = 2 

			END 

			IF (isnull(@publishCatalogId,0) = 0 ) 
				BEGIN 
					SET @status = 1
					-- Catalog Not Published 
					RETURN 0;
				END
			
			IF @IsCatalogPublishInProcess =  0 
			BEGIN 
			

			-- Any other catalog was in process dont intitiate category publish	
			--If Exists ( SELECT TOP 1 1 FROM ZnodePublishcatalogLog  WHERE  IsCatalogPublished  IS NULL AND IsCategoryPublished IS NULL )
			--Begin
			--		SET @status = 2
			--		RETURN 0;
			--End

			
				EXEC [Znode_GetPublishCategoryGroup] @publishCatalogId = @PublishCatalogId,@VersionId = 0,@userId =2,@isDebug = 1,@PimCategoryHierarchyId = @PimCategoryHierarchyId,@localeId =@localeID,@PublishStateId=@PublishStateId
			
			BEGIN 
				INSERT INTO @insertPublishProductIds EXEC [Dbo].[Znode_InsertPublishProductIds] @publishCatalogId = @publishCatalogId,@userid = @userid,@pimProductId = @pimProductId,@pimCategoryHierarchyId = @pimCategoryHierarchyId
				INSERT INTO @pimProductId SELECT PimProductId FROM @insertPublishProductIds

				EXEC [Dbo].[Znode_GetPublishProductbulk] @publishCatalogId = @publishCatalogId,@versionId = @versionId,@pimProductId = @pimProductId,@userid = @userid,@pimCategoryHierarchyId = @pimCategoryHierarchyId,@pimCatalogId = @pimCatalogId,@localeIds = @localeId ,@publishstateId =@publishStateId 
				
				--UPDATE ZnodePimProduct 		SET IsProductPublish = 1 ,PublishStateId = @PublishStateId		
				--WHERE EXISTS (SELECT TOP 1 1 
				--	FROM ZnodePublishProduct ZPP
				--	WHERE ZPP.PimProductId = ZnodePimProduct.PimProductId 
				--		AND ZPP.PublishCatalogId = @publishCatalogId
				--	)

					

			END
			DECLARE @tBL_PublishCatalogId table(PublishCatalogId int,PublishProductId int,PublishCategoryId int,PimProductId int,VersionId int,LocaleId INT  );
			
			INSERT INTO @tBL_PublishCatalogId (PublishCatalogId,PublishProductId,PublishCategoryId,PimProductId,VersionId ,Localeid)  
			SELECT DISTINCT ZPC.PublishCatalogId,ZPX.PublishProductId,ZPX.PublishCategoryId,ZPP.PimProductId,Max(TH.PublishCatalogLogId),TH.Localeid 
			FROM ZnodePublishCategory ZPC 
			INNER JOIN ZnodePublishCatalogLog TH ON (TH.PublishCatalogId = ZPC.PublishCatalogId)
			INNER JOIN @tBL_CategoryCategoryHierarchyIds CTC ON (ZPC.PimCategoryHierarchyId = CTC .PimCategoryHierarchyId )
			INNER JOIN ZnodePublishCategoryProduct ZPX  ON ZPC.PublishCategoryId = ZPX.PublishCategoryId AND ZPX.PublishCatalogId = ZPC.PublishCatalogId 
			INNER JOIN ZnodePublishProduct ZPP ON ZPP.PublishCatalogId = ZPC.PublishCatalogId AND ZPX.PublishProductId = ZPP.PublishProductId 
			WHERE ZPC.PublishCatalogId = @PublishCatalogId 
			AND  TH.PublishStateId = @PublishStateId
			AND EXISTS (SELECT TOP 1 1 FROM @LocaleId WHERE id = TH.LocaleId)
			GROUP BY ZPC.PublishCatalogId,ZPX.PublishProductId ,ZPX.PublishCategoryId,ZPP.PimProductId,TH.Localeid 
		
			INSERT INTO @tBL_PublishCatalogId (PublishCatalogId,PublishProductId,PublishCategoryId,PimProductId,VersionId,Localeid ) 
			SELECT IPP.PublishCatalogId,IPP.PublishProductId,0,IPP.PimProductId,max(PublishCatalogLogId) VersionId ,h.Localeid
			FROM @insertPublishProductIds IPP 
			LEFT JOIN ZnodePublishCatalogLog h ON (h.PublishCatalogId = IPP.PublishCatalogId )
			WHERE NOT EXISTS (SELECT TOP 1 1 FROM @tBL_PublishCatalogId PCI WHERE IPP.PublishProductId = PCI.PublishProductId)
			AND EXISTS (SELECT TOP 1 1 FROM @LocaleId WHERE id = h.LocaleId)
			AND h.PublishStateId = @PublishStateId
			GROUP BY IPP.PublishCatalogId,IPP.PublishProductId,IPP.PimProductId,Localeid
			
			UPDATE ZnodePublishCatalogLog 
			SET IsProductPublished = 1,
			    PublishProductId = (SELECT  COUNT(DISTINCT PublishProductId) FROM ZnodePublishCategoryProduct ZPP WHERE ZPP.PublishCatalogId = ZnodePublishCatalogLog.PublishCatalogId AND ZPP.PublishCategoryId IS NOT NULL)  
			,ModifiedBy=@userId, ModifiedDate=GETDATE()
			WHERE PublishCatalogLogId IN (SELECT VersionId FROM @tBL_PublishCatalogId)

			UPDATE ZnodePimProduct 
			SET IsProductPublish = 1 ,PublishStateId = ISNULL(@ProductPublishStateId,@PublishStateId),
			ModifiedBy=@userId, ModifiedDate=GETDATE()	
			WHERE EXISTS (SELECT TOP 1 1 
				FROM @tBL_PublishCatalogId ZPP
				WHERE ZPP.PimProductId = ZnodePimProduct.PimProductId
				)
		
				SELECT PublishCatalogId
					,PublishProductId
					,PublishCategoryId
					,VersionId,LocaleId
			FROM @tBL_PublishCatalogId
			END 
			 IF @IsCatalogPublishInProcess = 1 
				BEGIN 
				SELECT 1 Id , 'Single category publish request cannot be processed as catalog or category publish is in progress. Please try after publish is complete.' MessageDetails,  CAST(0 AS BIT ) Status
				END 
				ELSE
				 IF @IsCatalogPublishInProcess = 2 
				BEGIN
				
				SELECT 1 Id , 'Please associate products to the category or to at least one child category to publish the category.' MessageDetails,  CAST(0 AS BIT ) Status
				END 
				ELSE 
				BEGIN 
				SELECT 1 Id , ' Publish Successfull' MessageDetails, CAST(1 AS BIT ) Status
				END 
		END TRY
		BEGIN CATCH
			SELECT error_message()
				,error_procedure();
			UPDATE ZnodePublishCatalogLog 
			SET IsCatalogPublished = 0 
			WHERE PublishCatalogLogId = @versionId
			SET @status = 0;
			DECLARE @error_procedure varchar(1000)= error_procedure(),@errorMessage nvarchar(max)= error_message(),@errorLine varchar(100)= error_line(),@errorCall nvarchar(max)= 'EXEC Znode_GetPublishProducts @PimCatalogId = '+cast(@pimCatalogId AS varchar(max))+',@@PimCategoryHierarchyId='+@pimCategoryHierarchyId+',@UserId='+cast(@userId AS varchar(50))+',@UserId = '+cast(@userId AS varchar(50))+',@VersionId='+cast(@versionId AS varchar(50))+',@Status='+cast(@status AS varchar(10));
			SELECT 0 AS ID
				,cast(0 AS bit) AS Status;
			--ROLLBACK TRAN GetPublishProducts;
			EXEC Znode_InsertProcedureErrorLog @procedureName = 'Znode_GetPublishCategoryProducts',@errorInProcedure = @error_procedure,@errorMessage = @errorMessage,@errorLine = @errorLine,@errorCall = @errorCall;
		END CATCH;
		END;
GO
if exists(select * from sys.procedures where name = 'Znode_GetPublishCategory')
	drop proc Znode_GetPublishCategory
go



CREATE PROCEDURE [dbo].[Znode_GetPublishCategory]
(   @PublishCatalogId INT,
    @UserId           INT,
    @VersionId        INT,
    @Status           BIT = 0 OUT,
    @IsDebug          BIT = 0,
	@LocaleId         TransferID READONLY)
AS 
/*
       Summary:Publish category with their respective products and details 
	            The result is fetched in xml form   
       Unit Testing   
       Begin transaction 
       SELECT * FROM ZnodePIMAttribute 
	   SELECT * FROM ZnodePublishCatalog 
	   SELECT * FROM ZnodePublishCategory WHERE publishCAtegoryID = 167 


       EXEC [Znode_GetPublishCategory] @PublishCatalogId = 3,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 
     


       Rollback Transaction 
	*/
     BEGIN
         BEGIN TRAN GetPublishCategory;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @LocaleIdIn INT= 0, @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @Counter INT= 1, @MaxId INT= 0, @CategoryIdCount INT;
             DECLARE @IsActive BIT= [dbo].[Fn_GetIsActiveTrue]();
             DECLARE @AttributeIds VARCHAR(MAX)= '', @PimCategoryIds VARCHAR(MAX)= '', @DeletedPublishCategoryIds VARCHAR(MAX)= '', @DeletedPublishProductIds VARCHAR(MAX);
             --get the pim catalog id 
			 DECLARE @PimCatalogId INT=(SELECT PimCatalogId FROM ZnodePublishcatalog WHERE PublishCatalogId = @PublishCatalogId); 

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
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder   INT
             );
             DECLARE @TBL_AttributeValue TABLE
             (PimCategoryAttributeValueId INT,
              PimCategoryId               INT,
              CategoryValue               NVARCHAR(MAX),
              AttributeCode               VARCHAR(300),
              PimAttributeId              INT
             );
             DECLARE @TBL_LocaleIds TABLE
             (RowId     INT IDENTITY(1, 1),
              LocaleId  INT,
              IsDefault BIT
             );
             DECLARE @TBL_PimCategoryIds TABLE
             (PimCategoryId       INT,
              PimParentCategoryId INT,
              DisplayOrder        INT,
              ActivationDate      DATETIME,
              ExpirationDate      DATETIME,
              CategoryName        NVARCHAR(MAX),
              ProfileId           VARCHAR(MAX),
              IsActive            BIT,
			  PimCategoryHierarchyId INT,
			  ParentPimCategoryHierarchyId INT ,
			   CategoryCode  NVARCHAR(MAX)             );


             DECLARE @TBL_PublishPimCategoryIds TABLE
             (PublishCategoryId       INT,
              PimCategoryId           INT,
              PublishProductId        varchar(max),
              PublishParentCategoryId INT ,
			  PimCategoryHierarchyId INT ,parentPimCategoryHierarchyId INT,
			  RowIndex INT
             );
             DECLARE @TBL_DeletedPublishCategoryIds TABLE
             (PublishCategoryId INT,
              PublishProductId  INT
             );
             DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
              CategoryXml       XML,
              LocaleId          INT
             );
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
             SELECT LocaleId,IsDefault FROM ZnodeLocale MT WHERE IsActive = @IsActive
			  AND (EXISTS (SELECT TOP 1 1  FROM @LocaleId RT WHERE RT.Id = MT.LocaleId )
			 OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleId ));

			 if object_id('tempdb..#CategoryData')is not null
				drop table #CategoryData

			 ------------for CategoryCode update
			SELECT ZPCAL.CategoryValue as CategoryCode,MAX(ZPC.PublishCategoryId) as PublishCategoryId ,ZPCA.PimCategoryId, ZPoC.PortalId
			INTO #CategoryData
			FROM ZnodePimCategoryAttributeValue ZPCA
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAL on ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCA.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePublishCategory ZPC on ZPCA.PimCategoryId = ZPC.PimCategoryId
			INNER JOIN ZnodePortalCatalog ZPoC on ZPC.PublishCatalogId = ZPoC.PublishCatalogId
			where ZPA.AttributeCode = 'CategoryCode' AND ZPC.PublishCatalogId = @PublishCatalogId
			AND EXISTS(SELECT * FROM ZnodeCMSWidgetCategory ZCWC WHERE ZPC.PublishCategoryId = ZCWC.PublishCategoryId )
			group by ZPCAL.CategoryValue, ZPCA.PimCategoryId, ZPoC.PortalId

			UPDATE ZCWC SET ZCWC.CategoryCode = CD.CategoryCode
			from ZnodeCMSWidgetCategory ZCWC
			INNER JOIN #CategoryData CD ON ZCWC.PublishCategoryId = CD.PublishCategoryId and ZCWC.CMSMappingId = CD.PortalId
			where ZCWC.TypeOFMapping = 'PortalMapping'
			----------

             INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
             SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
			 FROM ZnodePimCategoryHierarchy AS ZPCH 
			 LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
			 WHERE ZPCH.PimCatalogId = @PimCatalogId; 
             -- AND IsActive = @IsActive ; -- As discussed with @anup active flag maintain on demo site 23/12/2016
			 --	SELECT * FROM @TBL_PimCategoryIds
			 -- here is find the deleted publish category id on basis of publish catalog
             INSERT INTO @TBL_DeletedPublishCategoryIds(PublishCategoryId,PublishProductId)
             SELECT ZPC.PublishCategoryId,ZPCP.PublishProductId 
			 FROM ZnodePublishCategoryProduct ZPCP
             INNER JOIN ZnodePublishCategory AS ZPC ON(ZPCP.PublishCategoryId = ZPC.PublishCategoryId AND ZPCP.PublishCatalogId = ZPC.PublishCatalogId)                                                  
             INNER JOIN ZnodePublishProduct ZPP ON(zpp.PublishProductId = zpcp.PublishProductId AND zpp.PublishCatalogId = zpcp.PublishCatalogId)
             INNER JOIN ZnodePublishCatalog ZPCC ON(ZPCC.PublishCatalogId = ZPCP.PublishCatalogId)
             WHERE ZPC.PublishCatalogId = @PublishCataLogId 
			 AND NOT EXISTS(SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy AS TBPC WHERE TBPC.PimCategoryId = ZPC.PimCategoryId AND TBPC.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId
			 AND TBPC.PimCatalogId = ZPCC.PimCatalogId);

			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishCategoryIds = ISNULL(SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_DeletedPublishCategoryIds AS ZPC
                                              GROUP BY ZPC.PublishCategoryId FOR XML PATH('') ), 2, 4000), '');
			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishProductIds = '';
			 -- Delete the publish category id 
	
	        --   SELECT * FROM @TBL_DeletedPublishCategoryIds 

             EXEC Znode_DeletePublishCatalog @PublishCatalogIds = @PublishCatalogId,@PublishCategoryIds = @DeletedPublishCategoryIds,@PublishProductIds = @DeletedPublishProductIds; 
			
             MERGE INTO ZnodePublishCategory TARGET USING  @TBL_PimCategoryIds SOURCE ON
			 (
			 TARGET.PimCategoryId = SOURCE.PimCategoryId 
			 AND TARGET.PublishCatalogId = @PublishCataLogId 
			 AND TARGET.PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId
			 )
			 WHEN MATCHED THEN UPDATE SET TARGET.PimParentCategoryId = SOURCE.PimParentCategoryId,TARGET.CreatedBy = @UserId,TARGET.CreatedDate = @GetDate,
             TARGET.ModifiedBy = @UserId,TARGET.ModifiedDate = @GetDate,PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId,ParentPimCategoryHierarchyId=SOURCE.ParentPimCategoryHierarchyId
             WHEN NOT MATCHED THEN INSERT(PimCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PimCategoryHierarchyId,ParentPimCategoryHierarchyId) 
			 VALUES(SOURCE.PimCategoryId,@PublishCatalogId,@UserId,@GetDate,@UserId,@GetDate,SOURCE.PimCategoryHierarchyId,SOURCE.ParentPimCategoryHierarchyId)
             OUTPUT INSERTED.PublishCategoryId,INSERTED.PimCategoryId,INSERTED.PimCategoryHierarchyId,INSERTED.parentPimCategoryHierarchyId INTO @TBL_PublishPimCategoryIds(PublishCategoryId,PimCategoryId,PimCategoryHierarchyId,parentPimCategoryHierarchyId);
			
    --         UPDATE TBPC SET PublishParentCategoryId = TBPCS.PublishCategoryId 
			 --FROM @TBL_PublishPimCategoryIds TBPC
    --         INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId)
    --         INNER JOIN @TBL_PublishPimCategoryIds TBPCS ON(TBC.PimCategoryHierarchyId = TBPCS.parentPimCategoryHierarchyId  ) 
			 --WHERE TBC.parentPimCategoryHierarchyId IS NOT NULL;
           
		     -- here update the publish parent category id
             UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] 
			 FROM ZnodePublishCategory ZPC
             INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL
			 AND TBPC.PublishCatalogId =@PublishCatalogId
			 ;
			 UPDATE a
			 SET  a.PublishParentCategoryId = b.PublishCategoryId
			FROM ZnodePublishCategory a 
			INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
			WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
			AND a.PublishCatalogId =@PublishCatalogId
			AND b.PublishCatalogId =@PublishCatalogId

			UPDATE a set a.PublishParentCategoryId = NULL
			FROM ZnodePublishCategory a 
			WHERE a.parentpimCategoryHierarchyId IS NULL AND PimParentCategoryId IS NULL
			AND a.PublishCatalogId = @PublishCatalogId AND a.PublishParentCategoryId IS NOT NULL

			 --UPDATE ZPC SET [PimParentCategoryId] = TBPC.[PimCategoryId] 
			 --FROM ZnodePublishCategory ZPC
    --         INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 --WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 --AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL ;

			 -- product are published here 
            --  EXEC Znode_GetPublishProducts @PublishCatalogId,0,@UserId,1,0,0;

             SET @MaxId =(SELECT MAX(RowId)FROM @TBL_LocaleIds);
			 DECLARE @TransferID TRANSFERID 
			 INSERT INTO @TransferID 
			 SELECT DISTINCT  PimCategoryId
			 FROM @TBL_PublishPimCategoryIds 

             SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(50)) FROM @TBL_PublishPimCategoryIds FOR XML PATH('')), 2, 4000);
			 
             WHILE @Counter <= @MaxId -- Loop on Locale id 
                 BEGIN
                     SET @LocaleIdIn =(SELECT LocaleId FROM @TBL_LocaleIds WHERE RowId = @Counter);
                   
				     SET @AttributeIds = SUBSTRING((SELECT ','+CAST(ZPCAV.PimAttributeId AS VARCHAR(50)) FROM ZnodePimCategoryAttributeValue ZPCAV 
										 WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC WHERE TBPC.PimCategoryId = ZPCAV.PimCategoryId) GROUP BY ZPCAV.PimAttributeId FOR XML PATH('')), 2, 4000);
                
				     SET @CategoryIdCount =(SELECT COUNT(1) FROM @TBL_PimCategoryIds);

                     INSERT INTO @TBL_AttributeIds (PimAttributeId,ParentPimAttributeId,AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,
					 IsConfigurable,IsPersonalizable,DisplayOrder,HelpDescription,IsCategory,IsHidden,CreatedDate,ModifiedDate,AttributeName,AttributeTypeName)
                     EXEC [Znode_GetPimAttributesDetails] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeDefault (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)
                     EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
                     EXEC [dbo].[Znode_GetCategoryAttributeValueId] @TransferID,@AttributeIds,@LocaleIdIn;

					-- SELECT * FROM @TBL_AttributeValue WHERE PimCategoryId = 281


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
                     AS (SELECT TBA.PimCategoryId,TBA.PimAttributeId,[dbo].[FN_GetThumbnailMediaPathPublish](SUBSTRING((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
					    (SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH('')), 2, 4000)) CategoryValue
						FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId))
                         
					 UPDATE TBAV SET CategoryValue = CTCM.CategoryValue 
					 FROM @TBL_AttributeValue TBAV 
					 INNER JOIN Cte_productMedia CTCM ON(CTCM.PimCategoryId = TBAV.PimCategoryId
					 AND CTCM.PimAttributeId = TBAV.PimAttributeId);

                     WITH Cte_PublishProductIds
					 AS (SELECT TBPC.PublishcategoryId,SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50))
					  FROM ZnodePublishCategoryProduct ZPCP 
					  WHERE ZPCP.PublishCategoryId = TBPC.publishCategoryId
					  AND ZPCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId
                      AND ZPCP.PublishCatalogId = @PublishCatalogId FOR XML PATH('')), 2, 8000) PublishProductId ,PimCategoryHierarchyId
					  FROM @TBL_PublishPimCategoryIds TBPC)
                          
					 UPDATE TBPPC SET PublishProductId = CTPP.PublishProductId FROM @TBL_PublishPimCategoryIds TBPPC INNER JOIN Cte_PublishProductIds CTPP ON(TBPPC.PublishCategoryId = CTPP.PublishCategoryId 
					 AND TBPPC.PimCategoryHierarchyId = CTPP.PimCategoryHierarchyId);

                     WITH Cte_CategoryProfile
                     AS (SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
					 FROM ZnodeProfileCatalog ZPC 
					 INNER JOIN ZnodeProfileCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
                        AND ZPRCC.ProfileCatalogId = ZPC.ProfileCatalogId) 
						WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
                      
					   FROM ZnodePimCategoryHierarchy ZPCC 
					   WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
					   WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId = @PimCatalogId 
					   AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId))
                          
				     UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds FROM @TBL_PimCategoryIds TBPC 
					 LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
                     
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId));


					  UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )


					DECLARE @UpdateCategoryLog  TABLE (PublishCatalogLogId INT , LocaleId INT ,PublishCatalogId INT  )
					INSERT INTO @UpdateCategoryLog
					SELECT MAX(PublishCatalogLogId) PublishCatalogLogId , LocaleId , PublishCatalogId 
					FROM ZnodePublishCatalogLog a 
					WHERE a.PublishCatalogId =@PublishCatalogId
					AND  a.LocaleId = @LocaleIdIn 
					GROUP BY 	LocaleId,PublishCatalogId 



					 -- here update the publish category details 
                     ;WITH Cte_UpdateCategoryDetails
                     AS (
					 SELECT TBC.PimCategoryId,PublishCategoryId,CategoryName, TBPPC.PimCategoryHierarchyId,CategoryCode
					 FROM @TBL_PimCategoryIds TBC
                     INNER JOIN @TBL_PublishPimCategoryIds TBPPC ON(TBC.PimCategoryId = TBPPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPPC.PimCategoryHierarchyId)
					 )						
                     MERGE INTO ZnodePublishCategoryDetail TARGET USING Cte_UpdateCategoryDetails SOURCE ON(TARGET.PublishCategoryId = SOURCE.PublishCategoryId
					 AND TARGET.LocaleId = @LocaleIdIn)
                     WHEN MATCHED THEN UPDATE SET PublishCategoryId = SOURCE.PublishcategoryId,PublishCategoryName = SOURCE.CategoryName,LocaleId = @LocaleIdIn,ModifiedBy = @userId,ModifiedDate = @GetDate,CategoryCode=SOURCE.CategoryCode
                     WHEN NOT MATCHED THEN INSERT(PublishCategoryId,PublishCategoryName,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CategoryCode) VALUES
                     (SOURCE.PublishCategoryId,SOURCE.CategoryName,@LocaleIdIn,@userId,@GetDate,@userId,@GetDate,SOURCE.CategoryCode);

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

                     ;WITH Cte_CategoryXML
                     AS (SELECT PublishcategoryId,PimCategoryId,(SELECT ISNULL(TYU.PublishCatalogLogId,'') VersionId,TBPC.PublishCategoryId ZnodeCategoryId,@PublishCatalogId ZnodeCatalogId
																		,THR.PublishParentCategoryId TempZnodeParentCategoryIds,ZPC.CatalogName ,
																		 ISNULL(DisplayOrder, '0') DisplayOrder,@LocaleIdIn LocaleId,ActivationDate 
																		 ,ExpirationDate,TBC.IsActive,ISNULL(CategoryName, '') Name,ProfileId TempProfileIds,ISNULL(TBPC.PublishProductId, '') TempProductIds
																		 ,ISNULL(TBPC.RowIndex,1) CategoryIndex
																		 ,ISNULL(CategoryCode,'') CategoryCode
                        FROM @TBL_PublishPimCategoryIds TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId= @PublishCatalogId)
						LEFT JOIN @UpdateCategoryLog TYU ON (TYU.PublishCatalogId = @PublishCatalogId AND TYU.LocaleId = @LocaleIdIn)
						INNER JOIN ZnodePublishCAtegory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId= @PublishCatalogId )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) WHERE TBPC.PublishCategoryId = TBPCO.PublishCategoryId 
						FOR XML PATH('')) CategoryXml 
						FROM @TBL_PublishPimCategoryIds TBPCO),

                     Cte_CategoryAttributeXml
                     AS (SELECT CTCX.PublishCategoryId,'<CategoryEntity>'+ISNULL(CategoryXml, '')+ISNULL((SELECT(SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
                        ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,(SELECT ''+TBAV.CategoryValue FOR XML PATH('')) AttributeValues,TBA.AttributeTypeName FROM @TBL_AttributeValue TBAV
                        INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
                        WHERE CTCX.PimCategoryId = TBAV.PimCategoryId AND TBAO.PimAttributeId = TBA.PimAttributeId FOR XML PATH('AttributeEntity'), TYPE) FROM @TBL_AttributeIds TBAO
                        FOR XML PATH('Attributes')), '')+'</CategoryEntity>' CategoryXMl FROM Cte_CategoryXML CTCX)

                     INSERT INTO @TBL_CategoryXml(PublishCategoryId,CategoryXml,LocaleId)
                     SELECT PublishCategoryId,CategoryXml,@LocaleIdIn LocaleId FROM Cte_CategoryAttributeXml;
                   
				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;

    --         UPDATE ZnodePublishCatalogLog SET PublishCategoryId = SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_CategoryXml
			 --GROUP BY PublishCategoryId																				
    --         FOR XML PATH('')), 2, 4000), IsCategoryPublished = 1 WHERE PublishCatalogLogId = @VersionId;

			 --UPDATE ZnodePublishCatalogLog 
			 --SET PublishCategoryId = (SELECT COunt(DISTINCT PublishCategoryId ) FROM ZnodePublishCategory WHERE PublishCatalogId =@PublishCatalogId), IsCategoryPublished = 1 
			 --WHERE EXISTS (SELECT TOP 1 1 FROM @UpdateCategoryLog TY WHERE TY.PublishCatalogLogId =  ZnodePublishCatalogLog.PublishCatalogLogId ) ;


			 UPDATE ZnodePublishCatalogLog 
			 SET PublishCategoryId = (SELECT COunt(DISTINCT PimCategoryId ) 
			 FROM @TBL_PublishPimCategoryIds WHERE PublishCatalogId =@PublishCatalogId), 
			 IsCategoryPublished = 1 
			 WHERE EXISTS (SELECT TOP 1 1 FROM @UpdateCategoryLog TY WHERE TY.PublishCatalogLogId =  ZnodePublishCatalogLog.PublishCatalogLogId ) ;
			 


             DELETE FROM ZnodePublishedXml WHERE PublishCataloglogId = @VersionId;
            
             INSERT INTO ZnodePublishedXml (PublishCatalogLogId,PublishedId,PublishedXML,IsCategoryXML,IsProductXML,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
             SELECT @VersionId PublishCataloglogId,PublishCategoryId,CategoryXml,1,0,LocaleId,@UserId,@GetDate,@UserId,@GetDate FROM @TBL_CategoryXml WHERE @VersionId <> 0;
             
			 SELECT CategoryXml  
			 FROM @TBL_CategoryXml 
			 

			 ------------for CategoryPublishId update
			SELECT ZPCAL.CategoryValue as CategoryCode,MAX(ZPC.PublishCategoryId) as PublishCategoryId ,ZPCA.PimCategoryId,ZPoC.PortalId
			INTO #CategoryData1
			FROM ZnodePimCategoryAttributeValue ZPCA
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAL on ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCA.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePublishCategory ZPC on ZPCA.PimCategoryId = ZPC.PimCategoryId
			INNER JOIN ZnodePortalCatalog ZPoC on ZPC.PublishCatalogId = ZPoC.PublishCatalogId
			where ZPA.AttributeCode = 'CategoryCode' AND ZPC.PublishCatalogId = @PublishCatalogId
			group by ZPCAL.CategoryValue, ZPCA.PimCategoryId, ZPoC.PortalId

			UPDATE ZCWC SET ZCWC.PublishCategoryId = CD.PublishCategoryId
			from ZnodeCMSWidgetCategory ZCWC
			INNER JOIN #CategoryData1 CD ON ZCWC.CategoryCode = CD.CategoryCode and ZCWC.CMSMappingId = CD.PortalId
			where ZCWC.TypeOFMapping = 'PortalMapping'
			----------------

			 --UPDATE ZnodePimCategory 
			 --SET IsCategoryPublish =1 
			 --WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_PimCategoryIds)

			 UPDATE ZnodePimCategory 
			 SET PublishStateId = Dbo.Fn_GetPublishStateIdForPreview()
			 WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_CategoryXml)

              
             COMMIT TRAN GetPublishCategory;
			 
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishCategory @PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0;
             ROLLBACK TRAN GetPublishCategory;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishCategory',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
insert into ZnodeApplicationSetting(GroupName,ItemName,Setting,ViewOptions,FrontPageName,FrontObjectName,IsCompressed,OrderByFields,ItemNameWithoutCurrency,CreatedByName,ModifiedByName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select 'Table', 'ZnodeAssociatedSalesRep','<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>UserId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>display-none</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>FullName</name>      <headertext>Full Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>columnFullName</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>UserName</name>      <headertext>Username</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>columnUsername</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Email</name>      <headertext>Email ID</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Email Id</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PhoneNumber</name>      <headertext>Phone Number</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Phone Number</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>0</width>      <datatype>Date</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsLock</name>      <headertext>Is Lock</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Is Lock</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Manage|Disable|Delete</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Manage|Lock|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>UserId|UserId,IsLock|UserId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Delete</name>      <headertext>Delete</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>/Account/DeleteUser</deleteactionurl>      <deleteparamfield>UserId</deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>View</name>      <headertext>View</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>/Account/ManageUser</viewactionurl>      <viewparamfield>UserId</viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>',
'ZnodeSalesReps','ZnodeSalesReps','ZnodeSalesReps',0,null,null,null,null,2,getdate(),2,getdate()
where not exists(select * from ZnodeApplicationSetting where ItemName = 'ZnodeAssociatedSalesRep')
go
if not exists(select * from sys.tables where name = 'ZnodeSalesRepCustomerUserPortal')
begin
	CREATE TABLE [dbo].[ZnodeSalesRepCustomerUserPortal] (
		[SalesRepCustomerUserPortalId] INT      IDENTITY (1, 1) NOT NULL,
		[UserPortalId]                 INT      NULL,
		[SalesRepUserId]               INT      NULL,
		[CustomerUserid]               INT      NULL,
		[CustomerPortalId]             INT      NULL,
		[CreatedBy]                    INT      NOT NULL,
		[CreatedDate]                  DATETIME NOT NULL,
		[ModifiedBy]                   INT      NOT NULL,
		[ModifiedDate]                 DATETIME NOT NULL,
		CONSTRAINT [PK_ZnodeSalesRepCustomerUserPortal] PRIMARY KEY CLUSTERED ([SalesRepCustomerUserPortalId] ASC) WITH (FILLFACTOR = 90),
		CONSTRAINT [FK_ZnodeSalesRepCustomerUserPortal_ZnodePortal_PortalId] FOREIGN KEY ([CustomerPortalId]) REFERENCES [dbo].[ZnodePortal] ([PortalId]),
		CONSTRAINT [FK_ZnodeSalesRepCustomerUserPortal_ZnodeUser_SalesRepUserId] FOREIGN KEY ([SalesRepUserId]) REFERENCES [dbo].[ZnodeUser] ([UserId]),
		CONSTRAINT [FK_ZnodeSalesRepCustomerUserPortal_ZnodeUser_UserId] FOREIGN KEY ([CustomerUserid]) REFERENCES [dbo].[ZnodeUser] ([UserId]),
		CONSTRAINT [FK_ZnodeSalesRepUserPortal_ZnodeUserPortal_UserPortalId] FOREIGN KEY ([UserPortalId]) REFERENCES [dbo].[ZnodeUserPortal] ([UserPortalId])
	);
end
go
if exists(select * from sys.procedures where name = 'Znode_AdminUsers')
	drop proc Znode_AdminUsers
go

CREATE PROCEDURE [dbo].[Znode_AdminUsers]
(	@RoleName		VARCHAR(200),
    @UserName		VARCHAR(200),
    @WhereClause	VARCHAR(MAX)  = '',
    @Rows			INT           = 100,
    @PageNo			INT           = 1,
    @Order_By		VARCHAR(1000) = '',
    @RowCount		INT        = 0 OUT,
	@IsCallOnSite   BIT = 0 ,
	@PortalId		VARCHAR(1000) = 0,
	@IsGuestUser    BIT = 0 )
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
             
			IF @PortalId  <> '0' 
			BEGIN 
			    SET @WhereClause = CASE WHEN  @WhereClause = '' THEN ' (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' ELSE @WhereClause+' AND (PortalId IN ('+@PortalId+') OR PortalId IS NULL) ' END 
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
					 
				SELECT  DISTINCT A.UserId,AspNetUserId,UserName,FirstName,MiddleName,LastName,Email,EmailOptIn,BudgetAmount,A.CreatedBy,A.CreatedDate,A.ModifiedBy,A.ModifiedDate
				,RoleId,RoleName,IsActive,IsLock,FullName,AccountName,PermissionsName,PermissionCode,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId,PhoneNumber
				,ExternalId,ApprovalName,ApprovalUserId,AccountUserOrderApprovalId ,CustomerPaymentGUID
				INTO #Cte_AdminUserDetail
				FROM View_AdminUserDetail A
				'+CASE WHEN @PortalId  <> '0' THEN ' INNER JOIN ZnodeUserPortal ZUP ON (ZUP.UserId = A.UserId) 'ELSE '' END  +'	 
				'+dbo.Fn_GetWhereClause(@WhereClause, ' WHERE ')+'
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
			
				SET @SQL = '
				
				SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #Cte_CustomerUserDetail
				FROM View_CustomerUserAddDetail a 
				
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
				' END +dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+' 
				
				;With Cte_CustomerUserDetailRowId  AS 
				(
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId ,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				FROM #Cte_CustomerUserDetail -- genrate the unique rowid 
				)
					 			 
				SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RowId,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
				INTO #AccountDetail FROM Cte_CustomerUserDetailRowId  

				SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetail    ),0)

				alter table #AccountDetail add SalesRepUserName varchar(500), SalesRepFullName varchar(500)

				update CUAD
				set CUAD.SalesRepUserName = azu.UserName, 
					CUAD.SalesRepFullName = (ISNULL(RTRIM(LTRIM(ZU.FirstName)), '''')+'' ''+ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '''')
										+CASE
											WHEN ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '''') = ''''
											THEN ''''
											ELSE '' ''
										END+ISNULL(RTRIM(LTRIM(ZU.LastName)), '''')) 
				from #AccountDetail CUAD
				inner join ZnodeSalesRepCustomerUserPortal SRCUP ON CUAD.UserId = SRCUP.CustomerUserid 
				inner join ZnodeUser ZU ON SRCUP.SalesRepUserId = ZU.UserId
				inner join ASPNetUsers ANU ON(ZU.AspNetuserId = ANU.Id)
				inner join AspNetZnodeUser azu ON(azu.AspNetZnodeUserId = ANU.UserName)
												  
				SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName, SalesRepUserName, SalesRepFullName
				FROM #AccountDetail '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC');
                PRINT @SQL    					
				EXEC SP_executesql
				@SQL,
				N'@Count INT OUT',
				@Count = @RowCount OUT;
				END;
            ELSE
				BEGIN
					SELECT * FROM View_CustomerUserDetail AS VICUD WHERE 1 = 0;
					SET @RowCount = 0;
				END;
            END;			
         END TRY
         BEGIN CATCH
            DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUsers @RoleName = '+@RoleName+' ,@UserName='+@UserName+',@WhereClause='+@WhereClause+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50));
            EXEC Znode_InsertProcedureErrorLog
            @ProcedureName    = 'Znode_AdminUsers',
            @ErrorInProcedure = @ERROR_PROCEDURE,
            @ErrorMessage     = @ErrorMessage,
            @ErrorLine        = @ErrorLine,
            @ErrorCall        = @ErrorCall;
         END CATCH;


     END;
GO
if exists(select * from sys.procedures where name = 'Znode_AdminUsersSalesRep')
	drop proc Znode_AdminUsersSalesRep
go

CREATE PROCEDURE [dbo].[Znode_AdminUsersSalesRep]
(	
	@RoleName		VARCHAR(200)='',
    @WhereClause	VARCHAR(MAX)  = '',
    @Rows			INT           = 100,
    @PageNo			INT           = 1,
    @Order_By		VARCHAR(1000) = '',
    @RowCount		INT        = 0 OUT,
	@UserId int = 0
)
AS
begin
		set nocount on

		declare @SQL nvarchar(max)
		declare @PaginationWhereClause VARCHAR(300)= dbo.Fn_GetRowsForPagination(@PageNo, @Rows, ' WHERE RowId');

		BEGIN TRY

			if OBJECT_ID('tempdb..##CustomerUserAddDetail') is not null
				drop table ##CustomerUserAddDetail

			if OBJECT_ID('tempdb..##View_SalesRepUserAddDetail') is not null
				drop table ##View_SalesRepUserAddDetail
			
			-----Getting SalesRep users associated with Portals of @UserId (given user)
			--select a.UserId 
			--into #SalesRepUser
			--from ZnodeUserPortal a
			--inner join ZnodeSalesRepCustomerUserPortal b on a.UserPortalId = b.UserPortalId and a.UserId = b.SalesRepUserId
			--where exists(select * from ZnodeUserPortal ZUP where UserId = @UserId and a.PortalId = ZUP.PortalId)
			
			-----Getting SalesRep users associated with Portals of @UserId (given user)
			select a.UserId 
			into #SalesRepUser
			from ZnodeUserPortal a
			inner join ZnodeUser b on a.UserId = b.UserId 
			inner join AspNetUsers c on b.AspNetUserId = c.Id
			inner join AspNetUserRoles d on c.Id = d.UserId
			inner join AspNetRoles e on d.RoleId = e.Id
			where e.Name = 'Sales Rep'
			and (exists(select * from ZnodeUserPortal ZUP where ZUP.UserId = @UserId and (a.PortalId = ZUP.PortalId or ZUP.PortalId is null))
			    or a.PortalId is null)
		    

			SELECT a.userId,a.AspNetuserId,azu.UserName,a.FirstName,a.MiddleName,a.LastName,a.PhoneNumber,
				a.Email,a.EmailOptIn,a.CreatedBy,CONVERT( DATE, a.CreatedDate) CreatedDate,A.ModifiedBy,
				CONVERT( DATE, a.ModifiedDate) ModifiedDate,ur.RoleId,r.Name RoleName,
				CASE
					WHEN B.LockoutEndDateUtc IS NULL
					THEN CAST(1 AS    BIT)
					ELSE CAST(0 AS BIT)
				END IsActive,
				CAST(CASE WHEN ISNULL(LockoutEndDateUtc, 0) = 0 THEN  0 ELSE  1 END  AS    BIT) AS IsLock,
				(ISNULL(RTRIM(LTRIM(a.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(a.MiddleName)), '')
					+CASE
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
				a.BudgetAmount,r.TypeOfRole,CASE WHEN a.AspNetuserId IS NULL THEN 1 ELSE 0 END IsGuestUser
				,a.CustomerPaymentGUID
		into ##View_SalesRepUserAddDetail
		FROM ZnodeUser a
		left JOIN ASPNetUsers B ON(a.AspNetuserId = b.Id)
		LEFT JOIN ZnodeAccount e ON(e.AccountId = a.AccountId)
		LEFT JOIN AspNetUserRoles ur ON(ur.UserId = a.AspNetUserId)
		LEFT JOIN AspNetRoles r ON(r.Id = ur.RoleId)                               
		LEFT JOIN AspNetZnodeUser azu ON(azu.AspNetZnodeUserId = b.UserName)
		WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeUSer ZUQ WHERE ZUQ.UserId = a.UserId AND ZUQ.EmailOptIn = 1 AND ZUQ.AspNetUserId IS NULL )
		and exists(select * from #SalesRepUser SRU where a.UserId = SRU.UserId)

	alter table ##View_SalesRepUserAddDetail 
	add DepartmentId int, PermissionsName varchar(200), PermissionCode varchar(200), DepartmentName varchar(300), AccountPermissionAccessId int,
	AccountUserOrderApprovalId int, ApprovalName varchar(1000) , ApprovalUserId int, PortalId int , StoreName varchar(1000)
	,CountryName varchar(1000),CityName varchar(1000),StateName varchar(1000),PostalCode varchar(1000), CompanyName varchar(1000)

	--To get data for DepartmentId
	update CUD SET DepartmentId = i.DepartmentId
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeDepartmentUser i ON(i.UserId = cud.UserId)
		
	--To get data for PermissionsName
	update CUD SET PermissionsName = h.PermissionsName, PermissionCode = h.PermissionCode
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeAccountUserPermission f ON(f.UserId = cud.UserId)
	INNER JOIN ZnodeAccountPermissionAccess g ON(g.AccountPermissionAccessId = f.AccountPermissionAccessId)
	INNER JOIN ZnodeAccessPermission h ON(h.AccessPermissionId = g.AccessPermissionId)
	
	--To get data for DepartmentName
	update CUD SET DepartmentName = j.DepartmentName
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeDepartmentUser i ON(i.UserId = cud.UserId)
	INNER JOIN ZnodeDepartment j ON(j.DepartmentId = i.DepartmentId)

	--To get data for AccountPermissionAccessId
	update CUD SET AccountPermissionAccessId = f.AccountPermissionAccessId
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeAccountUserPermission f ON(f.UserId = cud.UserId)

	--To get data for AccountPermissionAccessId
	update CUD SET AccountPermissionAccessId = f.AccountPermissionAccessId
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeAccountUserPermission f ON(f.UserId = cud.UserId)
		
	--To get data for AccountUserOrderApprovalId
	update CUD SET AccountUserOrderApprovalId = ZAUOA.AccountUserOrderApprovalId
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeAccountUserOrderApproval ZAUOA ON cud.UserId = ZAUOA.UserID
		
	--To get data for ApprovalName,ApprovalUserId
	update CUD SET ApprovalName = ISNULL(RTRIM(LTRIM(ZU.FirstName)), '')+' '+ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '')
									+CASE
										WHEN ISNULL(RTRIM(LTRIM(ZU.MiddleName)), '') = ''
										THEN ''
										ELSE ' '
									END,
					ApprovalUserId = ZAUOA.ApprovalUserId
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeAccountUserOrderApproval ZAUOA ON cud.UserId = ZAUOA.UserID
	INNER JOIN ZnodeUser ZU ON(ZU.UserId = ZAUOA.ApprovalUserId)
		
	--To get data for PortalId
	update CUD SET PortalId = CASE
									WHEN cud.AccountId IS NULL
									THEN up.PortalId
									ELSE ZPA.PortalId
								END 
	from ##View_SalesRepUserAddDetail cud
	INNER JOIN ZnodeUserPortal up ON(up.UserId = cud.UserId) 
	INNER JOIN ZnodePortalAccount ZPA ON(ZPA.AccountId = cud.AccountId) 
		
	----To get data for StoreName
	create index Ind_##View_SalesRepUserAddDetail_UserId on ##View_SalesRepUserAddDetail(UserId)
	update CUD SET StoreName = CASE WHEN zp.StoreName IS NULL THEN 'ALL' ELSE zp.StoreName END 
	from ##View_SalesRepUserAddDetail cud
	LEFT JOIN ZnodeUserPortal up ON(up.UserId = cud.UserId) 
	LEFT JOIN ZnodePortal zp ON (up.PortalId = zp.PortalId)
		
	----To get data for StoreName
	update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName
	from ##View_SalesRepUserAddDetail a
	inner join ZnodeAccountAddress ZAA on a.AccountId = ZAA.AccountId
	inner  JOIN ZnodeAddress ZA on ZA.AddressId = ZAA.AddressId
	where isnull(a.AccountId,0)<> 0-- is not null

		
	----To get data for CountryName, CityName, StateName, PostalCode, CompanyName
	update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName
	from ##View_SalesRepUserAddDetail a
	inner join ZnodeAccountAddress ZAA on a.AccountId = ZAA.AccountId
	inner  JOIN ZnodeAddress ZA on ZA.AddressId = ZAA.AddressId
	where isnull(a.AccountId,0)<> 0-- is not null
	 
	update  a set CountryName = ZA.CountryName, CityName = za.CityName, StateName = ZA.StateName, PostalCode = ZA.PostalCode, CompanyName = ZA.CompanyName
	from ##View_SalesRepUserAddDetail a
	inner join ZnodeUserAddress ZUA on a.UserId = ZUA.UserId
	inner  JOIN ZnodeAddress ZA on ZA.AddressId = zua.AddressId
		
	SET @SQL = '			
			SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
			EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
			AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
			BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,StoreName,PortalId,
			CountryName, CityName, StateName, PostalCode, CompanyName
			INTO #Cte_CustomerUserDetail
			FROM ##View_SalesRepUserAddDetail a 				
			WHERE 1=1 '+dbo.Fn_GetWhereClause(@WhereClause, ' AND ')+' 
					
			----;With Cte_CustomerUserDetailRowId  AS 
			----(
			SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
			EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
			AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
			BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RANK()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowId ,StoreName,PortalId,
			CountryName, CityName, StateName, PostalCode, CompanyName
			into #AccountDetail
			FROM #Cte_CustomerUserDetail -- genrate the unique rowid 
			----)
					 			 
			--SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
			--EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
			--AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
			--BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode,CustomerPaymentGUID ,RowId,StoreName,PortalId,
			--CountryName, CityName, StateName, PostalCode, CompanyName
			--INTO #AccountDetail FROM Cte_CustomerUserDetailRowId  

			SET @Count= ISNULL((SELECT  Count(1) FROM #AccountDetail    ),0)

			SELECT DISTINCT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
			EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
			AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
			BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
			CountryName, CityName, StateName, PostalCode, CompanyName
			,Row_Number()Over('+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC')+',UserId DESC) RowNumber
			into ##CustomerUserAddDetail
			FROM #AccountDetail '+@PaginationWhereClause+' '+dbo.Fn_GetOrderByClause(@Order_By, 'UserId DESC');
			PRINT @SQL    					
			EXEC SP_executesql @SQL,
			N'@Count INT OUT',
			@Count = @RowCount OUT;
		
		SELECT UserId,AspNetuserId,UserName,FirstName,MiddleName,LastName,PhoneNumber,Email,
				EmailOptIn,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RoleId,RoleName,IsActive,IsLock,FullName,
				AccountName,PermissionsName,DepartmentName,DepartmentId,AccountId,AccountPermissionAccessId , ExternalId,
				BudgetAmount,AccountUserOrderApprovalId,ApprovalName,ApprovalUserId,PermissionCode ,CustomerPaymentGUID,StoreName,PortalId,
				CountryName, CityName, StateName, PostalCode, CompanyName
		from ##CustomerUserAddDetail
		where UserId <> @UserId
		Order by RowNumber
	
		if OBJECT_ID('tempdb..##CustomerUserAddDetail') is not null
			drop table ##CustomerUserAddDetail

		if OBJECT_ID('tempdb..##View_SalesRepUserAddDetail') is not null
			drop table ##View_SalesRepUserAddDetail

		END TRY
         BEGIN CATCH
            DECLARE @ERROR_PROCEDURE VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_AdminUsersSalesRep @RoleName = '+@RoleName+' ,@WhereClause='+@WhereClause+' ,@Rows= '+CAST(@Rows AS VARCHAR(50))+',@PageNo='+CAST(@PageNo AS VARCHAR(50))+',@Order_By='+@Order_By+',@RowCount='+CAST(@RowCount AS VARCHAR(50))+',@UserId='+CAST(@UserId AS VARCHAR(50)) ;
            EXEC Znode_InsertProcedureErrorLog
            @ProcedureName    = 'Znode_AdminUsersSalesRep',
            @ErrorInProcedure = @ERROR_PROCEDURE,
            @ErrorMessage     = @ErrorMessage,
            @ErrorLine        = @ErrorLine,
            @ErrorCall        = @ErrorCall;
         END CATCH;
end
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
GO
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
GO
if exists(select * from sys.procedures where name = 'Znode_DeleteUserDetails')
	drop proc Znode_DeleteUserDetails
go

CREATE PROCEDURE [dbo].[Znode_DeleteUserDetails]
(
       @UserId VARCHAR(2000) = NULL ,
       @Status INT OUT	  , 
	   @UserIds Transferid READONLY , 
	   @IsForceFullyDelete BIT =0  ,@IsCallInternal   BIT = 0 
)
AS
/*
Summary: This Procedure Is used to delete user details
Unit Testing:
EXEC Znode_DeleteUserDetails 

*/
     BEGIN
         BEGIN TRY
             SET NOCOUNT ON;
             BEGIN TRAN A;
			 DECLARE @StatusOut Table (Id INT ,Message NVARCHAR(max), Status BIT )
             DECLARE @V_table TABLE (
                                    USERID1 NVARCHAR(200)
                                    );
             DECLARE @V_tabledeleted TABLE (
                                           UserId1      INT ,
                                           AspnetUserid NVARCHAR(1000)
                                           );
             DECLARE @TBL_DeleteduserName TABLE (
                                                id NVARCHAR(MAX)
                                                );
             INSERT INTO @V_tabledeleted
                    SELECT ITEM , b.AspNetUserId
                    FROM dbo.split ( @UserId , ','
                                   ) AS a INNER JOIN ZnodeUser AS b ON ( a.Item = b.UserId )
								   WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeOmsOrderDetails zood WHERE zood.UserId= b.UserId)
					 AND UserId <> 2 
		     INSERT INTO @V_tabledeleted 						   
			  	 SELECT a.Id , b.AspNetUserId
                    FROM @UserIds AS a 
					INNER JOIN ZnodeUser AS b ON ( a.Id = b.UserId )
								   WHERE (NOT EXISTS (SELECT TOP 1 1 FROM ZnodeOmsOrderDetails zood WHERE zood.UserId= b.UserId) OR @IsForceFullyDelete =1 )	
								   AND UserId <> 2 			  
             DELETE FROM ZnodeUserProfile
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeUserProfile.UserId
                          );
             DELETE FROM ZnodeUserAddress
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeUserAddress.UserId
                          ); 

			--------
			delete from ZnodeOmsPersonalizeCartItem 
			where OmsSavedCartLineItemId in (
				select OmsSavedCartLineItemId  from ZnodeOmsSavedCartLineItem where OmsSavedCartId in (
				select OmsSavedCartId FROM ZnodeOmsSavedCart
				where OmsCookieMappingId in (select OmsCookieMappingId from ZnodeOmsCookieMapping
										 WHERE EXISTS ( SELECT TOP 1 1
														FROM @V_tabledeleted AS a
														WHERE a.UserId1 = ZnodeOmsCookieMapping.UserId
													  ))));

			delete from ZnodeOmsSavedCartLineItem where OmsSavedCartId in (
			select OmsSavedCartId FROM ZnodeOmsSavedCart
			where OmsCookieMappingId in (select OmsCookieMappingId from ZnodeOmsCookieMapping
										 WHERE EXISTS ( SELECT TOP 1 1
														FROM @V_tabledeleted AS a
														WHERE a.UserId1 = ZnodeOmsCookieMapping.UserId
													  )));

			DELETE FROM ZnodeOmsSavedCart
			where OmsCookieMappingId in (select OmsCookieMappingId from ZnodeOmsCookieMapping
										 WHERE EXISTS ( SELECT TOP 1 1
														FROM @V_tabledeleted AS a
														WHERE a.UserId1 = ZnodeOmsCookieMapping.UserId
													  ));

			DELETE FROM ZnodeOmsCookieMapping
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeOmsCookieMapping.UserId
                          );

			DELETE FROM ZnodeGiftCard            
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeGiftCard.UserId
                          );
		   ---------

             DELETE FROM ZnodeAccountUserOrderApproval
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeAccountUserOrderApproval.UserId
                          );
             DELETE FROM AspNetUserRoles
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.aspNetUserId = AspNetUserRoles.UserId
                          );
         
             DELETE FROM dbo.ZnodeAccountUserPermission
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeAccountUserPermission.UserId
                          );
			 
			 DELETE FROM ZnodeSalesRepCustomerUserPortal
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeSalesRepCustomerUserPortal.CustomerUserid
                          );

		     delete from ZnodeSalesRepCustomerUserPortal 
			 WHERE exists(select TOP 1 1  FROM ZnodeUserPortal ZUP where EXISTS ( SELECT TOP 1 1 FROM @V_tabledeleted AS a WHERE a.UserId1 = ZUP.UserId )
			              and ZnodeSalesRepCustomerUserPortal.UserPortalId = ZUP.UserPortalId );
			 
			 DELETE FROM ZnodeUserPortal
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeUserPortal.UserId
                          );
             DELETE FROM ZnodeAccountUserOrderApproval
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeAccountUserOrderApproval.UserId
                                  OR
                                  TBDL.UserId1 = ZnodeAccountUserOrderApproval.ApprovalUserId
                          );
			 DELETE FROM ZnodeOmsUsersReferralUrl 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsUsersReferralUrl.UserId
                           );
			 DELETE FROM ZnodeOmsReferralCommission 
			 WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsReferralCommission.UserId      
                          );
			DELETE FROM ZnodeUserWishList 
			WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeUserWishList.UserId      
                          );
			 DELETE FROM ZnodeDepartmentUser 
			 WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeDepartmentUser.UserId      
                          );
			 DELETE FROM ZnodeUserPromotion 
			 WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeUserPromotion.UserId      
                          );

			 DELETE FROM AspNetUserClaims 
			 WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = AspNetUserClaims.UserId      
                          ); 
			 DELETE FROM ZnodeNote 
			 WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeNote.UserId      
                          ); 

			 DELETE FROM ZnodeOmsQuotePersonalizeItem WHERE OmsQuoteLineItemId IN (SELECT OmsQuoteLineItemId FROM ZnodeOmsQuoteLineItem  WHERE OmsQuoteId IN (SELECT OmsQuoteId FROM ZnodeOmsQuote 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsQuote.UserId      
                          ) )) 
			 DELETE FROM ZnodeOmsQuoteLineItem  WHERE OmsQuoteId IN (SELECT OmsQuoteId FROM ZnodeOmsQuote 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsQuote.UserId      
                          ) )
			 DELETE FROM ZnodeOmsQuote 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsQuote.UserId      
                          ); 
			 DELETE FROM ZnodeAccountUserPermission 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeAccountUserPermission.UserId      
                          ); 
			  DELETE FROM ZnodePriceListUser 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodePriceListUser.UserId      
                          ); 
			  DELETE FROM ZnodeMediaFolderUser 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeMediaFolderUser.UserId      
                          ); 
			  DELETE FROM ZnodeAccountUserOrderApproval 
			  WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeAccountUserOrderApproval.UserId      
                          ); 
			 DELETE FROM ZnodeOmsTemplateLineItem WHERE OmsTemplateId IN (SELECT OmsTemplateId 
			 FROM ZnodeOmsTemplate WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsTemplate.UserId      
                          ) )

			 DELETE FROM dbo.ZnodeFormBuilderGlobalAttributeValueLocale   WHERE FormBuilderGlobalAttributeValueId IN 
			 (SELECT FormBuilderGlobalAttributeValueId  FROM dbo.ZnodeFormBuilderGlobalAttributeValue  WHERE FormBuilderSubmitId IN (SELECT FormBuilderSubmitId FROM dbo.ZnodeFormBuilderSubmit WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeFormBuilderSubmit.UserId      
                          ) ))

			  DELETE FROM dbo.ZnodeFormBuilderGlobalAttributeValue  WHERE FormBuilderSubmitId IN (SELECT FormBuilderSubmitId FROM dbo.ZnodeFormBuilderSubmit WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeFormBuilderSubmit.UserId      
                          ) )
			  DELETE FROM dbo.ZnodeFormBuilderSubmit WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeFormBuilderSubmit.UserId      
                          )  
			 
			 DELETE FROM ZnodeOmsTemplate  WHERE  EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS TBDL
                            WHERE TBDL.UserId1 = ZnodeOmsTemplate.UserId      
                          ) 
			 
			 
			DELETE FROM ZnodeCaseRequestHistory WHERE CaseRequestId IN (SELECT CaseRequestId  FROM ZnodeCaseRequest  WHERE EXISTS (SELECT TOP  1 1 FROM @V_tabledeleted AS TBDL WHERE TBDL.UserId1 = ZnodeCaseRequest.UserId))
			  DELETE FROM ZnodeCaseRequest  WHERE EXISTS (SELECT TOP  1 1 FROM @V_tabledeleted AS TBDL WHERE TBDL.UserId1 = ZnodeCaseRequest.UserId)
			  DECLARE @OrderId Transferid 
			 INSERT INTO @OrderId 
			 SELECT DISTINCT  a.OmsOrderId 
			 FROM ZnodeOMsOrder A 
			 INNER JOIN ZnodeOmsOrderDetails b ON(b.OmsOrderId = a.OmsOrderId)
			 WHERE EXISTS (SELECT TOP 1  1 FROM @V_tabledeleted t WHERE b.UserId = t.UserId1 )
			 INSERT INTO @StatusOut (Id ,Status) 
			EXEC  Znode_DeleteOrderById   @OmsOrderIds =@OrderId ,@Status = 0 
			UPDATE ZnodePublishCatalogLog	 SET Userid =2 
			WHERE UserId IN (SELECT UserId1 FROM @V_tabledeleted t)

			
			 DELETE FROM ZnodeCMSCustomerReview WHERE UserId IN (SELECT UserId1 FROM @V_tabledeleted t)
             DELETE FROM ZnodeBlogNewsCommentLocale where BlogNewsCommentId in (select BlogNewsCommentId from  ZnodeBlogNewsComment WHERE UserId IN
			  (SELECT UserId1 FROM @V_tabledeleted t))
			 DELETE FROM ZnodeBlogNewsComment WHERE UserId IN (SELECT UserId1 FROM @V_tabledeleted t)

			 DELETE FROM ZnodeUser
             OUTPUT deleted.UserId
                    INTO @V_table
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.UserId1 = ZnodeUser.UserId
                          );

             DELETE FROM AspNetUsers
             OUTPUT deleted.UserName
                    INTO @TBL_DeleteduserName
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @V_tabledeleted AS a
                            WHERE a.AspnetUserid = AspNetUsers.Id
                          );

             DELETE FROM AspNetZnodeUser
             WHERE EXISTS ( SELECT TOP 1 1
                            FROM @TBL_DeleteduserName AS TBUN
                            WHERE TBUN.id = AspNetZnodeUser.AspNetZnodeUserId
                          );
			 
			 
			  IF  @IsCallInternal = 0  
			  BEGIN 
             IF ( SELECT COUNT(1)
                  FROM @V_tabledeleted
                ) = ( SELECT COUNT(1)
                      FROM dbo.split ( @UserId , ','
                                     )
                    ) OR @UserId IS NULL 
                 BEGIN
                     SELECT 0 AS ID , CAST(1 AS BIT) AS Status;
                 END;
             ELSE
                 BEGIN
                     SELECT 0 AS ID , CAST(0 AS BIT) AS Status;
                 END;
		       END 
             SET @Status = 1;
             COMMIT TRAN A;
         END TRY
         BEGIN CATCH
		 SELECT ERROR_MESSAGE()
              DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_DeleteUserDetails @UserId = '+@UserId+',@Status='+CAST(@Status AS VARCHAR(200));
             SET @Status = 0;
             SELECT 0 AS ID,
                    CAST(0 AS BIT) AS Status;
			 ROLLBACK TRAN A;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_DeleteUserDetails',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
GO
if exists(select * from sys.procedures where name = 'Znode_InsertUpdate_SalesRepCustomerUserPortal')
	drop proc Znode_InsertUpdate_SalesRepCustomerUserPortal
go

CREATE PROCEDURE [dbo].[Znode_InsertUpdate_SalesRepCustomerUserPortal]
(
	@SalesRepUserId Int,
	@CustomerUserId Int,
	@CustomerPortalId int,
	@UserId int,
	@Status bit = 0 out 
)
as
begin

	set nocount on
	declare @GetDate datetime =dbo.Fn_GetDate()
	declare @SalesRepPortalId int = 0
	declare @UserPortalId int

	begin try
	begin tran
		if @SalesRepPortalId = 0 and isnull(@CustomerPortalId,0)=0 ----all portal
		begin
			select @UserPortalId = UserPortalId,@SalesRepPortalId = PortalId 
			from ZnodeUserPortal where UserId = @SalesRepUserId and PortalId is null

			if @SalesRepPortalId = 0 and not exists(select top 1 PortalId from ZnodeUserPortal where UserId = @SalesRepUserId  and PortalId is null )
			begin
				set @SalesRepPortalId = (select top 1 PortalId from ZnodeUserPortal where UserId = @SalesRepUserId )
				set @UserPortalId = (select top 1 UserPortalId from ZnodeUserPortal where UserId = @SalesRepUserId and PortalId = @SalesRepPortalId)
			end
		end
		else if @SalesRepPortalId = 0 and isnull(@CustomerPortalId,0) <> 0 
		begin
			select @UserPortalId=UserPortalId, @SalesRepPortalId=PortalId from ZnodeUserPortal where UserId = @SalesRepUserId and (PortalId = @CustomerPortalId or PortalId is null)
		end

		update SRCUP 
		set SalesRepUserId = @SalesRepUserId, UserPortalId = @UserPortalId
		from ZnodeSalesRepCustomerUserPortal SRCUP
		where CustomerUserid = @CustomerUserId and isnull(CustomerPortalId,0) = isnull(@CustomerPortalId,0)

		if isnull(@CustomerPortalId,0) = 0 and exists(select *  from ZnodeSalesRepCustomerUserPortal where CustomerUserid = @CustomerUserId and CustomerPortalId is not null)
		begin
			delete from ZnodeSalesRepCustomerUserPortal
			where CustomerUserid = @CustomerUserId and CustomerPortalId is not null
		end

		if isnull(@CustomerPortalId,0) <> 0 and exists(select *  from ZnodeSalesRepCustomerUserPortal where CustomerUserid = @CustomerUserId and CustomerPortalId is null)
		begin
			delete from ZnodeSalesRepCustomerUserPortal
			where CustomerUserid = @CustomerUserId and CustomerPortalId is null
		end

		insert into ZnodeSalesRepCustomerUserPortal (UserPortalId,SalesRepUserId,CustomerUserid,CustomerPortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
		select UP.UserPortalId, UP.UserId as SalesRepUserId,@CustomerUserId as CustomerUserid, case when @CustomerPortalId = 0 then null else @CustomerPortalId end as CustomerPortalId,
			   @UserId, @GetDate, @UserId, @GetDate
		from ZnodeUserPortal UP
		where UP.UserPortalId = @UserPortalId 
		and not exists(select * from ZnodeSalesRepCustomerUserPortal SRCUP where SRCUP.UserPortalId = UP.UserPortalId and SRCUP.CustomerUserid = @CustomerUserId and isnull(SRCUP.CustomerPortalId,0) = isnull(@CustomerPortalId,0))
	
	SET @Status = 1;
	SELECT 1 AS ID,@Status AS Status; 
	commit tran
	end try
	begin catch
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_InsertUpdate_SalesRepCustomerUserPortal @SalesRepUserId ='+CAST(@SalesRepUserId AS VARCHAR(50))+',@CustomerUserId = '+CAST(@CustomerUserId AS VARCHAR(50))+',@CustomerPortalId='+CAST(@CustomerPortalId AS VARCHAR(50))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,@Status AS Status;                     
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName    = 'Znode_InsertUpdate_SalesRepCustomerUserPortal',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage     = @ErrorMessage,
				@ErrorLine        = @ErrorLine,
				@ErrorCall        = @ErrorCall;
			rollback tran
	end catch

end
GO
if exists(select * from sys.procedures where name = 'Znode_InsertUpdate_UserPortal')
	drop proc Znode_InsertUpdate_UserPortal
go

CREATE PROCEDURE [dbo].[Znode_InsertUpdate_UserPortal]
(
	@UserId Int,
	@PortalId Varchar(2000),
	@Status bit = 0 out 
)
as
begin
	set nocount on
	declare @PortalId_Tbl table(PortalId int)
	declare @GetDate datetime =dbo.Fn_GetDate()

	begin try
	begin tran
		insert into @PortalId_Tbl(PortalId)
		select Item from dbo.Split(@PortalId,',')

		if @PortalId is null or @PortalId = '0'
		begin 

			insert into ZnodeUserPortal (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			select @UserId, case when PortalId = 0 then null else PortalId end , @UserId, @GetDate, @UserId, @GetDate
			from @PortalId_Tbl PT
			where not exists(select * from ZnodeUserPortal  where isnull(ZnodeUserPortal.PortalId,0) = isnull(PT.PortalId,0) and ZnodeUserPortal.UserId = @UserId )

			update ZnodeSalesRepCustomerUserPortal 
			set UserPortalId = (select top 1 UserPortalId from ZnodeUserPortal where UserId = @UserId and PortalId is null)
			where SalesRepUserId = @UserId
			and exists (select top 1 UserPortalId from ZnodeUserPortal where UserId = @UserId and PortalId is null)

			delete from ZnodeSalesRepCustomerUserPortal 
			where exists(select *  from ZnodeUserPortal 
					where ZnodeUserPortal.UserId = @UserId --and PortalId is not null
					and not exists(select * from @PortalId_Tbl PT where isnull(ZnodeUserPortal.PortalId,0) = isnull(PT.PortalId,0) )
					and ZnodeSalesRepCustomerUserPortal.UserPortalId = ZnodeUserPortal.UserPortalId)

			delete from ZnodeUserPortal 
			where ZnodeUserPortal.UserId = @UserId --and PortalId is not null
			and not exists(select * from @PortalId_Tbl PT where isnull(ZnodeUserPortal.PortalId,0) = isnull(PT.PortalId,0) )

		end
		else if isnull(@PortalId,'0') <> '0'
		begin
			
			insert into ZnodeUserPortal (UserId,PortalId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			select @UserId, PortalId, @UserId, @GetDate, @UserId, @GetDate
			from @PortalId_Tbl PT
			where not exists(select * from ZnodeUserPortal  where ZnodeUserPortal.PortalId = PT.PortalId and ZnodeUserPortal.UserId = @UserId )

			update SRCUP 
			set UserPortalId = ZUP.UserPortalId 
			from ZnodeSalesRepCustomerUserPortal SRCUP
			inner join ZnodeUserPortal ZUP on SRCUP.SalesRepUserId = ZUP.UserId and SRCUP.CustomerPortalId = ZUP.PortalId
			where SalesRepUserId = @UserId
			and exists (select * from @PortalId_Tbl PT where ZUP.PortalId = PT.PortalId )
			and isnull(ZUP.PortalId,0) <> 0 

			delete from ZnodeSalesRepCustomerUserPortal 
			where exists(select *  from ZnodeUserPortal 
					where ZnodeUserPortal.UserId = @UserId
					and not exists(select * from @PortalId_Tbl PT where isnull(ZnodeUserPortal.PortalId,0) = isnull(PT.PortalId,0) )
					and ZnodeSalesRepCustomerUserPortal.UserPortalId = ZnodeUserPortal.UserPortalId)

			delete from ZnodeUserPortal 
			where ZnodeUserPortal.UserId = @UserId
			and not exists(select * from @PortalId_Tbl PT where isnull(ZnodeUserPortal.PortalId,0) = isnull(PT.PortalId,0) )

		end

		SET @Status = 1;
		SELECT 1 AS ID,@Status AS Status;    
	commit tran
	end try
	begin catch
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_InsertUpdate_UserPortal @UserId='+CAST(@UserId AS VARCHAR(50))+',@PortalId='+CAST(@PortalId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,@Status AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName    = 'Znode_InsertUpdate_UserPortal',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage     = @ErrorMessage,
				@ErrorLine        = @ErrorLine,
				@ErrorCall        = @ErrorCall;
			rollback tran
	end catch
end
GO
update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>UserId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>display-none</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>FullName</name>      <headertext>Full Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>columnFullName</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>UserName</name>      <headertext>Username</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>columnUsername</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Email</name>      <headertext>Email ID</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Email Id</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PhoneNumber</name>      <headertext>Phone Number</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Phone Number</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>0</width>      <datatype>Date</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsLock</name>      <headertext>Is Lock</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Is Lock</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Manage|Disable|Delete</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Manage|Lock|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>UserId|UserId,IsLock|UserId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Delete</name>      <headertext>Delete</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>/Account/DeleteUser</deleteactionurl>      <deleteparamfield>UserId</deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>View</name>      <headertext>View</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>/Account/ManageUser</viewactionurl>      <viewparamfield>UserId</viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeAssociatedSalesRep'
go
if exists(select * from sys.procedures where name = 'Znode_GetSEODefaultSetting')
	drop proc Znode_GetSEODefaultSetting
go

CREATE PROCEDURE [dbo].[Znode_GetSEODefaultSetting]
( 
	@PortalId INT = 0,
	@SEOType Varchar(200) = '',
	@Id INT = 0
)
as 
Begin
	SET NOCOUNT ON;
	DECLARE @Title VARCHAR(MAX), @Description VARCHAR(MAX),@Keyword VARCHAR(MAX)
	DECLARE @SQL VARCHAR(MAX)
	 
	IF @SEOType = 'Product'
	BEGIN
			SELECT @Title = case when ProductTitle = '<NAME>' then 'ProductName' when ProductTitle = '<Product_Num>' then 'ProductCode'  when ProductTitle = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end,
				   @Description = case when ProductDescription = '<NAME>' then 'ProductName' when ProductDescription = '<Product_Num>' then 'ProductCode' when ProductDescription = '<SKU>' then 'SKU' when ProductDescription = '<Brand>' then 'Brand' end,
				   @Keyword = case when ProductKeyword = '<NAME>' then 'ProductName' when ProductKeyword = '<Product_Num>' then 'ProductCode' when ProductKeyword = '<SKU>' then 'SKU' when ProductKeyword = '<Brand>' then 'Brand' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT PimProductId, max(LongDescription) as LongDescription, max(SKU) as SKU, max(ShortDescription) as ShortDescription, 
			       max(ProductName) as ProductName,max(Brand) as Brand, max(ProductCode) as ProductCode
			into #ProductDetail
			FROM  
			(
				select PimProductId,	AttributeValue,	AttributeCode
				from View_LoadManageProductInternal 
				where PimProductId = @Id and AttributeCode in ('LongDescription', 'SKU', 'ShortDescription','ProductName','ProductCode')
				union all
				select a.PimProductId, d.AttributeDefaultValueCode as AttributeValue , 'Brand' as AttributeCode
				from ZnodePimAttributeValue a
				inner join ZnodePimProductAttributeDefaultValue b on a.PimAttributeValueId = b.PimAttributeValueId
				inner join ZnodePimAttributeDefaultValue d on b.PimAttributeDefaultValueId = d.PimAttributeDefaultValueId
				inner join ZnodePimAttribute c on a.PimAttributeId = c.PimAttributeId
				where c.AttributeCode = 'Brand' and a.PimProductId = @Id
			) AS SourceTable  
			PIVOT  
			(  
			max(AttributeValue)  
			FOR AttributeCode IN (LongDescription, SKU, ShortDescription, ProductName,Brand,ProductCode)  
			) AS PivotTable
			group by PimProductId 

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ProductDetail'
				print @SQL
				exec (@SQL)
			end

		end
		IF @SEOType = 'Category'
		BEGIN
			
			SELECT @Title = case when CategoryTitle = '<NAME>' then 'CategoryName' when CategoryTitle = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryTitle = '<SKU>' then 'CategoryCode' end,
				   @Description = case when CategoryDescription = '<NAME>' then 'CategoryName' when CategoryDescription = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryDescription = '<SKU>' then 'CategoryCode' end,
				   @Keyword = case when CategoryKeyword = '<NAME>' then 'CategoryName' when CategoryKeyword = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryKeyword = '<SKU>' then 'CategoryCode' end
		    FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT ZPCAV.PimCategoryId, ZPCAVL.CategoryValue as CategoryCode,  ZPCAVL1.CategoryValue as CategoryName
			INTO #CategoryDetail
			FROM ZnodePimCategoryAttributeValue ZPCAV
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL ON ZPCAV.PimCategoryAttributeValueId = ZPCAVL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCAV.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePimCategoryAttributeValue ZPCAV1 ON ZPCAV.PimCategoryId = ZPCAV1.PimCategoryId
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL1 ON ZPCAV1.PimCategoryAttributeValueId = ZPCAVL1.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA1 ON ZPCAV1.PimAttributeId = ZPA1.PimAttributeId
			WHERE ZPA.AttributeCode = 'CategoryCode' AND ZPA1.AttributeCode = 'CategoryName'
			and ZPCAV.PimCategoryId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #CategoryDetail'
				
				exec (@SQL)
			end

		end

		IF @SEOType = 'Content_Page'
		BEGIN
			
			SELECT @Title = case when ContentTitle = '<Name>' then 'PageName' when ContentTitle = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentTitle = '<SKU>' then 'PageName' end,
					@Description = case when ContentDescription = '<Name>' then 'PageName' when ContentDescription = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentDescription = '<SKU>' then 'PageName' end,
					@Keyword = case when ContentKeyword = '<Name>' then 'PageName' when ContentKeyword = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentKeyword = '<SKU>' then 'PageName' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT CMSContentPagesId, PageName into #ContentPageDetail from ZnodeCMSContentPages where CMSContentPagesId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin

				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ContentPageDetail'

				exec (@SQL)
			end


		end

	

end
GO
if exists(select * from sys.procedures where name = 'Znode_GetSEODefaultSetting')
	drop proc Znode_GetSEODefaultSetting
go

CREATE PROCEDURE [dbo].[Znode_GetSEODefaultSetting]
( 
	@PortalId INT = 0,
	@SEOType Varchar(200) = '',
	@Id INT = 0
)
as 
Begin
	SET NOCOUNT ON;
	DECLARE @Title VARCHAR(MAX), @Description VARCHAR(MAX),@Keyword VARCHAR(MAX)
	DECLARE @SQL VARCHAR(MAX)
	 
	IF @SEOType = 'Product'
	BEGIN
			SELECT @Title = case when ProductTitle = '<NAME>' then 'ProductName' when ProductTitle = '<Product_Num>' then 'ProductCode'  when ProductTitle = '<SKU>' then 'SKU' when ProductTitle = '<Brand>' then 'Brand' end,
				   @Description = case when ProductDescription = '<NAME>' then 'ProductName' when ProductDescription = '<Product_Num>' then 'ProductCode' when ProductDescription = '<SKU>' then 'SKU' when ProductDescription = '<Brand>' then 'Brand' end,
				   @Keyword = case when ProductKeyword = '<NAME>' then 'ProductName' when ProductKeyword = '<Product_Num>' then 'ProductCode' when ProductKeyword = '<SKU>' then 'SKU' when ProductKeyword = '<Brand>' then 'Brand' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT PimProductId, max(LongDescription) as LongDescription, max(SKU) as SKU, max(ShortDescription) as ShortDescription, 
			       max(ProductName) as ProductName,max(Brand) as Brand, max(ProductCode) as ProductCode
			into #ProductDetail
			FROM  
			(
				select PimProductId,	AttributeValue,	AttributeCode
				from View_LoadManageProductInternal 
				where PimProductId = @Id and AttributeCode in ('LongDescription', 'SKU', 'ShortDescription','ProductName','ProductCode')
				union all
				select a.PimProductId, d.AttributeDefaultValueCode as AttributeValue , 'Brand' as AttributeCode
				from ZnodePimAttributeValue a
				inner join ZnodePimProductAttributeDefaultValue b on a.PimAttributeValueId = b.PimAttributeValueId
				inner join ZnodePimAttributeDefaultValue d on b.PimAttributeDefaultValueId = d.PimAttributeDefaultValueId
				inner join ZnodePimAttribute c on a.PimAttributeId = c.PimAttributeId
				where c.AttributeCode = 'Brand' and a.PimProductId = @Id
			) AS SourceTable  
			PIVOT  
			(  
			max(AttributeValue)  
			FOR AttributeCode IN (LongDescription, SKU, ShortDescription, ProductName,Brand,ProductCode)  
			) AS PivotTable
			group by PimProductId 

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ProductDetail'
				print @SQL
				exec (@SQL)
			end

		end
		IF @SEOType = 'Category'
		BEGIN
			
			SELECT @Title = case when CategoryTitle = '<NAME>' then 'CategoryName' when CategoryTitle = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryTitle = '<SKU>' then 'CategoryCode' end,
				   @Description = case when CategoryDescription = '<NAME>' then 'CategoryName' when CategoryDescription = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryDescription = '<SKU>' then 'CategoryCode' end,
				   @Keyword = case when CategoryKeyword = '<NAME>' then 'CategoryName' when CategoryKeyword = '<Product_Num>' then 'cast(PimCategoryId as varchar(10))' when CategoryKeyword = '<SKU>' then 'CategoryCode' end
		    FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT ZPCAV.PimCategoryId, ZPCAVL.CategoryValue as CategoryCode,  ZPCAVL1.CategoryValue as CategoryName
			INTO #CategoryDetail
			FROM ZnodePimCategoryAttributeValue ZPCAV
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL ON ZPCAV.PimCategoryAttributeValueId = ZPCAVL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCAV.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePimCategoryAttributeValue ZPCAV1 ON ZPCAV.PimCategoryId = ZPCAV1.PimCategoryId
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAVL1 ON ZPCAV1.PimCategoryAttributeValueId = ZPCAVL1.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA1 ON ZPCAV1.PimAttributeId = ZPA1.PimAttributeId
			WHERE ZPA.AttributeCode = 'CategoryCode' AND ZPA1.AttributeCode = 'CategoryName'
			and ZPCAV.PimCategoryId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin
				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #CategoryDetail'
				
				exec (@SQL)
			end

		end

		IF @SEOType = 'Content_Page'
		BEGIN
			
			SELECT @Title = case when ContentTitle = '<Name>' then 'PageName' when ContentTitle = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentTitle = '<SKU>' then 'PageName' end,
					@Description = case when ContentDescription = '<Name>' then 'PageName' when ContentDescription = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentDescription = '<SKU>' then 'PageName' end,
					@Keyword = case when ContentKeyword = '<Name>' then 'PageName' when ContentKeyword = '<Product_Num>' then 'cast(CMSContentPagesId as varchar(10))' when ContentKeyword = '<SKU>' then 'PageName' end
			FROM ZnodeCMSPortalSEOSetting WHERE PortalId = @PortalId

			SELECT CMSContentPagesId, PageName into #ContentPageDetail from ZnodeCMSContentPages where CMSContentPagesId = @Id

			if (@Title <> '' or @Description <> '' or @Keyword <> '')
			begin

				SET @SQL = '
				select '+CASE WHEN isnull(@Title,'') = '' THEN '''''' ELSE @Title END  +' as SEOTitle,'+ 
						 CASE WHEN isnull(@Description,'') = '' THEN '''''' ELSE @Description END+ ' as SEODescription,'+ 
						 CASE WHEN isnull(@Keyword,'') = '' THEN '''''' ELSE @Keyword END+' as SEOKeywords   
				from #ContentPageDetail'

				exec (@SQL)
			end


		end

	

end
GO

update ZnodeApplicationSetting set Setting = '<?xml version="1.0" encoding="utf-16"?>  <columns>    <column>      <id>1</id>      <name>UserId</name>      <headertext>Checkbox</headertext>      <width>40</width>      <datatype>Int32</datatype>      <columntype>Int32</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>y</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>display-none</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>2</id>      <name>FullName</name>      <headertext>Full Name</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>columnFullName</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>3</id>      <name>UserName</name>      <headertext>Username</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>columnUsername</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>4</id>      <name>Email</name>      <headertext>Email ID</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>y</isvisible>      <mustshow>y</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>y</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Email Id</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>5</id>      <name>PhoneNumber</name>      <headertext>Phone Number</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Phone Number</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>6</id>      <name>CreatedDate</name>      <headertext>Created Date</headertext>      <width>0</width>      <datatype>Date</datatype>      <columntype>String</columntype>      <allowsorting>true</allowsorting>      <allowpaging>true</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>      </displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>7</id>      <name>IsLock</name>      <headertext>Is Lock</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>UserId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>UserId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Is Lock</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>8</id>      <name>Manage</name>      <headertext>Action</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>true</allowpaging>      <format>Manage|Disable|Delete</format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>n</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>y</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>AccountId</islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>AccountId</checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Manage|Lock|Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>UserId|UserId,IsLock|UserId</manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>y</isadvancesearch>      <Class>grid-action</Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>9</id>      <name>Delete</name>      <headertext>Delete</headertext>      <width>40</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>Delete</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>/Account/DeleteUser</deleteactionurl>      <deleteparamfield>UserId</deleteparamfield>      <viewactionurl>      </viewactionurl>      <viewparamfield>      </viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>    <column>      <id>10</id>      <name>View</name>      <headertext>View</headertext>      <width>0</width>      <datatype>String</datatype>      <columntype>String</columntype>      <allowsorting>false</allowsorting>      <allowpaging>false</allowpaging>      <format>      </format>      <isvisible>n</isvisible>      <mustshow>n</mustshow>      <musthide>y</musthide>      <maxlength>0</maxlength>      <isallowsearch>n</isallowsearch>      <isconditional>n</isconditional>      <isallowlink>n</isallowlink>      <islinkactionurl>      </islinkactionurl>      <islinkparamfield>      </islinkparamfield>      <ischeckbox>n</ischeckbox>      <checkboxparamfield>      </checkboxparamfield>      <iscontrol>n</iscontrol>      <controltype>      </controltype>      <controlparamfield>      </controlparamfield>      <displaytext>View</displaytext>      <editactionurl>      </editactionurl>      <editparamfield>      </editparamfield>      <deleteactionurl>      </deleteactionurl>      <deleteparamfield>      </deleteparamfield>      <viewactionurl>/Account/ManageUser</viewactionurl>      <viewparamfield>UserId</viewparamfield>      <imageactionurl>      </imageactionurl>      <imageparamfield>      </imageparamfield>      <manageactionurl>      </manageactionurl>      <manageparamfield>      </manageparamfield>      <copyactionurl>      </copyactionurl>      <copyparamfield>      </copyparamfield>      <xaxis>n</xaxis>      <yaxis>n</yaxis>      <isadvancesearch>n</isadvancesearch>      <Class>      </Class>      <SearchControlType>--Select--</SearchControlType>      <SearchControlParameters>      </SearchControlParameters>      <DbParamField>      </DbParamField>      <useMode>DataBase</useMode>      <IsGraph>n</IsGraph>      <allowdetailview>n</allowdetailview>    </column>  </columns>'
where ItemName = 'ZnodeAssociatedSalesRep'
go

if exists(select * from sys.procedures where name = 'Znode_GetPublishSingleCategory')
	drop proc Znode_GetPublishSingleCategory
go
CREATE PROCEDURE [dbo].[Znode_GetPublishSingleCategory]
(   @PimCategoryId    INT, 
    @UserId           INT,
    @Status           int = 0 OUT,
	@IsDebug          BIT = 0
	,@LocaleIds		  TransferId READONLY,
	@PimCatalogId     INT = 0 )
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

       EXEC [Znode_GetPublishSingleCategory @PublishCatalogId = 5,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 
       Rollback Transaction 
	*/
     BEGIN
         BEGIN TRAN GetPublishCategory;
         BEGIN TRY
             SET NOCOUNT ON;
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

			 IF NOT EXISTS (Select TOP 1 1 from @TBL_PublishCatalogId) OR NOT EXISTS (select TOP 1 1  from ZnodePimCatalogCategory where PimCategoryId = @PimCategoryId  )
			 Begin
				SET @Status = 1  -- Category not associated or catalog not publish
				ROLLBACK TRAN GetPublishCategory;
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
             DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
              CategoryXml       XML,
              LocaleId          INT
			 
             );
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
            SELECT LocaleId,IsDefault FROM ZnodeLocale MT WHERE IsActive = @IsActive
			AND (EXISTS (SELECT TOP 1 1  FROM @LocaleIds RT WHERE RT.Id = MT.LocaleId )
			OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleIds )) ;

             INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId,
			 PublishCatalogId,PimCatalogId,VersionId)
			 --select @PimCategoryId, NULL , NULL , NULL , NULL ,NULL , NULL ,NULL 
			 SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId,
			 PublishCatalogId,PCI.PimCatalogId,VersionId
			 FROM ZnodePimCategoryHierarchy AS ZPCH 
			 LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
			 Inner join @TBL_PublishCatalogId PCI on ZPCH.PimCatalogId = PCI.PimCatalogId 
			 WHERE ZPCH.PimCategoryId = @PimCategoryId ; 

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
			     	    
			 -- here update the publish parent category id
            UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] 
			FROM ZnodePublishCategory ZPC
            INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			WHERE ZPC.PublishCatalogId = TBPC.PublishCatalogId 
			AND TBPC.PublishCatalogId  in (Select PublishCatalogId from @TBL_PublishCatalogId)
			AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL AND 
			ZPC.PimCategoryId = @PimCategoryId  ;

			UPDATE a
			SET  a.PublishParentCategoryId = b.PublishCategoryId
			FROM ZnodePublishCategory a 
			INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
			WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
			AND a.PublishCatalogId = b.PublishCatalogId AND b.PublishCatalogId in (Select PublishCatalogId from @TBL_PublishCatalogId)
			AND a.PimCategoryId = @PimCategoryId 
			 --UPDATE ZPC SET [PimParentCategoryId] = TBPC.[PimCategoryId] 
			 --FROM ZnodePublishCategory ZPC
			 --INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 --WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 --AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL ;

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

					-- SELECT * FROM @TBL_AttributeValue WHERE PimCategoryId = 281

					--select * from @TBL_AttributeValue



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
                     AS (SELECT TBA.PimCategoryId,TBA.PimAttributeId,[dbo].[FN_GetThumbnailMediaPathPublish](SUBSTRING((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
					    (SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH('')), 2, 4000)) CategoryValue
						FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId))
                         
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
                     AS (SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
					 FROM ZnodeProfileCatalog ZPC 
					 INNER JOIN ZnodeProfileCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
                        AND ZPRCC.ProfileCatalogId = ZPC.ProfileCatalogId) 
						WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
                      
					   FROM ZnodePimCategoryHierarchy ZPCC 
					   WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
					   WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId in (Select PimCatalogId from @TBL_PublishCatalogId)
					   AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId))
                          
				     UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds FROM @TBL_PimCategoryIds TBPC 
					 LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
                     
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId))


					 UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )
					 
					 --select * from @TBL_PimCategoryIds

					 --select * from @TBL_AttributeValue
					-- SELECT * FROM @TBL_AttributeValue WHERE pimCategoryId = 369


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

                     ;WITH Cte_CategoryXML
                     AS (SELECT PublishcategoryId,PimCategoryId,(SELECT TY.PublishCatalogLogId,TBPC.PublishCategoryId ZnodeCategoryId,TBC.PublishCatalogId ZnodeCatalogId
																		,THR.PublishParentCategoryId TempZnodeParentCategoryIds,ZPC.CatalogName ,
																		 ISNULL(DisplayOrder, '0') DisplayOrder,@LocaleId LocaleId,ActivationDate 
																		 ,ExpirationDate,TBC.IsActive,ISNULL(CategoryName, '') Name,ProfileId TempProfileIds,ISNULL(PublishProductId, '') TempProductIds,ISNULL(CategoryCode,'') as CategoryCode
																		 ,ISNULL(TBPC.RowIndex,1) CategoryIndex
                        FROM @TBL_PublishPimCategoryIds TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId in  (Select PublishCatalogId from @TBL_PublishCatalogId))
						INNER JOIN ZnodePublishCAtegory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId in  (Select PublishCatalogId from @TBL_PublishCatalogId) )
						LEFT JOIN @UpdateCategoryLog TY ON ( TY.PublishCatalogId IN (Select PublishCatalogId from @TBL_PublishCatalogId) AND TY.localeId = @LocaleId  )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) WHERE TBPC.PublishCategoryId = TBPCO.PublishCategoryId 
						FOR XML PATH('')) CategoryXml 
						FROM @TBL_PublishPimCategoryIds TBPCO),


                     Cte_CategoryAttributeXml
                     AS (SELECT CTCX.PublishCategoryId,'<CategoryEntity>'+ISNULL(CategoryXml, '')+
					  ISNULL((SELECT(SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
                        ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,TBAV.CategoryValue AttributeValues,TBA.AttributeTypeName FROM @TBL_AttributeValue TBAV
                        INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
                        WHERE CTCX.PimCategoryId = TBAV.PimCategoryId AND TBAO.PimAttributeId = TBA.PimAttributeId FOR XML PATH('AttributeEntity'), TYPE) FROM @TBL_AttributeIds TBAO
                        FOR XML PATH('Attributes')), '')+'</CategoryEntity>' CategoryXMl FROM Cte_CategoryXML CTCX)

						
                     INSERT INTO @TBL_CategoryXml(PublishCategoryId,CategoryXml,LocaleId)
                     SELECT PublishCategoryId,CategoryXml,@LocaleId LocaleId FROM Cte_CategoryAttributeXml;

                  
				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;
	
			Select PublishCategoryId ,VersionId	, PimCatalogId	, LocaleId,PublishCatalogId
			into #OutPublish from @TBL_PublishCatalogId CLI CROSS JOIN @TBL_CategoryXml  
			--group by PimCatalogId,VersionId,PublishCategoryId

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
				inner join ZnodePimCatalogCategory b on  a.PimCategoryId = b.PimCategoryId and c.PimCatalogId = b.PimCatalogId
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
			from ZnodePimCatalogCategory a
			inner join ZnodePublishCatalog b on a.PimCatalogId = b.PimCatalogId
			inner join ZnodePublishCatalogLog c on b.PublishCatalogId = c.PublishCatalogId
			where a.PimCategoryId = @PimcategoryId
			group by C.PublishCatalogId

		   UPDATE ZPCC 
				SET PublishCategoryId = (select count(distinct a.PimCategoryId)
				from ZnodePublishCategory a 
				inner join ZnodePublishCatalog c on a.PublishCatalogId = c.PublishCatalogId
				inner join ZnodePimCatalogCategory b on  a.PimCategoryId = b.PimCategoryId and c.PimCatalogId = b.PimCatalogId
				where a.PublishCatalogId = ZPCC.PublishCatalogId)
				,ModifiedDate = @GetDate
			FROM ZnodePublishCatalogLog ZPCC
			WHERE exists(select * from #temp_CatalogCategory CC where ZPCC.PublishCatalogLogId = CC.PublishCatalogLogId )
		end

				SET @Counter  = @Counter  + 1  
			END
           	Select distinct 
			SUBSTRING(( SELECT Distinct ',' + CAST(PublishCategoryId AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) PublishCategoryId,
			SUBSTRING(( SELECT Distinct ',' + CAST(VersionId	 AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) VersionId,	
			SUBSTRING(( SELECT Distinct ',' + CAST(PublishCatalogId	 AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) PimCatalogId,
			SUBSTRING(( SELECT Distinct ',' + CAST(LocaleId AS VARCHAR(50)) FROM #OutPublish CLO
			FOR XML PATH('')), 2, 4000) LocaleId
			from #OutPublish
			--group by PimCatalogId,VersionId,PublishCategoryId

			--Select PublishCategoryId ,VersionId	, PimCatalogId, LocaleId  from #OutPublish 

			Select CategoryXml from @TBL_CategoryXml 

			SELECT CategoryCode FROM @TBL_PimCategoryIds
			GROUP BY CategoryCode

			UPDATE ZnodePimCategory	SET IsCategoryPublish = 1 WHERE PimCategoryId = @PimCategoryId 

			Commit TRAN GetPublishCategory;
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishSingleCategory @PimCategoryId= '+CAST(@PimCategoryId AS VARCHAR(50))+',@PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0 -- Publish Falies 
             ROLLBACK TRAN GetPublishCategory;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishSingleCategory',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 go
if not exists(select * from sys.tables where name = 'ZnodePortalRecommendationSetting')
begin
	 CREATE TABLE [dbo].[ZnodePortalRecommendationSetting] (
    [PortalRecommendationSettingId] INT      IDENTITY (1, 1) NOT NULL,
    [PortalId]                      INT      NOT NULL,
    [IsHomeRecommendation]          BIT      CONSTRAINT [DF_ZnodePortalRecommendationSetting_IsHomeRecommendation] DEFAULT ((0)) NOT NULL,
    [IsPDPRecommendation]           BIT      CONSTRAINT [DF_ZnodePortalRecommendationSetting_IsPDPRecommendation] DEFAULT ((0)) NOT NULL,
    [IsCartRecommendation]          BIT      CONSTRAINT [DF_ZnodePortalRecommendationSetting_IsCartRecommendation] DEFAULT ((0)) NOT NULL,
    [CreatedBy]                     INT      NOT NULL,
    [CreatedDate]                   DATETIME NOT NULL,
    [ModifiedBy]                    INT      NOT NULL,
    [ModifiedDate]                  DATETIME NOT NULL,
    CONSTRAINT [PK_ZnodePortalRecommendationSetting] PRIMARY KEY CLUSTERED ([PortalRecommendationSettingId] ASC),
    CONSTRAINT [FK_ZnodePortalRecommendationSetting_ZnodePortal] FOREIGN KEY ([PortalId]) REFERENCES [dbo].[ZnodePortal] ([PortalId])
);

end
go

INSERT  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT NULL ,'Recommendation','GetRecommendationSetting',0,2,Getdate(),2,Getdate() WHERE NOT EXISTS
(SELECT * FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName = 'GetRecommendationSetting')
UNION ALL 
SELECT NULL ,'Recommendation','SaveRecommendationSetting',0,2,Getdate(),2,Getdate() WHERE NOT EXISTS
(SELECT * FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName = 'SaveRecommendationSetting')

INSERT INTO ZnodeActionMenu ( MenuId,	ActionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
SELECT 
(SELECT TOP 1 MenuId from ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience')	
,(SELECT TOP 1 ActionId FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName= 'GetRecommendationSetting') ,2,Getdate(),2,Getdate()
WHERE NOT EXISTS (SELECT * FROM ZnodeActionMenu WHERE MenuId = 
(SELECT TOP 1 MenuId FROM ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience') and ActionId = 
(SELECT TOP 1 ActionId from ZnodeActions where ControllerName = 'Recommendation' and ActionName= 'GetRecommendationSetting'))
UNION ALL 
SELECT 
(SELECT TOP 1 MenuId from ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience')	
,(SELECT TOP 1 ActionId FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName= 'SaveRecommendationSetting') ,2,Getdate(),2,Getdate()
WHERE NOT EXISTS (SELECT * FROM ZnodeActionMenu WHERE MenuId = 
(SELECT TOP 1 MenuId FROM ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience') and ActionId = 
(SELECT TOP 1 ActionId from ZnodeActions where ControllerName = 'Recommendation' and ActionName= 'SaveRecommendationSetting'))




insert into ZnodeMenuActionsPermission ( MenuId,	ActionId, AccessPermissionId,	CreatedBy ,CreatedDate,	ModifiedBy, ModifiedDate )
select 
(SELECT TOP 1 MenuId from ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience')
,(SELECT TOP 1 ActionId FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName= 'GetRecommendationSetting')	
,1,2,Getdate(),2,Getdate() where not exists 
(SELECT * FROM ZnodeMenuActionsPermission where MenuId = 
(SELECT TOP 1 MenuId from ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience') and ActionId = 
(SELECT TOP 1 ActionId FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName= 'GetRecommendationSetting'))
UNION ALL 
select 
(SELECT TOP 1 MenuId from ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience')
,(SELECT TOP 1 ActionId FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName= 'SaveRecommendationSetting')	
,1,2,Getdate(),2,Getdate() where not exists 
(SELECT * FROM ZnodeMenuActionsPermission where MenuId = 
(SELECT TOP 1 MenuId from ZnodeMenu WHERE MenuName = 'Store Experience' AND ControllerName = 'StoreExperience') and ActionId = 
(SELECT TOP 1 ActionId FROM ZnodeActions WHERE ControllerName = 'Recommendation' and ActionName= 'SaveRecommendationSetting'))

GO
INSERT INTO ZnodeCMSMessageKey(MessageKey,MessageTag,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'RecommendedProductsTitle',NULL,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSMessageKey WHERE MessageKey='RecommendedProductsTitle')

INSERT INTO ZnodeCMSMessage(LocaleId,Message,IsPublished,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PublishStateId)
SELECT 1,'<p>Recommended Products</p>',NULL,2,GETDATE(),2,GETDATE(),3
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSMessage WHERE Message='<p>Recommended Products</p>')

INSERT INTO ZnodeCMSPortalMessage(PortalId,CMSMessageKeyId,CMSMessageId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT NULL ,(SELECT TOP 1 CMSMessageKeyId FROM ZnodeCMSMessageKey WHERE MessageKey='RecommendedProductsTitle'),
(SELECT TOP 1 CMSMessageId  FROM ZnodeCMSMessage WHERE Message='<p>Recommended Products</p>'),2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT * FROM ZnodeCMSPortalMessage WHERE CMSMessageKeyId IN (SELECT CMSMessageKeyId FROM ZnodeCMSMessageKey WHERE MessageKey='RecommendedProductsTitle'))
AND NOT EXISTS 
(SELECT * FROM ZnodeCMSPortalMessage WHERE CMSMessageId IN (SELECT CMSMessageId  FROM ZnodeCMSMessage WHERE Message='<p>Recommended Products</p>') and PortalId is null)
go

Insert  INTO ZnodeCMSWidgets (Code,DisplayName,IsConfigurable,FileName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'HomeRecommendations' ,'RecommendedProducts',0,'Product_List.png',2,Getdate(),2,Getdate() where not exists
(SELECT * FROM ZnodeCMSWidgets where Code = 'HomeRecommendations')
UNION ALL 
SELECT 'PDPRecommendations' ,'RecommendedProducts',0,'Product_List.png',2,Getdate(),2,Getdate() where not exists
(SELECT * FROM ZnodeCMSWidgets where Code = 'PDPRecommendations')
UNION ALL
SELECT 'CartRecommendations' ,'RecommendedProducts',0,'Product_List.png',2,Getdate(),2,Getdate() where not exists
(SELECT * FROM ZnodeCMSWidgets where Code = 'CartRecommendations')
go

if exists(select * from sys.procedures where name  = 'Znode_CopyPortal')
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
 ZnodePriceListPortal ,ZnodeActivityLog,ZnodeShippingPortal,ZnodeGiftCard ,ZnodeCMSContentPages,ZnodePortalDisplaySetting ,ZnodeCMSPortalMessage,    
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
   --PortalId - this column value is auto-generated    
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
   --PortalCatalogId - this column value is auto-generated    
   PortalId, PublishCatalogId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, PublishCatalogId, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalCatalog    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalProfile(    
   --PortalProfileID - this column value is auto-generated    
   PortalId, ProfileId, IsDefaultAnonymousProfile, IsDefaultRegistedProfile, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, ProfileId, IsDefaultAnonymousProfile, IsDefaultRegistedProfile, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalProfile    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalUnit(    
   --PortalUnitId - this column value is auto-generated    
   PortalId, CurrencyId,CultureId, WeightUnit, DimensionUnit,CurrencySuffix, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, CurrencyId,CultureId, WeightUnit, DimensionUnit,CurrencySuffix, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalUnit    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalCountry(    
   --PortalCountryId - this column value is auto-generated    
   PortalId, CountryCode, IsDefault, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, CountryCode, IsDefault, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalCountry    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodeShippingPortal(    
   --ShippingPortalId - this column value is auto-generated    
   PortalId, ShippingOriginAddress1, ShippingOriginAddress2, ShippingOriginCity, ShippingOriginStateCode, ShippingOriginZipCode, ShippingOriginCountryCode, ShippingOriginPhone, FedExAccountNumber, FedExLTLAccountNumber, FedExMeterNumber, FedExProductionKey, FedExSecurityCode, FedExDropoffType, FedExPackagingType, FedExUseDiscountRate, FedExAddInsurance, UPSUserName, UPSPassword, UPSKey, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, ShippingOriginAddress1, ShippingOriginAddress2, ShippingOriginCity, ShippingOriginStateCode, ShippingOriginZipCode, ShippingOriginCountryCode, ShippingOriginPhone, FedExAccountNumber, FedExLTLAccountNumber, FedExMeterNumber, FedExProductionKey, FedExSecurityCode, FedExDropoffType, FedExPackagingType, FedExUseDiscountRate, FedExAddInsurance, UPSUserName, UPSPassword, UPSKey, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodeShippingPortal    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalLocale(    
   --PortalLocaleId - this column value is auto-generated    
   PortalId, LocaleId, IsDefault, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, LocaleId, IsDefault, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalLocale    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalSmtpSetting(    
   --PortalSmtpSettingId - this column value is auto-generated    
   PortalId, ServerName, UserName, Password, Port, IsEnableSsl, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,DisableAllEmails )    
       SELECT @NewPortalId, ServerName, UserName, Password, Port, IsEnableSsl, @UserId, @GetDate, @UserId, @GetDate,DisableAllEmails    
 FROM ZnodePortalSmtpSetting    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalDisplaySetting(    
   --PortalDisplaySettingsId - this column value is auto-generated    
   PortalId, MediaId, MaxDisplayItems, MaxSmallThumbnailWidth, MaxSmallWidth, MaxMediumWidth, MaxThumbnailWidth, MaxLargeWidth, MaxCrossSellWidth, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate )    
       SELECT @NewPortalId, MediaId, MaxDisplayItems, MaxSmallThumbnailWidth, MaxSmallWidth, MaxMediumWidth, MaxThumbnailWidth, MaxLargeWidth, MaxCrossSellWidth, @UserId, @GetDate, @UserId, @GetDate    
       FROM ZnodePortalDisplaySetting    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodeCMSPortalTheme(    
   --CMSPortalThemeId - this column value is auto-generated    
   PortalId, CMSThemeId, CMSThemeCSSId, MediaId, WebsiteTitle, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,WebsiteDescription )    
       SELECT @NewPortalId, CMSThemeId, CMSThemeCSSId, MediaId, WebsiteTitle, @UserId, @GetDate, @UserId, @GetDate ,WebsiteDescription   
       FROM ZnodeCMSPortalTheme    
       WHERE PortalId = @PortalId;    
   INSERT INTO dbo.ZnodePortalFeatureMapper(    
   --PortalFeatureMapperId - this column value is auto-generated    
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

if exists(select * from sys.procedures where name  = 'Znode_DeletePortalByPortalId')
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
if exists(select * from sys.procedures where name = 'Znode_PurgeData')
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
		DELETE FROM ZnodePortalDisplaySetting WHERE EXISTS ( SELECT TOP 1 1 FROM @TBL_PortalIds AS TBP WHERE TBP.PortalId = ZnodePortalDisplaySetting.PortalId);
		
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

BEGIN
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledWarning' 
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledInfo' 
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledDebug' 
UPDATE ZnodeGlobalSetting set FeatureValues='True',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledError' 
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledAll' 
UPDATE ZnodeGlobalSetting set FeatureValues='False',ModifiedDate=GETDATE(),ModifiedBy=2 where FeatureName='IsLoggingLevelsEnabledFatal' 
END

GO

INSERT INTO znodeglobalsetting (FeatureName,FeatureValues,FeatureSubValues,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'ClearLoadBalancerAPICacheIPs','False',NULL,2, GETDATE(),2 , GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM znodeglobalsetting WHERE FeatureName = 'ClearLoadBalancerAPICacheIPs')
GO


INSERT INTO znodeglobalsetting (FeatureName,FeatureValues,FeatureSubValues,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'ClearLoadBalancerWebStoreCacheIPs','False',NULL,2, GETDATE(),2 , GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM znodeglobalsetting WHERE FeatureName = 'ClearLoadBalancerWebStoreCacheIPs')
GO

INSERT INTO znodeglobalsetting (FeatureName,FeatureValues,FeatureSubValues,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'DefaultProductLimitForRecommendations','12',NULL,2, GETDATE(),2 , GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM znodeglobalsetting WHERE FeatureName = 'DefaultProductLimitForRecommendations')
GO


INSERT INTO ZnodeCMSMessageKey(MessageKey,MessageTag,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'RecommendedProductsTitle',NULL,2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSMessageKey WHERE MessageKey='RecommendedProductsTitle')

INSERT INTO ZnodeCMSMessage(LocaleId,Message,IsPublished,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PublishStateId)
SELECT 1,'<p>Recommended Products</p>',NULL,2,GETDATE(),2,GETDATE(),3
WHERE NOT EXISTS (SELECT TOP 1 1 FROM ZnodeCMSMessage WHERE Message='<p>Recommended Products</p>')

INSERT INTO ZnodeCMSPortalMessage(PortalId,CMSMessageKeyId,CMSMessageId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT NULL ,(SELECT TOP 1 CMSMessageKeyId FROM ZnodeCMSMessageKey WHERE MessageKey='RecommendedProductsTitle'),
(SELECT TOP 1 CMSMessageId  FROM ZnodeCMSMessage WHERE Message='<p>Recommended Products</p>'),2,GETDATE(),2,GETDATE()
WHERE NOT EXISTS (SELECT * FROM ZnodeCMSPortalMessage WHERE CMSMessageKeyId IN (SELECT CMSMessageKeyId FROM ZnodeCMSMessageKey WHERE MessageKey='RecommendedProductsTitle'))
AND NOT EXISTS 
(SELECT * FROM ZnodeCMSPortalMessage WHERE CMSMessageId IN (SELECT CMSMessageId  FROM ZnodeCMSMessage WHERE Message='<p>Recommended Products</p>') and PortalId is null)
go

if not exists(select * from sys.tables where name = 'ZnodeMongoIndex')
begin
CREATE TABLE [dbo].[ZnodeMongoIndex] (
    [MongoIndexId]     INT           IDENTITY (1, 1) NOT NULL,
    [CollectionName]   VARCHAR (50)  NOT NULL,
    [DelimitedColumns] VARCHAR (MAX) NOT NULL,
    [IsAscending]      BIT           NULL,
    [IsCompoundIndex]  BIT           NULL,
    [EntityType]       VARCHAR (50)  NULL,
    [Createdby]        INT           NULL,
    [CreatedDate]      DATETIME      NULL,
    [ModifiedBy]       INT           NULL,
    [ModifiedDate]     DATETIME      NULL,
    CONSTRAINT [PK_ZnodeMongoIndex] PRIMARY KEY CLUSTERED ([MongoIndexId] ASC)
)
end
go
if not exists(select * from sys.indexes where name = 'Ind_ZnodeMediaAttributeValue_MediaCategoryId')
begin
CREATE NONCLUSTERED INDEX [Ind_ZnodeMediaAttributeValue_MediaCategoryId]
    ON [dbo].[ZnodeMediaAttributeValue]([MediaCategoryId] ASC);
end

GO
if not exists(select * from sys.indexes where name = 'Ind_ZnodeMediaAttributeValue_MediaAttributeId')
begin
CREATE NONCLUSTERED INDEX [Ind_ZnodeMediaAttributeValue_MediaAttributeId]
    ON [dbo].[ZnodeMediaAttributeValue]([MediaAttributeId] ASC);
end
go

Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'webstoreentity','PortalId,LocaleId,PublishState',1,0,'store',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'webstoreentity' and DelimitedColumns = 'PortalId,LocaleId,PublishState' and EntityType = 'store')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'contentpageconfigentity','PortalId,IsActive,ProfileId,VersionId',1,0,'store',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'contentpageconfigentity' and DelimitedColumns = 'PortalId,IsActive,ProfileId,VersionId' and EntityType = 'store')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'categoryentity','DisplayOrder,ZnodeCategoryId,ZnodeCatalogId,LocaleId,VersionId,IsActive',1,0,'Catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'categoryentity' and DelimitedColumns = 'DisplayOrder,ZnodeCategoryId,ZnodeCatalogId,LocaleId,VersionId,IsActive' and EntityType = 'Catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'categoryentity','IsActive,VersionId,ZnodeCatalogId,ZnodeCategoryId',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'categoryentity' and DelimitedColumns = 'IsActive,VersionId,ZnodeCatalogId,ZnodeCategoryId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'logmessageentity','CreatedDate',1,0,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'logmessageentity' and DelimitedColumns = 'CreatedDate' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'versionentity','ZnodeCatalogId,RevisionType,LocaleId',1,0,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'versionentity' and DelimitedColumns = 'ZnodeCatalogId,RevisionType,LocaleId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'configurableproductentity','ZnodeProductId,VersionId',1,0,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'configurableproductentity' and DelimitedColumns = 'ZnodeProductId,VersionId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'configurableproductentity','VersionId,ZnodeProductId',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'configurableproductentity' and DelimitedColumns = 'VersionId,ZnodeProductId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'seoentity','PortalId,SEOTypeName,LocaleId,VersionId,SEOCode',1,0,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'seoentity' and DelimitedColumns = 'PortalId,SEOTypeName,LocaleId,VersionId,SEOCode' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'seoentity','PortalId,SEOUrl,VersionId',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'seoentity' and DelimitedColumns = 'PortalId,SEOUrl,VersionId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'seoentity','PortalId,SEOCode,SEOTypeName,SEOUrl,VersionId',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'seoentity' and DelimitedColumns = 'PortalId,SEOCode,SEOTypeName,SEOUrl,VersionId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'addonentity','DisplayOrder,ZnodeProductId,LocaleId,VersionId,RequiredType',1,0,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'addonentity' and DelimitedColumns = 'DisplayOrder,ZnodeProductId,LocaleId,VersionId,RequiredType' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'productentity','ZnodeProductId,SKULower,ZnodeCatalogId,ZnodeCategoryIds,LocaleId,ProductIndex,IsActive,VersionId',1,0,'catalog',2,getdate(),2,getdate() where not exists( select * from ZnodeMongoIndex where CollectionName = 'productentity' and DelimitedColumns = 'ZnodeProductId,SKULower,ZnodeCatalogId,ZnodeCategoryIds,LocaleId,ProductIndex,IsActive,VersionId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'productentity','IsActive, LocaleId,VersionId,ZnodeCatalogId,ZnodeProductId',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'productentity' and DelimitedColumns = 'IsActive, LocaleId,VersionId,ZnodeCatalogId,ZnodeProductId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'productentity','IsActive,LocaleId,VersionId,ZnodeProductId',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'productentity' and DelimitedColumns = 'IsActive,LocaleId,VersionId,ZnodeProductId' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'productentity','LocaleId,ZnodeCatalogId,SKU',1,1,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'productentity' and DelimitedColumns = 'LocaleId,ZnodeCatalogId,SKU' and EntityType = 'catalog')
Insert Into ZnodeMongoIndex(CollectionName,DelimitedColumns,IsAscending,IsCompoundIndex,EntityType,Createdby,CreatedDate,ModifiedBy,ModifiedDate)
select 'textwidgetentity','LocaleId,PortalId,VersionId',1,0,'catalog',2,getdate(),2,getdate() 
where not exists( select * from ZnodeMongoIndex where CollectionName = 'textwidgetentity' and DelimitedColumns = 'LocaleId,PortalId,VersionId' and EntityType = 'catalog')
go

if not exists(select * from sys.tables where NAme = 'ZnodeCMSMediaConfiguration')
begin
CREATE TABLE [dbo].[ZnodeCMSMediaConfiguration] (
    [CMSMediaConfigurationId] INT            IDENTITY (1, 1) NOT NULL,
    [CMSWidgetsId]            INT            NULL,
    [WidgetsKey]              NVARCHAR (500) NULL,
    [CMSMappingId]            INT            NULL,
    [TypeOFMapping]           VARCHAR (50)   NULL,
    [MediaId]                 INT            NULL,
    [CreatedBy]               INT            NULL,
    [CreatedDate]             DATETIME       NULL,
    [ModifiedBy]              INT            NULL,
    [ModifiedDate]            DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([CMSMediaConfigurationId] ASC),
    CONSTRAINT [FK_ZnodeCMSMediaConfiguration_ZnodeCMSWidgets] FOREIGN KEY ([MediaId]) REFERENCES [dbo].[ZnodeMedia] ([MediaId]),
    CONSTRAINT [FK_ZnodeCMSMediaConfiguration_ZnodeCMSWidgets_CMSWidgetsId] FOREIGN KEY ([CMSWidgetsId]) REFERENCES [dbo].[ZnodeCMSWidgets] ([CMSWidgetsId])
);
End
go
if exists(select * from sys.procedures where name = 'Znode_GetMediaWidgetConfiguration')
	drop proc Znode_GetMediaWidgetConfiguration
go
CREATE PROCEDURE [dbo].[Znode_GetMediaWidgetConfiguration]
(
       @PortalId INT
	   ,@UserId INT =  0  	
	   ,@CMSMappingId INT =0
)
AS
/*
Summary: This Procedure is used to get Media widget configuration
Unit Testing :
 EXEC Znode_GetMediaWidgetConfiguration 1,2

*/
     BEGIN
		 SET NOCOUNT ON;
         BEGIN TRY
             DECLARE @ReturnXML TABLE (
                                      ReturnXMl XML
                                      );
                      
                     DECLARE @CMSWidgetData TABLE (CMSMediaConfigurationId INT ,CMSWidgetsId INT ,WidgetsKey NVARCHAR(256) ,CMSMappingId  INT ,TypeOFMapping   NVARCHAR(100) ,[MediaPath]  NVARCHAR(1000));
                     
					 DECLARE @CMSWidgetDataFinal TABLE (CMSMediaConfigurationId INT ,CMSWidgetsId INT ,WidgetsKey  NVARCHAR(256) ,CMSMappingId  INT ,TypeOFMapping NVARCHAR(100) ,[MediaPath]  NVARCHAR(1000));

                     INSERT INTO @CMSWidgetDataFinal
                     SELECT CMSMediaConfigurationId , CMSWidgetsId , WidgetsKey , CMSMappingId , TypeOFMapping , ZM.Path as MediaPath
                     FROM ZnodeCMSMediaConfiguration AS a
					 inner join ZnodeMedia ZM on a.MediaId = ZM.MediaId
                     WHERE (a.TypeOFMapping = 'ContentPageMapping'
                     AND ( EXISTS ( SELECT TOP 1 1 FROM ZnodeCMSContentPages  WHERE a.CMSMappingId = CMSContentPagesId AND PortalId = @PortalId  ))
                     OR (a.TypeOFMapping = 'PortalMapping' AND a.CMSMappingId = @PortalId ))
					 AND (a.CMSMappingId = @CMSMappingId OR @CMSMappingId = 0  )
					
                     INSERT INTO @ReturnXML ( ReturnXMl
                                            )
                            SELECT ( SELECT CMSMediaConfigurationId AS MediaWidgetConfigurationId , CMSWidgetsId AS WidgetsId , WidgetsKey , CMSMappingId AS MappingId , TypeOFMapping , MediaPath , @PortalId AS PortalId
                                     FROM @CMSWidgetDataFinal AS a
                                     WHERE a.CMSMediaConfigurationId = w.CMSMediaConfigurationId 
                                     FOR XML PATH('MediaWidgetEntity')
                                   )
                            FROM @CMSWidgetDataFinal AS w

					 SELECT * FROM @ReturnXML;
         END TRY
         BEGIN CATCH
             DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetMediaWidgetConfiguration @PortalId = '+CAST(@PortalId AS VARCHAR(max))+',@UserId='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'Znode_GetMediaWidgetConfiguration',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
         END CATCH;
     END;
	 go

Insert  INTO ZnodeCMSWidgets (Code,DisplayName,IsConfigurable,FileName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'ImageWidget' ,'ImageWidget',1,'Text_Editor.png',2,Getdate(),2,Getdate() where not exists
(SELECT * FROM ZnodeCMSWidgets where Code = 'ImageWidget')
go
Insert  INTO ZnodeCMSWidgets (Code,DisplayName,IsConfigurable,FileName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
SELECT 'VideoWidget' ,'Video Widget',1,'Text_Editor.png',2,Getdate(),2,Getdate() where not exists
(SELECT * FROM ZnodeCMSWidgets where Code = 'VideoWidget')
go
if exists(select * from sys.procedures where name = 'Znode_GetPublishCategory')
	drop proc Znode_GetPublishCategory
go

CREATE PROCEDURE [dbo].[Znode_GetPublishCategory]
(   @PublishCatalogId INT,
    @UserId           INT,
    @VersionId        INT,
    @Status           BIT = 0 OUT,
    @IsDebug          BIT = 0,
	@LocaleId         TransferID READONLY)
AS 
/*
       Summary:Publish category with their respective products and details 
	            The result is fetched in xml form   
       Unit Testing   
       Begin transaction 
       SELECT * FROM ZnodePIMAttribute 
	   SELECT * FROM ZnodePublishCatalog 
	   SELECT * FROM ZnodePublishCategory WHERE publishCAtegoryID = 167 


       EXEC [Znode_GetPublishCategory] @PublishCatalogId = 3,@VersionId = 0 ,@UserId =2 ,@IsDebug = 1 
     


       Rollback Transaction 
	*/
     BEGIN
         BEGIN TRAN GetPublishCategory;
         BEGIN TRY
             SET NOCOUNT ON;
			 DECLARE @GetDate DATETIME = dbo.Fn_GetDate();
             DECLARE @LocaleIdIn INT= 0, @DefaultLocaleId INT= dbo.Fn_GetDefaultLocaleId(), @Counter INT= 1, @MaxId INT= 0, @CategoryIdCount INT;
             DECLARE @IsActive BIT= [dbo].[Fn_GetIsActiveTrue]();
             DECLARE @AttributeIds VARCHAR(MAX)= '', @PimCategoryIds VARCHAR(MAX)= '', @DeletedPublishCategoryIds VARCHAR(MAX)= '', @DeletedPublishProductIds VARCHAR(MAX);
             --get the pim catalog id 
			 DECLARE @PimCatalogId INT=(SELECT PimCatalogId FROM ZnodePublishcatalog WHERE PublishCatalogId = @PublishCatalogId); 

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
             (PimAttributeId            INT,
              AttributeDefaultValueCode VARCHAR(100),
              IsEditable                BIT,
              AttributeDefaultValue     NVARCHAR(MAX)
			  ,DisplayOrder   INT
             );
             DECLARE @TBL_AttributeValue TABLE
             (PimCategoryAttributeValueId INT,
              PimCategoryId               INT,
              CategoryValue               NVARCHAR(MAX),
              AttributeCode               VARCHAR(300),
              PimAttributeId              INT
             );
             DECLARE @TBL_LocaleIds TABLE
             (RowId     INT IDENTITY(1, 1),
              LocaleId  INT,
              IsDefault BIT
             );
             DECLARE @TBL_PimCategoryIds TABLE
             (PimCategoryId       INT,
              PimParentCategoryId INT,
              DisplayOrder        INT,
              ActivationDate      DATETIME,
              ExpirationDate      DATETIME,
              CategoryName        NVARCHAR(MAX),
              ProfileId           VARCHAR(MAX),
              IsActive            BIT,
			  PimCategoryHierarchyId INT,
			  ParentPimCategoryHierarchyId INT ,
			   CategoryCode  NVARCHAR(MAX)             );


             DECLARE @TBL_PublishPimCategoryIds TABLE
             (PublishCategoryId       INT,
              PimCategoryId           INT,
              PublishProductId        varchar(max),
              PublishParentCategoryId INT ,
			  PimCategoryHierarchyId INT ,parentPimCategoryHierarchyId INT,
			  RowIndex INT
             );
             DECLARE @TBL_DeletedPublishCategoryIds TABLE
             (PublishCategoryId INT,
              PublishProductId  INT
             );
             DECLARE @TBL_CategoryXml TABLE
             (PublishCategoryId INT,
              CategoryXml       XML,
              LocaleId          INT
             );
             INSERT INTO @TBL_LocaleIds
             (LocaleId,
              IsDefault
             )
			  -- here collect all locale ids
             SELECT LocaleId,IsDefault FROM ZnodeLocale MT WHERE IsActive = @IsActive
			  AND (EXISTS (SELECT TOP 1 1  FROM @LocaleId RT WHERE RT.Id = MT.LocaleId )
			 OR NOT EXISTS (SELECT TOP 1 1 FROM @LocaleId ));

			 if object_id('tempdb..#CategoryData')is not null
				drop table #CategoryData

			 ------------for CategoryCode update
			SELECT ZPCAL.CategoryValue as CategoryCode,MAX(ZPC.PublishCategoryId) as PublishCategoryId ,ZPCA.PimCategoryId, ZPoC.PortalId
			INTO #CategoryData
			FROM ZnodePimCategoryAttributeValue ZPCA
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAL on ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCA.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePublishCategory ZPC on ZPCA.PimCategoryId = ZPC.PimCategoryId
			INNER JOIN ZnodePortalCatalog ZPoC on ZPC.PublishCatalogId = ZPoC.PublishCatalogId
			where ZPA.AttributeCode = 'CategoryCode' AND ZPC.PublishCatalogId = @PublishCatalogId
			AND EXISTS(SELECT * FROM ZnodeCMSWidgetCategory ZCWC WHERE ZPC.PublishCategoryId = ZCWC.PublishCategoryId )
			group by ZPCAL.CategoryValue, ZPCA.PimCategoryId, ZPoC.PortalId

			UPDATE ZCWC SET ZCWC.CategoryCode = CD.CategoryCode
			from ZnodeCMSWidgetCategory ZCWC
			INNER JOIN #CategoryData CD ON ZCWC.PublishCategoryId = CD.PublishCategoryId and ZCWC.CMSMappingId = CD.PortalId
			where ZCWC.TypeOFMapping = 'PortalMapping'
			----------

             INSERT INTO @TBL_PimCategoryIds(PimCategoryId,PimParentCategoryId,DisplayOrder,ActivationDate,ExpirationDate,IsActive,PimCategoryHierarchyId,ParentPimCategoryHierarchyId)
             SELECT DISTINCT ZPCH.PimCategoryId,ZPCH2.PimCategoryId  PimParentCategoryId,ZPCH.DisplayOrder,ZPCH.ActivationDate,ZPCH.ExpirationDate,ZPCH.IsActive ,ZPCH.PimCategoryHierarchyId,ZPCH.ParentPimCategoryHierarchyId
			 FROM ZnodePimCategoryHierarchy AS ZPCH 
			 LEFT JOIN ZnodePimCategoryHierarchy AS ZPCH2 ON (ZPCH2.PimCategoryHierarchyId = ZPCH. ParentPimCategoryHierarchyId ) 
			 WHERE ZPCH.PimCatalogId = @PimCatalogId; 
             -- AND IsActive = @IsActive ; -- As discussed with @anup active flag maintain on demo site 23/12/2016
			 --	SELECT * FROM @TBL_PimCategoryIds
			 -- here is find the deleted publish category id on basis of publish catalog
             INSERT INTO @TBL_DeletedPublishCategoryIds(PublishCategoryId,PublishProductId)
             SELECT ZPC.PublishCategoryId,ZPCP.PublishProductId 
			 FROM ZnodePublishCategoryProduct ZPCP
             INNER JOIN ZnodePublishCategory AS ZPC ON(ZPCP.PublishCategoryId = ZPC.PublishCategoryId AND ZPCP.PublishCatalogId = ZPC.PublishCatalogId)                                                  
             INNER JOIN ZnodePublishProduct ZPP ON(zpp.PublishProductId = zpcp.PublishProductId AND zpp.PublishCatalogId = zpcp.PublishCatalogId)
             INNER JOIN ZnodePublishCatalog ZPCC ON(ZPCC.PublishCatalogId = ZPCP.PublishCatalogId)
             WHERE ZPC.PublishCatalogId = @PublishCataLogId 
			 AND NOT EXISTS(SELECT TOP 1 1 FROM ZnodePimCategoryHierarchy AS TBPC WHERE TBPC.PimCategoryId = ZPC.PimCategoryId AND TBPC.PimCategoryHierarchyId = ZPC.PimCategoryHierarchyId
			 AND TBPC.PimCatalogId = ZPCC.PimCatalogId);

			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishCategoryIds = ISNULL(SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_DeletedPublishCategoryIds AS ZPC
                                              GROUP BY ZPC.PublishCategoryId FOR XML PATH('') ), 2, 4000), '');
			 -- here is find the deleted publish category id on basis of publish catalog
             SET @DeletedPublishProductIds = '';
			 -- Delete the publish category id 
	
	        --   SELECT * FROM @TBL_DeletedPublishCategoryIds 

             EXEC Znode_DeletePublishCatalog @PublishCatalogIds = @PublishCatalogId,@PublishCategoryIds = @DeletedPublishCategoryIds,@PublishProductIds = @DeletedPublishProductIds; 
			
             MERGE INTO ZnodePublishCategory TARGET USING  @TBL_PimCategoryIds SOURCE ON
			 (
			 TARGET.PimCategoryId = SOURCE.PimCategoryId 
			 AND TARGET.PublishCatalogId = @PublishCataLogId 
			 AND TARGET.PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId
			 )
			 WHEN MATCHED THEN UPDATE SET TARGET.PimParentCategoryId = SOURCE.PimParentCategoryId,TARGET.CreatedBy = @UserId,TARGET.CreatedDate = @GetDate,
             TARGET.ModifiedBy = @UserId,TARGET.ModifiedDate = @GetDate,PimCategoryHierarchyId = SOURCE.PimCategoryHierarchyId,ParentPimCategoryHierarchyId=SOURCE.ParentPimCategoryHierarchyId
             WHEN NOT MATCHED THEN INSERT(PimCategoryId,PublishCatalogId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PimCategoryHierarchyId,ParentPimCategoryHierarchyId) 
			 VALUES(SOURCE.PimCategoryId,@PublishCatalogId,@UserId,@GetDate,@UserId,@GetDate,SOURCE.PimCategoryHierarchyId,SOURCE.ParentPimCategoryHierarchyId)
             OUTPUT INSERTED.PublishCategoryId,INSERTED.PimCategoryId,INSERTED.PimCategoryHierarchyId,INSERTED.parentPimCategoryHierarchyId INTO @TBL_PublishPimCategoryIds(PublishCategoryId,PimCategoryId,PimCategoryHierarchyId,parentPimCategoryHierarchyId);
			
    --         UPDATE TBPC SET PublishParentCategoryId = TBPCS.PublishCategoryId 
			 --FROM @TBL_PublishPimCategoryIds TBPC
    --         INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId)
    --         INNER JOIN @TBL_PublishPimCategoryIds TBPCS ON(TBC.PimCategoryHierarchyId = TBPCS.parentPimCategoryHierarchyId  ) 
			 --WHERE TBC.parentPimCategoryHierarchyId IS NOT NULL;
           
		     -- here update the publish parent category id
             UPDATE ZPC SET [PimParentCategoryId] =TBPC.[PimCategoryId] 
			 FROM ZnodePublishCategory ZPC
             INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL
			 AND TBPC.PublishCatalogId =@PublishCatalogId
			 ;
			 UPDATE a
			 SET  a.PublishParentCategoryId = b.PublishCategoryId
			FROM ZnodePublishCategory a 
			INNER JOIN ZnodePublishCategory b   ON (a.parentpimCategoryHierarchyId = b.pimCategoryHierarchyId)
			WHERE a.parentpimCategoryHierarchyId IS NOT NULL 
			AND a.PublishCatalogId =@PublishCatalogId
			AND b.PublishCatalogId =@PublishCatalogId

			UPDATE a set a.PublishParentCategoryId = NULL
			FROM ZnodePublishCategory a 
			WHERE a.parentpimCategoryHierarchyId IS NULL AND PimParentCategoryId IS NULL
			AND a.PublishCatalogId = @PublishCatalogId AND a.PublishParentCategoryId IS NOT NULL

			 --UPDATE ZPC SET [PimParentCategoryId] = TBPC.[PimCategoryId] 
			 --FROM ZnodePublishCategory ZPC
    --         INNER JOIN ZnodePublishCategory TBPC ON(ZPC.parentPimCategoryHierarchyId = TBPC.PimCategoryHierarchyId  ) 
			 --WHERE ZPC.PublishCatalogId =@PublishCatalogId
			 --AND ZPC.ParentPimCategoryHierarchyId IS NOT NULL ;

			 -- product are published here 
            --  EXEC Znode_GetPublishProducts @PublishCatalogId,0,@UserId,1,0,0;

             SET @MaxId =(SELECT MAX(RowId)FROM @TBL_LocaleIds);
			 DECLARE @TransferID TRANSFERID 
			 INSERT INTO @TransferID 
			 SELECT DISTINCT  PimCategoryId
			 FROM @TBL_PublishPimCategoryIds 

             SET @PimCategoryIds = SUBSTRING((SELECT ','+CAST(PimCategoryId AS VARCHAR(50)) FROM @TBL_PublishPimCategoryIds FOR XML PATH('')), 2, 4000);
			 
             WHILE @Counter <= @MaxId -- Loop on Locale id 
                 BEGIN
                     SET @LocaleIdIn =(SELECT LocaleId FROM @TBL_LocaleIds WHERE RowId = @Counter);
                   
				     SET @AttributeIds = SUBSTRING((SELECT ','+CAST(ZPCAV.PimAttributeId AS VARCHAR(50)) FROM ZnodePimCategoryAttributeValue ZPCAV 
										 WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC WHERE TBPC.PimCategoryId = ZPCAV.PimCategoryId) GROUP BY ZPCAV.PimAttributeId FOR XML PATH('')), 2, 4000);
                
				     SET @CategoryIdCount =(SELECT COUNT(1) FROM @TBL_PimCategoryIds);

                     INSERT INTO @TBL_AttributeIds (PimAttributeId,ParentPimAttributeId,AttributeTypeId,AttributeCode,IsRequired,IsLocalizable,IsFilterable,IsSystemDefined,
					 IsConfigurable,IsPersonalizable,DisplayOrder,HelpDescription,IsCategory,IsHidden,CreatedDate,ModifiedDate,AttributeName,AttributeTypeName)
                     EXEC [Znode_GetPimAttributesDetails] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeDefault (PimAttributeId,AttributeDefaultValueCode,IsEditable,AttributeDefaultValue,DisplayOrder)
                     EXEC [dbo].[Znode_GetAttributeDefaultValueLocale] @AttributeIds,@LocaleIdIn;

                     INSERT INTO @TBL_AttributeValue (PimCategoryAttributeValueId,PimCategoryId,CategoryValue,AttributeCode,PimAttributeId)
                     EXEC [dbo].[Znode_GetCategoryAttributeValueId] @TransferID,@AttributeIds,@LocaleIdIn;

					-- SELECT * FROM @TBL_AttributeValue WHERE PimCategoryId = 281


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
                     AS (SELECT TBA.PimCategoryId,TBA.PimAttributeId,[dbo].[FN_GetThumbnailMediaPathPublish](SUBSTRING((SELECT ','+zm.PATH FROM ZnodeMedia ZM WHERE EXISTS
					    (SELECT TOP 1 1 FROM dbo.split(TBA.CategoryValue, ',') SP WHERE SP.Item = CAST(Zm.MediaId AS VARCHAR(50)))FOR XML PATH('')), 2, 4000)) CategoryValue
						FROM @TBL_AttributeValue TBA WHERE EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetProductMediaAttributeId]() FNMA WHERE FNMA.PImAttributeId = TBA.PimATtributeId))
                         
					 UPDATE TBAV SET CategoryValue = CTCM.CategoryValue 
					 FROM @TBL_AttributeValue TBAV 
					 INNER JOIN Cte_productMedia CTCM ON(CTCM.PimCategoryId = TBAV.PimCategoryId
					 AND CTCM.PimAttributeId = TBAV.PimAttributeId);

                     WITH Cte_PublishProductIds
					 AS (SELECT TBPC.PublishcategoryId,SUBSTRING((SELECT ','+CAST(PublishProductId AS VARCHAR(50))
					  FROM ZnodePublishCategoryProduct ZPCP 
					  WHERE ZPCP.PublishCategoryId = TBPC.publishCategoryId
					  AND ZPCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId
                      AND ZPCP.PublishCatalogId = @PublishCatalogId FOR XML PATH('')), 2, 8000) PublishProductId ,PimCategoryHierarchyId
					  FROM @TBL_PublishPimCategoryIds TBPC)
                          
					 UPDATE TBPPC SET PublishProductId = CTPP.PublishProductId FROM @TBL_PublishPimCategoryIds TBPPC INNER JOIN Cte_PublishProductIds CTPP ON(TBPPC.PublishCategoryId = CTPP.PublishCategoryId 
					 AND TBPPC.PimCategoryHierarchyId = CTPP.PimCategoryHierarchyId);

                     WITH Cte_CategoryProfile
                     AS (SELECT PimCategoryId,ZPCC.PimCategoryHierarchyId,SUBSTRING(( SELECT ','+CAST(ProfileId AS VARCHAR(50)) 
					 FROM ZnodeProfileCatalog ZPC 
					 INNER JOIN ZnodeProfileCategoryHierarchy ZPRCC ON(ZPRCC.PimCategoryHierarchyId = ZPCC.PimCategoryHierarchyId
                        AND ZPRCC.ProfileCatalogId = ZPC.ProfileCatalogId) 
						WHERE ZPC.PimCatalogId = ZPCC.PimCatalogId FOR XML PATH('')), 2, 4000) ProfileIds
                      
					   FROM ZnodePimCategoryHierarchy ZPCC 
					   WHERE EXISTS(SELECT TOP 1 1 FROM @TBL_PimCategoryIds TBPC 
					   WHERE TBPC.PimCategoryId = ZPCC.PimCategoryId AND ZPCC.PimCatalogId = @PimCatalogId 
					   AND ZPCC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId))
                          
				     UPDATE TBPC SET TBPC.ProfileId = CTCP.ProfileIds FROM @TBL_PimCategoryIds TBPC 
					 LEFT JOIN Cte_CategoryProfile CTCP ON(CTCP.PimCategoryId = TBPC.PimCategoryId AND CTCP.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId );
                     
					 UPDATE TBPC SET TBPC.CategoryName = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
                     AND EXISTS(SELECT TOP 1 1 FROM [dbo].[Fn_GetCategoryNameAttribute]() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId));


					  UPDATE TBPC SET TBPC.CategoryCode = TBAV.CategoryValue FROM @TBL_PimCategoryIds TBPC INNER JOIN @TBL_AttributeValue TBAV ON(TBAV.PimCategoryId = TBPC.PimCategoryId
					 AND EXISTS(SELECT TOP 1 1 FROM dbo.Fn_GetCategoryCodeAttribute() FNGCNA WHERE FNGCNA.PimAttributeId = TBAV.PimAttributeId)
					 )


					DECLARE @UpdateCategoryLog  TABLE (PublishCatalogLogId INT , LocaleId INT ,PublishCatalogId INT  )
					INSERT INTO @UpdateCategoryLog
					SELECT MAX(PublishCatalogLogId) PublishCatalogLogId , LocaleId , PublishCatalogId 
					FROM ZnodePublishCatalogLog a 
					WHERE a.PublishCatalogId =@PublishCatalogId
					AND  a.LocaleId = @LocaleIdIn 
					GROUP BY 	LocaleId,PublishCatalogId 



					 -- here update the publish category details 
                     ;WITH Cte_UpdateCategoryDetails
                     AS (
					 SELECT TBC.PimCategoryId,PublishCategoryId,CategoryName, TBPPC.PimCategoryHierarchyId,CategoryCode
					 FROM @TBL_PimCategoryIds TBC
                     INNER JOIN @TBL_PublishPimCategoryIds TBPPC ON(TBC.PimCategoryId = TBPPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPPC.PimCategoryHierarchyId)
					 )						
                     MERGE INTO ZnodePublishCategoryDetail TARGET USING Cte_UpdateCategoryDetails SOURCE ON(TARGET.PublishCategoryId = SOURCE.PublishCategoryId
					 AND TARGET.LocaleId = @LocaleIdIn)
                     WHEN MATCHED THEN UPDATE SET PublishCategoryId = SOURCE.PublishcategoryId,PublishCategoryName = SOURCE.CategoryName,LocaleId = @LocaleIdIn,ModifiedBy = @userId,ModifiedDate = @GetDate,CategoryCode=SOURCE.CategoryCode
                     WHEN NOT MATCHED THEN INSERT(PublishCategoryId,PublishCategoryName,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,CategoryCode) VALUES
                     (SOURCE.PublishCategoryId,SOURCE.CategoryName,@LocaleIdIn,@userId,@GetDate,@userId,@GetDate,SOURCE.CategoryCode);

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

                     ;WITH Cte_CategoryXML
                     AS (SELECT PublishcategoryId,PimCategoryId,(SELECT ISNULL(TYU.PublishCatalogLogId,'') VersionId,TBPC.PublishCategoryId ZnodeCategoryId,@PublishCatalogId ZnodeCatalogId
																		,THR.PublishParentCategoryId TempZnodeParentCategoryIds,ZPC.CatalogName ,
																		 ISNULL(DisplayOrder, '0') DisplayOrder,@LocaleIdIn LocaleId,ActivationDate 
																		 ,ExpirationDate,TBC.IsActive,ISNULL(CategoryName, '') Name,ProfileId TempProfileIds,ISNULL(TBPC.PublishProductId, '') TempProductIds
																		 ,ISNULL(TBPC.RowIndex,1) CategoryIndex
																		 ,ISNULL(CategoryCode,'') CategoryCode
                        FROM @TBL_PublishPimCategoryIds TBPC 
						INNER JOIN ZnodePublishCatalog ZPC ON (ZPC.PublishCatalogId= @PublishCatalogId)
						LEFT JOIN @UpdateCategoryLog TYU ON (TYU.PublishCatalogId = @PublishCatalogId AND TYU.LocaleId = @LocaleIdIn)
						INNER JOIN ZnodePublishCAtegory THR ON (THR.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId AND THR.PimCategoryId = TBPC.PimCategoryId AND THR.PublishCatalogId= @PublishCatalogId )
						INNER JOIN @TBL_PimCategoryIds TBC ON(TBC.PimCategoryId = TBPC.PimCategoryId AND TBC.PimCategoryHierarchyId = TBPC.PimCategoryHierarchyId) WHERE TBPC.PublishCategoryId = TBPCO.PublishCategoryId 
						FOR XML PATH('')) CategoryXml 
						FROM @TBL_PublishPimCategoryIds TBPCO),

                     Cte_CategoryAttributeXml
                     AS (SELECT CTCX.PublishCategoryId,'<CategoryEntity>'+ISNULL(CategoryXml, '')+ISNULL((SELECT(SELECT TBA.AttributeCode,TBA.AttributeName,ISNULL(IsUseInSearch, 0) IsUseInSearch,
                        ISNULL(IsHtmlTags, 0) IsHtmlTags,ISNULL(IsComparable, 0) IsComparable,(SELECT ''+TBAV.CategoryValue FOR XML PATH('')) AttributeValues,TBA.AttributeTypeName FROM @TBL_AttributeValue TBAV
                        INNER JOIN @TBL_AttributeIds TBA ON(TBAV.PimAttributeId = TBA.PimAttributeId) LEFT JOIN ZnodePimFrontendProperties ZPFP ON(ZPFP.PimAttributeId = TBA.PimAttributeId)
                        WHERE CTCX.PimCategoryId = TBAV.PimCategoryId AND TBAO.PimAttributeId = TBA.PimAttributeId FOR XML PATH('AttributeEntity'), TYPE) FROM @TBL_AttributeIds TBAO
                        FOR XML PATH('Attributes')), '')+'</CategoryEntity>' CategoryXMl FROM Cte_CategoryXML CTCX)

                     INSERT INTO @TBL_CategoryXml(PublishCategoryId,CategoryXml,LocaleId)
                     SELECT PublishCategoryId,CategoryXml,@LocaleIdIn LocaleId FROM Cte_CategoryAttributeXml;
                   
				     DELETE FROM @TBL_AttributeIds;
                     DELETE FROM @TBL_AttributeDefault;
                     DELETE FROM @TBL_AttributeValue;
                     SET @Counter = @Counter + 1;
                 END;

    --         UPDATE ZnodePublishCatalogLog SET PublishCategoryId = SUBSTRING((SELECT ','+CAST(PublishCategoryId AS VARCHAR(50)) FROM @TBL_CategoryXml
			 --GROUP BY PublishCategoryId																				
    --         FOR XML PATH('')), 2, 4000), IsCategoryPublished = 1 WHERE PublishCatalogLogId = @VersionId;

			 --UPDATE ZnodePublishCatalogLog 
			 --SET PublishCategoryId = (SELECT COunt(DISTINCT PublishCategoryId ) FROM ZnodePublishCategory WHERE PublishCatalogId =@PublishCatalogId), IsCategoryPublished = 1 
			 --WHERE EXISTS (SELECT TOP 1 1 FROM @UpdateCategoryLog TY WHERE TY.PublishCatalogLogId =  ZnodePublishCatalogLog.PublishCatalogLogId ) ;


			 UPDATE ZnodePublishCatalogLog 
			 SET PublishCategoryId = (SELECT COunt(DISTINCT PimCategoryId ) 
			 FROM @TBL_PublishPimCategoryIds WHERE PublishCatalogId =@PublishCatalogId), 
			 IsCategoryPublished = 1 
			 WHERE EXISTS (SELECT TOP 1 1 FROM @UpdateCategoryLog TY WHERE TY.PublishCatalogLogId =  ZnodePublishCatalogLog.PublishCatalogLogId ) ;
			 


             DELETE FROM ZnodePublishedXml WHERE PublishCataloglogId = @VersionId;
            
             INSERT INTO ZnodePublishedXml (PublishCatalogLogId,PublishedId,PublishedXML,IsCategoryXML,IsProductXML,LocaleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
             SELECT @VersionId PublishCataloglogId,PublishCategoryId,CategoryXml,1,0,LocaleId,@UserId,@GetDate,@UserId,@GetDate FROM @TBL_CategoryXml WHERE @VersionId <> 0;
             
			 SELECT CategoryXml  
			 FROM @TBL_CategoryXml 
			 

			 ------------for CategoryPublishId update
			SELECT ZPCAL.CategoryValue as CategoryCode,MAX(ZPC.PublishCategoryId) as PublishCategoryId ,ZPCA.PimCategoryId,ZPoC.PortalId
			INTO #CategoryData1
			FROM ZnodePimCategoryAttributeValue ZPCA
			INNER JOIN ZnodePimCategoryAttributeValueLocale ZPCAL on ZPCA.PimCategoryAttributeValueId = ZPCAL.PimCategoryAttributeValueId
			INNER JOIN ZnodePimAttribute ZPA ON ZPCA.PimAttributeId = ZPA.PimAttributeId
			INNER JOIN ZnodePublishCategory ZPC on ZPCA.PimCategoryId = ZPC.PimCategoryId
			INNER JOIN ZnodePortalCatalog ZPoC on ZPC.PublishCatalogId = ZPoC.PublishCatalogId
			where ZPA.AttributeCode = 'CategoryCode' AND ZPC.PublishCatalogId = @PublishCatalogId
			group by ZPCAL.CategoryValue, ZPCA.PimCategoryId, ZPoC.PortalId

			UPDATE ZCWC SET ZCWC.PublishCategoryId = CD.PublishCategoryId
			from ZnodeCMSWidgetCategory ZCWC
			INNER JOIN #CategoryData1 CD ON ZCWC.CategoryCode = CD.CategoryCode and ZCWC.CMSMappingId = CD.PortalId
			where ZCWC.TypeOFMapping = 'PortalMapping'
			----------------

			 --UPDATE ZnodePimCategory 
			 --SET IsCategoryPublish =1 
			 --WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_PimCategoryIds)

			 UPDATE ZnodePimCategory 
			 SET PublishStateId = Dbo.Fn_GetPublishStateIdForPreview()
			 WHERE pimCategoryId IN (SELECT PimCategoryId FROM @TBL_PublishPimCategoryIds)

              
             COMMIT TRAN GetPublishCategory;
			 
         END TRY
         BEGIN CATCH
             SELECT ERROR_MESSAGE();
             DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(), @ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetPublishCategory @PublishCatalogId = '+CAST(@PublishCatalogId AS VARCHAR(50))+',@UserId ='+CAST(@UserId AS VARCHAR(50))+',@Status='+CAST(@Status AS VARCHAR(50));
             SET @Status = 0;
             ROLLBACK TRAN GetPublishCategory;
             EXEC Znode_InsertProcedureErrorLog
                  @ProcedureName = 'Znode_GetPublishCategory',
                  @ErrorInProcedure = @Error_procedure,
                  @ErrorMessage = @ErrorMessage,
                  @ErrorLine = @ErrorLine,
                  @ErrorCall = @ErrorCall;
         END CATCH;
     END;
	go
if exists(select * from INFORMATION_SCHEMA.columns where TABLE_NAME = 'ZnodeOmsOrderDiscount' and COLUMN_NAME = 'DiscountCode')
begin
ALTER TABLE ZnodeOmsOrderDiscount ALTER COLUMN DiscountCode VARCHAR(300)
end
GO
if exists(select * from sys.procedures where name = 'ZnodeReport_GetCouponFiltered')
	drop proc ZnodeReport_GetCouponFiltered
go

CREATE PROCEDURE [dbo].[ZnodeReport_GetCouponFiltered]  
(   
	@BeginDate    DATE         = NULL,  
	@EndDate      DATE         = NULL,  
	@PortalId     VARCHAR(MAX) = '',  
	@DiscountCode NVARCHAR(300) = '',  
	@DiscountType VARCHAR(600) = ''
 )  
AS   
/*  
     Summary:- this procedure is used to get coupon filtered ( include promotion details )  
      
     EXEC ZnodeReport_GetCouponFiltered @DiscountCode = 'o' ,@PortalId = '2,4,5' ,@DiscountType = 'pro'  
*/  
  BEGIN  
  BEGIN TRY  
         SET NOCOUNT ON;
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		 DECLARE @DefSymbol NVARCHAR(5) =  dbo.Fn_GetDefaultCurrencySymbol()
		 DECLARE @Portal TABLE (PortalId INT)
		 INSERT INTO @portal 
		 SELECT  SP.Item
		 FROM dbo.split(@PortalId, ',') SP
		 
		 IF OBJECT_ID('Tempdb..[#ZnodeOmsOrderDiscount]') IS NOT NULL 
		 DROP TABLE Tempdb..[#ZnodeOmsOrderDiscount]
		    
  
         CREATE TABLE #ZnodeOmsOrderDiscount   
         (OmsOrderDiscountId INT,  
          OmsOrderDetailsId  INT,  
          OmsOrderLineItemId INT,  
          OmsDiscountTypeId  INT,  
          DiscountCode       VARCHAR(300),  
          DiscountAmount     NUMERIC(28, 6),  
          Description        NVARCHAR(MAX),  
          CreatedBy          INT,  
          CreatedDate        DATETIME,  
          ModifiedBy         INT,  
          ModifiedDate       DATETIME,  
          PortalId           INT,  
          Total              NUMERIC(28, 6),  
          Symbol    NVARCHAR(100),  
          OmsOrderDate       Datetime,  
		  CultureCode VARCHAR(100)
         );  
         INSERT INTO #ZnodeOmsOrderDiscount  
         (OmsOrderDiscountId,  
          OmsOrderDetailsId,  
            
          OmsDiscountTypeId,  
          DiscountCode,  
          DiscountAmount,  
          Description,  
          CreatedBy,  
          CreatedDate,  
          ModifiedBy,  
          ModifiedDate,  
          PortalId,  
          Total,
		  --Symbol,  
		  OmsOrderDate ,
		  CultureCode 
         )  
                SELECT DISTINCT zood.OmsOrderDiscountId,  
                       ISNULL(zood.OmsOrderDetailsId, zooli.OmsOrderDetailsId),  
                       zood.OmsDiscountTypeId,  
                       zood.DiscountCode,  
                       zood.DiscountAmount,  
                       zood.Description,  
                       zood.CreatedBy,  
                       zood.CreatedDate,  
                       zood.ModifiedBy,  
                       zood.ModifiedDate,  
                       zoods.PortalId,  
                       zoods.Total, 
					   --ISNULL(ZC.Symbol,@DefSymbol) Symbol,
					   zoods.OrderDate,
					   ZOODS.CultureCode
                FROM ZnodeOmsOrderDiscount AS zood  
                     LEFT OUTER JOIN ZnodeOmsOrderLineItems AS zooli ON zood.OmsOrderLineItemId = zooli.OmsOrderLineItemsId  
                     LEFT OUTER JOIN ZnodeOmsOrderDetails AS zoods ON (ISNULL(zood.OmsOrderDetailsId, zooli.OmsOrderDetailsId) = zoods.OmsOrderDetailsId and zoods.IsActive=1) 
					 --LEFT JOIN ZnodeCulture ZC ON (ZC.CultureCode = ZOODS.CurrencyCode);
		     
		 UPDATE ZOODS SET ZOODS.Symbol = ISNULL(ZC.Symbol,@DefSymbol)  
		 FROM #ZnodeOmsOrderDiscount ZOODS
		 INNER JOIN ZnodeCulture ZC ON (ZC.CultureCode = ZOODS.CultureCode)

         SELECT zood.DiscountCode AS CouponCode,  
                zdt.[Name] AS DiscountType,  
                zp.[StoreName] AS StoreName,  
                COUNT(zood.DiscountCode) AS TotalCount,  
                [dbo].[Fn_GetDefaultPriceRoundOff](SUM(zood.Total)) AS Total,  
                [dbo].[Fn_GetDefaultPriceRoundOff](SUM(zood.DiscountAmount)) AS DiscountAmount,  
                ISNULL(zpr.[description], znpc.[description]) AS Description,  
                ISNULL(zpr.StartDate, znpc.StartDate) AS StartDate,  
                ISNULL(zpr.EndDate, znpc.EndDate) AS EndDate,Symbol  
         FROM #ZnodeOmsOrderDiscount AS zood  
              INNER JOIN ZnodePortal AS zp ON zood.PortalId = zp.PortalId  
              LEFT OUTER JOIN ZNodePromotion AS zpr ON zood.DiscountCode = zpr.PromoCode  
              LEFT OUTER JOIN ZnodePromotionCoupon AS zprc ON zood.DiscountCode = zprc.Code  
              LEFT OUTER JOIN ZNodePromotion AS znpc ON zprc.PromotionId = znpc.PromotionId  
              LEFT OUTER JOIN ZnodeOmsDiscountType AS zdt ON zood.OmsDiscountTypeId = zdt.OmsDiscountTypeId  
         WHERE((EXISTS  
               (  
                   SELECT TOP 1 1 
					FROM @portal TBL
					WHERE ZP.PortalId = TBL.PortalId  OR @PortalId = ''   
               )))  
              AND (ISNULL(zood.DiscountCode, '') LIKE '%'+@DiscountCode+'%'  
                   OR @DiscountCode = '')  
              AND (ISNULL(zdt.[Name], '') LIKE '%'+@DiscountType+'%'  
                   OR @DiscountType = '')  
			AND (CAST(zood.OmsOrderDate AS DATE) BETWEEN CASE  
			WHEN @BeginDate IS NULL  
			THEN CAST(zood.OmsOrderDate AS DATE)  
			ELSE @BeginDate  
			END AND CASE  
			WHEN @EndDate IS NULL  
			THEN CAST(zood.OmsOrderDate AS DATE)  
			ELSE @EndDate  
			END
   )  
         GROUP BY zp.StoreName,  
                  zood.DiscountCode,  
                  ISNULL(zpr.[description], znpc.[description]),  
                  ISNULL(zpr.StartDate, znpc.StartDate),  
                  ISNULL(zpr.EndDate, znpc.EndDate),  
                  zdt.Name,  
                  zood.PortalId,Symbol;  
		IF OBJECT_ID('Tempdb..[#ZnodeOmsOrderDiscount]') IS NOT NULL 
		DROP TABLE Tempdb..[#ZnodeOmsOrderDiscount]

  END TRY  
  BEGIN CATCH  
  DECLARE @Status BIT ;  
	SET @Status = 0;  
	DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),  
	@ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_GetCouponFiltered @PortalId = '+@PortalId+',@BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@DiscountCode='+@DiscountCode+',@DiscountType='+@DiscountType+',@Status	='+CAST(@Status AS VARCHAR(10));  
	SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
	EXEC Znode_InsertProcedureErrorLog  
	@ProcedureName = 'ZnodeReport_GetCouponFiltered',  
	@ErrorInProcedure = @Error_procedure,  
	@ErrorMessage = @ErrorMessage,  
	@ErrorLine = @ErrorLine,  
	@ErrorCall = @ErrorCall;  
  END CATCH  
END;
GO
if exists(select * from sys.procedures where name = 'ZnodeDevExpressReport_GetCouponFiltered')
	drop proc ZnodeDevExpressReport_GetCouponFiltered
go

CREATE PROCEDURE [dbo].[ZnodeDevExpressReport_GetCouponFiltered]  
(   
 @BeginDate  DATE        ,  
 @EndDate  DATE         ,  
 @StoreName  VARCHAR(MAX)  = '',  
 @DiscountType   NVARCHAR(MAX) 
)  
AS   
/*  
     Summary:- this procedure is used to get coupon filtered ( include promotion details )  
      
     EXEC ZnodeDevExpressReport_GetCouponFiltered_bak @PromotionCode = 'sale10' ,@DiscountType = 'pro', @BeginDate = '2019-05-07 10:46:57.190', @EndDate = '2019-05-07 10:53:17.617'  
  
   EXEC ZnodeDevExpressReport_GetCouponFiltered  @BeginDate = '2019-05-08 11:56:45.570', @EndDate = '2019-05-15 12:49:34.120'  , @DiscountType ='PROMOCODE|COUPONCODE'
*/  
     BEGIN  
  BEGIN TRY  
         SET NOCOUNT ON;   
  
  
      DECLARE @RoundOffValue INT= dbo.Fn_GetDefaultValue('PriceRoundOff'); 
	  DECLARE @DefaultCurrencySymbol varchar(100) = dbo.Fn_GetDefaultCurrencySymbol() 
  
   CREATE TABLE #TBL_PortalId (PortalId INT );  
   INSERT INTO #TBL_PortalId  
   SELECT PortalId   
   FROM ZnodePortal ZP   
   INNER JOIN dbo.split(@StoreName,'|') SP ON (SP.Item = ZP.StoreName)  
  
   CREATE TABLE #ZnodeOmsOrderDiscount ( OmsOrderDetailsId  INT,OmsOrderLineItemId INT,OmsDiscountTypeId  INT,DiscountCode VARCHAR(300),DiscountAmount NUMERIC(28, 6),  
   Description NVARCHAR(MAX),CreatedBy INT,CreatedDate DATETIME,ModifiedBy INT,ModifiedDate DATETIME,PortalId INT,Total NUMERIC(28, 6), Symbol NVARCHAR(100), OmsOrderDate Datetime,
   OmsOrderDiscountId INT);  
  

   INSERT INTO #ZnodeOmsOrderDiscount  
   (OmsOrderDetailsId,OmsDiscountTypeId,DiscountCode,DiscountAmount,Description,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,PortalId,Total,Symbol, OmsOrderDate,OmsOrderDiscountId)  
   SELECT Distinct ISNULL(zood.OmsOrderDetailsId, zooli.OmsOrderDetailsId) OmsOrderDetailsId,zood.OmsDiscountTypeId,zood.DiscountCode,zood.DiscountAmount,zood.Description,  
   zood.CreatedBy,zood.CreatedDate, zood.ModifiedBy,zood.ModifiedDate,zoods.PortalId, zoods.Total, ISNULL(ZC.Symbol,@DefaultCurrencySymbol) Symbol,zoods.OrderDate
   ,zood.OmsOrderDiscountId  
   FROM ZnodeOmsOrderDiscount AS zood  
   INNER JOIN ZnodeOmsDiscountType ODT ON (ODT.OmsDiscountTypeId = zood.OmsDiscountTypeId)  
   LEFT  JOIN ZnodeOmsOrderLineItems AS zooli ON zood.OmsOrderLineItemId = zooli.OmsOrderLineItemsId  
   LEFT  JOIN ZnodeOmsOrderDetails AS zoods ON ISNULL(zood.OmsOrderDetailsId, zooli.OmsOrderDetailsId) = zoods.OmsOrderDetailsId  
   INNER JOIN ZnodeOmsOrderState ZOOS ON (ZOODS.OmsOrderStateId = ZOOS.OmsOrderStateId)   
   LEFT JOIN ZnodeCulture ZC ON (ZC.CultureCode = ZOODS.CurrencyCode)  
   WHERE (EXISTS (SELECT TOP 1 1 FROM #TBL_PortalId rt WHERE rt.PortalId = zoods.PortalId)  
   OR NOT EXISTS (SELECT TOP 1 1 FROM #TBL_PortalId ))  
   AND ZOODS.IsActive = 1  
   AND ZOOS.OrderStateName NOT IN ('CANCELLED','RETURNED','REJECTED','FAILED')   
   AND ODT.Name NOT IN ('PARTIALREFUND','GIFTCARD')
        
 	 
   --;WITH CTE_GetCouponFiltered AS
   --(    
   SELECT zood.DiscountCode CouponCode,zdt.[Name] AS DiscountType,zp.[StoreName] AS StoreName,COUNT(zood.OmsOrderDiscountId) AS TotalCount,  
  [dbo].[Fn_GetDefaultPriceRoundOff](zood.Total) AS Total 
   ,[dbo].[Fn_GetDefaultPriceRoundOff](SUM(zood.DiscountAmount)) AS DiscountAmount,  
   ISNULL(zpr.[description], znpc.[description]) AS Description,  
   ISNULL(zpr.StartDate, znpc.StartDate) AS BeginDate,ISNULL(zpr.EndDate, znpc.EndDate) AS EndDate,Symbol, zpr.PromoCode AS PromotionCode , zpr.Name AS PromotionName  
   ,OmsOrderDetailsId
   INTO #CTE_GetCouponFiltered
   FROM #ZnodeOmsOrderDiscount AS zood   
   INNER JOIN ZnodePortal AS zp ON zood.PortalId = zp.PortalId  
   LEFT JOIN ZNodePromotion AS zpr ON zood.DiscountCode = zpr.PromoCode  
   LEFT JOIN ZnodePromotionCoupon AS zprc ON zood.DiscountCode = zprc.Code  
   LEFT JOIN ZNodePromotion AS znpc ON zprc.PromotionId = znpc.PromotionId  
   LEFT JOIN ZnodeOmsDiscountType AS zdt ON zood.OmsDiscountTypeId = zdt.OmsDiscountTypeId  
    WHERE CAST(ZOOD.OmsOrderDate AS DATETIME) BETWEEN @BeginDate AND @EndDate       
    AND zdt.[Name] IN (select Item from dbo.split(@DiscountType,'|'))    
    GROUP BY zp.StoreName,zood.DiscountCode
	,ISNULL(zpr.[description], znpc.[description]),ISNULL(zpr.StartDate, znpc.StartDate),ISNULL(zpr.EndDate, znpc.EndDate),  
    zdt.Name,zood.PortalId,Symbol,zpr.PromoCode,zpr.Name, zood.OmsOrderDetailsId,zood.Total
	--)  
    
   

   SELECT CouponCode, --CASE WHEN DiscountType='promocode' THEN '' ELSE CouponCode END 
   DiscountType,StoreName,SUM(TotalCount) AS NumberOfUses
   ,SUM(convert(numeric(28,6),Total)) SalesTotal
   ,SUM(convert(numeric(28,6),DiscountAmount)) DiscountTotal,
   Description,BeginDate AS ActivationDate,EndDate AS ExpirationDate,
   CASE WHEN DiscountType='couponcode' THEN '' ELSE ISNULL(PromotionCode,CouponCode) END 
   PromotionCode,
   CASE WHEN DiscountType='couponcode' THEN '' ELSE PromotionName END 
   PromotionName 
   FROM #CTE_GetCouponFiltered 
   GROUP BY CouponCode ,DiscountType,StoreName,Description,BeginDate,EndDate,CASE WHEN DiscountType='couponcode' THEN '' ELSE ISNULL(PromotionCode,CouponCode) END 
   ,PromotionName --CASE WHEN DiscountType='promocode' THEN '' ELSE CouponCode END 

   
       
  END TRY  
  BEGIN CATCH  
  DECLARE @Status BIT ;  
       SET @Status = 0;  
       DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),  
    @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_GetCouponFiltered @BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(10));  
                    
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                      
      
             EXEC Znode_InsertProcedureErrorLog  
    @ProcedureName = 'ZnodeReport_GetCouponFiltered',  
    @ErrorInProcedure = @Error_procedure,  
    @ErrorMessage = @ErrorMessage,  
    @ErrorLine = @ErrorLine,  
    @ErrorCall = @ErrorCall;  
  END CATCH  
     END;
	 GO
	 if exists(select * from sys.procedures where name = 'Znode_GetMediaFolderDetails')
	drop proc Znode_GetMediaFolderDetails
go

CREATE PROCEDURE [dbo].[Znode_GetMediaFolderDetails]
( @WhereClause VARCHAR(1000),
  @MediaPathId INT,
  @Rows        INT           = 1000,
  @PageNo      INT           = 0,
  @Order_BY    VARCHAR(1000) = '',
  @RowsCount   INT OUT,
  @LocaleId    INT           = 1)
AS
/*
  Summary: This Procedure is Used to Get Details of Media Folder
  Unit Testing:
  begin tran
DECLARE @RowsCount BIGINT  
EXEC Znode_GetMediaFolderDetails @MediaPathId = -1 , @WhereClause='',@Rows=2147483647,@PageNo=1 ,@Order_By='', @RowsCount = @RowsCount OUT  
  rollback tran
  begin tran
DECLARE @RowsCount BIGINT  
EXEC Znode_GetMediaFolderDetails @MediaPathId = 1 , @WhereClause='' ,@Rows=10,@PageNo=1 ,@RowsCount =@RowsCount
  rollback tran
*/
     BEGIN
         SET NOCOUNT ON;

         BEGIN TRY
Declare @DisplayNameId int,
@DescriptionId int

SELECT @DisplayNameId =MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'DisplayName'
SELECT @DescriptionId =MediaAttributeId from ZnodeMediaAttribute where AttributeCode = 'Description'

if object_id('tempdb..#GetMediaPathDetail') is not null
drop table #GetMediaPathDetail

if object_id('tempdb..##GetMediaPathHierarchy') is not null
drop table ##GetMediaPathHierarchy

CREATE TABLE #ZnodeMediaAttributeValue_DisplayName (MediaCategoryId int,AttributeValue varchar(500))
INSERT INTO #ZnodeMediaAttributeValue_DisplayName
SELECT MediaCategoryId, AttributeValue from ZnodeMediaAttributeValue where MediaAttributeId =@DisplayNameId

CREATE TABLE #ZnodeMediaAttributeValue_Description (MediaCategoryId int,AttributeValue varchar(500))
INSERT INTO #ZnodeMediaAttributeValue_Description
SELECT MediaCategoryId, AttributeValue from ZnodeMediaAttributeValue where MediaAttributeId =@DescriptionId

CREATE TABLE #GetMediaPathDetail
(MediaCategoryId int , MediaPathId int , [Folder] varchar(1000), [FileName] varchar(1000) ,
Size varchar(30) , Height varchar(30) , Width varchar(30) , [Type] varchar(100) ,
   [MediaType] varchar(100), CreatedDate datetime, ModifiedDate datetime,
MediaId int , [Path] varchar(1000), MediaServerPath varchar(1000) ,
MediaServerThumbnailPath varchar(1000) , FamilyCode varchar(100) , CreatedBy int ,
[DisplayName] varchar(5000), [ShortDescription] varchar(1000) ,
[PathName] varchar(1000) , [Version] int
)


Insert into #GetMediaPathDetail  
(MediaCategoryId , MediaPathId , [Folder] , [FileName] ,
Size , Height , Width , Type  ,
   [MediaType] , CreatedDate , ModifiedDate ,
MediaId ,
Path , MediaServerPath ,
MediaServerThumbnailPath , FamilyCode  , CreatedBy ,
[DisplayName] , [ShortDescription] ,
[PathName] , Version )

SELECT
Zmc.MediaCategoryId, ZMPL.MediaPathId, ZMPL.[PathName] [Folder], zM.[FileName],
Zm.Size, Zm.Height, Zm.Width, Zm.Type, Zm.Type [MediaType],
zm.CreatedDate CreatedDate,
zm.ModifiedDate ModifiedDate, Zm.MediaId,
ZMCF.URL+ZMSM.ThumbnailFolderName+'\'+zM.Path MediaThumbnailPath,
ZMCF.URL+zM.Path  MediaServerPath, zM.Path,
zmafl.FamilyCode FamilyCode,
Zm.CreatedBy,ZMAVD.AttributeValue,ZMAVS.AttributeValue,ZMPL.[PathName], Zm.Version
FROM ZnodeMediaCategory ZMC
LEFT JOIN  ZnodeMediaAttributeFamily zmafl ON(zmc.MediaAttributeFamilyId = zmafl.MediaAttributeFamilyId)
INNER JOIN ZnodeMediaPathLocale ZMPL ON(ZMC.MediaPathId = ZMPL.MediaPathId)
INNER JOIN ZnodeMedia ZM ON(Zm.MediaId = Zmc.MediaId)
  LEFT JOIN  ZnodeMediaConfiguration ZMCF ON (ZMCF.MediaConfigurationId = ZM.MediaConfigurationId AND ZMCF.IsActive = 1)
LEFT JOIN  ZnodeMediaServerMaster ZMSM ON (ZMSM.MediaServerMasterId = ZMCF.MediaServerMasterId)
LEFT JOIN  #ZnodeMediaAttributeValue_DisplayName ZMAVD ON ZMAVD.MediaCategoryId = Zmc.MediaCategoryId and  ZMAVD.AttributeValue is not null
LEFT JOIN  #ZnodeMediaAttributeValue_Description ZMAVS ON ZMAVS.MediaCategoryId = Zmc.MediaCategoryId and  ZMAVS.AttributeValue is not null

CREATE INDEX Ind_#GetMediaPathDetail_MediaCategoryId on #GetMediaPathDetail(MediaPathId)

DECLARE @Rows_start VARCHAR(1000), @Rows_end VARCHAR(1000);
SET @MediaPathId =  CASE WHEN @MediaPathId = -1 THEN 1 ELSE @MediaPathId END

SET @Rows_start = CASE
                                   WHEN @Rows >= 1000000
                                   THEN 0
                                   ELSE(@Rows * (@PageNo - 1)) + 1
                               END;
             SET @Rows_end = CASE
                                 WHEN @Rows >= 1000000
                                 THEN @Rows
                                 ELSE @Rows * (@PageNo)
                             END;
             DECLARE @SQL NVARCHAR(MAX);


             SET @Order_BY = REPLACE(@Order_BY, 'MediaPathId', 'Convert(numeric,MediaPathId)');
             SET @Order_BY = REPLACE(@Order_BY, 'Size', 'Convert(numeric,Size)');
             SET @Order_BY = REPLACE(@Order_BY, 'MediaId', 'Convert(numeric,MediaId)');
             SET @Order_BY = REPLACE(@Order_BY, 'CreatedBy', 'Convert(numeric,CreatedBy)');
             SET @Order_BY = REPLACE(@Order_BY, 'MediaCategoryId', 'Convert(numeric,MediaCategoryId)');

SET @SQL = '
SELECT * INTO ##GetMediaPathHierarchy FROM DBO.FN_GetMediaPathHierarchy('+CAST( @MediaPathId  AS VARCHAR(1000))+')'

EXEC SP_executesql @SQL

             SET @SQL = ' DECLARE @V_MediaServerPath  VARCHAR(max) , @V_MediaServerThumbnailPath  VARCHAR(MAx)  


SELECT RANK()OVER(ORDER BY '+CASE
                                                 WHEN @Order_BY IS NULL
                                                      OR @Order_BY = ''
                                                 THEN ''
                                                 ELSE @Order_BY+' ,'
                                          END+'MediaId ) RowId, [MediaCategoryId],[MediaPathId],[Folder],[FileName],[Size],[Height],[Width],
[MediaType],[CreatedDate],[ModifiedDate],[MediaId],[Path],ISNULL(MediaServerPath,'''') AS MediaServerPath,
 ISNULL(MediaServerThumbnailPath,'''') AS MediaServerThumbnailPath,[FamilyCode],[CreatedBy],[ShortDescription],[DisplayName], [Version]
INTO #MediaPathDetail FROM '+CASE
                                                 WHEN @MediaPathId = -1
                                                 THEN ' View_GetAllMediaInRoot '
                                                 ELSE ' #GetMediaPathDetail ZMC '
                                          END+' WHERE 1=1 '+CASE
                                                                   WHEN @WhereClause = ''
                                                                        OR @WhereClause IS NULL
                                                                        OR @WhereClause = '-1'
                                                                   THEN 'AND exists (select top 1 1 from ##GetMediaPathHierarchy Q
where Q.MediaPathId = ZMC.MediaPathId )'
                                                                   ELSE CASE
                                                                            WHEN @MediaPathId = -1
                                                                            THEN ' AND '+@WhereClause
                                                                            ELSE ' AND exists (select top 1 1 from ##GetMediaPathHierarchy Q
where Q.MediaPathId = ZMC.MediaPathId ) and  '+@WhereClause
                                                                        END
                                                               END+' Order BY '+CASE
                                                                                    WHEN @Order_BY IS NULL
                                                                                         OR @Order_BY = ''
                                                                                    THEN ' MediaCategoryId DESC'
                                                                                    ELSE @Order_BY
                                                                                END+' SELECT  @Count=ISNULL(Count(1),0) FROM  #MediaPathDetail  SELECT [MediaCategoryId],[MediaPathId],[Folder],[FileName],[Size],[Height],[Width],
[MediaType],[CreatedDate],[ModifiedDate],[MediaId],[Path],ISNULL(MediaServerPath,'''') AS MediaServerPath, ISNULL(MediaServerThumbnailPath,'''') AS MediaServerThumbnailPath,
[FamilyCode],[CreatedBy],[ShortDescription],[DisplayName],[Version]
FROM #MediaPathDetail
WHERE RowId BETWEEN '+@Rows_start+' AND '+@Rows_end+' Order BY '+CASE
                                                                                   WHEN @Order_BY IS NULL
                                                                                        OR @Order_BY = ''
                                                                                   THEN ' MediaCategoryId DESC '
                                                                                   ELSE @Order_BY
                                                                              END;
     
             EXEC SP_executesql
                  @SQL,
                  N'@Count INT OUT',
                  @Count = @RowsCount OUT;

if object_id('tempdb..#GetMediaPathDetail') is not null
drop table #GetMediaPathDetail

if object_id('tempdb..##GetMediaPathHierarchy') is not null
drop table ##GetMediaPathHierarchy


         END TRY
         BEGIN CATCH
DECLARE @Status BIT ;
SET @Status = 0;
DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
@ErrorCall NVARCHAR(MAX)= 'EXEC Znode_GetMediaFolderDetails @WhereClause = '''+ISNULL(@WhereClause,'''''')+''',@Rows='+ISNULL(CAST(@Rows AS
VARCHAR(50)),'''''')+',@PageNo='+ISNULL(CAST(@PageNo AS VARCHAR(50)),'''')+',@Order_BY='''+ISNULL(@Order_BY,'''''')+''',@RowsCount='+ISNULL(CAST(@RowsCount AS VARCHAR(50)),'''')+',@MediaPathId='+ISNULL(CAST(@WhereClause AS VARCHAR(100)),'''')+',@LocaleId = '+ISNULL(CAST(@LocaleId AS VARCHAR(50)),'''');
             
SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    

EXEC Znode_InsertProcedureErrorLog
@ProcedureName = 'Znode_GetMediaFolderDetails',
@ErrorInProcedure = 'Znode_GetMediaFolderDetails',
@ErrorMessage = @ErrorMessage,
@ErrorLine = @ErrorLine,
@ErrorCall = @ErrorCall;                                
         END CATCH;
     END;

go

Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Customer','GetSalesRepList',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Customer' and ActionName = 'GetSalesRepList')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer')
   ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetSalesRepList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
    (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId =
    (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetSalesRepList'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetSalesRepList')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Users' AND ControllerName = 'Customer') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Customer' and ActionName= 'GetSalesRepList'))

go


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'WebSite','ManageMediaWidgetConfiguration',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'WebSite' and ActionName = 'ManageMediaWidgetConfiguration')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Pages' AND ControllerName = 'Content')
   ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'ManageMediaWidgetConfiguration') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
    (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Pages' AND ControllerName = 'Content') and ActionId =
    (select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'ManageMediaWidgetConfiguration'))

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Pages' AND ControllerName = 'Content'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'ManageMediaWidgetConfiguration')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Pages' AND ControllerName = 'Content') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'WebSite' and ActionName= 'ManageMediaWidgetConfiguration'))
go
insert into ZnodeSearchFeature(ParentSearchFeatureId,FeatureCode,FeatureName,IsAdvanceFeature,ControlType,HelpDescription
,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select null,'DfsQueryThenFetch','Enable Accurate Scoring',0,'Yes/No','Find all the matching documents from all the shards from the index and apply the relevance score to get a more relevant result. Note: Enabling this feature may hamper the performance of the query by 20%',
2,getdate(),2,getdate()
where not exists(select * from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch' )

insert into ZnodeSearchQueryTypeFeature (SearchFeatureId,SearchQueryTypeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch'),
(select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Match'),
2,getdate(),2,GETDATE()
where not exists(select * from ZnodeSearchQueryTypeFeature
where SearchFeatureId = (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch')
and SearchQueryTypeId = (select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Match')
)

insert into ZnodeSearchQueryTypeFeature (SearchFeatureId,SearchQueryTypeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch'),
(select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Match Phrase'),
2,getdate(),2,GETDATE()
where not exists(select * from ZnodeSearchQueryTypeFeature
where SearchFeatureId = (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch')
and SearchQueryTypeId = (select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Match Phrase')
)

insert into ZnodeSearchQueryTypeFeature (SearchFeatureId,SearchQueryTypeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch'),
(select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Match Phrase Prefix'),
2,getdate(),2,GETDATE()
where not exists(select * from ZnodeSearchQueryTypeFeature
where SearchFeatureId = (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch')
and SearchQueryTypeId = (select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Match Phrase Prefix')
)

insert into ZnodeSearchQueryTypeFeature (SearchFeatureId,SearchQueryTypeId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch'),
(select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Multi Match'),
2,getdate(),2,GETDATE()
where not exists(select * from ZnodeSearchQueryTypeFeature
where SearchFeatureId = (select top 1 SearchFeatureId from ZnodeSearchFeature where FeatureCode = 'DfsQueryThenFetch')
and SearchQueryTypeId = (select top 1 SearchQueryTypeId from ZnodeSearchQueryType where QueryTypeName = 'Multi Match')
)
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
			 ALTER TABLE ##CustomerUserAddDetail ADD AddressId Int

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



if exists(select * from sys.procedures where name = 'ZnodeReport_DashboardLowInventoryProductCount')
	drop proc ZnodeReport_DashboardLowInventoryProductCount
go
CREATE PROCEDURE [dbo].[ZnodeReport_DashboardLowInventoryProductCount]
(
	 @PortalId       VARCHAR(MAX)  = '',
	 @BeginDate      DATE          = NULL,
	 @EndDate        DATE          = NULL
)
AS
	/* Summary : -This Procedure is used to get the dashboard report on basis of portal 
	 Unit Testing 
	 EXEC ZnodeReport_DashboardLowInventoryProductCOunt
	 
	*/
 BEGIN 
	BEGIN TRY
	SET NOCOUNT ON
             DECLARE @TBL_ProtalIds TABLE(PortalId INT);
			 DECLARE @CountDetail INT = 0 
             --INSERT INTO @TBL_SKUs
             --       SELECT item
             --       FROM dbo.split(@SKUs, ',');
             INSERT INTO @TBL_ProtalIds
                    SELECT item
                    FROM dbo.split(@PortalId, ',');
             DECLARE @TLB_SKUSumInventory TABLE
             (SKU          VARCHAR(600),
              Quantity     NUMERIC(28, 6),
              ReOrderLevel NUMERIC(28, 6),
              PortalId     INT
             );
           
			 CREATE TABLE #TBL_AllwareHouseToportal 
             (WarehouseId       INT,
              PortalId          INT,
              PortalWarehouseId INT
			  
             );

			 CREATE INDEX idx_#TBL_AllwareHouseToportal ON #TBL_AllwareHouseToportal(WarehouseId)

             INSERT INTO #TBL_AllwareHouseToportal
                    SELECT ZPw.WarehouseId,
                           zp.PortalId,
                           zpw.PortalWarehouseId
                    FROM [dbo].ZnodePortal AS zp
                         INNER JOIN [ZnodePortalWarehouse] AS zpw ON(zpw.PortalId = zp.PortalId)
                    WHERE EXISTS
                    (
                        SELECT TOP 1 1
                        FROM @TBL_ProtalIds AS tp
                        WHERE tp.PortalId = zp.PortalId OR @PortalId= ''
                    );

             INSERT INTO #TBL_AllwareHouseToportal
                    SELECT zpaw.WarehouseId,
                           a.PortalId,
                           zpaw.PortalWarehouseId
                    FROM [dbo].[ZnodePortalAlternateWarehouse] AS zpaw
                         INNER JOIN #TBL_AllwareHouseToportal AS a ON(zpaw.PortalWarehouseId = a.PortalWarehouseId);
  
			 
		   SELECT ZI.SKU , zpw.PortalId,ZW.WarehouseName,ZP.StoreName ,zi.Quantity,Zi.ReOrderLevel
           into #AllwareHouseToportalCnt
		   FROM #TBL_AllwareHouseToportal AS zpw
            INNER JOIN #TBL_AllwareHouseToportal AS ziw ON(ziw.WarehouseId = zpw.WarehouseId)
            INNER JOIN [dbo].[ZnodeInventory] AS ZI ON(zi.WarehouseId = ziw.WarehouseId)
			INNER JOIN ZnodeWareHouse ZW ON (ZW.WarehouseId = ziw.WarehouseId)
			INNER JOIN ZnodePortal ZP ON (ZP.PortalId = ZPW.PortalId)

		    create index idx_#AllwareHouseToportalCnt_SKU on #AllwareHouseToportalCnt (SKU)
		    
			select top 1 @CountDetail =  COUNT(*)Over()
			from #AllwareHouseToportalCnt a
			INNER JOIN dbo.ZnodePublishProductDetail ZPPD ON (ZPPD.SKU = a.SKU)
            GROUP BY a.SKU , a.PortalId,ZPPD.ProductName,a.WarehouseName,a.StoreName 
		    HAVING SUM(ISNULL(a.Quantity, 0)) <= SUM(ISNULL(a.ReOrderLevel, 0))

		   SELECT @CountDetail  ProductCount
		END TRY
		BEGIN CATCH
		DECLARE @Status BIT ;
		     SET @Status = 0;
		     DECLARE @Error_procedure VARCHAR(1000)= ERROR_PROCEDURE(), @ErrorMessage NVARCHAR(MAX)= ERROR_MESSAGE(), @ErrorLine VARCHAR(100)= ERROR_LINE(),
			 @ErrorCall NVARCHAR(MAX)= 'EXEC ZnodeReport_DashboardLowInventoryProductCount @PortalId = '+@PortalId+',@BeginDate='+CAST(@BeginDate AS VARCHAR(200))+',@EndDate='+CAST(@EndDate AS VARCHAR(200))+',@Status='+CAST(@Status AS VARCHAR(10));
              			 
             SELECT 0 AS ID,CAST(0 AS BIT) AS Status;                    
		  
             EXEC Znode_InsertProcedureErrorLog
				@ProcedureName = 'ZnodeReport_DashboardLowInventoryProductCount',
				@ErrorInProcedure = @Error_procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorLine = @ErrorLine,
				@ErrorCall = @ErrorCall;
		END CATCH

END
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
update ZnodeActions set ControllerName = 'WebSite' where ControllerName = 'WebSite ' and ActionName = 'ManageMediaWidgetConfiguration'
go


Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'Template','DownloadTemplate',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'Template' and ActionName = 'DownloadTemplate')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Page Templates' AND ControllerName = 'Template')
   ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Template' and ActionName= 'DownloadTemplate') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
    (select TOP 1 MenuId from ZnodeMenu where MenuName = 'Page Templates' AND ControllerName = 'Template') and ActionId =
    (select TOP 1 ActionId from ZnodeActions where ControllerName = 'Template' and ActionName= 'DownloadTemplate') )

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Page Templates' AND ControllerName = 'Template'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Template' and ActionName= 'DownloadTemplate')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'Page Templates' AND ControllerName = 'Template') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'Template' and ActionName= 'DownloadTemplate'))
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'TouchPointConfiguration','GetUnAssignedTouchPointsList',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName = 'GetUnAssignedTouchPointsList')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration')
   ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'GetUnAssignedTouchPointsList') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
    (select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration') and ActionId =
    (select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'GetUnAssignedTouchPointsList') )

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'GetUnAssignedTouchPointsList')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'GetUnAssignedTouchPointsList'))
go
Insert  INTO ZnodeActions (AreaName,ControllerName,ActionName,IsGlobalAccess,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
select NULL ,'TouchPointConfiguration','AssignTouchPointToActiveERP',0,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName = 'AssignTouchPointToActiveERP')

insert into ZnodeActionMenu ( MenuId, ActionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration')
   ,(select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'AssignTouchPointToActiveERP') ,2,Getdate(),2,Getdate()
where not exists (select * from ZnodeActionMenu where MenuId =
    (select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration') and ActionId =
    (select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'AssignTouchPointToActiveERP') )

insert into ZnodeMenuActionsPermission ( MenuId, ActionId, AccessPermissionId, CreatedBy ,CreatedDate, ModifiedBy, ModifiedDate )
select
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration'),
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'AssignTouchPointToActiveERP')
,1,2,Getdate(),2,Getdate() where not exists
(select * from ZnodeMenuActionsPermission where MenuId =
(select TOP 1 MenuId from ZnodeMenu where MenuName = 'ERP Configuration' AND ControllerName = 'TouchPointConfiguration') and ActionId =
(select TOP 1 ActionId from ZnodeActions where ControllerName = 'TouchPointConfiguration' and ActionName= 'AssignTouchPointToActiveERP'))
