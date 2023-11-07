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
var StoreLocator = /** @class */ (function (_super) {
    __extends(StoreLocator, _super);
    function StoreLocator() {
        return _super.call(this) || this;
    }
    StoreLocator.prototype.Init = function () {
        if ($("#map").length > 0) {
            navigator.geolocation.getCurrentPosition(function (position) {
                if ($("#Latitude").val() == null || $("#Latitude").val() == "") {
                    $("#Latitude").val(position.coords.latitude);
                    $("#Longitude").val(position.coords.longitude);
                    StoreLocator.prototype.GetLatLng();
                }
            }, function (error) {
                StoreLocator.prototype.GetLatLng();
            }, {
                enableHighAccuracy: true
            });
        }
        Account.prototype.BindStates();
    };
    //Get co-ordinates of address
    StoreLocator.prototype.GetLatLng = function () {
        _super.prototype.ajaxRequest.call(this, _super.prototype.GetGeoLocatorAPI.call(this) + '?address='
            + $("#Address2").val() + ',+'
            + $("#Address3").val() + ',+'
            + $("#PostalCode").val() + ',+'
            + $("#CityName").val() + ',+'
            + $("#StateName").val() + ',+'
            + $("#ddlCountryList").val() + '&key=' + _super.prototype.GetGeoLocatorAPIKey.call(this), "GET", {}, function (data) {
            if (data.status == "OK") {
                //Other responses : 
                //ZERO_RESULTS(indicates that the geocode was successful but returned no results.This may occur if the geocoder was passed a non- existent address), 
                //OVER_QUERY_LIMIT(indicates that you are over your quota), 
                //REQUEST_DENIED(indicates that your request was denied), 
                //INVALID_REQUEST(generally indicates that the query (address, components or latlng) is missing), 
                //UNKNOWN_ERROR ( indicates that the request could not be processed due to a server error. The request may succeed if you try again.)
                $("#Latitude").val(data.results[0]
                    .geometry
                    .location
                    .lat);
                $("#Longitude").val(data.results[0]
                    .geometry
                    .location
                    .lng);
                initMap();
            }
            else {
                if (data.error_message == null) {
                    ZnodeBase.prototype.errorAsAlert = false;
                    ZnodeBase.prototype.errorOutfunction("Invalid address");
                }
                else {
                    ZnodeBase.prototype.errorAsAlert = false;
                    ZnodeBase.prototype.errorOutfunction(data.error_message);
                }
            }
            initMap();
        }, "json");
    };
    return StoreLocator;
}(ZnodeBase));
//# sourceMappingURL=StoreLocator.js.map