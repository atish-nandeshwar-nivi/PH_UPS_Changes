using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Znode.Engine.Api.Models;
using Znode.Libraries.Resources;

namespace Znode.Api.Model.Custom
{
    public class SamplePortalModel : BaseModel
    {
        public int PortalId { get; set; }
        public int? PublishCatalogId { get; set; }
        public int? LocaleId { get; set; }
        public int? CMSThemeId { get; set; }
        public int OrderStatusId { get; set; }
        public string DefaultCurrency { get; set; }
        public string DefaultDimensionUnit { get; set; }
        public string DefaultWeightUnit { get; set; }
        public string ReviewStatus { get; set; }
        public string ThemeName { get; set; }
        public string ProductReviewStatus { get; set; }
        public string OrderStatus { get; set; }

        [StringLength(100, ErrorMessageResourceType = typeof(Api_Resources), ErrorMessageResourceName = ZnodeApi_Resources.Errorlength)]
        public string StoreName { get; set; }

        [StringLength(100, ErrorMessageResourceType = typeof(Api_Resources), ErrorMessageResourceName = ZnodeApi_Resources.Errorlength)]
        public string CompanyName { get; set; }
        public string AdministratorEmail { get; set; }
        public string SalesEmail { get; set; }
        public string DomainUrl { get; set; }
        public string CustomerServiceEmail { get; set; }
        public string ImageNotAvailablePath { get; set; }
        public string SalesPhoneNumber { get; set; }
        public string MediaServerUrl { get; set; }
        public string MediaServerThumbnailUrl { get; set; }
        public string CustomerServicePhoneNumber { get; set; }
        public string[] PortalFeatureIds { get; set; }
        public bool IsEnableSSL { get; set; }
        public int CMSThemeCSSId { get; set; }
        public int ProfileId { get; set; }
        public int? CopyContentPortalId { get; set; }
        public string CopyContentPortalName { get; set; }
        public string InStockMsg { get; set; }
        public string OutOfStockMsg { get; set; }
        public string BackOrderMsg { get; set; }

        public List<SamplePortalFeatureModel> SelectedPortalFeatures { get; set; }
        public List<SamplePortalFeatureModel> AvailablePortalFeatures { get; set; }

        public Dictionary<string, bool> PortalFeatureValues { get; set; }
    }
}
