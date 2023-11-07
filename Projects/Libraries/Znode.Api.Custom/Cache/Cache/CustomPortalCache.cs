using Znode.Api.Custom.Service;
using Znode.Engine.Api.Cache;
using Znode.Engine.Api.Models.Extensions;
using Znode.Api.Model.Custom;
using Znode.Api.Model.Custom.Responses;

namespace Znode.Api.Custom.Cache
{
    public class CustomPortalCache : BaseCache, ICustomPortalCache
    {
        #region Private Variables
        private readonly ICustomPortalService _portalService;
        #endregion

        #region Constructor
        public CustomPortalCache(ICustomPortalService portalService)
        {
            _portalService = portalService;
        }
        #endregion

        #region Public Methods
        public string GetSamplePortalList(string routeUri, string routeTemplate)
        {
            string data = GetFromCache(routeUri);
            if (string.IsNullOrEmpty(data))
            {
                //Get data from service
                CustomPortalDetailListModel portalList = _portalService.GetPortalList(Expands, Filters, Sorts, Page);
                if (portalList?.CustomPortalDetailList?.Count > 0)
                {
                    //Create Response and insert in to cache
                    CustomPortalDetailListResponse response = new CustomPortalDetailListResponse { CustomPortalDetailList = portalList.CustomPortalDetailList };

                    response.MapPagingDataFromModel(portalList);
                    data = InsertIntoCache(routeUri, routeTemplate, response);
                }
            }
            return data;
        }

        public string GetCustomPortalDetailList(string routeUri, string routeTemplate)
        {
            string data = GetFromCache(routeUri);
            if (string.IsNullOrEmpty(data))
            {
                //Get data from service
                CustomPortalDetailListModel customPortalDetailList = _portalService.GetCustomPortalDetailList(Expands, Filters, Sorts, Page);
                if (customPortalDetailList?.CustomPortalDetailList?.Count > 0)
                {
                    //Create Response and insert in to cache
                    CustomPortalDetailListResponse response = new CustomPortalDetailListResponse { CustomPortalDetailList = customPortalDetailList.CustomPortalDetailList };

                    response.MapPagingDataFromModel(customPortalDetailList);
                    data = InsertIntoCache(routeUri, routeTemplate, response);
                }
            }
            return data;
        }

        public string GetCustomPortalDetail(int portalDetailId, string routeUri, string routeTemplate)
        {
            string data = GetFromCache(routeUri);
            if (string.IsNullOrEmpty(data))
            {
                //Get data from custom Portal Detail service.
                CustomPortalDetailModel portalDetailModel = _portalService.GetCustomPortalDetail(portalDetailId, Expands);
                if (!Equals(portalDetailModel, null))
                {
                    //Create Response and insert in to cache
                    CustomPortalResponse response = new CustomPortalResponse { PortalDetail = portalDetailModel };
                    data = InsertIntoCache(routeUri, routeTemplate, response);
                }
            }
            return data;
        }
        #endregion
    }
}
