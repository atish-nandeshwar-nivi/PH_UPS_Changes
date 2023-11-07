using System.Collections.Generic;
using System.Linq;
using Znode.Engine.Api.Models;
using Znode.Api.Model.Custom;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.Api.Custom.Maps
{
    public static class SampleMap
    {
        public static CustomPortalDetailListModel ToListModel(IList<ZnodePortal> portalListEntity, List<CustomPortalDetailModel> customPortalList)
        {
            CustomPortalDetailListModel portalList = new CustomPortalDetailListModel();
            portalList.CustomPortalDetailList = customPortalList;
            if (portalListEntity?.Count > 0)
            {
                portalList.CustomPortalDetailList.ForEach(customPortal =>
                {
                    var portal = portalListEntity.Where(portalDetails => portalDetails.PortalId == customPortal.PortalId)
                                ?.FirstOrDefault();

                    customPortal.PortalId = portal.PortalId;
                    customPortal.StoreName = portal.StoreName;
                    customPortal.CompanyName = portal.CompanyName;
                    customPortal.AdministratorEmail = portal.AdminEmail;
                    customPortal.CustomerServiceEmail = portal.CustomerServiceEmail;
                    customPortal.SalesEmail = portal.SalesEmail;
                    customPortal.CustomerServicePhoneNumber = portal.CustomerServicePhoneNumber;
                    customPortal.SalesPhoneNumber = portal.SalesPhoneNumber;
                    customPortal.IsEnableSSL = portal.UseSSL;
                    customPortal.OrderStatusId = portal.DefaultOrderStateID.GetValueOrDefault();
                    customPortal.ReviewStatus = portal.DefaultReviewStatus;
                    customPortal.ImageNotAvailablePath = portal.ImageNotAvailablePath;
                    customPortal.CopyContentPortalId = portal.CopyContentBasedOnPortalId;
                    customPortal.InStockMsg = portal.InStockMsg;
                    customPortal.OutOfStockMsg = portal.OutOfStockMsg;
                    customPortal.BackOrderMsg = portal.BackOrderMsg;
                    customPortal.DomainUrl = portal?.ZnodeDomains?.Count > 0 ? portal.ZnodeDomains.Where(x => x.IsActive && x.PortalId == portal.PortalId && x.ApplicationType == ApplicationTypesEnum.WebStore.ToString()).FirstOrDefault()?.DomainName : "#";
                    customPortal.OrderStatus = !Equals(portal.ZnodeOmsOrderState, null) && !string.IsNullOrEmpty(portal.ZnodeOmsOrderState.Description) ? portal.ZnodeOmsOrderState.Description : string.Empty;
                    customPortal.PublishCatalogId = !Equals(portal.ZnodePortalCatalogs, null) && portal.ZnodePortalCatalogs.FirstOrDefault()?.PublishCatalogId > 0 ? portal.ZnodePortalCatalogs.FirstOrDefault()?.PublishCatalogId : null;
                    customPortal.LocaleId = HelperUtility.IsNotNull(portal.ZnodePortalLocales) && HelperUtility.IsNotNull(portal.ZnodePortalLocales?.FirstOrDefault(x => x.IsDefault)) ? portal.ZnodePortalLocales.FirstOrDefault(x => x.IsDefault)?.LocaleId : portal.ZnodePortalLocales.FirstOrDefault()?.LocaleId;
                });
            }
            return portalList;
        }

        public static CustomPortalDetailModel ToModel(ZnodePortal portalEntity, CustomPortalDetailModel customPortal)
        {
            if (HelperUtility.IsNotNull(portalEntity) && HelperUtility.IsNotNull(customPortal))
            {
                customPortal.PortalId = portalEntity.PortalId;
                customPortal.StoreName = portalEntity.StoreName;
                customPortal.CompanyName = portalEntity.CompanyName;
                customPortal.AdministratorEmail = portalEntity.AdminEmail;
                customPortal.CustomerServiceEmail = portalEntity.CustomerServiceEmail;
                customPortal.SalesEmail = portalEntity.SalesEmail;
                customPortal.CustomerServicePhoneNumber = portalEntity.CustomerServicePhoneNumber;
                customPortal.SalesPhoneNumber = portalEntity.SalesPhoneNumber;
                customPortal.IsEnableSSL = portalEntity.UseSSL;
                customPortal.OrderStatusId = portalEntity.DefaultOrderStateID.GetValueOrDefault();
                customPortal.ReviewStatus = portalEntity.DefaultReviewStatus;
                customPortal.ImageNotAvailablePath = portalEntity.ImageNotAvailablePath;
                customPortal.CopyContentPortalId = portalEntity.CopyContentBasedOnPortalId;
                customPortal.InStockMsg = portalEntity.InStockMsg;
                customPortal.OutOfStockMsg = portalEntity.OutOfStockMsg;
                customPortal.BackOrderMsg = portalEntity.BackOrderMsg;
                customPortal.DomainUrl = portalEntity?.ZnodeDomains?.Count > 0 ? portalEntity.ZnodeDomains.Where(x => x.IsActive && x.PortalId == portalEntity.PortalId && x.ApplicationType == ApplicationTypesEnum.WebStore.ToString()).FirstOrDefault()?.DomainName : "#";
                customPortal.OrderStatus = !Equals(portalEntity.ZnodeOmsOrderState, null) && !string.IsNullOrEmpty(portalEntity.ZnodeOmsOrderState.Description) ? portalEntity.ZnodeOmsOrderState.Description : string.Empty;
                customPortal.PublishCatalogId = !Equals(portalEntity.ZnodePortalCatalogs, null) && portalEntity.ZnodePortalCatalogs.FirstOrDefault()?.PublishCatalogId > 0 ? portalEntity.ZnodePortalCatalogs.FirstOrDefault()?.PublishCatalogId : null;
                customPortal.LocaleId = HelperUtility.IsNotNull(portalEntity.ZnodePortalLocales) && HelperUtility.IsNotNull(portalEntity.ZnodePortalLocales?.FirstOrDefault(x => x.IsDefault)) ? portalEntity.ZnodePortalLocales.FirstOrDefault(x => x.IsDefault)?.LocaleId : portalEntity.ZnodePortalLocales.FirstOrDefault()?.LocaleId;
            }
            return customPortal;
        }

        public static CustomPortalDetailModel ToCustomModel(PortalModel portalModel, CustomPortalDetailModel customPortal)
        {
            if (HelperUtility.IsNotNull(portalModel))
            {
                if (HelperUtility.IsNull(customPortal))
                    customPortal = new CustomPortalDetailModel();

                customPortal.PortalId = portalModel.PortalId;
                customPortal.CopyContentPortalName = portalModel.CopyContentPortalName;
                customPortal.OrderStatus = portalModel.OrderStatus;
                customPortal.IsSearchIndexCreated = portalModel.IsSearchIndexCreated;
                customPortal.SelectedPortalFeatures = portalModel.SelectedPortalFeatures;
                customPortal.AvailablePortalFeatures = portalModel.AvailablePortalFeatures;
                customPortal.StoreName = portalModel.StoreName;
                customPortal.CompanyName = portalModel.CompanyName;
                customPortal.AdministratorEmail = portalModel.AdministratorEmail;
                customPortal.CustomerServiceEmail = portalModel.CustomerServiceEmail;
                customPortal.SalesEmail = portalModel.SalesEmail;
                customPortal.CustomerServicePhoneNumber = portalModel.CustomerServicePhoneNumber;
                customPortal.SalesPhoneNumber = portalModel.SalesPhoneNumber;
                customPortal.IsEnableSSL = portalModel.IsEnableSSL;
                customPortal.OrderStatusId = portalModel.OrderStatusId;
                customPortal.ReviewStatus = portalModel.ReviewStatus;
                customPortal.ImageNotAvailablePath = portalModel.ImageNotAvailablePath;
                customPortal.CopyContentPortalId = portalModel.CopyContentPortalId;
                customPortal.InStockMsg = portalModel.InStockMsg;
                customPortal.OutOfStockMsg = portalModel.OutOfStockMsg;
                customPortal.BackOrderMsg = portalModel.BackOrderMsg;
                customPortal.DomainUrl = portalModel.DomainUrl;
                customPortal.OrderStatus = portalModel.OrderStatus;
                customPortal.PublishCatalogId = portalModel.PublishCatalogId;
                customPortal.LocaleId = portalModel.LocaleId;
                customPortal.CMSThemeCSSId = portalModel.CMSThemeCSSId;
                customPortal.CMSThemeId = portalModel.CMSThemeId;
                customPortal.StoreCode = portalModel.StoreCode;
            }
            return customPortal;
        }
    }
}
