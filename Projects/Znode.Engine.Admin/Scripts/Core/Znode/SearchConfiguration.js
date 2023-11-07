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
var boostValues = new Array();
var SearchConfiguration = /** @class */ (function (_super) {
    __extends(SearchConfiguration, _super);
    function SearchConfiguration() {
        var _this = _super.call(this) || this;
        _this._endpoint = new Endpoint();
        return _this;
    }
    SearchConfiguration.prototype.Init = function () {
        SearchConfiguration.prototype.GetSearchIndexMonitorList();
        SearchConfiguration.prototype.ValidateIndexName();
    };
    SearchConfiguration.prototype.GetProductBoostValuesByCatalogId = function () {
        $(".groupPannel").removeClass("tab-selected");
        $("#lnkProductBoostList").parent("li").addClass("tab-selected");
        $("#createIndexSection").html("");
        var catalogId = $("#hdnPublishCatalogId").val();
        Endpoint.prototype.GetProductBoostSetting(catalogId, function (response) {
            $("#BoostSetting").html(response);
        });
    };
    SearchConfiguration.prototype.GetCategoryProductBoostValuesByCatalogId = function () {
        $(".groupPannel").removeClass("tab-selected");
        $("#lnkCategoryBoostList").parent("li").addClass("tab-selected");
        $("#createIndexSection").html("");
        var catalogId = $("#hdnPublishCatalogId").val();
        Endpoint.prototype.GetProductCategoryBoostSetting(catalogId, function (response) {
            $("#BoostSetting").html(response);
        });
    };
    SearchConfiguration.prototype.GetFieldBoostValuesByCatalogId = function () {
        $(".groupPannel").removeClass("tab-selected");
        $("#lnkFieldBoostList").parent("li").addClass("tab-selected");
        $("#createIndexSection").html("");
        var catalogId = $("#hdnPublishCatalogId").val();
        Endpoint.prototype.GetFieldBoostSetting(catalogId, function (response) {
            $("#BoostSetting").html(response);
        });
    };
    SearchConfiguration.prototype.GetStoreSearchConfigurations = function () {
        $("#BoostSetting").html("");
        $(".groupPannel").removeClass("active");
        $("#lnkSearchProfileList").removeClass("active");
        $("#lnkKeywordsRedirectList").removeClass("active");
        $("#lnkSynonymsList").removeClass("active");
        $("#lnkCreateIndex").parent("li").addClass("active");
        var publishCatalogId = $("#hdnPublishCatalogId").val();
        Endpoint.prototype.GetSearchConfiguration(publishCatalogId, $('#txtCatalogName').val(), function (response) {
            $("#divCreateIndex").html(response);
            $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
            SearchConfiguration.prototype.SetFastSelectFilter("publishcatalogid", publishCatalogId);
            SearchConfiguration.prototype.SubmitFormOnFastSelection();
            SearchConfiguration.prototype.UpdateFastSelectAfterGridUpdate();
        });
    };
    SearchConfiguration.prototype.GetSearchProfiles = function () {
        //$(".groupPannel").removeClass("tab-selected")
        //$("#lnkSearchProfileList").parent("li").addClass("tab-selected")
        $("#BoostSetting").html("");
        $("#createIndexSection").html("");
        Endpoint.prototype.GetSearchProfiles(function (response) {
            $("#ZnodeSearchProfileAttribute").html(response);
            $(".groupPannel").removeClass("tab-selected");
            $("#lnkSearchProfileList").parent("li").addClass("tab-selected");
        });
    };
    SearchConfiguration.prototype.GetSearchFacets = function () {
        $(".groupPannel").removeClass("tab-selected");
        $("#lnkSearchFacetsList").parent("li").addClass("tab-selected");
        $("#BoostSetting").html("");
        Endpoint.prototype.GetAssociatedCatalogAttributes(function (response) {
            $("#createIndexSection").html(response);
        });
    };
    SearchConfiguration.prototype.GetSearchIndexMonitorList = function () {
        if ($("#HasError").val() == "True")
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper($("#ErrorMessage").val(), 'error', isFadeOut, fadeOutTime);
        var catalogIndexId = $("#CatalogIndexId").val();
        if (catalogIndexId != undefined) {
            Endpoint.prototype.GetSearchIndexMonitorList(catalogIndexId, function (response) {
                $("#searchIndexMonitorList").html("");
                $("#searchIndexMonitorList").html(response);
                $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
            });
        }
    };
    SearchConfiguration.prototype.GetSearchIndexServerStatusList = function (searchIndexMonitorId) {
        Endpoint.prototype.GetSearchIndexMonitorList(searchIndexMonitorId, function (response) {
            $("#searchIndexMonitorList").html("");
            $("#searchIndexMonitorList").html(response);
        });
    };
    SearchConfiguration.prototype.ViewServerStatus = function (zViewAnchor) {
        zViewAnchor.attr("href", "#");
        var indexMonitorId = $($(zViewAnchor[0]).closest("tr").find("td")[0]).html();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/SearchConfiguration/GetSearchIndexServerStatusList?searchIndexMonitorId=' + indexMonitorId, 'divSearchIndexServerStatusList');
    };
    SearchConfiguration.prototype.GetCreateIndexSchedulerView = function () {
        $("#createSchedulerError").hide();
        if (parseInt($("#CatalogIndexId").val(), 10) > 0) {
            var footer = "<button type='button' class='popup-panel-close' onclick='ZnodeBase.prototype.CancelUpload('divCreateScheduler')'><i class='z-close'></i></button>";
            ZnodeBase.prototype.ShowLoader();
            var catalogId = $("#hdnPublishCatalogId").val();
            var url = "/TouchPointConfiguration/Create?ConnectorTouchPoints=createIndex_" + $("#IndexName").val() + "&indexName=" + $("#IndexName").val() + "&schedulerCallFor=Indexer&catalogId=" + catalogId + "&catalogIndexId=" + parseInt($("#CatalogIndexId").val(), 10);
            Endpoint.prototype.GetPartial(url, function (response) {
                var htmlContent = footer + response;
                $("#divCreateScheduler").html(htmlContent);
                $($("#divCreateScheduler").find("a.grey")).attr("href", "#");
                $($("#divCreateScheduler").find("a.grey")).attr("onclick", "ZnodeBase.prototype.CancelUpload('divCreateScheduler')");
                $("#divCreateScheduler").show();
                $("body").append("<div class='modal-backdrop fade in'></div>");
                ZnodeBase.prototype.HideLoader();
            });
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper("Please create index before creating scheduler.", 'error', isFadeOut, fadeOutTime);
        }
    };
    SearchConfiguration.prototype.CreateScheduler = function () {
        var isValid = SearchConfiguration.prototype.ValidateSchedulerData();
        var schedulerName = $("#SchedulerName").val();
        if (isValid) {
            var erpTaskSchedulerViewModel = {
                "ERPTaskSchedulerId": $("#ERPTaskSchedulerId").val(),
                "IndexName": $("#IndexName").val(),
                "IsEnabled": $("[id=IsActive]:checked").val(),
                "SchedulerCallFor": $("#SchedulerCallFor").val(),
                "PortalId": $("#PortalId").val(),
                "CatalogId": $("#CatalogId").val(),
                "CatalogIndexId": $("#CatalogIndexId").val(),
                "SchedulerFrequency": $('[name=SchedulerFrequency]:checked').val(),
                "SchedulerName": $("#SchedulerName").val(),
                "StartDate": $("#StartDate").val(),
                "StartTime": $("#StartTime").val(),
                "TouchPointName": $("#TouchPointName").val(),
                "CronExpression": $("#txtCronExpression").val(),
                "HangfireJobId": $("#HangfireJobId").val()
            };
            if (parseInt($("#ERPTaskSchedulerId").val(), 10) > 0) {
                Endpoint.prototype.EditSearchScheduler(erpTaskSchedulerViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SearchSchedulerUpdatedSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divCreateScheduler');
                    }
                    else {
                        $("#createSchedulerError").text(response.message);
                        $("#createSchedulerError").show();
                    }
                });
            }
            else {
                Endpoint.prototype.CreateSearchScheduler(erpTaskSchedulerViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SearchSchedulerCreatedSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divCreateScheduler');
                        $("#schedulerNameText").val(schedulerName);
                        $("#schedulerName").removeClass("hidden");
                        $("#schedulerLabel").html("");
                        $(".createScheduler").html("");
                        $(".createScheduler").html("<i class='z-add-circle'></i>" + ZnodeBase.prototype.getResourceByKeyName("UpdateScheduler"));
                        $("#searchScheduler").val(ZnodeBase.prototype.getResourceByKeyName("EditScheduler"));
                    }
                    else {
                        $("#createSchedulerError").text(response.message);
                        $("#createSchedulerError").show();
                    }
                });
            }
        }
    };
    SearchConfiguration.prototype.ValidateSchedulerData = function () {
        var isValid = true;
        //Validate SchedulerName
        isValid = SearchConfiguration.prototype.ValidateSchedulerName() && isValid;
        //Validate TouchPointName
        isValid = SearchConfiguration.prototype.ValidateTouchpointName() && isValid;
        if ($('[name=SchedulerFrequency]:checked').val() == "OneTime") {
            //Validate StartDate
            if ($("#StartDate").val() == "" || $("#StartDate").val().length < 1 || $("#StartDate").val() == null) {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorStartDateRequired"), $("#StartDate"), $("#valStartDate"));
                isValid = isValid && false;
            }
            else {
                Products.prototype.HideErrorMessage($("#StartDate"), $("#valStartDate"));
            }
            //Validate StartTime
            if ($("#StartTime").val() == "" || $("#StartTime").val().length < 1 || $("#StartTime").val() == null) {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorStartTimeRequired"), $("#StartTime"), $("#valStartTime"));
                isValid = isValid && false;
            }
            else {
                Products.prototype.HideErrorMessage($("#StartTime"), $("#valStartTime"));
            }
        }
        else {
            if ($("#txtCronExpression").val() == "" || $("#txtCronExpression").val().length < 1 || $("#txtCronExpression").val() == null) {
                Products.prototype.ShowErrorMessage("Enter a valid cron expression", $("#txtCronExpression"), $("#valCronExpression"));
                isValid = isValid && false;
            }
            else {
                Products.prototype.HideErrorMessage($("#txtCronExpression"), $("#valCronExpression"));
            }
        }
        return isValid;
    };
    SearchConfiguration.prototype.ValidateSchedulerName = function () {
        if ($("#SchedulerName").val() == "" || $("#SchedulerName").val().length < 1 || $("#SchedulerName").val() == null) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorSchedulerNameRequired"), $("#SchedulerName"), $("#valSchedulerName"));
            return false;
        }
        else {
            Products.prototype.HideErrorMessage($("#SchedulerName"), $("#valSchedulerName"));
        }
        if ($("#SchedulerName").val().length > 100) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorSchedulerNameLength"), $("#SchedulerName"), $("#valSchedulerName"));
            return false;
        }
        else {
            Products.prototype.HideErrorMessage($("#SchedulerName"), $("#valSchedulerName"));
        }
        var regexp = new RegExp('^[A-Za-z][a-zA-Z0-9]*$');
        if (!regexp.test($("#SchedulerName").val())) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("AlphanumericStartWithAlphabet"), $("#SchedulerName"), $("#valSchedulerName"));
            return false;
        }
        else {
            Products.prototype.HideErrorMessage($("#SchedulerName"), $("#valSchedulerName"));
        }
        return true;
    };
    SearchConfiguration.prototype.ValidateTouchpointName = function () {
        if ($("#TouchPointName").val() == "" || $("#TouchPointName").val().length < 1 || $("#TouchPointName").val() == null) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("TouchPointNameRequired"), $("#TouchPointName"), $("#valTouchPointName"));
            return false;
        }
        else {
            Products.prototype.HideErrorMessage($("#TouchPointName"), $("#valTouchPointName"));
        }
        if ($("#TouchPointName").val().length > 100) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorTouchPointNameLength"), $("#TouchPointName"), $("#valTouchPointName"));
            return false;
        }
        else {
            Products.prototype.HideErrorMessage($("#TouchPointName"), $("#valTouchPointName"));
        }
        return true;
    };
    SearchConfiguration.prototype.ValidateBoostField = function (object) {
        var isValid = true;
        if (isNaN($(object).val())) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("InvalidBoostValue"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else if ($(object).val() > 999999) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorBoostValue"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    //This method is used to get portal list on aside panel.
    SearchConfiguration.prototype.GetPortalList = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/SearchConfiguration/GetPortalList', 'divStoreListAsidePanel');
    };
    //This method is used to select catalog from fast select and show it on textbox
    SearchConfiguration.prototype.OnSelectPubCatalogDataBind = function (item) {
        Store.prototype.OnSelectPubCatalogAutocompleteDataBind(item);
        if ($("#SearchConfigurationType").val() == "CreateIndex")
            SearchConfiguration.prototype.GetStoreSearchConfigurations();
        else {
            var selectedTab_1 = $('#SelectedTab').val();
            if (selectedTab_1 != undefined && selectedTab_1 != "") {
                switch (selectedTab_1) {
                    case "GetGlobalProductCategoryBoost":
                        SearchConfiguration.prototype.GetCategoryProductBoostValuesByCatalogId();
                        break;
                    case "GetFieldLevelBoost":
                        SearchConfiguration.prototype.GetFieldBoostValuesByCatalogId();
                        break;
                    case "GetGlobalProductBoost":
                        SearchConfiguration.prototype.GetProductBoostValuesByCatalogId();
                        break;
                    case "GetSearchSynonymsList":
                        SearchConfiguration.prototype.GetSynonymsByCatalogId();
                        break;
                    case "GetCatalogKeywordsList":
                        SearchConfiguration.prototype.GetKeywordsRedirectByCatalogId();
                        break;
                    case "GetSearchProfilesList":
                        SearchConfiguration.prototype.GetSearchProfilesByCatalogId();
                        break;
                }
            }
        }
        ZnodeBase.prototype.RemovePopupOverlay();
    };
    //This method is used to select portal from list and show it on textbox.
    SearchConfiguration.prototype.GetCatalogDetails = function () {
        $("#ZnodeStoreCatalog").find("tr").click(function () {
            var catalogName = $(this).find("td[class='catalogcolumn']").text();
            var publishCatalogId = $(this).find("td")[0].innerHTML;
            $('#txtCatalogName').val(catalogName);
            $('#hdnPublishCatalogId').val(publishCatalogId);
            if ($("#SearchConfigurationType").val() == "CreateIndex")
                SearchConfiguration.prototype.GetStoreSearchConfigurations();
            else {
                var selectedTab_2 = $('#SelectedTab').val();
                if (selectedTab_2 != undefined && selectedTab_2 != "") {
                    switch (selectedTab_2) {
                        case "GetGlobalProductCategoryBoost":
                            SearchConfiguration.prototype.GetCategoryProductBoostValuesByCatalogId();
                            break;
                        case "GetFieldLevelBoost":
                            SearchConfiguration.prototype.GetFieldBoostValuesByCatalogId();
                            break;
                        case "GetGlobalProductBoost":
                            SearchConfiguration.prototype.GetProductBoostValuesByCatalogId();
                            break;
                        case "GetSearchSynonymsList":
                            SearchConfiguration.prototype.GetSynonymsByCatalogId();
                            break;
                        case "GetCatalogKeywordsList":
                            SearchConfiguration.prototype.GetKeywordsRedirectByCatalogId();
                            break;
                    }
                }
            }
            $("#errorRequiredCatalog").text("").removeClass("field-validation-error").hide();
            $("#txtCatalogName").removeClass('input-validation-error');
            $('#divCataloglistPopup').hide(700);
            ZnodeBase.prototype.RemovePopupOverlay();
        });
    };
    //To get the search profiles list when any selection is made from fast select control.
    SearchConfiguration.prototype.GetSearchProfilesByCatalogId = function () {
        $(".groupPannel").removeClass("active");
        $("#lnkCreateIndex").removeClass("active");
        $("#lnkSynonymsList").removeClass("active");
        $("#lnkKeywordsRedirectList").removeClass("active");
        $("#lnkSearchProfileList").parent("li").addClass("active");
        SearchConfiguration.prototype.SetFastSelectFilter("publishcatalogid", $("#hdnPublishCatalogId").val());
        SearchConfiguration.prototype.SubmitFormOnFastSelection();
    };
    //To set filters related to fast select control present on _FilterComponent.cshtml page.
    SearchConfiguration.prototype.SetFastSelectFilter = function (filterName, filterValue) {
        $("#fastSelectFilterName").attr({
            "name": filterName,
            "value": filterValue
        });
        $("#fastSelectFilterOperator").attr({
            "name": "DataOperatorId",
            "value": "1"
        });
    };
    //To submit the form when any selection is made from fast select control.
    SearchConfiguration.prototype.SubmitFormOnFastSelection = function () {
        UpdateContainerId = $("#fastSelectFilterName").closest('form').attr('data-ajax-update').replace("#", "");
        $("#fastSelectFilterName").closest("form").submit();
    };
    //Event triggered when grid is updated.
    SearchConfiguration.prototype.UpdateFastSelectAfterGridUpdate = function () {
        $(document).off("GRID_UPDATED").on("GRID_UPDATED", function () {
            $("#txtCatalogName").val($("#hdnPublishCatalogName").val());
        });
    };
    //Event triggered when grid is updated.
    SearchConfiguration.prototype.UpdateSearchFastSelectAfterGridUpdate = function () {
        $(document).off("GRID_UPDATED").on("GRID_UPDATED", function () {
            var publishCatalogId = $("#PublishCatalogId").val();
            var searchMonitorPublishCatalogId = $("#hdnSearchMonitorPublishCatalogId").val();
            if (publishCatalogId != searchMonitorPublishCatalogId) {
                Endpoint.prototype.GetSearchConfiguration(searchMonitorPublishCatalogId, $('#txtCatalogName').val(), function (response) {
                    $("#divCreateIndex").html(response);
                    $("#txtCatalogName").val($("#hdnPublishCatalogName").val());
                    $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
                });
            }
        });
    };
    SearchConfiguration.prototype.GetSynonymsByCatalogId = function () {
        $("#createIndexSection").html("");
        $(".groupPannel").removeClass("active");
        $("#lnkCreateIndex").removeClass("active");
        $("#lnkSearchProfileList").removeClass("active");
        $("#lnkKeywordsRedirectList").removeClass("active");
        $("#lnkSynonymsList").parent("li").addClass("active");
        SearchConfiguration.prototype.SetFastSelectFilter("publishcatalogid", $("#hdnPublishCatalogId").val());
        SearchConfiguration.prototype.SubmitFormOnFastSelection();
    };
    SearchConfiguration.prototype.GetKeywordsRedirectByCatalogId = function () {
        $("#createIndexSection").html("");
        $(".groupPannel").removeClass("active");
        $("#lnkCreateIndex").removeClass("active");
        $("#lnkSearchProfileList").removeClass("active");
        $("#lnkSynonymsList").removeClass("active");
        $("#lnkKeywordsRedirectList").parent("li").addClass("active");
        SearchConfiguration.prototype.SetFastSelectFilter("publishcatalogid", $("#hdnPublishCatalogId").val());
        SearchConfiguration.prototype.SubmitFormOnFastSelection();
    };
    SearchConfiguration.prototype.SetLinkParamter = function (control) {
        var catalogId = $("#publishCatalogId").val();
        var catalogName = $("#catalogName").val();
        var href = $(control).attr("href");
        if (catalogId != undefined && catalogName != undefined) {
            var encodedCatalogName = encodeURIComponent(catalogName);
            $(control).attr("href", href + "?catalogId=" + catalogId + "&catalogName=" + encodedCatalogName);
        }
    };
    SearchConfiguration.prototype.GetAddSynonymsView = function (zViewAnchor) {
        zViewAnchor.attr("href", "#");
        var searchSynonymsId = decodeURIComponent($(zViewAnchor).attr("data-parameter")).split('&')[0].split('=')[1];
        ZnodeBase.prototype.BrowseAsidePoupPanel('/SearchConfiguration/EditSearchSynonyms?searchSynonymsId=' + searchSynonymsId, 'divAddSynonymsPopup');
    };
    SearchConfiguration.prototype.CreateSynonyms = function () {
        var originalTerms = $("#frmCreateEditSynonyms input[name=OriginalTerm]").val().replaceAll(',', '|');
        var replaceByTerms = $("#frmCreateEditSynonyms input[name=ReplacedBy]").val().replaceAll(',', '|');
        var synonymCode = $("#frmCreateEditSynonyms input[name=SynonymCode]").val().replaceAll(',', '|');
        if (SearchConfiguration.prototype.ValidateSynonymsForm(originalTerms, replaceByTerms, synonymCode)) {
            var SearchSynonymsId = $("#frmCreateEditSynonyms input[name=SearchSynonymsId]").val();
            var synonymsViewModel = {
                "SearchSynonymsId": SearchSynonymsId,
                "PublishCatalogId": $("#PublishCatalogId").val(),
                "OriginalTerm": $("#frmCreateEditSynonyms input[name=OriginalTerm]").val(),
                "ReplacedBy": $("#frmCreateEditSynonyms input[name=ReplacedBy]").val(),
                "IsBidirectional": $("#frmCreateEditSynonyms [id=IsBidirectional]:checked").val(),
                "SynonymCode": $("#frmCreateEditSynonyms input[name=SynonymCode]").val(),
            };
            if (SearchSynonymsId > 0) {
                Endpoint.prototype.EditSynonyms(synonymsViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RecordUpdatededSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divAddSynonymsPopup');
                        SearchConfiguration.prototype.GetSynonymsByCatalogId();
                    }
                    else {
                        $("#CreateSynonymsError").text(response.message);
                        $("#CreateSynonymsError").show();
                    }
                });
            }
            else {
                Endpoint.prototype.AddSynonyms(synonymsViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RecordCreatedSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divAddSynonymsPopup');
                        SearchConfiguration.prototype.GetSynonymsByCatalogId();
                    }
                    else {
                        $("#CreateSynonymsError").text("Failed");
                        $("#CreateSynonymsError").show();
                    }
                });
            }
        }
    };
    SearchConfiguration.prototype.ValidateSynonymsForm = function (originalTerms, replaceByTerms, synonymCode) {
        var hasError = false;
        if (synonymCode !== undefined && synonymCode == "") {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorSynonymCode"), $("#SynonymCode"), $("#valSynonymCode"));
            hasError = true;
        }
        if (originalTerms !== undefined && originalTerms == "") {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorOriginalTerm"), $("#OriginalTerm").siblings('div'), $("#valOriginalTerm"));
            hasError = true;
        }
        if (replaceByTerms !== undefined && replaceByTerms == "") {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorReplacedTerm"), $("#ReplacedBy").siblings('div'), $("#valReplacedBy"));
            hasError = true;
        }
        if (!hasError)
            return SearchConfiguration.prototype.ValidateMessage();
    };
    SearchConfiguration.prototype.RemoveSynonymsOriginalTermValidation = function () {
        var originalTerms = $("#OriginalTerm").val();
        if (originalTerms !== undefined && originalTerms !== "")
            Products.prototype.HideErrorMessage($("#OriginalTerm").siblings('div'), $("#valOriginalTerm"));
    };
    SearchConfiguration.prototype.RemoveSynonymsReplacedByTermValidation = function () {
        var replaceByTerms = $("#ReplacedBy").val();
        if (replaceByTerms !== undefined && replaceByTerms !== "")
            Products.prototype.HideErrorMessage($("#ReplacedBy").siblings('div'), $("#valReplacedBy"));
    };
    SearchConfiguration.prototype.DeleteSearchSynonyms = function (control) {
        var searchSynonymsId = DynamicGrid.prototype.GetMultipleSelectedIds();
        var catalogId = $("#hdnPublishCatalogId").val();
        if (searchSynonymsId.length > 0) {
            Endpoint.prototype.DeleteSearchSynonyms(searchSynonymsId, catalogId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    SearchConfiguration.prototype.DeleteKeywords = function (control) {
        var searchKeywordsRedirectId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (searchKeywordsRedirectId.length > 0) {
            Endpoint.prototype.DeleteKeywords(searchKeywordsRedirectId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    SearchConfiguration.prototype.CreateKeywordsRedirect = function () {
        var keywords = $("#frmCreateEditKeywords input[name=Keywords]").val();
        var url = $("#frmCreateEditKeywords input[name=URL]").val();
        if (SearchConfiguration.prototype.ValidateKeywordsForm(keywords, url)) {
            var SearchKeywordsRedirectId = $("#frmCreateEditKeywords input[name=SearchKeywordsRedirectId]").val();
            var keywordsViewModel = {
                "SearchKeywordsRedirectId": SearchKeywordsRedirectId,
                "PublishCatalogId": $("#PublishCatalogId").val(),
                "Keywords": $("#frmCreateEditKeywords input[name=Keywords]").val(),
                "URL": $("#frmCreateEditKeywords input[name=URL]").val(),
            };
            if (SearchKeywordsRedirectId > 0) {
                Endpoint.prototype.EditKeywords(keywordsViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RecordUpdatededSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divAddKeywordsPopup');
                        SearchConfiguration.prototype.GetKeywordsRedirectByCatalogId();
                    }
                    else {
                        $("#CreateKeywordsError").text(response.message);
                        $("#CreateKeywordsError").show();
                    }
                });
            }
            else {
                Endpoint.prototype.AddKeywords(keywordsViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RecordCreatedSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divAddKeywordsPopup');
                        SearchConfiguration.prototype.GetKeywordsRedirectByCatalogId();
                    }
                    else {
                        $("#CreateKeywordsError").text("Failed");
                        $("#CreateKeywordsError").show();
                    }
                });
            }
        }
    };
    SearchConfiguration.prototype.ValidateKeywordsForm = function (keywords, url) {
        if (keywords == "" && url == "") {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorKeywordsTerm"), $("#Keywords"), $("#valKeywords"));
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorURLTerm"), $("#URL"), $("#valURL"));
            return false;
        }
        else if (keywords == "") {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorKeywordsTerm"), $("#Keywords"), $("#valKeywords"));
            return false;
        }
        else if (url == "") {
            $("#valKeywords").html("");
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorURLTerm"), $("#URL"), $("#valURL"));
            return false;
        }
        if (url != "") {
            var URLs = url.split(",");
            if (URLs.length > 1) {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorMultipleURL"), $("#URL"), $("#valURL"));
                return false;
            }
        }
        if (url != "") {
            if (url.match("^/")) {
                return true;
            }
            var regexp = new RegExp('^([a-zA-Z0-9]+)$|^((https|http|www)\\:\\/\\/[a-zA-Z0-9_\\-/]+(?:\\.[a-zA-Z0-9_\\-/]+)*)$');
            var isValidUrl = regexp.test(url);
            if (!isValidUrl) {
                Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("ErrorInvalidUrl"), $("#URL"), $("#valURL"));
                return false;
            }
        }
        return true;
    };
    SearchConfiguration.prototype.GetAddKeywordsView = function (zViewAnchor) {
        zViewAnchor.attr("href", "#");
        var searchKeywordsRedirectId = decodeURIComponent($(zViewAnchor).attr("data-parameter")).split('&')[0].split('=')[1];
        ZnodeBase.prototype.BrowseAsidePoupPanel('/SearchConfiguration/EditSearchKeywordsRedirect?searchKeywordsRedirectId=' + searchKeywordsRedirectId, 'divAddKeywordsPopup');
    };
    SearchConfiguration.prototype.WriteSearchFile = function (isSynonymsFile) {
        var catalogId = $("#hdnPublishCatalogId").val();
        Endpoint.prototype.WriteSynonymsFile(catalogId, isSynonymsFile, function (response) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            $('#btnToggle').click();
        });
    };
    SearchConfiguration.prototype.DeleteIndex = function () {
        var catalogIndexId = $("#CatalogIndexId").val();
        Endpoint.prototype.DeleteIndex(catalogIndexId, function (response) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
        });
    };
    SearchConfiguration.prototype.RevisionTypePopUp = function () {
        if (SearchConfiguration.prototype.ValidateIndexName()) {
            $("#errorSpanIndexName").removeClass("error-msg");
            if ($('#radBtnPublishState').length > 0)
                $("#PortalIndexPopup").modal('show');
            else
                $("#frmCreateIndexData").submit();
        }
    };
    SearchConfiguration.prototype.CreateIndexSection = function () {
        var publishStateData = 'NONE';
        if ($('#radBtnPublishState').length > 0) {
            publishStateData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
            $("#RevisionType").val(publishStateData);
            $("#frmCreateIndexData").submit();
            $('.modal-backdrop').removeClass('modal-backdrop');
        }
    };
    SearchConfiguration.prototype.ValidateIndexName = function () {
        var indexName = $("#frmCreateIndexData").find("input[name*='IndexName']").val();
        return SearchConfiguration.prototype.ValidateIndexPattern("frmCreateIndexData", indexName);
    };
    // this method validates an index pattern.
    SearchConfiguration.prototype.ValidateIndexPattern = function (formID, indexName) {
        var pattern1 = new RegExp('[?!^#/*?<>..|.,"]');
        var pattern2 = new RegExp('/[a-z0-9]{1,255}/g');
        var isValid = true;
        if (indexName != undefined) {
            if (indexName.match(pattern1) || (indexName.match(/\s/g)) || (indexName.match(pattern2)) || (indexName.match(/\\/g))) {
                SearchConfiguration.prototype.ErrorMessageNotification(formID);
                return false;
            }
            else if (indexName.indexOf("-", 0) === 0 || indexName.indexOf("_", 0) === 0 || indexName.indexOf("+", 0) === 0) {
                SearchConfiguration.prototype.ErrorMessageNotification(formID);
                return false;
            }
            if (indexName.match(/[A-Z]/g)) {
                SearchConfiguration.prototype.ErrorMessageNotification(formID);
                return false;
            }
        }
        return true;
    };
    SearchConfiguration.prototype.ErrorMessageNotification = function (formId) {
        $("#" + formId).find("input[name*='IndexName']").addClass("input-validation-error");
        $("#errorSpanIndexName").addClass("error-msg");
        $("#errorSpanIndexName").text(ZnodeBase.prototype.getResourceByKeyName("AlphabetsAllowed"));
        $("#errorSpanIndexName").show();
    };
    //CMS index creation
    SearchConfiguration.prototype.GetCmsPageSearchConfigurations = function () {
        $("#BoostSetting").html("");
        $(".groupPannel").removeClass("active");
        $("#lnkSearchProfileList").removeClass("active");
        $("#lnkKeywordsRedirectList").removeClass("active");
        $("#lnkSynonymsList").removeClass("active");
        $("#lnkCreateIndex").removeClass("active");
        $("#lnkCreateCmsPageIndex").parent("li").addClass("active");
        var portalId = $("#hdnPortalId").val();
        Endpoint.prototype.GetCmsSearchConfiguration(portalId, $('#txtPortalName').val(), function (response) {
            $("#divCreateCMSIndex").html("");
            $("#divCreateCMSIndex").html(response);
            $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
        });
    };
    //Event triggered when grid is updated.
    SearchConfiguration.prototype.UpdateCMSPageFastSelectAfterGridUpdate = function () {
        $(document).off("GRID_UPDATED").on("GRID_UPDATED", function () {
            $("#txtPortalName").val($("#hdnPortalName").val());
        });
    };
    //Event triggered when grid is updated.
    SearchConfiguration.prototype.UpdateCMSPageSearchFastSelectAfterGridUpdate = function () {
        $(document).off("GRID_UPDATED").on("GRID_UPDATED", function () {
            var portalId = $("#hdnPortalId").val();
            var searchMonitorPortalId = $("#hdnSearchMonitorPortalId").val();
            if (portalId != searchMonitorPortalId) {
                Endpoint.prototype.GetCmsSearchConfiguration(searchMonitorPortalId, $('#txtStoreName').val(), function (response) {
                    $("#divCreateCMSIndex").html("");
                    $("#divCreateCMSIndex").html(response);
                    $("#txtPortalName").val($("#hdnPortalName").val());
                    $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
                });
            }
        });
    };
    SearchConfiguration.prototype.CreateCmsPageIndexSection = function () {
        var publishStateData = 'NONE';
        if ($('#radBtnPublishState').length > 0) {
            publishStateData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
            $("#RevisionType").val(publishStateData);
            $("#frmCmsPageCreateIndexData").submit();
            $('.modal-backdrop').removeClass('modal-backdrop');
        }
    };
    SearchConfiguration.prototype.GetCmsPageSearchIndexMonitorList = function () {
        if ($("#HasError").val() == "True")
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper($("#ErrorMessage").val(), 'error', isFadeOut, fadeOutTime);
        var cmsPageIndexId = $("#CMSSearchIndexId").val();
        var portalId = $("#hdnPortalId").val();
        SearchConfiguration.prototype.SetFastSelectFilter("portalid", portalId);
        if ($("#indexCMSMonitorListForm").length) {
            var searchMonitorPortalId = $("#hdnSearchMonitorPortalId").val();
            if (portalId != searchMonitorPortalId) {
                $("#indexCMSMonitorListForm").submit();
                SearchConfiguration.prototype.UpdateCMSPageFastSelectAfterGridUpdate();
            }
        }
        else {
            if (cmsPageIndexId != undefined) {
                Endpoint.prototype.GetCmsSearchIndexMonitorList(cmsPageIndexId, portalId, function (response) {
                    $("#searchIndexMonitorList").html("");
                    $("#searchIndexMonitorList").html(response);
                    $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
                });
            }
        }
    };
    //This method is used to select portal from fast select and show it on textbox
    SearchConfiguration.prototype.OnSelectCmsPortalDataBind = function (item) {
        Store.prototype.OnSelectStoreAutocompleteDataBind(item);
        if ($("#SearchConfigurationType").val() == "CreateIndex")
            SearchConfiguration.prototype.GetCmsPageSearchConfigurations();
        else {
            var selectedTab_3 = $('#SelectedTab').val();
            if (selectedTab_3 != undefined && selectedTab_3 != "") {
                switch (selectedTab_3) {
                    case "GetGlobalProductCategoryBoost":
                        SearchConfiguration.prototype.GetCategoryProductBoostValuesByCatalogId();
                        break;
                    case "GetFieldLevelBoost":
                        SearchConfiguration.prototype.GetFieldBoostValuesByCatalogId();
                        break;
                    case "GetGlobalProductBoost":
                        SearchConfiguration.prototype.GetProductBoostValuesByCatalogId();
                        break;
                    case "GetSearchSynonymsList":
                        SearchConfiguration.prototype.GetSynonymsByCatalogId();
                        break;
                    case "GetCatalogKeywordsList":
                        SearchConfiguration.prototype.GetKeywordsRedirectByCatalogId();
                        break;
                }
            }
        }
        ZnodeBase.prototype.RemovePopupOverlay();
    };
    SearchConfiguration.prototype.CmsPageRevisionTypePopUp = function () {
        if (SearchConfiguration.prototype.ValidateCMSPageIndexName()) {
            $("#errorSpanIndexName").removeClass("error-msg");
            if ($('#radBtnPublishState').length > 0)
                $("#CmsPageIndexPopup").modal('show');
            else
                $("#frmCmsPageCreateIndexData").submit();
        }
    };
    //This method is used to validate CMS Page Index Name
    SearchConfiguration.prototype.ValidateCMSPageIndexName = function () {
        var indexName = $("#frmCmsPageCreateIndexData").find("input[name*='IndexName']").val();
        return SearchConfiguration.prototype.ValidateIndexPattern("frmCreateIndexData", indexName);
    };
    SearchConfiguration.prototype.ValidateMessage = function () {
        var validateText;
        $(".field-validation-error").each(function () {
            validateText = $(this).text();
        });
        if (validateText !== undefined && validateText !== "") {
            return false;
        }
        return true;
    };
    return SearchConfiguration;
}(ZnodeBase));
//# sourceMappingURL=SearchConfiguration.js.map