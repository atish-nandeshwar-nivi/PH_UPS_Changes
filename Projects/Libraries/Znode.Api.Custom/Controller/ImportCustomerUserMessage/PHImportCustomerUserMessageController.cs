using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using Znode.Api.Custom.Cache.Cache;
using Znode.Api.Custom.Service.Service;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;
using Znode.Api.Model.Custom.Responses;
using Znode.Engine.Api.Controllers;
using Znode.Engine.Api.Models.Responses;

namespace Znode.Api.Custom.Controller.ImportCustomerUserMessage
{
    public class PHImportCustomerUserMessageController : BaseController
    {
        private readonly PHImportCustomerUserMessageService _phimportCustomerUserMessageService;
        private readonly PHImportCustomerUserMessageCache _phimportCustomerUserMessageCache;

        public PHImportCustomerUserMessageController()
        {
            _phimportCustomerUserMessageService = new PHImportCustomerUserMessageService();
            _phimportCustomerUserMessageCache = new PHImportCustomerUserMessageCache();
        }

        [ResponseType(typeof(BaseResponse))]
        [HttpPost]
        public HttpResponseMessage ImportCustomerUserMessage([FromBody] List<CustomerUserMessageModel> models)
        {
            HttpResponseMessage response = CreateNoContentResponse();

            try
            {
                bool status = _phimportCustomerUserMessageService.ImportCustomerUserMessage(models);
                response = CreateOKResponse(new BaseResponse { HasError = false, ErrorMessage = "success" });// : CreateOKResponse(new BaseResponse { HasError = true, ErrorMessage = "fail" });

            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new BaseResponse { HasError = true, ErrorMessage = ex.Message });
            }

            return response;
        }

        [ResponseType(typeof(CustomerUserMessageLogResponse))]
        [HttpGet]
        public HttpResponseMessage GetCustomerUserMessageLog()
        {
            HttpResponseMessage response = CreateNoContentResponse();

            try
            {
                string data = _phimportCustomerUserMessageCache.GetCustomerUserMessageLog(RouteUri, RouteTemplate);
                response = string.IsNullOrEmpty(data) ? CreateNoContentResponse() : CreateOKResponse<CustomerUserMessageLogResponse>(data);
                //string result = _phimportCustomerUserMessageCache.GetCustomerUserMessageLog(RouteUri, RouteTemplate);
                //response = result != null ? CreateNoContentResponse() : CreateOKResponse(new CustomerUserMessageLogResponse() { });

            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse("error");
            }

            return response;
        }

        [ResponseType(typeof(CustomerUserMessageLogDetailsResponse))]
        [HttpGet]
        public HttpResponseMessage GetCustomerUserMessageLogDetails(string CustomerUserMessageLogId)
        {
            HttpResponseMessage response = CreateNoContentResponse();

            try
            {
                string data = _phimportCustomerUserMessageCache.GetCustomerUserMessageLogDetails(RouteUri, RouteTemplate, Convert.ToInt32(CustomerUserMessageLogId));
                response = string.IsNullOrEmpty(data) ? CreateNoContentResponse() : CreateOKResponse<CustomerUserMessageLogDetailsResponse>(data);
                //string result = _phimportCustomerUserMessageCache.GetCustomerUserMessageLog(RouteUri, RouteTemplate);
                //response = result != null ? CreateNoContentResponse() : CreateOKResponse(new CustomerUserMessageLogResponse() { });

            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse("error");
            }

            return response;
        }
    }
}
