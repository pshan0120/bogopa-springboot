//현재 년월일시분초
const gfn_getCurrentDts = () => {
    const d = new Date();
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    const dd = d.getDate();
    const h = d.getHours();
    const m = d.getMinutes();
    const s = d.getSeconds();
    return yyyy + "." + gfn_to2Digits(mm) + "." + gfn_to2Digits(dd) + " " + gfn_to2Digits(h) + ":" + gfn_to2Digits(m) + ":" + gfn_to2Digits(s);
};

// 현재 년월일
const gfn_getCurrentDate = () => {
    const d = new Date();
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    const dd = d.getDate();
    return yyyy + gfn_to2Digits(mm) + gfn_to2Digits(dd);
};

const gfn_getCurrentDateDash = () => {
    const d = new Date();
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    const dd = d.getDate();
    return yyyy + "-" + gfn_to2Digits(mm) + "-" + gfn_to2Digits(dd);
};

const gfn_getCurrentYearMonthDash = () => {
    const d = new Date();
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    return yyyy + "-" + gfn_to2Digits(mm);
};

const gfn_getCurrentDateDot = () => {
    const d = new Date();
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    const dd = d.getDate();
    return yyyy + "." + gfn_to2Digits(mm) + "." + gfn_to2Digits(dd);
};

// 전후 년월일
const gfn_getDate = day => {
    const d = new Date();
    const dayOfMonth = d.getDate();
    d.setDate(dayOfMonth + day);
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    const dd = d.getDate();
    return yyyy + gfn_to2Digits(mm) + gfn_to2Digits(dd);
};

const gfn_getDateDash = day => {
    const d = new Date();
    const dayOfMonth = d.getDate();
    d.setDate(dayOfMonth + day);
    const yyyy = d.getFullYear();
    const mm = d.getMonth() + 1;
    const dd = d.getDate();
    return yyyy + "-" + gfn_to2Digits(mm) + "-" + gfn_to2Digits(dd);
};

// UNIX시간을 일반 시간으로 변환
const unix_timestamp = t => {
    const date = new Date(t * 1000);
    const year = date.getFullYear();
    const month = "0" + (date.getMonth() + 1);
    const day = "0" + date.getDate();
    const hour = "0" + date.getHours();
    const minute = "0" + date.getMinutes();
    const second = "0" + date.getSeconds();

    return year + "-" + month.substr(-2) + "-" + day.substr(-2) + " " + hour.substr(-2) + ":" + minute.substr(-2) + ":" + second.substr(-2);
};

// timestamp 을 일반 시간으로 변환
const gfn_timestampToDate = t => {
    if (t === null) return "-";

    const date = new Date(t);
    const year = date.getFullYear();
    const month = "0" + (date.getMonth() + 1);
    const day = "0" + date.getDate();
    const hour = "0" + date.getHours();
    const minute = "0" + date.getMinutes();
    const second = "0" + date.getSeconds();

    return year + "-" + month.substr(-2) + "-" + day.substr(-2) + " " + hour.substr(-2) + ":" + minute.substr(-2) + ":" + second.substr(-2);
};

const gfn_convertLocalDateToDate = localDate => {
    return localDate.substring(0, 10);
}

const gfn_convertLocalDateTimeToDate = localDateTime => {
    return localDateTime.substring(0, 10);
}

const gfn_convertLocalDateTimeToTime = localDateTime => {
    return localDateTime.substring(11, 19);
}

const gfn_convertLocalDateTimeToDateTime = localDateTime => {
    return localDateTime;
}

const gfn_localDateTimeObjectToDateObject = localDateTime => {
    return new Date(localDateTime.substring(0, 4), localDateTime.substring(5, 7) - 1, localDateTime.substring(8, 10),
        localDateTime.substring(11, 13), localDateTime.substring(14, 16), localDateTime.substring(17, 19));
}

const gfn_localDateObjectToDateObject = localDate => {
    return new Date(localDate.substring(0, 4), localDate.substring(5, 7) - 1, localDate.substring(8, 10));
}

const gfn_localDateObjectToDash = localDate => {
    if (!localDate) {
        return null;
    }
    return localDate.substring(0, 4) + "-" + localDate.substring(5, 7) + "-" + localDate.substring(8, 10);
}

const gfn_localDateObjectToDot = localDate => {
    if (!localDate) {
        return null;
    }
    return localDate.substring(0, 4) + "." + localDate.substring(5, 7) + "." + localDate.substring(8, 10);
}

// 6자리 텍스트가 날짜가 맞는지 체크
const gfn_isDateSize6 = dateOfSize8 => {
    const yyyyMMdd = String(dateOfSize8);
    const month = yyyyMMdd.substring(4, 6);

    if (!gfn_isNumber(dateOfSize8) || dateOfSize8.length != 6)
        return false;

    if (Number(month) > 12 || Number(month) < 1)
        return false;

    return true;
};

// 6자리 텍스트가 날짜가 맞는지 체크
const gfn_isDateSize8 = dateOfSize8 => {
    const yyyyMMdd = String(dateOfSize8);
    const month = yyyyMMdd.substring(4, 6);
    const day = yyyyMMdd.substring(6, 8);

    if (!gfn_isNumber(dateOfSize8) || dateOfSize8.length != 8)
        return false;

    if (Number(month) > 12 || Number(month) < 1)
        return false;

    if (Number(gfn_lastDay(dateOfSize8)) < day)
        return false;

    return true;
};

const gfn_lastDay = dateOfSize8 => {
    const yyyyMMdd = String(dateOfSize8);
    const year = yyyyMMdd.substring(0, 4);
    const month = yyyyMMdd.substring(4, 6);

    if (Number(month) == 2) {
        if (gfn_isLeapYear(year)) {
            return "29";
        } else {
            return "28";
        }
    }

    if (Number(month) == 4 || Number(month) == 6 || Number(month) == 9 || Number(month) == 11) {
        return "30";
    }

    return "31";
};

// 윤달이 있는 년도인지 체크
const gfn_isLeapYear = (year) => {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
}

// 날짜를 한글 날짜로
const gfn_replaceKorDate = date => {
    if (date == null) {
        return false;
    }
    return parseInt(date.substr(0, 4)) + "년 " + parseInt(date.substr(4, 2)) + "월 " + parseInt(date.substr(6, 2)) + "일";
};

const gfn_getDateDot = (localDate) => {
    if (localDate == null) {
        return false;
    }
    const yyyy = localDate.getFullYear();
    const mm = localDate.getMonth() + 1;
    const dd = localDate.getDate();
    return yyyy + "." + gfn_to2Digits(mm) + "." + gfn_to2Digits(dd);
};
