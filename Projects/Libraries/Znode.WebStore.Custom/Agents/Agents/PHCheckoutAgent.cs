using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;
using System.Linq;
using System.Web;
using Znode.Api.Client.Custom;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.WebStore.Helpers;
using Znode.Engine.WebStore.Maps;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Resources;
using Znode.WebStore.Custom;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using Znode.Engine.klaviyo.Models;
using Znode.Engine.Klaviyo.IClient;
using Znode.Libraries.Klaviyo.Helper;
using Znode.Api.Model.Custom.CustomUpsModel;

namespace Znode.Engine.WebStore.Agents
{
    public class PHCheckoutAgent : CheckoutAgent, ICheckoutAgent
    {
        #region Private Variables
        private readonly IShippingClient _shippingsClient;
        private readonly IPaymentClient _paymentClient;
        private readonly IPortalProfileClient _profileClient;
        private readonly ICustomerClient _customerClient;
        private readonly IUserClient _userClient;
        private readonly IOrderClient _orderClient;
        private readonly ICartAgent _cartAgent;
        private readonly IUserAgent _userAgent;
        private readonly IPaymentAgent _paymentAgent;
        private readonly IAccountClient _accountClient;
        private readonly IWebStoreUserClient _webStoreAccountClient;
        private readonly IPortalClient _portalClient;
        private readonly IShoppingCartClient _shoppingCartClient;
        private readonly IAddressAgent _addressAgent;
        #endregion

        public PHCheckoutAgent(IShippingClient shippingsClient, IPaymentClient paymentClient, IPortalProfileClient profileClient, ICustomerClient customerClient, IUserClient userClient, IOrderClient orderClient, IAccountClient accountClient, IWebStoreUserClient webStoreAccountClient, IPortalClient portalClient, IShoppingCartClient shoppingCartClient, IAddressClient addressClient)
            : base(shippingsClient, paymentClient, profileClient, customerClient, userClient, orderClient, accountClient, webStoreAccountClient, portalClient, shoppingCartClient, addressClient)
        {
            _shippingsClient = GetClient<IShippingClient>(shippingsClient);
            _paymentClient = GetClient<IPaymentClient>(paymentClient);
            _profileClient = GetClient<IPortalProfileClient>(profileClient);
            _customerClient = GetClient<ICustomerClient>(customerClient);
            _userClient = GetClient<IUserClient>(userClient);
            _orderClient = GetClient<IOrderClient>(orderClient);
            //   _userAgent = new UserAgent(GetClient<CountryClient>(), GetClient<WebStoreUserClient>(), GetClient<WishLishClient>(), GetClient<UserClient>(), GetClient<PublishProductClient>(), GetClient<CustomerReviewClient>(), GetClient<OrderClient>(), GetClient<GiftCardClient>(), GetClient<AccountClient>(), GetClient<AccountQuoteClient>(), GetClient<OrderStateClient>(), GetClient<PortalCountryClient>(), GetClient<ShippingClient>(), GetClient<PaymentClient>(), GetClient<CustomerClient>(), GetClient<StateClient>(), GetClient<PortalProfileClient>());
            _userAgent = GetService<IUserAgent>();
            _cartAgent = new CartAgent(GetClient<ShoppingCartClient>(), GetClient<PublishProductClient>(), GetClient<AccountQuoteClient>(), GetClient<UserClient>());
            //_paymentAgent = new PaymentAgent(GetClient<PaymentClient>(), GetClient<OrderClient>());
            _paymentAgent = GetService<IPaymentAgent>();
            _accountClient = GetClient<IAccountClient>(accountClient);
            _webStoreAccountClient = GetClient<IWebStoreUserClient>(webStoreAccountClient);
            _portalClient = GetClient<IPortalClient>(portalClient);
            _shoppingCartClient = GetClient<IShoppingCartClient>(shoppingCartClient);
            _addressAgent = new AddressAgent(GetClient<IAddressClient>(addressClient));
        }

        #region Public Methods
        //Bind shipping option list.
        //CUSTOMIZATION: ADDED THIS OVERRIDE TO DETECT SECOND SHIPMENT OPTION FROM CUSTOM1 FIELD AND FLAG IT AS ISSELECTED ALONG WITH STANDARD SHIPPING METHOD
        public override ShippingOptionListViewModel GetShippingOptions(string shippingTypeName = null, bool isQuote = false)
        {
            List<ShippingOptionViewModel> shippingOptions;
            bool isB2BUser = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey)?.AccountId > 0;

            ShoppingCartModel cartModel = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
                             _cartAgent.GetCartFromCookie();

            int omsQuoteId = (cartModel?.OmsQuoteId).GetValueOrDefault();

