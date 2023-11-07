using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.Services;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Resources;

namespace Znode.Api.Custom.Service.Service
{
    public class PHOrderService : OrderService
    {
        private readonly ZnodeRepository<ZnodeOmsOrderDetail> _omsOrderDetailRepository;
        #region Constructor
        public PHOrderService() : base()
        {
            _omsOrderDetailRepository = new ZnodeRepository<ZnodeOmsOrderDetail>();
        }
        #endregion Constructor

        public override OrderModel UpdateOrder(OrderModel model)
        {
            OrderModel orderModel = new OrderModel();
            try
            {
                orderModel = base.UpdateOrder(model);
            }
            catch (Exception)
            {
                
            }
            return orderModel;
        }
    }
}
