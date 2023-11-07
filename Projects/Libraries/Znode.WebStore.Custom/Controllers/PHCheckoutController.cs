using System;
using System.Diagnostics;
using System.Web.Mvc;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Webstore.Custom.Agents;

namespace Znode.WebStore.Custom
{
    public class PHCheckoutController : CheckoutController
    {
        #region Private Read-only members
        private readonly IUserAgent _userAgent;
        private readonly ICheckoutAgent _checkoutAgent;
        private readonly ICartAgent _cartAgent;
        private readonly IPaymentAgent _paymentAgent;
        private readonly bool IsEnableSinglePageCheckout = PortalAgent.CurrentPortal.IsEnableSinglePageCheckout;
        private readonly string TotalTableView = "_TotalTable";
        private readonly string CheckoutReciept = "CheckoutReciept";
        #endregion
        public PHCheckoutAgent PHCheckAgent;

        #region Public Constructor
        public PHCheckoutController(IUserAgent userAgent, ICheckoutAgent checkoutAgent, ICartAgent cartAgent, IPaymentAgent paymentAgent)
        : base(userAgent, checkoutAgent, cartAgent, paymentAgent)
        {
            _userAgent = userAgent;
            _checkoutAgent = checkoutAgent;
            _cartAgent = cartAgent;
            _paymentAgent = paymentAgent;
            PHCheckAgent = (PHCheckoutAgent)checkoutAgent;
        }
        #endregion
       

        public override ActionResult Index(bool IsSinglePage = true)
        {
            string userOrSessionId = string.Empty;
            CartViewModel accountQuoteViewModel = null;
            if (!Equals(Request.QueryString["QuoteId"], null))
            {
                accountQuoteViewModel = _cartAgent.SetQuoteCart(Convert.ToInt32(Request.QueryString["QuoteId"]));
            }

            if (!Equals(Request.QueryString["ShippingId"], null))
            {
                _cartAgent.AddEstimatedShippingIdToCartViewModel(int.Parse(Convert.ToString(Request.QueryString["ShippingId"])));
            }
            //TODO: Manage guest mode token generation process current session based process is not secured.
            if ((User.Identity.IsAuthenticated || Convert.ToString(Request.QueryString["mode"]) == "guest"))
            {
                //passing UserOrSessionId value for token generation call
                if (User.Identity.IsAuthenticated)
                    userOrSessionId = User.Identity.Name;
                else
                    userOrSessionId = Request.Cookies["ASP.NET_SessionId"].Value;

                // This method is call to get payment Api header as store on the view
                ViewBag.PaymentApiResponseHeader = _paymentAgent.GetPaymentAuthToken(userOrSessionId, false);
                //Changes for klaviyo checkoutstart
                PHCheckAgent.PostDataToKlaviyo();
                return _cartAgent.GetCartCount() < 1 ? RedirectToAction<HomeController>(x => x.Index()) : IsEnableSinglePageCheckout ? View("SinglePage", _checkoutAgent.GetUserDetails(accountQuoteViewModel?.UserId ?? 0)) : View("MultiStepCheckout", _checkoutAgent.GetBillingShippingAddress());
            }

            return RedirectToAction("Login", "User", new { returnUrl = "~/checkout", isSinglePageCheckout = IsEnableSinglePageCheckout });
        }

        //public override ActionResult CartReview(int? shippingOptionId, int? shippingAddressId, string shippingCode, string additionalInstruction = "", bool isQuoteRequest = false, bool isCalculateCart = true, bool isPendingOrderRequest = false, string jobName = "")
        //{
        //    return PartialView("_CartReview", _cartAgent.CalculateShipping(shippingOptionId.GetValueOrDefault(), shippingAddressId.GetValueOrDefault(), shippingCode, additionalInstruction, isQuoteRequest, isCalculateCart, isPendingOrderRequest, jobName));
        //}


        //Get logged in user cart to review
        public ActionResult CustomCartReview(int? shippingOptionId, int? shippingOption2Id, int? shippingOption3Id, int? shippingAddressId, string shippingCode, string additionalInstruction = "", string omsSavedCardLineItemIds = "", string optionalfeesIds = "")//Atish ups
        {
           
            if (omsSavedCardLineItemIds != "")
            {
                var updated = ((PHCartAgent)_cartAgent).UpdateOptionalFees(omsSavedCardLineItemIds, optionalfeesIds);
            }
            return PartialView("_CartReview", ((PHCartAgent)_cartAgent).CustomCalculateShipping(shippingOptionId.GetValueOrDefault(), shippingOption2Id.GetValueOrDefault(), shippingOption3Id.GetValueOrDefault(), shippingAddressId.GetValueOrDefault(), shippingCode, additionalInstruction));//Atish ups
        }

