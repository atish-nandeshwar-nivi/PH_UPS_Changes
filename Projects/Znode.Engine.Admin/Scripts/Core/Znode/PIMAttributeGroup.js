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
var PIMAttributeGroup = /** @class */ (function (_super) {
    __extends(PIMAttributeGroup, _super);
    function PIMAttributeGroup() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    PIMAttributeGroup.prototype.DeletePIMAttributeGroup = function (contollerName, control) {
        var pimAttributeGroupIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (pimAttributeGroupIds.length > 0) {
            this._endPoint.DeletePIMAttributeGroup(pimAttributeGroupIds, contollerName, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    PIMAttributeGroup.prototype.ValidateGroupCode = function () {
        $("#GroupCode").on("blur", function () {
            ZnodeBase.prototype.ShowLoader();
            PIMAttributeGroup.prototype.ValidateAttributeGroupCode();
            ZnodeBase.prototype.HideLoader();
        });
    };
    PIMAttributeGroup.prototype.ValidateAttributeGroupCode = function () {
        var isValid = true;
        if ($("#GroupCode").val() == '') {
            $("#GroupCode").addClass("input-validation-error");
            $("#errorSpanGroupCode").addClass("error-msg");
            $("#errorSpanGroupCode").text(ZnodeBase.prototype.getResourceByKeyName("ErrorAttributeGroupCodeRequired"));
            $("#errorSpanGroupCode").show();
            ZnodeBase.prototype.HideLoader();
        }
        else {
            Endpoint.prototype.IsAttributeGroupCodeExist($("#GroupCode").val(), $("#IsCategory").val(), $("#PimAttributeGroupId").val(), function (response) {
                if (!response) {
                    $("#GroupCode").addClass("input-validation-error");
                    $("#errorSpanGroupCode").addClass("error-msg");
                    $("#errorSpanGroupCode").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistAttributeGroupCode"));
                    $("#errorSpanGroupCode").show();
                    isValid = false;
                    ZnodeBase.prototype.HideLoader();
                }
            });
        }
        if (!CommonHelper.prototype.Validate())
            isValid = false;
        return isValid;
    };
    return PIMAttributeGroup;
}(ZnodeBase));
//# sourceMappingURL=PIMAttributeGroup.js.map