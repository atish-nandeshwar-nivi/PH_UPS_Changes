using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Znode.Api.Client.Custom;
using Znode.Api.Model.Custom;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Models;
using Znode.Engine.Core.ViewModels;
using Znode.Engine.Exceptions;
using Znode.Engine.klaviyo.Models;
using Znode.Engine.Klaviyo.IClient;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Klaviyo.Helper;
using Znode.Libraries.Resources;
using Znode.Sample.Api.Model.Responses;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;

namespace Znode.Webstore.Custom.Agents
{
    public class PHCartAgent : CartAgent, ICartAgent
    {
        #region Private member
        private readonly IShoppingCartClient _shoppingCartsClient;
        private readonly IPublishProductClient _publishProductClient;
        private readonly IAccountQuoteClient _accountQuoteClient;
        private readonly IUserClient _userClient;
        private static List<UpdatedProductQuantityModel> updatedProducts = new List<UpdatedProductQuantityModel>();
        private readonly IGlobalAttributeEntityClient _globalAttributesEntityClient;

        #endregion

        #region Constructor
        public PHCartAgent(IShoppingCartClient shoppingCartsClient, IPublishProductClient publishProductClient, IAccountQuoteClient accountQuoteClient, IUserClient userClient, IGlobalAttributeEntityClient globalAttributeEntiyClient)
        : base(shoppingCartsClient, publishProductClient, accountQuoteClient, userClient)
        {
            _shoppingCartsClient = GetClient<IShoppingCartClient>(shoppingCartsClient);
            _publishProductClient = GetClient<IPublishProductClient>(publishProductClient);
            _accountQuoteClient = GetClient<IAccountQuoteClient>(accountQuoteClient);
            _userClient = GetClient<IUserClient>(userClient);
            _globalAttributesEntityClient = GetClient<IGlobalAttributeEntityClient>(globalAttributeEntiyClient);
        }
        #endregion

        #region Public methods

        public bool UpdateOptionalFees(string omsSavedCardLineItemIds, string optionalfeesIds)
        {
            return ((PHShoppingCartClient)_shoppingCartsClient).UpdateOptionalFees(omsSavedCardLineItemIds, optionalfeesIds);
        }
       

        //Calculate shipping.
        public CartViewModel CustomCalculateShipping(int shippingOptionId, int shippingOption2Id, int shippingOption3Id, int shippingAddressId, string shippingCode, string additionalInstruction = "")//Atish ups
        {
            ShoppingCartModel cartModel = IsShoppingCartInSession(GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey)) ?
                        GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) : GetCartFromCookie();

            if (IsNull(cartModel?.Shipping))
            {
                cartModel.Shipping = new OrderShippingModel();
            }

            //bind shipping related data to ShoppingCartModel.
            cartModel.AdditionalInstructions = additionalInstruction;
            cartModel.Shipping.ShippingId = shippingOptionId > 0 ? shippingOptionId : cartModel.Shipping.ShippingId;
            cartModel.ShippingId = shippingOptionId > 0 ? shippingOptionId : cartModel.ShippingId;
            cartModel.Shipping.Custom1 = shippingOption2Id.ToString();
            cartModel.Shipping.Custom3 = shippingOption3Id.ToString();//Atish ups
            cartModel.Shipping.ResponseCode = (IsNotNull(shippingCode) && shippingCode != string.Empty) ? shippingCode : cartModel.Shipping.ResponseCode;
            cartModel.ShippingAddress = IsNotNull(cartModel?.ShippingAddress) ? cartModel.ShippingAddress : DependencyResolver.Current.GetService<IUserAgent>().GetAddressList()?.AddressList?.FirstOrDefault(x => x.AddressId == shippingAddressId)?.ToModel<AddressModel>();
            cartModel.Shipping.ShippingCountryCode = IsNull(cartModel?.ShippingAddress?.CountryName) ? "us" : cartModel.ShippingAddress.CountryName;
            //Calculate cart.
            CartViewModel cartViewModel = CalculateCart(cartModel, true)?.ToViewModel<CartViewModel>();
            cartViewModel.AdditionalInstruction = cartModel.AdditionalInstructions;
            cartModel.Shipping.ShippingDiscount = Convert.ToDecimal(cartViewModel?.Shipping?.ShippingDiscount);
            cartModel.ShippingCost = cartViewModel.ShippingCost;
            cartModel.TaxCost = cartViewModel.TaxCost;
            cartModel.Total = cartViewModel.Total;
            SaveInSession(WebStoreConstants.CartModelSessionKey, cartModel);

            PortalApprovalModel portalApprovalModel = GetClient<PortalClient>().GetPortalApproverDetailsById(PortalAgent.CurrentPortal.PortalId);
            cartViewModel.ApprovalType = portalApprovalModel?.PortalApprovalTypeName;

