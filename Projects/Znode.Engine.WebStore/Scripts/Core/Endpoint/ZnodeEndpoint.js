var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var Endpoint = /** @class */ (function (_super) {
    __extends(Endpoint, _super);
    function Endpoint() {
        return _super.call(this) || this;
    }
    Endpoint.prototype.GetProductDetails = function (productId, isQuickView, publishState, localeId, profileId, accountId, catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductQuickView", Constant.GET, { "id": productId, "isQuickView": isQuickView, "publishState": publishState, "localeId": localeId, "profileId": profileId, "accountId": accountId, "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProductOutOfStockDetails = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductOutOfStockDetails", Constant.GET, { "productId": productId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductListBySKU = function (sku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductListBySKU", Constant.GET, { "sku": sku }, callbackMethod, "json");
    };
    Endpoint.prototype.AddToWishList = function (sku, addOnSKUs, callbackMethod, isRedirectToLogin) {
        if (isRedirectToLogin === void 0) { isRedirectToLogin = false; }
        _super.prototype.ajaxRequest.call(this, "/Product/AddToWishList", Constant.GET, { "productSKU": sku, "addOnProductSKUs": addOnSKUs, "isRedirectToLogin": isRedirectToLogin }, callbackMethod, "json");
    };
    Endpoint.prototype.AddToWishListPLP = function (sku, addOnSKUs, callbackMethod, isRedirectToLogin) {
        if (isRedirectToLogin === void 0) { isRedirectToLogin = false; }
        _super.prototype.ajaxRequest.call(this, "/Product/AddToWishListPLP", Constant.GET, { "productSKU": sku, "addOnProductSKUs": addOnSKUs, "isRedirectToLogin": isRedirectToLogin }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductPrice = function (sku, parentProductSKU, quantity, selectedAddOnIds, parentProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductPrice", Constant.GET, { "productSKU": sku, "parentProductSKU": parentProductSKU, "quantity": quantity, "addOnIds": selectedAddOnIds, "parentProductId": parentProductId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetProduct = function (parameters, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetConfigurableProduct", Constant.Post, { "model": parameters }, callbackMethod, "html");
    };
    Endpoint.prototype.CheckGroupProductInventory = function (mainProductId, sku, quantity, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/CheckGroupProductInventory", Constant.GET, { "mainProductId": mainProductId, "productSKU": sku, "quantity": quantity }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GlobalLevelProductComapre = function (productId, categoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GlobalLevelCompareProduct", Constant.GET, { "productId": productId, "categoryId": categoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductComparison = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/ViewProductComparison", Constant.GET, {}, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveProduct = function (productId, control, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/RemoveProductFormSession", Constant.GET, { "productId": productId, "control": control }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCompareProductList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetCompareProductList", Constant.GET, {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetRecentlyViewProduct = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetRecentViewProducts", Constant.GET, { "productId": productId }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateCartQUantity = function (guid, quantity, productid, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/cart/UpdateCartQuantity", Constant.Post, { "guid": guid, "quantity": quantity, "productId": productid }, callbackMethod, "html");
    };
    Endpoint.prototype.RemoveProductFromWishList = function (wishlistId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/Wishlist", Constant.Post, { "wishid": wishlistId }, callbackMethod, "json");
    };
    Endpoint.prototype.getView = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, Constant.GET, {}, callbackMethod, "html");
    };
    Endpoint.prototype.SignUpForNewsLetter = function (emailId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Home/SignUpForNewsLetter", Constant.Post, { "emailId": emailId }, callbackMethod, "json");
    };
    Endpoint.prototype.SendMail = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/SendComparedProductMail", Constant.GET, {}, callbackMethod, "html");
    };
    Endpoint.prototype.GetSenMailNotification = function (url, senderMailId, recieverMailId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, Constant.Post, { "senderMailId": senderMailId, "recieverMailId": recieverMailId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveCouponCode = function (couponCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/RemoveCoupon", Constant.GET, { "couponCode": couponCode }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveGiftCard = function (discountCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/ApplyDiscount", Constant.Post, { "discountCode": discountCode, "isGiftCard": true }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateQuoteStatus = function (quoteId, status, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/UpdateQuoteStatus", Constant.GET, { "quoteId": quoteId, "status": status }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteTemplate = function (omsTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/DeleteTemplate", Constant.GET, { "omsTemplateId": omsTemplateId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPaymentDetails = function (paymentSettingId, isAsync, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetPaymentDetails", Constant.GET, { "paymentSettingId": paymentSettingId }, callbackMethod, "json", isAsync);
    };
    Endpoint.prototype.GetPaymentDetailsForInvoice = function (paymentSettingId, isAsync, isUsedForOfflinePayment, remainingOrderAmount, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetPaymentDetails", Constant.GET, { "paymentSettingId": paymentSettingId, "isUsedForOfflinePayment": isUsedForOfflinePayment, "remainingOrderAmount": remainingOrderAmount }, callbackMethod, "json", isAsync);
    };
    Endpoint.prototype.GetPaymentDetailsForQuotes = function (paymentSettingId, isAsync, quoteNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetPaymentDetailsForQuotes", Constant.GET, { "paymentSettingId": paymentSettingId, "quoteNumber": quoteNumber }, callbackMethod, "json", isAsync);
    };
    Endpoint.prototype.GetBillingAddressDetail = function (portalId, billingAddressId, shippingAddressId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetBillingAddressDetail", Constant.GET, { "portalId": portalId, "billingAddressId": billingAddressId, "shippingAddressId": shippingAddressId }, callbackMethod, "json", true);
    };
    Endpoint.prototype.ShippingOptions = function (isAsync, isQuoteRequest, isPendingOrderRequest, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/ShippingOptions", Constant.GET, { "isQuote": isQuoteRequest, "isPendingOrderRequest": isPendingOrderRequest }, callbackMethod, "html", isAsync);
    };
    Endpoint.prototype.GetXml = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/View", Constant.GET, { "id": id }, callbackMethod, "html");
    };
    Endpoint.prototype.ProcessPayPalPayment = function (submitPaymentViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/submitorder", Constant.Post, { "submitPaymentViewModel": submitPaymentViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteQuoteLineItem = function (omsQuoteLineItemId, omsQuoteId, quoteLineItemCount, orderStatus, roleName, token, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/DeleteQuoteLineItem", Constant.Post, { "omsQuoteLineItemId": omsQuoteLineItemId, "omsQuoteId": omsQuoteId, "quoteLineItemCount": quoteLineItemCount, "orderStatus": orderStatus, "roleName": roleName, "__RequestVerificationToken": token }, callbackMethod, "json");
    };
    Endpoint.prototype.CreateQuote = function (submitQuoteViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/CreateQuote", Constant.Post, { "submitQuoteViewModel": submitQuoteViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPurchanseOrder = function (paymentType, paymentSettingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetPaymentProvider", Constant.GET, { "paymentType": paymentType, "paymentSettingId": paymentSettingId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetShippingEstimates = function (zipCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/cart/GetShippingEstimates", Constant.GET, { "zipCode": zipCode }, callbackMethod, "json");
    };
    Endpoint.prototype.GetBreadCrumb = function (categoryId, categoryIds, checkFromSession, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetBreadCrumb", Constant.GET, { "categoryId": categoryId, "productAssociatedCategoryIds": categoryIds, "checkFromSession": checkFromSession }, callbackMethod, "json");
    };
    Endpoint.prototype.GetSaveCreditCardCount = function (customerGUID, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetSaveCreditCardCount", Constant.GET, { "customerGUID": customerGUID }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAjaxHeaders = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetAjaxHeaders", Constant.GET, {}, callbackMethod, "json", true);
    };
    Endpoint.prototype.GetPaymentAppHeader = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetPaymentAppHeader", Constant.GET, {}, callbackMethod, "json", true);
    };
    Endpoint.prototype.CallPriceApi = function (products, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductPrice", Constant.Post, { "products": products }, callbackMethod, "json");
    };
    Endpoint.prototype.CallInventoryPriceApi = function (products, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetPriceWithInventory", Constant.Post, { "productSku": products }, callbackMethod, "json");
    };
    Endpoint.prototype.IsAsyncPrice = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/IsAsyncPrice", Constant.Post, {}, callbackMethod, "json");
    };
    Endpoint.prototype.IsTemplateNameExist = function (templateName, omsTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/IsTemplateNameExist", Constant.Post, { "templateName": templateName, "omsTemplateId": omsTemplateId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAutoCompleteItemProperties = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetAutoCompleteItemProperties", Constant.GET, { "productId": productId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetSiteMapCategory = function (pageSize, pageLength, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SiteMap/SiteMapList", Constant.GET, { "pageSize": pageSize, "pageLength": pageLength }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUserCommentList = function (blogNewsId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/GetUserCommentList", Constant.GET, { "blogNewsId": blogNewsId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPublishedProductList = function (pageIndex, pageSize, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SiteMap/GetPublishProduct", Constant.GET, { "pageIndex": pageIndex, "pageSize": pageSize }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAmazonPayAddress = function (shippingOptionId, shippingAddressId, shippingCode, paymentSettingId, paymentApplicationSettingId, amazonOrderReferenceId, total, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetAmazonAddress", Constant.GET, { "shippingOptionId": shippingOptionId, "shippingAddressId": shippingAddressId, "shippingCode": shippingCode, "paymentSettingId": paymentSettingId, "paymentApplicationSettingId": paymentApplicationSettingId, "amazonOrderReferenceId": amazonOrderReferenceId, "total": total, callbackMethod: callbackMethod }, callbackMethod, "json");
    };
    Endpoint.prototype.AmazonShippingOptions = function (OrderReferenceId, paymentSettingId, total, accesstoken, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/AmazonShippingOptions", Constant.GET, { "amazonOrderReferenceId": OrderReferenceId, "paymentSettingId": paymentSettingId, "total": total, "accesstoken": accesstoken }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetCartCount = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Home/GetCartCount", Constant.GET, "", callbackMethod, "html", true);
    };
    Endpoint.prototype.GetCartCountByProductId = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/cart/GetCartCount", Constant.GET, { "productId": productId }, callbackMethod, "json", true);
    };
    Endpoint.prototype.IsAttributeValueUnique = function (attributeCodeValues, id, isCategory, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/ProductAttribute/IsAttributeValueUnique", Constant.GET, { "attributeCodeValues": attributeCodeValues, "id": id, "isCategory": isCategory }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ValidationView = function (url, attributeTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, Constant.GET, { "AttributeTypeId": attributeTypeId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsGlobalAttributeCodeExist = function (attributeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/IsAttributeCodeExist", Constant.GET, { "attributeCode": attributeCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsGlobalAttributeDefaultValueCodeExist = function (attributeId, attributeDefaultValueCode, defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/IsAttributeDefaultValueCodeExist", Constant.GET, { "attributeId": attributeId, "attributeDefaultValueCode": attributeDefaultValueCode, "defaultValueId": defaultvalueId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsGlobalAttributeValueUnique = function (attributeCodeValues, id, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/FormAttributeValueUnique", Constant.GET, { "AttributeCodeValues": attributeCodeValues, "Id": id, "EntityType": entityType }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetRecommendedAddress = function (_addressModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetRecommendedAddress", Constant.Post, { "addressViewModel": _addressModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ImportPost = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/ImportShippingAddress", Constant.Post, {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetBrandData = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Brand/GetBrandListPopUp", Constant.GET, {}, callbackMethod, "html");
    };
    Endpoint.prototype.GetAddressDetails = function (addressId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetAddressById", Constant.GET, { "addressId": addressId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAndSelectAddressDetails = function (addressId, addressType, callbackMethod, isCalculateCart) {
        if (isCalculateCart === void 0) { isCalculateCart = true; }
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetAddressById", Constant.GET, { "addressId": addressId, "addressType": addressType, "isCalculateCart": isCalculateCart }, callbackMethod, "json", false);
    };
    Endpoint.prototype.RefreshAddressOptions = function (addressType, callbackMethod, isCalculateCart) {
        if (isCalculateCart === void 0) { isCalculateCart = true; }
        _super.prototype.ajaxRequest.call(this, "/Checkout/RefreshAddressOptions", Constant.GET, { "addressType": addressType, "isCalculateCart": isCalculateCart }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetApproverList = function (accountId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetApproverList", Constant.GET, { "accountId": accountId, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateSearchAddress = function (addressViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/UpdateSearchAddress", Constant.Post, { "addressViewModel": addressViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.IsUserNameExist = function (userName, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/IsUserNameExists", Constant.GET, {
            "userName": userName, "portalId": $("#PortalId").val(),
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetPermissionList = function (accountId, accountPermissionAccessId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetPermissionList", Constant.GET, { accountId: accountId, accountPermissionId: accountPermissionAccessId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteAccountCustomers = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/CustomerDelete", Constant.GET, { "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.CustomerEnableDisableAccount = function (accountid, id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/CustomerEnableDisableAccount", Constant.GET, { "accountId": accountid, "userId": id, "isLock": isEnable, "isRedirect": false }, callbackMethod, "json");
    };
    Endpoint.prototype.SingleResetPassword = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/SingleResetPassword", Constant.GET, { "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.CustomerAccountResetPassword = function (accountid, id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/BulkResetPassword", Constant.GET, { "accountid": accountid, "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.SelectBrand = function (brandId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomBrand/SelectBrand", Constant.GET, { "brandId": brandId }, callbackMethod, "json");
    };
    Endpoint.prototype.SearchBrand = function (searchKeyword, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomBrand/SearchBrandData", Constant.GET, { "searchKeyword": searchKeyword }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteImportLogs = function (importProcessLogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/DeleteLogs", Constant.GET, { "importProcessLogId": importProcessLogId }, callbackMethod, "json");
    };
    Endpoint.prototype.IsGlobalValueUnique = function (attributeCodeValues, id, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomUser/IsGlobalAttributeValueUnique", Constant.Post, { "AttributeCodeValues": attributeCodeValues, "Id": id, "EntityType": entityType }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetStates = function (countryCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetStates", Constant.GET, { "countryCode": countryCode }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCart = function (shippingId, zipCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/cart/GetCalculatedShipping", Constant.GET, { "shippingId": shippingId, "zipCode": zipCode }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetshippingBillingAddress = function (portalId, shippingId, billingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetshippingBillingAddress", "get", { "portalId": portalId, "shippingId": shippingId, "billingId": billingId }, callbackMethod, "json", true);
    };
    Endpoint.prototype.GetUserApproverList = function (omsQuoteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetUserApproverList", Constant.GET, { "omsQuoteId": omsQuoteId }, callbackMethod, "html");
    };
    Endpoint.prototype.SetPrimaryAddress = function (selectedAddressId, addressType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/SetPrimaryBillingShippingAddress", Constant.GET, { "addressId": selectedAddressId, "addressType": addressType }, callbackMethod, "json");
    };
    Endpoint.prototype.GetValidateUserBudget = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/ValidateUserBudget", Constant.GET, {}, callbackMethod, "json", false);
    };
    Endpoint.prototype.SetAddressRecipientNameInCart = function (firstName, lastName, addressType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/SetAddressRecipientNameInCart", Constant.GET, { "firstName": firstName, "lastName": lastName, "addressType": addressType }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GenerateOrderNumber = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GenerateOrderNumber", Constant.GET, { "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.LogAuthNetIframeResponse = function (portalId, response, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/LogAuthNetIframeResponse", Constant.GET, { "portalId": portalId, "response": response }, callbackMethod, "json", false);
    };
    //Region B2B Theme
    Endpoint.prototype.Login = function (returnUrl, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/Login", "get", { "returnUrl": returnUrl }, callbackMethod, "html", false);
    };
    Endpoint.prototype.Logoff = function (callback) {
        _super.prototype.ajaxRequest.call(this, "/User/Logout", "get", {}, callback, "html", false);
    };
    Endpoint.prototype.GetAccountMenus = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetAccountMenus", "get", {}, callbackMethod, "html", false);
    };
    Endpoint.prototype.ForgotPassword = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/ForgotPassword", "get", {}, callbackMethod, "html", false);
    };
    Endpoint.prototype.RemoveFromWishList = function (wishListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/Wishlist", "get", { "wishid": wishListId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCategoryBreadCrumb = function (categoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Category/GetBreadCrumb/" + categoryId, Constant.GET, {}, callbackMethod, "json");
    };
    Endpoint.prototype.PaymentOptions = function (isAsync, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/PaymentOptions", Constant.GET, { "isQuote": isQuote }, callbackMethod, "html", isAsync);
    };
    Endpoint.prototype.GetLoginUserAddress = function (userid, quoteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/AccountAddress", Constant.GET, { "userid": userid, "quoteId": quoteId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetcartReview = function (shippingOptionId, shippingAddressId, shippingCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetCartDetails", Constant.GET, { "shippingOptionId": shippingOptionId, "shippingAddressId": shippingAddressId, "shippingCode": shippingCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ChangeUserProfile = function (profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/ChangeUserProfile", Constant.GET, { profileId: profileId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetBarcodeScanner = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Home/GetBarcodeScanner", Constant.GET, "", callbackMethod, "html");
    };
    Endpoint.prototype.GetProductDetail = function (searchTerm, enableSpecificSearch, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductDetail", Constant.GET, { "searchTerm": searchTerm, "enableSpecificSearch": enableSpecificSearch }, callbackMethod, "html");
    };
    Endpoint.prototype.SaveSearchReportData = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchReport/SaveSearchReportData", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.GetSearchCMSPages = function (searchTerm, pageNumber, pageSize, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/GetSearchContentPage", "post", { "searchTerm": searchTerm, "pageNumber": pageNumber, "pageSize": pageSize }, callbackMethod, "html");
    };
    Endpoint.prototype.GetOrderDetailsForReturn = function (orderNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/GetOrderDetailsForReturn", Constant.GET, { "orderNumber": orderNumber }, callbackMethod, "html", false);
    };
    Endpoint.prototype.DeleteOrderReturn = function (returnNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/DeleteOrderReturn", Constant.Post, { "returnNumber": returnNumber }, callbackMethod, "json", false);
    };
    Endpoint.prototype.SubmitOrderReturn = function (url, orderReturnModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, Constant.Post, { "returnViewModel": orderReturnModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.CalculateOrderReturn = function (url, calculateOrderReturnModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, Constant.Post, { "calculateOrderReturnModel": calculateOrderReturnModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.SaveOrderReturn = function (orderReturnModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/SaveOrderReturn", Constant.Post, { "returnViewModel": orderReturnModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.PrintReturnReceipt = function (url, returnNumber, isReturnDetailsReceipt, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, Constant.GET, { "returnNumber": returnNumber, "isReturnDetailsReceipt": isReturnDetailsReceipt }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetAllLocationInventory = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetProductInventory", Constant.GET, { "productId": productId }, callbackMethod, "json");
    };
    Endpoint.prototype.ShowProductAllLocationInventory = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/ShowProductAllLocationInventory", Constant.GET, { "productId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.DisplayAddToCartNotification = function (product, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/ShowAddToCartNotification", "post", { "product": JSON.parse(product) }, callbackMethod, "html");
    };
    Endpoint.prototype.IsTemplateItemsModified = function (templateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/IsTemplateItemsModified", Constant.GET, { "omsTemplateId": templateId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveVoucher = function (code, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/RemoveVoucher", Constant.GET, { "voucherNumber": code }, callbackMethod, "json");
    };
    Endpoint.prototype.GetHighlightInfoByCode = function (highlightCode, publishProductId, productSku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetHighlightInfoByCode", Constant.GET, { "highLightCode": highlightCode, "productId": publishProductId, "sku": productSku }, callbackMethod, "json");
    };
    Endpoint.prototype.AddProductsToQuickOrder = function (multipleItems, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/AddProductsToQuickOrder", Constant.Post, { "multipleItems": multipleItems }, callbackMethod, "json", true);
    };
    Endpoint.prototype.AmazonPaymentOptions = function (isQuotes, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/AmazonPaymentOptions", Constant.GET, { "isQuotes": isQuotes }, callbackMethod, "json");
    };
    Endpoint.prototype.ValidateGuestUserReturn = function (orderNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/ValidateGuestUserReturn", Constant.GET, { "orderNumber": orderNumber }, callbackMethod, "json");
    };
    Endpoint.prototype.CheckOrderEligibilityForReturn = function (orderNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/CheckOrderEligibilityForReturn", Constant.GET, { "orderNumber": orderNumber }, callbackMethod, "json");
    };
    Endpoint.prototype.GetImage = function (_productImageDetails, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/GetConfigurableProductVariantImage", Constant.Post, { "productDetails": _productImageDetails }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetOrderAndPaymentDetails = function (omsOrderId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetOrderAndPaymentDetails", Constant.GET, { "omsOrderId": omsOrderId, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.SubmitStockRequest = function (stockRequestModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/SubmitStockRequest", Constant.Post, { "stockNotificationViewModel": stockRequestModel }, callbackMethod, "json");
    };
    Endpoint.prototype.CheckConfigurableChildProductQuantity = function (parentProductId, childSKUs, childQuantities, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/CheckConfigurableChildProductInventory", Constant.GET, { "parentProductId": parentProductId, "childSKUs": childSKUs, "childQuantities": childQuantities }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAuthorizeNetToken = function (paymentTokenModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/checkout/GetAuthorizeNetToken", Constant.Post, { "paymentTokenModel": paymentTokenModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPaymentGatewayToken = function (paymentTokenModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Checkout/GetPaymentGatewayToken", Constant.Post, { "paymentTokenModel": paymentTokenModel }, callbackMethod, "json");
    };
    Endpoint.prototype.SavedNewcart = function (templatename, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/savedcart/createsavedcart", Constant.Post, { "templatename": templatename }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetSavedCartList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/savedcart/GetTemplate", Constant.GET, {}, callbackMethod, "json", false);
    };
    Endpoint.prototype.EditSaveCart = function (omsTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/savedcart/EditSaveCart", Constant.Post, { "omsTemplateId": omsTemplateId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.EditSavedCartName = function (templateName, templateid, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/savedcart/EditSaveCartName", Constant.GET, { "templateName": templateName, "templateid": templateid }, callbackMethod, "json", false);
    };
    //End Region
    //Nivi Code start  
    Endpoint.prototype.CustomAddtoCart = function (productId, quantity, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Product/CustomAddToCart", Constant.Post, { "productId": productId, "quantity": quantity }, callbackMethod, "json", true);
    };
    return Endpoint;
}(ZnodeBase));
//# sourceMappingURL=ZnodeEndpoint.js.map