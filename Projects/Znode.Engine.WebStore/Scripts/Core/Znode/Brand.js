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
var Brand = /** @class */ (function (_super) {
    __extends(Brand, _super);
    function Brand() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    Brand.prototype.Init = function () {
        ZSearch.prototype.Init();
        Category.prototype.changeProductViewDisplay();
        Category.prototype.setProductViewDisplay();
        Category.prototype.GetCompareProductList();
    };
    Brand.prototype.GetBrandData = function () {
        $('.brand-popup').modal('toggle');
        Endpoint.prototype.GetBrandData(function (response) {
            $("#brand-popup-content").html(response);
        });
    };
    Brand.prototype.GetSelectedBrand = function (brandId) {
        Endpoint.prototype.SelectBrand(brandId, function (response) {
            location.reload();
        });
    };
    Brand.prototype.SearchBrand = function (control) {
        Endpoint.prototype.SearchBrand(control.value, function (response) {
            $("#brand-popup-content").html(response);
        });
    };
    return Brand;
}(ZnodeBase));
//# sourceMappingURL=Brand.js.map