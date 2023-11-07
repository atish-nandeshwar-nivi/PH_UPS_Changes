using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Znode.Admin.Custom.ViewModel
{
    public class CustomerUserMessageLogViewModel
    {
        public int CustomerUserMessageLogId { get; set; }
        public string Status { get; set; }
        public int TotalRecords { get; set; }
        public int SuceessRecords { get; set; }
        public int FailRecords { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
