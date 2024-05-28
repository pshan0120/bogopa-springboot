<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <!-- 다음 주소찾기 적용  -->
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>

    <script>
        $(() => {
            gfn_setSortTh("bocPlayRecordList", "selectBocPlayRecordList(1)");

            const adminMemberLoggedIn = JSON.parse("<%= SessionUtils.isAdminMemberLoggedIn() %>");
            if (adminMemberLoggedIn) {
                $("button[name='openCreatePlayButton']").show();
            }

            selectBocPlayRecordList(1);
        });


        const selectBocPlayRecordList = pageNo => {
            let comAjax = new ComAjax("bocPlayRecordForm");
            comAjax.setUrl("<c:url value='/selectBocPlayRecordList' />");
            comAjax.setCallback("selectBocPlayRecordListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.addParam("orderBy", $('#bocPlayRecordListCurOrderBy').val());
            comAjax.ajax();
        };

        const selectBocPlayRecordListCallback = data => {
            let cnt = data.map.cnt;
            let body = $("#bocPlayRecordListTbl>tbody");
            body.empty();
            let str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                let params = {
                    divId: "bocPlayRecordListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "selectBocPlayRecordList",
                    recordCount: 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function (key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openPlayRecordModal('" + value.playNo + "')\" >";
                    str += "			" + value.playNm;
                    str += "		</a>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.gameNm;
                    str += "	</td>";
                    str += "	<td scope=\"row\">";
                    str += "		<div class=\"media align-items-center\">";
                    str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"openClubProfileModal('" + value.clubNo + "')\">";
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

        /*const createBocMember = () => {
            const nickname = prompt("회원명 입력");
            if (!nickname) {
                return;
            }

            if (!confirm("[" + nickname + "] 닉네임으로 BOC 모임에 가입된 회원을 등록합니다.")) {
                return;
            }

            gfn_callPostApi("/api/member/boc", {nickname})
                .then(data => {
                    console.log('game status saved !!', data);
                    alert("회원이 생성되었습니다.");
                })
                .catch(response => console.error('error', response));
        }*/

        const openClubProfileModal = clubId => {
            clubProfileModal.open(clubId);
        }

        const openCreatePlayModal = () => {
            createPlayModal.open(GAME.BOC_TROUBLE_BREWING);
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
                        <h1 class="text-white">Blood on the Clocktower</h1>
                        <p class="text-lead text-light">trouble brewing</p>
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
                        <form id="bocPlayRecordForm" onsubmit="return false;">
                            <input type="hidden" id="bocPlayRecordListCurOrderBy">
                            <div class="row clearfix">
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label">플레이찾기</label>
                                        <input type="text" name="srchText"
                                               class="form-control form-control-alternative"
                                               onKeypress="gfn_hitEnter(event, 'fn_selectPlayRecord4List(1)');"
                                               placeholder="게임이름(한글, 영어)">
                                    </div>
                                </div>
                                <div class="col-lg-6 mb-3">
                                    <button type="button" class="btn btn-sm btn-primary float-right mr-1 my-1"
                                            onclick="openCreatePlayModal();" name="openCreatePlayButton" style="display: none">
                                        새로운 플레이
                                    </button>
                                </div>
                            </div>
                        </form>
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="bocPlayRecordListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th name="bocPlayRecordListSortTh" id="sortTh_playNm">
                                        플레이이름 <span name="bocPlayRecordListSort" id="bocPlayRecordListSort_playNm"
                                                    class="fa"></span>
                                    </th>
                                    <th name="bocPlayRecordListSortTh" id="sortTh_gameNm">
                                        게임 <span name="bocPlayRecordListSort" id="bocPlayRecordListSort_gameNm"
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
                                id="bocPlayRecordListPageNav"></ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/jsp/game/createPlayModal.jspf" %>
<!-- 모임프로필 -->
<%@ include file="/WEB-INF/jsp/fo/jspf/clubProfileModal.jspf" %>
<!-- 플레이기록 -->
<%@ include file="/WEB-INF/jsp/fo/playRecordModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
