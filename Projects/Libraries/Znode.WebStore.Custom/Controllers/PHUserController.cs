using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Engine.WebStore.ViewModels;
using Znode.WebStore.Core.Agents;

namespace Znode.WebStore.Custom.Controllers
{
    class PHUserController : UserController
    {
        #region Private Read-only members
        private readonly IUserAgent _userAgent;
        private readonly IPaymentAgent _paymentAgent;
        private readonly IImportAgent _importAgent;
        private readonly IAuthenticationHelper _authenticationHelper;
        private readonly ICartAgent _cartAgent;
        private readonly IFormBuilderAgent _formBuilderAgent;
        private readonly IPowerBIAgent _powerBIAgent;
        private readonly IRMAReturnAgent _rmaReturnAgent;
        private readonly ISaveForLaterAgent _saveForLater;
        #endregion

        #region Public Constructor        
        public PHUserController(IUserAgent userAgent, ICartAgent cartAgent, IAuthenticationHelper authenticationHelper, IPaymentAgent paymentAgent, IImportAgent importAgent, IFormBuilderAgent formBuilderAgent, IPowerBIAgent powerBIAgent) : base(userAgent, cartAgent, authenticationHelper, paymentAgent, importAgent, formBuilderAgent, powerBIAgent)
        {
            _userAgent = userAgent;
            _authenticationHelper = authenticationHelper;
            _cartAgent = cartAgent;
            _paymentAgent = paymentAgent;
            _importAgent = importAgent;
            _formBuilderAgent = formBuilderAgent;
            _powerBIAgent = powerBIAgent;
            _rmaReturnAgent = DependencyResolver.Current.GetService<IRMAReturnAgent>();
            _saveForLater = DependencyResolver.Current.GetService<ISaveForLaterAgent>();
        }
        #endregion

        //Address Book.
        //Order loss patch provided by amla
        [Authorize]
        [HttpGet]
        public override ActionResult AddressBook()
        {
            //If session expires redirect to login page.
            if (string.IsNullOrEmpty(_userAgent.GetUserViewModelFromSession()?.RoleName))
                return RedirectToAction<UserController>(x => x.Login(string.Empty));

            return View("AddressBook", _userAgent.GetAddressList());

        }
    }
}
