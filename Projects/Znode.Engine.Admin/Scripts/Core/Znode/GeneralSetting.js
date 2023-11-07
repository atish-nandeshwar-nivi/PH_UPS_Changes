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
var GeneralSetting = /** @class */ (function (_super) {
    __extends(GeneralSetting, _super);
    function GeneralSetting() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        _this._notification = new ZnodeNotification();
        return _this;
    }
    GeneralSetting.prototype.Init = function () {
    };
    GeneralSetting.prototype.EnablePublishStateMapping = function () {
        var publishStateMappingId = $("#HdnPublishStateMappingId").val();
        if (publishStateMappingId.length > 0) {
            Endpoint.prototype.EnableDisablePublishStateMapping(publishStateMappingId, true, function (res) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status != true ? 'error' : 'success', isFadeOut, fadeOutTime);
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodePublishStateApplicationTypeMapping").find("#refreshGrid"), res);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    GeneralSetting.prototype.DisablePublishStateMapping = function () {
        var publishStateMappingId = $("#HdnPublishStateMappingId").val();
        if (publishStateMappingId.length > 0) {
            Endpoint.prototype.EnableDisablePublishStateMapping(publishStateMappingId, false, function (res) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status != true ? 'error' : 'success', isFadeOut, fadeOutTime);
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodePublishStateApplicationTypeMapping").find("#refreshGrid"), res);
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneRecord"), 'error', isFadeOut, fadeOutTime);
        }
    };
    GeneralSetting.prototype.ToggleEnableDisableAction = function () {
        $('#grid tbody tr').each(function () {
            $(this).find("td").each(function () {
                if ($(this).hasClass('grid-action')) {
                    if ($(this).next().children().hasClass("z-active")) {
                        $(this).children().children("ul").children().find(".z-disable").parent().show();
                        $(this).children().children("ul").children().find(".z-enable").parent().hide();
                    }
                    else if ($(this).next().children().hasClass("z-inactive")) {
                        $(this).children().children("ul").children().find(".z-disable").parent().hide();
                        $(this).children().children("ul").children().find(".z-enable").parent().show();
                    }
                }
            });
            $(this).find("td.IsEnabled").each(function () {
                if ($(this).children("i").hasClass("z-active")) {
                    $(this).next().children().children("ul").children().find(".z-disable").parent().show();
                    $(this).next().children().children("ul").children().find(".z-enable").parent().hide();
                }
                else if ($(this).children("i").hasClass("z-inactive")) {
                    $(this).next().children().children("ul").children().find(".z-disable").parent().hide();
                    $(this).next().children().children("ul").children().find(".z-enable").parent().show();
                }
            });
        });
    };
    GeneralSetting.prototype.EnablePublishStateMappingPopup = function (zEnableAnchor) {
        zEnableAnchor.attr("href", "#");
        $("#HdnPublishStateMappingId").val($(zEnableAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        $("#publishStateMappingEnable").modal('show');
    };
    GeneralSetting.prototype.DisablePublishStateMappingPopup = function (zEnableAnchor) {
        zEnableAnchor.attr("href", "#");
        $("#HdnPublishStateMappingId").val($(zEnableAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        $("#publishStateMappingDisable").modal('show');
    };
    GeneralSetting.prototype.GetPublishHistoryPopup = function (zViewAnchor) {
        zViewAnchor.attr("href", "#");
        var publishState = $(zViewAnchor).attr("data-parameter").split('&')[0].split('=')[1];
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PublishHistory/List?publishState=' + publishState, 'divPublishHistoryListPopup');
    };
    return GeneralSetting;
}(ZnodeBase));
//# sourceMappingURL=GeneralSetting.js.map