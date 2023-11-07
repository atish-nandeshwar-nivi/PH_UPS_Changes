﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;
using Znode.Engine.Api.Models;
using Znode.Engine.Shipping.Helper;
using Znode.Libraries.Data;
using Znode.Libraries.ECommerce.Entities;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Custom.Data;
using RateAvailableServiceWebServiceClient.RateServiceWebReference;

namespace Znode.Engine.Shipping.Custom
{
    public class ZnodeShippingJit : ZnodeShippingsType
    {
        const string freeFreightCarrierName = "LOCALFREIGHT";

        private readonly IZnodeRepository<ConpacWarehouseAttribute> _warehouseAttributeRepository;
        private readonly IZnodeRepository<CustomUOMRule> _customUomRulesRepository;

        public ZnodeShippingJit()
        {
            Name = "JIT";
            Description = "Calculates shipping rates when using Jit.";

            Controls.Add(ZnodeShippingControl.Profile);
            Controls.Add(ZnodeShippingControl.ServiceCodes);
            Controls.Add(ZnodeShippingControl.HandlingCharge);
            Controls.Add(ZnodeShippingControl.Countries);
            _warehouseAttributeRepository = new ZnodeRepository<ConpacWarehouseAttribute>(new Custom_Entities());
            _customUomRulesRepository = new ZnodeRepository<CustomUOMRule>(new Custom_Entities());
        }

        private bool isFreeFreight;
        private Dictionary<string, string> dSkuUom;
        private Dictionary<string, string> dSkuCarrier;

