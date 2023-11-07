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
var SalesRep = /** @class */ (function (_super) {
    __extends(SalesRep, _super);
    function SalesRep() {
        var _this = _super.call(this) || this;
        User.prototype._multiFastItemdata = new Array();
        return _this;
    }
    SalesRep.prototype.Init = function () {
        User.prototype.SetIsSelectAllPortalOnInit();
    };
    SalesRep.prototype.EnableUserAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableSalesRepAccount(accountIds, true, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/SalesRep/List";
            });
            ZnodeBase.prototype.HideLoader();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    SalesRep.prototype.DisableUserAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableSalesRepAccount(accountIds, false, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/SalesRep/List";
            });
            ZnodeBase.prototype.HideLoader();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    SalesRep.prototype.UserResetPassword = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.UserResetSalesRepPassword(accountIds, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/SalesRep/List";
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    return SalesRep;
}(ZnodeBase));
//# sourceMappingURL=SalesRep.js.map