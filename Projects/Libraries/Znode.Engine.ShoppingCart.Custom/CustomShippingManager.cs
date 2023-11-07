using StructureMap;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using Znode.Engine.Api.Models;
using Znode.Engine.Shipping.Helper;
using Znode.Libraries.Data;
using Znode.Libraries.ECommerce.Entities;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Engine.Shipping;

namespace Znode.Engine.Shipping.Custom
{
    public class CustomShippingManager : ZnodeBusinessBase
    {
        #region private data members
        private ZnodeShoppingCart _shoppingCart;
        private ZnodeGenericCollection<IZnodeShippingsType> _shippingTypes;
        private List<ZnodeShippingBag> _shippingbagList;
        #endregion



        // Throws a NotImplementedException because this class requires a shopping cart to work.
        public CustomShippingManager()
        {
            throw new NotImplementedException();
        }


        /// <summary>
        /// Instantiates all the shipping types and rules that are required for the current shopping cart.
        /// </summary>
        /// <param name="shoppingCart">The current shopping cart.</param>
        public CustomShippingManager(Znode.Engine.Shipping.Custom.CustomShoppingCart shoppingCart, bool isAllowAddNewShippingType = false, ZnodeGenericCollection<IZnodeShippingsType> shippingTypes = null, List<ZnodeShippingBag> shippingbagList = null)
        {
            WriteLogs("NIVI shipping id :" + Newtonsoft.Json.JsonConvert.SerializeObject(shoppingCart.Shipping.ShippingID));
            //Assign shopping cart data to instance variable of ZNodeShoppingCart.
            _shoppingCart = shoppingCart;
            _shoppingCart.JobName = Convert.ToString(shoppingCart.CookieMappingId);
            if (!isAllowAddNewShippingType)
                _shippingTypes = new ZnodeGenericCollection<IZnodeShippingsType>();
            else
            {
                _shippingTypes = shippingTypes;
                _shippingbagList = shippingbagList;
            }

            ShippingRuleListModel shippingRules = new ShippingRuleListModel();
            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();
            ShippingModel shippingModel = new ShippingModel();
            if (shoppingCart.Shipping.ShippingID > 0)
            {
                shippingModel = shippingHelper.GetPortalProfileShipping(shoppingCart.Shipping.ShippingCountryCode, shoppingCart.Shipping.ShippingID, shoppingCart.PortalId, shoppingCart.ProfileId, shoppingCart.UserId);

                shippingRules.ShippingRuleList = shippingHelper.GetPortalProfileShippingRuleList(shoppingCart.Shipping.ShippingCountryCode, shoppingCart.Shipping.ShippingID, shoppingCart.PortalId, shoppingCart.ProfileId, shoppingCart.UserId);

                if (((HelperUtility.IsNotNull(shippingModel) && (string.IsNullOrEmpty(shippingModel.ZipCode) || shippingModel.ZipCode.Contains(shoppingCart.Payment.ShippingAddress.PostalCode)) || (shippingRules.ShippingRuleList.Count > 0))))
                {
                    ZnodeShippingBag shippingBag = BuildShippingBag(shippingModel, shippingRules, shoppingCart.SubTotal);
                    if (isAllowAddNewShippingType)
                    {
                        _shippingbagList.Add(shippingBag);
                    }
                    AddShippingTypes(shippingModel, shippingBag);
                }

            }
        }
        private void WriteLogs(string strValue)
        {
            try
            {
                string basepath = AppDomain.CurrentDomain.BaseDirectory + "/PHSLogs/";
                // create directory if not exists
                System.IO.Directory.CreateDirectory(basepath);

                //Logfile
                string path = basepath + "phlog_" + DateTime.Now.ToString("dd-MM-yyyy") + ".txt";
                using (System.IO.StreamWriter sw = System.IO.File.AppendText(path))
                {
                    sw.WriteLine(DateTime.Now.ToString("dd-MM-yyyy hh:mm::ss tt =>") + strValue);
                }
            }
            catch (Exception ex)
            {

            }
        }

        // Calculates the shipping cost and updates the shopping cart.
        public void Calculate()
        {
            _shoppingCart.OrderLevelShipping = 0;
            _shoppingCart.Shipping.ShippingHandlingCharge = 0;
            _shoppingCart.Shipping.ResponseCode = "0";
            _shoppingCart.Shipping.ResponseMessage = String.Empty;

            ResetShippingCostForCartItemsAndAddOns();
            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();

            CalculateEachShippingType();
        }

        /// <summary>
        /// Process anything that must be done before the order is submitted.
        /// </summary>
        /// <returns>True if everything is good for submitting the order; otherwise, false.</returns>
        public bool PreSubmitOrderProcess()
        {
            bool allPreConditionsOk = true;

            foreach (ZnodeShippingsType shippingType in _shippingTypes)
                // Make sure all pre-conditions are good before letting the customer check out
                allPreConditionsOk &= shippingType.PreSubmitOrderProcess();

            return allPreConditionsOk;
        }

        // Process anything that must be done after the order is submitted.
        public void PostSubmitOrderProcess()
        {
            foreach (ZnodeShippingsType shippingType in _shippingTypes)
                shippingType.PostSubmitOrderProcess();
        }

