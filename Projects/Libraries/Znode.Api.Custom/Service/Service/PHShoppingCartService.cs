using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.Services.Maps;
using Znode.Engine.Shipping;
using Znode.Libraries.Admin;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.Data.Helpers;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.MongoDB.Data;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using Znode.Libraries.Resources;
using Znode.Engine.Services;
using Znode.Custom.Data;
using Znode.Engine.Shipping.Custom;
using Znode.Engine.Shipping.Custom.Interface;

namespace Znode.Api.Custom.Service
{
    public class PHShoppingCartService : ShoppingCartService, IShoppingCartService
    {
        #region Private Variables
        private readonly IZnodeRepository<ZnodeOmsCookieMapping> _cookieMappingRepository;
        private readonly IZnodeRepository<ZnodeOmsSavedCart> _omsSavedRepository;
        private readonly IZnodeRepository<ZnodeOmsSavedCartLineItem> _savedCartLineItemService;
        private readonly IZnodeRepository<ZnodeOmsOrderDetail> _orderDetailRepository;
        private readonly IZnodeRepository<ZnodeOmsOrderLineItem> _orderLineItemRepository;
        private readonly IZnodeRepository<ZnodeOmsOrderLineItemRelationshipType> _lineItemRelationshipType;
        private readonly IZnodeRepository<ConpacWarehouseAttribute> _conpacWarehouseAttributeRepository;
        private readonly IZnodeRepository<ZnodeWarehouseAddress> _wareHouseAddressRepository;
        private readonly IZnodeRepository<ZnodeWarehouse> _conpacWarehouseRepository;
        private IGlobalAttributeGroupEntityService _attributeGroupEntityService;
        private readonly IAccountService _accountService;


        private readonly IZnodeRepository<ZnodeState> _stateRepository;
        private readonly IPublishProductHelper publishProductHelper;
        private readonly IZnodeOrderHelper orderHelper;
        public static string SKU { get; } = "sku";
        public static string Width { get; } = "width";
        public static string Height { get; } = "height";
        private readonly IShoppingCartMap _shoppingCartMap;
        private readonly ICustomShoppingCartMap _customShoppingCartMap;
        private readonly IShoppingCartItemMap _shoppingCartItemMap;
        public readonly string[] _upsLTLCode = { "308", "309", "310" };

        public readonly IWarehouseService _warehouseService;
        #endregion

        #region Constructor
        public PHShoppingCartService()
        {
            _cookieMappingRepository = new ZnodeRepository<ZnodeOmsCookieMapping>();
            _omsSavedRepository = new ZnodeRepository<ZnodeOmsSavedCart>();
            _savedCartLineItemService = new ZnodeRepository<ZnodeOmsSavedCartLineItem>();
            _orderDetailRepository = new ZnodeRepository<ZnodeOmsOrderDetail>();
            _lineItemRelationshipType = new ZnodeRepository<ZnodeOmsOrderLineItemRelationshipType>();
            _conpacWarehouseAttributeRepository = new ZnodeRepository<ConpacWarehouseAttribute>(new Custom_Entities());
            _stateRepository = new ZnodeRepository<ZnodeState>();
            publishProductHelper = GetService<IPublishProductHelper>();
            orderHelper = GetService<IZnodeOrderHelper>();
            _orderLineItemRepository = new ZnodeRepository<ZnodeOmsOrderLineItem>();
            _shoppingCartMap = GetService<IShoppingCartMap>();
            _customShoppingCartMap = GetService<ICustomShoppingCartMap>();
            _shoppingCartItemMap = GetService<IShoppingCartItemMap>();
            _warehouseService = GetService<IWarehouseService>();
            _attributeGroupEntityService = GetService<IGlobalAttributeGroupEntityService>();
            _accountService = GetService<IAccountService>();
        }
        #endregion

        #region Public Methods

        public override ShippingListModel GetShippingEstimates(string zipCode, ShoppingCartModel model)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            ZnodeLogging.LogMessage("Base - GetShippingEstimates", "Custom", TraceLevel.Info);
            if (HelperUtility.IsNull(model))
                throw new ZnodeException(ErrorCodes.NullModel, Admin_Resources.ErrorShoppingCartModelNull);

            if (string.IsNullOrEmpty(zipCode))
                return null;

