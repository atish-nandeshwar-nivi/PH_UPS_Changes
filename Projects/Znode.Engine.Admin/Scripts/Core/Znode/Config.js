var Config;
(function (Config) {
    Config.PaymentScriptUrl = $("#hdnPaymentAppUrl").val() + "/script/znodeapijs";
    Config.PaymentScriptUrlForACH = $("#hdnPaymentAppUrl").val() + "/script/znodeapijsforach";
    Config.PaymentApplicationUrl = $("#hdnPaymentAppUrl").val() + "/";
    Config.PaymentTwoCoUrl = $("#hdnAdminUrl").val() + "/orders/twoco?paymentSettingId=";
})(Config || (Config = {}));
//# sourceMappingURL=Config.js.map