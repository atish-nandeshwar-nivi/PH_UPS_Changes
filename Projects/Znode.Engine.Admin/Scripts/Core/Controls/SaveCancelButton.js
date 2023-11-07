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
var SaveCancel = /** @class */ (function (_super) {
    __extends(SaveCancel, _super);
    function SaveCancel() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    SaveCancel.prototype.SubmitForm = function (formid, callback, backURL) {
        ZnodeBase.prototype.ShowLoader();
        if (!$("#" + formid).valid() && $(".ui-tabs").length > 0) {
            if ($("#" + formid + " .input-validation-error").closest(".ui-tabs-panel").length > 0) {
                var tabId = $("#" + formid + " .input-validation-error").closest(".ui-tabs-panel").get(0).id;
                $(".ui-tabs ul").find("[aria-controls='" + tabId + "']").find('a').click();
            }
        }
        ZnodeBase.prototype.setCookie("CurrentUrl", window.location.href, 1);
        if (typeof (backURL) != "undefined" && $("#" + formid).valid())
            $.cookie("_backURL", backURL, { path: '/' });
        if (typeof callback !== 'undefined' && callback != null && callback !== "") {
            var checkStatus;
            var boolResult = ZnodeBase.prototype.executeFunctionByName(callback, window, null);
            if (!boolResult) {
                ZnodeBase.prototype.HideLoader();
                return;
            }
        }
        $('#' + formid).submit();
        ZnodeBase.prototype.HideLoader();
    };
    SaveCancel.prototype.Cancel = function () {
        if (document.referrer.indexOf(window.location.hostname) != -1) {
            var referrer = document.referrer;
            if (referrer.indexOf("returnUrl") >= 0) {
                window.location.href = '/Dashboard/Dashboard';
            }
            else {
                window.location.replace(referrer);
            }
        }
        else {
            window.location.href = '/Dashboard/Dashboard';
        }
    };
    return SaveCancel;
}(ZnodeBase));
//# sourceMappingURL=SaveCancelButton.js.map