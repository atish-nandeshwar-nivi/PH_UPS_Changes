using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Routing;

namespace Znode.Engine.Api
{
    public static class CustomWebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            //Custom Portal Detail Routes
            config.Routes.MapHttpRoute("custom-portal-list", "customportal/list", new { controller = "customportal", action = "getportallist" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("custom-portal-detail-list", "customportaldetail/list", new { controller = "customportal", action = "getcustomportaldetaillist" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("custom-portal-get", "customportal/getcustomportaldetail/{customPortalDetailId}", new { controller = "customportal", action = "getcustomportaldetail" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get), customPortalDetailId = @"^\d+$" });
            config.Routes.MapHttpRoute("custom-portal-create", "customportal/create", new { controller = "customportal", action = "insertcustomportaldetail" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("custom-portal-update", "customportal/update", new { controller = "customportal", action = "updatecustomportaldetail" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Put) });
            config.Routes.MapHttpRoute("custom-portal-delete", "customportal/delete", new { controller = "customportal", action = "deletecustomportaldetail" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });

            //customwarehouse
            config.Routes.MapHttpRoute("customwarehouse-list", "customwarehouse/list", new { controller = "customwarehouse", action = "list" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("customwarehouse-create", "customwarehouse/create", new { controller = "customwarehouse", action = "create" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("customwarehouse-get", "customwarehouse/{customwarehouseId}", new { controller = "customwarehouse", action = "getcustomwarehouse" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("customwarehouse-update", "customwarehouse/update", new { controller = "customwarehouse", action = "update" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Put) });
            config.Routes.MapHttpRoute("customwarehouse-delete", "customwarehouse/delete", new { controller = "customwarehouse", action = "delete" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });

            //warehouseattributes
            config.Routes.MapHttpRoute("customassociatedinventory-list", "customwarehouse/associatedinventory/list", new { controller = "customwarehouse", action = "getassociatedinventorylist" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("warehouseattribute-list", "customwarehouse/getwarehouseattributes", new { controller = "customwarehouse", action = "getwarehouseattributes" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("customwarehouseattribute-list", "customwarehouse/warehouseattribute/list", new { controller = "customwarehouse", action = "GetWarehouseAttributeList" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("customwarehouseattribute-update", "customwarehouse/warehouseattribute/update", new { controller = "customwarehouse", action = "UpdateAttribute" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("customwarehouseattribute-delete", "customwarehouse/warehouseattribute/delete", new { controller = "customwarehouse", action = "DeleteAttribute" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("customwarehouse-inventorybyzip-list", "customwarehouse/inventorybyzip/{zipCode}", new { controller = "customwarehouse", action = "GetAssociatedInventoryByZip" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get), zipCode = @"^\d+$" });
            config.Routes.MapHttpRoute("customwarehouse-associatedinventory", "customwarehouse/inventory", new { controller = "customwarehouse", action = "GetAssociatedInventory" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });

            // shipping estimates
            config.Routes.MapHttpRoute("phshoppingcart-getshippingestimates", "phshoppingcarts/getshippingestimates/{zipcode}", new { controller = "phshoppingcart", action = "getcustomshippingestimates" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("phshoppingcart-calculate", "phshoppingcarts/calculate", new { controller = "phshoppingcart", action = "customcalculate" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("phorder-create", "phorder/create", new { controller = "phorder", action = "customcreate" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("phshoppingcart-updateoptionalfees", "phshoppingcarts/updateoptionalfees", new { controller = "phshoppingcart", action = "updateoptionalfees" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("phshoppingcart-getoptionalfees", "phshoppingcarts/getoptionalfees/{OmsSavedCardLineItemIds}", new { controller = "phshoppingcart", action = "getoptionalfees" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });

            //customer user messages
            config.Routes.MapHttpRoute("phimportcustomerusermessage-index", "phimportcustomerusermessage/index", new { controller = "phimportcustomerusermessage", action = "index" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("phimportcustomerusermessage-importcustomerusermessage", "phimportcustomerusermessage/importcustomerusermessage", new { controller = "phimportcustomerusermessage", action = "importcustomerusermessage" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
            config.Routes.MapHttpRoute("phimportcustomerusermessage-getcustomerusermessagelog", "phimportcustomerusermessage/getcustomerusermessagelog", new { controller = "phimportcustomerusermessage", action = "getcustomerusermessagelog" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
            config.Routes.MapHttpRoute("phimportcustomerusermessage-getcustomerusermessagelogdetails", "phimportcustomerusermessage/getcustomerusermessagelogdetails/{CustomerUserMessageLogId}", new { controller = "phimportcustomerusermessage", action = "getcustomerusermessagelogdetails" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });

            //BC integration nivi Endpoint
            config.Routes.MapHttpRoute("PH-Order-LisByStatus", "phorder/getorderlist", new { controller = "phorder", action = "getorderlist" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
        }
    }
}