            if (IsNotNull(cartViewModel))
            {
                SetPortalApprovalType(cartViewModel);

                cartViewModel.IsSinglePageCheckout = PortalAgent.CurrentPortal.IsEnableSinglePageCheckout;

                if (!string.IsNullOrEmpty(cartViewModel.ShippingResponseErrorMessage))
                {
                    cartViewModel.HasError = true;
                    cartViewModel.IsValidShippingSetting = false;
                    cartViewModel.ErrorMessage = cartViewModel.ShippingResponseErrorMessage;
                }
                else if (cartViewModel.ShoppingCartItems.Where(w => w.IsAllowedTerritories == false).ToList().Count > 0)
                {
                    cartViewModel.HasError = true;
                }

                //Get User details from session.
                UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);

                if (cartModel.OmsQuoteId > 0)
                    cartViewModel.IsLastApprover = _accountQuoteClient.IsLastApprover(cartModel.OmsQuoteId);
                else
                    cartViewModel.IsLastApprover = cartModel?.IsLastApprover ?? false;

                cartViewModel.IsLevelApprovedOrRejected = cartModel?.IsLevelApprovedOrRejected ?? false;
                cartViewModel.OmsQuoteId = cartModel?.OmsQuoteId ?? 0;

                //Bind User details to ShoppingCartModel.
                cartViewModel.CustomerPaymentGUID = userViewModel?.CustomerPaymentGUID;
                cartViewModel.UserId = IsNotNull(userViewModel) ? userViewModel.UserId : 0;
                cartViewModel.OrderStatus = cartModel.OrderStatus;
                cartViewModel.BudgetAmount = (userViewModel?.BudgetAmount).GetValueOrDefault();
                cartViewModel.PermissionCode = userViewModel?.PermissionCode;
                cartViewModel.RoleName = userViewModel?.RoleName;

                if (IsNotNull(cartViewModel?.ShoppingCartItems) && cartViewModel.ShoppingCartItems.Count > 0)
                {
                    cartViewModel.ShoppingCartItems = cartViewModel.ShoppingCartItems.OrderBy(c => c.GroupSequence).ToList();
                }

