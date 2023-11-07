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
var Template = /** @class */ (function (_super) {
    __extends(Template, _super);
    function Template() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    Template.prototype.Init = function () {
        var filename = $("#txtUpload").attr("title");
        var uploadedFileName = $("#FileName").val() == "" ? $("#FilePath_FileName").val() : $("#FileName").val();
        filename = filename == "" ? uploadedFileName : filename;
        $('#fileName').text(filename);
    };
    Template.prototype.DeleteTemplate = function (control) {
        var templateIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        var fileName = DynamicGrid.prototype.GetMultipleValuesOfGridColumn('File Name');
        if (templateIds.length > 0) {
            Endpoint.prototype.DeleteTemplate(templateIds, fileName, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Template.prototype.CheckTemplateName = function () {
        $("#Name").on("blur", function () {
            return Template.prototype.ValidateTemplateName(true);
        });
    };
    Template.prototype.ValidateTemplateName = function (isOnBlur, backURL) {
        if (isOnBlur === void 0) { isOnBlur = false; }
        if (backURL === void 0) { backURL = ""; }
        var templateName = $("#Name").val();
        var status = false;
        if ($("#frmTemplate").valid()) {
            if ($("#CMSTemplateId").val() > 0) {
                if (Template.prototype.ValidateUploadedTemplateFile() && !isOnBlur) {
                    if (typeof (backURL) != "undefined")
                        $.cookie("_backURL", backURL, { path: '/' });
                    $("#frmTemplate").submit();
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        Endpoint.prototype.CheckTemplateName(templateName, function (res) {
            if (res == false) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorTemplateName"), 'error', isFadeOut, fadeOutTime);
                Template.prototype.ValidateUploadedTemplateFile();
                return false;
            }
            else {
                if (!isOnBlur) {
                    status = Template.prototype.ValidateUploadedTemplateFile() ? true : false;
                    if (!isOnBlur && status) {
                        if (typeof (backURL) != "undefined")
                            $.cookie("_backURL", backURL, { path: '/' });
                        $("#frmTemplate").submit();
                    }
                }
            }
        });
    };
    Template.prototype.ValidateUploadedTemplateFile = function () {
        if (window.location.pathname.split("/")[2] == "Copy") {
            return true;
        }
        var ext = $('#txtUpload').val().split('.').pop().toLowerCase();
        if (ext != "") {
            if ($.inArray(ext, ['cshtml',]) == -1) {
                $("#errorTemplateFilePath").html(ZnodeBase.prototype.getResourceByKeyName("ErrorCSHTMLFile"));
                return false;
            }
            return true;
        }
        var fileName = $("#fileName").text();
        if (fileName == "" || fileName == 'undefined') {
            $("#errorTemplateFilePath").html(ZnodeBase.prototype.getResourceByKeyName("FileRequiredError"));
            return false;
        }
        else {
            $("#errorTemplateFilePath").text('');
            return true;
        }
    };
    return Template;
}(ZnodeBase));
//# sourceMappingURL=Template.js.map