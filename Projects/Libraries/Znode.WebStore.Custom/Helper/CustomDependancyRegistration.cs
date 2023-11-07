using Autofac;
using Znode.Api.Client.Custom;
using Znode.Engine.Api.Client;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Libraries.Framework.Business;
using Znode.Webstore.Custom.Agents;
using Znode.WebStore.Custom;
using Znode.WebStore.Custom.Agents.Agents;
using Znode.WebStore.Custom.Clients.Clients;
using Znode.WebStore.Custom.Controllers;

namespace Znode.Engine.WebStore
{
    public class CustomDependancyRegistration : IDependencyRegistration
    {
        public virtual void Register(ContainerBuilder builder)
        {
            //builder.RegisterType<CustomUserController>().As<UserController>().InstancePerDependency();
            builder.RegisterType<PHCategoryController>().As<CategoryController>().InstancePerDependency();
            builder.RegisterType<PHCheckoutController>().As<CheckoutController>().InstancePerDependency();
            builder.RegisterType<PHProductController>().As<ProductController>().InstancePerDependency();
            builder.RegisterType<PHProductAgent>().As<IProductAgent>().InstancePerDependency();
            builder.RegisterType<PHShoppingCartClient>().As<IShoppingCartClient>().InstancePerDependency();
            builder.RegisterType<PHCheckoutAgent>().As<ICheckoutAgent>().InstancePerDependency();
            builder.RegisterType<PHCartAgent>().As<ICartAgent>().InstancePerDependency();
            builder.RegisterType<PHCartController>().As<CartController>().InstancePerDependency();
            builder.RegisterType<PHUserAgent>().As<IUserAgent>().InstancePerDependency();
            //builder.RegisterType<PHUserController>().As<UserController>().InstancePerDependency();
            //builder.RegisterType<PHProductController>().As<ProductController>().InstancePerDependency();
            //builder.RegisterType<PHProductAgent>().As<IProductAgent>().InstancePerDependency();
            //builder.RegisterType<PHPublishProductClient>().As<IPublishProductClient>().InstancePerDependency();
        }
        public int Order
        {
            get { return 1; }
        }
    }
}