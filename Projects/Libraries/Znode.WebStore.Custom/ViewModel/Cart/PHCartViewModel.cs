using System.Collections.Generic;
using Znode.Engine.WebStore.ViewModels;

namespace Znode.WebStore.Custom.ViewModel
{
    public class CustomCartViewModel
    {
        public CartViewModel CartViewModel { get; set; }
        public List<string> FreeFreightSkus { get; set; }
    }
}
