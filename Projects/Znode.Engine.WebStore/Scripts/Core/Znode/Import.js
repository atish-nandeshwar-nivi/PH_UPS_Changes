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
var Import = /** @class */ (function (_super) {
    __extends(Import, _super);
    function Import() {
        return _super.call(this) || this;
    }
    Import.prototype.ValidateImportFile = function () {
        if ($("#ImportData").val() == "") {
            $("#importErrorFileTypeAndSize").html(ZnodeBase.prototype.getResourceByKeyName("FileNotPresentError"));
            return false;
        }
    };
    //Delete shipping logs by log ids.
    Import.prototype.DeleteImportLogs = function (control) {
        var importProcessLogId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (importProcessLogId.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.DeleteImportLogs(importProcessLogId, function (res) {
                ZnodeBase.prototype.HideLoader();
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Delete user logs by log ids.
    Import.prototype.DeleteUserImportLogs = function (control) {
        var importProcessLogId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (importProcessLogId.length > 0) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.DeleteImportLogs(importProcessLogId, function (res) {
                ZnodeBase.prototype.HideLoader();
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeUserImportProcessLog").find("#refreshGrid"), res);
            });
        }
    };
    return Import;
}(ZnodeBase));
//# sourceMappingURL=Import.js.map