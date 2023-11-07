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
var TouchPointConfiguration = /** @class */ (function (_super) {
    __extends(TouchPointConfiguration, _super);
    function TouchPointConfiguration() {
        return _super.call(this) || this;
    }
    TouchPointConfiguration.prototype.Init = function () {
        TouchPointConfiguration.prototype.ShowLogDetails();
    };
    TouchPointConfiguration.prototype.ShowLogDetails = function () {
        $("#TouchPointSchedulerHistory tbody tr td").find(".z-history").each(function () {
            $(this).removeAttr("href");
        });
        $("#grid tbody tr td").find(".z-history").click(function (e) {
            var schedulerName = $(this).attr("data-parameter").split('&')[0].split('=')[1];
            var recordId = $(this).attr("data-parameter").split('&')[1].split('=')[1];
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.ShowTaskSchedularLogDetails(schedulerName, recordId, function (res) {
                $("#divShowLogDetails").show(700);
                $("#divShowLogDetails").html(res);
                ZnodeBase.prototype.HideLoader();
                $("body").css('overflow', 'hidden');
                $("body").append("<div class='modal-backdrop fade in'></div>");
            });
        });
    };
    return TouchPointConfiguration;
}(ZnodeBase));
//# sourceMappingURL=TouchPointConfiguration.js.map