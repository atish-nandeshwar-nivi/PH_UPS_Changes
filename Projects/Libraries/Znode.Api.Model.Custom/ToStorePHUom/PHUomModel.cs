using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Znode.Api.Model.Custom.ToStorePHUom
{
    //customization to send UOM data
    public class PHUomModel
    {
        public string BuyUOM { get; set; }
        public string JITBuyUOM { get; set; }
        public string PriceUnitDescription { get; set; }
    }
}
