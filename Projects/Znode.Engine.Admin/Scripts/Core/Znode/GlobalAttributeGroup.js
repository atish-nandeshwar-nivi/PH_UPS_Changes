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
var GlobalAttributeGroup = /** @class */ (function (_super) {
    __extends(GlobalAttributeGroup, _super);
    function GlobalAttributeGroup() {
        return _super.call(this) || this;
    }
    GlobalAttributeGroup.prototype.DeleteGlobalAttributeGroup = function (control) {
        var globalAttributeGroupIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (globalAttributeGroupIds.length > 0) {
            Endpoint.prototype.DeleteGlobalAttributeGroup(globalAttributeGroupIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    GlobalAttributeGroup.prototype.ValidateGroupCode = function () {
        $("#GroupCode").on("blur", function () {
            ZnodeBase.prototype.ShowLoader();
            GlobalAttributeGroup.prototype.ValidateAttributeGroupCode();
            ZnodeBase.prototype.HideLoader();
        });
    };
    GlobalAttributeGroup.prototype.ValidateAttributeGroupCode = function () {
        var isValid = true;
        if ($("#GroupCode").val() == '') {
            $("#GroupCode").addClass("input-validation-error");
            $("#errorSpanGroupCode").addClass("error-msg");
            $("#errorSpanGroupCode").text(ZnodeBase.prototype.getResourceByKeyName("ErrorAttributeGroupCodeRequired"));
            $("#errorSpanGroupCode").show();
            ZnodeBase.prototype.HideLoader();
        }
        else {
            Endpoint.prototype.IsGlobalAttributeGroupCodeExist($("#GroupCode").val(), $("#GlobalAttributeGroupId").val(), function (response) {
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
    GlobalAttributeGroup.prototype.OnSelectEntityAutocompleteDataBind = function (item) {
        if (item != undefined) {
            var entityType = item.text;
            var entityId = item.Id;
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetAttributeGroupList(entityId, entityType, function (response) {
                $("#ZnodeGlobalAttributeGroupList").html("");
                $("#ZnodeGlobalAttributeGroupList").html(response);
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    return GlobalAttributeGroup;
}(ZnodeBase));
//# sourceMappingURL=GlobalAttributeGroup.js.map