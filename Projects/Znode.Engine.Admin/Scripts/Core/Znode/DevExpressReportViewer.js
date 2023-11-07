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
var _reportviewid = 0;
var DevExpressReport = /** @class */ (function (_super) {
    __extends(DevExpressReport, _super);
    function DevExpressReport() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    DevExpressReport.prototype.Init = function () {
        $("#closebuttonSaveLayoutPopup").on("click", function () {
            $('#SaveReportLayoutPopup').hide();
        });
        $("#closebuttonLoadLayoutPopup").on("click", function () {
            $('#LoadReportLayoutPopup').hide();
        });
        $("#dvSavebutton").on("click", function () {
            DevExpressReport.prototype.fnSaveReportcomponents();
        });
        $("#Reset").on("click", function () {
            $("#txtReportLayoutName").val("");
        });
        DevExpressReport.prototype.InisilizeCss();
    };
    DevExpressReport.prototype.InisilizeCss = function () {
        $(document).element.find('.dx-overlay-content').css('height', 'auto');
        $(document).element.find('.dx-overlay-content').css('top', '10px');
    };
    DevExpressReport.prototype.ViewSavedHistories = function () {
        DevExpressReport.prototype.fnLoadSavedReportcomponents();
        $('#LoadReportLayoutPopup').show();
    };
    DevExpressReport.prototype.ShowSaveLayoutPopup = function () {
        $('#SaveReportLayoutPopup').show();
    };
    DevExpressReport.prototype.GetUrlParameter = function (name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    };
    ;
    DevExpressReport.prototype.AddOrUpdateUrlParam = function (uri, paramKey, paramVal) {
        var re = new RegExp("([?&])" + paramKey + "=[^&#]*", "i");
        if (re.test(uri)) {
            uri = uri.replace(re, '$1' + paramKey + "=" + paramVal);
        }
        else {
            var separator = /\?/.test(uri) ? "&" : "?";
            uri = uri + separator + paramKey + "=" + paramVal;
        }
        return uri;
    };
    DevExpressReport.prototype.fnSaveReportcomponents = function () {
        var reportName = $("#txtReportLayoutName").val();
        if (reportName == "") {
            $('#statusmessage').html(ZnodeBase.prototype.getResourceByKeyName("SliderNameRequired"));
            $('#AlertPopup').show();
            return;
        }
        var reportCode = DevExpressReport.prototype.GetUrlParameter("reportCode");
        Endpoint.prototype.SaveReportLayout(reportName, reportCode, function (res) {
            $('#statusmessage').html(res.message);
            $('#AlertPopup').show();
            $("#txtReportLayoutName").val("");
            $('#SaveReportLayoutPopup').hide();
        });
    };
    DevExpressReport.prototype.fnDeleteSavedReportLayoutConfirmation = function (reportviewid) {
        _reportviewid = reportviewid;
        $('#ConfirmPopup').show();
    };
    DevExpressReport.prototype.fnDeleteSavedReportLayout = function () {
        Endpoint.prototype.fnDeleteSavedReportLayout(_reportviewid, function (res) {
            DevExpressReport.prototype.fnLoadSavedReportcomponents();
        });
    };
    DevExpressReport.prototype.fnLoadSavedReportcomponents = function () {
        var reportName = $("#txtReportLayoutName").val();
        var reportCode = DevExpressReport.prototype.GetUrlParameter("reportCode");
        Endpoint.prototype.LoadSavedReportLayout(reportName, reportCode, function (res) {
            var html = "";
            if (res.data.length > 0) {
                for (var i = 0; i < res.data.length; i++) {
                    html += "<div class='report-popup-container-div'><label class='report-popup-container-label'><input type='radio' name ='reportsname' value='" + res.data[i].ReportName + "'/><span class='lbl padding-8'>" + res.data[i].ReportName + "</span></label><label class='report-popup-file-remove-label' onclick='DevExpressReport.prototype.fnDeleteSavedReportLayoutConfirmation(" + res.data[i].ReportViewId + ")'>x</label></div>";
                }
            }
            else {
                html += ZnodeBase.prototype.getResourceByKeyName("NoResult");
            }
            $("#dvFilesHistory").html(html);
        });
    };
    DevExpressReport.prototype.fnLoadReportcomponents = function () {
        if ($('input[name=reportsname]:checked').val() == undefined) {
            $('#statusmessage').html(ZnodeBase.prototype.getResourceByKeyName("FileNameSelectionValidation"));
            $('#AlertPopup').show();
            return;
        }
        window.location.href = DevExpressReport.prototype.AddOrUpdateUrlParam(window.location.href, "reportName", $('input[name=reportsname]:checked').val());
    };
    DevExpressReport.prototype.CustomizeMenuActions = function (s, e, field) {
        var actions = e.Actions;
        var hightlightEditingFields = e.GetById(field);
        if (hightlightEditingFields)
            hightlightEditingFields.visible = false;
    };
    DevExpressReport.prototype.OnInit = function (s, e) {
        var reportPreview = s.GetPreviewModel().reportPreview;
        //set the properties of web document viewer.
        reportPreview.showMultipagePreview(true);
        reportPreview.zoom(1);
        //Report parameter panel properties configuration.
        var previewModel = s.GetPreviewModel();
        previewModel.tabPanel.width(350);
        previewModel.tabPanel.collapsed(false);
        previewModel.tabPanel.tabs[0].active(true);
        var currentExportOptions = reportPreview.exportOptionsModel;
        var optionsUpdating = false;
        var fixExportOptions = function (options) {
            try {
                optionsUpdating = true;
                if (!options) {
                    currentExportOptions(null);
                }
                else {
                    delete options["docx"];
                    delete options["mht"];
                    delete options["html"];
                    delete options["textExportOptions"];
                    delete options["rtf"];
                    delete options["image"];
                    currentExportOptions(options);
                }
            }
            finally {
                optionsUpdating = false;
            }
        };
        currentExportOptions.subscribe(function (newValue) {
            !optionsUpdating && fixExportOptions(newValue);
        });
        fixExportOptions(currentExportOptions());
    };
    DevExpressReport.prototype.EnableDisableParameterByOther = function (affectedParamName, affectedByParamName, s) {
        var parametersModel = s.GetPreviewModel().parametersModel;
        if (parametersModel[affectedByParamName]() == true) {
            $("input[name=" + affectedParamName + "]").next().children(".dx-texteditor-input").attr("disabled", "disabled");
        }
        else {
            $("input[name=" + affectedParamName + "]").next().children(".dx-texteditor-input").removeAttr("disabled");
        }
    };
    DevExpressReport.prototype.DisableFieldIfChecked = function (s, e) {
        setTimeout(function () {
            s.parametersInfo.parameters.forEach(function (param, count) {
                if (param.Name == 'ShowAllProducts') {
                    DevExpressReport.prototype.EnableDisableParameterByOther('paramTopProducts', 'ShowAllProducts', s);
                }
                if (param.Name == 'ShowAllCustomers') {
                    DevExpressReport.prototype.EnableDisableParameterByOther('paramTopCustomers', 'ShowAllCustomers', s);
                }
            });
        }, 1000);
    };
    return DevExpressReport;
}(ZnodeBase));
//# sourceMappingURL=DevExpressReportViewer.js.map