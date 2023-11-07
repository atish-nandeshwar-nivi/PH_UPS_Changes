using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Znode.Admin.Custom.Endpoints.Custom;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;
using Znode.Api.Model.Custom.Responses;
using Znode.Engine.Api.Client;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;

namespace Znode.Api.Client.Custom.Clients.Clients
{
    public class PHImportCustomerUserMessageClient : BaseClient
    {
        public bool ImportCustomerUserMessage(List<CustomerUserMessageModel> models)
        {
            //Get Endpoint.
            string endpoint = CustomEndpoint.PHImportCustomerUserMessage();
            //Get Serialize object as a response.
            ApiStatus status = new ApiStatus();

            var data = JsonConvert.SerializeObject(models);
            BaseResponse response = PostResourceToEndpoint<BaseResponse>(endpoint, data, status);

            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);

            return !response.HasError;
        }

        public List<CustomerUserMessageLogModel> GetCustomerUserMessageLog()
        {
            //Get Endpoint.
            string endpoint = CustomEndpoint.GetCustomerUserMessageLog();
            //Get Serialize object as a response.
            ApiStatus status = new ApiStatus();

            CustomerUserMessageLogResponse response = GetResourceFromEndpoint<CustomerUserMessageLogResponse>(endpoint,status);

            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);

            return response.CustomerUserMessageLogList;
        }

        public List<CustomerUserMessageLogDetailsModel> GetCustomerUserMessageLogDetails(int CustomerUserMessageLogId)
        {
            //Get Endpoint.
            string endpoint = CustomEndpoint.GetCustomerUserMessageLogDetails(CustomerUserMessageLogId);
            //Get Serialize object as a response.
            ApiStatus status = new ApiStatus();

            CustomerUserMessageLogDetailsResponse response = GetResourceFromEndpoint<CustomerUserMessageLogDetailsResponse>(endpoint, status);

            CheckStatusAndThrow<ZnodeException>(status, HttpStatusCode.OK);

            return response.CustomerUserMessageLogDetailsList;
        }
    }
}
