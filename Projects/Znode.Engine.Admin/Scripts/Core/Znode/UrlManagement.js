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
var UrlManagement = /** @class */ (function (_super) {
    __extends(UrlManagement, _super);
    function UrlManagement() {
        return _super.call(this) || this;
    }
    UrlManagement.prototype.Init = function () {
    };
    UrlManagement.prototype.ValidateDomainNameField = function (object) {
        var isValid = true;
        if ($(object).val() == '') {
            $(object).addClass("input-validation-error");
            if ($(object).val() == '')
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("DomainNameIsRequired"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    UrlManagement.prototype.EnableDomain = function () {
        var domainIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (domainIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableAdminAPIDomain(domainIds, true, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/UrlManagement/List";
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    UrlManagement.prototype.DisableDomain = function () {
        var domainIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (domainIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableAdminAPIDomain(domainIds, false, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/UrlManagement/List";
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    UrlManagement.prototype.DeleteMultipleUrl = function (control) {
        var urlIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (urlIds.length > 0) {
            Endpoint.prototype.DeleteUrl(urlIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    return UrlManagement;
}(ZnodeBase));
//# sourceMappingURL=UrlManagement.js.map