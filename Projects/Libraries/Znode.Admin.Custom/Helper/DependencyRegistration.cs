using Autofac;
using Znode.Admin.Custom.Agents;
using Znode.Engine.Admin.Agents;
using Znode.Libraries.Framework.Business;

namespace Znode.Admin.Custom.Helper
{
    public class DependencyRegistration : IDependencyRegistration
    {
        /// <summary>
        /// Register the Dependency Injection types.
        /// </summary>
        /// <param name="builder">Autofac Container Builder</param>
        public virtual void Register(ContainerBuilder builder)
        {
            builder.RegisterType<CustomPortalAgent>().As<ICustomPortalAgent>().InstancePerLifetimeScope();

            //Here override znode base code method by injecting dependancy metion as below.
            //"In CustomUserAgent.cs we have override 'LogOut()' of znode base code" .
            builder.RegisterType<CustomUserAgent>().As<IUserAgent>().InstancePerLifetimeScope();
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
