using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Znode.Engine.Api.Models;
using Znode.Engine.Core.ViewModels;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Resources;
using Znode.Webstore.Custom.Agents;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;

namespace Znode.WebStore.Custom
{
    public class PHProductController :  ProductController
    {
        #region Private Readonly members
        private readonly IProductAgent _productAgent;
        private readonly IUserAgent _accountAgent;
        private readonly IAttributeAgent _attributeAgent;
        private readonly ICartAgent _cartAgent;
        private const string ComparableProductsView = "_ComparableProducts";
        private const string ProductComparePopup = "_ProductComparePopup";
        private const string SendMailPopUp = "_SendMailView";
        private readonly IWidgetDataAgent _widgetDataAgent;
        #endregion

        public PHProductController(IProductAgent productAgent, IUserAgent userAgent, ICartAgent cartAgent, IWidgetDataAgent widgetDataAgent, IAttributeAgent attributeAgent, IRecommendationAgent recommendationAgent)
            : base(productAgent, userAgent, cartAgent, widgetDataAgent, attributeAgent, recommendationAgent)
        {
            _productAgent = productAgent;
            _accountAgent = userAgent;
            _cartAgent = cartAgent;
            _widgetDataAgent = widgetDataAgent;
            _attributeAgent = attributeAgent;
        }

        /// <summary>
        /// Overide to get Category data
        /// </summary>
        /// <param name="id"></param>
        /// <param name="seo"></param>
        /// <param name="isQuickView"></param>
        /// <param name="publishState"></param>
        /// <param name="localeId"></param>
        /// <param name="profileId"></param>
        /// <param name="accountId"></param>
        /// <param name="catalogId"></param>
        /// <returns></returns>
        [ChildActionOnly]
        [ZnodeOutputCache(Duration = 3600, VaryByParam = "id;publishState;profileId;localeId;accountId;catalogId")]
        public override ActionResult DetailsContent(int id = 0, string seo = "", bool isQuickView = false, string publishState = "PRODUCTION", int localeId = 0, int profileId = 0, int accountId = 0, int catalogId = 0)
        {
            ViewBag.IsLite = false;
            ProductViewModel product = _productAgent.GetProduct(id, true);
            if (IsNull(product))
                return Redirect("/404");

            product.ProductTemplateName = string.IsNullOrEmpty(product.ProductTemplateName) || Equals(product.ProductTemplateName, ZnodeConstant.ProductDefaultTemplate) ? "Details" : product.ProductTemplateName;

            /* Nivi code start */
            if (product.ZnodeProductCategoryIds?.FirstOrDefault() > 0)
            {
                CategoryViewModel categoryViewModel = ((PHProductAgent)_productAgent).GetProductCategory(product.ZnodeProductCategoryIds.FirstOrDefault());
                product.CategoryHierarchy = new List<CategoryViewModel> { categoryViewModel };
            }
            /* Nivi code end */

            return PartialView(product.ProductTemplateName, product);
        }


        [HttpPost]
        [Route("Product/CustomAddToCart")]
        public ActionResult CustomAddToCart(int ProductId, decimal Quantity)
        {
            bool hasError = true;
            if (Quantity <= 0)
            {
                return Json(new { status = hasError });
            }
            ProductViewModel product = _productAgent.GetProduct(ProductId);

            if (Equals(product, null) || Equals(product.ProductPrice, null) || product.ProductPrice <= 0)
            {
                return Json(new { status = hasError });
            }

            int qtyAttributeValue;
            var priceUnitDescription = product?.Attributes?.Where(x => x.AttributeCode == "PriceUnit")?.FirstOrDefault()?.SelectValues[0]?.Value;

            if (string.Equals(priceUnitDescription, "Each", StringComparison.OrdinalIgnoreCase))
            {
                Int32.TryParse(product?.Attributes?.Where(x => x.AttributeCode == "QtyPerShipUnit")?.FirstOrDefault()?.AttributeValues, out qtyAttributeValue);
                if (qtyAttributeValue > 0 && (Quantity % qtyAttributeValue) != 0)
                { return Json(new { status = true, errorMessage = "Quantity must be in multiple of " + qtyAttributeValue.ToString() }); }
            }

            AddToCartViewModel cartItem = new AddToCartViewModel
            {
                ProductId = ProductId.ToString(),
                Quantity = Quantity,
                ConfigurableProductSKUs = product.ConfigurableProductSKU,
                SKU = product.SKU,
                ProductType = product.ProductType
            };

            AddToCartViewModel ShoppingCart = _cartAgent.AddToCartProduct(cartItem);

            return Json(new { status = ShoppingCart.HasError, cartCount = ShoppingCart.CartCount, Product = ShoppingCart?.ShoppingCartItems?.FirstOrDefault(x => x.SKU == cartItem.SKU), ImagePath = $"{MediaPaths.MediaThumbNailPath}/{ShoppingCart?.ShoppingCartItems?.FirstOrDefault(x => x.SKU == cartItem.SKU)?.Product.Attributes.FirstOrDefault(x => x.AttributeCode == ZnodeConstant.ProductImage)?.AttributeValues}" }, JsonRequestBehavior.AllowGet);

        }

