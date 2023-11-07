using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.Services;
using Znode.Engine.Services.Maps;
using Znode.Engine.Shipping.Custom;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Resources;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using Znode.Engine.Shipping.Custom.Interface;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Custom.Data;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.Admin;
using Znode.Engine.Taxes;
using System.Web;
using Znode.Engine.klaviyo.Models;
using Znode.Engine.Klaviyo.Services;
using System.Collections.Specialized;
using Znode.Engine.Services.Constants;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Znode.Api.Model.Custom.ToStorePHUom;

namespace Znode.Api.Custom.Service.Service
{
    class CustomOrderService : OrderService, IOrderService
    {
        private readonly IShoppingCartMap _shoppingCartMap;
        private readonly ICustomShoppingCartMap _customShoppingCartMap;
        private readonly IZnodeRepository<ConpacWarehouseAttribute> _conpacWarehouseAttributeRepository;
        private IGlobalAttributeGroupEntityService attributeGroupEntityService;
        private readonly IZnodeRepository<ZnodeShipping> _shippingRepository;
        private readonly IShoppingCartService _shoppingCartService;
        private readonly IZnodeRepository<ZnodeOmsOrderState> _omsOrderStateRepository;
        private readonly IKlaviyoService _service;
        private readonly IZnodeRepository<ZnodeOmsOrderDetail> _orderOrderDetailRepository;
        private readonly IZnodeRepository<ZnodeOmsOrderShipment> _orderOrderShipmentRepository;
        private readonly IZnodeRepository<ZnodeUser> _ZnodeUserRepository ;
        protected readonly IZnodeRepository<ZnodeAccount> _accountRepository;
        private readonly IZnodeRepository<ZnodeOmsNote> _omsNoteRepository;
        private readonly IShippingService _shippingservice;

        public CustomOrderService(IShoppingCartService shoppingCartService)
        {
            _shoppingCartMap = GetService<IShoppingCartMap>();
            _customShoppingCartMap = GetService<ICustomShoppingCartMap>();
            _conpacWarehouseAttributeRepository = new ZnodeRepository<ConpacWarehouseAttribute>(new Custom_Entities());
            attributeGroupEntityService = GetService<IGlobalAttributeGroupEntityService>();
            _shippingRepository = new ZnodeRepository<ZnodeShipping>();
            _shoppingCartService = shoppingCartService;
            _omsOrderStateRepository = new ZnodeRepository<ZnodeOmsOrderState>();
            _service = GetService<IKlaviyoService>();
            _orderOrderDetailRepository = new ZnodeRepository<ZnodeOmsOrderDetail>();
            _orderOrderShipmentRepository = new ZnodeRepository<ZnodeOmsOrderShipment>(); 
            _ZnodeUserRepository = new ZnodeRepository<ZnodeUser>();
            _accountRepository = new ZnodeRepository<ZnodeAccount>();
            _omsNoteRepository = new ZnodeRepository<ZnodeOmsNote>();
            _shippingservice = ZnodeDependencyResolver.GetService<IShippingService>();
        }

        //overriden to catch soft error while updating order status from admin
        public override OrderModel UpdateOrder(OrderModel model)
        {
            OrderModel orderModel = new OrderModel();
            try
            {
                orderModel = base.UpdateOrder(model);
            }
            catch (Exception)
            {

            }
            return orderModel;
        }

        public override IZnodeCheckout SetCheckoutData(UserAddressModel userAddress, ShoppingCartModel model, ZnodeLogging log)
        {
            ZnodeLogging.LogMessage("UserAddressModel and ShoppingCartModel with Ids: ", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { UserAddressModelWithId = userAddress?.UserId, ShoppingCartModelWithOmsOrderStatusId = model?.OmsOrderStatusId });
            var znodeShoppingCart = ToZnodeShoppingCart(model, userAddress);
            znodeShoppingCart.Shipping.ShippingID = model.ShippingId;

            //CUSTOMIZATION: SETTING THE SECOND SHIPPING CARRIER FROM CUSTOM 1 AND CUSTOM 2 PARAMATERS
            if (model.Shipping != null && model.Shipping.Custom1 != null)
                ((CustomShoppingCart)znodeShoppingCart).Shipping2Carrier = model.Shipping.Custom1.ToString();
            if (model.Shipping != null && model.Shipping.Custom2 != null)
                ((CustomShoppingCart)znodeShoppingCart).Shipping2Method = model.Shipping.Custom2.ToString();

            // Create the checkout object

            IZnodeCheckout checkout = CheckoutMap.ToZnodeCheckout(userAddress, znodeShoppingCart);
            if (IsNull(checkout?.ShoppingCart))
            {
                log.LogActivityTimerEnd((int)ZnodeLogging.ErrorNum.OrderSubmissionFailed, null);
                throw new ZnodeException(ErrorCodes.ProcessingFailed, Admin_Resources.UnableToProcessOrder);
            }

            return SetShoppingCartDataToCheckout(checkout, model);
        }

