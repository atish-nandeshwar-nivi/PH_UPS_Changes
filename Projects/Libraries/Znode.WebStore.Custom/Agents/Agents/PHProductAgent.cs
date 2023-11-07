using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Znode.Api.Model.Custom;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.klaviyo.Models;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Klaviyo.Helper;
using Znode.Libraries.Resources;
using Znode.Sample.Api.Model.Responses;
using Znode.WebStore.Custom.Clients.Clients;

namespace Znode.Webstore.Custom.Agents
{
    public class PHProductAgent : ProductAgent, IProductAgent
    {
        #region Private member
        private readonly ICustomerReviewClient _reviewClient;
        private readonly IPublishProductClient _productClient;
        private readonly IWebStoreProductClient _webstoreProductClient;
        private readonly ISearchClient _searchClient;
        private readonly IHighlightClient _highlightClient;
        private readonly IPublishCategoryClient _publishCategoryClient;
        #endregion

        #region Constructor
        public PHProductAgent(ICustomerReviewClient reviewClient, IPublishProductClient productClient, IWebStoreProductClient webstoreProductClient, ISearchClient searchClient, IHighlightClient highlightClient, IPublishCategoryClient publishCategoryClient)
        : base( reviewClient,  productClient,  webstoreProductClient,  searchClient,  highlightClient,  publishCategoryClient)
        {
            _reviewClient = GetClient<ICustomerReviewClient>(reviewClient);
            _productClient = GetClient<IPublishProductClient>(productClient);
            _webstoreProductClient = GetClient<IWebStoreProductClient>(webstoreProductClient);
            _searchClient = GetClient<ISearchClient>(searchClient);
            _highlightClient = GetClient<IHighlightClient>(highlightClient);
            _publishCategoryClient = GetClient<IPublishCategoryClient>(publishCategoryClient);
        }
        #endregion

        #region Public methods
        //CUSTOMIZATION ADDING GetAutoCompleteItemPropertiesForMultiples to include QtyPerShipUnit attribute
        //public AutoComplete GetAutoCompleteProductProperties(int productId)
        //{
        //    AutoComplete _item = new AutoComplete();

        //    //Get published product by product ID.
        //    _productClient.SetProfileIdExplicitly(Helper.GetProfileId().GetValueOrDefault());
        //    PublishProductModel product = _productClient.GetPublishProduct(productId, GetRequiredFilters(), GetProductInventoryExpands());

        //    if (HelperUtility.IsNotNull(product))
        //    {
        //        ProductViewModel productViewModel = product.ToViewModel<ProductViewModel>();

        //        bool? isCallForPricing = false;
        //        if (!Convert.ToBoolean(product.Attributes.Where(x => x.AttributeCode == ZnodeConstant.CallForPricing)?.FirstOrDefault()?.AttributeValues))
        //            isCallForPricing = product?.Promotions.Any(x => x.PromotionType?.Replace(" ", "") == ZnodeConstant.CallForPricing);
        //        else
        //            isCallForPricing = Convert.ToBoolean(product.Attributes.Where(x => x.AttributeCode == ZnodeConstant.CallForPricing)?.FirstOrDefault()?.AttributeValues);

        //        List<GroupProductViewModel> associatedProductList = GetGroupProductList(productId);
        //        if (associatedProductList.Any())
        //        {
        //            _item.Properties.Add("GroupProductSKUs", string.Join(",", associatedProductList.Select(x => x.SKU)));
        //            _item.Properties.Add("GroupProductsQuantity", associatedProductList.Select(x => x.SKU).Count().ToString());
        //        }

        //        _item.DisplayText = product.SKU;
        //        _item.Id = product.PublishProductId;
        //        _item.Properties.Add("InventoryMessage", GetInventoryMessage(productViewModel));

