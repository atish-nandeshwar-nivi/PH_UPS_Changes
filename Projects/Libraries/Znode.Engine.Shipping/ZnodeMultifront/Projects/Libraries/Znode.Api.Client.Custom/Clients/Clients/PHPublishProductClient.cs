using Newtonsoft.Json;
using System.Collections.ObjectModel;
using System.Net;
using Znode.Admin.Custom.Endpoints.Custom;
using Znode.Api.Model.Custom;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Client.Sorts;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Extensions;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Sample.Api.Model.Responses;

namespace Znode.WebStore.Custom.Clients.Clients
{
    public class PHPublishProductClient : PublishProductClient, IPublishProductClient
    {
        public WarehouseListModel GetCustomWarehouseList(ExpandCollection expands, FilterCollection filters, SortCollection sorts, int? pageIndex, int? pageSize)
        {
            //Get Endpoint.
            string endpoint = PHWarehouseEndpoint.GetCustomWarehouseList();
            endpoint += BuildEndpointQueryString(expands, filters, sorts, pageIndex, pageSize);

            //Get response
            ApiStatus status = new ApiStatus();
            WarehouseListResponse response = GetResourceFromEndpoint<WarehouseListResponse>(endpoint, status);

            Collection<HttpStatusCode> expectedStatusCodes = new Collection<HttpStatusCode> { HttpStatusCode.OK, HttpStatusCode.NoContent };
            CheckStatusAndThrow<ZnodeException>(status, expectedStatusCodes);

            WarehouseListModel list = new WarehouseListModel { WarehouseList = response?.WarehouseList };
            list.MapPagingDataFromResponse(response);

            return list;
        }

        //Get list of free freight sku
        public FreeFreightSkuListResponse GetAssociatedInventory(FreeFreightSkuList freeFreightSkuList)
        {
            string endpoint = PHWarehouseEndpoint.GetAssociatedInventory();

            ApiStatus status = new ApiStatus();
            FreeFreightSkuListResponse response = PostResourceToEndpoint<FreeFreightSkuListResponse>(endpoint, JsonConvert.SerializeObject(freeFreightSkuList), status);

            Collection<HttpStatusCode> expectedStatusCodes = new Collection<HttpStatusCode> { HttpStatusCode.OK, HttpStatusCode.NoContent };
            CheckStatusAndThrow<ZnodeException>(status, expectedStatusCodes);

            FreeFreightSkuListResponse freeFreightSkuListResponse = new FreeFreightSkuListResponse { SkuList = response?.SkuList };

            return freeFreightSkuListResponse;
        }
    }
}
