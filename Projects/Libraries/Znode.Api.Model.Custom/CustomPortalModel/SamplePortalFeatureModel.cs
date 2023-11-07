using Znode.Engine.Api.Models;

namespace Znode.Api.Model.Custom
{
    public class SamplePortalFeatureModel: BaseModel
    {
        public int PortalFeatureId { get; set; }
        public string PortalFeatureName { get; set; }
        public bool PortalFeatureValue { get; set; }
    }
}