        //Add product in the cart.
        public override ActionResult AddToCartProduct(AddToCartViewModel cartItem, bool IsRedirectToCart = true)
        {
            AddToCartViewModel ShoppingCart = _cartAgent.AddToCartProduct(cartItem);
            ShoppingCartItemModel productDetail = ShoppingCart?.ShoppingCartItems?.FirstOrDefault(x => x.SKU == cartItem.SKU);
            string imagePath = $"{PortalAgent.CurrentPortal.ImageThumbnailUrl}{productDetail?.Product?.Attributes?.FirstOrDefault(x => x.AttributeCode == ZnodeConstant.ProductImage)?.AttributeValues}";
            if (IsNotNull(cartItem) && !string.IsNullOrEmpty(imagePath))
            {
                cartItem.Image = imagePath;
            }
            if (IsRedirectToCart)
                return RedirectToAction<CartController>(x => x.Index());
            ProductViewModel product = _productAgent.GetProduct(Convert.ToInt32(cartItem.ProductId));

            if (Equals(product, null) || Equals(product.ProductPrice, null) || product.ProductPrice <= 0)
            {
                return Json(new { status = true });
            }


            int qtyAttributeValue;
            var priceUnitDescription = product?.Attributes?.Where(x => x.AttributeCode == "PriceUnit")?.FirstOrDefault()?.SelectValues[0]?.Value;

            if (string.Equals(priceUnitDescription, "Each", StringComparison.OrdinalIgnoreCase))
            {
                Int32.TryParse(product?.Attributes?.Where(x => x.AttributeCode == "QtyPerShipUnit")?.FirstOrDefault()?.AttributeValues, out qtyAttributeValue);
                if (qtyAttributeValue > 0 && (cartItem.Quantity % qtyAttributeValue) != 0)
                {
                    return Json(new
                    {
                        status = true,
                        errorMessage = "Quantity must be in multiple of " + qtyAttributeValue.ToString()
                    });
                }
            }

            return Json(new
            {
                status = ShoppingCart?.HasError,
                cartCount = ShoppingCart?.CartCount,
                Product = productDetail,
                ImagePath = imagePath,
                CartNotification = _cartAgent.BindAddToCartNotification(cartItem)
            }, JsonRequestBehavior.AllowGet);
        }

        //Nivi code overriden to set Price per unit on cart
        public override ActionResult GetAutoCompleteItemProperties(int productId)
        => Json(_productAgent.GetAutoCompleteProductProperties(productId), JsonRequestBehavior.AllowGet);


        [HttpPost]
        public override ActionResult AddMultipleProductsToCart(List<CartItemViewModel> cartItems)
        {
            string errorMessage = _cartAgent.AddMultipleProductsToCart(cartItems);
            return Json(new
            {
                isSuccess = string.IsNullOrEmpty(errorMessage),
                message = string.IsNullOrEmpty(errorMessage) ? WebStore_Resources.MultipleCartSuccessMessage : errorMessage,
                cartCount = _cartAgent.GetCartCount(),
            }, JsonRequestBehavior.AllowGet);
        }

        //[ChildActionOnly]
        //[ZnodeOutputCache(Duration = 3600, VaryByParam = "id;publishState;profileId;localeId;accountId;catalogId")]
        //public override ActionResult DetailsContent(int id = 0, string seo = "", bool isQuickView = false, string publishState = "PRODUCTION", int localeId = 0, int profileId = 0, int accountId = 0, int catalogId = 0)
        //{
        //    ViewBag.IsLite = false;
        //    ProductViewModel product = _productAgent.GetProduct(id);
        //    if (Equals(product, null))
        //        return Redirect("/404");

        //    List<string> freeFreightSku = ((PHProductAgent)_productAgent).GetFreeFreightSkuList(new List<string> { product?.SKU });

        //    if (freeFreightSku?.Count > 0 && freeFreightSku.Contains(product.SKU))
        //        product.Attributes.Add(new AttributesViewModel() { AttributeCode = "IsFreeFreight", AttributeValues = "True" });

        //    if (product.ZnodeProductCategoryIds?.FirstOrDefault() > 0)
        //    {
        //        CategoryViewModel categoryViewModel = ((PHProductAgent)_productAgent).GetProductCategory(product.ZnodeProductCategoryIds.FirstOrDefault());
        //        product.CategoryHierarchy = new List<CategoryViewModel> { categoryViewModel };
        //    }

        //    product.ProductTemplateName = string.IsNullOrEmpty(product.ProductTemplateName) || Equals(product.ProductTemplateName, ZnodeConstant.ProductDefaultTemplate) ? "Details" : product.ProductTemplateName;

        //    return PartialView(product.ProductTemplateName, product);
        //}

        protected override void OnException(ExceptionContext filterContext)
        {
            filterContext.ExceptionHandled = true;

            var error = filterContext.Exception.Message;
            //Log the error!!
            //_Logger.Error(filterContext.Exception);

            //Redirect or return a view, but not both.
            //filterContext.Result = RedirectToAction("Index", "ErrorHandler");
            // OR 
            //filterContext.Result = new ViewResult
            //{
            //    ViewName = "~/Views/Themes/EquinaviaB2C/Views/Shared/ErrorPage.cshtml"
            //};
        }
    }
}
