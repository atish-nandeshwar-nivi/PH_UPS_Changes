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
var Highlight = /** @class */ (function (_super) {
    __extends(Highlight, _super);
    function Highlight() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    Highlight.prototype.Init = function () {
        var highlightTypeId = $("#ddlHighlightTypeList").val();
        Highlight.prototype.LocaleDropDownChangeForHighlight();
        Highlight.prototype.HighlightBehaviorOnChange();
        if ($("#HighlightId").val() > 0)
            $.cookie("_highLightCulture", $("#ddl_locale_list_highlight").val());
        EmailTemplate.prototype.ShowHideTemplateTokens();
    };
    Highlight.prototype.DeleteMultipleHighlight = function (control) {
        var highlightIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (highlightIds.length > 0) {
            Endpoint.prototype.DeleteMultipleHighlight(highlightIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Highlight.prototype.DisplayNotificationMessagesForHighlight = function (message, type, isFadeOut, fadeOutMilliSeconds) {
        var element = $(".highlightMessageBoxContainer");
        $(".highlightMessageBoxContainer").removeAttr("style");
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
    //function for HighlightBehavior setting on change event.
    Highlight.prototype.HighlightBehaviorOnChange = function () {
        var HandlingChargeValue = $('input[name=HighlightBehavior]:checked').val();
        if (HandlingChargeValue == "Hyperlink") {
            $('#divHyperlink').fadeIn();
            $('#divDescription').fadeOut();
            $('#IsDescription').val("false");
            $('#DisplayPopup').val("true");
        }
        else {
            if ($("#Hyperlink").hasClass('input-validation-error')) {
                $("#Hyperlink").val('');
                $("#Hyperlink").focusout();
            }
            $('#divDescription').fadeIn();
            $('#divHyperlink').fadeOut();
            $('#IsDescription').val("true");
            $('#DisplayPopup').val("false");
        }
    };
    //function for Locale on change event.
    Highlight.prototype.LocaleDropDownChangeForHighlight = function () {
        $("#ddl_locale_list_highlight").on("change", function () {
            Endpoint.prototype.EditHighlight($("#HighlightId").val(), $("#ddl_locale_list_highlight").val(), function (response) {
                $('#div_highlight_for_locale').html(response);
                $('#titleHighlightName').text($('#HighlightName').val());
                Highlight.prototype.HighlightBehaviorOnChange();
                $("#div_highlight_for_locale textarea").attr("wysiwygenabledproperty", "true");
                reInitializationMce();
                var _newUrl = MediaManagerTools.prototype.UpdateQueryString("localeId", $("#ddl_locale_list_highlight").val(), window.location.href);
                $('#tabHighlightProductList a').attr('href', '/Highlight/HighlightProductList?localeId=' + $("#ddl_locale_list_highlight").val() + '&highlightId=' + $("#HighlightId").val() + '&highlightCode=' + $("#HighlightCode").val());
                window.history.pushState({ path: _newUrl }, '', _newUrl);
            });
        });
    };
    Highlight.prototype.AddProducts = function () {
        ZnodeBase.prototype.ShowLoader();
        var ProductIds = DynamicGrid.prototype.GetMultipleSelectedIds('AssociatedProductList');
        if (ProductIds.length > 0)
            Endpoint.prototype.AssociateHighlightProductList($("#HighlightCode").val(), ProductIds, function (res) {
                Endpoint.prototype.HighlightProductList($("#LocaleId").val(), $("#HighlightId").val(), $("#HighlightCode").val(), function (response) {
                    $("#ZnodeHighlightProduct").html('');
                    $("#ZnodeHighlightProduct").html(response);
                    GridPager.prototype.UpdateHandler();
                });
                $("#divhighlightProductListPopup").hide(700);
                ZnodeBase.prototype.HideLoader();
                ZnodeBase.prototype.RemovePopupOverlay();
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        else {
            Highlight.prototype.DisplayNotificationMessagesForHighlight(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneProduct"), "error", isFadeOut, fadeOutTime);
            ZnodeBase.prototype.HideLoader();
        }
    };
    Highlight.prototype.SaveProducts = function (highlightId, ProductIds) {
        Endpoint.prototype.AssociateHighlightProductList(highlightId, ProductIds, function (res) {
            $("#ZnodeShippingSKU").html(res);
            $("#divhighlightProductListPopup").hide(700);
            window.location.href = "/Highlight/HighlightProductList?highlightId=" + highlightId + "&name=" + $("#Name").val();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
        });
    };
    Highlight.prototype.UnAssociateHighlightProduct = function (control) {
        var HighlightProductId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (HighlightProductId.length > 0) {
            Endpoint.prototype.UnAssociateHighlightProduct(HighlightProductId, $('#HighlightCode').val(), function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Highlight.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_highLightCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime }); // expires after 2 hours
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        window.location.reload();
    };
    return Highlight;
}(ZnodeBase));
//# sourceMappingURL=Highlight.js.map