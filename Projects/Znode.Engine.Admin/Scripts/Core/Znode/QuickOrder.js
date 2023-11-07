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
        QuickOrder.prototype.ShowHideQuickOrderPopUp();
        QuickOrder.prototype.CloseQuickOrderpopup();
        QuickOrder.prototype.Validation();
        QuickOrder.prototype.RemoveValidationMessage();
        QuickOrder.prototype.SetProperties();
        QuickOrder.prototype.SetQuantity();
    };
    QuickOrder.prototype.OnItemSelect = function (item) {
        var _focus = document.activeElement;
        var _content = $(_focus).closest(".quick-order-container");
        $(_content).find('.txtQuickOrderSku').val(item.displaytext);
        $(_content).find('#hdnttxtSKU').val(item.displaytext);
        $(_content).find('#hdnQuickOrderProductId').val(item.id);
        $(_content).find('#hdnQuickOrderSku').val(item.displaytext);
        $(_content).find('#hdnQuickOrderProductName').val(item.properties.ProductName);
        $(_content).find('#hdnQuickOrderQuantityOnHand').val(item.properties.Quantity);
        $(_content).find('#hdnQuickOrderCartQuantity').val(item.properties.CartQuantity);
        $(_content).find('#hdnQuickOrderProductType').val(item.properties.ProductType);
        $(_content).find('#hdnRetailPrice').val(item.properties.RetailPrice);
        $(_content).find('#hdnImagePath').val(item.properties.ImagePath);
        $(_content).find('#hdnIsPersonisable').val(item.properties.IsPersonalisable);
        if (item.properties.CallForPricing != undefined) {
            $(_content).find('#hdnQuickOrderCallForPricing').val(item.properties.CallForPricing);
        }
        else {
            $(_content).find('#hdnQuickOrderCallForPricing').val("false");
        }
        if (item.properties.TrackInventory != undefined) {
            $(_content).find('#hdnQuickOrderInventoryTracking').val(item.properties.TrackInventory);
        }
        else {
            $(_content).find('#hdnQuickOrderInventoryTracking').val("");
        }
        if (item.properties.OutOfStockMessage != undefined) {
            $(_content).find('#hdnQuickOrderOutOfStockMessage').val(item.properties.OutOfStockMessage);
        }
        if (item.properties.MaxQuantity != undefined) {
            $(_content).find('#hdnQuickOrderMaxQty').val(item.properties.MaxQuantity);
        }
        if (item.properties.MinQuantity != undefined) {
            $(_content).find('#hdnQuickOrderMinQty').val(item.properties.MinQuantity);
        }
        if (item.properties.IsPersonalisable != undefined) {
            $(_content).find('#hdnIsPersonisable').val(item.properties.IsPersonalisable);
        }
        $(_content).find('.quickOrderAddToCart').prop('disabled', false);
    };
    QuickOrder.prototype.Validation = function () {
        var _focus = document.activeElement;
        var _content = $(_focus).closest(".quick-order-container");
        var quantity = parseFloat($(_content).find('.txtQuickOrderQuantity').val());
        var trackInventory = $(_content).find('#hdnQuickOrderInventoryTracking').val();
        var productType = $(_content).find('#hdnQuickOrderProductType').val();
        var retailPrice = $(_content).find('#hdnRetailPrice').val();
        var inventorySettingQuantity = $(_content).find('#hdnQuickOrderQuantityOnHand').val();
        var isPersonisable = $(_content).find('#hdnIsPersonisable').val();
        $("#hdnTemplateNameQuickOrder").val($("#TemplateName").val());
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
                $(_content).find('#inventorymsg').html($('#hdnQuickOrderOutOfStockMessage').val());
                return false;
            }
        }
        if ((trackInventory == "DisablePurchasing")) {
            if (quantity + parseFloat($(_content).find("#hdnQuickOrderCartQuantity").val()) > parseFloat($(_content).find('#hdnQuickOrderQuantityOnHand').val())) {
                $(_content).find('#inventorymsg').html("Only " + (parseFloat($(_content).find('#hdnQuickOrderQuantityOnHand').val()) - parseFloat($(_content).find("#hdnQuickOrderCartQuantity").val())) + " quantities are available for Add to cart/Shipping");
                return false;
            }
        }
        if ((productType == "GroupedProduct" || productType == "ConfigurableProduct")) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorAddToCartFromPDPOrQuickView"));
            return false;
        }
        if ((retailPrice == "")) {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorPriceNotSet"));
            return false;
        }
        if (inventorySettingQuantity == "" || inventorySettingQuantity == undefined || inventorySettingQuantity == 0) {
            $(_content).find('#inventorymsg').html($('#hdnQuickOrderOutOfStockMessage').val());
            return false;
        }
        if (isPersonisable == "true") {
            $(_content).find('#inventorymsg').html(ZnodeBase.prototype.getResourceByKeyName("ErrorAddToCartFromPDPOrQuickView"));
            return false;
        }
        Endpoint.prototype.QuickOrderAddToCart(QuickOrder.prototype.BindCartModel(), function (response) {
            $("#divShoppingCart").empty();
            $("#divShoppingCart").append(response);
            Order.prototype.ClearShippingEstimates();
            if (Order.prototype.IsQuote()) {
                $("#div-coupons-promotions").hide();
            }
            else {
                if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
                    $("#div-coupons-promotions").hide();
                }
                else {
                    $("#div-coupons-promotions").show();
                }
            }
            Order.prototype.ToggleFreeShipping();
            $('*[data-autocomplete-url]').each(function () { autocompletewrapper($(this), $(this).data("onselect-function")); });
        });
    };
    QuickOrder.prototype.ShowHideQuickOrderPopUp = function () {
        $(".quickordercontainer").on('mouseenter touch', function () {
            $(this).find(".divQuickOrder").show();
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
    QuickOrder.prototype.BindCartModel = function () {
        var _cartItemModel = {
            SKU: $('#hdnQuickOrderSku').val(),
            ProductName: $('#hdnQuickOrderProductName').val(),
            PublishProductId: $('#hdnQuickOrderProductId').val(),
            ProductType: $('#hdnQuickOrderProductType').val(),
            Quantity: $('.txtQuickOrderQuantity').val(),
        };
        return _cartItemModel;
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
                if ($(this).val() >= 0) {
                    $(this).val(parseInt($(this).val()));
                }
                else {
                    $(this).val($(this).val().replace(/[^\d].+/, ""));
                    if ((ev.which < 48 || ev.which > 57)) {
                        $(this).val(1);
                    }
                }
            }
        });
    };
    QuickOrder.prototype.CloseTemplateQuickOrder = function () {
        $('.close-quick-order-popup').click();
    };
    return QuickOrder;
}(ZnodeBase));
//# sourceMappingURL=QuickOrder.js.map