using System;
using System.Collections.Generic;
using System.Linq;
using Znode.Engine.Api.Models;
using Znode.Libraries.Admin;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.MongoDB.Data;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using Entities = Znode.Libraries.ECommerce.Entities;
using Znode.Engine.Services.Maps;
using Znode.Engine.Services;
using Znode.Engine.Shipping.Custom.Interface;

namespace Znode.Engine.Shipping.Custom.Maps
{
    public class CustomShoppingCartMap : ICustomShoppingCartMap
    {

        private readonly IShoppingCartItemMap shoppingCartItemMap;

        public CustomShoppingCartMap()
        {
            shoppingCartItemMap = GetService<IShoppingCartItemMap>();
        }

        public virtual ShoppingCartModel ToModel(CustomShoppingCart znodeCart, IImageHelper objImage = null)
        {
            if (IsNull(znodeCart))
                return new ShoppingCartModel();

            ShoppingCartModel model = new ShoppingCartModel
            {
                Discount = znodeCart.Discount,
                GiftCardAmount = znodeCart.GiftCardAmount,
                GiftCardApplied = znodeCart.IsGiftCardApplied,
                GiftCardMessage = znodeCart.GiftCardMessage,
                GiftCardNumber = znodeCart.GiftCardNumber,
                GiftCardValid = znodeCart.IsGiftCardValid,
                GiftCardBalance = znodeCart.GiftCardBalance,
                MultipleShipToEnabled = znodeCart.IsMultipleShipToAddress,
                OrderLevelDiscount = znodeCart.OrderLevelDiscount,
                OrderLevelShipping = znodeCart.OrderLevelShipping,
                OrderLevelTaxes = znodeCart.OrderLevelTaxes,
                ProfileId = znodeCart.ProfileId,
                PortalId = znodeCart.PortalId.GetValueOrDefault(),
                UserId = znodeCart.UserId,
                SalesTax = znodeCart.SalesTax,
                ShippingCost = IsNotNull(znodeCart.Shipping) ? znodeCart.ShippingCost : 0,
                ShippingDifference = IsNotNull(znodeCart.Shipping) ? znodeCart.ShippingDifference : 0,
                SubTotal = znodeCart.SubTotal,
                TaxCost = znodeCart.TaxCost,
                Shipping = ShippingMap.ToModel(znodeCart.Shipping),
                TaxRate = znodeCart.TaxRate,
                Total = znodeCart.Total,
                LocaleId = znodeCart.LocalId,
                PublishedCatalogId = znodeCart.PublishedCatalogId,
                OmsOrderId = znodeCart.OrderId,
                ShippingId = znodeCart.Shipping.ShippingID,
                CSRDiscountAmount = znodeCart.CSRDiscountAmount,
                CSRDiscountDescription = znodeCart.CSRDiscountDescription,
                CSRDiscountApplied = znodeCart.CSRDiscountApplied,
                CSRDiscountMessage = znodeCart.CSRDiscountMessage,
                CurrencyCode = znodeCart.CurrencyCode,
                CultureCode = znodeCart.CultureCode,
                CurrencySuffix = znodeCart.CurrencySuffix,
                CookieMappingId = new ZnodeEncryption().EncryptData(znodeCart.CookieMappingId.ToString()),
                CustomShippingCost = znodeCart.CustomShippingCost,
                CustomTaxCost = znodeCart.CustomTaxCost,
                IsLineItemReturned = znodeCart.IsLineItemReturned,
                EstimateShippingCost = znodeCart.EstimateShippingCost,
                Custom1 = znodeCart.Custom1,
                Custom2 = znodeCart.Custom2,
                Custom3 = znodeCart.Custom3,
                Custom4 = znodeCart.Custom4,
                Custom5 = znodeCart.Custom5,
                TotalAdditionalCost = znodeCart.TotalAdditionalCost,
                IsAllowWithOtherPromotionsAndCoupons = znodeCart.IsAllowWithOtherPromotionsAndCoupons
            };

            foreach (ZnodeShoppingCartItem cartItem in znodeCart.ShoppingCartItems)
                model.ShoppingCartItems.Add(shoppingCartItemMap.ToModel(cartItem, znodeCart, objImage));

            foreach (Entities.ZnodeCoupon coupon in znodeCart?.Coupons)
                model.Coupons.Add(CouponMap.ToModel(coupon));

            if ((model.ShippingCost.Equals(0) && (model.Shipping.ShippingDiscount > 0) && (model.Shipping.ShippingId > 0)) || model.Shipping.ShippingDiscountApplied)
                model.FreeShipping = true;

            int FreeShippingItemsCount = 0;
            int NonFreeShippingItemsCount = 0;
            foreach (ZnodeShoppingCartItem cartItem in znodeCart.ShoppingCartItems)
            {
                OrderAttributeModel orderAttributeModel = cartItem.Product.Attributes.Find(x => string.Equals(x.AttributeCode, "IsDownloadable", StringComparison.InvariantCultureIgnoreCase) && string.Equals(x.AttributeValue, "true", StringComparison.InvariantCultureIgnoreCase));
                if (cartItem.Product.FreeShippingInd || orderAttributeModel != null)
                    FreeShippingItemsCount++;
                else NonFreeShippingItemsCount++;
            }
            if (NonFreeShippingItemsCount <= 0 && FreeShippingItemsCount > 0) model.FreeShipping = true;
            return model;
        }

