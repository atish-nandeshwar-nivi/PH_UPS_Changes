using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Znode.Admin.Custom.ViewModel
{
    public class CustomerUserMessageLogDetailsViewModel
    {
        public int CustomerUserMessageLogDetailsId { get; set; }
        public int CustomerUserMessageLogId { get; set; }
        public string UserName { get; set; }
        public string ErrorMessage { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
