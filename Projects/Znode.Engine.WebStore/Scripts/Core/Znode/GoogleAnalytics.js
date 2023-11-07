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
var GoogleAnalytics = /** @class */ (function (_super) {
    __extends(GoogleAnalytics, _super);
    function GoogleAnalytics() {
        return _super.call(this) || this;
    }
    //Send the product list ecommerce data to Google Analytics through data layer
    GoogleAnalytics.prototype.SendProductListDataImpressions = function (data, currencyCode) {
        var ecommerce = {};
        var impressions = [];
        $.each(data, function (v, e) {
            var listName;
            if (e.SearchKeyword != null && e.SearchKeyword != "") {
                listName = "Search results for " + e.SearchKeyword;
            }
            else {
                listName = e.CategoryName;
            }
            var product = {
                id: e.SKU,
                name: e.Name,
                category: e.CategoryName,
                brand: e.BrandName,
                list: listName,
                price: e.ProductPrice
            };
            impressions.push(product);
        });
        ecommerce["currencyCode"] = currencyCode;
        ecommerce["impressions"] = impressions;
        znodeDataLayer.push({ "ecommerce": ecommerce });
    };
    ;
    //Send the product detail views ecommerce data to Google Analytics through data layer
    GoogleAnalytics.prototype.SendProductDetailViews = function (data, currencyCode) {
        var product = {
            id: data.SKU,
            name: data.Name,
            category: data.CategoryName,
            brand: data.BrandName,
            price: data.ProductPrice
        };
        znodeDataLayer.push({
            "event": "productDetail",
            "ecommerce": {
                "currencyCode": currencyCode,
                "detail": {
                    "products": [product]
                }
            }
        });
    };
    GoogleAnalytics.prototype.SendProductClicks = function (data, currencyCode, productUrl) {
        var product = {
            id: data.SKU,
            name: data.Name,
            category: data.CategoryName,
            brand: data.BrandName,
            price: data.ProductPrice
        };
        znodeDataLayer.push({
            'event': 'ProductClick',
            'ecommerce': {
                'currencyCode': currencyCode,
                'click': {
                    'actionField': { 'list': data.CategoryName },
                    'products': [product]
                }
            },
            'eventCallback': function () { document.location.href = productUrl; }
        });
    };
    GoogleAnalytics.prototype.SendProductAddToCarts = function (control, event, currencyCode) {
        var brand = "";
        var quantity = "";
        var price = "";
        var name = "";
        if ($(control).closest('form').children("#dynamic-productname").val() != undefined) {
            name = $(control).closest('form').children("#dynamic-productname").val();
        }
        else {
            name = $(".product-name").html();
        }
        ;
        if ($("#lnkProductBrand").html() != undefined) {
            brand = $("#lnkProductBrand").html().trim();
        }
        ;
        if ($("#spnProductPrice").html() != undefined) {
            price = $("#spnProductPrice").html().trim();
        }
        ;
        if ($("#Quantity").val() != undefined) {
            quantity = $("#Quantity").val();
        }
        else {
            quantity = $(control).closest('form').children("#dynamic-quantity").val();
        }
        var cartItem = {
            id: $(control).closest('form').children("#dynamic-sku").val(),
            name: name,
            brand: brand,
            variant: $(control).closest('form').children("#dynamic-configurableproductskus").val(),
            quantity: quantity,
            price: price
        };
        znodeDataLayer.push({
            'event': 'addToCart',
            'ecommerce': {
                'currencyCode': currencyCode,
                'add': {
                    'products': [cartItem
                    ]
                }
            }
        });
    };
    GoogleAnalytics.prototype.SendAddToCartsFromQuickOrder = function () {
        var _content = $(".quickOrderAddToCart").closest(".quick-order-container");
        var productId = parseInt(_content.find("#hdnQuickOrderProductId").val());
        var cartItem = {
            id: _content.find("#hdnQuickOrderSku").val(),
            name: _content.find("#hdnQuickOrderProductName").val(),
            brand: "",
            price: _content.find("#hdnRetailPrice").val(),
            variant: $(".quickOrderAddToCart").closest('form').children("#dynamic-configurableproductskus").val(),
            quantity: $("#txtQuickOrderQuantity").val()
        };
        znodeDataLayer.push({
            'event': 'addToCart',
            'ecommerce': {
                'add': {
                    'products': [cartItem]
                }
            }
        });
    };
    GoogleAnalytics.prototype.SendAddToCartsFromMultipleQuickOrder = function (data) {
        var ecommerce = {};
        var add = {};
        var cartItems = [];
        $.each(data, function (v, e) {
            var cartItem = {
                id: e.Sku,
                name: e.ProductName,
                brand: "",
                price: "",
                variant: "",
                quantity: e.Quantity
            };
            cartItems.push(cartItem);
        });
        add["products"] = cartItems;
        ecommerce["add"] = add;
        znodeDataLayer.push({ "ecommerce": ecommerce, "event": "addToCart" });
    };
    GoogleAnalytics.prototype.SendRemoveFromCartsForAllCartItems = function (data) {
        var ecommerce = {};
        var remove = {};
        var cartItems = [];
        $.each(data, function (v, e) {
            var cartItem = {
                id: e.SKU,
                name: e.Name,
                brand: "",
                price: e.ProductPrice,
                variant: e.Variant,
                quantity: e.Quantity
            };
            cartItems.push(cartItem);
        });
        remove["products"] = cartItems;
        ecommerce["remove"] = remove;
        znodeDataLayer.push({ "ecommerce": ecommerce, "event": "removeFromCart" });
    };
    GoogleAnalytics.prototype.SendRemoveFromCartsForSingleCartItem = function (data) {
        var cartItem = {
            id: data.SKU,
            name: data.Name,
            brand: "",
            price: data.ProductPrice,
            variant: data.Variant,
            quantity: data.Quantity
        };
        znodeDataLayer.push({
            'event': 'removeFromCart',
            'ecommerce': {
                'remove': {
                    'products': [cartItem]
                }
            }
        });
    };
    GoogleAnalytics.prototype.SendEcommerceCheckoutData = function (data) {
        var ecommerce = {};
        var checkout = {};
        var products = [];
        var actionField = {};
        $.each(data, function (v, e) {
            var product = {};
            product["id"] = e.SKU;
            product["name"] = e.Name;
            product["price"] = e.ProductPrice;
            product["quantity"] = e.Quantity;
            products.push(product);
        });
        actionField["step"] = 1;
        actionField["option"] = "Shopping Cart Page";
        checkout["actionField"] = actionField;
        checkout["products"] = products;
        ecommerce["checkout"] = checkout;
        znodeDataLayer.push({ "ecommerce": ecommerce, "event": "checkout" });
    };
    GoogleAnalytics.prototype.SendEcommerceCheckoutOptionData = function (step, option) {
        znodeDataLayer.push({
            'event': 'checkout',
            'ecommerce': {
                'checkout': {
                    'actionField': { 'step': step, 'option': option }
                }
            }
        });
    };
    GoogleAnalytics.prototype.SendEcommercePurchaseData = function (data, storeName) {
        var ecommerce = {};
        var purchase = {};
        var actionField = {
            id: data.OrderNumber,
            affiliation: storeName,
            revenue: data.Total,
            tax: data.TaxCost,
            shipping: data.ShippingCost,
        };
        if (data.CouponCode != "" && data.CouponCode != null) {
            actionField["coupon"] = GoogleAnalytics.prototype.GetEcommerceOrderCouponCode(data.CouponCode);
        }
        purchase["actionField"] = actionField;
        var purchasedProducts = new Array();
        $.each(data.PurchasedProducts, function (v, e) {
            var purchasedProduct = {
                id: e.Id,
                sku: e.Sku,
                name: e.ProductName,
                quantity: e.Quantity,
                price: e.Price,
                total: e.Price * e.Quantity,
                description: e.Description
            };
            purchasedProducts.push(purchasedProduct);
        });
        purchase["products"] = purchasedProducts;
        ecommerce["purchase"] = purchase;
        znodeDataLayer.push({ "ecommerce": ecommerce });
    };
    GoogleAnalytics.prototype.GetEcommerceOrderCouponCode = function (item) {
        var itemValue = item != undefined ? item : "";
        return itemValue;
    };
    return GoogleAnalytics;
}(ZnodeBase));
//# sourceMappingURL=GoogleAnalytics.js.map