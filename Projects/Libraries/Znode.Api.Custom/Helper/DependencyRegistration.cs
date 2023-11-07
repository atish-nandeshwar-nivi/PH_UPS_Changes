using Autofac;
using Znode.Api.Client.Custom;
using Znode.Api.Custom.Service;
using Znode.Api.Custom.Service.Service;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Controllers.OMS;
using Znode.Engine.Services;
using Znode.Engine.Shipping.Custom;
using Znode.Engine.Shipping.Custom.Interface;
using Znode.Engine.Shipping.Custom.Maps;
using Znode.Engine.ShoppingCart.Custom;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.Framework.Business;

namespace Znode.Api.Custom.Helper
{
    public class DependencyRegistration : IDependencyRegistration
    {
        /// <summary>
        /// Register the Dependency Injection types.
        /// </summary>
        /// <param name="builder">Autofac Container Builder</param>
        public virtual void Register(ContainerBuilder builder)
        {
            builder.RegisterType<CustomPortalService>().As<ICustomPortalService>().InstancePerRequest();
            builder.RegisterType<PHProductFeedService>().As<IProductFeedService>().InstancePerRequest();
            builder.RegisterType<CustomShoppingCartService>().As<IShoppingCartService>().InstancePerRequest();
            builder.RegisterType<PHShoppingCartClient>().As<IShoppingCartClient>().InstancePerRequest();
            builder.RegisterType<CustomShoppingCartMap>().As<ICustomShoppingCartMap>().InstancePerRequest();
            builder.RegisterType<CustomShoppingCart>().As<IZnodeShoppingCart>().InstancePerRequest();
            builder.RegisterType<CustomCheckout>().As<IZnodeCheckout>().InstancePerRequest();
            builder.RegisterType<PHPublishProductService>().As<IPublishProductService>().InstancePerRequest();
            builder.RegisterType<PHOrderClient>().As<IOrderClient>().InstancePerRequest();
            builder.RegisterType<PHOrderController>().As<OrderController>().InstancePerRequest();
            builder.RegisterType<CustomOrderService>().As<IOrderService>().InstancePerRequest();
            builder.RegisterType<CustomOrderReceipt>().As<IZnodeOrderReceipt>().InstancePerRequest();
            //builder.RegisterType<PHOrderService>().As<IOrderService>().InstancePerRequest();
            //Here override znode base code method by injecting dependancy mention as below.
            //"In CustomPortalService.cs we have override 'DeletePortal()' of znode base code".
            //builder.RegisterType<CustomPortalService>().As<IPortalService>().InstancePerRequest();
        }

        /// <summary>
        /// Order method represents Dependency Injection Registration Order.
        /// For znode base code Library the DI registration order set to 0.
        /// For custom code library the DI registration order should be incremental.
        /// </summary>
        public int Order
        {
            get { return 1; }
        }
    }
}
