using Znode.Engine.Api.Client.Endpoints;

namespace Znode.Admin.Custom.Endpoints.Custom
{
    public class PHWarehouseEndpoint : BaseEndpoint
    {
        #region Warehouse
        //Get warehouse list Endpoint.
        public static string GetCustomWarehouseList() => $"{ApiRoot}/customwarehouse/list";

        //Create warehouse Endpoint.
        public static string CreateCustomWarehouse() => $"{ApiRoot}/customwarehouse/create";

        //Get warehouse on the basis of warehouse id Endpoint.
        public static string GetCustomWarehouse(int warehouseId) => $"{ApiRoot}/customwarehouse/{warehouseId}";

        //Update warehouse Endpoint.
        public static string UpdateCustomWarehouse() => $"{ApiRoot}/customwarehouse/update";

        //Delete warehouse Endpoint.
        public static string DeleteCustomWarehouse() => $"{ApiRoot}/customwarehouse/delete";
        #endregion

        #region Associate inventories

        //Get assigned inventory list endpoint.
        public static string GetAssociatedInventoryList() => $"{ApiRoot}/customwarehouse/associatedinventory/list";
        public static string GetWarehouseAttributeList() => $"{ApiRoot}/customwarehouse/warehouseattribute/list";
        public static string UpdateWarehouseAttribute() => $"{ApiRoot}/customwarehouse/warehouseattribute/update";
        public static string DeleteWarehouseAttribute() => $"{ApiRoot}/customwarehouse/warehouseattribute/delete";
        public static string GetAssociatedInventory() => $"{ApiRoot}/customwarehouse/inventory/";

        #endregion

    }
}
