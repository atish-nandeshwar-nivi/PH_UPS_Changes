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
var ZnodeProgressNotifier = /** @class */ (function (_super) {
    __extends(ZnodeProgressNotifier, _super);
    function ZnodeProgressNotifier() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this._pollingInterval = 10000; //In millisecond.
        _this._working = false;
        return _this;
    }
    ZnodeProgressNotifier.prototype.InitiateProgressBar = function (completionCallback) {
        ZnodeProgressNotifier.prototype.GetHeader(function (response) {
            ZnodeProgressNotifier.prototype._headerResponse = response;
            ZnodeProgressNotifier.prototype._completionCallback = completionCallback;
            ZnodeProgressNotifier.prototype._pollingInterval = 10000;
            if (!ZnodeProgressNotifier.prototype._working) {
                ZnodeProgressNotifier.prototype._working = true;
                ZnodeProgressNotifier.prototype.PollAPI().then(function (result) {
                    ZnodeProgressNotifier.prototype.BindProgressBar(result);
                }, function (err) {
                    //Do nothing.
                });
            }
        });
    };
    ZnodeProgressNotifier.prototype.PollAPI = function () {
        var response = ZnodeProgressNotifier.prototype._headerResponse;
        if (response.Authorization.match("^Authorization: ")) {
            response.Authorization = response.Authorization.replace('Authorization: ', '');
        }
        return $.ajax({
            type: "GET",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization", response.Authorization);
                xhr.setRequestHeader("Znode-UserId", response.ZnodeAccountId);
                xhr.setRequestHeader("Znode-DomainName", response.DomainName);
                xhr.setRequestHeader("Token", response.Token);
            },
            global: false,
            url: response.ApiUrl + "/apiprogressnotification/List",
            contentType: false,
            dataType: "json",
            processData: false,
            cache: false
        }).then(function (data) {
            if (data.ProgressNotifications == null || data.ProgressNotifications.length === 0) {
                if (ZnodeProgressNotifier.prototype._completionCallback != null)
                    ZnodeProgressNotifier.prototype._completionCallback();
                ZnodeProgressNotifier.prototype._working = false;
                ZnodeProgressNotifier.prototype.UnbindProgressBar();
                return [];
            }
            else {
                ZnodeProgressNotifier.prototype._lastNotifications = data.ProgressNotifications;
                ZnodeProgressNotifier.prototype.BindProgressBar(data.ProgressNotifications);
                return ZnodeProgressNotifier.prototype.DelayedPromise().then(ZnodeProgressNotifier.prototype.PollAPI);
            }
        });
    };
    ZnodeProgressNotifier.prototype.DelayedPromise = function () {
        return $.Deferred(function (def) {
            setTimeout(def.resolve, ZnodeProgressNotifier.prototype._pollingInterval);
        }).promise();
    };
    ZnodeProgressNotifier.prototype.GetHeader = function (callbackFunction) {
        CommonHelper.prototype.GetAjaxHeaders(function (response) {
            callbackFunction(response);
        });
    };
    ZnodeProgressNotifier.prototype.BindProgressBar = function (result) {
        $('#publishStatusTable').find('tbody').empty();
        if (result && result.length > 0) {
            //let template = $("#publish_JobTemplate").find('tr').html;
            result.forEach(function (element) {
                var notification = element;
                var status;
                if (notification.IsCompleted == true)
                    status = 'Completed';
                else if (notification.IsFailed == true)
                    status = 'Failed';
                else
                    status = 'In Progress';
                var itemHtml = '<tr class="working" data-jobid="' + notification.JobId + '">'
                    + '<td width="35%" style="font-size:0.8em;"><span class="filename">Publishing ' + notification.JobName + '.</span><span><br/>Started by: ' + notification.StartedByFriendlyName + '</span></td>'
                    + '<td width="65%">'
                    + '<div class="progress publish-progressbar">'
                    + '<div class="progress-bar ' + (notification.IsCompleted === false && notification.IsFailed === false ? 'progress-bar-info progress-bar-striped active' : (notification.IsCompleted === true && notification.IsFailed === false ? 'progress-bar-success' : 'progress-bar-danger')) + '" role="progressbar" aria-valuenow="' + notification.ProgressMark + '" aria-valuemin="0" aria-valuemax="100" style="width:' + notification.ProgressMark + '%">'
                    + '<span class="">' + (notification.IsFailed === true ? 'Publish failed.' : (notification.ProgressMark + ' % Complete')) + '</span>'
                    + '</div></div>'
                    + '</td>'
                    + '</tr>'
                    + (notification.IsFailed === true ?
                        (notification.ExceptionMessage ?
                            '<tr style="border-top:0px;"><td colspan="2"><span class="text-danger">' + notification.ExceptionMessage + '</span></td></tr>' :
                            '<tr style="border-top:0px;"><span class="text-danger">Publish failed.</span></td>') : '');
                $('#publishStatusTable').find('tbody').append(itemHtml);
            });
            $('#publishProgressBar').show();
        }
    };
    ZnodeProgressNotifier.prototype.UnbindProgressBar = function () {
        $('#publishProgressBar').hide();
    };
    ZnodeProgressNotifier.prototype.ToggleProgressBar = function (selector) {
        var container = $('#' + selector);
        if (container.attr('x-data-active') === 'true') {
            container.removeClass('active');
            container.attr('x-data-active', 'false');
        }
        else {
            container.addClass('active');
            container.attr('x-data-active', 'true');
        }
    };
    return ZnodeProgressNotifier;
}(ZnodeBase));
//# sourceMappingURL=ZnodeProgressNotifier.js.map