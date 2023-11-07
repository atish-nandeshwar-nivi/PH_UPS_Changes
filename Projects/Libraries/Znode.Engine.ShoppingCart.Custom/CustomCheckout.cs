using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using Znode.Engine.Api.Models;
using Znode.Engine.Shipping.Custom;
using Znode.Engine.Shipping.Custom.Interface;
using Znode.Libraries.Admin;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.Entities;
using Znode.Libraries.ECommerce.Fulfillment;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;


namespace Znode.Engine.ShoppingCart.Custom
{
    // Order Checkout Class - Order the checkout process
    public class CustomCheckout : ZnodeCheckout, IZnodeCheckout
    {
        #region Member Variables
        private readonly int _ShippingID = 0;
        private readonly IZnodeOrderHelper orderHelper;
        private readonly IPublishProductHelper publishProductHelper;
        private readonly Dictionary<int, string> publishCategory = new Dictionary<int, string>();
        private readonly ICustomShoppingCartMap _customShoppingCartMap;
        #endregion

        #region Constructor
        public CustomCheckout() {
            orderHelper = GetService<IZnodeOrderHelper>();
            publishProductHelper = GetService<IPublishProductHelper>();
            _customShoppingCartMap = GetService<ICustomShoppingCartMap>();
        }
        
        // Initializes a new instance of the ZNodeCheckout class.
        public CustomCheckout(UserAddressModel userAccount, ZnodePortalCart shoppingCart)
        {

            this.UserAccount = userAccount;
            this.ShoppingCart = shoppingCart;
            orderHelper = GetService<IZnodeOrderHelper>();
            publishProductHelper = GetService<IPublishProductHelper>();
        }

        #endregion

        #region  public virtual Methods

        //to set order details
        public override void SetOrderDetails(ZnodeOrderFulfillment order, IZnodePortalCart shoppingCart, UserAddressModel userAccount)
        {
            UserModel userDetails = GetUserDetailsByUserId(shoppingCart.UserId);
            bool isTaxExempt = Convert.ToBoolean(userDetails.UserGlobalAttributes?.FirstOrDefault(o => o.AttributeCode == "TaxExempt")?.AttributeValue);
            
            order.UserID = userAccount.UserId;
            order.Created = GetDateTime();
            order.Modified = GetDateTime();
            order.CreatedBy = userAccount.UserId;
            order.ModifiedBy = userAccount.UserId;
            order.TaxCost = shoppingCart.TaxCost;
            order.VAT = shoppingCart.VAT;
            order.SalesTax = shoppingCart.SalesTax;
            order.HST = shoppingCart.HST;
            order.PST = shoppingCart.PST;
            order.GST = shoppingCart.GST;
            order.Email = userAccount.Email;
            order.CurrencyCode = shoppingCart.CurrencyCode;
            order.CultureCode = shoppingCart.CultureCode;
            order.ShippingCost = shoppingCart.ShippingCost;
            order.ShippingDifference = shoppingCart.ShippingDifference;
            order.SubTotal = shoppingCart.SubTotal;

            //CUSTOMIZATION: CONVERTING PORTALCART TO CUSTOMCART TO CALCULATE THE TOTAL (USING THE GETADDITIONALPRICE FUNCTION OVERRIDE)
            //TODO: Rather than convert carts, make Checkout object a customcheckout with CustomShoppingCart as Portal Cart and Address Carts
            //CustomShoppingCart customPortalCart = _customShoppingCartMap.ToZnodeShoppingCart(shoppingCart);
            IZnodePortalCart cart = new ZnodePortalCart();
            ZnodePortalCart CartModel = (ZnodePortalCart)cart;
            CustomShoppingCart customPortalCart = _customShoppingCartMap.ToZnodeShoppingCart(CartModel);
            //order.Total = customPortalCart.Total;
            order.Total = shoppingCart.Total;// order.ShippingCost + order.SubTotal;

            // END OF CUSTOMIZATION
            order.ExternalId = shoppingCart.ExternalId;
            order.DiscountAmount = shoppingCart.Discount;
            order.BillingAddress = userAccount.BillingAddress;
            order.ShippingAddress = userAccount.ShippingAddress;
            order.OrderDate = shoppingCart.OrderDate.GetValueOrDefault();
            order.PaymentTrancationToken = shoppingCart.Token;
            order.CreditCardNumber = shoppingCart.CreditCardNumber;
            order.CardType = shoppingCart.CardType;
            order.CreditCardExpMonth = shoppingCart.CreditCardExpMonth;
            order.CreditCardExpYear = shoppingCart.CreditCardExpYear;
            order.IsShippingCostEdited = IsNotNull(shoppingCart.CustomShippingCost);
            order.IsTaxCostEdited = IsNotNull(shoppingCart.CustomTaxCost);
            order.Custom1 = shoppingCart.Custom1;
            order.Custom2 = shoppingCart.Custom2;
            order.Custom3 = shoppingCart.Custom3;
            order.Custom4 = shoppingCart.Custom4;
            order.Custom5 = shoppingCart.Custom5;
            order.PublishStateId = shoppingCart.PublishStateId;
            order.EstimateShippingCost = shoppingCart.EstimateShippingCost;

            order.PaymentDisplayName = shoppingCart?.Payment?.PaymentDisplayName;
            order.PaymentExternalId = shoppingCart?.Payment?.PaymentExternalId;
            foreach (ZnodeCoupon coupon in shoppingCart.Coupons)
            {
                if (coupon.CouponApplied && coupon.CouponValid)
                {
                    order.CouponCode = (!string.IsNullOrEmpty(order.CouponCode)) ? order.CouponCode += ZnodeConstant.CouponCodeSeparator + coupon.Coupon : coupon.Coupon;
                }
            }
            SetOrderModel(order, shoppingCart);
        }


