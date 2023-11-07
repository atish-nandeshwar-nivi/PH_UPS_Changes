using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Api.Model.Custom.Request;

namespace Znode.Api.Custom.Cache.ICache
{
    interface IPHOrderCache 
    {
        /// <summary>
        /// Get the list of all orders.
        /// </summary>
        /// <param name="routeUri">URI to route.</param>
        /// <param name="routeTemplate">Template of route.</param>
        /// <returns>list of order in string format by serializing it.</returns>
        string GetOrderList(string OrderState, string routeUri, string routeTemplate);
    }
}
