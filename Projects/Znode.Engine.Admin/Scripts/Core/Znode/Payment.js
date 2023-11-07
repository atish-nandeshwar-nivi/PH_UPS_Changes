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
var Payment = /** @class */ (function (_super) {
    __extends(Payment, _super);
    function Payment() {
        return _super.call(this) || this;
    }
    Payment.prototype.Init = function () {
        Payment.prototype.OnLoad();
    };
    Payment.prototype.OnLoad = function () {
        $(document).off("change", "#ddlPaymentTypes").on("change", "#ddlPaymentTypes", function () {
            Payment.prototype.GetPaymentTypesForm($('#ddlPaymentTypes option:selected').attr('data-type'), null);
        });
        var paymentType = $('#ddlPaymentTypes option:selected').attr('data-type').toLowerCase();
        Payment.prototype.SetGatewayMode();
        if (paymentType == "credit_card") {
            Payment.prototype.DisableCybersource();
            $(document).off("change", "#ddlPaymentGetways").on("change", "#ddlPaymentGetways", function () {
                Payment.prototype.DisableCybersource();
                Payment.prototype.SetGatewayMode();
                Payment.prototype.GetPaymentGetwayForm($('#ddlPaymentGetways').val(), null);
            });
        }
        if (paymentType == "credit_card" || paymentType == "paypal_express" || paymentType == "amazon_pay") {
            $(document).off("change", "#ddlTestMode").on("change", "#ddlTestMode", function () {
                Payment.prototype.GetPaymentSettingCredentials();
            });
        }
        $(document).off("change", "#IsPoDocUploadEnable").on("change", "#IsPoDocUploadEnable", function () {
            Payment.prototype.ToggleIsPODocRequired();
        });
        $(document).off("change", "#IsPoDocRequire").on("change", "#IsPoDocRequire", function () {
            var IsPODocRequired = $("#IsPoDocRequire");
            IsPODocRequired.is(":checked") ? IsPODocRequired.val("true") : IsPODocRequired.val("false");
        });
        if (paymentType == "purchase_order") {
            $("#IsPoDocUploadEnable").trigger("change");
            $("#IsPoDocRequire").trigger("change");
        }
        Payment.prototype.PaymentCodeValidation();
        Payment.prototype.PaymentDisplayNameValidation();
    };
    Payment.prototype.DisableCybersource = function () {
        if ($("#ddlPaymentGetways").val() == 'cybersource') {
            $('#IsActive').prop('checked', false);
            $('#IsActive').prop('disabled', true);
        }
        else {
            $('#IsActive').prop('checked', true);
            $('#IsActive').prop('disabled', false);
        }
    };
    Payment.prototype.GetPaymentTypesForm = function (paymentName, paymentSettingModel) {
        var payment_Name = $("#PaymentTypeCode").val(); //"PaymentTypeCode" has the Payment name.
        if (payment_Name != undefined && payment_Name != "") {
            $("#ddlPaymentTypes").val(payment_Name);
            paymentName = $('#ddlPaymentTypes option:selected').attr('data-type');
        }
        var paymentCode = $('#ddlPaymentTypes option:selected').val();
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.GetPaymentTypeForm(paymentName, paymentSettingModel, paymentCode, function (res) {
            $("#paymenttypeform-container").show();
            $("#paymenttypeform-container").html(res);
            var gatewayCode = $('#ddlPaymentGetways').val();
            if (gatewayCode != undefined && gatewayCode != "") {
                Payment.prototype.GetPaymentGetwayForm($('#ddlPaymentGetways').val(), null);
            }
            ZnodeBase.prototype.HideLoader();
        });
    };
    Payment.prototype.ValidatePayment = function () {
        var IsValid = true;
        IsValid = Payment.prototype.IsCardTypeSelected();
        if (IsValid == true) {
            IsValid = Payment.prototype.ValidatePaymentCode();
        }
        if (IsValid) {
            $("#PaymentTypeCode").val($("#ddlPaymentTypes option:selected").val());
            $("#GatewayCode").val($("#ddlPaymentGetways option:selected").val());
        }
        return IsValid;
    };
    Payment.prototype.IsCardTypeSelected = function () {
        $("#paymentcardtype").show();
        var paymentType = $('#ddlPaymentTypes option:Selected').val().toLowerCase();
        if (paymentType == "creditcard") {
            var gatewayCode = $('#ddlPaymentGetways').val();
            if (gatewayCode == "cybersource" || gatewayCode == "authorizenet") {
                $("#paymentcardtype").hide();
                return true;
            }
            if ($("#EnableVisa").is(":checked") == false
                && $("#EnableMasterCard").is(":checked") == false
                && $("#EnableAmericanExpress").is(":checked") == false
                && $("#EnableDiscover").is(":checked") == false) {
                $("#AcceptedCardsValidation").show();
                return false;
            }
        }
        return true;
    };
    Payment.prototype.IsMatchRegularExpressionString = function (str, regax) {
        if (str.match(regax)) {
            return true;
        }
        else {
            return false;
        }
    };
    Payment.prototype.GetPaymentGetwayForm = function (gatewayname, paymentSettingModel) {
        if (gatewayname != "" && gatewayname != "0") {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetPaymentGetwayForm(gatewayname, paymentSettingModel, function (res) {
                $("#PaymentGetwayForm-container").html(res);
                $("#PaymentGetwayForm-container").show();
                Payment.prototype.ResetGatewayForm();
                Payment.prototype.GetPaymentSettingCredentials();
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    Payment.prototype.GetPaymentSettingCredentials = function () {
        var paymentCode = $("#PaymentCode").val();
        if (paymentCode != undefined && paymentCode != "") {
            ZnodeBase.prototype.ShowLoader();
            var testMode = $("#ddlTestMode").val();
            var gatewayCode = $('#ddlPaymentGetways').val();
            var paymentType = $('#ddlPaymentTypes option:selected').attr('data-type').toLowerCase();
            var paymentTypeCode = $('#ddlPaymentTypes option:selected').val();
            if (paymentType == "amazon_pay") {
                gatewayCode = "amazon_pay";
            }
            Endpoint.prototype.GetPaymentSettingCredentials(paymentCode, testMode, gatewayCode, paymentTypeCode, function (response) {
                $("#PaymentGetwayForm-container").html(response);
                $("#PaymentGetwayForm-container").show();
                Payment.prototype.OnLoad();
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    Payment.prototype.DeleteMultiplePaymentSettings = function (control) {
        var paymentSettingIds = MediaManagerTools.prototype.unique();
        if (paymentSettingIds.length > 0) {
            Endpoint.prototype.DeleteMultiplePaymentSettings(paymentSettingIds.join(","), function (response) {
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Payment.prototype.ToggleIsPODocRequired = function () {
        var divIsPODocRequired = $("#divIsPODocRequired");
        var EnablePODocUpload = $("#IsPoDocUploadEnable").is(":checked");
        if (EnablePODocUpload) {
            divIsPODocRequired.show();
            $("#IsPoDocUploadEnable").val("true");
            var IsPODocRequired = $("#IsPoDocRequire");
            if (IsPODocRequired != null && typeof IsPODocRequired != 'undefined') {
                IsPODocRequired.is(":checked") ? IsPODocRequired.val("true") : IsPODocRequired.val("false");
            }
        }
        else {
            divIsPODocRequired.hide();
            $("#IsPoDocRequire").prop("checked", false);
            $("#IsPoDocRequire").val("false");
            $("#IsPoDocUploadEnable").val("false");
        }
    };
    Payment.prototype.PaymentCodeValidation = function () {
        $('input[id$="PaymentCode"]').blur(function () {
            Payment.prototype.PaymentCodeExist();
        });
    };
    Payment.prototype.PaymentCodeExist = function () {
        Endpoint.prototype.IsPaymentCodeExist($("#PaymentCode").val(), $("#PaymentSettingId").val(), function (response) {
            if (!response) {
                Payment.prototype.SetPaymentValidation("PaymentCode", "errorSpanPaymentCode", "AlreadyExistPaymentCode");
                return false;
            }
        });
    };
    Payment.prototype.PaymentDisplayNameValidation = function () {
        $('input[id$="PaymentDisplayName"]').blur(function () {
            Payment.prototype.IsDuplicatePaymentName();
        });
    };
    Payment.prototype.ShowBillingAddressOptional = function () {
        $("#divIsBillingAddressOptional").show();
    };
    Payment.prototype.IsDuplicatePaymentName = function () {
        Endpoint.prototype.IsPaymentDisplayNameExists($("#PaymentDisplayName").val(), $("#PaymentSettingId").val(), function (response) {
            if (!response) {
                Payment.prototype.SetPaymentValidation("PaymentDisplayName", "errorSpanPaymentDisplayName", "AlreadyExistPaymentDisplayName");
                return false;
            }
        });
    };
    Payment.prototype.ValidatePaymentCode = function () {
        var isValid = true;
        if ($("#PaymentCode").val() == '') {
            this.SetPaymentValidation("PaymentCode", "errorSpanPaymentCode", "PaymentCodeRequiredError");
            isValid = false;
        }
        else if ($("#PaymentDisplayName").val() == '') {
            this.SetPaymentValidation("PaymentDisplayName", "errorSpanPaymentDisplayName", "PaymentCodeRequiredError");
            isValid = false;
        }
        else {
            Endpoint.prototype.IsPaymentCodeExist($("#PaymentCode").val(), $("#PaymentSettingId").val(), function (response) {
                if (!response) {
                    Payment.prototype.SetPaymentValidation("PaymentCode", "errorSpanPaymentCode", "AlreadyExistPaymentCode");
                    isValid = false;
                }
            });
            Endpoint.prototype.IsPaymentDisplayNameExists($("#PaymentDisplayName").val(), $("#PaymentSettingId").val(), function (response) {
                if (!response) {
                    Payment.prototype.SetPaymentValidation("PaymentDisplayName", "errorSpanPaymentDisplayName", "AlreadyExistPaymentDisplayName");
                    isValid = false;
                }
            });
        }
        return isValid;
    };
    Payment.prototype.ResetGatewayForm = function () {
        var gatewayCode = $('#ddlPaymentGetways').val();
        if (gatewayCode == "cybersource" || gatewayCode == "authorizenet") {
            $("#paymentcardtype").hide();
        }
        else {
            $("#paymentcardtype").show();
        }
        $("#paymentPreAuthorize").show();
        if (parseInt($("#PaymentSettingId").val()) < 1) {
            $('#PreAuthorize').attr('checked', false);
            $('#EnableVisa').attr('checked', false);
            $('#EnableMasterCard').attr('checked', false);
            $('#EnableAmericanExpress').attr('checked', false);
            $('#EnableDiscover').attr('checked', false);
        }
    };
    Payment.prototype.SetPaymentValidation = function (controlId, validationControlId, errorKey) {
        $("#" + controlId).addClass("input-validation-error");
        $("#" + validationControlId).addClass("error-msg");
        $("#" + validationControlId).text(ZnodeBase.prototype.getResourceByKeyName(errorKey));
        $("#" + validationControlId).show();
    };
    Payment.prototype.SetGatewayMode = function () {
        var gatewayCode = $('#ddlPaymentGetways').val();
        if (gatewayCode == "cybersource" || gatewayCode == "paypal") {
            $("#divGatewayMode").hide();
            $("#divGatewayModeHelpText").removeClass("d-none");
        }
        else {
            $("#divGatewayMode").show();
            $("#divGatewayModeHelpText").addClass("d-none");
        }
    };
    return Payment;
}(ZnodeBase));
//# sourceMappingURL=Payment.js.map