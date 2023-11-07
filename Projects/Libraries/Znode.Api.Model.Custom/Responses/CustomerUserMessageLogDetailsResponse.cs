using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;
using Znode.Engine.Api.Models.Responses;

namespace Znode.Api.Model.Custom.Responses
{
    public class CustomerUserMessageLogDetailsResponse : BaseResponse
    {
        public List<CustomerUserMessageLogDetailsModel> CustomerUserMessageLogDetailsList { get; set; }
    }
}
