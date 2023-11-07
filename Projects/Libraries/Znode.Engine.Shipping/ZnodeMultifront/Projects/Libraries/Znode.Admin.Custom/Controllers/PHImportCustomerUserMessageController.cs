using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Znode.Admin.Custom.Agents.Agents;
using Znode.Admin.Custom.ViewModel;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;
using Znode.Engine.Admin.Controllers;

namespace Znode.Admin.Custom.Controllers
{
    public class PHImportCustomerUserMessageController : BaseController
    {
        private readonly PHImportCustomerUserMessageAgent _PHImportCustomerUserMessageAgent;

        public PHImportCustomerUserMessageController()
        {
            _PHImportCustomerUserMessageAgent = new PHImportCustomerUserMessageAgent();
        }
        //HttpPostedFileBase httpPostedFile
        public ActionResult Index()
        {
            return ActionView("Index");
        }

        public ActionResult ImportCustomerUserMessage(HttpPostedFileBase FilePath)
        {
            bool status = false;
            if (FilePath != null)
            {
                if (FilePath.ContentType == "text/csv")
                {
                    status = _PHImportCustomerUserMessageAgent.ImportCustomerUserMessage(FilePath);
                    if (!status)
                    {
                        ViewBag.FileMessage = "Invalid Columns";
                        return ActionView("Index");
                    }
                    return RedirectToAction("CustomerUserMessageLogs");
                }
                else
                {
                    ViewBag.FileMessage = "Please Select valid .csv file";
                    return ActionView("Index");
                }
            }
            else
            {
                ViewBag.FileMessage = "Please Select the template";
                return ActionView("Index");
            }
        }

        public FileContentResult DownloadImportCustomerUserMessage()
        {
            string csv = "UserName, UserMessage";
            return File(new System.Text.UTF8Encoding().GetBytes(csv), "text/csv", "CustomerUserMessage.csv");
        }

        public ActionResult CustomerUserMessageLogs()
        {
            List<CustomerUserMessageLogModel> model = _PHImportCustomerUserMessageAgent.GetCustomerUserMessageLog();
            List<CustomerUserMessageLogViewModel> viewModel = new List<CustomerUserMessageLogViewModel>();
            model?.ForEach(x =>
            {
                viewModel.Add(new CustomerUserMessageLogViewModel()
                {
                     CustomerUserMessageLogId = x.CustomerUserMessageLogId,
                     Status = x.Status,
                     TotalRecords = x.TotalRecords,
                     SuceessRecords = x.SuceessRecords,
                     FailRecords = x.FailRecords,
                     CreatedBy = x.CreatedBy,
                     CreatedDate = x.CreatedDate
                });
            });
            return ActionView("CustomerUserMessageLogs", viewModel);
        }

        public PartialViewResult CustomerUserMessageLogDetails(string id)
        {
            int CustomerUserMessageLogId = Convert.ToInt32(id);
            List<CustomerUserMessageLogDetailsModel> model = _PHImportCustomerUserMessageAgent.GetCustomerUserMessageLogDetails(CustomerUserMessageLogId);
            List<CustomerUserMessageLogDetailsViewModel> viewModel = new List<CustomerUserMessageLogDetailsViewModel>();
            model?.ForEach(x =>
            {
                viewModel.Add(new CustomerUserMessageLogDetailsViewModel()
                {
                    CustomerUserMessageLogDetailsId = x.CustomerUserMessageLogDetailsId,
                    CustomerUserMessageLogId = x.CustomerUserMessageLogId,
                    UserName = x.UserName,
                    ErrorMessage = x.ErrorMessage,
                    CreatedBy = x.CreatedBy,
                    CreatedDate = x.CreatedDate
                });
            });
            return PartialView("_CustomerUserMessageLogDetails", viewModel);
        }
    }
}
