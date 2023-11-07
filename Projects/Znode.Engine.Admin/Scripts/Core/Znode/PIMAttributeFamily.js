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
var PIMAttributeFamily = /** @class */ (function (_super) {
    __extends(PIMAttributeFamily, _super);
    function PIMAttributeFamily() {
        return _super.call(this) || this;
    }
    PIMAttributeFamily.prototype.DeletePIMFamily = function (control, contollerName) {
        var pimAttributeFamilyIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (pimAttributeFamilyIds.length > 0) {
            Endpoint.prototype.DeletePIMFamily(pimAttributeFamilyIds, contollerName, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    PIMAttributeFamily.prototype.ValidatePIMAttributeFamily = function () {
        $("#FamilyCode").on("blur", function () {
            ZnodeBase.prototype.ShowLoader();
            PIMAttributeFamily.prototype.ValidatePIMAttributeFamilyCode();
            ZnodeBase.prototype.HideLoader();
        });
    };
    PIMAttributeFamily.prototype.ValidatePIMAttributeFamilyCode = function () {
        var isValid = true;
        if ($("#FamilyCode").val() == '') {
            $("#FamilyCode").addClass("input-validation-error");
            $("#errorSpanFamilyCode").addClass("error-msg");
            $("#errorSpanFamilyCode").text(ZnodeBase.prototype.getResourceByKeyName("ErrorAttributeFamilyCodeRequired"));
            $("#errorSpanFamilyCode").show();
            ZnodeBase.prototype.HideLoader();
        }
        else {
            Endpoint.prototype.IsAttributeFamilyCodeExist($("#FamilyCode").val(), $("#IsCategory").val(), $("#PimAttributeFamilyId").val(), function (response) {
                if (!response) {
                    $("#FamilyCode").addClass("input-validation-error");
                    $("#errorSpanFamilyCode").addClass("error-msg");
                    $("#errorSpanFamilyCode").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistFamilyCode"));
                    $("#errorSpanFamilyCode").show();
                    isValid = false;
                }
            });
        }
        if (!CommonHelper.prototype.Validate())
            isValid = false;
        return isValid;
    };
    //This method is used to show popup to edit display order
    PIMAttributeFamily.prototype.EditDisplayOrder = function (groupID, groupCode, displayOrder) {
        $("#errorSpamtxtDisplayOrder").removeClass("error-msg field-validation-valid").hide();
        $("#txtDisplayOrder").removeClass('input-validation-error');
        $('#divEditDisplayOrderPopup').show();
        $('#txtGroupCode').val(groupCode);
        $('#txtDisplayOrder').val(displayOrder);
        $('#hdnGroupCodeId').val(groupID);
        $('#divEditDisplayOrderPopup').modal({ backdrop: 'static', keyboard: false });
    };
    //This method is used to update display order of attribute group in attribute family
    PIMAttributeFamily.prototype.UpdateDisplayOrder = function (control) {
        var displayOrder = $('#txtDisplayOrder').val();
        var pimattributeGroupId = $('#hdnGroupCodeId').val();
        var pimAttributeFamilyId = $('#PimAttributeFamilyId').val();
        if (!PIMAttributeFamily.prototype.ValidateDisplayOrder(displayOrder))
            return;
        Endpoint.prototype.UpdateAttributeGroupDisplayOrder(pimattributeGroupId, displayOrder, pimAttributeFamilyId, function (response) {
            $('#divEditDisplayOrderPopup').modal("hide");
            if (response.status)
                window.location.reload();
            else {
                ZnodeBase.prototype.HideLoader();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
            }
        });
    };
    //Validate display order.
    PIMAttributeFamily.prototype.ValidateDisplayOrder = function (displayOrder) {
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
    //Get Unassigned attributes.
    PIMAttributeFamily.prototype.GetUnAssignedAttributes = function (contollerName, groupID, familyID) {
        var pimattributeGroupId = groupID;
        var pimAttributeFamilyId = $('#PimAttributeFamilyId').val();
        if (pimattributeGroupId > 0 && pimAttributeFamilyId > 0) {
            Endpoint.prototype.GetUnAssigedAttributes(pimattributeGroupId, pimAttributeFamilyId, contollerName, function (response) {
                $("#UnAssignedAttributesForGroup_" + pimattributeGroupId).html(response);
            });
        }
    };
    return PIMAttributeFamily;
}(ZnodeBase));
//# sourceMappingURL=PIMAttributeFamily.js.map