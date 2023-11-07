module Config {
    export const PaymentScriptUrl = $("#hdnPaymentAppUrl").val() + "/script/znodeapijs";
    export const PaymentScriptUrlForACH = $("#hdnPaymentAppUrl").val() + "/script/znodeapijsforach";
    export const PaymentApplicationUrl = $("#hdnPaymentAppUrl").val() + "/";
    /*NIVI CODE*/
    export const APIUrl = $("#hdnZnodeApiDomainName").val();
    export const APIkey = $("#hdnZnodeApiDomainKey").val();
    
}