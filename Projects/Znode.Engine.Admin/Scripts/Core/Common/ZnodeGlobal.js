/// <reference path="../../typings/jquery/jquery.d.ts" />
/// <reference path="../../typings/jqueryui/jqueryui.d.ts" />
/// <reference path="../../typings/jquery.validation/jquery.validation.d.ts" />
var isFadeOut = true;
var fadeOutTime = 10000;
var CheckBoxCollection = new Array();
var UpdateContainerId;
var _document;
var showGlobalLoader = true;
var ZnodeBase = /** @class */ (function () {
    function ZnodeBase() {
        this.pendingAjaxRequests = false;
    }
    ZnodeBase.prototype.ajaxRequest = function (url, method, parameters, successCallback, responseType, async, globalLoader) {
        if (async === void 0) { async = true; }
        if (globalLoader === void 0) { globalLoader = true; }
        /* loader hide and show depends on "showGlobalLoader" variable.
         * It is now updated from the request parameter.
         * Default value of this variable will be true */
        showGlobalLoader = globalLoader;
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
                success: function (response) {
                    successCallback(response);
                },
                error: function () {
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
    };
    /*
     *Validate Whether Code Field Already Exists or not
     *{param}{string}{selector} - selector of field to validate
     *{param}{string}{CodeFieldValue} - previously stored code field for manage
     *{param}{string}{url} - url to validate code field
     *{return}{boolean} - if true then code field is unique
    */
    ZnodeBase.prototype.ValidateCodeField = function (selector, codeFieldValue, url) {
        var currentSelector = $(selector);
        var storeCode = currentSelector.val();
        var isValid = true;
        if (storeCode && storeCode != codeFieldValue) {
            return ZnodeBase.prototype.CheckCodeExist(selector, url);
        }
        return isValid;
    };
    ZnodeBase.prototype.CheckCodeExist = function (selector, url) {
        var isValid = true;
        var currentSelector = $(selector);
        var storeCode = currentSelector.val();
        Endpoint.prototype.CheckCodeExists(url, storeCode, function (response) {
            if (!response["isExist"]) {
                currentSelector.addClass('input-validation-error');
                currentSelector.removeClass('dirty valid');
                currentSelector.next().show();
                currentSelector.next().text(response["message"]);
                currentSelector.next().addClass('field-validation-error');
                isValid = false;
                $('#frmCopyStore') ? $('#frmCopyStore').attr('onsubmit', 'return false') : ""; //Stop Submit on Copy
                return false;
            }
        });
        return isValid;
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
            console.log(ErrorMsg.InvalidFunction + functionName);
        }
    };
    // In an array of Name-Value pairs, merge values for all the items together and concate in a comma separated string.
    ZnodeBase.prototype.mergeNameValuePairsToString = function (nameValueCollection) {
        var result = '';
        if (nameValueCollection && nameValueCollection.length > 0) {
            for (var _i = 0, nameValueCollection_1 = nameValueCollection; _i < nameValueCollection_1.length; _i++) {
                var nameValuePair = nameValueCollection_1[_i];
                if (result.length > 0)
                    result += ',' + nameValuePair.value;
                else
                    result = nameValuePair.value;
            }
            return result;
        }
        else
            return null;
    };
    // In an array of Name-Value pairs, merge values for all the items together and concate in a comma separated string.
    ZnodeBase.prototype.mergeNameValuePairsToArray = function (nameValueCollection) {
        var result = [];
        if (nameValueCollection && nameValueCollection.length > 0) {
            for (var _i = 0, nameValueCollection_2 = nameValueCollection; _i < nameValueCollection_2.length; _i++) {
                var nameValuePair = nameValueCollection_2[_i];
                result.push(nameValuePair.value);
            }
            return result;
        }
        else
            return null;
    };
    // Onready method runs when document is loaded and ready
    ZnodeBase.prototype.onready = function () {
        // Set the controller and action names
        var modules = $("body").data("controller").split(".");
        // Loads modules based on controller and view
        // If init() methods are present, they will be run on load
        modules.forEach(function (module) {
            if (module !== 'undefined') {
                var functionName = module + ".Init";
                ZnodeBase.prototype.executeInit(functionName, window, arguments);
            }
        });
        //Bootstrap ToolTip Call
        $('[data-toggle="tooltip"]').tooltip({ trigger: 'hover', html: true });
        $(document).on("click", "#slide-menu", function () {
            $("i", this).toggleClass("z-left-collaps-arrow z-right-collaps-arrow");
            $(this).toggleClass("active");
            $("body").toggleClass("nav-open");
        });
        $("#popclose").on("click", function () {
            $('#aside-popup-datacontainer').html('');
            $("#aside-popup-main").hide();
        });
        $('body').addClass(localStorage.getItem("asidepanel"));
        InitializeDirtyForm();
    };
    //Aside panel tab selection 
    ZnodeBase.prototype.activeAsidePannel = function () {
        var status = 0;
        var redirecturl = window.location.href;
        redirecturl = decodeURIComponent(redirecturl);
        var originurl = document.location.origin;
        var matchingUrl = redirecturl.replace(originurl, '');
        matchingUrl = decodeURIComponent(matchingUrl);
        $('.aside-panel li a.active').removeClass('active');
        $(".aside-panel li").each(function () {
            if (($.trim($(this).find('a').attr('href')).toLowerCase() == $.trim(matchingUrl).toLowerCase()
                || $.trim($(this).find('a').attr('href') + '#').toLowerCase() == $.trim(matchingUrl).toLowerCase())
                || $.trim($(this).find('a').attr('href')).toLowerCase() == $.trim(matchingUrl).split('?')[0].toLowerCase()) {
                $(this).find('a').addClass('active');
                status = 1;
            }
        });
        if (status === 0) {
            var dataView = $("body").data("view");
            $(".aside-panel li").each(function () {
                if ($(this).find('a').attr('href') != undefined && $(this).find('a').attr('href') != "") {
                    var originurlArray = $(this).find('a').attr('href').split('/');
                    var actionName;
                    if (originurlArray != undefined && originurlArray.length > 1) {
                        if (originurlArray.length > 0 && originurlArray.length <= 3)
                            actionName = originurlArray[2].split("?")[0];
                        else
                            actionName = originurlArray[3].split("?")[0];
                        if (actionName != undefined && actionName != "") {
                            if (actionName === dataView) {
                                $(this).find('a').addClass('active');
                                status = 1;
                            }
                        }
                    }
                }
            });
        }
    };
    ZnodeBase.prototype.OnImgError = function () {
        jQuery('img').on('error', function (e) {
            if ($(this).is(":visible"))
                this.src = window.location.protocol + "//" + window.location.host + "/Content/Images/no-image.png";
        });
    };
    //Return current browser name
    ZnodeBase.prototype.getBrowser = function () {
        var userAgent = navigator.userAgent;
        if (this.detectIE(userAgent))
            return "IE";
        else if (userAgent.indexOf('Chrome') >= 0)
            return "Chrome";
        else if (userAgent.indexOf('Firefox') >= 0)
            return "Firefox";
        else if (userAgent.indexOf('Safari') >= 0)
            return "Safari";
        else if (userAgent.indexOf('Opera') >= 0)
            return "Opera";
    };
    //Detect IE browser
    ZnodeBase.prototype.detectIE = function (userAgent) {
        var msie = userAgent.indexOf('MSIE');
        if (msie > 0) {
            // IE 10 
            return true;
        }
        var trident = userAgent.indexOf('Trident/');
        if (trident > 0) {
            // IE 11 
            return true;
        }
        var edge = userAgent.indexOf('Edge/');
        if (edge > 0) {
            // Edge (IE 12+)
            return true;
        }
        return false;
    };
    ZnodeBase.prototype.SetNoImageForList = function () {
        jQuery('img').each(function (e) {
            if ($(this).attr('src') == "")
                this.src = window.location.protocol + "//" + window.location.host + "/Content/Images/no-image.png";
        });
    };
    //Aside panel tab selection 
    ZnodeBase.prototype.activeAsidePannelAjax = function (element) {
        $('.aside-panel li a').removeClass('active');
        $(element).addClass('active');
    };
    //get locale resource by key name.
    ZnodeBase.prototype.getResourceByKeyName = function (keyname) {
        try {
            var defaultculter = ZnodeBase.prototype.getCookie("culture");
            var resourceClassObj = Object.create(window[defaultculter].prototype);
            resourceClassObj.constructor.apply(resourceClassObj);
            return resourceClassObj[keyname];
        }
        catch (ex) {
            console.log(ex);
        }
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
    ZnodeBase.prototype.showDeleteStatus = function (response) {
        var pageIndex = $("#PageIndex").val();
        var currentPageNumber;
        if ($("#grid").find("tr").not(".grid-header").length == 1 && pageIndex > 0) {
            currentPageNumber = parseInt(pageIndex.toString());
        }
        else {
            currentPageNumber = parseInt(pageIndex.toString()) + 1;
        }
        var url = GridPager.prototype.GetRedirectUrl();
        var _customUri = new CustomJurl();
        var newUrlParameter = _customUri.setQueryParameter(PageFieldName, currentPageNumber);
        var newUrl = _customUri.build(url, newUrlParameter);
        GridPager.prototype.pagingUrlHandler(newUrl);
        ZnodeBase.prototype.HideLoader();
        $('.modal-backdrop').remove();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
    };
    ZnodeBase.prototype.RemovePopupOverlay = function () {
        //Below code is used to close the overlay of popup, as it was not closed in server because container is updated by Ajax call
        $("body").css('overflow', 'auto');
        $('.modal-backdrop').fadeOut(400);
    };
    //Aside PopUp Panel Function.
    ZnodeBase.prototype.BrowseAsidePoupPanel = function (url, targetDiv) {
        $("#" + targetDiv).slideDown();
        $("body").css('overflow', 'hidden');
        ZnodeBase.prototype.HideLoader();
        $("body").append("<div class='modal-backdrop fade in'></div>");
        Endpoint.prototype.GetPartial(url, function (response) {
            $("#" + targetDiv).html('');
            $("#" + targetDiv).append(response);
            GridPager.prototype.Init();
            $('.mceEditor').attr('wysiwygenabledproperty', 'true');
            reInitializationMce();
            if (targetDiv == "productDetailsPanel" && window.location.href.toLowerCase().indexOf("order") > -1) {
                if ($("#productDetailsPanel").text().trim().length > 0) {
                    $(".header-check-all").change();
                }
            }
            //trigger Event PARTIAL_LOADED - It tells BrowseAsidePoupPanel is loaded successfully.
            $(document).trigger("PARTIAL_LOADED", [url]);
        });
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    //Aside PopUp Panel Function.
    ZnodeBase.prototype.BrowseAsidePoupPanelWithCallBack = function (url, targetDiv, callbackMethod) {
        $("#" + targetDiv).slideDown();
        $("body").css('overflow', 'hidden');
        ZnodeBase.prototype.HideLoader();
        $("body").append("<div class='modal-backdrop fade in'></div>");
        Endpoint.prototype.GetPartial(url, function (response) {
            $("#" + targetDiv).html('');
            $("#" + targetDiv).append(response);
            GridPager.prototype.Init();
            $('.mceEditor').attr('wysiwygenabledproperty', 'true');
            reInitializationMce();
            callbackMethod(response);
        });
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    ZnodeBase.prototype.CancelUpload = function (targetDiv) {
        if ($(".add-to-cart-popover").html() != null && $(".add-to-cart-popover").html() != undefined && $(".add-to-cart-popover").html() != "")
            $(".add-to-cart-popover").remove();
        $("#" + targetDiv).html('');
        $("#" + targetDiv).slideUp().hide();
        if (targetDiv != 'getProductDetail')
            $("#globalfiltercolumn").val("");
        $("body").css('overflow', 'auto');
        ZnodeBase.prototype.RemovePopupOverlay();
    };
    ZnodeBase.prototype.ResetTabDetails = function () {
        localStorage['activetab'] = 0;
        localStorage['CurrentUrl'] = "";
    };
    //Handel change event of ddlCulture dropdown
    ZnodeBase.prototype.ChangeCultureDropdown = function (control) {
        //Set name of culture 
        $("#ddlCultureSpan").text(control.text);
        $("#ddlCultureSpan").attr("data-value", $(control).attr('data-value'));
        if (CheckDirty())
            event.preventDefault();
        // Set the controller and action names
        var modules = $("body").data("controller").split(".");
        // DdlCultureChange() methods will be run.
        modules.forEach(function (module) {
            if (module !== 'undefined') {
                var functionName = module + ".DdlCultureChange";
                ZnodeBase.prototype.executeInit(functionName, window, arguments);
            }
        });
    };
    ZnodeBase.prototype.ShowLoader = function () {
        $("#loading-div-background").show();
    };
    ZnodeBase.prototype.HideLoader = function () {
        $("#loading-div-background").hide();
    };
    //Set expiry time for cookies for 2 hours.
    ZnodeBase.prototype.SetCookiesExpiry = function () {
        var date = new Date();
        date.setTime(date.getTime() + (120 * 60 * 1000)); // (minutes * second * Miliseconds)
        return date;
    };
    //Show active menu in parent menu list.
    ZnodeBase.prototype.ShowActiveMenu = function () {
        $('#nav-menu li').removeClass('current-page');
        $(".sub-menu").each(function () {
            var parentMenuId = $(this).attr('id');
            $("#nav-menu li a").each(function () {
                if ($(this).attr('id') === parentMenuId) {
                    $(this).closest('li').addClass('current-page');
                }
            });
        });
    };
    //Add class for image column.
    ZnodeBase.prototype.AddClassToImageColumn = function (listname) {
        $('table[data-swhgcontainer="' + listname + '"] thead th:contains("Image")').addClass("imageicon");
    };
    ZnodeBase.prototype.ExpandMenu = function (status) {
        Endpoint.prototype.SetCollapseMenuStatus(status, function (response) { });
        if (status) {
            $("#Menu_Collapse").hide();
            $("#Menu_Expand").show();
        }
        else {
            $("#Menu_Collapse").show();
            $("#Menu_Expand").hide();
        }
    };
    ZnodeBase.prototype.RemoveAsidePopupPanel = function () {
        $("#aside-popup-panel").remove();
    };
    //Need to fetch from config file.
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
    ZnodeBase.prototype.InitializeProgressNotifier = function () {
        try {
            ZnodeProgressNotifier.prototype.InitiateProgressBar();
        }
        catch (ex) { }
    };
    //To initialize and set the value to Multi Fastselect input
    ZnodeBase.prototype.SetInitialMultifastselectInput = function (source, dest, obj) {
        var initval = [];
        if (source != null && dest != null) {
            var values = "";
            for (var j = 0; j < source.length; j++) {
                for (var i = 0; i < dest.length; i++) {
                    if (dest[i].value == source[j]) {
                        initval.push({ text: dest[i].text, value: dest[i].value });
                        values = values + "," + dest[i].value;
                    }
                }
            }
            obj.val(values.substr(1));
        }
        obj.fastselect({
            initialValue: initval,
            searchPlaceholder: obj.attr("placeholder")
        });
    };
    // To show partial Loader.
    ZnodeBase.prototype.ShowPartialLoader = function (partialDiv) {
        showGlobalLoader = false;
        // Loader element id
        var loaderElement = $('#' + partialDiv);
        // Get the parent element using loader element
        var parentElement = loaderElement.parent();
        // Add the minimum height if parent element height is less than 50px
        if (parentElement.height() < 50) {
            parentElement.css("min-height", "100px");
        }
        else {
            parentElement.css("min-height", "auto");
        }
        // Show the loader
        loaderElement.find('#loading-content').show();
    };
    //To hide Partial Loader.
    ZnodeBase.prototype.HidePartialLoader = function (partialDiv) {
        showGlobalLoader = true;
        $('#' + partialDiv).find('#loading-content').hide();
    };
    //Remove and Add jQuery validation of the form
    ZnodeBase.prototype.RemoveAndAddUnobtrusiveValidation = function () {
        $('form').removeData('validator');
        $('form').removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse('form');
    };
    return ZnodeBase;
}());
$(window).on("load", function () {
    ZnodeBase.prototype.onready();
    ZnodeBase.prototype.activeAsidePannel();
    ZnodeBase.prototype.OnImgError();
    ZnodeBase.prototype.ShowActiveMenu();
    ZnodeBase.prototype.InitializeProgressNotifier();
});
//Aside Popup Panel Close on body click.
$(document).on("mouseup", function (e) {
    var is_chrome = navigator.userAgent.indexOf('Chrome') > -1;
    var is_explorer = navigator.userAgent.indexOf('MSIE') > -1;
    var is_firefox = navigator.userAgent.indexOf('Firefox') > -1;
    var is_opera = navigator.userAgent.toLowerCase().indexOf("op") > -1;
    //If the data picker is open then not calling the close function of aside panel.
    if ($(".datepicker.datepicker-dropdown:visible").length == 0 && $("#asidepopover:visible").length == 0 && $(".ui-autocomplete").length == 0) {
        if ($(".panel-container:visible").length > 0) {
            if (is_chrome || is_explorer || is_firefox || is_opera) {
                var popup = $("#aside-popup-panel");
                if (!$('#open').is(e.target) && !popup.is(e.target) && popup.has(e.target).length == 0) {
                    if (_gridContainerName == '#ZnodeOrderProductList') {
                        var selectedIds = DynamicGrid.prototype.GetMultipleSelectedIds();
                        Order.prototype.RemoveItemFromCart(event, selectedIds, true);
                    }
                    popup.slideUp(400, function () {
                        $('.aside-popup-panel').hide(5);
                        $(this).remove();
                        $("body").css('overflow', 'auto');
                        $('.modal-backdrop').remove();
                    });
                }
            }
        }
    }
});
// ToolTip On Product Title ellipsis case.
$(function () {
    $('.title-container span').each(function (i) {
        if (isEllipsisActive(this)) {
            $(this).attr("title", $(this).text());
        }
    });
});
function isEllipsisActive(e) {
    return (e.offsetWidth < e.scrollWidth);
}
$(document).on("click", "input[type=submit]", function (event) {
    ZnodeBase.prototype.ShowLoader();
});
$(window).on('beforeunload', function () {
    ZnodeBase.prototype.ShowLoader();
});
//Code for addding class to body for mac sarafi only
if (navigator.userAgent.indexOf('Mac') >= 0) {
    $('body').addClass('mac-os');
}
// Overlay on dropdown for Top Nav and Create Menu.
$(function () {
    $('.nav-dropdown-menu').on("click", function (i) {
        if ($('.nav-dropdown-menu').parent().is(".open") == true) {
            $(".drop-panel-overlay").remove();
        }
        else {
            if ($("body").find(".drop-panel-overlay").length == 1) {
                $(".drop-panel-overlay").css('display', 'block');
            }
            else {
                $("body").append("<div class='drop-panel-overlay'></div>");
            }
        }
    });
    $('.create-quick').on("click", function (i) {
        if ($('.create-quick').parent().is(".open") == true) {
            $(".drop-panel-overlay").remove();
        }
        else {
            if ($("body").find(".drop-panel-overlay").length == 1) {
                $(".drop-panel-overlay").css('display', 'block');
            }
            else {
                $("body").append("<div class='drop-panel-overlay'></div>");
            }
        }
    });
});
$(document).on("mouseup", function (e) {
    var container = $(".contain-area");
    if (!container.is(e.target) && container.has(e.target).length === 0) {
        $(".drop-panel-overlay").hide();
    }
    if (e.target.className.indexOf("menu-link") >= 0 && e.which == 2) {
        if (/firefox/i.test(navigator.userAgent)) {
            e.preventDefault();
            $(".drop-panel-overlay").remove();
        }
    }
});
$(document).on("mousedown", function (e) {
    if (e.which == 2 && $(e.target).is("a[href]")) {
        e.preventDefault();
        $(e.target).click();
        return false;
    }
});
//# sourceMappingURL=ZnodeGlobal.js.map