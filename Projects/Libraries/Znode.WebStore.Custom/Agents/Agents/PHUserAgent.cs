using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Maps;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Resources;
using Znode.Engine.klaviyo.Models;
using Znode.Engine.Klaviyo.IClient;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;

namespace Znode.WebStore.Custom.Agents.Agents
{
    class PHUserAgent : UserAgent, IUserAgent
    {
        #region protected Variables
        protected readonly ICountryClient _countryClient;
        protected readonly IWebStoreUserClient _webStoreAccountClient;
        protected readonly IWishListClient _wishListClient;
        protected readonly IUserClient _userClient;
        protected readonly IPublishProductClient _productClient;
        protected readonly ICustomerReviewClient _customerReviewClient;
        protected readonly IOrderClient _orderClient;
        protected readonly IGiftCardClient _giftCardClient;
        protected readonly IAccountClient _accountClient;
        protected readonly IAccountQuoteClient _accountQuoteClient;
        protected readonly IOrderStateClient _orderStateClient;
        protected readonly IPortalCountryClient _portalCountryClient;
        protected readonly IProductAgent _productAgent;
        protected readonly IShippingClient _shippingClient;
        protected readonly ICartAgent _cartAgent;
        protected readonly IPaymentClient _paymentClient;
        protected readonly ICustomerClient _customerClient;
        protected readonly IRoleClient _roleClient;
        protected readonly IStateClient _stateClient;
        protected readonly IPortalProfileClient _portalProfileClient;
        protected readonly HttpContext httpContext;

        #endregion
        #region Constructor
        public PHUserAgent(ICountryClient countryClient, IWebStoreUserClient webStoreAccountClient, IWishListClient wishListClient, IUserClient userClient, IPublishProductClient productClient, ICustomerReviewClient customerReviewClient, IOrderClient orderClient,
          IGiftCardClient giftCardClient, IAccountClient accountClient, IAccountQuoteClient accountQuoteClient, IOrderStateClient orderStateClient, IPortalCountryClient portalCountryClient, IShippingClient shippingClient, IPaymentClient paymentClient, ICustomerClient customerClient, IStateClient stateClient, IPortalProfileClient portalProfileClient) : base(countryClient, webStoreAccountClient, wishListClient, userClient, productClient, customerReviewClient, orderClient,
           giftCardClient, accountClient, accountQuoteClient, orderStateClient, portalCountryClient, shippingClient, paymentClient, customerClient, stateClient, portalProfileClient)
        {
            _countryClient = GetClient<ICountryClient>(countryClient);
            _webStoreAccountClient = GetClient<IWebStoreUserClient>(webStoreAccountClient);
            _wishListClient = GetClient<IWishListClient>(wishListClient);
            _userClient = GetClient<IUserClient>(userClient);
            _productClient = GetClient<IPublishProductClient>(productClient);
            _customerReviewClient = GetClient<ICustomerReviewClient>(customerReviewClient);
            _orderClient = GetClient<IOrderClient>(orderClient);
            _giftCardClient = GetClient<IGiftCardClient>(giftCardClient);
            _accountClient = GetClient<IAccountClient>(accountClient);
            _accountQuoteClient = GetClient<IAccountQuoteClient>(accountQuoteClient);
            _orderStateClient = GetClient<IOrderStateClient>(orderStateClient);
            _portalCountryClient = GetClient<IPortalCountryClient>(portalCountryClient);
            _productAgent = new ProductAgent(GetClient<CustomerReviewClient>(), GetClient<PublishProductClient>(), GetClient<WebStoreProductClient>(), GetClient<SearchClient>(), GetClient<HighlightClient>(), GetClient<PublishCategoryClient>());
            _shippingClient = GetClient<IShippingClient>(shippingClient);
            _cartAgent = new CartAgent(GetClient<ShoppingCartClient>(), GetClient<PublishProductClient>(), GetClient<AccountQuoteClient>(), GetClient<UserClient>());
            _paymentClient = GetClient<IPaymentClient>(paymentClient);
            _customerClient = GetClient<ICustomerClient>(customerClient);
            _roleClient = GetClient<RoleClient>();
            _stateClient = GetClient<IStateClient>(stateClient);
            _portalProfileClient = GetClient<IPortalProfileClient>(portalProfileClient);
            httpContext = HttpContext.Current;
        }
        #endregion

