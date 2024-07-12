/* 공용 폼 데이터 submit */
function ComSubmit(opt_formId) {
    this.formId = gfn_isEmpty(opt_formId) == true ? "commonForm" : opt_formId;
    this.url = "";

    if (this.formId == "commonForm") {
        $("#commonForm").empty();
    }

    this.setUrl = function setUrl(url) {
        this.url = url;
    };

    this.addParam = function addParam(key, value) {
        $("#" + this.formId).append($("<input type='hidden' name='" + key + "' id='" + key + "' value='" + value + "' >"));
    };

    this.submit = function submit() {
        var frm = $("#" + this.formId)[0];
        frm.action = this.url;
        frm.method = "post";
        frm.submit();
    };
}

/* 공통 폼 데이터 Ajax */
var fv_ajaxCallback = "";

function ComAjax(opt_formId) {
    this.url = "";
    this.formId = gfn_isEmpty(opt_formId) == true ? "commonForm" : opt_formId;
    this.param = "";

    if (this.formId == "commonForm") {
        var frm = $("#commonForm");
        if (frm.length > 0) {
            frm.remove();
        }
        var str = "<form id='commonForm' name='commonForm'></form>";
        $('body').append(str);
    }

    this.setUrl = function setUrl(url) {
        this.url = url;
    };

    this.setCallback = function setCallback(callBack) {
        fv_ajaxCallback = callBack;
    };

    this.addParam = function addParam(key, value) {
        this.param = this.param + "&" + key + "=" + value;
    };

    this.ajax = function ajax() {
        if (this.formId != "commonForm") {
            this.param += "&" + $("#" + this.formId).serialize();
        }
        $.ajax({
            url: this.url,
            type: "POST",
            data: this.param,
            async: false,
            success: function (data, status) {
                if (typeof (fv_ajaxCallback) == "function") {
                    fv_ajaxCallback(data);
                } else {
                    eval(fv_ajaxCallback + "(data);");
                }
            }
            /*
            ,beforeSend:function() {
                $('.wrap-loading').removeClass('display-none');
            },complete:function() {
                $('.wrap-loading').addClass('display-none');
            }
            */
        });
    };
}

//ajax 공통 기본 콜백
function gfn_defaultCallback(data) {
    if (!this.gfn_isEmpty(data.resultMsg)) {
        alert(data.resultMsg);
    }
    if (data.result) {
        document.location.reload();
    }
}

// ajax response data를 특정 폼에 DOM의 name기준으로 value에 입력
function gfn_setDataVal(dataMap, objId) {
    var array = new Array();
    $("#" + objId + " [name]").each(function () {
        array.push($(this).attr("name"));
    });

    $.each(dataMap, function (key, value) {
        if (array[$.inArray(key, array)] == key) {
            if (key == "mpNo") {
                $("#" + objId + " [name=" + key + "]").val(gfn_viewTelNo(value));
            } else if (key == "telNo") {
                $("#" + objId + " [name=" + key + "]").val(gfn_viewTelNo(value));
            } else if (key.indexOf("Amt") > -1) {
                $("#" + objId + " [name=" + key + "]").val(gfn_comma(value));
            } else {
                $("#" + objId + " [name=" + key + "]").val(value);
            }
        }
    });
}

//ajax response data를 특정 폼에 DOM의 name기준으로 text에 입력
function gfn_setDataText(dataMap, objId) {
    var array = new Array();
    $("#" + objId + " [name]").each(function () {
        //console.log($(this).attr("name"));
        array.push($(this).attr("name"));
    });

    $.each(dataMap, function (key, value) {
        if (array[$.inArray(key, array)] == key) {
            if (key == "mpNo") {
                $("#" + objId + " [name=" + key + "]").html(gfn_viewTelNo(value));
            } else if (key == "telNo") {
                $("#" + objId + " [name=" + key + "]").html(gfn_viewTelNo(value));
            } else if (key.indexOf("Amt") > -1) {
                $("#" + objId + " [name=" + key + "]").html(gfn_comma(value));
            } else {
                $("#" + objId + " [name=" + key + "]").html(value);
            }
        }
    });
}

/* 마스킹 처리 */

