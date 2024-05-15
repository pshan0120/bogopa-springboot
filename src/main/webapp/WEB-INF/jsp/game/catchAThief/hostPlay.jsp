<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/catchAThief/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/catchAThief/constants.js'/>"></script>

    <script>
        const PLAY_NO = ${playNo};
        let playSetting = {};
        let playStatus = {};
        let originalPlayerList = [];
        let playerList = [];
        let uptownOutcastList = [];
        let downtownOutcastList = [];
        let beforeOutcastList = [];

        $(async () => {
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
            uptownOutcastList = [];
            downtownOutcastList = [];
            beforeOutcastList = [];

            console.log('initializationSetting', initializationSetting);

            $("#settingDiv").show();
            $("#roundDiv").hide();
            $("#resultDiv").hide();

            const originalPlayMemberList = await readPlayMemberList(PLAY_NO);
            const clientPlayMemberList = originalPlayMemberList.clientPlayMemberList;
            const hostPlayMember = originalPlayMemberList.hostPlayMember;

            playStatus = {
                round: 0,
                hostMemberId: hostPlayMember.mmbrNo,
                hostMemberName: hostPlayMember.nickNm,
            }

            originalPlayerList = clientPlayMemberList;

            playSetting = initializationSetting.player
                .find(item => originalPlayerList.length === item.numberOfPlayer);
            playSetting = {...playSetting, round: initializationSetting.round, money: initializationSetting.money};

            renderPlayMemberList(originalPlayerList);
        };

        const renderPlayMemberList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            $playerDiv.empty();

            const htmlString = playerList.reduce((prev, next) => {
                return prev +
                    "<div class=\"form-group form-inline\">" +
                    "   <label class=\"form-control-label\">" + next.nickNm + "</label>" +
                    "   <input type=\"text\" class=\"form-control form-control-alternative\" name=\"items\" readonly" +
                    "       data-member-id=\"" + next.mmbrNo + "\">" +
                    "</div>";
            }, "");

            $playerDiv.append(htmlString);
        }

        const readPlayMemberList = playNo => {
            return gfn_callGetApi("/api/game/play/member/list", {playNo})
                .then(data => {
                    // console.log('data', data);
                    return data;
                })
                .catch(response => console.error('error', response));
        }

        const setTownOfPlayer = () => {
            playerList = createPlayerList(originalPlayerList);

            showPlayerTownList(playerList);
        }

        const createThiefOfTown = playerListOfTown => {
            let thiefChosen = false;
            return playerListOfTown
                .sort(() => Math.random() - 0.5)
                .map(player => {
                    if (!thiefChosen) {
                        thiefChosen = true;
                        return {
                            ...player,
                            money: 0,
                            thief: true,
                        };
                    }
                    return {
                        ...player,
                        money: playSetting.money,
                        thief: false,
                    };
                })
                .sort(() => Math.random() - 0.5);
        };

        const createPlayerList = playerList => {
            let playerNumber = 0;

            const playerListOfTown = playerList
                .sort(() => Math.random() - 0.5)
                .map(player => {
                    const fakePlayerName = FAKE_PLAYER_NAME_LIST[playerNumber];

                    playerNumber++;
                    if (playerNumber <= playSetting.uptown) {
                        return {
                            playerName: player.nickNm,
                            fakePlayerName,
                            playerId: player.mmbrNo,
                            hashKey: player.hashKey,
                            playerNumber,
                            town: UPTOWN,
                            outcast: false,
                        };
                    }

                    return {
                        playerName: player.nickNm,
                        fakePlayerName,
                        playerId: player.mmbrNo,
                        hashKey: player.hashKey,
                        playerNumber,
                        town: DOWNTOWN,
                        outcast: false,
                    };
                });

            return [
                ...createThiefOfTown(playerListOfTown.filter(player => player.town.name === UPTOWN.name)),
                ...createThiefOfTown(playerListOfTown.filter(player => player.town.name === DOWNTOWN.name)),
            ]
        }

        const showPlayerTownList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            playerList.forEach(player => {
                console.log('player', player);
                const found = $playerDiv.find("input[name='items']").toArray()
                    .filter(itemsObject => player.playerId == $(itemsObject).data("memberId"));

                $(found).val(player.town.title + (player.thief ? "(도둑)" : ""));

                $(found).removeClass();
                $(found).addClass("form-control form-control-alternative");
            });
        }

        const saveGameStatus = () => {
            const log = {
                playSetting: JSON.stringify(playSetting),
                playStatus: JSON.stringify(playStatus),
                playerList: JSON.stringify(playerList),
                uptownOutcastList: JSON.stringify(uptownOutcastList),
                downtownOutcastList: JSON.stringify(downtownOutcastList),
                beforeOutcastList: JSON.stringify(beforeOutcastList),
            }

            const request = {
                playNo: PLAY_NO,
                log: JSON.stringify(log)
            }

            gfn_callPostApi("/api/game/play/save", request)
                .then(data => {
                    console.log('game status saved !!', data);
                })
                .catch(response => console.error('error', response));
        }

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_NO);
            if (!lastPlayLog) {
                return;
            }

            const lastPlayLogJson = JSON.parse(lastPlayLog);
            console.log('lastPlayLogJson', lastPlayLogJson);

            playSetting = JSON.parse(lastPlayLogJson.playSetting);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);
            playerList = JSON.parse(lastPlayLogJson.playerList);
            uptownOutcastList = JSON.parse(lastPlayLogJson.uptownOutcastList);
            downtownOutcastList = JSON.parse(lastPlayLogJson.downtownOutcastList);
            beforeOutcastList = JSON.parse(lastPlayLogJson.beforeOutcastList);

            console.log('game status loaded !!');
        }

        const readLastPlayLog = playNo => {
            return gfn_callGetApi("/api/game/play/log/last", {playNo})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
                })
                .catch(response => console.error('error', response));
        }

        const beginGame = () => {
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

            if (uptownOutcastList.length === 0
                || downtownOutcastList.length === 0) {
                alert("이번 라운드의 추방자가 선택되지 않았습니다.");
                throw new Error("추방자 미선택 미선택");
            }

            if (!confirm("결과를 계산한 뒤 저장하시겠습니까?")) {
                return;
            }

            steal();
            move();

            uptownOutcastList = [];
            downtownOutcastList = [];
            playerList.forEach(player => player.outcast = false);

            playStatus.round = playStatus.round + 1;
            saveGameStatus();
            renderRound();
        }

        const steal = () => {
            const thiefPlayerList = playerList.filter(player => player.thief);

            thiefPlayerList.forEach(thiefPlayer => {
                if (thiefPlayer.outcast) {
                    return;
                }

                if (thiefPlayer.town.name === UPTOWN.name) {
                    const uptownPlayerList = playerList.filter(player => {
                        return player.town.name === UPTOWN.name
                            && !uptownOutcastList.some(outcast => outcast.playerName === player.playerName)
                    });

                    uptownPlayerList.forEach(player => {
                        player.money = player.money - playSetting.stolenMoney;
                        thiefPlayer.money = thiefPlayer.money + playSetting.stolenMoney;
                    });
                    return;
                }

                const downtownPlayerList = playerList.filter(player => {
                    return player.town.name === DOWNTOWN.name
                        && !downtownOutcastList.some(outcast => outcast.playerName === player.playerName)
                });

                downtownPlayerList.forEach(player => {
                    player.money = player.money - playSetting.stolenMoney;
                    thiefPlayer.money = thiefPlayer.money + playSetting.stolenMoney;
                });
            })

        }

        const move = () => {
            const uptownOutcast = uptownOutcastList.pop();
            playerList.find(player => player.playerName === uptownOutcast.playerName).town = DOWNTOWN;
            beforeOutcastList.push(uptownOutcast);

            const downtownOutcast = downtownOutcastList.pop();
            playerList.find(player => player.playerName === downtownOutcast.playerName).town = UPTOWN;
            beforeOutcastList.push(downtownOutcast);
        }

        const renderRound = () => {
            if (playSetting.round < playStatus.round) {
                endGame();
                return;
            }

            const $roundDiv = $("#roundDiv");
            $roundDiv.show();

            $roundDiv.find("span[name='roundTitle']").text(playStatus.round + " / " + playSetting.round);

            renderTown($roundDiv.find("div[name='uptownDiv']"), UPTOWN);
            renderTown($roundDiv.find("div[name='downtownDiv']"), DOWNTOWN);

            console.log('playerList', playerList);
        }

        const renderTown = ($townDiv, town) => {
            const $townTitle = $townDiv.find("span[name='townTitle']");
            $townTitle.empty().append(town.title);

            const $playerDiv = $townDiv.find("div[name='playerDiv']");
            $playerDiv.empty().append(createPlayerHtml(town));

            const $outcastDiv = $townDiv.find("div[name='outcastDiv']");
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

        const setOutcast = playerName => {
            if (beforeOutcastList.some(outcast => outcast.playerName === playerName)) {
                alert("직전 추방된 사람은 다음 라운드가 지나서 추방될 수 있습니다.");
                return;
            }

            const player = playerList.find(player => player.playerName === playerName);
            player.outcast = true;

            if (player.town.name === UPTOWN.name) {
                const beforeOutcastIndex = beforeOutcastList.findIndex(beforeOutcast => beforeOutcast.town.name === UPTOWN.name);
                beforeOutcastList.splice(beforeOutcastIndex, 1);

                uptownOutcastList.push(player);
                const $roundDiv = $("#roundDiv");
                const $uptownDiv = $roundDiv.find("div[name='uptownDiv']");
                $uptownDiv.find("div[name='playerDiv']").empty();
                $uptownDiv.find("div[name='outcastDiv']").empty().html(player.playerName);
                return;
            }

            const beforeOutcastIndex = beforeOutcastList.findIndex(beforeOutcast => beforeOutcast.town.name === DOWNTOWN.name);
            beforeOutcastList.splice(beforeOutcastIndex, 1);

            downtownOutcastList.push(player);
            const $roundDiv = $("#roundDiv");
            const $downtownDiv = $roundDiv.find("div[name='downtownDiv']");
            $downtownDiv.find("div[name='playerDiv']").empty();
            $downtownDiv.find("div[name='outcastDiv']").empty().html(player.playerName);
        }

        const resetGame = () => {
            if (!confirm("현재까지의 모든 진행 상황을 초기화하고 게임을 처음부터 진행합니다.")) {
                return;
            }

            const request = {
                playNo: PLAY_NO
            }

            gfn_callDeleteApi("/api/game/play/log/all", request)
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
                return "작으 마을 승리!";
            }

            return "도둑 승리!";
        }

        const openTownStatusModal = () => {
            townStatusModal.open();
        }

        const openMoneyStatusModal = () => {
            moneyStatusModal.open(PLAY_NO);
        }

        const openGuideModal = () => {
            guideModal.open();
        }

        const openQrLoginModal = () => {
            qrLoginModal.open(playerList);
        }

        const openQrImage = () => {
            window.open("/qr?url=" + encodeURIComponent(document.URL), "_blank");
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
                            <button type="button" class="btn btn-default" onclick="setTownOfPlayer()">
                                마을 지정
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
                    <div class="card-body" name="townDiv">
                        <div name="uptownDiv">
                            <h4><span name="townTitle"></span> 추방자</h4>
                            <div name="playerDiv"></div>
                            <div name="outcastDiv"></div>
                        </div>
                        <hr>
                        <div name="downtownDiv">
                            <h4><span name="townTitle"></span> 추방자</h4>
                            <div name="playerDiv"></div>
                            <div name="outcastDiv"></div>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-info btn-block" onclick="openTownStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openMoneyStatusModal()">
                                재산 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextRound()">
                                다음 라운드 진행
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openQrImage()">
                                QR 이미지로 공유
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
                            <button type="button" class="btn btn-info btn-block" onclick="openTownStatusModal()">
                                주민 보기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openMoneyStatusModal()">
                                재산 보기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openQrImage()">
                                QR 이미지로 공유
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

<%@ include file="/WEB-INF/jsp/game/catchAThief/jspf/townStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/catchAThief/jspf/moneyStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/catchAThief/jspf/guideModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/qrLoginModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
