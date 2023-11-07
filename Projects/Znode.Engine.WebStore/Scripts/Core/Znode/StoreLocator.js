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
                }
            }, function (error) { }, {
                enableHighAccuracy: true
            });
        }
    };
    //Get co-ordinates of address
    StoreLocator.prototype.GetLatLng = function (callback) {
        console.log(_super.prototype.GetGeoLocatorAPI.call(this) + '?address='
            + $("#PostalCode").val() + ',+'
            + $("#CityName").val() + ',+'
            + $("#StateName").val() + '&key=' + _super.prototype.GetGeoLocatorAPIKey.call(this));
        _super.prototype.ajaxRequest.call(this, _super.prototype.GetGeoLocatorAPI.call(this) + '?address='
            + $("#PostalCode").val() + ',+'
            + $("#CityName").val() + ',+'
            + $("#StateName").val() + '&key=' + _super.prototype.GetGeoLocatorAPIKey.call(this), "GET", {}, function (data) {
            console.log(data);
            if (data.status == "OK") {
                //Other responses : 
                //ZERO_RESULTS(indicates that the geocode was successful but returned no results.This may occur if the geocoder was passed a non- existent address), 
                //OVER_QUERY_LIMIT(indicates that you are over your quota), 
                //REQUEST_DENIED(indicates that your request was denied), 
                //INVALID_REQUEST(generally indicates that the query (address, components or latlng) is missing), 
                //UNKNOWN_ERROR ( indicates that the request could not be processed due to a server error. The request may succeed if you try again.)
                var browserLocation = {
                    lat: data.results[0]
                        .geometry
                        .location
                        .lat,
                    lng: data.results[0]
                        .geometry
                        .location
                        .lng
                };
                callback(browserLocation, data.status);
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
                callback(null, data.status);
            }
        }, "json");
    };
    //Show/hide store locations in grid
    StoreLocator.prototype.showDistanceWiseData = function () {
        document.getElementById('right-panel').innerHTML = "";
        $(".storeLocationCoordinate").each(function (index, storeLocation) {
            //Show/hide store locations in grid
            var storeDistance = $(storeLocation).data("distance");
            if (parseFloat(storeDistance) <= parseFloat($("#Radius").val()))
                $(storeLocation).show();
            else
                $(storeLocation).hide();
            //If distance could not be calculated
            if ($("#Radius").val() == 0)
                $(storeLocation).show();
        });
        initMap();
    };
    return StoreLocator;
}(ZnodeBase));
//# sourceMappingURL=StoreLocator.js.map