//이름
function gfn_maskCusNm(str) {
    if (str == undefined || str === '') {
        return '';
    }
    var firstStr = str.substr(0, 1);
    var lastStr = str.substr(str.length - 1, 1);
    var star = "";
    for (var i = 0; i < str.length - 2; i++) {
        star += "*";
    }
    str = firstStr + star + lastStr;
    return str;
}

// 주민번호 
function gfn_maskSsnNo(str) {
    if (str == undefined || str === '') {
        return '';
    }
    str = str.replace(/-/g, '').replace(/([0-9]{6})([0-9]{7})/g, "$1-$2");
    return str.replace(/.{6}$/, "******");
}

// 이메일
function gfn_maskEmail(str) {
    if (str == undefined || str === '') {
        return '';
    }

    var at = str.indexOf("@");
    var firstStr = str.substr(0, at);
    var lastStr = str.substr(at + 1, str.length);
    var star = "";

    for (var i = 0; i < firstStr.length - 4; i++) {
        star += "*";
    }

    firstStr = firstStr.substr(0, 4) + star;
    str = firstStr + "@" + lastStr;
    return str;
}

// 휴대전화번호
function gfn_maskMpNo(str) {
    var pattern = /^(\d{3})-?(\d{1,2})\d{2}-?\d(\d{3})$/;
    var result = "";
    if (!str) return result;

    if (pattern.test(str)) {
        result = str.replace(pattern, '$1-$2**-*$3');
    } else {
        result = "***";
    }
    return result;
}

/* 형 변환 */

