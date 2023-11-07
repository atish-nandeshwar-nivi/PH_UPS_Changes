using System.Collections.Generic;
using System.Linq;
using Znode.Admin.Custom.Clients;
using Znode.Admin.Custom.ViewModels;
using Znode.Engine.Admin.Agents;
using Znode.Engine.Admin.Extensions;
using Znode.Engine.Admin.Helpers;
using Znode.Engine.Admin.Maps;
using Znode.Engine.Admin.Models;
using Znode.Engine.Admin.ViewModels;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Client.Sorts;
using Znode.Api.Model.Custom;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Resources;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;

namespace Znode.Admin.Custom.Agents
{
    public class CustomPortalAgent : StoreAgent, ICustomPortalAgent
    {
        #region Private Variables
        private readonly ICustomClient _customPortalClient;

        #endregion

        #region Constructor
        public CustomPortalAgent(IPortalClient portalClient, IEcommerceCatalogClient ecommerceCatalogClient, IThemeClient themeClient, IDomainClient domainClient, IPriceClient priceClient, IOrderStateClient orderStateClient,
            IProductReviewStateClient productReviewClient, IPortalProfileClient portalProfileClient, IWarehouseClient warehouseClient, ICSSClient cssClient, IManageMessageClient manageMessageClient,
            IContentPageClient contentPageClient, ITaxClassClient taxClassClient, IPaymentClient paymentClient, IShippingClient shippingClient, IPortalCountryClient portalCountryClient, ICustomerAgent customAgent, ITagManagerClient tagManagerClient,IGeneralSettingClient generalSettingClient)
            : base(portalClient, ecommerceCatalogClient, themeClient, domainClient, priceClient, orderStateClient,
            productReviewClient, portalProfileClient, warehouseClient, cssClient, manageMessageClient,
            contentPageClient, taxClassClient, paymentClient, shippingClient, portalCountryClient, tagManagerClient, generalSettingClient)
        {

            _customPortalClient = GetClient<CustomClient>();
        }
        #endregion

        #region Public Methods
        //Get Store List.
        public CustomPortalDetailListViewModel GetStoreList(FilterCollection filters = null, SortCollection sorts = null, int? pageIndex = default(int?), int? pageSize = default(int?))
        {
            CustomPortalDetailListModel storeList = _customPortalClient.GetPortalList(new ExpandCollection { ZnodePortalEnum.ZnodeDomains.ToString().ToLower() }, filters, sorts, pageIndex, pageSize);

            CustomPortalDetailListViewModel storeListViewModel = new CustomPortalDetailListViewModel { CustomPortalDetailList = storeList?.CustomPortalDetailList?.ToViewModel<CustomPortalDetailViewModel>().ToList() };

            SetListPagingData(storeListViewModel, storeList);

            //Set the Tool Menus for Store List Grid View.
            SetStoreListToolMenus(storeListViewModel);
            return storeListViewModel;
        }

        //Get Custom Portal Details List.
        public CustomPortalDetailListViewModel GetCustomPortalDetailList(FilterCollection filters = null, SortCollection sorts = null, int? pageIndex = default(int?), int? pageSize = default(int?))
        {
            CustomPortalDetailListModel portalDetailModel = _customPortalClient.GetCustomPortalDetailList(null, filters, sorts, pageIndex, pageSize);
            CustomPortalDetailListViewModel customPortalDetailModel = new CustomPortalDetailListViewModel { CustomPortalDetailList = (portalDetailModel?.CustomPortalDetailList?.Count > 0) ? portalDetailModel.CustomPortalDetailList.ToViewModel<CustomPortalDetailViewModel>().ToList() : new List<CustomPortalDetailViewModel>() };
            SetListPagingData(customPortalDetailModel, portalDetailModel);

            //Set the Tool Menus for Store List Grid View.
            SetCustomPortalListToolMenus(customPortalDetailModel);
            return customPortalDetailModel;
        }

