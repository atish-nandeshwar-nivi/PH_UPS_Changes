using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Web;
using StructureMap;
using Znode.Engine.Api.Models;
using Znode.Engine.Taxes.Helper;
using Znode.Engine.Taxes.Interfaces;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.Entities;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;

namespace Znode.Engine.Taxes.Custom
{
    // Helps in Manage taxes.
    public class CustomTaxManager : ZnodeBusinessBase
    {
        #region Private Memeber Variables
        private const string TaxTypesCache = "TaxTypesCache";
        private ZnodeShoppingCart _shoppingCart;
        private ZnodeGenericCollection<IZnodeTaxesType> _taxes;
        private readonly ZnodeTaxHelper taxHelper;
        #endregion
        #region Constructors
        public CustomTaxManager()
        {
            // Throws a NotImplementedException because this class requires a shopping cart to work.
            throw new NotImplementedException();
        }

        public CustomTaxManager(ZnodeShoppingCart shoppingCart)
        {
            taxHelper = new ZnodeTaxHelper();
            _shoppingCart = shoppingCart;
            BindTaxRules();
        }

        public CustomTaxManager(ShoppingCartModel shoppingCart)
        {
            taxHelper = new ZnodeTaxHelper();
            BindShoppingCartModel(shoppingCart);
            BindTaxRules();
        }
        #endregion

        //Get the list
        public List<TaxRuleModel> TaxRules
        {
            get
            {
                //Added for SiteAdmin CreateOrder Without Customer Selected
                if (HelperUtility.IsNull(_shoppingCart?.Payment?.ShippingAddress))
                {
                    _shoppingCart = new ZnodeShoppingCart();
                    _shoppingCart.Payment = new ZnodePayment();
                    _shoppingCart.Payment.ShippingAddress = new AddressModel();
                }

                AddressModel shippingAddress = _shoppingCart?.Payment?.ShippingAddress ?? new AddressModel();

                List<TaxRuleModel> taxRuleList = null;
                if (HelperUtility.IsNotNull(_shoppingCart))
                {
                    int? _userId = HelperUtility.IsNull(_shoppingCart.OrderId) ? _shoppingCart.UserId : GetGuestUserId(_shoppingCart.UserId, _shoppingCart.OrderId);
                    taxRuleList = taxHelper.GetTaxRuleListByPortalId(shippingAddress, Convert.ToInt32(_shoppingCart.PortalId), _shoppingCart.ProfileId, _userId);
                }

                return taxRuleList ?? new List<TaxRuleModel>();
            }
        }

