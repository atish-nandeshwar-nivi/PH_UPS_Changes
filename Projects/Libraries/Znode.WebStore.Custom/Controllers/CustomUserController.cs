using System;
using System.IO;
using System.Web.Mvc;
using System.Xml.Serialization;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.SAML;
using Znode.Libraries.SAMLWeb;
using Znode.Libraries.SAMLWeb.Controllers;
using Znode.WebStore.Core.Agents;

namespace Znode.Engine.WebStore.Controllers
{
    //public class CustomUserController : UserController
    //{
    //    #region Private Read-only members
    //    private readonly IAuthenticationHelper _authenticationHelper;
    //    private readonly IUserAgent _userAgent;
    //    private readonly ICartAgent _cartAgent;
    //    #endregion

    //    #region Public Constructor     
    //    public CustomUserController(IUserAgent userAgent, ICartAgent cartAgent, IAuthenticationHelper authenticationHelper, IPaymentAgent paymentAgent, IImportAgent importAgent, IFormBuilderAgent formBuilderAgent,IPowerBIAgent powerBIAgent)
    //   : base(userAgent, cartAgent, authenticationHelper, paymentAgent, importAgent, formBuilderAgent,powerBIAgent)
    //    {
    //        _authenticationHelper = authenticationHelper;
    //        _userAgent = userAgent;
    //        _cartAgent = cartAgent;
    //    }
    //    #endregion

    //    [AllowAnonymous]
    //    [HttpGet]
    //    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "None")]
    //    public override ActionResult Login(string returnUrl)
    //    {
    //        return RedirectToAction<SAMLProviderController>(x => x.GetResource());
    //    }

    //    //SAML call back 
    //    public ActionResult SAMLCallback(string returnUrl = "")
    //    {
    //        SessionObj sessionObj = SessionHelper.GetDataFromSession<SessionObj>(Request.Params["state"]);

    //        string samlResponseXML = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(sessionObj.SAMLToken));

    //        XmlSerializer serializer = new XmlSerializer(typeof(ResponseType));

    //        ResponseType response = (ResponseType)serializer.Deserialize(new StringReader(samlResponseXML));

    //        string username = string.Empty;
    //        //Find assertion
    //        AssertionType assertion = null;
    //        foreach (var item in response.Items)
    //        {
    //            if (item is AssertionType)
    //            {
    //                assertion = item as AssertionType;
    //            }
    //        }

    //        //Find the username
    //        if (assertion != null)
    //        {
    //            foreach (var item in assertion.Subject.Items)
    //            {
    //                if (item is NameIDType)
    //                {

    //                    if (!string.IsNullOrEmpty(((NameIDType)item).Value))
    //                    {
    //                        username = ((NameIDType)item).Value;
    //                    }
    //                }
    //            }
    //        }
    //        string id = Request.Params["id"];

    //        //Set the Authentication Cookie.  
    //        SetAuthCookie(username, id);

    //        return RedirectToAction<HomeController>(x => x.Index());
    //    }

    //    private void SetAuthCookie(string userName, string id)
    //    {
    //        Session.Add(WebStoreConstants.UserAccountKey, new UserViewModel { UserName = userName, UserId = Convert.ToInt32(id), RoleName = "admin" });

    //        //Set the Authentication Cookie.           
    //        _authenticationHelper.SetAuthCookie(userName, true);
    //    }
    //}
}