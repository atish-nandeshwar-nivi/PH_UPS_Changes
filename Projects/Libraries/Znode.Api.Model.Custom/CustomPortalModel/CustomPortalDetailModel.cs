using Znode.Engine.Api.Models;

namespace Znode.Api.Model.Custom
{
    public class CustomPortalDetailModel : PortalModel
    {
        public int? CustomePortalDetailsId { get; set; }
        public string PortalName { get; set; }
        public string CustomeData1 { get; set; }
        public string CustomeData2 { get; set; }
        public string CustomeData3 { get; set; }
    }
}