        public virtual ZnodeShoppingCart ToZnodeShoppingCart(ShoppingCartModel model, UserAddressModel userDetails = null, List<string> expands = null)
        {
            if (IsNull(model))
                return null;

            ZnodeShoppingCart znodeCart = (ZnodeShoppingCart)GetService<IZnodeShoppingCart>();

            znodeCart.GiftCardAmount = model.GiftCardAmount;
            znodeCart.GiftCardMessage = model.GiftCardMessage;
            znodeCart.GiftCardNumber = model.GiftCardNumber ?? String.Empty;
            znodeCart.IsGiftCardApplied = model.GiftCardApplied;
            znodeCart.IsGiftCardValid = model.GiftCardValid;
            znodeCart.OrderLevelDiscount = model.OrderLevelDiscount;
            znodeCart.OrderLevelShipping = model.OrderLevelShipping;
            znodeCart.OrderLevelTaxes = model.OrderLevelTaxes;
            znodeCart.PayerId = model.PayerId;
            znodeCart.Payment = PaymentMap.ToZnodePayment(model.Payment, (model.MultipleShipToEnabled) ? model?.ShoppingCartItems?[0].ShippingAddress : model.ShippingAddress, model.BillingAddress);
            znodeCart.ProfileId = model.ProfileId;
            znodeCart.SalesTax = model.SalesTax;
            znodeCart.Shipping = ShippingMap.ToZnodeShipping(model.Shipping);
            znodeCart.TaxRate = model.TaxRate;
            znodeCart.Token = model.Token;
            znodeCart.PortalId = model.PortalId;
            znodeCart.LoginUserName = model?.UserDetails?.UserName ?? string.Empty;
            znodeCart.OrderId = model.OmsOrderId;
            znodeCart.OrderDate = model.OrderDate;
            znodeCart.UserId = model.UserId;
            znodeCart.LocalId = model.LocaleId;
            znodeCart.CookieMappingId = !string.IsNullOrEmpty(model.CookieMappingId) ? Convert.ToInt32(new ZnodeEncryption().DecryptData(model.CookieMappingId)) : 0;
            znodeCart.PublishedCatalogId = model.PublishedCatalogId;
            znodeCart.CSRDiscountAmount = model.CSRDiscountAmount;
            znodeCart.CSRDiscountDescription = model.CSRDiscountDescription;
            znodeCart.CSRDiscountApplied = model.CSRDiscountApplied;
            znodeCart.CSRDiscountMessage = model.CSRDiscountMessage;
            znodeCart.CurrencyCode = model.CurrencyCode;
            znodeCart.CultureCode = model.CultureCode;
            znodeCart.CurrencySuffix = model.CurrencySuffix;
            znodeCart.OrderAttribute = model.OrderAttribute;
            znodeCart.PersonaliseValuesList = model.ShoppingCartItems.Count > 0 ? model?.ShoppingCartItems?[0].PersonaliseValuesList : new System.Collections.Generic.Dictionary<string, object>();
            znodeCart.CustomShippingCost = model.CustomShippingCost;
            znodeCart.CustomTaxCost = model.CustomTaxCost;
            znodeCart.ExternalId = model.ExternalId;
            znodeCart.IsLineItemReturned = model.IsLineItemReturned;
            znodeCart.IsCchCalculate = model.IsCchCalculate;
            znodeCart.ReturnItemList = model.ReturnItemList;
            znodeCart.Custom1 = model.Custom1;
            znodeCart.Custom2 = model.Custom2;
            znodeCart.Custom3 = model.Custom3;
            znodeCart.Custom4 = model.Custom4;
            znodeCart.Custom5 = model.Custom5;
            znodeCart.EstimateShippingCost = model.EstimateShippingCost;
            znodeCart.TotalAdditionalCost = model.TotalAdditionalCost.GetValueOrDefault();
            znodeCart.IsAllowWithOtherPromotionsAndCoupons = model.IsAllowWithOtherPromotionsAndCoupons;
            znodeCart.PublishStateId = model.PublishStateId;
            znodeCart.IpAddress = model.IpAddress;
            znodeCart.InHandDate = model.InHandDate;
            znodeCart.JobName = model.JobName;
            znodeCart.ShippingConstraintCode = model.ShippingConstraintCode;
            znodeCart.IsCalculatePromotionAndCoupon = model.IsCalculatePromotionAndCoupon;
            znodeCart.IsShippingRecalculate = model.IsShippingRecalculate;
            znodeCart.ShippingDiscount = IsNotNull(model.Shipping) ? model.Shipping.ShippingDiscount : 0;
            znodeCart.ShippingHandlingCharges = IsNotNull(model.Shipping.ShippingHandlingCharge == 0) ? model.ShippingHandlingCharges : model.Shipping.ShippingHandlingCharge;
            znodeCart.ReturnCharges = model.ReturnCharges;
            znodeCart.IsRemoveShippingDiscount = model.IsRemoveShippingDiscount;
            znodeCart.InvalidOrderLevelShippingDiscount = model.InvalidOrderLevelShippingDiscount;
            znodeCart.InvalidOrderLevelShippingPromotion = model.InvalidOrderLevelShippingPromotion;
            znodeCart.IsShippingDiscountRecalculate = model.IsShippingDiscountRecalculate;
            znodeCart.IsOldOrder = model.IsOldOrder;
            znodeCart.IsCalculateTaxAfterDiscount = model.IsCalculateTaxAfterDiscount;
            znodeCart.IsCallLiveShipping = model.IsCallLiveShipping ? false : model.IsOldOrder;
            znodeCart.SkipShippingCalculations = model.SkipShippingCalculations;
            znodeCart.FreeShipping = model.FreeShipping;
            znodeCart.BusinessIdentificationNumber = model.UserDetails?.BusinessIdentificationNumber;
            znodeCart.IsPricesInclusiveOfTaxes = model.IsPricesInclusiveOfTaxes;
            znodeCart.IsTaxExempt = model.IsTaxExempt;
            znodeCart.AvataxIsSellerImporterOfRecord = model.AvataxIsSellerImporterOfRecord;
            //nivi code start for second shipping not calculating in case of tax applied
            znodeCart.ShippingCost = model.ShippingCost;
            //nivi code end

            znodeCart.CSRDiscountEdited = model.CSRDiscountEdited;
            if (IsNull(znodeCart.Payment))
                znodeCart.Payment = new Libraries.ECommerce.Entities.ZnodePayment();

            znodeCart.Payment.BillingAddress = model?.BillingAddress ?? new AddressModel();

            if (Equals(model.ShippingAddress, null))
                model.ShippingAddress = model?.Payment?.ShippingAddress ?? new AddressModel();


            if (IsNotNull(userDetails))
                znodeCart.UserAddress = userDetails;

            IPublishProductHelper publishProductHelper = GetService<IPublishProductHelper>();

            List<string> skus = new List<string>();

            foreach (ShoppingCartItemModel item in model.ShoppingCartItems)
            {
                if (!string.IsNullOrEmpty(item.ConfigurableProductSKUs))
                {
                    skus.Add(item.ConfigurableProductSKUs.ToLower());
                }
                else if (item?.GroupProducts?.Count > 0)
                {
                    skus.Add(item.GroupProducts[0]?.Sku.ToLower());
                }

                skus.Add(item.SKU.ToLower());
            }
            skus = skus.Distinct().ToList();

            List<PublishedConfigurableProductEntityModel> configEntities;

            if (IsNull(expands))
                expands = new List<string> { ZnodeConstant.Promotions, ZnodeConstant.Pricing, ZnodeConstant.Inventory, ZnodeConstant.SEO };

            int catalogVersionId = publishProductHelper.GetCatalogVersionId(model.PublishedCatalogId, model.LocaleId);

            bool includeInactiveProduct = false;

            //If order status is cancelled then allow inactive products for cancellation.
            if (string.Equals(model.OrderStatus, ZnodeOrderStatusEnum.CANCELED.ToString(), StringComparison.InvariantCultureIgnoreCase))
                includeInactiveProduct = true;

            List<PublishProductModel> cartLineItemsProductData = publishProductHelper.GetDataForCartLineItems(skus, model.PublishedCatalogId, model.LocaleId, expands, model.UserId.GetValueOrDefault(), model.PortalId, catalogVersionId, out configEntities, includeInactiveProduct, model.OmsOrderId.GetValueOrDefault());

            List<TaxClassRuleModel> lstTaxClassSKUs = publishProductHelper.GetTaxRules(skus);

            List<ZnodePimDownloadableProduct> lstDownloadableProducts = new ZnodeRepository<ZnodePimDownloadableProduct>().Table.Where(x => skus.Contains(x.SKU)).ToList();

            znodeCart.AddtoShoppingBagV2(model, cartLineItemsProductData, catalogVersionId, lstTaxClassSKUs, lstDownloadableProducts, configEntities, expands);

            if (IsNotNull(model?.Coupons))
            {
                foreach (CouponModel coupon in model.Coupons)
                    znodeCart.Coupons.Add(CouponMap.ToZnodeCoupon(coupon));
            }

            if (IsNotNull(model?.Vouchers))
            {
                foreach (VoucherModel voucher in model.Vouchers)
                    znodeCart.Vouchers.Add(VoucherMap.ToZnodeVoucher(voucher));
            }
            znodeCart.IsCalculateVoucher = model.IsCalculateVoucher;
            znodeCart.IsAllVoucherRemoved = model.IsAllVoucherRemoved;
            znodeCart.IsQuoteOrder = model.IsQuoteOrder;
            znodeCart.IsPendingOrderRequest = model.IsPendingOrderRequest;
            if (IsNotNull(model.OmsOrderId) && model.OmsOrderId > 0 && model.ShippingCost > 0 && znodeCart.ShippingCost == 0.0M && !model.IsOldOrder)
            {
                znodeCart.ShippingCost = model.ShippingCost;
            }
            return znodeCart;
        }


