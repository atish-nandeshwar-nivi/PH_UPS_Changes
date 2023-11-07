/// <reference path="../../typings/jquery/jquery.d.ts" />
/// <reference path="../../typings/jqueryui/jqueryui.d.ts" />
/// <reference path="../../typings/jquery.validation/jquery.validation.d.ts" />
/// <reference path="../../typings/jquery.cookie/jquery.cookie.d.ts" />
var isFadeOut = true;
var fadeOutTime = 10000;
var CheckBoxCollection = new Array();
var UpdateContainerId;
var ZnodeBase = /** @class */ (function () {
    function ZnodeBase() {
    }
    ZnodeBase.prototype.ajaxRequest = function (url, method, parameters, successCallback, responseType, async) {
        if (async === void 0) { async = true; }
        if (!method) {
            method = Constant.GET;
        }
        if (!responseType) {
            responseType = Constant.json;
        }
        if (typeof successCallback != Constant.Function) {
            this.errorOutfunction(ErrorMsg.CallbackFunction);
        }
        else {
            $.ajax({
                type: method,
                url: url,
                async: async,
                data: this.cachestampfunction(parameters),
                dataType: responseType,
                //NIVICODE
                beforeSend: function (xhr) {
                    if (url.indexOf(Config.APIUrl) != -1)
                        xhr.setRequestHeader("Authorization", "Basic " + btoa(Config.APIUrl + "|" + Config.APIkey));
                },
                success: function (response) {
                    successCallback(response);
                },
                error: function (xhr, thrownError) {
                    ZnodeBase.prototype.errorOutfunction(xhr.status);
                    ZnodeBase.prototype.errorOutfunction(thrownError);
                    ZnodeBase.prototype.errorOutfunction(ErrorMsg.APIEndpoint + url);
                }
            });
        }
    };
    ZnodeBase.prototype.cachestampfunction = function (data) {
        var d = new Date();
        if (typeof data == Constant.string) {
            data += "&_=" + d.getTime();
        }
        else if (typeof data == Constant.object) {
            data["_"] = d.getTime();
        }
        else {
            data = { "_": d.getTime() };
        }
        return (data);
    };
    // Error output
    ZnodeBase.prototype.errorOutfunction = function (message) {
        console.log(message);
        if (this.errorAsAlert) {
            alert(message);
        }
    };
    ZnodeBase.prototype.executeFunctionByName = function (functionName, context, args, target) {
        if (target === void 0) { target = undefined; }
        try {
            var args = [].slice.call(arguments).splice(2);
            var namespaces = functionName.split(".");
            var func = namespaces.pop();
            for (var i = 0; i < namespaces.length; i++) {
                context = context[namespaces[i]];
            }
            if (target !== undefined)
                return context[func].apply(this, args, target);
            else
                return context[func].apply(this, args);
        }
        catch (ex) {
            console.log(ErrorMsg.InvalidFunction + functionName);
        }
    };
    ZnodeBase.prototype.executeInit = function (functionName, context, args) {
        try {
            if (functionName != "Product.Init") {
                localStorage.removeItem("isFromCategoryPage");
            }
            var args = [].slice.call(arguments).splice(2);
            var namespaces = functionName.split(".");
            var func = namespaces.pop();
            for (var i = 0; i < namespaces.length; i++) {
                context = context[namespaces[i]];
            }
            var _contextObject = new context();
            return _contextObject[func].apply(this, args);
        }
        catch (ex) {
            console.log("Invalid function name " + functionName);
        }
    };
    // Onready method runs when document is loaded and ready
    ZnodeBase.prototype.onready = function () {
        // Set the controller and action names
        var modules = $("body").data("controller").split(".");
        var action = $("body").data("view");
        // Loads modules based on controller and view
        // If init() methods are present, they will be run on load
        modules.forEach(function (module) {
            if (module !== 'undefined') {
                var functionName = module + ".Init";
                ZnodeBase.prototype.executeInit(functionName, window, arguments);
            }
        });
    };
    //get cookies value by name.
    ZnodeBase.prototype.getCookie = function (cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    };
    //set cookies value
    ZnodeBase.prototype.setCookie = function (cname, cvalue, exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toUTCString();
        document.cookie = cname + "=" + cvalue + "; " + expires;
    };
    //get locale resource by key name.
    ZnodeBase.prototype.getResourceByKeyName = function (keyname) {
        var defaultculter = this.getCookie("culture");
        var resourceClassObj = Object.create(window[defaultculter].prototype);
        resourceClassObj.constructor.apply(resourceClassObj);
        return resourceClassObj[keyname];
    };
    ZnodeBase.prototype.onImageError = function () {
        jQuery('img').on('error', function (e) {
            this.src = window.location.protocol + "//" + window.location.host + "/Content/Images/no-image.png";
        });
    };
    ZnodeBase.prototype.ShowLoader = function () {
        $("#Single-loader-content-backdrop").show();
    };
    ZnodeBase.prototype.HideLoader = function () {
        $("#Single-loader-content-backdrop").hide();
    };
    ZnodeBase.prototype.IsiPad = function () {
        if ((navigator.userAgent.match(/iPad/i)) && (navigator.userAgent.match(/iPad/i) != null)) {
            var clickTimer = null;
            $(".navbar-nav li").find("a").on("click", function (e) {
                if ($(this).parent().find("ul").length > 0) {
                    e.preventDefault();
                    var control = this;
                    if (clickTimer == null) {
                        clickTimer = setTimeout(function () {
                            clickTimer = null;
                            $(control).parent().find("ul").show();
                        }, 500);
                    }
                    else {
                        clearTimeout(clickTimer);
                        clickTimer = null;
                        window.location.href = $(control).attr("href");
                    }
                }
            });
        }
    };
    //Get google geo-locator api
    ZnodeBase.prototype.GetGeoLocatorAPI = function () {
        return Constant.gocoderGoogleAPI;
    };
    //Get google geo-locator api key
    ZnodeBase.prototype.GetGeoLocatorAPIKey = function () {
        return Constant.gocoderGoogleAPIKey;
    };
    //Method to Get Parameter Values
    ZnodeBase.prototype.GetParameterValues = function (param) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var urlparam = url[i].split('=');
            if (urlparam[0] == param) {
                return urlparam[1];
            }
        }
    };
    ZnodeBase.prototype.InitializeZnodeAjaxifier = function () {
        try {
            ZnodeAjaxify.prototype.Apply();
        }
        catch (ex) { }
    };
    return ZnodeBase;
}());
$(window).on("load", function () {
    ZnodeBase.prototype.onready();
    ZnodeBase.prototype.HideLoader();
    CommonHelper.prototype.RemovePostFixAfterFacebookSocialLogin();
    ZnodeBase.prototype.IsiPad();
    ZnodeBase.prototype.InitializeZnodeAjaxifier();
});
ZnodeBase.prototype.onImageError();
$(document).off("contextmenu", "a[data-ajax=true]");
$(document).on("contextmenu", "a[data-ajax=true]", function () {
    return false;
});
//# sourceMappingURL=ZnodeGlobal.js.map