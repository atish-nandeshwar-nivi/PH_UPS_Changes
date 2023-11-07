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
var Shippings = /** @class */ (function (_super) {
    __extends(Shippings, _super);
    function Shippings() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    Shippings.prototype.Init = function () {
        Shippings.prototype.SetShippingOption($("#ddlShippingTypeList").val());
        var shippingTypeId = $("#ddlShippingTypeList").val();
        if ($("#ShippingServiceCodeId").val() > 0)
            Shippings.prototype.BindServiceList('ddlShippingServiceCodeList', shippingTypeId);
        $("#ddlShippingTypeList").on("change", function () {
            Shippings.prototype.BindServiceList('ddlShippingServiceCodeList', shippingTypeId);
            Shippings.prototype.SetShippingOption($(this).val());
        });
        if ($("#ddlShippingTypeList").val() === "ZnodeShippingCustom" && $("#ImportSkuSection")) {
            $("#ImportSkuSection").show();
        }
        else {
            $("#ImportSkuSection").hide();
            $("#importFile").val(null);
        }
        Shippings.prototype.HandlingChargeBasedOnChange();
        Shippings.prototype.SetPriceLimitVisiblity($("#ddlShippingRuleTypeList"));
        Shippings.prototype.ShippingSKUList();
        Shippings.prototype.ValidateShippingName();
        Shippings.prototype.ShowHideValidationMessage();
    };
    //Set Shipping options according to shipping type.
    Shippings.prototype.SetShippingOption = function (shippingOption) {
        switch ($.trim(shippingOption)) {
            case "ZnodeShippingCustom":
                $("#shippingname-content").show();
                $("#displayname-content").show();
                $("#displayname-content").children().children().children().prop("disabled", false);
                $("#internalcode-content").show();
                $("#internalcode-content").children().children().children().prop("disabled", false);
                $("#service-content").hide();
                $("#service-content").children().children().children().attr("disabled", "disabled");
                $("#handlingcharge-content").show();
                $("#countries-content").show();
                $("#state-content").show();
                $("#ShippingOriginZipCode-content").show();
                $("#TrackingUrl-content").show();
                $("#InternalCodeMessage").hide();
                break;
            case "ZnodeShippingFedEx":
                $("#shippingname-content").show();
                $("#displayname-content").show();
                $("#displayname-content").children().children().children().attr("disabled", false);
                $("#internalcode-content").hide();
                $("#internalcode-content").children().children().children().attr("disabled", "disabled");
                $("#service-content").show();
                $("#service-content").children().children().children().prop("disabled", false);
                $("#handlingcharge-content").show();
                $("#countries-content").show();
                $("#state-content").show();
                $("#ShippingOriginZipCode-content").show();
                $("#TrackingUrl-content").show();
                $("#InternalCodeMessage").hide();
                break;
            case "ZnodeShippingUps":
                $("#shippingname-content").show();
                $("#displayname-content").show();
                $("#displayname-content").children().children().children().attr("disabled", false);
                $("#internalcode-content").hide();
                $("#internalcode-content").children().children().children().attr("disabled", "disabled");
                $("#service-content").show();
                $("#service-content").children().children().children().prop("disabled", false);
                $("#handlingcharge-content").show();
                $("#countries-content").show();
                $("#state-content").show();
                $("#ShippingOriginZipCode-content").show();
                $("#TrackingUrl-content").show();
                $("#InternalCodeMessage").hide();
                break;
            case "ZnodeShippingUsps":
                $("#shippingname-content").show();
                $("#displayname-content").show();
                $("#displayname-content").children().children().children().attr("disabled", false);
                $("#internalcode-content").hide();
                $("#internalcode-content").children().children().children().attr("disabled", "disabled");
                $("#service-content").show();
                $("#service-content").children().children().children().prop("disabled", false);
                $("#handlingcharge-content").show();
                $("#countries-content").show();
                $("#state-content").show();
                $("#ShippingOriginZipCode-content").show();
                $("#TrackingUrl-content").show();
                $("#InternalCodeMessage").hide();
                break;
            case Constant.ZnodeCustomerShipping:
                $("#shippingname-content").show();
                $("#displayname-content").show();
                $("#displayname-content").children().children().children().prop("disabled", false);
                $("#internalcode-content").show();
                $("#internalcode-content").children().children().children().prop("disabled", false);
                $("#service-content").hide();
                $("#service-content").children().children().children().attr("disabled", "disabled");
                $("#handlingcharge-content").hide();
                $("#countries-content").show();
                $("#state-content").hide();
                $("#ShippingOriginZipCode-content").hide();
                $("#TrackingUrl-content").hide();
                break;
            default:
                $("#shippingname-content").show();
                $("#displayname-content").show();
                $("#displayname-content").children().children().children().prop("disabled", false);
                $("#internalcode-content").show();
                $("#internalcode-content").children().children().children().prop("disabled", false);
                $("#service-content").hide();
                $("#service-content").children().children().children().attr("disabled", "disabled");
                $("#handlingcharge-content").show();
                $("#countries-content").show();
                $("#state-content").show();
                $("#ShippingOriginZipCode-content").show();
                $("#TrackingUrl-content").show();
                $("#InternalCodeMessage").hide();
        }
    };
    //Set price limit according to shipping rule type.
    Shippings.prototype.SetPriceLimitVisiblity = function (shippingRuleType) {
        switch ($("option:selected", shippingRuleType).val()) {
            case "FlatRatePerItem":
                $("#setpricing").show();
                $("#peritemcost-content").show();
                $("#LowerLimit").val("0");
                $("#UpperLimit").val("0");
                $("#valUpperLimit").val("0");
                $("#valLowerLimit").val("0");
                $("#enterlimitsfortieredpricing").hide();
                break;
            case "QuantityBasedRate":
                $("#setpricing").show();
                $("#peritemcost-content").show();
                $("#enterlimitsfortieredpricing").show();
                break;
            case "WeightBasedRate":
                $("#setpricing").show();
                $("#peritemcost-content").show();
                $("#enterlimitsfortieredpricing").show();
                break;
            case "FixedRatePerItem":
                $("#setpricing").show();
                $("#peritemcost-content").hide();
                $("#valPerItemCost").val("0");
                $("#LowerLimit").val("0");
                $("#UpperLimit").val("0");
                $("#valUpperLimit").val("0");
                $("#valLowerLimit").val("0");
                $("#enterlimitsfortieredpricing").hide();
                break;
            default:
                $("#setpricing").hide();
                $("#enterlimitsfortieredpricing").hide();
        }
    };
    //Delete multiple shipping.
    Shippings.prototype.DeleteMultipleShipping = function (control) {
        var shippingIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (shippingIds.length > 0) {
            Endpoint.prototype.DeleteMultipleShipping(shippingIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Shows or Hides validation message for Display Name and Internal Code
    Shippings.prototype.ShowHideValidationMessage = function () {
        $("#valDisplayName").on("blur", function () {
            if ($("#valDisplayName").val() != "")
                Products.prototype.HideErrorMessage($("#valDisplayName"), $("#valDisplayNameErr"));
            else
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("EnterShippingOptionName"), $("#valDisplayName"), $("#valDisplayNameErr"));
        });
        $("#valInternalCode").on("blur", function () {
            if ($("#valInternalCode").val() != "")
                Products.prototype.HideErrorMessage($("#valInternalCode"), $("#valInternalCodeErr"));
            else
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("EnterShippingCode"), $("#valInternalCode"), $("#valInternalCodeErr"));
        });
    };
    //Validation for shipping service code.
    Shippings.prototype.ValidationForShippingServiceCode = function () {
        if ($("#ddlShippingTypeList").val() === "ZnodeShippingFedEx" || $("#ddlShippingTypeList").val() === "ZnodeShippingUps") {
            if ($("#ddlShippingServiceCodeList").val() === "") {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("SelectShippingServiceCode"), $("#ddlShippingServiceCodeList"), $("#ddlShippingServiceCode"));
                return false;
            }
        }
        Products.prototype.HideErrorMessage($("#ddlShippingServiceCodeList"), $("#ddlShippingServiceCode"));
        return true;
    };
    //Custom validation for different shipping options. 
    Shippings.prototype.ValidationAttributesForShippingOption = function () {
        var displayNameflag = true, internalCodeflag = true, flag = false;
        if ($('#valDisplayName').is(':visible') && $('#valInternalCode').is(':visible')) {
            var displayName = $("#valDisplayName").val();
            if (displayName.length < 1) {
                $("#valDisplayNameErr").html(ZnodeBase.prototype.getResourceByKeyName("EnterShippingOptionName"));
                displayNameflag = false;
            }
            else
                $("#valDisplayNameErr").html("");
            var internalCode = $("#valInternalCode").val();
            if (internalCode.length < 1) {
                $("#valInternalCodeErr").html(ZnodeBase.prototype.getResourceByKeyName("EnterShippingCode"));
                internalCodeflag = false;
            }
            else
                $("#valInternalCodeErr").html("");
        }
        if ($("#ddlShippingTypeList").val() === "ZnodeShippingFedEx" || $("#ddlShippingTypeList").val() === "ZnodeShippingUps") {
            flag = Shippings.prototype.ValidationForShippingServiceCode();
        }
        if ((displayNameflag == true && internalCodeflag == true) || flag)
            flag = Shippings.prototype.ValidateHandlingCharges();
        return flag;
    };
    //Validation for handling charges.
    Shippings.prototype.ValidateHandlingCharges = function () {
        var handlingChargeValue = $("#HandlingCharge").val();
        var handlingChargeBasedOn = $('input[name=HandlingChargeBasedOn]:checked').val();
        if (handlingChargeBasedOn === "Shipping" || handlingChargeBasedOn === "SubTotal") {
            if (handlingChargeValue < 0 || handlingChargeValue > 100) {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("InvalidPercentageHandlingCharges"), $("#HandlingCharge"), $("#valHandlingCharges"));
                return false;
            }
            else {
                Products.prototype.HideErrorMessage($("#HandlingCharge"), $("#valHandlingCharges"));
                return true;
            }
        }
        else {
            if (handlingChargeValue < 0 || handlingChargeValue > 9999) {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("InvalidAmountHandlingCharges"), $("#HandlingCharge"), $("#valHandlingCharges"));
                return false;
            }
            else {
                Products.prototype.HideErrorMessage($("#HandlingCharge"), $("#valHandlingCharges"));
                return true;
            }
        }
    };
    //Bind shipping service code for all shipping type. 
    Shippings.prototype.BindServiceList = function (ddlShippingServiceCodeList, serviceShippingTypeId) {
        var id = $("#ddlShippingTypeList").val();
        if (id !== undefined) {
            Endpoint.prototype.getServiceListByShippingTypeId(id, function (response) {
                $('#' + ddlShippingServiceCodeList).empty();
                $('#' + ddlShippingServiceCodeList).append("<option value=" + "" + ">" + ZnodeBase.prototype.getResourceByKeyName("ShippingServiceCodeDefaultValue") + "</option>");
                for (var i = 0; i < response.length; i++) {
                    if (parseInt(response[i].Value) > 0) {
                        var defaultValue = parseInt(response[i].Value) - 1;
                        $('#' + ddlShippingServiceCodeList).append("<option value=" + response[i].Value + ">" + response[i].Text + "</option>");
                    }
                    else {
                        $('#' + ddlShippingServiceCodeList).append("<option value=" + response[i].Value + ">" + response[i].Text + "</option>");
                    }
                }
                var selectedValue = $("#ShippingServiceCodeId").val();
                if (parseInt(selectedValue) !== 0)
                    $('#' + ddlShippingServiceCodeList).val(selectedValue);
                if (response.length < 1)
                    $('#' + ddlShippingServiceCodeList);
            });
        }
        if ($("#ddlShippingTypeList").val() === "ZnodeShippingCustom" && $("#ImportSkuSection")) {
            $("#ImportSkuSection").show();
        }
        else {
            $("#ImportSkuSection").hide();
            $("#importFile").val(null);
        }
    };
    //Get shipping sku list(product list).
    Shippings.prototype.ShippingSKUList = function () {
        $("#AssociatedSKUList").html(Constant.innerLoderHtml);
        Endpoint.prototype.ShippingSKUList(parseInt($("#ShippingId").val(), 10), parseInt($("#ShippingRuleId").val(), 10), $("#ShippingRuleTypeCode").val(), function (response) {
            $("#AssociatedSKUList").html('');
            $("#AssociatedSKUList").html(response);
            GridPager.prototype.UpdateHandler();
        });
    };
    //Delete shipping rules.
    Shippings.prototype.DeleteMultipleShippingRule = function (control, shippingId) {
        var shippingRuleId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (shippingRuleId.length > 0) {
            Endpoint.prototype.DeleteMultipleShippingRule(shippingRuleId, shippingId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Add shipping rule.
    Shippings.prototype.AddRule = function () {
        var shippingId = parseInt($("#hdnShippingId").val(), 10);
        Endpoint.prototype.AddShippingRule(shippingId, function (res) {
            $("#divAddRule").html(res);
            if ($("#ShippingRuleTypeListCount").val() <= 0)
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorRuleTypeAlreadyAssociated"), "error", isFadeOut, fadeOutTime);
            else
                $("#divAddRule").modal("show");
        });
    };
    //Call back funcation: show notification message.
    Shippings.prototype.ShippingRuleAddResult = function (data) {
        $("#divAddRule").modal("hide");
        window.location.href = window.location.href.replace('#', '');
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.isSuccess ? "success" : "error", true, fadeOutTime);
        GridPager.prototype.UpdateHandler();
    };
    //Get shipping rule list.
    Shippings.prototype.ShippingRuleList = function () {
        Endpoint.prototype.ShippingRuleList(parseInt($("#ShippingId").val(), 10), function (response) {
            $("#AssociatedRuleList").html('');
            $("#AssociatedRuleList").html(response);
            GridPager.prototype.UpdateHandler();
        });
    };
    //Bind state list bu country code.
    Shippings.prototype.BindStateList = function () {
        var countryCode = $("#ddlCountryList option:selected").val();
        Endpoint.prototype.ShippingStateListByCountryCode(countryCode, function (response) {
            $('#ddlStateList').html("");
            $.each(response, function (i, item) {
                $('#ddlStateList').append("<option value='" + item.Value + "' > " + item.Text + " </option>");
            });
        });
    };
    //Display notification message.
    Shippings.prototype.DisplayNotificationMessagesForShipping = function (message, type, isFadeOut, fadeOutMilliSeconds) {
        var element = $(".shippingMessageBoxContainer");
        $(".shippingMessageBoxContainer").removeAttr("style");
        $(window).scrollTop(0);
        $(document).scrollTop(0);
        if (element.length) {
            if (message !== "" && message != null) {
                element.html("<p class='pull-left'>" + message + "</p>");
                element.find('p').addClass('error-msg');
                if (isFadeOut == null || typeof isFadeOut === "undefined")
                    isFadeOut = true;
                if (fadeOutMilliSeconds == null || typeof fadeOutMilliSeconds === "undefined")
                    fadeOutMilliSeconds = 10000;
                if (isFadeOut == true) {
                    setTimeout(function () {
                        element.fadeOut().empty();
                    }, fadeOutMilliSeconds);
                }
            }
        }
    };
    //function for currency symbol and percentage symbol setting on change event.
    Shippings.prototype.HandlingChargeBasedOnChange = function () {
        var HandlingChargeValue = $('input[name=HandlingChargeBasedOn]:checked').val();
        if (HandlingChargeValue == "Amount") {
            $("div#currencyDropdown").show();
            $('#divIcon i').hide();
        }
        else {
            $("div#currencyDropdown").hide();
            $('#divIcon i').show();
            $('#divIcon').removeClass("left-inner-icon");
            $('#divIcon').addClass("right-inner-icon");
            $('#divIcon i').text("%");
        }
    };
    //Check lower and upper limit value.
    Shippings.prototype.CheckMinMaxValue = function () {
        var _lowerLimit = parseFloat($('#valLowerLimit').val());
        var _upperLimit = parseFloat($('#valUpperLimit').val());
        if (($('#valLowerLimit').val() != '') && ($('#valUpperLimit').val() != '')) {
            if (_lowerLimit > _upperLimit) {
                $('#_validationMessageForLowerLimit').removeClass("text-danger field-validation-valid");
                $('#_validationMessageForUpperLimit').removeClass("text-danger field-validation-valid");
                $('#valUpperLimit').addClass("input-validation-error");
                $('#valLowerLimit').addClass("input-validation-error");
                $('#_validationMessageForLowerLimit').addClass("text-danger field-validation-error");
                $('#_validationMessageForUpperLimit').addClass("text-danger field-validation-error");
                $('#_validationMessageForUpperLimit').text(ZnodeBase.prototype.getResourceByKeyName("UpperLimitGreaterThanOrEqualsToLowerLimit"));
                $('#_validationMessageForLowerLimit').text(ZnodeBase.prototype.getResourceByKeyName("LowerLimitLowerThanOrEqualsToUpperLimit"));
                return false;
            }
            else {
                $('#_validationMessageForLowerLimit').addClass("text-danger field-validation-valid");
                $('#_validationMessageForUpperLimit').addClass("text-danger field-validation-valid");
                $('#valUpperLimit').removeClass("input-validation-error");
                $('#valLowerLimit').removeClass("input-validation-error");
                $('#_validationMessageForLowerLimit').removeClass("text-danger field-validation-error");
                $('#_validationMessageForUpperLimit').removeClass("text-danger field-validation-error");
                $('#_validationMessageForUpperLimit').text("");
                $('#_validationMessageForLowerLimit').text("");
                return true;
            }
        }
    };
    Shippings.prototype.ValidateShipping = function () {
        var IsValid = false;
        if (Shippings.prototype.ValidationAttributesForShippingOption())
            return Shippings.prototype.ShippingNameValidation();
        return IsValid;
    };
    Shippings.prototype.ValidateShippingName = function () {
        $("#ShippingName").on("blur", function () {
            Shippings.prototype.ShippingNameValidation();
        });
    };
    Shippings.prototype.ShippingNameValidation = function () {
        var isValid = true;
        if ($("#ShippingName").val() == '') {
            $("#ShippingName").addClass("input-validation-error");
            $("#errorSpanShippingName").addClass("error-msg");
            $("#errorSpanShippingName").text(ZnodeBase.prototype.getResourceByKeyName("ShippingNameRequiredError"));
            $("#errorSpanShippingName").show();
        }
        else {
            Endpoint.prototype.IsShippingNameExist($("#ShippingName").val(), $("#ShippingId").val(), function (response) {
                if (!response) {
                    $("#ShippingName").addClass("input-validation-error");
                    $("#errorSpanShippingName").addClass("error-msg");
                    $("#errorSpanShippingName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistShippingName"));
                    $("#errorSpanShippingName").show();
                    isValid = false;
                }
            });
        }
        return isValid;
    };
    return Shippings;
}(ZnodeBase));
//# sourceMappingURL=Shippings.js.map