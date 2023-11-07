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
    Endpoint.prototype.gettreeviewdataset = function (http) {
        return http.get("/MediaManager/MediaManager/GetTreeData").success(function (data) {
            data;
        });
    };
    Endpoint.prototype.getdropdowndataset = function (http) {
        return http.get("/MediaManager/MediaManager/GetDropDownList").success(function (data) {
            data;
        });
    };
    Endpoint.prototype.SaveRights = function (data, roleId) {
        _super.prototype.ajaxRequest.call(this, "/RoleAndAccessRight/SavePermissions?data=" + data.toString() + "&roleId=" + roleId + "", "Post", {}, function (res) {
            window.location.href = "/RoleAndAccessRight/RoleList";
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.IsSuccess ? "success" : "error", isFadeOut, fadeOutTime);
        }, "HTML");
    };
    Endpoint.prototype.ManageRolePermission = function (collection, _roleId) {
        _super.prototype.ajaxRequest.call(this, "/RoleAndAccessRight/ManagePermission", "POST", { data: JSON.stringify(collection), roleId: _roleId }, function (data) {
            if (data) {
                window.location.href = "/RoleAndAccessRight/RoleList";
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.statusMessage, data.success ? "success" : "error", isFadeOut, fadeOutTime);
            }
        }, "json");
    };
    Endpoint.prototype.GetXml = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/View", "get", { "id": id }, callbackMethod, "html");
    };
    Endpoint.prototype.GetColumnsList = function (entityType, entityName, columnListJson, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/GetColumnList", "get", { "entityType": entityType, "entityName": entityName, "columnListJson": columnListJson }, callbackMethod, "html");
    };
    Endpoint.prototype.GetEntityName = function (term, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/AutoCompleteEntityName", "POST", { "term": term, "entityType": entityType }, callbackMethod, "json");
    };
    Endpoint.prototype.SaveXmlData = function (url, _griddata, txtviewOptions, entityType, entityName, txtfrontPageName, txtfrontObjectName, id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "POST", { "columnCollection": _griddata, "viewOptions": txtviewOptions, "entityType": entityType, "entityName": entityName, "frontPageName": txtfrontPageName, "frontObjectName": txtfrontObjectName, "id": id }, callbackMethod, "json");
    };
    Endpoint.prototype.deleteRecordById = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "post", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetAttributeInputValidationView = function (attributeTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/BindInputValidationList", "get", { "attributeTypeId": attributeTypeId }, callbackMethod, "html");
    };
    Endpoint.prototype.ValidationView = function (url, attributeTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "AttributeTypeId": attributeTypeId }, callbackMethod, "html");
    };
    Endpoint.prototype.SaveDefaultValues = function (url, data, attributeId, defaultvaluecode, defaultvalueId, displayOrder, isDefault, isSwatch, swatch, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {
            "model": JSON.stringify(data), "attributeId": attributeId, "defaultvalueId": defaultvalueId, "defaultvaluecode": defaultvaluecode, "displayOrder": displayOrder, "isdefault": isDefault, "isswatch": isSwatch, "swatchtext": swatch
        }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteDefaultValues = function (url, defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "defaultvalueId": defaultvalueId }, callbackMethod, "json");
    };
    Endpoint.prototype.getView = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.GetRecord = function (model, SuccessCallBack) {
        _super.prototype.ajaxRequest.call(this, "/" + model.Controller + "/" + model.Action, "get", { id: model.ItemIds.toString(), flag: model.flag }, SuccessCallBack, "html");
    };
    Endpoint.prototype.GetMediaSetting = function (partialViewName, serverId, SuccessCallBack) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaConfiguration/GetMediaSetting", "get", { partialViewName: partialViewName, serverId: serverId }, SuccessCallBack, "html");
    };
    Endpoint.prototype.GenerateImageOnEdit = function (mediaPath, fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/GenerateImageOnEdit", "get", { "mediaPath": mediaPath, "fileName": fileName }, callbackMethod, "json");
    };
    Endpoint.prototype.GenerateImages = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaConfiguration/GenerateImages", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.TestAjaxCall = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedAttributes = function (url, attributeId, familyId, SuccessCallBack) {
        _super.prototype.ajaxRequest.call(this, url, "GET", { "attributeGroupId": attributeId, "attributeFamilyId": familyId }, SuccessCallBack, "html");
    };
    Endpoint.prototype.SaveAttributeDefaultValue = function (attributeId, localeArray, defaultAttributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/SaveDefaultAttributeValue", "post", { "attributeId": attributeId, "defaultAttributeId": defaultAttributeId, "localeValue": localeArray }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteAttributeDefaultValue = function (defaultAttributeId, attributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/DeleteDefaultAttributeValue", "get", { "defaultAttributevalueId": defaultAttributeId, "attributeId": attributeId }, callbackMethod, "html");
    };
    Endpoint.prototype.MediaAddFolder = function (parentId, folderName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/AddFolder", "get", { "parentId": parentId, "folderName": folderName }, callbackMethod, "json");
    };
    Endpoint.prototype.MediaRenameFolder = function (folderId, folderName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/RenameFolder", "get", { "folderId": folderId, "folderName": folderName }, callbackMethod, "json");
    };
    Endpoint.prototype.MediaMoveFolder = function (addtoFolderId, folderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/MoveFolder", "get", { "addtoFolderId": addtoFolderId, "folderId": folderId }, callbackMethod, "json");
    };
    Endpoint.prototype.MoveMedia = function (folderId, mediaIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/MoveMediaToFolder", "get", { "folderId": folderId, "mediaIds": mediaIds }, callbackMethod, "json");
    };
    Endpoint.prototype.MediaUserList = function (folderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/GetUserAccountList", "get", { "folderId": folderId }, callbackMethod, "html");
    };
    Endpoint.prototype.MediaShareFolder = function (folderId, accountIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/ShareFolder", "post", { "folderId": folderId, "accountIds": accountIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPromotionTypeDetails = function (className, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/GetPromotionTypeByClassName", "get", { "className": className }, callbackMethod, "json");
    };
    Endpoint.prototype.GetSupplierTypeDetails = function (className, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/GetSupplierTypeByClassName", "get", { "className": className }, callbackMethod, "json");
    };
    Endpoint.prototype.GetShippingTypeDetails = function (className, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/GetShippingTypeByClassName", "get", { "className": className }, callbackMethod, "json");
    };
    Endpoint.prototype.GetTaxRuleTypeDetails = function (className, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/GetTaxRuleTypeByClassName", "get", { "className": className }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPaymentTypeForm = function (paymentName, paymentSettingModel, paymentCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Payment/GetPaymentTypeForm", "post", { "paymentName": paymentName, "paymentSetting": JSON.stringify(paymentSettingModel), "paymentCode": paymentCode }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPaymentGetwayForm = function (gatewayCode, paymentSettingModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Payment/GetPaymentGetwayForm", "post", { "gatewayCode": gatewayCode, "paymentSetting": JSON.stringify(paymentSettingModel) }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPaymentSettingCredentials = function (paymentCode, isTestMode, gatewayCode, paymentTypeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Payment/GetPaymentSettingCredentials", "get", { "paymentCode": paymentCode, "isTestMode": isTestMode, "gatewayCode": gatewayCode, "paymentTypeCode": paymentTypeCode }, callbackMethod, "html");
    };
    Endpoint.prototype.MediaDelete = function (mediaIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/DeleteMedia", "get", { "mediaId": mediaIds }, callbackMethod, "json");
    };
    Endpoint.prototype.FolderDelete = function (folderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/DeleteFolder", "get", { "folderId": folderId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteTaxRuleTypes = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/DeleteTaxRuleType", "get", { "id": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteShippingTypes = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/DeleteShippingType", "get", { "id": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteSupplierTypes = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/DeleteSupplierType", "get", { "id": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeletePromotionTypes = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/DeletePromotionType", "get", { "id": id }, callbackMethod, "json");
    };
    Endpoint.prototype.EnableTaxRuleTypes = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/BulkEnableDisableTaxRuleTypes", "get", { "id": id, "isEnable": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.EnableSupplierTypes = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/BulkEnableDisableSupplierTypes", "get", { "id": id, "isEnable": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.EnableShippingTypes = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/BulkEnableDisableShippingTypes", "get", { "id": id, "isEnable": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.EnablePromotionTypes = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/BulkEnableDisablePromotionTypes", "get", { "id": id, "isEnable": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteTaxClasses = function (taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/Delete", "get", { "taxClassId": taxClassId }, callbackMethod, "html");
    };
    Endpoint.prototype.SetGlobalConfigSetting = function (Url, model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, Url, "post", { model: model }, callbackMethod, "json");
    };
    Endpoint.prototype.SetSearchProfileSetting = function (Url, portalId, id, publishCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, Url, "post", { "portalId": portalId, "searchProfileId": id, "publishCatalogId": publishCatalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.SetGlobalConfigSettingListType = function (Url, listType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, Url, "get", { listType: listType }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteUsers = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/DeleteUser", "get", { "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteCustomer = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/CustomerDelete", "get", { "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.EnableDisableUserAccount = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/EnableDisableAccount", "get", { "userId": id, "isLock": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.EnableDisableSingleUserAccount = function (id, isEnable, isAdminUser, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/EnableDisableSingleAccount", "get", { "userId": id, "isLock": isEnable, "isAdminUser": isAdminUser }, callbackMethod, "json");
    };
    Endpoint.prototype.EnableDisableCustomerAccount = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/CustomerEnableDisableAccount", "get", { "userId": id, "isLock": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteStore = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/DeleteStore", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteStoreByStoreCode = function (storeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/DeleteStoreByStoreCode", "get", { "storeCode": storeCode }, callbackMethod, "json");
    };
    Endpoint.prototype.UserResetPassword = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/BulkResetPassword", "get", { "userId": id }, callbackMethod, "html");
    };
    Endpoint.prototype.CustomerResetPassword = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/BulkResetPassword", "get", { "userId": id }, callbackMethod, "html");
    };
    Endpoint.prototype.getServiceListByShippingTypeId = function (serviceShippingTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/BindServiceList", "get", { "ServiceShippingTypeId": serviceShippingTypeId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteUrl = function (urlIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/DeleteUrl", "get", { "domainId": urlIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAdminAPIUrl = function (urlIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/UrlManagement/DeleteUrl", "get", { "domainId": urlIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeletePortalProfile = function (portalProfileIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/DeletePortalProfile", "get", { "portalProfileId": portalProfileIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetMedia = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/List", "post", { "popupViewModel": model }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCurrencyInfo = function (currencyId, oldCurrencyId, cultureId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetCurrencyInformation", "get", {
            "currencyId": currencyId, "oldCurrencyId": oldCurrencyId, "cultureId": cultureId
        }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCultureInfo = function (currencyId, cultureId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetCultureCodeList", "get", { "currencyId": currencyId, "cultureId": cultureId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCSSListForStore = function (cmsThemeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetCSSList", "get", { "cmsThemeId": cmsThemeId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetParentAccountList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetParentAccountList", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCountriesByPortalId = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetCountryBasedOnPortalId", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCountriesByPortalIdWithountAccountAccess = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/GetCountryBasedOnPortalId", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAccountDepartmentList = function (accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetAccountDepartments", "get", { "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPermissionList = function (accountId, accountPermissionAccessId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetPermissionList", "get", { accountId: accountId, accountPermissionId: accountPermissionAccessId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetPermissionListWithoutAccountId = function (accountPermissionAccessId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetPermissionList", "get", { accountPermissionId: accountPermissionAccessId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetApproverList = function (accountId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetApproverList", "get", { "accountId": accountId, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetRoleList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/GetRoleList", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.SalesDetailsBasedOnSelectedPortal = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/GetDashboardSalesDetails", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.SalesDetailsBasedOnSelectedPortalAndAccount = function (portalId, accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/GetDashboardDetails", "get", { "portalId": portalId, "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeletePIMFamily = function (id, contollerName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/" + contollerName + "/Delete", "get", { "pimattributeFamilyId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeletePIMAttributeGroup = function (id, contollerName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/" + contollerName + "/Delete", "get", { "pimAttributeGroupId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMediaFamily = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/AttributeFamily/Delete", "get", { "mediaAttributeFamilyId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeletePIMAttribute = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/ProductAttribute/Delete", "get", { "pimAttributeId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMediaAttribute = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/Delete", "get", { "mediaAttributeId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateAddons = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AssociateAddonGroup", "post", { "model": model }, callbackMethod, "html");
    };
    Endpoint.prototype.AssignLinkProducts = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AssignLinkProduct", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnassociatedProducts = function (parentProductId, listType, associatedProductIds, addonGroupId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetUnassociatedProducts", "get", { "parentProductId": parentProductId, "listType": listType, "addonProductId": addonGroupId, "associatedProductIds": associatedProductIds }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateProducts = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AssociateProducts", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMediaAttributeGroup = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/AttributeGroup/Delete", "get", { "mediaAttributeGroupId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedProducts = function (productId, attributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetAssociatedProducts", "get", { "parentProductId": productId, "attributeId": attributeId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedBundleProducts = function (productId, attributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetAssociatedBundleProducts", "get", { "parentProductId": productId, "attributeId": attributeId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedConfigureProducts = function (productId, attributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetAssociatedConfigureProducts", "get", { "parentProductId": productId, "associatedAttributeIds": attributeId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAttributeFamilyDetails = function (familyId, productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetAttributes", "get", { "familyId": familyId, "productId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCustomField = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AddCustomField", "get", { "productId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditCustomField = function (productId, customFieldId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/EditCustomField", "get", { "productId": productId, "customFieldId": customFieldId }, callbackMethod, "html");
    };
    Endpoint.prototype.SaveDefaultValuesMedia = function (data, attributeId, defaultvaluecode, defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/SaveDefaultValues", "get", { "model": JSON.stringify(data), "attributeId": attributeId, "defaultvaluecode": defaultvaluecode, "defaultvalueId": defaultvalueId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteDefaultValuesMedia = function (defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/DeleteDefaultValues", "get", { "defaultvalueId": defaultvalueId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCustomFieldList = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/CustomFields", "get", { "productId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDownloadableProductKeyList = function (productId, sku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetDownloadableProductKeys", "get", { "productId": productId, "sku": sku }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateCategories = function (catalogAssociation, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/AssociateCatalogCategoryProduct", "post", { "catalogAssociation": catalogAssociation }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCategoryFamilyDetails = function (familyId, CategoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/GetAttributes", "get", { "familyId": familyId, "categoryId": CategoryId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteCatalogs = function (pimCatalogId, isDeletePublishCatalog, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/Delete", "get", { "pimCatalogId": pimCatalogId, "isDeletePublishCatalog": isDeletePublishCatalog }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteCategories = function (pimCategoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/Delete", "get", { "pimCategoryId": pimCategoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetRegularExpressionValueByRuleName = function (attributeTypeId, ruleName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/ValidationRuleRegularExpression", "post", { attributeTypeId: attributeTypeId, ruleName: ruleName }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishCatagory = function (pimCategoryId, revisionType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/PublishCategory", "get", { "pimCategoryId": pimCategoryId, "revisionType": revisionType }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteCustomFields = function (customFieldId, productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/DeleteCustomField", "get", { "customFieldId": customFieldId, "productId": productId }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociateCategories = function (catalogAssociation, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/UnAssociateCatalogCategoryProduct", "post", { "catalogAssociation": catalogAssociation }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnAssociateList = function (url, pimCatalogId, catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "pimCatalogId": pimCatalogId, "catalogName": catalogName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCategoryTreePreview = function (pimCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetCategoryTreePreview", "get", { "pimCatalogId": pimCatalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAutoCompleteCategorySearch = function (pimCatalogId, categoryName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetAutoCompleteCategoryList", "get", { "pimCatalogId": pimCatalogId, "categoryName": categoryName }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAutoCompleteProductSearch = function (productName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetAutoCompleteProductList", "get", { "productName": productName }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishCatalogCategoryProducts = function (pimCatalogId, pimCategoryHierarchyId, revisionType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/PublishCatalogCategoryProducts", "get", { "pimCatalogId": pimCatalogId, "pimCategoryHierarchyId": pimCategoryHierarchyId, 'revisionType': revisionType }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedAddons = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AssociatedAddonList", "get", { "parentProductId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssignedLinkProducts = function (productId, linkAttributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AssignedLinkProducts", "get", { "parentProductId": productId, "attributeId": linkAttributeId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPersonalizedAttribute = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetAssignedPersonalizedAttributes", "get", { "productId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeletePrice = function (priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/Delete", "get", { "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleDepartments = function (departmentId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/DeleteAccountDepartment", "get", { "departmentId": departmentId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleNotes = function (noteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/DeleteAccountNote", "get", { "noteId": noteId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleCustomerNotes = function (noteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/DeleteCustomerNote", "get", { "noteId": noteId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleCustomerAddress = function (userAddressId, accountAddressId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/DeleteAddress", "get", { "userAddressId": userAddressId, "accountAddressId": accountAddressId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleAccount = function (accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/Delete", "get", { "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAddress = function (accountAddressId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/DeleteAddress", "get", { "accountAddressId": accountAddressId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleSKUPrice = function (priceId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/DeleteSKUPrice", "get", { "priceId": priceId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleTierPrice = function (priceTierId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/DeleteTierPrice", "get", { "priceTierId": priceTierId }, callbackMethod, "json");
    };
    Endpoint.prototype.AddTierPrice = function (price, minQuantity, maxQuantity, activationDate, expirationDate, sku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/AddTierPrice", "post", { price: price, minQuantity: minQuantity, maxQuantity: maxQuantity, activationDate: activationDate, expirationDate: expirationDate, sku: sku }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCategoryAssociatedProductTreeStructure = function (catalogId, categoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetCategoryAssociatedProducts", "get", { "catalogId": catalogId, "categoryId": categoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteInventory = function (inventoryListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/Delete", "get", { "InventoryListId": inventoryListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleSKUInventory = function (inventoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/DeleteSKUInventory", "get", { "InventoryId": inventoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedProfilesForAccounts = function (accountProfileIds, accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/UnAssociateProfileToAccount", "get", { "accountProfileId": accountProfileIds, "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleAssociatedSkus = function (inventoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Warehouse/DeleteSKUInventory", "get", { "InventoryId": inventoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.EditTierPrice = function (priceTierId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/EditTierPrice", "get", { "priceTierId": priceTierId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteTierPrice = function (priceTierId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/DeleteTierPrice", "get", { "priceTierId": priceTierId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnAssociatedStoreListForCMS = function (PriceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/GetUnAssociatedStoreList", "get", { "cmsThemeId": PriceListId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateStoreList = function (priceListId, storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/AssociateStore", "post", { "priceListId": priceListId, "storeIds": storeIds }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateStoreListForCMS = function (priceListId, storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/AssociateStore", "post", { "cmsThemeId": priceListId, "storeIds": storeIds }, callbackMethod, "json");
    };
    Endpoint.prototype.SaveWidgetsToTheme = function (cmsThemeId, widgetIds, cmsAreaId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/SaveThemeWidgets", "post", { "cmsThemeId": cmsThemeId, "widgetIds": widgetIds, "cmsAreaId": cmsAreaId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateCustomerList = function (priceListId, customerIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/AssociateCustomer", "post", { "priceListId": priceListId, "customerIds": customerIds }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociatePriceListToStore = function (portalId, priceListIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociatePriceListToStore", "post", { "portalId": portalId, "priceListIds": priceListIds }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociatePriceListToProfile = function (profileId, priceListIds, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociatePriceListToProfile", "post", { "profileId": profileId, "priceListIds": priceListIds, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleCustomerPrice = function (priceListUserId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/DeleteAssociatedCustomer", "get", { "priceListUserId": priceListUserId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedStores = function (priceListPortalId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/RemoveAssociatedStores", "get", { "priceListPortalId": priceListPortalId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedStoresForCMS = function (priceListPortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/RemoveAssociatedStores", "get", { "priceListPortalId": priceListPortalId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateProfileList = function (priceListId, profileIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/AssociateProfile", "post", { "priceListId": priceListId, "profileIds": profileIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedProfiles = function (priceListProfileId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/RemoveAssociatedProfiles", "get", { "priceListProfileId": priceListProfileId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteWarehouse = function (warehouseId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Warehouse/Delete", "get", { "warehouseId": warehouseId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnAssociatedPriceListForStore = function (PortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetUnAssociatedPriceListForStore", "get", { "PortalId": PortalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnAssociatedSortListForStore = function (PortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetUnassociatedSortList", "get", { "PortalId": PortalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedSortList = function (PortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetUnassociatedSortList", "get", { "PortalId": PortalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedPageList = function (PortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetUnassociatedPageList", "get", { "PortalId": PortalId }, callbackMethod, "html");
    };
    Endpoint.prototype.RemoveAssociatedPriceListFromStore = function (priceListPortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/RemoveAssociatedPriceListToStore", "get", { "priceListPortalId": priceListPortalId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveAssociatedPriceListFromProfile = function (priceListProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/RemoveAssociatedPriceListToProfile", "get", { "priceListProfileId": priceListProfileId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnAssociatedPriceListForProfile = function (profileId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetUnAssociatedPriceListForProfile", "get", { "profileId": profileId, "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedPriceListForProfile = function (PortalId, ProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedPriceListForProfile", "get", { "PortalId": PortalId, "ProfileId": ProfileId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCMSAreaWidgets = function (cmsThemeId, cmsAreaId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/GetCMSAreaWidgets", "get", { "cmsThemeId": cmsThemeId, "cmsAreaId": cmsAreaId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCMSAreas = function (cmsThemeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/GetCMSAreas", "get", { "cmsThemeId": cmsThemeId }, callbackMethod, "html");
    };
    Endpoint.prototype.AddonDelete = function (addonIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UnassociateAddon", "get", { "pimAddonDetailId": addonIds }, callbackMethod, "json");
    };
    Endpoint.prototype.LinkProductDelete = function (linkProductDetailIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UnAssignLinkProducts", "get", { "pimLinkProductDetailId": linkProductDetailIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnAssociatedCategoryProducts = function (categoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/GetUnAssociatedCategoryProducts", "get", { "categoryId": categoryId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateCategoryProducts = function (categoryId, productIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/AssociatedCategoryProducts", "get", { "categoryId": categoryId, "productIds": productIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociateCategoriesToProduct = function (productId, categoryIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/AssociateCategoriesToProduct", "get", { "productId": productId, "categoryIds": categoryIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleAssociatedProducts = function (pimCategoryProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/DeleteAssociatedProducts", "get", { "pimCategoryProductId": pimCategoryProductId }, callbackMethod, "json");
    };
    Endpoint.prototype.EditCategoryProduct = function (categoryProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/EditCategoryProduct", "get", { "categoryProductId": categoryProductId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedCategoryProducts = function (categoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/GetAssociatedCategoryProducts", "get", { "pimCategoryId": categoryId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetWarehouses = function (portalId, warehouseId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedWarehouseList", "get", { "portalId": portalId, "warehouseId": warehouseId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateWarehouseToStore = function (portalId, warehouseId, alternateWarehouseIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociateWarehouseToStore", "post", { "portalId": portalId, "warehouseId": warehouseId, "alternateWarehouseIds": alternateWarehouseIds }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteAssociatedProducts = function (associatedProductIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UnassociateProducts", "get", { "pimProductTypeAssociationId": associatedProductIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedCategories = function (pimCategoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/DeleteAssociatedCategories", "get", { "pimCategoryProductId": pimCategoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.PreViewPriceImportList = function (file, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/PreviewImportPrice", "get", { "file": file }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteProducts = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/Delete", "get", { "PimProductId": productId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetSimilarCombination = function (productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetSimilarCombination", "get", { "productId": productId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedPriceListForStore = function (PortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedPriceListForStore", "get", { "PortalId": PortalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedPriceListForAccount = function (accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetAssociatedPriceListForAccount", "get", { "accountId": accountId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetTierPrice = function (priceListId, sku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/AddTierPrice", "get", { "priceListId": priceListId, "sku": sku }, callbackMethod, "html");
    };
    Endpoint.prototype.PriceTierList = function (priceListId, sku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/PriceTierList", "get", { "priceListId": priceListId, "sku": sku }, callbackMethod, "html");
    };
    Endpoint.prototype.PriceTierListUsingLazyLoading = function (priceListId, sku, pageNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/PriceTierList", "get", { "priceListId": priceListId, "sku": sku, 'pageNumber': pageNumber }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.BoostAndBuryList = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetBoostAndBuryRules", "get", { "catalogId": catalogId, "catalogName": "" }, callbackMethod, "html");
    };
    Endpoint.prototype.GetLinkWidgetConfigurationList = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, fileName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/GetLinkWidgetConfigurationList", "get", {
            "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetsKey": widgetKey, "typeOFMapping": typeOFMapping, "displayName": displayName, "widgetName": widgetName, "fileName": fileName, "localeId": localeId
        }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteMultipleShipping = function (shippingIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/shippings/Delete", "get", { "shippingId": shippingIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleShippingSKU = function (shippingSKUId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/DeleteShippingSKU", "get", { "shippingSKUId": shippingSKUId }, callbackMethod, "json");
    };
    Endpoint.prototype.ShippingSKUList = function (shippingId, shippingRuleId, shippingRuleType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/ShippingSKUList", "get", { "shippingId": shippingId, "shippingRuleId": shippingRuleId, "shippingRuleType": shippingRuleType }, callbackMethod, "html");
    };
    Endpoint.prototype.EditShippingSKU = function (shippingSKUId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/EditShippingSKU", "get", { "shippingSKUId": shippingSKUId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditPortalCatalog = function (portalCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/EditPortalCatalog", "get", { "portalCatalogId": portalCatalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPortalAssociatedCatalog = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedPortalCatalog", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteMultipleTaxClass = function (taxClassIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/Delete", "get", { "taxClassId": taxClassIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleTaxClassSKU = function (taxClassSKUId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/DeleteTaxClassSKU", "get", { "taxClassSKUId": taxClassSKUId }, callbackMethod, "json");
    };
    Endpoint.prototype.AddTaxClassSKU = function (taxClassId, name, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/AddTaxClassSKU", "get", { "taxClassId": taxClassId, "name": name }, callbackMethod, "html");
    };
    Endpoint.prototype.TaxClassSKUList = function (taxClassId, name, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/TaxClassSKUList", "get", { "taxClassId": taxClassId, "name": name }, callbackMethod, "html");
    };
    Endpoint.prototype.EditTaxClassSKU = function (taxClassSKUId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/EditTaxClassSKU", "get", { "taxClassSKUId": taxClassSKUId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetConfigureAttributeDetails = function (familyId, productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetConfigureAttributeList/", "get", { "familyId": familyId, "productId": productId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateAccountList = function (priceListId, accountIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/AssociateAccount", "post", { "priceListId": priceListId, "customerIds": accountIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleAccountPrice = function (priceListAccountId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/DeleteAssociatedAccount", "get", { "priceListAccountId": priceListAccountId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleTaxRule = function (taxRuleId, taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/DeleteTaxRule", "get", { "taxRuleId": taxRuleId, "taxClassId": taxClassId }, callbackMethod, "json");
    };
    Endpoint.prototype.AddTaxRule = function (taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/AddTaxRule", "get", { "taxClassId": taxClassId }, callbackMethod, "html");
    };
    Endpoint.prototype.TaxRuleList = function (taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/TaxRuleList", "get", { "taxClassId": taxClassId }, callbackMethod, "html");
    };
    Endpoint.prototype.PriceSKUList = function (priceListId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/PriceSKUList", "get", { "priceListId": priceListId, "listName": listName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPriceBySku = function (pimProductId, sku, productType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/GetPriceBySku", "get", { "pimProductId": pimProductId, "sku": sku, "producttype": productType }, callbackMethod, "json");
    };
    Endpoint.prototype.EditTaxRule = function (taxRuleId, taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/EditTaxRule", "get", { "taxRuleId": taxRuleId, "taxClassId": taxClassId }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateAddonGroup = function (addonGroupData, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/EditAddonGroup/", "post", { "model": addonGroupData }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnassociatedConfigureProducts = function (parentProductId, associatedAttributeIds, associatedProductIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetUnassociatedConfigureProducts", "get", {
            "ParentProductId": parentProductId, "attributeIds": associatedAttributeIds, "associatedProductIds": associatedProductIds
        }, callbackMethod, "html");
    };
    Endpoint.prototype.AddSlider = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/CreateSlider", "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.CopyStore = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/CopyStore", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditSlider = function (cmsSliderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/EditSlider", "get", { "cmsSliderId": cmsSliderId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetSliderList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/GetSliderList", "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.GetStoreList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/List", "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.DeleteSliders = function (cmsSliderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/DeleteSlider", "get", { "cmsSliderId": cmsSliderId }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishSlider = function (CMSSliderId, targetPublishState, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/PublishSliderWithPreview", "get", { "cmsSliderId": CMSSliderId, "targetPublishState": targetPublishState, "portalId": 0, "localeId": 0, "takeFromDraftFirst": true }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteBanners = function (cmsSliderBannerId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/DeleteBanner", "get", { "cmsSliderBannerId": cmsSliderBannerId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteCustomerReview = function (cmsCustomerReviewId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Review/Delete", "get", { "cmsCustomerReviewId": cmsCustomerReviewId }, callbackMethod, "json");
    };
    Endpoint.prototype.StateListByCountryCode = function (countryCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/BindStateList", "get", { "countryCode": countryCode }, callbackMethod, "json");
    };
    Endpoint.prototype.CountyListByStateCode = function (stateCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/BindCountyList", "get", { "stateCode": stateCode }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteTheme = function (cmsThemeId, name, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/Delete", "get", { "cmsThemeId": cmsThemeId, "name": name }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteRevisedTheme = function (cmsThemeId, name, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/DeleteRevisedTheme", "get", { "cmsThemeId": cmsThemeId, "name": name }, callbackMethod, "json");
    };
    Endpoint.prototype.GetEditStaticPage = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/EditStaticPage", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditContentPage = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/EditStaticPage", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteStaticPage = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/DeleteStaticPage", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteLinkWidgetConfiguration = function (id, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/DeleteLinkWidgetConfiguration", "get", { "cmsWidgetTitleConfigurationId": id, "localeId": localeId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPublishInfo = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.DeleteAddonGroups = function (addonGroupIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/AddonGroup/DeleteAddonGroup", "get", { "pimAddOnGroupId": addonGroupIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleShippingRule = function (shippingRuleId, shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/DeleteShippingRule", "get", { "shippingRuleId": shippingRuleId, "shippingId": shippingId }, callbackMethod, "json");
    };
    Endpoint.prototype.AddShippingRule = function (shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/AddShippingRule", "get", { "shippingId": shippingId }, callbackMethod, "html");
    };
    Endpoint.prototype.ShippingRuleList = function (shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/ShippingRuleList", "get", { "shippingId": shippingId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditShippingRule = function (shippingRuleId, shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/EditShippingRule", "get", { "shippingRuleId": shippingRuleId, "shippingId": shippingId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetEditContentPageData = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/EditStaticPage", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetContentPageListData = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/StaticPageList", "get", { "id": id }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteContentPage = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/DeleteContentPage", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "json");
    };
    Endpoint.prototype.EditStaticPage = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/EditStaticPage", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedAddonGroup = function (parentProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetUnassociatedAddonGroups", "get", { "parentProductId": parentProductId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedAddonlist = function (parentProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetAssociatedAddonGroups", "get", { "parentProductId": parentProductId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteManageMessage = function (cmsPortalMessageId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/DeleteManageMessage", "get", { "cmsPortalMessageId": cmsPortalMessageId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedStoreList = function (priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/GetAssociatedStoreList", "get", { "cmsThemeId": priceListId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteManageMessageForWebsite = function (cmsMessageId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/DeleteManageMessage", "get", { "cmsMessageId": cmsMessageId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAddonProduct = function (addonProductId, parentProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/DeleteAddonProduct", "get", { "addonProductId": addonProductId, "parentProductId": parentProductId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatedAddonProduct = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/AssociatedAddonProduct", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.UnassociateAddonProducts = function (addonProductDetailId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UnassociateAddonProducts", "get", { "pimAddonProductDetailId": addonProductDetailId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateProduct = function (cmsWidgetsId, cmsMappingId, WidgetsKey, TypeOfMapping, SKUs, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/AssociateProduct", "post", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "WidgetKey": WidgetsKey, "TypeOfMapping": TypeOfMapping, "SKUs": SKUs }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociateProduct = function (cmsWidgetProductId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/UnAssociateProduct", "get", { "cmsWidgetProductId": cmsWidgetProductId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUnAssociatedProductList = function (cmsContentPagesId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/GetUnAssociatedProductList", "get", { "cmsContentPagesId": cmsContentPagesId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteAccountCustomers = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/CustomerDelete", "get", { "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductsToBeAssociated = function (associatedProductIds, productType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetProductsToBeAssociated", "get", { "productIds": associatedProductIds, "productType": productType }, callbackMethod, "html");
    };
    Endpoint.prototype.GetConfigureProductsToBeAssociated = function (associatedProductIds, associatedAttributeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetConfigureProductsToBeAssociated", "get", { "associatedProductIds": associatedProductIds, "associatedAttributeIds": associatedAttributeIds }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedCategory = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/GetUnAssociatedCategoryList", "get", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetKey": widgetKey, "typeOFMapping": typeOFMapping, "displayName": displayName, "widgetName": widgetName, "fileName": fileName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedBrand = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/GetUnAssociatedBrandList", "get", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetKey": widgetKey, "typeOFMapping": typeOFMapping, "displayName": displayName, "widgetName": widgetName, "fileName": fileName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedCountryList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetUnAssociatedCountryList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnAssociatedProfileList = function (userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/GetUnAssociatedProfileList", "get", { "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.CreateLinkWidgetConfiguration = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/CreateLinkWidgetConfiguration", "get", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetKey": widgetKey, "typeOFMapping": typeOFMapping, "displayName": displayName, "widgetName": widgetName }, callbackMethod, "html");
    };
    Endpoint.prototype.RemoveAssociatedCategories = function (cmsWidgetCategoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/RemoveAssociatedCategories", "get", { "cmsWidgetCategoryId": cmsWidgetCategoryId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveAssociatedBrands = function (cmsWidgetBrandId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/RemoveAssociatedBrands", "get", { "cmsWidgetBrandId": cmsWidgetBrandId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveAssociatedCountries = function (portalCountryId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/UnAssociateCountries", "get", { "portalCountryId": portalCountryId, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociatePriceListFromAccount = function (priceListId, accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/UnAssociatePriceListToAccount", "get", { "priceListId": priceListId, "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociateProfiles = function (profileId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/UnAssociateProfiles", "get", { "profileId": profileId, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductListBySKU = function (attributeValue, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/GetProductListBySKU", "get", { "attributeValue": attributeValue }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCatalogList = function (catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetCatalog", "get", { "catalogName": catalogName }, callbackMethod, "json");
    };
    Endpoint.prototype.GetTaxAssociatedStoreList = function (taxClassId, name, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/GetAssociatedStoreList", "get", { "taxClassId": taxClassId, "name": name }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnassociatedStoreList = function (taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/GetUnassociatedStoreList", "get", { "taxClassId": taxClassId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateStore = function (taxClassId, storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/AssociateStore", "post", { "taxClassId": taxClassId, "storeIds": storeIds }, callbackMethod, "json");
    };
    Endpoint.prototype.UnassociateStore = function (taxClassPortalId, taxClassId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/UnassociateStore", "get", { "taxClassPortalId": taxClassPortalId, "taxClassId": taxClassId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateCategoriesForWebSite = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, categoryCodes, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/AssociateCategories", "post", { "cmsWidgetsId": cmsWidgetsId, "categoryCodes": categoryCodes, "cmsMappingId": cmsMappingId, "widgetKey": widgetKey, "typeOFMapping": typeOFMapping }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateBrandsForWebSite = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, brandId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/AssociateBrands", "post", { "cmsWidgetsId": cmsWidgetsId, "brandId": brandId, "cmsMappingId": cmsMappingId, "widgetKey": widgetKey, "typeOFMapping": typeOFMapping }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateCountriesForStore = function (portalId, countryCode, isDefault, portalCountryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociateCountries", "post", { "countryCode": countryCode, "portalId": portalId, "isDefault": isDefault, "portalCountryId": portalCountryId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateProfilesForCustomer = function (profileIds, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/AssociateProfiles", "post", { "profileIds": profileIds, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedCatagoryList = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/GetAssociatedCategoryList", "get", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetKey": widgetKey, "typeOFMapping": typeOFMapping, "displayName": displayName, "widgetName": widgetName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetShippingAssociatedStoreList = function (shippingId, shippingTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/GetAssociatedStoreList", "get", { "shippingId": shippingId, "shippingTypeId": shippingTypeId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetShippingUnassociatedStoreList = function (shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/GetUnassociatedStoreList", "get", { "shippingId": shippingId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateStoreToShipping = function (shippingId, storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/AssociateStore", "post", { "shippingId": shippingId, "storeIds": storeIds }, callbackMethod, "json");
    };
    Endpoint.prototype.UnassociateStoreFromShipping = function (shippingPortalId, shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/UnassociateStore", "get", { "shippingPortalId": shippingPortalId, "shippingId": shippingId }, callbackMethod, "json");
    };
    Endpoint.prototype.EditAssociatedStoresPrecedence = function (priceListPortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/EditAssociatedStoresPrecedence", "get", { "priceListPortalId": priceListPortalId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatedStoresList = function (priceListId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/GetAssociatedStoreList", "get", { "priceListId": priceListId, "listName": listName }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteUrlRedirect = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/DeleteUrlRedirect", "get", { "cmsUrlRedirectId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.EditAssociatedCustomerPrecedence = function (priceListUserId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/EditAssociatedCustomerPrecedence", "get", { "priceListUserId": priceListUserId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatedCustomerList = function (priceListId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/GetAssociatedCustomerList", "get", { "priceListId": priceListId, "listName": listName }, callbackMethod, "html");
    };
    Endpoint.prototype.EditAssociatedAccountPrecedence = function (priceListAccountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/EditAssociatedAccountPrecedence", "get", { "priceListAccountId": priceListAccountId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatedAccountList = function (priceListId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/GetAssociatedAccountList", "get", { "priceListId": priceListId, "listName": listName }, callbackMethod, "html");
    };
    Endpoint.prototype.EditAssociatedProfilePrecedence = function (priceListProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/EditAssociatedProfilePrecedence", "get", { "priceListProfileId": priceListProfileId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatedProfileList = function (priceListId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/GetAssociatedProfileList", "get", { "priceListId": priceListId, "listName": listName }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteStoreLocator = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/StoreLocator/Delete", "get", { "PortalAddressId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteStoreLocatorByCode = function (storeLocationCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/StoreLocator/DeleteByCode", "get", { "storeLocationCode": storeLocationCode }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCreateAddonGroupForm = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/AddonGroup/CreateAddonGroup", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.CreateAddonGroup = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/AddonGroup/CreateAddonGroup", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleCatalogAssociatedCategories = function (pimCatalogId, pimCategoryHierarchyId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/DeleteAssociateCategory", "get", { "pimCatalogId": pimCatalogId, "pimCategoryHierarchyId": pimCategoryHierarchyId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultiplePromotion = function (promotionIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/Delete", "get", { "promotionId": promotionIds }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteProfiles = function (profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/Delete", "get", { "profileId": profileId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedCategoryDetails = function (catalogId, categoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/EditCategorySettings", "get", { "catalogId": catalogId, "categoryId": categoryId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedCategoryList = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetAssociatedCategoryList", "get", { "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateAssociatedCategoryDetails = function (catalogAssociateCategoryViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/EditCategorySettings", "post", { "catalogAssociateCategoryViewModel": catalogAssociateCategoryViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.CatalogListByStorIds = function (storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/BindCatalogList", "get", { "storeIds": storeIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.CategoryListByStorIds = function (storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/BindCategoryList", "get", { "storeIds": storeIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ProductListByStorIds = function (storeIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/BindProductList", "get", { "storeIds": storeIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.UpdateAddonProductAssociation = function (addonProductmodel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UpdateProductAddonAssociation", "post", { "addonProductViewModel": addonProductmodel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsAttributeCodeExist = function (attributeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Attributes/IsAttributeCodeExist", "get", { "attributeCode": attributeCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsPIMAttributeCodeExist = function (attributeCode, isCategory, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/ProductAttribute/IsAttributeCodeExist", "get", { "attributeCode": attributeCode, "isCategory": isCategory }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ChangeStatus = function (cmsCustomerReviewId, statusId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Review/BulkStatusChange", "get", { "cmsCustomerReviewId": cmsCustomerReviewId, "statusId": statusId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsAttributeValueUnique = function (attributeCodeValues, id, isCategory, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/ProductAttribute/IsAttributeValueUnique", "get", { "attributeCodeValues": attributeCodeValues, "id": id, "isCategory": isCategory }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetUnassociatedCatalogCategory = function (pimCatalogId, catalogName, isCategoryTreeUpdate, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetUnAssociatedCategoryList", "get", { "pimCatalogId": pimCatalogId, "catalogName": catalogName, "isCategoryTreeUpdate": isCategoryTreeUpdate }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteGiftCard = function (giftCardId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/Delete", "get", { "giftCardId": giftCardId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteSearchProfile = function (searchProfileId, isDeletePublishSearchProfile, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/Delete", "get", {
            "searchProfileId": searchProfileId, "isDeletePublishSearchProfile": isDeletePublishSearchProfile
        }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteSearchTriggers = function (searchProfileTriggerId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/DeleteSearchTriggers", "get", { "searchProfileTriggerId": searchProfileTriggerId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultiplePaymentSettings = function (paymentSettingIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Payment/Delete", "get", { "PaymentSettingId": paymentSettingIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAjaxHeaders = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/MediaManager/GetAjaxHeaders", "get", {}, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetPaymentAppHeader = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetPaymentAppHeader", Constant.GET, {}, callbackMethod, "json", true);
    };
    Endpoint.prototype.GetCSSList = function (cmsThemeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/Manage", "get", { "cmsThemeId": cmsThemeId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteTemplate = function (cmsTemplateId, fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Template/Delete", "get", { "cmsTemplateId": cmsTemplateId, "fileName": fileName }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteCss = function (cmsThemeCssId, cssName, themeName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/DeleteCSS", "get", { "cmsThemeCssId": cmsThemeCssId, "cssName": cssName, "themeName": themeName }, callbackMethod, "json");
    };
    Endpoint.prototype.ContentPageAddFolder = function (parentId, folderName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/AddFolder", "get", { "parentId": parentId, "folderName": folderName }, callbackMethod, "json");
    };
    Endpoint.prototype.ContentPageRenameFolder = function (folderId, folderName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/RenameFolder", "get", { "folderId": folderId, "folderName": folderName }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProfileList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/GetProfileList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.ContentPageFolderDelete = function (folderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/DeleteFolder", "get", { "folderId": folderId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCountryList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/GetCountryList", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateLocales = function (Url, model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, Url, "post", { model: model }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteMenu = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RoleAndAccessRight/DeleteMenu", "get", { "menuId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteRole = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RoleAndAccessRight/DeleteRole", "get", { "id": id }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteERPConfigurator = function (eRPConfiguratorId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProviderEngine/DeleteERPConfigurator", "get", { "eRPConfiguratorId": eRPConfiguratorId }, callbackMethod, "json");
    };
    Endpoint.prototype.ProfileListByStorId = function (storeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/ProfileListByStoreId", "get", { "storeIds": storeId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.CatalogListByStorId = function (storeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/CatalogListByStoreId", "get", { "storeIds": storeId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.CategoryListByStorId = function (storeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/CategoryListByStoreId", "get", { "storeIds": storeId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ShippingStateListByCountryCode = function (countryCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/GetStateListByCountryCode", "get", { "countryCode": countryCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ShippingCityListByStateCode = function (stateCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/GetCityListByStateCode", "get", { "stateCode": stateCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.CreateNewOrderByPortalIdChange = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/CreateOrder", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.CreateNewOrderByPortalIdChangeForUser = function (portalId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/CreateOrder", "get", { "portalId": portalId, "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetConvertedDecimalValues = function (price, currencyCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RmaManager/GetConvertedCurrencyValues", "post", { "decimalValue": price, "currencyCode": currencyCode }, callbackMethod, "json");
    };
    Endpoint.prototype.createRMARequest = function (requestModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAManager/CreateRMA", "post", { "requestModel": requestModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCustomerList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetCustomerList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDomains = function (portalId, doaminIds, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/GetDomains", "get", { "portalId": portalId, "domainIds": doaminIds, "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.SetCustomerDetailsById = function (userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/SetCustomerDetailsById", "get", { "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCreateLinkWidgetForm = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/CreateLinkWidget", "get", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetsKey": widgetKey, "typeOFMapping": typeOFMapping, "displayName": displayName, "widgetName": widgetName, "fileName": fileName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetNewCustomerView = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/AddNewCustomer", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.ManageTextWidgetConfiguration = function (mappingId, widgetId, widgetKey, mappingType, displayName, widgetName, fileName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/ManageTextWidgetConfiguration", "get", { "mappingId": mappingId, "widgetId": widgetId, "widgetKey": widgetKey, "mappingType": mappingType, "displayName": displayName, "widgetName": widgetName, "fileName": fileName, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteERPTaskScheduler = function (erpTaskSchedulerIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TouchPointConfiguration/Delete", "get", { "erpTaskSchedulerId": erpTaskSchedulerIds }, callbackMethod, "json");
    };
    Endpoint.prototype.EditBanner = function (CMSSliderBannerId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/EditBanner", "get", { "CMSSliderBannerId": CMSSliderBannerId, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateManageMessage = function (cmsMessageKeyId, cmsAreaId, portalId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/UpdateManageMessage", "get", { "cmsMessageKeyId": cmsMessageKeyId, "cmsAreaId": cmsAreaId, "portalId": portalId, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.AddTaxClassSKUList = function (taxClassId, SKUs, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TaxClass/AddTaxClassSKU", "get", { "taxClassId": taxClassId, "taxClassSKUs": SKUs }, callbackMethod, "json");
    };
    Endpoint.prototype.GetSchedulerFrequency = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.GetCustomerListByName = function (customerName, portalId, isAccountCustomer, accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetCustomerListByName", "get", { "customerName": customerName, "portalId": portalId, "isAccountCustomer": isAccountCustomer, "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUserAddressBySelectedAddress = function (addressId, fromBillingShipping, isB2BCustomer, userId, portalId, accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetAddressById", "get", { "userAddressId": addressId, "fromBillingShipping": fromBillingShipping, "isB2BCustomer": isB2BCustomer, "userId": userId, "portalId": portalId, "accountId": accountId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPartial = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.EditEmailTemplate = function (EmailTemplateId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/Edit", "get", { "EmailTemplateId": EmailTemplateId, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateCategoriesToCatalog = function (catalogAssociation, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/AssociateCategory", "post", { "catalogAssociationViewModel": catalogAssociation }, callbackMethod, "json");
    };
    Endpoint.prototype.AddUpdateProductInventory = function (inventorySKUViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/AddUpdateSKUInventoryProduct", "post", { "InventorySKUViewModel": inventorySKUViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateProductsToCatalogCategory = function (productAssociationModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/AssociateProduct", "post", { "catalogAssociationViewModel": productAssociationModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociateProducts = function (productUnassociationModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/DeleteAssociateProducts", "post", { "catalogAssociationViewModel": productUnassociationModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteEmailTemplates = function (emailTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/Delete", "get", { "emailtemplateId": emailTemplateId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteProductFeed = function (productFeedId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProductFeed/Delete", "get", { "productFeedId": productFeedId }, callbackMethod, "json");
    };
    Endpoint.prototype.EmailTemplatePreview = function (emailTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/Preview", "get", { "emailTemplateId": emailTemplateId }, callbackMethod, "html");
    };
    Endpoint.prototype.SingleResetPassword = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/SingleResetPassword", "get", { "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductsList = function (portalCatalogId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/ProductList", "get", { "portalCatalogId": portalCatalogId, "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.CalculateShippingCharges = function (data, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/CalculateShippingCharges", "post", { "createOrderModel": data }, callbackMethod, "html");
    };
    Endpoint.prototype.CreateReasonForReturn = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/CreateReasonForReturn", "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.EditReasonForReturn = function (rmaReasonForReturnId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/EditReasonForReturn", "get", { "rmaReasonForReturnId": rmaReasonForReturnId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteReasonForReturn = function (rmaReasonForReturnId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/DeleteReasonForReturn", "get", { "rmaReasonForReturnId": rmaReasonForReturnId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetReasonForReturnList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/GetReasonForReturnList", "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.EditRequestStatus = function (rmaRequestStatusId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/EditRequestStatus", "get", { "rmaRequestStatusId": rmaRequestStatusId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetRequestStatusList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/GetRequestStatusList", "get", "", callbackMethod, "html");
    };
    Endpoint.prototype.DeleteRequestStatus = function (rmaRequestStatusId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAConfiguration/DeleteRequestStatus", "get", { "rmaRequestStatusId": rmaRequestStatusId }, callbackMethod, "json");
    };
    Endpoint.prototype.EditHighlight = function (HighlightId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Highlight/Edit", "get", { "HighlightId": HighlightId, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditAssociatedPriceListPrecedence = function (priceListProfileId, priceListId, portalId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/EditAssociatedPriceListPrecedence", "get", { "priceListProfileId": priceListProfileId, "priceListId": priceListId, "portalId": portalId, "listName": listName }, callbackMethod, "json");
    };
    Endpoint.prototype.AddToCart = function (cartItem, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/AddToCart", "post", { "cartItem": cartItem }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteEmailTemplateAreaMapping = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/DeleteEmailTemplateAreaMapping", "get", { "areaMappingId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAvailableTemplateArea = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/GetAvailableTemplateArea", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetEmailTemplateListByName = function (searchTerm, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/GetEmailTemplateListByName", "get", { "searchTerm": searchTerm }, callbackMethod, "json");
    };
    Endpoint.prototype.SaveBoostValues = function (boostData, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/SaveBoostValue", "post", { "boostData": boostData }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleHighlight = function (highlightIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Highlight/Delete", "get", { "highlightId": highlightIds }, callbackMethod, "json");
    };
    Endpoint.prototype.EditAssociatedPriceListPrecedenceForAccount = function (priceListId, accountId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/EditAssociatedPriceListPrecedence", "get", { "priceListId": priceListId, "accountId": accountId, "listName": listName }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatePriceListForAccount = function (accountId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/AssociatePriceListToAccount", "post", { "accountId": accountId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateProfileForAccount = function (accountId, profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/AssociateProfileToAccount", "post", { "accountId": accountId, "profileIds": profileId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProductSKUList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Price/GetProductSKUList", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.UnAssociatePriceListFromCustomer = function (priceListId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/UnAssociatePriceListToCustomer", "get", { "priceListId": priceListId, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.EditAssociatedPriceListPrecedenceForCustomer = function (priceListId, userId, listName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/EditAssociatedPriceListPrecedence", "get", { "priceListId": priceListId, "userId": userId, "listName": listName }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedPriceListForCustomer = function (userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/GetAssociatedPriceListForCustomer", "get", { "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatePriceListForCustomer = function (userId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/AssociatePriceListToCustomer", "post", { "userId": userId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateHighlightProductList = function (highlightCode, productIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Highlight/AssociateHighlightProducts", "get", { "highlightCode": highlightCode, "productIds": productIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.UnAssociateHighlightProduct = function (productId, highlightcode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Highlight/UnAssociateHighlightProducts", "get", { "PimProductId": productId, "attributevalue": highlightcode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.BindCustomerDetails = function (cartParameter, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/BindCustomerDetails", "post", { "cartParameter": cartParameter }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateCartQuantity = function (guid, quantity, productid, shippingid, isQuote, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateCartQuantity", "post", { "guid": guid, "quantity": quantity, "productId": productid, "shippingId": shippingid, "isQuote": isQuote, "userId": userId }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.DeleteCartItem = function (guid, orderId, isQuote, userId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/RemoveCartItem", "post", { "guid": guid, "orderId": orderId, "isQuote": isQuote, "userId": userId, "portalId": portalId }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.DeleteAllCartItem = function (userId, portalId, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/RemoveAllShoppingCartItems", "post", {
            "userId": userId, "portalId": portalId, "isQuote": isQuote
        }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.GetPortalSeoSettings = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/SEOSetting", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProductPrice = function (portalId, sku, parentProductSKU, quantity, selectedAddOnIds, parentProductId, omsOrderId, userId, callbackMethod) {
        if (omsOrderId === void 0) { omsOrderId = 0; }
        if (userId === void 0) { userId = 0; }
        _super.prototype.ajaxRequest.call(this, "/Order/GetProductPrice", "get", {
            "portalId": portalId, "productSKU": sku, "parentProductSKU": parentProductSKU, "quantity": quantity, "addOnIds": selectedAddOnIds, "parentProductId": parentProductId, "omsOrderId": omsOrderId, "userId": userId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAddLinkWidgetConfiguration = function (cmsWidgetsId, cmsMappingId, widgetKey, typeOFMapping, displayName, widgetName, fileName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/AddNewLinkWidgetConfiguration", "get", { "cmsWidgetsId": cmsWidgetsId, "cmsMappingId": cmsMappingId, "widgetsKey": widgetKey, "typeOFMapping": typeOFMapping, "localeId": localeId, "displayName": displayName, "widgetName": widgetName, "fileName": fileName }, callbackMethod, "json");
    };
    Endpoint.prototype.GetProduct = function (parameters, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetConfigurableProduct", "post", { "parameters": parameters }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPaymentDetails = function (paymentSettingId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetPaymentDetails", "get", { "paymentSettingId": paymentSettingId, "userId": userId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetPublishProductsList = function (portalCatalogId, portalId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/ProductList", "get", { "portalCatalogId": portalCatalogId, "portalId": portalId, "userId": userId }, callbackMethod, "html", true, false);
    };
    Endpoint.prototype.GetEncryptedAmountByAmount = function (total, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetEncryptedAmount", "get", { "amount": total }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetInventoryDetails = function (productSKU, productId, isDownlodableProduct, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/ProductInventory", "get", {
            "SKU": productSKU,
            "productId": productId,
            "isDownloadable": isDownlodableProduct
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDownloadableProductKeys = function (productSKU, productId, inventoryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/GetDownloadableProductKeys", "get", {
            "sku": productSKU,
            "productId": productId,
            "inventoryId": inventoryId
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedProductCatagoryList = function (isAssociated, productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Category/GetAssociatedCategoriesToProduct", "get", {
            "isAssociateCategories": isAssociated,
            "productId": productId
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProductSEODetails = function (seoTypeId, seoCode, publishProductId, localeId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/GetSEODetailsBySEOCode", "get", {
            "seoTypeId": seoTypeId,
            "localeId": localeId,
            "portalId": portalId,
            "seoCode": seoCode,
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCategorySEODetails = function (seoTypeId, seoCode, categoryId, localeId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/CategorySEODetails", "get", {
            "seoTypeId": seoTypeId,
            "itemId": categoryId,
            "localeId": localeId,
            "portalId": portalId,
            "seoCode": seoCode
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDefaultSEODetails = function (seoTypeId, seoCode, itemId, localeId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/GetDefaultSEODetails", "get", {
            "seoTypeId": seoTypeId,
            "localeId": localeId,
            "portalId": portalId,
            "seoCode": seoCode,
            "itemId": itemId
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDefaultCMSSEODetails = function (seoTypeId, seoCode, itemId, localeId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/GetDefaultCMSSEODetails", "get", {
            "seoTypeId": seoTypeId,
            "localeId": localeId,
            "portalId": portalId,
            "seoCode": seoCode,
            "itemId": itemId
        }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProductPriceDetails = function (pimProductId, sku, productType, productpriceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Products/GetProductPriceBySku", "get", { "pimProductId": pimProductId, "sku": sku, "productType": productType, "productpriceListId": productpriceListId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetInventoryBySKU = function (sku, warehouseId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/InventoryBySKUAndWarehouseId", "get", { "sku": sku, "warehouseId": warehouseId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteTierPriceByIdAndPriceList = function (priceTierId, pimProductId, priceListId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Products/DeleteTierPrice", "get", { "priceTierId": priceTierId, "pimProductId": pimProductId, "priceListId": priceListId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteBrand = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Brand/Delete", "get", { "brandId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.SEODetails = function (itemName, seoTypeId, seoCode, localeId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/SEODetails", "get", { "itemName": itemName, "seoTypeId": seoTypeId, "seoCode": seoCode, "localeId": localeId, "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPublishedProductList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/GetProductsForSEO", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetActiveCurrencyToStore = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/GetActiveCurrencyToStore", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCurrencyDetailsByCode = function (currencyCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/GetCurrencyDetailsByCode", "get", { "currencyCode": currencyCode }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPublishedCategoryList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/GetCategoriesForSEO", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetContentPagesList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/GetContentPages", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.UrlRedirectList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/UrlRedirectList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetReportData = function (reportPath, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/GetReportDetail", "get", { "reportPath": reportPath }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteVendor = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Vendor/Delete", "get", { "PimVendorId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.BrandAssociatePortalList = function (brandId, portalIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Brand/AssociateBrandPortals", "get", { "brandId": brandId, "portalIds": portalIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.BrandAssociateProductList = function (brandCode, productIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Brand/AssociateBrandProducts", "get", { "brandCode": brandCode, "productIds": productIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.BrandUnAssociateProductList = function (productIds, brandCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Brand/UnAssociateBrandProducts", "get", { "pimProductId": productIds, "attributeValue": brandCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.BrandUnAssociatePortalList = function (portalId, brandId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Brand/UnAssociateBrandPortals", "get", { "portalId": portalId, "brandId": brandId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociatedBrandPortalList = function (brandId, brandCode, brandName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Brand/AssociatedStoreList", "get", { "brandId": brandId, "localeId": localeId, "brandCode": brandCode, "brandName": brandName }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAccountsPortal = function (accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetAccountsPortal", "get", { "accountId": accountId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.VendorAssociatedProductList = function (vendorCode, vendorName, productIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Vendor/AssociateVendorProducts", "get", { "vendorCode": vendorCode, "vendorName": vendorName, "productIds": productIds }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociatedProductList = function (PimVendorId, vendorCode, vendorName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Vendor/AssociatedProductList", "get", { "PimVendorId": PimVendorId, "vendorCode": vendorCode, "vendorName": vendorName }, callbackMethod, "html");
    };
    Endpoint.prototype.VendorUnAssociateProductList = function (productIds, vendorCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Vendor/UnAssociateVendorProducts", "get", { "pimProductId": productIds, "attributeValue": vendorCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ActiveInactiveVendor = function (vendorIds, isActive, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Vendor/ActiveInactiveVendor", "get", { "vendorIds": vendorIds, "isActive": isActive }, callBackMethod, "json");
    };
    Endpoint.prototype.CreateUrlRedirect = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SEO/CreateUrlRedirect", "get", { "portalId": portalId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.CheckGroupProductInventory = function (parameters, sku, quantity, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/CheckGroupProductInventory", "post", { "parameters": parameters, "productSKU": sku, "quantity": quantity }, callbackMethod, "json", false);
    };
    Endpoint.prototype.ManageEmailTemplateArea = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/EmailTemplate/ManageEmailTemplateArea", "get", { "portalId": portalId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetSearchConfiguration = function (publishCatalogId, catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/CreateIndex", "get", { "publishCatalogId": publishCatalogId, "catalogName": catalogName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetSearchProfiles = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetSearchProfiles", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.GetSearchProfilesByCatalogId = function (publishCatalogId, catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetSearchProfiles", "get", { "catalogId": publishCatalogId, "catalogName": catalogName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedCatalogAttributes = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetAssociatedCatalogAttributes", "get", { "publishCatalogId": 0, "searchProfileId": 0 }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedUnAssociatedCatalogAttributes = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetAssociatedUnAssociatedCatalogAttributes", "get", { "publishCatalogId": 0, "searchProfileId": 0, "isAssociated": true }, callbackMethod, "html");
    };
    Endpoint.prototype.GetPromotionDiscountAttribute = function (discountName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/GetPromotionDiscountAttribute", "get", { "discountName": discountName }, callbackMethod, "html");
    };
    Endpoint.prototype.InsertCreateIndexData = function (portalIndex, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/InsertCreateIndexData", "post", { "portalIndexModel": portalIndex }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetSearchIndexMonitorList = function (catalogIndexId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetSearchIndexMonitor", "get", { "catalogIndexId": catalogIndexId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetSearchIndexServerStatusList = function (searchIndexMonitorId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetSearchIndexServerStatusList", "get", { "searchIndexMonitorId": searchIndexMonitorId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedCatelog = function (storeId, catelogIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/GetAssociatedCatelog", "get", { "storeId": storeId, "catelogIds": catelogIds, "promotionId": promotionId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedCategory = function (storeId, categoryIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/GetAssociatedCategory", "get", { "storeId": storeId, "categoryIds": categoryIds, "promotionId": promotionId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedProduct = function (storeId, productIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/GetAssociatedProduct", "get", { "storeId": storeId, "productIds": productIds, "promotionId": promotionId }, callbackMethod, "html");
    };
    Endpoint.prototype.EnableDisableAdminAPIDomain = function (domainIds, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/UrlManagement/EnableDisableDomain", "get", { "DomainId": domainIds, "IsActive": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateCatalogToPromotion = function (storeId, associatedCatelogIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/AssociateCatalogToPromotion", "get", { "storeId": storeId, "associatedCatelogIds": associatedCatelogIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedBrands = function (brandIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/GetAssociatedBrands", "get", { "assignedIds": brandIds, "promotionId": promotionId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProductBoostSetting = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetGlobalProductBoost", "get", { "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProductCategoryBoostSetting = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetGlobalProductCategoryBoost", "get", { "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetFieldBoostSetting = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetFieldLevelBoost", "get", { "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateCategoryToPromotion = function (storeId, associatedCategoryIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/AssociateCategoryToPromotion", "get", { "storeId": storeId, "associatedCategoryIds": associatedCategoryIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.CustomerEnableDisableAccount = function (accountid, id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/CustomerEnableDisableAccount", "get", { "accountId": accountid, "userId": id, "isLock": isEnable, "isRedirect": false }, callbackMethod, "json");
    };
    Endpoint.prototype.EnableDisableDomain = function (portalId, domainIds, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/EnableDisableDomain", "get", { "PortalId": portalId, "DomainId": domainIds, "IsActive": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.CustomerAccountResetPassword = function (accountid, id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/BulkResetPassword", "get", { "accountid": accountid, "userId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.useCouponCode = function (url, couponCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "Coupon": couponCode }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.AssociateProductToPromotion = function (storeId, associatedProductIds, promotionId, discountTypeName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/AssociateProductToPromotion", "get", { "storeId": storeId, "associatedProductIds": associatedProductIds, "promotionId": promotionId, "discountTypeName": discountTypeName }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateBrandToPromotion = function (associatedBrandIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/AssociateBrandToPromotion", "get", { "associatedBrandIds": associatedBrandIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.removeCouponCode = function (url, couponCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "Coupon": couponCode }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.applyGiftCard = function (url, giftCard, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "giftCardNumber": giftCard, "userId": userId }, callbackMethod, "html", true, false);
    };
    Endpoint.prototype.GetTemplateList = function (importHeadId, familyId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/BindTemplateList", "post", { "importHeadId": importHeadId, "familyId": familyId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetTemplateMappings = function (templateId, importHeadId, familyId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/GetAssociatedTemplateList", "post", { "templateId": templateId, "importHeadId": importHeadId, "familyId": familyId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetContentPage = function (CMSContentPagesId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/EditContentPage", "get", { "cmsContentPagesId": CMSContentPagesId, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.PublishContentPage = function (cmsContentPagesId, targetPublishState, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/PublishContentPageWithPreview", "post", { "cmsContentPagesId": cmsContentPagesId, "localeId": localeId, "targetPublishState": targetPublishState, "takeFromDraftFirst": true }, callbackMethod, "json");
    };
    Endpoint.prototype.ShowLogStatus = function (importProcessLogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/ShowLogStatus", "get", { "importProcessLogId": importProcessLogId }, callbackMethod, "html");
    };
    Endpoint.prototype.ShowLogDetails = function (importProcessLogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/ShowLogDetails", "get", { "importProcessLogId": importProcessLogId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsAttributeDefaultValueCodeExist = function (attributeId, attributeDefaultValueCode, defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/ProductAttribute/IsAttributeDefaultValueCodeExist", "get", { "attributeId": attributeId, "attributeDefaultValueCode": attributeDefaultValueCode, "defaultValueId": defaultvalueId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteAssociatedPromotionProducts = function (associatedProductIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/UnAssociateProducts", "get", { "publishProductId": associatedProductIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedPromotionBrands = function (associatedBrandIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/UnAssociateBrands", "get", { "BrandId": associatedBrandIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateQuoteStatus = function (quoteId, status, isPendingPaymentStatus, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/UpdateQuoteStatus", "get", { "quoteId": quoteId, "status": status, "isPendingPaymentStatus": isPendingPaymentStatus }, callbackMethod, "json");
    };
    Endpoint.prototype.DeclinePendingPayment = function (quoteId, status, isPendingPaymentStatus, orderStatus, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/UpdateQuoteStatus", "get", { "quoteId": quoteId, "status": status, "isPendingPaymentStatus": isPendingPaymentStatus, 'orderStatus': orderStatus }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedPromotionCategorys = function (associatedCategoryIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/UnAssociateCategories", "get", { "publishCategoryId": associatedCategoryIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedPromotionCatalogs = function (associatedCatalogIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/UnAssociateCatalogs", "get", { "publishCatalogId": associatedCatalogIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedProfileCatalog = function (profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/DeleteAssociatedProfileCatalog", "get", { "profileId": profileId }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociateAssociatedShipping = function (shippingId, profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/UnAssociateAssociatedShipping", "get", { "shippingId": shippingId, "profileId": profileId }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociateAssociatedShippingToStore = function (shippingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/UnAssociateAssociatedShipping", "get", { "shippingId": shippingId, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.ApplyCSRDiscount = function (csrDiscount, csrDesc, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/ApplyCSRDiscount", "get", { "CSRDiscount": csrDiscount, "csrDesc": csrDesc, "userId": userId }, callbackMethod, "html", true, false);
    };
    Endpoint.prototype.AssociateCatalogToProfile = function (profileId, pimCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/AssociateCatalogToProfile", "get", { "profileId": profileId, "pimCatalogId": pimCatalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateShipping = function (profileId, shippingIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/AssociateShipping", "get", { "profileId": profileId, "shippingIds": shippingIds }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateShippingToStore = function (portalId, shippingIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociateShipping", "get", { "portalId": portalId, "shippingIds": shippingIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedShippingList = function (profileId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/GetAssociatedShippingList", "get", { "profileId": profileId, "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedShippingListToStore = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedShippingList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetProfileCatalogList = function (profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/GetProfileCatalogList", "get", { "profileId": profileId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteAssociateProductsFromProfile = function (catalogAssociation, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/DeleteAssociateProductsFromProfile", "post", { "catalogAssociationViewModel": catalogAssociation }, callbackMethod, "json");
    };
    Endpoint.prototype.MoveCategory = function (addtoFolderId, folderId, catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/MoveFolder", "get", { "addtoFolderId": addtoFolderId, "folderId": folderId, "pimCatalogId": catalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateProductsToProfileCatalog = function (catalogAssociation, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/AssociateProductToProfileCatalog", "post", { "catalogAssociationViewModel": catalogAssociation }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteMultipleCatalogAssociatedCategoriesForProfile = function (pimCatalogId, pimCategoryHierarchyId, profileCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/DeleteAssociateCategoryForProfile", "get", { "pimCatalogId": pimCatalogId, "pimCategoryHierarchyId": pimCategoryHierarchyId, "profileCatalogId": profileCatalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.CreateNewView = function (itemViewId, itemText, isPublic, isDefault, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/CreateNewView", "get", { "itemViewId": itemViewId, "itemText": itemText, "isPublic": isPublic, "isDefault": isDefault }, callbackMethod, "json");
    };
    Endpoint.prototype.CreateSearchScheduler = function (erpTaskSchedulerViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TouchPointConfiguration/Create", "post", { "erpTaskSchedulerViewModel": erpTaskSchedulerViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.AddSynonyms = function (searchSynonymsViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/CreateSearchSynonyms", "post", { "searchSynonymsViewModel": searchSynonymsViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.CreateSearchProfileTriggers = function (SearchTriggersViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/CreateSearchProfileTriggers", "post", { "searchTriggersViewModel": SearchTriggersViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetSearchProfilesTriggers = function (searchProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetSearchProfilesTriggers", "get", { "searchProfileId": searchProfileId }, callbackMethod, "html");
    };
    Endpoint.prototype.EditSynonyms = function (searchSynonymsViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/EditSearchSynonyms", "post", { "searchSynonymsViewModel": searchSynonymsViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.EditSearchScheduler = function (erpTaskSchedulerViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TouchPointConfiguration/Edit", "post", { "erpTaskSchedulerViewModel": erpTaskSchedulerViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteView = function (itemViewId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/DeleteView", "get", { "itemViewId": itemViewId }, callbackMethod, "json");
    };
    Endpoint.prototype.GiftCardList = function (isExcludeExpired, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/List", "get", { "isExcludeExpired": isExcludeExpired }, callbackMethod, "html");
    };
    Endpoint.prototype.GetView = function (itemViewId, viewName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/XMLGenerator/GetView", "get", { "itemViewId": itemViewId, "viewName": viewName }, callbackMethod, "json");
    };
    Endpoint.prototype.ProcessPayPalPayment = function (paymentmodel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/ProcessPayPalPayment", "post", { "paymentmodel": paymentmodel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IssueGiftCard = function (requestModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAManager/IssueGiftCard", "post", { "requestModel": requestModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteTableRowData = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/DeleteTableRowData", "get", { "areaMappingId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetExportData = function (dynamicReportType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/GetExportData", "get", { "dynamicReportType": dynamicReportType }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAllFamilies = function (isCategory, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/GetAllFamilies", "get", { "isCategory": isCategory }, callbackMethod, "json");
    };
    Endpoint.prototype.GetEditorFormats = function (currentPortalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/DynamicContent/GetEditorFormats", "get", { "portalId": currentPortalId }, callbackMethod, "", false);
    };
    Endpoint.prototype.GetOperators = function (reportType, filterName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/GetOperators", "get", {
            "reportType": reportType, "filterName": filterName
        }, callbackMethod, "json");
    };
    Endpoint.prototype.ActivateDeactivateProducts = function (productIds, isActive, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/ActivateDeactivateProducts", "get", { "productIds": productIds, "isActive": isActive }, callbackMethod, "json");
    };
    Endpoint.prototype.HighlightProductList = function (localeId, highlightId, highlightCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Highlight/HighlightProductList", "get", { "localeId": localeId, "highlightId": highlightId, "highlightCode": highlightCode }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatedBrandProductList = function (brandId, brandCode, brandName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Brand/AssociatedProductList", "get", { "brandId": brandId, "localeId": localeId, "brandCode": brandCode, "brandName": brandName }, callbackMethod, "html");
    };
    Endpoint.prototype.ActiveInactiveBrand = function (brandIds, isActive, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Brand/ActiveInactiveBrand", "get", { "brandIds": brandIds, "isActive": isActive }, callBackMethod, "json");
    };
    Endpoint.prototype.SetCustomerDefaultProfile = function (userId, profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/SetDefaultProfile", "get", { "userId": userId, "profileId": profileId }, callbackMethod, "html");
    };
    Endpoint.prototype.SetAccountDefaultProfile = function (accountId, accountProfileId, profileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/SetDefaultProfile", "get", { "accountId": accountId, "accountProfileId": accountProfileId, "profileId": profileId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsMediaAttributeDefaultValueCodeExist = function (attributeId, attributeDefaultValueCode, defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaManager/Attributes/IsAttributeDefaultValueCodeExist", "get", { "attributeId": attributeId, "attributeDefaultValueCode": attributeDefaultValueCode, "defaultValueId": defaultvalueId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetDashboardSales = function (portalIds, durationId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/DashboardSaleReport", "get", { "portalIds": portalIds, "durationId": durationId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDashboardOrders = function (portalIds, durationId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/DashboardOrderReport", "get", { "portalIds": portalIds, "durationId": durationId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDashboardRevenue = function (portalIds, durationId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/DashboardRevenueReport", "get", { "portalIds": portalIds, "durationId": durationId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDashboardTopResult = function (portalIds, durationId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/DashboardTopReport", "get", { "portalIds": portalIds, "durationId": durationId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetDashboardLowProductInventory = function (portalIds, durationId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/DashboardLowProductInventoryReport", "get", { "portalIds": portalIds, "durationId": durationId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsSliderNameExist = function (name, cmsSliderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/IsSliderNameExist", "get", {
            "name": name, "cmsSliderId": cmsSliderId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsContentPageNameExist = function (name, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/IsContentPageNameExistForPortal", "get", {
            "name": name,
            "portalId": portalId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsFileNameExist = function (name, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProductFeed/IsFileNameExist", "get", {
            "name": name,
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsThemeNameExist = function (name, cmsThemeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Theme/IsThemeNameExist", "get", {
            "name": name, "cmsThemeId": cmsThemeId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsCatalogNameExist = function (catalogName, pimCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Catalog/IsCatalogNameExist", "post", { "CatalogName": catalogName, "PimCatalogId": pimCatalogId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.EditCatalog = function (pimCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/EditCatalog", "get", { "PimCatalogId": pimCatalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsRuleNameExist = function (ruleName, publishCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/IsRuleNameExist", "post", { "ruleName": ruleName, "publishCatalogId": publishCatalogId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsShippingNameExist = function (shippingName, shippingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Shippings/IsShippingNameExist", "post", { "ShippingName": shippingName, "shippingId": shippingId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsPaymentCodeExist = function (paymentCode, paymentSettingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Payment/IsPaymentCodeExist", "post", { "paymentCode": paymentCode, "paymentSettingId": paymentSettingId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsPromotionCodeExist = function (promotionCode, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/IsPromotionNameExist", "post", { "PromoCode": promotionCode, "promotionId": promotionId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsRoleNameExist = function (name, id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RoleAndAccessRight/IsRoleNameExist", "post", { "Name": name, "id": id }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsUserIdForGiftCardExist = function (userId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/IsUserIdExist", "post", { "UserId": userId, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsSeoNameExist = function (seoUrl, cmsContentPagesId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/IsSeoNameExist", "post", {
            "SEOUrl": seoUrl, "CMSContentPagesId": cmsContentPagesId, "PortalId": portalId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsBannerNameExist = function (title, cmsSliderBannerId, cmsSliderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/IsBannerNameExist", "post", {
            "Title": title, "CMSSliderBannerId": cmsSliderBannerId, "CMSSliderId": cmsSliderId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsDomainNameExist = function (DomainName, DomainId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/IsDomainNameExist", "post", {
            "DomainName": DomainName, "DomainId": DomainId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsAccountPermissionExist = function (accountPermissionName, accountId, accountPermissionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/IsAccountPermissionExist", "post", {
            "AccountPermissionName": accountPermissionName, "AccountId": accountId, "AccountPermissionId": accountPermissionId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsMediaAttributeGroupCodeExist = function (groupCode, mediaAttributeGroupId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/AttributeGroup/IsGroupCodeExist", "post", {
            "groupCode": groupCode, "mediaAttributeGroupId": mediaAttributeGroupId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsAttributeFamilyCodeExist = function (familyCode, isCategory, PimAttributeFamilyId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProductAttributeFamily/IsFamilyCodeExist", "post", {
            "FamilyCode": familyCode, "IsCategory": isCategory, "PimAttributeFamilyId": PimAttributeFamilyId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsAttributeGroupCodeExist = function (groupCode, isCategory, pimAttributeGroupId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProductAttributeGroup/IsGroupCodeExist", "post", {
            "GroupCode": groupCode, "IsCategory": isCategory, "PimAttributeGroupId": pimAttributeGroupId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsBrandSEOFriendlyPageNameExist = function (seoFriendlyPageName, seoDetailsId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Brand/IsBrandSEOFriendlyPageNameExist", "post", { "seoFriendlyPageName": seoFriendlyPageName, "seoDetailsId": seoDetailsId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.MoveContentPagesFolder = function (addtoFolderId, folderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/MoveContentPagesFolder", "get", { "addtoFolderId": addtoFolderId, "folderId": folderId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPublishProduct = function (publishProductId, localeId, portalId, userId, catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetPublishProduct", "get", { "publishProductId": publishProductId, "localeId": localeId, "portalId": portalId, "userId": userId, "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.AddProductToCart = function (orderId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/AddProductToCart", "get", { "cartItems": true, "orderId": orderId, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.SyncMedia = function (folderName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaConfiguration/SyncMedia", "post", { "folderName": folderName }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateDisplayOrder = function (pimCatalogId, pimCategoryId, displayOrder, pimCategoryHierarchyId, isDown, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Catalog/UpdateDisplayOrder", "get", { "pimCatalogId": pimCatalogId, "pimCategoryId": pimCategoryId, "displayOrder": displayOrder, "pimCategoryHierarchyId": pimCategoryHierarchyId, "isDown": isDown }, callbackMethod, "json", false);
    };
    Endpoint.prototype.CaptureVoidPayment = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateTaxClassListToStore = function (taxClassIds, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociateTaxClass", "get", { "taxClassIds": taxClassIds, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.StoreAssociatedTaxClassList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/TaxList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.UnAssociateTaxClass = function (taxClassIds, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/UnAssociateTaxClass", "get", { "taxClassId": taxClassIds, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateBrandsToPortal = function (brandIds, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociatePortalBrand", "get", { "brandIds": brandIds, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetStoreAssociatedBrandList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/BrandList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.UnAssociateBrandsFromPortal = function (brandIds, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/UnAssociatePortalBrand", "get", { "brandId": brandIds, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.SetPortalDefaultTax = function (taxClassIds, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/SetPortalDefaultTax", "get", { "taxClassId": taxClassIds, "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociatePaymentSetting = function (paymentSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociatePaymentSetting", "get", { "paymentSettingId": paymentSettingId, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociateOfflinePaymentSetting = function (paymentSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociateOfflinePaymentSetting", "get", { "paymentSettingId": paymentSettingId, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociateSortSetting = function (sortSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociateSortSetting", "get", { "sortSettingId": sortSettingId, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociatePageSetting = function (pageSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/AssociatePageSetting", "get", { "pageSettingId": pageSettingId, "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAssociatedPaymentList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedPaymentList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedInvoiceManagementPaymentList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedInvoiceManagementPaymentList", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedSortList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedSortForStore", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetAssociatedPageList = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetAssociatedPageForStore", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.RemoveAssociatedSortSetting = function (portalSortSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/RemoveAssociatedSortSetting", "get", { "portalSortSettingId": portalSortSettingId, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveAssociatedPageSetting = function (portalPageSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/RemoveAssociatedPageSetting", "get", { "portalPageSettingId": portalPageSettingId, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.RemoveAssociatedPaymentSetting = function (paymentSettingId, portalId, isUsedForOfflinePayment, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/RemoveAssociatedPaymentSetting", "get", { "paymentSettingId": paymentSettingId, "portalId": portalId, "isUsedForOfflinePayment": isUsedForOfflinePayment }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociatePaymentSettingForProfiles = function (paymentSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/AssociatePaymentSetting", "get", { "paymentSettingId": paymentSettingId, "profileId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAssociatedPaymentListForProfiles = function (profileId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/GetAssociatedPaymentList", "get", { "profileId": profileId, "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.RemoveAssociatedPaymentSettingForProfiles = function (paymentSettingId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Profiles/RemoveAssociatedPaymentSetting", "get", { "paymentSettingId": paymentSettingId, "profileId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetImportInventoryView = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/ImportInventoryView", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.ImportPost = function (importModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/Index", "post", { "importModel": importModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPricingList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/GetPricingList", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetImportCatalogList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/GetCatalogList", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetImportPortalList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/GetPortalList", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetLocalServerURL = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaConfiguration/GetLocalServerURL", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetNetworkDriveURL = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MediaConfiguration/GetNetworkDriveURL", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteImportLogs = function (importProcessLogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/DeleteLogs", "get", { "importProcessLogId": importProcessLogId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetColumnList = function (reportId, dynamicReportType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/GetColumnList", "get", { "reportId": reportId, "dynamicReportType": dynamicReportType }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteDynamicReport = function (customReportTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/DeleteReport", "get", { "customReportTemplateId": customReportTemplateId }, callbackMethod, "json");
    };
    Endpoint.prototype.CheckCouponCodeExist = function (couponCode, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/CheckCouponCodeExist", "post", { "couponCode": couponCode, "promotionId": promotionId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.SetCollapseMenuStatus = function (status, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/SetCollapseMenuStatus", "get", { "status": status }, callbackMethod, "json");
    };
    Endpoint.prototype.SaveCustomReport = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/DynamicReport", "post", { "model": model }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetShippingOptions = function (userId, excludeCustomShippingFromCreateOrder, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetShippingOptionsListWithRates", "get", { "userId": userId, "excludeCustomShippingFromCreateOrder": excludeCustomShippingFromCreateOrder, "isQuote": isQuote }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.GetShippingOptionsForManage = function (orderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetShippingOptionsListForManage", "get", { "orderId": orderId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetReportView = function (reportType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/MyReports/GetReportView", "get", { "reportType": reportType }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetImportCountryList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Import/GetCountryList", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.showDiagnosticsTrace = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Trace.axd?id=0", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateAttributeGroupDisplayOrder = function (pimAttributeGroupId, displayOrder, pimAttributeFamilyId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/ProductAttributeFamily/UpdateAttributeGroupDisplayOrder", "post", { "pimAttributeGRoupId": pimAttributeGroupId, "pimAttributeFamilyId": pimAttributeFamilyId, "displayOrder": displayOrder }, callbackMethod, "json");
    };
    Endpoint.prototype.QuickOrderAddToCart = function (cartItemModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/AddToCart", "post", { "cartItem": cartItemModel }, callbackMethod, "html");
    };
    Endpoint.prototype.MovePage = function (folderId, pageIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/MovePageToFolder", "get", { "folderId": folderId, "pageIds": pageIds }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateOrderPaymentStatus = function (omsOrderId, paymentStatus, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateOrderPaymentStatus", "get", { "omsOrderId": omsOrderId, "paymentStatus": paymentStatus }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateTrackingNumber = function (omsOrderId, TrackingNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateTrackingNumber", "get", { "omsOrderId": omsOrderId, "trackingnumber": TrackingNumber }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateColumnShipping = function (OmsOrderId, ColumnShipping, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateColumnShipping", "get", { "OmsOrderId": OmsOrderId, "shipping": ColumnShipping }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateCSRDiscountAmount = function (OmsOrderId, CSRDiscountAmount, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateCSRDiscountAmount", "get", { "OmsOrderId": OmsOrderId, "CSRDiscountAmount": CSRDiscountAmount }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateTaxCost = function (OmsOrderId, TaxCost, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateTaxCost", "get", { "OmsOrderId": OmsOrderId, "taxCost": TaxCost }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateShippingType = function (OmsOrderId, ShippingType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateShippingType", "get", { "OmsOrderId": OmsOrderId, "shippingType": ShippingType }, callbackMethod, "json");
    };
    Endpoint.prototype.GetOrderInformation = function (orderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetOrderInformation", "get", { "orderId": orderId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCustomerInformation = function (orderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetCustomerInformation", "get", { "orderId": orderId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetOrderLineItems = function (orderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetOrderLineItems", "get", { "orderId": orderId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetReturnLineItems = function (orderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetReturnLineItems", "get", { "orderId": orderId }, callbackMethod, "html");
    };
    Endpoint.prototype.CheckTemplateName = function (fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Template/TemplateName", "post", { "templateName": fileName }, callbackMethod, "json");
    };
    Endpoint.prototype.ShippingSelectHandler = function (userId, shippingId, orderId, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/CalculateShippingInManage", "post", { "userId": userId, "shippingId": shippingId, "omsOrderId": orderId }, callBackMethod, "json");
    };
    Endpoint.prototype.UpdateCartItem = function (_orderLineItemDetail, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateCartItem", "post", { "orderDataModel": _orderLineItemDetail }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateManageOrder = function (orderId, additionalNotes, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateOrder", "post", { "orderId": orderId, "additionalNote": additionalNotes }, callbackMethod, "json");
    };
    Endpoint.prototype.SubmitEditOrderpayment = function (submitPaymentViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/SubmitEditOrderpayment", "post", { "submitPaymentViewModel": submitPaymentViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateAddonGroupProducts = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/AddonGroup/AssociateAddonGroupProducts", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAddonGroupProducts = function (addonGroupProductIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/AddonGroup/DeleteAddonGroupProducts", "get", { "addonGroupProductId": addonGroupProductIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedAddonProducts = function (addonGroupId, addonGroupName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/AddonGroup/GetAssociatedProducts", "get", { "addonGroupId": addonGroupId, "addonGroupName": addonGroupName, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.PrintOnManage = function (omsOrderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/PrintOnManage", "get", { "omsOrderId": omsOrderId }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateForTaxExempt = function (omsOrderId, orderTextValue, pageName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateOrderText", "get", { "omsOrderId": omsOrderId, "orderTextValue": orderTextValue, "pageName": pageName }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateTaxExemptOnCreateOrder = function (userId, orderTextValue, pageName, isTaxExempt, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateTaxExemptOnCreateOrder", "get", {
            "userId": userId, "orderTextValue": orderTextValue, "pageName": pageName, "isTaxExempt": isTaxExempt, "isQuote": isQuote
        }, callbackMethod, "html", true, false);
    };
    Endpoint.prototype.GetReasonsForReturn = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetReasonsForReturn", "get", {}, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetShippingList = function (omsOrderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetShippingPanel", "get", { "omsOrderId": omsOrderId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetOrderStateValueById = function (omsOrderStateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetOrderStateValueById", "get", { "omsOrderStateId": omsOrderStateId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsUserNameExist = function (userName, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/IsUserNameExists", "get", {
            "userName": userName, "portalId": $("#PortalId").val(),
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsAccountNameExist = function (accountName, accountId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/IsAccountNameExists", "get", {
            "accountName": accountName, "accountId": accountId, "portalId": portalId
        }, callbackMethod, "json", false);
    };
    Endpoint.prototype.SendReturnedOrderEmail = function (omsOrderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/SendReturnedOrderEmail", "get", { "omsOrderId": omsOrderId }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishCatalog = function (pimCatalogId, revisionType, publishContent, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Catalog/Publish", "get", { "pimCatalogId": pimCatalogId, "revisionType": revisionType, "publishContent": publishContent }, callbackMethod, "json");
    };
    Endpoint.prototype.PreviewCatalog = function (pimCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Catalog/Preview", "get", { "pimCatalogId": pimCatalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishStoreSetting = function (portalId, targetPublishState, publishContent, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/PublishStoreSetting", "get", { "portalId": portalId, "targetPublishState": targetPublishState, "publishContent": publishContent }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishStoreCMSContent = function (portalId, targetPublishState, publishContent, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/StoreExperience/PublishStoreCMSContent", "get", { "portalId": portalId, "targetPublishState": targetPublishState, "publishContent": publishContent }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishProduct = function (pimProductId, revisionType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/PublishProduct", "get", { "pimProductId": pimProductId, "revisionType": revisionType }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishMessage = function (cmsMessageKeyId, portalId, targetPublishState, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Content/PublishManageMessageWithPreview", "get", {
            "cmsMessageKeyId": cmsMessageKeyId, "portalId": portalId, "localeId": localeId, "targetPublishState": targetPublishState, "takeFromDraftFirst": true
        }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishSeo = function (seoCode, portalId, localeId, seoTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Seo/Publish", "get", { "seoCode": seoCode, "portalId": portalId, "localeId": localeId, "seoTypeId": seoTypeId }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishSeoWithPreview = function (seoCode, portalId, localeId, seoTypeId, targetPublishState, takeFromDraftFirst, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Seo/Publishwithpreview", "get", { "seoCode": seoCode, "portalId": portalId, "localeId": localeId, "seoTypeId": seoTypeId, "targetPublishState": targetPublishState, "takeFromDraftFirst": takeFromDraftFirst }, callbackMethod, "json");
    };
    Endpoint.prototype.AssignTouchPointToActiveERP = function (touchPointNames, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TouchPointConfiguration/AssignTouchPointToActiveERP", "get", { "touchPointNames": touchPointNames }, callbackMethod, "json");
    };
    Endpoint.prototype.AssignedTouchPointList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TouchPointConfiguration/List", "get", {}, callbackMethod, "html");
    };
    Endpoint.prototype.ShowTaskSchedularLogDetails = function (schedulerName, recordId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/TouchPointConfiguration/SchedulerLogDetails", "get", {
            "schedulerName": schedulerName, "recordId": recordId
        }, callbackMethod, "html");
    };
    Endpoint.prototype.CreateCatalogSchedular = function (connectorTouchPoints, schedulerCallFor, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/CreateScheduler", "get", {
            "connectorTouchPoints": connectorTouchPoints, "schedulerCallFor": schedulerCallFor
        }, callbackMethod, "html");
    };
    Endpoint.prototype.ResendOrderConfirmationForCartItem = function (orderId, cartLineItemId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/ResendOrderLineItemConfirmMail", "get", { "omsOrderId": orderId, "orderLineItemId": cartLineItemId }, callbackMethod, "html");
    };
    Endpoint.prototype.AssociateShippingToPromotion = function (associatedShippingIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/AssociateShippingToPromotion", "get", { "associatedShippingIds": associatedShippingIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedShippings = function (storeId, shippingIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/GetAssociatedShippings", "get", { "storeId": storeId, "assignedIds": shippingIds, "promotionId": promotionId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteAssociatedPromotionShippings = function (associatedShippingIds, promotionId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Promotion/UnAssociateShippings", "get", { "ShippingId": associatedShippingIds, "promotionId": promotionId }, callbackMethod, "json");
    };
    Endpoint.prototype.GenerateProductFeed = function (url, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetBlogNews = function (blogNewsId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/EditBlogNews", "get", { "blogNewsId": blogNewsId, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteBlogNews = function (blogNewsId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/DeleteBlogNews", "get", { "BlogNewsId": blogNewsId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteBlogNewsComment = function (blogNewsCommentId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/DeleteBlogNewsComment", "get", { "BlogNewsCommentId": blogNewsCommentId }, callbackMethod, "json");
    };
    Endpoint.prototype.ActivateDeactivateBlogNews = function (blogNewsIds, isTrueOrFalse, activity, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/ActivateDeactivateBlogNews", "get", { "blogNewsIds": blogNewsIds, "isTrueOrFalse": isTrueOrFalse, "activity": activity }, callBackMethod, "json");
    };
    Endpoint.prototype.ApproveDisapproveBlogNewsComment = function (blogNewsCommentIds, isApproved, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/ApproveDisapproveBlogNewsComment", "get", { "blogNewsCommentIds": blogNewsCommentIds, "isApproved": isApproved }, callBackMethod, "json");
    };
    Endpoint.prototype.UpdateReturnShippingHistory = function (lineItemId, omsOrderId, isInsert, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/UpdateReturnShippingHistory", "post", {
            "lineItemId": lineItemId, "omsOrderId": omsOrderId, "isInsert": isInsert
        }, callBackMethod, "json");
    };
    //SaveReturnShippingHistory(_orderLineItemDetail: Znode.Core.OrderLineItemModel, callbackMethod) {
    //    super.ajaxRequest("/Order/SaveReturnShippingHistory", "post", { "orderDataModel": _orderLineItemDetail }, callbackMethod, "json");
    //}
    Endpoint.prototype.GetSynonymsList = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetSearchSynonymsList", "get", { "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetKeywordsRedirectList = function (catalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/GetCatalogKeywordsList", "get", { "catalogId": catalogId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteSearchSynonyms = function (searchSynonymsId, publishCataLogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/DeleteSearchSynonyms", "get", { "SearchSynonymsId": searchSynonymsId, "publishCataLogId": publishCataLogId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteKeywords = function (searchKeywordsRedirectId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/DeleteSearchKeywordsRedirect", "get", { "searchKeywordsRedirectId": searchKeywordsRedirectId }, callbackMethod, "json");
    };
    Endpoint.prototype.AddKeywords = function (searchKeywordsViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/CreateSearchKeywordsRedirect", "post", { "searchKeywordsRedirectViewModel": searchKeywordsViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.EditKeywords = function (searchKeywordsViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/EditSearchKeywordsRedirect", "post", { "searchKeywordsRedirectViewModel": searchKeywordsViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteIndex = function (catalogIndexId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/DeleteIndex", "get", { "catalogIndexId": catalogIndexId }, callbackMethod, "json");
    };
    Endpoint.prototype.WriteSynonymsFile = function (publishCataLogId, isSynonymsFile, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SearchConfiguration/WriteSearchFile", "get", { "publishCataLogId": publishCataLogId, "isSynonymsFile": isSynonymsFile }, callbackMethod, "json");
    };
    Endpoint.prototype.PrintOnPackageSlip = function (omsOrderId, OmsOrderLineItemsId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/PrintPackagingSlip", "get", { "omsOrderId": omsOrderId, "OmsOrderLineItemsId": OmsOrderLineItemsId }, callbackMethod, "html");
    };
    Endpoint.prototype.SendPoEmail = function (receiverEmail, omsOrderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/SendPOEmail", "get", { "receiverEmail": receiverEmail, "omsOrderId": omsOrderId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetUnAssigedAttributes = function (attributeGroupId, attributeFamilyId, contollerName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/" + contollerName + "/GetUnAssignedAttributes", "post", { "attributeFamilyId": attributeFamilyId, "attributeGroupId": attributeGroupId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsGlobalAttributeCodeExist = function (attributeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/IsAttributeCodeExist", "get", { "attributeCode": attributeCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteGlobalAttribute = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/Delete", "get", { "globalAttributeId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.SaveGlobalAttributeDefaultValues = function (url, data, attributeId, defaultvaluecode, defaultvalueId, displayOrder, isDefault, isSwatch, swatch, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", {
            "model": JSON.stringify(data), "attributeId": attributeId, "defaultvalueId": defaultvalueId, "defaultvaluecode": defaultvaluecode, "displayOrder": displayOrder, "isdefault": isDefault, "isswatch": isSwatch, "swatchtext": swatch
        }, callbackMethod, "json");
    };
    Endpoint.prototype.IsGlobalAttributeDefaultValueCodeExist = function (attributeId, attributeDefaultValueCode, defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/IsAttributeDefaultValueCodeExist", "get", { "attributeId": attributeId, "attributeDefaultValueCode": attributeDefaultValueCode, "defaultValueId": defaultvalueId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteGlobalAttributeDefaultValues = function (defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/DeleteDefaultValues", "get", { "defaultvalueId": defaultvalueId }, callbackMethod, "json");
    };
    Endpoint.prototype.IsGlobalAttributeGroupCodeExist = function (groupCode, globalAttributeGroupId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeGroup/IsGroupCodeExist", "post", { "GroupCode": groupCode, "globalAttributeGroupId": globalAttributeGroupId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteGlobalAttributeGroup = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeGroup/Delete", "get", { "globalAttributeGroupId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateGlobalAttributeGroupDisplayOrder = function (globalAttributeGroupId, displayOrder, globalAttributeEntityId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/UpdateAttributeGroupDisplayOrder", "post", { "globalAttributeGroupId": globalAttributeGroupId, "globalAttributeEntityId": globalAttributeEntityId, "displayOrder": displayOrder }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedGlobalAttributes = function (attributeId, SuccessCallBack) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/AssignedGlobalAttributes", "GET", { "attributeGroupId": attributeId }, SuccessCallBack, "html");
    };
    Endpoint.prototype.UnAssignGlobalAttributeGroup = function (globalattributeGroupId, entityId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/UnAssignAttributeGroups", "get", { "groupId": globalattributeGroupId, "entityId": entityId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteDownloadablePrductKey = function (pimDownloadableProductKeyId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/DeleteDownloadableProductKeys", "get", { "PimDownloadableProductKeyId": pimDownloadableProductKeyId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetTabStructure = function (entityId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/GetTabStructure", "get", { "globalEntityId": entityId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsGlobalAttributeValueUnique = function (attributeCodeValues, id, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/IsGlobalAttributeValueUnique", "get", { "AttributeCodeValues": attributeCodeValues, "Id": id, "EntityType": entityType }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociatePortalToProfile = function (searchProfileId, portalIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/AssociatePortalToSearchProfile", "post", { "searchProfileId": searchProfileId, "portalIds": portalIds }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishSearchProfile = function (searchProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/PublishSearchProfile", "get", { "searchProfileId": searchProfileId }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociatePortalToSearchProfile = function (searchProfileId, portalSearchProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/UnAssociatePortalToSearchProfile", "post", { "portalSearchProfileId": portalSearchProfileId, "searchProfileId": searchProfileId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateSearchAttributesToProfile = function (searchProfileId, attributeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/AssociateAttributesToProfile", "post", { "searchProfileId": searchProfileId, "attributeCode": attributeCode }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssociateSearchAttributesFromProfile = function (searchProfilesAttributeMappingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/UnAssociateAttributesFromProfile", "post", { "searchProfileAttributeMappingId": searchProfilesAttributeMappingId }, callbackMethod, "json");
    };
    Endpoint.prototype.SetFeatureByQueyId = function (queryId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetFeaturesByQueryId", "get", { "queryId": queryId }, callbackMethod, "html");
    };
    Endpoint.prototype.DeleteFormBuilder = function (formBuilderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/Delete", "get", { "formBuilderId": formBuilderId }, callbackMethod, "json");
    };
    Endpoint.prototype.IsFormCodeExist = function (formCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/IsFormCodeExist", "get", { "formCode": formCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.UpdateAttributeDisplayOrder = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/UpdateAttributeDisplayOrder", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateGroupDisplayOrder = function (model, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/UpdateGroupDisplayOrder", "post", { "model": model }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssignAttribute = function (formBuilderId, attributeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/UnAssignAttribute", "get", { "formBuilderId": formBuilderId, "attributeId": attributeId }, callbackMethod, "json");
    };
    Endpoint.prototype.ManageSearchWidgetConfiguration = function (mappingId, widgetId, widgetKey, mappingType, displayName, widgetName, fileName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/ManageSearchWidgetConfiguration", "get", { "mappingId": mappingId, "widgetId": widgetId, "widgetKey": widgetKey, "mappingType": mappingType, "displayName": displayName, "widgetName": widgetName, "fileName": fileName, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.UnAssignGroup = function (formBuilderId, groupId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/UnAssignGroup", "get", { "formBuilderId": formBuilderId, "groupId": groupId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetFormBuilderAttributeGroup = function (formBuilderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/FormBuilder/AssignedAttributeGroupList", "get", { "id": formBuilderId }, callbackMethod, "html");
    };
    Endpoint.prototype.ManageFormWidgetConfiguration = function (mappingId, widgetId, widgetKey, mappingType, displayName, widgetName, fileName, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/ManageFormWidgetConfiguration", "get", { "mappingId": mappingId, "widgetId": widgetId, "widgetKey": widgetKey, "mappingType": mappingType, "displayName": displayName, "widgetName": widgetName, "fileName": fileName, "localeId": localeId }, callbackMethod, "html");
    };
    Endpoint.prototype.IsShowChangePasswordPopup = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/IsShowChangePasswordPopup", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.SaveInCookie = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/SaveInCookie", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.ProductUpdateImportPost = function (importModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UpdateProducts", "post", { "importModel": importModel }, callbackMethod, "json");
    };
    Endpoint.prototype.DownloadProductUpdateTemplate = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/DownloadProductTemplate", "post", {}, callbackMethod, "json");
    };
    Endpoint.prototype.AddCustomShippingAmount = function (customShippingCost, estimateShippingCost, userId, isQuote, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/AddCustomShippingAmount", "post", {
            "customShippingCost": customShippingCost, "estimateShippingCost": estimateShippingCost, "userId": userId, "isQuote": isQuote
        }, callBackMethod, "json", false);
    };
    Endpoint.prototype.GetStates = function (countryCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/GetStates", "get", { "countryCode": countryCode }, callbackMethod, "json");
    };
    Endpoint.prototype.CheckCodeExists = function (url, code, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "codeField": code }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetInventoryDetailBySKU = function (sku, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Inventory/GetInventoryDetail", "get", { "sku": sku }, callbackMethod, "json");
    };
    Endpoint.prototype.CheckUniqueBrandCode = function (code, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Brand/CheckUniqueBrandCode", "get", { "code": code }, callbackMethod, "json");
    };
    Endpoint.prototype.GetBrandName = function (code, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Brand/GetBrandName", "get", {
            "code": code, "localeid": localeId
        }, callbackMethod, "json");
    };
    Endpoint.prototype.GetFieldValueList = function (publishCatalogId, searchProfileId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetfieldValuesList", "get", { "publishCatalogId": publishCatalogId, "searchProfileId": searchProfileId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetSearchRulesByCatalogId = function (publishCatalogId, catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetBoostAndBuryRules", "get", { "catalogId": publishCatalogId, "catalogName": catalogName }, callbackMethod, "html");
    };
    Endpoint.prototype.PauseCatalogSearchRule = function (searchCatalogRuleId, isPause, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/PauseCatalogSearchRule", "get", { "searchCatalogRuleId": searchCatalogRuleId, "isPause": isPause }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteCatalogSearchRule = function (ruleId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/DeleteCatalogSearchRule", "get", { "searchCatalogRuleId": ruleId }, callbackMethod, "json");
    };
    Endpoint.prototype.IsStoreCodeExist = function (storeCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/IsStoreCodeExist", "get", { "storeCode": storeCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAutoSuggestion = function (query, fieldName, publishCatalogId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/Search/GetAutoSuggestion", "get", { "query": query, "fieldName": fieldName, "publishCatalogId": publishCatalogId }, callbackMethod, "json");
    };
    Endpoint.prototype.EnableDisablePublishStateMapping = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GeneralSetting/EnableDisablePublishStateMapping", "put", { "publishStateMappingId": id, "isEnabled": isEnable }, callbackMethod, "json");
    };
    Endpoint.prototype.GetAssociatedCatalog = function (pimProductId, callback) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/GetAssociatedCatalog", "get", { pimProductId: pimProductId }, callback, "json");
    };
    Endpoint.prototype.DashboardLowInventoryProductCountOnSelectedPortal = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Dashboard/GetDashboardLowInventoryProductCount", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.TestEmail = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/TestEmail", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetLevelList = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetLevelList", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAreaMapping = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/DeleteApproverLevel", "delete", { "userApproverId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetApprovalList = function (portalId, selectedApprovalType, selectedApprovalTypeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetApprovalList", "get", {
            "portalId": portalId, "selectedApprovalType": selectedApprovalType, "selectedApprovalTypeId": selectedApprovalTypeId
        }, callbackMethod, "json");
    };
    Endpoint.prototype.GetApproverUsersByName = function (searchTerm, portalId, accountId, approvalUserIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetApproverUsersByName", "get", { "searchTerm": searchTerm, "portalId": portalId, "accountId": accountId, "approvalUserIds": approvalUserIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetApproverLevelList = function (userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/GetApproverLevelList", "get", { "userId": userId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetApproverUsersByPortalId = function (searchTerm, portalId, approvalUserIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetApproverUsersByPortalId", "get", { "searchTerm": searchTerm, "portalId": portalId, "approvalUserIds": approvalUserIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPortalApproverDetails = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetPortalApproverDetailsById", "get", { "portalId": portalId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.UpdateBillingAccountNumber = function (userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/UpdateBillingNumber", "get", { "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.SaveReportLayout = function (reportName, reportCode, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/DevExpressReport/SaveReportLayout", "post", { "reportName": reportName, "reportCode": reportCode }, callBackMethod, "json", false);
    };
    Endpoint.prototype.LoadSavedReportLayout = function (reportName, reportCode, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/DevExpressReport/LoadSavedReportLayout", "post", { "reportName": reportName, "reportCode": reportCode }, callBackMethod, "json", false);
    };
    Endpoint.prototype.fnLoadReportcomponents = function (reportName, reportCode, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/DevExpressReport/LoadSavedReportLayout", "post", { "reportName": reportName, "reportCode": reportCode }, callBackMethod, "json", false);
    };
    Endpoint.prototype.fnDeleteSavedReportLayout = function (reportviewid, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/DevExpressReport/DeleteSavedReportLayout", "post", { "reportviewid": reportviewid }, callBackMethod, "json", false);
    };
    Endpoint.prototype.GetPortalList = function (type, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Typeahead/GetSuggestions", "get", { "type": type }, callBackMethod, "json", false);
    };
    Endpoint.prototype.UpdateProductDisplayOrder = function (catalogAssociation, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/UpdateProductDisplayOrder", "post", { "catalogAssociationViewModel": catalogAssociation }, callbackMethod, "json");
    };
    Endpoint.prototype.GetApproverOrder = function (portalApprovalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetApproverOrder", "get", { "portalApprovalId": portalApprovalId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeletePortalAreaMapping = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/DeletePortalApproverUser", "delete", { "userApproverId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPaymentApproverOrder = function (portalId, count, paymentIds, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetPaymentApproverOrder", "get", { "portalId": portalId, "paymentdivcount": count, "paymentIds": paymentIds }, callbackMethod, "json");
    };
    Endpoint.prototype.GenerateOrderNumber = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GenerateOrderNumber", Constant.GET, { "portalId": portalId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsUserNameAnExistingShopper = function (userName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/User/IsUserNameAnExistingShopper", Constant.GET, { "userName": userName }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsUserNameExists = function (userName, portalId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/IsUserNameExists", "get", {
            "userName": userName, "portalId": $("#PortalId").val(), "userId": userId,
        }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUserList = function (portalId, portalName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/CustomersList", "get", { "portalId": portalId, "portalName": portalName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetProductList = function (pimCatalogId, catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/List", "get", { "pimCatalogId": pimCatalogId, "catalogName": catalogName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetOrderList = function (userId, accountId, portalId, portalName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/List", "get", { "userId": userId, "accountId": accountId, "portalId": portalId, "portalName": portalName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetCategoryList = function (pimCatalogId, catalogName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Category/List", "get", { "pimCatalogId": pimCatalogId, "catalogName": catalogName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetImpersonateURL = function (portalId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/GetImpersonationUrl", "get", { "portalId": portalId, "userId": userId }, callbackMethod, "json");
    };
    Endpoint.prototype.EnableDisableSalesRepAccount = function (id, isEnable, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SalesRep/EnableDisableAccount", "get", { "userId": id, "isLock": isEnable }, callbackMethod, "html");
    };
    Endpoint.prototype.UserResetSalesRepPassword = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/SalesRep/BulkResetPassword", "get", { "userId": id }, callbackMethod, "html");
    };
    Endpoint.prototype.SetCustomerAddress = function (addressId, otherAddressId, addressType, isB2BCustomer, userId, portalId, accountId, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetAddressDetails", "get", { "userAddressId": addressId, "otherAddressId": otherAddressId, "addressType": addressType, "isB2BCustomer": isB2BCustomer, "userId": userId, "portalId": portalId, "accountId": accountId, "isQuote": isQuote }, callbackMethod, "json");
    };
    Endpoint.prototype.GetUsersByPhoneNoOrUserName = function (searchTerm, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetCustomerListBySearchTerm", "get", { "searchTerm": searchTerm, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.AssociateUsersWithAccount = function (userIds, accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/AssociateUsersWithAccount", "post", { "userIds": userIds, "accountId": accountId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAssociateUsers = function (accountId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/CustomersList", Constant.GET, { "accountId": accountId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetShoppingCart = function (userId, portalId, orderId, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetShoppingCartItems", "get", { "userId": userId, "portalId": portalId, "orderId": orderId, isQuote: isQuote }, callbackMethod, "json");
    };
    Endpoint.prototype.GetTopKeywordsReport = function (portalId, portalName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/SearchReport/GetTopKeywordsReport", "get", { "portalId": portalId, "portalName": portalName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetNoResultsFoundReport = function (portalId, portalName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Search/SearchReport/GetNoResultsFoundReport", "get", { "portalId": portalId, "portalName": portalName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.CalculateShoppingCart = function (userId, portalId, orderId, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/CalculateShoppingCart", "get", {
            "userId": userId, "portalId": portalId, "orderId": orderId, "isQuote": isQuote
        }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.GetPaymentMethods = function (portalId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetPaymentMethods", "get", { "portalId": portalId, "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCartCount = function (userId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetCartCount", "get", { "userId": userId, "portalId": portalId }, callbackMethod, "json");
    };
    Endpoint.prototype.GetCmsSearchConfiguration = function (portalId, storeName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CMSSearchConfiguration/CreateIndex", "get", { "portalId": portalId, "storeName": storeName }, callbackMethod, "html");
    };
    Endpoint.prototype.GetCmsSearchIndexMonitorList = function (cmsSearchIndexId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CMSSearchConfiguration/GetCmsPageSearchIndexMonitor", "get", { "cmsSearchIndexId": cmsSearchIndexId, "portalId": portalId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.AssociateCategoryToCatalog = function (categoryAssociationModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Catalog/AssociateCategoryToCatalog", "post", { "catalogAssociationViewModel": categoryAssociationModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetQuoteList = function (portalId, portalName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/QuoteList", "get", { "portalId": portalId, "portalName": portalName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetQuoteStateValueById = function (omsQuoteStateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/GetQuoteStateValueById", "get", { "omsQuoteStateId": omsQuoteStateId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetQuoteShippingList = function (omsQuoteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/GetQuoteShippingList", "get", { "omsQuoteId": omsQuoteId }, callbackMethod, "json");
    };
    Endpoint.prototype.CalculateShippingInManage = function (shippingId, omsQuoteId, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/CalculateShippingInManage", "post", { "shippingId": shippingId, "omsQuoteId": omsQuoteId }, callBackMethod, "json");
    };
    Endpoint.prototype.SubmitOrderReturn = function (returnNumber, notes, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/SubmitOrderReturn", "post", { "returnNumber": returnNumber, "notes": notes }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateOrderReturnLineItem = function (orderReturnLineItemModel, returnNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/UpdateOrderReturnLineItem", "post", { "orderReturnLineItemModel": orderReturnLineItemModel, "returnNumber": returnNumber }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetReturnList = function (portalId, portalName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/List", "get", { "portalId": portalId, "portalName": portalName }, callbackMethod, "html", true);
    };
    Endpoint.prototype.UpdateOrderReturnStatus = function (returnStatusCode, returnNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/UpdateOrderReturnStatus", "post", { "returnStatusCode": returnStatusCode, "returnNumber": returnNumber }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteQuoteCartItem = function (omsQuoteId, guid, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/RemoveQuoteCartItem", "post", { "omsQuoteId": omsQuoteId, "guid": guid }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.CalculateQuoteShoppingCart = function (omsQuoteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/CalculateShoppingCart", "get", { "omsQuoteId": omsQuoteId }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.IsPaymentDisplayNameExists = function (paymentDisplayName, paymentSettingId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Payment/IsPaymentDisplayNameExists", "post", { "paymentDisplayName": paymentDisplayName, "paymentSettingId": paymentSettingId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.UpdateQuoteCartItem = function (_quoteLineItemDetail, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/UpdateQuoteCartItem", "post", { "quoteDataModel": _quoteLineItemDetail }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateTaxExemptForQuote = function (omsQuoteId, isTaxExempt, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/UpdateTaxExemptForManage", "post", { "omsQuoteId": omsQuoteId, "isTaxExempt": isTaxExempt }, callbackMethod, "html");
    };
    Endpoint.prototype.PrintManangeQuote = function (omsQuoteId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/PrintManageQuote", "get", { "omsQuoteId": omsQuoteId }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateManageQuote = function (omsQuoteId, additionalNotes, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/UpdateQuote", "post", { "omsQuoteId": omsQuoteId, "additionalNote": additionalNotes }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateAccountManageQuote = function (omsQuoteId, AdditionalNotes, OmsOrderStateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Account/UpdateAccountQuote", "post", { "omsQuoteId": omsQuoteId, "AdditionalNotes": AdditionalNotes, "OmsOrderStateId": OmsOrderStateId }, callbackMethod, "html");
    };
    Endpoint.prototype.CreateQuoteRequest = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/CreateQuoteRequest", "get", { "portalId": portalId }, callbackMethod, "html");
    };
    Endpoint.prototype.PrintReturnReceipt = function (returnNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/PrintReturn", Constant.GET, { "returnNumber": returnNumber }, callbackMethod, "html", false);
    };
    Endpoint.prototype.ClearAllPublishedData = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Diagnostics/Maintenance/PurgeAllPublishedData", "delete", {}, callbackMethod, "json");
    };
    Endpoint.prototype.PublishBlogNewsPage = function (blogNewsId, targetPublishState, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/BlogNews/PublishBlogNewsPage", "post", { "blogNewsId": blogNewsId, "localeId": localeId, "targetPublishState": targetPublishState, "takeFromDraftFirst": true }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPaymentOptions = function (portalId, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/GetPaymentMethods", "get", { "portalId": portalId, "userId": userId }, callbackMethod, "html");
    };
    Endpoint.prototype.SaveAndConvertQuoteToOrder = function (_convertQuoteToOrderViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/SaveAndConvertQuoteToOrder", "post", { "convertToOrderViewModel": _convertQuoteToOrderViewModel }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateQuoteCartItemPrice = function (guid, unitPrice, productid, shippingid, isQuote, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Quote/UpdateQuoteCartItemPrice", "post", { "guid": guid, "unitPrice": unitPrice, "productId": productid, "shippingId": shippingid, "isQuote": isQuote, "userId": userId }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.ActivateDeactivateVouchers = function (voucherIds, isActive, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/ActivateDeactivateVouchers", "post", { "giftCardId": voucherIds, "isActive": isActive }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.GetVoucherHistoryList = function (voucherId, portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GiftCard/GetVoucherHistoryList", "get", { "voucherId": voucherId, "portalId": portalId }, callbackMethod, "html", true);
    };
    Endpoint.prototype.RemoveVoucher = function (url, voucher, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "voucher": voucher }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.ApplyVoucher = function (url, giftCard, userId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, url, "get", { "voucherNumber": giftCard, "userId": userId }, callbackMethod, "json", true, false);
    };
    Endpoint.prototype.GetAttributeList = function (entityId, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttribute/List", "get", { "entityId": entityId, "entityType": entityType }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetAttributeGroupList = function (entityId, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeGroup/List", "get", { "entityId": entityId, "entityType": entityType }, callbackMethod, "html", true);
    };
    Endpoint.prototype.GetAttributeFamilyList = function (entityId, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeFamily/List", "get", { "entityId": entityId, "entityType": entityType }, callbackMethod, "html", true);
    };
    Endpoint.prototype.DeleteGlobalAttributeFamily = function (id, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeFamily/Delete", "get", { "globalAttributeFamilyId": id }, callbackMethod, "json");
    };
    Endpoint.prototype.UpdateFamilyGroupDisplayOrder = function (groupCode, displayOrder, familyCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeFamily/UpdateAttributeGroupDisplayOrder", "post", { "groupCode": groupCode, "familyCode": familyCode, "displayOrder": displayOrder }, callbackMethod, "json");
    };
    Endpoint.prototype.UnAssignGlobalAttributeGroupFromFamily = function (groupCode, familyCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeFamily/UnassignAttributeGroups", "get", { "groupCode": groupCode, "familyCode": familyCode }, callbackMethod, "json");
    };
    Endpoint.prototype.GetTabStructureForAttributeFamily = function (familyCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeFamily/GetTabStructure", "get", { "familyCode": familyCode }, callbackMethod, "html");
    };
    Endpoint.prototype.IsGlobalFamilyCodeExist = function (familyCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GlobalAttributeFamily/IsFamilyCodeExist", "get", { "familyCode": familyCode }, callbackMethod, "json", false);
    };
    Endpoint.prototype.UpdateAssociatedProducts = function (pimProductTypeAssociationId, relatedProductId, data, pimProductId, productId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/PIM/Products/UpdateAssociatedProducts", "post", { "pimProductTypeAssociationId": pimProductTypeAssociationId, "relatedProductId": relatedProductId, "data": data, "pimProductId": pimProductId, "productId": productId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsContainerTemplateExist = function (code, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContainerTemplate/IsContainerTemplateExist", "get", { "code": code }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetUnassociatedProfileList = function (containerKey, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/GetUnassociatedProfiles", "get", { "containerKey": containerKey }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAssociatedVariants = function (entityId, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/GetEntityAttributeDetails", "get", { "entityId": entityId, "entityType": entityType }, callbackMethod, "html", false, false);
    };
    Endpoint.prototype.DeleteContentContainer = function (contentContainerId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/Delete", "get", { "contentContainerId": contentContainerId }, callbackMethod, "json");
    };
    Endpoint.prototype.DeleteAssociatedVariant = function (containerProfileVariantId, containerKey, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/DeleteAssociatedVariant", "post", { "containerProfileVariantId": containerProfileVariantId, "containerKey": containerKey }, callbackMethod, "json", false);
    };
    Endpoint.prototype.AssociateWidgetTemplate = function (variantId, containerTemplateId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/AssociateContainerTemplate", "put", { "variantId": variantId, "containerTemplateId": containerTemplateId }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsContainerExist = function (containerKey, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/IsContainerExist", "get", { "containerKey": containerKey }, callbackMethod, "json", false);
    };
    Endpoint.prototype.DeleteWidgetTemplate = function (containerTemplateId, fileName, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContainerTemplate/Delete", "get", { "ContainerTemplateId": containerTemplateId, "fileName": fileName }, callbackMethod, "json");
    };
    Endpoint.prototype.CalculateOrderReturn = function (calculateOrderReturnModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/CalculateOrderReturn", "post", { "calculateOrderReturnModel": calculateOrderReturnModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.SubmitCreateReturn = function (orderReturnModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/SubmitCreateReturn", "post", { "returnViewModel": orderReturnModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.IsValidReturnItem = function (orderReturnModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/IsValidReturnItems", "post", { "returnViewModel": orderReturnModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.PrintCreateReturnReceipt = function (returnNumber, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/RMAReturn/PrintCreateReturnReceipt", Constant.GET, { "returnNumber": returnNumber }, callbackMethod, "html", false);
    };
    Endpoint.prototype.DeleteSeo = function (seoTypeId, portalId, SEOCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Seo/DeleteSeoDetail", "get", { "seoTypeId": seoTypeId, "portalId": portalId, "seoCode": SEOCode }, callbackMethod, "json");
    };
    Endpoint.prototype.GetGlobalAttributesForDefaultVariantData = function (familyCode, entityType, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/GetGlobalAttributesForDefaultData", "get", { "familyCode": familyCode, "entityType": entityType }, callbackMethod, "html", false, false);
    };
    Endpoint.prototype.EditAssociatedVariant = function (variantId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/EditAssociatedVariant", "get", { "containerProfileVariantId": variantId, "localeId": localeId }, callbackMethod, "html", false);
    };
    Endpoint.prototype.GetVariantsList = function (containerKey, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/GetAssociatedVariantList", "get", { "containerKey": containerKey }, callbackMethod, "html", true, false);
    };
    Endpoint.prototype.GetAssociatedVariantData = function (variantId, localeId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/GetAttributesDataOnLocaleChange", "get", { "variantId": variantId, "localeId": localeId }, callbackMethod, "json", true, true);
    };
    Endpoint.prototype.ActivateDeactivateVariant = function (containerProfileVariantIds, isActivate, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/ActivateDeactivateVariant", "post", { "containerProfileVariantIds": containerProfileVariantIds, "isActivate": isActivate }, callbackMethod, "json", false);
    };
    Endpoint.prototype.PublishContentContainer = function (containerKey, targetPublishState, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/PublishContentContainer", "get", {
            "containerKey": containerKey, "targetPublishState": targetPublishState
        }, callbackMethod, "json");
    };
    Endpoint.prototype.PublishContentContainerVariant = function (containerKey, containerProfileVariantId, targetPublishState, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ContentContainer/PublishContainerVariant", "get", {
            "containerKey": containerKey, "containerProfileVariantId": containerProfileVariantId, "targetPublishState": targetPublishState
        }, callbackMethod, "json");
    };
    Endpoint.prototype.SaveContainerDetails = function (configurationModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/WebSite/SaveContainerDetails", "post", { "configurationViewModel": configurationModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetDateFormatGlobalSetting = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GeneralSetting/GetDateFormatGlobalSetting", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetTimeFormatGlobalSetting = function (callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/GeneralSetting/GetTimeFormatGlobalSetting", "get", {}, callbackMethod, "json");
    };
    Endpoint.prototype.GetProviderTypeForm = function (providerName, portalId, currentProviderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetProviderTypeForm", "post", { "providerName": providerName, "portalId": portalId, "currentProviderId": currentProviderId, }, callbackMethod, "html");
    };
    Endpoint.prototype.UpdateExistingUserName = function (userDetailsViewModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Customer/UpdateUsernameForRegisteredUser", "put", { "userDetailsViewModel": userDetailsViewModel }, callbackMethod, "json", false);
    };
    Endpoint.prototype.GetAuthorizeNetToken = function (paymentTokenModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/order/GetAuthorizeNetToken", "post", { "paymentTokenModel": paymentTokenModel }, callbackMethod, "json");
    };
    Endpoint.prototype.GetPaymentGatewayToken = function (paymentTokenModel, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Order/GetPaymentGatewayToken", "post", { "paymentTokenModel": paymentTokenModel }, callbackMethod, "json");
    };
    Endpoint.prototype.CheckFileNameExist = function (localeId, fileName, callBackMethod) {
        _super.prototype.ajaxRequest.call(this, "/ProductFeed/IsFileNameCombinationAlreadyExist", "get", { "localeId": localeId, "fileName": fileName }, callBackMethod, "json");
    };
    Endpoint.prototype.GetProviderTypeKlaviyoForm = function (providerName, portalId, currentProviderId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/Store/GetProviderTypeKlaviyoForm", "post", { "providerName": providerName, "portalId": portalId, "currentProviderId": currentProviderId, }, callbackMethod, "html");
    };
    return Endpoint;
}(ZnodeBase));
;
//# sourceMappingURL=ZnodeEndpoint.js.map