        //        _item.Properties.Add("CartQuantity", GetOrderedItemQuantity(product.SKU));
        //        _item.Properties.Add("ProductName", product.Name);
        //        _item.Properties.Add("Quantity", product.Quantity);
        //        _item.Properties.Add("ProductType", productViewModel.Attributes.SelectAttributeList(ZnodeConstant.ProductType)?.FirstOrDefault()?.Code);
        //        _item.Properties.Add("CallForPricing", isCallForPricing);
        //        _item.Properties.Add("TrackInventory", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.OutOfStockOptions)?.FirstOrDefault()?.AttributeValues);
        //        _item.Properties.Add("OutOfStockMessage", string.IsNullOrEmpty(product.OutOfStockMessage) ? WebStore_Resources.TextOutofStock : product.OutOfStockMessage);
        //        _item.Properties.Add("MaxQuantity", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.MaximumQuantity)?.FirstOrDefault()?.AttributeValues);
        //        _item.Properties.Add("MinQuantity", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.MinimumQuantity)?.FirstOrDefault()?.AttributeValues);
        //        _item.Properties.Add("RetailPrice", product.RetailPrice);
        //        _item.Properties.Add("ImagePath", product.ImageSmallPath);
        //        _item.Properties.Add("IsPersonisable", productViewModel.Attributes.Where(x => x.IsPersonalizable == true).Select(x => x.IsPersonalizable).FirstOrDefault());
        //        _item.Properties.Add("ConfigurableProductSKUs", product.ConfigurableProductSKU);
        //        _item.Properties.Add("AutoAddonSKUs", string.Join(",", product.AddOns.Where(x => x.IsAutoAddon)?.Select(y => y.AutoAddonSKUs)));
        //        _item.Properties.Add("InvetoryCode", GetOutOfStockOptionsAttributeList(productViewModel)?.FirstOrDefault().Code);

        //        var qtyAttributeValue = product?.Attributes?.Where(x => x.AttributeCode == "QtyPerShipUnit")?.FirstOrDefault()?.AttributeValues;
        //        var priceUnitDescription = product?.Attributes?.Where(x => x.AttributeCode == "PriceUnit")?.FirstOrDefault()?.SelectValues[0]?.Value;
        //        var QtyPerShipUnitValue = !string.IsNullOrEmpty(qtyAttributeValue) && string.Equals(priceUnitDescription, "Each", StringComparison.OrdinalIgnoreCase) ? Convert.ToDecimal(qtyAttributeValue) : 1;
        //        _item.Properties.Add("QtyPerShipUnit", QtyPerShipUnitValue);
        //    }

        //    return _item;
        //}

