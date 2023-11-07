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
var tinyMCE;
var templateDataList;
var Content = /** @class */ (function (_super) {
    __extends(Content, _super);
    function Content() {
        var _this = _super.call(this) || this;
        _this._callBackCount = 0;
        _this.isMoveFolder = false;
        _this.portalId = 0;
        return _this;
    }
    Content.prototype.Init = function () {
        Content.prototype.ShowModalPublishState();
        ZnodeBase.prototype.ShowLoader();
        Content.prototype.BindTreeView();
        Content.prototype.LocaleDropDownChangeForBanner();
        Content.prototype.LocaleDropDownChangeForContentPages();
        Content.prototype.BindAddContent();
        Content.prototype.SetIsSelectAllProfile();
        Content.prototype.ValidateSEOUrl();
        Content.prototype.ShowHideCustomField();
        ZnodeBase.prototype.HideLoader();
        Content.prototype.IsGlobal();
        Content.prototype.BindTemplateData();
    };
    Content.prototype.ValidateContentPageName = function (name, portalId) {
        var isValid = true;
        var actionName = $("#hdnactionname").val();
        if (name != "" && name != undefined && actionName == 'addcontentpage') {
            Endpoint.prototype.IsContentPageNameExist(name, portalId, function (response) {
                if (response) {
                    $("#PageName").addClass("input-validation-error");
                    $("#errorContentPageName").addClass("error-msg");
                    $("#errorContentPageName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistContentPageName"));
                    $("#errorContentPageName").show();
                    isValid = false;
                }
            });
        }
        return isValid;
    };
    Content.prototype.RemoveWidgetData = function (mappingId, widgetsKey, widgetCode) {
        var cmsContentPagesId = $('#CMSContentPagesId').val();
        var typeOfMapping = $('#TypeOFMapping').val();
        $.ajax({
            url: '/WebSite/RemoveWidgetDataFromContentPage?mappingId=' + mappingId + '&widgetKey=' + widgetsKey + '&widgetCode=' + widgetCode + '&typeOfMapping=' + typeOfMapping,
            async: true,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (result) {
                if (typeOfMapping == ZnodeBase.prototype.getResourceByKeyName("PortalMapping")) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(result.message, result.status ? 'success' : 'error', true, fadeOutTime);
                }
                else {
                    window.location.href = window.location.protocol + "//" + window.location.host + "/Content/EditContentPage?cmsContentPagesId=" + cmsContentPagesId + "&fileName=" + 'Widgets';
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(result.message, result.status ? 'success' : 'error', true, fadeOutTime);
                }
            }
        });
    };
    Content.prototype.SaveMediaWidget = function (code) {
        var mediaId = $("input#" + code).val();
        var cmsContentPagesId = $('#CMSContentPagesId').val();
        $.ajax({
            url: $("img#" + code).attr('data-url') + '&MediaId=' + mediaId,
            async: true,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (result) {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(result.message, result.status ? 'success' : 'error', true, fadeOutTime);
                window.location.href = window.location.protocol + "//" + window.location.host + "/Content/EditContentPage?cmsContentPagesId=" + cmsContentPagesId + "&fileName=" + 'Widgets';
            }
        });
    };
    Content.prototype.ValidateSEOUrl = function () {
        $("#SEOUrl").on("blur", function () {
            ZnodeBase.prototype.ShowLoader();
            Content.prototype.ValidateExistSEOUrl();
            ZnodeBase.prototype.HideLoader();
        });
    };
    Content.prototype.ValidateExistSEOUrl = function () {
        var isValid = true;
        if ($("#SEOUrl").val() != '') {
            Endpoint.prototype.IsSeoNameExist($("#SEOUrl").val(), $("#CMSContentPagesId").val(), $("#PortalId").val(), function (response) {
                if (!response) {
                    $("#SEOUrl").addClass("input-validation-error");
                    $("#errorSpanSEOUrl").addClass("error-msg");
                    $("#errorSpanSEOUrl").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistSEOUrl"));
                    $("#errorSpanSEOUrl").show();
                    isValid = false;
                }
                ZnodeBase.prototype.HideLoader();
            });
        }
        return isValid;
    };
    Content.prototype.ShowHideCustomField = function () {
        if (parseInt($("#CMSContentPagesId").val(), 10) > 0) {
            $("#PublishContentPageLink").show();
        }
    };
    Content.prototype.IsGlobal = function () {
        if ($('#PortalId').val() == "0" && window.location.href.toLowerCase().indexOf("update") !== -1) {
            $("#IsGlobal").attr("checked", "checked");
        }
        if ($("#IsGlobal").is(":checked")) {
            $("#txtPortalName").val('');
            $('#hdnPortalId').val(0);
            $(".portalsuggestion *").attr('readonly', true);
            $('.portalsuggestion').css({ pointerEvents: "none" });
            $(".fstElement").css({ "background-color": "#e7e7e7" });
            $(".fstElement").removeClass('input-validation-error');
            $("#errorRequiredStore").text('').text("").removeClass("field-validation-error").hide();
            $("#txtPortalName").removeClass('input-validation-error');
            $(".fstToggleBtn").html("Select Store");
            $(".fstResultItem").removeClass('fstSelected');
            $('#PortalId').val("0");
            $('#hdnPortalId').val("0");
            $('.fstToggleBtn').html($("#MsgAllStore").val());
            $('#StoreName').val($("#MsgAllStore").val());
        }
        else {
            $(".portalsuggestion *").attr('readonly', false);
            $('.portalsuggestion').css({ pointerEvents: "visible" });
            $(".fstElement").css({ "background-color": "#fff" });
            $('.fstToggleBtn').html($("#MsgSelectStore").val());
        }
    };
    Content.prototype.PublishContentPagePopup = function (control) {
        if (control != undefined || control != null) {
            control.attr("href", "#");
            $("#CMSContentPagesId").val($(control).attr("data-parameter").split('=')[1]);
            this.localeId = Number($("#ddlCultureSpan").attr("data-value"));
        }
        else {
            this.localeId = Number($("#ddl_locale_list_content_pages").val());
            $("#CMSContentPagesId").val($("#CMSContentPagesId").val());
        }
        $("#PublishContentPage").modal('show');
    };
    Content.prototype.EditContentPage = function (control) {
        if (control != undefined || control != null) {
            var url = control.attr("href");
            control.attr("href", "#");
            control.parent(".grid-action").prev('td').text();
            window.location.href = url + "&publishStatus=" + control.parents(".grid-action").prev('td').html();
        }
    };
    Content.prototype.OnTabChange = function (control) {
        if (control.text == "Page Info") {
            $("#divMainContainer").show();
            $("#divPreviewContainer").hide();
            $("#divContentContainer").hide();
        }
        else {
            $("#divMainContainer").hide();
            $("#divContentContainer").show();
            $("#divPreviewContainer").hide();
            $("#FileName").val(control.id);
        }
    };
    Content.prototype.SetSaveButton = function (element) {
        $('#dvSave').hide();
        $('#btnSaveNClose').hide();
        $('#btnToggle').hide();
        $('#linkBack').addClass("cms-back-link");
        ZnodeBase.prototype.activeAsidePannelAjax(element);
    };
    Content.prototype.PublishContentPage = function (control) {
        ZnodeBase.prototype.ShowLoader();
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        Endpoint.prototype.PublishContentPage($("#CMSContentPagesId").val(), publishStateFormData, 0, function (res) {
            DynamicGrid.prototype.RefreshGridOndelete(control, res);
        });
    };
    Content.prototype.UpdateAndPublishContentPage = function (control, formId) {
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        $("#" + formId + " [name=TargetPublishState]").val(publishStateFormData);
        $("#" + formId).attr("action", "UpdateAndPublishContentPage");
        $("#" + formId).addClass("dirtyignore");
        SaveCancel.prototype.SubmitForm(formId, 'Content.prototype.SelectProfile', undefined);
        ZnodeBase.prototype.ShowLoader();
        $("#" + formId).removeClass("dirtyignore");
    };
    Content.prototype.GetAddContentPageResult = function (response) {
        if (response.status) {
            window.location.href = "/Content/EditStaticPage?cmsContentPagesId=" + response.cmsContentPagesId;
        }
        ZnodeBase.prototype.RemovePopupOverlay();
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.message, response.status ? 'success' : 'error', true, fadeOutTime);
    };
    Content.prototype.DeleteContentPage = function (control) {
        var cmsContentPagesId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (cmsContentPagesId.length > 0) {
            Endpoint.prototype.DeleteContentPage(cmsContentPagesId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Content.prototype.DeleteManageMessages = function (control) {
        var cmsPortalMessageId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (cmsPortalMessageId.length > 0) {
            Endpoint.prototype.DeleteManageMessage(cmsPortalMessageId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    //tree
    Content.prototype.LoadTree = function () {
        var treeData = $('#Content_Page_Main_Tree').attr('data-tree');
        var obj = eval(treeData);
        if ($("#IsAddContentPageMode").val() == "True") {
            $('#Content_Page_Main_Tree').jstree({
                'core': {
                    "animation": 0,
                    "check_callback": function (operation, node, parent, position, more) {
                        if (operation === "move_node") {
                            return false;
                        }
                        return true; //allow all other operations
                    },
                    'multiple': false,
                    data: obj,
                },
                "search": {
                    "case_insensitive": true,
                    "show_only_matches": true
                },
                "plugins": ["contextmenu", "dnd", "search", "state", "wholerow"],
                "contextmenu": {
                    "items": function ($node) {
                        return {
                            "Create": {
                                "label": "Add Folder",
                                "action": function (obj) {
                                    Content.prototype.create();
                                }
                            },
                            "Rename": {
                                "label": "Rename",
                                "action": function (obj) {
                                    Content.prototype.rename();
                                }
                            }
                        };
                    }
                }
            });
        }
        else {
            $('#Content_Page_Main_Tree').jstree({
                'core': {
                    "animation": 0,
                    "check_callback": function (operation, node, parent, position, more) {
                        if (operation === "move_node") {
                            return (position == 0 && (more.pos == "i" || more.pos == undefined));
                        }
                        return true; //allow all other operations
                    },
                    'multiple': false,
                    data: obj,
                },
                "search": {
                    "case_insensitive": true,
                    "show_only_matches": true
                },
                "plugins": ["contextmenu", "dnd", "search", "state", "wholerow"],
                "contextmenu": {
                    "items": function ($node) {
                        return {
                            "Create": {
                                "label": "Add Folder",
                                "action": function (obj) {
                                    Content.prototype.create();
                                }
                            },
                            "Rename": {
                                "label": "Rename",
                                "action": function (obj) {
                                    Content.prototype.rename();
                                }
                            },
                            "Delete": {
                                "label": "Delete",
                                "action": function (obj) {
                                    Content.prototype.remove();
                                }
                            }
                        };
                    }
                }
            });
        }
    };
    Content.prototype.OpenDialog = function () {
        var url = $(this).attr('href');
        var dialog = $('<div style="display:none"></div>').appendTo('body');
        dialog.load(url, {}, function (responseText, textStatus, XMLHttpRequest) {
            dialog.dialog({
                close: function (event, ui) {
                    dialog.remove();
                }
            });
        });
        return false;
    };
    Content.prototype.BindEvent = function () {
        $("#Content_Page_Main_Tree").off('ready.jstree');
        $("#Content_Page_Main_Tree").on('ready.jstree', function (e, data) {
            var treeData = $('#Content_Page_Main_Tree').attr('data-tree');
            var obj = eval(treeData);
            var folderId = $('#hdnContentPageFolderId').val();
            if (folderId === undefined || folderId == "0" || folderId == "-1") {
                folderId = obj[0].id;
                $(".jstree-icon").click();
            }
            $('#Content_Page_Main_Tree').jstree(true).deselect_all();
            $('#Content_Page_Main_Tree').jstree('select_node', folderId);
        });
        $('#Content_Page_Main_Tree').off("move_node.jstree");
        $("#Content_Page_Main_Tree").on('move_node.jstree', this.setCurrentNode.bind(this));
        $('#Content_Page_Main_Tree').off("select_node.jstree");
        $("#Content_Page_Main_Tree").on('select_node.jstree', this.bindCurrentNode.bind(this));
    };
    Content.prototype.setCurrentNode = function (e, data) {
        if (data.parent != "#" && Content.prototype.IsFolderNameValid(data.node)) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.MoveContentPagesFolder(data.parent, data.node.id, function (data) {
                ZnodeBase.prototype.HideLoader();
                Content.prototype.RebindStructureTreeData(data.FolderJsonTree);
                if (data.HasNoError) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, 'success', isFadeOut, fadeOutTime);
                }
                else {
                    Content.prototype.ReloadTree();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, 'error', isFadeOut, fadeOutTime);
                }
            });
        }
        else {
            Content.prototype.ReloadTree();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSameNameFolder"), data.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
        }
    };
    Content.prototype.bindCurrentNode = function (e, data) {
        var i, j, r = [];
        for (i = 0, j = data.selected.length; i < j; i++) {
            r.push(data.instance.get_node(data.selected[i]).id);
        }
        var id = r[0];
        if (data.instance.get_parent(id) == "#") {
            $("#IsRootFolder").val("true");
        }
        else {
            $("#IsRootFolder").val("false");
        }
        $('#hdnContentPageFolderId').val(id);
        $.ajax({
            url: "/Content/ContentPageList?folderId=" + id + "&isRootFolder=" + $("#IsRootFolder").val(),
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                $("#StaticPageList").html(result);
            }
        });
    };
    Content.prototype.create = function () {
        var contentPageStructureTree = $('#Content_Page_Main_Tree').jstree(true), selectedNode = contentPageStructureTree.get_selected();
        if (!selectedNode.length) {
            return false;
        }
        selectedNode = selectedNode[0];
        var createdNode = contentPageStructureTree.create_node(selectedNode, { "type": "file" });
        if (createdNode.length > 0) {
            contentPageStructureTree.edit(createdNode, "New Folder", this.editCurrentNode.bind(this));
            $('.jstree-rename-input').attr('maxLength', 100);
        }
    };
    Content.prototype.editCurrentNode = function (obj) {
        if (this.IsFolderNameValid(obj) && obj.parent != null && obj.parent != "") {
            if (obj.text.length <= 100) {
                ZnodeBase.prototype.ShowLoader();
                Endpoint.prototype.ContentPageAddFolder(obj.parent, obj.text, function (data) {
                    $('#Content_Page_Main_Tree').jstree(true).set_id(obj, data.Id);
                    ZnodeBase.prototype.HideLoader();
                    Content.prototype.RebindStructureTreeData(data.FolderJsonTree);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
                });
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorFolderName"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
        }
        else {
            this.ReloadTree();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSameNameFolder"), 'error', isFadeOut, fadeOutTime);
            return false;
        }
    };
    Content.prototype.IsFolderNameValid = function (selectedNode) {
        var contentPageStructureTree = $('#Content_Page_Main_Tree').jstree(true);
        var siblings = contentPageStructureTree.get_children_dom(selectedNode.parent);
        var newNodeId = selectedNode.id;
        var siblingFolderNames = [];
        siblings.find("a.jstree-anchor").each(function () {
            if (this.parentElement.id != newNodeId) {
                siblingFolderNames.push($(this).text());
            }
        });
        if (selectedNode.text != null && selectedNode.text != "") {
            return ($.inArray(selectedNode.text, siblingFolderNames) == -1);
        }
        else {
            return false;
        }
    };
    Content.prototype.ReloadTree = function () {
        $('#Content_Page_Main_Tree').jstree("destroy");
        Content.prototype.LoadTree();
        Content.prototype.BindEvent();
    };
    Content.prototype.rename = function () {
        var contentPageStructureTree = $('#Content_Page_Main_Tree').jstree(true), selectedNode = contentPageStructureTree.get_selected();
        if ($('.jstree-clicked').length == 1) {
            var selectedNodeText = $('.jstree-clicked').text();
        }
        if (!selectedNode.length) {
            return false;
        }
        selectedNode = selectedNode[0];
        if (selectedNode) {
            contentPageStructureTree.edit(selectedNode, selectedNodeText, this.RenameFolder.bind(this));
            $('.jstree-rename-input').attr('maxLength', 100);
        }
    };
    Content.prototype.RenameFolder = function (obj) {
        if (this.IsFolderNameValid(obj) && obj.id != null && obj.id != "") {
            if (obj.text.length <= 100) {
                ZnodeBase.prototype.ShowLoader();
                Endpoint.prototype.ContentPageRenameFolder(obj.id, obj.text, function (data) {
                    ZnodeBase.prototype.HideLoader();
                    Content.prototype.RebindStructureTreeData(data.FolderJsonTree);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
                });
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorFolderName"), 'error', isFadeOut, fadeOutTime);
                return false;
            }
        }
        else {
            this.ReloadTree();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSameNameFolder"), 'error', isFadeOut, fadeOutTime);
            return false;
        }
    };
    Content.prototype.remove = function () {
        var isRoot = $("#IsRootFolder").val();
        if (isRoot != undefined && isRoot != "" && isRoot == "false") {
            $("#delete-popup-btn").html('<button type="button" id="btnDeleteFolder" data-toggle="modal" data-target="#ContentPageFolderDeletePopup"></button>');
            $("#btnDeleteFolder").click();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorRootFolderCanNotDelete"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Content.prototype.DeleteFolder = function () {
        var ref = $('#Content_Page_Main_Tree').jstree(true), selectedNode = ref.get_selected();
        if (selectedNode == null) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectFolderToDelete"), 'error', isFadeOut, fadeOutTime);
        }
        else {
            $("#delete-popup-btn").html('<button type="button" id="btnTempFolderDelete" data-toggle="modal" data-target="#ContentPageConfirmFolderDeletePopup">temp</button>');
            $("#btnTempFolderDelete").click();
        }
    };
    Content.prototype.DeleteFolderPerment = function () {
        var ref = $('#Content_Page_Main_Tree').jstree(true), selectedNode = ref.get_selected();
        if (selectedNode == null) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectFolderToDelete"), 'error', isFadeOut, fadeOutTime);
        }
        else {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.ContentPageFolderDelete(selectedNode[0].toString(), function (data) {
                ZnodeBase.prototype.HideLoader();
                Content.prototype.RebindStructureTreeData(data.FolderJsonTree);
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
                var parentId = ref.get_parent(selectedNode);
                ref.delete_node(selectedNode);
                $('#Content_Page_Main_Tree' + ' #' + parentId + '_anchor').click();
            });
        }
    };
    Content.prototype.RebindStructureTreeData = function (updatedData) {
        $('#Popup_Tree').attr('data-tree', updatedData);
        $('#Content_Page_Main_Tree').attr('data-tree', updatedData);
        $("#Popup_Tree").jstree('destroy');
        TreeView.prototype.PopupTree();
    };
    Content.prototype.GetProfileList = function (actionName) {
        if (actionName == "addcontentpage") {
            var portalId = $("#PortalId").val();
            Endpoint.prototype.GetProfileList(portalId, function (res) {
                if (res != null || res != "") {
                    $("#profilelist").html(res);
                }
            });
        }
    };
    Content.prototype.SelectProfile = function () {
        var isSubmit = false;
        if (!Content.prototype.ValidateExistSEOUrl())
            return false;
        if (!Content.prototype.ValidateContentPageName($("#PageName").val(), $("#PortalId").val()))
            return false;
        Content.prototype.SetIsSelectAllProfile();
        Content.prototype.ValidateForStore();
        if ($(".jstree-clicked").attr("id") != null && $(".jstree-clicked").attr("id") !== "") {
            $("#CMSContentPageGroupId").val($(".jstree-clicked").attr("id").split("_")[0]);
        }
        var checkedCount = 0;
        $("#ProfileId").next().children("ul.multiselect-container").children().children().children(".checkbox").children().each(function () {
            if ($(this).is(":checked")) {
                checkedCount = checkedCount + 1;
                $("#error-profile").html("");
                isSubmit = $(this).is(":checked");
                return true;
            }
            else {
                if (isSubmit) {
                    $("#error-profile").html("");
                }
                else {
                    $("#error-profile").html(ZnodeBase.prototype.getResourceByKeyName("SelectAtleastOneProfile"));
                }
            }
        });
        return isSubmit;
    };
    Content.prototype.OnPreviewTabChange = function (control) {
        $("#divMainContainer").hide();
        $("#divContentContainer").hide();
        $("#divPreviewContainer").show();
    };
    Content.prototype.LocaleDropDownChangeForBanner = function () {
        $("#ddl_locale_list_manage_message").on("change", function () {
            Endpoint.prototype.UpdateManageMessage($("#CMSMessageKeyId").val(), $("#CMSAreaId").val(), $("#PortalId").val(), $("#ddl_locale_list_manage_message").val(), function (response) {
                $('#div_manage_message_locale').html(response);
                $("#div_manage_message_locale textarea").attr("wysiwygenabledproperty", "true");
                reInitializationMce();
            });
        });
    };
    Content.prototype.LocaleChangeOnConfigure = function () {
        $("#ddl_locale_list").off("change");
        $("#ddl_locale_list").on("change", function () {
            Endpoint.prototype.ManageTextWidgetConfiguration($('#CMSMappingId').val(), $('#CMSWidgetsId').val(), $('#WidgetsKey').val(), $('#TypeOFMapping').val(), $('#DisplayName').val(), $('#WidgetName').val(), $('#FileName').val(), $('#ddl_locale_list').val(), function (response) {
                $('#associatedPanel').html("");
                $('#associatedPanel').html(response);
                $('.mceEditor').attr('wysiwygenabledproperty', 'true');
                reInitializationMce();
            });
        });
    };
    Content.prototype.BindAddContent = function () {
        $("#AddContentPagebtn").off("click");
        $("#AddContentPagebtn").on('click', function (e) {
            e.preventDefault();
            var contentGroupId = "0";
            if ($(".jstree-clicked").attr("id") != null && $(".jstree-clicked").attr("id") !== "") {
                contentGroupId = $(".jstree-clicked").attr("id").split("_")[0];
            }
            if (parseInt(contentGroupId) > 0)
                window.location.href = window.location.protocol + "//" + window.location.host + "/Content/AddContentPage?folderId=" + parseInt(contentGroupId) + "";
            else
                window.location.href = window.location.protocol + "//" + window.location.host + "/Content/AddContentPage";
        });
    };
    Content.prototype.SetTreeView = function () {
        if ($("#hdnContentPageFolderId").val() > 0) {
            $('#Content_Page_Main_Tree').on('ready.jstree', function () {
                $('#Content_Page_Main_Tree').jstree(true).deselect_all();
                $('#Content_Page_Main_Tree').jstree('select_node', $("#hdnContentPageFolderId").val());
            });
        }
    };
    //function for Locale on change event.
    Content.prototype.LocaleDropDownChangeForContentPages = function () {
        $("#ddl_locale_list_content_pages").on("change", function () {
            Endpoint.prototype.GetContentPage($("#CMSContentPagesId").val(), $("#ddl_locale_list_content_pages").val(), function (response) {
                $('#div_content_page_for_locale').html(response);
            });
        });
    };
    Content.prototype.SetIsSelectAllProfile = function () {
        if ($("#profilelist ul li input:checkbox[value='multiselect-all']").prop('checked')) {
            $("#IsSelectAllProfile").val("true");
        }
        else {
            $("#IsSelectAllProfile").val("false");
        }
        return true;
    };
    Content.prototype.CheckIsAllProfileSelected = function () {
        if ($("#IsSelectAllProfile").val() == "True" || $("#IsSelectAllProfile").val() == "true" || $("#IsSelectAllProfile").val() == true) {
            $("#profilelist ul li input:checkbox").click();
        }
    };
    Content.prototype.SetIsMoveFolderValue = function (modelPopup) {
        this.isMoveFolder = true;
        EditableText.prototype.DialogDelete(modelPopup);
        TreeView.prototype.PopupTree();
    };
    Content.prototype.GetSelectednodeId = function () {
        var selectedNode = new Array();
        var ref = $('#Popup_Tree').jstree(true), selectedNode = ref.get_selected();
        return selectedNode[0];
    };
    Content.prototype.unique = function () {
        var ids = [];
        $("#grid").find("tr").each(function () {
            if ($(this).find(".grid-row-checkbox").length > 0) {
                if ($(this).find(".grid-row-checkbox").is(":checked")) {
                    var id = $(this).find(".grid-row-checkbox").attr("id").split("_")[1];
                    ids.push(id);
                }
            }
        });
        var result = [];
        $.each(ids, function (i, e) {
            if ($.inArray(e, result) == -1)
                result.push(e);
        });
        return result;
    };
    Content.prototype.MoveCopyPages = function () {
        var ids = this.unique().toString();
        var selectedNode = this.GetSelectednodeId();
        if (selectedNode == null || selectedNode == "") {
            $("#TreePopupError").show();
            return false;
        }
        $("#TreePopupError").hide();
        ZnodeBase.prototype.ShowLoader();
        Endpoint.prototype.MovePage(selectedNode, ids, function (data) {
            ZnodeBase.prototype.HideLoader();
            $("#TreePopupCancel").click();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, data.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
            if (Content.prototype.isMoveFolder) {
                $("#searchform").submit();
            }
        });
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Content.prototype.SaveMessageForPortal = function (backURL) {
        $("#frmCreateMessage").validate();
        var isValid = this.ValidateForStore();
        if (!$("#frmCreateMessage").valid() || !isValid) {
            if (tinyMCE.activeEditor.getContent() == "") {
                $("#error_Manage_Message").html(ZnodeBase.prototype.getResourceByKeyName("EnterMessageDescription"));
            }
            else {
                $("#error_Manage_Message").html(" ");
            }
            //Promotion tab contains validation
            $(".input-validation-error").parent().parent().parent().parent().parent().each(function () {
                if ($(this).parent().attr('id') != undefined)
                    $('li[data-groupcode=' + $(this).parent().attr('id') + ']').addClass('active-tab-validation');
                else
                    $('li[data-groupcode=' + $(this).parent().parent().attr('id') + ']').addClass('active-tab-validation');
                ZnodeBase.prototype.HideLoader();
            });
        }
        else {
            if (typeof (backURL) != "undefined")
                $.cookie("_backURL", backURL, { path: '/' });
            $('#frmCreateMessage').submit();
        }
    };
    //validation for store textbox
    Content.prototype.ValidateForStore = function () {
        if (($("#txtPortalName").val() == "" || $("#hdnPortalId").val() <= 0) && !$("#IsGlobal").is(":checked")) {
            $("#errorRequiredStore").text('').text(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectPortal")).addClass("field-validation-error").show();
            $("#txtPortalName").parent("div").addClass('input-validation-error');
            return false;
        }
        return true;
    };
    //This method is used to get publish catalog list on aside panel
    Content.prototype.GetPortalList = function () {
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Content/GetPortalList', 'divContentStoreList');
    };
    //To Do: To bind portal information
    Content.prototype.OnSelectPortalResult = function (item) {
        Store.prototype.OnSelectStoreAutocompleteDataBind(item);
        Content.prototype.GetProfileList($('#hdnactionname').val());
    };
    Content.prototype.GetPortalDetail = function () {
        $("#grid").find("tr").on("click", function () {
            var portalName = $(this).find("td[class='storecolumn']").text();
            var portalId = $(this).find("td")[0].innerHTML;
            $('#txtPortalName').val(portalName);
            $('#hdnPortalId').val(portalId);
            $('#PortalId').val(portalId);
            $("#errorRequiredStore").text("").removeClass("field-validation-error").hide();
            $("#txtPortalName").removeClass('input-validation-error');
            $('#divContentStoreList').hide(700);
            ZnodeBase.prototype.RemovePopupOverlay();
            Content.prototype.GetProfileList($('#hdnactionname').val());
        });
    };
    Content.prototype.BindTreeView = function () {
        Content.prototype.LoadTree();
        Content.prototype.BindEvent();
        Content.prototype.SetTreeView();
        $('.treesearch').keyup(function () {
            var searchText = $('.treesearch').val();
            var result = $('#Content_Page_Main_Tree').jstree('search', searchText);
            if ($(result).find('.jstree-search').length == 0 && searchText != "")
                $('#contentsearchresult').html(ZnodeBase.prototype.getResourceByKeyName("NoResult"));
            else {
                $('#contentsearchresult').html("");
            }
        });
    };
    Content.prototype.ShowModalPublishState = function () {
        var href = window.location.href.toLowerCase();
        var publishStatus = Order.prototype.GetParameterByName("publishstatus", href);
        var folderId = Order.prototype.GetParameterByName("folderid", href);
        if (publishStatus != null && publishStatus != "production" && publishStatus != "preview") {
            $("#SaveContentPage").modal('show');
        }
        if (folderId != null) {
            $("#divMainContainer").show();
        }
    };
    Content.prototype.DdlCultureChange = function () {
        var expiresTime = ZnodeBase.prototype.SetCookiesExpiry();
        $.cookie("_contentCulture", $("#ddlCultureSpan").attr("data-value"), { expires: expiresTime }); // expires after 2 hours
        var url = decodeURIComponent(window.location.href);
        var orignalUrl = url.split(/[?#]/)[0];
        if (selectedTab != undefined)
            window.location.replace(orignalUrl + "?CmsMessageKeyId=" + $("#CmsMessageId").val() + "&selectedtab=" + selectedTab);
        else {
            if (url.indexOf('CmsMessageId') > -1)
                window.location.replace(orignalUrl + "?CmsMessageKeyId=" + $("#CmsMessageId").val());
            else
                window.location.reload();
        }
    };
    Content.prototype.PublishContentPopup = function (zPublishAnchor) {
        zPublishAnchor.attr("href", "#");
        this.portalId = parseInt($(zPublishAnchor).attr("data-parameter").split('&')[2].split('=')[1]);
        $("#HdncmsMessageId").val($(zPublishAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        $("#HdncmsMessageKeyId").val($(zPublishAnchor).attr("data-parameter").split('&')[3].split('=')[1]);
        $("#PublishMessage").modal('show');
    };
    Content.prototype.PublishMessage = function () {
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        Endpoint.prototype.PublishMessage($("#HdncmsMessageKeyId").val(), this.portalId, publishStateFormData, 0, function (res) {
            DynamicGrid.prototype.RefreshGridOndelete($("#View_GetManageMessageList").find("#refreshGrid"), res);
        });
    };
    Content.prototype.UpdatePublish = function () {
        var publishStateFormData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateFormData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        $("#frmCreateMessage [name=TargetPublishState]").val(publishStateFormData);
        $("#frmCreateMessage").attr('action', 'UpdateAndPublishManageMessage');
        $("#frmCreateMessage").addClass("dirtyignore");
        $("#frmCreateMessage").submit();
        $("#frmCreateMessage").removeClass("dirtyignore");
    };
    Content.prototype.PublishPopPup = function () {
        $("#UpdatePublish").modal('show');
    };
    Content.prototype.SaveMessage = function () {
        $("#frmCreateMessage").submit();
    };
    Content.prototype.ShowPreviewNotification = function () {
        var message = "";
        if ($("#hdnPreviewUrl").val() != "" && $("#StorePublishStatus").val() == "true") {
            message = ZnodeBase.prototype.getResourceByKeyName("CMSNotificationForConfigure");
        }
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(message, 'success', isFadeOut, fadeOutTime);
    };
    Content.prototype.RefreshGridContent = function (targetDiv) {
        if ($("#hdnPageRefreshUrl") != undefined && $("#hdnPageRefreshUrl").val() != "") {
            var url = $("#hdnPageRefreshUrl").val();
            Endpoint.prototype.GetPartial(url, function (response) {
                $("#" + targetDiv).html('');
                $("#" + targetDiv).append(response);
                GridPager.prototype.Init();
                DynamicGrid.prototype.ClearCheckboxArray();
            });
        }
    };
    Content.prototype.GetCMSDefaultSEODetails = function () {
        var itemId = $("#CMSContentPagesId").val();
        var seoCode = $('[id^=CategoryCode]').val();
        var seoTypeId = 3;
        var portalId = $("#PortalId").val();
        if (portalId == undefined)
            portalId = 0;
        var localeId = $("#LocaleId").val();
        if (localeId == undefined)
            localeId = 0;
        if (itemId != undefined) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.GetDefaultCMSSEODetails(seoTypeId, seoCode, itemId, localeId, portalId, function (response) {
                $("#div_content_page_for_locale").show();
                $("#div_content_page_for_locale").html("");
                $("#div_content_page_for_locale").html(response);
                ZnodeBase.prototype.HideLoader();
            });
        }
    };
    Content.prototype.BindTemplateData = function () {
        $.each(templateDataList, function () {
            $('#ddlCMSTemplate').append('<option value=' + this.CMSTemplateId + ' data-thumbnail=' + encodeURI(this.MediaPath) + '>' + this.Name + '</option>');
        });
        $('#ddlCMSTemplate').change(function () {
            var value = $(this).val();
            $('#CMSTemplateId').val(value);
        });
        if ($('#ddlCMSTemplate').val() != undefined) {
            $('#CMSTemplateId').val($("#ddlCMSTemplate option:selected").val());
        }
    };
    Content.prototype.SetFormWidgetActiveTab = function (id) {
        $('.cms-form-widget .aside-panel li a').removeClass('active');
        $("#" + id).addClass('active');
    };
    Content.prototype.SetFormWidgetActiveTabOnLoad = function () {
        if (!$("#EmailWidget").hasClass('active')) {
            $("#FormWidget").addClass('active');
        }
    };
    return Content;
}(ZnodeBase));
//# sourceMappingURL=Content.js.map