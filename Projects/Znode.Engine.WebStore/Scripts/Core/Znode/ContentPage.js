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
var ContentPage = /** @class */ (function (_super) {
    __extends(ContentPage, _super);
    function ContentPage() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    ContentPage.prototype.Init = function () {
        Product.prototype.GetPriceAsync();
        window.sessionStorage.removeItem("lastCategoryId");
        window.sessionStorage.setItem("lastCategoryId", $("#categoryId").val());
        localStorage.setItem("isFromCategoryPage", "true");
        Category.prototype.changeProductViewDisplay();
        Category.prototype.setProductViewDisplay();
        Category.prototype.GetCompareProductList();
        ZSearch.prototype.Init();
    };
    return ContentPage;
}(ZnodeBase));
//# sourceMappingURL=ContentPage.js.map