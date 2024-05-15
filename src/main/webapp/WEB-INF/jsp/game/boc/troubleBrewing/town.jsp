<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/troubleBrewing/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/troubleBrewing/roles.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let playerList = [];
        let roleList = [];
        let demonPlayerList = [];
        let minionPlayerList = [];
        let townsFolkPlayerList = [];
        let outsiderPlayerList = [];
        let playStatus = {};

        $(async () => {
            await loadGameStatus();

            const $townDiv = $("#townDiv");
            const $playersDiv = $townDiv.find("div[name='playersDiv']");
            if (!playStatus) {
                const htmlString = `게임이 시작되지 않았습니다.`;
                $playersDiv.append(htmlString);
                return;
            }

            console.log('playStatus', playStatus);
            /*if (0 < playStatus.round) {
                if (playStatus.night) {
                    renderOtherNight();
                    return;
                }

                renderOtherDay();
                return;
            }*/

            playerList.sort((prev, next) => prev.seatNumber - next.seatNumber);

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

            $("#townDiv").show();
        });

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_ID);
            if (!lastPlayLog) {
                return;
            }

            const lastPlayLogJson = JSON.parse(lastPlayLog);

            playerList = JSON.parse(lastPlayLogJson.playerList);
            roleList = JSON.parse(lastPlayLogJson.roleList);
            townsFolkPlayerList = JSON.parse(lastPlayLogJson.townsFolkPlayerList);
            outsiderPlayerList = JSON.parse(lastPlayLogJson.outsiderPlayerList);
            minionPlayerList = JSON.parse(lastPlayLogJson.minionPlayerList);
            demonPlayerList = JSON.parse(lastPlayLogJson.demonPlayerList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

            console.log('game status loaded !!');
        }

        const readLastPlayLog = playId => {
            return gfn_callGetApi("/api/play/log/last", {playId})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
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
                <div class="card shadow mt-5" id="townDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            마을 광장
                        </h2>
                    </div>
                    <div class="card-body">
                        <div name="playersDiv"></div>
                    </div>
                </div>

                <div class="card shadow mt-5" id="qrDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            QR 이미지로 마을 지도 공유
                        </h2>
                    </div>
                    <div class="card-body">
                        <div name="playersDiv">
                            준비중입니다.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
