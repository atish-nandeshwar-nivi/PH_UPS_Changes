using Znode.Engine.Api.Models;
using Znode.Engine.Services;
using Znode.Engine.Api.Cache;

namespace Znode.Api.Custom.Cache
{
    public class PHShoppingCartCache : ShoppingCartCache, IShoppingCartCache
    {
        #region Private Variables
        private readonly IShoppingCartService _shoppingCartService;
        #endregion

        #region Constructor
        public PHShoppingCartCache(IShoppingCartService shoppingCartService)
           :base(shoppingCartService)
        {
            _shoppingCartService = shoppingCartService;
        }
        #endregion

        #region Public Methods

        public override ShippingListModel GetShippingEstimates(string zipCode, string routeUri, ShoppingCartModel model)
        {
            return _shoppingCartService.GetShippingEstimates(zipCode, model);
        }

        public override ShoppingCartModel Calculate(string routeUri, ShoppingCartModel model)
        {
            UpdateCacheForProfile();
            return _shoppingCartService.Calculate(model);
        }

        #endregion
    }
}