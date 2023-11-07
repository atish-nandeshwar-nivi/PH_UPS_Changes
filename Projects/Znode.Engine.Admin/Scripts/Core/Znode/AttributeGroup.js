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
var AttributeGroup = /** @class */ (function (_super) {
    __extends(AttributeGroup, _super);
    function AttributeGroup() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    AttributeGroup.prototype.DeleteAttributeGroup = function (control) {
        var mediaAttributeGroupIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (mediaAttributeGroupIds.length > 0) {
            Endpoint.prototype.DeleteMediaAttributeGroup(mediaAttributeGroupIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    AttributeGroup.prototype.Init = function () {
        AttributeGroup.prototype.ValidateGroupCode();
        $("#GroupCodeText").on('keypress blur change', function (e) {
            $("#GroupCode").val($("#GroupCodeText").val());
        });
        $("#dvSave").on("click", function () {
            if ($("#GroupCodeLable").text() == "") {
                if ($("#GroupCodeText").val()) {
                    $("#GroupCodeErrormessage").html("");
                    return true;
                }
                else {
                    $("#GroupCodeErrormessage").html("Please enter Group Code.");
                    return false;
                }
            }
        });
    };
    AttributeGroup.prototype.ValidateGroupCode = function () {
        $("#GroupCode").on("blur", function () {
            ZnodeBase.prototype.ShowLoader();
            AttributeGroup.prototype.ValidateMediaAttributeGroupCode();
            ZnodeBase.prototype.HideLoader();
        });
    };
    AttributeGroup.prototype.ValidateMediaAttributeGroupCode = function () {
        var isValid = true;
        if ($("#GroupCode").val() == '') {
            $("#GroupCode").addClass("input-validation-error");
            $("#errorSpanGroupCode").addClass("error-msg");
            $("#errorSpanGroupCode").text(ZnodeBase.prototype.getResourceByKeyName("ErrorAttributeGroupCodeRequired"));
            $("#errorSpanGroupCode").show();
            ZnodeBase.prototype.HideLoader();
        }
        else {
            Endpoint.prototype.IsMediaAttributeGroupCodeExist($("#GroupCode").val(), $("#MediaAttributeGroupId").val(), function (response) {
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
    return AttributeGroup;
}(ZnodeBase));
//# sourceMappingURL=AttributeGroup.js.map