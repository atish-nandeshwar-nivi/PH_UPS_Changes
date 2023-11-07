using System.Collections.Specialized;
using Znode.Api.Model.Custom;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.Api.Custom.Service
{
    public interface ICustomPortalService
    {
        /// <summary>
        /// Get the list of all portals.
        /// </summary>
        /// <param name="expands">Expand Collection.</param>
        /// <param name="filters">Filter collection.</param>
        /// <param name="sorts">Sort Collection.</param>
        /// <param name="Page">paging parameters.</param>
        /// <returns>PortalsList Model.</returns>
        CustomPortalDetailListModel GetPortalList(NameValueCollection expands, FilterCollection filters, NameValueCollection sorts, NameValueCollection Page);

        /// <summary>
        /// Get the list of all custom portal detail.
        /// </summary>
        /// <param name="expands">Expand Collection.</param>
        /// <param name="filters">Filter collection.</param>
        /// <param name="sorts">Sort Collection.</param>
        /// <param name="Page">paging parameters.</param>
        /// <returns>CustomPortalDetailListModel Model.</returns>
        CustomPortalDetailListModel GetCustomPortalDetailList(NameValueCollection expands, FilterCollection filters, NameValueCollection sorts, NameValueCollection Page);


        /// <summary>
        /// Get Custom Portal details by Custom Portal Detail Id.
        /// </summary>
        /// <param name="customPortalDetailId">Id of Custom Portal Detail to get Custom Portal details.</param>
        /// <returns>Return Custom Portal Details in CustomPortalDetailModel Format.</returns>
        CustomPortalDetailModel GetCustomPortalDetail(int customPortalDetailId, NameValueCollection expands);

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
        /// <returns>return true if portal update else false.</returns>
        bool UpdateCustomPortalDetail(CustomPortalDetailModel customPortalDetailModel);

        /// <summary>
        /// Delete Custom Portal Details by Custom Portal Detail Id.
        /// </summary>
        /// <param name="customPortalDetailIds">Id of Custom Portal Detail to delete Custom Portal Details.</param>
        /// <returns>return true if deleted else false.</returns>
        // bool DeleteCustomPortalDetail(ParameterModel customPortalDetailIds);
    }
}
