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
var OneClick = false;
var isValidCvvSaved = true;
var LastSelectedOrderStatus = "";
var selectedProductIds;
var CVVNumber;
var Order = /** @class */ (function (_super) {
    __extends(Order, _super);
    function Order() {
        return _super.call(this) || this;
    }
    Order.prototype.Init = function () {
        Order.prototype.ShippingSameAsBillingHandler();
        Order.prototype.SetProductDetails();
        Order.prototype.SetCustomerErrorMessage();
        Order.prototype.SetDataOnUpdate();
        Order.prototype.SetPurchaseOrderNumber();
        Order.prototype.SetDataOnConvertingQuoteToOrder();
        Order.prototype.ChangeOrderStatus();
        if ($('#failedOrderTransactionList').html() != undefined) {
            ZnodeDateRangePicker.prototype.Init(Order.prototype.FailedOrderDateTimePickerRange());
        }
        else {
            ZnodeDateRangePicker.prototype.Init(Order.prototype.DateTimePickerRange());
        }
        Order.prototype.AutoCompleteApprovalUsers();
    };
    Order.prototype.DateTimePickerRange = function () {
        var ranges = {
            'All Orders': [],
            'Last Hour': [],
            'Last Day': [],
            'Last 7 Days': [],
            'Last 30 Days': [],
        };
        return ranges;
    };
    Order.prototype.FailedOrderDateTimePickerRange = function () {
        var ranges = {
            'All Transactions': [],
            'Last Hour': [],
            'Last Day': [],
            'Last 7 Days': [],
            'Last 30 Days': [],
        };
        return ranges;
    };
    Order.prototype.SetAttributeForPortalId = function () {
        var portalId = $("#selectedPortalId").val();
        if (portalId > 0)
            $("#txtPortalName").attr("data-portalid", portalId);
    };
    Order.prototype.GetCatalogListByPortalId = function (portalId, isAllowGlobalLevelUserCreation) {
        if (isAllowGlobalLevelUserCreation === void 0) { isAllowGlobalLevelUserCreation = false; }
        var portalId = portalId;
        $("#txtCustomerName").val('');
        $("#hdnUserId").val(0);
        $(".tab-details").hide(true);
        if (Order.prototype.IsQuote()) {
            Endpoint.prototype.CreateQuoteRequest(portalId, function (response) {
                var cartData = $.parseHTML(response);
                $("#AddressDiv").html($(cartData).find('#AddressDiv').html());
                Order.prototype.ShippingSameAsBillingHandler();
                $("#ShoppingCartDiv").html($(cartData).find('#ShoppingCartDiv').html());
                $("#shippingMethodDiv").html($(cartData).find('#shippingMethodDiv').html());
            });
        }
        else {
            Endpoint.prototype.CreateNewOrderByPortalIdChange(portalId, function (response) {
                var cartData = $.parseHTML(response);
                $("#AddressDiv").html($(cartData).find('#AddressDiv').html());
                Order.prototype.ShippingSameAsBillingHandler();
                $("#ShoppingCartDiv").html($(cartData).find('#ShoppingCartDiv').html());
                $("#shippingMethodDiv").html($(cartData).find('#shippingMethodDiv').html());
            });
        }
    };
    Order.prototype.OnSelectAccount = function (item) {
        if (item != undefined) {
            var selectedAccount = item.Id;
            Order.prototype.OnSelectAccoutAutocompleteDataBind(item);
            $('#selectedAccountId').val(selectedAccount);
            $('#ddlAccount').val(selectedAccount);
            $("#txtAccountName").attr("data-accountid", selectedAccount);
            if (parseInt(selectedAccount) == 0 && selectedAccount == "") {
                $('#ddlDepartment').children('option:not(:first)').remove();
                $('#ddlAccountType').children('option:not(:first)').remove();
                $('#divDepartmentId').hide();
                $('#divUserTypeId').hide();
                $('#divRole').hide();
                $('#ddlPortals').show();
                $('#customer_general_information').show();
                return false;
            }
            Endpoint.prototype.GetAccountDepartmentList(selectedAccount, function (response) {
                $('#ddlDepartment').children('option:not(:first)').remove();
                for (var i = 0; i < response.length; i++) {
                    var opt = new Option(response[i].Text, response[i].Value);
                    $('#ddlDepartment').append(opt);
                }
                $('#divDepartmentId').show();
            });
            Endpoint.prototype.GetRoleList(function (response) {
                $('#ddlUserType').children('option').remove();
                for (var i = 0; i < response.length; i++) {
                    if (response[i].Value == $("#hdnRoleName").val())
                        var opt = new Option(response[i].Text, response[i].Value, false, true);
                    else
                        var opt = new Option(response[i].Text, response[i].Value);
                    $('#ddlUserType').append(opt);
                    $('#divUserTypeId').show();
                }
            });
            $('#divRole').show();
            $('#ddlPortals').show();
            $('#customer_general_information').show();
            $('#errorSelectAccountId').html("");
        }
    };
    Order.prototype.OnSelectAccoutAutocompleteDataBind = function (item) {
        if (item != undefined && item.Id > 0) {
            var accountName = item.text;
            var accountId = item.Id;
            if ($('#hdnAccountId').val() != undefined) {
                $("#hdnAccountId").val(accountId);
            }
            if ($('#AccountId').val() != undefined) {
                $('#AccountId').val(accountId);
            }
            $('#txtAccountName').val(accountName);
            $("#errorRequiredAccount").text("").removeClass("field-validation-error").hide();
            $("#txtAccountName").parent("div").removeClass('input-validation-error');
        }
    };
    Order.prototype.PrintOnManange = function () {
        Endpoint.prototype.PrintOnManage(Order.prototype.GetOrderId(), function (response) {
            var originalContents = document.body.innerHTML;
            if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1) {
                setTimeout(function () { document.body.innerHTML = response; }, 1);
                setTimeout(function () { window.print(); }, 10);
                setTimeout(function () { document.body.innerHTML = originalContents; }, 20);
                setTimeout(function () { Order.prototype.HideLoader(); }, 30);
            }
            else {
                document.body.innerHTML = response;
                window.print();
                document.body.innerHTML = originalContents;
            }
            $("#btnToggle").click();
        });
    };
    Order.prototype.PrintHandler = function (e) {
        var printContents = $("#printContentDiv").html();
        var originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
    };
    Order.prototype.GetCustomerList = function () {
        $("#divStoreListAsidePanel").html('');
        Order.prototype.SetAttributeForPortalId();
        var portalId = parseInt($("#txtPortalName").attr("data-portalid"));
        var accountId = 0;
        var requestedUrl = window.location.href.toLocaleLowerCase();
        if (requestedUrl.indexOf("createquoteforcustomer") > 0) {
            accountId = $("#hdnAccountId").val();
        }
        else if (requestedUrl.indexOf("createaccountquote") > 0) {
            accountId = $("#hdnAccountId").val();
        }
        else {
            accountId = 0;
        }
        var isQuote = Order.prototype.IsQuote();
        //If the request comes from create quote request page then set isQuote paarmeter to false which is passed as isAccountCustomer for GetCustomerList 
        if ($("#searchCustomer").attr("data-action") == "createquoterequest") {
            isQuote = false;
        }
        if (portalId > 0) {
            $("#selectedPortalId").val(portalId);
            ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetCustomerList?PortalId=' + portalId + '&isAccountCustomer=' + isQuote + '&accountId=' + accountId, 'customerDetails');
        }
        else {
            $("#errorRequiredStore").text('').text(ZnodeBase.prototype.getResourceByKeyName("SelectPortal")).addClass("field-validation-error").show();
            $("#txtPortalName").parent("div").addClass('input-validation-error');
            return false;
        }
    };
    Order.prototype.ClosePanel = function () {
        $("#panel-pop-up").html('');
        $("#panel-pop-up").hide();
    };
    Order.prototype.ResetCustomerDetails = function () {
        $("#customerDetails").html('');
        $("#panel-pop-up").html('');
        $("#panel-pop-up").hide();
    };
    Order.prototype.SetCustomerDetailsById = function () {
        $("[data-swhgcontainer = ZnodeOrderCustomer]").find("tbody tr").on("click", function (e) {
            e.preventDefault();
            var previousUserId = $("#hdnUserId").val();
            var userId = $(this).find("td a").attr("href").split('?')[1].split('&')[1].split('=')[1];
            Order.prototype.SetCustomerDetails(userId, previousUserId);
        });
    };
    Order.prototype.SetCustomerDetails = function (userId, previoususerId) {
        var cartParameter = {
            "UserId": userId,
            "PortalId": Order.prototype.GetPortalId(),
            "PublishedCatalogId": $("#PortalCatalogId").val(),
            "IsQuote": Order.prototype.IsQuote(),
        };
        $("#hdnUserId").val(userId);
        $(".tab-details").hide(true);
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.BindCustomerDetails(cartParameter, function (response) {
            var cartData = $.parseHTML(response);
            $("#txtCustomerName").val($(cartData).find('#UserAddressDataViewModel_FullName').val());
            $("#selectedUserName").val($(cartData).find('#UserAddressDataViewModel_FullName').val());
            $('#CustomerNameError').text('');
            $("#hdnAccountId").val($(cartData).find('#hdnAccountId').val());
            Order.prototype.SetUserDetailsbyHtml(cartData);
            ZnodeBase.prototype.CancelUpload('customerDetails');
            Order.prototype.RemoveUserNameValidation();
            Order.prototype.HideLoader();
            Order.prototype.ClearDiscountMessages();
            Order.prototype.SetShoppingCartDetails();
            if (previoususerId != $("#hdnUserId").val()) {
                Order.prototype.DisablePaymentAndReviewTab();
            }
        });
        $(".chkShippingBilling").remove();
    };
    Order.prototype.SetCustomerDetailsOnReorder = function (userId) {
        if ($("#hdnActionName").val() == "reordercompleteorder") {
            window.history.replaceState({}, document.title, "/" + "Order/ReorderCompleteOrder?userId=" + $("#hdnUserId").val() + "&portalId=" + $("#selectedPortalId").val());
            Order.prototype.SetCustomerDetails(userId, userId);
        }
    };
    Order.prototype.showCurrentTab = function () {
        if ($("#hdnAddressId").val() > 0 && $("#hdnAddressId").val() != undefined) {
            Order.prototype.ClickSelectedTab("shipping-cart-tab-link");
        }
        else {
            Order.prototype.ClickSelectedTab("customer-tab-link");
        }
    };
    Order.prototype.GetCartParameters = function () {
        var cartParameter = {
            "UserId": $("#hdnUserId").val(),
            "LocaleId": $("#LocaleId").val(),
            "PortalId": Order.prototype.GetPortalId(),
            "PublishedCatalogId": $("#PortalCatalogId").val(),
            "IsQuote": Order.prototype.IsQuote(),
        };
        return cartParameter;
    };
    Order.prototype.SetCustomerErrorMessage = function () {
        $("#btnSaveNextToShoppingCart").on("click", function (e) {
            var href = $(this).attr("href");
            $('#CustomerNameError').text('');
            if ($('#hdnUserId').val() <= 0) {
                $('#CustomerNameError').text(ZnodeBase.prototype.getResourceByKeyName("ErrorCustomerSelect"));
                e.preventDefault(); //this will prevent the link trying to navigate to another page
            }
        });
    };
    Order.prototype.GetNewCustomerView = function () {
        var portalId = Order.prototype.GetPortalId();
        Endpoint.prototype.GetNewCustomerView(portalId, function (response) {
            $("#panel-pop-up").html(response);
            $("#panel-pop-up").show(700);
            $("#panel-pop-up").append("<a class=\"panel-pop-up-close\" onclick='Order.prototype.ClosePanel()'><i class='z-close-circle'></i></a>");
        });
    };
    Order.prototype.ShippingSameAsBillingHandler = function () {
        if ($("#shippingSameAsBillingAddress").is(':checked')) {
            $("#BillingAddressContainer").hide();
        }
        else {
            $("#BillingAddressContainer").show();
        }
    };
    Order.prototype.IsLogin = function () {
        if ($("#CreateLogin").is(':checked')) {
            $("#divnewLogin").show();
        }
        else {
            $("#divnewLogin").hide();
        }
    };
    Order.prototype.ChangeTrackingNumberSuccessCallback = function (response) {
        if (response.TrackingNumber != "") {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateTrackingNumber"), "success", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.ChangeInHandDateSuccessCallback = function (response) {
        if (response.InHandDate != "") {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateInHandDate"), "success", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.ChangeJobNameSuccessCallback = function (response) {
        if (response.JobName == "" || response.JobName != response.Response) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Response, "error", isFadeOut, fadeOutTime);
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateJobName"), "success", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.ChangeShippingConstraintCodeSuccessCallback = function (response) {
        if (response.ShippingConstraintCode == "" || response.ShippingConstraintCode != response.Response) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Response, "error", isFadeOut, fadeOutTime);
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateShippingConstraintCode"), "success", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.ValidateTrackingNumber = function () {
        if ($("#OrderTextValue").val() == "") {
            $("#OrderTextValue").addClass("input-validation-error");
            $("#spnTrackingNumber").show();
            return false;
        }
        else {
            $("#OrderTextValue").removeClass("input-validation-error");
            $("#spnTrackingNumber").hide();
            return true;
        }
    };
    Order.prototype.ValidateShippingAccountNumber = function () {
        if ($("#OrderTextValue").val() == "") {
            $("#OrderTextValue").addClass("input-validation-error");
            $("#spnShippingAccountNumber").show();
            return false;
        }
        else {
            $("#OrderTextValue").removeClass("input-validation-error");
            $("#spnShippingAccountNumber").hide();
            return true;
        }
    };
    Order.prototype.ChangeShippingAccountNumberSuccessCallback = function (response) {
        if (response.ShippingAccountNumber != "")
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateShippingAccountNo"), "success", isFadeOut, fadeOutTime);
    };
    Order.prototype.ValidateShippingMethod = function () {
        if ($("#OrderTextValue").val() == "") {
            $("#OrderTextValue").addClass("input-validation-error");
            $("#spnShippingMethod").show();
            return false;
        }
        else {
            $("#OrderTextValue").removeClass("input-validation-error");
            $("#spnShippingMethod").hide();
            return true;
        }
    };
    Order.prototype.ChangeShippingMethodSuccessCallback = function (response) {
        if (response.shippingMethod != "")
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessUpdateShippingMethod"), "success", isFadeOut, fadeOutTime);
    };
    Order.prototype.AddCustomerSuccessCallback = function (response) {
        var html = $.parseHTML(response);
        var hideLoaderFlag = false;
        if ($($(html).find('.duplicateusererrormessage')[0]).val() != null && typeof $($(html).find('.duplicateusererrormessage')[0]).val() != 'undefined' && $($(html).find('.duplicateusererrormessage')[0]).val() != "") {
            $($($(html).find('.showduplicateusererrormessage')[0])[0]).text($($(html).find('.duplicateusererrormessage')[0]).val());
            $("#ShowDuplicateUserErrorMessage").text($($(html).find('.duplicateusererrormessage')[0]).val());
            Order.prototype.HideLoader();
            return false;
        }
        Order.prototype.ToggleFreeShipping();
        if (response.indexOf("field-validation-error") < 0) {
            if ($(html).find("#hdnHasError").val() == "False") {
                ZnodeBase.prototype.CancelUpload('customerDetails');
                $("#txtCustomerName").val($($(html).find('#UserName')[0]).val() + ' | ' + $($(html).find('#FirstName')[0]).val() + ' ' + $($(html).find('#LastName')[0]).val());
                $('#CustomerNameError').text('');
                var userId = $($(html).find('#hdnCreatedUserId')[0]).val();
                $("#hdnUserId").val(userId);
                var accountId = $($(html).find('#AccountId')).val();
                $("#hdnAccountId").val(accountId);
                ZnodeBase.prototype.ShowLoader();
                Endpoint.prototype.BindCustomerDetails(Order.prototype.GetCartParameters(), function (response) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("CustomerCreatedSuccessfully"), "success", isFadeOut, fadeOutTime);
                    $('#CustomerNameError').text('');
                    var cartData = $.parseHTML(response);
                    Order.prototype.SetUserDetailsbyHtml(cartData);
                    Order.prototype.RemoveUserNameValidation();
                    ZnodeBase.prototype.HideLoader();
                });
            }
            else {
                $("#error-create-customer").html("");
                $("#error-create-customer").html($(html).find("#hdnErrorMessage").val());
                hideLoaderFlag = true;
            }
        }
        else {
            $("#divtaxProductListPopup").html(response);
            hideLoaderFlag = true;
        }
        Order.prototype.RemoveFormDataValidation();
        if (hideLoaderFlag) {
            ZnodeBase.prototype.HideLoader();
        }
    };
    Order.prototype.ValidateCustomer = function () {
        var flag = true;
        if (Order.prototype.isCustomerValid != undefined && !Order.prototype.isCustomerValid) {
            Order.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("InvalidCustomer"), $("#txtCustomerName"), $("#CustomerNameError"));
            $("#btnCreateOrder").attr("disabled", "disabled");
            return flag = false;
        }
        else {
            Order.prototype.HideErrorMessage($("#txtCustomerName"), $("#CustomerNameError"));
            $("#btnCreateOrder").prop("disabled", false);
        }
        return flag;
    };
    Order.prototype.ShowErrorMessage = function (errorMessage, controlToValidateSelector, validatorSelector) {
        if (errorMessage === void 0) { errorMessage = ""; }
        controlToValidateSelector.removeClass("input-validation-valid").addClass("input-validation-error");
        validatorSelector.removeClass("field-validation-valid").addClass("field-validation-error").html("<span>" + errorMessage + "</span>");
    };
    Order.prototype.HideErrorMessage = function (controlToValidateSelector, validatorSelector) {
        controlToValidateSelector.removeClass("input-validation-error").addClass("input-validation-valid");
        validatorSelector.removeClass("field-validation-error").addClass(" field-validation-valid").html("");
    };
    Order.prototype.SetUserDetailsbyHtml = function (cartData) {
        //Set address details of user.
        $("#AddressDiv").html($(cartData).find('#AddressDiv').html());
        Order.prototype.SetShoppingCartDetails();
        $("#selectedUserName").val($(cartData).find('#UserAddressDataViewModel_FullName').val());
        //Display discount view if shopping cart having items other wise hide the discount view.
        Order.prototype.ShowHideDiscountView();
    };
    Order.prototype.updateQueryStringParameter = function (uri, key, value) {
        var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
        var separator = uri.indexOf('?') !== -1 ? "&" : "?";
        if (uri.match(re)) {
            return uri.replace(re, '$1' + key + "=" + value + '$2');
        }
        else {
            return uri + separator + key + "=" + value;
        }
    };
    Order.prototype.SetUserAddress = function (addressTypeName, response) {
        $('#UserAddressDataViewModel_' + addressTypeName + '_FirstName').val(response.FirstName);
        $('#UserAddressDataViewModel_' + addressTypeName + '_LastName').val(response.LastName);
        $('#UserAddressDataViewModel_' + addressTypeName + '_CompanyName').val(response.CompanyName);
        $('#UserAddressDataViewModel_' + addressTypeName + '_Address1').val(response.Address1);
        $('#UserAddressDataViewModel_' + addressTypeName + '_Address2').val(response.Address2);
        $('#UserAddressDataViewModel_' + addressTypeName + '_Address3').val(response.Address3);
        $('#UserAddressDataViewModel_' + addressTypeName + '_CityName').val(response.CityName);
        $('#UserAddressDataViewModel_' + addressTypeName + '_StateName').val(response.StateName);
        $('#UserAddressDataViewModel_' + addressTypeName + '_PostalCode').val(response.PostalCode);
        $('#UserAddressDataViewModel_' + addressTypeName + '_PhoneNumber').val(response.PhoneNumber);
        if (response.AddressId == 0) {
            $('#UserAddressDataViewModel_' + addressTypeName + '_AddressId').val(response.AddressId);
            $('#UserAddressDataViewModel_' + addressTypeName + '_CountryName').prop('selectedIndex', 0);
        }
        else {
            $('#UserAddressDataViewModel_' + addressTypeName + '_AddressId').val(response.AddressId);
        }
    };
    Order.prototype.SetProductDetails = function () {
        $('#ZnodeOrderProductList').find('#menu1').hide();
        var ZnodeOrderProductList = $("table[data-swhgcontainer='ZnodeOrderProductList']");
        ZnodeOrderProductList.find('.publishproductid').hide();
        ZnodeOrderProductList.find('.productType').hide();
        var gridTD = $('#ZnodeOrderProductList #grid tbody tr:eq(0)').find('td');
        Order.prototype.HideTableTH(gridTD, 'productType');
        Order.prototype.HideTableTH(gridTD, 'publishproductid');
        $("#ZnodeOrderProductList #grid").each(function (e) {
            if ($('#ZnodeOrderProductList #grid tbody tr:eq(0)').find('td').hasClass('addToCart')) {
                var indexOfRow = $('#ZnodeOrderProductList #grid tbody tr:eq(0)').find('.addToCart').index() + 1;
                $('th:nth-child(' + indexOfRow + ')').hide();
                $('td:nth-child(' + indexOfRow + ')').hide();
            }
        });
        var gridrow = $('#ZnodeOrderProductList #grid tbody tr');
        gridrow.each(function (e) {
            $(this).attr("data-container", "body").attr("data-toggle", "popover").attr("data-content", " ").addClass('addtocartpopover');
        });
        //To Show Add to cart Popup
        Order.prototype.ShowAddToCartPopup(gridrow);
    };
    Order.prototype.ShowAddToCartPopup = function (gridrow) {
        gridrow.on("click", function (event) {
            event.stopPropagation();
            var publishProductId = $(this).find('.grid-checkbox input[type=hidden]').val();
            var catalogId = $("#PortalCatalogId").val();
            var localeId = $("#LocaleId").val();
            var userId = $('#hdnUserId').val() == undefined ? $("#labelCustomerId").text().trim() : $("#hdnUserId").val();
            var portalId = Order.prototype.GetPortalId();
            var isQuote = Order.prototype.IsQuote();
            ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetPublishProduct?publishProductId=' + publishProductId + '&localeId=' + localeId + '&portalId=' + portalId + '&userId=' + userId + '&catalogId=' + catalogId + '&isQuote=' + isQuote, 'getProductDetail');
        });
    };
    Order.prototype.GenerateInvoice = function (event) {
        if (event == 'undefined' || event == "" || event == null) {
            return false;
        }
        else {
            var eventText = event.text;
            if (eventText != "" && eventText != null && eventText != 'undefined' && eventText.toLowerCase().trim() != "generate invoice") {
                return false;
            }
            var arrIds = DynamicGrid.prototype.GetMultipleSelectedIds();
            if (arrIds != undefined && arrIds.length > 0) {
                $("#orderIds").val(arrIds);
                var newForm = $('<form ></form>', { action: '/Order/DownloadPDF', method: 'POST' }).append($('<input></input>', {
                    'name': 'orderIds',
                    'id': 'orderIds',
                    'value': arrIds,
                    'type': 'hidden'
                }));
                $("body").append(newForm);
                newForm.submit();
                setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 1000);
                return true;
            }
            else {
                $("#SuccessMessage").html("");
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper("At least one order should be selected.", "error", isFadeOut, fadeOutTime);
                return false;
            }
        }
    };
    Order.prototype.GetProductsList = function () {
        ZnodeBase.prototype.ShowLoader();
        $("#customerDetails").html("");
        $("#divCustomerAddressPopup").html("");
        DynamicGrid.prototype.ClearCheckboxArray();
        var portalCatalogId = $("#PortalCatalogId").val();
        var portalId = Order.prototype.GetPortalId();
        var userId = $('#hdnUserId').val() == undefined ? $("#labelCustomerId").text().trim() : $("#hdnUserId").val();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/ProductList?portalCatalogId=' + portalCatalogId + '&portalId=' + portalId + '&userId=' + userId + '', 'getProductsList');
    };
    Order.prototype.ReorderValidateCart = function () {
        $("#divShoppingCart").find(".cart-scroll-section .product-quantity").each(function () {
            var control = $(this).find('input[id="CartQuantity"]');
            Order.prototype.CartQuantityValidation(control);
        });
    };
    Order.prototype.CartQuantityValidation = function (control) {
        var selectedQty = $(control).val();
        var maxQuantity = $(control).attr("data-cart-maxquantity");
        var minQuantity = $(control).attr("data-cart-minquantity");
        var externalId = $(control).attr("data-cart-externalid");
        if ((parseFloat(selectedQty) < parseFloat(minQuantity)) || (parseFloat(selectedQty) > parseFloat(maxQuantity))) {
            $("#quantity_error_msg_" + externalId).text('Selected quantity should be in between ' + minQuantity + ' to ' + maxQuantity + '.');
            $("#btnCreateOrder").attr("disabled", "disabled");
            Order.prototype.EnableDisableAddNotesButton(true);
            return false;
        }
        else if ($(".error-msg").text() !== "") {
            Order.prototype.EnableDisableAddNotesButton(true);
            return false;
        }
        return true;
    };
    Order.prototype.UpdateCartQuantity = function (control) {
        var productid = $(control).attr("data-cart-productid");
        var externalId = $(control).attr("data-cart-externalid");
        var shippingid = $("input[name='ShippingId']:checked").val();
        var inventoryRoundOff = $(control).attr("data-inventoryRoundOff");
        var userId = Order.prototype.GetUserId();
        $("#quantity_error_msg_" + externalId).text('');
        var selectedQty = $(control).val();
        if (selectedQty.split(".")[1] != null && parseInt(selectedQty.split(".")[1].length) > parseInt(inventoryRoundOff)) {
            $("#quantity_error_msg_" + externalId).text('Please enter quantity having ' + inventoryRoundOff + ' numbers after decimal point.');
            $("#btnCreateOrder").attr("disabled", "disabled");
            return false;
        }
        var matches = selectedQty.match(/^-?[\d.]+(?:e-?\d+)?$/);
        if (matches == null) {
            $("#quantity_error_msg_" + externalId).text('Please enter numeric value');
            $("#btnCreateOrder").attr("disabled", "disabled");
            Order.prototype.EnableDisableAddNotesButton(true);
            return false;
        }
        var cartQuantityValidation = Order.prototype.CartQuantityValidation(control);
        if (cartQuantityValidation) {
            Order.prototype.EnableDisableAddNotesButton(false);
            $("#btnCreateOrder").prop("disabled", false);
            var guid = $(control).attr("data-cart-externalid");
            ZnodeBase.prototype.ShowPartialLoader("loader-cart-content");
            this.UpdateQuantity(guid, selectedQty, productid, shippingid, userId);
        }
    };
    Order.prototype.EnableDisableAddNotesButton = function (isDisabled) {
        $('#btnNextTab').prop("disabled", isDisabled);
        $('#btnBottomNextTab').prop("disabled", isDisabled);
    };
    Order.prototype.UpdateQuantity = function (guid, selectedQty, productid, shippingid, userId) {
        Order.prototype.ClearShippingEstimates();
        Endpoint.prototype.UpdateCartQuantity(guid, selectedQty, productid, shippingid, Order.prototype.IsQuote(), userId, function (response) {
            if (response.success) {
                $("#divShoppingCart").html("");
                $("#divShoppingCart").html(response.html);
                //TODO:OMS
                $("#publishProductDv").html('');
                $("#publishProductDv").hide();
                var orderId = Order.prototype.GetOrderId();
                var portalId = Order.prototype.GetPortalId();
                //Calculate the shopping cart
                Order.prototype.CalculateShoppingCart(userId, portalId, orderId, false);
                //TODO:OMS
                if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
                    $("#couponContainer").html("");
                    $("#csr-discount-status").html("");
                    $("#txtcsrDiscount").val("");
                    $("#div-coupons-promotions").hide();
                }
                else {
                    Order.prototype.BindCouponHtml(response.coupons);
                }
            }
            ZnodeBase.prototype.HidePartialLoader("loader-cart-content");
        });
    };
    Order.prototype.CalculateShoppingCart = function (userId, portalId, orderId, showLoader) {
        if (showLoader === void 0) { showLoader = true; }
        if (showLoader) {
            ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        }
        var isQuote = Order.prototype.IsQuote();
        Endpoint.prototype.CalculateShoppingCart(userId, portalId, orderId, isQuote, function (response) {
            if (response.html.length > 0) {
                if (orderId > 0) {
                    $("#divTotal").html(response.html);
                }
                else {
                    $("#divTotal").html(response.html);
                    $("#OrderDetails").html(response.html);
                    $("#lblSubTotal").html(response.subtotal);
                    Order.prototype.BindCouponHtml(response.coupons);
                }
                if (showLoader) {
                    ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
                }
            }
        });
    };
    Order.prototype.DeleteCartItem = function (control) {
        if (!this.IsAnyPendingReturn()) {
            ZnodeBase.prototype.ShowPartialLoader("loader-cart-content");
            var guid = $(control).attr('data_cart_externalid');
            var orderId_1 = Order.prototype.GetOrderId();
            var userId_1 = Order.prototype.GetUserId();
            var portalId_1 = Order.prototype.GetPortalId();
            Endpoint.prototype.DeleteCartItem(guid, orderId_1, Order.prototype.IsQuote(), userId_1, portalId_1, function (response) {
                if (response.success) {
                    if (orderId_1 > 0) {
                        $("#orderLineItems").html(response.html);
                        Order.prototype.OnTaxExemptPageLoadCheck();
                    }
                    else {
                        $("#divShoppingCart").html("");
                        $("#divShoppingCart").html(response.html);
                    }
                    $("#publishProductDv").html('');
                    $("#publishProductDv").hide();
                    if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
                        Order.prototype.DisablePaymentAndReviewTab();
                        $("#couponContainer").html("");
                        $("#csr-discount-status").html("");
                        $("#txtcsrDiscount").val("");
                        $("#div-coupons-promotions").hide();
                    }
                    else {
                        Order.prototype.BindCouponHtml(response.coupons);
                    }
                    Order.prototype.ClearShippingEstimates();
                    //Calculate the shopping cart
                    Order.prototype.CalculateShoppingCart(userId_1, portalId_1, orderId_1);
                }
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorDeleteLineItem"), "error", isFadeOut, fadeOutTime);
                ZnodeBase.prototype.HidePartialLoader("loader-cart-content");
            });
        }
    };
    Order.prototype.DeleteAllCartItem = function () {
        ZnodeBase.prototype.ShowPartialLoader("loader-cart-content");
        var userId = Order.prototype.GetUserId();
        var portalId = Order.prototype.GetPortalId();
        var orderId = Order.prototype.GetOrderId();
        var isQuote = Order.prototype.IsQuote();
        if (userId > 0 && portalId > 0) {
            Endpoint.prototype.DeleteAllCartItem(userId, portalId, isQuote, function (response) {
                if (response.success) {
                    $("#divShoppingCart").html("");
                    $("#divShoppingCart").html(response.html);
                    //Calculate the shopping cart          
                    Order.prototype.CalculateShoppingCart(userId, portalId, orderId);
                    Order.prototype.RemoveAllCartSuccess();
                }
                Order.prototype.EnableDisableShippingOptions();
                ZnodeBase.prototype.HidePartialLoader("loader-cart-content");
            });
        }
    };
    Order.prototype.ResendOrderLineItemConfirmMail = function (cartLineItemId) {
        Endpoint.prototype.ResendOrderConfirmationForCartItem(Order.prototype.GetOrderId(), cartLineItemId, function (response) {
            window.location.reload(true);
        });
    };
    Order.prototype.AddressDivShowHide = function (tab) {
        var activeTab = $(tab).attr('id');
        $("#btnContinue").show();
        $("#btnCreateOrder").hide();
        $("#OrderAsidePannel>li.tab-selected").removeClass("tab-selected");
        $(tab).closest('li').addClass('tab-selected').removeClass("disabled");
        if (activeTab == 'z-customers') {
            $("#CustomerDiv").show();
            $("#AddressDiv").hide();
            $("#ShoppingCartDiv").hide();
            $("#shippingMethodDiv").hide();
            $("#paymentMethodsDiv").hide();
            $("#publishProductDv").html('');
            $("#publishProductDv").hide();
            $("#ReviewDiv").hide();
            if ($("#txtCustomerName").val() != "" || $("#txtCustomerName").val() != undefined) {
                $("#CustomerNameError").text('').removeClass("field-validation-error");
                $("#txtCustomerName").removeClass("input-validation-error");
            }
            $("#paypal-button").hide();
        }
        else if (activeTab == 'z-address') {
            $("#CustomerDiv").hide();
            $("#AddressDiv").show();
            $("#ShoppingCartDiv").hide();
            $("#shippingMethodDiv").hide();
            $(".chkShippingBilling").remove();
            $("#paymentMethodsDiv").hide();
            $("#publishProductDv").html('');
            $("#publishProductDv").hide();
            $("#ReviewDiv").hide();
            $("#paypal-button").hide();
        }
        else if (activeTab == 'z-shopping-cart') {
            $("#CustomerDiv").hide();
            $("#AddressDiv").hide();
            $("#ShoppingCartDiv").show();
            Order.prototype.ShowHideDiscountView();
            $("#shippingMethodDiv").hide();
            $("#paymentMethodsDiv").hide();
            $("#publishProductDv").html('');
            $("#publishProductDv").hide();
            $("#ReviewDiv").hide();
            $("#paypal-button").hide();
        }
        else if (activeTab == 'z-shipping-methods') {
            Order.prototype.AddCustomShippingAmount('', '', true);
            Order.prototype.GetShippingEstimates();
            $("#CustomerDiv").hide();
            $("#AddressDiv").hide();
            $("#ShoppingCartDiv").hide();
            $("#shippingMethodDiv").show();
            $("#paymentMethodsDiv").hide();
            $("#publishProductDv").html('');
            $("#publishProductDv").hide();
            $("#ReviewDiv").hide();
            $("#paypal-button").hide();
            if ($("#hndShippingclassName").val() == Constant.ZnodeCustomerShipping) {
                $("#customerShippingDiv").show();
            }
        }
        else if (activeTab == 'z-payment') {
            $("#CustomerDiv").hide();
            $("#AddressDiv").hide();
            $("#ShoppingCartDiv").hide();
            $("#shippingMethodDiv").hide();
            $("#paymentMethodsDiv").show();
            $("#publishProductDv").html('');
            $("#publishProductDv").hide();
            $("#ReviewDiv").hide();
            if (($("#hdnTotalOrderAmount").val() == undefined || $("#hdnTotalOrderAmount").val() > 0.00) && ($("#hdnOverDueAmount").val() >= 0.00)) {
                $("#ddlPaymentTypes").prop("disabled", false);
            }
            else {
                $(".HidePaymentTypeDiv").hide();
                $("#div-COD").show();
                $("#ddlPaymentTypes").val($("#ddlPaymentTypes option:first").val());
                $("#ddlPaymentTypes").prop("disabled", true);
            }
            if (isValidCvvSaved)
                Order.prototype.ShowAndSetPayment("#ddlPaymentTypes", true);
        }
        else if (activeTab == 'z-review') {
            if (Order.prototype.ReviewOrder()) {
                $("#CustomerDiv").hide();
                $("#AddressDiv").hide();
                $("#ShoppingCartDiv").hide();
                $("#shippingMethodDiv").hide();
                $("#paymentMethodsDiv").hide();
                $("#publishProductDv").html('');
                $("#publishProductDv").hide();
                $("#ReviewDiv").show();
                $("#btnContinue").hide();
                Order.prototype.DisableCheckouButtonOnReviewPage();
                if ($("#ddlPaymentTypes option:selected").length == 0 || $("#ddlPaymentTypes option:selected").attr("id") && $("#ddlPaymentTypes option:selected").attr("id").toLowerCase() != 'paypal_express') {
                    $("#btnCreateOrder").show();
                }
                else {
                    Order.prototype.DisableCheckouButtonOnReviewPage();
                    if (parseFloat($("#hdnTotalOrderAmount").val()) == 0 && $("#ddlPaymentTypes option:selected").length == 1) {
                        $("#btnCreateOrder").show();
                    }
                    else {
                        $("#btnCreateOrder").hide();
                        $("#paypal-button").show();
                    }
                }
                if (($("#ddlPaymentTypes option:selected").length > 0 || $("#ddlPaymentTypes option:selected").attr("id")) && ($("#ddlPaymentTypes option:selected").attr("id") != undefined && ($("#ddlPaymentTypes option:selected").attr("id").toLowerCase() == 'paypal_expresspaypal' || $("#ddlPaymentTypes option:selected").attr("data-payment-type") == "PAYPAL_EXPRESS"))) {
                    $("#btnCreateOrder").hide();
                }
            }
        }
        OrderSidePanel.prototype.SetSidePanelData($("#OrderAsidePannel>li.tab-selected").attr("id"));
        if ($('#shippingMethodDiv input[name="ShippingId"]').length > 0) {
            $("#div-shipping-method-change").show();
        }
        else {
            $("#div-shipping-method-change").hide();
        }
    };
    Order.prototype.GetShippingEstimates = function () {
        if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("NoProductsInCart"), 'error', isFadeOut, fadeOutTime);
        }
        else {
            ZnodeBase.prototype.ShowPartialLoader("loader-shippingOptions");
            var shippingId = $('#shippingMethodDiv input[name="ShippingId"]:checked').val();
            var customerShippingAccountNumber = $("#ShippingListViewModel_AccountNumber").val();
            var customerShippingMethod = $("#ShippingListViewModel_ShippingMethod").val();
            Endpoint.prototype.GetShippingOptions($("#hdnUserId").val(), true, Order.prototype.IsQuote(), function (response) {
                if (response != null && response.result != "") {
                    $("#ShippingDetails").empty();
                    $("#div-shipping-method-change").show();
                    $("#ShippingDetails").append(response.result);
                    $("#ShippingListViewModel_AccountNumber").val(customerShippingAccountNumber);
                    $("#ShippingListViewModel_ShippingMethod").val(customerShippingMethod);
                    Order.prototype.DisableShippingForFreeShippingAndDownloadableProduct();
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("NoShippingOptionList"), "error", isFadeOut, fadeOutTime);
                }
                shippingId = shippingId != "" && typeof shippingId != "undefined" ? shippingId : $("#hdnQuoteShipppingId").val();
                var shippingClassName = "";
                if (shippingId != "" && typeof shippingId != "undefined") {
                    $('#shippingMethodDiv input[name="ShippingId"][value=' + shippingId + ']').prop('checked', true);
                    shippingClassName = $('#shippingMethodDiv input[name="ShippingId"]:checked').attr("data-ShippingClassName");
                    var shippingCode = $('#shippingMethodDiv input[name="ShippingId"]:checked').attr("id");
                    Order.prototype.ShowEditCustomShipping(shippingCode);
                }
                if ($("#cartFreeShipping").val() != "True" && $("#shippingMethodDiv :radio:checked").length > 0)
                    Order.prototype.ShippingChangeHandler(shippingClassName);
                ZnodeBase.prototype.HidePartialLoader("loader-shippingOptions");
            });
        }
    };
    Order.prototype.GetShippingEstimatesForManage = function () {
        ZnodeBase.prototype.ShowLoader();
        var shippingId = $('#shippingMethodDiv input[name="ShippingId"]:checked').val();
        Endpoint.prototype.GetShippingOptionsForManage(Order.prototype.GetOrderId(), function (response) {
            ZnodeBase.prototype.ShowLoader();
            if (response != null && response.ShippingOptionList != null) {
                var loopCount = response.ShippingOptionList.length;
                for (var iCount = 0; iCount < loopCount; iCount++) {
                    var shippingRateId = "#ShippingId_" + response.ShippingOptionList[iCount].ShippingId;
                    var shippingRate = " - " + response.ShippingOptionList[iCount].FormattedShippingRate;
                    $(shippingRateId).html(shippingRate);
                }
                $('#shippingMethodDiv input[name="ShippingId"][value=' + shippingId + ']').prop('checked', true);
                ZnodeBase.prototype.HideLoader();
            }
        });
    };
    Order.prototype.ClearShippingEstimates = function () {
        $('#shippingOptionMethod').html('');
        $('#shippingOptionMethod').html('<div id="divNoShippingOptions" class="col-sm-12 text-center margin-bottom" data-test-selector="divNoShippingOptionAvailable">' + ZnodeBase.prototype.getResourceByKeyName("UpdateShippingOptions") + '</div>');
    };
    Order.prototype.BindUserAddress = function (e) {
        if ($('#hdnUserId').val() <= 0) {
            $('#CustomerNameError').text(ZnodeBase.prototype.getResourceByKeyName("ErrorCustomerSelect"));
            e.preventDefault();
        }
        $("#CustomerDiv").toggle();
        $("#AddressDiv").toggle();
        Endpoint.prototype.BindCustomerDetails(Order.prototype.GetCartParameters(), function (response) {
            var cartData = $.parseHTML(response);
            Order.prototype.SetUserDetailsbyHtml(cartData);
        });
        $(".chkShippingBilling").remove();
    };
    Order.prototype.SubmitOrder = function () {
        var isValid = false;
        isValid = OrderTabs.prototype.ContinueOrder();
        if (isValid) {
            var paymentCode = $("#hdnGatewayCode").val().toLowerCase();
            if (paymentCode == Constant.CyberSource) {
                if ($('ul#creditCardTab ').find('li').find('a.active').attr('href') == "#savedCreditCard-panel" || $('ul#creditCardTab ').find('li.active').find('a').attr('href') == "#savedCreditCard-panel") {
                    Order.prototype.SubmitCyberSourcePayment("");
                }
                else {
                    $("#pay-button").click();
                }
            }
            else {
                Order.prototype.SubmitOrderCheckout();
            }
        }
    };
    Order.prototype.SubmitOrderCheckout = function () {
        ZnodeBase.prototype.ShowLoader();
        var isValid = true;
        isValid = Order.prototype.ValidateDetails("false");
        if (isValid) {
            ZnodeBase.prototype.ShowLoader();
            if ($("#hdnTotalOrderAmount").val() == undefined || $("#hdnTotalOrderAmount").val() > 0.00 && ($("#hdnOverDueAmount").val() >= 0.00)) {
                var selectedPaymentText = $("#ddlPaymentTypes option:selected").attr("id");
                var paymentSettingId = $("#ddlPaymentTypes").val();
                $("#hdnPaymentTypeId").val(paymentSettingId);
                selectedPaymentText = this.GetPaymentType(selectedPaymentText);
                switch (selectedPaymentText) {
                    case "cod":
                        Order.prototype.SubmitCheckOut();
                        break;
                    case "purchase_order":
                        Order.prototype.SubmitCheckOut();
                        break;
                    case "credit_card":
                        Order.prototype.GetPaymentDetails(paymentSettingId);
                        Order.prototype.SubmitPayment();
                        break;
                    case "ach":
                        Order.prototype.GetPaymentDetails(paymentSettingId);
                        Order.prototype.SubmitACHPayment();
                        break;
                    case "invoice me":
                        Order.prototype.SubmitCheckOut();
                        break;
                }
            }
            else {
                Order.prototype.SubmitCheckOut();
            }
        }
        if (!isValid)
            ZnodeBase.prototype.HideLoader();
    };
    Order.prototype.SubmitCheckOut = function () {
        $('#status-message').remove();
        var controllerName;
        if ($('.z-cancel').closest('a').attr('id') == "btnCancelQuoteOrderId") {
            controllerName = "Quote";
        }
        else
            controllerName = "Order";
        $("#PortalId").val(Order.prototype.GetPortalId());
        $.ajax({
            url: "/Order/SubmitOrder",
            data: Order.prototype.SetCreateOrderViewModel(),
            type: 'POST',
            success: function (data) {
                Order.prototype.HideLoader();
                if (!data.HasError) {
                    var form = $('<form action="CheckoutReceipt" method="post">' +
                        '<input type="hidden" name="orderId" value="' + data.OrderId + '" />' +
                        '<input type="text" name= "ReceiptHtml" value= "' + data.ReceiptHtml + '" />' +
                        '<input type="hidden" name= "IsEmailSend" value= ' + data.IsEmailSend + ' />' +
                        '</form>');
                    var action = controllerName == "Quote" ? "/Quote/CheckoutReceipt" : "/Order/CheckoutReceipt";
                    form.attr("action", action);
                    $('body').append(form);
                    $(form).submit();
                }
                else {
                    ZnodeBase.prototype.HideLoader();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.ErrorMessage, "error", isFadeOut, fadeOutTime);
                }
            }
        });
    };
    Order.prototype.ValidateShipping = function () {
        var shipping = $("[name='ShippingId']").val();
        if (shipping == undefined || shipping == "" || $("#shippingMethodDiv #ShippingDetails :radio:checked").length == 0 && ($("#cartFreeShipping").val() != "True" || $("#hdnIsFreeShipping").val() != "True")) {
            Order.prototype.ClickSelectedTab("shipping-cart-tab-link");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingNotAvailable"), "error", isFadeOut, fadeOutTime);
            return false;
        }
        return true;
    };
    Order.prototype.ValidateDetails = function (isQuote) {
        ZnodeBase.prototype.ShowLoader();
        var isValid = true;
        var paymentType = $("#ddlPaymentTypes option:selected").attr("id");
        var cardType = $('input[name="PaymentProviders"]:checked').val();
        paymentType = this.GetPaymentType(paymentType);
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
        else if (paymentType == null && paymentType == undefined && ($("#hdnTotalOrderAmount").val() > 0.00)) {
            Order.prototype.ClickSelectedTab("payment-tab-link");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorPaymentAvailable"), "error", isFadeOut, fadeOutTime);
            isValid = false;
        }
        else if (paymentType != null && paymentType != undefined) {
            if (paymentType.toLowerCase() == 'select payment type') {
                if (isQuote != "true") {
                    if ($("#hdnTotalOrderAmount").val() == undefined || $("#hdnTotalOrderAmount").val() > 0.00 && ($("#hdnOverDueAmount").val() >= 0.00)) {
                        isValid = false;
                        $("#ddlPaymentTypes").css({
                            "border": "1px solid red"
                        });
                        Order.prototype.ClickSelectedTab("payment-tab-link");
                    }
                }
            }
            else if (paymentType == 'credit_card' && ($("#OrderAsidePannel>li.active").attr("id") == 'payment-tab-link' || $("#OrderAsidePannel>li.active").attr("id") == 'review-placeorder-tab-link')) {
                var isCCValid_1 = true;
                if ($('#creditCardTab').css('display') == 'block' && $('ul#creditCardTab ').find('li.active').find('a').attr('href') == "#savedCreditCard-panel") {
                    var savedCartOptionValue = $("input[name='CCListdetails']:checked").val();
                    if (savedCartOptionValue == null || savedCartOptionValue == "") {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSavedCreditCardOption"), "error", isFadeOut, fadeOutTime);
                        isValid = false;
                        isCCValid_1 = false;
                        Order.prototype.ClickSelectedTab("payment-tab-link");
                    }
                    else {
                        isValid = Order.prototype.ValidateCVV();
                        isValid ? isCCValid_1 = true : isCCValid_1 = false;
                    }
                }
                else if ($("#hdnGatewayCode").val().toLowerCase() == "cardconnect") {
                    isValid = Order.prototype.ValidateCardConnectDataToken() && Order.prototype.ValidateCardConnectCardHolderName();
                }
                else if ($("#hdnGatewayCode").val().toLowerCase() == Constant.CyberSource) {
                    isValid = Order.prototype.ValidateCardConnectDataToken();
                    if (!isValid)
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper($("#ErrorMessage").val(), "error", isFadeOut, fadeOutTime);
                }
                else {
                    $('input[data-payment="number"],input[data-payment="exp-month"],input[data-payment="exp-year"],input[data-payment="cvc"],input[data-payment="cardholderName"]').each(function () {
                        if ($.trim($(this).val()) == '') {
                            isValid = false;
                            isCCValid_1 = false;
                            $(this).css({
                                "border": "1px solid red"
                            });
                        }
                        else {
                            $(this).css({
                                "border": "1px solid #c3c3c3"
                            });
                        }
                    });
                    if (!Order.prototype.Mod10($('input[data-payment="number"]').val())) {
                        isValid = false;
                        isCCValid_1 = false;
                        $('#errornumber').show();
                        $('input[data-payment="number"]').css({
                            "border": "1px solid red"
                        });
                    }
                    else {
                        $('#errornumber').hide();
                    }
                    if (!Order.prototype.ValidateCreditCardExpirationDetails()) {
                        isValid = false;
                    }
                    if ($('input[data-payment="cvc"]').val().length < 3) {
                        isValid = false;
                        isCCValid_1 = false;
                        Order.prototype.ShowHideErrorCVV(true);
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
                            isCCValid_1 = false;
                            Order.prototype.ShowHideErrorCVV(true);
                            Order.prototype.PaymentError("cvc");
                        }
                    }
                    if ($('input[data-payment="cardholderName"]').val() == '') {
                        $('#errorcardholderName').show();
                    }
                    else {
                        $('#errorcardholderName').hide();
                    }
                    if (isCCValid_1 == true) {
                        var cardNumber = Order.prototype.GetCreditCardNumber();
                        var cardType = Order.prototype.DetectCardType(cardNumber);
                        if ($("#addNewCreditCard-panel").attr("class").indexOf("active") != -1) {
                            isValid = Order.prototype.ValidateCardType(cardType);
                        }
                    }
                }
                if (isValid == false) {
                    Order.prototype.ClickSelectedTab("payment-tab-link");
                }
            }
            else if (paymentType.toLowerCase() == 'purchase_order') {
                if ($("#PurchaseOrderNumber").val() == "") {
                    $("#PurchaseOrderNumber").css({
                        "border": "1px solid red"
                    });
                    $("#cart-ponumber-status").show();
                    isValid = false;
                    Order.prototype.ClickSelectedTab("payment-tab-link");
                }
            }
            else if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
                isValid = false;
                Order.prototype.ClickSelectedTab("shipping-cart-tab-link");
            }
            else if ($("#hdnIsAnyProductOutOfStock").val().toLowerCase() == 'true' || $("#hdnIsAnyProductOutOfStock").val() == true) {
                isValid = false;
                Order.prototype.ClickSelectedTab("shipping-cart-tab-link");
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
    Order.prototype.ValidateCreditCardExpirationDetails = function () {
        var isValidCard = true;
        var isValidMonth = true;
        var isValidYear = true;
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="exp-month"]');
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="exp-year"]');
        $('#errormonth').hide();
        $('#erroryear').hide();
        var currentMonth = (new Date).getMonth() + 1;
        var currentYear = (new Date).getFullYear();
        if ($('input[data-payment="exp-year"]').val() == currentYear && $('input[data-payment="exp-month"]').val() < currentMonth) {
            isValidYear = false;
            isValidMonth = false;
        }
        if (!/^[0-9]+$/.test($('input[data-payment="exp-year"]').val())) {
            isValidYear = false;
        }
        if (!/^[0-9]+$/.test($('input[data-payment="exp-month"]').val())) {
            isValidMonth = false;
        }
        if ($('input[data-payment="exp-month"]').val() > 12 || $('input[data-payment="exp-month"]').val() < 1) {
            isValidMonth = false;
        }
        if ($('input[data-payment="exp-year"]').val() < currentYear) {
            isValidYear = false;
        }
        if (!isValidMonth && !isValidYear) {
            isValidCard = false;
            $('#errormonth').show();
            Order.prototype.PaymentError("exp-month");
            Order.prototype.PaymentError("exp-year");
        }
        else if (!isValidMonth) {
            isValidCard = false;
            $('#errormonth').show();
            Order.prototype.PaymentError("exp-month");
        }
        else if (!isValidYear) {
            isValidCard = false;
            $('#erroryear').show();
            Order.prototype.PaymentError("exp-year");
        }
        return isValidCard;
    };
    Order.prototype.ShowHideErrorCVV = function (isShow) {
        isShow ? $('#errorcvc').show() : $('#errorcvc').hide();
    };
    Order.prototype.PaymentError = function (control) {
        $('input[data-payment=' + control + ']').css({
            "border": "1px solid red",
            "background": "#FFCECE"
        });
    };
    Order.prototype.RemoveCreditCardValidationCSS = function (control) {
        $(control).css('border', '1px solid #969EA4');
        $(control).css('background', '');
    };
    Order.prototype.ValidateCVV = function () {
        var cardtype = $("input[name='CCListdetails']:checked").next().next().attr('data-cardtype');
        var cvvNumber = $("input[name='CCListdetails']:checked").next().next().val();
        if (cardtype == Constant.AmericanExpressCardCode) {
            if (!cvvNumber || cvvNumber.length < 4) {
                Order.prototype.CSSofCVVforSavedCard();
                isValidCvvSaved = false;
                return false;
            }
        }
        if (!cvvNumber || (cvvNumber.length <= 2 || cvvNumber.length > 4)) {
            Order.prototype.CSSofCVVforSavedCard();
            isValidCvvSaved = false;
            return false;
        }
        $("[name='SaveCard-CVV']:visible").parent().find("span").hide();
        isValidCvvSaved = true;
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvv"]');
        return true;
    };
    ;
    Order.prototype.ClearCreditCartDetails = function () {
        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var LastTab = $(e.relatedTarget).attr('href'); // get last tab
            if (LastTab == "#savedCreditCard-panel") {
                $('input:radio[name=CCListdetails]').prop('checked', false);
            }
            if (LastTab == "#addNewCreditCard-panel") {
                $("input:radio[name=PaymentProviders]:first").prop('checked', true);
                $("#div-CreditCard [data-payment='number']").val('');
                $("#div-CreditCard [data-payment='cvc']").val('');
                $("#div-CreditCard [data-payment='exp-month']").val('');
                $("#div-CreditCard [data-payment='exp-year']").val('');
                $("#div-CreditCard [data-payment='cardholderName']").val('');
            }
        });
    };
    Order.prototype.DisableShippingForFreeShippingAndDownloadableProduct = function () {
        if ($("#cartFreeShipping").val() == "True" || $("#hdnIsFreeShipping").val() == "True") {
            $("#FreeShipping").attr('disabled', false);
            $("#FreeShipping").prop("checked", true);
            Order.prototype.ShippingChangeHandler('ZnodeCustomShipping', 'FreeShipping');
            $("#message-freeshipping").show();
            $('#shippingOptionMethod').addClass('disable-radio');
        }
        else {
            $('#shippingOptionMethod').removeClass('disable-radio');
        }
    };
    Order.prototype.SubmitQuote = function () {
        var isValid = true;
        isValid = Order.prototype.ValidateDetails("true");
        if (isValid) {
            $('#status-message').remove();
            $("#PortalId").val(Order.prototype.GetPortalId());
            ZnodeBase.prototype.ShowLoader();
            $.ajax({
                url: "/Order/SubmitQuote",
                data: $("#checkoutform").serialize(),
                type: 'POST',
                success: function (data) {
                    Order.prototype.HideLoader();
                    if (!data.HasError) {
                        var requestedUrl = window.location.href.toLocaleLowerCase();
                        if (requestedUrl.indexOf("createquoteforcustomer") > 0) {
                            window.location.href = "/Account/CustomersList?accountId=" + data.AccountId;
                        }
                        else if (requestedUrl.indexOf("createaccountquote") > 0) {
                            window.location.href = "/Account/AccountQuoteList?accountId=" + data.AccountId;
                        }
                        else {
                            window.location.href = "/Quote/AccountQuoteList";
                        }
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("QuoteSubmittedSuccessfully"), "success", isFadeOut, fadeOutTime);
                    }
                    else {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.ErrorMessage, "error", isFadeOut, fadeOutTime);
                    }
                }
            });
        }
    };
    Order.prototype.ClickSelectedTab = function (tabToClick) {
        $("#OrderAsidePannel").find('#' + tabToClick).addClass('tab-selected');
        $("#OrderAsidePannel").find('#' + tabToClick).find('a').click();
        $("#OrderAsidePannel").find('#' + tabToClick).addClass('active');
    };
    Order.prototype.ChangeShipping = function () {
        ZnodeBase.prototype.CancelUpload("ReviewOrderPopup");
        Order.prototype.ClickSelectedTab("z-shipping-methods");
    };
    Order.prototype.ChangeAddress = function () {
        ZnodeBase.prototype.CancelUpload("ReviewOrderPopup");
        Order.prototype.ClickSelectedTab("z-address");
    };
    Order.prototype.BindAddOnProductSKU = function (event) {
        OneClick = true;
        if ($("#product-details-quantity input[name='Quantity']").attr('data-change') == "true") {
            $("#button-addtocart").attr("disabled", "disabled");
            event.preventDefault();
            return false;
        }
        var personalisedForm = $("#frmPersonalised");
        if (personalisedForm.length > 0 && !personalisedForm.valid())
            return false;
        var addOnValues = [];
        var bundleProducts = [];
        var groupProducts = "";
        var groupProductsQuantity = "";
        var personalisedCodes = [];
        var personalisedValues = [];
        var quantity = "";
        var flag = true;
        var groupProductName = "";
        var productType = $("#dynamic-producttype").val();
        selectedProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        //for checkbox   
        $(".chk-product-addons").each(function () {
            var optional = $(this).data("isoptional");
            var id = $(this).attr("id");
            var addOnId = $(this).data("addongroupid");
            if (optional == "False") {
                flag = true;
            }
            else {
                var isError = true;
                $('#' + id).find(':checkbox').each(function () {
                    if ($(this).is(':checked')) {
                        isError = false;
                    }
                });
                if (!isError) {
                    $("#paraComment-" + addOnId).css("display", "none");
                    flag = true;
                }
                else {
                    $("#paraComment-" + addOnId).removeAttr("style");
                    flag = false;
                }
            }
        });
        //Get selected add on product skus.
        addOnValues = Order.prototype.GetSelectedAddons();
        //Get bundle product skus.
        bundleProducts = Order.prototype.GetSelectedBundelProducts();
        //Get group product skus and their quantity.
        $("#groupProductList").find("input[type=text].quantity").each(function () {
            if ($(this).attr("name") != "Quantity") {
                var quantity = $(this).val();
                if (quantity != null && quantity != "") {
                    groupProducts = groupProducts + $(this).attr("name") + ",";
                    groupProductsQuantity = groupProductsQuantity + $(this).val() + "_";
                    groupProductName = groupProductName + $(this).attr("data-productname") + ",";
                }
            }
        });
        groupProductsQuantity = groupProductsQuantity.substr(0, groupProductsQuantity.length - 1);
        groupProducts = groupProducts.substr(0, groupProducts.length - 1);
        if (productType == "GroupedProduct") {
            if (groupProductsQuantity == null || groupProductsQuantity == "") {
                $("#group-product-error").html(ZnodeBase.prototype.getResourceByKeyName("RequiredProductQuantity"));
                return false;
            }
            else if (!Order.prototype.OnAssociatedProductQuantityChange()) {
                $("#group-product-error").html(ZnodeBase.prototype.getResourceByKeyName("ErrorProductQuantity"));
                return false;
            }
            else {
                if (!Order.prototype.CheckGroupProductQuantity(Order.prototype.BindProductParameterModel(), groupProducts, groupProductsQuantity))
                    return false;
            }
            if (quantity == "" || quantity == "0") {
                var groupProductsQuantitySum = 0;
                var quantityArray = groupProductsQuantity.split('_');
                for (var i = 0; i < quantityArray.length; i++) {
                    groupProductsQuantitySum = groupProductsQuantitySum + parseInt(quantityArray[i]);
                }
                quantity = groupProductsQuantitySum.toString();
            }
        }
        else {
            quantity = $("#product-details-quantity input[name='Quantity']").val();
        }
        $("input[IsPersonalizable = True]").each(function () {
            var $label = $("label[for='" + this.id + "']");
            personalisedValues.push($(this).val());
            personalisedCodes.push($label.text());
        });
        Order.prototype.SetCartItemModelValues(addOnValues, bundleProducts, groupProducts, groupProductsQuantity, quantity, personalisedCodes, personalisedValues, groupProductName);
        //if flag=true then only show loader.
        if (flag)
            ZnodeBase.prototype.ShowLoader();
        return flag;
    };
    Order.prototype.BindProductParameterModel = function () {
        var _productParameter = {
            PortalId: Order.prototype.GetPortalId(),
            LocaleId: parseInt($("#LocaleId").val()),
            PublishProductId: parseInt($("#dynamic-parentproductId").val()),
            UserId: parseInt($("#hdnUserId").val()),
            OMSOrderId: $("#OmsOrderId").val() == "" || $("#OmsOrderId").val() == 'undefined' ? $("#OrderId").val() : $("#OmsOrderId").val()
        };
        return _productParameter;
    };
    Order.prototype.CheckGroupProductQuantity = function (productParameters, groupProductSkus, groupProductQuantities) {
        var isSuccess = true;
        Endpoint.prototype.CheckGroupProductInventory(productParameters, groupProductSkus, groupProductQuantities, function (response) {
            if (response.ErrorMessage != "" && response.ErrorMessage != null && response.ErrorMessage != "undefined") {
                $("#group-product-error").html(response.ErrorMessage);
                isSuccess = false;
            }
        });
        return isSuccess;
    };
    Order.prototype.OnQuantityChange = function (control) {
        $("#product-details-quantity input[name='Quantity']").attr('data-change', 'true');
        $("#quantity-error-msg").text('');
        $("#dynamic-inventory").text('');
        var _productDetail = Order.prototype.BindProductModel(control, false);
        if (this.CheckIsNumeric(_productDetail.Quantity, _productDetail.QuantityError)) {
            if (this.CheckDecimalValue(_productDetail.DecimalPoint, _productDetail.DecimalValue, _productDetail.InventoryRoundOff, _productDetail.QuantityError)) {
                if (this.CheckQuantityGreaterThanZero(parseInt(_productDetail.Quantity), _productDetail.QuantityError)) {
                    $("#button-addtocart").prop("disabled", false);
                    Order.prototype.UpdateProductVariations(false, _productDetail.SKU, _productDetail.MainProductSKU, _productDetail.Quantity, _productDetail.MainProductId, function (response) {
                        var salesPrice = response.data.price;
                        Order.prototype.UpdateProductValues(response, _productDetail.Quantity);
                        Order.prototype.RefreshPrice(salesPrice);
                        Order.prototype.InventoryStatus(response);
                    });
                }
            }
        }
    };
    Order.prototype.OnAddonSelect = function () {
        $("#dynamic-product-addons").on("change", ".AddOn", function (ev) {
            $('p[id*="paraComment"]').hide();
            var _productSKU = Order.prototype.GetGroupProductSKUQuantity($(this).attr("data-parentsku"));
            if (_productSKU != null) {
                Order.prototype.UpdateProductVariations(false, _productSKU.SKU, _productSKU.ParentSKU, _productSKU.Quantity, _productSKU.ParentProductId, function (response) {
                    var salesPrice = response.data.price;
                    Order.prototype.UpdateProductValues(response, _productSKU.Quantity);
                    Order.prototype.RefreshPrice(salesPrice);
                    Order.prototype.InventoryStatus(response);
                });
            }
        });
    };
    Order.prototype.GetGroupProductSKUQuantity = function (parentSKU) {
        var _productSKU;
        $("input[type=text].quantity").each(function () {
            if ($(this).attr("name") != "Quantity") {
                var groupProductQuantity = $(this).val();
                if (groupProductQuantity != null && groupProductQuantity != "") {
                    _productSKU = {
                        Quantity: groupProductQuantity,
                        SKU: $(this).attr("data-sku"),
                        ParentSKU: parentSKU,
                        ParentProductId: 0
                    };
                    return false;
                }
            }
        });
        if (_productSKU == null) {
            _productSKU = {
                Quantity: $("#Quantity").val(),
                SKU: $("#Quantity").attr("data-sku"),
                ParentSKU: $("#Quantity").attr("data-parentsku"),
                ParentProductId: parseInt($("#Quantity").attr("data-parentProductId")),
            };
        }
        return _productSKU;
    };
    Order.prototype.UpdateProductVariations = function (htmlContainer, sku, parentSku, quantity, parentProductId, callbackMethod) {
        var selectedAddOnIds = Order.prototype.getAddOnIds("");
        var portalId = Order.prototype.GetPortalId();
        var omsOrderId = $("#OmsOrderId").val() == "" || $("#OmsOrderId").val() == 'undefined' ? $("#OrderId").val() : $("#OmsOrderId").val();
        var userId = $("#hdnUserId").val();
        if ((parseInt($("#OrderId").val()) > 0 && $.isNumeric($("#OrderId").val())) || (parseInt($("#OmsOrderId").val()) > 0 && $.isNumeric($("#OmsOrderId").val()))) {
            portalId = $("#PortalId").val();
        }
        Endpoint.prototype.GetProductPrice(portalId, sku, parentSku, quantity, selectedAddOnIds, parentProductId, omsOrderId, userId, function (res) {
            if (callbackMethod) {
                callbackMethod(res);
            }
        });
    };
    Order.prototype.UpdateProductValues = function (response, quantity) {
        var selectedAddOnIds = Order.prototype.getAddOnIds("");
        // Set form values for submit
        $("#dynamic-productid").val(response.data.productId);
        $("#dynamic-sku").val(response.data.sku);
        $("#Quantity").val(quantity);
        $("#dynamic-addons").val(selectedAddOnIds);
        $("input[name='AddOnValueIds']").val(selectedAddOnIds);
        if (response.data.addOnMessage != undefined) {
            $("#dynamic-addOninventory").show();
            $("#dynamic-addOninventory").html(response.data.addOnMessage);
        }
        else {
            $("#dynamic-addOninventory").hide();
            $("#dynamic-addOninventory").html("");
        }
    };
    Order.prototype.RefreshPrice = function (amount) {
        $("#product_Detail_Price_Div").show();
        $("#layout-product .dynamic-product-price").html(amount);
        $("#oms_pdp_price").text(amount);
    };
    Order.prototype.InventoryStatus = function (response) {
        if (response.success) {
            // In stock
            $("#dynamic-inventory").hide();
            $("#button-addtocart").prop("disabled", false);
            $("#button-addtocart").attr("onclick", "return Order.prototype.BindAddOnProductSKU(event);");
            $("#product-details-quantity input[name='Quantity']").attr("data-change", "false");
        }
        else {
            // Out of stock
            $("#button-addtocart").attr("disabled", "disabled");
            $("#dynamic-inventory").show().html(response.message);
        }
    };
    Order.prototype.getAddOnIds = function (parentSelector) {
        var selectedAddOnIds = [];
        if (typeof parentSelector == "undefined") {
            parentSelector = "";
        }
        $(parentSelector + " select.AddOn").each(function () {
            selectedAddOnIds.push($(this).val());
        });
        $(parentSelector + " input.AddOn:checked").each(function () {
            selectedAddOnIds.push($(this).val());
        });
        $(parentSelector + ".AddOnValues").each(function () {
            var optional = $(this).data("isoptional");
            var displayType = $(this).data("addondisplaytype");
            if ((displayType == "TextBox" && optional == "False") ||
                (displayType == "TextBox" && optional == "True" && $(this).val() != "")) {
                selectedAddOnIds.push($(this).data("addonvalueid"));
            }
        });
        return (selectedAddOnIds.join());
    };
    Order.prototype.HideLoader = function () {
        $("#loading-div-background").hide();
        this.ToggleFreeShipping();
    };
    Order.prototype.AddToCartSuccessCallBack = function (data) {
        Order.prototype.CloseAddToCartUp();
        OneClick = false;
        var orderId = Order.prototype.GetOrderId();
        if (data.success) {
            if (orderId > 0) {
                $("#orderLineItems").html(data.html);
            }
            else {
                $("#divShoppingCart").html(data.html);
            }
            var userId = Order.prototype.GetUserId();
            var portalId = Order.prototype.GetPortalId();
            //Calculate the shopping cart          
            Order.prototype.CalculateShoppingCart(userId, portalId, orderId);
            Order.prototype.ClearShippingEstimates();
        }
    };
    Order.prototype.SetShoppingCartDetails = function () {
        var orderId = Order.prototype.GetOrderId();
        var userId = Order.prototype.GetUserId();
        var portalId = Order.prototype.GetPortalId();
        var isQuote = Order.prototype.IsQuote();
        Order.prototype.GetPublishProductsList();
        if (userId > 0) {
            try {
                Endpoint.prototype.GetShoppingCart(userId, portalId, orderId, isQuote, function (response) {
                    if (response.html.length > 0) {
                        if (orderId > 0) {
                            $("#orderLineItems").html(response.html);
                        }
                        else {
                            $("#divShoppingCart").html(response.html);
                            Order.prototype.ReorderValidateCart();
                        }
                        Order.prototype.CalculateShoppingCart(userId, portalId, orderId);
                        if (orderId > 0) {
                            Order.prototype.GetShippingEstimates();
                            Order.prototype.EnableDisableShippingOptions();
                        }
                        else {
                            Order.prototype.ClearShippingEstimates();
                        }
                    }
                    else {
                        $("#productMessageBoxContainerId").show();
                    }
                });
            }
            catch (err) {
            }
        }
    };
    Order.prototype.EnableDisableShippingOptions = function () {
        var cartCount = parseInt($("#hdnShoppingCartCount").val());
        if (isNaN(cartCount)) {
            $('#shippingMethodDiv input[name="ShippingId"]').attr('disabled', true);
            $(".dev-custom-shipping").hide();
        }
    };
    Order.prototype.CloseAddToCartUp = function () {
        ZnodeBase.prototype.HideLoader();
        $("#getProductDetail").slideUp().hide();
        $("#getProductDetail").empty();
        ZnodeBase.prototype.RemovePopupOverlay();
    };
    //TO Do Relace paymentType With Payment Type Code
    Order.prototype.ShowPaymentHtml = function (control) {
        var selectionId = "#" + control.id + " option:selected";
        Order.prototype.ShowAndSetPayment(selectionId, false);
        if ($("#OmsOrderId").val() > 0)
            $("#divAdditionalInfo").hide();
    };
    Order.prototype.ShowAndSetPayment = function (selectionId, isFirstTime) {
        var paymentType = $("#ddlPaymentTypes option:selected").attr("id");
        paymentType = this.GetPaymentType(paymentType);
        $("#PaymentSettingId").val($(selectionId).val());
        $("#paypal-button").hide();
        if (paymentType == undefined || paymentType == null || paymentType == "")
            return;
        if (paymentType !== "")
            $('span#valPaymentTypes').text("");
        if (paymentType.toLowerCase() === "credit_card") {
            $("#PurchaseOrderNumber").val("");
            Order.prototype.creditCardPayment(selectionId, isFirstTime);
        }
        else if (paymentType.toLowerCase() == "ach") {
            $('#divAuthorizeNetIFrame').hide();
            $("#PurchaseOrderNumber").val("");
            Order.prototype.ACHAccountPayment(selectionId, isFirstTime);
        }
        else if (paymentType.toLowerCase() == "purchase_order") {
            $('#divAuthorizeNetIFrame').hide();
            $(".HidePaymentTypeDiv").hide();
            $("#paypal-button").hide();
            $("#div-PurchaseOrder").show();
        }
        else if (paymentType.toLowerCase() == "paypal_express") {
            $('#divAuthorizeNetIFrame').hide();
            var isCreditCardEnabled = $("#hdnIsCreditCardEnabled").val();
            if (isCreditCardEnabled == "0" && !isFirstTime) {
                Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorOrderOverDueAmount"));
                return false;
            }
            $("#PurchaseOrderNumber").val("");
            $(".HidePaymentTypeDiv").hide();
            $("#paypal-button").show();
        }
        else if (paymentType.toLowerCase() == "cod") {
            $('#divAuthorizeNetIFrame').hide();
            $("#PurchaseOrderNumber").val("");
            $(".HidePaymentTypeDiv").hide();
            $("#div-COD").show();
            $("#paypal-button").hide();
        }
        else {
            $('#divAuthorizeNetIFrame').hide();
            $("#PurchaseOrderNumber").val("");
            $(".HidePaymentTypeDiv").hide();
            $("#paypal-button").hide();
        }
        Order.prototype.ClearCreditCartDetails();
    };
    Order.prototype.OnAttributeSelect = function (control) {
        var productId = $("#dynamic-parentproductId").val();
        var catalogId = $("#dynamic-catalogId").val();
        var sku = $("#dynamic-configurableProductSKUs").val();
        var ParentProductSKU = $("#dynamic-sku").val();
        var Codes = [];
        var Values = [];
        var selectedCode = $(control).attr('code');
        var selectedValue = $(control).val();
        $("select.ConfigurableAttribute").each(function () {
            Values.push($(this).val());
            Codes.push($(this).attr('id'));
        });
        $(" input.ConfigurableAttribute:checked").each(function () {
            Values.push($(this).val());
            Codes.push($(this).attr('code'));
        });
        var parameters = {
            "SelectedCode": selectedCode,
            "SelectedValue": selectedValue,
            "SKU": sku,
            "Codes": Codes.join(),
            "Values": Values.join(),
            "ParentProductId": productId,
            "ParentProductSKU": ParentProductSKU,
            "IsQuickView": $("#isQuickView").val(),
            "UserId": $("#hdnUserId").val(),
            "PortalId": Order.prototype.GetPortalId(),
            "PublishCatalogId": catalogId,
            "LocaleId": $("#LocaleId").val()
        };
        Endpoint.prototype.GetProduct(parameters, function (res) {
            $("#getProductDetail").html(res);
        });
    };
    Order.prototype.ReviewOrder = function () {
        ZnodeBase.prototype.ShowLoader();
        var selectedPayment = $("#ddlPaymentTypes option:selected");
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
                $("#orderNotes").html($("#additionalInstructions").val());
                $("#inHandDates").html($("#InHandDate").val());
                $("#spnPurchaseOrderNumber").html($("#PurchaseOrderNumber").val());
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
    };
    Order.prototype.SetCreditCardValidations = function () {
        $('input[data-payment="exp-month"]').on("keypress", function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                return false;
            }
        });
        $('input[data-payment="exp-year"]').on("keypress", function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                return false;
            }
        });
        $("input[data-payment='exp-month']").on("focusout", function (e) {
            Order.prototype.ValidateCreditCardExpirationDetails();
        });
        $("input[data-payment='exp-year']").on("focusout", function (e) {
            Order.prototype.ValidateCreditCardExpirationDetails();
        });
        $("input[data-payment='exp-month']").on("paste", function (e) {
            Order.prototype.ValidateCreditCardExpirationDetails();
        });
        $("input[data-payment='exp-year']").on("paste", function (e) {
            Order.prototype.ValidateCreditCardExpirationDetails();
        });
        $('input[data-payment="cvc"]').on("keypress", function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                return false;
            }
        });
    };
    Order.prototype.CanclePayment = function () {
        Order.prototype.HidePaymentProcessDialog();
        $("#ajaxBusy").dialog('close');
        $("#div-CreditCard").hide();
        $("#div-CreditCard [data-payment='number']").val('');
        $("#div-CreditCard [data-payment='cvc']").val('');
        $("#div-CreditCard [data-payment='exp-month']").val('');
        $("#div-CreditCard [data-payment='exp-year']").val('');
        $("#div-CreditCard [data-payment='cardholderName']").val('');
        $("#ddlPaymentTypes").val('');
        $("#ddlPaymentTypes option").each(function () {
            if ($(this).html() == "Select Payment") {
                $(this).attr("selected", "selected");
                return;
            }
        });
    };
    Order.prototype.GetPaymentDetails = function (paymentSettingId) {
        Endpoint.prototype.GetPaymentDetails(paymentSettingId, $("#hdnUserId").val(), function (response) {
            if (!response.HasError) {
                $("#hdnPaymentCode").val(response.PaymentCode);
                $("#hdnGatewayCode").val(response.GatewayCode);
                $("#paymentProfileId").val(response.PaymentProfileId);
                $("#hdnEncryptedTotalAmount").val(response.Total);
                $("#hdnIsCreditCardEnabled").val(response.IsCreditCardEnabled);
            }
        });
    };
    Order.prototype.GetEncryptedAmount = function (total) {
        Endpoint.prototype.GetEncryptedAmountByAmount(total, function (response) {
            if (response != undefined && response.data != undefined) {
                $("#hdnEncryptedTotalAmount").val(response.data);
            }
        });
    };
    Order.prototype.ClearPaymentAndDisplayMessage = function (message) {
        Order.prototype.CanclePayment();
        Order.prototype.ClickSelectedTab("payment-tab-link");
        Order.prototype.DisableReviewTab();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(message, "error", isFadeOut, fadeOutTime);
    };
    Order.prototype.creditCardPayment = function (selectionId, isFirstTime) {
        $("#div-ACHAccount").hide();
        $(".HidePaymentTypeDiv").hide();
        $("#div-CreditCard input:password").val("");
        //$("#div-CreditCard input:text").val("");
        $("#SaveCreditCard").prop("checked", false);
        $("#PaymentSettingId").val($(selectionId).val());
        $("#hdnGatewayCode").val('');
        $("#hdnEncryptedTotalAmount").val('');
        Order.prototype.GetPaymentDetails($(selectionId).val());
        var paymentGatwayCode = $("#hdnGatewayCode").val().toLowerCase();
        if ($("#hdnGatewayCode").val() != undefined && $("#hdnGatewayCode").val().length > 0) {
            var gatewayCode = $("#hdnGatewayCode").val();
            var isCreditCardEnabled = $("#hdnIsCreditCardEnabled").val();
            if (isCreditCardEnabled == "0" && !isFirstTime) {
                Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorOrderOverDueAmount"));
                return false;
            }
            var profileId = null;
            if ($("#paymentProfileId").val().length > 0) {
                profileId = $("#paymentProfileId").val();
            }
            var paymentCreditCardModel = {
                gateway: gatewayCode,
                profileId: profileId,
                paymentCode: $('#hdnPaymentCode').val(),
                customerGUID: $("#hdnCustomerGUID").val(),
                publishStateId: $("#hdnPublishStateId").val()
            };
            $.ajax({
                type: "POST",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", $("#hdnPaymentApiRequestHeader").val());
                },
                url: Config.PaymentScriptUrl,
                data: paymentCreditCardModel,
                success: function (response) {
                    $("#div-CreditCard").show();
                    $("#manageOrderPayButton").show();
                    $("#manageQuotePayButton").show();
                    $("#btnPlaceOrder").show();
                    if (paymentGatwayCode == "cardconnect") {
                        $("#divCardconnect").show();
                        $("#creditCard").hide();
                        $("#divCyberSource").hide();
                        $('#paymentProviders').show();
                        $('#divAuthorizeNetIFrame').hide();
                    }
                    else if (paymentGatwayCode == Constant.CyberSource) {
                        $("#divCyberSource").show();
                        $("#creditCard").hide();
                        $("#divCardconnect").hide();
                        $('#divAuthorizeNetIFrame').hide();
                        $('#paymentProviders').hide();
                        Order.prototype.CreditCardPaymentCyberSource(selectionId);
                    }
                    else if (paymentGatwayCode == "authorizenet") {
                        $('#paymentProviders').hide();
                        $("#divCyberSource").hide();
                        $("#divCardconnect").hide();
                        $('#divAuthorizeNetIFrame').show();
                        $("#creditCard").hide();
                        $("#manageOrderPayButton").hide();
                        $("#manageQuotePayButton").hide();
                        $("#btnPlaceOrder").hide();
                        Order.prototype.AuthorizeNetPayment(selectionId);
                    }
                    else {
                        $("#divCardconnect").hide();
                        $("#creditCard").show();
                        $('#divAuthorizeNetIFrame').hide();
                        $("#divCyberSource").hide();
                    }
                    Order.prototype.AppendResponseToHTML(response);
                    Order.prototype.SetCreditCardValidations();
                    if ($("#hdnAnonymousUser").val() == "true" || gatewayCode.toLowerCase() == "payflow") {
                        $("#Save-credit-card").hide();
                    }
                    else {
                        $("#Save-credit-card").show();
                    }
                    //Include the CSS required
                    if ($("#hdnGatewayCode").val() == "cardconnect") {
                        $("#iframebody").attr("src", iframeUrl + "&css=" + encodeURIComponent(Order.prototype.GetCardConnectIframeCSS()));
                    }
                    if (enabledPaymentProviders != '') {
                        var payProvidersHtml = '';
                        var toSplittedPayProviders = enabledPaymentProviders.split(",");
                        for (var iPayProviders = 0; iPayProviders < toSplittedPayProviders.length; iPayProviders++) {
                            payProvidersHtml += "<div class='col-xs-12 col-sm-3 nopadding save-cart'><input id=radioPaymentProviders" + iPayProviders + " type=radio name=PaymentProviders value=" + toSplittedPayProviders[iPayProviders] + " /><label class='lbl padding-8' for=radioPaymentProviders" + iPayProviders + "><img src=../../Content/images/" + toSplittedPayProviders[iPayProviders] + ".png class='img-responsive' style='float:right;' /></label></div>";
                        }
                        $('#paymentProviders').html("<ul>" + payProvidersHtml + "</ul>");
                        $("#" + $('input[name="PaymentProviders"]')[0].id).prop("checked", true);
                    }
                    if (savedUserCCDetails != '') {
                        $('#radioCCList').show();
                        $('#radioCCList').html('');
                        var iCCOrder = 0;
                        var creditCardHtml = "";
                        if (paymentGatwayCode != Constant.CyberSource) {
                            $.each(JSON.parse(savedUserCCDetails), function () {
                                creditCardHtml += "<div class='col-sm-12 nopadding'><label><input onclick=Order.prototype.OnSavedCreditCardClick(" + this['CreditCardLastFourDigit'].split(" ")[3] + "); id=radioSavedCreditCard" + iCCOrder + " type=radio name=CCListdetails value=" + this['PaymentGUID'] + " /><span class='lbl padding-8' for=radioSavedCreditCard" + iCCOrder + ">" + this['CreditCardLastFourDigit'] + "</span></label></div>";
                                iCCOrder++;
                            });
                        }
                        else {
                            $.each(JSON.parse(savedUserCCDetails), function () {
                                creditCardHtml += "<div class='col-sm-12 nopadding'><label><input onclick=Order.prototype.OnSavedCreditCardClickCyberSource(" + this['CreditCardLastFourDigit'].split(" ")[3] + "," + "'" + this['PaymentGUID'] + "'" + "); id=radioSavedCreditCard" + iCCOrder + " type=radio name=CCListdetails value=" + this['PaymentGUID'] + " /><span class='lbl padding-8' for=radioSavedCreditCard" + iCCOrder + ">" + this['CreditCardLastFourDigit'] + "</span></label></div>";
                                iCCOrder++;
                            });
                        }
                        $('#radioCCList').append("<div class='col-sm-12 nopadding'>" + creditCardHtml + "</div>");
                        Order.prototype.ToggleCreditCardTab(true);
                        var savedCCRadio = $("#radioSavedCreditCard0");
                        if (savedCCRadio.length > 0) {
                            savedCCRadio.prop('checked', 'true');
                            var cardData = JSON.parse(savedUserCCDetails)[0];
                            if (cardData.CardType == Constant.AmericanExpressCardCode)
                                savedCCRadio.parent().append(Order.prototype.GetCVVHtmlForAmericanExpress(cardData.CardType));
                            else
                                savedCCRadio.parent().append(Order.prototype.GetCVVHtml(cardData.CardType));
                            savedCCRadio.click();
                        }
                        Order.prototype.BindEvent();
                    }
                    else {
                        Order.prototype.ToggleCreditCardTab(false);
                        Order.prototype.RestrictCopyPasteEvent();
                    }
                    $("#div-CreditCard").show();
                    $("#divOrderSavePage").hide();
                    $("#div-CreditCard [data-payment='number']").focus();
                    return false;
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorContactPaymentApp"));
                    $('.quote-getquotedetails #paymentStatusPanel').hide();
                    return false;
                }
            });
        }
        else {
            Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorPaymentGateway"));
            return false;
        }
        return false;
    };
    Order.prototype.ACHAccountPayment = function (selectionId, isFirstTime) {
        $("#div-CreditCard").hide();
        $(".HidePaymentTypeDiv").hide();
        $("#PaymentSettingId").val($(selectionId).val());
        $("#hdnGatewayCode").val('');
        $("#hdnEncryptedTotalAmount").val('');
        Order.prototype.GetPaymentDetails($(selectionId).val());
        var paymentGatwayCode = $("#hdnGatewayCode").val().toLowerCase();
        if ($("#hdnGatewayCode").val() != undefined && $("#hdnGatewayCode").val().length > 0) {
            var gatewayCode = $("#hdnGatewayCode").val();
            var profileId = null;
            if ($("#paymentProfileId").val().length > 0) {
                profileId = $("#paymentProfileId").val();
            }
            var paymentCreditCardModel = {
                gateway: gatewayCode,
                profileId: profileId,
                paymentCode: $('#hdnPaymentCode').val(),
                customerGUID: $("#hdnCustomerGUID").val(),
                publishStateId: $("#hdnPublishStateId").val()
            };
            $.ajax({
                type: "POST",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", $("#hdnPaymentApiRequestHeader").val());
                },
                url: Config.PaymentScriptUrlForACH,
                data: paymentCreditCardModel,
                success: function (response) {
                    $("#div-ACHAccount").show();
                    $("#div-CreditCard").hide();
                    Order.prototype.AppendResponseToHTML(response);
                    if ($("#hdnAnonymousUser").val() == "true" || gatewayCode.toLowerCase() == "payflow") {
                        $("#Save-ach-card").hide();
                    }
                    else {
                        $("#Save-ach-card").show();
                    }
                    //Include the CSS required
                    if ($("#hdnGatewayCode").val() == "cardconnect") {
                        $("#iframebodyACH").attr("src", iframeUrl + "&css=" + encodeURIComponent(Order.prototype.GetCardConnectIframeCSS()));
                    }
                    if (savedUserACHAccountDetails != '') {
                        $('#radioACHList').show();
                        $('#radioACHList').html('');
                        var iCCOrder = 0;
                        var creditCardHtml = "";
                        $.each(JSON.parse(savedUserACHAccountDetails), function () {
                            creditCardHtml += "<div class='col-sm-12 nopadding'><label><input onclick=Order.prototype.OnSavedAchAccountClick(" + this['CreditCardLastFourDigit'].split(" ")[3] + "); id=radioSavedCreditCard" + iCCOrder + " type=radio name=CCListdetails value=" + this['PaymentGUID'] + " /><span class='lbl padding-8' for=radioSavedCreditCard" + iCCOrder + ">" + this['CreditCardLastFourDigit'] + "</span></label></div>";
                            iCCOrder++;
                        });
                        $('#radioACHList').append("<div class='col-sm-12 nopadding'>" + creditCardHtml + "</div>");
                        Order.prototype.ToggleACHAccountTab(true);
                        var savedACHRadio = $("#radioSavedCreditCard0");
                        if (savedACHRadio.length > 0) {
                            savedACHRadio.prop('checked', 'true');
                            savedACHRadio.click();
                        }
                        Order.prototype.BindEvent();
                    }
                    else {
                        Order.prototype.ToggleACHAccountTab(false);
                        Order.prototype.RestrictCopyPasteEvent();
                    }
                    $("#div-ACHAccount").show();
                    $("#divOrderSavePage").hide();
                    return false;
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorContactPaymentApp"));
                    return false;
                }
            });
        }
        else {
            Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorPaymentGateway"));
            return false;
        }
        return false;
    };
    Order.prototype.OnSavedAchAccountClick = function (cardNo) {
        $("#hdnCreditCardNumber").val(cardNo);
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvv"]');
    };
    Order.prototype.GetCardConnectIframeCSS = function () {
        return "input{width:100%;max-width:280px;height:32px;border:1px solid #969EA4;border-radius:3px;border-width:thin; outline: medium none; padding: 0 8px;margin-bottom: 10px;margin-top: 5px;}select{width: 70px;height: 32px;border: 1px solid #969EA4;border-radius: 3px;border-width: thin; outline: medium none;padding: 0 8px;margin-bottom: 10px;margin-top: 5px;}#cccvvfield{width:70px}label{font-weight: bold; font-size: 14px;color: #2A2C2E;font-family: 'Roboto-Regular', segoeui, HelveticaNeueLTStd Lt, Arial, sans-serif;}";
    };
    Order.prototype.GetACHCardConnectIframeCSS = function () {
        return "input{width:100%;max-width:280px;height:34px;border:1px solid #9E9E9E;border-radius:2px;border-width:thin; outline: medium none;background-color:#FAFAFA; padding: 0 8px;margin-bottom: 10px;margin-top: 5px;}select{width: 70px;height: 34px;border: 1px solid #9E9E9E;border-radius: 2px;border-width: thin; outline: medium none;background-color: #FAFAFA;padding: 0 8px;margin-bottom: 10px;margin-top: 5px;}#cccvvfield{width:70px}label{font-weight: bold; font-size: 14px;color: #454545;font-family: Roboto-Regular,Arial,Sans-serif;}";
    };
    Order.prototype.Getiframe = function () {
        setTimeout(function () {
            $('#iframebody').show();
        }, 300);
    };
    Order.prototype.GetiframeACH = function () {
        setTimeout(function () {
            $('#iframebodyACH').show();
        }, 300);
    };
    Order.prototype.CardConnectPayment = function (token) {
        $('#CardDataToken').val(token.message);
        $('#CardExpirationDate').val(token.expiry);
        $("#ErrorMessage").val(token.validationError);
    };
    Order.prototype.BindEvent = function () {
        $("#radioCCList input[type='radio']").on("change", Order.prototype.AppendCVVHtml);
        //restrict inputs
        $(document).on("keypress", 'input[data-payment="cvv"]', function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                return false;
            }
        });
        //restrict cut-copy-paste
        Order.prototype.RestrictCopyPasteEvent();
    };
    Order.prototype.RestrictCopyPasteEvent = function () {
        //restrict cut-copy-paste
        $('input[data-payment="cvv"]').add('input[data-payment="cvc"]').on("cut copy paste", function (e) {
            e.preventDefault();
        });
    };
    Order.prototype.ToggleCreditCardTab = function (show) {
        $('#credit-card-div').show();
        if (show) {
            jQuery('#creditCardTab').show();
            jQuery('#savedCreditCard-panel').addClass('active in');
            jQuery('#addNewCreditCard-panel').removeClass('active in');
            $("#creditCardTab li:eq(0)").first().addClass('active');
            $("#creditCardTab li:eq(1)").first().removeClass('active');
            $('#divAddNewCCDetails').show();
        }
        else {
            jQuery('#creditCardTab').hide();
            jQuery('#savedCreditCard-panel').removeClass('active in');
            jQuery('#addNewCreditCard-panel').addClass('active in');
            $("#creditCardTab li:eq(0)").first().removeClass('active');
            $("#creditCardTab li:eq(1)").first().addClass('active');
            $('#divAddNewCCDetails').hide();
        }
    };
    Order.prototype.ToggleACHAccountTab = function (show) {
        $('#ach-account-div').show();
        if (show) {
            jQuery('#ACHAccountTab').show();
            jQuery('#savedACHAccount-panel').addClass('active in');
            jQuery('#addNewACHAccount-panel').removeClass('active in');
            $("#ACHAccountTab li:eq(0)").first().addClass('active');
            $("#ACHAccountTab li:eq(1)").first().removeClass('active');
            $('#divAddNewCCDetails').show();
        }
        else {
            jQuery('#ACHAccountTab').hide();
            jQuery('#savedACHAccount-panel').removeClass('active in');
            jQuery('#addNewACHAccount-panel').addClass('active in');
            $("#ACHAccountTab li:eq(0)").first().removeClass('active');
            $("#ACHAccountTab li:eq(1)").first().addClass('active');
            $('#divAddNewCCDetails').hide();
        }
    };
    //Append CVV Code HTML
    Order.prototype.AppendCVVHtml = function (event) {
        var currentElement = event.currentTarget;
        var cardtype = "";
        var cardData = JSON.parse(savedUserCCDetails);
        $.each(cardData, function (element, value) {
            if (currentElement.value == value["PaymentGUID"])
                cardtype = value["CardType"];
        });
        $('.error-cvv').hide();
        $('[name=SaveCard-CVV]').hide();
        if ($(currentElement).parent().find('[name=SaveCard-CVV]').length > 0) {
            $(currentElement).parent().find('[name=SaveCard-CVV]').show();
        }
        else {
            if (cardtype == Constant.AmericanExpressCardCode)
                $(currentElement).parent().append(Order.prototype.GetCVVHtmlForAmericanExpress(cardtype));
            else
                $(currentElement).parent().append(Order.prototype.GetCVVHtml(cardtype));
        }
    };
    //Get CVV Code HTML
    Order.prototype.GetCVVHtml = function (cardtype) {
        if (cardtype === void 0) { cardtype = ""; }
        return "<input class='form-control' id='CredidCardCVCNumberSaved' name='SaveCard-CVV' data-cardtype=" + cardtype + " data-payment='cvv' type='password' placeholder='Enter CVV' maxlength='3'  style='width:25%;margin-left:2%;'/>";
    };
    //Get CVV Code HTML
    Order.prototype.GetCVVHtmlForAmericanExpress = function (cardtype) {
        if (cardtype === void 0) { cardtype = ""; }
        return "<input class='form-control' id='CredidCardCVCNumberSaved' name='SaveCard-CVV' data-cardtype=" + cardtype + " data-payment='cvv' type='password'  placeholder='Enter CVV' maxlength='4'  style='width:25%;margin-left:2%;'/>";
    };
    Order.prototype.AppendResponseToHTML = function (response) {
        $("#div_payment_option script").remove();
        //if script element is already present then add html to response
        if ($("#div_payment_option").find("script").length > 0) {
            $("#div_payment_option").find("script").html(response);
            return;
        }
        //Append header inside script
        PaymentauthHeader = $("#hdnPaymentApiRequestHeader").val();
        $("#div_payment_option").append("<script>" + response + "</script>");
    };
    Order.prototype.OnSavedCreditCardClick = function (cardNo) {
        $("#hdnCreditCardNumber").val(cardNo);
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvv"]');
    };
    Order.prototype.OnSavedCreditCardClickCyberSource = function (cardNo, PaymentGUID) {
        $("#hdnCreditCardNumber").val(cardNo);
        $("#hdnPaymentGUID").val(PaymentGUID);
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvv"]');
    };
    Order.prototype.IsOrderTotalGreaterThanZero = function (total) {
        if (total > 0.00) {
            return true;
        }
        else {
            Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorZeorOrderTotal"));
        }
    };
    Order.prototype.Mod10 = function (ccNum) {
        ccNum = ccNum.replace(/ /g, '');
        var valid = "0123456789"; // Valid digits in a credit card number
        var len = ccNum.length; // The length of the submitted cc number
        var iCCN = parseInt(ccNum); // integer of ccNum
        var sCCN = ccNum.toString(); // string of ccNum
        sCCN = sCCN.replace(/^\s+|\s+$/g, ''); // strip spaces
        var iTotal = 0; // integer total set at zero
        var bNum = true; // by default assume it is a number
        var bResult = false; // by default assume it is NOT a valid cc
        var temp; // temp variable for parsing string
        var calc; // used for calculation of each digit
        // Determine if the ccNum is in fact all numbers
        for (var j = 0; j < len; j++) {
            temp = "" + sCCN.substring(j, j + 1);
            if (valid.indexOf(temp) == -1) {
                bNum = false;
            }
        }
        // ccNum is a number and the proper length - let's see if it is a valid card number
        if (len >= 15) { // 15 or 16 for Amex or V/MC
            for (var i = len; i > 0; i--) { // LOOP throught the digits of the card
                calc = Math.floor(iCCN) % 10; // right most digit
                calc = Math.floor(parseInt(calc)); // assure it is an integer
                iTotal += calc; // running total of the card number as we loop - Do Nothing to first digit
                i--; // decrement the count - move to the next digit in the card
                iCCN = iCCN / 10; // subtracts right most digit from ccNum
                calc = Math.floor(iCCN) % 10; // NEXT right most digit
                calc = calc * 2; // multiply the digit by two
                // Instead of some screwy method of converting 16 to a string and then parsing 1 and 6 and then adding them to make 7,
                // I use a simple switch statement to change the value of calc2 to 7 if 16 is the multiple.
                switch (calc) {
                    case 10:
                        calc = 1;
                        break; //5*2=10 & 1+0 = 1
                    case 12:
                        calc = 3;
                        break; //6*2=12 & 1+2 = 3
                    case 14:
                        calc = 5;
                        break; //7*2=14 & 1+4 = 5
                    case 16:
                        calc = 7;
                        break; //8*2=16 & 1+6 = 7
                    case 18:
                        calc = 9;
                        break; //9*2=18 & 1+8 = 9
                    default: calc = calc; //4*2= 8 &   8 = 8  -same for all lower numbers
                }
                iCCN = iCCN / 10; // subtracts right most digit from ccNum
                iTotal += calc; // running total of the card number as we loop
            } // END OF LOOP
            if ((iTotal % 10) == 0) { // check to see if the sum Mod 10 is zero
                bResult = true; // This IS (or could be) a valid credit card number.
            }
            else {
                bResult = false; // This could NOT be a valid credit card number
            }
        }
        return bResult; // Return the results
    };
    Order.prototype.DetectCardType = function (number) {
        var re = {
            electron: /^(4026|417500|4405|4508|4844|4913|4917)\d+$/,
            maestro: /^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\d+$/,
            dankort: /^(5019)\d+$/,
            interpayment: /^(636)\d+$/,
            unionpay: /^(62|88)\d+$/,
            visa: /^4[0-9]{12}(?:[0-9]{3})?$/,
            mastercard: /^5[1-5]\d{14}$|^2(?:2(?:2[1-9]|[3-9]\d)|[3-6]\d\d|7(?:[01]\d|20))\d{12}$/,
            amex: /^3[47][0-9]{13}$/,
            diners: /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
            discover: /^6(?:011|5[0-9]{2})[0-9]{12}$/,
            jcb: /^(?:2131|1800|35\d{3})\d{11}$/
        };
        if (re.electron.test(number)) {
            return 'ELECTRON';
        }
        else if (re.maestro.test(number)) {
            return 'MAESTRO';
        }
        else if (re.dankort.test(number)) {
            return 'DANKORT';
        }
        else if (re.interpayment.test(number)) {
            return 'INTERPAYMENT';
        }
        else if (re.unionpay.test(number)) {
            return 'UNIONPAY';
        }
        else if (re.visa.test(number)) {
            return 'VISA';
        }
        else if (re.mastercard.test(number)) {
            return 'MASTERCARD';
        }
        else if (re.amex.test(number)) {
            return 'AMEX';
        }
        else if (re.diners.test(number)) {
            return 'DINERS';
        }
        else if (re.discover.test(number)) {
            return 'DISCOVER';
        }
        else if (re.jcb.test(number)) {
            return 'JCB';
        }
        else {
            return undefined;
        }
    };
    Order.prototype.SubmitPayment = function () {
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            var payment = Order.prototype.GetPaymentModel();
            var cardType = $("#hdnGatewayCode").val() == "cardconnect" ? Order.prototype.DetectCardTypeForCardConnect($('#CardDataToken').val()) : Order.prototype.DetectCardType(Order.prototype.GetCreditCardNumber());
            var paymentDetails = {
                "CardType": cardType,
                "CardExpirationMonth": $("#div-CreditCard [data-payment='exp-month']").val(),
                "CardExpirationYear": $("#div-CreditCard [data-payment='exp-year']").val()
            };
            $("#div-CreditCard").hide();
            submitCard(payment, function (response) {
                var orderNumber = "";
                Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) { orderNumber = response.orderNumber; });
                if (response.GatewayResponse == undefined) {
                    if (response.indexOf("Unauthorized") > 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage('We were unable to process your credit card payment. <br /><br />Reason:<br />' + response + '<br /><br />If the problem persists, contact us to complete your order.');
                    }
                }
                else {
                    var isSuccess = response.GatewayResponse.IsSuccess;
                    if (isSuccess) {
                        var submitPaymentViewModel = {
                            PaymentSettingId: $('#PaymentSettingId').val(),
                            PaymentCode: $('#hdnPaymentCode').val(),
                            CustomerProfileId: response.GatewayResponse.CustomerProfileId,
                            CustomerPaymentId: response.GatewayResponse.CustomerPaymentProfileId,
                            CustomerShippingAddressId: response.GatewayResponse.CustomerShippingAddressId,
                            CustomerGuid: response.GatewayResponse.CustomerGUID,
                            PaymentToken: $("input[name='CCdetails']:checked").val(),
                            UserId: $("#hdnUserId").val(),
                            ShippingOptionId: $("[name='ShippingId']").val(),
                            BillingAddressId: $("#UserAddressDataViewModel_BillingAddress_AddressId").val(),
                            ShippingAddressId: $("#UserAddressDataViewModel_ShippingAddress_AddressId").val(),
                            CardSecurityCode: $("#div-CreditCard [data-payment='cvc']").val(),
                            PortalId: Order.prototype.GetPortalId(),
                            PortalCatalogId: $("#PortalCatalogId").val(),
                            AdditionalInfo: $("#additionalInstructions").val(),
                            EnableAddressValidation: $("input[name='EnableAddressValidation']").val(),
                            RequireValidatedAddress: $("input[name='RequireValidatedAddress']").val(),
                            CreditCardNumber: $("#hdnGatewayCode").val() == "cardconnect" ? $('#CardDataToken').val().slice(-4) : $("#hdnCreditCardNumber").val(),
                            AccountNumber: $("#ShippingListViewModel_AccountNumber").val(),
                            ShippingMethod: $("#ShippingListViewModel_ShippingMethod").val(),
                            CardType: cardType,
                            OrderNumber: orderNumber,
                            CardDataToken: $('#CardDataToken').val(),
                            CardExpirationDate: $("#CardExpirationDate").val(),
                            CardExpiration: paymentDetails.CardExpirationMonth + "-" + paymentDetails.CardExpirationYear,
                            InHandDate: $("#InHandDate").val(),
                            JobName: $("#JobName").val(),
                            ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val()
                        };
                        submitPaymentViewModel["CardSecurityCode"] = submitPaymentViewModel["PaymentToken"] ? $("[name='SaveCard-CVV']:visible").val() : $("#div-CreditCard [data-payment='cvc']").val();
                        $.ajax({
                            type: "POST",
                            url: "/order/submitpayment",
                            data: submitPaymentViewModel,
                            success: function (response) {
                                if (response.Data.OrderId !== undefined && response.Data.OrderId > 0) {
                                    $("#ajaxBusy").dialog('close');
                                    var form = $('<form action="CheckoutReceipt" method="post">' +
                                        '<input type="hidden" name="orderId" value="' + response.Data.OrderId + '" />' +
                                        '<input type="text" name= "ReceiptHtml" value= "' + response.Data.ReceiptHtml + '" />' +
                                        '<input type="hidden" name= "IsEmailSend" value= ' + response.Data.IsEmailSend + ' />' +
                                        '</form>');
                                    $('body').append(form);
                                    $(form).submit();
                                }
                                else {
                                    $("#ajaxBusy").dialog('close');
                                    var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                                    Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                                    return false;
                                }
                            },
                            error: function () {
                                Order.prototype.ClearPaymentAndDisplayMessage("Failed to process order");
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
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    Order.prototype.SubmitAuthorizeEditOrderPayment = function (querystr) {
        var transactionResponse = JSON.parse(querystr);
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            $("#div-CreditCard").hide();
            var submitPaymentViewModel = {
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
                InHandDate: $("#InHandDate").val(),
                JobName: $("#JobName").val(),
                ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val(),
                TransactionId: transactionResponse.transId,
                OmsOrderId: Order.prototype.GetOrderId,
                PaymentApplicationSettingId: $('#hdnPaymentApplicationSettingId').val(),
                OrderNumber: $("#hdnOrderNumber").val(),
                CreditCardNumber: (transactionResponse.accountNumber).slice(-4),
                IsSaveCreditCard: $("#SaveCreditCard").is(':checked')
            };
            Endpoint.prototype.SubmitEditOrderpayment(submitPaymentViewModel, function (response) {
                $("#ajaxBusy").dialog('close');
                if (response === undefined || response.Data === undefined || response.Data.OrderId === undefined || response.Data.OrderId <= 0 || response.Data.HasError == true) {
                    var errorMessage = response.Data == undefined || response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                    Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                    return false;
                }
                else {
                    location.reload(true);
                }
            });
        }
    };
    Order.prototype.SubmitAuthorizeNetPayment = function (querystr) {
        var Total = $("#hdnTotalAmt").val();
        var transactionResponse = JSON.parse(querystr);
        var orderNumber = $("#OrderNumber").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            $("#div-CreditCard").hide();
            var submitPaymentViewModel = {
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
                InHandDate: $("#InHandDate").val(),
                JobName: $("#JobName").val(),
                ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val(),
                TransactionId: transactionResponse.transId,
                IsSaveCreditCard: $("#SaveCreditCard").is(':checked'),
                CreditCardNumber: (transactionResponse.accountNumber).slice(-4),
                CustomerProfileId: $('#CustomerProfileId').val(),
                CustomerPaymentProfileId: $('#CustomerPaymentProfileId').val(),
                OrderNumber: orderNumber,
                GatewayCode: $("#hdnGatewayCode").val()
            };
            $.ajax({
                type: "POST",
                url: "/order/submitpayment",
                data: submitPaymentViewModel,
                success: function (response) {
                    if (response.Data.OrderId !== undefined && response.Data.OrderId > 0) {
                        $("#ajaxBusy").dialog('close');
                        var form = $('<form action="CheckoutReceipt" method="post">' +
                            '<input type="hidden" name="orderId" value="' + response.Data.OrderId + '" />' +
                            '<input type="text" name= "ReceiptHtml" value= "' + response.Data.ReceiptHtml + '" />' +
                            '<input type="hidden" name= "IsEmailSend" value= ' + response.Data.IsEmailSend + ' />' +
                            '</form>');
                        $('body').append(form);
                        $(form).submit();
                    }
                    else {
                        $("#ajaxBusy").dialog('close');
                        var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                        return false;
                    }
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage("Failed to process order");
                }
            });
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    Order.prototype.AuthorizeNetPayment = function (controlId) {
        var urlhost = document.location.origin;
        var iFrameUrl = urlhost + "/Order/AuthorizeIframeCommunicator";
        var orderNumber = $("#OrderNumber").val();
        if (orderNumber == undefined) {
            Endpoint.prototype.GenerateOrderNumber(parseInt($("#hdnPortalId").val()), function (response) {
                orderNumber = response.orderNumber;
            });
        }
        var paymentTokenModel = {
            PaymentSettingId: parseInt($('#PaymentSettingId').val()),
            PaymentCode: $("#hdnPaymentCode").val(),
            Total: (($("#OmsQuoteId").val()) > 0) ? $("#hdnTotalQuoteAmount").val() : $("#hdnTotalOrderAmount").val(),
            IFrameUrl: iFrameUrl,
            CustomerProfileId: $('#CustomerProfileId').val(),
            CustomerGUID: $("#hdnCustomerGUID").val(),
            GatewayCode: $("#hdnGatewayCode").val(),
            UserId: $("#hdnUserId").val(),
            OrderNumber: orderNumber,
            IsAdminRequestUrl: true
        };
        Endpoint.prototype.GetAuthorizeNetToken(paymentTokenModel, function (response) {
            $("#divAuthorizeNetIFrame").show();
            if (response.customerProfileId != '' && response.customerProfileId != undefined) {
                $("#Save-credit-card").hide();
            }
            $("#divAuthorizeNetIFrame").html(response.html);
            ZnodeBase.prototype.HideLoader();
        });
    };
    Order.prototype.SubmitCyberSourcePayment = function (querystr) {
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            $("#div-CreditCard").hide();
            var orderNumber = "";
            Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) {
                orderNumber = response.orderNumber;
            });
            var submitPaymentViewModel = {
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
                IsSaveCreditCard: $("#SaveCreditCard").is(':checked'),
                CustomerProfileId: $('#CustomerProfileId').val(),
                CustomerPaymentId: $('#CustomerPaymentProfileId').val(),
                CustomerGuid: $("#hdnCustomerGUID").val(),
                PaymentGUID: $("#hdnPaymentGUID").val(),
                GatewayCode: $("#hdnGatewayCode").val()
            };
            $.ajax({
                type: "POST",
                url: "/order/submitpayment",
                data: submitPaymentViewModel,
                success: function (response) {
                    if (response.Data.OrderId !== undefined && response.Data.OrderId > 0) {
                        $("#ajaxBusy").dialog('close');
                        var form = $('<form action="CheckoutReceipt" method="post">' +
                            '<input type="hidden" name="orderId" value="' + response.Data.OrderId + '" />' +
                            '<input type="text" name= "ReceiptHtml" value= "' + response.Data.ReceiptHtml + '" />' +
                            '<input type="hidden" name= "IsEmailSend" value= ' + response.Data.IsEmailSend + ' />' +
                            '</form>');
                        $('body').append(form);
                        $(form).submit();
                    }
                    else {
                        $("#ajaxBusy").dialog('close');
                        var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                        return false;
                    }
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage("Failed to process order");
                }
            });
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    Order.prototype.SubmitManageOrderPayment = function (querystr) {
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            $("#div-CreditCard").hide();
            var orderNumber = "";
            Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) {
                orderNumber = response.orderNumber;
            });
            var submitPaymentViewModel = {
                OmsOrderId: Order.prototype.GetOrderId,
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
                IsSaveCreditCard: $("#SaveCreditCard").is(':checked'),
                CustomerProfileId: $('#CustomerProfileId').val(),
                CustomerPaymentId: $('#CustomerPaymentProfileId').val(),
                CustomerGuid: $("#hdnCustomerGUID").val(),
                PaymentGUID: $("#hdnPaymentGUID").val(),
                GatewayCode: $("#hdnGatewayCode").val()
            };
            $.ajax({
                type: "POST",
                url: "/order/SubmitEditOrderpayment",
                data: submitPaymentViewModel,
                success: function (response) {
                    if (response.Data.OrderId !== undefined && response.Data.OrderId > 0) {
                        window.location.reload(true);
                        $("#ajaxBusy").dialog('close');
                        var form = $('<form action="Manage" method="post">' +
                            '<input type="hidden" name="OmsOrderId" value="' + response.Data.OrderId + '" />' +
                            '<input type="text" name= "ReceiptHtml" value= "' + response.Data.ReceiptHtml + '" />' +
                            '</form>');
                        $('body').append(form);
                        $(form).submit();
                    }
                    else {
                        $("#ajaxBusy").dialog('close');
                        var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                        Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                        return false;
                    }
                },
                error: function () {
                    Order.prototype.ClearPaymentAndDisplayMessage("Failed to process order");
                }
            });
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    Order.prototype.SubmitACHPayment = function () {
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            var payment = Order.prototype.GetACHPaymentModel();
            var cardType = $("#hdnGatewayCode").val() == "cardconnect" ? Order.prototype.DetectCardTypeForCardConnect($('#CardDataToken').val()) : Order.prototype.DetectCardType(Order.prototype.GetCreditCardNumber());
            $("#div-CreditCard").hide();
            submitCard(payment, function (response) {
                var orderNumber = "";
                Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) { orderNumber = response.orderNumber; });
                if (response.GatewayResponse == undefined) {
                    if (response.indexOf("Unauthorized") > 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage('We were unable to process your credit card payment. <br /><br />Reason:<br />' + response + '<br /><br />If the problem persists, contact us to complete your order.');
                    }
                }
                else {
                    var cardNumber = "";
                    if ($("#hdnGatwayName").val() == "cardconnect") {
                        cardNumber = $('#CardDataToken').val();
                    }
                    if (cardNumber != "") {
                        $("#hdnCreditCardNumber").val(cardNumber.slice(-4));
                    }
                    var isSuccess = response.GatewayResponse.IsSuccess;
                    if (isSuccess) {
                        var submitPaymentViewModel = {
                            PaymentSettingId: $('#PaymentSettingId').val(),
                            PaymentCode: $('#hdnPaymentCode').val(),
                            CustomerProfileId: response.GatewayResponse.CustomerProfileId,
                            CustomerPaymentId: response.GatewayResponse.CustomerPaymentProfileId,
                            CustomerShippingAddressId: response.GatewayResponse.CustomerShippingAddressId,
                            CustomerGuid: response.GatewayResponse.CustomerGUID,
                            PaymentToken: $("input[name='CCdetails']:checked").val(),
                            UserId: $("#hdnUserId").val(),
                            ShippingOptionId: $("[name='ShippingId']").val(),
                            BillingAddressId: $("#UserAddressDataViewModel_BillingAddress_AddressId").val(),
                            ShippingAddressId: $("#UserAddressDataViewModel_ShippingAddress_AddressId").val(),
                            PortalId: Order.prototype.GetPortalId(),
                            PortalCatalogId: $("#PortalCatalogId").val(),
                            AdditionalInfo: $("#additionalInstructions").val(),
                            EnableAddressValidation: $("input[name='EnableAddressValidation']").val(),
                            RequireValidatedAddress: $("input[name='RequireValidatedAddress']").val(),
                            CreditCardNumber: $("#hdnCreditCardNumber").val(),
                            AccountNumber: $("#ShippingListViewModel_AccountNumber").val(),
                            ShippingMethod: $("#ShippingListViewModel_ShippingMethod").val(),
                            CardType: cardType,
                            OrderNumber: orderNumber,
                            CardDataToken: $('#CardDataToken').val(),
                            InHandDate: $("#InHandDate").val(),
                            JobName: $("#JobName").val(),
                            ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val()
                        };
                        Order.prototype.SubmitPaymentForACH(submitPaymentViewModel);
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
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    Order.prototype.SubmitPaymentForACH = function (submitPaymentViewModel) {
        $.ajax({
            type: "POST",
            url: "/order/submitpayment",
            data: submitPaymentViewModel,
            success: function (response) {
                if (response.Data.OrderId !== undefined && response.Data.OrderId > 0) {
                    $("#ajaxBusy").dialog('close');
                    var form = $('<form action="CheckoutReceipt" method="post">' +
                        '<input type="hidden" name="orderId" value="' + response.Data.OrderId + '" />' +
                        '<input type="text" name= "ReceiptHtml" value= "' + response.Data.ReceiptHtml + '" />' +
                        '<input type="hidden" name= "IsEmailSend" value= ' + response.Data.IsEmailSend + ' />' +
                        '</form>');
                    $('body').append(form);
                    $(form).submit();
                }
                else {
                    $("#ajaxBusy").dialog('close');
                    var errorMessage = response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                    Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                    return false;
                }
            },
            error: function () {
                Order.prototype.ClearPaymentAndDisplayMessage("Failed to process order");
            }
        });
    };
    Order.prototype.CreditCardPaymentCyberSource = function (selectionId) {
        var paymentTokenModel = {
            PaymentSettingId: parseInt($('#PaymentSettingId').val()),
            PaymentCode: $("#hdnPaymentCode").val(),
            Total: $("#hdnTotalOrderAmount").val(),
            paymentGatewayId: $("#hdnGatewayCode").val(),
            GatewayCode: $("#hdnGatewayCode").val(),
        };
        Endpoint.prototype.GetPaymentGatewayToken(paymentTokenModel, function (response) {
            $("#divCreditCardCyberSource").html(response.html);
        });
        if ($("#hdnGatwayName").val() == Constant.CyberSource) {
            $("#creditCard").hide();
        }
    };
    Order.prototype.PaypalExpressCheckout = function () {
        var isValid = true;
        isValid = Order.prototype.ValidateDetails("false");
        if (isValid) {
            return Order.prototype.PayPalPaymentProcess();
        }
    };
    Order.prototype.PayPalPaymentProcess = function () {
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            var paymentOptionId = $('#ddlPaymentTypes').val();
            var urlhost = document.location.origin; //window.location.host;
            var cancelUrl = urlhost + "/order/createorder";
            var returnUrl = urlhost + "/order/submitpaypalorder?paymentOptionId=" + paymentOptionId;
            var orderNumber = "";
            Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) { orderNumber = response.orderNumber; });
            var shippingId = $("input[name='ShippingId']:checked").val();
            var additionalInformation = $("#additionalInstructions").val();
            if (shippingId == undefined) {
                returnUrl = returnUrl + "&shippingId=0&additionalNotes=" + additionalInformation;
            }
            else {
                returnUrl = returnUrl + "&shippingId=" + shippingId + "&additionalNotes=" + additionalInformation;
            }
            var billingaddressId = $("#UserAddressDataViewModel_BillingAddress_AddressId").val();
            var shipingaddressId = $("#UserAddressDataViewModel_ShippingAddress_AddressId").val();
            var paymentmodel = {
                PaymentSettingId: paymentOptionId,
                UserId: $("#hdnUserId").val(),
                BillingAddressId: billingaddressId,
                ShippingAddressId: shipingaddressId,
                PortalId: Order.prototype.GetPortalId(),
                PortalCatalogId: $("#PortalCatalogId").val(),
                PaymentCode: $('#hdnPaymentCode').val(),
                PayPalReturnUrl: returnUrl,
                PayPalCancelUrl: cancelUrl
            };
            var paypalDetails = [];
            Endpoint.prototype.ProcessPayPalPayment(paymentmodel, function (response) {
                var message = response.message;
                if (message.toLowerCase().indexOf("false") >= 0) {
                    Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessPayment"));
                    $("#paypal-button").hide();
                    return false;
                }
                else {
                    if (message != undefined && message.indexOf('Message=') >= 0) {
                        var errorMessage = message.substr(message.indexOf('=') + 1);
                        Order.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorOrderOverDueAmount"));
                        $("#ddlPaymentTypes").val('');
                    }
                    else if (message.indexOf("http") != -1) {
                        paypalDetails.push(response.message);
                        paypalDetails.push(response.token);
                    }
                    else {
                        Order.prototype.ClearPaymentAndDisplayMessage(message);
                        $("#ddlPaymentTypes").val(paymentOptionId);
                    }
                }
            });
            return paypalDetails;
        }
    };
    Order.prototype.ShippingSelectHandler = function (ShippingId, shippingTypeClass) {
        $("#hndShippingclassName").val(shippingTypeClass);
        $("#AccountNumber").val("");
        if (shippingTypeClass == Constant.ZnodeCustomerShipping) {
            $("#customerShippingDiv").show();
            Order.prototype.HideLoader();
        }
        else {
            $("#customerShippingDiv").hide();
        }
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.ShippingSelectHandler(Number($("#hdnUserId").val()), ShippingId, Order.prototype.GetOrderId(), function (response) {
            $("#asidePannelmessageBoxContainerId").hide();
            if (response.shippingErrorMessage != "" && response.shippingErrorMessage != null && response.shippingErrorMessage != "undefined") {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.shippingErrorMessage, "error", isFadeOut, fadeOutTime);
                return false;
            }
            //Set shopping cart details of user.
            $("#orderLineItems").html(response.CartView);
            //Set the seleced shipping option
            $("#shippingTypes option[value !=" + ShippingId + "]").removeAttr('selected');
            var selectedShippingOption = $("#shippingTypes option[value=" + ShippingId + "]");
            selectedShippingOption.attr('selected', 'selected');
            Order.prototype.OnTaxExemptPageLoadCheck();
            if ($("#hdnUserId").val() > 0) {
                $("#ShoppingCartDiv").find('#productListDiv').show();
            }
            Order.prototype.HideLoader();
            Order.prototype.ShippingErrorMessage();
        });
    };
    Order.prototype.ShippingChangeHandler = function (ShippingclassName, shippingCode) {
        if (shippingCode === void 0) { shippingCode = ""; }
        ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        $("#hndShippingclassName").val(ShippingclassName);
        $("#selectedShippingId").val($('#shippingMethodDiv input[name="ShippingId"]:checked').val());
        if (ShippingclassName == Constant.ZnodeCustomerShipping) {
            $("#customerShippingDiv").show();
        }
        else {
            $("#ShippingListViewModel_AccountNumber").val("");
            $("#ShippingListViewModel_ShippingMethod").val("");
            $("#customerShippingDiv").hide();
        }
        $.ajax({
            url: "/Order/CalculateShippingCharges",
            data: Order.prototype.SetCreateOrderViewModel(),
            type: 'POST',
            async: true,
            success: function (data) {
                $("#divTotal").html("");
                //Set cart summary details of user.
                $("#divTotal").html(data);
                $("#OrderDetails").html("");
                $("#OrderDetails").html(data);
                if ($("#hdnUserId").val() > 0) {
                    $("#ShoppingCartDiv").find('#productListDiv').show();
                }
                $("#isGiftcardValid").val("true");
                $("#cart-giftcard-status").hide().html("");
                var success = $("#hdnGiftCardApplied").val();
                var message = $("#hdnGiftCardMessage").val();
                if (message != undefined && message != '') {
                    if (success) {
                        var giftCardMsg = "<p class='green- color'>" + "<a href='#' class='z-close' onclick='Order.prototype.RemoveGiftCard();'></a>" + " - " + message + "</p>";
                        $("#cart-giftcard-status").show().html(giftCardMsg);
                    }
                    else {
                        var giftCardMsg = "<p class='field-validation-error'>" + "<a href='#' class='z-close' onclick='Order.prototype.RemoveGiftCard();'></a>" + " - " + message + "</p>";
                        $("#cart-giftcard-status").show().html(giftCardMsg);
                        $("#isGiftcardValid").val("false");
                    }
                }
                Order.prototype.ShippingErrorMessage();
                Order.prototype.ShowAllowedTerritoriesError();
                ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
            },
            error: function (textStatus, errorThrown) {
            },
            complete: function () {
                shippingCode = $('#shippingMethodDiv input[name="ShippingId"]:checked').attr("id");
                if (shippingCode != "") {
                    $(".dev-custom-shipping-edit").hide();
                    $(".dev-custom-shipping").hide();
                    $("#hdnCustomShippingCost").val("");
                    Order.prototype.ToggleFreeShipping();
                }
            }
        });
    };
    Order.prototype.ShowEditCustomShipping = function (shippingCode) {
        if (location.pathname.indexOf("Quote") <= -1)
            $("#div-Edit-" + shippingCode + "").show();
    };
    Order.prototype.GetSelectedAddons = function () {
        var addOnValues = [];
        $(".AddOn").each(function () {
            var values = "";
            if ($(this).is(":checked")) {
                values = $(this).val();
            }
            else {
                values = $(this).children(":selected").attr("data-addonsku");
            }
            if (values != null && values != "") {
                addOnValues.push(values);
            }
        });
        return addOnValues;
    };
    Order.prototype.GetSelectedBundelProducts = function () {
        var bundleProducts = [];
        $(".bundle").each(function () {
            var values = $(this).attr("data-bundlesku");
            bundleProducts.push(values);
        });
        return bundleProducts;
    };
    Order.prototype.SetCartItemModelValues = function (addOnValues, bundleProducts, groupProducts, groupProductsQuantity, quantity, personalisedcodes, personalisedvalues, groupProductName) {
        if (groupProductName === void 0) { groupProductName = ""; }
        $("#dynamic-addonProductSKU").val(addOnValues);
        $("#dynamic-portalId").val(Order.prototype.GetPortalId());
        $("#dynamic-catalogId").val($("#PortalCatalogId").val());
        $("#dynamic-userId").val($("#hdnUserId").val());
        $("#dynamic-localeId").val($("#LocaleId").val());
        $("#dynamic-bundleProductSKU").val(bundleProducts);
        if (quantity != null || quantity != "") {
            $("#dynamic-quantity").val(quantity);
        }
        $("#dynamic-groupProductSKUs").val(groupProducts);
        $("#dynamic-groupProductsQuantity").val(groupProductsQuantity);
        $("#dynamic-personalisedcodes").val(personalisedcodes);
        $("#dynamic-personalisedvalues").val(personalisedvalues);
        $("#dynamic-groupProductNames").val(groupProductName);
    };
    Order.prototype.OnAssociatedProductQuantityChange = function () {
        var isAddToCartArray = [];
        var isAddToCartGroupProduct = true;
        $("#dynamic-product-variations .quantity").each(function () {
            var _productDetail = Order.prototype.BindProductModel(this, true);
            if (_productDetail.Quantity != null && _productDetail.Quantity != "") {
                if (Order.prototype.CheckIsNumeric(_productDetail.Quantity, _productDetail.QuantityError)) {
                    if (Order.prototype.CheckDecimalValue(_productDetail.DecimalPoint, _productDetail.DecimalValue, _productDetail.InventoryRoundOff, _productDetail.QuantityError)) {
                        if (Order.prototype.CheckQuantityGreaterThanZero(parseInt(_productDetail.Quantity), _productDetail.QuantityError)) {
                            $("#button-addtocart").prop("disabled", false);
                            $(_productDetail.QuantityError).text("");
                            $(_productDetail.QuantityError).removeClass("error-msg");
                            $("#group-product-error").html("");
                            isAddToCartArray.push(true);
                        }
                        else {
                            isAddToCartArray.push(false);
                        }
                    }
                    else {
                        isAddToCartArray.push(false);
                    }
                }
                else {
                    isAddToCartArray.push(false);
                }
            }
            else {
                $("#button-addtocart").prop("disabled", false);
                $(_productDetail.QuantityError).text("");
                $(_productDetail.QuantityError).removeClass("error-msg");
                $("#group-product-error").html("");
                isAddToCartArray.push(true);
            }
            isAddToCartGroupProduct = !($.inArray(false, isAddToCartArray) > -1);
            OneClick = false;
        });
        return isAddToCartGroupProduct;
    };
    Order.prototype.CheckDecimalValue = function (decimalPoint, decimalValue, inventoryRoundOff, quantityError, isPrice) {
        if (isPrice === void 0) { isPrice = false; }
        if (decimalValue != 0 && decimalPoint > inventoryRoundOff) {
            if (isPrice)
                $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("EnterPriceHaving") + inventoryRoundOff + ZnodeBase.prototype.getResourceByKeyName("XNumbersAfterDecimalPoint"));
            else
                $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("EnterQuantityHaving") + inventoryRoundOff + ZnodeBase.prototype.getResourceByKeyName("XNumbersAfterDecimalPoint"));
            $(quantityError).css("class", "error-msg");
            $(quantityError).show();
            $("#button-addtocart").attr("disabled", "disabled");
            return false;
        }
        $(quantityError).hide();
        return true;
    };
    Order.prototype.CheckIsNumeric = function (selectedQty, quantityError) {
        var matches = selectedQty.match(/^-?[\d.]+(?:e-?\d+)?$/);
        if (matches == null) {
            $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("RequiredNumericValue"));
            $(quantityError).addClass("error-msg");
            $(quantityError).show();
            $("#button-addtocart").attr("disabled", "disabled");
            return false;
        }
        return true;
    };
    Order.prototype.CheckQuantityGreaterThanZero = function (selectedQty, quantityError) {
        if (selectedQty <= 0) {
            $("#button-addtocart").attr("disabled", "disabled");
            $("#btnUpdateQuote").addClass('pointer-none');
            $(quantityError).show();
            $(quantityError).addClass("error-msg");
            $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorProductQuantity"));
            return false;
        }
        $("#btnUpdateQuote").removeClass('pointer-none');
        return true;
    };
    Order.prototype.BindProductModel = function (control, isGroup) {
        var _productDetail = {
            InventoryRoundOff: parseInt($(control).attr("data-inventoryroundoff")),
            ProductId: parseInt($(control).attr('data-productId')),
            Quantity: $(control).val(),
            SKU: $(control).attr("data-sku"),
            MainProductSKU: $(control).attr("data-parentsku"),
            DecimalPoint: $(control).val().split(".")[1] != null ? $(control).val().split(".")[1].length : 0,
            DecimalValue: $(control).val().split(".")[1] != null ? $(control).val().split(".")[1] : 0,
            QuantityError: isGroup ? "#quantity-error-msg_" + $(control).attr('data-productId') : "#quantity-error-msg",
            MainProductId: parseInt($(control).attr("data-parentProductId")),
        };
        return _productDetail;
    };
    Order.prototype.ApplyPromoCode = function (isCouponApplied) {
        if (this.IsAnyPendingReturn()) {
            $("#promocode").val("");
        }
        else if ($("#promocode").val() == "" || $("#promocode").val() == undefined) {
            var htmlString = "<div>";
            htmlString = htmlString + "<p class='field-validation-error'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorCouponCode") + "</p>";
            htmlString = htmlString + "</div>";
            $("#couponContainer").show();
            $("#couponContainer").html("");
            $("#couponContainer").html(htmlString);
        }
        else {
            var orderId = Order.prototype.GetOrderId();
            var url = "";
            var userId = $("#hdnUserId").val();
            if (orderId > 0)
                url = "/Order/ManageApplyCoupon?orderId=" + orderId + "&userId=" + userId;
            else
                url = "/Order/ApplyCoupon?userId=" + userId;
            ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
            Endpoint.prototype.useCouponCode(url, $("#promocode").val(), function (response) {
                if (orderId > 0) {
                    $("#divShoppingCart").html("");
                    $("#divShoppingCart").html(response.html);
                    Order.prototype.OnTaxExemptPageLoadCheck();
                }
                else {
                    $("#divTotal").html("");
                    $("#OrderDetails").html("");
                    $("#divTotal").html(response.html);
                    $("#OrderDetails").html(response.html);
                }
                Order.prototype.BindCouponHtml(response.coupons);
                Order.prototype.IsValidCSRDiscountApplied();
                ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
            });
        }
    };
    Order.prototype.BindCouponHtml = function (couponsCodes) {
        if (couponsCodes != null) {
            var coupons = couponsCodes;
            var htmlString = "<div>";
            for (var couponIndex = 0; couponIndex < coupons.length; couponIndex++) {
                var style = coupons[couponIndex].CouponApplied ? "green-color" : "field-validation-error";
                var message = coupons[couponIndex].PromotionMessage;
                var couponCode = coupons[couponIndex].Code;
                htmlString = htmlString + "<p class='" + style + "'>";
                if (!coupons[couponIndex].IsExistInOrder) {
                    htmlString += "<a href='#' class='z-close dirtyignore' onclick='Order.prototype.RemoveCoupon(&#39;" + couponCode + "&#39;)'></a>";
                }
                htmlString += "<b>" + "  " + couponCode + "</b> " + " - " + message + "</p>";
                if (coupons[couponIndex].CouponApplied) {
                    $("#promocode").val(coupons[couponIndex].Coupon);
                }
            }
            htmlString = htmlString + "</div>";
            $("#couponContainer").show();
            $("#couponContainer").html("");
            $("#couponContainer").html(htmlString);
        }
        $('*[data-autocomplete-url]').each(function () { autocompletewrapper($(this), $(this).data("onselect-function")); });
    };
    Order.prototype.ApplyTaxExempt = function () {
        $("#containerTaxExempt").show();
        $("#btnTaxExempt").hide();
    };
    Order.prototype.ConfirmTaxExemptOrder = function () {
        Endpoint.prototype.UpdateForTaxExempt(Order.prototype.GetOrderId(), "0.0", "TaxView", function (response) {
            $("#divShoppingCart").html("");
            $("#divShoppingCart").html(response);
            $("#chkTaxExempt").attr("disabled", true);
            $("#spnTaxExempt").hide();
            $("#messageTaxExcempt").html("This Order Tax Exempted");
        });
    };
    Order.prototype.ConfirmTaxExemptOnCreateOrder = function () {
        var isTaxExempt = $("#chkTaxExempt").prop("checked");
        ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        var isQuote = Order.prototype.IsQuote();
        Endpoint.prototype.UpdateTaxExemptOnCreateOrder(Order.prototype.GetUserId(), "0.0", "TaxView", isTaxExempt, isQuote, function (response) {
            $("#divTotal").html("");
            $("#divTotal").html(response);
            $("#OrderDetails").html("");
            $("#OrderDetails").html(response);
            if (isTaxExempt == true) {
                var textTaxExempted = isQuote ? "This Quote Tax Exempted" : "This Order Tax Exempted";
                $("#messageTaxExcempt").html(textTaxExempted);
            }
            else {
                $("#messageTaxExcempt").html("Make Tax Exempt");
            }
            ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
        });
    };
    Order.prototype.OnTaxExemptPageLoadCheck = function () {
        if ($("#hdnTaxCostEdited").val() == "True") {
            $("#chkTaxExempt").attr("disabled", true);
            $("#chkTaxExempt").attr("checked", true);
            $("#spnTaxExempt").hide();
            $("#btnTaxExempt").hide();
            $("#containerTaxExempt").show();
            $("#messageTaxExcempt").html("This Order Tax Exempted");
        }
        $("#divTaxExemptContainer").show();
    };
    Order.prototype.OnTaxExemptChecked = function () {
        if (this.IsAnyPendingReturn()) {
            var isTaxExempt = $("#hdnTaxCostEdited").val() == 'True' ? true : false;
            $("#chkTaxExempt").prop("checked", isTaxExempt);
        }
        else if ($("#chkTaxExempt").is(':checked')) {
            $("#PopUpTaxExemptSubmitOrder").modal("show");
        }
        else {
            Order.prototype.ConfirmTaxExemptOnCreateOrder();
        }
    };
    Order.prototype.RemoveCoupon = function (coupon) {
        event.preventDefault();
        ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        var orderId = Order.prototype.GetOrderId();
        var userId = $("#hdnUserId").val();
        var url = "";
        if (orderId > 0)
            url = "/Order/ManageRemoveCoupon?orderId=" + orderId + "&userId=" + userId;
        else
            url = "/Order/RemoveCoupon?userId=" + userId;
        Endpoint.prototype.removeCouponCode(url, coupon, function (response) {
            if (Order.prototype.GetOrderId() > 0) {
                $("#divShoppingCart").html("");
                $("#divShoppingCart").html(response.html);
                Order.prototype.OnTaxExemptPageLoadCheck();
                Order.prototype.BindCouponHtml(response.coupons);
            }
            else {
                $("#divTotal").html("");
                $("#divTotal").html(response.html);
                $("#OrderDetails").html("");
                $("#OrderDetails").html(response.html);
                Order.prototype.BindCouponHtml(response.coupons);
            }
            $("#promocode").val("");
            Order.prototype.IsValidCSRDiscountApplied();
            ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
        });
    };
    Order.prototype.RemoveOrderGridIcone = function () {
        Order.prototype.HideGridColumn('IsInRMA');
        $('#grid tbody tr').each(function () {
            if (($(this).find('td').find('.z-void-payment').attr('href').toLowerCase().indexOf('authorized') >= 0) || ($(this).find('td').find('.z-void-payment').attr('href').toLowerCase().indexOf('captured') >= 0)) {
                if ($(this).find('.paymentType').text().toLowerCase() == 'paypal express') {
                    $(this).find('.z-void-payment').parents('li').remove();
                }
            }
            else {
                $(this).find('.z-void-payment').parents('li').remove();
            }
        });
        $("#listcontainerId").show();
    };
    Order.prototype.HideGridColumn = function (cssClass) {
        var indexOfRow = $('#grid tbody tr:eq(0)').find('.' + cssClass + '').index() + 1;
        $('th:nth-child(' + indexOfRow + ')').hide();
        $('#grid tbody tr').find('.' + cssClass + '').hide();
    };
    Order.prototype.GetOrderId = function () {
        var omsOrderId = $("#hdnManageOmsOrderId").val();
        if (omsOrderId != null && omsOrderId != "") {
            var orderId = parseInt(omsOrderId);
            if (orderId > 0) {
                return orderId;
            }
        }
        return 0;
    };
    Order.prototype.GetVoucherURL = function () {
        var orderId = Order.prototype.GetOrderId();
        var url = "";
        if (orderId > 0)
            url = "/Order/ManageApplyVoucher?orderId=" + orderId + "";
        else
            url = "/Order/ApplyVoucher";
        return url;
    };
    Order.prototype.ApplyVoucher = function () {
        if (this.IsAnyPendingReturn()) {
            $("#txtgiftcard").val("");
        }
        else if ($("#txtgiftcard").val() == "" || $("#txtgiftcard").val() == undefined) {
            var htmlString = "<div>";
            htmlString = htmlString + "<p class='field-validation-error'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorVoucherNo") + "</p>";
            htmlString = htmlString + "</div>";
            $("#RequiredgiftCardErrorMessage").show();
            $("#RequiredgiftCardErrorMessage").html("");
            $("#RequiredgiftCardErrorMessage").html(htmlString);
        }
        else {
            var isValid = Order.prototype.ValidateVoucher();
            if (isValid) {
                ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
                Endpoint.prototype.ApplyVoucher(Order.prototype.GetVoucherURL(), $("#txtgiftcard").val(), $("#hdnUserId").val(), function (response) {
                    var orderId = Order.prototype.GetOrderId();
                    if (orderId > 0) {
                        $("#divShoppingCart").html("");
                        $("#divShoppingCart").html(response.html);
                    }
                    else {
                        $("#divTotal").html("");
                        $("#divTotal").html(response.html);
                        $("#OrderDetails").html("");
                        $("#OrderDetails").html(response.html);
                    }
                    vouchers = response.vouchers;
                    Order.prototype.BindVoucherHtml(vouchers);
                    Order.prototype.BindCouponHtml(response.coupons);
                    ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
                    $('*[data-autocomplete-url]').each(function () { autocompletewrapper($(this), $(this).data("onselect-function")); });
                });
            }
        }
    };
    Order.prototype.RemoveVoucher = function (voucher) {
        event.preventDefault();
        ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        var orderId = Order.prototype.GetOrderId();
        var userId = $("#hdnUserId").val();
        var url = "";
        if (orderId > 0)
            url = "/Order/ManageRemoveVoucher?orderId=" + orderId + "&userId=" + userId;
        else
            url = "/Order/RemoveVoucher?userId=" + userId;
        Endpoint.prototype.RemoveVoucher(url, voucher, function (response) {
            if (Order.prototype.GetOrderId() > 0) {
                $("#divShoppingCart").html("");
                $("#divShoppingCart").html(response.html);
                Order.prototype.OnTaxExemptPageLoadCheck();
                Order.prototype.BindVoucherHtml(response.vouchers);
            }
            else {
                $("#divTotal").html("");
                $("#divTotal").html(response.html);
                $("#OrderDetails").html("");
                $("#OrderDetails").html(response.html);
                Order.prototype.BindVoucherHtml(response.vouchers);
            }
            $("#promocode").val("");
            ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
        });
    };
    Order.prototype.BindVoucherHtml = function (vouchers) {
        if (vouchers != null) {
            $("#RequiredgiftCardErrorMessage").html('');
            $("#giftCardMessageContainer").html("");
            for (var voucherIndex = 0; voucherIndex < vouchers.length; voucherIndex++) {
                var isExistInOrder = vouchers[voucherIndex].IsExistInOrder;
                var message = isExistInOrder ? 'Applied' : vouchers[voucherIndex].VoucherMessage;
                var isVoucherApplied = vouchers[voucherIndex].IsVoucherApplied;
                var voucherNumber = vouchers[voucherIndex].VoucherNumber;
                Order.prototype.AppendGiftCardMessage(message, isVoucherApplied, voucherNumber, vouchers[voucherIndex].VoucherName, vouchers[voucherIndex].ExpirationDate, vouchers[voucherIndex].VoucherAmountUsed, isExistInOrder, vouchers[voucherIndex].OrderVoucherAmount);
                $("#giftCard").removeClass("promotion-block");
            }
        }
    };
    Order.prototype.AppendGiftCardMessage = function (msg, giftCardApplied, voucherNumber, voucherName, expirationDate, voucherAmountUsed, isExistInOrder, OrderVoucherAmount) {
        var htmlString = "<div id='voucherContainer' class='control-non' data-test-selector='divVoucherCodeStatus'>";
        var removeLink = isExistInOrder ? "" : "<a class='z-close dirtyignore' onclick = 'Order.prototype.RemoveVoucher(&#39;" + voucherNumber + "&#39;);' > </a>";
        htmlString = giftCardApplied == true || giftCardApplied == "True" ? htmlString = htmlString + "<p style='font-size: 11px;'> " + removeLink + "<strong class='success-msg'> " + (isExistInOrder ? OrderVoucherAmount : voucherAmountUsed) + "</strong> " + voucherName + " Expires :(" + expirationDate + ") <strong> " + voucherNumber + " </strong></p>"
            : htmlString = htmlString + "<p class='error-msg' style='font-size: 11px;'>" + removeLink + msg + "</p>";
        htmlString = htmlString + "</div>";
        if (msg != null && msg != "") {
            $("#giftCardMessageContainer").append(htmlString);
        }
    };
    Order.prototype.ValidateVoucher = function () {
        ZnodeBase.prototype.ShowLoader();
        var discountCode = $("#txtgiftcard").val();
        var htmlString = "<div>";
        if (discountCode == null || discountCode == "" || discountCode == undefined) {
            htmlString = htmlString + "<p class='field-validation-error nopadding'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorVoucherNo") + "</p>";
            htmlString = htmlString + "</div>";
            $("#RequiredgiftCardErrorMessage").show();
            $("#RequiredgiftCardErrorMessage").html("");
            $("#RequiredgiftCardErrorMessage").html(htmlString);
            ZnodeBase.prototype.HideLoader();
            return false;
        }
        else if (parseFloat($("#hdnTotalOrderAmount").val().replace(',', '.')) <= 0.00) {
            htmlString = htmlString + "<p class='field-validation-error'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorNoVoucherApplied") + "</p>";
            htmlString = htmlString + "</div>";
            $("#RequiredgiftCardErrorMessage").html("");
            $("#RequiredgiftCardErrorMessage").html(htmlString);
            ZnodeBase.prototype.HideLoader();
            return false;
        }
        else if (typeof vouchers !== "undefined" && vouchers !== null) {
            var found = vouchers.some(function (el) { return el.VoucherNumber === discountCode && el.IsVoucherApplied == true; });
            if (found == true) {
                htmlString = htmlString + "<p class='field-validation-error'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorVoucherAlreadyApplied") + "</p>";
                htmlString = htmlString + "</div>";
                $("#RequiredgiftCardErrorMessage").html("");
                $("#RequiredgiftCardErrorMessage").html(htmlString);
                ZnodeBase.prototype.HideLoader();
                return false;
            }
        }
        else
            $("#RequiredgiftCardErrorMessage").html('');
        return true;
    };
    Order.prototype.ClearDiscountMessages = function () {
        $("#RequiredgiftCardErrorMessage").html('');
        $("#giftCardMessageContainer").html("");
        $("#txtgiftcard").val("");
        $("#csr-discount-status").html("");
        $("#txtcsrDiscount").val("");
        $("#couponContainer").html("");
        $("#promocode").val("");
        $("#chkTaxExempt").prop("checked", false);
    };
    Order.prototype.CustomerAddressViewHandler = function (control) {
        Order.prototype.ShowHideAddressCheckBoxDiv(control);
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
    Order.prototype.ShowHideAddressCheckBoxDiv = function (addressType) {
        if (addressType == 'shipping') {
            $("#DefaultBillingAddressDiv").hide();
            $("#DefaultShippingAddressDiv").show();
        }
        if (addressType == 'billing') {
            $("#DefaultShippingAddressDiv").hide();
            $("#DefaultBillingAddressDiv").show();
        }
    };
    Order.prototype.GetCustomerAddressForManange = function (control, selectedAddressId, shippingBillingId, omsOrderId) {
        if (!this.IsAnyPendingReturn()) {
            $("#customerDetails").html("");
            $("#hdnIsShipping").val(control);
            var ShippingAddressId = control == 'shipping' ? selectedAddressId : shippingBillingId;
            var BillingAddressId = control == 'billing' ? selectedAddressId : shippingBillingId;
            ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetUserAddressForManageById?selectedAddressId=' + selectedAddressId + '&orderId=' + omsOrderId + '&ShippingAddressId=' + ShippingAddressId + '&BillingAddressId=' + BillingAddressId + '&userId=' + $("#hdnUserId").val() + '&portalId=' + Order.prototype.GetPortalId() + '' + '&control=' + control + '', 'addressDetails');
            $("#addressDetails").find('.chkShippingBilling').remove();
        }
    };
    Order.prototype.GetCustomerAddressDetails = function (addressType, shippingAddressId, billingAddressId) {
        $("#customerDetails").html("");
        $("#hdnIsShipping").val(addressType);
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetUserAddress?ShippingAddressId=' + shippingAddressId + '&BillingAddressId=' + billingAddressId + '&userId=' + $("#hdnUserId").val() + '&portalId=' + Order.prototype.GetPortalId() + '&addressType=' + addressType + '&isQuote=' + Order.prototype.IsQuote() + '', 'addressDetails');
        $("#addressDetails").find('.chkShippingBilling').remove();
    };
    Order.prototype.CreateNewAddress = function (addressType, selectedAddressId, shippingBillingId) {
        $("#customerDetails").html("");
        $("#hdnIsShipping").val(addressType);
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/CreateNewAddress?userId=' + $('#hdnUserId').val() + '&portalId=' + Order.prototype.GetPortalId() + '&addressType=' + addressType + '&shippingAddressId=' + selectedAddressId + '&billingAddressId=' + shippingBillingId + '&isQuote=' + Order.prototype.IsQuote() + '', 'addressDetails');
        if (addressType == 'shipping') {
            $("#DefaultBillingAddressDiv").hide();
            $("#DefaultShippingAddressDiv").show();
        }
        else if (addressType == 'billing') {
            $("#DefaultShippingAddressDiv").hide();
            $("#DefaultBillingAddressDiv").show();
        }
    };
    Order.prototype.ChangeAddressSuccessForManage = function (response) {
        if (response.shippingErrorMessage != "" && response.shippingErrorMessage != null && response.shippingErrorMessage != "undefined") {
            $("#asidePannelmessageBoxContainerId div").html(response.shippingErrorMessage);
            $("#asidePannelmessageBoxContainerId").show();
            return false;
        }
        if (response.addressView.indexOf("field-validation-error") < 0) {
            Order.prototype.HideLoader();
            ZnodeBase.prototype.CancelUpload('addressDetails');
            $("#customerInformation").html(response.addressView);
            $("#divTotal").html(response.orderTotal);
            $("#divShoppingCart").html("");
            $("#divShoppingCart").html(response.totalView);
            Order.prototype.DisableManageOrderControls();
            Order.prototype.RemoveFormDataValidation();
            Order.prototype.ToggleFreeShipping();
            Order.prototype.GetShippingList();
        }
        else {
            $("#divCustomerAddressPopup").html(response.addressView);
            $(".chkShippingBilling").show();
        }
    };
    Order.prototype.ChangeAddressSuccessCallback = function (response) {
        if (response.ErrorMassage != "" && response.ErrorMassage != null && response.ErrorMassage != "undefined") {
            $("#asidePannelmessageBoxContainerId div").html(response.ErrorMassage);
            $("#asidePannelmessageBoxContainerId").show();
            return false;
        }
        if (response.addressView.indexOf("field-validation-error") < 0) {
            ZnodeBase.prototype.CancelUpload('addressDetails');
            if (response.isShippingAddressChange) {
                Order.prototype.ClearShippingEstimates();
                $("#divTotal").html("");
                $("#divTotal").html(response.totalView);
            }
            $("#customerAddresses").html(response.addressView);
            $("#changeAddressdiv").hide();
            Order.prototype.ShowAllowedTerritoriesError();
            Order.prototype.EnableDisableShippingOptions();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AddressSavedSuccessfully"), "success", isFadeOut, fadeOutTime);
        }
        else {
            $("#divCustomerAddressPopup").html(response.addressView);
            $(".chkShippingBilling").show();
        }
    };
    Order.prototype.RemoveFormDataValidation = function () {
        $('form').removeData('validator');
        $('form').removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse('form');
        $('#IsDefaultShipping').rules('remove');
        $('#IsDefaultBilling').rules('remove');
    };
    Order.prototype.GetUserAddressBySelectedAddress = function (control) {
        var addressId = $(control).val();
        var isShipping = $("#hdnIsShipping").val();
        var isB2BCustomer = $("#hdnAccountId").val() > 0 ? true : false;
        var fromBillingShipping = $("#hdnFromBillingShipping").val();
        Endpoint.prototype.GetUserAddressBySelectedAddress(addressId, fromBillingShipping, isB2BCustomer, $("#hdnUserId").val(), Order.prototype.GetPortalId(), $("#hdnAccountId").val(), function (response) {
            $("#addressDiv").html(response.html);
            Order.prototype.ShowHideAddressCheckBoxDiv(isShipping);
            if (response.address.AddressId == 0) {
                $(".chkShippingBilling").show();
                $('#UserId').val($("#hdnUserId").val());
                $('#AddressId').val(response.address.AddressId);
                $('#CountryName').prop('selectedIndex', 0);
                if (isShipping == 'shipping') {
                    $('#SelectedShippingId').val(response.address.AddressId);
                    $('#IsShippingAddressChange').val('true');
                }
                else
                    $('#SelectedBillingId').val(response.address.AddressId);
            }
            else {
                $('#AddressId').val(response.address.AddressId);
                if (isShipping == 'shipping') {
                    $('#SelectedShippingId').val(response.address.AddressId);
                    $('#IsShippingAddressChange').val('true');
                }
                else
                    $('#SelectedBillingId').val(response.address.AddressId);
            }
            Order.prototype.HideLoader();
        });
    };
    Order.prototype.ValidateRefundOrder = function () {
        var status = true;
        for (var i = 0; i < $("#RefundOrderLineitems tr").not("thead tr").length; i++) {
            if (Number($("input[name='RefundOrderLineitems[" + i + "].RefundAmount']").val()) > Number($("input[name='RefundOrderLineitems[" + i + "].RefundableAmountLeft']").val())) {
                $("#valRefundOrderLineitems_" + i).text('').removeClass("field-validation-error");
                $("#valRefundOrderLineitems_" + i).text(ZnodeBase.prototype.getResourceByKeyName("RefundAmountError")).addClass("field-validation-error");
                $("#valRefundOrderLineitems_" + i).show();
                status = false;
            }
        }
        if (Number($("#ShippingRefundDetails_RefundAmount").val()) > Number($("#ShippingRefundDetails_RefundableAmountLeft").val())) {
            $("#valRefundOrderShipping").text('').removeClass("field-validation-error");
            $("#valRefundOrderShipping").text(ZnodeBase.prototype.getResourceByKeyName("RefundAmountError")).addClass("field-validation-error");
            $("#valRefundOrderShipping").show();
            status = false;
        }
        if (Number($("#TotalRefundDetails_RefundAmount").val()) > Number($("#TotalRefundDetails_RefundableAmountLeft").val())) {
            $("#valRefundOrderTotal").text('').removeClass("field-validation-error");
            $("#valRefundOrderTotal").text(ZnodeBase.prototype.getResourceByKeyName("RefundAmountError")).addClass("field-validation-error");
            $("#valRefundOrderTotal").show();
            status = false;
        }
        return status;
    };
    Order.prototype.IsQuote = function () {
        var isQuote = $("#IsQuote").val();
        if (isQuote != null)
            return isQuote.toLowerCase() == "true";
        return false;
    };
    Order.prototype.ApplyCSRDiscount = function () {
        if ($("#txtcsrDiscount").val() == "" || $("#txtcsrDiscount").val() == undefined) {
            var htmlString = "<div>";
            htmlString = htmlString + "<p class='field-validation-error'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorCSRDiscount") + "</p>";
            htmlString = htmlString + "</div>";
            $("#csr-discount-status").show();
            $("#csr-discount-status").html("");
            $("#csr-discount-status").html(htmlString);
        }
        else if ($("#txtcsrDiscount").val() != "" && $("#txtcsrDiscount").val() != undefined && $("#txtcsrDiscount").val() < 0) {
            var htmlString = "<div>";
            htmlString = htmlString + "<p class='field-validation-error'>" + ZnodeBase.prototype.getResourceByKeyName("ErrorCSRDisountNegative") + "</p>";
            htmlString = htmlString + "</div>";
            $("#csr-discount-status").show();
            $("#csr-discount-status").html("");
            $("#csr-discount-status").html(htmlString);
        }
        else {
            if ($("#txtcsrDiscount").val() == "") {
                $("#txtcsrDiscount").val(0);
            }
            ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
            Endpoint.prototype.ApplyCSRDiscount($("#txtcsrDiscount").val(), $("#txtcsrDesc").val(), $("#hdnUserId").val(), function (response) {
                $("#divTotal").html("");
                $("#divTotal").html(response);
                $("#OrderDetails").html("");
                $("#OrderDetails").html(response);
                if ($("#txtcsrDiscount").val().trim().length > 0) {
                    var success = $("#hdnCSRDiscountApplied").val();
                    var message = $("#hdnCsrSuccessMessage").val();
                    if (success.toLowerCase() == "true") {
                        var discountMsg = "<p class='green- color'>" + "<a href='#' class='z-close' onclick='Order.prototype.RemoveCSRDiscount();'></a>" + "  " + message + "</p>";
                        $("#csr-discount-status").show().html(discountMsg);
                    }
                    else {
                        var discountMsg = "<p class='field-validation-error'>" + "<a href='#' class='z-close' onclick='Order.prototype.RemoveCSRDiscount();'></a>" + "  " + message + "</p>";
                        $("#csr-discount-status").show().html(discountMsg);
                    }
                }
                else {
                    $("#csr-discount-status").html("");
                }
                ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
            });
            if ($("#txtcsrDiscount").val() == "0") {
                $("#txtcsrDiscount").val("");
            }
        }
    };
    Order.prototype.IsValidCSRDiscountApplied = function () {
        var isValidCSRDiscount = true;
        var csrMessage = $("#hdnCsrSuccessMessage").val();
        var discountMsg;
        if ($("#hdnCSRDiscountAmount").val() > 0 && (parseInt($("#hdnCSRDiscountAmount").val()) + parseInt($("#hdnDiscount").val()) > $("#hdnSubTotal").val())) {
            discountMsg = "<p class='field-validation-error'>" + "<a href='#' class='z-close' onclick='Order.prototype.RemoveCSRDiscount();'></a>" + "  " + csrMessage + "</p>";
            $("#csr-discount-status").show().html(discountMsg);
            isValidCSRDiscount = false;
            $('#txtcsrDiscount').focus();
        }
        else if ($("#hdnCSRDiscountAmount").val() > 0) {
            discountMsg = "<p class='green- color'>" + "<a href='#' class='z-close' onclick='Order.prototype.RemoveCSRDiscount();'></a>" + "  " + csrMessage + "</p>";
            $("#csr-discount-status").show().html(discountMsg);
        }
        return isValidCSRDiscount;
    };
    Order.prototype.RemoveCSRDiscount = function () {
        event.preventDefault();
        ZnodeBase.prototype.ShowPartialLoader("loader-divTotal");
        var orderId = Order.prototype.GetOrderId();
        Endpoint.prototype.ApplyCSRDiscount(0, "", $("#hdnUserId").val(), function (response) {
            if (orderId > 0) {
                $("#divShoppingCart").html("");
                $("#divShoppingCart").html(response);
            }
            else {
                $("#divTotal").html("");
                $("#divTotal").html(response);
                $("#OrderDetails").html("");
                $("#OrderDetails").html(response);
            }
            var success = $("#hdnCSRDiscountApplied").val();
            var message = $("#hdnCsrSuccessMessage").val();
            $("#csr-discount-status").show().html(message);
            $("#txtcsrDiscount").val("");
            ZnodeBase.prototype.HidePartialLoader("loader-divTotal");
        });
    };
    Order.prototype.AddNewUser = function () {
        var portalId = parseInt($("#txtPortalName").attr("data-portalid"));
        if (portalId > 0) {
            $("#ZnodeUserPortalList").html("");
            $("#ZnodeOrderCustomer").html("");
            ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/AddNewCustomer?portalid=' + portalId + '', 'customerDetails');
        }
        else {
            $("#errorRequiredStore").text('').text(ZnodeBase.prototype.getResourceByKeyName("SelectPortal")).addClass("field-validation-error").show();
            $("#txtPortalName").parent("div").addClass('input-validation-error');
            return false;
        }
    };
    Order.prototype.MakeAccountIdMandetory = function () {
        if (Order.prototype.IsQuote() && $("#searchCustomer").attr("data-action") != "createquoterequest") {
            $("#lblAccountId").addClass("required");
        }
    };
    Order.prototype.SetPortalId = function () {
        var portalId = Order.prototype.GetPortalId();
        $("#PortalId").val(portalId);
        $("#selectedPortalId").val(portalId);
        if (Order.prototype.IsQuote()) {
            if ($("#AccountId").val() == "") {
                $("#errorSelectAccountId").html("Please select account.");
                return false;
            }
        }
        if ($("#ddlUserType").is(":visible") && $("#ddlUserType").val() == "") {
            $("#valRoleName").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorRoleNameRequired")).addClass("field-validation-error").show();
            $("#ddlUserType").addClass('input-validation-error');
            return false;
        }
        return true;
    };
    Order.prototype.OrderStatusTrackingNumHideShow = function (ShippingTypeName) {
        var shippingTypeName = ShippingTypeName;
        if (shippingTypeName.toLowerCase().indexOf("fedex") >= 0) {
            $("#txtTrackingNumber").text(ZnodeBase.prototype.getResourceByKeyName("LabelFedExTrackingNo"));
        }
        else if (shippingTypeName.toLowerCase().indexOf("ups") >= 0) {
            $("#txtTrackingNumber").text(ZnodeBase.prototype.getResourceByKeyName("LabelUPSTrackingNo"));
        }
        else if (shippingTypeName.toLowerCase().indexOf("usps") >= 0) {
            $("#txtTrackingNumber").text(ZnodeBase.prototype.getResourceByKeyName("LabelUSPSTrackingNo"));
        }
        if (shippingTypeName.toLowerCase().indexOf("fedex") >= 0 || shippingTypeName.toLowerCase().indexOf("ups") >= 0 || shippingTypeName.toLowerCase().indexOf("usps") >= 0) {
            $("#btnChangeTrackingNumber").css("display", "inline");
        }
    };
    Order.prototype.RemovePagingControlsFromGrid = function () {
        $("div.pagination-top").remove();
        $("div.pagination-bottom").remove();
        $("div.grid-control").remove();
    };
    Order.prototype.AddNotesSuccessCallBack = function () {
        $("#AdditionalNotes").val('');
    };
    Order.prototype.ManageNotesSuccessCallBack = function () {
        $("#AdditionalNotes").val('');
    };
    Order.prototype.SubmitManageNotes = function () {
        $("#ManageOrderNotes").submit();
    };
    Order.prototype.AddNotesValidation = function () {
        if ($("#AdditionalNotes").val() == '') {
            return false;
        }
        return true;
    };
    Order.prototype.GetAccountId = function () {
        var href = window.location.href.toLowerCase();
        if (href.indexOf("?accountid=") != -1) {
            return Order.prototype.GetParameterByName("accountid", href);
        }
        else {
            return "0";
        }
    };
    Order.prototype.GetParameterByName = function (name, url) {
        if (!url) {
            url = window.location.href.toLowerCase();
        }
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"), results = regex.exec(url);
        if (!results)
            return null;
        if (!results[2])
            return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    };
    Order.prototype.AddProductToCart = function (e) {
        var selectedIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        selectedProductIds = "";
        var count = selectedIds == "" ? 0 : selectedIds.split(",").length;
        if (count > 0) {
            var orderId_2 = Order.prototype.GetOrderId();
            Endpoint.prototype.AddProductToCart(orderId_2, $("#hdnUserId").val(), function (response) {
                Order.prototype.HideAsidePopUpPanel();
                if (orderId_2 > 0) {
                    $("#orderLineItems").html(response.html);
                    Order.prototype.FreezeManageOrder(false);
                    Order.prototype.OnTaxExemptPageLoadCheck();
                }
                else {
                    $("#divShoppingCart").empty();
                    $("#divShoppingCart").append(response.html);
                }
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
                        Order.prototype.BindCouponHtml(response.coupons);
                    }
                }
                Order.prototype.ToggleFreeShipping();
            });
        }
        else {
            $("#productMessageBoxContainerId").show();
        }
    };
    Order.prototype.ClosePopUp = function (e) {
        var productIds = Order.prototype.GetOrderId() > 0 ? selectedProductIds : DynamicGrid.prototype.GetMultipleSelectedIds();
        if (productIds != null && typeof productIds != "undefined" && productIds != "") {
            Order.prototype.RemoveItemFromCart(e, productIds, true);
        }
        Order.prototype.HideAsidePopUpPanel();
        selectedProductIds = "";
    };
    Order.prototype.HideAsidePopUpPanel = function () {
        var popup = $("#aside-popup-panel");
        $('.aside-popup-panel').hide();
        popup.slideUp(200, function () {
            $("body").css('overflow', 'auto');
            $(this).remove();
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
        });
    };
    Order.prototype.HideTableTH = function (gridTD, cssClass) {
        if (gridTD.hasClass('addToCart')) {
            var indexOfRow = $('#grid tbody tr:eq(0)').find('.' + cssClass + '').index() + 1;
            $('th:nth-child(' + indexOfRow + ')').hide();
        }
    };
    Order.prototype.SetDataOnUpdate = function () {
        if ($("#hdnActionName").val() == "converttoorder" || $("#hdnActionName").val() == "reorder" || $("#hdnActionName").val() == "editorder") {
            Order.prototype.ShowAsidePanelSelected();
        }
    };
    Order.prototype.SetDataOnConvertingQuoteToOrder = function () {
        if ($("#hdnActionName").val() == "converttoorder") {
            Order.prototype.ShowAsidePanelSelected();
        }
    };
    Order.prototype.ShowAsidePanelSelected = function () {
        for (var i = 0; i < ($("#OrderAsidePannel li").length - 2); i++)
            OrderSidePanel.prototype.ContinueOrder();
        $("#z-customers a").click();
        Order.prototype.ShowAndSetPayment("#ddlPaymentTypes option:selected", true);
    };
    Order.prototype.RemoveItemFromCart = function (event, ids, isRemoveAllCartItems) {
        if (event.stopPropagation)
            event.stopPropagation();
        var orderId = Order.prototype.GetOrderId();
        var userId = $("#hdnUserId").val();
        $.ajax({
            url: "/Order/RemoveItemFromCart",
            data: { "productIds": ids, "omsOrderId": orderId, "isRemoveAllCartItems": isRemoveAllCartItems, "userId": userId },
            type: 'GET',
            success: function (data) {
                $(".popover").popover('hide');
                if (isRemoveAllCartItems) {
                    if (orderId > 0) {
                        Order.prototype.OnTaxExemptPageLoadCheck();
                    }
                    $("#publishProductDv").html('');
                    $("#publishProductDv").hide();
                    if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
                        $("#couponContainer").html("");
                        $("#csr-discount-status").html("");
                        $("#txtcsrDiscount").val("");
                        $("#div-coupons-promotions").hide();
                    }
                    else {
                        Order.prototype.BindCouponHtml(data.coupons);
                    }
                    Order.prototype.ClearShippingEstimates();
                    Order.prototype.HideLoader();
                    $('*[data-autocomplete-url]').each(function () { autocompletewrapper($(this), $(this).data("onselect-function")); });
                }
            }
        });
    };
    //Display discount view if shopping cart having items other wise hide the discount view. 
    Order.prototype.ShowHideDiscountView = function () {
        if (typeof $("#hdnShoppingCartCount").val() == 'undefined' || $("#hdnShoppingCartCount").val() == '0') {
            $("#div-coupons-promotions").hide();
        }
        else {
            $("#div-coupons-promotions").show();
        }
    };
    Order.prototype.CaptureVoidPayment = function (url) {
        Endpoint.prototype.CaptureVoidPayment(url, function (response) {
            if (response.success) {
                $("#refreshGrid").click();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.DisableCheckouButtonOnReviewPage = function () {
        var priceValue = parseFloat($("#hdnTotalOrderAmount").val());
        if (priceValue >= 0) {
            $("#btnCreateOrder").removeAttr('style');
        }
        else {
            $("#btnCreateOrder").css("display", "none");
        }
        var validQuantity = true;
        if ($("#hdnIsAnyProductOutOfStock").val().toLowerCase() == 'true' || $("#hdnIsAnyProductOutOfStock").val() == true) {
            $("#btnCreateOrder").attr("disabled", "disabled");
        }
        else {
            $("#btnCreateOrder").prop("disabled", false);
        }
        $('tr#cart-row-div').each(function () {
            if ($('#quantity_error_msg_' + $(this).find('#CartQuantity').attr('data-cart-externalid') + '').text().trim() != '') {
                validQuantity = false;
            }
        });
        if (validQuantity) {
            $("#btnCreateOrder").prop("disabled", false);
        }
        else {
            $("#btnCreateOrder").attr("disabled", "disabled");
        }
    };
    Order.prototype.ToggleFreeShipping = function () {
        if ($("#cartFreeShipping").val() != undefined) {
            var freeshipping = $("#cartFreeShipping").val();
            if (freeshipping.toLowerCase() == "true") {
                $("#message-freeshipping").show();
            }
            else {
                $("#message-freeshipping").hide();
            }
        }
    };
    Order.prototype.SetPurchaseOrderNumber = function () {
        var poNumber = $("#PONumber").val();
        if (poNumber != "") {
            $("#PurchaseOrderNumber").val(poNumber);
        }
    };
    Order.prototype.ChangeOrderStatus = function () {
        $("#btnColumnTax").on("click", function () {
            $("#divColumnTax").toggle();
            $("#dynamic-Column-Tax").toggle();
        });
        $("#btnColumnShipping").on("click", function () {
            $("#divColumnShipping").toggle();
            $("#dynamic-shipping-cost").toggle();
        });
        $("#btnCSRDiscountAmount").on("click", function () {
            $("#divCSRDiscountAmount").toggle();
            $("#dynamic-csr-discount-amount").toggle();
        });
        $("#PopUpTaxExemptSubmitOrder #btn-cancel-popup").on("click", function () { $("#chkTaxExempt").prop("checked", false); });
    };
    Order.prototype.DisableManageOrderControls = function () {
        Endpoint.prototype.GetOrderStateValueById($("#hdnOmsOrderStateId").val(), function (response) {
            if (!response.isEdit || parseInt($('#hdnCartCount').val()) <= 0) {
                Order.prototype.FreezeManageOrder(true);
            }
            else {
                Order.prototype.FreezeManageOrder(false);
            }
        });
    };
    Order.prototype.changeShippingMethod = function () {
        var orderId = $("#OmsOrderId").val();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetShippingPanel?omsOrderId=' + orderId + '', 'ShippingPanel');
    };
    Order.prototype.onddlSelectListChange = function (obj) {
        if (obj.id == "ddlOrderStatus") {
            Endpoint.prototype.GetOrderStateValueById($(obj).val(), function (response) {
                Order.prototype.DisableManageOrderControls();
                $("#btnChangeOrderStatus").hide();
                $("#SelectedItemId").val($(obj).val());
                $("#SelectedItemValue").val($(obj).find("option:selected").text());
            });
        }
        else {
            $("#SelectedItemId").val($(obj).val());
            $("#SelectedItemValue").val($(obj).find("option:selected").text());
        }
    };
    Order.prototype.OnOrderStatusChange = function (obj) {
        var currentform = $(obj).closest("form").children();
        var selected = $(obj).find('option:selected');
        var isAnyPendingReturn = this.CheckAnyOrderReturnPending(selected.val());
        if (isAnyPendingReturn) {
            var selectedstatus = currentform.find('#SelectedItemValue').val();
            $(obj).val($(obj).find("option:contains('" + selectedstatus + "')").attr('value'));
            return false;
        }
        if (!(selected.val() == Enum.OrderStatusDropdown.PENDINGAPPROVAL || selected.val() == Enum.OrderStatusDropdown.PENDING)) {
            if (obj.id == "ddlOrderStatus") {
                Order.prototype.DisableManageOrderControls();
                Order.prototype.BindSelectedOptionForStatus(obj);
            }
            else
                Order.prototype.BindSelectedOptionForStatus(obj);
        }
        else {
            var selectedstatus = currentform.find('#SelectedItemValue').val();
            $(obj).val($(obj).find("option:contains('" + selectedstatus + "')").attr('value'));
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorOnSelectPending"), "error", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.BindSelectedOptionForStatus = function (obj) {
        var currentform = $(obj).closest("form").children();
        currentform.find('#SelectedItemValue').val($(obj).find('option:selected').text());
        currentform.find('#SelectedItemId').val($(obj).val());
        $(obj).closest("form").submit();
    };
    Order.prototype.CancelOrder = function () {
        if ($('#ddlOrderStatus').val() != Enum.OrderStatusDropdown.CANCELED && !this.IsAnyPendingReturn()) {
            var form = $('#OrderStatus');
            form.find('#SelectedItemValue').val("CANCELED");
            form.find('#SelectedItemId').val(Enum.OrderStatusDropdown.CANCELED);
            $('#ddlOrderStatus').val(Enum.OrderStatusDropdown.CANCELED);
            form.submit();
        }
    };
    Order.prototype.OnUpdateOrderStatus = function (data) {
        if (data != undefined && data != null && data.SelectedItemId > 0) {
            if (data.pageName == "PaymentStatus") {
                $("#ddlPaymentStatus").val(data.SelectedItemId);
            }
            else {
                $("#ddlOrderStatus").val(data.SelectedItemId);
                $('#hdnOrderStatus').val(data.SelectedItemValue);
                $("#hdnOmsOrderStateId").val(data.SelectedItemId);
                Order.prototype.DisableManageOrderControls();
            }
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.HasError ? data.ErrorMessage : data.SuccessMessage, data.HasError ? "error" : "success", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.UpdateOrderStatus = function (data) {
        if (data != undefined && data != null) {
            $("#ddlListItem").val(data);
            if (data.pageName == "PaymentStatus") {
                $("#labelPaymentStatus").html(data.SelectedItemValue);
                $("#btnChangePaymentStatus").show();
                $("#btnChangePaymentStatus").attr("href", "/order/ManageOrderStatus?omsOrderId=" + Order.prototype.GetOrderId() + "&orderStatus=" + data.SelectedItemValue + "&pageName=PaymentStatus");
            }
            else {
                $("#Order_State").html(data.SelectedItemValue);
                $('#hdnOrderStatus').val(data.SelectedItemValue);
                $("#btnChangeOrderStatus").show();
                $("#btnChangeOrderStatus").attr("href", "/order/ManageOrderStatus?omsOrderId=" + Order.prototype.GetOrderId() + "&orderStatus=" + data.SelectedItemValue + "&pageName=OrderStatus");
                $("#hdnOmsOrderStateId").val(data.SelectedItemId);
                Order.prototype.DisableManageOrderControls();
            }
            $("#divorderStatus").toggle();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.HasError ? data.ErrorMessage : data.SuccessMessage, data.HasError ? "error" : "success", isFadeOut, fadeOutTime);
        }
    };
    Order.prototype.ChangeOrderStatusBegin = function (pageName) {
        var isDefaultSelected = Order.prototype.IsOrderStatusAlreadySelected();
        if (!isDefaultSelected) {
            if ($("#pageName").val() == "PaymentStatus") {
                $("#spnOrderStatus").hide();
                if ($("#ddlPaymentStatus").val() == "" || $("#ddlPaymentStatus").val() == undefined) {
                    $("#spnPaymentStatus").show();
                    return false;
                }
                else {
                    return true;
                }
            }
            else {
                $("#spnPaymentStatus").hide();
                if ($("#ddlOrderStatus").val() == "" || $("#ddlOrderStatus").val() == undefined) {
                    $("#spnOrderStatus").show();
                    return false;
                }
                else {
                    return true;
                }
            }
        }
        else {
            Order.prototype.OnOrderStatusCancelEdit('Order_State', LastSelectedOrderStatus, 'OrderStatus');
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RecordUpdatededSuccessfully"), "success", isFadeOut, fadeOutTime);
            return false;
        }
    };
    //This method will check if order status is default selected Order 
    //if true then it will avoid call to server.
    Order.prototype.IsOrderStatusAlreadySelected = function () {
        if (LastSelectedOrderStatus.trim() == $('#ddlOrderStatus :selected').text())
            return true;
        return false;
    };
    Order.prototype.FreezeManageOrder = function (flag) {
        if (flag) {
            $("#shippingTypes").attr("disabled", true);
            $("#orderInformation select").attr("disabled", true);
            $("#customerInformation a").hide();
            $("#orderInformation input").attr("disabled", true);
            $("#divTotal input").attr("disabled", true);
            $("#chkTaxExempt").attr("disabled", true);
            $('#orderLineItems select').attr("disabled", true);
            $('#orderLineItems input').attr("disabled", true);
            $('#order-discount button').hide();
            $('#order-discount input').attr('disabled', true);
            $("#customerInformation input").hide();
            $(".sp-actions").hide();
            if ($("#hdnTaxCostEdited").val() == "True") {
                $("#chkTaxExempt").attr("disabled", true);
            }
        }
    };
    Order.prototype.UpdateOrderText = function (data) {
        if (data.pagetype == "ShippingView") {
            $("#shipping-cost").text(data.amount);
        }
        else if (data.pagetype == "CSRDiscountAmountView") {
            $("#csr-discount-amount").text(data.amount);
        }
        else if (data.pagetype == "TaxView") {
            $("#tax-cost").text(data.amount);
        }
    };
    Order.prototype.UpdateTrackingNumber = function () {
        Endpoint.prototype.UpdateTrackingNumber($("#OmsOrderId").val(), $("#TrackingNumber").val(), function (response) {
            if (response.success) {
                $("#labelTrackingNumber").html(response.trackingNumber);
                if (!response.isStatusButtonShow) {
                    $("#btnChangeTrackingNumber").hide();
                    $("#divTrackingNumber").hide();
                }
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdatedSuccessfully"), "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdateFailed"), "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.UpdateColumnShipping = function () {
        Endpoint.prototype.UpdateColumnShipping($("#OmsOrderId").val(), $("#ColumnShipping").val(), function (response) {
            if (response.success) {
                $("#labelTrackingNumber").html(response.trackingNumber);
                if (!response.isStatusButtonShow) {
                    $("#divColumnShipping").hide();
                }
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdatedSuccessfully"), "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdateFailed"), "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.UpdateCSRDiscountAmount = function () {
        Endpoint.prototype.UpdateCSRDiscountAmount($("#OmsOrderId").val(), $("#CSRDiscountAmount").val(), function (response) {
            if (response.success) {
                $("#labelTrackingNumber").html(response.trackingNumber);
                if (!response.isStatusButtonShow) {
                    $("#divCSRDiscountAmount").hide();
                }
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdatedSuccessfully"), "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdateFailed"), "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.UpdateTaxCost = function () {
        Endpoint.prototype.UpdateTaxCost($("#OmsOrderId").val(), $("#TaxCost").val(), function (response) {
            if (response.success) {
                $("#labelTaxCost").html(response.trackingNumber);
                if (!response.isStatusButtonShow) {
                    $("#divColumnTax").hide();
                }
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdatedSuccessfully"), "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdateFailed"), "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.UpdateShippingType = function () {
        Endpoint.prototype.UpdateShippingType($("#OmsOrderId").val(), $("#ShippingType").val(), function (response) {
            if (response.success) {
                $("#labelShippingType").html(response.trackingNumber);
                if (!response.isStatusButtonShow) {
                    $("#divShippingTypeName").hide();
                }
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdatedSuccessfully"), "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdateFailed"), "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.UpdateOrderPaymentStatus = function () {
        Endpoint.prototype.UpdateOrderPaymentStatus($("#OmsOrderId").val(), $("#OrderPaymentStatus").val(), function (response) {
            if (response.success) {
                $("#labelOrderPaymentStatus").html(response.trackingNumber);
                if (!response.isStatusButtonShow) {
                    $("#divPaymentStatus").hide();
                }
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdatedSuccessfully"), "success", isFadeOut, fadeOutTime);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("PaymentStatusUpdateFailed"), "error", isFadeOut, fadeOutTime);
            }
        });
    };
    Order.prototype.ShippingErrorMessage = function () {
        if ($("#hdnShippiingErrorMessage").length > 0) {
            var shippingErrorMessage = $("#hdnShippiingErrorMessage").val();
            if ($("#hdnHasError").val().toLowerCase() == "true" && shippingErrorMessage != "" && shippingErrorMessage != null && shippingErrorMessage != 'undefined') {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(shippingErrorMessage, 'error', isFadeOut, 10000);
                return false;
            }
            return true;
        }
    };
    Order.prototype.ShowErrorPaymentDialog = function (message) {
        $("#ErrorPaymentModal").modal({
            "keyboard": true,
            "show": true
        }).find('p').html(message);
    };
    Order.prototype.ShowPaymentProcessDialog = function () {
        $("#PaymentModal").modal({
            "backdrop": "static",
            "keyboard": true,
            "show": true
        });
    };
    Order.prototype.HidePaymentProcessDialog = function () {
        $(".modal-backdrop").remove();
        $("#PaymentModal").modal('hide');
    };
    Order.prototype.ShowHideCustomQuantity = function (control, guid) {
        if ($(control).prop("checked")) {
            $("#custom-quantity-" + guid).show();
        }
        else {
            $("#custom-quantity-" + guid).html("");
            $("#custom-quantity-" + guid).hide();
        }
    };
    Order.prototype.CancleEditCartItem = function (guid) {
        $("#unitprice-" + guid).show();
        $("#unit-price-" + guid).hide();
        $("#quantity-" + guid).show();
        $("#cartQuantity-" + guid).hide();
        $("#shipSeperately_" + guid).hide();
        $("#trackingnumber_" + guid).show();
        $("#tracking-number-" + guid).hide();
        $("#shippingcost_" + guid).show();
        $("#shippingstatus_" + guid).show();
        $("#shipping-status-" + guid).hide();
        $("#unit_price_error_msg_" + guid).html("");
        $("#quantity_error_msg_" + guid).html("");
        $("#partialRefund_error_msg_" + guid).html("");
        $("#ship-seperately-" + guid).text("");
        $("#custom-quantity-" + guid).html("");
        $("#custom-quantity-" + guid).hide();
        $("#edit_" + guid).show();
        $("#update_" + guid).hide();
        $("#reason_" + guid).hide();
        $("#reasonForReturn").hide();
        if ($("[id^=lblpartialRefund_]").text().trim() == '') {
            $("#partialRefund").hide();
            $(".sp-refundlist").hide();
        }
        $("#partialRefund_" + guid).hide();
        $("#returnShipping").hide();
        $("#returnShipping_" + guid).hide();
        $("#partialRefund_" + guid).val(" ");
    };
    Order.prototype.ClearErrorMessages = function (guid) {
        $("#unit_price_error_msg_" + guid).html("");
        $("#quantity_error_msg_" + guid).html("");
        $("#partialRefund_error_msg_" + guid).html("");
    };
    Order.prototype.UpdateCartItem = function (guid) {
        var _orderLineItemDetail = Order.prototype.BindCartItemModel(guid);
        var selectedStatus = $("#shipping-status-" + guid + " :selected");
        $("#shippingstatus_" + guid).attr("data-orderstate", selectedStatus.val());
        $('#IsOrderLineShippingUpdated_' + guid).val("false");
        var quantityError = "#quantity_error_msg_" + guid;
        if (this.CheckForValidRmaConfigured(selectedStatus.text())) {
            if (this.CheckUnitPriceValidations(_orderLineItemDetail.UnitPrice.toString(), guid)) {
                if (this.CheckPartialAmountValidations(_orderLineItemDetail.PartialRefundAmount, $("#extendedPrice_" + guid).text(), guid, selectedStatus.text())) {
                    if (_orderLineItemDetail.Quantity != null && _orderLineItemDetail.Quantity != "") {
                        if (this.CheckCustomQuantityValidations(_orderLineItemDetail.Quantity, _orderLineItemDetail.CustomQuantity, guid, quantityError)) {
                            Endpoint.prototype.UpdateCartItem(_orderLineItemDetail, function (response) {
                                Order.prototype.ClearErrorMessages(guid);
                                Order.prototype.DisplayUpdatedLineItemData(response, guid);
                                Order.prototype.BindCouponHtml(response.coupons);
                                if (response.hasError) {
                                    $(quantityError).html(response.errorMessage);
                                    $(quantityError).show();
                                }
                                else {
                                    $(quantityError).html("");
                                    $(quantityError).hide();
                                }
                                $(".ReturnList_IsShippingReturn").prop("disabled", "disabled");
                            });
                        }
                    }
                    else {
                        Endpoint.prototype.UpdateCartItem(_orderLineItemDetail, function (response) {
                            Order.prototype.CancleEditCartItem(guid);
                            Order.prototype.DisplayUpdatedLineItemData(response, guid);
                            Order.prototype.BindCouponHtml(response.coupons);
                            $(".ReturnList_IsShippingReturn").prop("disabled", "disabled");
                        });
                    }
                }
            }
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorForRma"), "error", isFadeOut, fadeOutTime);
        }
        this.HideShowPartialRefund();
    };
    Order.prototype.CheckMinMaxQuantity = function (quantity, guid, quantityError) {
        var control = $("#cartQuantity-" + guid);
        var minQuantity = $(control).attr("data-cart-minquantity");
        var maxQuantity = $(control).attr("data-cart-maxquantity");
        if (parseFloat(quantity) < parseFloat(minQuantity) || parseFloat(quantity) > parseFloat(maxQuantity)) {
            $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("SelectedQuantityBetween") + minQuantity + ZnodeBase.prototype.getResourceByKeyName("To") + maxQuantity + '.').show();
            return false;
        }
        return true;
    };
    Order.prototype.DisplayUpdatedLineItemData = function (response, guid) {
        if (response.cartView != null && response.cartView != "") {
            $("#divShoppingCart").html("");
            $("#divShoppingCart").html(response.cartView);
            Order.prototype.GetAttributesForLineItem();
            this.HideShowPartialRefund();
            Order.prototype.HideLoader();
        }
        else {
            $("#unitprice-" + guid).text(response.unitPrice);
            $("#shippingcost_" + guid).text(response.shippingCost);
            $("#extendedPrice_" + guid).text(response.extendedPrice);
            $("#quantity-" + guid).text(response.quantity);
            if (response.trackingNumber != null && response.trackingNumber != "")
                $("#trackingnumber_" + guid).html(Order.prototype.MapTrackingNoToURL(response.trackingNumber));
            if (response.orderLineItemStatus != null && response.orderLineItemStatus != "") {
                $("#shippingstatus_" + guid).text(response.orderLineItemStatus);
                $("#shippingstatus_" + guid).attr("data-orderstate", response.orderLineItemStatusId);
            }
            if (response.partialRefund != null && response.partialRefund != undefined && response.partialRefund != "") {
                $("#lblpartialRefund_" + guid).show();
                if (response != null && response.partialRefund != null) {
                    var refundAmount = parseFloat(response.partialRefund);
                    if (refundAmount.toString() == "NaN") {
                        $("#lblpartialRefund_" + guid).text(response.partialRefund);
                    }
                    else {
                        $("#lblpartialRefund_" + guid).text($("#hdnCurrencySymbol_" + guid).val() + parseFloat(response.partialRefund).toFixed(2));
                    }
                }
                else {
                    $("#lblpartialRefund_" + guid).text($("#hdnCurrencySymbol_" + guid).val() + "0.00");
                }
                $("#partialRefund").show();
                $(".sp-refundlist").show();
            }
            if (!response.isEditStatus) {
                $("#actionLinks_" + guid).remove();
                $("#shipping-status-" + guid).attr('disabled', true);
            }
            $("#divTotal").html(response.totalView);
        }
        if (response.returnLineItemView != null && response.returnLineItemView != "") {
            $("#returnLineItems").html(response.returnLineItemView);
            $("#returnLineItems").show();
            Order.prototype.RemovePagingControlsFromGrid();
        }
    };
    Order.prototype.FreezManageOrderForCartCount = function () {
        var cartCount = parseInt($("#hdnCartCount").val());
        if (cartCount < 1) {
            Order.prototype.FreezeManageOrder(true);
            $("#order-discount").hide();
        }
        $("#addProducts").show();
    };
    Order.prototype.BindCartItemModel = function (guid) {
        var _orderLineItemDetail = {
            OrderId: Order.prototype.GetOrderId(),
            Quantity: $("#quantity-" + guid).text(),
            UnitPrice: $("#unit-price-" + guid).val(),
            ProductId: parseInt($("#cartQuantity-" + guid).attr("data-cart-productid")),
            TrackingNumber: $("#tracking-number-" + guid).val(),
            Guid: guid,
            CustomQuantity: $("#custom-quantity-" + guid).val(),
            OrderLineItemStatusId: $("#shipping-status-" + guid).val(),
            ReasonForReturnId: $("#ddlReasonList_" + guid).val(),
            OrderLineItemStatus: $("#shipping-status-" + guid + " :selected").text(),
            ReasonForReturn: $("#ddlReasonList_" + guid + " :selected").text(),
            IsShippingReturn: $("#IsShippingReturn_" + guid).prop("checked"),
            PartialRefundAmount: $("#partialRefund_" + guid).val(),
            OrderLineItemShippingCost: $("#orderLineItemShipping_" + guid).val(),
            IsOrderLineItemShipping: $("#IsOrderLineShippingUpdated_" + guid).val(),
            OriginalOrderLineItemShippingCost: $("#hdnLineItemShipping_" + guid).val()
        };
        return _orderLineItemDetail;
    };
    Order.prototype.CheckUnitPriceValidations = function (unitPrice, guid) {
        var quantityError = "#unit_price_error_msg_" + guid;
        var decimalPoint = unitPrice.split(".")[1] != null ? unitPrice.split(".")[1].length : 0;
        var decimalValue = unitPrice.split(".")[1] != null ? parseInt(unitPrice.split(".")[1]) : 0;
        var priceRoundOff = parseInt($("#unit-price-" + guid).attr("data-priceRoundOff"));
        if (unitPrice == "")
            return true;
        if (this.CheckIsNumeric(unitPrice, quantityError)) {
            if (this.CheckDecimalValue(decimalPoint, decimalValue, priceRoundOff, quantityError, true)) {
                if (parseFloat(unitPrice) > 999999) {
                    $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorPriceRange"));
                    $(quantityError).css("class", "error-msg");
                    return false;
                }
                return true;
            }
        }
        return false;
    };
    Order.prototype.CheckQuantityValidations = function (quantity, guid, quantityError) {
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
    Order.prototype.CheckCustomQuantityValidations = function (quantity, customQuantity, guid, quantityError) {
        if ($("#custom-quantity-" + guid).css("display") != "none") {
            if (this.CheckQuantityValidations(quantity, guid, quantityError)) {
                var custom = parseFloat(customQuantity);
                var actual = parseFloat(quantity);
                if (customQuantity != "") {
                    if (!this.CheckQuantityValidations(customQuantity, guid, quantityError)) {
                        $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidCustomQuantity"));
                        $(quantityError).show();
                        return false;
                    }
                }
                else {
                    $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorQtyRequired"));
                    $(quantityError).show();
                    return false;
                }
                if (custom < 1 || custom > actual) {
                    $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidQuantity"));
                    $(quantityError).show();
                    return false;
                }
                return true;
            }
            return false;
        }
        return true;
    };
    Order.prototype.CheckPartialAmountValidations = function (partialRefundAmount, totalAmount, guid, selectedStatus) {
        var refundAmount = parseFloat(partialRefundAmount);
        var total = Number(totalAmount.replace(/[^0-9\.-]+/g, ""));
        if (refundAmount > 0 || (isNaN(refundAmount) && partialRefundAmount.trim() != "")) {
            var decimalPoint = partialRefundAmount.split(".")[1] != null ? partialRefundAmount.split(".")[1].length : 0;
            var decimalValue = partialRefundAmount.split(".")[1] != null ? parseFloat(partialRefundAmount.split(".")[1]) : 0;
            var priceRoundOff = parseFloat($("#partialRefund_" + guid).attr("data-priceRoundOff"));
            var quantityError = "#partialRefund_error_msg_" + guid;
            if (this.CheckIsNumeric(partialRefundAmount, quantityError)) {
                if (this.CheckDecimalValue(decimalPoint, decimalValue, priceRoundOff, quantityError, true)) {
                    if (refundAmount > total) {
                        $(quantityError).text(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidAmount"));
                        $(quantityError).show();
                        return false;
                    }
                    return true;
                }
            }
            return false;
        }
        else {
            if (selectedStatus.toLowerCase() == "partial refund") {
                $("#partialRefund_error_msg_" + guid).text(ZnodeBase.prototype.getResourceByKeyName("ErrorPartialRefund"));
                $("#partialRefund_error_msg_" + guid).show();
                return false;
            }
            return true;
        }
    };
    //This method is used to get portal list on aside panel
    Order.prototype.GetPortalList = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetPortalList', 'divStoreListAsidePanel');
    };
    Order.prototype.SubmitEditOrder = function () {
        var paymentType = $("#PaymentType").val().toLowerCase();
        paymentType = this.GetPaymentType(paymentType);
        if ($("#OverDueAmount").val() < 0 && (paymentType == 'credit_card' || paymentType == 'amazon_pay') && $('#hdnPaymentStatus').val().toLowerCase() == "authorized") {
            Order.prototype.ShowErrorPaymentDialog(ZnodeBase.prototype.getResourceByKeyName("ErrorCaptureOrder"));
            return;
        }
        var notes = "";
        if ($("#AdditionalNotes").val() != "") {
            notes = $("#AdditionalNotes").val();
        }
        var orderStatus = $('#hdnOrderStatus').val().toLowerCase();
        if (($("#OverDueAmount").val() > 0 && paymentType == 'credit_card' && orderStatus != "cancelled" && orderStatus != "returned")) {
            ZnodeBase.prototype.BrowseAsidePoupPanel('/Order/GetPaymentById?&userId=' + $('#hdnUserId').val() + '&portalId=' + Order.prototype.GetPortalId() + '&paymentType=' + paymentType + '', 'paymentStatusPanel');
        }
        else {
            Order.prototype.UpdateManageOrder(notes);
            Order.prototype.ShowLoader();
        }
    };
    Order.prototype.PlaceOrder = function () {
        var paymentCode = $('#hdnGatewayCode').val();
        if (paymentCode == Constant.CyberSource) {
            if ($('ul#creditCardTab ').find('li.active').find('a').attr('href') == "#savedCreditCard-panel") {
                Order.prototype.SubmitManageOrderPayment("");
            }
            else {
                $("#pay-button").click();
            }
        }
        else {
            Order.prototype.PlaceOrderCheckout();
        }
    };
    ;
    Order.prototype.PlaceOrderCheckout = function () {
        if (Order.prototype.ValidatePayment()) {
            $("#paymentStatusPanel").hide();
            ZnodeBase.prototype.RemovePopupOverlay();
            Order.prototype.setCVVNumber();
            var selectedPaymentText = $("#ddlPaymentTypes option:selected").attr("id");
            var paymentSettingId = $("#ddlPaymentTypes").val();
            selectedPaymentText = this.GetPaymentType(selectedPaymentText);
            $("#paymentStatusPanel").hide();
            ZnodeBase.prototype.RemovePopupOverlay();
            if (selectedPaymentText == "credit_card") {
                Order.prototype.SubmitEditOrderPayment();
            }
        }
    };
    Order.prototype.setCVVNumber = function () {
        CVVNumber = $("[name='SaveCard-CVV']:visible").val();
    };
    Order.prototype.getCVVNumber = function () {
        return CVVNumber;
    };
    Order.prototype.ValidatePayment = function () {
        if ($("#OverDueAmount").val() > 0) {
            if ($("#ddlPaymentTypes option:selected").val() == '') {
                $('#' + $(this).attr('id')).addClass('input-validation-error');
                $('#' + $(this).attr('id')).attr('style', 'border: 1px solid rgb(195, 195, 195)');
                $('span#valPaymentTypes').removeClass('field-validation-valid');
                $('span#valPaymentTypes').addClass('field-validation-error');
                $('span#valPaymentTypes').text(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectPaymentType"));
                return false;
            }
            if ($('span#valPaymentTypes').text().length > 0) {
                $('span#valPaymentTypes').text("");
            }
            var paymentType = $("#ddlPaymentTypes option:selected").attr("id");
            if ($("#hdnGatewayCode").val().toLowerCase() == "cardconnect") {
                if ($("#addNewCreditCard-panel").attr("class").indexOf("active") != -1) {
                    if (Order.prototype.ValidateCardConnectDataToken() && Order.prototype.ValidateCardConnectCardHolderName()) {
                        var cardType = Order.prototype.DetectCardTypeForCardConnect($('#CardDataToken').val());
                        return Order.prototype.ValidateCardType(cardType);
                    }
                    else
                        Order.prototype.ShowErrorPaymentDialog($("#ErrorMessage").val());
                }
                else {
                    var savedCartOptionValue = $("input[name='CCListdetails']:checked").val();
                    if (savedCartOptionValue == null || savedCartOptionValue == "") {
                        Order.prototype.ShowErrorPaymentDialog(ZnodeBase.prototype.getResourceByKeyName("ErrorSavedCreditCardOption"));
                        return false;
                    }
                    return Order.prototype.ValidateCardCVV();
                }
            }
            paymentType = this.GetPaymentType(paymentType);
            if (paymentType == 'credit_card') {
                if (!Order.prototype.ValidateCreditCard())
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
                else {
                    $("#cart-ponumber-status").hide();
                }
            }
        }
        return true;
    };
    Order.prototype.ValidateCardCVV = function () {
        var isValid = true;
        if ($("[name='SaveCard-CVV']:visible").length > 0) {
            var cardtype = $("[name='SaveCard-CVV']:visible").attr('data-cardtype');
            var cvvNumber = $("[name='SaveCard-CVV']:visible").val();
            if (cardtype == Constant.AmericanExpressCardCode) {
                if (!cvvNumber || cvvNumber.length < 4) {
                    isValid = false;
                    OrderSidePanel.prototype.ValidationOfCVV();
                }
            }
            if (!cvvNumber || (cvvNumber.length <= 2 || cvvNumber.length > 4)) {
                isValid = false;
                OrderSidePanel.prototype.ValidationOfCVV();
            }
        }
        return isValid;
    };
    Order.prototype.DetectCardTypeForCardConnect = function (number) {
        var firstDigit = number.toString().substring(1, 2);
        if (firstDigit == 5)
            return 'MASTERCARD';
        else if (firstDigit == 3)
            return 'AMEX';
        else if (firstDigit == 6)
            return 'DISCOVER';
        else if (firstDigit == 4)
            return 'VISA';
        else
            return 'undefined';
    };
    Order.prototype.ValidateCardType = function (cardType) {
        if (cardType.toLowerCase() != $("input[name='PaymentProviders']:checked").val().toLowerCase()) {
            $("#ajaxBusy").dialog('close');
            var message = "The selected card type is of " + $("input[name='PaymentProviders']:checked").val().toLowerCase() + ".  Please check the credit card number and the card type.";
            if (message != undefined) {
                Order.prototype.ShowErrorPaymentDialog(message);
                return false;
            }
            return false;
        }
        return true;
    };
    Order.prototype.ValidateCreditCard = function () {
        var isValid = true;
        var cardType = $('input[name="PaymentProviders"]:checked').val();
        var paymentType = $("#ddlPaymentTypes option:selected").attr("id");
        paymentType = this.GetPaymentType(paymentType);
        if (paymentType == 'credit_card') {
            var paymentCode = $('#hdnGatewayCode').val();
            if (paymentCode == Constant.CyberSource) {
                return isValid;
            }
            var isCCValid_2 = true;
            if ($('#creditCardTab').css('display') == 'block' && $('ul#creditCardTab ').find('li.active').find('a').attr('href') == "#savedCreditCard-panel") {
                var savedCartOptionValue = $("input[name='CCListdetails']:checked").val();
                if (savedCartOptionValue == null || savedCartOptionValue == "") {
                    Order.prototype.ShowErrorPaymentDialog(ZnodeBase.prototype.getResourceByKeyName("ErrorSavedCreditCardOption"));
                    isValid = false;
                    isCCValid_2 = false;
                }
                isValid = Order.prototype.ValidateCardCVV();
            }
            else {
                $('input[data-payment="number"],input[data-payment="exp-month"],input[data-payment="exp-year"],input[data-payment="cardholderName"]').each(function () {
                    if ($.trim($(this).val()) == '') {
                        isValid = false;
                        isCCValid_2 = false;
                        $(this).css({
                            "border": "1px solid red"
                        });
                    }
                    else {
                        $(this).css({
                            "border": "1px solid #c3c3c3"
                        });
                    }
                });
                if (!Order.prototype.Mod10($('input[data-payment="number"]').val())) {
                    isValid = false;
                    isCCValid_2 = false;
                    $('#errornumber').show();
                    $('input[data-payment="number"]').css({
                        "border": "1px solid red"
                    });
                }
                else {
                    $('#errornumber').hide();
                }
                if ($('input[data-payment="exp-month"]').val() > 12 || $('input[data-payment="exp-month"]').val() < 1) {
                    isValid = false;
                    isCCValid_2 = false;
                    $('#errormonth').show();
                    $('input[data-payment="exp-month"]').css({
                        "border": "1px solid red"
                    });
                }
                else {
                    $('#errormonth').hide();
                }
                var currentYear = (new Date).getFullYear();
                var currentMonth = (new Date).getMonth() + 1;
                if ($('input[data-payment="exp-year"]').val() < currentYear) {
                    isValid = false;
                    isCCValid_2 = false;
                    $('#erroryear').show();
                    $('input[data-payment="exp-year"]').css({
                        "border": "1px solid red"
                    });
                }
                else {
                    $('#erroryear').hide();
                }
                if ($('input[data-payment="exp-year"]').val() == currentYear && $('input[data-payment="exp-month"]').val() < currentMonth) {
                    isValid = false;
                    isCCValid_2 = false;
                    $('#errormonth').show();
                    $('input[data-payment="exp-month"]').css({
                        "border": "1px solid red"
                    });
                    $('#erroryear').show();
                    $('input[data-payment="exp-year"]').css({
                        "border": "1px solid red"
                    });
                }
                if ($('input[data-payment="cvc"]').val().length < 3) {
                    isValid = false;
                    isCCValid_2 = false;
                    Order.prototype.ShowHideErrorCVV(true);
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
                        isCCValid_2 = false;
                        Order.prototype.ShowHideErrorCVV(true);
                        Order.prototype.PaymentError("cvc");
                    }
                }
                if ($('input[data-payment="cardholderName"]').val() == '') {
                    $('#errorcardholderName').show();
                }
                else {
                    $('#errorcardholderName').hide();
                }
                if (isCCValid_2 == true) {
                    var cardNumber = Order.prototype.GetCreditCardNumber();
                    var cardType = Order.prototype.DetectCardType(cardNumber);
                    if ($("#addNewCreditCard-panel").attr("class").indexOf("active") != -1) {
                        if (cardType.toLowerCase() != $("input[name='PaymentProviders']:checked").val().toLowerCase()) {
                            $("#ajaxBusy").dialog('close');
                            var message = "The selected card type is of " + $("input[name='PaymentProviders']:checked").val().toLowerCase() + ".  Please check the credit card number and the card type.";
                            if (message != undefined) {
                                Order.prototype.ShowErrorPaymentDialog(message);
                                isValid = false;
                            }
                            isValid = false;
                        }
                    }
                }
            }
            return isValid;
        }
    };
    //To Do: This method is used to select portal from list and show it on textbox
    Order.prototype.OnSelectPortalResult = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            if (window.location.href.toLocaleLowerCase().indexOf("createquoteforcustomer") >= 0) {
                Store.prototype.OnSelectStoreAutocompleteDataBind(item);
                Order.prototype.SetPortalIDOnSelection(parseInt(portalId));
                $(".tab-details").hide(true);
                var userId = $('#hdnUserId').val() == undefined ? $("#labelCustomerId").text().trim() : $("#hdnUserId").val();
                Endpoint.prototype.CreateNewOrderByPortalIdChangeForUser(parseInt(portalId), parseInt(userId), function (response) {
                    var cartData = $.parseHTML(response);
                    Order.prototype.ShippingSameAsBillingHandler();
                    $("#ShoppingCartDiv").html($(cartData).find('#ShoppingCartDiv').html());
                    $("#shippingMethodDiv").html($(cartData).find('#shippingMethodDiv').html());
                });
            }
            else {
                Store.prototype.OnSelectStoreAutocompleteDataBind(item);
                Order.prototype.SetPortalIDOnSelection(parseInt(portalId));
                Order.prototype.GetCatalogListByPortalId(parseInt(portalId), $("#isAllowGlobalLevelUserCreation").val());
                Order.prototype.DisableAllTabs();
                $("#txtCustomerName").prop("disabled", false);
                $("#txtCustomerName").prop("autocomplete", "disableAutocomplete");
                $("#selectedUserName").val("");
            }
        }
    };
    Order.prototype.SetPortalIDOnSelection = function (portalId) {
        $('#selectedPortalId').val(portalId);
        $('#ddlPortal').val(portalId);
        $("#txtPortalName").attr("data-portalid", portalId);
    };
    Order.prototype.CSSofCVVforSavedCard = function () {
        $("[name='SaveCard-CVV']:visible").css({
            "border": "1px solid red",
            "background": "#FFCECE"
        });
        $("[name='SaveCard-CVV']:visible").parent().find("span.field-validation-error").length <= 0 ?
            $("[name='SaveCard-CVV']:visible").parent().append("<span class='field-validation-error error-cvv'>" + ZnodeBase.prototype.getResourceByKeyName("CVVErrorMessage") + "</span>") :
            $("[name='SaveCard-CVV']:visible").parent().find("span.field-validation-error").show();
    };
    //This method is used to select portal from list and show it on textbox
    Order.prototype.GetPortalDetail = function () {
        $("#ZnodeUserPortalList #grid").find("tr").on("click", function () {
            if (window.location.href.toLocaleLowerCase().indexOf("createquoteforcustomer") >= 0) {
                var portalName = $(this).find("td[class='storecolumn']").text();
                var portalId = $(this).find("td")[0].innerHTML;
                Order.prototype.SetPortalOnSelection(portalName, parseInt(portalId));
                $(".tab-details").hide(true);
                var userId = $('#hdnUserId').val() == undefined ? $("#labelCustomerId").text().trim() : $("#hdnUserId").val();
                Endpoint.prototype.CreateNewOrderByPortalIdChangeForUser(parseInt(portalId), parseInt(userId), function (response) {
                    var cartData = $.parseHTML(response);
                    Order.prototype.ShippingSameAsBillingHandler();
                    $("#ShoppingCartDiv").html($(cartData).find('#ShoppingCartDiv').html());
                    $("#shippingMethodDiv").html($(cartData).find('#shippingMethodDiv').html());
                });
                $("#divStoreListAsidePanel").html('');
                ZnodeBase.prototype.RemovePopupOverlay();
            }
            else {
                var portalName = $(this).find("td[class='storecolumn']").text();
                var portalId = $(this).find("td")[0].innerHTML;
                Order.prototype.SetPortalOnSelection(portalName, parseInt(portalId));
                Order.prototype.GetCatalogListByPortalId(parseInt(portalId), $("#isAllowGlobalLevelUserCreation").val());
                ZnodeBase.prototype.RemovePopupOverlay();
            }
        });
    };
    Order.prototype.SetPortalOnSelection = function (portalName, portalId) {
        $('#txtPortalName').val(portalName);
        $('#PortalId').val(portalId);
        $('#selectedPortalId').val(portalId);
        $('#ddlPortal').val(portalId);
        $("#txtPortalName").attr("data-portalid", portalId);
        $("#errorRequiredStore").text('').text("").removeClass("field-validation-error").hide();
        $("#txtPortalName").removeClass('input-validation-error');
        $('#divStoreListAsidePanel').hide(700);
    };
    Order.prototype.UpdateManageOrder = function (notes) {
        Endpoint.prototype.UpdateManageOrder(Order.prototype.GetOrderId(), notes, function (data) {
            if (data.hasError)
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.errorMessage, "error", isFadeOut, fadeOutTime);
            else {
                Order.prototype.CheckOrderStateAndPaymentType(data);
                window.location.reload(true);
            }
            //Condition for checking default order status to show print button for packaging slip.
            if (data.SelectedItemValue && data.SelectedItemValue.toString().toLowerCase() == "shipped") {
                $("#packingSlipLink").show();
            }
            else {
                $("#packingSlipLink").hide();
            }
        });
    };
    Order.prototype.CheckOrderStateAndPaymentType = function (data) {
        var paymentType = $("#PaymentType").val().toLowerCase();
        var orderState = data.OrderState != null ? data.OrderState.toLowerCase() : "";
        var receiverEmail = data.UserName;
        if (paymentType == 'purchase_order' && orderState == 'shipped') {
            Endpoint.prototype.SendPoEmail(receiverEmail, Order.prototype.GetOrderId(), function (response) { });
        }
    };
    Order.prototype.CheckoutReceipt = function (action, orderId, receiptHtml, isEmailSend) {
        var form = $('<form action="CheckoutReceipt" method="post">' +
            '<input type="hidden" name="orderId" value="' + orderId + '" />' +
            '<input type="text" name= "ReceiptHtml" value= "' + receiptHtml + '" />' +
            '<input type="hidden" name= "IsEmailSend" value= ' + isEmailSend + ' />' +
            '</form>');
        form.attr("action", action);
        $('body').append(form);
        $(form).submit();
        return true;
    };
    Order.prototype.OnConfirmSubmitOrder = function () {
        if (!Order.prototype.ShowAllowedTerritoriesError())
            return false;
        $('#PopUpConfirmSubmitOrder').modal('show');
    };
    Order.prototype.HideTrackingNumber = function () {
        $("#btnChangeTrackingNumber").hide();
    };
    Order.prototype.HideStatusForUpdate = function () {
        LastSelectedOrderStatus = $('#labelPaymentStatus').text();
        $("#btnChangePaymentStatus").hide();
    };
    Order.prototype.HideOrderStatusForUpdate = function () {
        LastSelectedOrderStatus = $('#Order_State').text();
        $("#btnChangeOrderStatus").hide();
    };
    Order.prototype.SetOrderStatusForUpdate = function (orderStatus) {
        $("#ddlOrderStatus option").filter(function () {
            return $(this).text() == orderStatus;
        }).attr('selected', true);
    };
    Order.prototype.OnCapturedSubmitOrder = function () {
        $('#PopUpCapturedSubmitOrder').modal('show');
    };
    Order.prototype.HideCSRDiscountAmountForUpdate = function () {
        $('#CSRDiscountAmount').hide();
    };
    Order.prototype.HideTaxCostForUpdate = function () {
        $('#TaxCostAmount').hide();
    };
    Order.prototype.HideShippingCostForUpdate = function () {
        $('#ShippingCostAmount').hide();
    };
    Order.prototype.HideShippingAccountNumber = function () {
        $("#btnChangeShippingAccountNumber").hide();
    };
    Order.prototype.HideShippingMethod = function () {
        $("#btnChangeShippingMethod").hide();
    };
    Order.prototype.OnOrderCancelEdit = function (id, value) {
        if ($("#hdnShippingTrackingUrl").val() == "") {
            $("#" + id).html(value);
        }
        else {
            $("#" + id).html("<a target=_blank href=" + $("#hdnShippingTrackingUrl").val() + value + ">" + value + "</a>");
        }
        $("#btnChangeTrackingNumber").show();
    };
    Order.prototype.OnShippingAccountNumberCancelEdit = function (id, value) {
        $("#" + id).html(value);
        $("#btnChangeShippingAccountNumber").show();
    };
    Order.prototype.OnShippingMethodCancelEdit = function (id, value) {
        $("#" + id).html(value);
        $("#btnChangeShippingMethod").show();
    };
    Order.prototype.MapTrackingNoToURL = function (value) {
        if ($("#hdnShippingTrackingUrl").val() == "") {
            return value;
        }
        else {
            return "<a target=_blank href=" + $("#hdnShippingTrackingUrl").val() + value + ">" + value + "</a>";
        }
    };
    Order.prototype.OnTotalTableCancelEdit = function (pageName, value) {
        var roundOffDigits = $("#hdnRoundOffDigits").val();
        if (roundOffDigits == '' || roundOffDigits == undefined || roundOffDigits == null)
            roundOffDigits = 3;
        if (pageName == "CSRDiscountAmountView") {
            $("#dynamic-csr-discount-amount").html("$" + parseFloat(value).toFixed(roundOffDigits));
            $("#CSRDiscountAmount").show();
        }
        else if (pageName == "TaxView") {
            $("#dynamic-Column-Tax").html(value);
            $("#TaxCostAmount").show();
        }
        else {
            $("#dynamic-shipping-cost").html("$" + parseFloat(value).toFixed(roundOffDigits));
            $("#ShippingCostAmount").show();
        }
    };
    Order.prototype.ConfirmCapturedOrder = function (omsOrderId, token, status) {
        window.location.href = "/Order/CapturePayment?omsOrderId=" + omsOrderId + "&paymentTransactionToken=" + token + "&PaymentStatus=" + status;
    };
    Order.prototype.OnOrderStatusCancelEdit = function (id, value, pageName) {
        $("#" + id).html(value);
        if (pageName == "PaymentStatus") {
            $("#btnChangePaymentStatus").show();
        }
        else {
            $("#btnChangeOrderStatus").show();
        }
    };
    Order.prototype.SubmitEditOrderPayment = function () {
        if (!Order.prototype.ShowAllowedTerritoriesError())
            return false;
        var Total = $("#hdnTotalAmt").val();
        if (Order.prototype.IsOrderTotalGreaterThanZero(Total)) {
            Order.prototype.GetEncryptedAmount(Total);
            var payment = Order.prototype.GetPaymentModel();
            $("#div-CreditCard").hide();
            submitCard(payment, function (response) {
                if (response.GatewayResponse == undefined) {
                    if (response.indexOf("Unauthorized") > 0) {
                        Order.prototype.ClearPaymentAndDisplayMessage('We were unable to process your credit card payment. <br /><br />Reason:<br />' + response + '<br /><br />If the problem persists, contact us to complete your order.');
                    }
                }
                else {
                    var isSuccess = response.GatewayResponse.IsSuccess;
                    if (isSuccess) {
                        var submitPaymentViewModel = {
                            OmsOrderId: Order.prototype.GetOrderId,
                            PaymentSettingId: $('#PaymentSettingId').val(),
                            PaymentCode: $('#hdnPaymentCode').val(),
                            CustomerShippingAddressId: response.GatewayResponse.CustomerShippingAddressId,
                            PaymentApplicationSettingId: $('#hdnPaymentApplicationSettingId').val(),
                            CustomerProfileId: response.GatewayResponse.CustomerProfileId,
                            CustomerPaymentId: response.GatewayResponse.CustomerPaymentProfileId,
                            CustomerGuid: response.GatewayResponse.CustomerGUID,
                            PaymentToken: $("input[name='CCdetails']:checked").val(),
                            AdditionalInfo: $("#AdditionalNotes").val(),
                            CreditCardNumber: $("#hdnCreditCardNumber").val(),
                            OrderNumber: $("#hdnOrderNumber").val(),
                        };
                        submitPaymentViewModel["CardSecurityCode"] = payment["CardSecurityCode"];
                        Endpoint.prototype.SubmitEditOrderpayment(submitPaymentViewModel, function (response) {
                            $("#ajaxBusy").dialog('close');
                            if (response === undefined || response.Data === undefined || response.Data.OrderId === undefined || response.Data.OrderId <= 0 || response.Data.HasError == true) {
                                var errorMessage = response.Data == undefined || response.Data.ErrorMessage == undefined || response.Data.ErrorMessage == "" ? ZnodeBase.prototype.getResourceByKeyName("ErrorOrderPlace") : response.Data.ErrorMessage;
                                Order.prototype.ClearPaymentAndDisplayMessage(errorMessage);
                                return false;
                            }
                            else {
                                location.reload(true);
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
        }
    };
    Order.prototype.GetPaymentModel = function () {
        var Total = $("#hdnTotalAmt").val();
        if ($("#ajaxProcessPaymentError").html() != undefined) {
            $("#ajaxProcessPaymentError").html(ZnodeBase.prototype.getResourceByKeyName("ProcessingPayment"));
        }
        var cardNumber;
        var CardExpirationMonth;
        var CardExpirationYear;
        var CardHolderName;
        if ($("#hdnGatewayCode").val() == "cardconnect" || $("#hdnGatewayCode").val() == Constant.CyberSource) {
            cardNumber = $('#CardDataToken').val();
            CardExpirationMonth = $("#CardExpirationDate").val().substring(4);
            CardExpirationYear = $("#CardExpirationDate").val().substring(0, 4);
            CardHolderName = $("#cardconnectCardHolderName").val();
        }
        else {
            cardNumber = Order.prototype.GetCreditCardNumber();
            ;
            CardExpirationMonth = $("#div-CreditCard [data-payment='exp-month']").val();
            CardExpirationYear = $("#div-CreditCard [data-payment='exp-year']").val();
            CardHolderName = $("#div-CreditCard [data-payment='cardholderName']").val();
        }
        if (cardNumber != "") {
            $("#hdnCreditCardNumber").val(cardNumber.slice(-4));
        }
        else {
            var card = $("input[name='CCListdetails']:checked").next().html();
            if (card != "") {
                $("#hdnCreditCardNumber").val(card.split(" ")[3]);
            }
        }
        var IsAnonymousUser = $("#hdnAnonymousUser").val();
        var guid = $('#GUID').val();
        var discount = $('#dynamic-discount-amount').text().substring(1);
        var ShippingCost = $('#ShippingCost').val();
        var SubTotal = $('#dynamic-subtotal-amount').text().substring(1);
        var cardType = $("#hdnGatewayCode").val() == "cardconnect" ? Order.prototype.DetectCardTypeForCardConnect($('#CardDataToken').val()) : Order.prototype.DetectCardType(Order.prototype.GetCreditCardNumber());
        var orderNumber = "";
        $("#PortalId").val();
        Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) { orderNumber = response.orderNumber; });
        Order.prototype.ShowPaymentProcessDialog();
        var paymentSettingId = $('#PaymentSettingId').val();
        var paymentCode = $('#hdnPaymentCode').val();
        var CustomerPaymentProfileId = $('#CustomerPaymentProfileId').val();
        var CustomerProfileId = $('#CustomerProfileId').val();
        var CardDataToken = $('#CardDataToken').val();
        var billingEmail = $('#address_email').text().trim();
        if (billingEmail == "" || billingEmail == undefined || billingEmail == null) {
            billingEmail = $('#hdnEmailId').val().trim();
        }
        //var stateCode = $('#UserAddressDataViewModel_BillingAddress_StateName').val();
        //if ($("#UserAddressDataViewModel_BillingAddress_StateCode").val() != undefined && $("#UserAddressDataViewModel_BillingAddress_StateCode").val() != null && $("#UserAddressDataViewModel_BillingAddress_StateCode").val() != "") {
        //    stateCode = $("#UserAddressDataViewModel_BillingAddress_StateCode").val();
        //}
        var stateCode = $("#hdnstateCode").val();
        if (billingEmail == undefined && billingEmail == null) {
            billingEmail = $('#hdnGuestUserName').val();
        }
        var gatewayCode = $("#hdnGatewayCode").val();
        if (gatewayCode.toLowerCase() == 'payflow') {
            if ($("#hdnEncryptedTotalAmount").val() != undefined && $("#hdnEncryptedTotalAmount").val() != null) {
                Total = $("#hdnEncryptedTotalAmount").val();
            }
        }
        var paymentModel = {
            "GUID": guid,
            "GatewayType": gatewayCode,
            "BillingCity": $('#UserAddressDataViewModel_BillingAddress_CityName').val(),
            "BillingCountryCode": $('#UserAddressDataViewModel_BillingAddress_CountryName').val(),
            "BillingFirstName": $('#UserAddressDataViewModel_BillingAddress_FirstName').val(),
            "BillingLastName": $('#UserAddressDataViewModel_BillingAddress_LastName').val(),
            "BillingPhoneNumber": $('#UserAddressDataViewModel_BillingAddress_PhoneNumber').val(),
            "BillingPostalCode": $('#UserAddressDataViewModel_BillingAddress_PostalCode').val(),
            "BillingStateCode": $('#UserAddressDataViewModel_BillingAddress_StateName').val(),
            "BillingStreetAddress1": $('#UserAddressDataViewModel_BillingAddress_Address1').val(),
            "BillingStreetAddress2": $('#UserAddressDataViewModel_BillingAddress_Address2').val(),
            "BillingEmailId": billingEmail,
            "ShippingCost": ShippingCost,
            "ShippingCity": $('#UserAddressDataViewModel_ShippingAddress_CityName').val(),
            "ShippingCountryCode": $('#UserAddressDataViewModel_ShippingAddress_CountryName').val(),
            "ShippingFirstName": $('#UserAddressDataViewModel_ShippingAddress_FirstName').val(),
            "ShippingLastName": $('#UserAddressDataViewModel_ShippingAddress_LastName').val(),
            "ShippingPhoneNumber": $('#UserAddressDataViewModel_ShippingAddress_PhoneNumber').val(),
            "ShippingPostalCode": $('#UserAddressDataViewModel_ShippingAddress_PostalCode').val(),
            "ShippingStateCode": $('#UserAddressDataViewModel_ShippingAddress_StateName').val(),
            "ShippingStreetAddress1": $('#UserAddressDataViewModel_ShippingAddress_Address1').val(),
            "ShippingStreetAddress2": $('#UserAddressDataViewModel_ShippingAddress_Address2').val(),
            "SubTotal": SubTotal,
            "Total": Total,
            "Discount": discount,
            "CardNumber": cardNumber,
            "CreditCardNumber": $("#hdnCreditCardNumber").val(),
            "CardExpirationMonth": CardExpirationMonth,
            "CardExpirationYear": CardExpirationYear,
            "CardExpirationDate": $("#CardExpirationDate").val(),
            "GatewayCurrencyCode": $('#hdnCurrencyCode').val(),
            "CustomerPaymentProfileId": CustomerPaymentProfileId,
            "CustomerProfileId": CustomerProfileId,
            "CardDataToken": CardDataToken,
            "CardType": cardType,
            "PaymentSettingId": paymentSettingId,
            "PaymentCode": paymentCode,
            "IsAnonymousUser": IsAnonymousUser,
            "IsSaveCreditCard": $("#SaveCreditCard").is(':checked'),
            "CardHolderName": CardHolderName,
            "CustomerGUID": $("#hdnCustomerGUID").val(),
            "OrderId": orderNumber,
            "PaymentToken": ($("#addNewCreditCard-panel").attr("class").indexOf("active") != -1) ? "" : $("input[name='CCListdetails']:checked").val(),
            "CompanyName": $('#UserAddressDataViewModel_ShippingAddress_CompanyName').val()
        };
        paymentModel["CardSecurityCode"] = paymentModel["PaymentToken"] ? Order.prototype.getCVVNumber() : $("#div-CreditCard [data-payment='cvc']").val();
        return paymentModel;
    };
    Order.prototype.GetACHPaymentModel = function () {
        var Total = $("#hdnTotalAmt").val();
        if ($("#ajaxProcessPaymentError").html() != undefined) {
            $("#ajaxProcessPaymentError").html(ZnodeBase.prototype.getResourceByKeyName("ProcessingPayment"));
        }
        var cardNumber;
        if ($("#hdnGatewayCode").val() == "cardconnect") {
            cardNumber = $('#CardDataToken').val();
        }
        else {
            cardNumber = Order.prototype.GetCreditCardNumber();
            ;
        }
        if (cardNumber != "") {
            $("#hdnCreditCardNumber").val(cardNumber.slice(-4));
        }
        else {
            var card = $("input[name='CCListdetails']:checked").next().html();
            if (card != "") {
                $("#hdnCreditCardNumber").val(card.split(" ")[3]);
            }
        }
        var IsAnonymousUser = $("#hdnAnonymousUser").val();
        var guid = $('#GUID').val();
        var discount = $('#dynamic-discount-amount').text().substring(1);
        var ShippingCost = $('#ShippingCost').val();
        var SubTotal = $('#dynamic-subtotal-amount').text().substring(1);
        var cardType = $("#hdnGatewayCode").val() == "cardconnect" ? Order.prototype.DetectCardTypeForCardConnect($('#CardDataToken').val()) : Order.prototype.DetectCardType(Order.prototype.GetCreditCardNumber());
        var orderNumber = "";
        $("#PortalId").val();
        Endpoint.prototype.GenerateOrderNumber($("#hdnPortalId").val(), function (response) { orderNumber = response.orderNumber; });
        Order.prototype.ShowPaymentProcessDialog();
        var paymentSettingId = $('#PaymentSettingId').val();
        var paymentCode = $('#hdnPaymentCode').val();
        var CustomerPaymentProfileId = $('#CustomerPaymentProfileId').val();
        var CustomerProfileId = $('#CustomerProfileId').val();
        var CardDataToken = $('#CardDataToken').val();
        var billingEmail = $('#address_email').text().trim();
        if (billingEmail == "" || billingEmail == undefined || billingEmail == null) {
            billingEmail = $('#hdnEmailId').val().trim();
        }
        if (billingEmail == undefined && billingEmail == null) {
            billingEmail = $('#hdnGuestUserName').val();
        }
        var gatewayCode = $("#hdnGatewayCode").val();
        if (gatewayCode.toLowerCase() == 'payflow') {
            if ($("#hdnEncryptedTotalAmount").val() != undefined && $("#hdnEncryptedTotalAmount").val() != null) {
                Total = $("#hdnEncryptedTotalAmount").val();
            }
        }
        var paymentModel = {
            "GUID": guid,
            "GatewayType": gatewayCode,
            "BillingCity": $('#UserAddressDataViewModel_BillingAddress_CityName').val(),
            "BillingCountryCode": $('#UserAddressDataViewModel_BillingAddress_CountryName').val(),
            "BillingFirstName": $('#UserAddressDataViewModel_BillingAddress_FirstName').val(),
            "BillingLastName": $('#UserAddressDataViewModel_BillingAddress_LastName').val(),
            "BillingPhoneNumber": $('#UserAddressDataViewModel_BillingAddress_PhoneNumber').val(),
            "BillingPostalCode": $('#UserAddressDataViewModel_BillingAddress_PostalCode').val(),
            "BillingStateCode": $('#UserAddressDataViewModel_BillingAddress_StateName').val(),
            "BillingStreetAddress1": $('#UserAddressDataViewModel_BillingAddress_Address1').val(),
            "BillingStreetAddress2": $('#UserAddressDataViewModel_BillingAddress_Address2').val(),
            "BillingEmailId": billingEmail,
            "ShippingCost": ShippingCost,
            "ShippingCity": $('#UserAddressDataViewModel_ShippingAddress_CityName').val(),
            "ShippingCountryCode": $('#UserAddressDataViewModel_ShippingAddress_CountryName').val(),
            "ShippingFirstName": $('#UserAddressDataViewModel_ShippingAddress_FirstName').val(),
            "ShippingLastName": $('#UserAddressDataViewModel_ShippingAddress_LastName').val(),
            "ShippingPhoneNumber": $('#UserAddressDataViewModel_ShippingAddress_PhoneNumber').val(),
            "ShippingPostalCode": $('#UserAddressDataViewModel_ShippingAddress_PostalCode').val(),
            "ShippingStateCode": $('#UserAddressDataViewModel_ShippingAddress_StateName').val(),
            "ShippingStreetAddress1": $('#UserAddressDataViewModel_ShippingAddress_Address1').val(),
            "ShippingStreetAddress2": $('#UserAddressDataViewModel_ShippingAddress_Address2').val(),
            "SubTotal": SubTotal,
            "Total": Total,
            "Discount": discount,
            "CardNumber": cardNumber,
            "CreditCardNumber": $("#hdnCreditCardNumber").val(),
            "GatewayCurrencyCode": $('#hdnCurrencyCode').val(),
            "CustomerPaymentProfileId": CustomerPaymentProfileId,
            "CustomerProfileId": CustomerProfileId,
            "CardDataToken": CardDataToken,
            "CardType": cardType,
            "PaymentSettingId": paymentSettingId,
            "PaymentCode": paymentCode,
            "IsAnonymousUser": IsAnonymousUser,
            "IsSaveCreditCard": $("#SaveACHAccount").is(':checked'),
            "CustomerGUID": $("#hdnCustomerGUID").val(),
            "OrderId": orderNumber,
            "PaymentToken": ($("#addNewACHAccount-panel").attr("class").indexOf("active") != -1) ? "" : $("input[name='CCListdetails']:checked").val(),
            "CompanyName": $('#UserAddressDataViewModel_ShippingAddress_CompanyName').val(),
            "IsACHPayment": true
        };
        return paymentModel;
    };
    Order.prototype.OnLineItemStatusChange = function (guid) {
        var originalStatus = $('#shippingstatus_' + guid).attr('data-orderstate');
        if ($("#shipping-status-" + guid).val() != originalStatus && this.IsAnyPendingReturn()) {
            $("#shipping-status-" + guid).val(originalStatus);
        }
        else {
            Order.prototype.ClearErrorMessages(guid);
            $("#quantity_error_msg_" + guid).text("");
            $("#quantity_error_msg_" + guid).hide();
            if ($("#shipping-status-" + guid).val() != $("#shippingstatus_" + guid).attr('data-orderstate') && $("#shipping-status-" + guid).val() == 50) {
                $("#shipping-status-" + guid).val($("#shippingstatus_" + guid).attr('data-orderstate'));
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorOnSelectPending"), "error", isFadeOut, fadeOutTime);
            }
            var shippingStatusListControl = $("#shipping-status-" + guid);
            if (shippingStatusListControl != null) {
                var orderLineItemStatus = $("#shipping-status-" + guid + " :selected").val();
                this.SetLineItemAttributes(orderLineItemStatus, guid);
                //Enable or disable shipping amount field depend upon status
                this.ManageOrderLineItemShippingInput(orderLineItemStatus, guid);
            }
            var partialRefundProductcount = 0;
            $("#layout-cart [id ^= 'lblpartialRefund']").each(function (e) {
                if ($(this).html() != "" || $("input[id ^= 'partialRefund']").is(":visible")) {
                    partialRefundProductcount = partialRefundProductcount + 1;
                }
            });
            if (partialRefundProductcount > 0) {
                $("#partialRefund").show();
                $(".sp-refundlist").show();
            }
            else {
                $("#partialRefund").hide();
                $("input[id ^= 'partialRefund']").hide();
                $(".sp-refundlist").hide();
            }
            if (!($("select[id ^= 'ddlReasonList_']").is(":visible"))) {
                $('#divShoppingCart .sp-returned-reason').hide();
                $('.sp-shipping-status').hide();
            }
        }
    };
    Order.prototype.SetLineItemAttributes = function (orderLineItemStatus, guid) {
        switch (orderLineItemStatus) {
            case Enum.OrderStatusDropdown.RETURNED:
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessageReturnedReturn"), "error", isFadeOut, fadeOutTime);
                $("#shipping-status-" + guid).val($("#shippingstatus_" + guid).attr('data-orderstate'));
                //Order.prototype.GetAttributesForReturn(guid)
                break;
            case Enum.OrderStatusDropdown.PARTIALREFUND:
                Order.prototype.GetAttributesForPartialRefund(guid);
                break;
            case Enum.OrderStatusDropdown.SHIPPED:
                Order.prototype.GetAttributesForShipped(guid);
                break;
            case Enum.OrderStatusDropdown.SUBMITTED:
                Order.prototype.GetAttributesForSubmitted(guid);
                break;
            case Enum.OrderStatusDropdown.PENDINGAPPROVAL:
                Order.prototype.GetAttributesForPendingApproval(guid);
                break;
            default:
                Order.prototype.GetAttributeForDefault(guid);
                break;
        }
    };
    Order.prototype.GetAttributesForReturn = function (guid) {
        var shippingcost = Number($("#shippingcost_" + guid).text().replace(/[^0-9\.-]+/g, ""));
        if (Order.prototype.ValidateLineItemForReturnStatus(guid)) {
            if ($("#DownloadableProductKey_" + guid).val() == "True") {
                $("#custom-quantity-" + guid).hide();
            }
            else {
                $("#custom-quantity-" + guid).show();
                $("#custom-quantity-" + guid).val('');
            }
            $("#returnShipping").hide();
            $("#quantity-" + guid).show();
            $("#unitprice-" + guid).show();
            $("#unit-price-" + guid).hide();
            $("#partialRefund_" + guid).hide();
            $(".sp-returned-reason").show();
            if ($("#ShipSeperately_" + guid).val() == "True") {
                $("#trackingnumber_" + guid).show();
                $(".sp-shipping-status").show();
                $("#sp-shipping-status").show();
                $("#tracking-number-" + guid).hide();
                if (shippingcost > 0) {
                    $("#returnShipping").show();
                    $("#returnShipping_" + guid).show();
                }
            }
            $("#reason_" + guid).html("");
            Endpoint.prototype.GetReasonsForReturn(function (response) {
                var data = response.data;
                var selectControl = "<select id='ddlReasonList_" + guid + "' name= 'Reason' ></select>";
                $("#reason_" + guid).html(selectControl);
                $("#reason_" + guid).show();
                $("#reasonForReturn").show();
                $.each(data, function (i) {
                    var optionhtml = '<option value="' +
                        data[i].Value + '">' + data[i].Text + '</option>';
                    $("#ddlReasonList_" + guid).append(optionhtml);
                });
            });
        }
    };
    Order.prototype.GetAttributesForPartialRefund = function (guid) {
        $("#returnShipping_" + guid).hide();
        $("#quantity-" + guid).show();
        $("#custom-quantity-" + guid).hide();
        $("#unitprice-" + guid).show();
        $("#unit-price-" + guid).hide();
        $("#reason_" + guid).html("");
        $("#tracking-number-" + guid).hide();
        $("#custom-quantity-" + guid).hide();
        $("#custom-quantity-" + guid).val('');
        $("#cartQuantity-" + guid).hide();
        $("#trackingnumber_" + guid).show();
        $("#partialRefund").show();
        $(".sp-refundlist").show();
        $("#partialRefund_" + guid).show();
        if ($("#lblpartialRefund_" + guid).text().trim() != '')
            $("#lblpartialRefund_" + guid).show();
    };
    Order.prototype.GetAttributesForShipped = function (guid) {
        $("#returnShipping_" + guid).hide();
        $("#custom-quantity-" + guid).hide();
        $("#unitprice-" + guid).show();
        $("#unit-price-" + guid).hide();
        $("#unit-price-" + guid).val('');
        $("#quantity-" + guid).show();
        $("#tracking-number-" + guid).hide();
        $("#reason_" + guid).html("");
        if ($("[id^=lblpartialRefund_]").text().trim() == '')
            $("#partialRefund_" + guid).hide();
        else {
            $("#partialRefund").show();
            $(".sp-refundlist").show();
            $("#lblpartialRefund_" + guid).show();
        }
        $("#trackingnumber_" + guid).hide();
        $("#tracking-number-" + guid).show();
        if ($("#shippingstatus_" + guid).attr('data-orderstate') != Enum.OrderStatusDropdown.SHIPPED) {
            $("#custom-quantity-" + guid).show();
            $("#custom-quantity-" + guid).val('');
        }
        $("#tracking-number-" + guid).val($("#trackingnumber_" + guid).html());
    };
    Order.prototype.GetAttributesForSubmitted = function (guid) {
        $("#returnShipping_" + guid).hide();
        $("#custom-quantity-" + guid).hide();
        $("#unitprice-" + guid).show();
        $("#unit-price-" + guid).hide();
        $("#unit-price-" + guid).val('');
        $("#reason_" + guid).html("");
        if ($("#DownloadableProductKey_" + guid).val() == "True") {
            $("#quantity-" + guid).show();
        }
        $("#tracking-number-" + guid).hide();
        $("#partialRefund_" + guid).hide();
        if ($("#trackingnumber_" + guid).length > 0)
            $("#trackingnumber_" + guid).show();
    };
    Order.prototype.GetAttributesForPendingApproval = function (guid) {
        $("#returnShipping_" + guid).hide();
        $("#custom-quantity-" + guid).hide();
        $("#unitprice-" + guid).show();
        $("#unit-price-" + guid).hide();
        $("#unit-price-" + guid).val('');
        $("#quantity-" + guid).show();
        $("#tracking-number-" + guid).hide();
        $("#partialRefund_" + guid).hide();
        $("#reason_" + guid).html("");
        if ($("#trackingnumber_" + guid).length > 0)
            $("#trackingnumber_" + guid).show();
    };
    Order.prototype.GetAttributeForDefault = function (guid) {
        $("#returnShipping_" + guid).hide();
        $("#custom-quantity-" + guid).hide();
        $("#unitprice-" + guid).show();
        $("#unit-price-" + guid).hide();
        $("#unit-price-" + guid).val('');
        $("#quantity-" + guid).show();
        $("#tracking-number-" + guid).hide();
        $("#reason_" + guid).html("");
        if ($("#trackingnumber_" + guid).length > 0)
            $("#trackingnumber_" + guid).show();
        $("#lblpartialRefund_" + guid).show();
        $("#partialRefund_" + guid).hide();
    };
    Order.prototype.CheckForValidRmaConfigured = function (shippingStatus) {
        if (shippingStatus.toLowerCase() == "returned") {
            return ($("#hdnIsValidForRma").val() == "True");
        }
        else {
            return true;
        }
        ;
    };
    Order.prototype.IsAnyPendingReturn = function () {
        if (typeof $('#IsAnyPendingReturn').val() === "undefined" || $('#IsAnyPendingReturn').val().toLowerCase() == "false")
            return false;
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("IsAnyPendingReturnMessage"), "error", isFadeOut, fadeOutTime);
            return true;
        }
    };
    Order.prototype.ShowCustomQuantity = function (guid) {
        $("#unitprice-" + guid).show();
        if ($("#unit-price-" + guid).val() != null && $("#unit-price-" + guid).val() != "") {
            var unitPriceLength = $("#unitprice-" + guid).text().split(',').length;
            var unitPrice = Order.prototype.PriceAsFloat($("#unitprice-" + guid).text());
            $("#unit-price-" + guid).val(unitPrice);
        }
        $("#unit_price_error_msg_" + guid).html("");
        $("#unit-price-" + guid).hide();
        $("#quantity-" + guid).show();
        var cartQuantity = parseFloat($("#quantity-" + guid).text());
        $("#cartQuantity-" + guid).hide();
        $("#cartQuantity-" + guid).val(cartQuantity);
        var cartCount = parseInt($("#hdnCartCount").val());
        if (cartQuantity > 1) {
            $("#custom-quantity-" + guid).show();
            $("#custom-quantity-" + guid).val('');
        }
    };
    Order.prototype.CheckForReturnItem = function (guid, quantityError) {
        if ($("#shipping-status-" + guid + " :selected").val() == Enum.OrderStatusDropdown.RETURNED) {
            var cartQuantity = parseFloat($("#quantity-" + guid).text());
            var cartCount = parseInt($("#hdnCartCount").val());
            if (cartCount < 2) {
                var customQuantity = parseFloat($("#custom-quantity-" + guid).val());
                if (cartQuantity > 1 && customQuantity < 1) {
                    $(quantityError).text("Please specify custom Quantity to return item.");
                    return false;
                }
            }
        }
        return true;
    };
    Order.prototype.SendReturnedOrderMail = function () {
        var orderId = $("#OmsOrderId").val();
        if (orderId > 0) {
            Endpoint.prototype.SendReturnedOrderEmail(orderId, function (response) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.hasError ? "success" : "error", isFadeOut, fadeOutTime);
            });
        }
        else
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorOrderId"), "error", isFadeOut, fadeOutTime);
    };
    Order.prototype.PriceAsFloat = function (price) {
        return parseFloat(price.replace(/[^0-9.,]/g, "").replace(/[^\d\.]/g, '.'));
    };
    Order.prototype.ValidateLineItemForReturn = function (guid) {
        var paymentType = $("#PaymentType").val().toLowerCase();
        paymentType = this.GetPaymentType(paymentType);
        if ((paymentType == 'credit_card' || paymentType == 'amazon_pay') && $('#hdnPaymentStatus').val().toLowerCase() == "authorized") {
            Order.prototype.ShowErrorPaymentDialog(ZnodeBase.prototype.getResourceByKeyName("ErrorCaptureOnReturnOrder"));
            $("#shipping-status-" + guid).val("");
            return false;
        }
        return true;
    };
    Order.prototype.ValidateLineItemForReturnStatus = function (guid) {
        var paymentType = $("#PaymentType").val().toLowerCase();
        paymentType = this.GetPaymentType(paymentType);
        if ((paymentType == 'credit_card' || paymentType == 'amazon_pay') && $('#hdnPaymentStatus').val().toLowerCase() == "authorized") {
            Order.prototype.ShowErrorPaymentDialog(ZnodeBase.prototype.getResourceByKeyName("ErrorCaptureOnReturnOrder"));
            $("#shipping-status-" + guid).val($("#shippingstatus_" + guid).attr('data-orderstate'));
            return false;
        }
        return true;
    };
    Order.prototype.RemoveAllCartSuccess = function () {
        $("#couponContainer").html("");
        $("#csr-discount-status").html("");
        $("#txtcsrDiscount").val("");
        $("#div-coupons-promotions").hide();
        $("#RequiredgiftCardErrorMessage").html('');
        $("#giftCardMessageContainer").html("");
        Order.prototype.ClearShippingEstimates();
        Order.prototype.DisablePaymentAndReviewTab();
        //TODO:OMS
        //Order.prototype.ClickSelectedTab("z-shopping-cart");
    };
    Order.prototype.ShowAllowedTerritoriesError = function () {
        var orderId = Order.prototype.GetOrderId();
        if ($("#dynamic-allowesterritories").length > 0) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AllowedTerritories"), "error", isFadeOut, fadeOutTime);
            return false;
        }
        if ($("#hndShippingclassName").val() != undefined && $("#hndShippingclassName").val() == Constant.ZnodeCustomerShipping && orderId > 0) {
            if ($("#txtAccountNumber").val().trim() == undefined || $("#txtAccountNumber").val().trim() == "") {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterAccountNumber"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
            if ($("#txtShippingMethod").val().trim() == undefined || $("#txtShippingMethod").val().trim() == "") {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterShippingMethod"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
        }
        if ($("#CSRDiscountAmount").val() > 0) {
            return Order.prototype.IsValidCSRDiscountApplied();
        }
        return true;
    };
    Order.prototype.UpdateOrderTextDetails = function (data) {
        var pageType = $(data).closest("form").attr("id");
        var amount = $(data).find('input[type="text"]').val();
        if (amount && !isNaN(amount)) {
            switch (pageType) {
                case "ShippingView":
                    if (amount < 0) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorShippingtAmountNegative"), "error", isFadeOut, fadeOutTime);
                        this.ResetOriginalPrice(data);
                        return false;
                    }
                    return true;
                case "CSRDiscountAmountView":
                    if (amount < 0) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorCSRDisountNegative"), "error", isFadeOut, fadeOutTime);
                        this.ResetOriginalPrice(data);
                        return false;
                    }
                    return true;
                default:
                    return true;
            }
        }
        else {
            this.ResetOriginalPrice(data);
            return false;
        }
    };
    //round off price as per global setting
    Order.prototype.UpdatePriceSuccessCallback = function (data) {
        var form = $(data).closest("form");
        var input = $(form).find('input[type="text"]');
        var amount = 0;
        if (input.val()) {
            amount = parseFloat(input.val());
        }
        var roundOff = input.attr('data-priceroundoff');
        $("#" + input.attr('id')).val(amount.toFixed(parseInt(roundOff)));
    };
    Order.prototype.UpdateReturnShippingHistory = function (omsOrderLineItemsId, checkbox) {
        Endpoint.prototype.UpdateReturnShippingHistory(omsOrderLineItemsId, $("#OmsOrderId").val(), $(checkbox).prop("checked"), function (response) {
        });
    };
    Order.prototype.GetPortalId = function () {
        return $("#txtPortalName").attr("data-portalid") != undefined ? parseInt($("#txtPortalName").attr("data-portalid")) : parseInt($("#PortalId").val());
    };
    Order.prototype.GetUserId = function () {
        return $('#hdnUserId').val() == undefined ? parseInt($("#labelCustomerId").text().trim()) : parseInt($("#hdnUserId").val());
    };
    Order.prototype.PrintOnPackageSlip = function (OmsOrderLineItemsId) {
        Endpoint.prototype.PrintOnPackageSlip(Order.prototype.GetOrderId(), OmsOrderLineItemsId, function (response) {
            var originalContents = document.body.innerHTML;
            document.body.innerHTML = response;
            window.print();
            document.body.innerHTML = originalContents;
        });
    };
    //CheckboxClearOnload(): any {
    //    if (CheckBoxCollection.length <= 0)
    //        $("#ZnodeOrder #grid").find("input:checkbox").attr("checked", false);
    //}
    Order.prototype.AddCustomShipping = function (code) {
        $(".dev-custom-shipping").hide();
        $("#div_" + code + "").show();
    };
    // Add and edit CustomShipping.
    Order.prototype.AddEditCustomShipping = function (code) {
        $(".dev-custom-shipping").hide();
        var shippingId = $("#" + code + "").val();
        $(".ShippingOptionsWithRates").show();
        $("#ShippingId_" + shippingId + "").hide();
        var shippingValue = $("#" + code).attr("data-ShippingValue");
        $("#ShippingDollar_" + shippingId + "").show();
        $("#div_" + code + "").show();
        if (shippingValue != undefined) {
            $("#CustomShipping_" + code + "").val(shippingValue.replace("$", ""));
        }
    };
    Order.prototype.CancelCustomShipping = function (code) {
        $("#div_" + code + "").hide();
        $("#CustomShipping_" + code + "").val("");
        Order.prototype.ShowEditCustomShipping(code);
    };
    Order.prototype.AddCustomShippingAmount = function (customShippingCost, estimateShippingCost, isRemove) {
        if (isRemove === void 0) { isRemove = false; }
        if ((customShippingCost != "" && customShippingCost != null && typeof customShippingCost != "undefined") || isRemove) {
            var isQuote = Order.prototype.IsQuote();
            Endpoint.prototype.AddCustomShippingAmount(customShippingCost.replace("$", ""), estimateShippingCost, $("#hdnUserId").val(), isQuote, function (response) {
                if (response == true) {
                    $("#hdnCustomShippingCost").val(customShippingCost);
                    var orderId = Order.prototype.GetOrderId();
                    var portalId = Order.prototype.GetPortalId();
                    var userId = $("#hdnUserId").val();
                    //Calculate the shopping cart
                    Order.prototype.CalculateShoppingCart(userId, portalId, orderId);
                }
            });
        }
    };
    Order.prototype.GetPaymentType = function (paymentTypeId) {
        if (paymentTypeId) {
            var paymentType = $("#ddlPaymentTypes " + "#" + paymentTypeId).attr("data-payment-type");
            if (paymentType != undefined) {
                return paymentType.toLowerCase();
            }
            else {
                return paymentTypeId;
            }
        }
    };
    Order.prototype.DeclinePendingPayment = function () {
        var quoteIds = $("#OmsQuoteId").val();
        var statusId = 0;
        var isPendingPaymentStatus = true;
        var orderStatus = 'Decline';
        Endpoint.prototype.DeclinePendingPayment(quoteIds, statusId, isPendingPaymentStatus, orderStatus, function (res) {
            $("[data-id='PaymentOrderStatus']").val(res.paymentStatus);
            if (res.status == true) {
                $("#btnAccept").hide();
                $("#btnDecline").hide();
            }
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? 'success' : 'error', isFadeOut, fadeOutTime);
        });
    };
    Order.prototype.AcceptPendingPayment = function () {
        var userId = $('#UserId').val();
        Endpoint.prototype.UpdateBillingAccountNumber(userId, function (res) {
            if (res != "") {
                $("#divBillingAccountNumber").modal("show");
                $("#divBillingAccountNumber").html(res);
            }
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
        });
    };
    Order.prototype.HideShowPartialRefund = function () {
        if ($("#partialRefund").is(":visible")) {
            $(".sp-refundlist").show();
        }
        else {
            $(".sp-refundlist").hide();
        }
    };
    //This method is used to select store from fast select and show it on textbox
    Order.prototype.OnSelectStoreAutocompleteDataBind = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            Endpoint.prototype.GetOrderList(0, 0, portalId, portalName, function (response) {
                $("#orderList").html("");
                $("#orderList").html(response);
                ZnodeDateRangePicker.prototype.Init(Order.prototype.DateTimePickerRange());
            });
        }
    };
    Order.prototype.AutoCompleteApprovalUsers = function () {
        $("#txtCustomerName").autocomplete({
            source: function (request, response) {
                try {
                    if (request.term.length >= 3) {
                        var portalId = parseInt($("#txtPortalName").attr("data-portalid"));
                        $("#selectedPortalId").val(portalId);
                        ZnodeBase.prototype.ShowLoader();
                        Endpoint.prototype.GetUsersByPhoneNoOrUserName(request.term, portalId, function (res) {
                            if (res.length > 0) {
                                response($.map(res, function (item) {
                                    ZnodeBase.prototype.HideLoader();
                                    return {
                                        label: item.UserName,
                                        userid: item.UserId,
                                    };
                                }));
                            }
                        });
                    }
                }
                catch (err) {
                }
            },
            select: function (event, ui) {
                $("#selectedUserId").val(ui.item.userid);
                Order.prototype.SetCustomerDetailsByUserId();
            }
        });
    };
    Order.prototype.SetCustomerDetailsByUserId = function () {
        var userId = $("#selectedUserId").val();
        var cartParameter = {
            "UserId": userId,
            "PortalId": Order.prototype.GetPortalId(),
            "PublishedCatalogId": $("#PortalCatalogId").val(),
            "IsQuote": Order.prototype.IsQuote(),
        };
        $("#hdnUserId").val(userId);
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.BindCustomerDetails(cartParameter, function (response) {
            var cartData = $.parseHTML(response);
            $("#txtCustomerName").val($(cartData).find('#UserAddressDataViewModel_FullName').val());
            $("#selectedUserName").val($(cartData).find('#UserAddressDataViewModel_FullName').val());
            $('#CustomerNameError').text('');
            $("#hdnAccountId").val($(cartData).find('#hdnAccountId').val());
            Order.prototype.SetUserDetailsbyHtml(cartData);
            Order.prototype.RemoveUserNameValidation();
            Order.prototype.HideLoader();
        });
    };
    Order.prototype.OnShippingAddressSelectionChange = function () {
        ZnodeBase.prototype.ShowLoader();
        var addressId = $("#ShippingAddress").val();
        var otherAddressId = $("#BillingAddress").val();
        var isQuote = $("#IsQuote").val();
        var isB2BUser = ($("#hdnAccountId").val() > 0) ? true : false;
        Endpoint.prototype.SetCustomerAddress(addressId, otherAddressId, "shipping", isB2BUser, $("#hdnUserId").val(), Order.prototype.GetPortalId(), $("#hdnAccountId").val(), isQuote, function (response) {
            $("#customerAddresses").html(response.Data.addressView);
            ZnodeBase.prototype.HideLoader();
            if (response.Data.isShippingAddressChange) {
                Order.prototype.ClearShippingEstimates();
                $("#divTotal").html("");
                $("#divTotal").html(response.Data.totalView);
            }
        });
    };
    Order.prototype.OnBillingAddressSelectionChange = function () {
        ZnodeBase.prototype.ShowLoader();
        var otherAddressId = $("#ShippingAddress").val();
        var addressId = $("#BillingAddress").val();
        var isQuote = $("#IsQuote").val();
        var isB2BUser = ($("#hdnAccountId").val() > 0) ? true : false;
        Endpoint.prototype.SetCustomerAddress(addressId, otherAddressId, "billing", isB2BUser, $("#hdnUserId").val(), Order.prototype.GetPortalId(), $("#hdnAccountId").val(), isQuote, function (response) {
            $("#customerAddresses").html(response.Data.addressView);
            ZnodeBase.prototype.HideLoader();
        });
    };
    Order.prototype.GetPublishProductsList = function () {
        ZnodeBase.prototype.ShowPartialLoader("loader-productlist");
        var portalCatalogId = $("#PortalCatalogId").val();
        var portalId = Order.prototype.GetPortalId();
        var userId = Order.prototype.GetUserId();
        Endpoint.prototype.GetPublishProductsList(portalCatalogId, portalId, userId, function (response) {
            $("#productListDiv").html('');
            $('#productListDiv').html(response);
            $("#grid").find("tr").addClass('preview-link');
            ZnodeBase.prototype.HidePartialLoader("loader-productlist");
        });
    };
    Order.prototype.ValidateUsername = function () {
        if ($("#txtCustomerName").val() != $("#selectedUserName").val()) {
            $("#txtCustomerName").val($("#selectedUserName").val());
        }
        Order.prototype.RemoveUserNameValidation();
    };
    Order.prototype.RemoveUserNameValidation = function () {
        if ($("#txtCustomerName").val()) {
            $("#txtCustomerName").removeClass("input-validation-error");
            $('span[id^="CustomerNameError"]').remove();
        }
    };
    Order.prototype.GetPaymentMethods = function () {
        ZnodeBase.prototype.ShowLoader();
        var portalId = Order.prototype.GetPortalId();
        var userId = Order.prototype.GetUserId();
        var selectedPaymentOption = $("#PaymentSettingId").val();
        if (selectedPaymentOption == null || selectedPaymentOption == undefined || selectedPaymentOption == '' || selectedPaymentOption == 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetPaymentMethods(portalId, userId, function (response) {
                if (response != null) {
                    $("#paymentMethodsDiv").html('');
                    $('#paymentMethodsDiv').append(response);
                }
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    //Save Manage Order Details
    Order.prototype.SaveFields = function (data) {
        if (this.IsAnyPendingReturn()) {
            $("#" + data.id).val(data.defaultValue);
        }
        else {
            $(data).closest("form").submit();
        }
    };
    Order.prototype.SaveInHandDate = function (data) {
        $(data).closest("form").submit();
    };
    //Get Manage Order Additional note pop up
    Order.prototype.GetAdditionalNote = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanelWithCallBack('/Order/GetAdditionalNotes', 'AdditionalNotes', function (response) {
            $('#Notes').val($('#AdditionalNotes').val());
        });
    };
    Order.prototype.ValidateCardConnectDataToken = function () {
        var token = $("#CardDataToken").val();
        if (token != null && token != "" && token != 'undefined')
            return true;
        else {
            if ($("#ErrorMessage").val() == "")
                $("#ErrorMessage").val(ZnodeBase.prototype.getResourceByKeyName("ErrorCardDetails"));
            return false;
        }
    };
    Order.prototype.ErrorDisplayCyberSourcePayment = function () {
        if ($("#ErrorMessage").val() == "")
            $("#ErrorMessage").val(ZnodeBase.prototype.getResourceByKeyName("ErrorCardDetails"));
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper($("#ErrorMessage").val(), "error", isFadeOut, fadeOutTime);
    };
    Order.prototype.ValidateCardConnectCardHolderName = function () {
        var name = $("#cardconnectCardHolderName").val();
        if (name != null && name != "" && name != 'undefined' && name.trim().length <= 100)
            return true;
        else {
            $("#ErrorMessage").val($("#errorcardconnectcardholderName").text());
            return false;
        }
    };
    //Bind the added note
    Order.prototype.SaveAddedNote = function () {
        var notes = $('#Notes').val();
        $('#AdditionalNotes').val(notes);
        ZnodeBase.prototype.CancelUpload('AdditionalNotes');
    };
    //Get Shipping List for manage order
    Order.prototype.GetShippingList = function () {
        Endpoint.prototype.GetShippingList(Order.prototype.GetOrderId(), function (response) {
            var data = response.status;
            var shippingList = data.ShippingList;
            var currentSelectected = $('#shippingTypes option:selected').val();
            $('#shippingTypes').empty();
            $.each(shippingList, function (index, element) {
                $('#shippingTypes').append($("<option value=\"" + element.ShippingId + "\"  class = \"" + element.ClassName + "\" ><text>" + element.Description + "</text></option>"));
                if (element.ShippingId == currentSelectected)
                    $("#shippingTypes option[value=" + element.ShippingId + "]").attr('selected', 'selected');
            });
            Order.prototype.CheckIsOldOrder();
        });
    };
    //Bind the selected shipping
    Order.prototype.GetSelectedShipping = function (data) {
        var isOldOrder = $("#hdnIsOldOrder").val();
        if (!this.IsAnyPendingReturn() || (typeof isOldOrder === "undefined" || isOldOrder.toLowerCase() == "true")) {
            var currentTarget = $(data).find('option:selected');
            if (currentTarget.attr('value') != undefined && currentTarget.attr('class') != undefined) {
                Order.prototype.ShippingSelectHandler(parseInt(currentTarget.attr('value')), currentTarget.attr('class'));
            }
        }
    };
    Order.prototype.GetAttributesForLineItem = function () {
        $("li[data-cart-lineitem]").each(function () {
            var guid = $(this).data('cart-lineitem');
            Order.prototype.OnLineItemStatusChange(guid);
        });
    };
    Order.prototype.GetCartCount = function () {
        var userId = Order.prototype.GetUserId();
        var portalId = Order.prototype.GetPortalId();
        var isQuote = Order.prototype.IsQuote();
        Endpoint.prototype.GetCartCount(userId, portalId, function (response) {
            $('#cart-count').html((isQuote ? "Quote: " : "Cart: ") + response + " " + "Items");
        });
    };
    Order.prototype.BindOrderData = function (shippingType) {
        Order.prototype.DisableManageOrderControls();
        Order.prototype.GetShippingList();
        Order.prototype.OnTaxExemptPageLoadCheck();
        Order.prototype.OrderStatusTrackingNumHideShow(shippingType);
        Order.prototype.DisableShippingType();
    };
    //TODO: OMS Manage Order
    Order.prototype.DisableShippingType = function () {
        if ($("#hdnEstimateShippingCost").val() != "" && $("#hdnEstimateShippingCost").val() != null && typeof $("#hdnEstimateShippingCost").val() != "undefined")
            $("#btnShippingType").hide();
    };
    Order.prototype.GetCreditCardNumber = function () {
        return $("#div-CreditCard [data-payment='number']").val().replace(/ /g, '');
    };
    Order.prototype.SetCreateOrderViewModel = function () {
        var CreateOrderViewModel = {
            UserId: $('#hdnUserId').val(),
            ShippingId: $('#selectedShippingId').val(),
            PaymentTypeId: $("#ddlPaymentTypes").val(),
            PurchaseOrderNumber: $("#PurchaseOrderNumber").val(),
            EnableAddressValidation: $("#enableAddressValidation").val(),
            AccountId: $("#hdnAccountId").val(),
            AdditionalInstructions: $("#additionalInstructions").val(),
            AccountNumber: $("#ShippingListViewModel_AccountNumber").val(),
            ShippingMethod: $("#ShippingListViewModel_ShippingMethod").val(),
            InHandDate: $("#InHandDate").val(),
            JobName: $("#JobName").val(),
            ShippingConstraintCode: $("input[name='ShippingConstraintCode']:checked").val(),
            IsQuote: Order.prototype.IsQuote()
        };
        return CreateOrderViewModel;
    };
    Order.prototype.DisablePaymentAndReviewTab = function () {
        $('#payment-tab-link').addClass("disabled");
        $('#paymentMethodsDiv').html();
        Order.prototype.DisableReviewTab();
    };
    Order.prototype.SetCustomerTableData = function () {
        $("[data-swhgcontainer=ZnodeOrderCustomer]").find("tr").addClass('preview-link');
        $('#DropDownId1').find('input#UserId').closest('li').remove(); /*To Remove CustomerId search Field from column dropdown*/
    };
    Order.prototype.ToggleShowHideDetails = function (control) {
        if ($(control).find("i").hasClass("z-up")) {
            $(control).find("span").text($(control).attr('data-show-details'));
            $(control).find("i").removeClass("z-up").addClass("z-down");
        }
        else {
            $(control).find("span").text($(control).attr('data-hide-details'));
            $(control).find("i").removeClass("z-down").addClass("z-up");
        }
    };
    Order.prototype.DisableAllTabs = function () {
        if ($("#hdnUserId").val() == "0") {
            Order.prototype.DisableCartAndShippingTab();
            Order.prototype.DisablePaymentAndReviewTab();
        }
    };
    Order.prototype.ShowTaxDetails = function (element) {
        var taxSummary = $(element).closest("#taxTotalDiv").find("#TaxSummary");
        if (taxSummary.is(':visible')) {
            taxSummary.hide();
        }
        else {
            taxSummary.show();
        }
    };
    Order.prototype.DisableCartAndShippingTab = function () {
        $('#shipping-cart-tab-link').addClass("disabled");
        $('#shipping-cart-tab').html();
    };
    Order.prototype.DisableReviewTab = function () {
        $('#review-placeorder-tab-link').addClass("disabled");
        $('#ReviewDiv').html();
    };
    Order.prototype.EnablePaymentTab = function () {
        $('#payment-tab-link').click();
    };
    Order.prototype.DisableEnablePaymentMethod = function () {
        if (($("#hdnTotalOrderAmount").val() == undefined || $("#hdnTotalOrderAmount").val() > 0.00) && ($("#hdnOverDueAmount").val() >= 0.00)) {
            $("#ddlPaymentTypes").prop("disabled", false);
        }
        else {
            $(".HidePaymentTypeDiv").hide();
            $("#div-COD").show();
            $("#ddlPaymentTypes").val($("#ddlPaymentTypes option:first").val());
            $("#ddlPaymentTypes").prop("disabled", true);
        }
    };
    //Save order line item shipping
    Order.prototype.SaveOrderLineItemShipping = function (event) {
        var target = $(event.target);
        var newShippingvalue = target.val();
        var extenalId = target.next().next('#hdnExternalId').val();
        var oldShippingValue = target.next('#hdnLineItemShipping_' + extenalId).val();
        var matches = newShippingvalue.match(/^-?[\d.]+(?:e-?\d+)?$/);
        var isAnyPendingReturn = this.IsAnyPendingReturn();
        if (matches == null || !newShippingvalue || newShippingvalue < 0 || isAnyPendingReturn) {
            target.val(oldShippingValue);
            event.stopImmediatePropagation();
            return false;
        }
        $('#IsOrderLineShippingUpdated_' + extenalId).val("true");
        return true;
    };
    //Enable or disable shipping amount field
    Order.prototype.ManageOrderLineItemShippingInput = function (orderLineItemStatus, guid) {
        if (orderLineItemStatus == Enum.OrderStatusDropdown.SHIPPED || orderLineItemStatus == Enum.OrderStatusDropdown.FAILED) {
            $("#orderLineItemShipping_" + guid).prop("disabled", true);
        }
        else {
            $("#orderLineItemShipping_" + guid).prop("disabled", false);
        }
    };
    //Check any return pending & if yes then avoid certain order status to update
    Order.prototype.CheckAnyOrderReturnPending = function (orderStatus) {
        var isAnyPendingReturn = $('#IsAnyPendingReturn').val();
        if (isAnyPendingReturn.toLowerCase() == "true") {
            if (orderStatus == Enum.OrderStatusDropdown.FAILED || orderStatus == Enum.OrderStatusDropdown.CANCELED || orderStatus == Enum.OrderStatusDropdown.ORDERRECEIVED
                || orderStatus == Enum.OrderStatusDropdown.PENDINGPAYMENT || orderStatus == Enum.OrderStatusDropdown.SENDING || orderStatus == Enum.OrderStatusDropdown.WAITINGTOSHIP
                || orderStatus == Enum.OrderStatusDropdown.INPROGRESS || orderStatus == Enum.OrderStatusDropdown.INPRODUCTION || orderStatus == Enum.OrderStatusDropdown.INVOICED
                || orderStatus == Enum.OrderStatusDropdown.SHIPPED || orderStatus == Enum.OrderStatusDropdown.SUBMITTED) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("IsAnyPendingReturnMessage"), "error", isFadeOut, fadeOutTime);
                return true;
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    };
    //To set the original price to input
    Order.prototype.ResetOriginalPrice = function (data) {
        var input = $(data).find('input[type="text"]');
        var defaultAmount = input.prop("defaultValue");
        if (defaultAmount) {
            defaultAmount = parseFloat(defaultAmount);
            var roundOff = input.attr('data-priceroundoff');
            $("#" + input.attr('id')).val(defaultAmount.toFixed(parseInt(roundOff)));
        }
    };
    /* This method will check whether the order is old order or not & will show the notification on edit screen
     to notify the admin that this is old order. So if any updation do so it will work as per new oms calculation flow
     & may impact the calculation in case of absent data in old order */
    Order.prototype.ShowOldOrderNotification = function (isAnOldOrder) {
        if (typeof isAnOldOrder === "undefined" || isAnOldOrder.toLowerCase() == "false")
            return false;
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("IsAnOldOrderMessage"), "error", false, 36000000);
            return true;
        }
    };
    Order.prototype.CheckIsOldOrder = function () {
        var isOldOrder = $("#hdnIsOldOrder").val();
        if (typeof isOldOrder !== "undefined" && isOldOrder.toLowerCase() == "true") {
            var currentTarget = $('#shippingTypes');
            Order.prototype.GetSelectedShipping(currentTarget);
        }
    };
    Order.prototype.DownloadPODocument = function () {
        var PODocumentPath = $("#hdnPODocumentPath").val();
        if (typeof PODocumentPath !== undefined && PODocumentPath !== "" && PODocumentPath != null) {
            event.preventDefault();
            window.open(PODocumentPath, "_blank");
            ZnodeBase.prototype.HideLoader();
        }
    };
    Order.prototype.ReorderCompleteOrder = function () {
        var userId = parseInt($("#hdnUserId").val());
        var orderId = parseInt($('#hdnManageOmsOrderId').val());
        var portalId = parseInt($('#hdnPortalId').val());
        if (userId > 0 && orderId > 0 && portalId > 0) {
            window.location.href = "/Order/ReorderCompleteOrder?userId=" + userId + "&portalId=" + portalId + "&omsOrderId=" + orderId;
        }
    };
    Order.prototype.HideAuthorizeIframe = function () {
        $("#divAuthorizeNetIFrame").hide();
        $("#ddlPaymentTypes option:selected").prop("selected", false);
    };
    return Order;
}(ZnodeBase));
//On Focus out of CreditCardNumber changed
$(document).on("blur", "#CreditCardNumber", function () {
    var CreditCardNumber = $('input[data-payment="number"]').val().split(" ").join("");
    if (!Order.prototype.Mod10(CreditCardNumber) && CreditCardNumber != "") {
        $('#errornumber').show();
        Order.prototype.PaymentError("number");
        return false;
    }
    else {
        $('#errornumber').hide();
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="number"]');
    }
});
$(document).on('blur', "input#CreditCardCVCNumberSaved", function () {
    Order.prototype.ValidateCVV();
});
//On Focus out of CreditCardCVCNumber changed
$(document).on("blur", "#CreditCardCVCNumber", function () {
    var cardType = $('input[name="PaymentProviders"]:checked').val();
    if ($('input[data-payment="cvc"]').val().length < 3 && $('input[data-payment="cvc"]').val() != "") {
        $('#errorcvc').show();
        Order.prototype.PaymentError("cvc");
        return false;
    }
    else if (cardType == Constant.AmericanExpressCardCode && $('input[data-payment="cvc"]').val().length < 4 && $('input[data-payment="cvc"]').val() != "") {
        $('#errorcvc').show();
        Order.prototype.PaymentError("cvc");
        return false;
    }
    else {
        $('#errorcvc').hide();
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cvc"]');
    }
});
//On Focus out of CardHolderName changed
$(document).on("blur", "#CardHolderName", function () {
    if ($('input[data-payment="cardholderName"]').val().trim() == "") {
        $('#errorcardholderName').show();
        Order.prototype.PaymentError("cardholderName");
        return false;
    }
    else {
        $('#errorcardholderName').hide();
        Order.prototype.RemoveCreditCardValidationCSS('input[data-payment="cardholderName"]');
    }
});
//On Focus out of ExpirationMonth format changed
$(document).on("focusout", "input[data-payment='exp-month']", function () {
    var monthVal = $('input[data-payment="exp-month"]').val();
    if (monthVal.length == 1 && (monthVal >= 1 && monthVal <= 9)) {
        monthVal = 0 + monthVal;
        $('input[data-payment="exp-month"]').val(monthVal);
    }
});
$('[data-attr = "data-toggle-tab"]').on('shown.bs.tab', function (e) {
    var activeTab = ($(e.target).attr("href")).split('#')[1]; // newly activated tab
    /* var previousActiveTab = ($(e.relatedTarget).attr("href")).split('#')[1]; */ // previous active tab
    switch (activeTab) {
        case "customer-tab":
            $('#btnNextTabName').text('Add Products');
            $("#btnNextTab").show();
            $("#btnPlaceOrder").hide();
            break;
        case "shipping-cart-tab":
            if (Order.prototype.IsQuote()) {
                $('#btnNextTabName').text('Add Notes');
            }
            else {
                $('#btnNextTabName').text('Review');
            }
            $("#btnNextTab").show();
            $("#btnPlaceOrder").hide();
            break;
        case "payment-tab":
            Order.prototype.ValidateShipping();
            if (Order.prototype.IsQuote()) {
                $('#btnNextTabName').text('Review And Save Quote');
                $("#btnNextTab").show();
                $("#btnPlaceOrder").hide();
            }
            else {
                $('#btnNextTabName').text('Review And Place Order');
                $("#btnNextTab").hide();
                $("#btnPlaceOrder").show();
                Order.prototype.GetPaymentMethods();
            }
            Order.prototype.GetCartCount();
            if (!Order.prototype.IsQuote()) {
                Order.prototype.DisableEnablePaymentMethod();
            }
            if (isValidCvvSaved)
                Order.prototype.ShowAndSetPayment("#ddlPaymentTypes", true);
            break;
        case "review-placeorder-tab":
            if (Order.prototype.IsQuote()) {
                Quote.prototype.ReviewQuote();
                $("#btnNextTab").hide();
                $("#btnPlaceOrder").show();
            }
            else {
                Order.prototype.ReviewOrder();
                $("#btnNextTab").show();
                $("#btnPlaceOrder").hide();
                $('#btnNextTabName').text('Make Payment');
            }
            break;
    }
});
//# sourceMappingURL=Order.js.map