using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Znode.Admin.Custom.Helper
{
    public class CustomizedRazorViewEngine : RazorViewEngine
    {
        #region Constructor
        public CustomizedRazorViewEngine()
        {
            ViewLocationFormats = new[]
            {
               "~/Views/{1}/{0}.cshtml",
               "~/Views/Shared/{0}.cshtml",
               "~/Views/CustomViews/{0}.cshtml",
               "~/Views/CustomViews/{1}/{0}.cshtml"
            };

            PartialViewLocationFormats = new[]
            {
              "~/Views/{1}/{0}.cshtml",
              "~/Views/Shared/{0}.cshtml",
              "~/Views/CustomViews/{0}.cshtml",
              "~/Views/CustomViews/{1}/{0}.cshtml"
            };
        }
        #endregion

        #region Public Methods
        //Check file exits or not.
        protected override bool FileExists(ControllerContext controllerContext, string virtualPath)
        {
            try
            {
                return File.Exists(controllerContext.HttpContext.Server.MapPath(virtualPath));
            }
            catch (HttpException exception)
            {
                if (exception.GetHttpCode() != 0x194)
                {
                    throw;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        //Find View.
        public override ViewEngineResult FindView(ControllerContext controllerContext, string viewName, string masterName, bool useCache)
        {
            string[] strArray;
            string[] strArray2;

            if (Equals(controllerContext, null))
            {
                throw new ArgumentNullException("controllerContext");
            }
            if (string.IsNullOrEmpty(viewName))
            {
                throw new ArgumentException("View Name must be specified.", "viewName");
            }

            string requiredString = controllerContext.RouteData.GetRequiredString("controller");

            string viewPath = GetPath(controllerContext, ViewLocationFormats, "ViewLocationFormats", viewName, string.Empty, requiredString, "View", useCache, out strArray);
            string masterPath = GetPath(controllerContext, MasterLocationFormats, "MasterLocationFormats", masterName, string.Empty, requiredString, "Master", useCache, out strArray2);

            if (!string.IsNullOrEmpty(viewPath) && (!string.IsNullOrEmpty(masterPath) || string.IsNullOrEmpty(masterName)))
            {
                return new ViewEngineResult(CreateView(controllerContext, viewPath, masterPath), this);
            }
            strArray2 = new string[0];
            return new ViewEngineResult(strArray.Union(strArray2));
        }

        //Fine Partial View.
        public override ViewEngineResult FindPartialView(ControllerContext controllerContext, string partialViewName, bool useCache)
        {
            string[] strArray;
            if (Equals(controllerContext, null))
            {
                throw new ArgumentNullException("controllerContext");
            }
            if (string.IsNullOrEmpty(partialViewName))
            {
                throw new ArgumentException("Partial View Name must be specified.", "partialViewName");
            }

            string requiredString = controllerContext.RouteData.GetRequiredString("controller");
            string partialViewPath = GetPath(controllerContext, PartialViewLocationFormats, "PartialViewLocationFormats", partialViewName, string.Empty, requiredString, "Partial", useCache, out strArray);
            return string.IsNullOrEmpty(partialViewPath) ? new ViewEngineResult(strArray) : new ViewEngineResult(CreatePartialView(controllerContext, partialViewPath), this);
        }
        #endregion

        #region Private Methods
        private static readonly string[] _emptyLocations;

        //Get path.
        private string GetPath(ControllerContext controllerContext, string[] locations, string locationsPropertyName, string name, string themeName, string controllerName, string cacheKeyPrefix, bool useCache, out string[] searchedLocations)
        {
            searchedLocations = _emptyLocations;
            if (string.IsNullOrEmpty(name))
            {
                return string.Empty;
            }
            if (Equals(locations, null) || (locations.Length.Equals(0)))
            {
                throw new InvalidOperationException("locations must not be null or emtpy.");
            }

            bool flag = IsSpecificPath(name);
            string key = CreateCacheKey(cacheKeyPrefix, name, flag ? string.Empty : controllerName, string.Empty);
            if (useCache)
            {
                string viewLocation = ViewLocationCache.GetViewLocation(controllerContext.HttpContext, key);
                if (!Equals(viewLocation, null))
                {
                    return viewLocation;
                }
            }
            return !flag ? GetPathFromGeneralName(controllerContext, locations, name, controllerName, themeName, key, ref searchedLocations)
                        : GetPathFromSpecificName(controllerContext, name, key, ref searchedLocations);
        }

        private static bool IsSpecificPath(string name)
        {
            char ch = name[0];
            if (!Equals(ch, '~'))
            {
                return (ch == '/');
            }
            return true;
        }

        //Create cache key.
        private string CreateCacheKey(string prefix, string name, string controllerName, string themeName)
        {
            return string.Format(
                CultureInfo.InvariantCulture,
                ":ViewCacheEntry:{0}:{1}:{2}:{3}:{4}",
                new object[] { GetType().AssemblyQualifiedName, prefix, name, controllerName, themeName });
        }

        //Get path from general name.
        private string GetPathFromGeneralName(ControllerContext controllerContext, string[] locations, string name, string controllerName, string themeName, string cacheKey, ref string[] searchedLocations)
        {
            string virtualPath = string.Empty;
            searchedLocations = new string[locations.Length];
            for (int i = 0; i < locations.Length; i++)
            {
                string str2 = string.Format(CultureInfo.InvariantCulture, locations[i], new object[] { name, controllerName, themeName });

                if (FileExists(controllerContext, str2))
                {
                    searchedLocations = _emptyLocations;
                    virtualPath = str2;
                    ViewLocationCache.InsertViewLocation(controllerContext.HttpContext, cacheKey, virtualPath);
                    return virtualPath;
                }
                searchedLocations[i] = str2;
            }
            return virtualPath;
        }

        //Get path from specific name.
        private string GetPathFromSpecificName(ControllerContext controllerContext, string name, string cacheKey, ref string[] searchedLocations)
        {
            string virtualPath = name;
            if (!FileExists(controllerContext, name))
            {
                virtualPath = string.Empty;
                searchedLocations = new[] { name };
            }
            ViewLocationCache.InsertViewLocation(controllerContext.HttpContext, cacheKey, virtualPath);
            return virtualPath;
        }

        #endregion
    }
}