        // Calculates shipping rates when using JIT.
        public override void Calculate()
        {
            if (dSkuUom == null)
                dSkuUom = new Dictionary<string, string>();
            if (dSkuCarrier == null)
                dSkuCarrier = new Dictionary<string, string>();

            decimal itemShippingRate = 0;
            // Instantiate JIT agent
            JitAgent shippingAgent = new JitAgent();

            string packageType = string.Empty;

            PortalShippingModel portalShippingModel = GetAgentDetails(ref shippingAgent, out packageType);

            bool IsLocalFreight = shippingAgent.JITServiceType == freeFreightCarrierName;

            ShippingRateModel model = new ShippingRateModel();

            // Calculate ship toghether item.
            if (ShipTogetherItems?.Count > 0)
            {
                //Rates have already been returned on the first request and stored in dictionary after the first instance.
                //Hopefully, the local freight carrier was processed first. But in case it isn't we need to assess the "IsFreeFreight" if it's not.
                if (((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary != null && ((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary.ContainsKey(this.ClassName) && shippingAgent.JITServiceType != freeFreightCarrierName)
                {
                    object obj;
                    ((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary.TryGetValue(this.ClassName, out obj);
                    TPWResponse carriers = (TPWResponse)obj;

                    //simulate request to populate dicitionary items
                    RateRequest request = MapShippingDetails(shippingAgent, portalShippingModel);

                    if (carriers?.Error != null)
                    {
                        Exception ex = new Exception("JIT Shipping: " + carriers.Error);
                        ZnodeLogging.LogMessage(ex, "Shipping", TraceLevel.Error);
                        shippingAgent.ErrorCode = "-1";
                        shippingAgent.ErrorDescription = ex.Message;
                        //throw ex;
                    }
                    else
                    {
                        if (carriers.Quotes.Any(o => o.CarrierCode == shippingAgent.JITServiceType))
                        {
                            //bool useFlatRate = ((CustomShoppingCart)ShoppingCart).MyWarehouseFlatRate > 0 && IsLocalFreight && (model.ShippingRate < ((CustomShoppingCart)ShoppingCart).MyWarehouseFlatRate);
                            model.ShippingRate = carriers.Quotes.FirstOrDefault(o => o.CarrierCode == shippingAgent.JITServiceType).Rate;
                            itemShippingRate = (isFreeFreight ? 0 : model.ShippingRate);
                        }
                        else
                        {
                            shippingAgent.ErrorCode = "00009";
                            shippingAgent.ErrorDescription = "Shipping method does not exist";
                        }
                    }
                }
                else
                {
                    model = CalculateShipTogetherItems(packageType, shippingAgent, portalShippingModel);
                    //bool useFlatRate = ((CustomShoppingCart)ShoppingCart).MyWarehouseFlatRate > 0 && IsLocalFreight && (model.ShippingRate < ((CustomShoppingCart)ShoppingCart).MyWarehouseFlatRate);
                    itemShippingRate = (isFreeFreight ? 0 : model.ShippingRate);
                }


                if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary == null)
                {
                    ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary = new Dictionary<string, string>();
                }
                if (string.IsNullOrEmpty(model.Custom1))
                {
                    model = CalculateShipTogetherItems(packageType, shippingAgent, portalShippingModel);
                }
                if (model.Custom1 != null)
                {
                    Dictionary<string, string> carrierWarehouse = new Dictionary<string, string>();
                    if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary.ContainsKey("_carrierWarehouse"))
                    {
                        carrierWarehouse = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_carrierWarehouse"]);
                    }
                    //Customization for Shipping showing in admin with taxable state [JIT:GA]
                    List<InventoryWarehouseMapperModel> shipmentWarehouseCartItems = new List<InventoryWarehouseMapperModel>();
                    foreach (KeyValuePair<int, List<InventoryWarehouseMapperModel>> kvp in ((CustomShoppingCart)ShoppingCart).WarehouseSkuDictionary)
                    {
                        ConpacWarehouseAttribute shipperNameAttribute = _warehouseAttributeRepository.Table.FirstOrDefault(o => o.Type == "SHP" && o.WarehouseId == kvp.Key);
                        if (shipperNameAttribute.Value.ToLower() == this.Name.ToLower())
                        {
                            shipmentWarehouseCartItems.AddRange(kvp.Value.Where(o => !shipmentWarehouseCartItems.Select(s => s.SKU).ToList().Contains(o.SKU)));
                        }

                    }
                    //End Coustomization

                    carrierWarehouse[this.Name] = shipmentWarehouseCartItems.FirstOrDefault().WarehouseCode;

                    ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_carrierWarehouse"] = Newtonsoft.Json.JsonConvert.SerializeObject(carrierWarehouse);
                }

            }

            // Calculate ship separately item.
            if (ShipSeparatelyItems?.Count > 0)
            {
                model = CalculateShipSeparatelyItems(packageType, shippingAgent, portalShippingModel);
                foreach (ZnodeShoppingCartItem shoppingCartItem in ShoppingCart.ShoppingCartItems)
                {
                    foreach (ZnodeShoppingCartItem shipSeparatelyItems in ShipSeparatelyItems)
                    {
                        if (Equals(shoppingCartItem.Product.SKU, shipSeparatelyItems.Product.SKU))
                            shoppingCartItem.ShippingCost = shipSeparatelyItems.ShippingCost;
                    }

                }
            }

            if (Equals(shippingAgent.ErrorCode, null) || (ShipSeparatelyItems.Count == 0 && ShipTogetherItems.Count == 0))
                LogsActivity(ShoppingCart);
            else if (!shippingAgent.ErrorCode.Equals("0") && (ShipSeparatelyItems.Count > 0 || ShipTogetherItems.Count > 0))
                LogsActivityShipSeparatelyItems(ShoppingCart, shippingAgent);
            else
            {
                ShoppingCart.OrderLevelShipping += itemShippingRate;
                ShoppingCart.ApproximateArrival = model.ApproximateArrival;
            }
            //Nivi code start to save JIT SKU items in custom2
            ShoppingCart.Custom2 = Newtonsoft.Json.JsonConvert.SerializeObject(dSkuCarrier);
            ShoppingCart.Custom2 = ShoppingCart.Custom2 + "^" + ShoppingCart.Custom3;
            //Nivi code end 
        }


        public override List<ShippingModel> GetEstimateRate(List<ZnodeShippingBag> shippingbagList)
        {
            JitAgent shippingAgent = new JitAgent();
            string packageType = string.Empty;

            PortalShippingModel portalShippingModel = GetAgentDetails(ref shippingAgent, out packageType);

            RateRequest request = MapShippingDetails(shippingAgent, portalShippingModel);

            foreach (ZnodeShoppingCartItem item in ShipSeparatelyItems)
            {
                ShipTogetherItems.Add(item);
            }

            List<ShippingModel> list = shippingAgent.GetJITEstimateRate(request, Convert.ToDecimal(portalShippingModel.PackageWeightLimit));

            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();
            foreach (ShippingModel model in list ?? new List<ShippingModel>())
            {
                ZnodeShippingBag shippingBag = shippingbagList.Where(w => w.ShippingCode == model.ShippingCode)?.FirstOrDefault();
                if (HelperUtility.IsNotNull(shippingBag))
                    model.ShippingRate = shippingHelper.GetShipTogetherItemsHandlingCharge(shippingBag, Convert.ToDecimal(model.ShippingRate));
            }

            return list ?? new List<ShippingModel>();
        }

        /// <summary>
        /// Checks the response code before the order is submitted.
        /// </summary>
        /// <returns>True if the response code is 0; otherwise, false.</returns>
        public override bool PreSubmitOrderProcess()
        {
            if (!Equals(ShoppingCart.Shipping.ResponseCode, "0"))
            {
                ShoppingCart.AddErrorMessage = GenericShippingErrorMessage();
                ZnodeLogging.LogMessage("Shipping error in PreSubmitOrderProcess: " + ShoppingCart.Shipping.ResponseCode + " " + ShoppingCart.Shipping.ResponseMessage, "Shipping", TraceLevel.Error);
                return false;
            }
            return true;
        }

        // Get JIT credentials.
        private JitAgent GetAgentCredentials(PortalShippingModel portalShippingModel, JitAgent shippingAgent)
        {
            // Eventually need to decrypt values from shippingPortal like JIT account info
            string testMode = System.Configuration.ConfigurationManager.AppSettings["ShippingIntegrationTestMode"];

            var encrypt = new ZnodeEncryption();

            if (testMode.ToLower() == "true")
            {
                shippingAgent.JITCustomerNumber = "E77F65F6-75BC-4D67-9F09-1A63E58A250E";
                shippingAgent.JITUsername = "conpacgroup_api";
                shippingAgent.JITPassword = "B3f0F1&f&Ar4";
            }
            else
            {
                shippingAgent.JITCustomerNumber = "40749E8B-E26B-4E51-8D71-FEE609B9DA6F";
                shippingAgent.JITUsername = "conpacgroup_api";
                shippingAgent.JITPassword = "x-77MOi0V$se";
            }



            return shippingAgent;
        }

        // Calculate ship separately item.
        private ShippingRateModel CalculateShipSeparatelyItems(string packageType, JitAgent shippingAgent, PortalShippingModel portalShippingModel)
        {
            ShippingRateModel model = new ShippingRateModel();
            decimal itemTotalValue = 0.0m;
            decimal itemShippingRate = 0.0m;
            // Shipping estimate for ship-separately packages
            if (ShipSeparatelyItems?.Count > 0)
            {
                foreach (ZnodeShoppingCartItem separateItem in ShipSeparatelyItems)
                {
                    var singleItemlist = new ZnodeGenericCollection<ZnodeShoppingCartItem>();
                    singleItemlist.Add(separateItem);

                    var seperateItemPackage = new ZnodeShippingPackage(singleItemlist);

                    // Add insurance
                    itemTotalValue = seperateItemPackage.Value;

                    // Add customs
                    shippingAgent.TotalCustomsValue = itemTotalValue;

                    shippingAgent.PackageHeight = Convert.ToString(separateItem.Product.Height);
                    shippingAgent.PackageWidth = Convert.ToString(separateItem.Product.Width);
                    shippingAgent.PackageLength = Convert.ToString(separateItem.Product.Length);
                    shippingAgent.PackageWeight = separateItem.Product.Weight;
                    shippingAgent.PackageGroupCount = Convert.ToString(separateItem.Quantity);
                    shippingAgent.PackageCount = "1";
                    shippingAgent.ItemPackageTypeCode = string.IsNullOrEmpty(separateItem.Product?.PackagingType) ? string.Empty : separateItem.Product?.PackagingType;

                    if (separateItem.Quantity > 0)
                    {
                        model = GetShipSeparatelyItemsShippingRate(shippingAgent);
                        itemShippingRate = model.ShippingRate;
                    }

                    ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();

                    itemShippingRate = shippingHelper.GetShipSeparatelyItemsHandlingCharge(ShippingBag, separateItem, itemShippingRate);

                    separateItem.ShippingCost = itemShippingRate;
                }
            }

            return model;
        }

        // Calcualte ship together item.
        private ShippingRateModel CalculateShipTogetherItems(string packageType, JitAgent shippingAgent, PortalShippingModel portalShippingModel)
        {
            ShippingRateModel model = new ShippingRateModel();
            decimal itemShippingRate = 0.0m;

            // Shipping estimate for ship-together package
            if (ShipTogetherItems?.Count > 0)
            {
                var shipTogetherPackage = new ZnodeShippingPackage(ShipTogetherItems);

                model = GetShipToGetherItemRate(shippingAgent, portalShippingModel);
                itemShippingRate = model.ShippingRate;

                itemShippingRate = GetHandlingCharge(itemShippingRate);
            }
            model.ShippingRate = itemShippingRate;
            return model;
        }

        // Get ship separately item rate.
        private ShippingRateModel GetShipSeparatelyItemsShippingRate(JitAgent shippingAgent)
        {
            ShippingRateModel model = new ShippingRateModel();
            decimal itemShippingRate = 0.0m;

            if (shippingAgent.WeightUnit.ToUpper().Equals(WeightUnitKgs))
            {
                WeightUnitBase = shippingAgent.WeightUnit;
                shippingAgent.PackageWeight = ConvertWeightKgToLbs(shippingAgent.PackageWeight);
                shippingAgent.WeightUnit = WeightUnitBase = WeightUnitLbs;
            }

            model = shippingAgent.GetShippingRate();
            itemShippingRate += model.ShippingRate;

            model.ShippingRate = itemShippingRate;
            return model;
        }

        // Get ship together item rate.
        private ShippingRateModel GetShipToGetherItemRate(JitAgent shippingAgent, PortalShippingModel portalShippingModel)
        {
            ShippingRateModel model = new ShippingRateModel();
            decimal itemShippingRate = 0.0m;
            RateRequest request = MapShippingDetails(shippingAgent, portalShippingModel);

            object obj;
            if (((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary != null)
            {
                ((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary.TryGetValue(this.ClassName, out obj);
                TPWResponse carriers = (TPWResponse)obj;
                shippingAgent.CartCarrierList = carriers;
            }

            model = shippingAgent.GetShippingRate(request, Convert.ToDecimal(portalShippingModel.PackageWeightLimit));

            if (((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary == null)
            {
                ((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary = new Dictionary<string, object>();
            }

            ((CustomShoppingCart)ShoppingCart).CarrierResponseDictionary[this.ClassName] = shippingAgent.CartCarrierList;

            itemShippingRate += model.ShippingRate;

            model.ShippingRate = itemShippingRate;
            return model;
        }

        // Get discount, weightunit,dimension and currency code.
        private JitAgent GetDiscountWeightUnitDimensionUnitCurrencyCode(PortalShippingModel portalShippingModel, JitAgent shippingAgent)
        {
            bool useDiscountRate = false;
            string weightUnit = portalShippingModel?.portalUnitModel?.WeightUnit;
            string dimensionUnit = portalShippingModel?.portalUnitModel?.DimensionUnit;

            // Check to apply JIT discount rates
            if (useDiscountRate)
                shippingAgent.UseDiscountRate = useDiscountRate;

            // Check weight unit
            if (!string.IsNullOrEmpty(weightUnit))
                shippingAgent.WeightUnit = weightUnit.TrimEnd(new char[] { 'S' });

            // Check dimension unit
            if (!string.IsNullOrEmpty(dimensionUnit))
                shippingAgent.DimensionUnit = dimensionUnit;

            // Currency code
            shippingAgent.CurrencyCode = ZnodeCurrencyManager.CurrencyCode();

            return shippingAgent;
        }

        // Map package dimensions.
        private JitAgent MapPackageDimension(ZnodeShippingPackage package, JitAgent shippingAgent)
        {
            shippingAgent.PackageLength = Convert.ToInt32(package.Length).ToString();
            shippingAgent.PackageHeight = Convert.ToInt32(package.Height).ToString();
            shippingAgent.PackageWidth = Convert.ToInt32(package.Width).ToString();

            return shippingAgent;
        }

        // Map shipping destination address.
        private JitAgent MapShippingDestinationToAgent(ZnodeShoppingCart shoppingCart, JitAgent shippingAgent)
        {
            IZnodeRepository<Znode.Libraries.Data.DataModel.ZnodeShipping> _shippingRepository = new ZnodeRepository<Znode.Libraries.Data.DataModel.ZnodeShipping>();
            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();
            if (HelperUtility.IsNotNull(ShoppingCart?.Payment?.ShippingAddress))
            {
                shippingAgent.ShipToFirstName = ShoppingCart.Payment.ShippingAddress.FirstName;
                shippingAgent.ShipToLastName = ShoppingCart.Payment.ShippingAddress.LastName;
                shippingAgent.ShipToCompany = ShoppingCart.Payment.ShippingAddress.CompanyName;
                shippingAgent.ShipToAddress1 = ShoppingCart.Payment.ShippingAddress.Address1;
                shippingAgent.ShipToAddress2 = ShoppingCart.Payment.ShippingAddress.Address2;
                shippingAgent.ShipToCity = ShoppingCart.Payment.ShippingAddress.CityName;
                shippingAgent.ShipToZipCode = ShoppingCart.Payment.ShippingAddress.PostalCode;
                shippingAgent.ShipToStateCode = shippingHelper.GetStateCode(ShoppingCart.Payment.ShippingAddress.StateName);
                shippingAgent.ShipToCountryCode = HelperUtility.IsNotNull(ShoppingCart.Payment.ShippingAddress.CountryName) ? ShoppingCart.Payment.ShippingAddress.CountryName : _shippingRepository.Table.FirstOrDefault(x => x.ShippingId == shoppingCart.Shipping.ShippingID)?.DestinationCountryCode;
            }
            return shippingAgent;
        }

        // Map shipping origin address.
        private JitAgent MapShippingOriginToAgent(PortalShippingModel portalShippingModel, JitAgent shippingAgent)
        {
            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();

            // Service type
            shippingAgent.JITServiceType = ShippingBag.ShippingCode;
            shippingAgent.PackageTypeCode = portalShippingModel.FedExPackagingType;
            shippingAgent.DropOffType = portalShippingModel.FedExDropoffType;
            // Set portal default ware house address or origin address on flag basis.
            AddressModel portalWareHouseAddressModel = shippingHelper.GetPortalShippingAddress(portalShippingModel.PortalId);
            // Shipping origin
            shippingAgent.ShipperAddress1 = portalWareHouseAddressModel.Address1;
            shippingAgent.ShipperAddress2 = portalWareHouseAddressModel.Address2;
            shippingAgent.ShipperCity = portalWareHouseAddressModel.CityName;
            shippingAgent.ShipperZipCode = portalWareHouseAddressModel.PostalCode;
            shippingAgent.ShipperStateCode = shippingHelper.GetStateCode(string.IsNullOrEmpty(portalWareHouseAddressModel.StateName) ? portalWareHouseAddressModel.StateCode : portalWareHouseAddressModel.StateName);
            shippingAgent.ShipperCountryCode = portalWareHouseAddressModel.CountryName;

            return shippingAgent;
        }

        // Los activity for ship separately item.
        private void LogsActivityShipSeparatelyItems(ZnodeShoppingCart shoppingCart, JitAgent shippingAgent)
        {
            ShoppingCart.Shipping.ResponseCode = shippingAgent.ErrorCode;
            ShoppingCart.Shipping.ResponseMessage = GenericShippingErrorMessage();
            ShoppingCart.AddErrorMessage = GenericShippingErrorMessage();
            ZnodeLogging.LogMessage("Shipping error: " + shippingAgent.ErrorCode + " " + shippingAgent.ErrorDescription, "Shipping", TraceLevel.Error);
        }

        // Log activity.
        private void LogsActivity(ZnodeShoppingCart shoppingCart)
        {
            ShoppingCart.Shipping.ResponseCode = "-1";
            ShoppingCart.AddErrorMessage = "Shipping error: Invalid option selected.";
            ShoppingCart.Shipping.ResponseMessage = GenericShippingErrorMessage();
        }

        private RateRequest SetPackageLineItem(JitAgent shippingAgent, ZnodeGenericCollection<ZnodeShoppingCartItem> shipTogetherItems, bool isInsurance)
        {
            RateRequest request = new RateRequest();
            int count = 0;
            int packageLineItem = 1;
            int packageCount = 0;
            decimal packagePrice = 0.0M;
            request.RequestedShipment = new RequestedShipment();
            request.RequestedShipment.RequestedPackageLineItems = new RequestedPackageLineItem[ShipTogetherItems.Count];
            Dictionary<string, string> skuPartNumberDictionary = null;
            if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary.ContainsKey("_skuPart"))
            {
                skuPartNumberDictionary = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_skuPart"]);
            }

            foreach (ZnodeShoppingCartItem cartItem in ShipTogetherItems)
            {
                if (cartItem.Quantity > 0)
                {
                    request.RequestedShipment.RequestedPackageLineItems[count] = new RequestedPackageLineItem();

                    OrderAttributeModel uomAttribute = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "UOM");
                    OrderAttributeModel jitUOMAttribute = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "JITBuyUOM");
                    OrderAttributeModel priceUnitDescriptionAttribute = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "PriceUnit");
                    OrderAttributeModel qtyPerShipUnitAttribute = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "QtyPerShipUnit");
                    bool usePricePerShipUnit = false;
                    bool useJitUOMAttributeOverride = jitUOMAttribute != null && !String.IsNullOrEmpty(jitUOMAttribute.AttributeValue);
                    int perShipUnit = 0;
                    string measureValue = uomAttribute.AttributeValue;
                    if (uomAttribute != null && priceUnitDescriptionAttribute != null && qtyPerShipUnitAttribute != null)
                    {
                        measureValue = (useJitUOMAttributeOverride && jitUOMAttribute != null ? jitUOMAttribute.AttributeValue : uomAttribute.AttributeValue);
                        int.TryParse(qtyPerShipUnitAttribute.AttributeValue, out perShipUnit);
                        List<CustomUOMRule> uomRuleList = _customUomRulesRepository.Table.ToList();
                        if (perShipUnit > 0)
                        {
                            foreach (CustomUOMRule rule in uomRuleList)
                            {
                                if (measureValue.ToLower() == rule.UOM.ToLower() && priceUnitDescriptionAttribute.AttributeValue.ToLower() == rule.Description.ToLower())
                                {
                                    usePricePerShipUnit = true;
                                }
                            }
                        }
                    }
                    dSkuUom[cartItem.SKU] = priceUnitDescriptionAttribute.AttributeValue;
                    dSkuCarrier[cartItem.SKU] = this.Name;

                    // Set the package sequence number
                    request.RequestedShipment.RequestedPackageLineItems[count].SequenceNumber = packageLineItem.ToString();
                    request.RequestedShipment.RequestedPackageLineItems[count].GroupPackageCount = Convert.ToString((usePricePerShipUnit ? (int)cartItem.Quantity * perShipUnit : (int)cartItem.Quantity));
                    decimal totalWeight = cartItem.Quantity * cartItem.Product.Weight;

                    //Set Packaging Type
                    request.RequestedShipment.RequestedPackageLineItems[count].PhysicalPackaging = string.IsNullOrEmpty(cartItem.Product?.PackagingType) ? PhysicalPackagingType.BOX : (PhysicalPackagingType)Enum.Parse(typeof(PhysicalPackagingType), cartItem.Product?.PackagingType, true);
                    request.RequestedShipment.RequestedPackageLineItems[count].PhysicalPackagingSpecified = true;

                    // Set the package weight 
                    request.RequestedShipment.RequestedPackageLineItems[count].Weight = new Weight();
                    request.RequestedShipment.RequestedPackageLineItems[count].Weight.Value = totalWeight;
                    request.RequestedShipment.RequestedPackageLineItems[count].Weight.ValueSpecified = true;
                    request.RequestedShipment.RequestedPackageLineItems[count].Weight.Units = (WeightUnits)Enum.Parse(typeof(WeightUnits), shippingAgent.WeightUnit);
                    request.RequestedShipment.RequestedPackageLineItems[count].Weight.UnitsSpecified = true;

                    // Set the package dimensions
                    request.RequestedShipment.RequestedPackageLineItems[count].Dimensions = new Dimensions();
                    request.RequestedShipment.RequestedPackageLineItems[count].Dimensions.Length = Convert.ToString((int)cartItem.Product.Length);
                    request.RequestedShipment.RequestedPackageLineItems[count].Dimensions.Width = Convert.ToString((int)cartItem.Product.Width);
                    request.RequestedShipment.RequestedPackageLineItems[count].Dimensions.Height = Convert.ToString((int)cartItem.Product.Height);
                    request.RequestedShipment.RequestedPackageLineItems[count].Dimensions.Units = (LinearUnits)Enum.Parse(typeof(LinearUnits), shippingAgent.DimensionUnit);
                    request.RequestedShipment.RequestedPackageLineItems[count].Dimensions.UnitsSpecified = true;
                    OrderAttributeModel JitProductNumberAttribute = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "JITPartNumber");
                    if (JitProductNumberAttribute != null)
                    {
                        request.RequestedShipment.RequestedPackageLineItems[count].ItemDescription = JitProductNumberAttribute.AttributeValue;
                        if (skuPartNumberDictionary == null)
                            skuPartNumberDictionary = new Dictionary<string, string>();
                        skuPartNumberDictionary[cartItem.Product.SKU] = JitProductNumberAttribute.AttributeValue;
                    }
                    else
                    {
                        request.RequestedShipment.RequestedPackageLineItems[count].ItemDescription = cartItem.Product.SKU;
                    }

                    count++;
                    packageLineItem++;

                    packageCount = packageCount + (int)cartItem.Quantity;
                    packagePrice = packagePrice + cartItem.Product.FinalPrice;
                }
            }
            if (skuPartNumberDictionary != null)
                ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_skuPart"] = Newtonsoft.Json.JsonConvert.SerializeObject(skuPartNumberDictionary);

            if (dSkuUom != null)
                ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_itemSkus"] = Newtonsoft.Json.JsonConvert.SerializeObject(dSkuUom);

            if (dSkuCarrier != null)
                ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_itemCarriers"] = Newtonsoft.Json.JsonConvert.SerializeObject(dSkuCarrier);

            if (isInsurance)
                shippingAgent.TotalInsuredValue = packagePrice;

            request.RequestedShipment.PackageCount = packageCount.ToString();
            return request;
        }

        private RateRequest SetFrightPackageLineItem(JitAgent shippingAgent, ZnodeGenericCollection<ZnodeShoppingCartItem> shipTogetherItems, bool isInsurance)
        {
            RateRequest request = new RateRequest();
            int count = 0;
            int packageLineItem = 1;
            int packageCount = 0;
            request.RequestedShipment = new RequestedShipment();
            request.RequestedShipment.FreightShipmentDetail = new FreightShipmentDetail();
            request.RequestedShipment.FreightShipmentDetail.LineItems = new FreightShipmentLineItem[ShipTogetherItems.Count];
            foreach (ZnodeShoppingCartItem cartItem in ShipTogetherItems)
            {
                if (cartItem.Quantity > 0)
                {
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count] = new FreightShipmentLineItem();

                    // Set the package sequence number
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].FreightClass = FreightClassType.CLASS_100;
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].FreightClassSpecified = true;

                    //Set Packaging Type
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Packaging = string.IsNullOrEmpty(cartItem.Product?.PackagingType) ? PhysicalPackagingType.BOX : (PhysicalPackagingType)Enum.Parse(typeof(PhysicalPackagingType), cartItem.Product?.PackagingType, true);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].PackagingSpecified = true;
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Description = "Freight line item description";

                    // Set the package weight 
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Weight = new Weight();
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Weight.Value = (decimal)(cartItem.Product.Weight * cartItem.Quantity);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Weight.ValueSpecified = true;
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Weight.Units = (WeightUnits)Enum.Parse(typeof(WeightUnits), shippingAgent.WeightUnit);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Weight.UnitsSpecified = true;

                    // Set the package dimensions
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Dimensions = new Dimensions();
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Dimensions.Length = Convert.ToString((int)cartItem.Product.Length);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Dimensions.Width = Convert.ToString((int)cartItem.Product.Width);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Dimensions.Height = Convert.ToString((int)cartItem.Product.Height);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Dimensions.Units = (LinearUnits)Enum.Parse(typeof(LinearUnits), shippingAgent.DimensionUnit);
                    request.RequestedShipment.FreightShipmentDetail.LineItems[count].Dimensions.UnitsSpecified = true;
                    count++;
                    packageLineItem++;

                    packageCount = packageCount + (int)cartItem.Quantity;
                }
            }

            request.RequestedShipment.FreightShipmentDetail.TotalHandlingUnits = packageCount.ToString();
            request.RequestedShipment.PackageCount = count.ToString();
            return request;
        }

        private PortalShippingModel GetAgentDetails(ref JitAgent shippingAgent, out string packageType)
        {
            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();
            PortalShippingModel portalShippingModel = shippingHelper.GetPortalShipping(Convert.ToInt32(ShoppingCart.PortalId), GetPublishStateId(ShoppingCart.PublishStateId));

            packageType = portalShippingModel.FedExPackagingType;

            try
            {
                // Get JIT credentials.
                shippingAgent = GetAgentCredentials(portalShippingModel, shippingAgent);
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("There was an error decrypting JIT account information.", "Shipping", TraceLevel.Error, ex);
            }

            if (string.IsNullOrEmpty(shippingAgent.JITUsername)
                || string.IsNullOrEmpty(shippingAgent.JITPassword)
                || string.IsNullOrEmpty(shippingAgent.JITCustomerNumber))
            {
                ShoppingCart = shippingHelper.SetShippingErrorMessage(ShoppingCart);
                ShoppingCart.Shipping.ResponseMessage = GenericShippingErrorMessage();
            }

            // Shipping origin properties.
            shippingAgent = MapShippingOriginToAgent(portalShippingModel, shippingAgent);

            // Destination properties.
            shippingAgent = MapShippingDestinationToAgent(ShoppingCart, shippingAgent);


            // Ship-to residence
            shippingAgent.ShipToAddressIsResidential = ShoppingCart?.Payment?.ShippingAddress?.AccountId > 0;

            shippingAgent = GetDiscountWeightUnitDimensionUnitCurrencyCode(portalShippingModel, shippingAgent);

            // Split the items that ship separately from the items that ship together
            SplitShipSeparatelyFromShipTogether(ref shippingAgent);
            return portalShippingModel;
        }

        private RateRequest MapShippingDetails(JitAgent shippingAgent, PortalShippingModel portalShippingModel)
        {
            var shipTogetherPackage = new ZnodeShippingPackage(ShipTogetherItems);

            //Splite Weight if Weight is greter than 150 for JIT
            List<decimal> splWeight = new List<decimal>();
            if (shippingAgent.WeightUnit.ToUpper().Equals(WeightUnitKgs))
            {
                WeightUnitBase = shippingAgent.WeightUnit;
                shippingAgent.PackageWeight = ConvertWeightKgToLbs(shippingAgent.PackageWeight);
                shippingAgent.WeightUnit = WeightUnitBase = WeightUnitLbs;
            }
            shippingAgent.PackageWeight = shipTogetherPackage.Weight;

            RateRequest request = new RateRequest();
            if (shippingAgent.IsFreightServiceType(shippingAgent.JITServiceType))
                request = SetFrightPackageLineItem(shippingAgent, ShipTogetherItems, false);
            else
                request = SetPackageLineItem(shippingAgent, ShipTogetherItems, false);
            return request;
        }

        private decimal GetHandlingCharge(decimal itemShippingRate)
        {
            ZnodeShippingHelper shippingHelper = new ZnodeShippingHelper();

            itemShippingRate = shippingHelper.GetShipTogetherItemsHandlingCharge(ShippingBag, itemShippingRate);
            return itemShippingRate;
        }

        public void SplitShipSeparatelyFromShipTogether(ref JitAgent shippingAgent)
        {
            List<InventoryWarehouseMapperModel> warehouseInv = ((CustomShoppingCart)ShoppingCart).WarehouseInventory.InventoryWarehouseMapperList;
            string recipientZip = ((CustomShoppingCart)ShoppingCart).Payment.ShippingAddress.PostalCode;
            bool isResidential = (((CustomShoppingCart)ShoppingCart).Payment.ShippingAddress.Address3 != null ? Equals(((CustomShoppingCart)ShoppingCart).Payment.ShippingAddress.Address3.ToString().ToLower(), "residential") : false);
            decimal orderMinimum = ((CustomShoppingCart)ShoppingCart).MyWarehouseOrderMin;
            int myWarehouseId = (((CustomShoppingCart)ShoppingCart).MyWarehouseId == null ? 0 : (int)((CustomShoppingCart)ShoppingCart).MyWarehouseId);
            string MyWarehouseShipperName = ((CustomShoppingCart)ShoppingCart).MyWarehouseShipperName;

            //For JIT ONLY
            //if (isResidential) {
            //    shippingAgent.ErrorCode = "-1";
            //    shippingAgent.ErrorDescription = "JIT does not ship to addresses marked as residential.";
            //    ZnodeLogging.LogMessage("JIT does not ship to addresses marked as residential", "Shipping", TraceLevel.Error);
            //    return;
            //}

            List<InventoryWarehouseMapperModel> myWarehouseCartItems = new List<InventoryWarehouseMapperModel>();

            List<InventoryWarehouseMapperModel> shipmentWarehouseCartItems = new List<InventoryWarehouseMapperModel>();
            List<InventoryWarehouseMapperModel> otherShipmentWarehouseCartItems = new List<InventoryWarehouseMapperModel>();

            bool thisIsMyWarehouseShipper = false;
            List<int> NotThisShipperWarehouseIds = new List<int>();
            foreach (KeyValuePair<int, List<InventoryWarehouseMapperModel>> kvp in ((CustomShoppingCart)ShoppingCart).WarehouseSkuDictionary)
            {
                ConpacWarehouseAttribute shipperNameAttribute = _warehouseAttributeRepository.Table.FirstOrDefault(o => o.Type == "SHP" && o.WarehouseId == kvp.Key);
                if (shipperNameAttribute == null || shipperNameAttribute.Value == null)
                {
                    shippingAgent.ErrorCode = "-1";
                    shippingAgent.ErrorDescription = "Warehouse exists without Shipper Name.";
                    ZnodeLogging.LogMessage("Warehouse exists without Shipper Name", "Shipping", TraceLevel.Error);
                    return;
                };
                if (shipperNameAttribute.Value.ToLower() == this.Name.ToLower())
                {
                    shipmentWarehouseCartItems.AddRange(kvp.Value.Where(o => !shipmentWarehouseCartItems.Select(s => s.SKU).ToList().Contains(o.SKU)));

                    if (kvp.Key == myWarehouseId)
                    {
                        thisIsMyWarehouseShipper = true;
                        ((CustomShoppingCart)ShoppingCart).WarehouseSkuDictionary.TryGetValue(myWarehouseId, out myWarehouseCartItems);
                    }
                }
                else
                {
                    NotThisShipperWarehouseIds.Add(kvp.Key);
                    otherShipmentWarehouseCartItems.AddRange(kvp.Value.Where(o => !otherShipmentWarehouseCartItems.Select(s => s.SKU).ToList().Contains(o.SKU)));
                }
            }
            List<ZnodeShoppingCartItem> chillitemsJit = new List<ZnodeShoppingCartItem>();
            List<ZnodeShoppingCartItem> UpsItemsjit = new List<ZnodeShoppingCartItem>();//Atish ups
    
            foreach(var removeitem in ShippingBag.ShoppingCart.ShoppingCartItems)//Atish ups
            {
                var fromupsval = removeitem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "FromUPS")?.AttributeValue;//Atish ups
                var Freeproductval = removeitem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "FreeFreight")?.AttributeValue;
                var fromups = fromupsval != null && fromupsval == "true";
                var fromfree = Freeproductval != null && Freeproductval == "true";

                if (fromups)
                {
                    UpsItemsjit.Add(removeitem);
                }
                if (fromfree)
                {
                    chillitemsJit.Add(removeitem);
                }
            }

            //if (ShippingBag.ShoppingCart.ShoppingCartItems.Any(x => x.SKU.ToLower().Contains("chill")))
            //{
            //    chillitemsJit = ShippingBag.ShoppingCart.ShoppingCartItems.Where(x => x.SKU.ToLower().Contains("chill")).ToList();
            //    ShippingBag.ShoppingCart.ShoppingCartItems.RemoveAll(x => x.SKU.ToLower().Contains("chill"));
            //}
            if (UpsItemsjit.Count > 0)
            {
                foreach (ZnodeShoppingCartItem itemToRemove in UpsItemsjit)
                {
                    ShippingBag.ShoppingCart.ShoppingCartItems.Remove(itemToRemove);
                }
            }
            if (chillitemsJit.Count > 0)//Atish ups
            {
                foreach (ZnodeShoppingCartItem itemToRemove in chillitemsJit)
                {
                    ShippingBag.ShoppingCart.ShoppingCartItems.Remove(itemToRemove);
                }
            }

            bool thisShipperCanShipAll = (ShippingBag.ShoppingCart.ShoppingCartItems.Join(shipmentWarehouseCartItems, o => o.SKU, w => w.SKU, (o, w) => new { o, w }).Count() == ShippingBag.ShoppingCart.ShoppingCartItems.Count());
            bool otherShipperCanShipAll = (ShippingBag.ShoppingCart.ShoppingCartItems.Join(otherShipmentWarehouseCartItems, o => o.SKU, w => w.SKU, (o, w) => new { o, w }).Count() == ShippingBag.ShoppingCart.ShoppingCartItems.Count());

            //if (chillitemsJit.Count() > 0)
            //{
            //    ShippingBag.ShoppingCart.ShoppingCartItems.AddRange(chillitemsJit);
            //}
            if (UpsItemsjit.Count > 0)//Atish ups
            {
               
              ShippingBag.ShoppingCart.ShoppingCartItems.AddRange(UpsItemsjit);
                
            }
            if (chillitemsJit.Count > 0)//Atish ups
            {

                ShippingBag.ShoppingCart.ShoppingCartItems.AddRange(chillitemsJit);

            }


            //JUST FOR JIT - ITEMS GET REMOVED IF THEY CAN BE SHIPPED BY ALTERNATE SHIPPERS
            //If other shipping methods can ship all the items, then we don't need to ship any items using JIT.
            if (!thisIsMyWarehouseShipper)
            {
                if (otherShipperCanShipAll && (isResidential || (myWarehouseId != null && myWarehouseId > 0)))// added isResidential check to fix shipping option dictinary issue
                {
                    shippingAgent.ErrorCode = "-1";
                    shippingAgent.ErrorDescription = "Use alternate shipping method";
                    return;
                }

                // if alternate shipper can't ship everything, move any items in the cart that can be shipped by alternate shipper out of current shipper
                if (otherShipmentWarehouseCartItems.Count > 0)
                {
                    shipmentWarehouseCartItems.RemoveAll(x => otherShipmentWarehouseCartItems.Select(o => o.SKU).ToList().Contains(x.SKU));
                }
            }

            if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary == null)
            {
                ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary = new Dictionary<string, string>();
            }

