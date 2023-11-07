using System.Collections.Generic;
using Znode.Api.Model.Custom;

namespace Znode.Engine.Api.Models.Responses
{
    public class ConpacWarehouseAttributeListResponse : BaseListResponse
    {
        public List<ConpacWarehouseAttributeModel> ConpacWarehouseAttributeList { get; set; }
    }
}