// 숫자 3자리마다 콤마 추가
function gfn_comma(str) {
    return str.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

//콤마 제거
function gfn_uncomma(str) {
    return str.toString().replace(/[^\d]+/g, '');
}

// 0자리수 2자리로 조정
function gfn_2digits($num) {
    $num < 10 ? $num = '0' + $num : $num;
    return $num.toString();
}

// 휴대전화번호
function gfn_viewMpNo(num, type) {
    var formatNum = '';
    if (num.length == 11) {
        if (type == 0) {
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-****-$3');
        } else {
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        }
    } else if (num.length == 8) {
        formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
    } else {
        if (num.indexOf('02') == 0) {
            if (type == 0) {
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-****-$3');
            } else {
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
            }
        } else {
            if (type == 0) {
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-***-$3');
            } else {
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
            }
        }
    }
    return formatNum;
}

//숫자를 한글로 변환
function gfn_viewKorean(num) {
    var hanA = new Array("", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구", "십");
    var danA = new Array("", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천", "", "십", "백", "천");
    var result = "";
    for (i = 0; i < num.length; i++) {
        str = "";
        han = hanA[num.charAt(num.length - (i + 1))];
        if (han != "")
            str += han + danA[i];
        if (i == 4) str += "만 ";
        if (i == 8) str += "억 ";
        if (i == 12) str += "조 ";
        result = str + result;
    }
    if (num != 0)
        //result = result + "원";
        result = result;
    return result;
}

// 숫자를 전화번호 형식으로 변환
function gfn_viewTelNo(num, type) {
    var formatNum = '';
    if (num.length == 11) {
        if (type == 0) {
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-****-$3');
        } else {
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        }
    } else if (num.length == 8) {
        formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
    } else {
        if (num.indexOf('02') == 0) {
            if (type == 0) {
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-****-$3');
            } else {
                formatNum = num.replace(/(\d{2})(\d{3})(\d{4})/, '$1-$2-$3');
            }
        } else {
            if (type == 0) {
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-***-$3');
            } else {
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
            }
        }
    }
    return formatNum;
}

// 숫자를 계좌번호 형식(농협)으로 변환
function gfn_viewNHAcntNo(num) {
    return num.replace(/(\d{3})(\d{4})(\d{4})(\d{2})/, '$1-$2-$3-$4');
}

// 문자열 내 특수문자 변환
function gfn_replaceChar(str) {
    str = str.replace(/\&/g, "");
    str = str.replace(/\@/g, "");
    str = str.replace(/\'/g, "\"");
    str = str.replace(/\"/g, "\"");
    str = str.replace(/\$/g, "달러");
    str = str.replace(/\%/g, "퍼센트");
    return str;
}


/* validate */

// 빈 값인지 체크
function gfn_isEmpty(str) {
    if (str == null) return true;
    if (str == "NaN") return true;
    if (str.trim() == "") return true;
    var chkStr = new String(str);
    if (chkStr.valueOf() == "undefined") return true;
    if (chkStr == null) return true;
    if (chkStr.toString().length == 0) return true;
    return false;
}

// 주민번호 유효성 체크
function gfn_isSsnNo(ssnNo) {
    var input = ssnNo.replace(/-/gi, "");
    var mul = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5];
    var sum = 0;

    for (var i = 0; i < mul.length; i++) {
        var digit = parseInt(input[i]);
        sum += digit * mul[i];
    }

    var eleven_spare = sum % 11;
    var confirm_num = 11 - eleven_spare;

    if (confirm_num > 9) {
        confirm_num -= 10;
    }

    if (confirm_num == parseInt(input[input.length - 1]) && input.length == 13) {
        return true;
    } else {
        return false;
    }
}

//사업자번호 유효성 체크
function gfn_isBizNo(bizNo) {
    var input = bizNo.replace(/-/gi, "");
    if (input.length == 10) {
        if (gfn_isNumeric(bizNo, "5")) {
            var checkArr = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1);
            var tmpBizNo, i, chkSum = 0, c2, remainder;
            for (i = 0; i <= 7; i++) {
                chkSum += checkArr[i] * bizNo.charAt(i);
            }
            c2 = "0" + (checkArr[8] * bizNo.charAt(8));
            c2 = c2.substring(c2.length - 2, c2.length);
            chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1));
            remainder = (10 - (chkSum % 10)) % 10;

            if (Math.floor(bizNo.charAt(9)) == remainder) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}

// 법인번호 유효성 체크
function gfn_isCrprtnNo(crprtnNo) {
    var input = crprtnNo.replace(/-/gi, "");
    if (input.length == 13) {
        if (gfn_isNumeric(crprtnNo, "5")) {
            var crprtnNoArr = crprtnNo.split("");
            var checkArr = new Array(1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2);
            var iSumCrprtnNo = 0;
            var iCheckDigit = 0;

            for (i = 0; i < 12; i++) {
                iSumCrprtnNo += eval(crprtnNoArr[i]) * eval(checkArr[i]);
            }

            iCheckDigit = 10 - (iSumCrprtnNo % 10);
            iCheckDigit = iCheckDigit % 10;

            if (iCheckDigit == crprtnNoArr[12]) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}

// 휴대전화번호 형식 체크
function gfn_isMpNo(mpNo) {
    var regExp = /(0[1|7][0|1|6|9|7])(\d{3}|\d{4})(\d{4}$)/g;
    var result = regExp.exec(mpNo.replace(/-/gi, ""));
    if (result) return true;
    else return false;
}

// 한글로만 되어 있는지 체크
function gfn_isKoreanOnly(koreanChar) {
    if (koreanChar == null) return false;

    for (var i = 0; i < koreanChar.length; i++) {
        var c = koreanChar.charCodeAt(i);
        //( 0xAC00 <= c && c <= 0xD7A3 ) 초중종성이 모인 한글자
        //( 0x3131 <= c && c <= 0x318E ) 자음 모음
        if (!((0xAC00 <= c && c <= 0xD7A3) || (0x3131 <= c && c <= 0x318E))) {
            return false;
        }
    }
    return true;
}

// 숫자 체크
function gfn_isNumber(num) {
    var reg = /^\d+$/;
    return reg.test(num);
}

// 옵션에 따른 숫자 체크
function gfn_isNumeric(num, opt) {
    // trim 처리
    num = String(num).replace(/^\s+|\s+$/g, "");
    num = num.replace(/,/g, "");

    if (typeof opt == "undefined" || opt == "1") {
        // 모든 10진수 (부호 선택, 자릿수구분기호 선택, 소수점 선택)
        var regex = /^[+\-]?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+) {1}(\.[0-9]+)?$/g;
    } else if (opt == "2") {
        // 부호 미사용, 자릿수구분기호 선택, 소수점 선택
        var regex = /^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+) {1}(\.[0-9]+)?$/g;
    } else if (opt == "3") {
        // 부호 미사용, 자릿수구분기호 미사용, 소수점 선택
        var regex = /^[0-9]+(\.[0-9]+)?$/g;
    } else if (opt == "4") {
        // 한 자리 숫자만(부호 미사용, 자릿수구분기호 미사용, 소수점 미사용)
        var regex = /^[0-9]$/g;
    } else {
        // 숫자만(부호 미사용, 자릿수구분기호 미사용, 소수점 미사용)
        var regex = /^\d+$/;
    }

    if (regex.test(num)) {
        return isNaN(num) ? false : true;
    } else {
        return false;
    }
}

// 비밀번호 유효성 체크
function gfn_isPswrd(pswrd) {
    var num = pswrd.search(/[0-9]/g);
    var eng = pswrd.search(/[a-z]/ig);
    var spe = pswrd.search(/[`~!@#$%&^*|\\\\'\";:\/?]/gi);
    var ban1 = pswrd.search(/&/gi);
    var ban2 = pswrd.search(/@@/gi);

    if (pswrd.length < 8 || pswrd.length > 20) {
        alert("비밀번호는 8~20자리 이내로 입력해 주세요.");
        return false;
    }
    if (pswrd.search(/\s/) != -1) {
        alert("비밀번호는 공백없이 입력해 주세요.");
        return false;
    }
    if (num < 0 || eng < 0 || spe < 0) {
        alert("비밀번호는 영문,숫자,특수문자(~,!,# 등)를 조합하여 입력해 주세요.");
        return false;
    }

    if (ban1 > -1) {
        alert("비밀번호에서 특수문자 '&'는 보안 정책상 사용하실 수 없습니다.");
        return false;
    }

    if (ban2 > -1) {
        alert("비밀번호에서 특수문자 '@@'는 보안 정책상 사용하실 수 없습니다.");
        return false;
    }
    return true;
}

// 이메일 체크
function gfn_isEmail(email) {
    if (!gfn_validateEmail(email)) {
        alert('이메일 형식이 올바르지 않습니다.');
        return false;
    }
    return true;
}

// 이메일 검증
function gfn_validateEmail(email) {

    if (email.includes(" ")) {
        return false;
    }

    const indexOfAt = email.indexOf("@");
    if (indexOfAt === -1) {
        return false;
    }

    const localPart = email.substring(0, indexOfAt);
    if (!localPart.length) {
        return false;
    }

    const domainPart = email.substring(indexOfAt + 1);
    if (!domainPart.length || !domainPart.includes(".")) {
        return false;
    }

    const indexOfLastDot = domainPart.lastIndexOf(".");
    if (indexOfLastDot === -1 || indexOfLastDot === domainPart.length - 1) {
        return false;
    }
    return true;
}

// form내 input 검증
function gfn_validateForm(formId) {
    var validate = true;
    $("#" + formId + " .hasValue").each(function () {
        if (validate) {
            if ($(this).attr("type") == "checkbox") {
                if (!$(this).prop("checked")) {
                    validate = false;
                }
            } else {
                validate = !gfn_isEmpty($(this).val());
            }

            if (!validate) {
                if ($(this).attr("type") == "checkbox") {
                    alert("필수 항목에 체크해 주세요.");
                    validate = false;
                    $(this).focus();
                } else {
                    var labelText = $($(this).next()).text();
                    alert("필수 항목을 입력해 주세요.[" + labelText + "]");
                    validate = false;
                    $(this).focus();
                }
            }
        }
    });

    $("#" + formId + " .numberOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isNumeric($(this).val(), "5");
            if (!validate) {
                var labelText = $($(this).next()).text();
                alert("숫자로만 입력해 주세요.[" + labelText + "]");
                validate = false;
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .floatOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isNumeric($(this).val(), "3");
            if (!validate) {
                var labelText = $($(this).next()).text();
                alert("숫자(소숫점 가능)로만 입력해 주세요.[" + labelText + "]");
                validate = false;
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .commaOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            var testVal = $(this).val().replace(/,/g, "");
            validate = gfn_isNumeric(testVal, "5");
            if (!validate) {
                var labelText = $($(this).next()).text();
                alert("숫자로만 입력해 주세요.[" + labelText + "]");
                validate = false;
                $(this).focus();
            } else {
                $(this).val(testVal);
            }
        }
    });

    $("#" + formId + " .mpNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isMpNo($(this).val());
            if (!validate) {
                alert("휴대전화번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .emailOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isEmail($(this).val());
            if (!validate) {
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .pswrdOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isPswrd($(this).val());
            if (!validate) {
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .pswrdReOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isPswrd($(this).val());
            if (!validate) {
                $(this).focus();
            } else {
                if ($("#" + formId + " .pswrdOnly").val() != $(this).val()) {
                    alert("비밀번호를 확인해 주세요.");
                    validate = false;
                    $(this).focus();
                }
            }
        }
    });

    $("#" + formId + " .ssnNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isSsnNo($(this).val());
            if (!validate) {
                alert("주민등록번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .bizNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isBizNo($(this).val());
            if (!validate) {
                alert("사업자번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .crprtnNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isCrprtnNo($(this).val());
            if (!validate) {
                alert("법인번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .dateSize6Only").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isDateSize6($(this).val());
            if (!validate) {
                alert("년월일 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + formId + " .dateSize8Only").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isDateSize8($(this).val());
            if (!validate) {
                alert("년월 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    return validate;
}

// div내 input 검증
function gfn_validate(objId) {
    var validate = true;
    $("#" + objId + " .hasValue").each(function () {
        if (validate) {
            if ($(this).attr("type") == "checkbox") {
                if (!$(this).prop("checked")) {
                    validate = false;
                }
            } else {
                validate = !gfn_isEmpty($(this).val());
            }

            if (!validate) {
                if ($(this).attr("type") == "checkbox") {
                    var labelText = $(this).data("name");
                    alert("필수 항목에 체크해 주세요.[" + labelText + "]");
                    validate = false;
                    $(this).focus();
                } else {
                    var labelText = $(this).data("name");
                    alert("필수 항목을 입력해 주세요.[" + labelText + "]");
                    validate = false;
                    $(this).focus();
                }
            }
        }
    });

    $("#" + objId + " .numberOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isNumeric($(this).val(), "5");
            if (!validate) {
                var labelText = $(this).data("name");
                alert("숫자로만 입력해 주세요.[" + labelText + "]");
                validate = false;
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .floatOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isNumeric($(this).val(), "3");
            if (!validate) {
                var labelText = $(this).data("name");
                alert("숫자(소숫점 가능)로만 입력해 주세요.[" + labelText + "]");
                validate = false;
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .commaOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            var testVal = $(this).val().replace(/,/g, "");
            validate = gfn_isNumeric(testVal, "5");
            if (!validate) {
                var labelText = $(this).data("name");
                alert("숫자로만 입력해 주세요.[" + labelText + "]");
                validate = false;
                $(this).focus();
            } else {
                $(this).val(testVal);
            }
        }
    });

    $("#" + objId + " .mpNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isMpNo($(this).val());
            if (!validate) {
                alert("휴대전화번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .emailOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isEmail($(this).val());
            if (!validate) {
                $(this).focus();
            }
        }
    });


    $("#" + objId + " .pswrdOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isPswrd($(this).val());
            if (!validate) {
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .pswrdReOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isPswrd($(this).val());
            if (!validate) {
                $(this).focus();
            } else {
                if ($("#" + objId + " .pswrdOnly").val() != $(this).val()) {
                    alert("비밀번호를 확인해 주세요.");
                    validate = false;
                    $(this).focus();
                }
            }
        }
    });

    $("#" + objId + " .ssnNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isSsnNo($(this).val());
            if (!validate) {
                alert("주민등록번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .bizNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isBizNo($(this).val());
            if (!validate) {
                alert("사업자번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .crprtnNoOnly").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isCrprtnNo($(this).val());
            if (!validate) {
                alert("법인번호 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .dateSize6Only").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isDateSize6($(this).val());
            if (!validate) {
                alert("년월일 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    $("#" + objId + " .dateSize8Only").each(function () {
        if (validate && !gfn_isEmpty($(this).val())) {
            validate = gfn_isDateSize8($(this).val());
            if (!validate) {
                alert("년월 형식이 맞지 않습니다.");
                $(this).focus();
            }
        }
    });

    return validate;
}

const gfn_validateInputsInForm = $form => {
    $.each($form.find(".hasValue"), (idx, item) => {
        // console.log($(item), $(item).val());
        if (gfn_isEmpty($(item).val())) {
            const labelText = $(item)[0].alt;
            alert("필수 항목을 입력해 주세요. [" + labelText + "]");
            $(item).focus();
            throw new Error("validateFormInput hasValue");
        }
    });

    $.each($form.find(".numberOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isNumeric($(item).val(), "5")) {
            const labelText = $($(item.closest("div")).prev()).text();
            alert("숫자로만 입력해 주세요.[" + labelText + "]");
            $(item).focus();
            throw new Error("validateFormInput numberOnly");
        }
    });

    $.each($form.find(".floatOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isNumeric($(item).val(), "3")) {
            const labelText = $($(item.closest("div")).prev()).text();
            alert("숫자(소숫점 가능)로만 입력해 주세요.[" + labelText + "]");
            $(item).focus();
            throw new Error("validateFormInput floatOnly");
        }
    });

    $.each($form.find(".commaOnly"), (idx, item) => {
        const uncommaValue = gfn_uncomma($(item).val());
        if (!gfn_isEmpty($(item).val()) && !gfn_isNumeric(uncommaValue, "5")) {
            const labelText = $($(item.closest("div")).prev()).text();
            alert("숫자(소숫점 가능)로만 입력해 주세요.[" + labelText + "]");
            $(item).focus();
            throw new Error("validateFormInput floatOnly");
        }

        $(item).val(uncommaValue);
    });

    $.each($form.find(".mblNoOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_validateMblNo($(item).val())) {
            alert("휴대전화번호 형식이 맞지 않습니다.");
            $(item).focus();
            throw new Error("validateFormInput mblNoOnly");
        }
    });

    $.each($form.find(".emailOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_validateEmail($(item).val())) {
            alert('이메일 형식이 올바르지 않습니다.');
            $(item).focus();
            throw new Error("validateFormInput emailOnly");
        }
    });

    $.each($form.find(".pswrdOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isPswrd($(item).val())) {
            alert('비밀번호 형식이 올바르지 않습니다.');
            $(item).focus();
            throw new Error("validateFormInput pswrdOnly");
        }
    });

    $.each($form.find(".ssnNoOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isSsnNo($(item).val())) {
            alert("주민등록번호 형식이 맞지 않습니다.");
            $(item).focus();
            throw new Error("validateFormInput ssnNoOnly");
        }
    });

    $.each($form.find(".bizNoOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isBizNo($(item).val())) {
            alert("사업자번호 형식이 맞지 않습니다.");
            $(item).focus();
            throw new Error("validateFormInput bizNoOnly");
        }
    });

    $.each($form.find(".crprtnNoOnly"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isCrprtnNo($(item).val())) {
            alert("법인번호 형식이 맞지 않습니다.");
            $(item).focus();
            throw new Error("validateFormInput bizNoOnly");
        }
    });

    $.each($form.find(".dateSize6Only"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isDateSize6($(item).val())) {
            alert("년월일 형식이 맞지 않습니다.");
            $(item).focus();
            throw new Error("validateFormInput dateSize6Only");
        }
    });

    $.each($form.find(".dateSize8Only"), (idx, item) => {
        if (!gfn_isEmpty($(item).val()) && !gfn_isDateSize8($(item).val())) {
            alert("년월일 형식이 맞지 않습니다.");
            $(item).focus();
            throw new Error("validateFormInput dateSize8Only");
        }
    });
}


// 테이블 Th클릭 정렬 세팅
function gfn_setSortTh(sortId, fnNm) {
    $("th[name=" + sortId + "SortTh]").click(function () {
        var id = this.id.substring(7);
        var asc = $("#" + sortId + "Sort_" + id).hasClass("fa-sort-amount-down");
        var desc = $("#" + sortId + "Sort_" + id).hasClass("fa-sort-amount-up");

        $("span[name=" + sortId + "Sort]").removeClass("fa-sort-amount-down");
        $("span[name=" + sortId + "Sort]").removeClass("fa-sort-amount-up");
        if (desc) {
            $("#" + sortId + "Sort_" + id).addClass("fa-sort-amount-down");
            $("#" + sortId + "CurOrderBy").val(id);
        } else if (asc) {
            $("#" + sortId + "CurOrderBy").val("");
        } else {
            $("#" + sortId + "Sort_" + id).addClass("fa-sort-amount-up");
            $("#" + sortId + "CurOrderBy").val(id + " DESC");
        }
        gfv_pageIndex = 1;
        eval(fnNm);
    });
}

// 테이블 내 체크박스 전체선택 세팅
function gfn_setAllCheckbox(allCheckboxNm, itemCheckboxNm) {
    $("input:checkbox[name=" + allCheckboxNm + "]").on("change", function () {
        if ($(this).is(":checked")) {
            $("input:checkbox[name=" + itemCheckboxNm + "]").prop("checked", true);
            $("input:checkbox[name=" + itemCheckboxNm + "]").attr("checked", true);
        } else {
            $("input:checkbox[name=" + itemCheckboxNm + "]").prop("checked", false);
            $("input:checkbox[name=" + itemCheckboxNm + "]").attr("checked", false);
        }
    });
}

//특정 폼 내 셀렉트박스 값 변경시 onChange 클래스가 선언되어 있다면 펑션 실행
function gfn_setOnChange(formId, fnNm) {
    $("#" + formId + " .onChange").change(function (e) {
        gfv_pageIndex = 1;
        eval(fnNm);
    });
}

// 엔터 키 입력시 펑션 실행
function gfn_hitEnter(event, fnNm) {
    if (event.keyCode == 13) {
        event.preventDefault();
        gfv_pageIndex = 1;
        eval(fnNm);
    } else {
        event.keyCode == 0;
        return;
    }
}

/* 파일처리 */

// 파일 다운로드
function gfn_downloadFile(seq) {
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("/com/downloadFile");
    comSubmit.addParam("seq", seq);
    comSubmit.submit();
}


// 다음 주소찾기
//주소찾기 팝업 테마 설정
var addrThemeObj = {
    /*bgColor: "#EFEFEF", //바탕 배경색
    searchBgColor: "#9E5D9F", //검색창 배경색
    contentBgColor: "#FFFFFF", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
    pageBgColor: "#FFFFFF", //페이지 배경색
    //textColor: "", //기본 글자색
    queryTextColor: "#FFFFFF", //검색창 글자색
    postcodeTextColor: "#712594", //우편번호 글자색
    emphTextColor: "#333333", //강조 글자색
    outlineColor: "#FFFFFF" //테두리*/
};

// zipCd : 우편번호 id, addr1 : 주소1 id, addr2 : 주소2 id
function gfn_findAddr(zipCd, addr1, addr2) {
    new daum.Postcode({
        theme: addrThemeObj,
        oncomplete: function (data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullAddr = ''; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;

            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                fullAddr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
            if (data.userSelectedType === 'R') {
                //법정동명이 있을 경우 추가한다.
                if (data.bname !== '') {
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if (data.buildingName !== '') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            //document.getElementById('postcode').value = data.zonecode; //5자리 새우편번호 사용
            //document.getElementById('address').value = fullAddr;
            $("#" + zipCd).val(data.zonecode);
            $("#" + addr1).val(fullAddr);

            // 커서를 상세주소 필드로 이동한다.
            //document.getElementById('address2').focus();
            $("#" + addr2).focus();
        }
    }).open();
}

const gfn_removeElementChildrenAndAppendHtmlString = ($element, htmlString) => {
    $element.empty();
    $element.append(htmlString);
}

const gfn_deepCopyByJSON = object => {
    return JSON.parse(JSON.stringify(object));
}

const gfn_copyText = text => {
    window.navigator.clipboard.writeText(text)
        .then(() => alert("복사되었습니다."));
};