            List<ShippingModel> listwithRates = new List<ShippingModel>();
            try
            {
                List<ShippingModel> list = GetShippingList(model);

                ZnodeLogging.LogMessage("Shipping list:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, list?.Count);
                if (list?.Count > 0)
                {
                    if (Equals(model.ShippingAddress, null))
                    {
                        IZnodeRepository<ZnodeAddress> _addressRepository = new ZnodeRepository<ZnodeAddress>();
                        IZnodeRepository<ZnodeUserAddress> _addressUserRepository = new ZnodeRepository<ZnodeUserAddress>();
                        var shippingAddress = (from p in _addressRepository.Table
                                               join q in _addressUserRepository.Table
                                                   on p.AddressId equals q.AddressId
                                               where (q.UserId == model.UserId) && (p.IsDefaultShipping)
                                               select new AddressModel
                                               {
                                                   StateName = p.StateName,
                                                   CountryName = p.CountryName,
                                                   PostalCode = p.PostalCode,
                                                   AccountId = p.ZnodeAccountAddresses == null || p.ZnodeAccountAddresses.FirstOrDefault() == null ? 0 : p.ZnodeAccountAddresses.FirstOrDefault().AccountId,
                                               }).FirstOrDefault();
                        model.ShippingAddress = (shippingAddress != null) ? shippingAddress : new AddressModel();
                    }
                    string countryCode = model?.ShippingAddress?.CountryName;
                    string stateCode = GetStateCode(model?.ShippingAddress?.StateName);
                    ZnodeLogging.LogMessage("Parameter:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { countryCode = countryCode, stateCode = stateCode });

                    if (!string.IsNullOrEmpty(countryCode) && !string.IsNullOrEmpty(stateCode))
                        list = GetShippingByCountryAndStateCode(countryCode, stateCode, list);

                    if (!string.IsNullOrEmpty(model.ShippingAddress?.PostalCode))
                        list = GetShippingByZipCode(model.ShippingAddress.PostalCode, list);

                    //check shipping type and call that service to get the rates. Add the rates in the list.
                    if (Equals(model.ShippingAddress, null))
                        model.ShippingAddress = new AddressModel();

                    model.ShippingAddress.PostalCode = zipCode;
                    model.ShippingAddress.StateCode = stateCode;
                    model.ShippingAddress.CountryName = countryCode;
                    model.ShippingAddress.Address1 = string.IsNullOrEmpty(model.ShippingAddress.Address1) ? string.Empty : model.ShippingAddress.Address1;
                    model.ShippingAddress.CityName = string.IsNullOrEmpty(model.ShippingAddress.CityName) ? string.Empty : model.ShippingAddress.CityName;

                    Engine.Shipping.Custom.CustomShoppingCart znodeShoppingCart = _customShoppingCartMap.ToZnodeShoppingCart(model);
                    List<ShippingModel> upslist = list.Where(w => w.ShippingTypeName.ToLower() == ZnodeConstant.UPS.ToLower() /*|| w.ShippingTypeName.ToLower() == ZnodeConstant.FedEx.ToLower()*/).ToList();
                    list?.RemoveAll(r => (r.ShippingTypeName?.ToLower() == ZnodeConstant.UPS.ToLower() /*|| r.ShippingTypeName?.ToLower() == ZnodeConstant.FedEx.ToLower() */) && !_upsLTLCode.Contains(r.ShippingCode));

                    //Call the respective shipping classes to get the shipping rates rates.

                    AppendWarehouseInformation(model, znodeShoppingCart);

                    //CUSTOMIZATION: If one shipper has items and fails, all shipping needs to fail.
                    Dictionary<string, bool> carriersWithItemsDictionary = new Dictionary<string, bool>();

                    GlobalAttributeEntityDetailsModel attributesEntity = (this.PortalId != null ? _attributeGroupEntityService.GetEntityAttributeDetails((int)this.PortalId, ZnodeConstant.Store) : new GlobalAttributeEntityDetailsModel { Groups = new List<GlobalAttributeGroupModel>(), Attributes = new List<GlobalAttributeValuesModel>() });
                    GlobalAttributeValuesModel displayOrderTakeValue = attributesEntity?.Attributes.FirstOrDefault(x => x.AttributeCode == "ShippingMethodDisplayOrderTake");
                    GlobalAttributeValuesModel displayOrderTakeAdditional = attributesEntity?.Attributes.FirstOrDefault(x => x.AttributeCode == "ShippingMethodDisplayOrderAdditional");

                    foreach (ShippingModel item in list)
                    {
                        model.Shipping.ShippingId = item.ShippingId;
                        model.Shipping.ShippingName = item.ShippingCode;
                        model.Shipping.ShippingCountryCode = string.IsNullOrEmpty(countryCode) ? item.DestinationCountryCode : countryCode;

                        znodeShoppingCart.Shipping = ShippingMap.ToZnodeShipping(model.Shipping);
                        CustomShippingManager shippingManager = new CustomShippingManager(znodeShoppingCart);

                        shippingManager.Calculate();
                        item.ShippingRate = znodeShoppingCart.ShippingCost;
                        if (item.ShippingRate > 0 && znodeShoppingCart?.Shipping?.ShippingDiscount > 0)
                            item.ShippingRateWithoutDiscount = znodeShoppingCart.ShippingCost + znodeShoppingCart.Shipping.ShippingDiscount;

                        item.ApproximateArrival = znodeShoppingCart.ApproximateArrival;

                        if (znodeShoppingCart.Custom1 != null && (item.ShippingCode == "LOCALFREIGHT" || item.ShippingCode == "OURTRUCK"))
                        {
                            item.Description = " " + znodeShoppingCart.Custom1;
                            znodeShoppingCart.Custom1 = null;
                        }
                        if (znodeShoppingCart.WarehouseNameCodeDictionary != null)
                        {
                            string warehouseCode = null;
                            znodeShoppingCart.WarehouseNameCodeDictionary.TryGetValue(item.ClassName, out warehouseCode);

                            WarehouseModel warehouseWithAddress = GetShippingWareHouseAddress(warehouseCode);
                            if (warehouseWithAddress != null)
                            {
                                item.Custom1 = string.Format("{0}, {1}", warehouseWithAddress.CityName, warehouseWithAddress.StateName);
                            }

                        }
                        if (Equals(znodeShoppingCart?.Shipping?.ResponseCode, "0"))
                        {
                            listwithRates.Add(item);
                            carriersWithItemsDictionary[item.ClassName] = true;
                        }

                    }

                    //CUSTOMIZATION: If Any APIs were used, then they must be represented in the shipping options. If there is a mismatch, remove all shipping options.
                    if (znodeShoppingCart.CarrierResponseDictionary.Keys.Count != carriersWithItemsDictionary.Keys.Count)
                    {
                        listwithRates = new List<ShippingModel>();
                        try
                        {
                            ZnodeLogging.LogMessage($"Shipping Carrier Mismatch. Required carrier was not present on checkout. Shopping Cart Carrier Keys:{String.Join(",", znodeShoppingCart.CarrierResponseDictionary.Keys)}. Carrier Item Dict Keys:{String.Join(",", carriersWithItemsDictionary.Keys)}. Check logs for shipper-specific exception.", "Shipping", TraceLevel.Error);
                        }
                        catch (Exception)
                        {
                            ZnodeLogging.LogMessage($"Shipping Carrier Mismatch. Required carrier was not present on checkout. Check logs for shipper-specific exception.", "Shipping", TraceLevel.Error);
                        }
                    }

                    //CUSTOMIZATION: Sorting and filtering shipping options based on display order. Take all of top <takeCount> and then only 2 of takeCount+
                    if (listwithRates.Count > 0 && displayOrderTakeValue != null && displayOrderTakeAdditional != null)
                    {
                        int takeCount = 0;
                        int.TryParse(displayOrderTakeValue.AttributeValue, out takeCount);
                        int takeAdditionalCount = 0;
                        int.TryParse(displayOrderTakeAdditional.AttributeValue, out takeAdditionalCount);
                        if (takeCount > 0)
                        {
                            Dictionary<string, List<ShippingModel>> carrierModels = listwithRates.GroupBy(o => o.ClassName).ToDictionary(x => x.Key, x => x.Select(a => a).ToList());
                            foreach (KeyValuePair<string, List<ShippingModel>> kvp in carrierModels)
                            {
                                List<ShippingModel> carrierMethods = kvp.Value;
                                List<int> filteredItemIds = carrierMethods.Where(o => o.DisplayOrder > takeCount).OrderBy(o => o.ShippingRate).Take(takeAdditionalCount).Select(o => o.ShippingId).ToList();
                                listwithRates.RemoveAll(o => o.DisplayOrder > takeCount && !filteredItemIds.Contains(o.ShippingId) && o.ClassName == kvp.Key);
                            }
                        }

                    }



                    if (upslist.Count > 0)
                    {
                        ZnodeShippingManager manager = null;
                        ZnodeGenericCollection<IZnodeShippingsType> shippingTypes = new ZnodeGenericCollection<IZnodeShippingsType>();
                        List<ZnodeShippingBag> shippingbagList = new List<ZnodeShippingBag>();
                        foreach (ShippingModel item in upslist)
                        {
                            model.Shipping.ShippingId = item.ShippingId;
                            model.Shipping.ShippingName = item.ShippingCode;
                            model.Shipping.ShippingCountryCode = string.IsNullOrEmpty(countryCode) ? item.DestinationCountryCode : countryCode;
                            znodeShoppingCart.Shipping = ShippingMap.ToZnodeShipping(model.Shipping);
                            manager = new ZnodeShippingManager(znodeShoppingCart, true, shippingTypes, shippingbagList);
                        }

                        List<ShippingModel> ratelist = manager.GetShippingEstimateRate(znodeShoppingCart, model, countryCode, shippingbagList);
                        ZnodeLogging.LogMessage("Rate list:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, ratelist?.Count());
                        upslist = upslist.Join(ratelist, r => r.ShippingCode, p => p.ShippingCode, (ulist, rlist) => ulist).ToList();

                        upslist?.ForEach(f =>
                        {
                            ShippingModel shippingModel = ratelist?.Where(w => w.ShippingCode == f.ShippingCode && !Equals(w.ShippingRate, 0))?.FirstOrDefault();

                            if (HelperUtility.IsNotNull(shippingModel) && shippingModel?.ShippingRate > 0)
                            {
                                f.EstimateDate = shippingModel.EstimateDate;
                                f.ShippingRate = znodeShoppingCart.CustomShippingCost ?? shippingModel.ShippingRate;
                                f.ShippingRateWithoutDiscount = shippingModel?.ShippingRateWithoutDiscount > 0 ? shippingModel?.ShippingRateWithoutDiscount : 0;
                            }

                        });

                        listwithRates.AddRange(upslist);
                    }
                    return new ShippingListModel { ShippingList = listwithRates.OrderBy(o => o.DisplayOrder).ToList() };
                }
                else
                    return new ShippingListModel { ShippingList = new List<ShippingModel>() };
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage(Admin_Resources.ErrorShippingOptionGet, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error, ex);
                return new ShippingListModel { ShippingList = listwithRates?.Count() > 0 ? listwithRates.OrderBy(o => o.DisplayOrder).ToList() : new List<ShippingModel>() };
            }
        }

        public WarehouseModel GetShippingWareHouseAddress(string warehouseCode)
        {
            WarehouseListModel ware = _warehouseService.GetWarehouseList(null, new FilterCollection(), null, null);
            return ware.WarehouseList.FirstOrDefault(o => o.WarehouseCode == warehouseCode);
        }

        private void AppendWarehouseInformation(ShoppingCartModel model, CustomShoppingCart znodeShoppingCart)
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
            else if (model.ShippingAddress != null && model.ShippingAddress.PostalCode != null)
            {
                postalCodeWarehouse = warehouseZipcodeList.FirstOrDefault(o => o.Value == model.ShippingAddress.PostalCode);
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

                // warehouses have a minimum rate for local shipping. This rate is added to the custom shopping cart
                if (flatRateWarehouse != null && flatRateWarehouse.Value != null)
                {
                    decimal flatRate = 0;
                    decimal.TryParse(flatRateWarehouse.Value, out flatRate);
                    znodeShoppingCart.MyWarehouseFlatRate = flatRate;

                }

                var accountId = model.Payment?.ShippingAddress?.AccountId ?? model.ShippingAddress?.AccountId;
                if (accountId == 0)
                {
                    try
                    {
                        var addressId = model.Payment?.ShippingAddress?.AddressId ?? model.ShippingAddress?.AddressId;
                        var address1 = model.Payment?.ShippingAddress?.Address1 ?? model.ShippingAddress?.Address1;
                        if (address1 != null || addressId != null)
                        {
                            var _addressRepository = new ZnodeRepository<ZnodeAddress>();

                            IZnodeRepository<ZnodeAccountAddress> _addressAccountRepository = new ZnodeRepository<ZnodeAccountAddress>();
                            IZnodeRepository<ZnodeUserAddress> _addressUserRepository = new ZnodeRepository<ZnodeUserAddress>();
                            accountId = (from p in _addressRepository.Table
                                         join q in _addressAccountRepository.Table
                                             on p.AddressId equals q.AddressId
                                         join u in _addressUserRepository.Table
                                             on q.AddressId equals u.AddressId
                                         where u.UserId == model.UserId && (p.AddressId == addressId || p.Address1 == address1)
                                         select q.AccountId /*p.ZnodeAccountAddresses.FirstOrDefault() == null? 0: p.ZnodeAccountAddresses.FirstOrDefault().AccountId*/).FirstOrDefault();
                        }

                        if (accountId == 0)
                        {
                            IZnodeRepository<ZnodeUser> _userRepository = new ZnodeRepository<ZnodeUser>();
                            IZnodeRepository<AspNetUser> _aspNetUserRepository = new ZnodeRepository<AspNetUser>();
                            IZnodeRepository<AspNetZnodeUser> _aspNetZnodeUserRepository = new ZnodeRepository<AspNetZnodeUser>();

                            accountId = (from user in _userRepository.Table
                                         join aspNetUser in _aspNetUserRepository.Table on user.AspNetUserId equals aspNetUser.Id
                                         join aspNetZnodeUser in _aspNetZnodeUserRepository.Table on aspNetUser.UserName equals
                                             aspNetZnodeUser.AspNetZnodeUserId
                                         where user.UserId == model.UserId
                                         select user.AccountId).FirstOrDefault();
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex);
                    }
                }
                GlobalAttributeEntityDetailsModel attributesEntity = accountId > 0 ? _attributeGroupEntityService.GetEntityAttributeDetails(accountId.Value, ZnodeConstant.Account) : new GlobalAttributeEntityDetailsModel { Groups = new List<GlobalAttributeGroupModel>(), Attributes = new List<GlobalAttributeValuesModel>() };
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

            }

            /// end custization
        }

        public override ShoppingCartModel Calculate(ShoppingCartModel shoppingCartModel)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            if (IsNull(shoppingCartModel))
                throw new ZnodeException(ErrorCodes.NullModel, Admin_Resources.ShoppingCartModelNotNull);

            //remove duplicate coupons with same name but different cases.
            ZnodeLogging.LogMessage("Coupons details:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, shoppingCartModel.Coupons);

            RemoveDuplicateCoupons(shoppingCartModel.Coupons);

            SetShippingStateCode(shoppingCartModel);

            // customization
            CustomShoppingCart znodeShoppingCart = _customShoppingCartMap.ToZnodeShoppingCart(shoppingCartModel);
            AppendWarehouseInformation(shoppingCartModel, znodeShoppingCart);
            // end customization
            SetAllowTerritories(znodeShoppingCart, shoppingCartModel.BillingAddress);
            znodeShoppingCart.PublishStateId = znodeShoppingCart.PublishStateId == 0 ? shoppingCartModel.PublishStateId : znodeShoppingCart.PublishStateId;
            znodeShoppingCart.Shipping2Carrier = (string)shoppingCartModel.Shipping.Custom1;
            znodeShoppingCart.Shipping2Method = (string)shoppingCartModel.Shipping.Custom2;
            znodeShoppingCart.Calculate(znodeShoppingCart.ProfileId, shoppingCartModel.IsCalculateTaxAndShipping);
            //znodeShoppingCart.OrderLevelShipping = list.ShippingList[0].ShippingRate.Value;
            ShoppingCartModel calculatedModel = _shoppingCartMap.ToModel(znodeShoppingCart, GetService<IImageHelper>(new ZnodeNamedParameter("PortalId", znodeShoppingCart.PortalId.GetValueOrDefault())));
            calculatedModel.ShippingAddress = shoppingCartModel.ShippingAddress;
            calculatedModel.BillingAddress = shoppingCartModel.BillingAddress;
            calculatedModel.CurrencyCode = shoppingCartModel.CurrencyCode;
            calculatedModel.CultureCode = shoppingCartModel.CultureCode;



            if (IsNotNull(calculatedModel) && IsNotNull(calculatedModel.ShoppingCartItems))
            {
                List<string> skus = calculatedModel.ShoppingCartItems?.Select(x => x.SKU).ToList();
                List<ZnodePimDownloadableProduct> lstDownloadableProducts = new ZnodeRepository<ZnodePimDownloadableProduct>().Table.Where(x => skus.Contains(x.SKU)).ToList();

                //Get the discount amour of each cartline item.
                foreach (ShoppingCartItemModel shoppingCartItem in calculatedModel.ShoppingCartItems)
                {
                    List<ShoppingCartItemModel> cartItem = shoppingCartModel.ShoppingCartItems.Where(product => Equals(product.ProductId, shoppingCartItem.ProductId))?.ToList();
                    decimal modelCartItemDiscountAmount = IsNotNull(cartItem.FirstOrDefault()) ? cartItem.FirstOrDefault().ProductDiscountAmount : 0;

                    if (shoppingCartItem.ProductDiscountAmount <= 0.0M && modelCartItemDiscountAmount > 0.0M)
                        shoppingCartItem.ProductDiscountAmount = shoppingCartModel.ShoppingCartItems.FirstOrDefault(product => Equals(product.ProductId, shoppingCartItem.ProductId)).ProductDiscountAmount;
                    shoppingCartItem.CurrencyCode = shoppingCartModel.CurrencyCode;
                    shoppingCartItem.CultureCode = shoppingCartModel.CultureCode;
                    if (HelperUtility.IsNotNull(shoppingCartModel.OmsOrderId) && shoppingCartModel.OmsOrderId > 0)
                    {
                        bool IsDownloadableSKU = lstDownloadableProducts.Any(x => x.SKU == shoppingCartItem.SKU);
                        if (IsDownloadableSKU)
                        {
                            int? parentOmsOrderLineItemsId = _orderLineItemRepository.Table.FirstOrDefault(x => x.OmsOrderLineItemsId == shoppingCartItem.OmsOrderLineItemsId && x.IsActive).ParentOmsOrderLineItemsId;
                            if (parentOmsOrderLineItemsId > 0)
                            {
                                shoppingCartItem.DownloadableProductKey = GetProductKey(shoppingCartItem.SKU, Convert.ToInt32(parentOmsOrderLineItemsId));
                            }
                        }
                    }
                    shoppingCartItem.CultureCode = shoppingCartModel.CultureCode;
                }

                bool? isTrackInventory = shoppingCartModel.ShoppingCartItems?.FirstOrDefault()?.TrackInventory;

                if (IsNotNull(isTrackInventory))
                    calculatedModel.ShoppingCartItems?.ForEach(item => { item.TrackInventory = isTrackInventory.GetValueOrDefault(); });

            }
            //to set order over due amount
            if (IsNotNull(shoppingCartModel.OmsOrderId) && shoppingCartModel.OmsOrderId > 0)
                SetOrderOverDueAmount(calculatedModel);
            ZnodeLogging.LogMessage("Oms Quote Id:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, shoppingCartModel.OmsQuoteId);
            if (shoppingCartModel.OmsQuoteId > 0)
            {
                calculatedModel.OmsQuoteId = shoppingCartModel.OmsQuoteId;
                calculatedModel.OrderStatus = shoppingCartModel.OrderStatus;
            }

            ZnodeLogging.LogMessage("Execution done:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            return calculatedModel;
        }

        private string GetProductKey(string sku, int omsOrderLineItemsId)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            ZnodeLogging.LogMessage("Input Parameter:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { sku = sku, omsOrderLineItemsId = omsOrderLineItemsId });
            string productKey = string.Empty;
            IZnodeRepository<ZnodePimDownloadableProduct> _pimDownloadableProduct = new ZnodeRepository<ZnodePimDownloadableProduct>();
            IZnodeRepository<ZnodePimDownloadableProductKey> _pimDownloadableProductKey = new ZnodeRepository<ZnodePimDownloadableProductKey>();
            IZnodeRepository<ZnodeOmsDownloadableProductKey> _omsDownloadableProductKey = new ZnodeRepository<ZnodeOmsDownloadableProductKey>();

            var productKeyDetails =
                from omsDownloadableProductKey in _omsDownloadableProductKey.Table
                join pimDownloadableProductKey in _pimDownloadableProductKey.Table on omsDownloadableProductKey.PimDownloadableProductKeyId equals pimDownloadableProductKey.PimDownloadableProductKeyId
                join pimDownloadableProduct in _pimDownloadableProduct.Table on pimDownloadableProductKey.PimDownloadableProductId equals pimDownloadableProduct.PimDownloadableProductId
                where pimDownloadableProduct.SKU == sku && pimDownloadableProductKey.IsUsed && omsDownloadableProductKey.OmsOrderLineItemsId == omsOrderLineItemsId
                select new { keys = pimDownloadableProductKey.DownloadableProductKey }.keys;

            productKey = string.Join(",", productKeyDetails);
            ZnodeLogging.LogMessage("Product Key:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, productKey);
            return productKey;
        }

       // overriding AddToCartProduct to add order in multiple(QtyPerShipUnit) customization
        public override AddToCartModel AddToCartProduct(AddToCartModel shoppingCart)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            if (HelperUtility.IsNull(shoppingCart))
                throw new ZnodeException(ErrorCodes.NullModel, Admin_Resources.AddToCartModelNotNull);

            PublishProductModel publishProduct = GetPublishProductCustom(shoppingCart);

            var qtyAttributeValue = publishProduct?.Attributes?.Where(x => x.AttributeCode == "QtyPerShipUnit")?.FirstOrDefault()?.AttributeValues;
            var priceUnitDescription = publishProduct?.Attributes?.Where(x => x.AttributeCode == "PriceUnit")?.FirstOrDefault()?.SelectValues[0]?.Value;
            var QtyPerShipUnitValue = !string.IsNullOrEmpty(qtyAttributeValue) && string.Equals(priceUnitDescription, "Each", StringComparison.OrdinalIgnoreCase) ? Convert.ToDecimal(qtyAttributeValue) : 1;
            //need the attribute  value of "PriceUnit"  to use on cartitems and orderitems, using Custom3 to pass this value
            if (!Equals(shoppingCart.ShoppingCartItems[0], null))
            {
                shoppingCart.ShoppingCartItems[0].Custom3 = priceUnitDescription;
            }

            var qty = !string.IsNullOrWhiteSpace(shoppingCart?.ShoppingCartItems[0]?.ExternalId) ? shoppingCart.ShoppingCartItems[0].Quantity : shoppingCart.Quantity;

            if (QtyPerShipUnitValue > 0 && qty % QtyPerShipUnitValue != 0)
            {
                //  throw new ZnodeException(ErrorCodes.MinMaxQtyError, string.Format(Admin_Resources.AddToCartQtyPerShipUnit, QtyPerShipUnitValue));
                throw new ZnodeException(ErrorCodes.MinMaxQtyError, string.Format("AddToCartQtyPerShipUnit", QtyPerShipUnitValue));
            }

            AddToCartModel cartModel = GetService<IZnodeShoppingCart>().SaveAddToCartData(shoppingCart, DefaultGlobalConfigSettingHelper.DefaultGroupIdProductAttribute, DefaultGlobalConfigSettingHelper.DefaultGroupIdPersonalizeAttribute);

            publishProduct = GetPublishProduct(shoppingCart);

            if (HelperUtility.IsNotNull(publishProduct))
                shoppingCart.ShoppingCartItems.FirstOrDefault().Product = publishProduct;
            ZnodeLogging.LogMessage("PublishProduct model details:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { PublishProductId = publishProduct?.PublishProductId });
            ZnodeLogging.LogMessage("Execution done:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            return cartModel;
        }

        public PublishProductModel GetPublishProductCustom(AddToCartModel shoppingCart)
        {
            ZnodeLogging.LogMessage("Execution started:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);
            int? catlogVersionId = GetCatalogVersionId(shoppingCart.PublishedCatalogId);

            ShoppingCartItemModel lineItem = shoppingCart.ShoppingCartItems.FirstOrDefault();

            string sku = string.IsNullOrEmpty(lineItem.ConfigurableProductSKUs) ? lineItem.SKU : lineItem.ConfigurableProductSKUs;
            ZnodeLogging.LogMessage("Parameter:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Verbose, new { catlogVersionId = catlogVersionId, ProductId = lineItem.ProductId, sku = sku });

            ZnodeLogging.LogMessage("Execution done:", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Info);

            var localeId = !string.IsNullOrWhiteSpace(shoppingCart?.ShoppingCartItems[0]?.ExternalId) ? GetDefaultLocaleId() : shoppingCart.LocaleId;
           // return publishProductHelper.GetPublishProductBySKU(sku, shoppingCart.PublishedCatalogId, localeId, catlogVersionId)?.ToModel<PublishProductModel>();
            return GetService<IPublishedProductDataService>().GetPublishProductBySKU(sku, shoppingCart.PublishedCatalogId, localeId, catlogVersionId)?.ToModel<PublishProductModel>();
        }

        //To get shopping cart count
        // OVERRIDING THIS FUNCTION SO THAT THE CART COUNT RETURNED IS THE LINE COUNT RATHER THAN THE TOTAL NUMBER OF ITEMS IN THE CART.

        public override string GetCartCount(CartParameterModel cartParameterModel)
        {
            //Check if cookieMappingId is null or 0.
            if ((string.IsNullOrEmpty(cartParameterModel.CookieMappingId) || cartParameterModel.CookieId == 0) && cartParameterModel.UserId > 0)
            {
                List<ZnodeOmsCookieMapping> cookieMappings = orderHelper.GetCookieMappingList(cartParameterModel);
                cartParameterModel.CookieId = Convert.ToInt32(cookieMappings?.FirstOrDefault()?.OmsCookieMappingId);
                cartParameterModel.CookieMappingId = new ZnodeEncryption().EncryptData(cartParameterModel.CookieId.ToString());
            }

            int mappingId = !string.IsNullOrEmpty(cartParameterModel.CookieMappingId) ? Convert.ToInt32(new ZnodeEncryption().DecryptData(cartParameterModel.CookieMappingId)) : 0;

            if (mappingId > 0)

            {
                int bundleProductTypeId = _lineItemRelationshipType.Table.FirstOrDefault(x => x.Name == "Bundles").OrderLineItemRelationshipTypeId;

                var cartItems = (from cart in _omsSavedRepository.Table
                                 join item in _savedCartLineItemService.Table on cart.OmsSavedCartId equals item.OmsSavedCartId
                                 where cart.OmsCookieMappingId == mappingId
                                 select item);

                decimal cartItemCount = Convert.ToDecimal(cartItems?.Where(item => item.OrderLineItemRelationshipTypeId != _lineItemRelationshipType.Table.FirstOrDefault(x => x.Name == "AddOns").OrderLineItemRelationshipTypeId && item.OrderLineItemRelationshipTypeId != null && item.OrderLineItemRelationshipTypeId != bundleProductTypeId)?.Count());

                cartItemCount = Math.Round(cartItemCount + GetBundleProductCount(cartItems, bundleProductTypeId));

                return Convert.ToString(cartItemCount);
            }
            return string.Empty;
        }

        /// <summary>
        /// Returns Bundle Product count in cart
        /// </summary>
        /// <param name="cartItems"></param>
        /// <param name="bundleProductTypeId"></param>
        /// <returns></returns>
        private decimal GetBundleProductCount(IQueryable<ZnodeOmsSavedCartLineItem> cartItems, int bundleProductTypeId)
        {
            var bundleProductChildItemList = cartItems?.Where(item => item.OrderLineItemRelationshipTypeId == bundleProductTypeId);

            decimal bundleProductQuantity = Convert.ToDecimal((from item in cartItems
                                                               join bundleItem in bundleProductChildItemList on item.OmsSavedCartLineItemId equals bundleItem.ParentOmsSavedCartLineItemId
                                                               where item.OrderLineItemRelationshipTypeId == null
                                                               select item)?.Distinct()?.Sum(x => x.Quantity));

            return bundleProductQuantity;
        }

        #endregion

    }
}
