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
var ZnodeNotification = /** @class */ (function (_super) {
    __extends(ZnodeNotification, _super);
    function ZnodeNotification() {
        return _super.call(this) || this;
    }
    ZnodeNotification.prototype.DisplayNotificationMessages = function () {
        var element = $(".messageBoxContainer");
        if (element.length) {
            var msgObj = element.data('message');
            if (msgObj !== "") {
                this.DisplayNotificationMessagesHelper(msgObj.Message, msgObj.Type, msgObj.IsFadeOut, msgObj.FadeOutMilliSeconds);
            }
        }
    };
    ZnodeNotification.prototype.DisplayNotificationMessagesHelper = function (message, type, isFadeOut, fadeOutMilliSeconds) {
        var element = $(".messageBoxContainer");
        $(".messageBoxContainer").removeAttr("style");
        var closeBtnHtml = "<span onclick='ZnodeNotification.prototype.CloseMessageNotificationContainer(this);' class='close pull-right right zf-close'></span>";
        $(window).scrollTop(0);
        $(document).scrollTop(0);
        if (element.length) {
            if (message !== "" && message != null) {
                element.html("<div class='message-box alert'><p class='text-center'>" + message + "</p>" + closeBtnHtml + "</div>");
                switch (type) {
                    case "success":
                        {
                            element.find('div').addClass('alert-success');
                            break;
                        }
                    case "error":
                        {
                            element.find('div').addClass('alert-danger');
                            break;
                        }
                    default:
                        {
                            element.find('div').addClass('alert-info');
                        }
                }
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
    ZnodeNotification.prototype.CloseMessageNotificationContainer = function (messageContainer) {
        $(messageContainer).parent("div").parent("div").hide();
    };
    return ZnodeNotification;
}(ZnodeBase));
//# sourceMappingURL=ZnodeNotification.js.map