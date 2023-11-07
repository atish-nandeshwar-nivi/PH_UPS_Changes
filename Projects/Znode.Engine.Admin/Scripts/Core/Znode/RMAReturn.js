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
var RMAReturn = /** @class */ (function (_super) {
    __extends(RMAReturn, _super);
    function RMAReturn() {
        return _super.call(this) || this;
    }
    RMAReturn.prototype.Init = function () {
        ZnodeDateRangePicker.prototype.Init(RMAReturn.prototype.DateTimePickerRange());
        RMAReturn.prototype.DisableAttributesOnUpdatedReturnStatus($("#ddlReturnStatus").val());
    };
    //Get additional return note pop up
    RMAReturn.prototype.GetAdditionalReturnNote = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanelWithCallBack('/RMAReturn/GetAdditionalReturnNotes', 'AdditionalReturnNotes', function (response) {
            $('#Notes').val($('#AdditionalReturnNotes').val());
        });
    };
    RMAReturn.prototype.DateTimePickerRange = function () {
        var ranges = {
            'All Returns': [],
            'Last Hour': [],
            'Last Day': [],
            'Last 7 Days': [],
            'Last 30 Days': [],
        };
        return ranges;
    };
    //This method is used to select store from fast select and show it on textbox
    RMAReturn.prototype.OnSelectStoreAutocompleteDataBind = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            Endpoint.prototype.GetReturnList(portalId, portalName, function (response) {
                $("#returnList").html("");
                $("#returnList").html(response);
                ZnodeDateRangePicker.prototype.Init(RMAReturn.prototype.DateTimePickerRange());
            });
        }
    };
    RMAReturn.prototype.ConfirmCancelReturnPopUp = function () {
        $('#PopUpConfirmCancelReturn').modal('show');
    };
    RMAReturn.prototype.ConfirmCancelReturn = function () {
        window.location.href = '/RMAReturn/List';
    };
    //On Confirm Submit Return
    RMAReturn.prototype.OnConfirmSubmitReturn = function () {
        var isValidOrderLineItem = this.IsValidAllReturnLineItem();
        if (isValidOrderLineItem != undefined && isValidOrderLineItem) {
            $('#PopUpConfirmSubmitReturn').modal('show');
            return true;
        }
        return false;
    };
    //Bind the added return note
    RMAReturn.prototype.SaveAddedReturnNote = function () {
        var notes = $('#Notes').val();
        $('#AdditionalReturnNotes').val(notes);
        ZnodeBase.prototype.CancelUpload('AdditionalReturnNotes');
    };
    //Validate Return Line Item
    RMAReturn.prototype.ValidateReturnLineItem = function (guid) {
        if (RMAReturn.prototype.ValidateReturnQuantityLineItem(guid)) {
            if (RMAReturn.prototype.ValidatePartialRefundAmountLineItem(guid)) {
                return true;
            }
        }
        return false;
    };
    //Validate Return Quantity Line Item
    RMAReturn.prototype.ValidateReturnQuantityLineItem = function (guid) {
        ZnodeBase.prototype.ShowLoader();
        var returnedQuantity = $("#returnedQuantity_" + guid).val();
        var expectedReturnQuantity = $("#expectedReturnQuantity_" + guid).val();
        var returnedQuantityError = "#returnedQuantity_error_msg_" + guid;
        $(returnedQuantityError).html("");
        $("#returnTotalPrice_" + guid).html("");
        if (returnedQuantity != null && returnedQuantity != "" && returnedQuantity > 0) {
            if (this.CheckExpectedReturnQuantityValidations(returnedQuantity, expectedReturnQuantity, returnedQuantityError)) {
                $(returnedQuantityError).html("");
                $(returnedQuantityError).hide();
                return true;
            }
        }
        else {
            $(returnedQuantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorQtyRequired"));
            $(returnedQuantityError).show();
            return false;
        }
        ZnodeBase.prototype.HideLoader();
    };
    //Validate Partial Refund Amount Line Item
    RMAReturn.prototype.ValidatePartialRefundAmountLineItem = function (guid) {
        var partialRefundAmount = $("#partialRefundAmount_" + guid).val();
        var returnTotalPrice = $("#returnTotalPrice_" + guid).val();
        var partialRefundAmountError = "#partialRefundAmount_error_msg_" + guid;
        if ($("#returnStatus_" + guid).val() == Enum.ReturnStatusDropdown.PARTIALLYAPPROVED) {
            var refundAmount = parseFloat(partialRefundAmount);
            if (refundAmount == 0 || (isNaN(refundAmount) || partialRefundAmount.trim() == "")) {
                $(partialRefundAmountError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorPartialRefund"));
                $(partialRefundAmountError).show();
                return false;
            }
        }
        if (this.CheckPartialRefundAmountValidations(partialRefundAmount, returnTotalPrice, guid, partialRefundAmountError)) {
            return true;
        }
    };
    //Update Order Return Line Item
    RMAReturn.prototype.UpdateOrderReturnLineItem = function (guid) {
        ZnodeBase.prototype.ShowLoader();
        var returnLineItemStatus = $("#returnStatus_" + guid).val();
        if (returnLineItemStatus == Enum.ReturnStatusDropdown.SUBMITTED && $("#savedReturnStatus_" + guid).val() != Enum.ReturnStatusDropdown.SUBMITTED) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorUpdateToLineItemSubmittedStatus"), "error", isFadeOut, fadeOutTime);
            $("#returnStatus_" + guid).val($("#savedReturnStatus_" + guid).val());
        }
        else {
            if (returnLineItemStatus == Enum.ReturnStatusDropdown.APPROVED) {
                $("#partialRefundAmount_" + guid).val("0");
                $("#partialRefundAmount_" + guid).prop("disabled", true);
            }
            else if (returnLineItemStatus == Enum.ReturnStatusDropdown.PARTIALLYAPPROVED) {
                $("#returnedQuantity_" + guid).prop("disabled", false);
                $("#partialRefundAmount_" + guid).prop("disabled", false);
                $("#partialRefund").show();
                $(".sp-refundlist").show();
                $("#partialRefundAmount_" + guid).show();
            }
            else if (returnLineItemStatus == Enum.ReturnStatusDropdown.REJECTED) {
                $("#returnedQuantity_" + guid).val($("#expectedReturnQuantity_" + guid).val());
                $("#partialRefundAmount_" + guid).val("0");
                $("#partialRefundAmount_" + guid).prop("disabled", true);
                $("#IsShippingReturn_" + guid).prop('checked', false);
            }
            else {
                $("#partialRefundAmount_" + guid).val("0");
                $("#partialRefundAmount_" + guid).prop("disabled", true);
            }
            var partialRefundProductcount = 0;
            $("#layout-cart [id ^= 'partialRefundAmount']").each(function (e) {
                if ($(this).html() != "" || $("input[id ^= 'partialRefundAmount']").is(":visible")) {
                    partialRefundProductcount = partialRefundProductcount + 1;
                }
            });
            if (partialRefundProductcount > 0) {
                $("#partialRefund").show();
                $(".sp-refundlist").show();
            }
            else {
                $("#partialRefund").hide();
                $("input[id ^= 'partialRefundAmount']").hide();
                $(".sp-refundlist").hide();
            }
            if (RMAReturn.prototype.ValidateReturnLineItem(guid)) {
                var orderReturnLineItemModel = RMAReturn.prototype.BindSingleReturnItemModel(guid);
                var returnNumber = $("#hdnReturnNumber").val();
                Endpoint.prototype.UpdateOrderReturnLineItem(orderReturnLineItemModel, returnNumber, function (response) {
                    if (response.hasError) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
                    }
                    else {
                        $("#returnLineItems").html("").html(response.returnLineItems);
                        var returnTotalAmount = $('#hdnreturntotalid').val();
                        var formattedReturnTotalAmount = $('#returnTotalId').html();
                        if (returnTotalAmount) {
                            $('#hdntotalreturnamount').val(returnTotalAmount);
                            $('#total-return-amount').html(formattedReturnTotalAmount);
                        }
                        if (returnLineItemStatus == Enum.ReturnStatusDropdown.PARTIALLYAPPROVED) {
                            $("#returnedQuantity_" + guid).prop("disabled", false);
                            $("#partialRefundAmount_" + guid).prop("disabled", false);
                            $(".sp-refundlist").show();
                        }
                        else if (returnLineItemStatus == Enum.ReturnStatusDropdown.REJECTED) {
                            $("#returnedQuantity_" + guid).prop("disabled", true);
                            $("#partialRefundAmount_" + guid).prop("disabled", true);
                        }
                        else {
                            $("#returnedQuantity_" + guid).prop("disabled", false);
                            $("#partialRefundAmount_" + guid).prop("disabled", true);
                        }
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "success", isFadeOut, fadeOutTime);
                    }
                });
            }
        }
        ZnodeBase.prototype.HideLoader();
    };
    //Update order return status
    RMAReturn.prototype.OnReturnStatusChange = function (obj) {
        ZnodeBase.prototype.ShowLoader();
        var selectedReturnStatus = $(obj).find('option:selected').val();
        var returnNumber = $("#hdnReturnNumber").val();
        var isValidOrderLineItem = this.IsValidAllReturnLineItem();
        if (isValidOrderLineItem != undefined && isValidOrderLineItem) {
            Endpoint.prototype.UpdateOrderReturnStatus(parseInt(selectedReturnStatus), returnNumber, function (response) {
                if (response.hasError) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
                    $("#ddlReturnStatus").val(response.returnStateId);
                }
                else {
                    $("#returnLineItems").html("").html(response.returnLineItems);
                    $("#hdnUpdatedReturnStatusId").val(response.returnStateId);
                    if (selectedReturnStatus != Enum.ReturnStatusDropdown.SUBMITTED && selectedReturnStatus != Enum.ReturnStatusDropdown.INREVIEW && selectedReturnStatus != Enum.ReturnStatusDropdown.RECEIVED) {
                        RMAReturn.prototype.DisableAttributesOnUpdatedReturnStatus(selectedReturnStatus);
                    }
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "success", isFadeOut, fadeOutTime);
                }
            });
        }
        else {
            $("#ddlReturnStatus").val($("#hdnUpdatedReturnStatusId").val());
        }
        ZnodeBase.prototype.HideLoader();
    };
    //Save order return.
    RMAReturn.prototype.SaveOrderReturn = function () {
        var paymentType = $("#hdnPaymentType").val().toLowerCase();
        if (($("#ddlReturnStatus").val() == Enum.ReturnStatusDropdown.APPROVED || $("#ddlReturnStatus").val() == Enum.ReturnStatusDropdown.APPROVED)
            && (paymentType == 'credit_card' || paymentType == 'amazon_pay') && $('#hdnPaymentStatus').val().toLowerCase() == "authorized") {
            Order.prototype.ShowErrorPaymentDialog(ZnodeBase.prototype.getResourceByKeyName("ErrorCaptureOrder"));
            return;
        }
        var isValidOrderLineItem = this.IsValidAllReturnLineItem();
        if (isValidOrderLineItem != undefined && isValidOrderLineItem) {
            var returnNumber = $("#hdnReturnNumber").val();
            var notes = $('#AdditionalReturnNotes').val();
            Endpoint.prototype.SubmitOrderReturn(returnNumber, notes, function (response) {
                if (response.hasError) {
                    if ($("#ddlReturnStatus").val() == Enum.ReturnStatusDropdown.REFUNDPROCESSED) {
                        $("#ddlReturnStatus").attr("disabled", false);
                        $("#ddlReturnStatus").val($("#SelectedItemId").val());
                        RMAReturn.prototype.DisableAttributesOnUpdatedReturnStatus($("#ddlReturnStatus").val());
                    }
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
                }
                else {
                    window.location.reload(true);
                }
            });
            ZnodeBase.prototype.ShowLoader();
        }
    };
    //Process Refund for order return.
    RMAReturn.prototype.ProcessRefund = function () {
        $("#ddlReturnStatus").val(Enum.ReturnStatusDropdown.REFUNDPROCESSED);
        RMAReturn.prototype.OnReturnStatusChange($("#ddlReturnStatus"));
    };
    //Print return receipt
    RMAReturn.prototype.PrintReturnReceipt = function (returnNumber) {
        if (returnNumber != null && returnNumber != "") {
            Endpoint.prototype.PrintReturnReceipt(returnNumber, function (response) {
                var originalContents = document.body.innerHTML;
                if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1) {
                    setTimeout(function () { document.body.innerHTML = response; }, 1);
                    setTimeout(function () { window.print(); }, 10);
                    setTimeout(function () { document.body.innerHTML = originalContents; }, 20);
                    setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 30);
                }
                else {
                    document.body.innerHTML = response;
                    window.print();
                    document.body.innerHTML = originalContents;
                }
            });
        }
    };
    //Check is valid all return line item
    RMAReturn.prototype.IsValidAllReturnLineItem = function () {
        var guidArray = [];
        $("li[data-return-lineitem]").each(function () {
            var guid = $(this).attr("data-return-lineitem");
            guidArray.push(guid);
        });
        var isValidOrderLineItem = true;
        if (guidArray != undefined && guidArray.length > 0) {
            guidArray.forEach(function (guid) {
                var status = RMAReturn.prototype.ValidateReturnLineItem(guid);
                if (status == undefined || status == false) {
                    isValidOrderLineItem = false;
                }
            });
        }
        return isValidOrderLineItem;
    };
    //Check Return Quantity Validations
    RMAReturn.prototype.CheckExpectedReturnQuantityValidations = function (returnedQuantity, expectedReturnQuantity, returnedQuantityError) {
        var returnQty = parseFloat(returnedQuantity);
        var expectedQuantity = parseFloat(expectedReturnQuantity);
        if (returnedQuantity != "") {
            if (!RMAReturn.prototype.CheckIsNumeric(returnedQuantity, returnedQuantityError, false)) {
                return false;
            }
        }
        else {
            $(returnedQuantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidReturnedQuantity"));
            $(returnedQuantityError).show();
            return false;
        }
        if (returnQty != 0 && (returnQty < 1 || returnQty > expectedQuantity)) {
            $(returnedQuantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidReturnedQuantity"));
            $(returnedQuantityError).show();
            return false;
        }
        return true;
    };
    //Check data Is Numeric or not
    RMAReturn.prototype.CheckIsNumeric = function (data, errorMessage, isDecimal) {
        var matches = null;
        if (isDecimal) {
            matches = data.match(/^-?[\d.]+(?:e-?\d+)?$/);
        }
        else {
            matches = data.match(/^[0-9]*$/);
        }
        if (matches == null) {
            $(errorMessage).text(ZnodeBase.prototype.getResourceByKeyName("RequiredNumericValue"));
            $(errorMessage).addClass("error-msg");
            $(errorMessage).show();
            return false;
        }
        return true;
    };
    //Check Partial Refund Amount Validations
    RMAReturn.prototype.CheckPartialRefundAmountValidations = function (partialRefundAmount, returnTotalPrice, guid, partialRefundAmountError) {
        var refundAmount = parseFloat(partialRefundAmount);
        var returnTotal = Number(returnTotalPrice.replace(/[^0-9\.-]+/g, ""));
        if (refundAmount > 0 || (isNaN(refundAmount) && partialRefundAmount.trim() != "")) {
            var decimalPoint = partialRefundAmount.split(".")[1] != null ? partialRefundAmount.split(".")[1].length : 0;
            var decimalValue = partialRefundAmount.split(".")[1] != null ? parseInt(partialRefundAmount.split(".")[1]) : 0;
            var priceRoundOff = parseInt($("#partialRefundAmount_" + guid).attr("data-priceRoundOff"));
            if (this.CheckIsNumeric(partialRefundAmount, partialRefundAmountError, true)) {
                if (this.CheckDecimalValue(decimalPoint, decimalValue, priceRoundOff, partialRefundAmountError)) {
                    if (refundAmount > returnTotal) {
                        $(partialRefundAmountError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidAmount"));
                        $(partialRefundAmountError).show();
                        return false;
                    }
                    return true;
                }
            }
            return false;
        }
        return true;
    };
    //Check Decimal Value
    RMAReturn.prototype.CheckDecimalValue = function (decimalPoint, decimalValue, inventoryRoundOff, error) {
        if (decimalValue != 0 && decimalPoint > inventoryRoundOff) {
            $(error).text(ZnodeBase.prototype.getResourceByKeyName("EnterPriceHaving") + inventoryRoundOff + ZnodeBase.prototype.getResourceByKeyName("XNumbersAfterDecimalPoint"));
            $(error).css("class", "error-msg");
            $(error).show();
            return false;
        }
        return true;
    };
    //Bind Single Return Item Model
    RMAReturn.prototype.BindSingleReturnItemModel = function (guid) {
        var _returnOrderLineItemModel = {
            Guid: guid,
            ReturnedQuantity: $("#returnedQuantity_" + guid).val(),
            OmsOrderLineItemsId: parseInt($("#OmsOrderLineItemsId_" + guid).val()),
            RmaReturnLineItemsId: parseInt($("#RmaReturnLineItemsId_" + guid).val()),
            IsShippingReturn: $("#IsShippingReturn_" + guid).prop('checked'),
            RmaReturnStateId: parseInt($("#returnStatus_" + guid).val()),
            RefundAmount: parseFloat($("#partialRefundAmount_" + guid).val()),
            ReturnStatus: $("#returnStatus_" + guid).find('option:selected').text(),
            ShippedQuantity: $("#shippedquantity_" + guid).val(),
            ProductId: parseInt($("#shippedquantity_" + guid).attr("data-return-productid")),
            ExpectedReturnQuantity: $("#expectedReturnQuantity_" + guid).val(),
            RmaReasonForReturnId: $("#ddlReasonList_" + guid).val(),
            RmaReasonForReturn: $("#ddlReasonList_" + guid + " :selected").text(),
            TotalLineItemPrice: 0,
        };
        return _returnOrderLineItemModel;
    };
    //Disable attributes on manage return for updated return status
    RMAReturn.prototype.DisableAttributesOnUpdatedReturnStatus = function (returnStatus) {
        $("#ProcessRefund").attr("disabled", true);
        if (returnStatus != Enum.ReturnStatusDropdown.SUBMITTED && returnStatus != Enum.ReturnStatusDropdown.INREVIEW && returnStatus != Enum.ReturnStatusDropdown.RECEIVED) {
            $("#returnLineItems select").attr("disabled", true);
            $("#returnLineItems input").attr("disabled", true);
        }
        if (returnStatus == Enum.ReturnStatusDropdown.REJECTED || returnStatus == Enum.ReturnStatusDropdown.REFUNDPROCESSED) {
            $("#ddlReturnStatus").attr("disabled", true);
        }
        else if (returnStatus == Enum.ReturnStatusDropdown.APPROVED || returnStatus == Enum.ReturnStatusDropdown.PARTIALLYAPPROVED) {
            //TODO - hdnPaymentType need to be come from constant file.
            if ($("#hdnPaymentType").val().toLowerCase() == 'cod' || $("#hdnPaymentType").val().toLowerCase() == 'purchase_order' || $("#hdnPaymentType").val().toLowerCase() == 'ach' || $("#hdnPaymentType").val().toLowerCase() == 'invoice me') {
                $("#ProcessRefund").attr("disabled", true);
            }
            else {
                $("#ProcessRefund").attr("disabled", false);
            }
        }
    };
    // Show popup model on back Buutton click
    RMAReturn.prototype.ConfirmCancelCreateReturnPopUp = function () {
        $('#PopUpConfirmCancelCreateReturn').modal('show');
    };
    //Redirect to list page 
    RMAReturn.prototype.ConfirmCancelCreateReturn = function () {
        window.location.href = '/RMAReturn/List';
    };
    RMAReturn.prototype.CheckOrderEligibiltyForReturn = function () {
        var userId = parseInt($("#hdnUserId").val());
        var portalId = parseInt($("#PortalId").val());
        var orderNumber = $('#hdnOrderNumber').val();
        var orderId = parseInt($('#hdnManageOmsOrderId').val());
        window.location.href = "/RMAReturn/CheckOrderEligibleForReturn?orderNumber=" + orderNumber + "&userId=" + userId + "&portalId=" + portalId + "&omsOrderId=" + orderId + "&isManageOrder=" + true;
    };
    RMAReturn.prototype.ShowCreateReturnPopUp = function () {
        $('#PopUpCreateReturn').modal('show');
    };
    //Validate Return Line Item
    RMAReturn.prototype.ValidateCreateReturnLineItem = function (guid) {
        var shippedQuantity = $("#shippedquantity_" + guid).val();
        var expectedReturnQuantity = $("#expectedReturnQuantity_" + guid).val();
        var expectedReturnQuantityError = "#expectedReturnQuantity_error_msg_" + guid;
        $(expectedReturnQuantityError).html("");
        $("#returnTotalPrice_" + guid).html("");
        RMAReturn.prototype.ClearTotalSummary();
        if (expectedReturnQuantity == null || expectedReturnQuantity == "") {
            $("#expectedReturnQuantity_" + guid).val("0");
            expectedReturnQuantity = "0";
        }
        if (expectedReturnQuantity == "0") {
            var cultureCode = $("#hdnCurrencyCode").val();
            $("#returnTotal").html(cultureCode + "0.00");
            $("#returnSubtotal").html(cultureCode + "0.00");
            if ($("#returnOrderDetails").length > 0) {
                $("#returnOrderDetails").hide();
            }
        }
        if (expectedReturnQuantity != null && expectedReturnQuantity != "") {
            if (this.CheckExpectedReturnQuantityValidations(expectedReturnQuantity, shippedQuantity, expectedReturnQuantityError)) {
                $(expectedReturnQuantityError).html("");
                $(expectedReturnQuantityError).hide();
                RMAReturn.prototype.CalculateOrderReturn();
            }
        }
    };
    //Clear Total Summary
    RMAReturn.prototype.ClearTotalSummary = function () {
        $("#returnSubtotalId").html("");
        $("#returnTaxCostId").html("");
        $("#returnShippingCostId").html("");
        $("#returnTotalId").html("");
        $("#returnDiscountAmountId").html("");
        $("#returnCSRDiscountAmountId").html("");
        $("#returnShippingDiscountAmountId").html("");
        $("#returnChargesAmountId").html("");
    };
    //Calculate order return
    RMAReturn.prototype.CalculateOrderReturn = function () {
        ZnodeBase.prototype.ShowLoader();
        RMAReturn.prototype.ClearTotalSummary();
        var guidArray = this.GetGreaterThanZeroReturnQuantityLineItemGuid();
        if (guidArray != undefined && guidArray.length > 0) {
            var calculateOrderReturnModel = RMAReturn.prototype.BindCalculateOrderReturnData(guidArray);
            Endpoint.prototype.CalculateOrderReturn(calculateOrderReturnModel, function (response) {
                RMAReturn.prototype.BindCalculatedDataResponse(response);
            });
        }
        else {
            var returnNumber = $("#hdnReturnNumber").val();
        }
        ZnodeBase.prototype.HideLoader();
    };
    //Get Greater Than Zero Return Quantity Line Item Guid
    RMAReturn.prototype.GetGreaterThanZeroReturnQuantityLineItemGuid = function () {
        var guidArray = [];
        $("#divShoppingCart tbody tr").each(function () {
            var guid = $(this).attr("data-return-lineitem");
            if ($("#expectedReturnQuantity_" + guid).val() > 0) {
                guidArray.push(guid);
            }
        });
        return guidArray;
    };
    //Bind calculate order return data
    RMAReturn.prototype.BindCalculateOrderReturnData = function (guidArray) {
        if (guidArray.length > 0) {
            var returnOrderLineItemModel = [];
            guidArray.forEach(function (guid) {
                returnOrderLineItemModel.push(RMAReturn.prototype.BindSingleReturnItemModel(guid));
            });
            var _calculateOrderReturnModel = {
                OrderNumber: $("#hdnOrderNumber").val(),
                CultureCode: $("#hdnCultureCode").val(),
                ReturnCalculateLineItemList: returnOrderLineItemModel,
                PortalId: parseInt($("#hdnPortalId").val()),
                UserId: parseInt($("#hdnUserId").val()),
            };
            return _calculateOrderReturnModel;
        }
    };
    //Bind calculated data response
    RMAReturn.prototype.BindCalculatedDataResponse = function (response) {
        $("#divReturnCalculation").html("").html(response.html);
        var calculateLineItemList = response.calculateLineItemList;
        if (calculateLineItemList != undefined && calculateLineItemList.length > 0) {
            for (var index = 0; index < calculateLineItemList.length; index++) {
                $("#returnTotalPrice_" + calculateLineItemList[index].Guid).html(calculateLineItemList[index].TotalLineItemPriceWithCurrency);
                $("#expectedReturnQuantity_error_msg_" + calculateLineItemList[index].Guid).html(calculateLineItemList[index].ErrorMessage);
            }
        }
        if (response.hasError) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.errorMessage, "error", isFadeOut, fadeOutTime);
        }
    };
    //Save order return.
    RMAReturn.prototype.SubmitCreateReturn = function () {
        ZnodeBase.prototype.ShowLoader();
        var guidArray = [];
        guidArray = this.GetGreaterThanZeroReturnQuantityLineItemGuid();
        var orderReturnModel = RMAReturn.prototype.BindOrderReturnData(guidArray);
        var isValidReturnItems = RMAReturn.prototype.IsValidReturnItem(orderReturnModel);
        if (isValidReturnItems) {
            if (guidArray != undefined && guidArray.length > 0) {
                var isValidOrderLineItem = this.IsValidReturnLineItem(guidArray, true);
                if (isValidOrderLineItem != undefined && isValidOrderLineItem) {
                    Endpoint.prototype.SubmitCreateReturn(orderReturnModel, function (response) {
                        ZnodeBase.prototype.ShowLoader();
                        if (response.hasError) {
                            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.errorMessage, "error", isFadeOut, fadeOutTime);
                        }
                        else {
                            window.location.href = window.location.protocol + "//" + window.location.host + "/RMAReturn/GetReturnDetails?returnNumber=" + response.returnNumber + "&isReturnDetailsReceipt=" + false;
                        }
                    });
                }
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper("Please select Return Qty. for at least one line item for return.", "error", isFadeOut, fadeOutTime);
                ZnodeBase.prototype.HideLoader();
            }
        }
    };
    RMAReturn.prototype.IsValidReturnItem = function (orderReturnModel) {
        Endpoint.prototype.IsValidReturnItem(orderReturnModel, function (response) {
            ZnodeBase.prototype.ShowLoader();
            if (response.hasError) {
                response.orderLineItems.forEach(function (returnitem) {
                    if (returnitem.HasError) {
                        var guid = returnitem.OmsOrderLineItemsId;
                        $("#createReturnLineItem_error_msg_" + guid).html(returnitem.ErrorMessage);
                        return false;
                    }
                    return true;
                });
            }
            return true;
        });
        return true;
    };
    //Check is valid return line item
    RMAReturn.prototype.IsValidReturnLineItem = function (guidArray, isValidOrderLineItem) {
        guidArray.forEach(function (guid) {
            var shippedQuantity = $("#shippedquantity_" + guid).val();
            var expectedReturnQuantity = $("#expectedReturnQuantity_" + guid).val();
            var expectedReturnQuantityError = "#expectedReturnQuantity_error_msg_" + guid;
            var status = RMAReturn.prototype.CheckExpectedReturnQuantityValidations(expectedReturnQuantity, shippedQuantity, expectedReturnQuantityError);
            if (status == undefined || status == false) {
                isValidOrderLineItem = false;
            }
        });
        return isValidOrderLineItem;
    };
    //Bind order return data
    RMAReturn.prototype.BindOrderReturnData = function (guidArray) {
        if (guidArray.length > 0) {
            var returnOrderLineItemModel = [];
            guidArray.forEach(function (guid) {
                returnOrderLineItemModel.push(RMAReturn.prototype.BindSingleReturnItemModel(guid));
            });
            var _orderReturnModel = {
                OrderNumber: $("#hdnOrderNumber").val(),
                ReturnNumber: $("#hdnReturnNumber").val(),
                CultureCode: $("#hdnCultureCode").val(),
                Notes: $("#ReturnNote").val(),
                ReturnLineItems: returnOrderLineItemModel,
                PortalId: parseInt($("#hdnPortalId").val()),
                UserId: parseInt($("#hdnUserId").val()),
                OmsOrderDetailsId: parseInt($('#hdnOrderDetailId').val()),
            };
            return _orderReturnModel;
        }
    };
    //Redirect to return list page
    RMAReturn.prototype.CancelReciept = function () {
        window.location.href = window.location.protocol + "//" + window.location.host + "/RMAReturn/List";
    };
    //Print create return receipt
    RMAReturn.prototype.PrintCreateReturnReceipt = function (returnNumber) {
        if (returnNumber != null && returnNumber != "") {
            Endpoint.prototype.PrintCreateReturnReceipt(returnNumber, function (response) {
                var originalContents = document.body.innerHTML;
                if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1) {
                    setTimeout(function () { document.body.innerHTML = response; }, 1);
                    setTimeout(function () { window.print(); }, 10);
                    setTimeout(function () { document.body.innerHTML = originalContents; }, 20);
                    setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 30);
                }
                else {
                    document.body.innerHTML = response;
                    window.print();
                    document.body.innerHTML = originalContents;
                }
            });
        }
    };
    return RMAReturn;
}(ZnodeBase));
//# sourceMappingURL=RMAReturn.js.map