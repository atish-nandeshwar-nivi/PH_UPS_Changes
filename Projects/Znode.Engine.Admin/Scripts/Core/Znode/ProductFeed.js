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
var ProductFeed = /** @class */ (function (_super) {
    __extends(ProductFeed, _super);
    function ProductFeed() {
        var _this = _super.call(this) || this;
        ProductFeed.prototype._multiFastItemdata = new Array();
        return _this;
    }
    ProductFeed.prototype.Init = function () {
        ProductFeed.prototype.AddCreateFileName();
        ProductFeed.prototype.DisplayXMLSiteMapType();
    };
    ProductFeed.prototype.DisplayCustomDate = function (control) {
        if ($.trim($(control).val()) === "Use date / time of this update") {
            $('#CustomDate-content').show();
        }
        else {
            $('#CustomDate-content').hide();
        }
        if ($.trim($(control).val()) === "Use the database update date") {
            var dt = new Date(Date.now());
            var date = dt.toLocaleDateString() + " " + dt.toLocaleTimeString();
            $('#DBDate').val(date);
        }
    };
    ProductFeed.prototype.DisplayXMLSiteMapType = function () {
        if (($('#ddlXMLSiteMap').val() == Enum.ProductFeedType[Enum.ProductFeedType.XmlSiteMap]) || ($('#txtSitemapType').data('typecode') == Enum.ProductFeedType[Enum.ProductFeedType.XmlSiteMap])) {
            $('#rdbXMLSiteMapType').show();
            $('#GoogleFeedFields').hide();
            $('.defaultLocalId').hide();
            ProductFeed.prototype.AddFileName();
        }
        else if (($('#ddlXMLSiteMap').val() == Enum.ProductFeedType[Enum.ProductFeedType.Google]) || $('#txtSitemapType').data('typecode') == Enum.ProductFeedType[Enum.ProductFeedType.Google]) {
            $('#rdbXMLSiteMapType').hide();
            $('#GoogleFeedFields').show();
            $('.defaultLocalId').show();
            $('#FileName').val(Constant.googleProductFeed);
            ProductFeed.prototype.AppendPortalId();
        }
        else if (($('#ddlXMLSiteMap').val() == Enum.ProductFeedType[Enum.ProductFeedType.Bing]) || $('#txtSitemapType').data('typecode') == Enum.ProductFeedType[Enum.ProductFeedType.Bing]) {
            $('#rdbXMLSiteMapType').hide();
            $('#GoogleFeedFields').show();
            $('.defaultLocalId').show();
            $('#FileName').val(Constant.bingProductFeed);
            ProductFeed.prototype.AppendPortalId();
        }
        else if (($('#ddlXMLSiteMap').val() == Enum.ProductFeedType[Enum.ProductFeedType.Xml]) || $('#txtSitemapType').data('typecode') == Enum.ProductFeedType[Enum.ProductFeedType.Xml]) {
            $('#rdbXMLSiteMapType').hide();
            $('#GoogleFeedFields').show();
            $('.defaultLocalId').show();
            $('#FileName').val(Constant.xmlProductFeed);
            ProductFeed.prototype.AppendPortalId();
        }
    };
    ProductFeed.prototype.AppendPortalId = function () {
        if ($('#PortalId').val() > 0) {
            var portalId = $('#PortalId').val();
            var fileName = $("#FileName").val();
            $("#FileName").val("");
            $("#FileName").val(fileName + "_" + portalId);
        }
    };
    ProductFeed.prototype.DisableXMLSiteMapType = function () {
        if ($('#ProductFeedId').val() > 0) {
            $('#XMLTypeInputs input').prop('disabled', true);
        }
    };
    ProductFeed.prototype.DeleteProductFeed = function (control) {
        var productFeedId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (productFeedId.length > 0) {
            Endpoint.prototype.DeleteProductFeed(productFeedId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    ProductFeed.prototype.OnSelectPortalResult = function (item) {
        Store.prototype.OnSelectStoreAutocompleteDataBind(item);
        ProductFeed.prototype.DisplayXMLSiteMapType();
    };
    ProductFeed.prototype.SetPortals = function () {
        if ($("#txtPortalName").val() == '' || $("#txtPortalName").val() == undefined) {
            $("#StoreName-error").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectPortal")).addClass("field-validation-error").show();
            $("#txtPortalName").parent("div").addClass('input-validation-error');
            return false;
        }
        return true;
    };
    ProductFeed.prototype.SetSubmitOnSave = function () {
        var isPortalValidate = ProductFeed.prototype.SetPortals();
        if ($('#frmProductFeed').valid() && isPortalValidate) {
            var localeId = parseInt($("#LocaleId").val());
            var fileName = $("#FileName").val();
            if (($('#ProductFeedId').val() > 0)) {
                $('#frmProductFeed').submit();
            }
            else {
                Endpoint.prototype.CheckFileNameExist(localeId, fileName, function (response) {
                    if (response.data) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ProductFeedAlreadyExist"), 'error', isFadeOut, fadeOutTime);
                        return false;
                    }
                    $('#frmProductFeed').submit();
                });
            }
        }
    };
    ProductFeed.prototype.SetFeedIsSelectAllPortalOnInit = function () {
        if ($('input:checkbox[name="PortalId"]').prop('checked') == true) {
            $(".chkStoresList").hide();
        }
        else {
            if (($('#Stores').val() != undefined) && ($('#Stores').val() != "")) {
                var portalsArray = $('#Stores').val().split(',');
                Endpoint.prototype.GetPortalList(Constant.storelist, function (response) {
                    ZnodeBase.prototype.SetInitialMultifastselectInput(portalsArray, response, $("#txtPortalName"));
                });
            }
            else {
                ZnodeBase.prototype.SetInitialMultifastselectInput(null, null, $("#txtPortalName"));
            }
            $(".chkStoresList").show();
        }
    };
    ProductFeed.prototype.GenerateProductFeed = function (url) {
        Endpoint.prototype.GenerateProductFeed(url, function (response) {
            if (response.success) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
            }
        });
    };
    ProductFeed.prototype.AddCreateFileName = function () {
        if (!($('#ProductFeedId').val() > 0)) {
            ProductFeed.prototype.AddFileName();
        }
    };
    ProductFeed.prototype.AddFileName = function () {
        $('#FileName').val('');
        if ($('input[name="ProductFeedSiteMapTypeCode"]:checked').val() === Enum.ProductFeedSiteMapType[Enum.ProductFeedSiteMapType.Category]) {
            $('#FileName').val(Constant.categoryXMLSitemap);
        }
        else if ($('input[name="ProductFeedSiteMapTypeCode"]:checked').val() === Enum.ProductFeedSiteMapType[Enum.ProductFeedSiteMapType.Content]) {
            $('#FileName').val(Constant.contentPagesXMLSitemap);
        }
        else if ($('input[name="ProductFeedSiteMapTypeCode"]:checked').val() === Enum.ProductFeedSiteMapType[Enum.ProductFeedSiteMapType.Product]) {
            $('#FileName').val(Constant.productXMLSitemap);
        }
        else if ($('input[name="ProductFeedSiteMapTypeCode"]:checked').val() === Enum.ProductFeedSiteMapType[Enum.ProductFeedSiteMapType.ALL]) {
            $('#FileName').val(Constant.allXMLSitemap);
        }
        ProductFeed.prototype.AppendPortalId();
    };
    return ProductFeed;
}(ZnodeBase));
$(document).off("click", "#ZnodeProductFeed .z-download");
$(document).on("click", "#ZnodeProductFeed .z-download", function (e) {
    e.preventDefault();
    ProductFeed.prototype.GenerateProductFeed($(this).attr('href'));
});
//# sourceMappingURL=ProductFeed.js.map