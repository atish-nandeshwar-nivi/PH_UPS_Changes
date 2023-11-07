using Newtonsoft.Json;
using System.Collections.ObjectModel;
using System.Net;
using Znode.Admin.Custom.Endpoints.Custom;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Client.Sorts;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Extensions;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Api.Model.Custom;
using Znode.Api.Model.Custom.Responses;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.Admin.Custom.Clients
{
    public class CustomClient : BaseClient, ICustomClient
    {
        public CustomPortalDetailListModel GetPortalList(ExpandCollection expands, FilterCollection filters, SortCollection sorts, int? pageIndex, int? pageSize)
        {
            //Create Endpoint to get the list of all portals.
            string endpoint = CustomEndpoint.GetPortalList();
            endpoint += BuildEndpointQueryString(expands, filters, sorts, pageIndex, pageSize);

            ApiStatus status = new ApiStatus();

            CustomPortalDetailListResponse response = GetResourceFromEndpoint<CustomPortalDetailListResponse>(endpoint, status);

            //Check the status of response of portal list.
            Collection<HttpStatusCode> expectedStatusCodes = new Collection<HttpStatusCode> { HttpStatusCode.OK, HttpStatusCode.NoContent };
            CheckStatusAndThrow<ZnodeException>(status, expectedStatusCodes);

            CustomPortalDetailListModel list = new CustomPortalDetailListModel { CustomPortalDetailList = response?.CustomPortalDetailList };
            list.MapPagingDataFromResponse(response);
            return list;
        }

        //Get Custom Portal Details List.
        public CustomPortalDetailListModel GetCustomPortalDetailList(ExpandCollection expands, FilterCollection filters, SortCollection sorts, int? pageIndex, int? pageSize)
        {
            //Create Endpoint to get the list of all portals.
            string endpoint = CustomEndpoint.GetCustomPortalDetailList();
            endpoint += BuildEndpointQueryString(expands, filters, sorts, pageIndex, pageSize);

            ApiStatus status = new ApiStatus();
            CustomPortalDetailListResponse response = GetResourceFromEndpoint<CustomPortalDetailListResponse>(endpoint, status);

            //Check the status of response of portal list.
            Collection<HttpStatusCode> expectedStatusCodes = new Collection<HttpStatusCode> { HttpStatusCode.OK, HttpStatusCode.NoContent };
            CheckStatusAndThrow<ZnodeException>(status, expectedStatusCodes);

            CustomPortalDetailListModel list = new CustomPortalDetailListModel { CustomPortalDetailList = response?.CustomPortalDetailList };
            list.MapPagingDataFromResponse(response);
            return list;
        }

        //Get Custom Portal details by Custom Portal Detail Id.
        public CustomPortalDetailModel GetCustomPortalDetail(int customPortalDetailId, ExpandCollection expands)
        {
            //Create Endpoint to get the Custom Portal Details.
            string endpoint = CustomEndpoint.GetCustomPortalDetail(customPortalDetailId);
            endpoint += BuildEndpointQueryString(expands);
            ApiStatus status = new ApiStatus();
            CustomPortalResponse response = GetResourceFromEndpoint<CustomPortalResponse>(endpoint, status);

            //Check the status of response of Custom Portal Detail.
            Collection<HttpStatusCode> expectedStatusCodes = new Collection<HttpStatusCode> { HttpStatusCode.OK, HttpStatusCode.NoContent };
            CheckStatusAndThrow<ZnodeException>(status, expectedStatusCodes);

            return response?.PortalDetail;
        }

        //Insert the Customized Portal Details.
        public CustomPortalDetailModel InsertCustomPortalDetail(CustomPortalDetailModel portalDetailModel)
        {
            //Create Endpoint to Custom Portal Detail.
            string endpoint = CustomEndpoint.InsertCustomPortalDetail();

            ApiStatus status = new ApiStatus();
            CustomPortalResponse response = PostResourceToEndpoint<CustomPortalResponse>(endpoint, JsonConvert.SerializeObject(portalDetailModel), status);

            //Check the status of response of Custom Portal Detail.
            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.Created);
            return response?.PortalDetail;
        }

        //Update Custom Portal Details.
        public CustomPortalDetailModel UpdateCustomPortalDetail(CustomPortalDetailModel customPortalDetailModel)
        {
            //Create Endpoint to Update Custom Portal Details
            string endpoint = CustomEndpoint.UpdateCustomPortalDetail();

            ApiStatus status = new ApiStatus();
            CustomPortalResponse response = PutResourceToEndpoint<CustomPortalResponse>(endpoint, JsonConvert.SerializeObject(customPortalDetailModel), status);

            //Check the status of response of Custom Portal Detail.
            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);
            return response?.PortalDetail;

        }

        public bool DeleteCustomPortalDetail(ParameterModel customPortalDetailIds)
        {
            //Create Endpoint to Delete Custom Portal Detail.
            string endpoint = CustomEndpoint.DeleteCustomPortalDetail();

            ApiStatus status = new ApiStatus();
            TrueFalseResponse response = PostResourceToEndpoint<TrueFalseResponse>(endpoint, JsonConvert.SerializeObject(customPortalDetailIds), status);

            //Check the status of response of Custom Portal Detail.
            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);
            return response.IsSuccess;
        }
    }
}