        private static UserModel GetUserDetailsByUserId(int? userId)
        {
            if (userId > 0)
            {
                IZnodeRepository<ZnodeUser> _userRepository = new ZnodeRepository<ZnodeUser>();
                IZnodeRepository<AspNetUser> _aspNetUserRepository = new ZnodeRepository<AspNetUser>();
                IZnodeRepository<AspNetZnodeUser> _aspNetZnodeUserRepository = new ZnodeRepository<AspNetZnodeUser>();

                var userDetails = (from user in _userRepository.Table
                                   join aspNetUser in _aspNetUserRepository.Table on user.AspNetUserId equals aspNetUser.Id
                                   join aspNetZnodeUser in _aspNetZnodeUserRepository.Table on aspNetUser.UserName equals aspNetZnodeUser.AspNetZnodeUserId
                                   where user.UserId == userId
                                   select new UserModel
                                   {
                                       FirstName = user.FirstName,
                                       LastName = user.LastName,
                                       AccountId = user.AccountId,
                                       UserName = aspNetZnodeUser.UserName
                                   })?.FirstOrDefault();

                List<GlobalAttributeValuesModel> userGlobalAttributes = GetGlobalLevelAttributeList(userDetails.AccountId, ZnodeConstant.Account);
                userDetails.UserGlobalAttributes = userGlobalAttributes;

                return userDetails;
            }
            return new UserModel();
        }

        public static List<GlobalAttributeValuesModel> GetGlobalLevelAttributeList(int? entityId, string entityType)
        {
            ZnodeLogging.LogMessage("Execution started.", string.Empty, TraceLevel.Info);
            List<GlobalAttributeValuesModel> userAttributes = new List<GlobalAttributeValuesModel>();
            if (entityId > 0 && !string.IsNullOrEmpty(entityType))
            {
                IZnodeViewRepository<GlobalAttributeValuesModel> globalAttributeValues = new ZnodeViewRepository<GlobalAttributeValuesModel>();
                globalAttributeValues.SetParameter("EntityName", entityType, ParameterDirection.Input, DbType.String);
                globalAttributeValues.SetParameter("GlobalEntityValueId", entityId, ParameterDirection.Input, DbType.Int32);
                ZnodeLogging.LogMessage("entityId and entityType to get user attributes: ", string.Empty, TraceLevel.Verbose, new object[] { entityId, entityType });
                userAttributes = globalAttributeValues.ExecuteStoredProcedureList("Znode_GetGlobalEntityAttributeValue @EntityName, @GlobalEntityValueId").ToList();
            }
            ZnodeLogging.LogMessage("userAttributes list count: ", string.Empty, TraceLevel.Verbose, userAttributes.Count);
            ZnodeLogging.LogMessage("Execution done.", string.Empty, TraceLevel.Info);
            return userAttributes;
        }
        #endregion
    }
}
