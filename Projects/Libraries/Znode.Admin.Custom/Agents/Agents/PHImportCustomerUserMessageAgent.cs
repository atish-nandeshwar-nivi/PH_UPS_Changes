using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Znode.Api.Client.Custom.Clients.Clients;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;

namespace Znode.Admin.Custom.Agents.Agents
{
    public class PHImportCustomerUserMessageAgent
    {
        private readonly PHImportCustomerUserMessageClient _PHImportCustomerUserMessageClient;

        public PHImportCustomerUserMessageAgent()
        {
            _PHImportCustomerUserMessageClient = new PHImportCustomerUserMessageClient();
        }
        //HttpPostedFileBase httpPostedFile
        public bool ImportCustomerUserMessage(HttpPostedFileBase FilePath)
        {
            bool status = false;
            string invalidColumn = string.Empty;
            try
            {
                List<CustomerUserMessageModel> listCustomerUserMessageModel = new List<CustomerUserMessageModel>();
                List<string> lines = new List<string>();
                using (System.IO.StreamReader reader = new System.IO.StreamReader(FilePath.InputStream))
                {
                    while (!reader.EndOfStream)
                    {
                        lines.Add(reader.ReadLine());
                    }
                }
                if (lines.Count > 0)
                {
                    //first line to create headers
                    string firstLine = lines[0].Replace(" ", "");
                    string[] headerLabel = firstLine.Split(',');

                    //for data
                    for (int r = 1; r < lines.Count; r++)
                    {
                        string[] dataWords = lines[r].Split(',');
                        CustomerUserMessageModel _CustomerUserMessageModel = new CustomerUserMessageModel();
                        int columnIndex = 0;
                        foreach (string headerWord in headerLabel)
                        {
                            switch (headerWord)
                            {

                                case "UserName":
                                    _CustomerUserMessageModel.UserName = dataWords[columnIndex++];
                                    break;
                                case "UserMessage":
                                    _CustomerUserMessageModel.UserMessage = dataWords[columnIndex++];
                                    break;
                                default:
                                    invalidColumn = "Invalid Column";
                                    break;
                            }
                        }
                        listCustomerUserMessageModel.Add(_CustomerUserMessageModel);
                    }
                }
                if (!string.IsNullOrEmpty(invalidColumn))
                {
                    return status = false;
                }
                status = _PHImportCustomerUserMessageClient.ImportCustomerUserMessage(listCustomerUserMessageModel);
            }
            catch (Exception)
            {
                status = false;
            }
            return status;
        }

        public List<CustomerUserMessageLogModel> GetCustomerUserMessageLog()
        {
            List<CustomerUserMessageLogModel> list = _PHImportCustomerUserMessageClient.GetCustomerUserMessageLog();
            return list;
        }

        public List<CustomerUserMessageLogDetailsModel> GetCustomerUserMessageLogDetails(int CustomerUserMessageLogId)
        {
            List<CustomerUserMessageLogDetailsModel> list = _PHImportCustomerUserMessageClient.GetCustomerUserMessageLogDetails(CustomerUserMessageLogId);
            return list;
        }
    }
}
