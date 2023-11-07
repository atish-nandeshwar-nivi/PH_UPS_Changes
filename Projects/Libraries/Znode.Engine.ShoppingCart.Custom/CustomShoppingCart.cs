using System;
using System.Collections.Generic;
using System.Linq;
using Znode.Custom.Data;
using Znode.Engine.Api.Models;
using Znode.Engine.Promotions;
using Znode.Libraries.Admin;
using Znode.Libraries.Data;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.ECommerce.Utilities;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using Znode.Engine.Shipping.Custom.Interface;
using Znode.Engine.Services;
using Znode.Engine.Taxes.Custom;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Data.DataModel;
using Newtonsoft.Json;
using System.Diagnostics;

namespace Znode.Engine.Shipping.Custom
{
    /// <summary>
    /// Represents Shopping cart and shopping cart items
    /// </summary>
    [Serializable()]
    public class CustomShoppingCart : ZnodeShoppingCart, ICustomShoppingCart
    {
        #region Private Variables        
        private Dictionary<string, decimal> SKUQuantity;
        private List<ZnodePortalCart> portalCarts = new List<ZnodePortalCart>();
        private readonly IPublishProductHelper publishProductHelper;
        private readonly IZnodeOrderHelper orderHelper;
        private int _catalogVersionId = 0;
        private IGlobalAttributeGroupEntityService attributeGroupEntityService;
        private readonly IZnodeRepository<ConpacWarehouseAttribute> _conpacWarehouseAttributeRepository;
        public readonly IWarehouseService _warehouseService;

        private Dictionary<int, List<InventoryWarehouseMapperModel>> _warehouseSkuDictionary;
        private InventoryWarehouseMapperListModel _warehouseInventory;
        #endregion

        #region Constructor
        public CustomShoppingCart()
        {
            publishProductHelper = GetService<IPublishProductHelper>();
            orderHelper = GetService<IZnodeOrderHelper>();
            attributeGroupEntityService = GetService<IGlobalAttributeGroupEntityService>();
            _conpacWarehouseAttributeRepository = new ZnodeRepository<ConpacWarehouseAttribute>(new Custom_Entities());
            _warehouseService = GetService<IWarehouseService>();
        }
        #endregion

        #region Public Properties
        // Get Portal based cart items.
        public List<ConpacWarehouseAttribute> WarehouseZipcodeList
        {
            get
            {
                return _conpacWarehouseAttributeRepository.Table.Where(o => o.Type == "ZIP").ToList();
            }
        }
        public InventoryWarehouseMapperListModel WarehouseInventory
        {
            get
            {
                if (_warehouseInventory == null)
                {
                    _warehouseInventory = _warehouseService.GetAssociatedInventoryList(null, new FilterCollection(), null, null);
                }
                return _warehouseInventory;
            }
        }
        public int? MyWarehouseId { get; set; }
        public decimal MyWarehouseOrderMin { get; set; }
        public string MyWarehouseShipperName { get; set; }
        public decimal MyWarehouseFlatRate { get; set; }
        public Dictionary<string, object> CarrierResponseDictionary { get; set; }
        public Dictionary<int, List<InventoryWarehouseMapperModel>> WarehouseSkuDictionary
        {
            get
            {
                if (_warehouseSkuDictionary == null)
                {
                    _warehouseSkuDictionary = (from sci in ShoppingCartItems.Cast<ZnodeShoppingCartItem>().ToList() join wi in WarehouseInventory.InventoryWarehouseMapperList on sci.SKU equals wi.SKU select wi).GroupBy(x => x.WarehouseId)
                                                    .OrderBy(p => p.Key.ToString())
                                                    .ToDictionary(x => x.Key, x => x.Select(a => a).ToList());
                }
                return _warehouseSkuDictionary;
            }
        }
        public string Shipping2Carrier { get; set; }
        public string Shipping2Method { get; set; }
        public Dictionary<string, string> WarehouseNameCodeDictionary { get; set; }
        #endregion

        #region Public Methods           

        /// <summary>
        /// Calculates final pricing, shipping and taxes in the cart.
        /// </summary>
        // Pass profile ID as null to the overload
        public override void Calculate()
        {
            //Atish ups comment below code affecting shipping calculation
            try
            {
                //SetCarrierResponseDictionary();
                Calculate(null);
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage($"Error Calculating Cart With Saved Carrier Response:{ex.Message}", "Shipping", TraceLevel.Warning);
                CarrierResponseDictionary = null;
                Calculate(null);
            }
        }

