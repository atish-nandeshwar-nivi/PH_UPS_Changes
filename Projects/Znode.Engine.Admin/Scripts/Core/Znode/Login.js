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
var Login = /** @class */ (function (_super) {
    __extends(Login, _super);
    function Login() {
        return _super.call(this) || this;
    }
    Login.prototype.ChangePassword = function () {
        var userName = $("#btnUsername").val();
        window.location.href = "/User/ResetAdminPassword?userName=" + userName;
    };
    Login.prototype.IsShowChangePasswordPopup = function () {
        if ($("#btnUsername").val().toLowerCase() == Constant.defaultAdmin) {
            Endpoint.prototype.IsShowChangePasswordPopup(function (response) {
                if (response.status)
                    $('#divcssaddpopup').modal('show');
                else
                    $("#frmLogin").submit();
            });
        }
        else
            $("#frmLogin").submit();
        return true;
    };
    Login.prototype.SaveInCookie = function () {
        if ($("#Dont-Show-Message").prop("checked")) {
            Endpoint.prototype.SaveInCookie(function (response) {
                $("#frmLogin").submit();
            });
        }
        else {
            $("#frmLogin").submit();
        }
    };
    return Login;
}(ZnodeBase));
$(document).ready(function () {
    $("#Login").click(function () {
        var userName = $("#btnUsername").val();
        var password = $("#btnPassword").val();
        if (userName == "" || userName == null
            || typeof userName == "undefined" || password == ""
            || password == null || typeof password == "undefined") {
            if (userName == "" || userName == null || typeof userName == "undefined") {
                $("#btnUsername").addClass("input-validation-error");
                $("#valUserName").text('').text("Username is required.").addClass("field-validation-error").show();
            }
            if (password == "" || password == null || typeof password == "undefined") {
                $("#btnPassword").addClass("input-validation-error");
                $("#valPassword").text('').text("Password is required.").addClass("field-validation-error").show();
            }
            return false;
        }
        else {
            Login.prototype.IsShowChangePasswordPopup();
            return false;
        }
    });
    $("#Later").click(function () {
        Login.prototype.SaveInCookie();
    });
    $("#ResetAdminPassword").click(function () {
        Login.prototype.ChangePassword();
    });
});
//# sourceMappingURL=Login.js.map