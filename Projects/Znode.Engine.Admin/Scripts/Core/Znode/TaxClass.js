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
var TaxClass = /** @class */ (function (_super) {
    __extends(TaxClass, _super);
    function TaxClass() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    TaxClass.prototype.Init = function () {
        $("#divAddSKU").modal("hide");
        TaxClass.prototype.AddRule();
    };
    TaxClass.prototype.DeleteMultipleTaxClass = function (control) {
        var taxClassIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (taxClassIds.length > 0) {
            Endpoint.prototype.DeleteMultipleTaxClass(taxClassIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    TaxClass.prototype.DeleteMultipleTaxClassSKU = function (control) {
        var taxClassSKUId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (taxClassSKUId.length > 0) {
            Endpoint.prototype.DeleteMultipleTaxClassSKU(taxClassSKUId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    TaxClass.prototype.TaxClassSKUAddResult = function (data) {
        ZnodeBase.prototype.RemovePopupOverlay();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.isSuccess ? "success" : "error", isFadeOut, fadeOutTime);
        TaxClass.prototype.TaxClassSKUList();
    };
    TaxClass.prototype.TaxClassSKUList = function () {
        Endpoint.prototype.TaxClassSKUList(parseInt($("#TaxClassId").val(), 10), $("#Name").val(), function (response) {
            $("#AssociatedSKUList").html('');
            $("#AssociatedSKUList").html(response);
            GridPager.prototype.UpdateHandler();
        });
    };
    TaxClass.prototype.DeleteMultipleTaxRule = function (control, taxClassId) {
        var taxRuleId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (taxRuleId.length > 0) {
            Endpoint.prototype.DeleteMultipleTaxRule(taxRuleId, taxClassId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    TaxClass.prototype.AddRule = function () {
        $("#addTaxRule").on("click", function () {
            var taxClassId = parseInt($("#TaxClassId").val(), 10);
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.AddTaxRule(taxClassId, function (res) {
                $("#divAddRule").show(700);
                $("#divAddRule").html(res);
                ZnodeBase.prototype.HideLoader();
                TaxClass.prototype.ShowHideContainer();
                $("body").css('overflow', 'hidden');
                $("body").append("<div class='modal-backdrop fade in'></div>");
            });
        });
    };
    TaxClass.prototype.TaxRuleAddResult = function (data) {
        $("#divAddRule").hide(700);
        ZnodeBase.prototype.RemovePopupOverlay();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.isSuccess ? "success" : "error", isFadeOut, fadeOutTime);
        TaxClass.prototype.TaxRuleList();
    };
    TaxClass.prototype.TaxRuleList = function () {
        $("#AssociatedRuleList").html(Constant.innerLoderHtml);
        Endpoint.prototype.TaxRuleList(parseInt($("#TaxClassId").val(), 10), function (response) {
            $("#AssociatedRuleList").html('');
            $("#AssociatedRuleList").html(response);
            GridPager.prototype.UpdateHandler();
        });
    };
    TaxClass.prototype.BindStateList = function (stateList, countryCode) {
        Endpoint.prototype.StateListByCountryCode(countryCode, function (response) {
            var stateSelectedVal = '';
            $('#' + stateList).empty();
            for (var i = 0; i < response.length; i++) {
                if (response[i].Value == $("#hdnStateCode").val())
                    $('#' + stateList).append("<option selected  value='" + response[i].Value + "'>" + response[i].Text + "</option>");
                else
                    $('#' + stateList).append("<option  value='" + response[i].Value + "'>" + response[i].Text + "</option>");
            }
        });
    };
    TaxClass.prototype.AddSKUs = function () {
        var CheckBoxCollection = [];
        $("div[id=AssociatedTaxClassProductList]").find("#grid").find("tr").each(function () {
            if ($(this).find(".grid-row-checkbox").length > 0) {
                if ($(this).find(".grid-row-checkbox").is(":checked")) {
                    CheckBoxCollection.push($(this).find(".grid-row-checkbox").attr("id").replace("rowcheck_", ""));
                }
            }
        });
        if (CheckBoxCollection.length > 0) {
            TaxClass.prototype.SaveSKUs($("#TaxClassId").val(), CheckBoxCollection.join(","));
            ZnodeBase.prototype.RemoveAsidePopupPanel();
        }
        else
            TaxClass.prototype.DisplayNotificationMessagesForTaxClass(ZnodeBase.prototype.getResourceByKeyName("TextSelectSKU"), "error", isFadeOut, fadeOutTime);
    };
    TaxClass.prototype.SaveSKUs = function (taxClassId, SKUs) {
        Endpoint.prototype.AddTaxClassSKUList(taxClassId, SKUs, function (res) {
            $("#ZnodeShippingSKU").html(res);
            $("#divtaxProductListPopup").hide(700);
            $(".modal-backdrop").remove();
            Endpoint.prototype.TaxClassSKUList(taxClassId, $("#Name").val(), function (response) {
                $("#AssociatedSKUList").html('');
                $("#AssociatedSKUList").html(response);
                GridPager.prototype.UpdateHandler();
            });
            ZnodeBase.prototype.RemovePopupOverlay();
            DynamicGrid.prototype.ClearCheckboxArray();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
        });
    };
    TaxClass.prototype.DisplayNotificationMessagesForTaxClass = function (message, type, isFadeOut, fadeOutMilliSeconds) {
        var element = $(".taxClassMessageBoxContainer");
        $(".taxClassMessageBoxContainer").removeAttr("style");
        $(window).scrollTop(0);
        $(document).scrollTop(0);
        if (element.length) {
            if (message !== "" && message != null) {
                element.html("<p>" + message + "</p>");
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
    TaxClass.prototype.ShowHideContainer = function () {
        var selectedText;
        selectedText = $("#ddlTaxRuleTypeList option:selected").text();
        if (selectedText == 'Sales Tax' || selectedText.indexOf('Select') > -1) {
            $(".tax-rate-class").show();
            $("#ddlCountryList").val($("#hdnCountryCode").val());
        }
        else {
            $(".tax-rate-class").hide();
            $("#ddlCountryList").val("");
        }
    };
    return TaxClass;
}(ZnodeBase));
$(document).off("click", "frmCreateEditTaxClass .z-edit");
$(document).on("click", "#frmCreateEditTaxClass .z-edit", function (e) {
    e.preventDefault();
    var listName = $(this).closest("section").attr("update-container-id");
    var taxClassId = $("#TaxClassId").val();
    if (listName === "ZnodeTaxRule") {
        var dataParam = decodeURIComponent($(this).attr("data-parameter"));
        var taxRuleId = dataParam.split('&')[0].split('=')[1];
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.EditTaxRule(taxRuleId, taxClassId, function (res) {
            $("#divAddRule").show(700);
            $("#divAddRule").html(res);
            ZnodeBase.prototype.HideLoader();
            TaxClass.prototype.ShowHideContainer();
            $("body").css('overflow', 'hidden');
            $("body").append("<div class='modal-backdrop fade in'></div>");
        });
    }
});
//# sourceMappingURL=TaxClass.js.map