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
var EditableText = /** @class */ (function (_super) {
    __extends(EditableText, _super);
    function EditableText() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    EditableText.prototype.DialogDelete = function (DataTarget, target) {
        if (target === void 0) { target = undefined; }
        var selectedIds = DynamicGrid.prototype.GetMultipleSelectedIds(target);
        if (selectedIds.length > 0) {
            $('#' + DataTarget + '').modal('show');
        }
        else {
            $('#NoCheckboxSelected').modal('show');
        }
    };
    return EditableText;
}(ZnodeBase));
//# sourceMappingURL=TextBoxEditorFor.js.map