        // Caches all available shipping types in the application cache.
        public static void CacheAvailableShippingTypes()
        {         
            if (Equals(HttpRuntime.Cache["ShippingTypesCache"], null))
            {
                ObjectFactory.Configure(scanner => scanner.Scan(x =>
                {
                    x.AssembliesFromApplicationBaseDirectory(
                        assembly => assembly.FullName.Contains("Znode.") || assembly.FullName.Contains(!string.IsNullOrEmpty(ZnodeApiSettings.CustomAssemblyLookupPrefix) ? Convert.ToString(ZnodeApiSettings.CustomAssemblyLookupPrefix) : string.Empty));
                    x.AddAllTypesOf<IZnodeShippingsType>();
                }));


                // Only cache shipping types that have a ClassName and Name; this helps avoid showing base classes in some of the dropdown lists
                var shippingTypes = ObjectFactory.GetAllInstances<IZnodeShippingsType>().Where(x => !String.IsNullOrEmpty(x.ClassName) && !String.IsNullOrEmpty(x.Name));
                HttpRuntime.Cache["ShippingTypesCache"] = shippingTypes.ToList();
            }
        }

        /// <summary>
        /// Gets all available shipping types from the application cache.
        /// </summary>
        /// <returns>A list of the available shipping types.</returns>
        public static List<IZnodeShippingsType> GetAvailableShippingTypes()
        {
            ObjectFactory.Configure(scanner => scanner.Scan(x =>
            {
                x.AssembliesFromApplicationBaseDirectory(
                    assembly => assembly.FullName.Contains("Znode.") || assembly.FullName.Contains(!string.IsNullOrEmpty(ZnodeApiSettings.CustomAssemblyLookupPrefix) ? Convert.ToString(ZnodeApiSettings.CustomAssemblyLookupPrefix) : string.Empty));
                x.AddAllTypesOf<IZnodeShippingsType>();
            }));

            // Only cache shipping types that have a ClassName and Name; this helps avoid showing base classes in some of the dropdown lists
            var shippingTypes = ObjectFactory.GetAllInstances<IZnodeShippingsType>().Where(x => !String.IsNullOrEmpty(x.ClassName) && !String.IsNullOrEmpty(x.Name)).ToList();
            if (!Equals(shippingTypes, null))
                shippingTypes.Sort((shippingTypeA, shippingTypeB) => string.CompareOrdinal(shippingTypeA.Name, shippingTypeB.Name));
            else
                shippingTypes = new List<IZnodeShippingsType>();
            return shippingTypes;
        }

        private void ResetShippingCostForCartItemsAndAddOns()
        {
            foreach (ZnodeShoppingCartItem cartItem in _shoppingCart.ShoppingCartItems)
            {
                // Reset each line item shipping cost
                cartItem.ShippingCost = 0;
                if (HelperUtility.IsNotNull(cartItem.Product))
                {
                    cartItem.Product.ShippingCost = 0;

                    foreach (ZnodeProductBaseEntity addOn in cartItem.Product.ZNodeAddonsProductCollection)
                    {
                        addOn.ShippingCost = 0;
                    }

                    foreach (ZnodeProductBaseEntity group in cartItem.Product.ZNodeGroupProductCollection)
                        group.ShippingCost = 0;
                }
            }
        }

        //Calculate shipping types.
        private void CalculateEachShippingType()
        {
            //Calculate all shipping types.
            foreach (ZnodeShippingsType shippingType in _shippingTypes ?? new ZnodeGenericCollection<IZnodeShippingsType>())
            {
                try
                {
                    shippingType.ResetShippingItems();
                    shippingType.Calculate();
                }
                catch (Exception ex)
                {
                    //Log exception if occur.
                    ZnodeLogging.LogMessage("Error while calculating shipping type: " + shippingType.Name, "Shipping", TraceLevel.Error, ex);

                }
            }
        }

        //Assign shipping data to ZnodeShippingBag which is used by shipping types for calculations.
        private ZnodeShippingBag BuildShippingBag(ShippingModel shipping, ShippingRuleListModel shippingRuleList, decimal subTotal)
        {
            ZnodeShippingBag shippingBag = new ZnodeShippingBag();

            shippingBag.ShoppingCart = _shoppingCart;
            shippingBag.ShippingCode = shipping?.ShippingCode;
            WriteLogs("NIVI BuildShippingBag Shipping code :" + Newtonsoft.Json.JsonConvert.SerializeObject(shippingBag.ShippingCode) +" "+ Newtonsoft.Json.JsonConvert.SerializeObject(shipping?.ShippingCode));
            shippingBag.HandlingCharge = shipping.HandlingCharge;
            shippingBag.ShippingRules = new ShippingRuleListModel();
            shippingBag.ShippingRules.ShippingRuleList = shippingRuleList.ShippingRuleList;
            shippingBag.SubTotal = subTotal;
            shippingBag.HandlingBasedOn = shipping?.HandlingChargeBasedOn ?? string.Empty;

            return shippingBag;
        }