        // Calculates the sales tax for the shopping cart and its items. 
        public void Calculate(ZnodeShoppingCart shoppingCart)
        {
            UserModel userDetails = GetUserDetailsByUserId(shoppingCart.UserId);
            bool isTaxExempt = Convert.ToBoolean(userDetails.UserGlobalAttributes?.FirstOrDefault(o => o.AttributeCode == "TaxExempt")?.AttributeValue);

            // Reset values  
            shoppingCart.OrderLevelTaxes = shoppingCart.GST = shoppingCart.HST = shoppingCart.PST = 0;
            shoppingCart.VAT = shoppingCart.SalesTax = shoppingCart.TaxRate = 0;

            // Go through each item in the cart
            foreach (ZnodeShoppingCartItem cartItem in shoppingCart.ShoppingCartItems)
            {
                cartItem.IsTaxCalculated = false;

                cartItem.Product.GST = cartItem.Product.HST = cartItem.Product.PST = cartItem.Product.VAT = cartItem.Product.SalesTax = 0;

                ResetValue(cartItem.Product.ZNodeGroupProductCollection);
                ResetValue(cartItem.Product.ZNodeAddonsProductCollection);
                ResetValue(cartItem.Product.ZNodeConfigurableProductCollection);
            }

            if (isTaxExempt) return;

            foreach (ZnodeTaxesType tax in _taxes)
                tax.Calculate();
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


        // Process anything that must be done before the order is submitted.
        public bool PreSubmitOrderProcess(ZnodeShoppingCart shoppingCart)
        {
            bool allPreConditionsOk = true;

            foreach (ZnodeTaxesType tax in _taxes)
                // Make sure all pre-conditions are good before letting the customer check out
                allPreConditionsOk &= tax.PreSubmitOrderProcess();

            return allPreConditionsOk;
        }

        // Process anything that must be done after the order is submitted.
        public void PostSubmitOrderProcess(ZnodeShoppingCart shoppingCart)
        {
            foreach (ZnodeTaxesType tax in _taxes)
                tax.PostSubmitOrderProcess();
        }

        // Process anything that must be done after the order is submitted.
        public void CancelOrderRequest(ShoppingCartModel shoppingCartModel)
        {
            foreach (ZnodeTaxesType tax in _taxes)
                tax.CancelOrderRequest(shoppingCartModel);
        }

        // Caches all available tax types in the application cache.
        public static void CacheAvailableTaxTypes()
        {
            if (!HelperUtility.IsNull(HttpRuntime.Cache[TaxTypesCache])) return;
            ObjectFactory.Configure(scanner => scanner.Scan(x =>
            {
                x.AssembliesFromApplicationBaseDirectory(
                    assembly => assembly.FullName.Contains("Znode.") || assembly.FullName.Contains(!string.IsNullOrEmpty(ZnodeApiSettings.CustomAssemblyLookupPrefix) ? Convert.ToString(ZnodeApiSettings.CustomAssemblyLookupPrefix) : string.Empty));
                x.AddAllTypesOf<IZnodeTaxesType>();
            }));

            // Only cache tax types that have a ClassName and Name; this helps avoid showing base classes in some of the dropdown lists
            HttpRuntime.Cache[TaxTypesCache] = ObjectFactory.GetAllInstances<IZnodeTaxesType>().Where(x => !String.IsNullOrEmpty(x.ClassName) && !String.IsNullOrEmpty(x.Name))?.ToList();
        }

        //Return order line item.
        public void ReturnOrderLineItem(ShoppingCartModel orderModel)
        {
            foreach (ZnodeTaxesType tax in _taxes)
                tax.ReturnOrderLineItem(orderModel);
        }

        public static List<IZnodeTaxesType> GetAvailableTaxTypes()
        {
            //Code Added for get all current instance of all request. 
            ObjectFactory.Configure(scanner => scanner.Scan(x =>
            {
                x.AssembliesFromApplicationBaseDirectory(
                    assembly => assembly.FullName.Contains("Znode.") || assembly.FullName.Contains(!string.IsNullOrEmpty(ZnodeApiSettings.CustomAssemblyLookupPrefix) ? Convert.ToString(ZnodeApiSettings.CustomAssemblyLookupPrefix) : string.Empty));
                x.AddAllTypesOf<IZnodeTaxesType>();
            }));
            // Only cache tax types that have a ClassName and Name; this helps avoid showing base classes in some of the dropdown lists
            var list = ObjectFactory.GetAllInstances<IZnodeTaxesType>().Where(x => !String.IsNullOrEmpty(x.ClassName) && !String.IsNullOrEmpty(x.Name))?.ToList();
            if (!Equals(list, null))
                list.Sort((taxA, taxB) => String.CompareOrdinal(taxA.Name, taxB.Name));
            else
                list = new List<IZnodeTaxesType>();
            return list;
        }

        //Get ZnodeTaxBag to calculate tax rates.
        private ZnodeTaxBag BuildTaxBag(TaxRuleModel rule)
            => new ZnodeTaxBag
            {
                DestinationCountryCode = string.IsNullOrEmpty(rule.DestinationCountryCode) ? null : rule.DestinationCountryCode,
                DestinationStateCode = string.IsNullOrEmpty(rule.DestinationStateCode) ? null : rule.DestinationStateCode,
                CountyFIPS = string.IsNullOrEmpty(rule.CountyFIPS) ? null : rule.CountyFIPS,
                SalesTax = rule.SalesTax.GetValueOrDefault(),
                ShippingTaxInd = rule.TaxShipping,
                VAT = rule.VAT.GetValueOrDefault(),
                TaxClassId = rule.TaxClassId.GetValueOrDefault(),
                GST = rule.GST.GetValueOrDefault(),
                PST = rule.PST.GetValueOrDefault(),
                HST = rule.HST.GetValueOrDefault(),
                Custom1 = Convert.ToString(rule.Custom1),
                InclusiveInd = rule.InclusiveInd,
                IsDefault = rule.IsDefault,
                TaxRuleId = rule.TaxRuleId,
                AssociatedTaxRuleIds = GetAssocaitedTaxRuleIds()
            };

        //Add available tax xlasse to zeneric tax class collection.
        private void AddTaxTypes(TaxRuleModel rule, ZnodeTaxBag taxBag)
        {
            //Get all available tax classes from cache.
            List<IZnodeTaxesType> availableTaxTypes = GetAvailableTaxTypes();


            foreach (IZnodeTaxesType type in availableTaxTypes.Where(t => t.ClassName == rule.ClassName))
            {
                try
                {
                    type.Bind(_shoppingCart, taxBag);
                    _taxes.Add(type);
                }
                catch (Exception ex)
                {
                    //Log exception if occur.
                    ZnodeLogging.LogMessage("Error while instantiating tax type: " + type, string.Empty, TraceLevel.Error, ex);
                }
            }
        }

        // Reset values.
        private void ResetValue(ZnodeGenericCollection<ZnodeProductBaseEntity> productCollection)
        {
            foreach (ZnodeProductBaseEntity productItem in productCollection)
            {
                productItem.GST = productItem.HST = productItem.PST = productItem.VAT = productItem.SalesTax = 0;
                productItem.TaxCalculated = false;
            }
        }

        //to get all tax rule id associated to store
        private string GetAssocaitedTaxRuleIds()
         => String.Join(",", TaxRules.Select(i => i.TaxClassId).ToList());

        //to get guest user id
        private int? GetGuestUserId(int? userId, int? orderId)
        {
            if (HelperUtility.IsNotNull(orderId) && orderId > 0 && taxHelper.IsGuestUser(userId.GetValueOrDefault()))
                return 0;
            return userId;
        }

        //Binds the shopping cart.
        private void BindShoppingCartModel(ShoppingCartModel shoppingCart)
        {
            _shoppingCart = new ZnodeShoppingCart();
            _shoppingCart.Payment = new ZnodePayment();
            _shoppingCart.Payment.ShippingAddress = shoppingCart.ShippingAddress;
            _shoppingCart.OrderId = shoppingCart.OmsOrderId;
            _shoppingCart.UserId = shoppingCart.UserId;
            _shoppingCart.PortalId = shoppingCart.PortalId;
            _shoppingCart.ProfileId = shoppingCart.ProfileId;
        }

        //Binds the tax rules.
        private void BindTaxRules()
        {
            _taxes = new ZnodeGenericCollection<IZnodeTaxesType>();

            List<TaxRuleModel> taxRules = TaxRules;
            if (taxRules?.Count > 0)
            {
                //Apply sorting based on precedence 
                taxRules.OrderBy(x => x.Precedence);

                // Loop through tax rules and apply to cart based on precedence
                foreach (TaxRuleModel rule in taxRules)
                    AddTaxTypes(rule, BuildTaxBag(rule));
            }
        }
    }
}

