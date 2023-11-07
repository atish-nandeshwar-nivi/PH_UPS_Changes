using System.Collections.Generic;
using Znode.Engine.Admin.Models;
using Znode.Engine.Admin.ViewModels;

namespace Znode.Admin.Custom.ViewModel
{
    public class SamplePortalListViewModel : BaseViewModel
    {
        public int PriceListId { get; set; }
        public SamplePortalListViewModel()
        {
            StoreList = new List<StoreViewModel>();
        }

        public List<StoreViewModel> StoreList { get; set; }
        public GridModel GridModel { get; set; }
        public int TaxClassId { get; set; }
        public int ShippingId { get; set; }
    }
}