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
var SessionTimeoutAlert = /** @class */ (function (_super) {
    __extends(SessionTimeoutAlert, _super);
    function SessionTimeoutAlert() {
        var _this = _super.call(this) || this;
        SessionTimeoutAlert.prototype._idleTime = 0;
        return _this;
    }
    SessionTimeoutAlert.prototype.DisplayAlertMessage = function () {
        setInterval(SessionTimeoutAlert.prototype.TimeIncrement, 60000); // 60000 = 1 minute
        //Zero the idle timer on mouse movement.
        $('body').mousemove(function (e) {
            SessionTimeoutAlert.prototype._idleTime = 0;
        });
        $('body').keypress(function (e) {
            SessionTimeoutAlert.prototype._idleTime = 0;
        });
        $('body').click(function () {
            SessionTimeoutAlert.prototype._idleTime = 0;
        });
    };
    SessionTimeoutAlert.prototype.TimeIncrement = function () {
        SessionTimeoutAlert.prototype._idleTime = SessionTimeoutAlert.prototype._idleTime + 1;
        var sessionTimeoutWarning = $("#SessionWarningTime").val();
        if (SessionTimeoutAlert.prototype._idleTime > sessionTimeoutWarning) {
            //alert("Your session will expire in another 2 mins! Please Save the data before the session expires");
        }
    };
    return SessionTimeoutAlert;
}(ZnodeBase));
//# sourceMappingURL=SessionTimeoutAlert.js.map