        //Authenticate the user based on User Name & Password.
        public override LoginViewModel Login(LoginViewModel model)
        {
            LoginViewModel loginViewModel;
            try
            {
                model.PortalId = PortalAgent.CurrentPortal?.PortalId;
                //Authenticate the user credentials.
                UserModel userModel = _userClient.Login(UserViewModelMap.ToLoginModel(model), GetExpands());
                if (HelperUtility.IsNotNull(userModel))
                {
                    //Check of Reset password Condition.
                    if (HelperUtility.IsNotNull(userModel.User) && !string.IsNullOrEmpty(userModel.User.PasswordToken))
                    {
                        loginViewModel = UserViewModelMap.ToLoginViewModel(userModel);
                        return ReturnErrorModel(WebStore_Resources.InvalidUserNamePassword, true, loginViewModel);
                    }
                    // Check user associated profiles.                
                    if (!userModel.Profiles.Any() && !userModel.IsAdminUser)
                        return ReturnErrorModel(WebStore_Resources.ProfileLoginFailedErrorMessage);

                    SetLoginUserProfile(userModel);

                    //Save the User Details in Session.
                    SaveInSession(WebStoreConstants.UserAccountKey, userModel.ToViewModel<UserViewModel>());
                    LoginViewModel loginModel = UserViewModelMap.ToLoginViewModel(userModel);

                    //To clear the session for CartCount session key.
                    if (!loginModel.HasError)
                        _cartAgent.ClearCartCountFromSession();

                    if (PortalAgent.CurrentPortal.IsKlaviyoEnable)
                    {
                        //Created task to post the data to klaviyo

                        Task.Run(() =>
                        {
                            PostDataToKlaviyo(userModel, httpContext);
                        });
                    }
                    return loginModel;
                }
            }
            catch (ZnodeException ex)
            {
                ZnodeLogging.LogMessage(ex, string.Empty, TraceLevel.Warning);
                switch (ex.ErrorCode)
                {
                    case 2://Error Code to Reset the Password for the first time login.
                        return ReturnErrorModel(ex.ErrorMessage, true);
                    case ErrorCodes.AccountLocked:
                        return ReturnErrorModel(WebStore_Resources.ErrorAccountLocked);
                    case ErrorCodes.LoginFailed:
                        return ReturnErrorModel(WebStore_Resources.InvalidUserNamePassword);
                    case ErrorCodes.TwoAttemptsToAccountLocked:
                        return ReturnErrorModel(WebStore_Resources.ErrorTwoAttemptsRemain);
                    case ErrorCodes.OneAttemptToAccountLocked:
                        return ReturnErrorModel(WebStore_Resources.ErrorOneAttemptRemain);
                    case ErrorCodes.AdminApproval:
                        return ReturnErrorModel(WebStore_Resources.LoginFailAdminApproval);
                    default:
                        return ReturnErrorModel(WebStore_Resources.InvalidUserNamePassword);
                }
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage(ex, string.Empty, TraceLevel.Error);
                return ReturnErrorModel(WebStore_Resources.InvalidUserNamePassword);
            }
            return ReturnErrorModel(WebStore_Resources.InvalidUserNamePassword);
        }

        // To post the data to klaviyo
        protected override void PostDataToKlaviyo(UserModel userModel, HttpContext httpContext)
        {
            HttpContext.Current = httpContext;
            IKlaviyoClient _klaviyoClient = GetComponentClient<IKlaviyoClient>(GetService<IKlaviyoClient>());
            bool identifyStatus = _klaviyoClient.IdentifyKlaviyo(MapKlaviyoIdentifyModel(userModel));
        }