            Dictionary<string, string> itemUOM = null;
            Dictionary<string, string> itemCarrier = null;
            Dictionary<string, string> carrierMethod = new Dictionary<string, string>();
            if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary.ContainsKey("_itemSkus"))
            {
                itemUOM = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_itemSkus"]);
            }

            if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary.ContainsKey("_itemCarriers"))
            {
                itemCarrier = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_itemCarriers"]);
            }

            if (((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary.ContainsKey("_carrierMethods"))
            {
                carrierMethod = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_carrierMethods"]);
            }

            foreach (KeyValuePair<string, string> entry in (from ci in shipmentWarehouseCartItems join d in dSkuUom on ci.SKU equals d.Key select d))
            {
                if (itemUOM == null)
                    itemUOM = new Dictionary<string, string>();
                itemUOM[entry.Key] = entry.Value;
            }

            foreach (KeyValuePair<string, string> entry in (from ci in shipmentWarehouseCartItems join d in dSkuCarrier on ci.SKU equals d.Key select d))
            {
                if (itemCarrier == null)
                    itemCarrier = new Dictionary<string, string>();
                itemCarrier[entry.Key] = entry.Value;
            }

            carrierMethod[this.Name] = ShoppingCart.Shipping.ShippingName;
            if (((CustomShoppingCart)ShoppingCart).Shipping2Carrier != null)
                if (((CustomShoppingCart)ShoppingCart).Shipping2Carrier == this.ClassName)
                {
                    carrierMethod[this.Name] = ((CustomShoppingCart)ShoppingCart).Shipping2Method;
                }


            if (itemUOM != null)
                ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_itemSkus"] = Newtonsoft.Json.JsonConvert.SerializeObject(itemUOM);
            if (itemCarrier != null)
            {
                //foreach (var item in shipmentWarehouseCartItems)
                //{
                //    if (!itemCarrier.Any(x => x.Key == item.SKU))
                //        itemCarrier[this.Name] = item.SKU;
                //}
                ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_itemCarriers"] = Newtonsoft.Json.JsonConvert.SerializeObject(itemCarrier);

            }
            ((CustomShoppingCart)ShoppingCart).WarehouseNameCodeDictionary["_carrierMethods"] = Newtonsoft.Json.JsonConvert.SerializeObject(carrierMethod);



            isFreeFreight = false;
            decimal myWarehouseItemExtendedPrice = ShippingBag.ShoppingCart.ShoppingCartItems.Join(myWarehouseCartItems, o => o.SKU, w => w.SKU, (o, w) => new { o, w }).Sum(v => v.o.ExtendedPrice);
            // TODO: would like the "localfreight" to be a global parameter.
            if (thisIsMyWarehouseShipper && myWarehouseItemExtendedPrice >= orderMinimum && shippingAgent.JITServiceType == freeFreightCarrierName)
            {
                // all the items are in the Box Partners warehouse and the minimum has been met.
                isFreeFreight = true;
                ShippingBag.ShoppingCart.Custom1 = "You qualify for free freight!";
            }
            else if (thisIsMyWarehouseShipper && ShoppingCart.Shipping.ShippingName == freeFreightCarrierName)
            {
                decimal FreeFreightDifference = orderMinimum - myWarehouseItemExtendedPrice;
                ShippingBag.ShoppingCart.Custom1 = "You need to add $" + FreeFreightDifference.ToString("0.00") + " for free freight";
            }

            foreach (ZnodeShoppingCartItem cartItem in ShippingBag.ShoppingCart.ShoppingCartItems)
            {
                //Customization for show shipping in admin on taxable state [JIT:JIT]
                if (shipmentWarehouseCartItems.Count == 0)
                {

                    foreach (KeyValuePair<int, List<InventoryWarehouseMapperModel>> kvp in ((CustomShoppingCart)ShoppingCart).WarehouseSkuDictionary)
                    {
                        ConpacWarehouseAttribute shipperNameAttribute = _warehouseAttributeRepository.Table.FirstOrDefault(o => o.Type == "SHP" && o.WarehouseId == kvp.Key);
                        if (shipperNameAttribute.Value.ToLower() == this.Name.ToLower())
                        {
                            shipmentWarehouseCartItems.AddRange(kvp.Value.Where(o => !shipmentWarehouseCartItems.Select(s => s.SKU).ToList().Contains(o.SKU)));
                        }

                    }
                }
                //End customization

                if (!shipmentWarehouseCartItems.Where(o => o.SKU == cartItem.SKU).Any()) continue;
                var freeFreightVal = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "FreeFreight")?.AttributeValue;
                var FromUPSVal = cartItem.Product.Attributes.FirstOrDefault(o => o.AttributeCode == "FromUPS")?.AttributeValue;//Atish ups
                var freeFreight = freeFreightVal != null && freeFreightVal == "true";
                var FromUPS = FromUPSVal != null && FromUPSVal == "true";//Atish ups
                if (!freeFreight && !FromUPS)//Atish ups
                {
                    var hasWeight = false;
                    if (cartItem.Product.FreeShippingInd)
                    {
                        foreach (ZnodeProductBaseEntity addOn in cartItem.Product.ZNodeAddonsProductCollection)
                        {
                            if (!addOn.FreeShippingInd && addOn.Weight > 0)
                            {
                                hasWeight = true;
                                break;
                            }
                        }
                    }

                    if (cartItem.Product?.ZNodeGroupProductCollection?.Count < 1 && cartItem.Product?.ZNodeConfigurableProductCollection?.Count < 1)
                        SetProductItemForShipTogetherItemsOrShipSeparatelyItems(cartItem, hasWeight);

                    ShipTogetherOrShipSeparatelyForGroupAddonConfigureProduct(cartItem.Product.ZNodeGroupProductCollection, hasWeight, cartItem, true);
                    ShipTogetherOrShipSeparatelyForGroupAddonConfigureProduct(cartItem.Product.ZNodeConfigurableProductCollection, hasWeight, cartItem);
                    ShipTogetherOrShipSeparatelyForGroupAddonConfigureProduct(cartItem.Product.ZNodeAddonsProductCollection, hasWeight, cartItem);
                }

            }
        }

        private void ShipTogetherOrShipSeparatelyForGroupAddonConfigureProduct(ZnodeGenericCollection<ZnodeProductBaseEntity> productCollection, bool hasWeight, ZnodeShoppingCartItem cartItem, bool isgroupProduct = false)
        {
            foreach (ZnodeProductBaseEntity groupItem in productCollection)
            {
                SetProductItemForShipTogetherItemsOrShipSeparatelyItems(groupItem, hasWeight, cartItem, isgroupProduct);
            }
        }

        private void SetProductItemForShipTogetherItemsOrShipSeparatelyItems(ZnodeProductBaseEntity product, bool hasWeight, ZnodeShoppingCartItem cartItem, bool isgroupProduct = false)
        {
            ZnodeShoppingCartItem zNodeShoppingCartItem = new ZnodeShoppingCartItem();
            if (product.Weight > 0 && product.ShipSeparately)
            {
                if (!product.FreeShippingInd || hasWeight)
                {
                    zNodeShoppingCartItem.Product = product;
                    zNodeShoppingCartItem.Quantity = SetQuantityForGroupProduct(isgroupProduct, product, cartItem);
                    ShipSeparatelyItems.Add(zNodeShoppingCartItem);
                }
            }
            else if (product.Weight > 0 && !product.ShipSeparately && (!product.FreeShippingInd || hasWeight))
            {
                zNodeShoppingCartItem.Product = product;
                zNodeShoppingCartItem.Quantity = SetQuantityForGroupProduct(isgroupProduct, product, cartItem);
                ShipTogetherItems.Add(zNodeShoppingCartItem);
            }
        }

        private decimal SetQuantityForGroupProduct(bool isgroupProduct, ZnodeProductBaseEntity product, ZnodeShoppingCartItem cartItem)
        {
            return isgroupProduct ? product.SelectedQuantity : cartItem.Quantity;
        }

        private void SetProductItemForShipTogetherItemsOrShipSeparatelyItems(ZnodeShoppingCartItem cartItem, bool hasWeight)
        {
            if (cartItem.Product.Weight > 0 && cartItem.Product.ShipSeparately)
            {
                if (!cartItem.Product.FreeShippingInd || hasWeight)
                    ShipSeparatelyItems.Add(cartItem);
            }
            else if (cartItem.Product.Weight > 0 && !cartItem.Product.ShipSeparately && (!cartItem.Product.FreeShippingInd || hasWeight))
            {
                ShipTogetherItems.Add(cartItem);
            }
        }
    }
}
