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
var RMAConfiguration = /** @class */ (function (_super) {
    __extends(RMAConfiguration, _super);
    function RMAConfiguration() {
        return _super.call(this) || this;
    }
    RMAConfiguration.prototype.Init = function () {
    };
    RMAConfiguration.prototype.CreateReasonForReturn = function () {
        Endpoint.prototype.CreateReasonForReturn(function (res) {
            $("#reasonForReturnPopup").modal("show");
            $("#reasonForReturnPopup").html(res);
        });
    };
    RMAConfiguration.prototype.EditReasonForReturn = function () {
        $("#grid tbody tr td").find(".z-edit").click(function (e) {
            e.preventDefault();
            var rmaReasonForReturnId = $(this).attr("data-parameter").split('&')[0].split('=')[1];
            Endpoint.prototype.EditReasonForReturn(rmaReasonForReturnId, function (res) {
                if (res != "") {
                    $("#reasonForReturnPopup").modal("show");
                    $("#reasonForReturnPopup").html(res);
                }
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
            });
        });
    };
    RMAConfiguration.prototype.AddReasonForReturnResult = function (response) {
        if (response.status) {
            Endpoint.prototype.GetReasonForReturnList(function (res) {
                $("#reasonForReturnPopup").html(res);
                $("#reasonForReturnPopup").modal("hide");
            });
        }
        $("#reasonForReturnPopup").modal("hide");
        WebSite.prototype.RemovePopupOverlay();
        window.location.href = window.location.protocol + "//" + window.location.host + "/RMAConfiguration/GetReasonForReturnList";
    };
    RMAConfiguration.prototype.DeleteReasonForReturn = function (control) {
        var rmaReasonForReturnId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (rmaReasonForReturnId.length > 0) {
            Endpoint.prototype.DeleteReasonForReturn(rmaReasonForReturnId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    RMAConfiguration.prototype.EditRequestStatus = function () {
        $("#grid tbody tr td").find(".z-edit").click(function (e) {
            e.preventDefault();
            var rmaRequestStatusId = $(this).attr("data-parameter").split('&')[0].split('=')[1];
            Endpoint.prototype.EditRequestStatus(rmaRequestStatusId, function (res) {
                if (res != "") {
                    $("#requestStatusPopup").modal("show");
                    $("#requestStatusPopup").html(res);
                }
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
            });
        });
    };
    RMAConfiguration.prototype.EditRequestStatusResult = function (response) {
        if (response.status) {
            Endpoint.prototype.GetRequestStatusList(function (res) {
                $("#requestStatusPopup").html(res);
                $("#requestStatusPopup").modal("hide");
            });
        }
        $("#requestStatusPopup").modal("hide");
        WebSite.prototype.RemovePopupOverlay();
        window.location.href = window.location.protocol + "//" + window.location.host + "/RMAConfiguration/GetRequestStatusList";
    };
    RMAConfiguration.prototype.DeleteRequestStatus = function (control) {
        var rmaRequestStatusId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (rmaRequestStatusId.length > 0) {
            Endpoint.prototype.DeleteRequestStatus(rmaRequestStatusId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    RMAConfiguration.prototype.ValidateNameField = function (object) {
        var isValid = true;
        if ($(object).val() == '') {
            $(object).addClass("input-validation-error");
            if ($(object).val() == '')
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ReasonForReturnIsRequired"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    return RMAConfiguration;
}(ZnodeBase));
//# sourceMappingURL=RMAConfiguration.js.map