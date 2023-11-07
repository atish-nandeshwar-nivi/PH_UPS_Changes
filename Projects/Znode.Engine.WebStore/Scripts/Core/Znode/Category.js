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
var Category = /** @class */ (function (_super) {
    __extends(Category, _super);
    function Category() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    Category.prototype.Init = function () {
        Product.prototype.GetPriceAsync();
        window.sessionStorage.removeItem("lastCategoryId");
        window.sessionStorage.setItem("lastCategoryId", $("#categoryId").val());
        localStorage.setItem("isFromCategoryPage", "true");
        Category.prototype.changeProductViewDisplay();
        Category.prototype.setProductViewDisplay();
        Category.prototype.GetCompareProductList();
        Category.prototype.GetCategoryBreadCrumb($("#categoryId").val());
        ZSearch.prototype.Init();
    };
    Category.prototype.changeProductViewDisplay = function () {
        $(".productview").on("click", function () {
            var previousClass = $("#view-option-productgrid").attr('class').split(' ')[1];
            var newClass = $(this).attr('title').toLowerCase().replace(" ", "-");
            $(".productview").each(function () {
                if ($(this).attr("class").indexOf('-active') >= 0) {
                    var baseClass = $(this).attr('class').replace('-active', '');
                    $(this).removeClass($(this).attr('class'));
                    $(this).addClass(baseClass);
                }
            });
            var activeclass = $(this).attr('class') + '-active';
            $(this).removeClass($(this).attr('class'));
            $(this).addClass(activeclass);
            if (previousClass != undefined && previousClass.length > 0) {
                $("#view-option-productgrid").removeClass(previousClass).addClass(newClass);
            }
            else {
                $("#view-option-productgrid").addClass(newClass);
            }
            localStorage["currentDisplayType"] = newClass;
            InitbLazy();
        });
    };
    Category.prototype.setProductViewDisplay = function () {
        var displayType = localStorage["currentDisplayType"];
        if ($("#view-option-productgrid").html() != undefined) {
            var previousClass = $("#view-option-productgrid").attr('class').split(' ')[1];
            $(".productview").each(function () {
                if ($(this).attr("class").indexOf('-active') >= 0) {
                    var baseClass = $(this).attr('class').replace('-active', '');
                    $(this).removeClass($(this).attr('class'));
                    $(this).addClass(baseClass);
                }
            });
            $(".productview").each(function () {
                if (!displayType) {
                    if ($(this).attr("class").indexOf("grid-view") >= 0) {
                        var firstClass = $(this).attr('class');
                        $(this).removeClass(firstClass);
                        $(this).addClass(firstClass + "-active");
                    }
                }
                else {
                    if ($(this).attr("class").indexOf(displayType) >= 0) {
                        var activeclass = $(this).attr('class') + '-active';
                        $(this).removeClass($(this).attr('class'));
                        $(this).addClass(activeclass);
                    }
                }
            });
            if (!displayType) {
                $("#view-option-productgrid").removeClass(previousClass).addClass("grid-view");
            }
            else {
                $("#view-option-productgrid").removeClass(previousClass).addClass(displayType);
            }
        }
    };
    Category.prototype.AddToCompare = function (productId, categoryId) {
        Endpoint.prototype.GlobalLevelProductComapre(productId, categoryId, function (response) {
            Category.prototype.UpdateProductCompareDetails(response);
        });
        return false;
    };
    Category.prototype.RemoveProduct = function (productId) {
        var url = window.location.href.toString().split('/');
        var control = url[3];
        Endpoint.prototype.RemoveProduct(productId, control, function (response) {
            if (response != null) {
                $("#compareProductList").html(response.data.html);
                if (response.count > 0) {
                    $("#compareProductBox").removeAttr("style");
                }
                $(".remove-compare").off("click");
                $(".remove-compare").on("click", function () { Category.prototype.RemoveProduct($(this).attr("data-productid")); });
            }
            if (response.data.html == undefined || response.data.html.length < 1) {
                $("#compareProductList").hide();
            }
            else {
                $("#compareProductList").show();
            }
            return true;
        });
    };
    Category.prototype.GetCompareProductList = function () {
        Endpoint.prototype.GetCompareProductList(function (response) {
            if (response != null) {
                $("#compareProductList").html(response.data.html);
                if (response.count > 0) {
                    $("#compareProductBox").removeAttr("style");
                }
                $(".remove-compare").off("click");
                $(".remove-compare").on("click", function () { Category.prototype.RemoveProduct($(this).attr("data-productid")); });
            }
            if (response.data.html == undefined || response.data.html.length < 1) {
                $("#compareProductList").hide();
            }
            else {
                $("#compareProductList").show();
            }
            return true;
        });
    };
    Category.prototype.GetProductComparison = function () {
        Endpoint.prototype.GetProductComparison(function (response) {
            if (response.success == true) {
                $("#btnAddCompare").click();
                $("#popUp_content").html(response.data.popuphtml);
            }
            else {
                window.location.href = "/Product/ViewComparison";
            }
        });
    };
    Category.prototype.CategoryLevelComparison = function (productId, categoryId) {
        Endpoint.prototype.GlobalLevelProductComapre(productId, categoryId, function (response) {
            Category.prototype.UpdateProductCompareDetails(response);
        });
    };
    Category.prototype.UpdateProductCompareDetails = function (response) {
        if (response.success == true) {
            $("#compareProductList").html(response.data.html);
            $("#compareProductBox").removeAttr("style");
            $(".remove-compare").off("click");
            $(".remove-compare").on("click", function () { Category.prototype.RemoveProduct($(this).attr("data-productid")); });
            $("#btnAddCompare").click();
            $("#popUp_content").html(response.data.popuphtml);
        }
        else {
            $("#btnAddCompare").click();
            $("#popUp_content").html(response.data.popuphtml);
        }
        if (response.data.html == undefined || response.data.html.length < 1) {
            $("#compareProductList").hide();
        }
        else {
            $("#compareProductList").show();
        }
    };
    Category.prototype.GetCategoryBreadCrumb = function (categoryId) {
        Endpoint.prototype.GetCategoryBreadCrumb(categoryId, function (response) {
            $("#breadCrumb").html(response.breadCrumb);
        });
    };
    return Category;
}(ZnodeBase));
//# sourceMappingURL=Category.js.map