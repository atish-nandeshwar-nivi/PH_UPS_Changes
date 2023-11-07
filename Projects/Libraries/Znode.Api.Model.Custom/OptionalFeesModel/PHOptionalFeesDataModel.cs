using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Znode.Api.Model.Custom.OptionalFeesModel
{
    public class PHOptionalFeesDataModel
    {
        public int OptionalFeeId { get; set; }
        public string OptionalFeeCode { get; set; }
        public string OptionalFeeName { get; set; }
        public decimal OptionalFee { get; set; }
    }
}
