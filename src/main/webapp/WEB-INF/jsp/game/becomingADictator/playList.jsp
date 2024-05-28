<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script>
        $(() => {
            gfn_setSortTh("becomingADictatorPlayRecordList", "selectBecomingADictatorPlayRecordList(1)");

            const adminMemberLoggedIn = JSON.parse("<%= SessionUtils.isAdminMemberLoggedIn() %>");
            if (adminMemberLoggedIn) {
                $("button[name='openCreatePlayButton']").show();
            }

            selectBecomingADictatorPlayRecordList(1);
        });


        const selectBecomingADictatorPlayRecordList = pageNo => {
            let comAjax = new ComAjax("becomingADictatorPlayRecordForm");
            comAjax.setUrl("<c:url value='/selectBecomingADictatorPlayRecordList' />");
            comAjax.setCallback("selectBecomingADictatorPlayRecordListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.addParam("orderBy", $('#becomingADictatorPlayRecordListCurOrderBy').val());
            comAjax.ajax();
        };

        const selectBecomingADictatorPlayRecordListCallback = data => {
            let cnt = data.map.cnt;
            let body = $("#becomingADictatorPlayRecordListTbl>tbody");
            body.empty();
            let str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                let params = {
                    divId: "becomingADictatorPlayRecordListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "selectBecomingADictatorPlayRecordList",
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

        const openClubProfileModal = clubId => {
            clubProfileModal.open(clubId);
        }

        const openCreatePlayModal = () => {
            createPlayModal.open(GAME.BECOMING_A_DICTATOR);
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
                        <h1 class="text-white">이리하여 나는 독재자가 되었다</h1>
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
                        <form id="becomingADictatorPlayRecordForm" onsubmit="return false;">
                            <input type="hidden" id="becomingADictatorPlayRecordListCurOrderBy">
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
                            <table class="table align-items-center table-flush" id="becomingADictatorPlayRecordListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th name="becomingADictatorPlayRecordListSortTh" id="sortTh_playNm">
                                        플레이이름 <span name="becomingADictatorPlayRecordListSort"
                                                    id="becomingADictatorPlayRecordListSort_playNm"
                                                    class="fa"></span>
                                    </th>
                                    <th name="becomingADictatorPlayRecordListSortTh" id="sortTh_gameNm">
                                        게임 <span name="becomingADictatorPlayRecordListSort" id="becomingADictatorPlayRecordListSort_gameNm"
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
                                id="becomingADictatorPlayRecordListPageNav"></ul>
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
