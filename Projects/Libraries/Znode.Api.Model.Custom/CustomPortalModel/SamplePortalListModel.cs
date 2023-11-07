using System.Collections.Generic;
using Znode.Engine.Api.Models;

namespace Znode.Api.Model.Custom
{
    public class SamplePortalListModel: BaseListModel
    {       
        public List<SamplePortalModel> PortalList { get; set; }
    }
}
