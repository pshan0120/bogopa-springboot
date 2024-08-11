<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/zombie/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/zombie/constants.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let playSetting = {};
        let playStatus = {};
        let originalPlayerList = [];
        let playerList = [];

        $(async () => {
            await gfn_readPlayablePlayById(PLAY_ID);

            await loadGameStatus();

            console.log('playStatus', playStatus);
            if (Object.keys(playStatus).length === 0) {
                await initializeGame();
                return;
            }

            if (0 < playStatus.round) {
                renderRound();
                return;
            }

            renderPlayMemberList(playerList);

            $("#settingDiv").show();
        });

        const initializeGame = async () => {
            playSetting = {};
            playStatus = {};
            playerList = [];

            console.log('initializationSetting', initializationSetting);

            $("#settingDiv").show();
            $("#roundDiv").hide();
            $("#resultDiv").hide();

            const originalPlayMemberList = await readPlayMemberList(PLAY_ID);
            const clientPlayMemberList = originalPlayMemberList.clientPlayMemberList;
            const hostPlayMember = originalPlayMemberList.hostPlayMember;

            playStatus = {
                round: 0,
                hostMemberId: hostPlayMember.memberId,
                hostMemberName: hostPlayMember.nickname,
            }

            originalPlayerList = clientPlayMemberList;

            playSetting = initializationSetting.player
                .find(item => originalPlayerList.length === item.numberOfPlayer);
            playSetting = {...playSetting, round: initializationSetting.round};

            renderPlayMemberList(originalPlayerList);
        };

        const renderPlayMemberList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            $playerDiv.empty();

            const htmlString = playerList.reduce((prev, next) => {
                return prev +
                    "<div class=\"form-group form-inline\">" +
                    "   <label class=\"form-control-label\">" + next.nickname + "</label>" +
                    "   <input type=\"text\" class=\"form-control form-control-alternative\" name=\"items\" readonly" +
                    "       data-member-id=\"" + next.memberId + "\">" +
                    "</div>";
            }, "");

            $playerDiv.append(htmlString);
        }

        const readPlayMemberList = playId => {
            return gfn_callGetApi("/api/play/member/list", {playId})
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const setRoleOfPlayer = () => {
            playerList = createPlayerList(originalPlayerList);

            showRoleOfPlayerList(playerList);
        }

        const createPlayerList = playerList => {
            let playerNumber = 0;

            return playerList
                .sort(() => Math.random() - 0.5)
                .map(player => {
                    playerNumber++;
                    if (playerNumber <= playSetting.zombie) {
                        return {
                            ...player,
                            playerNumber,
                            firstZombie: true,
                            zombie: true,
                            cure: true,
                            point: 0,
                            touchedMemberIdByRound: null,
                            lastInfectedAt: null,
                        }
                    }

                    return {
                        ...player,
                        playerNumber,
                        firstZombie: false,
                        zombie: false,
                        cure: true,
                        point: 0,
                        touchedMemberIdByRound: null,
                        lastInfectedAt: null,
                    }
                })
                .sort(() => Math.random() - 0.5);
        }

        const showRoleOfPlayerList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            playerList.forEach(player => {
                console.log('player', player);
                const found = $playerDiv.find("input[name='items']").toArray()
                    .filter(itemsObject => player.memberId == $(itemsObject).data("memberId"));

                $(found).val(player.firstZombie ? "최초 좀비" : "사람");

                $(found).removeClass();
                $(found).addClass("form-control form-control-alternative");
            });
        }

        const saveGameStatus = () => {
            const log = {
                playSetting: JSON.stringify(playSetting),
                playStatus: JSON.stringify(playStatus),
                playerList: JSON.stringify(playerList),
            }

            const request = {
                playId: PLAY_ID,
                log: JSON.stringify(log)
            }

            gfn_callPostApi("/api/play/save", request)
                .then(data => {
                    console.log('game status saved !!', data);
                })
                .catch(response => console.error('error', response));
        }

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_ID);
            if (!lastPlayLog) {
                return;
            }

            const lastPlayLogJson = JSON.parse(lastPlayLog);
            console.log('lastPlayLogJson', lastPlayLogJson);

            playSetting = JSON.parse(lastPlayLogJson.playSetting);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);
            playerList = JSON.parse(lastPlayLogJson.playerList);

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

        const beginGame = () => {
            if (playerList.length === 0) {
                alert("역할이 분배되지 않았습니다.");
                return;
            }

            $("#settingDiv").hide();
            proceedToNextRound();
        }

        const proceedToNextRound = () => {
            if (playStatus.round === 0) {
                playStatus.round = playStatus.round + 1;
                saveGameStatus();
                renderRound();
                return;
            }

            if (!confirm("결과를 계산한 뒤 저장하시겠습니까?")) {
                return;
            }

            infect();

            playerList.forEach(player => player.touchedMemberIdByRound = null);

            playStatus.round = playStatus.round + 1;
            saveGameStatus();
            renderRound();
        }

        const infect = () => {
            // TODO: 감염 계산

            // touchedMemberIdByRound
        }

        const renderRound = () => {
            if (playSetting.round < playStatus.round) {
                endGame();
                return;
            }

            const $roundDiv = $("#roundDiv");
            $roundDiv.show();

            $roundDiv.find("span[name='roundTitle']").text(playStatus.round + " / " + playSetting.round);
            console.log('playerList', playerList);
        }

        const renderTown = ($touchDiv, town) => {
            const $townTitle = $touchDiv.find("span[name='townTitle']");
            $townTitle.empty().append(town.title);

            const $playerDiv = $touchDiv.find("div[name='playerDiv']");
            $playerDiv.empty().append(createPlayerHtml(town));

            const $outcastDiv = $touchDiv.find("div[name='outcastDiv']");
            $outcastDiv.empty();
        }

        const createPlayerHtml = town => {
            return playerList
                .filter(player => player.town.name === town.name)
                .reduce((prev, next) => {
                    return prev
                        + "<button class=\"btn btn-sm btn-outline-default mr-1 my-1\" "
                        + " onclick=\"setOutcast('" + next.playerName + "')\" >"
                        + " " + next.playerName + (next.thief ? "(도둑)" : "")
                        + "</button>";
                    // }, `<h3>\${town.title} 추방자</h3>`) + "<hr>";
                }, "");
        }


        const resetGame = () => {
            if (!confirm("현재까지의 모든 진행 상황을 초기화하고 게임을 처음부터 진행합니다.")) {
                return;
            }

            const request = {
                playId: PLAY_ID
            }

            gfn_callDeleteApi("/api/play/log/all", request)
                .then(data => {
                    console.log('data', data);
                })
                .catch(response => console.error('error', response));

            initializeGame();
        }

        const endGame = () => {
            $("#roundDiv").hide();
            $("#resultDiv").show();

            renderResult();
        }

        const renderResult = () => {
            const $resultDiv = $("#resultDiv");

            const $winnerDiv = $resultDiv.find("div[name='winnerDiv']");
            $winnerDiv.empty().append(createWinnerHtml());

            let uptownPlayerRank = 0;
            const uptownPlayerHtmlString = playerList
                .filter(player => !player.thief)
                .filter(player => player.town.name === UPTOWN.name)
                .sort((prev, next) => next.money - prev.money)
                .reduce((prev, next) => {
                    uptownPlayerRank++;
                    return prev +
                        `<div class="row">
                            <div class="col-2">
                                \${uptownPlayerRank}위
                            </div>
                            <div class="col-6">
                                \${next.playerName}
                            </div>
                            <div class="col-4 text-right">
                                \${next.money}
                            </div>
                        </div>`;
                }, "");
            const $uptownPlayerDiv = $resultDiv.find("div[name='uptownPlayerDiv']");
            $uptownPlayerDiv.empty().append(uptownPlayerHtmlString);

            let downtownPlayerRank = 0;
            const downtownPlayerHtmlString = playerList
                .filter(player => !player.thief)
                .filter(player => player.town.name === DOWNTOWN.name)
                .sort((prev, next) => next.money - prev.money)
                .reduce((prev, next) => {
                    downtownPlayerRank++;
                    return prev +
                        `<div class="row">
                            <div class="col-2">
                                \${downtownPlayerRank}위
                            </div>
                            <div class="col-6">
                                \${next.playerName}
                            </div>
                            <div class="col-4 text-right">
                                \${next.money}
                            </div>
                        </div>`;
                }, "");
            const $downtownPlayerDiv = $resultDiv.find("div[name='downtownPlayerDiv']");
            $downtownPlayerDiv.empty().append(downtownPlayerHtmlString);

            let thiefRank = 0;
            const thiefPlayerHtmlString = playerList
                .filter(player => player.thief)
                .sort((prev, next) => next.money - prev.money)
                .reduce((prev, next) => {
                    thiefRank++;
                    return prev +
                        `<div class="row">
                            <div class="col-2">
                                \${thiefRank}위
                            </div>
                            <div class="col-6">
                                \${next.playerName}
                            </div>
                            <div class="col-4 text-right">
                                \${next.money}
                            </div>
                        </div>`;
                }, "");
            const $thiefPlayerDiv = $resultDiv.find("div[name='thiefPlayerDiv']");
            $thiefPlayerDiv.empty().append(thiefPlayerHtmlString);
        }

        const createWinnerHtml = () => {
            const thiefList = playerList.filter(player => player.thief);
            const uptownThiefList = thiefList.filter(player => player.town.name === UPTOWN.name);
            const downtownThiefList = thiefList.filter(player => player.town.name === DOWNTOWN.name);

            if (uptownThiefList.length === 0) {
                return "큰 마을 승리!";
            }

            if (downtownThiefList.length === 0) {
                return "작은 마을 승리!";
            }

            return "도둑 승리!";
        }

        const openTouchModal = () => {
            touchModal.open(playerList);
        }

        const openUseCureModal = () => {
            useCureModal.open(playerList);
        }

        const openTownStatusModal = () => {
            townStatusModal.open();
        }

        const openMoneyStatusModal = () => {
            moneyStatusModal.open(PLAY_ID);
        }

        const openGuideModal = () => {
            guideModal.open();
        }

        const openQrLoginModal = () => {
            qrLoginModal.open(playerList);
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
                        <h1 class="text-white">좀비 게임</h1>
                        <p class="text-lead text-light">호스트 참조</p>
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
                <div class="card shadow mt-5 display-none" id="settingDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            게임 세팅
                        </h2>
                    </div>
                    <div class="card-body">
                        <div name="playerDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default" onclick="setRoleOfPlayer()">
                                역할 지정
                            </button>
                            <button type="button" class="btn btn-primary" onclick="beginGame()">
                                게임 시작
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="roundDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            [<span name="roundTitle"></span>] 번째 라운드
                        </h2>
                    </div>
                    <div class="card-body" name="touchDiv">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openTouchModal()">
                                터치 모달 표시
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openUseCureModal()">
                                치료제 사용 모달 표시
                            </button>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openMoneyStatusModal()">
                                재산 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextRound()">
                                다음 라운드 진행
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="resetGame()">
                                게임 재설정
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="resultDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            게임 종료
                        </h2>
                    </div>
                    <div class="card-body">
                        <h4>우승자</h4>
                        <div name="winnerDiv"></div>
                        <hr>
                        <h4>큰 마을</h4>
                        <div name="uptownPlayerDiv"></div>
                        <hr>
                        <h4>작은 마을</h4>
                        <div name="downtownPlayerDiv"></div>
                        <hr>
                        <h4>도둑</h4>
                        <div name="thiefPlayerDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openMoneyStatusModal()">
                                재산 보기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="resetGame()">
                                게임 재설정
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/jsp/game/zombie/jspf/touchModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/zombie/jspf/useCureModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/zombie/jspf/moneyStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/zombie/jspf/guideModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/qrLoginModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
