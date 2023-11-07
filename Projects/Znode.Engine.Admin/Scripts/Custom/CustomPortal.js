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
var CustomPortal = /** @class */ (function (_super) {
    __extends(CustomPortal, _super);
    function CustomPortal() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        CustomPortal.prototype.GetValueOnFormPost();
        return _this;
    }
    CustomPortal.prototype.Init = function () {
    };
    CustomPortal.prototype.GetValueOnFormPost = function () {
        $("#frmStore").on("submit", function () {
            $("#OrderStatusId").val($("#ddlOrderStatus").val());
        });
    };
    return CustomPortal;
}(ZnodeBase));
//# sourceMappingURL=CustomPortal.js.map