namespace Znode.Api.Custom.Cache
{
    public interface ICustomPortalCache
    {
        /// <summary>
        /// Get the list of all portals.
        /// </summary>
        /// <param name="routeUri">URI to route.</param>
        /// <param name="routeTemplate">Template of route.</param>
        /// <returns>list of portal in string format by serializing it.</returns>
        string GetSamplePortalList(string routeUri, string routeTemplate);

        /// <summary>
        /// Get the list Custom Portal Detail.
        /// </summary>
        /// <param name="routeUri">URI to route.</param>
        /// <param name="routeTemplate">Template of route.</param>
        /// <returns>list of portal in string format by serializing it.</returns>
        string GetCustomPortalDetailList(string routeUri, string routeTemplate);


        /// <summary>
        /// Get the Custom Portal details by Custom Portal Detail Id.
        /// </summary>
        /// <param name="portalDetailId">Id of Custom Portal Detail to Get Custom Portal Details.</param>
        /// <param name="routeUri">URI to route.</param>
        /// <param name="routeTemplate">Template of route.</param>
        /// <returns>Custom Portal Detail Model in string format by serializing it.</returns>
        string GetCustomPortalDetail(int portalDetailId, string routeUri, string routeTemplate);
    }
}
