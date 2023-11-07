using System;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Znode.Api.Custom.Cache;
using Znode.Api.Custom.Service;
using Znode.Api.Model.Custom;
using Znode.Engine.Api.Cache;
using Znode.Engine.Api.Helper;
using Znode.Engine.Api.Models;
using Znode.Engine.Api.Models.Responses;
using Znode.Engine.Exceptions;
using Znode.Engine.Services;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using static Znode.Libraries.ECommerce.Utilities.HelperUtility;

namespace Znode.Engine.Api.Controllers.OMS.ShoppingCartController
{
    public class PHShoppingCartController : ShoppingCartController
    {
        #region Private Variables
        private readonly IShoppingCartService _shoppingCartService;
        private readonly IShoppingCartCache _shoppingCartCache;
        private readonly IShippingCache _shippingcache;
        private readonly IShippingService _shippingservice;

        #endregion

        #region Constructor

        public PHShoppingCartController(IShoppingCartService shoppingCartService)
       : base(shoppingCartService)
        {
            _shippingservice = ZnodeDependencyResolver.GetService<IShippingService>();
            _shoppingCartService = shoppingCartService;
            _shoppingCartCache = new PHShoppingCartCache(_shoppingCartService);
            _shippingcache = new ShippingCache(_shippingservice);
        }
        #endregion

        #region Public Methods


        /// <summary>
        /// Get shipping estimates by zip code.
        /// </summary>
        /// <param name="zipCode">zip Code</param>
        /// <param name="model">ShoppingCartModel</param>
        /// <returns>Shipping estimates by zip code.</returns>
        [ResponseType(typeof(ShippingListResponse))]
        [HttpPost]
        public HttpResponseMessage GetCustomShippingEstimates(string zipCode, [FromBody] ShoppingCartModel model)
        {
            HttpResponseMessage response;
            try
            {
                ShippingListModel list = _shoppingCartCache.GetShippingEstimates(zipCode, RouteUri, model);
                response = IsNotNull(list) ? CreateOKResponse(new ShippingListResponse { ShippingList = list?.ShippingList }) : CreateNoContentResponse();
            }
            catch (ZnodeException ex)
            {
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Warning);
                response = CreateInternalServerErrorResponse(new ShippingListResponse { HasError = true, ErrorMessage = ex.Message, ErrorCode = ex.ErrorCode });
            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new ShippingListResponse { HasError = true, ErrorMessage = ex.Message });
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
            }
            return response;
        }

        /// <summary>
        /// Performs calculations for a shopping cart.
        /// </summary>
        /// <param name="model">The model of the shopping cart.</param>
        /// <returns>Performs calculations and gives Shopping Cart Response </returns>
        [ResponseType(typeof(ShoppingCartResponse))]
        [HttpPost]
        public HttpResponseMessage CustomCalculate([FromBody] ShoppingCartModel model)
        {
            HttpResponseMessage response;

            try
            {
                ShippingListModel list = _shippingservice.GetShippingList(null, new FilterCollection(), null, null);
                int Shipping2 = 0;
                int Shipping3 = 0;//Atish ups
                if (model.Shipping.ShippingId > 0)
                {
                    // adding the name to qualify for free freight based on system parameter in custom shipping types
                    ShippingModel v = list.ShippingList.FirstOrDefault(o => o.ShippingId == model.Shipping.ShippingId);
                    model.Shipping.ShippingName = v.ShippingCode;
                }
                if (model.Shipping.Custom1 != null)
                {
                    int.TryParse(model.Shipping.Custom1.ToString(), out Shipping2);
                    if (Shipping2 > 0)
                    {
                        ShippingModel m = list.ShippingList.FirstOrDefault(o => o.ShippingId == Shipping2);
                        if (m != null)
                        {
                            model.Shipping.Custom1 = m.ClassName;
                            model.Shipping.Custom2 = m.ShippingCode;
                        }

                    }
                }
                if (model.Shipping.Custom3 != null)//Atish ups
                {
                    int.TryParse(model.Shipping.Custom3.ToString(), out Shipping3);
                    if (Shipping3 > 0)
                    {
                        ShippingModel m = list.ShippingList.FirstOrDefault(o => o.ShippingId == Shipping3);
                        if (m != null)
                        {
                            model.Shipping.Custom3 = m.ClassName;
                            model.Shipping.Custom4 = m.ShippingCode;

                        }

                    }
                }

                ShoppingCartModel shoppingCartModel = _shoppingCartCache.Calculate(RouteUri, model);
                response = IsNotNull(shoppingCartModel) ? CreateOKResponse(new ShoppingCartResponse { ShoppingCart = shoppingCartModel }) : CreateNoContentResponse();
            }
            catch (ZnodeException ex)
            {
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Warning);
                response = CreateInternalServerErrorResponse(new ShoppingCartResponse { HasError = true, ErrorMessage = ex.Message, ErrorCode = ex.ErrorCode });
            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new ShoppingCartResponse { HasError = true, ErrorMessage = ex.Message });
                ZnodeLogging.LogMessage(ex, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
            }

            return response;
        }


        [ResponseType(typeof(BaseResponse))]
        [HttpPost]
        public HttpResponseMessage UpdateOptionalFees([FromBody] OptionalFeesParameterModel model)
        {
            HttpResponseMessage response= CreateNoContentResponse();

            try
            {
                var updated = ((CustomShoppingCartService)_shoppingCartService).UpdateOptionalFees(model.OmsSavedCardLineItemIds, model.OptionalfeesIds);
                response = updated ? CreateOKResponse(new BaseResponse { HasError = false, ErrorMessage = "success" } ) : CreateOKResponse(new BaseResponse { HasError = true, ErrorMessage = "fail" });

            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new BaseResponse { HasError = true, ErrorMessage = ex.Message });
            }

            return response;
        }

        //GetOptionalFees
        [ResponseType(typeof(BaseResponse))]
        [HttpGet]
        public HttpResponseMessage GetOptionalFees(string OmsSavedCardLineItemIds)
        {
            HttpResponseMessage response = CreateNoContentResponse();

            try
            {
                var feeIds= ((CustomShoppingCartService)_shoppingCartService).GetOptionalFeeIds(OmsSavedCardLineItemIds);
                response = CreateOKResponse(new BaseResponse { HasError = false, ErrorMessage = feeIds });
            }
            catch (Exception ex)
            {
                response = CreateInternalServerErrorResponse(new BaseResponse { HasError = true, ErrorMessage = ex.Message });
            }

            return response;
        }

        #endregion
    }
}