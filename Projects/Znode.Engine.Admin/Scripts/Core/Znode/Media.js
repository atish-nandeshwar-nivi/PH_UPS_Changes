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
var MediaEdit = /** @class */ (function (_super) {
    __extends(MediaEdit, _super);
    function MediaEdit() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    MediaEdit.prototype.Init = function () {
    };
    MediaEdit.prototype.ReplaceMedia = function () {
        document.getElementById("txtUpload").onchange = function (e) {
            var totalFiles = e.target.files.length;
            $("#fileuploadstatus").hide();
            $("#fileName").text("");
            $('#fileuploadstatus table tbody').html("");
            $("#isMediaReplace").val("false");
            if (totalFiles > 0) {
                var file = e.target.files[0];
                var filename = file.name.toLowerCase();
                var filetype = $("#Type").val().toLowerCase();
                //Validate file type
                if (!filename.match(filetype)) {
                    var tpl = '<tr class="working" id="' + file.name + '"><td><span class="filename">' + file.name + '<span></td><td>' + MediaEdit.prototype.formatFileSize(file.size) + '</td><td class="status">Extension not allowed</td><td></td></tr>';
                    if ($('#fileuploadstatus table tbody').find('tr[id="' + file.name + '"]').length === 0)
                        $('#fileuploadstatus table tbody').append(tpl);
                    $("#fileuploadstatus").show();
                    return false;
                }
                else {
                    $("#isMediaReplace").val("true");
                    MediaEdit.prototype.readImageFile(file);
                    return true;
                }
            }
            return false;
        };
    };
    MediaEdit.prototype.formatFileSize = function (bytes) {
        if (typeof bytes !== 'number') {
            return '';
        }
        if (bytes >= 1000000000) {
            return (bytes / 1000000000).toFixed(2) + ' GB';
        }
        if (bytes >= 1000000) {
            return (bytes / 1000000).toFixed(2) + ' MB';
        }
        return (bytes / 1000).toFixed(2) + ' KB';
    };
    MediaEdit.prototype.readImageFile = function (file) {
        var reader = new FileReader();
        reader.onload = function (fr) {
            $('#impPrev').attr('src', fr.currentTarget["result"]);
            $("#Size").val(MediaEdit.prototype.formatFileSize(file.size));
            var img = new Image();
            img.src = fr.currentTarget["result"];
            img.addEventListener("load", function () {
                $("#Width").val(this.width + " pixels");
                $("#Height").val(this.height + " pixels");
            });
        };
        reader.readAsDataURL(file);
    };
    MediaEdit.prototype.ValidateImageAndSaveToServer = function (file, totalFiles) {
        if (($("#frmMediaEdit").valid()) && ($("#isMediaReplace").val() == "true") && (totalFiles > 0)) {
            var data = new FormData();
            data.append("file", file);
            var mediaId = $("#MediaId").val();
            var folderId = $("#isMediaReplace").data("val");
            var fileNameold = $("#FileName").val();
            CommonHelper.prototype.GetAjaxHeaders(function (response) {
                if (response.Authorization.match("^Authorization: ")) {
                    response.Authorization = response.Authorization.replace('Authorization: ', '');
                }
                $.ajax({
                    type: "POST",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", response.Authorization);
                        xhr.setRequestHeader("Znode-UserId", response.ZnodeAccountId);
                        xhr.setRequestHeader("Znode-DomainName", response.DomainName);
                        xhr.setRequestHeader("Token", response.Token);
                    },
                    url: response.ApiUrl + "/apiupload/upload?folderid=" + folderId + "&filetype=" + file.type + "&isMediaReplace=" + $("#isMediaReplace").val() + "&mediaId=" + mediaId + "&filename=" + fileNameold + "",
                    contentType: false,
                    dataType: "json",
                    processData: false,
                    data: data,
                    async: false,
                    success: function (data1) {
                    },
                    error: function (error) {
                        var jsonValue = JSON.parse(error.responseText);
                    }
                });
            });
        }
        return true;
    };
    return MediaEdit;
}(ZnodeBase));
//# sourceMappingURL=Media.js.map