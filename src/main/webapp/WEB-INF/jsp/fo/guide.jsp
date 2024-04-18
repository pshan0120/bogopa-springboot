<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>
    <script>
        const PAGE_ROW = 5;

        $(() => {
            readNoticePage(1);
            fn_selectFaqBrdList(1);
        });

        const readNoticePage = pageNo => {
            const $form = $("#noticeBoardForm");
            const request = {
                page: pageNo,
                size: PAGE_ROW,
                descending: true,
                sortBy: "seq",
                brdTypeCd: "1",
                searchText: $form.find("input[name='srchText']").val(),
            }

            gfn_callGetApi("/api/board/page", request)
                .then(data => readNoticePageCallback(data))
                .catch(response => console.error('error', response));
        };

        const readNoticePageCallback = data => {
            const $body = $("#noticeBoardListTbl>tbody");

            const count = data.totalElements;
            const list = data.content;

            if (list.length == 0) {
                const htmlString = "<tr><td colspan='3' class=\"text-center\">조회결과가 없습니다.</td></tr>";
                gfn_removeElementChildrenAndAppendHtmlString($body, htmlString);
                return;
            }

            const htmlString = createNoticeTableBodyHtmlString(list);
            gfn_removeElementChildrenAndAppendHtmlString($body, htmlString);

            const params = {
                divId: "pageNav",
                pageIndex: "pageIndex",
                totalCount: count,
                eventName: "readNoticePage",
                recordCount: PAGE_ROW
            };
            gfn_renderPaging(params);
        };

        const createNoticeTableBodyHtmlString = list => {
            let htmlString = "";
            $.each(list, (index, value) => {
                htmlString += "<tr>";
                htmlString += "	<td>";
                htmlString += "		" + value.seq;
                htmlString += "	</td>";
                htmlString += "	<td>";
                htmlString += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openBrdModal('" + value.seq + "')\" >";
                htmlString += "			" + value.title;
                htmlString += "		</a>";
                htmlString += "	</td>";
                htmlString += "	<td>";
                htmlString += "		" + value.insDt;
                htmlString += "	</td>";
                htmlString += "</tr>";
            });
            return htmlString;
        }

        const openDetail = id => {
            location.href = "/bo/banner/" + id;
        }

        /*function readNoticePageCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#noticeBoardListTbl>tbody");
            body.empty();
            var str = "";
            if(cnt == 0) {
                str += "<tr><td colspan='3' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId : "noticeBoardListPageNav",
                    pageIndex : "pageIndex",
                    totalCount : cnt,
                    eventName : "fn_selectNtcBrdList",
                    recordCount : 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function(key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		" + value.seq;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openBrdModal('" + value.seq + "')\" >";
                    str += "			" + value.title;
                    str += "		</a>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.insDt;
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }*/

        function fn_selectFaqBrdList(pageNo) {
            var comAjax = new ComAjax("faqBrdForm");
            comAjax.setUrl("<c:url value='/selectBrdList' />");
            comAjax.setCallback("fn_selectFaqBrdListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.addParam("brdTypeCd", "2");
            comAjax.ajax();
        }

        function fn_selectFaqBrdListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#faqBrdListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='3' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "faqBrdListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectFaqBrdList",
                    recordCount: 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function (key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		" + value.seq;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openBrdModal('" + value.seq + "')\" >";
                    str += "			" + value.title;
                    str += "		</a>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.insDt;
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_openBrdModal(seq) {
            var comAjax = new ComAjax();
            comAjax.setUrl("<c:url value='/selectBrd' />");
            comAjax.setCallback("fn_openBrdModalCallback");
            comAjax.addParam("seq", seq);
            comAjax.ajax();
        }

        function fn_openBrdModalCallback(data) {
            gfn_setDataVal(data.map, "brdForm");
            $("#brdModal").modal("show");
        }

    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbar.jsp" %>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">난 뉴비라는 말이 좋아</h1>
                        <p class="text-lead text-light">하지만 날 뉴비라고 놀리는 것은 참을 수 없다!</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="separator separator-bottom separator-skew zindex-100">
            <svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1"
                 xmlns="http://www.w3.org/2000/svg">
                <polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
            </svg>
        </div>
    </div>
    <!-- Page content -->
    <div class="container mt--7">
        <div class="row">
            <div class="col-xl-12 mb-5 mb-xl-0">
                <div class="card shadow mt-5">
                    <div class="nav-wrapper">
                        <ul class="nav nav-pills nav-fill flex-column flex-md-row mx-3" role="tablist" id="tabList">
                            <li class="nav-item px-1">
                                <a class="nav-link active" id="aboutTabA" data-toggle="tab" href="#aboutTab"
                                   role="tab" aria-controls="aboutTab" aria-selected="true">
                                    서비스 소개
                                </a>
                            </li>
                            <li class="nav-item px-1">
                                <a class="nav-link" id="noticeTabA" data-toggle="tab" href="#noticeTab" role="tab"
                                   aria-controls="noticeTab" aria-selected="true">
                                    공지사항
                                </a>
                            </li>
                            <li class="nav-item px-1">
                                <a class="nav-link" id="faqTabA" data-toggle="tab" href="#faqTab" role="tab"
                                   aria-controls="faqTab" aria-selected="false">
                                    자주 묻는 질문
                                </a>
                            </li>
                            <li class="nav-item px-1">
                                <a class="nav-link" id="inquiryTabA" data-toggle="tab" href="#inquiryTab" role="tab"
                                   aria-controls="inquiryTab" aria-selected="false">
                                    각종 문의
                                </a>
                            </li>
                        </ul>
                    </div>
                    <!-- 전체 탭 컨텐츠 -->
                    <div class="tab-content">
                        <!-- 소개 탭 컨텐츠 -->
                        <div id="aboutTab" class="tab-pane fade show active" role="tabpanel"
                             aria-labelledby="aboutTabA">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-6 col-lg-6">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body text-center">
                                <h2>
                                    보드게임 같이 하고파!
                                </h2>
                                <h4>
                                    보고파는 보드게이머가 만든 보드게이머를 위한 서비스입니다.
                                </h4>
                                <p>
                                    오프라인 모임을 찾아보고 마음맞는 사람들과 함께 보드게임을 즐길 수 있습니다.<br>
                                    모임 출석과 회비관리를 쉽게 할 수 있습니다.<br>
                                    요즘 어떤 게임이 많이 플레이 되는지 알아볼 수 있습니다.<br>
                                    누가 진짜 고수인지 겨뤄볼 수 있습니다.<br>
                                </p>
                                <h3>
                                    언젠간 전국구 보드게임리그를 열고 말겠습니다!
                                </h3>
                            </div>
                            <div class="card-footer py-4">
                            </div>
                        </div>
                        <!-- 공지사항 탭 컨텐츠 -->
                        <div id="noticeTab" class="tab-pane fade" role="tabpanel" aria-labelledby="noticeTabA">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-6 col-lg-6">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body" id="noticeBoardDiv">
                                <form id="noticeBoardForm" onsubmit="return false;">
                                    <div class="row clearfix">
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label class="form-control-label">게시물찾기</label>
                                                <input type="text" name="srchText"
                                                       class="form-control form-control-alternative"
                                                       onKeypress="gfn_hitEnter(event, 'readNoticePage(1)');"
                                                       placeholder="제목, 내용">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <div class="table-responsive">
                                    <table class="table align-items-center table-flush" id="noticeBoardListTbl">
                                        <thead class="thead-light">
                                        <tr>
                                            <th scope="col">순번</th>
                                            <th scope="col">제목</th>
                                            <th scope="col">등록일시</th>
                                        </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <nav aria-label="">
                                    <ul class="pagination pagination-sm justify-content-end mb-0"
                                        id="noticeBoardListPageNav"></ul>
                                </nav>
                            </div>
                        </div>
                        <!-- 자주 묻는 질문 탭 컨텐츠 -->
                        <div id="faqTab" class="tab-pane fade" role="tabpanel" aria-labelledby="faqTabA">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-6 col-lg-6">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <form id="faqBrdForm" onsubmit="return false;">
                                    <div class="row clearfix">
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label class="form-control-label">게시물찾기</label>
                                                <input type="text" name="srchText"
                                                       class="form-control form-control-alternative"
                                                       onKeypress="gfn_hitEnter(event, 'fn_selectFaqBrdList(1)');"
                                                       placeholder="제목, 내용">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <div class="table-responsive">
                                    <table class="table align-items-center table-flush" id="faqBrdListTbl">
                                        <thead class="thead-light">
                                        <tr>
                                            <th scope="col">순번</th>
                                            <th scope="col">제목</th>
                                            <th scope="col">등록일시</th>
                                        </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <nav aria-label="">
                                    <ul class="pagination pagination-sm justify-content-end mb-0"
                                        id="faqBrdListPageNav"></ul>
                                </nav>
                            </div>
                        </div>
                        <!-- 문의 탭 컨텐츠 -->
                        <div id="inquiryTab" class="tab-pane fade" role="tabpanel" aria-labelledby="inquiryTabA">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-6 col-lg-6">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body text-center">
                                <p>
                                    문의게시판 만드는 중입니다.<br>
                                    그 전까지는 pshan0120@naver.com 로 메일주세요.
                                </p>
                            </div>
                            <div class="card-footer py-4">
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<!-- 게시물 모달 -->
<div class="modal fade" id="brdModal" role="dialog" aria-labelledby="brdModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="brdModalLabel">게시물</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="brdForm">
                    <input type="hidden" name="seq">
                    <div class="row clearfix">
                        <div class="col-lg-6">
                            <div class="form-group">
                                <label class="form-control-label">게시물유형</label>
                                <input type="text" name="brdTypeNm" class="form-control form-control-alternative"
                                       readonly>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="form-group">
                                <label class="form-control-label">작성일시</label>
                                <input type="text" name="insDt" class="form-control form-control-alternative" readonly>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="form-control-label">제목</label>
                                <input type="text" name="title" class="form-control form-control-alternative" readonly>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="form-control-label">내용</label>
                                <textarea rows="16" name="cntnts" class="form-control form-control-alternative"
                                          readonly></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
