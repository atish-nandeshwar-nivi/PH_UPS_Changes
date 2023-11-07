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
        User.prototype._multiFastItemdata = new Array();
        return _this;
    }
    User.prototype.Init = function () {
        $("#ddlUserType").off("change");
        $("#ddlUserType").on("change", function () {
            $("#hdnRoleName").val($("#ddlUserType option:selected").text());
            Account.prototype.ShowHidePermissionDiv();
        });
        $("#ddlUserType").change();
        Account.prototype.ShowHidePermissionDiv();
        Account.prototype.ValidateAccountsCustomer();
        User.prototype.GetUserPermissionList();
        $("#rolelist").on("change", function () {
            $("#hdnRoleName").val($("#rolelist option:selected").text());
        });
        $("#rolelist").change();
        $("#ddl_Impersonate_Portal_list").on("change", function () {
            $("#hdnImpersonatePortalId").val($("#ddl_Impersonate_Portal_list option:selected").val());
            User.prototype.ValidationCustomerImpersonation();
        });
        User.prototype.SetRoleName();
        User.prototype.SetIsSelectAllPortalOnInit();
        User.prototype.SubmitOnEnterKey();
    };
    User.prototype.SetRoleName = function () {
        $("#ddlUserType").on("change", function () {
            $("#hdnRoleName").val($("#ddlUserType option:selected").text());
        });
    };
    User.prototype.DeleteUsers = function (control) {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            Endpoint.prototype.DeleteUsers(accountIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    User.prototype.DeleteCustomer = function (control) {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            Endpoint.prototype.DeleteCustomer(accountIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.EnableUserAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableUserAccount(accountIds, true, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/User/UsersList";
            });
            ZnodeBase.prototype.HideLoader();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.DisableUserAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableUserAccount(accountIds, false, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/User/UsersList";
            });
            ZnodeBase.prototype.HideLoader();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.EnableCustomerAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableCustomerAccount(accountIds, true, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/Customer/CustomersList";
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.DisableCustomerAccount = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        ;
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.EnableDisableCustomerAccount(accountIds, false, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/Customer/CustomersList";
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.UserResetPassword = function () {
        var accountIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (accountIds.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.UserResetPassword(accountIds, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/User/UsersList";
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
            Endpoint.prototype.CustomerResetPassword(accountIds, function (res) {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/Customer/CustomersList";
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.ResetPasswordCustomer = function () {
        var accountId = $("#AccountId").val();
        window.location.href = window.location.protocol + "//" + window.location.host + "/customer/singleresetpassword?accountId=" + accountId;
    };
    User.prototype.EnableDisableSingleAccount = function (isAdminUser) {
        var status = $("#EnableDisable").attr("data-enablediasble");
        var isLock = JSON.parse(status);
        var id = $('#UserId').val();
        console.log(isAdminUser);
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.EnableDisableSingleUserAccount(id, isLock, isAdminUser, function (res) {
            ZnodeBase.prototype.HideLoader();
            var errorType = 'error';
            if (res.status) {
                errorType = 'success';
                var description = isLock ? ZnodeBase.prototype.getResourceByKeyName("LockAccountConfirmationMessage") : ZnodeBase.prototype.getResourceByKeyName("UnlockAccountConfirmationMessage");
                $('#PopUpConfirmDisableEnable p').text(description);
                isLock ? $('#EnableDisable').text('Disable') : $('#EnableDisable').text('Enable');
                $('#EnableDisable').attr("data-enablediasble", !isLock);
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, errorType, isFadeOut, fadeOutTime);
            }
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, errorType, isFadeOut, fadeOutTime);
        });
    };
    User.prototype.ResetPasswordUsers = function () {
        var userId = $("#divAddCustomerAsidePanel #UserId").val();
        if (userId == undefined)
            userId = $("#UserId").val();
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.SingleResetPassword(userId, function (res) {
            ZnodeBase.prototype.HideLoader();
            var errorType = 'error';
            if (res.status) {
                errorType = 'success';
            }
            ZnodeBase.prototype.CancelUpload("divAddCustomerAsidePanel");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, errorType, isFadeOut, fadeOutTime);
        });
    };
    User.prototype.GetSalesRep = function () {
        var userId = $("#UserId").val();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Customer/GetSalesRepList?userId=' + userId, 'SalesRepAssociationPanel');
    };
    User.prototype.GetSalesRepForAccount = function (IsUpdate) {
        var portalId = IsUpdate == '1' ? $("#CompanyAccount_PortalId").val() : $("#hdnPortalId").val();
        if (portalId == "") {
            $(".fstElement").addClass('input-validation-error');
            $("#errorRequiredStore").text(ZnodeBase.prototype.getResourceByKeyName("SelectPortal")).addClass("text-danger").show();
            return;
        }
        else {
            $(".fstElement").removeClass('input-validation-error');
            $("#errorRequiredStore").text('').removeClass("field-validation-error").hide();
        }
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Customer/GetSalesRepListForAccount?portalId=' + portalId, 'SalesRepAssociationPanel');
    };
    User.prototype.SetSalesRepById = function () {
        $("#ZnodeAssociatedSalesRep #grid tbody tr").on("click", function (e) {
            e.preventDefault();
            var textbox = $(this);
            var userid = textbox.find("td a").text();
            var salesRep = textbox.find("td[class='columnUsername']").text() + " | " + textbox.find("td[class='columnFullName']").text();
            ZnodeBase.prototype.ShowLoader();
            $("#SalesRep").val(salesRep);
            $("#hdnSalesRepId").val(userid);
            ZnodeBase.prototype.CancelUpload('SalesRepAssociationPanel');
            Order.prototype.HideLoader();
        });
    };
    User.prototype.ImpersonateUsers = function () {
        var userId = $("#frmImpersonateCustomerAccount #UserId").val();
        var portalId = $("#frmImpersonateCustomerAccount #hdnImpersonatePortalId").val();
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.GetImpersonateURL(portalId, userId, function (response) {
            ZnodeBase.prototype.HideLoader();
            var errorType = 'error';
            if (response.status) {
                if (response.url != "") {
                    window.open(response.url, '_blank');
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper($("#frmImpersonateCustomerAccount #hdnImpersonateInvalidTokenMsg").val(), 'error', isFadeOut, fadeOutTime);
                }
            }
        });
    };
    User.prototype.SetIsSelectAllPortal = function () {
        User.prototype._multiFastItemdata = new Array();
        if ($("#AllStoresCheck").val() != undefined) {
            if ($("#AllStoresCheck").prop('checked')) {
                $("#IsSelectAllPortal").val("true");
                $("#txtPortalIds").val(User.prototype._multiFastItemdata.push("0"));
                $("#PortalIdString").val("");
            }
            else {
                $("#IsSelectAllPortal").val("false");
                $("#areaList").find(".fstChoiceItem").each(function () {
                    if ($(this).data('value') != undefined)
                        User.prototype._multiFastItemdata.push($(this).data('value'));
                });
                $("#txtPortalIds").val(User.prototype._multiFastItemdata);
            }
        }
        return true;
    };
    User.prototype.SetIsSelectAllPortalOnInit = function () {
        $("#AllStoresCheck").on("change", function () {
            if ($(this).prop('checked')) {
                $("#IsSelectAllPortal").val("true");
                $("#divPortalIds").hide();
            }
            else {
                $("#IsSelectAllPortal").val("false");
                $("#divPortalIds").show();
            }
        });
        if ($("#IsSelectAllPortal").val() == "True") {
            $("#AllStoresCheck").attr('checked', 'checked');
            $(".storediv").hide();
        }
        else if (!$('#txtPortalIds').prop('disabled')) {
            if (($('#PortalIdString').val() != undefined) && ($('#PortalIdString').val() != "")) {
                var portalsArray = $('#PortalIdString').val().split(',');
                Endpoint.prototype.GetPortalList(Constant.storelist, function (response) {
                    ZnodeBase.prototype.SetInitialMultifastselectInput(portalsArray, response, $("#txtPortalIds"));
                });
            }
            else {
                ZnodeBase.prototype.SetInitialMultifastselectInput(null, null, $("#txtPortalIds"));
            }
            $(".storediv").show();
        }
    };
    User.prototype.ShowHideStoreListinput = function (ctrl) {
        if (ctrl != '') {
            if (ctrl.checked) {
                $(".fstElement").removeClass('input-validation-error');
                $("#errorRequiredStore").text('').text("").removeClass("field-validation-error").hide();
                $(".storediv").hide();
            }
            else {
                ZnodeBase.prototype.SetInitialMultifastselectInput(null, null, $("#txtPortalIds"));
                $(".storediv").show();
            }
        }
    };
    User.prototype.ShowHidePortals = function () {
        if ($("#IsSelectAllPortal").val() == "True") {
            $("#divPortalIds").hide();
        }
        else {
            $("#divPortalIds").show();
        }
        $("#chkIsSelectAllPortal").on("change", function () {
            if ($(this).prop('checked')) {
                $("#IsSelectAllPortal").val("true");
                $("#divPortalIds").hide();
            }
            else {
                $("#IsSelectAllPortal").val("false");
                $("#divPortalIds").show();
            }
        });
    };
    User.prototype.ClickSelectAllPortal = function () {
        $(".chkPortal").click(function () {
            if ($(this).prop('checked')) {
                if ($('.chkPortal:checked').length == ($('.chkPortal').length / 2)) {
                    $("#chkIsSelectAllPortal").prop('checked', 'checked');
                    $("#IsSelectAllPortal").val("true");
                    $("#divPortalIds").hide();
                }
            }
        });
    };
    User.prototype.SubmitOnEnterKey = function () {
        $("#btnPassword").keypress(function (e) {
            if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
                $('button[type=submit]').click();
                return true;
            }
        });
        return true;
    };
    User.prototype.OnAccountSelection = function () {
        var selectedAccount = $("#AccountId").val();
        if (selectedAccount == 0 && selectedAccount == "") {
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
            $('#ddlUserType').val("User");
        });
        $('#divRole').show();
        $('#ddlPortals').show();
        $('#customer_general_information').show();
        $('#errorSelectAccountId').html("");
    };
    User.prototype.OnUserTypeSelection = function () {
        var selectedRole = $("#ddlUserType option:selected").text();
        $("#ddlUserType").removeClass("input-validation-error");
        $("#valRoleName").text('').text("").removeClass("field-validation-error").hide();
        if (selectedRole == null || selectedRole == "") {
            $('#ddlRole').children('option:not(:first)').remove();
            $('#divRole').show();
            return false;
        }
        var selectedAccount = $("#AccountId").val();
        if (selectedAccount == '') {
            selectedAccount = 0;
        }
        $('#divRole').show();
        Endpoint.prototype.GetPermissionList(selectedAccount, $("#AccountPermissionAccessId").val(), function (response) {
            $('#permission_options').html("");
            $('#permission_options').html(response);
            $("#ddlPermission").attr("onchange", "User.prototype.OnPermissionSelection();");
        });
        $("#ddlPermission").change();
    };
    User.prototype.OnPermissionSelection = function () {
        var permission = $("#ddlPermission option:selected").attr('data-permissioncode');
        var $sel = $("#divRole");
        var value = $sel.val();
        var text = $("option:selected", $sel).text();
        $('#PermissionCode').val(permission);
        $('#PermissionsName').val(text);
    };
    User.prototype.GetSelectedAccount = function () {
        $("#grid").find("tr").click(function () {
            var accountName = $(this).find("td[class='accountnamecolumn']").text();
            var accountCode = $(this).find("td[class='accountcodecolumn']").text();
            var accountId = $(this).find("td")[0].innerHTML;
            $("#PortalId").val($(this).find("td[class='portalId']").text());
            $("#ddlUserType option:selected").prop("selected", false);
            if (accountId != undefined && accountName != undefined) {
                $('#AccountName').val((accountCode == "" || accountCode == undefined) ? accountName : accountName + " | " + accountCode);
                $('#selectedAccountName').val(accountName + " | " + accountCode);
                $('#AccountId').val(accountId);
                $('#accountListId').hide(700);
                GiftCard.prototype.GetActiveCurrencyToStore("");
                $("#ZnodeUserAccountList").html("");
                ZnodeBase.prototype.RemovePopupOverlay();
                User.prototype.OnAccountSelection();
                return;
            }
            else {
                ZnodeBase.prototype.RemovePopupOverlay();
                return;
            }
        });
    };
    //This method is used to get account list on aside panel.
    User.prototype.GetAccountList = function (selectedPortal) {
        $("#divRole").hide();
        $("#maxBudgetDiv").hide();
        var accountName = $("#AccountName").val();
        if (accountName.includes("|")) {
            var index = accountName.indexOf("|");
            accountName = accountName.substring(index + 1).trim();
        }
        if (selectedPortal == 0)
            selectedPortal = $("#PortalId").val();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Customer/GetAccountList?portalId=' + selectedPortal + '&accountCode=' + accountName, 'accountListId');
    };
    //Clear selected account name.
    User.prototype.ClearAccountName = function () {
        $('#AccountName').val(undefined);
        $('#AccountId').val(undefined);
        $('#ddlDepartment').children('option').remove();
        $('#ddlAccountType').children('option').remove();
        $('#ZnodeUserAccountList').html("");
        $('#ddlUserType').children('option').remove();
        $('#divDepartmentId').hide();
        $('#divUserTypeId').hide();
        $('#divRole').hide();
        $('#ddlPortals').show();
        $('#hdnRoleName').val("");
        return false;
    };
    User.prototype.CheckIsAllPortalSelected = function () {
        if ($("#IsSelectAllPortal").val() == "True") {
            $("#areaList ul li input:checkbox").click();
        }
    };
    User.prototype.ConvertToOrder = function () {
        window.location.href = $("#hdnOrderURL").val();
    };
    User.prototype.GetUserPermissionList = function () {
        var selectedAccount = $("#AccountId").val();
        if (selectedAccount == '' || selectedAccount == null) {
            selectedAccount = 0;
        }
        Endpoint.prototype.GetPermissionList(selectedAccount, $("#AccountPermissionAccessId").val(), function (response) {
            $('#permission_options').html("");
            $('#permission_options').html(response);
            $("#ddlPermission").attr("onchange", "User.prototype.OnPermissionSelection();");
        });
    };
    User.prototype.ValidateUser = function (backURL) {
        var userName = $("#UserName").val();
        var isSubmit = true;
        var isValidate = User.prototype.SaveAdminUser();
        if (isValidate) {
            Endpoint.prototype.IsUserNameAnExistingShopper(userName, function (response) {
                if (typeof (backURL) != "undefined")
                    $.cookie("_backURL", backURL, { path: '/' });
                if (response.status) {
                    if ($("#UserId").val() == 0) {
                        if (response.message != null && response.message != "") {
                            $("#btnConvertShopperToAdmin").attr("onclick", '$("#ConfirmPopup").hide()');
                            $("#divShoppertoAdminValidation").html(response.message);
                        }
                        else {
                            $("#divShoppertoAdminValidation").html(ZnodeBase.prototype.getResourceByKeyName("ShopperToAdminConversionConfirmation"));
                            $("#btnConvertShopperToAdmin").attr("onclick", 'User.prototype.ConvertShopperToAdmin();$("#ConfirmPopup").hide()');
                        }
                        $(".drop-panel-overlay").show();
                        $("#ConfirmPopup").show();
                        isSubmit = false;
                    }
                }
                if (isSubmit)
                    $("#frmcreateeditstoreadmin").submit();
            });
        }
    };
    User.prototype.ConvertShopperToAdmin = function () {
        $("#frmcreateeditstoreadmin").attr('action', 'ConvertShopperToAdmin');
        $("#frmcreateeditstoreadmin").submit();
    };
    User.prototype.SaveAdminUser = function () {
        var isValidate = true;
        $("#txtPortalName").val('');
        $('#PortalIds').val("0");
        $('#PortalId').val("0");
        $('#hdnPortalId').val("0");
        if ($("#UserName").val() == "") {
            $("#UserName").addClass('input-validation-error');
            $("#errorRequiredUserName").text(ZnodeBase.prototype.getResourceByKeyName("ErrorUsernameRequired")).addClass("text-danger").show();
            isValidate = false;
        }
        if ($("#FirstName").val() == "") {
            $("#FirstName").addClass('input-validation-error');
            $("#errorRequiredFirstName").text(ZnodeBase.prototype.getResourceByKeyName("ErrorFirstNameRequired")).addClass("text-danger").show();
            isValidate = false;
        }
        if ($("#LastName").val() == "") {
            $("#LastName").addClass('input-validation-error');
            $("#errorRequiredLastName").text(ZnodeBase.prototype.getResourceByKeyName("ErrorLastNameRequired")).addClass("text-danger").show();
            isValidate = false;
        }
        if ($("#Email").is(':visible') && $("#Email").val() == '') {
            $("#errorRequiredEmail").text('').text(ZnodeBase.prototype.getResourceByKeyName("EmailAddressIsRequired")).removeClass('field-validation-valid').addClass("field-validation-error").show();
            $("#Email").removeClass('valid').addClass('input-validation-error');
            isValidate = false;
        }
        if ($("#Email").is(':visible') && !RegExp(/^((\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)\s*[,]{0,1}\s*)+$/).test($("#Email").val())) {
            $("#errorRequiredEmail").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorEmailAddress")).removeClass('field-validation-valid').addClass("field-validation-error").show();
            $("#Email").removeClass('valid').addClass('input-validation-error');
            isValidate = false;
        }
        if ($("#AllStoresCheck").val() != undefined) {
            if ($("#AllStoresCheck").prop('checked')) {
                $(".fstElement").css({ "background-color": "#e7e7e7" });
                $(".fstElement").removeClass('input-validation-error');
                $("#errorRequiredStore").text('').text("").removeClass("field-validation-error").hide();
                $("#txtPortalName").removeClass('input-validation-error');
            }
            else {
                if ($("#txtPortalIds").val() == "") {
                    $(".fstElement").addClass('input-validation-error');
                    $("#errorRequiredStore").text(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneStore")).show();
                    isValidate = false;
                }
                else {
                    $(".fstElement").removeClass('input-validation-error');
                    $("#errorRequiredStore").text('').removeClass("field-validation-error").hide();
                }
            }
        }
        return isValidate;
    };
    User.prototype.ValidateUserForSameAsAdmin = function (backURL) {
        if (typeof (backURL) != "undefined")
            $.cookie("_backURL", backURL, { path: '/' });
        if ($("#UserId").val() > 0) {
            if ($("#ModifiedByUser").val() != $("#UserName").val() && $("#ModifiedBy").val() == $("#UserId").val()) {
                $(".drop-panel-overlay").show();
                $("#ConfirmPopup").show();
            }
            else {
                $('#frmCreateEditCustomerAccount').submit();
            }
        }
        else {
            $("#frmCreateEditCustomerAccount").attr('action', 'CustomerCreate');
            $("#frmCreateEditCustomerAccount").submit();
        }
    };
    User.prototype.ConfirmChangeUserName = function () {
        $("#frmCreateEditCustomerAccount").attr('action', 'CustomerEdit');
        $("#frmCreateEditCustomerAccount").submit();
    };
    //Validate reGx using Country code.
    User.prototype.IsValidPostalCode = function (postalCode) {
        //Currently regex for few countries is available.To validate for other countries add regex in 'ZipCodeRegex.ts'.
        var postalCodeRegExp = PostalCodeValidationRegExp[$('#CountryCode').val()];
        if (postalCodeRegExp)
            return new RegExp(postalCodeRegExp).test(postalCode);
        return true;
    };
    User.prototype.ValidationCustomerImpersonation = function () {
        var portal = $("#hdnImpersonatePortalId").val();
        if (portal == null || portal == "" || portal == "0") {
            $("#errorRequiredddl_portal_list").html(ZnodeBase.prototype.getResourceByKeyName("SelectPortal"));
            $("#btnCustomerImpersonation").prop("disabled", true);
            return false;
        }
        $('#btnCustomerImpersonation').removeAttr("disabled");
        return true;
    };
    User.prototype.ValidateSalesRepUser = function (backURL) {
        var isValidate = User.prototype.SaveAdminUser();
        if (isValidate) {
            if (typeof (backURL) != "undefined")
                $.cookie("_backURL", backURL, { path: '/' });
            $("#frmcreateeditstoreadmin").submit();
        }
    };
    User.prototype.OnMultiSelectUserPortalResult = function () {
        if ($("#txtPortalIds").val() != undefined && $("#txtPortalIds").val() != '') {
            $(".fstElement").removeClass('input-validation-error');
            $("#errorRequiredStore").text('').text("").removeClass("field-validation-error").hide();
        }
        else {
            $(".fstElement").addClass('input-validation-error');
            $("#errorRequiredStore").text(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneStore")).show();
        }
    };
    User.prototype.SetUsername = function () {
        var username = $("#UserName").val();
        $("#currentUsername").val(username);
    };
    User.prototype.ClearField = function () {
        $("#newUsername").removeClass("input-validation-error").val("");
        $("#errorMessage").removeClass("error-msg").text("");
    };
    User.prototype.ValidateUsername = function () {
        var isValid = true;
        var regex = new RegExp(/^((\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)\s*[,]{0,1}\s*)+$/);
        var newUsername = $("#newUsername").val();
        $("#newUsername").addClass("input-validation-error error-msg");
        if (newUsername == "") {
            $("#errorMessage").addClass("error-msg").text(ZnodeBase.prototype.getResourceByKeyName("ErrorUsernameRequired")).show();
            isValid = false;
        }
        else if (!regex.test(newUsername)) {
            $("#errorMessage").addClass("error-msg").text(ZnodeBase.prototype.getResourceByKeyName("ErrorEmailAddress")).show();
            isValid = false;
        }
        else {
            return isValid;
        }
    };
    User.prototype.UpdateExistingUsername = function () {
        if (User.prototype.ValidateUsername()) {
            var data = User.prototype.BindUserDetailsViewModel();
            Endpoint.prototype.UpdateExistingUserName(data, function (response) {
                if (response.success != null && response.success == "undefined") {
                    $("#btnCancelUpdate").click();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorUsernameUpdate"), 'error', isFadeOut, fadeOutTime);
                }
                else if (response.success) {
                    var newUsername = $("#newUsername").val();
                    $("#UserName").val(newUsername);
                    $("#btnCancelUpdate").click();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("UsernameUpdatedSuccessfully"), 'success', isFadeOut, fadeOutTime);
                }
                else {
                    $("#newUsername").addClass("input-validation-error");
                    $("#errorMessage").addClass("error-msg").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistUserName")).show();
                }
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("UsernameUpdateFailed"), 'error', isFadeOut, fadeOutTime);
        }
    };
    User.prototype.BindUserDetailsViewModel = function () {
        var userDetailModel = {
            UserName: $("#newUsername").val(),
            UserId: $("#UserId").val(),
            PortalId: $("#PortalId").val(),
        };
        return userDetailModel;
    };
    return User;
}(ZnodeBase));
//Hide Validation Message on focus of postal code textBox
$(document).on("focus", "#TextPostalCode", function () {
    $('#ValidatePostalCode').hide();
});
//On Focus out of Texbox call ValidatePostalCode()
$(document).on("focusout", "#TextPostalCode", function () {
    // Show/Hide validation message.
    var postalCode = $("#TextPostalCode").val();
    var formId = $("#TextPostalCode").closest("form").attr('id');
    if ($("#TextPostalCode-error").html() || User.prototype.IsValidPostalCode(postalCode) || postalCode == "") {
        $('#ValidatePostalCode').hide();
    }
    else {
        $('#ValidatePostalCode').show();
    }
    //Stop from submitting the form if the postal code validation is shown
    $("#" + formId).off("submit").on("submit", function () {
        if ($("#DisplayName").val() == "" || $("#FirstName").val() == "" || $("#LastName").val() == "" || $("#Address1").val() == "" || $("#StateName-error:visible").length == 1 || postalCode == "" || $("#PhoneNumber").val() == "" || $("#ValidatePostalCode:visible").length == 1) {
            return false;
        }
    });
});
//# sourceMappingURL=User.js.map