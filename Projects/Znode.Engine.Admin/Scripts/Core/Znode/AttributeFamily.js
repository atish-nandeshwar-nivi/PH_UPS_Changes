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
var AttributeFamily = /** @class */ (function (_super) {
    __extends(AttributeFamily, _super);
    function AttributeFamily() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    AttributeFamily.prototype.Init = function () { };
    AttributeFamily.prototype.DeleteMediaFamily = function () {
        var mediaAttributeFamilyIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (mediaAttributeFamilyIds.length > 0) {
            this._endPoint.DeleteMediaFamily(mediaAttributeFamilyIds, function (res) {
                ZnodeBase.prototype.showDeleteStatus(res);
            });
        }
    };
    AttributeFamily.prototype.Validate = function () {
        var Locales = [];
        $(".LocaleLabel").each(function () {
            Locales.push($(this).attr('localename'));
        });
        var flag = true;
        for (var i = 0; i < Locales.length; i++) {
            var value = $("#Locale" + Locales[i]).val();
            if (value.length > 100) {
                $("#error" + Locales[i]).html(ZnodeBase.prototype.getResourceByKeyName("LocaleError"));
                flag = false;
            }
        }
        return flag;
    };
    return AttributeFamily;
}(ZnodeBase));
//# sourceMappingURL=AttributeFamily.js.map