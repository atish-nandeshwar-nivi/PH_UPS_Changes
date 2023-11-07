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
var Catalog = /** @class */ (function (_super) {
    __extends(Catalog, _super);
    function Catalog() {
        var _this = _super.call(this) || this;
        _this._callBackCount = 0;
        return _this;
    }
    Catalog.prototype.Init = function () {
        Catalog.prototype.BindTreeView();
        Catalog.prototype.ValidateCatalog();
        Catalog.prototype.EnableDisableDefaultStore(true);
        Catalog.prototype.AllowIndexingListner();
        Catalog.prototype.EditCatalog();
        //Event triggered when grid is updated.
        $(document).off("GRID_UPDATED").on("GRID_UPDATED", function () {
            Catalog.prototype.EditCatalog();
        });
    };
    Catalog.prototype.AllowIndexingListner = function () {
        $(document).on("click", ".IsAllowIndexing", function () {
            if ($(this).is(":checked") && $(this).data("val").toLowerCase() == "enable")
                Catalog.prototype.EnableDisableDefaultStore(false);
            else
                Catalog.prototype.EnableDisableDefaultStore(true);
        });
    };
    Catalog.prototype.EnableDisableDefaultStore = function (isStoreDisabled) {
        if ($(".fstElement").length > 0) {
            if (isStoreDisabled) {
                $(".fstElement").children().prop('disabled', true);
                $(".fstElement").css("background-color", "#efefef");
            }
            else {
                $(".fstElement").children().prop('disabled', false);
                $(".fstElement").css("background-color", "");
            }
        }
    };
    Catalog.prototype.EditCatalog = function () {
        $("table[data-swhgcontainer='ZnodePimCatalog']").find("[data-managelink='Edit']").on("click", function (e) {
            e.preventDefault();
            e.stopPropagation();
            var pimCatalogId = parseInt(decodeURIComponent($(this).attr('data-parameter')).split('=')[1]);
            Endpoint.prototype.EditCatalog(pimCatalogId, function (res) {
                if (res != "") {
                    $("#divEditCatalogPopup").modal("show");
                    $("#divEditCatalogPopup").html(res);
                    $('*[data-url]').each(function () { fastselectwrapper($(this), $(this).data("onselect-function")); });
                    var isStoreDisabled = $(".IsAllowIndexing:checked").data("val").toLowerCase() == "disable";
                    Catalog.prototype.EnableDisableDefaultStore(isStoreDisabled);
                }
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorMessage"), 'error', isFadeOut, fadeOutTime);
            });
        });
    };
    Catalog.prototype.UpdateCatalogResult = function (res) {
        if (res.status) {
            $("#divCopyStorePopup").modal("hide");
            WebSite.prototype.RemovePopupOverlay();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, "success", true, 5000);
            DynamicGrid.prototype.RefreshGridNoNotification($("#ZnodePimCatalog").find("#refreshGrid"));
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, "error", true, 5000);
            $("#divCopyStorePopup").modal("hide");
            WebSite.prototype.RemovePopupOverlay();
        }
    };
    Catalog.prototype.LoadCategoryMethods = function () {
    };
    Catalog.prototype.LoadProductMethods = function () {
    };
    Catalog.prototype.DeleteMultipleCatalog = function (control) {
        var pimCatalogId = [];
        if (MediaManagerTools.prototype.unique().length <= 0) {
            pimCatalogId.push($("#DeleteCatalogId").val());
            $("#DeleteCatalogId").val("");
        }
        else {
            pimCatalogId = MediaManagerTools.prototype.unique();
        }
        if (pimCatalogId.length > 0) {
            Endpoint.prototype.DeleteCatalogs(pimCatalogId.join(","), $('#IsDeletePublishCatalog').is(":checked"), function (response) {
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Catalog.prototype.OnSelectPortalResult = function (item) {
        $('#PortalId').val(item.Id);
    };
    Catalog.prototype.BindProductGridBasedOnStatus = function () {
        ZnodeBase.prototype.ShowLoader();
        var isActivechecked = $("#IsActive").is(":checked");
        var _newUrl = MediaManagerTools.prototype.UpdateQueryString("IsActive", $("#IsActive").is(":checked"), window.location.href);
        window.history.pushState({ path: _newUrl }, '', _newUrl);
        $.ajax({
            url: _newUrl,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            success: function (result) {
                ZnodeBase.prototype.HideLoader();
                $("#" + $("#container_to_update").val()).html(result);
            }
        });
    };
    Catalog.prototype.ChangeCheckBoxStatus = function () {
        var isActivechecked = $("#IsActive").is(":checked");
        $("#IsActive").prop("checked", !isActivechecked);
    };
    Catalog.prototype.SetProudctQueryString = function () {
        var isActivechecked = $("#IsActive").length > 0 ? $("#IsActive").is(":checked") : true;
        var _newUrl = MediaManagerTools.prototype.UpdateQueryString("IsActive", isActivechecked, window.location.href);
        window.history.pushState({ path: _newUrl }, '', _newUrl);
    };
    Catalog.prototype.DeleteCatalog = function () {
        $("#grid tbody tr td").find(".z-delete").removeAttr("onclick data-toggle data-target");
        $("#grid tbody tr td").find(".z-delete").on("click", function (e) {
            e.preventDefault();
            $("#DeleteCatalogId").val($(this).attr("data-parameter").split('&')[0].split('=')[1]);
            $("#DeleteCatalogPopup").modal('show');
        });
    };
    Catalog.prototype.PublishCatalogPopup = function (zPublishAnchor) {
        zPublishAnchor.attr("href", "#");
        $("#HdnCatalogId").val($(zPublishAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        Catalog.prototype.SetDefaultCheckedValue();
        $("#PublishCatalog").modal('show');
    };
    Catalog.prototype.PreviewCatalogPopup = function (zPublishAnchor) {
        zPublishAnchor.attr("href", "#");
        $("#HdnCatalogId").val($(zPublishAnchor).attr("data-parameter").split('&')[0].split('=')[1]);
        $("#PreviewCatalog").modal('show');
    };
    Catalog.prototype.PublishCatalog = function (revisionType, isDraftProductsOnly) {
        Endpoint.prototype.PublishCatalog($("#HdnCatalogId").val(), revisionType, isDraftProductsOnly, function (res) {
            ZnodeProgressNotifier.prototype.InitiateProgressBar(function () {
                DynamicGrid.prototype.RefreshGridOndelete($("#ZnodePimCatalog").find("#refreshGrid"), res);
            });
        });
    };
    Catalog.prototype.GetActiveTab = function (res, type) {
        $("#create-edit-catalog").hide();
        ZnodeBase.prototype.activeAsidePannelAjax(res);
        if (type == 'Category') {
            Catalog.prototype.LoadCategoryMethods();
        }
        else if (type == 'Product') {
            Catalog.prototype.LoadProductMethods();
        }
    };
    Catalog.prototype.GetPopUpTree = function () {
        $("#ZnodePimCatalog").find(".z-preview").on("click", function (e) {
            e.preventDefault();
            var pimCatalogId = $(this).attr("href").split('/')[3].split('?')[1].split('=')[1];
            $("#category-tree-link").html('<button type="button" id="category-link" data-toggle="modal" data-target="#Category-Tree" title="Category Tree">Category Tree</button>');
            $("#category-link").click();
            $("#Category-Popup-Tree").jstree('destroy');
            $("#Category-Popup-Tree").jstree({
                'core': {
                    'data': {
                        "url": function (node) {
                            var nodeId = "";
                            var url = "";
                            if (node.id == "#") {
                                url = '/PIM/Catalog/GetProductTree?pimCatalogId=' + pimCatalogId + "&pimCategoryId=-1&displayProducts=true";
                            }
                            else if (node.id == "0") {
                                url = '/PIM/Catalog/GetProductTree?pimCatalogId=' + pimCatalogId + "&pimCategoryId=0&displayProducts=true";
                            }
                            else {
                                url = '/PIM/Catalog/GetProductTree?pimCatalogId=' + pimCatalogId + "&pimCategoryId=" + node.id + "&displayProducts=true";
                            }
                            return url;
                        },
                        "success": function (new_data) {
                            return eval(new_data);
                        }
                    }
                },
                "plugins": ['state', "themes", "json_data", "wholerow"]
            }).on('loaded.jstree', function () {
                $("#Category_Tree").jstree('open_all');
            });
            return false;
        });
    };
    Catalog.prototype.DeleteMultipleCatalogAssociatedCategories = function (control) {
        var ref = $('#category_Main_Tree').jstree(true), selectedNode = ref.get_selected();
        if (selectedNode == null) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectFolderToDelete"), 'error', isFadeOut, fadeOutTime);
        }
        var pimCategoryHierarchyId = $("#hdnPimCategoryId").val();
        var pimCatalogId = $("#hdnPimCatalogId").val();
        ZnodeBase.prototype.ShowLoader();
        if (pimCatalogId.length > 0) {
            Endpoint.prototype.DeleteMultipleCatalogAssociatedCategories(pimCatalogId, pimCategoryHierarchyId, function (response) {
                ZnodeBase.prototype.HideLoader();
                Catalog.prototype.RebindStructureTreeData(response.FolderJsonTree);
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Message, response.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
                var parentId = ref.get_parent(selectedNode);
                ref.delete_node(selectedNode);
                $('#category_Main_Tree' + ' #' + parentId + '_anchor').click();
                Catalog.prototype.ReloadTree();
            });
        }
    };
    Catalog.prototype.RebindStructureTreeData = function (updatedData) {
        $('#category_Main_Tree').attr('data-tree', updatedData);
        Catalog.prototype.LoadTree();
        Catalog.prototype.BindEvent();
    };
    Catalog.prototype.GetAssociatedCategoryDetails = function () {
        $("section[update-container-id=ZnodeCatalogAssociateCategory]").find(".z-edit").on("click", function (e) {
            e.preventDefault();
            var catalogId = $("#PimCatalogId").val();
            var categoryId = parseInt($(this).attr("href").split('/')[3].split('?')[1].split('=')[1]);
            Endpoint.prototype.GetAssociatedCategoryDetails(catalogId, categoryId, function (res) {
                $("#associatedcategorydetails").modal("show");
                $("#associatedcategorydetails").html(res);
            });
        });
    };
    Catalog.prototype.GetAssociatedCategoryList = function () {
        Endpoint.prototype.GetAssociatedCategoryList(parseInt($("#PimCatalogId").val()), function (response) {
            $("#ZnodeCatalogAssociateCategory").html('');
            $("#ZnodeCatalogAssociateCategory").html(response);
            GridPager.prototype.UpdateHandler();
        });
    };
    Catalog.prototype.EditAssociatedCategory = function () {
        var catalogId = $("#PimCatalogId").val();
        var categoryId = parseInt($('#Category_Tree').jstree(true).get_selected()[0]);
        Endpoint.prototype.GetAssociatedCategoryDetails(catalogId, categoryId, function (res) {
            $("#associatedcategorydetails").html(res);
            $("#associatedcategorydetails").modal("show");
        });
    };
    Catalog.prototype.GetUnassociatedCatalogCategory = function () {
        var pimCatalogId = $("#PimCatalogId").val();
        var catalogName = $("#CatalogName").val();
        Endpoint.prototype.GetUnassociatedCatalogCategory(pimCatalogId, catalogName, true, function (response) {
            $(".unassocated-list").html("");
            for (var i = 0; i < response.categoryList.length; i++) {
                $("#categoryunassociatedcatalog .unassocated-list").append('<li class="categoryproduct-list" draggable="true"> <label><input class="category" name="IsActive" type="checkbox" value="true" data-categoryid="' + response.categoryList[i].Value + '" ><span class="lbl padding-8" >' + response.categoryList[i].Text + '</span><input name= "IsActive" type= "hidden" value= "false" ></label></li>'); //append('<li class="categoryproduct-list" draggable="true" data-categoryid="' + response.categoryList[i].Value + '">' + response.categoryList[i].Text + '</li>')
            }
        });
    };
    //tree
    Catalog.prototype.LoadTree = function () {
        var treeData = $('#category_Main_Tree').attr('data-tree');
        var obj = eval(treeData);
        $('#category_Main_Tree').jstree({
            'core': {
                "animation": 0,
                "check_callback": function (operation, node, parent, position, more) {
                    if (Catalog.prototype.IsProfileCatalog()) {
                        return false;
                    }
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
                    if (window.location.href.indexOf("ManageProfileCatalog") <= -1) {
                        if ($node.original.id > 0) {
                            return {
                                "Edit": {
                                    "label": ZnodeBase.prototype.getResourceByKeyName("Labeledit"),
                                    "action": function (obj) {
                                        Catalog.prototype.EditCategorySettings();
                                    }
                                },
                                "Delete": {
                                    "label": ZnodeBase.prototype.getResourceByKeyName("LabelUnAssociate"),
                                    "action": function (obj) {
                                        Catalog.prototype.remove();
                                    }
                                },
                                "Up": {
                                    "label": "Up",
                                    "action": function (obj) {
                                        Catalog.prototype.Up(obj);
                                    }
                                },
                                "Down": {
                                    "label": "Down",
                                    "action": function (obj) {
                                        Catalog.prototype.Down(obj);
                                    }
                                },
                                "Publish": {
                                    "label": "Publish",
                                    "action": function (obj) {
                                        Catalog.prototype.PublishCatalogCategoryProductsPopup(obj);
                                    }
                                }
                            };
                        }
                    }
                    else {
                        return {
                            "Delete": {
                                "label": ZnodeBase.prototype.getResourceByKeyName("LabelUnAssociate"),
                                "action": function (obj) {
                                    Catalog.prototype.remove();
                                }
                            }
                        };
                    }
                }
            }
        });
    };
    Catalog.prototype.IsProfileCatalog = function () {
        return (window.location.href.indexOf("ManageProfileCatalog") > -1);
    };
    Catalog.prototype.BindEvent = function () {
        $("#category_Main_Tree").off('ready.jstree');
        $("#category_Main_Tree").on('ready.jstree', function (e, data) {
            var treeData = $('#category_Main_Tree').attr('data-tree');
            var obj = eval(treeData);
            var folderId = $('#hdnPimCategoryId').val();
            if (folderId === undefined || folderId == "0" || folderId == "-1") {
                $("#btn-product-association").hide();
                folderId = obj[0].id;
                $(".jstree-icon").click();
            }
            $('#category_Main_Tree').jstree(true).deselect_all();
            $('#category_Main_Tree').jstree('select_node', folderId);
        });
        $('#category_Main_Tree').off("move_node.jstree");
        $("#category_Main_Tree").on('move_node.jstree', this.setCurrentNode.bind(this));
        $('#category_Main_Tree').off("select_node.jstree");
        $("#category_Main_Tree").on('select_node.jstree', this.bindCurrentNode.bind(this));
    };
    Catalog.prototype.bindCurrentNode = function (e, data) {
        DynamicGrid.prototype.ClearCheckboxArray();
        if (Catalog.prototype._callBackCount === 0) {
            Catalog.prototype._callBackCount++;
        }
        else {
            var i, j, r = [];
            for (i = 0, j = data.selected.length; i < j; i++) {
                r.push(data.instance.get_node(data.selected[i]).id);
            }
            var id = r[0];
            if (data.instance.get_parent(id) == "#") {
                $("#btn-product-association").hide();
                $("#IsRootFolder").val("true");
                $('#hdnPimCategoryId').val("-1");
                id = "-1";
                $("#PublishCatalogCategoryLink").hide();
                $("#hideShowCatalogbtn").hide();
            }
            else {
                $("#PublishCatalogCategoryLink").show();
                $("#btn-product-association").show();
                $("#hideShowCatalogbtn").show();
                $("#IsRootFolder").val("false");
                $('#hdnPimCategoryId').val(id);
            }
            ZnodeBase.prototype.ShowLoader();
            var _newUrl;
            _newUrl = MediaManagerTools.prototype.UpdateQueryString("pimCategoryHierarchyId", id, window.location.href);
            window.history.pushState({ path: _newUrl }, '', _newUrl);
            $.ajax({
                url: _newUrl,
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                success: function (result) {
                    ZnodeBase.prototype.HideLoader();
                    $("#" + $("#container_to_update").val()).html(result);
                }
            });
        }
    };
    Catalog.prototype.GetDisplayOrder = function (isDown) {
        var ref = $('#category_Main_Tree').jstree(true), selectedNode = ref.get_selected(true);
        var node1;
        var node2;
        if (isDown) {
            node1 = $("#category_Main_Tree li #" + selectedNode[0].id).next();
            node2 = $("#category_Main_Tree li #" + selectedNode[0].id).next().next();
        }
        else {
            node1 = $("#category_Main_Tree li #" + selectedNode[0].id).prev();
            node2 = $("#category_Main_Tree li #" + selectedNode[0].id).prev().prev();
        }
        if (node1[0] == undefined && node2[0] == undefined)
            return;
        var node1DO = 0;
        var node2DO = 0;
        if (node1[0] != undefined)
            node1DO = parseInt($('#category_Main_Tree').jstree(true).get_node('#' + node1[0].id + ', true').data.displayorder);
        if (node2[0] != undefined)
            node2DO = parseInt($('#category_Main_Tree').jstree(true).get_node('#' + node2[0].id + ', true').data.displayorder);
        var _dispalyorder = 0;
        if (node1DO == node2DO)
            _dispalyorder = Math.round(node1DO / 2);
        else if (isDown && node1[0] != undefined && node2[0] == undefined)
            _dispalyorder = Math.round(node1DO + (node1DO / 2));
        else
            _dispalyorder = Math.round((node1DO + node2DO) / 2);
        return _dispalyorder;
    };
    Catalog.prototype.GetPimCategoryId = function () {
        var ref = $('#category_Main_Tree').jstree(true);
        var selectedNode = ref.get_selected();
        var pimCategoryId = 0;
        if (selectedNode.length > 0)
            pimCategoryId = $('#category_Main_Tree').jstree(true).get_node('#' + selectedNode[0] + ', true').data.PimCategoryId;
        return pimCategoryId;
    };
    Catalog.prototype.Up = function (obj) {
        Catalog.prototype.MoveNode(false);
    };
    Catalog.prototype.Down = function (obj) {
        Catalog.prototype.MoveNode(true);
    };
    Catalog.prototype.MoveNode = function (IsDown) {
        var _PimCategoryId = Catalog.prototype.GetPimCategoryId();
        var _dispalyorder = Catalog.prototype.GetDisplayOrder(IsDown);
        Endpoint.prototype.UpdateDisplayOrder($("#hdnPimCatalogId").val(), _PimCategoryId, _dispalyorder, $("#hdnPimCategoryId").val(), false, function (response) {
            $("#category_Main_Tree").jstree('destroy');
            Catalog.prototype.RebindStructureTreeData(response.FolderJsonTree);
            Catalog.prototype.ReloadTree();
        });
    };
    Catalog.prototype.remove = function () {
        var isRoot = $("#IsRootFolder").val();
        if (isRoot != undefined && isRoot != "" && isRoot == "false") {
            $("#temp_data_to_insert").html('<button type="button" id="btnDeleteFolder" data-toggle="modal" data-target="#CatalogAssociatedCategoryDeletePopup"></button>');
            $("#btnDeleteFolder").click();
            if (window.location.href.indexOf("ManageProfileCatalog") > -1) {
                $("#temp_data_to_insert").html('<button type="button" id="btnDeleteFolder" data-toggle="modal" data-target="#CatalogAssociatedCategoryFromProfileDeletePopup"></button>');
                $("#btnDeleteFolder").click();
            }
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorRootFolderCanNotDelete"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.AssociateCategories = function () {
        var selectedCategoryId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (selectedCategoryId.length > 0) {
            var catalogAssociation = {
                "CatalogId": $("#hdnPimCatalogId").val(),
                "CategoryId": Catalog.prototype.GetPimCategoryId(),
                "CategoryIds": selectedCategoryId,
                "CatalogName": $("#CatalogName").val(),
                "PimCategoryHierarchyId": $("#hdnPimCategoryId").val(),
                "PimCategoryHierarchyIds": selectedCategoryId,
                "ProfileCatalogId": $("#ProfileCatalogId").val()
            };
            Endpoint.prototype.AssociateCategoriesToCatalog(catalogAssociation, function (response) {
                $("#cancle-associated-category").click();
                $("#category_Main_Tree").jstree('destroy');
                Catalog.prototype.RebindStructureTreeData(response.tree);
                Catalog.prototype.BindEvent();
                if (response.status)
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AssociateCategories"), 'success', isFadeOut, fadeOutTime);
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorAssociateCategories"), 'error', isFadeOut, fadeOutTime);
                ZnodeBase.prototype.HideLoader();
            });
        }
        else {
            $("#error-unassociated-category").html("");
            $("#error-unassociated-category").html(ZnodeBase.prototype.getResourceByKeyName("TextSelectCategories"));
        }
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Catalog.prototype.AssociateProducts = function () {
        var selectedProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (selectedProductIds.length > 0) {
            var productAssociationModel = {
                "CategoryId": Catalog.prototype.GetPimCategoryId(),
                "ProductIds": selectedProductIds,
            };
            Endpoint.prototype.AssociateProductsToCatalogCategory(productAssociationModel, function (response) {
                $("#cancle-associated-category").click();
                $('#category_Main_Tree' + ' #' + $("#hdnPimCategoryId").val() + '_anchor').click();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AssociateProducts"), 'success', isFadeOut, fadeOutTime);
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        }
        else {
            $("#error-unassociated-products").html("");
            $("#error-unassociated-products").html(ZnodeBase.prototype.getResourceByKeyName("TextSelectProducts"));
        }
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Catalog.prototype.ConfirmRemoveAssociatedProducts = function () {
        var selectedProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (selectedProductIds.length > 0) {
            $("#temp_data_to_insert").html('<button type="button" id="btnDeleteFolder" data-toggle="modal" data-target="#ConfirmRemoveAssociatedProducts"></button>');
            $("#btnDeleteFolder").click();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextSelectProducts"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.RemoveAssociatedProducts = function (target) {
        if ($("#hdnPimCategoryId").val() > 0) {
            var selectedProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
            if (selectedProductIds.length > 0) {
                var productUnassociationModel = {
                    "CategoryId": Catalog.prototype.GetPimCategoryId(),
                    "ProductIds": selectedProductIds,
                };
                Endpoint.prototype.DeleteAssociateProducts(productUnassociationModel, function (response) {
                    DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeGetCatalogAssociatedProduct").find("#refreshGrid"), response);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RemoveProducts"), 'success', isFadeOut, fadeOutTime);
                });
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextSelectProducts"), 'error', isFadeOut, fadeOutTime);
            }
            DynamicGrid.prototype.ClearCheckboxArray();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextSelectCategories"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.EditCategorySettings = function () {
        if ($("#hdnPimCategoryId").val() > 0) {
            ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Catalog/EditCategorySettings?CatalogId=' + $("#hdnPimCatalogId").val() + '&categoryHierarchyId=' + $('#hdnPimCategoryId').val(), 'target-category-edit-to-display');
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorRootFolderCanNotEdit"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.GetUnassociatedProducts = function () {
        $("#target-categories-to-display").html("");
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Catalog/UnAssociatedProducts?pimCatalogId=' + $("#hdnPimCatalogId").val() + '&pimCategoryId=' + Catalog.prototype.GetPimCategoryId() + '&profileCatalogId=' + $('#hdnProfileCateogryId').val() + '&pimCategoryHierarchyId=' + $("#hdnPimCategoryId").val(), 'target-products-to-display');
    };
    Catalog.prototype.CreateNewCategory = function () {
        window.location.href = "/PIM/Category/Create?catalogId=" + $("#hdnPimCatalogId").val() + "&parentCategoryId=" + $("#hdnPimCategoryId").val();
    };
    Catalog.prototype.CreateNewProduct = function () {
        if ($("#hdnPimCategoryId").val() > 0) {
            window.location.href = "/PIM/Products/Create?familyId=0&catalogId=" + $("#hdnPimCatalogId").val() + "&categoryId=" + Catalog.prototype.GetPimCategoryId() + "&categoryHierarchyId=" + $("#hdnPimCategoryId").val();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextSelectCategories"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.CloseUnassociateProductPopup = function () {
        $("#UnAssociatedProductsToCatalog").html("");
        ZnodeBase.prototype.CancelUpload('target-products-to-display');
        _gridContainerName = "#ZnodeGetCatalogAssociatedProduct";
    };
    Catalog.prototype.CloseUnassociateCategoryPopup = function () {
        ZnodeBase.prototype.CancelUpload('target-categories-to-display');
        _gridContainerName = "#ZnodeGetCatalogAssociatedProduct";
    };
    Catalog.prototype.RemoveAssociatedProductsFromProfileCatalog = function (target) {
        if ($("#hdnPimCategoryId").val() > 0) {
            var selectedProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
            if (selectedProductIds.length > 0) {
                var catalogAssociation = {
                    "CatalogId": $("#hdnPimCatalogId").val(),
                    "CategoryId": Catalog.prototype.GetPimCategoryId(),
                    "ProfileCatalogId": $("#ProfileCatalogId").val(),
                    "PimCategoryHierarchyId": $("#hdnPimCategoryId").val(),
                    "ProductIds": selectedProductIds
                };
                Endpoint.prototype.DeleteAssociateProductsFromProfile(catalogAssociation, function (response) {
                    DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeGetProfileCatalogAssociatedProduct").find("#refreshGrid"), response);
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("RemoveProducts"), 'success', isFadeOut, fadeOutTime);
                });
            }
            else {
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextSelectProducts"), 'error', isFadeOut, fadeOutTime);
            }
            DynamicGrid.prototype.ClearCheckboxArray();
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("TextSelectCategories"), 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.GetUnAssociatedProductsForProfile = function () {
        $("#target-categories-to-display").html("");
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Catalog/UnAssociatedProductsForProfile?pimCatalogId=' + $("#hdnPimCatalogId").val() + '&pimCategoryId=0&profileCatalogId=' + $('#ProfileCatalogId').val() + '&profileId=' + $('#ProfileId').val() + '&pimCatgoryHierarchyId=' + $("#hdnPimCategoryId").val(), 'target-products-to-display');
    };
    Catalog.prototype.setCurrentNode = function (e, data) {
        if (data.parent != "#" && Catalog.prototype.IsFolderNameValid(data.node)) {
            ZnodeBase.prototype.ShowLoader();
            Endpoint.prototype.MoveCategory(data.parent.substring(0, 1) == "j" ? data.parent.split('_')[1] : data.parent, data.node.id, $("#hdnPimCatalogId").val(), function (data) {
                ZnodeBase.prototype.HideLoader();
                $("#category_Main_Tree").jstree('destroy');
                Catalog.prototype.RebindStructureTreeData(data.FolderJsonTree);
                Catalog.prototype.ReloadTree();
                if (data.HasNoError) {
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, 'success', isFadeOut, fadeOutTime);
                }
                else {
                    Catalog.prototype.ReloadTree();
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.Message, 'error', isFadeOut, fadeOutTime);
                }
            });
        }
        else {
            Catalog.prototype.ReloadTree();
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSameNameFolder"), data.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
        }
    };
    Catalog.prototype.ReloadTree = function () {
        $('#category_Main_Tree').jstree("destroy");
        Catalog.prototype.LoadTree();
        Catalog.prototype.BindEvent();
    };
    Catalog.prototype.IsFolderNameValid = function (selectedNode) {
        var mediaStructureTree = $('#category_Main_Tree').jstree(true);
        var siblings = mediaStructureTree.get_children_dom(selectedNode.parent);
        var newNodeId = selectedNode.id;
        var siblingFolderNames = [];
        siblings.find("a.jstree-anchor").each(function () {
            if (this.parentElement.id != newNodeId) {
                siblingFolderNames.push($(this).attr('id').split('_')[0]);
            }
        });
        if (selectedNode.text != null && selectedNode.text != "") {
            return ($.inArray(selectedNode.id, siblingFolderNames) == -1);
        }
        else {
            return false;
        }
    };
    Catalog.prototype.RebindMediaStructureTreeData = function (updatedData) {
        $('#category_Main_Tree').attr('data-tree', updatedData);
    };
    Catalog.prototype.AssociateProductsToProfileCatalog = function () {
        var selectedProductIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (selectedProductIds.length > 0) {
            var catalogAssociation = {
                "CatalogId": $("#hdnPimCatalogId").val(),
                "CategoryId": Catalog.prototype.GetPimCategoryId(),
                "ProfileCatalogId": $("#ProfileCatalogId").val(),
                "ProfileId": $("#ProfileId").val(),
                "PimCategoryHierarchyId": $("#hdnPimCategoryId").val(),
                "ProductIds": selectedProductIds,
            };
            Endpoint.prototype.AssociateProductsToProfileCatalog(catalogAssociation, function (response) {
                $("#cancle-associated-profilecategory").click();
                $('#category_Main_Tree' + ' #' + $("#hdnPimCategoryId").val() + '_anchor').click();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AssociateProducts"), 'success', isFadeOut, fadeOutTime);
            });
        }
        else {
            $("#error-unassociated-products").html("");
            $("#error-unassociated-products").html(ZnodeBase.prototype.getResourceByKeyName("TextSelectProducts"));
        }
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Catalog.prototype.CloseUnassociateProductForProfilePopup = function () {
        ZnodeBase.prototype.CancelUpload('target-products-to-display');
        _gridContainerName = "#ZnodeGetCatalogAssociatedProduct";
    };
    Catalog.prototype.RemoveAssociatedCategoriesFromProfileCatalog = function (control) {
        var ref = $('#category_Main_Tree').jstree(true), selectedNode = ref.get_selected();
        if (selectedNode == null) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectFolderToDelete"), 'error', isFadeOut, fadeOutTime);
        }
        var pimCategoryHierarchyId = $("#hdnPimCategoryId").val();
        var pimCatalogId = $("#hdnPimCatalogId").val();
        var profileCatalogId = $("#ProfileCatalogId").val();
        ZnodeBase.prototype.ShowLoader();
        if (pimCatalogId.length > 0) {
            Endpoint.prototype.DeleteMultipleCatalogAssociatedCategoriesForProfile(pimCatalogId, pimCategoryHierarchyId, profileCatalogId, function (response) {
                ZnodeBase.prototype.HideLoader();
                Catalog.prototype.RebindStructureTreeData(response.FolderJsonTree);
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(response.Message, response.HasNoError ? 'success' : 'error', isFadeOut, fadeOutTime);
                var parentId = ref.get_parent(selectedNode);
                ref.delete_node(selectedNode);
                $('#category_Main_Tree' + ' #' + parentId + '_anchor').click();
                Catalog.prototype.ReloadTree();
            });
        }
    };
    Catalog.prototype.GetUnassociatedCategoryList = function () {
        $("#target-products-to-display").html("");
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Catalog/UnAssociatedCategoriesForProfile?profileCatalogId=' + $("#ProfileCatalogId").val() + '&pimCatalogId=' + $("#hdnPimCatalogId").val() + '&pimCategoryId=' + Catalog.prototype.GetPimCategoryId() + '&pimCategoryHierarchyId=' + $("#hdnPimCategoryId").val(), 'target-categories-to-display');
    };
    Catalog.prototype.GetCatalogPublishStatus = function (zViewAnchor) {
        zViewAnchor.attr("href", "#");
        var pimCatalogId = $(zViewAnchor).attr("data-parameter").split('&')[0].split('=')[1];
        var pimCatalogName = $(zViewAnchor).attr("data-parameter").split('&')[1].split('=')[1];
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Catalog/GetCatalogPublishStatus?pimCatalogId=' + pimCatalogId + '&CatalogName=' + pimCatalogName, 'divCatalogPublishStatusList');
    };
    Catalog.prototype.ValidateDisplayOrderField = function (object) {
        var regex = new RegExp('^\\d{0,}?$');
        var isValid = true;
        if (isNaN($(object).val()) || $(object).val() == '' || $(object).val() == 0) {
            $(object).addClass("input-validation-error");
            if (isNaN($(object).val()))
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("InvalidDisplayOrder"), 'error', isFadeOut, fadeOutTime);
            else
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("DisplayOrderRange"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else if (!regex.test($(object).val())) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("DisplayOrderRange"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    Catalog.prototype.ValidateCatalogNameField = function (object) {
        var isValid = true;
        if ($(object).val() == '') {
            $(object).addClass("input-validation-error");
            if ($(object).val() == '')
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("CatalogNameIsRequired"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    Catalog.prototype.ValidateCatalog = function () {
        $("#CatalogName :input").blur(function () {
            ZnodeBase.prototype.ShowLoader();
            Catalog.prototype.ValidateCatalogName();
            ZnodeBase.prototype.HideLoader();
        });
    };
    Catalog.prototype.ValidateCatalogName = function (catalogName, pimCatalogId) {
        if (catalogName === void 0) { catalogName = ""; }
        if (pimCatalogId === void 0) { pimCatalogId = 0; }
        var isValid = true;
        catalogName = catalogName ? catalogName : $("#CatalogName").val();
        if (catalogName) {
            Endpoint.prototype.IsCatalogNameExist(catalogName, pimCatalogId, function (response) {
                if (!response) {
                    $("#CatalogName").addClass("input-validation-error");
                    $("#errorSpanCatalogName").addClass("error-msg");
                    $("#errorSpanCatalogName").text(ZnodeBase.prototype.getResourceByKeyName("AlreadyExistCatalogName"));
                    $("#errorSpanCatalogName").show();
                    isValid = false;
                }
            });
        }
        ZnodeBase.prototype.HideLoader();
        return isValid;
    };
    Catalog.prototype.ValidateCatalogForm = function () {
        if (Catalog.prototype.ValidateCatalogName() && Catalog.prototype.ValidateDefaultStore())
            return true;
        return false;
    };
    Catalog.prototype.ValidateDefaultStore = function () {
        if ($(".IsAllowIndexing:checked").data("val").toLowerCase() == "enable") {
            var portalId = $("#PortalId").val();
            if (portalId && parseInt(portalId) >= 1) {
                $(".fstNoneSelected").removeClass("input-validation-error");
                $("#errorSpanDefaultStore").hide();
                return true;
            }
            else {
                $(".fstNoneSelected").addClass("input-validation-error");
                $("#errorSpanDefaultStore").text("Please select store to enable the Index Settings").addClass("error-msg").show();
                return false;
            }
        }
        return true;
    };
    Catalog.prototype.BrowseCategories = function (catalogId) {
        $("#target-products-to-display").html("");
        ZnodeBase.prototype.BrowseAsidePoupPanel('/PIM/Catalog/UnAssociatedCategories?pimCatalogId=' + catalogId + '&pimCategoryId=' + Catalog.prototype.GetPimCategoryId() + '&pimCategoryHierarchyId=' + $("#hdnPimCategoryId").val(), 'target-categories-to-display');
    };
    Catalog.prototype.ShowPublishTaskSchedularDetails = function (data) {
        data.attr("href", "#");
        var schedulerName = data.attr("data-parameter").split('&')[0].split('=')[1];
        var schedularCallFor = data.attr("data-parameter").split('&')[1].split('=')[1];
        var footer = "<button type='button' class='popup-panel-close' onclick='ZnodeBase.prototype.CancelUpload(" + '"divCreateSchedularForCatalog"' + ")'><i class='z-close'></i></button>";
        ZnodeBase.prototype.ShowLoader();
        var url = "/PIM/Catalog/CreateScheduler?ConnectorTouchPoints=" + schedulerName + "&schedulerCallFor=" + schedularCallFor;
        Endpoint.prototype.GetPartial(url, function (response) {
            var htmlContent = footer + response;
            $("#divCreateSchedularForCatalog").html(htmlContent);
            $($("#divCreateSchedularForCatalog").find("a.grey")).attr("href", "#");
            $($("#divCreateSchedularForCatalog").find("a.grey")).attr("onclick", "ZnodeBase.prototype.CancelUpload('divCreateScheduler')");
            $("#divCreateSchedularForCatalog").show(700);
            $("body").append("<div class='modal-backdrop fade in'></div>");
            ZnodeBase.prototype.HideLoader();
        });
    };
    Catalog.prototype.CreateScheduler = function () {
        var isValid = SearchConfiguration.prototype.ValidateSchedulerData();
        var schedulerName = $("#SchedulerName").val();
        if (isValid) {
            var erpTaskSchedulerViewModel = {
                "ERPTaskSchedulerId": $("#ERPTaskSchedulerId").val(),
                "IndexName": $("#IndexName").val(),
                "IsEnabled": $("#divSchedulerSetting #IsActive").prop('checked'),
                "SchedulerCallFor": $("#SchedulerCallFor").val(),
                "PortalId": $("#PortalId").val(),
                "PortalIndexId": $("#PortalIndexId").val(),
                "SchedulerFrequency": $('[name=SchedulerFrequency]:checked').val(),
                "SchedulerName": $("#SchedulerName").val(),
                "StartDate": $("#StartDate").val(),
                "StartTime": $("#StartTime").val(),
                "TouchPointName": $("#TouchPointName").val(),
                "SchedulerType": $("#SchedulerType").val(),
                "CronExpression": $("#txtCronExpression").val(),
                "HangfireJobId": $("#HangfireJobId").val()
            };
            if (parseInt($("#ERPTaskSchedulerId").val(), 10) > 0) {
                Endpoint.prototype.EditSearchScheduler(erpTaskSchedulerViewModel, function (response) {
                    if (response.status) {
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SchedulerUpdatedSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divCreateSchedularForCatalog');
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
                        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("SchedulerCreatedSuccessfully"), response.status ? 'success' : 'error', isFadeOut, fadeOutTime);
                        ZnodeBase.prototype.CancelUpload('divCreateSchedularForCatalog');
                        $("#schedulerNameText").val(schedulerName);
                        $("#schedulerName").removeClass("hidden");
                        $(".createScheduler").html("");
                        $(".createScheduler").html("<i class='z-add-circle'></i>" + ZnodeBase.prototype.getResourceByKeyName("UpdateScheduler"));
                    }
                    else {
                        $("#createSchedulerError").text(response.message);
                        $("#createSchedulerError").show();
                    }
                });
            }
        }
    };
    Catalog.prototype.BindTreeView = function () {
        Catalog.prototype.LoadTree();
        Catalog.prototype.BindEvent();
        $('.treesearch').keyup(function () {
            var searchText = $('.treesearch').val();
            var result = $('#category_Main_Tree').jstree('search', searchText);
            if ($(result).find('.jstree-search').length == 0 && searchText != "")
                $('#categorysearchresult').html(ZnodeBase.prototype.getResourceByKeyName("NoResult"));
            else {
                $('#categorysearchresult').html("");
            }
        });
    };
    Catalog.prototype.PublishCatalogCategoryProductsPopup = function (zPublishAnchor) {
        $("#PublishCatalogCategoryProducts").modal('show');
    };
    Catalog.prototype.PublishCatalogCategoryProducts = function () {
        var publishStateData = 'NONE';
        if ($('#radBtnPublishState').length > 0)
            publishStateData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("CategoryPublishSuccessMsg"), "success", true, 1000);
        Endpoint.prototype.PublishCatalogCategoryProducts($('#hdnPimCatalogId').val(), $('#hdnPimCategoryId').val(), publishStateData, function (res) {
            ZnodeProgressNotifier.prototype.InitiateProgressBar(function () {
                DynamicGrid.prototype.RefreshGridNoNotification($("#ZnodeGetCatalogAssociatedProduct").find("#refreshGrid"));
            });
            DynamicGrid.prototype.RefreshGridOndelete($("#ZnodeGetCatalogAssociatedProduct").find("#refreshGrid"), res);
        });
    };
    Catalog.prototype.PublishCatalogSetting = function () {
        var publishStateData = 'NONE';
        var publishStausFormData = '';
        if ($('#radBtnPublishState').length > 0)
            publishStateData = ZnodeBase.prototype.mergeNameValuePairsToString($('#radBtnPublishState').serializeArray());
        if ($('#chkBxPublishStatesChoice').length > 0)
            publishStausFormData = ZnodeBase.prototype.mergeNameValuePairsToString(Catalog.prototype.GetCheckBoxCheckedArrar('chkBxPublishStatesChoice'));
        Catalog.prototype.PublishCatalog(publishStateData, publishStausFormData);
    };
    Catalog.prototype.GetCheckBoxCheckedArrar = function (statesControl) {
        var PublishContentChoice = [];
        $('#' + statesControl).find('input[type=checkbox]:checked').each(function () {
            PublishContentChoice.push({ 'name': $(this).attr('name'), 'value': $(this).val() });
        });
        return PublishContentChoice;
    };
    //Associate category to catalog tree
    Catalog.prototype.AssociateCategoryToCatalog = function () {
        var selectedCategoryId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (selectedCategoryId.length > 0) {
            var categoryAssociationModel = {
                "CatalogId": $("#hdnPimCatalogId").val(),
                "CategoryId": Catalog.prototype.GetPimCategoryId(),
                "CategoryIds": selectedCategoryId,
                "PimCategoryHierarchyId": $("#hdnPimCategoryId").val(),
            };
            Endpoint.prototype.AssociateCategoryToCatalog(categoryAssociationModel, function (response) {
                $("#cancle-associated-category").click();
                $("#category_Main_Tree").jstree('destroy');
                Catalog.prototype.RebindStructureTreeData(response.tree);
                Catalog.prototype.BindEvent();
                if (response.status)
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("AssociateCategories"), 'success', isFadeOut, fadeOutTime);
                else
                    ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorAssociateCategories"), 'error', isFadeOut, fadeOutTime);
                ZnodeBase.prototype.HideLoader();
            });
        }
        else {
            $("#error-unassociated-category").html("");
            $("#error-unassociated-category").html(ZnodeBase.prototype.getResourceByKeyName("TextSelectCategories"));
        }
        DynamicGrid.prototype.ClearCheckboxArray();
    };
    Catalog.prototype.SetDefaultCheckedValue = function () {
        $('input[type^="checkbox"]').each(function () {
            if ($(this).val().toLowerCase() == 'draft') {
                $(this).prop('checked', true);
                return true;
            }
        });
    };
    return Catalog;
}(ZnodeBase));
//# sourceMappingURL=Catalog.js.map