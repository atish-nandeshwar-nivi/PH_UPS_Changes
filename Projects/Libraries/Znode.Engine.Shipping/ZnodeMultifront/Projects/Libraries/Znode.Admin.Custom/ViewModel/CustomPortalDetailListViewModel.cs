using System.Collections.Generic;
using Znode.Engine.Admin.Models;
using Znode.Engine.Admin.ViewModels;


namespace Znode.Admin.Custom.ViewModels
{
    public class CustomPortalDetailListViewModel : BaseViewModel
    {
        public CustomPortalDetailListViewModel()
        {
            CustomPortalDetailList = new List<CustomPortalDetailViewModel>();
        }

        public List<CustomPortalDetailViewModel> CustomPortalDetailList { get; set; }
        public GridModel GridModel { get; set; }
    }
}