        public override void Calculate(int? profileId, bool isCalCulateTaxAndShipping = true, bool isCalculatePromotionAndCoupon = true)
        {
            // Clear previous error message
            ClearPreviousErrorMessages();
            bool isCouponAvailable;

            ZnodeCartPromotionManager cartPromoManager = new ZnodeCartPromotionManager(this, profileId);
            cartPromoManager.Calculate();

            //// TaxRules
            if (isCalCulateTaxAndShipping)
            {
                //Atish ups comment below code affecting shipping calculation
                //try
                //{
                //    if (Debugger.IsAttached)
                //    {
                //        SetCarrierResponseDictionary();
                //    }

                //}
                //catch (Exception ex)
                //{
                //    Console.WriteLine(ex.Message);
                //}
                //Initialise  ZnodeShippingManager and calculate shipping cost.
                CustomShippingManager shippingManager = new CustomShippingManager(this);
                shippingManager.Calculate();

                // TaxRules
                CustomTaxManager taxManager = new CustomTaxManager(this);
                taxManager.Calculate(this);
            }

            List<ShoppingCartDiscountModel> productDiscount = new List<ShoppingCartDiscountModel>();
            // Promotions calculation starts

            //to save previous discount amount of product before calculating Promotions
            // TODO: Add info logs
            base.GetDiscountFromShoppingCart(productDiscount);

            isCouponAvailable = productDiscount.Count > 0;

            if (isCouponAvailable || IsAnyPromotionApplied)
            {
                productDiscount.Clear();
                // TODO: Add info logs
                GetDiscountFromShoppingCart(productDiscount);
            }

            if (productDiscount.Count > 0)
            {
                // TODO: Add info logs
                SetShoppingCartDiscount(productDiscount);
            }

            GiftCardAmount = 0;
            IsGiftCardApplied = false;
            GiftCardMessage = string.Empty;
            CSRDiscountApplied = false;
            CSRDiscountMessage = string.Empty;
            //to apply csr discount amount
            if (CSRDiscountAmount > 0)
            {
                // TODO: Add info logs
                AddCSRDiscount(CSRDiscountAmount);
            }

            //calculate PercentOffShipping promotion after shipping is calculated in order to get the calculated shipping cost
            if (cartPromoManager.CartPromotionCache.Any(x => x.PromotionType.ClassName == ZnodeConstant.PercentOffShipping || x.PromotionType.ClassName == ZnodeConstant.PercentOffShippingWithCarrier))
                cartPromoManager.Calculate();

            //if (!Equals(GiftCardNumber, string.Empty))
            //{
            //    // TODO: Add info logs
            //    AddGiftCard(GiftCardNumber, this.OrderId);
            //}
            if (IsCalculateVoucher && isCalculatePromotionAndCoupon && !IsPendingOrderRequest)
            {
                AddVouchers(this.OrderId);
            }

            //Atish ups comment below code affecting shipping calculation
            //try
            //{
            //    if (CarrierResponseDictionary != null)
            //    {
            //        SaveCarrierResponseDictionary();
            //    }
            //}
            //catch (Exception ex)
            //{
            //    ZnodeLogging.LogMessage($"Error Saving Carrier Response:{ex.Message}", "Shipping", TraceLevel.Warning);
            //    //CarrierResponseDictionary = null;
            //}
        }

        // CUSTOMIZATION: Override function to add the additional fees from the checkout
        // IMPORTANT !!!!!!!!
        // ZNODE HAS PROVIDED SOURCE CODE TO BE APPLIED TO THE ZNODE-SOURCE PROJECT TO PROCESS ADDITIONAL PRICES.
        // ONCE THE CODE IS IMPLEMENTED TO THE ZNODE-SOURCE AND COMPILED, THESE DLLS NEED TO BE REPLACED IN THE SDK
        // ZNODE.ENGINE.ADMIN.DLL
        // ZNODE.ENGINE.API.MODELS.DLL
        // ZNODE.ENGINE.PROMOTIONS.DLL
        // ZNODE.ENGINE.SERVICES.DLL
        // ZNODE.LIBRARIES.ECOMMERCE.SHOPPINGCART.DLL

