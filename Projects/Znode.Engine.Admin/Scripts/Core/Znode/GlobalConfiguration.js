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
var GlobalConfiguration = /** @class */ (function (_super) {
    __extends(GlobalConfiguration, _super);
    function GlobalConfiguration() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        _this._notification = new ZnodeNotification();
        return _this;
    }
    GlobalConfiguration.prototype.DefaultSubmit = function (SelectedIdArr, Controller, Action, Callback) {
        var action = "SetDefault";
        var ids = [];
        ids = MediaManagerTools.prototype.unique();
        if (ids.length == 0)
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        else if (ids.length > 1)
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAnyOneToSetAsDefault"), 'error', isFadeOut, fadeOutTime);
        else {
            this.submit(ids, action, Controller, Action, Callback);
        }
    };
    GlobalConfiguration.prototype.ActiveSubmit = function (SelectedIdArr, Controller, Action, Callback) {
        var action = "SetActive";
        var ids = [];
        ids = MediaManagerTools.prototype.unique();
        if (ids.length == 0)
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        else {
            this.submit(ids, action, Controller, Action, Callback);
        }
    };
    GlobalConfiguration.prototype.DeActivateSubmit = function (SelectedIdArr, Controller, Action, Callback) {
        var action = "SetDeActive";
        var ids = [];
        ids = MediaManagerTools.prototype.unique();
        if (ids.length == 0)
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        else {
            //ajax call.
            this.submit(ids, action, Controller, Action, Callback);
        }
    };
    GlobalConfiguration.prototype.submit = function (SelectedIdArr, action, Controller, Action, Callback) {
        this._Model = { "SelectedIds": SelectedIdArr.toString(), "Action": action };
        var url = "/" + Controller + "/" + Action;
        this.GetGlobalSetting(url, this._Model, Controller, Callback);
    };
    GlobalConfiguration.prototype.GetGlobalSetting = function (url, model, controller, callback) {
        Endpoint.prototype.SetGlobalConfigSetting(url, model, function (data) {
            if (data != "") {
                window.location.href = "/" + controller + "/" + callback;
                //window.location.assign("");               
            }
        });
    };
    GlobalConfiguration.prototype.RefreshCacheData = function (control) {
        var applicationType = $(control).attr("name").trim();
        var cacheId = $(control).attr("id").split("-")[1];
        GlobalConfiguration.prototype.RefreshCache(cacheId, "");
    };
    GlobalConfiguration.prototype.RefreshCache = function (cacheId, domainIds) {
        ZnodeBase.prototype.ShowLoader();
        $.ajax({
            url: "/GeneralSetting/RefreshCache?id=" + cacheId + "&domainIds=" + domainIds,
            type: 'POST',
            success: function (response) {
                ZnodeBase.prototype.HideLoader();
                if ($("#hdnApplicationType").val() == Constant.Cloudflare) {
                    $('#grid tr').each(function () {
                        if ($(this).find("input[type=checkbox]").attr('id') != "check-all") {
                            $(this).closest('tr').append("<td id='status_" + $(this).find("input[type=checkbox]").attr('id').split('_')[1] + "'></td>");
                        }
                    });
                    $(response.Data.CloudflareErrorList).each(function () {
                        if (this.Status)
                            $("#status_" + this.DomainId).html("Refreshed");
                        else
                            $("#status_" + this.DomainId).html("Not Refreshed");
                    });
                }
                else {
                    if (!response.HasError) {
                        $("#startDate_" + cacheId).text(response.Data.StartDate);
                        $("#hdnstartDate_" + cacheId).val(response.Data.StartDate);
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Message, "success", isFadeOut, fadeOutTime);
                    }
                    else {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Message, "error", isFadeOut, fadeOutTime);
                    }
                }
            }
        });
    };
    GlobalConfiguration.prototype.UpdateFullPageCacheParameters = function () {
        var domainIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (domainIds == "") {
            $("#urlId").show();
        }
        else {
            //var cacheId: string = $("#div-FullPageCache").find('input:button').attr("id").split("-")[1];
            var cacheId = $("#hdnApplicationCacheId").val();
            GlobalConfiguration.prototype.RefreshCache(cacheId, domainIds);
            if ($("#hdnApplicationType").val() != Constant.Cloudflare)
                ZnodeBase.prototype.CancelUpload("domainList");
        }
    };
    GlobalConfiguration.prototype.GetDomains = function (control) {
        $("#hdnApplicationCacheId").val($(control).attr("id").split("-")[1]);
        ZnodeBase.prototype.BrowseAsidePoupPanel('/GeneralSetting/GetWebstoreDomains', 'domainList');
    };
    GlobalConfiguration.prototype.GetCloudflareDomains = function (control) {
        $("#hdnApplicationCacheId").val($(control).attr("id").split("-")[1]);
        $("#hdnApplicationType").val(Constant.Cloudflare);
        ZnodeBase.prototype.BrowseAsidePoupPanel('/GeneralSetting/GetWebstoreDomainsForCloudflare', 'domainList');
    };
    return GlobalConfiguration;
}(ZnodeBase));
//# sourceMappingURL=GlobalConfiguration.js.map