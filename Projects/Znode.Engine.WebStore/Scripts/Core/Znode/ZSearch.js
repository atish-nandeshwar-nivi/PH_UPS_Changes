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
var totalPages = 0;
var ZSearch = /** @class */ (function (_super) {
    __extends(ZSearch, _super);
    function ZSearch() {
        return _super.call(this) || this;
    }
    ZSearch.prototype.Init = function () {
        $.getScript("/Scripts/lib/purl.js");
        ZSearch.prototype.SearchSort();
        ZSearch.prototype.NextClickFunction();
        ZSearch.prototype.PrevClickFunction();
        totalPages = parseInt($("#hdnTotalPages").val(), 10);
    };
    // BINDINGS
    // Redirects to new search results page when the sorting dropdown is changed
    // Uses purl library
    ZSearch.prototype.SearchSort = function () {
        $("#layout-search .search-sorting select").on("change", function () {
            $("#layout-search .search-results").html('<div class="search-results-wait">...</div>');
            var url = purl(), query = url.param();
            query.sort = $(this).val();
            query.pagenumber = 1;
            window.location.href = url.attr("path") + "?" + $.param(query) + "#product-grid";
        });
        ZSearch.prototype.SearchPaging();
    };
    ZSearch.prototype.SearchPaging = function () {
        $("#layout-paging .search-paging select").on("change", function () {
            $("#layout-search .search-results").html('<div class="search-results-wait">...</div>');
            var url = purl(), query = url.param();
            query.pageSize = $(this).val();
            query.pagenumber = 1;
            window.location.href = url.attr("path") + "?" + $.param(query) + "#product-grid";
        });
    };
    ZSearch.prototype.SetPager = function (control, mode) {
        var currentPageNo = $(control).data("pageno");
        if (currentPageNo == "") {
            currentPageNo = 1;
        }
        if (mode == 1) {
            currentPageNo++;
        }
        else
            currentPageNo--;
        var url = purl(), query = url.param();
        query.pageSize = $("#PageSize").val();
        query.pagenumber = currentPageNo;
        window.location.href = url.attr("path") + "?" + $.param(query);
    };
    ZSearch.prototype.GetQueryStringParameterByName = function (name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    };
    ZSearch.prototype.PrevClickFunction = function () {
        $(".prev-page-search").on("click", function () {
            var pageno = ZSearch.prototype.GetQueryStringParameterByName("pagenumber");
            if (totalPages == 1) {
                $('.prev-page-search').addClass('disabled');
                return false;
            }
            if (parseInt(pageno) == 1) {
                $('.prev-page-search').addClass('disabled');
                return false;
            }
            ZSearch.prototype.SetPager(this, 0);
        });
    };
    ZSearch.prototype.NextClickFunction = function () {
        $(".next-page-search").on("click", function () {
            var pageno = ZSearch.prototype.GetQueryStringParameterByName("pagenumber");
            if (totalPages == 1) {
                $('.next-page-search').addClass('disabled');
                return false;
            }
            if (parseInt(pageno) == (totalPages)) {
                $('.next-page-search').addClass('disabled');
                return false;
            }
            ZSearch.prototype.SetPager(this, 1);
        });
    };
    return ZSearch;
}(ZnodeBase));
//# sourceMappingURL=ZSearch.js.map