        public override decimal GetAdditionalPrice()
        {
            decimal additionalPrice = 0;
            ZnodeShoppingCartItem firstLineItem = ShoppingCartItems.Cast<ZnodeShoppingCartItem>().FirstOrDefault(o => o.Custom1 != null);


            GlobalAttributeEntityDetailsModel attributesEntity = (this.PortalId != null ? attributeGroupEntityService.GetEntityAttributeDetails((int)this.PortalId, ZnodeConstant.Store) : new GlobalAttributeEntityDetailsModel { Groups = new List<GlobalAttributeGroupModel>(), Attributes = new List<GlobalAttributeValuesModel>() });
            GlobalAttributeGroupModel SpecialDeliveryGroup = attributesEntity.Groups.FirstOrDefault(x => x.GroupCode == "SpecialDeliveryFees");
            List<GlobalAttributeValuesModel> attributeList = attributesEntity?.Attributes.Where(x => x.GlobalAttributeGroupId == SpecialDeliveryGroup?.GlobalAttributeGroupId).GroupBy(p => p.GlobalAttributeId).Select(g => g.First()).ToList();

            if (HelperUtility.IsNull(firstLineItem))
            {
                return additionalPrice;
            }

            if (HelperUtility.IsNull(firstLineItem.Custom1) || firstLineItem.Custom1.ToString() == string.Empty)
            { return additionalPrice; }

            Dictionary<int, decimal> Fees = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<int, decimal>>(firstLineItem.Custom1);
            additionalPrice = Fees.Sum(x => x.Value);

            Dictionary<string, decimal> additionCostDictionary = (from f in Fees join al in attributeList on f.Key equals al.GlobalAttributeId select new { al.AttributeCode, f.Value }).ToDictionary(x => x.AttributeCode, x => x.Value);
            if (additionCostDictionary != null)
            {
                ShoppingCartItems[0].AdditionalCost = additionCostDictionary;
            }
            //List<int> list = firstLineItem.Custom1.ToString().Split('|').Select(int.Parse).ToList();
            //if (list == null) {
            //    firstLineItem.AdditionalCost?.Clear();
            //    ShoppingCartItems[0] = firstLineItem;
            //}

            //foreach (int fee in list)
            //{
            //    GlobalAttributeValuesModel feeValue = attributeList.FirstOrDefault(o => o.GlobalAttributeId == fee);
            //    if (feeValue != null)
            //    {
            //        firstLineItem.AdditionalCost = new Dictionary<string, decimal>() {
            //            { feeValue.AttributeCode, decimal.Parse(feeValue.AttributeValue) }
            //        };
            //        ShoppingCartItems[0] = firstLineItem;
            //        additionalPrice += decimal.Parse(feeValue.AttributeValue);
            //    }
            //}
            return additionalPrice;

        }

        //Save the shopping cart items in the database.

        // OVERRIDING THIS FUNCTION SO THAT THE CART COUNT RETURNED IS THE LINE COUNT RATHER THAN THE TOTAL NUMBER OF ITEMS IN THE CART.

        public override AddToCartModel SaveAddToCartData(AddToCartModel cartModel, string groupIdProductAttribute = "", GlobalSettingValues groupIdPersonalizeAttribute = null)
        {
            if (IsNotNull(cartModel))
            {
                //Get CookieMappingId
                int cookieMappingId = (!string.IsNullOrEmpty(cartModel.CookieMappingId) ? Convert.ToInt32(new ZnodeEncryption().DecryptData(cartModel.CookieMappingId)) : 0) == 0 ? orderHelper.GetCookieMappingId(cartModel.UserId, cartModel.PortalId) : !string.IsNullOrEmpty(cartModel.CookieMappingId) ? Convert.ToInt32(new ZnodeEncryption().DecryptData(cartModel.CookieMappingId)) : 0;

                //Get SavedCartId
                int savedCartId = orderHelper.GetSavedCartId(cookieMappingId, cartModel.PortalId, cartModel.UserId);

                foreach (ShoppingCartItemModel cartItem in cartModel.ShoppingCartItems)
                {
                    BindCartProductDetails(cartItem, cartModel.PublishedCatalogId, cartModel.LocaleId, groupIdProductAttribute, groupIdPersonalizeAttribute);
                }

                //Save all shopping cart line items.
                bool status = orderHelper.SaveAllCartLineItemsInDatabase(savedCartId, cartModel);

                cartModel.CookieMappingId = new ZnodeEncryption().EncryptData(cookieMappingId.ToString());

                List<ZnodeOmsSavedCartLineItem> lineItems = orderHelper.GetSavedCartLineItem(savedCartId);

                lineItems?.RemoveAll(x => x.OrderLineItemRelationshipTypeId == Convert.ToInt32(ZnodeCartItemRelationshipTypeEnum.AddOns) || x.OrderLineItemRelationshipTypeId == Convert.ToInt32(ZnodeCartItemRelationshipTypeEnum.Bundles));

                cartModel.CartCount = lineItems?.Where(x => x.Quantity != null && x.Quantity > 0).Count() ?? 0.00M;

                cartModel.HasError = !status;

                return cartModel;
            }
            return null;
        }

