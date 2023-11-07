using System;
using System.Web.Mvc;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.ViewModels;
using Znode.WebStore.Core.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Webstore.Custom.Agents;
using Znode.Engine.Core.ViewModels;
using System.Linq;
using Znode.WebStore.Custom.ViewModel;

namespace Znode.WebStore.Custom
{
    public class PHCartController : CartController
    {
        #region Private Variables
        private readonly ICartAgent _cartAgent;
        private readonly IWSPromotionAgent _promotionAgent;
        private readonly string shoppingCartView = "Cart";
        private readonly string shoppingCart = "_shoppingCart";
        #endregion

        #region Constructor
        public PHCartController(ICartAgent cartAgent, IPortalAgent portalAgent, IWSPromotionAgent promotionAgent)
            : base(cartAgent, portalAgent, promotionAgent)
        {
            _cartAgent = cartAgent;
            _promotionAgent = promotionAgent;

        }
        #endregion

        //CUSTOMIZATION: Checkout page form is set to submit to this endpoint. Added "SpecialFees" argument and error handling."
        [HttpPost]
        [ValidateAntiForgeryToken]
        public virtual ActionResult UpdateQuantityOfCartWithFees(string guid, string quantity, int productId = 0, string specialfeeids = "")
        {
            AddToCartViewModel cartView = ((PHCartAgent)_cartAgent).UpdateQuantityOfCartItemWithFees(guid, quantity, productId, specialfeeids);
            CustomCartViewModel customCartData = new CustomCartViewModel();
            customCartData.CartViewModel = _cartAgent.GetCart(false, false);
            customCartData.CartViewModel.ShippingModel = _promotionAgent.GetPromotionListByPortalId(PortalAgent.CurrentPortal.PortalId);

            if (cartView.HasError)
            {
                var cartItem = customCartData.CartViewModel.ShoppingCartItems.FirstOrDefault(p => p.SKU == cartView.SKU);
                cartItem.HasError = cartView.HasError;
                cartItem.ErrorMessage = cartView.ErrorMessage;
            }

            return PartialView(shoppingCart, customCartData.CartViewModel);
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            filterContext.ExceptionHandled = true;

            var error = filterContext.Exception.Message;
            //Log the error!!
            //_Logger.Error(filterContext.Exception);

            //Redirect or return a view, but not both.
            //filterContext.Result = RedirectToAction("Index", "ErrorHandler");
            // OR 
            //filterContext.Result = new ViewResult
            //{
            //    ViewName = "~/Views/Themes/EquinaviaB2C/Views/Shared/ErrorPage.cshtml"
            //};
        }
    }
}
