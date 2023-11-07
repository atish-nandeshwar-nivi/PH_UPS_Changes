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
var _data;
var addonId;
var selectedTab;
var AddonGroup = /** @class */ (function (_super) {
    __extends(AddonGroup, _super);
    function AddonGroup() {
        return _super.call(this) || this;
    }
    AddonGroup.prototype.Init = function () {
    };
    AddonGroup.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_addOnCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime });
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        window.location.reload();
    };
    AddonGroup.prototype.CultureChange = function () {
        $.cookie("_addOnCulture", $("#ddlAddonLocale").val());
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        if (orignalUrl.indexOf('PimAddonGroupId;') > -1)
            window.location.replace(orignalUrl + "?PimAddonGroupId=" + $("#PimAddonGroupId").val());
        else
            window.location.reload();
    };
    AddonGroup.prototype.AddSKUs = function () {
        var productIds = DynamicGrid.prototype.GetMultipleSelectedIds('UnassociatedProducts');
        if (productIds != "" && productIds != null && productIds != undefined) {
            AddonGroup.prototype.AssociateAddonGroupSKU(productIds, parseInt($("#PimAddonGroupId").val(), 10));
            ZnodeBase.prototype.CancelUpload('divAssociateAddonGroupProduct');
            DynamicGrid.prototype.ClearCheckboxArray();
        }
        else {
            $("#AssociateAddonGroupError").show();
        }
    };
    AddonGroup.prototype.AssociateAddonGroupSKU = function (associatedProductIds, addonGroupId) {
        var model = { "ParentId": addonGroupId, "AssociatedIds": associatedProductIds };
        Endpoint.prototype.AssociateAddonGroupProducts(model, function (response) {
            if (response.status) {
                AddonGroup.prototype.GetAssociatedProducts($("#associatedProducts"), addonGroupId, $("#AddonGroupName").val(), parseInt($("#LocaleId").val()));
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper("An error occured while associating addon group products.", "error", true, 5000);
            }
            $("#divAssociateAddonGroupProduct").html("");
        });
    };
    //Method for Delete Addon Groups
    AddonGroup.prototype.DeleteMultipleAddonGroupProduct = function (control) {
        var addonGroupProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (addonGroupProductIds.length > 0) {
            Endpoint.prototype.DeleteAddonGroupProducts(addonGroupProductIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    AddonGroup.prototype.GetAssociatedProducts = function (containerDiv, addonGroupId, addonGroupName, localeId) {
        Endpoint.prototype.GetAssociatedAddonProducts(addonGroupId, addonGroupName, localeId, function (res) {
            containerDiv.html(res);
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper("Addon group products associated successfully.", "success", true, 5000);
        });
    };
    return AddonGroup;
}(ZnodeBase));
//# sourceMappingURL=AddonGroup.js.map