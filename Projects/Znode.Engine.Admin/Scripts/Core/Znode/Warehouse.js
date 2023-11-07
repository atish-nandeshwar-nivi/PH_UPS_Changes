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
var Warehouse = /** @class */ (function (_super) {
    __extends(Warehouse, _super);
    function Warehouse() {
        return _super.call(this) || this;
    }
    Warehouse.prototype.Init = function () {
        Account.prototype.BindStates();
    };
    Warehouse.prototype.DeleteWarehouse = function (control) {
        var warehouseIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (warehouseIds.length > 0) {
            Endpoint.prototype.DeleteWarehouse(warehouseIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Warehouse.prototype.DeleteMultipleSKUInventory = function (control) {
        var inventoryId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (inventoryId.length > 0) {
            Endpoint.prototype.DeleteMultipleAssociatedSkus(inventoryId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //Restrict multiple click while associating inventory to warehouse.
    Warehouse.prototype.RestrictDoubleClickForInventory = function () {
        $("#UnassociatedInventory td a").click(function (e) {
            $('#associateinventorylist').hide(700);
        });
    };
    //Hide filter if no record found.
    Warehouse.prototype.HideInventoryFilter = function () {
        if ($("#UnassociatedInventory").find("tr").length == 0) {
            $("#UnassociatedInventory").find(".filter-component").hide();
        }
    };
    return Warehouse;
}(ZnodeBase));
//# sourceMappingURL=Warehouse.js.map