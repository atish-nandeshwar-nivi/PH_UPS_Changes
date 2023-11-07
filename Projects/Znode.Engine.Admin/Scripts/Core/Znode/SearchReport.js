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
var SearchReport = /** @class */ (function (_super) {
    __extends(SearchReport, _super);
    function SearchReport() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    SearchReport.prototype.Init = function () {
    };
    SearchReport.prototype.IntializeDatePicker = function () {
        ZnodeDateRangePicker.prototype.Init(SearchReport.prototype.DateTimePickerRangeForSearchReport());
    };
    //This method is used to select store from fast select and show it on textbox
    SearchReport.prototype.OnSelectStoreTopKeywordList = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            Endpoint.prototype.GetTopKeywordsReport(portalId, portalName, function (response) {
                $("#divTopKeywordList").html("");
                $("#divTopKeywordList").html(response);
            });
        }
    };
    SearchReport.prototype.OnSelectStoreNoResultFoundKeywordList = function (item) {
        if (item != undefined) {
            var portalName = item.text;
            var portalId = item.Id;
            Endpoint.prototype.GetNoResultsFoundReport(portalId, portalName, function (response) {
                $("#divNoResultKeywordList").html("");
                $("#divNoResultKeywordList").html(response);
                ZnodeDateRangePicker.prototype.Init(SearchReport.prototype.DateTimePickerRangeForSearchReport());
            });
        }
    };
    SearchReport.prototype.DateTimePickerRangeForSearchReport = function () {
        var ranges = {
            'Last Hour': [],
            'Last Day': [],
            'Last 7 Days': [],
            'Last 30 Days': [],
        };
        return ranges;
    };
    return SearchReport;
}(ZnodeBase));
//# sourceMappingURL=SearchReport.js.map