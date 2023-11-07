using System;
using System.Linq;
using Znode.Admin.Custom.ViewModel;
using Znode.Engine.Admin.ViewModels;
using Znode.Api.Model.Custom;

namespace Znode.Admin.Custom.Maps
{
    public static class CustomPortalViewModelMap
    {
        public static SamplePortalListViewModel ToListViewModel(SamplePortalListModel portalListModel)
        {
            if (portalListModel?.PortalList?.Count > 0)
            {
                SamplePortalListViewModel storeListViewModel = new SamplePortalListViewModel
                {
                    StoreList = portalListModel.PortalList.Select(
                        portalModel => new StoreViewModel
                        {
                            PortalId = portalModel.PortalId,
                            StoreName = portalModel.StoreName,
                            CompanyName = portalModel.CompanyName,
                            AdministratorEmail = portalModel.AdministratorEmail,
                            ImageNotAvailablePath = portalModel.ImageNotAvailablePath,
                            CustomerServiceEmail = portalModel.CustomerServiceEmail,
                            CustomerServicePhoneNumber = portalModel.CustomerServicePhoneNumber,
                            SalesEmail = portalModel.SalesEmail,
                            SalesPhoneNumber = portalModel.SalesPhoneNumber,
                            DomainUrl = portalModel.DomainUrl
                        }).ToList()
                };
                storeListViewModel.Page = Convert.ToInt32(portalListModel.PageIndex);
                storeListViewModel.RecordPerPage = Convert.ToInt32(portalListModel.PageSize);
                storeListViewModel.TotalPages = Convert.ToInt32(portalListModel.TotalPages);
                storeListViewModel.TotalResults = Convert.ToInt32(portalListModel.TotalResults);
                return storeListViewModel;
            }
            return new SamplePortalListViewModel();
        }
    }
}
