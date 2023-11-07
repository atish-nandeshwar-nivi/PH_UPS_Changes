using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Services;
using Znode.Engine.Api.Models;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.Admin;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.WebStore.Custom
{
    public class PHCategoryController : CategoryController
    {
        #region Private Readonly members
        private readonly IProductAgent _productAgent;
        private readonly ICategoryAgent _categoryAgent;
        private readonly IWidgetDataAgent _widgetDataAgent;
        private readonly IPublishProductHelper publishProductHelper;
        #endregion

        #region Public Constructor
        public PHCategoryController(IProductAgent productAgent,ICategoryAgent categoryAgent, IWidgetDataAgent widgetDataAgent): base(categoryAgent, widgetDataAgent)
        {
            _categoryAgent = categoryAgent;
            _widgetDataAgent = widgetDataAgent;
            publishProductHelper = ZnodeDependencyResolver.GetService<IPublishProductHelper>();
            _productAgent = productAgent;
        }
        #endregion

        /// <summary>
        /// Added code for getting Tier Price and Inventory data
        /// </summary>
        /// <param name="category"></param>
        /// <param name="categoryId"></param>
        /// <param name="viewAll"></param>
        /// <param name="fromSearch"></param>
        /// <param name="publishState"></param>
        /// <param name="bindBreadcrumb"></param>
        /// <param name="facetGroup"></param>
        /// <param name="sort"></param>
        /// <param name="localeId"></param>
        /// <param name="profileId"></param>
        /// <param name="accountId"></param>
        /// <param name="catalogId"></param>
        /// <returns></returns>
        [ChildActionOnly]
        [WebMethod(EnableSession = true)]
        [ZnodeOutputCache(Duration = 3600, VaryByParam = "categoryId;publishState;viewAll;facetGroup;pageSize;pageNumber;sort;profileId;localeId;accountId;catalogId")]
        public ActionResult PHCategoryContent(string category, int categoryId = 0, bool? viewAll = false, bool fromSearch = false, string publishState = "PRODUCTION", bool bindBreadcrumb = true, string facetGroup = "", string sort = "", int localeId = 0, int profileId = 0, int accountId = 0, int catalogId = 0)
        {
            if (viewAll.Value)
                SessionHelper.SaveDataInSession<bool>(WebStoreConstants.ViewAllMode, true);
            else
                SessionHelper.RemoveDataFromSession(WebStoreConstants.ViewAllMode);

            CategoryViewModel ViewModel = _categoryAgent.GetCategorySeoDetails(categoryId, bindBreadcrumb);

            if (bindBreadcrumb)
                _categoryAgent.GetBreadCrumb(ViewModel);

            if (!fromSearch)
                //Remove Facet from Session.
                _categoryAgent.RemoveFromSession(ZnodeConstant.FacetsSearchFields);

            if (HelperUtility.IsNotNull(ViewModel.SEODetails))
            {
                ViewBag.Title = ViewModel.SEODetails.SEOTitle;
                TempData["Title"] = ViewModel.SEODetails.SEOTitle;
                TempData["Keywords"] = ViewModel.SEODetails.SEOKeywords;
                TempData["Description"] = ViewModel.SEODetails.SEODescription;
                TempData["CanonicalURL"] = ViewModel.SEODetails.CanonicalURL;
                TempData["RobotTag"] = string.IsNullOrEmpty(ViewModel.SEODetails.RobotTag) || ViewModel.SEODetails.RobotTag.ToLower() == "none" ? string.Empty : ViewModel.SEODetails.RobotTag?.Replace("_", ",");
            }
            Dictionary<string, object> searchProperties = GetSearchProperties();
            ViewModel.ProductListViewModel = _widgetDataAgent.GetCategoryProducts(new WidgetParameter { CMSMappingId = categoryId, TypeOfMapping = ViewModel.CategoryName, LocaleId = PortalAgent.LocaleId, properties = searchProperties }
            );

            //Nivi Code Start 
            if(ViewModel.ProductListViewModel.Products != null && ViewModel.ProductListViewModel?.Products.Count > 0)
            {
                var priceList = GetPriceTiersList(ViewModel.ProductListViewModel.Products);
                //Add Tier Price List for each sku
                ViewModel.ProductListViewModel.Products.ForEach(x => x.TierPriceList = priceList.FirstOrDefault(y => y.sku==x.SKU).TierPriceList);
            }
            //Nivi Code end

            return PartialView("_ProductListContent", ViewModel);
        }

        
        private List<ProductPriceViewModel> GetPriceTiersList(List<ProductViewModel> Products)
        {
            //List<PriceTierModel> list = new List<PriceTierModel>();
            List<ProductPriceViewModel> productSku = new List<ProductPriceViewModel>();
            //foreach(ProductViewModel p in Products)
            //{
            //    var price = new ProductPriceViewModel
            //    {
            //        sku = p.SKU,
            //        PublishProductId = p.PublishProductId,
            //        type = p.ProductType,
            //        PriceView = p.PriceView,
            //        ObsoleteClass = p.ObsoleteClass,
            //        MinQuantity = p.MinQuantity
            //    };
            //    productSku.Add(price);
            //}
            Products.ForEach(x =>
            {
                productSku.Add(new ProductPriceViewModel()
                {
                    sku = x.SKU,
                    PublishProductId = x.PublishProductId,
                    type = x.ProductType,
                    PriceView = x.PriceView,
                    ObsoleteClass = x.ObsoleteClass,
                    MinQuantity = x.MinQuantity
                });
            });

            List<ProductPriceViewModel> productPriceViewModel = _productAgent.GetPriceWithInventory(productSku);

           return productPriceViewModel;
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            filterContext.ExceptionHandled = true;

            var error = filterContext.Exception.Message;
            //Log the error!!
            //_Logger.Error(filterContext.Exception);

            //Redirect or return a view, but not both.
            filterContext.Result = RedirectToAction("Index", "ErrorHandler");
            // OR 
            //filterContext.Result = new ViewResult
            //{
            //    ViewName = "~/Views/Themes/EquinaviaB2C/Views/Shared/ErrorPage.cshtml"
            //};
        }


    }
}
