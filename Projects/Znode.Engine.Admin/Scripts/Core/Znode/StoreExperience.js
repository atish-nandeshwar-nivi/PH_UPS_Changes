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
var StoreExperience = /** @class */ (function (_super) {
    __extends(StoreExperience, _super);
    function StoreExperience() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    StoreExperience.prototype.PublishStoreCMSContent = function () {
        var publishStateFormData = 'NONE';
        var publishContentFormData = 'StoreSettings,CmsContent';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        Endpoint.prototype.PublishStoreCMSContent($("#HdnStoreId").val(), publishStateFormData, publishContentFormData, function (res) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            ZnodeProgressNotifier.prototype.InitiateProgressBar(function () {
                DynamicGrid.prototype.RefreshGridNoNotification($("#ZnodeStoreExperience").find("#refreshGrid"));
            });
        });
    };
    return StoreExperience;
}(ZnodeBase));
//# sourceMappingURL=StoreExperience.js.map