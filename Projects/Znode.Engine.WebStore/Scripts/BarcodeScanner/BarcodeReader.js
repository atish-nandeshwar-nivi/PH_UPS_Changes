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
var Dynamsoft;
var BarcodeReader = /** @class */ (function (_super) {
    __extends(BarcodeReader, _super);
    function BarcodeReader() {
        var _this = _super.call(this) || this;
        _this._iptIndex = 0;
        _this._scanner = null;
        return _this;
    }
    BarcodeReader.prototype.LoadBarcodeScannerScript = function (licenseKey, callbackMethod) {
        if ($('script[data-productKeys]').length == 0) {
            var script = document.createElement('script');
            script.type = "text/javascript";
            script.src = "https://cdn.jsdelivr.net/npm/dynamsoft-javascript-barcode@7.1.3/dist/dbr.min.js";
            script.onload = callbackMethod;
            script.setAttribute("data-productKeys", licenseKey);
            document.body.appendChild(script);
        }
        callbackMethod();
    };
    BarcodeReader.prototype.InitiateBarcodeScanner = function (licenseKey, barcodeFormats, UIElement, callbackOnLoadMethod, callbackResultMethod) {
        BarcodeReader.prototype.LoadBarcodeScannerScript(licenseKey, function () {
            var _this = this;
            if (Dynamsoft != undefined) {
                if (BarcodeReader.prototype._scanner != null) {
                    BarcodeReader.prototype._scanner.onUnduplicatedRead = undefined;
                    BarcodeReader.prototype.StopScanner();
                }
                Dynamsoft.BarcodeScanner.createInstance().then(function (s) {
                    BarcodeReader.prototype._scanner = s;
                    BarcodeReader.prototype._iptIndex = 0;
                    BarcodeReader.prototype._scanner.bAddSearchRegionCanvasToResult = true;
                    var runtimeSettings = BarcodeReader.prototype._scanner.getRuntimeSettings();
                    barcodeFormats.forEach(function (item, index) {
                        if (index == 0) {
                            runtimeSettings.BarcodeFormatIds = BarcodeReader.prototype.GetBarcodeFormatCode(item);
                        }
                        else {
                            runtimeSettings.BarcodeFormatIds += BarcodeReader.prototype.GetBarcodeFormatCode(item);
                        }
                    });
                    BarcodeReader.prototype._scanner.updateRuntimeSettings(runtimeSettings);
                    if (Dynamsoft.BarcodeReader.isLoaded()) {
                        callbackOnLoadMethod(BarcodeReader.prototype._scanner);
                        console.log('Is the loading completed? ' + Dynamsoft.BarcodeReader.isLoaded());
                        console.log('Index? ' + _this._iptIndex);
                        BarcodeReader.prototype._scanner.UIElement = document.getElementById(UIElement);
                        BarcodeReader.prototype._scanner.onFrameRead = function (results) { };
                        BarcodeReader.prototype._scanner.onUnduplicatedRead = function (txt, result) {
                            console.log('result? ' + result);
                            callbackResultMethod(txt, result);
                            if (3 == ++BarcodeReader.prototype._iptIndex) {
                                _this._scanner.onUnduplicatedRead = undefined;
                                BarcodeReader.prototype.StopScanner();
                            }
                        };
                    }
                });
            }
        });
    };
    BarcodeReader.prototype.StartScanner = function (callbackSuccess, callbackFailed) {
        if (BarcodeReader.prototype._scanner != null) {
            BarcodeReader.prototype._scanner.show().then(function (_) { callbackSuccess(); }).catch(function (error) {
                callbackFailed(error);
            });
        }
    };
    BarcodeReader.prototype.StartScannerOnElement = function (UIElement, callbackSuccess, callbackFailed) {
        if (BarcodeReader.prototype._scanner != null) {
            BarcodeReader.prototype._scanner.UIElement = document.getElementById(UIElement);
            BarcodeReader.prototype.StartScanner(callbackSuccess, callbackFailed);
        }
    };
    BarcodeReader.prototype.StopScanner = function () {
        if (BarcodeReader.prototype._scanner != null) {
            BarcodeReader.prototype._scanner.stop();
            BarcodeReader.prototype._scanner.hide();
        }
    };
    BarcodeReader.prototype.PauseScanner = function () {
        if (BarcodeReader.prototype._scanner != null) {
            BarcodeReader.prototype._scanner.pause();
        }
    };
    BarcodeReader.prototype.GetBarcodeFormatCode = function (Code) {
        var barcodeFormatCode;
        switch (Code) {
            case "ONED": {
                barcodeFormatCode = Dynamsoft.EnumBarcodeFormat.OneD;
                break;
            }
            case "QR_CODE": {
                barcodeFormatCode = Dynamsoft.EnumBarcodeFormat.QR_CODE;
                break;
            }
            case "CODABAR": {
                barcodeFormatCode = Dynamsoft.EnumBarcodeFormat.CODABAR;
                break;
            }
            default: {
                barcodeFormatCode = Dynamsoft.EnumBarcodeFormat.QR_CODE;
                break;
            }
        }
        return barcodeFormatCode;
    };
    return BarcodeReader;
}(ZnodeBase));
//# sourceMappingURL=BarcodeReader.js.map