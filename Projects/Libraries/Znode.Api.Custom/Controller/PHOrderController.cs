using System;
using System.Diagnostics;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Znode.Engine.Api.Cache;
using Znode.Engine.Api.Helper;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Engine.Services;
using Znode.Libraries.Framework.Business;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;
using Znode.Engine.Api.Controllers.OMS;
using Znode.Libraries.ECommerce.Utilities;
using System.Linq;
using Znode.Api.Model.Custom.Request;
using Znode.Api.Custom.Cache.ICache;
using Znode.Api.Custom.Cache.Cache;

namespace Znode.Api.Custom
{
    public class PHOrderController : OrderController
    {
        #region Private Variables
        private readonly IPHOrderCache _orderCache;
        private readonly IOrderService _orderService;
        private readonly IShippingCache _shippingcache;
        private readonly IShippingService _shippingservice;
        #endregion

        #region Constructor
        public PHOrderController(IOrderService orderService)
        : base(orderService)
        {
            _shippingservice = ZnodeDependencyResolver.GetService<IShippingService>();
            _orderService = orderService;
            _orderCache = new PHOrderCache(_orderService);
            _shippingcache = new ShippingCache(_shippingservice);
        }
        #endregion

        #region Public Methods

        /// <summary>
        /// Create new order.
        /// </summary>
        /// <param name="shoppingCartModel">shopping cart model.</param>
        /// <returns>Creates new order.</returns>
        [ResponseType(typeof(OrderResponse))]
        [HttpPost, ValidateModel]
        public HttpResponseMessage CustomCreate([FromBody] ShoppingCartModel shoppingCartModel)
        {
            HttpResponseMessage response;
            try
            {
                //CUSTOMIZATION: SHIPPING.CUSTOM1 WILL HAVE THE SECOND SHIPPING METHOD ID. IT IS CONVERTED TO A SHIPPING CLASS AND METHOD HERE.
                ShippingListModel list = _shippingservice.GetShippingList(null, new FilterCollection(), null, null);
                int Shipping2 = 0;
                if (shoppingCartModel.Shipping.Custom1 != null)
                {
                    int.TryParse(shoppingCartModel.Shipping.Custom1.ToString(), out Shipping2);
                    if (Shipping2 > 0)
                    {
                        ShippingModel m = list.ShippingList.FirstOrDefault(o => o.ShippingId == Shipping2);
                        if (m != null)
                        {
                            shoppingCartModel.Shipping.Custom1 = m.ClassName;
                            shoppingCartModel.Shipping.Custom2 = m.ShippingCode;
                        }

                    }
                }
                // END OF CUSTOMIZATION

                OrderModel order = _orderService.CreateOrder(shoppingCartModel);

                response = IsNotNull(order) ? CreateCreatedResponse(new OrderResponse { Order = order }) : CreateNoContentResponse();
            }
            catch (ZnodeException ex)
            {
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Warning);
                response = CreateInternalServerErrorResponse(new OrderResponse { HasError = true, ErrorMessage = ex.Message, ErrorCode = ex.ErrorCode });
            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new OrderResponse { HasError = true, ErrorMessage = ex.Message });
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
            }
            return response;
        }


        /// <summary>
        /// Get the list of all Orders.
        /// </summary>
        /// <returns>Returns list of all orders.</returns>
        [ResponseType(typeof(OrderListResponse))]
        [HttpGet]
        public HttpResponseMessage GetOrderList(string OrderState)
        {
            HttpResponseMessage response;
            try
            {
                string data = _orderCache.GetOrderList(OrderState, RouteUri, RouteTemplate);
                response = string.IsNullOrEmpty(data) ? CreateNoContentResponse() : CreateOKResponse<OrderListResponse>(data);
            }
            catch (ZnodeException ex)
            {
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Warning);
                response = CreateInternalServerErrorResponse(new OrderListResponse { HasError = true, ErrorMessage = ex.Message, ErrorCode = ex.ErrorCode });
            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new OrderListResponse { HasError = true, ErrorMessage = ex.Message });
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
            }
            return response;
        }
        #endregion
    }
}
