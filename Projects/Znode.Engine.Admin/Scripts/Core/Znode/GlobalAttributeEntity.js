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
var GlobalAttributeEntity = /** @class */ (function (_super) {
    __extends(GlobalAttributeEntity, _super);
    function GlobalAttributeEntity() {
        return _super.call(this) || this;
    }
    GlobalAttributeEntity.prototype.HideShowExpandOption = function (control, controller, action) {
        $(control).find("i").toggleClass("z-add z-minus");
        $(control).closest("thead").next("tbody .attributeData").toggle();
        if ($(control).find("i").hasClass("z-minus")) {
            this._attributeId = $(control).data("attributegroupid");
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetAssociatedGlobalAttributes(this._attributeId, function (response) {
                if (response) {
                    $(control).closest("thead").next("tbody .attributeData").html(response).show();
                    ZnodeBase.prototype.HideLoader();
                }
                else {
                    $(control).closest("thead").next("tbody .attributeData").html("No attributes associated to be displayed.").show();
                    ZnodeBase.prototype.HideLoader();
                }
            });
        }
    };
    GlobalAttributeEntity.prototype.GetAttributeGroupEntity = function () {
        var entityId = $('#entityList').val();
        $("#hdnEntityId").val(entityId);
        $("#divEntityToGroup").html("");
        if (entityId > 0) {
            Endpoint.prototype.GetTabStructure(entityId, function (response) {
                if (response != "" && response != null && typeof (response) != "undefined") {
                    $("#divEntityToGroup").append(response);
                }
            });
        }
    };
    //This method is used to show popup to edit display order
    GlobalAttributeEntity.prototype.EditDisplayOrder = function (groupID, groupCode, displayOrder) {
        $("#errorSpamtxtDisplayOrder").removeClass("error-msg field-validation-valid").hide();
        $("#txtDisplayOrder").removeClass('input-validation-error');
        $('#divEditDisplayOrderPopup').show();
        $('#txtGroupCode').val(groupCode);
        $('#txtDisplayOrder').val(displayOrder);
        $('#hdnGroupCodeId').val(groupID);
        $('#divEditDisplayOrderPopup').modal({ backdrop: 'static', keyboard: false });
    };
    //This method is used to update display order of attribute group in attribute entity
    GlobalAttributeEntity.prototype.UpdateDisplayOrder = function (control) {
        var displayOrder = $('#txtDisplayOrder').val();
        var globalattributeGroupId = $('#hdnGroupCodeId').val();
        var globalAttributeEntityId = $('#entityList').val();
        if (!GlobalAttributeEntity.prototype.ValidateDisplayOrder(displayOrder))
            return;
        Endpoint.prototype.UpdateGlobalAttributeGroupDisplayOrder(globalattributeGroupId, displayOrder, globalAttributeEntityId, function (response) {
            $('#divEditDisplayOrderPopup').modal("hide");
            if (response.status) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "success", isFadeOut, fadeOutTime);
                GlobalAttributeEntity.prototype.GetAttributeGroupEntity();
            }
            else {
                ZnodeBase.prototype.HideLoader();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
            }
        });
    };
    //This method will unassign the global attribute group.
    GlobalAttributeEntity.prototype.UnAssignAttributeGroup = function (groupId, control) {
        if (groupId > 0) {
            var entityId = $('#entityList').val();
            Endpoint.prototype.UnAssignGlobalAttributeGroup(groupId, entityId, function (response) {
                if (response.status) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Message, "success", isFadeOut, fadeOutTime);
                    GlobalAttributeEntity.prototype.GetAttributeGroupEntity();
                }
                else {
                    ZnodeBase.prototype.HideLoader();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Message, "error", isFadeOut, fadeOutTime);
                }
            });
        }
    };
    //Validate display order.
    GlobalAttributeEntity.prototype.ValidateDisplayOrder = function (displayOrder) {
        if (displayOrder === "" && displayOrder.length === 0) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorRequiredDisplayOrder"), $("#txtDisplayOrder"), $("#errorSpamtxtDisplayOrder"));
            return false;
        }
        else if (!/^([1-9][0-9]{0,2}|999)$/.test(displayOrder)) {
            $("#errorSpamtxtDisplayOrder").removeClass("error-msg field-validation-valid").show();
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("InValidDisplayOrderRange"), $("#txtDisplayOrder"), $("#errorSpamtxtDisplayOrder"));
            return false;
        }
        else
            return true;
    };
    return GlobalAttributeEntity;
}(ZnodeBase));
//# sourceMappingURL=GlobalAttributeEntity.js.map