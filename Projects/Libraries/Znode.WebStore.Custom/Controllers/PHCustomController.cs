using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Znode.Engine.Api.Models;
using Znode.Engine.WebStore;
using Znode.Engine.WebStore.Agents;
using Znode.Engine.WebStore.Controllers;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.WebStore.Custom.Controllers
{
    public class PHCustomController : BaseController
    {
       

        //[HttpPost]
        //public ActionResult UpdateOptionalFees(string omsSavedCardLineItemIds, string optionalfeesIds, int shippingOption2Id)
        //{
        //    try
        //    {
        //        //////
        //        if (shippingOption2Id > 0)
        //        {
        //            var ShoppingCartModel= SessionHelper.GetDataFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey);
        //            ShoppingCartModel.Shipping.Custom1 = shippingOption2Id.ToString();
        //            SessionHelper.SaveDataInSession(WebStoreConstants.CartModelSessionKey, ShoppingCartModel);
        //        }
        //        //////
        //        optionalfeesIds = string.IsNullOrEmpty(optionalfeesIds) ? "NULL" : optionalfeesIds = optionalfeesIds.Remove(optionalfeesIds.Length - 1);
        //        string message = string.Empty;
        //        using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ZnodeECommerceDB"].ConnectionString))
        //        {
        //            try
        //            {
        //                SqlCommand command = new SqlCommand("Nivi_UpdateOptionalFees", connection);
        //                connection.Open();
        //                command.CommandType = CommandType.StoredProcedure;
        //                command.Parameters.AddWithValue("@OmsSavedCardLineItemIds", omsSavedCardLineItemIds);
        //                command.Parameters.AddWithValue("@OptionalfeesIds", optionalfeesIds);
        //                SqlDataReader reader = command.ExecuteReader();

        //                connection.Close();
        //                message = "Success";
        //            }
        //            catch (Exception ex)
        //            {
        //                message = ex.Message;
        //            }
        //        }
        //        return Json(new
        //        {
        //            isSuccess = true,
        //            message = message,
        //        }, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (System.Exception Ex)
        //    {
        //        return Json(new
        //        {
        //            isSuccess = false,
        //            message = Ex.Message,
        //        }, JsonRequestBehavior.AllowGet);
        //    }
        //}

        //[HttpPost]
        //public ActionResult GetOptionalFees(string omsSavedCardLineItemIds,int shippingOption2Id)
        //{
        //    dynamic responseDatas = "";
        //    try
        //    {
        //        //////
        //        if (shippingOption2Id > 0)
        //        {
        //            var ShoppingCartModel = SessionHelper.GetDataFromSession<ShoppingCartModel>(WebStoreConstants.CartModelSessionKey);
        //            ShoppingCartModel.Shipping.Custom1 = shippingOption2Id.ToString();
        //            SessionHelper.SaveDataInSession(WebStoreConstants.CartModelSessionKey, ShoppingCartModel);
        //        }
        //        //////
        //        using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ZnodeECommerceDB"].ConnectionString))
        //        {
        //            try
        //            {
        //                SqlCommand command = new SqlCommand("Nivi_GetOptionalFeesIdFromSaveCart", connection);
        //                connection.Open();
        //                command.CommandType = CommandType.StoredProcedure;
        //                command.Parameters.AddWithValue("@OmsSavedCardLineItemIds", omsSavedCardLineItemIds);
        //                SqlDataReader reader = command.ExecuteReader();
        //                while (reader.Read())
        //                {
        //                    responseDatas = reader["Custom5"].ToString();
        //                }
        //                connection.Close();
        //            }
        //            catch (Exception ex)
        //            {
        //                responseDatas = ex.Message;
        //            }
        //        }
        //        return Json(new
        //        {
        //            isSuccess = true,
        //            message = responseDatas,
        //        }, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (System.Exception Ex)
        //    {
        //        return Json(new
        //        {
        //            isSuccess = false,
        //            message = Ex.Message,
        //        }, JsonRequestBehavior.AllowGet);
        //    }
        //}
    }
}
