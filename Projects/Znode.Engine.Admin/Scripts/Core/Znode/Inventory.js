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
var Inventory = /** @class */ (function (_super) {
    __extends(Inventory, _super);
    function Inventory() {
        return _super.call(this) || this;
    }
    Inventory.prototype.Init = function () {
        Inventory.prototype.AutocompleteSku();
        $(document).on("change", "#txtUpload", function () {
            Import.prototype.ValidateImportedFileType();
        });
    };
    Inventory.prototype.DeleteInventory = function (control) {
        var inventoryListIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (inventoryListIds.length > 0) {
            Endpoint.prototype.DeleteInventory(inventoryListIds, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Inventory.prototype.DeleteMultipleSKUInventory = function (control) {
        var inventoryId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (inventoryId.length > 0) {
            Endpoint.prototype.DeleteMultipleSKUInventory(inventoryId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Inventory.prototype.ExportInventoryData = function () {
        var listCode = "";
        $("#grid").find("tr").each(function () {
            if ($(this).find(".grid-row-checkbox").length > 0) {
                if ($(this).find(".grid-row-checkbox").is(":checked")) {
                    listCode = $(this).find("td")[1].innerHTML;
                }
            }
        });
        var inventoryListIds = [];
        $("#ZnodeInventoryList").find("tr").each(function () {
            if ($(this).find(".grid-row-checkbox").length > 0) {
                if ($(this).find(".grid-row-checkbox").is(":checked")) {
                    var id = $(this).find(".grid-row-checkbox").attr("id").split("_")[1];
                    inventoryListIds.push(id);
                }
            }
        });
        if (inventoryListIds.length == 1) {
            window.location.href = "/Inventory/ExportInventoryData?inventoryListIds=" + inventoryListIds + "&listCode=" + listCode;
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorSelectAtMostOneInventoryList"), "error", false, 10000);
        }
    };
    //Validate inventory sku.
    Inventory.prototype.ValidateInventorySKU = function (object, defaultInventoryRoundOff, message, colname) {
        var regex = new RegExp('^\\d{0,}(\\.\\d{0,' + defaultInventoryRoundOff + '})?$');
        switch (colname) {
            case "Quantity":
                return Inventory.prototype.ValidateQuantity(object, regex, message);
            case "ReOrderLevel":
                return Inventory.prototype.ValidateReOrderLevel(object, regex, message);
        }
    };
    //Validate quantity in inline editing.
    Inventory.prototype.ValidateQuantity = function (object, regex, message) {
        var isValid = true;
        var qtyValue = $(object).val();
        if (!qtyValue) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorProductQuantity"), 'error', isFadeOut, fadeOutTime);
            $(object).addClass("input-validation-error");
            isValid = false;
        }
        else if (!regex.test(qtyValue)) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(message, 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else if (parseInt(qtyValue, 10) > 0 && parseInt(qtyValue, 10) > 999999) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorNumberRange"), 'error', isFadeOut, fadeOutTime);
            $(object).addClass("input-validation-error");
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    //Validate reorder level in inline editing.
    Inventory.prototype.ValidateReOrderLevel = function (object, regex, message) {
        var isValid = true;
        var reorderLevelValue = $(object).val();
        if (!reorderLevelValue) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorProductReOrderLevel"), 'error', isFadeOut, fadeOutTime);
            $(object).addClass("input-validation-error");
            isValid = false;
        }
        else if (!regex.test(reorderLevelValue)) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(message, 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else if (Number(reorderLevelValue) < 0 || Number(reorderLevelValue) > 999999) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorReorderLevelValue"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    //Method for Auto complete Sku
    Inventory.prototype.AutocompleteSku = function () {
        $("#txtSKU").autocomplete({
            source: function (request, response) {
                try {
                    Endpoint.prototype.GetProductListBySKU(request.term, function (res) {
                        if (res.ProductAttributeValues.length > 0) {
                            var attributeValues = new Array();
                            res.ProductAttributeValues.forEach(function (attributeValue) {
                                if (attributeValue != undefined)
                                    attributeValues.push(attributeValue.AttributeValue);
                            });
                            if ($.inArray(request.term, attributeValues) == -1)
                                Inventory.prototype.isSKUValid = false;
                            else
                                Inventory.prototype.isSKUValid = true;
                            response($.map(res.ProductAttributeValues, function (item) {
                                return {
                                    label: item.AttributeValue,
                                };
                            }));
                        }
                        else {
                            Inventory.prototype.isSKUValid = false;
                            $(".ui-autocomplete").hide();
                        }
                    });
                }
                catch (err) {
                }
            },
            select: function (event, ui) {
                Inventory.prototype.isSKUValid = true;
            }
        }).focusout(function () {
            return Inventory.prototype.ValidateSKU();
        });
    };
    //Method for Validate SKU
    Inventory.prototype.ValidateSKU = function () {
        if ($.isFunction($.fn.getTierPriceData)) {
            $.fn.getTierPriceData();
        }
        var rowLength = $('#tierPriceQuantity tr').length;
        if (rowLength == 1) {
            if ($("#tierQuantity").val() != "" && $("#priceTier").val() == "") {
                $("#error-price").html(ZnodeBase.prototype.getResourceByKeyName("TierPriceIsRequired"));
                $("#error-quantity").html("");
                return false;
            }
            else if ($("#tierQuantity").val() == "" && $("#priceTier").val() != "") {
                $("#error-quantity").html(ZnodeBase.prototype.getResourceByKeyName("MinimumQuantityIsRequired"));
                $("#error-price").html("");
                return false;
            }
            else {
                $("#error-price").html("");
                $("#error-quantity").html("");
            }
        }
        else {
            if ($("#tierQuantity").val() != "" && $("#priceTier").val() == "") {
                $("#error-price").html(ZnodeBase.prototype.getResourceByKeyName("TierPriceIsRequired"));
                $("#error-quantity").html("");
                return false;
            }
            else if ($("#tierQuantity").val() == "" && $("#priceTier").val() != "") {
                $("#error-quantity").html(ZnodeBase.prototype.getResourceByKeyName("MinimumQuantityIsRequired"));
                $("#error-price").html("");
                return false;
            }
            else if ($("#tierQuantity").val() == "" && $("#priceTier").val() == "") {
                $("#error-price").html(ZnodeBase.prototype.getResourceByKeyName("TierPriceIsRequired"));
                $("#error-quantity").html(ZnodeBase.prototype.getResourceByKeyName("MinimumQuantityIsRequired"));
                return false;
            }
            else {
                $("#error-price").html("");
                $("#error-quantity").html("");
            }
        }
        var flag = true;
        if (Inventory.prototype.isSKUValid != undefined && !Inventory.prototype.isSKUValid) {
            Products.prototype.ShowErrorMessage(ZnodeBase.prototype.getResourceByKeyName("InvalidSKU"), $("#txtSKU"), $("#valSKU"));
            return flag = false;
        }
        else {
            Products.prototype.HideErrorMessage($("#txtSKU"), $("#valSKU"));
        }
        var mindate = new Date($("#PriceSKU_ActivationDate").val());
        var maxdate = new Date($("#PriceSKU_ExpirationDate").val());
        if ((mindate > maxdate)) {
            $("#spamDate").html(ZnodeBase.prototype.getResourceByKeyName("ErrorActivationDate"));
            flag = false;
        }
        return flag;
    };
    Inventory.prototype.ValidateProductKey = function (object, colname) {
        switch (colname) {
            case "DownloadableProductKey":
                return Inventory.prototype.ValidateDownloadableProductKey(object);
            case "DownloadableProductURL":
                return Inventory.prototype.ValidateDownloadableProductURL(object);
        }
    };
    Inventory.prototype.GetInventoryBySKU = function () {
        if ($("#IsDownloadable").val() == "True")
            return;
        ZnodeBase.prototype.ShowLoader();
        var sku = $('[id^=SKU]').val();
        var date = new Date();
        var warehouseId = $("#WarehouseId").val();
        if ((sku == undefined || sku == "") ||
            (warehouseId == undefined || warehouseId == "")) {
            $("#Quantity").val("");
            $("#ReOrderLevel").val("");
            $("#InventoryId").val("");
            $("#BackOrderQuantity").val("");
            $("#BackOrderExpectedDate").val("");
            $("#BackOrderExpectedDate").datepicker("setDate", date);
            $('#BackOrderExpectedDate').val("").datepicker("update");
            ZnodeBase.prototype.HideLoader();
            return;
        }
        Endpoint.prototype.GetInventoryBySKU(sku, warehouseId, function (response) {
            if (response.status) {
                $("#Quantity").val(response.quantity);
                $("#ReOrderLevel").val(response.reOrderLevel);
                $("#InventoryId").val(response.inventoryId);
                $("#BackOrderQuantity").val(response.backOrderQuantity);
                $("#BackOrderExpectedDate").val(response.backOrderExpectedDate);
                if (response.backOrderExpectedDate)
                    $("#BackOrderExpectedDate").datepicker("setDate", response.backOrderExpectedDate);
                else {
                    $("#BackOrderExpectedDate").datepicker("setDate", date);
                    $('#BackOrderExpectedDate').val("").datepicker("update");
                }
            }
            else {
                $("#Quantity").val("");
                $("#ReOrderLevel").val("");
                $("#InventoryId").val(0);
                $("#BackOrderQuantity").val("");
                $("#BackOrderExpectedDate").val("");
                $("#BackOrderExpectedDate").datepicker("setDate", date);
                $('#BackOrderExpectedDate').val("").datepicker("update");
            }
            ZnodeBase.prototype.HideLoader();
        });
    };
    //Add downloadable product keys.
    Inventory.prototype.AddDownloadableProductKeyResult = function (data) {
        if (!data.status) {
            var array = data.list;
            var index, len;
            for (index = 0, len = array.length; index < len; ++index) {
                if (array[index].IsDuplicate) {
                    $("#error-productKey_" + array[index].rowIndexId + "").removeClass("field-validation-valid");
                    $("#error-productKey_" + array[index].rowIndexId + "").addClass("field-validation-error");
                    $("#error-productKey_" + array[index].rowIndexId + "").html("This key is already exists.");
                    $("#error-productKey_" + array[index].rowIndexId + "").show();
                    $('#downloadableProductError').hide();
                }
                else {
                    $("#error-productKey_" + array[index].rowIndexId + "").html("");
                    $('#downloadableProductError').hide();
                }
            }
            if (data.hasError) {
                $('#downloadableProductError').show();
            }
        }
        else {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(data.message, "success", data.status, 5000);
            $("#divAsidePanelDownloadableProduct").html("");
            $("#divAsidePanelDownloadableProduct").hide();
            ZnodeBase.prototype.RemovePopupOverlay();
            ZnodeBase.prototype.ShowLoader();
            $("#" + 'ZnodePimDownloadableProductKeyForInventory').find(".btn-search").click();
            GridPager.prototype.UpdateHandler();
            Inventory.prototype.UpdateInventoryList();
            ZnodeBase.prototype.HideLoader();
        }
    };
    Inventory.prototype.ValidateDownloadableProductKey = function (object) {
        var isValid = true;
        if ($(object).val() == '') {
            $(object).addClass("input-validation-error");
            if ($(object).val() == '')
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ProductKeyIsRequired"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        if ($("#productKey").val() == "") {
            $("#error-productKey_0").html("");
        }
        return isValid;
    };
    //Method for Delete Downloadable Prduct Key.
    Inventory.prototype.DeleteDownloadablePrductKey = function (control) {
        var downloadablePrductKey = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (downloadablePrductKey.length > 0) {
            Endpoint.prototype.DeleteDownloadablePrductKey(downloadablePrductKey, function (response) {
                DynamicGrid.prototype.RefreshGridOndelete(control, response);
            });
        }
    };
    Inventory.prototype.GetInventoryDetailBySKU = function () {
        ZnodeBase.prototype.ShowLoader();
        var sku = $("#SKU").val();
        Endpoint.prototype.GetInventoryDetailBySKU(sku, function (response) {
            $("#Quantity").val((response.data ? response.data.Quantity : ""));
            $("#QuantityInventory").val((response.data ? response.data.IsDownloadable ? response.data.Quantity : "" : "0"));
            $("#ReOrderLevel").val((response.data ? response.data.ReOrderLevel : ""));
            $("#InventoryId").val((response.data ? response.data.InventoryId : ""));
            ZnodeBase.prototype.HideLoader();
        });
    };
    Inventory.prototype.ValidateDownloadableProductURL = function (object) {
        var url = $(object).val();
        var res = url.match(/(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g);
        var isValid = true;
        if ($(object).val() == '') {
            $(object).addClass("input-validation-error");
            if ($(object).val() == '')
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ProductUrlIsRequired"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else if (res == null) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ProductUrlIsRequired"), 'error', isFadeOut, fadeOutTime);
            isValid = false;
        }
        else {
            $(object).remove("input-validation-error");
            $(object).removeClass("input-validation-error");
            isValid = true;
        }
        return isValid;
    };
    Inventory.prototype.ImportInventory = function () {
        if (Import.prototype.ValidateTemplateName() &&
            Import.prototype.ValidateImportFileType()) {
            var templateName = "";
            if ($("#templateList").val() > 0) {
                templateName = $("#templateList option:selected").text();
            }
            else {
                templateName = $("#TemplateName").val();
            }
            var ImportViewModels = {
                ImportHeadId: $("#ImportHeadId").val(),
                ImportType: $("#ImportType").val(),
                TemplateId: $("#templateList").val(),
                TemplateName: templateName,
                FileName: $("#ChangedFileName").val(),
                IsPartialPage: true
            };
            Endpoint.prototype.ImportPost(ImportViewModels, function (res) {
                $('#divinventoryImport').html('');
                $('#divinventoryImport').modal('hide');
                setTimeout(function () {
                    ZnodeBase.prototype.HideLoader();
                    window.location.href = window.location.protocol + "//" + window.location.host + "/Inventory/InventorySKUList";
                }, 900);
            });
        }
    };
    Inventory.prototype.ImportTool = function () {
        Endpoint.prototype.GetImportInventoryView(function (res) {
            $('#divinventoryImport').html(res);
            $('#divinventoryImport').modal('show');
        });
    };
    Inventory.prototype.UpdateInventoryList = function () {
        Endpoint.prototype.GetDownloadableProductKeys($("#hdnProductSKU").val(), $("#hdnProductId").val(), $("#hdnInventoryId").val(), function (response) {
            $('#GetDownloadableProductKeys').html("");
            $('#GetDownloadableProductKeys').html(response);
            Inventory.prototype.HideUsedDownloadableKeyEditLink();
        });
    };
    Inventory.prototype.HideUsedDownloadableKeyEditLink = function () {
        $("#GetDownloadableProductKeys #grid").find("tr").each(function () {
            if ($(this).find(".z-isused .z-active").length > 0) {
                $(this).find(".z-edit").hide();
            }
        });
    };
    return Inventory;
}(ZnodeBase));
$(document).on("click", "#inventorySample", function (e) {
    setTimeout(function () { ZnodeBase.prototype.HideLoader(); }, 1000);
});
//# sourceMappingURL=Inventory.js.map