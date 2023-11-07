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
var CustomEndpoint = /** @class */ (function (_super) {
    __extends(CustomEndpoint, _super);
    function CustomEndpoint() {
        return _super.call(this) || this;
    }
    CustomEndpoint.prototype.GetStateByCountryCode = function (countryCode, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomAccount/GetStateByCountryCode", "get", { "countryCode": countryCode }, callbackMethod, "json", false);
    };
    CustomEndpoint.prototype.DeleteDataCaptureDefaultValues = function (defaultvalueId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomStoreDataCapture/DeleteDefaultValues", "get", {
            "defaultvalueId": defaultvalueId
        }, callbackMethod, "json");
    };
    CustomEndpoint.prototype.SaveGlobalAttributeDefaultValues = function (data, attributeId, defaultvaluecode, defaultvalueId, displayOrder, isDefault, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomStoreDataCapture/SaveDefaultValues", "get", {
            "model": JSON.stringify(data),
            "attributeId": attributeId,
            "defaultvalueId": defaultvalueId,
            "defaultvaluecode": defaultvaluecode,
            "displayOrder": displayOrder,
            "isdefault": isDefault
        }, callbackMethod, "json");
    };
    CustomEndpoint.prototype.GetPortalCustomizationSettings = function (portalId, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomOrder/GetProductCustomizationSetting", "get", { "portalId": portalId }, callbackMethod, "json");
    };
    CustomEndpoint.prototype.GetProduct = function (parameters, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomOrder/GetConfigurableProduct", "post", { "model": parameters }, callbackMethod, "html");
    };
    CustomEndpoint.prototype.DeleteCartItem = function (guidId, orderId, isQuote, callbackMethod) {
        _super.prototype.ajaxRequest.call(this, "/CustomOrder/RemoveShoppingCartItem", "post", { "guidId": guidId, "orderId": orderId, "isQuote": isQuote }, callbackMethod, "json");
    };
    return CustomEndpoint;
}(ZnodeBase));
//# sourceMappingURL=CustomEndpoint.js.map