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
var SEO = /** @class */ (function (_super) {
    __extends(SEO, _super);
    function SEO() {
        return _super.call(this) || this;
    }
    SEO.prototype.Init = function () {
        SEO.prototype.LocaleDropDownChangeForSEODetails();
        SEO.prototype.GetContentPagList();
    };
    SEO.prototype.GetSelectedStoreSEOSetting = function () {
        Endpoint.prototype.GetPortalSeoSettings(parseInt($("#hdnPortalId").val()), function (response) {
            $("#PortalSeoSetting").html(response);
            $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
        });
    };
    SEO.prototype.DeleteUrlRedirect = function (control) {
        var urlRedirectIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (urlRedirectIds.length > 0) {
            Endpoint.prototype.DeleteUrlRedirect(urlRedirectIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    SEO.prototype.LocaleDropDownChangeForSEODetails = function () {
        $("#ddl_locale_list_for_seoDetails").on("change", function () {
            Endpoint.prototype.SEODetails($("#ItemName").val(), $("#CMSSEOTypeId").val(), $("#SEOCode").val(), $("#ddl_locale_list_for_seoDetails").val(), $("#PortalId").val(), function (response) {
                $('#div_seo_details_locale_field').html(response);
                $('#seoName').text($('#name').val());
            });
        });
    };
    SEO.prototype.GetPublishedProductList = function () {
        SEO.prototype.SetLink();
        Endpoint.prototype.GetPublishedProductList(parseInt($("#hdnPortalId").val()), function (response) {
            $("#productList").html(response);
        });
    };
    SEO.prototype.GetPublishedCategoryList = function () {
        SEO.prototype.SetLink();
        Endpoint.prototype.GetPublishedCategoryList(parseInt($("#hdnPortalId").val()), function (response) {
            $("#categoryList").html(response);
        });
    };
    SEO.prototype.GetContentPagList = function () {
        SEO.prototype.SetLink();
        Endpoint.prototype.GetContentPagesList(parseInt($("#hdnPortalId").val()), function (response) {
            $("#contentPageList").html(response);
        });
    };
    SEO.prototype.GetURLRedirectPageList = function () {
        SEO.prototype.SetLink();
        Endpoint.prototype.UrlRedirectList(parseInt($("#hdnPortalId").val()), function (response) {
            $("#urlRedirectList").html(response);
        });
    };
    SEO.prototype.CreateUrlRedirect = function () {
        Endpoint.prototype.CreateUrlRedirect($("#hdnPortalId").val(), function (response) {
            $("#urlRedirect").html(response);
            $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
        });
    };
    SEO.prototype.SetLink = function () {
        var _newUrl = MediaManagerTools.prototype.UpdateQueryString("portalId", $("#hdnPortalId").val(), window.location.href);
        window.history.pushState({ path: _newUrl }, '', _newUrl);
    };
    //This method is used to get portal list on aside panel
    SEO.prototype.GetPortalList = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/SEO/GetPortalList', 'divStoreListAsidePanel');
    };
    SEO.prototype.GetPortalListForURL = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/SEO/GetPortalList', 'divStoreListAsidePanel');
    };
    //To Do: To bind portal information
    SEO.prototype.OnSelectPortalResult = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            var dataView = $("body").data("view");
            $('#StoreName').val(portalName);
            Store.prototype.OnSelectStoreAutocompleteDataBind(item);
            if ($('#frmCreateEditUrlRedirect').length != 1) {
                if (dataView != undefined && dataView != "") {
                    switch (dataView) {
                        case "GetProductsForSEO":
                            SEO.prototype.GetPublishedProductList();
                            break;
                        case "GetCategoriesForSEO":
                            SEO.prototype.GetPublishedCategoryList();
                            break;
                        case "GetContentPages":
                            SEO.prototype.GetContentPagList();
                            break;
                        case "UrlRedirectList":
                            SEO.prototype.GetURLRedirectPageList();
                            break;
                        case "SEOSetting":
                            SEO.prototype.GetSelectedStoreSEOSetting();
                            break;
                        case "SaveSEOSetting":
                            SEO.prototype.GetSelectedStoreSEOSetting();
                            break;
                    }
                }
            }
        }
    };
    SEO.prototype.GetPortalDetail = function () {
        $("#ZnodeUserPortalList").find("table tr").click(function () {
            var portalName = $(this).find("td[class='storecolumn']").text();
            var portalId = $(this).find("td")[0].innerHTML;
            var dataView = $("body").data("view");
            $('#txtPortalName').val(portalName);
            $('#StoreName').val(portalName);
            $('#hdnPortalId').val(portalId);
            $('#PortalId').val(portalId);
            if ($('#frmCreateEditUrlRedirect').length != 1) {
                if (dataView != undefined && dataView != "") {
                    switch (dataView) {
                        case "GetProductsForSEO":
                            SEO.prototype.GetPublishedProductList();
                            break;
                        case "GetCategoriesForSEO":
                            SEO.prototype.GetPublishedCategoryList();
                            break;
                        case "GetContentPages":
                            SEO.prototype.GetContentPagList();
                            break;
                        case "UrlRedirectList":
                            SEO.prototype.GetURLRedirectPageList();
                            break;
                        case "SEOSetting":
                            SEO.prototype.GetSelectedStoreSEOSetting();
                            break;
                        case "SaveSEOSetting":
                            SEO.prototype.GetSelectedStoreSEOSetting();
                            break;
                    }
                }
            }
            $('#divStoreListAsidePanel').hide(700);
            ZnodeBase.prototype.RemovePopupOverlay();
            $('#ZnodeUserPortalList').html("");
        });
    };
    SEO.prototype.UpdatePublish = function () {
        $("#frmCreatEditSEODEtails").attr('action', 'UpdateAndPublishSeo');
        $("#frmCreatEditSEODEtails").submit();
    };
    SEO.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_productCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime }); // expires after 2 hours
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        if (selectedTab != undefined)
            window.location.replace(orignalUrl + "?SEOCode=" + $("#portalId").val() + "&selectedtab=" + selectedTab);
        else {
            if (url.indexOf('SEOCode') > -1)
                window.location.replace(orignalUrl + "?SEOCode=" + $("#portalId").val());
            else
                window.location.reload();
        }
    };
    SEO.prototype.PublishSeoPopup = function (zPublishAnchor) {
        zPublishAnchor.attr("href", "#");
        $("#SEOCode").val($(zPublishAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        this.localId = Number($("#ddlCultureSpan").attr("data-value"));
        $("#PublishSeo").modal('show');
    };
    SEO.prototype.GetContentPagePublishSeoPopup = function (zPublishAnchor) {
        zPublishAnchor.attr("href", "#");
        var seoCode = $(zPublishAnchor).closest("tr").find("td").first().next().html();
        $("#SEOCode").val(encodeURIComponent(seoCode));
        this.localId = Number($("#ddlCultureSpan").attr("data-value"));
        $("#PublishSeo").modal('show');
    };
    SEO.prototype.PublishSeo = function (control) {
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        Endpoint.prototype.PublishSeoWithPreview($("#SEOCode").val(), $("#hdnPortalId").val(), 0, $("#hdnSEOTypeId").val(), publishStateFormData, true, function (res) {
            if (res.status == true)
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, "success", isFadeOut, fadeOutTime);
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, "error", isFadeOut, fadeOutTime);
            DynamicGrid.prototype.RefreshGridOndelete(control, res);
        });
    };
    SEO.prototype.UpdateAndPublishSeo = function () {
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        $("#frmCreatEditSEODEtails [name=TargetPublishState]").val(publishStateFormData);
        $("#frmCreatEditSEODEtails").attr("action", "UpdateAndPublishSeo");
        $("#frmCreatEditSEODEtails").submit();
    };
    SEO.prototype.PublishSeoPopupEdit = function (zPublishAnchor) {
        $("#UpdateAndPublishSeo").modal('show');
    };
    return SEO;
}(ZnodeBase));
//# sourceMappingURL=SEOSetting.js.map