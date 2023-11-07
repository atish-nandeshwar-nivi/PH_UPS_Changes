using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using Znode.Engine.Services;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.Admin;
using Znode.Libraries.Data;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Engine.Api.Models;
using System.Collections.Specialized;
using Znode.Libraries.Framework.Business;
using System.Diagnostics;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using System.Data;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;

namespace Znode.Api.Custom.Service.Service
{
    public class PHPublishProductService : PublishProductService, IPublishProductService
    {
        private readonly ISearchService searchService;

        #region Constructor
        public PHPublishProductService() : base()
        {
            searchService = GetService<ISearchService>();
        }
        #endregion

        #region public methods
        //Calls One time from PDP page.
        /// <summary>
        /// Overidden to get All location inventory of product
        /// </summary>
        /// <param name="publishProductId"></param>
        /// <param name="filters"></param>
        /// <param name="expands"></param>
        /// <returns></returns>
        public override PublishProductModel GetPublishProduct(int publishProductId, FilterCollection filters, NameValueCollection expands)
        {
            PublishProductModel publishProduct = base.GetPublishProduct(publishProductId, filters, expands);
            /* Nivi Code start */
            DataTable tableDetails = searchService.GetProductFiltersForSP(new List<dynamic>());
            tableDetails.Rows.Add(publishProductId.ToString(), "SimpleProduct", "DontTrackInventory", publishProduct.SKU);
            IList<PublishCategoryProductDetailModel> productDetails = GetProductInventoryDetails(tableDetails, GetLoginUserId(), GetPortalId(), true);
            publishProduct.Inventory = GetAllLocationsInventoryForProduct(publishProduct.SKU, productDetails);
            /* Nivi Code end */
            return publishProduct;
        }
        #endregion



        #region private method
        private IList<PublishCategoryProductDetailModel> GetProductInventoryDetails(DataTable tableDetails, int userId = 0, int portalId = 0, bool isSendAllLocations = false)
        {
            IZnodeViewRepository<PublishCategoryProductDetailModel> objStoredProc = new ZnodeViewRepository<PublishCategoryProductDetailModel>();
            objStoredProc.SetParameter("@PortalId", portalId, ParameterDirection.Input, DbType.Int32);
            objStoredProc.SetParameter("@LocaleId", Convert.ToInt32(DefaultGlobalConfigSettingHelper.Locale), ParameterDirection.Input, DbType.Int32);
            objStoredProc.SetParameter("@UserId", userId, ParameterDirection.Input, DbType.Int32);
            objStoredProc.SetParameter("@currentUtcDate", HelperUtility.GetDateTime().Date, ParameterDirection.Input, DbType.String);
            objStoredProc.SetTableValueParameter("@ProductDetailsFromWebStore", tableDetails, ParameterDirection.Input, SqlDbType.Structured, "dbo.ProductDetailsFromWebStore");
            objStoredProc.SetParameter("@IsAllLocation", isSendAllLocations, ParameterDirection.Input, DbType.Boolean);
            //Gets the entity list according to where clause, order by clause and pagination
            return objStoredProc.ExecuteStoredProcedureList("Znode_GetProductWarehouseDetailInfoForWebStoreIndexing @PortalId,@LocaleId,@UserId,@currentUtcDate,@ProductDetailsFromWebStore,@IsAllLocation");
        }

        private List<InventorySKUModel> GetAllLocationsInventoryForProduct(string ProductSKU, IList<PublishCategoryProductDetailModel> productDetails)
        {
            List<InventorySKUModel> productInventoryList = new List<InventorySKUModel>();
            List<PublishCategoryProductDetailModel> products = productDetails?.Where(x => x.SKU == ProductSKU)?.ToList();
            foreach (PublishCategoryProductDetailModel product in products)
            {
                productInventoryList.Add(new InventorySKUModel() { Quantity = product.Quantity.GetValueOrDefault(), WarehouseName = product.WarehouseName, IsDefaultWarehouse = product.IsDefaultWarehouse });
            }
            return productInventoryList;
        }
        #endregion


    }
}
