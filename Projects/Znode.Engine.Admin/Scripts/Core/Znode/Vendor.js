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
var Vendor = /** @class */ (function (_super) {
    __extends(Vendor, _super);
    function Vendor() {
        return _super.call(this) || this;
    }
    Vendor.prototype.Init = function () {
        Account.prototype.BindStates();
    };
    //Delete vendor
    Vendor.prototype.DeleteVendor = function (control) {
        var pimVendorId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (pimVendorId.length > 0) {
            Endpoint.prototype.DeleteVendor(pimVendorId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Associate products to vendor
    Vendor.prototype.AssociateVendorProducts = function () {
        ZnodeBase.prototype.ShowLoader();
        var ProductIds = DynamicGrid.prototype.GetMultipleSelectedIds('AssociatedProductList');
        if (ProductIds.length > 0)
            Endpoint.prototype.VendorAssociatedProductList($("#VendorCode").val(), $("#VendorName").val(), ProductIds, function (res) {
                Endpoint.prototype.AssociatedProductList($("#PimVendorId").val(), $("#VendorCode").val(), $("#VendorName").val(), function (response) {
                    $("#AssociatedVendorProductList").html('');
                    $("#AssociatedVendorProductList").html(response);
                    GridPager.prototype.UpdateHandler();
                });
                $("#divVendorProductListPopup").hide(700);
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeBase.prototype.HideLoader();
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        else {
            Vendor.prototype.DisplayNotificationMessagesForVendor(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneProduct"), "error", isFadeOut, fadeOutTime);
            ZnodeBase.prototype.HideLoader();
        }
    };
    //unassociate products from vendor
    Vendor.prototype.UnassociateVendorProduct = function (control) {
        var vendorProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (vendorProductIds.length > 0) {
            Endpoint.prototype.VendorUnAssociateProductList(vendorProductIds, $("#VendorCode").val(), function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Dispaly notification messages
    Vendor.prototype.DisplayNotificationMessagesForVendor = function (message, type, isFadeOut, fadeOutMilliSeconds) {
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
    //Show/hide save cancel button.
    Vendor.prototype.ShowHideSaveCancelButton = function () {
        if ($("#divVendorProductListPopup").find("tr").length > 0)
            $("#divSave").show();
        else
            $("#divSave").hide();
    };
    //Active/Inactive vendor
    Vendor.prototype.ActiveInactiveVendor = function (isActive) {
        var vendorIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (vendorIds.length > 0) {
            Endpoint.prototype.ActiveInactiveVendor(vendorIds, isActive, function (response) {
                $("#ZnodePimVendor #refreshGrid").click();
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            $('#NoCheckboxSelected').modal('show');
        }
    };
    return Vendor;
}(ZnodeBase));
//# sourceMappingURL=Vendor.js.map