using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Api.Custom.Service.Service;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;
using Znode.Api.Model.Custom.Responses;
using Znode.Engine.Api.Cache;

namespace Znode.Api.Custom.Cache.Cache
{
    public class PHImportCustomerUserMessageCache : BaseCache
    {
        #region Private Variables
        private readonly PHImportCustomerUserMessageService _phimportCustomerUserMessageService;
        #endregion

        #region Constructor
        public PHImportCustomerUserMessageCache()
        {
            _phimportCustomerUserMessageService =  new PHImportCustomerUserMessageService();
        }
        #endregion

        #region Public Methods
        public string GetCustomerUserMessageLog(string routeUri, string routeTemplate)
        {
            string data = GetFromCache(routeUri);
            if (string.IsNullOrEmpty(data))
            {
                //Get data from service
                List<CustomerUserMessageLogModel> customerUserMessageLogs = _phimportCustomerUserMessageService.GetCustomerUserMessageLog();
                if (customerUserMessageLogs?.Count > 0)
                {
                    //Create Response and insert in to cache
                    CustomerUserMessageLogResponse response = new CustomerUserMessageLogResponse { CustomerUserMessageLogList = customerUserMessageLogs };

                    data = InsertIntoCache(routeUri, routeTemplate, response);
                }
            }
            return data;
        }

        public string GetCustomerUserMessageLogDetails(string routeUri, string routeTemplate, int CustomerUserMessageLogId)
        {
            string data = GetFromCache(routeUri);
            if (string.IsNullOrEmpty(data))
            {
                //Get data from service
                List<CustomerUserMessageLogDetailsModel> CustomerUserMessageLogDetailsList = _phimportCustomerUserMessageService.GetCustomerUserMessageLogDetails(CustomerUserMessageLogId);
                if (CustomerUserMessageLogDetailsList?.Count > 0)
                {
                    //Create Response and insert in to cache
                    CustomerUserMessageLogDetailsResponse response = new CustomerUserMessageLogDetailsResponse { CustomerUserMessageLogDetailsList = CustomerUserMessageLogDetailsList };

                    data = InsertIntoCache(routeUri, routeTemplate, response);
                }
            }
            return data;
        }
        #endregion
    }
}
