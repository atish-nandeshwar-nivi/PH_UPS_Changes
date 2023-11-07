using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Api.Custom.Cache.ICache;
using Znode.Api.Model.Custom.Request;
using Znode.Engine.Api.Cache;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Extensions;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Services;
using Znode.Libraries.ECommerce.Utilities;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;

namespace Znode.Api.Custom.Cache.Cache
{
    public class PHOrderCache : BaseCache, IPHOrderCache
    {

        #region Private Variables
        private readonly IOrderService _orderService;
        #endregion

        #region Constructor
        public PHOrderCache (IOrderService orderService)
        {
            _orderService = orderService;
        }
        #endregion  
        /// <summary>
        /// New Method for order API
        /// </summary>
        /// <param name="OrderListRequest"></param>
        /// <param name="routeUri"></param>
        /// <param name="routeTemplate"></param>
        /// <returns></returns>
        public virtual string GetOrderList(string OrderState, string routeUri, string routeTemplate)
        {
            string data = GetFromCache(routeUri);
            if (string.IsNullOrEmpty(data))
            {
                //Get data from service
                FilterCollection filters = new FilterCollection();
                if (OrderState != null)
                    filters.Add(new FilterTuple("OrderState", FilterOperators.Like, OrderState));
               
                OrdersListModel orderList = _orderService.GetOrderList(Expands, filters, Sorts, Page);
                if (orderList?.Orders?.Count > 0 || IsNotNull(orderList?.CustomerName))
                {
                    OrderListResponse response = new OrderListResponse { OrderList = orderList };
                    response.MapPagingDataFromModel(orderList);
                    data = InsertIntoCache(routeUri, routeTemplate, response);
                }
            }
            return data;
        }
    }
}