        public virtual CustomShoppingCart ToZnodeShoppingCart(ShoppingCartModel model, UserAddressModel userDetails = null)
        {
            if (IsNull(model))
                return null;

            CustomShoppingCart znodeCart = (CustomShoppingCart)GetService<IZnodeShoppingCart>();

            znodeCart.GiftCardAmount = model.GiftCardAmount;
            znodeCart.GiftCardMessage = model.GiftCardMessage;
            znodeCart.GiftCardNumber = model.GiftCardNumber ?? String.Empty;
            znodeCart.IsGiftCardApplied = model.GiftCardApplied;
            znodeCart.IsGiftCardValid = model.GiftCardValid;
            znodeCart.OrderLevelDiscount = model.OrderLevelDiscount;
            znodeCart.OrderLevelShipping = model.OrderLevelShipping;
            znodeCart.OrderLevelTaxes = model.OrderLevelTaxes;
         //   znodeCart.Payerid = model.Payerid;
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

            if (IsNull(znodeCart.Payment))
                znodeCart.Payment = new Entities.ZnodePayment();

            znodeCart.Payment.BillingAddress = model?.BillingAddress ?? new AddressModel();
            if (znodeCart.Payment.ShippingAddress == null || znodeCart.Payment.ShippingAddress.Address1 == null)
            {
                znodeCart.Payment.ShippingAddress = model.Payment?.ShippingAddress ?? new AddressModel();
            }

            if (Equals(model.ShippingAddress, null) || Equals(model.ShippingAddress.Address1, null))
                model.ShippingAddress = model?.Payment?.ShippingAddress ?? new AddressModel();


            if (IsNotNull(userDetails))
                znodeCart.UserAddress = userDetails;

            IPublishProductHelper publishProductHelper = GetService<IPublishProductHelper>();

            List<string> skus = new List<string>();

            foreach (ShoppingCartItemModel item in model.ShoppingCartItems)
            {
                if (!string.IsNullOrEmpty(item.ConfigurableProductSKUs))
                    skus.Add(item.ConfigurableProductSKUs.ToLower());

                skus.Add(item.SKU.ToLower());
            }
            skus = skus.Distinct().ToList();

            //List<ConfigurableProductEntity> configEntities;
            List<PublishedConfigurableProductEntityModel> configEntities;

            List<string> navigationProperties = new List<string> { ZnodeConstant.Promotions, ZnodeConstant.Pricing, ZnodeConstant.Inventory, ZnodeConstant.SEO };

            int catalogVersionId = publishProductHelper.GetCatalogVersionId(model.PublishedCatalogId,model.LocaleId);

            List<PublishProductModel> cartLineItemsProductData = publishProductHelper.GetDataForCartLineItems(skus, model.PublishedCatalogId, model.LocaleId, navigationProperties, model.UserId.GetValueOrDefault(), model.PortalId, catalogVersionId, out configEntities);

            List<TaxClassRuleModel> lstTaxClassSKUs = publishProductHelper.GetTaxRules(skus);

            List<ZnodePimDownloadableProduct> lstDownloadableProducts = new ZnodeRepository<ZnodePimDownloadableProduct>().Table.Where(x => skus.Contains(x.SKU)).ToList();

            //List<ConfigurableProductEntity> configEntities = publishProductHelper.GetConfigurableProductEntity(cartLineItemsProductData.Select(x => x.PublishProductId).Distinct().ToList(), catalogVersionId);

            // znodeCart.AddtoShoppingBagV2(model, cartLineItemsProductData, catalogVersionId, lstTaxClassSKUs, lstDownloadableProducts, configEntities);
            znodeCart.AddtoShoppingBagV2(model, cartLineItemsProductData, catalogVersionId, lstTaxClassSKUs, lstDownloadableProducts, configEntities);
            if (IsNotNull(model?.Coupons))
            {
                foreach (CouponModel coupon in model?.Coupons)
                    znodeCart.Coupons.Add(CouponMap.ToZnodeCoupon(coupon));
            }

            return znodeCart;
        }

