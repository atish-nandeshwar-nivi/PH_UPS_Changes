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
var startDate;
var endDate;
var ranges;
var ZnodeDateRangePicker = /** @class */ (function (_super) {
    __extends(ZnodeDateRangePicker, _super);
    function ZnodeDateRangePicker() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    ZnodeDateRangePicker.prototype.Init = function (_ranges) {
        ranges = _ranges;
        ZnodeDateRangePicker.prototype.InitDateTimePicker();
        //Event triggered when grid is updated.
        $(document).off("GRID_UPDATED").on("GRID_UPDATED", function () {
            ZnodeDateRangePicker.prototype.InitDateTimePicker();
        });
    };
    ZnodeDateRangePicker.prototype.InitDateTimePicker = function () {
        ZnodeDateRangePicker.prototype.DateRangePicker();
        ZnodeDateRangePicker.prototype.ShowAppliedValueOfFilter();
        ZnodeDateRangePicker.prototype.AppendApplyCancelButtons();
    };
    //To load date range picker dropdown
    ZnodeDateRangePicker.prototype.DateRangePicker = function () {
        try {
            ZnodeDateRangePicker.prototype.SetDatePicketValues();
        }
        catch (e) {
        }
    };
    ZnodeDateRangePicker.prototype.SetDatePicketValues = function () {
        var start = moment().subtract(29, 'days');
        var end = moment();
        var dateTimeFormat = ZnodeDateRangePicker.prototype.GetDefaultDateTimeFormat();
        var selectedFilterCode = ZnodeDateRangePicker.prototype.GetFilterCode();
        //Remove daterangepicker if present
        if ($(".daterangepicker.show-ranges").length > 0)
            $(".daterangepicker.show-ranges").remove();
        function cb(start, end) {
            $('#reportrange span').html(start.format(dateTimeFormat) + ' to ' + end.format(dateTimeFormat));
        }
        $('#reportrange').daterangepicker({
            startDate: (ZnodeDateRangePicker.prototype.IsCustomRange()) ? ZnodeDateRangePicker.prototype.GetStartOrEndDateInDefaultFormat(selectedFilterCode, true) : moment(),
            endDate: (ZnodeDateRangePicker.prototype.IsCustomRange()) ? ZnodeDateRangePicker.prototype.GetStartOrEndDateInDefaultFormat(selectedFilterCode, false) : moment(),
            timePicker: true,
            timePickerSeconds: true,
            autoUpdateInput: false,
            opens: 'left',
            locale: {
                format: dateTimeFormat
            },
            ranges: ranges
        }, cb);
        cb(start, end);
    };
    //Shows the applied filter value on the date time picker input.
    ZnodeDateRangePicker.prototype.ShowAppliedValueOfFilter = function () {
        var selectedFilterCode = ZnodeDateRangePicker.prototype.GetFilterCode();
        var $dateTimeRange = $("#dateTimeRange");
        if (!selectedFilterCode) {
            if (ranges != undefined) {
                if (ranges["All Transactions"] != undefined)
                    $dateTimeRange.val($("li[data-range-code = 'Last_Day']").attr('data-range-key'));
                else if (ranges == undefined || ranges["All Logs"] == undefined)
                    $dateTimeRange.val($("li[data-range-code = 'Last_30_Days']").attr('data-range-key'));
                else
                    $dateTimeRange.val($("li[data-range-code = 'Last_Hour']").attr('data-range-key'));
            }
        }
        else if (ZnodeDateRangePicker.prototype.IsCustomRange())
            $dateTimeRange.val(ZnodeDateRangePicker.prototype.GetStartOrEndDateInDefaultFormat(selectedFilterCode, true) + " - " + ZnodeDateRangePicker.prototype.GetStartOrEndDateInDefaultFormat(selectedFilterCode, false));
        else
            $dateTimeRange.val($("li[data-range-code = '" + selectedFilterCode.trim() + "']").attr('data-range-key'));
    };
    //Appends apply cancel buttons to the date time picker if not present.
    ZnodeDateRangePicker.prototype.AppendApplyCancelButtons = function () {
        if ($("#applyFilter").length == 0) {
            $(".ranges ul").append("<li id = 'addDTPButtons'><button type='button' class='btn-text btn-text-secondary margin-right margin-bottom' id='applyFilter'>Apply</button><button type='button' class='btn-text btn-text-default margin-bottom' id='cancelFilter'>Cancel</button></li>");
        }
    };
    //Gets applied filter code
    ZnodeDateRangePicker.prototype.GetFilterCode = function () {
        return $("#hdnDateTimeRange").attr('selected-filter-value');
    };
    //Returns true if custom range filter is applied on the filter.
    ZnodeDateRangePicker.prototype.IsCustomRange = function () {
        var selectedCode = ZnodeDateRangePicker.prototype.GetFilterCode();
        return (selectedCode.indexOf("to") != -1) ? true : false;
    };
    //Shows or hides apply cancel buttons as required.
    ZnodeDateRangePicker.prototype.ShowHideApplyCancelButtons = function (action) {
        action ? $("#addDTPButtons").show() : $("#addDTPButtons").hide();
    };
    //Shows or hides date time picker as required.
    ZnodeDateRangePicker.prototype.ShowHideDateRangePicker = function (action) {
        action ? $(".daterangepicker").show() : $(".daterangepicker").hide();
    };
    //Submits the search form.
    ZnodeDateRangePicker.prototype.SubmitSearchForm = function () {
        $("#searchform").submit();
    };
    //Adds 'name' attribute to the input field whose value in submitted on form submit.
    ZnodeDateRangePicker.prototype.AddNameToHdnDateTimeRangeField = function () {
        $("#hdnDateTimeRange").attr('name', 'DateTimeRange');
    };
    //Displays the current selected value from dropdown.
    ZnodeDateRangePicker.prototype.ShowCurrentSelectedValueOfFilter = function (currentelement) {
        $(".ranges li").removeClass("active");
        currentelement.addClass("active");
        $("#dateTimeRange").val($("li[data-range-key].active").text());
    };
    //Get default date time format set in the global settings.
    ZnodeDateRangePicker.prototype.GetDefaultDateTimeFormat = function () {
        var dateFormat = $("#hdnDateTimeRange").attr('default-date-format').toUpperCase();
        var timeFormat = $("#hdnDateTimeRange").attr('default-time-format').replace('tt', 'A');
        return dateFormat.concat(' ', timeFormat);
    };
    //Gets start or end date in default format saved in global settings.
    ZnodeDateRangePicker.prototype.GetStartOrEndDateInDefaultFormat = function (dateTime, value) {
        var dates = dateTime.split("to");
        if (value)
            return ZnodeDateRangePicker.prototype.ChangeStringDateTimeFormat(dates[0].toString().trim());
        else
            return ZnodeDateRangePicker.prototype.ChangeStringDateTimeFormat(dates[1].toString().trim());
    };
    //Change date time string of one format to default format.
    ZnodeDateRangePicker.prototype.ChangeStringDateTimeFormat = function (dateTime) {
        var defaultDateTimeFormat = ZnodeDateRangePicker.prototype.GetDefaultDateTimeFormat();
        return moment(dateTime, defaultDateTimeFormat).format(defaultDateTimeFormat);
    };
    //Shows or hides date time calendar as required.
    ZnodeDateRangePicker.prototype.ShowHideCalendar = function (action) {
        if (action) {
            $(".drp-calendar").css("display", "block");
            $(".drp-buttons").css("display", "block");
            ZnodeDateRangePicker.prototype.ShowHideApplyCancelButtons(false);
        }
        else {
            $(".drp-calendar").css("display", "none");
            $(".drp-buttons").css("display", "none");
            ZnodeDateRangePicker.prototype.ShowHideApplyCancelButtons(true);
        }
    };
    //Adds active class to applied filter option.
    ZnodeDateRangePicker.prototype.HighlightAppliedFilterOption = function (filterOption) {
        $(".ranges li").removeClass("active");
        filterOption == "Custom Range" ? $("li[data-range-key = '" + filterOption + "']").addClass("active") : $("li[data-range-code = " + filterOption + "]").addClass("active");
    };
    return ZnodeDateRangePicker;
}(ZnodeBase));
//Event triggered on click of dropdown options of the date time picker.
$(document).off("click", "li[data-range-key]").on("click", "li[data-range-key]", function (e) {
    var currentelement = $(this);
    ZnodeDateRangePicker.prototype.ShowHideDateRangePicker(true);
    ZnodeDateRangePicker.prototype.ShowCurrentSelectedValueOfFilter(currentelement);
    if (currentelement && currentelement.attr('data-range-key') != 'Custom Range')
        ZnodeDateRangePicker.prototype.ShowHideCalendar(false);
    else
        ZnodeDateRangePicker.prototype.ShowHideCalendar(true);
});
//Event triggered on click of the date time picker.
$(document).off("click", "#reportrange").on("click", "#reportrange", function (e) {
    $(".daterangepicker.show-ranges").css("display", "block");
    ZnodeDateRangePicker.prototype.ShowAppliedValueOfFilter();
    var selectedFilterCode = $("#hdnDateTimeRange").attr('selected-filter-value');
    if (!selectedFilterCode) {
        if (ranges["All Transactions"] != undefined)
            ZnodeDateRangePicker.prototype.HighlightAppliedFilterOption("Last_Day");
        else if (ranges == undefined || ranges["All Logs"] == undefined)
            ZnodeDateRangePicker.prototype.HighlightAppliedFilterOption("Last_30_Days");
        else
            ZnodeDateRangePicker.prototype.HighlightAppliedFilterOption("Last_Hour");
        ZnodeDateRangePicker.prototype.ShowHideCalendar(false);
    }
    else if ($("li[data-range-code = '" + selectedFilterCode.trim() + "']").length == 0) {
        ZnodeDateRangePicker.prototype.HighlightAppliedFilterOption("Custom Range");
        ZnodeDateRangePicker.prototype.ShowHideCalendar(true);
    }
    else {
        ZnodeDateRangePicker.prototype.HighlightAppliedFilterOption(selectedFilterCode.trim());
        ZnodeDateRangePicker.prototype.ShowHideCalendar(false);
    }
});
//Event triggered on click of apply button of the date time picker.
$(document).off("click", "#applyFilter").on("click", "#applyFilter", function (e) {
    ZnodeDateRangePicker.prototype.ShowHideDateRangePicker(false);
    $("#dateTimeRange").val($("li[data-range-key].active").text());
    $("#hdnDateTimeRange").val($("li[data-range-key].active").attr('data-range-code'));
    ZnodeDateRangePicker.prototype.AddNameToHdnDateTimeRangeField();
    ZnodeDateRangePicker.prototype.SubmitSearchForm();
});
//Event triggered on click of apply button in the case of custom range.
$(document).off("click", ".applyBtn").on("click", ".applyBtn", function (e) {
    $("#dateTimeRange").val($('.drp-selected').first().text());
    $("#hdnDateTimeRange").val($('#reportrange').text().trim());
    ZnodeDateRangePicker.prototype.AddNameToHdnDateTimeRangeField();
    ZnodeDateRangePicker.prototype.ShowHideDateRangePicker(false);
    ZnodeDateRangePicker.prototype.SubmitSearchForm();
});
//Event triggered on click of cancel button of the date time picker.
$(document).off("click", "#cancelFilter").on("click", "#cancelFilter", function (e) {
    ZnodeDateRangePicker.prototype.ShowHideDateRangePicker(false);
    ZnodeDateRangePicker.prototype.ShowAppliedValueOfFilter();
});
//Event triggered on click of cancel button in the case of custom range.
$(document).off("click", ".cancelBtn").on("click", ".cancelBtn", function (e) {
    ZnodeDateRangePicker.prototype.ShowHideDateRangePicker(false);
    ZnodeDateRangePicker.prototype.ShowAppliedValueOfFilter();
});
//Hide the date-time picker on outside click.
$(document).mouseup(function (e) {
    var container = $(".daterangepicker");
    // if the target of the click isn't the container or its descendant, hide the container.
    if (!container.is(e.target) && container.has(e.target).length === 0) {
        container.hide();
        ZnodeDateRangePicker.prototype.ShowAppliedValueOfFilter();
    }
});
//# sourceMappingURL=ZnodeDateRangePicker.js.map