        public void SaveCarrierResponseDictionary()
        {
            
            //Get SavedCartId
            int savedCartId = orderHelper.GetSavedCartId(CookieMappingId);

            //foreach (ShoppingCartItemModel cartItem in cartModel.ShoppingCartItems)
            //{
            //    BindCartProductDetails(cartItem, cartModel.PublishedCatalogId, cartModel.LocaleId, groupIdProductAttribute, groupIdPersonalizeAttribute);
            //}

            //Save all shopping cart line items.

            IZnodeRepository<ZnodeOmsSavedCartLineItem> _savedCartLineItemRepository = new ZnodeRepository<ZnodeOmsSavedCartLineItem>();
            List<ZnodeOmsSavedCartLineItem> savedCartLineItems = _savedCartLineItemRepository.Table.Where(x => x.OmsSavedCartId == savedCartId)?.ToList() ?? new List<ZnodeOmsSavedCartLineItem>();

            //cartModel.CookieMappingId = new ZnodeEncryption().EncryptData(cookieMappingId.ToString());

            //List<ZnodeOmsSavedCartLineItem> lineItems = orderHelper.GetSavedCartLineItem(savedCartId);
            ZnodeOmsSavedCartLineItem znodeOmsSavedCartLineItem = null;
            foreach (ZnodeShoppingCartItem cartItem in this.ShoppingCartItems)
            {
                if (znodeOmsSavedCartLineItem == null)
                {
                    znodeOmsSavedCartLineItem = savedCartLineItems.First(f => f.OmsSavedCartLineItemId == cartItem.OmsSavedCartLineItemId);
                }
                else
                {
                    break;
                }
                var lineItem = znodeOmsSavedCartLineItem;
                //lineItem.Custom1 = cartItem.Custom1;
                //lineItem.Custom2 = cartItem.Custom2;
                //lineItem.Custom3 = cartItem.Custom3;
                //lineItem.Custom4 = cartItem.Custom4;
                //lineItem.Custom5 = cartItem.Custom5;
                //var firstItem = ShoppingCartItems.AsQueryable().fir;
                lineItem.Custom4 = JsonConvert.SerializeObject(CarrierResponseDictionary);
            }
            _savedCartLineItemRepository.BatchUpdate(savedCartLineItems);

        }

        public void SetCarrierResponseDictionary()
        {
            string json = null;
            try
            {
                int savedCartId = orderHelper.GetSavedCartId(CookieMappingId);
                IZnodeRepository<ZnodeOmsSavedCartLineItem> _savedCartLineItemRepository = new ZnodeRepository<ZnodeOmsSavedCartLineItem>();
                List<ZnodeOmsSavedCartLineItem> savedCartLineItems = _savedCartLineItemRepository.Table.Where(x => x.OmsSavedCartId == savedCartId)?.ToList() ?? new List<ZnodeOmsSavedCartLineItem>();
                foreach (var cartItem in savedCartLineItems)
                {
                    if (cartItem.Custom4 != null)
                    {
                        json = cartItem.Custom4;
                        var rawDict = JsonConvert.DeserializeObject<Dictionary<string, object>>(json);
                        CarrierResponseDictionary = new Dictionary<string, object>();
                        foreach (var item in rawDict.Keys)
                        {
                            if (item.ToLower().Contains("box"))
                            {
                                CarrierResponseDictionary[item] = JsonConvert.DeserializeObject<List<Carrier>>(rawDict[item].ToString());
                            }
                            else if (item.ToLower().Contains("jit"))
                            {
                                CarrierResponseDictionary[item] = JsonConvert.DeserializeObject<TPWResponse>(rawDict[item].ToString());
                            }
                        }
                        break;
                    }
                }

            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage($"Saved Carrier Response Retrieval Error:{ex.Message}. Saved json:{json}", "Shipping", TraceLevel.Warning);
                CarrierResponseDictionary = null;
            }
        }