        [HttpPost]
        public ActionResult UpdateOptionalFees(string omsSavedCardLineItemIds, string optionalfeesIds)
        {
            var updated = ((PHCartAgent)_cartAgent).UpdateOptionalFees(omsSavedCardLineItemIds, optionalfeesIds);

            return Json(new
            {
                isSuccess = updated,
                message = updated? "success" : "fail",
            }, JsonRequestBehavior.AllowGet);
        }


        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public virtual ActionResult UpdateCheckoutWithFees(string guid, string quantity, int productId = 0, string specialfeeids = "")
        //{
        //    var cartAgent = (PHCartAgent)_cartAgent;
        //    cartAgent.UpdateQuantityOfCartItemWithFees(guid, quantity, productId, specialfeeids);
        //    var cartViewModel = cartAgent.GetCart(isCheckout:true);
        //    cartViewModel.IsSinglePageCheckout = PortalAgent.CurrentPortal.IsEnableSinglePageCheckout;
        //    return PartialView("_CartReview", cartViewModel);
        //}

        //Submit order (work with both checkout Single/Multistep check out)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public override ActionResult SubmitOrder(SubmitOrderViewModel submitOrderViewModel)
        {
            if (!TempData.ContainsKey(ZnodeConstant.BrowserRefresh))
            {
                TempData.Add(ZnodeConstant.BrowserRefresh, true);

                if (Equals(submitOrderViewModel?.PaymentType?.ToLower(), ZnodeConstant.CreditCard.ToLower()))
                {
                    ZnodeLogging.LogMessage(" Nivi Before _checkoutAgent.SubmitOrder OrderNumber " + submitOrderViewModel?.OrderNumber + " Trans ID " + submitOrderViewModel?.TransactionId, ZnodeLogging.Components.Webstore.ToString(), TraceLevel.Error);
                }
                OrdersViewModel order = _checkoutAgent.SubmitOrder(submitOrderViewModel);

                if (HelperUtility.IsNotNull(order) && !order.HasError)
                {
                    order.Total = submitOrderViewModel.Total;
                    order.SubTotal = submitOrderViewModel.SubTotal;

                    // Below code is used for "PayPal Express" to redirect payment website.
                    if (!string.IsNullOrEmpty(submitOrderViewModel.PayPalReturnUrl) && !string.IsNullOrEmpty(submitOrderViewModel.PayPalCancelUrl) && HelperUtility.Equals(submitOrderViewModel.PaymentType?.ToLower(), ZnodeConstant.PayPalExpress.ToLower()))
                    {
                        //Check User Authentication
                        CheckUserAuthentication();
                        TempData["Error"] = order.HasError;
                        TempData["ErrorMessage"] = order.ErrorMessage;
                        TempData.Remove(ZnodeConstant.BrowserRefresh);
                        return Json(new { responseText = order.PayPalExpressResponseText });
                    }

                    // Below code is used for "Amazon Pay" to redirect payment website.
                    if (!string.IsNullOrEmpty(submitOrderViewModel.AmazonPayReturnUrl) && !string.IsNullOrEmpty(submitOrderViewModel.AmazonPayCancelUrl) && HelperUtility.Equals(submitOrderViewModel.PaymentType?.ToLower(), ZnodeConstant.AmazonPay.ToLower()))
                    {
                        //Check User Authentication
                        CheckUserAuthentication();
                        TempData.Remove(ZnodeConstant.BrowserRefresh);
                        return Json(new { responseText = Convert.ToString(order.PaymentStatus), responseToken = order.TrackingNumber });
                    }

                    // Below code is used, after payment success from "PayPal Express" return to "return url" of "PayPal Express" i.e. "SubmitPaypalOrder".
                    if (submitOrderViewModel.IsFromPayPalExpress)
                    {
                        TempData["Order"] = order;
                        TempData.Remove(ZnodeConstant.BrowserRefresh);
                        return Json(new { success = true });
                    }
                    // Below code is used, after payment success from "Amazon Pay" return to "return url" of "AmazonPay" i.e. "SubmitAmazonPayOrder".
                    if (submitOrderViewModel.IsFromAmazonPay)
                    {
                        TempData["Order"] = order;
                        TempData.Remove(ZnodeConstant.BrowserRefresh);
                        return Json(new { success = true });
                    }

                    if (!User.Identity.IsAuthenticated)
                    {
                        _userAgent.RemoveGuestUserSession();
                    }

                    _cartAgent.RemoveAllCartItems(order.OmsOrderId);

                    // Below code is used, for after successfully payment from "Credit Card" return receipt.
                    if (Equals(submitOrderViewModel?.PaymentType?.ToLower(), ZnodeConstant.CreditCard.ToLower()))
                    {
                        TempData.Remove(ZnodeConstant.BrowserRefresh);
                        return Json(new { receiptHTML = RenderRazorViewToString(CheckoutReceipt, order), omsOrderId = order.OmsOrderId });
                    }

                    if (Equals(submitOrderViewModel?.PaymentType?.ToLower(), ZnodeConstant.ACH.ToLower()))
                    {
                        TempData.Remove(ZnodeConstant.BrowserRefresh);
                        return Json(new { receiptHTML = RenderRazorViewToString(CheckoutReceipt, order), omsOrderId = order.OmsOrderId });
                    }

                    TempData.Remove(ZnodeConstant.BrowserRefresh);
                    TempData["OrderId"] = order.OmsOrderId;
                    return RedirectToAction<CheckoutController>(x => x.OrderCheckoutReceipt());
                }

                //Return error message, if payment through "Paypal Express" raises any error.
                if (order.HasError)
                {
                    TempData["Error"] = order.HasError;
                    TempData["ErrorMessage"] = order?.ErrorMessage;
                }

                // Return error message, if payment through "Credit Card" raises any error.
                if (Equals(submitOrderViewModel?.PaymentType?.ToLower(), ZnodeConstant.CreditCard.ToLower()))
                {
                    ZnodeLogging.LogMessage(" Nivi SubmitOrder Credit Card Error " + order.ErrorMessage, ZnodeLogging.Components.Webstore.ToString(), TraceLevel.Error, order);
                    TempData.Remove(ZnodeConstant.BrowserRefresh);
                    return Json(new { error = order.ErrorMessage });
                }

                // Return error message, if payment through "PayPal Express" raises any error.
                if (!string.IsNullOrEmpty(submitOrderViewModel.PayPalReturnUrl) && !string.IsNullOrEmpty(submitOrderViewModel.PayPalCancelUrl))
                {
                    TempData.Remove(ZnodeConstant.BrowserRefresh);
                    return Json(new { error = order.ErrorMessage, responseText = order.PaymentStatus });
                }

                // Return error message, if payment through "AmazonPay" raises any error.
                if (!string.IsNullOrEmpty(submitOrderViewModel.AmazonPayReturnUrl) && !string.IsNullOrEmpty(submitOrderViewModel.AmazonPayCancelUrl))
                {
                    TempData.Remove(ZnodeConstant.BrowserRefresh);
                    return Json(new { error = order.ErrorMessage, responseText = order.PaymentStatus });
                }
                SetNotificationMessage(GetErrorNotificationMessage(order.ErrorMessage));
            }

            TempData.Remove(ZnodeConstant.BrowserRefresh);
            return RedirectToAction<CheckoutController>(x => x.Index(true));
        }


