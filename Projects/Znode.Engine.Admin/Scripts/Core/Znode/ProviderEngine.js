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
var ProviderEngine = /** @class */ (function (_super) {
    __extends(ProviderEngine, _super);
    function ProviderEngine() {
        return _super.call(this) || this;
    }
    ProviderEngine.prototype.Init = function () {
        if (window.location.href.indexOf('PromotionTypeList') > 0) {
            $.cookie('_backURL', '', { path: '/' });
        }
    };
    ProviderEngine.prototype.GetPromotionTypeByClassName = function () {
        var className = $("#ddlPromotionType").val();
        Endpoint.prototype.GetPromotionTypeDetails(className, function (response) {
            if (response != null) {
                $("#Name").val(response.Name);
                $("#ClassName").val(response.ClassName);
                $("#Description").val(response.Description);
                $("#ClassType").val(response.ClassType);
            }
        });
    };
    ProviderEngine.prototype.GetTaxRuleTypeByClassName = function () {
        var className = $("#ddlTaxType").val();
        Endpoint.prototype.GetTaxRuleTypeDetails(className, function (response) {
            if (response != null) {
                $("#Name").val(response.Name);
                $("#ClassName").val(response.ClassName);
                $("#Description").val(response.Description);
            }
        });
    };
    ProviderEngine.prototype.GetShippingTypeByClassName = function () {
        var className = $("#ddlShippingType").val();
        Endpoint.prototype.GetShippingTypeDetails(className, function (response) {
            if (response != null) {
                $("#Name").val(response.Name);
                $("#ClassName").val(response.ClassName);
                $("#Description").val(response.Description);
            }
        });
    };
    ProviderEngine.prototype.DeleteTaxRuleType = function (control) {
        var taxRuletypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        var url = "/ProviderEngine/DeleteTaxRuleType";
        if (taxRuletypeIds.length > 0) {
            Endpoint.prototype.DeleteTaxRuleTypes(taxRuletypeIds, function (res) {
                DynamicGrid.prototype.RefreshGrid(control, res);
            });
        }
    };
    ProviderEngine.prototype.DeleteShippingType = function (control) {
        var shippingTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        var url = "/ProviderEngine/DeleteShippingType";
        if (shippingTypeIds.length > 0) {
            Endpoint.prototype.DeleteShippingTypes(shippingTypeIds, function (res) {
                DynamicGrid.prototype.RefreshGrid(control, res);
            });
        }
    };
    ProviderEngine.prototype.DeletePromotionType = function (control) {
        var promotionTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        var url = "/ProviderEngine/DeletePromotionType";
        if (promotionTypeIds.length > 0) {
            Endpoint.prototype.DeletePromotionTypes(promotionTypeIds, function (res) {
                DynamicGrid.prototype.RefreshGrid(control, res);
            });
        }
    };
    ProviderEngine.prototype.EnableTaxRuleType = function (control) {
        var taxruleTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (taxruleTypeIds.length > 0) {
            Endpoint.prototype.EnableTaxRuleTypes(taxruleTypeIds, true, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/ProviderEngine/TaxRuleTypeList";
            });
        }
    };
    ProviderEngine.prototype.DisableTaxRuleType = function (control) {
        var taxruleTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (taxruleTypeIds.length > 0) {
            Endpoint.prototype.EnableTaxRuleTypes(taxruleTypeIds, false, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/ProviderEngine/TaxRuleTypeList";
            });
        }
    };
    ProviderEngine.prototype.EnableShippingType = function (control) {
        var shippingTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (shippingTypeIds.length > 0) {
            Endpoint.prototype.EnableShippingTypes(shippingTypeIds, true, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/ProviderEngine/ShippingTypeList";
            });
        }
    };
    ProviderEngine.prototype.DisableShippingType = function (control) {
        var shippingTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (shippingTypeIds.length > 0) {
            Endpoint.prototype.EnableShippingTypes(shippingTypeIds, false, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/ProviderEngine/ShippingTypeList";
            });
        }
    };
    ProviderEngine.prototype.EnablePromotionType = function (control) {
        var promotionTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (promotionTypeIds.length > 0) {
            Endpoint.prototype.EnablePromotionTypes(promotionTypeIds, true, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/ProviderEngine/PromotionTypeList";
            });
        }
    };
    ProviderEngine.prototype.DisablePromotionType = function (control) {
        var promotionTypeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (promotionTypeIds.length > 0) {
            Endpoint.prototype.EnablePromotionTypes(promotionTypeIds, false, function (res) {
                window.location.href = window.location.protocol + "//" + window.location.host + "/ProviderEngine/PromotionTypeList";
            });
        }
    };
    return ProviderEngine;
}(ZnodeBase));
//# sourceMappingURL=ProviderEngine.js.map