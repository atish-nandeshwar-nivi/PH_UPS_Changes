/// <reference path="../../typings/jquery.cookie/jquery.cookie.d.ts" />
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
var CommonHelper = /** @class */ (function (_super) {
    __extends(CommonHelper, _super);
    function CommonHelper() {
        return _super.call(this) || this;
    }
    CommonHelper.prototype.BlockHtmlTagForTextBox = function () {
        /* validated all text box in project*/
        $(':input').not('.AllowHtml').on("paste keypress change", function (e) {
            if ($(this).val().indexOf("~") != -1) {
                var _inputValue = CommonHelper.prototype.Removetildslashfromstring($(this).val(), "~");
                $(this).val(_inputValue);
            }
            if ($(this).val().indexOf("<") != -1) {
                var _inputValue = CommonHelper.prototype.Removetildslashfromstring($(this).val(), "<");
                $(this).val(_inputValue);
            }
            if ($(this).val().indexOf(">") != -1) {
                var _inputValue = CommonHelper.prototype.Removetildslashfromstring($(this).val(), ">");
                $(this).val(_inputValue);
            }
            /*new validation*/
            var key = [e.keyCode || e.which];
            if (key[0] != undefined) {
                if ((key == null) || (key[0] == 0) || (key[0] == 126) || (key[0] == 60) || (key[0] == 62)) {
                    return false;
                }
            }
        });
        /* validated all text box in project*/
        $(':input').not('.AllowHtml').on("paste", function (e) {
            if ($(this).attr('data-datype') === "Int32" || $(this).attr('data-datype') === "Decimal") {
                return false;
            }
        });
        $(":input").not('.AllowHtml').on("keypress", function (e) {
            if (e.which === 32 && !this.value.length)
                e.preventDefault();
        });
    };
    CommonHelper.prototype.Removetildslashfromstring = function (str, char) {
        var notildslash = "";
        var newstr = str.split(char);
        for (var i = 0; i < newstr.length; i++) {
            notildslash += newstr[i];
        }
        return notildslash;
    };
    CommonHelper.prototype.Validate = function () {
        var Locales = [];
        $(".LocaleLabel").each(function () {
            Locales.push($(this).attr('localename'));
        });
        var flag = true;
        for (var i = 0; i < Locales.length; i++) {
            var value = $("#Locale" + Locales[i]).val();
            if (value.length > 100) {
                $("#error" + Locales[i]).html("Error");
                flag = false;
            }
        }
        return flag;
    };
    CommonHelper.prototype.GetAjaxHeaders = function (callBackFUnction) {
        return Endpoint.prototype.GetAjaxHeaders(callBackFUnction);
    };
    CommonHelper.prototype.GetPaymentAppHeader = function (callBackFUnction) {
        var paymentApiHeaderResponseValue = $("#hdnPaymentApiResponseHeader").val();
        if (paymentApiHeaderResponseValue) {
            var response = {};
            response["Authorization"] = paymentApiHeaderResponseValue;
            return callBackFUnction(response);
        }
        return Endpoint.prototype.GetPaymentAppHeader(callBackFUnction);
    };
    CommonHelper.prototype.RemovePostFixAfterFacebookSocialLogin = function () {
        if (window.location.hash && window.location.hash == '#_=_') {
            if (window.history && history.pushState) {
                window.history.pushState("", document.title, window.location.pathname + window.location.search);
            }
        }
    };
    return CommonHelper;
}(ZnodeBase));
$(document).on("paste keypress change", ":input", function (e) {
    if ($(this).val().indexOf("~") != -1) {
        var _inputValue = CommonHelper.prototype.Removetildslashfromstring($(this).val(), "~");
        $(this).val(_inputValue);
    }
    if ($(this).val().indexOf("<") != -1) {
        var _inputValue = CommonHelper.prototype.Removetildslashfromstring($(this).val(), "<");
        $(this).val(_inputValue);
    }
    if ($(this).val().indexOf(">") != -1) {
        var _inputValue = CommonHelper.prototype.Removetildslashfromstring($(this).val(), ">");
        $(this).val(_inputValue);
    }
    /*new validation*/
    var key = [e.keyCode || e.which];
    if (key[0] != undefined) {
        if ((key == null) || (key[0] == 0) || (key[0] == 126) || (key[0] == 60) || (key[0] == 62)) {
            return false;
        }
    }
});
$(document).ajaxError(function (e, jqxhr, settings, exception) {
    e.stopPropagation();
    if (jqxhr != null) {
        if (jqxhr.status === 403) {
            if (jqxhr.statusText != undefined) {
                window.location.href = "/User/Login?returnUrl=" + jqxhr.statusText;
            }
            else
                window.location.reload();
        }
    }
});
$('.noSubmitOnEnterKeyPress').on('keyup keypress', function (e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode === 13) {
        e.preventDefault();
        return false;
    }
});
$(document).off("change", "#ddlCulture");
$(document).on("change", "#ddlCulture", function () {
    $(this).closest("form").submit();
});
$.ajaxSetup({
    error: function (x, e) {
        if (x.status === 403) {
            if (x.statusText != undefined) {
                window.location.href = "/User/Login?returnUrl=" + x.statusText;
            }
            else
                window.location.reload();
        }
    }
});
//# sourceMappingURL=ZnodeHelper.js.map