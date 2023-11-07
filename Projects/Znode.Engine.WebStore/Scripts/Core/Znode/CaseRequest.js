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
var CaseRequest = /** @class */ (function (_super) {
    __extends(CaseRequest, _super);
    function CaseRequest() {
        return _super.call(this) || this;
    }
    CaseRequest.prototype.Init = function () {
        CaseRequest.prototype.ValidationForContactUsForm();
        CaseRequest.prototype.ValidationForCustomerFeedbackForm();
    };
    //Set validation for inputs
    CaseRequest.prototype.ValidationForContactUsForm = function () {
        $("#contact-us").on("click", function () {
            var flag = true;
            //Set required field for first name
            var firstName = $("#valFirstName").val();
            if (firstName.length < 1) {
                $("#valFirstNameErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredFirstName"));
                flag = false;
            }
            else {
                $("#valFirstNameErr").html("");
            }
            //Set required field for last name
            var lastName = $("#valLastName").val();
            if (lastName.length < 1) {
                $("#valLastNameErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredLastName"));
                flag = false;
            }
            else {
                $("#valLastNameErr").html("");
            }
            //Set required field for comment
            var comment = $("#valComment").val();
            if (comment.length < 1) {
                $("#valCommentErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredComment"));
                flag = false;
            }
            else {
                $("#valCommentErr").html("");
            }
            //Validate phone number
            var phoneNum = $("#valPhoneNum").val();
            if (phoneNum.length < 1) {
                $("#valPhoneNumErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredPhoneNumber"));
                flag = false;
            }
            //Validate email address
            var email = $("#valEmail").val();
            if (email.length < 1) {
                $("#valEmailErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredEmailId"));
                flag = false;
            }
            else {
                $("#valEmailErr").html("");
                var regex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!regex.test(email)) {
                    $("#valEmailErr").html(ZnodeBase.prototype.getResourceByKeyName("ErrorEmailAddress"));
                    flag = false;
                }
            }
            return flag;
        });
        //Set Validate Captcha Code for ContactUs form
        $("#formCreateCaseRequest").on("submit", function () {
            var captcha = $("#CaptchaInputText").val();
            $("#valueCaptchaError").html("");
            if (typeof captcha != undefined && captcha != null && captcha != "") {
                $("#contact-us").prop("disabled", true).addClass("disabled");
            }
            $("#contact-captcha").html("");
        });
    };
    //Set validation for Customer Feedback Form
    CaseRequest.prototype.ValidationForCustomerFeedbackForm = function () {
        $("#customer-feedback").on("click", function () {
            var flag = true;
            var FirstName = $("#FirstName").val();
            if (FirstName.length < 1) {
                $("#valFirstNameErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredFirstName"));
                flag = false;
            }
            var LastName = $("#LastName").val();
            if (LastName.length < 1) {
                $("#valLastNameErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredLastName"));
                flag = false;
            }
            //Validate email address
            var email = $("#valEmailAddress").val();
            if (email.length < 1) {
                $("#valEmailAddressErr").html(ZnodeBase.prototype.getResourceByKeyName("RequiredEmailId"));
                flag = false;
            }
            else {
                $("#valEmailAddressErr").html("");
                var regex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!regex.test(email)) {
                    $("#valEmailAddressErr").html(ZnodeBase.prototype.getResourceByKeyName("ErrorEmailAddress"));
                    flag = false;
                }
            }
            return flag;
        });
        //Set Validate Captcha Code for Customer Feedback Form
        $("#formCreateCustomerFeedback").submit(function (event) {
            $("#valueCaptchaError").html("");
        });
    };
    return CaseRequest;
}(ZnodeBase));
//# sourceMappingURL=CaseRequest.js.map