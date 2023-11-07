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
var Profiles = /** @class */ (function (_super) {
    __extends(Profiles, _super);
    function Profiles() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    Profiles.prototype.Init = function () {
        $(document).on("UpdateGrid", Profiles.prototype.RefreshGridOnEdit);
    };
    Profiles.prototype.DeleteProfiles = function (control) {
        var profileId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (profileId.length > 0) {
            Endpoint.prototype.DeleteProfiles(profileId, function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Profiles.prototype.AssociateCatalogs = function (profileId, catalogId) {
        if (catalogId.length > 0) {
            Endpoint.prototype.AssociateCatalogToProfile(profileId, catalogId, function (res) {
                if (res.status) {
                    Endpoint.prototype.GetProfileCatalogList(profileId, function (res) {
                        DynamicGrid.prototype.ClearCheckboxArray();
                        $("#ZnodeProfileAssociatedCatalogList").html(res);
                    });
                }
                $("#divUnassociatedCatalogListPopup").hide(700);
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
            ZnodeBase.prototype.RemoveAsidePopupPanel();
        }
        else {
            $("#divAssociatedProfileCatalogsError").show();
        }
    };
    Profiles.prototype.GetUnassociatedCatalog = function (profileId) {
        DynamicGrid.prototype.ClearCheckboxArray();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Profiles/GetProfileUnAssociatedCatalogList?profileId=' + profileId, 'divUnassociatedCatalogListPopup');
    };
    Profiles.prototype.GetUnassociatedShipping = function (profileId) {
        DynamicGrid.prototype.ClearCheckboxArray();
        ZnodeBase.prototype.BrowseAsidePoupPanel('/Profiles/GetUnAssociatedShippingList?profileId=' + profileId + '&portalId=' + $("#PortalId").val(), 'divUnassociatedShippingListPopup');
    };
    Profiles.prototype.AssociateShipping = function (profileId) {
        var shippingIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (shippingIds.length > 0) {
            Endpoint.prototype.AssociateShipping(profileId, shippingIds, function (res) {
                if (res.status) {
                    Endpoint.prototype.GetAssociatedShippingList(profileId, $("#PortalId").val(), function (res) {
                        DynamicGrid.prototype.ClearCheckboxArray();
                        $("#ZnodeAssociatedShippingListToProfile").html(res);
                    });
                }
                $("#divUnassociatedShippingListPopup").hide(700);
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? 'success' : 'error', isFadeOut, fadeOutTime);
            });
            ZnodeBase.prototype.RemoveAsidePopupPanel();
        }
        else {
            $("#divAssociatedProfileShippingError").show();
        }
    };
    Profiles.prototype.UnAssociateAssociatedShipping = function (control) {
        var shippingId = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (shippingId.length > 0) {
            Endpoint.prototype.UnAssociateAssociatedShipping(shippingId, $("#ProfileId").val(), function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Profiles.prototype.AssociatePaymentSetting = function (portalId) {
        ZnodeBase.prototype.ShowLoader();
        var linkTaxClassIds = DynamicGrid.prototype.GetMultipleSelectedIds('ZnodePayment');
        if (linkTaxClassIds.length > 0)
            Endpoint.prototype.AssociatePaymentSettingForProfiles(linkTaxClassIds, portalId, function (res) {
                Endpoint.prototype.GetAssociatedPaymentListForProfiles(portalId, $("#PortalId").val(), function (response) {
                    $("#AssociatedPaymentListToProfile").html('');
                    $("#AssociatedPaymentListToProfile").html(response);
                    GridPager.prototype.UpdateHandler();
                });
                $("#DivGetUnAssociatedPaymentSettingListForStore").hide(700);
                ZnodeBase.prototype.RemovePopupOverlay();
                ZnodeNotification.prototype.DisplayNotificationMessagesHelper(res.message, res.status ? "success" : "error", isFadeOut, fadeOutTime);
                DynamicGrid.prototype.ClearCheckboxArray();
                ZnodeBase.prototype.HideLoader();
                ZnodeBase.prototype.RemoveAsidePopupPanel();
            });
        else {
            $('#associatedTaxClass').show();
            ZnodeBase.prototype.HideLoader();
        }
    };
    Profiles.prototype.RemoveAssociatedPaymentSetting = function (control) {
        var taxClassIds = DynamicGrid.prototype.GetMultipleSelectedIds();
        if (taxClassIds.length > 0) {
            Endpoint.prototype.RemoveAssociatedPaymentSettingForProfiles(taxClassIds, $("#ProfileId").val(), function (res) {
                DynamicGrid.prototype.RefreshGridOndelete(control, res);
            });
        }
    };
    Profiles.prototype.ValidateProfile = function (object, defaultInventoryRoundOff, message, colname) {
        var regex = new RegExp('^\\d{0,}(\\.\\d{0,})?$');
        switch (colname) {
            case "Weighting":
                return Profiles.prototype.ValidateWeighting(object, regex, message);
            case "ProfileName":
                return Profiles.prototype.ValidateProfileName(object, regex, message);
            case "DefaultExternalAccountNo":
                return Profiles.prototype.ValidateProfileCode(object, regex, message);
        }
    };
    Profiles.prototype.RefreshGridOnEdit = function () {
        if ($('#AssociatedPaymentListToProfile').length > 0)
            Profiles.prototype.ProfilePaymentUpdateResult();
        else if ($('#ZnodeAssociatedShippingListToProfile').length > 0)
            Profiles.prototype.ProfileShippingUpdateResult();
    };
    Profiles.prototype.ProfilePaymentUpdateResult = function () {
        $("[update-container-id='AssociatedPaymentListToProfile'] #refreshGrid").click();
    };
    Profiles.prototype.ProfileShippingUpdateResult = function () {
        $("[update-container-id='ZnodeAssociatedShippingListToProfile'] #refreshGrid").click();
    };
    Profiles.prototype.ValidateWeighting = function (object, regex, message) {
        var isValid = true;
        var qtyValue = $(object).val();
        if (!qtyValue) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorEnterWighting"), 'error', isFadeOut, fadeOutTime);
            $(object).addClass("input-validation-error");
            isValid = false;
        }
        else if (!regex.test(qtyValue)) {
            $(object).addClass("input-validation-error");
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorOnlyNumericValue"), 'error', isFadeOut, fadeOutTime);
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
    Profiles.prototype.ValidateProfileName = function (object, regex, message) {
        var isValid = true;
        var qtyValue = $(object).val();
        if (!qtyValue) {
            ZnodeNotification.prototype.DisplayNotificationMessagesHelper(ZnodeBase.prototype.getResourceByKeyName("ErrorProfileName"), 'error', isFadeOut, fadeOutTime);
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
    Profiles.prototype.ValidateProfileCode = function (object, regex, message) {
        var isValid = true;
        return isValid;
    };
    return Profiles;
}(ZnodeBase));
//# sourceMappingURL=Profiles.js.map