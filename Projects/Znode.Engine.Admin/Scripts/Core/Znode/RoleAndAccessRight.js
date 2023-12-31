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
var RoleAndAccessRight = /** @class */ (function (_super) {
    __extends(RoleAndAccessRight, _super);
    function RoleAndAccessRight(doc) {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    RoleAndAccessRight.prototype.Init = function () {
        this.CheckedIsParentMenu();
    };
    RoleAndAccessRight.prototype.CheckedIsParentMenu = function () {
        var isParentMenu = $("#IsParentMenu").is(":checked") ? false : true;
        if (isParentMenu)
            $('#divParentMenuList').show();
        else
            $('#divParentMenuList').hide();
    };
    RoleAndAccessRight.prototype.ValidateRole = function () {
        $("#Name :input").blur(function () {
            ZnodeBase.prototype.ShowLoader();
            RoleAndAccessRight.prototype.ValidateRoleName();
            ZnodeBase.prototype.HideLoader();
        });
    };
    RoleAndAccessRight.prototype.ValidateRoleName = function () {
        var isValid = true;
        if ($("#Name").val() != '') {
            Endpoint.prototype.IsRoleNameExist($("#Name").val(), $("#id").val(), function (response) {
                if (!response) {
                    $("#Name").addClass("input-validation-error");
                    $("#errorSpanRoleName").addClass("error-msg");
                    $("#errorSpanRoleName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistRoleName"));
                    $("#errorSpanRoleName").show();
                    isValid = false;
                }
            });
        }
        return isValid;
    };
    RoleAndAccessRight.prototype.SaveMenuRights = function (backURL) {
        if (!this.ValidateRoleName())
            return;
        var counter = 1;
        var collection = new Array();
        $("#RolesAndPermissions tr").each(function () {
            if (counter > 1 && $(this).find("input[type='radio']:checked").length > 0) {
                var menuId = $(this).find("input[type='hidden']").val();
                var rights = new Array();
                $(this).find("input[type='radio']:checked").each(function () {
                    var permissions = $(this).data("permissions").toString().split(',');
                    if ($(this).hasClass("full-access")) {
                        rights.push($(this).parent().parent().parent().find(".read-only").data("permissions"));
                    }
                    $.each(permissions, function (index, value) {
                        if (value != undefined && value != null && value != "") {
                            rights.push(value);
                        }
                    });
                });
                $(this).find("input[type='checkbox']:checked").each(function () {
                    rights.push($(this).data("permissions"));
                });
                collection.push({ MenuId: menuId, Rights: rights });
            }
            counter++;
        });
        $("#PermissionAccessString").val(JSON.stringify(collection));
        if ($("#IsSystemDefined").val().toLowerCase() == "true")
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorUpdateSystemDefinedRole"), "error", isFadeOut, fadeOutTime);
        else {
            if (typeof (backURL) != "undefined")
                $.cookie("_backURL", backURL, { path: '/' });
            $("#frmRole").submit();
        }
    };
    RoleAndAccessRight.prototype.RedirectToRoleList = function () {
        window.location.href = "/RoleAndAccessRight/RoleList";
    };
    RoleAndAccessRight.prototype.GetActionPermissions = function () {
        var permissions = [];
        $(".actionpermissions").each(function () {
            var actionPermissions = $(this).children().children("#actionPermission").attr("data-permissions") + "_" + $(this).children().children("#accessPermissionId").find(":selected").val();
            permissions.push(actionPermissions);
        });
        $("#ActionPermissions").val(permissions);
        return true;
    };
    RoleAndAccessRight.prototype.SetRoleAccessPermissions = function (permissionAccess, accessMode) {
        var assignedPermissions = [];
        var RoleMenuId;
        $(permissionAccess).each(function () {
            var permissionId = this.permission;
            var accessPermissions = $("#menu_" + this.RoleMenuId).parent().parent().find(".rights-checkbox");
            $.each(accessPermissions, function () {
                var permissions = $(this).data("permissions").toString().split(',');
                var inputType = $(this);
                $.each(permissions, function (index, value) {
                    if (value != undefined && value != null && value != "") {
                        if (value == permissionId) {
                            $(inputType).prop('checked', true);
                        }
                    }
                });
            });
        });
        $("#RolesAndPermissions tr").each(function () {
            if (accessMode) {
                $(this).find(".full-access").prop('checked', true);
                $(this).find(".delete-access").prop('checked', true);
            }
            else {
                if ($(this).find("input[type='radio']:checked").length > 0) {
                    if ($(this).find("input[type='radio']:checked").hasClass("read-only")) {
                        $(this).find(".delete-access").attr("disabled", true);
                    }
                }
                else {
                    $(this).find(".delete-access").attr("disabled", true);
                    $(this).find(".no-access").prop('checked', true);
                    var menuId = $(this).find(".RoleMenuIdClass").val();
                    $("#RolesAndPermissions tr").each(function () {
                        if ($(this).find(".ParentMenuIdClass").val() == menuId) {
                            $(this).find(".full-access").prop('disabled', true);
                        }
                    });
                }
            }
        });
    };
    RoleAndAccessRight.prototype.DeleteMenu = function (control) {
        var menuIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (menuIds.length > 0) {
            Endpoint.prototype.DeleteMenu(menuIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    RoleAndAccessRight.prototype.DeleteRole = function (control) {
        var roleIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (roleIds.length > 0) {
            Endpoint.prototype.DeleteRole(roleIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    RoleAndAccessRight.prototype.RestrictEnterButton = function () {
        $('#frmRole').on('keyup keypress', function (e) {
            var keyCode = e.keyCode || e.which;
            if (keyCode === 13) {
                e.preventDefault();
                return false;
            }
        });
    };
    RoleAndAccessRight.prototype.ResetAccessPermission = function (controllerName, className, parentMenuId, deleteStatus) {
        if (deleteStatus === void 0) { deleteStatus = false; }
        $("#RolesAndPermissions tr").each(function () {
            if ($(this).find(".ParentMenuIdClass").val() == parentMenuId) {
                var menuId = $(this).find(".RoleMenuIdClass").val();
                $("#RolesAndPermissions tr").each(function () {
                    if ($(this).find(".ParentMenuIdClass").val() == menuId) {
                        if (className != "delete-access") {
                            $(this).find(className).prop('checked', true);
                            $(this).find(className).attr('disabled', false);
                            var rightCount = $(this).find('input.full-access:checked').length;
                            if (rightCount > 0)
                                $(this).find(".delete-access").prop('checked', true).prop("disabled", false);
                            rightCount = $(this).find('input.no-access:checked').length;
                            if (rightCount > 0) {
                                $(this).find(".delete-access").prop('checked', false).attr("disabled", true);
                                $(this).find(".full-access").prop('checked', false).attr("disabled", true);
                            }
                            rightCount = $(this).find('input.read-only:checked').length;
                            if (rightCount > 0)
                                $(this).find(".delete-access").prop('checked', false).attr("disabled", true);
                        }
                        else {
                            if (deleteStatus) {
                                $(this).find(".delete-access").prop('checked', true);
                            }
                        }
                    }
                });
                if (className != "delete-access") {
                    $(this).find(className).prop('checked', true);
                    $(this).find(className).attr('disabled', false);
                    var rightCount = $(this).find('input.full-access:checked').length;
                    if (rightCount > 0)
                        $(this).find(".delete-access").prop('checked', true).prop("disabled", false);
                    rightCount = $(this).find('input.no-access:checked').length;
                    if (rightCount > 0) {
                        $(this).find(".delete-access").prop('checked', false).attr("disabled", true);
                        $(this).find(".full-access").prop('checked', false).attr("disabled", true);
                    }
                    rightCount = $(this).find('input.read-only:checked').length;
                    if (rightCount > 0)
                        $(this).find(".delete-access").prop('checked', false).attr("disabled", true);
                }
                else {
                    if (deleteStatus) {
                        $(this).find(".delete-access").prop('checked', true);
                    }
                }
            }
        });
    };
    return RoleAndAccessRight;
}(ZnodeBase));
$("#submit-rights").on("click", function () {
    var counter = 0;
    var collection = new Array();
    $("#RolesAndPermissions tr").each(function () {
        if (counter >= 1 && $(this).find("input[type='checkbox']:checked").length > 0) {
            var menuId = $(this).find("input[type='hidden']").val();
            var rights = new Array();
            $(this).find("input[type='checkbox']:checked").each(function () {
                if ($(this).data("id") !== 'all')
                    rights.push($(this).data("id"));
                if ($(this).data("id") == 'menu')
                    rights.pop();
            });
            collection.push({ MenuId: menuId, Rights: rights });
        }
        counter++;
    });
    Endpoint.prototype.SaveRights(JSON.stringify(collection), $("#roleId").val());
});
$(".All").on("change", function () {
    if ($(this).is(":checked")) {
        $(this).parent().parent().parent().find("input[type='checkbox']").prop("checked", true);
    }
    else {
        $(this).parent().parent().parent().find("input[type='checkbox']").prop("checked", false);
    }
});
$(".rights-checkbox").on("change", function () {
    var rowindex = $(this).closest('tr').index();
    var ControllerName = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('.Menu').data("controller");
    var menuID = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('.RoleMenuIdClass').val();
    if (!$(this).hasClass("delete-access")) {
        var rightCount = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.full-access:checked').length;
        if (rightCount > 0) {
            $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find(".delete-access").prop('checked', true).prop("disabled", false);
            RoleAndAccessRight.prototype.ResetAccessPermission(ControllerName, ".full-access", menuID);
        }
        rightCount = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.no-access:checked').length;
        if (rightCount > 0) {
            $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find(".delete-access").prop('checked', false).attr("disabled", true);
            RoleAndAccessRight.prototype.ResetAccessPermission(ControllerName, ".no-access", menuID);
        }
        rightCount = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.read-only:checked').length;
        if (rightCount > 0) {
            $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find(".delete-access").prop('checked', false).attr("disabled", true);
            RoleAndAccessRight.prototype.ResetAccessPermission(ControllerName, ".read-only", menuID);
        }
    }
    var deleteStatus = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find(".delete-access").prop('checked');
    RoleAndAccessRight.prototype.ResetAccessPermission(ControllerName, "delete-access", deleteStatus);
});
$(".Menu").on("change", function () {
    var rowindex = $(this).closest('tr').index();
    var rightCount = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.rights-checkbox:checked').length;
    var menuCount = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.Menu:checked').length;
    if (((menuCount) + (rightCount)) == 5)
        $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.All').prop("checked", true);
    else
        $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.All').prop("checked", false);
    var menuCount = $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.Menu:checked').length;
    if (menuCount == 0)
        $("#RolesAndPermissions tbody tr:eq(" + (rowindex) + ")").find('input.rights-checkbox').prop("checked", false);
});
$(".radio-allCheck").on("click", function () {
    if ($(this).hasClass("fullaccess")) {
        $("#RolesAndPermissions tr").each(function () {
            $(this).find(".full-access").prop('checked', true).attr("disabled", false);
            $(this).find(".delete-access").prop('checked', true).attr("disabled", false);
        });
    }
    else if ($(this).hasClass("readonly")) {
        $("#RolesAndPermissions tr").each(function () {
            $(this).find(".read-only").prop('checked', true);
            $(this).find(".delete-access").prop('checked', false).attr("disabled", true);
        });
    }
    else if ($(this).hasClass("noaccess")) {
        $("#RolesAndPermissions tr").each(function () {
            $(this).find(".no-access").prop('checked', true);
            $(this).find(".delete-access").prop('checked', false).attr("disabled", true);
            $(this).find(".full-access").prop('checked', false).attr("disabled", false);
            $("#RolesAndPermissions tr").each(function () {
                if ($(this).find(".ParentMenuIdClass").val() != '') {
                    $(this).find(".full-access").prop('disabled', true);
                }
            });
        });
    }
});
//# sourceMappingURL=RoleAndAccessRight.js.map