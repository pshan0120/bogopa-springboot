<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/troubleBrewing/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/troubleBrewing/roles.js'/>"></script>

    <script>
        const PLAY_NO = ${playNo};
        let playerList = [];
        let roleList = [];
        let demonPlayerList = [];
        let minionPlayerList = [];
        let townsFolkPlayerList = [];
        let outsiderPlayerList = [];
        let playStatus = {};

        $(async () => {
            /*await loadGameStatus();

            const $townDiv = $("#townDiv");
            const $playersDiv = $townDiv.find("div[name='playersDiv']");
            if (Object.keys(playStatus).length === 0) {
                const htmlString = `게임이 시작되지 않았습니다.`;
                $playersDiv.append(htmlString);
                return;
            }

            console.log('playStatus', playStatus);*/
            /*if (0 < playStatus.round) {
                if (playStatus.night) {
                    renderOtherNight();
                    return;
                }

                renderOtherDay();
                return;
            }*/

            /*playerList.sort((prev, next) => prev.seatNumber - next.seatNumber);

            const htmlString = playerList.reduce((prev, next) => {
                const found = [
                    ...demonPlayerList,
                    ...minionPlayerList,
                    ...townsFolkPlayerList,
                    ...outsiderPlayerList,
                ].find(player => player.playerId === next.mmbrNo);

                if (found) {
                    console.log('found', found);
                    const shroudHtml = found.died ? `<i class="ni ni-tie-bow"></i>` : "";
                    const nominatableHtml = found.nominatable ? "투표가능" : "투표불가";

                    return prev +
                        `<div class="row">
                            <div class="col-8">
                                \${found.playerName} \${shroudHtml}
                            </div>
                            <div class="col-4">
                                \${nominatableHtml}
                            </div>
                        </div>
                        <hr>`;
                }

                return "";
            }, "");

            $playersDiv.append(htmlString);

            $("#townDiv").show();*/
        });



        const openGuideModal = () => {
            guideModal.openRuleGuideModal();
        }

        const openRoleGuideModal = () => {
            guideModal.openRoleGuideModal();
        }

        const openNightStepGuideModal = () => {
            guideModal.openNightStepGuideModal();
        }

        const openTownModal = () => {
            townModal.open();
        }

        const openQrModal = () => {
            qrModal.open();
        }

        const openNoteModal = () => {
            noteModal.open();
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
                        <h2>
                            개인 참조
                        </h2>
                    </div>
                    <div class="card-body">
                        게임 진행을 돕기 위한 참조 페이지입니다.
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoleGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openNightStepGuideModal()">
                                밤 역할 진행 순서
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openQrModal()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openNoteModal()">
                                노트
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/guideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/townModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/qrModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/noteModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
