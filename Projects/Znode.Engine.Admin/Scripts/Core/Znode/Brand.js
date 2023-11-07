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
var Brand = /** @class */ (function (_super) {
    __extends(Brand, _super);
    function Brand() {
        return _super.call(this) || this;
    }
    Brand.prototype.Init = function () {
        if ($("#BrandId").val() > 0)
            $.cookie("_brandCulture", $("#ddlBrandLocale").val());
    };
    //Delete brand.
    Brand.prototype.DeleteBrand = function (control) {
        var brandIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (brandIds.length > 0) {
            Endpoint.prototype.DeleteBrand(brandIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Associate product to a brand.
    Brand.prototype.AssociateBrandProducts = function () {
        ZnodeBase.prototype.ShowLoader();
        var linkProductIds = DynamicGrid.prototype.GetMultipleSelectedIds('AssociatedProductList');
        if (linkProductIds.length > 0)
            Endpoint.prototype.BrandAssociateProductList($("#BrandCode").val(), linkProductIds, function (res) {
                Endpoint.prototype.AssociatedBrandProductList($("#BrandId").val(), $("#BrandCode").val(), $("#BrandName").val(), $("#LocaleId").val(), function (response) {
                    $("#BrandAssociatedProductList").html('');
                    $("#BrandAssociatedProductList").html(response);
                    GridPager.prototype.UpdateHandler();
                });
                $("#divBrandProductListPopup").hide(700);
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeBase.prototype.HideLoader();
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        else {
            Brand.prototype.DisplayNotificationMessagesForBrand(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneProduct"), "error", isFadeOut, fadeOutTime);
            ZnodeBase.prototype.HideLoader();
        }
    };
    //Unassociate product from a brand.
    Brand.prototype.UnassociateBrandProduct = function (control) {
        var brandProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (brandProductIds.length > 0) {
            Endpoint.prototype.BrandUnAssociateProductList(brandProductIds, $("#BrandCode").val(), function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Dispaly notification messages
    Brand.prototype.DisplayNotificationMessagesForBrand = function (message, type, isFadeOut, fadeOutMilliSeconds) {
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
    //Set cookies when locales dropdown change.
    Brand.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_brandCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime }); // expires after 2 hours
        window.location.reload();
    };
    //Set cookies value when locale dropdown change.
    Brand.prototype.CultureChangeOnEdit = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_brandCulture", $("#ddlBrandLocale").val(), { expires: expiresTime }); // expires after 2 hours
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        if (url.indexOf('BrandId') > -1)
            window.location.replace(orignalUrl + "?BrandId=" + $("#BrandId").val());
        else
            window.location.reload();
    };
    //Show/hide save cancel button.
    Brand.prototype.ShowHideSaveCancelButton = function () {
        if ($("#divBrandProductListPopup").find("tr").length > 0)
            $("#divSave").show();
        else
            $("#divSave").hide();
    };
    //Active and Inactive brand.
    Brand.prototype.ActiveInactiveBrand = function (isActive) {
        var brandIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (brandIds.length > 0) {
            Endpoint.prototype.ActiveInactiveBrand(brandIds, isActive, function (response) {
                $("#ZnodeBrandDetails #refreshGrid").click();
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
        }
        else
            $('#NoCheckboxSelected').modal('show');
    };
    //Check duplicate brand SEOFriendlyPageName.
    Brand.prototype.ValidateBrandSEOFriendlyPageName = function () {
        var isValid = true;
        if ($("#SEOFriendlyPageName").val() != undefined && $("#SEOFriendlyPageName").val().trim().length > 0)
            Endpoint.prototype.IsBrandSEOFriendlyPageNameExist($("#SEOFriendlyPageName").val(), $("#CMSSEODetailId").val(), function (response) {
                if (!response) {
                    $("#SEOFriendlyPageName").addClass("input-validation-error");
                    $("#errorSEOFriendlyPageName").addClass("error-msg");
                    $("#errorSEOFriendlyPageName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistBrandSEOFriendlyPageName"));
                    $("#errorSEOFriendlyPageName").show();
                    isValid = false;
                    ZnodeBase.prototype.HideLoader();
                }
            });
        return isValid;
    };
    //Associate product to a brand.
    Brand.prototype.AssociateBrandPortal = function () {
        ZnodeBase.prototype.ShowLoader();
        var linkPortalIds = DynamicGrid.prototype.GetMultipleSelectedIds('ZnodeStorePortal');
        if (linkPortalIds.length > 0)
            Endpoint.prototype.BrandAssociatePortalList($("#BrandId").val(), linkPortalIds, function (res) {
                location.reload();
                ZnodeBase.prototype.CancelUpload("divBrandStoreListPopup");
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
                DynamicGrid.prototype.ClearCheckboxArray();
            });
        else {
            Brand.prototype.DisplayNotificationMessagesForBrand(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneStore"), "error", isFadeOut, fadeOutTime);
            ZnodeBase.prototype.HideLoader();
        }
    };
    Brand.prototype.CheckUniqueBrandCode = function (control) {
        Endpoint.prototype.CheckUniqueBrandCode($(control).val(), function (res) {
            if (res.result) {
                $("#errorSpanForUnique").text(ZnodeBase.prototype.getResourceByKeyName("ErrorCodeAlreadyExist")).addClass("error-msg").show();
                $(control).focus();
                return false;
            }
            else {
                $("#errorSpanForUnique").hide();
            }
        });
    };
    //Get Brand Name
    Brand.prototype.GetBrandName = function (control) {
        var BrandCode = $(control).val();
        var localeId = $("#ddlBrandLocale").val();
        Endpoint.prototype.GetBrandName(BrandCode, localeId, function (res) {
            if (res.result) {
                $("#BrandName").val(res.result);
            }
        });
    };
    return Brand;
}(ZnodeBase));
//# sourceMappingURL=Brand.js.map