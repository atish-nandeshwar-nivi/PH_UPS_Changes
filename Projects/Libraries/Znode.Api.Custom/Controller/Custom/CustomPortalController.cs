using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations.Model;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using Znode.Api.Custom.Cache;
using Znode.Api.Custom.Service;
using Znode.Engine.Api.Controllers;
using Znode.Engine.Api.Helper;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Api.Model.Custom;
using Znode.Api.Model.Custom.Responses;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;

namespace Znode.Api.Custom.Controller.Custom
{
    public class CustomPortalController : BaseController
    {
        #region Private Variables
        private readonly ICustomPortalCache _customCache;
        private readonly ICustomPortalService _customService;

        #endregion

        #region Constructor
        public CustomPortalController(ICustomPortalService portalService)
        {
            _customService = portalService;
            _customCache = new CustomPortalCache(_customService);
        }
        #endregion

        /// <summary>
        /// Get Portal List.
        /// </summary>
        /// <returns>HttpResponseMessage</returns>
        [HttpGet]
        public HttpResponseMessage GetPortalList()
        {
            HttpResponseMessage response;
            try
            {
                string data = _customCache.GetSamplePortalList(RouteUri, RouteTemplate);
                response = string.IsNullOrEmpty(data) ? CreateNoContentResponse() : CreateOKResponse<CustomPortalDetailListResponse>(data);
            }
            catch (Exception ex)
            {
                CustomPortalDetailListResponse data = new CustomPortalDetailListResponse { HasError = true, ErrorMessage = ex.Message };
                response = CreateInternalServerErrorResponse(data);
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            return response;
        }

        /// <summary>
        /// Get Custom Portal Detail List.
        /// </summary>
        /// <returns>HttpResponseMessage</returns>
        [HttpGet]
        public HttpResponseMessage GetCustomPortalDetailList()
        {
            HttpResponseMessage response;
            try
            {
                string data = _customCache.GetCustomPortalDetailList(RouteUri, RouteTemplate);
                response = string.IsNullOrEmpty(data) ? CreateNoContentResponse() : CreateOKResponse<CustomPortalDetailListResponse>(data);
            }
            catch (Exception ex)
            {
                CustomPortalDetailListResponse data = new CustomPortalDetailListResponse { HasError = true, ErrorMessage = ex.Message };
                response = CreateInternalServerErrorResponse(data);
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            return response;
        }


        /// <summary>
        /// Get Custom Portal Details by Custom Portal Details Id.
        /// </summary>
        /// <param name="customPortalDetailId">Custom Portal Details Id</param>
        /// <returns>HttpResponseMessage</returns>
        [HttpGet]
        public HttpResponseMessage GetCustomPortalDetail(int customPortalDetailId)
        {
            HttpResponseMessage response;
            try
            {
                //Get the Custom Portal Details from Cache.
                string data = _customCache.GetCustomPortalDetail(customPortalDetailId, RouteUri, RouteTemplate);
                response = !string.IsNullOrEmpty(data) ? CreateOKResponse<CustomPortalResponse>(data) : CreateNoContentResponse();
            }
            catch (Exception ex)
            {
                CustomPortalResponse portalResponse = new CustomPortalResponse { HasError = true, ErrorMessage = ex.Message };
                response = CreateInternalServerErrorResponse(portalResponse);
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            return response;
        }

        /// <summary>
        /// Insert Portal Details.
        /// </summary>
        /// <param name="portalDetailModel">Portal Details Model.</param>
        /// <returns>HttpResponseMessage</returns>
        [HttpPost, ValidateModel]
        public HttpResponseMessage InsertCustomPortalDetail([FromBody] CustomPortalDetailModel portalDetailModel)
        {
            HttpResponseMessage response;
            try
            {

                //Insert Custom Portal Details.
                CustomPortalDetailModel portalDetail = _customService.InsertCustomPortalDetail(portalDetailModel);
                response = HelperUtility.IsNotNull(portalDetail) ? CreateCreatedResponse(new CustomPortalResponse { PortalDetail = portalDetail }) : CreateInternalServerErrorResponse();
            }
            catch (ZnodeException ex)
            {
                response = CreateInternalServerErrorResponse(new CustomPortalResponse { HasError = true, ErrorMessage = ex.Message, ErrorCode = ex.ErrorCode });
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new CustomPortalResponse { HasError = true, ErrorMessage = ex.Message });
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            return response;
        }


        /// <summary>
        /// Update Custom Portal Details.
        /// </summary>
        /// <param name="portalDetailModel">Portal Detail Model.</param>
        /// <returns>HttpResponseMessage</returns>
        [HttpPut]
        public HttpResponseMessage UpdateCustomPortalDetail([FromBody] CustomPortalDetailModel portalDetailModel)
        {
            HttpResponseMessage response;
            try
            {
                //Update the Custom Portal Details.
                bool isUpdated = _customService.UpdateCustomPortalDetail(portalDetailModel);
                response = isUpdated ? CreateOKResponse(new CustomPortalResponse { PortalDetail = portalDetailModel }) : CreateInternalServerErrorResponse();
            }
            catch (Exception ex)
            {
                CustomPortalResponse portalResponse = new CustomPortalResponse { HasError = true, ErrorMessage = ex.Message };
                response = CreateInternalServerErrorResponse(portalResponse);
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            return response;
        }

        /// <summary>
        /// Delete Custom Portal Details by Custom Portal Details Id.
        /// </summary>
        /// <param name="customPortalDetailIds">Id of Custom Portal Details to delete Custom Portal Details.</param>
        /// <returns>HttpResponseMessage</returns>
        [HttpPost]
        public HttpResponseMessage DeleteCustomPortalDetail([FromBody] ParameterModel customPortalDetailIds)
        {
            HttpResponseMessage response;
            try
            {
                //Delete the Custom Portal Details.
                bool isDeleted = true; //_customService.DeleteCustomPortalDetail(customPortalDetailIds);
                response = CreateOKResponse(new TrueFalseResponse { IsSuccess = isDeleted });
            }
            catch (ZnodeException ex)
            {
                TrueFalseResponse portalResponse = new TrueFalseResponse { HasError = true, ErrorCode = ex.ErrorCode };
                response = CreateInternalServerErrorResponse(portalResponse);
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            catch (Exception ex)
            {
                TrueFalseResponse portalResponse = new TrueFalseResponse { HasError = true };
                response = CreateInternalServerErrorResponse(portalResponse);
                ZnodeLogging.LogMessage(ex.Message, ZnodeLogging.Components.Portal.ToString());
            }
            return response;
        }

    }
}
