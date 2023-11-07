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
var OrderSidePanel = /** @class */ (function (_super) {
    __extends(OrderSidePanel, _super);
    function OrderSidePanel() {
        return _super.call(this) || this;
    }
    OrderSidePanel.prototype.Init = function () {
    };
    OrderSidePanel.prototype.SetSidePanelData = function (activeTab) {
        OrderSidePanel.prototype.ShowHideTab(activeTab, 1);
        if (activeTab == 'z-customers') {
            if ($("#OrderId").val() == "" && $("#OrderId").val() == "0") {
                OrderSidePanel.prototype.ShowHideTab('z-address', 0);
                OrderSidePanel.prototype.ShowHideTab('z-shopping-cart', 0);
                OrderSidePanel.prototype.ShowHideTab('z-shipping-methods', 0);
                OrderSidePanel.prototype.ShowHideTab('z-payment', 0);
                $("#OrderAsidePannel>li:gt(1)").addClass("disabled");
            }
        }
        OrderSidePanel.prototype.SetOrderData();
    };
    OrderSidePanel.prototype.SetOrderData = function () {
        $("#spnUserName").text($("#txtCustomerName").val());
        if ($("#OrderId").val() > 0)
            $("#spnStoreName").text($("#StoreName").val());
        else
            $("#spnStoreName").text($("#txtPortalName").val());
        OrderSidePanel.prototype.ShowAddressData();
        OrderSidePanel.prototype.ShowCartData();
        OrderSidePanel.prototype.ShowShippingData();
        OrderSidePanel.prototype.ShowPaymentData();
    };
    OrderSidePanel.prototype.ShowPaymentData = function () {
        if ($("#ddlPaymentTypes option:selected").index() > 0)
            $("#spnPaymentName").text($("#ddlPaymentTypes option:selected").text());
        else {
            OrderSidePanel.prototype.ShowHideTab('z-payment', 0);
            $("#spnPaymentName").text('');
        }
    };
    OrderSidePanel.prototype.ShowShippingData = function () {
        var shippingId = $("input[name='ShippingId']:checked").attr("id");
        var shippingName = $("#" + shippingId).attr("data-shipping-name");
        shippingName = typeof shippingName == "undefined" || shippingName == "" ? $("input[name='ShippingId']:checked").attr("data-shipping-name") : shippingName;
        if (shippingName != undefined && shippingName.length > 0)
            $("#spnShippingName").text(shippingName);
        else {
            OrderSidePanel.prototype.ShowHideTab('z-shipping-methods', 0);
            $("#spnShippingName").text('');
        }
    };
    OrderSidePanel.prototype.ShowAddressData = function () {
        var address = $(".address-title");
        var billAdd = '';
        var shippAdd = '';
        if (address != undefined && address.length > 0 && ("#layout-cart table:visible").length > 0) {
            shippAdd = address[0].innerHTML;
            billAdd = address[1].innerHTML;
        }
        $("#spnBillingAddressName").text(billAdd);
        $("#spnShippingAddressName").text(shippAdd);
    };
    OrderSidePanel.prototype.ShowCartData = function () {
        var cart = $("#layout-cart");
        var tblBody = $("#tbodyCartItems");
        var content = '';
        if (cart != undefined
            && cart.length > 0
            && $("#tbodyCartItems").filter(function () {
                return this.style.display !== "none";
            }).length > 0) {
            cart.find('.product-list-items').each(function () {
                var sku = $(this).find('input[id^=CartQuantity]').attr("data-cart-sku");
                var productName = $(this).find('input[id^=CartQuantity]').attr("data-cart-productName");
                var qty = $(this).find('input[id^=CartQuantity]').val();
                content += "<tr><td><p class='sku-name'>" + sku + "</p></td><td><p class='product-name'>" + productName + "</p></td ><td>" + qty + "</td></tr>";
            });
        }
        tblBody.html(content);
        jQuery('img').on('error', function (e) {
            this.src = window.location.protocol + "//" + window.location.host + "/Content/Images/no-image.png";
        });
    };
    OrderSidePanel.prototype.ShowHideTab = function (tab, show) {
        var display = show == 1 ? "block" : "none";
        $("#" + tab + " .pull-right").attr("style", "display:" + display);
        $("#" + tab + " .tab-details").attr("style", "display:" + display);
    };
    OrderSidePanel.prototype.ValidatePortal = function () {
        if ($("#ddlPortal").val() == "" || $("#ddlPortal").val() == 0 || $("#txtPortalName").val() == "") {
            $("#errorRequiredStore").text('').text(ZnodeBase.prototype.getResourceByKeyName("SelectPortal")).addClass("field-validation-error").show();
            $("#txtPortalName").parent("div").addClass('input-validation-error');
            return false;
        }
        return true;
    };
    OrderSidePanel.prototype.ContinueOrder = function () {
        var activeTab = $("#OrderAsidePannel>li.tab-selected").attr("id");
        var nextTab = $("#OrderAsidePannel>li.tab-selected").next('li');
        if (OrderSidePanel.prototype.CheckValidationOnDiv(activeTab))
            return false;
        if (activeTab == 'z-customers') {
            if ($("#txtCustomerName").val() == "") {
                OrderSidePanel.prototype.ValidatePortal();
                $('#' + $(this).attr('id')).addClass('input-validation-error');
                $('#' + $(this).attr('id')).attr('style', 'border: 1px solid rgb(195, 195, 195)');
                $('span#CustomerNameError').removeClass('field-validation-valid');
                $('span#CustomerNameError').addClass('field-validation-error');
                $('#txtCustomerName').addClass('input-validation-error');
                $('span#CustomerNameError').text(ZnodeBase.prototype.getResourceByKeyName("ErrorCustomerSelect"));
                return false;
            }
            else if (typeof $("#hdnUserId").val() == 'undefined' || $("#hdnUserId").val() == '0') {
                $('#' + $(this).attr('id')).addClass('input-validation-error');
                $('#' + $(this).attr('id')).attr('style', 'border: 1px solid rgb(195, 195, 195)');
                $('span#CustomerNameError').removeClass('field-validation-valid');
                $('span#CustomerNameError').addClass('field-validation-error');
                $('span#CustomerNameError').text(ZnodeBase.prototype.getResourceByKeyName("InvalidCustomer"));
                return false;
            }
        }
        if (activeTab == 'z-address') {
            if (typeof $("#ShippingAddress_AddressId").val() == 'undefined' || $("#ShippingAddress_AddressId").val() == '0') {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingAddress"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
            $('*[data-autocomplete-url]').each(function () { autocompletewrapper($(this), $(this).data("onselect-function")); });
        }
        if (activeTab == 'z-shopping-cart') {
            if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorItemNotFountInCart"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
            $('*[data-autocomplete-url]').each(function () { autocompletewrapper($(this), $(this).data("onselect-function")); });
        }
        if (activeTab == 'z-shipping-methods') {
            if ($('#shippingMethodDiv input[name="ShippingId"]').length > 0) {
                if ($("#shippingMethodDiv :radio:checked").length == 0 && ($("#cartFreeShipping").val() != "True" || $("#hdnIsFreeShipping").val() != "True")) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectShippingMethod"), 'error', isFadeOut, fadeOutTime);
                    return false;
                }
            }
            if (!Order.prototype.ShippingErrorMessage()) {
                return false;
            }
            if (!Order.prototype.ShowAllowedTerritoriesError()) {
                return false;
            }
            if ($("#hndShippingclassName").val() != undefined && $("#hndShippingclassName").val() == Constant.ZnodeCustomerShipping) {
                if ($("#ShippingListViewModel_AccountNumber").val() == undefined || $("#ShippingListViewModel_AccountNumber").val() == "") {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterAccountNumber"), 'error', isFadeOut, fadeOutTime);
                    return false;
                }
                if ($("#ShippingListViewModel_ShippingMethod").val() == undefined || $("#ShippingListViewModel_ShippingMethod").val() == "") {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterShippingMethod"), 'error', isFadeOut, fadeOutTime);
                    return false;
                }
            }
            var id = $("#shippingMethodDiv :radio:checked").attr('id');
            var customShipping = $("#CustomShipping_" + id + "").val();
            var estimateShipping = $("#CustomShipping_" + id + "").attr("data-estimate-shipping");
            Order.prototype.AddCustomShippingAmount(customShipping, estimateShipping);
        }
        if (activeTab == 'z-payment') {
            if ($("#hdnTotalOrderAmount").val() == undefined || $("#hdnTotalOrderAmount").val() > 0.00 && ($("#hdnOverDueAmount").val() >= 0.00)) {
                if ($("#ddlPaymentTypes option:selected").val() == '') {
                    $('#' + $(this).attr('id')).addClass('input-validation-error');
                    $('#' + $(this).attr('id')).attr('style', 'border: 1px solid rgb(195, 195, 195)');
                    $('span#valPaymentTypes').removeClass('field-validation-valid');
                    $('span#valPaymentTypes').addClass('field-validation-error');
                    $('span#valPaymentTypes').text(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectPaymentType"));
                    return false;
                }
                if ($("#ddlPaymentTypes option:selected").attr("id") != null && $("#ddlPaymentTypes option:selected").attr("id") != undefined) {
                    if ($("#ddlPaymentTypes option:selected").attr("id").toLowerCase() == 'credit_card') {
                        if (!Order.prototype.ValidateDetails("false"))
                            return false;
                    }
                    else if ($("#ddlPaymentTypes option:selected").attr("id").toLowerCase() == 'purchase_order') {
                        var poControl = $("#PurchaseOrderNumber");
                        var purchaseOrderNumber = poControl.val();
                        if (purchaseOrderNumber == "" || purchaseOrderNumber == null || purchaseOrderNumber == 'undefined') {
                            $("#cart-ponumber-status").show();
                            poControl.addClass('input-validation-error');
                            return false;
                        }
                    }
                }
                else {
                    $("#cart-ponumber-status").hide();
                }
            }
        }
        $("#OrderAsidePannel>li.tab-selected").removeClass("tab-selected");
        if (nextTab.length > 0) {
            nextTab.addClass('tab-selected');
            nextTab.find('a').trigger('click');
        }
        OrderSidePanel.prototype.SetSidePanelData(activeTab);
        if ($("#IsFromUserCart").val() == 'True' && activeTab == 'z-customers') {
            Order.prototype.showCurrentTab();
        }
    };
    OrderSidePanel.prototype.CheckValidationOnDiv = function (activeTab) {
        var activeDiv;
        var IsInvalid = false;
        switch (activeTab) {
            case "z-customers":
                activeDiv = "CustomerDiv";
                break;
            case "z-address":
                activeDiv = "AddressDiv";
                break;
            case "z-shopping-cart":
                activeDiv = "ShoppingCartDiv";
                break;
            case "z-shipping-methods":
                activeDiv = "shippingMethodDiv";
                break;
            case "z-payment":
                activeDiv = "paymentMethodsDiv";
                break;
            case "z-review":
                activeDiv = "ReviewDiv";
                break;
        }
        $('div#' + activeDiv + '').find("[data-val-required]").each(function () {
            if ($(this).attr('type') != 'hidden' && $(this).val() === "") {
                if ($("#hdnTotalOrderAmount").val() > 0.00 && ($("#hdnOverDueAmount").val() >= 0.00)) {
                    $('#' + $(this).attr('id')).addClass('input-validation-error');
                    $('#' + $(this).attr('id')).attr('style', 'border: 1px solid rgb(195, 195, 195)');
                    $('span#' + $(this).attr('name') + 'Error').removeClass('field-validation-valid');
                    $('span#' + $(this).attr('name') + 'Error').addClass('field-validation-error');
                    $('span#' + $(this).attr('name') + 'Error').text($(this).attr('data-val-required'));
                    IsInvalid = true;
                }
                else {
                    IsInvalid = false;
                }
            }
            else if (activeDiv == 'ShoppingCartDiv') {
                if ($("#hdnIsAnyProductOutOfStock").val() != undefined && $("#hdnIsAnyProductOutOfStock").val().toLowerCase() == 'true' || $("#hdnIsAnyProductOutOfStock").val() == true) {
                    IsInvalid = true;
                }
                else {
                    $('tr#cart-row-div').each(function () {
                        if ($('#quantity_error_msg_' + $(this).find('#CartQuantity').attr('data-cart-externalid') + '').text().trim() != '') {
                            IsInvalid = true;
                        }
                    });
                }
            }
            else if ($(this).attr('type') != 'hidden' && typeof ($(this).attr('class')) != 'undefined') {
                if ($(this).attr('class').indexOf("input-validation-error") > 0) {
                    IsInvalid = true;
                }
            }
            else if ($("[name='SaveCard-CVV']:visible").length > 0) {
                var cardtype = $("[name='SaveCard-CVV']:visible").attr('data-cardtype');
                var cvvNumber = $("[name='SaveCard-CVV']:visible").val();
                if (cardtype == Constant.AmericanExpressCardCode) {
                    if (!cvvNumber || cvvNumber.length < 4) {
                        OrderSidePanel.prototype.ValidationOfCVV();
                        Order.prototype.ShowHideErrorCVV(false);
                        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvc"]');
                        IsInvalid = true;
                    }
                }
                else if (!cvvNumber || (cvvNumber.length <= 2 || cvvNumber.length > 4)) {
                    IsInvalid = true;
                    Order.prototype.ShowHideErrorCVV(false);
                    Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvc"]');
                    OrderSidePanel.prototype.ValidationOfCVV();
                }
                else {
                    IsInvalid = false;
                }
            }
        });
        return IsInvalid;
    };
    OrderSidePanel.prototype.ValidationOfCVV = function () {
        $("[name='SaveCard-CVV']:visible").css({
            "border": "1px solid red",
            "background": "#FFCECE"
        });
        $("[name='SaveCard-CVV']:visible").parent().find("span.field-validation-error").length <= 0 ?
            $("[name='SaveCard-CVV']:visible").parent().append("<span class='field-validation-error error-cvv'>" + ZnodeBase.prototype.getResourceByKeyName("CVVErrorMessage") + "</span>") :
            $("[name='SaveCard-CVV']:visible").parent().find("span.field-validation-error").show();
    };
    OrderSidePanel.prototype.OnBlurPurchaseOrderNumber = function () {
        var poOrderNumber = $("#PurchaseOrderNumber").val();
        if (poOrderNumber != "" && poOrderNumber != null && poOrderNumber != "undefined") {
            $("#cart-ponumber-status").hide();
            $(poOrderNumber).removeClass('input-validation-error');
        }
    };
    OrderSidePanel.prototype.ConfirmCancelOrderPopUp = function () {
        $('#PopUpConfirmCancelOrder').modal('show');
    };
    OrderSidePanel.prototype.ConfirmCancelOrder = function () {
        window.location.href = '/Order/List';
    };
    OrderSidePanel.prototype.ConfirmCancelCustomerOrderPopUp = function () {
        $('#PopUpConfirmCancelCustomerOrder').modal('show');
    };
    OrderSidePanel.prototype.ConfirmCancelCustomerOrder = function () {
        window.location.href = '/Customer/GetOrderList?userId=' + $("#hdnUserId").val();
    };
    OrderSidePanel.prototype.ConfirmCancelQuoteOrderPopUp = function () {
        $('#PopUpConfirmCancelQuoteOrder').modal('show');
    };
    OrderSidePanel.prototype.ConfirmCancelQuoteOrder = function () {
        window.location.href = '/Quote/AccountQuoteList';
    };
    OrderSidePanel.prototype.ConfirmCancelAccountQuoteOrderPopUp = function () {
        $('#PopUpConfirmCancelAccountQuoteOrder').modal('show');
    };
    OrderSidePanel.prototype.ConfirmCancelAccountQuoteOrder = function () {
        window.location.href = '/Account/AccountQuoteList?accountId=' + $("#hdnAccountId").val();
    };
    OrderSidePanel.prototype.ConfirmCancelQuotePopUp = function () {
        $('#PopUpConfirmCancelQuote').modal('show');
    };
    OrderSidePanel.prototype.ConfirmCancelQuote = function () {
        window.location.href = '/Quote/QuoteList';
    };
    return OrderSidePanel;
}(ZnodeBase));
//# sourceMappingURL=OrderSidePanel.js.map