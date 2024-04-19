<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <!-- 다음 주소찾기 적용  -->
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>

    <script>
        const GAME_NO = 1951;
        var sttng1Str = "";
        var sttng2Str = "";
        var sttng3Str = "";
        var minPlyrCnt = 0;
        var maxPlyrCnt = 0;
        var joinPlyrCnt = 0;

        $(function () {
            gfn_setSortTh("bocPlayRcrdList", "fn_selectBocPlayRcrdList(1)");

            $("[data-toggle='tooltip']").tooltip();

            fn_selectBocPlayRcrdList(1);
        });


        function fn_selectBocPlayRcrdList(pageNo) {
            var comAjax = new ComAjax("bocPlayRcrdForm");
            comAjax.setUrl("<c:url value='/selectBocPlayRcrdList' />");
            comAjax.setCallback("fn_selectBocPlayRcrdListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.addParam("orderBy", $('#bocPlayRcrdListCurOrderBy').val());
            comAjax.ajax();
        }

        function fn_selectBocPlayRcrdListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#bocPlayRcrdListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "bocPlayRcrdListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectBocPlayRcrdList",
                    recordCount: 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function (key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openPlayRcrdModal('" + value.playNo + "')\" >";
                    str += "			" + value.playNm;
                    str += "		</a>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.gameNm;
                    str += "	</td>";
                    str += "	<td scope=\"row\">";
                    str += "		<div class=\"media align-items-center\">";
                    str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
                    if (value.clubPrflImgFileNm != "") {
                        str += "			<img src=\"https://bogopayo.cafe24.com/img/club/" + value.clubNo + "/" + value.clubPrflImgFileNm + "\">";
                    } else {
                        str += "			<img src=\"https://bogopayo.cafe24.com/img/club/default.png\">";
                    }
                    str += "			</a>";
                    str += "			<div class=\"media-body\">";
                    str += "				<span class=\"mb-0 text-sm\">" + value.clubNm + "</span>";
                    str += "			</div>";
                    str += "		</div>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.strtDt + " ~ ";
                    if (value.endDt != "") {
                        str += value.endDt;
                    }
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_openInsertPlayModal() {
            $("#playMmbrListTbl>tbody").empty();
            $("#playJoinMmbrNListDiv").empty();
            $("#insertPlayForm input[name='hostMmbrNo']").val("<c:out value="${mmbrNo}" />");
            $("#insertPlayForm input[name='hostNickNm']").val("<c:out value="${nickNm}" />");
            $("#insertPlayForm input[name='clubNo']").val("<c:out value="${clubNo}" />");
            $("#insertPlayForm input[name='playNm']").val("");

            $("div[name='sttngCntrlDiv']").empty();
            minPlyrCnt = 5;
            maxPlyrCnt = 20;
            joinPlyrCnt = 0;

            fn_selectPlayJoinMmbrList(1);
            fn_setPlayNm("블러드 온 더 클락타워 - 트러블 브루잉");

            $("#insertPlayModal").modal("show");
        }

        function fn_setPlayNm(gameNm) {
            $("#insertPlayForm input[name='playNm']").val("'" + "<c:out value="${nickNm}" />" + "'의 " + gameNm);
        };

        function fn_addPlayMmbr(mmbrNo, nickNm) {
            if (joinPlyrCnt < maxPlyrCnt) {
                var body = $("#playMmbrListTbl>tbody");
                var str = "";
                str += "<tr name=\"addPlayMmbrTr\" id=\"addPlayMmbrTr" + mmbrNo + "\">";
                str += "	<td>";
                str += "		" + nickNm;
                str += "	</td>";
                str += "	<td>";
                if (sttng1Str != "") {
                    str += "	<select class=\"form-control hasValue\" name=\"sttng1Cd\">";
                    str += "	" + sttng1Str;
                    str += "	</select>";
                }
                if (sttng2Str != "") {
                    str += "	<select class=\"form-control hasValue\" name=\"sttng2Cd\">";
                    str += "	" + sttng2Str;
                    str += "	</select>";
                }
                if (sttng3Str != "") {
                    str += "	<select class=\"form-control hasValue\" name=\"sttng3Cd\">";
                    str += "	" + sttng3Str;
                    str += "	</select>";
                }
                str += "	</td>";
                str += "	<td>";
                if (mmbrNo == "<c:out value="${mmbrNo}" />") {
                    str += "	호스트";
                } else {
                    str += "	<a class=\"btn btn-sm btn-outline-warning\" href=\"javascript:(void(0));\" onclick=\"fn_removePlayMmbr('" + mmbrNo + "','" + nickNm + "')\">제외</a>";
                }
                str += "	</td>";
                str += "</tr>";
                body.append(str);

                $("#playJoinMmbrNListDiv a").each(function () {
                    var playJoinNickNm = $(this).text().trim();
                    if (playJoinNickNm == nickNm) {
                        $(this).remove();
                    }
                });

                joinPlyrCnt++;
            } else {
                alert("최대 플레이 가능인원은 " + maxPlyrCnt + "명까지입니다.");
                return false;
            }
        }

        function fn_removePlayMmbr(mmbrNo, nickNm) {
            var body = $("#playJoinMmbrNListDiv");
            var str = "";
            str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_addPlayMmbr('" + mmbrNo + "', '" + nickNm + "')\" >";
            str += "	" + nickNm;
            str += "</a>";
            body.append(str);

            $("#playMmbrListTbl td:nth-child(1)").each(function () {
                var playJoinNickNm = $(this).text().trim();
                if (playJoinNickNm == nickNm.trim()) {
                    $("#addPlayMmbrTr" + mmbrNo).remove();
                    joinPlyrCnt--;
                }
            });
        }

        function fn_selectPlayJoinMmbrList(pageNo) {
            var comAjax = new ComAjax("insertPlayForm");
            comAjax.setUrl("<c:url value='/selectPlayJoinMmbrList' />");
            comAjax.setCallback("fn_selectPlayJoinMmbrListCallback");
            comAjax.ajax();
        }

        function fn_selectPlayJoinMmbrListCallback(data) {
            var cnt = data.list.length;
            var body = $("#playJoinMmbrNListDiv");
            body.empty();
            var str = "";
            if (cnt > 0) {
                $.each(data.list, function (key, value) {
                    var isRun = true;
                    $("#playMmbrListTbl td:nth-child(1)").each(function () {
                        var playJoinNickNm = $(this).text().trim();
                        if (playJoinNickNm != $("#hostMmbrNo").val() && playJoinNickNm == value.nickNm) {
                            isRun = false;
                        }
                    });
                    if (isRun) {
                        str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_addPlayMmbr('" + value.mmbrNo + "', '" + value.nickNm + "')\" >";
                        str += "	" + value.nickNm;
                        str += "</a>";
                    }
                });
            }
            body.append(str);
        }

        function fn_insertPlay() {
            if (joinPlyrCnt < minPlyrCnt) {
                alert("선택된 플레이어가 최소 플레이어수보다 적습니다.");
                return false;
            }

            if (joinPlyrCnt > maxPlyrCnt) {
                alert("선택된 플레이어가 최대 플레이어수보다 많습니다.");
                return false;
            }

            var joinMmbrNoArr = new Array();
            var sttngCd1Arr = new Array();
            var sttngCd2Arr = new Array();
            var sttngCd3Arr = new Array();

            $("#playMmbrListTbl > tbody > tr").each(function () {
                joinMmbrNoArr.push(this.id.replace("addPlayMmbrTr", ""));
            });
            $("#playMmbrListTbl > tbody > tr select[name='sttng1Cd'] option:selected").each(function () {
                sttngCd1Arr.push(this.value);
            });
            $("#playMmbrListTbl > tbody > tr select[name='sttng2Cd'] option:selected").each(function () {
                sttngCd2Arr.push(this.value);
            });
            $("#playMmbrListTbl > tbody > tr select[name='sttng3Cd'] option:selected").each(function () {
                sttngCd3Arr.push(this.value);
            });

            if (gfn_validate("insertPlayForm")) {
                if (confirm("바로 플레이를 시작됩니다. 진행하시겠습니까?")) {
                    var comAjax = new ComAjax("insertPlayForm");
                    comAjax.setUrl("<c:url value='/insertPlay' />");
                    comAjax.setCallback("fn_insertPlayCallback");
                    comAjax.addParam("gameNo", GAME_NO);
                    comAjax.addParam("joinMmbrNoArr", joinMmbrNoArr);
                    comAjax.addParam("sttngCd1Arr", sttngCd1Arr);
                    comAjax.addParam("sttngCd2Arr", sttngCd2Arr);
                    comAjax.addParam("sttngCd3Arr", sttngCd3Arr);
                    comAjax.ajax();
                } else {
                    return;
                }
            }
        }

        function fn_insertPlayCallback(data) {
            location.href = "/game/" + data.playNo;
        }

    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp" %>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">신사답게 기록해</h1>
                        <p class="text-lead text-light">그리고 너 다음에 한판 더 해</p>
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
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-lg-12">
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <form id="bocPlayRcrdForm" onsubmit="return false;">
                            <input type="hidden" id="bocPlayRcrdListCurOrderBy">
                            <div class="row clearfix">
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label">플레이찾기</label>
                                        <input type="text" name="srchText"
                                               class="form-control form-control-alternative"
                                               onKeypress="gfn_hitEnter(event, 'fn_selectPlayRcrd4List(1)');"
                                               placeholder="게임이름(한글, 영어)">
                                    </div>
                                </div>
                                <div class="col-lg-6 mb-3">
                                    <c:if test="${clubNo ne ''}">
                                        <button type="button" class="btn btn-sm btn-primary float-right"
                                                onclick="fn_openInsertPlayModal();">새로운 플레이
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </form>
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="bocPlayRcrdListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th name="bocPlayRcrdListSortTh" id="sortTh_playNm">
                                        플레이이름 <span name="bocPlayRcrdListSort" id="bocPlayRcrdListSort_playNm" class="fa"></span>
                                    </th>
                                    <th name="bocPlayRcrdListSortTh" id="sortTh_gameNm">
                                        게임 <span name="bocPlayRcrdListSort" id="bocPlayRcrdListSort_gameNm" class="fa"></span>
                                    </th>
                                    <th scope="col">모임</th>
                                    <th scope="col">플레이시간</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="bocPlayRcrdListPageNav"></ul>
                        </nav>
                    </div>




                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<!-- 새로운 플레이 Modal -->
<div class="modal fade" id="insertPlayModal" role="dialog" aria-labelledby="insertPlayModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">새로운 플레이</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="insertPlayForm">
                    <input type="hidden" name="hostMmbrNo">
                    <input type="hidden" name="hostNickNm">
                    <input type="hidden" name="clubNo">
                    <div class="row clearfix">
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="form-control-label">*플레이이름</label>
                                <input type="text" data-name="플레이이름" name="playNm"
                                       class="form-control form-control-alternative hasValue">
                            </div>
                        </div>
                    </div>
                </form>

                <label class="form-control-label">*플레이어</label>
                <div class="mb-4" id="playJoinMmbrNListDiv"></div>
                <div class="table-responsive">
                    <table class="table align-items-center table-flush" id="playMmbrListTbl">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col">닉네임</th>
                            <th scope="col" colspan="2">세팅</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="fn_insertPlay();">등록</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 회원프로필 -->
<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp" %>
<!-- 모임프로필 -->
<%@ include file="/WEB-INF/jsp/fo/clubPrflModal.jsp" %>
<!-- 플레이기록 -->
<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
