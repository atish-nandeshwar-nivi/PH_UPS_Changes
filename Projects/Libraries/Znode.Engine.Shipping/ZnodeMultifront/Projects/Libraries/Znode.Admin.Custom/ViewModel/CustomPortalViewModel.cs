using Znode.Admin.Custom.ViewModels;
using Znode.Engine.Admin.ViewModels;

namespace Znode.Admin.Custom.ViewModel
{
    public class CustomPortalViewModel : BaseViewModel
    {
        public StoreViewModel Portal { get; set; }
        public CustomPortalDetailViewModel PortalCustomDetail { get; set; }
    }
}