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
var Review = /** @class */ (function (_super) {
    __extends(Review, _super);
    function Review() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    Review.prototype.DeleteCustomerReview = function (control) {
        var customerReviewIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (customerReviewIds.length > 0) {
            Endpoint.prototype.DeleteCustomerReview(customerReviewIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Review.prototype.ChangeStatusNew = function (control) {
        var statusId = $(".page-container").find('ul li:nth-child(2) a').attr("id");
        var customerReviewIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (customerReviewIds.length > 0) {
            Endpoint.prototype.ChangeStatus(customerReviewIds, statusId, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/Review/List";
            });
        }
    };
    Review.prototype.ChangeStatusActive = function (control) {
        var statusId = $(".page-container").find('ul li:nth-child(3) a').attr("id");
        var customerReviewIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (customerReviewIds.length > 0) {
            Endpoint.prototype.ChangeStatus(customerReviewIds, statusId, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/Review/List";
            });
        }
    };
    Review.prototype.ChangeStatusInactive = function (control) {
        var statusId = $(".page-container").find('ul li:nth-child(4) a').attr("id");
        var customerReviewIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (customerReviewIds.length > 0) {
            Endpoint.prototype.ChangeStatus(customerReviewIds, statusId, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/Review/List";
            });
        }
    };
    return Review;
}(ZnodeBase));
//# sourceMappingURL=Review.js.map