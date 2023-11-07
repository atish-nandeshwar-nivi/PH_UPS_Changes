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
var Sms = /** @class */ (function (_super) {
    __extends(Sms, _super);
    function Sms() {
        return _super.call(this) || this;
    }
    Sms.prototype.Init = function () {
    };
    Sms.prototype.ShowProviderHtml = function () {
        var providerName = $('#ddlProviderTypes option:selected').html();
        var portalId = $('#hdnportalId').val();
        var currentProviderId = $('#ddlProviderTypes  option:selected')[0].id;
        if (currentProviderId == "defaultType") {
            $("#providertypeform-container").hide();
            $("#providertypeform-container").html('');
        }
        else {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetProviderTypeForm(providerName, portalId, currentProviderId, function (res) {
                $("#providertypeform-container").show();
                $("#providertypeform-container").html(res);
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    return Sms;
}(ZnodeBase));
//# sourceMappingURL=SMS.js.map