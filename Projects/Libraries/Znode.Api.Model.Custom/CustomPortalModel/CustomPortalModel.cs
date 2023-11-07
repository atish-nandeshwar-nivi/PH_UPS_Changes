using Znode.Engine.Api.Models;

namespace Znode.Api.Model.Custom
{
    public class CustomPortalModel: BaseModel
    {
        public PortalModel Portal { get; set; }
        public CustomPortalDetailModel PortalCustomDetail { get; set; }
    }
}
