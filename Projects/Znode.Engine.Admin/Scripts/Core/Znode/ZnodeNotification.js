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
    ZnodeNotification.prototype.pendingAjaxRequestsFinalized = function () {
        return !ZnodeBase.prototype.pendingAjaxRequests;
    };
    ZnodeNotification.prototype.DisplayNotificationMessages = function () {
        this.queuedNotification = function () {
            var element = $(".messageBoxContainer");
            if (element.length) {
                var msgObj = element.data('message');
                if (msgObj !== "") {
                    this.DisplayNotificationMessagesHelper(msgObj.Message, msgObj.Type, msgObj.IsFadeOut, msgObj.FadeOutMilliSeconds);
                }
            }
        };
        if (this.pendingAjaxRequestsFinalized() === true && this.queuedNotification) {
            this.queuedNotification();
            this.queuedNotification = null;
        }
    };
    ZnodeNotification.prototype.DisplayNotificationMessagesHelper = function (message, type, isFadeOut, fadeOutMilliSeconds) {
        this.queuedNotification = function () {
            var element = $(".messageBoxContainer");
            $(".messageBoxContainer").removeAttr("style");
            ZnodeNotification.prototype.BindDisplayNotificationMessage(element, message, type, fadeOutMilliSeconds);
        };
        if (this.pendingAjaxRequestsFinalized() === true && this.queuedNotification) {
            this.queuedNotification();
            this.queuedNotification = null;
        }
    };
    ZnodeNotification.prototype.DisplayNotificationMessagesHelperForAsidePanel = function (message, type, isFadeOut, fadeOutMilliSeconds) {
        this.queuedNotification = function () {
            var element = $('.panel-container').find('.error-msg');
            if (!element.length)
                element = $('.panel-container').find('.success-msg');
            $(window).scrollTop(0);
            $(document).scrollTop(0);
            if (element.length) {
                if (message !== "" && message != null) {
                    element.text(message);
                    switch (type) {
                        case "success":
                            {
                                element.removeClass('error-msg').addClass('success-msg');
                                element.parent('div').show();
                                element.show();
                                break;
                            }
                        case "error":
                            {
                                element.removeClass('success-msg').addClass('error-msg');
                                element.parent('div').show();
                                element.show();
                                break;
                            }
                        default:
                            {
                                element.addClass('alert-info');
                                element.parent('div').show();
                                element.show();
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
        if (this.pendingAjaxRequestsFinalized() === true && this.queuedNotification) {
            this.queuedNotification();
            this.queuedNotification = null;
        }
    };
    ZnodeNotification.prototype.BindDisplayNotificationMessage = function (element, message, type, fadeOutMilliSeconds) {
        var closeBtnHtml = "<span onclick='ZnodeNotification.prototype.CloseMessageNotificationContainer(this);' class='close pull-right right z-close-circle'></span>";
        if (element.length) {
            if (message !== "" && message != null) {
                element.html("<div class='message-box alert'><p class='text-center' data-test-selector='popMessageBoxContainer'>" + message + "</p>" + closeBtnHtml + "</div>");
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
                if (ZnodeBase.prototype.getBrowser() == "Chrome") {
                    $("html,body").animate({ scrollTop: 0 }, "slow");
                }
                else {
                    $(window).scrollTop(0);
                    $(document).scrollTop(0);
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