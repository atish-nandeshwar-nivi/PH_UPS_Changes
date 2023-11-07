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
var Import = /** @class */ (function (_super) {
    __extends(Import, _super);
    function Import() {
        var _this = _super.call(this) || this;
        _this._endPoint = new Endpoint();
        return _this;
    }
    Import.prototype.Init = function () {
        $('#updateMappings').hide();
        $(document).on("click", "#SourceColumnList li", function (e) {
            Import.prototype.AppendSelectedClass($(this));
        });
        $(document).on("click", "#TargetColumnList li", function (e) {
            Import.prototype.AppendSelectedClass($(this));
        });
        $(document).on("click", "#btnSourceMoveUp", function () {
            Import.prototype.listbox_move("SourceColumnList", "up", "sourceColumnName");
        });
        $(document).on("click", "#btnSourceMoveDown", function () {
            Import.prototype.listbox_move("SourceColumnList", "down", "sourceColumnName");
        });
        $(document).on("click", "#btnSourceAllUp", function () {
            Import.prototype.listbox_move("SourceColumnList", "First", "sourceColumnName");
        });
        $(document).on("click", "#btnSourceAllDown", function () {
            Import.prototype.listbox_move("SourceColumnList", "Last", "sourceColumnName");
        });
        $(document).on("click", "#CsvHeaders li", function (e) {
            Import.prototype.AppendSelectedClass($(this));
        });
        $(document).on("click", "#btnMoveRight", function () {
            Import.prototype.MoveSelectedElement("#CsvHeaders", "#SourceColumnList");
            Import.prototype.ClearMappingErrorMessage();
        });
        $(document).on("click", "#btnMoveLeft", function () {
            Import.prototype.MoveSelectedElement("#SourceColumnList", "#CsvHeaders");
            Import.prototype.ClearMappingErrorMessage();
        });
        $(document).on("click", "#btnAllMoveRight", function () {
            Import.prototype.MoveAllRight();
        });
        $(document).on("click", "#btnAllMoveLeft", function () {
            Import.prototype.MoveAllLeft();
        });
        $(document).on("click", "#btnTargetMoveUp", function () {
            Import.prototype.listbox_move("TargetColumnList", "up", "targetColumnName");
        });
        $(document).on("click", "#btnTargetMoveDown", function () {
            Import.prototype.listbox_move("TargetColumnList", "down", "targetColumnName");
        });
        $(document).on("click", "#btnTargetAllUp", function () {
            Import.prototype.listbox_move("TargetColumnList", "First", "targetColumnName");
        });
        $(document).on("click", "#btnTargetAllDown", function () {
            Import.prototype.listbox_move("TargetColumnList", "Last", "targetColumnName");
        });
        $(document).on("blur", "#TemplateName", function () {
            Import.prototype.ClearErrorMessage();
        });
        $(document).on("click", "#btnCreateTemplateName", function () {
            if ($("#TemplateName").val() == 0 || $("#TemplateName").val() == undefined || $("#TemplateName").val() == "") {
                $("#error-template-name").html(ZnodeBase.prototype.getResourceByKeyName("EnterTemplateNameError"));
            }
            else {
                $("#error-template-name").html("");
                Import.prototype.AddTemplateName();
                $("#ShowHideTemplates").show();
            }
        });
        $(document).on("change", "#txtUpload", function () {
            Import.prototype.ValidateImportedFileType();
        });
    };
    Import.prototype.RemoveTargetColumns = function () {
        $("#TargetColumnList").empty();
        return true;
    };
    Import.prototype.MoveAllLeft = function () {
        $("#SourceColumnList li").each(function () {
            var header = $(this).html().trim();
            var attr = $(this).attr("CsvHeaders");
            var isAvailable = false;
            if ($("#CsvHeaders").find("li").length > 0) {
                $("#CsvHeaders li").each(function () {
                    if ($(this).html().trim() != header) {
                        isAvailable = true;
                    }
                    else {
                        isAvailable = false;
                        return false;
                    }
                });
            }
            else {
                $("#CsvHeaders").append("<li sourcecolumnname=" + $(this).attr("sourceColumnName") + ">" + $(this).html() + "</li>");
                $(this).remove();
            }
            if (isAvailable) {
                $("#CsvHeaders").append("<li sourcecolumnname=" + $(this).attr("sourceColumnName") + ">" + $(this).html() + "</li>");
                $(this).remove();
            }
        });
    };
    Import.prototype.MoveAllRight = function () {
        $("#CsvHeaders li").each(function () {
            var header = $(this).html().trim();
            var attr = $(this).attr("sourceColumnName");
            var isAvailable = false;
            if ($("#SourceColumnList").find("li").length > 0) {
                $("#SourceColumnList li").each(function () {
                    if ($(this).html().trim() != header) {
                        isAvailable = true;
                    }
                    else {
                        isAvailable = false;
                        return false;
                    }
                });
            }
            else {
                $("#SourceColumnList").append("<li sourceColumnName=" + $(this).attr("sourceColumnName") + ">" + $(this).html() + "</li>");
                $(this).remove();
            }
            if (isAvailable) {
                $("#SourceColumnList").append("<li sourceColumnName=" + $(this).attr("sourceColumnName") + ">" + $(this).html() + "</li>");
                $(this).remove();
            }
        });
        Import.prototype.ClearMappingErrorMessage();
    };
    Import.prototype.MoveSelectedElement = function (fromControl, toControl) {
        var fromliControl = fromControl + " li.selected ";
        var elements = $(fromliControl);
        if (elements != undefined) {
            if (Import.prototype.CheckHeaderIsNotAvailable($(fromliControl).html().trim(), toControl)) {
                $(toControl).append($(fromliControl));
                elements.removeClass("selected");
                $($(fromControl + " li ")[0]).addClass("selected");
            }
        }
    };
    Import.prototype.AppendSelectedClass = function (controlName) {
        if ($(controlName) != undefined) {
            $(controlName).parent().find("li").removeClass("selected");
            $(controlName).addClass("selected");
        }
    };
    Import.prototype.GetCsvHeaders = function (dataParam) {
        ZnodeBase.prototype.ShowLoader();
        var ajaxRequest = $.ajax({
            type: "POST",
            url: "/Import/GetCsvData",
            contentType: false,
            processData: false,
            data: dataParam
        });
        ajaxRequest.done(function (data, textStatus) {
            var dynamicHtml = "";
            if (data.Csvlist != "" && data.Csvlist != null) {
                var headers = data.Csvlist.split(',');
                for (var arrayCounter = 0; arrayCounter < headers.length; ++arrayCounter) {
                    var header = headers[arrayCounter];
                    dynamicHtml += "<li sourceColumnName='" + header + "' >" + header + " </li>";
                }
                $("#CsvHeaders").html(dynamicHtml);
                $("#ChangedFileName").val(data.UpdateFileName);
                ZnodeBase.prototype.HideLoader();
            }
        });
    };
    Import.prototype.CheckHeaderIsNotAvailable = function (header, toControl) {
        var isAvailable = true;
        $(toControl + " li").each(function () {
            if ($(this).html().trim() == header) {
                isAvailable = false;
                return isAvailable;
            }
            else {
                isAvailable = true;
            }
        });
        return isAvailable;
    };
    Import.prototype.ValidateImportFileType = function () {
        if ($("#txtUpload").val() != "") {
            if ($("#fileName").html().split(".")[1] == "csv") {
                $("#error-file-upload").html("");
                return true;
            }
            else {
                $("#error-file-upload").html(ZnodeBase.prototype.getResourceByKeyName("SelectCSVFileError"));
                return false;
            }
        }
        else {
            $("#error-file-upload").html(ZnodeBase.prototype.getResourceByKeyName("FileNotPresentError"));
            return false;
        }
    };
    Import.prototype.ValidateImportedFileType = function () {
        var totalFiles = $("#txtUpload").get(0).files.length;
        if (totalFiles > 0) {
            var file = $("#txtUpload").get(0).files[0];
            var regularExpression = /.csv/;
            if (!regularExpression.test(file.name)) {
                $("#error-file-upload").html(ZnodeBase.prototype.getResourceByKeyName("SelectCSVFileError"));
                $("#CsvHeaders").empty();
                return false;
            }
            else {
                var files = $("#txtUpload").get(0).files;
                var dataParm = new FormData();
                dataParm.append("FilePath", files[0]);
                Import.prototype.GetCsvHeaders(dataParm);
                $("#error-file-upload").html("");
                return true;
            }
        }
        return false;
    };
    Import.prototype.CheckCSVFileName = function (fileName) {
        var format = /[ !@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
        return !format.test(fileName);
    };
    Import.prototype.ValidateModel = function () {
        return (Import.prototype.ValidateImportType() &&
            Import.prototype.ValidateTemplateName() &&
            Import.prototype.ValidateImportFileType() &&
            Import.prototype.ValidateMappings());
    };
    Import.prototype.ValidateImportType = function () {
        if ($("#importTypeList option:selected").val() == 0 || $("#importTypeList option:selected").val() == undefined || $("#importTypeList option:selected").val() == "") {
            $("#error-importname").html(ZnodeBase.prototype.getResourceByKeyName("SelectImportNameError"));
            return false;
        }
        else {
            $("#error-importname").html("");
            return true;
        }
    };
    Import.prototype.ValidateTemplateName = function () {
        if ($("#templateList option:selected").val() == 0 || $("#templateList option:selected").val() == undefined || $("#templateList option:selected").val() == "") {
            if ($("#TemplateName").val() == undefined || $("#TemplateName").val() == "") {
                $("#error-templatename").html(ZnodeBase.prototype.getResourceByKeyName("SelectTemplateNameError"));
                if ($("#txtUpload") != undefined && $("#txtUpload").val() != undefined && $("#txtUpload").val() != "") {
                    $("#txtUpload").val("");
                    $("#fileName").html("");
                }
                return false;
            }
            else {
                $("#error-templatename").html("");
                return true;
            }
        }
        else {
            return true;
        }
    };
    Import.prototype.ValidateMappings = function () {
        if ($("#SourceColumnList > li").length > 0 && $("#TargetColumnList> li").length > 0) {
            $("#error-sourcecolumnlist").html("");
            return true;
        }
        else {
            $("#error-sourcecolumnlist").html(ZnodeBase.prototype.getResourceByKeyName("SelectTemplateMappingError"));
            return false;
        }
    };
    Import.prototype.ValidateAndPost = function () {
        if (Import.prototype.ValidateModel()) {
            Import.prototype.CreateAndPostModel();
            return false;
        }
        else {
            return false;
        }
    };
    Import.prototype.CreateModel = function () {
        var mappings = new Array();
        var loopCount = $("#TargetColumnList > li").length;
        for (var iCount = 0; iCount < loopCount; iCount++) {
            var item = {
                MappingId: $($("#TargetColumnList > li")[iCount]).attr('targetvalue'),
                MapCsvColumn: $($("#SourceColumnList > li")[iCount]).text().trim(),
                MapTargetColumn: $($("#TargetColumnList > li")[iCount]).text().trim()
            };
            mappings.push(item);
        }
        var templateName = "";
        if ($("#templateList").val() > 0) {
            templateName = $("#templateList option:selected").text();
        }
        else {
            templateName = $("#TemplateName").val();
        }
        var ImportViewModels = {
            LocaleId: $("#LocaleId").val(),
            ImportHeadId: $("#importTypeList").val(),
            ImportType: $("#importTypeList option:selected").text(),
            TemplateId: $("#templateList").val(),
            TemplateName: templateName,
            TemplateVersion: $("#TemplateVersion").val(),
            FileName: $("#ChangedFileName").val(),
            FamilyId: $("#familyList").val(),
            PriceListId: $("#pricingList option:selected").val(),
            CatalogId: $("#catalogList option:selected").val(),
            Mappings: mappings,
            CountryCode: $("#countryList option:selected").val(),
            PortalId: $("#PortalId").val(),
        };
        return ImportViewModels;
    };
    Import.prototype.CreateAndPostModel = function () {
        var ImportViewModels = Import.prototype.CreateModel();
        Import.prototype.PostData(ImportViewModels);
    };
    Import.prototype.PostData = function (importModel) {
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.ImportPost(importModel, function (res) {
            setTimeout(function () {
                ZnodeBase.prototype.HideLoader();
                window.location.href = window.location.protocol + "//" + window.location.host + "/Import/List";
            }, 900);
        });
    };
    Import.prototype.GetTemplateAndFamilies = function () {
        var importHeadId = $("#importTypeList option:selected").val();
        var familyId = $("#familyList option:selected").val();
        if (familyId == "" || familyId == undefined) {
            familyId = 0;
        }
        Import.prototype.ResetDropdowns();
        $("#downloadImportHeadId").val(importHeadId);
        $("#downloadImportName").val($("#importTypeList option:selected").text());
        $("#downloadImportFamilyId").val(familyId);
        $('#divSelectPricing').hide();
        if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "product" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "category") {
            $('#divSelectFamily').show();
            $('#divSelectCountry').hide();
            $('#divSelectCatalog').hide();
            Import.prototype.GetAllFamilies();
        }
        else if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "pricing") {
            $('#divSelectPricing').show();
            $('#divSelectCatalog').hide();
            $('#divSelectCountry').hide();
            Endpoint.prototype.GetPricingList(function (res) {
                var dynamicHtml = "";
                if (res.pricingList != "" && res.pricingList != null) {
                    dynamicHtml = "<option value='0'>Please Select</option>";
                    $("#pricingList").html(Import.prototype.GetDropDownHtml(res.pricingList, dynamicHtml));
                }
            });
        }
        else if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "catalogcategoryassociation") {
            $('#divSelectCatalog').show();
            $('#divSelectCountry').hide();
            Endpoint.prototype.GetImportCatalogList(function (res) {
                var dynamicHtml = "";
                if (res.catalogList != "" && res.catalogList != null) {
                    dynamicHtml = "<option value='0'>Please Select</option>";
                    $("#catalogList").html(Import.prototype.GetDropDownHtml(res.catalogList, dynamicHtml));
                }
            });
        }
        else if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "zipcode") {
            $('#divSelectCountry').show();
            $('#divSelectCatalog').hide();
            Endpoint.prototype.GetImportCountryList(function (res) {
                var dynamicHtml = "";
                if (res.countryList != "" && res.countryList != null) {
                    dynamicHtml = "<option value='0'>Please Select</option>";
                    $("#countryList").html(Import.prototype.GetDropDownHtml(res.countryList, dynamicHtml));
                }
            });
        }
        else if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "seodetails" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "customer" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "adminb2bcustomer" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "account") {
            $('#divSelectSEODetails').show();
            $('#divSelectCountry').hide();
            $('#divSelectCatalog').hide();
            Import.prototype.GetTemplateList();
            Endpoint.prototype.GetImportPortalList(function (res) {
                var dynamicHtml = "";
                if (res.portalList != "" && res.portalList != null) {
                    dynamicHtml = "<option value='0'>Please Select</option>";
                    $("#portalList").html(Import.prototype.GetDropDownHtml(res.portalList, dynamicHtml));
                }
            });
        }
        else {
            $('#divSelectFamily').hide();
            $('#divSelectCountry').hide();
            $('#divSelectPricing').hide();
            $('#divSelectCatalog').hide();
            Import.prototype.GetTemplateList();
        }
        $('#updateMappings').hide();
        if ($("#importTypeList").val() != "")
            $("#error-importname").html("");
    };
    Import.prototype.GetTemplatesFromFamily = function () {
        $("#error-familyname").html("");
        $("#TargetColumnList").html("");
        $("#SourceColumnList").html("");
        Import.prototype.GetTemplateList();
    };
    Import.prototype.GetAllFamilies = function () {
        var importType = $("#importTypeList option:selected").text().toLocaleLowerCase();
        if (importType == "product" || importType == "category") {
            var isCategory = true;
            if (importType == "product") {
                isCategory = false;
            }
            Endpoint.prototype.GetAllFamilies(isCategory, function (res) {
                var dynamicHtml = "";
                if (res.productFamilies != "" && res.productFamilies != null) {
                    dynamicHtml = "<option value='0'>Please Select</option>";
                    $("#familyList").html(Import.prototype.GetDropDownHtml(res.productFamilies, dynamicHtml));
                }
            });
        }
    };
    Import.prototype.GetDropDownHtml = function (responseList, dynamicHtml) {
        for (var arrayCounter = 0; arrayCounter < responseList.length; ++arrayCounter) {
            var value = responseList[arrayCounter].Value;
            var templateList = responseList[arrayCounter].Text;
            dynamicHtml += "<option value='" + value + "'>" + templateList + " </option>";
        }
        return dynamicHtml;
    };
    Import.prototype.ResetDropdowns = function () {
        $('#divSelectFamily').hide();
        $('#divSelectPricing').hide();
        $('#divSelectSEODetails').hide();
        $("#familyList").val('0');
        $("#templateList").val('0');
        $("#pricingList").val('0');
        $("#TargetColumnList").html("");
        $("#SourceColumnList").html("");
        $("#familyList").html("");
        $("#templateList").html("");
        $("#pricingList").html("");
    };
    Import.prototype.GetTemplateList = function () {
        $("#error-importname").html("");
        var importHeadId = $("#importTypeList option:selected").val();
        var familyId = 0;
        if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "product" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "category") {
            familyId = $("#familyList option:selected").val();
        }
        $("#downloadImportHeadId").val(importHeadId);
        $("#downloadImportName").val($("#importTypeList option:selected").text());
        $("#downloadImportFamilyId").val(familyId);
        Endpoint.prototype.GetTemplateList(importHeadId, familyId, function (res) {
            var dynamicHtml = "";
            if (res.templatenamelist != "" && res.templatenamelist != null) {
                $("#templateList").html(Import.prototype.GetDropDownHtml(res.templatenamelist, dynamicHtml));
                $("#TargetColumnList").html("");
                $("#SourceColumnList").html("");
            }
            else {
                $("#templateList").html('');
            }
        });
    };
    Import.prototype.GetTemplateMappings = function () {
        $("#error-templatename").html("");
        var templateId = $("#templateList option:selected").val();
        var importHeadId = $("#importTypeList option:selected").val();
        var familyId = $("#familyList option:selected").val();
        if (templateId == "" || templateId == undefined) {
            templateId = 0;
        }
        if (familyId == "" || familyId == undefined) {
            familyId = 0;
        }
        Endpoint.prototype.GetTemplateMappings(templateId, importHeadId, familyId, function (res) {
            if (res.templateMappingList != "" && res.templateMappingList != null) {
                var targetColumns = res.templateMappingList[0];
                var sourceColumns = res.templateMappingList[1];
                if ($("#divAddTemplatePopup").is(":visible") && templateId == 0) {
                    Import.prototype.ShowColumnLists(targetColumns, sourceColumns);
                }
                else if (!$("#divAddTemplatePopup").is(":visible") && templateId > 0) {
                    Import.prototype.ShowColumnLists(targetColumns, sourceColumns);
                }
                else {
                    $("#TargetColumnList").empty();
                    $("#SourceColumnList").empty();
                }
            }
        });
        Import.prototype.ShowUpdateMappingButton();
    };
    Import.prototype.ShowColumnLists = function (targetColumns, sourceColumns) {
        var dynamicHtml = "";
        if (targetColumns != "" && targetColumns != null) {
            for (var arrayCounter = 0; arrayCounter < targetColumns.length; ++arrayCounter) {
                var targetValue = targetColumns[arrayCounter].Value;
                var targetColumnName = targetColumns[arrayCounter].Text;
                dynamicHtml += "<li targetColumnName='" + targetColumnName + "'>" + targetColumnName + " </li>";
            }
            $("#TargetColumnList").html(dynamicHtml);
        }
        dynamicHtml = "";
        if (sourceColumns != "" && sourceColumns != null) {
            for (var arrayCounter = 0; arrayCounter < sourceColumns.length; ++arrayCounter) {
                var sourceColumnName = sourceColumns[arrayCounter].Text;
                if (sourceColumnName != null && $.trim(sourceColumnName) != "")
                    dynamicHtml += "<li sourceColumnName='" + sourceColumnName + "'>" + sourceColumnName + " </li>";
            }
            $("#SourceColumnList").html(dynamicHtml);
        }
    };
    Import.prototype.listbox_move = function (listID, direction, attributeVal) {
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
    Import.prototype.CreateNewTemplate = function () {
        if ($("#importTypeList option:selected").val() == "") {
            $("#error-importname").html(ZnodeBase.prototype.getResourceByKeyName("SelectImportNameError"));
            return false;
        }
        else {
            if ($("#importTypeList option:selected").text().toLocaleLowerCase() == "product" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "category") {
                if ($("#familyList option:selected").val() == "0" || $("#familyList option:selected").val() == undefined || $("#familyList option:selected").val() == "") {
                    $("#error-familyname").html(ZnodeBase.prototype.getResourceByKeyName("SelectImportFamilyError"));
                    return false;
                }
            }
            Import.prototype.CreateTemplate();
            $("#error-familyname").html("");
            $("#error-importname").html("");
            $("#templateList").val(0);
            $("#SourceColumnList").empty();
            $("#TargetColumnList").empty();
            setTimeout(function () { Import.prototype.GetTemplateMappings(); }, 300);
            return true;
        }
    };
    Import.prototype.CheckImportType = function () {
        if ($("#downloadImportHeadId").val() == "" || $("#downloadImportHeadId").val() == undefined) {
            $("#error-importname").html(ZnodeBase.prototype.getResourceByKeyName("SelectImportNameError"));
            return false;
        }
        else {
            if (($("#importTypeList option:selected").text().toLocaleLowerCase() == "product" || $("#importTypeList option:selected").text().toLocaleLowerCase() == "category") && $("#familyList option:selected").val() == 0) {
                $("#error-familyname").html(ZnodeBase.prototype.getResourceByKeyName("SelectImportFamilyError"));
                return false;
            }
            setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 1000);
            return true;
        }
    };
    Import.prototype.ClearErrorMessage = function () {
        if ($("#TemplateName").val() != undefined || $("#TemplateName").val() != "") {
            $("#error-templatename").html("");
        }
    };
    Import.prototype.ClearMappingErrorMessage = function () {
        if ($("#SourceColumnList > li").length > 0) {
            $("#error-sourcecolumnlist").html("");
        }
    };
    Import.prototype.ShowMappingErrorMessage = function () {
        if ($("#SourceColumnList > li").length == 0) {
            $("#error-sourcecolumnlist").html(ZnodeBase.prototype.getResourceByKeyName("SelectTemplateMappingError"));
        }
    };
    Import.prototype.CreateTemplate = function () {
        $("#error-template-name").html("");
        $("#divAddTemplatePopup").modal("show");
    };
    Import.prototype.AddTemplateName = function () {
        var templateName = $("#TemplateName").val();
        $("#templateList").empty();
        $("#templateList").append($("<option></option>").val("0").html(templateName).attr('selected', 'selected'));
        $("#divAddTemplatePopup").modal("hide");
        ZnodeBase.prototype.RemovePopupOverlay();
    };
    Import.prototype.ShowTemplateList = function () {
        Import.prototype.GetTemplateList();
        $("#ShowHideTemplates").hide();
    };
    Import.prototype.RemovePopupOverlay = function () {
        //Below code is used to close te overlay of popup, As it was not closed in server because Container is updated by Ajax call
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
    };
    Import.prototype.RemoveHrefAttributes = function () {
        $(".z-publish").removeAttr("href");
        $(".z-view").removeAttr("href");
        $(document).off("click", ".z-publish");
        $(document).on("click", ".z-publish", function (e) {
            ZnodeBase.prototype.ShowLoader();
            e.preventDefault();
            Import.prototype.ShowLogStatusInPopup($(this));
            return false;
        });
        $(document).off("click", ".z-view");
        $(document).on("click", ".z-view", function (e) {
            ZnodeBase.prototype.ShowLoader();
            e.preventDefault();
            Import.prototype.ShowLogDetailsInPopup($(this));
            return false;
        });
    };
    Import.prototype.ShowLogStatusInPopup = function (control) {
        var importProcessLogId = $(control).attr("data-parameter").split("=")[1];
        Endpoint.prototype.ShowLogStatus(parseInt(importProcessLogId), function (res) {
            if (res != "") {
                $("#divStatusPopup").html(res);
                $("#divStatusPopup").modal('show');
                ZnodeBase.prototype.HideLoader();
            }
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
        });
    };
    Import.prototype.ShowLogDetailsInPopup = function (control) {
        var importProcessLogId = $(control).attr("data-parameter").split("=")[1];
        Endpoint.prototype.ShowLogDetails(parseInt(importProcessLogId), function (res) {
            if (res != "") {
                $("#divLogDetailsPopup").html(res);
                $("#divLogDetailsPopup").show(700);
                ZnodeBase.prototype.ShowLoader();
                $("body").append("<div class='modal-backdrop fade in'></div>");
            }
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
        });
    };
    Import.prototype.UpdateMappings = function () {
        var importViewModels = Import.prototype.CreateModel();
        $.ajax({
            type: "POST",
            url: "/Import/UpdateMappings",
            data: importViewModels,
            success: function (res) {
                if (res.status) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, 'success', isFadeOut, fadeOutTime);
                }
                else {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, 'error', isFadeOut, fadeOutTime);
                }
            },
            error: function (error) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
            }
        });
    };
    Import.prototype.ShowUpdateMappingButton = function () {
        var templateId = $("#templateList option:selected").val();
        var importHeadId = $("#importTypeList option:selected").val();
        if (templateId == 0 && importHeadId == 0) {
            $('#updateMappings').hide();
            return false;
        }
        else {
            $('#updateMappings').show();
            return true;
        }
    };
    //Delete Import process Log details.
    Import.prototype.DeleteImportLogs = function (control) {
        var importProcessLogId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (importProcessLogId.length > 0) {
            Endpoint.prototype.DeleteImportLogs(importProcessLogId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //This method is used to select portal from list and show it on textbox
    Import.prototype.OnSelectPortalResult = function (item) {
        if (item != undefined) {
            $('#PortalId').val(item.Id);
        }
    };
    return Import;
}(ZnodeBase));
//# sourceMappingURL=Import.js.map