                if (cartModel.UserId > 0)
                {
                    cartViewModel.IsRequireApprovalRouting = IsRequireApprovalRouting('0', cartViewModel.Total.Value);
                }
            }
            return cartViewModel;
        }

        //public virtual CartViewModel GetCart(bool isCalculateTaxAndShipping = true, bool isCalculateCart = true, bool isCheckout = false)
        //{
        //    ShoppingCartModel shoppingCartModel = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
        //                             GetCartFromCookie();

        //    if (IsNull(shoppingCartModel))
        //    {
        //        return new CartViewModel()
        //        {
        //            HasError = true,
        //            ErrorMessage = WebStore_Resources.OutofStockMessage
        //        };
        //    }

        //    if (IsNotNull(shoppingCartModel) && (IsNull(shoppingCartModel?.ShoppingCartItems) || shoppingCartModel?.ShoppingCartItems?.Count == 0))
        //    {
        //        var shoppingartItems = GetCartFromCookie()?.ShoppingCartItems;
        //        shoppingCartModel.ShoppingCartItems = (shoppingartItems?.Count > 0) ? shoppingartItems : new List<ShoppingCartItemModel>(); ;
        //    }

        //    if (shoppingCartModel.ShoppingCartItems?.Count == 0)
        //    {
        //        return new CartViewModel();
        //    }

        //    if (!isCheckout)
        //    {
        //        //Remove Shipping and Tax calculation From Cart.
        //        RemoveShippingTaxFromCart(shoppingCartModel);

        //        //To remove the tax getting calculated when we come back from checkout page to cart page
        //        shoppingCartModel.ShippingAddress = new AddressModel();
        //        shoppingCartModel.ShippingAddress.CountryName = "us";
        //        shoppingCartModel.ShippingAddress.PostalCode = GetFromSession<String>(ZnodeConstant.ShippingEstimatedZipCode);
        //        shoppingCartModel.CultureCode = PortalAgent.CurrentPortal.CultureCode;
        //        shoppingCartModel.CurrencyCode = PortalAgent.CurrentPortal.CurrencyCode;
        //    }

        //    //Calculate cart
        //    shoppingCartModel = CalculateCart(shoppingCartModel, isCalculateTaxAndShipping, isCalculateCart);

        //    SaveInSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey, shoppingCartModel);
        //    //Set currency details.
        //    var cartViewModel = SetCartCurrency(shoppingCartModel);
        //    if (isCheckout)
        //    {
        //        cartViewModel.TaxCost = shoppingCartModel.TaxCost;
        //    }
        //    return cartViewModel;
        //}

        //Calculate cart.
        public override ShoppingCartModel CalculateCart(ShoppingCartModel shoppingCartModel, bool isCalculateTaxAndShipping = true, bool isCalculateCart = true)
        {
            ShoppingCartModel model = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey);
            if (IsNotNull(shoppingCartModel))
            {
                shoppingCartModel.LocaleId = PortalAgent.LocaleId;
                shoppingCartModel.IsCalculateTaxAndShipping = isCalculateTaxAndShipping;
                string billingEmail = shoppingCartModel.BillingEmail;
                int shippingId = shoppingCartModel.ShippingId;
                int billingAddressId = shoppingCartModel.BillingAddressId;
                int shippingAddressId = shoppingCartModel.ShippingAddressId;
                int selectedAccountUserId = shoppingCartModel.SelectedAccountUserId;
                shoppingCartModel.ProfileId = Helper.GetProfileId();
                if (isCalculateCart)
                {
                    ShoppingCartModel oldShoppingCartModel = shoppingCartModel;
                    shoppingCartModel = _shoppingCartsClient.Calculate(shoppingCartModel);
                    shoppingCartModel.ShippingOptions = oldShoppingCartModel.ShippingOptions;
                    //Bind required data to ShoppingCartModel.
                    BindShoppingCartData(shoppingCartModel, billingEmail, shippingId, shippingAddressId, billingAddressId, selectedAccountUserId);
                    //MapQuantityOnHandAndSeoName(oldShoppingCartModel, shoppingCartModel);

                    ////set optional fees to jobname
                    var ids = string.Join(",", shoppingCartModel.ShoppingCartItems.Select(x => x.OmsSavedcartLineItemId).ToList());
                    shoppingCartModel.JobName = ((PHShoppingCartClient)_shoppingCartsClient).GetOptionalFees(ids);
                    ////
                }

            }

            SaveInSession(WebStoreConstants.CartModelSessionKey, shoppingCartModel);
            return shoppingCartModel;
        }

        //Check whether approval routing is required for the current user quote.
        protected override bool IsRequireApprovalRouting(int quoteId, decimal quoteTotal)
        {
            bool IsRequireApprovalRouting = false;

            UserApproverListViewModel model = GetUserApproverList(0, true);
            if (model?.UserApprover?.Count > 0)
            {
                int firstLevelOrder = model.UserApprover.Min(x => x.ApproverOrder);
                decimal? firstLevelBudgetStart = model.UserApprover.Where(x => x.ApproverOrder == firstLevelOrder)?.Select(x => x.FromBudgetAmount)?.FirstOrDefault();
                if (IsNotNull(firstLevelBudgetStart) && quoteTotal > firstLevelBudgetStart)
                {
                    IsRequireApprovalRouting = true;
                }
            }
            return IsRequireApprovalRouting;
        }

        protected override void BindShoppingCartData(ShoppingCartModel shoppingCartModel, string billingEmail, int shippingId, int shippingAddressId, int billingAddressId, int selectedAccountUserId)
        {
            shoppingCartModel.BillingEmail = billingEmail;
            shoppingCartModel.ShippingId = shippingId;
            shoppingCartModel.ShippingAddressId = shippingAddressId;
            shoppingCartModel.BillingAddressId = billingAddressId;
            shoppingCartModel.SelectedAccountUserId = selectedAccountUserId;
        }

        //CUSTOMIZATION: added this function to send the IDs of special fees into the client
        public virtual AddToCartViewModel UpdateQuantityOfCartItemWithFees(string guid, string quantity, int productId, string specialfeeids)
        {
            // Get shopping cart from session.
            ShoppingCartModel shoppingCart = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey);
            decimal newQuantity = ModifyQuantityValue(quantity);

            if (IsNotNull(shoppingCart))
            {
                //Update quantity and update the cart.
                if (productId > 0)
                {
                    shoppingCart.ShoppingCartItems?.Where(w => w.ExternalId == guid)?.Select(x => x.GroupProducts?.Where(y => y.ProductId == productId)?.Select(z => { z.Quantity = newQuantity; return z; })?.FirstOrDefault()).ToList();
                }
                else
                {
                    shoppingCart.ShoppingCartItems?.Where(w => w.ExternalId == guid)?.Select(y => { y.Quantity = Convert.ToDecimal(newQuantity.ToInventoryRoundOff()); return y; }).ToList();
                }

                ShoppingCartItemModel shoppingCartItemModel = shoppingCart.ShoppingCartItems?.FirstOrDefault(w => w.ExternalId == guid);
                shoppingCartItemModel?.AssociatedAddOnProducts?.ForEach(x => x.Quantity = Convert.ToDecimal(newQuantity.ToInventoryRoundOff()));
                if (IsNotNull(shoppingCartItemModel))
                {
                    AddToCartViewModel addToCartViewModel = new AddToCartViewModel();
                    addToCartViewModel.CookieMappingId = GetFromCookie(WebStoreConstants.CartCookieKey);
                    addToCartViewModel.GroupId = shoppingCartItemModel.GroupId;
                    addToCartViewModel.AddOnProductSKUs = shoppingCartItemModel.AddOnProductSKUs;
                    addToCartViewModel.AutoAddonSKUs = shoppingCartItemModel.AutoAddonSKUs;
                    addToCartViewModel.SKU = shoppingCartItemModel.SKU;
                    addToCartViewModel.ParentOmsSavedcartLineItemId = shoppingCartItemModel.ParentOmsSavedcartLineItemId;
                    addToCartViewModel.AssociatedAddOnProducts = shoppingCartItemModel.AssociatedAddOnProducts;

                    // Customization: adding fees to Custom1
                    if (specialfeeids != null && specialfeeids != string.Empty)
                    {
                        List<int> list = specialfeeids.Split('|').Select(int.Parse).ToList();
                        if (list != null)
                        {
                            GlobalAttributeEntityDetailsModel attributesEntity = _globalAttributesEntityClient.GetEntityAttributeDetails(shoppingCart.PortalId, ZnodeConstant.Store);
                            GlobalAttributeGroupModel SpecialDeliveryGroup = attributesEntity.Groups.FirstOrDefault(x => x.GroupCode == "SpecialDeliveryFees");
                            List<GlobalAttributeValuesModel> attributeList = attributesEntity?.Attributes.Where(x => x.GlobalAttributeGroupId == SpecialDeliveryGroup?.GlobalAttributeGroupId).GroupBy(p => p.GlobalAttributeId).Select(g => g.First()).ToList();
                            Dictionary<int, decimal> SpecialFeesList = new Dictionary<int, decimal>();
                            foreach (int fee in list)
                            {
                                GlobalAttributeValuesModel feeValue = attributeList.FirstOrDefault(o => o.GlobalAttributeId == fee);
                                if (feeValue != null)
                                {
                                    SpecialFeesList[feeValue.GlobalAttributeId] = decimal.Parse(feeValue.AttributeValue);
                                }
                            }
                            if (SpecialFeesList != null && SpecialFeesList.Count > 0)
                            {
                                shoppingCartItemModel.Custom1 = Newtonsoft.Json.JsonConvert.SerializeObject(SpecialFeesList);
                            }
                        }
                    }

                    if (specialfeeids != null && specialfeeids == string.Empty)
                    {
                        shoppingCartItemModel.Custom1 = null;
                    }

                    if (!string.IsNullOrEmpty(shoppingCartItemModel.BundleProductSKUs))
                    {
                        addToCartViewModel.OmsSavedCartLineItemId = shoppingCartItemModel.OmsSavedcartLineItemId;
                        addToCartViewModel.Quantity = shoppingCartItemModel.Quantity;
                        addToCartViewModel.Custom1 = shoppingCartItemModel.Custom1;
                        GetSelectedBundleProductsForAddToCart(addToCartViewModel, shoppingCartItemModel.BundleProductSKUs);
                    }
                    else if (shoppingCartItemModel.GroupProducts?.Count > 0)
                    {
                        shoppingCartItemModel.Quantity = shoppingCartItemModel.GroupProducts.FirstOrDefault().Quantity;

                        addToCartViewModel.ShoppingCartItems.Add(shoppingCartItemModel);
                    }

                    else if (!string.IsNullOrEmpty(shoppingCartItemModel.ConfigurableProductSKUs))
                    {
                        addToCartViewModel.OmsSavedCartLineItemId = shoppingCartItemModel.OmsSavedcartLineItemId;
                        addToCartViewModel.Quantity = shoppingCartItemModel.Quantity;
                        addToCartViewModel.Custom1 = shoppingCartItemModel.Custom1;
                        GetSelectedConfigurableProductsForAddToCart(addToCartViewModel, shoppingCartItemModel.ConfigurableProductSKUs);
                    }

                    else
                    {
                        addToCartViewModel.ShoppingCartItems.Add(shoppingCartItemModel);
                    }

                    AddToCartModel addToCartModel = addToCartViewModel.ToModel<AddToCartModel>();

                    try
                    {
                        addToCartModel.PublishedCatalogId = shoppingCart.PublishedCatalogId;
                        addToCartModel.Coupons = shoppingCart.Coupons;
                        addToCartModel.ZipCode = shoppingCart?.ShippingAddress?.PostalCode;
                        addToCartModel.UserId = shoppingCart.UserId;
                        addToCartModel.PortalId = shoppingCart.PortalId;
                        addToCartModel = _shoppingCartsClient.AddToCartProduct(addToCartModel);
                        addToCartModel.ShippingId = shoppingCart.ShippingId;
                        //Save items updated quantities with sku in list.
                        UpdateQuantityItem(shoppingCartItemModel);

                        // ShoppingCartItems set null to get from cart from database in GetCart
                        shoppingCart.ShoppingCartItems = null;

                        SaveInSession(WebStoreConstants.CartModelSessionKey, shoppingCart);
                        SaveInCookie(WebStoreConstants.CartCookieKey, addToCartModel.CookieMappingId, ZnodeConstant.MinutesInAYear);
                    }
                    catch (ZnodeException ex)
                    {
                        // ShoppingCartItems set null to get from cart from database in GetCart
                        shoppingCart.ShoppingCartItems = null;
                        SaveInSession(WebStoreConstants.CartModelSessionKey, shoppingCart);
                        SaveInCookie(WebStoreConstants.CartCookieKey, addToCartModel.CookieMappingId, ZnodeConstant.MinutesInAYear);

                        switch (ex.ErrorCode)
                        {
                            case ErrorCodes.MinMaxQtyError:
                                return (AddToCartViewModel)GetViewModelWithErrorMessage(addToCartViewModel, ex.ErrorMessage);
                        }
                    }
                }
            }
            return new AddToCartViewModel();
        }

        //Convert string type to decimal for quantity.
        protected override decimal ModifyQuantityValue(string quantity)
        {
            decimal newQuantity = 0;
            if (quantity.Contains(","))
            {
                newQuantity = Convert.ToDecimal((quantity).Replace(",", "."));
            }
            else
            {
                newQuantity = decimal.Parse(quantity, CultureInfo.InvariantCulture);
            }

            return newQuantity;
        }

        protected override void UpdateQuantityItem(ShoppingCartItemModel shoppingCartItemModel)
        {
            UpdatedProductQuantityModel updatedProduct = updatedProducts.FirstOrDefault(x =>
                                    x.SKU == shoppingCartItemModel.SKU &&
                                    x.AddOnProductSKUs == shoppingCartItemModel.AddOnProductSKUs &&
                                    x.AutoAddonSKUs == shoppingCartItemModel.AutoAddonSKUs &&
                                    x.ConfigurableProductSKUs == shoppingCartItemModel.ConfigurableProductSKUs &&
                                    x.BundleProductSKUs == shoppingCartItemModel.BundleProductSKUs &&
                                    x.PersonaliseValuesDetail == shoppingCartItemModel.PersonaliseValuesDetail);

            if (IsNotNull(updatedProduct))
            {
                updatedProduct.Quantity = shoppingCartItemModel.Quantity;
            }
            else
            {
                updatedProducts.Add(new UpdatedProductQuantityModel()
                {
                    SKU = shoppingCartItemModel.SKU,
                    AddOnProductSKUs = shoppingCartItemModel.AddOnProductSKUs,
                    AutoAddonSKUs = shoppingCartItemModel.AutoAddonSKUs,
                    BundleProductSKUs = shoppingCartItemModel.BundleProductSKUs,
                    ConfigurableProductSKUs = shoppingCartItemModel.ConfigurableProductSKUs,
                    Quantity = shoppingCartItemModel.Quantity,
                    PersonaliseValuesDetail = shoppingCartItemModel.PersonaliseValuesDetail,
                    Custom1 = shoppingCartItemModel.Custom1
                });
            }
        }

        //Add product in cart.
        public override AddToCartViewModel AddToCartProduct(AddToCartViewModel cartItem)
        {
            if (IsNotNull(cartItem))
            {
                try
                {
                    cartItem.CookieMappingId = GetFromCookie(WebStoreConstants.CartCookieKey);

                    ShoppingCartModel shoppingCartModel = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey)?.ShoppingCartItems?.Count > 0 ? GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) : new ShoppingCartModel();

                    cartItem.Coupons = shoppingCartModel?.Coupons?.Count > 0 ? shoppingCartModel?.Coupons : new List<CouponModel>();

                    //Create new cart.
                    cartItem = _shoppingCartsClient.AddToCartProduct(GetShoppingCartValues(cartItem)?.ToModel<AddToCartModel>()).ToViewModel<AddToCartViewModel>();

                    SaveInCookie(WebStoreConstants.CartCookieKey, cartItem.CookieMappingId.ToString(), ZnodeConstant.MinutesInAYear);

                    cartItem?.ShoppingCartItems.Where(x => x.SKU == cartItem.SKU).Select(x => { x.ProductType = cartItem.ProductType; return x; })?.ToList();

                    cartItem.ShippingId = (shoppingCartModel?.ShippingId).GetValueOrDefault();

                    shoppingCartModel = MapAddToCartToShoppingCart(cartItem, shoppingCartModel);

                    SaveInSession(WebStoreConstants.CartModelSessionKey, shoppingCartModel);

                    if (cartItem.HasError == false)
                        ClearCartCountFromSession();
                    // Created the task to post the data to klaviyo
                    HttpContext httpContext = HttpContext.Current;

                    Task.Run(() =>
                    {
                        PostDataToKlaviyo(cartItem, httpContext);
                    });
                }
                catch (ZnodeException ex)
                {
                    switch (ex.ErrorCode)
                    {
                        case ErrorCodes.MinMaxQtyError:
                            return (AddToCartViewModel)GetViewModelWithErrorMessage(cartItem, ex.ErrorMessage);
                    }
                }

                return cartItem;

            }
            return null;
        }

        // To post the data to klaviyo
        protected override void PostDataToKlaviyo(AddToCartViewModel cartItem, HttpContext httpContext)
        {
            HttpContext.Current = httpContext;
            IKlaviyoClient _klaviyoClient = GetComponentClient<IKlaviyoClient>(GetService<IKlaviyoClient>());
            KlaviyoProductDetailModel klaviyoProductDetailModel = MapShoppingCartModelToKlaviyoModel(cartItem);
            bool isTrackKlaviyo = _klaviyoClient.TrackKlaviyo(klaviyoProductDetailModel);
        }

        // Map the order model to klaviyo model
        protected override KlaviyoProductDetailModel MapShoppingCartModelToKlaviyoModel(AddToCartViewModel cartItem)
        {
            HttpContext httpContext = HttpContext.Current;
            var Kemail = SessionHelper.GetDataFromSession<string>("EmailForGuest");
            var KFirstName = SessionHelper.GetDataFromSession<string>("FirstNameForGuest");
            if (String.IsNullOrEmpty(Kemail))
            {
                Kemail = Convert.ToString(httpContext.Request.Cookies["KlaviyoEmail"]?.Value);
                KFirstName = Convert.ToString(httpContext.Request.Cookies["KlaviyoFirstName"]?.Value);
            }
            KlaviyoProductDetailModel klaviyoProductDetailModel = new KlaviyoProductDetailModel();
            klaviyoProductDetailModel.OrderLineItems = new List<OrderLineItemDetailsModel>();
            klaviyoProductDetailModel.PortalId = PortalAgent.CurrentPortal.PortalId;
            UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);
            if (httpContext.Request.IsAuthenticated != true)
            {
                klaviyoProductDetailModel.Email = Kemail;
                klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
                klaviyoProductDetailModel.PropertyType = (int)KlaviyoEventType.AddToCartEvent;
                klaviyoProductDetailModel.FirstName = KFirstName;
                klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = cartItem.ShoppingCartItems.FirstOrDefault().ProductName, SKU = cartItem?.SKU, Quantity = cartItem.Quantity, UnitPrice = cartItem.ShoppingCartItems.FirstOrDefault().UnitPrice, Image = cartItem.Image });
                return klaviyoProductDetailModel;
            }
            if (HelperUtility.IsNull(userViewModel))
                userViewModel = _userClient.GetUserDetailById(cartItem.UserId.GetValueOrDefault(), cartItem.PortalId)?.ToViewModel<UserViewModel>();
            klaviyoProductDetailModel.FirstName = userViewModel?.FirstName;
            klaviyoProductDetailModel.LastName = userViewModel?.LastName;
            klaviyoProductDetailModel.Email = userViewModel?.Email;
            klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
            klaviyoProductDetailModel.PropertyType = (int)KlaviyoEventType.AddToCartEvent;
            klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = cartItem.ShoppingCartItems.FirstOrDefault().ProductName, SKU = cartItem?.SKU, Quantity = cartItem.Quantity, UnitPrice = cartItem.ShoppingCartItems.FirstOrDefault().UnitPrice, Image = cartItem.Image });
            return klaviyoProductDetailModel;
        }

        public virtual ShippingOptionListViewModel GetShippingEstimatesFromProfile()
        {
            ShoppingCartModel cart = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
                        GetCartFromCookie();

            if (IsNull(cart))
            {
                return (ShippingOptionListViewModel)GetViewModelWithErrorMessage(new ShippingOptionListViewModel(), WebStore_Resources.ErrorNoCartItemsFound);
            }

            // cart.PublishStateId = DefaultSettingHelper.GetCurrentorDefaultAppType(PortalAgent.CurrentPortal.PublishState);
            cart.PublishStateId = DefaultSettingHelper.GetCurrentOrDefaultAppType(PortalAgent.CurrentPortal.PublishState);
            string zipCode = cart.ShippingAddress.PostalCode;
            UserViewModel userModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey) ?? GetFromSession<UserViewModel>(WebStoreConstants.GuestUserKey);
            if (userModel != null)
            {
                AddressViewModel defaultShippingAddress = userModel.Addresses.FirstOrDefault(o => o.IsDefaultShipping);
                if (defaultShippingAddress != null)
                {
                    zipCode = defaultShippingAddress.PostalCode;
                    cart.ShippingAddress.PostalCode = defaultShippingAddress.PostalCode;
                    cart.ShippingAddress.FirstName = defaultShippingAddress.FirstName;
                    cart.ShippingAddress.LastName = defaultShippingAddress.LastName;
                    cart.ShippingAddress.StateName = defaultShippingAddress.StateName;
                    cart.ShippingAddress.CompanyName = defaultShippingAddress.CompanyName;
                    cart.ShippingAddress.Address1 = defaultShippingAddress.Address1;
                    cart.ShippingAddress.CityName = defaultShippingAddress.CityName;
                    cart.ShippingAddress.Address3 = defaultShippingAddress.Address3;
                }
            }


            ShippingListModel lstModel = _shoppingCartsClient.GetShippingEstimates(zipCode, cart);

            ShippingOptionListViewModel lstViewModel = new ShippingOptionListViewModel { ShippingOptions = lstModel?.ShippingList?.ToViewModel<ShippingOptionViewModel>().ToList() };

            if (cart.Shipping?.ShippingId > 0)
            {
                lstViewModel.ShippingOptions?.Where(x => x.ShippingId == cart.Shipping.ShippingId)?.Select(y => { y.IsSelected = true; return y; })?.ToList();
            }

            if (cart.Shipping?.Custom1 != null)
            {
                int SecondShippingId = 0;
                if (cart.Shipping.Custom1 != null)
                {
                    int.TryParse(cart.Shipping.Custom1.ToString(), out SecondShippingId);
                }
                lstViewModel.ShippingOptions?.Where(x => x.ShippingId == SecondShippingId)?.Select(y => { y.IsSelected = true; return y; })?.ToList();
            }

            lstViewModel = GetCurrencyFormattedRates(lstViewModel);
            if (IsNotNull(cart.ShippingAddress))
            {
                cart.ShippingAddress.PostalCode = zipCode;
                SaveInSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey, cart);
            }
            SaveInSession<String>(ZnodeConstant.ShippingEstimatedZipCode, zipCode);
            return lstViewModel;
        }

        protected override ShippingOptionListViewModel GetCurrencyFormattedRates(ShippingOptionListViewModel lstViewModel)
        {
            ShippingOptionListViewModel model = new ShippingOptionListViewModel();
            List<ShippingOptionViewModel> lstModel = new List<ShippingOptionViewModel>();
            string cultureCode = PortalAgent.CurrentPortal.CultureCode;
            if (lstViewModel?.ShippingOptions?.Count > 0)
            {
                foreach (ShippingOptionViewModel shipping in lstViewModel?.ShippingOptions)
                {
                    shipping.FormattedShippingRate = Helper.FormatPriceWithCurrency(shipping.ShippingRate, cultureCode);
                    lstModel.Add(shipping);
                }
            }

            model.ShippingOptions = lstModel;
            return model;
        }

        public virtual void AddEstimatedShippingDetailsToCartViewModel(int shippingId, int shippingId2)
        {
            ShoppingCartModel cartModel = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
                      GetCartFromCookie();
            cartModel.ShippingId = shippingId;
            cartModel.Shipping.ShippingId = shippingId;
            cartModel.Shipping.Custom1 = shippingId2.ToString();

            UserViewModel userModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey) ?? GetFromSession<UserViewModel>(WebStoreConstants.GuestUserKey);
            if (userModel != null)
            {
                AddressViewModel defaultShippingAddress = userModel.Addresses.FirstOrDefault(o => o.IsDefaultShipping);
                if (defaultShippingAddress != null)
                {
                    cartModel.ShippingAddress.PostalCode = defaultShippingAddress.PostalCode;
                    cartModel.ShippingAddress.FirstName = defaultShippingAddress.FirstName;
                    cartModel.ShippingAddress.LastName = defaultShippingAddress.LastName;
                    cartModel.ShippingAddress.StateName = defaultShippingAddress.StateName;
                    cartModel.ShippingAddress.CompanyName = defaultShippingAddress.CompanyName;
                    cartModel.ShippingAddress.Address1 = defaultShippingAddress.Address1;
                    cartModel.ShippingAddress.CityName = defaultShippingAddress.CityName;
                }
            }

            SaveInSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey, cartModel);
            SaveInSession<String>(ZnodeConstant.ShippingEstimatedZipCode, cartModel.ShippingAddress.PostalCode);
        }

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
                customerPostalCode = userModel?.ShippingAddress?.PostalCode/* ?? userModel?.Addresses?.Where(x => x.IsDefaultShipping = true).FirstOrDefault()?.PostalCode*/;
                if (string.IsNullOrEmpty(customerPostalCode))
                {
                    try
                    {
                        var service = ZnodeDependencyResolver.GetService<IUserAgent>();
                        var addressList = service.GetAddressList();
                        customerPostalCode = addressList?.ShippingAddress?.PostalCode;
                    }
                    catch (Exception)
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
                FreeFreightSkuListResponse freeFreightSkuListResponse = ((PHShoppingCartClient)_shoppingCartsClient).GetAssociatedInventory(freightSkuList);
                lstWarehouseSku = freeFreightSkuListResponse?.SkuList;
            }

            return lstWarehouseSku;
        }

        protected override bool IsShoppingCartInSession(ShoppingCartModel model)
        {
            if (IsNull(model) || IsNull(model?.ShoppingCartItems) || model?.ShoppingCartItems?.Count < 1)
            {
                return false;
            }
            return true;
        }

        //Set portal approval type in the cart model
        protected override void SetPortalApprovalType(CartViewModel cartViewModel)
        {
            if (PortalAgent.CurrentPortal.EnableApprovalManagement && IsNotNull(cartViewModel))
            {
                PortalApprovalModel portalApprovalModel = GetClient<PortalClient>().GetPortalApproverDetailsById(PortalAgent.CurrentPortal.PortalId);
                cartViewModel.ApprovalType = portalApprovalModel?.PortalApprovalTypeName;
            }
        }

        // Get Cart method to check Session or Cookie to get the existing shopping cart.
        public override CartViewModel GetCart(bool isCalculateTaxAndShipping = true, bool isCalculateCart = true, bool isCalculatePromotionAndCoupon = true)
        {
            ShoppingCartModel shoppingCartModel = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
                                     GetCartFromCookie();

            if (IsNull(shoppingCartModel))
            {
                return new CartViewModel()
                {
                    HasError = true,
                    ErrorMessage = WebStore_Resources.OutofStockMessage
                };
            }

            if (IsNotNull(shoppingCartModel) && (IsNull(shoppingCartModel?.ShoppingCartItems) || shoppingCartModel?.ShoppingCartItems?.Count == 0))
            {
                List<ShoppingCartItemModel> shoppingartItems = GetCartFromCookie()?.ShoppingCartItems;
                shoppingCartModel.ShoppingCartItems = (shoppingartItems?.Count > 0) ? shoppingartItems : new List<ShoppingCartItemModel>(); ;
            }

            if (shoppingCartModel.ShoppingCartItems?.Count == 0)
            {
                return new CartViewModel();
            }

            if (!(HttpContext.Current.User.Identity.IsAuthenticated) && shoppingCartModel?.ShippingOptions?.Count > 0)
            {
                shoppingCartModel.Shipping = new OrderShippingModel() { ShippingId = shoppingCartModel.ShippingId > 0 ? shoppingCartModel.ShippingId : 0, ShippingCountryCode = WebStoreConstants.ShippingCountryCode };
                shoppingCartModel.Payment = new PaymentModel();
                RemoveTaxFromCart(shoppingCartModel);
            }
            else
            {
                //Remove Shipping and Tax calculation From Cart.
                RemoveShippingTaxFromCart(shoppingCartModel);

                //To remove the tax getting calculated when we come back from checkout page to cart page
                shoppingCartModel.ShippingAddress = new AddressModel();
                shoppingCartModel.ShippingAddress.PostalCode = GetFromSession<String>(ZnodeConstant.ShippingEstimatedZipCode);
            }

            shoppingCartModel.ShippingAddress.CountryName = "us";
            shoppingCartModel.CultureCode = PortalAgent.CurrentPortal.CultureCode;
            shoppingCartModel.CurrencyCode = PortalAgent.CurrentPortal.CurrencyCode;
            shoppingCartModel.IsCalculatePromotionAndCoupon = isCalculatePromotionAndCoupon;
            shoppingCartModel.IsCalculateVoucher = false;
            shoppingCartModel.IsPendingOrderRequest = false;
            //Calculate cart
            shoppingCartModel = CalculateCart(shoppingCartModel, isCalculateTaxAndShipping, isCalculateCart);

            shoppingCartModel?.ShoppingCartItems?.ForEach(x => {
                if (x.SKU.ToLower().Contains("chill"))
                {
                    x.Custom2 = x.ProductCode;
                }
            });
            SaveInSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey, shoppingCartModel);

            //Set currency details.
            return SetCartCurrency(shoppingCartModel);
        }
        #endregion
    }


}