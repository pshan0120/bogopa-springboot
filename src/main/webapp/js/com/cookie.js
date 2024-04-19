const gfn_setCookie = (name, value, expiredDay, expiredHour = false) => {
    const todayDate = new Date();

    if(expiredHour === false) {
        todayDate.setDate(todayDate.getDate() + expiredDay);
    } else {
        todayDate.setHours(expiredHour, 0, 0, 0);
        todayDate.setDate(todayDate.getDate() + expiredDay);
    }

    // document.cookie = name + "=" + escape(value) + "; Secure; SameSite=None; path=/; expires=" + todayDate.toGMTString() + ";";
    document.cookie = name + "=" + encodeURIComponent(value) + "; Secure; SameSite=None; path=/; expires=" + todayDate.toGMTString() + ";";
}

const gfn_deleteCookie = name => {
    gfn_setCookie(name, null, 0);
}

const gfn_getCookie = name => {
    let found = false;
    let start;
    let end;
    let i = 0;

    while (i <= document.cookie.length) {
        start = i;
        end = start + name.length;
        if (document.cookie.substring(start, end) == name) {
            found = true;
            break;
        }
        i++;
    }

    if (found) {
        start = end + 1;
        end = document.cookie.indexOf(";", start);
        // 마지막 부분이라는 것을 의미(마지막에는 ";"가 없다)
        if (end < start)
            end = document.cookie.length;
        // cookie_name에 해당하는 value값을 추출하여 리턴한다.
        return document.cookie.substring(start, end);
    }

    return "";
}