        ////to load shoppingCart from database by orderId
        //public override ShoppingCartModel LoadCartFromOrder(CartParameterModel model, int? catalogVersionId = null)
        //{
        //    ShoppingCartModel cartModel;
        //    List<ZnodeOmsOrderLineItem> parentDetails = null;
        //    //Check if OrderId is null or 0.
        //    if (IsNull(model.OmsOrderId) || model.OmsOrderId == 0)
        //    {
        //        return null;
        //    }

        //    //Get order line items from ZnodeOmsOrderLineItem by orderId.
        //    IZnodeOrderHelper helper = GetService<IZnodeOrderHelper>();
        //    ZnodeOmsOrderDetail orderDetails = helper.GetOrderById(model.OmsOrderId.GetValueOrDefault());
        //    cartModel = orderDetails?.ToModel<ShoppingCartModel>() ?? new ShoppingCartModel();
        //    cartModel.IsOldOrder = model.IsOldOrder;
        //    List<ZnodeOmsOrderLineItem> allOrderLineItems = helper.GetOrderLineItemByOrderId(cartModel.OmsOrderDetailsId);
        //    List<ZnodeOmsOrderLineItem> orderLineItems = allOrderLineItems?
        //                                             .Where(m => m.OrderLineItemRelationshipTypeId != Convert.ToInt32(ZnodeCartItemRelationshipTypeEnum.AddOns)
        //                                             && m.OrderLineItemRelationshipTypeId != Convert.ToInt32(ZnodeCartItemRelationshipTypeEnum.Bundles)).ToList();
        //    List<OrderDiscountModel> allLineItemDiscountList = helper.GetOmsOrderDiscountList(model.OmsOrderId.GetValueOrDefault());


        //    List<PublishedProductEntityModel> productList = GetPublishProductBySKUs(orderLineItems?.Select(x => x.Sku).ToList(), model.PublishedCatalogId, model.LocaleId, catalogVersionId)?.ToModel<PublishedProductEntityModel>()?.ToList();
        //    cartModel.ShoppingCartItems = new List<ShoppingCartItemModel>();
        //    parentDetails = orderLineItems.Where(o => o.ParentOmsOrderLineItemsId == null).ToList();
        //    SetParentLineItemDetails(parentDetails, productList);