        //To set shopping cart data to checkout object
        public override IZnodeCheckout SetShoppingCartDataToCheckout(IZnodeCheckout checkout, ShoppingCartModel model)
        {
            //InventoryWarehouseMapperListModel warehouseInventory = _warehouseService.GetAssociatedInventoryList(null, new FilterCollection(), null, null);
            //Dictionary<int, List<InventoryWarehouseMapperModel>> warehouseSkuDic = (from sci in model.ShoppingCartItems join wi in warehouseInventory.InventoryWarehouseMapperList on sci.SKU equals wi.SKU select wi).GroupBy(xo => xo.WarehouseId)
            //                                .OrderBy(p => p.Key.ToString())
            //                                .ToDictionary(xo => xo.Key, xo => xo.Select(a => a).ToList());

            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            int cookieId;
            try
            {
                cookieId = Convert.ToInt32(new ZnodeEncryption().DecryptData(model.CookieMappingId));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                cookieId = 0;
            }
            checkout.ShoppingCart.Total = Convert.ToDecimal(model.Total);///Fix Order Total while placing order
            checkout.ShoppingCart.LocalId = model.LocaleId;
            checkout.ShoppingCart.PublishedCatalogId = model.PublishedCatalogId;
            checkout.ShoppingCart.OrderDate = model.OrderDate;
            checkout.ShoppingCart.GiftCardAmount = model.GiftCardAmount;
            checkout.ShoppingCart.GiftCardMessage = model.GiftCardMessage;
            checkout.ShoppingCart.GiftCardNumber = model.GiftCardNumber;
            checkout.ShoppingCart.IsGiftCardApplied = model.GiftCardApplied;
            checkout.ShoppingCart.IsGiftCardValid = model.GiftCardValid;
            checkout.ShoppingCart.CreditCardNumber = model.CreditCardNumber;
            checkout.ShoppingCart.CSRDiscountAmount = model.CSRDiscountAmount;
            checkout.ShoppingCart.CSRDiscountDescription = model.CSRDiscountDescription;
            checkout.ShoppingCart.CSRDiscountApplied = model.CSRDiscountApplied;
            checkout.ShoppingCart.CSRDiscountMessage = model.CSRDiscountMessage;
            checkout.ShoppingCart.CustomShippingCost = model.CustomShippingCost;
            checkout.ShoppingCart.CustomTaxCost = model.CustomTaxCost;
            checkout.ShoppingCart.OrderAttribute = model.OrderAttribute;
            checkout.ShoppingCart.CurrencyCode = model.CurrencyCode;
            checkout.ShoppingCart.CultureCode = model.CultureCode;
            checkout.ShoppingCart.UserId = model.UserId;
            checkout.ShoppingCart.ExternalId = model.ExternalId;
            checkout.ShoppingCart.CardType = model.CardType;
            checkout.ShoppingCart.CreditCardExpMonth = model.CreditCardExpMonth;
            checkout.ShoppingCart.CreditCardExpYear = model.CreditCardExpYear;
            checkout.ShoppingCart.LoginUserName = model.UserDetails?.LoginName ?? string.Empty;
            checkout.ShoppingCart.IsLineItemReturned = model.IsLineItemReturned;
            if (IsNotNull(model?.Coupons))
            {
                foreach (CouponModel coupon in model.Coupons)
                    checkout.ShoppingCart.Coupons.Add(CouponMap.ToZnodeCoupon(coupon));
            }
            checkout.ShoppingCart.PortalID = model.PortalId;
            checkout.ShoppingCart.VAT = model.Vat.GetValueOrDefault();
            checkout.ShoppingCart.HST = model.Hst.GetValueOrDefault();
            checkout.ShoppingCart.GST = model.Gst.GetValueOrDefault();
            checkout.ShoppingCart.PST = model.Pst.GetValueOrDefault();
            checkout.AdditionalInstructions = model.AdditionalInstructions;
            checkout.PurchaseOrderNumber = model.PurchaseOrderNumber;
            checkout.PoDocument = model.PODocumentName;
            checkout.PortalID = model.PortalId;
            checkout.ShoppingCart.Payment = PaymentMap.ToZnodePayment(model.Payment);
            checkout.ShoppingCart.Shipping = ShippingMap.ToZnodeShipping(model.Shipping);
            checkout.ShippingID = checkout.ShoppingCart.Shipping.ShippingID;
            //Nivi code start to fix 0 shipping id in case of coupon applied
            IZnodeRepository<ZnodeShipping> _shippingRepository = new ZnodeRepository<ZnodeShipping>();
            ZnodeShipping shipping = _shippingRepository.Table.FirstOrDefault(x => x.ShippingCode == model.Shipping.ShippingName);//We stored ShippingName in ShippingCode in DB
            if (shipping == null)
                shipping = _shippingRepository.Table.FirstOrDefault(x => x.ShippingCode == model.Shipping.Custom2);//In case of single shipping 
            if (checkout.ShippingID == 0)
            {
                checkout.ShippingID = shipping.ShippingId;
                checkout.ShoppingCart.Shipping.ShippingID = shipping.ShippingId;
            }
            //nivi code end
            checkout.ShoppingCart.Payment.PaymentSettingId = model.Payment?.PaymentSetting == null || model.Payment?.PaymentSetting.PaymentSettingId == 0 ? null : model.Payment?.PaymentSetting.PaymentSettingId;
            checkout.ShoppingCart.ReturnItemList = model.ReturnItemList;
            checkout.ShoppingCart.IsCchCalculate = model.IsCchCalculate;
            checkout.ShoppingCart.IsAllowWithOtherPromotionsAndCoupons = model.IsAllowWithOtherPromotionsAndCoupons;
            checkout.ShoppingCart.EstimateShippingCost = model.EstimateShippingCost;
            checkout.ShoppingCart.Custom1 = model.Custom1;
            checkout.ShoppingCart.Custom2 = model.Custom2;
            checkout.ShoppingCart.Custom3 = model.Custom3;
            checkout.ShoppingCart.Custom4 = model.Custom4;
            checkout.ShoppingCart.Custom5 = model.Custom5;
            if (IsNotNull(model.OrderShipment))
            {
                // Do the cart calculation
                checkout.ShoppingCart.AddressCarts.ForEach(x =>
                {
                    CustomShoppingCart y = _customShoppingCartMap.ToZnodeShoppingCart(x);
                    x.Shipping = string.IsNullOrEmpty(x.Shipping.ShippingName) ? new Libraries.ECommerce.Entities.ZnodeShipping
                    {
                        ShippingID = checkout.ShoppingCart.Shipping.ShippingID,
                        ShippingName = checkout.ShoppingCart.Shipping.ShippingName,
                        ShippingCountryCode = checkout?.ShoppingCart?.Shipping.ShippingCountryCode
                    } : x.Shipping;
                    var address = _addressRepository.GetById(x.AddressID);
                    checkout.ShoppingCart.Payment = PaymentMap.ToZnodePayment(model.Payment, address.ToModel<AddressModel>());
                    x.Payment = checkout.ShoppingCart.Payment;
                    x.PortalId = checkout.PortalID;
                    x.UserId = checkout.ShoppingCart.UserId;
                    x.CurrencyCode = checkout.ShoppingCart.CurrencyCode;
                    x.CultureCode = checkout.ShoppingCart.CultureCode;
                    x.Coupons = checkout.ShoppingCart.Coupons;
                    x.PublishStateId = checkout.ShoppingCart.PublishStateId;
                    x.IsAllowWithOtherPromotionsAndCoupons = checkout.ShoppingCart.IsAllowWithOtherPromotionsAndCoupons;
                    x.Calculate();
                });
            }
            else
            {
                // Do the cart calculation



                checkout.ShoppingCart.AddressCarts.ForEach(x =>
                {


                    x.Shipping = string.IsNullOrEmpty(x.Shipping.ShippingName) ? new Libraries.ECommerce.Entities.ZnodeShipping
                    {
                        ShippingID = checkout.ShoppingCart.Shipping.ShippingID,
                        ShippingName = checkout.ShoppingCart.Shipping.ShippingName,
                        ShippingCountryCode = checkout?.ShoppingCart?.Shipping.ShippingCountryCode
                    } : x.Shipping;
                    x.Payment = checkout.ShoppingCart.Payment;
                    x.PortalId = checkout.PortalID;
                    x.UserId = checkout.ShoppingCart.UserId;
                    x.CurrencyCode = checkout.ShoppingCart.CurrencyCode;
                    x.CultureCode = checkout.ShoppingCart.CultureCode;
                    x.OrderId = checkout.ShoppingCart.OrderId;
                    x.IsCchCalculate = checkout.ShoppingCart.IsCchCalculate;
                    x.ReturnItemList = checkout.ShoppingCart.ReturnItemList;
                    x.OrderDate = checkout.ShoppingCart.OrderDate;
                    x.Coupons = checkout.ShoppingCart.Coupons;
                    x.PublishStateId = checkout.ShoppingCart.PublishStateId;
                    x.IsAllowWithOtherPromotionsAndCoupons = checkout.ShoppingCart.IsAllowWithOtherPromotionsAndCoupons;

                    //CUSTOMIZATION: CONVERTING CART TO CUSTOMCART TO CALCULATE USING WAREHOUSE DICTIONARIES AND ZIP CODES
                    //TODO: Rather than convert carts, make Checkout object a customcheckout with CustomShoppingCart as Portal Cart and Address Carts
                    CustomShoppingCart y = _customShoppingCartMap.ToZnodeShoppingCart(x);
                    AppendWarehouseInformation(checkout.ShoppingCart, y);
                    y.CookieMappingId = cookieId;
                    y.Calculate();
                    x.OrderLevelShipping = y.OrderLevelShipping;
                    x.Shipping = y.Shipping;

                });
            }

            //CUSTOMIZATION: CONVERTING CART TO CUSTOMCART TO CALCULATE USING WAREHOUSE DICTIONARIES AND ZIP CODES
            //TODO: Rather than convert carts, make Checkout object a customcheckout with CustomShoppingCart as Portal Cart and Address Carts
            CustomShoppingCart customPortalCart = _customShoppingCartMap.ToZnodeShoppingCart(checkout.ShoppingCart);
            customPortalCart.CookieMappingId = cookieId;
            customPortalCart.Calculate();
            checkout.ShoppingCart.Shipping = customPortalCart.Shipping;
            checkout.ShoppingCart.CustomTaxCost = customPortalCart.TaxCost; //To set the calculated tax to taxcost

            // AFTER CALCULATING SHIPPING, A DICTIONARY OF SHIPPERS AND WAREHOUSE CODES IS SAVED TO CUSTOM 1 TO DISPLAY THE WAREHOUSE CODE IN THE ADMIN.
            if (customPortalCart.WarehouseNameCodeDictionary != null)
                checkout.ShoppingCart.Custom1 = JsonConvert.SerializeObject(customPortalCart.WarehouseNameCodeDictionary);

            //atish Ups 00 to save ups method in custom1 i.e WarehouseNameCodeDictionary
            if (customPortalCart.Custom5!= null)
            {
                ShippingListModel list = _shippingservice.GetShippingList(null, new FilterCollection(), null, null);
                Dictionary<string, string> carrierMethodups = new Dictionary<string, string>();
                var shippingUps = list.ShippingList.FirstOrDefault(x => x.ShippingCode == customPortalCart.Custom5);
                if (customPortalCart.WarehouseNameCodeDictionary.ContainsKey("_carrierMethods"))
                {
                    carrierMethodups = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(customPortalCart.WarehouseNameCodeDictionary["_carrierMethods"]);
                }
                carrierMethodups.Add("UPS", shippingUps.ShippingName);

                customPortalCart.WarehouseNameCodeDictionary["_carrierMethods"] = Newtonsoft.Json.JsonConvert.SerializeObject(carrierMethodups);
                checkout.ShoppingCart.Custom1 = JsonConvert.SerializeObject(customPortalCart.WarehouseNameCodeDictionary);
            }
            //atish Ups 00 to save ups method in custom1 i.e WarehouseNameCodeDictionary End


            //checkout.ShoppingCart.OrderLevelShipping = customPortalCart.OrderLevelShipping;
            //nivi code start to calculate second shipping when tax applied
            checkout.ShoppingCart.OrderLevelShipping = model.ShippingCost;
            checkout.ShoppingCart.ShippingCost = model.ShippingCost;
            string omsSavedCardLineItemIds = string.Join(",", model.ShoppingCartItems.Select(x => x.OmsSavedcartLineItemId).ToList());
            string optionalFeeIds = ((CustomShoppingCartService)_shoppingCartService).GetOptionalFeeIds(omsSavedCardLineItemIds);
            checkout.ShoppingCart.Custom5 = (optionalFeeIds != null && optionalFeeIds != "NULL") ? optionalFeeIds : "";
            //nivi code end

            //checkout.ShoppingCart.Calculate();

            ZnodeLogging.LogMessage("Execution done:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            return checkout;
        }

        private void AppendWarehouseInformation(IZnodePortalCart model, CustomShoppingCart znodeShoppingCart)
        {
            /// customization
            //ShippingListModel list = GetShippingEstimates(shoppingCartModel.ShippingAddress.PostalCode, shoppingCartModel);

            List<ConpacWarehouseAttribute> warehouseZipcodeList = _conpacWarehouseAttributeRepository.Table.Where(o => o.Type == "ZIP").ToList();
            FilterCollection filters = new FilterCollection();

            //znodeShoppingCart.WarehouseZipcodeList = warehouseZipcodeList;
            ConpacWarehouseAttribute postalCodeWarehouse = null;
            if (model.Payment != null && model.Payment.ShippingAddress != null)
            {
                postalCodeWarehouse = warehouseZipcodeList.FirstOrDefault(o => o.Value == model.Payment.ShippingAddress.PostalCode);
            }
            else if (model.Payment.ShippingAddress != null && model.Payment.ShippingAddress.PostalCode != null)
            {
                postalCodeWarehouse = warehouseZipcodeList.FirstOrDefault(o => o.Value == model.Payment.ShippingAddress.PostalCode);
            }

            if (postalCodeWarehouse != null)
            {
                znodeShoppingCart.MyWarehouseId = postalCodeWarehouse.WarehouseId;
                ConpacWarehouseAttribute orderMinWarehouse = _conpacWarehouseAttributeRepository.Table.FirstOrDefault(o => o.Type == "MIN" && o.WarehouseId == postalCodeWarehouse.WarehouseId);
                ConpacWarehouseAttribute flatRateWarehouse = _conpacWarehouseAttributeRepository.Table.FirstOrDefault(o => o.Type == "RAT" && o.WarehouseId == postalCodeWarehouse.WarehouseId);
                ConpacWarehouseAttribute shipperName = _conpacWarehouseAttributeRepository.Table.FirstOrDefault(o => o.Type == "SHP" && o.WarehouseId == postalCodeWarehouse.WarehouseId);
                decimal orderMin = 0;
                if (orderMinWarehouse != null)
                {
                    decimal.TryParse(orderMinWarehouse.Value, out orderMin);
                    znodeShoppingCart.MyWarehouseOrderMin = orderMin;
                    znodeShoppingCart.MyWarehouseShipperName = (shipperName == null ? "" : shipperName.Value);
                }

                var accountId = model.Payment?.ShippingAddress?.AccountId;
                if (accountId == 0)
                {
                    try
                    {
                        var addressId = model.Payment?.ShippingAddress?.AddressId;
                        var address1 = model.Payment?.ShippingAddress?.Address1;
                        IZnodeRepository<ZnodeAccountAddress> _addressUserRepository = new ZnodeRepository<ZnodeAccountAddress>();
                        accountId = (from p in _addressRepository.Table
                                     join q in _addressUserRepository.Table
                                         on p.AddressId equals q.AddressId
                                     where /*(q.UserId == model.UserId) &&*/ (p.AddressId == addressId || p.Address1 == address1)
                                     select q.AccountId /*p.ZnodeAccountAddresses.FirstOrDefault() == null? 0: p.ZnodeAccountAddresses.FirstOrDefault().AccountId*/).FirstOrDefault();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                    }
                }
                GlobalAttributeEntityDetailsModel attributesEntity = accountId > 0 ? attributeGroupEntityService.GetEntityAttributeDetails(accountId.Value, ZnodeConstant.Account) : new GlobalAttributeEntityDetailsModel { Groups = new List<GlobalAttributeGroupModel>(), Attributes = new List<GlobalAttributeValuesModel>() };
                if (attributesEntity != null && attributesEntity.Attributes != null)
                {
                    GlobalAttributeValuesModel customerFreightOverride = attributesEntity.Attributes.FirstOrDefault(o => o.AttributeCode == "CustomerFreeFreightOverride");
                    if (customerFreightOverride != null && customerFreightOverride.AttributeValue != null)
                    {
                        decimal customOverride;
                        decimal.TryParse(customerFreightOverride.AttributeValue, out customOverride);
                        if (customOverride < orderMin && customOverride > 0)
                        {
                            znodeShoppingCart.MyWarehouseOrderMin = customOverride;
                        }
                    }

                }

                // warehouses have a minimum rate for local shipping. This rate is added to the custom shopping cart
                if (flatRateWarehouse != null && flatRateWarehouse.Value != null)
                {
                    decimal flatRate = 0;
                    decimal.TryParse(flatRateWarehouse.Value, out flatRate);
                    znodeShoppingCart.MyWarehouseFlatRate = flatRate;

                }

            }

            /// end custization
        }

        //to update order status.
        public override bool UpdateOrderStatus(OrderStateParameterModel model)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            ZnodeLogging.LogMessage("OrderStateParameterModel with Id: ", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { OmsOrderId = model?.OmsOrderId });
            bool updated = false;

            ZnodeOmsOrderDetail order = IsValidOrder(model);

            if (IsNotNull(order))
            {
                int previousOrderStateId = order.OmsOrderStateId;
                order.OmsOrderStateId = model.OmsOrderStateId;
                order.TrackingNumber = model.TrackingNumber;
                order.ModifiedDate = GetDateTime();
                List<ZnodeOmsOrderState> orderStateList = _omsOrderStateRepository.GetEntityList(string.Empty)?.ToList();
                ZnodeLogging.LogMessage("orderStateList Count: ", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { orderStateListCount = orderStateList?.Count });

                if (orderStateList?.Count > 0)
                {
                    if (order.OmsOrderStateId.Equals(orderStateList?.FirstOrDefault(x => x.OrderStateName == ZnodeOrderStatusEnum.SHIPPED.ToString())?.OmsOrderStateId))
                        order.ShipDate = DateTime.Now;
                    else if (order.OmsOrderStateId.Equals(orderStateList?.FirstOrDefault(x => x.OrderStateName == ZnodeOrderStatusEnum.RETURNED.ToString())?.OmsOrderStateId))
                        order.ReturnDate = GetDateTime().Date + GetDateTime().TimeOfDay;
                }

                updated = _orderDetailsRepository.Update(order);
                if (updated)
                    UpdateLineItemState(model.OmsOrderId, previousOrderStateId, model.OmsOrderStateId, order.ShipDate);
                //Cancel tax transaction.
                CancelTaxTransaction(updated, order, orderStateList);

                if (updated && orderHelper.IsSendEmail(order.OmsOrderStateId))
                {
                    OrderModel orderModel = GetOrderById(order.OmsOrderId, null, GetOrderExpands());
                    SendOrderStatusEmail(orderModel);
                    if (updated && order.OmsOrderStateId == 20)
                    {
                        PostDataToKlaviyo(orderModel);
                    }
                    return true;
                }
            }
            return updated;
        }
        //Cancel tax transaction.
        private static void CancelTaxTransaction(bool updated, ZnodeOmsOrderDetail order, List<ZnodeOmsOrderState> orderStateList)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            bool isCancelledOrder = order.OmsOrderStateId.Equals(orderStateList?.FirstOrDefault(x => x.OrderStateName == ZnodeOrderStatusEnum.CANCELED.ToString())?.OmsOrderStateId);
            if (updated && isCancelledOrder)
            {
                IZnodeTaxHelper taxHelper = GetService<IZnodeTaxHelper>();
                int? omsLineItemId = order?.ZnodeOmsOrderLineItems?.FirstOrDefault()?.OmsOrderLineItemsId;
                if (IsNotNull(omsLineItemId))
                    taxHelper.CancelTaxTransaction(omsLineItemId.Value, order?.PortalId);
            }
            ZnodeLogging.LogMessage("Execution done:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
        }