        public virtual CustomShoppingCart ToZnodeShoppingCart(IZnodeMultipleAddressCart model, UserAddressModel userDetails = null)
        {
            if (IsNull(model))
                return null;

            CustomShoppingCart znodeCart = (CustomShoppingCart)GetService<IZnodeShoppingCart>();

            znodeCart.GiftCardAmount = model.GiftCardAmount;
            znodeCart.GiftCardMessage = model.GiftCardMessage;
            znodeCart.GiftCardNumber = model.GiftCardNumber ?? String.Empty;
            znodeCart.OrderLevelDiscount = model.OrderLevelDiscount;
            znodeCart.OrderLevelShipping = model.OrderLevelShipping;
            znodeCart.OrderLevelTaxes = model.OrderLevelTaxes;
           // znodeCart.Payerid = model.Payerid;
            //znodeCart.Payment = PaymentMap.ToZnodePayment(model.Payment, (model.IsMultipleShipToAddress) ? model?.ShoppingCartItems?[0].ShippingAddress : model, model.BillingAddress);
            znodeCart.ProfileId = model.ProfileId;
            znodeCart.SalesTax = model.SalesTax;
            znodeCart.Shipping = model.Shipping;
            znodeCart.TaxRate = model.TaxRate;
            znodeCart.Token = model.Token;
            znodeCart.PortalId = model.PortalId;
            znodeCart.OrderId = model.OrderId;
            znodeCart.OrderDate = model.OrderDate;
            znodeCart.UserId = model.UserId;
            znodeCart.LocalId = model.LocalId;
            znodeCart.CookieMappingId = model.CookieMappingId;
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
            znodeCart.TotalAdditionalCost = model.TotalAdditionalCost;
            znodeCart.IsAllowWithOtherPromotionsAndCoupons = model.IsAllowWithOtherPromotionsAndCoupons;
            znodeCart.PublishStateId = model.PublishStateId;


            if (IsNull(znodeCart.Payment))
                znodeCart.Payment = new Entities.ZnodePayment();

            //znodeCart.Payment.BillingAddress = model?.BillingAddress ?? new AddressModel();

            //if (Equals(model.ShippingAddress, null))
            //    model.ShippingAddress = model?.Payment?.ShippingAddress ?? new AddressModel();


            if (IsNotNull(userDetails))
                znodeCart.UserAddress = userDetails;

            IPublishProductHelper publishProductHelper = GetService<IPublishProductHelper>();

            List<string> skus = new List<string>();

            //foreach (ZnodeShoppingCartItem item in model.ShoppingCartItems)
            //{
            //    if (!string.IsNullOrEmpty(item.co))
            //        skus.Add(item.ConfigurableProductSKUs.ToLower());

            //    skus.Add(item.SKU.ToLower());
            //}
            //skus = skus.Distinct().ToList();

            //List<string> navigationProperties = new List<string> { ZnodeConstant.Promotions, ZnodeConstant.Pricing, ZnodeConstant.Inventory, ZnodeConstant.SEO };

            //int catalogVersionId = publishProductHelper.GetCatalogVersionId(model.PublishedCatalogId, model.LocalId);

            //List<PublishProductModel> cartLineItemsProductData = publishProductHelper.GetDataForCartLineItems(skus, model.PublishedCatalogId, model.LocalId, navigationProperties, model.UserId.GetValueOrDefault(), model.PortalId, catalogVersionId);

            //List<TaxClassRuleModel> lstTaxClassSKUs = publishProductHelper.GetTaxRules(skus);

            //List<ZnodePimDownloadableProduct> lstDownloadableProducts = new ZnodeRepository<ZnodePimDownloadableProduct>().Table.Where(x => skus.Contains(x.SKU)).ToList();

            //List<ConfigurableProductEntity> configEntities = publishProductHelper.GetConfigurableProductEntity(cartLineItemsProductData.Select(x => x.PublishProductId).Distinct().ToList(), catalogVersionId);

            //znodeCart.AddtoShoppingBagV2(model, cartLineItemsProductData, catalogVersionId, lstTaxClassSKUs, lstDownloadableProducts, configEntities);

            //if (IsNotNull(model?.Coupons))
            //{
            //    foreach (CouponModel coupon in model?.Coupons)
            //        znodeCart.Coupons.Add(CouponMap.ToZnodeCoupon(coupon));
            //}

            return znodeCart;
        }

