using System.Collections.Generic;
using Znode.Engine.Api.Models.Responses;

namespace Znode.Api.Model.Custom.Responses
{
    public class SamplePortalListResponse: BaseListResponse
    {
        public List<SamplePortalModel> PortalList { get; set; }
        public List<SamplePortalFeatureModel> PortalFeatureList { get; set; }
    }
}
