using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using Znode.Api.Custom.Maps;
using Znode.Custom.Data;
using Znode.Engine.Api.Models;
using Znode.Engine.Exceptions;
using Znode.Engine.Services;
using Znode.Engine.Services.Maps;
using Znode.Api.Model.Custom;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.Data.Helpers;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;

namespace Znode.Api.Custom.Service
{
    public class CustomPortalService : PortalService, ICustomPortalService
    {
        #region Private Variables
        private readonly IZnodeRepository<ZnodePortal> _portalRepository;
        private readonly IZnodeRepository<ZnodeCustomPortalDetail> _portalDetailRepository;

        #endregion

        #region Constructor
        public CustomPortalService()
        {
            _portalRepository = new ZnodeRepository<ZnodePortal>();
            _portalDetailRepository = new ZnodeRepository<ZnodeCustomPortalDetail>(new Custom_Entities());
        }

        #endregion

        #region Public Methods
        //Get the list of all portals.
        public CustomPortalDetailListModel GetPortalList(NameValueCollection expands, FilterCollection filters, NameValueCollection sorts, NameValueCollection page)
        {
            //Set Authorized Portal filter based on user portal access.
            BindUserPortalFilter(ref filters);

            //Bind the Filter, sorts & Paging details.
            PageListModel pageListModel = new PageListModel(filters, sorts, page);

            //Get the Portal Details List.
            IList<ZnodePortal> portals = _portalRepository.GetPagedList(pageListModel.EntityWhereClause.WhereClause, pageListModel.OrderBy, GetExpands(expands), pageListModel.EntityWhereClause.FilterValues, pageListModel.PagingStart, pageListModel.PagingLength, out pageListModel.TotalRowCount);

            List<CustomPortalDetailModel> cutomPortalList = null;
            if (portals?.Count > 0)
            {
                int pageCount = 0;
                FilterCollection customfilters = new FilterCollection();
                customfilters.Add(new FilterTuple(ZnodePortalEnum.PortalId.ToString(), FilterOperators.In, string.Join(",", portals.Select(x => x.PortalId))));

                cutomPortalList = _portalDetailRepository.GetPagedList(DynamicClauseHelper.GenerateDynamicWhereClauseWithFilter(customfilters.ToFilterDataCollection())?.WhereClause, "", 1, 1, out pageCount)?.ToModel<CustomPortalDetailModel>()?.ToList();
            }
            CustomPortalDetailListModel portalList = SampleMap.ToListModel(portals, cutomPortalList);
            //Set for pagination
            portalList.BindPageListModel(pageListModel);
            return portalList;
        }

        //Get the list of all custom portal detail.
        public CustomPortalDetailListModel GetCustomPortalDetailList(NameValueCollection expands, FilterCollection filters, NameValueCollection sorts, NameValueCollection page)
        {
            //Set Authorized Portal filter based on user portal access.
            BindUserPortalFilter(ref filters);

            //Bind the Filter, sorts & Paging details.
            PageListModel pageListModel = new PageListModel(filters, sorts, page);

            //Get the Portal Details List.
            IZnodeViewRepository<CustomPortalDetailModel> objStoredProc = new ZnodeViewRepository<CustomPortalDetailModel>();
            objStoredProc.SetParameter("@WhereClause", pageListModel.SPWhereClause, ParameterDirection.Input, DbType.String);
            objStoredProc.SetParameter("@Rows", pageListModel.PagingLength, ParameterDirection.Input, DbType.Int32);
            objStoredProc.SetParameter("@PageNo", pageListModel.PagingStart, ParameterDirection.Input, DbType.Int32);
            objStoredProc.SetParameter("@Order_By", pageListModel.OrderBy, ParameterDirection.Input, DbType.String);
            objStoredProc.SetParameter("@RowCount", pageListModel.TotalRowCount, ParameterDirection.Output, DbType.Int32);
            IList<CustomPortalDetailModel> list = objStoredProc.ExecuteStoredProcedureList("Znode_GetCustomePortalDetailList @WhereClause,@Rows,@PageNo,@Order_By,@RowCount OUT", 4, out pageListModel.TotalRowCount);

            CustomPortalDetailListModel customPortalDetailModel = new CustomPortalDetailListModel() { CustomPortalDetailList = list?.ToList() };

            //Set for pagination
            customPortalDetailModel.BindPageListModel(pageListModel);
            return customPortalDetailModel;
        }

        //Get Custom Portal details by Custom Portal Detail Id.
        public CustomPortalDetailModel GetCustomPortalDetail(int customPortalId, NameValueCollection expands)
        {
            if (customPortalId < 1)
                throw new ZnodeException(ErrorCodes.NotFound, "Custom Portal Detail Id can not be less than 1.");

            CustomPortalDetailModel portalDetail = new CustomPortalDetailModel();

            PortalModel portalModel = base.GetPortal(customPortalId, expands);
            if (HelperUtility.IsNotNull(portalModel) && portalModel.PortalId > 0)
            {
                //Get Custom Portal Details By Custom Portal Details Id.
                portalDetail = _portalDetailRepository.Table.Where(x => x.PortalId == customPortalId)?.FirstOrDefault()?.ToModel<CustomPortalDetailModel>();

                portalDetail = SampleMap.ToCustomModel(portalModel, portalDetail);
            }
            return portalDetail;
        }

