using Znode.Engine.Api.Models;
using Znode.Engine.Services;
using Znode.Libraries.ECommerce.ShoppingCart;

namespace Znode.Engine.Shipping.Custom.Interface
{
    public interface ICustomShoppingCartMap
    {
        //Mapping to model.
        ShoppingCartModel ToModel(CustomShoppingCart znodeCart, IImageHelper objImage = null);

        //Mapping to Znode shopping cart model.
        CustomShoppingCart ToZnodeShoppingCart(ShoppingCartModel model, UserAddressModel userDetails = null);
        CustomShoppingCart ToZnodeShoppingCart(IZnodeMultipleAddressCart cart, UserAddressModel userDetails = null);
        CustomShoppingCart ToZnodeShoppingCart(IZnodePortalCart cart, UserAddressModel userDetails = null);
    }
}