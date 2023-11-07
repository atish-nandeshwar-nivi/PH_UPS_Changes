using Znode.Admin.Custom.ViewModels;
using Znode.Engine.Admin.ViewModels;
using Znode.Engine.Api.Client.Sorts;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.Admin.Custom.Agents
{
    public interface ICustomPortalAgent
    {
        /// <summary>
        /// List of Store.
        /// </summary>
        /// <param name="filters">FilterCollection</param>
        /// <param name="sorts">SortCollection</param>
        /// <param name="pageIndex">Start Page Index</param>
        /// <param name="pageSize">Page Size</param>
        /// <returns>Return the List of Store in SamplePortalListViewModel Model</returns>
        CustomPortalDetailListViewModel GetStoreList(FilterCollection filters = null, SortCollection sorts = null, int? pageIndex = default(int?), int? pageSize = default(int?));

        /// <summary>
        /// List of Custom Portal Details.
        /// </summary>
        /// <param name="filters">FilterCollection</param>
        /// <param name="sorts">SortCollection</param>
        /// <param name="pageIndex">Start Page Index</param>
        /// <param name="pageSize">Page Size</param>
        /// <returns>Return the List of Store in CustomPortalDetailListViewModel Model</returns>
        CustomPortalDetailListViewModel GetCustomPortalDetailList(FilterCollection filters = null, SortCollection sorts = null, int? pageIndex = default(int?), int? pageSize = default(int?));


        /// <summary>
        /// Get Custom Portal details by Custom Portal Id.
        /// </summary>
        /// <param name="customPortalId">Id of Custom Portal Detail.</param>
        /// <returns>Return Custom Portal Details in CustomPortalViewModel.</returns>
        CustomPortalDetailViewModel GetCustomPortalDetail(int customPortalId);

        /// <summary>
        /// Insert the Customized Portal Details.
        /// </summary>
        /// <param name="portalDetailModel">Custom Portal Details Model</param>
        /// <returns>Return Custom Portal Details in CustomPortalDetailViewModel.</returns>
        CustomPortalDetailViewModel InsertCustomPortalDetail(CustomPortalDetailViewModel portalDetailModel);

        /// <summary>
        /// Update Custom Portal Details.
        /// </summary>
        /// <param name="portalDetailModel">Custom Portal Details Model</param>
        /// <returns>returns true if Custom Portal Details updated else false.</returns>
        bool UpdateCustomPortalDetail(CustomPortalDetailViewModel portalDetailModel);

        /// <summary>
        /// Set Create page information for Store.
        /// </summary>
        /// <param name="model">StoreViewModel</param>
        /// <returns>CustomPortalDetailViewModel</returns>
        CustomPortalDetailViewModel SetStoreInformation(StoreViewModel model);
    }
}