        //Nivi code overriden to set Price per unit on cart
        public AutoComplete GetAutoCompleteProductProperties(int productId)
        {
            AutoComplete _item = new AutoComplete();

            //Get published product by product ID.
            _productClient.SetProfileIdExplicitly(Helper.GetProfileId().GetValueOrDefault());
            PublishProductModel product = _productClient.GetPublishProduct(productId, GetRequiredFilters(), GetProductInventoryExpands());

            if (HelperUtility.IsNotNull(product))
            {
                ProductViewModel productViewModel = product.ToViewModel<ProductViewModel>();

                List<AttributeValidationViewModel> attributeValidation = GetattributeValidation(productViewModel, productId);

                bool? isCallForPricing = false;
                if (!Convert.ToBoolean(product.Attributes.Where(x => x.AttributeCode == ZnodeConstant.CallForPricing)?.FirstOrDefault()?.AttributeValues))
                    isCallForPricing = product?.Promotions.Any(x => x.PromotionType?.Replace(" ", "") == ZnodeConstant.CallForPricing);
                else
                    isCallForPricing = Convert.ToBoolean(product.Attributes.Where(x => x.AttributeCode == ZnodeConstant.CallForPricing)?.FirstOrDefault()?.AttributeValues);

                List<GroupProductViewModel> associatedProductList = GetGroupProductList(productId);
                if (associatedProductList.Any())
                {
                    _item.Properties.Add("GroupProductSKUs", string.Join(",", associatedProductList.Select(x => x.SKU)));
                    _item.Properties.Add("GroupProductsQuantity", associatedProductList.Select(x => x.SKU).Count().ToString());
                }

                _item.DisplayText = product.SKU;
                _item.Id = product.PublishProductId;
                if (productViewModel.Attributes.SelectAttributeList(ZnodeConstant.ProductType)?.FirstOrDefault()?.Code == ZnodeConstant.BundleProduct)
                {
                    UpdateBundleProductInventoryQuantity(productViewModel);
                    product.Quantity = productViewModel.Quantity;
                    // Returns bool if child product out of stock setting is DisablePurchasing
                    bool isChildDisablePurchasing = productViewModel.PublishBundleProducts
                                         .Any(x => x.Attributes.SelectAttributeList(ZnodeConstant.OutOfStockOptions).FirstOrDefault().Code == ZnodeConstant.DisablePurchasing);
                    _item.Properties.Add("InventoryCode", isChildDisablePurchasing ? ZnodeConstant.DisablePurchasing : GetOutOfStockOptionsAttributeList(productViewModel)?.FirstOrDefault().Code);
                }
                else
                {
                    _item.Properties.Add("InventoryCode", GetOutOfStockOptionsAttributeList(productViewModel)?.FirstOrDefault().Code);
                }
                _item.Properties.Add("InventoryMessage", GetInventoryMessage(productViewModel));

                _item.Properties.Add("CartQuantity", GetOrderedItemQuantity(product.SKU));
                _item.Properties.Add("ProductName", product.Name);
                _item.Properties.Add("Quantity", product.Quantity);
                _item.Properties.Add("ProductType", productViewModel.Attributes.SelectAttributeList(ZnodeConstant.ProductType)?.FirstOrDefault()?.Code);
                _item.Properties.Add("CallForPricing", isCallForPricing);
                _item.Properties.Add("TrackInventory", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.OutOfStockOptions)?.FirstOrDefault()?.AttributeValues);
                _item.Properties.Add("OutOfStockMessage", string.IsNullOrEmpty(product.OutOfStockMessage) ? WebStore_Resources.TextOutofStock : product.OutOfStockMessage);
                _item.Properties.Add("MaxQuantity", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.MaximumQuantity)?.FirstOrDefault()?.AttributeValues);
                _item.Properties.Add("MinQuantity", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.MinimumQuantity)?.FirstOrDefault()?.AttributeValues);
                _item.Properties.Add("RetailPrice", product.RetailPrice);
                _item.Properties.Add("ImagePath", product.ImageSmallPath);
                _item.Properties.Add("IsPersonalisable", productViewModel.Attributes.Where(x => x.IsPersonalizable == true).Select(x => x.IsPersonalizable).FirstOrDefault());
                _item.Properties.Add("IsRequired", attributeValidation?.Where(x => x.IsRequired == true)?.Select(x => x.IsRequired)?.FirstOrDefault().ToString()?.ToLower());
                _item.Properties.Add("ConfigurableProductSKUs", product.ConfigurableProductSKU);
                _item.Properties.Add("AutoAddonSKUs", string.Join(",", product.AddOns.Where(x => x.IsAutoAddon)?.Select(y => y.AutoAddonSKUs)));
                _item.Properties.Add("IsObsolete", productViewModel.Attributes.Where(x => x.AttributeCode == ZnodeConstant.IsObsolete)?.FirstOrDefault()?.AttributeValues);
                _item.Properties.Add("IsActive", product.IsActive);
                //Nivi code start
                _item.Properties.Add("PriceUnitDescription", product?.Attributes?.Where(x => x.AttributeCode == "PriceUnit")?.FirstOrDefault()?.SelectValues[0]?.Value);
                //Nivi code end

            }

            return _item;
        }

        //Get product inventory expands.
        private ExpandCollection GetProductInventoryExpands()
        {
            ExpandCollection expands = new ExpandCollection();
            expands.Add(ExpandKeys.Inventory);
            expands.Add(ExpandKeys.Pricing);
            expands.Add(ExpandKeys.AddOns);
            expands.Add(ExpandKeys.Promotions);
            expands.Add(ExpandKeys.ConfigurableAttribute);
            return expands;
        }

        //Get Out Of Stock Options Attribute List.
        private List<AttributesSelectValuesViewModel> GetOutOfStockOptionsAttributeList(ProductViewModel viewModel)
            => viewModel.Attributes?.SelectAttributeList(ZnodeConstant.OutOfStockOptions);

        public List<string> GetFreeFreightSkuList(List<string> skuList)
        {
            //To get customer zipcode
            List<string> lstWarehouseSku = null;
            string customerPostalCode = null;
            ShoppingCartModel cart = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey);

            if (!string.IsNullOrEmpty(cart?.ShippingAddress?.PostalCode))
            {
                customerPostalCode = cart.ShippingAddress.PostalCode;
            }
            else
            {
                UserViewModel userModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey) ?? GetFromSession<UserViewModel>(WebStoreConstants.GuestUserKey);
                customerPostalCode = userModel?.ShippingAddress?.PostalCode /*?? userModel?.Addresses?.Where(x => x.IsDefaultShipping = true).FirstOrDefault()?.PostalCode*/;
                if (string.IsNullOrEmpty(customerPostalCode))
                {
                    try
                    {
                        var service = ZnodeDependencyResolver.GetService<IUserAgent>();
                        var addressList = service.GetAddressList();
                        customerPostalCode = addressList?.ShippingAddress?.PostalCode;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Customer Postal Code Retrieval Error");
                    }
                }
            }

            if (!string.IsNullOrEmpty(customerPostalCode))
            {
                FreeFreightSkuList freightSkuList = new FreeFreightSkuList
                {
                    SkuList = skuList,
                    ZipCode = customerPostalCode
                };
                FreeFreightSkuListResponse freeFreightSkuListResponse = ((PHPublishProductClient)_productClient).GetAssociatedInventory(freightSkuList);
                lstWarehouseSku = freeFreightSkuListResponse?.SkuList;
            }

            return lstWarehouseSku;
        }

        public CategoryViewModel GetProductCategory(int categoryId)
        {
            FilterCollection filters = GetRequiredFilters();
            filters.Add(WebStoreEnum.IsGetParentCategory.ToString(), FilterOperators.Equals, ZnodeConstant.TrueValue);
            filters.Add(WebStoreEnum.IsBindImage.ToString(), FilterOperators.Equals, ZnodeConstant.FalseValue);
            CategoryViewModel category = _publishCategoryClient.GetPublishCategory(categoryId, filters, new ExpandCollection { ZnodeConstant.SEO })?.ToViewModel<CategoryViewModel>();
            return category;
        }

        // Get product details associated with category
        //Klaviyo changes to avoid product view while adding to cart
        public override ProductViewModel GetProduct(int productId, bool isCategoryAssociated)
        {
            if (productId > 0)
            {
                //set user id for profile base pricing.
                _productClient.UserId = (GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey)?.UserId).GetValueOrDefault();

                _productClient.SetPublishStateExplicitly(PortalAgent.CurrentPortal.PublishState);
                _productClient.SetLocaleExplicitly(PortalAgent.CurrentPortal.LocaleId);
                _productClient.SetDomainHeaderExplicitly(GetCurrentWebstoreDomain());
                _productClient.SetProfileIdExplicitly(Helper.GetProfileId().GetValueOrDefault());
                PublishProductModel model = _productClient.GetPublishProduct(productId, SetProductFilter(isCategoryAssociated), GetProductExpands());
                if (HelperUtility.IsNotNull(model))
                {
                    ProductViewModel viewModel = model.ToViewModel<ProductViewModel>();

                    string minQuantity = viewModel.Attributes?.Value(ZnodeConstant.MinimumQuantity);

                    viewModel.MinQuantity = minQuantity;

                    decimal quantity = Convert.ToDecimal(string.IsNullOrEmpty(minQuantity) ? "0" : minQuantity);

                    viewModel.IsCallForPricing = Convert.ToBoolean(viewModel.Attributes?.Value(ZnodeConstant.CallForPricing)) || (model.Promotions?.Any(x => x.PromotionType?.Replace(" ", "") == ZnodeConstant.CallForPricing)).GetValueOrDefault();

                    viewModel.ProductType = viewModel.Attributes.CodeFromSelectValue(ZnodeConstant.ProductType);
                    viewModel.IsConfigurable = model.IsConfigurableProduct;

                    if (string.Equals(viewModel?.ProductType, ZnodeConstant.BundleProduct, StringComparison.InvariantCultureIgnoreCase))
                    {
                        UpdateBundleProductInventoryQuantity(viewModel);
                        CheckBundleProductsInventory(viewModel, 0, _productClient.UserId);
                    }
                    else
                        //Check Main Product inventory
                        CheckInventory(viewModel, quantity);

                    //Check any default addon product is selected or not.
                    string addOnSKU = string.Empty;
                    List<string> addOnProductSKU = viewModel.AddOns?.Where(x => x.IsRequired)?.Select(y => y.AddOnValues?.FirstOrDefault(x => x.IsDefault)?.SKU)?.ToList();

                    if (addOnProductSKU?.Count > 0)
                    {
                        addOnSKU = string.Join(",", addOnProductSKU.Where(x => !string.IsNullOrEmpty(x)));
                    }

                    if ((!string.IsNullOrEmpty(addOnSKU) && (HelperUtility.IsNotNull(viewModel.Quantity) && viewModel.Quantity > 0)) || (!string.IsNullOrEmpty(addOnSKU) && (Equals(viewModel.ProductType, ZnodeConstant.GroupedProduct))))
                        //Check Associated addon inventory.
                        CheckAddOnInvenTory(viewModel, addOnSKU, quantity);

                    if (!viewModel.IsCallForPricing)
                        GetProductFinalPrice(viewModel, viewModel.AddOns, quantity, addOnSKU);

                    viewModel.ParentProductId = productId;
                    viewModel.IsConfigurable = HelperUtility.IsNotNull(viewModel.Attributes?.Find(x => x.ConfigurableAttribute?.Count > 0));

                    viewModel.ParentProductImageSmallPath = model?.ParentProductImageSmallPath;

                    UpdateRecentViewedProducts(viewModel);
                    AddToRecentlyViewProduct(viewModel.ConfigurableProductId > 0 ? viewModel.ConfigurableProductId : viewModel.PublishProductId);

                    Helper.SetProductCartParameter(viewModel);

                    if (viewModel.IsConfigurable)
                        GetConfigurableValues(model, viewModel);

                    if (Convert.ToBoolean(viewModel.Attributes?.Value(ZnodeConstant.DisplayVariantsOnGrid)) && string.Equals(viewModel?.ProductType, ZnodeConstant.ConfigurableProduct, StringComparison.InvariantCultureIgnoreCase))
                        viewModel.IsConfigurable = model.IsConfigurableProduct;


                    //check if the product is added in wishlist for the logged in user. If so, binds its wishlistId
                    BindProductWishListDetails(viewModel);

                    if (PortalAgent.CurrentPortal.IsKlaviyoEnable)
                    {
                        // Created the task to post the data to klaviyo
                        //Klaviyo changes to avoid product view while adding to cart
                        HttpContext httpContext = HttpContext.Current;
                        if (httpContext.Request.AppRelativeCurrentExecutionFilePath == "~/Product/AddToCartProduct" || httpContext.Request.AppRelativeCurrentExecutionFilePath == "~/Product/CustomAddToCart")
                        {
                            return viewModel;
                        }
                        else
                        {
                            Task.Run(() =>
                            {
                                PostDataToKlaviyo(viewModel, httpContext);
                            });
                        }

                    }

                    return viewModel;
                }
            }
            throw new ZnodeException(ErrorCodes.ProductNotFound, WebStore_Resources.ErrorProductNotFound);
        }
        // Map Product model to Klaviyo Model
        // Klaviyo change to trigger Product view for Guest user
        protected override KlaviyoProductDetailModel MapProductModelToKlaviyoModel(ProductViewModel viewModel)
        {
            HttpContext httpContext = HttpContext.Current;
            var Kemail = SessionHelper.GetDataFromSession<string>("EmailForGuest");
            var KFirstName = SessionHelper.GetDataFromSession<string>("FirstNameForGuest");
            if (String.IsNullOrEmpty(Kemail) && String.IsNullOrEmpty(KFirstName))
            {
                Kemail = Convert.ToString(httpContext.Request.Cookies["KlaviyoEmail"]?.Value);
                KFirstName = Convert.ToString(httpContext.Request.Cookies["KlaviyoFirstName"]?.Value);
            }
            EcommerceDataViewModel ecommerceDataViewModel = viewModel.GetEcommerceDetailsOfProduct();
            KlaviyoProductDetailModel klaviyoProductDetailModel = new KlaviyoProductDetailModel();
            klaviyoProductDetailModel.OrderLineItems = new List<OrderLineItemDetailsModel>();
            klaviyoProductDetailModel.PortalId = PortalAgent.CurrentPortal.PortalId;
            UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);
            if (httpContext.Request.IsAuthenticated != true)
            {
                klaviyoProductDetailModel.Email = Kemail;
                klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
                klaviyoProductDetailModel.PropertyType = (int)KlaviyoEventType.ProductEvent;
                klaviyoProductDetailModel.FirstName = KFirstName;
                klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = ecommerceDataViewModel.Name, SKU = viewModel.SKU, UnitPrice = Convert.ToDecimal(viewModel?.UnitPrice), Image = viewModel.ImageSmallPath });
                return klaviyoProductDetailModel;
            }
            klaviyoProductDetailModel.FirstName = userViewModel?.FirstName;
            klaviyoProductDetailModel.LastName = userViewModel?.LastName;
            klaviyoProductDetailModel.Email = userViewModel?.Email;
            klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
            klaviyoProductDetailModel.PropertyType = (int)KlaviyoEventType.ProductEvent;
            klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = ecommerceDataViewModel.Name, SKU = viewModel.SKU, UnitPrice = Convert.ToDecimal(viewModel?.UnitPrice), Image = viewModel.ImageSmallPath });
            return klaviyoProductDetailModel;
        }
        /// <summary>
        /// To update recent view products
        /// </summary>
        /// <param name="viewModel"></param>
        private void UpdateRecentViewedProducts(ProductViewModel viewModel)
        {
            RecentViewModel recentViewModel = new RecentViewModel()
            {
                ImageSmallPath = viewModel.ConfigurableProductId > 0 ? HttpUtility.UrlEncode(viewModel.ParentProductImageSmallPath) : HttpUtility.UrlEncode(viewModel.ImageSmallPath),
                PublishProductId = viewModel.ConfigurableProductId > 0 ? viewModel.ConfigurableProductId : viewModel.PublishProductId,
                SalesPrice = viewModel.SalesPrice,
                Name = viewModel.ConfigurableProductId > 0 ? viewModel.ParentConfiguarableProductName : viewModel.Name,
                SEOUrl = viewModel.SEOUrl,
                SKU = viewModel.SKU,
                ProductType = viewModel.ProductType,
                CultureCode = viewModel.CultureCode,
                PromotionalPrice = viewModel.PromotionalPrice,
                UOM = Attributes.ValueFromSelectValue(viewModel?.Attributes, ZnodeConstant.UOM),
                RetailPrice = viewModel.RetailPrice,
                Rating = viewModel.Rating,
                Attributes = viewModel.Attributes,
                Promotions = viewModel.Promotions

            };

            int maxItemToDisplay = 15;
            List<RecentViewModel> storedValues = new List<RecentViewModel>();
            try
            {
                List<RecentViewModel> recentViewProductCookie = GetFromSession<List<RecentViewModel>>("RecentViewProduct");

                if (recentViewProductCookie == null || recentViewProductCookie?.Count == 0)
                {
                    storedValues.Add(recentViewModel);
                    SaveInSession(ZnodeConstant.RecentViewProduct, storedValues);
                }
                else
                {
                    int publishProductId = viewModel.ConfigurableProductId > 0 ? viewModel.ConfigurableProductId : viewModel.PublishProductId;
                    storedValues = recentViewProductCookie;

                    if (!storedValues.Where(x => x.PublishProductId == publishProductId).Any())
                    {
                        storedValues.Insert(0, recentViewModel);
                        if (storedValues.Count() > maxItemToDisplay)
                        {
                            storedValues.RemoveAt(storedValues.Count - 1);
                        }
                        SaveInSession(ZnodeConstant.RecentViewProduct, storedValues);
                    }
                }
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.Inventory.ToString(), TraceLevel.Error);
            }
        }

        private void AddToRecentlyViewProduct(int productId)
        {
            if (productId > 0)
            {
                List<string> productIds = GetFromSession<List<string>>(ZnodeConstant.RecentlyViewProducts);
                if (!IsProductExistInList(productIds, Convert.ToString(productId)))
                    SetMaxRecentProductInSession(Convert.ToString(productId));
            }
        }
        //Check if product already exist in recently view product list.
        private bool IsProductExistInList(List<string> productIds, string productId)
        {
            if (productIds?.Count > 0)
                return productIds.Contains(productId) ? true : false;

            return false;
        }

        //Check for max limit of recently view product.
        private void SetMaxRecentProductInSession(string productId)
        {
            //List of product ids from cookies
            List<string> productIds = GetFromSession<List<string>>(ZnodeConstant.RecentlyViewProducts);

            if (HelperUtility.IsNull(productIds))
                productIds = new List<string>();

            productIds.Add(productId);

            int maxItemToDisplay = /*MvcDemoConstants.MaxRecentViewItemToDisplay*/15;

            //If exceed of max limit of recently view product remove last product from list.
            if (productIds.Count > maxItemToDisplay)
                for (int count = 0; count < productIds.Count - maxItemToDisplay; count++)
                    productIds.RemoveAt(0);

            if (productIds.Count > 0)
                SaveInSession(ZnodeConstant.RecentlyViewProducts, productIds);
        }

        private void GetConfigurableValues(PublishProductModel model, ProductViewModel viewModel)
        {
            viewModel.ConfigurableData = new ConfigurableAttributeViewModel();
            //Select Is Configurable Attributes list
            viewModel.ConfigurableData.ConfigurableAttributes = viewModel.Attributes.Where(x => x.IsConfigurable && x.ConfigurableAttribute?.Count > 0).ToList();
            //Assign select attribute values.
            if (model.IsDefaultConfigurableProduct)
                viewModel.ConfigurableData.ConfigurableAttributes.ForEach(x => x.SelectedAttributeValue = new[] { x?.AttributeValues });
            else
                viewModel.ConfigurableData.ConfigurableAttributes.ForEach(x => x.SelectedAttributeValue = new[] { x.ConfigurableAttribute?.FirstOrDefault()?.AttributeValue });
        }
        #endregion
    }
}