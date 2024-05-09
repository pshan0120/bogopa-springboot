<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <!-- 다음 주소찾기 적용  -->
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>

    <script>
        let minPlyrCnt = 0;
        let maxPlyrCnt = 0;
        let joinPlyrCnt = 0;

        $(() => {
            gfn_setSortTh("catchAThiefPlayRcrdList", "selectCatchAThiefPlayRcrdList(1)");

            $("[data-toggle='tooltip']").tooltip();

            selectCatchAThiefPlayRcrdList(1);
        });


        const selectCatchAThiefPlayRcrdList = pageNo => {
            let comAjax = new ComAjax("catchAThiefPlayRcrdForm");
            comAjax.setUrl("<c:url value='/selectCatchAThiefPlayRcrdList' />");
            comAjax.setCallback("selectCatchAThiefPlayRcrdListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.addParam("orderBy", $('#catchAThiefPlayRcrdListCurOrderBy').val());
            comAjax.ajax();
        };

        const selectCatchAThiefPlayRcrdListCallback = data => {
            let cnt = data.map.cnt;
            let body = $("#catchAThiefPlayRcrdListTbl>tbody");
            body.empty();
            let str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                let params = {
                    divId: "catchAThiefPlayRcrdListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "selectCatchAThiefPlayRcrdList",
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
        };

        const openInsertPlayModal = () => {
            $("#playMmbrListTbl>tbody").empty();
            $("#playJoinMmbrNListDiv").empty();
            $("#insertPlayForm input[name='hostMmbrNo']").val("<c:out value="${mmbrNo}" />");
            $("#insertPlayForm input[name='hostNickNm']").val("<c:out value="${nickNm}" />");
            $("#insertPlayForm input[name='clubNo']").val("<c:out value="${clubNo}" />");
            $("#insertPlayForm input[name='playNm']").val("");

            minPlyrCnt = 7;
            maxPlyrCnt = 16;
            joinPlyrCnt = 0;

            selectPlayJoinMmbrList(1);
            setPlayNm("도둑잡기");

            $("#insertPlayModal").modal("show");
        };

        const setPlayNm = gameNm => {
            $("#insertPlayForm input[name='playNm']").val("'" + "<c:out value="${nickNm}" />" + "'의 " + gameNm);
        };

        const addPlayMmbr = (mmbrNo, nickNm) => {
            if (joinPlyrCnt < maxPlyrCnt) {
                let body = $("#playMmbrListTbl>tbody");
                let str = "";
                str += "<tr name=\"addPlayMmbrTr\" id=\"addPlayMmbrTr" + mmbrNo + "\">";
                str += "	<td>";
                str += "		" + nickNm;
                str += "	</td>";
                str += "	<td>";
                str += "	</td>";
                str += "	<td>";
                if (mmbrNo == "<c:out value="${mmbrNo}" />") {
                    str += "	호스트";
                } else {
                    str += "	<a class=\"btn btn-sm btn-outline-warning\" href=\"javascript:(void(0));\" onclick=\"removePlayMmbr('" + mmbrNo + "','" + nickNm + "')\">제외</a>";
                }
                str += "	</td>";
                str += "</tr>";
                body.append(str);

                $("#playJoinMmbrNListDiv a").each(function () {
                    let playJoinNickNm = $(this).text().trim();
                    if (playJoinNickNm == nickNm) {
                        $(this).remove();
                    }
                });

                joinPlyrCnt++;
            } else {
                alert("최대 플레이 가능인원은 " + maxPlyrCnt + "명까지입니다.");
                return false;
            }
        };

        const removePlayMmbr = (mmbrNo, nickNm) => {
            let body = $("#playJoinMmbrNListDiv");
            let str = "";
            str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"addPlayMmbr('" + mmbrNo + "', '" + nickNm + "')\" >";
            str += "	" + nickNm;
            str += "</a>";
            body.append(str);

            $("#playMmbrListTbl td:nth-child(1)").each(function () {
                let playJoinNickNm = $(this).text().trim();
                if (playJoinNickNm == nickNm.trim()) {
                    $("#addPlayMmbrTr" + mmbrNo).remove();
                    joinPlyrCnt--;
                }
            });
        };

        const selectPlayJoinMmbrList = pageNo => {
            let comAjax = new ComAjax("insertPlayForm");
            comAjax.setUrl("<c:url value='/selectPlayJoinMmbrList' />");
            comAjax.setCallback("selectPlayJoinMmbrListCallback");
            comAjax.ajax();
        };

        const selectPlayJoinMmbrListCallback = data => {
            let cnt = data.list.length;
            let body = $("#playJoinMmbrNListDiv");
            body.empty();
            let str = "";
            if (cnt > 0) {
                $.each(data.list, function (key, value) {
                    let isRun = true;
                    $("#playMmbrListTbl td:nth-child(1)").each(function () {
                        let playJoinNickNm = $(this).text().trim();
                        if (playJoinNickNm != $("#hostMmbrNo").val() && playJoinNickNm == value.nickNm) {
                            isRun = false;
                        }
                    });
                    if (isRun) {
                        str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"addPlayMmbr('" + value.mmbrNo + "', '" + value.nickNm + "')\" >";
                        str += "	" + value.nickNm;
                        str += "</a>";
                    }
                });
            }
            body.append(str);
        }

        const insertPlay = () => {
            if (joinPlyrCnt < minPlyrCnt) {
                alert("선택된 플레이어가 최소 플레이어수보다 적습니다.");
                return false;
            }

            if (joinPlyrCnt > maxPlyrCnt) {
                alert("선택된 플레이어가 최대 플레이어수보다 많습니다.");
                return false;
            }

            let joinMmbrNoArr = new Array();

            $("#playMmbrListTbl > tbody > tr").each(function () {
                joinMmbrNoArr.push(this.id.replace("addPlayMmbrTr", ""));
            });

            if (gfn_validate("insertPlayForm")) {
                if (confirm("바로 플레이를 시작됩니다. 진행하시겠습니까?")) {
                    let comAjax = new ComAjax("insertPlayForm");
                    comAjax.setUrl("<c:url value='/insertPlay' />");
                    comAjax.setCallback("insertPlayCallback");
                    comAjax.addParam("gameNo", GAME.CATCH_A_THIEF);
                    comAjax.addParam("joinMmbrNoArr", joinMmbrNoArr);
                    comAjax.ajax();
                } else {
                    return;
                }
            }
        };

        const insertPlayCallback = data => {
            location.href = "/game/catch-a-thief/play/" + data.playNo;
        }

        const createCatchAThiefMember = () => {
            const nickname = prompt("회원명 입력");
            if (!nickname) {
                return;
            }

            if (!confirm("[" + nickname + "] 닉네임으로 도둑잡기 모임에 가입된 회원을 등록합니다.")) {
                return;
            }

            gfn_callPostApi("/api/member/catch-a-thief", {nickname})
                .then(data => {
                    console.log('game status saved !!', data);
                    alert("회원이 생성되었습니다.");
                })
                .catch(response => console.error('error', response));
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
                        <h1 class="text-white">도둑잡기</h1>
                        <p class="text-lead text-light"></p>
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
                        <form id="catchAThiefPlayRcrdForm" onsubmit="return false;">
                            <input type="hidden" id="catchAThiefPlayRcrdListCurOrderBy">
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
                                        <button type="button" class="btn btn-sm btn-primary float-right mr-1 my-1"
                                                onclick="openInsertPlayModal();">
                                            새로운 플레이
                                        </button>
                                    </c:if>
                                    <c:if test="${clubNo ne ''}">
                                        <button type="button" class="btn btn-sm btn-primary float-right mr-1 my-1"
                                                onclick="createCatchAThiefMember();">
                                            도둑잡기 회원 등록
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </form>
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="catchAThiefPlayRcrdListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th name="catchAThiefPlayRcrdListSortTh" id="sortTh_playNm">
                                        플레이이름 <span name="catchAThiefPlayRcrdListSort"
                                                    id="catchAThiefPlayRcrdListSort_playNm"
                                                    class="fa"></span>
                                    </th>
                                    <th name="catchAThiefPlayRcrdListSortTh" id="sortTh_gameNm">
                                        게임 <span name="catchAThiefPlayRcrdListSort" id="catchAThiefPlayRcrdListSort_gameNm"
                                                 class="fa"></span>
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
                                id="catchAThiefPlayRcrdListPageNav"></ul>
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
                <button type="button" class="btn btn-primary" onclick="insertPlay();">등록</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 모임프로필 -->
<%@ include file="/WEB-INF/jsp/fo/clubPrflModal.jsp" %>
<!-- 플레이기록 -->
<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
