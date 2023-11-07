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
var FormBuilder = /** @class */ (function (_super) {
    __extends(FormBuilder, _super);
    function FormBuilder() {
        return _super.call(this) || this;
    }
    FormBuilder.prototype.Init = function () {
        FormBuilder.prototype.DisableControls();
    };
    FormBuilder.prototype.DeleteFormBuilder = function (control) {
        var formBuilderIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (formBuilderIds.length > 0) {
            Endpoint.prototype.DeleteFormBuilder(formBuilderIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Check unique form code.
    FormBuilder.prototype.IsFormCodeExist = function () {
        var result = true;
        var formId = $("#FormBuilderId").val();
        var formCode = $('#FormCode').val();
        if ((typeof (formId) == "undefined" || formId < 1) && (typeof (formCode) != "undefined" && formCode != "")) {
            Endpoint.prototype.IsFormCodeExist(formCode, function (res) {
                if (res.data) {
                    $("#errorSpanFomCode").addClass("error-msg");
                    $("#errorSpanFomCode").text(ZnodeBase.prototype.getResourceByKeyName("ErrorCodeAlreadyExist"));
                    $("#errorSpanFomCode").show();
                    result = false;
                }
            });
        }
        return result;
    };
    FormBuilder.prototype.UpdateAttributeDisplayOrder = function (attributeId, moveToUp) {
        if (attributeId > 0) {
            ZnodeBase.prototype.ShowLoader();
            var formBuilderId_1 = $("#FormBuilderId").val();
            var model = { "FormBuilderId": formBuilderId_1, "AttributeId": attributeId, "IsNavigateUpward": moveToUp };
            Endpoint.prototype.UpdateAttributeDisplayOrder(model, function (res) {
                if (res.HasNoError) {
                    FormBuilder.prototype.GetFormBuilderAttributeGroup(formBuilderId_1);
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.Message, "error", isFadeOut, fadeOutTime);
                }
            });
            ZnodeBase.prototype.HideLoader();
        }
        FormBuilder.prototype.DisableControls();
    };
    FormBuilder.prototype.UpdateGroupDisplayOrder = function (groupId, moveToUp) {
        if (groupId > 0) {
            ZnodeBase.prototype.ShowLoader();
            var formBuilderId_2 = $("#FormBuilderId").val();
            var model = { "FormBuilderId": formBuilderId_2, "GroupId": groupId, "IsNavigateUpward": moveToUp };
            Endpoint.prototype.UpdateGroupDisplayOrder(model, function (res) {
                if (res.HasNoError) {
                    FormBuilder.prototype.GetFormBuilderAttributeGroup(formBuilderId_2);
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.Message, "error", isFadeOut, fadeOutTime);
                }
            });
            ZnodeBase.prototype.HideLoader();
        }
    };
    FormBuilder.prototype.UnAssignAttribute = function (attributeId) {
        if (attributeId > 0) {
            ZnodeBase.prototype.ShowLoader();
            var formBuilderId_3 = $("#FormBuilderId").val();
            Endpoint.prototype.UnAssignAttribute(formBuilderId_3, attributeId, function (res) {
                if (res.HasNoError) {
                    FormBuilder.prototype.GetFormBuilderAttributeGroup(formBuilderId_3);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.Message, "success", isFadeOut, fadeOutTime);
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.Message, "error", isFadeOut, fadeOutTime);
                }
            });
            ZnodeBase.prototype.HideLoader();
        }
    };
    FormBuilder.prototype.UnAssignGroup = function (groupId) {
        if (groupId > 0) {
            ZnodeBase.prototype.ShowLoader();
            var formBuilderId_4 = $("#FormBuilderId").val();
            Endpoint.prototype.UnAssignGroup(formBuilderId_4, groupId, function (res) {
                if (res.HasNoError) {
                    FormBuilder.prototype.GetFormBuilderAttributeGroup(formBuilderId_4);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.Message, "success", isFadeOut, fadeOutTime);
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.Message, "error", isFadeOut, fadeOutTime);
                }
            });
            ZnodeBase.prototype.HideLoader();
        }
    };
    FormBuilder.prototype.GetFormBuilderAttributeGroup = function (formBuilderId) {
        $("#frombuilderControls").html("");
        if (formBuilderId > 0) {
            Endpoint.prototype.GetFormBuilderAttributeGroup(formBuilderId, function (response) {
                if (response != "" && response != null && typeof (response) != "undefined") {
                    $("#frombuilderControls").append(response);
                    $('#frombuilderControls button[id="UploadMultiple"]').attr("disabled", "disabled");
                }
            });
        }
    };
    //Disable  multifile upload control attribute.
    FormBuilder.prototype.DisableControls = function () {
        $('button[id="UploadMultiple"]').attr("disabled", "disabled");
    };
    return FormBuilder;
}(ZnodeBase));
//# sourceMappingURL=FormBuilder.js.map