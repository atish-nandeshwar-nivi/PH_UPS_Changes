using System;
using System.Collections.Generic;
using Znode.Engine.Api.Models;

namespace Znode.Api.Model.Custom
{
    public class ConpacWarehouseAttributeModel : BaseModel
    {
        public int? RowId { get; set; }
        public int? UniqueId { get; set; }
        public int? WarehouseId { get; set; }
        public string Value { get; set; }
        public string Type { get; set; }
    }

    public class FreeFreightSkuList : BaseModel
    {
        public List<string> SkuList { get; set; }
        public string ZipCode { get; set; }
        public Nullable<int> WarehouseId { get; set; }
    }

    public class FreeFreightSku : BaseModel
    {
        public string SkuList { get; set; }
    }
}