        //Insert the CustomPortalDetailModel Portal Details.
        public CustomPortalDetailModel InsertCustomPortalDetail(CustomPortalDetailModel portalDetailModel)
        {
            if (HelperUtility.IsNull(portalDetailModel))
                throw new ZnodeException(ErrorCodes.NullModel, "Model can not be null.");

            CustomPortalDetailModel portalDetail = new CustomPortalDetailModel();

            //Insert Portal Details.
            PortalModel portal = base.CreatePortal(portalDetailModel);
            if (portal?.PortalId > 0)
            {
                //Insert Portal Custom Detail.
                portalDetail = _portalDetailRepository.Insert(portalDetailModel.ToEntity<ZnodeCustomPortalDetail>())?.ToModel<CustomPortalDetailModel>();
                ZnodeLogging.LogMessage(HelperUtility.IsNull(portalDetail) ? "Error Occurred while Insertion of Portal Details." : "Portal Details created successfully.");
            }
            return portalDetail;
        }

        //Update Custom Portal Details.
        public bool UpdateCustomPortalDetail(CustomPortalDetailModel portalDetailModel)
        {
            if (HelperUtility.IsNull(portalDetailModel))
                throw new Exception("Model can not be null.");

            if (portalDetailModel.PortalId < 1)
                throw new Exception("Portal Id can not be less than 1.");

            //Insert Portal Details.
            if (base.UpdatePortal(portalDetailModel))
            {
                if (portalDetailModel.CustomePortalDetailsId > 0)
                    return _portalDetailRepository.Update(portalDetailModel.ToEntity<ZnodeCustomPortalDetail>());
                else
                    return _portalDetailRepository.Insert(portalDetailModel.ToEntity<ZnodeCustomPortalDetail>())?.CustomePortalDetailsId > 0;
            }
            return false;
        }

        //Delete Custom Portal details by Custom Portal Detail Id.
        public override bool DeletePortal(ParameterModel customPortalDetailIds, bool isDeleteByStoreCode)
        {
            if (Equals(customPortalDetailIds, null) || string.IsNullOrEmpty(customPortalDetailIds.Ids))
                throw new ZnodeException(ErrorCodes.NullModel, "Custom Portal Detail Id can not be less than 1.");

            FilterCollection filters = new FilterCollection();
            filters.Add(new FilterTuple(ZnodePortalEnum.PortalId.ToString(), ProcedureFilterOperators.In, customPortalDetailIds.Ids.ToString()));

            //Delete Custom Portal Details.
            bool status = _portalDetailRepository.Delete(DynamicClauseHelper.GenerateDynamicWhereClauseWithFilter(filters.ToFilterDataCollection()).WhereClause);

            //Delete Portal Details.
            return status ? base.DeletePortal(customPortalDetailIds, isDeleteByStoreCode) : false;
        }

        #endregion

        #region Private Methods
        //Get expands and add them to navigation properties
        private List<string> GetExpands(NameValueCollection expands)
        {
            List<string> navigationProperties = new List<string>();
            if (expands != null && expands.HasKeys())
            {

                foreach (string key in expands.Keys)
                {
                    if (Equals(key, ZnodePortalEnum.ZnodeDomains.ToString().ToLower())) SetExpands(ZnodePortalEnum.ZnodeDomains.ToString(), navigationProperties);
                    if (Equals(key, ZnodePortalFeatureMapperEnum.ZnodePortalFeature.ToString().ToLower())) SetExpands(ZnodePortalFeatureMapperEnum.ZnodePortalFeature.ToString(), navigationProperties);
                    if (Equals(key, ZnodePortalEnum.ZnodeOmsOrderState.ToString().ToLower())) SetExpands(ZnodePortalEnum.ZnodeOmsOrderState.ToString(), navigationProperties);
                    if (Equals(key, ZnodePortalAlternateWarehouseEnum.ZnodeWarehouse.ToString().ToLower())) SetExpands(ZnodePortalAlternateWarehouseEnum.ZnodeWarehouse.ToString(), navigationProperties);
                    if (Equals(key, ZnodePortalEnum.ZnodePortalCatalogs.ToString().ToLower())) SetExpands(ZnodePortalEnum.ZnodePortalCatalogs.ToString(), navigationProperties);
                    if (Equals(key, ZnodePortalEnum.ZnodePortalLocales.ToString().ToLower())) SetExpands(ZnodePortalEnum.ZnodePortalLocales.ToString(), navigationProperties);
                }
            }
            return navigationProperties;
        }
        #endregion
    }
}
