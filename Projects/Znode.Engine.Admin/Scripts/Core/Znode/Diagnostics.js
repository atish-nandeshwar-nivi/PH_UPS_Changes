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
var Diagnostics = /** @class */ (function (_super) {
    __extends(Diagnostics, _super);
    function Diagnostics() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    Diagnostics.prototype.Init = function () {
        Endpoint.prototype.showDiagnosticsTrace(function (response) {
            $("#trace").html(response);
        });
    };
    Diagnostics.prototype.MaintenaceCleanDataPopup = function () {
        $("#maintenancecleardata").modal('show');
    };
    //To delete all the published data from elastic and sql publish entity
    Diagnostics.prototype.ClearAllPublishedData = function () {
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextClearPublishData"), 'success', isFadeOut, fadeOutTime);
        Endpoint.prototype.ClearAllPublishedData(function (response) {
            if (response != null) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            }
        });
    };
    return Diagnostics;
}(ZnodeBase));
//# sourceMappingURL=Diagnostics.js.map