        //Get Custom Portal details by Custom Portal detail Id.
        public CustomPortalDetailViewModel GetCustomPortalDetail(int customPortalId)
        {
            CustomPortalDetailModel customPortalModel = _customPortalClient.GetCustomPortalDetail(customPortalId, new ExpandCollection { ZnodePortalEnum.ZnodeOmsOrderState.ToString().ToLower() });
            CustomPortalDetailViewModel customPortalViewModel = customPortalModel?.ToViewModel<CustomPortalDetailViewModel>();

            customPortalViewModel.AvailableStoreFeatureList = StoreViewModelMap.ToStoreFeatureListViewModel(customPortalModel.AvailablePortalFeatures?.ToList());
            customPortalViewModel.SelectedStoreFeatureList = StoreViewModelMap.ToStoreFeatureListViewModel(customPortalModel.SelectedPortalFeatures?.ToList());
            customPortalViewModel.PersistentCartEnabled = IsNotNull(customPortalModel.AvailablePortalFeatures) ? (bool)customPortalModel.AvailablePortalFeatures.Where(x => x.PortalFeatureName == HelperUtility.StoreFeature.Persistent_Cart.ToString())?.FirstOrDefault()?.PortalFeatureValue : false;

            GetStoreFeatureValue(GetStoreInformation(customPortalViewModel));
            return customPortalViewModel;
        }

        //Insert the Customized Portal Details.
        public CustomPortalDetailViewModel InsertCustomPortalDetail(CustomPortalDetailViewModel portalDetailModel)
        {
            portalDetailModel.DefaultCurrency = DefaultSettingHelper.DefaultCurrency;
            portalDetailModel.DefaultWeightUnit = DefaultSettingHelper.DefaultWeightUnit;
            portalDetailModel.DefaultDimensionUnit = DimensionUnit.CM.ToString();
            return _customPortalClient.InsertCustomPortalDetail(portalDetailModel.ToModel<CustomPortalDetailModel>())?.ToViewModel<CustomPortalDetailViewModel>();
        }

        //Update Custom Portal Details.
        public bool UpdateCustomPortalDetail(CustomPortalDetailViewModel portalDetailModel)
            => IsNotNull(_customPortalClient.UpdateCustomPortalDetail(portalDetailModel?.ToModel<CustomPortalDetailModel>())) ? true : false;

        #endregion

        #region Private Methods
        //Set the Tool Menus for Store List Grid View.
        private void SetStoreListToolMenus(CustomPortalDetailListViewModel model)
        {
            if (IsNotNull(model))
            {
                model.GridModel = new GridModel();
                model.GridModel.FilterColumn = new FilterColumnListModel();
                model.GridModel.FilterColumn.ToolMenuList = new List<ToolMenuModel>();
                model.GridModel.FilterColumn.ToolMenuList.Add(new ToolMenuModel { DisplayText = Admin_Resources.ButtonDelete, JSFunctionName = "EditableText.prototype.DialogDelete('StoreDeletePopup');", ControllerName = "Store", ActionName = "Delete" });
            }
        }

        //Set the Tool Menus for Custom Portal List Grid View.
        private void SetCustomPortalListToolMenus(CustomPortalDetailListViewModel model)
        {
            if (IsNotNull(model))
            {
                model.GridModel = new GridModel();
                model.GridModel.FilterColumn = new FilterColumnListModel();
                model.GridModel.FilterColumn.ToolMenuList = new List<ToolMenuModel>();
                model.GridModel.FilterColumn.ToolMenuList.Add(new ToolMenuModel { DisplayText = Admin_Resources.ButtonDelete, JSFunctionName = "EditableText.prototype.DialogDelete('CustomStoreDeletePopup');", ControllerName = "CustomPortal", ActionName = "DeleteCustomPortal" });
            }
        }

        public CustomPortalDetailViewModel SetStoreInformation(StoreViewModel model)
        {
            return new CustomPortalDetailViewModel
            {
                CatalogList = model.CatalogList,
                //Bind the order status list.
                OrderStatusList = model.OrderStatusList,
                //Bind theme list.
                ThemeList = model.ThemeList,
                //Bind CSS list.
                CSSList = model.CatalogList,
                //Bind features.
                AvailableStoreFeatureList = model.AvailableStoreFeatureList,
                //Bind the customer review status list.
                CustomerReviewStatusList = model.CustomerReviewStatusList,

                PortalList = model.PortalList
            };
        }

        //Set the value of store feature.
        private void GetStoreFeatureValue(StoreViewModel storeViewModel)
        {
            if (storeViewModel?.AvailableStoreFeatureList?.Count > 0 && storeViewModel?.SelectedStoreFeatureList?.Count > 0)
            {
                foreach (StoreFeatureViewModel storeFeature in storeViewModel.AvailableStoreFeatureList)
                {
                    foreach (StoreFeatureViewModel item in storeViewModel.SelectedStoreFeatureList)
                    {
                        if (item.StoreFeatureId == storeFeature.StoreFeatureId)
                            storeFeature.StoreFeatureValue = true;
                    }
                }
            }
        }
        #endregion
    }
}
