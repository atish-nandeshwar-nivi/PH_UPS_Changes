var CustomJurl = /** @class */ (function () {
    function CustomJurl() {
        this.getHost = function (e) {
            return window.location.href;
        };
        this.t = "";
        this.queryParameters = new Array();
        this.urlParameters = new Array();
        this.hashParameter = new Array();
    }
    CustomJurl.prototype.r = function (e) {
        return e === null || typeof e === "undefined" || this.i(e) === "";
    };
    CustomJurl.prototype.i = function (e) {
        if (e === null || typeof e === "undefined") {
            return e;
        }
        e = e + "";
        return e.replace(/(^\s*)|(\s*$)/g, "");
    };
    CustomJurl.prototype.o = function (e) {
        if (this.r(e)) {
            return {};
        }
        var t = {};
        var n = e.split("&");
        var i;
        for (i = 0; i < n.length; i += 1) {
            var s = n[i].split("=");
            t[s[0]] = "";
            if (s.length > 1) {
                t[s[0]] = s[1];
            }
        }
        return t;
    };
    CustomJurl.prototype.u = function (e) {
        if (this.r(e)) {
            return [];
        }
        var t = [];
        var n = e.split("/");
        var i;
        for (i = 0; i < n.length; i += 1) {
            if (!this.r(n[i])) {
                t.push(n[i]);
            }
        }
        return t;
    };
    CustomJurl.prototype.addUrlParameter = function (e, s) {
        e = this.i(e);
        if (!this.r(e)) {
            if (this.r(s) && isNaN(s)) {
                this.urlParameters.push(e);
            }
            else {
                if (s < this.urlParameters.length) {
                    this.urlParameters.splice(s, 0, e);
                }
            }
        }
        return this.urlParameters;
    };
    CustomJurl.prototype.setQueryParameter = function (e, s) {
        e = this.i(e);
        if (!this.r(e)) {
            this.queryParameters[e] = "";
            if (!this.r(s)) {
                this.queryParameters[e] = s;
            }
        }
        return this.queryParameters;
    };
    CustomJurl.prototype.setHashParameter = function (e) {
        e = this.i(e);
        if (this.r(e)) {
            this.hashParameter = null;
        }
        this.hashParameter = this.i(e);
        return this.hashParameter;
    };
    CustomJurl.prototype.getQueryParameter = function (e) {
        e = this.i(e);
        if (this.r(e) || !this.queryParameters.hasOwnProperty(e)) {
            return null;
        }
        return this.queryParameters[e];
    };
    CustomJurl.prototype.getParameterIndex = function (e) {
        e = this.i(e);
        var t;
        for (t = 0; t < this.urlParameters.length; t += 1) {
            if (this.urlParameters[t] === e) {
                return t;
            }
        }
        return null;
    };
    CustomJurl.prototype.removeUrlParameter = function (e) {
        e = this.i(e);
        if (this.urlParameters.indexOf(e) > -1) {
            this.urlParameters.splice(this.urlParameters.indexOf(e), 1);
        }
        return this.urlParameters;
    };
    CustomJurl.prototype.removeQueryParameter = function (e) {
        e = this.i(e);
        if (this.queryParameters.hasOwnProperty(e)) {
            delete this.queryParameters[e];
        }
        return this.queryParameters;
    };
    CustomJurl.prototype.build = function (baseUrl, data) {
        var e = baseUrl;
        var t = [], i;
        for (i in data) {
            if (data.hasOwnProperty(i)) {
                var s = i;
                var o = data[i];
                if (!this.r(o)) {
                    s += "=" + o;
                }
                t.push(s);
            }
        }
        if (t.length > 0) {
            if (baseUrl.indexOf("?") > -1) {
                e += "&" + t.join("&");
            }
            else {
                e += "?" + t.join("&");
            }
        }
        return e;
    };
    return CustomJurl;
}());
//# sourceMappingURL=CustomJurl.js.map