
using System.Collections.Generic;
using Znode.Custom.Data;
using Znode.Engine.Api.Models;
using Znode.Libraries.ECommerce.ShoppingCart;


namespace Znode.Engine.Shipping.Custom.Interface
{
    public interface ICustomShoppingCart : IZnodeShoppingCart
    {
        List<ConpacWarehouseAttribute> WarehouseZipcodeList { get; }

        InventoryWarehouseMapperListModel WarehouseInventory { get; }
    }
}
