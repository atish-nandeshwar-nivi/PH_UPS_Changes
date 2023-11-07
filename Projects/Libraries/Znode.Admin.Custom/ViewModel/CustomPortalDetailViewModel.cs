using System.Collections.Generic;
using Znode.Engine.Admin.ViewModels;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;

namespace Znode.Admin.Custom.ViewModels
{
    public class CustomPortalDetailViewModel : StoreViewModel
    {
        public int CustomePortalDetailsId { get; set; }
        public string PortalName { get; set; }
        [Required]
        public string CustomeData1 { get; set; }
        public string CustomeData2 { get; set; }
        public string CustomeData3 { get; set; }
    }
}