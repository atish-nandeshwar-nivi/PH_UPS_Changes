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
var Quote = /** @class */ (function (_super) {
    __extends(Quote, _super);
    function Quote() {
        return _super.call(this) || this;
    }
    Quote.prototype.Init = function () {
        Order.prototype.Init();
        ZnodeDateRangePicker.prototype.Init(Quote.prototype.DateTimePickerRange());
    };
    Quote.prototype.HideConvertToOrderColumn = function () {
        $('#grid tbody tr').each(function () {
            $(this).find("td").each(function () {
                if ($(this).hasClass('grid-action')) {
                    if ($(this).next().children().hasClass("z-active")) {
                        $(this).children().children("ul").children().find(".z-orders").parent().hide();
                    }
                }
            });
            $(this).find("td.IsConvertedToOrder").each(function () {
                if ($(this).children("i").hasClass("z-active")) {
                    $(this).next().children().children("ul").children().find(".z-orders").parent().hide();
                }
            });
        });
        $('#grid th').each(function () {
            if ($.trim($(this).text()) == "Is Converted To Order")
                $(this).hide();
        });
        $('#grid').find(".IsConvertedToOrder").hide();
    };
    //This method is used to select store from fast select and show it on textbox
    Quote.prototype.OnSelectPortalDataBind = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            $('#txtPortalName').val(portalName);
            $('#hdnPortalId').val(portalId);
        }
        Quote.prototype.GetSearchQuoteListByPortalId();
    };
    //To get the quote list when any selection is made from fast select control.
    Quote.prototype.GetSearchQuoteListByPortalId = function () {
        Quote.prototype.SetFastSelectFilter("portalid", $("#hdnPortalId").val());
        Quote.prototype.SubmitFormOnFastSelection();
        ZnodeDateRangePicker.prototype.Init(Quote.prototype.DateTimePickerRange());
    };
    Quote.prototype.DateTimePickerRange = function () {
        var ranges = {
            'All Quotes': [],
            'Last Hour': [],
            'Last Day': [],
            'Last 7 Days': [],
            'Last 30 Days': [],
        };
        return ranges;
    };
    //To set filters related to fast select control present on _FilterComponent.cshtml page.
    Quote.prototype.SetFastSelectFilter = function (filterName, filterValue) {
        $("#fastSelectFilterName").attr({
            "name": filterName,
            "value": filterValue
        });
        $("#fastSelectFilterOperator").attr({
            "name": "DataOperatorId",
            "value": "1"
        });
    };
    //To submit the form when any selection is made from fast select control.
    Quote.prototype.SubmitFormOnFastSelection = function () {
        UpdateContainerId = $("#fastSelectFilterName").closest('form').attr('data-ajax-update').replace("#", "");
        $("#fastSelectFilterName").closest("form").submit();
    };
    Quote.prototype.GetQuoteId = function () {
        var omsquoteId = $("#hdnManageOmsQuoteId").val();
        if (omsquoteId != null && omsquoteId != "") {
            var quoteId = parseInt(omsquoteId);
            if (quoteId > 0) {
                return quoteId;
            }
        }
        return 0;
    };
    Quote.prototype.GetPortalId = function () {
        return $("#txtPortalName").attr("data-portalid") != undefined ? parseInt($("#txtPortalName").attr("data-portalid")) : parseInt($("#PortalId").val());
    };
    Quote.prototype.GetUserId = function () {
        return $('#hdnUserId').val() == undefined ? parseInt($("#labelCustomerId").text().trim()) : parseInt($("#hdnUserId").val());
    };
    //Save Manage Quote Details
    Quote.prototype.SubmitForm = function (data) {
        $(data).closest("form").submit();
    };
    Quote.prototype.CancelQuote = function () {
        if ($('#ddlQuoteStatus').val() != Enum.OrderStatusDropdown.CANCELED) {
            var form = $('#QuoteStatus');
            form.find('#SelectedItemValue').val(ZnodeBase.prototype.getResourceByKeyName("Canceled"));
            form.find('#SelectedItemId').val(Enum.OrderStatusDropdown.CANCELED);
            $('#ddlQuoteStatus').val(Enum.OrderStatusDropdown.CANCELED);
            form.submit();
        }
    };
    Quote.prototype.BindQuoteData = function () {
        Quote.prototype.DisableManageQuoteControls();
        Quote.prototype.GetQuoteShippingList();
        if ($('#hdnIsConvertedToOrder').val() != undefined && $('#hdnIsConvertedToOrder').val() == "True")
            Quote.prototype.FreezeManageQuote(true);
    };
    Quote.prototype.OnQuoteStatusChange = function (obj) {
        var currentform = $(obj).closest("form").children();
        var selected = $(obj).find('option:selected');
        if (selected.val() == Enum.OrderStatusDropdown.SUBMITTED) {
            var selectedstatus = currentform.find('#SelectedItemValue').val();
            $(obj).val($(obj).find("option:contains('" + selectedstatus + "')").attr('value'));
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorOnSelectSubmitted"), "error", isFadeOut, fadeOutTime);
        }
        else if (selected.val() == Enum.OrderStatusDropdown.EXPIRED) {
            var selectedstatus = currentform.find('#SelectedItemValue').val();
            $(obj).val($(obj).find("option:contains('" + selectedstatus + "')").attr('value'));
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorOnSelectExpired"), "error", isFadeOut, fadeOutTime);
        }
        else if (selected.val() == Enum.OrderStatusDropdown.APPROVED) {
            if (!Quote.prototype.ValidateQuote()) {
                var selectedstatus = currentform.find('#SelectedItemValue').val();
                $(obj).val($(obj).find("option:contains('" + selectedstatus + "')").attr('value'));
            }
            else {
                Quote.prototype.BindSelectedOptionForStatus(obj);
            }
        }
        else {
            if (obj.id == "ddlQuoteStatus") {
                Quote.prototype.BindSelectedOptionForStatus(obj);
            }
        }
    };
    Quote.prototype.OnAccountQuoteStatusChange = function (obj) {
        var quoteCurrentStatus = $(obj).find('option:selected');
        $("#hdnOmsOrderStateId").val(quoteCurrentStatus.val());
    };
    Quote.prototype.ValidateQuote = function () {
        var omsQuoteId = Quote.prototype.GetQuoteId();
        if ($('#hdnActiveProductCount').val() > 0) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorInActiveProduct"), "error", isFadeOut, fadeOutTime);
            return false;
        }
        if ($("#hndShippingclassName").val() != undefined && $("#hndShippingclassName").val() == Constant.ZnodeCustomerShipping && omsQuoteId > 0) {
            if ($("#txtShippingMethod").val() == undefined || $("#txtShippingMethod").val() == null || $("#txtShippingMethod").val() == "") {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterShippingMethod"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
            if ($("#txtAccountNumber").val() == undefined || $("#txtAccountNumber").val() == null || $("#txtAccountNumber").val() == "") {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterAccountNumber"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
        }
        if ($("#dynamic-allowesterritories").length > 0) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AllowedTerritories"), "error", isFadeOut, fadeOutTime);
            return false;
        }
        if ($("#hdnIsSaveQuote").val() != undefined && $("#hdnIsSaveQuote").val() == "false") {
            return false;
        }
        return true;
    };
    Quote.prototype.OnUpdateQuoteStatus = function (data) {
        if (data != undefined && data != null && data.SelectedItemId > 0) {
            $("#ddlQuoteStatus").val(data.SelectedItemId);
            Quote.prototype.DisableManageQuoteControls();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.HasError ? data.ErrorMessage : data.SuccessMessage, data.HasError ? "error" : "success", isFadeOut, fadeOutTime);
        }
    };
    Quote.prototype.BindSelectedOptionForStatus = function (obj) {
        var currentform = $(obj).closest("form").children();
        currentform.find('#SelectedItemValue').val($(obj).find('option:selected').text());
        currentform.find('#SelectedItemId').val($(obj).val());
        Quote.prototype.SubmitForm(obj);
    };
    Quote.prototype.DisableManageQuoteControls = function () {
        Endpoint.prototype.GetQuoteStateValueById($('#ddlQuoteStatus').find('option:selected').val(), function (response) {
            if ($('#SelectedItemValue').val() == "Approved" || !response.isEdit) {
                Quote.prototype.FreezeManageQuote(true);
            }
            else {
                Quote.prototype.FreezeManageQuote(false);
            }
        });
    };
    Quote.prototype.FreezeManageQuote = function (flag) {
        if (flag) {
            $("#cancelQuote").attr("disabled", true);
            $("#shippingTypes").attr("disabled", true);
            $("#quoteInformation select").attr("disabled", true);
            $("#quoteInformation input").attr("disabled", true);
            $("#customerInformation a").hide();
            $("#customerInformation input").hide();
            $("#divTotal input").attr("disabled", true);
            $("#chkTaxExempt").attr("disabled", true);
            $('#quoteLineItems select').attr("disabled", true);
            $('#quoteLineItems input').attr("disabled", true);
            $(".sp-actions").hide();
        }
        else {
            $("#cancelQuote").attr("disabled", false);
            $("#shippingTypes").attr("disabled", false);
            $("#quoteInformation select").attr("disabled", false);
            $("#quoteInformation input").attr("disabled", false);
            $("#customerInformation a").show();
            $("#customerInformation input").show();
            $("#divTotal input").attr("disabled", false);
            $("#chkTaxExempt").attr("disabled", false);
            $('#quoteLineItems select').attr("disabled", false);
            $(".sp-actions").show();
        }
    };
    //Get Manage Quote Additional note pop-up
    Quote.prototype.GetAdditionalNote = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanelWithCallBack('/Quote/GetAdditionalNotes', 'additionalNotes', function (response) {
            $('#notes').val($('#additionalNotes').val());
        });
    };
    //Bind the added note
    Quote.prototype.SaveAddedNote = function () {
        var notes = $('#notes').val();
        $('#additionalNotes').val(notes);
        ZnodeBase.prototype.CancelUpload('additionalNotes');
    };
    //To show success/error message on the basis of response status
    Quote.prototype.ChangeShippingAccountNumberSuccessCallback = function (response) {
        if (response.status) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateShippingAccountNo"), "success", isFadeOut, fadeOutTime);
            $("#spnShippingAccountNumber").hide();
        }
        else
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.ErrorMessage, "error", isFadeOut, fadeOutTime);
    };
    //To show success/error message on the basis of response status
    Quote.prototype.ChangeShippingMethodSuccessCallback = function (response) {
        if (response.status) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateShippingMethod"), "success", isFadeOut, fadeOutTime);
            $("#spnShippingMethod").hide();
        }
        else
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.ErrorMessage, "error", isFadeOut, fadeOutTime);
    };
    //To show success/error message on the basis of response status
    Quote.prototype.ChangeInHandDateSuccessCallback = function (response) {
        if (response.status) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateInHandDate"), "success", isFadeOut, fadeOutTime);
        }
        else
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.ErrorMessage, "error", isFadeOut, fadeOutTime);
    };
    //To show success/error message on the basis of response status
    Quote.prototype.ChangeQuoteExpirationDateSuccessCallback = function (response) {
        if (response.status) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateQuoteExpirationDate"), "success", isFadeOut, fadeOutTime);
        }
        else
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.ErrorMessage, "error", isFadeOut, fadeOutTime);
    };
    //Get Shipping List for manage Quote
    Quote.prototype.GetQuoteShippingList = function () {
        Endpoint.prototype.GetQuoteShippingList(Quote.prototype.GetQuoteId(), function (response) {
            var data = response.status;
            var shippingList = data.ShippingList;
            var currentSelectected = $('#hndShippingTypeId').val();
            $('#shippingTypes').empty();
            if (shippingList.filter(function (obj) { return obj.ShippingId === parseInt($('#hndShippingTypeId').val()); }).length < 0)
                $("#hdnIsShippingChange").val('true');
            $.each(shippingList, function (index, element) {
                $('#shippingTypes').append($("<option value=\"" + element.ShippingId + "\"  class = \"" + element.ClassName + "\" ><text>" + element.Description + "</text></option>"));
                if (element.ShippingId == currentSelectected)
                    $("#shippingTypes option[value=" + element.ShippingId + "]").attr('selected', 'selected');
            });
            Quote.prototype.CheckIsQuoteOrder();
        });
    };
    //Bind the selected shipping
    Quote.prototype.GetSelectedShipping = function (data) {
        var currentTarget = $(data).find('option:selected');
        if (currentTarget.attr('value') != undefined && currentTarget.attr('class') != undefined) {
            Quote.prototype.ShippingSelectHandler(parseInt(currentTarget.attr('value')), currentTarget.attr('class'));
        }
    };
    //Calculate Shipping In Manage Quote
    Quote.prototype.ShippingSelectHandler = function (ShippingId, shippingTypeClass) {
        $('#hndShippingTypeId').val(ShippingId);
        $("#hndShippingclassName").val(shippingTypeClass);
        $("#AccountNumber").val("");
        if (shippingTypeClass == Constant.ZnodeCustomerShipping) {
            $("#customerShippingDiv").show();
        }
        else {
            $("#customerShippingDiv").hide();
        }
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.CalculateShippingInManage(ShippingId, Quote.prototype.GetQuoteId(), function (response) {
            $("#asidePannelmessageBoxContainerId").hide();
            if (response.shippingErrorMessage != "" && response.shippingErrorMessage != null && response.shippingErrorMessage != "undefined") {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.shippingErrorMessage, "error", isFadeOut, fadeOutTime);
                return false;
            }
            //Set shopping cart details of user.
            $("#quoteLineItems").html(response.CartView);
            if ($('#hdnShoppingCartCount').val() == undefined || $('#hdnShoppingCartCount').val() == 0) {
                Quote.prototype.CancelQuote();
            }
            ZnodeBase.prototype.HideLoader();
            Quote.prototype.ShippingErrorMessage();
        });
    };
    //Show Shipping Error Message
    Quote.prototype.ShippingErrorMessage = function () {
        if ($("#hdnShippiingErrorMessage").length > 0) {
            var shippingErrorMessage = $("#hdnShippiingErrorMessage").val();
            if ($("#hdnHasError").val().toLowerCase() == "true" && shippingErrorMessage != "" && shippingErrorMessage != null && shippingErrorMessage != 'undefined') {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(shippingErrorMessage, 'error', isFadeOut, 10000);
                return false;
            }
            return true;
        }
    };
    Quote.prototype.ValidateShippingDetails = function (data) {
        var amount = $(data).find('input[type="text"]').val();
        if (!isNaN(amount)) {
            if (amount < 0) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingtAmountNegative"), "error", isFadeOut, fadeOutTime);
                return false;
            }
            else if ($(data).find('input[type="text"]').val() == "") {
                $("#ShippingCost").val($('#hdnShippingCost').val()).removeClass('input-validation-error');
                return false;
            }
            return true;
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RequiredNumericValue"), "error", isFadeOut, fadeOutTime);
            $("#ShippingCost").val($('#hdnShippingCost').val()).removeClass('input-validation-error');
            return false;
        }
    };
    //round off price as per global setting
    Quote.prototype.UpdatePriceSuccessCallback = function (data) {
        var form = $(data).closest("form");
        var input = $(form).find('input[type="text"]');
        var num = parseFloat(input.val());
        var roundOff = input.attr('data-priceroundoff');
        $("#" + input.attr('id')).val(num.toFixed(parseInt(roundOff)));
        if ($('#hdnShoppingCartCount').val() == undefined || $('#hdnShoppingCartCount').val() == 0) {
            Quote.prototype.CancelQuote();
        }
    };
    //Get Address Detail Popup
    Quote.prototype.GetCustomerAddressForManange = function (fromBillingShipping, selectedAddressId, shippingBillingId, omsQuoteId) {
        $("#customerDetails").html("");
        $("#hdnIsShipping").val(fromBillingShipping);
        var ShippingAddressId = fromBillingShipping == 'shipping' ? selectedAddressId : shippingBillingId;
        var BillingAddressId = fromBillingShipping == 'billing' ? selectedAddressId : shippingBillingId;
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Quote/GetUserAddressForManageById?selectedAddressId=' + selectedAddressId + '&omsQuoteId=' + omsQuoteId + '&ShippingAddressId=' + ShippingAddressId + '&BillingAddressId=' + BillingAddressId + '&userId=' + $("#hdnUserId").val() + '&portalId=' + Quote.prototype.GetPortalId() + '' + '&fromBillingShipping=' + fromBillingShipping + '', 'addressDetails');
        $("#addressDetails").find('.chkShippingBilling').remove();
    };
    //Map Calculated Shopping cart after address gets updated.
    Quote.prototype.ChangeAddressSuccessForManage = function (response) {
        if (response.errorMessage != "" && response.errorMessage != null && response.errorMessage != "undefined") {
            $("#asidePannelmessageBoxContainerId div").html(response.errorMessage);
            $("#asidePannelmessageBoxContainerId").show();
            return false;
        }
        if (response.shippingErrorMessage != "" && response.shippingErrorMessage != null && response.shippingErrorMessage != "undefined") {
            $("#asidePannelmessageBoxContainerId div").html(response.shippingErrorMessage);
            $("#asidePannelmessageBoxContainerId").show();
            return false;
        }
        if (response.addressView.indexOf("field-validation-error") < 0) {
            ZnodeBase.prototype.CancelUpload('addressDetails');
            $("#customerInformation").html(response.addressView);
            $("#divTotal").html(response.quoteTotal);
            $("#divShoppingCart").html("");
            $("#divShoppingCart").html(response.totalView);
            Quote.prototype.RemoveFormDataValidation();
            Quote.prototype.GetQuoteShippingList();
        }
        else {
            $("#divCustomerAddressPopup").html(response.addressView);
            $(".chkShippingBilling").show();
        }
    };
    //Remove Address Validation
    Quote.prototype.RemoveFormDataValidation = function () {
        $('form').removeData('validator');
        $('form').removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse('form');
        $('#IsDefaultShipping').rules('remove');
        $('#IsDefaultBilling').rules('remove');
    };
    Quote.prototype.CustomerAddressViewHandler = function (control) {
        Quote.prototype.ShowHideAddressCheckBoxDiv(control);
        if (control == 'shipping') {
            $("#BillingAddressContainer").hide();
            $('#IsShippingAddressChange').val('true');
        }
        else if (control == 'billing') {
            $("#BillingAddressContainer").show();
            $("#ShippingAddressContainer").hide();
        }
        else {
            $("#addressDetails").find('.chkShippingBilling').show();
        }
        $("#addressDetails").find('#shippingSameAsBillingAddressDiv').remove();
    };
    Quote.prototype.ShowHideAddressCheckBoxDiv = function (addressType) {
        if (addressType == 'shipping') {
            $("#DefaultBillingAddressDiv").hide();
            $("#DefaultShippingAddressDiv").show();
        }
        if (addressType == 'billing') {
            $("#DefaultShippingAddressDiv").hide();
            $("#DefaultBillingAddressDiv").show();
        }
    };
    //Delete Cart Item in Manage Quote
    Quote.prototype.DeleteQuoteCartItem = function (control) {
        if ($('#hdnShoppingCartCount').val() == "1") {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorDeleteLastItem"), "error", isFadeOut, fadeOutTime);
        }
        else {
            Quote.prototype.ValidateShippingMethod();
            ZnodeBase.prototype.ShowPartialLoader("loader-cart-content");
            var guid = $(control).attr('data_cart_externalid');
            var omsQuoteId_1 = Quote.prototype.GetQuoteId();
            Endpoint.prototype.DeleteQuoteCartItem(omsQuoteId_1, guid, function (response) {
                if (response.success) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessDeleteLineItem"), "success", isFadeOut, fadeOutTime);
                    $("#quoteLineItems").html(response.html);
                    //Calculate the shopping cart
                    Quote.prototype.CalculateShoppingCart(omsQuoteId_1);
                }
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorDeleteLineItem"), "error", isFadeOut, fadeOutTime);
                ZnodeBase.prototype.HidePartialLoader("loader-cart-content");
            });
        }
    };
    //Calculate Shopping Cart of Quote
    Quote.prototype.CalculateShoppingCart = function (omsQuoteId, showLoader) {
        if (showLoader === void 0) { showLoader = true; }
        if (showLoader) {
            ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        }
        Endpoint.prototype.CalculateQuoteShoppingCart(omsQuoteId, function (response) {
            if (response.html.length > 0) {
                if (omsQuoteId > 0) {
                    $("#divTotal").html(response.html);
                }
                if (showLoader) {
                    ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
                }
            }
        });
    };
    //Update CartItem with price and Quantity
    Quote.prototype.UpdateCartItem = function (guid) {
        var _quoteLineItemDetail = Quote.prototype.BindCartItemModel(guid);
        var quantityError = "#quantity_error_msg_" + guid;
        $('#IsQuoteLineShippingUpdated_' + guid).val("false");
        if (this.CheckQuantityValidations(_quoteLineItemDetail.Quantity, guid, quantityError)) {
            if (this.CheckUnitPriceValidations(_quoteLineItemDetail.UnitPrice.toString(), guid)) {
                if (_quoteLineItemDetail.Quantity != null && _quoteLineItemDetail.Quantity != "") {
                    Endpoint.prototype.UpdateQuoteCartItem(_quoteLineItemDetail, function (response) {
                        Quote.prototype.ClearErrorMessages(guid);
                        Quote.prototype.DisplayUpdatedLineItemData(response, guid);
                        Quote.prototype.UpdateQuoteLineItemShipping(response.lineItemShipping);
                        if (response.hasError) {
                            $(quantityError).html(response.errorMessage);
                            $(quantityError).show();
                            $('#hdnIsSaveQuote').val("false");
                        }
                        else {
                            $(quantityError).html("");
                            $(quantityError).hide();
                            $('#hdnIsSaveQuote').val("true");
                        }
                    });
                }
            }
        }
    };
    //Bind Cart Item Data
    Quote.prototype.BindCartItemModel = function (guid) {
        var currencySymbol = $("#hdnCurrencySymbol_" + guid).val();
        var _quoteLineItemDetail = {
            OmsQuoteId: Quote.prototype.GetQuoteId(),
            Quantity: ($("#cartQuantity-" + guid).val() == null && $("#cartQuantity-" + guid).val() == "") ? $("#quantity-" + guid).text() : $("#cartQuantity-" + guid).val(),
            UnitPrice: ($("#unitprice-" + guid).val().split(currencySymbol)[1] == undefined || $("#unitprice-" + guid).val().split(currencySymbol)[1] == '') ? $("#unitprice-" + guid).val() : $("#unitprice-" + guid).val().split(currencySymbol)[1].replace(/,/g, ''),
            ProductId: parseInt($("#cartQuantity-" + guid).attr("data-cart-productid")),
            Guid: guid,
            ShippingCost: ($("#shippingcost_" + guid).val().split(currencySymbol)[1] == undefined || $("#shippingcost_" + guid).val().split(currencySymbol)[1] == '') ? $("#shippingcost_" + guid).val() : $("#shippingcost_" + guid).val().split(currencySymbol)[1].replace(/,/g, ''),
            IsShippingEdit: $('#IsQuoteLineShippingUpdated_' + guid).val()
        };
        return _quoteLineItemDetail;
    };
    //Clear error message of item
    Quote.prototype.ClearErrorMessages = function (guid) {
        $("#unit_price_error_msg_" + guid).html("");
        $("#quantity_error_msg_" + guid).html("");
    };
    //To display updated cart item data
    Quote.prototype.DisplayUpdatedLineItemData = function (response, guid) {
        $("#unitprice-" + guid).text(response.unitPrice);
        $("#unitprice-" + guid).val(response.unitPrice);
        $("#shippingcost_" + guid).val(response.shippingCost);
        $("#extendedPrice_" + guid).text(response.extendedPrice);
        $("#quantity-" + guid).text(response.quantity);
        $("#divTotal").html(response.totalView);
        $("#hdnQuoteLineItemShipping_" + guid).val(response.shippingCost);
    };
    //Validate Quantity
    Quote.prototype.CheckQuantityValidations = function (quantity, guid, quantityError) {
        var decimalPoint = quantity.split(".")[1] != null ? quantity.split(".")[1].length : 0;
        var decimalValue = quantity.split(".")[1] != null ? parseInt(quantity.split(".")[1]) : 0;
        var priceRoundOff = parseInt($("#cartQuantity-" + guid).attr("data-inventoryRoundOff"));
        if (this.CheckIsNumeric(quantity, quantityError)) {
            if (this.CheckDecimalValue(decimalPoint, decimalValue, priceRoundOff, quantityError)) {
                if (Order.prototype.CheckQuantityGreaterThanZero(parseInt(quantity), quantityError)) {
                    return true;
                }
            }
        }
        return false;
    };
    //Validate Unit Price
    Quote.prototype.CheckUnitPriceValidations = function (unitPrice, guid) {
        var quantityError = "#unit_price_error_msg_" + guid;
        var decimalPoint = unitPrice.split(".")[1] != null ? unitPrice.split(".")[1].length : 0;
        var decimalValue = unitPrice.split(".")[1] != null ? parseInt(unitPrice.split(".")[1]) : 0;
        var priceRoundOff = parseInt($("#unit-price-" + guid).attr("data-priceRoundOff"));
        if (unitPrice == "")
            return true;
        if (this.CheckDecimalValue(decimalPoint, decimalValue, priceRoundOff, quantityError, true)) {
            if (parseFloat(unitPrice) > 999999) {
                $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorPriceRange"));
                $(quantityError).css("class", "error-msg");
                return false;
            }
            return true;
        }
        return false;
    };
    Quote.prototype.CheckDecimalValue = function (decimalPoint, decimalValue, inventoryRoundOff, quantityError, isPrice) {
        if (isPrice === void 0) { isPrice = false; }
        if (decimalValue != 0 && decimalPoint > inventoryRoundOff) {
            if (isPrice)
                $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("EnterPriceHaving") + inventoryRoundOff + ZnodeBase.prototype.getResourceByKeyName("XNumbersAfterDecimalPoint"));
            else
                $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("EnterQuantityHaving") + inventoryRoundOff + ZnodeBase.prototype.getResourceByKeyName("XNumbersAfterDecimalPoint"));
            $(quantityError).css("class", "error-msg");
            $(quantityError).show();
            return false;
        }
        $(quantityError).hide();
        return true;
    };
    Quote.prototype.CheckIsNumeric = function (selectedQty, quantityError) {
        var matches = selectedQty.match(/^-?[\d.]+(?:e-?\d+)?$/);
        if (matches == null) {
            $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("RequiredNumericValue"));
            $(quantityError).addClass("error-msg");
            $(quantityError).show();
            return false;
        }
        return true;
    };
    Quote.prototype.OnTaxExemptChecked = function () {
        if ($("#chkTaxExempt").is(':checked')) {
            $("#PopUpTaxExemptSubmitQuote").modal("show");
        }
        else {
            Quote.prototype.ConfirmTaxExemptQuote();
        }
    };
    Quote.prototype.ConfirmTaxExemptQuote = function () {
        var isTaxExempt = $("#chkTaxExempt").prop("checked");
        ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        Endpoint.prototype.UpdateTaxExemptForQuote(Quote.prototype.GetQuoteId(), isTaxExempt, function (response) {
            $("#divTotal").html("");
            $("#divTotal").html(response);
            if (isTaxExempt == true) {
                $("#messageTaxExcempt").html(ZnodeBase.prototype.getResourceByKeyName("TaxExemptMessage"));
            }
            else {
                $("#messageTaxExcempt").html(ZnodeBase.prototype.getResourceByKeyName("MakeTaxExemptMessage"));
            }
            ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
        });
    };
    Quote.prototype.CheckTaxExemptOnPageLoad = function () {
        if ($("#hdnIsTaxExempt").val() == "True") {
            $("#containerTaxExempt").show();
            $("#messageTaxExcempt").html("This Quote Tax Exempted");
        }
        $("#divTaxExemptContainer").show();
    };
    Quote.prototype.PrintManangeQuote = function () {
        Endpoint.prototype.PrintManangeQuote(Quote.prototype.GetQuoteId(), function (response) {
            if (response.success) {
                var originalContents = document.body.innerHTML;
                if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1) {
                    setTimeout(function () { document.body.innerHTML = response.html; }, 1);
                    setTimeout(function () { window.print(); }, 10);
                    setTimeout(function () { document.body.innerHTML = originalContents; }, 20);
                    setTimeout(function () { Order.prototype.HideLoader(); }, 30);
                }
                else {
                    document.body.innerHTML = response.html;
                    window.print();
                    document.body.innerHTML = originalContents;
                }
            }
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingCalculation"), "error", isFadeOut, fadeOutTime);
            return false;
        });
    };
    //To show success/error message on the basis of response status
    Quote.prototype.ChangeJobNameSuccessCallback = function (response) {
        if (response.status) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateJobName"), "success", isFadeOut, fadeOutTime);
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.ErrorMassage, "error", isFadeOut, fadeOutTime);
        }
    };
    //To show success/error message on the basis of response status
    Quote.prototype.ChangeShippingConstraintCodeSuccessCallback = function (response) {
        if (response.status) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateShippingConstraintCode"), "success", isFadeOut, fadeOutTime);
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.ErrorMassage, "error", isFadeOut, fadeOutTime);
        }
    };
    //Confirm Submit Quote.
    Quote.prototype.OnConfirmSubmitQuote = function () {
        if (!(Quote.prototype.ValidateQuote()))
            return false;
        Quote.prototype.ShowSubmitPopup();
    };
    Quote.prototype.SubmitEditQuote = function () {
        var notes = "";
        if ($("#additionalNotes").val() != "") {
            notes = $("#additionalNotes").val();
        }
        Endpoint.prototype.UpdateManageQuote(Quote.prototype.GetQuoteId(), notes, function (data) {
            if (!data.status)
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.errorMessage, "error", isFadeOut, fadeOutTime);
            window.location.reload(true);
        });
    };
    Quote.prototype.SubmitAccountQuote = function (flag) {
        var notes = "";
        var OmsOrderStateId = "";
        if ($("#additionalNotes").val() != "") {
            notes = $("#additionalNotes").val();
        }
        if ($("#hdnOmsOrderStateId").val() != "") {
            OmsOrderStateId = $("#hdnOmsOrderStateId").val();
        }
        Endpoint.prototype.UpdateAccountManageQuote(Quote.prototype.GetQuoteId(), notes, OmsOrderStateId, function (data) {
            if (!data.status)
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.errorMessage, "error", isFadeOut, fadeOutTime);
            if (flag != false) {
                window.location.replace("/Quote/AccountQuoteList");
            }
            else {
                window.location.reload(true);
            }
        });
    };
    //Validate Shipping method is exist or not before shipping calculation
    Quote.prototype.ValidateShippingMethod = function () {
        if ($('#hdnIsShippingChange').val() == "true") {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingCalculation"), "error", isFadeOut, fadeOutTime);
            return false;
        }
    };
    Quote.prototype.SubmitQuote = function () {
        ZnodeBase.prototype.ShowLoader();
        var isValid = true;
        isValid = Quote.prototype.ValidateDetails("false");
        if (isValid) {
            ZnodeBase.prototype.ShowLoader();
            Quote.prototype.CreateQuote();
        }
        if (!isValid)
            ZnodeBase.prototype.HideLoader();
    };
    Quote.prototype.CreateQuote = function () {
        $('#status-message').remove();
        $("#PortalId").val(Order.prototype.GetPortalId());
        $.ajax({
            url: "/Quote/SubmitQuote",
            data: Quote.prototype.SetQuoteCreateViewModel(),
            type: 'POST',
            success: function (data) {
                if (!data.HasError) {
                    window.location.href = "/Quote/QuoteList";
                }
                else {
                    ZnodeBase.prototype.HideLoader();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.ErrorMessage, 'error', isFadeOut, fadeOutTime);
                }
            }
        });
    };
    Quote.prototype.SetQuoteCreateViewModel = function () {
        var QuoteCreateViewModel = {
            UserId: $('#hdnUserId').val(),
            ShippingId: $('#selectedShippingId').val(),
            EnableAddressValidation: $("#enableAddressValidation").val(),
            AdditionalInstruction: $("#AdditionalInstruction").val(),
            AccountNumber: $("#ShippingListViewModel_AccountNumber").val(),
            ShippingMethod: $("#ShippingListViewModel_ShippingMethod").val(),
            InHandDate: $("#InHandDate").val(),
            QuoteExpirationDate: $("#QuoteExpirationDate").val(),
            JobName: $("#JobName").val(),
            ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val()
        };
        return QuoteCreateViewModel;
    };
    Quote.prototype.ReviewQuote = function () {
        var isValid = Quote.prototype.ValidateDetails("false");
        if (isValid) {
            ZnodeBase.prototype.ShowLoader();
            $.ajax({
                url: "/Order/GetReviewOrder",
                data: Order.prototype.SetCreateOrderViewModel(),
                type: 'POST',
                success: function (data) {
                    Order.prototype.HideLoader();
                    $("#ReviewDiv").html(data);
                    var shippingId = $("input[name='ShippingId']:checked").attr("id");
                    var shippingName = $("#shippingMethodDiv input[id='" + shippingId + "']").attr("data-shipping-name");
                    var shippingValue = $("#shippingMethodDiv input[id='" + shippingId + "']").attr("data-shippingvalue");
                    var customShippingCost = $("#hdnCustomShippingCost").val();
                    shippingName = typeof shippingName == "undefined" || shippingName == "" ? $("input[name='ShippingId']:checked").attr("data-shipping-name") : shippingName;
                    if (customShippingCost == '') {
                        $("#selectedShippingName").html(shippingName + ": " + shippingValue);
                    }
                    else {
                        $("#selectedShippingName").html(shippingName);
                    }
                    $("#customerDivReview").html($("#customerDiv").html());
                    $("#orderNotes").html($("#AdditionalInstruction").val());
                    $("#divQuoteExpirationDate").html($("#QuoteExpirationDate").val());
                    $("#inHandDates").html($("#InHandDate").val());
                    $("#jobName").html($("#JobName").val());
                    $("#shippingConstraintsCode").html($("input[name='ShippingConstraintCode']:checked").attr('data-shipping-name'));
                    GridPager.prototype.Init();
                    if (Order.prototype.IsQuote()) {
                        $("#divPaymentReview").hide();
                        $("#label-review-order").html(ZnodeBase.prototype.getResourceByKeyName("LabelReviewQuote"));
                        $("#label-review-order-sub-msg").html(ZnodeBase.prototype.getResourceByKeyName("ReviewQuoteSubMessage"));
                    }
                }
            });
        }
        return isValid;
    };
    Quote.prototype.ValidateDetails = function (isQuote) {
        ZnodeBase.prototype.ShowLoader();
        var isValid = true;
        if ($("#txtCustomerName").val() == '') {
            isValid = false;
            $("#txtCustomerName").css({
                "border": "1px solid red"
            });
            Order.prototype.ClickSelectedTab("customer-tab-link");
        }
        else if ($("[name='ShippingId']").val() == undefined || $("[name='ShippingId']").val() == "" || $("#shippingMethodDiv :radio:checked").length == 0 && ($("#cartFreeShipping").val() != "True" || $("#hdnIsFreeShipping").val() != "True")) {
            if (isQuote != "true") {
                Order.prototype.ClickSelectedTab("shipping-cart-tab-link");
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingNotAvailable"), "error", isFadeOut, fadeOutTime);
                isValid = false;
            }
        }
        else {
            if ($("#ShippingAddress_AddressId").val() == '0') {
                isValid = false;
            }
            ;
            if (!isValid) {
                Order.prototype.ClickSelectedTab("customer-tab-link");
            }
        }
        if (!Order.prototype.ShowAllowedTerritoriesError()) {
            isValid = false;
        }
        ZnodeBase.prototype.HideLoader();
        return isValid;
    };
    Quote.prototype.ShowSubmitPopup = function () {
        if ($('#SelectedItemValue').val() == "Approved" && $('#hdnIsConvertedToOrder').val() == "False") {
            $('#PopUpConvertToOrder').modal('show');
        }
        else {
            $('#PopUpConfirmSubmitQuote').modal('show');
        }
    };
    Quote.prototype.GetPaymentOptions = function () {
        if ($('#SelectedItemValue').val() == "Approved" && $('#hdnIsConvertedToOrder').val() == "False") {
            ZnodeBase.prototype.BrowseAsidePoupPanel('/Quote/GetPaymentMethods?&userId=' + $('#hdnUserId').val() + '&portalId=' + Quote.prototype.GetPortalId() + '', 'paymentStatusPanel');
        }
    };
    Quote.prototype.IsQuoteDataValid = function () {
        var isValid = true;
        var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
        var paymentOptionValue = Order.prototype.GetPaymentType(paymentOptionId);
        if (paymentOptionValue == null || paymentOptionValue == "") {
            $('#' + $(this).attr('id')).addClass('input-validation-error');
            $('#' + $(this).attr('id')).attr('style', 'border: 1px solid rgb(195, 195, 195)');
            $('span#valPaymentTypes').removeClass('field-validation-valid');
            $('span#valPaymentTypes').addClass('field-validation-error');
            $('span#valPaymentTypes').text(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectPaymentType"));
            return false;
        }
        else {
            $('span#valPaymentTypes').text("");
        }
        return isValid;
    };
    Quote.prototype.ResetQuoteStatus = function () {
        if ($('#ddlQuoteStatus').find('option:selected').text() != $('#hdnOmsQuoteStatus').val()) {
            var form = $('#QuoteStatus');
            $("#ddlQuoteStatus,#SelectedItemValue,#SelectedItemId, #hdnQuoteStatusQuoteId").attr("disabled", false);
            form.find('#SelectedItemValue').val($('#hdnOmsQuoteStatus').val());
            form.find('#SelectedItemId').val($('#hdnOmsQuoteStateId').val());
            $('#ddlQuoteStatus').val($('#hdnOmsQuoteStateId').val());
            form.submit();
        }
    };
    Quote.prototype.ConvertQuoteToOrder = function () {
        var paymentCode = $("#hdnGatewayCode").val().toLowerCase();
        if (paymentCode == Constant.CyberSource) {
            if ($('ul#creditCardTab ').find('li').find('a.active').attr('href') == "#savedCreditCard-panel" || $('ul#creditCardTab ').find('li.active').find('a').attr('href') == "#savedCreditCard-panel") {
                Quote.prototype.SubmitIframePayment("");
            }
            else {
                $("#pay-button").click();
            }
        }
        else {
            Quote.prototype.ConvertQuoteToOrderQuotes();
        }
    };
    Quote.prototype.ConvertQuoteToOrderQuotes = function () {
        if (Quote.prototype.IsQuoteDataValid()) {
            var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
            var paymentType = Order.prototype.GetPaymentType(paymentOptionId);
            switch (paymentType.toLowerCase()) {
                case "cod":
                    Quote.prototype.SubmitQuoteForm();
                    ZnodeBase.prototype.CancelUpload('paymentStatusPanel');
                    break;
                case "credit_card":
                    if (Quote.prototype.IsValidCreditCardDetails()) {
                        var paymentCode = $('#hdnGatewayCode').val();
                        if (paymentCode == Constant.CyberSource) {
                            Quote.prototype.SubmitIframePayment($("#CardDataToken").val());
                        }
                        else {
                            Quote.prototype.SubmitPayment();
                        }
                        ZnodeBase.prototype.CancelUpload('paymentStatusPanel');
                    }
                    break;
                case "ach":
                    Quote.prototype.SubmitACHPayment();
                    ZnodeBase.prototype.CancelUpload('paymentStatusPanel');
                    break;
                case "purchase_order":
                    if (Quote.prototype.CheckValidPODocument()) {
                        Quote.prototype.SubmitQuoteForm();
                    }
                    else {
                        ZnodeBase.prototype.HideLoader();
                        return false;
                    }
                    break;
                case "invoice me":
                    Quote.prototype.SubmitQuoteForm();
                    break;
            }
        }
    };
    Quote.prototype.CheckValidPODocument = function () {
        var purchaseOrderNumber = $('#PurchaseOrderNumber').val();
        if (purchaseOrderNumber != null) {
            if (purchaseOrderNumber.length < 1) {
                $('#cart-ponumber-status').show();
                $('#cart-ponumber-status').text(ZnodeBase.prototype.getResourceByKeyName('ErrorRequiredPurchaseOrder'));
                $(window).scrollTop(0);
                $(document).scrollTop(0);
                return false;
            }
            else if (purchaseOrderNumber.length > 50) {
                $('#cart-ponumber-status').show();
                $('#cart-ponumber-status').text(ZnodeBase.prototype.getResourceByKeyName('ErrorPurchaseOrderLength'));
                $(window).scrollTop(0);
                $(document).scrollTop(0);
                return false;
            }
            else if ($("#IsPoDocRequire").val() == "True") {
                if ($("#PODocument").val() == null || $("#PODocument").val() == "") {
                    $("#errorFileTypeAndSize").html(ZnodeBase.prototype.getResourceByKeyName("ErrorFileRequired"));
                    $(window).scrollTop(0);
                    $(document).scrollTop(0);
                    return false;
                }
            }
            return true;
        }
        else
            return true;
    };
    Quote.prototype.SubmitQuoteForm = function () {
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.SaveAndConvertQuoteToOrder(Quote.prototype.BindPaymentModel(), function (response) {
            if (response.OrderId !== undefined && response.OrderId > 0) {
                ZnodeBase.prototype.HideLoader();
                window.location.reload(true);
                $("#ajaxBusy").dialog('close');
                var form = $('<form action="QuoteCheckoutReceipt" method="post">' +
                    '<input type="hidden" name="orderId" value="' + response.OrderId + '" />' +
                    '<input type="text" name= "ReceiptHtml" value= "' + response.ReceiptHtml + '" />' +
                    '</form>');
                $('body').append(form);
                $(form).addClass("dirtyignore").submit();
            }
            else {
                $("#ajaxBusy").dialog('close');
                var errorMessage = response.error == undefined || response.error == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.error;
                Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                return false;
            }
        });
    };
    //Bind Cart Item Data
    Quote.prototype.BindPaymentModel = function () {
        var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
        var PaymentDetails = {
            PaymentSettingId: Number($("#ddlPaymentTypes option:selected").val()),
            paymentType: $("#ddlPaymentTypes " + "#" + paymentOptionId).attr("data-payment-type"),
            PurchaseOrderNumber: $("#PurchaseOrderNumber").val(),
            PODocumentName: $("#po-document-path").val(),
        };
        var _convertQuoteToOrderViewModel = {
            OmsQuoteId: Quote.prototype.GetQuoteId(),
            UserId: Quote.prototype.GetUserId(),
            AdditionalInstructions: $("#additionalNotes").val(),
            PaymentDetails: PaymentDetails,
        };
        return _convertQuoteToOrderViewModel;
    };
    //End Amazon Pay Methods. 
    Quote.prototype.GetPaymentType = function (id) {
        var paymentType = $("#" + id).attr("data-payment-type");
        if (paymentType != undefined) {
            return paymentType.toLowerCase();
        }
        else {
            return id;
        }
    };
    Quote.prototype.SubmitIframePayment = function (querystr) {
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            $("#div-CreditCard").hide();
            var orderNumber = "";
            Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) {
                orderNumber = response.orderNumber;
            });
            var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
            var paymentType = Order.prototype.GetPaymentType(paymentOptionId);
            var submitPaymentViewModel = {
                OmsQuoteId: Quote.prototype.GetQuoteId(),
                UserId: Quote.prototype.GetUserId(),
                PaymentDetails: {
                    PaymentSettingId: $('#PaymentSettingId').val(),
                    PaymentCode: $('#hdnPaymentCode').val(),
                    UserId: $("#hdnUserId").val(),
                    ShippingOptionId: $("[name='ShippingId']").val(),
                    BillingAddressId: $("#UserAddressDataViewModel_BillingAddress_AddressId").val(),
                    ShippingAddressId: $("#UserAddressDataViewModel_ShippingAddress_AddressId").val(),
                    PortalId: $("#hdnPortalId").val(),
                    PortalCatalogId: $("#PortalCatalogId").val(),
                    AdditionalInfo: $("#additionalInstructions").val(),
                    EnableAddressValidation: $("input[name='EnableAddressValidation']").val(),
                    RequireValidatedAddress: $("input[name='RequireValidatedAddress']").val(),
                    AccountNumber: $("#ShippingListViewModel_AccountNumber").val(),
                    ShippingMethod: $("#ShippingListViewModel_ShippingMethod").val(),
                    CardType: 'credit_card',
                    OrderNumber: orderNumber,
                    InHandDate: $("#InHandDate").val(),
                    JobName: $("#JobName").val(),
                    ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val(),
                    CyberSourceToken: querystr,
                    paymentType: paymentType,
                    IsSaveCreditCard: $("#SaveCreditCard").is(':checked'),
                    CustomerProfileId: $('#CustomerProfileId').val(),
                    CustomerPaymentId: $('#CustomerPaymentProfileId').val(),
                    CustomerGuid: $("#hdnCustomerGUID").val(),
                    PaymentGUID: $("#hdnPaymentGUID").val(),
                    GatewayCode: $("#hdnGatewayCode").val()
                }
            };
            $.ajax({
                type: "POST",
                url: "/quote/SaveAndConvertQuoteToOrder",
                async: true,
                data: submitPaymentViewModel,
                success: function (response) {
                    if (response.OrderId !== undefined && response.OrderId > 0) {
                        window.location.reload(true);
                        $("#ajaxBusy").dialog('close');
                        var form = $('<form action="QuoteCheckoutReceipt" method="post">' +
                            '<input type="hidden" name="orderId" value="' + response.OrderId + '" />' +
                            '<input type="text" name= "ReceiptHtml" value= "' + response.ReceiptHtml + '" />' +
                            '</form>');
                        $('body').append(form);
                        $(form).addClass("dirtyignore").submit();
                    }
                    else {
                        $("#ajaxBusy").dialog('close');
                        var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                        return false;
                    }
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessOrder"));
                    ZnodeBase.prototype.HideLoader();
                    return false;
                }
            });
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    //AuthorizeNet Payment
    Quote.prototype.SubmitAuthorizeNetPayment = function (querystr) {
        var Total = $("#hdnTotalAmt").val();
        var transactionResponse = JSON.parse(querystr);
        var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
        var paymentType = Order.prototype.GetPaymentType(paymentOptionId);
        var transactionId = transactionResponse.transId;
        var creditCardNumber = transactionResponse.accountNumber;
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            var submitPaymentViewModel = {
                OmsQuoteId: Quote.prototype.GetQuoteId(),
                UserId: Quote.prototype.GetUserId(),
                PaymentDetails: {
                    PaymentSettingId: Number($("#ddlPaymentTypes option:selected").val()),
                    GatewayCode: $("#hdnGatewayCode").val(),
                    PaymentCode: $('#hdnPaymentCode').val(),
                    paymentType: paymentType,
                    TransactionId: transactionId,
                    CustomerPaymentId: $('#CustomerPaymentProfileId').val(),
                    CustomerProfileId: $('#CustomerProfileId').val(),
                    IsSaveCreditCard: $("#SaveCreditCard").is(':checked'),
                    CreditCardNumber: (creditCardNumber).slice(-4),
                    CardType: 'credit_card',
                }
            };
            $.ajax({
                type: "POST",
                url: "/quote/SaveAndConvertQuoteToOrder",
                async: true,
                data: submitPaymentViewModel,
                success: function (response) {
                    if (response.OrderId !== undefined && response.OrderId > 0) {
                        window.location.reload(true);
                        $("#ajaxBusy").dialog('close');
                        var form = $('<form action="QuoteCheckoutReceipt" method="post">' +
                            '<input type="hidden" name="orderId" value="' + response.OrderId + '" />' +
                            '<input type="text" name= "ReceiptHtml" value= "' + response.ReceiptHtml + '" />' +
                            '</form>');
                        $('body').append(form);
                        $(form).addClass("dirtyignore").submit();
                    }
                    else {
                        $("#ajaxBusy").dialog('close');
                        var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                        return false;
                    }
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessOrder"));
                    ZnodeBase.prototype.HideLoader();
                    return false;
                }
            });
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    //Submit Payment
    Quote.prototype.SubmitPayment = function () {
        var Total = $("#hdnTotalQuoteAmount").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            if (Quote.prototype.IsValidCreditCardDetails()) {
                var paymentSettingId = Number($("#ddlPaymentTypes option:selected").val());
                var paymentCode = $('#hdnPaymentCode').val();
                //Get Payment model
                var payment = Order.prototype.GetPaymentModel();
                //Validate Payment Profile And Proceed for Convert To Order
                Quote.prototype.ValidatePaymentProfileAndConvertToOrder(payment, paymentSettingId, paymentCode);
            }
        }
    };
    //Submit Payment
    Quote.prototype.SubmitACHPayment = function () {
        var Total = $("#hdnTotalQuoteAmount").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            if (Order.prototype.ValidateCardConnectDataToken()) {
                var paymentSettingId = Number($("#ddlPaymentTypes option:selected").val());
                var paymentCode = $('#hdnPaymentCode').val();
                //Get Payment model
                var payment = Order.prototype.GetACHPaymentModel();
                //Validate Payment Profile And Proceed for Convert To Order
                Quote.prototype.ValidatePaymentProfileAndConvertToOrderForACH(payment, paymentSettingId, paymentCode);
            }
        }
    };
    Quote.prototype.IsValidCreditCardDetails = function () {
        var isValid = true;
        var paymentCode = $('#hdnGatewayCode').val();
        if (!$("#radioCCList").is(':visible')) {
            $('input[data-payment="number"],input[data-payment="exp-month"],input[data-payment="exp-year"],input[data-payment="cvc"]').each(function () {
                if ($.trim($(this).val()) == '') {
                    isValid = false;
                    $(this).css({
                        "border": "1px solid red",
                        "background": "#FFCECE"
                    });
                }
                else {
                    $(this).css({
                        "border": "1px solid black",
                        "background": ""
                    });
                }
            });
            if (paymentCode == Constant.CyberSource)
                isValid = Order.prototype.ValidateCardConnectDataToken();
            else if (paymentCode != "cardconnect")
                isValid = Quote.prototype.ValidateCreditCardDetails();
            else {
                if (Order.prototype.ValidateCardConnectDataToken() && Order.prototype.ValidateCardConnectCardHolderName()) {
                    var cardType = Order.prototype.DetectCardTypeForCardConnect($('#CardDataToken').val());
                    isValid = Order.prototype.ValidateCardType(cardType);
                }
                else
                    Order.prototype.ShowErrorPaymentDialog($("#ErrorMessage").val());
            }
        }
        else {
            isValid = Order.prototype.ValidateCVV();
        }
        if (isValid == false) {
            return false;
        }
        return isValid;
    };
    Quote.prototype.ValidateCreditCardDetails = function () {
        var isValid = true;
        var cardType = $('input[name="PaymentProviders"]:checked').val();
        if (!Order.prototype.Mod10($('input[data-payment="number"]').val().split(" ").join(""))) {
            isValid = false;
            $('#errornumber').show();
            Order.prototype.PaymentError("number");
        }
        else {
            $('#errornumber').hide();
            Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="number"]');
        }
        if (!Order.prototype.ValidateCreditCardExpirationDetails()) {
            isValid = false;
        }
        if ($('input[data-payment="cvc"]').val() == '') {
            $('#errorcvc').show();
        }
        else {
            $('#errorcvc').hide();
            Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvc"]');
        }
        if ($('input[data-payment="cvc"]').val().length < 3) {
            isValid = false;
            $('#errorcardnumber').show();
            Order.prototype.PaymentError("cvc");
        }
        else {
            if (cardType == Constant.AmericanExpressCardCode && $('input[data-payment="cvc"]').val().length == 4) {
                Order.prototype.ShowHideErrorCVV(false);
                Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvc"]');
            }
            else if (cardType != Constant.AmericanExpressCardCode && $('input[data-payment="cvc"]').val().length == 3) {
                Order.prototype.ShowHideErrorCVV(false);
                Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvc"]');
            }
            else {
                isValid = false;
                Order.prototype.ShowHideErrorCVV(true);
                Order.prototype.PaymentError("cvc");
            }
        }
        if ($('input[data-payment="cardholderName"]').val().trim() == '' || $('input[data-payment="cardholderName"]').val().trim().length > 100) {
            isValid = false;
            $('#errorcardholderName').show();
            Order.prototype.PaymentError("cardholderName");
        }
        else {
            $('#errorcardholderName').hide();
            Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cardholderName"]');
        }
        if (!isValid) {
            $(window).scrollTop(0);
            $(document).scrollTop(0);
        }
        return isValid;
    };
    Quote.prototype.ValidatePaymentProfileAndConvertToOrder = function (payment, paymentSettingId, paymentCode) {
        payment["CardSecurityCode"] = payment["PaymentToken"] ? $("[name='SaveCard-CVV']:visible").val() : $("#div-CreditCard [data-payment='cvc']").val();
        $("#div-CreditCard").hide();
        var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
        var paymentType = Order.prototype.GetPaymentType(paymentOptionId);
        var creditCardNumber = $("#hdnGatewayCode").val() == "cardconnect" ? $('#CardDataToken').val().slice(-4) : $('#CreditCardNumber').val();
        submitCard(payment, function (response) {
            if (response.GatewayResponse == undefined) {
                if (response.indexOf("Unauthorized") > 0) {
                    Quote.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessCreditCardPayment") + response + ZnodeBase.prototype.getResourceByKeyName("ContactUsToCompleteOrder"));
                    ZnodeBase.prototype.HideLoader();
                }
            }
            else {
                var isSuccess = response.GatewayResponse.IsSuccess;
                if (isSuccess) {
                    //Quote.prototype.ClosePopup();
                    var submitPaymentViewModel = Quote.prototype.GetSubmitPaymentViewModel(paymentSettingId, paymentCode, response, paymentType, creditCardNumber);
                    $.ajax({
                        type: "POST",
                        url: "/quote/SaveAndConvertQuoteToOrder",
                        async: true,
                        data: submitPaymentViewModel,
                        success: function (response) {
                            if (response.OrderId !== undefined && response.OrderId > 0) {
                                window.location.reload(true);
                                $("#ajaxBusy").dialog('close');
                                var form = $('<form action="QuoteCheckoutReceipt" method="post">' +
                                    '<input type="hidden" name="orderId" value="' + response.OrderId + '" />' +
                                    '<input type="text" name= "ReceiptHtml" value= "' + response.ReceiptHtml + '" />' +
                                    '</form>');
                                $('body').append(form);
                                $(form).addClass("dirtyignore").submit();
                            }
                            else {
                                $("#ajaxBusy").dialog('close');
                                var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                                Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                                return false;
                            }
                        },
                        error: function () {
                            Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessOrder"));
                            ZnodeBase.prototype.HideLoader();
                            return false;
                        }
                    });
                }
                else {
                    var errorMessage = response.GatewayResponse.ResponseText;
                    if (errorMessage == undefined) {
                        errorMessage = response.GatewayResponse.GatewayResponseData;
                    }
                    if (errorMessage != undefined && errorMessage.toLowerCase().indexOf("missing card data") >= 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorCardDataMissing"));
                    }
                    else if (errorMessage != undefined && errorMessage.indexOf("Message=") >= 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage.substr(errorMessage.indexOf("=") + 1));
                        $("#div-CreditCard").show();
                    }
                    else if (errorMessage.indexOf('customer') > 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                    }
                    else {
                        Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace"));
                    }
                }
            }
        });
    };
    Quote.prototype.ValidatePaymentProfileAndConvertToOrderForACH = function (payment, paymentSettingId, paymentCode) {
        payment["CardSecurityCode"] = payment["PaymentToken"] ? $("[name='SaveCard-CVV']:visible").val() : $("#div-CreditCard [data-payment='cvc']").val();
        $("#div-CreditCard").hide();
        var paymentOptionId = $("#ddlPaymentTypes option:selected").attr("id");
        var paymentType = Order.prototype.GetPaymentType(paymentOptionId);
        var creditCardNumber = $('#CreditCardNumber').val();
        submitCard(payment, function (response) {
            if (response.GatewayResponse == undefined) {
                if (response.indexOf("Unauthorized") > 0) {
                    Quote.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessCreditCardPayment") + response + ZnodeBase.prototype.getResourceByKeyName("ContactUsToCompleteOrder"));
                    ZnodeBase.prototype.HideLoader();
                }
            }
            else {
                var isSuccess = response.GatewayResponse.IsSuccess;
                if (isSuccess) {
                    //Quote.prototype.ClosePopup();
                    var submitPaymentViewModel = Quote.prototype.GetSubmitPaymentViewModelForACH(paymentSettingId, paymentCode, response, paymentType, creditCardNumber);
                    $.ajax({
                        type: "POST",
                        url: "/quote/SaveAndConvertQuoteToOrder",
                        async: true,
                        data: submitPaymentViewModel,
                        success: function (response) {
                            if (response.OrderId !== undefined && response.OrderId > 0) {
                                window.location.reload(true);
                                $("#ajaxBusy").dialog('close');
                                var form = $('<form action="QuoteCheckoutReceipt" method="post">' +
                                    '<input type="hidden" name="orderId" value="' + response.OrderId + '" />' +
                                    '<input type="text" name= "ReceiptHtml" value= "' + response.ReceiptHtml + '" />' +
                                    '</form>');
                                $('body').append(form);
                                $(form).addClass("dirtyignore").submit();
                            }
                            else {
                                $("#ajaxBusy").dialog('close');
                                var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                                Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                                return false;
                            }
                        },
                        error: function () {
                            Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessOrder"));
                            ZnodeBase.prototype.HideLoader();
                            return false;
                        }
                    });
                }
                else {
                    var errorMessage = response.GatewayResponse.ResponseText;
                    if (errorMessage == undefined) {
                        errorMessage = response.GatewayResponse.GatewayResponseData;
                    }
                    if (errorMessage != undefined && errorMessage.toLowerCase().indexOf("missing card data") >= 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorCardDataMissing"));
                    }
                    else if (errorMessage != undefined && errorMessage.indexOf("Message=") >= 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage.substr(errorMessage.indexOf("=") + 1));
                        $("#div-CreditCard").show();
                    }
                    else if (errorMessage.indexOf('customer') > 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                    }
                    else {
                        Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace"));
                    }
                }
            }
        });
    };
    Quote.prototype.GetPaymentErrorMsg = function (response) {
        var errorCode = response["error"] ? response["error"].toLowerCase().split(",") : "";
        if ($.inArray("code: E00027".toLowerCase(), errorCode) >= 0)
            return ZnodeBase.prototype.getResourceByKeyName("ErrorCodeE00027");
        return response["error"];
    };
    Quote.prototype.ClearPaymentAndDisplayMessage = function (message) {
        Order.prototype.CanclePayment();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(message, "error", isFadeOut, fadeOutTime);
    };
    Quote.prototype.GetSubmitPaymentViewModel = function (paymentSettingId, paymentCode, response, paymentType, creditCardNumber) {
        return {
            OmsQuoteId: Quote.prototype.GetQuoteId(),
            UserId: Quote.prototype.GetUserId(),
            PaymentDetails: {
                PaymentSettingId: paymentSettingId,
                PaymentCode: paymentCode,
                CustomerProfileId: response.GatewayResponse.CustomerProfileId,
                CustomerPaymentId: response.GatewayResponse.CustomerPaymentProfileId,
                CustomerShippingAddressId: response.GatewayResponse.CustomerShippingAddressId,
                CustomerGuid: response.GatewayResponse.CustomerGUID,
                PaymentToken: $("input[name='CCdetails']:checked").val(),
                paymentType: paymentType,
                CreditCardNumber: creditCardNumber.slice(-4)
            }
        };
    };
    Quote.prototype.GetSubmitPaymentViewModelForACH = function (paymentSettingId, paymentCode, response, paymentType, creditCardNumber) {
        return {
            OmsQuoteId: Quote.prototype.GetQuoteId(),
            UserId: Quote.prototype.GetUserId(),
            PaymentDetails: {
                PaymentSettingId: paymentSettingId,
                PaymentCode: paymentCode,
                CustomerProfileId: response.GatewayResponse.CustomerProfileId,
                CustomerPaymentId: response.GatewayResponse.CustomerPaymentProfileId,
                CustomerShippingAddressId: response.GatewayResponse.CustomerShippingAddressId,
                CustomerGuid: response.GatewayResponse.CustomerGUID,
                PaymentToken: $("input[name='CCdetails']:checked").val(),
                paymentType: paymentType,
                CreditCardNumber: creditCardNumber.slice(-4),
                IsACHPayment: true
            }
        };
    };
    Quote.prototype.UpdateQuoteCartItemPrice = function (control) {
        var productid = $(control).attr("data-cart-productid");
        var externalId = $(control).attr("data-cart-externalid");
        var shippingid = $("input[name='ShippingId']:checked").val();
        var priceRoundOff = $(control).attr("data-priceRoundOff");
        var userId = Order.prototype.GetUserId();
        var cartUnitPtice = $(control).attr("data-cart-unitPrice");
        $("#unit_price_error_msg_" + externalId).text('');
        var updatedUnitPrice = $(control).val();
        if (updatedUnitPrice != undefined && parseFloat(updatedUnitPrice) != parseFloat(cartUnitPtice)) {
            if (updatedUnitPrice.split(".")[1] != null && parseInt(updatedUnitPrice.split(".")[1].length) > parseInt(priceRoundOff)) {
                $("#unit_price_error_msg_" + externalId).text('Please enter Price having ' + priceRoundOff + ' numbers after decimal point.');
                return false;
            }
            var matches = updatedUnitPrice.match(/^-?[\d.]+(?:e-?\d+)?$/);
            if (matches == null) {
                $("#unit_price_error_msg_" + externalId).text('Please enter numeric value');
                return false;
            }
        }
        var guid = $(control).attr("data-cart-externalid");
        ZnodeBase.prototype.ShowPartialLoader("loader-cart-content");
        this.UpdatePrice(guid, updatedUnitPrice, productid, shippingid, userId);
    };
    Quote.prototype.UpdatePrice = function (guid, updatedUnitPrice, productid, shippingid, userId) {
        Order.prototype.ClearShippingEstimates();
        Endpoint.prototype.UpdateQuoteCartItemPrice(guid, updatedUnitPrice, productid, shippingid, Order.prototype.IsQuote(), userId, function (response) {
            if (response.success) {
                $("#divShoppingCart").html("");
                $("#divShoppingCart").html(response.html);
                var orderId = Order.prototype.GetOrderId();
                var portalId = Order.prototype.GetPortalId();
                //Calculate the shopping cart
                Order.prototype.CalculateShoppingCart(userId, portalId, orderId, false);
            }
            ZnodeBase.prototype.HidePartialLoader("loader-cart-content");
        });
    };
    //Save order line item shipping
    Quote.prototype.SaveOrderLineItemShipping = function (event) {
        var target = $(event.target);
        var newShippingValue = target.val();
        var extenalId = target.next().next('#hdnExternalId').val();
        var oldShippingValue = target.next('#hdnQuoteLineItemShipping_' + extenalId).val();
        newShippingValue = newShippingValue.replace(/[$]/g, '');
        var matches = newShippingValue.match(/^-?[\d.]+(?:e-?\d+)?/);
        if (matches == null || !newShippingValue || newShippingValue < 0) {
            target.val(oldShippingValue);
            event.stopImmediatePropagation();
            return false;
        }
        $('#IsQuoteLineShippingUpdated_' + extenalId).val("true");
        return true;
    };
    Quote.prototype.UpdateQuoteLineItemShipping = function (data) {
        if (data) {
            $.each(data, function (index, element) {
                $("#shippingcost_" + element.Item1).val(element.Item2);
                $("#hdnQuoteLineItemShipping_" + element.Item1).val(element.Item2);
            });
        }
    };
    //Get Manage Quote Additional note pop up
    Quote.prototype.GetQuoteAdditionalNote = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanelWithCallBack('/Quote/GetAdditionalNotes', 'additionalNotes', function (response) {
            $('#notes').val($('#additionalNotes').val());
        });
    };
    /* This method will check whether the quote is old quote or not & will show the notification on edit screen
     to notify the admin that this is old quote. So if any updation do so it will work as per new quote calculation flow
     & may impact the calculation in case of absent data in old quote */
    Quote.prototype.ShowOldQuoteNotification = function (isOldQuote) {
        if (typeof isOldQuote === "undefined" || isOldQuote.toLowerCase() == "false")
            return false;
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("IsAnOldQuoteMessage"), "error", false, 36000000);
            return true;
        }
    };
    Quote.prototype.CheckIsQuoteOrder = function () {
        var isOldQuote = $("#hdnIsOldQuote").val();
        if (typeof isOldQuote !== "undefined" && isOldQuote.toLowerCase() == "true") {
            var currentTarget = $('#shippingTypes');
            Quote.prototype.GetSelectedShipping(currentTarget);
        }
    };
    Quote.prototype.ShowTaxDetails = function (element) {
        var taxSummary = $(element).closest("#taxTotalDiv").find("#TaxSummary");
        if (taxSummary.is(':visible')) {
            taxSummary.hide();
        }
        else {
            taxSummary.show();
        }
    };
    return Quote;
}(ZnodeBase));
$('#PopUpConvertToOrder').find('#btn-cancel-popup').click(function () {
    Quote.prototype.ResetQuoteStatus();
});
//# sourceMappingURL=Quote.js.map