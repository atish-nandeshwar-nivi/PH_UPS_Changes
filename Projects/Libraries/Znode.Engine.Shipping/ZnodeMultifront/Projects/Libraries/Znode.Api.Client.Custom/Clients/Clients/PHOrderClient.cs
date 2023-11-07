using Newtonsoft.Json;
using System.Collections.ObjectModel;
using System.Net;
using Znode.Engine.Api.Client.Endpoints;
using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Client.Sorts;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Extensions;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Engine.Api.Client;
using Znode.Admin.Custom.Endpoints.Custom;

namespace Znode.Api.Client.Custom 
{
    public class PHOrderClient : OrderClient, IOrderClient
    {
        public PHOrderClient()
        {

        }

        // Create new order.
        public override OrderModel CreateOrder(ShoppingCartModel model)
        {
            //Get Endpoint.
            string endpoint = CustomEndpoint.CustomCreateOrder();

            //Get response
            ApiStatus status = new ApiStatus();
            OrderResponse response = PostResourceToEndpoint<OrderResponse>(endpoint, JsonConvert.SerializeObject(model), status);

            Collection<HttpStatusCode> expectedStatusCodes = new Collection<HttpStatusCode> { HttpStatusCode.OK, HttpStatusCode.Created };
            CheckStatusAndThrow<ZnodeException>(status, expectedStatusCodes);

            return response?.Order;
        }
    }
}
