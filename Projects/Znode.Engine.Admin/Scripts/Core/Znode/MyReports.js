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
var MyReports = /** @class */ (function (_super) {
    __extends(MyReports, _super);
    function MyReports() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    MyReports.prototype.Init = function () {
        $(document).on("click", "#btnSaveRowData", function (e) {
            $(this).closest('tr').find('.ddlAttributes').prop('disabled', true);
            $(this).closest('tr').find('.ddlOperators').prop('disabled', true);
            $(this).closest('tr').find('.txtValue').prop('disabled', true);
            $(this).closest('tr').focus();
            $(this).hide();
        });
        $(document).on("click", "#btnDeleteRowData", function (e) {
            $(this).closest('tr').remove();
            var rowCount = $('#tblReportFilters tbody tr').length;
            if (rowCount == 0)
                $('#trTblReportFilters').hide();
            return false;
        });
        $("#divTargetColumnList").ready(function () {
            MyReports.prototype.ulTargetColumnList();
        });
        $("#divColumnList").ready(function () {
            MyReports.prototype.ulColumnList();
        });
        $(document).on("click", "#ulTargetColumnList li", function (e) {
            MyReports.prototype.AppendSelectedClass($(this));
        });
        $(document).on("click", "#ulColumnList li", function (e) {
            MyReports.prototype.AppendSelectedClass($(this));
        });
        $(document).on("click", "#btnMoveRight", function () {
            if ($("#ulColumnList li").length > 0) {
                $("#targetColumnError").html('');
            }
            MyReports.prototype.MoveSelectedElement("#ulColumnList", "#ulTargetColumnList");
        });
        $(document).on("click", "#btnMoveLeft", function () {
            MyReports.prototype.MoveSelectedElement("#ulTargetColumnList", "#ulColumnList");
        });
        $(document).on("click", "#btnAllMoveRight", function () {
            if ($("#ulColumnList li").length > 0) {
                $("#targetColumnError").html('');
            }
            $("#ulColumnList li").each(function () {
                $("#ulTargetColumnList").append("<li columnName=" + $(this).attr("columnName") + ">" + $(this).html() + "</li>");
                $(this).remove();
            });
        });
        $(document).on("click", "#btnAllMoveLeft", function () {
            $("#ulTargetColumnList li").each(function () {
                $("#ulColumnList").append("<li columnName=" + $(this).attr("columnName") + ">" + $(this).html() + "</li>");
                $(this).remove();
            });
        });
        $(document).on("click", "#btnMoveUp", function () {
            MyReports.prototype.listbox_move("ulTargetColumnList", "up", "columnName");
        });
        $(document).on("click", "#btnMoveDown", function () {
            MyReports.prototype.listbox_move("ulTargetColumnList", "down", "columnName");
        });
        $(document).on("click", "#btnAllUp", function () {
            MyReports.prototype.listbox_move("ulTargetColumnList", "First", "columnName");
        });
        $(document).on("click", "#btnAllDown", function () {
            MyReports.prototype.listbox_move("ulTargetColumnList", "Last", "columnName");
        });
        $(document).on("change", ".ddlAttributes", function () {
            MyReports.prototype.GetOperators(this);
        });
        $(document).on("blur", "#ReportName", function () {
            MyReports.prototype.CheckReportName();
        });
        MyReports.prototype.GetSelectedColumnData();
    };
    MyReports.prototype.GetOperators = function (ctrl) {
        $($(ctrl).parent().parent().find(".ddlOperators")).empty();
        Endpoint.prototype.GetOperators($("#ddlReportType option:selected").text(), $("option:selected", ctrl).text(), function (res) {
            $($(ctrl).parent().parent().find(".ddlOperators")).append(res.data);
            $($(ctrl).parent().parent().find(".ddlOperators option").each(function () {
                $(this).attr("data-operator", res.dataType);
            }));
        });
    };
    MyReports.prototype.GetReportDetails = function () {
        Endpoint.prototype.GetReportData($("#ddlReport").val(), function (response) {
            $("#reportContent").html(response.reportContent);
        });
    };
    MyReports.prototype.AppendTableRows = function () {
        $("#trTblReportFilters").show();
        if ($("#tblReportFilters").find('tbody').find('tr').length > 0) {
            var defaultRow = $($("#tblReportFilters").find('tr')[1]).clone();
            $(defaultRow).find("#btnSaveRowData").show();
            $(defaultRow).find(".ddlAttributes").val(0);
            $(defaultRow).find(".ddlOperators").empty();
            $(defaultRow).find(".txtValue").val('');
            $("#tblReportFilters").find('tbody').append(defaultRow);
        }
        else
            MyReports.prototype.AppendRowData();
    };
    MyReports.prototype.AppendRowData = function () {
        $('#tblReportFilters tbody').empty();
        var dynamicReportType = $("#ddlReportType option:selected").text();
        if ($("#ddlReportType option:selected").val() != '') {
            Endpoint.prototype.GetExportData(dynamicReportType, function (res) {
                if (res.data != "" && res.data != null) {
                    var parameters = res.data[1];
                    var dynamicHtml = "<option value=0>" + ZnodeBase.prototype.getResourceByKeyName("LabelPleaseSelect") + "</option>";
                    if (parameters != "" && parameters != null) {
                        $.each(parameters, function (index, value) {
                            dynamicHtml += "<option  value='" + parameters[index].Value + "'>" + parameters[index].Text + " </option>";
                        });
                        var ddlFilter = $('<select class="ddlAttributes"></select>');
                        var ddlOperators = $('<select class="ddlOperators"></select>');
                        var txtDefaultValue = $('<input class="txtValue"></input>');
                        var btnDelete = $('<a id="btnDeleteRowData" href="javascript:void(0)" class="btn-narrow-icon"><i class="z-close"></i></a>');
                        $("#tblReportFilters").find('tbody').append($('<tr>').append($('<td>').append(ddlFilter)).append($('<td>').append(ddlOperators)).append($('<td>').append(txtDefaultValue)).append($('<td>').append(btnDelete)));
                        $(".ddlAttributes").html(dynamicHtml);
                    }
                }
            });
        }
    };
    MyReports.prototype.ulTargetColumnList = function () {
        if ($("#divTargetColumnList").attr("name") == "TargetColumnList") {
            $("#divTargetColumnList .scroll-default").attr("id", "ulTargetColumnList");
        }
    };
    MyReports.prototype.ulColumnList = function () {
        if ($("#divColumnList").attr("name") == "ColumnList") {
            $("#divColumnList .scroll-default").attr("id", "ulColumnList");
        }
    };
    MyReports.prototype.GetSelectedColumnData = function () {
        var dynamicReportType = $("#ddlReportType option:selected").text();
        MyReports.prototype.ShoHideLocaleList(dynamicReportType);
        if ($("#ddlReportType option:selected").val() != '') {
            Endpoint.prototype.GetColumnList($("#CustomReportTemplateId").val(), dynamicReportType, function (res) {
                if (res.data != "" && res.data != null) {
                    MyReports.prototype.AddFieldToSourceList(res.data[0]);
                    MyReports.prototype.AddFieldToDestinationList(res.data[1]);
                }
            });
        }
    };
    MyReports.prototype.AddFieldToDestinationList = function (selectedColumn) {
        var dynamicHtml = "";
        if (selectedColumn != "" && selectedColumn != null) {
            $.each(selectedColumn, function (index, value) {
                dynamicHtml += "<li columnName='" + value + "'>" + value + " </li>";
            });
            $("#ulTargetColumnList").html(dynamicHtml);
        }
    };
    MyReports.prototype.AddFieldToSourceList = function (columns) {
        var dynamicHtml = "";
        if (columns != "" && columns != null) {
            $.each(columns, function (index, value) {
                dynamicHtml += "<li columnName='" + columns[index] + "'>" + columns[index] + " </li>";
            });
            $("#ulColumnList").html(dynamicHtml);
        }
    };
    MyReports.prototype.ShoHideLocaleList = function (reportType) {
        if (reportType == 'Product' || reportType == 'Category')
            $("#divLocale").show();
        else
            $("#divLocale").hide();
    };
    MyReports.prototype.GetData = function () {
        $('#tblReportFilters tbody').empty();
        var dynamicReportType = $("#ddlReportType option:selected").text();
        MyReports.prototype.ShoHideLocaleList(dynamicReportType);
        $("#ulTargetColumnList").empty();
        $("#ulColumnList").html('');
        if ($("#ddlReportType option:selected").val() != '') {
            Endpoint.prototype.GetExportData(dynamicReportType, function (res) {
                if (res.data != "" && res.data != null) {
                    var columns = res.data[0];
                    var dynamicHtml = "";
                    if (columns != "" && columns != null) {
                        $.each(columns, function (index, value) {
                            var columnName = columns[index].Text;
                            dynamicHtml += "<li columnName='" + columnName + "'>" + columnName + " </li>";
                        });
                        $("#ulColumnList").html(dynamicHtml);
                    }
                }
            });
            MyReports.prototype.AppendTableRows();
        }
        MyReports.prototype.GetReportView();
    };
    MyReports.prototype.AppendSelectedClass = function (controlName) {
        if ($(controlName) != undefined) {
            $(controlName).parent().find("li").removeClass("selected");
            $(controlName).addClass("selected");
        }
    };
    MyReports.prototype.MoveSelectedElement = function (fromControl, toControl) {
        var fromliControl = fromControl + " li.selected ";
        var elements = $(fromliControl);
        if (elements != undefined) {
            $(toControl).append($(fromliControl));
            elements.removeClass("selected");
            $($(fromControl + " li ")[0]).addClass("selected");
        }
    };
    MyReports.prototype.listbox_move = function (listID, direction, attributeVal) {
        var selValue = $("#" + listID + " .selected").attr(attributeVal);
        var selText = $("#" + listID + " .selected").html();
        if (selText != undefined && selValue != undefined) {
            var dynamicHtml = "<li " + attributeVal + "='" + selValue + "'>" + selText + "</li>";
            if (direction == "First") {
                $("#" + listID).prepend(dynamicHtml);
            }
            else if (direction == "Last") {
                $("#" + listID).append(dynamicHtml);
            }
            else if (direction == "down") {
                var dynamicHtmlTest = $("#" + listID + " .selected").next("li");
                if (dynamicHtmlTest.length != 0) {
                    $("#" + listID + " .selected").next("li").after(dynamicHtml);
                }
                else {
                    return false;
                }
            }
            else {
                var dynamicHtmlTest = $("#" + listID + " .selected").prev("li");
                if (dynamicHtmlTest.length != 0) {
                    $("#" + listID + " .selected").prev("li").before(dynamicHtml);
                }
                else {
                    return false;
                }
            }
            $("#" + listID + " .selected").remove();
            $("#" + listID + " li[" + attributeVal + "='" + selValue + "']").addClass("selected");
        }
    };
    MyReports.prototype.GenerateDynamicReports = function () {
        ZnodeBase.prototype.ShowLoader();
        MyReports.prototype.RemoveValidationError();
        if (MyReports.prototype.ValidateForm()) {
            MyReports.prototype.CreateAndPostModel();
            ZnodeBase.prototype.HideLoader();
        }
        else
            ZnodeBase.prototype.HideLoader();
    };
    MyReports.prototype.CreateAndPostModel = function () {
        var model = MyReports.prototype.CreateModel();
        MyReports.prototype.PostModel(model);
    };
    MyReports.prototype.CreateModel = function () {
        var dynamicReportFilters = new Array();
        var loopCount = $("#tblReportFilters > tbody > tr").length;
        for (var iCount = 0; iCount < loopCount; iCount++) {
            if ($($("#tblReportFilters > tbody > tr")[iCount]).find("td").find(".ddlAttributes option:selected").text().toLowerCase() != "please select" &&
                $($("#tblReportFilters > tbody > tr")[iCount]).find("td").find(".txtValue").val() != "") {
                var Parameters = {
                    Name: $($("#tblReportFilters > tbody > tr")[iCount]).find("td").find(".ddlAttributes option:selected").text(),
                    Operator: $($("#tblReportFilters > tbody > tr")[iCount]).find("td").find(".ddlOperators option:selected").text(),
                    Value: $($("#tblReportFilters > tbody > tr")[iCount]).find("td").find(".txtValue").val(),
                    DataType: $($("#tblReportFilters > tbody > tr")[iCount]).find("td").find(".ddlOperators option").attr("data-operator")
                };
                dynamicReportFilters.push(Parameters);
            }
        }
        var paramList = {
            ParamList: dynamicReportFilters
        };
        var dynamicReportColumns = new Array();
        var loopCount = $("#ulTargetColumnList > li").length;
        for (var iCount = 0; iCount < loopCount; iCount++) {
            var Columns = {
                ColumnName: $($("#ulTargetColumnList > li")[iCount]).text()
            };
            dynamicReportColumns.push(Columns);
        }
        var ColumnList = {
            ColumnList: dynamicReportColumns
        };
        var dynamicReportModel = {
            ReportName: $("#ReportName").val(),
            ReportType: $("#ddlReportType option:selected").text(),
            ReportTypeId: $("#ddlReportType option:selected").val(),
            Parameters: paramList,
            Columns: ColumnList,
            LocaleId: $("#LocaleId").val(),
            CustomReportTemplateId: $("#CustomReportTemplateId").val(),
            PriceId: $("#ddlPrice option:selected").val(),
            WarehouseId: $("#ddlWarehouse option:selected").val(),
            CatalogId: $("#ddlCatalog option:selected").val()
        };
        return dynamicReportModel;
    };
    MyReports.prototype.PostModel = function (model) {
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.SaveCustomReport(model, function (res) {
            if (res.data)
                window.location.href = window.location.protocol + "//" + window.location.host + "/MyReports/GetReport?reportPath=" + res.reportName + ".rdl&reportName=Dynamic Reports - " + res.reportName + "&isDynamicReport=true";
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.errorMessage, "error", isFadeOut, fadeOutTime);
        });
        ZnodeBase.prototype.ShowLoader();
    };
    MyReports.prototype.RemoveValidationError = function () {
        $("#reportNameError").html('');
        $("#targetColumnError").html('');
    };
    MyReports.prototype.ValidateForm = function () {
        var isValidReportName = MyReports.prototype.CheckReportName();
        var isSourceColumnsAvailable = MyReports.prototype.CheckSourceColumns();
        return (isValidReportName && isSourceColumnsAvailable);
    };
    MyReports.prototype.CheckSourceColumns = function () {
        if ($("#ulTargetColumnList > li").length > 0)
            return true;
        else {
            $("#targetColumnError").html(ZnodeBase.prototype.getResourceByKeyName("SelectReportColumns"));
            return false;
        }
    };
    MyReports.prototype.CheckReportName = function () {
        if ($("#ReportName").val().length > 0) {
            if (MyReports.prototype.CheckReportNameLength()) {
                $("#reportNameError").html('');
                return true;
            }
            else {
                $("#reportNameError").html(ZnodeBase.prototype.getResourceByKeyName("ReportNameLengthError"));
                return false;
            }
        }
        else {
            $("#reportNameError").html(ZnodeBase.prototype.getResourceByKeyName("RequiredReportName"));
            return false;
        }
    };
    MyReports.prototype.CheckReportNameLength = function () {
        return !($("#ReportName").val().length > 50);
    };
    MyReports.prototype.RemoveHrefAttributes = function () {
        $(".z-view").removeAttr("href");
        $(document).on("click", ".z-view", function (e) {
            e.preventDefault();
            MyReports.prototype.ShowDynamicReport($(this));
        });
    };
    MyReports.prototype.ShowDynamicReport = function (control) {
        var reportName = $(control).attr("data-parameter").split('&')[0].split('=')[1];
        window.location.href = window.location.protocol + "//" + window.location.host + "/MyReports/GetReport?reportPath=" + reportName + ".rdl&reportName=Dynamic Reports - " + reportName + "&isDynamicReport=true";
    };
    MyReports.prototype.DeleteDynamicReport = function (control) {
        var customReportIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (customReportIds.length > 0) {
            Endpoint.prototype.DeleteDynamicReport(customReportIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    MyReports.prototype.GetReportView = function () {
        var reportType = $("#ddlReportType option:selected").text();
        Endpoint.prototype.GetReportView(reportType, function (res) {
            $("#divView").html('');
            $("#divView").html(res);
        });
    };
    return MyReports;
}(ZnodeBase));
//# sourceMappingURL=MyReports.js.map