        public string LogAuthNetIframeResponse(int portalId,string response)
        {
            PHHelper.WriteLog(" Nivi AuthNet IFrame Response "+ response);
            return "";
        }

        public override ActionResult GetAuthorizeNetToken(PaymentTokenViewModel paymentTokenModel)
        {
            ZnodeLogging.LogMessage(" Nivi GetAuthorizeNetToken UserID "+ paymentTokenModel?.UserId + "  OrderNumber " + paymentTokenModel?.OrderNumber + " Order Total " + paymentTokenModel?.Total, ZnodeLogging.Components.Webstore.ToString(), TraceLevel.Error);
            return base.GetAuthorizeNetToken(paymentTokenModel);
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            filterContext.ExceptionHandled = true;

            var error = filterContext.Exception.Message;
            //Log the error!!
            //_Logger.Error(filterContext.Exception);
            PHHelper.WriteLog(filterContext.Exception);

            //Redirect or return a view, but not both.
            //filterContext.Result = RedirectToAction("Index", "ErrorHandler");
            // OR 
            //filterContext.Result = new ViewResult
            //{
            //    ViewName = "~/Views/Themes/EquinaviaB2C/Views/Shared/ErrorPage.cshtml"
            //};
        }


        public static void WriteLog(string strValue)
        {
            try
            {
                string basepath = AppDomain.CurrentDomain.BaseDirectory + "/PHLogs/";
                // create directory if not exists
                System.IO.Directory.CreateDirectory(basepath);

                //Logfile
                string path = basepath + "phlog_" + DateTime.Now.ToString("dd-MM-yyyy") + ".txt";/// Server.MapPath("\textlog.txt");
                using (System.IO.StreamWriter sw = System.IO.File.AppendText(path))
                {
                    sw.WriteLine(DateTime.Now.ToString("dd-MM-yyyy hh:mm::ss tt =>") + strValue);
                }
            }
            catch (Exception ex)
            {

            }
        }


    }
}
