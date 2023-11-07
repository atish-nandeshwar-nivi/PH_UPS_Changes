using Znode.Engine.Api.Models.Responses;

namespace Znode.Api.Model.Custom.Responses
{
    public class CustomPortalResponse : BaseResponse
    {
        public CustomPortalDetailModel PortalDetail { get; set; }
        public CustomPortalModel Portal { get; set; }
    }
}
