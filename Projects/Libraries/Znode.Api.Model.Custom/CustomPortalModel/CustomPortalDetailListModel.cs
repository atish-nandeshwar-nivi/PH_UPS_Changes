using System.Collections.Generic;
using Znode.Engine.Api.Models;

namespace Znode.Api.Model.Custom
{
    public class CustomPortalDetailListModel : PortalListModel
    {
        public List<CustomPortalDetailModel> CustomPortalDetailList { get; set; }
    }
}
