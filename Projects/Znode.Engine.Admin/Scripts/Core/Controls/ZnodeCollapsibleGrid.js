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
var CollapsibleGrid = /** @class */ (function (_super) {
    __extends(CollapsibleGrid, _super);
    function CollapsibleGrid() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    CollapsibleGrid.prototype.HideShowExpandOption = function (control, area, controller, action) {
        $(control).find("em").toggleClass("z-add z-minus");
        $(control).closest("thead").next("tbody .attributeData").toggle();
        if ($(control).find("em").hasClass("z-minus")) {
            this._url = "/" + area + "/" + controller + "/" + action;
            this._attributeId = $(control).data("attributegroupid");
            this._familyId = $(control).data("attributefamilyid");
            ZnodeBase.prototype.ShowLoader();
            this._endpoint.GetAssociatedAttributes(this._url, this._attributeId, this._familyId, function (response) {
                if (response) {
                    $(control).closest("thead").next("tbody .attributeData").html(response).show();
                    ZnodeBase.prototype.HideLoader();
                }
                else {
                    $(control).closest("thead").next("tbody .attributeData").html("No attributes associated to be displayed.").show();
                    ZnodeBase.prototype.HideLoader();
                }
            });
        }
    };
    return CollapsibleGrid;
}(ZnodeBase));
//# sourceMappingURL=ZnodeCollapsibleGrid.js.map