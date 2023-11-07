class CustomPortal extends ZnodeBase {
    _endPoint: Endpoint;

    constructor() {
        super();
        this._endPoint = new Endpoint();
        CustomPortal.prototype.GetValueOnFormPost();
    }

    Init() {
 }

    GetValueOnFormPost(): any {
        $("#frmStore").on("submit", function () {
            $("#OrderStatusId").val($("#ddlOrderStatus").val());
        });
    }
}