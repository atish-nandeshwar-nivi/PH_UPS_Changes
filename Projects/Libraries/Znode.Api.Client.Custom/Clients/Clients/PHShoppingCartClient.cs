using Newtonsoft.Json;
using System.Net;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Engine.Api.Client;
using Znode.Admin.Custom.Endpoints.Custom;
using Znode.Engine.Api.Client.Expands;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Engine.Api.Client.Sorts;
using System.Collections.ObjectModel;
using Znode.Engine.Api.Client.Endpoints;
using Znode.Engine.Api.Models.Extensions;
using Znode.Sample.Api.Model.Responses;
using Znode.Api.Model.Custom;

namespace Znode.Api.Client.Custom
{
    public class PHShoppingCartClient : ShoppingCartClient, IShoppingCartClient
    {

        public PHShoppingCartClient()
        {

        }

        public string GetOptionalFees(string omsSavedCardLineItemIds)
        {
            //Get Endpoint
            string endpoint = CustomEndpoint.GetOptionalFees(omsSavedCardLineItemIds);

            //Get response
            ApiStatus status = new ApiStatus();
            BaseResponse response = GetResourceFromEndpoint<BaseResponse>(endpoint, status);

            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);

            return !response.HasError ? response.ErrorMessage : "";
        }

        public bool UpdateOptionalFees(string omsSavedCardLineItemIds, string optionalfeesIds)
        {
            //Get Endpoint
            string endpoint = CustomEndpoint.UpdateOptionalFees();

            //Get Serialize object as a response.
            ApiStatus status = new ApiStatus();

            var data = JsonConvert.SerializeObject(new OptionalFeesParameterModel { OmsSavedCardLineItemIds = omsSavedCardLineItemIds, OptionalfeesIds = optionalfeesIds });
            BaseResponse response = PostResourceToEndpoint<BaseResponse>(endpoint, data, status);

            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);
           
            return !response.HasError;
        }

        //Performs calculations for a shopping cart.
        //CUSTOMIZATION CREATED TO TAKE TWO SELECTED SHIPPING METHODS INTO ACCOUNT WHEN CALCULATING THE CART
        public override ShoppingCartModel Calculate(ShoppingCartModel model)
        {
            //Get Endpoint
            string endpoint = CustomEndpoint.CustomCalculate();

            //Get Serialize object as a response.
            ApiStatus status = new ApiStatus();
            ShoppingCartResponse response = PostResourceToEndpoint<ShoppingCartResponse>(endpoint, JsonConvert.SerializeObject(model), status);

            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);

            return response?.ShoppingCart;
        }

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
