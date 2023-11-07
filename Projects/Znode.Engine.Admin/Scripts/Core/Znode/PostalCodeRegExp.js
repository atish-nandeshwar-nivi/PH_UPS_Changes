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
var PostalCodeRegExp = /** @class */ (function (_super) {
    __extends(PostalCodeRegExp, _super);
    function PostalCodeRegExp() {
        return _super.call(this) || this;
    }
    return PostalCodeRegExp;
}(ZnodeBase));
var PostalCodeValidationRegExp;
(function (PostalCodeValidationRegExp) {
    PostalCodeValidationRegExp.US = /^[0-9]{5}(?:-[0-9]{4})?$/;
    PostalCodeValidationRegExp.IN = /^[1-9][0-9]{5}$/;
})(PostalCodeValidationRegExp || (PostalCodeValidationRegExp = {}));
//# sourceMappingURL=PostalCodeRegExp.js.map