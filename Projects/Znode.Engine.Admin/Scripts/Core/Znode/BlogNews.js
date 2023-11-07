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
var selectedTab;
var BlogNews = /** @class */ (function (_super) {
    __extends(BlogNews, _super);
    function BlogNews() {
        return _super.call(this) || this;
    }
    BlogNews.prototype.Init = function () {
        if (parseInt($("#BlogNewsId").val(), 10) <= 0) {
            $("#ddlCulture").prop("disabled", true);
            $("#ddlCulture").addClass("disabled");
        }
        BlogNews.prototype.EnableSelectedTab();
    };
    BlogNews.prototype.GetPortalList = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/BlogNews/GetPortalList', 'divBlogNewsStoreList');
    };
    //To Do: To bind portal information
    BlogNews.prototype.OnSelectPortalResult = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            $('#StoreName').val(portalName);
            Store.prototype.OnSelectStoreAutocompleteDataBind(item);
        }
    };
    //This method is used to select store from list and show it on textbox.
    BlogNews.prototype.GetPortalDetail = function () {
        $("#grid").find("tr").on("click", function () {
            var portalName = $(this).find("td[class='storecolumn']").text();
            var portalId = $(this).find("td")[0].innerHTML;
            $('#txtPortalName').val(portalName);
            $('#StoreName').val(portalName);
            $('#hdnPortalId').val(portalId);
            $('#PortalId').val(portalId);
            $("#errorRequiredStore").text("").removeClass("field-validation-error").hide();
            $("#txtPortalName").removeClass('input-validation-error');
            $('#divBlogNewsStoreList').hide(700);
            ZnodeBase.prototype.RemovePopupOverlay();
        });
    };
    BlogNews.prototype.GetContentPageList = function (portalId, localeId) {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/BlogNews/GetContentPageList?portalId=' + portalId + "&localeId=" + localeId + '', 'divBlogNewsContentPageList');
    };
    //This method is used to select content page from list and show it on textbox.
    BlogNews.prototype.GetContentPageDetail = function () {
        $("#grid").find("tr").on("click", function () {
            var pageName = $(this).find("td[class='pagenamecolumn']").text();
            var cmsContentPagesId = $(this).find("td")[0].innerHTML;
            $('#txtPageName').val(pageName);
            $('#hdnCMSContentPagesId').val(cmsContentPagesId);
            $('#CMSContentPagesId').val(cmsContentPagesId);
            $('#divBlogNewsContentPageList').hide(700);
            ZnodeBase.prototype.RemovePopupOverlay();
            $('#divBlogNewsContentPageList').html("");
        });
    };
    //Validations for blog/news.
    BlogNews.prototype.Validate = function () {
        //Checks validation for store.
        if ($("#txtPortalName").is(':visible')) {
            if ($("#txtPortalName").val() == "") {
                $("#errorRequiredStore").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectPortal")).addClass("field-validation-error").show();
                $("#txtPortalName").parent("div").addClass('input-validation-error');
                return false;
            }
        }
        return true;
    };
    //Delete blog(s)/news by blog/news id.
    BlogNews.prototype.DeleteBlogNews = function (control) {
        var blogNewsId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (blogNewsId.length > 0) {
            Endpoint.prototype.DeleteBlogNews(blogNewsId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Show selected tab contents.
    BlogNews.prototype.EnableTab = function (id) {
        selectedTab = id;
        if (id == "div-ContentPage") {
            $('#' + id).show();
            $('#div-loginForm').hide();
            $("#BlogNewsTab").parent("li").removeClass("tab-selected");
            $("#ContentPageTab").parent("li").addClass("tab-selected");
        }
        else {
            $('#div-ContentPage').hide();
            $('#div-loginForm').show();
            $("#BlogNewsTab").parent("li").addClass("tab-selected");
            $("#ContentPageTab").parent("li").removeClass("tab-selected");
        }
        $("#SelectedTab").val(selectedTab);
    };
    //Set cookies on locale change.
    BlogNews.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_blogNewsCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime });
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        if (selectedTab != undefined)
            window.location.replace(orignalUrl + "?blogNewsId=" + $("#BlogNewsId").val() + "&selectedtab=" + selectedTab);
        else {
            if (url.indexOf('blogNewsId') > -1)
                window.location.replace(orignalUrl + "?blogNewsId=" + $("#BlogNewsId").val());
            else
                window.location.reload();
        }
    };
    //Clears content page details.
    BlogNews.prototype.ClearContentPageName = function () {
        $('#txtPageName').val(undefined);
        $('#hdnCMSContentPagesId').val(undefined);
        $('#CMSContentPagesId').val(undefined);
        return false;
    };
    //Delete blog/news comment by blog/news id.
    BlogNews.prototype.DeleteBlogNewsComment = function (control) {
        var blogNewsCommentId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (blogNewsCommentId.length > 0) {
            Endpoint.prototype.DeleteBlogNewsComment(blogNewsCommentId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Activate/Deactivate blog(s)/news
    BlogNews.prototype.ActivateDeactivateBlogNews = function (isActive) {
        var activity = "IsActive";
        var blogNewsIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (blogNewsIds.length > 0) {
            Endpoint.prototype.ActivateDeactivateBlogNews(blogNewsIds, isActive, activity, function (response) {
                $("#ZnodeBlogNewsList #refreshGrid").click();
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            $('#NoCheckboxSelected').modal('show');
        }
    };
    //Allow/Deny blog(s)/news guest comments.
    BlogNews.prototype.ActiveDeactiveGuestCommentsBlogNews = function (isAllowGuestComment) {
        var activity = "IsAllowGuestComment";
        var blogNewsIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (blogNewsIds.length > 0) {
            Endpoint.prototype.ActivateDeactivateBlogNews(blogNewsIds, isAllowGuestComment, activity, function (response) {
                $("#ZnodeBlogNewsList #refreshGrid").click();
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            $('#NoCheckboxSelected').modal('show');
        }
    };
    //Approve/Disapprove blog/news comment(s).
    BlogNews.prototype.ApproveDisapproveBlogNewsComment = function (isApproved) {
        var action = "IsAllowGuestComments";
        var blogNewsCommentIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (blogNewsCommentIds.length > 0) {
            Endpoint.prototype.ApproveDisapproveBlogNewsComment(blogNewsCommentIds, isApproved, function (response) {
                $("#ZnodeBlogNewsCommentList #refreshGrid").click();
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
        }
        else {
            $('#NoCheckboxSelected').modal('show');
        }
    };
    //Method to show selected tab data.
    BlogNews.prototype.EnableSelectedTab = function () {
        selectedTab = $("#SelectedTab").val();
        BlogNews.prototype.EnableTab(selectedTab);
    };
    //Method to Get Parameter Values
    BlogNews.prototype.GetParameterValues = function (param) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var urlparam = url[i].split('=');
            if (urlparam[0] == param) {
                return urlparam[1];
            }
        }
    };
    BlogNews.prototype.PublishBlogNews = function () {
        ZnodeBase.prototype.ShowLoader();
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        Endpoint.prototype.PublishBlogNewsPage($("#BlogNewsId").val(), publishStateFormData, 0, function (res) {
            DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeBlogNewsList").find("#refreshGrid"), res);
        });
    };
    BlogNews.prototype.PublishBlogNewsPopup = function (control) {
        if (control != undefined || control != null) {
            control.attr("href", "#");
            $("#BlogNewsId").val($(control).attr("data-parameter").split('=')[1]);
        }
        else {
            $("#BlogNewsId").val($("#BlogNewsId").val());
        }
        $("#PublishBlogNewsPagePopdiv").modal('show');
    };
    BlogNews.prototype.UpdateAndPublishBlogNewsPage = function (control, formId, backURL) {
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        $("#" + formId + " [name=TargetPublishState]").val(publishStateFormData);
        $("#" + formId).attr("action", "UpdateAndPublishBlogNews");
        $("#" + formId).addClass("dirtyignore");
        SaveCancel.prototype.SubmitForm(formId, null, undefined);
        ZnodeBase.prototype.ShowLoader();
        $("#" + formId).removeClass("dirtyignore");
    };
    return BlogNews;
}(ZnodeBase));
//# sourceMappingURL=BlogNews.js.map