        //    foreach (ZnodeOmsOrderLineItem lineItem in orderLineItems.Where(orderLineItem => orderLineItem.ParentOmsOrderLineItemsId.HasValue || orderLineItem.Sku.Contains("CHILL")))
        //    {
        //        ShoppingCartItemModel item = lineItem.ToModel<ShoppingCartItemModel>();
        //        PublishedProductEntityModel product = productList?.FirstOrDefault(x => x.SKU == item.SKU);
        //        item.PerQuantityShippingCost = GetPerQtyShippingCost(item.ShippingCost, item.Quantity);
        //        item.OmsOrderId = model.OmsOrderId.GetValueOrDefault();
        //        if (lineItem.ParentOmsOrderLineItemsId == 0)
        //        {
        //            item.ProductType = ZnodeConstant.BundleProduct;
        //        }
        //        item.ParentOmsOrderLineItemsId = lineItem.ParentOmsOrderLineItemsId;
        //        item.IsActive = (product?.IsActive).GetValueOrDefault();
        //        item.ShipSeperately = lineItem.ShipSeparately.GetValueOrDefault();
        //        item.ImportDuty = (lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.ImportDuty).GetValueOrDefault();
        //        //to set configurable/group product quantity for cart line item
        //        SetConfigurableOrGroupProductQuantity(item, new List<ZnodeOmsOrderLineItem>() { lineItem }, productList);
        //        CalculateLineItemPrice(item, allOrderLineItems);
        //        SetAssociateProductType(item, allOrderLineItems);
        //        SetProductImage(item, model.PublishedCatalogId, model.LocaleId, model.OmsOrderId.GetValueOrDefault());
        //        GetLineItemEditStatus(lineItem.ZnodeOmsOrderState, item);
        //        GetLineItemReason(lineItem.ZnodeRmaReasonForReturn, item);
        //        item.TrackingNumber = lineItem.TrackingNumber;
        //        if (IsNotNull(lineItem.OrderLineItemRelationshipTypeId == (int)ZnodeCartItemRelationshipTypeEnum.AddOns))
        //        {
        //            ZnodeOmsTaxOrderLineDetail znodeOmsTaxOrderLineDetail = IsNull(lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()) && (lineItem.OrderLineItemRelationshipTypeId == (int)ZnodeCartItemRelationshipTypeEnum.Configurable || lineItem.OrderLineItemRelationshipTypeId == (int)ZnodeCartItemRelationshipTypeEnum.Group) ? orderLineItems.Where(orderLineItem => orderLineItem.OmsOrderLineItemsId == lineItem.ParentOmsOrderLineItemsId)?.ToList()?.FirstOrDefault()?.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault() : lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault();
        //            item.TaxCost = IsNotNull(znodeOmsTaxOrderLineDetail) ? item.TaxCost + (znodeOmsTaxOrderLineDetail.SalesTax + znodeOmsTaxOrderLineDetail.VAT + znodeOmsTaxOrderLineDetail.GST + znodeOmsTaxOrderLineDetail.HST + znodeOmsTaxOrderLineDetail.PST).GetValueOrDefault() : 0;
        //            item.TaxTransactionNumber = znodeOmsTaxOrderLineDetail?.TaxTransactionNumber;
        //            item.TaxRuleId = (znodeOmsTaxOrderLineDetail?.TaxRuleId).GetValueOrDefault();
        //        }
        //        else
        //        {
        //            item.TaxCost = item.TaxCost > 0 ? item.TaxCost : (lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.SalesTax + lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.VAT + lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.GST + lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.HST + lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.PST).GetValueOrDefault();
        //            item.TaxTransactionNumber = lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.TaxTransactionNumber;
        //            item.TaxRuleId = (lineItem.ZnodeOmsTaxOrderLineDetails?.FirstOrDefault()?.TaxRuleId).GetValueOrDefault();
        //        }
        //        SetPersonalizedAttributes(lineItem, item);
        //        item.DownloadableProductKey = GetProductKey(item.SKU, item.Quantity, item.OmsOrderLineItemsId);
        //        if (IsNotNull(item.ParentOmsQuoteLineItemId))
        //        {
        //            item.SKU = parentDetails?.Where(o => o.ParentOmsOrderLineItemsId == item.ParentOmsQuoteLineItemId)?.Select(o => o.Sku).FirstOrDefault();
        //        }

        //        SetGroupAndConfigurableParentProductDetails(parentDetails, lineItem, item);
        //        orderHelper.SetPerQuantityDiscount(allLineItemDiscountList, item);
        //        SetInventoryData(item, product);

        //        cartModel.ShoppingCartItems.Add(item);
        //    }
        //    if (cartModel.OmsOrderDetailsId > 0)
        //    {
        //        SetOrderDiscount(cartModel);
        //        if (IsNotNull(orderDetails))
        //        {
        //            orderDetails.DiscountAmount = cartModel.Discount;

        //            if (orderDetails.DiscountAmount > 0)
        //            {
        //                cartModel.Discount = orderDetails.DiscountAmount.GetValueOrDefault();
        //            }

        //            if (!string.IsNullOrEmpty(orderDetails.CouponCode))
        //            {
        //                SetOrderCoupons(cartModel, orderDetails.CouponCode);
        //            }
        //            if (!string.IsNullOrEmpty(cartModel.GiftCardNumber))
        //            {
        //                SetOrderVouchers(cartModel, cartModel.GiftCardNumber);
        //            }
        //        }


        //    }
        //    return cartModel;
        //}

    }
    #endregion
}


