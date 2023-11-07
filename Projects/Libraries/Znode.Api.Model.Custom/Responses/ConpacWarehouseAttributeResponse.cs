using System.Collections.Generic;
using Znode.Api.Model.Custom;
using Znode.Engine.Api.Models.Responses;

namespace Znode.Sample.Api.Model.Responses
{
    public class ConpacWarehouseAttributeResponse : BaseResponse
    {
        public ConpacWarehouseAttributeModel WarehouseAttribute { get; set; }
    }

    public class FreeFreightSkuListResponse : BaseResponse
    {
        public List<string> SkuList { get; set; }
    }
}
