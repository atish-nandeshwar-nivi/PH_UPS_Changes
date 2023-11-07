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
var Dashboard = /** @class */ (function (_super) {
    __extends(Dashboard, _super);
    function Dashboard() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    Dashboard.prototype.GetSelectedPortal = function () {
        var portalIds = $("#ddlPortal").val();
        var durationId = $("#ddlDuration").val();
        if (portalIds == 0) {
            var values = $.map($('#ddlPortal option'), function (e) { return e.value; });
            portalIds = values.join(',');
        }
        return portalIds;
    };
    Dashboard.prototype.DisplayLowInventoryProductReport = function () {
        var url = window.location.protocol + "//" + window.location.host + "/MyReports/GetDashboardReport?reportPath=InventoryReorder&reportName=Inventory Re-order&portalIds=" + Dashboard.prototype.GetSelectedPortal() + "&durationId=" + $("#ddlDuration").val();
        window.open(url, '_blank');
    };
    Dashboard.prototype.GetSelectedDashboardPortal = function (item) {
        if (item != undefined) {
            $("#hdnPortal").val(item.Id);
        }
        Dashboard.prototype.GetSalesDetailsBasedOnSelectedPortalAndAccount($("#hdnPortal").val(), $("#hdnAccount").val());
    };
    Dashboard.prototype.GetSelectedDashboardAccount = function (item) {
        if (item != undefined) {
            $("#hdnAccount").val(item.Id);
        }
        Dashboard.prototype.GetSalesDetailsBasedOnSelectedPortalAndAccount($("#hdnPortal").val(), $("#hdnAccount").val());
    };
    Dashboard.prototype.GetSalesDetailsBasedOnSelectedPortalAndAccount = function (portalId, accountId) {
        Endpoint.prototype.SalesDetailsBasedOnSelectedPortalAndAccount(portalId, accountId, function (response) {
            $("#QuotesView").html(response.quotes);
            $("#OrdersView").html(response.orders);
            $("#ReturnsView").html(response.returns);
            $("#TopAccountView").html(response.topaccounts);
            $("#SalesView").html(response.sales);
        });
        //Get low inventory products on the basis of selected portal.
        Dashboard.prototype.GetDashboardLowInventoryProductCountOnSelectedPortal();
    };
    Dashboard.prototype.GetDashboardLowInventoryProductCountOnSelectedPortal = function () {
        Endpoint.prototype.DashboardLowInventoryProductCountOnSelectedPortal(parseInt($("#ddlPortal").val()), function (response) {
            $("#LowInventoryCount").html(response.html);
        });
    };
    Dashboard.prototype.SetLink = function () {
        var _newUrl = MediaManagerTools.prototype.UpdateQueryString("portalId", $("#ddlPortal").val(), window.location.href);
        window.history.pushState({ path: _newUrl }, '', _newUrl);
    };
    return Dashboard;
}(ZnodeBase));
//# sourceMappingURL=Dashboard.js.map