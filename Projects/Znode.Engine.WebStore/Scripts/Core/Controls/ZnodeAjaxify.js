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
//Parses extended directives on the view and replaces them all with their own dynamic content.
//Extended Directives:
//<z-widget-ajax>...</z-widget-ajax>
var _znodeAjaxifyOnLoadAllSubscriptions = [];
var _znodeAjaxifyDirectives = [];
var _znodeAjaxifyDirectivesArray;
var _znodeAjaxifyOnLoadSubscriptions = [];
var ZnodeAjaxify = /** @class */ (function (_super) {
    __extends(ZnodeAjaxify, _super);
    function ZnodeAjaxify() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    ZnodeAjaxify.prototype.Init = function () {
    };
    //Applies this plug-in on per need basis and replace all the extended directives with their ajax place holders.
    ZnodeAjaxify.prototype.Apply = function (onLoadAllCallback, onLoadCallback) {
        if (onLoadAllCallback === void 0) { onLoadAllCallback = null; }
        if (onLoadCallback === void 0) { onLoadCallback = null; }
        _znodeAjaxifyDirectives = this._buildAjaxifiedDirectiveQueue();
        _znodeAjaxifyDirectivesArray = new _ZnodeAjaxifiedDirectives(_znodeAjaxifyDirectives);
        //Subscribe to the events to trigger supplied callbacks.
        if (onLoadCallback)
            this.OnLoad(onLoadCallback);
        if (onLoadAllCallback)
            this.OnLoadAll(onLoadAllCallback);
        _znodeAjaxifyDirectives.forEach(function (directive, index, array) {
            ZnodeAjaxify.prototype._renderDirective(directive, _znodeAjaxifyDirectivesArray);
        });
    };
    ZnodeAjaxify.prototype.OnLoadAll = function (callback) {
        _znodeAjaxifyOnLoadAllSubscriptions.push(callback);
    };
    ZnodeAjaxify.prototype.OnLoad = function (callback) {
        _znodeAjaxifyOnLoadSubscriptions.push(callback);
    };
    ZnodeAjaxify.prototype._renderDirective = function (directive, directivesArray) {
        var directiveType = directive.DirectiveType;
        switch (directiveType) {
            case 'widget':
                ZnodeAjaxify.prototype._renderWidget(directive, directivesArray);
                break;
            case 'partial':
                ZnodeAjaxify.prototype._renderPartial(directive, directivesArray);
                break;
            default:
                var identifier = directive.Identifier;
                console.error("Invalid 'type' provided for one of the '<z-**> tags having identifier '" + identifier + "'. Skipping this element.");
                break;
        }
    };
    ZnodeAjaxify.prototype._renderPartial = function (directive, directivesArray) {
        var actionName = $(directive.Directive).attr('data-actionName');
        var controllerName = $(directive.Directive).attr('data-controllerName');
        var parameters = JSON.parse($(directive.Directive).attr('data-parameters'));
        var identifier = $(directive.Directive).attr('data-identifier');
        var replaceTargetSelector = $(directive.Directive).attr('data-replaceTargetSelector');
        var url = '/' + controllerName + '/' + actionName;
        if (url && url.length > 0) {
            try {
                jQuery.get(url, parameters, function (data, status, jqXHR) {
                    if (jqXHR.status == 200) {
                        //Success.
                        $(directive.Directive).html(data);
                        // target can be any Element or other EventTarget.
                        ZnodeAjaxify.prototype._triggerLoadEvent(directive.Directive);
                        directive.MarkOnLoad();
                        directivesArray.MarkOnLoad();
                        if (directivesArray.IsLoaded == true)
                            ZnodeAjaxify.prototype._checkAndTriggerLoadAll();
                    }
                    if (replaceTargetSelector && replaceTargetSelector.length > 0) {
                        $.each($(replaceTargetSelector), function (index, replaceTargetElement) {
                            if (replaceTargetElement)
                                $(replaceTargetElement).empty();
                        });
                    }
                    $(directive.Directive).prev().hide();
                }, 'html');
            }
            catch ( //Additional routine here to run in case of failure 
            _a) { //Additional routine here to run in case of failure 
                $(directive.Directive).prev().hide();
            }
        }
        else
            console.error("'Url' can not be built for one of the '<z-**> tags having identifier '" + identifier + "'. Skipping this element.");
    };
    ZnodeAjaxify.prototype._renderWidget = function (directive, directivesArray) {
        var url = '/dynamicContent/widget';
        if (url && url.length > 0) {
            url += '?' + this._processDataParams(directive.Directive);
            try {
                jQuery.get(url, null, function (data, status, jqXHR) {
                    if (jqXHR.status == 200) {
                        //Success.
                        $(directive.Directive).html(data);
                        ZnodeAjaxify.prototype._triggerLoadEvent(directive.Directive);
                        directive.MarkOnLoad();
                        directivesArray.MarkOnLoad();
                        if (directivesArray.IsLoaded == true)
                            ZnodeAjaxify.prototype._checkAndTriggerLoadAll();
                    }
                    $(directive.Directive).prev().hide();
                }, 'html');
            }
            catch ( //Additional routine here to run in case of failure 
            _a) { //Additional routine here to run in case of failure 
                $(directive.Directive).prev().hide();
            }
        }
    };
    ZnodeAjaxify.prototype._processDataParams = function (element) {
        var uriParts = [];
        $.each($(element).data(), function (key, value) {
            uriParts.push(key + '=' + (ZnodeAjaxify.prototype._isObject(value) === true ? encodeURIComponent(JSON.stringify(value)) : value));
        });
        return uriParts.join('&');
    };
    ZnodeAjaxify.prototype._buildAjaxifiedDirectiveQueue = function () {
        var directiveArray = [];
        var extendedDirectives = ["z-widget-ajax", 'z-ajax'];
        extendedDirectives.forEach(function (value, i, array) {
            $(value).each(function (index, element) {
                directiveArray.push(new _ZnodeAjaxifiedDirective(element));
            });
        });
        return directiveArray;
    };
    ZnodeAjaxify.prototype._triggerLoadEvent = function (element) {
        var subscriptions = _znodeAjaxifyOnLoadSubscriptions;
        if (subscriptions && subscriptions.length > 0) {
            // Create the event.
            var event_1 = document.createEvent('CustomEvent');
            // Define that the event name is 'onZnodeDirectiveLoad'.
            event_1.initEvent('onZnodeDirectiveLoad', true, true);
            // Listen for the event.
            element.addEventListener('onZnodeDirectiveLoad', function (e) {
                // e.target matches elem
                subscriptions.forEach(function (callback, index, arr) {
                    callback(e);
                });
            }, false);
            element.dispatchEvent(event_1);
        }
    };
    ZnodeAjaxify.prototype._checkAndTriggerLoadAll = function () {
        var subscriptions = _znodeAjaxifyOnLoadAllSubscriptions;
        var directives = _znodeAjaxifyDirectives;
        directives.forEach(function (directive, index, arr) {
            if (directive.IsLoaded != true) {
                return;
            }
            //If it reaches here, all the directives have been loaded.
            // Create the event.
            var event = document.createEvent('CustomEvent');
            // Define that the event name is 'onZnodeDirectiveLoadAll'.
            event.initEvent('onZnodeDirectiveLoadAll', true, true);
            // Listen for the event.
            document.addEventListener('onZnodeDirectiveLoadAll', function (e) {
                // e.target matches elem
                subscriptions.forEach(function (callback, index, arr) {
                    callback(e);
                });
            }, false);
            document.dispatchEvent(event);
        });
    };
    ZnodeAjaxify.prototype._isObject = function (obj) {
        return obj !== undefined && obj !== null && obj.constructor == Object;
    };
    return ZnodeAjaxify;
}(ZnodeBase));
var _ZnodeAjaxifyEventModel = /** @class */ (function () {
    function _ZnodeAjaxifyEventModel(_event, _type) {
        this.Event = null;
        this.EventType = null;
        this.Event = _event;
        this.EventType = _type;
    }
    return _ZnodeAjaxifyEventModel;
}());
var _ZnodeAjaxifiedDirective = /** @class */ (function () {
    function _ZnodeAjaxifiedDirective(_directive) {
        this.Directive = null;
        this.DirectiveType = null;
        this.IsLoaded = false;
        this.Identifier = null;
        this.Directive = _directive;
        this.DirectiveType = $(_directive).attr('data-type').toLowerCase();
        this.Identifier = $(_directive).attr('data-identifier');
    }
    _ZnodeAjaxifiedDirective.prototype.MarkOnLoad = function () {
        this.IsLoaded = true;
    };
    return _ZnodeAjaxifiedDirective;
}());
var _ZnodeAjaxifiedDirectives = /** @class */ (function () {
    function _ZnodeAjaxifiedDirectives(_directives) {
        this.Directives = null;
        this.IsLoaded = false;
        this.Directives = _directives;
    }
    _ZnodeAjaxifiedDirectives.prototype.MarkOnLoad = function () {
        this.IsLoaded = true;
        for (var i = 0; i < this.Directives.length; i++) {
            if (this.Directives[i].IsLoaded == false) {
                this.IsLoaded = false;
                break;
            }
        }
    };
    return _ZnodeAjaxifiedDirectives;
}());
//# sourceMappingURL=ZnodeAjaxify.js.map