        //Get Shipping types from assembly and add to local instance variable.
        private void AddShippingTypes(ShippingModel shipping, ZnodeShippingBag shippingBag)
        {
            //Get all available shipping types.
            List<IZnodeShippingsType> availableShippingTypes = GetAvailableShippingTypes();
            foreach (IZnodeShippingsType type in availableShippingTypes.Where(t => t.ClassName == shipping.ClassName || (((CustomShoppingCart)_shoppingCart).Shipping2Carrier != null && t.ClassName == ((CustomShoppingCart)_shoppingCart).Shipping2Carrier) || (((CustomShoppingCart)_shoppingCart).Custom4 != null && t.ClassName == ((CustomShoppingCart)_shoppingCart).Custom4)).OrderBy(o => o.ClassName == (((CustomShoppingCart)_shoppingCart).Shipping2Carrier != null ? ((CustomShoppingCart)_shoppingCart).Shipping2Carrier : "")).ThenBy(o => o.ClassName != (((CustomShoppingCart)_shoppingCart).Shipping2Carrier != null ? ((CustomShoppingCart)_shoppingCart).Shipping2Carrier : "")))
            {
                try
                {
                    // custom: add second code to second shipping bag
                    if (type.ClassName == (((CustomShoppingCart)_shoppingCart).Shipping2Carrier != null ? ((CustomShoppingCart)_shoppingCart).Shipping2Carrier : ""))
                    {
                        ZnodeShippingBag newBag = new ZnodeShippingBag();
                        var propInfo = shippingBag.GetType().GetProperties();
                        foreach (var item in propInfo)
                        {

                            var pi = newBag.GetType().GetProperty(item.Name);
                            if (pi.CanWrite)
                            {
                                pi.SetValue(newBag, item.GetValue(shippingBag, null), null);
                            }
                        }
                        newBag.ShippingCode = ((CustomShoppingCart)_shoppingCart).Shipping2Method;

                        type.Bind(_shoppingCart, newBag);
                    }
                    else if (type.ClassName == (((CustomShoppingCart)_shoppingCart).Custom4 != null ? ((CustomShoppingCart)_shoppingCart).Custom4 : ""))//Atish ups
                    {
                        ZnodeShippingBag newBag = new ZnodeShippingBag();
                        var propInfo = shippingBag.GetType().GetProperties();
                        foreach (var item in propInfo)
                        {

                            var pi = newBag.GetType().GetProperty(item.Name);
                            if (pi.CanWrite)
                            {
                                pi.SetValue(newBag, item.GetValue(shippingBag, null), null);
                            }
                        }
                        newBag.ShippingCode = ((CustomShoppingCart)_shoppingCart).Custom5;

                        type.Bind(_shoppingCart, newBag);
                    }
                    else
                    {
                        type.Bind(_shoppingCart, shippingBag);
                    }
                   
                    _shippingTypes.Add(type);
                    if (_shippingTypes.Count == 3)//Atish ups
                    {
                        IZnodeShippingsType UPSType = new ZnodeShippingsType();
                        UPSType = _shippingTypes[1];
                        _shippingTypes.RemoveAt(1);
                        _shippingTypes.Add(UPSType);
                    }
                    
                }
                catch (Exception ex)
                {
                    //Log exception if occur.
                    ZnodeLogging.LogMessage("Error while instantiating shipping type: " + type, "Shipping", TraceLevel.Error, ex);
                }
            }
        }

        private void AllowedTerritoriesForGroupConfigureAddonsProduct(ZnodeShoppingCart shoppingCart, ZnodeShoppingCartItem item)
        {
            foreach (ZnodeProductBaseEntity productBaseEntity in item.Product.ZNodeGroupProductCollection)
            {
                item.IsAllowedTerritories = !string.IsNullOrEmpty(productBaseEntity.AllowedTerritories) ? productBaseEntity.AllowedTerritories.Split(',').ToList().Contains(shoppingCart.Shipping.ShippingCountryCode) : true;
            }
        }

        public List<ShippingModel> GetShippingEstimateRate(ZnodeShoppingCart znodeShoppingCart, ShoppingCartModel cartModel, string countryCode, List<ZnodeShippingBag> shippingbagList)
        {
            List<ShippingModel> listWithRates = new List<ShippingModel>();

            List<string> shippingName = new List<string>();
            foreach (ZnodeShippingsType shippingType in _shippingTypes ?? new ZnodeGenericCollection<IZnodeShippingsType>())
            {
                if (!shippingName.Contains(shippingType.Name))
                {
                    shippingType.ResetShippingItems();
                    shippingName.Add(shippingType.Name);


                    switch (shippingType?.Name?.ToLower())
                    {
                        case "ups":
                            listWithRates.AddRange(shippingType.GetEstimateRate(shippingbagList));
                            break;
                        case "usps":
                            listWithRates.AddRange(shippingType.GetEstimateRate(shippingbagList));
                            break;
                        case "fedex":
                            listWithRates.AddRange(shippingType.GetEstimateRate(shippingbagList));
                            break;
                        default:
                            break;
                    }

                }
            }

            return listWithRates ?? new List<ShippingModel>();
        }
    }
}
