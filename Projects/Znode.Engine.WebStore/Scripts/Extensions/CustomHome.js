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
var CustomHome = /** @class */ (function (_super) {
    __extends(CustomHome, _super);
    function CustomHome() {
        return _super.call(this) || this;
    }
    CustomHome.prototype.TestCustom = function () {
        // super.TestCustom();
        alert("derived method");
    };
    return CustomHome;
}(Home));
//# sourceMappingURL=CustomHome.js.map