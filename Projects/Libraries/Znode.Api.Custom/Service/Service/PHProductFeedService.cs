using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Hosting;
using Znode.Engine.Api.Models;
using Znode.Engine.Services;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
namespace Znode.Api.Custom.Service.Service
{
    public class PHProductFeedService : ProductFeedService
    {

        #region Private Variables
        private readonly string strNamespace = ZnodeApiSettings.SiteMapNameSpace;
        private readonly string strGoogleFeedNamespace = ZnodeApiSettings.GoogleProductFeedNameSpace;
        private const string ItemCategory = "category";
        private const string ItemContentPages = "content";
        private const string ItemProduct = "product";
        private readonly string ItemUrlset = "urlset";
        private const string ItemAll = "all";
        private readonly IZnodeRepository<ZnodeProductFeed> _productFeedRepository;
        private readonly IZnodeRepository<ZnodeProductFeedSiteMapType> _productFeedSiteMapTypeRepository;
        private readonly IZnodeRepository<ZnodeProductFeedType> _productFeedTypeRepository;
        private const string SITEMAP_FILE_PATTERN = @"\w+_\d+\.xml"; // sitemapAll_0.xml  sitemapAll_2022-06-0308-19-46.xml
        #endregion
        #region Constructor
        public PHProductFeedService() : base()
        {
            _productFeedRepository = new ZnodeRepository<ZnodeProductFeed>();
            _productFeedSiteMapTypeRepository = new ZnodeRepository<ZnodeProductFeedSiteMapType>();
            _productFeedTypeRepository = new ZnodeRepository<ZnodeProductFeedType>();
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Overidden to copy sitemap file from API path to webstore path
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public override ProductFeedModel CreateGoogleSiteMap(ProductFeedModel model)
        {
            DeleteProductFeedSiteMapFiles();
            base.CreateGoogleSiteMap(model);
            CopyProductFeedSiteMapFile(model);
            return model;
        }

        /// <summary>
        /// Overidden to copy sitemap file from API path to webstore path
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public override bool UpdateProductFeed(ProductFeedModel model)
        {
            DeleteProductFeedSiteMapFiles();
            base.UpdateProductFeed(model);
            CopyProductFeedSiteMapFile(model);
            return true;
        }
        #endregion

        #region private mehtods
        private void CopyProductFeedSiteMapFile(ProductFeedModel model)
        {
            try
            {
                string fileName = string.Empty;
                string sourcePath = HostingEnvironment.ApplicationPhysicalPath+ "Data\\Media\\SiteMap";
                string customSiteMapFilePath = Convert.ToString(ConfigurationManager.AppSettings["SiteMapFilePath"]);
                string targetPath = Path.GetDirectoryName(customSiteMapFilePath) + Path.DirectorySeparatorChar;

                // create directory if not exists
                Directory.CreateDirectory(Path.GetDirectoryName(customSiteMapFilePath));

                if (Directory.Exists(sourcePath))
                {
                    foreach (string s in Directory.GetFiles(sourcePath))
                    {
                        fileName = Path.GetFileName(s);
                        string txtXMLFileName = string.Empty;
                        //Rename existing file to custom sitemap File name 
                        if (Regex.IsMatch(fileName, SITEMAP_FILE_PATTERN))
                        {
                            if (model.ProductFeedTypeCode == "Google")
                            {
                                txtXMLFileName = fileName.Replace(fileName, "googlefeed.xml");
                            }
                            else if (model.ProductFeedSiteMapTypeCode == "Category")
                            {
                                txtXMLFileName = fileName.Replace(fileName, "sitemapcategory.xml");
                            }
                            else if (model.ProductFeedSiteMapTypeCode == "Content")
                            {
                                txtXMLFileName = fileName.Replace(fileName, "sitemapcontent.xml");
                            }
                            else if (model.ProductFeedSiteMapTypeCode == "ALL")
                            {
                                txtXMLFileName = fileName.Replace(fileName, "sitemap.xml");
                            }
                            else if (model.ProductFeedSiteMapTypeCode == "Product")
                            {
                                txtXMLFileName = fileName.Replace(fileName, "sitemapproduct.xml");
                            }
                            else
                            {
                                txtXMLFileName = fileName;
                            }
                        }
                        File.Copy(s, Path.Combine(targetPath, txtXMLFileName), true);
                    }
                }
            }
            catch (Exception Ex)
            {
                ZnodeLogging.LogMessage("CopyProductFeedSiteMapFile Ex:-" + Ex, ZnodeLogging.Components.WebstoreApplicationError.ToString(), TraceLevel.Error);
            }

        }

        private void DeleteProductFeedSiteMapFiles()
        {
            try
            {
                string sourcePath = Path.Combine(HostingEnvironment.ApplicationPhysicalPath, ZnodeConfigManager.EnvironmentConfig.ContentPath.Replace("~/", ""));

                if (Directory.Exists(sourcePath))
                {
                    foreach (string s in Directory.GetFiles(sourcePath))
                    {
                        File.Delete(s);
                    }
                }
            }
            catch (Exception Ex)
            {
                ZnodeLogging.LogMessage("DeleteProductFeedSiteMapFiles Ex:-" + Ex, ZnodeLogging.Components.WebstoreApplicationError.ToString(), TraceLevel.Error);
            }

        }

        #endregion

    }

}
