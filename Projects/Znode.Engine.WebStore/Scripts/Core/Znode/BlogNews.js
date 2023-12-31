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
var BlogNews = /** @class */ (function (_super) {
    __extends(BlogNews, _super);
    function BlogNews() {
        return _super.call(this) || this;
    }
    BlogNews.prototype.Init = function () {
    };
    BlogNews.prototype.SavedCommentSuccessMessage = function (response) {
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper("Comment added successfully.", "success", false, 0);
        $("#BlogNewsComment").val("");
        Endpoint.prototype.GetUserCommentList($("#BlogNewsId").val(), function (response) {
            $("#comments-display-section").html('');
            $('#comments-display-section').show();
            $("#comments-display-section").html(response);
        });
        return true;
    };
    return BlogNews;
}(ZnodeBase));
//# sourceMappingURL=BlogNews.js.map