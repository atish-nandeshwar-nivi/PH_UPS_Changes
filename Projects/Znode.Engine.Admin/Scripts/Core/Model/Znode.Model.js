var Constant;
(function (Constant) {
    Constant.GET = "GET";
    Constant.json = "json";
    Constant.Function = "function";
    Constant.string = "string";
    Constant.object = "object";
    Constant.innerLoderHtml = "<div class='loader-inner' style='margin:0 auto;text-align:center;padding:20px;'><img src='../Content/Images/throbber.gif' alt='Loading' class='dashboard-loader' /></div>";
    Constant.configurableProduct = "ConfigurableProduct";
    Constant.simpleProduct = "SimpleProduct";
    Constant.groupedProduct = "GroupedProduct";
    Constant.bundleProduct = "BundleProduct";
    Constant.addOns = "AddOns";
    Constant.ZnodeCustomerShipping = "ZnodeCustomerShipping";
    Constant.GuestUser = "Guest User";
    Constant.gocoderGoogleAPI = $("#gocoderGoogleAPI").val(); //To be fetched from config file
    Constant.gocoderGoogleAPIKey = $("#gocoderGoogleAPIKey").val(); //To be fetched from config file 
    Constant.inventory = "Inventory";
    Constant.category = "Category";
    Constant.seo = "SEO";
    Constant.defaultAdmin = "admin@znode.com";
    Constant.CATALOG = "Catalog";
    Constant.image = "Image";
    Constant.AmericanExpressCardCode = "AMEX";
    Constant.shippingSettings = "ShippingSettings";
    Constant.productSetting = "ProductSetting";
    Constant.productDetails = "ProductDetails";
    Constant.storelist = "Storelist";
    Constant.creditCardNoHidden = "XXXX-XXXX-XXXX-";
    Constant.creditCardPaymentCode = "credit_card";
    Constant.Cloudflare = "cloudflare";
    Constant.categoryXMLSitemap = "CategoryXMLSitemap";
    Constant.contentPagesXMLSitemap = "ContentPagesXMLSitemap";
    Constant.productXMLSitemap = "ProductXMLSitemap";
    Constant.allXMLSitemap = "AllXMLSitemap";
    Constant.googleProductFeed = "GoogleProductFeed";
    Constant.bingProductFeed = "BingProductFeed";
    Constant.shoppingProductFeed = "ShoppingProductFeed";
    Constant.analyticsChartStartDate = "30daysAgo";
    Constant.analyticsChartEndDate = "today";
    Constant.analyticsTableChartMaxResults = 10;
    Constant.xmlProductFeed = "XmlProductFeed";
    Constant.CyberSource = "cybersource";
})(Constant || (Constant = {}));
var ErrorMsg;
(function (ErrorMsg) {
    ErrorMsg.CallbackFunction = "Callback is not defined. No request made.";
    ErrorMsg.APIEndpoint = "API Endpoint not available: ";
    ErrorMsg.InvalidFunction = "invalid function name : ";
    ErrorMsg.ErrorMessageForCategoryCode = "Alphanumeric values are allowed,Must contain at least one alphabet in CategoryCode.";
})(ErrorMsg || (ErrorMsg = {}));
var Enum;
(function (Enum) {
    var OrderStatusDropdown;
    (function (OrderStatusDropdown) {
        OrderStatusDropdown["PENDING"] = "5";
        OrderStatusDropdown["RECEIVED"] = "11";
        OrderStatusDropdown["SUBMITTED"] = "10";
        OrderStatusDropdown["SHIPPED"] = "20";
        OrderStatusDropdown["RETURNED"] = "30";
        OrderStatusDropdown["CANCELED"] = "40";
        OrderStatusDropdown["PENDINGAPPROVAL"] = "50";
        OrderStatusDropdown["APPROVED"] = "60";
        OrderStatusDropdown["REJECTED"] = "70";
        OrderStatusDropdown["INREVIEW"] = "80";
        OrderStatusDropdown["DRAFT"] = "90";
        OrderStatusDropdown["ORDERED"] = "100";
        OrderStatusDropdown["PARTIALREFUND"] = "110";
        OrderStatusDropdown["SENDING"] = "120";
        OrderStatusDropdown["ORDERRECEIVED"] = "130";
        OrderStatusDropdown["FAILED"] = "140";
        OrderStatusDropdown["INPROGRESS"] = "150";
        OrderStatusDropdown["INPRODUCTION"] = "160";
        OrderStatusDropdown["WAITINGTOSHIP"] = "170";
        OrderStatusDropdown["INVOICED"] = "180";
        OrderStatusDropdown["PENDINGPAYMENT"] = "190";
        OrderStatusDropdown["EXPIRED"] = "200";
    })(OrderStatusDropdown = Enum.OrderStatusDropdown || (Enum.OrderStatusDropdown = {}));
    var ReturnStatusDropdown;
    (function (ReturnStatusDropdown) {
        ReturnStatusDropdown["SUBMITTED"] = "10";
        ReturnStatusDropdown["INREVIEW"] = "30";
        ReturnStatusDropdown["RECEIVED"] = "40";
        ReturnStatusDropdown["APPROVED"] = "50";
        ReturnStatusDropdown["REJECTED"] = "60";
        ReturnStatusDropdown["PARTIALLYAPPROVED"] = "70";
        ReturnStatusDropdown["REFUNDPROCESSED"] = "80";
    })(ReturnStatusDropdown = Enum.ReturnStatusDropdown || (Enum.ReturnStatusDropdown = {}));
    var ProductFeedType;
    (function (ProductFeedType) {
        ProductFeedType[ProductFeedType["XmlSiteMap"] = 0] = "XmlSiteMap";
        ProductFeedType[ProductFeedType["Google"] = 1] = "Google";
        ProductFeedType[ProductFeedType["Bing"] = 2] = "Bing";
        ProductFeedType[ProductFeedType["Xml"] = 3] = "Xml";
    })(ProductFeedType = Enum.ProductFeedType || (Enum.ProductFeedType = {}));
    var ProductFeedSiteMapType;
    (function (ProductFeedSiteMapType) {
        ProductFeedSiteMapType[ProductFeedSiteMapType["Category"] = 0] = "Category";
        ProductFeedSiteMapType[ProductFeedSiteMapType["Content"] = 1] = "Content";
        ProductFeedSiteMapType[ProductFeedSiteMapType["Product"] = 2] = "Product";
        ProductFeedSiteMapType[ProductFeedSiteMapType["ALL"] = 3] = "ALL";
    })(ProductFeedSiteMapType = Enum.ProductFeedSiteMapType || (Enum.ProductFeedSiteMapType = {}));
})(Enum || (Enum = {}));
//# sourceMappingURL=Znode.Model.js.map