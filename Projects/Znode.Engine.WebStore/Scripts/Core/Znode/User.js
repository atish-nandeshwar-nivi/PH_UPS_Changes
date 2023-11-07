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
var User = /** @class */ (function (_super) {
    __extends(User, _super);
    function User() {
        var _this = _super.call(this) || this;
        _this.isPaymentInProcess = false;
        return _this;
    }
    User.prototype.Init = function () {
        User.prototype.RemoveIconWishlist();
        User.prototype.LoadQuote();
        User.prototype.RestrictEnterButton();
        User.prototype.BindStates(null);
        User.prototype.RemoveCaptchaValidationMessage();
    };
    User.prototype.RestrictEnterButton = function () {
        $('#frmUpdateQuoteQuantity').on('keyup keypress', function (e) {
            var keyCode = e.keyCode || e.which;
            if (keyCode === 13) {
                e.preventDefault();
                return false;
            }
        });
    };
    User.prototype.LogOffUser = function () {
        if (typeof amazon !== 'undefined') {
            ZnodeBase.prototype.ShowLoader();
            amazon.Login.logout();
            window.setInterval(function () { return User.prototype.LogOff(); }, 1800);
            ZnodeBase.prototype.HideLoader();
        }
        else
            User.prototype.LogOff();
    };
    User.prototype.RemoveIconWishlist = function () {
        $("#layout-account-wishlist .wishlist-item-remove a").on("click", function (ev) {
            ev.preventDefault();
            User.prototype.RemoveWishlistItem(this);
        });
    };
    User.prototype.RemoveWishlistItem = function (el) {
        var clicked = $(el);
        var wishlistId = clicked.data("id");
        var wishListCount = parseInt($("#wishlistcount").text());
        Endpoint.prototype.RemoveProductFromWishList(wishlistId, function (res) {
            if (res.success) {
                clicked.closest(".wishlist-item").remove();
                $("#wishlistcount").html(res.data.total);
                if (res.data.total == 0) {
                    $('#subTextWishList').text('');
                    $('#subTextWishList').text(ZnodeBase.prototype.getResourceByKeyName("MessageNoProductsInWishlist"));
                }
            }
            else {
            }
        });
    };
    User.prototype.UpdateQuoteStatus = function (control, statusId) {
        var quoteIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (quoteIds.length > 0 && statusId > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.UpdateQuoteStatus(quoteIds, statusId, function (res) {
                DynamicGrid.prototype.RefreshGrid(control, res);
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.GenerateInvoice = function () {
        var arrIds = [];
        var ids = new Array();
        $(".grid-row-checkbox:checked").each(function () {
            ids.push($.trim($(this).attr('id').split('_')[1]));
        });
        if (ids.length > 0) {
            for (var _i = 0, ids_1 = ids; _i < ids_1.length; _i++) {
                var entry = ids_1[_i];
                arrIds.push(entry.replace("rowcheck_", ""));
            }
        }
        if (arrIds != undefined && arrIds.length > 0) {
            $("#orderIds").val(arrIds);
            setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 1000);
            return true;
        }
        else {
            $("#SuccessMessage").html("");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneOrder"), "error", isFadeOut, fadeOutTime);
            return false;
        }
    };
    User.prototype.LoadQuote = function () {
        $("#btnBottomReview").on('click', function () {
            $("#OrderStatus").val('IN REVIEW');
        });
        $("#btnBottomApprove").on('click', function () {
            $("#OrderStatus").val('APPROVED');
        });
        $("#btnBottomReject").on('click', function () {
            $("#OrderStatus").val('REJECTED');
        });
        $("#btnTopReview").on('click', function () {
            $("#OrderStatus").val('IN REVIEW');
        });
        $("#btnTopApprove").on('click', function () {
            $("#OrderStatus").val('APPROVED');
        });
        $("#btnTopReject").on('click', function () {
            $("#OrderStatus").val('REJECTED');
        });
    };
    User.prototype.UpdateQuoteLineItemQuantity = function (control) {
        var sku = $(control).attr("data-cart-sku");
        var minQuantity = parseInt($(control).attr("min-Qty"));
        var maxQuantity = parseInt($(control).attr("max-Qty"));
        $("#quantity_error_msg_" + sku).text('');
        var inventoryRoundOff = parseInt($(control).attr("data-inventoryRoundOff"));
        var selectedQty = $(control).val();
        var decimalPoint = 0;
        var decimalValue = 0;
        if (selectedQty.split(".")[1] != null) {
            decimalPoint = selectedQty.split(".")[1].length;
            decimalValue = parseInt(selectedQty.split(".")[1]);
        }
        if (this.CheckDecimalValue(decimalPoint, decimalValue, inventoryRoundOff, sku)) {
            if (this.CheckIsNumeric(selectedQty, sku)) {
                if (this.CheckMinMaxQuantity(parseInt(selectedQty), minQuantity, maxQuantity, sku)) {
                    $(control).closest("form").submit();
                }
            }
        }
        return false;
    };
    User.prototype.CheckDecimalValue = function (decimalPoint, decimalValue, inventoryRoundOff, sku) {
        if (decimalValue != 0 && decimalPoint > inventoryRoundOff) {
            $("#quantity_error_msg_" + sku).text(ZnodeBase.prototype.getResourceByKeyName("EnterQuantityHaving") + inventoryRoundOff + ZnodeBase.prototype.getResourceByKeyName("XNumbersAfterDecimalPoint"));
            return false;
        }
        return true;
    };
    User.prototype.CheckIsNumeric = function (selectedQty, sku) {
        var matches = selectedQty.match(/^-?[\d.]+(?:e-?\d+)?$/);
        if (matches == null) {
            $("#quantity_error_msg_" + sku).text(ZnodeBase.prototype.getResourceByKeyName("RequiredNumericValue"));
            return false;
        }
        return true;
    };
    User.prototype.CheckMinMaxQuantity = function (selectedQty, minQuantity, maxQuantity, sku) {
        if (selectedQty < minQuantity || selectedQty > maxQuantity) {
            $("#quantity_error_msg_" + sku).text(ZnodeBase.prototype.getResourceByKeyName("SelectedQuantityBetween") + minQuantity + ZnodeBase.prototype.getResourceByKeyName("To") + maxQuantity + ZnodeBase.prototype.getResourceByKeyName("FullStop"));
            return false;
        }
        return true;
    };
    User.prototype.DeleteCurrentAddress = function () {
        var url = $("#deleteCurrentAddress").attr('data-url');
        $("#frmEditAddress_billing").attr('action', url);
        $("#frmEditAddress_billing").submit();
    };
    User.prototype.DeleteTemplate = function (control) {
        var templateIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (templateIds.length > 0) {
            Endpoint.prototype.DeleteTemplate(templateIds, function (res) {
                DynamicGrid.prototype.RefreshGrid(control, res);
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.ProcessContinueOnClick = function () {
        if (parseInt($("#InventoryOutOfStockCount").val()) == parseInt($("#ShoppingCartItemsCount").val())) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("QuoteItemsOutOfStockErrorMsg"), "error", isFadeOut, 0);
            return false;
        }
        var cartItemcount = $("#CartItemCount").val();
        if (parseInt(cartItemcount) > 0) {
            var omsQuoteLineItemId = $("#omsQuoteLineItemId").val();
            $("#QuoteConfirmPopup").modal('show');
        }
        else {
            User.prototype.ProcessQuote();
        }
    };
    User.prototype.ProcessQuote = function () {
        $("#FormQuoteView").attr('action', "/User/ProcessQuote").submit();
    };
    User.prototype.DeleteQuoteLineItem = function () {
        var omsQuoteLineItemId = $("#OmsQuoteLineItemId").val();
        var omsQuoteId = $("#OmsQuoteId").val();
        var orderStatus = $("#OrderStatus").val();
        var roleName = $("#RoleName").val();
        var token = $('input[name="__RequestVerificationToken"]', $('#FormQuoteView')).val();
        Endpoint.prototype.DeleteQuoteLineItem(omsQuoteLineItemId, omsQuoteId, 1, orderStatus, roleName, token, function (res) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
            window.location.href = window.location.protocol + "//" + window.location.host + "/User/QuoteHistory";
        });
    };
    User.prototype.DeleteDraft = function () {
        $("#DraftConfirmPopup").modal('show');
    };
    User.prototype.ValidateCreateEditTemplate = function () {
        var templateName = $("#TemplateName").val();
        var isValid = true;
        if (!templateName) {
            $("#validTemplateName").html(ZnodeBase.prototype.getResourceByKeyName("RequiredTemplateName"));
            $("#validTemplateName").addClass("error-msg");
            $("#validTemplateName").show();
            isValid = false;
        }
        Endpoint.prototype.IsTemplateNameExist(templateName, $("#OmsTemplateId").val(), function (response) {
            if (!response) {
                $("#validTemplateName").html(ZnodeBase.prototype.getResourceByKeyName("TemplateNameAlreadyExist"));
                $("#validTemplateName").addClass("error-msg");
                $("#validTemplateName").show();
                isValid = false;
            }
        });
        if (isValid)
            $("#frmCreateEditTemplate").submit();
        else
            return false;
    };
    User.prototype.SetManageQuoteUrl = function () {
        $("#grid tbody tr td").find(".zf-view").each(function () {
            var orderStatus = $(this).attr("data-parameter").split('&')[1].split('=')[1];
            var newhref = $(this).attr("href");
            if (newhref.length > 0) {
                if (orderStatus.toLowerCase() == "ordered") {
                    var omsQuoteId = $(this).attr("data-parameter").split('&')[0].split('=')[1];
                    newhref = window.location.protocol + "//" + window.location.host + "/User/OrderReceipt?OmsOrderId=" + omsQuoteId;
                }
                else {
                    newhref = window.location.protocol + "//" + window.location.host + newhref;
                }
            }
            $(this).attr('href', newhref);
        });
    };
    User.prototype.SetQuoteIdLinkURL = function () {
        $("#grid tbody tr .linkQuoteId").each(function () {
            var orderStatus = $(this).children().attr("href").split('&')[1].split('=')[1];
            var newhref = $(this).children().attr("href");
            if (newhref.length > 0) {
                if (orderStatus.toLowerCase() == "ordered") {
                    var omsQuoteId = $(this).children().attr("href").split('&')[0].split('=')[1];
                    newhref = window.location.protocol + "//" + window.location.host + "/User/OrderReceipt?OmsOrderId=" + omsQuoteId;
                }
                else {
                    newhref = window.location.protocol + "//" + window.location.host + newhref;
                }
            }
            $(this).children().attr('href', newhref);
        });
    };
    User.prototype.HideAddressChangeLink = function () {
        $("#FormQuoteView").find('.address-change').hide();
        $("#FormQuoteView").find('.change-address').hide();
    };
    //Saved Credit Card Region
    User.prototype.ShowCardPaymentOptions = function (customerGUID) {
        Endpoint.prototype.GetSaveCreditCardCount(customerGUID, function (count) {
            $("#creditCardCount").html($("#creditCardCount").html().replace("0", count.toString()));
        });
    };
    User.prototype.ShowPaymentOptions = function (data, CustomerPaymentGUID, isAccount) {
        Endpoint.prototype.GetPaymentDetails(data, true, function (response) {
            if (!response.HasError) {
                Endpoint.prototype.GetSaveCreditCardCount(CustomerPaymentGUID, function (count) {
                    $("#creditCardCount").html($("#creditCardCount").html().replace("0", count.toString()));
                });
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorContactPaymentApp"), "error", false, 0);
            }
        });
    };
    User.prototype.HideGridColumnForPODocument = function (isEnableReturnRequest) {
        //Hide return icon if create return is disable for store
        if (!isEnableReturnRequest) {
            $('#grid .zf-return').hide();
        }
        //Hide PODocument path column
        $('#grid tbody tr').each(function () {
            var podoc = $(this).find('td').last();
            if (podoc.hasClass('z-podocument')) {
                //Get the PoDocument path if exist and create a hyper link to download PODocument.
                var filePath = podoc.text();
                if (filePath != "" && typeof filePath != "undefined") {
                    $(this).find('td').each(function () {
                        if ($(this).hasClass("z-paymenttype")) {
                            if ($(this).text().toLocaleLowerCase() == "purchase_order") {
                                $(this).text("");
                                $(this).append($('<div>').html("<a href='" + podoc.text() + "' target='_blank'>Purchase Order</a>"));
                            }
                        }
                    });
                }
            }
        });
    };
    User.prototype.RemoveCaptchaValidationMessage = function () {
        $("#CaptchaInputText").on("keyup keypress", function () {
            $("#CaptchaInputText").addClass("input-validation-valid").removeClass("input-validation-error");
            $("#CaptchaInputText").next().next("span").attr("class", "field-validation-valid");
            $("#CaptchaInputText").next().next("span").html("");
        });
    };
    User.prototype.PrintOrderDetails = function (e) {
        var printContents = $("#userorderdetails").html();
        var originalContents = document.body.innerHTML;
        var orderNumber = $("#OrderNumber").val();
        var emailAddress = $("#EmailAddress").val();
        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
        $("#OrderNumber").val(orderNumber);
        $("#EmailAddress").val(emailAddress);
        $.validator.unobtrusive.parse($("#frmOrderDetails"));
    };
    User.prototype.LoginMethod = function () {
        var actualurl = window.location.href;
        //If actual url does not contain return url then only append return url.
        if (actualurl.indexOf("returnUrl") == -1) {
            actualurl = decodeURIComponent(actualurl);
            var returnUrl = decodeURIComponent(actualurl.replace(document.location.origin, ''));
            returnUrl = encodeURIComponent(returnUrl);
            if (returnUrl != "/User/Login")
                window.location.href = window.location.protocol + "//" + window.location.host + '/User/Login?returnUrl=' + returnUrl;
        }
        else
            window.location.href = window.location.protocol + "//" + window.location.host + '/User/Login';
    };
    User.prototype.AppendLoaderOnSubmit = function () {
        $("#error-content").empty();
        if ($("#login_password").val() != "" && $("#login_username").val() != "") {
            if ($(".field-validation-error").eq(0).html() == "") {
                ZnodeBase.prototype.ShowLoader();
            }
        }
        ZnodeBase.prototype.HideLoader();
        $("#valueCaptchaError").html("");
        Checkout.prototype.KlaviyoSubscribe($("#klaviyoListID").val());
    };
    User.prototype.BindAddressModel = function (addressType) {
        var stateName = $("#frmEditAddress_" + addressType).find('#txtStateCode[disabled]').length > 0 ? $("#frmEditAddress_" + addressType).find("#SelectStateName option:selected").val() : $("#frmEditAddress_" + addressType).find("#txtStateCode").val();
        var _addressModel = {
            Address1: $("#frmEditAddress_" + addressType).find("input[name=Address1]").val(),
            Address2: $("#frmEditAddress_" + addressType).find("input[name=Address2]").val(),
            AddressId: parseInt($("#frmEditAddress_" + addressType).find("#AddressId").val()),
            CityName: $("#frmEditAddress_" + addressType).find("input[name=CityName]").val(),
            FirstName: $("#frmEditAddress_" + addressType).find("input[name=FirstName]").val(),
            LastName: $("#frmEditAddress_" + addressType).find("input[name=LastName]").val(),
            PostalCode: $("#frmEditAddress_" + addressType).find("input[name=PostalCode]").val(),
            StateName: stateName,
            CountryName: $("#frmEditAddress_" + addressType).find('select[name="CountryName"]').val(),
            AddressType: addressType,
            PhoneNumber: $("#frmEditAddress_" + addressType).find("input[name=PhoneNumber]").val(),
            EmailAddress: $("#frmEditAddress_" + addressType).find("input[name=EmailAddress]").val(),
            AspNetUserId: $("#frmEditAddress_" + addressType).find("input[name=AspNetUserId]").val(),
            UserId: $("#frmEditAddress_" + addressType).find("input[name=UserId]").val()
        };
        return _addressModel;
    };
    User.prototype.ValidateAddressForm = function (addressType) {
        var _addressType = $("#frmEditAddress_" + addressType);
        var isValid = false;
        if (User.prototype.IsValidZipCode(_addressType.find('#address_postalcode').val(), _addressType)) {
            _addressType.find('#valid-postalcode').hide();
            isValid = true;
        }
        else {
            _addressType.find('#valid-postalcode').show();
            isValid = false;
        }
        return isValid;
    };
    User.prototype.IsValidZipCode = function (zipCode, _addressType) {
        var countryCode = _addressType.find('#ShippingAddressModel_CountryCode').val();
        //Currently few country regex available.If want to validate for other country add regex in 'ZipCodeRegex'
        var zipCodeRegexp = ZipCodeRegex[countryCode];
        if (zipCodeRegexp) {
            var regexp = new RegExp(zipCodeRegexp);
            return regexp.test(zipCode);
        }
        return true;
    };
    User.prototype.SaveChanges = function (event, id, addressType) {
        event ? event.preventDefault() : "";
        if (id != "" && typeof id != "undefined" && id != null) {
            $("#frmEditAddress_" + addressType).find("input[name=Address1]").val($("#recommended-address1-" + id + "").text());
            $("#frmEditAddress_" + addressType).find("input[name=Address2]").val($("#recommended-address2-" + id + "").text());
            $("#frmEditAddress_" + addressType).find("input[name=CityName]").val($("#recommended-address-city-" + id + "").text());
            $("#frmEditAddress_" + addressType).find("input[name=PostalCode]").val($("#recommended-address-postalcode-" + id + "").text());
            $("#frmEditAddress_" + addressType).find('#txtStateCode[disabled]').length > 0 ? $("#frmEditAddress_" + addressType).find("select[name=StateName]").val($("#recommended-address-state-" + id + "").text()) : $("#frmEditAddress_" + addressType).find("input[name=StateName]").val($("#recommended-address-state-" + id + "").text());
            $("#formChange").val("true");
        }
        $('#custom-modal').modal('hide');
        $("#frmEditAddress_" + addressType).find("#btnSaveAddress").closest("form").submit();
        return true;
    };
    User.prototype.RecommendedAddress = function (addressType) {
        if (!$("#frmEditAddress_" + addressType).valid())
            return false;
        if (!User.prototype.ValidateAddressForm(addressType))
            return false;
        ZnodeBase.prototype.ShowLoader();
        var addressModel = User.prototype.BindAddressModel(addressType);
        var isSuggestedAddress = false;
        Endpoint.prototype.GetRecommendedAddress(addressModel, function (response) {
            var htmlString = response.html;
            if (htmlString != "" && typeof htmlString != "undefined" && htmlString != null) {
                $('#custom-modal').find('#custom-content').empty();
                $('#custom-modal').find('#custom-content').append(htmlString);
                $("#user-entered-address").empty();
                var enteredaddress = "<div class='address-street'><div id='enteredAddress1'>" + addressModel.Address1 + "</div>";
                if (addressModel.Address2 != "" && typeof addressModel.Address2 != "undefined" && addressModel.Address2 != null) {
                    enteredaddress += "<div id='enteredAddress2'>" + addressModel.Address2 + "</div> ";
                }
                enteredaddress += "<div class='address-citystate'><span id='enteredCity'>" + addressModel.CityName + "</span> <span id='enteredState'>" + addressModel.StateName + "</span> <span id='enteredPostalCode'>" + addressModel.PostalCode + "</span> <div id='enteredCountry'>" + addressModel.CountryName + "</div></div>";
                $("#user-entered-address").append(enteredaddress);
                User.prototype.ShowHideRecommendedPopUp(addressType);
                ZnodeBase.prototype.HideLoader();
                isSuggestedAddress = false;
                $(".address-popup").modal("hide");
            }
            else {
                isSuggestedAddress = true;
            }
        });
        return isSuggestedAddress;
    };
    //If the recommended address matches completely then it will hide popup and save the address.
    User.prototype.ShowHideRecommendedPopUp = function (addressType) {
        var isShowRecommendedAddress = true;
        isShowRecommendedAddress = User.prototype.MatchAddress();
        if (isShowRecommendedAddress) {
            $('#custom-modal').empty();
            return User.prototype.SaveChanges(null, null, addressType);
        }
        $('#custom-modal').modal('show');
    };
    //Match entered address with recommended address.
    User.prototype.MatchAddress = function () {
        var isMatchedAddress = true;
        for (var i = 1; i < $("#custom-modal .address-details").length; i++) {
            isMatchedAddress = User.prototype.ValidateRecommendedAddress("#enteredAddress1", "#recommended-address1-" + i, isMatchedAddress);
            isMatchedAddress = User.prototype.ValidateRecommendedAddress("#enteredAddress2", "#recommended-address2-" + i, isMatchedAddress);
            isMatchedAddress = User.prototype.ValidateRecommendedAddress("#enteredCity", "#recommended-address-city-" + i, isMatchedAddress);
            isMatchedAddress = User.prototype.ValidateRecommendedAddress("#enteredState", "#recommended-address-state-" + i, isMatchedAddress);
            isMatchedAddress = User.prototype.ValidateRecommendedAddress("#enteredCountry", "#recommended-address-country-" + i, isMatchedAddress);
            isMatchedAddress = User.prototype.ValidateRecommendedAddress("#enteredPostalCode", "#recommended-address-postalcode-" + i, isMatchedAddress);
        }
        return isMatchedAddress;
    };
    User.prototype.ValidateRecommendedAddress = function (selector, recommendedAddressSelector, isMatchedAddress) {
        if (!($(selector).text().trim().toLowerCase() == $(recommendedAddressSelector).text().trim().toLowerCase())) {
            $(recommendedAddressSelector).addClass("address-error");
            isMatchedAddress = false;
        }
        return isMatchedAddress;
    };
    User.prototype.HideShowAddressPopUP = function () {
        $("#AddressError").html("");
        $("#custom-modal").modal("hide");
    };
    User.prototype.OnUserTypeSelection = function () {
        var selectedRole = $("#ddlUserType option:selected").text();
        if (selectedRole == null && selectedRole == "") {
            $('#ddlRole').children('option:not(:first)').remove();
            $('#divRole').hide();
            return false;
        }
        if (selectedRole == "User") {
            $('#divRole').show();
            Endpoint.prototype.GetPermissionList($("#AccountId").val(), $("#AccountPermissionAccessId").val(), function (response) {
                $('#permission_options').html("");
                $('#permission_options').html(response);
                $("#ddlPermission").attr("onchange", "User.prototype.OnPermissionSelection();");
            });
            $("#ddlPermission").change();
        }
        else {
            $('#divRole').hide();
            $('#approvalNamesDiv').hide();
            $('#maxBudgetDiv').hide();
            $("#BudgetAmount").val("");
        }
    };
    User.prototype.OnPermissionSelection = function () {
        var permission = $("#ddlPermission option:selected").attr('data-permissioncode');
        var $sel = $("#divRole");
        var value = $sel.val();
        var text = $("option:selected", $sel).text();
        $('#PermissionCode').val(permission);
        $('#PermissionsName').val(text);
        if (permission != undefined && permission == 'ARA') {
            User.prototype.ShowApprovalList();
            $('#maxBudgetDiv').hide();
        }
        else if (permission != undefined && permission == 'SRA') {
            User.prototype.ShowApprovalList();
            $('#maxBudgetDiv').show();
        }
        else {
            $('#approvalNamesDiv').hide();
            $('#maxBudgetDiv').hide();
            $("#BudgetAmount").val("");
        }
    };
    User.prototype.OnUserProfileSelection = function () {
        var profileId = $("#ddlUserProfile option:selected").val();
        if (profileId != undefined && profileId > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.ChangeUserProfile(profileId, function (response) {
                if (response.status) {
                    window.location.reload();
                }
            });
        }
    };
    User.prototype.ShowApprovalList = function () {
        var accountId = $("#AccountId").val();
        var userId = parseInt($("#UserId").val(), 10);
        Endpoint.prototype.GetApproverList(accountId, userId, function (response) {
            var approvalUserId = $("#ApprovalUserId").val();
            $("#ddlApproverList").html("");
            $('#ddlApproverList').find('option').remove().end();
            $('#ddlApproverList').children('option:not(:first)').remove();
            for (var i = 0; i < response.length; i++) {
                if (response[i].Value == approvalUserId)
                    var opt = new Option(response[i].Text, response[i].Value, false, true);
                else
                    var opt = new Option(response[i].Text, response[i].Value);
                $('#ddlApproverList').append(opt);
            }
            $('#approvalNamesDiv').show();
        });
    };
    User.prototype.ValidateUserNameExists = function () {
        if ($("#divAddCustomerAsidePanel #UserName").val() != '') {
            Endpoint.prototype.IsUserNameExist($("#divAddCustomerAsidePanel #UserName").val(), $("#PortalId").val(), function (response) {
                if (!response) {
                    $("#UserName").addClass("input-validation-error");
                    $("#errorUserName").addClass("error-msg");
                    $("#errorUserName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistUserName"));
                    $("#errorUserName").show();
                    $("#loading-div-background").hide();
                    return false;
                }
            });
        }
        return User.prototype.ValidateBudgetAmount();
    };
    User.prototype.ValidateBudgetAmount = function () {
        if ($("#BudgetAmount").is(':visible')) {
            if ($("#BudgetAmount").val() == null || $("#BudgetAmount").val() == "") {
                $("#errorRequiredAccountPermissionAccessId").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorBudgetAmount")).addClass("field-validation-error").show();
                $("#BudgetAmount").addClass('input-validation-error');
                return false;
            }
        }
        return true;
    };
    User.prototype.SubmitCustomerCreateEditForm = function () {
        return User.prototype.ValidationForUser();
    };
    User.prototype.ValidateAccountsCustomer = function () {
        $("#frmCreateEditCustomerAccount").submit(function () {
            return User.prototype.ValidationForUser();
        });
    };
    User.prototype.ValidationForUser = function () {
        var flag = true;
        var _AllowGlobalLevelUserCreation = $("#AllowGlobalLevelUserCreation").val();
        if (_AllowGlobalLevelUserCreation == "False" && $("#AccountName").val() == "" && $("#hdnPortalId").val() == "") {
            $("#errorRequiredStore").text('').text(ZnodeBase.prototype.getResourceByKeyName("SelectPortal")).addClass("field-validation-error").show();
            $("#txtPortalName").addClass('input-validation-error');
            flag = false;
        }
        if ($("#hdnRoleName").val() == "User") {
            if ($("#BudgetAmount").is(':visible')) {
                if ($("#BudgetAmount").val() == null || $("#BudgetAmount").val() == "") {
                    $("#errorRequiredAccountPermissionAccessId").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorBudgetAmount")).addClass("field-validation-error").show();
                    $("#BudgetAmount").addClass('input-validation-error');
                    flag = false;
                }
            }
            if ($("#ddlApproverList").is(':visible')) {
                if ($("#ddlApproverList").val() == null || $("#ddlApproverList").val() == "") {
                    $("#errorRequiredApprovalUserId").html("<span>" + ZnodeBase.prototype.getResourceByKeyName("SelectApprovalUserId") + "</span>");
                    $("#ddlApproverList").addClass('input-validation-error');
                    flag = false;
                }
            }
        }
        if (!$("#BudgetAmount").is(':visible')) {
            $("#BudgetAmount").val("");
        }
        if ($("#Email").is(':visible') && $("#Email").val() == '') {
            $("#errorRequiredEmail").text('').text(ZnodeBase.prototype.getResourceByKeyName("EmailAddressIsRequired")).removeClass('field-validation-valid').addClass("field-validation-error").show();
            $("#Email").removeClass('valid').addClass('input-validation-error');
            flag = false;
        }
        return flag;
    };
    User.prototype.CancelUpload = function (targetDiv) {
        if ($(".add-to-cart-popover").html() != null && $(".add-to-cart-popover").html() != undefined && $(".add-to-cart-popover").html() != "")
            $(".add-to-cart-popover").remove();
        $("#" + targetDiv).hide(700);
        $("#" + targetDiv).html("");
        $("body").css('overflow', 'auto');
        User.prototype.RemovePopupOverlay();
    };
    User.prototype.RemovePopupOverlay = function () {
        //Below code is used to close the overlay of popup, as it was not closed in server because container is updated by Ajax call
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
        $("body").css('overflow', 'auto');
    };
    User.prototype.DeleteMultipleAccountCustomer = function (control) {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.DeleteAccountCustomers(accountIds, function (res) {
                ZnodeBase.prototype.HideLoader();
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeAccountUser").find("#refreshGrid"), res);
            });
        }
    };
    User.prototype.EnableCustomerAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.CustomerEnableDisableAccount($("#AccountId").val(), accountIds, true, function (res) {
                ZnodeBase.prototype.HideLoader();
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeAccountUser").find("#refreshGrid"), res);
                if (res.status == true)
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("EnableMessage"), 'success', isFadeOut, fadeOutTime);
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.DisableCustomerAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.CustomerEnableDisableAccount($("#AccountId").val(), accountIds, false, function (res) {
                ZnodeBase.prototype.HideLoader();
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeAccountUser").find("#refreshGrid"), res);
                if (res.status == true)
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("DisableMessage"), 'success', isFadeOut, fadeOutTime);
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.CustomerResetPassword = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.CustomerAccountResetPassword($("#AccountId").val(), accountIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeAccountUser").find("#refreshGrid"), res);
                ZnodeBase.prototype.HideLoader();
                if (res.status == true)
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SuccessResetPassword"), 'success', isFadeOut, fadeOutTime);
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName(res.message), 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.GetUserPermissionList = function () {
        if ($("#hdnRoleName").val() == "User") {
            Endpoint.prototype.GetPermissionList($("#AccountId").val(), $("#AccountPermissionAccessId").val(), function (response) {
                $('#permission_options').html("");
                $('#permission_options').html(response);
                $("#ddlPermission").attr("onchange", "User.prototype.OnPermissionSelection();");
            });
        }
    };
    User.prototype.ShowHidePermissionDiv = function () {
        if ($("#hdnRoleName").val() != "User") {
            $("#permissionsToHide").hide();
        }
        else {
            $("#permissionsToHide").show();
        }
    };
    User.prototype.ResetPasswordCustomer = function () {
        var accountId = $("#AccountId").val();
        window.location.href = window.location.protocol + "//" + window.location.host + "/user/singleresetpassword?accountId=" + accountId;
    };
    User.prototype.ResetPasswordUsers = function () {
        var userId = $("#divAddCustomerAsidePanel #UserId").val();
        if (userId == undefined && $("#UserId").val() != undefined)
            userId = $("#UserId").val();
        else
            userId = User.prototype.GetUserIdFromQueryString(); //if #UserId and #divAddCustomerAsidePanel is undefine then UserId will get from query string
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.SingleResetPassword(userId, function (res) {
            ZnodeBase.prototype.HideLoader();
            var errorType = 'error';
            if (res.status) {
                errorType = 'success';
            }
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, errorType, isFadeOut, fadeOutTime);
        });
    };
    //Get User ID from Query String
    User.prototype.GetUserIdFromQueryString = function () {
        var hdnResetPasswordURL = $("#hdnResetPasswordURL").val();
        var paramStr = decodeURIComponent(hdnResetPasswordURL).substring(1);
        var paramSegs = paramStr.split('&');
        for (var i = 0; i < paramSegs.length; i++) {
            var paramSeg = paramSegs[i].split('=');
        }
        var userId = paramSeg[1];
        return userId;
    };
    User.prototype.BindStates = function (addresstype) {
        if (addresstype == null || addresstype == '') {
            $(".addressType").each(function () {
                addresstype = $(this).val();
                if (addresstype.toLowerCase() == "shipping")
                    User.prototype.BindStatestoShippingAddress();
                else if (addresstype.toLowerCase() == "billing")
                    User.prototype.BindStatestoBillingAddress();
                else {
                    var countryCode = ($('select[name="CountryName"]').val() != undefined) ? $('select[name="CountryName"]').val() : $('select[name="Address.CountryName"]').val();
                    if (countryCode.toLowerCase() != '' && countryCode.toLowerCase() != undefined) {
                        Endpoint.prototype.GetStates(countryCode, function (response) {
                            var stateName = $('#SelectStateName');
                            stateName.empty();
                            $("#txtStateCode").attr("disabled", "disabled");
                            $("#txtStateCode").val('');
                            $.each(response.states, function (key, value) {
                                stateName.append('<option value="' + value.Value + '">' + value.Text + '</option>');
                            });
                            var code = $("#hdn_StateCode").val();
                            $("#SelectStateName option").filter(function () {
                                return ($(this).val() == code);
                            }).prop('selected', true);
                        });
                    }
                    else {
                        $("#txtStateCode").prop("disabled", false);
                    }
                    $("#dev-statecode-textbox").hide();
                    $("#dev-statecode-select").show();
                }
            });
        }
        else if (addresstype.toLowerCase() == "shipping")
            User.prototype.BindStatestoShippingAddress();
        else if (addresstype.toLowerCase() == "billing")
            User.prototype.BindStatestoBillingAddress();
    };
    User.prototype.BindStatestoShippingAddress = function () {
        var countryCode = ($("#frmEditAddress_shipping").find('select[name="CountryName"]').val() != undefined) ? $("#frmEditAddress_shipping").find('select[name="CountryName"]').val() : $("#frmEditAddress_shipping").find('select[name="Address.CountryName"]').val();
        if (countryCode.toLowerCase() != '' && countryCode.toLowerCase() != undefined) {
            Endpoint.prototype.GetStates(countryCode, function (response) {
                var stateName = $("#frmEditAddress_shipping").find('#SelectStateName');
                stateName.empty();
                $("#frmEditAddress_shipping").find("#txtStateCode").attr("disabled", "disabled");
                $("#frmEditAddress_shipping").find("#txtStateCode").val('');
                $.each(response.states, function (key, value) {
                    stateName.append('<option value="' + value.Value + '">' + value.Text + '</option>');
                });
                var code = $("#frmEditAddress_shipping").find("#hdn_StateCode").val();
                $("#frmEditAddress_shipping").find("#SelectStateName option").filter(function () {
                    return ($(this).val() == code);
                }).prop('selected', true);
            });
        }
        else {
            $("#frmEditAddress_shipping").find("#txtStateCode").prop("disabled", false);
        }
        $("#frmEditAddress_shipping").find("#dev-statecode-textbox").hide();
        $("#frmEditAddress_shipping").find("#dev-statecode-select").show();
    };
    User.prototype.BindStatestoBillingAddress = function () {
        var countryCode = ($("#frmEditAddress_billing").find('select[name="CountryName"]').val() != undefined) ? $("#frmEditAddress_billing").find('select[name="CountryName"]').val() : $("#frmEditAddress_billing").find('select[name="Address.CountryName"]').val();
        if (countryCode.toLowerCase() != '' && countryCode.toLowerCase() != undefined) {
            Endpoint.prototype.GetStates(countryCode, function (response) {
                var stateName = $("#frmEditAddress_billing").find('#SelectStateName');
                stateName.empty();
                $("#frmEditAddress_billing").find("#txtStateCode").attr("disabled", "disabled");
                $("#frmEditAddress_billing").find("#txtStateCode").val('');
                $.each(response.states, function (key, value) {
                    stateName.append('<option value="' + value.Value + '">' + value.Text + '</option>');
                });
                var code = $("#frmEditAddress_billing").find("#hdn_StateCode").val();
                $("#frmEditAddress_billing").find("#SelectStateName option").filter(function () {
                    return ($(this).val() == code);
                }).prop('selected', true);
            });
        }
        else {
            $("#frmEditAddress_billing").find("#txtStateCode").prop("disabled", false);
        }
        $("#frmEditAddress_billing").find("#dev-statecode-textbox").hide();
        $("#frmEditAddress_billing").find("#dev-statecode-select").show();
    };
    User.prototype.SetPrimaryAddress = function (event, type) {
        var selectedAddressId = event.value;
        User.prototype.ShowLoader();
        Endpoint.prototype.SetPrimaryAddress(selectedAddressId, type, function (response) {
            if (type == "shipping") {
                $("#defaultShippingAddressDiv").html(response.html);
            }
            if (type == "billing") {
                $("#defaultBillingAddressDiv").html(response.html);
            }
            User.prototype.HideLoader();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? "success" : "error", isFadeOut, fadeOutTime);
        });
    };
    User.prototype.GetUserApproverList = function (omsQuoteId) {
        Endpoint.prototype.GetUserApproverList(omsQuoteId, function (response) {
            $("#user-approver-popup-content").html(response);
        });
    };
    User.prototype.LoginInPopup = function () {
        var actualurl = window.location.href;
        var returnUrl;
        //If actual url does not contain return url then only append return url.
        if (actualurl.indexOf("returnUrl") == -1) {
            actualurl = decodeURIComponent(actualurl);
            returnUrl = decodeURIComponent(actualurl.replace(document.location.origin, ''));
            if (returnUrl == "/User/Login")
                returnUrl = "";
        }
        Endpoint.prototype.Login(returnUrl, function (response) {
            $("#sign-in-nav").html(response);
            $(".accountmenus").addClass("OpenNav");
            $(".loginNow").addClass("OpenNav");
        });
    };
    User.prototype.GetAccountMenus = function () {
        Endpoint.prototype.GetAccountMenus(function (response) {
            ZnodeBase.prototype.HideLoader();
            $("#accountMenusDiv").html(response);
            $("#accountMenusDiv .dropdown-menu").attr("style", "display:block");
            $("#accountMenusDiv .dropdown-menu").show();
        });
    };
    User.prototype.ForgotPassword = function () {
        Endpoint.prototype.ForgotPassword(function (response) {
            $("#sign-in-nav").html(response);
        });
    };
    User.prototype.GetResult = function (data) {
        if (data.status == false || data.status == undefined || data.status == "undefined") {
            if (data.error == '' || data.error == undefined || data.error == "undefined") {
                $("#sign-in-nav").html(data);
                $("#CaptchaInputText").addClass("input-validation-error");
                $("#CaptchaInputText").next().next("span").attr("class", "field-validation-error");
                $("#CaptchaInputText").val("");
            }
            $("#error-content").html(data.error);
            $("#login_password").val("");
            $("#div-captcha").html(data.captchaHtml);
            ZnodeBase.prototype.HideLoader();
        }
        else if (data.status == true) {
            if (data.hasOwnProperty('isResetPassword') && data.isResetPassword == true) {
                window.location.href = "/User/ResetWebstorePassword";
            }
            else if (data.link != null) {
                if (data.link == "/User/Wishlist") {
                    localStorage.setItem("Status", data.status);
                    window.location.reload();
                }
                if (data.link !== null && data.link !== '') {
                    if (data.link.indexOf(window.location.origin) >= 0)
                        window.location.href = data.link;
                    else if (data.link.match("^/")) {
                        window.location.href = window.location.origin + data.link;
                    }
                    else {
                        if (data.link.indexOf('/') == 0)
                            window.location.href = window.location.origin + data.link;
                        else
                            window.location.href = window.location.origin + '/' + data.link;
                    }
                }
                else
                    window.location.href = window.location.pathname;
            }
            else if (window.location.href.indexOf('/User/signup') >= 0) {
                window.location.href = '/';
            }
            else {
                window.location.reload();
            }
        }
        else {
            if (window.location.href.indexOf('/User/signup') >= 0) {
                window.location.href = '/';
            }
            else {
                window.location.reload();
            }
        }
    };
    User.prototype.LogOff = function () {
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.Logoff(function (reponse) {
            window.location.href = window.location.protocol + "//" + window.location.host;
            ZnodeBase.prototype.HideLoader();
        });
    };
    User.prototype.RedirectToLogin = function (data) {
        $("#sign-in-nav").html(data);
        ZnodeBase.prototype.HideLoader();
    };
    User.prototype.RemoveValidationMessage = function (addressType) {
        var _addressType = $("#frmEditAddress_" + addressType);
        _addressType.find('#valid-postalcode').hide();
    };
    User.prototype.LoginOnPasswordReset = function () {
        ZnodeBase.prototype.HideLoader();
        window.location.reload();
    };
    User.prototype.AddToCartOnCreateTemplate = function () {
        var flag = true;
        var cartItemCount = $("#hdnTemplateCartItemCount").val();
        var templateId = $("#OmsTemplateId").val();
        if (cartItemCount > 0) {
            if (templateId > 0) {
                ZnodeBase.prototype.ShowLoader();
                Endpoint.prototype.IsTemplateItemsModified(templateId, function (response) {
                    ZnodeBase.prototype.HideLoader();
                    if (response.status == true) {
                        flag = true;
                        window.location.href = "/User/AddTemplateToCart?omsTemplateId=" + templateId;
                    }
                    else {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSaveOrderTemplate"), "error", false, 0);
                        flag = false;
                    }
                });
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSaveOrderTemplate"), "error", false, 0);
                flag = false;
            }
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorAtLeastOneProductTemplate"), "error", false, 0);
            flag = false;
        }
        return flag;
    };
    User.prototype.IsInvoicePaymentValid = function () {
        var isValid = true;
        var paymentOptionValue = $("input[name='PaymentOptions']:checked").val();
        if (paymentOptionValue == null || paymentOptionValue == "") {
            isValid = false;
            $("#errorPayment").html(ZnodeBase.prototype.getResourceByKeyName("SelectPaymentOption"));
            Checkout.prototype.HidePaymentLoader();
        }
        return isValid;
    };
    User.prototype.PayInvoice = function () {
        if (!User.prototype.IsInvoicePaymentValid()) {
            User.prototype.isPaymentInProcess = false;
        }
        else {
            var paymentOptionId = $("input[name='PaymentOptions']:checked").attr("id");
            var paymentType = Checkout.prototype.GetPaymentType(paymentOptionId);
            var userType = ZnodeBase.prototype.GetParameterValues("mode");
            if (userType == undefined) {
                userType = "";
            }
            userType = (userType != "") ? userType.replace("#", "") : userType;
            switch (paymentType.toLowerCase()) {
                case "ach":
                    User.prototype.SubmitACHPayment();
                    break;
                case "credit_card":
                    User.prototype.SubmitPayment();
                    break;
                default:
                    // global data
                    if (Checkout.prototype.CheckValidPODocument()) {
                        Quote.prototype.SubmitQuoteForm();
                    }
                    else {
                        Checkout.prototype.HideLoader();
                        return false;
                    }
                    break;
            }
        }
    };
    //Submit Payment
    User.prototype.SubmitPayment = function () {
        var Total = $("#Total").val();
        Total = Total.replace(',', '.');
        if (Checkout.prototype.IsOrderTotalGreaterThanZero(Total)) {
            if (Quote.prototype.IsValidCreditCardDetails()) {
                var shippingId = $("#shipping-content").find("#AddressId").val();
                var billingId = $("#billing-content").find("#AddressId").val();
                if ($("#IsBillingAddressOptional").val() == 'true' && (parseInt(billingId) == 0)) {
                    billingId = $("#shipping-content").find("#AddressId").val();
                    $("#billing-content").find("#AddressId").val(billingId);
                }
                var currentStatus = Checkout.prototype.isPayMentInProcess;
                Quote.prototype.ClosePopup();
                Checkout.prototype.ShowPaymentProcessDialog();
                Endpoint.prototype.GetshippingBillingAddress(parseInt($("#hdnPortalId").val()), parseInt(shippingId), parseInt(billingId), function (response) {
                    Checkout.prototype.isPayMentInProcess = currentStatus;
                    if (!response.Billing.HasError) {
                        if ($("#ajaxProcessPaymentError").html() == undefined) {
                        }
                        else {
                            $("#ajaxProcessPaymentError").html(ZnodeBase.prototype.getResourceByKeyName("ProcessingPayment"));
                        }
                        var _a = Quote.prototype.GetOrderDetails(response), BillingCity = _a.BillingCity, BillingCountryCode = _a.BillingCountryCode, BillingFirstName = _a.BillingFirstName, BillingLastName = _a.BillingLastName, BillingPhoneNumber = _a.BillingPhoneNumber, BillingPostalCode = _a.BillingPostalCode, BillingStateCode = _a.BillingStateCode, BillingStreetAddress1 = _a.BillingStreetAddress1, BillingStreetAddress2 = _a.BillingStreetAddress2, BillingEmailId = _a.BillingEmailId, ShippingCity = _a.ShippingCity, ShippingCountryCode = _a.ShippingCountryCode, ShippingFirstName = _a.ShippingFirstName, ShippingLastName = _a.ShippingLastName, ShippingPhoneNumber = _a.ShippingPhoneNumber, ShippingPostalCode = _a.ShippingPostalCode, ShippingStateCode = _a.ShippingStateCode, ShippingStreetAddress1 = _a.ShippingStreetAddress1, ShippingStreetAddress2 = _a.ShippingStreetAddress2, ShippingEmailId = _a.ShippingEmailId;
                        var _b = Quote.prototype.GetCardDetails(), cardNumber = _b.cardNumber, cardExpirationMonth = _b.cardExpirationMonth, cardExpirationYear = _b.cardExpirationYear, cardHolderName = _b.cardHolderName;
                        var IsAnonymousUser = $("#hdnAnonymousUser").val() == 0 ? true : false;
                        var guid = $('#GUID').val();
                        var discount = $('#Discount').val();
                        var ShippingCost = $('#ShippingCost').val();
                        var SubTotal = $('#SubTotal').val();
                        var cardType = $("#hdnGatwayName").val() == "cardconnect" ? Checkout.prototype.DetectCardTypeForCardConnect(cardNumber) : Checkout.prototype.DetectCardType(cardNumber);
                        var orderNumber = response.orderNumber;
                        if (cardNumber != "") {
                            $("#hdnCreditCardNumber").val(cardNumber.slice(-4));
                        }
                        if ($("#addNewCreditCard-panel").attr("class").indexOf("active") != -1) {
                            if (cardType.toLowerCase() != $("input[name='PaymentProviders']:checked").val().toLowerCase()) {
                                Checkout.prototype.HidePaymentProcessDialog();
                                var message = ZnodeBase.prototype.getResourceByKeyName("SelectedCardType") + $("input[name='PaymentProviders']:checked").val().toLowerCase() + ZnodeBase.prototype.getResourceByKeyName("SelectCardNumberAndCardType");
                                if (message != undefined) {
                                    Checkout.prototype.ShowErrorPaymentDialog(message);
                                }
                                Checkout.prototype.HideLoader();
                                return false;
                            }
                        }
                        var paymentSettingId = $('#PaymentSettingId').val();
                        var paymentCode = $('#hdnPaymentCode').val();
                        var CustomerPaymentProfileId = $('#CustomerPaymentProfileId').val();
                        var CustomerProfileId = $('#CustomerProfileId').val();
                        var CardDataToken = $('#CardDataToken').val();
                        var gatewayCode = $("#hdnGatwayName").val();
                        if (gatewayCode.toLowerCase() == 'payflow') {
                            if ($("#hdnEncryptedTotalAmount").val() != undefined && $("#hdnEncryptedTotalAmount").val() != null) {
                                Total = $("#hdnEncryptedTotalAmount").val();
                            }
                        }
                        if (Total.indexOf(',') > -1) {
                            Total.replace(',', '');
                        }
                        //Get Payment model
                        var payment = Quote.prototype.GetPaymentModel(guid, gatewayCode, BillingCity, BillingCountryCode, BillingFirstName, BillingLastName, BillingPhoneNumber, BillingPostalCode, BillingStateCode, BillingStreetAddress1, BillingStreetAddress2, BillingEmailId, ShippingCost, ShippingCity, ShippingCountryCode, ShippingFirstName, ShippingLastName, ShippingPhoneNumber, ShippingPostalCode, ShippingStateCode, ShippingStreetAddress1, ShippingStreetAddress2, ShippingEmailId, SubTotal, Total, discount, cardNumber, CustomerPaymentProfileId, CustomerProfileId, CardDataToken, cardType, paymentSettingId, IsAnonymousUser, paymentCode, orderNumber, cardExpirationYear, cardExpirationMonth, cardHolderName);
                        //Validate Payment Profile And Proceed for Convert To Order
                        User.prototype.ValidatePaymentAndPayInvoice(payment, paymentSettingId, paymentCode, gatewayCode);
                    }
                });
            }
        }
    };
    //Submit ACH Payment
    User.prototype.SubmitACHPayment = function () {
        var Total = $("#Total").val();
        Total = Total.replace(',', '.');
        var isValid = true;
        if (Checkout.prototype.IsOrderTotalGreaterThanZero(Total)) {
            if ($("#addNewACHAccount-panel").attr("class").indexOf("active") != -1) {
                isValid = Checkout.prototype.ValidateCardConnectDataToken();
            }
            if (isValid == false) {
                Checkout.prototype.isPayMentInProcess = false;
                Checkout.prototype.HidePaymentProcessDialog();
                Checkout.prototype.HideLoader();
                return false;
            }
            var shippingId = $("#shipping-content").find("#AddressId").val();
            var billingId = $("#billing-content").find("#AddressId").val();
            if ($("#IsBillingAddressOptional").val() == 'true' && (parseInt(billingId) == 0)) {
                billingId = $("#shipping-content").find("#AddressId").val();
                $("#billing-content").find("#AddressId").val(billingId);
            }
            var currentStatus = Checkout.prototype.isPayMentInProcess;
            Quote.prototype.ClosePopup();
            Checkout.prototype.ShowPaymentProcessDialog();
            Endpoint.prototype.GetshippingBillingAddress(parseInt($("#hdnPortalId").val()), parseInt(shippingId), parseInt(billingId), function (response) {
                Checkout.prototype.isPayMentInProcess = currentStatus;
                if (!response.Billing.HasError) {
                    if ($("#ajaxProcessPaymentError").html() == undefined) {
                    }
                    else {
                        $("#ajaxProcessPaymentError").html(ZnodeBase.prototype.getResourceByKeyName("ProcessingPayment"));
                    }
                    var _a = Quote.prototype.GetOrderDetails(response), BillingCity = _a.BillingCity, BillingCountryCode = _a.BillingCountryCode, BillingFirstName = _a.BillingFirstName, BillingLastName = _a.BillingLastName, BillingPhoneNumber = _a.BillingPhoneNumber, BillingPostalCode = _a.BillingPostalCode, BillingStateCode = _a.BillingStateCode, BillingStreetAddress1 = _a.BillingStreetAddress1, BillingStreetAddress2 = _a.BillingStreetAddress2, BillingEmailId = _a.BillingEmailId, ShippingCity = _a.ShippingCity, ShippingCountryCode = _a.ShippingCountryCode, ShippingFirstName = _a.ShippingFirstName, ShippingLastName = _a.ShippingLastName, ShippingPhoneNumber = _a.ShippingPhoneNumber, ShippingPostalCode = _a.ShippingPostalCode, ShippingStateCode = _a.ShippingStateCode, ShippingStreetAddress1 = _a.ShippingStreetAddress1, ShippingStreetAddress2 = _a.ShippingStreetAddress2, ShippingEmailId = _a.ShippingEmailId;
                    var _b = Quote.prototype.GetCardDetails(), cardNumber = _b.cardNumber, cardExpirationMonth = _b.cardExpirationMonth, cardExpirationYear = _b.cardExpirationYear, cardHolderName = _b.cardHolderName;
                    var IsAnonymousUser = $("#hdnAnonymousUser").val() == 0 ? true : false;
                    var guid = $('#GUID').val();
                    var discount = $('#Discount').val();
                    var ShippingCost = $('#ShippingCost').val();
                    var SubTotal = $('#SubTotal').val();
                    var cardType = $("#hdnGatwayName").val() == "cardconnect" ? Checkout.prototype.DetectCardTypeForCardConnect(cardNumber) : Checkout.prototype.DetectCardType(cardNumber);
                    var orderNumber = response.orderNumber;
                    if (cardNumber != "") {
                        $("#hdnCreditCardNumber").val(cardNumber.slice(-4));
                    }
                    var paymentSettingId = $('#PaymentSettingId').val();
                    var paymentCode = $('#hdnPaymentCode').val();
                    var CustomerPaymentProfileId = $('#CustomerPaymentProfileId').val();
                    var CustomerProfileId = $('#CustomerProfileId').val();
                    var CardDataToken = $('#CardDataToken').val();
                    var gatewayCode = $("#hdnGatwayName").val();
                    if (Total.indexOf(',') > -1) {
                        Total.replace(',', '');
                    }
                    //Get Payment model
                    var payment = Quote.prototype.GetPaymentACHModel(guid, gatewayCode, BillingCity, BillingCountryCode, BillingFirstName, BillingLastName, BillingPhoneNumber, BillingPostalCode, BillingStateCode, BillingStreetAddress1, BillingStreetAddress2, BillingEmailId, ShippingCost, ShippingCity, ShippingCountryCode, ShippingFirstName, ShippingLastName, ShippingPhoneNumber, ShippingPostalCode, ShippingStateCode, ShippingStreetAddress1, ShippingStreetAddress2, ShippingEmailId, SubTotal, Total, discount, cardNumber, CustomerPaymentProfileId, CustomerProfileId, CardDataToken, cardType, paymentSettingId, IsAnonymousUser, paymentCode, orderNumber, cardExpirationYear, cardExpirationMonth, cardHolderName);
                    //Validate Payment Profile And Proceed for Convert To Order
                    User.prototype.ValidatePaymentAndPayInvoiceACH(payment, paymentSettingId, paymentCode, gatewayCode);
                }
            });
        }
    };
    User.prototype.ValidatePaymentAndPayInvoice = function (payment, paymentSettingId, paymentCode, gatewayCode) {
        payment["CardSecurityCode"] = payment["PaymentToken"] ? $("[name='SaveCard-CVV']:visible").val() : $("#div-CreditCard [data-payment='cvc']").val();
        var creditCardNumber = $('#CredidCardNumber').val();
        $("#div-CreditCard").hide();
        var paymentOptionId = $("input[name='PaymentOptions']:checked").attr("id");
        var paymentType = Checkout.prototype.GetPaymentType(paymentOptionId);
        submitCard(payment, function (response) {
            if (response.GatewayResponse == undefined) {
                if (response.indexOf("Unauthorized") > 0) {
                    Checkout.prototype.HidePaymentProcessDialog();
                    Quote.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessCreditCardPayment") + response + ZnodeBase.prototype.getResourceByKeyName("ContactUsToCompleteOrder"));
                    Checkout.prototype.HideLoader();
                    Checkout.prototype.isPayMentInProcess = false;
                }
            }
            else {
                var isSuccess = response.GatewayResponse.IsSuccess;
                if (isSuccess) {
                    Quote.prototype.ClosePopup();
                    var submitPaymentViewModel = User.prototype.GetSubmitPaymentViewModel(paymentSettingId, paymentCode, response, paymentType, creditCardNumber);
                    $.ajax({
                        type: "POST",
                        url: "/user/PayInvoice",
                        async: true,
                        data: submitPaymentViewModel,
                        success: function (response) {
                            Checkout.prototype.isPayMentInProcess = false;
                            if (response.error != null && response.error != "" && response.error != 'undefined') {
                                Checkout.prototype.HidePaymentProcessDialog();
                                $("#layout-account-orderhistory").html('');
                                $("#layout-account-orderhistory").html(response.receiptHTML);
                                var message = Checkout.prototype.GetPaymentErrorMsg(response);
                                Quote.prototype.ClearPaymentAndDisplayMessage(message);
                                Checkout.prototype.HideLoader();
                                return false;
                            }
                            else if (response.receiptHTML != null && response.receiptHTML != "" && response.receiptHTML != 'undefined') {
                                Quote.prototype.CanclePayment();
                                Checkout.prototype.HidePaymentProcessDialog();
                                //This will focus to the top of screen.
                                $(this).scrollTop(0);
                                $('body, html').animate({ scrollTop: 0 }, 'fast');
                                $(".cartcount").html('0');
                                $("#messageBoxContainerId").hide();
                                $(".cartAmount").html('');
                                window.location.href = "/User/OrderReceiptForOfflinePayment?OmsOrderId=" + $("#OmsOrderId").val();
                                ;
                            }
                        },
                        error: function () {
                            Checkout.prototype.HidePaymentProcessDialog();
                            Checkout.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessOrder"));
                            Checkout.prototype.HideLoader();
                            return false;
                        }
                    });
                }
                else {
                    Checkout.prototype.HidePaymentProcessDialog();
                    Quote.prototype.PaymentFailedProcess(response, gatewayCode);
                }
            }
        });
    };
    User.prototype.ValidatePaymentAndPayInvoiceACH = function (payment, paymentSettingId, paymentCode, gatewayCode) {
        payment["CardSecurityCode"] = payment["PaymentToken"] ? $("[name='SaveCard-CVV']:visible").val() : $("#div-CreditCard [data-payment='cvc']").val();
        var creditCardNumber = $('#CredidCardNumber').val();
        $("#div-CreditCard").hide();
        var paymentOptionId = $("input[name='PaymentOptions']:checked").attr("id");
        var paymentType = Checkout.prototype.GetPaymentType(paymentOptionId);
        submitCard(payment, function (response) {
            if (response.GatewayResponse == undefined) {
                if (response.indexOf("Unauthorized") > 0) {
                    Checkout.prototype.HidePaymentProcessDialog();
                    Quote.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessCreditCardPayment") + response + ZnodeBase.prototype.getResourceByKeyName("ContactUsToCompleteOrder"));
                    Checkout.prototype.HideLoader();
                    Checkout.prototype.isPayMentInProcess = false;
                }
            }
            else {
                var isSuccess = response.GatewayResponse.IsSuccess;
                if (isSuccess) {
                    Quote.prototype.ClosePopup();
                    var submitPaymentViewModel = User.prototype.GetSubmitPaymentViewACHModel(paymentSettingId, paymentCode, response, paymentType, creditCardNumber);
                    $.ajax({
                        type: "POST",
                        url: "/user/PayInvoice",
                        async: true,
                        data: submitPaymentViewModel,
                        success: function (response) {
                            Checkout.prototype.isPayMentInProcess = false;
                            if (response.error != null && response.error != "" && response.error != 'undefined') {
                                Checkout.prototype.HidePaymentProcessDialog();
                                $("#layout-account-orderhistory").html('');
                                $("#layout-account-orderhistory").html(response.receiptHTML);
                                var message = Checkout.prototype.GetPaymentErrorMsg(response);
                                Quote.prototype.ClearPaymentAndDisplayMessage(message);
                                Checkout.prototype.HideLoader();
                                return false;
                            }
                            else if (response.receiptHTML != null && response.receiptHTML != "" && response.receiptHTML != 'undefined') {
                                Quote.prototype.CanclePayment();
                                Checkout.prototype.HidePaymentProcessDialog();
                                //This will focus to the top of screen.
                                $(this).scrollTop(0);
                                $('body, html').animate({ scrollTop: 0 }, 'fast');
                                $(".cartcount").html('0');
                                $("#messageBoxContainerId").hide();
                                $(".cartAmount").html('');
                                window.location.href = "/User/OrderReceiptForOfflinePayment?OmsOrderId=" + $("#OmsOrderId").val();
                                ;
                            }
                        },
                        error: function () {
                            Checkout.prototype.HidePaymentProcessDialog();
                            Checkout.prototype.ClearPaymentAndDisplayMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorProcessOrder"));
                            Checkout.prototype.HideLoader();
                            return false;
                        }
                    });
                }
                else {
                    Quote.prototype.PaymentFailedProcess(response, gatewayCode);
                }
            }
        });
    };
    User.prototype.GetSubmitPaymentViewModel = function (paymentSettingId, paymentCode, response, paymentType, creditCardNumber) {
        return {
            OmsOrderId: $("#OmsOrderId").val(),
            UserId: $("#hdnUserId").val(),
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
                RemainingAmount: parseFloat($("#Total").val()),
                PaymentAmount: parseFloat($("#paymentAmount").val()),
                PaymentGatewayId: $("#hdnPaymentGatewayId").val(),
                PaymentGatewayName: $("#hdnGatwayName").val()
            }
        };
    };
    User.prototype.GetSubmitPaymentViewACHModel = function (paymentSettingId, paymentCode, response, paymentType, creditCardNumber) {
        return {
            OmsOrderId: $("#OmsOrderId").val(),
            UserId: $("#hdnUserId").val(),
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
                RemainingAmount: parseFloat($("#Total").val()),
                PaymentAmount: parseFloat($("#paymentAmount").val()),
                IsACHPayment: true
            }
        };
    };
    User.prototype.ValidateInvoiceAmount = function () {
        var paymentAmount = parseFloat($("#paymentAmount").val());
        var amountDue = parseFloat($("#AmountDue").text());
        var roundoff = $("#priceRoundOff").val();
        if (isNaN(paymentAmount) || paymentAmount == null || paymentAmount == undefined) {
            $('#errorPaymentAmount').empty();
            User.prototype.EnableDisableSubmitPayment(false);
            $("#paymentAmount").val(amountDue.toFixed(roundoff));
        }
        else if (amountDue < paymentAmount) {
            $("#errorPaymentAmount").text(ZnodeBase.prototype.getResourceByKeyName("ErrorAmountDueMessage"));
            User.prototype.EnableDisableSubmitPayment(true);
        }
        else if (paymentAmount == 0) {
            $("#errorPaymentAmount").text(ZnodeBase.prototype.getResourceByKeyName("ErrorpaymentAmountMessage"));
            User.prototype.EnableDisableSubmitPayment(true);
        }
        else {
            User.prototype.EnableDisableSubmitPayment(false);
            $('#errorPaymentAmount').empty();
            $("#paymentAmount").val(paymentAmount.toFixed(roundoff));
        }
    };
    User.prototype.EnableDisableSubmitPayment = function (isDisabled) {
        $('#btnPayInvoice').prop("disabled", isDisabled);
    };
    //Move to cart for Saved Items
    User.prototype.MoveToCartForSavedLaterItem = function (omsTemplateLineItemId) {
        var flag = true;
        var cartItemCount = $("#hdnSavedCartItemCount").val();
        var templateId = $("#OmsTemplateId").val();
        if (cartItemCount > 0) {
            if (templateId > 0 && omsTemplateLineItemId > 0) {
                window.location.href = "/SaveForLater/AddProductToCart?omsTemplateId=" + templateId + "&omsTemplateLineItemId=" + omsTemplateLineItemId;
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSaveOrderTemplate"), "error", false, 0);
                flag = false;
            }
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AddToCartErrorMessage"), "error", false, 0);
            flag = false;
        }
        return flag;
    };
    return User;
}(ZnodeBase));
$('#custom-modal').on('hidden.bs.modal', function () {
    if ($("#custom-modal .close, .popup").length > 1) {
        $('body').addClass('modal-open');
    }
});
$('.address-popup').on('hidden.bs.modal', function () {
    $('body').addClass('modal-open');
});
//# sourceMappingURL=User.js.map