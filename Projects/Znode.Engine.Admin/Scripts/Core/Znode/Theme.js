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
var Theme = /** @class */ (function (_super) {
    __extends(Theme, _super);
    function Theme() {
        return _super.call(this) || this;
    }
    Theme.prototype.Init = function () {
        Theme.prototype.DownloadCSS();
        Theme.prototype.ValidateCSSFile();
        Theme.prototype.ValidateZipFile();
        Theme.prototype.GetFileName();
        Theme.prototype.RemoveParentThemeValidationRule();
    };
    //Validate theme to check theme already exists or not.
    Theme.prototype.ValidateThemeName = function () {
        var isValid = true;
        var name = $("#Name").val();
        if (name != '') {
            Endpoint.prototype.IsThemeNameExist(name, $("#CMSThemeId").val(), function (response) {
                if (!response) {
                    $("#Name").addClass("input-validation-error");
                    $("#errorSpanThemeName").addClass("error-msg");
                    $("#errorSpanThemeName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistThemeName"));
                    $("#errorSpanThemeName").show();
                    isValid = false;
                }
            });
        }
        return isValid;
    };
    //Handles the Parent Theme checkbox change event.
    Theme.prototype.IsParentThemeToggleCallback = function (checked, target) {
        if (target)
            if (checked === true) {
                target.hide();
                Theme.prototype.RemoveParentThemeValidationRule();
            }
            else {
                target.show();
                Theme.prototype.AddParentThemeValidationRule();
            }
    };
    Theme.prototype.RemoveParentThemeValidationRule = function () {
        $("#ParentThemeId").rules("remove", 'required');
    };
    Theme.prototype.AddParentThemeValidationRule = function () {
        $("#ParentThemeId").rules("add", 'required');
    };
    //Get file name.
    Theme.prototype.GetFileName = function () {
        if ($("#CMSThemeId").val() > 0) {
            $("#txtUpload").attr("title", $("#Name").val());
            var filename = $("#fileName").attr("title");
            $('#fileName').text(filename);
        }
    };
    Theme.prototype.UnSavedChanges = function () {
        Theme.prototype.unsaved = false;
        $("#frmThemeAsset :input").on("change", function () {
            Theme.prototype.unsaved = true;
        });
    };
    Theme.prototype.CheckChangeInForm = function () {
        if (Theme.prototype.unsaved) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSaveChanges"), 'error', isFadeOut, fadeOutTime);
            return !Theme.prototype.unsaved;
        }
    };
    Theme.prototype.GetUnAssociatedStoreList = function (PriceListId) {
        Endpoint.prototype.GetUnAssociatedStoreListForCMS(PriceListId, function (res) {
            if (res != null && res != "") {
                $("#associatestorelist").html(res);
                if ($("#modelAssociatedStore").find("tr").length == 0) {
                    $("#modelAssociatedStore").find(".modal-footer").hide();
                    $("#modelAssociatedStore").find(".filter-component").hide();
                }
                $("#associatestorelist").show();
            }
        });
    };
    Theme.prototype.AssociateCMSThemeStore = function (priceListId) {
        var storeIds = "";
        var storeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (storeIds.length > 0) {
            Endpoint.prototype.AssociateStoreListForCMS(priceListId, storeIds, function (res) {
                $("#associatestorelist").hide();
                Endpoint.prototype.GetAssociatedStoreList(priceListId, function (response) {
                    $("#associatedassets").html('');
                    $("#associatedassets").html(response);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                    ZnodeBase.prototype.RemovePopupOverlay();
                });
            });
        }
        else {
            $("#associatestorelist").hide();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneStore"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Theme.prototype.DeleteAssociatedThemeStores = function (control) {
        var priceListPortalId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (priceListPortalId.length > 0) {
            Endpoint.prototype.DeleteAssociatedStoresForCMS(priceListPortalId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Theme.prototype.GetCMSAreaWidgets = function (cmsThemeId) {
        var cmsAreaId = $("#areaId :selected").val();
        Endpoint.prototype.GetCMSAreaWidgets(cmsThemeId, cmsAreaId, function (response) {
            $("#widgetsDivId").html('');
            $("#widgetsDivId").html(response);
        });
    };
    Theme.prototype.GetMultipleSelectedIds = function () {
        var ids = [];
        $.each($("input[name='CMSAreaWidgetsData.WidgetIds']:checked"), function () {
            if ($(this).length > 0) {
                if ($(this).is(":checked")) {
                    var id = $(this).attr("value");
                    ids.push(id);
                }
            }
        });
        var result = [];
        $.each(ids, function (i, e) {
            if ($.inArray(e, result) == -1)
                result.push(e);
        });
        return result.join();
    };
    Theme.prototype.CheckCheckbox = function () {
        var widgetIds = Theme.prototype.GetMultipleSelectedIds();
        if (widgetIds.length > 0) {
            $("#frmCreateAreaWidget").submit();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneCheckbox"), 'error', isFadeOut, fadeOutTime);
            $("#frmCreateAreaWidget").off("submit");
            return false;
        }
    };
    Theme.prototype.DeleteMultipleTheme = function (control, themePropertyName) {
        var cmsThemeId = DynamicGrid.prototype.GetMultipleSelectedIds();
        var cmsThemeName = DynamicGrid.prototype.GetMultipleValuesOfGridColumn(themePropertyName);
        if (cmsThemeId.length > 0 || cmsThemeName != "") {
            Endpoint.prototype.DeleteTheme(cmsThemeId, cmsThemeName, function (response) {
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Theme.prototype.DeleteRevisedTheme = function (control, themePropertyName) {
        var cmsThemeId = $("#CMSThemeId").val();
        var cmsThemeName = DynamicGrid.prototype.GetMultipleValuesOfGridColumn(themePropertyName);
        if (cmsThemeName != "") {
            Endpoint.prototype.DeleteRevisedTheme(cmsThemeId, cmsThemeName, function (response) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
                ZnodeBase.prototype.RemovePopupOverlay();
            });
        }
    };
    Theme.prototype.DeleteMultipleCss = function (control, cssPropertyName) {
        var cmsThemeCssId = DynamicGrid.prototype.GetMultipleSelectedIds();
        var cssName = DynamicGrid.prototype.GetMultipleValuesOfGridColumn(cssPropertyName);
        var themeName = $("#CMSThemeName").val();
        if (cmsThemeCssId.length > 0 || cssName != "") {
            Endpoint.prototype.DeleteCss(cmsThemeCssId, cssName, themeName, function (response) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Theme.prototype.GetWidgetResult = function (data) {
        var cmsThemeId = $("input[name=CMSThemeId]", $(this).parent()).val();
        var message = JSON.parse(data.Message);
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(message.Message, message.Type, isFadeOut, fadeOutTime);
        Endpoint.prototype.GetCMSAreas(cmsThemeId, function (response) {
            $("#associatedassets").html('');
            $("#associatedassets").html(response);
        });
    };
    Theme.prototype.SaveThemeAsset = function (response) {
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
        Theme.prototype.unsaved = false;
    };
    Theme.prototype.GetPDPAssets = function () {
        var assets = [];
        $(".pdpassets").each(function () {
            var pdpAsset = $(this).children().children("#assets").attr("data-producttype") + "_" + $(this).children().children("#CMSAssetId").find(":selected").val();
            assets.push(pdpAsset);
        });
        $("#Assets").val(assets);
    };
    Theme.prototype.DownloadCSS = function () {
        $("#themecsslist .z-download").on("click", function (e) {
            e.preventDefault();
            var CMSThemeId = $(this).attr("data-parameter").split("?")[1].split('&')[0].split('=')[1];
            var CSSName = $(this).attr("data-parameter").split("&")[1].split("=")[1];
            var themeName = $("#Name").val();
            window.location.href = "/Theme/DownloadCSS?CMSThemeId=" + CMSThemeId + "&CSSName=" + CSSName + "&themeName=" + themeName + "";
        });
    };
    Theme.prototype.ValidateCSSFile = function () {
        $(document).on('change', '#txtUpload', function () {
            Theme.prototype.ValidateCSSFileType();
        });
    };
    Theme.prototype.ValidateCSSFileType = function () {
        var isCssFile = false;
        var regex = new RegExp("^[^'\"{}]+$");
        if ($("#txtUpload").val() != "") {
            $.each($("#fileName").html().split(","), function (index, item) {
                if (item.split(".")[1] == "css" || item.split(".")[2] == "css") {
                    if (!regex.test(item)) {
                        $("#errInvalidType").html(ZnodeBase.prototype.getResourceByKeyName("ErrorCssInvalidFileName"));
                    }
                    else {
                        $("#errInvalidType").html("");
                        isCssFile = true;
                    }
                    if (isCssFile) {
                        return isCssFile;
                    }
                    else {
                        $("#errInvalidType").html(ZnodeBase.prototype.getResourceByKeyName("ErrorCssInvalidFileName"));
                        return isCssFile;
                    }
                }
                else {
                    $("#errInvalidType").html(ZnodeBase.prototype.getResourceByKeyName("SelectCSSFileError"));
                    return isCssFile;
                }
            });
        }
        return true;
    };
    Theme.prototype.ValidateZipFile = function () {
        $(document).on('change', '#txtUpload', function () {
            Theme.prototype.ValidateZipFileType();
        });
    };
    Theme.prototype.ValidateZipFileType = function () {
        //Validate theme to check theme already exists or not.
        var isExists = Theme.prototype.ValidateThemeName();
        var fileName = $("#fileName").text();
        if ($("#txtUpload").val() != "") {
            if ($('#txtUpload').val().split('.').pop().toLowerCase() == "zip") {
                $("#errZipFileType").html("");
                if (!isExists)
                    return false;
                return true;
            }
            else {
                $("#errZipFileType").html(ZnodeBase.prototype.getResourceByKeyName("SelectZipFileError"));
                return false;
            }
        }
        else {
            $("#errZipFileType").text('');
            if (!isExists)
                return false;
            return true;
        }
    };
    Theme.prototype.HideLoader = function () {
        $("#loading-div-background").hide();
    };
    Theme.prototype.Reload = function () {
        setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 1000);
    };
    return Theme;
}(ZnodeBase));
//# sourceMappingURL=Theme.js.map