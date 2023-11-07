using System.Collections.Generic;
using Znode.Engine.Api.Models.Responses;

namespace Znode.Api.Model.Custom.Responses
{
    public class CustomPortalDetailListResponse : BaseListResponse
    {
        public List<CustomPortalDetailModel> CustomPortalDetailList { get; set; }
    }
}