            try
            {
                if (IsNotNull(cartModel) && !string.IsNullOrEmpty(shippingTypeName))
                    SetShippingTypeNameToModel(shippingTypeName, cartModel);

                //Get address associated to the cart, If it is not available then get address from user address book.
                AddressListViewModel addressList = GetCartAddressList(cartModel);
                if (addressList?.ShippingAddress == null || addressList?.ShippingAddress?.AddressId == 0)
                    addressList = _userAgent.GetAddressList();

                if (!IsValidShippingAddress(addressList))
                    return new ShippingOptionListViewModel() { IsB2BUser = isB2BUser, OmsQuoteId = omsQuoteId };

                cartModel.BillingAddress = addressList?.BillingAddress?.ToModel<AddressModel>();
                cartModel.Payment = new PaymentModel { ShippingAddress = addressList?.ShippingAddress?.ToModel<AddressModel>() };

                shippingOptions = GetShippingListAndRates(addressList?.ShippingAddress?.PostalCode, cartModel)?.ShippingOptions;

                //Atish ups change for handeling weight > 150
                if (shippingOptions.FirstOrDefault().Custom2 != null)
                {
                    var upserror = new Dictionary<string, string>();
                    upserror = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(shippingOptions.FirstOrDefault().Custom2);
                    if (shippingOptions.Count > 0 && upserror["Error"] == "The remote server returned an error: (400) Bad Request." && Convert.ToDecimal(upserror["Weight"]) > 150)
                    {
                        return new ShippingOptionListViewModel() { ShippingOptions = shippingOptions, ErrorMessage = "The maximum per package weight for the selected service is 150 pounds" };
                    }
                }
               
                //Atish ups change for handeling weight > 150 end
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage(ex, "GetShippingOptions", TraceLevel.Error);
                shippingOptions = new List<ShippingOptionViewModel>();
            }

            ShoppingCartModel shoppingCart = GetFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey);

