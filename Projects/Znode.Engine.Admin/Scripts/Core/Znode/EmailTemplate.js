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
var RESET_PASSWORD = "ResetPassword";
var EmailTemplate = /** @class */ (function (_super) {
    __extends(EmailTemplate, _super);
    function EmailTemplate() {
        return _super.call(this) || this;
    }
    EmailTemplate.prototype.Init = function () {
        EmailTemplate.prototype.LocaleDropDownChangeForEmailTemplate();
        EmailTemplate.prototype.AutoCompleteEmailTemplates();
        EmailTemplate.prototype.SaveTemplateMapping();
        EmailTemplate.prototype.ShowHideTemplateTokens();
    };
    EmailTemplate.prototype.LocaleDropDownChangeForEmailTemplate = function () {
        $("#ddl_locale_list_email_template").on("change", function () {
            Endpoint.prototype.EditEmailTemplate($("#EmailTemplateId").val(), $("#ddl_locale_list_email_template").val(), function (response) {
                $('#div_email_template_for_locale').html(response);
                $("#div_email_template_for_locale textarea").attr("wysiwygenabledproperty", "true");
                reInitializationMce();
            });
        });
    };
    EmailTemplate.prototype.DeleteEmailTemplates = function (control) {
        var emailTemplateId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (emailTemplateId.length > 0) {
            Endpoint.prototype.DeleteEmailTemplates(emailTemplateId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    EmailTemplate.prototype.PreviewTemplate = function () {
        $("#grid tbody tr td").find(".z-preview").on("click", function (e) {
            e.preventDefault();
            var templateId = $(this).attr("data-parameter").split('&')[0].split('=')[1];
            ZnodeBase.prototype.BrowseAsidePoupPanel('/EmailTemplate/Preview?emailTemplateId=' + templateId + '', 'divEmailTemplatePreview');
        });
    };
    EmailTemplate.prototype.AddNewArea = function (data) {
        data = 0;
        EmailTemplate.prototype.GetAvailableTemplateArea(data);
        $(".MessageBox").remove();
        $("#partial").show();
        $('.thead-div').show();
    };
    EmailTemplate.prototype.GetAvailableTemplateArea = function (data) {
        data = 0;
        Endpoint.prototype.GetAvailableTemplateArea($("#ddl_portal_list_for_email_template").val(), function (response) {
            if (response.status) {
                $("#partial").html(response.html);
                EmailTemplate.prototype.SetAreaMappingAttributes(0, true);
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, 'info', isFadeOut, fadeOutTime);
            }
        });
    };
    EmailTemplate.prototype.EditAreaMapping = function (data) {
        EmailTemplate.prototype.SetAreaMappingAttributes(data, false);
    };
    EmailTemplate.prototype.DeleteAreaMapping = function (data, control) {
        Endpoint.prototype.DeleteEmailTemplateAreaMapping(data, function (response) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            if (response.status) {
                $(control).closest("form").remove();
            }
            WebSite.prototype.DisplayNoRecordFoundMessage();
        });
    };
    EmailTemplate.prototype.CancelNewAddAreaMapping = function (data, control) {
        var EmailTemplateMapperId = data.split('_')[1];
        if (EmailTemplateMapperId <= 0) {
            $(control).closest("form").remove();
        }
        else {
            Endpoint.prototype.ManageEmailTemplateArea($("#ddl_portal_list_for_email_template").val(), function (responce) {
                $("#content-to-dispaly-in-table").html(responce);
            });
        }
    };
    EmailTemplate.prototype.SetAreaMappingAttributes = function (data, isCreate) {
        $("#saveAreaMapping_" + data + "").show();
        $("#CancelAreaMapping_" + data + "").show();
        $("#EditAreaMapping_" + data + "").attr("style", "display: none !important");
        $("#deleteAreaMapping_" + data + "").attr("style", "display: none !important");
        $("#areaActive_" + data + "").attr('disabled', false);
        $("#areaSmsActive_" + data + "").attr('disabled', false);
        $("#emailTemplate_" + data + "").attr('disabled', false);
        var emailArea = isCreate ? $("select[name=EmailTemplateAreasId] option:selected").text() : $("#emailArea_" + data + "").val();
        if (emailArea != RESET_PASSWORD)
            $("#areaIsEnableBcc_" + data + "").attr('disabled', false);
    };
    EmailTemplate.prototype.AreaMapperAddResult = function (data, control) {
        var id = $(control).closest("form").attr("id").split('_')[1];
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.message, data.status ? 'success' : 'error', isFadeOut, fadeOutTime);
        if (data.emailTemplateMapperId > 0 && data.status == true) {
            if (parseInt(id) == 0) {
                $("#partial").after(data.html);
                $("#partial").html("");
            }
            EmailTemplate.prototype.EmailTemplateShowHideFormAttributes(data.emailTemplateMapperId);
        }
        else {
            Endpoint.prototype.ManageEmailTemplateArea($("#ddl_portal_list_for_email_template").val(), function (res) {
                $("#content-to-dispaly-in-table").html(res);
                EmailTemplate.prototype.EmailTemplateShowHideFormAttributes(data.emailTemplateMapperId);
            });
        }
    };
    EmailTemplate.prototype.EmailTemplateShowHideFormAttributes = function (data) {
        var emailArea = $("#emailArea_" + data + "").val();
        if (emailArea == RESET_PASSWORD) {
            Endpoint.prototype.ManageEmailTemplateArea($("#ddl_portal_list_for_email_template").val(), function (res) {
                $("#content-to-dispaly-in-table").html(res);
            });
        }
        $("#saveAreaMapping_" + data + "").attr("style", "display: none !important");
        $("#CancelAreaMapping_" + data + "").attr("style", "display: none !important");
        $("#EditAreaMapping_" + data + "").show();
        $("#deleteAreaMapping_" + data + "").show();
        $("#emailArea_" + data + "").attr('disabled', 'disabled');
        $("#areaSmsActive_" + data + "").attr('disabled', 'disabled');
        $("#emailTemplate_" + data + "").attr('disabled', 'disabled');
        $("#areaActive_" + data + "").attr('disabled', 'disabled');
        $("#areaIsEnableBcc_" + data + "").attr('disabled', 'disabled');
    };
    EmailTemplate.prototype.AutoCompleteEmailTemplates = function () {
        $(".txtEmailTemplate").autocomplete({
            source: function (request, response) {
                try {
                    Endpoint.prototype.GetEmailTemplateListByName(request.term, function (res) {
                        if (res.length > 0) {
                            var templateValues = new Array();
                            res.forEach(function (templateValue) {
                                if (templateValue != undefined)
                                    templateValues.push(templateValue.TemplateName);
                            });
                            if ($.inArray(request.term, templateValues) == -1)
                                EmailTemplate.prototype.isTemplateValid = false;
                            else
                                EmailTemplate.prototype.isTemplateValid = true;
                            response($.map(res, function (item) {
                                return {
                                    label: item.TemplateName,
                                    templateId: item.EmailTemplateId,
                                };
                            }));
                        }
                        else {
                            EmailTemplate.prototype.isTemplateValid = false;
                        }
                    });
                }
                catch (err) {
                }
            },
            select: function (event, ui) {
                var id = $(this).attr("id").split('_')[1];
                $("#frmEmailTemplateArea_" + id + " #EmailTemplateId").val(ui.item.templateId);
                EmailTemplate.prototype.isTemplateValid = true;
            },
            focus: function (event, ui) {
                var id = $(this).attr("id").split('_')[1];
                $("#frmEmailTemplateArea_" + id + " #EmailTemplateId").val(ui.item.templateId);
            }
        }).focusout(function () {
            return EmailTemplate.prototype.ValidateEmailTemplate($(this).attr("id"));
        });
    };
    EmailTemplate.prototype.ValidateEmailTemplate = function (data) {
        var flag = true;
        var mapperId = data.split('_')[1];
        if (EmailTemplate.prototype.isTemplateValid != undefined && !EmailTemplate.prototype.isTemplateValid) {
            EmailTemplate.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("InvalidEmailTemplate"), mapperId);
            return flag = false;
        }
        else {
            EmailTemplate.prototype.HideErrorMessage(mapperId);
        }
        return flag;
    };
    EmailTemplate.prototype.ShowErrorMessage = function (errorMessage, mapperId) {
        if (errorMessage === void 0) { errorMessage = ""; }
        $("#emailTemplate_" + mapperId + "").removeClass("input-validation-valid").addClass("input-validation-error");
        $("#valEmailTemplate_" + mapperId + "").removeClass("field-validation-valid").addClass("field-validation-error").html("<span>" + errorMessage + "</span>");
        $("#frmEmailTemplateArea_" + mapperId + " #EmailTemplateId").val(0);
    };
    EmailTemplate.prototype.HideErrorMessage = function (mapperId) {
        $("#emailTemplate_" + mapperId + "").removeClass("input-validation-error").addClass("input-validation-valid");
        $("#valEmailTemplate_" + mapperId + "").removeClass("field-validation-error").addClass(" field-validation-valid").html("");
    };
    EmailTemplate.prototype.SaveTemplateMapping = function () {
        $(".btnSaveTemplateMapping").on("click", function () {
            return EmailTemplate.prototype.ValidateEmailTemplate($(this).attr("id"));
        });
    };
    EmailTemplate.prototype.PortalDropDownChange = function () {
        Endpoint.prototype.ManageEmailTemplateArea($("#ddl_portal_list_for_email_template").val(), function (responce) {
            $("#content-to-dispaly-in-table").html(responce);
        });
    };
    EmailTemplate.prototype.ShowHideTemplateTokens = function () {
        $("#templateTokens").on("click", function () {
            if ($("#templateTokensData").hasClass('display-none')) {
                $(this).html("Hide");
                $("#templateTokensData").removeClass("display-none").show("slow");
            }
            else {
                $(this).html("See More");
                $("#templateTokensData").addClass("display-none").hide("slow");
            }
        });
    };
    EmailTemplate.prototype.OnEmailTemplateAreaChange = function () {
        var emailArea = $("select[name=EmailTemplateAreasId] option:selected").text();
        if (emailArea == RESET_PASSWORD) {
            $("#areaIsEnableBcc_0").attr('disabled', true);
            $("#areaIsEnableBcc_0").attr('checked', false);
        }
        else
            $("#areaIsEnableBcc_0").attr('disabled', false);
    };
    return EmailTemplate;
}(ZnodeBase));
//# sourceMappingURL=EmailTemplate.js.map