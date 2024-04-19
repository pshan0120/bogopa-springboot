//페이징 처리
const DEFAULT_VISIBLE_PAGES = 5;
let gfv_pageIndex = null;

const gfn_initializeGlobalPageIndex = () => {
    gfv_pageIndex = 1;
}

const gfn_renderPaging = params => {
    const $pagingObject = calculatePagingObject(params.divId, params.pagingObject);
    const totalCount = params.totalCount;	// 전체 건수
    const recordCount = params.recordCount;	// 페이지당 표시할 건수
    let startPage = calculateStartPage($pagingObject, gfv_pageIndex);
    const totalPages = Math.ceil(totalCount / recordCount);
    if(totalPages < startPage) {
        startPage = 1;
    }

    gfv_pageIndex = null;

    const visiblePages = DEFAULT_VISIBLE_PAGES;
    const pageClickEvent = params.eventName;

    $pagingObject.twbsPagination('destroy');

    $pagingObject.twbsPagination({
        startPage,
        totalPages,
        initiateStartPageClick: false,
        first: "&laquo;",
        prev: "&#60;",
        next: "&#62;",
        last: "&raquo;",
        visiblePages,
        onPageClick: function (event, page) {
            if(totalPages < page) {
                page = startPage;
            }
            invokePageClickEvent(pageClickEvent, page);
        }
    });
};

const calculatePagingObject = (objectId, $pagingObject) => {
    if (gfn_isEmpty(objectId)) {
        return $pagingObject;
    }
    return $("#" + objectId);
};

const calculateStartPage = ($pagingObject, globalPageIndex) => {
    if (globalPageIndex !== null) {
        return globalPageIndex;
    }

    if (gfn_isEmpty($pagingObject.html())) {
        return 1;
    }

    return $pagingObject.twbsPagination('getCurrentPage');	// js에서 가져온 페이지
};

const invokePageClickEvent = (pageClickEvent, value) => {
    if (typeof (pageClickEvent) == "function") {
        pageClickEvent(value);
    } else {
        eval(pageClickEvent + "(value);");
    }
};

// 페이징 fragment
const gfn_getHashJson = () => {
    let hashJson = {};
    $.each(window.location.hash.substr(1).split("&"), (idx, itemString) => {
        let itemArray = itemString.split("=");
        hashJson[itemArray[0]] = decodeURIComponent(itemArray[1]).replace('+', ' ');
    })
    return hashJson;
};

const gfn_setPageSearchHash = (formQS, callback) => {
    // fragment 값 가져와서 form 세팅 후 함수 실행
    $(window).on("hashchange load", (event) => {
        event.preventDefault();
        event.stopPropagation();
        let hashJson = {};
        if (window.location.hash === "") {
            // 해쉬데이터가 없으면 기존에 작성 해놓은 데이터 사용
            $.each(formQS.serializeArray(), (idx, item) => {
                hashJson[item["name"]] = item["value"];
            });
            window.location.hash = $.param(hashJson);
        } else {
            // 해쉬데이터가 있으면 가져옴
            hashJson = gfn_getHashJson();
        }
        // console.log("hash change", hashJson);
        hashJson["pageIndex"] = (hashJson["pageIndex"] === null || hashJson["pageIndex"] === undefined) ? 1 : Number(hashJson["pageIndex"]);

        // form 에 뿌린다
        $.each(formQS.find(":input"), (idx, item) => {
            // console.log($(item), $(item).val());
            if (hashJson[$(item).attr("name")] !== null) {
                $(item).val(hashJson[$(item).attr("name")]);
            }
        });

        callback(hashJson["pageIndex"]);
    })
    formQS.on("pageChange", () => {
        let hashJson = gfn_getHashJson();
        let flag = false;
        $.each(formQS.serializeArray(), (idx, item) => {
            if (item["name"] !== "pageIndex" && hashJson[item["name"]] !== item["value"]) {
                flag = true;
            }
            hashJson[item["name"]] = item["value"];
        });
        // console.log("form change", hashJson, flag);
        if (flag) {
            hashJson["pageIndex"] = 1;
        }
        window.location.hash = $.param(hashJson);
    });
    formQS.on('keypress', (event) => {
        if (event.keyCode === 13) {
            formQS.trigger("pageChange");
            event.preventDefault();
        }
    })
    formQS.on('click', (event) => {
        formQS.trigger("pageChange");
        event.preventDefault();
    })
};

const gfn_newRenderPaging = params => {
    let divQS = params.divQS;	// div QS
    let formQS = params.formQS;	// form QS
    let totalCount = params.totalCount;	// 전체 건수
    let pageIndex = Number(formQS.find("input[name='pageIndex']").val());	// 현재 페이지
    let pageRow = params.pageRow;	// 페이지당 표시할 건수
    let visiblePages = DEFAULT_VISIBLE_PAGES;
    divQS.twbsPagination('destroy');
    divQS.twbsPagination({
        startPage: pageIndex,
        totalPages: Math.ceil(totalCount / pageRow),
        initiateStartPageClick: false,
        first: "&laquo;",
        prev: "&#60;",
        next: "&#62;",
        last: "&raquo;",
        activeClass: "on",
        visiblePages: visiblePages,
        onPageClick: function (event, page) {
            formQS.find("input[name='pageIndex']").val(page).trigger('pageChange');
        }
    });
};
