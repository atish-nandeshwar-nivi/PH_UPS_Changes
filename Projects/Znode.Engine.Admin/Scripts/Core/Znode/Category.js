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
var selectedTab;
var Category = /** @class */ (function (_super) {
    __extends(Category, _super);
    function Category() {
        return _super.call(this) || this;
    }
    Category.prototype.Init = function () {
        Category.prototype.hdnCatalogIdForCatalog = $("#hdnCatalogIdForCatalog").val();
        Category.prototype.hdnPimParentCategoryIdForCatalog = $("#hdnPimParentCategoryIdForCatalog").val();
        Category.prototype.GetAttributeFamilyDetails();
        Category.prototype.ShowHideAttributes();
        Category.prototype.ValidationOfCategoryCode();
        Products.prototype.MultiSelectDropDown();
        if (parseInt($("#CategoryId").val(), 10) <= 0) {
            $("#ddlCulture").prop("disabled", true);
            $("#ddlCulture").addClass("disabled");
        }
        else {
            $(".dropdown-hide-show").children('li').children("#PublishCategoryLink").show();
        }
        $("input:radio[name*=IsActive].yes").prop("checked", true);
        var selectedTabGroupCode = Products.prototype.GetParameterValues('selectedtab');
        $(".groupPannel[data-groupcode=" + selectedTabGroupCode + "]").click();
        if (selectedTabGroupCode == undefined)
            $(".groupPannel").first().click();
    };
    Category.prototype.GetAttributeFamilyDetails = function () {
        $("#ddlfamily").off("change");
        $("#ddlfamily").on("change", function () {
            Endpoint.prototype.GetCategoryFamilyDetails($("#ddlfamily").val(), $("#CategoryId").val(), function (response) {
                $("#categoryDetails").html(response);
                Category.prototype.ShowHideAttributes();
                Category.prototype.GetAttributeFamilyDetails();
                $.getScript("/Scripts/References/DynamicValidation.js");
                if (parseInt($("#CategoryId").val(), 10) <= 0) {
                    $("#ddlCulture").prop("disabled", true);
                    $("#ddlCulture").addClass("disabled");
                }
                reInitializationMce();
            });
        });
        $(".groupPannel").first().click();
        $("#hdnCatalogIdForCatalog").val(Category.prototype.hdnCatalogIdForCatalog);
        $("#hdnPimParentCategoryIdForCatalog").val(Category.prototype.hdnPimParentCategoryIdForCatalog);
        if (Category.prototype.hdnCatalogIdForCatalog > 0) {
            var cancelUrl = "/PIM/Catalog/Manage?pimCatalogId=" + Category.prototype.hdnCatalogIdForCatalog + "&pimCategoryId=" + Category.prototype.hdnPimParentCategoryIdForCatalog;
            $("#btnCancelForCategory").attr('href', cancelUrl);
        }
        Products.prototype.MultiSelectDropDown();
    };
    Category.prototype.GetUnAssociatedCategoryProducts = function () {
        var categoryId = $("#CategoryId").val();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Category/GetUnAssociatedCategoryProducts?categoryId=' + categoryId + '', 'divCategoryProduct');
    };
    Category.prototype.ShowHideAttributes = function () {
        $(".groupPannel").off("click");
        var groupCode = $(this).attr("data-groupcode");
        $(".groupPannel").on("click", function () {
            $("#CategoryAsidePannel>li.tab-selected").removeClass("tab-selected");
            var groupCode = $(this).attr("data-groupcode");
            var groupId = $(this).attr("data-groupId");
            var groupType = $(this).attr("data-groupType");
            selectedTab = groupCode;
            $('li[data-groupcode=' + groupCode + ']').addClass('tab-selected');
            $(".categoryAttribute").hide();
            if (groupCode == "PannelAssociateProducts") {
                var PimCategoryId = $('#CategoryId').val();
                Endpoint.prototype.GetAssociatedCategoryProducts(PimCategoryId, function (res) {
                    $("#PannelAssociateProducts").html(res);
                });
                $('.associate-products-categories').show();
                $(".hide-publish").children("#btnSaveNClose").hide();
                $(".dropdown-hide-show").children('li').children("#btnSaveNClose").show();
            }
            else {
                $('.associate-products-categories').hide();
                $(".hide-publish").children("#btnSaveNClose").show();
            }
            if (groupCode != "PannelAssociateProducts") {
                $(".dropdown-hide-show").children('li').children("#btnSaveNClose").hide();
            }
            if (groupCode == "PannelSEO") {
                Category.prototype.GetCategorySEODetails();
                $('#categorySeoDetails').show();
                $(".hide-publish").children("#btnSaveNClose").show();
            }
            else {
                $('#categorySeoDetails').hide();
            }
            $('#' + groupCode).show();
            $('#lblCategoryHeading').text($(this).find('a').text());
            if ($("div[id='" + groupCode + "']").find('.multi-upload-Image').length > 0)
                $("div[id='" + groupCode + "']").find('.multi-upload-Image').each(function () {
                    Products.prototype.GetMultipleUploadImages($(this).attr('id'));
                });
            if ($("div[id='" + groupCode + "']").find('.multi-upload-Files').length > 0)
                $("div[id='" + groupCode + "']").find('.multi-upload-Files').each(function () {
                    EditableText.prototype.GetMultipleUploadFiles($(this).attr('id'));
                });
        });
        if ($("div[id^='GeneralInfo']").find('.multi-upload-Image').length > 0)
            $("div[id^='GeneralInfo']").find('.multi-upload-Image').each(function () {
                Products.prototype.GetMultipleUploadImages($(this).attr('id'));
            });
        if ($("div[id^='Descriptions']").find('.multi-upload-Image').length > 0)
            $("div[id^='Descriptions']").find('.multi-upload-Image').each(function () {
                Products.prototype.GetMultipleUploadImages($(this).attr('id'));
            });
        if (groupCode == "PannelAssociateProducts") {
            $('.associate-products-categories').show();
        }
        else {
            $('.associate-products-categories').hide();
        }
    };
    Category.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_productCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime });
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        if (selectedTab != undefined)
            window.location.replace(orignalUrl + "?pimCategoryId=" + $("#CategoryId").val() + "&selectedtab=" + selectedTab);
        else {
            if (url.indexOf('pimCategoryId') > -1)
                window.location.replace(orignalUrl + "?pimCategoryId=" + $("#CategoryId").val());
            else
                window.location.reload();
        }
    };
    Category.prototype.DeleteMultipleCategory = function (control) {
        var pimCategoryId = [];
        pimCategoryId = MediaManagerTools.prototype.unique();
        if (pimCategoryId.length > 0) {
            Endpoint.prototype.DeleteCategories(pimCategoryId.join(","), function (response) {
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Category.prototype.PublishCategoryPopup = function (zPublishAnchor) {
        if (zPublishAnchor != null) {
            zPublishAnchor.attr("href", "#");
            $("#HdnCategoryId").val($(zPublishAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        }
        $("#PublishCategory").modal('show');
    };
    Category.prototype.PublishCategory = function () {
        Endpoint.prototype.PublishCatagory($("#HdnCategoryId").val(), ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray()), function (res) {
            DynamicGrid.prototype.RefreshGridOndelete($("#View_PimCategoryDetail").find("#refreshGrid"), res);
        });
    };
    Category.prototype.UpdateAndPublishCategory = function () {
        $(".active-tab-validation").removeClass('active-tab-validation');
        if (!$("#frmCategory").valid()) {
            $(".input-validation-error").parent().parent().parent().parent().each(function () {
                $('li[data-groupcode=' + $(this).attr('id') + ']').addClass('active-tab-validation');
            });
        }
        else if (!Products.prototype.IsAttributeValueUnique(true))
            return false;
        else {
            $("#frmCategory").attr("action", "UpdateAndPublishCategory");
            $("#revisionType").val(ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray()));
            var myForm = document.getElementById('frmCategory');
            myForm.submit();
        }
    };
    Category.prototype.SaveCategory = function (backURL) {
        $(".active-tab-validation").removeClass('active-tab-validation');
        if (!$("#frmCategory").valid()) {
            $(".input-validation-error").parent().parent().parent().parent().each(function () {
                $('li[data-groupcode=' + $(this).attr('id') + ']').addClass('active-tab-validation');
            });
        }
        else if (!Products.prototype.IsAttributeValueUnique(true)) {
            return false;
        }
        else {
            if (selectedTab != undefined)
                $("#frmCategory").attr("action", $("#frmCategory").attr("action") + "?selectedtab=" + selectedTab);
            if (Products.prototype.ValidateFileTypeControl()) {
                $(".fileuploader").parent().parent().parent().each(function () {
                    $('li[data-groupcode=' + $(this).parent().attr('id') + ']').addClass('active-tab-validation');
                });
                return;
            }
            var PimCategoryId = parseInt($("#CategoryId").val(), 10);
            if (PimCategoryId == 0)
                $.cookie("_productCulture", "");
            if (typeof (backURL) != "undefined")
                $.cookie("_backURL", backURL, { path: '/' });
            $("#frmCategory").submit();
        }
    };
    Category.prototype.AssociateCategoryProducts = function (PimCategoryId) {
        ZnodeBase.prototype.ShowLoader();
        var productId = DynamicGrid.prototype.GetMultipleSelectedIds("UnAssociatedCategoryProducts");
        if (productId.length > 0 && PimCategoryId > 0) {
            Endpoint.prototype.AssociateCategoryProducts(PimCategoryId, productId, function (response) {
                if (response.status) {
                    Endpoint.prototype.GetAssociatedCategoryProducts(PimCategoryId, function (res) {
                        $("#PannelAssociateProducts").html(res);
                    });
                }
                $("#divCategoryProduct").hide(700);
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        }
        else {
            $("#AssociateCategoryProductError").show();
        }
        ZnodeBase.prototype.HideLoader();
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Category.prototype.CloseAddProductInventoryPopup = function () {
        ZnodeBase.prototype.CancelUpload('divAssociateProductCategory');
    };
    Category.prototype.AssociateCategoriesToProduct = function () {
        ZnodeBase.prototype.ShowLoader();
        var productId = $("#ProductId").val();
        var categoryId = DynamicGrid.prototype.GetMultipleSelectedIds("divAssociateProductCategory");
        if (categoryId.length > 0) {
            Endpoint.prototype.AssociateCategoriesToProduct(productId, categoryId, function (response) {
                if (response.status) {
                    $("#btnCancelcategoriesProductAssociation").click();
                    Products.prototype.GetCatagoryAssociatedToProduct(false);
                }
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        }
        else {
            $("#AssociateCategoryProductError").show();
        }
        ZnodeBase.prototype.HideLoader();
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Category.prototype.DeleteMultipleAssociatedProducts = function (control) {
        var PimCategoryProductId = MediaManagerTools.prototype.unique();
        if (PimCategoryProductId.length > 0) {
            Endpoint.prototype.DeleteMultipleAssociatedProducts(PimCategoryProductId.join(","), function (response) {
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Category.prototype.EditCategoryProductResult = function (response) {
        if (response.status) {
            Endpoint.prototype.GetAssociatedCategoryProducts(response.PimCategoryId, function (res) {
                $("#PannelAssociateProducts").html(res);
                $("#divCategoryProduct").modal("hide");
            });
        }
        $("#divCategoryProduct").modal("hide");
        ZnodeBase.prototype.RemovePopupOverlay();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
    };
    Category.prototype.GetCategorySEODetails = function () {
        var categoryId = $("#HdnCategoryId").val();
        var seoCode = $('[id^=CategoryCode]').val();
        var seoTypeId = $("#CMSSEOTypeId").val();
        if (seoTypeId == undefined)
            seoTypeId = 2;
        var portalId = $("#PortalId").val();
        if (portalId == undefined)
            portalId = 0;
        var localeId = $("#LocaleId").val();
        if (localeId == undefined)
            localeId = 0;
        if (categoryId != undefined) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetCategorySEODetails(seoTypeId, seoCode, categoryId, localeId, portalId, function (response) {
                $('#divCategorySEO').show();
                $('#divCategorySEO').html("");
                $('#divCategorySEO').html(response);
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    Category.prototype.GetCategoryDefaultSEODetails = function () {
        var itemId = $("#HdnCategoryId").val();
        var seoCode = $('[id^=CategoryCode]').val();
        var seoTypeId = $("#CMSSEOTypeId").val();
        if (seoTypeId == undefined)
            seoTypeId = 2;
        var portalId = $("#PortalId").val();
        if (portalId == undefined)
            portalId = 0;
        var localeId = $("#LocaleId").val();
        if (localeId == undefined)
            localeId = 0;
        if (itemId != undefined) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetDefaultSEODetails(seoTypeId, seoCode, itemId, localeId, portalId, function (response) {
                $('#divCategorySEO').show();
                $('#divCategorySEO').html("");
                $('#divCategorySEO').html(response);
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    Category.prototype.SuccessErrorCategorySeoNotification = function (response) {
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
        if (response.cmsseodetailId != 0) {
            $("#CMSSEODetailId").val(response.cmsseodetailId);
            $("#LocaleId").prop("disabled", false);
            $("#LocaleId").attr("readonly", false);
        }
    };
    Category.prototype.ValidationOfCategoryCode = function () {
        var categoryCodeSelector = $("#frmCategory").find("input[name*='CategoryCode']");
        categoryCodeSelector.rules("add", {
            regex: /^\d*[a-zA-Z0-9]{1,}\d*/g,
            messages: {
                regex: ErrorMsg.ErrorMessageForCategoryCode
            }
        });
    };
    // This method is used to select catalog from fast select and show it on the textbox
    Category.prototype.OnSelectCatalogAutocompleteDataBind = function (item) {
        if (item != undefined) {
            var catalogName = item.text;
            var pimCatalogId = item.Id;
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetCategoryList(pimCatalogId, catalogName, function (response) {
                $("#categoryList").html("");
                $("#categoryList").html(response);
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    return Category;
}(ZnodeBase));
//# sourceMappingURL=Category.js.map