        public virtual CustomShoppingCart ToZnodeShoppingCart(IZnodePortalCart portalCart, UserAddressModel userDetails = null)
        {
            if (IsNull(portalCart))
                return null;

            CustomShoppingCart znodeCart = (CustomShoppingCart)GetService<IZnodeShoppingCart>();

            znodeCart.GiftCardAmount = portalCart.GiftCardAmount;
            znodeCart.GiftCardMessage = portalCart.GiftCardMessage;
            znodeCart.GiftCardNumber = portalCart.GiftCardNumber ?? String.Empty;
            znodeCart.OrderLevelDiscount = portalCart.OrderLevelDiscount;
            znodeCart.OrderLevelShipping = portalCart.OrderLevelShipping;
            znodeCart.OrderLevelTaxes = portalCart.OrderLevelTaxes;
            //znodeCart.Payerid = portalCart.Payerid;
            //znodeCart.Payment = PaymentMap.ToZnodePayment(portalCart.Payment, (portalCart.IsMultipleShipToAddress) ? portalCart?.ShoppingCartItems?[0].ShippingAddress : portalCart, portalCart.BillingAddress);
            znodeCart.ProfileId = portalCart.ProfileId;
            znodeCart.SalesTax = portalCart.SalesTax;
            znodeCart.Shipping = portalCart.Shipping;
            znodeCart.TaxRate = portalCart.TaxRate;
            znodeCart.Token = portalCart.Token;
            znodeCart.PortalId = portalCart.PortalId;
            znodeCart.OrderId = portalCart.OrderId;
            znodeCart.OrderDate = portalCart.OrderDate;
            znodeCart.UserId = portalCart.UserId;
            znodeCart.LocalId = portalCart.LocalId;
            znodeCart.CookieMappingId = portalCart.CookieMappingId;
            znodeCart.PublishedCatalogId = portalCart.PublishedCatalogId;
            znodeCart.CSRDiscountAmount = portalCart.CSRDiscountAmount;
            znodeCart.CSRDiscountDescription = portalCart.CSRDiscountDescription;
            znodeCart.CSRDiscountApplied = portalCart.CSRDiscountApplied;
            znodeCart.CSRDiscountMessage = portalCart.CSRDiscountMessage;
            znodeCart.CurrencyCode = portalCart.CurrencyCode;
            znodeCart.CultureCode = portalCart.CultureCode;
            znodeCart.CurrencySuffix = portalCart.CurrencySuffix;
            znodeCart.OrderAttribute = portalCart.OrderAttribute;
            znodeCart.PersonaliseValuesList = portalCart.ShoppingCartItems.Count > 0 ? portalCart?.ShoppingCartItems?[0].PersonaliseValuesList : new System.Collections.Generic.Dictionary<string, object>();
            znodeCart.CustomShippingCost = portalCart.CustomShippingCost;
            znodeCart.CustomTaxCost = portalCart.CustomTaxCost;
            znodeCart.ExternalId = portalCart.ExternalId;
            znodeCart.IsLineItemReturned = portalCart.IsLineItemReturned;
            znodeCart.IsCchCalculate = portalCart.IsCchCalculate;
            znodeCart.ReturnItemList = portalCart.ReturnItemList;
            znodeCart.Custom1 = portalCart.Custom1;
            znodeCart.Custom2 = portalCart.Custom2;
            znodeCart.Custom3 = portalCart.Custom3;
            znodeCart.Custom4 = portalCart.Custom4;
            znodeCart.Custom5 = portalCart.Custom5;
            znodeCart.EstimateShippingCost = portalCart.EstimateShippingCost;
            znodeCart.TotalAdditionalCost = portalCart.TotalAdditionalCost;
            znodeCart.IsAllowWithOtherPromotionsAndCoupons = portalCart.IsAllowWithOtherPromotionsAndCoupons;
            znodeCart.PublishStateId = portalCart.PublishStateId;


            if (IsNull(znodeCart.Payment))
                znodeCart.Payment = new Entities.ZnodePayment();

            //znodeCart.Payment.BillingAddress = portalCart?.BillingAddress ?? new AddressModel();

            //if (Equals(portalCart.ShippingAddress, null))
            //    portalCart.ShippingAddress = portalCart?.Payment?.ShippingAddress ?? new AddressModel();


            if (IsNotNull(userDetails))
                znodeCart.UserAddress = userDetails;

            IPublishProductHelper publishProductHelper = GetService<IPublishProductHelper>();

            List<string> skus = new List<string>();

            //foreach (ZnodeShoppingCartItem item in portalCart.ShoppingCartItems)
            //{
            //    if (!string.IsNullOrEmpty(item.co))
            //        skus.Add(item.ConfigurableProductSKUs.ToLower());

            //    skus.Add(item.SKU.ToLower());
            //}
            //skus = skus.Distinct().ToList();

            //List<string> navigationProperties = new List<string> { ZnodeConstant.Promotions, ZnodeConstant.Pricing, ZnodeConstant.Inventory, ZnodeConstant.SEO };

            //int catalogVersionId = publishProductHelper.GetCatalogVersionId(portalCart.PublishedCatalogId, portalCart.LocalId);

            //List<PublishProductModel> cartLineItemsProductData = publishProductHelper.GetDataForCartLineItems(skus, portalCart.PublishedCatalogId, portalCart.LocalId, navigationProperties, portalCart.UserId.GetValueOrDefault(), portalCart.PortalId, catalogVersionId);

            //List<TaxClassRuleModel> lstTaxClassSKUs = publishProductHelper.GetTaxRules(skus);

            //List<ZnodePimDownloadableProduct> lstDownloadableProducts = new ZnodeRepository<ZnodePimDownloadableProduct>().Table.Where(x => skus.Contains(x.SKU)).ToList();

            //List<ConfigurableProductEntity> configEntities = publishProductHelper.GetConfigurableProductEntity(cartLineItemsProductData.Select(x => x.PublishProductId).Distinct().ToList(), catalogVersionId);

            //znodeCart.AddtoShoppingBagV2(portalCart, cartLineItemsProductData, catalogVersionId, lstTaxClassSKUs, lstDownloadableProducts, configEntities);

            //if (IsNotNull(portalCart?.Coupons))
            //{
            //    foreach (CouponModel coupon in portalCart?.Coupons)
            //        znodeCart.Coupons.Add(CouponMap.ToZnodeCoupon(coupon));
            //}

            return znodeCart;
        }
    }
}