        // To post the data to klaviyo
        public void PostDataToKlaviyo(OrderModel orderModel)
        {
            //string cookieValue = GetFromCookie(WebStoreConstants.CartCookieKey);
            //ShoppingCartModel shoppingCartModel = _shoppingCartClient.GetShoppingCart(new CartParameterModel
            //{
            //    CookieMappingId = cookieValue,
            //    LocaleId = PortalAgent.LocaleId,
            //    PortalId = PortalAgent.CurrentPortal.PortalId,
            //    PublishedCatalogId = GetCatalogId().GetValueOrDefault(),
            //    UserId = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey)?.UserId
            //});
            //HttpContext.Current = httpContext;
            //IKlaviyoClient _klaviyoClient = GetComponentClient<IKlaviyoClient>(GetService<IKlaviyoClient>());
            KlaviyoProductDetailModel klaviyoProductDetailModel = MapShoppingCartModelToKlaviyoModel(orderModel);
            bool isTrackKlaviyo = _service.KlaviyoTrack(klaviyoProductDetailModel);
        }

        // Map the order model to klaviyo model
        public KlaviyoProductDetailModel MapShoppingCartModelToKlaviyoModel(OrderModel orderModel)
        {
            KlaviyoProductDetailModel klaviyoProductDetailModel = new KlaviyoProductDetailModel();
            klaviyoProductDetailModel.OrderLineItems = new List<OrderLineItemDetailsModel>();
            klaviyoProductDetailModel.PortalId = orderModel.PortalId;
            //UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);
            //if (HelperUtility.IsNull(userViewModel))
            //userViewModel = _userClient.GetUserDetailById(shoppingCartModel.UserId.GetValueOrDefault(), shoppingCartModel.PortalId)?.ToViewModel<UserViewModel>();
            //userViewModel = shoppingCartModel.UserDetails.ToViewModel<UserViewModel>();
            klaviyoProductDetailModel.FirstName = orderModel?.FirstName;
            klaviyoProductDetailModel.LastName = orderModel?.LastName;
            klaviyoProductDetailModel.Email = orderModel?.Email;
            klaviyoProductDetailModel.StoreName = orderModel.StoreName;
            klaviyoProductDetailModel.PropertyType = 5;
            foreach (OrderLineItemModel OrderLineItems in orderModel.OrderLineItems)
            {
                klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = OrderLineItems.ProductName, SKU = OrderLineItems.Sku, Quantity = OrderLineItems.Quantity, UnitPrice = OrderLineItems.Price, Image = OrderLineItems.ProductImagePath });
            }
            return klaviyoProductDetailModel;
        }

        //Get order list.
        public override OrdersListModel GetOrderList(NameValueCollection expands, FilterCollection filters, NameValueCollection sorts, NameValueCollection page)
        {
            ZnodeLogging.LogMessage("Execution started.", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            Dictionary<string, string> OptionalFee = new Dictionary<string, string> { { "1", "Limited Access Fee - $65.00 " }, { "2", "Inside Delivery Fee - $60.00" }, { "3", "Lift Gate Fee - $75.00" }, { "4", "Notification Prior to Delivery Fee - $25.00" } };
            //Bind the Filter conditions for the authorized portal access.
            BindUserPortalFilter(ref filters);
            //Replace sort key name.
            if (IsNotNull(sorts))
                ReplaceSortKeys(ref sorts);

            int userId = 0;
            GetUserIdFromFilters(filters, ref userId);
            //Add date time value in filter collection against filter column name Order date.
            filters = ServiceHelper.AddDateTimeValueInFilterByName(filters, Engine.Services.Constants.FilterKeys.OrderDate);

            int fromAdmin = Convert.ToInt32(filters?.Find(x => string.Equals(x.FilterName, Znode.Libraries.ECommerce.Utilities.FilterKeys.IsFromAdmin, StringComparison.CurrentCultureIgnoreCase))?.Item3);
            filters?.RemoveAll(x => string.Equals(x.FilterName, Znode.Libraries.ECommerce.Utilities.FilterKeys.IsFromAdmin, StringComparison.CurrentCultureIgnoreCase));
            ReplaceFilterKeys(ref filters);
            PageListModel pageListModel = new PageListModel(filters, sorts, page);
            IList<OrderModel> list = GetOrderList(pageListModel, userId, fromAdmin);
            foreach (OrderModel order in list)
            {
                List<ZnodeOmsNote> Noteslist = new List<ZnodeOmsNote>();
                ZnodeOmsOrderDetail omsOrderDetail = _orderOrderDetailRepository.Table.Where(w => w.OmsOrderDetailsId == order.OmsOrderDetailsId).FirstOrDefault();
                List<ZnodeOmsOrderLineItem> orderLineItemDetails = orderHelper.GetOrderLineItemByOrderId(order.OmsOrderDetailsId).ToList();
                List<OrderLineItemModel> orderLineItemModel = orderLineItemDetails?.ToModel<OrderLineItemModel>().Distinct().ToList();
                //customization to send UOM data
                try
                {
                    var itemCarriersDic = new Dictionary<string, string>();
                    if (IsNotNull(omsOrderDetail.Custom4))
                    {
                        foreach (var item in omsOrderDetail.Custom4?.Split('^'))
                        {
                            if (item != "{}" && item != "" && item != "{" && IsJson(item))
                            {
                                var dict = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(item);
                                if (itemCarriersDic == null || itemCarriersDic.Count == 0)
                                {
                                    foreach (var carr in dict)
                                    {
                                        itemCarriersDic.Add(carr.Key, carr.Value);
                                    }
                                }
                                else
                                {
                                    foreach (var carr in dict)
                                    {
                                        if (itemCarriersDic.ContainsKey(carr.Key))
                                        {
                                            continue;
                                        }
                                        itemCarriersDic.Add(carr.Key, carr.Value);
                                    }
                                }
                            }
                        }
                    }
                    

                    
                    foreach (OrderLineItemModel lineItem in orderLineItemModel)
                    {

                        if (lineItem.Custom3 != null && IsJson(lineItem.Custom3))
                        {
                            var uomModeldata = Newtonsoft.Json.JsonConvert.DeserializeObject<PHUomModel>(lineItem.Custom3);
                            var ss = itemCarriersDic.Where(x => x.Key == lineItem.Sku).FirstOrDefault();

                            switch (ss.Value)
                            {
                                case "JIT":
                                    lineItem.Custom3 = uomModeldata.JITBuyUOM;
                                    break;

                                case "Box Partners":
                                    lineItem.Custom3 = uomModeldata.BuyUOM;
                                    break;

                                default:
                                    lineItem.Custom3 = uomModeldata.PriceUnitDescription;
                                    break;
                            }
                        }


                    }
                }
                catch (Exception ex)
                {

                    throw;
                }
                //customization to send UOM data end

                order.OrderLineItems = orderLineItemModel;
                int OrderShipmentId = Convert.ToInt32(orderLineItemDetails.FirstOrDefault()?.OmsOrderShipmentId);
                order.ShippingAddress = SetShippingAddress(OrderShipmentId);
                if (!string.IsNullOrEmpty(omsOrderDetail.Custom5))
                {
                    var OptionalFeeIDs = omsOrderDetail.Custom5.Split(',').ToList();
                    var listFee = new List<string>();
                    foreach (var id in OptionalFeeIDs)
                    {
                        listFee.Add(OptionalFee[id]);
                    }
                    order.Custom5 = string.Join(", ", listFee);
                }
                if(!string.IsNullOrEmpty(omsOrderDetail.Custom4))
                {
                    order.Custom4 = omsOrderDetail.Custom4;
                }
                if(!string.IsNullOrEmpty(omsOrderDetail.CouponCode))
                {
                    order.CouponCode = omsOrderDetail.CouponCode;
                }
                order.BillingAddress = SetBillingAddress(omsOrderDetail);
                order.Custom1 = omsOrderDetail.Custom1;
                order.PurchaseOrderNumber = omsOrderDetail.PurchaseOrderNumber;
                ZnodeUser user = new ZnodeRepository<ZnodeUser>().Table.Where(x => x.UserId == order.UserId).FirstOrDefault();
                order.ExternalId = user.ExternalId;
                var AccountCode = _accountRepository.Table.Where(x => x.AccountId == user.AccountId).FirstOrDefault()?.AccountCode;
                order.AccountNumber = AccountCode;
                Noteslist = _omsNoteRepository.Table.Where(x => x.OmsOrderDetailsId == order.OmsOrderDetailsId).ToList();
                order.OrderNotes = MaptoOrderListModel(Noteslist);

            }
            OrdersListModel orderListModel = new OrdersListModel() { Orders = list?.ToList() };

            GetCustomerName(userId, orderListModel);
            orderListModel.BindPageListModel(pageListModel);
            ZnodeLogging.LogMessage("Execution done.", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            return orderListModel;
        }
        private static bool IsJson(string input)
        {
            try
            {
                JsonConvert.DeserializeObject(input);
                return true;
            }
            catch (JsonReaderException)
            {
                return false;
            }
        }


        private AddressModel SetShippingAddress(int OrderShipmentId)
        {
            string ShippingcompanyName = string.Empty;
            ZnodeOmsOrderShipment OrderShipment = _orderOrderShipmentRepository.Table.Where(x => x.OmsOrderShipmentId == OrderShipmentId).FirstOrDefault();
            try
            {
                ShippingcompanyName = _addressRepository.Table.Where(x => x.AddressId == OrderShipment.AddressId)?.FirstOrDefault()?.CompanyName;
            }
            catch (Exception ex)
            {

            }
            AddressModel addressModel = new AddressModel();
            addressModel.FirstName = OrderShipment.ShipToFirstName;
            addressModel.LastName = OrderShipment.ShipToLastName;
            addressModel.EmailAddress = OrderShipment.ShipToEmailId;

            //addressModel.CompanyName = OrderShipment.ShipToCompanyName;
            addressModel.CompanyName = ShippingcompanyName;

            addressModel.CityName = OrderShipment.ShipToCity;

            addressModel.StateCode = OrderShipment.ShipToStateCode;

            addressModel.CountryCode = OrderShipment.ShipToCountry;

            addressModel.PostalCode = OrderShipment.ShipToPostalCode;

            addressModel.Address1 = OrderShipment.ShipToStreet1;

            addressModel.Address2 = OrderShipment.ShipToStreet2;
            addressModel.PhoneNumber = OrderShipment.ShipToPhoneNumber;

            return addressModel;
        }

        private AddressModel SetBillingAddress(ZnodeOmsOrderDetail omsOrderDetail)
        {
            AddressModel addressModel = new AddressModel();
            addressModel.FirstName = omsOrderDetail.BillingFirstName;
            addressModel.LastName = omsOrderDetail.BillingLastName;
            addressModel.EmailAddress = omsOrderDetail.BillingEmailId;

            addressModel.CompanyName = omsOrderDetail.BillingCompanyName;

            addressModel.CityName = omsOrderDetail.BillingCity;

            addressModel.StateCode = omsOrderDetail.BillingStateCode;

            addressModel.CountryCode = omsOrderDetail.BillingCountry;

            addressModel.PostalCode = omsOrderDetail.BillingPostalCode;

            addressModel.Address1 = omsOrderDetail.BillingStreet1;

            addressModel.Address2 = omsOrderDetail.BillingStreet2;
            addressModel.PhoneNumber = omsOrderDetail.BillingPhoneNumber;
            return addressModel;
        }

        public List<OrderNotesModel> MaptoOrderListModel(List<ZnodeOmsNote> OmsNotesList)
        {
            OrderNotesModel neworderlistmodel = new OrderNotesModel ();
            List<OrderNotesModel> newListOrderlistmodel = new List<OrderNotesModel>();

            foreach (ZnodeOmsNote Notes in OmsNotesList)
            {
                neworderlistmodel.OmsOrderDetailsId = Notes.OmsOrderDetailsId;
                neworderlistmodel.Notes = Notes.Notes;
                newListOrderlistmodel.Add(neworderlistmodel);
            }
            return newListOrderlistmodel;
        }


    }
}
