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
var Attributes = /** @class */ (function (_super) {
    __extends(Attributes, _super);
    function Attributes() {
        return _super.call(this) || this;
    }
    Attributes.prototype.Init = function () {
        Attributes.prototype.BindDefaultValueSaveClick();
        Attributes.prototype.BindDefaultValueDeleteClick();
        Attributes.prototype.ShowHideDefaultView();
        ProductAttribute.prototype.ShowhideFieldForAttributeTypeLink();
        Attributes.prototype.AddRequiredValidation();
        Attributes.prototype.ShowhideMaxCharacterforTextArea();
        Attributes.prototype.ShowHideIsAllowMultiUpload();
        Attributes.prototype.ParseForm();
        ProductAttribute.prototype.ShowHideIsConfigurable();
        ProductAttribute.prototype.ShowHideIsRequired();
        ZnodeBase.prototype.ResetTabDetails();
    };
    //Bind default value save/edit click event.
    Attributes.prototype.BindDefaultValueSaveClick = function () {
        $(".action-save").off("click");
        $(".action-save").click(function () {
            var indexid = $(this).parent().attr('id').split('_')[1];
            var buttonObj = this;
            if ($(this).attr('title') === "Edit")
                Attributes.prototype.ShowDefaultValueEditMode(indexid, buttonObj);
            else
                Attributes.prototype.ValidateAndSaveDefaultAttributeValue(indexid, buttonObj);
        });
    };
    //Show default value row in edit mode.
    Attributes.prototype.ShowDefaultValueEditMode = function (indexId, buttonObj) {
        $('#table-default-Values div[id="rowIndex_' + indexId + '"]').find('input').show();
        $('#table-default-Values div[id="rowIndex_' + indexId + '"]').find('label').hide();
        $(buttonObj).replaceWith('<a href="#" class="action-save btn-narrow-icon" title= "Save" > <i class=z-ok > </i></a>');
        Attributes.prototype.BindDefaultValueSaveClick();
    };
    //Bind default value delete click event.
    Attributes.prototype.BindDefaultValueDeleteClick = function () {
        $(".action-delete").off("click");
        $("body").on("click", ".action-delete", function () {
            $('#hdnDeleteDiv').val($(this).attr("id"));
        });
    };
    //Check default value validation and save validated value.
    Attributes.prototype.ValidateAndSaveDefaultAttributeValue = function (indexid, buttonObj) {
        //Check atleast one locale default value present in a row. 
        if (!Attributes.prototype.ValidateDefaultValue(indexid))
            return;
        var defaultvalueCode = $('#table-default-Values div[id="code_' + indexid + '"]').find('#DefaultValueCode-' + indexid).val();
        $('#table-default-Values div[id="code_' + indexid + '"]').find('#DefaultValueCode-' + indexid).next().text(defaultvalueCode);
        Endpoint.prototype.SaveDefaultValuesMedia(Attributes.prototype.GetDefaultValueLocaleValueArray(indexid), $("#AttributeId").val(), defaultvalueCode, $("#hdnDefaultvalue_" + indexid).val(), function (res) {
            if (res.defaultvalueId > 0) {
                $('#hdnDefaultvalue_' + indexid).val(res.defaultvalueId);
                $('#table-default-Values div[id="rowIndex_' + indexid + '"]').find('input').hide();
                $('#table-default-Values div[id="rowIndex_' + indexid + '"]').find('label').show();
                $('#table-default-Values div[id="code_' + indexid + '"]').find('input').hide();
                $('#table-default-Values div[id="code_' + indexid + '"]').find('label').show();
                $(buttonObj).replaceWith('<a href="#" class="action-save btn-narrow-icon" title= "Edit" > <i class=z-edit > </i></a>');
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.mode == "Create"
                    ? ZnodeBase.prototype.getResourceByKeyName("RecordCreatedSuccessfully")
                    : ZnodeBase.prototype.getResourceByKeyName("RecordUpdatededSuccessfully"), "success", false, fadeOutTime);
            }
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), "error", false, fadeOutTime);
            Attributes.prototype.BindDefaultValueSaveClick();
        });
    };
    //Get default value locale array with property id and value.
    Attributes.prototype.GetDefaultValueLocaleValueArray = function (indexid) {
        var _defaultValues = [];
        $('#table-default-Values div[id="rowIndex_' + indexid + '"]').find(('input[type=text]')).each(function () {
            var value = $(this).val();
            var id = $(this).attr("localeid");
            $(this).next().text(value);
            var item = {};
            item["Value"] = value;
            item["Id"] = id;
            _defaultValues.push(item);
        });
        return _defaultValues;
    };
    Attributes.prototype.ValidationView = function () {
        Attributes.prototype.ShowHideDefaultView();
        var url = "/MediaManager/Attributes/ValidationRule";
        Endpoint.prototype.ValidationView(url, $("#attributeTypeList").val(), function (res) {
            $("#validation-container").html(res);
            $.getScript("/Scripts/References/DynamicValidation.js");
            Attributes.prototype.ParseForm();
        });
        ProductAttribute.prototype.ShowhideFieldForAttributeTypeLink();
        ProductAttribute.prototype.ShowHideIsRequired();
    };
    Attributes.prototype.ShowHideIsRequired = function () {
        var attributetype = $("#attributeTypeList option:selected").text();
        if (attributetype == "Label")
            $("#divIsRequired").hide();
        else
            $("#divIsRequired").show();
    };
    Attributes.prototype.AddNewRow = function (jsonArray) {
        var html = '<tr id="dynamic-row" class="dynamic-row">';
        var _localCount = $("#LocaleCount").val();
        var _defaultValueCount = $("#DefaultValueCount").val();
        _defaultValueCount++;
        html += '<td><div id="code_' + _defaultValueCount + '"><input  name="NewAdded"  id="DefaultValueCode-' + _defaultValueCount + '" type="text" value=""><label style="display: none;"></label> <input type="hidden" id="hdnDefaultvalue_' + _defaultValueCount + '"></div></td>';
        for (var i = 0; i < _localCount; i++) {
            html += '<td><div id="rowIndex_' + _defaultValueCount + '"><input localeid=' + jsonArray[i] + ' name="NewAdded"  id="DefaultValue" type="text" value=""><label style="display: none;"></label></div></td>';
        }
        html += '<td><div id="action_' + _defaultValueCount + '"><a href="#" class="action-save btn-narrow-icon" title="Save"><i class="z-ok"></i></a> <a href= "#" id="delete_' + _defaultValueCount + '" data-toggle="modal" data-target="#MediaDefaultValueDeletePopup" class="action-delete btn-narrow-icon" title= "Delete" > <i class="z-close" > </i></a></div></td>';
        html += '</tr>';
        $("#DefaultValueCount").val(_defaultValueCount);
        $('#table-default-Values tbody:eq(0) tr:last').after(html);
        ProductAttribute.prototype.ScrollToElementById("DefaultValueCode-" + _defaultValueCount, 0);
        Attributes.prototype.BindDefaultValueSaveClick();
    };
    Attributes.prototype.ShowhideFieldForAttributeTypeLink = function () {
        if ($("#attributeTypeList option:selected").text() == "Link") {
            $("#IsRequired").val("false");
            $("#IsConfigurable").val("false");
            $("#IsPersonalizable").val("false");
            $("#IsLocalizable").val("false");
            $("#IsComparable").val("false");
            $("#IsUseInSearch").val("false");
            $("#attributeTypeGroupList option:selected").val("0");
            $("#divIsRequired").hide();
            $("#divAttributConfigurable").hide();
            $("#divAttributPersonalizable").hide();
            $("#divFrontendProperty").hide();
            $("#divAttributGroup").hide();
            $("#divAttributLocalizable").hide();
        }
        else {
            $("#divIsRequired").show();
            $("#divAttributConfigurable").show();
            $("#divAttributPersonalizable").show();
            $("#divFrontendProperty").show();
            $("#divAttributGroup").show();
            $("#divAttributLocalizable").show();
        }
    };
    Attributes.prototype.ShowHideIsAllowMultiUpload = function () {
        $("#divIsAllowMultiUpload").hide();
    };
    Attributes.prototype.ShowHideDefaultView = function () {
        var attributetype = $("#attributeTypeList option:selected").text();
        if (attributetype == "Multi Select" || attributetype == "Simple Select" || attributetype == "Text" || attributetype == "Label") {
            $("#divDefaultAtrributeValue").show();
            (attributetype == "Text" || attributetype == "Label") ? $("#defaultValue-add-new-row").hide() : $("#defaultValue-add-new-row").show();
        }
        else
            $("#divDefaultAtrributeValue").hide();
    };
    Attributes.prototype.DeleteMediaAttribute = function (control) {
        var attributeIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (attributeIds.length > 0) {
            Endpoint.prototype.DeleteMediaAttribute(attributeIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Attributes.prototype.GetInputValidationRuleExpressionValue = function () {
        if ($("#ValidationRule option:selected").text() == "")
            $("#RegularExpression").val("");
        else {
            Endpoint.prototype.GetRegularExpressionValueByRuleName($("#attributeTypeList").val(), $("#ValidationRule option:selected").text(), function (res) {
                $("#RegularExpression").val(res.data);
            });
        }
    };
    Attributes.prototype.AddRequiredValidation = function () {
        ($("#ValidationRule option:selected").text() == "") ? $("#RegularExpression").prop('required', false) : $("#RegularExpression").prop('required', true);
    };
    Attributes.prototype.ValidateDefaultValue = function (indexid) {
        var textboxes = $('#table-default-Values div[id="rowIndex_' + indexid + '"]').find(('input[type=text]'));
        var defaultvalueCode = $('#table-default-Values div[id="code_' + indexid + '"]').find('#DefaultValueCode-' + indexid).val();
        var emptytextboxes = textboxes.filter(function () { return this.value == ""; });
        if (textboxes.length == emptytextboxes.length) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AtleasEnterOnLocale"), "error", false, fadeOutTime);
            return false;
        }
        else if (($("#AttributeId").val() == undefined) || $("#AttributeId").val() == "0") {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("FirstSaveAttribute"), (!($("#AttributeId").val() == undefined)) ? "success" : "error", false, fadeOutTime);
            return false;
        }
        else if (defaultvalueCode.length == 0) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("DefaultvalueCodeCannotBlank"), "error", false, fadeOutTime);
            return false;
        }
        else if (!/^[a-zA-Z0-9_]*$/i.test(defaultvalueCode)) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("OnlyAlphanumericareAllowed"), "error", false, fadeOutTime);
            return false;
        }
        else if (Attributes.prototype.IsDefaultValueCodeExist(defaultvalueCode, $("#hdnDefaultvalue_" + indexid).val()))
            return false;
        else
            return true;
    };
    Attributes.prototype.DeleteDefaultAttributeValue = function (element) {
        var indexid = element.split('_')[1];
        if ($("#hdnDefaultvalue_" + indexid).val() == 0) {
            var textboxes = $('#table-default-Values div[id="rowIndex_' + indexid + '"]').find(('input[type=text]'));
            var emptytextboxes = textboxes.filter(function () { return this.value == ""; });
            var attributetype = $("#attributeTypeList option:selected").text();
            if (textboxes.length == emptytextboxes.length && attributetype == "Text")
                return;
            if (attributetype == "Text") {
                $('#table-default-Values div[id="rowIndex_' + "0" + '"]').find("#DefaultValue").val("");
                $('#table-default-Values div[id="code_' + indexid + '"]').find("#DefaultValueCode-" + indexid).val("");
            }
            else {
                $('#table-default-Values div[id="rowIndex_' + indexid + '"]').closest("#dynamic-row").remove();
                $('#table-default-Values div[id="rowIndex_' + indexid + '"]').remove();
                $('#table-default-Values div[id="action_' + indexid + '"]').remove();
                $('#table-default-Values div[id="code_' + indexid + '"]').remove();
            }
        }
        else {
            Endpoint.prototype.DeleteDefaultValuesMedia($("#hdnDefaultvalue_" + indexid).val(), function (res) {
                if (res != "") {
                    if (res.success == true) {
                        $('#table-default-Values div[id="rowIndex_' + indexid + '"]').closest("#dynamic-row").remove();
                        $('#table-default-Values div[id="rowIndex_' + indexid + '"]').remove();
                        $('#table-default-Values div[id="action_' + indexid + '"]').remove();
                        $('#table-default-Values div[id="code_' + indexid + '"]').remove();
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.statusMessage, "success", false, fadeOutTime);
                    }
                    else
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.statusMessage, "error", false, fadeOutTime);
                }
            });
        }
    };
    Attributes.prototype.ValidationLocale = function (LocaleName) {
        var value = $("#Locale" + LocaleName).val();
        if (value.length > 100) {
            $("#error" + LocaleName).html(ZnodeBase.prototype.getResourceByKeyName("LocaleError"));
            return false;
        }
        else if (value.length > 0 && value.indexOf(',') > -1) {
            $("#error" + LocaleName).html(ZnodeBase.prototype.getResourceByKeyName("ErrorCommaNotAllowed"));
            return false;
        }
        else {
            $("#error" + LocaleName).html("");
            return true;
        }
    };
    Attributes.prototype.ShowhideMaxCharacterforTextArea = function () {
        if ($('input:radio[name*=WYSIWYGEnabledProperty]:checked').val() == 'true') {
            $("#MaxCharacters").val('');
            $('#divMaxCharacters').hide();
        }
        else
            $('#divMaxCharacters').show();
    };
    Attributes.prototype.CheckNegitaveNumberforMinNumber = function (val) {
        if ($("input[name = AllowNegative]:checked").val() == "false") {
            if (isNaN(val)) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMinNumber"));
                $("#errorSpamMinNumber").show();
                return false;
            }
            else if (!isNaN(val) && parseInt(val) < 0) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("NegitaveValueNotAllowed"));
                $("#errorSpamMinNumber").show();
                return false;
            }
            else {
                $("#errorSpamMinNumber").text("");
                return true;
            }
        }
        else {
            $("#errorSpamMinNumber").text("");
            return true;
        }
    };
    Attributes.prototype.CheckNegitaveNumberforMaxNumber = function (val) {
        if ($("input[name = AllowNegative]:checked").val() == "false") {
            if (isNaN(val)) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMaxNumber"));
                $("#errorSpamMaxNumber").show();
                return false;
            }
            else if (!isNaN(val) && parseInt(val) < 0) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("NegitaveValueNotAllowed"));
                $("#errorSpamMaxNumber").show();
                return false;
            }
            else {
                $("#errorSpamMaxNumber").text("");
                return true;
            }
        }
        else {
            $("#errorSpamMaxNumber").text("");
            return true;
        }
    };
    Attributes.prototype.CheckIsDecimalNumberforMinNumber = function (val) {
        if ($("input[name = AllowDecimals]:checked").val() == "false") {
            if (isNaN(val)) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMinNumber"));
                $("#errorSpamMinNumber").show();
                return false;
            }
            else if (!isNaN(val) && Attributes.prototype.IsDecimalExist(val)) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("DeciamlValueNotAllowed"));
                $("#errorSpamMinNumber").show();
                return false;
            }
            else {
                $("#errorSpamMinNumber").text("");
                return true;
            }
        }
        else {
            $("#errorSpamMinNumber").text("");
            return true;
        }
    };
    Attributes.prototype.CheckIsDecimalNumberforMaxNumber = function (val) {
        if ($("input[name = AllowDecimals]:checked").val() == "false") {
            if (isNaN(val)) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMaxNumber"));
                $("#errorSpamMaxNumber").show();
                return false;
            }
            else if (!isNaN(val) && Attributes.prototype.IsDecimalExist(val)) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("DeciamlValueNotAllowed"));
                $("#errorSpamMaxNumber").show();
                return false;
            }
            else {
                $("#errorSpamMaxNumber").text("");
                return true;
            }
        }
        else {
            $("#errorSpamMaxNumber").text("");
            return true;
        }
    };
    Attributes.prototype.IsDecimalExist = function (p_decimalNumber) {
        var l_boolIsExist = true;
        if (p_decimalNumber % 1 == 0)
            l_boolIsExist = false;
        return l_boolIsExist;
    };
    Attributes.prototype.CheckRangeofNumber = function (minval, maxval) {
        if (parseFloat(minval) > parseFloat(maxval)) {
            $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("MaxNumberAlwaysGreaterThanMinNumber"));
            $("#errorSpamMaxNumber").show();
            return false;
        }
        else {
            $("#errorSpamMaxNumber").text("");
            return true;
        }
    };
    Attributes.prototype.CheckNumericValueforMinNumber = function (minval) {
        if (!isNaN(minval) && minval.length <= 12) {
            $("#errorSpamMinNumber").html("");
            return true;
        }
        else {
            $("#errorSpamMinNumber").html(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMinNumber"));
            return false;
        }
    };
    Attributes.prototype.CheckNumericValueforMaxNumber = function (maxval) {
        if (!isNaN(maxval) && maxval.length <= 12) {
            $("#errorSpamMaxNumber").html("");
            return true;
        }
        else {
            $("#errorSpamMaxNumber").html(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMaxNumber"));
            return false;
        }
    };
    Attributes.prototype.ParseForm = function () {
        $("form").removeData("validator");
        $.validator.unobtrusive.parse("form");
    };
    Attributes.prototype.Validate = function () {
        var Locales = [];
        $(".LocaleLabel").each(function () {
            Locales.push($(this).attr('localename'));
        });
        var flag = true;
        for (var i = 0; i < Locales.length; i++) {
            var value = $("#Locale" + Locales[i]).val();
            if (value.length > 100) {
                $("#error" + Locales[i]).html(ZnodeBase.prototype.getResourceByKeyName("LocaleError"));
                flag = false;
            }
            else if (value.length > 0 && value.indexOf(',') > -1) {
                $("#error" + Locales[i]).html(ZnodeBase.prototype.getResourceByKeyName("ErrorCommaNotAllowed"));
                flag = false;
            }
        }
        var minNumber = $("#MinNumber").val();
        var maxNumber = $("#MaxNumber").val();
        if (isNaN(minNumber) && minNumber != undefined) {
            $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMinNumber"));
            $("#errorSpamMinNumber").show();
            flag = false;
        }
        if (Attributes.prototype.IsValidateNumberLength(minNumber)) {
            $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("NumericNumberOutofRang"));
            $("#errorSpamMinNumber").show();
            flag = false;
        }
        if (isNaN(maxNumber) && maxNumber != undefined) {
            $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMaxNumber"));
            $("#errorSpamMaxNumber").show();
            flag = false;
        }
        if (Attributes.prototype.IsValidateNumberLength(maxNumber)) {
            $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("NumericNumberOutofRang"));
            $("#errorSpamMaxNumber").show();
            flag = false;
        }
        if ($("input[name = AllowNegative]:checked").val() == "false") {
            if (isNaN(minNumber)) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMinNumber"));
                $("#errorSpamMinNumber").show();
                flag = false;
            }
            if (!isNaN(minNumber) && parseInt(minNumber) < 0) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("NegitaveValueNotAllowed"));
                $("#errorSpamMinNumber").show();
                flag = false;
            }
        }
        if ($("input[name = AllowNegative]:checked").val() == "false") {
            if (isNaN(maxNumber)) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMaxNumber"));
                $("#errorSpamMaxNumber").show();
                flag = false;
            }
            if (!isNaN(maxNumber) && parseInt(maxNumber) < 0) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("NegitaveValueNotAllowed"));
                $("#errorSpamMaxNumber").show();
                flag = false;
            }
        }
        if ($("input[name = AllowDecimals]:checked").val() == "false") {
            if (isNaN(minNumber)) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMinNumber"));
                $("#errorSpamMinNumber").show();
                flag = false;
            }
            if (!isNaN(minNumber) && Attributes.prototype.IsDecimalExist(minNumber)) {
                $("#errorSpamMinNumber").text(ZnodeBase.prototype.getResourceByKeyName("DeciamlValueNotAllowed"));
                $("#errorSpamMinNumber").show();
                flag = false;
            }
        }
        if ($("input[name = AllowDecimals]:checked").val() == "false") {
            if (isNaN(maxNumber)) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("OnlyNumericallowforMaxNumber"));
                $("#errorSpamMaxNumber").show();
                flag = false;
            }
            if (!isNaN(maxNumber) && Attributes.prototype.IsDecimalExist(maxNumber)) {
                $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("DeciamlValueNotAllowed"));
                $("#errorSpamMaxNumber").show();
                flag = false;
            }
        }
        if (parseFloat(minNumber) > parseFloat(maxNumber)) {
            $("#errorSpamMaxNumber").text(ZnodeBase.prototype.getResourceByKeyName("MaxNumberAlwaysGreaterThanMinNumber"));
            $("#errorSpamMaxNumber").show();
            flag = false;
        }
        if (Attributes.prototype.IsValidateNumberLength($("#MaxCharacters").val())) {
            $("#errorSpamMaxCharacters").text(ZnodeBase.prototype.getResourceByKeyName("NumericNumberOutofRang"));
            $("#errorSpamMaxCharacters").show();
            flag = false;
        }
        var mindate = new Date($("#MinDate").val());
        var maxdate = new Date($("#MaxDate").val());
        if (mindate > maxdate) {
            $("#spamDate").html(ZnodeBase.prototype.getResourceByKeyName("ErrorMindate"));
            flag = false;
        }
        return flag;
    };
    Attributes.prototype.ValidateAttribute = function () {
        return true;
    };
    Attributes.prototype.IsValidateNumberLength = function (val) {
        var isNumeric = false;
        if (val != undefined) {
            if (val.length >= 13)
                isNumeric = true;
        }
        return isNumeric;
    };
    Attributes.prototype.YesNoControlChangeEvent = function () {
        if ($("#attributeTypeList option:selected").text() == "Text Area")
            Attributes.prototype.ShowhideMaxCharacterforTextArea();
        if ($("#attributeTypeList option:selected").text() == "Number") {
            var minnumber = $("#MinNumber").val();
            var maxnumber = $("#MaxNumber").val();
            if (Attributes.prototype.CheckIsDecimalNumberforMinNumber(minnumber))
                if (Attributes.prototype.CheckIsDecimalNumberforMaxNumber(maxnumber))
                    if (Attributes.prototype.CheckNegitaveNumberforMinNumber(minnumber))
                        if (Attributes.prototype.CheckNegitaveNumberforMaxNumber(maxnumber))
                            Attributes.prototype.CheckRangeofNumber(minnumber, maxnumber);
        }
    };
    Attributes.prototype.IsAttributeCodeExist = function () {
        //check for other validations
        var result = Attributes.prototype.Validate();
        if (($("#AttributeId").val() === undefined || $("#AttributeId").val() < 1) && ($('#AttributeCode').val() !== undefined && $('#AttributeCode').val() !== "")) {
            Endpoint.prototype.IsAttributeCodeExist($('#AttributeCode').val(), function (res) {
                if (res.data) {
                    $("#errorSpanAttributeCode").addClass("error-msg");
                    $("#errorSpanAttributeCode").text(ZnodeBase.prototype.getResourceByKeyName("ErrorAttributeCode"));
                    $("#errorSpanAttributeCode").show();
                    result = false;
                }
            });
        }
        return result;
    };
    //Check default value code exiest or not.
    Attributes.prototype.IsDefaultValueCodeExist = function (defaultvalueCode, defaultvalueId) {
        var isExist = false;
        Endpoint.prototype.IsMediaAttributeDefaultValueCodeExist($("#AttributeId").val(), defaultvalueCode, defaultvalueId, function (res) {
            if (res.data) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("DefaultValueCodeAlreadyExist"), 'error', isFadeOut, fadeOutTime);
                isExist = true;
            }
        });
        return isExist;
    };
    return Attributes;
}(ZnodeBase));
//# sourceMappingURL=Attributes.js.map