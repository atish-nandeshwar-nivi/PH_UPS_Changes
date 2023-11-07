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
var LogMessage = /** @class */ (function (_super) {
    __extends(LogMessage, _super);
    function LogMessage() {
        var _this = _super.call(this) || this;
        _this._callBackCount = 0;
        return _this;
    }
    LogMessage.prototype.Init = function () {
        ZnodeDateRangePicker.prototype.Init(LogMessage.prototype.DateTimePickerRange());
    };
    LogMessage.prototype.DateTimePickerRange = function () {
        var ranges = {
            'All Logs': [],
            'Last Hour': [],
            'Last Day': [],
            'Last 7 Days': [],
            'Last 30 Days': [],
        };
        return ranges;
    };
    LogMessage.prototype.ConfigureLogs = function () {
        $("#frmConfigureLogs").attr('action', 'ConfigureLogs');
        $("#frmConfigureLogs").submit();
    };
    LogMessage.prototype.PurgeLogs = function () {
        var logCategoryIds = $("#LogCategoryIdToBeDeleted").val();
        ZnodeBase.prototype.ShowLoader();
        $.ajax({
            url: "/LogMessage/PurgeLogs?logCategoryIds=" + logCategoryIds,
            type: 'POST',
            success: function (response) {
                ZnodeBase.prototype.HideLoader();
                if (response.status)
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "success", isFadeOut, fadeOutTime);
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, "error", isFadeOut, fadeOutTime);
            }
        });
    };
    LogMessage.prototype.DeleteLogsPopup = function () {
        $("#LogsDeletePopup").modal('show');
    };
    LogMessage.prototype.PurgeLogsPopup = function (zPublishAnchor) {
        if (zPublishAnchor != null) {
            zPublishAnchor.attr("href", "#");
            $("#LogCategoryIdToBeDeleted").val($(zPublishAnchor).attr('id'));
        }
        $("#LogsDeletePopup").modal('show');
    };
    LogMessage.prototype.SaveLoggingLevel = function () {
        $("#frmLoggingLevel").attr('action', 'LoggingLevelsList');
        $("#frmLoggingLevel").submit();
    };
    LogMessage.prototype.SelectAllLog = function () {
        if (!($("#IsLoggingLevelsEnabledAll").prop('checked'))) {
            $("#IsLoggingLevelsEnabledAll").prop('checked', false);
            $("#IsLoggingLevelsEnabledInfo").prop('checked', false);
            $("#IsLoggingLevelsEnabledWarning").prop('checked', false);
            $("#IsLoggingLevelsEnabledDebug").prop('checked', false);
            $("#IsLoggingLevelsEnabledError").prop('checked', false);
            $("#IsLoggingLevelsEnabledAll").prop('value', false);
            $("#IsLoggingLevelsEnabledInfo").prop('value', false);
            $("#IsLoggingLevelsEnabledWarning").prop('value', false);
            $("#IsLoggingLevelsEnabledDebug").prop('value', false);
            $("#IsLoggingLevelsEnabledError").prop('value', false);
        }
        else {
            $("#IsLoggingLevelsEnabledAll").prop('checked', true);
            $("#IsLoggingLevelsEnabledInfo").prop('checked', true);
            $("#IsLoggingLevelsEnabledWarning").prop('checked', true);
            $("#IsLoggingLevelsEnabledDebug").prop('checked', true);
            $("#IsLoggingLevelsEnabledError").prop('checked', true);
            $("#IsLoggingLevelsEnabledAll").prop('value', true);
            $("#IsLoggingLevelsEnabledInfo").prop('value', true);
            $("#IsLoggingLevelsEnabledWarning").prop('value', true);
            $("#IsLoggingLevelsEnabledDebug").prop('value', true);
            $("#IsLoggingLevelsEnabledError").prop('value', true);
        }
    };
    LogMessage.prototype.CheckUncheck = function (control) {
        var id = "";
        if ($(control).prop('checked')) {
            id = $(control).attr("id");
            $("#" + id).prop('checked', true);
            $("#" + id).prop('value', true);
        }
        else {
            id = $(control).attr("id");
            $("#" + id).prop('checked', false);
            $("#" + id).prop('value', false);
        }
        var searchIDs = $("#loggingLevelDiv input:checkbox:not(:checked)").map(function () {
            return $(this).val();
        }).get();
        if (searchIDs.indexOf('false') > -1) {
            $("#IsLoggingLevelsEnabledAll").prop('checked', false);
            $("#IsLoggingLevelsEnabledAll").prop('value', false);
        }
        else {
            $("#IsLoggingLevelsEnabledAll").prop('checked', true);
            $("#IsLoggingLevelsEnabledAll").prop('value', true);
        }
    };
    return LogMessage;
}(ZnodeBase));
//# sourceMappingURL=LogMessage.js.map