            if (shoppingCart?.ShoppingCartItems?.Count > 0)
            {
                //CUSTOMIZATION: GET THE SECOND SHIPPING METHOD ID FROM CUSTOM 1 FIELD
                int SecondShippingId = 0;
                if (shoppingCart.Shipping.Custom1 != null)
                {
                    int.TryParse(shoppingCart.Shipping.Custom1.ToString(), out SecondShippingId);
                }

                shippingOptions.Where(x => x.ShippingId == shoppingCart.ShippingId)?.Select(y => { y.IsSelected = true; shoppingCart.Shipping.ShippingId = y.ShippingId; return y; }).FirstOrDefault();

                // IF SECOND SHIPPING METHOD IS NOT NULL, MARK IT AS SELECTED TOO
                shippingOptions.Where(x => x.ShippingId == SecondShippingId)?.Select(y => { y.IsSelected = true; shoppingCart.Shipping.ShippingId = y.ShippingId; return y; }).FirstOrDefault();
                //Removed due not showing address validation on checkout page while entering not valid address 
                //if (shoppingCart.ShoppingCartItems.Any(x => x.Quantity > 500 && shippingOptions?.Count() == 0))
                //{
                //    SaveInSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey, shoppingCart);
                //    return new ShippingOptionListViewModel() { ShippingOptions = shippingOptions, IsB2BUser = isB2BUser, OmsQuoteId = omsQuoteId, ErrorMessage = Admin_Resources.ErrorShippingExceeded, HasError = true };
                //}
            }
            SaveInSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey, shoppingCart);
            return new ShippingOptionListViewModel() { ShippingOptions = shippingOptions, IsB2BUser = isB2BUser, OmsQuoteId = omsQuoteId };
        }


        public override OrdersViewModel SubmitOrder(SubmitOrderViewModel submitOrderViewModel)
        {
            try
            {
                if (IsNull(submitOrderViewModel))
                {
                    ZnodeLogging.LogMessage("The submit order model is null", ZnodeLogging.Components.Webstore.ToString(), TraceLevel.Error);
                    return new OrdersViewModel() { HasError = true, ErrorMessage = WebStore_Resources.ErrorFailedToCreate };
                }

                //Get deep copy of the cart to remove the reference type dependency of session object or by cookie.
                ShoppingCartModel cartModel = GetCloneFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
                              _cartAgent.GetCartFromCookie();

                if (IsNull(cartModel))
                {
                    ZnodeLogging.LogMessage("The session shopping cart model is null", ZnodeLogging.Components.Webstore.ToString(), TraceLevel.Error);
                    return new OrdersViewModel() { HasError = true, ErrorMessage = WebStore_Resources.ErrorFailedToCreate };
                }

                //Condition for checking Available Quantity
                if (GetAvailableQuantity(cartModel))
                {
                    return new OrdersViewModel() { HasError = true, ErrorMessage = WebStore_Resources.ExceedingAvailableWithoutQuantity };
                }

                UserViewModel userViewModel = GetCloneFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);

                //Set IsQuoteOrder true if quote id is greater than zero or user permission access is does not require approver.
                if (IsNotNull(userViewModel))
                {
                    userViewModel.CreatedDate = string.Empty;
                    SetIsQuoteOrder(cartModel, userViewModel);
                    string message = string.Empty;
                    if (!_userAgent.ValidateUserBudget(out message))
                    {
                        return (OrdersViewModel)GetViewModelWithErrorMessage(new OrdersViewModel(), message);
                    }
                    UpdateUserDetailsInSession(cartModel, userViewModel);
                }

                RemoveInvalidDiscountCode(cartModel);

                UserViewModel user = (IsNotNull(userViewModel) && userViewModel.UserId > 0) ? userViewModel : GetFromSession<UserViewModel>(WebStoreConstants.GuestUserKey);

                //Get the payment details.
                GetPaymentDetails(submitOrderViewModel.PaymentSettingId, cartModel);

                //Check if billing address of cart model is not null then create it billing address of guest user.
                if (IsNotNull(cartModel.BillingAddress) && !Convert.ToBoolean(cartModel.ShippingAddress.IsDefaultBilling))
                {
                    if (cartModel.Payment?.PaymentSetting?.IsBillingAddressOptional == true)
                    {
                        cartModel.BillingAddress = cartModel.ShippingAddress;
                        cartModel.BillingAddress.AddressId = 0;
                        cartModel.BillingAddress.IsBilling = true;
                        cartModel.BillingAddress.IsDefaultBilling = true;
                    }
                }

                cartModel.OrderNumber = !string.IsNullOrEmpty(submitOrderViewModel.OrderNumber) ? submitOrderViewModel.OrderNumber
                                        : GenerateOrderNumber(cartModel.PortalId);

                if (IsNull(user) || user?.UserId < 1)
                {
                    if (IsAmazonPayEnable(submitOrderViewModel))
                    {
                        SetUsersPaymentDetails(submitOrderViewModel.PaymentSettingId, cartModel, true);
                        SetAmazonAddress(submitOrderViewModel, cartModel);
                        user = CreateAnonymousUserAccount(cartModel.BillingAddress, cartModel.ShippingAddress?.EmailAddress);
                        UserViewModel oldSession = GetFromSession<UserViewModel>(WebStoreConstants.GuestUserKey);
                        if (!Equals(oldSession, null))
                        {
                            oldSession.GuestUserId = oldSession.UserId;
                            if (IsNotNull(userViewModel))
                                userViewModel.UserId = oldSession.UserId;
                            SaveInSession(WebStoreConstants.GuestUserKey, oldSession);
                        }
                    }
                    else
                    {
                        user = CreateAnonymousUserAccount(cartModel.BillingAddress, cartModel.ShippingAddress?.EmailAddress);
                    }
                }

                //Get the list of all addresses associated to current logged in user.
                List<AddressModel> userAddresses = GetUserAddressList();

                if (IsNull(userAddresses) || userAddresses.Count < 1)
                {
                    if (IsAmazonPayEnable(submitOrderViewModel) && !Equals(cartModel.ShippingAddress, null) && (string.IsNullOrEmpty(cartModel.ShippingAddress.Address1) || string.IsNullOrEmpty(cartModel.ShippingAddress.FirstName)))
                    {
                        SetUsersPaymentDetails(submitOrderViewModel.PaymentSettingId, cartModel, true);
                        SetAmazonAddress(submitOrderViewModel, cartModel);
                        cartModel.ShippingAddress.IsDefaultBilling = true;
                        cartModel.ShippingAddress.IsDefaultShipping = true;
                    }
                    if (!string.IsNullOrEmpty(cartModel?.Payment?.PaymentName) && Equals(cartModel.Payment.PaymentName.Replace("_", "").ToLower(), ZnodeConstant.PayPalExpress.ToLower()))
                    {
                        if (string.IsNullOrEmpty(submitOrderViewModel.PayPalToken))
                        {
                            userAddresses = GetAnonymousUserAddresses(cartModel, submitOrderViewModel);
                        }
                    }
                    else if (IsNotNull(submitOrderViewModel?.PaymentType) && Equals(submitOrderViewModel?.PaymentType.ToLower(), ZnodeConstant.AmazonPay.ToLower()))
                    {
                        SetAmazonAddress(submitOrderViewModel, cartModel);
                        SetUserDetails(user, cartModel);
                        cartModel.ShippingAddress.IsDefaultBilling = true;
                        cartModel.ShippingAddress.IsDefaultShipping = true;
                        userAddresses = GetAnonymousUserAddresses(cartModel, submitOrderViewModel);
                    }
                    else
                    {
                        userAddresses = GetAnonymousUserAddresses(cartModel, submitOrderViewModel);
                    }
                }
                submitOrderViewModel.UserId = user.UserId;

                //Send shipping address in cart for validation, 
                //if it is not available then only send shipping address from user address list for validation in USPS.
                Api.Models.BooleanModel booleanModel;
                if (IsAmazonPayEnable(submitOrderViewModel) == true || IsAddressValidationRequiredForOrder() == false)
                {
                    booleanModel = new Api.Models.BooleanModel { IsSuccess = true };
                    SetPublishStateIdInAddressModel((IsNull(cartModel?.ShippingAddress) || cartModel?.ShippingAddress?.AddressId == 0) ? userAddresses?.Where(x => x.AddressId == submitOrderViewModel.ShippingAddressId)?.FirstOrDefault() : cartModel?.ShippingAddress);
                }
                else { booleanModel = IsValidAddressForCheckout((IsNull(cartModel?.ShippingAddress) || cartModel?.ShippingAddress?.AddressId == 0) ? userAddresses?.Where(x => x.AddressId == submitOrderViewModel.ShippingAddressId)?.FirstOrDefault() : cartModel?.ShippingAddress); }
                //Check whether address is valid or not.
                if ((!booleanModel.IsSuccess) &&
                    !(bool)PortalAgent.CurrentPortal.PortalFeatureValues.Where(x => x.Key.Contains(StoreFeature.Require_Validated_Address.ToString()))?.FirstOrDefault().Value)
                {
                    return (OrdersViewModel)GetViewModelWithErrorMessage(new OrdersViewModel(), booleanModel.ErrorMessage ?? WebStore_Resources.AddressValidationFailed);
                }

                //Set shoppingcart details like shipping. payment setting, etc.
                SetShoppingCartDetails(submitOrderViewModel, userAddresses, cartModel);

                // Perform the calculation in case the session order total & order total from page does not match
                // In case of multi tab scenario where at the time of order place, the cart update from other tab
                cartModel = EnsureShoppingCartCalculations(cartModel, submitOrderViewModel);

                bool isCreditCardPayment = false;
                // Condition for "Credit Card" payment.
                if (IsNotNull(cartModel?.Payment) && Equals(cartModel.Payment.PaymentName.ToLower(), ZnodeConstant.CreditCard.ToLower()))
                {
                    isCreditCardPayment = true;
                    OrdersViewModel orderViewModel = ProcessCreditCardPayment(submitOrderViewModel, cartModel);
                    if (orderViewModel.HasError)
                    {
                        ZnodeLogging.LogMessage(" Nivi SubmitOrder after ProcessCreditCardPayment Error " + orderViewModel.ErrorMessage, ZnodeLogging.Components.Webstore.ToString(), TraceLevel.Error, orderViewModel);
                        return orderViewModel;
                    }
                    
                    ZnodeLogging.LogMessage(" Nivi submitOrder after ProcessCreditCardPayment Total: "+cartModel.Total + " ShippingCost:" + cartModel.ShippingCost  + " OrderNumber: "+ cartModel.OrderNumber+" TransactionId :" + cartModel.TransactionId + " TransactionDate :"+ cartModel.TransactionDate+ "  PaymentStatusId:" 
                        + cartModel.Payment.PaymentStatusId+ " IsGatewayPreAuthorize :"+ cartModel.IsGatewayPreAuthorize+ "  CreditCardNumber:" + cartModel.CreditCardNumber, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                   
                }
                else if (IsNotNull(cartModel?.Payment) && Equals(cartModel.Payment.PaymentName.ToLower(), ZnodeConstant.ACH.ToLower()))
                {
                    OrdersViewModel orderViewModel = ProcessCreditCardPayment(submitOrderViewModel, cartModel);
                    if (orderViewModel.HasError)
                    {
                        return orderViewModel;
                    }
                }
                // Condition for "PayPal Express".                   
                else if (!string.IsNullOrEmpty(cartModel?.Payment?.PaymentName) && Equals(cartModel.Payment.PaymentName.Replace("_", "").ToLower(), ZnodeConstant.PayPalExpress.ToLower()))
                {
                    ZnodeLogging.LogMessage($"Paypal Token - {submitOrderViewModel.PayPalToken}");
                    OrdersViewModel order = new OrdersViewModel();
                    if (string.IsNullOrEmpty(submitOrderViewModel.PayPalToken))
                    {
                        return PayPalExpressPaymentProcess(submitOrderViewModel, cartModel, userAddresses);
                    }
                    else
                    {
                        order = PayPalExpressPaymentProcess(submitOrderViewModel, cartModel, userAddresses);
                    }

                    if (!string.IsNullOrEmpty(order?.PayPalExpressResponseToken))
                    {
                        cartModel.Token = order.PayPalExpressResponseToken;
                        if (string.Equals(order.PaymentStatus, Znode.Engine.Api.Models.Enum.ZnodePaymentStatus.PENDINGFORREVIEW.ToString(), StringComparison.InvariantCultureIgnoreCase))
                            cartModel.Payment.PaymentStatusId = Convert.ToInt16(Enum.Parse(typeof(Znode.Engine.Api.Models.Enum.ZnodePaymentStatus), order.PaymentStatus));
                    }
                    else
                    {
                        return order;
                    }
                }
                //Amazon payment.
                else if (IsNotNull(submitOrderViewModel?.PaymentType) && Equals(submitOrderViewModel?.PaymentType.ToLower(), ZnodeConstant.AmazonPay.ToLower()) && !string.IsNullOrEmpty(submitOrderViewModel.AmazonPayReturnUrl) && !string.IsNullOrEmpty(submitOrderViewModel.AmazonPayCancelUrl))
                {
                    return AmazonPaymentProcess(submitOrderViewModel, cartModel, userAddresses);
                }

                if (submitOrderViewModel.IsFromAmazonPay)
                {
                    cartModel.Token = cartModel.Token;
                }

                if (!string.IsNullOrEmpty(submitOrderViewModel.PayPalToken) && submitOrderViewModel.IsFromPayPalExpress)
                {
                    submitOrderViewModel.CardType = "PayPal";
                    submitOrderViewModel.TransactionId = cartModel.Token;
                }

                if (submitOrderViewModel.IsFromAmazonPay)
                {
                    cartModel.Token = submitOrderViewModel.PaymentToken;
                    submitOrderViewModel.CardType = "Amazon";
                    submitOrderViewModel.TransactionId = submitOrderViewModel.PaymentToken;
                }

                //Card Type
                cartModel.CardType = submitOrderViewModel.CardType;
                cartModel.CcCardExpiration = submitOrderViewModel.CcExpiration;
                cartModel.TransactionId = submitOrderViewModel.TransactionId;
                if (IsNotNull(PortalAgent.CurrentPortal.PublishState))
                {
                    cartModel.PublishStateId = (byte)PortalAgent.CurrentPortal.PublishState;
                }

                cartModel.OmsOrderStatusId = PortalAgent.CurrentPortal.DefaultOrderStateID;
                cartModel.IsOrderFromWebstore = true;

                //This is used to skip pre-submit order validation, since all the validations have already been validated at the checkout page.
                cartModel.SkipPreprocessing = true;

                ZnodeLogging.LogMessage(" Nivi submitOrder before PlaceOrder   OrderNumber :" + cartModel?.OrderNumber, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                cartModel.Custom4 = HttpContext.Current.Session[WebStoreConstants.CartModelSessionKey + "_ItemCarriers"] as string;
                OrdersViewModel _ordersViewModel = PlaceOrder(cartModel);

                ZnodeLogging.LogMessage(" Nivi submitOrder after PlaceOrder   OrderNumber :" + cartModel?.OrderNumber, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);


                //Update the new balance values against the user.
                if (_ordersViewModel.OmsOrderId > 0)
                {
                    RemoveCookie(WebStoreConstants.UserOrderReceiptOrderId);
                    SaveInCookie(WebStoreConstants.UserOrderReceiptOrderId, Convert.ToString(_ordersViewModel.OmsOrderId), ZnodeConstant.MinutesInAHour);
                    UpdateUserDetailsInSession(_ordersViewModel.Total);
                }

                //Get address from cache.
                string cacheKey = $"{WebStoreConstants.UserAccountAddressList}{cartModel.UserId}";
                Helper.ClearCache(cacheKey);

                if (isCreditCardPayment && !cartModel.IsGatewayPreAuthorize && _ordersViewModel.OmsOrderId > 0 && !string.IsNullOrEmpty(cartModel.Token))
                {
                    CapturePayment(_ordersViewModel.OmsOrderId, cartModel.Token, _ordersViewModel);
                    ZnodeLogging.LogMessage(" Nivi submitOrder after CapturePayment   OrderNumber :" + cartModel?.OrderNumber, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);

                }
                else if (isCreditCardPayment)
                {
                    _orderClient.CreateOrderHistory(new OrderHistoryModel() { OmsOrderDetailsId = _ordersViewModel.OmsOrderDetailsId, Message = WebStore_Resources.TextTransactionPreAuthorized, TransactionId = _ordersViewModel.TransactionId, CreatedBy = _ordersViewModel.CreatedBy, ModifiedBy = _ordersViewModel.ModifiedBy });
                    ZnodeLogging.LogMessage(" Nivi submitOrder after CreateOrderHistory   OrderNumber :" + cartModel?.OrderNumber+ " OmsOrderDetailsId: "+ _ordersViewModel.OmsOrderDetailsId, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                }

                if (IsNotNull(submitOrderViewModel?.PaymentType) && Equals(submitOrderViewModel?.PaymentType.ToLower(), ZnodeConstant.AmazonPay.ToLower()) && !cartModel.IsGatewayPreAuthorize && _ordersViewModel.OmsOrderId > 0 && !string.IsNullOrEmpty(cartModel.Token))
                {
                    CapturePayment(_ordersViewModel.OmsOrderId, submitOrderViewModel.PaymentToken, _ordersViewModel);
                }

                if (PortalAgent.CurrentPortal.IsKlaviyoEnable)
                {
                    // Created the task to post the data to klaviyo
                    HttpContext httpContext = HttpContext.Current;

                    System.Threading.Tasks.Task.Run(() =>
                    {
                        PostDataToKlaviyo(_ordersViewModel, httpContext);
                    });
                }
                if (string.Equals(submitOrderViewModel.GatewayCode, ZnodeConstant.CyberSource, StringComparison.CurrentCultureIgnoreCase))
                {
                    RemoveInSession(WebStoreConstants.UserAccountKey);
                }
                return _ordersViewModel;
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in SubmitOrder method is " + ex.Message, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                return new OrdersViewModel() { HasError = true, ErrorMessage = WebStore_Resources.ErrorFailedToCreate };
            }
        }
        // To post the data to klaviyo
        public void PostDataToKlaviyo()
        {
            try
            {
                ShoppingCartModel cartModel = GetCloneFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey) ??
                               _cartAgent.GetCartFromCookie();
                IKlaviyoClient _klaviyoClient = GetComponentClient<IKlaviyoClient>(GetService<IKlaviyoClient>());
                KlaviyoProductDetailModel klaviyoProductDetailModel = MapShoppingCartModelToKlaviyoModel(cartModel);
                bool isTrackKlaviyo = _klaviyoClient.TrackKlaviyo(klaviyoProductDetailModel);
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in PHCheckout PostDataToKlaviyo method is " + ex.Message+" "+ex.StackTrace, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
            }
        }

        // Map the order model to klaviyo model
        public KlaviyoProductDetailModel MapShoppingCartModelToKlaviyoModel(ShoppingCartModel shoppingCartModel)
        {
            KlaviyoProductDetailModel klaviyoProductDetailModel = new KlaviyoProductDetailModel();
            try
            {
                HttpContext httpContext = HttpContext.Current;
                var Kemail = SessionHelper.GetDataFromSession<string>("EmailForGuest");
                var KFirstName = SessionHelper.GetDataFromSession<string>("FirstNameForGuest");
                if (String.IsNullOrEmpty(Kemail))
                {
                    Kemail = Convert.ToString(httpContext.Request.Cookies["KlaviyoEmail"]?.Value);
                    KFirstName = Convert.ToString(httpContext.Request.Cookies["KlaviyoFirstName"]?.Value);
                }
                
                klaviyoProductDetailModel.OrderLineItems = new List<OrderLineItemDetailsModel>();
                klaviyoProductDetailModel.PortalId = PortalAgent.CurrentPortal.PortalId;
                UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);
                if (httpContext.Request.IsAuthenticated != true)
                {
                    klaviyoProductDetailModel.Email = Kemail;
                    klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
                    klaviyoProductDetailModel.PropertyType = 4;
                    klaviyoProductDetailModel.FirstName = KFirstName;
                    foreach (ShoppingCartItemModel ShoppingCartItems in shoppingCartModel.ShoppingCartItems)
                    {
                        klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = ShoppingCartItems.ProductName, SKU = ShoppingCartItems.SKU, Quantity = ShoppingCartItems.Quantity, UnitPrice = ShoppingCartItems.UnitPrice, Image = ShoppingCartItems.ImagePath });
                    }
                    return klaviyoProductDetailModel;
                }
                if (HelperUtility.IsNull(userViewModel))
                    //userViewModel = _userClient.GetUserDetailById(shoppingCartModel.UserId.GetValueOrDefault(), shoppingCartModel.PortalId)?.ToViewModel<UserViewModel>();
                    userViewModel = shoppingCartModel.UserDetails.ToViewModel<UserViewModel>();
                klaviyoProductDetailModel.FirstName = userViewModel?.FirstName;
                klaviyoProductDetailModel.LastName = userViewModel?.LastName;
                klaviyoProductDetailModel.Email = userViewModel?.Email;
                klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
                klaviyoProductDetailModel.PropertyType = 4;
                foreach (ShoppingCartItemModel ShoppingCartItems in shoppingCartModel.ShoppingCartItems)
                {
                    klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = ShoppingCartItems.ProductName, SKU = ShoppingCartItems.SKU, Quantity = ShoppingCartItems.Quantity, UnitPrice = ShoppingCartItems.UnitPrice, Image = ShoppingCartItems.ImagePath });
                }
                return klaviyoProductDetailModel;
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in PHCheckout PostDataToKlaviyo method is " + ex.Message + " " + ex.StackTrace, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);

            }
            return klaviyoProductDetailModel;

        }
        // Map the order model to klaviyo model
        protected override KlaviyoProductDetailModel MapOrderModelToKlaviyoModel(OrdersViewModel _ordersViewModel)
        {
            KlaviyoProductDetailModel klaviyoProductDetailModel = new KlaviyoProductDetailModel();
            klaviyoProductDetailModel.OrderLineItems = new List<OrderLineItemDetailsModel>();
            klaviyoProductDetailModel.PortalId = PortalAgent.CurrentPortal.PortalId;
            HttpContext httpContext = HttpContext.Current;
            var Kemail = SessionHelper.GetDataFromSession<string>("EmailForGuest");
            var KFirstName = SessionHelper.GetDataFromSession<string>("FirstNameForGuest");
            if (String.IsNullOrEmpty(Kemail))
            {
                Kemail = Convert.ToString(httpContext.Request.Cookies["KlaviyoEmail"]?.Value);
                KFirstName = Convert.ToString(httpContext.Request.Cookies["KlaviyoFirstName"]?.Value);
            }
            UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);
            if (httpContext.Request.IsAuthenticated != true)
            {
                klaviyoProductDetailModel.Email = Kemail;
                klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
                klaviyoProductDetailModel.PropertyType = (int)KlaviyoEventType.CheckOutSuccessEvent;
                klaviyoProductDetailModel.FirstName = KFirstName;
                foreach (OrderLineItemViewModel orderLineItem in _ordersViewModel.OrderLineItems)
                {
                    klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = orderLineItem.ProductName, SKU = orderLineItem.Sku, Quantity = orderLineItem.Quantity, UnitPrice = orderLineItem.Price, Image = orderLineItem.Image });
                }
                return klaviyoProductDetailModel;
            }
            klaviyoProductDetailModel.FirstName = userViewModel?.FirstName;
            klaviyoProductDetailModel.LastName = userViewModel?.LastName;
            klaviyoProductDetailModel.Email = _ordersViewModel?.EmailAddress;
            klaviyoProductDetailModel.StoreName = PortalAgent.CurrentPortal.Name;
            klaviyoProductDetailModel.PropertyType = (int)KlaviyoEventType.CheckOutSuccessEvent;
            foreach (OrderLineItemViewModel orderLineItem in _ordersViewModel.OrderLineItems)
            {
                klaviyoProductDetailModel.OrderLineItems.Add(new OrderLineItemDetailsModel { ProductName = orderLineItem.ProductName, SKU = orderLineItem.Sku, Quantity = orderLineItem.Quantity, UnitPrice = orderLineItem.Price, Image = orderLineItem.Image });
            }
            return klaviyoProductDetailModel;
        }


        protected override OrdersViewModel ProcessCreditCardPayment(SubmitOrderViewModel submitOrderViewModel, ShoppingCartModel cartModel)
        {
            try
            {
                SetUsersPaymentDetails(submitOrderViewModel.PaymentSettingId, cartModel);
                submitOrderViewModel.PaymentType = cartModel?.Payment?.PaymentName;
                GatewayResponseModel gatewayResponse = GetPaymentResponse(cartModel, submitOrderViewModel);
                if (string.Equals(submitOrderViewModel.GatewayCode, ZnodeConstant.CyberSource, StringComparison.CurrentCultureIgnoreCase))
                {
                    SaveCustomerPaymentGuid(submitOrderViewModel.UserId, gatewayResponse.CustomerGUID, cartModel.UserDetails.CustomerPaymentGUID);
                }
                if (gatewayResponse?.HasError ?? true || string.IsNullOrEmpty(gatewayResponse?.Token))
                {
                    //RemoveInSession(WebStoreConstants.CartModelSessionKey);
                    return (OrdersViewModel)GetViewModelWithErrorMessage(new OrdersViewModel(), !string.IsNullOrEmpty(gatewayResponse?.ErrorMessage) ? (string.Equals(gatewayResponse.ErrorMessage, WebStore_Resources.ErrorCardConnectGatewayResponse, StringComparison.InvariantCultureIgnoreCase) ? WebStore_Resources.ErrorProcessPayment : gatewayResponse.ErrorMessage) : WebStore_Resources.ErrorProcessPayment);
                }


                //Map payment token
                cartModel.Token = gatewayResponse.Token;
                cartModel.IsGatewayPreAuthorize = gatewayResponse.IsGatewayPreAuthorize;
                cartModel.TransactionDate = gatewayResponse.TransactionDate;
                cartModel.TransactionId = gatewayResponse.Token;
                cartModel.Payment.PaymentStatusId = (int)gatewayResponse.PaymentStatus;
                submitOrderViewModel.TransactionId = gatewayResponse.Token;
                if (IsNotNull(cartModel?.Payment?.PaymentSetting?.GatewayCode) && (string.Equals(cartModel.Payment.PaymentSetting.GatewayCode, ZnodeConstant.CyberSource, StringComparison.InvariantCultureIgnoreCase) || string.Equals(cartModel.Payment.PaymentSetting.GatewayCode, ZnodeConstant.AuthorizeNet, StringComparison.InvariantCultureIgnoreCase)))
                    cartModel.CreditCardNumber = gatewayResponse.CardNumber;
                return new OrdersViewModel();
            }

            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in ProcessCreditCardPayment method for OrderNumber " + cartModel?.OrderNumber + " is " + ex.Message, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                throw;
            }
        }

        public override GatewayResponseModel GetPaymentResponse(ShoppingCartModel cartModel, SubmitOrderViewModel submitOrderViewModel)
        {
            try
            {
                // Map shopping Cart model and submit Payment view model to Submit payment model 
                SubmitPaymentModel model = PaymentViewModelMap.ToModel(cartModel, submitOrderViewModel);

                // Map Customer Payment Guid for Save Credit Card 
                if (!string.IsNullOrEmpty(submitOrderViewModel.CustomerGuid) && string.IsNullOrEmpty(cartModel.UserDetails.CustomerPaymentGUID))
                {
                    UserModel userModel = _userClient.GetUserAccountData(submitOrderViewModel.UserId);
                    userModel.CustomerPaymentGUID = submitOrderViewModel.CustomerGuid;
                    _userClient.UpdateCustomerAccount(userModel);

                    UserViewModel userViewModel = GetFromSession<UserViewModel>(WebStoreConstants.UserAccountKey);

                    if (string.IsNullOrEmpty(userViewModel.CustomerPaymentGUID))
                    {
                        userViewModel.CustomerPaymentGUID = submitOrderViewModel.CustomerGuid;
                        SaveInSession(WebStoreConstants.UserAccountKey, userViewModel);
                    }
                }

                model.Total = _paymentAgent.FormatOrderTotal(cartModel.Total);

                ZnodeLogging.LogMessage(" GetPaymentResponse OrderNumber: " + cartModel.OrderNumber+ "  ", ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error,model);

                return _paymentAgent.ProcessPayNow(model);
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in GetPaymentResponse method for OrderNumber " + cartModel?.OrderNumber + " is " + ex.Message, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                throw;
            }
        }

        //Perform calculation on shopping cart items
        public override ShoppingCartModel EnsureShoppingCartCalculations(ShoppingCartModel cartModel, SubmitOrderViewModel submitOrderViewModel)
        {
            try
            {
                //Check the order calculated correctly. i.e. total, tax cost and shipping cost calculated against order
                //This condition evaluates to be always true for COD
                //Taxcost gets zero incase of multitab scenario. ie. Checkout page and Cart page
                //Shipping and taxes do not get mapped incase the shoppingcartModel is fetched from cookie instead of session
                //If voucher is applied then calculate the voucher against order in calculation
                cartModel.IsCalculateVoucher = (IsNotNull(cartModel?.Vouchers) && cartModel?.Vouchers.Count > 0) ? true : false;

                //Perform calculation on cart item
                ShoppingCartModel calculatedCartModel = GetClient<PHShoppingCartClient>().Calculate(cartModel);
                var OptionalFee = calculatedCartModel?.Custom5;


                if (IsNotNull(calculatedCartModel))
                {
                    //Map calculatation related properties from calculated shopping cart to shoppingcart which pass to create order
                    cartModel = MapCalculatedCartToShoppingCart(cartModel, calculatedCartModel);
                    cartModel.Custom5 = OptionalFee;
                }

                return cartModel;
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in EnsureShoppingCartCalculations method for OrderNumber " + cartModel?.OrderNumber + " is " + ex.Message, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                throw;
            }
        }

        //Set billing and shipping address
        public override AddressViewModel SetAddressByAddressType(string type, int addressId, AddressListViewModel addressListViewModel)
        {
            if (addressId == 0 || (addressListViewModel.AddressList == null || addressListViewModel.AddressList.Count == 0))
            {
                if (type.Equals(WebStoreConstants.ShippingAddressType, StringComparison.InvariantCultureIgnoreCase))
                {
                    return addressListViewModel.ShippingAddress;
                }
                else
                {
                    return addressListViewModel.BillingAddress;
                }
            }
            else
            {
                //To set the default address, when the previous address is deleted from address book.
                //This condition is used when duplicate tab is opened and in the address book new address is been added and set as default also, previous address needs to be deleted.
                AddressViewModel address = addressListViewModel?.AddressList?.FirstOrDefault(x => x.AddressId == addressId);
                if (Equals(address, null))
                {
                    if (type.Equals(WebStoreConstants.ShippingAddressType, StringComparison.InvariantCultureIgnoreCase))
                        return addressListViewModel?.AddressList?.FirstOrDefault(x => x.IsDefaultShipping);

                    if (type.Equals(WebStoreConstants.BillingAddressType, StringComparison.InvariantCultureIgnoreCase))
                        return addressListViewModel?.AddressList?.FirstOrDefault(x => x.IsDefaultBilling);
                }
                return address;
            }
        }
        #endregion





        #region Private Methods



        #endregion
    }
}