using Znode.Engine.Admin.Agents;
using Znode.Engine.Api.Client;

namespace Znode.Admin.Custom.Agents
{
    public class CustomUserAgent : UserAgent
    {
        public CustomUserAgent(IUserClient userClient, IPortalClient portalClient, IAccountClient accountClient, IRoleClient roleClient, IDomainClient domainClient, IStateClient stateClient, IGlobalAttributeEntityClient globalAttributeEntityClient, IShoppingCartClient shoppingCartClient)
           : base(userClient, portalClient, accountClient, roleClient, domainClient, stateClient, globalAttributeEntityClient, shoppingCartClient)
        {

        }

        //"Sample for znode base code override".
        //Here we have over ride the log out method of znode base code i.e. UserAgent.
        //Like wise you can override any znode base code.
        public override void Logout()
        {
            base.Logout();
        }
    }
}