        protected override IdentifyModel MapKlaviyoIdentifyModel(UserModel userModel)
        {
            if (HelperUtility.IsNull(userModel))
                return new IdentifyModel();

            return new IdentifyModel
            {
                PhoneNumber = userModel.PhoneNumber,
                City = userModel.CityName,
                Country = userModel.CountryName,
                Zip = userModel.PostalCode,
                StoreCode = userModel.StoreCode,
                StoreName = userModel.StoreName,
                UserName = userModel.UserName,
                CompanyName = userModel.CompanyName,
                PortalId = userModel.PortalId
            };
        }

        //Get recommended address using USPS service
        public override AddressListViewModel GetRecommendedAddress(AddressViewModel addressViewModel)
        {
            //Klaviyo change to store emailID in session for guest user to track
            SessionHelper.SaveDataInSession("EmailForGuest", addressViewModel.EmailAddress);
            SessionHelper.SaveDataInSession("FirstNameForGuest", addressViewModel.FirstName);
            if (PortalAgent.CurrentPortal.EnableAddressValidation)
            {
                AddressModel model = addressViewModel.ToModel<AddressModel>();
                model.PortalId = PortalAgent.CurrentPortal.PortalId;
                model.PublishStateId = (byte)PortalAgent.CurrentPortal.PublishState;
                AddressListModel listModel = _shippingClient.RecommendedAddress(model);
                return new AddressListViewModel { AddressList = listModel.AddressList.ToViewModel<AddressViewModel>().ToList() };
            }
            return new AddressListViewModel { AddressList = new List<AddressViewModel> { addressViewModel } };
        }

        //Get address list of user.
        public override AddressListViewModel GetAddressList(int userId, bool isAddressBook = false)
        {
            AddressListViewModel addressViewModel = new AddressListViewModel();
            if (userId > 0)
            {
                //Get address from cache.
                string cacheKey = $"{WebStoreConstants.UserAccountAddressList}{userId}";

                addressViewModel.UserId = userId;
                if (HelperUtility.IsNull(HttpContext.Current.Cache[cacheKey]))
                {
                    GetUserAddressList(addressViewModel, cacheKey, addressViewModel.AccountId);
                }
                addressViewModel = Helper.GetFromCache<AddressListViewModel>(cacheKey);
            }
            else
            {
                //Get user details from session and bind account and user id to addressListViewModel.
                UserViewModel userDetails = GetUserViewModelFromSession();
                if (HelperUtility.IsNotNull(userDetails))
                {
                    addressViewModel.AccountId = userDetails.AccountId.GetValueOrDefault();
                    addressViewModel.UserId = userDetails.UserId;
                    addressViewModel.RoleName = userDetails.RoleName;
                    addressViewModel.ShippingAddress = new AddressViewModel() { AspNetUserId = userDetails.AspNetUserId };
                }
                // If AspNetUserId is null then get anonymous User Address
                if (addressViewModel.UserId == 0 || addressViewModel.ShippingAddress?.AspNetUserId == null)
                {
                    return GetAnonymousUserAddress();
                }

                //Get address from cache.
                string cacheKey = $"{WebStoreConstants.UserAccountAddressList}{addressViewModel.UserId}";

                if (isAddressBook)
                {
                    Helper.ClearCache(cacheKey);
                }

                //If data is not cached make a call else get cached data.
                if (HelperUtility.IsNull(HttpContext.Current.Cache[cacheKey]))
                {
                    GetUserAddressList(addressViewModel, cacheKey, addressViewModel.AccountId);
                }

                addressViewModel = Helper.GetFromCache<AddressListViewModel>(cacheKey);
                if (HelperUtility.IsNotNull(addressViewModel))
                {
                    addressViewModel.AddressList?.ForEach(address =>
                    {
                        address.EmailAddress = !string.IsNullOrEmpty(address.EmailAddress) ? address.EmailAddress : userDetails?.Email;
                    });
                    addressViewModel.RoleName = userDetails?.RoleName;
                }
            }
            return addressViewModel;
        }
    }
}
