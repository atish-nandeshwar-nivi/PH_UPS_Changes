using Znode.Engine.Api.Client.Expands;
using Znode.Engine.Api.Client.Sorts;
using Znode.Engine.Api.Models;
using Znode.Api.Model.Custom;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.Admin.Custom.Clients
{
    public interface ICustomClient
    {
        /// <summary>
        /// List of Portal.
        /// </summary>
        /// <param name="expands">ExpandCollection</param>
        /// <param name="filters">FilterCollection</param>
        /// <param name="sorts">SortCollection</param>
        /// <param name="pageIndex">Start Page Index</param>
        /// <param name="pageSize">Page Size</param>
        /// <returns>Return the List of Store in SamplePortalListModel Model</returns>
        CustomPortalDetailListModel GetPortalList(ExpandCollection expands, FilterCollection filters, SortCollection sorts, int? pageIndex, int? pageSize);

        /// <summary>
        /// List of Custom Portal Details.
        /// </summary>
        /// <param name="expands">ExpandCollection</param>
        /// <param name="filters">FilterCollection</param>
        /// <param name="sorts">SortCollection</param>
        /// <param name="pageIndex">Start Page Index</param>
        /// <param name="pageSize">Page Size</param>
        /// <returns>Return the List of Store in CustomPortalDetailListModel Model</returns>
        CustomPortalDetailListModel GetCustomPortalDetailList(ExpandCollection expands, FilterCollection filters, SortCollection sorts, int? pageIndex, int? pageSize);


        /// <summary>
        /// Get Custom Portal details by Custom Portal Id.
        /// </summary>
        /// <param name="customPortalId">Id of Custom Portal Detail to get Custom Portal details.</param>
        /// <returns>Return Custom Portal Details in CustomPortalModel Format.</returns>
        CustomPortalDetailModel GetCustomPortalDetail(int customPortalId, ExpandCollection expands);

        /// <summary>
        /// Insert Custom Portal Details.
        /// </summary>
        /// <param name="customPortalDetailModel">Custom Portal Details Model</param>
        /// <returns>Return Custom Portal Details in CustomPortalDetailModel Format.</returns>
        CustomPortalDetailModel InsertCustomPortalDetail(CustomPortalDetailModel customPortalDetailModel);

        /// <summary>
        /// Update Custom Portal Details.
        /// </summary>
        /// <param name="customPortalDetailModel">Custom Portal Details Model</param>
        /// <returns>Return Custom Portal Details in CustomPortalDetailModel Format.</returns>
        CustomPortalDetailModel UpdateCustomPortalDetail(CustomPortalDetailModel customPortalDetailModel);

        /// <summary>
        /// Delete Custom Portal Details by Custom Portal Detail Id.
        /// </summary>
        /// <param name="customPortalDetailIds">Id of Custom Portal Detail to delete Custom Portal Details.</param>
        /// <returns>return true if deleted else false.</returns>
        bool DeleteCustomPortalDetail(ParameterModel customPortalDetailIds);
    }
}