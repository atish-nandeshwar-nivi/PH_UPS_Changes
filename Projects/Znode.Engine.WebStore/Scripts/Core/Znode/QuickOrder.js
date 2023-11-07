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
var QuickOrder = /** @class */ (function (_super) {
    __extends(QuickOrder, _super);
    function QuickOrder() {
        return _super.call(this) || this;
    }
    QuickOrder.prototype.Init = function () {
        $('#btnQuickOrder').attr('disabled', 'disabled');
        QuickOrder.prototype.ShowHideQuickOrderPopUp();
        QuickOrder.prototype.CloseQuickOrderpopup();
        QuickOrder.prototype.Validation();
        QuickOrder.prototype.RemoveValidationMessage();
        QuickOrder.prototype.SetProperties();
        QuickOrder.prototype.SetQuantity();
    };
    QuickOrder.prototype.ShowHideQuickOrderPopUp = function () {
        $(".quickordercontainer").on('mouseover mouseenter touch', function () {
            $(this).find(".divQuickOrder").show();
            if ($("#TemplateName:visible").length > 0) {
                $("#quickOrderPadTemplateLink").attr("href", "/User/QuickOrderPadTemplate?templateName=" + $("#TemplateName").val());
            }
        });
        $(".quickordercontainer").on('mouseleave touch', function () {
            if ((!$(this).find("#hdnttxtSKU").is(":focus")) && (!$(this).find(".txtQuickOrderQuantity").is(":focus")) && ($(this).find("#hdnttxtSKU").val() == "")) {
                $(this).find(".divQuickOrder").hide();
            }
        });
    };
    QuickOrder.prototype.CloseQuickOrderpopup = function () {
        $('.close-quick-order-popup').on('click', function () {
            var _content = $(this).closest(".quick-order-container");
            $(_content).find(".divQuickOrder").hide();
            $(_content).find('.quickOrderAddToCart').attr('disabled', 'disabled');
            $(_content).find('.txtQuickOrderSku').val("");
            $(_content).find('#hdnttxtSKU').val("");
            $(_content).find('.txtQuickOrderQuantity').val("1");
            $(_content).find('#inventorymsg').html("");
            $(_content).find(".divTemplateQuickOrder").hide();
            $(_content).find('.quickOrderAddToTemplate').attr('disabled', 'disabled');
            $(_content).find('.txtTemplateQuickOrderQuantity').val("");
            $(_content).find('.txtTemplateQuickOrderQuantity').val("1");
            $(_content).find('#templateInventorymsg').html("");
        });
    };
    QuickOrder.prototype.OnItemSelect = function (item) {
        var _focus = document.activeElement;
        var _content = $(_focus).closest(".quick-order-container");
        $(_content).find('#hdnttxtSKU').val(item.displaytext);
        $(_content).find('#hdnQuickOrderProductId').val(item.id);
        $(_content).find('#hdnQuickOrderMaxQty').val(item.properties.MaxQuantity);
        $(_content).find('.quickOrderAddToCart').prop('disabled', false);
        QuickOrder.prototype.SetQuickOrderMultipleHref();
    };
    QuickOrder.prototype.SetQuickOrderMultipleHref = function () {
        if ($("#linkMultiplePartSku").length > 0) {
            var link = $("#linkMultiplePartSku").attr("href");
            link = QuickOrder.prototype.UpdateQueryStringParameter(link, "ProductId", $($('#hdnttxtSKU').closest('.quick-order-container')).find('#hdnQuickOrderProductId').val());
            $("#linkMultiplePartSku").attr("href", link);
        }
    };
    QuickOrder.prototype.UpdateQueryStringParameter = function (uri, key, value) {
        var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
        var separator = uri.indexOf('?') !== -1 ? "&" : "?";
        if (uri.match(re)) {
            return uri.replace(re, '$1' + key + "=" + value + '$2');
        }
        else {
            return uri + separator + key + "=" + value;
        }
    };
    QuickOrder.prototype.OnQuantityChange = function (item) {
        //Adding CartCoundByProductId method to get the count of product in cart.
        var cartCount = 0;
        $('.quickOrderAddToCart').attr('disabled', true);
        Endpoint.prototype.GetCartCountByProductId(parseInt($('#hdnQuickOrderProductId').val()), function (response) {
            cartCount = parseInt(response) + parseInt(item.value);
            if (parseInt($('#hdnQuickOrderMaxQty').val()) < cartCount || $('#hdnQuickOrderMaxQty').val() == "") {
                $('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("SelectedQuantityBetween") + 1 + ZnodeBase.prototype.getResourceByKeyName("To") + parseInt($('#hdnQuickOrderMaxQty').val()));
                $('.quickOrderAddToCart').attr('disabled', true);
                return false;
            }
            else
                $('.quickOrderAddToCart').attr('disabled', false);
        });
    };
    QuickOrder.prototype.Validation = function () {
        $(".quickOrderAddToCart").on("click", function () {
            var isValid = false;
            var _content = $(this).closest(".quick-order-container");
            var productId = parseInt(_content.find("#hdnQuickOrderProductId").val());
            Endpoint.prototype.GetAutoCompleteItemProperties(productId, function (res) {
                QuickOrder.prototype.SetValidationData(_content, res);
                isValid = QuickOrder.prototype.ValidateAddToCart(_content);
                if (isValid == true && $("#isEnhancedEcommerceEnabled").val() == "True") {
                    GoogleAnalytics.prototype.SendAddToCartsFromQuickOrder();
                }
                return isValid;
            });
            return isValid;
        });
    };
    QuickOrder.prototype.SetValidationData = function (_content, response) {
        $(_content).find('.txtQuickOrderSku').val(response.DisplayText);
        $(_content).find('#hdnQuickOrderSku').val(response.DisplayText);
        $(_content).find('#hdnQuickOrderProductName').val(response.Properties.ProductName);
        $(_content).find('#hdnQuickOrderQuantityOnHand').val(response.Properties.Quantity);
        $(_content).find('#hdnQuickOrderCartQuantity').val(response.Properties.CartQuantity);
        $(_content).find('#hdnQuickOrderProductType').val(response.Properties.ProductType);
        $(_content).find('#hdnRetailPrice').val(response.Properties.RetailPrice);
        $(_content).find('#hdnImagePath').val(response.Properties.ImagePath);
        $(_content).find('#hdnIsPersonisable').val(response.Properties.IsPersonalisable);
        $(_content).find('#hdnAutoAddonSKUs').val(response.Properties.AutoAddonSKUs);
        $(_content).find('#hdnInventoryCode').val(response.Properties.InventoryCode);
        $(_content).find('#hdnIsObsolete').val(response.Properties.IsObsolete);
        $(_content).find('#hdnIsRequired').val(response.Properties.IsRequired);
        if (response.Properties.ConfigurableProductSKUs != undefined) {
            $(_content).find('#hdnConfigurableProductSKUs').val(response.Properties.ConfigurableProductSKUs);
        }
        else {
            $(_content).find('#hdnConfigurableProductSKUs').val("");
        }
        if (response.Properties.GroupProductSKUs != undefined) {
            $(_content).find('#hdnGroupProductSKUs').val(response.Properties.GroupProductSKUs);
        }
        else {
            $(_content).find('#hdnGroupProductSKUs').val("");
        }
        if (response.Properties.GroupProductsQuantity != undefined) {
            $(_content).find('#hdnGroupProductsQuantity').val(new Array(response.Properties.GroupProductSKUs.split(",").length + 1).join($(_content).find('.txtQuickOrderQuantity').val() + "_").replace(/\_$/, ''));
        }
        else {
            $(_content).find('#hdnGroupProductsQuantity').val("");
        }
        if (response.Properties.CallForPricing != undefined) {
            $(_content).find('#hdnQuickOrderCallForPricing').val(response.Properties.CallForPricing);
        }
        else {
            $(_content).find('#hdnQuickOrderCallForPricing').val("false");
        }
        if (response.Properties.TrackInventory != undefined) {
            $(_content).find('#hdnQuickOrderInventoryTracking').val(response.Properties.TrackInventory);
        }
        else {
            $(_content).find('#hdnQuickOrderInventoryTracking').val("");
        }
        if (response.Properties.OutOfStockMessage != undefined) {
            $(_content).find('#hdnQuickOrderOutOfStockMessage').val(ZnodeBase.prototype.getResourceByKeyName("ErrorOutOfStockMessage"));
        }
        if (response.Properties.MaxQuantity != undefined) {
            $(_content).find('#hdnQuickOrderMaxQty').val(response.Properties.MaxQuantity);
        }
        if (response.Properties.MinQuantity != undefined) {
            $(_content).find('#hdnQuickOrderMinQty').val(response.Properties.MinQuantity);
        }
        if (response.Properties.IsPersonalisable != undefined) {
            $(_content).find('#hdnIsPersonisable').val(response.Properties.IsPersonalisable);
        }
    };
    QuickOrder.prototype.ValidateAddToCart = function (_content) {
        var quantity = parseFloat($(_content).find('.txtQuickOrderQuantity').val());
        var maxQuantity = parseFloat($(_content).find('#hdnQuickOrderMaxQty').val());
        var trackInventory = $(_content).find('#hdnQuickOrderInventoryTracking').val();
        var productType = $(_content).find('#hdnQuickOrderProductType').val();
        var retailPrice = $(_content).find('#hdnRetailPrice').val();
        var inventorySettingQuantity = $(_content).find('#hdnQuickOrderQuantityOnHand').val();
        var isPersonisable = $(_content).find('#hdnIsPersonisable').val();
        var inventoryCode = $(_content).find('#hdnInventoryCode').val();
        var isObsolete = $(_content).find('#hdnIsObsolete').val();
        var isRequired = $(_content).find('#hdnIsRequired').val();
        $("#hdnTemplateNameQuickOrder").val($("#TemplateName").val());
        if (productType != "" && productType.toLowerCase().trim() != "groupedproduct" && (retailPrice == "")) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorPriceNotSet"));
            return false;
        }
        if (isObsolete == "true") {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ObsoleteProductErrorMessage"));
            $('#btnQuickOrder').attr('disabled', 'disabled');
            return false;
        }
        if (isPersonisable == "true" && isRequired == "true") {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorAddToCartFromPDPOrQuickView"));
            return false;
        }
        if ((inventoryCode) && ((inventoryCode.toLowerCase().trim() == ZnodeBase.prototype.getResourceByKeyName("DontTrackInventory")) || inventoryCode.toLowerCase().trim() == ZnodeBase.prototype.getResourceByKeyName("AllowBackOrdering").toLowerCase())) {
            return true;
        }
        if ($(_content).find('#hdnttxtSKU').val() != $(_content).find('#hdnQuickOrderSku').val()) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorValidSKU"));
            return false;
        }
        if (parseInt($(_content).find('.txtQuickOrderQuantity').val()) % 1 != 0 || parseInt($(_content).find('.txtQuickOrderQuantity').val()) <= 0) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorValidQuantity"));
            return false;
        }
        if (isNaN($(_content).find('.txtQuickOrderQuantity').val()) || $(_content).find('.txtQuickOrderQuantity').val() == "") {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorWholeNumber"));
            return false;
        }
        if ($(_content).find('#hdnQuickOrderCallForPricing').val() == "true") {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("CallForPricing"));
            return false;
        }
        if ((trackInventory == "DisablePurchasing")) {
            if (parseFloat($(_content).find("#hdnQuickOrderQuantityOnHand").val()) <= 0) {
                $(_content).find('#inventorymsg').html($(_content).find('#hdnQuickOrderOutOfStockMessage').val());
                return false;
            }
        }
        if (parseFloat($(_content).find('#hdnQuickOrderMaxQty').val()) < quantity + parseFloat($(_content).find("#hdnQuickOrderCartQuantity").val())) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectedQuantityExceedsMaxCartQuantity"));
            return false;
        }
        if (parseInt($(_content).find('#hdnQuickOrderMinQty').val()) > quantity) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectedQuantityLessThanMinSpecifiedQuantity"));
            return false;
        }
        if ((trackInventory == "DisablePurchasing")) {
            if (parseFloat($(_content).find('#hdnQuickOrderQuantityOnHand').val()) == parseFloat($(_content).find("#hdnQuickOrderCartQuantity").val())) {
                $(_content).find('#inventorymsg').html($(_content).find('#hdnQuickOrderOutOfStockMessage').val());
                return false;
            }
        }
        if ((trackInventory == "DisablePurchasing")) {
            if (quantity + parseFloat($(_content).find("#hdnQuickOrderCartQuantity").val()) > parseFloat($(_content).find('#hdnQuickOrderQuantityOnHand').val())) {
                $(_content).find('#inventorymsg').html("Only " + (parseFloat($(_content).find('#hdnQuickOrderQuantityOnHand').val()) - parseFloat($(_content).find("#hdnQuickOrderCartQuantity").val())) + " quantities are available for Add to cart/Shipping");
                return false;
            }
        }
        if (productType != "" && productType.toLowerCase().trim() != "groupedproduct" && (inventorySettingQuantity == "" || inventorySettingQuantity == undefined || inventorySettingQuantity == 0)) {
            $(_content).find('#inventorymsg').html($(_content).find('#hdnQuickOrderOutOfStockMessage').val());
            return false;
        }
        if (maxQuantity < quantity) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("SelectedQuantityBetween") + 1 + ZnodeBase.prototype.getResourceByKeyName("To") + maxQuantity);
            return false;
        }
        return true;
    };
    QuickOrder.prototype.RemoveValidationMessage = function () {
        $("#hdnttxtSKU").on("focusout", function () {
            var _content = $(this).closest(".quick-order-container");
            $(_content).find('#txtQuickOrderQuantity').val('1');
            $(_content).find('#inventorymsg').text('');
            if ($(_content).find(".txtQuickOrderSku").val() == "") {
                $(_content).find('#inventorymsg').html("");
                $(_content).find('.quickOrderAddToCart').attr('disabled', 'disabled');
                $(_content).find('.txtQuickOrderQuantity').val("1");
            }
        });
        $("#txtQuickOrderQuantity").on("focusout", function () { $('#inventorymsg').text(''); });
    };
    QuickOrder.prototype.SetProperties = function () {
        var _focus = document.activeElement;
        var _content = $(_focus).closest(".quick-order-container");
        $(_content).find('.quickOrderAddToCart').attr('disabled', 'disabled');
        $(_content).find('#txtQuickOrderQuantity').attr('Value', 1);
    };
    QuickOrder.prototype.SetQuantity = function () {
        $("#txtQuickOrderQuantity").on("focusout", function (ev) {
            if ($(this).val() != "") {
                if ($(this).val() > 0) {
                    $(this).val(parseInt($(this).val()));
                }
                else {
                    $(this).val($(this).val().replace(/[^\d].+/, ""));
                    if ((ev.which < 49 || ev.which > 57)) {
                        $(this).val(1);
                    }
                }
            }
        });
    };
    QuickOrder.prototype.CloseTemplateQuickOrder = function () {
        $('.close-quick-order-popup').click();
    };
    //Nivi Code start
    //AddtoCart From PLP
    QuickOrder.prototype.AddtoCartPlp = function (item) {
        ZnodeBase.prototype.ShowLoader();
        var productId = parseInt(item.attributes.id.value);
        var strId = "txtQuickOrderQuantity_" + productId;
        var qty = parseInt($("#" + strId).val());
        if (qty > 0) {
            if (qty < $("#" + strId).data("minquantity") || qty > $("#" + strId).data("maxquantity")) {
                $("#" + strId).val($("#" + strId).data("minquantity"));
                ZnodeBase.prototype.HideLoader();
                return true;
            }
            Endpoint.prototype.CustomAddtoCart(productId, qty, function (response) {
                if (!response.status) {
                    $("#" + strId).val("0");
                }
                Product.prototype.DisplayAddToCartMessage(response);
            });
        }
        else {
            Checkout.prototype.HideLoader();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper("Quantity must be in multiple of " + $("#" + strId).attr("data-minquantity"), "error", isFadeOut, fadeOutTime);
        }
    };
    return QuickOrder;
}(ZnodeBase));
$(document).on("keypress", "#txtQuickOrderQuantity,.txtQuickOrderQuantity", function (e) {
    var key = e.keyCode || e.which;
    if ((47 < key) && (key < 58) || key === 8) {
        return true;
    }
    return false;
});
$('#txtQuickOrderQuantity').on("cut copy paste", function (e) {
    e.preventDefault();
});
$(window).on("load", function () {
    QuickOrder.prototype.ShowHideQuickOrderPopUp();
    QuickOrder.prototype.CloseQuickOrderpopup();
    QuickOrder.prototype.Validation();
    QuickOrder.prototype.RemoveValidationMessage();
    QuickOrder.prototype.SetProperties();
    QuickOrder.prototype.SetQuantity();
});
//# sourceMappingURL=QuickOrder.js.map