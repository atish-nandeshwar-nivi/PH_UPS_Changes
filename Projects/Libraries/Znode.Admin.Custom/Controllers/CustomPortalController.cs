using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Znode.Admin.Custom.Agents;
using Znode.Admin.Custom.ViewModels;
using Znode.Engine.Admin.Agents;
using Znode.Engine.Admin.Controllers;
using Znode.Engine.Admin.Helpers;
using Znode.Engine.Admin.Models;
using Znode.Engine.Admin.ViewModels;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Resources;

namespace Znode.Admin.Custom.Controllers
{
    public class CustomPortalController : BaseController
    {
        #region Private Variable       
        private readonly ICustomPortalAgent _customPortalAgent;
        private readonly IStoreAgent _portalAgent;
        #endregion

        #region Constructor
        public CustomPortalController(ICustomPortalAgent customPortalAgent, IStoreAgent portalAgent)
        {
            _customPortalAgent = customPortalAgent;
            _portalAgent = portalAgent;
        }
        #endregion

        #region Public Methods
        //Get the List of Stores
        public ActionResult List([ModelBinder(typeof(PageDataBinder))] FilterCollectionDataModel model)
        {
            //Get the list of all stores.
            CustomPortalDetailListViewModel storeList = _customPortalAgent.GetCustomPortalDetailList(model.Filters, model.SortCollection, model.Page, model.RecordPerPage);

            //Get the grid model.
            storeList.GridModel = FilterHelpers.GetDynamicGridModel(model, storeList.CustomPortalDetailList, "ZnodeCustomPortal", string.Empty, null, true, true, storeList?.GridModel?.FilterColumn?.ToolMenuList);

            //Set the total record count
            storeList.GridModel.TotalRecordCount = storeList.TotalResults;
            return ActionView("List", storeList);
        }

        //Get the Custom Portal Details List.
        public ActionResult CustomPortalDetailList([ModelBinder(typeof(PageDataBinder))] FilterCollectionDataModel model)
        {
            //Get the list of all custom portal detail.
            CustomPortalDetailListViewModel customPortalDetailList = _customPortalAgent.GetCustomPortalDetailList(model.Filters, model.SortCollection, model.Page, model.RecordPerPage);

            //Get the grid model.
            customPortalDetailList.GridModel = FilterHelpers.GetDynamicGridModel(model, customPortalDetailList.CustomPortalDetailList, "ZnodeCustomPortalDetail", string.Empty, null, true, true, customPortalDetailList?.GridModel?.FilterColumn?.ToolMenuList);

            //Set the total record count
            customPortalDetailList.GridModel.TotalRecordCount = customPortalDetailList.TotalResults;

            return ActionView("CustomPortalDetailList", customPortalDetailList);
        }

        #region Custom Portal

        //Get type method to create new store.
        //[Route("Store/CreateStore")]
        [HttpGet]
        public ActionResult CreateStore()
            => ActionView("CreateEditPortal", _customPortalAgent.SetStoreInformation(_portalAgent.GetStoreInformation(new StoreViewModel())));


        //Post type method to create new store.
        //[Route("Store/CreateStore")]
        [HttpPost]
        public ActionResult CreateStore(CustomPortalDetailViewModel storeViewModel)
        {
            CustomPortalDetailViewModel portalViewModel = _customPortalAgent.InsertCustomPortalDetail(storeViewModel);
            if (HelperUtility.IsNotNull(portalViewModel))
            {
                if (!portalViewModel.HasError)
                {
                    SetNotificationMessage(GetSuccessNotificationMessage(Admin_Resources.RecordCreationSuccessMessage));
                    return RedirectToAction<CustomPortalController>(x => x.EditStore(portalViewModel.PortalId));
                }
                else
                {
                    SetNotificationMessage(GetErrorNotificationMessage(portalViewModel.ErrorMessage));
                    return RedirectToAction<CustomPortalController>(x => x.CreateStore());
                }
            }
            SetNotificationMessage(GetErrorNotificationMessage(Admin_Resources.ErrorFailedToCreate));
            return RedirectToAction<CustomPortalController>(x => x.CreateStore());
        }


        [HttpGet]
        //[Route("Store/EditStore")]
        public ActionResult EditStore(int portalId)
        {
            CustomPortalDetailViewModel viewModel = _customPortalAgent.GetCustomPortalDetail(portalId);
            return ActionView("CreateEditPortal", viewModel);
        }

        //Post type method to update store.
        [HttpPost]
        //[Route("Store/EditStore")]
        public ActionResult EditStore(CustomPortalDetailViewModel storeViewModel)
        {
            if (!Equals(storeViewModel, null))
            {
                if (_customPortalAgent.UpdateCustomPortalDetail(storeViewModel))
                {
                    TempData[AdminConstants.Notifications] = GenerateNotificationMessages(Admin_Resources.UpdateMessage, NotificationType.success);
                    return RedirectToAction<CustomPortalController>(x => x.EditStore((storeViewModel.PortalId)));
                }
            }
            TempData[AdminConstants.Notifications] = GenerateNotificationMessages(Admin_Resources.UpdateErrorMessage, NotificationType.error);
            return ActionView("CreateEditPortal", storeViewModel);
        }
        #endregion

        #endregion
    }
}
